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
<tr><td width=8% valign=top>
    <p style="font-size:13px;font-weight:bold;text-align=center;">
    <br><br><br><br>Year<br>

<%
/*======== Description of this file =============================
  Log: 20121207, revise from census_mis_count1.jsp
================================================================ */
  
//======== connect to database ===========
String thisURL  = request.getRequestURL().toString();
String thisYear = request.getParameter("y");
String cntGroup = request.getParameter("g");
String cntName  = request.getParameter("n");

DataSource ds = HKAHInitServlet.getDataSourceCIS();
Connection con = ds.getConnection();
Statement stmt = con.createStatement();
String sql, s1="", s2, prevYear, prevMth, thisMth;
ResultSet rs;
int sum1=0, sum2=0, acc1=0, acc2=0, cnt=0; 
int cntVal1, cntVal2, lastMth=0, varMonth=0, varYear=0;

DecimalFormat pctFormat = new DecimalFormat();
DecimalFormat amtFormat = new DecimalFormat();
pctFormat.applyPattern("0.00%");
amtFormat.applyPattern("#,##0");

// ====== get report title, and remarks ============
String eTitle = "Census By Year";
String Remarks= "v.2012.12.07";
String cTitle="", curMonth="", curYear="";

sql = "select to_char(sysdate,'yyyy'), to_char(sysdate,'mm') from dual";
rs  = stmt.executeQuery(sql);
if  (rs.next()) {
   curYear = rs.getString(1);
   curMonth = rs.getString(2);
};

sql  = " select code_value1, code_value2, remarks from ah_sys_code ";
sql += " where sys_id='WEB' and code_type='REPORT' and code_no='" + cntGroup+"."+cntName+ "' ";
rs  = stmt.executeQuery(sql);
if  (rs.next()) {
   eTitle  = rs.getString(1);
   cTitle  = rs.getString(2); 
   Remarks = rs.getString(3);
};

// ======list of year ============
sql = " select distinct to_char(cnt_date,'yyyy') from mis_count ";
sql += " where cnt_group='" + cntGroup + "' and cnt_name='" + cntName + "'";
sql += " and cnt_date>=to_date('20060101','yyyymmdd') order by 1 desc ";
rs  = stmt.executeQuery(sql);

while (rs.next()) {
   s1 = rs.getString(1);
   if (thisYear==null) thisYear = curYear;
   if (thisYear.equals(s1)) {
     out.println( "<br>&nbsp;<font color=darkred>" + s1 + "</font>"  );
   } else {
     out.println( "<br>&nbsp;<a href="+thisURL+"?g="+cntGroup+"&n="+cntName+"&y="+s1+">" + s1 + "</a>" );
   }  
};

prevYear = ""+(Integer.parseInt(thisYear)-1);
prevMth  = prevYear+"12";
%>
    </b>
    </p>
 </td>   

<!-- right area, data -->
  <td><br>
    <p align=center>
       <font style="font-size:16px;font-weight:bold;color:darblue">
       <b> <%= eTitle %> </b></font>
    </p>

    <table align=center width=90% border=1 cellpadding="0" cellspacing="0">
      <tr>
       <th width=80 height=40>&nbsp;Month</th>
       <th width=180>&nbsp;<%=prevYear%><br>
           <table width=90% border=0><tr><td align=right>Amount<td align=right>YTM</tr></table></th>
       <th width=180>&nbsp;<%=thisYear%><br>
           <table width=90% border=0><tr><td align=right>Amount<td align=right>YTM</tr></table></th>
       <th width=180>Changes Compare<br>with Prev Month</th>
       <th width=180>YTM Change<br>
           <table width=90% border=0><tr><td align=right>Amount<td align=right>%</tr></table></th>
      </tr>

<%

//========== get op cnt for prev month =========
sql = " select sum(cnt_num2) as cnt from mis_count ";
sql += " where cnt_group='"+cntGroup+"' and cnt_name='"+cntName+"' ";
sql += "  and  to_char(cnt_date,'yyyymm')='"+prevMth+"' ";

rs  = stmt.executeQuery(sql);
if (rs.next()) lastMth = rs.getInt(1);

