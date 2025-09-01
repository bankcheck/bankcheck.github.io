<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
String doccode = request.getParameter("doccode");
String selectFrom = request.getParameter("selectFrom");
String type = request.getParameter("type");
String value = request.getParameter("value");
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));
String selectName = request.getParameter("selectName");
String selectClass = request.getParameter("selectClass");
String inputValue = request.getParameter("inputValue");
%>

<select name="<%=selectName %>" class="<%=selectClass%>">	


<option value="">--Select Doctor--</option>		
<%--							
<option value="Other" freetextValue="<%=inputValue%>">--Others, Please Specify--</option>
--%>
<%
ArrayList<ReportableListObject> record = UtilDBWeb.getFunctionResults("HAT_CMB_DOCTOR", new String[] { selectFrom });
ReportableListObject row = null;
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		%><option freetextValue="<%=inputValue%>" value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(doccode)?" selected":"" %>><%=row.getValue(1) %> <%=row.getValue(2) %> (<%=row.getValue(0) %>)</option><%
	}
}
%>
</select>
<span id='freetextDocCodeSpan'></span>
<%--
<input name="otherDocCode" value="<%=selectName%>" type="hidden"/>
--%>
<script>

var selectNameDocCode = $('input[name=otherDocCode]').val();

$('select[name='+selectNameDocCode+']').change(function() {
	
	var freetext = $(this).val();	
	var freetextValue = $(this).find(":selected").attr('freetextValue');
	//alert('selectName='+selectName+', freetextValue='+freetextValue);
	//alert('2')
	$('#freetextDocCodeSpan').html('');
	//alert('freetext ' + freetext);
	if(freetext == 'Other'){
		//alert($('#freetextDocCodeSpan').name);
		$('#freetextDocCodeSpan').append('<input name="'+selectNameDocCode+'_freetext" type="textfield" value="'+freetextValue+'" style="width:250px;"></input>');
	}else{
		$('#freetextDocCodeSpan').html('');
	}
});

$(document).ready(function() {
	$('select[name="<%=selectName%>"]').change();
});
</script>