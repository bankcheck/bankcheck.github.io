<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.servlet.HKAHInitServlet"%>
<%@ page import="com.hkah.constant.*"%>

<%!
	private ArrayList getFoodAllergyByPat(String patno) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT TO_CHAR(RX_DATE, 'DD/MM/YYYY HH24:MI'), FOOD, REACTION, UPDATE_USER_DESC, ");
		sqlStr.append("TO_CHAR(UPDATE_DATE, 'DD/MM/YYYY HH24:MI'), CANCEL_REASON, ");
		sqlStr.append("CANCEL_USER_DESC, TO_CHAR(CANCEL_DATE, 'DD/MM/YYYY HH24:MI') ");
		sqlStr.append("FROM EXT_GET_PAT_ALLERGY ");
		sqlStr.append("WHERE PATNO = '"+patno+"' ");
		sqlStr.append("AND FOOD IS NOT NULL ");
		sqlStr.append("ORDER BY SEQ_NO DESC ");
		
		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}
%>
<table>
	<tr><td colspan="8" class="text">Allergy:</td></tr>
	<tr>
		<td style="font-size:18px; border-style:outset; border-width:1px; color:black; height:25px; font-weight:bold; text-decoration: underline;">Date</td>
		<td style="font-size:18px; border-style:outset; border-width:1px; color:black; height:25px; font-weight:bold; text-decoration: underline;">Food/Other</td>
		<td style="font-size:18px; border-style:outset; border-width:1px; color:black; height:25px; font-weight:bold; text-decoration: underline;">Reaction</td>
		<td style="font-size:18px; border-style:outset; border-width:1px; color:black; height:25px; font-weight:bold; text-decoration: underline;">Update By</td>
		<td style="font-size:18px; border-style:outset; border-width:1px; color:black; height:25px; font-weight:bold; text-decoration: underline;">Update Date</td>
		<td style="font-size:18px; border-style:outset; border-width:1px; color:black; height:25px; font-weight:bold; text-decoration: underline;">Cancel Reason</td>
		<td style="font-size:18px; border-style:outset; border-width:1px; color:black; height:25px; font-weight:bold; text-decoration: underline;">Cancelled By</td>
		<td style="font-size:18px; border-style:outset; border-width:1px; color:black; height:25px; font-weight:bold; text-decoration: underline;">Cancel Date</td>
	</tr>
<%
	String patno = request.getParameter("patno");
	ArrayList record = getFoodAllergyByPat(patno);
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
	
	ReportableListObject row = null;
	
	if(record.size() > 0) {
		for(int i = 0; i < record.size(); i++) {
			row = (ReportableListObject)record.get(i);
%>
	<tr>
		<td style="font-size:16px; border-style:groove; border-width:1px; color:black; height:25px; font-weight:bold; <%=(row.getValue(7) != null && row.getValue(7).length() > 0)?"text-decoration:line-through;":""%>"><%=row.getValue(0) %></td>
		<td style="font-size:16px; border-style:groove; border-width:1px; color:black; height:25px; font-weight:bold; <%=(row.getValue(7) != null && row.getValue(7).length() > 0)?"text-decoration:line-through;":""%>"><%=row.getValue(1) %></td>
		<td style="font-size:16px; border-style:groove; border-width:1px; color:black; height:25px; font-weight:bold; <%=(row.getValue(7) != null && row.getValue(7).length() > 0)?"text-decoration:line-through;":""%>"><%=row.getValue(2) %></td>
		<td style="font-size:16px; border-style:groove; border-width:1px; color:black; height:25px; font-weight:bold;"><%=row.getValue(3) %></td>
		<td style="font-size:16px; border-style:groove; border-width:1px; color:black; height:25px; font-weight:bold; <%=(row.getValue(7) != null && row.getValue(7).length() > 0)?"text-decoration:line-through;":""%>"><%=row.getValue(4) %></td>
		<td style="font-size:16px; border-style:groove; border-width:1px; color:black; height:25px; font-weight:bold;"><%=row.getValue(5) %></td>
		<td style="font-size:16px; border-style:groove; border-width:1px; color:black; height:25px; font-weight:bold;"><%=row.getValue(6) %></td>
		<td style="font-size:16px; border-style:groove; border-width:1px; color:black; height:25px; font-weight:bold;"><%=row.getValue(7) %></td>
	</tr>
<%
		}
	}
%>
</table>