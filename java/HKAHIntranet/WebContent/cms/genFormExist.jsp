<%@ page import="com.hkah.web.db.*"%>
<%
String formId = request.getParameter("formId");
String key1 = request.getParameter("key1");

String key2 = request.getParameter("key2");
if (key2 == null)
	key2 = "0";

String key3 = request.getParameter("key3");
if (key3 == null)
	key3 = "0";

String output = null;

if ( CMSDB.getForm(formId, key1, key2, key3).isEmpty() )
	output = "N";
else
	output = "Y";	
%>
<%=output%>