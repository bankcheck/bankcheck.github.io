package com.hkah.web.db;

import java.util.ArrayList;

import javax.servlet.http.HttpSession;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.fop.Label_8220;
import com.hkah.fop.Label_L7160;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.PasswordUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class CRMClientDB {

	private static String sqlStr_insertClient = null;
	private static String sqlStr_updateClient = null;
	private static String sqlStr_updateClientName = null;
	private static String sqlStr_deleteClient = null;

	private static String sqlStr_insertClientAccessControl = null;
	private static String sqlStr_updateClientAccessControl = null;
	private static String sqlStr_deleteClientAccessControl = null;
	private static String sqlStr_getClientAccessControl = null;
	private static String sqlStr_isExistClientAccessControl = null;
	private static String sqlStr_isExistClientAccessControl_CheckAll = null;
	private static String sqlStr_isExistClient_Owner = null;

	private static String getNextClientID() {
		String clientID = null;

		// get next schedule id from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(CRM_CLIENT_ID) + 1 FROM CRM_CLIENTS");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			clientID = reportableListObject.getValue(0);

			// set 1 for initial
			if (clientID == null || clientID.length() == 0) return "1";
		}
		return clientID;
	}

	/**
	 * Add a client
	 */
	public static String add(UserBean userBean,
			String lastName, String firstName) {
		return add(userBean,
				lastName, firstName,
				null, null, null, null,
				null, null, null,
				null, null, null,
				null, null, null, null, null,
				null, null, null, null, null, null, null,
				null, null, null, null, null,
				null, null, null, null,
				null, null, "N", null);
	}

	/**
	 * Add a client
	 */
	public static String add(UserBean userBean,
			String lastName, String firstName,
			String chineseName, String title, String religion, String sex,
			String dob_yy, String dob_mm, String dob_dd,
			String decease_yy, String decease_mm, String decease_dd,
			String ageGroup, String educationLevelID, String occupationID, String hkid, String passport,
			String street1, String street2, String street3, String street4, String districtID, String areaID, String country,
			String language, String homeNumber, String officeNumber, String mobileNumber, String faxNumber,
			String email, String emergencyContactPerson, String emergencyContactNumber, String emergencyContactRelationship,
			String faceBook, String income, String willingPromotion, String preferContactMethod,
			String[] allowView,String userID,String userSiteCode,boolean isLMCCRM, String remarks) {
		
		return add(lastName, firstName,
				chineseName, title, religion, sex,
				dob_yy, dob_mm, dob_dd,
				decease_yy, decease_mm, decease_dd,
				ageGroup, educationLevelID, occupationID, hkid, passport,
				street1, street2, street3, street4, districtID, areaID, country,
				language, homeNumber, officeNumber, mobileNumber, faxNumber,
				email, emergencyContactPerson, emergencyContactNumber, emergencyContactRelationship,
				faceBook, income, willingPromotion, preferContactMethod,
				allowView, userBean.getSiteCode(), userBean.getDeptCode(), userBean.getLoginID(),userID,userSiteCode,isLMCCRM, remarks);
	}

	/**
	 * Add a client
	 */
	public static String add(UserBean userBean,
			String lastName, String firstName,
			String chineseName, String title, String religion, String sex,
			String dob_yy, String dob_mm, String dob_dd,
			String decease_yy, String decease_mm, String decease_dd,
			String ageGroup, String educationLevelID, String occupationID, String hkid, String passport,
			String street1, String street2, String street3, String street4, String districtID, String areaID, String country,
			String language, String homeNumber, String officeNumber, String mobileNumber, String faxNumber,
			String email, String emergencyContactPerson, String emergencyContactNumber, String emergencyContactRelationship,
			String faceBook, String income, String willingPromotion, String preferContactMethod) {
		String allowView = userBean.getSiteCode() + "-" + userBean.getDeptCode();
		return add(lastName, firstName,
				chineseName, title, religion, sex,
				dob_yy, dob_mm, dob_dd,
				decease_yy, decease_mm, decease_dd,
				ageGroup, educationLevelID, occupationID, hkid, passport,
				street1, street2, street3, street4, districtID, areaID, country,
				language, homeNumber, officeNumber, mobileNumber, faxNumber,
				email, emergencyContactPerson, emergencyContactNumber, emergencyContactRelationship,
				faceBook, income, willingPromotion, preferContactMethod,
				new String[] { allowView }, userBean.getSiteCode(), userBean.getDeptCode(), userBean.getLoginID(),null,null,false, null);
	}

	public static String add(
			String lastName, String firstName,
			String chineseName, String title, String religion, String sex,
			String dob_yy, String dob_mm, String dob_dd,
			String decease_yy, String decease_mm, String decease_dd,
			String ageGroup, String educationLevelID, String occupationID, String hkid, String passport,
			String street1, String street2, String street3, String street4, String districtID, String areaID, String country,
			String language, String homeNumber, String officeNumber, String mobileNumber, String faxNumber,
			String email, String emergencyContactPerson, String emergencyContactNumber, String emergencyContactRelationship,
			String faceBook, String income, String willingPromotion, String preferContactMethod,
			String[] allowView, String createSiteCode, String createDeptCode, String createUser,String userID,String userSiteCode,boolean isLMCCRM) {
		return add(lastName, firstName,
				chineseName, title, religion, sex,
				dob_yy, dob_mm, dob_dd,
				decease_yy, decease_mm, decease_dd,
				ageGroup, educationLevelID, occupationID, hkid, passport,
				street1, street2, street3, street4, districtID, areaID, country,
				language, homeNumber, officeNumber, mobileNumber, faxNumber,
				email, emergencyContactPerson, emergencyContactNumber, emergencyContactRelationship,
				faceBook, income, willingPromotion, preferContactMethod,
				allowView, createSiteCode, createDeptCode, createUser, null, null, false, null);
	}
	
	public static String add(
			String lastName, String firstName,
			String chineseName, String title, String religion, String sex,
			String dob_yy, String dob_mm, String dob_dd,
			String decease_yy, String decease_mm, String decease_dd,
			String ageGroup, String educationLevelID, String occupationID, String hkid, String passport,
			String street1, String street2, String street3, String street4, String districtID, String areaID, String country,
			String language, String homeNumber, String officeNumber, String mobileNumber, String faxNumber,
			String email, String emergencyContactPerson, String emergencyContactNumber, String emergencyContactRelationship,
			String faceBook, String income, String willingPromotion, String preferContactMethod,
			String[] allowView, String createSiteCode, String createDeptCode, String createUser,String userID,String userSiteCode,boolean isLMCCRM, String remarks) {

		// get next client ID
		String clientID = getNextClientID();
			
		// try to insert a new record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertClient,
				new String[] {
						clientID, lastName, firstName,
						chineseName, title, religion, sex,
						dob_yy, dob_mm, dob_dd,
						decease_yy, decease_mm, decease_dd,
						ageGroup, educationLevelID, occupationID, hkid, passport,
						street1, street2, street3, street4, districtID, areaID, country,
						language, homeNumber, officeNumber, mobileNumber, faxNumber,
						email, emergencyContactPerson, emergencyContactNumber, emergencyContactRelationship,
						faceBook, income, willingPromotion, preferContactMethod,
						createUser, createSiteCode, createDeptCode, createUser,userID , (isLMCCRM?"1":"0"), remarks} )) {

			addAccessControl(clientID, allowView, createUser);
			if(userID!= null && userID.length()>0){
				addClientUserIDInfo(userID,lastName,firstName,email,userSiteCode,createUser);
			}
			return clientID;
		} else {
			return null;
		}
	}

	
	/**
	 * Modify a client
	 * @return whether it is successful to update the record
	 */
	public static boolean update(UserBean userBean,
			String clientID,
			String lastName, String firstName) {
		return UtilDBWeb.updateQueue(
				sqlStr_updateClientName,
				new String[] {
						lastName, firstName, userBean.getLoginID(), clientID });
	}

	/**
	 * Modify a client
	 * @return whether it is successful to update the record
	 */
	public static boolean update(UserBean userBean,
			String clientID,
			String lastName, String firstName,
			String chineseName, String title, String religion, String sex,
			String dob_yy, String dob_mm, String dob_dd,
			String decease_yy, String decease_mm, String decease_dd,
			String ageGroup, String educationLevelID, String occupationID, String hkid, String passport,
			String street1, String street2, String street3, String street4, String districtID, String areaID, String country,
			String language, String homeNumber, String officeNumber, String mobileNumber, String faxNumber,
			String email, String emergencyContactPerson, String emergencyContactNumber, String emergencyContactRelationship,
			String faceBook, String income, String willingPromotion, String preferContactMethod,
			String[] allowView,String photoName, String remarks) {
		
		return update(clientID,
				lastName, firstName,
				chineseName, title, religion, sex,
				dob_yy, dob_mm, dob_dd,
				decease_yy, decease_mm, decease_dd,
				ageGroup, educationLevelID, occupationID, hkid, passport,
				street1, street2, street3, street4, districtID, areaID, country,
				language, homeNumber, officeNumber, mobileNumber, faxNumber,
				email, emergencyContactPerson, emergencyContactNumber, emergencyContactRelationship,
				faceBook, income, willingPromotion, preferContactMethod,
				allowView, userBean.getSiteCode(), userBean.getDeptCode(), userBean.getLoginID(),photoName, remarks);
	}
	
	

	/**
	 * Modify a client
	 * @return whether it is successful to update the record
	 */
	public static boolean update(
			String clientID,
			String lastName, String firstName,
			String chineseName, String title, String religion, String sex,
			String dob_yy, String dob_mm, String dob_dd,
			String decease_yy, String decease_mm, String decease_dd,
			String ageGroup, String educationLevelID, String occupationID, String hkid, String passport,
			String street1, String street2, String street3, String street4, String districtID, String areaID, String country,
			String language, String homeNumber, String officeNumber, String mobileNumber, String faxNumber,
			String email, String emergencyContactPerson, String emergencyContactNumber, String emergencyContactRelationship,
			String faceBook, String income, String willingPromotion, String preferContactMethod,
			String[] allowView, String createSiteCode, String createDeptCode, String updateUser,String photoName) {
		return update(clientID,
				lastName, firstName,
				chineseName, title, religion, sex,
				dob_yy, dob_mm, dob_dd,
				decease_yy, decease_mm, decease_dd,
				ageGroup, educationLevelID, occupationID, hkid, passport,
				street1, street2, street3, street4, districtID, areaID, country,
				language, homeNumber, officeNumber, mobileNumber, faxNumber,
				email, emergencyContactPerson, emergencyContactNumber, emergencyContactRelationship,
				faceBook, income, willingPromotion, preferContactMethod,
				allowView, createSiteCode, createDeptCode, updateUser, photoName, null);
	}
	
	public static boolean update(
			String clientID,
			String lastName, String firstName,
			String chineseName, String title, String religion, String sex,
			String dob_yy, String dob_mm, String dob_dd,
			String decease_yy, String decease_mm, String decease_dd,
			String ageGroup, String educationLevelID, String occupationID, String hkid, String passport,
			String street1, String street2, String street3, String street4, String districtID, String areaID, String country,
			String language, String homeNumber, String officeNumber, String mobileNumber, String faxNumber,
			String email, String emergencyContactPerson, String emergencyContactNumber, String emergencyContactRelationship,
			String faceBook, String income, String willingPromotion, String preferContactMethod,
			String[] allowView, String createSiteCode, String createDeptCode, String updateUser,String photoName, String remarks) {
		// try to update selected record
		if (UtilDBWeb.updateQueue(
				sqlStr_updateClient,
				new String[] {
						lastName, firstName,
						chineseName, title, religion, sex,
						dob_yy, dob_mm, dob_dd,
						decease_yy, decease_mm, decease_dd,
						ageGroup, educationLevelID, occupationID, hkid, passport,
						street1, street2, street3, street4, districtID, areaID, country,
						language, homeNumber, officeNumber, mobileNumber, faxNumber,
						email, emergencyContactPerson, emergencyContactNumber, emergencyContactRelationship,
						faceBook, income, willingPromotion, preferContactMethod,
						updateUser, photoName , remarks , clientID })) {
			
			ArrayList record = getUserName(clientID);
			if(record.size() > 0) {
				ReportableListObject row = (ReportableListObject)record.get(0);
				updateClientUserIDInfo(row.getValue(0),lastName,firstName,email,updateUser);				
			}
			if (isOwner(clientID, createSiteCode, createDeptCode)) {
				return addAccessControl(clientID, allowView, updateUser);
			} else {
				return true;
			}
		} else {			
			return false;
		}
	}
	
	public static boolean delete(UserBean userBean,
			String clientID) {
		// try to delete selected record
		if(UtilDBWeb.updateQueue(
				sqlStr_deleteClient,
				new String[] { userBean.getLoginID(), clientID } )){
			
			ArrayList record = getUserName(clientID);
			if(record.size() > 0) {
				ReportableListObject row = (ReportableListObject)record.get(0);
				deleteClientUserIDInfo(userBean.getLoginID(),row.getValue(0));
			}
			return true;
		}else{
			return false;
		}
	}

	public static ArrayList get(String clientID) {
		return get(clientID, null);
	}
	
	public static ArrayList get(String clientID, String clientUserName) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT C.CRM_LASTNAME, C.CRM_FIRSTNAME, ");
		sqlStr.append("       C.CRM_CHINESENAME, C.CRM_TITLE, C.CRM_RELIGION, C.CRM_SEX, ");
		sqlStr.append("       C.CRM_DOB_YY, C.CRM_DOB_MM, C.CRM_DOB_DD, ");
		sqlStr.append("       C.CRM_DECEASE_YY, C.CRM_DECEASE_MM, C.CRM_DECEASE_DD, ");
		sqlStr.append("       C.CRM_AGE_GROUP, C.CRM_EDUCATION_LEVEL_ID, C.CRM_OCCUPATION_ID, C.CRM_HKID, C.CRM_PASSPORT, ");
		sqlStr.append("       C.CRM_STREET1, C.CRM_STREET2, C.CRM_STREET3, C.CRM_STREET4, C.CRM_DISTRICT_ID, C.CRM_AREA_ID, C.CRM_COUNTRY, ");
		sqlStr.append("       C.CRM_LANGUAGE, C.CRM_HOME_NUMBER, C.CRM_OFFICE_NUMBER, C.CRM_MOBILE_NUMBER, C.CRM_FAX_NUMBER, ");
		sqlStr.append("       C.CRM_EMAIL, CRM_EMERGENCY_PERSON, CRM_EMERGENCY_NUMBER, CRM_EMERGENCY_RELATIONSHIP, ");
		sqlStr.append("       C.CRM_FACEBOOK, C.CRM_INCOME, C.CRM_WILLING_PROMOTION, CRM_PREFER_CONTACT_METHOD, ");
		sqlStr.append("       C.CRM_CREATED_SITE_CODE, C.CRM_CREATED_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, ");
		sqlStr.append("       C.CRM_CREATED_USER, TO_CHAR(C.CRM_CREATED_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       C.CRM_MODIFIED_USER, TO_CHAR(C.CRM_MODIFIED_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("		  C.CRM_GROUP_ID, C.CRM_USERNAME, C.CRM_CLIENT_ID, C.CRM_USERNAME,C.CRM_PHOTO_NAME,C.CRM_REMARKS ");
		sqlStr.append("FROM   CRM_CLIENTS C, CO_DEPARTMENTS D ");
		sqlStr.append("WHERE  C.CRM_CREATED_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    C.CRM_ENABLED = 1 ");
		if(clientID != null && clientID.length() > 0) {
			sqlStr.append("AND    C.CRM_CLIENT_ID = '"+clientID+"' ");
		}
		else if(clientUserName != null && clientUserName.length() > 0) {
			sqlStr.append("AND    C.CRM_USERNAME = '"+clientUserName+"' ");
		}

		//System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getClientTeamInfo(String clientID, String clientUserName) {
		StringBuffer sqlStr = new StringBuffer();
				
		sqlStr.append(" select G.CRM_GROUP_DESC , G.CRM_GROUP_ID , "); 
		sqlStr.append(" (select C2.CRM_LASTNAME||','||C2.CRM_FIRSTNAME "); 
		sqlStr.append(" from   CRM_CLIENTS C2, CRM_GROUP_COMMITTEE GC ");
		sqlStr.append(" where    	C2.CRM_ENABLED = 1 ");  
		sqlStr.append(" and       G.CRM_GROUP_ID = GC.CRM_GROUP_ID ");
		sqlStr.append(" and       GC.CRM_ENABLED = 1 ");
		sqlStr.append(" and       C2.CRM_CLIENT_ID = GC.CRM_CLIENT_ID ");
		sqlStr.append(" and       GC.CRM_GROUP_POSITION = 'team_leader') as CRM_GROUP_LEADERNAME, ");
		sqlStr.append(" (select C2.CRM_LASTNAME||','||C2.CRM_FIRSTNAME "); 
		sqlStr.append(" from   CRM_CLIENTS C2, CRM_GROUP_COMMITTEE GC ");
		sqlStr.append(" where    	C2.CRM_ENABLED = 1 ");  
		sqlStr.append(" and       G.CRM_GROUP_ID = GC.CRM_GROUP_ID ");
		sqlStr.append(" and       GC.CRM_ENABLED = 1 ");
		sqlStr.append(" and       C2.CRM_CLIENT_ID = GC.CRM_CLIENT_ID ");
		sqlStr.append(" and       GC.CRM_GROUP_POSITION = 'case_manager') as CRM_GROUP_MANAGERNAME, ");
		sqlStr.append(" (select C2.CRM_EMAIL ");
		sqlStr.append(" from   CRM_CLIENTS C2, CRM_GROUP_COMMITTEE GC ");
		sqlStr.append(" where    	C2.CRM_ENABLED = 1 ");  
		sqlStr.append(" and       G.CRM_GROUP_ID = GC.CRM_GROUP_ID ");
		sqlStr.append(" and       GC.CRM_ENABLED = 1 ");
		sqlStr.append(" and       C2.CRM_CLIENT_ID = GC.CRM_CLIENT_ID ");
		sqlStr.append(" and       GC.CRM_GROUP_POSITION = 'team_leader') as CRM_GROUP_LEADERNAME, ");
		sqlStr.append(" (select C2.CRM_EMAIL ");
		sqlStr.append(" from   CRM_CLIENTS C2, CRM_GROUP_COMMITTEE GC ");
		sqlStr.append(" where    	C2.CRM_ENABLED = 1 ");  
		sqlStr.append(" and       G.CRM_GROUP_ID = GC.CRM_GROUP_ID ");
		sqlStr.append(" and       GC.CRM_ENABLED = 1 ");
		sqlStr.append(" and       C2.CRM_CLIENT_ID = GC.CRM_CLIENT_ID ");
		sqlStr.append(" and       GC.CRM_GROUP_POSITION = 'case_manager') as CRM_GROUP_LEADERNAME ");
		sqlStr.append(" from CRM_CLIENTS C, CRM_GROUP G "); 
		sqlStr.append(" where C.CRM_GROUP_ID = G.CRM_GROUP_ID ");
		sqlStr.append(" and   C.CRM_ENABLED = 1 ");
		if(clientID != null && clientID.length() > 0) {
			sqlStr.append("AND    C.CRM_CLIENT_ID = '"+clientID+"' ");
		}
		else if(clientUserName != null && clientUserName.length() > 0) {
			sqlStr.append("AND    C.CRM_USERNAME = '"+clientUserName+"' ");
		}

		//System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getList(String siteCode, String deptCode,
			String pid, String lastName,
			String firstName, String chineseName, String sex,
			String phoneNumber, String id,boolean isLMCCRM) {
		return getList(siteCode, deptCode, pid, lastName,
				firstName, chineseName, sex,
				phoneNumber, null, null, null, id,isLMCCRM);
	}

	public static ArrayList getList(String lastName,
			String firstName, String chineseName, String sex,
			String officePhone, String homePhone, String mobilePhone,
			String id) {
		return getList(null, null, null, lastName,
				firstName, chineseName, sex,
				null, officePhone, homePhone, mobilePhone, id,false);
	}

	public static ArrayList getList(String siteCode, String deptCode,
			String pid, String lastName,
			String firstName, String chineseName, String sex,
			String phoneNumber, String officePhone, String homePhone, String mobilePhone,
			String id,boolean isLMCCRM) {
		// fetch client
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CRM_CLIENT_ID, CRM_LASTNAME, CRM_FIRSTNAME, CRM_CHINESENAME, ");
		sqlStr.append("       CRM_HKID, ");
		sqlStr.append("       CRM_STREET1, CRM_STREET2, CRM_STREET3, CRM_STREET4, ");
		sqlStr.append("       CRM_MOBILE_NUMBER, CRM_DISTRICT_ID, CRM_AREA_ID, CRM_EMAIL, ");
		sqlStr.append("       CRM_GROUP_ID, CRM_USERNAME ");
		sqlStr.append("FROM   CRM_CLIENTS ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		if (siteCode != null && siteCode.length() > 0) {
			sqlStr.append("AND    CRM_CREATED_SITE_CODE = '");
			sqlStr.append(siteCode);
			sqlStr.append("' ");
		}
		if (deptCode != null && deptCode.length() > 0) {
			sqlStr.append("AND    CRM_CREATED_DEPARTMENT_CODE = '");
			sqlStr.append(deptCode);
			sqlStr.append("' ");
		}
		if (pid != null && pid.length() > 0) {
			sqlStr.append("AND    CRM_CLIENT_ID = '");
			sqlStr.append(pid);
			sqlStr.append("' ");
		}
		if (lastName != null && lastName.length() > 0) {
			sqlStr.append("AND    CRM_LASTNAME LIKE '%");
			sqlStr.append(lastName);
			sqlStr.append("%' ");
		}
		if (firstName != null && firstName.length() > 0) {
			sqlStr.append("AND    CRM_FIRSTNAME LIKE '%");
			sqlStr.append(firstName);
			sqlStr.append("%' ");
		}
		if (chineseName != null && chineseName.length() > 0) {
			sqlStr.append("AND    CRM_CHINESENAME LIKE '%");
			sqlStr.append(chineseName);
			sqlStr.append("%' ");
		}
		if (sex != null && sex.length() > 0) {
			sqlStr.append("AND    CRM_SEX = '");
			sqlStr.append(sex);
			sqlStr.append("' ");
		}
		if (phoneNumber != null && phoneNumber.length() > 0) {
			sqlStr.append("AND   (CRM_HOME_NUMBER LIKE '%");
			sqlStr.append(phoneNumber);
			sqlStr.append("%' OR CRM_MOBILE_NUMBER LIKE '%");
			sqlStr.append(phoneNumber);
			sqlStr.append("%') ");
		} else {
			if (officePhone != null && officePhone.length() > 0) {
				sqlStr.append("AND    CRM_OFFICE_NUMBER LIKE '%");
				sqlStr.append(officePhone);
				sqlStr.append("%' ");
			}
			if (homePhone != null && homePhone.length() > 0) {
				sqlStr.append("AND    CRM_HOME_NUMBER LIKE '%");
				sqlStr.append(homePhone);
				sqlStr.append("%' ");
			}
			if (mobilePhone != null && mobilePhone.length() > 0) {
				sqlStr.append("AND    CRM_MOBILE_NUMBER LIKE '%");
				sqlStr.append(mobilePhone);
				sqlStr.append("%' ");
			}
		}
		if (id != null && id.length() > 0) {
			sqlStr.append("AND   (CRM_HKID LIKE '%");
			sqlStr.append(id);
			sqlStr.append("%' OR CRM_PASSPORT LIKE '%");
			sqlStr.append(id);
			sqlStr.append("%') ");
		}
		if(isLMCCRM){
			sqlStr.append("AND CRM_ISTEAM20 = 1 ");
		}
		sqlStr.append("ORDER BY CRM_LASTNAME, CRM_FIRSTNAME, CRM_CLIENT_ID");
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getList(UserBean userBean, String clientID) {
		return getList(userBean, null, null, clientID, null, null, null, null, null, null, null, null, null, null, false, 1);
	}

	public static ArrayList getList(UserBean userBean,
			String siteCode, String deptCode,
			String[] clubID, String[] sex, String[] districtID, String[] areaID,
			String[] ageGroup, String[] educationLevel, String[] interestIDHobby,
			String[] interestIDHospital, String[] medicalIDIndividual, String[] medicalIDFamily,
			int noOfMaxRecord) {
		return getList(userBean,
				siteCode, deptCode, null,
				clubID, sex, districtID, areaID,
				ageGroup, educationLevel, interestIDHobby,
				interestIDHospital, medicalIDIndividual, medicalIDFamily,
				true, noOfMaxRecord);
	}

	public static ArrayList getList(UserBean userBean,
			String siteCode, String deptCode,
			String[] clubID, String[] sex, String[] districtID, String[] areaID,
			String[] ageGroup, String[] educationLevel, String[] interestIDHobby,
			String[] interestIDHospital, String[] medicalIDIndividual, String[] medicalIDFamily,
			boolean skipEmptyAddress) {
		return getList(userBean,
				siteCode, deptCode, null,
				clubID, sex, districtID, areaID,
				ageGroup, educationLevel, interestIDHobby,
				interestIDHospital, medicalIDIndividual, medicalIDFamily,
				skipEmptyAddress, 0);
	}

	public static ArrayList getList(UserBean userBean,
			String siteCode, String deptCode,
			String[] clubID, String[] sex, String[] districtID, String[] areaID,
			String[] ageGroup, String[] educationLevel, String[] interestIDHobby,
			String[] interestIDHospital, String[] medicalIDIndividual, String[] medicalIDFamily,
			boolean skipEmptyAddress, int noOfMaxRecord) {
		return getList(userBean,
				siteCode, deptCode, null,
				clubID, sex, districtID, areaID,
				ageGroup, educationLevel, interestIDHobby,
				interestIDHospital, medicalIDIndividual, medicalIDFamily,
				skipEmptyAddress, noOfMaxRecord);
	}

	public static ArrayList getList(UserBean userBean,
			String siteCode, String deptCode, String clientID,
			String[] clubID, String[] sex, String[] districtID, String[] areaID,
			String[] ageGroup, String[] educationLevel, String[] interestIDHobby,
			String[] interestIDHospital, String[] medicalIDIndividual, String[] medicalIDFamily,
			boolean skipEmptyAddress, int noOfMaxRecord) {
		// fetch client
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT C.CRM_CLIENT_ID, C.CRM_LASTNAME, C.CRM_FIRSTNAME, C.CRM_CHINESENAME, ");
		sqlStr.append("       C.CRM_HKID, ");
		sqlStr.append("       C.CRM_STREET1, C.CRM_STREET2, C.CRM_STREET3, C.CRM_STREET4, ");
		sqlStr.append("       C.CRM_MOBILE_NUMBER, C.CRM_DISTRICT_ID, C.CRM_AREA_ID, C.CRM_EMAIL ");
		sqlStr.append("FROM   CRM_CLIENTS C, CRM_CLIENTS_ACCESS_CONTROL AC ");
		sqlStr.append("WHERE  C.CRM_CLIENT_ID = AC.CRM_CLIENT_ID ");
		sqlStr.append("AND    C.CRM_ENABLED = AC.CRM_ENABLED ");
		sqlStr.append("AND    C.CRM_ENABLED = 1 ");
		sqlStr.append("AND    C.CRM_WILLING_PROMOTION = 'Y' ");	// accept promotion
		if (skipEmptyAddress) {
			sqlStr.append("AND    C.CRM_STREET1 IS NOT NULL ");	// must not empty address
		}
//		sqlStr.append("AND    AC.CRM_SITE_CODE = ? ");
//		sqlStr.append("AND    AC.CRM_DEPARTMENT_CODE = ? ");
		if (siteCode != null && siteCode.length() > 0) {
			sqlStr.append("AND    AC.CRM_SITE_CODE = '");
			sqlStr.append(siteCode);
			sqlStr.append("' ");
		}
		if (deptCode != null && deptCode.length() > 0) {
			sqlStr.append("AND    AC.CRM_DEPARTMENT_CODE = '");
			sqlStr.append(deptCode);
			sqlStr.append("' ");
		}
		if (clientID != null && clientID.length() > 0) {
			sqlStr.append("AND    C.CRM_CLIENT_ID = '");
			sqlStr.append(clientID);
			sqlStr.append("' ");
		}
		if (clubID != null && clubID.length > 0) {
			sqlStr.append("AND    C.CRM_CLIENT_ID IN (SELECT DISTINCT CRM_CLIENT_ID FROM CRM_CLIENTS_MEMBERSHIP WHERE CRM_ENABLED = 1 AND CRM_CLUB_ID IN (");
			for (int i = 0; i < clubID.length; i++) {
				if (i > 0) sqlStr.append(",");
				sqlStr.append("'");
				sqlStr.append(clubID[i]);
				sqlStr.append("' ");
			}
			sqlStr.append(")) ");
		}
		if (sex != null && sex.length > 0) {
			sqlStr.append("AND    C.CRM_SEX IN (");
			for (int i = 0; i < sex.length; i++) {
				if (i > 0) sqlStr.append(",");
				sqlStr.append("'");
				sqlStr.append(sex[i]);
				sqlStr.append("' ");
			}
			sqlStr.append(") ");
		}
		if (districtID != null && districtID.length > 0) {
			sqlStr.append("AND    C.CRM_DISTRICT_ID IN (");
			for (int i = 0; i < districtID.length; i++) {
				if (i > 0) sqlStr.append(",");
				sqlStr.append("'");
				sqlStr.append(districtID[i]);
				sqlStr.append("' ");
			}
			sqlStr.append(") ");
		}
		if (areaID != null && areaID.length > 0) {
			sqlStr.append("AND    C.CRM_AREA_ID IN (");
			for (int i = 0; i < areaID.length; i++) {
				if (i > 0) sqlStr.append(",");
				sqlStr.append("'");
				sqlStr.append(areaID[i]);
				sqlStr.append("' ");
			}
			sqlStr.append(") ");
		}
		if (ageGroup != null && ageGroup.length > 0) {
			sqlStr.append("AND    C.CRM_AGE_GROUP IN (");
			for (int i = 0; i < ageGroup.length; i++) {
				if (i > 0) sqlStr.append(",");
				sqlStr.append("'");
				sqlStr.append(ageGroup[i]);
				sqlStr.append("' ");
			}
			sqlStr.append(") ");
		}
		if (educationLevel != null && educationLevel.length > 0) {
			sqlStr.append("AND    C.CRM_EDUCATION_LEVEL_ID IN (");
			for (int i = 0; i < educationLevel.length; i++) {
				if (i > 0) sqlStr.append(",");
				sqlStr.append("'");
				sqlStr.append(educationLevel[i]);
				sqlStr.append("' ");
			}
			sqlStr.append(") ");
		}
		if (interestIDHobby != null && interestIDHobby.length > 0) {
			sqlStr.append("AND    C.CRM_CLIENT_ID IN (SELECT DISTINCT CRM_CLIENT_ID FROM CRM_CLIENTS_INTEREST WHERE CRM_ENABLED = 1 AND CRM_INTEREST_TYPE = 'B' AND CRM_INTEREST_ID IN (");
			for (int i = 0; i < interestIDHobby.length; i++) {
				if (i > 0) sqlStr.append(",");
				sqlStr.append("'");
				sqlStr.append(interestIDHobby[i]);
				sqlStr.append("' ");
			}
			sqlStr.append(")) ");
		}
		if (interestIDHospital != null && interestIDHospital.length > 0) {
			sqlStr.append("AND    C.CRM_CLIENT_ID IN (SELECT DISTINCT CRM_CLIENT_ID FROM CRM_CLIENTS_INTEREST WHERE CRM_ENABLED = 1 AND CRM_INTEREST_TYPE = 'S' AND CRM_INTEREST_ID IN (");
			for (int i = 0; i < interestIDHospital.length; i++) {
				if (i > 0) sqlStr.append(",");
				sqlStr.append("'");
				sqlStr.append(interestIDHospital[i]);
				sqlStr.append("' ");
			}
			sqlStr.append(")) ");
		}
		if (medicalIDIndividual != null && medicalIDIndividual.length > 0) {
			sqlStr.append("AND    C.CRM_CLIENT_ID IN (SELECT DISTINCT CRM_CLIENT_ID FROM CRM_CLIENTS_MEDICAL WHERE CRM_ENABLED = 1 AND CRM_MEDICAL_TYPE = 'I' AND CRM_MEDICAL_ID IN (");
			for (int i = 0; i < medicalIDIndividual.length; i++) {
				if (i > 0) sqlStr.append(",");
				sqlStr.append("'");
				sqlStr.append(medicalIDIndividual[i]);
				sqlStr.append("' ");
			}
			sqlStr.append(")) ");
		}
		if (medicalIDFamily != null && medicalIDFamily.length > 0) {
			sqlStr.append("AND    C.CRM_CLIENT_ID IN (SELECT DISTINCT CRM_CLIENT_ID FROM CRM_CLIENTS_MEDICAL WHERE CRM_ENABLED = 1 AND CRM_MEDICAL_TYPE = 'F' AND CRM_MEDICAL_ID IN (");
			for (int i = 0; i < medicalIDFamily.length; i++) {
				if (i > 0) sqlStr.append(",");
				sqlStr.append("'");
				sqlStr.append(medicalIDFamily[i]);
				sqlStr.append("' ");
			}
			sqlStr.append(")) ");
		}
		sqlStr.append("GROUP BY C.CRM_CLIENT_ID, C.CRM_LASTNAME, C.CRM_FIRSTNAME, C.CRM_CHINESENAME, ");
		sqlStr.append("         C.CRM_HKID, ");
		sqlStr.append("         C.CRM_STREET1, C.CRM_STREET2, C.CRM_STREET3, C.CRM_STREET4, ");
		sqlStr.append("         C.CRM_MOBILE_NUMBER, C.CRM_DISTRICT_ID, C.CRM_AREA_ID, C.CRM_EMAIL ");
		sqlStr.append("ORDER BY C.CRM_LASTNAME, C.CRM_FIRSTNAME, C.CRM_CLIENT_ID");

		return UtilDBWeb.getReportableList(sqlStr.toString(), noOfMaxRecord);
	}

	// ---------------------------------------------------------------------
	public static boolean isOwner(String clientID, String siteCode, String deptCode) {
		return UtilDBWeb.isExist(sqlStr_isExistClient_Owner,
				new String[] { clientID, siteCode, deptCode });
	}

	// ---------------------------------------------------------------------
	public static ArrayList getRelationship(String clientID, String clientRelativeID) {
		// fetch relationship
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CRM_RELATIONSHIP ");
		sqlStr.append("FROM   CRM_CLIENTS_RELATIONSHIP ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_CLIENT_ID = ? ");
		sqlStr.append("AND    CRM_RELATED_CLIENT_ID = ? ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { clientID, clientRelativeID });
	}

	public static ArrayList getMembership(String clientID) {
		// fetch membership
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CM.CRM_CLUB_ID, CM.CRM_CLUB_SEQ, M.CRM_SITE_CODE, TO_CHAR(CM.CRM_JOINED_DATE, 'dd/MM/YYYY'), M.CRM_CLUB_DESC, ");
		sqlStr.append("       CM.CRM_MEMBER_ID, TO_CHAR(CM.CRM_ISSUE_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(CM.CRM_EXPIRY_DATE, 'dd/MM/YYYY'), CM.CRM_PAID_YN,  ");
		sqlStr.append("       CM.CRM_CREATED_USER ");
		sqlStr.append("FROM   CRM_CLIENTS_MEMBERSHIP CM, CRM_CLUBS M ");
		sqlStr.append("WHERE  CM.CRM_CLUB_ID = M.CRM_CLUB_ID ");
		sqlStr.append("AND    CM.CRM_ENABLED = 1 ");
		sqlStr.append("AND    CM.CRM_CLIENT_ID = ? ");
		sqlStr.append("ORDER BY M.CRM_CLUB_DESC ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { clientID });
	}

	public static ArrayList getAffiliation(String clientID) {
		// fetch affiliation
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CRM_AFFILIATION_ID, CRM_COMPANY_NAME, CRM_COMPANY_TITLE, ");
		sqlStr.append("       TO_CHAR(CRM_MODIFIED_DATE, 'dd/MM/YYYY') ");
		sqlStr.append("FROM   CRM_CLIENTS_AFFILIATION ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_CLIENT_ID = ? ");
		sqlStr.append("ORDER BY CRM_COMPANY_NAME ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { clientID });
	}

	public static boolean disableAccessControl(String clientID, String updateUser) {
		return UtilDBWeb.updateQueue(sqlStr_deleteClientAccessControl, new String[] { updateUser, clientID });
	}

	public static boolean addAccessControl(String clientID, String[] allowView, String updateUser) {
		if (allowView != null) {
			disableAccessControl(clientID, updateUser);
			String siteCode = null;
			String deptCode = null;
			int index = 0;
			for (int i = 0; i < allowView.length; i++) {
				index = allowView[i].indexOf(ConstantsVariable.MINUS_VALUE);
				siteCode = allowView[i].substring(0, index);
				deptCode = allowView[i].substring(index + 1);
				addAccessControl(clientID, siteCode, deptCode, updateUser);
			}
			return true;
		} else {
			return false;
		}
	}

	public static boolean addAccessControl(UserBean userBean, String clientID, String siteCode, String deptCode) {
		return addAccessControl(clientID, siteCode, deptCode, userBean.getLoginID());
	}

	public static boolean addAccessControl(String clientID, String siteCode, String deptCode, String updateUser) {
		if (!UtilDBWeb.isExist(sqlStr_isExistClientAccessControl_CheckAll, new String[] { clientID, siteCode, deptCode })) {
			return UtilDBWeb.updateQueue(sqlStr_insertClientAccessControl, new String[] { clientID, siteCode, deptCode, updateUser, updateUser });
		} else {
			return UtilDBWeb.updateQueue(sqlStr_updateClientAccessControl, new String[] { ConstantsVariable.ONE_VALUE, updateUser, clientID, siteCode, deptCode });
		}
	}

	public static boolean isAccessable(UserBean userBean, String clientID) {
		return isAccessable(clientID, userBean.getSiteCode(), userBean.getDeptCode());
	}

	public static boolean isAccessable(String clientID, String siteCode, String deptCode) {
		return UtilDBWeb.isExist(sqlStr_isExistClientAccessControl, new String[] { clientID, siteCode, deptCode });
	}

	public static ArrayList getAccessControl(String clientID) {
		return UtilDBWeb.getReportableList(sqlStr_getClientAccessControl, new String[] { clientID });
	}

	public static String getClientName(String clientLastName, String clientFirstName) {
		String clientName = "";
		if (clientFirstName != null && clientFirstName.length() > 0) {
			clientName += clientFirstName;
		}						
		if (clientLastName != null && clientLastName.length() > 0) {
			if (clientName.length() > 0) {
				clientName += " ";
			}
			clientName += clientLastName;
		}
		return clientName;
	}

	public static String createPDFAddress(HttpSession session, UserBean userBean, String clientID, String exportType, String exportColumn, String exportRow) {
		boolean is8220 = "8220".equals(exportType);
		boolean isL7160 = "L7160".equals(exportType);
		if (!is8220 && !isL7160) return null;

		ArrayList record = CRMClientDB.getList(userBean, clientID);

		if (record != null) {
			ArrayList parsedRecord = new ArrayList();
			String siteCode = userBean.getSiteCode();
			String deptCode = userBean.getDeptCode();

			// create pdf
			String locationPath = ConstantsServerSide.TEMP_FOLDER + "/" + userBean.getLoginID() + ".fo";

			// real record
			ReportableListObject realObject = (ReportableListObject) record.get(0); 

			// create dummy record
			ReportableListObject dummyObject = new ReportableListObject(realObject.getSize());
			for (int i = 0; i < realObject.getSize(); i++) {
				dummyObject.setValue(i, ConstantsVariable.EMPTY_VALUE);
			}

			// determine number of column per row
			int noOfColumnPerRow = 0; 
			if (is8220) {
				noOfColumnPerRow = 2;
			} else if (isL7160) {
				noOfColumnPerRow = 3;
			}

			// find location
			int location = Integer.parseInt(exportColumn) + ((Integer.parseInt(exportRow) - 1) * noOfColumnPerRow);

			// parse new list
			for (int j = 1; j < location; j++) {
				parsedRecord.add(dummyObject);
			}
			parsedRecord.add(realObject);

			String footer = (siteCode!=null?siteCode.toUpperCase():"") + "-" + (deptCode!=null?deptCode.toUpperCase():"") + "-" + DateTimeUtil.getCurrentDate();
			try {
				if (is8220) {
					Label_8220.toXMLfile(session, parsedRecord, locationPath, footer);
					return locationPath;
				} else if (isL7160) {
					Label_L7160.toXMLfile(session, parsedRecord, locationPath, footer);
					return locationPath;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return null;
	}

	// ---------------------------------------------------------------------
	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CRM_CLIENTS ");
		sqlStr.append("(CRM_CLIENT_ID, CRM_LASTNAME, CRM_FIRSTNAME, ");
		sqlStr.append(" CRM_CHINESENAME, CRM_TITLE, CRM_RELIGION, CRM_SEX, ");
		sqlStr.append(" CRM_DOB_YY, CRM_DOB_MM, CRM_DOB_DD, ");
		sqlStr.append(" CRM_DECEASE_YY, CRM_DECEASE_MM, CRM_DECEASE_DD, ");
		sqlStr.append(" CRM_AGE_GROUP, CRM_EDUCATION_LEVEL_ID, CRM_OCCUPATION_ID, CRM_HKID, CRM_PASSPORT, ");
		sqlStr.append(" CRM_STREET1, CRM_STREET2, CRM_STREET3, CRM_STREET4, CRM_DISTRICT_ID, CRM_AREA_ID, CRM_COUNTRY, ");
		sqlStr.append(" CRM_LANGUAGE, CRM_HOME_NUMBER, CRM_OFFICE_NUMBER, CRM_MOBILE_NUMBER, CRM_FAX_NUMBER, ");
		sqlStr.append(" CRM_EMAIL, CRM_EMERGENCY_PERSON, CRM_EMERGENCY_NUMBER, CRM_EMERGENCY_RELATIONSHIP, ");
		sqlStr.append(" CRM_FACEBOOK, CRM_INCOME, CRM_WILLING_PROMOTION, CRM_PREFER_CONTACT_METHOD, ");
		sqlStr.append(" CRM_CREATED_USER, CRM_CREATED_SITE_CODE, CRM_CREATED_DEPARTMENT_CODE, CRM_MODIFIED_USER,CRM_USERNAME,CRM_ISTEAM20 ,CRM_REMARKS ) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ");				// clientID, lastName, firstName
		sqlStr.append(" ?, ?, ?, ?, ");				// chineseName, title, religion, sex
		sqlStr.append(" ?, ?, ?, ");				// dob_yy, dob_mm, dob_dd
		sqlStr.append(" ?, ?, ?, ");				// decease_yy, decease_mm, decease_dd
		sqlStr.append(" ?, ?, ?, ?, ?, ");			// ageGroup, educationLevelID, occupationID, hkid, passport
		sqlStr.append(" ?, ?, ?, ?, ?, ?, ?, ");	// street1, street2, street3, street4, districtID, areaID, country
		sqlStr.append(" ?, ?, ?, ?, ?, ");			// language, homeNumber, officeNumber, mobileNumber, faxNumber
		sqlStr.append(" ?, ?, ?, ?, ");				// email, emergencyContactPerson, emergencyContactNumber, emergencyContactRelationship
		sqlStr.append(" ?, ?, ?, ?, ");				// faceBook, income, willingPromotion, preferContactMethod
		sqlStr.append(" ?, ?, ?, ?, ?, ?, ?)");		// userBean.getLoginID(), userBean.getSiteCode(), userBean.getDeptCode(), userBean.getLoginID() ,userID, isTeam20, remarks
		sqlStr_insertClient = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CRM_CLIENTS ");
		sqlStr.append("SET    CRM_LASTNAME = ?, CRM_FIRSTNAME = ?, ");
		sqlStr.append("       CRM_CHINESENAME = ?, CRM_TITLE = ?, CRM_RELIGION = ?, CRM_SEX = ?, ");
		sqlStr.append("       CRM_DOB_YY = ?, CRM_DOB_MM = ?, CRM_DOB_DD = ?, ");
		sqlStr.append("       CRM_DECEASE_YY = ?, CRM_DECEASE_MM = ?, CRM_DECEASE_DD = ?, ");
		sqlStr.append("       CRM_AGE_GROUP = ?, CRM_EDUCATION_LEVEL_ID = ?, CRM_OCCUPATION_ID = ?, CRM_HKID = ?, CRM_PASSPORT = ?, ");
		sqlStr.append("       CRM_STREET1 = ?, CRM_STREET2 = ?, CRM_STREET3 = ?, CRM_STREET4 = ?, CRM_DISTRICT_ID = ?, CRM_AREA_ID = ?, CRM_COUNTRY = ?, ");
		sqlStr.append("       CRM_LANGUAGE = ?, CRM_HOME_NUMBER = ?, CRM_OFFICE_NUMBER = ?, CRM_MOBILE_NUMBER = ?, CRM_FAX_NUMBER = ?, ");
		sqlStr.append("       CRM_EMAIL = ?, CRM_EMERGENCY_PERSON = ?, CRM_EMERGENCY_NUMBER = ?, CRM_EMERGENCY_RELATIONSHIP = ?, ");
		sqlStr.append("       CRM_FACEBOOK = ?, CRM_INCOME = ?, CRM_WILLING_PROMOTION = ?, CRM_PREFER_CONTACT_METHOD = ?, ");
		sqlStr.append("       CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? , CRM_PHOTO_NAME = ? , CRM_REMARKS = ? ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_CLIENT_ID = ?");
		sqlStr_updateClient = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CRM_CLIENTS ");
		sqlStr.append("SET    CRM_LASTNAME = ?, CRM_FIRSTNAME = ?, ");
		sqlStr.append("       CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_CLIENT_ID = ?");
		sqlStr_updateClientName = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CRM_CLIENTS ");
		sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_ENABLED = 1 ");
		sqlStr.append("AND    CRM_CLIENT_ID = ?");
		sqlStr_deleteClient = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO CRM_CLIENTS_ACCESS_CONTROL ");
		sqlStr.append("(CRM_CLIENT_ID, CRM_SITE_CODE, CRM_DEPARTMENT_CODE, CRM_CREATED_USER, CRM_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?, ?) ");
		sqlStr_insertClientAccessControl = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CRM_CLIENTS_ACCESS_CONTROL ");
		sqlStr.append("SET    CRM_ENABLED = ?, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_CLIENT_ID = ? ");
		sqlStr.append("AND    CRM_SITE_CODE = ? ");
		sqlStr.append("AND    CRM_DEPARTMENT_CODE = ? ");
		sqlStr_updateClientAccessControl = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CRM_CLIENTS_ACCESS_CONTROL ");
		sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CRM_CLIENT_ID = ? ");
		sqlStr_deleteClientAccessControl = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT CRM_SITE_CODE, CRM_DEPARTMENT_CODE ");
		sqlStr.append("FROM   CRM_CLIENTS_ACCESS_CONTROL ");
		sqlStr.append("WHERE  CRM_CLIENT_ID = ? ");
		sqlStr.append("AND    CRM_ENABLED = 1 ");
		sqlStr_getClientAccessControl = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM   CRM_CLIENTS_ACCESS_CONTROL ");
		sqlStr.append("WHERE  CRM_CLIENT_ID = ? ");
		sqlStr.append("AND    CRM_SITE_CODE = ? ");
		sqlStr.append("AND    CRM_DEPARTMENT_CODE = ? ");
		sqlStr_isExistClientAccessControl_CheckAll = sqlStr.toString();

		sqlStr.append("AND    CRM_ENABLED = 1 ");
		sqlStr_isExistClientAccessControl = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM   CRM_CLIENTS ");
		sqlStr.append("WHERE  CRM_CLIENT_ID = ? ");
		sqlStr.append("AND    CRM_CREATED_SITE_CODE = ? ");
		sqlStr.append("AND    CRM_CREATED_DEPARTMENT_CODE = ? ");
		sqlStr_isExistClient_Owner = sqlStr.toString();
	}
	
	public static ArrayList getClientInfo(String clientID) {
		return getClientInfo(clientID, null);
	}
	
	public static ArrayList getClientInfo(String clientID, String clientUserName) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT C.CRM_LASTNAME, C.CRM_FIRSTNAME, ");
		sqlStr.append("       C.CRM_CHINESENAME, C.CRM_TITLE, C.CRM_RELIGION, C.CRM_SEX, ");
		sqlStr.append("       C.CRM_DOB_YY, C.CRM_DOB_MM, C.CRM_DOB_DD, ");
		sqlStr.append("       C.CRM_DECEASE_YY, C.CRM_DECEASE_MM, C.CRM_DECEASE_DD, ");
		sqlStr.append("       C.CRM_AGE_GROUP, C.CRM_EDUCATION_LEVEL_ID, C.CRM_OCCUPATION_ID, C.CRM_HKID, C.CRM_PASSPORT, ");
		sqlStr.append("       C.CRM_STREET1, C.CRM_STREET2, C.CRM_STREET3, C.CRM_STREET4, C.CRM_DISTRICT_ID, C.CRM_AREA_ID, C.CRM_COUNTRY, ");
		sqlStr.append("       C.CRM_LANGUAGE, C.CRM_HOME_NUMBER, C.CRM_OFFICE_NUMBER, C.CRM_MOBILE_NUMBER, C.CRM_FAX_NUMBER, ");
		sqlStr.append("       C.CRM_EMAIL, CRM_EMERGENCY_PERSON, CRM_EMERGENCY_NUMBER, CRM_EMERGENCY_RELATIONSHIP, ");
		sqlStr.append("       C.CRM_FACEBOOK, C.CRM_INCOME, C.CRM_WILLING_PROMOTION, CRM_PREFER_CONTACT_METHOD, ");
		sqlStr.append("       C.CRM_CREATED_SITE_CODE, C.CRM_CREATED_DEPARTMENT_CODE, D.CO_DEPARTMENT_DESC, ");
		sqlStr.append("       C.CRM_CREATED_USER, TO_CHAR(C.CRM_CREATED_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       C.CRM_MODIFIED_USER, TO_CHAR(C.CRM_MODIFIED_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("		  C.CRM_GROUP_ID, C.CRM_USERNAME, C.CRM_CLIENT_ID, C.CRM_USERNAME, U.CO_SITE_CODE ");
		sqlStr.append("FROM   CRM_CLIENTS C, CO_DEPARTMENTS D ,CO_USERS U ");
		sqlStr.append("WHERE  C.CRM_CREATED_DEPARTMENT_CODE = D.CO_DEPARTMENT_CODE (+) ");
		sqlStr.append("AND    C.CRM_USERNAME = U.CO_USERNAME(+) ");
		sqlStr.append("AND    C.CRM_ENABLED = 1 ");
		if(clientID != null && clientID.length() > 0) {
			sqlStr.append("AND    C.CRM_CLIENT_ID = '"+clientID+"' ");
		}
		else if(clientUserName != null && clientUserName.length() > 0) {
			sqlStr.append("AND    C.CRM_USERNAME = '"+clientUserName+"' ");
		}

		//System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	
	
	private static boolean addClientUserIDInfo(String userName,String lastName,String firstName,String email,String siteCode,String createUser){
		return UtilDBWeb.updateQueue(
				"INSERT INTO CO_USERS (CO_USERNAME, CO_PASSWORD, " +
				"                      CO_LASTNAME, CO_FIRSTNAME, CO_EMAIL, CO_STAFF_YN, " +
				"                      CO_SITE_CODE,  CO_GROUP_ID, CO_CREATED_USER, CO_MODIFIED_USER) " +
				"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
				new String[] { userName, PasswordUtil.cisEncryption(userName), lastName, firstName, email, "N", siteCode,  "guest",createUser,createUser}); 
			
	}
	
	private static boolean updateClientUserIDInfo(String userName,String lastName,String firstName,String email,String updateUser){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CO_USERS ");
		sqlStr.append("SET    CO_LASTNAME = ?, ");
		sqlStr.append("       CO_FIRSTNAME = ?, ");	
		sqlStr.append("       CO_EMAIL = ?, ");	
		sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, ");
		sqlStr.append("       CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_USERNAME = ?");

		// update and reset password
		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { lastName, firstName, email, updateUser, userName } ) ;
	}
	
	private static boolean deleteClientUserIDInfo(String deleteUser, String userName){
		
		// update and reset password
		return UtilDBWeb.updateQueue(
				"UPDATE CO_USERS SET CO_ENABLED = 0, " +
				"       CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? " +
				"WHERE  CO_USERNAME = ?",
				new String[] { deleteUser, userName } );
	}
	
	public static ArrayList getUserName(String clientID) {
		// fetch relationship
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CRM_USERNAME ");
		sqlStr.append("FROM   CRM_CLIENTS ");		
		sqlStr.append("WHERE    CRM_CLIENT_ID = '"+clientID+"' ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static String getClientID(String userName) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CRM_CLIENT_ID ");
		sqlStr.append("FROM   CRM_CLIENTS ");		
		sqlStr.append("WHERE    CRM_USERNAME = '"+userName+"' ");

		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if(result.size() > 0) {
			ReportableListObject row = (ReportableListObject)result.get(0);
			return row.getValue(0);
		}else {
			return null;
		}
	}
	
	public static ArrayList isClientIDPWChanged(String clientID) {
		// fetch relationship
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 	CRM_CLIENT_ID,CRM_CHANGED_IDPW ");
		sqlStr.append("FROM 	CRM_CLIENTS ");		
		sqlStr.append("WHERE 	CRM_CLIENT_ID ="+clientID+" ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getListOfClientsWithIDPWChanged() {
		// fetch relationship
		StringBuffer sqlStr = new StringBuffer();
				
		sqlStr.append("SELECT C.CRM_CLIENT_ID ,C.CRM_EMAIL ,C.CRM_LASTNAME||','||C.CRM_FIRSTNAME,C.CRM_USERNAME,C.CRM_MODIFIED_DATE ");
		sqlStr.append("FROM CRM_CLIENTS C ");		
		sqlStr.append("WHERE C.CRM_CHANGED_IDPW = 1 ");
		sqlStr.append("AND   C.CRM_ENABLED = 1 ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getListOfClientsWithIDPWChangedWithGroupID() {
		// fetch relationship
		StringBuffer sqlStr = new StringBuffer();
				
		sqlStr.append("SELECT C.CRM_CLIENT_ID ,C.CRM_EMAIL ,C.CRM_LASTNAME||','||C.CRM_FIRSTNAME,C.CRM_USERNAME,C.CRM_MODIFIED_DATE,C.CRM_GROUP_ID ");
		sqlStr.append("FROM CRM_CLIENTS C ");		
		sqlStr.append("WHERE C.CRM_CHANGED_IDPW = 1 ");
		sqlStr.append("AND   C.CRM_ENABLED = 1 ");
		sqlStr.append("AND   C.CRM_GROUP_ID IS NOT NULL");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getClientLogBookLatestRecord(String clientID) {
		// fetch relationship
		StringBuffer sqlStr = new StringBuffer();
							
		sqlStr.append("SELECT   DISTINCT CA.CRM_QUESTIONAIRE_CAID, CA.CRM_CREATED_DATE ");
		sqlStr.append("FROM     CRM_QUESTIONAIRE_CLIENT_ANSWER CA ");		
		sqlStr.append("WHERE    CA.CRM_ENABLED = 1 ");
		sqlStr.append("AND      CA.CRM_CLIENT_ID = '"+clientID+"' ");
		sqlStr.append("ORDER BY CA.CRM_CREATED_DATE DESC ");
		
		//System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static boolean isAllTeamCaseManager(String clientID) {
		if(clientID != null && clientID.length() > 0){		
			StringBuffer sqlStr = new StringBuffer();
			
			sqlStr.append("select 1 ");
			sqlStr.append("from   CRM_GROUP G, CRM_GROUP_COMMITTEE GC ");
			sqlStr.append("where  G.CRM_GROUP_ID = GC.CRM_GROUP_ID ");
			sqlStr.append("and    GC.CRM_ENABLED = 1 ");
			sqlStr.append("and    GC.CRM_GROUP_POSITION = 'case_manager' ");
			sqlStr.append("and    GC.CRM_CLIENT_ID = '"+clientID+"'" );
			
			return UtilDBWeb.isExist(sqlStr.toString());
		}else{
			return false;
		}
	}
	
	public static boolean isCaseManager(String clientID) {
		if(clientID != null && clientID.length() > 0){
			ArrayList record = CRMClientDB.get(clientID);	
			String groupID = "";		
			if (record != null && record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				groupID = row.getValue(44);
			}
	
			StringBuffer sqlStr = new StringBuffer();
			
			sqlStr.append("select 1 ");
			sqlStr.append("from   CRM_GROUP G, CRM_GROUP_COMMITTEE GC ");
			sqlStr.append("where  G.CRM_GROUP_ID = '"+groupID+"' ");
			sqlStr.append("and    G.CRM_GROUP_ID = GC.CRM_GROUP_ID ");
			sqlStr.append("and    GC.CRM_ENABLED = 1 ");
			sqlStr.append("and    GC.CRM_GROUP_POSITION = 'case_manager' ");
			sqlStr.append("and    GC.CRM_CLIENT_ID = '"+clientID+"'" );
			
			return UtilDBWeb.isExist(sqlStr.toString());
		}else{
			return false;
		}
	}
	
	public static boolean isCaseManager(String clientID,String groupID) {
		if(clientID != null && clientID.length() > 0){			
			StringBuffer sqlStr = new StringBuffer();
			
			sqlStr.append("select 1 ");
			sqlStr.append("from   CRM_GROUP G, CRM_GROUP_COMMITTEE GC ");
			sqlStr.append("where  G.CRM_GROUP_ID = '"+groupID+"' ");
			sqlStr.append("and    G.CRM_GROUP_ID = GC.CRM_GROUP_ID ");
			sqlStr.append("and    GC.CRM_ENABLED = 1 ");
			sqlStr.append("and    GC.CRM_GROUP_POSITION = 'case_manager' ");
			sqlStr.append("and    GC.CRM_CLIENT_ID = '"+clientID+"'" );
			
			return UtilDBWeb.isExist(sqlStr.toString());
		}else{
			return false;
		}
	}
	
} 