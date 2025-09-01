<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private ArrayList<ReportableListObject> fetchClass() {
		return UtilDBWeb.getReportableListHATS("SELECT ACMCODE, ACMNAME FROM FIN_ACM ORDER BY SORT");
	}

	private ArrayList<ReportableListObject> fetchProc(boolean isGP) {
		if (isGP) {
			return UtilDBWeb.getReportableListHATS("SELECT TYPECODE, TYPEDESC FROM FIN_TYPE WHERE ISGP = '1' ORDER BY TYPECODE");
		} else {
			return UtilDBWeb.getReportableListHATS("SELECT TYPECODE, TYPEDESC FROM FIN_TYPE ORDER BY TYPECODE");
		}
	}

	private ArrayList<ReportableListObject> fetchDoctor(boolean isGP) {
		if (ConstantsServerSide.isTWAH()) {
			return UtilDBWeb.getReportableListHATS("SELECT DOCCODE, DOCFNAME || ' ' || DOCGNAME, DOCCNAME FROM DOCTOR WHERE DOCSTS = -1 ORDER BY DOCFNAME, DOCGNAME");
		} else if (isGP) {
			return UtilDBWeb.getReportableListHATS("SELECT DOCCODE, DOCFNAME || ' ' || DOCGNAME, DOCCNAME FROM DOCTOR WHERE DOCSTS = -1 AND ((DOCCODE not like '7%' and DOCCODE not like '8%') or LENGTH(DOCCODE) <> 4) AND DOCCODE in ('1494', '1420', '1838', '740') ORDER BY DOCFNAME, DOCGNAME");
		} else {
			return UtilDBWeb.getReportableListHATS("SELECT DOCCODE, DOCFNAME || ' ' || DOCGNAME, DOCCNAME FROM DOCTOR WHERE DOCSTS = -1 AND ((DOCCODE not like '7%' and DOCCODE not like '8%') or LENGTH(DOCCODE) <> 4) ORDER BY DOCFNAME, DOCGNAME");
		}
	}

	private ArrayList<ReportableListObject> fetchRegistrationRecord(String regid) {
		return UtilDBWeb.getReportableListHATS("SELECT PATNO, DOCCODE FROM REG WHERE REGID = ?", new String[] { regid });
	}

	private String getMasterDoctor(String doccode) {
		ArrayList<ReportableListObject> result = UtilDBWeb.getReportableListHATS(
				"SELECT MSTRDOCCODE FROM DOCTOR WHERE DOCCODE = ? AND DOCSTS = -1 AND MSTRDOCCODE IS NOT NULL",
				new String[] { doccode });
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else{
			return null;
		}
	}

	private UserBean createUserAccount(HttpServletRequest request, String doccode) {
		UserBean userBean = null;
		if (doccode != null && doccode.length() > 2 && !ConstantsServerSide.SECURE_SERVER) {
			userBean = UserDB.getUserBean(request, "DR" + doccode);

			String masterDoccode = doccode;

			if (userBean == null) {
				masterDoccode = getMasterDoctor(doccode);
				if (masterDoccode != null) {
					userBean = UserDB.getUserBean(request, "DR" + masterDoccode);
				} else {
					masterDoccode = doccode;
				}
			}

			if (userBean == null) {
				String docPwd = UserDB.getDoctorPassword(masterDoccode);

				if (docPwd != null) {
					// new user?
					UtilDBWeb.callFunction("HAT_ACT_CREATEDOCTOR", "ADD", new String[] { masterDoccode, PasswordUtil.cisEncryption(docPwd)});

					userBean = UserDB.getUserBean(request, "DR" + masterDoccode);
				}
			}
		}
		return userBean;
	}
%>
<%
	UserBean userBean = new UserBean(request);

	String patno = request.getParameter("patno");
	String doccode = request.getParameter("doccode");
	String hatsDoccode = null;
	if (userBean.isLogin()) {
		hatsDoccode = userBean.getStaffID();
	}
	String ProcedureSelect1 = request.getParameter("ProcedureSelect1");
	String regid = request.getParameter("regid");
	String patname = null;
	String patcname = null;
	String patidno = null;

	String roomClass = request.getParameter("room_class");

	ArrayList<ReportableListObject> record = null;
	ArrayList<ReportableListObject> recordDocList = fetchDoctor(false);
	ReportableListObject row = null;

	if (regid != null) {
		record = fetchRegistrationRecord(regid);
		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			patno = row.getValue(0);
			doccode = row.getValue(1);

			hatsDoccode = doccode;
			userBean = createUserAccount(request, doccode);
		}
	} else if (hatsDoccode != null && hatsDoccode.length() > 2) {
		int index = hatsDoccode.indexOf("DR");
		if (recordDocList.size() > 0 && index == 0) {
			hatsDoccode = hatsDoccode.substring(2);
			for (int i = 0; i < recordDocList.size(); i++) {
				row = (ReportableListObject) recordDocList.get(i);
				if (row.getValue(0).equals(hatsDoccode)) {
					doccode = hatsDoccode;
					break;
				}
			}
		}
	} else {
		hatsDoccode = doccode;
		userBean = createUserAccount(request, doccode);
	}

	boolean isGP = userBean != null && userBean.isLogin() && userBean.isAccessible("function.financialEstimation.gp");
	if (isGP) {
		recordDocList = fetchDoctor(isGP);
	}

	boolean isFreeTextDoc = userBean != null && userBean.isLogin() && userBean.isAccessible("function.financialEstimation.pbo");

	boolean allowViewHistory = userBean != null && userBean.isLogin() && !isGP &&
		((doccode != null && hatsDoccode != null && hatsDoccode.equals(doccode)) || userBean.isAccessible("function.financialEstimation.viewHistory"));

if (userBean != null && userBean.isLogin()) {
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate"); // HTTP 1.1.
response.setHeader("Pragma", "no-cache"); // HTTP 1.0.
response.setHeader("Expires", "0"); // Proxies.
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
<html:html xhtml="true" lang="true">
<!--jsp:include page="../common/header.jsp"/-->
<!-- BEGIN syntax highlighter -->
<script type="text/javascript" src="sh/shCore.js"></script>
<script type="text/javascript" src="sh/shBrushJScript.js"></script>
<link type="text/css" rel="stylesheet" href="sh/shCore.css"/>
<link type="text/css" rel="stylesheet" href="sh/shThemeDefault.css"/>
<script type="text/javascript">
	SyntaxHighlighter.all();
</script>
<!-- END syntax highlighter -->

<script src="../js/jquery-1.3.2.min.js" type="text/javascript"></script>
<script src="../js/jquery.searchabledropdown-1.0.8.min.js" type="text/javascript"></script>
<link rel="stylesheet" href="../css/jquery-ui.css">
<body>
	<form name="frmEstimate" id="frmEstimate" autocomplete="off" method="post">
	<div id="mask"></div>

	<table width="980px" border="0">
	<tr bgcolor='#FAFAD2'>
		<td width="100%">
			For support, please call hotline <b>(852) <%if (ConstantsServerSide.isTWAH()) {%>2275-6010<%} else { %>3651-8990<%} %></b>.
<%if (!ConstantsServerSide.isTWAH()) {%>
			Office hour: Mon - Fri 9:00 - 17:30 (except public holiday)
<%} %>
			<br>
			Please remember to
<%if (ConstantsServerSide.isTWAH()) {%>
			fax (<b>(852) 2275-6015</b>)
<%} else { %>
			fax (<b>(852) 3651-8801</b>) or email (<a href="mailto:hkahpsr@hkah.org.hk">hkahpsr@hkah.org.hk</a>)
<%} %>
			<i>Form A</i> and <i>Form B</i> to hospital.
		</td>
	</tr>
	</table>

	<table width="980px" border="1">
	<th colspan="4" bgcolor='#D8BFD8'>
			Financial Estimation Form for Hospital Admission and Procedure / Surgery <font color='red'>(August 2017)</font>
	</th>

	<tr bgcolor='#DDDDD'>
		<td><b>Patient No.: </b><input type='text' id='patno' name='patno' value="<%=patno==null?"":patno%>" maxlength="10" <% if (patno != null) { %> readonly <%} else {%> onblur="getPatName(this)"<%} %>></td>
		<td><b>Patient Name: </b><input type='text' id='patname' name='patname' value="<%=patname==null?"":patname%>" maxlength="40"></td>
		<td><b>Chinese Name: </b><input type='text' id='patcname' name='patcname' value="<%=patcname==null?"":patcname%>" maxlength="10"></td>
		<td><b>ID/Passport No: </b><input type='text' id='patidno' name='patidno' value="<%=patidno==null?"":patidno%>" maxlength="20"></td>
	</tr>
	</table>

	<table width="980px" border="0">
	<tr>
		<td width="32%"><b>主診醫生 Attending Doctor</b></td>
		<td colspan="4"><table><tr><td>
			<select name="DocSelect" id="DocSelect" onchange="clearDocInput();">
				<option value=''>---- Please Select Attending Doctor ----</option>
<%
	if (recordDocList != null && recordDocList.size() > 0) {
		for (int i = 0; i < recordDocList.size(); i++) {
			row = (ReportableListObject) recordDocList.get(i);
%>
				<option value="<%=row.getValue(0) %>"<%if (row.getValue(0).equals(doccode)) {%> selected<%}%>><%=row.getValue(1) %>&nbsp;<%=row.getValue(2) %> (<%=row.getValue(0) %>)</option>
<%
		}
	}
%>
			</select></td>
<%	if (isFreeTextDoc) { %>
			<td>or Free Text <input type='text' id='DocInput' name='DocInput' value="" maxlength="40" onblur="clearDocSelect();"></td>
<%	} %>
			</tr></table>
		</td>
	</tr>

	<!-- Procedure 1 -->
	<tr>
		<td style="line-height:1.2;"><b>醫療程序/手術類型 Procedure/Surgical Operation</b></td>
		<td colspan="4"><table><tr><td>
			<select name="ProcedureSelect1" id="ProcedureSelect1" onchange="return changeCode(this);">
				<option value=''>---- Please Select Procedure ----</option>
<%
	record = fetchProc(isGP);
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
%>
				<option value="<%=row.getValue(0) %>"<%if (row.getValue(0).equals(ProcedureSelect1)) {%> selected<%}%>><%=row.getValue(1) %></option>
<%
		}
	}
