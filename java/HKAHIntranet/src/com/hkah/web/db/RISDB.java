package com.hkah.web.db;

import java.io.File;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.encryption.AccessPermission;
import org.apache.pdfbox.pdmodel.encryption.StandardProtectionPolicy;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.PasswordUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;
import com.hkah.web.db.helper.DIReportDetail;
import com.hkah.web.db.helper.DoctorDetail;

public class RISDB {
	private static String sqlStr_getDIReportImagePath = null;
	
	static {	
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.setLength(0);	
		sqlStr.append("select code_value1 from ah_sys_code@cis where sys_id = 'RIS' and code_type = 'DIREPORT' and code_no = 'IMAGE_PATH'");
		sqlStr_getDIReportImagePath = sqlStr.toString();
	}	
	
	public static boolean insertDIReportLog(String rptID, String seqNum, String accessNum, String rptVersion, String docCode,
			   String filePath, String docEmail, String sendMailStatus,
			   String readDocStatus) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("INSERT INTO DI_RPT_LOG@CIS ");
		sqlStr.append("(DI_RPT_ID, DI_SEQ_NUM, DI_ACCESS_NUM, DI_RPT_VERSION, DI_DOCCODE, DI_FILE_PATH, ");
		sqlStr.append("DI_DOC_EMAIL ,DI_SENDMAIL_STATUS,DI_READDOC_STATUS) ");
		sqlStr.append("VALUES ('" + rptID + "', '" + seqNum + "', '" + accessNum + "' ");
		if (rptVersion != null && rptVersion.length() > 0) {
			sqlStr.append(", '" + rptVersion + "' ");
		} else {
			sqlStr.append(", NULL ");
		}		
		if (docCode != null && docCode.length() > 0) {
			sqlStr.append(", '" + docCode + "' ");
		} else {
			sqlStr.append(", NULL ");
		}		
		if (filePath != null && filePath.length() > 0) {
			sqlStr.append(", '" + filePath + "' ");
		} else {
			sqlStr.append(", NULL ");
		}
		if (docEmail != null && docEmail.length() > 0) {
			sqlStr.append(", '" + docEmail + "' ");
		} else {
			sqlStr.append(", NULL ");
		}
		if (sendMailStatus != null && sendMailStatus.length() > 0) {
			sqlStr.append(", '" + sendMailStatus + "' ");
		} else {
			sqlStr.append(", NULL ");
		}
		if (readDocStatus != null && readDocStatus.length() > 0) {
			sqlStr.append(", '" + readDocStatus + "' ");
		} else {
			sqlStr.append(", NULL ");
		}
		sqlStr.append(") ");
		
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
	
	public static boolean updateDiRptLogSendMailStatus(List<Integer> logIDs, String sendMailStatus) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("UPDATE DI_RPT_LOG SET DI_SENDMAIL_STATUS = ? ");
		sqlStr.append("WHERE DI_RPT_ID in (" + StringUtils.join(logIDs, ",")+ ")");

