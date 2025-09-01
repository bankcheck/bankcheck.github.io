<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="com.hkah.constant.ConstantsServerSide" %>
<%@ page import="com.hkah.ehr.common.FactoryBase" %>
<%
	FactoryBase.getInstance().loadSysparams();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<style>

</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Reload Parameters</title>
</head>
<body>
	<h1>Reload ehr-interface Parameters (Sysparam)</h1>
	<p>
		System Site Code=<%=ConstantsServerSide.SITE_CODE %><br />
		EHRTEST=<%=FactoryBase.getInstance().getSysparamValue("EHRTEST") %>
	</p>
</body>
</html>
