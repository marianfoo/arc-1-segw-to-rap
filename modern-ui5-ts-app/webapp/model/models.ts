import JSONModel from "sap/ui/model/json/JSONModel";
import BindingMode from "sap/ui/model/BindingMode";
import Device from "sap/ui/Device";

/**
 * @namespace com.demo.migration.projects.modern.model
 */
export default {
	createDeviceModel(): JSONModel {
		const model = new JSONModel(Device);
		model.setDefaultBindingMode(BindingMode.OneWay);
		return model;
	}
};