%>
			</select></td>
<%	if (isFreeTextDoc) { %>
			<td>or HATS Code <input type='text' id='ProcedureInput' name='ProcedureInput' value="" maxlength="20" onblur="return changeCodeByOperationCode();"></td>
<%	} %>
			</tr></table>
		</td>
	</tr>
	<!-- Procedure 2 -->
	<tr>
		<td style="line-height:1.2;">&nbsp;</td>
		<td colspan="4">
			<span id="ProcedureSelect2_indicator" />
		</td>
	</tr>
	<tr>
		<td>初步診斷 Provisional Diagnosis</td>
		<td colspan="4"><input type="text" class="textBox" id="DiagnosisText" name="DiagnosisText" maxlength="50" value="" style="width: 550px;" /></td>
	</tr>
<%	if (ConstantsServerSide.isHKAH()) {%>
	<!-- Procedure Range -->
<!--
	<tr bgcolor='#FAFAD2'>
		<td colspan="5" align="center"><b>Available Data Range of Fees</b>&nbsp;<i>(data will be displayed at section 'Estimated Hospital Charges' after selection)</i></td>
	</tr>
	<tr>
		<td colspan="5">
			<span id="ProcedureRange_indicator" />
		</td>
	</tr>
-->
	<!-- Procedure Range -->
<!--
	<tr bgcolor='#FAFAD2'>
		<td colspan="5" align="center"><b>Actual Class and LOS</b>&nbsp;<i>(may change per admission need)</i></td>
	</tr>
-->
<%	}%>
	<tr>
		<td>病房級別 Class of Ward</td>
		<td colspan="4"><select name="acmSelect" id="acmSelect" onchange="javascript:changeBed(this, true);">
				<option value=''>---- Select ----</option>
<%
	record = fetchClass();
	if (record.size() > 0) {
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
%>
				<option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(roomClass)?" selected":"" %>><%=row.getValue(1) %></option>
<%
		}
	}
%>
			</select>
		</td>
	</tr>
	<tr>
		<td>預計住院時間 Estimated Length of Stay</td>
		<td colspan="3"><table><tr><td>
			<select name="DaySelect" id="DaySelect" onchange="javascript: changeDay();">
<%	for (int i = 0; i <= 31; i++) { %>
				<option value='<%=i %>'><%=i %></option>
<%	}%>
			</select></td><td width="100">Day(s)</td></tr></table>
		</td>
		<td align="right">
			<button type=button id="btnRef" name="btnRef" onclick="javascript:refFunction(true);"><b>Reference</b></button>
			<button type=button id="btnReload" name="btnReload" onclick="javascript:pageReload()"><b>Reset</b></button>
		</td>
	</tr>
	<tr>
		<td colspan="5">
			<div style="float:left">
<%	if (ConstantsServerSide.isTWAH()) {%>
<!--
				<a href="Surgical Package.pdf" target="_blank"><img alt="住院需知 / 收費" src="../images/file.gif" width="16" border="0">Package Charges  套餐收費</a>
-->
<%	} else { %>
				<img alt="Daily Room Rates" src="../images/file.gif" width="16" onclick="javascript: window.open('https://www.hkah.org.hk/en/hospitalization/detail/id/18');"/>&nbsp;<a href="#" onclick="javascript: window.open('https://www.hkah.org.hk/en/hospitalization/detail/id/18');">Package Charges</a>&nbsp;&nbsp;&nbsp;&nbsp;
				<img alt="住院需知 / 收費" src="../images/file.gif" width="16" onclick="javascript: window.open('https://www.hkah.org.hk/tc/hospitalization/detail/id/18');"/>&nbsp;<a class="chinese" href="#" onclick="javascript: window.open('https://www.hkah.org.hk/tc/hospitalization/detail/id/18');">套餐收費</a>
<%	} %>
			</div>
		</td>
	</tr>

	<tr bgcolor='#cccccc'><td colspan="5" height="2"></td></tr>

	<tr><td colspan="4" height="0"></td>
		<td colspan="4"><div id="chartWrap">
		<!--[if lte IE 8]>
		<iframe id="chart" src="" width="980px" height="980px" frameborder="0" style="background-color:#fffff; overflow:scroll; display:none"></iframe></div>
		<![endif]-->
		<!--[if gte IE 9]>
		<iframe id="chart" src="" width="980px" height="650px" frameborder="0" style="background-color:#fffff; overflow:scroll; display:none"></iframe></div>
		<![endif]-->
		<![if !IE]>
		<iframe id="chart" src="" width="980px" height="650px" frameborder="0" style="background-color:#fffff; overflow:scroll; display:none"></iframe></div>
		<![endif]>
	</tr>
	</table>

	<table width="980px" border="0">
	<tr bgcolor='#FAFAD2'>
		<td colspan="2">&nbsp;</td>
		<td colspan="3" align="center"><b>醫生參考費用 Doctor Reference Range</b></td>
		<td>&nbsp;</td>
	</tr>
	<tr bgcolor='#FAFAD2'>
		<td colspan="2">&nbsp;</td>
		<td width="15%" align="center"><button type="button" style="font-size:15px;" onclick="copy2Input('2');">Select</button></td>
		<td width="15%" align="center"><button type="button" style="font-size:15px;" onclick="copy2Input('3');">Select</button></td>
		<td width="15%" align="center"><button type="button" style="font-size:15px;" onclick="copy2Input('4');">Select</button></td>
		<td align="center">&nbsp;</td>
	</tr>
	<tr bgcolor='#FAFAD2'>
		<td colspan="2" width="40%"><b>預計醫生費用 Estimated Doctor's Fees</b></td>
		<td width="15%" align="center"><b>Attending Doctor</b></td>
		<td width="15%" align="center"><b>Package</b><font color="red">(2)</font></font></td>
		<td width="15%" align="center"><b>All Doctors</b></td>
		<td width="15%" align="center"><b>Quotation</b><font color="red">(5)</font></td>

	</tr>
	<tr>
		<td width="25%">每日醫生巡房費 Daily Doctor's Round Fee
