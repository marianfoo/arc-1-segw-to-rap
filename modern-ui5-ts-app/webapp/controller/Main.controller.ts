import BaseController from "./BaseController";
import Filter from "sap/ui/model/Filter";
import FilterOperator from "sap/ui/model/FilterOperator";
import List from "sap/m/List";
import Text from "sap/m/Text";
import { ListBase$SelectionChangeEvent, ListBase$UpdateFinishedEvent } from "sap/m/ListBase";
import ListItemBase from "sap/m/ListItemBase";
import { SearchField$LiveChangeEvent } from "sap/m/SearchField";
import { ListItemBase$PressEvent } from "sap/m/ListItemBase";
import Context from "sap/ui/model/odata/v4/Context";
import ODataListBinding from "sap/ui/model/odata/v4/ODataListBinding";

/**
 * @namespace com.demo.migration.projects.modern.controller
 */
export default class Main extends BaseController {
	public onInit(): void {
		const list = this.byId("projectList") as List;
		list.attachUpdateFinished((event: ListBase$UpdateFinishedEvent) => {
			void this.refreshProjectCount(event);
		});
		this.applyListFilters(undefined);
	}

	private async refreshProjectCount(event: ListBase$UpdateFinishedEvent): Promise<void> {
		const total = event.getParameter("total");
		const bundle = await this.getResourceBundle();
		const countText = this.byId("countText") as Text;
		countText.setText(bundle.getText("mainCount", [String(total)]));
	}

	public onSearch(event: SearchField$LiveChangeEvent): void {
		const query = (event.getParameter("newValue") || "").trim();
		this.applyListFilters(query.length > 0 ? query : undefined);
	}

	private applyListFilters(query?: string): void {
		const list = this.byId("projectList") as List;
		const binding = list.getBinding("items") as ODataListBinding | undefined;
		if (!binding) {
			return;
		}

		const activeFilter = new Filter("IsActiveEntity", FilterOperator.EQ, true);
		if (!query) {
			binding.filter(activeFilter);
			return;
		}

		const textSearch = new Filter({
			filters: [
				new Filter("ProjectId", FilterOperator.Contains, query),
				new Filter("Title", FilterOperator.Contains, query)
			],
			and: false
		});
		binding.filter(new Filter({ filters: [activeFilter, textSearch], and: true }));
	}

	public onSelect(event: ListBase$SelectionChangeEvent): void {
		const item = event.getParameter("listItem");
		if (!item) {
			return;
		}
		this.navigateToProjectItem(item);
	}

	public onItemPress(event: ListItemBase$PressEvent): void {
		const item = event.getSource();
		this.navigateToProjectItem(item);
	}

	private navigateToProjectItem(item: ListItemBase): void {
		if (!item) {
			return;
		}
		const ctx = item.getBindingContext() as Context | null;
		if (!ctx) {
			return;
		}
		const projectId = ctx.getProperty("ProjectId") as string;
		this.getRouter().navTo("detail", {
			projectId
		});
	}
}
