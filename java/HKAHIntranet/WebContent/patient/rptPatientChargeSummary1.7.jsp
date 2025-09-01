<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ page import="java.text.SimpleDateFormat"%>
<%!
public static ArrayList getPatientChargeSummaryReport(String siteCode, String dischargeDateFrom, String dischargeDateTo) {
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("select ");
	sqlStr.append("  dr.doccode DOCCODE,");
	sqlStr.append("  dr.doccode_s DOCCODE_SLIP,");
	sqlStr.append("  dr.DOCFNAME,");
	sqlStr.append("  dr.DOCGNAME,");
	sqlStr.append("  s.REGTYPE,");
	sqlStr.append("  s.SDSCODE,");
	sqlStr.append("  s.SDSDESC,");
	sqlStr.append("  s.ACMNAME,");
	sqlStr.append("  s.LOS,");
	sqlStr.append("  s.DISCH_DATE,");
	sqlStr.append("  s.PATNO,");
	sqlStr.append("  s.PATFNAME,");
	sqlStr.append("  s.PATGNAME,");
	sqlStr.append("  s.DR_FEE,");
	sqlStr.append("  -1, "); //--s.OTHER_DR,
	sqlStr.append("  -1, "); //--s.OTHER_DR_FEE,
	sqlStr.append("  -1, "); //--s.HAS_ANES_ITEM,
	sqlStr.append("  s.HOSP_FEE,");
	sqlStr.append("  nvl(s.DR_FEE, 0) + nvl(s.HOSP_FEE, 0) TOTAL,");
	sqlStr.append("  dr.TITLE,");
	sqlStr.append("  dr.ADD1,");
	sqlStr.append("  dr.ADD2,");
	sqlStr.append("  dr.ADD3,");
	sqlStr.append("  dr.ADD4 ");
	sqlStr.append("from ");	
	sqlStr.append("( ");
	
	sqlStr.append("select  ");
	sqlStr.append("  r.regid, ");
	sqlStr.append("  s.doccode \"DOCCODE\", ");
	sqlStr.append("  inp.doccode_a \"DOCCODE_A\", ");
	sqlStr.append("  d.docfname \"DOCFNAME\", ");
	sqlStr.append("  d.docgname \"DOCGNAME\", ");
	sqlStr.append("  r.regtype \"REGTYPE\", ");
	sqlStr.append("  CASE WHEN r.regtype = 'D' THEN dayp.sdscode ELSE inp.sdscode END \"SDSCODE\", ");
	sqlStr.append("  CASE WHEN r.regtype = 'D' THEN sd2.sdsdesc ELSE sd.sdsdesc END \"SDSDESC\", ");
	sqlStr.append("  a.acmname \"ACMNAME\", ");
	//sqlStr.append("  --r.regdate \"REGDATE\", ");
	sqlStr.append("  CASE WHEN r.regtype = 'D' THEN '1' ELSE to_char(TRUNC(Inp.INPDDATE) - TRUNC(R.REGDATE) + 1) END \"LOS\", ");
	//sqlStr.append("  --inp.inpid \"INPID\", ");
	sqlStr.append("  CASE WHEN r.regtype = 'D' THEN to_char(r.regdate, 'dd/mm/yyyy') ELSE to_char(inp.inpddate, 'dd/mm/yyyy') END \"DISCH_DATE\", ");
	sqlStr.append("  r.patno \"PATNO\", ");
	sqlStr.append("  p.patfname \"PATFNAME\", ");
	sqlStr.append("  p.patgname \"PATGNAME\", ");
	//sqlStr.append("  -- doctor charges ");
	sqlStr.append("  to_char(SUM(CASE WHEN tx.itmtype = 'D' THEN tx.stnnamt ELSE 0 END)) \"DR_FEE\", ");
	//sqlStr.append("  -- hospital charges (-ve for discount) ");
	sqlStr.append("  to_char(SUM(case when (('" + siteCode.toLowerCase() + "' = 'hkah' and tx.itmtype = 'H') or ('" + siteCode.toLowerCase() + "' = 'twah' and tx.itmtype in ('H', 'S'))) then tx.stnnamt ELSE 0 end)) \"HOSP_FEE\" ");
	sqlStr.append("from  ");
	sqlStr.append("  reg@iweb r ");
	sqlStr.append("  join slip@iweb s on r.regid = s.regid ");
	sqlStr.append("  left join inpat@iweb inp on r.inpid = inp.inpid ");
	sqlStr.append("  left join daypat@iweb dayp on r.daypid = dayp.daypid ");
	sqlStr.append("  join sliptx@iweb tx on s.slpno = tx.slpno ");
	sqlStr.append("  join item@iweb itm on tx.itmcode = itm.itmcode ");
	sqlStr.append("  join patient@iweb p on r.patno = p.patno ");
	sqlStr.append("  join doctor@iweb d on s.doccode = d.doccode ");
	sqlStr.append("  left join acm@iweb a on inp.acmcode = a.acmcode ");
	sqlStr.append("  left join sdisease@iweb sd on inp.sdscode = sd.sdscode ");
	sqlStr.append("  left join sdisease@iweb sd2 on dayp.sdscode = sd2.sdscode ");
	sqlStr.append("  left join patcat@iweb pc on s.pcyid = pc.pcyid ");
	sqlStr.append("where ");
	sqlStr.append("1=1 ");
	//sqlStr.append("-- filter only itmtype D, H ");
	sqlStr.append("and tx.itmtype in ('D', 'H', 'S') ");
	//sqlStr.append("-- filter out payment items ");
	sqlStr.append("and tx.itmcode not in ('PAYME', 'REF') ");
	//sqlStr.append("-- filter out deposit items ");
	sqlStr.append("and itm.itmcat <> 'O' ");
	//sqlStr.append("-- filter by inp(hk)/daycase(tw) ");
	sqlStr.append("and (('" + siteCode.toLowerCase() + "' = 'hkah' and r.regtype = 'I') or ('" + siteCode.toLowerCase() + "' = 'twah' and r.regtype in ('I', 'D'))) ");
	//sqlStr.append("-- filter by discharge date ");
	sqlStr.append("and ");
	sqlStr.append("	( ");
	sqlStr.append("		(r.regtype = 'I' and inp.inpddate between to_date('" + dischargeDateFrom + "', 'dd/mm/yyyy') and to_date('" + dischargeDateTo + "', 'dd/mm/yyyy') +1) or ");
	sqlStr.append("		(r.regtype = 'D' and r.regdate between to_date('" + dischargeDateFrom + "', 'dd/mm/yyyy') and to_date('" + dischargeDateTo + "', 'dd/mm/yyyy') +1) ");
	sqlStr.append("	) ");
	//sqlStr.append("-- filter by normal reg, slip and sliptx ");
	sqlStr.append("and r.regsts in ('N') ");
	sqlStr.append("and s.slpsts in ('A', 'C') ");
	sqlStr.append("and tx.stnsts in ('N', 'A', 'P') ");
	//sqlStr.append("-- filter out patient cateogory: charity ");	
	sqlStr.append("and (('" + siteCode.toLowerCase() + "' = 'hkah' and (s.pcyid is null or pc.pcycode not in ('CH'))) or ('" + siteCode.toLowerCase() + "' = 'twah' and s.slpno not in (select slpno from sliptx@iweb where itmcode in ('MSCHT') and stnsts = 'N'))) ");
	sqlStr.append("group by r.regid, s.doccode, inp.doccode_a, d.docfname, d.docgname, r.regtype, inp.sdscode, dayp.sdscode, sd.sdsdesc, sd2.sdsdesc, a.acmname, r.regdate, TRUNC(Inp.INPDDATE) - TRUNC(R.REGDATE) + 1, inp.inpddate, r.patno, p.patfname, p.patgname ");
	sqlStr.append(") s ");
	
	sqlStr.append("join ");
	
	sqlStr.append("(");
	sqlStr.append("	select");
	sqlStr.append("	  distinct");
	sqlStr.append("	  txd.regid,");
	sqlStr.append("	  d.doccode,");
	sqlStr.append("	  txd.doccode_s,");
	sqlStr.append("	  d.docfname,");
	sqlStr.append("	  d.docgname,");
	sqlStr.append("   d.tittle TITLE, ");
	sqlStr.append("   decode(d.RPTTO,NULL,'','C',d.DOCADD1,'H',d.DOCHOMADD1,'O',d.DOCOFFADD1) ADD1, ");
	sqlStr.append("   decode(d.RPTTO,NULL,'','C',d.DOCADD2,'H',d.DOCHOMADD2,'O',d.DOCOFFADD2) ADD2, ");
	sqlStr.append("   decode(d.RPTTO,NULL,'','C',d.DOCADD3,'H',d.DOCHOMADD3,'O',d.DOCOFFADD3) ADD3, ");
	sqlStr.append("   decode(d.RPTTO,NULL,'','C',d.DOCADD4,'H',d.DOCHOMADD4,'O',d.DOCOFFADD4) ADD4 ");
	sqlStr.append("	from");
	sqlStr.append("	(");
	sqlStr.append("	  select ");
	sqlStr.append("		distinct");
	sqlStr.append("		r.regid,");
	sqlStr.append("		d.doccode doccode_tx,");
	sqlStr.append("		s.doccode doccode_s,");
	sqlStr.append("		inp.DOCCODE_A");
	sqlStr.append("	  from ");
	sqlStr.append("		reg@iweb r");
	sqlStr.append("		join slip@iweb s on r.regid = s.regid");
	sqlStr.append("		join sliptx@iweb tx on s.slpno = tx.slpno");
	sqlStr.append("		join item@iweb itm on tx.itmcode = itm.itmcode");
	sqlStr.append("		join doctor@iweb d on tx.doccode = d.doccode");
	sqlStr.append("		left join inpat@iweb inp on r.inpid = inp.inpid");
	sqlStr.append("		left join patcat@iweb pc on s.pcyid = pc.pcyid");
	sqlStr.append("	  where");
	sqlStr.append("		1=1");
	sqlStr.append("		and r.regsts in ('N')");
	sqlStr.append("		and s.slpsts in ('A', 'C')");
	sqlStr.append("		and tx.stnsts in ('N', 'A', 'P')");
	sqlStr.append("		and tx.itmtype in ('D', 'H', 'S')");
	sqlStr.append("		and itm.itmcat <> 'O'");
	sqlStr.append("		and tx.itmcode not in ('PAYME', 'REF')");
	sqlStr.append("		and (('" + siteCode.toLowerCase() + "' = 'hkah' and r.regtype = 'I') or ('" + siteCode.toLowerCase() + "' = 'twah' and r.regtype in ('I', 'D')))");
	sqlStr.append("		and ");
	sqlStr.append("		  (");
	sqlStr.append("		   (r.regtype = 'I' and inp.inpddate between to_date('" + dischargeDateFrom + "', 'dd/mm/yyyy') and to_date('" + dischargeDateTo + "', 'dd/mm/yyyy') +1) or");
	sqlStr.append("		   (r.regtype = 'D' and r.regdate between to_date('" + dischargeDateFrom + "', 'dd/mm/yyyy') and to_date('" + dischargeDateTo + "', 'dd/mm/yyyy') +1)");
	sqlStr.append("		  )");
	sqlStr.append("		and (('" + siteCode.toLowerCase() + "' = 'hkah' and (s.pcyid is null or pc.pcycode not in ('CH'))) or ('" + siteCode.toLowerCase() + "' = 'twah' and s.slpno not in (select slpno from sliptx@iweb where itmcode in ('MSCHT') and stnsts = 'N')))");
	sqlStr.append("		and (('" + siteCode.toLowerCase() + "' = 'hkah' and d.spccode <> 'ANAES') or ('" + siteCode.toLowerCase() + "' = 'twah' and d.spccode <> 'AN'))");
	sqlStr.append("	) txd ");
	sqlStr.append("	join doctor@iweb d on txd.doccode_s = d.doccode or txd.doccode_a = d.doccode or txd.doccode_tx = d.doccode ");
	sqlStr.append(") dr on s.regid = dr.regid ");
	sqlStr.append("where dr.DOCCODE is not null ");
	sqlStr.append("order by dr.DOCFNAME, dr.DOCGNAME, dr.doccode, s.REGTYPE desc, s.sdscode, s.ACMNAME, s.LOS, s.DISCH_DATE");
	
	System.out.println("[rptPatientChartSummary] sql=" + sqlStr.toString());

	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);

