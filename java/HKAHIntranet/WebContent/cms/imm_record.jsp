<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="org.apache.struts.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%!
private static String getPatno( UserBean userBean ) {
	
	String staffId = userBean.getStaffID();
	return getPatno( staffId );
}

private static String getPatno( String staffId ) {
	
	String patno = null;
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT CO_HOSP_NO FROM CO_STAFFS ");
	sqlStr.append(" WHERE CO_STAFF_ID = UPPER(?) ");
	sqlStr.append(" AND CO_HOSP_NO IS NOT NULL ");

	ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(),  
			new String[] { staffId });

	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		patno = row.getValue(0);
	}
	return patno;
}

public static ArrayList getDiseaseList() {
	
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append(" SELECT DIS_CODE, DIS_NAME, DIS_CNAME "); 
	sqlStr.append(" FROM IMM_DISEASE ");
	sqlStr.append(" ORDER BY DIS_NAME ");

	return  UtilDBWeb.getReportableListCIS(sqlStr.toString());
}   

public static ArrayList getRecordList( String patno, String language ) {
	
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT  P.PATNO, P.PATFNAME || ', ' || P.PATGNAME, h.vac_date, ");	
	
	if ( "Chinese".equals(language) ) {
		sqlStr.append(" v.vac_cname, ");
	} else {
		sqlStr.append(" v.vac_name, ");
	}

	sqlStr.append(" IMM_DOSE_COUNT(H.PATNO, v.VAC_CODE, h.VAC_DATE, ?), h.CREATE_DATE, v.VAC_CODE, 'V' as TYPE ");
	sqlStr.append(" FROM  IMM_VAC_HIST h ");
	sqlStr.append(" inner join IMM_VACCINE v on v.vac_code = h.vac_code ");
	sqlStr.append(" inner join PATIENT@HAT P on P.PATNO = H.PATNO ");
	sqlStr.append(" WHERE H.PATNO = ? ");
	sqlStr.append(" UNION ");
	sqlStr.append(" SELECT  P.PATNO, P.PATFNAME || ', ' || P.PATGNAME, h.dis_date, ");
	
	if ( "Chinese".equals(language) ) {
		sqlStr.append(" d.dis_cname, ");
	} else {
		sqlStr.append(" d.dis_name, ");
	}
	
	sqlStr.append(" h.EVENT || ' ' || h.REMARK, h.CREATE_DATE, d.DIS_CODE, h.EVENT ");
	sqlStr.append(" FROM  IMM_DIS_HIST h ");
	sqlStr.append(" inner join IMM_DISEASE d on d.dis_code = h.dis_code");
	sqlStr.append(" inner join PATIENT@HAT P on P.PATNO = H.PATNO ");
	sqlStr.append(" WHERE H.PATNO = ? ");
	sqlStr.append(" ORDER BY VAC_DATE ");

	return  UtilDBWeb.getReportableListCIS(sqlStr.toString(),  
			new String[] { language, patno, patno });
}