		System.out.println(new Date() + " [RISDB] updateDiRptLogSendMailStatus sendMailStatus="+sendMailStatus+", sql="+sqlStr.toString());
		return UtilDBWeb.updateQueueCIS(sqlStr.toString(), new String[]{sendMailStatus});
	}
	
	public static List<String> verifyDiKeyDoccode(List<Integer> logIDs) {
		StringBuffer sqlStr = new StringBuffer();
		List<String> unmatchLogID = new ArrayList<String>();
		sqlStr.append("SELECT dil.di_rpt_id ");
		sqlStr.append("from ris_rpt_send_email@hat dir ");
		sqlStr.append("join di_rpt_log dil on dir.msg_seq_no = dil.di_seq_num ");
		sqlStr.append("and dir.ris_accession_no = dil.di_access_num ");
		sqlStr.append("and dir.rpt_version = dil.di_rpt_version ");
		sqlStr.append("where dil.di_rpt_id in (" + StringUtils.join(logIDs, ",")+ ") and ");
		sqlStr.append("  ( ");
		sqlStr.append("		  dir.doctor_code is null or (dir.doctor_code is not null and dir.doctor_code <> dil.di_doccode) ");
		sqlStr.append("  ) ");

		System.out.println(new Date() + " [RISDB] verifyDiKeyDoccode sql="+sqlStr.toString());
		
		ArrayList docDocList = UtilDBWeb.getReportableListCIS(sqlStr.toString());
		for (int i = 0; i < docDocList.size(); i++) {
			ReportableListObject row = (ReportableListObject) docDocList.get(i);
			unmatchLogID.add(row.getFields0());
		}

		return unmatchLogID;
	}
	
	public static String getDocLoginID(String rptLogID, String diDocCode) {		
		StringBuffer sqlStr = new StringBuffer();				
		String docCode = "";
		sqlStr.append("SELECT DI_DOCCODE FROM DI_RPT_LOG@CIS ");
		sqlStr.append("WHERE  DI_RPT_ID = ? AND CO_ENABLED = '1' ");
		
		ArrayList docDocList = null;
		if (diDocCode != null && diDocCode.length() > 0) {
			sqlStr.append("AND DI_DOCCODE = ? ");
			docDocList = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {rptLogID, diDocCode});
		} else {
			docDocList = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {rptLogID});
		}
		
		for (int i = 0; i < docDocList.size(); i++) {			
			ReportableListObject row = (ReportableListObject) docDocList.get(0);
			if(row.getValue(0) != null && row.getValue(0).length() > 0){
				docCode = row.getValue(0);				
			} 		 
		}
		
		return getPortalUserName(docCode);
	}
	
	public static String getRptDefaultPassword(String seqNo){		
		StringBuffer sqlStr = new StringBuffer();
		String password = "";
		
		/* disabled coz now use browser viewer to open report instead of pdf.js
		//sqlStr.append("select substr(docidno,1,4)||to_char(DOCBDATE,'MM')||to_char(DOCBDATE,'DD') from doctor@iweb where doccode = '" + doccode + "'");
		//sqlStr.append("select to_char( co_created_date, 'MMDDHH24MISS' ) || di_doccode password from di_rpt_log@cis  where di_rpt_id = '" + rptId + "'");
		sqlStr.append("select substr(msg_create_dttm, 5,10) || doctor_code as password from ris_report_message@iweb where msg_seq_no = '" + seqNo + "'" );
		
		ArrayList docDocList = UtilDBWeb.getReportableList(sqlStr.toString());
		for (int i = 0; i < docDocList.size(); i++) {			
			ReportableListObject row = (ReportableListObject) docDocList.get(0);
			if(row.getValue(0) != null && row.getValue(0).length() > 0){
				password = row.getValue(0);				
			}
		}
		*/
		
		return password;
	}
	
	
	public static String getDocPasswordForTest(String DocNo){		
		StringBuffer sqlStr = new StringBuffer();
		String password = "";
		sqlStr.append("SELECT substr(docidno,1,4)||to_char(DOCBDATE,'MM')||to_char(DOCBDATE,'DD') psw FROM doctor@iweb d where d.doccode = '" + DocNo + "'" );
		
		ArrayList docDocList = UtilDBWeb.getReportableList(sqlStr.toString());
		for (int i = 0; i < docDocList.size(); i++) {			
			ReportableListObject row = (ReportableListObject) docDocList.get(0);
			if(row.getValue(0) != null && row.getValue(0).length() > 0){
				password = row.getValue(0);				
			}
		}
		return password;
	}
	
	public static String getMsgSeqByRptLogId(String rptLogId){		
		StringBuffer sqlStr = new StringBuffer();
		String msgSeq = "";
		sqlStr.append("select di_seq_num from di_rpt_log@cis where di_rpt_id = '" + rptLogId + "'" );
		
		ArrayList docDocList = UtilDBWeb.getReportableList(sqlStr.toString());
		for (int i = 0; i < docDocList.size(); i++) {			
			ReportableListObject row = (ReportableListObject) docDocList.get(0);
			if(row.getValue(0) != null && row.getValue(0).length() > 0){
				msgSeq = row.getValue(0);				
			}
		}
		return msgSeq;
	}

	public static String getDoccodebyRptlog(String rptLogID){		
		StringBuffer sqlStr = new StringBuffer();
		String doccode = "";
		sqlStr.append("SELECT DI_DOCCODE FROM DI_RPT_LOG@CIS WHERE DI_RPT_ID = '" + rptLogID + "' AND CO_ENABLED = '1' ");
		
		ArrayList docDocList = UtilDBWeb.getReportableList(sqlStr.toString());
		for (int i = 0; i < docDocList.size(); i++) {			
			ReportableListObject row = (ReportableListObject) docDocList.get(0);
			if(row.getValue(0) != null && row.getValue(0).length() > 0){
				doccode = row.getValue(0);				
			}
		}
		
		return doccode;
	}
	
	public static boolean drPortalAccExist(String hatsCode){	
		StringBuffer sqlStr = new StringBuffer();	
		boolean accExist = false;
		sqlStr.append("SELECT CO_USERNAME FROM CO_USERS WHERE CO_USERNAME = 'DR" + hatsCode + "'");
	
		ArrayList docDocList = UtilDBWeb.getReportableList(sqlStr.toString());
		for (int i = 0; i < docDocList.size(); i++) {			
			accExist = true;			 
		}
		
		return accExist;
	}
	
	public static boolean insertSSOUserMaping(String hatsCode, String portalLoginID) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("INSERT INTO SSO_USER_MAPPING@SSO ");
		sqlStr.append("(MODULE_CODE,MODULE_USER_ID,SSO_USER_ID) ");
		sqlStr.append("VALUES ");
		sqlStr.append("('doctor','" + hatsCode + "','" + portalLoginID + "') ");

		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
	
	public static boolean insertSSOUser(String hatsCode, String portalLoginID, String lastName, String givenName) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("INSERT INTO SSO_USER@SSO ");
		sqlStr.append("(SSO_USER_ID,STAFF_NO,LAST_NAME,GIVEN_NAME,DISPLAY_NAME) ");
		sqlStr.append("VALUES ");
		sqlStr.append("('" + portalLoginID +"','" + portalLoginID + "','" + lastName + "','" + givenName + "','" + lastName + " " + givenName + "') ");

		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
	
	public static boolean insertPortalAccount(String hatsCode, String portalLoginID, String lastName, String givenName, String accountPassword) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("INSERT INTO CO_USERS ");
		sqlStr.append("(CO_STAFF_ID, CO_USERNAME, CO_LASTNAME, CO_FIRSTNAME , CO_SITE_CODE, CO_STAFF_YN, CO_GROUP_ID, CO_PASSWORD) ");
		sqlStr.append("VALUES ");
		sqlStr.append("('" + portalLoginID + "', '" + portalLoginID + "', '" + lastName + "', '" + givenName + "' , '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append(", 'Y' , 'doctor' , '" + PasswordUtil.cisEncryption(accountPassword) + "') ");
		
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
	
	public static String getPortalUserName(String docCode) {
		String docUserName = "";
		ArrayList docList = SsoUserDB.getSsoUserIdByModuleUser("doctor", docCode);
		for (int i = 0; i < docList.size(); i++) {
			ReportableListObject row = (ReportableListObject) docList.get(0);
			if(row.getValue(0) != null && row.getValue(0).length() > 0){
				docUserName = row.getValue(0);
			} 
		}
		
		return docUserName;
	}
	
	public static ArrayList getRISReportToSend() {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("select   msg_seq_no, send_date, status, ris_accession_no, ");
		sqlStr.append("		    doctor_code, docemail, slip_no, patient_id, patient_type, ");
		sqlStr.append("		    report_title, stnid, reading_doctor, rpt_version, report_path, exam_dttm ");
		sqlStr.append("from     ris_rpt_send_email ");
		sqlStr.append("WHERE    STATUS IS NULL ");
		if (ConstantsServerSide.isTWAH()) {
			sqlStr.append("	AND (exam_dttm > (select param1 from sysparam where parcde = 'RISRPTSDT') or ris_accession_no =  'TWADI1900332998R') ");
		}
		sqlStr.append("ORDER BY PATIENT_ID ");
		
		System.out.println(new Date() + " [RISDB] getRISReportToSend sql=" + sqlStr.toString());		
		return UtilDBWeb.getReportableListHATS(sqlStr.toString());
	}
	
	public static String getDIReportImagePath() {
		String value = null;
		ArrayList result = UtilDBWeb.getReportableList(sqlStr_getDIReportImagePath);
		
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			value = reportableListObject.getValue(0);
		}
		return value;
	}
	
	public static int getNextReportLogID() {
		String ssID = null;

		ArrayList result = UtilDBWeb.getReportableList("SELECT SEQ_DI_RPT_LOG_ID.NEXTVAL@CIS FROM DUAL");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			ssID = reportableListObject.getValue(0);
		}

		return Integer.parseInt(ssID);
	}
	
	public static boolean updateEmailStatus(String seqNum, String status){
		StringBuffer sqlStr = new StringBuffer();
		boolean ret = false;
		
		sqlStr.append("select count(1) from ris_rpt_send_email_tab@iweb where msg_seq_no = ?");
		ArrayList rlo = UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{seqNum});
		if (!rlo.isEmpty()) {
			sqlStr.setLength(0);
			ReportableListObject row = (ReportableListObject) rlo.get(0);
			if (Integer.parseInt(row.getValue(0)) == 0) {
				sqlStr.append("insert into ris_rpt_send_email_tab@iweb ( status, send_date, msg_seq_no  ) values ( ?, sysdate, ? )");
			} else {
				sqlStr.append("update ris_rpt_send_email_tab@iweb set send_date = sysdate, status = ? where msg_seq_no = ?");
			}
			System.out.println("[RISDB] updateEmailStatus sql=[" + sqlStr.toString()+"] status="+status+", seqNum="+seqNum);
			ret = UtilDBWeb.updateQueue(sqlStr.toString(), new String[]{status, seqNum});
		}
		return ret;
	}
	
	public static ArrayList getDiRptLogList(String rptLogID, String diAccessNum, String doccode, 
			String sendDateFrom, String sendDateTo, String sendSstatus, String readStatus) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("  L.DI_RPT_ID, ");
		sqlStr.append("  L.DI_SEQ_NUM, ");
		sqlStr.append("  L.DI_ACCESS_NUM, ");
		sqlStr.append("  L.DI_RPT_VERSION, ");
		sqlStr.append("  L.DI_DOCCODE, ");
		sqlStr.append("  L.DI_FILE_PATH, ");
		sqlStr.append("  L.DI_DOC_EMAIL, ");
		sqlStr.append("  L.DI_SENDMAIL_STATUS, ");
		sqlStr.append("  L.DI_READDOC_STATUS, ");
		sqlStr.append("  TO_CHAR(L.CO_CREATED_DATE, 'DD/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("  L.CO_CREATED_USER, ");
		sqlStr.append("  TO_CHAR(L.CO_MODIFIED_DATE, 'DD/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("  L.CO_MODIFIED_USER, ");
		sqlStr.append("  L.CO_ENABLED, ");
		sqlStr.append("  (D.DOCFNAME || ' ' || D.DOCGNAME) DOCNAME ");
		sqlStr.append("FROM DI_RPT_LOG@CIS L ");
		sqlStr.append("	JOIN DOCTOR@IWEB D ON D.DOCCODE = L.DI_DOCCODE ");
		sqlStr.append("WHERE L.CO_ENABLED = '1' ");
		
		if (rptLogID != null && rptLogID.length() > 0) {
			sqlStr.append(" AND L.DI_RPT_ID = '" + rptLogID + "' ");
		}	
		if (diAccessNum != null && diAccessNum.length() > 0) {
			sqlStr.append(" AND L.DI_ACCESS_NUM like '%" + diAccessNum + "%' ");
		}	
		if (doccode != null && doccode.length() > 0) {
			sqlStr.append(" AND UPPER(L.DI_DOCCODE) = UPPER('" + doccode + "') ");
		}	
		if (sendDateFrom != null && sendDateFrom.length() > 0) {
			sqlStr.append(" AND L.CO_CREATED_DATE > TO_DATE('" + sendDateFrom + "', 'DD/MM/YYYY') ");
		}	
		if (sendDateTo != null && sendDateTo.length() > 0) {
			sqlStr.append(" AND L.CO_CREATED_DATE < TO_DATE('" + sendDateTo + "', 'DD/MM/YYYY') + 1 ");
		}
		if (sendSstatus != null && sendSstatus.length() > 0) {
			sqlStr.append(" AND L.DI_SENDMAIL_STATUS = '" + sendSstatus + "' ");
		}	
		if (readStatus != null && readStatus.length() > 0) {
			sqlStr.append(" AND L.DI_READDOC_STATUS = '" + readStatus + "' ");
		}	
		sqlStr.append("ORDER BY L.CO_CREATED_DATE DESC ");
		
		//System.out.println(sqlStr.toString());		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getRptLogDetail(String rptLogID, String docCode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DI_ACCESS_NUM FROM DI_RPT_LOG@CIS ");
		sqlStr.append("WHERE  DI_RPT_ID = ? AND CO_ENABLED = '1' ");
		sqlStr.append("AND    DI_DOCCODE in ");
		sqlStr.append("( ");
		sqlStr.append("	select doccode from doctor@iweb ");
		sqlStr.append("	where ");
		sqlStr.append("		mstrdoccode in ");
		sqlStr.append("		(select mstrdoccode from doctor@iweb where mstrdoccode = ? or doccode = ?) ");
		sqlStr.append("		or doccode in ");
		sqlStr.append("		(select mstrdoccode from doctor@iweb where mstrdoccode = ? or doccode = ?) ");
		sqlStr.append("		or doccode in ");
		sqlStr.append("		(select doccode from doctor@iweb where mstrdoccode = ? or doccode = ?) ");
		sqlStr.append(") ");
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {rptLogID, docCode, docCode, docCode, docCode, docCode, docCode});
	}
	
	public static ArrayList getRisAutoMatchLogList(String accessno, String patno, String status) {
		List<String> params = new ArrayList<String>();
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT logno, accessno, patno, doccode, examcode, examname, slpno, stnid, pattype, to_char(orderdate, 'dd/mm/yyyy hh24:mi:ss'), status ");
		sqlStr.append("FROM ris_auto_match_log@iweb ");
		sqlStr.append("WHERE 1=1 ");
		if (accessno != null && !accessno.isEmpty()) {
			sqlStr.append("AND accessno = ? ");
			params.add(accessno);
		}
		if (patno != null && !patno.isEmpty()) {
			sqlStr.append("AND patno = ? ");
			params.add(patno);
		}
		if (status != null && !status.isEmpty()) {
			sqlStr.append("AND status = ? ");
			params.add(status);
		}
		sqlStr.append("ORDER BY orderdate desc");
		
		//System.out.println("[getRisAutoMatchLogList] sql=" + sqlStr.toString());
		
		String[] paramsArray = params.toArray(new String[]{});
 		return UtilDBWeb.getReportableList(sqlStr.toString(), paramsArray);
	}
	
	public static List<String> getRisAutoMatchLogStatus() {
		StringBuffer sqlStr = new StringBuffer();
		List<String> statusList = new ArrayList<String>();
		sqlStr.append("SELECT distinct status ");
		sqlStr.append("from ris_auto_match_log@hat ");
		sqlStr.append("order by status");

		ArrayList rows = UtilDBWeb.getReportableListCIS(sqlStr.toString());
		for (int i = 0; i < rows.size(); i++) {
			ReportableListObject row = (ReportableListObject) rows.get(i);
			statusList.add(row.getFields0());
		}

		return statusList;
	}
	
	public static boolean updateRisAutoMatchLogStatus(String logno, String status){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("update ris_auto_match_log@iweb set status = ? where logno = ? ");
		
		//System.out.println("[updateRisAutoMatchLogStatus] sql=" + sqlStr.toString());
		return UtilDBWeb.updateQueue(sqlStr.toString(),new String[]{status, logno});
	}
	
	public static boolean allowReadDoc(UserBean userBean, String rptLogID, String docCode) {
		StringBuffer sqlStr = new StringBuffer();		
		boolean allowReadDoc = false;
		sqlStr.append("SELECT DI_DOCCODE FROM DI_RPT_LOG ");
		sqlStr.append("WHERE  DI_RPT_ID = ? ");
		sqlStr.append("AND    DI_DOCCODE in ");
		sqlStr.append("( ");
		sqlStr.append("	select doccode from doctor@hat ");
		sqlStr.append("	where ");
		sqlStr.append("		mstrdoccode in ");
		sqlStr.append("		(select mstrdoccode from doctor@hat where mstrdoccode = ? or doccode = ?) ");
		sqlStr.append("		or doccode in ");
		sqlStr.append("		(select mstrdoccode from doctor@hat where mstrdoccode = ? or doccode = ?) ");
		sqlStr.append("		or doccode in ");
		sqlStr.append("		(select doccode from doctor@hat where mstrdoccode = ? or doccode = ?) ");
		sqlStr.append(") ");
		sqlStr.append("AND CO_ENABLED = '1' ");

		ArrayList docDocList = UtilDBWeb.getReportableListCIS(sqlStr.toString(),
				new String[]{rptLogID, docCode, docCode, docCode, docCode, docCode, docCode});
		for (int i = 0; i < docDocList.size(); i++) {
			allowReadDoc = true;			 
		}
		
		System.out.println(new Date() + " [RISDB] allowReadDoc loginID="+userBean.getLoginID()+", rptLogID="+rptLogID+", docCode="+docCode+", allowReadDoc="+allowReadDoc);
		return allowReadDoc;
	}
	
	public static boolean updateReadDoc(UserBean userBean, String rptLogID, String docCode) {
		StringBuffer sqlStr = new StringBuffer();
		String staffID = userBean.getStaffID();
		sqlStr.append("UPDATE DI_RPT_LOG@CIS SET DI_READDOC_STATUS = '1', ");
		sqlStr.append("		  CO_MODIFIED_DATE=SYSDATE, CO_MODIFIED_USER=? ");
		sqlStr.append("WHERE DI_RPT_ID = ? ");
		sqlStr.append("AND DI_READDOC_STATUS = '0' ");
		sqlStr.append("AND DI_DOCCODE in ");
		sqlStr.append("( ");
		sqlStr.append("	select doccode from doctor@iweb ");
		sqlStr.append("	where ");
		sqlStr.append("		mstrdoccode in ");
		sqlStr.append("		(select mstrdoccode from doctor@iweb where mstrdoccode = ? or doccode = ?) ");
		sqlStr.append("		or doccode in ");
		sqlStr.append("		(select mstrdoccode from doctor@iweb where mstrdoccode = ? or doccode = ?) ");
		sqlStr.append("		or doccode in ");
		sqlStr.append("		(select doccode from doctor@iweb where mstrdoccode = ? or doccode = ?) ");
		sqlStr.append(") ");
		
		System.out.println(new Date() + " [RISDB] updateReadDoc loginID="+userBean.getLoginID()+", rptLogID="+rptLogID+",docCode="+docCode);
		
		return UtilDBWeb.updateQueue(sqlStr.toString(), 
				new String[]{userBean.getLoginID(), rptLogID, docCode, docCode, docCode, docCode, docCode, docCode});
	}
	
	public static String getDocCode(UserBean userBean) {
		String docCode = "";
		// Lab DI report account is uppercase DR<doccode> 
		ArrayList docList = SsoUserDB.getModuleUserIdBySsoUserId("doctor", userBean.getLoginID().toUpperCase());
		for (int i = 0; i < docList.size(); i++) {
			ReportableListObject row = (ReportableListObject) docList.get(0);
			if(row.getValue(0) != null && row.getValue(0).length() > 0){
				docCode = row.getValue(0);
			}
		}
		return docCode;
	}
	
	public static String getPatientName(String patNo) {
		String patientName = "N/A";
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT PATFNAME || ', ' || PATGNAME FROM PATIENT@IWEB WHERE PATNO = '" + patNo + "' ");
		ArrayList patientList = UtilDBWeb.getReportableList(sqlStr.toString());
		for (int i = 0; i < patientList.size(); i++) {
			ReportableListObject row = (ReportableListObject) patientList.get(0);
			if(row.getValue(0) != null && row.getValue(0).length() > 0){
				patientName = row.getValue(0);
			}
		}
		return patientName;		
	}
	
	public static boolean checkReportAvailable(String accessionNum){	
		StringBuffer sqlStr = new StringBuffer();
		boolean reportAvailable = true;

		sqlStr.append("SELECT msg_seq_no, send_date, status, ris_accession_no FROM ris_rpt_send_email ");
		sqlStr.append("where ris_accession_no = '" + accessionNum + "' and STATUS IS NULL ");
			
		ArrayList rptList = UtilDBWeb.getReportableListHATS(sqlStr.toString());
		for (int i = 0; i < rptList.size(); i++) {
			reportAvailable = false;
		}	
		return reportAvailable;
	}
	
	private static StringBuffer generateEmailContent(String patNo, String critical, String risAccessionNo, String rptLogID, String docCode){
		StringBuffer content = new StringBuffer();

		content.append("<tr>");
		content.append("<td>");
		if("Y".equals(critical)){
			content.append("<font color='red' style='font-weight:bold'>" + getPatientName(patNo) + "</font>");
		} else {
			content.append(getPatientName(patNo));
		}
		content.append("</td>");			
		content.append("<td>");
		if("Y".equals(critical)){
			content.append("<font color='red' style='font-weight:bold'>" + risAccessionNo + "</font>");
		} else {
			content.append(risAccessionNo);
		}
		content.append("</td>");
		
		String url = ""; 
		if (ConstantsServerSide.isTWAH()){
			if(ConstantsServerSide.DEBUG) {
				//url = "http://localhost:8080/intranet/di/convertPdfWithPW.jsp?";
				url = "https://mail.twah.org.hk/intranet/di/convertPdfWithPW.jsp?";
			} else {
				url = "https://mail.twah.org.hk/intranet/di/convertPdfWithPW.jsp?";
			}
		} else {
			if(ConstantsServerSide.DEBUG) {
				//url = "http://localhost:8080/intranet/di/convertPdfWithPW.jsp?";
				//url = "http://160.100.2.99:8080/intranet/di/convertPdfWithPW.jsp?";
				//url = "http://160.100.2.45:8080/intranet/di/convertPdfWithPW.jsp?";
				url = "http://demo3/intranet/di/convertPdfWithPW.jsp?";
				//url = "https://mail.hkah.org.hk/intranet/di/convertPdfWithPW.jsp?";
			} else {
				url = "https://mail.hkah.org.hk/intranet/di/convertPdfWithPW.jsp?";
			}
		}			
		url = url + "rptLogID="+rptLogID+"&";
		url = url + "docCode="+docCode;
		content.append("<td>");
		content.append("<a href='" + url +"'>link</a>");
		content.append("</td>");
		content.append("</tr>");
					
		return content;
	}
	
	public static void sendRISEmails(){
		System.out.println(new Date() + " [RISDB] SEND DI EMAILS");
		
		String senderMail = ConstantsServerSide.MAIL_ALERT;
		if (ConstantsServerSide.isTWAH()){
			senderMail = "hkah-tw.di@twah.org.hk";	// no auth, redirect to alert@twah.org.hk
		} else {
			senderMail = UtilMail.getEmailById("hkah-sr.di");	// auth is needed
			senderMail = senderMail == null ? ConstantsServerSide.MAIL_ALERT : senderMail;
		}
		
		ArrayList risList = getRISReportToSend();
		ArrayList<DoctorDetail> doctorDetailList = new ArrayList<DoctorDetail>();
		
		System.out.println(new Date() + " [RISDB] risList size="+risList.size());
		
		int rptLogID = getNextReportLogID();
		for (int i = 0; i < risList.size(); i++) {
			ReportableListObject row = (ReportableListObject) risList.get(i);
			String tSeqNum = row.getValue(0);
			String tFilePath = row.getValue(13);
			int index = tFilePath.lastIndexOf("\\");
			String tFName = tFilePath.substring(index + 1);
			
			String tDocCode = row.getValue(4);	
			String tDocEmail = row.getValue(5);	
			String tPatNo = row.getValue(7);
			String tAccessionNo = row.getValue(3);
			String rptVersion = row.getValue(12);
			
			System.out.println(new Date() + " [RISDB] row (" + i + ") tAccessionNo="+tAccessionNo+", tSeqNum="+tSeqNum+", tDocCode="+tDocCode+", tDocEmail="+tDocEmail+", tFilePath="+tFilePath);
		
			if (tFilePath != null && tFilePath.length() > 0){
				//updateEmailStatus(tSeqNum, "S");
				
				HashMap<String, String> listOfDocInfo = new HashMap<String, String>();	
			
				boolean isConvert = false;
				if(tDocCode != null && tDocCode.length() > 0){				
					listOfDocInfo.put(tDocCode, tDocEmail);
					if(tDocEmail != null && tDocEmail.length() > 0){
						isConvert = true;
					}
				} 
					
				try {							
					if(isConvert){
						System.out.println(new Date() + " [RISDB] before load report : access no. = " + tAccessionNo );
						PDDocument doc = PDDocument.load(new File(tFilePath));

						// Define the length of the encryption key.
						// Possible values are 40 or 128 (256 will be available in PDFBox 2.0).
						int keyLength = 128;

						AccessPermission ap = new AccessPermission();

						// Disable printing, everything else is allowed
						ap.setCanPrint(false);

						// Owner password (to open the file with all permissions) 
						// User password (to open the file but with restricted permissions, is empty here) 
						//StandardProtectionPolicy spp = new StandardProtectionPolicy("12345", "12345", ap);
						
						// disable password
						//StandardProtectionPolicy spp = new StandardProtectionPolicy(RISDB.getRptDefaultPassword(tSeqNum), RISDB.getRptDefaultPassword(tSeqNum), ap);
						//spp.setEncryptionKeyLength(keyLength);
						//spp.setPermissions(ap);
						//doc.protect(spp);

						System.out.println(new Date() + " [RISDB] before save report : access no. = " + tAccessionNo );
						String storeImagePath = getDIReportImagePath(); 
						String destinationDir = CMSDB.createDir(storeImagePath+"\\"+tAccessionNo);
						FileUtils.cleanDirectory(new File(storeImagePath+"\\"+tAccessionNo)); 
						doc.save(destinationDir + "\\" + tFName);
						doc.close();
						System.out.println(new Date() + " [RISDB] after save report : access no. = " + tAccessionNo );
						
						/*
						String storeImagePath = getDIReportImagePath(); 
						String destinationDir = CMSDB.createDir(storeImagePath+"\\"+tAccessionNo);
						FileUtils.cleanDirectory(new File(storeImagePath+"\\"+tAccessionNo)); 
						Converter.convertPdfToImage(tFilePath, destinationDir + "\\", 150);
						*/	
					}
					
					System.out.println(new Date() + " [RISDB] create details, listOfDocInfo size=" + listOfDocInfo.size());
					
					Iterator it = listOfDocInfo.entrySet().iterator();
					 while (it.hasNext()) {								
						Map.Entry pair = (Map.Entry)it.next();
						String docCode = (String) pair.getKey();						
						String allDocEmail = (String) pair.getValue();
						
						boolean foundDocCode = false;
						for(DoctorDetail d : doctorDetailList){
							if(d.docCode.equals(docCode)){
								foundDocCode = true;
								rptLogID = getNextReportLogID();
								d.diDetailList.add(new DIReportDetail(rptLogID, tSeqNum, tFilePath, tPatNo, tAccessionNo, rptVersion));
								break;
							}
						}
						if(foundDocCode == false){
							DoctorDetail tDoc = new DoctorDetail(docCode, allDocEmail);
							rptLogID = getNextReportLogID();
							tDoc.diDetailList.add(new DIReportDetail(rptLogID, tSeqNum, tFilePath, tPatNo, tAccessionNo, rptVersion));
							doctorDetailList.add(tDoc);
						}
					}
				} catch (Exception e) {
					System.out.println(e);
				}
			} else {
				updateEmailStatus(tSeqNum, "E");
			}
		}
		
		System.out.println(new Date() + " [RISDB] create emails, doctorDetailList size=" + doctorDetailList.size());
		
		for(DoctorDetail d : doctorDetailList){		
			String docFullName = DoctorDB.getDoctorFullName(d.docCode);
			if (docFullName == null) {
				EmailAlertDB.sendEmail("ris.doc.report", 
						"[" + ConstantsServerSide.SITE_CODE + "] DI Doctor email error: cannot get doctor name from HATS", 
						"Cannot get doctor name from HATS<br/>" +
						"Doctor: " + d.docCode + "<br/>");
			} else {
				StringBuffer content = new StringBuffer();
				content.append("<div style='font-size:13px'>");
				content.append("Dear Dr " + docFullName + "</br></br>");
				content.append("Please kindly find the hyperlink below for the Radiology report(s) which are ready for you.</br></br>");
				
				content.append("<table border='1'>");
				content.append("<tr bgcolor='#DCDCDC'>");
				content.append("<td>PATIENT NAME</td><td>Accession #</td><td>HYPERLINK</td>");
				content.append("</tr>");
				for(DIReportDetail l : d.diDetailList){
					content.append(generateEmailContent(l.patNo, "N", l.accessionNo, Integer.toString(l.diLogID), d.docCode));
				}
				content.append("</table></br>");
				content.append("<div style='font-size:15px;color:red;font-weight:bold;'>The password is first 4 characters of the requesting doctor's HKID + Birth Date's month + Birth Date's day</br>"); 
				content.append("Eg. Doctor's HKID A123456(7), Doctor's Birth Date = Jan 31,1980</br>");
				content.append("Password = A1230131</br></br></div>");
				content.append("<div style='font-size:14px;font-weight:bold;'>For any enquiry, call us at " + (ConstantsServerSide.isTWAH() ? "6383 5431" : "2835 0515") + " or reply to this email for any questions or concerns.</div></br></br>");
				// Just for testing , must be commented after production launched
				//content.append("Doctor Account Password ( Just for Testing period Only ) : " + getDocPasswordForTest(d.docCode) + "</br></br>");
				content.append("The information contained in this transmission contain privileged and confidential information. It is intended only for the use of the person(s) named above. If you are not intended recipient, you are hereby notified that any review, dissemination, distribution, or duplication of this communication is strictly prohibited. Please contact the sender and destroy all copies of the original message.</div>");
	
				String[] emailArray = d.email.split(";");
				
				System.out.println(new Date() + " [RISDB] d.docCode="+d.docCode+", d.email=" + d.email);
				
				if(d.email != null && d.email.length() > 0){
					boolean isAccountCreated = createDrPortalAccount(d.docCode);				
					boolean emailSuccess = false;
					boolean okToSendEmail = true;
					
					System.out.println(new Date() + " [RISDB] isAccountCreated="+isAccountCreated);
					
					if (isAccountCreated) {
						System.out.println(new Date() + " [RISDB] d.diDetailList size="+d.diDetailList.size());
						
						List<Integer> diLogIDs = new ArrayList<Integer>();
						for (DIReportDetail l : d.diDetailList) {
							diLogIDs.add(l.diLogID);
							
							if (!insertDIReportLog(Integer.toString(l.diLogID), l.seqNo, l.accessionNo, l.rptVersion, d.docCode,  l.filePath, d.email, "To Be Send", "0")) {
								okToSendEmail = false;
							}
							updateEmailStatus(l.seqNo, "S");
						}
						
						System.out.println(new Date() + " [RISDB] okToSendEmail="+okToSendEmail);
						
						if (okToSendEmail) {
							List<String> unmatchList = verifyDiKeyDoccode(diLogIDs);
							System.out.println(new Date() + " [RISDB] verifyDiKeyDoccode, unmatchList size="+unmatchList.size());
							
							if (unmatchList.isEmpty()) {
								emailSuccess = EmailAlertDB.sendEmail("ris.doc.report", "Completed DI Results Notification", content.toString(), emailArray);
								System.out.println(new Date() + " [RISDB] emailSuccess="+emailSuccess);
								
								if (emailSuccess) {
									updateDiRptLogSendMailStatus(diLogIDs, "Success");
								} else {
									updateDiRptLogSendMailStatus(diLogIDs, "Send Failed");
									EmailAlertDB.sendEmail("ris.doc.report", 
											"[" + ConstantsServerSide.SITE_CODE + "] DI Doctor email error: failed to send email", 
											"Failed to send email<br/>" +
											"Doctor: " + d.docCode + "<br/>" +
											"DI_RPT_ID = " + StringUtils.join(diLogIDs, ","));
								}
							} else {
								EmailAlertDB.sendEmail("ris.doc.report", 
										"[" + ConstantsServerSide.SITE_CODE + "] DI Doctor email error: ris_rpt_send_email and di_rpt_log not match", 
										"Failed to insert to di_rpt_log<br/>" +
										"Doctor: " + d.docCode + "<br/>" +
										"Unmatch DI_RPT_ID = " + StringUtils.join(unmatchList, ","));	
							}
						} else {
							EmailAlertDB.sendEmail("ris.doc.report", 
									"[" + ConstantsServerSide.SITE_CODE + "] DI Doctor email error: failed to insert to di_rpt_log", 
									"Failed to insert to di_rpt_log<br/>" +
									"Doctor: " + d.docCode + "<br/>" +
									"DI_RPT_ID = " + StringUtils.join(diLogIDs, ","));
						}
					}
				}else {
					for(DIReportDetail l : d.diDetailList){
						insertDIReportLog(Integer.toString(l.diLogID), l.seqNo, l.accessionNo, l.rptVersion, d.docCode, l.filePath, d.email, "No Email", "0");
						updateEmailStatus(l.seqNo, "S");
					}
				}
			}
		}
	}
	
	private static boolean createDrPortalAccount(String drCode){
		boolean isAccountCreated = true;
		if(!RISDB.drPortalAccExist(drCode)){
			//ArrayList ris_doc_info = RISDB.getRISDocInfo(drCode);		
			ArrayList hats_doc_info =  DoctorDB.getHATSDocInfo(drCode);
			
			String hatsCode = drCode;
			String portalLoginID = "DR"+drCode;
			String lastName = "";
			String givenName = "";
			String accountPassword = ""; 
			
			if (hats_doc_info.size() > 0) {
				ReportableListObject reportableListObject = (ReportableListObject) hats_doc_info.get(0);
				String hkidFirstFourChar = "";
				String hkidFromSearch = reportableListObject.getValue(1);
				String dobFromSearch = reportableListObject.getValue(2);;
				if(hkidFromSearch != null && hkidFromSearch.length() > 0){
					hkidFirstFourChar = hkidFromSearch.substring(0, Math.min(hkidFromSearch.length(), 4));
				}
				String mmForPW = "";
				String ddForPW = "";
				if(dobFromSearch != null && dobFromSearch.length() > 0){
					String[] splitDOB = dobFromSearch.split("/");
						if(splitDOB.length == 3){
							mmForPW = splitDOB[1];
							ddForPW = splitDOB[0];
					}
				}
				accountPassword = hkidFirstFourChar + mmForPW + ddForPW ;
				lastName = reportableListObject.getValue(4);
				givenName = reportableListObject.getValue(5);
			}
					
			if(accountPassword.length() == 8){
				RISDB.insertSSOUserMaping(hatsCode, portalLoginID);	
				RISDB.insertSSOUser(hatsCode, portalLoginID, lastName, givenName);
				RISDB.insertPortalAccount(hatsCode, portalLoginID, lastName, givenName, accountPassword);
				
				StringBuffer content = new StringBuffer();
				content.append("SSO User (ID = " + portalLoginID + ", SSO Staff No = " + portalLoginID +")");
				content.append("\n");
				content.append("SSO User Mapping (Module Code = doctor, Module User ID = " + hatsCode + ", SSO User ID = " + portalLoginID + ")");
				content.append("\n");
				content.append("Portal User (Username = " + portalLoginID + ", Staff ID = " + portalLoginID);
				
				EmailAlertDB.sendEmail("ris.doc.acc", "DI Doctor account created - " + drCode, content.toString());
			} else {
				EmailAlertDB.sendEmail("ris.doc.acc", "DI Missing Doctor info Error - " + drCode, "");
				isAccountCreated = false;
			}
		}
		return isAccountCreated;
	}
	
	public static ArrayList<ReportableListObject> getDocRISEmailList(String docCode, String docName, String sendRisEmail){
		List<String> params = new ArrayList<String>();
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT D.DOCCODE, D.DOCFNAME || ' ' || D.DOCGNAME DOCNAME, D.DOCEMAIL, CASE WHEN DE.DOCCODE IS NULL THEN -1 ELSE DE.SENDRISEMAIL END SENDRISEMAIL, TO_CHAR(DE.SENDRISEMAIL_MODDT, 'DD/MM/YYYY HH24:MI:SS'), D.MSTRDOCCODE ");
		sqlStr.append("FROM DOCTOR D LEFT JOIN DOCTOR_EXTRA DE ON D.DOCCODE = DE.DOCCODE ");
		sqlStr.append("WHERE D.DOCSTS = -1 ");
		sqlStr.append("AND D.ISDOCTOR = -1 ");
		if (docCode != null && !docCode.trim().isEmpty()) {
			sqlStr.append("AND D.DOCCODE = ? ");
			params.add(docCode);
		}
		if (docName != null && !docName.trim().isEmpty()) {
			sqlStr.append("AND (UPPER(D.DOCGNAME) like '%" + StringEscapeUtils.escapeSql(docName.toUpperCase()) + "%' OR ");
			sqlStr.append(" UPPER(D.DOCFNAME) like '%" + StringEscapeUtils.escapeSql(docName.toUpperCase()) + "%') ");
		}
		if (sendRisEmail != null&& !sendRisEmail.trim().isEmpty()) {
			sqlStr.append("AND DE.SENDRISEMAIL = ? ");
			params.add(sendRisEmail);
		}
		sqlStr.append("ORDER BY D.DOCCODE");
		
		String[] paramsArray = params.toArray(new String[]{});
		//System.out.println(sqlStr.toString());		
		return UtilDBWeb.getReportableListHATS(sqlStr.toString(), paramsArray);
	}
	
	public static boolean updateDocRISEmail(String docCode, String sendRisEmail){
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT 1 FROM DOCTOR_EXTRA WHERE DOCCODE = ? ");
		ArrayList<ReportableListObject> list = UtilDBWeb.getReportableListHATS(sqlStr.toString(), new String[]{docCode});
		if (list.isEmpty()) {
			sqlStr.setLength(0);
			sqlStr.append("INSERT INTO DOCTOR_EXTRA(DOCCODE) VALUES(?) ");
			UtilDBWeb.updateQueueHATS(sqlStr.toString(),new String[]{docCode});
		}
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE DOCTOR_EXTRA SET SENDRISEMAIL = ?, SENDRISEMAIL_MODDT = SYSDATE WHERE DOCCODE = ? ");
		
		//System.out.println("[updateDocRISEmail] sql=" + sqlStr.toString());
		return UtilDBWeb.updateQueueHATS(sqlStr.toString(),new String[]{sendRisEmail, docCode});
	}
}