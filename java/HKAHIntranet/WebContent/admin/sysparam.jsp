<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@	page import="java.text.*"%>
<%@ page import="com.hkah.config.MessageResources" %>
<%@ page import="com.hkah.util.mail.UtilMail"%>
<%@ page import="com.hkah.constant.ConstantsServerSide" %>
<%@ page import="com.spreada.utils.chinese.ZHConverter" %>
<%@ page import="com.hkah.util.sms.UtilSMS" %>
<%@ page import="java.io.IOException" %>
<%!
private static ArrayList<ReportableListObject> getSysparam(String parcde) {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT PARAM1, PARAM2, PARDESC, PARCDE ");
	sqlStr.append("FROM SYSPARAM ");
	sqlStr.append("WHERE PARCDE = ?");
	
	System.out.println("[sysparam] getSysparam sql="+sqlStr.toString() + ", parcde=" + parcde);
	return UtilDBWeb.getReportableListHATS(sqlStr.toString(), new String[]{parcde});
}

private static boolean update(String method, String parcde, String param1, String param2, String pardesc) {
	StringBuffer sqlStr = new StringBuffer();
	boolean ret = false;
	List<String> params = new ArrayList<String>();
	String[] paramsArray = null;
	
	if ("update".equalsIgnoreCase(method)) {
		sqlStr.append("UPDATE SYSPARAM ");
		sqlStr.append("SET ");
		sqlStr.append("PARAM1 = ? ");
		params.add(param1);
		if (param2 != null) {
			sqlStr.append(", PARAM2 = ? ");
			params.add(param2);
		}
		if (pardesc != null) {
			sqlStr.append(", PARDESC = ? ");
			params.add(pardesc);
		}
		sqlStr.append("WHERE PARCDE = ? ");
		params.add(parcde);
	} else {
		sqlStr.append("INSERT INTO SYSPARAM ");
		sqlStr.append("(PARAM1, PARAM2, PARDESC, PARCDE) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?) ");
		
		params.add(param1);
		params.add(param2);
		params.add(pardesc);
		params.add(parcde);
	}
	paramsArray = params.toArray(new String[params.size()]);
	
	System.out.print("[sysparam] update sql="+sqlStr.toString());
	for (int i = 0; i < paramsArray.length; i++) {
		System.out.print(", params["+i+"]=" + paramsArray[i]);
	}
	System.out.println();
	
	return UtilDBWeb.updateQueueHATS(sqlStr.toString(), paramsArray);
}

private static boolean deleteSysparam(String parcde) {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("DELETE FROM SYSPARAM ");
	sqlStr.append("WHERE PARCDE = ?");
	
	System.out.println("[sysparam] delete sql="+sqlStr.toString() +", parcde=" + parcde);
	return UtilDBWeb.updateQueueHATS(sqlStr.toString(), new String[]{parcde});
}	

%>
<%
	UserBean userBean = new UserBean(request);
	if (userBean == null || !userBean.isAdmin()) {
		System.out.println("[sysparam] acccess denied");
		return;
	}
	
	String method = request.getParameter("method");
	String parcde = request.getParameter("parcde");
	String param1 = request.getParameter("param1");
	String param2 = request.getParameter("param2");
	String pardesc = request.getParameter("pardesc");
	
	System.out.println("[sysparam] method="+method);
	
	boolean getAction = "get".equalsIgnoreCase(method);
	boolean insertAction = "insert".equalsIgnoreCase(method);
	boolean updateAction = "update".equalsIgnoreCase(method);
	boolean deleteAction = "delete".equalsIgnoreCase(method);

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
		<title>HATS syspram util</title>
	</head>
	<h2>Sysparam</h2>
	<body>
<% if (getAction) { %>
		<div>
			PARCDE: <%=parcde %>
		</div>
		<div>Result:
			<table cellpadding="0" cellspacing="1"
				class="contentFrameSearch" border="1">
				<tr>
					<td>parcde</td>
					<td>param1</td>
					<td>param2</td>
					<td>pardesc</td>
				</tr>
			
<%
	ArrayList<ReportableListObject> list = getSysparam(parcde);
	if (list != null) {
		for (int i = 0; i < list.size(); i++) {
			ReportableListObject row = list.get(i);
%>
				<tr>
					<td><%=row.getFields3() %></td>
					<td><%=row.getFields0() %></td>
					<td><%=row.getFields1() %></td>
					<td><%=row.getFields2() %></td>
				</tr>
<%
		}
	}
%>
			</table>
<% } else if (insertAction || updateAction) { %>
<%
		boolean ret = update(method, parcde, param1, param2, pardesc);
%>
		<div><%=method %> parcde:<%=parcde %> return: <%=ret %></div>
			
		<div>Result:
			<table cellpadding="0" cellspacing="1"
				class="contentFrameSearch" border="1">
				<tr>
					<td>parcde</td>
					<td>param1</td>
					<td>param2</td>
					<td>pardesc</td>
				</tr>
			
<%
	ArrayList<ReportableListObject> list = getSysparam(parcde);
	if (list != null) {
		for (int i = 0; i < list.size(); i++) {
			ReportableListObject row = list.get(i);
%>
				<tr>
					<td><%=row.getFields3() %></td>
					<td><%=row.getFields0() %></td>
					<td><%=row.getFields1() %></td>
					<td><%=row.getFields2() %></td>
				</tr>
<%
		}
	}
%>
			</table>
<% } else if (deleteAction) { %>
<%
		boolean ret = deleteSysparam(parcde);
%>
			<div>Delete parcde:<%=parcde %> return: <%=ret %></div>
<% } %>
		</div>
	</body>
</html>