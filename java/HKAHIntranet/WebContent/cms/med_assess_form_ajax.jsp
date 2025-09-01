<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="java.io.*,java.util.*" %>
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
<%@ page import="javax.servlet.*,java.text.*" %>
<%@ page import="org.json.JSONObject" %>
<%@ page import="org.json.JSONArray" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%!
private String getSystemParameter(String key) {
	ArrayList<ReportableListObject> record = UtilDBWeb.getReportableListHATS("select param1 from sysparam where parcde = ?", new String[] { key });
	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		return row.getValue(0);
	} else {
		return null;
	}
}

private boolean saveIpMedicalNote(String regid, String patno, String ipCC, String ipPhyExam, 
		String ipCvs, String ipRes, String ipCns, String ipAbd, String ipTargetExam, 
		String ipPastHealthFlag, String ipPastHealth, String ipPsyFlag, String ipPsy, 
		String ipImp, String ipPlan, String doccode, String usrid){
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("INSERT INTO IPD_DOCASSESS@CIS ");
	sqlStr.append("(REGID, PATNO, NOTE_DATE, CURR_CMPLT, PHY_EXAM, ");
	sqlStr.append("PHY_CVS_FLAG, PHY_RES_FLAG, PHY_CNS_FLAG, PHY_ABD_FLAG, ");
	sqlStr.append("PHY_TARGET_EXAM, PAST_HEALTH_FLAG, PAST_HEALTH, PSY_FLAG, PSY, ");
	sqlStr.append("IMP, PLAN, DOCCODE, UPDATE_USER, UPDATE_DATE) ");
	sqlStr.append("VALUES ");
	sqlStr.append("(?, ?, SYSDATE, ?, ?, ");
	sqlStr.append(" ?, ?, ?, ?, ");
	sqlStr.append(" ?, ?, ?, ?, ?, ");
	sqlStr.append(" ?, ?, ?, ?, SYSDATE ) ");

	//System.out.println(sqlStr.toString());
	return UtilDBWeb.updateQueue(sqlStr.toString(),  new String[] { regid, patno, ipCC, ipPhyExam, 
																	ipCvs, ipRes, ipCns, ipAbd, ipTargetExam, 
																	ipPastHealthFlag, ipPastHealth, ipPsyFlag, ipPsy, 
																	ipImp, ipPlan, doccode, usrid });
}

private boolean updateIpMedicalNote(String regid, String patno, String ipCC, String ipPhyExam, 
		String ipCvs, String ipRes, String ipCns, String ipAbd, String ipTargetExam, 
		String ipPastHealthFlag, String ipPastHealth, String ipPsyFlag, String ipPsy, 
		String ipImp, String ipPlan, String doccode, String usrid){
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("UPDATE IPD_DOCASSESS@CIS ");
	sqlStr.append("SET ");
	sqlStr.append("CURR_CMPLT = ?, ");
	sqlStr.append("PHY_EXAM = ?, ");
	sqlStr.append("PHY_CVS_FLAG = ?, ");
	sqlStr.append("PHY_RES_FLAG = ?, ");
	sqlStr.append("PHY_CNS_FLAG = ?, ");
	sqlStr.append("PHY_ABD_FLAG = ?, ");
	sqlStr.append("PHY_TARGET_EXAM = ?, ");
	sqlStr.append("PAST_HEALTH_FLAG = ?, "); 
	sqlStr.append("PAST_HEALTH = ?, ");
	sqlStr.append("PSY_FLAG = ?, ");
	sqlStr.append("PSY = ?, ");
	sqlStr.append("IMP = ?, ");
	sqlStr.append("PLAN = ?, ");
	sqlStr.append("DOCCODE = ?, ");
	sqlStr.append("UPDATE_USER = ?, ");
	sqlStr.append("UPDATE_DATE = SYSDATE ");
	sqlStr.append("WHERE REGID = ? ");

	//System.out.println(sqlStr.toString());
	return UtilDBWeb.updateQueue(sqlStr.toString(),  new String[] { ipCC, ipPhyExam, 
																	ipCvs, ipRes, ipCns, ipAbd, ipTargetExam, 
																	ipPastHealthFlag, ipPastHealth, ipPsyFlag, ipPsy, 
																	ipImp, ipPlan, doccode, usrid,  
																	regid});
}

