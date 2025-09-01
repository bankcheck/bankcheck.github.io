<%@ page import="com.hkah.util.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%
	String imageUrl = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "imageUrl"));
	String imageAlt = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "imageAlt"));
	if (imageAlt == null || imageAlt.isEmpty()) {
		imageAlt = imageUrl;
	}
%>

<style>
	#photo-full-size-page {
		margin: 10px;
		padding: 10px;
		background: #f8eeee;
		border: 1px solid #e0dfe3;
	}
	
	.close-button {
		display: block;
		margin-bottom: 10px;
	}
	
	img { border-top-width: 0px; border-left-width: 0px; border-bottom-width: 0px; margin: 0px; border-right-width: 0px }
	
	a { text-decoration: none }
	a:link { text-decoration: none }
	a:visited { text-decoration: none }
	a:hover { text-decoration: none }
</style>
<div id="photo-full-size-page">
	<a href="../" onclick="history.go(-1); return false;"><img class="close-button" src="<html:rewrite page="/images/gallery/photo_back.gif" />" alt="<bean:message key="button.back" />" /></a>
	<img src="<%=imageUrl %>" alt="<%=imageAlt %>" />
</div>

