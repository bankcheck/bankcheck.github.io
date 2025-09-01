<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>
	Healthy Team 20 Health Management Plan
</title>
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
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.json2.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.highlighter.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.funnelRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.enhancedLegendRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.dragable.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.donutRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.cursor.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.ciParser.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.categoryAxisRenderer.min.js" />" /></script>

<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.logAxisRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.dateAxisRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.canvasTextRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.canvasOverlay.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.canvasAxisTickRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.canvasAxisLabelRenderer.min.js" />" /></script>

<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.bubbleRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.blockRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.BezierCurveRenderer.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqplot/jqplot.barRenderer.min.js" />" /></script>

<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/jquery.jqplot.css" />"/>


<%
UserBean userBean = new UserBean(request);
String checkLogin = request.getParameter("checkLogin");
if(request.getRequestURL().indexOf("/crm/portal/index") < 0) {
%>
		<style>
			html, body, iframe {
				background-color: #e6e6e6!important;
			}
		</style>
	</head>
<%
}
else {
%>
	</head>
<%
}

if(userBean != null && !userBean.isLogin() && (checkLogin == null || checkLogin.equals("Y"))) {
%>
	<script type="text/javascript">
		if(window.location.href.indexOf("/crm/portal/index") > -1) {
			
		}
		else {
			window.open("index.jsp", "_top");
		}
	</script>
<%
}
%>
