<%@ page import="java.text.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
UserBean userBean = new UserBean(request);
String DateFrom = ParserUtil.getParameter(request,"DateFrom");
String Ward = ParserUtil.getParameter(request,"Ward");
String Class = ParserUtil.getParameter(request,"Class");
String command = ParserUtil.getParameter(request,"command");

String searchCommand = ParserUtil.getParameter(request,"searchCommand");
String patNoSearch = ParserUtil.getParameter(request,"patNoSearch");

String patNo = ParserUtil.getParameter(request,"patNo");
String patFirstName = ParserUtil.getParameter(request,"patFirstName");
String patLastName = ParserUtil.getParameter(request,"patLastName");
String patTel = ParserUtil.getParameter(request,"patTel");
String patSex = ParserUtil.getParameter(request,"patSex");
String patIDNo = ParserUtil.getParameter(request,"patIDNo");

String bkDate = ParserUtil.getParameter(request,"bkDate");
String LOS = ParserUtil.getParameter(request,"LOS");
%>
<%!
/*======== Description of this page ===========
  This page is used to retrieve bed occupancy for 7 days
  
  Log: 20100110, cherry
================================================ */
//===booking==///
private boolean Booking(String pno,String patFirstName,String patLastName,String ptel,String sex, String pIdno,String bkDate,String LOS,String Ward, String Class ){
	
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append(" INSERT INTO BEDPREBOK(pbpid, doccode,patno,bpbodate, bpbhdate,ESTSTAYLEN,usrid,acmcode, wrdcode, ");
	sqlStr.append(" bpbsts,stecode,bpbpname,patfname,patgname,patkhtel,patidno,sex)");
	sqlStr.append("  VALUES (SEQ_BEDPREBOK.NEXTVAL,'1528','"+pno+"',");
	sqlStr.append(" to_date('"+bkDate+"','dd/mm/yyyy'),to_date('"+bkDate+"','dd/mm/yyyy'),"+LOS+", ");
	sqlStr.append(" 'Web','"+Class+"','"+Ward+"','N','HKAH', ");
	sqlStr.append(" '"+patFirstName+"' || ' ' || '"+patLastName+"','"+patFirstName+"', '"+patLastName+"', " );
    sqlStr.append(" '"+ptel+"','"+pIdno+"','"+sex+"') ");
	
	System.out.println("[start book]"+sqlStr.toString());
	if (UtilDBWeb.updateQueueHATS(sqlStr.toString())) {
		return true;
	} else {
		return false;
	}
}



