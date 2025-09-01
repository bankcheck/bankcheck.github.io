<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.util.*"%>
<%!
public static boolean editReceiveEmailStatus(UserBean userBean,String type,String clientID,String groupID,boolean checked){	
	StringBuffer sqlStr = new StringBuffer();
	
	
	sqlStr.append("UPDATE  CRM_GROUP_COMMITTEE  ");
	sqlStr.append("SET     CRM_RECEIVE_EMAIL ='"+(checked?1:0)+"', ");
	sqlStr.append("        CRM_MODIFIED_DATE = SYSDATE, ");
	sqlStr.append("        CRM_MODIFIED_USER = '" + userBean.getLoginID() + "' ");
	sqlStr.append("WHERE   CRM_CLIENT_ID = '" + clientID + "' ");
	sqlStr.append("AND     CRM_GROUP_ID = '" + groupID + "' ");
	sqlStr.append("AND     CRM_ENABLED = 1 ");
	sqlStr.append("AND     CRM_GROUP_POSITION = '"+type+"'");
	
	//System.out.println(sqlStr.toString());
	
	return UtilDBWeb.updateQueue(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);

String type = request.getParameter("type");
String clientID = request.getParameter("clientID");	
String groupID = request.getParameter("groupID");
boolean checked = "true".equals(request.getParameter("checked"));

%><%=editReceiveEmailStatus(userBean,type,clientID,groupID,checked) %>

