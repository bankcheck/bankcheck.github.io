<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.UtilMail"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
     pageEncoding="UTF-8"%>

<%!
	private ArrayList<ReportableListObject> fetchOrderHistory(String patNo, String rows) {
		//String date = getRegDate(patNo);
	
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT * ");
		sqlStr.append("FROM (SELECT H.ORDER_NO, H.STATUS, H.SERVE_DATE, H.SERVE_TIME, H.SLPAMT, ");
		sqlStr.append("H.CREATE_USER, H.UPDATE_USER, TO_CHAR(H.CREATE_DATE, 'DD/MM/YYYY HH24:MI'), H.PATNO, ");
		sqlStr.append("H.SERVE_TYPE ");
		sqlStr.append("FROM DIT_ORDER_HDR H ");
		sqlStr.append("WHERE H.PATNO = '"+patNo+"' ");
		//sqlStr.append("AND D.ORDER_NO = H.ORDER_NO ");
		if(ConstantsServerSide.isTWAH()) {
			//sqlStr.append("AND CREATE_DATE >= TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY')||' 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
			//sqlStr.append("AND CREATE_DATE <= TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY')||' 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
		}
		//if(date != null) {
		//	sqlStr.append("AND CREATE_DATE >= TO_DATE('"+date+"', 'DD/MM/YYYY HH24:MI:SS') ");
		//}
		sqlStr.append("ORDER BY H.ORDER_NO DESC) ");
		sqlStr.append("WHERE rownum <= "+rows+" ");
		
		return UtilDBWeb.getReportableListFSD(sqlStr.toString());
	}

	private String fetchOrderDetail(String orderNo) {
		StringBuffer sqlStr = new StringBuffer();
		String content = "";
		
		sqlStr.append("SELECT ORDER_NO, ITEM_SEQ, ITEM_TYPE, ITEM_CODE, ITEM_OPT, ");
		sqlStr.append("ITEM_NAME1, ITEM_NAME2, REMARKS, ORDER_QTY, CURRENCY, AMOUNT, ");
		sqlStr.append("BILLAMT, KITCHEN ");
		sqlStr.append("FROM DIT_ORDER_DTL ");
		sqlStr.append("WHERE ORDER_NO = '"+orderNo+"' ");
		sqlStr.append("ORDER BY ITEM_SEQ ");
		
		ArrayList record = UtilDBWeb.getReportableListFSD(sqlStr.toString());
		if(record.size() > 0) {
			ReportableListObject row = null;
			String firstType = "";
			String subItem = "";
			int seq = 1;
			for(int i = 0; i < record.size(); i++) {
				row = (ReportableListObject)record.get(i);
				
				if(firstType.length() == 0) {
					if(!row.getValue(2).equals("M")) {
						firstType = row.getValue(2);
					}
				}
				
				if(row.getValue(2).equals("M")) {
					content += seq + ". " + row.getValue(5) + " X " + row.getValue(8) + "<br/>";
					seq++;
				}
				else if(row.getValue(2).equals("S")) {
					content += seq + ". " + row.getValue(5) + " X " + row.getValue(8) + "<br/>";
					seq++;
					if(firstType.equals("I")) {
						content += subItem;
						subItem = "";
					}
				}
				else if(row.getValue(2).equals("I")) {
					subItem += "&nbsp;&nbsp;&nbsp;&nbsp;" + row.getValue(5) + "<br/>";
					if(firstType.equals("S")) {
						content += "&nbsp;&nbsp;&nbsp;&nbsp;" + row.getValue(5) + "<br/>";
					}
				}
			}
		}
		
		return content;
	}
%>

<%
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

String patno = request.getParameter("patNo");

if(patno == null || patno.length() <= 0) {
	patno = userBean.getLoginID();
}

ArrayList<ReportableListObject> record = fetchOrderHistory(patno, "10");
ReportableListObject row = null;
%>
<tbody>
	<tr><td class="ui-widget-header" colspan="<%=(isTW)?"8":"4" %>" style="width:5%; color:black; height:35px; font-size:23px; font-weight:bold;">Order History</td></tr>
	<tr>
		<td style="width:5%; color:black; height:25px; font-weight:bold; text-decoration: underline; text-align:center;"><label class="text">Order No.</label></td>
		<td style="width:10%; color:black; height:25px; font-weight:bold; text-decoration: underline; text-align:center;"><label class="text">Serve Date</label></td>
		<td style="width:10%; color:black; height:25px; font-weight:bold; text-decoration: underline; text-align:center;"><label class="text">Serve Time</label></td>
		<td style="width:10%; color:black; height:25px; font-weight:bold; text-decoration: underline; text-align:center;"><label class="text">Status</label></td>
		<%if (isTW) { %>
			<td style="width:8%; color:black; height:25px; font-weight:bold; text-decoration: underline; text-align:center;"><label class="text">Order Time</label></td>
			<td style="width:10%; color:black; height:25px; font-weight:bold; text-decoration: underline; text-align:center;"><label class="text">Serve Type</label></td>
			<td style="width:38%; color:black; height:25px; font-weight:bold; text-decoration: underline; text-align:center;"><label class="text">Items</label></td>
			<td style="width:5%; color:black; height:25px; font-weight:bold; text-decoration: underline; text-align:center;"><label class="text">Action</label></td>
		<%} %>
	</tr>

<%
if(record.size() > 0) {
	for(int i = 0; i < record.size(); i++) {
		row = record.get(i);
		String status = null;
		if(row.getValue(1).equals("A")) {
			status = "Order/Active";
		}
		else if(row.getValue(1).equals("P")) {
			status = "Preparing";
		}
		else if(row.getValue(1).equals("R")) {
			status = "Ready";
		}
		else if(row.getValue(1).equals("X")) {
			if(row.getValue(6).equals("WEB")) {
				status = "To be Confirmed";
			}
			else {
				status = "Cancel";
			}
		}
%>
	<tr class="oh_detail <%=((i%2 == 0)?"even":"odd")%>">
		<td style="text-align:center"><label class="text"><%=row.getValue(0) %></label></td>
		<td style="text-align:center"><label class="text"><%=row.getValue(2).substring(0, 11) %></label></td>
		<td style="text-align:center"><label class="text"><%=row.getValue(3) %></label></td>
		<td style="text-align:center"><label class="text"><%=status %></label></td>
		<%if (isTW) { %>
			<td style="text-align:center"><label class="text"><%=row.getValue(7) %></label></td>
			<td style="text-align:center"><label class="text"><%=(row.getValue(9).equals("B")?"Breakfast":
											(row.getValue(9).equals("L")?"Lunch":
											(row.getValue(9).equals("S")?"Snack":
											(row.getValue(9).equals("D")?"Dinner":"")))) %></label></td>
			<td style="text-align:left"><label class="text"><%=fetchOrderDetail(row.getValue(0)) %></label></td>
			<td style="text-align:center">
				<%if (row.getValue(6).toLowerCase().equals("web") && row.getValue(1).equals("X")) { %>
					<button orderNo='<%=row.getValue(0) %>' class = "editOrder ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">Edit</button>&nbsp;
					<button onclick="deleteOrder('<%=row.getValue(0) %>', '<%=row.getValue(8) %>')" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">Delete</button>
				<%} %>
			</td>
		<%} %>
	</tr>
<%}%>
<%
}
%>
<%if (isTW) { %>
	<tr>
		<td>
			<button id="closeDetail" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only">
					Close
					</button>
		</td>
		<td colspan="5"></td>
	</tr>
<%	} %>
</tbody>