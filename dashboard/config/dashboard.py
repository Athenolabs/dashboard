from __future__ import unicode_literals
from frappe import _

def get_data():
	return [
		{
			"label": _("Documents"),
			"icon": "icon-star",
			"items": [
				{
					"type": "doctype",
					"name": "Widget",
					"description": _("Create widget for dashboard."),
				},
				{
					"type": "doctype",
					"name": "Widget Report",
					"description": _("Create report for widget."),
				}
			]
		},
		{
			"label": _("Dashboard"),
			"icon": "icon-list",
			"items": [
				{
					"type": "page",
					"name": "dashboard",
					"label": _("Dashboard"),
					"icon": "icon-bar-chart",
				}
			]
		},
	]
