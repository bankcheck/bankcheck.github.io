<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String keyword = request.getParameter("keyword");
String doccode = request.getParameter("doccode");

ArrayList<ReportableListObject> record = null;
ReportableListObject row = null;
%>
<select name="DocSelect"   id="DocSelect"  onchange="onChangeDoctor();" style="width:550px;">
<%record = UtilDBWeb.getFunctionResults("NHS_CMB_DOCCODE", new String[]{keyword});
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);%>
	<option value="<%=row.getValue(0) %>" spec="<%=row.getValue(3)%>"<%if (row.getValue(0).equals(doccode) || row.getValue(0).equals(keyword)) {%> selected <%}%>><%=row.getValue(1) %>&nbsp;<%=row.getValue(2) %> (<%=row.getValue(0) %>)</option>
<%	}}%>

</select>

