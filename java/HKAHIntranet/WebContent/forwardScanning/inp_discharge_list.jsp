<%@ page import="java.math.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.helper.*"%>
<%@ page import="com.hkah.web.db.model.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="org.displaytag.tags.*"%>
<%@ page import="org.displaytag.util.*"%>
<%@ page import="java.io.File"%>
<%!
public static List<ReportableListObject> getInpDischargeList(String inpDischargeDateFrom, String inpDischargeDateTo, String importStatus, String approveStatus) {
	String sqlStr_getInpDischargeList = null;
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("select  ");
	sqlStr.append("	inpddate, patno, patfname, patgname, regid, import_dates, approved_dates, ");
	sqlStr.append("	LISTAGG(vol_loc, ';') WITHIN GROUP (ORDER BY vol_loc) vol_locs ");
	sqlStr.append("from (  ");
	
	sqlStr.append("select  ");
	sqlStr.append("  to_char(a.inpddate, 'dd/mm/yyyy hh24:mi:ss') INPDDATE, a.patno, a.patfname, a.patgname, a.regid, b.vol_loc ");
	sqlStr.append("  , listagg(to_char(a.fs_import_date, 'dd/mm/yyyy hh24:mi:ss'),';') within group( order by a.fs_import_date desc) import_dates ");
	sqlStr.append("  , listagg(to_char(a.fs_approved_date, 'dd/mm/yyyy hh24:mi:ss'),';') within group( order by a.fs_import_date desc) approved_dates ");
	sqlStr.append("from ( ");
	sqlStr.append("  select  ");
	sqlStr.append("    r.patno, p.patfname, p.patgname, r.regid, ");
	sqlStr.append("    inp.inpddate, ");
	sqlStr.append("    i.fs_import_date, i.fs_approved_date ");
	sqlStr.append("  from reg@hat r join inpat@hat inp on r.inpid = inp.inpid ");
	sqlStr.append("  join patient@hat p on r.patno = p.patno ");
	sqlStr.append("  left join  ");
	sqlStr.append("  ( ");
	sqlStr.append("    select distinct fs_patno, fs_regid, fs_import_date, fs_approved_date ");
	sqlStr.append("    from fs_file_index  ");
	sqlStr.append("    where fs_enabled = 1 ");
	sqlStr.append("  ) i on r.patno = i.fs_patno and r.regid = i.fs_regid ");
	sqlStr.append("  where 1=1 ");
	//sqlStr.append("  --inp.inpddate between trunc(sysdate) - 11 and trunc(sysdate) - 10 ");
	if (inpDischargeDateFrom != null && !inpDischargeDateFrom.isEmpty()) {
		sqlStr.append(" and inp.inpddate >= to_date('" + inpDischargeDateFrom + " 00:00:00', 'dd/mm/yyyy hh24:mi:ss') ");
	}
	if (inpDischargeDateTo != null && !inpDischargeDateTo.isEmpty()) {
		sqlStr.append(" and inp.inpddate < to_date('" + inpDischargeDateTo + " 00:00:00', 'dd/mm/yyyy hh24:mi:ss') + 1 ");
	}
	//sqlStr.append("  inp.inpddate between to_date('" + inpDischargeDateFrom + " 00:00:00', 'dd/mm/yyyy hh24:mi:ss') and to_date('" + inpDischargeDateTo + " 00:00:00', 'dd/mm/yyyy hh24:mi:ss') + 1 ");
	sqlStr.append("  and regsts = 'N' ");
	sqlStr.append(") a ");
	sqlStr.append("left join  ");
	sqlStr.append("( ");
	sqlStr.append("	SELECT ");
	sqlStr.append("	H.PATNO, ");
	sqlStr.append("	'(' || H.MRHVOLLAB || ') ' || DECODE(D.MRLID_R, NULL, L1.MRLDESC,L2.MRLDESC) vol_loc ");
	sqlStr.append("	FROM MEDRECHDR@hat H, MEDRECDTL@hat D, ");
	sqlStr.append("	MEDRECLOC@hat L1,MEDRECLOC@hat L2 ");
	sqlStr.append("	WHERE H.MRDID = D.MRDID ");
	sqlStr.append("	AND D.MRLID_L = L1.MRLID(+) ");
	sqlStr.append("	AND D.MRLID_R = L2.MRLID(+) ");
	sqlStr.append("	AND H.MRHSTS <> 'P' ");
	sqlStr.append(") b on a.patno = b.patno ");
	sqlStr.append("group by  ");
	sqlStr.append("  a.patno, a.patfname, a.patgname, a.regid, a.inpddate, b.vol_loc ");
	sqlStr.append("having 1=1 ");
	if ("Y".equals(importStatus) || "N".equals(importStatus)) {
		sqlStr.append(" and listagg(to_char(a.fs_import_date, 'dd/mm/yyyy hh24:mi:ss'),';') within group( order by a.fs_import_date desc) is" + ("Y".equals(importStatus) ? " not" : "") + " null ");
	}
	if ("Y".equals(approveStatus) || "N".equals(approveStatus)) {
		sqlStr.append(" and listagg(to_char(a.fs_approved_date, 'dd/mm/yyyy hh24:mi:ss'),';') within group( order by a.fs_import_date desc) is" + ("Y".equals(approveStatus) ? " not" : "") + " null ");
	}
	
	sqlStr.append(") ");
	sqlStr.append("group by inpddate, patno, patfname, patgname, regid, import_dates, approved_dates ");
	sqlStr.append("order by inpddate ");
	sqlStr_getInpDischargeList = sqlStr.toString();
	
	//System.out.println("DEBUG getInpDischargeList sql=" + sqlStr_getInpDischargeList.toString());
	
	return UtilDBWeb.getReportableListCIS(sqlStr_getInpDischargeList.toString());
}
%>
<%
UserBean userBean = new UserBean(request);
String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String keyId = ParserUtil.getParameter(request, "keyId");

