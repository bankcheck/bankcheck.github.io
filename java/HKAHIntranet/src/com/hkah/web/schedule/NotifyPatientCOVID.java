package com.hkah.web.schedule;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Locale;

import jcifs.smb.NtlmPasswordAuthentication;
import jcifs.smb.SmbFile;
import jcifs.smb.SmbFileInputStream;

import net.lingala.zip4j.core.ZipFile;
import net.lingala.zip4j.exception.ZipException;
import net.lingala.zip4j.model.ZipParameters;
import net.lingala.zip4j.util.Zip4jConstants;

import org.apache.commons.lang.ArrayUtils;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.util.sms.UtilSMS;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.EmailAlertDB;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.encryption.AccessPermission;
import org.apache.pdfbox.pdmodel.encryption.StandardProtectionPolicy;

public class NotifyPatientCOVID implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		System.out.println("===== NotifyPatientCOVID v1.76 Start =====");
		main();
		System.out.println("===== NotifyPatientCOVID End =====");
	}

	// ======================================================================
	private static ArrayList<ReportableListObject> getList() {

		StringBuffer sqlStr = new StringBuffer();
/*
		sqlStr.append("SELECT LAB_NUM, TEST_CAT, PATNO, EMAIL, TO_CHAR(rptdate, 'YYYYMMDDHH24MISS'), report_path, report_file, HC_PATH, HC_FILE, COVGQ_PATH, COVGQ_FILE, ");
		sqlStr.append("	loc_code, location, patient, priority "); 
		sqlStr.append(" FROM V_HC_EMAIL_PENDING2@LIS ");
*/
		sqlStr.append("SELECT LAB_NUM, TEST_CAT, PATNO, EMAIL, TO_CHAR(rptdate, 'YYYYMMDDHH24MISS'), "); 
		sqlStr.append("	report_path, report_file, HC_PATH, HC_FILE, COVGQ_PATH, COVGQ_FILE, ");
		sqlStr.append("	loc_code, location, patient, priority "); 
		sqlStr.append(" FROM V_HC_EMAIL_PENDING3@LIS ");
		sqlStr.append(" WHERE PAT_EMAIL_LOG_ID IS NULL ");
		//sqlStr.append(" AND RPTDATE > SYSDATE - 7 ");		
				
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	// ======================================================================
	private static ArrayList<ReportableListObject> getList(String labnum) {

		StringBuffer sqlStr = new StringBuffer();
/*
		sqlStr.append("SELECT LAB_NUM, TEST_CAT, PATNO, EMAIL, TO_CHAR(rptdate, 'YYYYMMDDHH24MISS'), report_path, report_file, HC_PATH, HC_FILE, COVGQ_PATH, COVGQ_FILE, ");
		sqlStr.append("	loc_code, location, patient, priority "); 
		sqlStr.append(" FROM V_HC_EMAIL_PENDING2@LIS ");
*/
		sqlStr.append("SELECT LAB_NUM, TEST_CAT, PATNO, EMAIL, TO_CHAR(rptdate, 'YYYYMMDDHH24MISS'), "); 
		sqlStr.append("	report_path, report_file, HC_PATH, HC_FILE, COVGQ_PATH, COVGQ_FILE, ");
		sqlStr.append("	loc_code, location, patient, priority "); 
		sqlStr.append(" FROM V_HC_EMAIL_PENDING3@LIS ");
		sqlStr.append(" WHERE LAB_NUM = ? ");
				
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{labnum});
	}	
	
	// ======================================================================	
	private static String getTest(String labnum, String lang){
		
		String test = "SARS-CoV-2";
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("select p.long_desc, p.chinese ");
		sqlStr.append(" from labo_detail@LIS d inner join labm_prices@LIS p on d.test_num = p.code ");
		sqlStr.append(" where p.code in ( ");
//HK codes		
		sqlStr.append("		'HC', 'SARS', 'XSAR', ");
//TW codes		
		sqlStr.append("		'XHC', 'XSARS', ");
		sqlStr.append("		'COVGQ') ");
		sqlStr.append(" and lab_num = ? ");
		sqlStr.append(" and rownum = 1 ");

		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {labnum});
		ReportableListObject row = null;

		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			
			if ( "TRC".equals(lang) || "SMC".equals(lang) )
				test = row.getValue(1);
			else
				test = row.getValue(0);
		}
        
        return test;
	}

	// ======================================================================
	public static void main() {
					    		
		ArrayList<ReportableListObject> record = getList();
		ReportableListObject row = null;
		
		String summary = null;
		
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			
			String labnum = row.getValue(0);
			String testcat = row.getValue(1);
			String patno = row.getValue(2);
			String email = row.getValue(3);
			String rptDate = row.getValue(4);
			String rptPath = row.getValue(5);
			String rptFile = row.getValue(6);
			String hcPath = row.getValue(7);
			String hcFile = row.getValue(8);
			String ccPath = row.getValue(9);
			String ccFile = row.getValue(10);
			String loccode = row.getValue(11);
			String location = row.getValue(12);
			String patient = row.getValue(13);
			String priority = row.getValue(14);
			
			try {
													
				String message = send ( labnum, testcat, patno, email, rptDate, rptPath, rptFile, hcPath, hcFile, ccPath, ccFile, loccode, false );
					
				if ( message != null ) {
					if (summary == null) {
						summary = "<table border=1><tr><th>LABNUM</th>" +
								"<th>EMAIL</th>" +
								"<th>PATNO</th>" +
								"<th>NAME</th>" +
								"<th>TEST</th>" +
								"<th>LOCATION</th>" +
								"<th>PRIORITY</th>" +
								"<th>STATUS</th></tr>";
					}
				   
					summary = summary + "<tr><td>" + 
						labnum + "</td><td>" +
						email + "</td><td>" +
						patno + "</td><td>" +
						patient + "</td><td>" + 
						getTest(labnum, "ENG") + "</td><td>" +
						location + "</td><td>" +
						priority + "</td><td>" +
						message + "</td></tr>";		
				}
				
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
				
		}
		
		if (summary != null) {
			summary = summary + "</table>";
		
			try {				
				String site = ConstantsServerSide.SITE_CODE;
				
				String emailFrom = "it-admin@hkah.org.hk";
				if ("twah".equals(site)) 
					emailFrom = "alert@twah.org.hk";
				
				String subject = site + " COVID-19 Patient Email Fail" ;
			
				UtilMail.sendMail(emailFrom, getAdminEmail(), subject, summary);			
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}

	}
	
	// ======================================================================
	public static String send ( String labnum, String email, boolean debug ) {
		
		String message = "";
		
		ArrayList<ReportableListObject> record = getList(labnum);
		ReportableListObject row = null;	
		
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			
			String testcat = row.getValue(1);
			String patno = row.getValue(2);
			
			if (!debug) 
				email = row.getValue(3);
			
			String rptDate = row.getValue(4);
			String rptPath = row.getValue(5);
			String rptFile = row.getValue(6);
			String hcPath = row.getValue(7);
			String hcFile = row.getValue(8);
			String ccPath = row.getValue(9);
			String ccFile = row.getValue(10);
			String loccode = row.getValue(11);
			
			try {									
				message = message + labnum + "-" + testcat + ": "
					+ send ( labnum, testcat, patno, email, rptDate, rptPath, rptFile, hcPath, hcFile, ccPath, ccFile, loccode, debug );
				
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		
		return message; 
	}
	
	// ======================================================================
	private static String send ( String labnum, String testcat, String patno, String email, String rptDate, 
			String rptPath, String rptFile, String hcPath, String hcFile, String ccPath, String ccFile, 
			String loccode, boolean debug ) {
		
		String message = null;
		String logid = null;
		String rptType = null;
		String certType = null;
		
		String srcRptPath = rptPath.trim() + rptFile;
		String srcCrtPath = null;
		
		if ( "1".equals(testcat) ) {
			srcCrtPath = ccPath.trim() + ccFile;
			rptType = "LIS-1";
			certType = "LIS-IGG";
		} else if ( "M".equals(testcat) ) {
			srcCrtPath = hcPath.trim() + hcFile;
			rptType = "LIS-M";
			certType = "LIS-COVID";
		}
		
		String file = labnum + "-report.pdf";
		
		if ( email == null || email.trim().isEmpty() ) {	
			if (!debug) {
				message = "No email address";
				logid = UtilMail.insertDMSEmailLog(labnum, rptType, patno, email, rptDate, srcRptPath, file, getPasswd(labnum));
				UtilMail.updateDMSEmailLog(logid, message, false);
				updateReportLog(labnum, testcat, logid);
			}
			
			return message;
		}
		
		if ( email != null && "NOT PROVIDE".equals(email.trim().toUpperCase()) ) {	
			if (!debug) {
				message = "NOT PROVIDE";
				logid = UtilMail.insertDMSEmailLog(labnum, rptType, patno, email, rptDate, srcRptPath, file, getPasswd(labnum));
				UtilMail.updateDMSEmailLog(logid, message, false);
				updateReportLog(labnum, testcat, logid);
			}
			
			return message;
		}
				
		String site = ConstantsServerSide.SITE_CODE;
		System.out.println("[NotifyPatientCOVID] site= " + site);
		
		String type = null;	
		String sender = null;
		String subject1 = null;
		String[] bcc = null;
		
		if ("AMC2".equals(loccode)) {
			type = "AMC2";
			sender = "hkahsrcovid@hkah.org.hk";
			subject1 = "港安醫療中心 (太古坊)：請參閱附件 Adventist Medical Center (Taikoo Place): Document(s) for Your Reference";
		} else if ("hkah".equals(site)) {
			type = "HKLAB";
			sender = "hkahsrcovid@hkah.org.hk";
			subject1 = "香港港安–司徒拔道：請參閱附件 HKAH-Stubbs Road: Document(s) for Your Reference";
		} else {
			type = "TWLAB";
			sender = "lab.dept@twah.org.hk";
			subject1 = "香港港安–荃灣：請參閱附件 HKAH-Tsuen Wan: Document(s) for Your Reference";
		}
		
		if (!debug)
			bcc = getBccEmail(type);
			
		ArrayList<File> attachment = new ArrayList<File>();
		ArrayList<String> filename = new ArrayList<String>();
		
		String tmpFolder = ConstantsServerSide.TEMP_FOLDER;
		
		String destPath = tmpFolder + "/" + file;
		
		filename.add(file);	
		attachment.add(pdfAttachment(destPath, srcRptPath, getPasswd(labnum)));

//20230516 Add DMS_EMAIL_LOG		
		if (!debug)
			logid = UtilMail.insertDMSEmailLog(labnum, rptType, patno, email, rptDate, srcRptPath, file, getPasswd(labnum));
			
		boolean cert = false;
		if ( srcCrtPath != null && !srcCrtPath.trim().isEmpty()  ) {
			file = labnum + "-cert.pdf";
			destPath = tmpFolder + "/" + file;
			
			filename.add(file);			
			attachment.add(pdfAttachment(destPath, srcCrtPath, getPasswd(labnum)));
			
			cert = true;

//20230516 Add DMS_EMAIL_LOG				
			if (!debug)
				UtilMail.attachDMSEmailLog(logid, labnum, certType, rptDate, srcCrtPath, file, getPasswd(labnum));
		}
		
		if (attachment.size() > 0) {
			
			String emailContent1 = getEmail1Content( type );
								
			if (UtilMail.sendMail2(
					sender,
					new String[] { email },
					null, bcc,
					subject1,
					emailContent1, 
					attachment.toArray(new File[attachment.size()]),
					filename.toArray(new String[filename.size()]), 
					false)) {
				
//20230516 Add DMS_EMAIL_LOG				
				if (!debug)	{
					message = "Email sent successfully";
					UtilMail.updateDMSEmailLog(logid, message, true);
					updateReportLog(labnum, testcat, logid);		
				}
					
			} else {
//20230516 Add DMS_EMAIL_LOG	
				message = "Email sent failed";
				if (!debug)	{			
					UtilMail.updateDMSEmailLog(logid, message, false);
					updateReportLog(labnum, testcat, logid);
				}
			}
			
			if (!debug) {
				for (File tmpFile : attachment)
					tmpFile.delete();
			}
											
		} else {
//20230516 Add DMS_EMAIL_LOG				
			message = "File error, email not sent";
			if (!debug)	{			
				UtilMail.updateDMSEmailLog(logid, message, true);
				updateReportLog(labnum, testcat, logid);
			}						
		}
					
		return message;
	}
		
	// ======================================================================
/*Code obsoleted
	public static File zipAttachment (String labnum, String report, String cert, boolean debug) {
		
		File attachment = null;
		String tmpFolder = ConstantsServerSide.TEMP_FOLDER;
		System.out.println("[NotifyPatientCOVID] tmpFolder= " + tmpFolder);
		
		String destRptPath = tmpFolder + "/" + labnum + "-report.pdf";
		String destCrtPath = tmpFolder + "/"  + labnum + "-cert.pdf";

		String login_user = getSysParam("EHRSMBUID");
		if (login_user == null)
			login_user = "webfolder@ahhk.local";
	    String login_pass = getSysParam("EHRSMBPW");
	    if (login_pass == null)
	    	login_pass = "folder28350";

		NtlmPasswordAuthentication smbAuth = new NtlmPasswordAuthentication("",login_user, login_pass);
		
		try {
			
	        SmbFile smbReportFile = new SmbFile("smb:" + report.replace("\\", "/"), smbAuth);
	        SmbFile smbCertFile = new SmbFile("smb:" + cert.replace("\\", "/"), smbAuth);
			
			String zipPath = tmpFolder  + "/" + labnum + ".zip";
			
			System.out.println("[NotifyPatientCOVID] srcRptPath = " + report + 							
					" destRptPath = " + destRptPath +
					" srcCrtPath = " + cert +
					" destCrtPath = " + destCrtPath +
					" smb login = " + login_user + " / " + login_pass + 
					" zipPath = " + zipPath +
					" zipPassword = " + getPasswd() );
			
			File destReportFile = new File( destRptPath ) ;
			copyFileUsingFileStreams( smbReportFile, destReportFile ) ;
			
			File destCertFile = new File( destCrtPath ) ;
			
			if ( cert != null && !cert.trim().isEmpty()  ) {				
				copyFileUsingFileStreams( smbCertFile, destCertFile ) ;
			}
			
			try {
				ZipFile zipFile = new ZipFile(zipPath);						
				ZipParameters param = new ZipParameters();
				param.setCompressionMethod(Zip4jConstants.COMP_DEFLATE);
				param.setCompressionLevel(Zip4jConstants.DEFLATE_LEVEL_NORMAL); 
				param.setEncryptFiles(true);
				param.setEncryptionMethod(Zip4jConstants.ENC_METHOD_STANDARD);
				param.setPassword(getPasswd());
	
				ArrayList<File> filesToAdd = new ArrayList<File>();
				filesToAdd.add(destReportFile);
				
				if ( cert != null && !cert.trim().isEmpty()  ) {
					filesToAdd.add(destCertFile);
				}
									
				zipFile.addFiles(filesToAdd, param);
				
			} catch (ZipException e) {
				System.out.println("[NotifyPatientCOVID] zip file error : " + e.getMessage() );
			    e.printStackTrace();
			}
			
			attachment = new File(zipPath);
			
			if (!debug) {
				destReportFile.delete();
				destCertFile.delete();
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return attachment;			
	}
*/	
	// ======================================================================
	public static File getSmbFile ( String destination, String source ) {
		
		File output = null;

		String login_user = getSysParam("EHRSMBUID");		
		if (login_user == null)
			login_user = "webfolder@ahhk.local";
		
	    String login_pass = getSysParam("EHRSMBPW");
	    if (login_pass == null)
	    	login_pass = "folder28350";

		NtlmPasswordAuthentication smbAuth = new NtlmPasswordAuthentication("",login_user, login_pass);
		
		try {
			
	        SmbFile smbFile = new SmbFile("smb:" + source.replace("\\", "/"), smbAuth);
			
			System.out.println("[NotifyPatientCOVID] srcPath = " + source + 							
					" destFilePath = " + destination +
					" smb login = " + login_user + " / " + login_pass );
			
			output = new File( destination ) ;
			copyFileUsingFileStreams( smbFile, output ) ;
									
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return output;			
	}	

	// ======================================================================
	public static File pdfAttachment ( String destination, String source, String passwd ) {
		
		File attachment = getSmbFile ( destination, source );
		
		try {
			PDDocument pdd = PDDocument.load(attachment);
			AccessPermission ap = new AccessPermission();
			StandardProtectionPolicy stpp = new StandardProtectionPolicy( passwd, passwd, ap);
			stpp.setEncryptionKeyLength(128);
			stpp.setPermissions(ap);
			pdd.protect(stpp);
			pdd.save( destination );         // save the document
			pdd.close();                        // close the document
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
				
		return attachment;			
	}		
	
	// ======================================================================
	private static String getEmail1Content(String type) {
				
		StringBuffer content = new StringBuffer();
					
		String eng_location = "the Clinical and Pathology Laboratory in HKAH-Stubbs Road";;
		String chi_location = "香港港安醫院—司徒拔道病理化驗中心";
		String phone = "28350534";
		if ("AMC2".equals(type)) {
			//eng_location = "Adventist Medical Center (Taikoo Place)";
			eng_location = "the clinic";
			chi_location = "港安醫療中心 (太古坊)";
		} else if ("TWLAB".equals(type)) {
			eng_location = "the Clinical and Pathology Laboratory in HKAH-Tsuen Wan";
			chi_location = "香港港安醫院—荃灣病理化驗中心";
			phone = "22756166";
		}
		
		content.append("尊敬的先生/女士:<br /><br />");
//		content.append("<b>密碼：您的出生年份（如您的出生日期是1958年10月19日，您的密碼就是1958）</b><br /><br />");
//		content.append("閣下可使用上述密碼開啟電郵予閣下的文件。<br /><br />");
		content.append("附件受密碼保護。預設密碼為病人的四位數字出生年份。<br /><br />");
		content.append("如欲索取正本，您或獲授權人士可前往" + chi_location + "<br /><br />");
		content.append("如有任何查詢，請致電：<br />");
		content.append("電話：" + phone + "（香港）<br />");
		content.append("辦公時間：星期一至日，上午 9 時至下午 9 時<br /><br />");
		content.append("感謝選用本院服務。<br /><br />");
		content.append("====<br /><br />");
		content.append("此電子郵件消息（包括附件）中包含的信息可機密和/或法律的特權。 如閣下並非準收件人，則不得閱讀、複製或向任何人披露該消息或該消息中包含的任何信息。若錯誤收到此訊息，請立即通知寄件人，並從您的所有系統中刪除訊息。");
		
		content.append("<br /><br /><br />");
			
		content.append("Dear Sir / Madam,<br /><br />");
//		content.append("<b>Password: your YEAR of BIRTH (e.g If your birthday is 19/10/1958, the password is 1958)</b><br /><br />");
//		content.append("The password above is for opening the attached documents.<br /><br />");
		content.append("The attached file is password protected. The default password is the patient's year of birth in 4 digits.<br /><br />");
		content.append("If you wish to acquire a hard copy, you or an authorized person may collect them from " + eng_location + "<br /><br />");
		content.append("Should you have any inquiries, please call:<br />");
		content.append("T: " + phone + " (HK)<br />");
		content.append("Business hours: Mon to Sun, 9 am - 9 pm<br /><br />");
		content.append("Thank you for your attention.<br /><br />");
		content.append("====<br /><br />");
		content.append("This email and any attachments are confidential and may also be privileged. If you are not the intended recipient, you may not use, copy or disclose to anyone the message or any information contained in the message. If you have received the message in error, please advise the sender by reply e-mail and delete the message immediately.");
		
		return content.toString();
	}
		
	// ======================================================================
	private static String getMaskedNum(String num) {
		int maskedLen = 3;
		String maskChar = "X";
		int index = num.length() - maskedLen;
		String markedNum = "";
		
		if (num.length() <= maskedLen)
			return num;
		
		for (int i = 0; i < index; i++) {
			markedNum += maskChar;
		}
		
		return markedNum + num.substring(index);
	}	
	
	// ======================================================================
	private static boolean updateReportLog(String labnum, String testcat, String logid) {
		StringBuffer sqlStr = new StringBuffer();
		String cert = null;
		
		if ("1".equals(testcat))
			cert = "COVGQ";
		else if ("M".equals(testcat))
			cert = "HC";

		sqlStr.append("UPDATE LABO_REPORT_LOG@LIS ");
		sqlStr.append(" SET PAT_EMAIL_LOG_ID = ?, ");
		sqlStr.append(" PAT_NOTIFY_DATE = SYSDATE ");
		sqlStr.append(" WHERE LAB_NUM = ? ");
		sqlStr.append(" AND TEST_CAT in (?, ?)");

		return UtilDBWeb.updateQueue(sqlStr.toString(), new String[] { logid, labnum, testcat, cert });
	}
	
	// ======================================================================	
	private static String getSysParam(String key){
		
		String value = null;
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select PARAM1 from sysparam where parcde=?");
		
		try {		
			ArrayList<ReportableListObject> record = UtilDBWeb.getReportableListHATS(sqlStr.toString(), new String[] {key});
			ReportableListObject row = null;

			if (record.size() > 0) {
				row = (ReportableListObject) record.get(0);
				value = row.getValue(0);
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.out.println("[NotifyPatientCOVID] DEBUG: " + sqlStr.toString() + " parcde=" + key);
			e.printStackTrace();
		}
		
        return value;
	}
	
	// ======================================================================			
	private static String[] getBccEmail(String type) {
		
		String email = null;
		
		if ("AMC2".equals(type)) 
			email = getSysParam("COVBCCAMC2");
		else
			email = getSysParam("COVBCC");
	
		String[] emailArray = email.split(";");
		emailArray = (String[]) ArrayUtils.removeElement(emailArray, "");
				
		return emailArray;
	}
	
	// ======================================================================			
	private static String[] getAdminEmail() {
		
		String email = null;
		
		email = getSysParam("COVERR");
	
		String[] emailArray = email.split(";");
		emailArray = (String[]) ArrayUtils.removeElement(emailArray, "");
				
		return emailArray;
	}
	
	// ======================================================================	
	private static String getPasswd(){
		
		return "1234hkah";
	}
	
	// ======================================================================	
	private static String getPasswd(String labnum){
		
		String passwd = null;
		
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("select to_char(birth_date, 'yyyy') ");
		sqlStr.append(" from labo_masthead@LIS ");
		sqlStr.append(" where lab_num = ? ");

		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {labnum});
		ReportableListObject row = null;

		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			
			passwd = row.getValue(0);
		}
        
        return passwd;
	}	
	
	// ======================================================================	
    private static void copyFileUsingFileStreams(SmbFile source, File dest) throws IOException {
    	SmbFileInputStream input = null;
        OutputStream output = null;
        
        input = new SmbFileInputStream(source);
        output = new FileOutputStream(dest);
       
        byte[] buf = new byte[1024];
        int bytesRead;
       
        while ((bytesRead = input.read(buf)) > 0) {
    	   output.write(buf, 0, bytesRead);
        }
       
        input.close();
        output.close();
    }
}
