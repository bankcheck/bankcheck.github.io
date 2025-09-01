<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
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
	private boolean updateReceiveDate(String chemoPkgcode, String user){
		String sql = 	"UPDATE CHEMOTX@IWEB "
					+	"SET RECEIVE_DATE = SYSDATE, "
					+	"CHEMO_STATUS = 2, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_PKGCODE = ? "
					+	"AND TO_CHAR(START_DATE, 'DD/MM/YYYY') = TO_CHAR(SYSDATE, 'DD/MM/YYYY') "
					+	"AND CHEMO_STATUS = 1 ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, chemoPkgcode });
	}

	private boolean updatePreparationDate(String chemoPkgcode, String user){
		String sql = "UPDATE CHEMOTX@IWEB "
					+	"SET PREPARATION_DATE = SYSDATE, "
					+	"CHEMO_STATUS = 3, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_PKGCODE = ? "
					+	"AND CHEMO_STATUS = 2 ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, chemoPkgcode });
	}
	
	private boolean updatePreparationDateByItem(String chemoId, String user){
		String sql = "UPDATE CHEMOTX@IWEB "
					+	"SET PREPARATION_DATE = SYSDATE, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? "
					+	"AND CHEMO_STATUS = 3 ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, chemoId });
	}
	
	private boolean updateCheckingDate(String chemoPkgcode, String user){
		String sql = "UPDATE CHEMOTX@IWEB "
					+	"SET CHECKING_DATE = SYSDATE, "
					+	"CHEMO_STATUS = 4, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_PKGCODE = ? "
					+	"AND CHEMO_STATUS = 3 ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, chemoPkgcode });
	}
	
	private boolean updateCheckingDateByItem(String chemoId, String user){
		String sql = "UPDATE CHEMOTX@IWEB "
					+	"SET CHECKING_DATE = SYSDATE, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? "
					+	"AND CHEMO_STATUS = 4 ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, chemoId });
	}

	private boolean updateKasonInputDate(String chemoPkgcode, String user){
		String sql = "UPDATE CHEMOTX@IWEB "
					+	"SET KARSON_INPUT_DATE = SYSDATE, "
					//+	"CHEMO_STATUS = 5, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_PKGCODE = ? "
					+	"AND CHEMO_STATUS >= 2 ";
					System.out.println(sql);
		return UtilDBWeb.updateQueue( sql, new String[] { user, chemoPkgcode });
	}
	
	private boolean updateKasonInputDateByItem(String chemoId, String user){
		String sql = "UPDATE CHEMOTX@IWEB "
					+	"SET KARSON_INPUT_DATE = SYSDATE, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? "
					+	"AND CHEMO_STATUS >= 2 ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, chemoId });
	}
 	
	private boolean updateCleanRoomDate(String chemoPkgcode, String user){
		String sql = "UPDATE CHEMOTX@IWEB "
					+	"SET CLEAN_ROOM_DATE = SYSDATE, "
					+	"CHEMO_STATUS = 6, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_PKGCODE = ? "
					+	"AND CHEMO_STATUS = 4 ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, chemoPkgcode });
	}
	
	private boolean updateCleanRoomDateByItem(String chemoId, String user){
		String sql = "UPDATE CHEMOTX@IWEB "
					+	"SET CLEAN_ROOM_DATE = SYSDATE, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? "
					+	"AND CHEMO_STATUS = 6 ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, chemoId });
	}
	
	private boolean updateFinCheckDateByItem(String chemoId, String user){
		String sql = 	"UPDATE CHEMOTX@IWEB "
					+	"SET FINAL_CHECK_DATE = SYSDATE, "
					+	"CHEMO_STATUS = 7, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? "
					+	"AND CHEMO_STATUS = 6 ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, chemoId });
	}
	
	private boolean updateReadyDateByItem(String chemoId, String user){
		String sql = 	"UPDATE CHEMOTX@IWEB "
					+	"SET READY_DATE = SYSDATE, "
					+	"CHEMO_STATUS = 8, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? "
					+	"AND CHEMO_STATUS = 7 ";	
		return UtilDBWeb.updateQueue( sql, new String[] { user, chemoId });
	}
	
	private boolean updateDeliveryDateByItem(String chemoId, String user){
		String sql = 	"UPDATE CHEMOTX@IWEB "
					+	"SET DELIVERY_DATE = SYSDATE, "
					+	"CHEMO_STATUS = 9, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? "
					+	"AND CHEMO_STATUS = 8 ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, chemoId });
	}
	
	private boolean updateCounselingDateByItem(String chemoId, String user){
		String sql = "UPDATE CHEMOTX@IWEB "
					+	"SET COUNSELING_DATE = SYSDATE, "
					+	"CHEMO_STATUS = 10, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? "
					+	"AND CHEMO_STATUS = 9 ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, chemoId });
	}
	
	private boolean reverseReceiveConfirm(String chemoId, String user){
		String sql = 	"UPDATE CHEMOTX@IWEB "
					+	"SET RECEIVE_DATE = NULL, "
					+	"RECEIVE_REMARK = NULL, "
					+	"CHEMO_STATUS = 1, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? "
					+	"AND CHEMO_STATUS = 2 ";
		//System.out.println(sql + " + " + chemoId);
		return UtilDBWeb.updateQueue( sql, new String[] { user, chemoId });
	}

	private boolean reversePreparationDate(String chemoId, String user){
		String sql = 	"UPDATE CHEMOTX@IWEB "
					+	"SET PREPARATION_DATE = NULL, "
					+	"PREPARATION_REMARK = NULL, "
					+	"CHEMO_STATUS = 2, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? "
					+	"AND CHEMO_STATUS = 3 ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, chemoId });
	}
	
	private boolean reverseCheckingDate(String chemoId, String user){
		String sql = 	"UPDATE CHEMOTX@IWEB "
					+	"SET CHECKING_DATE = NULL, "
					+	"CHECKING_REMARK = NULL, "
					+	"CHEMO_STATUS = 3, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? "
					+	"AND CHEMO_STATUS = 4 ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, chemoId });
	}
	
	private boolean reverseKasonInputDate(String chemoId, String user){
		String sql = 	"UPDATE CHEMOTX@IWEB "
					+	"SET KARSON_INPUT_DATE = NULL, "
					+	"KARSON_INPUT_REMARK = NULL, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? "
					+	"AND KARSON_INPUT_DATE IS NOT NULL ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, chemoId });
	}

	private boolean reverseCleanRoomDate(String chemoId, String user){
		String sql = 	"UPDATE CHEMOTX@IWEB "
					+	"SET CLEAN_ROOM_DATE = NULL, "
					+	"CLEAN_ROOM_REMARK = NULL, "
					+	"CHEMO_STATUS = 4, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? "
					+	"AND CHEMO_STATUS = 6 ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, chemoId });
	}
	
	private boolean reverseFinCheckDate(String chemoId, String user){
		String sql = 	"UPDATE CHEMOTX@IWEB "
					+	"SET FINAL_CHECK_DATE = NULL, "
					+	"FINAL_CHECK_REMARK = NULL, "
					+	"CHEMO_STATUS = 6, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? "
					+	"AND CHEMO_STATUS = 7 ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, chemoId });
	}
	
	private boolean reverseReadyDate(String chemoId, String user){
		String sql = 	"UPDATE CHEMOTX@IWEB "
					+	"SET READY_DATE = NULL, "
					+	"READY_REMARK = NULL, "
					+	"CHEMO_STATUS = 7, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? "
					+	"AND CHEMO_STATUS = 8 ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, chemoId });
	}
	
	private boolean reverseDeliveryDate(String chemoId, String user){
		String sql = 	"UPDATE CHEMOTX@IWEB "
					+	"SET DELIVERY_DATE = NULL, "
					+	"DELIVERY_REMARK = NULL, "
					+	"CHEMO_STATUS = 8, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? "
					+	"AND CHEMO_STATUS = 9 ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, chemoId });
	}
	
	private boolean reverseCounselingDate(String chemoId, String user){
		String sql = 	"UPDATE CHEMOTX@IWEB "
					+	"SET COUNSELING_DATE = NULL, "
					+	"COUNSELING_REMARK = NULL, "
					+	"CHEMO_STATUS = 9, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? "
					+	"AND CHEMO_STATUS = 10 ";
		return UtilDBWeb.updateQueue( sql, new String[] { user, chemoId });
	}
	
	private boolean updateReceiveConfirmRemark(String chemoId, String remark, String user){
		String sql = 	"UPDATE CHEMOTX@IWEB "
					+	"SET RECEIVE_REMARK = ?, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? ";
		return UtilDBWeb.updateQueue( sql, new String[] { remark, user, chemoId });
	}
	
	private boolean updatePreparationDateRemark(String chemoId, String remark, String user){
		String sql = 	"UPDATE CHEMOTX@IWEB "
					+	"SET PREPARATION_REMARK = ?, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? ";
		return UtilDBWeb.updateQueue( sql, new String[] { remark, user, chemoId });
	}
	
	private boolean updateCheckingDateRemark(String chemoId, String remark, String user){
		String sql = 	"UPDATE CHEMOTX@IWEB "
					+	"SET CHECKING_REMARK = ?, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? ";
		return UtilDBWeb.updateQueue( sql, new String[] { remark, user, chemoId });
	}
	
	private boolean updateKasonInputDateRemark(String chemoId, String remark, String user){
		String sql = 	"UPDATE CHEMOTX@IWEB "
					+	"SET KARSON_INPUT_REMARK = ?, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? ";
		return UtilDBWeb.updateQueue( sql, new String[] { remark, user, chemoId });
	}
	
	private boolean updateCleanRoomDateRemark(String chemoId, String remark, String user){
		String sql = 	"UPDATE CHEMOTX@IWEB "
					+	"SET CLEAN_ROOM_REMARK = ?, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? ";
		return UtilDBWeb.updateQueue( sql, new String[] { remark, user, chemoId });
	}
	
	private boolean updateFinCheckDateRemark(String chemoId, String remark, String user){
		String sql = 	"UPDATE CHEMOTX@IWEB "
					+	"SET FINAL_CHECK_REMARK = ?, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? ";
		return UtilDBWeb.updateQueue( sql, new String[] { remark, user, chemoId });
	}
	
	private boolean updateReadyDateRemark(String chemoId, String remark, String user){
		String sql = 	"UPDATE CHEMOTX@IWEB "
					+	"SET READY_REMARK = ?, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? ";
		return UtilDBWeb.updateQueue( sql, new String[] { remark, user, chemoId });
	}
	
	private boolean updateDeliveryDateRemark(String chemoId, String remark, String user){
		String sql = 	"UPDATE CHEMOTX@IWEB "
					+	"SET DELIVERY_REMARK = ?, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? ";
		return UtilDBWeb.updateQueue( sql, new String[] { remark, user, chemoId });
	}
	
	private boolean updateCounselingDateRemark(String chemoId, String remark, String user){
		String sql = 	"UPDATE CHEMOTX@IWEB "
					+	"SET COUNSELING_REMARK = ?, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? ";
		return UtilDBWeb.updateQueue( sql, new String[] { remark, user, chemoId });
	}
	
	private ArrayList<ReportableListObject> getRemark(String chemoId){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 	C.CHEMO_PKGCODE, T.CHEMO_ID, ");
		sqlStr.append("			RECEIVE_REMARK, PREPARATION_REMARK, CHECKING_REMARK, KARSON_INPUT_REMARK, ");//2,3,4,5
		sqlStr.append("			CLEAN_ROOM_REMARK, FINAL_CHECK_REMARK, READY_REMARK, DELIVERY_REMARK, COUNSELING_REMARK ");//6, 7, 8, 9, 10
		sqlStr.append("FROM CHEMOTRACK@IWEB C, CHEMOTX@IWEB T ");
		sqlStr.append("WHERE C.CHEMO_PKGCODE = T.CHEMO_PKGCODE ");
		sqlStr.append("AND T.CHEMO_ID = '" + chemoId + "' ");
		sqlStr.append("AND T.CHEMO_STATUS != 0 ");
		sqlStr.append("AND C.ENABLED = 1 ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	private ArrayList<ReportableListObject> getPatInfo(String patno){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT PATFNAME ||' '|| PATGNAME ");
		sqlStr.append("FROM PATIENT@IWEB ");
		sqlStr.append("WHERE PATNO = '" + patno + "' ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	private ArrayList<ReportableListObject> getPkgInfo(String chemoPkgcode){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 	C.CHEMO_PKGCODE, T.CHEMO_ID, TO_CHAR(T.START_DATE, 'DD/MM/YYYY'), C.PATNO, P.PATFNAME ||' '|| P.PATGNAME, ");
		sqlStr.append("			T.CHEMO_ITMCODE, I.CHEMO_PHARCODE, I.CHEMO_ITMNAME, T.DOSE, TO_CHAR(C.NEXT_DATE, 'DD/MM/YYYY'), T.CHEMO_STATUS, ");
		sqlStr.append("			C.HASCOUNSELING, TO_CHAR(C.COUNSELING_DATE, 'DD/MM/YYYY'), C.REMARK, ");
		sqlStr.append("			CASE WHEN (T.CHEMO_STATUS = 9 AND T.KARSON_INPUT_DATE IS NOT NULL) THEN '1' ELSE '0' END AS COMPLETED ");
		sqlStr.append("FROM CHEMOTRACK@IWEB C, CHEMOTX@IWEB T, CHEMOITEM@IWEB I, PATIENT@IWEB P ");
		sqlStr.append("WHERE C.CHEMO_PKGCODE = T.CHEMO_PKGCODE ");
		sqlStr.append("AND T.CHEMO_ITMCODE = I.CHEMO_ITMCODE ");
		sqlStr.append("AND C.PATNO = P.PATNO ");
		sqlStr.append("AND C.CHEMO_PKGCODE = '" + chemoPkgcode + "' ");
		sqlStr.append("AND T.CHEMO_STATUS != 0 ");
		sqlStr.append("AND C.ENABLED = 1 ");
		sqlStr.append("ORDER BY T.START_DATE ");
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	private ArrayList<ReportableListObject> getTicket(String chemoPkgcode){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DISTINCT C.CHEMO_PKGCODE, C.PATNO, P.PATFNAME ||' '|| P.PATGNAME, TO_CHAR(C.NEXT_DATE, 'dd/MM/YYYY'), T.CHEMO_ITMCODE, I.CHEMO_PHARCODE, I.CHEMO_ITMNAME, T.DOSE ");
		sqlStr.append("FROM CHEMOTRACK@IWEB C, CHEMOTX@IWEB T, CHEMOITEM@IWEB I, PATIENT@IWEB P  ");
		sqlStr.append("WHERE C.CHEMO_PKGCODE = T.CHEMO_PKGCODE ");
		sqlStr.append("AND T.CHEMO_ITMCODE = I.CHEMO_ITMCODE ");
		sqlStr.append("AND C.PATNO = P.PATNO ");
		sqlStr.append("AND T.CHEMO_STATUS != 0 ");
		sqlStr.append("AND C.ENABLED = 1 ");
		sqlStr.append("AND C.CHEMO_PKGCODE = '" + chemoPkgcode + "' ");
		sqlStr.append("GROUP BY C.CHEMO_PKGCODE, C.PATNO, P.PATFNAME ||' '|| P.PATGNAME, C.NEXT_DATE, T.CHEMO_ITMCODE, I.CHEMO_PHARCODE, I.CHEMO_ITMNAME, T.DOSE ");
		sqlStr.append("ORDER BY C.CHEMO_PKGCODE, I.CHEMO_PHARCODE ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	private static String saveChemo(String patno, String nextSchedule, String userid, String selectItem, String allowCounseling, String counselingDate, String pkgRemark){
		String chemoPkgcode = "";
		ArrayList<ReportableListObject> record = new ArrayList();
		record = UtilDBWeb.getFunctionResultsHATS("NHS_ACT_CHEMO_LOG", new String[] {"ADD", patno, nextSchedule, userid, selectItem, "", "", allowCounseling, counselingDate, pkgRemark});
		ReportableListObject row = null;
		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			chemoPkgcode = row.getValue(0);
		}
		return chemoPkgcode;
	}
	
	private static String updateChemo(String patno, String chemoPkgcode, String nextSchedule, String userid, String selectItem, String removeItem, String allowCounseling, String counselingDate, String pkgRemark){
		ArrayList<ReportableListObject> record = new ArrayList();
		record = UtilDBWeb.getFunctionResultsHATS("NHS_ACT_CHEMO_LOG", new String[] {"MOD", patno, nextSchedule, userid, selectItem, chemoPkgcode, removeItem, allowCounseling, counselingDate, pkgRemark});
		ReportableListObject row = null;
		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			chemoPkgcode = row.getValue(0);
		}
		return chemoPkgcode;
	}
	
	private static String cancelChemo(String patno, String chemoPkgcode, String userid, String pkgRemark){
		ArrayList<ReportableListObject> record = new ArrayList();
		record = UtilDBWeb.getFunctionResultsHATS("NHS_ACT_CHEMO_LOG", new String[] {"DEL", patno, "", userid, "", chemoPkgcode, "", "", "", pkgRemark});
		ReportableListObject row = null;
		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			chemoPkgcode = row.getValue(0);
		}
		return chemoPkgcode;
	}
	
	private boolean updateChemoDose(String chemoId, String chemoDose, String user){
		String sql = 	"UPDATE CHEMOTX@IWEB "
					+	"SET DOSE = ?, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? ";
		return UtilDBWeb.updateQueue( sql, new String[] { chemoDose, user, chemoId });
	}
	
	private boolean updateChemoPredict(String chemoPkgcode, String nextSchedule, String user){
		String sql = 	"UPDATE CHEMOTRACK@IWEB "
					+	"SET NEXT_DATE = TO_DATE(?, 'DD/MM/YYYY'), "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_PKGCODE = ? ";
		return UtilDBWeb.updateQueue( sql, new String[] { nextSchedule, user, chemoPkgcode });
	}	
	
	private boolean updateCheckUser(String chemoId, String finCheckUserID, String user){
		String sql = 	"UPDATE CHEMOTX@IWEB "
					+	"SET FINAL_CHECK_USER = ?, "
					+	"UPDATE_DATE = SYSDATE, "
					+	"UPDATE_USER = ? " 
					+	"WHERE CHEMO_ID = ? ";
		return UtilDBWeb.updateQueue( sql, new String[] { finCheckUserID, user, chemoId });
	}	
