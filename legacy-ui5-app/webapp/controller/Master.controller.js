/* global jQuery, sap, console */
// Master controller — Liste der Projekte. Keine BaseController-Hierarchie, weil hat sich keiner getraut zu refactorn.

jQuery.sap.require("com.demo.migration.projects.legacy.model.formatter");

sap.ui.define([
	"sap/ui/core/mvc/Controller",
	"sap/ui/model/Filter",
	"sap/ui/model/FilterOperator"
], function (Controller, Filter, FilterOperator) {
	"use strict";

	return Controller.extend("com.demo.migration.projects.legacy.controller.Master", {

		onInit: function () {
			console.log("[Master] onInit");
			var that = this;

			// einfaches re-binden um count zu aktualisieren wenn das ODataModel die Liste lädt
			var oList = this.byId("projectList");
			oList.attachUpdateFinished(function (oEvent) {
				var iTotal = oEvent.getParameter("total");
				var oCountText = that.byId("countText");
				if (oCountText) {
					oCountText.setText(iTotal + " projects");
				}
			});
		},

		onSearch: function (oEvent) {
			var sQuery = oEvent.getParameter("newValue") || oEvent.getParameter("query") || "";
			console.log("[Master] search '" + sQuery + "'");

			var aFilters = [];
			if (sQuery && sQuery.length > 0) {
				aFilters.push(new sap.ui.model.Filter({
					filters: [
						new sap.ui.model.Filter("ProjectId", sap.ui.model.FilterOperator.Contains, sQuery),
						new sap.ui.model.Filter("Title", sap.ui.model.FilterOperator.Contains, sQuery)
					],
					and: false
				}));
			}

			var oList = this.byId("projectList");
			var oBinding = oList.getBinding("items");
			oBinding.filter(aFilters);
		},

		onSelect: function (oEvent) {
			var oItem = oEvent.getParameter("listItem");
			this._navigateToItem(oItem);
		},

		onItemPress: function (oEvent) {
			// fallback wenn jemand draufklickt aber nicht selektiert (sollte nicht passieren aber sicher ist sicher)
			this._navigateToItem(oEvent.getSource());
		},

		_navigateToItem: function (oItem) {
			if (!oItem) {
				return;
			}
			var oCtx = oItem.getBindingContext();
			if (!oCtx) {
				return;
			}
			// Path ist z.B. /ProjectSet('PRJ-0001'), wir wollen 'PRJ-0001'
			var sPath = oCtx.getPath();
			var sId = decodeURIComponent(sPath.replace(/^\/ProjectSet\('/, "").replace(/'\)$/, ""));
			console.log("[Master] navigate to project " + sId);

			var oRouter = sap.ui.core.UIComponent.getRouterFor(this);
			oRouter.navTo("detail", {
				projectId: sId
			});
		}

	});
});