String patno = ParserUtil.getParameter(request, "patno");
String inpDischargeDateType = ParserUtil.getParameter(request, "inpDischargeDateType");
String inpDischargeDate = ParserUtil.getParameter(request, "inpDischargeDate");
String inpDischargeDateFrom = ParserUtil.getParameter(request, "inpDischargeDateFrom");
String inpDischargeDateTo = ParserUtil.getParameter(request, "inpDischargeDateTo");
if (!"R".equals(inpDischargeDateType)) {
	inpDischargeDateFrom = inpDischargeDate;
	inpDischargeDateTo = inpDischargeDate;
}
String importStatus = ParserUtil.getParameter(request, "importStatus");
if (importStatus == null) {
	importStatus = "A";
}
String approveStatus = ParserUtil.getParameter(request, "approveStatus");
if (approveStatus == null) {
	approveStatus = "A";
}

Boolean isShowSuccessRecord = null;
String[] fileIndexIds = request.getParameterValues("fileIndexIds");
String listTablePageParaName = (new ParamEncoder("row").encodeParameterName(TableTagParameters.PARAMETER_PAGE));
String listTableCurPage = request.getParameter(listTablePageParaName);
String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");
if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }

String listLabel = "function.fs.inpDischarge.list";
String treeSubLink = "/common/pat_main.jsp";
String qryStrCategory = "category=fs";
String qryStrPatno = "patno=";
String qryStrViewMode = "viewMode=";
String requestURL = request.getRequestURL().toString();
String servletPath = request.getServletPath();
String treeLink = requestURL.replace(servletPath, "") + treeSubLink;

boolean approveAction = false;
if ("approve".equals(command) || "approveAll".equals(command)) {
	approveAction = true;
}

List<ReportableListObject> inpDischarge_list = null;
if (inpDischargeDate != null) {
	inpDischarge_list = ForwardScanningDB.getInpDischargeList(inpDischargeDateFrom, inpDischargeDateTo, importStatus, approveStatus);
}
request.setAttribute("inpDischarge_list", inpDischarge_list);

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
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display"%>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c"%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp" />
<style>
div.scroll {
    background-color: #E6E6E6;
    height: 200px;
    overflow: scroll;
}
.hidden {
	display: none;
}
.alert {
	font-weight: bold;
}
</style>
<body>
<div id=indexWrapper>
<div id=mainFrame>

<div id=contentFrame style="min-height:0px;">
<jsp:include page="../common/page_title.jsp">
	<jsp:param name="pageTitle" value="<%=listLabel %>" />
