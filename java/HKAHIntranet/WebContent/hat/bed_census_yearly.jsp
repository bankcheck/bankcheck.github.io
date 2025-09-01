<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%!
	private ArrayList getYearlyRecord() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select to_char(cnt_date,'yyyy'), SUM(cnt_bedtotal), SUM(cnt_inpatient), SUM(cnt_admission), ");
		sqlStr.append("       SUM(cnt_discharge), SUM(cnt_midnight), ");
		sqlStr.append("       SUM(cnt_midnight)/SUM(cnt_bedtotal), SUM(cnt_inpatient)/SUM(cnt_bedtotal) ");
		sqlStr.append("from   MIS_BEDCNT ");
		sqlStr.append("where  deptcode='ALL' ");
		sqlStr.append("and    cnt_date >= to_date('01/01/2007', 'dd/mm/yyyy') ");
		sqlStr.append("and    cnt_date < to_date('01/01/' || to_char(sysdate, 'yyyy'), 'dd/mm/yyyy') ");
		sqlStr.append("group by to_char(cnt_date,'yyyy') ");
		sqlStr.append("order by to_char(cnt_date,'yyyy') DESC ");

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
%>


<table border=0 >
<tr>
<!-- right area, data -->
  <td><br>
    <!--p align=center>
       <font size=3><b>Bed Occupancy Census</b></font>
    </p-->

    <table align=center width=90% border=1 cellpadding="0" cellspacing="0">
      <tr>
       <th width=120 height=30>&nbsp;Year</th>
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
int cntBed, cntInp, cntDis=0, cntReg, cntChg, cntMid;
double avgOccMid=0, avgOccFull=0;

DecimalFormat pctFormat = new DecimalFormat();
pctFormat.applyPattern("0.00%");
DecimalFormat pctFormat2 = new DecimalFormat();
pctFormat2.applyPattern("0.0");

//========== get bed list =========
ReportableListObject row = null;
ArrayList record = getYearlyRecord();
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		cntBed = string2Int(row.getValue(1));
		cntInp = string2Int(row.getValue(2));
		cntReg = string2Int(row.getValue(3));
		cntChg = (count==0? 0 : cntReg - cntDis );
		cntDis = string2Int(row.getValue(4));
		cntMid = string2Int(row.getValue(5));
		avgOccMid = string2Double(row.getValue(6));
		avgOccFull = string2Double(row.getValue(7));
		out.println( "<tr><td align=center>&nbsp;" + row.getValue(0) + "</td>" );
//		out.println( "<td align=center>&nbsp;" + (count==0? "":cntChg) + "</td>" );
		out.println( "<td align=center>&nbsp;" + cntReg + "</td>" );
		out.println( "<td align=center>&nbsp;" + cntDis + "</td>" );
		out.println( "<td align=center>&nbsp;" + cntMid + "</td>" );
		out.println( "<td align=center>&nbsp;" + pctFormat.format(avgOccMid) + "</td>" );
		out.println( "<td align=center>&nbsp;" + cntInp + "</td>" );
		out.println( "<td align=center>&nbsp;" + pctFormat.format(avgOccFull) + "</td>" );
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