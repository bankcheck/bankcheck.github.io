<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="org.displaytag.tags.*"%>
<%@ page import="org.displaytag.util.*"%>
<%@ page import="org.apache.poi.ss.usermodel.Workbook"%>
<%@ page import="org.apache.log4j.Logger"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook"%>
<%@ page import="org.apache.poi.ss.usermodel.Cell"%>
<%@ page import="org.apache.poi.ss.usermodel.CellStyle"%>
<%@ page import="org.apache.poi.ss.usermodel.CreationHelper"%>
<%@ page import="org.apache.poi.ss.usermodel.DataFormat"%>
<%@ page import="org.apache.poi.ss.usermodel.Font"%>
<%@ page import="org.apache.poi.ss.usermodel.IndexedColors"%>
<%@ page import="org.apache.poi.ss.usermodel.Row"%>
<%@ page import="org.apache.poi.ss.usermodel.Sheet"%>
<%@ page import="org.apache.poi.ss.usermodel.Workbook"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFSheet"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFRow"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFCell"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFCellStyle"%>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFChart"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%!
	private String getResponsiblePartyHighlight(UserBean userBean, boolean IsPIManager, String[] responsibleParty, String pirid) {
		String staffName = null;
		boolean isSelf = false;
		StringBuffer strBuf = new StringBuffer();
		boolean showButton = IsPIManager && !"piuser".equals(userBean.getLoginID());
		for (int i = 0; i < responsibleParty.length; i++) {
			staffName = StaffDB.getStaffName(responsibleParty[i]);
			if (staffName == null) {
				staffName = responsibleParty[i];
			}
			isSelf = responsibleParty[i].equals(userBean.getStaffID());

			if (!showButton && strBuf.length() > 0) {
				strBuf.append(ConstantsVariable.COMMA_VALUE);
				strBuf.append(ConstantsVariable.SPACE_VALUE);
			}
			if (isSelf) {
				strBuf.append("<font color='red'>");
			} else {
				strBuf.append("<font color='green'>");
			}

			if (showButton) {
				strBuf.append("<button onclick=\"return emailAlert('");
				strBuf.append(pirid);
				strBuf.append("','");
				strBuf.append(responsibleParty[i]);
				strBuf.append("');\">");
				strBuf.append(staffName);
				strBuf.append("</button>");
			} else {
				strBuf.append(staffName);
			}
			strBuf.append("</font>");
		}
		return strBuf.toString();
	}
%>
<%
String command = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "command"));
UserBean userBean = new UserBean(request);
String incident_date_from = request.getParameter("incident_date_from");
String incident_date_to = request.getParameter("incident_date_to");
String report_date_from = request.getParameter("report_date_from");
String report_date_to = request.getParameter("report_date_to");
String classification = request.getParameter("classification");
String status = request.getParameter("status");
String nearmiss = request.getParameter("nearmiss");
String hazardousContition = request.getParameter("hazardousContition");
String ceopend = request.getParameter("ceopend");
String rejected = request.getParameter("rejected");
String cancelled = request.getParameter("cancelled");
boolean isCancelled = "Y".equals(cancelled);
String pirID = request.getParameter("pirID");
//incident classfication
String equip = request.getParameter("equip");
String increlopr = request.getParameter("increlopr");
String bloodtrans = request.getParameter("bloodtrans");
String adr = request.getParameter("adr");
String med = request.getParameter("med");
String patfall = request.getParameter("patfall");
String patgen = request.getParameter("patgen");
String bef = request.getParameter("bef");
String stagen = request.getParameter("stagen");
String stafall = request.getParameter("stafall");
String secu = request.getParameter("secu");
String vrofall = request.getParameter("vrofall");
String vrogen = request.getParameter("vrogen");
String wpv = request.getParameter("wpv");
String oth = request.getParameter("oth");
//
String[] traffics = null;
String[] pirids = null;
String[] piremarks = null;
String[] piremarks2 = null;
String[] piremarks3 = null;
String[] umdmRemarks = null;
String[] umdmRemarks2 = null;
String[] umdmRemarks3 = null;
String[] donremarks = null;
String[] vparemarks = null;
String listTablePageParaName = (new ParamEncoder("row").encodeParameterName(TableTagParameters.PARAMETER_PAGE));
String listTableCurPage = request.getParameter(listTablePageParaName);

Boolean IsRedoStatus = false;
Boolean SaveTrafficAction = false;
Boolean SaveDonReamrkAction = false;
Boolean SaveVPARemarkAction = false;
Boolean SaveUMDMRemark = false;
Boolean ExcelReport = false;
Workbook wb = null;
Boolean IsPIManager = null;
Boolean IsDHead = null;
Boolean IsSubHead = null;
Boolean IsPharmacySeniorStaff = null;
Boolean IsNursingAdmin = null;
Boolean IsCooVpa = null;
Boolean IsCeo = null;
String xlsFileName = null;
Boolean ExcelPIReportType = false;
Boolean ExcelPIReportUnit = false;
Boolean ExcelPIReportTypeUnit = false;
Boolean ExcelPIReportSummary = false;
Boolean ExcelPIReportComparison = false;
Boolean ExcelPIReportBoard = false;
Boolean ExcelPIReportFall = false;
Boolean ExcelPIReportFallNurse = false;
Boolean ExcelPIReportFallControlChart = false;
ArrayList viewList = null;
Boolean IsNursingStaff = false;
Boolean furtherActionReminder = false;
Boolean reporterReminder = false;
Boolean postExamReminder = false;
Boolean ceoReminder = false;
//
String currYear = request.getParameter("ceoyear");
String currMonth = request.getParameter("ceomonth");

String pirID2 = null;
String incclass2 = null;
String Status2 = null;
String nearmiss2 = null;
String pinearmiss2 = null;
String class2 = null;
String piclass2 = null;
String deptcode = null;
String deptcodeFlwup = null;
String piincclass2 = null;
String IncType = null;
String IsPxIncident = null;

if ("".equals(currYear) || currYear == null) {
	currYear = Integer.toString(DateTimeUtil.getCurrentYear());
}
if ("".equals(currMonth) || currMonth == null) {
	currMonth = Integer.toString(DateTimeUtil.getCurrentMonth());
}
String currDay = null;
//inc_date_to = getLastMonthDay("1/" + Integer.toString(Integer.parseInt(currMonth) + 1) + "/2015");
Boolean ExcelPIReportCEO = false;
Boolean ExcelPIReportDOH = false;
Boolean ExcelPIReportPX = false;
String StatusLabel = null;
String[] responsibleParty = null;

if (status == null) {
	status = "";
}

IsPIManager = PiReportDB.IsPIManager(userBean.getStaffID());
IsDHead = PiReportDB.IsDHead(userBean.getStaffID());
IsNursingStaff = PiReportDB.IsNursingStaff(userBean.getStaffID());
IsPharmacySeniorStaff = PiReportDB.IsPharmacySeniorStaff(userBean.getStaffID());
IsNursingAdmin = PiReportDB.IsNursingAdmin(userBean.getStaffID());
IsCooVpa = PiReportDB.IsCooVpa(userBean.getStaffID());
IsCeo = PiReportDB.IsCeo(userBean.getStaffID());

