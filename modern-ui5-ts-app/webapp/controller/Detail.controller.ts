import BaseController from "./BaseController";
import JSONModel from "sap/ui/model/json/JSONModel";
import Table from "sap/m/Table";
import Text from "sap/m/Text";
import ODataModel from "sap/ui/model/odata/v4/ODataModel";
import Context from "sap/ui/model/odata/v4/Context";
import MessageToast from "sap/m/MessageToast";
import MessageBox from "sap/m/MessageBox";
import IconTabBar from "sap/m/IconTabBar";
import IconTabFilter from "sap/m/IconTabFilter";
import ColumnListItem from "sap/m/ColumnListItem";
import { Route$PatternMatchedEvent } from "sap/ui/core/routing/Route";
import { ListBase$SelectionChangeEvent } from "sap/m/ListBase";
import ListItemBase from "sap/m/ListItemBase";
import { ListItemBase$PressEvent } from "sap/m/ListItemBase";
import ODataListBinding from "sap/ui/model/odata/v4/ODataListBinding";
import formatter from "../model/formatter";

/** Bound approve action FQN — see skills/migrate-segw-to-rap.md §7d (curl example). */
const APPROVE_PROJECT = "com.sap.gateway.srvd.zui_dm_projects.v0001.approve_project";

/**
 * @namespace com.demo.migration.projects.modern.controller
 */
export default class Detail extends BaseController {
	/**
	 * Phone header back: always return to the main list (legacy parity; BaseController uses browser history).
	 */
	public override onNavBack(): void {
		this.getRouter().navTo("main", {}, undefined, true);
	}

	public onInit(): void {
		this.getView().setModel(new JSONModel({ value: 0 }), "tasksCount");
		this.getView().setModel(new JSONModel({ value: 0 }), "entriesCount");

		this.getRouter().getRoute("detail").attachPatternMatched(this.onDetailRouteMatched);

		const tasksTable = this.byId("tasksTable") as Table;
		tasksTable.attachUpdateFinished(this.onTasksOrEntriesUpdated);

		const entriesTable = this.byId("entriesTable") as Table;
		entriesTable.attachUpdateFinished(this.onTasksOrEntriesUpdated);
	}

	public onExit(): void {
		this.getRouter().getRoute("detail").detachPatternMatched(this.onDetailRouteMatched);
		const tasksTable = this.byId("tasksTable") as Table;
		tasksTable.detachUpdateFinished(this.onTasksOrEntriesUpdated);
		const entriesTable = this.byId("entriesTable") as Table;
		entriesTable.detachUpdateFinished(this.onTasksOrEntriesUpdated);
	}

	private readonly onTasksOrEntriesUpdated = (): void => {
		this.refreshCounters();
	};

	private readonly onDetailRouteMatched = (event: Route$PatternMatchedEvent): void => {
		const args = event.getParameter("arguments") as { projectId: string };
		const projectId = decodeURIComponent(args.projectId);
		const path = `/Project(ProjectId='${this.escapeODataString(projectId)}',IsActiveEntity=true)`;

		this.getView().bindElement({
			path,
			parameters: {
				$expand: "_Tasks"
			},
			events: {
				dataReceived: () => {
					this.refreshCounters();
				}
			}
		});

		this.clearEntriesTableBinding();

		this.refreshCounters();
	};

	/** OData navigation `_TimeEntries` exists on Task, not Project — declarative bindings would corrupt path against the project context. */
	private clearEntriesTableBinding(): void {
		const entriesTable = this.byId("entriesTable") as Table;
		// Runtime API matches ListBase; generated typings omit overloads for clear / suppress flags.
		void (entriesTable as unknown as { unbindItems(suppressInvalidate?: boolean): void }).unbindItems(true);
		void (entriesTable as unknown as { setBindingContext(ctx?: Context | null): void }).setBindingContext(undefined);
	}

	private buildTimeEntryRowTemplate(): ColumnListItem {
		const entryIdText = new Text({ wrapping: false });
		entryIdText.bindProperty("text", "EntryId");
		const taskIdText = new Text({ wrapping: false });
		taskIdText.bindProperty("text", "TaskId");
		const workDateText = new Text({ wrapping: false });
		workDateText.bindProperty("text", {
			path: "WorkDate",
			formatter(v: string | Date | undefined | null): string {
				return formatter.dateShort(v ?? undefined);
			}
		});
		const workHoursText = new Text({ wrapping: false });
		workHoursText.bindProperty("text", {
			path: "WorkHours",
			formatter(v: string | number | null | undefined): string {
				return formatter.hoursDecimal(v);
			}
		});
		const descText = new Text({ wrapping: false });
		descText.bindProperty("text", "Description");
		const userText = new Text({ wrapping: false });
		userText.bindProperty("text", "Username");
		return new ColumnListItem({
			cells: [entryIdText, taskIdText, workDateText, workHoursText, descText, userText]
		});
	}

	private escapeODataString(value: string): string {
		return value.replace(/'/g, "''");
	}

	private refreshCounters(): void {
		const view = this.getView();
		const tasksModel = view.getModel("tasksCount") as JSONModel;
		const tasksTable = this.byId("tasksTable") as Table;
		const tasksBinding = tasksTable.getBinding("items") as ODataListBinding | undefined;
		tasksModel.setProperty("/value", tasksBinding ? tasksBinding.getLength() : 0);

		const entriesModel = view.getModel("entriesCount") as JSONModel;
		const entriesTable = this.byId("entriesTable") as Table;
		const entriesBinding = entriesTable.getBinding("items") as ODataListBinding | undefined;
		entriesModel.setProperty("/value", entriesBinding ? entriesBinding.getLength() : 0);
	}

	public onTaskSelect(event: ListBase$SelectionChangeEvent): void {
		const item = event.getParameter("listItem") as ColumnListItem;
		if (!item) {
			return;
		}
		this.showTimeEntriesForTask(item);
	}

	public onTaskPress(event: ListItemBase$PressEvent): void {
		this.showTimeEntriesForTask(event.getSource());
	}

	private showTimeEntriesForTask(item: ListItemBase): void {
		const ctx = item.getBindingContext() as Context | null;
		if (!ctx) {
			return;
		}
		const entriesTable = this.byId("entriesTable") as Table;

		this.clearEntriesTableBinding();
		entriesTable.setBindingContext(ctx);
		entriesTable.bindItems({
			path: "_TimeEntries",
			parameters: { $filter: "IsActiveEntity eq true" },
			templateShareable: false,
			template: this.buildTimeEntryRowTemplate()
		});

		const iconTabBar = this.byId("iconTabBar") as IconTabBar;
		const tabEntries = this.byId("tabEntries") as IconTabFilter;
		iconTabBar.setSelectedKey(tabEntries.getId());
		this.refreshCounters();
	}

	public async onApprove(): Promise<void> {
		const ctx = this.getView().getBindingContext() as Context | undefined;
		if (!ctx) {
			return;
		}
		const model = ctx.getModel() as ODataModel;
		try {
			const operation = model.bindContext(`${APPROVE_PROJECT}()`, ctx);
			await operation.invoke("$auto");

			const projectId = ctx.getProperty("ProjectId") as string;
			MessageToast.show(`Project ${projectId} approved.`);
			ctx.refresh();
			this.refreshCounters();
		} catch (error: unknown) {
			let msg = "Unknown error";
			if (error instanceof Error) {
				msg = error.message;
			} else if (typeof error === "string") {
				msg = error;
			}
			MessageBox.error(`Could not approve: ${msg}`);
		}
	}
}
