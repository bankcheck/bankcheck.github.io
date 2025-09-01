package com.hkah.web.db;
import java.io.File;

import java.util.ArrayList;

import org.apache.commons.lang.StringUtils;
import org.joda.time.LocalDate;
import org.joda.time.format.DateTimeFormatter;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

import java.text.ParseException;
import java.text.SimpleDateFormat;  
import java.util.Date;  

public class BillingAgreementDB {

	UserBean userBean = new UserBean();
	private static String sqlStr_insertCorp = null;
	private static String sqlStr_updateCorp = null;
	private static String sqlStr_insertCorpAssoDept = null;
	private static String sqlStr_updateCorpAssoDept = null;
	private static String sqlStr_updateDateCorp = null;
	private static String sqlStr_updateInfoCorp = null;
	private static String sqlStr_deleteCorp = null;
	private static String sqlStr_removeAllChild = null;
	private static String sqlStr_deleteAllChild = null;
	private static String sqlStr_getChildCorpList = null;
	private static String sqlStr_getCorp = null;
	private static String sqlStr_updateExpireStatus = null;
	private static String sqlStr_expireContractWithID = null;
	private static String sqlStr_expireContract = null;

	private static String sqlStr_insertProgress = null;
	private static String sqlStr_updateProgress = null;
//	private static String sqlStr_listCorpEnabled = null;

	private static String sqlStr_insertApprovalCorp = null;
	private static String sqlStr_insertApprovalCorp2 = null;
	private static String sqlStr_confirmApprovalCorp = null;
	private static String sqlStr_getApprovalCorp = null;
	private static String sqlStr_listApprovalCorp = null;
	private static String sqlStr_updateApprovalCorp = null;
	private static String sqlStr_updateDoc = null;

	private static String sqlStr_getDeptName = null;
	private static String sqlStr_updateReminders = null;

	private static String getNextBaID(String siteCode, String moduleCode) {
		String baID = null;

		ArrayList<ReportableListObject> result = UtilDBWeb.getReportableList(
				"SELECT MAX(BA_CHECKLIST_ID) + 1 FROM BA_CHECKLIST WHERE BA_SITE_CODE = ? AND BA_MODULE_CODE = ?",
				new String[] { siteCode, moduleCode });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			baID = reportableListObject.getValue(0);

			// set 1 for initial
			if (baID == null || baID.length() == 0) return "1";
		}
		return baID;
	}

	public static String add(UserBean userBean, String moduleCode) {
		// get next ID
		String baID = getNextBaID(ConstantsServerSide.SITE_CODE, moduleCode);

		if (UtilDBWeb.updateQueue(
				sqlStr_insertCorp,
				new String[] { ConstantsServerSide.SITE_CODE, moduleCode, baID, userBean.getLoginID(), userBean.getLoginID() })) {

			if ("external".equals(moduleCode)) {
				String renewID = getNextRenewID(ConstantsServerSide.SITE_CODE, moduleCode, baID);
				UtilDBWeb.updateQueue(
						sqlStr_insertApprovalCorp2,
						new String[] { ConstantsServerSide.SITE_CODE, moduleCode, baID, renewID,
								userBean.getLoginID(), userBean.getLoginID() });
			}

			// insert default date
			if ("marketing".equals(moduleCode)) {
				UtilDBWeb.updateQueue(
						sqlStr_insertProgress,
						new String[] { ConstantsServerSide.SITE_CODE, baID, userBean.getLoginID(), userBean.getLoginID() });
			}
			return baID;
		} else {
			return null;
		}
	}
	

	public static boolean update(UserBean userBean, String moduleCode, String baID,
			String deptCodeRequest, String deptCodeResponse, String corpName,
			String businessType, String businessNature, String businessInfo,
			String contactDateFrom, String contactDateTo,
			String optCurrency, String optAmount, String optUnit,
			String enabled, String corporationCode, String contractRemarks, String reminder1, String reminder2, String availableSite ) {

		return update(userBean,moduleCode,baID,
				deptCodeRequest,deptCodeResponse,corpName,
				businessType,businessNature,businessInfo,
				contactDateFrom,contactDateTo,
				optCurrency,optAmount,optUnit,
				enabled,corporationCode,contractRemarks, "", reminder1, reminder2, availableSite);
	}
	
	public static boolean update(UserBean userBean, String moduleCode, String baID,
			String deptCodeRequest, String deptCodeResponse, String corpName,
			String businessType, String businessNature, String businessInfo,
			String contactDateFrom, String contactDateTo,
			String optCurrency, String optAmount, String optUnit,
			String enabled, String corporationCode, String contractRemarks, String availableSite) {
	
		return update(userBean,moduleCode,baID,
				deptCodeRequest,deptCodeResponse,corpName,
				businessType,businessNature,businessInfo,
				contactDateFrom,contactDateTo,
				optCurrency,optAmount,optUnit,
				enabled,corporationCode,contractRemarks,"", availableSite);
	}
	
	//Modified method to call with null reminders on 20221110 by Arran	
		public static boolean update(UserBean userBean, String moduleCode, String baID,
				String deptCodeRequest, String deptCodeResponse, String corpName,
				String businessType, String businessNature, String businessInfo,
				String contactDateFrom, String contactDateTo,
				String optCurrency, String optAmount, String optUnit,
				String enabled, String corporationCode, String contractRemarks,String contingency, String availableSite) {
			return update(userBean,moduleCode,baID,
					deptCodeRequest,deptCodeResponse,corpName,
					businessType,businessNature,businessInfo,
					contactDateFrom,contactDateTo,
					optCurrency,optAmount,optUnit,
					enabled,corporationCode,contractRemarks, contingency, null, null, availableSite);
		}	
	
