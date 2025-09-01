<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="org.apache.struts.*"%>
<%!
public static ArrayList getVaccineList(String disCode) {
	
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append(" SELECT v.VAC_CODE, v.vac_name, v.vac_cname "); 
	sqlStr.append(" FROM IMM_VACCINE v INNER JOIN IMM_VACCINE_DISEASE vd on v.vac_code = vd.vac_code ");
	sqlStr.append(" WHERE vd.dis_code = ? ");
	sqlStr.append(" ORDER BY v.VAC_CODE ");

	return  UtilDBWeb.getReportableListCIS(sqlStr.toString(),
		new String[] { disCode });
			
}

private static String getInfectedDate( String patno ) {
	
	String date = null;
	StringBuffer sqlStr = new StringBuffer();

	sqlStr = new StringBuffer();
	sqlStr.append("SELECT TO_CHAR(TO_DATE(MAX(EVENT_DATE), 'YYYY-MM-DD'), 'DD/MM/YYYY') FROM IMM_MED_HIST ");
	sqlStr.append(" WHERE STAFF_ID = ? ");
	sqlStr.append(" AND DIS_CODE = 'COVID19' ");
	sqlStr.append(" AND EVENT = 'INFECTED' ");

	ArrayList record = UtilDBWeb.getReportableListCIS(sqlStr.toString(),  
		new String[] { patno });
	
	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		date = row.getValue(0);
	}
	
	return date;
}

private static ReportableListObject getRejectReason( String patno ) {
		
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT remark FROM IMM_MED_HIST ");
	sqlStr.append(" WHERE STAFF_ID = ? ");
	sqlStr.append(" AND DIS_CODE = 'COVID19' ");
	sqlStr.append(" AND EVENT = 'NOT VACCINATE' ");
	
	ArrayList record = UtilDBWeb.getReportableListCIS(sqlStr.toString(),  
		new String[] { patno });

	if (record.size() > 0) {
		return (ReportableListObject)record.get(0);
	}

	return null;
}

private static ArrayList getVaccineHist(String patno) {
	
	StringBuffer sqlStr = new StringBuffer();
/*
	sqlStr.append(" SELECT ROWID, REMARK, TO_CHAR(TO_DATE(EVENT_DATE, 'yyyy-mm-dd'), 'dd/mm/yyyy') FROM IMM_MED_HIST ");
	sqlStr.append(" WHERE STAFF_ID = ? ");	
	sqlStr.append(" AND REMARK = ");	
	sqlStr.append(" 	(SELECT MIN(REMARK) FROM IMM_MED_HIST ");
	sqlStr.append(" 	WHERE STAFF_ID = ? AND dis_code = 'COVID19' AND EVENT='VACCINATE' AND EVENT_DATE = ");
	sqlStr.append("			(select min(EVENT_date) FROM IMM_MED_HIST ");
	sqlStr.append("			WHERE STAFF_ID = ? AND dis_code = 'COVID19' AND EVENT='VACCINATE') ");	
	sqlStr.append("		) ");	
	sqlStr.append(" ORDER BY EVENT_DATE ");
*/
	sqlStr.append(" SELECT ROWID, REMARK, TO_CHAR(TO_DATE(EVENT_DATE, 'yyyy-mm-dd'), 'dd/mm/yyyy') FROM IMM_MED_HIST ");
	sqlStr.append(" WHERE STAFF_ID = ? ");	
	sqlStr.append(" ORDER BY EVENT_DATE ");
	
	return  UtilDBWeb.getReportableListCIS(sqlStr.toString(),  
		new String[] { patno });
}

