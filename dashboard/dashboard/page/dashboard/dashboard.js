import_css_and_js = function() {
	//frappe.require("assets/dashboard/images/icon-sprite.png");
	frappe.require("assets/dashboard/css/sDashboard.css");

	//frappe.require("assets/dashboard/js/jquery.min.js");
	frappe.require("assets/dashboard/js/jquery-1.8.2.js");
	frappe.require("assets/dashboard/js/jquery-ui.js");
	//frappe.require("assets/dashboard/js/bootstrap.min.js");
	//frappe.require("assets/dashboard/js/jquery.gritter.js");
	frappe.require("assets/dashboard/js/jquery.dataTables.min.js");
	frappe.require("assets/dashboard/js/flotr2.js");
	frappe.require("assets/dashboard/js/jquery-sDashboard.js");
}


frappe.pages['dashboard'].on_page_load = function(wrapper) {
	var page = frappe.ui.make_app_page({
		parent: wrapper,
		title: 'Dashboard',
		single_column: true
	});
 	$(wrapper).html('<ul id="dashboard"></ul>');
	import_css_and_js();
	frappe.breadcrumbs.add("Dashboard");
	wrapper.dashboard = new frappe.Dashboard(wrapper);
};
frappe.pages['dashboard'].refresh = function(wrapper) {
	//wrapper.dashboard.refresh();
};

frappe.Dashboard = Class.extend({
	init: function(wrapper) {
		console.log("init called...");
		this.wrapper = wrapper;
		//this.body = $(this.wrapper).find(".user-settings");
		this.filters = {};
		//this.add_filters();
		this.refresh();
		
	},
	set_filter: function(key, value) {
		this.filters[key].$input.val(value);
	},
	get_user: function() {
		var user = this.filters.user.$input.val();
		return user== __("Select User") + "..." ? null : user;
	},

	add_filters: function() {
		var me = this;
		console.log("adding filter....");
		// frappe.core.page.user_permissions.js
/*
		{fieldtype:"Select", label: __("Company"), link:"Company", fieldname: "company",
			default_value: __("Select Company...")},
*/
		this.filters.dashboard = this.wrapper.page.add_field({
				fieldname: "user_permission",
				label: __("Name"),
				fieldtype: "Link",
				options: "[Select]"
		});


	},

//});

//$.extend(dashboard, {
	refresh: function(wrapper) {
		this.wrapper = $(wrapper);
		this.render();
	},
	render: function() {
		var me = this;
		var fiscal_year = '2016';
		this.addWidget();
	},
	addWidget: function() {
		var me = this;
		frappe.call({
			module:"dashboard.dashboard",
			page:"dashboard",
			method: "get_widget_name",
		    	type: "GET",
		    	callback: function(r){
				if(!r.exc && r.message){
					$.each(r.message, function(i, data){
						me.getWidget(data);
					});
				}
			}
		});

	},
	getWidget: function(widget) {
		var me = this;
		frappe.call({
			module:"dashboard.dashboard",
			page:"dashboard",
			method: "get_widget",
		    	type: "POST",
			args:{widget: JSON.stringify(widget)},
			dataType: 'json',
		    	callback: function(r){
				if(!r.exc && r.message){
					me.renderWidget(r.message);
				}
			}
		});

	},
	renderWidget: function(widget){
		var dashboardJSON = this.getDashboardJSON(widget);
		$("#dashboard").sDashboard({
					dashboardData : dashboardJSON
		});

	},
	getDashboardJSON: function(widget){
		if (widget.type === 'table' || widget.type === 'tab'){
			return this.getTableWidget(widget);
		}else if (widget.type === 'chart'){
			return this.getPieChartWidget(widget);
		}

	},
	getTableWidget: function(widget){
		var me = this;
		this.updateColumns(widget);
		var tableWidgetData = {
					"aaData" : widget.data,
					"sDom": 'rtip',
					"aoColumns" : widget.columns,
					"iDisplayLength": 10,
					"bPaginate": true,
					"aaSorting": [],
					"bAutoWidth": true
				};
		var dashboardJSON = [{
					widgetTitle : widget.title,
					widgetId : widget.name,
					widgetType : widget.type,
					enableRefresh : false,
					widgetContent : tableWidgetData,
					widgetHeight : widget.height,
					widgetWidth : widget.width,
					widgetBackgroundColor: widget.background_color
				}];
		return dashboardJSON;

	},
	getPieChartWidget: function(widget){
		var me = this;
		var pieChartOptions = {
				HtmlText : false,
				grid : {
					verticalLines : false,
					horizontalLines : false
				},
				xaxis : {
					showLabels : false
				},
				yaxis : {
					showLabels : false
				},
				pie : {
					show : true,
					explode : 6
				},
				mouse : {
					track : true
				},
				legend : {
					position : "se",
					backgroundColor : "#D2E8FF"
				}
			};
		var chartWidgetData = {
					data : widget.data,
					options : pieChartOptions
				};
		var dashboardJSON = [{
					widgetTitle : widget.title,
					widgetId : widget.name,
					widgetType : widget.type,
					widgetContent : chartWidgetData,
					widgetHeight : widget.height,
					widgetWidth : widget.width,
					widgetBackgroundColor: widget.background_color

				}];
		return dashboardJSON;
	},
	updateColumns: function(widget){

		if (widget.type === 'table'){
			var aoColumns = [];
			$.each(widget.columns, function (idx, column) {
			    var obj = { "sTitle": column };
			    aoColumns[idx] = obj;
			});
			widget.columns = aoColumns;
		} else if (widget.type === 'tab'){
			$.each(widget.data, function (idx, tab) {
				var aoColumns = [];
				$.each(tab.columns, function (cidx, column) {
					var obj = { "sTitle": column };
					aoColumns[cidx] = obj;
				});
				tab.columns = aoColumns;
			});
		}
	},


});


