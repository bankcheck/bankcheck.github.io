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
private final static String WARD_FIELD = "W.WRDCODE, W.WRDNAME";
private final static String ACM_FIELD = "A.ACMCODE, A.ACMNAME";
private final static String PAYMENT_TYPE_FIELD = "'', DECODE(AP.ARPID, NULL, DECODE(C.CTXMETH, 'C', 'Cash', 'D', 'Credit Card', 'E', 'EPS', 'Others'), 'Insurance') AS PAYTYPE";

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
		header[12] = "TOTAL";
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
		header[days] = "TOTAL";
		header[days+1] = "Empty";
	}
}

private ArrayList getAdmissionInWardData(String year, String field, boolean searchPayType, 
					boolean searchByMonth, String month, String day) {
	StringBuffer sqlStr = new StringBuffer();

	//select
	sqlStr.append("SELECT "+field+", ");
	if(searchByMonth) {
		sqlStr.append("to_char(R.REGDATE,'MM') \"Date\", ");
	}else {
		sqlStr.append("to_char(R.REGDATE,'DD/MM/YY') \"Date\", ");
	}
	sqlStr.append("COUNT(I.INPID) ");
	
	//from
	if(searchPayType) {
		sqlStr.append("FROM INPAT@IWEB I, REG@IWEB R, SLIP@IWEB S, ARTX@IWEB A, ARPTX@IWEB AP, CASHTX@IWEB C ");
	}else {
		sqlStr.append("FROM INPAT@IWEB I, REG@IWEB R, ACM@IWEB A, BED@IWEB B, ROOM@IWEB RM, WARD@IWEB W ");
	}
	
	//where
	if(!searchPayType) {
		sqlStr.append("WHERE I.INPID = R.INPID ");
		sqlStr.append("AND I.INPID IS NOT NULL ");
		sqlStr.append("AND R.INPID IS NOT NULL ");
		sqlStr.append("AND R.REGDATE IS NOT NULL ");
		sqlStr.append("AND A.ACMCODE = I.ACMCODE ");
		sqlStr.append("AND B.BEDCODE = I.BEDCODE ");
		sqlStr.append("AND RM.ROMCODE = B.ROMCODE ");
		sqlStr.append("AND W.WRDCODE = RM.WRDCODE ");
		sqlStr.append("AND W.WRDNAME NOT LIKE '%CLOSED%' ");
		sqlStr.append("AND W.WRDCODE <> 'IC' ");
		sqlStr.append("AND W.WRDCODE <> 'OB' ");
	}else {
		sqlStr.append("WHERE I.INPID = R.INPID ");
		sqlStr.append("AND I.INPID IS NOT NULL ");
		sqlStr.append("AND R.INPID IS NOT NULL ");
		sqlStr.append("AND R.REGDATE IS NOT NULL ");
		sqlStr.append("AND S.SLPNO = R.SLPNO ");
		sqlStr.append("AND S.PATNO = R.PATNO ");
		sqlStr.append("AND A.SLPNO = C.SLPNO ");
		sqlStr.append("AND AP.ARPID(+) = A.ARPID ");
		sqlStr.append("AND C.SLPNO = S.SLPNO  ");
	}
	
	//date condition
	sqlStr.append("AND R.REGDATE >= TO_DATE('");
	if(searchByMonth) {
		sqlStr.append("01/01/"+year+" ");
	}else {
		sqlStr.append(day+"/"+month+"/"+year+" ");
	}
	sqlStr.append("00:00:00','dd/mm/yyyy HH24:MI:SS') ");
	if(searchByMonth) {
		sqlStr.append("AND R.REGDATE <= TO_DATE('");
		sqlStr.append("31/12/"+year+" ");
		sqlStr.append("23:59:59','dd/mm/yyyy HH24:MI:SS') "); 
	}else {
		sqlStr.append("AND R.REGDATE <= (TO_DATE('");
		sqlStr.append(day+"/"+month+"/"+year+" ");
		sqlStr.append("23:59:59','dd/mm/yyyy HH24:MI:SS') + "+String.valueOf(days-1)+") ");
	}
	
	//group by
	if(searchByMonth) {
		if(searchPayType) {
			sqlStr.append("GROUP BY DECODE(AP.ARPID, NULL, DECODE(C.CTXMETH, 'C', 'Cash', 'D', 'Credit Card', 'E', 'EPS', 'Others'), 'Insurance'), to_char(R.REGDATE,'MM') ");
		}else {
			sqlStr.append("GROUP BY "+field+", to_char(R.REGDATE,'MM') ");
		}
	}else {
		if(searchPayType) {
			sqlStr.append("GROUP BY DECODE(AP.ARPID, NULL, DECODE(C.CTXMETH, 'C', 'Cash', 'D', 'Credit Card', 'E', 'EPS', 'Others'), 'Insurance'), to_char(R.REGDATE,'DD/MM/YY') ");
		}else {
			sqlStr.append("GROUP BY "+field+", to_char(R.REGDATE,'DD/MM/YY') ");
		}
	}
	
	//order by
	if(searchPayType) {
		sqlStr.append("ORDER BY PAYTYPE, \"Date\" ");
	}else {
		sqlStr.append("ORDER BY "+field+", \"Date\" ");
	}
	
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);
String type = request.getParameter("submitType");
String searchYearFrom = null;
String searchMonthFrom = null;
String searchDayFrom = null;
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
	rowGroup.add(
			new String[]{WARD_FIELD, 
						"1_Ward", 
						"Ward_INTENSIVE CARE UNIT", 
						"Ward_INTEGRATED UNIT",
						"Ward_MEDICAL UNIT",
						"Ward_OBSTETRIC UNIT", 
						"Ward_PEDIATRIC UNIT", 
						"Ward_SURGICAL UNIT",
						"Ward_TOTAL  ", " _ "});
	rowGroup.add(new String[]{ACM_FIELD, "1_Class", "Class_VIP", "Class_PRIVATE", "Class_SEMI-PRIVATE",
			"Class_STANDARD", "Class_TOTAL   "});
	rowGroup.add(new String[]{PAYMENT_TYPE_FIELD, "1_Payment Method", "Payment Method_CASH",
			"Payment Method_CREDIT CARD",  
			"Payment Method_EPS", "Payment Method_INSURANCE",
			"Payment Method_Others", "Payment Method_TOTAL    "});
}