if (command != null && command.equals("save_pi")) {
	traffics = request.getParameterValues("traffics");
	pirids = request.getParameterValues("pirids");
	piremarks = request.getParameterValues("piremarks");
	piremarks2 = request.getParameterValues("piremarks2");
	piremarks3 = request.getParameterValues("piremarks3");
	SaveTrafficAction = true;
}
else if (command != null && command.equals("save_don_remark")) {
	pirids = request.getParameterValues("pirids");
	donremarks = request.getParameterValues("donremarks");
	SaveDonReamrkAction = true;
}
else if (command != null && command.equals("save_vpa_remark")) {
	pirids = request.getParameterValues("pirids");
	vparemarks = request.getParameterValues("vparemarks");
	SaveVPARemarkAction = true;
}
else if (command != null && command.equals("save_umdm")) {
		pirids = request.getParameterValues("pirids");
		piremarks = request.getParameterValues("umdmremarks");
		//piremarks2 = request.getParameterValues("umdmremarks2");
		//piremarks3 = request.getParameterValues("umdmremarks3");
		SaveUMDMRemark = true;
	}
else if (command != null && command.equals("excel")) {
	traffics = request.getParameterValues("traffics");
	pirids = request.getParameterValues("pirids");
	ExcelReport = true;
}
else if (command != null && command.equals("pirpt_type")) {
	ExcelPIReportType = true;
}
else if (command != null && command.equals("pirpt_unit")) {
	ExcelPIReportUnit = true;
}
else if (command != null && command.equals("pirpt_type_unit")) {
	ExcelPIReportTypeUnit = true;
}
else if (command != null && command.equals("pirpt_summary")) {
	ExcelPIReportSummary = true;
}
else if (command != null && command.equals("pirpt_comparison")) {
	ExcelPIReportComparison = true;
}
else if (command != null && command.equals("pirpt_board")) {
	ExcelPIReportBoard = true;
}
else if (command != null && command.equals("pirpt_fall")) {
	ExcelPIReportFall = true;
}
else if (command != null && command.equals("pirpt_fall_nurse")) {
	ExcelPIReportFallNurse = true;
}
else if (command != null && command.equals("pirpt_fall_cnt_cht")) {
	ExcelPIReportFallControlChart = true;
}
else if (command != null && command.equals("pifurtheraction_remind")) {
	furtherActionReminder = true;
}
else if (command != null && command.equals("pireport_remind")) {
	reporterReminder  = true;
}
else if (command != null && command.equals("pipost_exam_remind")) {
	postExamReminder  = true;
}
else if (command != null && command.equals("piceo_remind")) {
	ceoReminder  = true;
}
else if (command != null && command.equals("pirpt_ceo")) {
	ExcelPIReportCEO  = true;
}
else if (command != null && command.equals("pirpt_doh")) {
	ExcelPIReportDOH  = true;
}
else if (command != null && command.equals("pirpt_px")) {
	ExcelPIReportPX  = true;
}

