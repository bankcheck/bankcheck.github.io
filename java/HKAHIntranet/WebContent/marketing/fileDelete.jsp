<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String keyID = request.getParameter("keyID");
String docID = request.getParameter("docID");
String isDelAll = request.getParameter("isDelAll");

boolean success =false;
if ("Y".equals(isDelAll) && (!"".equals(keyID) && keyID != null)) {
	success = DocumentDB.delete(userBean.getSiteCode(),userBean,"marketing",keyID,null);		
} else {
	success = DocumentDB.delete(userBean.getSiteCode(),userBean,"marketing",keyID,docID);
}

%>
<%=success%>