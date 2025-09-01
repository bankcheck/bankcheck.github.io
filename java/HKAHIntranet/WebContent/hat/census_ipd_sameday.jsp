<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page language="java" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
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
     font-size:13px; background:lightblue; text-align:center; }
</style>
</head>

<title>Inpatient Hospital Days (Midnight + Sameday)</title>

<body bgcolor=#F9F3F6>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.mis.census.ipd" />
</jsp:include>

<table border=0>
<tr><td width=8% valign=top>
    <p align=center><br><br><br><br>
    <Font style="font-size:13px;font-weight:bold;">Year</font>
    <br>

<%
/*======== Description of this page ===========
  Log: 20090922, ck.
================================================ */
  
//======== connect to database ===========
String thisYear = request.getParameter("y");
String thisURL  = request.getRequestURL().toString();

String sql, s1="", s2, prevYear, prevMth;
int sum1=0, sum2=0, acc1=0, acc2=0, cnt=0; 
int cntOpd1, cntOpd2, lastMth=0, varMonth, varYear;

DecimalFormat pctFormat = new DecimalFormat();
pctFormat.applyPattern("0.00%");

// ======list of year ============
sql = " select distinct to_char(cnt_date,'yyyy') from mis_bedcnt order by 1 desc ";

ArrayList record = UtilDBWeb.getReportableListCIS(sql);
ReportableListObject row = null;
for (int i = 0; i < record.size(); i++) {
   row = (ReportableListObject) record.get(i);
   s1 = row.getValue(0);
   if (thisYear==null) thisYear = s1;
   out.println( "<br>&nbsp;<a href="+thisURL+"?y=" + s1 + "><b>" + s1 + "</b></a>" );
};

prevYear = ""+(Integer.parseInt(thisYear)-1);
prevMth  = prevYear+"12";
%>

    </p>
 </td>   

<!-- right area, data -->
  <td><br>
    <p align=center>
       <font style="font-size:16px;font-weight:bold;color:darblue">
       <b>Inpatient Hospital Days (Midnight + Sameday)</b></font>
    </p>

    <table align=center width=90% border=1 cellpadding="0" cellspacing="0">
      <tr>
       <th width=80 height=40>&nbsp;Month</th>
       <th width=180>&nbsp;<%=prevYear%><br>
           <table width=90% border=0><tr><td>Hospital Days<td align=right>YTM</tr></table></th>
       <th width=180>&nbsp;<%=thisYear%><br>
           <table width=90% border=0><tr><td>Hospital Days<td align=right>YTM</tr></table></th>
       <th width=180>Changes Compare<br>with Prev Month</th>
       <th width=180>Changes Compare<br>with Prev Year</th>
      </tr>

<%
//========== get op cnt for prev month =========
sql = " select sum(cnt_midnight+cnt_sameday) as cnt from mis_bedcnt  ";
sql += "  where deptcode='ALL' and to_char(cnt_date,'yyyymm')='"+prevMth+"' ";
record = UtilDBWeb.getReportableListCIS(sql);
if (record.size() > 0) {
   row = (ReportableListObject) record.get(0);
   try {
      lastMth = Integer.parseInt(row.getValue(0));
   } catch (Exception e) {}
}

//========== get op cnt for each month =========
sql =  " select substr(mth,5) as month, mon  ";
sql += "   , sum(case when substr(mth,1,4)='"+prevYear+"' then cnt else 0 end) as cnt_comp  ";
sql += "   , sum(case when substr(mth,1,4)='"+thisYear+"' then cnt else 0 end) as cnt_this  ";
sql += " from (select to_char(cnt_date,'yyyymm') as mth ";
sql += "            , to_char(cnt_date,'MON','NLS_DATE_LANGUAGE = AMERICAN') as mon ";
sql += "            , sum(cnt_midnight+cnt_sameday) as cnt  ";
sql += "       from mis_bedcnt  ";
sql += "       where deptcode='ALL' and to_char(cnt_date,'yyyy') in ('"+prevYear+"','"+thisYear+"') ";
sql += "         and (to_char(sysdate,'yyyy')>'"+thisYear+"' or to_char(cnt_date,'mm')<to_char(sysdate,'mm')) ";
sql += "       group by to_char(cnt_date,'yyyymm'), to_char(cnt_date,'MON','NLS_DATE_LANGUAGE = AMERICAN')  ";
sql += "       ) x  ";
sql += " group by substr(mth,5), mon order by 1";

record = UtilDBWeb.getReportableListCIS(sql);
for (int i = 0; i < record.size(); i++) {
   row = (ReportableListObject) record.get(i);
   try {
      cntOpd1 = Integer.parseInt(row.getValue(2));
   } catch (Exception e) {
	  cntOpd1 = 0;
   }
   try {
	   cntOpd2 = Integer.parseInt(row.getValue(3));
   } catch (Exception e) {
	   cntOpd2 = 0;
   }
   acc1 += cntOpd1;
   acc2 += cntOpd2;
   varMonth = cntOpd2 - lastMth;
   varYear  = cntOpd2 - cntOpd1;
   
   out.println( "<tr><td align=center><b>&nbsp;" + row.getValue(1) + "</b></td>" );
   
   out.println( "<td><table width=90% align=center border=0><tr>");
   out.println( "  <td width=50% align=right>"+(cntOpd1==0?"&nbsp;":cntOpd1)+"</td>");
   out.println( "  <td width=50% align=right>"+(cntOpd1==0?"&nbsp;":acc1)+"</tr></table></td>" );
   
   out.println( "<td><table width=90% align=center border=0><tr>");
   out.println( "  <td width=50% align=right>"+(cntOpd2==0?"&nbsp;":cntOpd2)+"</td>");
   out.println( "  <td width=50% align=right>"+(cntOpd2==0?"&nbsp;":acc2)+"</tr></table></td>" );
   
   if ( cntOpd2>0  ) {
     out.println( "<td><table width=90% align=center border=0><tr><td width=50% align=right>"+varMonth+"</td>");
     out.println( "<td width=50% align=right>"+pctFormat.format( 1.00 * varMonth/lastMth)+"</tr></table></td>" );
     out.println( "<td><table width=90% align=center border=0><tr><td width=50% align=right>"+varYear+"</td>");
     out.println( "<td width=50% align=right>"+pctFormat.format( 1.00 * varYear/cntOpd1)+"</tr></table></td>" );
   } else {
     out.println( "<td><table width=90% align=center border=0><tr><td width=50% align=right>&nbsp;</td>");
     out.println( "<td width=50% align=right>&nbsp;</tr></table></td>" );
     out.println( "<td><table width=90% align=center border=0><tr><td width=50% align=right>&nbsp;</td>");
     out.println( "<td width=50% align=right>&nbsp;</tr></table></td>" );
   };
   
   out.println( "</tr>" );

   lastMth =  cntOpd2;
   cnt++;
};   

out.println( "<tr height=25 bgcolor=#E0E0FF><td align=center><b>Total:</td>");
out.println( " <td align=right><b>"+acc1+"&nbsp;&nbsp;&nbsp;</td>");
out.println( " <td align=right><b>"+acc2+"&nbsp;&nbsp;&nbsp;</td><td>&nbsp;</td>");
out.println( " <td align=right><b>"+pctFormat.format(1.00*(acc2-acc1)/acc1) );
out.println( " &nbsp;&nbsp;&nbsp;</td></tr>" );
%>

</table>

<br>
<table width=90% align=center border=0>
<tr><td>PS: not include "new-Born" patients.
</td></tr>
</table>


 </td></tr>
</table>

</html>