</jsp:include>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<jsp:include page="back.jsp" flush="false" />
<form name="search_form" action="inp_discharge_list.jsp" method="post">
	<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0" >
		<tr class="smallText hidden">
			<td class="infoLabel">Patient No.</td>
			<td class="infoData">
				<input type="text" name="patno" id="patno" value="<%=patno == null ? "" : patno %>" maxlength="10" size="10" />
			</td>
		</tr>
		<tr class="smallText">
			<td class="infoLabel">Discharge Date</td>
			<td class="infoData">
				<div id="inpDischargeDateExact">
					<input type="text" name="inpDischargeDate" class="datepickerfield" value="<%=inpDischargeDate == null ? "" : inpDischargeDate %>" maxlength="10" size="10" />
				</div>
				
				<div id="inpDischargeDateRange">
					From 
					<input type="text" name="inpDischargeDateFrom" class="datepickerfield" value="<%=inpDischargeDateFrom == null ? "" : inpDischargeDateFrom %>" maxlength="10" size="10" />
					To 
					<input type="text" name="inpDischargeDateTo" class="datepickerfield" value="<%=inpDischargeDateTo == null ? "" : inpDischargeDateTo %>" maxlength="10" size="10" />
					&nbsp;<a name="showInpDischargeDateToday" href="javascript:void(0)">show today only</a>
				</div>
				<input type="hidden" name="inpDischargeDateType" value="R" checked=checked /> 
			</td>
		</tr>
		<tr class="smallText">
			<td class="infoLabel">Import Status</td>
			<td class="infoData">
				<input type="radio" name="importStatus" value="A"<%="A".equals(importStatus) || importStatus == null?" checked":"" %> />All
				<input type="radio" name="importStatus" value="Y"<%="Y".equals(importStatus)?" checked":"" %> />Imported
				<input type="radio" name="importStatus" value="N"<%="N".equals(importStatus)?" checked":"" %> />Not imported
			</td>
		</tr>
		<tr class="smallText">
			<td class="infoLabel">Approve Status</td>
			<td class="infoData">
				<input type="radio" name="approveStatus" value="A"<%="A".equals(approveStatus) || approveStatus == null?" checked":"" %> />All
				<input type="radio" name="approveStatus" value="Y"<%="Y".equals(approveStatus)?" checked":"" %> />Approved
				<input type="radio" name="approveStatus" value="N"<%="N".equals(approveStatus)?" checked":"" %> />Not approved
			</td>
		</tr>
		<tr class="smallText">
			<td colspan="2" align="center">
				<button onclick="return submitSearch('0');"><bean:message key="button.search" /></button>
				<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
			</td>
		</tr>
	</table>
	<input type="hidden" name="<%=listTablePageParaName %>" />
	<input type="hidden" name="command" />
	<input type="hidden" name="step" />
</form>
<div style="margin: 10 0;">
Number of distinct patient in this list: <span id="patno_count" style="font-weight: bold;"></span>
</div>
<bean:define id="functionLabel"><bean:message key="<%=listLabel %>" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<%
	Set<String> patnos = new HashSet<String>();
%>
<form name="form1" action="importLog_list.jsp" method="post">
	<display:table id="row" name="requestScope.inpDischarge_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter"
			decorator="com.hkah.web.displaytag.ForwardScanningDecorator">
	<%
		String thisPatno = null;
		String thisImportDates = null;
		ReportableListObject row2 = null;
		boolean noImportChart = true;
		String styleClass = "";
		if (pageContext.getAttribute("row") != null) {
			row2 = ((ReportableListObject) pageContext.getAttribute("row"));
			thisPatno = row2.getFields1();
			thisImportDates = row2.getFields5();
			noImportChart = thisImportDates == null || thisImportDates.isEmpty();
		}
	%>
		<display:column title="&nbsp;" media="html" style="width:5%"><%=pageContext.getAttribute("row_rowNum")%>)</display:column>
		<display:column property="fields0" title="Discharge Date" style="width:14%" />
		<display:column property="fields1" title="Patient No." style="width:10%" media="csv excel xml pdf" />
		<display:column title="Patient No." style="width:10%" media="html">
<% 
	if (noImportChart) {
		styleClass = "alert";
	} 