<%if (ConstantsServerSide.isTWAH()) {%>
			<br><a href="https://www.twah.org.hk/getfile/index/action/images/name/T01_ward_accommodation_R.pdf" target="_blank">參考 Reference</a>
<%} %>
		</td>
		<td width="15%">
			<table>
				<tr>
					<td><input type="text" value="1" size="2" name="DrRndDay1" id="DrRndDay1" value="" onkeypress='numCheck(event)' onchange="javascript: numCheck2(this); DrRndCal();" readonly /></td>
					<td> day(s)</td>
					<td><b>x</b></td>
				</tr>
				<tr>
					<td colspan="3">
						$ <input type="text" name="DocRoundFeeMinInput" id="DocRoundFeeMinInput" value="" onkeypress='numCheck(event)' onblur="javascript: numCheck2(this); InputCal();"/>
						~ <input type="text" name="DocRoundFeeMaxInput" id="DocRoundFeeMaxInput" value="" onkeypress='numCheck(event)' onblur="javascript: numCheck2(this); InputCal();"/>
					</td>
				</tr>
			</table>
		</td>
		<td width="15%" align="center">
			<input type="text" class="minQ" name="DocRoundFeeMinQ" id="DocRoundFeeMinQ" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
			<input type="text" class="maxQ" name="DocRoundFeeMaxQ" id="DocRoundFeeMaxQ" onkeypress='numCheck(event)' onchange="javascript: MaxCal();" readonly />
		</td>
		<td width="15%" align="center">
			$ <input type="text" class="minS" name="DocRoundFeeMinS" id="DocRoundFeeMinS" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
			~ <input type="text" class="maxS" name="DocRoundFeeMaxS" id="DocRoundFeeMaxS" onkeypress='numCheck(event)' onchange="javascript: MaxCal();" readonly />
		</td>
		<td width="15%" align="center">
			<input type="text" class="minT" name="DocRoundFeeMinT" id="DocRoundFeeMinT" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
			<input type="text" class="maxT" name="DocRoundFeeMaxT" id="DocRoundFeeMaxT" onkeypress='numCheck(event)' onchange="javascript: MaxCal();" readonly />
		</td>
		<td align="center">
			$ <input type="text" class="minT sMininput" name="DrRndDaySumMin1" id="DrRndDaySumMin1" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
			~ <input type="text" class="maxT sMaxinput" name="DrRndDaySumMax1" id="DrRndDaySumMax1" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
		</td>
	</tr>
	<tr>
		<td>手術費 Surgical Fee
			<img id="chartBtn1" alt="Chart of Daily Surgical Fee" src="../images/search.gif" width="20" onclick="openiFrame('ProFeeInput')" style='visibility:hidden;'/>
		</td>
		<td>&nbsp;</td>
		<td align="center">
			<input type="text" class="minQ sminQ" name="ProFeeMinQ" id="ProFeeMinQ" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
			<input type="text" class="maxQ smaxQ" name="ProFeeMaxQ" id="ProFeeMaxQ" onkeypress='numCheck(event)' onchange="javascript: MaxCal();" readonly />
		</td>
		<td align="center">
			$ <input type="text" class="minS sminS" name="ProFeeMinS" id="ProFeeMinS" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
			~ <input type="text" class="maxS smaxS" name="ProFeeMaxS" id="ProFeeMaxS" onkeypress='numCheck(event)' onchange="javascript: MaxCal();" readonly />
		</td>
		<td align="center">
			<input type="text" class="minT sminT" name="ProFeeMinT" id="ProFeeMinT" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
			<input type="text" class="maxT smaxT" name="ProFeeMaxT" id="ProFeeMaxT" onkeypress='numCheck(event)' onchange="javascript: MaxCal();" readonly />
		</td>
		<td align="center">
			$ <input type="text" class="input sMininput" name="ProFeeMinInput" id="ProFeeMinInput" value="" onkeypress='numCheck(event)' onblur="javascript: numCheck2(this); InputCal();"/>
			~ <input type="text" class="input sMaxinput" name="ProFeeMaxInput" id="ProFeeMaxInput" value="" onkeypress='numCheck(event)' onblur="javascript: numCheck2(this); InputCal();"/>
		</td>
	</tr>
	<tr>
		<td>麻醉科醫生費 Anaesthetist's Fee
			<img id="chartBtn2" alt="Chart of Daily Anaesthetist Fee" src="../images/search.gif" width="20" onclick="openiFrame('AnaesthetistFeeInput')" style='visibility:hidden;'/>
		</td>
		<td>&nbsp;</td>
		<td align="center">
			<input type="text" class="minQ sminQ" name="AnaesthetistFeeMinQ" id="AnaesthetistFeeMinQ" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
			<input type="text" class="maxQ smaxQ" name="AnaesthetistFeeMaxQ" id="AnaesthetistFeeMaxQ" onkeypress='numCheck(event)' onchange="javascript: MaxCal();" readonly />
		</td>
		<td align="center">
			$ <input type="text" class="minS sminS" name="AnaesthetistFeeMinS" id="AnaesthetistFeeMinS" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
			~ <input type="text" class="maxS smaxS" name="AnaesthetistFeeMaxS" id="AnaesthetistFeeMaxS" onkeypress='numCheck(event)' onchange="javascript: MaxCal();" readonly />
		</td>
		<td align="center">
			<input type="text" class="minT sminT" name="AnaesthetistFeeMinT" id="AnaesthetistFeeMinT" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
			<input type="text" class="maxT smaxT" name="AnaesthetistFeeMaxT" id="AnaesthetistFeeMaxT" onkeypress='numCheck(event)' onchange="javascript: MaxCal();" readonly />
		</td>
		<td align="center">
			$ <input type="text" class="input sMininput" name="AnaesthetistFeeMinInput" id="AnaesthetistFeeMinInput" value="" onkeypress='numCheck(event)' onblur="javascript: numCheck2(this); InputCal();"/>
			~ <input type="text" class="input sMaxinput" name="AnaesthetistFeeMaxInput" id="AnaesthetistFeeMaxInput" value="" onkeypress='numCheck(event)' onblur="javascript: numCheck2(this); InputCal();"/>
		</td>
	</tr>
	<tr>
		<td>兒科/其他專科醫生診療費用 Paediatrician/Other Specialists' Consultation Fee</td>
		<td>&nbsp;</td>
		<td align="center">
			<input type="text" class="minQ sminQ" name="OtherMin1Q" id="OtherMin1Q" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
			<input type="text" class="maxQ smaxQ" name="OtherMax1Q" id="OtherMax1Q" onkeypress='numCheck(event)' onchange="javascript: MaxCal();" readonly />
		</td>
		<td align="center">
			$ <input type="text" class="minS sminS" name="OtherMin1S" id="OtherMin1S" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
			~ <input type="text" class="maxS smaxS" name="OtherMax1S" id="OtherMax1S" onkeypress='numCheck(event)' onchange="javascript: MaxCal();" readonly />
		</td>
		<td align="center">
			<input type="text" class="minT sminT" name="OtherMin1T" id="OtherMin1T" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
			<input type="text" class="maxT smaxT" name="OtherMax1T" id="OtherMax1T" onkeypress='numCheck(event)' onchange="javascript: MaxCal();" readonly />
		</td>
		<td align="center">
			$ <input type="text" class="input sMininput" name="OtherMin1Input" id="OtherMin1Input" value="" onkeypress='numCheck(event)' onblur="javascript: numCheck2(this); InputCal();"/>
			~ <input type="text" class="input sMaxinput" name="OtherMax1Input" id="OtherMax1Input" value="" onkeypress='numCheck(event)' onblur="javascript: numCheck2(this); InputCal();"/>
		</td>
	</tr>
	<tr>
		<td>其他項目及收費 Other Items and Charges
			<img id="chartBtn3" alt="Chart of Other Items and Charges" src="../images/search.gif" width="20" onclick="openiFrame('OtherInput2')" style='visibility:hidden;'/>
		</td>
		<td>&nbsp;</td>
		<td align="center">
			<input type="text" class="minQ sminQ" name="OtherMin2Q" id="OtherMin2Q" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
			<input type="text" class="maxQ smaxQ" name="OtherMax2Q" id="OtherMax2Q" onkeypress='numCheck(event)' onchange="javascript: MaxCal();" readonly />
		</td>
		<td align="center">
			$ <input type="text" class="minS sminS" name="OtherMin2S" id="OtherMin2S" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
			~ <input type="text" class="maxS smaxS" name="OtherMax2S" id="OtherMax2S" onkeypress='numCheck(event)' onchange="javascript: MaxCal();" readonly />
		</td>
		<td align="center">
			<input type="text" class="minT sminT" name="OtherMin2T" id="OtherMin2T" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
			<input type="text" class="maxT smaxT" name="OtherMax2T" id="OtherMax2T" onkeypress='numCheck(event)' onchange="javascript: MaxCal();" readonly />
		</td>
		<td align="center">
			$ <input type="text" class="input sMininput" name="OtherMin2Input" id="OtherMin2Input" value="" onkeypress='numCheck(event)' onblur="javascript: numCheck2(this); InputCal();"/>
			~ <input type="text" class="input sMaxinput" name="OtherMax2Input" id="OtherMax2Input" value="" onkeypress='numCheck(event)' onblur="javascript: numCheck2(this); InputCal();"/>
		</td>
	</tr>
	<tr bgcolor='#FAFAD2'>
		<td colspan="2">&nbsp;</td>
		<td colspan="3" align="center"><b>醫院參考費用 Hospital Reference Range</b></td>
		<td>&nbsp;</td>
	</tr>
	<tr bgcolor='#FAFAD2'>
		<td colspan="2">&nbsp;</td>
		<td width="15%" align="center"><button type="button" style="font-size:15px;" onclick="copy2Input('2');">Select</button></td>
		<td width="15%" align="center"><button type="button" style="font-size:15px;" onclick="copy2Input('3');">Select</button></td>
		<td width="15%" align="center"><button type="button" style="font-size:15px;" onclick="copy2Input('4');">Select</button></td>
		<td align="center">&nbsp;</td>
	</tr>
	<tr bgcolor='#FAFAD2'>
		<td colspan="2"><b>預計醫院費用 Estimated Hospital Charges</b></td>
		<td align="center"><b>Attending Doctor</b>
