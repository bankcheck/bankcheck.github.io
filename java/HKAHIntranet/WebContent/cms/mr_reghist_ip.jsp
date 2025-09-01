<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.util.*"%>
<%
UserBean userBean = new UserBean(request);
String patno = ParserUtil.getParameter(request, "patno");
String regid = ParserUtil.getParameter(request, "regid");
String showDocUrl = ParserUtil.getParameter(request, "showDocUrl");

//System.out.println("[intranet] mr_reghist_ip.jsp");
//System.out.println("patno="+patno+", regid="+regid+", showDocUrl="+showDocUrl);
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN"
	 "http://www.w3.org/TR/html4/frameset.dtd">
<html>
	<head>
		<title>Medical Record - Registration History (In-patient)</title>
	</head>
	<frameset name="forwardScanning_frameset" id="forwardScanning_frameset" 
			border="1" frameborder="1" framespacing="0" rows="*, 50">
		<frame name="fm_showDoc" src="<%=showDocUrl %>">
		<frame name="fm_cp" src="mr_reghist_ip_cp.jsp?patno=<%=patno %>&regid=<%=regid %>">
		<noframes>
				<P>Please use Internet Explorer or Mozilla!
		</noframes>
	</frameset>
</html>