package com.hkah.web.db;

import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.Vector;

import com.hkah.config.MessageResources;
import com.hkah.constant.ConstantsErrorMessage;
import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class FsDB {
	private static String sqlStr_insertFsLog = null;
	private static String serverSiteCode = ConstantsServerSide.SITE_CODE;
    // at which it was allocated, measured to the nearest millisecond.
	private Date dateNow = new Date ();
    private SimpleDateFormat sdf = new SimpleDateFormat("ddMMyyyyHHmmss");
    private String currDate = sdf.format(dateNow);

    public static ArrayList getReqRecord(String reqNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT "); 
		sqlStr.append("REQ_NO, ");
		sqlStr.append("TO_CHAR(REQ_DATE,'DD/MM/YYYY') AS REQ_DATE, ");
		sqlStr.append("REQ_BY, ");
		sqlStr.append("TO_CHAR(SERV_DATE_START,'DD/MM/YYYY') AS SERV_DATE, ");
		sqlStr.append("TO_CHAR(SERV_DATE_START,'HH24:MI') AS SERV_START_TIME, ");
		sqlStr.append("TO_CHAR(SERV_DATE_END,'HH24:MI') AS SERV_END_TIME, ");
		sqlStr.append("REQ_SITE_CODE, ");
		sqlStr.append("REQ_DEPT_CODE, ");
		sqlStr.append("CHARGE_TO, ");
		sqlStr.append("VENUE_ID, ");
		sqlStr.append("VENUE, ");
		sqlStr.append("REQ_STATUS, ");
		sqlStr.append("PURPOSE, ");
		sqlStr.append("AMOUNT, ");
		sqlStr.append("NO_OF_PERSON, ");
		sqlStr.append("MEAL_TYPE, ");
		sqlStr.append("MENU, ");
		sqlStr.append("REMARKS, ");
		sqlStr.append("SEND_APPROVAL, ");
		sqlStr.append("INS_BY, ");
		sqlStr.append("INS_DATE, ");
		sqlStr.append("MOD_BY, ");
		sqlStr.append("MOD_DATE, ");
		sqlStr.append("APPROVE_FLAG, ");
		sqlStr.append("APPROVED_BY, ");
		sqlStr.append("APPROVED_DATE, ");
		sqlStr.append("POST_DATE, ");
		sqlStr.append("INSTANCE_ID, ");
		sqlStr.append("PRICE_RANGE, ");
		sqlStr.append("MEAL_EVENT, ");		
		sqlStr.append("REQUEST_TYPE, ");
		sqlStr.append("OTHERMEAL, ");		
		sqlStr.append("CONTACTTEL, ");
		sqlStr.append("CHARGE_AMOUNT, ");
		sqlStr.append("OTHERREQ, ");
		sqlStr.append("OTHERCHARGE, ");
		sqlStr.append("SEND_COUNT ");		
		sqlStr.append("FROM FS_REQUEST ");
		sqlStr.append("WHERE REQ_NO = '");
		sqlStr.append(reqNo);
		sqlStr.append("'");
		System.err.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

    public static ArrayList getReqRecordWithDtl(String reqNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT "); 
		sqlStr.append("FR.REQ_NO, ");
		sqlStr.append("TO_CHAR(FR.REQ_DATE,'DD/MM/YYYY') AS REQ_DATE, ");		
		sqlStr.append("FR.REQ_BY, ");
		sqlStr.append("TO_CHAR(FR.SERV_DATE_START,'DD/MM/YYYY') AS SERV_DATE, ");
		sqlStr.append("TO_CHAR(FR.SERV_DATE_START,'HH24:MI') AS SERV_START_TIME, ");
		sqlStr.append("TO_CHAR(FR.SERV_DATE_END,'HH24:MI') AS SERV_END_TIME, ");
		sqlStr.append("FR.REQ_SITE_CODE, ");
		sqlStr.append("(SELECT D.CO_DEPARTMENT_DESC FROM CO_DEPARTMENTS D WHERE FR.REQ_DEPT_CODE=D.CO_DEPARTMENT_CODE) AS REQ_DEPT_CODE, ");		
		sqlStr.append("FR.CHARGE_TO, (");
		sqlStr.append("SELECT C.CO_EVENT_DESC ");
		sqlStr.append("FROM   CO_EVENT C ");
		sqlStr.append("WHERE  UPPER(C.CO_SITE_CODE) = UPPER('" + ConstantsServerSide.SITE_CODE + "') ");
		sqlStr.append("AND    C.CO_MODULE_CODE = 'foodOrder' ");
		sqlStr.append("AND    C.CO_ENABLED = 1 ");
		sqlStr.append("AND    C.CO_EVENT_ID = FR.VENUE_ID) AS VENUE_ID, ");
		sqlStr.append("FR.VENUE, ");
		sqlStr.append("FR.REQ_STATUS, ");
		sqlStr.append("FR.PURPOSE, ");
		sqlStr.append("FR.AMOUNT, ");
		sqlStr.append("FR.NO_OF_PERSON, ");
		sqlStr.append("(SELECT FM.MEAL_DESC FROM FS_MEAL FM WHERE FM.MEAL_TYPE='TYPE' AND FR.MEAL_TYPE = FM.MEAL_ID) AS MEAL_TYPE, ");
		sqlStr.append("FR.MENU, ");
		sqlStr.append("FR.REMARKS, ");
		sqlStr.append("(SELECT CU.CO_FIRSTNAME||' '||CU.CO_LASTNAME FROM CO_USERS CU WHERE CU.CO_STAFF_ID=FR.SEND_APPROVAL) AS SEND_APPROVAL, ");
		sqlStr.append("FR.INS_BY, ");
		sqlStr.append("FR.INS_DATE, ");
		sqlStr.append("FR.MOD_BY, ");
		sqlStr.append("FR.MOD_DATE, ");
		sqlStr.append("FR.APPROVE_FLAG, ");
		sqlStr.append("FR.APPROVED_BY, ");
		sqlStr.append("FR.APPROVED_DATE, ");
		sqlStr.append("FR.POST_DATE, ");
		sqlStr.append("FR.INSTANCE_ID, ");
		sqlStr.append("(SELECT FM.MEAL_DESC FROM FS_MEAL FM WHERE FM.MEAL_TYPE='PRICE' AND FR.PRICE_RANGE = FM.MEAL_ID) AS PRICE_RANGE, ");		
		sqlStr.append("(SELECT FM.MEAL_DESC FROM FS_MEAL FM WHERE FM.MEAL_TYPE='EVENT' AND FR.MEAL_EVENT = FM.MEAL_ID) AS MEAL_EVENT, ");				
		sqlStr.append("(SELECT FM.MEAL_DESC FROM FS_MEAL FM WHERE FM.MEAL_TYPE='REQUEST' AND FR.REQUEST_TYPE = FM.MEAL_ID) AS REQUEST_TYPE ");				
		sqlStr.append("FROM FS_REQUEST FR ");
		sqlStr.append("WHERE FR.REQ_NO = '");
		sqlStr.append(reqNo);
		sqlStr.append("'");
		System.err.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}    
        
    public static ArrayList getList(String mealId, String mealType, String userDept) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT MEAL_ID, MEAL_DESC FROM FS_MEAL WHERE 1 = 1 ");
		if (mealType!=null && mealType.length() > 0) {
			sqlStr.append(" AND MEAL_TYPE = '");
			sqlStr.append(mealType);
			sqlStr.append("'");
		}

		if(!("300".equals(userDept) || "FOOD".equals(userDept))&&"REQUEST".equals(mealType)){
			sqlStr.append(" AND MEAL_ID IN (1,2)");
		}
		if (mealId!=null && mealId.length() > 0) {
			sqlStr.append(" AND MEAL_ID = '");
			sqlStr.append(mealId);
			sqlStr.append("'");
		}
		sqlStr.append(" order by MEAL_ID");
		System.err.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}    

    public static Boolean deleteReqOrder(String reqNo, String reqStatus) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("DELETE FROM");
		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
				return true;
		} else {
			return false;
		}    	
    } 
    
    public static Boolean rollbackReqOrder(String requestNo,String reqStatus){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("DELETE FROM");    	
		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
				return true;
		} else {
			return false;
		}    	
    }        

	public static String addReqOrder(UserBean userBean, String reqDate, String servDateStartDateTime, String servDateEndDateTime, String reqSiteCode, String reqDept, String chargeTo, String eventID, String venue, String purpose, String noOfPerson, String mealID, String specReq, String sendAppTo, String reqStatus, String priceRange, String mealEvent, String requestType, String otherMeal, String contactTel, String estAmount, String otherReq, String otherChg, String sentCount) {
		StringBuffer sqlStr = new StringBuffer();
		Vector<String> sqlValue = new Vector<String>();
		String reqNo = getReqNo();
		sqlStr.append("INSERT INTO FS_REQUEST (");
		sqlStr.append("REQ_NO,");
		sqlStr.append("REQ_DATE,");
		sqlStr.append("REQ_BY,");
		sqlStr.append("SERV_DATE_START,");
		sqlStr.append("SERV_DATE_END,");
		sqlStr.append("REQ_SITE_CODE,");
		sqlStr.append("REQ_DEPT_CODE,");
		sqlStr.append("CHARGE_TO,");
		sqlStr.append("VENUE_ID,");
		sqlStr.append("VENUE,");
		sqlStr.append("REQ_STATUS,");
		sqlStr.append("PURPOSE,");
		sqlStr.append("NO_OF_PERSON,");
		sqlStr.append("MEAL_TYPE,");
		sqlStr.append("REMARKS,");
		sqlStr.append("SEND_APPROVAL,");
		sqlStr.append("INS_BY,");
		sqlStr.append("INS_DATE,");
		sqlStr.append("MOD_BY,");
		sqlStr.append("MOD_DATE,");
		sqlStr.append("PRICE_RANGE,");
		sqlStr.append("REQUEST_TYPE, ");
		sqlStr.append("MEAL_EVENT, ");
		sqlStr.append("OTHERMEAL, ");		
		sqlStr.append("CONTACTTEL, ");		
		sqlStr.append("AMOUNT, ");
		sqlStr.append("OTHERREQ, ");
		if(sentCount==null){
			sqlStr.append("OTHERCHARGE ) VALUES ('");			
		}else{
			sqlStr.append("OTHERCHARGE, ALERT_MAIL_DATE, SEND_COUNT) VALUES ('");	

		}
		sqlStr.append(reqNo);
		sqlStr.append("',TO_DATE('");
		sqlStr.append(reqDate);
		sqlStr.append("','DD/MM/YYYY'),'");		
		sqlStr.append(userBean.getStaffID());
		sqlStr.append("',TO_DATE('");
		sqlStr.append(servDateStartDateTime);
		sqlStr.append("','DD/MM/YYYY HH24:MI:SS'),");
		sqlStr.append("TO_DATE('");
		sqlStr.append(servDateEndDateTime);
		sqlStr.append("','DD/MM/YYYY HH24:MI:SS'),'");
		sqlStr.append(reqSiteCode);
		sqlStr.append("','");
		sqlStr.append(reqDept);
		sqlStr.append("','");
		sqlStr.append(chargeTo);
		sqlStr.append("','");
		sqlStr.append(eventID);
		sqlStr.append("','");
		if(venue==null){
			sqlStr.append("");
		}else{
			sqlStr.append(venue);
		}
		sqlStr.append("','");
		sqlStr.append(reqStatus);
		sqlStr.append("','");
		if(purpose==null){
			sqlStr.append("");
		}else{
			sqlStr.append(purpose);
		}		
		sqlStr.append("',TO_NUMBER('");		
		if(noOfPerson!=null && noOfPerson.length()>0){
			sqlStr.append(noOfPerson);
		}else{
			sqlStr.append("0");
		}
		sqlStr.append("'),'");
		sqlStr.append(mealID);
		sqlStr.append("','");	
		if(specReq==null){
			sqlStr.append("");
		}else{
			sqlStr.append(specReq);
		}			
		sqlStr.append("','");
		sqlStr.append(sendAppTo);
		sqlStr.append("','");
		sqlStr.append(userBean.getStaffID());
		sqlStr.append("',SYSDATE");
		sqlStr.append(",'");
		sqlStr.append(userBean.getStaffID());
		sqlStr.append("',SYSDATE, TO_NUMBER('");
		sqlStr.append(priceRange);
		sqlStr.append("'),'");		
		sqlStr.append(requestType);
		sqlStr.append("','");		
		sqlStr.append(mealEvent);
		sqlStr.append("','");
		sqlStr.append(otherMeal);
		sqlStr.append("','");		
		sqlStr.append(contactTel);
		sqlStr.append("',");
		if(estAmount != null && estAmount.length()>0){
			sqlStr.append(" TO_NUMBER('");
			sqlStr.append(estAmount);
			sqlStr.append("'),");			
		}else{
			sqlStr.append("0,");			
		}
		if(otherReq==null){
			sqlStr.append("'',");
		}else{
			sqlStr.append("'");			
			sqlStr.append(otherReq);
			sqlStr.append("',");			
		}
		if(otherChg==null){
			sqlStr.append("''");
		}else{
			sqlStr.append("'");			
			sqlStr.append(otherChg);
			sqlStr.append("'");			
		}
		if(sentCount==null){		
			sqlStr.append(")");
		}else{
			sqlStr.append(", SYSDATE, TO_NUMBER('");			
			sqlStr.append(sentCount);
			sqlStr.append("'))");
		}
System.err.println(sqlStr.toString());

		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			if (reqNo!=null && reqNo.length() > 0){
				if(UtilDBWeb.updateQueue(sqlStr_insertFsLog, new String[] {reqNo, reqStatus, userBean.getStaffID() })) {
					return reqNo;
				}else{
					return null;
				}
			} else {
				return null;
			}
		} else {
			return null;
		}
	}
	
	public static Boolean updateReqOrder(String reqNo, String servDateStartDateTime, String servDateEndDateTime, String reqDeptCode, String chargeTo, String  eventID, String  venue, String  purpose, String  noOfPerson, String mealID, String specReq, String sendApproval, String priceRange, String mealEvent, String requestType, String otherMeal, String contactTel, String estAmount, String otherReq, String otherChg, String sentCount, UserBean userBean){
		System.err.println("[estAmount]:"+estAmount+";");
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE FS_REQUEST SET ");
		sqlStr.append("SERV_DATE_START= TO_DATE('");
		sqlStr.append(servDateStartDateTime);
		sqlStr.append("','DD/MM/YYYY HH24:MI:SS'), SERV_DATE_END = TO_DATE('");		
		sqlStr.append(servDateEndDateTime);
		sqlStr.append("','DD/MM/YYYY HH24:MI:SS'), REQ_DEPT_CODE='");
		sqlStr.append(reqDeptCode);
		sqlStr.append("', CHARGE_TO = '");
		sqlStr.append(chargeTo);
		sqlStr.append("', VENUE_ID = '");
		sqlStr.append(eventID);		
		sqlStr.append("', VENUE = '");		
		sqlStr.append(venue);
		sqlStr.append("', PURPOSE = '");
		sqlStr.append(purpose);		
		sqlStr.append("', NO_OF_PERSON = '");
		sqlStr.append(noOfPerson);			
		sqlStr.append("', MEAL_TYPE = '");
		sqlStr.append(mealID);
		sqlStr.append("', REMARKS = '");
		sqlStr.append(specReq);		
		sqlStr.append("', SEND_APPROVAL = '");
		sqlStr.append(sendApproval);			
		sqlStr.append("', MOD_BY = '");
		sqlStr.append(userBean.getStaffID());		
		sqlStr.append("', MOD_DATE = SYSDATE,");		
		sqlStr.append("PRICE_RANGE = '");	
		sqlStr.append(priceRange);
		sqlStr.append("', MEAL_EVENT = '");	
		sqlStr.append(mealEvent);
		sqlStr.append("', OTHERMEAL = '");	
		sqlStr.append(otherMeal);		
		sqlStr.append("', CONTACTTEL = '");	
		sqlStr.append(contactTel);
		sqlStr.append("', OTHERREQ = '");	
		sqlStr.append(otherReq);
		sqlStr.append("', OTHERCHARGE = '");	
		sqlStr.append(otherChg);		
		sqlStr.append("', AMOUNT = ");
		if(estAmount != null && estAmount.length()>0){
			sqlStr.append(" TO_NUMBER('");
			sqlStr.append(estAmount);			
			sqlStr.append("')");			
		}else{
			sqlStr.append("0");			
		}
		if(sentCount != null && sentCount.length()>0){
			sqlStr.append(", ALERT_MAIL_DATE = SYSDATE, SEND_COUNT = TO_NUMBER('");
			sqlStr.append(sentCount);
			sqlStr.append("')");			
		}
		sqlStr.append(" WHERE REQ_NO='");
		sqlStr.append(reqNo);
		sqlStr.append("'");	
		System.err.println(sqlStr.toString());
		if (UtilDBWeb.updateQueue(sqlStr.toString())) {			
			return true;
		} else {			
			return false;
		}
	}

	public static Boolean approveReqOrder(String reqNo, String servDateStartDateTime, String servDateEndDateTime, String reqDeptCode, String chargeTo, 
				String eventID, String venue, String purpose, String noOfPerson, String mealID, String specReq, String sendApproval, String priceRange, 
				String reqStatus, String approveFlag, String mealEvent, String otherMeal, String contactTel, String estAmount, UserBean userBean){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE FS_REQUEST SET ");
		sqlStr.append("SERV_DATE_START= TO_DATE('");
		sqlStr.append(servDateStartDateTime);
		sqlStr.append("','DD/MM/YYYY HH24:MI:SS'), SERV_DATE_END = TO_DATE('");		
		sqlStr.append(servDateEndDateTime);
		sqlStr.append("','DD/MM/YYYY HH24:MI:SS'), REQ_DEPT_CODE='");
		sqlStr.append(reqDeptCode);
		sqlStr.append("', REQ_STATUS = '");
		sqlStr.append(approveFlag);		
		sqlStr.append("', CHARGE_TO = '");
		sqlStr.append(chargeTo);
		sqlStr.append("', VENUE_ID = '");
		sqlStr.append(eventID);	
		if(venue!=null && venue.length()>0){
			sqlStr.append("', VENUE = '");		
			sqlStr.append(venue);			
		}
		if(purpose!=null && purpose.length()>0){
			sqlStr.append("', PURPOSE = '");
			sqlStr.append(purpose);	
		}
		sqlStr.append("', NO_OF_PERSON = '");
		sqlStr.append(noOfPerson);			
		sqlStr.append("', MEAL_TYPE = '");
		sqlStr.append(mealID);
		if(specReq!=null && specReq.length()>0){		
			sqlStr.append("', REMARKS = '");
			sqlStr.append(specReq);
			sqlStr.append("',");			
		}else{
			sqlStr.append("', REMARKS = null, ");			
		}
		if(sendApproval!=null && sendApproval.length()>0){		
			sqlStr.append(" SEND_APPROVAL = '");
			sqlStr.append(sendApproval);
			sqlStr.append("',");			
		}else{
			sqlStr.append(" SEND_APPROVAL = null, ");			
		}		
		if("A".equals(approveFlag)){
			sqlStr.append(" APPROVE_FLAG = 1, ");			
		}else{
			sqlStr.append(" APPROVE_FLAG = 0, ");
		}
		
		sqlStr.append(" APPROVED_BY = '");
		sqlStr.append(userBean.getStaffID());		
		sqlStr.append("', APPROVED_DATE = SYSDATE");			
		sqlStr.append(", MOD_BY = '");
		sqlStr.append(userBean.getStaffID());		
		sqlStr.append("', MOD_DATE = SYSDATE");		
		sqlStr.append(", PRICE_RANGE = '");	
		sqlStr.append(priceRange);
		sqlStr.append("', MEAL_EVENT = '");	
		sqlStr.append(mealEvent);
		sqlStr.append("',");
		if(estAmount!=null && estAmount.length()>0){
			sqlStr.append(" AMOUNT = TO_NUMBER('");	
			sqlStr.append(estAmount);
			sqlStr.append("'),");			
		}else{
			sqlStr.append(" AMOUNT = 0,");				
		}
		if(otherMeal!=null && otherMeal.length()>0){
			sqlStr.append(" OTHERMEAL = '");	
			sqlStr.append(otherMeal);
			sqlStr.append("',");			
		}else{
			sqlStr.append(" OTHERMEAL = null, ");			
		}
		if(contactTel!=null && contactTel.length()>0){
			sqlStr.append(" CONTACTTEL = '");	
			sqlStr.append(contactTel);
			sqlStr.append("'");			
		}else{
			sqlStr.append(" CONTACTTEL = null ");			
		}		
		sqlStr.append(" WHERE REQ_NO='");
		sqlStr.append(reqNo);
		sqlStr.append("'");	
		
		System.err.println("[sqlStr.toString()]:"+sqlStr.toString());

		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			if(UtilDBWeb.updateQueue(sqlStr_insertFsLog, new String[] {reqNo, approveFlag, userBean.getStaffID() })) {
				return true;
			}else{
				return false;
			}
		} else {			
			return false;
		}
	}	

	public static Boolean updateMenu(String reqNo, String reqStatus, String menu, String specReq, String mealID, String noOfPerson, String estAmount, String servDateStartDateTime, String servDateEndDateTime, String chargeTo, String mealEvent, String eventID, String venue, String purpose, String otherMeal, String chargeAmount, UserBean userBean){				
		StringBuffer sqlStr = new StringBuffer();
		StringBuffer sqlStr2 = new StringBuffer();
		StringBuffer sqlStr3 = new StringBuffer();
		
		sqlStr.append("UPDATE FS_REQUEST SET ");
		if(!"C".equals(reqStatus)){
			if(!"B".equals(reqStatus)){
				if(servDateStartDateTime!=null){
					sqlStr.append("SERV_DATE_START= TO_DATE('");
					sqlStr.append(servDateStartDateTime);
					sqlStr.append("','DD/MM/YYYY HH24:MI:SS'), ");					
				}
				if(servDateEndDateTime!=null){
					sqlStr.append("SERV_DATE_END= TO_DATE('");
					sqlStr.append(servDateEndDateTime);
					sqlStr.append("','DD/MM/YYYY HH24:MI:SS'), ");					
				}
				if(chargeTo!=null){
					sqlStr.append("CHARGE_TO = '");
					sqlStr.append(chargeTo);
					sqlStr.append("', ");					
				}
				sqlStr.append("MOD_BY = '");
				sqlStr.append(userBean.getStaffID());		
				sqlStr.append("', MOD_DATE = SYSDATE ");
				sqlStr.append(", REQ_STATUS = '");	
				sqlStr.append(reqStatus);
				sqlStr.append("' ");		
				if(mealID!=null && mealID.length()>0){		
					sqlStr.append(", MEAL_TYPE = '");			
					sqlStr.append(mealID);
					sqlStr.append("'");			
				}
				if(noOfPerson!=null && noOfPerson.length()>0){		
					sqlStr.append(", NO_OF_PERSON = '");			
					sqlStr.append(noOfPerson);
					sqlStr.append("'");			
				}else{
					sqlStr.append(", NO_OF_PERSON = 0");
				}
				if(estAmount!=null && estAmount.length()>0){
					sqlStr.append(", AMOUNT = TO_NUMBER('");	
					sqlStr.append(estAmount);
					sqlStr.append("') ");			
				}else{
					sqlStr.append(", AMOUNT = 0 ");				
				}					
				if(chargeAmount!=null && chargeAmount.length()>0){
					sqlStr.append(", CHARGE_AMOUNT = TO_NUMBER('");	
					sqlStr.append(chargeAmount);
					sqlStr.append("') ");			
				}else{
					sqlStr.append(", CHARGE_AMOUNT = 0 ");				
				}	
				if(menu!=null && menu.length()>0){
					sqlStr.append(", MENU = '");			
					sqlStr.append(menu);
					sqlStr.append("'");			
				}			
				if(specReq!=null && specReq.length()>0){		
					sqlStr.append(", REMARKS = '");
					sqlStr.append(specReq);	
					sqlStr.append("'");
				}
				if(mealEvent!=null && mealEvent.length()>0){		
					sqlStr.append(", MEAL_EVENT = '");
					sqlStr.append(mealEvent);	
					sqlStr.append("'");
				}
				if(eventID!=null && eventID.length()>0){		
					sqlStr.append(", VENUE_ID = '");
					sqlStr.append(eventID);	
					sqlStr.append("'");
				}		
				if(venue!=null && venue.length()>0){		
					sqlStr.append(", VENUE = '");
					sqlStr.append(venue);	
					sqlStr.append("'");
				}
				if(purpose!=null && purpose.length()>0){		
					sqlStr.append(", PURPOSE = '");
					sqlStr.append(purpose);	
					sqlStr.append("'");
				}
				if(otherMeal!=null && otherMeal.length()>0){		
					sqlStr.append(", OTHERMEAL = '");
					sqlStr.append(otherMeal);	
					sqlStr.append("'");
				}				
			}else{
				sqlStr.append(" MOD_BY = '");
				sqlStr.append(userBean.getStaffID());		
				sqlStr.append("', MOD_DATE = SYSDATE ");
				sqlStr.append(", REQ_STATUS = '");	
				sqlStr.append(reqStatus);
				sqlStr.append("' ");		
				if(mealID!=null && mealID.length()>0){		
					sqlStr.append(", MEAL_TYPE = '");			
					sqlStr.append(mealID);
					sqlStr.append("'");			
				}
				if(noOfPerson!=null && noOfPerson.length()>0){		
					sqlStr.append(", NO_OF_PERSON = '");			
					sqlStr.append(noOfPerson);
					sqlStr.append("'");			
				}else{
					sqlStr.append(", NO_OF_PERSON = 0");
				}
				if(estAmount!=null && estAmount.length()>0){
					sqlStr.append(", CHARGE_AMOUNT = TO_NUMBER('");	
					sqlStr.append(estAmount);
					sqlStr.append("') ");			
				}else{
					sqlStr.append(", CHARGE_AMOUNT = 0 ");				
				}		
				if(menu!=null && menu.length()>0){
					sqlStr.append(", MENU = '");			
					sqlStr.append(menu);
					sqlStr.append("'");			
				}			
				if(specReq!=null && specReq.length()>0){		
					sqlStr.append(", REMARKS = '");
					sqlStr.append(specReq);	
					sqlStr.append("'");
				}
				if(mealEvent!=null && mealEvent.length()>0){		
					sqlStr.append(", MEAL_EVENT = '");
					sqlStr.append(mealEvent);	
					sqlStr.append("'");
				}
				if(purpose!=null && purpose.length()>0){		
					sqlStr.append(", PURPOSE = '");
					sqlStr.append(purpose);	
					sqlStr.append("'");
				}
				if(otherMeal!=null && otherMeal.length()>0){		
					sqlStr.append(", OTHERMEAL = '");
					sqlStr.append(otherMeal);	
					sqlStr.append("'");
				}				
			}					
		}else{
			sqlStr.append(" MOD_BY = '");
			sqlStr.append(userBean.getStaffID());		
			sqlStr.append("', MOD_DATE = SYSDATE ");
			sqlStr.append(", REQ_STATUS = '");	
			sqlStr.append(reqStatus);
			sqlStr.append("' ");
			if(specReq!=null && specReq.length()>0){		
				sqlStr.append(", REMARKS = '");
				sqlStr.append(specReq);	
				sqlStr.append("'");
			}			
		}
		sqlStr.append(" WHERE REQ_NO='");
		sqlStr.append(reqNo);
		sqlStr.append("'");	
		
		System.err.println("2[sqlStr.toString()]:"+sqlStr.toString());
		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			if(UtilDBWeb.updateQueue(sqlStr_insertFsLog, new String[] {reqNo, reqStatus, userBean.getStaffID() })) {
				return true;
			}else{
				return false;
			}
		} else {			
			return false;
		}		
		/*		
		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			if(UtilDBWeb.updateQueue(sqlStr_insertFsLog, new String[] {reqNo, reqStatus, userBean.getStaffID(), currDate })) {
				if(checkDitOrder(reqNo)==0){
					sqlStr2.append("INSERT INTO DIT_ORDER_HDR@UAIS(");
					sqlStr2.append("ORDER_NO,");
					sqlStr2.append("ORDER_TYPE,");
					sqlStr2.append("STATUS,");
					sqlStr2.append("PATNO,");
					sqlStr2.append("SERVE_DATE,");
					sqlStr2.append("SERVE_TYPE,");
					sqlStr2.append("SERVE_TIME,");
					sqlStr2.append("ROMCODE,");
					sqlStr2.append("BEDCODE,");
					sqlStr2.append("DITCODE,");
					sqlStr2.append("CREATE_USER,");
					sqlStr2.append("CREATE_DATE,");
					sqlStr2.append("UPDATE_USER,");
					sqlStr2.append("UPDATE_DATE,");
					sqlStr2.append("REGID,");
					sqlStr2.append("SLPNO,");
					sqlStr2.append("STNSEQ,");
					sqlStr2.append("SLPAMT,");
					sqlStr2.append("POST_MSG) VALUES ('");
					sqlStr2.append(reqNo);
					sqlStr2.append("','S',");
					sqlStr2.append("'A',");
					sqlStr2.append("NULL,TO_DATE('");
					sqlStr2.append(servDateStart);
					sqlStr2.append("','DD/MM/YYYY'),'L','");
					sqlStr2.append(servDateStartDateTime);
					sqlStr2.append("',NULL,");
					sqlStr2.append("NULL,");
					sqlStr2.append("NULL,'");
					sqlStr2.append(userBean.getStaffID());
					sqlStr2.append("',SYSDATE,'");
					sqlStr2.append(userBean.getStaffID());
					sqlStr2.append("',SYSDATE,");
					sqlStr2.append("NULL,");
					sqlStr2.append("NULL,");
					sqlStr2.append("NULL,");
					sqlStr2.append("NULL,");
					sqlStr2.append("NULL)");

					System.err.println("[sqlStr2.toString()]:"+sqlStr2.toString());					
					
					if (UtilDBWeb.updateQueue(sqlStr2.toString())) {
						sqlStr3.append("INSERT INTO DIT_ORDER_DTL@UAIS(");
						sqlStr3.append("ORDER_NO,");
						sqlStr3.append("ITEM_SEQ,");
						sqlStr3.append("ITEM_TYPE,");
						sqlStr3.append("ITEM_CODE,");
						sqlStr3.append("ITEM_OPT,");
						if(menu!=null && menu.length()>0){
							sqlStr3.append("ITEM_NAME1,");
							sqlStr3.append("ITEM_NAME2,");	
						}					
						sqlStr3.append("REMARKS,");
						sqlStr3.append("ORDER_QTY,");
						sqlStr3.append("CURRENCY,");
						sqlStr3.append("AMOUNT,");
						sqlStr3.append("BILLAMT,");
						sqlStr3.append("KITCHEN,");
						sqlStr3.append("READY_QTY,");
						sqlStr3.append("READY_TIME,");
						sqlStr3.append("UPDATE_USER,");
						sqlStr3.append("UPDATE_DATE) VALUES ('");
						sqlStr3.append(reqNo);
						sqlStr3.append("','1',");
						sqlStr3.append("'M',");
						sqlStr3.append("'SPECIAL',");
						sqlStr3.append("NULL,");
						if(noHTMLMenu!=null && noHTMLMenu.length()>0){
							sqlStr3.append("'");
							sqlStr3.append(noHTMLMenu);
							sqlStr3.append("','");
							sqlStr3.append(noHTMLMenu);
							sqlStr3.append("',");	
						}
						sqlStr3.append("NULL,");
						sqlStr3.append("1,");
						sqlStr3.append("NULL,");
						sqlStr3.append("0,");
						sqlStr3.append("0,");
						sqlStr3.append("'main',");
						sqlStr3.append("0,");
						sqlStr3.append("NULL,'");
						sqlStr3.append(userBean.getStaffID());
						sqlStr3.append("',SYSDATE");
						sqlStr3.append(")");
						
						System.err.println("[sqlStr3.toString()]:"+sqlStr3.toString());
						
						return UtilDBWeb.updateQueue(sqlStr3.toString());						
					} else {			
						return false;
					}		
				}else{
					if("C".equals(reqStatus)){
						sqlStr3.append("UPDATE DIT_ORDER_DTL@UAIS ");
						sqlStr3.append("SET STATUS ='X',");
						sqlStr3.append("UPDATE_USER='");
						sqlStr3.append(userBean.getStaffID());
						sqlStr3.append("',UPDATE_DATE=SYSDATE ");				
						sqlStr3.append("WHERE ORDER_NO = '");
						sqlStr3.append(reqNo);					
						sqlStr3.append("'");
					}else{
						sqlStr3.append("UPDATE DIT_ORDER_DTL@UAIS ");
						sqlStr3.append("SET ITEM_NAME1 =");
						if(noHTMLMenu!=null && noHTMLMenu.length()>0){
							sqlStr3.append("'");
							sqlStr3.append(noHTMLMenu);
							sqlStr3.append("',ITEM_NAME2='");
							sqlStr3.append(noHTMLMenu);
							sqlStr3.append("'");				
						}else{
							sqlStr3.append(noHTMLMenu);
							sqlStr3.append(",ITEM_NAME2=");
							sqlStr3.append(noHTMLMenu);					
						}
						sqlStr3.append(",UPDATE_USER='");
						sqlStr3.append(userBean.getStaffID());
						sqlStr3.append("',UPDATE_DATE=SYSDATE ");				
						sqlStr3.append("WHERE ORDER_NO = '");
						sqlStr3.append(reqNo);					
						sqlStr3.append("'");
					}
					
					System.err.println("[sqlStr.toString()]:"+sqlStr3.toString());
					
					return UtilDBWeb.updateQueue(sqlStr3.toString());
				}
			}else{
				return false;
			}

		} else {			
			return false;
		}
*/		
	}
	
	public static int checkDitOrder(String reqNo) {
		int rowCnt = 0;
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT COUNT(ORDER_NO) FROM DIT_ORDER_HDR@UAIS ");
		sqlStr.append("WHERE ORDER_NO = '");
		sqlStr.append(reqNo);
		sqlStr.append("'");
		System.err.println(sqlStr.toString());
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());
		ReportableListObject row = (ReportableListObject) record.get(0);

		try {
			rowCnt = Integer.parseInt(row.getValue(0));
		}
		catch (Exception ex) {
			rowCnt = 0;
		}
		return rowCnt;
	}	
	
	public static Boolean updateAmount(String reqNo, String  reqStatus, String chargeAmount, UserBean userBean){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE FS_REQUEST SET ");
		sqlStr.append(" MOD_BY = '");
		sqlStr.append(userBean.getStaffID());		
		sqlStr.append("', MOD_DATE = SYSDATE ");		
		if(chargeAmount!=null && chargeAmount.length()>0){		
			sqlStr.append(", CHARGE_AMOUNT = TO_NUMBER('");			
			sqlStr.append(chargeAmount);
			sqlStr.append("')");			
		}		
		if("B".equals(reqStatus)){
			sqlStr.append(", REQ_STATUS = '");	
			sqlStr.append(reqStatus);
			sqlStr.append("' ");			
		}
		sqlStr.append(" WHERE REQ_NO='");
		sqlStr.append(reqNo);
		sqlStr.append("'");	
		
		System.err.println("[sqlStr.toString()]:"+sqlStr.toString());

		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			if(UtilDBWeb.updateQueue(sqlStr_insertFsLog, new String[] {reqNo, reqStatus, userBean.getStaffID() })) {
				return true;
			}else{
				return false;
			}
		} else {			
			return false;
		}
	}
		
	public static boolean execProcUptComp(String txCode, UserBean userBean, String postDate) {
		return ConstantsErrorMessage.RETURN_PASS.equals(UtilDBWeb.callFunction(
				txCode,
				null,
				new String[] {
						userBean.getStaffID(),
						postDate
				}));
	}
	
	public static String execFuncGetList(String txCode, UserBean userBean, String postDate, String siteCode) {
		return (UtilDBWeb.callFunction(
				txCode,
				null,
				new String[] {
						postDate,
						siteCode
				}));
	}	
	
	private static String getInstanceId(String reqNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return null;
		}
	}	
	
	private static String getReqNo() {
/*		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT F_GET_PMS_TRANSNO('S') FROM DUAL");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return null;
		}
		
*/
		String f_rtn = UtilDBWeb.callFunction("F_GET_PMS_TRANSNO", "",new String[] {"S"});
		System.err.println("[f_rtn]:"+f_rtn);
		if(f_rtn!=null){
			return f_rtn;
		}else{
			return null;			
		}	
	}
	
	public static ArrayList getFsAppUserList(String flowId, String flowSeq, String sendAppTo, String loginID, String appGrp){
		StringBuffer sqlStr = new StringBuffer();
		Vector<String> sqlValue = new Vector<String>();		
		sqlStr.append("SELECT CU.CO_USERNAME, CU.CO_FIRSTNAME||','||CU.CO_LASTNAME||' -- '||EAL.CO_POSITION_1, EAL.CO_POSITION_1 ");
		sqlStr.append(" FROM EPO_APPROVE_LIST EAL, CO_USERS CU ");
		sqlStr.append(" WHERE EAL.STAFF_ID = CU.CO_USERNAME ");
		sqlStr.append(" AND APPROVAL_GROUP = ? ");
		sqlValue.add(flowId);		
		sqlStr.append(" AND EAL.FLOW_ID = ?");
		sqlValue.add(flowId);		
		sqlStr.append(" AND EAL.FLOW_SEQ = ?");
		sqlValue.add(flowSeq);		
		if (sendAppTo != null && sendAppTo.length() > 0) {
			sqlStr.append(" AND (CU.CO_USERNAME = '");
			sqlStr.append(sendAppTo);
			sqlStr.append("' OR CU.CO_STAFF_ID = '");
			sqlStr.append(sendAppTo);
			sqlStr.append("') ");
		}
		if (loginID != null && loginID.length() > 0 && !"1".equals(flowSeq)) {
			sqlStr.append(" AND CU.CO_USERNAME <> '");
			sqlStr.append(loginID);
			sqlStr.append("'");
		}
		sqlStr.append(" ORDER BY 1");
		// fetch user list
		System.err.println("[sqlStr]:"+sqlStr.toString());
		return UtilDBWeb.getReportableList(
				sqlStr.toString(),
				(String[]) sqlValue.toArray(new String[sqlValue.size()]));
	}	
	
	public static ArrayList getTrackList(String user, String serverSiteCode, String reqNo, String fromDate, String toDate, String servFromDate, String servToDate, String reqDept, String chargeTo, String reqStatus, String requestType, String appGrp) {
		System.err.println("[chargeTo]:"+chargeTo+";[user]:"+user);
		StringBuffer sqlStr = new StringBuffer();
		Vector<String> sqlValue = new Vector<String>();

		sqlStr.append("WITH MQ_FS_REQUEST_LOG as ( SELECT /*+ materialize */ REQ_NO FROM FS_REQUEST_LOG WHERE INSERT_BY = ? ) ");
		sqlValue.add(user);					
		sqlStr.append("SELECT "); 
		sqlStr.append("FST.REQ_NO, ");		
//		sqlStr.append("TO_CHAR(FST.REQ_DATE,'YYYY/MM/DD') AS REQ_DATE, ");
		sqlStr.append("TO_CHAR(FST.SERV_DATE_START,'YYYY/MM/DD') AS SERV_DATE, ");
		sqlStr.append("(SELECT DISTINCT CS.CO_STAFFNAME FROM CO_STAFFS CS WHERE FST.REQ_BY = CS.CO_STAFF_ID) AS REQ_BY, ");		
//		sqlStr.append("TO_CHAR(FST.SERV_DATE_END,'YYYY/MM/DD') AS SERV_DATE_END, "); 
		sqlStr.append("(select CD.CO_DEPARTMENT_DESC from (SELECT CO_DEPARTMENT_CODE, CO_DEPARTMENT_DESC FROM CO_DEPARTMENTS UNION SELECT 'CASH','CASH' FROM DUAL) CD where CD.CO_DEPARTMENT_CODE = FST.CHARGE_TO) as CHARGE_TO, ");
		sqlStr.append("(SELECT C.CO_EVENT_DESC FROM CO_EVENT C WHERE C.CO_EVENT_ID = VENUE_ID) AS VENUE_ID, ");
		sqlStr.append("NO_OF_PERSON, PURPOSE,");		
//		sqlStr.append("DECODE(FST.REQ_STATUS,'A','Approved','C','Cancelled','M','Menu Confirmed','S','Waiting approve','B','Bill settled','P','Post',FST.REQ_STATUS) AS REQSTATUS ");
		sqlStr.append("FST.REQ_STATUS, ");
		sqlStr.append("FST.REQ_BY, ");
		sqlStr.append("(SELECT CD.CO_DEPARTMENT_HEAD FROM CO_DEPARTMENTS CD WHERE CD.CO_DEPARTMENT_CODE = FST.REQ_DEPT_CODE) AS DEPARTMENT_HEAD, ");		
		sqlStr.append("FST.SEND_APPROVAL, ");
		sqlStr.append("NVL((SELECT DISTINCT CS.CO_FIRSTNAME||' '||CS.CO_LASTNAME FROM CO_STAFFS CS WHERE CS.CO_STAFF_ID = FST.SEND_APPROVAL AND UPPER(CS.CO_SITE_CODE) = UPPER('" + ConstantsServerSide.SITE_CODE + "')),FST.SEND_APPROVAL)  AS SEND_APP_NAME, ");
		sqlStr.append("DECODE(FST.REQUEST_TYPE,'1','Meal Order','2','Miscellaneous Order') ");		
		sqlStr.append(" FROM ( "); 
		sqlStr.append("SELECT "); 
		sqlStr.append("FS.REQ_NO, "); 
		sqlStr.append("FS.REQ_DATE, ");
		sqlStr.append("FS.SERV_DATE_START, ");
		sqlStr.append("FS.SERV_DATE_END, ");
		sqlStr.append("FS.REQ_BY, "); 
		sqlStr.append("FS.REQ_DEPT_CODE, ");
		sqlStr.append("FS.CHARGE_TO, ");		
		sqlStr.append("FS.REQ_STATUS, ");
		sqlStr.append("FS.NO_OF_PERSON, ");		
		sqlStr.append("FS.PURPOSE, ");
		sqlStr.append("FS.VENUE_ID, ");
		sqlStr.append("FS.MOD_BY, "); 
		sqlStr.append("FS.REQ_SITE_CODE, ");
		sqlStr.append("FS.REQUEST_TYPE, ");
		sqlStr.append("FS.SEND_APPROVAL ");		
		sqlStr.append("FROM FS_REQUEST FS ");
		sqlStr.append("WHERE FS.REQ_BY = ? OR ");
		sqlValue.add(user);					
		sqlStr.append("FS.REQ_NO IN (SELECT REQ_NO FROM FS_REQUEST WHERE REQ_DEPT_CODE = (SELECT CS.CO_DEPARTMENT_CODE FROM CO_STAFFS CS WHERE CS.CO_STAFF_ID = ?)) OR ");
		sqlValue.add(user);					
		sqlStr.append("FS.REQ_DEPT_CODE IN (SELECT CO_DEPARTMENT_CODE FROM CO_DEPARTMENTS WHERE CO_DEPARTMENT_HEAD = ?) OR ");
		sqlValue.add(user);
		sqlStr.append("FS.CHARGE_TO IN (SELECT CO_DEPARTMENT_CODE FROM CO_DEPARTMENTS WHERE CO_DEPARTMENT_HEAD = ?) OR ");
		sqlValue.add(user);
		sqlStr.append("FS.REQ_NO IN (SELECT REQ_NO FROM MQ_FS_REQUEST_LOG ) OR "); 
//		sqlStr.append("FS.REQ_NO IN ( SELECT REQ_NO FROM FS_REQUEST_LOG WHERE INSERT_BY = ? ) OR ");
//		sqlValue.add(user);		
		sqlStr.append("FS.SEND_APPROVAL = ? OR ");
		sqlValue.add(user);					
//		sqlStr.append("DECODE((SELECT 1 FROM EPO_APPROVE_LIST WHERE FLOW_ID = 2 AND FLOW_SEQ = 1 AND STAFF_ID = ? AND APPROVAL_GROUP = ?),1,FS.REQ_STATUS,FS.REQ_NO) IN ('S','A','M','B') OR ");
//		sqlValue.add(user);					
		sqlStr.append("DECODE((SELECT 1 FROM EPO_APPROVE_LIST WHERE FLOW_ID = 2 AND FLOW_SEQ = 2 AND STAFF_ID = ? AND APPROVAL_GROUP = ?),1,FS.REQ_STATUS,FS.REQ_NO) IN ('A','M','B','P')) FST ");
		sqlValue.add(user);	
		sqlValue.add(appGrp);
		sqlStr.append("WHERE FST.REQ_SITE_CODE = '");
		sqlStr.append(serverSiteCode);
		sqlStr.append("'");				
		if (reqNo != null && reqNo.length() > 0) {
			sqlStr.append(" AND FST.REQ_NO = ?");
			sqlValue.add(reqNo);
		}
		if (requestType != null && requestType.length() > 0) {
			sqlStr.append(" AND FST.REQUEST_TYPE = ?");
			sqlValue.add(requestType);
		}
		if (reqStatus != null && reqStatus.length() > 0) {
			System.err.println("1[reqStatus]:"+reqStatus);
			sqlStr.append(" AND FST.REQ_STATUS = ?");
			sqlValue.add(reqStatus);
			if (chargeTo != null && chargeTo.length() > 0) {
				sqlStr.append(" AND FST.CHARGE_TO = ?");
				sqlValue.add(chargeTo);
			}			
		}else{
			System.err.println("2[reqStatus]:"+reqStatus);			
			sqlStr.append(" AND FST.REQ_STATUS NOT IN ('P','C')");			
		}			
		if (fromDate != null && fromDate.length() > 0) {
			sqlStr.append(" AND FST.REQ_DATE >= TO_DATE(?,'DD/MM/YYYY')");
			sqlValue.add(fromDate);
		}
		if (toDate != null && toDate.length() > 0) {
			sqlStr.append(" AND FST.REQ_DATE <= TO_DATE(?,'DD/MM/YYYY')");
			sqlValue.add(toDate);
		}
		if (servFromDate != null && servFromDate.length() > 0) {
			sqlStr.append(" AND TRUNC(FST.SERV_DATE_START,'DD') >= TO_DATE(?,'DD/MM/YYYY')");
			sqlValue.add(servFromDate);
		}	
		if (servToDate != null && servToDate.length() > 0) {
			sqlStr.append(" AND TRUNC(FST.SERV_DATE_END,'DD') <= TO_DATE(?,'DD/MM/YYYY')");
			sqlValue.add(servToDate);
		}
		sqlStr.append(" ORDER BY FST.SERV_DATE_START DESC, FST.REQ_NO DESC ");				
		System.err.println(sqlStr.toString());
		System.err.println(sqlValue);
		return UtilDBWeb.getReportableList(
				sqlStr.toString(),
				(String[]) sqlValue.toArray(new String[sqlValue.size()]));
	}
	
	public static ArrayList getTodayList(String user, String serverSiteCode) {
		StringBuffer sqlStr = new StringBuffer();
		Vector<String> sqlValue = new Vector<String>();
								
		sqlStr.append("SELECT "); 
		sqlStr.append("FST.REQ_NO, ");		
		sqlStr.append("TO_CHAR(FST.SERV_DATE_START,'YYYY/MM/DD') AS SERV_DATE, ");
		sqlStr.append("TO_CHAR(FST.SERV_DATE_START,'HH24:MI') AS SERV_TIME, ");	
		sqlStr.append("(select CD.CO_DEPARTMENT_DESC from (SELECT CO_DEPARTMENT_CODE, CO_DEPARTMENT_DESC FROM CO_DEPARTMENTS UNION SELECT 'CASH','CASH' FROM DUAL) CD where CD.CO_DEPARTMENT_CODE = FST.CHARGE_TO) as CHARGE_TO, ");
		sqlStr.append("DECODE(FST.VENUE_ID, '1306', FST.VENUE, (SELECT C.CO_EVENT_DESC FROM CO_EVENT C WHERE C.CO_EVENT_ID = FST.VENUE_ID)) AS VENUE_ID, ");
		sqlStr.append("NO_OF_PERSON, FST.REQ_NO ");	
		sqlStr.append("FROM FS_REQUEST FST ");
		sqlStr.append("WHERE REQUEST_TYPE in ('1','2') ");		
		sqlStr.append("AND FST.REQ_SITE_CODE = '");
		sqlStr.append(serverSiteCode);
		sqlStr.append("'");
		sqlStr.append("AND FST.REQ_STATUS NOT IN ('S','C','P','B','R') ");
		sqlStr.append("AND TRUNC(FST.SERV_DATE_START,'MI') > TRUNC(SYSDATE- 2/24,'MI')"); 
		sqlStr.append("AND TRUNC(FST.SERV_DATE_START,'DD') >= TRUNC(SYSDATE,'DD')"); 
		sqlStr.append("AND TRUNC(FST.SERV_DATE_START,'DD') <= TRUNC(SYSDATE,'DD') + 365"); 	
/*		
		if (servFromDate != null && servFromDate.length() > 0) {
			sqlStr.append(" AND TRUNC(FST.SERV_DATE_START,'MI') > TRUNC(TO_DATE(?,'DDMMYYYYHH24MISS')- 2/24,'MI')");
//			sqlValue.add(currDate);
			sqlValue.add("08072016130000");			
			sqlStr.append(" AND TRUNC(FST.SERV_DATE_START,'DD') >= TO_DATE(?,'DD/MM/YYYY')");
			sqlValue.add(servFromDate);
		}
		if (servToDate != null && servToDate.length() > 0) {
			sqlStr.append(" AND TRUNC(FST.SERV_DATE_END,'DD') <= TO_DATE(?,'DD/MM/YYYY') + 2");
			sqlValue.add(servToDate);
		}
*/				
		sqlStr.append(" ORDER BY 2,3");			
		System.err.println("[sqlStr.toString()]:"+sqlStr.toString());
		return UtilDBWeb.getReportableList(
				sqlStr.toString(),
				(String[]) sqlValue.toArray(new String[sqlValue.size()]));
	}
	
	public static ArrayList getTodayPastList(String user, String serverSiteCode) {
		StringBuffer sqlStr = new StringBuffer();
		Vector<String> sqlValue = new Vector<String>();
								
		sqlStr.append("SELECT "); 
		sqlStr.append("FST.REQ_NO, ");		
		sqlStr.append("TO_CHAR(FST.SERV_DATE_START,'YYYY/MM/DD') AS SERV_DATE, ");
		sqlStr.append("TO_CHAR(FST.SERV_DATE_START,'HH24:MI') AS SERV_TIME, ");	
		sqlStr.append("(select CD.CO_DEPARTMENT_DESC from (SELECT CO_DEPARTMENT_CODE, CO_DEPARTMENT_DESC FROM CO_DEPARTMENTS UNION SELECT 'CASH','CASH' FROM DUAL) CD where CD.CO_DEPARTMENT_CODE = FST.CHARGE_TO) as CHARGE_TO, ");
		sqlStr.append("(SELECT C.CO_EVENT_DESC FROM CO_EVENT C WHERE C.CO_EVENT_ID = VENUE_ID) AS VENUE_ID, ");
		sqlStr.append("NO_OF_PERSON, FST.REQ_NO ");	
		sqlStr.append("FROM FS_REQUEST FST ");
		sqlStr.append("WHERE REQUEST_TYPE in ('1','2')");		
		sqlStr.append("AND FST.REQ_SITE_CODE = '");
		sqlStr.append(serverSiteCode);
		sqlStr.append("'");
		sqlStr.append("AND FST.REQ_STATUS NOT IN ('S','C','P','B','R') ");		
		sqlStr.append("AND TRUNC(FST.SERV_DATE_START,'MI') < TRUNC(SYSDATE- 2/24,'MI')"); 
		sqlStr.append("AND TRUNC(FST.SERV_DATE_START,'DD') >= TRUNC(SYSDATE,'DD')"); 
		sqlStr.append("AND TRUNC(FST.SERV_DATE_START,'DD') <= TRUNC(SYSDATE,'DD') + 2");		
/*		
		if (servFromDate != null && servFromDate.length() > 0) {
			sqlStr.append(" AND TRUNC(FST.SERV_DATE_START,'MI') < TRUNC(TO_DATE(?,'DDMMYYYYHH24MISS'),'MI')");
//			sqlValue.add(currDate);
			sqlValue.add("08072016130000");
			sqlStr.append(" AND TRUNC(FST.SERV_DATE_START,'DD') >= TO_DATE(?,'DD/MM/YYYY')");
			sqlValue.add(servFromDate);
		}
		if (servToDate != null && servToDate.length() > 0) {
			sqlStr.append(" AND TRUNC(FST.SERV_DATE_END,'DD') <= TO_DATE(?,'DD/MM/YYYY')");
			sqlValue.add(servToDate);
		}
*/		
		sqlStr.append(" ORDER BY 2,3");		
		System.err.println("[sqlStr.toString()]:"+sqlStr.toString());		
		return UtilDBWeb.getReportableList(
				sqlStr.toString(),
				(String[]) sqlValue.toArray(new String[sqlValue.size()]));
	}	

	public static boolean sendEmail(String reqNo, String reqBy, String loginID, String approvalStaff, String reqDesc, String reqStatus, String folderID, String flowID, String flowSeq) {
		String emailFrom = null;
		Vector emailTo = new Vector();
		String emailToID = null;
		String staffId = null;
		String topic = null;
		String deptHead = null;
		String reqDept = null;
		String reqDate = null;
		String deptHeadName = null;
		String reqByName = null;
		String emailTo1 = null;
		String servDate = null;
		String sendApprovalTo = null;
		String approver = null;
		String servDateStartTime = null;
		String servDateEndTime = null;
		String eventID = null;
		String venue = null;
		String purpose = null;
		String noOfPerson = null;
		String mealID = null;
		String sendAppTo = null;
		String requestType = null;
		String priceRange = null;
		String mealEvent = null;
		String requestDesc = null;
		String approvedBy = null;
		StringBuffer commentStr = null;
		
		int noOfRow = 0;
		int noOfRow2 = 0;
	
		// append url
		commentStr = new StringBuffer();
		if ("S".equals(reqStatus)) {
			if (("2".equals(flowID) || "E".equals(flowID)) && ("1".equals(flowSeq))) {

				emailTo.add(UserDB.getUserEmailByUserName(null, approvalStaff));				
				ArrayList record = FsDB.getReqRecordWithDtl(reqNo);
				noOfRow = record.size();
				System.err.println("[topic]:"+topic+";[approvalStaff]:"+approvalStaff);
				if (noOfRow > 0) {
					ReportableListObject row1 = (ReportableListObject) record.get(0);					
					servDate  = row1.getValue(3);
					reqDept = row1.getValue(7);				
				}				
				
				topic = "Request No:"+reqNo+": Please approve the Event Order for "+reqDept+" on "+servDate;				
				
				// flowID in "E" indicate for email resend
				if ("E".equals(flowID) ) {
					System.err.println("[sendEmail][reqNo]:"+reqNo);
					topic = "This email is a gentle reminder, please approve the Event Order for "+servDate;			
			
					commentStr.append("<br>This email is a gentle reminder that Department Food Order is waiting for your approval.");
					if ("hkah".equals(serverSiteCode)) {
						commentStr.append("<br>Please click  <a href=\'http://www-server/intranet/fs/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
						commentStr.append("\'>Intranet</a> or <a href=\'https://mail.hkah.org.hk/intranet/fs/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
						commentStr.append("\'>Offsite</a> to view the detail.");
					} else if ("twah".equals(serverSiteCode)) {
						commentStr.append("<br>Please click  <a href=\'http://192.168.0.20/intranet/fs/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
						commentStr.append("\'>Intranet</a> to view the detail.");
					}			
				}else{
					commentStr.append("<br>This departmental food order requisition, waiting for your approval.");
					if ("hkah".equals(serverSiteCode)) {
						commentStr.append("<br>Please click  <a href=\'http://www-server/intranet/fs/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
						commentStr.append("\'>Intranet</a> or <a href=\'https://mail.hkah.org.hk/intranet/fs/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
						commentStr.append("\'>Offsite</a> to view the detail.");
					} else if ("twah".equals(serverSiteCode)) {
						commentStr.append("<br>Please click  <a href=\'http://192.168.0.20/intranet/fs/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
						commentStr.append("\'>Intranet</a> or <a href=\'https://mail.twah.org.hk/intranet/fs/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
						commentStr.append("\'>Offsite</a> to view the detail.");
					}
				}
			} else if ("2".equals(flowID) && ("3".equals(flowSeq)) && !reqBy.equals(approvalStaff) && !loginID.equals(approvalStaff)) {
				topic = "Request NO.: "+reqNo;
//				emailTo.add(UserDB.getUserEmail(null, approvalStaff));
				emailTo.add(UserDB.getUserEmailByUserName(null, approvalStaff));
				System.err.println("[2][3][approvalStaff]:"+approvalStaff+";[emailTo.size()]:"+emailTo.size());				
				
				ArrayList record = FsDB.getReqRecordWithDtl(reqNo);
				noOfRow = record.size();

				if (noOfRow > 0) {
					ReportableListObject row1 = (ReportableListObject) record.get(0);
					sendApprovalTo = row1.getValue(18);		
					//approver = UserDB.getUserName(sendApprovalTo);
					approver = sendApprovalTo;
					
					reqNo = row1.getValue(0);
					reqDate = row1.getValue(1);
					reqByName = StaffDB.getStaffFullName2(row1.getValue(2));
					servDate  = row1.getValue(3);
					servDateStartTime = row1.getValue(4);
					servDateEndTime = row1.getValue(5);
					reqDept = row1.getValue(7);
					eventID = row1.getValue(9);
					venue = row1.getValue(10);
					reqStatus = row1.getValue(11);
					purpose = row1.getValue(12);
					noOfPerson = row1.getValue(14);
					mealID = row1.getValue(15);
					sendAppTo = row1.getValue(18);
					priceRange = row1.getValue(28);
					mealEvent = row1.getValue(29);
					requestType = row1.getValue(30);
					requestDesc = "1".equals(requestType)?"Meal Order":"Miscellaneous Order";
					approvedBy = row1.getValue(24);
				}				
								
				commentStr.append("<table border='1'><tr>");
				commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
				commentStr.append("<br>"+MessageResources.getMessageEnglish("prompt.reqBy"));				
				commentStr.append("</td><td>"+reqByName+"</td></tr>");
				commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
				commentStr.append("<br>"+MessageResources.getMessageEnglish("prompt.reqBy"));
				commentStr.append("</td><td>"+requestDesc+"</td></tr>");		
				commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.servDate"));
				commentStr.append("</td><td>"+servDate+"</td></tr>");
				commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.startTime"));
				commentStr.append("</td><td>"+servDateStartTime+"</td></tr>");				
				commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
				commentStr.append(MessageResources.getMessageEnglish("End Time:"));
				commentStr.append("</td><td>"+servDateEndTime+"</td></tr>");				
				commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.reqDept"));
				commentStr.append("</td><td>"+reqDept+"</td></tr>");				
				commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.eventLocation"));
				commentStr.append("</td><td>"+eventID+"</td></tr>");				
				commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.venue"));
				commentStr.append("</td><td>"+venue+"</td></tr>");				
				commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.eventMeeting"));
				commentStr.append("</td><td>"+mealEvent+"</td></tr>");				
				commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.purpose"));
				commentStr.append("</td><td>"+purpose+"</td></tr>");				
				commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.typeOfMeal"));				
				commentStr.append("</td><td>"+mealID+"</td></tr>");					
				commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.noOfPerson"));
				commentStr.append("</td><td>"+noOfPerson+"</td></tr>");
				commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.priceRange"));
				commentStr.append("</td><td>"+priceRange+"</td></tr>");				
				commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.approvalBy"));
				commentStr.append("</td><td>"+approver+"</td></tr>");
				commentStr.append("</table>");
// No link for Secretary
/*				
				if ("hkah".equals(serverSiteCode)) {
					commentStr.append("<br>Please click  <a href=\'http://demo3/intranet/fs/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Intranet</a> or <a href=\'https://mail.hkah.org.hk/intranet/fs/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Offsite</a> to view the detail.");
				} else if ("twah".equals(serverSiteCode)) {
					commentStr.append("<br>Please click  <a href=\'http://192.168.0.20/intranet/fs/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Intranet</a> or <a href=\'https://mail.twah.org.hk/intranet/fs/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Offsite</a> to view the detail.");
				}
*/								
			}
		}else if ("A".equals(reqStatus)) {
			ArrayList record = FsDB.getReqRecordWithDtl(reqNo);
			noOfRow = record.size();

			if (noOfRow > 0) {
				ReportableListObject row1 = (ReportableListObject) record.get(0);
				sendApprovalTo = row1.getValue(18);		
				//approver = UserDB.getUserName(sendApprovalTo);
				approver = sendApprovalTo;
				
				reqNo = row1.getValue(0);
				reqDate = row1.getValue(1);
				reqByName = StaffDB.getStaffFullName2(row1.getValue(2));
				servDate  = row1.getValue(3);
				servDateStartTime = row1.getValue(4);
				servDateEndTime = row1.getValue(5);
				reqDept = row1.getValue(7);
				eventID = row1.getValue(9);
				venue = row1.getValue(10);
				reqStatus = row1.getValue(11);
				purpose = row1.getValue(12);
				noOfPerson = row1.getValue(14);
				mealID = row1.getValue(15);
				sendAppTo = row1.getValue(18);
				priceRange = row1.getValue(28);
				mealEvent = row1.getValue(29);
				requestType = row1.getValue(30);
				requestDesc = "1".equals(requestType)?"Meal Order":"Miscellaneous Order";
				approvedBy = row1.getValue(24);				
			}				
						
			topic = "Event order for "+servDate+" is approved";

			if ("2".equals(flowID) && ("".equals(flowSeq) || flowSeq==null)) {
				emailToID = reqBy;
				if (UserDB.getUserEmailByUserName(null, emailToID) != null &&
						UserDB.getUserEmailByUserName(null, emailToID).length() > 0) {
					emailTo.add(UserDB.getUserEmailByUserName(null, emailToID));
				} else {
					emailTo.add(ConstantsServerSide.MAIL_ALERT);
				}


				commentStr.append("<br>Your food order is <font color='red'>APPROVED</font> and wait for chef cofirm menu.");

				if ("hkah".equals(serverSiteCode)) {
					commentStr.append("<table border='1'><tr>");
					commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
					commentStr.append("<br>"+MessageResources.getMessageEnglish("prompt.reqBy"));				
					commentStr.append("</td><td>"+reqByName+"</td></tr>");	
					commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
					commentStr.append("<br>"+MessageResources.getMessageEnglish("prompt.requestType"));				
					commentStr.append("</td><td>"+requestDesc+"</td></tr>");					
					commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
					commentStr.append(MessageResources.getMessageEnglish("prompt.servDate"));
					commentStr.append("</td><td>"+servDate+"</td></tr>");
					commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
					commentStr.append(MessageResources.getMessageEnglish("prompt.startTime"));
					commentStr.append("</td><td>"+servDateStartTime+"</td></tr>");				
					commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
					commentStr.append(MessageResources.getMessageEnglish("End Time:"));
					commentStr.append("</td><td>"+servDateEndTime+"</td></tr>");				
					commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
					commentStr.append(MessageResources.getMessageEnglish("prompt.reqDept"));
					commentStr.append("</td><td>"+reqDept+"</td></tr>");				
					commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
					commentStr.append(MessageResources.getMessageEnglish("prompt.eventLocation"));
					commentStr.append("</td><td>"+eventID+"</td></tr>");				
					commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
					commentStr.append(MessageResources.getMessageEnglish("prompt.venue"));
					commentStr.append("</td><td>"+venue+"</td></tr>");				
					commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
					commentStr.append(MessageResources.getMessageEnglish("prompt.eventMeeting"));
					commentStr.append("</td><td>"+mealEvent+"</td></tr>");				
					commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
					commentStr.append(MessageResources.getMessageEnglish("prompt.purpose"));
					commentStr.append("</td><td>"+purpose+"</td></tr>");				
					commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
					commentStr.append(MessageResources.getMessageEnglish("prompt.typeOfMeal"));				
					commentStr.append("</td><td>"+mealID+"</td></tr>");					
					commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
					commentStr.append(MessageResources.getMessageEnglish("prompt.noOfPerson"));
					commentStr.append("</td><td>"+noOfPerson+"</td></tr>");
					commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
					commentStr.append(MessageResources.getMessageEnglish("prompt.priceRange"));
					commentStr.append("</td><td>"+priceRange+"</td></tr>");				
					commentStr.append("<td style='background-color:#AA0066;color:#FFFFFF'>");
					commentStr.append(MessageResources.getMessageEnglish("prompt.approvalBy"));
					commentStr.append("</td><td>"+UserDB.getUserName(approvedBy)+"</td></tr>");
					commentStr.append("</table>");					
					commentStr.append("<br>Please click  <a href=\'http://www-server/intranet/fs/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Intranet</a> or <a href=\'https://mail.hkah.org.hk/intranet/fs/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Offsite</a> to view the detail.");
				} else if ("twah".equals(serverSiteCode)) {
					commentStr.append("<br>Please click  <a href=\'http://192.168.0.20:8080/intranet/fs/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Intranet</a> or <a href=\'https://mail.twah.org.hk/intranet/fs/retrieveRequest.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Offsite</a> to view the detail.");
				}				
			} else if ("2".equals(flowSeq)) {
				ArrayList result = getRelatedList("2","2","HKAH");
				System.err.print("[result.size()]+result.size()");
				for(int i=0;i<result.size();i++) {
					ReportableListObject row = (ReportableListObject) result.get(i);
System.err.print("["+i+"];[row.getFields0()]+row.getFields0()");
					if(!FsDB.isApprover(row.getFields0(),"HKAH")){						
						if (UserDB.getUserEmailByUserName(null, row.getFields0()) != null &&
								UserDB.getUserEmailByUserName(null, row.getFields0()).length() > 0) {
							emailTo.add(UserDB.getUserEmailByUserName(null, row.getFields0()));
						} else {
							emailTo.add(ConstantsServerSide.MAIL_ALERT);
						}
					}else{
						System.err.println("3[row.getFields0]"+row.getFields0());	
					}
				}

				commentStr.append("<br>This food order is approved, please complete the menu. ");
				if ("hkah".equals(serverSiteCode)) {
					commentStr.append("<br>Please click  <a href=\'http://www-server/intranet/fs/setMenuFormDetail.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Intranet</a> or <a href=\'https://mail.hkah.org.hk/intranet/fs/setMenuFormDetail.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Offsite</a> to view the detail.");
				} else if ("twah".equals(serverSiteCode)) {
					commentStr.append("<br>Please click  <a href=\'http://192.168.0.20/intranet/fs/setMenuFormDetail.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Intranet</a> or <a href=\'https://mail.twah.org.hk/intranet/fs/setMenuFormDetail.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Offsite</a> to view the detail.");
				}
			}
		}else if ("M".equals(reqStatus)) {
			if ("2".equals(flowID) && ("".equals(flowSeq) || flowSeq==null)) {
				ArrayList record = FsDB.getReqRecordWithDtl(reqNo);
				noOfRow = record.size();

				if (noOfRow > 0) {
					ReportableListObject row1 = (ReportableListObject) record.get(0);
					sendApprovalTo = row1.getValue(18);		
					//approver = UserDB.getUserName(sendApprovalTo);
					approver = sendApprovalTo;
					
					reqNo = row1.getValue(0);
					reqDate = row1.getValue(1);
					reqByName = StaffDB.getStaffFullName2(row1.getValue(2));
					servDate  = row1.getValue(3);
					servDateStartTime = row1.getValue(4);
					servDateEndTime = row1.getValue(5);
					reqDept = row1.getValue(7);
					eventID = row1.getValue(9);
					venue = row1.getValue(10);
					reqStatus = row1.getValue(11);
					purpose = row1.getValue(12);
					noOfPerson = row1.getValue(14);
					mealID = row1.getValue(15);
					sendAppTo = row1.getValue(18);
					priceRange = row1.getValue(28);
					mealEvent = row1.getValue(29);
					requestType = row1.getValue(30);				
				}				
				
				topic = "Serving Date on "+servDate+". Your food order menu confirmed";

				emailToID = reqBy;
				if (UserDB.getUserEmailByUserName(null, emailToID) != null &&
						UserDB.getUserEmailByUserName(null, emailToID).length() > 0) {
					emailTo.add(UserDB.getUserEmailByUserName(null, emailToID));
				} else {
					emailTo.add(ConstantsServerSide.MAIL_ALERT);
				}

				commentStr.append("<br>Your food order menu confirmed. ");

				if ("hkah".equals(serverSiteCode)) {
					commentStr.append("<br>Please click  <a href=\'http://www-server/intranet/fs/retrieveCreate.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Hong Kong Adventist Hospital - Stubbs Road Intranet Portal</a> or <a href=\'https://mail.hkah.org.hk/intranet/fs/retrieveCreate.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Hong Kong Adventist Hospital - Stubbs Road Offsite Portal</a> to view the detail.");
				} else if ("twah".equals(serverSiteCode)) {
					commentStr.append("<br>Please click  <a href=\'http://192.168.0.20/intranet/fs/retrieveCreate.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Hong Kong Adventist Hospital - Tsuen Wan Intranet Portal</a> or <a href=\'https://mail.twah.org.hk/intranet/fs/retrieveCreate.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Hong Kong Adventist Hospital - Tsuen Wan Offsite Portal</a> to view the detail.");
				}
			} else if ("2".equals(flowSeq)) {
				topic = "Serving Date on "+servDate+". Your food order menu confirmed, please post charges.";
				ArrayList result = getRelatedList("2","3","HKAH");

				for(int i=0;i<result.size();i++) {
					ReportableListObject row = (ReportableListObject) result.get(i);

					if (UserDB.getUserEmailByUserName(null, row.getFields0()) != null &&
							UserDB.getUserEmailByUserName(null, row.getFields0()).length() > 0) {
						emailTo.add(UserDB.getUserEmailByUserName(null, row.getFields0()));
					} else {
						emailTo.add(ConstantsServerSide.MAIL_ALERT);
					}
				}

				commentStr.append("<br>This food order menu is confirm, please post charges. ");
				if ("hkah".equals(serverSiteCode)) {
					commentStr.append("<br>Please click  <a href=\'http://www-server/intranet/fs/setChargeFormDetail.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Intranet</a> or <a href=\'https://mail.hkah.org.hk/intranet/fs/setChargeFormDetail.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Offsite</a> to view the detail.");
				} else if ("twah".equals(serverSiteCode)) {
					commentStr.append("<br>Please click  <a href=\'http://192.168.0.20/intranet/fs/setChargeFormDetail.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Intranet</a> or <a href=\'https://mail.twah.org.hk/intranet/fs/setChargeFormDetail.jsp?reqNo="+reqNo+"&command=view");
					commentStr.append("\'>Offsite</a> to view the detail.");
				}				
			}
		}		
		// get request user email
//		emailFrom = UserDB.getUserEmail(null, loginID);

		if (emailFrom == null||emailFrom.length()==0) {
			emailFrom = ConstantsServerSide.MAIL_ALERT;
		}

		if (emailTo.size() > 0) {
			if ("hkah".equals(serverSiteCode)) {
				topic = topic + " (From HKAH - SR - Department Food Order)";			
			} else if ("twah".equals(serverSiteCode)) {
				topic = topic + " (From HKAH - TW - Department Food Order)";
			}

			// send email
			if (UtilMail.sendMail(
					emailFrom,
					(String[]) emailTo.toArray(new String[emailTo.size()]),
					topic,
					commentStr.toString())) {
				return true;
			} else {
				return false;
			}
		} else {
			return false;
		}
	}

	public static ArrayList getTrackLog(String reqNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("DECODE(FSL.REQ_STATUS,'A','Approved','C','Cancelled','M','Menu confirm','B','Bill settled','S','Waiting approve','P','Post',FSL.REQ_STATUS), ");
		sqlStr.append("(SELECT DECODE(CU.CO_FIRSTNAME||CU.CO_LASTNAME,NULL,CS.CO_STAFFNAME,(CU.CO_FIRSTNAME||', '||CU.CO_LASTNAME)) FROM CO_USERS CU, CO_STAFFS CS WHERE CU.CO_STAFF_ID = CS.CO_STAFF_ID AND CU.CO_ENABLED = 1 AND CS.CO_ENABLED = 1 AND (FSL.INSERT_BY = CU.CO_USERNAME OR FSL.INSERT_BY = CU.CO_STAFF_ID)), ");
		sqlStr.append("TO_CHAR(FSL.INSERT_DATE,'DD/MM/YYYY HH24:MI') ");
		sqlStr.append("FROM FS_REQUEST_LOG FSL ");
		sqlStr.append("WHERE FSL.REQ_NO = '");
		sqlStr.append(reqNo);
		sqlStr.append("' ");
		sqlStr.append("ORDER BY FSL.INSERT_DATE ASC, FSL.REQ_STATUS DESC ");
		System.err.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}	
	
	public static boolean isApprover(UserBean userBean, String appGrp) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 FROM EPO_APPROVE_LIST ");
		sqlStr.append(" WHERE FLOW_ID = 2");
		sqlStr.append(" AND FLOW_SEQ = 1");
		sqlStr.append(" AND STAFF_ID = '");
		sqlStr.append(userBean.getStaffID());
		sqlStr.append("' AND APPROVAL_GROUP ='");
		sqlStr.append(appGrp);
		sqlStr.append("'");
		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			return true;
		} else {
			return false;
		}
	}
	
	public static boolean isApprover(String approver, String appGrp) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 FROM EPO_APPROVE_LIST ");
		sqlStr.append(" WHERE FLOW_ID = 2");
		sqlStr.append(" AND FLOW_SEQ = 1");
		sqlStr.append(" AND STAFF_ID = '");
		sqlStr.append(approver);
		sqlStr.append("' AND APPROVAL_GROUP ='");
		sqlStr.append(appGrp);
		sqlStr.append("'");
		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			return true;
		} else {
			return false;
		}
	}	

	public static boolean isChef(UserBean userBean, String appGrp) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 FROM EPO_APPROVE_LIST ");
		sqlStr.append(" WHERE FLOW_ID = 2");
		sqlStr.append(" AND FLOW_SEQ = 2");
		sqlStr.append(" AND STAFF_ID = '");
		sqlStr.append(userBean.getStaffID());
		sqlStr.append("' AND APPROVAL_GROUP ='");
		sqlStr.append(appGrp);
		sqlStr.append("'");
		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			return true;
		} else {
			return false;
		}
	}
	
	public static String checkSecretaryOf(String approver, String appGrp) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT MAX(STAFF_ID) FROM EPO_APPROVE_LIST ");
		sqlStr.append(" WHERE FLOW_ID = 2");
		sqlStr.append(" AND FLOW_SEQ = 3");
		sqlStr.append(" AND APPROVAL_GROUP ='");
		sqlStr.append(appGrp);		
		sqlStr.append("' AND (CO_POSITION_2 IN (SELECT CU.CO_USERNAME FROM CO_USERS CU WHERE '");
		sqlStr.append(approver);		
		sqlStr.append("' IN (CU.CO_STAFF_ID, CU.CO_USERNAME)) OR CO_POSITION_2 IN (SELECT CU.CO_STAFF_ID FROM CO_USERS CU WHERE '");
		sqlStr.append(approver);
		sqlStr.append("' IN (CU.CO_STAFF_ID, CU.CO_USERNAME)))");
		System.err.println(sqlStr.toString());
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return null;
		}
	}
	
	public static boolean ableChargeBill(UserBean userBean, String appGrp) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 FROM EPO_APPROVE_LIST ");
		sqlStr.append(" WHERE FLOW_ID = 2");
		sqlStr.append(" AND FLOW_SEQ = 4");
		sqlStr.append(" AND STAFF_ID = '");
		sqlStr.append(userBean.getStaffID());
		sqlStr.append("' AND APPROVAL_GROUP ='");
		sqlStr.append(appGrp);
		sqlStr.append("'");
		System.err.println(sqlStr.toString());		
		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			return true;
		} else {
			return false;
		}
	}	
		
	public static ArrayList existOrder(String reqNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DISTINCT REQ_NO FROM FS_REQUEST");
		sqlStr.append(" WHERE REQ_NO = '");
		sqlStr.append(reqNo);
		sqlStr.append("' ORDER BY 1");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList existPostDate(String postDate) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT COUNT(REQ_NO) FROM FS_REQUEST");
		sqlStr.append(" WHERE TRUNC(POST_DATE,'DD') = TO_DATE('");
		sqlStr.append(postDate);
		sqlStr.append("','DD/MM/YYYY') ORDER BY 1");
		System.err.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList billStatusAva() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT COUNT(REQ_NO) FROM FS_REQUEST");
		sqlStr.append(" WHERE REQ_STATUS = 'B'");
		System.err.println(sqlStr.toString());		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}	
	
	public static ArrayList getRelatedList(String flowID, String flowSeq, String appGrp) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("STAFF_ID ");
		sqlStr.append("FROM EPO_APPROVE_LIST ");
		sqlStr.append("WHERE FLOW_ID = TO_NUMBER('");
		sqlStr.append(flowID);
		sqlStr.append("') AND FLOW_SEQ = TO_NUMBER('");
		sqlStr.append(flowSeq);
		sqlStr.append("') AND APPROVAL_GROUP ='");
		sqlStr.append(appGrp);		
		sqlStr.append("' ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getChargeDetail(String postDate) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT "); 
		sqlStr.append("(SELECT CD.CO_DEPARTMENT_DESC FROM CO_DEPARTMENTS CD WHERE FR.REQ_DEPT_CODE=CD.CO_DEPARTMENT_CODE) AS DEPTNAME, ");
		sqlStr.append("DECODE(REQUEST_TYPE,'1','7200','2','7300') AS GLCODE, "); 
		sqlStr.append("(SELECT MEAL_DESC FROM FS_MEAL FM WHERE MEAL_TYPE = 'REQUEST' AND FM.MEAL_ID=FR.REQUEST_TYPE) AS REQTYPE, ");
		sqlStr.append("REQDATE, "); 
		sqlStr.append("(SELECT MEAL_DESC FROM FS_MEAL FM WHERE MEAL_TYPE = 'EVENT' AND FM.MEAL_ID=FR.MEAL_EVENT)||DECODE(FR.MEAL_EVENT,'9',' '||FR.PURPOSE,NULL) AS EVENTTYPE, ");
		sqlStr.append("NO_OF_PERSON AS NOOFMEAL, "); 
		sqlStr.append("AMOUNT AS AMT");
		sqlStr.append("FROM FS_REQUEST FR WHERE REQ_STATUS = 'P' ");
		sqlStr.append("AND TRUNC(POST_DATE,'DD') = TO_DATE('"+postDate+"','DD/MM/YYYY') ");		

