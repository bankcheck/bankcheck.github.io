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
<tr><td width=43 valign=top>
    <p style="font-size:13px;font-weight:bold;text-align=center;">
    <br><br><br><br>Year<br>

<%
/*======== Description of this file =============================
  Log: 20091221, ck. CLAB procedure census From Table MIS_COUNT
       20100112, ck, add remarks of last update date
       20121205, ck, add amount column
================================================================ */
  
//======== connect to database ===========
String thisURL   = request.getRequestURL().toString();
String thisYear  = request.getParameter("y");
String thisMonth = request.getParameter("m");

DataSource ds = HKAHInitServlet.getDataSourceCIS();
Connection con = ds.getConnection();
Statement stmt = con.createStatement();
String sql, s1="", s2, sGroup, sFirst, sHtml, prevYear, prevMth;
ResultSet rs;
int acc1=0, acc2=0, acc3=0, acc4=0, acc5=0, acc6=0, acc7=0, acc8=0, acc9=0;
int val1=0, val2=0, val3=0, val4=0, val5=0, val6=0, val7=0, val8=0, val9=0;
int lastMth=0, varMonth, varYear, cnt=0, nTotal=0, amount=0, amtTotal=0; 

DecimalFormat pctFormat = new DecimalFormat();
pctFormat.applyPattern("#,##0");

// ====== get report title, and remarks ============
String eTitle = "Cath-Lab Procedure Census by Doctor";
String cTitle, Remarks="", sUpdate="";

sql  = " select code_value1, code_value2, nvl(remarks,' ') from ah_sys_code ";
sql += " where sys_id='WEB' and code_type='REPORT' and code_no='CLAB.DocProc' ";
rs  = stmt.executeQuery(sql);
if  (rs.next()) {
   eTitle  = rs.getString(1);
   cTitle  = rs.getString(2); 
   Remarks = rs.getString(3);
};

// ======list of year ============
sql = " select distinct to_char(cnt_date,'yyyy') from mis_count ";
sql += " where cnt_group='CLAB' and cnt_name like 'DH0%:%' order by 1 desc ";
rs  = stmt.executeQuery(sql);

while (rs.next()) {
   s1 = rs.getString(1);
   if (thisYear==null) thisYear = s1;
   if (thisYear.equals(s1)) {
     out.println( "<br>&nbsp;<font color=darkred>" + s1 + "</font>"  );
   } else {
     out.println( "<br>&nbsp;<a href="+thisURL+"?y="+s1+">" + s1 + "</a>" );
   }  
};

if (thisYear==null) thisYear = "2009";
if (thisMonth==null) thisMonth = "%";
%>
    </b>
    </p>
 </td>   

<td width=43 valign=top>
    <p style="font-size:13px;font-weight:bold;text-align=center;">
    <br><br><br><br>Month<br>
    <br>&nbsp;<font color=blue>

<%
sql = " select distinct to_char(cnt_date,'mm'), to_char(cnt_date,'Mon','NLS_DATE_LANGUAGE = AMERICAN') ";
sql += "  from mis_count where cnt_group='CLAB' and cnt_name like 'DH0%:%' " ;
sql += "    and to_char(cnt_date,'yyyy')='"+thisYear+"' order by 1";
rs  = stmt.executeQuery(sql);
out.println( "<a href="+thisURL+"?y="+thisYear+">*All*</a>" );

while (rs.next()) {
   s1 = rs.getString(1);
   if (thisMonth.equals(s1)) {
     out.println( "<br>&nbsp;<font color=darkred>" + rs.getString(2) + "</font>"  );
   } else {
     out.println( "<br>&nbsp;<a href="+thisURL+"?y="+thisYear+"&m="+s1+">" + rs.getString(2) + "</a>" );
   }  
};
%>
    </p>
</td>   

<!-- right area, data -->
  <td><br>
    <p align=center>
       <font style="font-size:16px;font-weight:bold;color:darblue">
       <b> <%= eTitle + " -- " + thisYear + thisMonth  %> </b></font><br><br>
    </p>

    <table align=center width=95% border=1 cellpadding="0" cellspacing="0">
      <tr>
       <th width=250 height=40>Doctor</th>
       <th width=360><b>Procedure</th>
       <th width=50><b>Count</th>
       <th width=60><b>Amount</th>
       <th width=55><b>SubTotal</th>
       <th width=65><b>Amt Total</th>
      </tr>
