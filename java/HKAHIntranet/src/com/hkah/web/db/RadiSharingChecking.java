package com.hkah.web.db;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import sun.misc.BASE64Decoder;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.lowagie.text.pdf.PdfReader;
import com.lowagie.text.pdf.parser.PdfTextExtractor;

public class RadiSharingChecking {
	static String xmlRootDir = "\\\\192.168.10.223\\ha\\";//\\\\168.168.0.5\\ha\\";//ConstantsServerSide.DOCUMENT_FOLDER+"\\hapdf\\xml\\";
	static String pdfRootDir = ConstantsServerSide.DOCUMENT_FOLDER+"\\hapdf\\hkah\\";
	static ArrayList<File> checkFiles = null;
	static String siteMode = "HKAH";
	
	public static boolean checkRisReportMsg(boolean isSchedule) {
		List<RadiCaseObject> errorCases = new ArrayList<RadiCaseObject>();
		boolean ret = true;
		// 1. check meta_billing ris_auto_match_log match
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("Select Msg_Seq_No, Ris_Accession_No, patient_id ");
		sqlStr.append("From ris_Meta_Billing@iweb ");
		sqlStr.append("where Ris_Accession_No in (");
		sqlStr.append("Select ris_accession_no From ris_Meta_Billing@iweb ");
		if (isSchedule) {
			sqlStr.append("where TO_DATE(MSG_CREATE_DTTM, 'YYYYMMDDHH24MISS') >= TO_DATE(TO_CHAR(SYSDATE-1, 'DD/MM/YYYY')||' 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		}
		sqlStr.append("minus ");
		sqlStr.append("Select Accessno From Ris_Auto_Match_Log@iweb ");
		sqlStr.append(")");
		
		String errMsg = "Meta billing without auto match log.";
		ArrayList checkList = UtilDBWeb.getReportableList(sqlStr.toString());
		for (int i = 0; i < checkList.size(); i++) {
			ReportableListObject rlo = (ReportableListObject) checkList.get(i);
			errorCases.add(new RadiCaseObject(rlo.getValue(1), rlo.getValue(2), 
					rlo.getValue(0), null, errMsg));
		}
		
		// changed at 2014-6-23 exam2pay will be inserted at month-end
		/*
		// 2. check missing exam2pay in ris_report_message
		sqlStr.setLength(0);
		sqlStr.append("Select r.Msg_Seq_No, r.Ris_Accession_No, r.patient_id ");
		sqlStr.append("From Ris_Report_Message@iweb R Left Join Exam2pay@iweb E ");
		sqlStr.append("	on R.Stnid = E.Stnid ");
		sqlStr.append("Where E.Exrid Is Null and his_rtn_msg like '%Report=%' ");
		if (isSchedule) {
			sqlStr.append("and TO_DATE(r.MSG_CREATE_DTTM, 'YYYYMMDDHH24MISS') >= TO_DATE(TO_CHAR(SYSDATE-1, 'DD/MM/YYYY')||' 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		}
		
		errMsg = "Missing exam2pay (report message exists)";
		checkList = UtilDBWeb.getReportableList(sqlStr.toString());
		for (int i = 0; i < checkList.size(); i++) {
			ReportableListObject rlo = (ReportableListObject) checkList.get(i);
			errorCases.add(new RadiCaseObject(rlo.getValue(1), rlo.getValue(2), 
					rlo.getValue(0), null, errMsg));
		}
		*/
		
		// 3. check report status 340 without 240
		sqlStr.setLength(0);
		sqlStr.append("Select r.Msg_Seq_No, r.Ris_Accession_No, r.patient_id ");
		sqlStr.append("From Ris_Report_Message@iweb r ");
		sqlStr.append("where r.Ris_Accession_No in ( ");
		sqlStr.append("Select ris_accession_no From Ris_Report_Message@iweb ");
		sqlStr.append("where Ris_Report_Status = 340 ");
		if (isSchedule) {
			sqlStr.append("and TO_DATE(MSG_CREATE_DTTM, 'YYYYMMDDHH24MISS') >= TO_DATE(TO_CHAR(SYSDATE-1, 'DD/MM/YYYY')||' 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		}
		sqlStr.append("minus ");
		sqlStr.append("Select ris_accession_no From Ris_Report_Message@iweb ");
		sqlStr.append("where Ris_Report_Status = 240 ");
		sqlStr.append(")");
		
		errMsg = "Missing status 240 before 340";
		checkList = UtilDBWeb.getReportableList(sqlStr.toString());
		for (int i = 0; i < checkList.size(); i++) {
			ReportableListObject rlo = (ReportableListObject) checkList.get(i);
			errorCases.add(new RadiCaseObject(rlo.getValue(1), rlo.getValue(2), 
					rlo.getValue(0), null, errMsg));
		}
		
		String content = "";
		if (errorCases.size() > 0) {
			String msn = "";
			for (int i = 0; i < errorCases.size(); i++) {
				content += "--------------------------------------------------------------<br/>";
				content += "Accession No: "+errorCases.get(i).getAid()+"<br/>";
				content += "MSG_SEQ_NO: "+errorCases.get(i).getSid()+"<br/>";
				content += "Patient No: "+errorCases.get(i).getPatno()+"<br/>";
				content += "Error Msg: "+errorCases.get(i).getErrMsg()+"<br/><br/>";
				
				msn += errorCases.get(i).getSid()+", ";
				
				CHReportLogDB.addErrorLog("RIS", errorCases.get(i).getPatno(), 
						null, errorCases.get(i).getSid(), 
						"Accession No: "+errorCases.get(i).getAid()+" "+
						"MSG_SEQ_NO: "+errorCases.get(i).getSid()+" "+
						"Error Msg: "+errorCases.get(i).getErrMsg()
						);
			}
			EmailAlertDB.sendEmail( "ris.report.alert", 
					"RIS Report Message problem (MSG_SEQ_NO: "+msn.substring(0, msn.length()-2)+")", 
					content);
			ret = false;
		}
		return ret;
	}
	
	public static boolean checkRptMsg(String patNo, String rptPath) {
		ArrayList<RadiCaseObject> errorCases = new ArrayList<RadiCaseObject>();
		if (checkRptPdf(new File(rptPath), null, null, patNo, errorCases)) {
			return true; 	
		}
		else {
			String content = "";
			content += "--------------------------------------------------------------<br/>";
			content += "Patient No: "+errorCases.get(0).getPatno()+"<br/>";
			content += "Report Path: "+errorCases.get(0).getRptPath()+"<br/><br/>";
			content += "Error Msg: "+errorCases.get(0).getErrMsg()+"<br/><br/>";
			
			EmailAlertDB.sendEmail( "radisharing.alert", 
					"RIS Report Not Match (PatNo: "+errorCases.get(0).getPatno()+")", 
					content);
			CHReportLogDB.addErrorLog("RIS", errorCases.get(0).getPatno(), 
								errorCases.get(0).getRptPath(), null, 
								"Error Msg: "+errorCases.get(0).getErrMsg());
			return false;
		}
	}
	
	public static boolean checkRptMsg(String msgSeqNo, String aid, 
								boolean isSchedule) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT MSG_SEQ_NO, RIS_ACCESSION_NO, PATIENT_ID, TRIM(REPORT_PATH) ");
		sqlStr.append("FROM RIS_REPORT_MESSAGE@IWEB ");
		sqlStr.append("WHERE MSG_SEQ_NO IS NOT NULL ");
		if (msgSeqNo != null) {
			sqlStr.append("AND MSG_SEQ_NO = '"+msgSeqNo+"' ");
		}
		if (aid != null) {
			sqlStr.append("AND RIS_ACCESSION_NO = '"+aid+"' ");
		}
		if (isSchedule) {
			sqlStr.append("AND TO_DATE(MSG_CREATE_DTTM, 'YYYYMMDDHH24MISS') >= TO_DATE(TO_CHAR(SYSDATE-1, 'DD/MM/YYYY')||' 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		}
		sqlStr.append("ORDER BY MSG_SEQ_NO ");
		
		ArrayList checkList = UtilDBWeb.getReportableList(sqlStr.toString());
		ArrayList<RadiCaseObject> errorCases = new ArrayList<RadiCaseObject>();
		
		System.out.println("[RadiSharingChecking] Sql: "+sqlStr.toString());
		
		int success = 0;
		if (checkList.size() > 0) {
			//System.out.println("Total: "+checkList.size());
			for (int i = 0; i < checkList.size(); i++) {
				ReportableListObject rlo = (ReportableListObject) checkList.get(i);
				if (checkRptPdf(new File(rlo.getValue(3)), rlo.getValue(1), rlo.getValue(0), 
									rlo.getValue(2), errorCases)) {
					success++;
					//System.out.println(rlo.getValue(1));
				}
			}
			//System.out.println("-----------------------------------------------------------------");
			//System.out.println("Success: "+success);
			//System.out.println("Fail: "+(checkList.size()-success));
		}
		else {
			errorCases.add(new RadiCaseObject(aid, null, msgSeqNo, null, "No record Found"));
		}
		
		String content = "Total: "+checkList.size()+"<br/>Success: "+success+"<br/>Fail: "+errorCases.size()+"<br/><br/>";
		
		if (isSchedule) {
			content += "<b>Check records from yesterday to "+new Date()+" in db<b><br/>";
		}
		if (msgSeqNo != null) {
			content += "<b>Check by MSG_SEQ_NO("+msgSeqNo+") in db<b><br/>";
		}
		if (aid != null) {
			content += "<b>Check by ACCESSION NO("+aid+") in db<b><br/>";
		}
		
		if (errorCases.size() > 0) {
			String msn = "";
			for (int i = 0; i < errorCases.size(); i++) {
				content += "--------------------------------------------------------------<br/>";
				content += "Accession No: "+errorCases.get(i).getAid()+"<br/>";
				content += "MSG_SEQ_NO: "+errorCases.get(i).getSid()+"<br/>";
				content += "Patient No: "+errorCases.get(i).getPatno()+"<br/>";
				content += "Report Path: "+errorCases.get(i).getRptPath()+"<br/><br/>";
				content += "Error Msg: "+errorCases.get(i).getErrMsg()+"<br/><br/>";
				
				msn += errorCases.get(i).getSid()+", ";
				
				CHReportLogDB.addErrorLog("RIS", errorCases.get(i).getPatno(), 
						errorCases.get(i).getRptPath(), errorCases.get(i).getSid(), 
						"Accession No: "+errorCases.get(i).getAid()+" "+
						"MSG_SEQ_NO: "+errorCases.get(i).getSid()+" "+
						"Error Msg: "+errorCases.get(i).getErrMsg()
						);
			}
			
			EmailAlertDB.sendEmail( "radisharing.alert", 
					"RIS Report Not Match (MSG_SEQ_NO: "+msn.substring(0, msn.length()-2)+")", 
					content);
		}
		
		//EmailAlertDB.sendEmail( "radisharing.check", "RIS Report Checking", content);
		
		return errorCases.size() == 0;
	}
	
	private static boolean checkRptPdf(File file, String aid, String uid, String patNo,
										ArrayList<RadiCaseObject> errorCases) {
		boolean success = true;
		PdfReader reader = null;
		try {
			reader = new PdfReader(file.getAbsolutePath());
	        int n = reader.getNumberOfPages(); 
	        PdfTextExtractor extractor = new PdfTextExtractor(reader);
	        
	        for (int i = 1; i <= n; i++) {
	        	String content = extractor.getTextFromPage(i).replace("\n", "").replace("\r", "");
	        	
	        	boolean isExamNameSplit = true;
        		String[] headfoot = new String[2];
        		try {
            		headfoot[0] = content.substring(0, content.indexOf("Exam Name:"));
            		headfoot[1] = content.substring(content.indexOf("Exam Name:")+"Exam Name:".length());
        		}
        		catch (Exception e) {
        			isExamNameSplit = false;
        		}
        		
        		if (!isExamNameSplit) {
            		try {
	            		headfoot[0] = content.substring(0, content.indexOf("Report Title:"));
	            		headfoot[1] = content.substring(content.indexOf("Report Title:")+"Report Title:".length());
            		}
            		catch (Exception e) {
            			
            		}
        		}
        		
        		if (headfoot != null) {
        			String patHeadNo = null;
        			boolean accessionIDMatch = true;
        			
        			if (headfoot[0] != null) {
        				patHeadNo = getPdfData(headfoot[0], "Patient No.:", "Page").trim();
        				if (!isExamNameSplit && aid != null) {
            				accessionIDMatch = headfoot[0].indexOf(aid) > -1;
            			}
        			}
        			if (headfoot[1] != null) {
            			//check accession id
            			if (isExamNameSplit && aid != null) {
            				accessionIDMatch = headfoot[1].indexOf(aid) > -1;
            			}
        			}
        			
        			if (patHeadNo.equals(patNo) && accessionIDMatch) {
        				//System.out.println("All Match!!!");
        			}
        			else {
//        				System.out.println("--------------------------"+aid+"--------------------------");
//        				System.out.println("MSG_SEQ_NO: "+uid);
//            			System.out.println("Patient No.: "+patNo);
//            			System.out.println("Accession No.: "+aid);
//            			System.out.println("Patient No. in Report: "+patHeadNo);
//            			System.out.println("Patient No.: "+patHeadNo.equals(patNo));
//            			System.out.println("Accession No.: "+accessionIDMatch);
            			String error = "";
        				if (!patHeadNo.equals(patNo)) {
//            				System.out.println("Patient No is not match");
        					error += "Patient No is not match<br/>";
            			}
            			if (!accessionIDMatch) {
//            				System.out.println("Accession No is not match");
            				error += "Accession No is not match<br/>";
            			}
//        				System.out.println("Case is not match!!!!!!!!!");
        				success = false;
        				errorCases.add(new RadiCaseObject(aid, patNo, uid, file.getAbsolutePath(), error));
        			}
        		}
        		else {
//        			System.out.println("--------------------------"+aid+"--------------------------");
//        			System.out.println("No Content...........");
        			success = false;
        			errorCases.add(new RadiCaseObject(aid, patNo, uid, file.getAbsolutePath(), "No content/Cannot get any content"));
        		}
	        }
		}
		catch (Exception e) {
//			System.out.println("--------------------------"+aid+"--------------------------");
//			System.out.println("MSG_SEQ_NO: "+uid);
//			System.err.println("*************************Fail check pdf file*************************");
			success = false;
			e.printStackTrace();
			errorCases.add(new RadiCaseObject(aid, patNo, uid, file.getAbsolutePath(), e.getMessage()));
		}
		finally {
			if (reader != null) {
				reader.close();
			}
		}
		return success;
	}
	
	public static void checkXmlFiles() {
		getXmlFiles();
		
		for (int i = 0; i < checkFiles.size(); i++) {
			File f = checkFiles.get(i);
			System.out.println("================="+f.getName()+"=================");
			String xmlContent = readXml(f);
			String accessionID = getXmlData(xmlContent, "MSH.10");
			String processID = getXmlData(getXmlData(xmlContent, "MSH.11"), "PT.1");
			String patID = getXmlData(getXmlData(xmlContent, "PID.3"), "CX.1");
			String patIdType = getXmlData(getXmlData(xmlContent, "PID.3"), "CX.5");
			String patFName = getXmlData(getXmlData(xmlContent, "PID.5"), "FN.1");
			String patGName = getXmlData(getXmlData(xmlContent, "PID.5"), "XPN.2");
			String dob = getXmlData(getXmlData(xmlContent, "PID.7"), "TS.1");;
			String sex = getXmlData(xmlContent, "PID.8");
			String patType = getXmlData(xmlContent, "PV1.2");
			String caseStatus = getXmlData(xmlContent, "CWE.1");
			String rptData = getXmlData(getXmlData(xmlContent, "OBX.5"), "ED.5");
			String rptTitle = getXmlData(getXmlData(xmlContent, "OBX.3"), "CE.2");
			
			System.out.println("["+f.getName()+"]Accession ID: "+accessionID);
			System.out.println("["+f.getName()+"]Process ID: "+processID);
			System.out.println("["+f.getName()+"]Patient ID: "+patID);
			System.out.println("["+f.getName()+"]Patient ID Type: "+patIdType);
			System.out.println("["+f.getName()+"]Patient Family Name: "+patFName);
			System.out.println("["+f.getName()+"]Patient Given Name: "+patGName);
			System.out.println("["+f.getName()+"]Patient Date of Birth: "+dob);
			System.out.println("["+f.getName()+"]Patient Sex: "+sex);
			System.out.println("["+f.getName()+"]Patient Type: "+patType);
			System.out.println("["+f.getName()+"]Case Statis: "+caseStatus);
			System.out.println("["+f.getName()+"]Report Title: "+rptTitle);
			
			Map dataMap = new HashMap<String, String>();
			dataMap.put("accessionID", accessionID);
			dataMap.put("processID", processID);
			dataMap.put("patID", patID);
			dataMap.put("patIdType", patIdType);
			dataMap.put("patFName", patFName);
			dataMap.put("patGName", patGName);
			dataMap.put("dob", dob);
			dataMap.put("sex", sex);
			dataMap.put("patType", patType);
			dataMap.put("caseStatus", caseStatus);
			dataMap.put("rptTitle", rptTitle.replace("&amp;", "&"));

			StringBuffer sql = new StringBuffer();
			sql.append("INSERT INTO RIS_XML_LOG (SITE_CODE, AID, PID, XML_PATID, ");
			sql.append("XML_PATIDTYPE, XML_PATFANE, XML_PATGNAME, XML_PATDOB, ");
			sql.append("XML_PATSEX, XML_RPTTITLE, XML_PATTYPE) ");
			sql.append("VALUES ('"+siteMode+"', '"+accessionID+"', '"+processID+"', ");
			sql.append("'"+patID+"', '"+patIdType+"', '"+patFName+"', ");
			sql.append("'"+patGName+"', '"+dob+"', '"+sex+"', '"+rptTitle+"', '"+patType+"')");
			
			boolean success = UtilDBWeb.updateQueue(sql.toString());
			
			//check pdf
			generatePdfFile(accessionID+".pdf", rptData, dataMap);
			
			System.out.println("=================================================");
		}
	}
	
	private static String getPdfData(String content, String start, String end) {
		return content.substring(
				content.indexOf(start)+start.length(), 
				content.indexOf(end));
	}
	
	private static void checkPdfFile(File file, Map dataMap) {
		try {     
			PdfReader reader = new PdfReader(file.getAbsolutePath());
            int n = reader.getNumberOfPages(); 
            PdfTextExtractor extractor = new PdfTextExtractor(reader);
            
            String accessionID = (String)dataMap.get("accessionID");
            
            for (int i = 1; i <= n; i++) {
            	System.out.println("================="+accessionID+"=================");
            	String content = extractor.getTextFromPage(i).replace("\n", "").replace("\r", "");
            	if (siteMode.equals("HKAH")) {
            		boolean isExamNameSplit = true;
            		String[] headfoot = new String[2];
            		try {
	            		headfoot[0] = content.substring(0, content.indexOf("Exam Name:"));
	            		headfoot[1] = content.substring(content.indexOf("Exam Name:")+"Exam Name:".length());
            		}
            		catch (Exception e) {
            			isExamNameSplit = false;
            		}
            		
            		if (!isExamNameSplit) {
	            		try {
		            		headfoot[0] = content.substring(0, content.indexOf("Report Title:"));
		            		headfoot[1] = content.substring(content.indexOf("Report Title:")+"Report Title:".length());
	            		}
	            		catch (Exception e) {
	            			
	            		}
            		}
	            	
	            	if (headfoot != null) {
	            		String patHeadFName = null;
	            		String patHeadGName = null;
	            		String patHeadNo = null;
	            		boolean accessionIDMatch = false;
	            		boolean reportHeadTileMatch = false;
	            		boolean reportFootTitleMatch = false;
	            		String patFootNo = null;
	            		String patFootFName = null;
	            		String patFootGName = null;
	            		String patFootDob = null;
	            		String patSex = null;
	            		
	            		if (headfoot[0] != null) {
	            			//patient name
	            			String patName = getPdfData(headfoot[0], "Patient Name:", "Patient No.:");
	            			patName = patName.trim();
	            			patHeadFName = patName.split(",")[0].trim();
	            			patHeadGName = patName.split(",").length > 1?patName.split(",")[1].trim():"";
	            			
	            			//pat no
	            			patHeadNo = getPdfData(headfoot[0], "Patient No.:", "Page").trim();
	            			
	            			//check accession id
	            			if (!isExamNameSplit) {
	            				accessionIDMatch = headfoot[0].indexOf(accessionID) > -1;
	            			}
	            		}
	            		if (headfoot[1] != null) {
	            			//check accession id
	            			if (isExamNameSplit) {
	            				accessionIDMatch = headfoot[1].indexOf(accessionID) > -1;
	            			}
	            			
	            			//check report title
	            			if (isExamNameSplit) {
		            			reportHeadTileMatch = headfoot[1].substring(0, headfoot[1].indexOf("Exam Name:"))
															.indexOf((String)dataMap.get("rptTitle")) > -1; 
	            			}
	            			else {
	            				try {
		            				reportHeadTileMatch = headfoot[1].substring(0, headfoot[1].indexOf("Exam Desc.:"))
																.indexOf((String)dataMap.get("rptTitle")) > -1;
	            				}
	            				catch (Exception e) {
									reportHeadTileMatch = headfoot[1].substring(0, headfoot[1].indexOf("Report Date:"))
																.indexOf((String)dataMap.get("rptTitle")) > -1;
								}
	            			}
	            			
	            			String reportFootTitle = getPdfData(headfoot[1], "Exam Desc.:", "Patient No. :").trim();
	            			reportFootTitleMatch = reportFootTitle.trim().indexOf((String)dataMap.get("rptTitle")) > -1;
	                		patFootNo = getPdfData(headfoot[1], "Patient No. :", "Diagnostic Imaging Report").trim();
	                		
	                		String patFootName = null;
	                		if (isExamNameSplit) {
		                		patFootName = getPdfData(
		                								getPdfData(headfoot[1], 
		                										"Diagnostic Imaging Report", "Birth:").trim(),
		                								"Name:", "Date of");
	                		}
	                		else {
	                			patFootName = getPdfData(headfoot[1], "Name:", "Date of").trim();
	                		}
	                		patFootFName = patFootName.trim().split(",")[0].trim();
	                		patFootGName = patFootName.split(",").length > 1?patFootName.split(",")[1].trim():"";
	                		patFootDob = getPdfData(headfoot[1], "Birth:", "Gender:").trim();
	                		patFootDob = patFootDob.substring(6)+patFootDob.substring(3, 5)+patFootDob.substring(0, 2);
	                		patSex = getPdfData(headfoot[1], "Gender:", "Rev:").trim();
	            		}
	            		
	            		System.out.println("["+accessionID+"]patHeadFName: "+patHeadFName);
	        			System.out.println("["+accessionID+"]patHeadGName: "+patHeadGName);
	        			System.out.println("["+accessionID+"]patHeadNo: "+patHeadNo);
	        			System.out.println("["+accessionID+"]accessionIDMatch: "+accessionIDMatch);
	        			System.out.println("["+accessionID+"]reportHeadTileMatch: "+reportHeadTileMatch);
	        			System.out.println("["+accessionID+"]reportFootTitleMatch: "+reportFootTitleMatch);
	        			System.out.println("["+accessionID+"]patFootNo: "+patFootNo);
	        			System.out.println("["+accessionID+"]patFootFName: "+patFootFName);
	        			System.out.println("["+accessionID+"]patFootGName: "+patFootGName);
	        			System.out.println("["+accessionID+"]patFootDob: "+patFootDob);
	        			System.out.println("["+accessionID+"]patSex: "+patSex);
	        			
	        			updatePdfLog((String)dataMap.get("accessionID"), patHeadNo, 
	            				patHeadFName, patHeadGName, patFootNo,
	            				patFootFName, patFootGName, 
	            				patFootDob, 
	            				patSex, accessionIDMatch?"1":"0", "", 
	            				((String)dataMap.get("patFName")).equals(patHeadFName)?"1":"0", 
	            				((String)dataMap.get("patGName")).equals(patHeadGName)?"1":"0", 
	            				reportHeadTileMatch?"1":"0", "", 
	            				((String)dataMap.get("patFName")).equals(patFootFName)?"1":"0", 
	            				((String)dataMap.get("patGName")).equals(patFootGName)?"1":"0", 
	            				((String)dataMap.get("dob")).equals(patFootDob)?"1":"0", 
	            				((String)dataMap.get("sex")).equals(patSex)?"1":"0", 
	            				reportFootTitleMatch?"1":"0", "");
	            		
	            		System.out.println("===================================================");
	            	}
	            	else {
	            		//no content
	            		updatePdfLog((String)dataMap.get("accessionID"), "", "", "",
		   						 "", "", "", "", "", "", "", "", "", "", "", "", "",
		   						 "", "", "", "no content");
	            	}
            	}
            	else {//TWAH
            		boolean isExamNameSplit = true;
            		String[] headfoot = new String[2];
            		try {
	            		headfoot[0] = content.substring(0, content.indexOf("Exam Name:"));
	            		headfoot[1] = content.substring(content.indexOf("Exam Name:")+"Exam Name:".length());
            		}
            		catch (Exception e) {
            			isExamNameSplit = false;
            		}
            		
            		if (!isExamNameSplit) {
	            		try {
		            		headfoot[0] = content.substring(0, content.indexOf("Report Title:"));
		            		headfoot[1] = content.substring(content.indexOf("Report Title:")+"Report Title:".length());
	            		}
	            		catch (Exception e) {
	            			
	            		}
            		}
            		
	            	if (headfoot != null) {
	            		String patHeadFName = null;
	            		String patHeadGName = null;
	            		String patHeadNo = null;
	            		boolean accessionIDMatch = false;
	            		boolean reportHeadTileMatch = false;
	            		boolean reportFootTitleMatch = false;
	            		String patFootNo = null;
	            		String patFootFName = null;
	            		String patFootGName = null;
	            		String patFootDob = null;
	            		String patSex = null;
	            		
	            		if (headfoot[0] != null) {
	            			//patient name
	            			String patName = getPdfData(headfoot[0], "Patient Name:", "Patient No.:");
	            			patName = patName.trim();
	            			patHeadFName = patName.split(",")[0].trim();
	            			patHeadGName = patName.split(",").length > 1?patName.split(",")[1].trim():"";
	            			
	            			//pat no
	            			patHeadNo = getPdfData(headfoot[0], "Patient No.:", "Page").trim();
	            			if (!isExamNameSplit) {
	            				accessionIDMatch = headfoot[0].indexOf(accessionID) > -1;
	            			}
	            		}
	            		if (headfoot[1] != null) {
	            			//check accession id
	            			if (isExamNameSplit) {
	            				accessionIDMatch = headfoot[1].indexOf(accessionID) > -1;
	            			}
	            			
	            			//check report title
	            			if (isExamNameSplit) {
		            			reportHeadTileMatch = headfoot[1].substring(0, headfoot[1].indexOf("Exam Name:"))
															.indexOf((String)dataMap.get("rptTitle")) > -1; 
	            			}
	            			else {
	            				try {
		            				reportHeadTileMatch = headfoot[1].substring(0, headfoot[1].indexOf("Exam Desc.:"))
																.indexOf((String)dataMap.get("rptTitle")) > -1;
	            				}
	            				catch (Exception e) {
									reportHeadTileMatch = headfoot[1].substring(0, headfoot[1].indexOf("Report Date:"))
																.indexOf((String)dataMap.get("rptTitle")) > -1;
								}
	            			}
	            			
	            			String reportFootTitle = getPdfData(headfoot[1], 
	            										isExamNameSplit?"Exam Name:":"Exam Desc.:", 
	            										"Patient No. :").trim();
	            			reportFootTitleMatch = reportFootTitle.trim().indexOf((String)dataMap.get("rptTitle")) > -1;
	                		patFootNo = getPdfData(headfoot[1], "Patient No. :", "Diagnostic Imaging Report").trim();
	                		
	                		String patFootName = null;
	                		if (isExamNameSplit) {
		                		patFootName = getPdfData(
		                								getPdfData(headfoot[1], 
		                										"Diagnostic Imaging Report", "Birth:").trim(),
		                								"Name:", "Date of");
	                		}
	                		else {
	                			patFootName = getPdfData(headfoot[1], "Name:", "Date of").trim();
	                		}
	                		patFootFName = patFootName.trim().split(",")[0].trim();
	                		patFootGName = patFootName.split(",").length > 1?patFootName.split(",")[1].trim():"";
	                		patFootDob = getPdfData(headfoot[1], "Birth:", "Gender:").trim();
	                		patFootDob = patFootDob.substring(6)+patFootDob.substring(3, 5)+patFootDob.substring(0, 2);
	                		patSex = getPdfData(headfoot[1], "Gender:", "Rev:").trim();
	            		}
	            		
	            		System.out.println("["+accessionID+"]patHeadFName: "+patHeadFName);
	        			System.out.println("["+accessionID+"]patHeadGName: "+patHeadGName);
	        			System.out.println("["+accessionID+"]patHeadNo: "+patHeadNo);
	        			System.out.println("["+accessionID+"]accessionIDMatch: "+accessionIDMatch);
	        			System.out.println("["+accessionID+"]reportHeadTileMatch: "+reportHeadTileMatch);
	        			System.out.println("["+accessionID+"]reportFootTitleMatch: "+reportFootTitleMatch);
	        			System.out.println("["+accessionID+"]patFootNo: "+patFootNo);
	        			System.out.println("["+accessionID+"]patFootFName: "+patFootFName);
	        			System.out.println("["+accessionID+"]patFootGName: "+patFootGName);
	        			System.out.println("["+accessionID+"]patFootDob: "+patFootDob);
	        			System.out.println("["+accessionID+"]patSex: "+patSex);
	            		
	            		System.out.println("===================================================");
	            		
	            		updatePdfLog((String)dataMap.get("accessionID"), patHeadNo, 
	            				patHeadFName, patHeadGName, patFootNo,
	            				patFootFName, patFootGName, 
	            				patFootDob, 
	            				patSex, accessionIDMatch?"1":"0", "", 
	            				((String)dataMap.get("patFName")).equals(patHeadFName)?"1":"0", 
	            				((String)dataMap.get("patGName")).equals(patHeadGName)?"1":"0", 
	            				reportHeadTileMatch?"1":"0", "", 
	            				((String)dataMap.get("patFName")).equals(patFootFName)?"1":"0", 
	            				((String)dataMap.get("patGName")).equals(patFootGName)?"1":"0", 
	            				((String)dataMap.get("dob")).equals(patFootDob)?"1":"0", 
	            				((String)dataMap.get("sex")).equals(patSex)?"1":"0", 
	            				reportFootTitleMatch?"1":"0", "");
	            	}
	            	else {
	            		//no content
	            		updatePdfLog((String)dataMap.get("accessionID"), "", "", "",
	   						 "", "", "", "", "", "", "", "", "", "", "", "", "",
	   						 "", "", "", "no content");
	            	}
            	}
            }
		}
		catch (Exception e) {
			System.err.println("*************************Fail check pdf file*************************");
			updatePdfLog((String)dataMap.get("accessionID"), "", "", "",
						 "", "", "", "", "", "", "", "", "", "", "", "", "",
						 "", "", "", e.getMessage());
			e.printStackTrace();
		}
	}
	
	private static void updatePdfLog(String aid, String hPatNo, 
							String hPatFName, String hPatGName,
							String fPatNo, String fPatFName, String fPatGName,
							String fDob, String fPatSex, 
							String aidMatch, String hPatNoMatch, String hPatFNameMatch,
							String hPatGNameMatch, String hRptTitleMatch, 
							String fPatNoMatch, String fPatFNameMatch, String fPatGNameMatch,
							String fPatDobMatch, String fPatSexMatch, String fRptTitleMatch,
							String failMsg) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO RIS_PDF_LOG(");
		sqlStr.append("SITE_CODE, AID, PDF_HEADER_PATNO, PDF_HEADER_PATFNAME, ");
		sqlStr.append("PDF_HEADER_PATGNAME, PDF_FOOTER_PATNO, ");
		sqlStr.append("PDF_FOOTER_PATFNAME, PDF_FOOTER_PATGNAME, PDF_FOOTER_PATDOB, ");
		sqlStr.append("PDF_FOOTER_PATSEX, PDF_AID_MATCH, ");
		sqlStr.append("HEADER_PATNO_MATCH, HEADER_PATFNAME_MATCH, HEADER_PATGNAME_MATCH, ");
		sqlStr.append("HEADER_RPTTITLE_MATCH, FOOTER_PATNO_MATCH, FOOTER_PATFNAME_MATCH, ");
		sqlStr.append("FOOTER_PATGNAME_MATCH, FOOTER_PATDOB_MATCH, FOOTER_PATSEX_MATCH, ");
		sqlStr.append("FOOTER_RPTTITLE_MATCH, PDF_FAIL_MSG)");
		sqlStr.append("VALUES(?, ?, ?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ?, ");
		sqlStr.append("?, ?, ?, ");
		sqlStr.append("?, ?, ?, ");
		sqlStr.append("?, ?) ");
		
		UtilDBWeb.updateQueue(sqlStr.toString(),
				new String[] { 
								siteMode, aid, hPatNo, hPatFName, hPatGName, 
								fPatNo, fPatFName, fPatGName, fDob, fPatSex, 
								aidMatch, hPatNoMatch, hPatFNameMatch,
								hPatGNameMatch, hRptTitleMatch, fPatNoMatch, 
								fPatFNameMatch, fPatGNameMatch,	fPatDobMatch, 
								fPatSexMatch, fRptTitleMatch,failMsg 
							});
	}
	
	private static void generatePdfFile(String fileName, String rptData, Map dataMap) {
		BASE64Decoder decoder = new BASE64Decoder();
		
		try {
			byte[] decodedBytes = decoder.decodeBuffer(rptData);
			
			File file = new File(pdfRootDir+System.currentTimeMillis()+"_"+fileName);;
			FileOutputStream fop = new FileOutputStream(file);
	
			fop.write(decodedBytes);
			fop.flush();
			fop.close();
			
			checkPdfFile(file, dataMap);
		}
		catch (Exception e) {
			System.err.println("*************************Fail generate pdf file*************************");
			e.printStackTrace();
		}
	}
	
	private static String getXmlData(String respone, String key) {
		if(respone.indexOf("</"+key+">") > -1) {
			return respone.substring(respone.indexOf("<"+key+">")+("<"+key+">").length(), 
					respone.indexOf("</"+key+">")).replaceAll("'", "''").trim();
		}
		else {
			return null;
		}
	}
	
	public static String readXml(File xmlFile) {
		String xmlContent = null;
		try {
			BufferedReader br = new BufferedReader(new FileReader(xmlFile));
			try {
		        StringBuilder sb = new StringBuilder();
		        String line = br.readLine();

		        while (line != null) {
		            sb.append(line);
		            line = br.readLine();
		        }
		        xmlContent = sb.toString();
		    } catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} finally {
		        try {
					br.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
		    }
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		finally {
			return xmlContent;
		}
	}
	
	public static void getXmlFiles() {
		File xmlDir = new File(xmlRootDir);
		checkFiles = new ArrayList<File>();
		
		System.out.println("------------------------------Xml File List------------------------------");
		listXmlFiles(xmlDir);
		System.out.println("-------------------------------------------------------------------------");
		System.out.println("Total: "+checkFiles.size());
	}
	
	public static void listXmlFiles(File srcFile) {
		if (srcFile.isFile()) {
			isXmlFile(srcFile);
		}
		else if (srcFile.isDirectory()) {
			for (File f : srcFile.listFiles()) {
				if (!f.getName().equals("DCM")) {
					listXmlFiles(f);
				}
			}
		}
	}
	
	public static void isXmlFile(File srcFile) {
		if (srcFile.getName().endsWith("xml")) {
			checkFiles.add(srcFile);
			System.out.println(srcFile.getAbsolutePath());
		}
	}
}

class RadiCaseObject {
	String aid;
	String patno;
	String sid;
	String rptPath;
	String errMsg;
	
	/**
	 * @return the errMsg
	 */
	public String getErrMsg() {
		return errMsg;
	}

	/**
	 * @param errMsg the errMsg to set
	 */
	public void setErrMsg(String errMsg) {
		this.errMsg = errMsg;
	}

	public RadiCaseObject(String aid, String patno,	String sid,	String rptPath, String errMsg) {
		this.aid = aid;
		this.patno = patno;
		this.sid = sid;
		this.rptPath = rptPath;
		this.errMsg = errMsg;
	}
	
	/**
	 * @return the aid
	 */
	public String getAid() {
		return aid;
	}
	/**
	 * @return the patno
	 */
	public String getPatno() {
		return patno;
	}
	/**
	 * @return the sid
	 */
	public String getSid() {
		return sid;
	}
	/**
	 * @return the rptPath
	 */
	public String getRptPath() {
		return rptPath;
	}
	/**
	 * @param aid the aid to set
	 */
	public void setAid(String aid) {
		this.aid = aid;
	}
	/**
	 * @param patno the patno to set
	 */
	public void setPatno(String patno) {
		this.patno = patno;
	}
	/**
	 * @param sid the sid to set
	 */
	public void setSid(String sid) {
		this.sid = sid;
	}
	/**
	 * @param rptPath the rptPath to set
	 */
	public void setRptPath(String rptPath) {
		this.rptPath = rptPath;
	}
}