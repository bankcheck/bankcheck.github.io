<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>

<%!
	private ArrayList fetchRelative(String clientID, String sortBy, String ordering) {
		// fetch relative
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT D.CRM_DONATION_ID, D.CRM_CLIENT_ID, D.CRM_LASTNAME, D.CRM_FIRSTNAME, D.CRM_CHINESENAME,TO_CHAR(D.CRM_DONATION_DATE, 'DD/MM/YYYY') CRM_DONATION_DATE, D.CRM_STATUS, D.CRM_PLEDGED_AMOUNT, ");
		sqlStr.append("D.CRM_DONATION_METHOD, D.CRM_CREDITCARD_TYPE, D.CRM_CREDITCARD_NUMBER,TO_CHAR(CRM_CREDITCARD_EXPIREDATE, 'MM/YYYY') CRM_CREDITCARD_EXPIREDATE, D.CRM_CREDITCARD_HOLDERNAME, ");
		sqlStr.append("D.CRM_CHEQUE_NUMBER, D.CRM_BANKIN_ACCOUNT, D.CRM_RECEIPT_ID, ");
		sqlStr.append("D.CRM_CREATED_USER, D.CRM_MODIFIED_USER, D.CRM_ENABLED , TO_CHAR(R.CRM_PRINT_DATE, 'DD/MM/YYYY') CRM_PRINT_DATE  ");
		sqlStr.append("FROM (SELECT * ");
		sqlStr.append("      FROM CRM_CLIENTS_DONATION T ");
		sqlStr.append("      WHERE T.CRM_CLIENT_ID = '"+clientID+"' ");
		sqlStr.append("      AND    T.CRM_STATUS NOT LIKE ('client_info') ) D ");
		sqlStr.append("LEFT JOIN CRM_CLIENTS_DONATION_RECEIPT R ");
		sqlStr.append("ON D.CRM_RECEIPT_ID = R.CRM_RECEIPT_ID ");
		
		sqlStr.append("ORDER BY  ");
		
		if (ConstantsVariable.ZERO_VALUE.equals(sortBy)) {			
			sqlStr.append("D.CRM_DONATION_DATE ");
		} else if (ConstantsVariable.ONE_VALUE.equals(sortBy)) {			
			sqlStr.append("D.CRM_PLEDGED_AMOUNT ");
		} else {
			sqlStr.append("D.CRM_DONATION_DATE ");
		}

		if (ordering != null) {
			sqlStr.append(ConstantsVariable.SPACE_VALUE);
			sqlStr.append(ordering);
		} else {
			sqlStr.append(ConstantsVariable.SPACE_VALUE);
			sqlStr.append(" DESC");
		}
		
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getClientInfo(String clientID) {
		StringBuffer sqlStr = new StringBuffer();
	
		sqlStr.append("SELECT CRM_CLIENT_ID, CRM_LASTNAME, CRM_FIRSTNAME,  CRM_CHINESENAME, CRM_STREET1, ");
		sqlStr.append("       CRM_STREET2, CRM_STREET3, CRM_STREET4, ");
		sqlStr.append("       CRM_HOME_NUMBER,CRM_MOBILE_NUMBER, CRM_FAX_NUMBER,  CRM_EMAIL, CRM_PHOTO_NAME, ");
		sqlStr.append("       CRM_ORGANIZATION, CRM_SALUTATION, ");
		sqlStr.append("       CRM_DESCRIPTION,CRM_DONOR,  CRM_CREATED_USER, CRM_CREATED_SITE_CODE, ");
		sqlStr.append("       CRM_CREATED_DEPARTMENT_CODE, CRM_MODIFIED_USER ");	
		sqlStr.append("FROM   CRM_CLIENTS ");
		sqlStr.append("WHERE  CRM_CLIENT_ID = '"+clientID+"' ");	
		sqlStr.append("AND    CRM_DONOR = 'Y' ");
		//System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getDonorDonationReceipt(String receiptID) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT R.CRM_RECEIPT_ID, TO_CHAR(R.CRM_RECEIPT_DATE, 'DD/MM/YYYY'), ");
		sqlStr.append("R.CRM_RECEIPT_AMOUNT, D.CRM_DONATION_METHOD, ");
		sqlStr.append("F.CRM_FUND_DESC, ");
		sqlStr.append("CONCAT(C.CRM_LASTNAME, (' '||C.CRM_FIRSTNAME)), ");
		sqlStr.append("C.CRM_STREET1, C.CRM_STREET2, C.CRM_STREET3, C.CRM_STREET4, ");
		sqlStr.append("C.CRM_CHINESENAME, CRM_ORGANIZATION ");
		sqlStr.append("FROM CRM_CLIENTS_DONATION_RECEIPT R ");
		sqlStr.append("LEFT JOIN CRM_CLIENTS C ON R.CRM_CLIENT_ID = C.CRM_CLIENT_ID ");
		sqlStr.append("LEFT JOIN CRM_CLIENTS_DONATION D ON R.CRM_RECEIPT_ID = D.CRM_RECEIPT_ID ");
		sqlStr.append("LEFT JOIN CRM_FUNDS F ON D.CRM_FUND_ID = F.CRM_FUND_ID ");
		sqlStr.append("WHERE R.CRM_RECEIPT_ID IN ( '" + receiptID + "' ) ");
		sqlStr.append("AND R.CRM_PRINT_DATE IS NULL ");

		System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getDonorDonationHospitalReceipt(String donationID) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT R.CRM_RECEIPT_ID, TO_CHAR(R.CRM_RECEIPT_DATE, 'DD/MM/YYYY'), ");
		sqlStr.append("TO_CHAR(R.CRM_RECEIPT_AMOUNT, 'FM999G999G999G999'), C.CRM_LASTNAME || ',' || C.CRM_FIRSTNAME, ");
		sqlStr.append("C.CRM_STREET1, C.CRM_STREET2, C.CRM_STREET3, C.CRM_STREET4, ");
		sqlStr.append("C.CRM_CHINESENAME, CRM_ORGANIZATION, ");
		sqlStr.append("F.CRM_FUND_DESC ");
		sqlStr.append("FROM CRM_CLIENTS_DONATION_RECEIPT R ");
		sqlStr.append("LEFT JOIN CRM_CLIENTS C ON R.CRM_CLIENT_ID = C.CRM_CLIENT_ID ");
		sqlStr.append("LEFT JOIN CRM_CLIENTS_DONATION D ON R.CRM_RECEIPT_ID = D.CRM_RECEIPT_ID ");
		sqlStr.append("LEFT JOIN CRM_FUNDS F ON D.CRM_FUND_ID = F.CRM_FUND_ID ");
		sqlStr.append("WHERE R.CRM_DONATION_ID = '"+donationID+"' ");
		sqlStr.append("AND R.CRM_PRINT_DATE IS NULL ");

		System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static boolean updatePrintReceiptDate(UserBean userBean, String donationID) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("UPDATE CRM_CLIENTS_DONATION_RECEIPT ");
		sqlStr.append("SET    CRM_PRINT_DATE = SYSDATE, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = '"+userBean.getLoginID()+"' ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_DONATION_ID = '"+donationID+"' ");
		
		//System.out.println(sqlStr.toString());
		
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
	
	private static String getReceiptID(String donationID){
		StringBuffer sqlStr = new StringBuffer();
		String receiptID = "";
		
		sqlStr.append("SELECT CRM_RECEIPT_ID ");
		sqlStr.append("FROM CRM_CLIENTS_DONATION ");
		sqlStr.append("WHERE CRM_DONATION_ID = '"+donationID+"' ");
		
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());
		if(record.size() > 0){
			ReportableListObject reportableListObject = (ReportableListObject) record.get(0);
			receiptID = reportableListObject.getValue(0);
		}
		
		return receiptID;
	}
	
	private static String getFundType(String receiptID){
		StringBuffer sqlStr = new StringBuffer();
		String fundType = "";
		
		sqlStr.append("SELECT CRM_RECEIPT_ITEM ");
		sqlStr.append("FROM CRM_CLIENTS_DONATION_RECEIPT ");
		sqlStr.append("WHERE CRM_RECEIPT_ID = '"+receiptID+"' ");
		
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());
		if(record.size() > 0){
			ReportableListObject reportableListObject = (ReportableListObject) record.get(0);
			fundType = reportableListObject.getValue(0);
		}
		
		return fundType;
	}
	
	public static boolean delete(UserBean userBean, String donationID) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("UPDATE CRM_CLIENTS_DONATION  ");
		sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = '"+userBean.getLoginID()+"' ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_DONATION_ID = '"+donationID+"' ");
		
		//System.out.println(sqlStr.toString());
		
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}

	public static boolean deleteReceipt(UserBean userBean, String receiptID) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("UPDATE CRM_CLIENTS_DONATION_RECEIPT ");
		sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = '"+userBean.getLoginID()+"' ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_RECEIPT_ID = '"+receiptID+"' ");
		
		//System.out.println(sqlStr.toString());
		
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
%>
<%
UserBean userBean = new UserBean(request);
String clientID =  ParserUtil.getParameter(request, "clientID");

