<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page language="java" import="com.hkah.servlet.HKAHInitServlet"%>
<%@ page language="java" import="java.text.*" %>
<%@ page language="java" import="java.util.*" %>
<%@ page language="java" import="javax.sql.*" %>
<%@ page language="java" import="java.sql.*" %>
<%@ page language="java" import="javax.naming.*" %>

<html>
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

<title>Census</title>
<body bgcolor=#F9F3F6>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.mis.census.year" />
</jsp:include>

<table border=0>
<tr><td width=40 valign=top>
    <p style="font-size:13px;font-weight:bold;text-align=center;">
    <br><br><br><br>Year<br>

<%
/*======== Description of this file =============================
  Log: 20091218, ck. Revenue Report From Table MIS_COUNT
================================================================ */
  
//======== connect to database ===========
String thisURL   = request.getRequestURL().toString();
String thisYear  = request.getParameter("y");
String thisMonth = request.getParameter("m");
String cntGroup  = "RevenueByDept";
String cntName   = request.getParameter("n");

DataSource ds = HKAHInitServlet.getDataSourceCIS();
Connection con = ds.getConnection();
Statement stmt = con.createStatement();
String sql, s1="", s2, prevYear, prevMth;
ResultSet rs;
int acc1=0, acc2=0, acc3=0, acc4=0, acc5=0, acc6=0, acc7=0, acc8=0;
int acc9=0, accA=0, accB=0, accC=0, accD=0, accE=0;
int val1=0, val2=0, val3=0, val4=0, val5=0, val6=0, val7=0, val8=0;
int val9=0, valA=0, valB=0, valC=0, valD=0, valE=0;
int lastMth=0, varMonth, varYear, cnt=0;

DecimalFormat pctFormat = new DecimalFormat();
pctFormat.applyPattern("#,##0");

// ====== get report title, and remarks ============
String eTitle = "Revenue By Dept";
String cTitle, Remarks="v.2010.01.14", LastUpdate="";

sql  = " select code_value1, code_value2, remarks from ah_sys_code ";
sql += " where sys_id='WEB' and code_type='REPORT' and code_no='" + cntGroup+"."+cntName+"' ";
rs  = stmt.executeQuery(sql);
if  (rs.next()) {
   eTitle  = rs.getString(1);
   cTitle  = rs.getString(2); 
   Remarks = rs.getString(3);
};

// ======list of year ============
sql = " select distinct to_char(cnt_date,'yyyy') from mis_count ";
sql += " where cnt_group='" + cntGroup + "'  order by 1 desc ";
rs  = stmt.executeQuery(sql);

while (rs.next()) {
   s1 = rs.getString(1);
   if (thisYear==null) thisYear = s1;
   if (thisYear.equals(s1)) {
     out.println( "<br>&nbsp;<font color=darkred>" + s1 + "</font>"  );
   } else {
     out.println( "<br>&nbsp;<a href="+thisURL+"?n="+cntName+"&y="+s1+">" + s1 + "</a>" );
   }  
};

if (thisYear==null) thisYear = "2009";
if (thisMonth==null) thisMonth = "%";
%>
    </b>
    </p>
 </td>   

<td width=40 valign=top>
    <p style="font-size:13px;font-weight:bold;text-align=center;">
    <br><br><br><br>Month<br>
    <br>&nbsp;<font color=blue>

<%
sql = " select distinct to_char(cnt_date,'mm'), to_char(cnt_date,'Mon','NLS_DATE_LANGUAGE = AMERICAN') ";
sql += "  from mis_count where cnt_group='" + cntGroup + "'" ;
sql += "    and to_char(cnt_date,'yyyy')='"+thisYear+"' order by 1 desc ";
rs  = stmt.executeQuery(sql);
out.println( "<a href="+thisURL+"?n="+cntName+"&y="+thisYear+">*All*</a>" );

while (rs.next()) {
   s1 = rs.getString(1);
   if (thisMonth.equals(s1)) {
     out.println( "<br>&nbsp;<font color=darkred>" + rs.getString(2) + "</font>"  );
   } else {
     out.println( "<br>&nbsp;<a href="+thisURL+"?n="+cntName+"&y="+thisYear+"&m="+s1+">" + rs.getString(2) + "</a>" );
   }  
};
%>
    </p>
