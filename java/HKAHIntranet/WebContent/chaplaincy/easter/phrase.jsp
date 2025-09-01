<%@ page language="java" contentType="text/html; charset=ISO-8859-1"pageEncoding="ISO-8859-1"%>
<%@ taglib uri='http://java.sun.com/jsp/jstl/core' prefix='c'%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Easter</title>
</head>
<body>
	<div style="margin:auto; display:block;width: 1024px; height: 768px; ">
	
<%
		String imgType = request.getParameter("imgType");
		String lang = request.getParameter("lang");
		String url = "../easter/resource/" + lang + "/" +  imgType;
%>
	
<%
	if(imgType.equals("roman.png")){ 
%>
	<a href="../easter/letter.jsp?lang=<%=lang %>&order=2">
		<img  src="<%=url%>" style="width:100%;height:100%;"/>
		<img  src='../easter/resource/flashheart.gif' style='position:relative;<%=(lang.equals("en"))?"right:-700px;top:-100px;":"right:-620px;top:-100px;"%>'/>
	</a>
<%
	}
	if(imgType.equals("john.png")){ 
%>
	<a href="../easter/letter.jsp?lang=<%=lang %>&order=3">
		<img  src="<%=url%>" style="width:100%;height:100%;"/>
		<img  src='../easter/resource/flashheart.gif' style='position:relative;<%=(lang.equals("en"))?"right:-370px;top:-100px;":"right:-420px;top:-90px;"%>'/>
	</a>
<%
	}
	if(imgType.equals("ephesians.png")){ 
%>
	<a href="../easter/letter.jsp?lang=<%=lang %>&order=4">
		<img  src="<%=url%>" style="width:100%;height:100%;"/>
		<img  src='../easter/resource/flashheart.gif' style='position:relative;<%=(lang.equals("en"))?"right:-650px;top:-420px;":"right:-600px;top:-440px;"%>'/>
	</a>
<%
	}
	if(imgType.equals("john11.png")){ 
%>
	<a href="../easter/letter.jsp?lang=<%=lang %>&order=5">
		<img  src="<%=url%>" style="width:100%;height:100%;"/>
		<img  src='../easter/resource/flashheart.gif' style='position:relative;<%=(lang.equals("en"))?"right:-470px;top:-130px;":"right:-470px;top:-120px;"%>'/>
	</a>
<%
	}
	if(imgType.equals("revelation.png")){ 
%>
	<a href="../easter/qrposter.jsp?lang=<%=lang %>">
		<img  src="<%=url%>" style="width:100%;height:100%;"/>
		<img  src='../easter/resource/flashheart.gif' style='position:relative;<%=(lang.equals("en"))?"right:-650px;top:-250px;":"right:-630px;top:-270px;"%>'/>
	</a>
	
<%
	}
%>

	
	</div>
</body>
</html>