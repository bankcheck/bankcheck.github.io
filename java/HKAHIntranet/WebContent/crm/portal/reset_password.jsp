<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%
UserBean userBean = new UserBean(request);
if(userBean != null && userBean.isLogin()) {
}
%>
<html:html xhtml="true" lang="true">

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<jsp:include page="../../common/header.jsp">
	<jsp:param name="nocache" value="N" />
</jsp:include>
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/crm.main.css" />"/>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jquery.jqplot.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.trendline.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.pyramidRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.pyramidGridRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.pyramidAxisRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.pointLabels.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.pieRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.ohlcRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.meterGaugeRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.mekkoRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.mekkoAxisRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.logAxisRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.json2.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.highlighter.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.funnelRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.enhancedLegendRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.dragable.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.donutRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.dateAxisRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.cursor.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.ciParser.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.categoryAxisRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.canvasTextRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.canvasOverlay.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.canvasAxisTickRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.canvasAxisLabelRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.bubbleRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.blockRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.BezierCurveRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.barRenderer.min.js" />" /></script>
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/jquery.jqplot.css" />"/>
</head>

	<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/crm.login.css" />"/>
	<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/crm.photo.gallery.css" />"/>
	<body>
	<div style="border:5px solid #8fadff;height:330px;">
			<div style="float:left" id="banner">
			</div>
		<html:form  action="/CRMResetPassword.do" focus="userName" onsubmit="return submitAction();" >
		<div id="login" name="logonForm">
			<div id="header">
				<div id="logo" style="cursor:pointer"></div>
			</div>
			<h1>FORGET <br> PASSWORD</h1>
	  		<fieldset id="inputs">
		    	User ID<br/>
		    	<input id="username" type="text" name="userName" id="userName" size="20" required>			  
		  	</fieldset>
		  	
		  	<table><tr><td>		  	
			<font color="red"><html:errors/></font>
			<font color="blue"><html:messages id="messages" message="true"><bean:write name="messages"/></html:messages></font>
		    </td>
		    <td style="text-align:right"><a href = "index.jsp">Login</a>
		    </td></tr></table>
		  	<fieldset id="actions">		    	
		    	<button id="submit" type="submit">Submit</button>		    	    	
		  	</fieldset>		  
			</div>
		</html:form>	
		</div>	
	</body>
</html:html>
<script type="text/javascript">



function submitAction() {
	if (document.forms["ResetPasswordForm"].elements["userName"].value == "") {
		alert('Please enter User ID.');
		document.forms["ResetPasswordForm"].elements["userName"].focus();
		return false;
	}
	
}
</script>