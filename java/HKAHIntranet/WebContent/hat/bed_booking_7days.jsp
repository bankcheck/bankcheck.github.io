<%@ page language="java" %>
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
        font-family: "Arial", "Verdana", "sans-serif";  font-size:13px; }
A:link { color:blue; text-decoration: none; }
A:visited { color:#3388DD; text-decoration: none; }
A:hover { color:red; background-color:skyblue; text-decoration:none;}
TD { font-family: "Arial", "Verdana", "sans-serif"; font-size:11px; }
TH { font-family: "Arial", "Verdana", "sans-serif"; font-weight:bold; 
     font-size:14px; background:#F0CCF0; text-align:left; }
</style>
</head>

<body>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Bed Overview by Date" />
</jsp:include>
<br>
<%
/*======== Description of this page ===========
  This page is used to retrieve bed occupancy for 7 days
  
  Log: 20100110, cherry
================================================ */
  
//======== connect to database ===========
String sql, sysdate="";
String[][] bedlist = new String [500][13];
String[][] booking = new String [500][9];
String[][] blockedbed = new String [500][9];
String[][] inpatient = new String[500][10];
String[]   dayList = new String [7];
String[]   category = new String[6];
int i=0, aCnt=0, bCnt=0, cCnt=0,dCnt=0,eCnt=0,fCnt=0, m=-1, n=0;
int[] bedCnt =  { 0,0,0,0, 0,0,0,0 };
int[] bedFre =  { 0,0,0,0, 0,0,0,0 };
int[] bedBkg =  { 0,0,0,0, 0,0,0,0 };
Map<String,List> bookingMap = new HashMap<String,List>();
Map<String,List> blockedMap = new HashMap<String,List>();
Map<String,List> inpatientMap = new HashMap<String,List>();
//========== get bed list =========

sql  =  "select (select acmname from acm@hat x where x.acmcode=b.acmcode) as acm ";
sql += "    , b.wrdcode, b.romcode, b.beddesc as bedinfo,b.bedcode ";
sql += "from (select r.acmcode, r.wrdcode, b.romcode, b.bedcode, b.beddesc, r.romsex, bedremark, cis_isvalid_bed2(b.bedcode,sysdate) as vb ";
sql += "from hat_bed b, hat_room r ";
sql += "where b.romcode=r.romcode and bedoff=-1 and r.wrdcode<>'DC' ";
sql += " order by 1,2,3,4,5) b ";

ArrayList record = UtilDBWeb.getReportableListCIS(sql);
ReportableListObject row = null;
for (i = 0; i < record.size(); i++) {
   row = (ReportableListObject) record.get(i);
   bedlist[aCnt][0] = row.getValue(0);    // acm
   bedlist[aCnt][1] = row.getValue(1);    // ward
   bedlist[aCnt][2] = row.getValue(2);    // room
   bedlist[aCnt][3] = row.getValue(3);    // bed
   bedlist[aCnt][4] = row.getValue(4); //bedcode
   aCnt++;
};   

//========= get booking list==========
sql  = " select (select acmname from acm@hat x where x.acmcode=a.acmcode) as acm, wrdcode ";
sql += "  , to_char(bpbhdate,'dd/mm hh24:mi') as bookdate, patno, sex ";
sql += "  , (select substr(docfname||' '||docgname,1,10) from doctor@hat x where x.doccode=a.doccode) as docname";
sql += "  , eststaylen ,trunc(trunc(bpbhdate) -trunc(sysdate)) as startcomparetoday,bedcode ";
sql += " from bedprebok@hat a "; 
sql += " where trunc(bpbhdate) between trunc(sysdate) and trunc(sysdate)+7 ";
sql += "   and bpbsts<>'F' and bpbsts<>'D' and acmcode is not null and wrdcode is not null ";
sql += "    and eststaylen is not null ";
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
   booking[bCnt][6] = row.getValue(6);    // estimated stay length 
   booking[bCnt][7] = row.getValue(7);   // start date compare with today
   booking[bCnt][8] = row.getValue(8);  //bedcode
   bCnt++;
};   


//=====7 days====

sql  = "select distinct to_char(trunc(sysdate),'yyyy/mm/dd'),to_char(trunc(sysdate+1),'yyyy/mm/dd'), ";
sql += "to_char(trunc(sysdate+2),'yyyy/mm/dd'),to_char(trunc(sysdate+3),'yyyy/mm/dd'),to_char(trunc(sysdate+4),'yyyy/mm/dd'), ";
sql += "to_char(trunc(sysdate+5),'yyyy/mm/dd'),to_char(trunc(sysdate+6),'yyyy/mm/dd') 	from bedprebok@hat";
record = UtilDBWeb.getReportableListCIS(sql);
for (i = 0; i < record.size(); i++) {
	dayList[0] = row.getValue(0);
	dayList[1] = row.getValue(1);
	dayList[2] = row.getValue(2);
	dayList[3] = row.getValue(3);
	dayList[4] = row.getValue(4);
	dayList[5] = row.getValue(5);
	dayList[6] = row.getValue(6);
}
//=== blocked bed 
sql  = "select bedcode, blockstart,trunc(trunc(blockstart) - trunc(sysdate)) as startcomparetoday, ";
sql += "	trunc(trunc(blockend) - trunc(blockstart)+1)as printlength, ";
sql += "	trunc(trunc(blockstart) - trunc(sysdate))+trunc(trunc(blockend) - trunc(blockstart)+1) as count ";
sql += "from bedblock@hat ";

record = UtilDBWeb.getReportableListCIS(sql);
for (i = 0; i < record.size(); i++) {
	blockedbed[eCnt][0] = row.getValue(0);
	blockedbed[eCnt][1] = row.getValue(2); //compare
	blockedbed[eCnt][2] = row.getValue(3); //length
	blockedbed[eCnt][3] = row.getValue(4); //length
	eCnt++;
}

//==inpatient
sql  = "select i.inpid,q.patno,";
sql += "    i.bedcode,regdate,i.actstaylen,i.inpddate, ";
sql += "    (select substr(docfname||' '||docgname,1,10) from doctor@hat x where x.doccode=q.DOCCODE_A) as docname1, ";
sql += "  	(select substr(docfname||' '||docgname,1,10) from doctor@hat x where x.doccode=q.DOCCODE_D) as docname2, ";
sql += "	trunc(trunc(q.regdate) +i .actstaylen-1) as actualleavedate, ";
sql += "    trunc(trunc(q.regdate) +i.actstaylen- trunc(sysdate)) as printlen, ";
sql += "     trunc(trunc(q.regdate) - trunc(sysdate)) as comparetoday  ";
sql += "from inpat@hat i,qry_inpatient q ";
sql += "where i.inpid = q.inpid and q.regsts = 'N' and q.inpddate is null";

record = UtilDBWeb.getReportableListCIS(sql);
for (i = 0; i < record.size(); i++) {
	inpatient[fCnt][0] = row.getValue(1); //patno
	inpatient[fCnt][1] = row.getValue(2); //bedcode
	inpatient[fCnt][2] = row.getValue(6); //docname
	inpatient[fCnt][3] = row.getValue(8);//actualleavedate
	inpatient[fCnt][4] = row.getValue(9); //printlen
	inpatient[fCnt][5] = row.getValue(10); //comparetoday
	inpatient[fCnt][6] = row.getValue(4); //actuallen
	inpatient[fCnt][7] = row.getValue(5); //inpddate
	fCnt++;
}
//==process inpatient
String acm = "x", bedStr;

for (i=0; i<fCnt; i++ ) {
	bedStr = "<tr><td>&nbsp;</td>";
	if(inpatient[i][6]!= null && !"".equals(inpatient[i][6])){
		if(Integer.parseInt(inpatient[i][5])<=0){ //if reg day less than today
		  if(Integer.parseInt(inpatient[i][4]) > 0 ){  //expected discharge day compare with today
			  if(Integer.parseInt(inpatient[i][4])>7){ //if more than 7 days
				  if(inpatient[i][0]!= null){
				  bedStr +="<td colspan=\"7\" style=\"color:white; background-color:red\">Pat#"+inpatient[i][0]+"("+inpatient[i][2]+")"+"</td> ";
				  }else{
					  bedStr +="<td colspan=\"7\" style=\"color:white; background-color:red\">New Patient"+"("+inpatient[i][2]+")"+"</td> ";  
				  }
			  } else {
				  if(inpatient[i][0]!= null){
					  bedStr +="<td colspan=\""+inpatient[i][4]+"\" style=\"color:white; background-color:red\">Pat#"+inpatient[i][0]+"("+inpatient[i][2]+")"+"</td> ";
					  }else{
						  bedStr +="<td colspan=\""+inpatient[i][4]+"\" style=\"color:white; background-color:red\">New Patient"+"("+inpatient[i][2]+")"+"</td> ";  
					  }
				  	   int tempCount = 7 - Integer.parseInt(inpatient[i][4]);
				  	   for(int k=0;k<tempCount;k++){
				  		   bedStr += "<td>&nbsp;</td>";
				  	   }
			  }
			  
		     } else if (inpatient[i][7]== null){
		        bedStr += "<td style=\"color:white; background-color:red\">Pat#"+inpatient[i][0]+"("+inpatient[i][2]+")"+"</td>";
			  	   for(int k=0;k<6;k++){
			  		   bedStr += "<td>&nbsp;</td>";
			  	   }
		    }
		  }
	} else if(inpatient[i][7]== null){
	        bedStr += "<td style=\"color:white; background-color:red\">Pat#"+inpatient[i][0]+"("+inpatient[i][2]+")"+"</td>";
		  	   for(int k=0;k<6;k++){
		  		   bedStr += "<td>&nbsp;</td>";
		  	   } 
	} else {
		   for(int k=0;k<7;k++){
	  		   bedStr += "<td>&nbsp;</td>";
	  	   } 
	}
	bedStr += "</tr>";
  if(inpatientMap.containsKey(inpatient[i][1]) && inpatient[i][1] != null){
		 inpatientMap.get(inpatient[i][1]).add(bedStr);
   }else {
		    ArrayList<String> inpatientList = new ArrayList<String>();  
		    inpatientList.add(bedStr);
			inpatientMap.put(inpatient[i][1],inpatientList);
   } 
}
//========= Process booking information =======

String[][] bedList = new String [500][9];
String[][] bkList = new String [500][9];
String[][] blockList = new String [500][9];
	
n=0;
String tempBedNo = null;
for (i=0; i<bCnt; i++ ) {

  // match acm
  bedStr  = "";
  bedStr += "<tr><td>&nbsp;</td>";
  if(Integer.parseInt(booking[i][6]) >= (7 - Integer.parseInt(booking[i][7]))){ //length > compare with today
	  for(int k=0;k<Integer.parseInt(booking[i][7]);k++){
	 	bedStr += "<td>&nbsp;</td>"; //space before reg day start
	  }
	  if(booking[i][3]!= null){
		  bedStr += "<td colspan=\""+(7- Integer.parseInt(booking[i][7]))+"\" style=\"background-color:pink\"> Pat#"+booking[i][3]+"("+booking[i][5]+")</td>";  
	  } else {
		  bedStr += "<td colspan=\""+(7- Integer.parseInt(booking[i][7]))+"\" style=\"background-color:pink\"> New Patient("+booking[i][5]+")</td>";
	  }
  } else {
	  for(int k=0;k<Integer.parseInt(booking[i][7]);k++){
	  	bedStr += "<td>&nbsp;</td>"; //space before reg day start
	  }
	  if(booking[i][3]!= null){
	  	bedStr += "<td colspan=\""+(Integer.parseInt(booking[i][6]))+"\" style=\"background-color:pink\"> Pat#"+booking[i][3]+"("+booking[i][5]+")</td>";
	  } else {
	  	bedStr += "<td colspan=\""+(	Integer.parseInt(booking[i][6]))+"\" style=\"background-color:pink\"> New Patient("+booking[i][5]+")</td>"; 
	  }
	  for(int k=0;k<(7- Integer.parseInt(booking[i][7])-Integer.parseInt(booking[i][6]));k++){
	  	bedStr += "<td>&nbsp;</td>";
	  }
  }
  bedStr +="</tr>";

  
  
  if(bookingMap.containsKey(booking[i][8]) && booking[i][8] != null){
		 bookingMap.get(booking[i][8]).add(bedStr);
  }else {
	    ArrayList<String> bookingList = new ArrayList<String>();  
		bookingList.add(bedStr);
		bookingMap.put(booking[i][8],bookingList);
  }

}
//========= Blocked Bed =======
for (i=0; i<eCnt; i++ ) {
	int yesCount = 0;
	int noCount  = 0;

	bedStr = "<tr><td>&nbsp;</td>";
	
	if (Integer.parseInt(blockedbed[i][1])<=0){
		bedStr +="<td colspan=\""+Integer.parseInt(blockedbed[i][3])+"\" style=\"background-color:black\"></td>";
		if(Integer.parseInt(blockedbed[i][3]) <7){
			for(int k=0;k<7-Integer.parseInt(blockedbed[i][3]);k++){
			   bedStr += "<td>&nbsp;</td>";
			}
		}
	} else {
		for(int k=0;k<Integer.parseInt(blockedbed[i][1]);k++){
			   bedStr += "<td>&nbsp;</td>";
		}
		bedStr +="<td colspan=\""+blockedbed[i][2]+"\" style=\"background-color:black\"></td>";
		
		int tempcolspan = Integer.parseInt(blockedbed[i][1]) + Integer.parseInt(blockedbed[i][2]);
		
		if(tempcolspan < 7){
			for(int k=0;k<7-tempcolspan;k++){
			   bedStr += "<td>&nbsp;</td>";
			}
		}
	}
	bedStr +="</tr>";
    if(blockedMap.containsKey(blockedbed[i][0]) && blockedbed[i][0] != null){
		 
    	blockedMap.get(blockedbed[i][0]).add(bedStr);
 	}else {
	    ArrayList<String> blockedList = new ArrayList<String>();  
	    blockedList.add(bedStr);
	    blockedMap.put(blockedbed[i][0],blockedList);
 	}
    
}
	
//========= Process bed information =======


for (i=0; i<aCnt; i++ ) {

   if (!bedlist[i][0].equals(acm)) {
      acm = bedlist[i][0];
      bedList[++m][0] = bedlist[i][0];
      bedList[m][1] = bedList[m][2] = bedList[m][3] = bedList[m][4] = "";
      bedList[m][5] = bedList[m][6] = bedList[m][7] = bedList[m][8] = "";
      bkList[m][1] = bkList[m][2] = bkList[m][3] = bkList[m][4] = "";
      bkList[m][5] = bkList[m][6] = bkList[m][7] = bkList[m][8] = "";
   };   

  n = 1;
  bedStr="";
   if(bedlist[i][3] != null && !"".equals(bedlist[i][3])){
      bedStr = "<tr height=20 ><td>"+bedlist[i][3] + "</td>";
      for(int k=0;k<7;k++){
       bedStr +="<td>&nbsp;</td>";
      }
      bedStr += "</tr>";
   }
   
	if(inpatientMap.containsKey(bedlist[i][4])){
		Iterator itr = inpatientMap.get(bedlist[i][4]).iterator();
		while (itr.hasNext()) {
			 bedStr += itr.next().toString();
		}
	}
	
	if(bookingMap.containsKey(bedlist[i][4])){
		Iterator itr = bookingMap.get(bedlist[i][4]).iterator();
		while (itr.hasNext()) {
			 bedStr += itr.next().toString();
		}
	}
	if(blockedMap.containsKey(bedlist[i][4])){
		Iterator itr = blockedMap.get(bedlist[i][4]).iterator();
		while (itr.hasNext()) {
			
			 bedStr += itr.next().toString();
		}
	}



	
  if (bedlist[i][1].equals("OB")) { 
     bedList[m][1] += bedStr; 
     bedCnt[1] += n; 
     bedFre[1] += (bedlist[i][5]==null?1:0);
  } else if (bedlist[i][1].equals("SU")) { 
     bedList[m][2] += bedStr; 
     bedCnt[2] += n; 
     bedFre[2] += (bedlist[i][5]==null?1:0);
  } else if (bedlist[i][1].equals("PD")) { 
     bedList[m][3] += bedStr; 
     bedCnt[3] += n;
     bedFre[3] += (bedlist[i][5]==null?1:0);
  } else if (bedlist[i][1].equals("ME")) { 
     bedList[m][4] += bedStr;
     bedCnt[4] += n;
     bedFre[4] += (bedlist[i][5]==null?1:0);
  } else if (bedlist[i][1].equals("IN")) { 
     bedList[m][5] += bedStr;
     bedCnt[5] += n;
     bedFre[5] += (bedlist[i][5]==null?1:0);
  } else if (bedlist[i][1].equals("IC")) { 
     bedList[m][6] += bedStr;
     bedCnt[6] += n;
     bedFre[6] += (bedlist[i][5]==null?1:0);
  };
};

category[0] = "<tr><td width=10% height=5% style=\"color:white;background-color:green;\" ><font size=\"4\" >OB</font></td><td colspan=\"7\" style=\"color:white;background-color:green;\">&nbsp;</td></tr>";
category[1] = "<tr><td width=10% height=5% style=\"color:white;background-color:green;\"><font size=\"4\" >Surgical</font></td><td colspan=\"7\"style=\"color:white;background-color:green;\">&nbsp;</td></tr>";
category[2] = "<tr><td width=10% height=5% style=\"color:white;background-color:green;\"><font size=\"4\" >Pediatric Unit</font></td><td colspan=\"7\"style=\"color:white;background-color:green;\">&nbsp;</td></tr>";
category[3] = "<tr><td width=10% height=5% style=\"color:white;background-color:green;\"><font size=\"4\" >Medical Unit</font></td><td colspan=\"7\"style=\"color:white;background-color:green;\">&nbsp;</td></tr>";
category[4] = "<tr><td width=10% height=5% style=\"color:white;background-color:green;\"><font size=\"4\" >Integrated Unit</font></td><td colspan=\"7\"style=\"color:white;background-color:green;\">&nbsp;</td></tr>";
category[5] = "<tr><td width=10% height=5% style=\"color:white;background-color:green;\"><font size=\"4\" >ICU</font></td><td colspan=\"7\"style=\"color:white;background-color:green;\">&nbsp;</td></tr>";
%>
<table style="border"align=center width=20% border=1 cellpadding="0" cellspacing="0" > 
  <tr><td style="background-color:red"  width=10%></td><td>=Occupied</td></tr>
  <tr><td style="background-color:pink" width=10%></td><td>=Booked</td></tr>
  <tr><td style="background-color:grey" width=10%></td><td>Blocked</td></tr>
</table>
<br>
<table style="border"align=center width=98% border=1 cellpadding="0" cellspacing="0" > 
  <tr>
   <th width=3% height=30 valign=top>&nbsp;</th>
<% for(i=0;i<dayList.length;i++){ %>
   <%if(i==0) {%>
   	   <th width=10%>&nbsp;(Today)<br> <%=dayList[i] %></th>
   <%} else { %>
   		<th width=10%>&nbsp;<%=dayList[i] %></th>
	<%} %>
<%} %>

  </tr>

<%
//========= show table =============


for (i=0; i<6; i++) {
    out.println(category[i]);
    for(int j=0;j<=m;j++){
      if(!"".equals(bedList[j][i+1])){
          out.println("<tr><td height=5% style=\"color:black;background-color:lightblue\"><font size=3>"+bedList[j][0]+"</font></td><td colspan=\"7\"style=\"color:black;background-color:lightblue\">&nbsp;</td></tr>");  
      }
      out.println(bedList[j][i+1]);
	  //out.println("<tr><td height=5% style=\"background-color:pink\">Booking</td><td colspan=\"7\" >&nbsp;</td></tr>");
	 // out.println(bkList[j][i+1]);
    }
    
}
%>
</table>


<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>
