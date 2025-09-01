<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%!
	private ArrayList getMonthYear() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select distinct to_char(cnt_date,'yyyymm') from MIS_BEDCNT where deptcode='ALL' order by 1 desc ");

		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}

	private ArrayList getMonthlyRecord(String mth) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select to_char(cnt_date,'dd/mm/yyyy'), cnt_bedtotal, cnt_inpatient, cnt_admission, ");
		sqlStr.append("       cnt_discharge, cnt_midnight, ");
		sqlStr.append("       cnt_midnight/cnt_bedtotal, cnt_inpatient/cnt_bedtotal ");
		sqlStr.append("from   MIS_BEDCNT ");
		sqlStr.append("where  deptcode='ALL' ");
		sqlStr.append("and    to_char(cnt_date,'yyyymm') = ");
		if (mth == null) {
			sqlStr.append("to_char(sysdate,'yyyymm') ");
		} else {
			sqlStr.append("'");
			sqlStr.append(mth);
			sqlStr.append("' ");
		}
		sqlStr.append("order by cnt_date ");

		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}

	private int string2Int(String value) {
		try {
			return Integer.parseInt(value);
		} catch (Exception e) {
			return 0;
		}
	}

	private double string2Double(String value) {
		try {
			return Double.parseDouble(value);
		} catch (Exception e) {
			return 0.0;
		}
	}
%>
<%@ page contentType="text/html; charset=UTF-8"%>
<html>
<meta http-equiv="refresh" content=1200>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<jsp:include page="../common/header.jsp"/>
<head>

<style>
 body { margin-left:0px; margin-top:0px;	margin-right:0px; margin-bottom:0px; color:black;
        font-family: "Arial", "Verdana", "sans-serif";  font-size:12px; }
A:link { color:blue; text-decoration: none; }
A:visited { color:#3388DD; text-decoration: none; }
A:hover { color:red; background-color:skyblue; text-decoration:none;}
TD { font-family: "Arial", "Verdana", "sans-serif"; font-size:12px; }
TH { font-family: "Arial", "Verdana", "sans-serif"; font-weight:bold;
     font-size:13px; background:#F0CCF0; text-align:center; }
</style>
</head>

<title>Bed Occupancy Census</title>
<body bgcolor=#F9F3F6>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.bed.occupancy.view" />
</jsp:include>
<%
/*======== Description of this page ===========
  Log: 20090724, ck.
================================================ */

//======== connect to database ===========
String mth = request.getParameter("m");
%>


<table border="0" >
<tr><td width="10%" valign="top">
      <p align=center><br><b>Month</b><br>

<%
// ======list of month ============
ReportableListObject row = null;
ArrayList record = getMonthYear();
if (record.size() > 0) {
	for (int i = 0; i < record.size() && i < 28; i++) {
		row = (ReportableListObject) record.get(i);
		out.print( "<br>&nbsp;<a href=bed_census.jsp?m=" + row.getValue(0) + ">" + row.getValue(0) + "</a>" );
	}
}
%>
      </p>
   </td>


<!-- right area, data -->
  <td valign="top"><br>
    <!--p align=center>
       <font size=3><b>Bed Occupancy Census</b></font>
    </p-->

    <table align=center width=90% border=1 cellpadding="0" cellspacing="0">
      <tr>
       <th width=120 height=30>&nbsp;Date</th>
       <th width=120>&nbsp;Admission</th>
       <th width=120>&nbsp;Discharge</th>
       <th width=120>&nbsp;Inpatient (Midnight)</th>
       <th width=120>&nbsp;Occupancy (Midnight)</th>
       <th width=120>&nbsp;Inpatient (Fullday)</th>
       <th width=120>&nbsp;Occupancy (Fullday)</th>
       <th width=120>&nbsp;No. of Bed</th>
      </tr>

<%
int sumBed=0, sumInp=0, sumMid=0, sumReg=0, sumDis=0, count=0 ;
int cntInp, cntBed, cntDis=0, cntReg, cntChg, cntMid;

DecimalFormat pctFormat = new DecimalFormat();
pctFormat.applyPattern("0.00%");
DecimalFormat pctFormat2 = new DecimalFormat();
pctFormat2.applyPattern("0.0");

//========== get bed list =========
record = getMonthlyRecord(mth);
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		cntBed = string2Int(row.getValue(1));
		cntInp = string2Int(row.getValue(2));
		cntReg = string2Int(row.getValue(3));
		cntChg = (count==0? 0 : cntReg - cntDis );
		cntDis = string2Int(row.getValue(4));
		cntMid = string2Int(row.getValue(5));
		out.println( "<tr><td align=center>&nbsp;" + row.getValue(0) + "</td>" );
//		out.println( "<td align=center>&nbsp;" + (count==0? "":cntChg) + "</td>" );
		out.println( "<td align=center>&nbsp;" + cntReg + "</td>" );
		out.println( "<td align=center>&nbsp;" + cntDis + "</td>" );
		out.println( "<td align=center>&nbsp;" + cntMid + "</td>" );
		out.println( "<td align=center>&nbsp;" + pctFormat.format(string2Double(row.getValue(6))) + "</td>" );
		out.println( "<td align=center>&nbsp;" + cntInp + "</td>" );
		out.println( "<td align=center>&nbsp;" + pctFormat.format(string2Double(row.getValue(7))) + "</td>" );
		out.println( "<td align=center>&nbsp;" + cntBed + "</td></tr>" );
		count++;
		sumBed += cntBed;
		sumMid += cntMid;
		sumInp += cntInp;
		sumReg += cntReg;
		sumDis += cntDis;
	}
}

count = ( count==0? 1 : count );
out.println( "<tr><th align=right>&nbsp;<b>Total: </th>" );
out.println( "<th>&nbsp;" + sumReg + "</th>" );
out.println( "<th>&nbsp;" + sumDis + "</th>" );
out.println( "<th>&nbsp;Avg: " + pctFormat2.format( 1.00 * sumMid/count ) + "</th>" );
out.println( "<th>&nbsp;" + pctFormat.format( 1.00 * sumMid / sumBed ) + "</th>" );
out.println( "<th>&nbsp;Avg: " + pctFormat2.format( 1.00 * sumInp/count ) + "</th>" );
out.println( "<th>&nbsp;" + pctFormat.format( 1.00 * sumInp / sumBed ) + "</th>" );
out.println( "<th>&nbsp;Avg: " + pctFormat2.format( 1.00 * sumBed/count ) + "</th></TR>" );
%>

</table>

<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
PS: All wards, not include "new-Born" patients.

<br><br>

 </td></tr>
</table>

</html>