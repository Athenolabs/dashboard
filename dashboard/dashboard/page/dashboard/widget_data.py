# Copyright (c) 2013, Frappe Technologies Pvt. Ltd. and contributors
# For license information, please see license.txt

from __future__ import unicode_literals
import frappe
from frappe import _, _dict
from frappe.utils import (flt, cstr, getdate, get_first_day, get_last_day,
	add_months, add_days, formatdate)
from collections import defaultdict

def get_widget_data(widget, args=None):
	if "table" in widget["type"]:
		return get_table_widget_data(widget)
	elif "tab" in widget["type"]:
		return get_tab_widget_data(widget)
	elif "chart" in widget["type"]:
		return get_chart_widget_data(widget)


def get_table_widget_data(widget, args=None):
	conditions = get_conditions(args)
	report = get_table_report(widget["name"])
	query = get_report_query(report)
	widget_data = get_data(query, conditions)
	prepare_data_for_widget(widget_data, widget)
	return widget

def get_tab_widget_data(widget, args=None):
	widget_data = {"data":[], "columns":[]}
	conditions = get_conditions(args)
	tabs = get_tabs(widget["name"])
	for tab in tabs:
		tab_data = {"id": tab["name"], "title": tab["title"], "data": [], "columns": []}
		query = get_report_query(tab["report"])
		result = get_data(query, conditions)
		for data in result["data"]:
			tab_data["data"].append(data)

		tab_data["columns"].extend(result["columns"])
		widget_data["data"].append(tab_data)		
	prepare_data_for_widget(widget_data, widget)
	return widget

def get_chart_widget_data(widget, args=None):
	conditions = get_conditions(args)
	report = get_table_report(widget["name"])
	query = get_report_query(report)
	widget_data = get_chart_data(query, conditions)
	prepare_data_for_widget(widget_data, widget)
	return widget

def get_report_query(report):
	return frappe.db.sql("""
		select `query`
		from `tabWidget Report` 
		where name=%s""", report, as_list=1)[0][0]


def get_data(query, conditions):
	data = [list(t) for t in frappe.db.sql(query)]
	columns = [c[0] for c in frappe.db.get_description()]
	return {
		"data": data,
		"columns": columns
	}

def get_chart_data(query, conditions):
	data = frappe.db.sql(query, as_dict=1)
	data = sum_dict_value_by_key(data, 'label', 'data') 	
	columns = [c[0] for c in frappe.db.get_description()]
	return {
		"data": data,
		"columns": columns
	}

def sum_dict_value_by_key(data, key_field, value_field):
	dd = defaultdict(int)
    	for d in data:
        	dd[d[key_field]] += flt(d[value_field])
    	return [{key_field: k, value_field: [[0,v]]} for k, v in dd.items()]
	

def get_conditions(args):
	pass

def get_table_report(widget_name):
	return frappe.db.sql("""
		select report
		from `tabWidget` 
		where name=%s""", widget_name, as_list=1)[0][0]


def get_tabs(widget_name):
	return frappe.db.sql("""
		select name, tab_name as title, report
		from `tabWidget Tab` 
		where parent=%s""", widget_name, as_dict=1)


def prepare_data_for_widget(data, widget):
	widget.setdefault("data", data["data"])
	widget.setdefault("columns", data["columns"])

