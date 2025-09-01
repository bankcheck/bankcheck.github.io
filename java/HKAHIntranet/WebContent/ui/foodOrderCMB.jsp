<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@page import="java.util.*"%>
<%@page import="com.hkah.servlet.*"%>
<%@page import="com.hkah.util.*"%>
<%@page import="com.hkah.util.db.*"%>
<%@page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>

<%!
	private ArrayList getFoodOrder(String counter) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select serve_type, serve_time, item_code, item_opt, "); 
		sqlStr.append("item_name2 as cook_name, "); 
		sqlStr.append("sum(case when b.status ='X' then 0 else order_qty end) - nvl( ");
		sqlStr.append("(select sum(ready_qty) ");
		sqlStr.append("from dit_kitchen x ");
		sqlStr.append("where to_char(update_date,'yyyymmdd') = to_char(sysdate,'yyyymmdd') ");
		sqlStr.append("and x.status<>'X' and x.serve_time = b.serve_time ");
		sqlStr.append("and (x.serve_type is null or x.serve_type=b.serve_type) ");
		sqlStr.append("and x.item_code=a.item_code and item_name2=x.item_name ");
		sqlStr.append("and nvl(x.item_opt,'{NULL}')=nvl(a.item_opt,'{NULL}') ) ");
		sqlStr.append(",0) as cook_qty ");
		sqlStr.append("from dit_order_dtl a, dit_order_hdr b ");
		sqlStr.append("where a.order_no=b.order_no ");
		sqlStr.append("and to_char(serve_date,'yyyymmdd') = to_char(sysdate,'yyyymmdd') ");
		sqlStr.append("and a.kitchen = 'main' ");
		sqlStr.append("group by serve_type, serve_time, item_code, item_opt, item_name2 ");

		return UtilDBWeb.getReportableListFSD(sqlStr.toString());
	}
%>

<%
String counter = request.getParameter("count");
ArrayList record = getFoodOrder(counter);
ReportableListObject row = null;
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

%>
<table style="width:100%;">
		<tr>
			<td style="width:20%;"><label>Time</label></td>
			<td style="width:70%;"><label>Name</label></td>
			<td style="width:10%;"><label>Qty</label></td>
		</tr>
<%
int end = ((record.size()-Integer.parseInt(counter))<5)?(record.size()):(Integer.parseInt(counter)+5);

if(record.size() > 0) {
	for(int i = Integer.parseInt(counter); i < end; i++) {
		row = (ReportableListObject)record.get(i);
		String serveType = "";
		//if(Integer.parseInt(row.getValue(5)) > 0) {
			if(row.getValue(0).equals("B")) {
				serveType = "早餐";
			}
			else if(row.getValue(0).equals("L")) {
				serveType = "午餐";
			}
			else if(row.getValue(0).equals("D")) {
				serveType = "晚餐";
			}
			else if(row.getValue(0).equals("S")) {
				serveType = "小食";
			}
	%>
			<tr>
				<td><label><%=row.getValue(1) %></label><br/><label><%=serveType %></label></td>
				<td><label><%=row.getValue(4) %></label></td>
				<td><label><%=row.getValue(5) %></label></td>
			</tr>
	<%
		}
	//}
}
%>
</table>
<label id="reset" style="display:none"><%=(record.size()-Integer.parseInt(counter))<=5?"true":"false" %></label>