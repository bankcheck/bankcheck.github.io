<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList<ReportableListObject> fetchWard() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT WRDCODE, WRDNAME ");
		sqlStr.append("FROM   WARD@IWEB ");
		sqlStr.append("WHERE  ACTIVE = '-1' ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>
<%
/*
locid
1 - Pharmacy (PHAR)
2 - PBO (PBO)
//3 - WARD (@HATS-WARD)
*/

/*
STATUS (TABLE:TICKET_QUEUE)
1 - Start Discharge
11- Send to Pharmacy
2 - Receive order (RECEIVE_DATE)
3 - Entry Completed (ENTRY_DATE)
4 - Send to PBO (TO_PBO_DATE)
------------------------------------
6 - Receive from Pharmacy (RECEIVE_FROM_RX_DATE)
7 - Finish Billing (FINISH_BILLING_DATE)
8 - Payment Settlement (PAYMENT_SETTLEMENT_DATE)
------------------------------------
5 - Pharmacy Bedside Discharge (RX_BEDSIDE_DISCHARGE_DATE)
9 - Drug picking by patient  (DRUG_PICKING_DATE)
10 - No Discharge Med (NO_RX_DISCHARGE_DATE)
*/

UserBean userBean = new UserBean(request);

ArrayList<ReportableListObject> record = null;
ReportableListObject row = null;
%>
<html>

<head>
<link rel="stylesheet" type="text/css" href="../css/w3.hkah.css" />
<script type="text/javascript" src="../js/jquery-1.5.1.min.js" /></script>
<script type="text/javascript">

	function isIE() {
		  var myNav = navigator.userAgent.toLowerCase();
		  var ret = (myNav.indexOf('msie') != -1) ? parseInt(myNav.split('msie')[1]) : false;
		  return ret;
	}

	function reprint(regid){
		window.open("../pharmacy/dischargeProcessUpdate_ajax.jsp?regID="+regid+"&process=reprint");
	}

</script>
<style type="text/css">

#Header {
	height: 10%;
	border-bottom: 3px solid #333;
}

#title {
	position: absolute;
	bottom: 0;
	width: 100%;
	text-align: center;
}


</style>
</head>

<body>
<div id="Header" class="w3-display-container ah-pink">
	<b><font id="title" face="AR PL SungtiL GB" size=6 >Discharge Process</font></b>
</div>
<!-- index page -->

<table align="center" cellspacing="0" border="0">
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
<% if (userBean.isLogin() && userBean.isAccessible("function.discharge.phar")) { %>
	<tr>
		<td colspan="2">Pharmacy</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td align="left" valign=middle><b><font face="AR PL SungtiL GB" size=4 color="#AA0066"><a href="dischargeProcess.jsp?locid=PHAR">PHARMACY</a></font>&nbsp;<font color="red"></font></b></td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
<% } %>
<% if (userBean.isLogin() && userBean.isAccessible("function.discharge.pbo")) { %>
	<tr>
		<td colspan="2">PBO</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td align="left" valign=middle><b><font face="AR PL SungtiL GB" size=4 color="#AA0066"><a href="dischargeProcess.jsp?locid=PBO">PBO</a></font>&nbsp;<font color="red"></font></b></td>
	</tr>
	<tr>
		<td colspan="2">&nbsp;</td>
	</tr>
<% } %>
<% if (userBean.isLogin() && userBean.isAccessible("function.discharge") ||  userBean.isAccessible("function.discharge.viewAllDept")) { %>
	<tr>
		<td colspan="2">
			WARD
			<% if (userBean.isLogin() && userBean.isAccessible("function.discharge.viewAllDept")) { %>
			<a href="dischargeProcess.jsp?locid=allDept">(View All)</a>
			<%} %>
		</td>
	</tr>
<%	record = fetchWard();
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i); %>
	<tr>
		<td>(<%=(i + 1) %>)</td>
		<td align="left" valign=middle><b><font face="AR PL SungtiL GB" size=4 color="#AA0066"><a href="dischargeProcess.jsp?locid=<%=row.getValue(0) %>"><%=row.getValue(1) %></a></font>&nbsp;<font color="red"></font></b></td>	</tr>
<%	} %>
<% } %>



</table>
</body>
</html>