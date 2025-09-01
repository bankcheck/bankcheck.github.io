<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.db.ForwardScanningDB"%>
<%@ page import="com.hkah.web.db.PatientDB"%>
<%@ page import="com.hkah.web.db.helper.FsModelHelper"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%
// get infomation from userbean
UserBean userBean = new UserBean(request);

// store current category
String pageCategory = request.getParameter("category");
if (pageCategory != null) {
	session.setAttribute(ConstantsWebVariable.KEY_SESSION_PAGE_CATEGORY, pageCategory);
} else {
	pageCategory = (String) session.getAttribute(ConstantsWebVariable.KEY_SESSION_PAGE_CATEGORY);
}
String referer = (String) session.getAttribute(ConstantsWebVariable.KEY_SESSION_PAGE_REFERER);
String viewMode = ParserUtil.getParameter(request, "viewMode");
String patno = ParserUtil.getParameter(request, "patno");

boolean isAdminModes = (FsModelHelper.ViewMode.ADMIN.equals(FsModelHelper.parseViewMode(viewMode)) || 
		FsModelHelper.ViewMode.DEBUG.equals(FsModelHelper.parseViewMode(viewMode)));

//check patient lock
boolean isPatLocked = false;
ReportableListObject row = null; 
String isLocked = null;
String reason = null;
ArrayList record = PatientDB.getPatLockStatus(patno);
if (record.size() > 0) {
	row = (ReportableListObject) record.get(0);
	isLocked = row.getValue(5);
	reason = row.getValue(7);
	
	isPatLocked ="Y".equals(isLocked);
}

//check patient merge
Set<String> mergePatnos = null;
StringBuffer strBuf = new StringBuffer();
mergePatnos = ForwardScanningDB.getPatMergeByFmPatno(patno);
if (!mergePatnos.isEmpty()) {
	strBuf.append("Patient: ");
	strBuf.append(patno);
	strBuf.append(" has been merged to Patient: ");
	strBuf.append(StringUtils.join(mergePatnos, ", "));
}

mergePatnos = ForwardScanningDB.getPatMergeByToPatno(patno);
if (!mergePatnos.isEmpty()) {
	if (strBuf.length() > 0) {
		strBuf.append("\n");
	}
	strBuf.append("Patient: ");
	strBuf.append(patno);
	strBuf.append(" already include ");
	strBuf.append("Patient: ");
	strBuf.append(StringUtils.join(mergePatnos, ", "));
	strBuf.append("'s records ");
}
%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN"
	 "http://www.w3.org/TR/html4/frameset.dtd">
<html>
<head>
<title>Hospital Intranet</title>
<script>
		function showPatientMerge(str) {
			alert(str);
		}
		
<% if (strBuf.length() > 0 && 
		(FsModelHelper.ViewMode.LIVE.equals(FsModelHelper.parseViewMode(viewMode)) || 
				FsModelHelper.ViewMode.PREVIEW.equals(FsModelHelper.parseViewMode(viewMode)))) { %>
		showPatientMerge("<%=strBuf.toString() %>");
<% } %>
</script>
</head>
<% if (isPatLocked && !isAdminModes) {
	String[] reasonLines = null;
	if (reason != null) {
		reasonLines = reason.split("\r\n");
		
	}
%>
	<body>
	<script>
		var msg = '<% for(int i=0; i < reasonLines.length; i++) { %><%=reasonLines[i].replace("'", "\\'") %>\n<% } %>';
		function showPatLockMsg() {
			alert('Patient No.: <%=patno %>\nRestricted Access\nReason: ' + msg);
		}
		showPatLockMsg();
	</script>
	</body>
<% } else { %>
<% if (isAdminModes) { %>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.fs" />
	<jsp:param name="isHideTitle" value="Y" />
</jsp:include>
<% } %>
	<frameset name="pat_main_frameset" id="pat_main_frameset" border="0" frameborder="0" framespacing="0" rows="110, *">
		<frame name="pat_header" src="pat_header.jsp?viewMode=<%=viewMode %>&patno=<%=patno %>" noresize scrolling="no">
	<%
		if ("fs".equals(pageCategory)) {
	%>
		<frame name="bigcontent" src="../forwardScanning/frame.jsp?viewMode=<%=viewMode %>&patno=<%=patno %>">
	<%
		} else {
	%>
		<frame name="bigcontent">
	<%
		}
	%>
		<noframes>
				<P>Please use Internet Explorer or Mozilla!
		</noframes>
	</frameset>
<% } %>
</html>