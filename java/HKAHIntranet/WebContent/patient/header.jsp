<meta http-equiv="Cache-Control" content="no-cache">
<%@ page import="com.hkah.web.db.StaffDB"%>
<%
String value = (String)session.getAttribute("staffID");
String name = StaffDB.getStaffFullName2(value);
%>

<table width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<img src="../images/hkah_portal_logo.gif" border="0" width="302" height="81" />
		</td>
		<td align="right" valign="top">
			<%if (name != null) {%>
				<label id="postLabel">Staff: </label>
				<label><b><%=name!=null?name.replace(",", ""):"" %></b>!</label>
			<%} %>
		</td>
	</tr>
</table>