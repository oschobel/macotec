
function getSavedData(){
    $.get('/app/Settings/get_data', { });
}

function setData(company, phone, email){
	setFieldValue("company",company);
	setFieldValue("phone",phone);
	setFieldValue("email",email);
}

function alertUser(){
	
}