/*
private static boolean save(String staffId, String infDate, boolean reject, String rejectReason, String vacCode, String rowid1, String rowid2, String date1, String date2, String user) {
	
	StringBuffer sqlStr = new StringBuffer();
	ArrayList record = null;
	boolean rtn = true;
	
	sqlStr.append("DELETE IMM_MED_HIST ");
	sqlStr.append(" WHERE STAFF_ID = ? ");
	sqlStr.append(" AND DIS_CODE = 'COVID19' ");
	sqlStr.append(" AND EVENT = 'INFECTED' ");
	
	UtilDBWeb.updateQueueCIS( sqlStr.toString(),
		new String[] { staffId });
	
	
	if ( (infDate != null) && !infDate.isEmpty() ) {
		
		sqlStr = new StringBuffer();
			
		sqlStr.append("INSERT INTO IMM_MED_HIST (STAFF_ID, DIS_CODE, EVENT_DATE, EVENT, create_date, create_by) ");
		sqlStr.append(" VALUES (?, 'COVID19', TO_CHAR(TO_DATE(?, 'dd/mm/yyyy'), 'yyyy-mm-dd'), 'INFECTED', sysdate, ?) ");
			
		rtn = rtn && UtilDBWeb.updateQueueCIS( sqlStr.toString(),
			new String[] { staffId, infDate, user });
		if (!rtn)
			System.out.println(sqlStr.toString());
	}
	
	//delete
	sqlStr = new StringBuffer();
	sqlStr.append("DELETE IMM_MED_HIST ");
	sqlStr.append(" WHERE STAFF_ID = ? ");
	sqlStr.append(" AND DIS_CODE = 'COVID19' ");
	sqlStr.append(" AND EVENT = 'NOT VACCINATE' ");

	UtilDBWeb.updateQueueCIS( sqlStr.toString(),
		new String[] { staffId });
	
	if (reject) {
		sqlStr = new StringBuffer();
		sqlStr.append("DELETE IMM_MED_HIST ");
		sqlStr.append(" WHERE STAFF_ID = ? ");
		sqlStr.append(" AND DIS_CODE = 'COVID19' ");
		sqlStr.append(" AND EVENT = 'VACCINATE' ");

		UtilDBWeb.updateQueueCIS( sqlStr.toString(),
				new String[] { staffId });	
		
		sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO IMM_MED_HIST (STAFF_ID, DIS_CODE, EVENT_DATE, EVENT, remark, create_date, create_by) ");
		sqlStr.append(" VALUES (?, 'COVID19', TO_CHAR(SYSDATE, 'yyyy-mm-dd'), 'NOT VACCINATE', ?, sysdate, ?) ");

		rtn = rtn && UtilDBWeb.updateQueueCIS( sqlStr.toString(),
			new String[] { staffId, rejectReason, user });
		if (!rtn)
			System.out.println(sqlStr.toString());
		
	} else {
		sqlStr = new StringBuffer();
		sqlStr.append("DELETE IMM_MED_HIST ");
		sqlStr.append(" WHERE rowid in (?, ?) ");  

		UtilDBWeb.updateQueueCIS( sqlStr.toString(),
			new String[] { rowid1, rowid2 });

		//dose1
		sqlStr = new StringBuffer();
		sqlStr.append("SELECT * FROM IMM_MED_HIST ");
		sqlStr.append(" WHERE STAFF_ID = ? AND DIS_CODE='COVID19' AND EVENT='VACCINATE' REMARK = ? AND TO_CHAR(TO_DATE(EVENT_DATE, 'yyyy-mm-dd'), 'dd/mm/yyyy') = ? ");
		
		record = UtilDBWeb.getReportableListCIS(sqlStr.toString(),  
			new String[] { staffId, vacCode, date1 });
		
		if (record.size() == 0) {
			sqlStr = new StringBuffer();
			sqlStr.append("INSERT INTO IMM_MED_HIST (STAFF_ID, REMARK, EVENT_DATE, create_date, create_by, DIS_CODE, EVENT) ");
			sqlStr.append(" VALUES (?, ?, TO_CHAR(TO_DATE(?, 'dd/mm/yyyy'), 'yyyy-mm-dd'), sysdate, ?, 'COVID19', 'VACCINATE') ");
			rtn = rtn && UtilDBWeb.updateQueueCIS( sqlStr.toString(),
				new String[] { staffId, vacCode, date1, user });	
			if (!rtn)
				System.out.println(sqlStr.toString());
		} 
		

		//dose2		
		if ( (date2 != null) && !date2.isEmpty() ) {
			sqlStr = new StringBuffer();
			sqlStr.append("SELECT * FROM IMM_MED_HIST ");
			sqlStr.append(" WHERE STAFF_ID = ? AND DIS_CODE='COVID19' AND EVENT='VACCINATE' REMARK = ? AND TO_CHAR(TO_DATE(EVENT_DATE, 'yyyy-mm-dd'), 'dd/mm/yyyy') = ? ");
			
			record = UtilDBWeb.getReportableListCIS(sqlStr.toString(),  
				new String[] { staffId, vacCode, date2 });
			
			if (record.size() == 0) {
				sqlStr = new StringBuffer();
				sqlStr.append("INSERT INTO IMM_MED_HIST (STAFF_ID, REMARK, EVENT_DATE, create_date, create_by, DIS_CODE, EVENT) ");
				sqlStr.append(" VALUES (?, ?, TO_CHAR(TO_DATE(?, 'dd/mm/yyyy'), 'yyyy-mm-dd'), sysdate, ?, 'COVID19', 'VACCINATE') ");
				rtn = rtn && UtilDBWeb.updateQueueCIS( sqlStr.toString(),
					new String[] { staffId, vacCode, date2, user });	
				if (!rtn)
					System.out.println(sqlStr.toString());
			} 
		}

	}
	
	return rtn;
}
*/

