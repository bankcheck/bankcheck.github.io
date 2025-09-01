<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="java.util.ArrayList.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.data.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="java.io.*"%>
<%@ page import="java.text.SimpleDateFormat"%>

<%! 
private final static String REACHED_FIELD = "HAT_REACHED_BY";
private final static String REGISTERED_BY_FIELD = "HAT_REGISTERED_BY";
private final static String WARD_FIELD = "HAT_WARD";
private final static String ROOM_TYPE_FIELD = "HAT_ROOM_TYPE";
private final static String PAYMENT_TYPE_FIELD = "HAT_PAYMENT_TYPE";

ArrayList<String[]> rowGroup = new ArrayList<String[]>();
int days = 14;
int col = 20;

String header[] = new String[col];


private HashMap makeData(String header, String row, String value) {
	HashMap rowMap = new HashMap();
	rowMap.put("header", header);
	rowMap.put("row", row);
	rowMap.put("value", value);
	
	return rowMap;
}

private void generateHeader(boolean searchByMonth, String date, String month, String year) {
	if(searchByMonth) {
		header[0] = "Jan";
		header[1] = "Feb";
		header[2] = "Mar";
		header[3] = "Apr";
		header[4] = "May";
		header[5] = "Jun";
		header[6] = "Jul";
		header[7] = "Aug";
		header[8] = "Sep";
		header[9] = "Oct";
		header[10] = "Nov";
		header[11] = "Dec";
		header[12] = "Total";
		header[13] = "Empty";
		header[14] = "Empty";
	}else {
		Calendar cal = Calendar.getInstance();
		//System.out.println(year);
		//System.out.println(month);
		//System.out.println(date);
		cal.set(Integer.parseInt(year), Integer.parseInt(month) - 1, Integer.parseInt(date));
		SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yy", Locale.ENGLISH);
		cal.add(Calendar.DAY_OF_MONTH, -1);
		
		for(int i = 0; i < days; i++) {
			cal.add(Calendar.DAY_OF_MONTH, 1);
			header[i] = sdf.format(cal.getTime());
			//System.out.println(sdf.format(cal.getTime()));
		}
		header[days] = "Total";
		header[days+1] = "Empty";
	}
}