private ArrayList getIpMedicalNote(String regid) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT I.REGID, I.PATNO, ");
	sqlStr.append("P.PATFNAME||', '||P.PATGNAME AS PATNAME, P.PATCNAME, TO_CHAR(P.PATBDATE, 'DD/MM/YYYY'), P.PATSEX, ");
	sqlStr.append("TO_CHAR(I.NOTE_DATE, 'DD/MM/YYYY HH24:MI'), I.CURR_CMPLT, I.PHY_EXAM, ");
	sqlStr.append("I.PHY_CVS_FLAG, I.PHY_RES_FLAG, I.PHY_CNS_FLAG, I.PHY_ABD_FLAG, ");
	sqlStr.append("I.PHY_TARGET_EXAM, I.PAST_HEALTH_FLAG, I.PAST_HEALTH, I.PSY_FLAG, I.PSY, "); 
	sqlStr.append("I.IMP, I.PLAN, SUBSTR(I.DOCCODE,3), I.UPDATE_USER, I.UPDATE_DATE, IP.BEDCODE ");
	sqlStr.append("FROM IPD_DOCASSESS@CIS I, PATIENT@IWEB P, REG@IWEB R, INPAT@IWEB IP ");
	sqlStr.append("WHERE I.PATNO = P.PATNO ");
	sqlStr.append("AND I.REGID = R.REGID ");  
	sqlStr.append("AND R.INPID = IP.INPID ");
	sqlStr.append("AND I.REGID = ? ");
	System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{regid});		 
}

private ArrayList getIpBedCode(String regid) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT IP.BEDCODE ");
	sqlStr.append("FROM REG@IWEB R, INPAT@IWEB IP ");
	sqlStr.append("WHERE R.INPID = IP.INPID ");
	sqlStr.append("AND R.REGID = ? ");
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{regid});		 
}