//========== get op cnt for each month =========
sql =  " select substr(mth,5) as month, mon  ";
sql += "   , sum(case when substr(mth,1,4)='"+prevYear+"' then cnt else 0 end) as cnt_comp  ";
sql += "   , sum(case when substr(mth,1,4)='"+thisYear+"' then cnt else 0 end) as cnt_this ";
sql += "   , to_char(max(upddate),'dd/mm/yyyy hh24:mi') as last_update ";
sql += " from (select to_char(cnt_date,'yyyymm') as mth ";
sql += "            , to_char(cnt_date,'MON','NLS_DATE_LANGUAGE = AMERICAN') as mon ";
sql += "            , sum(cnt_num2) as cnt, max(create_date) as upddate  ";
sql += "       from mis_count ";
sql += "       where cnt_group='"+cntGroup+"' and cnt_name='"+cntName+"' ";
sql += "         and to_char(cnt_date,'yyyy') in ('"+prevYear+"','"+thisYear+"') ";
sql += "         and (to_char(sysdate,'yyyy')>'"+thisYear+"' or to_char(cnt_date,'mm')<=to_char(sysdate,'mm')) ";
sql += "       group by to_char(cnt_date,'yyyymm'), to_char(cnt_date,'MON','NLS_DATE_LANGUAGE = AMERICAN')  ";
sql += "       ) x  ";
sql += " group by substr(mth,5), mon order by 1";

rs  = stmt.executeQuery(sql);

while (rs.next()) {
   cntVal1 = rs.getInt(3);
   cntVal2 = rs.getInt(4);
   thisMth = rs.getString(1);
   
   if ( curYear.compareTo(thisYear)==0 && curMonth.compareTo(thisMth)==0 ) {
      out.println( "<tr bgcolor=#DDDDDD><td align=center><b>&nbsp;"+rs.getString(2)+"</b></td>" );
      out.println( "<td><table width=90% align=center border=0><tr>");
      out.println( "  <td width=50% align=right>"+amtFormat.format(cntVal1==0?"&nbsp;":cntVal1)+"</td>");
      out.println( "  <td width=50% align=right>&nbsp</tr></table></td>" );
      out.println( "<td><table width=90% align=center border=0><tr>");
      out.println( "  <td width=50% align=right>"+amtFormat.format(cntVal2)+"*</td>");
      out.println( "  <td width=50% align=right>&nbsp</tr></table></td>" );
      out.println( "<td align=center><small>*Updated on "+rs.getString(5)+"</td><td>&nbsp</td>" );
   } else {
      acc1 += cntVal1;
      acc2 += cntVal2;
      varMonth = cntVal2 - lastMth;
      //varYear  = cntVal2 - cntVal1;
      varYear  = acc2 - acc1;
   
      out.println( "<tr><td align=center><b>&nbsp;" + rs.getString(2) + "</b></td>" );
      
      out.println( "<td><table width=90% align=center border=0><tr>");
      out.println( "  <td width=50% align=right>"+amtFormat.format(cntVal1==0?"&nbsp;":cntVal1)+"</td>");
      out.println( "  <td width=50% align=right>"+amtFormat.format(cntVal1==0?"&nbsp;":acc1)+"</tr></table></td>" );
      
      out.println( "<td><table width=90% align=center border=0><tr>");
      out.println( "  <td width=50% align=right>"+amtFormat.format(cntVal2==0?"&nbsp;":cntVal2)+"</td>");
      out.println( "  <td width=50% align=right>"+amtFormat.format(cntVal2==0?"&nbsp;":acc2)+"</tr></table></td>" );
      
      if ( cntVal2>0  ) {
       out.println( "<td><table width=90% align=center border=0><tr><td width=50% align=right>"+amtFormat.format(varMonth)+"</td>");
       out.println( "<td width=50% align=right>"+pctFormat.format( 1.00 * varMonth/lastMth)+"</tr></table></td>" );
       out.println( "<td><table width=90% align=center border=0><tr><td width=50% align=right>"+amtFormat.format(varYear)+"</td>");
       out.println( "<td width=50% align=right>"+pctFormat.format( 1.00 * varYear/acc1)+"</tr></table></td>" );
      } else {
       out.println( "<td><table width=90% align=center border=0><tr><td width=50% align=right>&nbsp;</td>");
       out.println( "<td width=50% align=right>&nbsp;</tr></table></td>" );
       out.println( "<td><table width=90% align=center border=0><tr><td width=50% align=right>&nbsp;</td>");
       out.println( "<td width=50% align=right>&nbsp;</tr></table></td>" );
      };
   };
   
   out.println( "</tr>" );

   lastMth =  cntVal2;
   cnt++;
};   

out.println( "<tr height=25 bgcolor=#E0E0FF><td align=center><b>Total:</td>");
out.println( " <td align=right><b>"+amtFormat.format(acc1)+"&nbsp;&nbsp;&nbsp;</td>");
out.println( " <td align=right><b>"+amtFormat.format(acc2)+"&nbsp;&nbsp;&nbsp;</td><td>&nbsp;</td>");
out.println( " <td><table width=90% align=center border=0><tr><td width=50% align=right><b>");
out.println( amtFormat.format(acc2-acc1)+"</td><td  width=50% align=right>"+pctFormat.format(1.00*(acc2-acc1)/acc1) );
out.println( "</td></tr></table></td></tr>" );

stmt.close();
con.close();
%>

</table>

<br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
<%= Remarks %>
 </td></tr>
</table>


</html>