<%if (allowViewHistory) { %>
			<br><a href="javascript:viewHistory()">Historical Report</a> <font color="red">(1)</font>
<%}%>
		</td>
		<td align="center"><b>Package</b><font color="red">(2)</font><br><a href="javascript:viewLeaflet()">Leaflet</a> <font color="red">(3)</font></td>
		<td align="center"><b>All Doctors</b><font color="red">(4)</font></td>
		<td align="center"><b>Quotation</b><font color="red">(5)</font></td>
	</tr>
	<tr>
		<td>住宿 Room</td>
		<td>
			<table>
				<tr>
					<td><input type="text" value="1" size="2" name="DrRndDay2" id="DrRndDay2" value="" onkeypress='numCheck(event)'  onchange="javascript: numCheck2(this); DrRndCal();" readonly /></td>
					<td> day(s)</td>
					<td><b>x</b></td>
				</tr>
				<tr>
					<td colspan="3">
						$ <input type="text" name="RoomChgMinInput" id="RoomChgMinInput" value="" onkeypress='numCheck(event)' onblur="javascript: numCheck2(this); InputCal();"/>
						~ <input type="text" name="RoomChgMaxInput" id="RoomChgMaxInput" value="" onkeypress='numCheck(event)' onblur="javascript: numCheck2(this); InputCal();"/>
					</td>
				</tr>
			</table>
		</td>
		<td align="center">
			<input type="text" class="minQ sminQ" name="RoomChgMinQ" id="RoomChgMinQ" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
			<input type="text" class="maxQ smaxQ" name="RoomChgMaxQ" id="RoomChgMaxQ" onkeypress='numCheck(event)' onchange="javascript: MaxCal();" readonly />
		</td>
		<td align="center">
			$ <input type="text" class="minS sminS" name="RoomChgMinS" id="RoomChgMinS" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
			~ <input type="text" class="maxS smaxS" name="RoomChgMaxS" id="RoomChgMaxS" onkeypress='numCheck(event)' onchange="javascript: MaxCal();" readonly />
		</td>
		<td align="center">
			$ <input type="text" class="minT sminT" name="RoomChgMinT" id="RoomChgMinT" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
			~ <input type="text" class="maxT smaxT" name="RoomChgMaxT" id="RoomChgMaxT" onkeypress='numCheck(event)' onchange="javascript: MaxCal();" readonly />
		</td>
		<td align="center">
			$ <input type="text" class="minT sMininput" name="DrRndDaySumMin2" id="DrRndDaySumMin2" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
			~ <input type="text" class="maxT sMaxinput" name="DrRndDaySumMax2" id="DrRndDaySumMax2" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
		</td>
	</tr>
	<tr>
		<td>手術室及相關物料費用 Operating Theatre and Associated Materials Charges
			<img id="chartBtn4" alt="Chart of Daily Anaesthetist's Round Fee" src="../images/search.gif" width="20" onclick="openiFrame('OTInput')" style='visibility:hidden;'/>
		</td>
		<td>&nbsp;</td>
		<td align="center">
			$ <input type="text" class="minQ sminQ" name="OTMinQ" id="OTMinQ" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
			~ <input type="text" class="maxQ smaxQ" name="OTMaxQ" id="OTMaxQ" onkeypress='numCheck(event)' onchange="javascript: MaxCal();" readonly />
		</td>
		<td align="center">
			$ <input type="text" class="minS sminS" name="OTMinS" id="OTMinS" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
			~ <input type="text" class="maxS smaxS" name="OTMaxS" id="OTMaxS" onkeypress='numCheck(event)' onchange="javascript: MaxCal();" readonly />
		</td>
		<td align="center">
			$ <input type="text" class="minT sminT" name="OTMinT" id="OTMinT" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
			~ <input type="text" class="maxT smaxT" name="OTMaxT" id="OTMaxT" onkeypress='numCheck(event)' onchange="javascript: MaxCal();" readonly />
		</td>
		<td align="center">
			$ <input type="text" class="input sMininput" name="OTMinInput" id="OTMinInput" value="" onkeypress='numCheck(event)' onblur="javascript: numCheck2(this); InputCal();"/>
			~ <input type="text" class="input sMaxinput" name="OTMaxInput" id="OTMaxInput" value="" onkeypress='numCheck(event)' onblur="javascript: numCheck2(this); InputCal();"/>
		</td>
	</tr>
	<tr>
		<td>其他醫院收費 Other Hospital Charges
			<img id="chartBtn5" alt="Chart of Daily Other Items/Charges' Round Fee" src="../images/search.gif" width="20" onclick="openiFrame('OtherInput3')" style='visibility:hidden;'/>
		</td>
		<td>&nbsp;</td>
		<td align="center">
			$ <input type="text" class="minQ sminQ" name="OtherMin3Q" id="OtherMin3Q" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
			~ <input type="text" class="maxQ smaxQ" name="OtherMax3Q" id="OtherMax3Q" onkeypress='numCheck(event)' onchange="javascript: MaxCal();" readonly />
		</td>
		<td align="center">
			$ <input type="text" class="minS sminS" name="OtherMin3S" id="OtherMin3S" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
			~ <input type="text" class="maxS smaxS" name="OtherMax3S" id="OtherMax3S" onkeypress='numCheck(event)' onchange="javascript: MaxCal();" readonly />
		</td>
		<td align="center">
			$ <input type="text" class="minT sminT" name="OtherMin3T" id="OtherMin3T" onkeypress='numCheck(event)' onchange="javascript: MinCal();" readonly />
			~ <input type="text" class="maxT smaxT" name="OtherMax3T" id="OtherMax3T" onkeypress='numCheck(event)' onchange="javascript: MaxCal();" readonly />
		</td>
		<td align="center">
			$ <input type="text" class="input sMininput sinput" name="OtherMin3Input" id="OtherMin3Input" value="" onkeypress='numCheck(event)' onblur="javascript: numCheck2(this); InputCal();"/>
			~ <input type="text" class="input sMaxinput" name="OtherMax3Input" id="OtherMax3Input" value="" onkeypress='numCheck(event)' onblur="javascript: numCheck2(this); InputCal();"/>
		</td>
	</tr>
	<tr bgcolor='#FAFAD2'>
		<td align="right" colspan="2"><b>總計 Total: </b></td>
		<td align="center">
			$ <input type="text" name="totalMinQ" id="totalMinQ" readonly />
			~ <input type="text" name="totalMaxQ" id="totalMaxQ" readonly />
		</td>
		<td align="center">
			$ <input type="text" name="totalMinS" id="totalMinS" readonly />
			~ <input type="text" name="totalMaxS" id="totalMaxS" readonly />
		</td>
		<td align="center">
			$ <input type="text" name="totalMinT" id="totalMinT" readonly />
			~ <input type="text" name="totalMaxT" id="totalMaxT" readonly />
		</td>
		<td align="center">
			$ <input type="text" name="totalMinInput" id="totalMinInput" value="" readonly />
			~ <input type="text" name="totalMaxInput" id="totalMaxInput" value="" readonly />
		</td>
	</tr>
	<tr>
		<td colspan="7">
			<div style="margin:15px 0 10px 0; float:right;">
				<span id='leaflet'></span>
<%if (!isGP) { %>
				<input type="checkbox" id="showdate" name="showdate" value="Y" checked>Show Today Date &nbsp;
<%} %>
				<button type="button" id="confirm" name="confirm" style="font-size:15px;" onclick="printRPT();"/><b>Financial Estimation</b></button>
			</div>
		</td>
	</tr>
	<tr>
		<td colspan="7">
			<div style="margin:0; float:left;">
				<span id="version">.</span><br/>
				<span><font color="red">(1)</font> This report consisted of all the historical 'hospital charges' data for the attending doctor.<%if (ConstantsServerSide.isTWAH()) {%> Length of stay may not be reflected in the charges. Please refer to the historical report for detail.<%} %></span><br/>
				<span><font color="red">(2)</font> Package is developed basing on agreed care plan, agreed drug usage and specified Length of Stay.  For further information, please refer to the patient's leaflet.</span><br/>
				<span><font color="red">(3)</font> Please click 'Leaflet' for details of package for patient.</span><br/>
				<span><font color="red">(4)</font> Figures listed will be reviewed and improved annually.</span><br/>
				<span><font color="red">(5)</font> Please fill in the range of fees (i.e. two values), or one value (i.e. an amount) on the left box.</span><br/>
				<span>Best performance at Windows7 with Internet Explorer 9.0</span><br/>
			</div>
		</td>
	</tr>
	</table>

	<span id="showAdmission_indicator"></span>
	<span id="showProcedureFee_indicator"></span>
	<span id="showProcedurePackage_indicator"></span>
	<span id="showProcedureCode_indicator"></span>
	<span id="showBedFee_indicator"></span>
	<span id="showDoctorHistory_indicator"></span>
	<span id="showLeaflet_indicator"></span>

	<input type="hidden" name="doccode" value="<%=doccode==null?"":doccode %>">
	<input type="hidden" name="regid" value="<%=regid==null?"":regid %>">
	</form>

	<div id="loading"><img src="../images/loadingAnimation.gif"/></div>
	<div id="loadingRef"><img src="../images/loadingAnimation.gif"/></div>

<script type="text/javascript">
<%if (ConstantsServerSide.SECURE_SERVER) { %>
if (this.window.name == 'title' || this.window.name == 'content' || this.window.name == 'bigcontent') {
	parent.location.href = "<%=request.getContextPath() %>/financialEstimate/financialEstimationRpt.jsp";
}
<%} %>
$(document).ready(function() {
	$("select").searchable({
		maxListSize: 1000,			// if list size are less than maxListSize, show them all
		maxMultiMatch: 1000,			// how many matching entries should be displayed
		exactMatch: false,			// Exact matching on search
		wildcards: true,			// Support for wildcard characters (*, ?)
		ignoreCase: true,			// Ignore case sensitivity
		latency: 200,				// how many millis to wait until starting search
		warnMultiMatch: 'top {0} matches ...',	// string to append to a list of entries cut short by maxMultiMatch
		warnNoMatch: 'no matches ...',		// string to show in the list when no entries match
		zIndex: 'auto'				// zIndex for elements generated by this plugin
	});
});

// demo functions
$(document).ready(function() {
	$("#value").html($("#DocSelect :selected").text() + " (VALUE: " + $("#DocSelect").val() + ")");
	$("select").change(function(){
		$("#value").html(this.options[this.selectedIndex].text + " (VALUE: " + this.value + ")");
	});
});

function modifySelect() {
	$("select").get(0).selectedIndex = 5;
}

function appendSelectOption(str) {
	$("select").append("<option value=\"" + str + "\">" + str + "</option>");
}

function applyOptions() {
	$("select").searchable({
		maxListSize: $("#maxListSize").val(),
		maxMultiMatch: $("#maxMultiMatch").val(),
		latency: $("#latency").val(),
		exactMatch: $("#exactMatch").get(0).checked,
		wildcards: $("#wildcards").get(0).checked,
		ignoreCase: $("#ignoreCase").get(0).checked
	});

	alert(
		"OPTIONS\n---------------------------\n" +
		"maxListSize: " + $("#maxListSize").val() + "\n" +
		"maxMultiMatch: " + $("#maxMultiMatch").val() + "\n" +
		"exactMatch: " + $("#exactMatch").get(0).checked + "\n"+
		"wildcards: " + $("#wildcards").get(0).checked + "\n" +
		"ignoreCase: " + $("#ignoreCase").get(0).checked + "\n" +
		"latency: " + $("#latency").val()
	);
}

<%if (ProcedureSelect1 != null) { %>
changeCode(document.getElementById("ProcedureSelect1"));
<%} %>

<%if (patno != null && patno.length() > 0) { %>
getPatName(document.getElementById("patno"));
<%} %>

function pageReload() {
	refresh = "true"
	location.reload();
}

function numCheck(evt) {
	var theEvent = evt || window.event;
	var key = theEvent.keyCode || theEvent.which;
	key = String.fromCharCode( key );
	var regex = /[0-9]/;
	if( !regex.test(key) ) {
		theEvent.returnValue = false;
		if(theEvent.preventDefault) theEvent.preventDefault();
	}
}

function numCheck2(self) {
	if (isNaN(self.value)) {
		alert("It is not a number!");
		self.value = "";
		self.focus();
	} else {
		InputCal();
	}
}

