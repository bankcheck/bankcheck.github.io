<%@ page import="com.hkah.constant.*"%>
<%
String headerTitle = request.getParameter("headerTitle");
%>
<div class="header_top_row">
<div class="normal_area">
<table style="width:100%">
<tr>
<%if("twah".equals(ConstantsServerSide.SITE_CODE)){ %>
	<td><a href="http://www.twah.org.hk/en/main" id="logo_twah"></a></td>
<%} else { %>	
	<td><a href="http://www.hkah.org.hk/en/main" id="logo"></a></td>
<%} %>
	<td style="padding: 30px;" class="header_title_only"><%=headerTitle %></td>	
</tr>
</table>   
</div>                 
</div>
<br/>