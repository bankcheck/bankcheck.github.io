<%@ page language="java" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%--
    Licensed to the Apache Software Foundation (ASF) under one or more
    contributor license agreements.  See the NOTICE file distributed with
    this work for additional information regarding copyright ownership.
    The ASF licenses this file to You under the Apache License, Version 2.0
    (the "License"); you may not use this file except in compliance with
    the License.  You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>

<html>
<meta http-equiv="refresh" content=1200>
<meta http-equiv="Content-Type" content="text/html; charset=big5">

<head>
<style>
 body { margin-left:0px; margin-top:0px;	margin-right:0px; margin-bottom:0px; color:black;
        font-family: "Arial", "Verdana", "sans-serif";  font-size:12px; }
A:link { color:blue; text-decoration: none; }
A:visited { color:#3388DD; text-decoration: none; }
A:hover { color:red; background-color:skyblue; text-decoration:none;}
TD { font-family: "Arial", "Verdana", "sans-serif"; font-size:10px; }
TH { font-family: "Arial", "Verdana", "sans-serif"; font-weight:bold; 
     font-size:12px; background:#F0CCF0; text-align:left; }
SMALL { font-family: "Arial", "Verdana", "sans-serif"; font-size:8px; }     
</style>
</head>

<body>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.inpatientBed.view" />
</jsp:include>
<br>
<%
/*======== Description of this page ===========
  This page is used to retrieve bed list and booking information (today and tmr)
  and present an overview of bed booking for user.
  PS: via CIS -> dblink -> HAT; Auto-refresh in 30 seconds.
  
  Log: 20090702, ck. first release
       20141117, ck. revise for new ward.
================================================ */
  
//======== connect to database ===========
String sql, sysdate="";
String[][] bedlist = new String [500][10];
String[][] booking = new String [500][10];
String[][] notshow = new String [500][10];
int i=0, aCnt=0, bCnt=0, cCnt=0, m=-1, n=0;
int[] bedCnt =  { 0,0,0,0, 0,0,0,0, 0,0,0,0 };
int[] bedFre =  { 0,0,0,0, 0,0,0,0, 0,0,0,0 };
int[] bedBkg =  { 0,0,0,0, 0,0,0,0, 0,0,0,0 };

//========== get bed list =========
sql =  " select (select acmname from acm@hat x where x.acmcode=b.acmcode) as acm ";
//sql += "     , b.wrdcode, b.romcode, b.beddesc as bedinfo, i.patno, nvl(patsex,bedremark) as gender ";
sql += "     , b.wrdcode, b.romcode, b.beddesc as bedinfo, i.patno, nvl(patsex,CIS_ISVALID_BED(b.bedcode)) as gender ";
sql += "     , to_char(sysdate,'dd-mm-yyyy hh24:mi:ss')  ";
sql += " from (select r.acmcode, r.wrdcode, b.romcode, b.bedcode, b.beddesc, r.romsex, bedremark  ";
sql += "       from hat_bed b, hat_room r  ";
sql += "      where b.romcode=r.romcode and bedoff=-1 and r.wrdcode not in ('DC','IN') ";
sql += "      order by 1,2,3,4,5) b ";
sql += "    , (select patno, patsex, bedcode from qry_inpatient where inpddate is null) i ";
sql += " where b.bedcode=i.bedcode(+) ";

ArrayList record = UtilDBWeb.getReportableListCIS(sql);
ReportableListObject row = null;
for (i = 0; i < record.size(); i++) {
   row = (ReportableListObject) record.get(i);
   bedlist[aCnt][0] = row.getValue(0);    // acm
   bedlist[aCnt][1] = row.getValue(1);    // ward
   bedlist[aCnt][2] = row.getValue(2);    // room
   bedlist[aCnt][3] = row.getValue(3);    // bed
   bedlist[aCnt][4] = row.getValue(4);    // patno
   bedlist[aCnt][5] = row.getValue(5);    // gender
   sysdate = row.getValue(6);
   aCnt++;
};   

//========= get booking list==========
sql  = " select (select acmname from acm@hat x where x.acmcode=a.acmcode) as acm, wrdcode ";
sql += "  , to_char(bpbhdate,'dd/mm hh24:mi') as bookdate, patno, sex ";
sql += "  , (select substr(docfname||' '||docgname,1,9) from doctor@hat x where x.doccode=a.doccode) as docname";
sql += " from bedprebok@hat a "; 
sql += " where trunc(bpbhdate) between trunc(sysdate) and trunc(sysdate)+1 ";
sql += "   and bpbsts<>'F' and bpbsts<>'D' and acmcode is not null and wrdcode is not null ";
sql += " order by acmcode, wrdcode, bpbhdate ";

record = UtilDBWeb.getReportableListCIS(sql);
for (i = 0; i < record.size(); i++) {
   row = (ReportableListObject) record.get(i);
   booking[bCnt][0] = row.getValue(0);    // acm
   booking[bCnt][1] = row.getValue(1);    // ward
   booking[bCnt][2] = row.getValue(2);    // date
   booking[bCnt][3] = row.getValue(3);    // patno
   booking[bCnt][4] = row.getValue(4);    // sex
   booking[bCnt][5] = row.getValue(5);    // doctor name
   bCnt++;
};   

//========= booking not listed ========
sql  = " select (select acmname from acm@hat x where x.acmcode=a.acmcode) as acm ";
sql += "   , (select wrdname from ward@hat x where x.wrdcode=a.wrdcode) as wname ";
sql += "   , (select docfname||' '||docgname from doctor@hat x where x.doccode=a.doccode) as dn "; 
sql += "   , decode( sex, 'M', 'Male', 'F', 'Female', 'U', 'Unknown', sex ) as Gender "; 
sql += "   , a.wrdcode ";
sql += " from bedprebok@hat a "; 
sql += " where trunc(bpbhdate) between trunc(sysdate) and trunc(sysdate)+1 ";
sql += " and bpbsts<>'F' and bpbsts<>'D' and (acmcode is null or wrdcode is null)";
sql += " order by wrdcode, bpbhdate, acmcode ";

record = UtilDBWeb.getReportableListCIS(sql);
for (i = 0; i < record.size(); i++) {
   row = (ReportableListObject) record.get(i);
   notshow[cCnt][0] = row.getValue(0);    // acm
   notshow[cCnt][1] = row.getValue(1);    // wardname
   notshow[cCnt][2] = row.getValue(2);    // docname
   notshow[cCnt][3] = row.getValue(3);    // sex
   notshow[cCnt][4] = row.getValue(4);    // wordcode
   cCnt++;
};   

//========= Process bed information =======
String acm = "x", bedStr;
String[][] bedList = new String [6][10];
String[][] bkList = new String [6][10];

for (i=0; i<aCnt; i++ ) {

   if (!bedlist[i][0].equals(acm)) {
      acm = bedlist[i][0];
      bedList[++m][0] = bedlist[i][0];
      bedList[m][1] = bedList[m][2] = bedList[m][3] = bedList[m][4] = "";
      bedList[m][5] = bedList[m][6] = bedList[m][7] = bedList[m][8] = bedList[m][9] = "";
      bkList[m][1] = bkList[m][2] = bkList[m][3] = bkList[m][4] = "";
      bkList[m][5] = bkList[m][6] = bkList[m][7] = bkList[m][8] = bkList[m][9] = "";
   };   
  
  n = 1;
  if (bedlist[i][5]==null || bedlist[i][5].length()==0) {
      bedStr = "&nbsp;<font color=Green>"+bedlist[i][3] + "</font><br>";
  } else if (bedlist[i][5].equals("CLOSED")) {
      bedStr = "&nbsp;<font color=black>"+bedlist[i][3] + "</font><br>";
      n = 0;
  } else { 
      bedStr = "&nbsp;<font color=Red>"+bedlist[i][3]+"("+bedlist[i][5]+")</font><BR>";
  };
  
  bedCnt[0] += n;
  bedFre[0] += ((bedlist[i][5]==null || bedlist[i][5].length()==0)?1:0);
  
  if (bedlist[i][1].equals("OB")) {
     bedList[m][1] += bedStr; 
     bedCnt[1] += n; 
     bedFre[1] += ((bedlist[i][5]==null || bedlist[i][5].length()==0)?1:0);
  } else if (bedlist[i][1].equals("SU")) { 
     bedList[m][2] += bedStr; 
     bedCnt[2] += n; 
     bedFre[2] += ((bedlist[i][5]==null || bedlist[i][5].length()==0)?1:0);
  } else if (bedlist[i][1].equals("PD")) { 
     bedList[m][3] += bedStr; 
     bedCnt[3] += n;
     bedFre[3] += ((bedlist[i][5]==null || bedlist[i][5].length()==0)?1:0);
  } else if (bedlist[i][1].equals("ME")) { 
     bedList[m][4] += bedStr;
     bedCnt[4] += n;
     bedFre[4] += ((bedlist[i][5]==null || bedlist[i][5].length()==0)?1:0);
  } else if (bedlist[i][1].equals("MS")) { 
     bedList[m][5] += bedStr;
     bedCnt[5] += n;
     bedFre[5] += ((bedlist[i][5]==null || bedlist[i][5].length()==0)?1:0);
  } else if (bedlist[i][1].equals("IC")) { 
     if (bedCnt[6]==0) bedList[m][6] = "<font style='color:black;'><b><u>&nbsp;ICU Bed</u></b></font><br>";
     bedList[m][6] += bedStr;
     bedCnt[6] += n;
     bedFre[6] += ((bedlist[i][5]==null || bedlist[i][5].length()==0)?1:0);
     if (bedCnt[6]==4) bedList[m][6] += "<br><font style='color:black;'><b><u>&nbsp;ICU Ward</u></b></font><br>";
  } else if (bedlist[i][1].equals("SS")) { 
     bedList[m][7] += bedStr;
     bedCnt[7] += n;
     bedFre[7] += ((bedlist[i][7]==null || bedlist[i][7].length()==0)?1:0);
  } else if (bedlist[i][1].equals("SC")) { 
     bedList[m][8] += bedStr;
     bedCnt[8] += n;
     bedFre[8] += ((bedlist[i][8]==null || bedlist[i][8].length()==0)?1:0);
  } else if (bedlist[i][1].equals("ON")) { 
     bedList[m][9] += bedStr;
     bedCnt[9] += n;
     bedFre[9] += ((bedlist[i][9]==null || bedlist[i][9].length()==0)?1:0);
  };
};

//========= Process booking information =======
n=0;

for (i=0; i<bCnt; i++ ) {

  // match acm
  while (!booking[i][0].equals(bedList[n][0])) {
     n++;
  };   

  bkList[n][0] = booking[i][0];
  bedBkg[0]++;
  bedStr = booking[i][4] + ": <small>" + booking[i][5] + "</small><BR>";
  
  // match ward
  if (booking[i][1].equals("OB")) {
     bkList[n][1] += bedStr;
     bedBkg[1]++ ;
  } else if (booking[i][1].equals("SU")) { 
     bkList[n][2] += bedStr;
     bedBkg[2]++ ;
  } else if (booking[i][1].equals("PD")) { 
     bkList[n][3] += bedStr;
     bedBkg[3]++ ;
  } else if (booking[i][1].equals("ME")) { 
     bkList[n][4] += bedStr;
     bedBkg[4]++ ;
  } else if (booking[i][1].equals("MS")) { 
     bkList[n][5] += bedStr;
     bedBkg[5]++ ;
  } else if (booking[i][1].equals("IC")) { 
     bkList[n][6] += bedStr;
     bedBkg[6]++ ;
  } else if (booking[i][1].equals("SS")) { 
     bkList[n][7] += bedStr;
     bedBkg[7]++ ;
  } else if (booking[i][1].equals("SC")) { 
     bkList[n][8] += bedStr;
     bedBkg[8]++ ;
  } else if (booking[i][1].equals("ON")) { 
     bkList[n][9] += bedStr;
     bedBkg[9]++ ;
  };

};

//========= Count ward for unknow acm booking =======
for (i=0; i<cCnt; i++ ) {
  bedBkg[0]++;
  if (notshow[i][4]==null) {
     i=i;
  } else if (notshow[i][4].equals("OB")) {
     bedBkg[1]++ ;
  } else if (notshow[i][4].equals("SU")) { 
     bedBkg[2]++ ;
  } else if (notshow[i][4].equals("PD")) { 
     bedBkg[3]++ ;
  } else if (notshow[i][4].equals("ME")) { 
     bedBkg[4]++ ;
  } else if (notshow[i][4].equals("MS")) { 
     bedBkg[5]++ ;
  } else if (notshow[i][4].equals("IC")) { 
     bedBkg[6]++ ;
  } else if (notshow[i][4].equals("SS")) { 
     bedBkg[7]++ ;
  } else if (notshow[i][4].equals("SC")) { 
     bedBkg[8]++ ;
  } else if (notshow[i][4].equals("ON")) { 
     bedBkg[9]++ ;
  };
};

out.println( "<table align=center width='98%'>");
out.println( " <tr><td><font color=red>[Bed(Gender)]</font> = Occupied <br>");
out.println( " <font color=Green>[Bed]</font> = Available<br> " );
out.println( " <font color=Black>[Bed]</font> = Closed<br>" );
out.println( "</td>   <td align=right><a href=# onclick='javascript:location.reload(true)'>");
out.println( " <b>Refresh</b></a> at " + sysdate + "<br><br>" );
out.println( " <font color=Black>Booking cases include today and tomorrow<br></td></tr></table> " ); 
%>

<table align=center width=98% border=1 cellpadding="0" cellspacing="0">
  <tr>
   <th width=3% height=30 valign=top>&nbsp;Class</th>
   <th width=13%>&nbsp;OB <br><table width=100%><tr><td><td align=right>Booking</table></th>
   <th width=13%>&nbsp;Surgical<br><table width=100%><tr><td><td align=right>Booking</table></th>
   <th width=13%>&nbsp;Pediatric Unit<br><table width=100%><tr><td><td align=right>Booking</table></th>
   <th width=13%>&nbsp;Medical Unit<br><table width=100%><tr><td><td align=right>Booking</table></th> 
   <TH width=13%>&nbsp;Med. Surgical<br><table width=100%><tr><td><td align=right>Booking</table></th>
   <TH width=12%>&nbsp;ICU<table width=100%><tr><td><td align=right>Booking</table></th>
   <TH width=12%>&nbsp;Short Stay<table width=100%><tr><td><td align=right>Booking</table></th>
   <TH width=12%>&nbsp;Special Care<table width=100%><tr><td><td align=right>Booking</table></th>
   <TH width=12%>&nbsp;Oncology<table width=100%><tr><td><td align=right>Booking</table></th>
  </tr>

<%
//========= show table =============
String TDcode1 = "<td valign=top><table width=100% height=100% border=0><tr><td valign=top width='40%'><font color=green>";
String TDcode2 = "<td valign=top width='58%' bgcolor=lightblue>"; 
//out.println("<td valign=top>" + ( bedList[i][1].length()==0? "&nbsp;" : bedList[i][2]) + "</td>");
//bkList[0][1] = "<font style='background:red'>&nbsp;&nbsp;Booking Cases&nbsp;&nbsp;</font><br>";
//bkList[0][2] = bkList[0][3] = bkList[0][4] = bkList[0][5] = bkList[0][6] = bkList[0][1]; 

for (i=0; i<=m; i++) {
    out.println("<tr><td valign=top>&nbsp;<b>" + bedList[i][0] + "</td>" );

    out.println(TDcode1 + ( bedList[i][1].length()==0? "&nbsp;" : bedList[i][1]) + "</td>" );
    out.println(TDcode2 + bkList[i][1] + "</td></tr></table> </td>");
    
    out.println(TDcode1 + ( bedList[i][2].length()==0? "&nbsp;" : bedList[i][2]) + "</td>");
    out.println(TDcode2 + bkList[i][2] + "</td></tr></table> </td>");

    out.println(TDcode1 + ( bedList[i][3].length()==0? "&nbsp;" : bedList[i][3]) + "</td>");
    out.println(TDcode2 + bkList[i][3] + "</td></tr></table> </td>");

    out.println(TDcode1 + ( bedList[i][4].length()==0? "&nbsp;" : bedList[i][4]) + "</td>");
    out.println(TDcode2 + bkList[i][4] + "</td></tr></table> </td>");

    out.println(TDcode1 + ( bedList[i][5].length()==0? "&nbsp;" : bedList[i][5]) + "</td>");
    out.println(TDcode2 + bkList[i][5] + "</td></tr></table> </td>");

    out.println(TDcode1 + ( bedList[i][6].length()==0? "&nbsp;" : bedList[i][6]) + "</td>");
    out.println(TDcode2 + bkList[i][6] + "</td></tr></table> </td>");

    out.println(TDcode1 + ( bedList[i][7].length()==0? "&nbsp;" : bedList[i][7]) + "</td>");
    out.println(TDcode2 + bkList[i][7] + "</td></tr></table> </td>");

    out.println(TDcode1 + ( bedList[i][8].length()==0? "&nbsp;" : bedList[i][8]) + "</td>");
    out.println(TDcode2 + bkList[i][8] + "</td></tr></table> </td>");

    out.println(TDcode1 + ( bedList[i][9].length()==0? "&nbsp;" : bedList[i][9]) + "</td>");
    out.println(TDcode2 + bkList[i][9] + "</td></tr></table> </td>");
    
    out.println( "</tr>" );
}

DecimalFormat pctFormat = new DecimalFormat();
pctFormat.applyPattern("0%");

out.println( "<tr><td>&nbsp<b>");
out.println( pctFormat.format(1.00*(bedCnt[0]-bedFre[0]+bedBkg[0])/bedCnt[0]) + "<br>Total Bed<br>Occupied</td>" );
out.println( "<td>&nbsp;Capacity = " + bedCnt[1] + " <br>&nbsp;Available = " + (bedFre[1]-bedBkg[1]) );
out.println( "<br>&nbsp;" + pctFormat.format(1.00*(bedCnt[1]-bedFre[1]+bedBkg[1])/bedCnt[1]) + " Bed Occupied</td>" );
out.println( "<td>&nbsp;Capacity = " + bedCnt[2] + " <br>&nbsp;Available = " + (bedFre[2]-bedBkg[2]) );
out.println( "<br>&nbsp;" + pctFormat.format(1.00*(bedCnt[2]-bedFre[2]+bedBkg[2])/bedCnt[2])+ " Bed Occupied</td>" );
out.println( "<td>&nbsp;Capacity = " + bedCnt[3] + " <br>&nbsp;Available = " + (bedFre[3]-bedBkg[3]) );
out.println( "<br>&nbsp;" + pctFormat.format(1.00*(bedCnt[3]-bedFre[3]+bedBkg[3])/bedCnt[3])+ " Bed Occupied</td>" );
out.println( "<td>&nbsp;Capacity = " + bedCnt[4] + " <br>&nbsp;Available = " + (bedFre[4]-bedBkg[4]) );
out.println( "<br>&nbsp;" + pctFormat.format(1.00*(bedCnt[4]-bedFre[4]+bedBkg[4])/bedCnt[4])+ " Bed Occupied</td>" );
out.println( "<td>&nbsp;Capacity = " + bedCnt[5] + " <br>&nbsp;Available = " + (bedFre[5]-bedBkg[5]) );
out.println( "<br>&nbsp;" + pctFormat.format(1.00*(bedCnt[5]-bedFre[5]+bedBkg[5])/bedCnt[5])+ " Bed Occupied</td>" );
out.println( "<td>&nbsp;Capacity = " + bedCnt[6] + " <br>&nbsp;Available = " + (bedFre[6]-bedBkg[6]) );
out.println( "<br>&nbsp;" + pctFormat.format(1.00*(bedCnt[6]-bedFre[6]+bedBkg[6])/bedCnt[6])+ " Bed Occupied</td>" );
out.println( "<td>&nbsp;Capacity = " + bedCnt[7] + " <br>&nbsp;Available = " + (bedFre[7]-bedBkg[7]) );
out.println( "<br>&nbsp;" + pctFormat.format(1.00*(bedCnt[7]-bedFre[7]+bedBkg[7])/bedCnt[7])+ " Bed Occupied</td>" );
out.println( "<td>&nbsp;Capacity = " + bedCnt[8] + " <br>&nbsp;Available = " + (bedFre[8]-bedBkg[8]) );
out.println( "<br>&nbsp;" + pctFormat.format(1.00*(bedCnt[8]-bedFre[8]+bedBkg[8])/bedCnt[8])+ " Bed Occupied</td>" );
out.println( "<td>&nbsp;Capacity = " + bedCnt[9] + " <br>&nbsp;Available = " + (bedFre[9]-bedBkg[9]) );
out.println( "<br>&nbsp;" + pctFormat.format(1.00*(bedCnt[9]-bedFre[9]+bedBkg[9])/bedCnt[9])+ " Bed Occupied</td>" );
out.println( "</tr>" );

%>

</table>

<br><br>

<%
if (cCnt>0) {
  out.println( "<p align=center><b><font size=3>Pending for Allocation</font></b></p> ");
  out.println( "<table align=center width=80% border=1 cellpadding=0 cellspacing=0> ");
  out.println( "  <tr><th height=25 width=30% >&nbsp;Ward</th> <th width=20% >&nbsp;Class</th> "); 
  out.println( "  <th width=40% >&nbsp;Doctor Name</th> <th width=10% >&nbsp;Gender</th> "); 
  out.println( "  </tr><tr> ");
  
  for (i=0; i<cCnt; i++) {
    out.println("<tr><td>&nbsp;<b>" + (notshow[i][1]==null? "" : notshow[i][1]) );
    out.println("<td>&nbsp;" + (notshow[i][0]==null? "" : notshow[i][0]) + "</td>");
    out.println("<td>&nbsp;" + (notshow[i][2]==null? "" : notshow[i][2]) + "</td>");
    out.println("<td>&nbsp;" + (notshow[i][3]==null? "" : notshow[i][3]) + "</td>");
  }

  out.println( "  </tr></table><br>");

}     
out.println( "<p align=center>"+cCnt+" Pending Booking</p>");
%> 



<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>
