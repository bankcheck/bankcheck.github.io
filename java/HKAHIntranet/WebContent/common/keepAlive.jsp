<%@ page import="com.hkah.util.DateTimeUtil"%>
<%@ page import="java.util.Date"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%
Date creationTime = new Date(session.getCreationTime());
Date lastAccessedTime = new Date(session.getLastAccessedTime());
int maxInactiveInterval = session.getMaxInactiveInterval();
System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " [keepAlive] session id = " + session.getId() + ", creationTime=" + creationTime+", lastAccessedTime="+lastAccessedTime+", maxInactiveInterval="+maxInactiveInterval);

session.getId(); // keep session active
%>
OK