<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
	private ArrayList getCostDrugSold(String dateFrom, String dateTo) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT TO_CHAR(opt.trx_date, 'DD/MM/YYYY') as trx_date ");
		sqlStr.append("    , (SELECT pasid  FROM  patient_data@phar pd  WHERE  pd.encounter_no = opm.acct_no) AS patno ");
		sqlStr.append("    , trim(opt.drug_key)||'-'|| trim(opt.drug_type)  AS drug_code ");
		sqlStr.append("    , dm.name_eng   AS drug_name ");
		sqlStr.append("    , opt.drug_qty AS quantity ");
		sqlStr.append("    , dm.sell_uom  as sell_unit ");
		sqlStr.append("    , opt.drug_cost  AS drug_cost ");
		sqlStr.append("    , opm.slpno ");
		sqlStr.append("    , CASE ");
		sqlStr.append("      WHEN opm.pat_type = 'D' THEN 'Daycase' ");
		sqlStr.append("      WHEN substr(opm.prsb_no,1,1) = 'R' THEN 'Department' ");
		sqlStr.append("      ELSE 'Outpatient' ");
		sqlStr.append("      END as pat_type ");
		sqlStr.append("  FROM out_prsb_trx@phar opt, out_prsb_mas@phar opm, drug_mas@phar dm ");
		sqlStr.append("  WHERE opt.prsb_no    = opm.prsb_no ");
		sqlStr.append("   and opt.trx_status = 'P' ");
		sqlStr.append("   and (opm.pat_type <> 'I' or opm.pat_type is null) ");
		sqlStr.append("   and opt.drug_key   = dm.drug_key ");
		sqlStr.append("   and opt.drug_type  = dm.drug_type ");
		sqlStr.append("   and opt.drug_cost > 0 ");
		sqlStr.append("   and opt.trx_date >= TO_DATE(? || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("   and opt.trx_date <= TO_DATE(? || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");

		sqlStr.append("union all ");

		sqlStr.append("SELECT TO_CHAR(opt.trx_date, 'DD/MM/YYYY') as trx_date ");
		sqlStr.append("    , (SELECT pasid  FROM  patient_data@phar pd  WHERE  pd.encounter_no = opm.acct_no) AS patno ");
		sqlStr.append("    , trim(opt.drug_key)||'-'|| trim(opt.drug_type)  AS drug_code ");
		sqlStr.append("    , dm.name_eng   AS drug_name ");
		sqlStr.append("    , opt.drug_qty AS quantity ");
		sqlStr.append("    , dm.sell_uom  as sell_unit ");
		sqlStr.append("    , opt.drug_cost  AS drug_cost ");
		sqlStr.append("    , opm.slpno ");
		sqlStr.append("    , 'Discharge' as pat_type ");
		sqlStr.append("  FROM out_prsb_trx@phar opt, out_prsb_mas@phar opm, drug_mas@phar dm ");
		sqlStr.append("  WHERE opt.prsb_no    = opm.prsb_no ");
		sqlStr.append("   and opt.trx_status = 'P' ");
		sqlStr.append("   and opm.pat_type = 'I' ");
		sqlStr.append("   and opt.drug_key   = dm.drug_key ");
		sqlStr.append("   and opt.drug_type  = dm.drug_type ");
		sqlStr.append("   and opt.drug_cost > 0 ");
		sqlStr.append("   and opt.trx_date >= TO_DATE(? || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("   and opt.trx_date <= TO_DATE(? || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");

		sqlStr.append("union all ");

		sqlStr.append("select TO_CHAR(ipt.trx_date, 'DD/MM/YYYY') as trx_date ");
		sqlStr.append("    , pd.pasid AS patno ");
		sqlStr.append("    , trim(ipt.drug_key)||'-'|| trim(ipt.drug_type)  AS drug_code ");
		sqlStr.append("    , dm.name_eng   AS drug_name ");
		sqlStr.append("    , ipt.use_qty AS quantity ");
		sqlStr.append("    , dm.sell_uom  as sell_unit ");
		sqlStr.append("    , ipt.drug_cost  AS drug_cost ");
		sqlStr.append("    , slip.slpno ");
		sqlStr.append("    , 'Inpatient' as pat_type ");
		sqlStr.append("From INP_PRSB_TRX@phar ipt, inp_prsb_mas@phar ipm, drug_mas@phar dm, patient_data@phar pd, reg@hat, slip@hat ");
		sqlStr.append("where ipt.acct_no = ipm.acct_no and ipt.drug_key = ipm.drug_key and ipt.drug_type = ipm.drug_type and ipt.seq_no = ipm.seq_no ");
		sqlStr.append("   and ipt.acct_no = pd.encounter_no ");
		sqlStr.append("   and ipt.acct_no = reg.regid ");
		sqlStr.append("   and reg.slpno = slip.slpno ");
		sqlStr.append("   and ipt.trx_status = 'P' ");
		sqlStr.append("   and ipt.drug_key   = dm.drug_key ");
		sqlStr.append("   and ipt.drug_type  = dm.drug_type ");
		sqlStr.append("   and ipt.drug_cost > 0 ");
		sqlStr.append("   and ipt.trx_date >= TO_DATE(? || ' 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("   and ipt.trx_date <= TO_DATE(? || ' 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");

		return UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[] {dateFrom, dateTo, dateFrom, dateTo, dateFrom, dateTo});
	}
%>
<%
UserBean userBean = new UserBean(request);

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
if (message == null) {
	message = "";
}
if (errorMessage == null) {
	errorMessage = "";
}

String reportStartDate = request.getParameter("reportStartDate");
String reportEndDate = request.getParameter("reportEndDate");
// default search current date
if (reportStartDate == null || reportStartDate.length() == 0) {
	reportStartDate = DateTimeUtil.getCurrentDate();
}
if (reportEndDate == null || reportEndDate.length() == 0) {
	reportEndDate = DateTimeUtil.getCurrentDate();
}

request.setAttribute("cost_drug_sold", getCostDrugSold(reportStartDate, reportEndDate));

%><!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
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
<%@ taglib uri="/WEB-INF/fmt.tld" prefix="fmt" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Cost Drug Sold Report" />
</jsp:include>

<font color="blue"><%=message %></font>
<font color="red"><%=errorMessage %></font>

<form name="search_form" method="post" >
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="smallText">
		<td class="infoLabel" width="30%">Date Period</td>
		<td class="infoData" width="70%">
			<input type="text" name="reportStartDate" id="reportStartDate" class="datepickerfield" value="<%=reportStartDate == null ? "" : reportStartDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" />
			-
			<input type="text" name="reportEndDate" id="reportEndDate" class="datepickerfield" value="<%=reportEndDate == null ? "" : reportEndDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)" /><br>
			(DD/MM/YYYY) - (DD/MM/YYYY)
		</td>
	</tr>
</table>

<table width="100%" border="0">
	<tr class="smallText">
		<td align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
</form>

<bean:define id="functionLabel">Cost Drug Sold report</bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<display:table id="row" name="requestScope.cost_drug_sold" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column property="fields0" title="Tran date" style="width:8%;text-align:center" />
	<display:column property="fields1" title="Hosp No" style="width:8%;text-align:center" />
	<display:column property="fields2" title="Drug Code" style="width:8%;text-align:center" />
	<display:column property="fields3" title="Drug Name" style="width:20%;text-align:center" />
	<display:column property="fields4" title="Quantity" style="width:8%;text-align:center" />
	<display:column property="fields5" title="Sell Unit" style="width:8%;text-align:center" />
	<display:column property="fields6" title="Drug Cost" style="width:8%;text-align:center" />
	<display:column property="fields7" title="Slip No" style="width:12%;text-align:center" />
	<display:column property="fields8" title="Pat Type" style="width:12%;text-align:center" />

</display:table>

<script language="javascript">
	function submitSearch() {
		if (document.search_form.reportStartDate.value == '') {
			alert('Empty Start Date.');
			document.search_form.reportStartDate.focus();
			return false;
		} else if (document.search_form.reportEndDate.value == '') {
			alert('Empty End Date.');
			document.search_form.reportEndDate.focus();
			return false;
		}
		document.search_form.submit();
		return true;
	}

	function clearSearch() {
		document.search_form.reportStartDate.value = "<%=reportStartDate %>";
		document.search_form.reportEndDate.value = "<%=reportEndDate %>";
		return true;
	}
</script>
</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>