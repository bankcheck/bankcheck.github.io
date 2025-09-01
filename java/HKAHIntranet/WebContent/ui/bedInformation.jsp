<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@	page import="java.text.*"%>

<%!private ArrayList<ReportableListObject> fetchOccupBedInformation(String date, String ward, String acm) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT H.HAT_BEDCODE, D.DOCFNAME, D.DOCGNAME, D.DOCCNAME, W.WRDNAME, DECODE(H.HAT_STATUS, 'F', 'Occupied', 'C', 'Discharge') ");
		sqlStr.append("FROM HAT_BED_BOOKED H, DOCTOR@IWEB D, WARD@IWEB W ");
		sqlStr.append("WHERE H.HAT_PERIOD >= TO_DATE('"+date+" 00:00:00', 'dd/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND H.HAT_PERIOD <= TO_DATE('"+date+" 23:59:59', 'dd/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND H.HAT_WRDCODE = '"+ward.toUpperCase()+"' ");
		sqlStr.append("AND H.HAT_WRDCODE = W.WRDCODE ");
		sqlStr.append("AND H.HAT_DOCCODE = D.DOCCODE ");
		sqlStr.append("AND H.HAT_ACMCODE in (SELECT A.ACMCODE FROM ACM@IWEB A WHERE A.ACMNAME like '"+acm.toUpperCase()+"') ");
		sqlStr.append("AND (H.HAT_STATUS = 'F') ");
		sqlStr.append("ORDER BY H.HAT_WRDCODE, H.HAT_ACMCODE,H.HAT_BEDCODE ");
		/*
		sqlStr.append("SELECT I.BEDCODE, D.DOCFNAME, D.DOCGNAME, D.DOCCNAME, W.WRDNAME ");
		sqlStr.append("FROM   INPAT@IWEB I, REG@IWEB R, BED@IWEB B, ROOM@IWEB M, WARD@IWEB W, DOCTOR@IWEB D, BEDPREBOK@IWEB P ");
		sqlStr.append("WHERE  I.INPID = R.INPID ");
		sqlStr.append("AND    I.BEDCODE = B.BEDCODE ");
		sqlStr.append("AND    B.ROMCODE = M.ROMCODE ");
		sqlStr.append("AND    M.WRDCODE = W.WRDCODE ");
		sqlStr.append("and    R.DOCCODE = D.DOCCODE ");
		sqlStr.append("AND    M.WRDCODE  = '"+ward.toUpperCase()+"' ");
		sqlStr.append("AND    I.ACMCODE  in (SELECT A.ACMCODE FROM ACM@IWEB A WHERE A.ACMNAME like '"+acm.toUpperCase()+"') ");
		sqlStr.append("AND    R.PBPID = P.PBPID ");
		sqlStr.append("AND    M.WRDCODE IS NOT NULL ");
		sqlStr.append("AND    I.ACMCODE IS NOT NULL ");
		sqlStr.append("AND ");
		sqlStr.append("( ");
		sqlStr.append("  ( ");
		sqlStr.append("    I.INPDDATE IS NULL ");
		sqlStr.append("    AND    ( ");
		sqlStr.append("              ( ");
		sqlStr.append("                ((P.ESTSTAYLEN IS NULL OR P.ESTSTAYLEN = 0) ");
		sqlStr.append("                AND R.REGDATE >= (TO_DATE('"+date+" 00:00:00', 'dd/MM/YYYY HH24:MI:SS') - 2) ");
		sqlStr.append("                AND R.REGDATE <= TO_DATE('"+date+" 23:59:59', 'dd/MM/YYYY HH24:MI:SS')) ");
		sqlStr.append("                OR ");    
		sqlStr.append("                (ESTSTAYLEN IS NOT NULL ");
		sqlStr.append("                AND R.REGDATE >= (TO_DATE('"+date+" 00:00:00', 'dd/MM/YYYY HH24:MI:SS') - P.ESTSTAYLEN + 1) ");
		sqlStr.append("                AND R.REGDATE <= TO_DATE('"+date+" 23:59:59', 'dd/MM/YYYY HH24:MI:SS')) ");
		sqlStr.append("              ) ");
		sqlStr.append("           ) ");
		sqlStr.append("  ) ");
		sqlStr.append("  OR ");
		sqlStr.append("  ( ");
		sqlStr.append("    I.INPDDATE IS NOT NULL ");
		sqlStr.append("    AND    ( ");
		sqlStr.append("            ( ");
		sqlStr.append("              ((P.ESTSTAYLEN IS NULL OR P.ESTSTAYLEN = 0) ");
		sqlStr.append("              AND I.INPDDATE >= (TO_DATE('"+date+" 00:00:00', 'dd/MM/YYYY HH24:MI:SS') - 2) ");
		sqlStr.append("              AND I.INPDDATE <= TO_DATE('"+date+" 23:59:59', 'dd/MM/YYYY HH24:MI:SS')) ");
		sqlStr.append("              OR ");
		sqlStr.append("              (P.ESTSTAYLEN IS NOT NULL ");
		sqlStr.append("              AND I.INPDDATE >= (TO_DATE('"+date+" 00:00:00', 'dd/MM/YYYY HH24:MI:SS') - P.ESTSTAYLEN + 1) ");
		sqlStr.append("              AND I.INPDDATE <= TO_DATE('"+date+" 23:59:59', 'dd/MM/YYYY HH24:MI:SS')) ");
		sqlStr.append("            ) ");
		sqlStr.append("         ) ");
		sqlStr.append("  ) ");
		sqlStr.append(") ");
		sqlStr.append("AND    R.REGSTS = 'N' ORDER BY M.WRDCODE, I.ACMCODE,I.BEDCODE ");
		*/
		System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList<ReportableListObject> fetchBookedInformation(String date, String ward, String acm, String type) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT W.WRDNAME, H.HAT_PATNAME, H.HAT_PATCNAME, D.DOCFNAME, D.DOCGNAME, D.DOCCNAME ");
		sqlStr.append("FROM HAT_BED_BOOKED H, DOCTOR@IWEB D, WARD@IWEB W ");
		sqlStr.append("WHERE H.HAT_PERIOD >= TO_DATE('"+date+" 00:00:00', 'dd/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND H.HAT_PERIOD <= TO_DATE('"+date+" 23:59:59', 'dd/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND H.HAT_WRDCODE = '"+ward.toUpperCase()+"' ");
		sqlStr.append("AND H.HAT_WRDCODE = W.WRDCODE ");
		sqlStr.append("AND H.HAT_DOCCODE = D.DOCCODE ");
		sqlStr.append("AND H.HAT_ACMCODE in (SELECT A.ACMCODE FROM ACM@IWEB A WHERE A.ACMNAME like '"+acm.toUpperCase()+"') ");
		sqlStr.append("AND H.HAT_STATUS = 'B' ");
		if(type.equals("others")) {
			sqlStr.append("AND    H.HAT_BOOKED_OT = '0' ");
			sqlStr.append("AND    H.HAT_BOOKED_CCIC = '0' ");
		}
		else if(type.equals("ot")) {
			sqlStr.append("AND    H.HAT_BOOKED_OT = '1' ");
		}
		else if(type.equals("ccic")) {
			sqlStr.append("AND    H.HAT_BOOKED_CCIC = '1' ");
		}
		/*sqlStr.append("SELECT W.WRDNAME, B.BPBPNAME, B.BPBCNAME, D.DOCFNAME, D.DOCGNAME, D.DOCCNAME ");
		sqlStr.append("FROM   BEDPREBOK@IWEB B, DOCTOR@IWEB D, WARD@IWEB W ");
		
		if(true) {
			sqlStr.append("WHERE (((B.ESTSTAYLEN IS NULL OR B.ESTSTAYLEN = 0) AND B.BPBHDATE >= (TO_DATE('"+date+" 00:00:00', 'dd/MM/YYYY HH24:MI:SS') - 2) "); 
			sqlStr.append("AND B.BPBHDATE <= (TO_DATE('"+date+" 23:59:59', 'dd/MM/YYYY HH24:MI:SS'))) ");
			sqlStr.append("OR (B.ESTSTAYLEN IS NOT NULL  AND B.BPBHDATE >= (TO_DATE('"+date+" 00:00:00', 'dd/MM/YYYY HH24:MI:SS') - B.ESTSTAYLEN + 1) ");
			sqlStr.append("AND B.BPBHDATE <= (TO_DATE('"+date+" 23:59:59', 'dd/MM/YYYY HH24:MI:SS')))) ");
		}else {
		    sqlStr.append("WHERE  B.BPBHDATE >= TO_DATE('"+date+" 00:00:00', 'dd/MM/YYYY HH24:MI:SS') ");
			sqlStr.append("AND 	 B.BPBHDATE <= TO_DATE('"+date+" 23:59:59', 'dd/MM/YYYY HH24:MI:SS') ");
		}
		
		sqlStr.append("AND    B.BPBSTS NOT IN ('F', 'D') ");
		sqlStr.append("AND    B.WRDCODE = '"+ward.toUpperCase()+"' ");
		sqlStr.append("AND    B.ACMCODE in (SELECT A.ACMCODE FROM ACM@IWEB A WHERE A.ACMNAME like '"+acm.toUpperCase()+"') ");
		sqlStr.append("AND    B.DOCCODE = D.DOCCODE ");
		sqlStr.append("AND    W.WRDCODE = B.WRDCODE ");
		if(type.equals("others")) {
			sqlStr.append("AND    B.OTAID IS NULL ");
			sqlStr.append("AND    B.CABLABRMK IS NULL ");
		}
		else if(type.equals("ot")) {
			sqlStr.append("AND    B.OTAID IS NOT NULL ");
		}
		else if(type.equals("ccic")) {
			sqlStr.append("AND    B.CABLABRMK IS NOT NULL");
		}*/
		
		System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