function InputCal() {
	var sum1 = 0;
	var sum2 = 0;

	document.getElementById("DrRndDaySumMin1").value = document.getElementById("DocRoundFeeMinInput").value * document.getElementById("DrRndDay1").value;
	document.getElementById("DrRndDaySumMax1").value = document.getElementById("DocRoundFeeMaxInput").value * document.getElementById("DrRndDay1").value;
	document.getElementById("DrRndDaySumMin2").value = document.getElementById("RoomChgMinInput").value * document.getElementById("DrRndDay2").value;
	document.getElementById("DrRndDaySumMax2").value = document.getElementById("RoomChgMaxInput").value * document.getElementById("DrRndDay2").value;

	var inputs1 = $(".sminQ");
	for (var i = 0; i < inputs1.length; i++) {
		if (!isNaN(Number($(inputs1[i]).val()))) {
			sum1 = sum1 + Number($(inputs1[i]).val());
		}
	}
	document.getElementById("totalMinQ").value = sum1;

	inputs2 = $(".smaxQ");
	for (var i = 0; i < inputs2.length; i++){
		if (!isNaN(Number($(inputs2[i]).val()))) {
			sum2 = sum2 + Number($(inputs2[i]).val());
		}
	}
	document.getElementById("totalMaxQ").value = sum2;

	sum1 = 0;
	sum2 = 0;

	inputs1 = $(".sminS");
	for (var i = 0; i < inputs1.length; i++) {
		if (!isNaN(Number($(inputs1[i]).val()))) {
			sum1 = sum1 + Number($(inputs1[i]).val());
		}
	}
	document.getElementById("totalMinS").value = sum1;

	inputs2 = $(".smaxS");
	for (var i = 0; i < inputs2.length; i++){
		if (!isNaN(Number($(inputs2[i]).val()))) {
			sum2 = sum2 + Number($(inputs2[i]).val());
		}
	}
	document.getElementById("totalMaxS").value = sum2;

	sum1 = 0;
	sum2 = 0;

	inputs1 = $(".sminT");
	for (var i = 0; i < inputs1.length; i++) {
		if (!isNaN(Number($(inputs1[i]).val()))) {
			sum1 = sum1 + Number($(inputs1[i]).val());
		}
	}
	document.getElementById("totalMinT").value = sum1;

	inputs2 = $(".smaxT");
	for (var i = 0; i < inputs2.length; i++){
		if (!isNaN(Number($(inputs2[i]).val()))) {
			sum2 = sum2 + Number($(inputs2[i]).val());
		}
	}
	document.getElementById("totalMaxT").value = sum2;

	sum1 = 0;
	sum2 = 0;

	inputs1 = $(".sMininput");
	for (var i = 0; i < inputs1.length; i++) {
		if (!isNaN(Number($(inputs1[i]).val()))) {
			sum1 = sum1 + Number($(inputs1[i]).val());
		}
	}
	document.getElementById("totalMinInput").value = sum1;

	inputs2 = $(".sMaxinput");
	for (var i = 0; i < inputs2.length; i++){
		if (!isNaN(Number($(inputs2[i]).val()))) {
			sum2 = sum2 + Number($(inputs2[i]).val());
		}
	}
	document.getElementById("totalMaxInput").value = sum2;
}

function InputAvg(val1, val2) {
	var val3;
	if (!isNaN(val1) && !isNaN(val2)) {
		val3 = (Number(val1) + Number(val2)) / 2;
	} else {
		val3 = 0;
	}
	return val3.toFixed(0);
}

function getPatName(patno) {
	document.getElementById("patname").readOnly = false;
	document.getElementById("patcname").readOnly = false;
	document.getElementById("patidno").readOnly = false;
	document.getElementById("patname").value = "";
	document.getElementById("patcname").value = "";
	document.getElementById("patidno").value = "";

	if (patno.value.length > 0) {
		$.ajax({
			type: "POST",
			url: "../registration/admission_hats.jsp",
			data: "patno=" + patno.value,
			success: function(values) {
			if (values != '') {
				$("#showAdmission_indicator").html(values);
				if (values.substring(0, 1) == 1) {
					document.getElementById("patname").value = document.frmEstimate.hats_patfname.value + ' ' + document.frmEstimate.hats_patgname.value;
					document.getElementById("patcname").value = document.frmEstimate.hats_patcname.value;
					if (document.frmEstimate.hats_patidno.value.length > 4) {
						document.getElementById("patidno").value = document.frmEstimate.hats_patidno.value.substring(0, 4) + "XXX(X)";
					}
					document.getElementById("patname").readOnly = true;
					document.getElementById("patcname").readOnly = true;
					document.getElementById("patidno").readOnly = true;
				} else {
					alert('Patient not found.');
					patno.value = '';
				}
			}//if
			$("#showAdmission_indicator").html("");
			}//success
		});//$.ajax
	}
}

function changeCode(proc, proc2) {
	$.ajax({
		type: "POST",
		url: "procedureCMB.jsp",
		data: "procedure1=" + proc.value + "&procedure2=" + proc2,
		success: function(values) {
		if (values != '') {
			$("#ProcedureSelect2_indicator").html("<select name='ProcedureSelect2' id='ProcedureSelect2' onchange='return changeCode2(this);'>" + values + "</select>");

			checkPackageCode(document.getElementById("ProcedureSelect2"));
		} else {
			$("#ProcedureSelect2_indicator").html("");
		}//if
		}//success
	});//$.ajax

<%	if (ConstantsServerSide.isHKAH()) {%>
	$("#ProcedureRange_indicator").html("");
<%	}%>
}

function changeCode2(proc) {
	clearAll();
	clearInput();

	changeBed(document.getElementById("acmSelect"), false);

	checkPackageCode(proc);

	changePackage(proc);
}

function checkPackageCode(proc) {
	var procSelect2 = $("#ProcedureSelect2_indicator").html();
	var proc2Text;
	if (procSelect2.length > 0) {
		proc2Text = proc.options[proc.selectedIndex].text;
//		if (proc2Text.indexOf("Package") > 0 || proc2Text.indexOf("package") > 0) {
			$.ajax({
				type: "POST",
				url: "procedurePackage.jsp",
				data: "procedure=" + proc.value,
				success: function(values) {
				if (values != '') {
					$("#showProcedurePackage_indicator").html(values);

					if (document.frmEstimate.hats_PackageAcmCode.value != '--' && document.frmEstimate.hats_PackageAcmCode.value != '-1') {
						document.getElementById("acmSelect").value = document.frmEstimate.hats_PackageAcmCode.value;
						changeBed(document.getElementById("acmSelect"), false);
					}
					if (document.frmEstimate.hats_PackageLOS.value != '--' && document.frmEstimate.hats_PackageLOS.value != '-1') {
						document.getElementById("DaySelect").value = document.frmEstimate.hats_PackageLOS.value;
						changeDay();
					}
					refFunction(false);
				} else {
					$("#showProcedurePackage_indicator").html("");
				}//if
				}//success
			});//$.ajax
//		} else {
//			if (document.getElementById("acmSelect").selectedIndex!="0"
//					&& document.getElementById("acmSelect").selectedIndex!="-1"
//					&& document.getElementById("DaySelect").selectedIndex!="0"
//					&& document.getElementById("DaySelect").selectedIndex!="-1") {
//				refFunction(false);
//			}
//		}
	}
}

function changePackage(proc) {
	document.getElementById("DrRndDay1").style.display = 'block';
	document.getElementById("DrRndDay2").style.display = 'block';

//	var procSelect2 = $("#ProcedureSelect2_indicator").html();
//	var proc2Text;
//	if (procSelect2.length > 0) {
//		proc2Text = proc.options[proc.selectedIndex].text;
//		if (proc2Text.indexOf("Package") > 0) {
//			document.getElementById("DrRndDay1").value = '1';
//			document.getElementById("DrRndDay2").value = '1';
//			document.getElementById("DrRndDay1").style.display = 'none';
//			document.getElementById("DrRndDay2").style.display = 'none';
//		}
//	}
	changeDay();
}

function changeDay() {
	document.getElementById("DrRndDay1").value =
		document.getElementById("DaySelect").options[document.getElementById("DaySelect").selectedIndex].value;
	document.getElementById("DrRndDay2").value =
		document.getElementById("DaySelect").options[document.getElementById("DaySelect").selectedIndex].value;

	clearAll();

	InputCal();
}

function changeBed(bed, callref) {
	$.ajax({
		type: "POST",
		url: "roomFee.jsp",
		data: "acmcode=" + bed.value,
		success: function(values) {
		if (values != '') {
			$("#showBedFee_indicator").html(values);
			document.getElementById("RoomChgMinInput").value = document.frmEstimate.hats_RoomChgMin.value;
			document.getElementById("RoomChgMaxInput").value = document.frmEstimate.hats_RoomChgMax.value;
			InputCal();

			if (callref) {
				refFunction(false);
			}
		}//if
		$("#showBedFee_indicator").html("");
		}//success
	});//$.ajax

	clearAll();
}

function changeRange(acmcode, day) {
	document.getElementById("acmSelect").value = acmcode;
	changeBed(document.getElementById("acmSelect"), false);

	document.getElementById("DaySelect").value = day;
	changeDay();

	refFunction(false);
}

function changeCodeByOperationCode() {
	if (document.getElementById("ProcedureInput").value != "") {
		$.ajax({
			type: "POST",
			url: "procedureCode.jsp",
			data: "procedure=" + document.getElementById("ProcedureInput").value,
			success: function(values) {
			if (values != '') {
				$("#showProcedureCode_indicator").html(values);
				if (values.substring(0, 1) == 1) {
					document.getElementById("ProcedureSelect1").value = document.frmEstimate.hats_procedure1.value;
					changeCode(document.getElementById("ProcedureSelect1"), document.frmEstimate.hats_procedure2.value);
				} else {
					alert('Invalid hats code.');
					document.getElementById("ProcedureInput").focus();
				}
				document.getElementById("ProcedureInput").value = "";
			}//if
			$("#showProcedureCode_indicator").html("");
			}//success
		});//$.ajax

	}
}

