<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.io.*" %>
<%@ page import="java.util.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="hkah.*" %>;

<%
	String action = request.getParameter("a");
  
String rtnmsg = "SUCCESS";

if ( "labgen".equals(action) ) {
	try {

		EwellScheduler test = new EwellScheduler();
		test.ehrSchedule();

	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		rtnmsg = e.getMessage();
	}
} else {
	rtnmsg = "Hello World v1";
}
%>
<%=rtnmsg%>