String command = ParserUtil.getParameter(request, "command");
String dischargeDateFrom = request.getParameter("dischargeDateFrom");
String dischargeDateTo = request.getParameter("dischargeDateTo");

String site = ConstantsServerSide.SITE_CODE.toLowerCase();
String message = request.getParameter("message");
if (message == null) {
	message = "";
}
String errorMessage = "";
File reportFile = null;

SimpleDateFormat tsFormat = new SimpleDateFormat("yyyyMMddHHmmss");

if("view".equals(command)){
	//ArrayList list = PatientDB.getPatientChargeSummaryReport(site, dischargeDateFrom, dischargeDateTo);
	ArrayList list = getPatientChargeSummaryReport(site, dischargeDateFrom, dischargeDateTo);
	
	/*
	// debug
	for (int i = 0; i < list.size(); i++) {
		ReportableListObject row = (ReportableListObject) list.get(i);
		System.out.print("row " + i + " - ");
		for (int j = 0; j < 24; j++) {
			String doccode = row.getValue(0);
			String patno = row.getValue(9);
			String total = row.getValue(17);
			
			String val = row.getValue(j);
			
			//System.out.println("row:" + i + ", doccode["+doccode+"] patno[" + patno + "] total[" + total + "]");
			System.out.print(j + ":["+val+"]");
		}
		System.out.println();
	}
	*/

	reportFile = new File(application.getRealPath("/report/RPT_PAT_CHARGE_SUMMARY.jasper"));
	ReportListDataSource report = null;

	if (reportFile != null && reportFile.exists()) {
		String siteDesc = "hkah";
		if(ConstantsServerSide.isHKAH()){
			siteDesc = "hkah-sr";
		} else if(ConstantsServerSide.isTWAH()){
			siteDesc = "hkah-tw";
		}
		String fileName = "patient_charge_summary_" + siteDesc + "_" + 
			(dischargeDateFrom == null ? "" : dischargeDateFrom.replaceAll("/", "")) + "_" + 
			(dischargeDateTo == null ? "" : dischargeDateTo.replaceAll("/", "")) + ".pdf";
		
		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
		
		Map parameters = new HashMap();
		parameters.put("BaseDir", reportFile.getParentFile());
		parameters.put("in_stecode", site);
		parameters.put("in_datefrom", dischargeDateFrom);
		parameters.put("in_dateto", dischargeDateTo);
		
		JasperPrint jasperPrint =
			JasperFillManager.fillReport(
				jasperReport,
				parameters,
				new ReportMapDataSource(list, new String[]{
					"DOCCODE",
					"DOCCODE_SLIP",
					"DOCFNAME",
					"DOCGNAME",
					"REGTYPE",
					"SDSCODE",
					"SDSDESC",
					"ACMNAME",
					"LOS",
					"DISCH_DATE",
					"PATNO",
					"PATFNAME",
					"PATGNAME",
					"DR_FEE",
					"OTHER_DR",
					"OTHER_DR_FEE",
					"HAS_ANES_ITEM",
					"HOSP_FEE",
					"TOTAL",
					"TITLE",
					"ADD1",
					"ADD2",
					"ADD3",
					"ADD4"
				},
				null));	
				
		request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
		OutputStream ouputStream = response.getOutputStream();
		response.setContentType("application/pdf");
		JRPdfExporter exporter = new JRPdfExporter();
		response.setHeader("Content-Disposition", "attachment;filename=" + fileName);
		exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
		exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
		exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");
		
		exporter.exportReport();
		//return;	
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

<html:html xhtml="true" lang="true">
<style>
.remark {
	padding: 5px;
	background: #f9edbe;
	border: 1px solid #f0c36d;
	border-radius: 2px;
	-moz-border-radius: 2px;
	-webkit-border-radius: 2px;
	box-shadow: 0 2px 4px rgba(0,0,0,0.2);
}
</style>
	<jsp:include page="../common/header.jsp"/>
	<body>
		<div id=indexWrapper>
			<div id=mainFrame>
				<jsp:include page="../common/page_title.jsp" flush="false">
					<jsp:param name="pageTitle" value="function.rptPatientChargeSummary.report" />
					<jsp:param name="category" value="group.report" />
				</jsp:include>
				
				<font color="blue"><%=message %></font>
				<font color="red"><%=errorMessage %></font>
				<div class="remark">
					It may take several minutes to generate a report for one-month period. 
				</div>
				<form name="rptPatientChargeSummaryForm" action="rptPatientChargeSummary.jsp" method="get">
					<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0">
						<tr class="smallText">
							<td class="infoLabel" width="15%">
								Discharge Date
							</td>
							<td class="infoData" width="35%">
								From 
								<input type="textfield" name="dischargeDateFrom" id="dischargeDateFrom" 
									class="datepickerfield" value="<%=dischargeDateFrom==null?"":dischargeDateFrom %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/>
								to 
								<input type="textfield" name="dischargeDateTo" id="dischargeDateTo" 
									class="datepickerfield" value="<%=dischargeDateTo==null?"":dischargeDateTo %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/> (DD/MM/YYYY)
							</td>							
							<td width="20%">
								<button onclick="return submitReport('view');"><bean:message key="button.doc.view" /></button>
								<input type="hidden" name="command" />
							</td>							
						</tr>
					</table>
				</form>
				
				<bean:define id="functionLabel">
					<bean:message key="function.rptPatientChargeSummary.report" />
				</bean:define>
				<bean:define id="notFoundMsg">
					<bean:message key="message.notFound" arg0="<%=functionLabel %>" />
				</bean:define>
						
				<script language="javascript">
					function submitReport(cmd) {
						if (document.rptPatientChargeSummaryForm.dischargeDateFrom.value == '') {
							alert('Please enter Discharge Date period.');
							document.rptPatientChargeSummaryForm.dischargeDateFrom.focus();
							return false;
						}
						if (document.rptPatientChargeSummaryForm.dischargeDateTo.value == '') {
							alert('Please enter Discharge Date period.');
							document.rptPatientChargeSummaryForm.dischargeDateTo.focus();
							return false;
						}
							
						document.rptPatientChargeSummaryForm.command.value = cmd;
						document.rptPatientChargeSummaryForm.submit();	
						
						showLoadingBox('body', 500, $(window).scrollTop());
						return false;
					}
				
					function clearSearch() {
						document.rptPatientChargeSummaryForm.dischargeDateFrom.value="";
						document.rptPatientChargeSummaryForm.dischargeDateTo.value="";
					}				
				</script>
			</div>
		</div>
		
		<jsp:include page="../common/footer.jsp" flush="false" />
	</body>
</html:html>