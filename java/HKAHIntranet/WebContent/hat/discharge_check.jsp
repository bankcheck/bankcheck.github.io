<%@ page import="java.util.*" %>
<%@ page import="com.hkah.util.*" %>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%
UserBean userBean = new UserBean(request);

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

String command = ParserUtil.getParameter(request, "command");
String patno = ParserUtil.getParameter(request, "patno");
String patfname = null;
String patgname = null;

String checkid = ParserUtil.getParameter(request, "checkid");
String remark = ParserUtil.getParameter(request, "remark");

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
}

ArrayList record = null;
boolean foundPatNo = false;
if (patno != null && patno.length() > 0) {
	record = AdmissionDB.getHATSPatient(patno, null, null);
	if (record != null && record.size() > 0) {
		foundPatNo = true;

		ReportableListObject row = (ReportableListObject) record.get(0);
		patfname = row.getValue(1);
		patgname = row.getValue(2);

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT PH_CHECKOUT_ID, TO_CHAR(PH_OUT_DATE, 'DD/MM/YYYY HH24:MI:SS'), PH_BEDCODE, PH_OUT_STATUS, PH_REMARK ");
		sqlStr.append("FROM   PH_CHECKOUT ");
		sqlStr.append("WHERE  PH_PATNO = ? ");
		sqlStr.append("AND    PH_PICKUP_STATUS IS NULL ");
		sqlStr.append("ORDER BY PH_CREATE_DATE");
		record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { patno });
		request.setAttribute("dischargecheck_pharmacy_list", record);

		sqlStr.setLength(0);
		sqlStr.append("SELECT TO_CHAR(ORDERDATE, 'DD/MM/YYYY HH24:MI:SS'), ACCESSNO, BILLCODE1, BILLCODE2, PATTYPE, ERROR_MESSAGE ");
		sqlStr.append("FROM   RIS_AUTO_MATCH_LOG ");
		sqlStr.append("WHERE  STATUS = 'FAILED' ");
//		sqlStr.append("AND    ORDERDATE >= SYSDATE - 1 ");
		sqlStr.append("AND    PATNO = ? ");
		sqlStr.append("ORDER BY ORDERDATE");
		record = UtilDBWeb.getReportableListHATS(sqlStr.toString(), new String[] { patno });
		request.setAttribute("dischargecheck_di_list", record);
	} else {
		errorMessage = "Invalid Patient No.";
		patno = null;
	}
}
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
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.dischargecheck.list" />
	<jsp:param name="displayTitle" value="Discharge Check List" />
	<jsp:param name="category" value="Report" />
	<jsp:param name="mustLogin" value="N" />
</jsp:include>

<font color="blue"><%=message==null?"":message %></font>
<font color="red"><%=errorMessage==null?"":errorMessage %></font>
<form name="form1" id="form1" action="pharmacy2pbo.jsp" method="post">
<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0" width="300">
	<tr class="smallText">
		<td class="infoLabel" width="20%">Hospital No. :</td>
		<td class="infoData" width="80%" colspan="3">
<%	if (patno != null && patno.length() > 0) { %>
			<input type="hidden" name="patno" value="<%=patno %>"><%=patno %>
<%	} else { %>
			<input type="text" name="patno" value="<%=patno==null?"":patno %>" id="patno" maxlength="10" size="20" onblur="checkPatNo(this);">
			&nbsp;
			<button onclick="return submitAction('search');" style="text-decoration:none;font-size:20px;width:100px;height:50px;" class="btn-click">Search</button>
			&nbsp;
			&nbsp;
			<button onclick="return submitAction('report');" style="text-decoration:none;font-size:20px;width:100px;height:50px;" class="btn-click">Report</button>
			<button onclick="return submitAction('history');" style="text-decoration:none;font-size:20px;width:100px;height:50px;" class="btn-click">History</button>
<%	} %>
		</td>
	</tr>
