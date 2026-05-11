/* global jQuery, sap, window */
// Component.js – legacy 2020-era freestyle UI5 1.84 app.
// Worst practice: hardcoded service URL, manual ODataModel in init, jQuery.sap.require for "shared" formatter.

jQuery.sap.require("com.demo.migration.projects.legacy.model.formatter");

sap.ui.define([
	"sap/ui/core/UIComponent",
	"sap/ui/Device",
	"com/demo/migration/projects/legacy/model/models"
], function (UIComponent, Device, models) {
	"use strict";

	// hardcoded URL — ja wir wissen, sollte in manifest dataSources, aber hat sich nie jemand drum gekümmert
	var SERVICE_URL = "/sap/opu/odata/sap/ZDEMO_MIG_PROJECTS_SRV/";

	return UIComponent.extend("com.demo.migration.projects.legacy.Component", {

		metadata: {
			manifest: "json"
		},

		init: function () {
			// super-call
			UIComponent.prototype.init.apply(this, arguments);

			// device model (manuell, weil immer schon so gemacht)
			this.setModel(models.createDeviceModel(), "device");

			// OData v2 Model — manuell weil dataSources/manifest ist eh zu viel config-magic
			var oModel = new sap.ui.model.odata.v2.ODataModel(SERVICE_URL, {
				defaultBindingMode: sap.ui.model.BindingMode.TwoWay,
				useBatch: false,
				json: true
			});
			oModel.setDeferredGroups(["approve"]);
			this.setModel(oModel);
			console.log("[Component] OData model angelegt für " + SERVICE_URL);

			// router init
			this.getRouter().initialize();
		},

		// kein destroy override – rundet ab dass das ganze halt einfach so ist
		getContentDensityClass: function () {
			if (!this._sContentDensityClass) {
				if (!Device.support.touch) {
					this._sContentDensityClass = "sapUiSizeCompact";
				} else {
					this._sContentDensityClass = "sapUiSizeCozy";
				}
			}
			return this._sContentDensityClass;
		}
	});
});
