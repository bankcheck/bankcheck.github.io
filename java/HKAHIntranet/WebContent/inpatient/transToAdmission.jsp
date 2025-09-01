<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>

<% 
UserBean userBean = new UserBean(request);
String patNo = request.getParameter("patNo");
String bpbID = request.getParameter("bpbID");

%>

<%=InPatientPreBookDB.transToPreAdmission(userBean, patNo, bpbID)%>