private ArrayList getData(String year, String month, String day, 
							boolean searchByMonth, String searchType) {
	String dateCol = null;
	StringBuffer sqlStr = new StringBuffer();
	
	if(searchType.equals("reach") || 
			searchType.equals("payment_otpso") || searchType.equals("nonContact")) {
		if(searchByMonth) {
			dateCol = "TO_CHAR(B.BPBHDATE, 'MM')";
		}
		else {
			dateCol = "TO_DATE(TO_CHAR(B.BPBHDATE, 'DD/MM/YYYY'), 'DD/MM/YYYY')";
		}
		
		if(!searchByMonth) {
			sqlStr.append("SELECT T.Status, TO_CHAR(T.D, 'DD/MM/YY'), T.N ");
			sqlStr.append("FROM ( ");
		}
		if(searchType.equals("payment_otpso")){
			sqlStr.append("SELECT DECODE(F1.OT_PSO, '1', 'CASE') AS Status, ");
		}else{
			sqlStr.append("SELECT DECODE(F1.FLW_UP_STATUS, '4', '10001_Link', '12', '10002_Web', '5', '10003_Email', ");
			sqlStr.append("'6', '10004_SMS', '7', '10005_Fax', '8', '10006_Phone', ");
			sqlStr.append("'9', '10008_Can''t'||' '||'be'||' '||'reached', ");
			sqlStr.append("'10', '10007_Preferred'||' '||'upfront'||' '||'registration', ");
			sqlStr.append("'11', '10012_Booking'||' '||'cancelled or rescheduled', '13', '10009_Same day booking', ");
			sqlStr.append("'14', '10010_Booking made after printing call list (1 day ahead)','15', '10011_Without contact information', ");
			sqlStr.append("'16', '10013_Duplicate booking','17', '10014_Virtual booking for LOG', ");
			sqlStr.append("'18', '10015_Others' ");
			sqlStr.append(") AS Status, ");
		}
		sqlStr.append(dateCol+" AS D, ");
		if(searchType.equals("payment_otpso")){
			sqlStr.append("COUNT(DISTINCT F1.PATNO) AS N  ");
		}else{
			sqlStr.append("COUNT(1) AS N ");
		}
		sqlStr.append("FROM FLW_UP_HIST F1, BEDPREBOK@IWEB B ");
		if(searchType.equals("payment_otpso")){
			sqlStr.append("WHERE F1.FLW_UP_TYPE = 'INPATPB' ");
		}else{ 
			sqlStr.append("WHERE F1.UPDATE_DATE in ");
			sqlStr.append("( SELECT MAX(F2.UPDATE_DATE) ");
			sqlStr.append("FROM FLW_UP_HIST F2 ");
			sqlStr.append("WHERE F1.PBPID = F2.PBPID ");
			sqlStr.append("AND F2.FLW_UP_TYPE = 'INPATPB' ");
			sqlStr.append(") ");
			sqlStr.append("AND F1.FLW_UP_TYPE = 'INPATPB' ");			
		  	sqlStr.append("AND F1.FLW_UP_STATUS <> '0' ");
		}
		sqlStr.append("AND B.PBPID = F1.PBPID ");
		sqlStr.append("AND B.BPBSTS <> 'D' ");
		sqlStr.append("AND B.BPBHDATE >= ");
		if(searchByMonth) {
			sqlStr.append("TO_DATE('01/01/"+year+" 00:00:00', 'dd/mm/yyyy HH24:MI:SS') ");
		}else {
			sqlStr.append("TO_DATE('"+day+"/"+month+"/"+year);
			sqlStr.append(" 00:00:00','dd/mm/yyyy HH24:MI:SS') ");
		}
		sqlStr.append("AND B.BPBHDATE <= ");
		if(searchByMonth) {
			sqlStr.append("TO_DATE('31/12/"+year+" 23:59:59', 'dd/mm/yyyy HH24:MI:SS') ");
		}else {
			sqlStr.append("(TO_DATE('"+day+"/"+month+"/"+year);
			sqlStr.append(" 23:59:59','dd/mm/yyyy HH24:MI:SS')+"+String.valueOf(days-1)+") ");
		}
		if (searchType.equals("nonContact")){
			sqlStr.append("AND (F1.FLW_UP_STATUS = '9' OR F1.FLW_UP_STATUS = '13' OR ");
			sqlStr.append("F1.FLW_UP_STATUS = '14' OR F1.FLW_UP_STATUS = '15' OR ");
			sqlStr.append("F1.FLW_UP_STATUS = '16' OR F1.FLW_UP_STATUS = '17' OR ");
			sqlStr.append("F1.FLW_UP_STATUS = '18' OR F1.FLW_UP_STATUS = '11') ");
		}
		else if (searchType.equals("reach")){
			sqlStr.append("AND (F1.FLW_UP_STATUS = '4' OR F1.FLW_UP_STATUS = '12' OR ");
			sqlStr.append("F1.FLW_UP_STATUS = '5' OR F1.FLW_UP_STATUS = '6' OR ");
			sqlStr.append("F1.FLW_UP_STATUS = '7' OR F1.FLW_UP_STATUS = '8' OR ");
			sqlStr.append("F1.FLW_UP_STATUS = '10') ");
		}
		if(searchType.equals("payment_otpso")){
			sqlStr.append("AND F1.UPDATE_DATE = ");
			sqlStr.append("(SELECT MAX(F2.UPDATE_DATE) from FLW_UP_HIST F2 ");
			sqlStr.append("WHERE F1.PATNO = F2.PATNO) ");
		}
		if(searchType.equals("payment_otpso")){			
			sqlStr.append("GROUP BY DECODE(F1.OT_PSO, '1', 'CASE'), ");
		}else{
			sqlStr.append("GROUP BY DECODE(F1.FLW_UP_STATUS, '4', '10001_Link', '12', '10002_Web', '5', '10003_Email', ");
			sqlStr.append("'6', '10004_SMS', '7', '10005_Fax', '8', '10006_Phone', ");
			sqlStr.append("'9', '10008_Can''t'||' '||'be'||' '||'reached', ");
			sqlStr.append("'10', '10007_Preferred'||' '||'upfront'||' '||'registration', ");
			sqlStr.append("'11', '10012_Booking'||' '||'cancelled or rescheduled', '13', '10009_Same day booking', ");
			sqlStr.append("'14', '10010_Booking made after printing call list (1 day ahead)','15', '10011_Without contact information', ");
			sqlStr.append("'16', '10013_Duplicate booking','17', '10014_Virtual booking for LOG', ");
			sqlStr.append("'18', '10015_Others'), ");
		}
		sqlStr.append(dateCol+" ");
		sqlStr.append("ORDER BY Status, ");
		sqlStr.append(dateCol+" ");
		
		if(!searchByMonth) {
			sqlStr.append(") T "); 
		}
	}
	else {
		String selectCol = null;
		
		if(searchByMonth) {
			dateCol = "TO_CHAR(hp.HAT_EXPECTED_ADMISSION_DATE, 'MM')";
		}
		else {
			dateCol = "TO_DATE(TO_CHAR(hp.HAT_EXPECTED_ADMISSION_DATE, 'DD/MM/YYYY'), 'DD/MM/YYYY')";
		}
		
		if(searchType.equals("reg")) {
			selectCol = "DECODE(hp.HAT_SESSION_ID, null, DECODE(hp.HAT_CREATED_USER, 'SYSTEM', DECODE(flw.PATNO, null, '', 'Phone'), 'Web'), 'Email')";
		}else if(searchType.equals("ward")) {
			selectCol = "hp.HAT_WARD";
		}
		else if(searchType.equals("acm")) {
			selectCol = "UPPER(hp.HAT_ROOM_TYPE)";
		}
		else if(searchType.equals("payment")) {
			selectCol = "DECODE(hp.HAT_PAYMENT_TYPE, 'CASH', 'CASH', 'CREDIT CARD', 'CREDIT CARD', 'CREDIT CARD AUTH', 'CREDIT CARD AUTH', 'EPS', 'EPS', 'INSURANCE', 'INSURANCE', 'OTHER')";
		}
		
		if(!searchByMonth) {
			sqlStr.append("SELECT T.Col, TO_CHAR(T.D, 'DD/MM/YY'), T.N ");
			sqlStr.append("FROM ( ");
		}
		
		sqlStr.append("Select "+selectCol+" AS Col, ");
		sqlStr.append(dateCol+" AS D, ");
		sqlStr.append("COUNT(1) AS N ");
		sqlStr.append("FROM HAT_PATIENT hp ");
		if(searchType.equals("reg")) {
			sqlStr.append("left outer join ( ");
			sqlStr.append("SELECT B.PATNO, B.BPBHDATE ");
			sqlStr.append("FROM FLW_UP_HIST f1, BEDPREBOK@IWEB B ");
			sqlStr.append("WHERE f1.update_date in ");
			sqlStr.append("(SELECT MAX(f2.update_date) ");
			sqlStr.append("FROM FLW_UP_HIST f2 ");
			sqlStr.append("WHERE f1.pbpid = f2.pbpid ");
			sqlStr.append("AND f2.FLW_UP_TYPE = 'INPATPB') ");
			sqlStr.append("AND f1.FLW_UP_TYPE = 'INPATPB' ");
			sqlStr.append("AND f1.FLW_UP_STATUS = '8' ");
			sqlStr.append("AND f1.PBPID = B.PBPID) flw ");
			sqlStr.append("on flw.PATNO = hp.HAT_PATNO ");
			sqlStr.append("AND TO_CHAR(flw.BPBHDATE, 'DD/MM/YYYY') = TO_CHAR(hp.HAT_EXPECTED_ADMISSION_DATE, 'dd/MM/YYYY') ");
		}
		sqlStr.append("WHERE hp.HAT_EXPECTED_ADMISSION_DATE >= ");
		if(searchByMonth) {
			sqlStr.append("TO_DATE('01/01/"+year+" 00:00:00', 'dd/mm/yyyy HH24:MI:SS') ");
		}else {
			sqlStr.append("TO_DATE('"+day+"/"+month+"/"+year);
			sqlStr.append(" 00:00:00','dd/mm/yyyy HH24:MI:SS') ");
		}
		
		sqlStr.append("AND hp.HAT_EXPECTED_ADMISSION_DATE <= ");
		if(searchByMonth) {
			sqlStr.append("TO_DATE('31/12/"+year+" 23:59:59', 'dd/mm/yyyy HH24:MI:SS') ");
		}else {
			sqlStr.append("(TO_DATE('"+day+"/"+month+"/"+year);
			sqlStr.append(" 23:59:59','dd/mm/yyyy HH24:MI:SS')+"+String.valueOf(days-1)+") ");
		}
		
		if(searchType.equals("ward") || searchType.equals("acm")) {
			sqlStr.append("AND "+selectCol+" IS NOT NULL ");
		}
		else if(searchType.equals("payment")) {
			sqlStr.append("AND hp.HAT_PAYMENT_TYPE IS NOT NULL ");
		}
		
		sqlStr.append("AND    hp.HAT_ENABLED = 1 ");
		sqlStr.append("AND    hp.HAT_ADMISSION_TYPE = 'I' ");
		sqlStr.append("GROUP BY "+selectCol+", ");
		sqlStr.append(dateCol+" ");
		sqlStr.append("ORDER BY Col, ");
		sqlStr.append(dateCol+" ");
		
		if(!searchByMonth) {
			sqlStr.append(") T "); 
		}
	}
	
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);
String type = request.getParameter("submitType");
String searchYearFrom = null;
String searchYearTo = null;
String searchMonthFrom = null;
String searchMonthTo = null;
String searchDayFrom = null;
String searchDayTo = null;
boolean searchByMonth = false;