if (command != null) {
	if (SaveTrafficAction) { // save pi remark
		PiReportDB.updateTrafficLight(pirids, traffics, piremarks, piremarks2, piremarks3);

		command = "view";
		SaveTrafficAction = false;
	} else if (SaveDonReamrkAction) { // save don remark
		PiReportDB.updateDONremark(pirids, donremarks);

		command = "view";
		SaveDonReamrkAction = false;
	} else if (SaveVPARemarkAction) { // save vpa remark
		PiReportDB.updateVPAremark(pirids, vparemarks);

		command = "view";
		SaveVPARemarkAction = false;
	} else if (SaveUMDMRemark) { //save umdm remark
		PiReportDB.updateUMDMRemark(pirids, piremarks, piremarks2, piremarks3);

		command = "view";
		SaveUMDMRemark = false;
	} else if (ExcelReport) {
		wb = PiReportDB.SaveExcel(userBean, incident_date_from, incident_date_to,
			report_date_from, report_date_to, classification,
			equip, increlopr, bloodtrans, adr, med, patfall, patgen,
			bef, stagen, stafall, secu, vrofall,
			vrogen, oth,
			status, nearmiss, ceopend, rejected, pirID, userBean.getDeptCode(),
			userBean.getStaffID(), viewList);
		OutputStream out2 = response.getOutputStream();
		response.setContentType("application/excel");
		response.setHeader("Content-disposition", "attachment; filename=hkahrisk_draft.xls");
		wb.write(out2);
		out2.close();

		command = "view";
		ExcelReport = false;

	} else if (ExcelPIReportType) {
/*
		xlsFileName = "piyearend_type_draft.xls";
		wb = PiReportDB.piYearEndReportType(userBean, xlsFileName, incident_date_from, incident_date_to);
		OutputStream out2 = response.getOutputStream();
		response.setContentType("application/excel");
		response.setHeader("Content-disposition", "attachment; filename=" + xlsFileName);
		wb.write(out2);
		out2.flush();
		out2.close();
*/
		command = "view";
		ExcelPIReportType = false;
	} else if (ExcelPIReportUnit) {
/*
		xlsFileName = "piyearend_unit_draft.xls";
		wb = PiReportDB.piYearEndReportUnit(userBean, null, xlsFileName, incident_date_from, incident_date_to);
		OutputStream out2 = response.getOutputStream();
		response.setContentType("application/excel");
		response.setHeader("Content-disposition", "attachment; filename=" + xlsFileName);
		wb.write(out2);
		out2.flush();
		out2.close();
*/
		command = "view";
		ExcelPIReportType = false;
	} else if (ExcelPIReportTypeUnit) {
/*
		xlsFileName = "piyearend_type_unit_draft.xls";
		wb = PiReportDB.piYearEndReportTypeUnit(userBean, null, xlsFileName, incident_date_from, incident_date_to);
		OutputStream out2 = response.getOutputStream();
		response.setContentType("application/excel");
		response.setHeader("Content-disposition", "attachment; filename=" + xlsFileName);
		wb.write(out2);
		out2.flush();
		out2.close();
*/
		command = "view";
		ExcelPIReportTypeUnit = false;
	} else if (ExcelPIReportSummary) {
/*
		xlsFileName = "piyearend_summary_draft.xls";
		wb = PiReportDB.piYearEndReportSummary(userBean, null, xlsFileName, incident_date_from, incident_date_to);
		OutputStream out2 = response.getOutputStream();
		response.setContentType("application/excel");
		response.setHeader("Content-disposition", "attachment; filename=" + xlsFileName);
		wb.write(out2);
		out2.flush();
		out2.close();
*/
		command = "view";
		ExcelPIReportSummary = false;
	} else if (ExcelPIReportComparison) {
/*
		xlsFileName = "piyearend_comparison_draft.xls";
		wb = PiReportDB.piYearEndReportCompariosn(userBean, null, xlsFileName, incident_date_from, incident_date_to);
		OutputStream out2 = response.getOutputStream();
		response.setContentType("application/excel");
		response.setHeader("Content-disposition", "attachment; filename=" + xlsFileName);
		wb.write(out2);
		out2.flush();
		out2.close();
*/
		command = "view";
		ExcelPIReportComparison = false;
	} else if (ExcelPIReportBoard) {
		if (ConstantsServerSide.isTWAH()) {
			xlsFileName = "piyearend_all_draft_tw.xls";
		} else {
			xlsFileName = "piyearend_all_draft.xls";
		}
		incident_date_from = "0101" + Integer.toString(DateTimeUtil.getCurrentYear() - 1)  + " 000001";
		incident_date_to = "3112" + Integer.toString(DateTimeUtil.getCurrentYear() - 1)  + " 125959";
		//temp code for 2017 year end report
		//incident_date_from = "01012018 000001";
		//incident_date_to = "31122018 125959";
		//currYear = "2017";
		currYear = Integer.toString(DateTimeUtil.getCurrentYear() - 1);
		System.out.println("incident_date_from, incident_date_to, CurrYear : " + incident_date_from + " " + incident_date_to + " " + currYear);
		wb = PiReportDB.piYearEndReportBoard(userBean, xlsFileName, currYear, incident_date_from, incident_date_to);
		OutputStream out2 = response.getOutputStream();
		response.setContentType("application/excel");
		response.setHeader("Content-disposition", "attachment; filename=" + xlsFileName);
		wb.write(out2);
		out2.flush();
		out2.close();

		command = "view";
		ExcelPIReportBoard = false;
	} else if (ExcelPIReportFall) {
		xlsFileName = "piyearend_fall_draft.xls";
		incident_date_from = "0101" + Integer.toString(DateTimeUtil.getCurrentYear() - 1)  + " 000001";
		incident_date_to = "3112" + Integer.toString(DateTimeUtil.getCurrentYear() - 1)  + " 125959";
		//temp code for 2017 year end report
		//incident_date_from = "01012018 000001";
		//incident_date_to = "31122018 125959";
		//currYear = "2017";
		currYear = Integer.toString(DateTimeUtil.getCurrentYear() - 1);
		System.out.println("incident_date_from, incident_date_to, CurrYear : " + incident_date_from + " " + incident_date_to + " " + currYear);
		wb = PiReportDB.piYearEndReportFall(userBean, xlsFileName, currYear, incident_date_from, incident_date_to);
		OutputStream out2 = response.getOutputStream();
		response.setContentType("application/excel");
		response.setHeader("Content-disposition", "attachment; filename=" + xlsFileName);
		wb.write(out2);
		out2.flush();
		out2.close();

		command = "view";
		ExcelPIReportFall = false;
	} else if (ExcelPIReportFallNurse) {
		xlsFileName = "piyearend_nurse_draft.xls";
		incident_date_from = "0101" + Integer.toString(DateTimeUtil.getCurrentYear()) + " 000001";
		incident_date_to = "3112" + Integer.toString(DateTimeUtil.getCurrentYear()) + " 125959";

		wb = PiReportDB.piYearEndReportFallNurse(userBean, xlsFileName, incident_date_from, incident_date_to);
		OutputStream out2 = response.getOutputStream();
		response.setContentType("application/excel");
		response.setHeader("Content-disposition", "attachment; filename=" + xlsFileName);
		wb.write(out2);
		out2.flush();
		out2.close();

		command = "view";
		ExcelPIReportFallNurse = false;
	} else if (ExcelPIReportFallControlChart) {
		xlsFileName = "PatFallCtrlChart_draft.xls";
		incident_date_from = "0101" + Integer.toString(DateTimeUtil.getCurrentYear()) + " 000001";
		incident_date_to = "3112" + Integer.toString(DateTimeUtil.getCurrentYear()) + " 125959";
		currYear = Integer.toString(DateTimeUtil.getCurrentYear());
		//incident_date_from = "0101" + Integer.toString(DateTimeUtil.getCurrentYear() - 1) + " 000001";
		//incident_date_to = "3112" + Integer.toString(DateTimeUtil.getCurrentYear() - 1) + " 125959";
		//currYear = Integer.toString(DateTimeUtil.getCurrentYear() - 1);

		System.out.println("incident_date_from, incident_date_to, CurrYear : " + incident_date_from + " " + incident_date_to + " " + currYear);

		wb = PiReportDB.piYearEndReportFallControlChart(userBean, xlsFileName, currYear, incident_date_from, incident_date_to);
		// 10102018 use local function for pireportdb class not yet copy to production
		//wb = piYearEndReportFallControlChart(userBean, xlsFileName, currYear, incident_date_from, incident_date_to);
		OutputStream out2 = response.getOutputStream();
		response.setContentType("application/excel");
		response.setHeader("Content-disposition", "attachment; filename=" + xlsFileName);
		wb.write(out2);
		out2.flush();
		out2.close();

		command = "view";
		ExcelPIReportFallControlChart = false;
	} else if (furtherActionReminder) {
		PiReportDB.sendFurtherActionReminder(userBean);

		command = "view";
		furtherActionReminder  = false;
	} else if (reporterReminder) {
		PiReportDB.sendIncidentReportReminder(userBean);

		command = "view";
		reporterReminder  = false;
	} else if (postExamReminder) {
		PiReportDB.sendPostExamReportReminder(userBean);

		command = "view";
		postExamReminder  = false;
	} else if (ceoReminder) {
		PiReportDB.sendCeoReminder(userBean);

		command = "view";
		ceoReminder  = false;
	} else if (ExcelPIReportCEO) {
		xlsFileName = "ceoreport_draft.xls";
		wb = PiReportDB.CEOReport(userBean, currDay, currMonth, currYear, incident_date_from, incident_date_to,
				   report_date_from, report_date_to, classification,
				   equip, adr, med, patfall, patgen,
					bef, stagen, stafall, secu, vrofall,
					vrogen, oth,
				   status, nearmiss, pirID, userBean.getDeptCode(),
				   userBean.getStaffID(), viewList);
		OutputStream out2 = response.getOutputStream();
		response.setContentType("application/excel");
		response.setHeader("Content-disposition", "attachment; filename=" + xlsFileName);
		wb.write(out2);
		out2.flush();
		out2.close();

		command = "view";
		ExcelPIReportCEO = false;
	} else if (ExcelPIReportPX) {
		xlsFileName = "pipx.xls";

		incident_date_from = "0101" + Integer.toString(DateTimeUtil.getCurrentYear() - 1) + " 000001";
		incident_date_to = "3112" + Integer.toString(DateTimeUtil.getCurrentYear() - 1) + " 125959";
		currYear = Integer.toString(DateTimeUtil.getCurrentYear() - 1);
		System.out.println("incident_date_from, incident_date_to, CurrYear : " + incident_date_from + " " + incident_date_to + " " + currYear);


		wb = PiReportDB.piPxReport(userBean, currYear, incident_date_from, incident_date_to);
		OutputStream out2 = response.getOutputStream();
		response.setContentType("application/excel");
		response.setHeader("Content-disposition", "attachment; filename=" + xlsFileName);
		wb.write(out2);
		out2.flush();
		out2.close();

		command = "view";
		ExcelPIReportCEO = false;
	}
}

