<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.*"%>
<%
String regid = request.getParameter("regid");
String patno = request.getParameter("patno");
String seq = request.getParameter("seq");
String hour = request.getParameter("hour");
ArrayList record = null;

String formID = "FTOCC";

String data = null;

if (seq != null) {
	//System.out.println("[DEBUG] FTOCC get data: regid=" + regid + " seq=" + seq);
	record = PatientDB.getFTOCCRec(regid, seq);
} else {
	//System.out.println("[DEBUG] FTOCC get data: regid=" + regid + " hour=" + hour);
	record = PatientDB.getLastFTOCC(patno, hour);
}
if (record.size() > 0) {
	ReportableListObject row = (ReportableListObject) record.get(0);
	
	ReportableListObject version = CMSDB.getFormVersion(formID, row.getValue(3), "dd/mm/yyyy hh24:mi:ss");
	String formPath = version.getValue(0);
	
	data = "{\"sys\":\"" + row.getValue(1) +
			"\",\"usr\":\"" + row.getValue(2) +
			"\",\"createdt\":\"" + row.getValue(3) +
			"\",\"rbFever1\":\"" + row.getValue(4) + 
			"\",\"rbFever2\":\"" + row.getValue(5) + 
			"\",\"rbTravel1\":\"" + row.getValue(6) + 
			"\",\"rbTravel2\":\"" + row.getValue(7) + 
			"\",\"rbOcc1\":\"" + row.getValue(8) + 
			"\",\"rbOcc2\":\"" + row.getValue(9) + 
			"\",\"rbContact\":\"" + row.getValue(10) + 
			"\",\"rbCluster\":\"" + row.getValue(11) + 
			"\",\"rbHosp\":\"" + row.getValue(12) + 
			"\",\"txTemp\":\"" + row.getValue(13) + 
			"\",\"txMed\":\"" + row.getValue(14).replace("\\", "\\\\").replace("\"", "\\\"") + 
			"\",\"txTravel\":\"" + row.getValue(15).replace("\\", "\\\\").replace("\"", "\\\"") + 
			"\",\"txHosp\":\"" + row.getValue(16).replace("\\", "\\\\").replace("\"", "\\\"") + 
			"\",\"dtAdm\":\"" + row.getValue(17) + 
			"\",\"txDuration\":\"" + row.getValue(18).replace("\\", "\\\\").replace("\"", "\\\"") +
			"\",\"txDiag\":\"" + row.getValue(19).replace("\\", "\\\\").replace("\"", "\\\"") +
//20240702 added new fields			
			"\",\"rbContact1\":\"" + row.getValue(20) + 
			"\",\"rbContact2\":\"" + row.getValue(21) + 
			"\",\"rbContact3\":\"" + row.getValue(22) + 
			"\",\"formPath\":\"" + formPath +  			
			"\"}";
				  
} else {
	data = "null";
}

//System.out.println(data);
%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="UTF-8"%>
<%=data %>