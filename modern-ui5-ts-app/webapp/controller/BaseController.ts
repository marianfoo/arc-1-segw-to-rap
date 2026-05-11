import Controller from "sap/ui/core/mvc/Controller";
import UIComponent from "sap/ui/core/UIComponent";
import AppComponent from "../Component";
import Model from "sap/ui/model/Model";
import ResourceModel from "sap/ui/model/resource/ResourceModel";
import ResourceBundle from "sap/base/i18n/ResourceBundle";
import FRouter from "sap/f/routing/Router";
import History from "sap/ui/core/routing/History";

/**
 * @namespace com.demo.migration.projects.modern.controller
 */
export default abstract class BaseController extends Controller {
	/**
	 * Convenience method for accessing the component of the controller's view.
	 * @returns The component of the controller's view
	 */
	public getOwnerComponent(): AppComponent {
		return super.getOwnerComponent() as AppComponent;
	}

	/**
	 * Convenience method to get the components' router instance.
	 * @returns The router instance
	 */
	public getRouter(): FRouter {
		return UIComponent.getRouterFor(this) as FRouter;
	}

	/**
	 * Convenience method for getting the i18n resource bundle of the component.
	 * @returns The i18n resource bundle of the component
	 */
	public getResourceBundle(): Promise<ResourceBundle> {
		const i18nModel = this.getOwnerComponent().getModel("i18n") as ResourceModel;
		return i18nModel.getResourceBundle() as Promise<ResourceBundle>;
	}

	/**
	 * Convenience method for getting the view model by name in every controller of the application.
	 * @param [name] The model name
	 * @returns The model instance
	 */
	public getModel(name?: string): Model {
		return this.getView().getModel(name);
	}

	/**
	 * Convenience method for setting the view model in every controller of the application.
	 * @param model The model instance
	 * @param [name] The model name
	 * @returns The current base controller instance
	 */
	public setModel(model: Model, name?: string): BaseController {
		this.getView().setModel(model, name);
		return this;
	}

	/**
	 * Convenience method for triggering the navigation to a specific target.
	 * @param name Target name
	 * @param [parameters] Navigation parameters
	 * @param [replace] Defines if the hash should be replaced (no browser history entry) or set (browser history entry)
	 */
	public navTo(name: string, parameters?: object, replace?: boolean): void {
		this.getRouter().navTo(name, parameters, undefined, replace);
	}

	/**
	 * Convenience event handler for navigating back.
	 * When there is a history entry go one step back in the browser history.
	 * Otherwise navigate to the main route.
	 */
	public onNavBack(): void {
		const previousHash = History.getInstance().getPreviousHash();
		if (previousHash !== undefined) {
			window.history.go(-1);
		} else {
			this.getRouter().navTo("main", {}, undefined, true);
		}
	}
}
