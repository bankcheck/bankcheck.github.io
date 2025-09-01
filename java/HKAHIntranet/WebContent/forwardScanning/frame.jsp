<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.util.*"%>
<%
// get infomation from userbean
UserBean userBean = new UserBean(request);
//if (!userBean.isAccessible("function.fs"))
//	return;

String patno = ParserUtil.getParameter(request, "patno");
String viewMode = ParserUtil.getParameter(request, "viewMode");
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN"
	 "http://www.w3.org/TR/html4/frameset.dtd">
<html>
	<head>
		<title>Forward Scanning</title>
	</head>
	<frameset name="forwardScanning_frameset" id="forwardScanning_frameset" border="1" frameborder="1" framespacing="0" cols="450, *">
		<frame name="menu" src="left_menu.jsp?&viewMode=<%=viewMode %>&patno=<%=patno %>">
		<frame name="fs_content" src="preview.jsp">
		<noframes>
				<P>Please use Internet Explorer or Mozilla!
		</noframes>
	</frameset>
</html>