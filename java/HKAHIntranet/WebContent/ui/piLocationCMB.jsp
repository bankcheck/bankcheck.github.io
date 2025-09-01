<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String type = request.getParameter("type");
String value = request.getParameter("value");
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
String selectName = request.getParameter("selectName");
String selectClass = request.getParameter("selectClass");
String inputValue = request.getParameter("inputValue");
%>
<select name="<%=selectName %>" class="<%=selectClass%>">			
<%
if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	if (emptyLabel == null) {
		emptyLabel = "";
	}
%><option value=""><%=emptyLabel %></option>
<%
}
ArrayList record = PiReportDB.getPILocationList(type);
ReportableListObject row = null;

String freetext = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		
%><option freetextValue="<%=row.getValue(1).equals(value)?inputValue:"" %>" freetext="<%=row.getValue(2)%>" value="<%=row.getValue(1) %>" <%=row.getValue(1).equals(value)?" selected":"" %>><%=row.getValue(1) %></option>
<%
	}
}
%>
</select>
<span id='freetextSpan'>
	
</span>
<input name="inputSelectName" value="<%=selectName%>" type="hidden"/>
<script>
var selectName = $('input[name=inputSelectName]').val();
$('select[name='+selectName+']').change(function() {
	var freetext = $(this).find(":selected").attr('freetext');
	var freetextValue = ($(this).find(":selected").attr('freetextValue'));
	$('#freetextSpan').html('');
	if(freetext == '1'){
		$('#freetextSpan').append('<input name="'+selectName+'_freetext" type="textfield" value="'+freetextValue+'" style="width:250px;"></input>');
	}else if(freetext == '2'){
			$('#freetextSpan').append('<input name="'+selectName+'_freetext" type="textfield" value="'+freetextValue+'" style="width:250px;"></input>');
			$('#freetextSpan').append('<span></span>');
	}else{
		$('#freetextSpan').html('');
	}
});

$(document).ready(function() {
	$('select[name="<%=selectName%>"]').change();
});
</script>