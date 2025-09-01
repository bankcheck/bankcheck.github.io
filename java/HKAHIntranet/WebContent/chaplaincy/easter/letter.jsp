<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri='http://java.sun.com/jsp/jstl/core' prefix='c'%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Easter</title>
<style>
a img
{
  border: 0 none;
}
</style>

</head>
<body>
	<div style="margin:auto; display:block;width: 1024px; height: 768px; ">
<%
	String lang = request.getParameter("lang");
	if(lang == null){
		lang = "en";
	}
	
	String order = request.getParameter("order");
	if(order == null){
		order = "1";
	}
		
%>
              
	
	<div style="text-align:center;color:#4C2158;font-family:Comic Sans;font-size:170%;">
<%
	if(lang.equals("en")){
%>
		Eng <a href="../easter/letter.jsp?lang=cn">中文</a>
<%
	}else{
%>
		<a href="../easter/letter.jsp?lang=en">Eng</a> 中文
<%
	}
%>		
	</div>
	
	<img  src='../easter/resource/<%=lang %>/letter.png' alt='cannot find image' style="width:100%;"/>
		<a href = "../easter/image.jsp?imgType=easterabout.png&lang=<%=lang %>">
			<img  src='<%=(order.equals("1"))?"../easter/resource/flashheart.gif":"../easter/resource/heart.png" %>' style='position:relative;<%=(lang.equals("en"))?"right:-80px;top:-530px;":"right:-100px;top:-550px;"%>' />
		</a>
	<br/>	
		<a href = "../easter/image.jsp?imgType=happyeaster.gif&lang=<%=lang %>">
			<img  src='<%=(order.equals("2"))?"../easter/resource/flashheart.gif":"../easter/resource/heart.png" %>' style='position:relative;<%=(lang.equals("en"))?"right:-80px;top:-500px;":"right:-100px;top:-525px;"%>'/>
		</a>

	<br/>
		<a href = "../easter/image.jsp?imgType=easterpilgrimage.gif&lang=<%=lang %>">		
			<img  src='<%=(order.equals("3"))?"../easter/resource/flashheart.gif":"../easter/resource/heart.png" %>' style='position:relative;<%=(lang.equals("en"))?"right:-80px;top:-470px;":"right:-100px;top:-500px;"%>'/>
		</a>
	<br/>
	
		<a href = "../easter/image.jsp?imgType=whatfirst.png&lang=<%=lang %>">		
			<img  src='<%=(order.equals("4"))?"../easter/resource/flashheart.gif":"../easter/resource/heart.png" %>' style='position:relative;<%=(lang.equals("en"))?"right:-80px;top:-445px;":"right:-100px;top:-470px;"%>'/>
		</a>
	
	<br/>
		<a href = "../easter/image.jsp?imgType=eggshell.png&lang=<%=lang %>">		
			<img  src='<%=(order.equals("5"))?"../easter/resource/flashheart.gif":"../easter/resource/heart.png" %>' style='position:relative;<%=(lang.equals("en"))?"right:-80px;top:-390px;":"right:-100px;top:-420px;"%>'/>
		</a>
	<br/>
		<img src='../easter/resource/flashheart.gif' style='width:36px;position:relative;<%=(lang.equals("en"))?"right:-290px;top:-270px;":"right:-280px;top:-280px;"%>'/>
	<br/>
		<img src="../easter/resource/animation_letter.gif" style="width:130px;height:;position:relative;right:-850px;top:-815px;"/>

	</div>
	
	
</body>
</html>

