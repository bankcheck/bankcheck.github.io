<%@ page import="java.util.*"
%><%@ page import="com.hkah.util.*"
%><%@ page import="com.hkah.util.db.*"
%><%@ page import="com.hkah.web.common.*"
%><%@ page import="com.hkah.web.db.*"%><%
String acmcode = request.getParameter("acmcode");

String RoomChgMin = null;
String RoomChgMax = null;

ArrayList<ReportableListObject> record = UtilDBWeb.getFunctionResultsHATS("NHS_GET_ROOMFEE", new String[] { acmcode });
ReportableListObject row = null;

if (record.size() > 0) {
	row = (ReportableListObject) record.get(0);
	RoomChgMin = row.getValue(0);
	RoomChgMax = row.getValue(1);
}
%>
<input type="hidden" name="hats_RoomChgMin" value="<%=RoomChgMin==null||RoomChgMin.length()==0?"0":RoomChgMin %>" />
<input type="hidden" name="hats_RoomChgMax" value="<%=RoomChgMax==null||RoomChgMax.length()==0?"0":RoomChgMax %>" />