public static ArrayList getRecordListByDisease( String code, String language ) {
	
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT P.PATNO, P.PATFNAME || ', ' || P.PATGNAME, h.vac_date, ");	
	if ( "Chinese".equals(language) ) {
		sqlStr.append(" v.vac_cname, ");
	} else {
		sqlStr.append(" v.vac_name, ");
	}
	sqlStr.append(" IMM_DOSE_COUNT(H.PATNO, v.VAC_CODE, h.VAC_DATE, ?), h.CREATE_DATE, v.VAC_CODE, 'V' as TYPE ");
	sqlStr.append(" FROM  IMM_VAC_HIST h ");
	sqlStr.append(" inner join IMM_VACCINE v on v.vac_code = h.vac_code ");
	sqlStr.append(" inner join IMM_VACCINE_DISEASE vd on H.vac_code = vd.vac_code ");
	sqlStr.append(" inner join PATIENT@HAT P on P.PATNO = H.PATNO ");
	sqlStr.append(" WHERE VD.DIS_CODE = ? ");
	sqlStr.append(" UNION ");
	sqlStr.append(" SELECT  P.PATNO, P.PATFNAME || ', ' || P.PATGNAME, h.dis_date, ");
	if ( "Chinese".equals(language) ) {
		sqlStr.append(" d.dis_cname, ");
	} else {
		sqlStr.append(" d.dis_name, ");
	}
	sqlStr.append(" h.EVENT || ' ' || h.REMARK, h.CREATE_DATE, d.DIS_CODE, h.EVENT ");
	sqlStr.append(" FROM  IMM_DIS_HIST h ");
	sqlStr.append(" inner join IMM_DISEASE d on d.dis_code = h.dis_code ");
	sqlStr.append(" inner join PATIENT@HAT P on P.PATNO = H.PATNO ");
	sqlStr.append(" WHERE H.DIS_CODE = ? ");
	sqlStr.append(" ORDER BY VAC_DATE ");

	return  UtilDBWeb.getReportableListCIS(sqlStr.toString(),  
			new String[] { language, code, code });
}

public static boolean delete(String patno, String code, String date, String type) {
		
	StringBuffer sqlStr = new StringBuffer();
	
	if ("V".equals(type)) {
		
		sqlStr.append("DELETE IMM_VAC_HIST ");
		sqlStr.append(" WHERE PATNO = ? ");  
		sqlStr.append(" AND VAC_CODE = ? ");
		sqlStr.append(" AND VAC_DATE = ? ");
		
		return UtilDBWeb.updateQueueCIS( sqlStr.toString(),
			new String[] { patno, code, date });
		
	} else {
		
		sqlStr.append("DELETE IMM_DIS_HIST ");
		sqlStr.append(" WHERE PATNO = ? ");
		sqlStr.append(" AND DIS_CODE = ? ");
		sqlStr.append(" AND DIS_DATE = ? ");
		sqlStr.append(" AND EVENT = ? ");
		
		return UtilDBWeb.updateQueueCIS( sqlStr.toString(), 
			new String[] { patno, code, date, type });
	}	
}

private static boolean getDiagnosed( String patno, String disCode) {
	
	String result = null;
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("SELECT * FROM IMM_DIS_HIST ");
	sqlStr.append(" WHERE PATNO = ? ");
	sqlStr.append(" AND DIS_CODE = ? ");
	sqlStr.append(" AND EVENT = 'Diagnosed' ");
	
	ArrayList record = UtilDBWeb.getReportableListCIS(sqlStr.toString(),  
		new String[] { patno, disCode });

	if (record.size() > 0) {
		return true;
	}
	return false;
}

private static boolean getDisHist( String patno, String disCode, String event ) {
	
	String result = null;
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT * FROM IMM_DIS_HIST ");
	sqlStr.append(" WHERE PATNO = ? ");
	sqlStr.append(" AND DIS_CODE = ? ");
	sqlStr.append(" AND EVENT = ? ");
	sqlStr.append(" AND REMARK = 'POSITIVE' ");
	
	ArrayList record = UtilDBWeb.getReportableListCIS(sqlStr.toString(),  
		new String[] { patno, disCode, event });

	if (record.size() > 0) {
		return true;
	}
	return false;
}

