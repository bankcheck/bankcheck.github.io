<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.schedule.*"%>
<%!
%>
<%
NotifySendPriceMkNoticeHKJob hkjob = new NotifySendPriceMkNoticeHKJob();
hkjob.execute(null);


%>