//Added method with reminder1, reminder2 on 20221110 by Arran	
	public static boolean update(UserBean userBean, String moduleCode, String baID,
			String deptCodeRequest, String deptCodeResponse, String corpName,
			String businessType, String businessNature, String businessInfo,
			String contactDateFrom, String contactDateTo,
			String optCurrency, String optAmount, String optUnit,
			String enabled, String corporationCode, String contractRemarks,String contingency, String reminder1, String reminder2, String availableSite) {
		return UtilDBWeb.updateQueue(
				sqlStr_updateCorp,
				new String[] { deptCodeRequest, deptCodeResponse, corpName,
					businessType, businessNature, businessInfo,
					contactDateFrom, contactDateTo,
					optCurrency, optAmount, optUnit,
					enabled, corporationCode, contractRemarks,
					userBean.getLoginID(),contingency,availableSite,reminder1, reminder2, ConstantsServerSide.SITE_CODE, moduleCode, baID} );
	}

	public static String insertAssoDept(UserBean userBean, String moduleCode,
			String baParentID, String deptCodeResponse) {
		// get next ID
		String baID = getNextBaID(ConstantsServerSide.SITE_CODE, moduleCode);

		if(UtilDBWeb.updateQueue(
				sqlStr_insertCorpAssoDept,
				new String[] { ConstantsServerSide.SITE_CODE, moduleCode, baID, baParentID, deptCodeResponse,
						userBean.getLoginID(), userBean.getLoginID()} )) {
			return baID;
		}
		else {
			return null;
		}
	}

	public static boolean updateAssoDept(UserBean userBean, String moduleCode, String baID,
			String baParentID, String deptCodeResponse) {
		return UtilDBWeb.updateQueue(
				sqlStr_updateCorpAssoDept,
				new String[] { baParentID, deptCodeResponse,
					userBean.getLoginID(), ConstantsServerSide.SITE_CODE, moduleCode, baID} );
	}

	public static boolean update(UserBean userBean, String moduleCode, String baID,
			String contactDateFrom, String contactDateTo) {
		return UtilDBWeb.updateQueue(
				sqlStr_updateDateCorp,
				new String[] { contactDateFrom, contactDateTo,
					userBean.getLoginID(), ConstantsServerSide.SITE_CODE, moduleCode, baID} );
	}

	public static boolean delete(UserBean userBean, String moduleCode, String baID) {
		return UtilDBWeb.updateQueue(
				sqlStr_deleteCorp,
				new String[] { userBean.getLoginID(), ConstantsServerSide.SITE_CODE, moduleCode, baID } );
	}

	public static boolean removeAllChild(UserBean userBean, String moduleCode, String baParentID) {
		return UtilDBWeb.updateQueue(
				sqlStr_removeAllChild,
				new String[] { ConstantsServerSide.SITE_CODE, moduleCode, baParentID } );
	}

	public static boolean deleteAllChild(UserBean userBean, String moduleCode, String baParentID) {
		return UtilDBWeb.updateQueue(
				sqlStr_deleteAllChild,
				new String[] { userBean.getLoginID(), ConstantsServerSide.SITE_CODE, moduleCode, baParentID } );
	}

	public static String updateProgress(UserBean userBean, String baID, String baDID, String progress, String contactDate) {
		// Update BA_CHECKLIST_PROGRESS
		if (UtilDBWeb.updateQueue(
				sqlStr_updateProgress,
				new String[] {progress, contactDate, userBean.getLoginID(), ConstantsServerSide.SITE_CODE, baID, baDID})) {
			return baDID;
		} else {
			return null;
		}
	}

	public static boolean updateExpiredContract(){

		return UtilDBWeb.updateQueue(
				sqlStr_updateExpireStatus);
	}

	public static boolean expireContractWithID(UserBean userBean, String baID) {
		return UtilDBWeb.updateQueue(
				sqlStr_expireContractWithID,
				new String[] { baID } );
	}

	public static ArrayList<ReportableListObject> get(UserBean userBean, String moduleCode, String baID) {
		return UtilDBWeb.getReportableList(sqlStr_getCorp, new String[] { ConstantsServerSide.SITE_CODE, moduleCode, baID });
	}

	public static ArrayList<ReportableListObject> getList(UserBean userBean, String moduleCode, String enabled, String searchBy,
			String searchContent,String contractDateFrom, String contractDateTo,
			String deptCodeRequest, String deptCodeResponse, String deptCode, String[] ableSite) {
		return getList(userBean, moduleCode, enabled, searchBy,
			searchContent, contractDateFrom, contractDateTo,
			deptCodeRequest, deptCodeResponse, null, deptCode, ableSite);
	}

	public static ArrayList<ReportableListObject> getList(UserBean userBean, String moduleCode, String enabled, String searchBy,
			String searchContent,String contractDateFrom, String contractDateTo,
			String deptCodeRequest, String deptCodeResponse, String[] assoDeptCodeResponse, String deptCode, String[] ableSite) {
		return getList(userBean, moduleCode, enabled, searchBy,
				searchContent, contractDateFrom, contractDateTo,
				deptCodeRequest, deptCodeResponse, null, deptCode,"", ableSite);

	}

	public static ArrayList<ReportableListObject> getList(UserBean userBean, String moduleCode, String enabled, String searchBy,
			String searchContent,String contractDateFrom, String contractDateTo,
			String deptCodeRequest, String deptCodeResponse, String[] assoDeptCodeRequest, String deptCode, String addDeptCode, String[] ableSite) {

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DISTINCT ");
		sqlStr.append("C3.BA_CHECKLIST_ID, C3.BA_CORP_NAME, C3.BA_BUSINESS_TYPE, C3.BA_BUSINESS_NATURE, ");
		sqlStr.append("       TO_CHAR(C3.BA_CONTRACT_DATE_FROM, 'dd/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(C3.BA_CONTRACT_DATE_TO, 'dd/MM/YYYY'), ");
		sqlStr.append("       C3.BA_ENABLED, C3.BA_EXPIRED, C3.BA_CODE, C3.BA_REMARK, ");
		sqlStr.append("       D1.CO_DEPARTMENT_DESC, D2.CO_DEPARTMENT_DESC, ");
		sqlStr.append("       C3.BA_BUSINESS_INFO, C3.BA_OPT_CURRENCY, C3.BA_OPT_AMOUNT, C3.BA_OPT_UNIT, C3.BA_CONTINGENCY, ");
		sqlStr.append("      (SELECT COUNT(1) FROM CO_DOCUMENT_GENERAL WHERE CO_MODULE_CODE = '");
		if ("marketing".equals(moduleCode)) {
			sqlStr.append("bam");
		} else {
			sqlStr.append("bae");
		}
		sqlStr.append(".contingency' AND CO_KEY_ID = C3.BA_CHECKLIST_ID AND CO_ENABLED = 1), S.BA_STATUS_DESC, ");
		sqlStr.append(" D1.CO_COST_CENTRE_DESC, D2.CO_COST_CENTRE_DESC ");
		sqlStr.append("FROM   BA_CHECKLIST C3 ");
		sqlStr.append("LEFT JOIN CO_DEPARTMENTS D1 ON C3.BA_REQ_DEPARTMENT_CODE = D1.CO_DEPARTMENT_CODE ");
		sqlStr.append("LEFT JOIN CO_DEPARTMENTS D2 ON C3.BA_RES_DEPARTMENT_CODE = D2.CO_DEPARTMENT_CODE ");
		sqlStr.append("INNER JOIN BA_STATUS S ON C3.BA_ENABLED = S.BA_STATUS_CODE ");
		// place all search criteria in right join table
		sqlStr.append("RIGHT JOIN ");
		sqlStr.append("(");
		sqlStr.append("SELECT C.BA_SITE_CODE, C.BA_MODULE_CODE, C.BA_CHECKLIST_ID, C.BA_CHECKLIST_PARENT_ID ");
		sqlStr.append("FROM   BA_CHECKLIST C ");
		sqlStr.append("WHERE  C.BA_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    C.BA_MODULE_CODE = '" + moduleCode + "' ");
		sqlStr.append("AND    C.BA_ENABLED ");
		if (enabled != null && enabled.length() > 0) {
			sqlStr.append(" = ");
			sqlStr.append(enabled + " ");
		} else {
			sqlStr.append(" > 0 ");
		}
		
		//new condition site filtering, don leung, 09/11/2022
		int count = 0;
		if(ableSite != null){
			//Verify all data is null or not
			for(int i = 0;i < ableSite.length; i ++){
				if(ableSite[i] != null){
					count ++;
				}
			}
			if(count >= 1){
				sqlStr.append(" AND ");
				for(int i = 0; i < ableSite.length; i ++){
					if(i + 1 == ableSite.length){
						sqlStr.append("    C.BA_ABLE_SITE like  '%" + ableSite[i] + "%' ");
						break;
					}
					
					if(ableSite[i] == null){
						continue;
					}else{
						sqlStr.append("    C.BA_ABLE_SITE like  '%" + ableSite[i] + "%' OR ");
					}
				}
				
			}
			
			
		}
		
		if (contractDateFrom != null && contractDateFrom.length() > 0){
			sqlStr.append("AND C.BA_CONTRACT_DATE_FROM >= TO_DATE('");
			sqlStr.append(contractDateFrom);
			sqlStr.append(" 00:00:00', 'dd/MM/YYYY HH24:MI:SS') ");
		}
		if (contractDateTo != null && contractDateTo.length() > 0){
			sqlStr.append("AND C.BA_CONTRACT_DATE_TO = TO_DATE('");
			sqlStr.append(contractDateTo);
			sqlStr.append(" 00:00:00', 'dd/MM/YYYY HH24:MI:SS') ");
		}
		if (deptCodeResponse != null && deptCodeResponse.length() > 0){
			sqlStr.append("AND C.BA_RES_DEPARTMENT_CODE = '");
			sqlStr.append(deptCodeResponse);
			sqlStr.append("' ");
		}
		
		StringBuffer sqlDeptCodeStr = new StringBuffer();
		if (deptCodeRequest != null && deptCodeRequest.length() > 0){
			sqlDeptCodeStr.append("C.BA_REQ_DEPARTMENT_CODE = '");
			sqlDeptCodeStr.append(deptCodeRequest);
			sqlDeptCodeStr.append("' ");
		}
		
		if (assoDeptCodeRequest != null && assoDeptCodeRequest.length > 0){
			if (sqlDeptCodeStr.length() > 0) {
				sqlDeptCodeStr.append(" OR ");
			}
			sqlDeptCodeStr.append("C.BA_REQ_DEPARTMENT_CODE IN ('");
			sqlDeptCodeStr.append(StringUtils.join(assoDeptCodeRequest, "','"));
			sqlDeptCodeStr.append("') ");
		}
		
		if (deptCode != null && deptCode.length() > 0){
			if (addDeptCode != null) {
				if (sqlDeptCodeStr.length() > 0) {
					sqlDeptCodeStr.append(" OR ");
				}
				sqlDeptCodeStr.append("(C.BA_REQ_DEPARTMENT_CODE in('");
				sqlDeptCodeStr.append(deptCode);
				sqlDeptCodeStr.append("', '");
				sqlDeptCodeStr.append(addDeptCode);
				sqlDeptCodeStr.append("') ");
				sqlDeptCodeStr.append("OR C.BA_RES_DEPARTMENT_CODE in('");
				sqlDeptCodeStr.append(deptCode);
				sqlDeptCodeStr.append("', '");
				sqlDeptCodeStr.append(addDeptCode);
				sqlDeptCodeStr.append("')) ");
			} else {
				if (sqlDeptCodeStr.length() > 0) {
					sqlDeptCodeStr.append(" OR ");
				}
				sqlDeptCodeStr.append("(C.BA_REQ_DEPARTMENT_CODE = '");
				sqlDeptCodeStr.append(deptCode);
				sqlDeptCodeStr.append("' ");
				sqlDeptCodeStr.append("OR C.BA_RES_DEPARTMENT_CODE = '");
				sqlDeptCodeStr.append(deptCode);
				sqlDeptCodeStr.append("') ");
			}
		}
		
		if (sqlDeptCodeStr.length() > 0) {
			sqlStr.append("AND (");
			sqlStr.append(sqlDeptCodeStr.toString());
			sqlStr.append(")");
		}

		sqlStr.append(") C2 ");
		// join both childen and top level parent
		sqlStr.append("ON C3.BA_SITE_CODE = C2.BA_SITE_CODE ");
		sqlStr.append("	AND C3.BA_MODULE_CODE = C2.BA_MODULE_CODE ");
		sqlStr.append("	AND (C3.BA_CHECKLIST_ID = C2.BA_CHECKLIST_PARENT_ID ");
		sqlStr.append("		OR C3.BA_CHECKLIST_ID = C2.BA_CHECKLIST_ID) ");
		sqlStr.append("WHERE C3.BA_CHECKLIST_PARENT_ID IS NULL ");
		sqlStr.append("AND   C3.BA_ENABLED ");
		if (enabled != null && enabled.length() > 0) {
			sqlStr.append(" = ");
			sqlStr.append(enabled + " ");
		} else {
			sqlStr.append(" > 0 ");
		}
		if (searchContent != null && searchContent.length() > 0){
			if (ConstantsVariable.ONE_VALUE.equals(searchBy)){
				sqlStr.append("AND UPPER(C3.BA_CORP_NAME) like '%");
				searchContent = searchContent.toUpperCase();
			} else if (ConstantsVariable.TWO_VALUE.equals(searchBy)){
					sqlStr.append("AND C3.BA_BUSINESS_TYPE like '%");
					if ("IN-PATIENT".equals(searchContent.toUpperCase())){
						searchContent = "IP";
					} else if ("OUT-PATIENT".equals(searchContent.toUpperCase())){
						searchContent = "OP";
					} else if ("BOTH".equals(searchContent.toUpperCase())){
						searchContent = "Both";
					}
			} else if (ConstantsVariable.THREE_VALUE.equals(searchBy)){
				sqlStr.append("AND C3.BA_BUSINESS_NATURE like '%");
				if ("BROKER".equals(searchContent.toUpperCase())){
					searchContent = "BR";
				} else if ("CORPORATE".equals(searchContent.toUpperCase())){
					searchContent = "CE";
				} else if ("INSURANCE COMPANY".equals(searchContent.toUpperCase())){
					searchContent = "IC";
				} else if ("TPA".equals(searchContent.toUpperCase())){
					searchContent = "TPA";
				}
			} else if (ConstantsVariable.FOUR_VALUE.equals(searchBy)){
				sqlStr.append("AND C3.BA_CODE like '%");
			    searchContent = searchContent.toUpperCase();
			}
			sqlStr.append(searchContent);
			sqlStr.append("%' ");
		}
		sqlStr.append("ORDER BY C3.BA_CORP_NAME");
		
		System.out.println("[BillingAgreement] getList sql="+sqlStr.toString());

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList<ReportableListObject> getChildList(String moduleCode, String baParentId) {
		return UtilDBWeb.getReportableList(sqlStr_getChildCorpList,
				new String[] { ConstantsServerSide.SITE_CODE, moduleCode, baParentId });
	}

	public static ArrayList<ReportableListObject> getProgress(UserBean userBean, String baID) {
		// fetch BACheckList Progress
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT P.BA_CHECKLIST_DID, P.BA_CHECKLIST_DEPT_DESC, ");
		sqlStr.append("		  TO_CHAR(D.BA_FIRST_CONTACT_DATE, 'dd/MM/YYYY'), TO_CHAR(D.BA_MODIFIED_DATE, 'dd/MM/YYYY'),D.BA_PROGRESS ");
		sqlStr.append("FROM   BA_CHECKLIST_DEPT P, BA_CHECKLIST_PROGRESS D ");
		sqlStr.append("WHERE  D.BA_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    D.BA_CHECKLIST_ID = ? ");
		sqlStr.append("AND    D.BA_CHECKLIST_DID = P.BA_CHECKLIST_DID ");
		sqlStr.append("AND    D.BA_ENABLED = 1 ");
		sqlStr.append("ORDER BY P.BA_CHECKLIST_DID");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { baID });
	}

	public static String getRelatedHAAID(String corpName) {
		String haaID = null;
		ArrayList<ReportableListObject> result = UtilDBWeb.getReportableList(
				"SELECT HAA_CHECKLIST_ID FROM HAA_CHECKLIST WHERE HAA_CORP_NAME = '" + corpName+"'" );
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			haaID = reportableListObject.getValue(0);

			// set 1 for initial
			if (haaID == null || haaID.length() == 0) return "0";
		}

		return haaID;
	}

	public static void markToBeExpiredIn2Months(){

		UtilDBWeb.updateQueue("UPDATE BA_CHECKLIST SET BA_EXPIRED = 'NO' WHERE BA_ENABLED > 0 ");

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select BA_CHECKLIST_ID,BA_CORP_NAME, ");
		sqlStr.append("TO_CHAR(BA_CONTRACT_DATE_TO,'dd/MM/YYYY')  ");
		sqlStr.append("from ba_checklist ");
		sqlStr.append("where ba_contract_date_to > sysdate ");
		sqlStr.append("AND ba_contract_date_to < add_months(sysdate,2) ");
		sqlStr.append("AND BA_MODULE_CODE = 'marketing' ");
		sqlStr.append(" AND BA_enabled not in (0,2)");

		ArrayList<ReportableListObject> result = UtilDBWeb.getReportableList(sqlStr.toString());

		if (result.size()>0){
			for(int i=0;i<result.size();i++){
				ReportableListObject reportableListObject = (ReportableListObject) result.get(i);
				UtilDBWeb.updateQueue("UPDATE BA_CHECKLIST SET BA_EXPIRED = 'YES' WHERE BA_ENABLED > 0 AND BA_CHECKLIST_ID = "+reportableListObject.getValue(0));
			}
		}
	}

	public static boolean expireContract() {
		return UtilDBWeb.updateQueue(sqlStr_expireContract );
	}

	private static String getNextRenewID(String siteCode, String moduleCode, String baID) {
		String renewID = null;

		ArrayList<ReportableListObject> result = UtilDBWeb.getReportableList(
				"SELECT MAX(BA_RENEW_ID) + 1 FROM BA_RENEW WHERE BA_SITE_CODE = ? AND BA_MODULE_CODE = ? AND BA_CHECKLIST_ID = ?",
				new String[] { siteCode, moduleCode, baID });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			renewID = reportableListObject.getValue(0);

			// set 1 for initial
			if (renewID == null || renewID.length() == 0) return "1";
		}
		return renewID;
	}

	public static boolean updateDoc(UserBean userBean, String moduleCode, String baID, String newDocId, boolean attach) {
		ArrayList<ReportableListObject> result = null;
		if(!attach) {
			result = UtilDBWeb.getReportableList(
					"SELECT MAX(BA_RENEW_ID) FROM BA_RENEW WHERE BA_SITE_CODE = ? AND BA_MODULE_CODE = ? AND BA_CHECKLIST_ID = ?",
					new String[] { ConstantsServerSide.SITE_CODE, moduleCode, baID });
		}
		else {
			result = UtilDBWeb.getReportableList(
					"SELECT MAX(BA_RENEW_ID) FROM BA_RENEW WHERE BA_SITE_CODE = ? AND BA_MODULE_CODE = ? AND BA_CHECKLIST_ID = ? AND BA_APPROVAL_USER IS NOT NULL",
					new String[] { ConstantsServerSide.SITE_CODE, moduleCode, baID });
		}

		String renewID = null;
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			renewID = reportableListObject.getValue(0);
		}

		if(renewID == null || renewID.length() == 0) {
			renewID = getNextRenewID(ConstantsServerSide.SITE_CODE, moduleCode, baID);
			UtilDBWeb.updateQueue(
					sqlStr_insertApprovalCorp2,
					new String[] { ConstantsServerSide.SITE_CODE, moduleCode, baID, renewID,
							userBean.getLoginID(), userBean.getLoginID() });
		}

		String docID = null;
		result = UtilDBWeb.getReportableList(
				"SELECT DOC_ID FROM BA_RENEW WHERE BA_SITE_CODE = ? AND BA_MODULE_CODE = ? AND BA_CHECKLIST_ID = ? AND BA_RENEW_ID = ?",
				new String[] { ConstantsServerSide.SITE_CODE, moduleCode, baID, renewID });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			docID = reportableListObject.getValue(0);

			if (docID == null || docID.length() == 0) {
				docID = "";
			}

			return UtilDBWeb.updateQueue(sqlStr_updateDoc,
					new String[] { docID+newDocId+";", userBean.getLoginID(), ConstantsServerSide.SITE_CODE, moduleCode, baID, renewID });
		}

		return false;
	}

	public static boolean updateApproval(UserBean userBean, String moduleCode, String baID,
			String deptCodeRequest, String businessInfo,
			String optCurrency, String optAmount, String optUnit,
			String contractRemark, String[] assoDeptCodeRequest,
			String[] assoDeptCodeRequestId, String renewID, String contractDateFrom,
			String contractDateTo, boolean update) {
		boolean success = false;

		if(update) {
			ArrayList<ReportableListObject> result = UtilDBWeb.getReportableList(
					"SELECT MAX(BA_RENEW_ID) FROM BA_RENEW WHERE BA_SITE_CODE = ? AND BA_MODULE_CODE = ? AND BA_CHECKLIST_ID = ? AND BA_APPROVAL_USER IS NOT NULL ",
					new String[] { ConstantsServerSide.SITE_CODE, moduleCode, baID });

			if (result.size() > 0) {
				ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
				renewID = reportableListObject.getValue(0);
			}
		}
		success = updateApproval(userBean, moduleCode, baID,
				deptCodeRequest, businessInfo, optCurrency, optAmount,
				optUnit, contractRemark, assoDeptCodeRequest, assoDeptCodeRequestId, renewID);

		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("UPDATE BA_RENEW ");
		sqlStr.append("SET BA_CONTRACT_DATE_FROM = TO_DATE('"+contractDateFrom+"', 'dd/MM/YYYY'), ");
		sqlStr.append("	   BA_CONTRACT_DATE_TO = TO_DATE('"+contractDateTo+"', 'dd/MM/YYYY'), ");
		if(!update)
			sqlStr.append("	   BA_APPROVAL_USER = 'N/A', ");
		sqlStr.append("    BA_MODIFIED_DATE = SYSDATE, BA_MODIFIED_USER = '"+userBean.getLoginID()+"' ");
		sqlStr.append("WHERE  BA_SITE_CODE = '"+ConstantsServerSide.SITE_CODE+"' ");
		sqlStr.append("AND    BA_MODULE_CODE = '"+moduleCode+"' ");
		sqlStr.append("AND    BA_CHECKLIST_ID = '"+baID+"' ");
		sqlStr.append("AND    BA_RENEW_ID = '"+renewID+"' ");

		return (success && UtilDBWeb.updateQueue(sqlStr.toString()));
	}

	public static boolean updateApproval(UserBean userBean, String moduleCode, String baID,
			String deptCodeRequest, String businessInfo,
			String optCurrency, String optAmount, String optUnit,
			String contractRemark, String[] assoDeptCodeRequest,
			String[] assoDeptCodeRequestId, String renewID) {
		if(renewID != null) {
			String assoDeptCode = "";
			String assoDeptName = "";
			String assoDeptReqId = "";

			if(assoDeptCodeRequest != null) {
				for(int i = 0; i < assoDeptCodeRequest.length; i++) {
					assoDeptCode += assoDeptCodeRequest[i]+",";
					assoDeptName += getDeptName(assoDeptCodeRequest[i])+", ";
				}
			}

			if(assoDeptCodeRequestId != null) {
				for(int i = 0; i < assoDeptCodeRequestId.length; i++) {
					if(assoDeptCodeRequestId[i] != null && !assoDeptCodeRequestId[i].isEmpty()) {
						assoDeptReqId += assoDeptCodeRequestId[i]+",";
					}
					else {
						assoDeptReqId += "null,";
					}
				}
			}
			if(assoDeptCode.length() > 0)
				assoDeptCode = assoDeptCode.substring(0, assoDeptCode.length()-1);
			if(assoDeptName.length() > 0)
				assoDeptName = assoDeptName.substring(0, assoDeptName.length()-2);
			if(assoDeptReqId.length() > 0)
				assoDeptReqId = assoDeptReqId.substring(0, assoDeptReqId.length()-1);

			return UtilDBWeb.updateQueue(sqlStr_updateApprovalCorp,
					new String[] { deptCodeRequest, businessInfo, optCurrency, optAmount,
						optUnit, contractRemark, assoDeptCode, assoDeptName, assoDeptReqId, userBean.getLoginID(),
						ConstantsServerSide.SITE_CODE, moduleCode, baID, renewID});
		}
		else {
			return false;
		}

	}

	public static String addApproval(UserBean userBean, String moduleCode, String baID,
									String contactDateFrom, String contactDateTo) {
		// get next ID
		String renewID = getNextRenewID(ConstantsServerSide.SITE_CODE, moduleCode, baID);

		if (ConstantsVariable.ONE_VALUE.equals(renewID)) {
			ArrayList<ReportableListObject> result = get(userBean, moduleCode, baID);
			if (result.size() > 0) {
				ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
				String oldContactDateFrom = reportableListObject.getValue(4);
				String oldContactDateTo = reportableListObject.getValue(5);
				if (update(userBean, moduleCode, baID, oldContactDateFrom, oldContactDateTo)) {
					// set default approval record
					renewID = ConstantsVariable.TWO_VALUE;
				}
			}
		}

		if (UtilDBWeb.updateQueue(
				sqlStr_insertApprovalCorp,
				new String[] { ConstantsServerSide.SITE_CODE, moduleCode, baID, renewID,
						contactDateFrom, contactDateTo, userBean.getLoginID(), userBean.getLoginID()})) {

			if ("external".equals(moduleCode)) {
				//sendEMail(userBean, moduleCode, baID, "Request for approval");
			}

			return renewID;
		} else {
			return null;
		}
	}

	public static void sendEMail(UserBean userBean, String moduleCode, String baID, String subject) {
		// append url
		StringBuffer message = new StringBuffer();
		message.append("<br />");
		message.append("Please click <a href=\"http://");
		message.append(ConstantsServerSide.INTRANET_URL);
		message.append("/intranet/billingAgreement/checkitem.jsp?command=view&moduleCode=");
		message.append(moduleCode);
		message.append("&baID=");
		message.append(baID);
		message.append("\">Intranet</a> or <a href=\"https://");
		message.append(ConstantsServerSide.OFFSITE_URL);
		message.append("/intranet/billingAgreement/checkitem.jsp?command=view&moduleCode=");
		message.append(moduleCode);
		message.append("&baID=");
		message.append(baID);
		message.append("\">Offsite</a> to view the detail.");

		StringBuffer title = new StringBuffer();
		title.append("External Service Providers Register (");
		title.append(subject);
		title.append(") ");
		title.append(userBean.getUserName());
		title.append(" (");
		title.append(userBean.getLoginID());
		title.append(")");

		EmailAlertDB.sendEmail(
				"espr.alert",
				title.toString(),
				message.toString());

	}
	
	//send mail for new file has uploaded, don leung, 08/11/2022
	public static void sendFileEMail(String siteCode, ArrayList record, String site){
		int pageNumber = 0;
		String uploadDate = "";
		String reformattedStr = "";
		StringBuffer message = new StringBuffer();
		message.append("<span>");
		message.append("The following Billing Agreement was uploaded");
		message.append("</span>");
		message.append("</br>");
		message.append("</br>");
			
		message.append("<table class=MsoNormalTable border=1 cellpadding=0 width=70%>");
			
		message.append("<tr>");
		message.append("<td>#</td>");
		message.append("<td width=50%>Corporate Name</td>");
		message.append("<td width=10%>Corporate Code</td>");
		message.append("<td width=10%>Upload Date</td>");
		message.append("<td width=30%>Remark</td>");
		message.append("</tr>");
		if (record.size() > 0) {
			for(int i = 0; i < record.size(); i ++){
				pageNumber = i + 1;
				ReportableListObject row = (ReportableListObject) record.get(i);
				String companyName =  row.getValue(1);
				String arCode = row.getValue(8);
				String remarks = row.getValue(9);
				uploadDate = row.getValue(21);
				SimpleDateFormat fromUser = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				SimpleDateFormat myFormat = new SimpleDateFormat("dd/MM/yyyy");

				try {
				    reformattedStr = myFormat.format(fromUser.parse(uploadDate));
				} catch (ParseException e) {
				    e.printStackTrace();
				}
					
				message.append("<tr>");
				message.append("<td>" + pageNumber + "</td>");  
				message.append("<td>" + companyName + "</td>");
				message.append("<td>" + arCode + "</td>");
				message.append("<td>" + reformattedStr + "</td>");  
				message.append("<td>" + site + "</br></br>" + remarks + "</td>");
				message.append("</tr>");
			}
				
		}
					
		message.append("</table>");
			
		StringBuffer topic = new StringBuffer();
		topic.append("[HKAH-SR] Agreement Upload (As of " + reformattedStr + ")");
							
		EmailAlertDB.sendEmail("bill.upload." + siteCode, topic.toString() ,message.toString());
	}
	


	public static void updateAssoDepts(UserBean userBean, String moduleCode,
			String baID, String assoDeptCode, String assoDeptReqId, String renewID) {
		deleteAllChild(userBean, moduleCode, baID);

		String updateAssoDeptReqId = "";

		if (assoDeptCode != null) {
			String[] assoDeptCodeArray = assoDeptCode.split(",");
			String[] assoDeptReqIdArray = assoDeptReqId.split(",");

			for (int i = 0; i < assoDeptCodeArray.length; i++) {
				if(assoDeptReqIdArray.length == 1 && assoDeptReqIdArray[0].equals("null")) {
					updateAssoDeptReqId += getNextBaID(ConstantsServerSide.SITE_CODE, moduleCode)+",";
					insertAssoDept(userBean, moduleCode, baID, assoDeptCodeArray[i]);
				}
				else {
					if(assoDeptReqIdArray[i].equals("null")) {
						updateAssoDeptReqId += getNextBaID(ConstantsServerSide.SITE_CODE, moduleCode)+",";
						insertAssoDept(userBean, moduleCode, baID, assoDeptCodeArray[i]);
					}
					else {
						updateAssoDeptReqId += assoDeptReqIdArray[i]+",";
						updateAssoDept(userBean, moduleCode,
								assoDeptReqIdArray[i], baID, assoDeptCodeArray[i]);
					}
				}
			}
			if(updateAssoDeptReqId.length() > 0) {
				StringBuffer sqlStr = new StringBuffer();

				sqlStr.append("UPDATE BA_RENEW ");
				sqlStr.append("SET    BA_ASSODEPT_REQUEST_ID = '"+updateAssoDeptReqId.substring(0, updateAssoDeptReqId.length()-1)+"', ");
				sqlStr.append("       BA_MODIFIED_DATE = SYSDATE, BA_MODIFIED_USER = '"+userBean.getLoginID()+"' ");
				sqlStr.append("WHERE  BA_SITE_CODE = '"+ConstantsServerSide.SITE_CODE+"' ");
				sqlStr.append("AND    BA_MODULE_CODE = '"+moduleCode+"' ");
				sqlStr.append("AND    BA_CHECKLIST_ID = '"+baID+"' ");
				sqlStr.append("AND    BA_RENEW_ID = '"+renewID+"' ");

				UtilDBWeb.updateQueue(sqlStr.toString());
			}
		}
	}

	public static boolean confirmApproval(UserBean userBean, String moduleCode,
			String baID, String renewID, boolean isExternal) {
		if (UtilDBWeb.updateQueue(
				sqlStr_confirmApprovalCorp,
				new String[] { userBean.getLoginID(), userBean.getLoginID(),
						ConstantsServerSide.SITE_CODE, moduleCode, baID, renewID } )) {
			// update main table
			ArrayList<ReportableListObject> result = getApproval(userBean, moduleCode, baID, renewID);
			if (result.size() > 0) {
				ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
				String contactDateFrom = reportableListObject.getValue(0);
				String contactDateTo = reportableListObject.getValue(1);
				boolean success = false;
				if(isExternal) {
					String deptCodeRequest = reportableListObject.getValue(6);
					String businessInfo = reportableListObject.getValue(7);
					String optCurrency = reportableListObject.getValue(8);
					String optAmount = reportableListObject.getValue(9);
					String optUnit = reportableListObject.getValue(10);
					String contractRemark = reportableListObject.getValue(11);
					String assoDeptCode = reportableListObject.getValue(12);
					String assoDeptReqId = reportableListObject.getValue(14);

					updateAssoDepts(userBean, moduleCode, baID, assoDeptCode, assoDeptReqId, renewID);

					success = update(userBean, moduleCode, baID, contactDateFrom, contactDateTo, deptCodeRequest, businessInfo,
									optCurrency, optAmount, optUnit, contractRemark);
				}
				else {
					success = update(userBean, moduleCode, baID, contactDateFrom, contactDateTo);
				}

				return success;
			}
		}
		return false;
	}

	public static boolean update(UserBean userBean, String moduleCode, String baID,
			String contactDateFrom, String contactDateTo, String deptCodeRequest, String businessInfo,
			String optCurrency, String optAmount, String optUnit, String contractRemark) {
		return UtilDBWeb.updateQueue(
				sqlStr_updateInfoCorp,
				new String[] { deptCodeRequest, businessInfo, contactDateFrom, contactDateTo,
						optCurrency, optAmount, optUnit, contractRemark,
						userBean.getLoginID(), ConstantsServerSide.SITE_CODE, moduleCode, baID} );
	}

	public static ArrayList<ReportableListObject> getApproval(UserBean userBean, String moduleCode, String baID, String renewID) {
		return UtilDBWeb.getReportableList(sqlStr_getApprovalCorp,
				new String[] { ConstantsServerSide.SITE_CODE, moduleCode, baID, renewID });
	}

	public static ArrayList<ReportableListObject> getApprovalList(UserBean userBean, String moduleCode, String baID) {
		return UtilDBWeb.getReportableList(sqlStr_listApprovalCorp,
				new String[] { ConstantsServerSide.SITE_CODE, moduleCode, baID });
	}

	public static String getDeptName(String deptCode) {
		ArrayList<ReportableListObject> result =  UtilDBWeb.getReportableList(sqlStr_getDeptName,
				new String[] { deptCode });

		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			return reportableListObject.getValue(0);
		}

		return null;
	}
	
	public static boolean updateReminders(String baID, String reminder1, String reminder2) {
		return UtilDBWeb.updateQueue(
				sqlStr_updateReminders,
				new String[] { reminder1, reminder2, baID } );
	}

	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO BA_CHECKLIST (");
		sqlStr.append("BA_SITE_CODE, BA_MODULE_CODE, BA_CHECKLIST_ID, BA_CREATED_USER, BA_MODIFIED_USER ) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?, ? )");
		sqlStr_insertCorp = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE BA_CHECKLIST ");
		sqlStr.append("SET    BA_REQ_DEPARTMENT_CODE = ?, BA_RES_DEPARTMENT_CODE = ?, BA_CORP_NAME = ?, ");
		sqlStr.append("       BA_BUSINESS_TYPE = ?, BA_BUSINESS_NATURE = ?, BA_BUSINESS_INFO = ?, ");
		sqlStr.append("       BA_CONTRACT_DATE_FROM = TO_DATE(?, 'dd/MM/YYYY'), ");
		sqlStr.append("       BA_CONTRACT_DATE_TO = TO_DATE(?, 'dd/MM/YYYY'), ");
		sqlStr.append("       BA_OPT_CURRENCY = ?, BA_OPT_AMOUNT = ?, BA_OPT_UNIT = ?, ");
		sqlStr.append("       BA_ENABLED = ?, BA_CODE = ?, BA_REMARK = ?, ");
		sqlStr.append("       BA_MODIFIED_DATE = SYSDATE, BA_MODIFIED_USER = ?, ");

		//edit sql for new field, don leung, 09/11/2022
		sqlStr.append("       BA_CONTINGENCY =?, ");		
		sqlStr.append("       BA_ABLE_SITE =?, ");
		
		sqlStr.append("       BA_REMINDER1 = TO_DATE(?, 'dd/MM/YYYY'), ");
		sqlStr.append("       BA_REMINDER2 = TO_DATE(?, 'dd/MM/YYYY') ");
		

		sqlStr.append("WHERE  BA_SITE_CODE = ? ");
		sqlStr.append("AND    BA_MODULE_CODE = ? ");
		sqlStr.append("AND    BA_CHECKLIST_ID = ? ");
		sqlStr.append("AND    BA_ENABLED > 0 ");
		sqlStr_updateCorp = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE BA_CHECKLIST ");
		sqlStr.append("SET    BA_REQ_DEPARTMENT_CODE = ?, ");
		sqlStr.append("       BA_BUSINESS_INFO = ?, ");
		sqlStr.append("       BA_CONTRACT_DATE_FROM = TO_DATE(?, 'dd/MM/YYYY'), ");
		sqlStr.append("       BA_CONTRACT_DATE_TO = TO_DATE(?, 'dd/MM/YYYY'), ");
		sqlStr.append("       BA_OPT_CURRENCY = ?, BA_OPT_AMOUNT = ?, BA_OPT_UNIT = ?, ");
		sqlStr.append("       BA_REMARK = ?, ");
		sqlStr.append("       BA_MODIFIED_DATE = SYSDATE, BA_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  BA_SITE_CODE = ? ");
		sqlStr.append("AND    BA_MODULE_CODE = ? ");
		sqlStr.append("AND    BA_CHECKLIST_ID = ? ");
		sqlStr.append("AND    BA_ENABLED > 0 ");
		sqlStr_updateInfoCorp = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO BA_CHECKLIST (");
		sqlStr.append("BA_SITE_CODE, BA_MODULE_CODE, BA_CHECKLIST_ID, BA_CHECKLIST_PARENT_ID, BA_REQ_DEPARTMENT_CODE, BA_CREATED_USER, BA_MODIFIED_USER ) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?, ?, ?, ? )");
		sqlStr_insertCorpAssoDept = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE BA_CHECKLIST ");
		sqlStr.append("SET    BA_CHECKLIST_PARENT_ID = ?, BA_REQ_DEPARTMENT_CODE = ?, ");
		sqlStr.append("       BA_MODIFIED_DATE = SYSDATE, BA_MODIFIED_USER = ?, BA_ENABLED = 1 ");
		sqlStr.append("WHERE  BA_SITE_CODE = ? ");
		sqlStr.append("AND    BA_MODULE_CODE = ? ");
		sqlStr.append("AND    BA_CHECKLIST_ID = ? ");
		sqlStr_updateCorpAssoDept = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE BA_CHECKLIST ");
		sqlStr.append("SET    BA_CONTRACT_DATE_FROM = TO_DATE(?, 'dd/MM/YYYY'), ");
		sqlStr.append("       BA_CONTRACT_DATE_TO = TO_DATE(?, 'dd/MM/YYYY'), ");
		sqlStr.append("       BA_MODIFIED_DATE = SYSDATE, BA_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  BA_SITE_CODE = ? ");
		sqlStr.append("AND    BA_MODULE_CODE = ? ");
		sqlStr.append("AND    BA_CHECKLIST_ID = ? ");
		sqlStr.append("AND    BA_ENABLED > 0 ");
		sqlStr_updateDateCorp = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE BA_CHECKLIST ");
		sqlStr.append("SET    BA_ENABLED = 0, ");
		sqlStr.append("       BA_MODIFIED_DATE = SYSDATE, BA_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  BA_SITE_CODE = ? ");
		sqlStr.append("AND    BA_MODULE_CODE = ? ");
		sqlStr.append("AND    BA_CHECKLIST_ID = ? ");
		sqlStr.append("AND    BA_ENABLED > 0 ");
		sqlStr_deleteCorp = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("DELETE ");
		sqlStr.append("FROM	  BA_CHECKLIST ");
		sqlStr.append("WHERE  BA_SITE_CODE = ? ");
		sqlStr.append("AND    BA_MODULE_CODE = ? ");
		sqlStr.append("AND    BA_CHECKLIST_PARENT_ID = ? ");
		sqlStr_removeAllChild = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE BA_CHECKLIST ");
		sqlStr.append("SET    BA_ENABLED = 0, ");
		sqlStr.append("       BA_MODIFIED_DATE = SYSDATE, BA_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  BA_SITE_CODE = ? ");
		sqlStr.append("AND    BA_MODULE_CODE = ? ");
		sqlStr.append("AND    BA_CHECKLIST_PARENT_ID = ? ");
		sqlStr.append("AND    BA_ENABLED > 0 ");
		sqlStr_deleteAllChild = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO BA_CHECKLIST_PROGRESS (");
		sqlStr.append("BA_SITE_CODE, BA_CHECKLIST_ID, BA_CHECKLIST_DID, BA_CREATED_USER, BA_MODIFIED_USER) ");
		sqlStr.append("SELECT ?, ?, BA_CHECKLIST_DID, ?, ? FROM BA_CHECKLIST_DEPT");
		sqlStr_insertProgress = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE BA_CHECKLIST_PROGRESS ");
		sqlStr.append("SET    BA_PROGRESS = ? , ");
		sqlStr.append("       BA_FIRST_CONTACT_DATE = TO_DATE(?, 'dd/MM/YYYY'),  BA_MODIFIED_DATE = SYSDATE, BA_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  BA_SITE_CODE = ? ");
		sqlStr.append("AND    BA_CHECKLIST_ID = ? ");
		sqlStr.append("AND    BA_CHECKLIST_DID = ? ");
		sqlStr_updateProgress = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE BA_CHECKLIST ");
		sqlStr.append("SET	  BA_ENABLED = 1, BA_EXPIRED = 'NO' ");
		sqlStr.append("WHERE  BA_ENABLED = 2 ");
		sqlStr.append("AND    BA_CONTRACT_DATE_TO IS NOT NULL ");
		sqlStr.append("AND    BA_CONTRACT_DATE_TO >= trunc(SYSDATE) ");
		sqlStr.append("AND    BA_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr_updateExpireStatus = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE BA_CHECKLIST ");
		sqlStr.append("SET    BA_ENABLED = 2");
		sqlStr.append("WHERE  BA_ENABLED = 1 ");
		sqlStr.append("AND    BA_CONTRACT_DATE_TO IS NOT NULL ");
		sqlStr.append("AND    BA_CONTRACT_DATE_TO < TRUNC(SYSDATE) ");
		sqlStr.append("AND    BA_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr_expireContract = sqlStr.toString();
		sqlStr.append("AND BA_CHECKLIST_ID = ? ");
		sqlStr_expireContractWithID = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT C.BA_CHECKLIST_ID, C.BA_CORP_NAME, C.BA_BUSINESS_TYPE, C.BA_BUSINESS_NATURE, ");
		sqlStr.append("       TO_CHAR(C.BA_CONTRACT_DATE_FROM, 'dd/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(C.BA_CONTRACT_DATE_TO, 'dd/MM/YYYY'), ");
		sqlStr.append("       C.BA_ENABLED, C.BA_EXPIRED, C.BA_CODE, C.BA_REMARK, ");
		sqlStr.append("       C.BA_REQ_DEPARTMENT_CODE, D1.CO_DEPARTMENT_DESC, C.BA_RES_DEPARTMENT_CODE, D2.CO_DEPARTMENT_DESC, ");

		sqlStr.append("       C.BA_BUSINESS_INFO, C.BA_OPT_CURRENCY, C.BA_OPT_AMOUNT, C.BA_OPT_UNIT,C.BA_CONTINGENCY, ");
		sqlStr.append("       TO_CHAR(C.BA_REMINDER1, 'dd/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(C.BA_REMINDER2, 'dd/MM/YYYY'), ");
		sqlStr.append("       C.BA_MODIFIED_DATE, C.BA_ABLE_SITE ");


		sqlStr.append("FROM   BA_CHECKLIST C, CO_DEPARTMENTS D1, CO_DEPARTMENTS D2 ");
		sqlStr.append("WHERE  C.BA_REQ_DEPARTMENT_CODE = D1.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    C.BA_RES_DEPARTMENT_CODE = D2.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    C.BA_SITE_CODE = ? ");
		sqlStr.append("AND    C.BA_MODULE_CODE = ? ");
		sqlStr.append("AND    C.BA_CHECKLIST_ID = ? ");
		sqlStr.append("AND    C.BA_ENABLED > 0 ");
		sqlStr.append("ORDER BY C.BA_CORP_NAME");
		sqlStr_getCorp = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT C.BA_CHECKLIST_ID, C.BA_CORP_NAME, C.BA_BUSINESS_TYPE, C.BA_BUSINESS_NATURE, ");
		sqlStr.append("       TO_CHAR(C.BA_CONTRACT_DATE_FROM, 'dd/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(C.BA_CONTRACT_DATE_TO, 'dd/MM/YYYY'), ");
		sqlStr.append("       C.BA_ENABLED, C.BA_EXPIRED, C.BA_CODE, C.BA_REMARK, ");
		sqlStr.append("       C.BA_REQ_DEPARTMENT_CODE, D1.CO_DEPARTMENT_DESC, C.BA_RES_DEPARTMENT_CODE, D2.CO_DEPARTMENT_DESC, ");
		sqlStr.append("       C.BA_BUSINESS_INFO, C.BA_OPT_CURRENCY, C.BA_OPT_AMOUNT, C.BA_OPT_UNIT, ");
		sqlStr.append(" 	  D1.CO_COST_CENTRE_DESC, D2.CO_COST_CENTRE_DESC ");
		sqlStr.append("FROM   BA_CHECKLIST C, CO_DEPARTMENTS D1, CO_DEPARTMENTS D2 ");
		sqlStr.append("WHERE  C.BA_REQ_DEPARTMENT_CODE = D1.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    C.BA_RES_DEPARTMENT_CODE = D2.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    C.BA_SITE_CODE = ? ");
		sqlStr.append("AND    C.BA_MODULE_CODE = ? ");
		sqlStr.append("AND    C.BA_CHECKLIST_PARENT_ID = ? ");
		sqlStr.append("AND    C.BA_ENABLED > 0 ");
		sqlStr.append("ORDER BY C.BA_CHECKLIST_ID");
		sqlStr_getChildCorpList = sqlStr.toString();

//		sqlStr.setLength(0);
//		sqlStr.append("SELECT BA_CHECKLIST_ID, BA_CORP_NAME, BA_BUSINESS_TYPE, BA_BUSINESS_NATURE, ");
//		sqlStr.append("       TO_CHAR(BA_CONTRACT_DATE_FROM, 'dd/MM/YYYY'), ");
//		sqlStr.append("       TO_CHAR(BA_CONTRACT_DATE_TO, 'dd/MM/YYYY'), ");
//		sqlStr.append("       BA_ENABLED, BA_CODE ");
//		sqlStr.append("FROM   BA_CHECKLIST ");
//		sqlStr.append("WHERE  BA_ENABLED = ? ");
//		sqlStr.append("AND    BA_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
//		sqlStr.append("AND    BA_CHECKLIST_PARENT_ID is null ");
//		sqlStr.append("ORDER BY BA_CORP_NAME");
//		sqlStr_listCorpEnabled = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO BA_RENEW(");
		sqlStr.append("       BA_SITE_CODE, BA_MODULE_CODE, BA_CHECKLIST_ID, BA_RENEW_ID, ");
		sqlStr.append("       BA_CONTRACT_DATE_FROM, BA_CONTRACT_DATE_TO, ");
		sqlStr.append("       BA_CREATED_USER, BA_MODIFIED_USER) ");
		sqlStr.append("VALUES");
		sqlStr.append("(?, ?, ?, ?, TO_DATE(?, 'dd/MM/YYYY'), TO_DATE(?, 'dd/MM/YYYY'), ?, ? )");
		sqlStr_insertApprovalCorp = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO BA_RENEW(");
		sqlStr.append("       BA_SITE_CODE, BA_MODULE_CODE, BA_CHECKLIST_ID, BA_RENEW_ID, ");
		sqlStr.append("       BA_CREATED_USER, BA_MODIFIED_USER) ");
		sqlStr.append("VALUES");
		sqlStr.append("(?, ?, ?, ?, ?, ? )");
		sqlStr_insertApprovalCorp2 = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE BA_RENEW ");
		sqlStr.append("SET    BA_REQ_DEPARTMENT_CODE = ?, ");
		sqlStr.append("       BA_BUSINESS_INFO = ?, ");
		sqlStr.append("       BA_OPT_CURRENCY = ?, ");
		sqlStr.append("       BA_OPT_AMOUNT = ?, ");
		sqlStr.append("       BA_OPT_UNIT = ?, ");
		sqlStr.append("		  BA_REMARK = ?, ");
		sqlStr.append("		  BA_ASSODEPT_CODE = ?, ");
		sqlStr.append("		  BA_ASSODEPT_NAME = ?, ");
		sqlStr.append("		  BA_ASSODEPT_REQUEST_ID = ?, ");
		sqlStr.append("       BA_MODIFIED_DATE = SYSDATE, BA_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  BA_SITE_CODE = ? ");
		sqlStr.append("AND    BA_MODULE_CODE = ? ");
		sqlStr.append("AND    BA_CHECKLIST_ID = ? ");
		sqlStr.append("AND    BA_RENEW_ID = ? ");
		sqlStr_updateApprovalCorp = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE BA_RENEW ");
		sqlStr.append("SET    BA_APPROVAL_DATE = SYSDATE, BA_APPROVAL_USER = ?, ");
		sqlStr.append("       BA_MODIFIED_DATE = SYSDATE, BA_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  BA_SITE_CODE = ? ");
		sqlStr.append("AND    BA_MODULE_CODE = ? ");
		sqlStr.append("AND    BA_CHECKLIST_ID = ? ");
		sqlStr.append("AND    BA_RENEW_ID = ? ");
		sqlStr_confirmApprovalCorp = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT TO_CHAR(R.BA_CONTRACT_DATE_FROM, 'dd/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(R.BA_CONTRACT_DATE_TO, 'dd/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(R.BA_APPROVAL_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       R.BA_APPROVAL_USER, ");
		sqlStr.append("       TO_CHAR(R.BA_CREATED_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       R.BA_CREATED_USER, R.BA_REQ_DEPARTMENT_CODE, ");
		sqlStr.append("       R.BA_BUSINESS_INFO, R.BA_OPT_CURRENCY, ");
		sqlStr.append("       R.BA_OPT_AMOUNT, R.BA_OPT_UNIT, ");
		sqlStr.append("       R.BA_REMARK, ");
		sqlStr.append("       R.BA_ASSODEPT_CODE, ");
		sqlStr.append("       R.BA_ASSODEPT_NAME, ");
		sqlStr.append("       R.BA_ASSODEPT_REQUEST_ID, '', ");
		sqlStr.append("       R.BA_OPT_CURRENCY || ' ' || R.BA_OPT_AMOUNT || ' ' || R.BA_OPT_UNIT ");
		sqlStr.append("FROM   BA_RENEW R, CO_DEPARTMENTS D1 ");
		sqlStr.append("WHERE  R.BA_SITE_CODE = ? ");
		sqlStr.append("AND 	  R.BA_REQ_DEPARTMENT_CODE = D1.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    R.BA_MODULE_CODE = ? ");
		sqlStr.append("AND    R.BA_CHECKLIST_ID = ? ");
		sqlStr.append("AND    R.BA_RENEW_ID = ? ");
		sqlStr_getApprovalCorp = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT R.BA_RENEW_ID, ");
		sqlStr.append("       TO_CHAR(R.BA_CONTRACT_DATE_FROM, 'dd/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(R.BA_CONTRACT_DATE_TO, 'dd/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(R.BA_APPROVAL_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       R.BA_APPROVAL_USER, ");
		sqlStr.append("       TO_CHAR(R.BA_CREATED_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       R.BA_CREATED_USER, ");
		sqlStr.append("       D1.CO_DEPARTMENT_DESC, ");
		sqlStr.append("       R.BA_ASSODEPT_NAME, ");
		sqlStr.append("       R.BA_BUSINESS_INFO, ");
		sqlStr.append("       R.BA_OPT_CURRENCY || ' ' || R.BA_OPT_AMOUNT || ' ' || R.BA_OPT_UNIT, ");
		sqlStr.append("       R.BA_REMARK, DOC_ID, S1.CO_STAFFNAME, S2.CO_STAFFNAME ");
		sqlStr.append("FROM   BA_RENEW R ");
		sqlStr.append("LEFT JOIN CO_DEPARTMENTS D1 ON R.BA_REQ_DEPARTMENT_CODE = D1.CO_DEPARTMENT_CODE ");
		sqlStr.append("LEFT JOIN CO_USERS U1 ON R.BA_SITE_CODE = U1.CO_SITE_CODE AND R.BA_APPROVAL_USER = U1.CO_USERNAME ");
		sqlStr.append("LEFT JOIN CO_STAFFS S1 ON U1.CO_SITE_CODE = S1.CO_SITE_CODE AND U1.CO_STAFF_ID = S1.CO_STAFF_ID ");
		sqlStr.append("LEFT JOIN CO_USERS U2 ON R.BA_SITE_CODE = U2.CO_SITE_CODE AND R.BA_CREATED_USER = U2.CO_USERNAME ");
		sqlStr.append("LEFT JOIN CO_STAFFS S2 ON U2.CO_SITE_CODE = S2.CO_SITE_CODE AND U2.CO_STAFF_ID = S2.CO_STAFF_ID ");
		sqlStr.append("WHERE  R.BA_SITE_CODE = ? ");
		sqlStr.append("AND    R.BA_MODULE_CODE = ? ");
		sqlStr.append("AND    R.BA_CHECKLIST_ID = ? ");
		sqlStr_listApprovalCorp = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT CO_DEPARTMENT_DESC ");
		sqlStr.append("FROM CO_DEPARTMENTS ");
		sqlStr.append("WHERE CO_DEPARTMENT_CODE = ? ");
		sqlStr_getDeptName = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE BA_RENEW ");
		sqlStr.append("SET    DOC_ID = ?, ");
		sqlStr.append("       BA_MODIFIED_DATE = SYSDATE, BA_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  BA_SITE_CODE = ? ");
		sqlStr.append("AND    BA_MODULE_CODE = ? ");
		sqlStr.append("AND    BA_CHECKLIST_ID = ? ");
		sqlStr.append("AND    BA_RENEW_ID = ? ");
		sqlStr_updateDoc = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE BA_CHECKLIST ");
		sqlStr.append("SET    BA_REMINDER1 = TO_DATE(?, 'dd/MM/YYYY'), ");
		sqlStr.append("       BA_REMINDER2 = TO_DATE(?, 'dd/MM/YYYY') ");
		sqlStr.append("WHERE  BA_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    BA_MODULE_CODE = 'external' ");
		sqlStr.append("AND    BA_CHECKLIST_ID = ? ");
		sqlStr_updateReminders = sqlStr.toString();
	}
}