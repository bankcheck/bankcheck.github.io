<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>
<%!
%>
<%
String incidentType = request.getParameter("incidentType");
String action = request.getParameter("action");
boolean viewAction = "view".equals(action);
boolean editAction = "edit".equals(action);
String pirID = request.getParameter("pirID");

ArrayList incidentTypeRec = PiReportDB.fetchIncidentType(incidentType);
ReportableListObject row = null;

if(incidentTypeRec.size() > 0) {
	row = (ReportableListObject) incidentTypeRec.get(0);
%>
	<div id="report" class="ui-accordion ui-widget ui-helper-reset ui-accordion-icons">
		<div align="center"><label style="font-size:22px; font-weight:bold;"><%=row.getValue(0) %></label></div><br/>
<%

	String moduleCode = row.getValue(1);
	ArrayList category = PiReportDB.fetchReportHeading(moduleCode, pirID, editAction);
	
	if(category.size() > 0) {
		for(int i = 0; i < category.size(); i++) {
			row = (ReportableListObject) category.get(i);
			
			if(row.getValue(1).equals("group")) {
				%>
					<jsp:include page="../pi/report_grpCatergory.jsp" flush="false">
						<jsp:param name="group" value="Y" />
						<jsp:param name="grpID" value="<%=row.getValue(0)%>" />
						<jsp:param name="grpDesc" value="<%=row.getValue(2)%>" />
						<jsp:param name="moduleCode" value="<%=moduleCode%>" />
						<jsp:param name="action" value="<%=action%>" />
					</jsp:include>
				<%
			}
			else {
				%>
					<jsp:include page="../pi/report_grpCatergory.jsp" flush="false">
						<jsp:param name="group" value="N" />
						<jsp:param name="title" value="<%=row.getValue(2)%>" />
						<jsp:param name="categoryID" value="<%=row.getValue(0)%>" />
						<jsp:param name="category" value="<%=row.getValue(3)%>" />
						<jsp:param name="action" value="<%=action%>" />
					</jsp:include>
				<%
			}
		}
	}
%>
	</div>
	<br/>
	<input type="hidden" name="<%=incidentType%>_value" value=""/>
	<div align="center">
<%
	if(viewAction) {
%>
		<button class="reportSubmit" submitType="edit">Edit</button> 
<%
	}
	else if(editAction) {
%>
		<button class="reportSubmit" submitType="update">Update</button> 
<%		
	}
	else {
%>
		<button class="reportSubmit" submitType="create">Submit</button>
<%
	}
%>
	</div>
<%
}
%>