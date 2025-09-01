<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>

<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
	<jsp:include page="header.jsp"/>
	
	<div style="float:right;font-size:12px;padding-right:10px" id="footer">
		<a href="../../crm/portal/contact.jsp" target="">Contact</a>
	</div>
</html:html>
<script>
	$(document).ready(function(){
		$('#footer').find('a').attr('target', $('input[name=target_frame]').val());
	});
</script>