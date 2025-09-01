<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.mail.*"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.util.*"%>
<%@ page import="javax.mail.*"%>
<%@ page import="javax.mail.internet.*"%>
<%@ page import="java.net.MalformedURLException"%>
<%@ page import="java.net.URL"%>
<%@ page import="java.security.cert.Certificate"%>
<%@ page import="java.io.*"%>
<%@ page import="javax.net.ssl.HttpsURLConnection"%>
<%@ page import="javax.net.ssl.SSLPeerUnverifiedException"%>
<%@ page import="org.json.simple.JSONObject"%>
<%@ page import="org.json.simple.parser.JSONParser"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.web.db.*"%>


<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%

RISDB.sendRISEmails();

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>sendRISEmails (NotifyRISReportJob)</title>
<style>
div {
    cursor: help;
}
</style>
</head>
<body>
<div style="border: 1px solid red; width: 500px; height: 500px">

</div>
</body>
</html>