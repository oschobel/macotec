function helloWorld() {}

$(document).ready(function () {
	alert("loaded submit.erb...");
  	showLoadingIndicator();
});

function showLoadingIndicator(){
	setTimeout(function(){
			$('#loadingPlaceholder').hide();
			<% if @params["body"] == "SUCCESS" %>
			successfull();
			<% elsif @params["body"] == "FAILED" %>
			<%= puts "### FAILED ###" %>
			not_successfull();
			<% else %>
				wait();
			<% end %>
		},10000);
}
function successfull(){
  $('#successfull').show();
}

function not_successfull(){
  $('#not_successfull').show();
}

function wait(){
	alert("WAIT");
	<%= puts "################## WAIT" %>
}

function popupDateTimePicker(){
	alert("hase");
}