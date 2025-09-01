/*
 * Created on Nov 24, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class CRMPromotionDB {
	UserBean userBean = new UserBean();
	private static String sqlStr_insertEvent = null;
	private static String sqlStr_updateEvent = null;
	private static String sqlStr_deleteEvent = null;
	private static String sqlStr_insertPromotion = null;
	private static String sqlStr_insertInstruction = null;
	private static String sqlStr_insertEnquiry = null;
	private static String sqlStr_updatePromotion = null;
	private static String sqlStr_updateInstruction = null;
	private static String sqlStr_updateEnquiry = null;
	private static String sqlStr_deletePromotion = null;
	private static String sqlStr_deleteInstruction = null;
	private static String sqlStr_deleteInstructionOne = null;
	private static String sqlStr_deleteEnquiry = null;
	private static String sqlStr_deleteEnquiryOne = null;

	private static String getNextEventID(String moduleCode) {
		String eventID = null;

		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(CO_EVENT_ID) + 1 FROM CO_EVENT WHERE CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND CO_MODULE_CODE = ? ",
				new String[] { moduleCode });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			eventID = reportableListObject.getValue(0);

			// set 1 for initial
			if (eventID == null || eventID.length() == 0) return "1001";
		}
		return eventID;
	}

	private static String getNextInstructionID(String moduleCode, String crmEventId) {
		String instructionID = null;

		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(CRM_PROMO_INSTR_PID) + 1 FROM CRM_PROMOTION_INSTRUCTION WHERE CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND CRM_MODULE_CODE = ? AND CRM_EVENT_ID = ? ",
				new String[] { moduleCode, crmEventId });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			instructionID = reportableListObject.getValue(0);

			// set 1 for initial
			if (instructionID == null || instructionID.length() == 0) return "1001";
		}
		return instructionID;
	}

	private static String getNextEnquiryID(String moduleCode, String crmEventId) {
		String enquiryID = null;

		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(CRM_PROMO_ENQ_PID) + 1 FROM CRM_PROMOTION_ENQUIRY WHERE CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' AND CRM_MODULE_CODE = ? AND CRM_EVENT_ID = ? ",
				new String[] { moduleCode, crmEventId });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			enquiryID = reportableListObject.getValue(0);

			// set 1 for initial
			if (enquiryID == null || enquiryID.length() == 0) return "1001";
		}
		return enquiryID;
	}

	/**
	 * Add a event
	 * @return eventID
	 */