</td>   

<!-- right area, data -->
  <td><br>
    <p align=center>
       <font style="font-size:16px;font-weight:bold;color:darblue">
       <b> <%= eTitle + " -- " + thisYear + thisMonth  %> </b></font>
    </p>

    <table align=center width=96% border=1 cellpadding="0" cellspacing="0">

<%
out.println( "<tr>");
out.println( " <th width=280 height=35>&nbsp;Specialty</th>");
out.println( " <th width=80 align=center><b>Cath Lab</th>");
out.println( " <th width=80 align=center><b>Cyber knife</th>");
out.println( " <th width=80 align=center><b>OT</th>");
out.println( " <th width=80 align=center><b>ENDO</th>");
out.println( " <th width=80 align=center><b>DI</th>");
out.println( " <th width=80 align=center><b>Lab</th>");
out.println( " <th width=80 align=center><b>Pharmacy</th>");
out.println( " <th width=80 align=center><b>Cardio Lab</th>");
out.println( " <th width=80 align=center><b>PT</th>");
out.println( " <th width=80 align=center><b>Wards / OP</th>");
out.println( " <th width=80 align=center><b>Physician</th>");
out.println( " <th width=100 align=center><b>Others</th>");
out.println( " <th width=80 align=center><b>Total</th>");
out.println( "</tr>");

//========== SQL for report content =========
sql =  " select spec, sum(case when dept='200' then amt end) as CathLab   ";
sql += "    , sum(case when dept='245' then amt else 0 end) as CyberKnife ";
sql += "    , sum(case when dept='360' then amt else 0 end) as OT         ";
sql += "    , sum(case when dept='365' then amt else 0 end) as ENDO       ";
sql += "    , sum(case when dept in ('410','240','340') then amt else 0 end) as DI  ";
sql += "    , sum(case when dept='230' then amt else 0 end) as LAB        ";
sql += "    , sum(case when dept='380' then amt else 0 end) as Phar       ";
sql += "    , sum(case when dept='210' then amt else 0 end) as CardioLab  ";
sql += "    , sum(case when dept='390' then amt else 0 end) as PT         ";
sql += "    , sum(case when dept in ('100','110','120','130','140','150','250','370') then amt else 0 end) as Ward ";
sql += "    , sum(case when dept='PHY' then amt else 0 end) as Physician  ";
sql += "    , sum(amt) as totamt, to_char(max(create_date),'yyyy/mm/dd hh24:mi') as last_update ";
sql += " from (select remarks as spec, substr(cnt_name,1,3) as dept, cnt_num" + cntName + " as amt, create_date ";
sql += "       from mis_count where cnt_group='RevenueByDept' and to_char(cnt_date,'yyyymm') like '"+thisYear+thisMonth+"%') a  ";
sql += " group by spec having sum(amt)>0 order by 1 ";

rs  = stmt.executeQuery(sql);

