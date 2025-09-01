package com.hkah.web.schedule;

import java.util.ArrayList;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;

public class NotifyDMSError implements Job {
	
	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		System.out.println("[NotifyDMSError] ==== Start ====");
		sendEmail();
		System.out.println("[NotifyDMSError] ==== End ====");
	}

	// ======================================================================
	private static ArrayList<ReportableListObject> getDMSError() {
		
		StringBuffer sqlStr = new StringBuffer();	
		
		sqlStr.append("SELECT FOLDER, FNAME, DOCTYPE, LOG_MESSAGE ");
		sqlStr.append("	FROM dms_pat_rec_mr_errlog ");
		sqlStr.append(" WHERE STATUS = '1' "); 
				
		return UtilDBWeb.getReportableListCIS( sqlStr.toString() );
	}
	
	private static void updateDMSErrorLog(String folder, String fname, String status) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("UPDATE dms_pat_rec_mr_errlog ");
		sqlStr.append(" SET STATUS = ? ");
		sqlStr.append(" WHERE FOLDER = ? ");
		sqlStr.append(" AND FNAME = ? ");
		UtilDBWeb.updateQueue(sqlStr.toString(), new String[] { status, folder, fname });
	}
			
	public static ArrayList<String> getEmailList(String type) {
				
		ArrayList<String> emailList = new ArrayList<String>();
		
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT u.co_email "); 
		sqlStr.append(" FROM co_users u ");
		sqlStr.append(" inner join dms_alert_user d on u.co_username = d.co_staff_id ");
		sqlStr.append(" where u.co_enabled = 1 ");
		sqlStr.append(" and u.co_email is not null ");
		sqlStr.append(" and d.doctype = ? ");
						
		try {		
			ArrayList<ReportableListObject> record =  UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {type});
			
			for (int i = 0; i < record.size(); i++) {
				ReportableListObject row = (ReportableListObject) record.get(i);
				emailList.add(row.getValue(0));				
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.out.println("[NotifyDMSError] DEBUG: " + sqlStr.toString());
			e.printStackTrace();
		}
		
		return emailList;
	}
	
	public static void sendEmail() {
		
		try {
			ArrayList<ReportableListObject> record = getDMSError();
								
			for (int i = 0; i < record.size(); i++) {
				ReportableListObject row = (ReportableListObject) record.get(i);

				String folder = row.getValue(0);
				String fname = row.getValue(1);
				String doctype = row.getValue(2);
				String message = row.getValue(3);
				
				ArrayList<String> emailList = getEmailList(doctype);
				
				if (emailList.size() > 0) {
					String[] email = new String[emailList.size()];
					email = emailList.toArray(email);
				
					String emailFrom = "alert@twah.org.hk";
					String subject = "File name format error";
					
					String emailContent = "Folder: " + folder;
					emailContent = emailContent + "<br>File: " + fname;; 
					emailContent = emailContent + "<br>" + message; 
					
					if (UtilMail.sendMail(emailFrom, email, subject, emailContent)) { 
						updateDMSErrorLog(folder, fname, "2");
						UtilMail.insertEmailLog(null, fname.substring(0, 19), "AUTO_EMAIL", "dms.error", true, "");
					} else {
						updateDMSErrorLog(folder, fname, "3");
						String error = "Folder: " + folder + " Fname: " + fname;
						System.out.println("[NotifyDMSError] send mail error, " + error);
						UtilMail.insertEmailLog(null, fname.substring(0, 19), "AUTO_EMAIL", "dms.error", false, error);
					}	
					
				}				
				
			}								
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.out.println("[NotifyDMSError] DEBUG: " + e.getMessage());
			e.printStackTrace();
		}					
	}
}
