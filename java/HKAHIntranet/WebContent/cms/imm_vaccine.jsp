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
private static String getPatno( UserBean userBean ) {
	
	String staffId = userBean.getStaffID();
	
	String patno = null;
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT CO_HOSP_NO FROM CO_STAFFS ");
	sqlStr.append(" WHERE CO_STAFF_ID = ? ");
	sqlStr.append(" AND CO_HOSP_NO IS NOT NULL ");

	ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(),  
		new String[] { staffId });

	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		patno = row.getValue(0);
	}
	return patno;
}

public static ArrayList getVaccineHist(String patno, String code, String date) {
	
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append(" SELECT ROWID, LOT_NUM FROM IMM_VAC_HIST ");
	sqlStr.append(" WHERE PATNO = ? ");	
	sqlStr.append(" AND VAC_CODE = ? ");
	sqlStr.append(" AND VAC_DATE = TO_CHAR(TO_DATE(VAC_DATE, 'yyyy-mm-dd'), 'dd/mm/yyyy') ");


	return  UtilDBWeb.getReportableListCIS(sqlStr.toString(),  
		new String[] { patno, code, date });
}

public static ArrayList getVaccineList() {
	
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append(" SELECT v.VAC_CODE, v.vac_name, v.vac_cname "); 
	sqlStr.append(" FROM IMM_VACCINE v ");
	sqlStr.append(" ORDER BY vac_name ");

	return  UtilDBWeb.getReportableListCIS(sqlStr.toString());
}

public static boolean save(String patno, String vacCode, String rowid, String date, String lotNo, String user) {
	
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT * FROM IMM_VAC_HIST WHERE ROWID = ?");
	ArrayList record = UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[] { rowid });
	
	if (record.size() > 0) {
		
		sqlStr = new StringBuffer();
		sqlStr.append("UPDATE IMM_VAC_HIST SET VAC_CODE = ?, ");
		sqlStr.append("	VAC_DATE = TO_CHAR(TO_DATE(?, 'dd/mm/yyyy'), 'yyyy-mm-dd'), ");
		sqlStr.append("	LOT_NUM = ?, ");
		sqlStr.append(" create_date = sysdate, ");
		sqlStr.append(" create_by = ? ");
		sqlStr.append(" WHERE ROWID = ? ");

		return UtilDBWeb.updateQueueCIS( sqlStr.toString(),
			new String[] { vacCode, date, lotNo, user, rowid });			
	
	} else {
		
		sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO IMM_VAC_HIST (PATNO, VAC_CODE, VAC_DATE, LOT_NUM, create_date, create_by) ");
		sqlStr.append(" VALUES (?, ?, TO_CHAR(TO_DATE(?, 'dd/mm/yyyy'), 'yyyy-mm-dd'), ?, sysdate, ?) ");
		
		return UtilDBWeb.updateQueueCIS( sqlStr.toString(),
			new String[] { patno, vacCode, date, lotNo, user });
	}
}
%>
<%
UserBean userBean = new UserBean(request);

String patno =  getPatno( userBean );
String staffId = userBean.getStaffID();
String name = userBean.getUserName();

Locale locale = (Locale) session.getAttribute( Globals.LOCALE_KEY);
String lang = locale.getDisplayLanguage();

String command = request.getParameter("command");

String vacCode = request.getParameter("vacCode");
String date = request.getParameter("date");  

String rowid = null;
String lotNo = null;

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

if ("save".equals(command)) {

	rowid = request.getParameter("rowid");
	lotNo = request.getParameter("lotNo");
	
	if (save(patno, vacCode, rowid, date, lotNo, staffId)) {
		message = "Record saved";
	} else {
		message = "Failed to save record";
	}
	command = "close";
} else {
	ArrayList record = getVaccineHist(patno, vacCode, date);
	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);	
		rowid = row.getValue(0);
		lotNo = row.getValue(1);
	}
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
	<jsp:param name="pageTitle" value="Declare Vaccination" />
	<jsp:param name="pageMap" value="N" />
</jsp:include> 
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>

<form name="form1" id="form1" action="imm_vaccine.jsp" method="post">
<table cellpadding="0" cellspacing="5" border="0"  width="100%">
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.staffID" /></td>
		<td class="infoData" width="80%"><%=staffId %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.staffName" /></td>
		<td class="infoData" width="80%"><%=name %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.patNo" /></td>
		<td class="infoData" width="80%"><%=patno %></td>
	</tr>
	<tr><td class="infoLabel" width="20%"><bean:message key="prompt.date" /></td><td class="infoData" width="80%">
		<input type="text" name="date" id="date" class="datepickerfield" value="<%=date==null?"":date %>" maxlength="10" size="10" onkeyup="validDate(this)" /></td>
	</tr>	
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.imm.vaccine" /></td>
		<td class="infoData" width="80%">
			<select name="vacCode" id="vacCode">
			<%
			ArrayList rec = getVaccineList();
			ReportableListObject row = null;
			
			int j = 1;
			
			if ("Chinese".equals(lang))
				j = 2; 
			
			for (int i = 0; i < rec.size(); i++) {	
				row = (ReportableListObject)rec.get(i);
				
			%>		
				<option value="<%=row.getValue(0) %>" <%=row.getValue(0).equals(vacCode)?"selected":"" %> ><%=row.getValue(j) %></option>
			<%
			}
			%>			
			</select>
		</td>
	</tr>
	
	<tr><td class="infoLabel" width="20%"><bean:message key="prompt.imm.lotNo" />
		<br />(<bean:message key="prompt.optional" />)</td><td class="infoData" width="80%">
		<input type="textfield" name="lotNo" id="lotNo" value="<%=lotNo==null?"":lotNo %>" maxlength="15" size="15" /></td></tr>
</table>

<br />
<center><button id="btnSave"><bean:message key="button.save" /></button></center>
<br/>

<input type="hidden" name="command" id="command" value="<%=command==null?"":command %>"/>
<input type="hidden" name="rowid" id="rowid" value="<%=rowid==null?"":rowid %>" /> 
<input type="hidden" name="patno" id="patno" value="<%=patno==null?"":patno %>" />
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
	
	if ( $( "#patno" ).val() == "" ) {
		alert("Hospital Number not found");
		
		$("#form1").attr({
	    	'disabled': 'disabled'
	    });
	}
	
	if ( $( "#command" ).val() == "close" ) {
		opener.location.reload();
		window.close();
		return false;
	}
	
	$("#btnSave").click(function() {		
		if ( $( "#patno" ).val() == "" ) {
			alert("Hospital Number not found");
			return false;
		} else if ( $( "#date" ).val() == "" ) {
			alert("Date is empty");
			return false;			
		} else {
			$("#command").val("save");
			return true;
		}
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