while (rs.next()) {
   val2 = rs.getInt(2);
   val3 = rs.getInt(3);
   val4 = rs.getInt(4);
   val5 = rs.getInt(5);
   val6 = rs.getInt(6);      
   val7 = rs.getInt(7);
   val8 = rs.getInt(8);
   val9 = rs.getInt(9);
   valA = rs.getInt(10);
   valB = rs.getInt(11);
   valC = rs.getInt(12);
   valD = rs.getInt(13);
   LastUpdate = "Data was updated on " + rs.getString(14);
   valE = valD - valC - valB - valA - val9 - val8 - val7 - val6 - val5 - val4 - val3 - val2;
   out.println( "<tr"+(cnt%2==0?"":" bgcolor=#EEEEEE")+"><td align=left><b>" + rs.getString(1) + "</b></td>" );
   out.println( "<td align=right>" + (val2==0?"":pctFormat.format(val2)) + "&nbsp;</td>" );
   out.println( "<td align=right>" + (val3==0?"":pctFormat.format(val3)) + "&nbsp;</td>" );
   out.println( "<td align=right>" + (val4==0?"":pctFormat.format(val4)) + "&nbsp;</td>" );
   out.println( "<td align=right>" + (val5==0?"":pctFormat.format(val5)) + "&nbsp;</td>" );
   out.println( "<td align=right>" + (val6==0?"":pctFormat.format(val6)) + "&nbsp;</td>" );
   out.println( "<td align=right>" + (val7==0?"":pctFormat.format(val7)) + "&nbsp;</td>" );
   out.println( "<td align=right>" + (val8==0?"":pctFormat.format(val8)) + "&nbsp;</td>" );
   out.println( "<td align=right>" + (val9==0?"":pctFormat.format(val9)) + "&nbsp;</td>" );
   out.println( "<td align=right>" + (valA==0?"":pctFormat.format(valA)) + "&nbsp;</td>" );
   out.println( "<td align=right>" + (valB==0?"":pctFormat.format(valB)) + "&nbsp;</td>" );
   out.println( "<td align=right>" + (valC==0?"":pctFormat.format(valC)) + "&nbsp;</td>" );
   out.println( "<td align=right>" + (valE==0?"":pctFormat.format(valE)) + "&nbsp;</td>" );
   out.println( "<td align=right><b>" + (valD==0?"":pctFormat.format(valD)) + "&nbsp;</td>" );
   out.println( "</tr>" );
   acc2 += val2;
   acc3 += val3;
   acc4 += val4;
   acc5 += val5;
   acc6 += val6;
   acc7 += val7;
   acc8 += val8;
   acc9 += val9;
   accA += valA;
   accB += valB;
   accC += valC;
   accD += valD;
   accE += valE;
   cnt++;
   
   if (cnt==99) {
      out.println( "<tr>");
      out.println( " <th width=280 height=30>&nbsp;Specialty</th>");
      out.println( " <th width=80 align=center><b>Cath Lab</th>");
      out.println( " <th width=80 align=center><b>Cyber knife</th>");
      out.println( " <th width=80 align=center><b>OT</th>");
      out.println( " <th width=80 align=center><b>ENDO</th>");
      out.println( " <th width=80 align=center><b>DI</th>");
      out.println( " <th width=80 align=center><b>Lab</th>");
      out.println( " <th width=80 align=center><b>Pharmacy</th>");
      out.println( " <th width=80 align=center><b>Cardio Lab</th>");
      out.println( " <th width=80 align=center><b>PT</th>");
      out.println( " <th width=80 align=center><b>Wards</th>");
      out.println( " <th width=80 align=center><b>Physician</th>");
      out.println( " <th width=100 align=center><b>Others</th>");
      out.println( " <th width=80 align=center><b>Total</th>");
      out.println( "</tr>");
   };
     
};   

out.println( "<tr height=25 bgcolor=#E0E0FF><td align=center><b>Total:</td>");
out.println( "<td align=right>" + pctFormat.format(acc2) + "&nbsp;</td>" );
out.println( "<td align=right>" + pctFormat.format(acc3) + "&nbsp;</td>" );
out.println( "<td align=right>" + pctFormat.format(acc4) + "&nbsp;</td>" );
out.println( "<td align=right>" + pctFormat.format(acc5) + "&nbsp;</td>" );
out.println( "<td align=right>" + pctFormat.format(acc6) + "&nbsp;</td>" );
out.println( "<td align=right>" + pctFormat.format(acc7) + "&nbsp;</td>" );
out.println( "<td align=right>" + pctFormat.format(acc8) + "&nbsp;</td>" );
out.println( "<td align=right>" + pctFormat.format(acc9) + "&nbsp;</td>" );
out.println( "<td align=right>" + pctFormat.format(accA) + "&nbsp;</td>" );
out.println( "<td align=right>" + pctFormat.format(accB) + "&nbsp;</td>" );
out.println( "<td align=right>" + pctFormat.format(accC) + "&nbsp;</td>" );
out.println( "<td align=right>" + pctFormat.format(accE) + "&nbsp;</td>" );
out.println( "<td align=right><b>" + pctFormat.format(accD) + "&nbsp;</td>" );
out.println( "</tr>" );

stmt.close();
con.close();
%>

</table>

<br><br>&nbsp;<%= LastUpdate %>
<br><br>&nbsp;<%= Remarks %>
 </td></tr>
</table>


</html>

