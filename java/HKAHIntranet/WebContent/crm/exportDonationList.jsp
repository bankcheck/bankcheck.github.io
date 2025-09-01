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

<%!
	private ArrayList fetchDonation(String date_from, String date_to, String campaignID, String eventID, String lastName, String firstName, String acceptPromotion) {

		// fetch donation
		StringBuffer sqlStr = new StringBuffer();
		List<String> params = new ArrayList<String>();
		
		sqlStr.append("SELECT 	D.CRM_CLIENT_ID, CONCAT(CL.CRM_LASTNAME, (' '||CL.CRM_FIRSTNAME)), CL.CRM_CHINESENAME, ");
		sqlStr.append("			CL.CRM_STREET1, CL.CRM_STREET2, CL.CRM_STREET3, CL.CRM_STREET4, ");
		sqlStr.append("			D.CRM_DONATION_ID, TO_CHAR(D.CRM_DONATION_DATE, 'DD/MM/YYYY'), D.CRM_RECEIPT_ID, ");
		sqlStr.append("			F.CRM_FUND_DESC, ");
		sqlStr.append("			D.CRM_PLEDGED_AMOUNT, D.CRM_DONATION_METHOD, ");
		sqlStr.append("			D.CRM_CAMPAIGN_ID, C.CRM_CAMPAIGN_DESC, D.CRM_EVENT_ID, E.CO_EVENT_DESC, ");
		sqlStr.append("			DECODE(CL.CRM_WILLING_PROMOTION,'Y','Yes','N','No'), D.CRM_REMARKS ");
		sqlStr.append("FROM CRM_CLIENTS_DONATION D ");
		sqlStr.append("LEFT JOIN CRM_CLIENTS CL ON CL.CRM_CLIENT_ID = D.CRM_CLIENT_ID ");
		sqlStr.append("LEFT JOIN CRM_CAMPAIGN C ON D.CRM_CAMPAIGN_ID = C.CRM_CAMPAIGN_ID ");
		sqlStr.append("LEFT JOIN CO_EVENT E ON D.CRM_EVENT_ID = E.CO_EVENT_ID ");
		sqlStr.append("LEFT JOIN CRM_FUNDS F ON D.CRM_FUND_ID = F.CRM_FUND_ID ");
		sqlStr.append("WHERE 	D.CRM_ENABLED = 1 ");
	    if (date_from != null) {
	    	sqlStr.append("	AND 	D.CRM_DONATION_DATE >= TO_DATE(?, 'DD/MM/YYYY') ");
	    	params.add(date_from);
	    }
	    if (date_to != null) {
	    	sqlStr.append("	AND 	D.CRM_DONATION_DATE <= TO_DATE(?, 'DD/MM/YYYY') ");
	    	params.add(date_to);
	    }
	   	if(campaignID != null && campaignID.length() > 0){
	    	sqlStr.append("AND 		D.CRM_CAMPAIGN_ID = ? ");
	    	params.add(campaignID);
	   	}
	   	if(eventID != null && eventID.length() > 0){
	    	sqlStr.append("AND 		D.CRM_EVENT_ID = ? ");
	    	params.add(eventID);
	   	}
	   	if(lastName != null && lastName.length() > 0){
	    	sqlStr.append("AND 		CL.CRM_LASTNAME LIKE ? ");
	       	params.add("%" + lastName +"%");
	   	}
	   	if(firstName != null && firstName.length() > 0){
	    	sqlStr.append("AND 		CL.CRM_FIRSTNAME LIKE ? ");
	    	params.add("%" + firstName +"%");
	   	}
	   	if(acceptPromotion != null && !"A".equals(acceptPromotion)){
	    	sqlStr.append("AND 		CL.CRM_WILLING_PROMOTION = ? ");
	    	params.add(acceptPromotion);
	   	}
	   	sqlStr.append("ORDER BY D.CRM_CLIENT_ID, D.CRM_DONATION_DATE");
	   	
	   	
		return UtilDBWeb.getReportableList(sqlStr.toString(), params.toArray(new String[]{}));
	}
%>

<%
UserBean userBean = new UserBean(request);
String loginID = userBean.getLoginID();
String clientID = (String) session.getAttribute(ConstantsWebVariable.CLIENT_ID);

String command = request.getParameter("command");
String step = request.getParameter("step");
String date_from = request.getParameter("date_from");
String date_to = request.getParameter("date_to");
String campaignID = request.getParameter("campaignID");
String eventID = request.getParameter("eventID");
String clientLastName = request.getParameter("clientLastName");
String clientFirstName = request.getParameter("clientFirstName");
String acceptPromotion = request.getParameter("acceptPromotion");

ArrayList record = null;
record = fetchDonation(date_from,date_to,campaignID,eventID,clientLastName,clientFirstName,acceptPromotion);
//jasper report

if (record.size() > 0) {
	
	
	File reportFile = new File(application.getRealPath("/report/CRM_DONATION_LIST.jasper"));
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

		String encodedFileName = "DonationList.xls";
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