//=====get 7 days===//
private ArrayList getDates(String DateFrom){
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append(" select distinct to_char(trunc(to_date('"+DateFrom+"','dd/mm/yyyy')),'dd/mm/yyyy'),to_char(trunc(to_date('"+DateFrom+"','dd/mm/yyyy')+ 1),'dd/mm/yyyy'), ");
	sqlStr.append(" to_char(trunc(to_date('"+DateFrom+"','dd/mm/yyyy')+ 2),'dd/mm/yyyy'),to_char(trunc(to_date('"+DateFrom+"','dd/mm/yyyy')+ 3),'dd/mm/yyyy'),to_char(trunc(to_date('"+DateFrom+"','dd/mm/yyyy')+ 4),'dd/mm/yyyy'), ");
	sqlStr.append(" to_char(trunc(to_date('"+DateFrom+"','dd/mm/yyyy')+ 5),'dd/mm/yyyy'),to_char(trunc(to_date('"+DateFrom+"','dd/mm/yyyy')+ 6),'dd/mm/yyyy') 	from bedprebok@hat");
	return UtilDBWeb.getReportableListCIS(sqlStr.toString());
}
//==get booking information==//
private ArrayList getBookingList(String DateFrom, String Ward, String Class,String Type){
	StringBuffer sqlStr = new StringBuffer();
	if("doctor".equals(Type)){
		sqlStr.append("SELECT sum(day1),sum(day2),sum(day3),sum(day4),sum(day5),sum(day6),sum(day7),ward,acm FROM( ");
	}
	sqlStr.append("select (select acmname from acm@hat x where x.acmcode=a.acmcode) as acm, wrdcode ward  ");
	sqlStr.append("  , to_char(bpbhdate,'dd/mm/yyyy') as bookdate, patno, sex ");
	sqlStr.append("  , (select substr(docfname||' '||docgname,1,10) from doctor@hat x where x.doccode=a.doccode) as docname ");
	sqlStr.append("  , eststaylen,bedcode ");
	sqlStr.append("  ,get_bov_bking(trunc(to_date('"+DateFrom+"','dd/mm/yyyy')),bpbhdate,eststaylen)day1 ");
	sqlStr.append("  ,get_bov_bking(trunc(to_date('"+DateFrom+"','dd/mm/yyyy')+1),bpbhdate,eststaylen)day2 ");
	sqlStr.append("  ,get_bov_bking(trunc(to_date('"+DateFrom+"','dd/mm/yyyy')+2),bpbhdate,eststaylen)day3 ");
	sqlStr.append("  ,get_bov_bking(trunc(to_date('"+DateFrom+"','dd/mm/yyyy')+3),bpbhdate,eststaylen)day4 ");
	sqlStr.append("  ,get_bov_bking(trunc(to_date('"+DateFrom+"','dd/mm/yyyy')+4),bpbhdate,eststaylen)day5 ");
	sqlStr.append("  ,get_bov_bking(trunc(to_date('"+DateFrom+"','dd/mm/yyyy')+5),bpbhdate,eststaylen)day6 ");
	sqlStr.append("  ,get_bov_bking(trunc(to_date('"+DateFrom+"','dd/mm/yyyy')+6),bpbhdate,eststaylen)day7 ");
	sqlStr.append("from bedprebok@hat a  ");
	sqlStr.append(" where  ");
	sqlStr.append(" bpbsts<>'F' and bpbsts<>'D' and acmcode ='"+Class+"' and wrdcode ='"+Ward+"' ");
	sqlStr.append("order by acmcode, wrdcode, bpbhdate  ");
	if("doctor".equals(Type)){
		sqlStr.append("  )GROUP BY ward,acm ");
	}
	
	System.out.println("[booking]"+sqlStr.toString());

	return UtilDBWeb.getReportableListCIS(sqlStr.toString());
}
//===get vacant bed information==///
 private ArrayList getForecastList(String DateFrom, String Ward, String Class,String Type){
		StringBuffer sqlStr = new StringBuffer();
		
		if("doctor".equals(Type)){
		  sqlStr.append("SELECT SUM(r1),SUM(r2),SUM(r3),SUM(r4),SUM(r5),SUM(r6),SUM(r7),ward,acm FROM( ");
		}
		sqlStr.append(" select b.bedcode,w.wrdcode ward, m.acmname,m.acmcode acm, ");
		sqlStr.append("	decode(info.test1,null,1,1,0,0,1)r1,decode(info.test2,null,1,1,0,0,1)r2,decode(info.test3,null,1,1,0,0,1)r3, ");
		sqlStr.append("	decode(info.test4,null,1,1,0,0,1)r4,decode(info.test5,null,1,1,0,0,1)r5,decode(info.test6,null,1,1,0,0,1)r6,decode(info.test7,null,1,1,0,0,1)r7 ");
	 	sqlStr.append(" from ward@hat w, hat_room r,acm@hat m,hat_bed b ");
		sqlStr.append(" left join ");
		sqlStr.append(" (select i.inpid,q.patno,q.patename,bedinfo.wrdcode, bedinfo.acmname, ");
	    sqlStr.append(" i.bedcode bed ,q.regdate,i.actstaylen,i.inpddate, ");
	  	sqlStr.append("	(select substr(docfname||' '||docgname,1,10) from doctor@hat x where x.doccode=q.DOCCODE_A) as docname1, "); 
	  	sqlStr.append("	(select substr(docfname||' '||docgname,1,10) from doctor@hat x where x.doccode=q.DOCCODE_D) as docname2,q.patsex, ");
	  	sqlStr.append("	 GET_BOV_INPAT( trunc(to_date('"+DateFrom+"','dd/mm/yyyy')),q.inpddate,q.regdate,i.actstaylen)test1, ");
	  	sqlStr.append("GET_BOV_INPAT( trunc(to_date('"+DateFrom+"','dd/mm/yyyy')+1),q.inpddate,q.regdate,i.actstaylen)test2, ");
	  	sqlStr.append("GET_BOV_INPAT( trunc(to_date('"+DateFrom+"','dd/mm/yyyy')+2),q.inpddate,q.regdate,i.actstaylen)test3, ");
	  	sqlStr.append("GET_BOV_INPAT( trunc(to_date('"+DateFrom+"','dd/mm/yyyy')+3),q.inpddate,q.regdate,i.actstaylen)test4, ");
	  	sqlStr.append("GET_BOV_INPAT( trunc(to_date('"+DateFrom+"','dd/mm/yyyy')+4),q.inpddate,q.regdate,i.actstaylen)test5, ");
	  	sqlStr.append("GET_BOV_INPAT( trunc(to_date('"+DateFrom+"','dd/mm/yyyy')+5),q.inpddate,q.regdate,i.actstaylen)test6, ");
	  	sqlStr.append("GET_BOV_INPAT( trunc(to_date('"+DateFrom+"','dd/mm/yyyy')+6),q.inpddate,q.regdate,i.actstaylen)test7 ");
	  	sqlStr.append("from inpat@hat i,qry_inpatient q  ");
	  	sqlStr.append("join  ");
	  	sqlStr.append("(select b.bedcode,w.wrdcode, m.acmname, m.acmcode from ward@hat w, hat_room r, hat_bed b,acm@hat m ");
	  	sqlStr.append("where b.romcode = r.romcode and r.wrdcode = w.wrdcode and r.acmcode = m.acmcode and b.bedoff = -1) bedinfo ");
	  	sqlStr.append("on bedinfo.bedcode = q.bedcode ");
		sqlStr.append("where i.inpid = q.inpid and q.regsts = 'N'  ");
	  	sqlStr.append("and (q.inpddate is null or q.inpddate = sysdate) ");
	  	sqlStr.append("and q.inpddate is null ");
	  	sqlStr.append("and bedinfo.wrdcode = '"+Ward+"' ");
	  	sqlStr.append("and bedinfo.acmcode = '"+Class+"' ");
	    sqlStr.append(" )info ");
	    sqlStr.append("on b.bedcode = info.bed ");
	    sqlStr.append("where b.romcode = r.romcode and r.wrdcode = w.wrdcode and r.acmcode = m.acmcode and b.bedoff = -1 ");
	    sqlStr.append("and m.acmcode = '"+Class+"' and r.wrdcode = '"+Ward+"' ");	
		if("doctor".equals(Type)){
			sqlStr.append("  )GROUP BY ward,acm ");
		}
	
	System.out.println("[forecast]"+sqlStr.toString());
	
	return UtilDBWeb.getReportableListCIS(sqlStr.toString());
}
//=====get inpatient information===///
private ArrayList getInpatientList(String DateFrom, String Ward, String Class,String Type){
	StringBuffer sqlStr = new StringBuffer();
	if("doctor".equals(Type)){
		  sqlStr.append("SELECT SUM(test1),SUM(test2),SUM(test3),SUM(test4),SUM(test5),SUM(test6),SUM(test7),ward,acm FROM( ");
		}
	sqlStr.append("select i.inpid,q.patno,q.patename,bedinfo.wrdcode ward, bedinfo.acmname, ");
	sqlStr.append("i.bedcode,q.regdate,i.actstaylen,i.inpddate, ");
	sqlStr.append("	(select substr(docfname||' '||docgname,1,10) from doctor@hat x where x.doccode=q.DOCCODE_A) as docname1, "); 
	sqlStr.append("	(select substr(docfname||' '||docgname,1,10) from doctor@hat x where x.doccode=q.DOCCODE_D) as docname2,q.patsex, ");
	sqlStr.append("	 GET_BOV_INPAT( trunc(to_date('"+DateFrom+"','dd/mm/yyyy')),q.inpddate,q.regdate,i.actstaylen)test1, ");
	sqlStr.append("GET_BOV_INPAT( trunc(to_date('"+DateFrom+"','dd/mm/yyyy')+1),q.inpddate,q.regdate,i.actstaylen)test2, ");
	sqlStr.append("GET_BOV_INPAT( trunc(to_date('"+DateFrom+"','dd/mm/yyyy')+2),q.inpddate,q.regdate,i.actstaylen)test3, ");
	sqlStr.append("GET_BOV_INPAT( trunc(to_date('"+DateFrom+"','dd/mm/yyyy')+3),q.inpddate,q.regdate,i.actstaylen)test4, ");
	sqlStr.append("GET_BOV_INPAT( trunc(to_date('"+DateFrom+"','dd/mm/yyyy')+4),q.inpddate,q.regdate,i.actstaylen)test5, ");
	sqlStr.append("GET_BOV_INPAT( trunc(to_date('"+DateFrom+"','dd/mm/yyyy')+5),q.inpddate,q.regdate,i.actstaylen)test6, ");
	sqlStr.append("GET_BOV_INPAT( trunc(to_date('"+DateFrom+"','dd/mm/yyyy')+6),q.inpddate,q.regdate,i.actstaylen)test7, ");
	sqlStr.append(" bedinfo.acmcode acm ");
	sqlStr.append("from inpat@hat i,qry_inpatient q  ");
	sqlStr.append("join  ");
	sqlStr.append("(select b.bedcode,w.wrdcode, m.acmname, m.acmcode from ward@hat w, hat_room r, hat_bed b,acm@hat m ");
	sqlStr.append("where b.romcode = r.romcode and r.wrdcode = w.wrdcode and r.acmcode = m.acmcode and b.bedoff = -1) bedinfo ");
	sqlStr.append("on bedinfo.bedcode = q.bedcode ");
	sqlStr.append("where i.inpid = q.inpid and q.regsts = 'N'  ");
	sqlStr.append("and (q.inpddate is null or q.inpddate = sysdate) ");
	sqlStr.append("and q.inpddate is null ");
	sqlStr.append("and bedinfo.wrdcode = '"+Ward+"' ");
	sqlStr.append("and bedinfo.acmcode = '"+Class+"' ");
	if("doctor".equals(Type)){
		sqlStr.append("   ) GROUP BY ward,acm ");
	}
	System.out.println("[inpatient]"+sqlStr.toString());
	
	return UtilDBWeb.getReportableListCIS(sqlStr.toString());
}

