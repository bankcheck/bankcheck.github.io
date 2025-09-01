package com.hkah.web.schedule;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;


import jcifs.smb.NtlmPasswordAuthentication;
import jcifs.smb.SmbFile;
import jcifs.smb.SmbFileInputStream;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.encryption.AccessPermission;
import org.apache.pdfbox.pdmodel.encryption.StandardProtectionPolicy;

public class SendPatientReport implements Job {

	private static String daysAgo = "7"; 
	private static String sqlStr_getRpt = null;
	
	static {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT REPORT_ID, REPORT_TYPE, PATNO, PATFNAME, PATGNAME, PATCNAME, PATSEX, ");
		sqlStr.append(" TO_CHAR(REPORT_DATE,'YYYYMMDDHH24MISS'), SOURCE_PATH, ATTACH_FNAME, ATTACH_PW, ");
		sqlStr.append(" PATEMAIL, ENCRYPT_TYPE, ENCRYPT_PW ");
		sqlStr.append(" FROM V_DMS_EMAIL_PENDING ");
		sqlStr_getRpt = sqlStr.toString();
	}
	
	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		System.out.println("===== SendPatientReport v1 Start =====");
		main();
		System.out.println("===== SendPatientReport End =====");
	}

	// ======================================================================
	private static ArrayList<ReportableListObject> getList() {

		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT DISTINCT PATNO, PATEMAIL ");
		sqlStr.append(" FROM V_DMS_EMAIL_PENDING ");
		sqlStr.append(" WHERE PAT_EMAIL_LOG_ID IS NULL ");
		sqlStr.append(" AND REPORT_DATE < SYSDATE - ? ");
		
		return UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[] {daysAgo});
	}	
	
	// ======================================================================
	private static ArrayList<ReportableListObject> getOutstandingReports(String patno, String email) {

		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append(sqlStr_getRpt);
		sqlStr.append(" WHERE PAT_EMAIL_LOG_ID IS NULL ");
		sqlStr.append(" AND REPORT_DATE < SYSDATE - ? ");
		sqlStr.append(" AND PATNO = ? ");
		sqlStr.append(" AND PATEMAIL = ? ");
		
		return UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[] {daysAgo, patno, email});
	}
	
	// ======================================================================
	public static ArrayList<ReportableListObject> getSingleReport(String rptId, String rptType) {

		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append(sqlStr_getRpt);
		sqlStr.append(" WHERE REPORT_ID = ? ");
		sqlStr.append(" AND REPORT_TYPE = ? ");
				
		return UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[] {rptId, rptType});
	}	
	
    // ======================================================================
	public static String sendOutstanding (String patno, String email) {
		return send(getOutstandingReports(patno, email), email, false);
	}

    // ======================================================================
	public static String sendSingleReport (String rptId, String rptType, String email, boolean debug) {
		return send(getSingleReport(rptId, rptType), email, debug);
	}
	
	// ======================================================================
	public static void main() {
					    		
		ArrayList<ReportableListObject> record = getList();
		ReportableListObject row = null;
		
		String summary = null;
		
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			
			String patno = row.getValue(0);
			String email = row.getValue(1);
			try {													
				sendOutstanding(patno, email);									
				
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}				
		}
	}
	
	// ======================================================================
	private static String send (ArrayList<ReportableListObject> reportList, String email, boolean debug ) {
		
		String message = "";
		String logId = null;
		
		ArrayList<File> attachment = new ArrayList<File>();
		ArrayList<String> filename = new ArrayList<String>();
		
		try {		
			for (int i = 0; i < reportList.size(); i++) {
				ReportableListObject row = (ReportableListObject) reportList.get(i);
				
//REPORT_ID, REPORT_TYPE, PATNO, PATFNAME, PATGNAME, PATCNAME, PATSEX, TO_CHAR(REPORT_DATE,'YYYYMMDDHH24MISS'), SOURCE_PATH, ATTACH_FNAME, ATTACH_PW		
				String rptId = row.getValue(0);
				String rptType = row.getValue(1);
				String patno = row.getValue(2);
				String patfname = row.getValue(3);
				String patgname = row.getValue(4);
				String patcname = row.getValue(5);
				String patsex = row.getValue(6);						
				String rptDate = row.getValue(7);
				String src = row.getValue(8);
				String fname = row.getValue(9);
				String pw = row.getValue(10);
				
				if (src.contains(".")) {
					String ext = src.substring(src.lastIndexOf("."));
					fname =  fname + ext;
				}
								
				if (!debug) {
					if (i == 0) {
						logId = UtilMail.insertPatDMSEmailLog(rptId, rptType, 
							patno, patfname, patgname, patcname, 
							patsex, email, rptDate, src,     
							fname, pw);
					} else {
						UtilMail.attachDMSEmailLog("PAT", logId, rptId, rptType, 
								patno, patfname, patgname, patcname, patsex, 
								null, null, null, null, 
								email, rptDate, src, fname, pw);
					}

					updateReportEmailStatus(rptId, rptType, logId);
				}
				
				if ( email == null || email.trim().isEmpty() ) {
					message = "No email address";	
					if (!debug) {				
						UtilMail.updateDMSEmailLog(logId, message, false);
					}					
					return message;
				}
				
				if ( email != null && "NOT PROVIDE".equals(email.trim().toUpperCase()) ) {	
					message = "EMAIL NOT PROVIDE";
					if (!debug) {					
						UtilMail.updateDMSEmailLog(logId, message, false);
					}					
					return message;
				}
				
				String tmpFolder = ConstantsServerSide.TEMP_FOLDER;
				
				String destPath = tmpFolder + "/" + fname;
								
				if (debug)
					System.out.println("[SendPatientReport] tmpPath= " + destPath);								
				
				filename.add(fname);	
				attachment.add(pdfAttachment(destPath, src, pw));							
			}
			
			if (attachment.size() > 0) {
				
				String site = ConstantsServerSide.SITE_CODE;
				String sender = "client.report@hkah.org.hk";
				String subject = null;
				
				if ("hkah".equals(site)) {
					subject = "Test Report from Hong Kong Adventist Hospital – Stubbs Road";
				} else {
					subject = "Test Report from Hong Kong Adventist Hospital";
				}
								
				String emailContent = getEmailContent(site);
									
				if (UtilMail.sendMail2(
						sender,
						new String[] { email },
						null, null,
						subject,
						emailContent, 
						attachment.toArray(new File[attachment.size()]),
						filename.toArray(new String[filename.size()]), 
						false)) {
					
					message =  "Email sent successfully";
					if (!debug)	{			
						UtilMail.updateDMSEmailLog(logId, message, true);			
					}
						
				} else {
					
					message = "Email sent failed";
					if (!debug)	{			
						UtilMail.updateDMSEmailLog(logId, message, false);	
					}
				}
/*				
				if (!debug) {
					for (File tmpFile : attachment)
						tmpFile.delete();
				}
*/				
												
			} else {
	//20230516 Add DMS_EMAIL_LOG				
				message = "File attachment error, email not sent";
				if (!debug)	{			
					UtilMail.updateDMSEmailLog(logId, message, false);	
				}						
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
								
		return message;
	}
					
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
	        
			System.out.println("[SendPatientReport] srcPath = " + source + 							
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
	private static String getEmailContent(String site) {
				
		StringBuffer content = new StringBuffer();
		
		String eng_location = null;
		String chi_location = null;
		String pboemail = null;
		String pbophone = null;
		String mrphone = null;
		String mremail = null;
		
		if ("hkah".equals(site)) {
			eng_location = "-Stubbs Road";
			chi_location = "-司徒拨道";
						
			pboemail = "regdesk@hkah.org.hk";
			pbophone = "(852) 3651-8808";
			mremail = "med.records@hkah.org.hk";
			mrphone = "(852) 3651-8809";
		}
		
		content.append("Dear Patient<br /><br />");
		content.append("Thank you for using the Hong Kong Adventist Hospital" + eng_location + " Outpatient Services recently. Please find the report file attached to this email. The file is password-protected.");
		content.append(" To open, please enter your date of birth (DDMMYEAR).");
		content.append(" For example, if the date of birth is 1 February 2000, the password will be 01022000.<br /><br />");
		
		content.append("If you have any clinical inquiries regarding your laboratory or radiology result, please make a consultation appointment with your attending physician by contacting the Patient Business Office – Out-patient Registration.<br />");
		
		if (pboemail != null)
			content.append("Email: <a href='mailto:" + pboemail + "'>" + pboemail + "</a><br />");
		
		if (pbophone != null)
			content.append("Tel: " + pbophone + "<br /><br />");
		
		content.append("If you need, an extra copy of your report, you may contact the Medical Records Department during office hours.  Charges may be applied.<br />");
		
		if (mremail != null)
			content.append("Email: <a href='mailto:" + mremail + "'>" + mremail + "</a><br />");
		
		if (mrphone != null)
			content.append("Tel: " + mrphone + "<br /><br />");
		
		content.append("Medical Records Office Hours:<br />");
		content.append("Monday to Friday: 09:00 to 17:30<br />");
		content.append("Sunday: 09:00 to 13:00<br />");
		content.append("Saturday & Public Holiday: Closed");
		content.append("<br /><br />");
		
		content.append("This email and any attachments are confidential and may also be privileged. If you are not the intended recipient, you may not use, copy or disclose to anyone the message or any information contained in the message. If you have received the message in error, please inform us");

		if (pboemail != null)
			content.append(" by sending email to <a href='mailto:" + pboemail + "'>" + pboemail + "</a>");
		
		content.append(" and delete the message immediately.<br />");
		content.append("****************************************************************<br />");
		content.append("This is a computer generated email. Please do not reply.<br />");
		content.append("****************************************************************<br /><br />");		
		
		content.append("尊敬的病人:<br /><br />");
		content.append("感謝 閣下最近使用香港港安醫院" + chi_location + "門診服務。此電子郵件中附上閣下 的化驗或放射影像檢測報告。該附件受密碼保護。");
		content.append(" 請輸入您的出生日期（日日月月年年年年）以開啟附件。");
		content.append(" 如閣下 的出生日期為2000年2月1日，密碼將是01022000。");
		content.append("<br /><br />");
		
		content.append("在收到報告後，如 閣下對臨床化驗或放射影像檢測結果有任何疑問，請聯絡病人事務部–門診登記處預約 閣下的主診醫生咨詢。<br />");
		
		if (pboemail != null)
			content.append("電郵：<a href='mailto:" + pboemail + "'>" + pboemail + "</a><br />");
		
		if (pbophone != null)
			content.append("電話：" + pbophone + "<br /><br />");
		
		content.append("如 閣下  需要額外的報告副本，可以在辦公時間內聯繫本院的醫療記錄部。本院或會收取行政費用。<br />");
		
		if (mremail != null)
			content.append("電郵：<a href='mailto:" + mremail + "'>" + mremail + "</a><br />");
		
		if (mrphone != null)
			content.append("電話：" + mrphone + "<br /><br />");
		
		content.append("醫療記錄部辦公時間：<br />");
		content.append("星期一至星期五：09:00至17:30<br />");
		content.append("星期日：09:00至13:00<br />");
		content.append("星期六和公眾假期：休息<br /><br />");
		
		content.append("此電子郵件(包括附件）中包含的信息可機密和/或法律的特權。 如閣下並非準收件人，則不得閱讀、複製或向任何人披露該消息或該消息中包含的任何信息。若錯誤收到此訊息，請立即電郵通知本院");

		if (pboemail != null)
			content.append("<a href='mailto:" + pboemail + "'>" + pboemail + "</a>");
		
		content.append("，並從您的所有系統中刪除訊息。<br />");
		content.append("****************************************************************<br />");
		content.append("此郵件由系統自動發出,請勿直接回覆。<br />");
		content.append("****************************************************************<br /><br />");		
							
		return content.toString();
	}
		
	// ======================================================================
	private static boolean updateReportEmailStatus(String rptId, String rptType, String logId) {
		StringBuffer sqlStr = new StringBuffer();
		try {				
			if (rptType.startsWith("LIS-")) {
				String testcat = rptType.substring(4);
				sqlStr.append("UPDATE LABO_REPORT_LOG@LIS ");
				sqlStr.append(" SET PAT_EMAIL_LOG_ID = ?, ");
				sqlStr.append(" PAT_NOTIFY_DATE = SYSDATE ");
				sqlStr.append(" WHERE LAB_NUM = ? ");
				sqlStr.append(" AND TEST_CAT =? ");
				return UtilDBWeb.updateQueue(sqlStr.toString(), new String[] { logId, rptId, testcat });
				
			} else if ("FS".equals(rptType)) {
				sqlStr.append("UPDATE fs_file_profile ");
				sqlStr.append(" SET PAT_EMAIL_LOG_ID = ? ");
				sqlStr.append(" WHERE fs_file_index_id  = ? ");
				return UtilDBWeb.updateQueueCIS(sqlStr.toString(), new String[] { logId, rptId });
				
			} else if ("RIS".equals(rptType)) {
				sqlStr.append("UPDATE dms_pat_rec_ris ");
				sqlStr.append(" SET PAT_EMAIL_LOG_ID = ? ");
				sqlStr.append(" WHERE pagecount = ? ");	
				return UtilDBWeb.updateQueueCIS(sqlStr.toString(), new String[] { logId, rptId });
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.out.println("[SendPatientReport] DEBUG: " + sqlStr.toString() + " logId=" + logId + " rptId=" + rptId);
			e.printStackTrace();
		}
		
		return false;
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
			System.out.println("[SendPatientReport] DEBUG: " + sqlStr.toString() + " parcde=" + key);
			e.printStackTrace();
		}
		
        return value;
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