%>	
			<span class="<%=styleClass %>">
				<%=thisPatno%>
			</span>
		</display:column>
		<display:column property="fields2" title="First Name" style="width:10%" />
		<display:column property="fields3" title="Last Name" style="width:10%" />
		<display:column property="fields4" title="Reg ID" style="width:10%" />
		<display:column property="volCurrentChartLocDisplay" title="(Vol) Current Chart Location" style="width:15%" />
		<display:column property="inpDischargeImportDateDisplay" title="Import Dates" style="width:14%" media="html" />
		<display:column property="fields5" title="Import Dates" style="width:14%" media="csv excel xml pdf" />
		<display:column property="inpDischargeApproveDateDisplay" title="Approve Dates" style="width:14%" media="html" />
		<display:column property="fields6" title="Approve Dates" style="width:14%" media="csv excel xml pdf" />
		<display:column titleKey="prompt.action" media="html" style="width:11%; text-align:center;">
<% if (!noImportChart) { %>
			<button onclick="return submitAction('view', 1, '<%=thisPatno %>');">View Indexes</button>
			<!-- <button onclick="return submitAction('viewTree', 1, '<%=thisPatno %>');">Chart</button>-->
<% } %>
		</display:column>
		<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>" />
	</display:table>
	<input type="hidden" name="command" />
	<input type="hidden" name="step" />
	<input type="hidden" name="keyId" />
</form>
<script language="javascript">
//store file index list
	$(document).ready(function(){
		$("#inpDischargeDateRange").show();
		$("#inpDischargeDateExact").hide();
		$("a[name=showInpDischargeDateToday]").click(function(){
			var d = new Date();
			var c_date = d.getDate();
			var c_month = d.getMonth() + 1;
			if (c_month < 10) {
				c_month = '0' + c_month;
			}
			var c_year = d.getFullYear();
			var c_dateStr = c_date + '/' + c_month + '/' + c_year;
			
			$("input[name=inpDischargeDateFrom]").val(c_dateStr);
			$("input[name=inpDischargeDateTo]").val(c_dateStr);
		});
	});

	function submitSearch(stp) {
		if (stp == 1) {
			showLoadingBox('body', 500, $(window).scrollTop());
			document.search_form.submit();
			return true;
		} else {
			if ($("input[name=inpDischargeDateType]").val() == 'R') {
				var inpDischargeDateFromVal = $("input[name=inpDischargeDateFrom]").val();
				var inpDischargeDateToVal = $("input[name=inpDischargeDateTo]").val();
				var msg = '';
				if (inpDischargeDateFromVal == '' && inpDischargeDateToVal == '') {
					alert('Please select discharge date range.');
					$("input[name=inpDischargeDateFrom]").focus();
					return false;
				} else if (inpDischargeDateFromVal == '') {
					msg = 'Start date is not selected. It may take a long time to search.';
				} else if (inpDischargeDateToVal == '') {
					msg = 'End date is not selected. It may take a long time to search.';
				} else {
					submitSearch('1');
				}
				if (msg != '') {
					msg = msg + ' Do you want to continue?';
					$.prompt(msg,{
						buttons: { Ok: true, Cancel: false },
						callback: function(v,m,f){
							if (v){
								submitSearch('1');
							}
						},
						prefix:'cleanblue'
					});
				}
			}
			return false;
		}
	}
	
	function clearSearch() {
		document.search_form.patno.value = "";
		document.search_form.inpDischargeDate.value = "";
		
		return false;
	}
	
	function submitAction(cmd, step, keyId) {
		if (cmd == 'view') {
			callPopUpWindow("file_list.jsp?command=view&patno=" + keyId + "&approveStatus=P");
			return false;
		} else if (cmd == 'viewTree') {
				//callPopUpWindow("file_list.jsp?command=view&patno=" + keyId + "&approveStatus=P");
				return false;			
		} else {
			document.form1.command.value = cmd;
			document.form1.step.value = step;
			document.form1.keyId.value = keyId;
			document.form1.submit();
			showLoadingBox('body', 500, $(window).scrollTop());
			return true;
		}
	}
	
	function createTreeLink() {
		return "<%=treeLink %>?<%=qryStrCategory %>&<%=qryStrPatno %>" + $('#patno').val() + "&<%=qryStrViewMode %>" + $('input[name="viewMode"]:checked').val();
	}
</script></DIV>

</DIV>
</DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>