/*	public static String add(UserBean userBean,
			String moduleCode,
			String deptCode,
			String eventCategory, String eventType,
			String eventDesc, String eventDetail) {
		return add(moduleCode,
				deptCode, eventCategory, eventType, null,
				eventDesc, eventDetail, userBean.getLoginID());
	}

	public static String add(UserBean userBean,
			String moduleCode,
			String deptCode,
			String eventCategory, String eventType, String eventType2,
			String eventDesc, String eventDetail) {
		return add(moduleCode,
				deptCode, eventCategory, eventType, eventType2,
				eventDesc, eventDetail, userBean.getLoginID());
	}

	public static String add(
			String moduleCode,
			String deptCode,
			String eventCategory, String eventType,
			String eventDesc, String eventDetail,
			String createUser) {
		return add(moduleCode,
				deptCode, eventCategory, eventType, null,
				eventDesc, eventDetail, createUser);
	}*/

	public static String add(UserBean userBean,
			String moduleCode, String deptCode, String eventCategory, String eventType, String eventType2,
			String eventDesc, String eventDetail,
			String deptCode1, String target1, String deptCode2, String target2, String deptCode3, String target3,
			String initialDateFm, String initialDateTo,
			String promoteRemarks, String promoteDetail, String promoteMaterials,
			String refCode, String promoteComment,
			String createSiteCode, String createDeptCode) {

		// Insert event record
		String eventID = addEvent(moduleCode, deptCode, eventCategory, eventType, eventType2,
				eventDesc, eventDetail, userBean.getLoginID());

		// insert promotion record
		if (eventID != null) {
			addPromotion(moduleCode, eventID,
					deptCode1, target1, deptCode2, target2, deptCode3, target3,
					initialDateFm, initialDateTo, promoteRemarks, promoteDetail, promoteMaterials,
					refCode, promoteComment, userBean.getLoginID(),
					createSiteCode, createDeptCode, userBean.getLoginID());
			return eventID;
		} else {
			return null;
		}
	}

	public static String addEvent(
			String moduleCode,
			String deptCode,
			String eventCategory, String eventType, String eventType2,
			String eventDesc, String eventDetail,
			String createUser) {
		// get next event ID
		String eventID = getNextEventID(moduleCode);

		// try to insert a new record into co_event
		if (UtilDBWeb.updateQueue(
				sqlStr_insertEvent,
				new String[] { moduleCode, eventID, eventDesc, eventDetail, deptCode,
					eventCategory, eventType, eventType2,
					createUser, createUser })) {
			return eventID;
		} else {
			return null;
		}
	}

	public static String addPromotion(
			String moduleCode,	String eventID,
			String deptCode1, String target1, String deptCode2, String target2, String deptCode3, String target3,
			String initialDateFm, String initialDateTo,
			String promoteRemarks, String promoteDetail, String promoteMaterials,
			String refCode, String promoteComment,
			String createUser, String createSiteCode, String createDeptCode, String modifiedUser) {

		// try to insert a new record into CRM_PROMOTION
		if (UtilDBWeb.updateQueue(
				sqlStr_insertPromotion,
				new String[] { moduleCode, eventID,
						deptCode1, target1, deptCode2, target2, deptCode3, target3,
						initialDateFm, initialDateTo, promoteRemarks, promoteDetail, promoteMaterials,
						refCode, promoteComment, createUser,
						createSiteCode, createDeptCode, modifiedUser })) {
			return eventID;
		} else {
			return null;
		}
	}

	public static String addInstruction(UserBean userBean,
			String moduleCode,	String eventID,
			String instrPID, String instrCode, String instrRemarks) {

		// try to insert a new record into CRM_INSTRUCTION
		if (UtilDBWeb.updateQueue(
				sqlStr_insertInstruction,
				new String[] { moduleCode, eventID,
						instrPID, instrCode, instrRemarks,
						userBean.getLoginID(), userBean.getLoginID() })) {
			return eventID;
		} else {
			return null;
		}
	}

	public static String addEnquiry(UserBean userBean,
			String moduleCode,	String eventID,
			String enqPID, String enquiry, String phone) {

		// try to insert a new record into CRM_INSTRUCTION
		if (UtilDBWeb.updateQueue(
				sqlStr_insertEnquiry,
				new String[] { moduleCode, eventID,
						enqPID, enquiry, phone,
						userBean.getLoginID(), userBean.getLoginID() })) {
			return eventID;
		} else {
			return null;
		}
	}

	/**
	 * Modify a event
	 * @return whether it is successful to update the record
	 */
	public static String update(UserBean userBean,
			String moduleCode, String eventID,
			String deptCode,
			String eventCategory, String eventType, String eventType2,
			String eventDesc, String eventDetail,
			String deptCode1, String target1, String deptCode2, String target2, String deptCode3, String target3,
			String initDateFm, String initDateTo, String promoteRemarks, String promoteDetails,
			String promote_materials, String refCode, String promoteComment,
			String createdSite, String createdDept) {

		String EventID = updateEvent( moduleCode, eventID, deptCode, eventCategory, eventType, eventType2,
			eventDesc, eventDetail,	userBean.getLoginID());

		if (EventID != null) {
			// update promotion
			String Rslt = updatePromotion(userBean, moduleCode, eventID, deptCode, eventCategory, eventType, eventType2,
					eventDesc, eventDetail,	deptCode1, target1, deptCode2, target2, deptCode3, target3,
					initDateFm, initDateTo, promoteRemarks, promoteDetails, promote_materials, refCode,
					promoteComment, createdSite, createdDept);
			if (Rslt != null) {
				return EventID;
			} else {
				return null;
			}
		} else {
			return null;
		}
	}

	public static String updateEvent(
			String moduleCode, String eventID,
			String deptCode,
			String eventCategory, String eventType, String eventType2,
			String eventDesc, String eventDetail, String modifiedUser) {

		// try to update selected record
		if (UtilDBWeb.updateQueue(
				sqlStr_updateEvent,
				new String[] { eventDesc, eventDetail, deptCode,
						eventCategory, eventType, eventType2,
						modifiedUser, moduleCode, eventID })) {
			return eventID;
		} else {
			return null;
		}
	}

	public static String updatePromotion(UserBean userBean,
			String moduleCode, String eventID,
			String deptCode,
			String eventCategory, String eventType, String eventType2,
			String eventDesc, String eventDetail,
			String deptCode1, String target1, String deptCode2, String target2, String deptCode3, String target3,
			String initDateFm, String initDateTo, String promoteRemarks, String promoteDetails,
			String promote_materials, String refCode, String promoteComment,
			String createdSite, String createdDept) {

		// try to update selected record
		if (UtilDBWeb.updateQueue(
				sqlStr_updatePromotion,
				new String[] { deptCode1, target1, deptCode2, target2, deptCode3, target3,
						initDateFm, initDateTo, promoteRemarks, promoteDetails,
						promote_materials, refCode, promoteComment,
						createdSite, createdDept, userBean.getLoginID(), moduleCode, eventID})) {
			return eventID;
		} else {
			return null;
		}
	}

	public static String updateInstruction(UserBean userBean,
			String moduleCode, String eventID, String instrPID,
			String instrCode, String instrRemarks) {

		// try to update selected record
		if (UtilDBWeb.updateQueue(
				sqlStr_updateInstruction,
				new String[] { instrCode, instrRemarks, userBean.getLoginID(), moduleCode, eventID, instrPID})) {
			return eventID;
		} else {
			return null;
		}
	}

	public static String updateEnquiry(UserBean userBean,
			String moduleCode, String eventID, String enqPID,
			String enquiry, String phone) {

		// try to update selected record
		if (UtilDBWeb.updateQueue(
				sqlStr_updateEnquiry,
				new String[] { enquiry, phone, userBean.getLoginID(), moduleCode, eventID, enqPID})) {
			return eventID;
		} else {
			return null;
		}
	}

	public static boolean delete(UserBean userBean,
			String moduleCode, String eventID) {

		if (deleteEvent( userBean, moduleCode, eventID)) {
			if (deletePromotion( userBean, moduleCode, eventID)){
				if (deleteInstruction(userBean, moduleCode, eventID)) {
					return deleteEnquiry(userBean, moduleCode, eventID);
				} else {
					return false;
				}
			} else {
				return false;
			}
		} else {
			return false;
		}
	}

	public static boolean deleteEvent(UserBean userBean,
			String moduleCode, String eventID) {

		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteEvent,
				new String[] { userBean.getLoginID(), moduleCode, eventID } );
	}

	public static boolean deletePromotion(UserBean userBean,
			String moduleCode, String eventID) {

		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deletePromotion,
				new String[] { userBean.getLoginID(), moduleCode, eventID } );
	}

	public static boolean deleteInstruction(UserBean userBean,
			String moduleCode, String eventID) {

		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteInstruction,
				new String[] { userBean.getLoginID(), moduleCode, eventID } );
	}

	public static boolean deleteInstruction(UserBean userBean,
			String moduleCode, String eventID,
			String instrPID) {

		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteInstructionOne,
				new String[] { userBean.getLoginID(), moduleCode, eventID, instrPID } );
	}

	public static boolean deleteEnquiry(UserBean userBean,
			String moduleCode, String eventID) {

		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteEnquiry,
				new String[] { userBean.getLoginID(), moduleCode, eventID } );
	}

	public static boolean deleteEnquiry(UserBean userBean,
			String moduleCode, String eventID,
			String enqPID) {

		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteEnquiryOne,
				new String[] { userBean.getLoginID(), moduleCode, eventID, enqPID } );
	}


	public static ArrayList get(String eventID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT C.CO_EVENT_ID, C.CO_EVENT_DESC, ");
		sqlStr.append("       C.CO_EVENT_CATEGORY, C.CO_EVENT_TYPE, ");
		sqlStr.append("       P.CRM_DEPARTMENT_CODE1, D1.CO_DEPARTMENT_DESC, P.CRM_TARGET1, ");
		sqlStr.append("       P.CRM_DEPARTMENT_CODE2, D2.CO_DEPARTMENT_DESC, P.CRM_TARGET2, ");
		sqlStr.append("       P.CRM_DEPARTMENT_CODE3, D3.CO_DEPARTMENT_DESC, P.CRM_TARGET3, ");
		sqlStr.append("       P.CRM_INITIAL_DATE_FM, P.CRM_INITIAL_DATE_TO, ");
		sqlStr.append("       P.CRM_PROMOTE_REMARKS, P.CRM_PROMOTE_DETAILS, ");
		sqlStr.append("       P.CRM_PROMOTE_MATERIALS, P.CRM_REF_CODE, P.CRM_PROMOTE_COMMENT ");
		sqlStr.append("FROM   CO_EVENT C, CRM_PROMOTION P, CO_DEPARTMENTS D1, CO_DEPARTMENTS D2, CO_DEPARTMENTS D3 ");
		sqlStr.append("WHERE  C.CO_SITE_CODE = P.CRM_SITE_CODE ");
		sqlStr.append("AND    C.CO_MODULE_CODE = P.CRM_MODULE_CODE ");
		sqlStr.append("AND    C.CO_EVENT_ID = P.CRM_EVENT_ID ");
		sqlStr.append("AND    P.CRM_DEPARTMENT_CODE1 = D1.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    P.CRM_DEPARTMENT_CODE2 = D2.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    P.CRM_DEPARTMENT_CODE3 = D3.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    C.CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    C.CO_MODULE_CODE = 'crm' ");
		sqlStr.append("AND    C.CO_ENABLED = 1 ");
		sqlStr.append("AND    C.CO_EVENT_CATEGORY = 'marketing' ");
		sqlStr.append("AND    C.CO_EVENT_TYPE = 'promotion' ");
		sqlStr.append("AND    C.CO_EVENT_ID = ? ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { eventID });
	}
	
	
	public static ArrayList getList() {
		return getList();
	}

	public static ArrayList getList(String eventDesc, String orderBy) {
		/*
			SELECT C.CO_EVENT_ID, C.CO_EVENT_DESC, 
			       C.CO_EVENT_CATEGORY, C.CO_EVENT_TYPE,
			       P.CRM_INITIAL_DATE_FM, P.CRM_INITIAL_DATE_TO, 
			       P.CRM_PROMOTE_REMARKS, P.CRM_PROMOTE_DETAILS, 
			       P.CRM_PROMOTE_MATERIALS, P.CRM_REF_CODE, P.CRM_PROMOTE_COMMENT,
			       PD.CRM_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC,
			       PT.CRM_TARGET_TYPE, T.CRM_TARGET_CODE, T.CRM_TARGET_NAME, T.CRM_TARGET_DESCRIPTION,
			       PI.CRM_PROMO_INSTR_CODE, PI.CRM_PROMO_INSTR_REMARKS,
			       PE.CRM_ENQUIRY, PE.CRM_PHONE, 
			       PDC.CRM_DOCUMENT_ID
			FROM   
			       CO_EVENT C 
			       INNER JOIN CRM_PROMOTION P ON
			                C.CO_SITE_CODE = P.CRM_SITE_CODE 
			          AND   C.CO_MODULE_CODE = P.CRM_MODULE_CODE 
			          AND   C.CO_EVENT_ID = P.CRM_EVENT_ID
			       LEFT JOIN CRM_PROMOTION_DOCUMENT PDC ON
			                PDC.CRM_SITE_CODE = P.CRM_SITE_CODE
			          AND   PDC.CRM_MODULE_CODE = P.CRM_MODULE_CODE
			          AND   PDC.CRM_EVENT_ID = P.CRM_EVENT_ID
			       LEFT JOIN CRM_PROMOTION_DEPARTMENT PD ON
			                PD.CRM_SITE_CODE = P.CRM_SITE_CODE
			          AND   PD.CRM_MODULE_CODE = P.CRM_MODULE_CODE
			          AND   PD.CRM_EVENT_ID = P.CRM_EVENT_ID
			       LEFT JOIN CO_DEPARTMENTS D ON
			                D.CO_DEPARTMENT_CODE = PD.CRM_DEPARTMENT_CODE
			       LEFT JOIN CRM_PROMOTION_ENQUIRY PE ON
			                PE.CRM_SITE_CODE = P.CRM_SITE_CODE
			          AND   PE.CRM_MODULE_CODE = P.CRM_MODULE_CODE
			          AND   PE.CRM_EVENT_ID = P.CRM_EVENT_ID
			       LEFT JOIN CRM_PROMOTION_INSTRUCTION PI ON
			               PI.CRM_SITE_CODE = P.CRM_SITE_CODE
			          AND   PI.CRM_MODULE_CODE = P.CRM_MODULE_CODE
			          AND   PI.CRM_EVENT_ID = P.CRM_EVENT_ID
			       LEFT JOIN CRM_PROMOTION_TARGET PT ON
			                PT.CRM_SITE_CODE = P.CRM_SITE_CODE
			          AND   PT.CRM_MODULE_CODE = P.CRM_MODULE_CODE
			          AND   PT.CRM_EVENT_ID = P.CRM_EVENT_ID
			       LEFT JOIN CRM_TARGET T ON
			                PT.CRM_TARGET_ID = T.CRM_TARGET_ID
			WHERE
			       C.CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "'
			AND    C.CO_MODULE_CODE = 'crm' 
			AND    C.CO_ENABLED = 1 
			AND    C.CO_EVENT_CATEGORY = 'marketing' 
			AND    C.CO_EVENT_TYPE = 'promotion' 
			ORDER BY C.CO_EVENT_DESC, C.CO_EVENT_ID;
		 */
		
		
		// fetch event
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT C.CO_EVENT_ID, C.CO_EVENT_DESC, ");
		sqlStr.append("       C.CO_EVENT_CATEGORY, C.CO_EVENT_TYPE, ");
		sqlStr.append("       P.CRM_DEPARTMENT_CODE1, D1.CO_DEPARTMENT_DESC, P.CRM_TARGET1, ");
		sqlStr.append("       P.CRM_DEPARTMENT_CODE2, D2.CO_DEPARTMENT_DESC, P.CRM_TARGET2, ");
		sqlStr.append("       P.CRM_DEPARTMENT_CODE3, D3.CO_DEPARTMENT_DESC, P.CRM_TARGET3, ");
		sqlStr.append("       P.CRM_INITIAL_DATE_FM, P.CRM_INITIAL_DATE_TO, ");
		sqlStr.append("       P.CRM_PROMOTE_REMARKS, P.CRM_PROMOTE_DETAILS, ");
		sqlStr.append("       P.CRM_PROMOTE_MATERIALS, P.CRM_REF_CODE, P.CRM_PROMOTE_COMMENT ");
		sqlStr.append("FROM   CO_EVENT C, CRM_PROMOTION P, CO_DEPARTMENTS D1, CO_DEPARTMENTS D2, CO_DEPARTMENTS D3 ");
		sqlStr.append("WHERE  C.CO_SITE_CODE = P.CRM_SITE_CODE ");
		sqlStr.append("AND    C.CO_MODULE_CODE = P.CRM_MODULE_CODE ");
		sqlStr.append("AND    C.CO_EVENT_ID = P.CRM_EVENT_ID ");
		sqlStr.append("AND    P.CRM_DEPARTMENT_CODE1 = D1.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    P.CRM_DEPARTMENT_CODE2 = D2.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    P.CRM_DEPARTMENT_CODE3 = D3.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    C.CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    C.CO_MODULE_CODE = 'crm' ");
		sqlStr.append("AND    C.CO_ENABLED = 1 ");
		if (eventDesc != null && eventDesc.length() > 0) {
			sqlStr.append("AND    C.CO_EVENT_DESC LIKE '%");
			sqlStr.append(eventDesc);
			sqlStr.append("%' ");
		}
		sqlStr.append("AND    C.CO_EVENT_CATEGORY = 'marketing' ");
		sqlStr.append("AND    C.CO_EVENT_TYPE = 'promotion' ");
		sqlStr.append("ORDER BY C.CO_EVENT_DESC, C.CO_EVENT_ID");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static String getEventID(
			String moduleCode,
			String eventDesc) {
		return getEventID(moduleCode, eventDesc, null, null);
	}

	public static String getEventID(
			String moduleCode,
			String eventDesc,
			String eventCategory,
			String eventType) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_EVENT_ID ");
		sqlStr.append("FROM   CO_EVENT ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_EVENT_DESC = ? ");
		if (eventCategory != null && eventCategory.length() > 0) {
			sqlStr.append("AND    CO_EVENT_CATEGORY = '");
			sqlStr.append(eventCategory);
			sqlStr.append("'");
		}
		if (eventType != null && eventType.length() > 0) {
			sqlStr.append("AND    CO_EVENT_TYPE = '");
			sqlStr.append(eventType);
			sqlStr.append("'");
		}
		sqlStr.append("AND    CO_ENABLED = 1 ");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { moduleCode, eventDesc });

		if (result.size() > 0) {
			ReportableListObject rlo = (ReportableListObject) result.get(0);
			return rlo.getFields0();
		} else {
			return null;
		}
	}

	// ---------------------------------------------------------------------
	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CO_EVENT (");
		sqlStr.append("CO_SITE_CODE, CO_MODULE_CODE, CO_EVENT_ID, CO_EVENT_DESC, CO_EVENT_REMARK, CO_DEPARTMENT_CODE, ");
		sqlStr.append("CO_EVENT_CATEGORY, CO_EVENT_TYPE, CO_EVENT_TYPE2, CO_CREATED_USER, CO_MODIFIED_USER) ");
		sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
		sqlStr_insertEvent = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CRM_PROMOTION (");
		sqlStr.append("CRM_SITE_CODE, CRM_MODULE_CODE, CRM_EVENT_ID, CRM_DEPARTMENT_CODE1, CRM_TARGET1, CRM_DEPARTMENT_CODE2, ");
		sqlStr.append("CRM_TARGET2, CRM_DEPARTMENT_CODE3, CRM_TARGET3, CRM_INITIAL_DATE_FM, CRM_INITIAL_DATE_TO, CRM_PROMOTE_REMARKS, ");
		sqlStr.append("CRM_PROMOTE_DETAILS, CRM_PROMOTE_MATERIALS, CRM_REF_CODE, CRM_PROMOTE_COMMENT, CRM_CREATED_USER, ");
		sqlStr.append("CRM_CREATED_SITE_CODE, CRM_CREATED_DEPARTMENT_CODE, CRM_MODIFIED_USER, CRM_ENABLED) ");
		sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 1)");
		sqlStr_insertPromotion = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CRM_PROMOTION_INSTRUCTION (");
		sqlStr.append("CRM_SITE_CODE, CRM_MODULE_CODE, CRM_EVENT_ID, CRM_PROMO_INSTR_PID, CRM_PROMO_INSTR_CODE, CRM_PROMO_INSTR_REMARKS, ");
		sqlStr.append("CRM_CREATED_USER, CRM_MODIFIED_USER, CRM_ENABLED) ");
		sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', ?, ?, ?, ?, ?, ?, ?, 1)");
		sqlStr_insertInstruction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CRM_PROMOTION_ENQUIRY (");
		sqlStr.append("CRM_SITE_CODE, CRM_MODULE_CODE, CRM_EVENT_ID, CRM_PROMO_ENQ_PID, CRM_ENQUIRY, CRM_PHONE, ");
		sqlStr.append("CRM_CREATED_USER, CRM_MODIFIED_USER, CRM_ENABLED) ");
		sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', ?, ?, ?, ?, ?, ?, ?, 1)");
		sqlStr_insertEnquiry = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_EVENT ");
		sqlStr.append("SET    CO_EVENT_DESC = ?, CO_EVENT_REMARK = ?, CO_DEPARTMENT_CODE = ?, ");
		sqlStr.append("       CO_EVENT_CATEGORY = ?, CO_EVENT_TYPE = ?, CO_EVENT_TYPE2 = ?, ");
		sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_EVENT_ID = ? ");
		sqlStr_updateEvent = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CRM_PROMOTION ");
		sqlStr.append("SET    CRM_DEPARTMENT_CODE1 = ?, CRM_TARGET1 = ?, CRM_DEPARTMENT_CODE2 = ?, ");
		sqlStr.append("       CRM_TARGET2 = ?, CRM_DEPARTMENT_CODE3 = ?, CRM_TARGET3 = ?, ");
		sqlStr.append("       CRM_INITIAL_DATE_FM = ?, CRM_INITIAL_DATE_TO = ?, CRM_PROMOTE_REMARKS = ?, ");
		sqlStr.append("       CRM_PROMOTE_DETAILS = ?, CRM_PROMOTE_MATERIALS = ?, CRM_REF_CODE = ?, ");
		sqlStr.append("       CRM_PROMOTE_COMMENT = ?, CRM_CREATED_SITE_CODE = ?, CRM_CREATED_DEPARTMENT_CODE = ?, ");
		sqlStr.append("       CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CRM_MODULE_CODE = ? ");
		sqlStr.append("AND    CRM_EVENT_ID = ? ");
		sqlStr_updatePromotion = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CRM_PROMOTION_INSTRUCTION ");
		sqlStr.append("SET    CRM_PROMO_INSTR_CODE = ?, CRM_PROMO_INSTR_REMARKS = ?, ");
		sqlStr.append("       CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CRM_MODULE_CODE = ? ");
		sqlStr.append("AND    CRM_EVENT_ID = ? ");
		sqlStr.append("AND    CRM_PROMO_INSTR_PID = ? ");
		sqlStr_updateInstruction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CRM_PROMOTION_ENQUIRY ");
		sqlStr.append("SET    CRM_ENQUIRY = ?, CRM_PHONE = ?, ");
		sqlStr.append("       CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CRM_MODULE_CODE = ? ");
		sqlStr.append("AND    CRM_EVENT_ID = ? ");
		sqlStr.append("AND    CRM_PROMO_ENQ_PID = ? ");
		sqlStr_updateEnquiry = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_EVENT ");
		sqlStr.append("SET    CO_ENABLED = 0, CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_EVENT_ID = ?");
		sqlStr_deleteEvent = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CRM_PROMOTION ");
		sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CRM_MODULE_CODE = ? ");
		sqlStr.append("AND    CRM_EVENT_ID = ?");
		sqlStr_deletePromotion = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CRM_PROMOTION_INSTRUCTION ");
		sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CRM_MODULE_CODE = ? ");
		sqlStr.append("AND    CRM_EVENT_ID = ?");
		sqlStr_deleteInstruction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CRM_PROMOTION_INSTRUCTION ");
		sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CRM_MODULE_CODE = ? ");
		sqlStr.append("AND    CRM_EVENT_ID = ?");
		sqlStr.append("AND    CRM_PROMO_INSTR_PID = ?");
		sqlStr_deleteInstructionOne = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CRM_PROMOTION_ENQUIRY ");
		sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CRM_MODULE_CODE = ? ");
		sqlStr.append("AND    CRM_EVENT_ID = ?");
		sqlStr_deleteEnquiry = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CRM_PROMOTION_ENQUIRY ");
		sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    CRM_MODULE_CODE = ? ");
		sqlStr.append("AND    CRM_EVENT_ID = ?");
		sqlStr.append("AND    CRM_PROMO_ENQ_PID = ?");
		sqlStr_deleteEnquiryOne = sqlStr.toString();

	}
}