function refFunction(errmsg) {
	var proc2Text;
	clearInput();

//	if (document.getElementById("DocSelect").selectedIndex=="0" || document.getElementById("DocSelect").selectedIndex=="-1" || document.getElementById("DocSelect").selectedIndex=="101") {
//		alert("Please select Doctor.");
//		document.getElementById('DocSelect').focus();
//		return;
	if (document.getElementById("ProcedureSelect1").selectedIndex=="0" || document.getElementById("ProcedureSelect1").selectedIndex=="-1" || document.getElementById("ProcedureSelect1").selectedIndex=="101") {
		alert("Please select Procedure.");
		document.getElementById('ProcedureSelect1').focus();
		return;
	} else if (document.getElementById("acmSelect").selectedIndex=="0" || document.getElementById("acmSelect").selectedIndex=="-1") {
		alert("Please select class.");
		document.getElementById('acmSelect').focus();
		return;
	}

	$( "#loadingRef" ).show();

	$.ajax({
		type: "POST",
		url: "procedureFee2.jsp",
		data: "doccode=" + document.getElementById("DocSelect").value +
			"&procedure=" + document.getElementById("ProcedureSelect2").value +
			"&day=" + document.getElementById("DaySelect").value +
			"&acmcode=" + document.getElementById("acmSelect").value,
		success: function(values) {
		if (values != '') {
			$("#showProcedureFee_indicator").html(values);
			if (values.substring(0, 1) == 1) {
				document.getElementById("OTMinQ").value = document.frmEstimate.hats_OTMinQ.value;
				document.getElementById("OTMaxQ").value = document.frmEstimate.hats_OTMaxQ.value;
				document.getElementById("OtherMin3Q").value = document.frmEstimate.hats_OtherMin3Q.value;
				document.getElementById("OtherMax3Q").value = document.frmEstimate.hats_OtherMax3Q.value;

				if (document.frmEstimate.hats_RMMinS.value != '--') {
					document.getElementById("RoomChgMinS").value = document.frmEstimate.hats_RMMinS.value;
				} else {
					document.getElementById("RoomChgMinS").value = '';
				}
				if (document.frmEstimate.hats_RMMaxS.value != '--') {
					document.getElementById("RoomChgMaxS").value = document.frmEstimate.hats_RMMaxS.value;
				} else {
					document.getElementById("RoomChgMaxS").value = '';
				}
				document.getElementById("OTMinS").value = document.frmEstimate.hats_OTMinS.value;
				document.getElementById("OTMaxS").value = document.frmEstimate.hats_OTMaxS.value;
				document.getElementById("OtherMin3S").value = document.frmEstimate.hats_OtherMin3S.value;
				document.getElementById("OtherMax3S").value = document.frmEstimate.hats_OtherMax3S.value;

				if (document.frmEstimate.hats_RMMinT.value != '--') {
					document.getElementById("RoomChgMinT").value = document.frmEstimate.hats_RMMinT.value;
				} else {
					document.getElementById("RoomChgMinT").value = '';
				}
				if (document.frmEstimate.hats_RMMaxT.value != '--') {
					document.getElementById("RoomChgMaxT").value = document.frmEstimate.hats_RMMaxT.value;
				} else {
					document.getElementById("RoomChgMaxT").value = '';
				}
				document.getElementById("OTMinT").value = document.frmEstimate.hats_OTMinT.value;
				document.getElementById("OTMaxT").value = document.frmEstimate.hats_OTMaxT.value;
				document.getElementById("OtherMin3T").value = document.frmEstimate.hats_OtherMin3T.value;
				document.getElementById("OtherMax3T").value = document.frmEstimate.hats_OtherMax3T.value;

				document.getElementById("DocRoundFeeMinS").value = document.frmEstimate.hats_DocMinS.value;
				document.getElementById("DocRoundFeeMaxS").value = document.frmEstimate.hats_DocMaxS.value;
				document.getElementById("ProFeeMinS").value = document.frmEstimate.hats_SurgicalMinS.value;
				document.getElementById("ProFeeMaxS").value = document.frmEstimate.hats_SurgicalMaxS.value;
				document.getElementById("AnaesthetistFeeMinS").value = document.frmEstimate.hats_AnaesthetistMinS.value;
				document.getElementById("AnaesthetistFeeMaxS").value = document.frmEstimate.hats_AnaesthetistMaxS.value;
				document.getElementById("OtherMin1S").value = document.frmEstimate.hats_OtherMin1S.value;
				document.getElementById("OtherMax1S").value = document.frmEstimate.hats_OtherMax1S.value;
				document.getElementById("OtherMin2S").value = document.frmEstimate.hats_OtherMin2S.value;
				document.getElementById("OtherMax2S").value = document.frmEstimate.hats_OtherMax2S.value;

//				document.getElementById("chartBtn1").style.visibility = "visible";
//				document.getElementById("chartBtn2").style.visibility = "visible";
//				document.getElementById("chartBtn3").style.visibility = "visible";
//				document.getElementById("chartBtn4").style.visibility = "visible";
//				document.getElementById("chartBtn5").style.visibility = "visible";

				InputCal();

				proc2Text = document.getElementById("ProcedureSelect2").options[document.getElementById("ProcedureSelect2").selectedIndex].text;
				if (proc2Text.indexOf("Package") > 0 || proc2Text.indexOf("package") > 0) {
					copy2Input('3');
				}
			} else if (errmsg) {
				alert('No data.');
			}
		}//if
		$("#showProcedureFee_indicator").html("");
		}//success
	});//$.ajax

	$( "#loadingRef" ).hide();
}

function printRPT() {
	if (document.getElementById("patno").value=="" && document.getElementById("patname").value=="") {
		alert('Patient not found.');
		document.getElementById('patno').focus();
		return;
//	} else if (document.getElementById("DocSelect").selectedIndex=="0" || document.getElementById("DocSelect").selectedIndex=="-1" || document.getElementById("DocSelect").selectedIndex=="101") {
//		alert("Please select Doctor.");
//		document.getElementById('DocSelect').focus();
//		return;
	} else if (document.getElementById("ProcedureSelect1").selectedIndex=="0" || document.getElementById("ProcedureSelect1").selectedIndex=="-1" || document.getElementById("ProcedureSelect1").selectedIndex=="101") {
		alert("Please select Procedure.");
		document.getElementById('ProcedureSelect1').focus();
		return;
	} else if (document.getElementById("acmSelect").selectedIndex=="0" || document.getElementById("acmSelect").selectedIndex=="-1") {
		alert("Please select class.");
		document.getElementById('acmSelect').focus();
		return;
	}

	if (document.getElementById("DocRoundFeeMinInput").value == "" && document.getElementById("DocRoundFeeMaxInput").value != "") {
		document.getElementById("DocRoundFeeMinInput").value = document.getElementById("DocRoundFeeMaxInput").value;
	}
	if (document.getElementById("DocRoundFeeMinInput").value != "" && document.getElementById("DocRoundFeeMaxInput").value == "") {
		document.getElementById("DocRoundFeeMaxInput").value = document.getElementById("DocRoundFeeMinInput").value;
	}
	if (document.getElementById("RoomChgMinInput").value == "" && document.getElementById("RoomChgMaxInput").value != "") {
		document.getElementById("RoomChgMinInput").value = document.getElementById("RoomChgMaxInput").value;
	}
	if (document.getElementById("RoomChgMinInput").value != "" && document.getElementById("RoomChgMaxInput").value == "") {
		document.getElementById("RoomChgMaxInput").value = document.getElementById("RoomChgMinInput").value;
	}
	if (document.getElementById("ProFeeMinInput").value == "" && document.getElementById("ProFeeMaxInput").value != "") {
		document.getElementById("ProFeeMinInput").value = document.getElementById("ProFeeMaxInput").value;
	}
	if (document.getElementById("ProFeeMinInput").value != "" && document.getElementById("ProFeeMaxInput").value == "") {
		document.getElementById("ProFeeMaxInput").value = document.getElementById("ProFeeMinInput").value;
	}
	if (document.getElementById("AnaesthetistFeeMinInput").value == "" && document.getElementById("AnaesthetistFeeMaxInput").value != "") {
		document.getElementById("AnaesthetistFeeMinInput").value = document.getElementById("AnaesthetistFeeMaxInput").value;
	}
	if (document.getElementById("AnaesthetistFeeMinInput").value != "" && document.getElementById("AnaesthetistFeeMaxInput").value == "") {
		document.getElementById("AnaesthetistFeeMaxInput").value = document.getElementById("AnaesthetistFeeMinInput").value;
	}
	if (document.getElementById("OtherMin1Input").value == "" && document.getElementById("OtherMax1Input").value != "") {
		document.getElementById("OtherMin1Input").value = document.getElementById("OtherMax1Input").value;
	}
	if (document.getElementById("OtherMin1Input").value != "" && document.getElementById("OtherMax1Input").value == "") {
		document.getElementById("OtherMax1Input").value = document.getElementById("OtherMin1Input").value;
	}
	if (document.getElementById("OtherMin2Input").value == "" && document.getElementById("OtherMax2Input").value != "") {
		document.getElementById("OtherMin2Input").value = document.getElementById("OtherMax2Input").value;
	}
	if (document.getElementById("OtherMin2Input").value != "" && document.getElementById("OtherMax2Input").value == "") {
		document.getElementById("OtherMax2Input").value = document.getElementById("OtherMin2Input").value;
	}
	if (document.getElementById("OTMinInput").value == "" && document.getElementById("OTMaxInput").value != "") {
		document.getElementById("OTMinInput").value = document.getElementById("OTMaxInput").value;
	}
	if (document.getElementById("OTMinInput").value != "" && document.getElementById("OTMaxInput").value == "") {
		document.getElementById("OTMaxInput").value = document.getElementById("OTMinInput").value;
	}
	if (document.getElementById("OtherMin3Input").value == "" && document.getElementById("OtherMax3Input").value != "") {
		document.getElementById("OtherMin3Input").value = document.getElementById("OtherMax3Input").value;
	}
	if (document.getElementById("OtherMin3Input").value != "" && document.getElementById("OtherMax3Input").value == "") {
		document.getElementById("OtherMax3Input").value = document.getElementById("OtherMin3Input").value;
	}

	InputCal();

	document.getElementById('frmEstimate').action = 'financialEstimation_HTMLreport_jasper.jsp';
	document.getElementById('loading').style.display = 'block';
	document.getElementById('loading').style.display = 'none';
	document.getElementById("frmEstimate").submit();
}