//jasper report
if (searchYearFrom != null && searchYearFrom.length() > 0) {
//if (record.size() < 0) {
	File reportFile = new File(application.getRealPath("/report/RPT_ADMISSION_IN_WARD.jasper"));
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
			String[] temp = rowGroup.get(i);
			record = getAdmissionInWardData(searchYearFrom, temp[0], PAYMENT_TYPE_FIELD.equals(temp[0]), searchByMonth, searchMonthFrom, searchDayFrom);
			int currentRow = 0;
			int TOTAL[] = new int[col];
			for(int counter = 0; counter < TOTAL.length; counter++)
				TOTAL[counter] = 0;
			
			for(int h = 0; h < header.length; h++) {
				if(header[h].equals("Empty")) {
					break;
				}
				beans.add(makeData(header[h], temp[1], ""));
			}
			
			for(int j = 2; j < temp.length; j ++) {
				int rowSum = 0;
				for(int h = 0; h < header.length; h++) {
					if(header[h].equals("Empty")) {
						break;
					}
					if(temp[j].indexOf("TOTAL") > -1) {
						if(header[h].equals("TOTAL"))
							beans.add(makeData(header[h], temp[j], String.valueOf(rowSum)));
						else {
							rowSum += TOTAL[h];
							beans.add(makeData(header[h], temp[j], String.valueOf(TOTAL[h])));
						}
					}else {
						if(record.size() > currentRow) {
							row = (ReportableListObject) record.get(currentRow);
							if(!row.getValue(1).equals("") && temp[j].toUpperCase().indexOf(row.getValue(1).toUpperCase()) > -1) {
								if(searchByMonth) {
									if(h+1 == Integer.parseInt(row.getValue(2))) {
										currentRow++;
										rowSum += Integer.parseInt(row.getValue(3));
										TOTAL[h] += Integer.parseInt(row.getValue(3));
										
										beans.add(makeData(header[h], temp[j], row.getValue(3)));
									}
									else {
										beans.add(makeData(header[h], temp[j], "0"));
									}
								}
								else {
									if(header[h].equals(row.getValue(2))) {
										currentRow++;
										rowSum += Integer.parseInt(row.getValue(3));
										TOTAL[h] += Integer.parseInt(row.getValue(3));
										
										beans.add(makeData(header[h], temp[j], row.getValue(3)));
									}
									else {
										beans.add(makeData(header[h], temp[j], "0"));
									}
								}
							}
							else {
								if(temp[j].equals(" _ ")) {
									beans.add(makeData(header[h], temp[j], ""));
								}
								else {
									if(header[h].equals("TOTAL"))
										beans.add(makeData(header[h], temp[j], String.valueOf(rowSum)));
									else
										beans.add(makeData(header[h], temp[j], "0"));
								}
							}
						}
						else {
							if(temp[j].equals(" _ ")) {
								beans.add(makeData(header[h], temp[j], ""));
							}
							else {
								if(header[h].equals("TOTAL"))
									beans.add(makeData(header[h], temp[j], String.valueOf(rowSum)));
								else
									beans.add(makeData(header[h], temp[j], "0"));
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
<%String PageTitle = "Admission at Ward List"; %>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="function.admission.inWard.report" />
	<jsp:param name="category" value="Report" />
</jsp:include>

<form name="search_form" action="rpt_adminward.jsp" method="post" target="_blank">
<table cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">
	<tr class="bigText">
		<td colspan="4" align="center"><%=site %></td>
	</tr>
	<tr class="bigText">
		<td colspan="4" align="center">Admission at Ward List</td>
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