private StringBuffer parseTable(ArrayList recordVacant, ArrayList recordBk,ArrayList recordInp,String printTitle,ArrayList dayList) {

	StringBuffer strOut = new StringBuffer();
	int[] bedAvailable = new int[7];
	ReportableListObject row1 = null;
	ReportableListObject row2 = null;
	ReportableListObject row3 = null;
	ReportableListObject row4 = null;
	if (recordVacant.size() > 0 &&recordBk.size() >0) {
		row1 = (ReportableListObject)recordVacant.get(0);
		row2 = (ReportableListObject)recordBk.get(0);
		row3 = (ReportableListObject)recordInp.get(0);
		row4 = (ReportableListObject)dayList.get(0);
		
		strOut.append("<tr>");
		strOut.append("<td BGCOLOR=\"#FF6699\">"+printTitle+"</td>");
		for(int i=0;i<7;i++){
				int temp = Integer.parseInt(row1.getValue(i))- Integer.parseInt(row2.getValue(i))-Integer.parseInt(row3.getValue(i));
				strOut.append("<td valign=\"top\" align=\"center\"><table style=\"border\"  border=1>");
				for(int k=0;k<temp;k++){
					strOut.append("<tr><td><input type=\"button\" class=\"groovybutton\" value=\"Bed\" onclick=\"return submitAction('booking','"+row4.getValue(i)+"');\"></td></tr>");
	

				}
			strOut.append("</table></td>");
	
		}
		strOut.append("</tr>");
	}
	System.out.println("[Result]"+strOut.toString());

	return strOut;
}
private StringBuffer parseTable(ArrayList record, String printTitle, String Type,String DateFrom) {
	ReportableListObject row = null;
	ReportableListObject rowDay = null;
	StringBuffer day1 = new StringBuffer();
	StringBuffer day2 = new StringBuffer();
	StringBuffer day3 = new StringBuffer();
	StringBuffer day4 = new StringBuffer();
	StringBuffer day5 = new StringBuffer();
	StringBuffer day6 = new StringBuffer();
	StringBuffer day7 = new StringBuffer();
	StringBuffer strOut = new StringBuffer();
	int fieldCount = 0;
	int displayValue = 0;
	String valueCount = null;
	String temphtml1 = null;
	String temphtml2 = null;

	ArrayList dayList = getDates(DateFrom);
	if(dayList.size() >0){
		rowDay = (ReportableListObject)dayList.get(0);
	}
	
	if("1".equals(Type)){
		fieldCount=12;
		displayValue = 5;
		valueCount = "1";
		
	}else if ("2".equals(Type)){
		fieldCount=8;
		displayValue = 7;
		valueCount = "1";
		
	}else if ("3".equals(Type)){
		fieldCount = 4;
		displayValue=0;
		valueCount = "1";
	}
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			
			String displayInformation ="";
			if("1".equals(Type)){
			displayInformation = "title=\" Patient No:"+row.getValue(1)+"<br>Patient Name:"+row.getValue(2)+"  \" ";
			}

				if(valueCount.equals(row.getValue(fieldCount))){
					if("3".equals(Type)){
						day1.append("<tr><td><input type=\"button\" class=\"groovybutton\" value=\""+row.getValue(displayValue)+"\" onclick=\"return submitAction('booking','"+rowDay.getValue(0)+"');\"></td></tr>");
					}else{
						day1.append("<tr><td "+displayInformation+">"+row.getValue(displayValue)+"</td></tr>");
					}
				}if(valueCount.equals(row.getValue(fieldCount+1))){	
					if("3".equals(Type)){
						day2.append("<tr><td><input type=\"button\" class=\"groovybutton\" value=\""+row.getValue(displayValue)+"\" onclick=\"return submitAction('booking','"+rowDay.getValue(1)+"');\"></td></tr>");
					}else{
						day2.append("<tr><td>"+row.getValue(displayValue)+"</td></tr>"); 
					}
				}if(valueCount.equals(row.getValue(fieldCount+2))){
					 if("3".equals(Type)){
						 day3.append("<tr><td><input type=\"button\" class=\"groovybutton\" value=\""+row.getValue(displayValue)+"\" onclick=\"return submitAction('booking','"+rowDay.getValue(2)+"');\"></td></tr>");
					 }else{
					   	 day3.append("<tr><td>"+row.getValue(displayValue)+"</td></tr>");
					 }
				}if(valueCount.equals(row.getValue(fieldCount+3))){
					 if("3".equals(Type)){
						 day4.append("<tr><td><input type=\"button\" class=\"groovybutton\" value=\""+row.getValue(displayValue)+"\" onclick=\"return submitAction('booking','"+rowDay.getValue(3)+"');\"></td></tr>");
					 }else{
						 day4.append("<tr><td>"+row.getValue(displayValue)+"</td></tr>");
					 }
				}if(valueCount.equals(row.getValue(fieldCount+4))){
					 if("3".equals(Type)){
						 day5.append("<tr><td><input type=\"button\" class=\"groovybutton\" value=\""+row.getValue(displayValue)+"\" onclick=\"return submitAction('booking','"+rowDay.getValue(4)+"');\"></td></tr>");
					 }else{
						day5.append("<tr><td>"+row.getValue(displayValue)+"</td></tr>");
					 }
				}if(valueCount.equals(row.getValue(fieldCount+5))){
					 if("3".equals(Type)){
						day6.append("<tr><td><input type=\"button\" class=\"groovybutton\" value=\""+row.getValue(displayValue)+"\" onclick=\"return submitAction('booking','"+rowDay.getValue(5)+"');\"></td></tr>");
					 }else{
						day6.append("<tr><td>"+row.getValue(displayValue)+"</td></tr>");
					 }
				}if(valueCount.equals(row.getValue(fieldCount+6))){
					 if("3".equals(Type)){
						day7.append("<tr><td><input type=\"button\" class=\"groovybutton\" value=\""+row.getValue(displayValue)+"\" onclick=\"return submitAction('booking','"+rowDay.getValue(6)+"');\"></td></tr>");
					}else{
					 	day7.append("<tr><td>"+row.getValue(displayValue)+"</td></tr>");
					}
				}       
		}
	}
	strOut.append("<tr>");
	strOut.append("<td BGCOLOR=\"#FF6699\">"+printTitle+"</td>");
	strOut.append("<td valign=\"top\" align=\"center\"><table style=\"border\"  border=1>"+day1.toString()+"</table></td>");
	strOut.append("<td valign=\"top\" align=\"center\"><table style=\"border\"align=center  border=1>"+day2.toString()+"</table></td>");
	strOut.append("<td valign=\"top\" align=\"center\"><table style=\"border\"align=center  border=1>"+day3.toString()+"</table></td>");
	strOut.append("<td valign=\"top\" align=\"center\"><table style=\"border\"align=center  border=1>"+day4.toString()+"</table></td>");
	strOut.append("<td valign=\"top\" align=\"center\"><table style=\"border\"align=center  border=1>"+day5.toString()+"</table></td>");
	strOut.append("<td valign=\"top\" align=\"center\"><table style=\"border\"align=center  border=1>"+day6.toString()+"</table></td>");
	strOut.append("<td valign=\"top\" align=\"center\"><table style=\"border\"align=center  border=1>"+day7.toString()+"</table></td>");
	strOut.append("<tr>");
	
	
	return strOut;
}
%>
<%
if("booking".equals(command)){
	Booking(patNo,patFirstName,patLastName,patTel,patSex,patIDNo,bkDate,LOS,Ward,Class);
} 
if("patient".equals(searchCommand)){
	ArrayList record = AdmissionDB.getHATSPatient(patNoSearch,"","");
	ReportableListObject row = null;
	if (record.size() > 0) {
		row = (ReportableListObject) record.get(0);
	}
	patNo = row.getValue(0);
	patFirstName = row.getValue(1);
	patLastName = row.getValue(2);
	patIDNo = row.getValue(5);
	patSex = row.getValue(6);
}
%>



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
</head>