private static boolean save(String staffId, String infDate, boolean reject, String rejectReason, 
		String rowid1, String vacCode1, String date1,
		String rowid2, String vacCode2, String date2, 
		String rowid3, String vacCode3, String date3, 
		String rowid4, String vacCode4, String date4, 
		String user) {
	
	StringBuffer sqlStr = new StringBuffer();
	ArrayList record = null;
	boolean rtn = true;
	
	sqlStr.append("DELETE IMM_MED_HIST ");
	sqlStr.append(" WHERE STAFF_ID = ? ");
	sqlStr.append(" AND DIS_CODE = 'COVID19' ");
	sqlStr.append(" AND EVENT = 'INFECTED' ");
	
	UtilDBWeb.updateQueueCIS( sqlStr.toString(),
		new String[] { staffId });
	
	
	if ( (infDate != null) && !infDate.isEmpty() ) {
		
		sqlStr = new StringBuffer();
			
		sqlStr.append("INSERT INTO IMM_MED_HIST (STAFF_ID, DIS_CODE, EVENT_DATE, EVENT, create_date, create_by) ");
		sqlStr.append(" VALUES (?, 'COVID19', TO_CHAR(TO_DATE(?, 'dd/mm/yyyy'), 'yyyy-mm-dd'), 'INFECTED', sysdate, ?) ");
			
		rtn = rtn && UtilDBWeb.updateQueueCIS( sqlStr.toString(),
			new String[] { staffId, infDate, user });
		if (!rtn)
			System.out.println(sqlStr.toString());
	}
	
	//delete
	sqlStr = new StringBuffer();
	sqlStr.append("DELETE IMM_MED_HIST ");
	sqlStr.append(" WHERE STAFF_ID = ? ");
	sqlStr.append(" AND DIS_CODE = 'COVID19' ");
	sqlStr.append(" AND EVENT = 'NOT VACCINATE' ");

	UtilDBWeb.updateQueueCIS( sqlStr.toString(),
		new String[] { staffId });
	
	if (reject) {
		sqlStr = new StringBuffer();
		sqlStr.append("DELETE IMM_MED_HIST ");
		sqlStr.append(" WHERE STAFF_ID = ? ");
		sqlStr.append(" AND DIS_CODE = 'COVID19' ");
		sqlStr.append(" AND EVENT = 'VACCINATE' ");

		UtilDBWeb.updateQueueCIS( sqlStr.toString(),
				new String[] { staffId });	
		
		sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO IMM_MED_HIST (STAFF_ID, DIS_CODE, EVENT_DATE, EVENT, remark, create_date, create_by) ");
		sqlStr.append(" VALUES (?, 'COVID19', TO_CHAR(SYSDATE, 'yyyy-mm-dd'), 'NOT VACCINATE', ?, sysdate, ?) ");

		rtn = rtn && UtilDBWeb.updateQueueCIS( sqlStr.toString(),
			new String[] { staffId, rejectReason, user });
		if (!rtn)
			System.out.println(sqlStr.toString());
		
	} else {
		sqlStr = new StringBuffer();
		sqlStr.append("DELETE IMM_MED_HIST ");
		sqlStr.append(" WHERE rowid in (?, ?, ?, ?) ");  

		UtilDBWeb.updateQueueCIS( sqlStr.toString(),
			new String[] { rowid1, rowid2, rowid3, rowid4 });

		//dose1
		if ( (date1 != null) && !date1.isEmpty() ) {
			sqlStr = new StringBuffer();
			sqlStr.append("SELECT * FROM IMM_MED_HIST ");
			sqlStr.append(" WHERE STAFF_ID = ? AND DIS_CODE='COVID19' AND EVENT='VACCINATE' AND REMARK = ? AND TO_CHAR(TO_DATE(EVENT_DATE, 'yyyy-mm-dd'), 'dd/mm/yyyy') = ? ");
			
			record = UtilDBWeb.getReportableListCIS(sqlStr.toString(),  
				new String[] { staffId, vacCode1, date1 });
			
			if (record.size() == 0) {
				sqlStr = new StringBuffer();
				sqlStr.append("INSERT INTO IMM_MED_HIST (STAFF_ID, REMARK, EVENT_DATE, create_date, create_by, DIS_CODE, EVENT) ");
				sqlStr.append(" VALUES (?, ?, TO_CHAR(TO_DATE(?, 'dd/mm/yyyy'), 'yyyy-mm-dd'), sysdate, ?, 'COVID19', 'VACCINATE') ");
				rtn = rtn && UtilDBWeb.updateQueueCIS( sqlStr.toString(),
					new String[] { staffId, vacCode1, date1, user });	
				if (!rtn)
					System.out.println(sqlStr.toString());
			} 
		}
		
		//dose2		
		if ( (date2 != null) && !date2.isEmpty() ) {
			sqlStr = new StringBuffer();
			sqlStr.append("SELECT * FROM IMM_MED_HIST ");
			sqlStr.append(" WHERE STAFF_ID = ? AND DIS_CODE='COVID19' AND EVENT='VACCINATE' AND REMARK = ? AND TO_CHAR(TO_DATE(EVENT_DATE, 'yyyy-mm-dd'), 'dd/mm/yyyy') = ? ");
			
			record = UtilDBWeb.getReportableListCIS(sqlStr.toString(),  
				new String[] { staffId, vacCode2, date2 });
			
			if (record.size() == 0) {
				sqlStr = new StringBuffer();
				sqlStr.append("INSERT INTO IMM_MED_HIST (STAFF_ID, REMARK, EVENT_DATE, create_date, create_by, DIS_CODE, EVENT) ");
				sqlStr.append(" VALUES (?, ?, TO_CHAR(TO_DATE(?, 'dd/mm/yyyy'), 'yyyy-mm-dd'), sysdate, ?, 'COVID19', 'VACCINATE') ");
				rtn = rtn && UtilDBWeb.updateQueueCIS( sqlStr.toString(),
					new String[] { staffId, vacCode2, date2, user });	
				if (!rtn)
					System.out.println(sqlStr.toString());
			} 
		}
		
		//dose3		
		if ( (date3 != null) && !date3.isEmpty() ) {
			sqlStr = new StringBuffer();
			sqlStr.append("SELECT * FROM IMM_MED_HIST ");
			sqlStr.append(" WHERE STAFF_ID = ? AND DIS_CODE='COVID19' AND EVENT='VACCINATE' AND REMARK = ? AND TO_CHAR(TO_DATE(EVENT_DATE, 'yyyy-mm-dd'), 'dd/mm/yyyy') = ? ");
			
			record = UtilDBWeb.getReportableListCIS(sqlStr.toString(),  
				new String[] { staffId, vacCode3, date3 });
			
			if (record.size() == 0) {
				sqlStr = new StringBuffer();
				sqlStr.append("INSERT INTO IMM_MED_HIST (STAFF_ID, REMARK, EVENT_DATE, create_date, create_by, DIS_CODE, EVENT) ");
				sqlStr.append(" VALUES (?, ?, TO_CHAR(TO_DATE(?, 'dd/mm/yyyy'), 'yyyy-mm-dd'), sysdate, ?, 'COVID19', 'VACCINATE') ");
				rtn = rtn && UtilDBWeb.updateQueueCIS( sqlStr.toString(),
					new String[] { staffId, vacCode3, date3, user });	
				if (!rtn)
					System.out.println(sqlStr.toString());
			} 
		}
		
		//dose4		
		if ( (date4 != null) && !date4.isEmpty() ) {
			sqlStr = new StringBuffer();
			sqlStr.append("SELECT * FROM IMM_MED_HIST ");
			sqlStr.append(" WHERE STAFF_ID = ? AND DIS_CODE='COVID19' AND EVENT='VACCINATE' AND REMARK = ? AND TO_CHAR(TO_DATE(EVENT_DATE, 'yyyy-mm-dd'), 'dd/mm/yyyy') = ? ");
			
			record = UtilDBWeb.getReportableListCIS(sqlStr.toString(),  
				new String[] { staffId, vacCode4, date4 });
			
			if (record.size() == 0) {
				sqlStr = new StringBuffer();
				sqlStr.append("INSERT INTO IMM_MED_HIST (STAFF_ID, REMARK, EVENT_DATE, create_date, create_by, DIS_CODE, EVENT) ");
				sqlStr.append(" VALUES (?, ?, TO_CHAR(TO_DATE(?, 'dd/mm/yyyy'), 'yyyy-mm-dd'), sysdate, ?, 'COVID19', 'VACCINATE') ");
				rtn = rtn && UtilDBWeb.updateQueueCIS( sqlStr.toString(),
					new String[] { staffId, vacCode4, date4, user });	
				if (!rtn)
					System.out.println(sqlStr.toString());
			} 
		}

	}
	
	return rtn;
}
%>
<%
UserBean userBean = new UserBean(request);

