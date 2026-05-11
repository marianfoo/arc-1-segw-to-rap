/* global window, sap */
sap.ui.define([
	"sap/ui/core/ComponentContainer"
], function (ComponentContainer) {
	"use strict";

	new ComponentContainer({
		name: "com.demo.migration.projects.legacy",
		settings: { id: "projectMgr" },
		async: false,
		height: "100%"
	}).placeAt("content");
});
