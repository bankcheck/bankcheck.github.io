<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
String userID = request.getParameter("userID");
String username = CMSDB.getCISusername(userID);	
%>
<%=username%>