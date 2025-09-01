<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@	page import="java.text.*"%>

<%!
	private ArrayList<ReportableListObject> fetchBedBookingDetail(String date, 
														String ward, String type) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT B.BPBPNAME, B.BPBCNAME, D.DOCFNAME, D.DOCGNAME, D.DOCCNAME, ");
		sqlStr.append("Decode(abs(BPBHDATE - (SYSDATE-1)), BPBHDATE - (SYSDATE-1), ");
		sqlStr.append("Decode(BPBSTS, 'N', 'Normal', Decode(BPBSTS, 'F', 'In House', 'Cancel')), ");
		sqlStr.append("0, Decode(BPBSTS, 'N', 'Normal', Decode(BPBSTS, 'F', 'In House', 'Cancel')), ");
		sqlStr.append("Decode(BPBSTS, 'N', 'No Show', Decode(BPBSTS, 'F', 'In House', 'Cancel'))) AS STATUS ");
		sqlStr.append("FROM BEDPREBOK@IWEB B, DOCTOR@IWEB D ");
		sqlStr.append("WHERE B.WRDCODE = '"+ward+"' ");
		sqlStr.append("AND B.BPBHDATE >= TO_DATE('"+date+" 00:00:00', 'dd/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND B.BPBHDATE <= TO_DATE('"+date+" 23:59:59', 'dd/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND D.DOCCODE = B.DOCCODE ");
		
		if(type.equals("noshow")) {
			sqlStr.append("AND B.BPBSTS = 'N' ");
			sqlStr.append("AND (B.BPBHDATE - (SYSDATE - 1)) < 0 ");
		}
		else if(type.equals("cancel")) {
			sqlStr.append("AND B.BPBSTS = 'D' ");
		}
		else if(type.equals("booking")) {
		}
		
		sqlStr.append("ORDER BY STATUS ");
		System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

%>

<%
	String date = request.getParameter("date");
	String ward = request.getParameter("ward");
	String type = request.getParameter("type");
	
	ArrayList<ReportableListObject> record = null;
	ReportableListObject row = null;
	
	record = fetchBedBookingDetail(date, ward, type);

%>
<table style="width: 100%; overflow:scroll;">
	<tbody>
<%
	if(record.size() > 0) {
%>
		<tr style="height:20px"><td></td></tr>
		<tr>
			<td class="title" style="border-style: outset; border-width: 1px;">Patient</td>
			<td class="title" style="border-style: outset; border-width: 1px;">Doctor Name</td>
			<td class="title" style="border-style: outset; border-width: 1px;">Status</td>
		</tr>
<%
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
%>
		<tr>
			<td class="content"><%=row.getValue(0)%> <%=row.getValue(1)%></td>
			<td class="content"><%=row.getValue(2)%> <%=row.getValue(3)%> <%=row.getValue(4)%></td>
			<td class="content"><%=row.getValue(5)%></td>
		</tr>
<%
		}
	}
	
%>
	</tbody>
</table>