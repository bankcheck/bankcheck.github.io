/*
 * Created on April 8, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.UserBean;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class EvaluationDB {
	
	public static boolean isExist(UserBean userBean, String evaluationID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append(" FROM EE_EVALUATION_STAFF_ANSWER ");
		sqlStr.append(" WHERE EE_EVALUATION_ID = ? ");
		sqlStr.append(" AND EE_USER_ID = ? ");
		sqlStr.append(" AND EE_ENABLED = 1  ");


		return UtilDBWeb.isExist(sqlStr.toString(),
				new String[] { evaluationID, userBean.getStaffID() });
	}
	

	public static ArrayList getList(String eventID) {
		return getList(eventID, null);
	}

	public static ArrayList getList(String eventID, String evaluationID) {
		return getList(eventID, null, null);
	}
	
	public static ArrayList getList(String eventID, String evaluationID, String isFreeText) {
		// fetch summary
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT Q.EE_EVALUATION_ID, Q.EE_QUESTION, ");
		sqlStr.append("       Q.EE_EVALUATION_QID, ");
		sqlStr.append("       (SELECT COUNT(1) FROM EE_EVALUATION_STAFF_ANSWER A1 WHERE A1.EE_EVENT_ID = ? AND A1.EE_EVALUATION_QID = Q.EE_EVALUATION_QID AND A1.EE_EVALUATION_AID = 1), ");
		sqlStr.append("       (SELECT COUNT(1) FROM EE_EVALUATION_STAFF_ANSWER A2 WHERE A2.EE_EVENT_ID = ? AND A2.EE_EVALUATION_QID = Q.EE_EVALUATION_QID AND A2.EE_EVALUATION_AID = 2), ");
		sqlStr.append("       (SELECT COUNT(1) FROM EE_EVALUATION_STAFF_ANSWER A3 WHERE A3.EE_EVENT_ID = ? AND A3.EE_EVALUATION_QID = Q.EE_EVALUATION_QID AND A3.EE_EVALUATION_AID = 3), ");
		sqlStr.append("       (SELECT COUNT(1) FROM EE_EVALUATION_STAFF_ANSWER A4 WHERE A4.EE_EVENT_ID = ? AND A4.EE_EVALUATION_QID = Q.EE_EVALUATION_QID AND A4.EE_EVALUATION_AID = 4), ");
		sqlStr.append("       (SELECT COUNT(1) FROM EE_EVALUATION_STAFF_ANSWER A5 WHERE A5.EE_EVENT_ID = ? AND A5.EE_EVALUATION_QID = Q.EE_EVALUATION_QID AND A5.EE_EVALUATION_AID = 5), ");
		sqlStr.append("       (SELECT COUNT(1) FROM EE_EVALUATION_STAFF_ANSWER A6 WHERE A6.EE_EVENT_ID = ? AND A6.EE_EVALUATION_QID = Q.EE_EVALUATION_QID AND A6.EE_EVALUATION_AID = 6), ");
		sqlStr.append("       Q.EE_IS_FREE_TEXT ");
		sqlStr.append("FROM   EE_EVALUATION_QUESTION Q ");
		sqlStr.append("WHERE  Q.EE_ENABLED = 1 ");
		if (evaluationID != null) {
			sqlStr.append("	AND  Q.EE_EVALUATION_ID = " + evaluationID + " ");
		}
		if (isFreeText != null) {
			sqlStr.append("	AND  Q.EE_IS_FREE_TEXT = '" + isFreeText + "' ");
		}
		sqlStr.append("ORDER BY Q.EE_EVALUATION_ID, Q.EE_EVALUATION_QID, Q.EE_QUESTION ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { eventID, eventID, eventID, eventID, eventID, eventID });
	}
	
	public static ArrayList getList(String eventID, String evaluationID, String isFreeText, String  Year) {
		// fetch summary
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT Q.EE_EVALUATION_ID, Q.EE_QUESTION, ");
		sqlStr.append("       Q.EE_EVALUATION_QID, ");
		sqlStr.append("       (SELECT COUNT(1) FROM EE_EVALUATION_STAFF_ANSWER A1 WHERE A1.EE_EVENT_ID = ? AND A1.EE_EVALUATION_QID = Q.EE_EVALUATION_QID AND A1.EE_EVALUATION_AID = 1 AND to_char(ee_created_date,'YYYY') = '"+Year+"' ), ");
		sqlStr.append("       (SELECT COUNT(1) FROM EE_EVALUATION_STAFF_ANSWER A2 WHERE A2.EE_EVENT_ID = ? AND A2.EE_EVALUATION_QID = Q.EE_EVALUATION_QID AND A2.EE_EVALUATION_AID = 2 AND to_char(ee_created_date,'YYYY') = '"+Year+"' ), ");
		sqlStr.append("       (SELECT COUNT(1) FROM EE_EVALUATION_STAFF_ANSWER A3 WHERE A3.EE_EVENT_ID = ? AND A3.EE_EVALUATION_QID = Q.EE_EVALUATION_QID AND A3.EE_EVALUATION_AID = 3 AND to_char(ee_created_date,'YYYY') = '"+Year+"' ), ");
		sqlStr.append("       (SELECT COUNT(1) FROM EE_EVALUATION_STAFF_ANSWER A4 WHERE A4.EE_EVENT_ID = ? AND A4.EE_EVALUATION_QID = Q.EE_EVALUATION_QID AND A4.EE_EVALUATION_AID = 4 AND to_char(ee_created_date,'YYYY') = '"+Year+"' ), ");
		sqlStr.append("       (SELECT COUNT(1) FROM EE_EVALUATION_STAFF_ANSWER A5 WHERE A5.EE_EVENT_ID = ? AND A5.EE_EVALUATION_QID = Q.EE_EVALUATION_QID AND A5.EE_EVALUATION_AID = 5 AND to_char(ee_created_date,'YYYY') = '"+Year+"' ), ");
		sqlStr.append("       (SELECT COUNT(1) FROM EE_EVALUATION_STAFF_ANSWER A6 WHERE A6.EE_EVENT_ID = ? AND A6.EE_EVALUATION_QID = Q.EE_EVALUATION_QID AND A6.EE_EVALUATION_AID = 6 AND to_char(ee_created_date,'YYYY') = '"+Year+"' ), ");
		sqlStr.append("       Q.EE_IS_FREE_TEXT ");
		sqlStr.append("FROM   EE_EVALUATION_QUESTION Q ");
		sqlStr.append("WHERE  Q.EE_ENABLED = 1 ");
		if (evaluationID != null) {
			sqlStr.append("	AND  Q.EE_EVALUATION_ID = " + evaluationID + " ");
		}
		if (isFreeText != null) {
			sqlStr.append("	AND  Q.EE_IS_FREE_TEXT = '" + isFreeText + "' ");
		}
		sqlStr.append("ORDER BY Q.EE_EVALUATION_ID, Q.EE_EVALUATION_QID, Q.EE_QUESTION ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { eventID, eventID, eventID, eventID, eventID, eventID });
	}
	
	public static ArrayList getFreeTextList(String eventID) {
		return getFreeTextList(eventID, null);
	}
	
	public static ArrayList getFreeTextList(String eventID, String evaluationID) {
		// fetch free text question and answer
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT Q.EE_EVALUATION_ID, Q.EE_QUESTION, ");
		sqlStr.append("       Q.EE_EVALUATION_QID, ");
		sqlStr.append("       A.EE_EVALUATION_ANSWER_DESC ");
		sqlStr.append("FROM   EE_EVALUATION_QUESTION Q LEFT JOIN EE_EVALUATION_STAFF_ANSWER A ");
		sqlStr.append("	ON	  Q.EE_EVALUATION_ID = A.EE_EVALUATION_ID ");
		sqlStr.append("	AND	  Q.EE_EVALUATION_QID = A.EE_EVALUATION_QID ");
		sqlStr.append("WHERE  Q.EE_ENABLED = 1 ");
		sqlStr.append("	 AND  Q.EE_IS_FREE_TEXT = 'Y' ");
		sqlStr.append("	 AND  A.EE_SITE_CODE = ? ");
		sqlStr.append("	 AND  A.EE_MODULE_CODE = 'education' ");
		sqlStr.append("	 AND  A.EE_EVENT_ID = ? ");
		sqlStr.append("	 AND  A.EE_EVALUATION_ANSWER_DESC IS NOT NULL ");
		if (evaluationID != null) {
			sqlStr.append("	AND  Q.EE_EVALUATION_ID = " + evaluationID + " ");
		}
		sqlStr.append("ORDER BY Q.EE_EVALUATION_ID, Q.EE_EVALUATION_QID, Q.EE_QUESTION, A.EE_CREATED_DATE DESC ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { ConstantsServerSide.SITE_CODE, eventID });
	}

	public static ArrayList getAllQuestions(String evaluationID) {
		// fetch all question
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EE_EVALUATION_QID, EE_QUESTION, EE_IS_FREE_TEXT ");
		sqlStr.append("FROM   EE_EVALUATION_QUESTION ");
		sqlStr.append("WHERE  EE_ENABLED = 1 ");
		sqlStr.append("AND    EE_EVALUATION_ID = ? ");
		sqlStr.append("ORDER BY EE_EVALUATION_QID");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { evaluationID });
	}
	
	public static ArrayList getAllAnswer(String evaluationID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EE_EVALUATION_QID, EE_EVALUATION_AID, EE_ANSWER, EE_ISFREETEXT ");
		sqlStr.append("FROM   EE_EVALUATION_ANSWER ");
		sqlStr.append("WHERE  EE_ENABLED = 1 ");
		sqlStr.append("AND    EE_SITE_CODE = ? ");
		sqlStr.append("AND    EE_EVALUATION_ID = ? ");
		sqlStr.append("ORDER BY EE_EVALUATION_QID, EE_EVALUATION_AID");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { ConstantsServerSide.SITE_CODE, evaluationID });
	}
	
	public static ArrayList getAllAnswer(String evaluationID,String questionID) {
		// fetch all question
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EE_EVALUATION_AID,EE_ANSWER,EE_ISFREETEXT ");
		sqlStr.append("FROM   EE_EVALUATION_ANSWER ");
		sqlStr.append("WHERE  EE_ENABLED = 1 ");
		sqlStr.append("AND    EE_EVALUATION_ID = ? ");
		sqlStr.append("AND 	  EE_EVALUATION_QID = ? ");
		sqlStr.append("ORDER BY EE_EVALUATION_AID");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { evaluationID,questionID });
	}

	public static boolean addStaffResultAnswer(
			UserBean userBean, String eventID, String elearningID, String evaluationID, String enrollID,
			String evaluationQID, String evaluationAID, String evaluationDesc) {
		try {
			Integer.parseInt(evaluationAID);
		} catch (NumberFormatException nfe) {
			evaluationAID = "-1";
		}
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO EE_EVALUATION_STAFF_ANSWER (");
		sqlStr.append("EE_SITE_CODE, EE_MODULE_CODE, EE_EVENT_ID, EE_ENROLL_ID, ");
		sqlStr.append("EE_ELEARNING_ID, EE_EVALUATION_ID, EE_EVALUATION_QID, EE_EVALUATION_AID, ");
		sqlStr.append("EE_EVALUATION_ANSWER_DESC, ");
		sqlStr.append("EE_USER_TYPE, EE_USER_ID, EE_CREATED_USER, EE_MODIFIED_USER) ");
		sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', 'education', ?, ?, ");
		sqlStr.append("?, ?, ?, ?, ");
		sqlStr.append("?, ");
		sqlStr.append("'staff', ?, ?, ?)");

		// insert evaluation record
		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { eventID, enrollID,
					elearningID, evaluationID, evaluationQID, evaluationAID, evaluationDesc,
					userBean.getStaffID(), userBean.getLoginID(), userBean.getLoginID() });
	}
	
	public static boolean addCRMResultAnswer(
			UserBean userBean, String eventID, String elearningID, String evaluationID, String enrollID,
			String evaluationQID, String evaluationAID, String evaluationDesc) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO EE_EVALUATION_STAFF_ANSWER (");
		sqlStr.append("EE_SITE_CODE, EE_MODULE_CODE, EE_EVENT_ID, EE_ENROLL_ID, ");
		sqlStr.append("EE_ELEARNING_ID, EE_EVALUATION_ID, EE_EVALUATION_QID, EE_EVALUATION_AID, ");
		sqlStr.append("EE_EVALUATION_ANSWER_DESC, ");
		sqlStr.append("EE_USER_TYPE, EE_USER_ID, EE_CREATED_USER, EE_MODIFIED_USER) ");
		sqlStr.append("VALUES ('" + ConstantsServerSide.SITE_CODE + "', 'lmc.crm', ?, ?, ");
		sqlStr.append("?, ?, ?, ?, ");
		sqlStr.append("?, ");
		sqlStr.append("'guest', ?, ?, ?)");

		// insert evaluation record
		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { eventID, enrollID,
					elearningID, evaluationID, evaluationQID, evaluationAID, evaluationDesc,
					userBean.getUserName(), userBean.getUserName(), userBean.getUserName() });
	}
	
	public static boolean addEvaluationScore(
			UserBean userBean, String evaluationID,String staffID,String userType,
			String evaluationQID, String evaluationAID, String evaluationDesc) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO EE_EVALUATION_STAFF_ANSWER (");
		sqlStr.append("EE_SITE_CODE, EE_MODULE_CODE, EE_EVENT_ID, EE_ENROLL_ID, ");
		sqlStr.append("EE_ELEARNING_ID, EE_EVALUATION_ID, EE_EVALUATION_QID, EE_EVALUATION_AID, ");
		sqlStr.append("EE_EVALUATION_ANSWER_DESC, ");
		sqlStr.append("EE_USER_TYPE, EE_USER_ID, EE_CREATED_USER, EE_MODIFIED_USER) ");
		sqlStr.append("VALUES ('" +userBean.getSiteCode()  + "', 'appraisal', '6306', ?, ");
		sqlStr.append("?, '4', ?, ?, ");
		sqlStr.append("?, ");
		sqlStr.append("?, ?, ?, ?)");
		// insert evaluation record
		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {staffID,
					evaluationID, evaluationQID, evaluationAID, evaluationDesc,
					userType,userBean.getLoginID(), userBean.getLoginID(), userBean.getLoginID() });
	}

	public static boolean deleteEvaluationScore(
			UserBean userBean,String appraisalID,String userType,
			String evaluationQID, String evaluationAID,String staffID) {
		StringBuffer sqlStr =  new StringBuffer();
		sqlStr.append("DELETE EE_EVALUATION_STAFF_ANSWER ");
		sqlStr.append("WHERE EE_SITE_CODE = '"+userBean.getSiteCode()+"'");
		sqlStr.append("	AND EE_MODULE_CODE = 'appraisal' ");
		sqlStr.append("	AND EE_EVENT_ID = 6306 ");
		sqlStr.append("	AND EE_ENROLL_ID = "+staffID);
		sqlStr.append("	AND EE_EVALUATION_ID = 4 ");
		sqlStr.append("	AND EE_EVALUATION_QID = "+evaluationQID);
		sqlStr.append("	AND EE_USER_TYPE = '"+userType+"'");
		sqlStr.append("	AND EE_ELEARNING_ID = "+appraisalID );
		sqlStr.append("	AND EE_ENABLED = 1 ");
		// delete evaluation record
		return UtilDBWeb.updateQueue(
				sqlStr.toString());
	}
	
	public static ArrayList getStaffResultAnswer(String eventID, String elearningID, String evaluationID, String enrollID, String userType, String userID) {
		// fetch staff answer
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EE_EVALUATION_ID, EE_EVALUATION_QID, EE_EVALUATION_AID, EE_EVALUATION_ANSWER_DESC, EE_USER_TYPE ");
		sqlStr.append("FROM   EE_EVALUATION_STAFF_ANSWER ");
		sqlStr.append("WHERE  EE_ENABLED = 1 ");
		sqlStr.append("AND    EE_EVENT_ID = ? ");
		sqlStr.append("AND    EE_EVALUATION_ID = ? ");
		sqlStr.append("AND    EE_ENROLL_ID = ? ");
		if(userType != null && !"".equals(userType)){
		sqlStr.append("AND    EE_USER_TYPE =  '"+ userType +"' " );
		}
		if(userID != null && !"".equals(userID)){
		sqlStr.append(" AND    EE_USER_ID =  '"+ userID +"' ");
		}
		sqlStr.append(" ORDER BY EE_EVALUATION_QID, EE_EVALUATION_AID");
		
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { eventID, evaluationID, enrollID});
	}
	
	public static ArrayList getAllStaffResultAnswer(String eventID, String elearningID, String evaluationID, String userType, String userID) {
		// fetch staff answer
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT SA.EE_ENROLL_ID, SA.EE_EVALUATION_QID, SA.EE_EVALUATION_AID, A.EE_ANSWER, SA.EE_USER_TYPE, SA.EE_USER_ID, SA.EE_EVALUATION_SITE, SA.EE_EVALUATION_ANSWER_DESC, A.EE_ISFREETEXT ");
		sqlStr.append("FROM   EE_EVALUATION_STAFF_ANSWER SA LEFT JOIN EE_EVALUATION_ANSWER A");
		sqlStr.append("  ON	  SA.EE_SITE_CODE = A.EE_SITE_CODE AND SA.EE_EVALUATION_ID = A.EE_EVALUATION_ID ");
		sqlStr.append("   AND SA.EE_EVALUATION_QID = A.EE_EVALUATION_QID AND SA.EE_EVALUATION_AID = A.EE_EVALUATION_AID ");
		sqlStr.append("WHERE  SA.EE_ENABLED = 1 ");
		sqlStr.append("AND    A.EE_ENABLED = 1 ");
		sqlStr.append("AND    SA.EE_EVENT_ID = ? ");
		sqlStr.append("AND    SA.EE_ELEARNING_ID = ? ");
		sqlStr.append("AND    SA.EE_EVALUATION_ID = ? ");
		if(userType != null && !"".equals(userType)){
			sqlStr.append("AND    SA.EE_USER_TYPE = '"+ userType + "' " );
		}
		if(userID != null && !"".equals(userID)){
			sqlStr.append("AND    SA.EE_USER_ID = '"+ userID + "' " );
		}
		sqlStr.append(" ORDER BY SA.EE_ENROLL_ID, SA.EE_EVALUATION_QID, SA.EE_EVALUATION_AID");
		
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { eventID, elearningID, evaluationID});
	}
	
	public static ArrayList getStaffResultAnswer(String eventID, String elearningID, String evaluationID, String enrollID, String userType, String userID,String questionID) {
		// fetch staff answer
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT EE_EVALUATION_ID, EE_EVALUATION_QID, EE_EVALUATION_AID, EE_EVALUATION_ANSWER_DESC, EE_USER_TYPE ");
		sqlStr.append("FROM   EE_EVALUATION_STAFF_ANSWER ");
		sqlStr.append("WHERE  EE_ENABLED = 1 ");
		sqlStr.append("AND    EE_EVENT_ID = ? ");
		sqlStr.append("AND    EE_EVALUATION_ID = ? ");
		sqlStr.append("AND    EE_ENROLL_ID = ? ");
		sqlStr.append("AND    EE_EVALUATION_QID = ? ");
		if(userType != null && !"".equals(userType)){
		sqlStr.append("AND    EE_USER_TYPE =  "+ userType );
		}
		if(userID != null && !"".equals(userID)){
		sqlStr.append(" AND    EE_USER_ID =  "+ userID);
		}
		sqlStr.append(" ORDER BY EE_EVALUATION_QID, EE_EVALUATION_AID");
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { eventID, evaluationID, enrollID,questionID});
	}
	
	public static ArrayList getNextEnrollID(String eventID, String evaluationID) {
		// fetch enrollID
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 		MAX(EE_ENROLL_ID) + 1 ");
		sqlStr.append("FROM   		EE_EVALUATION_STAFF_ANSWER ");
		sqlStr.append("WHERE  		EE_EVENT_ID = ? ");
		sqlStr.append("AND    		EE_EVALUATION_ID = ? ");
		sqlStr.append("GROUP BY     EE_EVENT_ID, EE_EVALUATION_ID ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { eventID, evaluationID});
	}
	
	public static boolean addAnonymousResultAnswer(
			String siteCode, String eventID, String elearningID, String evaluationID, String enrollID,
			String evaluationQID, String evaluationAID, String evaluationSite) {
		return addAnonymousResultAnswer(siteCode, eventID, elearningID, evaluationID, enrollID,
				evaluationQID, evaluationAID, null, evaluationSite);
	}
	
	public static boolean addAnonymousResultAnswer(
			String siteCode, String eventID, String elearningID, String evaluationID, String enrollID,
			String evaluationQID, String evaluationAID, String evaluationAnswerDesc, String evaluationSite) {
		return addAnonymousResultAnswer(siteCode, eventID, elearningID, evaluationID, enrollID, evaluationQID, evaluationAID, 
				evaluationAnswerDesc, evaluationSite, null);
	}
	public static boolean addAnonymousResultAnswer(
			String siteCode, String eventID, String elearningID, String evaluationID, String enrollID,
			String evaluationQID, String evaluationAID, String evaluationAnswerDesc, String evaluationSite, String userType) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO EE_EVALUATION_STAFF_ANSWER (");
		sqlStr.append("EE_SITE_CODE, EE_MODULE_CODE, EE_EVENT_ID, EE_ENROLL_ID, ");
		sqlStr.append("EE_ELEARNING_ID, EE_EVALUATION_ID, EE_EVALUATION_QID, EE_EVALUATION_AID, EE_EVALUATION_ANSWER_DESC, EE_EVALUATION_SITE, ");
		sqlStr.append("EE_USER_TYPE, EE_USER_ID, EE_CREATED_USER, EE_MODIFIED_USER) ");
		sqlStr.append("VALUES (?, 'education', ?, ?, ");
		sqlStr.append("?, ?, ?, ?, ?, ?,");
		sqlStr.append("?, 'anonymous', 'anonymous', 'anonymous')");

		// insert evaluation record
		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { siteCode, eventID, enrollID,
					elearningID, evaluationID, evaluationQID, evaluationAID, evaluationAnswerDesc, evaluationSite, userType});
	}
	
	public static ArrayList getsurveyreport(String evaluationID,String evaluationSITE,String ee_is_free_text, String q1, String q2, String q3, String q4, String q5, String q6)
	{
		StringBuffer sqlStr = new StringBuffer();
		String SITEvalue;
		if(evaluationSITE == null)
		{
		 SITEvalue = "is null";
		}
		else
		{
		 SITEvalue = "='"+evaluationSITE+"'";
		}
		sqlStr.append("SELECT Q.EE_EVALUATION_QID, EE_QUESTION");
		sqlStr.append(",COALESCE(ANS"+q1+".ANSWER,0) ANSWER_"+q1);
		sqlStr.append(",COALESCE(ANS"+q2+".ANSWER,0) ANSWER_"+q2);
		sqlStr.append(",COALESCE(ANS"+q3+".ANSWER,0) ANSWER_"+q3);
		sqlStr.append(",COALESCE(ANS"+q4+".ANSWER,0) ANSWER_"+q4);
		sqlStr.append(",COALESCE(ANS"+q5+".ANSWER,0) ANSWER_"+q5);
		sqlStr.append(",COALESCE(ANS"+q6+".ANSWER,0) ANSWER_"+q6);	
		sqlStr.append(" FROM (SELECT EE_EVALUATION_QID FROM EE_EVALUATION_QUESTION WHERE EE_EVALUATION_ID = "+evaluationID+" and ee_is_free_text = '"+ee_is_free_text+"') Q");		
		sqlStr.append(" LEFT JOIN(");
		sqlStr.append(" SELECT EE_EVALUATION_QID,EE_QUESTION");
		sqlStr.append(" FROM EE_EVALUATION_QUESTION");
		sqlStr.append(" WHERE EE_EVALUATION_ID = "+evaluationID);
		sqlStr.append(" )QUEST ON Q.EE_EVALUATION_QID = QUEST.EE_EVALUATION_QID");		
		sqlStr.append(" LEFT JOIN(SELECT EE_EVALUATION_QID, COUNT(*) ANSWER");
		sqlStr.append(" FROM (SELECT EE_EVALUATION_QID, EE_EVALUATION_AID,EE_EVALUATION_SITE FROM EE_EVALUATION_STAFF_ANSWER");
		sqlStr.append(" WHERE EE_EVALUATION_SITE "+SITEvalue+" and EE_EVALUATION_ID = "+evaluationID+" and EE_EVENT_ID = -1 ORDER BY EE_EVALUATION_QID) E"); 
		sqlStr.append(" WHERE EE_EVALUATION_AID = "+q1+" GROUP BY EE_EVALUATION_QID ORDER BY EE_EVALUATION_QID ) ANS"+q1+" ON Q.EE_EVALUATION_QID = ANS"+q1+".EE_EVALUATION_QID ");
		sqlStr.append(" LEFT JOIN( SELECT EE_EVALUATION_QID, COUNT(*) ANSWER");
		sqlStr.append(" FROM(SELECT EE_EVALUATION_QID,EE_EVALUATION_AID,EE_EVALUATION_SITE FROM EE_EVALUATION_STAFF_ANSWER WHERE EE_EVALUATION_SITE "+SITEvalue+" AND EE_EVALUATION_ID = "+evaluationID+" AND EE_EVENT_ID = -1 ORDER BY EE_EVALUATION_QID ) E");
		sqlStr.append(" WHERE EE_EVALUATION_AID = "+q2+" GROUP BY EE_EVALUATION_QID ORDER BY EE_EVALUATION_QID) ANS"+q2+" ON Q.EE_EVALUATION_QID = ANS"+q2+".EE_EVALUATION_QID");
		sqlStr.append(" LEFT JOIN( SELECT EE_EVALUATION_QID, COUNT(*) ANSWER FROM (");
		sqlStr.append(" SELECT EE_EVALUATION_QID,EE_EVALUATION_AID, EE_EVALUATION_SITE FROM EE_EVALUATION_STAFF_ANSWER WHERE EE_EVALUATION_SITE "+SITEvalue+" AND EE_EVALUATION_ID = "+evaluationID+" AND EE_EVENT_ID = -1 ORDER BY EE_EVALUATION_QID) E");
		sqlStr.append(" WHERE EE_EVALUATION_AID = "+q3+" GROUP BY EE_EVALUATION_QID ORDER BY EE_EVALUATION_QID) ANS"+q3+" ON Q.EE_EVALUATION_QID = ANS"+q3+".EE_EVALUATION_QID");
		sqlStr.append(" LEFT JOIN( SELECT EE_EVALUATION_QID, COUNT(*) ANSWER FROM (");
		sqlStr.append(" SELECT EE_EVALUATION_QID, EE_EVALUATION_AID, EE_EVALUATION_SITE FROM EE_EVALUATION_STAFF_ANSWER WHERE EE_EVALUATION_SITE "+SITEvalue+" AND EE_EVALUATION_ID = "+evaluationID+" AND EE_EVENT_ID = -1 ORDER BY EE_EVALUATION_QID ) E");
		sqlStr.append(" WHERE EE_EVALUATION_AID = "+q4+" GROUP BY EE_EVALUATION_QID ORDER BY EE_EVALUATION_QID) ANS"+q4+" ON Q.EE_EVALUATION_QID = ANS"+q4+".EE_EVALUATION_QID");
		sqlStr.append(" LEFT JOIN( SELECT EE_EVALUATION_QID, COUNT(*) ANSWER FROM (");
		sqlStr.append(" SELECT EE_EVALUATION_QID, EE_EVALUATION_AID, EE_EVALUATION_SITE FROM EE_EVALUATION_STAFF_ANSWER WHERE EE_EVALUATION_SITE "+SITEvalue+" AND EE_EVALUATION_ID = "+evaluationID+" AND EE_EVENT_ID = -1 ORDER BY EE_EVALUATION_QID ) E");
		sqlStr.append(" WHERE EE_EVALUATION_AID = "+q5+" GROUP BY EE_EVALUATION_QID ORDER BY EE_EVALUATION_QID) ANS"+q5+" ON Q.EE_EVALUATION_QID = ANS"+q5+".EE_EVALUATION_QID");
		sqlStr.append(" LEFT JOIN( SELECT EE_EVALUATION_QID, COUNT(*) ANSWER FROM (");
		sqlStr.append(" SELECT EE_EVALUATION_QID, EE_EVALUATION_AID, EE_EVALUATION_SITE FROM EE_EVALUATION_STAFF_ANSWER WHERE EE_EVALUATION_SITE "+SITEvalue+" AND EE_EVALUATION_ID = "+evaluationID+" AND EE_EVENT_ID = -1 ORDER BY EE_EVALUATION_QID ) E");
		sqlStr.append(" WHERE EE_EVALUATION_AID = "+q6+" GROUP BY EE_EVALUATION_QID ORDER BY EE_EVALUATION_QID) ANS"+q6+" ON Q.EE_EVALUATION_QID = ANS"+q6+".EE_EVALUATION_QID");
		sqlStr.append(" ORDER BY Q.EE_EVALUATION_QID");
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getsurveyreporttext(String evaluationID,String evaluationSITE,String q1)
	{ 
		StringBuffer sqlStr = new StringBuffer();
		String SITEvalue;
		if(evaluationSITE == null)
		{
		 SITEvalue = "is null";
		}
		else
		{
		 SITEvalue = "='"+evaluationSITE+"'";
		}
		sqlStr.append("SELECT EE_EVALUATION_ANSWER_DESC FROM");
		sqlStr.append(" EE_EVALUATION_STAFF_ANSWER WHERE EE_EVALUATION_ID = "+evaluationID);
		sqlStr.append(" and EE_EVALUATION_QID = "+q1);
		sqlStr.append(" and ee_evaluation_site "+ SITEvalue);
		sqlStr.append(" and EE_EVALUATION_ANSWER_DESC IS NOT NULL");
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
}