<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="net.sf.jasperreports.engine.JasperPrint" %>
<% 
UserBean userBean = new UserBean(request);

String courseCategory = request.getParameter("courseCategory");
String date_from = request.getParameter("date_from");
String date_to = request.getParameter("date_to");


StringBuffer sqlStr = new StringBuffer();
ArrayList record = null;
sqlStr.append("SELECT  CE.CO_EVENT_ID, CE.CO_SCHEDULE_ID, ");
sqlStr.append("        C.CO_EVENT_CATEGORY, C.CO_EVENT_DESC, CS.CO_SCHEDULE_DESC, ");
sqlStr.append("        TO_CHAR(CS.CO_SCHEDULE_START, 'MON', 'nls_date_language=american') CO_MONTH, ");
sqlStr.append("        TO_CHAR(CS.CO_SCHEDULE_START, 'dd/MM/YYYY') CO_CLASS_DATE, ");
sqlStr.append("        TO_CHAR(CS.CO_SCHEDULE_START, 'HH24:MI') CO_CLASS_TIME_START, ");
sqlStr.append("        TO_CHAR(CS.CO_SCHEDULE_END, 'HH24:MI') CO_CLASS_TIME_END, ");
sqlStr.append("        CS.CO_SCHEDULE_DURATION, CS.CO_LECTURE_DESC, ");
sqlStr.append("        CE.CO_ENROLL_ID, ");
sqlStr.append("        S.CO_STAFFNAME, S.CO_STAFF_ID, S.CO_DEPARTMENT_CODE, INITCAP(D.CO_DEPARTMENT_DESC) CO_DEPARTMENT_DESC, ");
sqlStr.append("        INITCAP(DECODE(S.CO_POSITION_1, NULL , NULL, S.CO_POSITION_1 || ' ')||S.CO_POSITION_2) CO_POSITION, ");
sqlStr.append("       (SELECT GET_STAFF_CAT(DECODE(S.CO_POSITION_1, NULL , NULL, S.CO_POSITION_1 || ' ')||S.CO_POSITION_2, S.CO_DEPARTMENT_CODE) FROM DUAL) CO_STAFF_CAT, ");
sqlStr.append("        DECODE(CE.CO_ATTEND_STATUS,'1','Attended','Enrolled') CO_ATTEND_STATUS, ");
sqlStr.append("        DECODE(CE.CO_REMARK,'1','Yes','No') CO_ONDUTY ");
sqlStr.append("FROM CO_ENROLLMENT CE, CO_EVENT C, CO_SCHEDULE CS, CO_STAFFS S, CO_DEPARTMENTS D ");
sqlStr.append("WHERE  CE.CO_SITE_CODE = C.CO_SITE_CODE ");
sqlStr.append("AND    CE.CO_MODULE_CODE = C.CO_MODULE_CODE ");
sqlStr.append("AND    CE.CO_EVENT_ID = C.CO_EVENT_ID ");
sqlStr.append("AND    CE.CO_SITE_CODE = CS.CO_SITE_CODE (+) ");
sqlStr.append("AND    CE.CO_MODULE_CODE = CS.CO_MODULE_CODE (+) ");
sqlStr.append("AND    CE.CO_EVENT_ID = CS.CO_EVENT_ID (+) ");
sqlStr.append("AND    CE.CO_SCHEDULE_ID = CS.CO_SCHEDULE_ID (+) ");
sqlStr.append("AND    CE.CO_USER_ID = S.CO_STAFF_ID (+) ");
sqlStr.append("AND    S.CO_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE (+) ");
sqlStr.append("AND     CE.CO_MODULE_CODE = 'education' ");
if(courseCategory == null || courseCategory.length() > 0)
	sqlStr.append("AND     C.CO_EVENT_CATEGORY = '"+courseCategory+"' ");
sqlStr.append("AND     C.CO_EVENT_TYPE = 'class' ");
sqlStr.append("AND    CE.CO_ATTEND_DATE >= to_date('"+date_from+"','dd/mm/yyyy') ");
sqlStr.append("AND    CE.CO_ATTEND_DATE <= to_date('"+date_to+"','dd/mm/yyyy') ");
sqlStr.append("AND    CE.CO_ENABLED = 1 ");
sqlStr.append("ORDER BY CS.CO_SCHEDULE_START, CO_EVENT_ID, CO_SCHEDULE_ID ");
//System.out.println("DEBUG: sql = " + sqlStr.toString());
record = UtilDBWeb.getReportableList(sqlStr.toString());
//jasper report

if (record.size() > 0) {
		
	File reportFile = new File(application.getRealPath("/report/eeAnalysis.jasper"));
	File reportDir = new File(application.getRealPath("/report/"));
	
	if (reportFile.exists()) {
		JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());

		Map parameters = new HashMap();
		parameters.put(JRParameter.IS_IGNORE_PAGINATION, Boolean.TRUE);


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

		String encodedFileName = courseCategory + "Analysis.xls";
		request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
		OutputStream ouputStream = response.getOutputStream();
		response.setHeader("Content-disposition","inline; filename=\"" + encodedFileName + "\""); 
		response.setContentType("application/vnd.ms-excel");
		JRXlsExporter exporter = new JRXlsExporter();
        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
        exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");

        exporter.exportReport();
        ouputStream.flush();
        ouputStream.close();
		return;
		
	}
}



%>
