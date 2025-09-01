<%@ page import="java.util.*" %>
<%@ page import="com.hkah.util.*" %>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private static String getNextID() {
		String id = null;

		ArrayList result = UtilDBWeb.getReportableList("SELECT MAX(RH_BILL_ID) + 1 FROM RH_BILLING");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			id = reportableListObject.getValue(0);
			// set 1 for initial
			if (id == null || id.length() == 0) return "1";
		}
		return id;
	}

	private static ArrayList getTherapistList() {
		return UtilDBWeb.getReportableList("SELECT RH_STAFF_ID, RH_THERAPIST_NAME FROM RH_THERAPIST WHERE RH_ENABLED = 1 ORDER BY RH_THERAPIST_NAME");
	}
%>
<%
UserBean userBean = new UserBean(request);

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

String command = ParserUtil.getParameter(request, "command");
String patno = ParserUtil.getParameter(request, "patno");
String patfname = null;
String patgname = null;
String patadd1 = null;
String patadd2 = null;
String patadd3 = null;
String pathtel = null;
String patotel = null;
String patmtel = null;
String patftel = null;
String coucode = null;
String coudesc = null;

String billNo = ParserUtil.getParameter(request, "billNo");
String billDate = ParserUtil.getParameter(request, "billDate");
String therapistID = ParserUtil.getParameter(request, "therapistID");
String billAmount = ParserUtil.getParameter(request, "billAmount");

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
		patadd1 = row.getValue(19);
		patadd2 = row.getValue(20);
		patadd3 = row.getValue(21);
		pathtel = row.getValue(13);
		patotel = row.getValue(14);
		patmtel = row.getValue(15);
		patftel = row.getValue(16);
		coucode = row.getValue(31);

		record = UtilDBWeb.getFunctionResults("NHS_CMB_COUNTRY", null);
		if (record.size() > 0) {
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				if (row.getValue(0).equals(coucode)) {
					coudesc = row.getValue(1);
					break;
				}
			}
		}

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT RH_BILL_ID, RH_BILL_NO, TO_CHAR(RH_BILL_DATE, 'DD/MM/YYYY'), RH_THERAPIST_NAME, RH_BILL_AMOUNT ");
		sqlStr.append("FROM   RH_BILLING ");
		sqlStr.append("WHERE  RH_ENABLED = 1 ");
		sqlStr.append("AND    RH_PATIENT_NO = ? ");
		sqlStr.append("ORDER BY RH_BILL_DATE");

		record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { patno });

		request.setAttribute("rehabEarn_list", record);
	} else {
		errorMessage = "Invalid Patient No.";
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
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<%@ taglib uri="/WEB-INF/fmt.tld" prefix="fmt" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.rehabEarn.list" />
	<jsp:param name="displayTitle" value="Dragon Tiger List (Rehab)" />
	<jsp:param name="category" value="Report" />
</jsp:include>

<font color="blue"><%=message==null?"":message %></font>
<font color="red"><%=errorMessage==null?"":errorMessage %></font>
<form name="form1" action="rehabTopEarn.jsp" method="get">
<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0" width="300">
	<tr class="smallText">
		<td class="infoLabel" width="15%">Hospital No. :</td>
		<td class="infoData" width="85%" colspan="3">
<%	if (patno != null && (createAction || updateAction || deleteAction)) { %>
			<input type="hidden" name="patno" value="<%=patno %>"><%=patno %>
<%	} else { %>
			<input type="text" name="patno" value="<%=patno==null?"":patno %>" maxlength="10" size="20" onblur="checkPatNo(this);">
			&nbsp;
			<button onclick="return submitAction('search');" class="btn-click">Search</button>
<%	} %>
		</td>
	</tr>
<%	if (foundPatNo) { %>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Surname :</td>
		<td class="infoData" width="35%"><%=patfname!=null?patfname:"" %></td>
		<td class="infoLabel" width="15%">Firstname :</td>
		<td class="infoData" width="35%"><%=patgname!=null?patgname:"" %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Address :</td>
		<td class="infoData" width="85%" colspan=3">
			<%=patadd1!=null?patadd1:"" %><br />
			<%=patadd2!=null?patadd2:"" %><br />
			<%=patadd3!=null?patadd3:"" %><br />
			<%=coudesc!=null?coudesc:"" %>
		</td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Home :</td>
		<td class="infoData" width="35%"><%=pathtel!=null?pathtel:"" %></td>
		<td class="infoLabel" width="15%">Office :</td>
		<td class="infoData" width="35%"><%=patotel!=null?patotel:"" %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="15%">Mobile/Pager No :</td>
		<td class="infoData" width="35%"><%=patmtel!=null?patmtel:"" %></td>
		<td class="infoLabel" width="15%">Fax No :</td>
		<td class="infoData" width="35%"><%=patftel!=null?patftel:"" %></td>
	</tr>
<%	} %>
</table>
<%	if (foundPatNo) { %>
<%		if (createAction) { %>
<table id="row" class="tablesorter">
	<thead>
		<tr>
			<th>&nbsp;</th><th>Bill No.</th><th>Bill Date</th><th>Therapist</th><th>Amount</th><th>Action</th>
		</tr>
	</thead>
	<tbody>
		<tr class="odd">
			<td style="width:5%">&nbsp;</td>
			<td style="width:15%"><input type="textfield" name="billNo" id="billNo" value="<%=billNo==null?"":billNo %>"></td>
			<td style="width:15%"><input type="textfield" name="billDate" id="billDate" class="datepickerfield" value="<%=billDate==null?"":billDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"> (DD/MM/YYYY)</td>
			<td style="width:20%">
				<select name="therapist">
<%
		record = getTherapistList();
		if (record.size() > 0) {
			ReportableListObject row = null;
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(therapistID)?" selected":"" %>><%=row.getValue(1) %></option><%
			}
		}
%>
				</select>
			</td>
			<td style="width:20%">$ <input type="textfield" name="billAmount" id="billAmount" value="<%=billAmount==null?"":billAmount %>"></td>
			<td style="width:20%">
				<button onclick="return submitAction('create', '1';"><bean:message key="button.create" /></button>
				<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /></button>
			</td>
		</tr>
	</td>
</table>
<%		} else { %>
<bean:define id="functionLabel">Dragon Tiger List (Rehab)</bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.rehabEarn_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
	<display:column property="fields1" titleKey="prompt.billNo" style="width:15%" />
	<display:column property="fields2" title="Bill Date" style="width:15%" />
	<display:column property="fields3" title="Therapist" style="width:20%" />
	<display:column titleKey="prompt.amount" style="width:20%">
		$<fmt:formatNumber type="number" value="${row.fields4}"/>
	</display:column>
	<display:column titleKey="prompt.action" media="html" style="width:20%; text-align:center">
<%			if (!createAction) { %>
		<button onclick="return submitAction('update', '<c:out value="${row.fields0}" />';"><bean:message key="button.edit" /></button>
		<button onclick="return submitAction('delete', '<c:out value="${row.fields0}" />';"><bean:message key="button.delete" /></button>
<%			} %>
	</display:column>
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
</display:table>
<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
<%			if (createAction || updateAction || deleteAction) { %>
			<button onclick="return submitAction('<%=command %>', 1);" class="btn-click"><bean:message key="button.save" /> (<%=command%>)</button>
			<button onclick="return submitAction('view', 0);" class="btn-click"><bean:message key="button.cancel" /></button>
<%			} else { %>
			<button onclick="return submitAction('create', '');">New Referrals</button>
<%			}  %>
		</td>
	</tr>
</table>
<%		} %>
<%	} %>
<input type="hidden" name="command">
<input type="hidden" name="billid">
</form>

<script language="javascript">
<!--//
	function submitAction(cmd, billid) {
<%	if (createAction || updateAction) { %>
		if (cmd == 'create' || cmd == 'update') {
			if (document.form1.infoType.value == '') {
				alert("Empty news type.");
				document.form1.infoType.focus();
				return false;
			}
			if (document.form1.infoDescription.value == '') {
				alert("Empty title.");
				document.form1.infoDescription.focus();
				return false;
			}
		}
<%	} %>
		document.form1.command.value = cmd;
		document.form1.billid.value = billid;
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