%>

<%
	String date = request.getParameter("date");
	String ward = request.getParameter("ward");
	String acm = request.getParameter("acm");
	String type = request.getParameter("type");
	
	ArrayList<ReportableListObject> record = null;
	ReportableListObject row = null;
	String wardName = "";
	String bookTypes[] = new String[]{"others", "ot", "ccic"};

	if(type.equals("booked")) {
%>
<table style="width: 100%; overflow:scroll;">
	<tbody>
<%
		for(String bkType: bookTypes) {
			record = fetchBookedInformation(date, ward, acm, bkType);
			if (record.size() > 0) {
%>
	<tr style="height:20px"><td></td></tr>
	<tr><td colspan="2" class="available" style="border-style: outset; border-width: 1px;"><%=bkType.toUpperCase() %></td></tr>
	<tr>
		<td class="title" style="border-style: outset; border-width: 1px;">Patient</td>
		<td class="title" style="border-style: outset; border-width: 1px;">Doctor Name</td>
	</tr>
<%

				for (int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);
					wardName = row.getValue(0);
%>
	<tr>
		<td class="content"><%=row.getValue(1)%> <%=row.getValue(2)%></td>
		<td class="content"><%=row.getValue(3)%> <%=row.getValue(4)%> <%=row.getValue(5)%></td>
	</tr>
<%
				}
			}
		}
	}else {
		record = fetchOccupBedInformation(date, ward, acm);
%>
<table style="width: 100%; overflow:scroll;">
	<tbody>
	<tr>
		<td class="title" style="border-style: outset; border-width: 1px;">Bed</td>
		<td class="title" style="border-style: outset; border-width: 1px;">Doctor Name</td>
		<td class="title" style="border-style: outset; border-width: 1px;">Status</td>
	</tr>
	<tr></tr>
	<%
		if (record.size() > 0) {
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				wardName = row.getValue(4);
	%>
	<tr>
		<td class="content" style="width:20%"><%=row.getValue(0)%></td>
		<td class="content"><%=row.getValue(1)%> <%=row.getValue(2)%> <%=row.getValue(3)%></td>
		<td class="content"><%=row.getValue(5)%> </td>
	</tr>
	<%
			}
		}
	}
	%>
	<tr>
		<td id="infoWard" style="display:none;"><%=wardName%></td>
		<td id="infoACM" style="display:none;"><%=acm.toUpperCase()%></td>
	</tr>
	</tbody>
</table>
<%%>