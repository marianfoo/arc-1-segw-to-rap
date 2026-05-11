/* global jQuery, sap, console */
sap.ui.define([
	"sap/ui/core/mvc/Controller"
], function (Controller) {
	"use strict";

	return Controller.extend("com.demo.migration.projects.legacy.controller.App", {

		onInit: function () {
			console.log("[App] onInit");
			var oOwner = this.getOwnerComponent();
			// keine Density-Klasse vergessen sonst sieht's auf Desktop scheisse aus
			this.getView().addStyleClass(oOwner.getContentDensityClass());
		}

	});
});
