<%@ page language="java" contentType="text/html; charset=utf-8" %>
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
	if(imgType.equals("easterabout.png")){ 
%>
	<a href="../easter/phrase.jsp?imgType=roman.png&lang=<%=lang %>">
		<img  src="<%=url%>" style="width:100%;height:100%;"/>
	</a>
<%
	}
	if(imgType.equals("happyeaster.gif")){ 
%>
	<a href="../easter/phrase.jsp?imgType=john.png&lang=<%=lang %>">
		<img  src="<%=url%>" style="width:100%;height:100%;"/>
	</a>
	<br/>
	
	<div style="position:relative;right:-420px;top:-330px;margin-right:420px;">
		<font size="4" face="verdana">
		<b>
<%
		if(lang.equals("en")){
%>
			Click this magic hat to see more!
<%
		}
		else{
%>
			按入此"魔術帽"將有更多體會!
<%
		}
%>
		</b>
		</font>
	</div>
<%
	}
	if(imgType.equals("easterpilgrimage.gif")){ 
%>
	<a href="../easter/phrase.jsp?imgType=ephesians.png&lang=<%=lang %>">
		<img  src="<%=url%>" style="width:100%;height:100%;"/>
	</a>
	
<% 
		if(lang.equals("en")){
%>
	<div style="color:#4C2158;font-family:Comic Sans;font-size:350%;position:relative;right:-170px;top:-600px;margin-right:300px;margin-bottom:-200px">		
		<b>		
		Easter Prilgrimage 2012 </br>
		Have a Fun journey with us! </br>		
		</b>		
	</div>

	<div style="color:white;font-family:serif;font-size:;position:relative;right:-650px;top:-280px;margin-right:650px">		
		<b>
		Click this bubble to see more!
		</b>
	</div>
<%
		}else{
%>
	<div style="color:#4C2158;font-family:Comic Sans;font-size:450%;position:relative;right:-300px;top:-600px;margin-right:300px;">		
		<b>		
		復活節巡禮 
		</b>
	</div>
	<div style="color:#4C2158;font-family:Comic Sans;font-size:350%;position:relative;right:-700px;top:-670px;margin-right:700px">		
		<b>		
		2012
		</b>
	</div>
	<div style="color:#4C2158;font-family:Comic Sans;font-size:350%;position:relative;right:-180px;top:-670px;margin-right:180px">		
		<b>		
		與我們一起渡過這愉快的時光!
		</b>
	</div>	
	<div style="color:white;font-family:serif;font-size:;position:relative;right:-650px;top:-390px;margin-right:650px">		
		<b>
		按入此"泡泡"將有更多體會!
		</b>
	</div>
<%
		}
	}
	if(imgType.equals("whatfirst.png")){ 
%>
	<a href="../easter/phrase.jsp?imgType=john11.png&lang=<%=lang %>">
		<img  src="<%=url%>" style="width:100%;height:100%;"/>
		<img src="../easter/resource/animation_john11_25.gif" style="width:;height:160px;position:relative;right:-45px;top:-720px;"/>
	</a>
<%
	}
	if(imgType.equals("eggshell.png")){ 
		%>
			<a href="../easter/phrase.jsp?imgType=revelation.png&lang=<%=lang %>">
				<img  src="<%=url%>" style="width:100%;height:100%;"/>
				<img src="../easter/resource/animation_revelation.gif" style="width:460px;height:;position:relative;right:-20px;top:-760px;"/>
			</a>
			
		<%
	}
%>

	</div>
</body>
</html>