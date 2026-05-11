import BaseController from "./BaseController";

/**
 * @namespace com.demo.migration.projects.modern.controller
 */
export default class App extends BaseController {
	public onInit(): void {
		this.getView().addStyleClass(this.getOwnerComponent().getContentDensityClass());
	}
}