function ReplaceURL(A) {
	if(A == '') {
		return '';
	} else {
		return A.replace(/\%/gi, '%25').replace(/&/gi, '%26').replace(/\+/gi, '%2B').replace(/\ /gi, '%20').replace(/\//gi, '%2F').replace(/\#/gi, '%23').replace(/\=/gi, '%3D');
	}
}

function openiFrame(code) {
	var doccode = document.getElementById("DocSelect").value;
	var procedure1 = document.getElementById('ProcedureSelect1').value;
	var procedure2 = document.getElementById('ProcedureSelect2').value;
	var acmcode = document.getElementById("acmSelect").value;

	document.getElementById('mask').style.display='block';
	document.getElementById('loading').style.display='block';
	document.getElementById('chart').style.display='block';
	document.getElementById('chart').src = "financialEstimationChart_byRmClass.jsp?doccode="+doccode+"&procedure1="+ReplaceURL(procedure1)+"&procedure2="+ReplaceURL(procedure2)+"&procedure2="+ReplaceURL(procedure2)+"&procedure2="+ReplaceURL(procedure2)+"&code="+code+"&acmcode="+acmcode+"&rnd="+Math.random();
	document.getElementById('chart').setAttribute("background-color", "#ffffff");
	document.getElementById('chart').style.backgroundColor="#ffffff";
}

function copy2Input(type) {
	if (type == '2') {
		if (document.getElementById("OTMinQ").value != '--') {
			document.getElementById("OTMinInput").value = document.getElementById("OTMinQ").value;
		} else {
			document.getElementById("OTMinInput").value = 0;
		}
		if (document.getElementById("OTMaxQ").value != '--') {
			document.getElementById("OTMaxInput").value = document.getElementById("OTMaxQ").value;
		} else {
			document.getElementById("OTMaxInput").value = 0;
		}
		if (document.getElementById("OtherMin3Q").value != '--') {
			document.getElementById("OtherMin3Input").value = document.getElementById("OtherMin3Q").value;
		} else {
			document.getElementById("OtherMin3Input").value = 0;
		}
		if (document.getElementById("OtherMax3Q").value != '--') {
			document.getElementById("OtherMax3Input").value = document.getElementById("OtherMax3Q").value;
		} else {
			document.getElementById("OtherMax3Input").value = 0;
		}
	} else if (type == '3') {
		if (document.getElementById("DocRoundFeeMinS").value != '--') {
			document.getElementById("DocRoundFeeMinInput").value = document.getElementById("DocRoundFeeMinS").value;
		} else if (document.getElementById("DocRoundFeeMinInput").length == 0) {
			document.getElementById("DocRoundFeeMinInput").value = 0;
		}
		if (document.getElementById("DocRoundFeeMaxS").value != '--') {
			document.getElementById("DocRoundFeeMaxInput").value = document.getElementById("DocRoundFeeMaxS").value;
		} else if (document.getElementById("DocRoundFeeMaxInput").length == 0) {
			document.getElementById("DocRoundFeeMaxInput").value = 0;
		}
		if (document.getElementById("ProFeeMinS").value != '--') {
			document.getElementById("ProFeeMinInput").value = document.getElementById("ProFeeMinS").value;
		} else {
			document.getElementById("ProFeeMinInput").value = 0;
		}
		if (document.getElementById("ProFeeMaxS").value != '--') {
			document.getElementById("ProFeeMaxInput").value = document.getElementById("ProFeeMaxS").value;
		} else {
			document.getElementById("ProFeeMaxInput").value = 0;
		}
		if (document.getElementById("AnaesthetistFeeMinS").value != '--') {
			document.getElementById("AnaesthetistFeeMinInput").value = document.getElementById("AnaesthetistFeeMinS").value;
		} else {
			document.getElementById("AnaesthetistFeeMinInput").value = 0;
		}
		if (document.getElementById("AnaesthetistFeeMaxS").value != '--') {
			document.getElementById("AnaesthetistFeeMaxInput").value = document.getElementById("AnaesthetistFeeMaxS").value;
		} else {
			document.getElementById("AnaesthetistFeeMaxInput").value = 0;
		}
		if (document.getElementById("OtherMin1S").value != '--') {
			document.getElementById("OtherMin1Input").value = document.getElementById("OtherMin1S").value;
		} else {
			document.getElementById("OtherMin1Input").value = 0;
		}
		if (document.getElementById("OtherMax1S").value != '--') {
			document.getElementById("OtherMax1Input").value = document.getElementById("OtherMax1S").value;
		} else {
			document.getElementById("OtherMax1Input").value = 0;
		}
		if (document.getElementById("OtherMin2S").value != '--') {
			document.getElementById("OtherMin2Input").value = document.getElementById("OtherMin2S").value;
		} else {
			document.getElementById("OtherMin2Input").value = 0;
		}
		if (document.getElementById("OtherMax2S").value != '--') {
			document.getElementById("OtherMax2Input").value = document.getElementById("OtherMax2S").value;
		} else {
			document.getElementById("OtherMax2Input").value = 0;
		}
		if (document.getElementById("RoomChgMinS").value != '--') {
			document.getElementById("RoomChgMinInput").value = document.getElementById("RoomChgMinS").value;
		} else {
			document.getElementById("RoomChgMinInput").value = 0;
		}
		if (document.getElementById("RoomChgMaxS").value != '--') {
			document.getElementById("RoomChgMaxInput").value = document.getElementById("RoomChgMaxS").value;
		} else {
			document.getElementById("RoomChgMaxInput").value = 0;
		}
		if (document.getElementById("OTMinS").value != '--') {
			document.getElementById("OTMinInput").value = document.getElementById("OTMinS").value;
		} else {
			document.getElementById("OTMinInput").value = 0;
		}
		if (document.getElementById("OTMaxS").value != '--') {
			document.getElementById("OTMaxInput").value = document.getElementById("OTMaxS").value;
		} else {
			document.getElementById("OTMaxInput").value = 0;
		}
		if (document.getElementById("OtherMin3S").value != '--') {
			document.getElementById("OtherMin3Input").value = document.getElementById("OtherMin3S").value;
		} else {
			document.getElementById("OtherMin3Input").value = 0;
		}
		if (document.getElementById("OtherMax3S").value != '--') {
			document.getElementById("OtherMax3Input").value = document.getElementById("OtherMax3S").value;
		} else {
			document.getElementById("OtherMax3Input").value = 0;
		}
	} else if (type == '4') {
		if (document.getElementById("RoomChgMinT").value != '--') {
			document.getElementById("DrRndDaySumMin2").value = document.getElementById("RoomChgMinT").value;
		} else {
			document.getElementById("DrRndDaySumMin2").value = 0;
		}
		if (document.getElementById("RoomChgMaxT").value != '--') {
			document.getElementById("DrRndDaySumMax2").value = document.getElementById("RoomChgMaxT").value;
		} else {
			document.getElementById("DrRndDaySumMax2").value = 0;
		}
		if (document.getElementById("OTMinT").value != '--') {
			document.getElementById("OTMinInput").value = document.getElementById("OTMinT").value;
		} else {
			document.getElementById("OTMinInput").value = 0;
		}
		if (document.getElementById("OTMaxT").value != '--') {
			document.getElementById("OTMaxInput").value = document.getElementById("OTMaxT").value;
		} else {
			document.getElementById("OTMaxInput").value = 0;
		}
		if (document.getElementById("OtherMin3T").value != '--') {
			document.getElementById("OtherMin3Input").value = document.getElementById("OtherMin3T").value;
		} else {
			document.getElementById("OtherMin3Input").value = 0;
		}
		if (document.getElementById("OtherMax3T").value != '--') {
			document.getElementById("OtherMax3Input").value = document.getElementById("OtherMax3T").value;
		} else {
			document.getElementById("OtherMax3Input").value = 0;
		}
	}

	InputCal();
}

function viewHistory() {
	$("#showDoctorHistory_indicator").html("");

	if (document.getElementById("DocSelect").selectedIndex=="0" || document.getElementById("DocSelect").selectedIndex=="-1" || document.getElementById("DocSelect").selectedIndex=="101") {
		alert("Please select Doctor.");
		document.getElementById('DocSelect').focus();
<%	if (doccode != null && doccode.length() > 0) { %>
	} else if (document.getElementById("DocSelect").value != '<%=doccode %>') {
		alert("Please select your Doctor Name.");
		document.getElementById('DocSelect').focus();
<%	} %>
	} else if (document.getElementById("ProcedureSelect1").selectedIndex=="0" || document.getElementById("ProcedureSelect1").selectedIndex=="-1" || document.getElementById("ProcedureSelect1").selectedIndex=="101") {
		alert("Please select Procedure.");
		document.getElementById('ProcedureSelect1').focus();
	} else {
		$.ajax({
			type: "POST",
			url: "doctorHistoryCheck.jsp",
			data: "doccode=" + document.getElementById("DocSelect").value + "&procedure=" + document.getElementById("ProcedureSelect2").value,
			success: function(values) {
			if (values != '') {
				$("#showDoctorHistory_indicator").html(values);
				if (document.getElementById("hats_doctorHistory").value != "0") {
					document.getElementById('frmEstimate').action = 'doctorHistory_jasper.jsp';
					document.getElementById("frmEstimate").submit();
				} else {
					alert('No data.');
				}
			} else {
				alert('No data.');
			}//if
			$("#showDoctorHistory_indicator").html("");
			}//success
		});//$.ajax
	}
	return;
}

function viewLeaflet() {
	$("#showLeaflet_indicator").html("");

	if (document.getElementById("ProcedureSelect1").selectedIndex=="0" || document.getElementById("ProcedureSelect1").selectedIndex=="-1" || document.getElementById("ProcedureSelect1").selectedIndex=="101") {
		alert("Please select Procedure.");
	} else {
		$.ajax({
			type: "POST",
			url: "procedureLeaflet.jsp",
			data: "procedure=" + document.getElementById("ProcedureSelect2").value,
			success: function(values) {
			if (values != '') {
				$("#showLeaflet_indicator").html(values);
				if (document.getElementById("hats_leaflet").value.length > 0) {
					window.open(document.getElementById("hats_leaflet").value);
				} else {
					alert('Not available.');
				}
			} else {
				alert('Not available.');
			}//if
			$("#showLeaflet_indicator").html("");
			}//success
		});//$.ajax
	}
	return;
}

function clearDocInput() {
<%	if (isFreeTextDoc) { %>
	document.getElementById("DocInput").value = "";
<%	} %>
}

function clearDocSelect() {
	if (document.getElementById("DocInput").value != "") {
		document.getElementById("DocSelect").selectedIndex = 0;
	}
}

function clearAll() {
	clearQ();
	clearS();
	clearT();
}

function clearQ() {
	document.getElementById("DocRoundFeeMinQ").value = "";
	document.getElementById("DocRoundFeeMaxQ").value = "";
	document.getElementById("ProFeeMinQ").value = "";
	document.getElementById("ProFeeMaxQ").value = "";
	document.getElementById("AnaesthetistFeeMinQ").value = "";
	document.getElementById("AnaesthetistFeeMaxQ").value = "";
	document.getElementById("RoomChgMinQ").value = "";
	document.getElementById("RoomChgMaxQ").value = "";
	document.getElementById("OTMinQ").value = "";
	document.getElementById("OTMaxQ").value = "";
	document.getElementById("OtherMin1Q").value = "";
	document.getElementById("OtherMax1Q").value = "";
	document.getElementById("OtherMin2Q").value = "";
	document.getElementById("OtherMax2Q").value = "";
	document.getElementById("OtherMin3Q").value = "";
	document.getElementById("OtherMax3Q").value = "";
	document.getElementById("totalMinQ").value = "";
	document.getElementById("totalMaxQ").value = "";
}

function clearS() {
	document.getElementById("DocRoundFeeMinS").value = "";
	document.getElementById("DocRoundFeeMaxS").value = "";
	document.getElementById("ProFeeMinS").value = "";
	document.getElementById("ProFeeMaxS").value = "";
	document.getElementById("AnaesthetistFeeMinS").value = "";
	document.getElementById("AnaesthetistFeeMaxS").value = "";
	document.getElementById("RoomChgMinS").value = "";
	document.getElementById("RoomChgMaxS").value = "";
	document.getElementById("OTMinS").value = "";
	document.getElementById("OTMaxS").value = "";
	document.getElementById("OtherMin1S").value = "";
	document.getElementById("OtherMax1S").value = "";
	document.getElementById("OtherMin2S").value = "";
	document.getElementById("OtherMax2S").value = "";
	document.getElementById("OtherMin3S").value = "";
	document.getElementById("OtherMax3S").value = "";
	document.getElementById("totalMinS").value = "";
	document.getElementById("totalMaxS").value = "";
}

function clearT() {
	document.getElementById("DocRoundFeeMinT").value = "";
	document.getElementById("DocRoundFeeMaxT").value = "";
	document.getElementById("ProFeeMinT").value = "";
	document.getElementById("ProFeeMaxT").value = "";
	document.getElementById("AnaesthetistFeeMinT").value = "";
	document.getElementById("AnaesthetistFeeMaxT").value = "";
	document.getElementById("RoomChgMinT").value = "";
	document.getElementById("RoomChgMaxT").value = "";
	document.getElementById("OTMinT").value = "";
	document.getElementById("OTMaxT").value = "";
	document.getElementById("OtherMin1T").value = "";
	document.getElementById("OtherMax1T").value = "";
	document.getElementById("OtherMin2T").value = "";
	document.getElementById("OtherMax2T").value = "";
	document.getElementById("OtherMin3T").value = "";
	document.getElementById("OtherMax3T").value = "";
	document.getElementById("totalMinT").value = "";
	document.getElementById("totalMaxT").value = "";
}

function clearInput() {
	document.getElementById("DocRoundFeeMinInput").value = '';
	document.getElementById("DocRoundFeeMaxInput").value = '';
	document.getElementById("ProFeeMinInput").value = '';
	document.getElementById("ProFeeMaxInput").value = '';
	document.getElementById("AnaesthetistFeeMinInput").value = '';
	document.getElementById("AnaesthetistFeeMaxInput").value = '';
	document.getElementById("OTMinInput").value = '';
	document.getElementById("OTMaxInput").value = '';
	document.getElementById("OtherMin1Input").value = '';
	document.getElementById("OtherMax1Input").value = '';
	document.getElementById("OtherMin2Input").value = '';
	document.getElementById("OtherMax2Input").value = '';
	document.getElementById("OtherMin3Input").value = '';
	document.getElementById("OtherMax3Input").value = '';
	document.getElementById("totalMinInput").value = '';
	document.getElementById("totalMaxInput").value = '';
}

$("#ProFeeMaxInput").blur(function (e) {
	if (parseInt(document.getElementById('ProFeeMinInput').value) > parseInt(document.getElementById('ProFeeMaxInput').value)) {
		alert("Invalid Surgical Fee Range.");
		document.getElementById('ProFeeMaxInput').value = ""
		InputCal();
	}
});

$("#AnaesthetistFeeMaxInput").blur(function (e) {
	if (parseInt(document.getElementById('AnaesthetistFeeMinInput').value) > parseInt(document.getElementById('AnaesthetistFeeMaxInput').value)) {
		alert("Invalid Anaesthetist Fee Range.");
		document.getElementById('AnaesthetistFeeMaxInput').value = ""
		InputCal();
	}
});

$("#OtherMax1Input").blur(function (e) {
	if (parseInt(document.getElementById('OtherMin1Input').value) > parseInt(document.getElementById('OtherMax1Input').value)) {
		alert("Invalid Other Specialists' Consultation Fee Range.");
		document.getElementById('OtherMax1Input').value = ""
		InputCal();
	}
});

$("#OtherMax2Input").blur(function (e) {
	if (parseInt(document.getElementById('OtherMin2Input').value) > parseInt(document.getElementById('OtherMax2Input').value)) {
		alert("Invalid Other Items and Charges Range.");
		document.getElementById('OtherMax2Input').value = ""
		InputCal();
	}
});

$("#OTMaxInput").blur(function (e) {
	if (parseInt(document.getElementById('OTMinInput').value) > parseInt(document.getElementById('OTMaxInput').value)) {
		alert("Invalid Operating Theatre and Associated Materials Charges Range.");
		document.getElementById('OTMaxInput').value = ""
		InputCal();
	}
});

$("#OtherMax3Input").blur(function (e) {
	if (parseInt(document.getElementById('OtherMin3Input').value) > parseInt(document.getElementById('OtherMax3Input').value)) {
		alert("Invalid Other Hospital Charges Range.");
		document.getElementById('OtherMax3Input').value = ""
		InputCal();
	}
});

</script>
<style>
body {
	 font-family:Arial;
	 width:980px;
	 size:9px;
	 line-height:1.7;
	 margin-top:0;
	 padding-top:0;
}

#bgLayer {
	z-index: 0;
	position: absolute;
	maring:0;
	width: 100%;
	height: 100%;
	top: 0;
	left: 0;
}

