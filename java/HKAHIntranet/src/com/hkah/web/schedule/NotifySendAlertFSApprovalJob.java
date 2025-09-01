package com.hkah.web.schedule;

import java.util.ArrayList;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.FsDB;

public class NotifySendAlertFSApprovalJob implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		StringBuffer sqlStr = new StringBuffer();

		String reqNo = null;
		String sendApproval = null;
		String reqBy = null;		
		String reqStatus = null;
//		String servDate = null;
//		String servTime = null;	
		String secretaryOf = null;
		String getResendList_sqlStr = null;
		String updateSendFlag_sqlStr = null;

		ArrayList<ReportableListObject> resentList_ArrayList = null;
		ReportableListObject reportableListObject = null;		

		sqlStr.setLength(0);
		sqlStr.append("SELECT FR.REQ_NO, FR.REQ_STATUS, FR.REQ_BY, FR.SEND_APPROVAL, TO_CHAR(FR.SERV_DATE_START,'DD/MM/YYYY') SERV_DATE, TO_CHAR(FR.SERV_DATE_START,'HH24:MI') AS SERV_TIME, ");
		sqlStr.append("(SELECT CU.CO_EMAIL ");
		sqlStr.append("FROM CO_USERS CU, CO_STAFFS CS ");
		sqlStr.append("WHERE CU.CO_STAFF_ID = CS.CO_STAFF_ID ");
		sqlStr.append("AND (CU.CO_USERNAME = FR.SEND_APPROVAL OR ");
		sqlStr.append("CS.CO_STAFF_ID = FR.SEND_APPROVAL)) AS EMAIL ");
		sqlStr.append("FROM FS_REQUEST FR ");
		sqlStr.append("WHERE FR.REQ_STATUS ='S' ");
		sqlStr.append("AND TRUNC(FR.SERV_DATE_START,'DD')-TRUNC(SYSDATE,'DD')<=3 ");
		sqlStr.append("AND FR.SEND_COUNT <= 1 ");
		sqlStr.append("ORDER BY 1 DESC ");
		getResendList_sqlStr = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("update FS_REQUEST ");
		sqlStr.append("set ALERT_MAIL_DATE=SYSDATE,");
		sqlStr.append("SEND_COUNT = SEND_COUNT+1 ");
		sqlStr.append("where REQ_NO = ? ");
		updateSendFlag_sqlStr = sqlStr.toString();
		
		// Get resend list
		resentList_ArrayList = UtilDBWeb.getReportableList(getResendList_sqlStr);
		for (int i = 0; i < resentList_ArrayList.size(); i++) {
			reportableListObject = (ReportableListObject) resentList_ArrayList.get(i);
			reqNo = reportableListObject.getFields0();
			reqBy = reportableListObject.getFields1();
			reqStatus = reportableListObject.getFields2();
			sendApproval = reportableListObject.getFields3();
//			servDate = reportableListObject.getFields4();
//			servTime = reportableListObject.getFields5();
			if(sendApproval!=null && sendApproval.length()>0){
				secretaryOf = FsDB.checkSecretaryOf(sendApproval,"HKAH");
			}			
						
			if(FsDB.sendEmail(reqNo, null, reqBy, sendApproval, null, reqStatus, null, "E", "1")){
				secretaryOf = FsDB.checkSecretaryOf(sendApproval,"HKAH");
				if(FsDB.sendEmail(reqNo, reqBy, reqBy, secretaryOf, null, "S", null, "2", "3")){
					System.err.println("mail sent to secretary success");							
				}else{
					System.err.println("mail sent to secretary failed(Counter Sent Mail)");		
				}
				
					UtilDBWeb.updateQueue(updateSendFlag_sqlStr, new String[] { reqNo });				
			}
		}
	}
}