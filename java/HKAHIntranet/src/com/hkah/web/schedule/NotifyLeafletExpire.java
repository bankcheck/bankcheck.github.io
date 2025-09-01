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
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.EmailAlertDB;

public class NotifyLeafletExpire implements Job {
	
	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		System.out.println("[NotifyLeafletExpire] ==== Start ====");
		sendEmail();
		System.out.println("[NotifyLeafletExpire] ==== End ====");
	}

	// ======================================================================
	private static ArrayList getEmailContent(String email) {

		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT ll.loc_code, ll.leaflet_code, lc.loc_name, d.co_description, ");
		sqlStr.append(" to_char(ll.exp_date, 'dd/mm/yyyy'), "); 
		sqlStr.append(" CASE WHEN ll.exp_date < sysdate THEN 'FF0000' "); 
		sqlStr.append(" WHEN MONTHS_BETWEEN(ll.exp_date, sysdate) < 1 THEN 'FFFFFF' "); 
		sqlStr.append(" ELSE '00FF00' END ");
		sqlStr.append("	FROM lm_leaflet ll ");
		sqlStr.append("	join lm_location lc on ll.loc_code = lc.loc_code "); 
		sqlStr.append(" join co_document d on ll.document_id = d.co_document_id "); 
		sqlStr.append(" WHERE ll.enable = 1 "); 
		sqlStr.append(" AND MONTHS_BETWEEN(ll.exp_date, sysdate) < 3 "); 
		sqlStr.append(" AND lc.email like '%" + email + "%' ");
		sqlStr.append(" ORDER BY ll.loc_code, ll.exp_date, ll.leaflet_code ");
				
		return UtilDBWeb.getReportableList( sqlStr.toString() );
	}
	
	public static ArrayList<String> getEmailList() {
				
		ArrayList<String> emailList = new ArrayList<String>();
		
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT email "); 
		sqlStr.append(" FROM lm_location ");
						
		try {		
			ArrayList record =  UtilDBWeb.getReportableList(sqlStr.toString());
	
			for (int i = 0; i < record.size(); i++) {
				ReportableListObject row = (ReportableListObject) record.get(i);

				String email = row.getValue(0);
				String[] emailArray =  email.split(";");
				
				emailArray = (String[]) ArrayUtils.removeElement(emailArray, "");
				
				for (String item : emailArray) 
				{ 
				    if ( !emailList.contains(item.trim()) ) {
				    	emailList.add(item.trim());
				    }
				}
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.out.println("[NotifyLeafletExpire] DEBUG: " + sqlStr.toString());
			e.printStackTrace();
		}
		
		return emailList;
	}
	
	public static void sendEmail() {
		
		try {
		
			ArrayList<String> emailList = getEmailList();
			
			String emailArr[]=emailList.toArray(new String[emailList.size()]);
			
			for ( String email : emailArr ) {
				
				ArrayList record = getEmailContent( email );
				
				ReportableListObject row = null;
				
				if (record.size() > 0) {
					
					String emailContent = "<table border=1><tr><th>LOCATION</th><th>TOPIC</th><th>NEXT REVISION DATE</th></tr>";
					
					for (int i = 0; i < record.size(); i++) {
						row = (ReportableListObject) record.get(i);
	
						String locCode = row.getValue(0);
						String leafletCode = row.getValue(1);
						String locName = row.getValue(2);
						String description = row.getValue(3);
						String expDate = row.getValue(4);
						String color = row.getValue(5);
						
						emailContent = emailContent + "<tr style='color:#" + color + "'>";
						emailContent = emailContent + "<td>" + locName + "</td>";
						emailContent = emailContent + "<td><a href='http://it-s20/intranet/cms/lms_leaflet_entry.jsp?command=edit&locCode=" + locCode + "&leafletCode=" + leafletCode + "'>" + leafletCode + " - " + description + "</a></td>"; 
						emailContent = emailContent + "<td>" + expDate + "</td></tr>";
						
					}
					
					emailContent = emailContent + "</table><br/>Total=" + record.size();
					
					String emailFrom = "alert@twah.org.hk";
					String subject = "Leaflet revision reminder";
					
					boolean success = UtilMail.sendMail(emailFrom, email, subject, emailContent); 				
				}
				
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			System.out.println("[NotifyLeafletExpire] DEBUG: " + e.getMessage());
			e.printStackTrace();
		}					
	}
		
}
