frappe.require('assets/frappe/js/lib/jscolor/jscolor.js');

frappe.ui.form.on("Widget", "onload_post_render", function(frm) {
	$(frm.fields_dict["background_color"].input).addClass('color {required:false,hash:true}');
	jscolor.bind();
});

