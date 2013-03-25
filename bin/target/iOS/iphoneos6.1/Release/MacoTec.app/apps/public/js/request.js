
function setFieldValue(field, value) {
  document.getElementById(field).value=value;
}
 
 
function popupDateTimeAJPicker(flag, title, field_key) {
  $.get('/app/Request/popup', { flag: flag, title: title, field_key: field_key });
  return false;
}

function get_catalog(){
	$.get('<%= url_for(:model => :Product, :action => :get_catalog_data) %>',{ });
}