private ArrayList getEHRrecord(String patno){
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT row_number() over (partition by ALERT_TYPE order by ALERT_TYPE) AS ROW_NUM,  ALERT_TYPE, SHORT_DISPLAY_NAME, SEVERITY, REACTION, REMARK, UPDATE_USER, SUBSTR(UPDATE_DTM,0,16) AS UPDATE_DATE, ");
	sqlStr.append("TO_CHAR(TO_DATE(SUBSTR(UPDATE_DTM,0,16),'YYYY-MM-DD HH24:MI'),'DD/MM/YYYY') AS UPDATE_DDMMYYYY ");
	sqlStr.append("FROM CMS_STRUCTURE_ALERT ");
	sqlStr.append("WHERE PATIENT_REF_KEY = '"+patno+"' ");
	//sqlStr.append("ORDER BY ALERT_TYPE");
	return UtilDBWeb.getReportableListCIS(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);
String action = request.getParameter("action");

String regid = request.getParameter("regid");
String patno = request.getParameter("patno");

String noteDate = request.getParameter("noteDate");
String ipCC = request.getParameter("ipCC");
String ipPhyExam = request.getParameter("ipPhyExam");
String ipCvs = request.getParameter("ipCvs");
String ipRes = request.getParameter("ipRes");
String ipCns = request.getParameter("ipCns");
String ipAbd = request.getParameter("ipAbd");
String ipTargetExam = request.getParameter("ipTargetExam");
String ipPastHealthFlag = request.getParameter("ipPastHealthFlag");
String ipPastHealth = request.getParameter("ipPastHealth");
String ipPsyFlag = request.getParameter("ipPsyFlag");
String ipPsy = request.getParameter("ipPsy");
String ipImp = request.getParameter("ipImp");
String ipPlan = request.getParameter("ipPlan");
String doccode = request.getParameter("login");
String docname = request.getParameter("docname");
String login = request.getParameter("login");
String bedcode = request.getParameter("bedcode");

String tempChkDigit = null;
String patname = "";
String patcname = "";
String patbdate = "";
String patsex = "";

String temperature = "";
String weight = "";
String bps = "";
String bpd = "";
String bp = "";
String height = "";
String pulse = "";
String hc = "";
String rr = "";
String spo2 = "";
String psy = "";
JSONArray currentmed = new JSONArray();
String lmp = "";
String lmp1 = "";
String lmp2 = "";
String lmp3 = "";
String lmpType = "";
Double maxPain = 0.0;

boolean success = false;

if("saveNote".equals(action)){
	success = saveIpMedicalNote(regid, patno, ipCC, ipPhyExam, 
				ipCvs, ipRes, ipCns, ipAbd, ipTargetExam, 
				ipPastHealthFlag, ipPastHealth, ipPsyFlag, ipPsy, 
				ipImp, ipPlan, doccode, login);
%>
	<%=success%>
<%
}if("updateNote".equals(action)){
	success = updateIpMedicalNote(regid, patno, ipCC, ipPhyExam, 
			ipCvs, ipRes, ipCns, ipAbd, ipTargetExam, 
			ipPastHealthFlag, ipPastHealth, ipPsyFlag, ipPsy, 
			ipImp, ipPlan, doccode, login);
%>
<%=success%>
<%
}else if("print".equals(action)){
	ArrayList record = getIpMedicalNote(regid);
	
	String reportPath = null;
	String filePath = null;
	String reportName = null;
	
	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		
		regid = row.getValue(0);
		patno = row.getValue(1);
		patname = row.getValue(2);
		patcname = row.getValue(3);
		patbdate = row.getValue(4);
		patsex = row.getValue(5);
		
		noteDate = row.getValue(6);
		ipCC = row.getValue(7);
		ipPhyExam = row.getValue(8);
		ipCvs = row.getValue(9);
		ipRes = row.getValue(10);
		ipCns = row.getValue(11);
		ipAbd = row.getValue(12);
		ipTargetExam = row.getValue(13);
		ipPastHealthFlag = row.getValue(14);
		ipPastHealth = row.getValue(15);
		ipPsyFlag = row.getValue(16);
		ipPsy = row.getValue(17);
		ipImp = row.getValue(18);
		ipPlan = row.getValue(19);
		doccode = row.getValue(20);
		docname = DoctorDB.getDoctorFullName(doccode);
		if(docname == null){
			docname = "";
		}else{
			docname = "Dr. " + docname;
		}
		bedcode = row.getValue(23);
		
		String patCheckDigit = "";
		boolean isChkDigit = "YES".equals(getSystemParameter("ChkDigit"));
		if (isChkDigit) {
			patCheckDigit = !"".equals(patno)?PatientInfo.generateCheckDigit(patno):"";
		}
		String newbarcode = patno + patCheckDigit;
		
		String admissionData = PatientDB.getNisData("ADMISSION",regid);
		if(admissionData.length()>0){
			JSONObject content = new JSONObject(admissionData);
			temperature = "null".equals(content.get("temperature").toString())?"":content.get("temperature").toString();
			weight = "null".equals(content.get("weight").toString())?"":content.get("weight").toString();
			bps = "null".equals(content.get("bps").toString())?"":content.get("bps").toString();
			bpd = "null".equals(content.get("bpd").toString())?"":content.get("bpd").toString();
			bp = bps + (bpd.length()>0?" / "+bpd:"");
			height = "null".equals(content.get("height").toString())?"":content.get("height").toString();
			pulse = "null".equals(content.get("pulse").toString())?"":content.get("pulse").toString();
			if(!content.isNull("hc"))
				hc = "null".equals(content.get("hc").toString())?"":content.get("hc").toString();
			rr = "null".equals(content.get("rr").toString())?"":content.get("rr").toString();
			spo2 = "null".equals(content.get("spo2").toString())?"":content.get("spo2").toString();
			psy = content.getJSONArray("psychosicalassmnt").join(",").replaceAll("\"","");
			currentmed = content.getJSONArray("currentmed");
			JSONObject lmpContent = content.getJSONObject("lmp");
			lmp1 = "null".equals(lmpContent.get("lmp1").toString())?"":lmpContent.get("lmp1").toString().replace(".0","");
			if(!lmpContent.isNull("lmp2"))
				lmp2 = "null".equals(lmpContent.get("lmp2").toString())?"":lmpContent.get("lmp2").toString().replace(".0","");
			if(!lmpContent.isNull("lmp3"))
				lmp3 = "null".equals(lmpContent.get("lmp3").toString())?"":lmpContent.get("lmp3").toString().replace(".0","");
			lmp = lmp1 + (lmp2.length()>0?"/"+lmp2:"") + (lmp3.length()>0?"/"+lmp3:"");
			lmp = "0/0/0".equals(lmp)|| "0/0".equals(lmp)|| "0".equals(lmp)?"":lmp;
			lmpType = lmpContent.getJSONArray("lType").join(",").replaceAll("\"","");
		}
		String fallRisk = PatientDB.getNisData("FallRisk",regid);
		fallRisk = "NA".equals(fallRisk)?"":fallRisk;
		String allPainData = PatientDB.getNisData("Pain",regid); //get max. score
		if(allPainData.length()>0){
			JSONArray painData= new JSONArray(allPainData);
			for(int i=0; i<painData.length(); i++){ 
				JSONObject tmppain = painData.getJSONObject(i); 
				Double painScore = tmppain.getDouble("score");
				if(painScore>maxPain){
					maxPain = painScore;
				}
			}
		}else{
			maxPain = -99.0;
		}
		String tmpSql = "";

		for(int i=0; i<currentmed.length(); i++){ 
			JSONObject tmpMed = currentmed.getJSONObject(i);
			String tmpMedName = "null".equals(tmpMed.get("name").toString())?"":tmpMed.get("name").toString();
			String tmpMedDose = "null".equals(tmpMed.get("dose").toString())?"":tmpMed.get("dose").toString();
			String tmpMedFreq = "null".equals(tmpMed.get("freq").toString())?"":tmpMed.get("freq").toString();
			String tmpMedRoute = "null".equals(tmpMed.get("route").toString())?"":tmpMed.get("route").toString();
			String tmpMedLastDose = "null".equals(tmpMed.get("lastDose").toString())?"":tmpMed.get("lastDose").toString();
			if(i!=0){
				tmpSql += " UNION ";
			}
			tmpSql += "SELECT '" + tmpMedName + "', '" + tmpMedDose + "', '" + tmpMedFreq + "', '" + tmpMedRoute + "', '" + tmpMedLastDose + "' FROM DUAL ";
			
 		}
				
		File reportFile = new File(application.getRealPath("/report/HISPHYEXM.jasper"));
		File reportDir = new File(application.getRealPath("/report/"));
		Map parameters = new HashMap();
		parameters.put("BaseDir", reportFile.getParentFile());
		parameters.put("Site", ConstantsServerSide.SITE_CODE);
		parameters.put("SUBREPORT_DIR", reportDir.getPath() + "\\");
		
		parameters.put("REGID", regid);
		
		parameters.put("NOTE_DATE", noteDate);
		parameters.put("CURR_CMPLT", ipCC);
		parameters.put("PHY_EXAM", ipPhyExam);
		parameters.put("PHY_CVS_FLAG", ipCvs);
		parameters.put("PHY_RES_FLAG", ipRes);
		parameters.put("PHY_CNS_FLAG", ipCns);
		parameters.put("PHY_ABD_FLAG", ipAbd);
		parameters.put("PHY_TARGET_EXAM", ipTargetExam);
		parameters.put("PAST_HEALTH_FLAG", ipPastHealthFlag);
		parameters.put("PAST_HEALTH", ipPastHealth);
		parameters.put("PSY_FLAG", ipPsyFlag);
		parameters.put("PSY", ipPsy);
		parameters.put("IMP", ipImp);
		parameters.put("PLAN", ipPlan);
		
		parameters.put("DOCCODE", doccode);
		parameters.put("DOCNAME", docname);
		
		parameters.put("PATNO", patno);
		parameters.put("PATNAME", patname);
		parameters.put("PATBDATE", patbdate);
		parameters.put("PATSEX", patsex);
		parameters.put("PATCNAME", patcname);
		parameters.put("BEDCODE", bedcode);
		parameters.put("newbarcode", newbarcode);
		
		parameters.put("username", login);
		
		parameters.put("TEMP", temperature);
		parameters.put("WEIGHT", weight);
		parameters.put("BP", bp);
		parameters.put("HEIGHT", height);
		parameters.put("FALLRISK", fallRisk);
		parameters.put("PULSE", pulse);
		parameters.put("HC", hc);
		parameters.put("PHYASSESS", psy);
		parameters.put("RR", rr);
		parameters.put("LMP", lmp);
		parameters.put("LTYPE", lmpType);
		parameters.put("SPO2", spo2);
		parameters.put("PAIN", maxPain == -99.0?"":maxPain+"/10");
		
		parameters.put("SubDataSource1", new ReportListDataSource(getEHRrecord(patno)));
		parameters.put("SubDataSource2", new ReportListDataSource(UtilDBWeb.getReportableList(tmpSql)));
	
		//open in browser
	
		if (reportFile.exists()) {
			JasperReport jasperReport = (JasperReport) JRLoader.loadObject(reportFile.getPath());

			JasperPrint jasperPrint = JasperFillManager.fillReport(
							jasperReport,
							parameters,
							new ReportListDataSource(
									UtilDBWeb.getReportableList("Select 1 From Dual Connect By Level <= 1")));
	
			request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE,jasperPrint);
			OutputStream ouputStream = response.getOutputStream();
			response.setContentType("application/pdf");
			JRPdfExporter exporter = new JRPdfExporter();
			exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
			exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
			exporter.exportReport();
			return;
		}
		

		// auto print using NHSClientApp.exe	
/*
		JasperPrint jasperPrint = null;
		try {
			reportPath = "/report/HISPHYEXM.jasper";
			// file.jasper path
			filePath = getServletConfig().getServletContext().getRealPath(reportPath);
			InputStream inputStream = new FileInputStream(filePath);
			jasperPrint = JasperFillManager.fillReport(inputStream, parameters, new ReportListDataSource(
					UtilDBWeb.getReportableList("Select 1 From Dual Connect By Level <= 1")));
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
		*/
		%><%=reportName %><%
		
	}
}else if("printOnly".equals(action)){
	String reportPath = null;
	String filePath = null;
	String reportName = null;
	
	if (regid != null) {
		ArrayList record = PatientDB.getPatInfo(patno);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			patno = row.getValue(0);
			String patfname = row.getValue(11);
			String patgname = row.getValue(12);
			if(patgname.length()>0){
				patname = patfname + ", " +patgname;
			}else{
				patname= patfname;
			}
			patcname = row.getValue(4);
			patsex = row.getValue(1);
			patbdate = row.getValue(10);
			//patid = row.getValue(2);
			//patreligion = row.getValue(9);
		}
				
		
		/*noteDate = "";
		ipCC = row.getValue(7);
		ipPhyExam = row.getValue(8);
		ipCvs = row.getValue(9);
		ipRes = row.getValue(10);
		ipCns = row.getValue(11);
		ipAbd = row.getValue(12);
		ipTargetExam = row.getValue(13);
		ipPastHealthFlag = row.getValue(14);
		ipPastHealth = row.getValue(15);
		ipPsyFlag = row.getValue(16);
		ipPsy = row.getValue(17);
		ipImp = row.getValue(18);
		ipPlan = row.getValue(19);*/
		record = getIpBedCode(regid);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			bedcode = row.getValue(0);
		}
		docname = DoctorDB.getDoctorFullName(doccode);
		if(docname == null){
			docname = "";
		}else{
			docname = "Dr. " + docname;
		}
		
		
		String patCheckDigit = "";
		boolean isChkDigit = "YES".equals(getSystemParameter("ChkDigit"));
		if (isChkDigit) {
			patCheckDigit = !"".equals(patno)?PatientInfo.generateCheckDigit(patno):"";
		}
		String newbarcode = patno + patCheckDigit;
		
		String admissionData = PatientDB.getNisData("ADMISSION",regid);
		if(admissionData.length()>0){
			JSONObject content = new JSONObject(admissionData);
			temperature = "null".equals(content.get("temperature").toString())?"":content.get("temperature").toString();
			weight = "null".equals(content.get("weight").toString())?"":content.get("weight").toString();
			bps = "null".equals(content.get("bps").toString())?"":content.get("bps").toString();
			bpd = "null".equals(content.get("bpd").toString())?"":content.get("bpd").toString();
			bp = bps + (bpd.length()>0?" / "+bpd:"");
			height = "null".equals(content.get("height").toString())?"":content.get("height").toString();
			pulse = "null".equals(content.get("pulse").toString())?"":content.get("pulse").toString();
			if(!content.isNull("hc"))
				hc = "null".equals(content.get("hc").toString())?"":content.get("hc").toString();
			rr = "null".equals(content.get("rr").toString())?"":content.get("rr").toString();
			spo2 = "null".equals(content.get("spo2").toString())?"":content.get("spo2").toString();
			psy = content.getJSONArray("psychosicalassmnt").join(",").replaceAll("\"","");
			currentmed = content.getJSONArray("currentmed");
			JSONObject lmpContent = content.getJSONObject("lmp");
			lmp1 = "null".equals(lmpContent.get("lmp1").toString())?"":lmpContent.get("lmp1").toString().replace(".0","");
			if(!lmpContent.isNull("lmp2"))
				lmp2 = "null".equals(lmpContent.get("lmp2").toString())?"":lmpContent.get("lmp2").toString().replace(".0","");
			if(!lmpContent.isNull("lmp3"))
				lmp3 = "null".equals(lmpContent.get("lmp3").toString())?"":lmpContent.get("lmp3").toString().replace(".0","");
			lmp = lmp1 + (lmp2.length()>0?"/"+lmp2:"") + (lmp3.length()>0?"/"+lmp3:"");
			lmp = "0/0/0".equals(lmp)|| "0/0".equals(lmp)|| "0".equals(lmp)?"":lmp;
			lmpType = lmpContent.getJSONArray("lType").join(",").replaceAll("\"","");
		}
		String fallRisk = PatientDB.getNisData("FallRisk",regid);
		fallRisk = "NA".equals(fallRisk)?"":fallRisk;
		String allPainData = PatientDB.getNisData("Pain",regid); //get max. score
		if(allPainData.length()>0){
			JSONArray painData= new JSONArray(allPainData);
			for(int i=0; i<painData.length(); i++){ 
				JSONObject tmppain = painData.getJSONObject(i); 
				Double painScore = tmppain.getDouble("score");
				if(painScore>maxPain){
					maxPain = painScore;
				}
			}
		}else{
			maxPain = -99.0;
		}
		String tmpSql = "";

		for(int i=0; i<currentmed.length(); i++){ 
			JSONObject tmpMed = currentmed.getJSONObject(i);
			String tmpMedName = "null".equals(tmpMed.get("name").toString())?"":tmpMed.get("name").toString();
			String tmpMedDose = "null".equals(tmpMed.get("dose").toString())?"":tmpMed.get("dose").toString();
			String tmpMedFreq = "null".equals(tmpMed.get("freq").toString())?"":tmpMed.get("freq").toString();
			String tmpMedRoute = "null".equals(tmpMed.get("route").toString())?"":tmpMed.get("route").toString();
			String tmpMedLastDose = "null".equals(tmpMed.get("lastDose").toString())?"":tmpMed.get("lastDose").toString();
			if(i!=0){
				tmpSql += " UNION ";
			}
			tmpSql += "SELECT '" + tmpMedName + "', '" + tmpMedDose + "', '" + tmpMedFreq + "', '" + tmpMedRoute + "', '" + tmpMedLastDose + "' FROM DUAL ";
			
 		}
				
		File reportFile = new File(application.getRealPath("/report/HISPHYEXM.jasper"));
		File reportDir = new File(application.getRealPath("/report/"));
		Map parameters = new HashMap();
		parameters.put("BaseDir", reportFile.getParentFile());
		parameters.put("Site", ConstantsServerSide.SITE_CODE);
		parameters.put("SUBREPORT_DIR", reportDir.getPath() + "\\");
		
		parameters.put("REGID", regid);
		
		parameters.put("NOTE_DATE", noteDate);
		parameters.put("CURR_CMPLT", ipCC);
		parameters.put("PHY_EXAM", ipPhyExam);
		parameters.put("PHY_CVS_FLAG", ipCvs);
		parameters.put("PHY_RES_FLAG", ipRes);
		parameters.put("PHY_CNS_FLAG", ipCns);
		parameters.put("PHY_ABD_FLAG", ipAbd);
		parameters.put("PHY_TARGET_EXAM", ipTargetExam);
		parameters.put("PAST_HEALTH_FLAG", ipPastHealthFlag);
		parameters.put("PAST_HEALTH", ipPastHealth);
		parameters.put("PSY_FLAG", ipPsyFlag);
		parameters.put("PSY", ipPsy);
		parameters.put("IMP", ipImp);
		parameters.put("PLAN", ipPlan);
		
		parameters.put("DOCCODE", doccode);
		parameters.put("DOCNAME", docname);
		
		parameters.put("PATNO", patno);
		parameters.put("PATNAME", patname);
		parameters.put("PATBDATE", patbdate);
		parameters.put("PATSEX", patsex);
		parameters.put("PATCNAME", patcname);
		parameters.put("BEDCODE", bedcode);
		parameters.put("newbarcode", newbarcode);
		
		parameters.put("username", login);
		
		parameters.put("TEMP", temperature);
		parameters.put("WEIGHT", weight);
		parameters.put("BP", bp);
		parameters.put("HEIGHT", height);
		parameters.put("FALLRISK", fallRisk);
		parameters.put("PULSE", pulse);
		parameters.put("HC", hc);
		parameters.put("PHYASSESS", psy);
		parameters.put("RR", rr);
		parameters.put("LMP", lmp);
		parameters.put("LTYPE", lmpType);
		parameters.put("SPO2", spo2);
		parameters.put("PAIN", maxPain == -99.0?"":maxPain+"/10");
		
		parameters.put("SubDataSource1", new ReportListDataSource(getEHRrecord(patno)));
		parameters.put("SubDataSource2", new ReportListDataSource(UtilDBWeb.getReportableList(tmpSql)));
	
		//open in browser
	
		if (reportFile.exists()) {
			JasperReport jasperReport = (JasperReport) JRLoader.loadObject(reportFile.getPath());

			JasperPrint jasperPrint = JasperFillManager.fillReport(
							jasperReport,
							parameters,
							new ReportListDataSource(
									UtilDBWeb.getReportableList("Select 1 From Dual Connect By Level <= 1")));
	
			request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE,jasperPrint);
			OutputStream ouputStream = response.getOutputStream();
			response.setContentType("application/pdf");
			JRPdfExporter exporter = new JRPdfExporter();
			exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
			exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
			exporter.exportReport();
			return;
		}
		

		// auto print using NHSClientApp.exe	
/*
		JasperPrint jasperPrint = null;
		try {
			reportPath = "/report/HISPHYEXM.jasper";
			// file.jasper path
			filePath = getServletConfig().getServletContext().getRealPath(reportPath);
			InputStream inputStream = new FileInputStream(filePath);
			jasperPrint = JasperFillManager.fillReport(inputStream, parameters, new ReportListDataSource(
					UtilDBWeb.getReportableList("Select 1 From Dual Connect By Level <= 1")));
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
		*/
		%><%=reportName %><%
		
	}
} 
%>
