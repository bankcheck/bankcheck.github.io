<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%!
public static ArrayList getRecordList(String staffId, String dept) {
	
	StringBuffer sqlStr = new StringBuffer();
/*
	sqlStr.append("SELECT co_staff_id, co_staffname, co_department_desc, INFECTED_DATE, Sinovac_DOSE1, Sinovac_DOSE2, BioNTech_DOSE1, BioNTech_DOSE2, REJECTION_STATUS ");
	sqlStr.append("	FROM co_staffs S ");
	sqlStr.append(" LEFT OUTER JOIN	(SELECT staff_ID, ");
	sqlStr.append(" 	max( DECODE( EVENT, 'INFECTED', EVENT_DATE) ) INFECTED_DATE, ");
	sqlStr.append("		max( DECODE( EVENT, 'NOT VACCINATE', 'NOT VACCINATE ' || REMARK) ) REJECTION_STATUS, ");
	sqlStr.append("		max( DECODE( EVENT, 'VACCINATE', DECODE(REMARK, 'CoronaVac', DECODE(IMM_DOSE_COUNT@cis ( STAFF_ID, REMARK, EVENT_DATE, null ), 'Dose 1', EVENT_DATE))) ) Sinovac_DOSE1, ");
	sqlStr.append("		max( DECODE( EVENT, 'VACCINATE', DECODE(REMARK, 'CoronaVac', DECODE(IMM_DOSE_COUNT@cis ( STAFF_ID, REMARK, EVENT_DATE, null ), 'Dose 2', EVENT_DATE))) ) Sinovac_DOSE2, ");
	sqlStr.append("		max( DECODE( EVENT, 'VACCINATE', DECODE(REMARK, 'BNT162', DECODE(IMM_DOSE_COUNT@cis ( STAFF_ID, REMARK, EVENT_DATE, null ), 'Dose 1', EVENT_DATE))) ) BioNTech_DOSE1, ");
	sqlStr.append("		max( DECODE( EVENT, 'VACCINATE', DECODE(REMARK, 'BNT162', DECODE(IMM_DOSE_COUNT@cis ( STAFF_ID, REMARK, EVENT_DATE, null ), 'Dose 2', EVENT_DATE))) ) BioNTech_DOSE2 ");
	sqlStr.append("		FROM IMM_MED_HIST@cis ");
	sqlStr.append("		WHERE DIS_CODE = 'COVID19' ");
	sqlStr.append("		GROUP BY staff_ID) med ");
	sqlStr.append(" 	ON s.co_staff_id = med.staff_id ");
	sqlStr.append(" WHERE co_enabled = 1 ");
	sqlStr.append(" AND co_staff_id like 'SRC%' ");
	sqlStr.append(" AND co_staff_id <> 'SRC00000' ");
*/
	sqlStr.append("SELECT co_staff_id, co_staffname, co_department_desc, INFECTED_DATE, DOSE1_DATE, v1.vac_name, DOSE2_DATE, v2.vac_name, DOSE3_DATE, v3.vac_name, DOSE4_DATE, v4.vac_name, REJECTION_STATUS ");
	sqlStr.append("	FROM co_staffs S ");
	sqlStr.append(" LEFT OUTER JOIN	(SELECT staff_ID, ");
	sqlStr.append(" 	max( DECODE( EVENT, 'INFECTED', EVENT_DATE) ) INFECTED_DATE, ");
	sqlStr.append("		max( DECODE( EVENT, 'NOT VACCINATE', 'NOT VACCINATE ' || REMARK) ) REJECTION_STATUS, ");
	sqlStr.append("		max( DECODE( EVENT, 'VACCINATE', DECODE(DOSE, 1, EVENT_DATE)) ) DOSE1_DATE, ");
	sqlStr.append("		max( DECODE( EVENT, 'VACCINATE', DECODE(DOSE, 1, REMARK)) ) DOSE1_VAC, ");
	sqlStr.append("		max( DECODE( EVENT, 'VACCINATE', DECODE(DOSE, 2, EVENT_DATE)) ) DOSE2_DATE, ");
	sqlStr.append("		max( DECODE( EVENT, 'VACCINATE', DECODE(DOSE, 2, REMARK)) ) DOSE2_VAC, ");
	sqlStr.append("		max( DECODE( EVENT, 'VACCINATE', DECODE(DOSE, 3, EVENT_DATE)) ) DOSE3_DATE, ");
	sqlStr.append("		max( DECODE( EVENT, 'VACCINATE', DECODE(DOSE, 3, REMARK)) ) DOSE3_VAC, ");
	sqlStr.append("		max( DECODE( EVENT, 'VACCINATE', DECODE(DOSE, 4, EVENT_DATE)) ) DOSE4_DATE, ");
	sqlStr.append("		max( DECODE( EVENT, 'VACCINATE', DECODE(DOSE, 4, REMARK)) ) DOSE4_VAC ");
	sqlStr.append("		FROM (SELECT staff_id, dis_code, event, event_date, remark, ROW_NUMBER() OVER (PARTITION BY staff_id, EVENT ORDER BY event_date) dose ");
	sqlStr.append("			FROM IMM_MED_HIST@cis WHERE DIS_CODE = 'COVID19') ");
	sqlStr.append("		GROUP BY staff_ID) med ");
	sqlStr.append(" 	ON s.co_staff_id = med.staff_id ");
	sqlStr.append(" LEFT OUTER JOIN IMM_VACCINE@cis v1 ON v1.vac_code = med.DOSE1_VAC ");
	sqlStr.append(" LEFT OUTER JOIN IMM_VACCINE@cis v2 ON v2.vac_code = med.DOSE2_VAC ");
	sqlStr.append(" LEFT OUTER JOIN IMM_VACCINE@cis v3 ON v3.vac_code = med.DOSE3_VAC ");
	sqlStr.append(" LEFT OUTER JOIN IMM_VACCINE@cis v4 ON v4.vac_code = med.DOSE4_VAC ");	
	sqlStr.append(" WHERE co_enabled = 1 ");
	sqlStr.append(" AND co_mark_deleted = 'N' ");
	sqlStr.append(" AND Co_Termination_Date is null ");
	sqlStr.append(" AND co_staff_id like 'SRC%' ");
	sqlStr.append(" AND co_staff_id <> 'SRC00000' ");

	if ( (dept != null) && !dept.trim().isEmpty() ) {
		sqlStr.append(" AND co_department_code = " + dept );
	} else {
		sqlStr.append(" AND co_department_code not in (420, 421) ");
	}
	
	if ( (staffId != null) && !staffId.trim().isEmpty() ) {
		sqlStr.append(" AND co_staff_id = UPPER('" + staffId + "') ");
	}
		
	sqlStr.append(" ORDER BY co_department_desc, co_staff_id ");
	
	System.out.println(sqlStr.toString());
	
	return  UtilDBWeb.getReportableList(sqlStr.toString());  
}

