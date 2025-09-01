package com.hkah.web.schedule;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import java.util.ArrayList;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.util.mail.UtilMail;
/*
import java.text.SimpleDateFormat;

import java.util.Calendar;
import java.util.HashMap;
import java.util.Locale;



import com.hkah.constant.ConstantsServerSide;


import com.hkah.util.sms.UtilSMS;

import com.hkah.web.db.EmailAlertDB;
*/

public class NotifyAchiveFail implements Job{
	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		sendEmail();
	}
	
	static String emailMessage = null;
	
	// ======================================================================
	
	public static String getEmailTo() {
		String email = "arran.siu@hkah.org.hk";
		return email;
	}
		
	public static void setMessage(String file_id, String location, String filename, String errorMessage) {
		emailMessage = "<tr><td>" + file_id + "</td><td>" + location + "</td><td>" + filename + "</td><td>" + errorMessage + "</td></tr>";
	}
	
	public static String getMessage() {
		String message = "<b>File Archive Error:</b><br>" + 
				"<table border=1>" +
				"<tr><th align=left>File ID</th><th align=left>Path</th><th align=left>File Name</th><th align=left>Message</th></tr>" +
				emailMessage + "</table>";
		return message;
	}
	
	public static void sendEmail() {
		
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT file_id, ");
		sqlStr.append(" '\\\\' || submit_server || '\\' || submit_folder, ");
		sqlStr.append(" submit_file, ");
		sqlStr.append(" message ");
		sqlStr.append(" FROM file_store ");
		sqlStr.append(" WHERE status = 'E' ");			
		String errorListSQL = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE file_store ");
		sqlStr.append(" set status = 'F' ");
		sqlStr.append(" WHERE file_id = ? "); 
		String updateSQL = sqlStr.toString();
			
		ArrayList errorList = UtilDBWeb.getReportableListCIS(errorListSQL);

		if (errorList.size() > 0) {
			for (int i = 0; i < errorList.size(); i++) {
				
				ReportableListObject row = (ReportableListObject) errorList.get(i);
	
				String fileID = row.getValue(0);
				String filePath = row.getValue(1);
				String filename = row.getValue(2);
				String errorMessage = row.getValue(3);
				
				setMessage(fileID, filePath, filename, errorMessage);
				
				UtilDBWeb.updateQueueCIS(updateSQL,
						new String[] {fileID});
			}
			
			String emailTo = getEmailTo();
			String emailFrom = "it-admin@hkah.org.hk";
			String subject = "[" + ConstantsServerSide.SITE_CODE + "] File Archive Error";
			String message = getMessage();
			
			boolean success = UtilMail.sendMail(emailFrom, emailTo, null, null, subject, message);
		}
		
	}
}
