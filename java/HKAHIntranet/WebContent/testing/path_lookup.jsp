<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.io.*"%>
<%!
public File openPath(String path) {
	File f = null;
	if (path != null) {
		f = new File(path);
	}
	return f;
}
	
%>
<%
	UserBean userBean = new UserBean(request);
	if (userBean == null || !userBean.isAdmin()) {
%>
<jsp:forward page="" /> 
<%
	}

String path = request.getParameter("path");
File f = openPath(path);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Test path using standard Java.io.File</title>
</head>
<body>
	<h2>Test path using standard Java File</h2>
	<form name="form1" action="path_lookup.jsp" method="post">
		<table border="1">
			<tr>
				<td>Input path:</td>
				<td><input type="text" name="path" size="50"/><%=path == null ? "" : path %></td>
			</tr>
			<tr>
				<td colspan="2">
					<button type="submit" name="go">Go</button>
				</td>
			</tr>
		</table>
	</form>
	<div>Result:</div>
	<table border="1">
		<tr>
			<td valign="top">Path param</td>
			<td><%=path %></td>
		</tr>
		<tr>
			<td valign="top">File object</td>
			<td><%=f %></td>
		</tr>
<% if (f != null) { %>
		<tr>
			<td valign="top">getPath</td>
			<td><%=f.getPath() %></td>
		</tr>
		<tr>
			<td valign="top">isDirectory</td>
			<td><%=f.isDirectory() %>
				<%
					String[] nameList = f.list();
				%>
				<br />List size: <%=nameList == null ? "empty" : nameList.length %>
				<%
					if (nameList != null) {
						for (String name : nameList) {
				%>
				<br /> <%=name %>
				<%
						}
					}
				%>
			</td>
		</tr>
		<tr>
			<td>isFile</td>
			<td><%=f.isFile() %></td>
		</tr>
<% } %>
	</table>

</body>
</html>