public static ArrayList getDeptHeadRecordList(String deptHeadId) {
	
	StringBuffer sqlStr = new StringBuffer();
/*	
	sqlStr.append("SELECT co_staff_id, co_staffname, co_department_desc, INFECTED_DATE, Sinovac_DOSE1, Sinovac_DOSE2, BioNTech_DOSE1, BioNTech_DOSE2, REJECTION_STATUS ");
	sqlStr.append("	FROM co_staffs S ");
	sqlStr.append(" LEFT OUTER JOIN	(SELECT staff_ID, ");
	sqlStr.append(" 	max( DECODE( EVENT, 'INFECTED', EVENT_DATE) ) INFECTED_DATE, ");
	sqlStr.append("		max( DECODE( EVENT, 'NOT VACCINATE', 'NOT VACCINATE ' || REMARK) ) REJECTION_STATUS, ");
	sqlStr.append("		max( DECODE( EVENT, 'VACCINATE', DECODE(REMARK, 'CoronaVac', DECODE(IMM_DOSE_COUNT@cis ( STAFF_ID, REMARK, EVENT_DATE, null ), 'Dose 1', EVENT_DATE))) ) Sinovac_DOSE1, ");
	sqlStr.append("		max( DECODE( EVENT, 'VACCINATE', DECODE(REMARK, 'CoronaVac', DECODE(IMM_DOSE_COUNT@cis ( STAFF_ID, REMARK, EVENT_DATE, null ), 'Dose 2', EVENT_DATE))) ) Sinovac_DOSE2, ");
	sqlStr.append("		max( DECODE( EVENT, 'VACCINATE', DECODE(REMARK, 'BNT162', DECODE(IMM_DOSE_COUNT@cis ( STAFF_ID, REMARK, EVENT_DATE, null ), 'Dose 1', EVENT_DATE))) ) BioNTech_DOSE1, ");
	sqlStr.append("		max( DECODE( EVENT, 'VACCINATE', DECODE(REMARK, 'BNT162', DECODE(IMM_DOSE_COUNT@cis ( STAFF_ID, REMARK, EVENT_DATE, null ), 'Dose 2', EVENT_DATE))) ) BioNTech_DOSE2 ");
	sqlStr.append("		FROM IMM_MED_HIST@cis ");
	sqlStr.append("		WHERE DIS_CODE = 'COVID19' ");
	sqlStr.append("		GROUP BY staff_ID) med ");
	sqlStr.append(" 	ON s.co_staff_id = med.staff_id ");
	sqlStr.append(" WHERE co_enabled = 1 ");
	sqlStr.append(" AND co_staff_id like 'SRC%' ");
	sqlStr.append(" AND co_staff_id <> 'SRC00000' ");
	sqlStr.append(" AND co_department_code in ( ");
	sqlStr.append("		SELECT CO_DEPARTMENT_CODE FROM CO_DEPARTMENTS WHERE CO_DEPARTMENT_HEAD = ? )" );	
	sqlStr.append(" ORDER BY co_department_desc, co_staff_id ");
*/
	sqlStr.append("SELECT co_staff_id, co_staffname, co_department_desc, INFECTED_DATE, DOSE1_DATE, v1.vac_name, DOSE2_DATE, v2.vac_name, DOSE3_DATE, v3.vac_name, DOSE4_DATE, v4.vac_name, REJECTION_STATUS ");
	sqlStr.append("	FROM co_staffs S ");
	sqlStr.append(" LEFT OUTER JOIN	(SELECT staff_ID, ");
	sqlStr.append(" 	max( DECODE( EVENT, 'INFECTED', EVENT_DATE) ) INFECTED_DATE, ");
	sqlStr.append("		max( DECODE( EVENT, 'NOT VACCINATE', 'NOT VACCINATE ' || REMARK) ) REJECTION_STATUS, ");
	sqlStr.append("		max( DECODE( EVENT, 'VACCINATE', DECODE(DOSE, 1, EVENT_DATE)) ) DOSE1_DATE, ");
	sqlStr.append("		max( DECODE( EVENT, 'VACCINATE', DECODE(DOSE, 1, REMARK)) ) DOSE1_VAC, ");
	sqlStr.append("		max( DECODE( EVENT, 'VACCINATE', DECODE(DOSE, 2, EVENT_DATE)) ) DOSE2_DATE, ");
	sqlStr.append("		max( DECODE( EVENT, 'VACCINATE', DECODE(DOSE, 2, REMARK)) ) DOSE2_VAC, ");
	sqlStr.append("		max( DECODE( EVENT, 'VACCINATE', DECODE(DOSE, 3, EVENT_DATE)) ) DOSE3_DATE, ");
	sqlStr.append("		max( DECODE( EVENT, 'VACCINATE', DECODE(DOSE, 3, REMARK)) ) DOSE3_VAC, ");
	sqlStr.append("		max( DECODE( EVENT, 'VACCINATE', DECODE(DOSE, 4, EVENT_DATE)) ) DOSE4_DATE, ");
	sqlStr.append("		max( DECODE( EVENT, 'VACCINATE', DECODE(DOSE, 4, REMARK)) ) DOSE4_VAC ");
	sqlStr.append("		FROM (SELECT staff_id, dis_code, event, event_date, remark, ROW_NUMBER() OVER (PARTITION BY staff_id, EVENT ORDER BY event_date) dose ");
	sqlStr.append("			FROM IMM_MED_HIST@cis WHERE DIS_CODE = 'COVID19') ");
	sqlStr.append("		GROUP BY staff_ID) med ");
	sqlStr.append(" 	ON s.co_staff_id = med.staff_id ");
	sqlStr.append(" LEFT OUTER JOIN IMM_VACCINE@cis v1 ON v1.vac_code = med.DOSE1_VAC ");
	sqlStr.append(" LEFT OUTER JOIN IMM_VACCINE@cis v2 ON v2.vac_code = med.DOSE2_VAC ");
	sqlStr.append(" LEFT OUTER JOIN IMM_VACCINE@cis v3 ON v3.vac_code = med.DOSE3_VAC ");	
	sqlStr.append(" LEFT OUTER JOIN IMM_VACCINE@cis v4 ON v4.vac_code = med.DOSE4_VAC ");	
	sqlStr.append(" WHERE co_enabled = 1 ");
	sqlStr.append(" AND co_mark_deleted = 'N' ");
	sqlStr.append(" AND Co_Termination_Date is null ");
	sqlStr.append(" AND co_staff_id like 'SRC%' ");
	sqlStr.append(" AND co_staff_id <> 'SRC00000' ");
	sqlStr.append(" AND co_department_code in ( ");
	sqlStr.append("		SELECT CO_DEPARTMENT_CODE FROM CO_DEPARTMENTS WHERE CO_DEPARTMENT_HEAD = ? )" );	
	sqlStr.append(" ORDER BY co_department_desc, co_staff_id ");

	return  UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { deptHeadId } );  
}

