<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.util.db.*"%>

<%!
private boolean deleteOrder(String orderNo) {
	StringBuffer sqlStr_dtr = new StringBuffer();
	StringBuffer sqlStr_hdr = new StringBuffer();
	
	sqlStr_dtr.append("DELETE FROM DIT_ORDER_DTL WHERE ORDER_NO = '"+orderNo+"' ");
	sqlStr_hdr.append("DELETE FROM DIT_ORDER_HDR WHERE ORDER_NO = '"+orderNo+"' ");
	
	return UtilDBWeb.updateQueueFSD(sqlStr_dtr.toString()) && 
			UtilDBWeb.updateQueueFSD(sqlStr_hdr.toString());
}

private boolean editOrder() {
	return false;
}
%>

<%
UserBean userBean = new UserBean(request);
if (userBean == null || !userBean.isLogin()) {
	%>
	<script>
		window.open("../foodtw/index.jsp", "_self");
	</script>
	<%
	return;
}
String action = request.getParameter("action");
String orderNo = request.getParameter("orderNo");

if(action.equals("edit")) {
	
}
else if(action.equals("delete")) {
	boolean delete = deleteOrder(orderNo);
	
	if(delete) {
		UtilDBWeb.updateQueueFSD(
			"INSERT INTO AH_SYS_LOG (SYS_ID, SYS_TIME, USER_ID, USER_DEPT, USER_TEAM, KEYWORD, DESCRIPTION, PCNAME) "+
			"VALUES ('WEB', SYSDATE, ?, ?, 'USR', 'WEB', ?, 'WEB')",
			new String[]
	           {
					userBean.getStaffID(),
					userBean.getDeptCode(),
					"Order No: "+orderNo+" Delete: true ("+userBean.getUserName()+")"
	           });
	}
%>
	<%=delete%>
<%
}
%>