String staffId = userBean.getStaffID();
String name = userBean.getUserName();

Locale locale = (Locale) session.getAttribute( Globals.LOCALE_KEY);
if (locale == null)
	locale = Locale.US;

String lang = locale.getDisplayLanguage();

String command = request.getParameter("command");

String infDate = null;
boolean rejectVaccine = false;
String rejectReason = null;
boolean acceptVaccine = false;

String rowid1 = null;
String vacCode1 = null;
String date1 = null;

String rowid2 = null;
String vacCode2 = null;
String date2 = null;

String rowid3 = null;
String vacCode3 = null;
String date3 = null;

String rowid4 = null;
String vacCode4 = null;
String date4 = null;

String reject1 = "Side Effect";
String reject2 = "Doctor recommended not to receive COVID19 vaccination due to contraindication";

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

if ("save".equals(command)) {
	infDate = request.getParameter("infDate");
	
	String vaccination = request.getParameter("vaccination");
	if ("Y".equals(vaccination)) {
		acceptVaccine = true;
	}
	if ("N".equals(vaccination)) {
		rejectVaccine = true;
	}
	rejectReason = request.getParameter("rejectReason");
	if ("Other".equals(rejectReason)) {
		rejectReason = TextUtil.parseStrUTF8(request.getParameter("otherRejectReason"));
	}
	
	System.out.println(rejectReason);
	
	rowid1 = request.getParameter("rowid1");
	vacCode1 = request.getParameter("vacCode1");
	date1 = request.getParameter("date1");

	rowid2 = request.getParameter("rowid2");
	vacCode2 = request.getParameter("vacCode2");
	date2 = request.getParameter("date2");
	
	rowid3 = request.getParameter("rowid3");
	vacCode3 = request.getParameter("vacCode3");
	date3 = request.getParameter("date3");
	
	rowid4 = request.getParameter("rowid4");
	vacCode4 = request.getParameter("vacCode4");
	date4 = request.getParameter("date4");
		
	if (save(staffId, infDate, rejectVaccine, rejectReason, 
			rowid1, vacCode1, date1, 
			rowid2, vacCode2, date2, 
			rowid3, vacCode3, date3, 
			rowid4, vacCode4, date4, 
			staffId)) {
		
		message = "Record saved";
		
	} else {
		
		message = "Failed to save record";
		
	}
} else {
	
	infDate = getInfectedDate(staffId);
	
	ReportableListObject reject = getRejectReason(staffId);
	
	if (reject != null) {
		rejectReason = reject.getValue(0);
		rejectVaccine = true;
	}
	 
//vaccine;	
	ArrayList record = getVaccineHist(staffId);
	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);	
		rowid1 = row.getValue(0);
		vacCode1 = row.getValue(1);
		date1 = row.getValue(2);
		acceptVaccine = true;
	}
	
	if (record.size() > 1)  {
		ReportableListObject row = (ReportableListObject) record.get(1);	
		rowid2 = row.getValue(0);
		vacCode2 = row.getValue(1);
		date2 = row.getValue(2);
	}
	
	if (record.size() > 2)  {
		ReportableListObject row = (ReportableListObject) record.get(2);	
		rowid3 = row.getValue(0);
		vacCode3 = row.getValue(1);
		date3 = row.getValue(2);
	}
	
	if (record.size() > 3)  {
		ReportableListObject row = (ReportableListObject) record.get(3);	
		rowid4 = row.getValue(0);
		vacCode4 = row.getValue(1);
		date4 = row.getValue(2);
	}
}

