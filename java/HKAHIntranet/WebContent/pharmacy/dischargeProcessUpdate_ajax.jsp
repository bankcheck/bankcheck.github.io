<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="net.sf.jasperreports.engine.JasperPrint" %>


<%!
	private boolean updateToRx(String regID, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET TO_RX_DATE = SYSDATE, STATUS = 2, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "  
					+ "WHERE REGID = ? AND STATUS = 1 ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, regID });
	}

	private boolean updateReceiveOrder(String regID, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET RECEIVE_DATE = SYSDATE, STATUS = 3, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "  
					+ "WHERE REGID = ? AND STATUS = 2 ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, regID });
	}
	
	private boolean updateEntryCompleted(String regID, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET ENTRY_DATE = SYSDATE, STATUS = 4, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "  
					+ "WHERE REGID = ? AND STATUS = 3 ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, regID });
	}
	
	private boolean updateToPBO(String regID, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET TO_PBO_DATE = SYSDATE, STATUS = 5, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "   
					+ "WHERE REGID = ? AND STATUS IN (4,8,9,10) AND TO_PBO_DATE IS NULL";
		return UtilDBWeb.updateQueue( sql, new String[] { user, regID });
	}
/*
	private boolean updateReceiveFromPharmacy(String regID, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET RECEIVE_FROM_RX_DATE = SYSDATE, STATUS = 6, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "   
					+ "WHERE REGID = ? AND STATUS >= 4 AND STATUS != 11";
		return UtilDBWeb.updateQueue( sql, new String[] { user, regID });
	}
	*/
	private boolean updateFinishBilling(String regID, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET FINISH_BILLING_DATE = SYSDATE, STATUS = 6, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "   
					+ "WHERE REGID = ? AND STATUS >= 5 AND FINISH_BILLING_DATE IS NULL";
		return UtilDBWeb.updateQueue( sql, new String[] { user, regID });
	}
	
	private boolean updatePaymentSettlement(String regID, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET PAYMENT_SETTLEMENT_DATE = SYSDATE, STATUS = 7, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "   
					+ "WHERE REGID = ? AND STATUS >= 6 AND FINISH_BILLING_DATE IS NOT NULL AND PAYMENT_SETTLEMENT_DATE IS NULL";
		return UtilDBWeb.updateQueue( sql, new String[] { user, regID });
	}
	
	private boolean updateNoDischarge(String regID, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET NO_RX_DISCHARGE_DATE = SYSDATE, STATUS = 8, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "   
					+ "WHERE REGID = ? AND STATUS >= 4 AND DRUG_PICKING_DATE IS NULL AND RX_BEDSIDE_DISCHARGE_DATE IS NULL AND NO_RX_DISCHARGE_DATE IS NULL ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, regID });
	}
	
	private boolean updateBedsideDischarge(String regID, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET RX_BEDSIDE_DISCHARGE_DATE = SYSDATE, STATUS = 9, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "   
					+ "WHERE REGID = ? AND STATUS >= 4 AND NO_RX_DISCHARGE_DATE IS NULL AND DRUG_PICKING_DATE IS NULL AND RX_BEDSIDE_DISCHARGE_DATE IS NULL";
		return UtilDBWeb.updateQueue( sql, new String[] { user, regID });
	}
	
	private boolean updateDrugPicking(String regID, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET DRUG_PICKING_DATE = SYSDATE, STATUS = 10, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "   
					+ "WHERE REGID = ? AND STATUS >= 4 AND NO_RX_DISCHARGE_DATE IS NULL AND RX_BEDSIDE_DISCHARGE_DATE IS NULL AND DRUG_PICKING_DATE IS NULL";
		return UtilDBWeb.updateQueue( sql, new String[] { user, regID });
	}
	
	private boolean updateToRxRemark(String regID, String remark, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET TO_RX_DATE_REMARK = ?, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? " 
					+ "WHERE REGID = ? ";
		return UtilDBWeb.updateQueue( sql, new String[] { remark, user, regID });
	}
	
	private boolean updateReceiveOrderRemark(String regID, String remark, String user, String nomed){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET NO_MED = ?, RECEIVE_DATE_REMARK = ?, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? " 
					+ "WHERE REGID = ? ";
		return UtilDBWeb.updateQueue( sql, new String[] { nomed, remark, user, regID });
	}
	
	private boolean updateEntryCompletedRemark(String regID, String remark, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET ENTRY_DATE_REMARK = ?, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? " 
					+ "WHERE REGID = ? ";
		return UtilDBWeb.updateQueue( sql, new String[] { remark, user, regID });
	}
	
	private boolean updateToPBORemark(String regID, String remark, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET TO_PBO_DATE_REMARK = ?, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "  
					+ "WHERE REGID = ? ";
		return UtilDBWeb.updateQueue( sql, new String[] { remark, user, regID });
	}
	
	private boolean updateBedsideDischargeRemark(String regID, String remark, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET BEDSIDE_DISCHARGE_DATE_REMARK = ?, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "  
					+ "WHERE REGID = ? ";
		return UtilDBWeb.updateQueue( sql, new String[] { remark, user, regID });
	}
	
	private boolean updateReceiveFromPharmacyRemark(String regID, String remark, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET RECEIVE_FROM_RX_DATE_REMARK = ?, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "  
					+ "WHERE REGID = ? ";
		return UtilDBWeb.updateQueue( sql, new String[] { remark, user, regID });
	}
	
	private boolean updateFinishBillingRemark(String regID, String remark, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET FINISH_BILLING_DATE_REMARK = ?, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "  
					+ "WHERE REGID = ? ";
		return UtilDBWeb.updateQueue( sql, new String[] { remark, user, regID });
	}
	
	private boolean updatePaymentSettlementRemark(String regID, String remark, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET PAYMENT_SETTLEMENT_DATE_REMARK = ?, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "  
					+ "WHERE REGID = ? ";
		return UtilDBWeb.updateQueue( sql, new String[] { remark, user, regID });
	}
	
	private boolean updateDrugPickingRemark(String regID, String remark, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET DRUG_PICKING_DATE_REMARK = ?, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "  
					+ "WHERE REGID = ? ";
		return UtilDBWeb.updateQueue( sql, new String[] { remark, user, regID });
	}
	
	private boolean updateNoDischargeRemark(String regID, String remark, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET NO_RX_DISCHARGE_DATE_REMARK = ?, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "  
					+ "WHERE REGID = ? ";
		return UtilDBWeb.updateQueue( sql, new String[] { remark, user, regID });
		}
	
	private ArrayList<ReportableListObject> getRemark(String regID){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 	REGID, MODIFIED_DATE, ");
		sqlStr.append("			TO_RX_DATE_REMARK, RECEIVE_DATE_REMARK, ENTRY_DATE_REMARK, TO_PBO_DATE_REMARK, ");
		sqlStr.append("			FINISH_BILLING_DATE_REMARK, PAYMENT_SETTLEMENT_DATE_REMARK, ");
		sqlStr.append("			NO_RX_DISCHARGE_DATE_REMARK, BEDSIDE_DISCHARGE_DATE_REMARK, DRUG_PICKING_DATE_REMARK, ");
		sqlStr.append("			NO_MED ");
		sqlStr.append("FROM TICKET_QUEUE@IWEB ");
		sqlStr.append("WHERE REGID = '" + regID + "' ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	private ArrayList<ReportableListObject> getTime(String regID){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 	T.REGID, TO_CHAR(SYSDATE, 'DD/MM/YYYY HH24:MI'), ");
		sqlStr.append("		TO_CHAR(T.START_DATE, 'DD/MM/YYYY HH24:MI'), "); // 2
		sqlStr.append("		TO_CHAR(T.TO_RX_DATE, 'DD/MM/YYYY HH24:MI'), ");
		sqlStr.append("		TO_CHAR(T.RECEIVE_DATE, 'DD/MM/YYYY HH24:MI'), "); 
		sqlStr.append("		TO_CHAR(T.ENTRY_DATE, 'DD/MM/YYYY HH24:MI'), ");
		sqlStr.append("		TO_CHAR(T.TO_PBO_DATE, 'DD/MM/YYYY HH24:MI'), ");
		sqlStr.append("		TO_CHAR(T.FINISH_BILLING_DATE, 'DD/MM/YYYY HH24:MI'), ");
		sqlStr.append("		TO_CHAR(T.PAYMENT_SETTLEMENT_DATE, 'DD/MM/YYYY HH24:MI'), ");
		sqlStr.append("		TO_CHAR(T.NO_RX_DISCHARGE_DATE, 'DD/MM/YYYY HH24:MI'), ");
		sqlStr.append("		TO_CHAR(T.RX_BEDSIDE_DISCHARGE_DATE, 'DD/MM/YYYY HH24:MI'), ");
		sqlStr.append("		TO_CHAR(T.DRUG_PICKING_DATE, 'DD/MM/YYYY HH24:MI') ");
		sqlStr.append("FROM TICKET_QUEUE@IWEB T ");
		sqlStr.append("WHERE T.REGID = '" + regID + "' ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	private ArrayList<ReportableListObject> getLabel(String regID){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 	T.REGID, T.PATNO, P.PATFNAME || ' ' || P.PATGNAME, P.PATSEX, ");
		sqlStr.append("			R.DOCCODE, 'Dr. '|| D.DOCFNAME || ' ' || D.DOCGNAME, ");
		sqlStr.append("			T.BEDCODE, T.WRDCODE, T.START_DATE ");
		sqlStr.append("FROM TICKET_QUEUE@IWEB T, PATIENT@IWEB P, REG@IWEB R, DOCTOR@IWEB D ");
		sqlStr.append("WHERE T.PATNO = P.PATNO ");
		sqlStr.append("AND T.REGID = R.REGID ");
		sqlStr.append("AND R.DOCCODE = D.DOCCODE ");
		sqlStr.append("AND T.REGID = '" + regID + "' ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	private boolean reverseToRx(String regID, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET TO_RX_DATE = NULL, STATUS = 1, TO_RX_DATE_REMARK = NULL, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "  
					+ "WHERE REGID = ? AND STATUS = 2 ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, regID });
	}

	private boolean reverseReceiveOrder(String regID, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET RECEIVE_DATE = NULL, STATUS = 2, RECEIVE_DATE_REMARK = NULL, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "  
					+ "WHERE REGID = ? AND STATUS = 3 ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, regID });
	}
	
	private boolean reverseEntryCompleted(String regID, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET ENTRY_DATE = NULL, STATUS = 3, ENTRY_DATE_REMARK = NULL, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "  
					+ "WHERE REGID = ? AND STATUS = 4 ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, regID });
	}
	
	private boolean reverseToPBO(String regID, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET TO_PBO_DATE = NULL, STATUS = 4, TO_PBO_DATE_REMARK = NULL, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "   
					+ "WHERE REGID = ? AND STATUS >=5 AND FINISH_BILLING_DATE IS NULL AND PAYMENT_SETTLEMENT_DATE IS NULL ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, regID });
	}
/*
	private boolean reverseReceiveFromPharmacy(String regID, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET RECEIVE_FROM_RX_DATE = NULL, STATUS = 6, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "   
					+ "WHERE REGID = ? AND STATUS >= 4 AND STATUS != 11";
		return UtilDBWeb.updateQueue( sql, new String[] { user, regID });
	}
	*/
	private boolean reverseFinishBilling(String regID, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET FINISH_BILLING_DATE = NULL, STATUS = 5, FINISH_BILLING_DATE_REMARK = NULL, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "   
					+ "WHERE REGID = ? AND STATUS >= 6 AND PAYMENT_SETTLEMENT_DATE IS NULL ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, regID });
	}
	
	private boolean reversePaymentSettlement(String regID, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET PAYMENT_SETTLEMENT_DATE = NULL, STATUS = 6, PAYMENT_SETTLEMENT_DATE_REMARK = NULL, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "   
					+ "WHERE REGID = ? AND STATUS >= 7 ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, regID });
	}
	
	private boolean reverseNoDischarge(String regID, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET NO_RX_DISCHARGE_DATE = NULL, STATUS = 11, NO_RX_DISCHARGE_DATE_REMARK = NULL, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "   
					+ "WHERE REGID = ? AND STATUS >= 4 AND DRUG_PICKING_DATE IS NULL AND RX_BEDSIDE_DISCHARGE_DATE IS NULL ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, regID });
	}
	
	private boolean reverseBedsideDischarge(String regID, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET RX_BEDSIDE_DISCHARGE_DATE = NULL, STATUS = 11, BEDSIDE_DISCHARGE_DATE_REMARK = NULL, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "   
					+ "WHERE REGID = ? AND STATUS >= 4 AND STATUS != 11 AND NO_RX_DISCHARGE_DATE IS NULL AND DRUG_PICKING_DATE IS NULL ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, regID });
	}
	
	private boolean reverseDrugPicking(String regID, String user){
		String sql = "UPDATE TICKET_QUEUE@IWEB SET DRUG_PICKING_DATE = NULL, STATUS = 11, DRUG_PICKING_DATE_REMARK = NULL, MODIFIED_DATE = SYSDATE, MODIFIED_USER = ? "   
					+ "WHERE REGID = ? AND STATUS >= 4 AND NO_RX_DISCHARGE_DATE IS NULL AND RX_BEDSIDE_DISCHARGE_DATE IS NULL ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, regID });
	}

	
%><%
UserBean userBean = new UserBean(request);

String locid = request.getParameter("locid");
String queue = request.getParameter("queue");
String regID = request.getParameter("regID");
String remark = request.getParameter("remark");
String process = request.getParameter("process");
String nomed = request.getParameter("nomed");

if("reprint".equals(process)){
	JasperPrint jasperPrint = null;
	String reportPath = null;
	String filePath = null;
	String reportName = null;
	Map parameters = new HashMap();
	
	if (regID != null) {
		ArrayList<ReportableListObject> record1 = getLabel(regID);
		ReportableListObject row1 = null;
		if (record1.size() > 0) {
			row1 = (ReportableListObject) record1.get(0);
			parameters.put("regid", row1.getValue(0));
			parameters.put("patno", row1.getValue(1));
			parameters.put("patname", row1.getValue(2));
			parameters.put("patsex", row1.getValue(3));
			parameters.put("drname", row1.getValue(5));
			parameters.put("drcode", row1.getValue(4));
			parameters.put("bedcode", row1.getValue(6));
			parameters.put("wrdcode", row1.getValue(7));
			parameters.put("startdate", row1.getValue(8));
		}

		try {
			if (locid == null || locid.length() == 0 || "PBO".equals(locid)) {
				reportPath = "report/dischargeLabel_A4.jasper";
			} else {
				reportPath = "report/dischargeLabel.jasper";
			}

			// file.jasper path
			filePath = getServletConfig().getServletContext().getRealPath(reportPath);
			InputStream inputStream = new FileInputStream(filePath);
			jasperPrint = JasperFillManager.fillReport(inputStream, parameters);
		} catch (Exception e) {
			jasperPrint = null;
		}

		if (jasperPrint != null) {
			long sysTime = System.currentTimeMillis();
			reportName = jasperPrint.getName() + sysTime;
			jasperPrint.setName(reportName);

			String exportReportName = filePath.substring(0, filePath.length() - 7) + sysTime + ".pdf";
			JasperExportManager.exportReportToPdfFile(jasperPrint, exportReportName);
		}
	}
	%><%=reportName %><%
} else if ("getTime".equals(process)){
	if ("4".equals(queue)) {
		updateEntryCompleted(regID, userBean.getStaffID());
	} else if ("6".equals(queue)) {
		updateFinishBilling(regID, userBean.getStaffID());
	} else if ("9".equals(queue)) {
		updateBedsideDischarge(regID, userBean.getStaffID());
	} 
	ArrayList<ReportableListObject> record = getTime(regID);
	ReportableListObject row = null;
	if (record.size() > 0) {
		row = (ReportableListObject) record.get(0);
		SimpleDateFormat format = new SimpleDateFormat("dd/MM/yyyy HH:mm");
		Date sysTime = format.parse(row.getValue(1));
		Date date2 = null;
		if("6".equals(queue)){
			date2 = format.parse(row.getValue(6));
		}else{
			date2 = format.parse(row.getValue(4));
		}
		long diff = (sysTime.getTime()-date2.getTime())/60000;
		%><%=diff %><%
	}
} else if ("getRemark".equals(process)){
	ArrayList<ReportableListObject> record = getRemark(regID);
	ReportableListObject row = null;
	if (record.size() > 0) {
		row = (ReportableListObject) record.get(0);
		%>
		<script>
		$("#noMed").val('<%=row.getValue(11) %>');
		$("#remark").val('<%=row.getValue(Integer.parseInt(queue)) %>');
		</script>
		<%
	}
}  else if ("getPatno".equals(process)){
	ArrayList<ReportableListObject> record = getLabel(regID);
	ReportableListObject row = null;
	if (record.size() > 0) {
		row = (ReportableListObject) record.get(0);
		%>
		<%=row.getValue(1) %>
		<%
	}
} else if ("addRemark".equals(process)){
	if ("2".equals(queue)) {
		out.println("Remark - Ward to Rx : " + regID + " [" + updateToRxRemark(regID, remark, userBean.getStaffID()) + "]");
	} else if ("3".equals(queue)) {
		out.println("Remark - Pharmacy receive order : " + regID + " for receive order [" + updateReceiveOrderRemark(regID, remark, userBean.getStaffID(), nomed) + "]");
	} else if ("4".equals(queue)) {
		out.println("Remark - Entry completed: " + regID + " for entry completed [" + updateEntryCompletedRemark(regID, remark, userBean.getStaffID()) + "]");
	} else if ("5".equals(queue)) {
		out.println("Remark - Send to PBO: " + regID + " [" + updateToPBORemark(regID, remark, userBean.getStaffID()) + "]");
	} else if ("6".equals(queue)) {
		out.println("Remark - Finish Billing: " + regID + " [" + updateFinishBillingRemark(regID, remark, userBean.getStaffID()) + "]");
	} else if ("7".equals(queue)) {
		out.println("Remark - Payment Settlement: " + regID + " [" + updatePaymentSettlementRemark(regID, remark, userBean.getStaffID()) + "]");
	} else if ("8".equals(queue)) {
		out.println("Remark - No Pharmacy Discharge Med: " + regID + " [" + updateNoDischargeRemark(regID, remark, userBean.getStaffID()) + "]");
	} else if ("9".equals(queue)) {
		out.println("Remark - Pharmacy beside discharge: " + regID + " [" + updateBedsideDischargeRemark(regID, remark, userBean.getStaffID()) + "]");
	} else if ("10".equals(queue)) {
		out.println("Remark - Drug Picking by patient: " + regID + " [" + updateDrugPickingRemark(regID, remark, userBean.getStaffID()) + "]");
	} 
} else if ("reverse".equals(process)){
	if ("2".equals(queue)) {
		out.println("Reverse - Ward to Rx : " + regID + " [" + reverseToRx(regID, userBean.getStaffID()) + "]");
	} else if ("3".equals(queue)) {
		out.println("Reverse - Pharmacy receive order : " + regID + " for receive order [" + reverseReceiveOrder(regID, userBean.getStaffID()) + "]");
	} else if ("4".equals(queue)) {
		out.println("Reverse - Entry completed: " + regID + " for entry completed [" + reverseEntryCompleted(regID, userBean.getStaffID()) + "]");
	} else if ("5".equals(queue)) {
		out.println("Reverse - Send to PBO: " + regID + " [" + reverseToPBO(regID, userBean.getStaffID()) + "]");
	} else if ("6".equals(queue)) {
		out.println("Reverse - Finish Billing: " + regID + " [" + reverseFinishBilling(regID, userBean.getStaffID()) + "]");
	} else if ("7".equals(queue)) {
		out.println("Reverse - Payment Settlement: " + regID + " [" + reversePaymentSettlement(regID, userBean.getStaffID()) + "]");
	} else if ("8".equals(queue)) {
		out.println("Reverse - No Pharmacy Discharge Med: " + regID + " [" + reverseNoDischarge(regID, userBean.getStaffID()) + "]");
	} else if ("9".equals(queue)) {
		out.println("Reverse - Pharmacy beside discharge: " + regID + " [" + reverseBedsideDischarge(regID, userBean.getStaffID()) + "]");
	} else if ("10".equals(queue)) {
		out.println("Reverse - Drug Picking by patient: " + regID + " [" + reverseDrugPicking(regID, userBean.getStaffID()) + "]");
	} 
} else{
	if ("2".equals(queue)) {
		out.println("Ward to Rx: " + regID + " [" + updateToRx(regID, userBean.getStaffID()) + "]");
	} else if ("3".equals(queue)) {
		out.println("Pharmacy receive order: " + regID + " for receive order [" + updateReceiveOrder(regID, userBean.getStaffID()) + "]");
	} else if ("4".equals(queue)) {
		out.println("Entry completed: " + regID + " for entry completed [" + updateEntryCompleted(regID, userBean.getStaffID()) + "]");
	} else if ("5".equals(queue)) {
		out.println("Send to PBO: " + regID + " [" + updateToPBO(regID, userBean.getStaffID()) + "]");
	} else if ("6".equals(queue)) {
		out.println("Finish Billing: " + regID + " [" + updateFinishBilling(regID, userBean.getStaffID()) + "]");
	} else if ("7".equals(queue)) {
		out.println("Payment Settlement: " + regID + " [" + updatePaymentSettlement(regID, userBean.getStaffID()) + "]");
	} else if ("8".equals(queue)) {
		out.println("No Pharmacy Discharge Med: " + regID + " [" + updateNoDischarge(regID, userBean.getStaffID()) + "]");
	} else if ("9".equals(queue)) {
		out.println("Pharmacy beside discharge: " + regID + " [" + updateBedsideDischarge(regID, userBean.getStaffID()) + "]");
	} else if ("10".equals(queue)) {
		out.println("Drug Picking by patient: " + regID + " [" + updateDrugPicking(regID, userBean.getStaffID()) + "]");
	} 
}

%>