//		System.out.println(sqlStr.toString());

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getMiscItemDtl(String reqNo) {
		StringBuffer sqlStr = new StringBuffer();
		if(reqNo!=null && reqNo.length()>0){
			sqlStr.append("SELECT ");
			sqlStr.append("FSID.REQ_NO, ");
			sqlStr.append("FSID.ITEM_NO, ");
			sqlStr.append("FMI.ITEM_DESC, ");		
			sqlStr.append("FSID.QTY, ");
			sqlStr.append("FMI.UNIT, ");
			sqlStr.append("FSID.INS_BY, ");
			sqlStr.append("TO_CHAR(FSID.INS_DATE,'DD/MM/YYYY HH:MI:SS'), ");
			sqlStr.append("FSID.MOD_BY, ");
			sqlStr.append("TO_CHAR(FSID.MOD_DATE,'DD/MM/YYYY HH:MI:SS'), ");
			sqlStr.append("FMI.UNIT_PRICE ");			
			sqlStr.append("FROM FS_MISC_ITEM_DTL FSID, FS_MISC_ITEM FMI ");
			sqlStr.append("WHERE FSID.ITEM_NO = FMI.ITEM_NO(+) ");
			sqlStr.append("AND FSID.REQ_NO = '");
			sqlStr.append(reqNo);
			sqlStr.append("' ");
			
		}else{
			sqlStr.append("SELECT ");
			sqlStr.append("NULL, ");
			sqlStr.append("ITEM_NO, ");
			sqlStr.append("ITEM_DESC, ");		
			sqlStr.append("0, ");
			sqlStr.append("UNIT, ");
			sqlStr.append("NULL, ");
			sqlStr.append("TO_CHAR(SYSDATE,'DD/MM/YYYY HH:MI:SS'), ");
			sqlStr.append("NULL, ");
			sqlStr.append("TO_CHAR(SYSDATE,'DD/MM/YYYY HH:MI:SS'), ");
			sqlStr.append("ENABLED ");			
			sqlStr.append("FROM FS_MISC_ITEM FSMI ");
			sqlStr.append("WHERE ENABLED = '1' ");
			sqlStr.append("ORDER BY ITEM_NO");
		}
		System.out.println(sqlStr.toString());		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static boolean addMiscItem(UserBean userBean, String reqNo, String itemNo, String QTY) {
		StringBuffer sqlStr = new StringBuffer();
		Vector<String> sqlValue = new Vector<String>();
		sqlStr.append("INSERT INTO FS_MISC_ITEM_DTL (");
		sqlStr.append("REQ_NO ,");
		sqlStr.append("ITEM_NO ,");
		sqlStr.append("QTY ,");
		sqlStr.append("INS_BY ,");
		sqlStr.append("INS_DATE ,");
		sqlStr.append("MOD_BY ,");
		sqlStr.append("MOD_DATE) VALUES ('");
		sqlStr.append(reqNo);
		sqlStr.append("','");
		sqlStr.append(itemNo);
		sqlStr.append("',TO_NUMBER('");
		sqlStr.append(QTY);
		sqlStr.append("'),'");		
		sqlStr.append(userBean.getStaffID());
		sqlStr.append("',SYSDATE,'");
		sqlStr.append(userBean.getStaffID());
		sqlStr.append("',SYSDATE)");

		System.out.println(sqlStr.toString());		
		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			return true;
		} else {
			return false;
		} 
	}
	
	public static boolean updateMiscItem(UserBean userBean, String reqNo, String itemNo, String QTY) {
		StringBuffer sqlStr = new StringBuffer();
		Vector<String> sqlValue = new Vector<String>();
		sqlStr.append("UPDATE FS_MISC_ITEM_DTL SET ");
		sqlStr.append("REQ_NO ='");
		sqlStr.append(reqNo);		
		sqlStr.append("', QTY =TO_NUMBER('");
		sqlStr.append(QTY);		
		sqlStr.append("'), MOD_BY ='");
		sqlStr.append(userBean.getStaffID());		
		sqlStr.append("',MOD_DATE = SYSDATE ");
		sqlStr.append("WHERE REQ_NO = '");
		sqlStr.append(reqNo);
		sqlStr.append("' AND ITEM_NO ='");
		sqlStr.append(itemNo);
		sqlStr.append("'");

		System.out.println(sqlStr.toString());		
		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			return true;
		} else {
			return false;
		} 
	}
	
	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO FS_REQUEST_LOG (");
		sqlStr.append("	REQ_NO, REQ_STATUS, INSERT_BY, INSERT_DATE) ");
		sqlStr.append("VALUES (");
		sqlStr.append("?, ?, ?, SYSDATE)");
		sqlStr_insertFsLog = sqlStr.toString();
	}	
}