private static boolean getVacHist( String patno, String disCode, boolean full ) {
	
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT VAC_CODE FROM IMM_VACCINE_DISEASE ");
	sqlStr.append(" WHERE DIS_CODE = ? ");
	
	ArrayList vacList = UtilDBWeb.getReportableListCIS(sqlStr.toString(),  
		new String[] { disCode });
	
	for (int i = 0; i < vacList.size(); i++) {	
		
		ReportableListObject vacRow = (ReportableListObject)vacList.get(i);
		String vacCode = vacRow.getValue(0);
		int dose = 1;
		
		if (full) {
			try {
				sqlStr = new StringBuffer();
				sqlStr.append("SELECT DOSE_REQUIRE FROM IMM_VACCINE ");
				sqlStr.append(" WHERE VAC_CODE = ? ");
				
				ArrayList record = UtilDBWeb.getReportableListCIS(sqlStr.toString(),  
					new String[] { vacCode });
				
				if (record.size() > 0) {
					ReportableListObject row = (ReportableListObject) record.get(0);
					dose = Integer.parseInt(row.getValue(0));
				}
			} catch (Exception e) {
				e.printStackTrace();
				dose = 1;
			}	
		}
	
		sqlStr = new StringBuffer();
		sqlStr.append("SELECT COUNT(*) FROM IMM_VAC_HIST ");
		sqlStr.append(" WHERE PATNO = ? ");
		sqlStr.append(" AND VAC_CODE = ? ");
	
		ArrayList record = UtilDBWeb.getReportableListCIS(sqlStr.toString(),  
				new String[] { patno, vacCode });
	
		ReportableListObject row = (ReportableListObject) record.get(0);
		
		if (dose <= Integer.parseInt(row.getValue(0))) {
			return true;
		}
	}
	
	return false;
}

private static String getLastVacDate( String patno, String vacCode ) {
	
	String date = null;
	StringBuffer sqlStr = new StringBuffer();

	sqlStr = new StringBuffer();
	sqlStr.append("SELECT MAX(VAC_DATE) FROM IMM_VAC_HIST ");
	sqlStr.append(" WHERE PATNO = ? ");
	sqlStr.append(" AND VAC_CODE = ? ");

	ArrayList record = UtilDBWeb.getReportableListCIS(sqlStr.toString(),  
		new String[] { patno, vacCode });
	
	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		date = row.getValue(0);
	}
	return date;
}

public static ArrayList getDummy() {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT 1 FROM DUAL");
	return  UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);

Locale locale = (Locale) session.getAttribute( Globals.LOCALE_KEY);
String lang = locale.getDisplayLanguage();

String mode = request.getParameter("mode");
String command = request.getParameter("command");

String patno = null;
String staffId = null;
String name = null;
String disCode = null;

String message = request.getParameter("message");
String errorMessage = request.getParameter("errorMessage");

boolean accessable = true;

if ( "admin".equals(mode ) ) {
	accessable =  userBean.isAccessible("function.imm.view");
		
	staffId = request.getParameter("staffId");
	patno =  getPatno( staffId );
	name = StaffDB.getStaffName(staffId);
	
	if("report".equals(command) && accessable){
		
		String sex = null;
		String dob = null;
		
		ArrayList patRec = PatientDB.getPatInfo(patno);
		
		if (patRec.size() > 0) {
			ReportableListObject row = (ReportableListObject) patRec.get(0);
			sex = row.getValue(1);
			dob = row.getValue(10);
		} 
		
		boolean meaHist = getDiagnosed(patno, "MEA");
		boolean meaVac = getVacHist(patno, "MEA", false);
		boolean mumHist = getDiagnosed(patno, "MUM");
		boolean mumVac = getVacHist(patno, "MUM", false);
		boolean rubHist = getDiagnosed(patno, "RUB");
		boolean rubVac = getVacHist(patno, "RUB", false);
		boolean varHist = getDiagnosed(patno, "VAR");
		boolean varVac = getVacHist(patno, "VAR", false);
		boolean hbVac = getVacHist(patno, "HB", true);
		boolean hbsab_post = getDisHist(patno, "HB", "Post Vaccine Antibody Check");
		boolean hbsag = getDisHist(patno, "HB", "Antigen Test");
		boolean hbsab = getDisHist(patno, "HB", "Antibody Test");
		boolean fluVac = getVacHist(patno, "FLU", false);
		String fluDate = getLastVacDate(patno, "FLU");

		ArrayList record = getDummy();
		File reportFile = new File(application.getRealPath("/report/RPT_IMM_RECORD.jasper"));
		
		if (reportFile.exists()) {
			
			JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
			
			Map parameters = new HashMap();
			File reportDir = new File(application.getRealPath("/report/"));
			parameters.put("BaseDir", reportFile.getParentFile());
			parameters.put("PATNO", patno);
			parameters.put("NAME", name);
			parameters.put("DOB", dob);
			parameters.put("SEX", sex);
			parameters.put("MEA_HIST", meaHist);
			parameters.put("MEA_VAC", meaVac);
			parameters.put("MUM_HIST", mumHist);
			parameters.put("MUM_VAC", mumVac);
			parameters.put("RUB_HIST", rubHist);
			parameters.put("RUB_VAC", rubVac);
			parameters.put("VAR_HIST", varHist);
			parameters.put("VAR_VAC", varVac);
			parameters.put("HB_VAC", hbVac);
			parameters.put("HBSAG", hbsag);
			parameters.put("HBSAB", hbsab);
			parameters.put("HBSAB_POSTVAC", hbsab_post);
			parameters.put("FLU_VAC", fluVac);
			parameters.put("FLU_DATE", fluDate);
			JasperPrint jasperPrint =
				JasperFillManager.fillReport(
				jasperReport,
				parameters,
				new ReportListDataSource(record));
		
			request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
			OutputStream ouputStream = response.getOutputStream();
			response.setContentType("application/pdf");
			JRPdfExporter exporter = new JRPdfExporter();
	    	exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
	       	exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
	       	exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");

	       	exporter.exportReport();
	       	ouputStream.flush();
	       	ouputStream.close();
			return;
		}

	}
	
} else {
	patno =  getPatno( userBean );
	staffId = userBean.getStaffID();
	name = userBean.getUserName();
	
	String date = request.getParameter("date");
	String code = request.getParameter("code");
	String type = request.getParameter("type");
	
	if ("delete".equals(command)) {
		if (delete( patno, code, date, type))
			message = "Record deleted";
	} 
}