viewList = PiReportDB.getPIReportList(userBean, "view", incident_date_from, incident_date_to,
		report_date_from, report_date_to, classification,
		equip, increlopr, bloodtrans, adr, med, patfall, patgen,
		bef, stagen, stafall, secu, vrofall,
		vrogen, wpv, oth,
		status, nearmiss, hazardousContition, ceopend, rejected, cancelled, pirID, userBean.getDeptCode(), userBean.getStaffID());

request.setAttribute("reportList", viewList);
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
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>

<%
if (ConstantsServerSide.isHKAH()) {
	StatusLabel = "Wait for ";
} else {
	StatusLabel = "Pending ";
}
%>
<style>
<%if (ConstantsServerSide.isHKAH()) { %>
	span.pagebanner { font-size: 15px; }
	span.pagelinks  { font-size: 15px; }
<%} %>
</style>
<body>
	<DIV id=indexWrapper>
		<DIV id=mainFrame>
			<DIV id=contentFrame>
				<jsp:include page="../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="function.pi.report.list" />
					<jsp:param name="keepReferer" value="Y" />
					<jsp:param name="accessControl" value="Y"/>
				</jsp:include>
				<bean:define id="functionLabel"><bean:message key="function.pi.report.list" /></bean:define>
				<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
				<form name="searchfrom" action="reportlist.jsp" method="post">
					<input type="hidden" name="<%=listTablePageParaName %>" value="<%=listTableCurPage %>" />
					<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								Incident Date
							</td>
							<td class="infoData" width="85%">
								<input type="textfield" name="incident_date_from" id="incident_date_from"
									class="datepickerfield" value="<%=incident_date_from==null?"":incident_date_from %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/>
								-
								<input type="textfield" name="incident_date_to" id="incident_date_to"
									class="datepickerfield" value="<%=incident_date_to==null?"":incident_date_to %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)
							</td>
						</tr>

						<tr class="smallText">
							<td class="infoLabel" width="15%">
								Report Date
							</td>
							<td class="infoData" width="85%">
								<input type="textfield" name="report_date_from" id="report_date_from"
									class="datepickerfield" value="<%=report_date_from==null?"":report_date_from %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/>
								-
								<input type="textfield" name="report_date_to" id="report_date_to"
									class="datepickerfield" value="<%=report_date_to==null?"":report_date_to %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)
							</td>
						</tr>
<%if (ConstantsServerSide.isTWAH()) { %>
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								Classification
							</td>
							<td class="infoData" width="85%">
								<table border="0" width="100%">
								<tr>
									<td><input type="checkbox" name="equip" value="9" <%if ("9".equals(equip)) {%>checked<%} %>>Equipment</input></td>
									<td>&nbsp;</td>
									<td><input type="checkbox" name="increlopr" value="2092" <%if ("2092".equals(increlopr)) {%>checked<%} %>>Incident Relating to Operation</input></td>
									<td>&nbsp;</td>
									<td><input type="checkbox" name="bloodtrans" value="2172" <%if ("2172".equals(bloodtrans)) {%>checked<%} %>>Blood Product Transfusion</input></td>
									<td colspan="2">&nbsp;</td>
								</tr>
								<tr>
									<td><input type="checkbox" name="med" value="8" <%if ("8".equals(med)) {%>checked<%} %>>Medication Incident</input></td>
									<td>&nbsp;</td>
									<td><input type="checkbox" name="adr" value="530" <%if ("530".equals(adr)) {%>checked<%} %>>Medication ADR</input></td>
									<td colspan="4">&nbsp;</td>
								</tr>
								<tr>
									<td><input type="checkbox" name="patfall" value="1" <%if ("1".equals(patfall)) {%>checked<%} %>>Patient Fall</input></td>
									<td>&nbsp;</td>
									<td><input type="checkbox" name="patgen" value="4" <%if ("4".equals(patgen)) {%>checked<%} %>>Patient Inj</input></td>
									<td>&nbsp;</td>
									<td><input type="checkbox" name="stagen" value="5" <%if ("5".equals(stagen)) {%>checked<%} %>>Staff Inj</input></td>
									<td>&nbsp;</td>
									<td><input type="checkbox" name="stafall" value="2" <%if ("2".equals(stafall)) {%>checked<%} %>>Staff Fall</input></td>
								</tr>
								<tr>
									<td><input type="checkbox" name="secu" value="474" <%if ("474".equals(secu)) {%>checked<%} %>>Security</input></td>
									<td>&nbsp;</td>
									<td><input type="checkbox" name="vrofall" value="3" <%if ("3".equals(vrofall)) {%>checked<%} %>>Visitor/Rel/Oth Inj Fall</input></td>
									<td>&nbsp;</td>
									<td><input type="checkbox" name="vrogen" value="6" <%if ("6".equals(vrogen)) {%>checked<%} %>>Visitor/Rel/Oth Inj General</input></td>
									<td>&nbsp;</td>
									<td><input type="checkbox" name="oth" value="10" <%if ("10".equals(oth)) {%>checked<%} %>>Others</input></td>
								</tr>
								</table>
							</td>
						</tr>
<%} else { %>
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								Classification
							</td>
							<td class="infoData" width="85%">
								<table border="0" width="100%">
								<tr>
									<td colspan="9"><input type="checkbox" name="bloodtrans" value="1001" <%if ("1001".equals(bloodtrans)) {%>checked<%} %>>Blood Transfusion Reaction</input></td>
								</tr>
								<tr>
									<td colspan="9"><input type="checkbox" name="stafall" value="1002" <%if ("1002".equals(stafall)) {%>checked<%} %>>Code Blue</input></td>
								</tr>
								<tr>
									<td colspan="9"><input type="checkbox" name="equip" value="9" <%if ("9".equals(equip)) {%>checked<%} %>>Facility & Equipment & Security</input></td>
								</tr>
								<tr>
									<td colspan="9"><input type="checkbox" name="med" value="8" <%if ("8".equals(med)) {%>checked<%} %>>Medication Incident</input></td>
								</tr>
								<tr>
									<td><input type="checkbox" name="patgen" value="4" <%if ("4".equals(patgen)) {%>checked<%} %>>Patient Injury</input></td>
									<td>&nbsp;</td>
									<td><input type="checkbox" name="patfall" value="1007" <%if ("1007".equals(patfall)) {%>checked<%} %>>Patient Misidentification</input></td>
									<td>&nbsp;</td>
									<td><input type="checkbox" name="secu" value="1008" <%if ("1008".equals(secu)) {%>checked<%} %>>Procedure Unit Related</input></td>
									<td>&nbsp;</td>
									<td><input type="checkbox" name="bef" value="7" <%if ("7".equals(bef)) {%>checked<%} %>>Sharps Inj / BFE</input></td>
									<td colspan="2">&nbsp;</td>
								</tr>
								<tr>
									<td><input type="checkbox" name="vrofall" value="1010" <%if ("1010".equals(vrofall)) {%>checked<%} %>>Specimen Related</input></td>
									<td>&nbsp;</td>
									<td><input type="checkbox" name="stagen" value="5" <%if ("5".equals(stagen)) {%>checked<%} %>>Staff Injury</input></td>
									<td>&nbsp;</td>
									<td><input type="checkbox" name="vrogen" value="6" <%if ("6".equals(vrogen)) {%>checked<%} %>>Visitor Injury</input></td>
									<td>&nbsp;</td>
									<td><input type="checkbox" name="wpv" value="700" <%if ("700".equals(wpv)) {%>checked<%} %>>Workplace Violence</input></td>
									<td colspan="2">&nbsp;</td>
								</tr>
								<tr>
									<td colspan="7"><input type="checkbox" name="oth" value="10" <%if ("10".equals(oth)) {%>checked<%} %>>Others</input></td>
									<td colspan="2">&nbsp;</td>
								</tr>
								</table>
							</td>
						</tr>
<% } %>
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								Near Miss
							</td>
							<td class="infoData" width="85%">
								<select name="nearmiss">
									<option value=''></option>
									<option value='1'<%=(nearmiss!=null && "1".equals(nearmiss))?"selected":"" %>>Yes</option>
									<option value='0'<%=(nearmiss!=null && "0".equals(nearmiss))?"selected":"" %>>No</option>
								</select>
							</td>
						</tr>

						<tr class="smallText">
							<td class="infoLabel" width="15%">
								Hazardous Contition
							</td>
							<td class="infoData" width="85%">
								<select name="hazardousContition">
									<option value=''></option>
									<option value='1'<%=(hazardousContition!=null && "0".equals(hazardousContition))?"selected":"" %>>Yes</option>
									<option value='0'<%=(hazardousContition!=null && "1".equals(hazardousContition))?"selected":"" %>>No</option>
								</select>
							</td>
						</tr>

						<tr class="smallText">
							<td class="infoLabel" width="15%">
								Status
							</td>
							<td class="infoData" width="85%">
								<select name="status">
									<option value=''>All Reports</option>
									<!--option value='99'<%=(status!=null && "99".equals(status))?"selected":"" %>>All Reports (Exclude completed case)</option-->
									<option value='0'<%=(status!=null && "0".equals(status))?"selected":"" %>><%=StatusLabel%> Reporter resubmit</option>
									<option value='1'<%=(status!=null && "1".equals(status))?"selected":"" %>><%=StatusLabel%> Unit Manager Input/Senior Pharmacist Input</option>
									<option value='19'<%=(status!=null && "19".equals(status))?"selected":"" %>><%=StatusLabel%> <%if (ConstantsServerSide.isHKAH()) {%>Senior UM<%} else {%>SNO<%} %> Input</option>
									<option value='11'<%=(status!=null && "11".equals(status))?"selected":"" %>><%=StatusLabel%>Referring to OSH/ICN</option>
									<option value='7'<%=(status!=null && "7".equals(status))?"selected":"" %>><%=StatusLabel%>OSH/ICN Acceptance</option>
									<option value='12'<%=(status!=null && "12".equals(status))?"selected":"" %>>Refer to Pharmacist/<%=StatusLabel%> Manager Input - Clinical</option>
									<!--option value='8'<%=(status!=null && "8".equals(status))?"selected":"" %>>Wait for Senior Pharmacist Acceptance</option-->
									<!--option value='1'<%=(status!=null && "1".equals(status))?"selected":"" %>><%=StatusLabel%>Senior Pharmacist Input</option-->
									<option value='14'<%=(status!=null && "14".equals(status))?"selected":"" %>><%=StatusLabel%>Chief Pharmacist Input</option>
									<option value='2'<%=(status!=null && "2".equals(status))?"selected":"" %>><%=StatusLabel%>Administrator</option>
									<option value='3'<%=(status!=null && "3".equals(status))?"selected":"" %>><%=StatusLabel%>PI</option>
									<option value='4'<%=(status!=null && "4".equals(status))?"selected":"" %>><%=StatusLabel%>CEO</option>
									<option value='5'<%=(status!=null && "5".equals(status))?"selected":"" %>>Reporting Process Completed</option>
									<!--option value='6'<%=(status!=null && "6".equals(status))?"selected":"" %>>Rejected</option-->
								</select>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href="JavaScript:newPopup('statusdiagram.jsp')">Status Diagram</a>
							</td>
						</tr>
						<tr class="smallText">
							<td  class="infoLabel" style="width:15%">
									Report ID
								</td>
								<td id="patNoCell" style="vertical-align:top" colspan="2" class="infoData" style="width:85%">
									<input name="pirID" type="textfield" value="<%=(pirID==null)?"":pirID %>" maxlength="30" size="30" />
								</td>
						</tr>
