<%@ page language="java"
%><%@ page import="java.io.*"
%><%@ page import="java.util.*"
%><%@ page import="org.apache.commons.lang.StringUtils"
%><%@ page import="com.hkah.constant.*"
%><%@ page import="com.hkah.util.*"
%><%@ page import="com.hkah.web.common.*"
%><%
UserBean userBean = new UserBean(request);

/*

------
attrName - progress-download / progress-upload
------

------
progress - numeric percentage value (0 - 100)
------

*/
Long progress = 0l;

String cmd = request.getParameter("cmd");
String type = request.getParameter("type");
String attrName = "progress-" + (type == null ? "" : type);

if ("reset".equalsIgnoreCase(cmd)) {
	session.setAttribute(attrName, 0l);
} else {
	progress = (Long) session.getAttribute(attrName);
}
%>
<%=progress %>