boolean infected = false;
if ( (infDate != null) && !infDate.isEmpty() ) {
	infected = true;
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
<body lang=EN-US style='text-justify-trim:punctuation'>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="COVID-19 Vaccination" />
	<jsp:param name="pageMap" value="N" />
</jsp:include> 
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>

<form name="form1" id="form1" action="imm_covid.jsp" method="post">
<table cellpadding="0" cellspacing="5" border="0"  width="100%">
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.staffID" /></td>
		<td class="infoData" width="70" colspan=3><%=staffId %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.staffName" /></td>
		<td class="infoData" width="70%" colspan=3><%=name %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">1. <bean:message key="prompt.imm.covid.infected" /></td>
		<td class="infoData" width="30%">
			<input type="radio" id="rbInfected" name="infected" value="Y" <%=infected?"checked":"" %> /><bean:message key="label.yes" />
			<input type="radio" id="rbNotInfected" name="infected" value="N" <%=!infected?"checked":"" %> /><bean:message key="label.no" /></td>
		<td class="infoData" width="20%"><b id="infectLabel"><bean:message key="prompt.imm.covid.date" /></b></td>
		<td class="infoData" width="20%">
			<span id="infectData"><input type="text" name="infDate" id="infDate" class="datepickerfield" value="<%=infDate==null?"":infDate %>" maxlength="10" size="10" onkeyup="validDate(this)" />
			</span></td></tr>			
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%">2. <bean:message key="prompt.imm.covid.vaccination" /></td>
		<td class="infoData" width="70%" colspan=3>
			<input type="radio" id="rbAcceptVaccine" name="vaccination" value="Y" <%=acceptVaccine?"checked":"" %> /><bean:message key="label.yes" />
			<input type="radio" id="rbRejectVaccine" name="vaccination" value="N" <%=rejectVaccine?"checked":"" %> /><bean:message key="label.no" /></td>
	</tr>

	<tr id="reject" class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.imm.covid.reason" /></td>
		<td class="infoData" width="70%" colspan=3>
			<input type="radio" id="rbReject1" name="rejectReason" value="<%=reject1%>" <%=reject1.equals(rejectReason)?"checked":"" %> /><bean:message key="prompt.imm.reject1" /><br />
			<input type="radio" id="rbReject2" name="rejectReason" value="<%=reject2%>" <%=reject2.equals(rejectReason)?"checked":"" %> /><bean:message key="prompt.imm.reject2" /><br />
			<input type="radio" id="rbOtherReject" name="rejectReason" value="Other" <%=(!reject1.equals(rejectReason))&&(!reject2.equals(rejectReason))&&(rejectReason!=null)?"checked":"" %> /><bean:message key="prompt.imm.reject3" />	
			<input type="textfield" name="otherRejectReason" id="otherRejectReason" value="<%=(!reject1.equals(rejectReason))&&(!reject2.equals(rejectReason))&&(rejectReason!=null)?rejectReason:"" %>" maxlength="4000" size="80" />
		</td>
	</tr>

	<tr id="vaccine1" class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="label.imm.dose" arg0="1" /></td>
		<td class="infoData" width="30%">
			<select name="vacCode1" id="vacCode1">
				<option value="" ></option>			
			<%
			ArrayList rec = getVaccineList("COVID19");
			ReportableListObject row = null;
			
			int j = 1;
			
			if ("Chinese".equals(lang))
				j = 2; 
			
			for (int i = 0; i < rec.size(); i++) {	
				row = (ReportableListObject)rec.get(i);
				
			%>		
				<option value="<%=row.getValue(0) %>" <%=row.getValue(0).equals(vacCode1)?"selected":"" %> ><%=row.getValue(j) %></option>
			<%
			}
			%>			
			</select>
		</td>
		<td class="infoData" width="40%" colspan=2>
			<input type="text" name="date1" id="date1" class="datepickerfield" value="<%=date1==null?"":date1 %>" maxlength="10" size="10" onkeyup="validDate(this)" />
		</td>				
	</tr>
	
	<tr id="vaccine2" class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="label.imm.dose" arg0="2" /></td>
		<td class="infoData" width="30%">
			<select name="vacCode2" id="vacCode2">
				<option value="" ></option>			
			<%						
			for (int i = 0; i < rec.size(); i++) {	
				row = (ReportableListObject)rec.get(i);
				
			%>		
				<option value="<%=row.getValue(0) %>" <%=row.getValue(0).equals(vacCode2)?"selected":"" %> ><%=row.getValue(j) %></option>
			<%
			}
			%>			
			</select>
		</td>
		<td class="infoData" width="40%" colspan=2>
			<input type="text" name="date2" id="date2" class="datepickerfield" value="<%=date2==null?"":date2 %>" maxlength="10" size="10" onkeyup="validDate(this)" />
		</td>		
	</tr>
	
	<tr id="vaccine3" class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="label.imm.dose" arg0="3"/></td>
		<td class="infoData" width="30%">
			<select name="vacCode3" id="vacCode3">
				<option value="" ></option>			
			<%
			for (int i = 0; i < rec.size(); i++) {	
				row = (ReportableListObject)rec.get(i);
				
			%>		
				<option value="<%=row.getValue(0) %>" <%=row.getValue(0).equals(vacCode3)?"selected":"" %> ><%=row.getValue(j) %></option>
			<%
			}
			%>			
			</select>
		</td>
		<td class="infoData" width="40%" colspan=2>
			<input type="text" name="date3" id="date3" class="datepickerfield" value="<%=date3==null?"":date3 %>" maxlength="10" size="10" onkeyup="validDate(this)" />
		</td>
	</tr>
	
	<tr id="vaccine4" class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="label.imm.dose" arg0="4"/></td>
		<td class="infoData" width="30%">
			<select name="vacCode4" id="vacCode4">
				<option value="" ></option>			
			<%
			for (int i = 0; i < rec.size(); i++) {	
				row = (ReportableListObject)rec.get(i);
				
			%>		
				<option value="<%=row.getValue(0) %>" <%=row.getValue(0).equals(vacCode4)?"selected":"" %> ><%=row.getValue(j) %></option>
			<%
			}
			%>			
			</select>
		</td>
		<td class="infoData" width="40%" colspan=2>
			<input type="text" name="date4" id="date4" class="datepickerfield" value="<%=date4==null?"":date4 %>" maxlength="10" size="10" onkeyup="validDate(this)" />
		</td>
	</tr>	
	
</table>

<br />
<center><button id="btnSave" type="submit"><bean:message key="button.save" /></button></center>

<input type="hidden" name="command" id="command" value="<%=command==null?"":command %>"/>
<input type="hidden" name="rowid1" id="rowid1" value="<%=rowid1==null?"":rowid1 %>" /> 
<input type="hidden" name="rowid2" id="rowid2" value="<%=rowid2==null?"":rowid2 %>" /> 
<input type="hidden" name="rowid3" id="rowid3" value="<%=rowid3==null?"":rowid3 %>" /> 
<input type="hidden" name="rowid4" id="rowid4" value="<%=rowid4==null?"":rowid4 %>" /> 

</form> 
<script language="javascript">
<!--
//IE compatibility
if (typeof console=="undefined") var console={ log: function(x) {document.getElementById('msg').innerHTML=x} };
 
if(typeof String.prototype.trim !== 'function') {
  String.prototype.trim = function() {
    return this.replace(/^\s+|\s+$/g, ''); 
  }
}

$(document).ready(function(){
	
	$("#infectLabel").hide();
	$("#infectData").hide();
	$("#reject").hide();
	$("#vaccine1").hide();
	$("#vaccine2").hide();
	$("#vaccine3").hide();
	$("#vaccine4").hide();
	
	$("#otherRejectReason").attr({
    	'disabled': 'disabled'
    });		
	
	if ($("#rbInfected").is(":checked")) { 
		$("#infectLabel").show();
		$("#infectData").show();
	}
	
	if ($("#rbAcceptVaccine").is(":checked")) { 
		$("#vaccine1").show();
		$("#vaccine2").show();
		$("#vaccine3").show();
		$("#vaccine4").show();
	}
	
	if ($("#rbRejectVaccine").is(":checked")) { 
		$("#reject").show();
	}
	
	if ($("#rbOtherReject").is(":checked")) { 
		$("#otherRejectReason").removeAttr('disabled');	
	}
	
	$("#rbInfected").click(function(){
		$("#infectLabel").show();
		$("#infectData").show();
	});
	
	$("#rbNotInfected").click(function(){
		$("#infectLabel").hide();
		$("#infectData").hide();
		$("#infDate").val("");
	}); 
	
	$("#rbAcceptVaccine").click(function(){
		$("#vaccine1").show();
		$("#vaccine2").show();
		$("#vaccine3").show();
		$("#vaccine4").show();
		$("#reject").hide();
		$("#rejectReason").val("");
		$("#otherRejectReason").val("");
	}); 
	
	$("#rbRejectVaccine").click(function(){
		$("#vaccine1").hide();
		$("#vaccine2").hide();
		$("#vaccine3").hide();
		$("#vaccine4").hide();
		
		$("#reject").show();
		$("#date1").val("");
		$("#date2").val("");
		$("#date3").val("");
		$("#date4").val("");
		
	});
	
	$("#rbReject1").click(function(){
		$("#otherRejectReason").val("");
		$("#otherRejectReason").attr({
	    	'disabled': 'disabled'
	    });
	});
	
	$("#rbReject2").click(function(){
		$("#otherRejectReason").val("");
		$("#otherRejectReason").attr({
	    	'disabled': 'disabled'
	    });
	});
	
	$("#rbOtherReject").click(function(){
		$("#otherRejectReason").removeAttr('disabled');	
	});
	
	$("#btnSave").click(function() {
		
//use xor to reset any imcomplete data		
		if ($("#vacCode1").val() == "" ^ $("#date1").val() == "" ) {
			$("#date1").val("");
			$("#vacCode1").val("");
		}
		
		if ($("#vacCode2").val() == "" ^ $("#date2").val() == "" ) {
			$("#date2").val("");
			$("#vacCode2").val("");
		}

		if ($("#vacCode3").val() == "" ^ $("#date3").val() == "" ) {
			$("#date3").val("");
			$("#vacCode3").val("");
		}
		
		if ($("#vacCode4").val() == "" ^ $("#date4").val() == "" ) {
			$("#date4").val("");
			$("#vacCode4").val("");
		}		
//////////////////////////////////////			
		
		if ($("#rbInfected").is(":checked") && $("#infDate").val() == "" ) {
			alert('<bean:message key="prompt.imm.covid.missing.inf.date" />');
			return false;
		}
		
		if ($("#rbAcceptVaccine").is(":checked") && $("#date1").val() == "" ) { 
			alert('<bean:message key="prompt.imm.covid.missing.date1" />');
			return false;
		}
		
		if ($("#rbAcceptVaccine").is(":checked") && $("#date1").val() == "" ) { 
			alert('<bean:message key="prompt.imm.covid.missing.date1" />');
			return false;
		}

//Check same day
		if ( $("#rbAcceptVaccine").is(":checked") && ( $("#date1").val() == $("#date2").val()) ) {
			alert('<bean:message key="prompt.imm.covid.sameday" arg0="1" arg1="2" />');
			return false;
		}
		
		if ( $("#rbAcceptVaccine").is(":checked") && ( $("#date1").val() == $("#date3").val()) ) {
			alert('<bean:message key="prompt.imm.covid.sameday" arg0="1" arg1="3" />');
			return false;
		}
		
		if ( $("#rbAcceptVaccine").is(":checked") && ( $("#date1").val() == $("#date4").val()) ) {
			alert('<bean:message key="prompt.imm.covid.sameday" arg0="1" arg1="4" />');
			return false;
		}
		
		if ( $("#rbAcceptVaccine").is(":checked") && ( $("#date2").val() != "" ) && ( $("#date2").val() == $("#date3").val()) ) {
			alert('<bean:message key="prompt.imm.covid.sameday" arg0="2" arg1="3" />');
			return false;
		}
		
		if ( $("#rbAcceptVaccine").is(":checked") && ( $("#date2").val() != "" ) && ( $("#date2").val() == $("#date4").val()) ) {
			alert('<bean:message key="prompt.imm.covid.sameday" arg0="2" arg1="4" />');
			return false;
		}
		
		if ( $("#rbAcceptVaccine").is(":checked") && ( $("#date3").val() != "" ) && ( $("#date3").val() == $("#date4").val()) ) {
			alert('<bean:message key="prompt.imm.covid.sameday" arg0="3" arg1="4" />');
			return false;
		}		
////////////////	
		
		if ( !$("#rbAcceptVaccine").is(":checked") && !$("#rbRejectVaccine").is(":checked") ) {
			alert('<bean:message key="prompt.imm.covid.q2" />');
			return false;
		}
		
		$("#command").val("save");
		return true;
    });	
	
});
-->
</script>
</DIV>
</DIV>
</DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>

</html:html>
