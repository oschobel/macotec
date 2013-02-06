
function setFieldValue(field, value) {
  document.getElementById(field).value=value;
}
 
function setFieldValue(field, value) {
  document.getElementById(field).value=value;
}
 
function popupDateTimeAJPicker(flag, title, field_key) {
  $.get('/app/Request/popup', { flag: flag, title: title, field_key: field_key });
  return false;
}