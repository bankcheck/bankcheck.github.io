<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.model.FsForm"%>

<%
String formCode = request.getParameter("formCode");
String pattype = request.getParameter("pattype");

FsForm record = ForwardScanningDB.getFsForm(formCode,pattype);
%>
<%=record.getFsCategoryId().toPlainString() %>