String command = ParserUtil.getParameter(request, "command");
String sortBy = request.getParameter("sortBy");
String ordering =  ParserUtil.getParameter(request, "ordering");
String donationID = ParserUtil.getParameter(request, "donationID");
String receiptID = ParserUtil.getParameter(request, "receiptID");
String fundType = "";

	//get fundType
	fundType = getFundType(receiptID);
	if("foundation".equals(fundType)){
		ArrayList record = getDonorDonationReceipt(receiptID);
		request.setAttribute("donationList", record);
		boolean success = updatePrintReceiptDate(userBean, donationID);

		if (record.size() > 0 ) {
			File reportFile = new File(application.getRealPath("/report/RPT_DONOR_RECEIPT_FOUNDATION.jasper"));
			File reportDir = new File(application.getRealPath("/report/"));

			if (reportFile.exists()) {
				JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());

				Map parameters = new HashMap();
				parameters.put("BaseDir", reportFile.getParentFile());		
						
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
				
				
				String encodedFileName = receiptID + ".pdf";
				request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
				OutputStream ouputStream = response.getOutputStream();
				response.setContentType("application/pdf");
				response.setHeader("Content-disposition","inline; filename=\"" + encodedFileName + "\"");
				JRPdfExporter exporter = new JRPdfExporter();
		        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
		        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
		        exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");
		
		        exporter.exportReport();
		       
				return;
			}
		}else{
%>
			<h3 style="color:red;">Alert:<br>Receipt printed already.</h3>
<%		}
	}else if("hospital".equals(fundType)){
		ArrayList record = getDonorDonationHospitalReceipt(donationID);
		request.setAttribute("donationList", record);
		boolean success = updatePrintReceiptDate(userBean, donationID);
					
		if (record.size() > 0 ) {
			File reportFile = new File(application.getRealPath("/report/RPT_DONOR_RECEIPT.jasper"));
			if (reportFile.exists()) {
				JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
				//System.out.println(reportFile.getParentFile());
				Map parameters = new HashMap();
				parameters.put("BaseDir", reportFile.getParentFile());		
				
				ReportableListObject row = (ReportableListObject)record.get(0);
				String displayName = "";
				String engName = row.getValue(3);
				String chiName = row.getValue(8);
				String organization = row.getValue(9);
				
				if(engName.equals(",")){					
					if(chiName != null && chiName.length() > 0){
						displayName = chiName;
					}else{
						displayName = organization;
					}					
				}else{
					if(chiName != null && chiName.length() > 0){
						displayName = engName + " / " + chiName;
					}else{
						displayName = engName;
					}
				}
				
				parameters.put("Name", displayName);
		
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
				
				String encodedFileName = receiptID + ".pdf";
				request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
				OutputStream ouputStream = response.getOutputStream();
				response.setContentType("application/pdf");
				response.setHeader("Content-disposition","inline; filename=\"" + encodedFileName + "\"");
				JRPdfExporter exporter = new JRPdfExporter();
		        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
		        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
		        exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");
		
		        exporter.exportReport();
				return;
			}
		}else{
%>
			<h3 style="color:red;">Alert:<br>Receipt printed already.</h3>
<%		}
	}

%>