<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Bed Overview by Date" />
</jsp:include>
<br>
<table width="100%">
<tr>
<%if("doctor".equals(command)) %>
<td width="40%">
		<form name="search_form" action="bed_booking_7days_test.jsp" method="post">
		<table cellpadding="0" cellspacing="5" border="0">
			<tr class="smallText">
				<td class="infoLabel">Patient No</td>
				<td class="infoData">
					<input type="text" name="patNoSearch" id="patNoSearch"  maxlength="100" size="5" >
				</td>
				<td  align="center">
							<button onclick="return submitSearch('patient','');"><bean:message key="button.search" /></button>
				</td>					
			</tr>	
			<tr class="smallText">
				<td class="infoLabel">Patient No</td>
				<td class="infoData" colspan="2"><%=patNo != null?patNo:"" %></td>
			</tr>
			<tr class="smallText">
				<td class="infoLabel">Patient Name</td>
				<td class="infoData" colspan="2"><%=patLastName != null?patLastName+" "+patFirstName:""  %></td>
			</tr>
		</table>
			<table cellpadding="0" cellspacing="5" border="0">
					<tr class="smallText">
						<td class="infoLabel" width="30%">Date From</td>
						<td class="infoData" width="70%"><input type="text" name="DateFrom" class="datepickerfield" value="<%=DateFrom == null ? "" : DateFrom%>" maxlength="10" size="10"></td>
					</tr>
					<tr class="smallText">
						<td class="infoLabel" width="30%">Ward</td>
						<td class="infoData" width="70%">
							<select name="Ward">
							<jsp:include page="../ui/ward_classCMB.jsp" flush="false">
							<jsp:param name="Type" value="Ward"/>
							<jsp:param name="Value" value="<%=Ward%>"/>
							</jsp:include>
							</select>
						</td>
					</tr>
					<tr class="smallText">
						<td class="infoLabel" width="30%">Class</td>
						<td class="infoData" width="70%">
							<select name="Class">
							<jsp:include page="../ui/ward_classCMB.jsp" flush="false">
							<jsp:param name="Type" value="Class"/>
							<jsp:param name="Value" value="<%=Class%>"/>
							</jsp:include>
							</select>
						</td>
					</tr>
					<tr class="smallText">
						<td colspan="2" align="center">
							<%if("doctor".equals(command)){ %>
							<button onclick="return submitSearch('bed','doctor');"><bean:message key="button.search" /></button>							
							<%}else{ %>
							<button onclick="return submitSearch('bed','');"><bean:message key="button.search" /></button>							
							<%} %>
						</td>
					</tr>
			</table>
	
		

			<table border="0">
				<tr><td colspan="2">&nbsp;</td></tr>
					<tr class="smallText">
						<td class="infoLabel">Booking Date</td>
						<td class="infoData"><input type="text" name="bkDate" class="datepickerfield" value="<%=DateFrom == null ? "" : DateFrom%>" maxlength="10" size="10"></td>
					</tr>
					<tr >
						<td class="infoLabel">Length of Stay</td>
						<td class="infoData">
						<input type="text" name="LOS" id="LOS"  maxlength="100" size="5" >
						</td>					
					</tr>
					<tr>
						<td>
							<button onclick="submitAction('booking','');" class="btn-click">Booking</button>
						</td>
					</tr>
			</table>	

		<input type="hidden" name="command" />	
		<input type="hidden" name="searchCommand" />	
		<input type="hidden" name="patNo" value="<%=patNo %>"/>
		<input type="hidden" name="patFirstName" value="<%=patFirstName %>"/>		
		<input type="hidden" name="patLastName" value="<%=patLastName %>"/>
		<input type="hidden" name="patTel" value="<%=patTel %>"/>
		<input type="hidden" name="patSex" value="<%=patSex %>"/>
		<input type="hidden" name="patIDNo" value="<%=patIDNo %>"/>

	</form>