String searchBy =  request.getParameter("searchBy");
System.out.println("searchBy=" + searchBy);
if ("disease".equals(searchBy)) {
	disCode =  request.getParameter("disCode");

	System.out.println("searchBy=" + disCode);
	request.setAttribute("record", getRecordListByDisease(disCode, lang));
} else {
	request.setAttribute("record", getRecordList(patno, lang));
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
	<jsp:param name="pageTitle" value="Immunization Status Record" />
</jsp:include> 
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="form1" id="form1" action="imm_record.jsp" method="post">

<table cellpadding="0" cellspacing="5" border="0"  width="100%">
<% if ("admin".equals(mode)) { %>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><input type="radio" id="rbStaff" name="searchBy" value="staff" <%="staff".equals(searchBy)?"checked":"" %> ><bean:message key="prompt.staffID" /></td>
		<td class="infoData" width="80%"><input type="textfield" name="staffId" id="staffId" value="<%=staffId==null?"":staffId %>" maxlength="8" size="8" /></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><input type="radio" id="rbDisease" name="searchBy" value="disease" <%="disease".equals(searchBy)?"checked":"" %> ><bean:message key="prompt.imm.disease" /></td>
		<td class="infoData" width="80%">
			<select name="disCode" id="disCode">
			<%
			ArrayList rec = getDiseaseList();
			ReportableListObject row = null;
			
			int j = 1;
			
			if ("Chinese".equals(lang))
				j = 2; 
			
			for (int i = 0; i < rec.size(); i++) {	
				row = (ReportableListObject)rec.get(i);
				
			%>		
				<option value="<%=row.getValue(0) %>" <%=row.getValue(0).equals(disCode)?"selected":"" %> ><%=row.getValue(j) %></option>
			<%
			}
			%>			
			</select>
		</td>
	</tr>
<%} %>	
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.patNo" /></td>
		<td class="infoData" width="80%"><%=patno==null?"":patno %></td>
	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="20%"><bean:message key="prompt.staffName" /></td>
		<td class="infoData" width="80%"><%=name==null?"":name %></td>
	</tr>
</table>
<br/>
<% if ("admin".equals(mode)) { %>
	<button id="btnSearch"><bean:message key="button.search" /></button>
	<button id="btnPrint">Print Individual Immunization Record</button>
<% } else {%> 
	<button id="btnCovid" class="declare"><bean:message key="button.imm.covid" /></button>
	<button id="btnVaccine" class="declare"><bean:message key="button.imm.vaccine" /></button>
	<button id="btnInfection" class="declare"><bean:message key="button.imm.disease" /></button>
<% } %> 
<br/>
<display:table id="tab" name="requestScope.record" class="tablesorter" export="true">
	<display:column property="fields0" titleKey="prompt.patNo" style="width:10%" />
	<display:column property="fields1" titleKey="prompt.name" style="width:20%" />
	<display:column property="fields2" titleKey="prompt.date" style="width:10%" />
	<display:column property="fields3" titleKey="prompt.imm.vaccine.and.disease.history" style="width:20%" />	
	<display:column property="fields4" titleKey="prompt.status" style="width:20%" />
	<display:column property="fields5" titleKey="eshare.entryDate" style="width:10%" />	
<% if (!"admin".equals(mode)) { %>		
	<display:column titleKey="prompt.action" media="html" style="width:10%; text-align:center">
		<button onclick="return deleteAction('<c:out value="${tab.fields2}" />','<c:out value="${tab.fields6}" />','<c:out value="${tab.fields7}" />');"><bean:message key='button.delete' /></button>
	</display:column>
<% } %> 	
</display:table>

<input type="hidden" name="command" id="command" />
<input type="hidden" name="patno" id="patno" value="<%=patno==null?"":patno %>" /> 
<input type="hidden" name="mode" id="mode" value="<%=mode==null?"":mode %>" /> 
<input type="hidden" name="date" id="date" /> 
<input type="hidden" name="code" id="code" />  
<input type="hidden" name="type" id="type" />  
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
	<% if (!accessable) { %>
	alert("Access Deny!");
	window.close();
	<% } %>
	
	if ( $( "#mode" ).val() == "admin" ) {
		$('#disCode').attr({'disabled': 'disabled'});
		$('#staffId').attr({'disabled': 'disabled'});
		$('#btnPrint').attr({'disabled': 'disabled'});
		
		if ($('#rbStaff').is(":checked")) { 
			$("#staffId").removeAttr('disabled');
			$("#btnPrint").removeAttr('disabled');
		}
		
		if ($('#rbDisease').is(":checked")) { 
			$("#disCode").removeAttr('disabled');
		}
		
	} else {
		if ( $( "#patno" ).val() == "" ) {
			alert("Hospital Number not found");
			
			$(".declare").attr({
		    	'disabled': 'disabled'
		    });
		}
		
		$("#staffId").attr({
	    	'disabled': 'disabled'
	    });
	}
		
	$("#btnCovid").click(function() {
		callPopUpWindow("imm_covid.jsp");
		return false;
    });
	
	$("#btnVaccine").click(function() {
		callPopUpWindow("imm_vaccine.jsp");
		return false;
    });
	
	$("#btnInfection").click(function() {
		callPopUpWindow("imm_disease.jsp");
		return false;
    });
	
	$("#btnPrint").click(function() {
		$("#command").val("report");
    });
	
	$("#btnSearch").click(function() {
		$("#command").val("");
    });
	
	$("#rbStaff").click(function(){
		$("#staffId").removeAttr('disabled');
		$('#disCode').attr({'disabled': 'disabled'});
	}); 

	$("#rbDisease").click(function(){
		$("#disCode").removeAttr('disabled');
		$('#staffId').val("");
		$('#staffId').attr({'disabled': 'disabled'});
		$('#btnPrint').attr({'disabled': 'disabled'});
	});

});

function deleteAction(date, code, type) {
	$("#command").val("delete");
	$("#date").val(date);
	$("#code").val(code);
	$("#type").val(type); 
	$("#form1").submit();
}
-->
</script>
</DIV>
</DIV>
</DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>

</html:html>