<%	if (IsCeo) { %>
						<tr class="smallText">
							<td  class="infoLabel" style="width:15%">
									CEO Pending List
								</td>
								<td class="ceopending" width="85%">
									<select name="ceopend">
										<option value=''></option>
										<option value='1'<%=(ceopend!=null && "1".equals(ceopend))?"selected":"" %>>Yes</option>
										<%--
										<option value='0'<%=(ceopend!=null && "0".equals(ceopend))?"selected":"" %>>No</option>
										 --%>
									</select>
								</td>
						</tr>
<%	} %>
<%	if (IsPIManager) { %>
						<tr class="smallText">
							<td  class="infoLabel" style="width:15%">
									Rejected Cases
								</td>
								<td class="rejectedcases" width="85%">
									<select name="rejected">
										<option value=''></option>
										<option value='1'<%=(rejected!=null && "1".equals(rejected))?"selected":"" %>>Yes</option>
										<%--
										<option value='0'<%=(ceopend!=null && "0".equals(ceopend))?"selected":"" %>>No</option>
										 --%>
									</select>
								</td>
						</tr>
						<tr class="smallText">
							<td  class="infoLabel" style="width:15%">
									Cancelled Cases
								</td>
								<td class="rejectedcases" width="85%">
									<select name="cancelled">
										<option value=''></option>
										<option value='Y'<%=(cancelled!=null && "Y".equals(cancelled))?"selected":"" %>>Yes</option>
									</select>
								</td>
						</tr>
<%	} %>


						<tr class="smallText">
							<td colspan="2" align="center">
								<button onclick="submitSearch()">
									<bean:message key="button.search" />
								</button>
								<button onclick="clearSearch()">
									<bean:message key="button.clear" />
								</button>
								<input type="hidden" name="command" />
							<%--
								<button onclick="createReport()">
									Create Report(Old UI)
								</button>
							--%>
								<button onclick="createReport2()">
									Create Report
								</button>
<%	if (IsPIManager && !"piuser".equals(userBean.getLoginID())) { // save button for pi %>
								<button onclick="return showconfirm('save_pi');">
									Save Traffic Light and PI Remark
								</button>
<%	} %>

<%	if (ConstantsServerSide.isHKAH() && IsNursingAdmin) { %>
								<button onclick="return showconfirm('save_don_remark');">
									Save Remark
								</button>
<%	} %>
<%	if (ConstantsServerSide.isHKAH() && IsCooVpa) { %>
								<button onclick="return showconfirm('save_vpa_remark');">
									Save Remark
								</button>
<%	} %>


<%
	if (PiReportDB.IsPIManager(userBean.getStaffID()) ||
		PiReportDB.IsPharmacyStaff(userBean.getStaffID()) ||
		PiReportDB.IsDeptHeadStaff(userBean.getStaffID()) ||
		PiReportDB.IsOshIcnStaff(userBean.getStaffID()) ||
		"5676".equals(userBean.getStaffID())
	) {
%>
								<button onclick="return showconfirm('excel');">
									Excel report
								</button>
<%	} %>

