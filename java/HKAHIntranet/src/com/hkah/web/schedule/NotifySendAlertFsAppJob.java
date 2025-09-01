package com.hkah.web.schedule;

import java.util.ArrayList;
import java.util.Vector;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.UserDB;

public class NotifySendAlertFsAppJob implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		StringBuffer message = new StringBuffer();
		StringBuffer sqlStr = new StringBuffer();

		String reqNo = null;

		String getReqList_sqlStr = null;
		ArrayList<ReportableListObject> reqList_ArrayList = null;
		ReportableListObject reportableListObject = null;
		String topic = null;
		Vector emailTo = new Vector();
//		String[] emailListToArray = null;
//		String[] mailToCcArray = new String[1];
		String serverSiteCode = ConstantsServerSide.SITE_CODE;
		String approvalStaff = null;

		sqlStr.setLength(0);
		sqlStr.append("SELECT "); 
		sqlStr.append(" REQ_NO, ");
		sqlStr.append(" TO_CHAR(REQ_DATE,'DD/MM/YYYY') AS REQ_DATE, ");		
		sqlStr.append(" REQ_BY, ");
		sqlStr.append(" TO_CHAR(SERV_DATE_START,'DD/MM/YYYY') AS SERV_DATE, ");
		sqlStr.append(" TO_CHAR(SERV_DATE_START,'HH24:MI') AS SERV_START_TIME, ");
		sqlStr.append(" TO_CHAR(SERV_DATE_END,'HH24:MI') AS SERV_END_TIME, ");
		sqlStr.append(" REQ_SITE_CODE, ");
		sqlStr.append(" REQ_DEPT_CODE, ");
		sqlStr.append(" CHARGE_TO, ");
		sqlStr.append(" VENUE_ID, ");
		sqlStr.append(" VENUE, ");
		sqlStr.append(" REQ_STATUS, ");
		sqlStr.append(" PURPOSE, ");
		sqlStr.append(" AMOUNT, ");
		sqlStr.append(" NO_OF_PERSON, ");
		sqlStr.append(" MEAL_TYPE, ");
		sqlStr.append(" MENU, ");
		sqlStr.append(" REMARKS, ");
		sqlStr.append(" SEND_APPROVAL, ");
		sqlStr.append(" INS_BY, ");
		sqlStr.append(" INS_DATE, ");
		sqlStr.append(" MOD_BY, ");
		sqlStr.append(" MOD_DATE, ");
		sqlStr.append(" APPROVE_FLAG, ");
		sqlStr.append(" APPROVED_BY, ");
		sqlStr.append(" APPROVED_DATE, ");
		sqlStr.append(" POST_DATE, ");
		sqlStr.append(" INSTANCE_ID, ");
		sqlStr.append(" PRICE_RANGE, ");
		sqlStr.append(" MEAL_EVENT, ");		
		sqlStr.append(" REQUEST_TYPE ");			
		sqlStr.append("FROM FS_REQUEST ");
		sqlStr.append("WHERE REQ_STATUS = 'S' ");
		sqlStr.append("AND TRUNC(SERV_DATE_START,'HH')-TRUNC(SYSDATE,'HH')<=2 ");
		sqlStr.append("AND TRUNC(SERV_1DATE_START,'HH')-TRUNC(SYSDATE,'HH')>0 ");
		System.err.println(sqlStr.toString());
		sqlStr.append(" ORDER BY REQ_NO ASC");
		getReqList_sqlStr = sqlStr.toString();

		// Get doctor information
		reqList_ArrayList = UtilDBWeb.getReportableList(getReqList_sqlStr);

		for (int i = 0; i < reqList_ArrayList.size(); i++) {
			emailTo = new Vector();
			reportableListObject = (ReportableListObject) reqList_ArrayList.get(i);
			reqNo = reportableListObject.getFields0();
			approvalStaff = reportableListObject.getFields18();

			message.setLength(0);
			System.err.println("[sendEmail][reqNo]:"+reqNo);
			topic = "This email is a gentle reminder for Request NO.: "+reqNo+"; Approval Email";
	
			message.append("<br>This email is a gentle reminder that Department Food Order is waiting for your approval.");
			if ("hkah".equals(serverSiteCode)) {
				message.append("<br>Please click  <a href=\'http://160.100.1.115:8080/intranet/fs/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
				message.append("\'>Intranet</a> or <a href=\'https://mail.hkah.org.hk/intranet/fs/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
				message.append("\'>Offsite</a> to view the detail.");
			} else if ("twah".equals(serverSiteCode)) {
				message.append("<br>Please click  <a href=\'http://192.168.0.20/intranet/fs/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
				message.append("\'>Intranet</a> to view the detail.");
			}

			emailTo.add(UserDB.getUserEmailByUserName(null, approvalStaff));

			// Send mail
			UtilMail.sendMail(
					ConstantsServerSide.MAIL_ALERT,
					(String[]) emailTo.toArray(new String[emailTo.size()]),
					topic,
					message.toString());
			
			// reset values
			emailTo = null;
		}
	}
}