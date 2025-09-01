<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);
String eventType = request.getParameter("eventType");
String title = request.getParameter("title");
String desc = request.getParameter("desc");
String date = request.getParameter("date");
String sTime = request.getParameter("sTime");
String eTime = request.getParameter("eTime");
String action = request.getParameter("action");
String enrollID = request.getParameter("enrollID");
String memEventID = request.getParameter("memEventID");
String isRecur = request.getParameter("isRecur");
String recurWeekDay = request.getParameter("recurWeekDay");
String rEndDay = request.getParameter("rEndDay");
String recurType = request.getParameter("recurType");
String venue = request.getParameter("venue");
boolean success =false;
int result = -1;
 
result = Integer.parseInt(UtilDBWeb.callFunction
		("ACT_MKTEVENT",action, new String[] { eventType,title,desc,
				date+" "+sTime,date+" "+eTime,enrollID,memEventID,isRecur,recurWeekDay,rEndDay,recurType,venue }));

success = (result >= 0);
%>
<%=result%>