<%	if (IsDHead && IsNursingStaff && !IsNursingAdmin) {	// save button for dm um %>
								<button onclick="return showconfirm('save_umdm');">
									Save UM/DM remark
								</button>
<%	} %>

								<br/>
<%	if ((IsPIManager || IsNursingAdmin || IsCooVpa || IsPharmacySeniorStaff) && !"piuser".equals(userBean.getLoginID())) { %>

								<%--
								<button onclick="return showconfirm('pirpt_type', '');">
									Incident Report by Type
								</button>
								<button onclick="return showconfirm('pirpt_unit', '');">
									Incident Report by Unit
								</button>
								<button onclick="return showconfirm('pirpt_type_unit', '');">
									Incident Report by breakdown
								</button>
								<button onclick="return showconfirm('pirpt_summary', '');">
									Incident Report by Summary
								</button>
								<button onclick="return showconfirm('pirpt_comparison', '');">
									Incident Report by Comparison
								</button>
								--%>


								<button onclick="return showconfirm('pirpt_board', '');">
									Year-end Summary Report of Incident
								</button>

<%	if (IsPIManager && !"piuser".equals(userBean.getLoginID())) { %>
								<button onclick="return showconfirm('pirpt_fall', '');">
									Year-end Summary of Patient Fall
								</button>
<%	} %>
<%} %>
<%if (IsPIManager && !"piuser".equals(userBean.getLoginID())) { %>
								<button onclick="return showconfirm('pirpt_fall_cnt_cht', '');">
									Patient Fall Control Chart
								</button>
								<br/>

<%} %>
<%if ((IsPIManager || IsNursingAdmin || IsCooVpa || IsPharmacySeniorStaff) && !"piuser".equals(userBean.getLoginID())) { %>

								<button onclick="return showconfirm('pirpt_ceo', '');">
									Summary Report
								</button>
<%} %>
<%if ((IsPIManager || IsNursingAdmin || IsCooVpa || IsPharmacySeniorStaff) && !"piuser".equals(userBean.getLoginID())) { %>
								<select name="ceomonth" class="notEmpty" value="">
<%	String month_shortform[] = { "JAN", "FEB", "MAR", "APR", "MAY", "JUN", "JUL", "AUG", "SEP", "OCT", "NOV", "DEC" }; %>
<%	for (int i = 1; i <= 12 ; i ++) { %>
									<option value="<%=i %>"<%if (String.valueOf(i).equals(currMonth)) {%>selected<%} %>><%=month_shortform[i - 1] %></option>
<%	} %>
								</select>
								<select name="ceoyear" class="notEmpty" value="">
<%	for (int i = 2014; i <= DateTimeUtil.getCurrentYear() + 1 ; i ++) { %>
									<option value="<<%=i %>"<%if (String.valueOf(i).equals(currYear)) {%>selected<%} %>><%=i %></option>
<%	} %>
								</select>
<%	if (ConstantsServerSide.isHKAH()) { %>
<%		if ((IsPIManager) && !"piuser".equals(userBean.getLoginID())) { %>
								<!--
								<button onclick="return showconfirm('pirpt_doh', '');">
									DOH Report
								</button>
								-->
<%		} %>
<%	} %>
<%	if ((IsPIManager || IsNursingAdmin || IsPharmacySeniorStaff) && !"piuser".equals(userBean.getLoginID())) { %>
								<button onclick="return showconfirm('pirpt_px', '');">
									Pharmacy Report
								</button>
<%	} %>

						<br/>
<%	if (IsPIManager && !"piuser".equals(userBean.getLoginID())) { %>
							<table border=1>
								<tr>
								<td>
								<font color="red"><b>Reminder Section</b></font>
								</td>
								</tr>
								<tr>
								<td>
									<button onclick="return showconfirm('pireport_remind', '');">
										Sent Incident Report Reminder
									</button>
									<button onclick="return showconfirm('pifurtheraction_remind', '');">
										Sent Further Action Reminder
									</button>
									<button onclick="return showconfirm('pipost_exam_remind', '');">
										Sent Doctor Exam Form Reminder
									</button>

									<button onclick="return showconfirm('piceo_remind', '');">
										Sent CEO Reminder
									</button>
								</td>
								</tr>
							</table>
<%	} %>
<%} %>
<%if (PiReportDB.IsNursingSeniorStaff(userBean.getStaffID()) && 1 == 2) { %>
								<button onclick="return showconfirm('pirpt_fall_nurse', '');">
									Year-end Summary of Nurse
								</button>
<%} %>
							</td>
						</tr>
					</table>

				<display:table id="row" name="requestScope.reportList" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="generaltable"
				 	excludedParams="piremarks piremarks2 piremarks3 pirids traffics">
					<display:column property="fields0" title="Rpt ID" style="text-align:center;width:4%" />
						<c:set var="pirID2" value="${row.fields0}"/>
						<c:set var="incclass2" value="${row.fields9}"/>
						<c:set var="piStatus2" value="${row.fields7}"/>
						<c:set var="nearmiss2" value="${row.fields16}"/>
						<c:set var="pinearmiss2" value="${row.fields17}"/>
						<c:set var="class2" value="${row.fields6}"/>
						<c:set var="piclass2" value="${row.fields18}"/>
						<c:set var="piincclass2" value="${row.fields21}"/>
						<c:set var="deptcode" value="${row.fields22}"/>
						<c:set var="deptcodeFlwup" value="${row.fields23}"/>
<%
					pirID2 = (String)pageContext.getAttribute("pirID2");
					incclass2 = (String)pageContext.getAttribute("incclass2");
					Status2 = (String)pageContext.getAttribute("piStatus2");
					// pi near miss and classification
					nearmiss2 = (String)pageContext.getAttribute("nearmiss2");
					pinearmiss2 = (String)pageContext.getAttribute("pinearmiss2");
					class2 = (String)pageContext.getAttribute("class2");
					piclass2 = (String)pageContext.getAttribute("piclass2");
					deptcode = (String)pageContext.getAttribute("deptcode");
					deptcodeFlwup = (String)pageContext.getAttribute("deptcodeFlwup");
					IsSubHead = PiReportDB.IsSubHeadCase(deptcode);
					piincclass2 = (String)pageContext.getAttribute("piincclass2");
					IncType = PiReportDB.getRptStsDesc(PiReportDB.IsPxDeptCode(deptcodeFlwup), class2, deptcode, Status2);
					responsibleParty = PiReportDB.getResponsibleParty(pirID2);
%>
<%if (ConstantsServerSide.isHKAH()) { %>
					<display:column property="fields1" title="Report Person - Name" style="width:8%" />
					<display:column property="fields3" title="Report Person - Department" style="width:8%" />
					<display:column property="fields24" title="Incident Department" style="width:8%" />
					<display:column property="fields4" title="Incident Date" style="width:8%" />
					<display:column property="fields5" title="Incident Place" style="width:8%" />
<%} else { %>
					<display:column property="fields1" title="Report Person Name" style="width:8%" />
					<display:column property="fields3" title="Report Person Department" style="width:8%" />
					<display:column property="fields24" title="Incident Department" style="width:8%" />
					<display:column property="fields4" title="Incident Date" style="width:8%" />
					<display:column property="fields5" title="Incident Place" style="width:8%" />
<%} %>
					<display:column title="Near Miss" style="width:8%" >
