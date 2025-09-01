<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.UtilMail"%>
<%@ page import="com.hkah.web.common.*"%>

<%!
	private ArrayList<ReportableListObject> fetchOrderHistoryDetail(String orderNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ITEM_NAME1, ORDER_QTY, ITEM_TYPE ");
		sqlStr.append("FROM  DIT_ORDER_DTL ");
		sqlStr.append("WHERE ORDER_NO = '"+orderNo+"' ");
		sqlStr.append("ORDER BY ITEM_SEQ ");
		
		return UtilDBWeb.getReportableListFSD(sqlStr.toString());
	}
%>

<%
String orderNo = request.getParameter("orderNo");
UserBean userBean = new UserBean(request);
boolean isTW = ConstantsServerSide.isTWAH();
if (userBean == null || !userBean.isLogin()) {
	if(isTW) {
		%>
		<script>
			window.open("../foodtw/index.jsp", "_self");
		</script>
		<%
	}
	else {
		%>
		<script>
			window.open("../patient/index.jsp", "_self");
		</script>
		<%
	}
	
	return;
}

ArrayList<ReportableListObject> record = fetchOrderHistoryDetail(orderNo);
ReportableListObject row = null;
%>

<tbody>
	<tr><td class="ui-widget-header" colspan="4" style="width:5%; color:black; height:35px; font-size:20px; font-weight:bold;">Detail <label id="orderNo" class="text"></label></td></tr>
	<tr>
		<td style="width:5%; color:black; height:25px; font-weight:bold; text-decoration: underline;"><label class="text">Item</label></td>
		<td style="width:5%; color:black; height:25px; font-weight:bold; text-decoration: underline;"><label class="text">Quantity</label></td>
	</tr>

<%
if(record.size() > 0) {
	for(int i = 0; i < record.size(); i++) {
		row = record.get(i);
		if(!row.getValue(2).equals("I")) {
		
%>
			<tr class="<%=((i%2 == 0)?"even":"odd")%>">
				<td><div><label class="text"><%=row.getValue(0) %></label></div></td>
				<td><label class="text"><%=row.getValue(1) %></label></td>
			</tr>
		
<%
		}
	}
}
%>
	<tr><td>&nbsp;</td></tr>
	<tr><td>
		<button id="closeDetail" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
						&nbsp;<label class="text">Close</label></button>&nbsp;</td><td></td></tr>
</tbody>
<%
%>