</td>
<td width="60%">
		<form name ="form1">

		<%if(!"".equals(DateFrom)&& DateFrom != null) {%>		
			<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
				<tr>
					<td class="infoLabel" width="10%">Ward</td>
					<td class="infoData" width="10%"><%=Ward %></td>
					<td class="infoLabel" width="10%">Class</td>
					<td class="infoData" width="70%"><%="P".equals(Class)?"Private":("S".equals(Class)?"Semi-Private":("T".equals(Class)?"Standard":"VIP"))%></td>
				</tr>
			</table>
				
				<table style="border"align="center"  border=1>
					<tr>
						<td>&nbsp;</td>
					<%
					ArrayList dayList = getDates(DateFrom);
					StringBuffer strbuf = new StringBuffer();
					StringBuffer bkButtonList = new StringBuffer();
					bkButtonList.append("<tr align=\"center\" >");
					bkButtonList.append("<td>&nbsp;</td>");

					if (dayList.size() > 0) {
							ReportableListObject row = (ReportableListObject) dayList.get(0);
							for(int i=0;i<7;i++){%> 
								<td class="infoCenterLabel" width="16%"><%=row.getValue(i) %></td>
								<%bkButtonList.append("<td><input type=\"button\" class=\"groovybutton\" value=\"Bed\" onclick=\"return submitAction('booking','"+row.getValue(i)+"');\"></td>"); %>
					<%		}
							bkButtonList.append("</tr>");		
					}
					%>
					</tr>

							<%StringBuffer inpatList = parseTable(getInpatientList(DateFrom,Ward,Class,""),"Occupied","1",DateFrom);%>
							<%=inpatList.toString() %>
							<%if("doctor".equals(command)){ %>
								<%StringBuffer doctorList = parseTable(
										getForecastList(DateFrom,Ward,Class,"doctor"),
										getBookingList(DateFrom,Ward,Class,"doctor"),
										getInpatientList(DateFrom,Ward,Class,"doctor"),
										"Available",dayList);%>
								<%=doctorList.toString() %>
							<%}else{ %>
								<%StringBuffer forecastList = parseTable(getForecastList(DateFrom,Ward,Class,""),"Vacant","3",DateFrom);%>
								<%=forecastList.toString() %>
							<%} %>
							<%StringBuffer bookingList = parseTable(getBookingList(DateFrom,Ward,Class,""),"Booking","2",DateFrom);%>
							<%=bookingList.toString() %>

											
				</table>
		<%} %>
		</form>
</td></tr>
</table>
<script>
$('td[title]').qtip({
	   content: $(this).attr('title'),
	   show: 'mouseover',
	   hide: 'mouseout',
	   position: { target: 'mouse' },
	   style: {
		      border: {
		         width: 3,
		         radius: 8,
		         color: '#6699CC',
		         tip: 'leftMiddle'
		      },
		      width: 200
		}
	});

function submitSearch(cmd,type) {
	document.search_form.searchCommand.value = cmd;
	if(type != null && type !=''){
	document.search_form.command.value = type;
	}
	document.search_form.submit();
	
}

function submitAction(cmd,date){
	if(cmd=='booking'){
		if(document.search_form.LOS.value != ''){
			document.search_form.command.value = cmd;
			if(date !=null && date != ''){
			document.search_form.bkDate.value = date;
			}
			document.search_form.submit();
			return false;
			
		}else{
			alert("Please fill in the booking Date and the Length of Stay.");
			return false;
		}
	}else if (cmd=='doctor'){
		document.search_form.searchCommand.value = cmd;
		document.search_form.submit();
	}
		
}
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>
