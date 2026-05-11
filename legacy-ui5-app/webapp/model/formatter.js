/* global jQuery, window */
// formatter.js – legacy 2020-era — kein sap.ui.define, sondern globaler Namensraum + jQuery.sap.declare.
// Fünf Jahre später benutzen wir das immer noch in jeder View, weil "läuft ja". Quatsch, aber typisch.

jQuery.sap.declare("com.demo.migration.projects.legacy.model.formatter");

window.com = window.com || {};
window.com.demo = window.com.demo || {};
window.com.demo.migration = window.com.demo.migration || {};
window.com.demo.migration.projects = window.com.demo.migration.projects || {};
window.com.demo.migration.projects.legacy = window.com.demo.migration.projects.legacy || {};
window.com.demo.migration.projects.legacy.model = window.com.demo.migration.projects.legacy.model || {};

window.com.demo.migration.projects.legacy.model.formatter = {

	// Status code -> Text via i18n. Wird in jeder View per "global"-Path-Pattern aufgerufen:
	//   formatter:".formatter.statusText"  // (über controller-relative Pfade)
	// Aber wer's eilig hat, schreibt halt direkt:
	//   text="{ path: 'Status', formatter: 'window.com.demo.migration.projects.legacy.model.formatter.statusText' }"
	statusText: function (sStatus) {
		switch (sStatus) {
			case "A":
				return "Approved";
			case "D":
				return "Draft";
			case "X":
				return "Cancelled";
			default:
				return sStatus || "";
		}
	},

	statusState: function (sStatus) {
		// sap.ui.core.ValueState — Success / Warning / Error / None
		if (sStatus === "A") {
			return "Success";
		}
		if (sStatus === "X") {
			return "Error";
		}
		if (sStatus === "D") {
			return "Warning";
		}
		return "None";
	},

	taskStatusText: function (sStatus) {
		if (sStatus === "O") { return "Open"; }
		if (sStatus === "P") { return "In Progress"; }
		if (sStatus === "C") { return "Completed"; }
		return sStatus || "";
	},

	taskStatusState: function (sStatus) {
		if (sStatus === "C") { return "Success"; }
		if (sStatus === "P") { return "Warning"; }
		if (sStatus === "O") { return "None"; }
		return "None";
	},

	priorityText: function (sPrio) {
		if (sPrio === "1" || sPrio === 1) { return "Low"; }
		if (sPrio === "2" || sPrio === 2) { return "Medium"; }
		if (sPrio === "3" || sPrio === 3) { return "High"; }
		return sPrio || "";
	},

	priorityState: function (sPrio) {
		if (sPrio === "3" || sPrio === 3) { return "Error"; }
		if (sPrio === "2" || sPrio === 2) { return "Warning"; }
		return "None";
	},

	// klassische Datum-Formatter — instanziert pro Aufruf, weil egal
	dateShort: function (oDate) {
		if (!oDate) { return ""; }
		var oFmt = sap.ui.core.format.DateFormat.getDateInstance({ style: "medium" });
		return oFmt.format(oDate);
	},

	hoursDecimal: function (sHours) {
		if (sHours === null || typeof sHours === "undefined" || sHours === "") {
			return "";
		}
		// sloppy parse — funktioniert weil OData v2 schickt string
		var fHours = parseFloat(sHours);
		if (isNaN(fHours)) { return sHours; }
		return fHours.toFixed(2) + " h";
	}

};

// Alias für controller-relative Aufrufe via "this.formatter.xxx"
sap.ui.define([], function () {
	"use strict";
	return window.com.demo.migration.projects.legacy.model.formatter;
});
