<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.net.URLEncoder.*"%>
<%!
	private ArrayList<ReportableListObject> fetchPatientNo(String deptCode, String staffID) {
		// fetch fund
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_HOSP_NO ");
		sqlStr.append("FROM   CO_STAFFS ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		if (deptCode != null) {
			sqlStr.append("AND    CO_DEPARTMENT_CODE = '");
			sqlStr.append(deptCode);
			sqlStr.append("' ");
		}
		if (staffID != null) {
			sqlStr.append("AND    CO_STAFF_ID = '");
			sqlStr.append(staffID);
			sqlStr.append("' ");
		}
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList<ReportableListObject> fetchPE(String patientNo) {
		// fetch fund
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT a.patno as hosp_no, p.patfname || ' ' || p.patgname as staff_name, ");
		sqlStr.append("       p.patcname as staff_cname, pkgcode as exam_code, ");
		sqlStr.append("      (SELECT pkgname FROM package@IWEB x WHERE x.pkgcode = b.pkgcode) as exam_name, ");
		sqlStr.append("      (SELECT TO_CHAR(max(x.stncdate), 'DD/MM/YYYY') FROM sliptx@IWEB x WHERE stnsts = 'N' AND x.slpno = b.slpno) as exam_date, ");
		sqlStr.append("       round( ( sysdate - p.patbdate )/ 365.25 ) as age, b.stncdate ");
		sqlStr.append("FROM   slip@IWEB a, sliptx@IWEB b, patient@IWEB p ");
		sqlStr.append("WHERE  a.slpno = b.slpno ");
		sqlStr.append("AND    p.patno = a.patno ");
		sqlStr.append("AND    a.slpsts <> 'R' ");
		sqlStr.append("AND    b.stnsts = 'N' ");
		sqlStr.append("AND    b.pkgcode in ('ESC01','ESC02', 'EPC01', 'EPC02', 'EPC03', 'EPC06', 'EPC07', 'EPC08', 'ESC06', ");
		sqlStr.append(" 'ESC10','ESC11', 'ESC12', 'ESC13', 'ESC14', 'EPC09', 'EPC10', 'EPC11', 'EPC12', 'EPC13', 'EPC14', 'EPC15' ) ");
		sqlStr.append("AND   (b.stncdate + 10 * 365) > sysdate ");
		sqlStr.append("AND    a.patno in (");
		sqlStr.append(patientNo);
		sqlStr.append(") ");
//		sqlStr.append("AND    ROWNUM <= 1 ");
		sqlStr.append("GROUP BY a.patno, p.patfname, p.patgname, p.patcname, b.pkgcode, b.slpno, p.patbdate, b.stncdate ");
		sqlStr.append("ORDER By p.patfname, p.patgname, p.patbdate, b.stncdate DESC ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private ArrayList<ReportableListObject> fetchTodoExam(String staffID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select co_phe_code, co_pkgcode, co_pkgname, co_itmcode, co_itmname, co_optional, co_req_status from table ( phe.todo_exam_with_req( '" + staffID + "' ) )");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

%>
<%
StringBuffer patno = new StringBuffer();

UserBean userBean = new UserBean(request);

String deptCode = request.getParameter("deptCode");
String staffID = request.getParameter("staffID");

boolean isAdmin = false;

if (userBean.isLogin() && userBean.isAccessible("function.hr.physical.exam")) {
	isAdmin = true;
} else {
	deptCode = userBean.getDeptCode();
	staffID = userBean.getStaffID();
}

if (staffID != null) {
	ArrayList record = fetchPatientNo(deptCode, staffID);
	if (record.size() > 0) {
		ReportableListObject row = null;
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			if (i > 0) patno.append(",");
			patno.append("'");
			patno.append(row.getValue(0));
			patno.append("'");
		}
	}
}

if (patno.toString() != null && !("".equals(patno.toString())) ) {
	request.setAttribute("record_list", fetchPE(patno.toString()));
}

//request.setAttribute("todo_exam_list", fetchTodoExam(staffID));
%>
<!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="X-UA-Compatible" content="chrome=1, IE=edge">
<meta http-equiv="Pragma" content="no-cache"> 
<meta http-equiv="Cache-Control" content="no-cache"> 
<meta http-equiv="Expires" content="0">



</head>
<body>
	<br/><p/><br/>
	<table cellpadding="0" cellspacing="5"
		class="contentFrameMenu" border="0" width="100%">
		<tr class="bigText">
			<td class="infoLabel" width="35%"><bean:message key="prompt.title" /></td>
			<td class="infoData" width="65%">Employee Physical Examination</td>
		</tr>
	</table>
	<%	if (isAdmin) { %>
	<form name="form1" id="form1" action="" method="post" >
	<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
	
		<tr class="smallText">
			<td class="infoLabel" width="30%"><bean:message key="prompt.staffID" /></td>
			<td class="infoData" width="70%"><input type="textfield" id="staffID" name="staffID" value="<%=staffID==null?"":staffID %>" maxlength="10" size="50"></td>
		</tr>
		<tr class="smallText">
			<td colspan="2" align="center">
				<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
				<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
				
			<%if (userBean.isAdmin() || userBean.isAccessible("function.hr.physical.exam")) { %>
	 			<button onclick="return reqForm();">Emp Request Status</button>
	 			<button onclick="return pheOutstanding();">Outstanding PHE Requests</button>
			<%} %>
			</td>
		</tr>
	</table>
	</form>
	<%	} %>
	<display:table id="row1" name="requestScope.record_list" export="true" pagesize="1" class="tablesorter">
		<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row1_rowNum")%>)</display:column>
		<display:column title="Staff Name">
			<c:out value="${row1.fields1}" /> <c:out value="${row1.fields2}" />
		</display:column>
		<display:column property="fields3" title="Exam Code" />
		<display:column property="fields4" title="Exam Name" />
		<display:column property="fields5" title="Exam Date" />
	</display:table>
	<br/>*** only display latest records
	
	<%if (isAdmin) { %>
	<table cellpadding="0" cellspacing="5"
		class="contentFrameSearch" border="0">
		<tr class="smallText">
			<td colspan="2" align="center">
				<button onclick="return pheReqForm();">Health Exam Request</button>
			</td>
		</tr>
	</table>
	<%} %>
	
	<center>
	<table cellpadding="0" cellspacing="5"
		class="contentFrameMenu" border="1" width="80%">
		<tr class="warning">
			<td><b>AGE</b></td>
			<td><b>FREQUENCY</b></td>
			<td><b>TEST</b></td>
			<td><b>OPTIONAL TEST*</b></td>
		</tr>
		<tr>
			<td>Below 35</td>
			<td>every 3 years after<BR/>the last health exam</td>
			<td>CBC<BR/>Urinalysis<BR/>Stool, routine<BR/>Chest X-ray</td>
			<td>LMC lifestyle consultation</td>
		</tr>
		<tr>
			<td>35 - 50</td>
			<td>every 2 years after<BR/>the last health exam</td>
			<td>All of the above plus<BR/>Fasting blood sugar<BR/>Lipid profile</td>
			<td>Mammogram**<BR/>Pap smear<BR/>LMC lifestyle consultation</td>
		</tr>
		<tr>
			<td>51 or above</td>
			<td>annually</td>
			<td>All of the above plus<BR/>Liver function test<BR/>Renal function test</td>
			<td>Mammogram<BR/>Pap smear<BR/>LMC lifestyle consultation</td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td>every 2 years after<BR/>the last health exam</td>
			<td>&nbsp;</td>
			<td>EKG<BR/>PSA for males</td>
		</tr>
	</table>
	<table cellpadding="0" cellspacing="5"
		class="contentFrameMenu" border="0" width="80%">
		<tr><td valign="top">*</td><td><b>Optional tests</b> must be approved by Employee Health Department. Employees cannot request optional tests after they have already seen the doctor for their periodic health examinations.</td></tr>
		<tr><td valign="top">**</td><td>Eligible employees between 35-39 years old may request to have a Mammogram only if they have a family history of premenopausal diagnosed breast cancer in a first degree relative.</td></tr>
	</table>
	</center>
	<br/><p/><br/>
	<script src="http://code.jquery.com/jquery-3.2.1.min.js"></script>
	<script language="javascript">
		function submitSearch() {
			document.form1.submit();
		}
	
		function clearSearch() {
			document.form1.staffID.value = "";
			return false;
		}
		
		function pheReqForm() {
			var staffID = $('#staffID').val();
			document.form1.action = "../education/phe_req_form.jsp?staffID=" + staffID ;
			document.form1.submit();
		}
	
		function pheOutstanding() {
			document.form1.action = "../education/phe_outstanding.jsp" ;
			document.form1.submit();
		}
	
		function reqForm()  {
			document.form1.action = "../education/phe_req_form.jsp?staffID=" + document.form1.staffID.value ;
			document.form1.submit();
		}
		
	</script>
</body>
</html>