<%	if (foundPatNo) { %>
	<tr class="smallText">
		<td class="infoLabel" width="20%">Surname :</td>
		<td class="infoData" width="30%"><%=patfname!=null?patfname:"" %></td>
		<td class="infoLabel" width="20%">Firstname :</td>
		<td class="infoData" width="30%"><%=patgname!=null?patgname:"" %></td>
	</tr>
<%	} %>
</table>
<%	if (foundPatNo) { %>
<table border="0" width="100%">
	<tr>
		<td class="infoCenterLabel">Pharmacy Checkout Outstanding</td>
	</tr>
	<tr>
		<td>
<bean:define id="functionLabel1">Pharmacy Checkout Outstanding</bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel1 %>" /></bean:define>
<display:table id="row1" name="requestScope.dischargecheck_pharmacy_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row1_rowNum")%>)</display:column>
	<display:column property="fields1" title="Time in" style="width:15%" />
	<display:column property="fields2" title="Room" style="width:15%" />
	<display:column title="Status" style="width:10%">
		<logic:equal name="row1" property="fields3" value="NOMED">
			<font color="blue">NO MED</font>
		</logic:equal>
		<logic:equal name="row1" property="fields3" value="BEDSIDE">
			<font color="blue">BEDSIDE</font>
		</logic:equal>
		<logic:equal name="row1" property="fields3" value="PICKUP">
			<font color="red">PICK UP AT RX</font>
		</logic:equal>
		<logic:equal name="row1" property="fields3" value="MEDGIVEN">
			<font color="green">MED GIVEN</font>
		</logic:equal>
	</display:column>
	<display:column property="fields4" title="Remarks" style="width:20%" />
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
<%			if (!updateAction) { %>
		<button onclick="return submitAction('update', '<c:out value="${row.fields0}" />';"><bean:message key="button.confirm" /></button>
<%			} %>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
		</td>
	</tr>
</table>
<br/><p/><br/>
<table border="0" width="100%">
	<tr>
		<td class="infoCenterLabel">DI (RIS) Outstanding</td>
	</tr>
	<tr>
		<td>
<bean:define id="functionLabel3">DI (RIS) Outstanding</bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel3 %>" /></bean:define>
<display:table id="row3" name="requestScope.dischargecheck_di_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row3_rowNum")%>)</display:column>
	<display:column property="fields0" title="Order Date" style="width:15%" />
	<display:column property="fields1" title="Accession No" style="width:15%" />
	<display:column property="fields2" title="Bill Code 1" style="width:10%" />
	<display:column property="fields3" title="Bill Code 2" style="width:10%" />
	<display:column title="Slip Type" style="width:10%">
		<logic:equal name="row3" property="fields4" value="I">
			<font color="blue">Inpatient</font>
		</logic:equal>
		<logic:equal name="row3" property="fields4" value="O">
			<font color="green">Outpatient</font>
		</logic:equal>
		<logic:equal name="row3" property="fields4" value="D">
			<font color="orange">Daycase</font>
		</logic:equal>
	</display:column>
	<display:column property="fields5" title="Status" style="width:20%" />
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
		</td>
	</tr>
</table>
<%	} %>
<input type="hidden" name="command">
<input type="hidden" name="checkid">
</form>

<script language="javascript">
<!--//
	$(document).ready(function() {
<%	if (patno != null && patno.length() > 0) { %>
		document.form1.remark.focus();
<%	} else { %>
		document.form1.patno.focus();
<%	} %>
	});

	function submitAction(cmd, checkid) {
		if (cmd == 'search' && document.form1.patno.value == '') {
			alert("Empty Patient No.");
			document.form1.patno.focus();
			return false;
		} else if (cmd == 'clear') {
			clearSearch();
		} else if (cmd == 'report' || cmd == 'history') {
			alert("Under Construction!");
			return false;
		}
		document.form1.command.value = cmd;
		document.form1.checkid.value = checkid;
		document.form1.submit();
	}

	function clearSearch() {
		document.form1.patno.value = "";
	}
//-->
</script>
</div>
</div>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>