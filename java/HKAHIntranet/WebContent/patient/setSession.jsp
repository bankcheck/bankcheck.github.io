<%@ page import="java.util.*"%>
<%@ page import="org.apache.struts.*"%>
<meta http-equiv="Cache-Control" content="no-cache">
<%
String name = request.getParameter("sessionName");
String value = request.getParameter("sessionValue");
String directTo = request.getParameter("directTo");

if (name.equals("language")) {
	Locale locale = Locale.US;
	if ("zh_TW".equals(value)) {
		locale = Locale.TRADITIONAL_CHINESE;
	} else if ("zh_CN".equals(value)) {
		locale = Locale.SIMPLIFIED_CHINESE;
	} else if ("ja_JP".equals(value)) {
		locale = Locale.JAPAN;
	}
	
	session.setAttribute( Globals.LOCALE_KEY, locale );
}
else {
	session.removeAttribute(name);
	session.setAttribute(name, value);
}

if (directTo !=null && directTo.equals("main")) {
	response.sendRedirect("../patient/main_develop.jsp");
}
else {
	response.sendRedirect(request.getHeader("Referer"));
}
%>