<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="javax.servlet.*,java.text.*" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>

<%
UserBean userBean = new UserBean(request);
ArrayList<ReportableListObject> record = null;
ReportableListObject row = null;

String mode = request.getParameter("mode");
String arccode = request.getParameter("arccode");
String arName = request.getParameter("arName");
String addDoccode = request.getParameter("doccode");
String doccode[] = null;
if("save".equals(mode)){
	boolean success = false;
	success = PanelDoctorDB.insertPanelDoctor("AR", arccode, null, null, addDoccode);
	%><%=success %><%
}else{
	String docName[] = null;
	String doccodeAvailable[] = null;
	String docNameAvailable[] = null;
	record = PanelDoctorDB.getDoctorList(arccode);
	if(record.size() > 0){
		doccode = new String[record.size()];
		docName = new String[record.size()];
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			doccode[i] = row.getValue(0);
			String docFName = row.getValue(1);
			String docGName = row.getValue(2);
			docName[i] = (docFName == null ? "" : docFName + ", ") + (docGName == null ? "" : docGName);
		}
	} else {
		doccode = null;
	}
	
	record = PanelDoctorDB.getAllDocList();
	if(record.size() > 0){
		doccodeAvailable = new String[record.size()];
		docNameAvailable = new String[record.size()];
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			doccodeAvailable[i] = row.getValue(0);
			String docFName = row.getValue(1);
			String docGName = row.getValue(2);
			docNameAvailable[i] = (docFName == null ? "" : docFName + ", ") + (docGName == null ? "" : docGName);
		}
	} else {
		doccodeAvailable = null;
	}
	
	String title = null;
	title = "Add Doctor to Company - " + arName;
%>
		<jsp:include page="../common/page_title.jsp" flush="false">
			<jsp:param name="pageTitle" value="<%=title %>" />
		</jsp:include>
<form name="new_form" action="panelDoctorByAR.jsp" method="post">
		<table style="width:100%;">
			<tr class="smallText">
				<td>Available Doctor</td>
				<td>&nbsp;</td>
				<td>Selected Doctor</td>
			</tr>
			<tr class="smallText">
				<td width="40%">
					<select name="doccodeAvailable" id="select1" size="10" multiple="">
<%	if (doccodeAvailable != null) {
		for (int i = 0; i < doccodeAvailable.length; i++) {
			
%>						<option value="<%=doccodeAvailable[i] %>"><%=docNameAvailable[i] %></option><%
		}
	} %>
					</select>
				</td>
				<td width="20%">
					<input type="button" class="btn-click" onclick="appendToSelected()" value="Add >>"></input><br/>
					<input type="button" class="btn-click" onclick="removeFromSelected()" value="<< Delete"></input></span>
				</td>
				<td width="40%">
					<select name="doccode" id="select2" size="10" multiple="">
<%	if (doccode != null) {
		for (int i = 0; i < doccode.length; i++) {
%>						<option value="<%=doccode[i] %>"><%=docName[i] %></option><%
		}
	} %>
					</select>
				</td>
			</tr>
		</table>
	</form>
	<button onclick="saveAction();" class="btn-click">Save</button>
	
	<script>
	removeDuplicateItem('new_form', 'doccodeAvailable', 'doccode');
	</script>
<%}%>