%><%
UserBean userBean = new UserBean(request);

String process = request.getParameter("process");
String patno = request.getParameter("patno");
String queue = request.getParameter("queue");
String regID = request.getParameter("regID");
String remark = request.getParameter("remark");

String selectItem = request.getParameter("selectItem");
String removeItem = request.getParameter("removeItem");
String nextSchedule = request.getParameter("nextSchedule");
String chemoPkgcode = request.getParameter("chemoPkgcode");
String chemoId = request.getParameter("chemoid");
String chemoDose = request.getParameter("chemoDose");
boolean canRemove = "N".equals(request.getParameter("canRemove"))?false:true;
boolean canUpdateDose = "N".equals(request.getParameter("canUpdateDose"))?false:true;

String allowCounseling = "true".equals(request.getParameter("allowCounseling"))?"Y":"N";
String counselingDate =  request.getParameter("counselingDate");
String pkgRemark = request.getParameter("pkgRemark");
String finCheckUserID = request.getParameter("finCheckUserID");

if("getPatInfo".equals(process)){
	ArrayList<ReportableListObject> record = getPatInfo(patno);
	ReportableListObject row = null;
	if (record.size() > 0) {
		row = (ReportableListObject) record.get(0);
		%><%=row.getValue(0) %><%
	}
} else if("getPkgInfo".equals(process)){
	ArrayList<ReportableListObject> record = getPkgInfo(chemoPkgcode);
	ReportableListObject row = null;
	if (record.size() > 0) {
		for(int i=0; i<record.size(); i++){
			row = (ReportableListObject) record.get(i);
			String vChemoPkgcode = row.getValue(0);
			String vChemoId = row.getValue(1);
			String vStartDate = row.getValue(2);
			String vPatno = row.getValue(3);
			String vPatName = row.getValue(4);
			String vChemoItmcode = row.getValue(5);
			String vChemoPharcode = row.getValue(6);
			String vChemoItmName = row.getValue(7);
			String vDose = row.getValue(8);
			String vNextDate = row.getValue(9);
			String vStatus = row.getValue(10);
			Boolean vhasCounseling = "Y".equals(row.getValue(11))?true:false;
			String vcounselingDate = row.getValue(12);
			String vPkgRemark = row.getValue(13);
			Boolean vCompleted = "1".equals(row.getValue(14))?true:false;
			
%>
	<tr class=' <%if (vCompleted){%> completedRow <%}%> exitstingitem' id='<%=vChemoId %>'>
<%		if(canRemove){ %>
		<td class='w3-center'>
			<button class='removeitem' onclick='removeItem(this)'>X</button>
		</td>
<%		}%>
		<td class="startDate">
			<%=vStartDate %>
		</td>
		<td>
			<%=vChemoItmName %>
		</td>
		<td>
			1
		</td>
		<td>
<%		if(canUpdateDose){ %>
			<input type='text' name='dose-<%=vChemoId %>' id='dose-<%=vChemoId %>' class='w3-input w3-border submitDose' value="<%=vDose %>"/>
<%		}else{%>
			<%=vDose %>
<%		}%>
			
		</td>
	</tr>
	<script>
		$('#patno').val("<%=vPatno %>");
		$('#patno').attr('readonly', true);
		$('#patName').html("<%=vPatName %>");
		$('#nextSchedule').val("<%=vNextDate %>");
		$('#chemoPkgcode').val("<%=vChemoPkgcode %>");
		$('#pkgRemark').val("<%=vPkgRemark %>");
<%	if(vhasCounseling){ %>
		$('#allowCounseling').prop('checked', true);
		$('#counselingDate').val("<%=vcounselingDate %>");
<% 	}else{ %>
		$('#allowCounseling').prop('checked', false);
		$('#counselingDate').val("");
<%	} %>
		
		
	</script>
<%
		}
	}
} else if("appendToNewCase".equals(process)){
	ArrayList<ReportableListObject> record = getTicket(chemoPkgcode);
	ReportableListObject row = null;
	if (record.size() > 0) {
		for(int i=0; i<record.size(); i++){
			row = (ReportableListObject) record.get(i);
			String vChemoPkgcode = row.getValue(0);
			String vPatno = row.getValue(1);
			String vPatName = row.getValue(2);
			String vNextDate = row.getValue(3);
			String vChemoItmcode = row.getValue(4);
			String vChemoPharcode = row.getValue(5);
			String vChemoItmName = row.getValue(6);
			String vDose = row.getValue(7);
			
%>
	<script>
	var chemoCount = $("table#addChemoTable >tbody >tr").length+1;
	if(chemoCount == 11){
		alert("Error occur. New chemotherapy tracking cannot add more than 10 items.");
	}else {
		$('#addChemoTable')
			.find('tbody')
				.append($("<tr class='eachitem' id='"+ chemoCount +"'>")
				.append($("<td class='w3-center'>").append("<button class='removeitem' onclick='removeItem(this)'>X</button>"))
				.append($("<td>").append("<input type='text' name='startdate"+chemoCount+"' id='startdate"+chemoCount+"' class='w3-input w3-border startChemoDate submitDate' value='' maxlength='10' size='10' onkeyup='validDate(this)' onblur='validDate(this)'>"))
				.append($("<td>").append("<select name='chemo"+chemoCount+"' id='chemo"+chemoCount+"' class='w3-select w3-border submitChemoItem'><option value='<%=vChemoItmcode%>'>[<%=vChemoPharcode %>] <%=vChemoItmName%></option></select>"))
				.append($("<td>").append("<input type='number' name='dur"+chemoCount+"' id='dur"+chemoCount+"' class='w3-input w3-border submitDur' min=1 max=9 value='1'/>"))
				.append($("<td>").append("<input type='text' name='dose"+chemoCount+"' id='dose"+chemoCount+"' class='w3-input w3-border submitDose' value='<%=vDose %>'/>")));
	}
	</script>
<%
		}
	}
} else if("getTicket".equals(process)){
	ArrayList<ReportableListObject> record = getTicket(chemoPkgcode);
	ReportableListObject row = null;
	if (record.size() > 0) {
		for(int i=0; i<record.size(); i++){
			row = (ReportableListObject) record.get(i);
			String vChemoPkgcode = row.getValue(0);
			String vPatno = row.getValue(1);
			String vPatName = row.getValue(2);
			String vNextDate = row.getValue(3);
			String vChemoItmcode = row.getValue(4);
			String vChemoPharcode = row.getValue(5);
			String vChemoItmName = row.getValue(6);
			String vDose = row.getValue(7);
			
%>
	<tr class=' exitstingitem'>
		<td>
			[<%=vChemoPharcode %>] <%=vChemoItmName %>
		</td>
		<td>
			<%=vDose %>
		</td>
	</tr>
	<script>
		$('#patno').val("<%=vPatno %>");
		$('#patno').attr('readonly', true);
		$('#patName').html("<%=vPatName %>");
		$('#nextSchedule').val("<%=vNextDate %>");
		$('#chemoPkgcode').val("<%=vChemoPkgcode %>");
	</script>
<%
		}
	}
} else if("submitNewCase".equals(process)){
	chemoPkgcode = saveChemo(patno, nextSchedule, userBean.getStaffID(), selectItem, allowCounseling, counselingDate, pkgRemark);
	%>
		<%=chemoPkgcode %>
	<%
} else if("updateChemoCase".equals(process)){
	chemoPkgcode = updateChemo(patno, chemoPkgcode, nextSchedule, userBean.getStaffID(), selectItem, removeItem, allowCounseling, counselingDate, pkgRemark);
	%>
		<%=chemoPkgcode %>
	<%
} else if("cancelChemoCase".equals(process)){
	chemoPkgcode = cancelChemo(patno, chemoPkgcode, userBean.getStaffID(), pkgRemark);
	%>
		<%=chemoPkgcode %>
	<%
} else if("updateChemoDose".equals(process)){
	updateChemoDose(chemoId, chemoDose, userBean.getStaffID());
} else if("updateCheckUser".equals(process)){
	updateCheckUser(chemoId, finCheckUserID, userBean.getStaffID());
} else if("updateChemoPredict".equals(process)){
	updateChemoPredict(chemoPkgcode, nextSchedule, userBean.getStaffID());
} else if ("getRemark".equals(process)){
	ArrayList<ReportableListObject> record = getRemark(chemoId);
	ReportableListObject row = null;
	if (record.size() > 0) {
		row = (ReportableListObject) record.get(0);
		%>
		<script>
		$("#remark").val('<%=row.getValue(Integer.parseInt(queue)) %>');
		</script>
		<%
	}
} else if ("addRemark".equals(process)){
	if ("2".equals(queue)) {
		out.println("Remark - Receive Confirmation : " + chemoId + " [" + updateReceiveConfirmRemark(chemoId, remark, userBean.getStaffID()) + "]");
	} else if ("3".equals(queue)) {
		out.println("Remark - Materials Preparation Finish : " + chemoId + " [" + updatePreparationDateRemark(chemoId, remark, userBean.getStaffID()) + "]");
	} else if ("4".equals(queue)) {
		out.println("Remark - Materials Checking Finish: " + chemoId + " [" + updateCheckingDateRemark(chemoId, remark, userBean.getStaffID()) + "]");
	} else if ("5".equals(queue)) {
		out.println("Remark - KARSON input completed: " + chemoId + " [" + updateKasonInputDateRemark(chemoId, remark, userBean.getStaffID()) + "]");
	} else if ("6".equals(queue)) {
		out.println("Remark - Entered into Clean Room: " + chemoId + " [" + updateCleanRoomDateRemark(chemoId, remark, userBean.getStaffID()) + "]");
	} else if ("7".equals(queue)) {
		out.println("Remark - Fin. Vol Checking: " + chemoId + " [" + updateFinCheckDateRemark(chemoId, remark, userBean.getStaffID()) + "]");
	} else if ("8".equals(queue)) {
		out.println("Remark - Fin. Product Ready to send out: " + chemoId + " [" + updateReadyDateRemark(chemoId, remark, userBean.getStaffID()) + "]");
	} else if ("9".equals(queue)) {
		out.println("Remark - Fin. Product Delivery Completed: " + chemoId + " [" + updateDeliveryDateRemark(chemoId, remark, userBean.getStaffID()) + "]");
	} else if ("10".equals(queue)) {
		out.println("Remark - 1st Dose Chemo Counseling: " + chemoId + " [" + updateCounselingDateRemark(chemoId, remark, userBean.getStaffID()) + "]");
	} 
} else if ("reverseStatus".equals(process)){
	if ("2".equals(queue)) {
		out.println("Reverse - Receive Confirmation : " + chemoId + " [" + reverseReceiveConfirm(chemoId, userBean.getStaffID()) + "]");
	} else if ("3".equals(queue)) {
		out.println("Reverse - Materials Preparation Finish : " + chemoId + " [" + reversePreparationDate(chemoId, userBean.getStaffID()) + "]");
	} else if ("4".equals(queue)) {
		out.println("Reverse - Materials Checking Finish: " + chemoId + " [" + reverseCheckingDate(chemoId, userBean.getStaffID()) + "]");
	} else if ("5".equals(queue)) {
		out.println("Reverse - KARSON input completed: " + chemoId + " [" + reverseKasonInputDate(chemoId, userBean.getStaffID()) + "]");
	} else if ("6".equals(queue)) {
		out.println("Reverse - Entered into Clean Room: " + chemoId + " [" + reverseCleanRoomDate(chemoId, userBean.getStaffID()) + "]");
	} else if ("7".equals(queue)) {
		out.println("Reverse - Fin. Vol Checking: " + chemoId + " [" + reverseFinCheckDate(chemoId, userBean.getStaffID()) + "]");
	} else if ("8".equals(queue)) {
		out.println("Reverse - Fin. Product Ready to send out: " + chemoId + " [" + reverseReadyDate(chemoId, userBean.getStaffID()) + "]");
	} else if ("9".equals(queue)) {
		out.println("Reverse - Fin. Product Delivery Completed: " + chemoId + " [" + reverseDeliveryDate(chemoId, userBean.getStaffID()) + "]");
	} else if ("10".equals(queue)) {
		out.println("Reverse - 1st Dose Chemo Counseling: " + chemoId + " [" + reverseCounselingDate(chemoId, userBean.getStaffID()) + "]");
	} 
} else if ("updateStatus".equals(process)){
	if ("2".equals(queue)) {
		out.println("Receive Confirmation: " + chemoPkgcode + " [" + updateReceiveDate(chemoPkgcode, userBean.getStaffID()) + "]");
	} else if ("3".equals(queue)) {
		out.println("Materials Preparation Finish: " + chemoPkgcode + " [" + updatePreparationDate(chemoPkgcode, userBean.getStaffID()) + "]");
	} else if ("4".equals(queue)) {
		out.println("Materials Checking Finish: " + chemoPkgcode + " [" + updateCheckingDate(chemoPkgcode, userBean.getStaffID()) + "]");
	} else if ("5".equals(queue)) {
		out.println("KARSON input completed: " + chemoPkgcode + " [" + updateKasonInputDate(chemoPkgcode, userBean.getStaffID()) + "]");
	} else if ("6".equals(queue)) {
		out.println("Entered into Clean Room: " + chemoPkgcode + " [" + updateCleanRoomDate(chemoPkgcode, userBean.getStaffID()) + "]");
	}
} else if ("updateStatusByItem".equals(process)){
	if ("3".equals(queue)) {
		out.println("Materials Preparation Finish: " + chemoId + " [" + updatePreparationDateByItem(chemoId, userBean.getStaffID()) + "]");
	} else if ("4".equals(queue)) {
		out.println("Materials Checking Finish: " + chemoId + " [" + updateCheckingDateByItem(chemoId, userBean.getStaffID()) + "]");
	} else if ("5".equals(queue)) {
		out.println("KARSON input completed: " + chemoId + " [" + updateKasonInputDateByItem(chemoId, userBean.getStaffID()) + "]");
	} else if ("6".equals(queue)) {
		out.println("Entered into Clean Room: " + chemoId + " [" + updateCleanRoomDateByItem(chemoId, userBean.getStaffID()) + "]");
	} else if ("7".equals(queue)) {
		out.println("Fin. Vol Checking: " + chemoId + " [" + updateFinCheckDateByItem(chemoId, userBean.getStaffID()) + "]");
	} else if ("8".equals(queue)) {
		out.println("Fin. Product Ready to send out: " + chemoId + " [" + updateReadyDateByItem(chemoId, userBean.getStaffID()) + "]");
	} else if ("9".equals(queue)) {
		out.println("Fin. Product Delivery Completed: " + chemoId + " [" + updateDeliveryDateByItem(chemoId, userBean.getStaffID()) + "]");
	} else if ("10".equals(queue)) {
		out.println("1st Dose Chemo Counseling: " + chemoId + " [" + updateCounselingDateByItem(chemoId, userBean.getStaffID()) + "]");
	} 
}

%>