<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>

<%
String group = request.getParameter("group");
String action = request.getParameter("action");
boolean viewAction = "view".equals(action);
boolean editAction = "edit".equals(action);

if(group.equals("Y")) {
	String grpID = request.getParameter("grpID");
	String grpDesc = request.getParameter("grpDesc");
	String moduleCode = request.getParameter("moduleCode");
	String pirID = request.getParameter("pirID");
	
	ArrayList record = PiReportDB.fetchReportSubHeading(moduleCode, grpID, pirID, editAction);
	ReportableListObject row = null;
	
	if(record.size() > 0) {
	%>
		<div align="left">
			<hr></hr>
			<div style="background-color:#C00000;color:white!important;">
				&nbsp;
				<u>
					<label style="font-size:22px; font-weight:bold;color:white!important;"><%=grpDesc%></label>
				</u>
			</div>
	<%
		for(int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			%>
				<h3 class="header ui-widget-header" style="width:99.85%" grpID='<%=row.getValue(0) %>'>
						<label><%=row.getValue(2) %></label>&nbsp;&nbsp;&nbsp;<span class="alert"></span>
						<div style="float:right" class="toggleLabel"><img src='../images/module-expand.png'/><b><u>Open</u></b></div>
				</h3>
				<div id="<%=row.getValue(0)%>" categroy="<%=row.getValue(3)%>" style="width:95.2%"
						class="ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom ui-accordion-content-active content-frame">
						<jsp:include page='../pi/report_details.jsp' flush='false'>
							<jsp:param name='subContent' value='N' />
							<jsp:param name='grpID' value='<%=row.getValue(0)%>' />
							<jsp:param name="action" value="<%=action%>" />
						</jsp:include>
				</div>
			<%
		}
		%>
			<br/>
		</div>
	<%
	}
	
}
else {
	String title = request.getParameter("title");
	String categoryID = request.getParameter("categoryID");
	String category = request.getParameter("category");
	
	%>
		<h3 class="header ui-widget-header" style="width:99.85%" grpID='<%=categoryID %>'>
				<label><%=title %></label>&nbsp;&nbsp;&nbsp;<span class="alert"></span>
				<div style="float:right" class="toggleLabel"><img src='../images/module-expand.png'/><b><u>Open</u></b></div>
		</h3>
		<div id="<%=categoryID%>" categroy="<%=category%>" style="width:95.2%"
				class="ui-accordion-content ui-helper-reset ui-widget-content ui-corner-bottom ui-accordion-content-active content-frame">
				<jsp:include page='../pi/report_details.jsp' flush='false'>
					<jsp:param name='subContent' value='N' />
					<jsp:param name='grpID' value='<%=categoryID%>' />
					<jsp:param name="action" value="<%=action%>" />
				</jsp:include>
		</div>
	<%
}
%>