#mask {
	z-index: 200;
	position: absolute;
	background-color: #ffffff;
	maring:0;
	width: 100%;
	height: 100%;
	top: 0;
	left: 0;
	opacity: 0.4;
	filter: alpha(opacity=40);
	display:none;
}

td {
	font-size: 12px;
}

#chartWrap {
	position: absolute;
	z-index: 967;
	margin-left: -430px;
}

#loading, #loadingRef {
	display:none;
	z-index: 2000;
	position: absolute;
	top: 360px;
	left: 400px;
}

.groupD {
	width: 18px;
	margin-left: 3px;
	top: 4px;
	position: relative;
	display: none;
}
#procedureGroup {
	position: absolute;
	display:none;
	z-index: 30;
	width: 577px;
}
#btn_closeProcedureGroup {
	position: relative;
	float: right;
	display: inline;
	margin-left:2px;
}

#btnPackage {
	position: relative;
	margin-bottom: -20px;
	font-size: 0.9em;
}


#patno, #patname, #patcname, #patidno {
	width: 60%;
}

#DrRndDay1, #DrRndDay2, .minP, .maxP, .minQ, .maxQ, .minS, .maxS, .minT, .maxT, #totalMinP, #totalMaxP, #totalMinQ, #totalMaxQ, #totalMinS, #totalMaxS, #totalMinT, #totalMaxT, #stotalMinP, #stotalMaxP, #stotalMinQ, #stotalMaxQ, #stotalMinS, #stotalMaxS, #stotalMinT, #stotalMaxT  {
border:0;
}
.minP, .maxP, .minQ, .maxQ, .minS, .maxS, .minT, .maxT, #totalMinP, #totalMaxP, #totalMinQ, #totalMaxQ, #totalMinS, #totalMaxS, #totalMinT, #totalMaxT, #stotalMinP, #stotalMaxP, #stotalMinQ, #stotalMaxQ, #stotalMinS, #stotalMaxS, #stotalMinT, #stotalMaxT  {
	width:50px;
}
.input, #DrRndInput, #totalMinInput, #totalMaxInput, #stotalInput, #DocRoundFeeMinInput, #DocRoundFeeMaxInput, #RoomChgMinInput, #RoomChgMaxInput {
	width:50px;
	z-index:100;
}
img:hover {
	cursor: hand;
}

.ProcedureSelect {
	min-width: 555px;
	max-width: 680px;
	z-index: 200;
}

.pointer {
	cursor:pointer;
	color: #0000FF;
}

#version {
	color: #666666;
}
</style>
</body>
</html:html>
<%
} else {
%>
<script type="text/javascript">
	alert('Access Denied.');
	window.close();
</script>
<%
}
%>