public static boolean isDepartmentHead(UserBean userBean) {
	
	String staffId = userBean.getLoginID();
	
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT * ");
	sqlStr.append("	FROM co_departments ");
	sqlStr.append(" WHERE CO_DEPARTMENT_HEAD = ? ");
	
	ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(),  
			new String[] { staffId });
	
	if (record.size() > 0) {
		return true;
	}
	
	return false;
}
%>
<%
UserBean userBean = new UserBean(request);

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

String staffId = request.getParameter("staffId");;
String dept = request.getParameter("dept");

if (userBean.isAccessible("function.imm.covid.report")) {
	request.setAttribute("record", getRecordList(staffId, dept));
	
} else if ( isDepartmentHead(userBean) ) {	
	request.setAttribute("record", getDeptHeadRecordList(userBean.getLoginID()));
	
} else {	
	request.setAttribute("record", getRecordList(userBean.getLoginID(), null));
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
	<jsp:param name="pageTitle" value="COVID-19 Immunization Record" />
</jsp:include> 
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="form1" id="form1" action="imm_covid_record.jsp" method="post">

<%if (userBean.isAccessible("function.imm.covid.report")) { %>
<table cellpadding="0" cellspacing="5" border="0"  width="100%">
	<tr class="smallText">
		<td class="infoLabel" width="40%"><bean:message key="prompt.staffID" /></td>
		<td class="infoData" width="60%">
			<input type="textfield" name="staffId" id="staffId" value="<%=staffId==null?"":staffId %>" maxlength="10" size="10" />
		</td>
	</tr>	
		<tr class="smallText">
		<td class="infoLabel" width="40%"><bean:message key="prompt.department" /></td>		
		<td class="infoData" width="60%">
			<select name="dept">
				<option value=""><bean:message key="label.selectAllDepartment" /></option>				
				<jsp:include page="../ui/deptCodeCMB.jsp" flush="false">
					<jsp:param name="deptCode" value="<%=dept %>" />
					<jsp:param name="allowAll" value="Y" />
					<jsp:param name="ignoreDeptCode" value="420,421" />
				</jsp:include>
			</select>
		</td>
	</tr>
		<tr class="smallText">
		<td class="infoData" width="40%" />
		<td class="infoData" width="60%">
			<button id="btnSearch"><bean:message key="button.search" /></button>
		</td>
	</tr>
</table>
<%} %>

<display:table id="tab" name="requestScope.record" class="tablesorter" export="true">
	<display:column property="fields0" titleKey="prompt.staffID" style="width:5%" />
	<display:column property="fields1" titleKey="prompt.name" style="width:10%" />
	<display:column property="fields2" title="Department" style="width:10%" />
	<display:column property="fields3" title="Infected Date" style="width:5%" />	
	<display:column property="fields4" title="Dose1 Date" style="width:5%" />
	<display:column property="fields5" title="Dose1 Vaccine" style="width:10%" />
	<display:column property="fields6" title="Dose2 Date" style="width:5%" />
	<display:column property="fields7" title="Dose2 Vaccine" style="width:10%" />
	<display:column property="fields8" title="Dose3 Date" style="width:5%" />
	<display:column property="fields9" title="Dose3 Vaccine" style="width:10%" />	
	<display:column property="fields10" title="Dose4 Date" style="width:5%" />
	<display:column property="fields11" title="Dose4 Vaccine" style="width:10%" />		
	<display:column property="fields12" title="Not Vaccinate Reason" style="width:10%" />		 	
</display:table>

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
-->
</script>
</DIV>
</DIV>
</DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>

</html:html>
