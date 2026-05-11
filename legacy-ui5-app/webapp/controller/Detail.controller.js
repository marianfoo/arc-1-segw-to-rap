/* global jQuery, sap, console */
// Detail controller — Project header + Tasks/Time Entries Tabs + Approve.
// Worst-practice 2020-Mix: function-import URL manuell zusammengestrickt mit jQuery.ajax weil
// damals "schneller" als ODataModel.callFunction durchzulesen.

jQuery.sap.require("com.demo.migration.projects.legacy.model.formatter");
jQuery.sap.require("sap.m.MessageToast");
jQuery.sap.require("sap.m.MessageBox");

sap.ui.define([
	"sap/ui/core/mvc/Controller",
	"sap/ui/model/json/JSONModel"
], function (Controller, JSONModel) {
	"use strict";

	return Controller.extend("com.demo.migration.projects.legacy.controller.Detail", {

		onInit: function () {
			console.log("[Detail] onInit");

			// JSON-Model für Tab-Counter — wird aus dem ODataModel manuell geladen
			this.getView().setModel(new JSONModel({ value: 0 }), "tasksCount");
			this.getView().setModel(new JSONModel({ value: 0 }), "entriesCount");

			// view-eigenes JSON-Model für TimeEntries-Path (wird beim Task-Klick gesetzt)
			this.getView().setModel(new JSONModel({ timeEntriesPath: undefined }), "view");

			var oRouter = sap.ui.core.UIComponent.getRouterFor(this);
			oRouter.getRoute("detail").attachMatched(this._onDetailMatched, this);
		},

		_onDetailMatched: function (oEvent) {
			var sProjectId = oEvent.getParameter("arguments").projectId;
			this._sProjectId = sProjectId;
			console.log("[Detail] route matched for project " + sProjectId);

			var sPath = "/ProjectSet('" + encodeURIComponent(sProjectId) + "')";
			var that = this;

			this.getView().bindElement({
				path: sPath,
				parameters: {
					expand: "Tasks"
				},
				events: {
					dataReceived: function (oData) {
						that._refreshCounters();
					},
					dataRequested: function () {
						console.log("[Detail] dataRequested " + sPath);
					}
				}
			});

			// counter erst mal grob initialisieren bis dataReceived kommt
			this._refreshCounters();
		},

		_refreshCounters: function () {
			var oView = this.getView();
			var oCtx  = oView.getBindingContext();

			var iTasks = 0;
			if (oCtx) {
				var oObj = oCtx.getObject();
				if (oObj && oObj.Tasks && oObj.Tasks.results) {
					iTasks = oObj.Tasks.results.length;
				}
			}
			oView.getModel("tasksCount").setProperty("/value", iTasks);

			// time entries — nur wenn ein Task angeklickt ist
			var oEntriesTab = this.byId("entriesTable");
			if (oEntriesTab) {
				var oBinding = oEntriesTab.getBinding("items");
				if (oBinding) {
					oView.getModel("entriesCount").setProperty("/value", oBinding.getLength());
				} else {
					oView.getModel("entriesCount").setProperty("/value", 0);
				}
			}
		},

		onTaskSelect: function (oEvent) {
			var oItem = oEvent.getParameter("listItem");
			if (!oItem) { return; }
			this._showTimeEntriesForTask(oItem);
		},

		onTaskPress: function (oEvent) {
			this._showTimeEntriesForTask(oEvent.getSource());
		},

		_showTimeEntriesForTask: function (oItem) {
			var oCtx = oItem.getBindingContext();
			if (!oCtx) { return; }
			var sTaskPath = oCtx.getPath() + "/TimeEntries";
			console.log("[Detail] load time entries from " + sTaskPath);
			this.getView().getModel("view").setProperty("/timeEntriesPath", sTaskPath);

			// gleich auf den richtigen Tab springen damit man's sieht
			this.byId("iconTabBar").setSelectedKey(this.byId("tabEntries").sId);

			// counter nach kurzem delay aktualisieren — total hacky aber funktioniert
			var that = this;
			setTimeout(function () {
				that._refreshCounters();
			}, 500);
		},

		onApprove: function () {
			var that = this;
			var sProjectId = this._sProjectId;
			console.log("[Detail] approve " + sProjectId);

			var oModel = this.getOwnerComponent().getModel();

			oModel.callFunction("/ApproveProject", {
				method: "POST",
				urlParameters: { ProjectId: sProjectId },
				success: function (oData) {
					console.log("[Detail] approve success", oData);
					sap.m.MessageToast.show("Project " + sProjectId + " approved.");
					// rebind damit Status-Update sichtbar wird
					that.getView().getElementBinding().refresh(true);
				},
				error: function (oError) {
					console.error("[Detail] approve failed", oError);
					var sMsg = oError && oError.message ? oError.message : "Unknown error";
					sap.m.MessageBox.error("Could not approve: " + sMsg);
				}
			});
		},

		onNavBack: function () {
			var oRouter = sap.ui.core.UIComponent.getRouterFor(this);
			oRouter.navTo("master");
		}

	});
});
