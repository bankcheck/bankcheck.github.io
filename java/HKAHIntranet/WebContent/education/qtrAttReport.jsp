<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.util.ArrayList.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="java.io.*"%>
<%
UserBean userBean = new UserBean(request);

String[] current_year = DateTimeUtil.getCurrentYearRange();
String[] current_month = DateTimeUtil.getCurrentMonthRange();
String curent_date = DateTimeUtil.getCurrentDate();

String site = request.getParameter("site"); 
StringBuffer sqlStr = new StringBuffer();
String Year = request.getParameter("Year_yy");
String Quarter = request.getParameter("Quarter");
String quarterStart = null;
String quarterEnd = null;

ArrayList record = null;

if (Year != null && Quarter != null) {
	if("1st".equals(Quarter)){
		quarterStart = "01/01/";
		quarterEnd = "31/03/";
	}else if ("2nd".equals(Quarter)){
		quarterStart = "01/01/";
		quarterEnd = "30/06/";
	}else if ("3rd".equals(Quarter)){
		quarterStart = "01/01/";
		quarterEnd = "30/09/";
	}else if ("4th".equals(Quarter)){
		quarterStart = "01/01/";
		quarterEnd = "31/12/";
	}
//=================
// HKAH PRODUCTION
//=================
if(ConstantsServerSide.isHKAH()){
	sqlStr.append("select ");
	sqlStr.append("d.co_department_desc,");
	sqlStr.append("(select CO_STAFFNAME from co_staffs where CO_STAFF_ID = d.CO_DEPARTMENT_HEAD)as headName ,");
	sqlStr.append("  e_1 e_1_a, dep_tot e_1_s, round(e_1/dep_tot*100,2) e_1_per,");
	sqlStr.append("  e_2 e_2_a, dep_tot e_2_s, round(e_2/dep_tot*100,2) e_2_per,");
	sqlStr.append("  e_3 e_3_a, dep_tot e_3_s, round(e_3/dep_tot*100,2) e_3_per,");
	sqlStr.append("  e_4 e_4_a, dep_tot e_4_s, round(e_4/dep_tot*100,2) e_4_per,");
	sqlStr.append("  e_5 e_5_a, dep_tot e_5_s, round(e_5/dep_tot*100,2) e_5_per,");
	sqlStr.append("  e_6 e_6_a, dep_tot e_6_s, round(e_6/dep_tot*100,2) e_6_per,");
	sqlStr.append("  e_7 e_7_a, dep_tot e_7_s, round(e_7/dep_tot*100,2) e_7_per,");
	sqlStr.append("  e_8 e_8_a, dep_tot e_8_s, round(e_8/dep_tot*100,2) e_8_per,");
	sqlStr.append("  d.co_department_category,  d.co_department_code ");
	sqlStr.append("  from");
	sqlStr.append("( select co_department_code,"); 
	sqlStr.append("          sum(e_1) e_1, sum(e_2) e_2, sum(e_3) e_3, sum(e_4) e_4,");
	sqlStr.append("          sum(e_5) e_5,sum(e_6) e_6,sum(e_7) e_7,sum(e_8) e_8 from (");
	sqlStr.append("    select co_department_code,decode(co_event_id,1010,1,0) as e_1, decode(co_event_id,1040,1,0) as e_2,");
	sqlStr.append("    decode(co_event_id,1030,1,0) as e_3, decode(co_event_id,1070,1,0) as e_4,");
	sqlStr.append("    decode(co_event_id,1020,1,0) as e_5,decode(co_event_id,1050,1,0) as e_6,");
	sqlStr.append("     DECODE(co_event_id,'1060',1,0) AS e_7,decode(co_event_id,1110,1,0) as e_8 ");
	sqlStr.append("	from ( select distinct co_user_id, co_event_id from co_enrollment where CO_ATTEND_DATE >= TO_DATE('"+quarterStart+Year+"','dd/mm/yyyy') ");
	sqlStr.append("	AND CO_ATTEND_DATE <= TO_DATE('"+quarterEnd+Year+"','dd/mm/yyyy') AND co_enabled = 1 )"); 
	sqlStr.append("    right join (select * from co_staffs where co_enabled = 1 ");
	sqlStr.append(" AND CO_STATUS not like 'CA' AND CO_STAFF_ID NOT LIKE 'DR%' AND CO_STAFF_ID NOT LIKE '9%'AND CO_STAFF_ID <> 'IPD' AND co_site_code  = 'hkah' AND co_site_code IS NOT NULL AND co_department_code <> '880' ) on co_user_id = co_staff_id)");         
	sqlStr.append("    group by co_department_code ) a");
	sqlStr.append("  left join ( select co_department_code,count(1) dep_tot from co_staffs where co_enabled = 1 "); 
	sqlStr.append(" AND CO_STATUS not like 'CA' AND CO_STAFF_ID NOT LIKE 'DR%' AND CO_STAFF_ID NOT LIKE '9%' AND CO_STAFF_ID <> 'IPD' AND co_site_code  = 'hkah' AND co_site_code IS NOT NULL AND co_department_code <> '880' group by co_department_code ) b on a.co_department_code = b.co_department_code");
	sqlStr.append("  join (select * from co_departments where co_department_category is not null and co_department_code not like '9%' and co_department_code <>'400' ) d");
	sqlStr.append("    on a.co_department_code = d.co_department_code");
	sqlStr.append("  order by d.co_department_category, d.co_department_code"); 
}

//=================
// twah production
//=================
if(ConstantsServerSide.isTWAH()){
sqlStr.append("select ");
sqlStr.append("  d.co_department_desc || ' (' || d.co_department_code || ')' ,");
sqlStr.append("d.CO_DEPARTMENT_HEAD,");
sqlStr.append("  e_1 e_1_a, dep_tot e_1_s, round(e_1/dep_tot*100,2) e_1_per,");
sqlStr.append("  e_2 e_2_a, dep_tot e_2_s, round(e_2/dep_tot*100,2) e_2_per,");
sqlStr.append("  e_3 e_3_a, dep_tot e_3_s, round(e_3/dep_tot*100,2) e_3_per,");
sqlStr.append("  e_4 e_4_a, dep_tot e_4_s, round(e_4/dep_tot*100,2) e_4_per,");
//sqlStr.append("  MH MH_a, dep_tot MH_s, round(MH/dep_tot*100,2) MH_per,");
sqlStr.append("  e_5 e_5_a, dep_tot e_5_s, round(e_5/dep_tot*100,2) e_5_per,");
sqlStr.append("  e_6 e_6_a, dep_tot e_6_s, round(e_6/dep_tot*100,2) e_6_per,");
sqlStr.append("  e_7 e_7_a, dep_tot e_7_s, round(e_7/dep_tot*100,2) e_7_per,");
sqlStr.append("  e_8 e_8_a, dep_tot e_8_s, round(e_8/dep_tot*100,2) e_8_per,");
sqlStr.append("  d.co_department_category");
sqlStr.append("  from");
sqlStr.append("( select co_department_code,"); 
sqlStr.append("          sum(e_1) e_1, sum(e_2) e_2, sum(e_3) e_3, sum(e_4) e_4,");
//sqlStr.append("			 sum(MH) MH, ");
sqlStr.append("          sum(e_5) e_5,sum(e_6) e_6,sum(e_7) e_7,sum(e_8) e_8 from (");
sqlStr.append("    select co_department_code,decode(co_event_id,1010,1,0) as e_1, decode(co_event_id,1020,1,1025,1,0) as e_2,");
sqlStr.append("    decode(co_event_id,1070,1,0) as e_3, decode(co_event_id,1030,1,0) as e_4,");
//sqlStr.append("    decode(co_event_id,1070,1,1030,1,0) as MH,");
sqlStr.append("    decode(co_event_id,1040,1,1041,1,0) as e_5,decode(co_event_id,1042,1,1045,1,0) as e_6,");
sqlStr.append("     DECODE(co_event_id,'1080',1,'6020',1,0) AS e_7,decode(co_event_id,1060,1,0) as e_8 from ( select distinct co_user_id, co_event_id from co_enrollment where CO_ATTEND_DATE >= TO_DATE('"+quarterStart+Year+"','dd/mm/yyyy') AND CO_ATTEND_DATE <= TO_DATE('"+quarterEnd+Year+"','dd/mm/yyyy') AND co_enabled = 1 AND co_user_id not in ('21032','21044'))"); 
sqlStr.append("    right join (select * from co_staffs where co_enabled = 1 and co_staff_id not in ('21032','21044')AND CO_STATUS not like 'CAS' AND co_site_code  = 'twah' AND co_site_code IS NOT NULL  ) on co_user_id = co_staff_id)");         
sqlStr.append("    group by co_department_code ) a");
sqlStr.append("  left join ( select co_department_code,count(1) dep_tot from co_staffs where co_enabled = 1 AND CO_STAFF_ID NOT LIKE 'se%' AND co_site_code  = 'twah' AND co_site_code IS NOT NULL group by co_department_code ) b on a.co_department_code = b.co_department_code");
sqlStr.append("  join (select * from co_departments where co_department_category is not null) d");
sqlStr.append("    on a.co_department_code = d.co_department_code");
sqlStr.append("  order by d.co_department_category, d.co_department_code"); 
}   
System.out.println("DEBUG: sql = " + sqlStr.toString());
record = UtilDBWeb.getReportableList(sqlStr.toString());
//jasper report

if (record.size() > 0) {
	
	File reportFile = new File(application.getRealPath("/report/quarter_dept_staff_attendance.jasper"));
	if (reportFile.exists()) {
		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());

		Map parameters = new HashMap();
		parameters.put("BaseDir", reportFile.getParentFile());
		parameters.put("Year", Year);
		parameters.put("Quarter", Quarter);
		parameters.put("Site",ConstantsServerSide.SITE_CODE);


		JasperPrint jasperPrint =
			JasperFillManager.fillReport(
				jasperReport,
				parameters,
				new ReportListDataSource(record) {
					public Object getFieldValue(int index) throws JRException {
						String value = (String) super.getFieldValue(index);

						return value;
					}
				});


		request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
		OutputStream ouputStream = response.getOutputStream();
		response.setHeader("Content-disposition","filename="+ "report.xls" ); 
		response.setContentType("application/vnd.ms-excel");
		JRXlsExporter exporter = new JRXlsExporter();
        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
        exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");

        exporter.exportReport();
		return;
	}
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
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<%String PageTitle = "Mandatory In-service Education Attendance Report"; %>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=PageTitle %>" />
	<jsp:param name="category" value="Report" />
</jsp:include>

<form name="search_form" action="qtrAttReport.jsp" method="post">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="bigText">
		<td  width="30%"></td>
		<td  width="70%" align="center">Mandatory In-service Education Department Staff Attendance Report</td>

	</tr>
	<tr class="smallText">
		<td class="infoLabel" width="30%"><bean:message key="prompt.year" /></td>
		<td class="infoData" width="70%">
		<jsp:include page="../ui/dateCMB.jsp" flush="false">
			<jsp:param name="label" value="Year" />
			<jsp:param name="isYearOnly" value="Y" />
		</jsp:include>
		</td>
	</tr>
	<tr class="smallText">
	<td class="infoLabel" width="30%">Quarter</td>
	<td class="infoData" width="70%">
	<select name="Quarter">
		<option value="1st">1st Quarter</option>
		<option value="2nd">2nd Quarter</option>
		<option value="3rd">3rd Quarter</option>
		<option value="4th">4th Quarter</option>
	</select>
	</td>
	</tr>
	<tr class="smallText">
		<td colspan="2" align="center">
			<button onclick="return submitSearch();"><bean:message key="button.search" /></button>
			<button onclick="return clearSearch();"><bean:message key="button.clear" /></button>
		</td>
	</tr>
</table>
</form>

<script language="javascript">
<!--//
	function submitSearch() {
		document.search_form.submit();
	}

	function clearSearch() {
	}
//-->
</script>


</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>