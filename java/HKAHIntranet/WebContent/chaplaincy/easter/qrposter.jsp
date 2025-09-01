<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1"%>
<%@ taglib uri='http://java.sun.com/jsp/jstl/core' prefix='c'%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Easter</title>

</head>
<body>	
<%
		String lang = request.getParameter("lang");	
%>
	<div style="margin:auto; display:block;width: 1024px; height: 768px; ">
		<a href="../easter/index.jsp">
			<img style="width:100%;" src='../easter/resource/<%=lang%>/easterposter.jpg'/>
		</a>
	</div>
</body>
</html>