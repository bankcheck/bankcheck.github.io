package com.hkah.web.schedule;

import java.util.ArrayList;

import org.apache.commons.lang.ArrayUtils;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class NotifyBaeExpire implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		System.out.println("===== NotifyBaeExpire v1.8 Start =====");
		main();
		System.out.println("===== NotifyBaeExpire End =====");
	}

	// ======================================================================
	private static ArrayList getList() {

		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT BA_CHECKLIST_ID, BA_BUSINESS_INFO, TO_CHAR(BA_CONTRACT_DATE_TO, 'dd-mm-yyyy'), NVL2(BA_REMINDER1_SENT, '2nd Reminder ', '1st Reminder ') ");
		sqlStr.append(" FROM BA_CHECKLIST ");
		sqlStr.append(" WHERE BA_MODULE_CODE = 'external' ");
		sqlStr.append(" AND BA_ENABLED = 1 ");		
		sqlStr.append(" AND ((BA_REMINDER1_SENT is NULL AND BA_REMINDER1 <= sysdate) ");
		sqlStr.append("  OR (BA_REMINDER2_SENT is NULL AND BA_REMINDER2 <= sysdate)) ");	
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	// ======================================================================	
	public static String[] getEmail(String checklistId) {
			
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT nvl(u.co_email, s.co_email) "); 
		sqlStr.append(" FROM co_staffs s ");
		sqlStr.append(" INNER JOIN ac_function_access a ON s.co_staff_id = A.Ac_Staff_Id ");
		sqlStr.append(" INNER JOIN co_users u ON s.co_staff_id = u.co_staff_id ");
		sqlStr.append(" WHERE a.ac_function_id = 'function.ba.external.list.all' ");
		sqlStr.append(" AND a.ac_enabled = 1 ");
		sqlStr.append(" AND s.co_enabled = 1 ");
		sqlStr.append(" AND u.co_enabled = 1 ");		
		sqlStr.append(" AND s.co_department_code in ( ");
		sqlStr.append("  SELECT TO_CHAR(BA_REQ_DEPARTMENT_CODE) FROM BA_CHECKLIST ");
		sqlStr.append("   WHERE BA_MODULE_CODE = 'external' ");
		sqlStr.append("   AND ba_enabled = 1 ");
		sqlStr.append("   AND (BA_CHECKLIST_ID = ? OR BA_CHECKLIST_PARENT_ID = ?) ");
		sqlStr.append("   UNION SELECT TO_CHAR(BA_RES_DEPARTMENT_CODE) from BA_CHECKLIST ");
		sqlStr.append("   WHERE BA_MODULE_CODE = 'external' ");
		sqlStr.append("   AND ba_enabled = 1 ");
		sqlStr.append("   AND BA_CHECKLIST_ID = ? ) ");		
		sqlStr.append(" UNION SELECT nvl(u.co_email, s.co_email) "); 
		sqlStr.append(" FROM co_staffs s ");
		sqlStr.append(" INNER JOIN co_users u ON s.co_staff_id = u.co_staff_id ");
		sqlStr.append(" LEFT OUTER JOIN co_staff_departments d on s.co_staff_id = d.co_Staff_Id ");
		sqlStr.append(" WHERE s.co_staff_id in ( ");
		sqlStr.append("  select ac_staff_id from ac_function_access where ac_function_id like 'function.ba.external.%' and ac_enabled = 1 ");
		sqlStr.append("   union select g.ac_staff_id from ac_user_groups g inner join ac_function_access f on g.ac_group_id = f.ac_group_id ");
		sqlStr.append("   where f.ac_function_id like 'function.ba.external.%' and f.ac_enabled = 1 and  g.ac_enabled = 1 ) ");				
		sqlStr.append(" AND s.co_enabled = 1 ");
		sqlStr.append(" AND u.co_enabled = 1 ");
		sqlStr.append(" AND ( (d.co_department_code in ( ");
		sqlStr.append("  SELECT BA_REQ_DEPARTMENT_CODE FROM BA_CHECKLIST ");
		sqlStr.append("   WHERE BA_MODULE_CODE = 'external' ");
		sqlStr.append("   AND ba_enabled = 1 ");
		sqlStr.append("   AND (BA_CHECKLIST_ID = ? OR BA_CHECKLIST_PARENT_ID = ?) ");
		sqlStr.append("   UNION SELECT BA_RES_DEPARTMENT_CODE from BA_CHECKLIST ");
		sqlStr.append("   WHERE BA_MODULE_CODE = 'external' ");
		sqlStr.append("   AND ba_enabled = 1 ");
		sqlStr.append("   AND BA_CHECKLIST_ID = ? ) AND d.co_enabled = 1 ) ");	
		sqlStr.append("  OR s.co_department_code in ( ");
		sqlStr.append("  SELECT BA_REQ_DEPARTMENT_CODE FROM BA_CHECKLIST ");
		sqlStr.append("   WHERE BA_MODULE_CODE = 'external' ");
		sqlStr.append("   AND ba_enabled = 1 ");
		sqlStr.append("   AND (BA_CHECKLIST_ID = ? OR BA_CHECKLIST_PARENT_ID = ?) ");
		sqlStr.append("   UNION SELECT BA_RES_DEPARTMENT_CODE from BA_CHECKLIST ");
		sqlStr.append("   WHERE BA_MODULE_CODE = 'external' ");
		sqlStr.append("   AND ba_enabled = 1 ");
		sqlStr.append("   AND BA_CHECKLIST_ID = ? )) ");	
		
		ArrayList record =  UtilDBWeb.getReportableList(sqlStr.toString(),
			new String[] { checklistId, checklistId, checklistId, checklistId, checklistId, checklistId, checklistId, checklistId, checklistId } );
			
		String email[]=new String[record.size()];
	
		for (int i = 0; i < record.size(); i++) {
			ReportableListObject row = (ReportableListObject) record.get(i);
			email[i] = row.getValue(0);
		}
			
		return email;
	}
	
	// ======================================================================
	public static boolean sendEmail( String checklistId, String detail, String expDate, String reminder ) {
		
		String[] email = getEmail(checklistId);
		
		String site = ConstantsServerSide.SITE_CODE;
		
		String emailFrom = "it-admin@hkah.org.hk";
		if ("twah".equals(site)) 
			emailFrom = "alert@twah.org.hk";
		
		String subject = reminder + "Alert Message for Contract Expiry";
		
		String content = "This message is auto generated from Hong Kong Adventist Hospital-Stubbs Road.<br/>" +
			"Please do not reply to this email address.<br/><br/>" +
			"*Contract will be expired*<br/><br/>" +
			"Contract Content: " + detail + " will be expired on " + expDate + ". Please review and update the system.";
		
		if ("twah".equals(site)) 
			content = "This message is auto generated from Hong Kong Adventist Hospital-Tsuen Wan.<br/>" +
				"Please do not reply to this email address.<br/><br/>" +
				"*Contract will be expired*<br/><br/>" +
				"Contract Content: " + detail + " will be expired on " + expDate + ". Please review and update the system.";
																	
		return UtilMail.sendMail(emailFrom, email, subject, content); 												
	}	

	// ======================================================================	
	public static void main() {
					    		
		ArrayList<ReportableListObject> record = getList();
		ReportableListObject row = null;
		
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			
			String checklistId = row.getValue(0);
			String detail = row.getValue(1);
			String expDate = row.getValue(2);
			String reminder = row.getValue(3);
			
			try {
													
				if (sendEmail( checklistId, detail, expDate, reminder )) {
					updateReminderSent(checklistId);
					UtilMail.insertEmailLog(null, checklistId, "AUTO_EMAIL", "bae.reminder", true, "");
				} else {
					String error = "checklistId: " + checklistId;
					System.out.println("[NotifyBaeExpire] send mail error, " + error);
					UtilMail.insertEmailLog(null, checklistId, "AUTO_EMAIL", "bae.reminder", false, error);
				}					
				
			} catch (Exception e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
				
		}

	}
			
	// ======================================================================
	private static void updateReminderSent(String checklistId) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("UPDATE BA_CHECKLIST ");
		sqlStr.append(" SET BA_REMINDER2_SENT = SYSDATE ");
		sqlStr.append(" WHERE BA_MODULE_CODE = 'external' ");
		sqlStr.append(" AND BA_REMINDER1_SENT is NOT NULL ");
		sqlStr.append(" AND BA_REMINDER2_SENT is NULL ");
		sqlStr.append(" AND BA_REMINDER2 <= sysdate ");		
		sqlStr.append(" AND BA_CHECKLIST_ID = ? ");
		UtilDBWeb.updateQueue(sqlStr.toString(), new String[] { checklistId });

		sqlStr = new StringBuffer();
		
		sqlStr.append("UPDATE BA_CHECKLIST ");
		sqlStr.append(" SET BA_REMINDER1_SENT = SYSDATE ");
		sqlStr.append(" WHERE BA_MODULE_CODE = 'external' ");
		sqlStr.append(" AND BA_REMINDER1_SENT is NULL ");
		sqlStr.append(" AND BA_REMINDER1 <= sysdate ");		
		sqlStr.append(" AND BA_CHECKLIST_ID = ? ");
		UtilDBWeb.updateQueue(sqlStr.toString(), new String[] { checklistId });			
	}
	
}
