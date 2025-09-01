package com.hkah.web.schedule;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Locale;

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

public class NotifyNotificationFail implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		System.out.println("[NotifyNotificationFail] ===== Start =====");
		sendNotification();
		System.out.println("[NotifyNotificationFail] ===== End =====");
	}

	// ======================================================================
	private static ArrayList getList() {

		StringBuffer sqlStr = new StringBuffer();
		ArrayList record = null;
		
		sqlStr.append("SELECT m.hospnum, m.patient, M.LOCATION, ");
		sqlStr.append(" to_char(r.rpt_date, 'dd/mm/yyyy hh24:mi:ss') rpt_date, ");
		sqlStr.append(" decode(msg_lang, 'ENG', 'SMS-ENGLISH', 'UTF8', 'SMS-CHINESE', 'SMS') msgtype, ");
		sqlStr.append(" nvl2(s.rev_mobile, s.rev_operator || ': (' || s.rev_area_code || ') ' || s.rev_mobile, NVL2(P.PATPAGER, '(' || NVL(PE.PATPGRCOUCODE, P.COUCODE) || ') ' || P.PATPAGER, 'NO PHONE NUMBER') ), ");
		sqlStr.append(" decode(r.pat_notify_status, 'R', 'Ready', s.res_msg ), ");
		sqlStr.append(" to_char(s.send_time, 'dd/mm/yyyy hh24:mi:ss') send_time, m.lab_num ");
		sqlStr.append(" FROM labo_masthead@lis m ");
		sqlStr.append(" JOIN labo_detail@lis d on m.lab_num = d.lab_num and d.test_num in ('SARS', 'HC', 'XSAR') ");
		sqlStr.append(" JOIN LABO_REPORT_LOG@LIS r on m.lab_num = r.lab_num and r.test_cat = '1' ");
		sqlStr.append(" JOIN patient@iweb p on m.hospnum = p.patno ");
		sqlStr.append(" JOIN PATIENT_EXTRA@IWEB PE ON P.PATNO = PE.PATNO ");
		sqlStr.append(" LEFT JOIN sms_log s on m.lab_num = s.key_id and s.smcid in ('COVID', 'H1N1') ");
		sqlStr.append(" WHERE M.TYPE = 'O' ");
		sqlStr.append(" AND SYSDATE - R.RPT_DATE <= 1 ");
		sqlStr.append(" AND (s.success is null or s.success <> 1) AND r.pat_notify_status <> 'R' ");
		sqlStr.append(" UNION ");
		sqlStr.append("SELECT m.hospnum, m.patient, M.LOCATION, ");
		sqlStr.append(" to_char(r.rpt_date, 'dd/mm/yyyy hh24:mi:ss') rpt_date, ");
		sqlStr.append(" 'EMAIL' msgtype, ");
		sqlStr.append(" NVL(p.patemail, 'NO EMAIL ADDRESS'), ");
		sqlStr.append(" decode(r.pat_notify_status, 'R', 'Ready', decode (e.success, 1, 'SUCCESS', 'Failed ' || e.ERROR_MSG) ), ");
		sqlStr.append(" to_char(e.send_time, 'dd/mm/yyyy hh24:mi:ss') send_time, m.lab_num ");
		sqlStr.append(" FROM labo_masthead@lis m ");
		sqlStr.append(" JOIN labo_detail@lis d on m.lab_num = d.lab_num and d.test_num in ('SARS', 'HC', 'XSAR') ");
		sqlStr.append(" JOIN LABO_REPORT_LOG@LIS r on m.lab_num = r.lab_num and r.test_cat = '1' ");
		sqlStr.append(" JOIN patient@iweb p on m.hospnum = p.patno ");
		sqlStr.append(" LEFT JOIN email_log e on r.lab_num = e.key_id and e.mail_type in ('COVID', 'H1N1') ");
		sqlStr.append(" WHERE M.TYPE = 'O' ");
		sqlStr.append(" AND SYSDATE - R.RPT_DATE <= 1 ");
		sqlStr.append(" AND (e.success is null or e.success <> 1)  AND r.pat_email_status <> 'R' ");
		sqlStr.append(" ORDER BY LOCATION, RPT_DATE desc, lab_num, msgtype ");
					
		try {
			record = UtilDBWeb.getReportableList(sqlStr.toString());
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.out.println("[NotifyNotificationFail] DEBUG: " + sqlStr.toString());
			e.printStackTrace();
		}
		
		return record;
	}

	// ======================================================================
	
	public static void sendNotification() {
		// get current day
		Calendar currentCal = Calendar.getInstance();
		boolean debug = false;

		ArrayList record = getList();
		
		if (record.size() > 0) {
			
			String emailContent = "<table border=1><tr><th>PATNO</th><th>NAME</th><th>LOCATION</th><th>REPORT TIME</th>"
					+ "<th>MESSAGE TYPE</th><th>DESTINATION</th><th>STATUS</th><th>SEND TIME</th><th>LABNUM</th></tr>";
			
			for (int i = 0; i < record.size(); i++) {
				ReportableListObject row = (ReportableListObject) record.get(i);

				String patno = row.getValue(0);
				String name = row.getValue(1);
				String location = row.getValue(2);
				String rptTime = row.getValue(3);
				String type = row.getValue(4);
				String destination = row.getValue(5);
				String status = row.getValue(6);
				String sendTime = row.getValue(7);
				String labnum = row.getValue(8);
				
				emailContent = emailContent + "<tr><td>" + 
						patno + "</td><td>" +
						name + "</td><td>" +
						location + "</td><td>" +
						rptTime + "</td><td>" +
						type + "</td><td>" +
						destination + "</td><td>" +
						status + "</td><td>" +
						sendTime + "</td><td>" +
						labnum + "</td></tr>";
				
			}
			
			emailContent = emailContent + "</table><br/>Total=" + record.size();
			
			String emailFrom = "it-admin@hkah.org.hk";
			String subject = "HKAH-SR: Patient Notification Failed";
			
			boolean success = UtilMail.sendMail(emailFrom, getEmailTo(), subject, emailContent); 						
		}
	}
	
// ======================================================================	
	
	public static String[] getEmailTo() {
			
		String email = null;
		String[] emailArray = null;

		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT PARAM1 FROM SYSPARAM@IWEB where PARCDE = 'ERRSMSMAIL' ");
		
		try {		
			ArrayList result =  UtilDBWeb.getReportableList(sqlStr.toString());
	
			if (result.size() > 0) {
				ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
				email = reportableListObject.getValue(0);
			}
			
			emailArray = email.split(";");
			emailArray = (String[]) ArrayUtils.removeElement(emailArray, "");
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.out.println("[NotifyNotificationFail] DEBUG: " + sqlStr.toString());
			e.printStackTrace();
		}
		
		return emailArray;
	}

}