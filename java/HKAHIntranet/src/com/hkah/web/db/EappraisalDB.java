package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsVariable;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;


public class EappraisalDB {

	private static String sqlStr_getQuestionList = null;
	private static String sqlStr_addEvaluation = null;
	private static String sqlStr_getRecord = null;
	public static ArrayList getQuestionList() {

		return UtilDBWeb.getReportableList(
				sqlStr_getQuestionList);
	}

	public static ArrayList get(String evaluationID, UserBean userBean, String staffID) {
		
		return UtilDBWeb.getReportableList(
				sqlStr_getRecord,
				new String[] {evaluationID, userBean.getSiteCode(),staffID} );
	}
	
	private static String getNextEvaluationID(String siteCode){
		String evaluationID = null;
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(EA_APPRAISAL_ID) + 1 FROM EA_APPRAISAL WHERE EA_SITE_CODE = ? AND EA_ENABLED = 1 ",
				new String[] { siteCode});
		
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			evaluationID = reportableListObject.getValue(0);
			
			if (evaluationID == null || evaluationID.length() == 0) return ConstantsVariable.ONE_VALUE;		
		}
		return evaluationID;
	}
	
	public static String add(UserBean userBean,String appraisedYear, String deptCode, String staffID)
	{
		String evaluationID = getNextEvaluationID(userBean.getSiteCode());
		
		if (UtilDBWeb.updateQueue(
				sqlStr_addEvaluation,
				new String[]{userBean.getSiteCode(),evaluationID,staffID,appraisedYear,userBean.getLoginID(),userBean.getLoginID() }  ))
		{ 
			return evaluationID;
		}else{
			return null;
		}
		
	}
	
	public static boolean update(UserBean userBean, String appraisedYear, String deptCode,
			String staffID, String evaluationType, String[] appraisedPoint, String[] staffPoint,
			String staffTotal, String appraisedTotal, String appraiserComment, String performObj,
			String employeeComment,String evaluationID){
		
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE EA_APPRAISAL ");
			sqlStr.append(" SET EA_TYPE = ? ");
			if(staffTotal != null){
				sqlStr.append(" , EA_EMPLOYEE_POINTS = ? ");
			}
			if(appraisedTotal != null){
				sqlStr.append(", EA_APPRAISER_POINTS = ? ");
			}
			sqlStr.append("WHERE EA_SITE_CODE = ? ");
			sqlStr.append("AND EA_APPRAISAL_YEAR = ? ");
			sqlStr.append("AND EA_APPRAISED_STAFF_ID = ? ");
			sqlStr.append("AND EA_APPRAISAL_ID = ? ");
			sqlStr.append("AND EA_ENABLED = 1 ");
		
			if(UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[]{evaluationType, staffTotal, appraisedTotal, userBean.getSiteCode(),"2011",staffID,evaluationID})){
				if(staffPoint != null){
					for(int i=0;i<staffPoint.length;i++){
						Integer temp = i+1;
						EvaluationDB.deleteEvaluationScore(userBean,evaluationID,"staff",temp.toString(),staffPoint[i],staffID);
						EvaluationDB.addEvaluationScore(userBean, evaluationID,staffID,"staff",temp.toString(), staffPoint[i],"");
					}
				}	
				if(appraisedPoint != null){
					for(int i=0;i<appraisedPoint.length;i++){
						Integer temp = i+1;
						EvaluationDB.deleteEvaluationScore(userBean,evaluationID,"appraiser",temp.toString(),appraisedPoint[i],staffID);
						EvaluationDB.addEvaluationScore(userBean, evaluationID,staffID,"appraiser",temp.toString(), appraisedPoint[i],"");
					}
				}
				if(appraiserComment != null){
					EvaluationDB.deleteEvaluationScore(userBean,evaluationID,"appraiser","14","14",staffID);
					EvaluationDB.addEvaluationScore(userBean, evaluationID,staffID,"appraiser","14","14", appraiserComment);
				}
				if(employeeComment != null){
					EvaluationDB.deleteEvaluationScore(userBean,evaluationID,"staff","16","16",staffID);
					EvaluationDB.addEvaluationScore(userBean, evaluationID,staffID,"staff","16","16", employeeComment);	
				}
				if(performObj!= null){
					EvaluationDB.deleteEvaluationScore(userBean,evaluationID,"appraiser","15","15",staffID);
					EvaluationDB.addEvaluationScore(userBean, evaluationID,staffID,"appraiser","15","15", performObj);				
				}
				return true;
			} else {
				return false;
			}
			
	}
	
	public static boolean appraiserApprove(UserBean userBean, String appraisalID, String appraisedStaffID){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE EA_APPRAISAL ");
		sqlStr.append("SET  EA_APPROVED_APPRAISER ='"+userBean.getStaffID()+"'");
		sqlStr.append(" ,EA_APPRAISER_APPROVED_DATE = SYSDATE ");
		sqlStr.append(" ,EA_MODIFIED_DATE = SYSDATE, EA_MODIFIED_USER='"+userBean.getLoginID()+"'");
		sqlStr.append(" WHERE EA_SITE_CODE='"+userBean.getSiteCode()+"'");
		sqlStr.append(" AND EA_APPRAISAL_ID='"+appraisalID+"'");
		sqlStr.append(" AND EA_APPRAISED_STAFF_ID ='"+appraisedStaffID+"'");
		sqlStr.append(" AND EA_ENABLED = 1 ");
		
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
	
	public static boolean employeeApprove(UserBean userBean, String appraisalID){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE EA_APPRAISAL ");
		sqlStr.append(" SET  EA_STAFF_APPROVED_DATE = SYSDATE ");
		sqlStr.append(" ,EA_MODIFIED_DATE = SYSDATE, EA_MODIFIED_USER='"+userBean.getStaffID()+"'");
		sqlStr.append(" WHERE EA_SITE_CODE='"+userBean.getSiteCode()+"'");
		sqlStr.append(" AND EA_APPRAISAL_ID='"+appraisalID+"'");
		sqlStr.append(" AND EA_APPRAISED_STAFF_ID ='"+userBean.getStaffID()+"'");
		sqlStr.append(" AND EA_ENABLED = 1 ");
		
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
	
	public static boolean supervisorApprove(UserBean userBean, String appraisalID, String appraisedStaffID){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE EA_APPRAISAL ");
		sqlStr.append("SET  EA_SUPERVISOR ='"+userBean.getStaffID()+"'");
		sqlStr.append(" ,EA_SUPERVISOR_REVIEW_DATE = SYSDATE ");
		sqlStr.append(" ,EA_MODIFIED_DATE = SYSDATE, EA_MODIFIED_USER='"+userBean.getStaffID()+"'");
		sqlStr.append(" WHERE EA_SITE_CODE='"+userBean.getSiteCode()+"'");
		sqlStr.append(" AND EA_APPRAISAL_ID='"+appraisalID+"'");
		sqlStr.append(" AND EA_APPRAISED_STAFF_ID ='"+appraisedStaffID+"'");
		sqlStr.append(" AND EA_ENABLED = 1 ");
		
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
	
	public static String getAppraisalID(String staffID, String Year){

		String appraisalID = null;
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT EA_APPRAISAL_ID FROM EA_APPRAISAL WHERE EA_APPRAISED_STAFF_ID = ? AND EA_APPRAISAL_YEAR = ? AND EA_ENABLED = 1",
				new String[] { staffID,Year});
		
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			appraisalID = reportableListObject.getValue(0);
				
		}
		return appraisalID;
	}
	
	static {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.setLength(0);
		sqlStr.append("SELECT EE_EVALUATION_QID, EE_QUESTION ");
		sqlStr.append("FROM EE_EVALUATION_QUESTION  ");
		sqlStr.append("WHERE EE_ENABLED = 1 AND EE_EVALUATION_ID = 4 AND EE_EVALUATION_QID < 14 ORDER BY EE_EVALUATION_QID ");
		sqlStr_getQuestionList = sqlStr.toString();
		
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT EA_APPRAISAL_ID,EA_APPRAISED_STAFF_ID,EA_APPRAISAL_YEAR, ");
		sqlStr.append(" EA_TYPE, EA_EMPLOYEE_POINTS, EA_APPRAISER_POINTS,EA_APPROVED_APPRAISER, ");
		sqlStr.append(" TO_CHAR(EA_APPRAISER_APPROVED_DATE, 'dd/MM/YYYY'),TO_CHAR( EA_STAFF_APPROVED_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append(" EA_SUPERVISOR, TO_CHAR( EA_SUPERVISOR_REVIEW_DATE, 'dd/MM/YYYY') ");
		sqlStr.append(" FROM EA_APPRAISAL ");
		sqlStr.append(" WHERE EA_APPRAISAL_ID = ? ");
		sqlStr.append(" AND EA_SITE_CODE = ? ");
		sqlStr.append(" AND EA_APPRAISED_STAFF_ID = ? ");
		sqlStr.append(" AND EA_ENABLED = 1 ");
		sqlStr_getRecord = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO EA_APPRAISAL ");
		sqlStr.append(" (EA_SITE_CODE, EA_APPRAISAL_ID, EA_APPRAISED_STAFF_ID, ");
		sqlStr.append("EA_APPRAISAL_YEAR, ");
		sqlStr.append(" EA_CREATE_USER, EA_MODIFIED_USER ");
		sqlStr.append(" )");
		sqlStr.append(" VALUES(?,?,?, ");
		sqlStr.append("?, ");
		sqlStr.append("?,?)");
		sqlStr_addEvaluation = sqlStr.toString();
		
	}
}