<%if (!nearmiss2.equals(pinearmiss2)) { %>
							<logic:equal name="row" property="fields17" value="0">
								<a href="JavaScript:newPopup('piclass.jsp?pirID=<%=pirID2%>');">No</a>
							</logic:equal>
							<logic:equal name="row" property="fields17" value="1">
								<a href="JavaScript:newPopup('piclass.jsp?pirID=<%=pirID2%>');">Yes</a>
							</logic:equal>

<%} else { %>
							<logic:equal name="row" property="fields17" value="0"> No
							</logic:equal>
							<logic:equal name="row" property="fields17" value="1"> Yes
							</logic:equal>
<%} %>
					</display:column>
					<display:column title="Hazardous Contition" style="width:8%" >
							<logic:equal name="row" property="fields27" value="0"> No
							</logic:equal>
							<logic:equal name="row" property="fields27" value="1"> Yes
							</logic:equal>
					</display:column>
					<display:column title="Incident Classification" style="width:8%" >
<%if (!class2.equals(piclass2)) { %>
							<a href="JavaScript:newPopup('piclass.jsp?pirID=<%=pirID2%>');"><%=piincclass2 %></a>
<%} else { %>
							<%=piincclass2 %>
<%} %>
					</display:column>					
					<display:column property="fields12" title="Incident Remark" style="width:15%" />				
					<%IsRedoStatus = PiReportDB.IsRedoStatus(pirID2); %>
					<display:column media="html" title="Status" style="width:8%">
						<logic:equal name="row" property="fields7" value="2">
<%if (PiReportDB.IsCooVpaRespondIncident(pirID2, userBean.getStaffID())) { %>
							<a href="JavaScript:newPopup('workFlowStatus.jsp?pirID=<%=pirID2%>');"><%=IsRedoStatus?"(VPA Redo)":""%> <%=IncType %></a>
<%} else {%>
							<a href="JavaScript:newPopup('workFlowStatus.jsp?pirID=<%=pirID2%>');"><%=IsRedoStatus?"(Redo)":""%> <%=IncType %></a>
<%} %>
						</logic:equal>
						<logic:equal name="row" property="fields7" value="4">
							Wait for CEO
						</logic:equal>
						<logic:equal name="row" property="fields7" value="5">
							<a href="JavaScript:newPopup('workFlowStatus.jsp?pirID=<%=pirID2%>');">Reporting Process Completed
						</logic:equal>
						<logic:equal name="row" property="fields7" value="6">
							<font color="red">Rejected</font>
						</logic:equal>
						<logic:notEqual name="row" property="fields7" value="2">
							<logic:notEqual name="row" property="fields7" value="4">
								<logic:notEqual name="row" property="fields7" value="5">
									<logic:notEqual name="row" property="fields7" value="6">
							<a href="JavaScript:newPopup('workFlowStatus.jsp?pirID=<%=pirID2%>');"><%=IsRedoStatus?"(Redo)":""%> <%=IncType %></a>
									</logic:notEqual>
								</logic:notEqual>
							</logic:notEqual>
						</logic:notEqual>
						<logic:notEqual name="row" property="fields7" value="6">
<% if (isCancelled) { %>
							<font color="red">&nbsp;(Cancelled)</font>
<%} %>
						</logic:notEqual>
					</display:column>
					<display:column media="html" title="Responsible Party" style="width:8%">
						<%=getResponsiblePartyHighlight(userBean, IsPIManager, responsibleParty, pirID2) %>
					</display:column>
					<display:column property="fields8" media="html" title="Report Date" style="width:8%" />
					<display:column property="fields10" media="csv excel xml pdf" title="Narrative Description" style="width:30%" />
					<display:column titleKey="prompt.action" media="html" style="width:5%; text-align:center">
<%if (ConstantsServerSide.isTWAH() && PiReportDB.ShowEditButton(pirID2, userBean.getStaffID()) && "0".equals(Status2)) { %>
							<button onclick="return callReport('edit', '<c:out value="${row.fields0}" />');"><bean:message key='button.edit' /></button>
<%} %>
<%if (ConstantsServerSide.isHKAH()) { %>
							<button onclick="return callReport('view', '<c:out value="${row.fields0}" />');"><bean:message key='button.view' /></button>
<%} else if (ConstantsServerSide.isTWAH()) { %>
							<button onclick="return callReport('view', '<c:out value="${row.fields0}" />');"><bean:message key='button.view' /></button>
<%} %>
<%if (IsPIManager && !"piuser".equals(userBean.getLoginID())) {  // pi remark %>
<%	if (!"0".equals(Status2) && !"6".equals(Status2)) { %>
							<button onclick="return callReport('fu_redo', '<c:out value="${row.fields0}" />');">Redo</button>
<%	} %>
<%	if (isCancelled) { %>
							<button onclick="return callReport('reopen', '<c:out value="${row.fields0}" />');">Re-Open</button>
<%	} else { %>
							<button onclick="return callReport('delete', '<c:out value="${row.fields0}" />');"><bean:message key='button.cancel' /></button>
<%	} %>
<%}%>
					</display:column>
<%if (IsPIManager && !"piuser".equals(userBean.getLoginID())) {  // pi remark %>
					<display:column title="Traffic Light" media="html" style="width:5%; text-align:center">
<%	String value = ((ReportableListObject)pageContext.getAttribute("row")).getFields11(); %>
						<select name="traffics">
							<option value="" <%if ("".equals(value)) {%>selected<%} %>></option>
							<option value="G" <%if ("G".equals(value)) {%>selected<%} %> style="background-color: green">G</option>
							<option value="Y" <%if ("Y".equals(value)) {%>selected<%} %> style="background-color: yellow">Y</option>
							<option value="R" <%if ("R".equals(value)) {%>selected<%} %> style="background-color: red">R</option>
						</select>
						<input type="hidden" value="${row.fields0}" name="pirids"></input>
					</display:column>

					<display:column title="PI Remark" media="html" style="width:20%; text-align:center">
<%	String value = ((ReportableListObject)pageContext.getAttribute("row")).getFields12(); %>
						<input type="text" value="${row.fields12}" name="piremarks"></input>
					</display:column>
					<display:column title="" media="html" style="width:20%; text-align:center">
<%	String value = ((ReportableListObject)pageContext.getAttribute("row")).getFields13(); %>
						<input type="text" value="${row.fields13}" name="piremarks2"></input>
					</display:column>
					<display:column title="" media="html" style="width:20%; text-align:center">
<%	String value = ((ReportableListObject)pageContext.getAttribute("row")).getFields14(); %>
						<input type="text" value="${row.fields14}" name="piremarks3"></input>
					</display:column>

<%}%>
<%if (ConstantsServerSide.isHKAH() && IsNursingAdmin) { // DON remark %>
						<display:column title="Remark" media="html" style="width:20%; text-align:center">
<%	String value = ((ReportableListObject)pageContext.getAttribute("row")).getFields19(); %>
							<input type="text" value="${row.fields19}" name="donremarks"></input>
							<input type="hidden" value="${row.fields0}" name="pirids"></input>
						</display:column>
<%} %>
<%if (ConstantsServerSide.isHKAH() && IsCooVpa) { // VPA remark %>
						<display:column title="Remark" media="html" style="width:20%; text-align:center">
<%	String value = ((ReportableListObject)pageContext.getAttribute("row")).getFields20(); %>
							<input type="text" value="${row.fields20}" name="vparemarks"></input>
							<input type="hidden" value="${row.fields0}" name="pirids"></input>
						</display:column>
<%}%>
<%if (IsDHead && IsNursingStaff && !IsNursingAdmin) {  // nurse dm/um remark %>
						<display:column title="UM/DM Remark" media="html" style="width:5%; text-align:center">
<%	String value = ((ReportableListObject)pageContext.getAttribute("row")).getFields15(); %>
						<input type="text" value="${row.fields15}" name="umdmremarks"></input>
						<input type="hidden" value="${row.fields0}" name="pirids"></input>
						</display:column>
<%} %>
					<%-- for export
					<display:column title="Traffic Light" property="fields11" media="csv excel xml pdf" style="width:5%; text-align:center" />
					--%>
