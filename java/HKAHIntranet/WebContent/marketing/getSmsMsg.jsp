<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.db.SMSDB"%>
<%@ page import="com.hkah.web.common.ReportableListObject"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>

<%
String smsCode = request.getParameter("smsCode");
String smsMsg = "";
ArrayList result = new ArrayList();

if (smsCode.contains("%")){
	smsMsg = "";
}else{
	result = SMSDB.getMsg(smsCode,null);
	if (result.size() > 0) {
		ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
		smsMsg = reportableListObject.getValue(1);
	} else {
		smsMsg = "";
	}
}

String newMsg = smsMsg.replace("&#13;", "<br/>");

response.setContentType("text/html; charset=utf-8");

if(smsMsg == ""){ %>
   	<script>
   		$('#send').prop('disabled',true);
   		alert("Error SMS code");
   	</script>
<% }else{ %>
	<%=newMsg %>
	<script>$('#send').prop('disabled',false);</script>
<% } %>
