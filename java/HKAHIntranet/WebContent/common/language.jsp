<%@ page import="java.util.*"%>
<%@ page import="org.apache.struts.*"%>
<%
String language = request.getParameter("language");
Locale locale = Locale.US;
if ("zh_TW".equals(language)) {
	locale = Locale.TRADITIONAL_CHINESE;
} else if ("zh_CN".equals(language)) {
	locale = Locale.SIMPLIFIED_CHINESE;
} else if ("ja_JP".equals(language)) {
	locale = Locale.JAPAN;
}

session.setAttribute( Globals.LOCALE_KEY, locale );
%><% response.sendRedirect("../index.jsp"); %>