if(type != null && type.equals("byMonth")) {
	searchYearFrom = request.getParameter("searchYear_ByMonth_yy");
	searchByMonth = true;
}
else {
	searchYearFrom = request.getParameter("searchYearFrom_ByDate_yy");
	searchMonthFrom = request.getParameter("searchYearFrom_ByDate_mm");
	searchDayFrom = request.getParameter("searchYearFrom_ByDate_dd");
	searchByMonth = false;
}

String site = request.getParameter("site");
StringBuffer sqlStr = new StringBuffer();

if( ConstantsServerSide.SITE_CODE_HKAH.equalsIgnoreCase(userBean.getSiteCode())) {
	site = "Hong Kong Adventist Hospital- Stubbs Road";
}else if (ConstantsServerSide.SITE_CODE_TWAH.equalsIgnoreCase(userBean.getSiteCode())){
	site = "Hong Kong Adventist Hospital - Tsuen Wan";
}

ArrayList record = null;
ReportableListObject row = null;

if(rowGroup.size() == 0) {
	rowGroup.add(new String[]{
			"reach", "1_Reached By", 
			"ReachedBy_Link ", "ReachedBy_Web ", "ReachedBy_Email ",
			"ReachedBy_SMS", "ReachedBy_Fax", "ReachedBy_Phone ",  
			 "ReachedBy_Preferred upfront registration"," _ "});
	rowGroup.add(new String[]{
			"nonContact", "1_Non-Contacted", 
			"Non-Contacted_Can't be reached", 
			 "Non-Contacted_Same day booking",
			 "Non-Contacted_Booking made after printing call list (1 day ahead)",
			 "Non-Contacted_Without contact information",
			 "Non-Contacted_Booking cancelled or rescheduled", 
			 "Non-Contacted_Duplicate booking",
			 "Non-Contacted_Virtual booking for LOG", "ReachedBy_Others ",	
			 "Non-Contacted_Total     ", " _ ", " _  "});
	rowGroup.add(new String[]{"reg", "1_Registered", "Registered_Link / Email",
			"Registered_Phone", "Registered_Web",
			"Registered_Total ", " _ "});
	rowGroup.add(new String[]{"ward", "1_Booking(Ward)", "Booking(Ward)_ICU", 
			"Booking(Ward)_Integrated Unit", "Booking(Ward)_Medical Unit",
			"Booking(Ward)_Obstetric Unit", "Booking(Ward)_Pediatric Unit", 
			"Booking(Ward)_Surgical Unit", "Booking(Ward)_Total  ", " _ "});
	rowGroup.add(new String[]{"acm", "1_Class", "Class_Private", "Class_Semi-Private",
			"Class_Standard", "Class_VIP", "Class_Total   ", " _ "});
	rowGroup.add(new String[]{"payment", "1_Payment Method", "Payment Method_Cash",
			"Payment Method_Credit card", "Payment Method_Credit card Auth", 
			"Payment Method_EPS", "Payment Method_Insurance",
			"Payment Method_Others", "Payment Method_Total    ", " _ "});
	rowGroup.add(new String[]{"payment_otpso", "1_Case", "Payment Case_OT/Endo PSO"});
}

