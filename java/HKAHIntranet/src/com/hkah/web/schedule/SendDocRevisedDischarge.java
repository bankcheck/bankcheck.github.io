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

public class SendDocRevisedDischarge implements Job {
	
	static String MaxAttach = getSysParam("MaxAttach");
	
	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		System.out.println("===== SendDocRevisedDischarge v1.7 Start =====");
		main();
		System.out.println("===== SendDocRevisedDischarge End =====");
	}

	// ======================================================================
	private static ArrayList<ReportableListObject> getRevisedList() {

		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT DISTINCT DOCCODE, EMAIL ");
		sqlStr.append(" FROM V_FS_DISCHARGE_EMAIL D ");
		sqlStr.append(" WHERE D.PAT_EMAIL_LOG_ID IS NULL ");
		sqlStr.append(" AND EXISTS ");
		sqlStr.append(" (SELECT 1 FROM FS_FILE_INDEX F ");
		sqlStr.append("  WHERE TO_CHAR(F.FS_REGID) = TO_CHAR(D.REGID) AND F.FS_ENABLED = 0 AND F.FS_APPROVED_DATE IS NOT NULL) ");
		
		return UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[] {});
	}	
	
	// ======================================================================
	private static ArrayList<ReportableListObject> getRevisedDischarge(String doccode) {

		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT REPORT_ID, PATNO, REGID, ");
		sqlStr.append(" TO_CHAR(REPORT_DATE,'YYYYMMDDHH24MISS'), SOURCE_PATH, ");
		sqlStr.append(" PATFNAME, PATGNAME, PATCNAME, PATSEX, ");						
		sqlStr.append(" DOCCODE, DOCFNAME, DOCGNAME, EMAIL, ");
		sqlStr.append(" ATTACH_FNAME, ATTACH_PW ");
		sqlStr.append(" FROM V_FS_DISCHARGE_EMAIL D ");		
		sqlStr.append(" WHERE D.PAT_EMAIL_LOG_ID IS NULL ");		
		sqlStr.append(" AND EXISTS ");
		sqlStr.append(" (SELECT 1 FROM FS_FILE_INDEX F ");
		sqlStr.append("  WHERE TO_CHAR(F.FS_REGID) = TO_CHAR(D.REGID) AND F.FS_ENABLED = 0 AND F.FS_APPROVED_DATE IS NOT NULL) ");
		sqlStr.append(" AND D.DOCCODE = ? ");
		
		return UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[] { doccode });
	}
	
	// ======================================================================
	public static ArrayList<ReportableListObject> getSingleDischarge(String rptId) {

		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT REPORT_ID, PATNO, REGID, ");
		sqlStr.append(" TO_CHAR(REPORT_DATE,'YYYYMMDDHH24MISS'), SOURCE_PATH, ");
		sqlStr.append(" PATFNAME, PATGNAME, PATCNAME, PATSEX, ");						
		sqlStr.append(" DOCCODE, DOCFNAME, DOCGNAME, EMAIL, ");
		sqlStr.append(" ATTACH_FNAME, ATTACH_PW ");
		sqlStr.append(" FROM V_FS_DISCHARGE_EMAIL D ");	
		sqlStr.append(" WHERE REPORT_ID = ? ");
		sqlStr.append(" AND EXISTS ");
		sqlStr.append(" (SELECT 1 FROM FS_FILE_INDEX F ");
		sqlStr.append("  WHERE TO_CHAR(F.FS_REGID) = TO_CHAR(D.REGID) AND F.FS_ENABLED = 0 AND F.FS_APPROVED_DATE IS NOT NULL) ");
				
		return UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[] {rptId});
	}	
	
    // ======================================================================
	public static String sendNewDischarge (String doccode, String email) {
		return send(getRevisedDischarge(doccode), email, false);
	}

    // ======================================================================
	public static String sendSingleDischarge (String rptId, String email, boolean debug) {
		return send(getSingleDischarge(rptId), email, debug);
	}
	
	// ======================================================================
	public static void main() {
					    		
		ArrayList<ReportableListObject> record = getRevisedList();
		ReportableListObject row = null;
		
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			
			String doccode = row.getValue(0);
			String email = row.getValue(1);
			try {													
				sendNewDischarge(doccode, email);									
				
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
		String docname = null;
		
		ArrayList<File> attachment = new ArrayList<File>();
		ArrayList<String> filename = new ArrayList<String>();
		
		try {		
			for (int i = 0; i < reportList.size(); i++) {
				ReportableListObject row = (ReportableListObject) reportList.get(i);
				
// REPORT_ID, PATNO, REGID, 
// TO_CHAR(REPORT_DATE,'YYYYMMDDHH24MISS'), SOURCE_PATH, 
// PATFNAME, PATGNAME, PATCNAME, PATSEX,
// DOCCODE, DOCFNAME, DOCGNAME, EMAIL,
// ATTACH_FNAME, ATTACH_PW 				
				
				String rptId = row.getValue(0);
				String patno = row.getValue(1);
				String regid = row.getValue(2);
				String rptDate = row.getValue(3);
				String src = row.getValue(4);
				String patfname = row.getValue(5);
				String patgname = row.getValue(6);
				String patcname = row.getValue(7);
				String patsex = row.getValue(8);
				String doccode = row.getValue(9);
				String docfname = row.getValue(10);
				String docgname = row.getValue(11);

				String fname = row.getValue(13);
				String pw = row.getValue(14);
				
				docname = docfname;
								
//no log and update log id in debug mode				
				if (!debug) {
					email = row.getValue(12);
					
					if (logId == null) {
						logId = UtilMail.insertDMSEmailLog("DOC-RDS", rptId, "FS", 
								patno, patfname, patgname, patcname, patsex,
								doccode, docfname, docgname, regid,
								email, rptDate, src, fname, pw );
					} else {
						UtilMail.attachDMSEmailLog("DOC-RDS", logId, rptId, "FS", 
								patno, patfname, patgname, patcname, patsex, 
								doccode, docfname, docgname, regid, 
								email, rptDate, src, fname, pw);
					}

					updateReportEmailStatus(rptId, logId);
				}
				
				if ( email == null || email.trim().isEmpty() || "NOT PROVIDE".equals(email.trim().toUpperCase()) ) {
					message = "EMAIL NOT PROVIDE";
					if (!debug) {				
						UtilMail.updateDMSEmailLog(logId, message, false);
					}					
					return message;
				}				
				
				String tmpFolder = ConstantsServerSide.TEMP_FOLDER;
				
				String destPath = tmpFolder + "/" + fname;
								
				if (debug)
					System.out.println("[SendDocRevisedDischarge] tmpPath= " + destPath);								
				
				filename.add(fname);	
				attachment.add(pdfAttachment(destPath, src, pw));	
				
				if ( isNum(MaxAttach) && attachment.size() > Integer.valueOf(MaxAttach) ) {					
					sendEmail ( logId, email, attachment, filename, docname );
					logId = null;
					attachment = new ArrayList<File>();
					filename = new ArrayList<String>();
				}				
			}
			
			if (attachment.size() > 0)
				sendEmail ( logId, email, attachment, filename, docname );																
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
								
		return message;
	}
	
	// ======================================================================
	private static String sendEmail ( String logId, String email, ArrayList<File> attachment, ArrayList<String> filename, String docfname ) {
		
		String message = null;
		
		try {
			
			if (attachment.size() > 0) {
				
				String sender = "med.records@hkah.org.hk";
				String subject = "HKAH-SR:  Discharge Summary of Your Patient";
								
				String emailContent = getEmailContent(docfname);
									
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
					if (logId != null)	{			
						UtilMail.updateDMSEmailLog(logId, message, true);			
					}
						
				} else {
					
					message = "Email sent failed";
					if (logId != null) {			
						UtilMail.updateDMSEmailLog(logId, message, false);	
					}
				}
												
			} else {
	//20230516 Add DMS_EMAIL_LOG				
				message = "File attachment error, email not sent";
				if (logId != null) {			
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
	private static boolean isNum(String in) {
		
		try {			
			float num = Integer.valueOf(in);
			
		} catch (Exception e) {
			return false;
		}
		
		return true;		
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
	        
			System.out.println("[SendDocRevisedDischarge] srcPath = " + source + 							
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
	private static String getEmailContent(String docname) {
				
		StringBuffer content = new StringBuffer();
/*		
		content.append("<br /><p style='color:#01A8FF'>****************************************************************");
		content.append("<br /><b>Please do not reply to this computer generated e-mail.</b><br />");
		content.append("****************************************************************</p><br />");
*/
		content.append("<p style='color:#1F497D'>Dear Dr " + docname + "<br /><br />");
		content.append("Attached is/are the <u>revised version</u> of the Discharge Summary(ies) of your patient(s) that you received earlier.<br />");
		content.append("Password is needed to open the file(s).</p>");
		content.append("<span style='color:red'><b>Password:       First 4 characters of your HKID + month that you were born + day that you were born</b></span><br />");
		content.append("For example:  Doctor's HKID A123456(7), Doctor's Date of Birth = Jan 31, 1980<br /><br />");
		content.append("<span style='color:red'><b>Therefore Password should be:     <u>A1230131</u></b></span><br />");
/*		
		content.append("<center><p style='color:#1F497D'><u>DISCLAIMER:</u><br />");
		content.append("Privileged/Confidential Information may be contained in this message.  If you are not the intended recipient, you are notified that any unauthorized copying, dissemination or distribution of the material in this e-mail is strictly prohibited.  If you have received this email in error, please notify the sender immediately and destroy this original message.  Thank you.</p></center>");
*/
		return content.toString();
	}
		
	// ======================================================================
	private static boolean updateReportEmailStatus(String rptId, String logId) {
		StringBuffer sqlStr = new StringBuffer();
		try {				
			
			sqlStr.append("UPDATE fs_file_profile ");
			sqlStr.append(" SET FS_PAT_EMAIL_LOG_ID = ? ");
			sqlStr.append(" WHERE fs_file_index_id  = ? ");
			return UtilDBWeb.updateQueueCIS(sqlStr.toString(), new String[] { logId, rptId });
				
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.out.println("[SendDocRevisedDischarge] DEBUG: " + sqlStr.toString() + " logId=" + logId + " rptId=" + rptId);
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
			System.out.println("[SendDocNewDischarge] DEBUG: " + sqlStr.toString() + " parcde=" + key);
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
