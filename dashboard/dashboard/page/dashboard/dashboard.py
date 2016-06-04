# Copyright (c) 2013, Frappe Technologies Pvt. Ltd. and contributors
# For license information, please see license.txt

from __future__ import unicode_literals
import frappe
import json
from frappe import _, _dict
from frappe.utils import (flt, cstr, getdate, get_first_day, get_last_day,
	add_months, add_days, formatdate)
from widget_data import get_widget_data

@frappe.whitelist()
def get_widget(widget):
	widget = json.loads(widget)
	return get_widget_data(widget)


@frappe.whitelist()
def get_widget_name():
	return frappe.db.sql("""
		select name, lower(type) as type, chart_type, title, width, height, background_color
		from `tabWidget`
		where disabled = 0
		order by type, name""", as_dict=1)




	
