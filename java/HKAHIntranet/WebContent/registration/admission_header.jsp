<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%
String language = request.getParameter("language");
String header = MessageResources.getMessage(Locale.US, "title.online.admission");

if ("all".equals(language)) {
	header = MessageResources.getMessage(Locale.US, "title.online.admission") + " " + MessageResources.getMessage(Locale.TRADITIONAL_CHINESE, "title.online.admission");
} else if ("chi".equals(language)) {
	header = MessageResources.getMessage(Locale.TRADITIONAL_CHINESE, "title.online.admission");
} else {
	header = MessageResources.getMessage(Locale.US, "title.online.admission");
}
	
%>
<div class="header_top_row">
<div class="normal_area">
<table style="width:100%">
<tr>
	<td><a href="http://www.hkah.org.hk/en/main" id="logo"></a></td>
	<td style="padding: 30px;" class="header_title_only"><%=header %></td>
</tr>
</table>   
</div>                 
</div>
<br/>