<%

//========== SQL for report content =========
sql =  " select docfname||' '||docgname||' ('||doccode||')' as docname  ";
sql += "     , cnt_name, substr(cnt_name,1,5)||' - '||remarks, sum(cnt_num1) as cnt  ";
sql += "     , to_char(max(create_date),'dd/mm/yyyy hh24:mi') as last_update, sum(cnt_num2) as amt ";
sql += " from mis_count a, doctor@hat d  ";
sql += " where cnt_group='CLAB' and cnt_name like 'DH0%:%'  "; 
sql += "   and d.doccode=substr(cnt_name,7)  ";
sql += "   and to_char(cnt_date,'yyyymm') like '"+thisYear+thisMonth+"%'  ";
sql += " group by docfname||' '||docgname||' ('||doccode||')', cnt_name, remarks order by 1  ";
rs  = stmt.executeQuery(sql);

sFirst = sHtml = sGroup = "";

while (rs.next()) {
   if (cnt==0) sGroup = rs.getString(1);
   s1     = rs.getString(1);
   val1   = rs.getInt(4);
   acc1   += val1;
   nTotal += val1;
   
   val2   = rs.getInt(6);
   acc2   += val2;
   amtTotal += val2;

   if (cnt==0) {
     cnt=1;
     sGroup = rs.getString(1);
     sFirst = "<td align=left>&nbsp;" + rs.getString(3) + "&nbsp;</td>\n";
     sFirst += "<td align=center>&nbsp;" + val1 + "&nbsp;</td>\n";
     sFirst += "<td align=right>&nbsp;" + pctFormat.format(val2) + "&nbsp;</td>\n";
     sUpdate = "Data last updated on " + rs.getString(5);
   } else if ( !sGroup.equals(s1) ) {
     sFirst =  "<tr><td valign=top rowspan="+cnt+"><b>&nbsp;"+sGroup+"</b></td>\n"+sFirst;
     sFirst += "<td valign=bottom align=center rowspan=" + cnt + ">&nbsp;" ;
     sFirst += (acc1-val1)+ "&nbsp;</td>";
     sFirst += "<td valign=bottom align=right rowspan=" + cnt + ">&nbsp;" ;
     sFirst += pctFormat.format(acc2-val2)+ "&nbsp;</td></tr>\n";
     out.println( sFirst + sHtml );
     sGroup = rs.getString(1);
     acc1=val1; acc2=val2; cnt=1;
     sFirst  = "<td align=left>&nbsp;" + rs.getString(3) + "&nbsp;</td>\n";
     sFirst += "<td align=center>&nbsp;" + val1 + "&nbsp;</td>\n";
     sFirst += "<td align=right>&nbsp;" + pctFormat.format(val2) + "&nbsp;</td>\n";
     sHtml = "";
   } else {
     sHtml += "<tr><td align=left>&nbsp;" + rs.getString(3) + "&nbsp;</td>\n";
     sHtml += "<td align=center>&nbsp;" + val1 + "&nbsp;</td>\n";
     sHtml += "<td align=right>&nbsp;" + pctFormat.format(val2) + "&nbsp;</td></tr>\n";
     cnt++;
   };  
};

sFirst = "<tr><td valign=top align=left rowspan="+cnt+"><b>&nbsp;"+sGroup + "</b></td>\n" + sFirst;
sFirst += "<td valign=bottom align=center rowspan="+cnt+">&nbsp;" + acc1 + "&nbsp;</td>\n";
sFirst += "<td valign=bottom align=right rowspan="+cnt+">&nbsp;" + pctFormat.format(acc2) + "&nbsp;</td></tr>\n";
out.println( sFirst + "\n" + sHtml );

out.println( "<tr height=25 bgcolor=#E0E0FF><td align=center>&nbsp;</td>");
out.println( "   <td>&nbsp;</td><td><b>&nbsp;&nbsp;Total:</td><td>&nbsp;</td>");
out.println( "   <td align=center><b>&nbsp;"+nTotal+"</td>" );
out.println( "   <td align=right><b>&nbsp;"+pctFormat.format(amtTotal)+"</td></tr>" );

stmt.close();
con.close();
%>

</table>

<br><br><%= sUpdate %>
<br><br><%= Remarks %>
 </td></tr>
</table>


</html>