<%--
					<display:column media="html" style="width:5%; text-align:center">
						<logic:notEqual name="row" property="fields6" value="2">
							<logic:notEqual name="row" property="fields6" value="5">
								<logic:notEqual name="row" property="fields6" value="7">
									<button onclick="return printReport('<c:out value="${row.fields0}" />');"><bean:message key='button.print' /></button>
								</logic:notEqual>
							</logic:notEqual>
						</logic:notEqual>
					</display:column>
 --%>
 					<display:column property="fields25" title="Narrative Description Of Occurence" media="csv excel xml pdf" style="width:0%" />
 					<display:column property="fields11" title="Traffic Light" media="csv excel xml pdf" style="width:0%" />
					<display:column property="fields12" title="piremarks1" media="csv excel xml pdf" style="width:0%" />
					<display:column property="fields13" title="piremarks2" media="csv excel xml pdf" style="width:0%" />
					<display:column property="fields14" title="piremarks3" media="csv excel xml pdf" style="width:0%" />
					<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
				</display:table>
				</form>
				<table align="center">
				<%--
					<tr class="smallText">
							<td colspan="2" align="center">
								<button onclick="createReport()">
									Create Report(Old UI)
								</button>
							</td>
					</tr>
				--%>
				<%--
					<tr class="smallText">
							<td colspan="2" align="center">
								<button onclick="createReport2()">
									Create Report(New UI)
								</button>
							</td>
					</tr>
				--%>
				</table>
				<script language="javascript">

				keepAlive(60000);

				function showconfirm(cmd) {
						$.prompt('Are you sure?!',{
							buttons: { Ok: true, Cancel: false },
							callback: function(v,m,f) {
								if (v ) {
									submitAction2(cmd);
									if (cmd == 'pifurtheraction_remind' || cmd == 'pipost_exam_remind') {
										alert('Reminder Sent');
									}
									if (cmd == 'pireport_remind' || cmd == 'piceo_remind') {
										alert('Reminder Sent');
									}
								}
							},
							prefix:'cleanblue'
						});
						return false;
					}

					function submitAction2(cmd) {
						document.searchfrom.command.value = cmd;
						document.searchfrom.submit();

						//$.prompt('Saving..... Please wait.',{
						//	prefix:'cleanblue', buttons: { }
						//});

					}

					function callReport(action, pirID) {
						if ('fu_redo' == action) {
							if (confirm('Do you want to redo Case no ' + pirID + '?')) {
								$.ajax({
									type: "POST",
									url: "redo_action.jsp",
									data: "pirID=" + pirID,
									success: function(values) {
										alert(values);
									}//success
								});//$.ajax
							}
						} else {
							callPopUpWindow('incident_report2.jsp?command=' + action + '&pirID=' + pirID);
						}
						return false;
					}

					function printReport(pirID) {
						callPopUpWindow('PostIncidentExam.jsp?pirID=' + pirID);
					}

					function submitSearch() {
						document.searchfrom.command.value = 'search';
						document.searchfrom.submit();
					}

					function clearSearch() {
						document.searchfrom.incident_date_from.value="";
						document.searchfrom.incident_date_to.value="";
						document.searchfrom.report_date_from.value="";
						document.searchfrom.report_date_to.value="";
<%if (ConstantsServerSide.isHKAH()) { %>
						document.searchfrom.equip.value="";
						//document.searchfrom.adr.value="";
						document.searchfrom.med.value="";
						document.searchfrom.patfall.value="";
						document.searchfrom.patgen.value="";
						document.searchfrom.bef.value="";
						document.searchfrom.stagen.value="";
						document.searchfrom.stafall.value="";

						document.searchfrom.secu.value="";
						document.searchfrom.vrofall.value="";
						document.searchfrom.vrogen.value="";
						document.searchfrom.oth.value="";
<%} else { %>

						document.searchfrom.equip.value="";
						document.searchfrom.increlopr.value="";
						document.searchfrom.bloodtrans.value="";
						document.searchfrom.med.value="";
						document.searchfrom.adr.value="";
						document.searchfrom.patfall.value="";

						document.searchfrom.patgen.value="";
						document.searchfrom.stagen.value="";
						document.searchfrom.stafall.value="";

						document.searchfrom.secu.value="";
						document.searchfrom.vrofall.value="";
						document.searchfrom.vrogen.value="";
						document.searchfrom.oth.value="";
<%} %>
						document.searchfrom.status.value="";
						document.searchfrom.pirID.value="";
						document.searchfrom.nearmiss.value="";
						document.searchfrom.ceomonth.value="";
						document.searchfrom.ceoyear.value="";
<%if (IsCeo) { %>
						document.searchfrom.ceopend.value="";
<%} %>
<%if (IsPIManager) { %>
						document.searchfrom.rejected.value="";
<%} %>
						$('select[name=status]').val('');
						$('select[name=nearmiss]').val('');

						document.searchfrom.command.value = 'clear';
						document.searchfrom.submit();
					}

					function createReport() {
						document.searchfrom.command.value = "";
						callPopUpWindow('incident_report.jsp');
						return false;
					}

					function createReport2() {
						document.searchfrom.command.value = "";
						callPopUpWindow('incident_report2.jsp');
						return false;
					}

					// Popup window code
					function newPopup(url) {
						popupWindow = window.open(
							url,'popUpWindow2','height=700,width=800,left=10,top=10,resizable=yes,scrollbars=yes,toolbar=yes,menubar=no,location=no,directories=no,status=yes')
					}

					function emailAlert(pirid,staffid) {
						if (confirm('Do you want to send email alert to responsible party ?')) {
							$.ajax({
								type: "POST",
								url: "email_alert.jsp",
								data: "pirid=" + pirid + "&staffid=" + staffid,
								success: function(values) {
									alert('Email sent.');
								}//success
							});//$.ajax
						}
						return false;
					}
				</script>
			</DIV>
		</DIV>
	</DIV>
	<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>