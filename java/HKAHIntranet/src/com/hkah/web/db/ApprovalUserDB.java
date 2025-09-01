/*
 * Created on May 17, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.db;

import java.util.ArrayList;
import java.util.Vector;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ApprovalUserDB {

	// ---------------------------------------------------------------------
	private static String sqlStr_maxRequestID = null;
	private static String sqlStr_insert = null;
	private static String sqlStr_process = null;
	private static String sqlStr_list = null;

	// ---------------------------------------------------------------------
	private static String getNextApproveID(String moduleCode, String category, String siteCode, String deptCode, String userType, String userID) {
		String approveID = null;

		// get next schedule id from db
		ArrayList result = UtilDBWeb.getReportableList(
				sqlStr_maxRequestID,
				new String[] { moduleCode, category, siteCode, deptCode, userType, userID });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			approveID = reportableListObject.getValue(0);

			// set 1 for initial
			if (approveID == null || approveID.length() == 0) return "1";
		}
		return approveID;
	}

	public static boolean sendRequest(UserBean userBean, String moduleCode, String category,
			String ownerSiteCode, String ownerDeptCode, String externalID) {
		// get next approve ID
		String approveID = getNextApproveID(moduleCode, category, userBean.getSiteCode(), userBean.getDeptCode(), "staff", userBean.getStaffID());

		String staffID = null;
		String email = null;

		ArrayList record = getApprovalUserList(moduleCode, category, ownerSiteCode, ownerDeptCode, null);
		int userListSize = record.size();
		if (userListSize > 0) {
			ReportableListObject row = null;

			for (int i = 0; i < userListSize; i++) {
				row = (ReportableListObject) record.get(i);
				staffID = row.getValue(0);
				email = row.getValue(2);

				// try to insert a new record
				UtilDBWeb.updateQueue(
					sqlStr_insert,
					new String[] { moduleCode, category, approveID,
						userBean.getSiteCode(), userBean.getDeptCode(), "staff", userBean.getStaffID(),
						ownerSiteCode, ownerDeptCode, "staff", staffID,
						"O", externalID,
						userBean.getLoginID(), userBean.getLoginID() });

				if (email != null && email.length() > 0) {
					StringBuffer commentStr = new StringBuffer();
					commentStr.append(userBean.getUserName());
					commentStr.append(" would like to view your clients information. Please go to <a href=\"http");
					commentStr.append(ConstantsServerSide.INTRANET_URL);
					commentStr.append("/intranet/crm/client_info_approval.jsp");
					commentStr.append("\">Intranet</a> or <a href=\"https://");
					commentStr.append(ConstantsServerSide.OFFSITE_URL);
					commentStr.append("/intranet/crm/client_info_approval.jsp");
					commentStr.append("\">Offsite</a> for request approval!");

					// send email
					UtilMail.sendMail(
						ConstantsServerSide.MAIL_ADMIN,
						email,
						"Client Release Request (System message)",
						commentStr.toString());
				}
			}
			return true;
		} else {
			return false;
		}
	}

	public static boolean processRequest(UserBean userBean, String moduleCode, String category, String approveID,
			String requestSiteCode, String requestDeptCode, String requestUserID, String externalID, String status) {
		if (UtilDBWeb.updateQueue(
				sqlStr_process,
				new String[] { status, userBean.getLoginID(), moduleCode, category, requestSiteCode, requestDeptCode, "staff", requestUserID, approveID})) {
			// accept
			if ("A".equals(status)) {
				CRMClientDB.addAccessControl(userBean, externalID, requestSiteCode, requestDeptCode);
			}
			return true;
		} else {
			return false;
		}
	}

	public static ArrayList getList(UserBean userBean, String moduleCode, String category) {
		// fetch approval list
		return UtilDBWeb.getReportableList(
				sqlStr_list,
				new String[] { moduleCode, category,
			userBean.getSiteCode(), userBean.getDeptCode(), userBean.getStaffID(),
			userBean.getSiteCode(), userBean.getDeptCode(), userBean.getStaffID() });
	}

	public static ArrayList getEpoAppUserList(String flowId, String flowSeq, String sendAppTo, String loginID, String appGrp) {
		String siteCode = ConstantsServerSide.SITE_CODE;
		StringBuffer sqlStr = new StringBuffer();
		Vector<String> sqlValue = new Vector<String>();		
		sqlStr.append("SELECT DISTINCT CU.CO_STAFF_ID, CU.co_staffname||' -- '||EAL.CO_POSITION_1, EAL.CO_POSITION_1 ");
		sqlStr.append(" FROM EPO_APPROVE_LIST EAL, CO_STAFFS CU ");
		sqlStr.append(" WHERE EAL.STAFF_ID = CU.CO_STAFF_ID ");
		sqlStr.append(" AND EAL.APPROVAL_GROUP = ?");
		sqlValue.add(appGrp);
//		sqlStr.append(" AND EAL.SITE_CODE = CU.CO_SITE_CODE ");
		sqlStr.append(" AND EAL.FLOW_ID = ?");
		sqlValue.add(flowId);		
		sqlStr.append(" AND EAL.FLOW_SEQ = ?");
		sqlValue.add(flowSeq);
//		sqlStr.append(" AND CU.CO_SITE_CODE = ?");
//		sqlValue.add(ConstantsServerSide.SITE_CODE);
		if (sendAppTo != null && sendAppTo.length() > 0) {
			sqlStr.append(" AND CU.CO_STAFF_ID = '");
			sqlStr.append(sendAppTo);
			sqlStr.append("' ");
		}else{
			if (loginID != null && loginID.length() > 0 && !"3".equals(flowSeq)) {
				sqlStr.append(" AND '");
				sqlStr.append(loginID);
				sqlStr.append("' NOT IN (CU.CO_STAFF_ID)");
			}			
		}
		sqlStr.append(" ORDER BY 2");
		System.err.println(sqlStr.toString());
		// fetch user list
		return UtilDBWeb.getReportableList(
				sqlStr.toString(),
				(String[]) sqlValue.toArray(new String[sqlValue.size()]));
	}

	public static ArrayList getEpoAppUserList(String flowId, String flowSeq, String sendAppTo, String loginID, String reqStatus, String appGrp) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CU.CO_STAFF_ID, CU.CO_FIRSTNAME||','||CU.CO_LASTNAME||' -- '||EAL.CO_POSITION_1, EAL.CO_POSITION_1 ");
		sqlStr.append(" FROM EPO_WORKFLOW EW, EPO_APPROVE_LIST EAL, CO_USERS CU ");
		sqlStr.append(" WHERE EAL.STAFF_ID = CU.CO_STAFF_ID ");
		sqlStr.append(" AND EAL.FLOW_ID = EW.FLOW_ID ");
		sqlStr.append(" AND EAL.FLOW_SEQ = EW.FLOW_SEQ ");
		sqlStr.append(" AND EAL.APPROVAL_GROUP = ?");
//		sqlStr.append(" AND EAL.SITE_CODE = CU.CO_SITE_CODE ");
		sqlStr.append(" AND EW.ENABLE = 1");
		sqlStr.append(" AND EAL.FLOW_ID = ?");
		sqlStr.append(" AND EAL.FLOW_SEQ = ?");
		if (sendAppTo != null && sendAppTo.length() > 0) {
			sqlStr.append(" AND CU.CO_STAFF_ID = '");
			sqlStr.append(sendAppTo);
			sqlStr.append("'");
		}
		if (loginID != null && loginID.length() > 0 && !sendAppTo.equals(loginID) && !"O".equals(reqStatus) && !"A".equals(reqStatus) && !"F".equals(reqStatus)) {
			sqlStr.append(" AND CU.CO_STAFF_ID <> '");
			sqlStr.append(loginID);
			sqlStr.append("'");
		}
		sqlStr.append(" ORDER BY 1");
		System.err.println(sqlStr.toString());
		// fetch user list
		return UtilDBWeb.getReportableList(
				sqlStr.toString(),
				new String[] { appGrp, flowId, flowSeq });
	}

	public static ArrayList getCtsApprover(String docCode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CDA.DOCCODE,DOC.DOCFNAME||' '||DOC.DOCGNAME,CDA.ENABLED,CDA.DOCCODE ");
		sqlStr.append(" FROM CTS_DOC_APPROVER CDA, doctor@iweb DOC");
		sqlStr.append(" WHERE CDA.DOCCODE = DOC.DOCCODE");
		sqlStr.append(" AND CDA.ENABLED = 1");
		sqlStr.append(" AND (CDA.EXPIRED_DATE IS NULL OR");
		sqlStr.append(" TRUNC(CDA.EXPIRED_DATE,'DD') > TRUNC(SYSDATE,'DD'))");
//		if (docCode!=null && docCode.length()>0) {
//			sqlStr.append(" AND CDA.DOCCODE = '");
//			sqlStr.append(docCode);
//			sqlStr.append("'");
//		}
		sqlStr.append(" ORDER BY 2");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getApprovalUserList(String moduleCode, String category, String requestSiteCode, String requestUserID) {
		return getApprovalUserList(moduleCode, category, requestSiteCode, StaffDB.getDeptCode(requestUserID), requestUserID);
	}

	public static ArrayList getApprovalUserList(String moduleCode, String category, String requestSiteCode, String requestDeptCode, String requestUserID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT A.CO_APPROVAL_USER_ID, S.CO_STAFFNAME, U.CO_EMAIL, A.CO_APPROVAL_PRIORITY ");
		sqlStr.append("FROM   CO_APPROVAL_USER A, CO_STAFFS S, CO_USERS U ");
		sqlStr.append("WHERE  A.CO_APPROVAL_SITE_CODE = S.CO_SITE_CODE ");
		sqlStr.append("AND    A.CO_APPROVAL_USER_ID = S.CO_STAFF_ID ");
		sqlStr.append("AND    A.CO_ENABLED = S.CO_ENABLED ");
		sqlStr.append("AND    A.CO_APPROVAL_SITE_CODE = U.CO_SITE_CODE ");
		sqlStr.append("AND    A.CO_APPROVAL_USER_ID = U.CO_STAFF_ID ");
		sqlStr.append("AND    A.CO_ENABLED = U.CO_ENABLED ");
		sqlStr.append("AND    A.CO_ENABLED = 1 ");
		sqlStr.append("AND    A.CO_MODULE_CODE = ? ");
		sqlStr.append("AND    A.CO_CATEGORY = ? ");
		if (requestSiteCode != null && requestSiteCode.length() > 0) {
			sqlStr.append("AND    A.CO_REQUEST_SITE_CODE = '");
			sqlStr.append(requestSiteCode);
			sqlStr.append("' ");
		}
		if (requestDeptCode != null && requestDeptCode.length() > 0) {
			sqlStr.append("AND   A.CO_REQUEST_DEPARTMENT_CODE = '");
			sqlStr.append(requestDeptCode);
			sqlStr.append("' ");
		}
		if (requestUserID != null && requestUserID.length() > 0) {
			if ("eleave.d".equals(moduleCode)) {
				sqlStr.append("AND   (A.CO_REQUEST_USER_ID = 'ALL' OR A.CO_REQUEST_USER_ID = '");
				sqlStr.append(requestUserID);
				sqlStr.append("') ");
			} else {
				sqlStr.append(" AND A.CO_REQUEST_USER_ID in(( ");
				sqlStr.append("  select decode(userExist,0,'ALL',"+requestUserID+") from ");
				sqlStr.append(" (select count(*) as userExist from CO_APPROVAL_USER where CO_REQUEST_USER_ID = '"+requestUserID+"') )) ");
			}
		}
		sqlStr.append("ORDER BY S.CO_STAFFNAME");

		// fetch user list
		return UtilDBWeb.getReportableList(
				sqlStr.toString(),
				new String[] { moduleCode, category });
	}

	public static ArrayList getApprovalUserListForEL(String moduleCode, String category, String requestSiteCode, String requestDeptCode, String requestUserID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT A.CO_APPROVAL_USER_ID, S.CO_STAFFNAME, U.EL_EMAIL, A.CO_APPROVAL_PRIORITY ");
		sqlStr.append("FROM   CO_APPROVAL_USER A, CO_STAFFS S, EL_EMPLOYEE U ");
		sqlStr.append("WHERE  A.CO_APPROVAL_SITE_CODE = S.CO_SITE_CODE ");
		sqlStr.append("AND    A.CO_APPROVAL_USER_ID = S.CO_STAFF_ID ");
		sqlStr.append("AND    A.CO_ENABLED = S.CO_ENABLED ");
		sqlStr.append("AND    A.CO_APPROVAL_SITE_CODE = U.EL_SITE_CODE ");
		sqlStr.append("AND    A.CO_APPROVAL_USER_ID = U.EL_STAFF_ID ");
		sqlStr.append("AND    A.CO_ENABLED = U.EL_ENABLED ");
		sqlStr.append("AND    A.CO_ENABLED = 1 ");
		sqlStr.append("AND    A.CO_MODULE_CODE = ? ");
		sqlStr.append("AND    A.CO_CATEGORY = ? ");
		if (requestSiteCode != null && requestSiteCode.length() > 0) {
			sqlStr.append("AND    A.CO_REQUEST_SITE_CODE = '");
			sqlStr.append(requestSiteCode);
			sqlStr.append("' ");
		}
		if (requestDeptCode != null && requestDeptCode.length() > 0) {
			sqlStr.append("AND   A.CO_REQUEST_DEPARTMENT_CODE = '");
			sqlStr.append(requestDeptCode);
			sqlStr.append("' ");
		}
		if (requestUserID != null && requestUserID.length() > 0) {
			if ("eleave.d".equals(moduleCode)) {
				sqlStr.append("AND   (A.CO_REQUEST_USER_ID = 'ALL' OR A.CO_REQUEST_USER_ID = '");
				sqlStr.append(requestUserID);
				sqlStr.append("') ");
			} else {
				sqlStr.append(" AND A.CO_REQUEST_USER_ID in(( ");
				sqlStr.append("  select decode(userExist,0,'ALL',"+requestUserID+") from ");
				sqlStr.append(" (select count(*) as userExist from CO_APPROVAL_USER where CO_REQUEST_USER_ID = '"+requestUserID+"') )) ");
			}
		}
		sqlStr.append("ORDER BY S.CO_STAFFNAME");

		// fetch user list
		return UtilDBWeb.getReportableList(
				sqlStr.toString(),
				new String[] { moduleCode, category });
	}

	public static ArrayList getDepartmentHead(String requestUserID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DISTINCT cd.co_department_head, (SELECT DISTINCT cs.co_staffname FROM co_staffs cs WHERE cs.co_staff_id=cd.co_department_head), '' FROM co_departments cd ");
		sqlStr.append(" WHERE cd.co_department_code IN (");
		sqlStr.append(" SELECT co_department_code FROM co_staffs WHERE co_staff_id = ? OR co_staff_id IN (SELECT co_staff_id FROM co_users WHERE co_username = ?))");
		// fetch user list
		return UtilDBWeb.getReportableList(
				sqlStr.toString(),
				new String[] { requestUserID, requestUserID });
	}

	public static ArrayList getDepartmentHead1(String requestUserID) {
		StringBuffer sqlStr = new StringBuffer();
		String dept_code = EPORequestDB.getDeptByDeptHead(requestUserID);
		String deptSRN = EPORequestDB.getDeptByDeptHead(requestUserID);
		
		if(deptSRN!=null && deptSRN.length()>0){
			sqlStr.append("SELECT DISTINCT cd.co_department_head, (");
			sqlStr.append("SELECT DISTINCT cs.co_staffname ");
			sqlStr.append(" FROM co_staffs cs ");
			sqlStr.append(" WHERE cs.co_staff_id=cd.co_department_head), ''");
			sqlStr.append(" FROM co_departments cd WHERE cd.CO_DEPARTMENT_CODE = ? AND cd.co_department_head IS NOT NULL union ");			
			sqlStr.append("SELECT DISTINCT cd.CO_DEPARTMENT_SUBHEAD, (");
			sqlStr.append("SELECT DISTINCT cs.co_staffname ");
			sqlStr.append(" FROM co_staffs cs ");
			sqlStr.append(" WHERE cs.co_staff_id=cd.CO_DEPARTMENT_SUBHEAD), ''");
			sqlStr.append(" FROM co_departments cd WHERE cd.CO_DEPARTMENT_CODE = ? AND cd.CO_DEPARTMENT_SUBHEAD IS NOT NULL ");
			System.err.println(sqlStr.toString());
			return UtilDBWeb.getReportableList(
					sqlStr.toString(),
					new String[] { dept_code, dept_code });			
		}else{
			sqlStr.append("SELECT DISTINCT cd.co_department_head, (");
			sqlStr.append("SELECT DISTINCT cs.co_staffname ");
			sqlStr.append(" FROM co_staffs cs ");
			sqlStr.append(" WHERE cs.co_staff_id=cd.co_department_head), ''");
			sqlStr.append(" FROM co_departments cd WHERE cd.co_department_head = ? OR cd.co_department_head IN (SELECT co_staff_id FROM co_users WHERE co_username = ?)");
			System.err.println(sqlStr.toString());
			return UtilDBWeb.getReportableList(
					sqlStr.toString(),
					new String[] { requestUserID, requestUserID });			
		}
	}

	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT MAX(CO_REQUEST_ID) + 1 ");
		sqlStr.append("FROM   CO_APPROVAL_REQUEST ");
		sqlStr.append("WHERE  CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_APPROVAL_CATEGORY = ? ");
		sqlStr.append("AND    CO_REQUEST_SITE_CODE = ? ");
		sqlStr.append("AND    CO_REQUEST_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    CO_REQUEST_USER_TYPE = ? ");
		sqlStr.append("AND    CO_REQUEST_USER_ID = ? ");
		sqlStr_maxRequestID = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CO_APPROVAL_REQUEST (");
		sqlStr.append("CO_MODULE_CODE, CO_APPROVAL_CATEGORY, CO_REQUEST_ID, ");
		sqlStr.append("CO_REQUEST_SITE_CODE, CO_REQUEST_DEPARTMENT_CODE, CO_REQUEST_USER_TYPE, CO_REQUEST_USER_ID, ");
		sqlStr.append("CO_APPROVE_SITE_CODE, CO_APPROVE_DEPARTMENT_CODE, CO_APPROVE_USER_TYPE, CO_APPROVE_USER_ID, ");
		sqlStr.append("CO_APPROVE_STATUS, CO_EXTERNAL_ID, CO_CREATED_USER, CO_MODIFIED_USER) ");
		sqlStr.append("VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
		sqlStr_insert = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_APPROVAL_REQUEST ");
		sqlStr.append("SET    CO_APPROVE_STATUS = ?, CO_MODIFIED_USER = ?, CO_MODIFIED_DATE = SYSDATE ");
		sqlStr.append("WHERE  CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_APPROVAL_CATEGORY = ? ");
		sqlStr.append("AND    CO_REQUEST_SITE_CODE = ? ");
		sqlStr.append("AND    CO_REQUEST_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    CO_REQUEST_USER_TYPE = ? ");
		sqlStr.append("AND    CO_REQUEST_USER_ID = ? ");
		sqlStr.append("AND    CO_REQUEST_ID = ? ");
		sqlStr.append("AND    CO_APPROVE_STATUS = 'O' ");
		sqlStr_process = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT R.CO_REQUEST_ID, ");
		sqlStr.append("       R.CO_REQUEST_SITE_CODE, R.CO_REQUEST_DEPARTMENT_CODE, R.CO_REQUEST_USER_ID, S1.CO_STAFFNAME, ");
		sqlStr.append("       R.CO_APPROVE_SITE_CODE, R.CO_APPROVE_DEPARTMENT_CODE, R.CO_APPROVE_USER_ID, S2.CO_STAFFNAME, ");
		sqlStr.append("       R.CO_EXTERNAL_ID, TO_CHAR(R.CO_CREATED_DATE, 'dd/MM/yyyy'), R.CO_APPROVE_STATUS ");
		sqlStr.append("FROM   CO_APPROVAL_REQUEST R, CO_STAFFS S1, CO_STAFFS S2 ");
		sqlStr.append("WHERE  R.CO_REQUEST_SITE_CODE = S1.CO_SITE_CODE ");
		sqlStr.append("AND    R.CO_REQUEST_USER_ID = S1.CO_STAFF_ID ");
		sqlStr.append("AND    R.CO_REQUEST_USER_TYPE = 'staff' ");
		sqlStr.append("AND    R.CO_ENABLED = S1.CO_ENABLED ");
		sqlStr.append("AND    R.CO_APPROVE_SITE_CODE = S2.CO_SITE_CODE ");
		sqlStr.append("AND    R.CO_APPROVE_USER_ID = S2.CO_STAFF_ID ");
		sqlStr.append("AND    R.CO_APPROVE_USER_TYPE = 'staff' ");
		sqlStr.append("AND    R.CO_ENABLED = S2.CO_ENABLED ");
		sqlStr.append("AND    R.CO_ENABLED = 1 ");
		sqlStr.append("AND    R.CO_MODULE_CODE = ? ");
		sqlStr.append("AND    R.CO_APPROVAL_CATEGORY = ? ");
		sqlStr.append("AND  ((R.CO_REQUEST_SITE_CODE = ? ");
		sqlStr.append("AND    R.CO_REQUEST_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    R.CO_REQUEST_USER_ID = ?) ");
		sqlStr.append("OR    (R.CO_APPROVE_SITE_CODE = ? ");
		sqlStr.append("AND    R.CO_APPROVE_DEPARTMENT_CODE = ? ");
		sqlStr.append("AND    R.CO_APPROVE_USER_ID = ?)) ");
		sqlStr.append("ORDER BY R.CO_CREATED_DATE DESC ");
		sqlStr_list = sqlStr.toString();
	}
}