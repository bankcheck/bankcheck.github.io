package com.hkah.web.schedule;

import java.util.ArrayList;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.EmailAlertDB;

public class NotifySendPRApprovalJob implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		sendWaitingApproval();
		sendApproved();
	}
	
	private void sendWaitingApproval() {
		StringBuffer message = new StringBuffer();
		StringBuffer sqlStr = new StringBuffer();

		String prNo = null;
		String reqBy = null;
		String shippedTo = null;
		String appDate = null;
		String shippedToDeptName = null;
		String area = null;
		String sendApproval = null;

		String getAppList_sqlStr = null;
		String getMailListByDept_sqlStr = null;
		String getMailListSendApproval_sqlStr = null;
		String updateSendFlag_sqlStr = null;
		String getStaffIdByEmailHkah_sqlStr = null;
		String getStaffIdByEmailTwah_sqlStr = null;
		String getStaffNameByIdHkah_sqlStr = null; 
		String getStaffNameByIdTwah_sqlStr = null;

		ArrayList<ReportableListObject> appList_ArrayList = null;
		ArrayList<ReportableListObject> mailList_ArrayList = null;
		ArrayList<ReportableListObject> staffList_ArrayList = null;

		ReportableListObject reportableListObject = null;
		ReportableListObject reportableListObject2 = null;
		ReportableListObject reportableListObject3 = null;
		
		boolean updateRet = false;

		sqlStr.setLength(0);
		sqlStr.append("SELECT ");
		sqlStr.append(" ppm.pur_no,");
		sqlStr.append(" NVL((SELECT sub.user_name ");
		sqlStr.append("  FROM sys_user_basic sub ");
		sqlStr.append("  WHERE sub.user_id = ppm.pur_op),ppm.pur_op) AS req_by,");
		sqlStr.append(" ppm.shipped_to AS shipped_to,");
		sqlStr.append(" ppm.send_approve_date AS app_date,");
		sqlStr.append(" Trim(pd.dept_ename) AS shipped_to_deptName, ");
		sqlStr.append(" pd.area, ");
		sqlStr.append(" ppm.send_approval ");
		sqlStr.append("FROM pms_pur_m ppm, pn_dept pd ");
		sqlStr.append("WHERE ppm.send_approve_flag <> 1 ");
		sqlStr.append("AND pd.dept_id = ppm.shipped_to ");
		sqlStr.append("AND ppm.ppo_id IS NULL ");
		sqlStr.append("AND ppm.cancel_flag = 'N' ");
		sqlStr.append("ORDER BY ppm.pur_dept ASC");
		getAppList_sqlStr = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT DISTINCT pn.email, pn.staff_no ");
		sqlStr.append(" FROM pms_notice_to pn ");
		sqlStr.append(" join pms_pur_m ppm on ppm.send_approval = pn.staff_no ");
		sqlStr.append("WHERE pn.active = 1 AND pn.type ='RA' ");
		sqlStr.append("AND ppm.pur_no = ? ");
		getMailListSendApproval_sqlStr = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT DISTINCT email, staff_no ");
		sqlStr.append(" FROM pms_notice_to ");
		sqlStr.append("WHERE active = 1 AND type ='RA' ");
		sqlStr.append("AND Trim(UPPER(unit)) = Trim(UPPER(?))");
		getMailListByDept_sqlStr = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT co_staff_id, co_firstname||' '||co_lastname ");
		sqlStr.append(" FROM co_users ");
		sqlStr.append("WHERE Trim(UPPER(co_email)) = Trim(UPPER(?))");
		sqlStr.append("and co_staff_id IS NOT NULL");
		getStaffIdByEmailHkah_sqlStr = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT co_staff_id, co_firstname||' '||co_lastname ");
		sqlStr.append(" FROM co_users@twah ");
		sqlStr.append("WHERE Trim(UPPER(co_email)) = Trim(UPPER(?))");
		sqlStr.append("and co_staff_id IS NOT NULL");
		getStaffIdByEmailTwah_sqlStr = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT co_staff_id, co_firstname||' '||co_lastname ");
		sqlStr.append(" FROM co_users ");
		sqlStr.append("WHERE Trim(co_staff_id) = Trim(?)");
		sqlStr.append("and co_staff_id IS NOT NULL");
		getStaffNameByIdHkah_sqlStr = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT co_staff_id, co_firstname||' '||co_lastname ");
		sqlStr.append(" FROM co_users@twah ");
		sqlStr.append("WHERE Trim(co_staff_id) = Trim(?)");
		sqlStr.append("and co_staff_id IS NOT NULL");
		getStaffNameByIdTwah_sqlStr = sqlStr.toString();		

		sqlStr.setLength(0);
		sqlStr.append("update pms_pur_m ");
		sqlStr.append("set send_approve_flag=1,");
		sqlStr.append("send_approve_date=to_char(sysdate,'yyyymmddhh24mi') ");
		sqlStr.append("where TRIM(shipped_to) = TRIM(?) ");
		sqlStr.append("and send_approve_flag=0");
		updateSendFlag_sqlStr = sqlStr.toString();

		// Get approval pr number
		appList_ArrayList = UtilDBWeb.getReportableListTAH(getAppList_sqlStr);
		for (int i = 0; i < appList_ArrayList.size(); i++) {
			reportableListObject = (ReportableListObject) appList_ArrayList.get(i);
			prNo = reportableListObject.getFields0();
			reqBy = reportableListObject.getFields1();
			shippedTo = reportableListObject.getFields2().trim();
			appDate = reportableListObject.getFields3();
			shippedToDeptName = reportableListObject.getFields4();
			area = reportableListObject.getFields5();
			sendApproval = reportableListObject.getFields6();

			String co_staff_id = null;
			String staff_name = null;

			// Get mail list
			String getMailSql = null;
			String[] getMailSqlParam = null;
			if (sendApproval == null || sendApproval.isEmpty()) {
				getMailSql = getMailListByDept_sqlStr;
				getMailSqlParam = new String[]{shippedTo};
			} else {
				getMailSql = getMailListSendApproval_sqlStr;
				getMailSqlParam = new String[]{prNo};
			}
			mailList_ArrayList = UtilDBWeb.getReportableListTAH(getMailSql, getMailSqlParam);
			if (mailList_ArrayList.isEmpty()) {
				EmailAlertDB.sendEmail(
						"pms.admin", 
						"PMS - Cannot find approver email",
						"Cannot find valid approver email in pms_notice_to<br/>" +
						"PR No: " + prNo + ", Send Approval: " + sendApproval + ", Ship To: " + shippedTo);
			}
			for (int k=0 ; k<mailList_ArrayList.size(); k++) {
				reportableListObject2 = (ReportableListObject) mailList_ArrayList.get(k);
				String[] mailToArray = new String[]{reportableListObject2.getFields0()};
//				List<String> mailTo = new ArrayList<String>();
//				mailTo.add(reportableListObject2.getFields0());

				// Get staff name				
				if ("HKAH".equals(area)) {
					staffList_ArrayList = UtilDBWeb.getReportableList(getStaffNameByIdHkah_sqlStr, new String[]{reportableListObject2.getFields1()});
					if (staffList_ArrayList.size() == 0) {
						staffList_ArrayList = UtilDBWeb.getReportableList(getStaffNameByIdTwah_sqlStr, new String[]{reportableListObject2.getFields1()});
						if (staffList_ArrayList.size() == 0) {
							co_staff_id = null;
							staff_name = null;
						} else {
							reportableListObject3 = (ReportableListObject) staffList_ArrayList.get(0);
							co_staff_id = reportableListObject3.getFields0();
							staff_name =  reportableListObject3.getFields1();
						}
					} else {
						reportableListObject3 = (ReportableListObject) staffList_ArrayList.get(0);
						co_staff_id = reportableListObject3.getFields0();
						staff_name =  reportableListObject3.getFields1();
					}
				} else {
					staffList_ArrayList = UtilDBWeb.getReportableList(getStaffNameByIdTwah_sqlStr, new String[]{reportableListObject2.getFields1()});
					if (staffList_ArrayList.size() == 0) {
						staffList_ArrayList = UtilDBWeb.getReportableList(getStaffNameByIdHkah_sqlStr, new String[]{reportableListObject2.getFields1()});
						if (staffList_ArrayList.size() == 0) {
							co_staff_id = null;
							staff_name = null;
						}
					} else {
						reportableListObject3 = (ReportableListObject) staffList_ArrayList.get(0);
						co_staff_id = reportableListObject3.getFields0();
						staff_name =  reportableListObject3.getFields1();
					}
				}				
				
				// Get staff id
/*
				if ("HKAH".equals(area)) {
					staffList_ArrayList = UtilDBWeb.getReportableList(getStaffIdByEmailHkah_sqlStr, new String[]{reportableListObject2.getFields0()});
					if (staffList_ArrayList.size() == 0) {
						staffList_ArrayList = UtilDBWeb.getReportableList(getStaffIdByEmailTwah_sqlStr, new String[]{reportableListObject2.getFields0()});
						if (staffList_ArrayList.size() == 0) {
							co_staff_id = null;
							staff_name = null;
						} else {
							reportableListObject3 = (ReportableListObject) staffList_ArrayList.get(0);
							co_staff_id = reportableListObject3.getFields0();
							staff_name =  reportableListObject3.getFields1();
						}
					} else {
						reportableListObject3 = (ReportableListObject) staffList_ArrayList.get(0);
						co_staff_id = reportableListObject3.getFields0();
						staff_name =  reportableListObject3.getFields1();
					}
				} else {
					staffList_ArrayList = UtilDBWeb.getReportableList(getStaffIdByEmailTwah_sqlStr, new String[]{reportableListObject2.getFields0()});
					if (staffList_ArrayList.size() == 0) {
						staffList_ArrayList = UtilDBWeb.getReportableList(getStaffIdByEmailHkah_sqlStr, new String[]{reportableListObject2.getFields0()});
						if (staffList_ArrayList.size() == 0) {
							co_staff_id = null;
							staff_name = null;
						}
					} else {
						reportableListObject3 = (ReportableListObject) staffList_ArrayList.get(0);
						co_staff_id = reportableListObject3.getFields0();
						staff_name =  reportableListObject3.getFields1();
					}
				}
*/
				String url = null;
				if ("HKAH".equals(area)) {
					url = "http://160.100.3.22:9080/webRequisition/MaterialManagement.html?siteCode=hkah&moduleCode=pms&userID="+co_staff_id+"&userName="+staff_name+"&deptCode="+shippedTo+"&reqNo="+prNo;
				} else {
					url = "http://192.168.0.24:8080/webRequisition/MaterialManagement.html?siteCode=twah&moduleCode=pms&userID="+co_staff_id+"&userName="+staff_name+"&deptCode="+shippedTo+"&reqNo="+prNo;
				}
				
				message.setLength(0);
				message.append("This message is auto generated from Hong Kong Adventist Hospital.<br>");
				message.append("Please do not reply to this email address.<br><br>");
				message.append("*Please login PMS to approve this requisition or click the PR no.<br><br>");
				message.append("PR NO.:<br>");
				message.append("<b><h1><a href=\'"+url+"\'>"+prNo+"</a></b></h1><br>");
				message.append("<br>Please click  <a href=\'" + url);
				message.append("\'>Intranet</a> to view the detail.");

				// Send mail
				UtilMail.sendMail(
						ConstantsServerSide.MAIL_ALERT,
//						mailTo == null?null:mailTo.toArray(new String[mailTo.size()]),
						mailToArray,
						null,
						null,
						shippedToDeptName+", New REQ NO.:"+prNo+" created, please approval",
						message.toString());
			}

			if (prNo!="" && prNo.length()>0) {
				updateRet = UtilDBWeb.updateQueueTAH(updateSendFlag_sqlStr, new String[]{shippedTo});
			} else {
				updateRet = false;
			}
			
			System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " [NotifySendPRApprovalJob] sendWaitingApproval prNo="+prNo+", sendApproval="+sendApproval+", shippedTo="+shippedTo+", updateRet="+updateRet);
		}
	}
	
	private void sendApproved() {
		StringBuffer message = new StringBuffer();
		StringBuffer sqlStr = new StringBuffer();

		String prNo = null;
		String reqBy = null;
		String shippedTo = null;
		String appDate = null;
		String shippedToDeptName = null;
		String area = null;
		String approveBy = null;
		String approveDate = null;
		String deptCode = null;
		String deptHead = null;

		String getAppList_sqlStr = null;
		String getMailListSendApprovedNotify_sqlStr = null;
		String updateApprovedNotifyFlag_sqlStr = null;
		String getStaffNameByIdHkah_sqlStr = null; 
		String getStaffNameByIdTwah_sqlStr = null;

		ArrayList<ReportableListObject> appList_ArrayList = null;
		ArrayList<ReportableListObject> mailList_ArrayList = null;
		ArrayList<ReportableListObject> staffList_ArrayList = null;

		ReportableListObject reportableListObject = null;
		ReportableListObject reportableListObject2 = null;
		ReportableListObject reportableListObject3 = null;

		boolean updateRet = false;
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT  ");
		sqlStr.append(" ppm.pur_no, ");
		sqlStr.append(" NVL((SELECT sub.user_name  ");
		sqlStr.append(" FROM sys_user_basic@tah sub  ");
		sqlStr.append(" WHERE sub.user_id = ppm.pur_op),ppm.pur_op) AS req_by, ");
		sqlStr.append(" ppm.shipped_to AS shipped_to, ");
		sqlStr.append(" Trim(pd.dept_ename) AS shipped_to_deptName,  ");
		sqlStr.append(" pd.area,  ");
		sqlStr.append(" ppm.approve_by, ");
		sqlStr.append(" ppm.approve_date, ");
		sqlStr.append(" decode(pd.area, 'HKAH', d.co_department_code, 'TWAH', d_tw.co_department_code) department_code, ");
		sqlStr.append(" decode(pd.area, 'HKAH', d.co_department_head, 'TWAH', d_tw.co_department_head) department_head ");
		sqlStr.append("FROM pms_pur_m@tah ppm ");
		sqlStr.append("    left join pn_dept@tah pd on pd.dept_id = ppm.shipped_to  ");
		sqlStr.append("    left join co_department_mapping dm on dm.co_department_code1 = trim(ppm.shipped_to) ");
		sqlStr.append("    left join co_department_mapping@twah dm_tw on dm_tw.co_department_code3 = trim(ppm.shipped_to) ");
		sqlStr.append("    left join co_departments d on d.co_department_code = dm.co_department_code1 ");
		sqlStr.append("    left join co_departments@twah d_tw on d_tw.co_department_code = dm_tw.co_department_code2 ");
		sqlStr.append("WHERE 1=1 ");
		sqlStr.append("AND ppm.cancel_flag = 'N' ");
		sqlStr.append("AND ppm.approve_date is not null ");
		sqlStr.append("AND ppm.approve_by is not null ");
		sqlStr.append("AND ppm.approved_notify_date is null ");
		sqlStr.append("AND ppm.send_approval is not null ");
		sqlStr.append("and ppm.pr_status is not null ");
		sqlStr.append("AND ppm.ppo_id IS NULL ");
		sqlStr.append("ORDER BY pur_no ");
		getAppList_sqlStr = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT DISTINCT pn.email, pn.staff_no ");
		sqlStr.append(" FROM pms_notice_to pn ");
		sqlStr.append("WHERE pn.active = 1 AND pn.type ='RA' ");
		sqlStr.append("AND pn.staff_no = ? ");
		getMailListSendApprovedNotify_sqlStr = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT co_staff_id, co_firstname||' '||co_lastname ");
		sqlStr.append(" FROM co_users ");
		sqlStr.append("WHERE Trim(co_staff_id) = Trim(?)");
		sqlStr.append("and co_staff_id IS NOT NULL");
		getStaffNameByIdHkah_sqlStr = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT co_staff_id, co_firstname||' '||co_lastname ");
		sqlStr.append(" FROM co_users@twah ");
		sqlStr.append("WHERE Trim(co_staff_id) = Trim(?)");
		sqlStr.append("and co_staff_id IS NOT NULL");
		getStaffNameByIdTwah_sqlStr = sqlStr.toString();		

		sqlStr.setLength(0);
		sqlStr.append("update pms_pur_m ");
		sqlStr.append("set approved_notify_date=sysdate ");
		sqlStr.append("where pur_no = ? ");
		updateApprovedNotifyFlag_sqlStr = sqlStr.toString();

		// Get approved pr number
		appList_ArrayList = UtilDBWeb.getReportableList(getAppList_sqlStr);
		for (int i = 0; i < appList_ArrayList.size(); i++) {
			reportableListObject = (ReportableListObject) appList_ArrayList.get(i);
			prNo = reportableListObject.getFields0();
			reqBy = reportableListObject.getFields1();
			shippedTo = reportableListObject.getFields2().trim();
			shippedToDeptName = reportableListObject.getFields3();
			area = reportableListObject.getFields4();
			approveBy = reportableListObject.getFields5();
			approveDate = reportableListObject.getFields6();
			deptCode = reportableListObject.getFields7();
			deptHead = reportableListObject.getFields8();

			String co_staff_id = null;
			String staff_name = null;

			// Get mail list
			String getMailSql = null;
			String[] getMailSqlParam = null;
			getMailSql = getMailListSendApprovedNotify_sqlStr;
			getMailSqlParam = new String[]{deptHead};
			mailList_ArrayList = UtilDBWeb.getReportableListTAH(getMailSql, getMailSqlParam);
			if (mailList_ArrayList.isEmpty()) {
				EmailAlertDB.sendEmail(
						"pms.admin", 
						"PMS - Cannot find department head email (Approved)",
						"Cannot find valid department email in pms_notice_to<br/>" +
						"PR No: " + prNo + ", Department Head: " + deptHead + ", Ship To: " + shippedTo);
			}
			for (int k=0 ; k<mailList_ArrayList.size(); k++) {
				reportableListObject2 = (ReportableListObject) mailList_ArrayList.get(k);
				String[] mailToArray = new String[]{reportableListObject2.getFields0()};
//				List<String> mailTo = new ArrayList<String>();
//				mailTo.add(reportableListObject2.getFields0());

				// Get staff name				
				if ("HKAH".equals(area)) {
					staffList_ArrayList = UtilDBWeb.getReportableList(getStaffNameByIdHkah_sqlStr, new String[]{reportableListObject2.getFields1()});
					if (staffList_ArrayList.size() == 0) {
						staffList_ArrayList = UtilDBWeb.getReportableList(getStaffNameByIdTwah_sqlStr, new String[]{reportableListObject2.getFields1()});
						if (staffList_ArrayList.size() == 0) {
							co_staff_id = null;
							staff_name = null;
						} else {
							reportableListObject3 = (ReportableListObject) staffList_ArrayList.get(0);
							co_staff_id = reportableListObject3.getFields0();
							staff_name =  reportableListObject3.getFields1();
						}
					} else {
						reportableListObject3 = (ReportableListObject) staffList_ArrayList.get(0);
						co_staff_id = reportableListObject3.getFields0();
						staff_name =  reportableListObject3.getFields1();
					}
				} else {
					staffList_ArrayList = UtilDBWeb.getReportableList(getStaffNameByIdTwah_sqlStr, new String[]{reportableListObject2.getFields1()});
					if (staffList_ArrayList.size() == 0) {
						staffList_ArrayList = UtilDBWeb.getReportableList(getStaffNameByIdHkah_sqlStr, new String[]{reportableListObject2.getFields1()});
						if (staffList_ArrayList.size() == 0) {
							co_staff_id = null;
							staff_name = null;
						}
					} else {
						reportableListObject3 = (ReportableListObject) staffList_ArrayList.get(0);
						co_staff_id = reportableListObject3.getFields0();
						staff_name =  reportableListObject3.getFields1();
					}
				}				

				String url = null;
				if ("HKAH".equals(area)) {
					url = "http://160.100.3.22:9080/webRequisition/MaterialManagement.html?siteCode=hkah&moduleCode=pms&userID="+co_staff_id+"&userName="+staff_name+"&deptCode="+shippedTo+"&reqNo="+prNo;
				} else {
					url = "http://192.168.0.24:8080/webRequisition/MaterialManagement.html?siteCode=twah&moduleCode=pms&userID="+co_staff_id+"&userName="+staff_name+"&deptCode="+shippedTo+"&reqNo="+prNo;
				}
				
				message.setLength(0);
				message.append("This message is auto generated from Hong Kong Adventist Hospital.<br>");
				message.append("Please do not reply to this email address.<br><br>");
				message.append("*This PMS requisition has been final approved.<br><br>");
				message.append("PR NO.:<br>");
				message.append("<b><h1><a href=\'"+url+"\'>"+prNo+"</a></b></h1><br>");
				message.append("<br>Please click  <a href=\'" + url);
				message.append("\'>Intranet</a> to view the detail.");

				String subject = shippedToDeptName+", REQ NO.:"+prNo+" final approved.";			
				// Send mail
				UtilMail.sendMail(
						ConstantsServerSide.MAIL_ALERT,
//						mailTo == null?null:mailTo.toArray(new String[mailTo.size()]),
						mailToArray,
						null,
						null,
						subject,
						message.toString());
			}

			if (prNo!="" && prNo.length()>0) {
				updateRet = UtilDBWeb.updateQueueTAH(updateApprovedNotifyFlag_sqlStr, new String[]{prNo});
			} else {
				updateRet = false;
			}
			
			System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " [NotifySendPRApprovalJob] sendApproved prNo="+prNo+", approved by="+approveBy+", shippedTo="+shippedTo+", deptHead="+deptHead+", updateRet="+updateRet);
		}
	}
}