//jasper report
if (searchYearFrom != null && searchYearFrom.length() > 0) {
//if (record.size() < 0) {
	File reportFile = new File(application.getRealPath("/report/RPT_INPAT_PRE_REG_BYMONTH.jasper"));
	if (reportFile.exists()) {
		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());

		Map parameters = new HashMap();
		parameters.put("BaseDir", reportFile.getParentFile());
		parameters.put("Site", site);
		parameters.put("Year", searchYearFrom);
		if(searchByMonth)
			parameters.put("rType", "    (By Month)");
		else
			parameters.put("rType", "    (By Date)");

		generateHeader(searchByMonth, searchDayFrom, searchMonthFrom, searchYearFrom);
		
		Collection beans = new ArrayList();
		
		for(int i = 0; i < rowGroup.size(); i++) {
			String[] items = rowGroup.get(i);
			record = getData(searchYearFrom, searchMonthFrom, searchDayFrom, searchByMonth, items[0]);
			
			int currentRow = 0;
			int total[] = new int[col];
			
			//init array of total
			for(int counter = 0; counter < total.length; counter++)
				total[counter] = 0;
			
			//Make the header
			for(int h = 0; h < header.length; h++) {
				if(header[h].equals("Empty")) {
					break;
				}
				beans.add(makeData(header[h], items[1], ""));
			}
			
			//make the related data
			for(int itemIndex = 2; itemIndex < items.length; itemIndex++) {
				int rowSum = 0;
				
				for(int h = 0; h < header.length; h++) {
					if(header[h].equals("Empty")) {
						break;
					}
					
					if(items[itemIndex].indexOf("Total") > -1) {
						if(header[h].equals("Total"))
							beans.add(makeData(header[h], items[itemIndex], String.valueOf(rowSum)));
						else {
							rowSum += total[h];
							beans.add(makeData(header[h], items[itemIndex], String.valueOf(total[h])));
						}
					}else {
						if(record.size() > currentRow) {
							row = (ReportableListObject) record.get(currentRow);
							String item = null;

							if(items[0].equals("reach") || items[0].equals("nonContact")) {
								item = row.getValue(0).toUpperCase().split("_")[1];
							}
							else {
								item = row.getValue(0).toUpperCase();
							}
							
							if(!row.getValue(0).equals("") && 
									items[itemIndex].toUpperCase().indexOf(item) > -1) {
								boolean equal = header[h].equals(row.getValue(1));
								if(!equal) {
									try {
										equal = (h+1 == Integer.parseInt(row.getValue(1)));
									}catch(Exception e) {
										equal = false;
									}
								}
								
								if(equal) {
									currentRow++;
									//System.out.println(header[h]);
									//System.out.println(row.getValue(2));
									rowSum += Integer.parseInt(row.getValue(2));
									total[h] += Integer.parseInt(row.getValue(2));
									
									beans.add(makeData(header[h], items[itemIndex], row.getValue(2)));
								}
								else {
									beans.add(makeData(header[h], items[itemIndex], "0"));
								}
							}
							else {
								if(items[itemIndex].indexOf(" _ ") > -1) {
									beans.add(makeData(header[h], items[itemIndex], ""));
								}
								else {
									if(header[h].equals("Total"))
										beans.add(makeData(header[h], items[itemIndex], String.valueOf(rowSum)));
									else
										beans.add(makeData(header[h], items[itemIndex], "0"));
								}
							}
						}
						else {
							if(items[itemIndex].indexOf(" _ ") > -1) {
								beans.add(makeData(header[h], items[itemIndex], ""));
							}
							else {
								if(header[h].equals("Total"))
									beans.add(makeData(header[h], items[itemIndex], String.valueOf(rowSum)));
								else
									beans.add(makeData(header[h], items[itemIndex], "0"));
							}
						}
					}
				}
			}
		}

		JRMapCollectionDataSource ds = new JRMapCollectionDataSource(beans);

		JasperPrint jasperPrint =
			JasperFillManager.fillReport(
				jasperReport,
				parameters,
				(JRDataSource)ds);
		
		
		request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
		response.setContentType("application/pdf");
		OutputStream ouputStream = response.getOutputStream();
		
		JRPdfExporter exporter = new JRPdfExporter();
        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
        exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");

        exporter.exportReport();
        ouputStream.close();
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
<%String PageTitle = "Inpatient Pre-registration Report"; %>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.inpatient.preregistration.report" />
	<jsp:param name="category" value="Report" />
</jsp:include>

<form name="search_form" action="rpt_inpatprereg.jsp" method="post" target="_blank">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="bigText">
		<td colspan="4" align="center"><%=site %></td>
	</tr>
	<tr class="bigText">
		<td colspan="4" align="center">Inpatient Pre-registration Report</td>
	</tr>	
	<tr><td>&nbsp;</td></tr>
	<tr class="smallText" >
		<td class="infoLabel" width="100%" colspan="4" style="text-align:left">Report by Date (14 Days)</td>
	</tr>
	<tr class="smallText" >
		<td class="infoLabel" width="10%">Start Date</td>
		<td class="infoData" width="40%" >
			<jsp:include page="../ui/dateCMB.jsp" flush="false"> 
				<jsp:param name="label" value="searchYearFrom_ByDate" />
				<jsp:param name="day_yy" value="<%=searchYearFrom %>" />
				<jsp:param name="yearRange" value="1" />
				<jsp:param name="isYearOnly" value="N" />
				<jsp:param name="showTime" value="N" />
			</jsp:include>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr class="smallText">
		<td colspan="4" align="center">
			<button onclick="return genRptByDate();">Generate Report (By Date)</button>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr class="smallText" >
		<td class="infoLabel" width="100%" colspan="4" style="text-align:left">Report by Month</td>
	</tr>
	<tr class="smallText" >
		<td class="infoLabel" width="10%">Year</td>
		<td class="infoData" width="40%" >
			<jsp:include page="../ui/dateCMB.jsp" flush="false"> 
				<jsp:param name="label" value="searchYear_ByMonth" />
				<jsp:param name="day_yy" value="<%=searchYearFrom %>" />
				<jsp:param name="yearRange" value="1" />
				<jsp:param name="isYearOnly" value="Y" />
			</jsp:include>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr class="smallText">
		<td colspan="4" align="center">
			<button onclick="return genRptByMon();">Generate Report (By Month)</button>
			<input type="hidden" name="submitType" value=""/>
		</td>
	</tr>
	<tr><td><input type="hidden" name="submitType" value=""/></td></tr>
</table>
</form>

<script language="javascript">
<!--//
	function genRptByDate() {
		$('input[name=submitType]').val('byDate');
		document.search_form.submit();
	}
	function genRptByMon() {
		$('input[name=submitType]').val('byMonth');
		document.search_form.submit();
	}
//-->
</script>


</DIV>

</DIV></DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>