<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"
%><%@ page import="java.util.*"
%><%@ page import="com.hkah.util.file.*"
%><%@ page import="com.hkah.util.db.*"
%><%@ page import="com.hkah.web.common.*"
%><%@ page import="com.hkah.constant.*"
%><%@ page import="com.hkah.util.*"
%>
<%!
	private String getFolderPath(String parcde) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT Param1 ");
		sqlStr.append("FROM   Sysparam@IWEB_UAT ");
		sqlStr.append("WHERE  Parcde = ?");

		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { parcde });
		ReportableListObject row = null;
		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			return row.getValue(0);
		}
		return null;
	}
	
		private String[] getStmtInfo(String billNo) {
			String[] ret = new String[2];
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT BILLSTMTTYPE, SLPNO ");
		sqlStr.append("FROM   APPBILLS@IWEB_UAT ");
		sqlStr.append("WHERE  BILLID = ?");

		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { billNo });
		ReportableListObject row = null;
		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			ret[0] =  row.getValue(0);
			ret[1] =  row.getValue(1);
			
			return ret;
		}
		return null;
	}
%>
<%
	String[] result = getStmtInfo(request.getParameter("billNo"));
	String billId = request.getParameter("billNo");
	if (ConstantsServerSide.isTWAH() && result.length > 0) {
	  if ("INTERIMBILL".equals(result[0])) {
			String ret = ServerUtil.connectServer("http://192.168.0.31/intranet/mobile/genPatientStmt.jsp", "slpNo="+result[1]+"&slpType=I&lang=CHT&billID=" +billId);
		UtilFile.getServerImage(request, response, getFolderPath("ABillPath"), "billNo_"+request.getParameter("billNo") + ".pdf");
 		} else {
			try {
				UtilFile.getServerImage(request, response, getFolderPath("ABillPath"), "billNo_"+request.getParameter("billNo") + ".pdf");
			} catch (Exception e) {
				%><%
			}
%>		
 
<%	}} else {
		try {
			UtilFile.getServerImage(request, response, getFolderPath("ABillPath"), "billNo_"+request.getParameter("billNo") + ".pdf");
		} catch (Exception e) {
			%><%
		}
	}
%>