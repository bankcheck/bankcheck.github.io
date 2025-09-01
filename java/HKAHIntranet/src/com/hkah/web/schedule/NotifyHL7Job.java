package com.hkah.web.schedule;

import java.util.ArrayList;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.EmailAlertDB;

public class NotifyHL7Job implements Job {

	// ======================================================================
	private static String sqlStr_getLastEmailRecord = null;
	private static String sqlStr_insertEmailRecord = null;
	private static final String dblink = ConstantsServerSide.DEBUG ? "@iweb_uat" : "@iweb";

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		String lastEmailDate = "";
		String seqPueID = getHueID();
		
		ArrayList<ReportableListObject> lastEmailRecord = UtilDBWeb.getReportableList(sqlStr_getLastEmailRecord);
		if (lastEmailRecord.size() > 0) {
			ReportableListObject lastEmailRow = (ReportableListObject)lastEmailRecord.get(0);
			lastEmailDate = lastEmailRow.getValue(1);
		}
		UtilDBWeb.updateQueue(sqlStr_insertEmailRecord,new String[] { seqPueID }); 

		ArrayList<ReportableListObject> hl7UpdateRecord = getOutStandingHL7Header(lastEmailDate);
		if (hl7UpdateRecord.size() > 0) {
			String title = (ConstantsServerSide.DEBUG ? "[UAT-HKAH] " : "") + "HL7 Header Update";
			StringBuffer content = new StringBuffer();
			 if (ConstantsServerSide.DEBUG) {
				 content.append("<p><b>[UAT-HKAH]</b><br />");
			 }
			 content.append("<table style='border-collapse: collapse;' border=1>");
			 content.append("	<tr>");
			 content.append("		<td>MESSAGE_ID</td>");
			 content.append("		<td>RECV_APP</td>");
			 content.append("		<td>EVENT</td>");
			 content.append("		<td>MESSAGE_DATE</td>");
			 content.append("		<td>STATUS</td>");
			 content.append("	</tr>");

			for (int i = 0; i < hl7UpdateRecord.size(); i++) {
				ReportableListObject hl7UpdateRow = (ReportableListObject) hl7UpdateRecord.get(i);				
				 content.append("	<tr>");
				 content.append("		<td>" + hl7UpdateRow.getValue(0) + "</td>");
				 content.append("		<td>" + hl7UpdateRow.getValue(1) + "</td>");
				 content.append("		<td>" + hl7UpdateRow.getValue(2) + "</td>");
				 content.append("		<td>" + hl7UpdateRow.getValue(3) + "</td>");
				 content.append("		<td>" + hl7UpdateRow.getValue(4) + "</td>");
				 content.append("	</tr>");			
				 
			}
			 content.append("</table>");
			 boolean emailSuccess = EmailAlertDB.sendEmail("hl7.update", title, content.toString());					 
			 //boolean emailSuccess = UtilMail.sendMail(ConstantsServerSide.MAIL_ALERT, "nfsit1988@gmail.com", title, content.toString());
		}
	}

	public static ArrayList getOutStandingHL7Header(String lastEmailDate) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT MESSAGE_ID, RECV_APP, EVENT, TO_CHAR(MESSAGE_DATE, 'DD/MM/YYYY hh24:mi'), STATUS FROM HL7_HEADER@HL7_TWAH ");
		if(lastEmailDate != null && lastEmailDate.length() > 0 ) {
			sqlStr.append(" WHERE      MESSAGE_DATE <= TO_DATE('" + lastEmailDate + "','DD/MM/YYYY hh24:mi:ss') - 10/(24*60) ");
			sqlStr.append(" AND        MESSAGE_DATE >= TO_DATE('" + lastEmailDate + "','DD/MM/YYYY hh24:mi:ss') - 15/(24*60) ");
			sqlStr.append(" AND        STATUS = 'R' ");
		}
		sqlStr.append(" ORDER BY  MESSAGE_DATE DESC ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private static String getHueID() {
		String hueID = null;

		// get next schedule id from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(HL7_HUEID) + 1 FROM HL7_UPDATE_EMAIL");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			hueID = reportableListObject.getValue(0);

			// set 1 for initial
			if (hueID == null || hueID.length() == 0) return "1";
		}
		return hueID;
	}

	static {
		StringBuffer sqlStr = new StringBuffer();
			
		sqlStr.setLength(0);
		sqlStr.append(" select   HL7_HUEID, TO_CHAR(HL7_LASTEMAILSEND_DATE , 'dd/MM/yyyy hh24:mi:ss') ");
		sqlStr.append(" FROM     HL7_UPDATE_EMAIL ");
		sqlStr.append(" WHERE    HL7_ENABLED = '1' ");
		sqlStr.append(" ORDER BY HL7_HUEID DESC ");	
		sqlStr_getLastEmailRecord = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO HL7_UPDATE_EMAIL (");
		sqlStr.append("HL7_HUEID)");
		sqlStr.append("VALUES (?) ");
		sqlStr_insertEmailRecord = sqlStr.toString();

	}
}