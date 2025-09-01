/*
 * Created on April 9, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.db;

import java.io.File;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Properties;
import java.util.Set;

import org.apache.log4j.Logger;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.PasswordUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class HelpDeskDB {
	private static Logger logger = Logger.getLogger(HelpDeskDB.class);

	private static String sqlStr_insertAppuser = null;
	private static String sqlStr_updateAppuser = null;
	private static String sqlStr_adminUpdateAppuser = null;
	private static String sqlStr_deleteAppuser = null;
	private static String sqlStr_insertPhoto = null;
	private static String sqlStr_updateAppuserPhoto = null;
	private static String sqlStr_updateSr = null;
	private static String sqlStr_updateSrPhoto = null;
	private static String sqlStr_logout = null;
	private static String sqlStr_addLocation = null;
	private static String sqlStr_insertSr = null;
	private static String sqlStr_insertSrLog = null;
	
	public static String LOGINSTATUS_LOGOUT_LOGIN = "0";
	public static String LOGINSTATUS_LOGOUT = "2";

	public static String APPCONFIG_KEY_PHOTO_PATH = "photo_path";
	
	private static Properties properties = null;
	private static final String DEFAULT_CONFIG = "/WebConfig/HelpDesk/db.conf";
	
	public static final String LOG_STATE_INIT = "-1";
	public static final String LOG_STATE_CREATE = "0";
	/*
		desc appuser
		Name        Null     Type          
		----------- -------- ------------- 
		USERID      NOT NULL VARCHAR2(40)  
		FIRSTNAME            VARCHAR2(100)  
		LASTNAME             VARCHAR2(50)  
		NICKNAME             VARCHAR2(100)  
		PASSWORD             VARCHAR2(50)  
		USERTYPE             NUMBER(38)    
		PHONE                VARCHAR2(20)  
		PHOTO                VARCHAR2(128) 
		LOGINSTATUS          NUMBER(38)    
		DEPTCODE             VARCHAR2(10)  
	 */
	public static ArrayList getList(String userId, String deptCode, String name, String userType, String loginStatus, String enabled) {
		// fetch user
		List<String> paramsList = new ArrayList<String>();
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT	USERID, ");
		sqlStr.append("			FIRSTNAME, LASTNAME, NICKNAME, PASSWORD, ");
		sqlStr.append("			USERTYPE, PHONE, PHOTO, ");
		sqlStr.append("			LOGINSTATUS, DEPTCODE ");
		sqlStr.append("FROM   	APPUSER@helpdesk ");
		sqlStr.append("WHERE   	1=1  ");
		if (userId != null && !userId.isEmpty()) {
			sqlStr.append("AND   	UPPER(USERID) like '%" + userId.toUpperCase() + "%' ");
		}
		if (deptCode != null && !deptCode.isEmpty()) {
			sqlStr.append("AND   	DEPTCODE = ? ");
			paramsList.add(deptCode);
		}
		if (name != null && !name.isEmpty()) {
			sqlStr.append("AND ");
			sqlStr.append("(UPPER(FIRSTNAME) like '%" + name.toUpperCase() + "%' ");
			sqlStr.append("OR UPPER(LASTNAME) like '%" + name.toUpperCase() + "%' ");
			sqlStr.append("OR UPPER(NICKNAME) like '%" + name.toUpperCase() + "%') ");
		}
		if (userType != null && !userType.isEmpty()) {
			sqlStr.append("AND   	USERTYPE = ? ");
			paramsList.add(userType);
		}
		if (loginStatus != null && !loginStatus.isEmpty()) {
			sqlStr.append("AND   	LOGINSTATUS = ? ");
			paramsList.add(loginStatus);
		}
		if (enabled != null && !enabled.isEmpty()) {
			sqlStr.append("AND   	PASSWORD is " + ("0".equals(enabled) ? "" : "not") + " null ");
		}
		sqlStr.append("ORDER BY	USERID");

		String[] params = (String []) paramsList.toArray(new String[paramsList.size()]);
		//System.out.println("[DEBUG] getList sql="+sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString(), params);
	}
	
	public static ArrayList get(String userId) {
		// fetch user
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT	distinct ");
		sqlStr.append("			au.USERID, ");
		sqlStr.append("			au.FIRSTNAME, au.LASTNAME, au.NICKNAME, au.PASSWORD, ");
		sqlStr.append("			au.USERTYPE, au.PHONE, au.PHOTO, ");
		sqlStr.append("			au.LOGINSTATUS, au.DEPTCODE, ");
		sqlStr.append("			u.co_staff_id, p.url, ");
		sqlStr.append("			case when p.url is null then null else cf.value || p.url end ");
		sqlStr.append("FROM   	APPUSER@helpdesk au left join co_users u on au.userid = lower(u.co_staff_id) ");
		sqlStr.append("			left join photo@helpdesk p on au.PHOTO = p.id ");
		sqlStr.append("			left join appconfig@helpdesk cf on cf.key = 'photo_url' ");
		sqlStr.append("where 	(u.co_enabled = 1 or u.co_staff_id is null) ");
		sqlStr.append("and   	au.USERID = ? ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{userId});
	}
	
	public static boolean add(
			String userid, 
			String firstName,
			String lastName,
			String nickname,
			String passwordPlain,
			String password,
			String usertype,
			String phone,
			String photo,
			String deptcode) {
		if (passwordPlain != null && !passwordPlain.isEmpty()) {
			password = hashPassword(passwordPlain);
		}
		if (UtilDBWeb.updateQueue(sqlStr_insertAppuser,
				new String[] {
						userid, firstName, lastName, nickname, password, usertype, phone, photo, LOGINSTATUS_LOGOUT, deptcode
				} )) {
			return true;
		}
		return false;
	}
	
	public static boolean update(
			String userid, 
			String firstName,
			String lastName,
			String nickname,
			String passwordPlain,
			String password,
			String usertype,
			String phone,
			String photo,
			String deptcode) {
		if (passwordPlain != null && !passwordPlain.isEmpty()) {
			password = hashPassword(passwordPlain);
		}
		return UtilDBWeb.updateQueue(
				sqlStr_updateAppuser,
				new String[] { firstName, lastName, nickname, password, usertype, phone, photo, deptcode, userid});
	}
	
	public static boolean adminUpdate(
			String userid, 
			String firstName,
			String lastName,
			String nickname,
			String phone,
			String photo,
			String deptcode) {
		return UtilDBWeb.updateQueue(
				sqlStr_adminUpdateAppuser,
				new String[] { firstName, lastName, nickname, phone, photo, deptcode, userid});
	}
	
	public static boolean updatePhoto(
			String userid, 
			String photoId,
			String photoFileName) {
		if (UtilDBWeb.updateQueue(
				sqlStr_insertPhoto,
				new String[] { photoId, photoFileName})) {
			return UtilDBWeb.updateQueue(
					sqlStr_updateAppuserPhoto,
					new String[] { photoId, userid });
		}
		return false;
	}
	
	public static boolean delete(String userid) {
		return UtilDBWeb.updateQueue(
				sqlStr_deleteAppuser,
				new String[] { userid });
	}
	
	public static boolean logout(String userid) {
		return UtilDBWeb.updateQueue(
				sqlStr_logout,
				new String[] { LOGINSTATUS_LOGOUT, userid });
	}
	
	public static boolean synchronizePortalUser() {
		return synchronizePortalUser(null);
	}
	
	public static boolean synchronizePortalUser(String[] appuserFields) {
		boolean ret = false;
		boolean isInsertMode = true;

		List<String> paramsList = new ArrayList<String>();
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("  lower(s.co_staff_id), ");
		sqlStr.append("  substr(s.co_staffname, 1, 100), ");
		sqlStr.append("  'HKAH', ");
		sqlStr.append("  substr(s.co_staffname, 1, 100), ");
		sqlStr.append("  u.co_password, ");
		sqlStr.append("  s.co_department_code ");
		sqlStr.append("from co_staffs s join co_users u on s.co_staff_id = u.co_staff_id ");
		sqlStr.append("where u.co_site_code = '" + ConstantsServerSide.SITE_CODE.toLowerCase() + "' ");
		sqlStr.append("and u.co_enabled = 1 ");
		sqlStr.append("and s.co_enabled = 1 ");
		
		StringBuffer insertSqlStr = new StringBuffer();
		insertSqlStr.append("INSERT INTO APPUSER@helpdesk ");
		insertSqlStr.append("(USERID, FIRSTNAME, LASTNAME, NICKNAME, PASSWORD, USERTYPE, PHONE, PHOTO, LOGINSTATUS, DEPTCODE) ");
		insertSqlStr.append("VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");			

		StringBuffer updateSqlStr = new StringBuffer();
		updateSqlStr.append("UPDATE APPUSER@helpdesk SET 1=1 ");
		if (appuserFields != null && appuserFields.length > 0) {
			for (String field : appuserFields) {
				updateSqlStr.append(", " + field + " = ? "); 
			}
		} else {
			updateSqlStr.append(", FIRSTNAME = ?, LASTNAME = ?, NICKNAME = ?, PASSWORD = ?, DEPTCODE = ? ");
		}
		updateSqlStr.append("WHERE USERID = ?");
		
		StringBuffer updateFirstnameDeptCodeSqlStr = new StringBuffer();
		updateFirstnameDeptCodeSqlStr.append("UPDATE APPUSER@helpdesk ");
		updateFirstnameDeptCodeSqlStr.append("SET FIRSTNAME = ?, DEPTCODE = ? ");
		updateFirstnameDeptCodeSqlStr.append("WHERE USERID = ?");
		
		List<ReportableListObject> result = UtilDBWeb.getReportableList(sqlStr.toString());
		ReportableListObject rlo = null;
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT ");
		sqlStr.append("  USERID ");
		sqlStr.append("from APPUSER@helpdesk");
		List<ReportableListObject> result2 = UtilDBWeb.getReportableList(sqlStr.toString());
		List<String> resultAppuser = new ArrayList<String>();
		for (int i = 0; i < result2.size(); i++) {
			resultAppuser.add(result2.get(i).getFields0());
		}
		
		System.out.println("[HelpDeskDB] HelpDeskDB.synchronizePortalUser getList size=" + result.size());
		//System.out.println("sql="+sqlStr.toString()); 
		
		if (result.size() > 0) {
			Set<String> useridNotSync = userNameDeptCodeNotSync();
			
			for (int i = 0; i < result.size(); i++) {
				rlo = (ReportableListObject) result.get(i);

				String staffIdLower = rlo.getValue(0);
				String firstname = rlo.getValue(1);
				String lastname = rlo.getValue(2);
				String pwCisEncrypted = rlo.getValue(4);
				String deptCode = rlo.getValue(5);
				String userType = "0";		// requester
				if ("MANT".equals(deptCode)) {
					userType = "2";	// default all MANT staff are workman, set up as supervisor manually
				}
				String phoneDir = null;
				String photo = null;
				String loginStatus = "2";	// sign off
				
				String pwPlainText = PasswordUtil.cisDecryption(pwCisEncrypted);
				String pwHash = PasswordUtil.md5(pwPlainText);
				
				if (resultAppuser.contains(staffIdLower)) {
					isInsertMode = false;	// update
				} else {
					isInsertMode = true;
				}
				
				boolean successInt = false;
				if (isInsertMode) {
					successInt = UtilDBWeb.updateQueue(insertSqlStr.toString(), 
						new String[]{staffIdLower, firstname, lastname, firstname, pwHash, userType, phoneDir, photo, loginStatus, deptCode});
					//System.out.println("[HelpDeskDB]  staff[" + staffIdLower + "] insert return:" + successInt); 
				} else {
					// update firstname (staffname), deptcode only
					if (useridNotSync.contains(staffIdLower)) {
						successInt = UtilDBWeb.updateQueue(updateFirstnameDeptCodeSqlStr.toString(), 
								new String[]{firstname, deptCode, staffIdLower});
						//System.out.println("[HelpDeskDB]  staff[" + staffIdLower + "] update name, deptcode return:" + successInt); 
					}
				}
			}
		}
		ret = true;
		
		return ret;
	}
	
	public static Set<String> userNameDeptCodeNotSync() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT  ");
		sqlStr.append("  uh.userid, ");
		sqlStr.append("  uh.firstname, ");
		sqlStr.append("  substr(s.co_staffname, 1, 100),  ");
		sqlStr.append("  uh.deptcode, ");
		sqlStr.append("  s.co_department_code ");
		sqlStr.append("from co_staffs s join co_users u on s.co_staff_id = u.co_staff_id  ");
		sqlStr.append("  join appuser@helpdesk uh on lower(s.co_staff_id) = lower(uh.userid) ");
		//sqlStr.append("  --left join co_department_mapping dm on s.co_department_code = dm.co_department_code2 ");
		sqlStr.append("where u.co_site_code = 'twah'  ");
		sqlStr.append("and u.co_enabled = 1  ");
		sqlStr.append("and s.co_enabled = 1 ");

		sqlStr.append("and (uh.firstname <> substr(s.co_staffname, 1, 100) ");
		sqlStr.append("  or uh.deptcode <> s.co_department_code) ");
		
		List<ReportableListObject> result = UtilDBWeb.getReportableList(sqlStr.toString());
		ReportableListObject rlo = null;
		Set<String> userids = new HashSet<String>();
		for (int i = 0; i < result.size(); i++) {
			rlo = (ReportableListObject) result.get(i);
			userids.add(rlo.getFields0());
		}
		return userids;
	}
	
	public static boolean synchronizePortalPassword() {
		return synchronizePortalPassword(null);
	}
	
	public static boolean synchronizePortalPassword(String userid) {
		boolean success = false;
		
		List<String> paramsList = new ArrayList<String>();
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select s.co_staff_id, hu.userid, u.co_password, ");
		sqlStr.append("	case when s.co_enabled = 0 or u.co_enabled = 0 then null else u.co_password end portal_password, ");
		sqlStr.append("	hu.password hu_password ");
		sqlStr.append("from co_staffs s ");
		sqlStr.append("  join co_users u on s.co_staff_id = u.co_staff_id ");
		sqlStr.append("  join appuser@helpdesk hu on lower(s.co_staff_id) = hu.userid ");
		if (userid != null && !userid.isEmpty()) {
			sqlStr.append("AND   	hu.USERID = ? ");
			sqlStr.append("AND   	upper(u.co_staff_id) = ? ");
			paramsList.add(userid);
			paramsList.add(userid.toUpperCase());
		}
		// doctor account have more than 1 co_user
		sqlStr.append("WHERE (u.co_staff_id not like 'DR%' or (u.co_staff_id like 'DR%' and u.co_username like 'DR%' and u.co_username not like 'M%')) ");
		// disabled account
		sqlStr.append(" AND hu.password not in ('ACCOUNT_DISABLED') ");
		sqlStr.append("ORDER BY	hu.USERID");
		
		StringBuffer updateSqlStr = new StringBuffer();
		updateSqlStr.append("UPDATE APPUSER@helpdesk ");
		updateSqlStr.append("SET PASSWORD = ? ");
		updateSqlStr.append("WHERE USERID = ?");			


		String[] params = (String []) paramsList.toArray(new String[paramsList.size()]);
		//System.out.println("[DEBUG] getList sql="+sqlStr.toString());
		List<ReportableListObject> result = UtilDBWeb.getReportableList(sqlStr.toString(), params);
		ReportableListObject rlo = null;
		
		System.out.println("[HelpDeskDB] synchronizePortalPassword userid=" + userid + ", list size=" + result.size());
		if (result.size() > 0) {
			for (int i = 0; i < result.size(); i++) {
				rlo = (ReportableListObject) result.get(i);
				String appuserid = rlo.getFields1();
				String pwPortalEncrypted = rlo.getFields3();
				String pwHDEncrypted = rlo.getFields4();
				String pwHash = pwPortalEncrypted != null ? convertPortalPw2HelpDeskPw(pwPortalEncrypted) : null;
				
				if ((pwPortalEncrypted == null && pwHDEncrypted != null) || 											// portal acc inactive, hd acc active
						(pwPortalEncrypted != null && pwHDEncrypted == null) ||											// portal acc active, hd acc inactive
						(pwPortalEncrypted != null && pwHDEncrypted != null && !pwHDEncrypted.equals(pwHash))) {		// portal acc active, hd acc active, pw changed
					success = UtilDBWeb.updateQueue(updateSqlStr.toString(), new String[]{pwHash, appuserid});
					System.out.println(" appuserid[" + appuserid + "] pw(portal)[" + pwPortalEncrypted + "] old pw(helpdek)[" + pwHDEncrypted + "] new pw(helpdek)[" + pwHash +" ] update:" + success);
				}
				success = true;
			}
		}
		return success;
	}
	
	public static String convertPortalPw2HelpDeskPw(String portalEncodedPw) {
		return hashPassword(PasswordUtil.cisDecryption(portalEncodedPw));
	}
	
	public static String hashPassword(String plainText) {
		return PasswordUtil.md5(plainText);
	}
	
	public static String getPhotoPath(String key) {
		String value = null;
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT	value ");
		sqlStr.append("FROM   	APPCONFIG@helpdesk ");
		sqlStr.append("where 	key = ? ");
		List<ReportableListObject> result = UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{key});
		if (!result.isEmpty()) {
			value = result.get(0).getFields0();
		}
		return value;
	}
	
	public static String getDbUUID() {
		String uuid = null;
		StringBuffer sqlStr = new StringBuffer();
		if (ConstantsServerSide.DEBUG) {
			sqlStr.append("SELECT random_uuid@helpdesk FROM dual");	// uat
		} else {
			sqlStr.append("SELECT random_uuid FROM dual@helpdesk");	// production
		}
		List<ReportableListObject> result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (!result.isEmpty()) {
			uuid = result.get(0).getFields0();
		}
		return uuid;
	}
	
	public static String uploadPhoto(String photoFileName) {
		// Get Photo ID
		String photoId = getDbUUID();
		
		UtilDBWeb.updateQueue(
				sqlStr_insertPhoto,
				new String[] { photoId, photoFileName});
		
		return photoId;
	}
	
	public static boolean updateSr(String srId, String content) {
		
		if (UtilDBWeb.updateQueue(
				sqlStr_updateSr,
				new String[] { content, srId })){
			return true;
		}else{
			return false;
		}
	}
	
	public static boolean updateSrPhoto(String srId, String photoId) {
		
		if (UtilDBWeb.updateQueue(
				sqlStr_updateSrPhoto,
				new String[] { photoId, srId })){
			return true;
		}else{
			return false;
		}
	}
	
	public static String getNextSrCode() {
		String srCode = "";
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT SR_SEQ.NEXTVAL@helpdesk ");
		sqlStr.append("FROM dual");
		
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		
		if (result.size() > 0){
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			srCode = reportableListObject.getValue(0);
			
			if (srCode == "" || srCode.length() == 0) return "1";
		} else {
			return "1";
		}

		return srCode;
	}
	
	public static String addLocation(String location) {
		String locationId = getDbUUID();
		
		UtilDBWeb.updateQueue(
				sqlStr_addLocation,
				new String[] { locationId, location, location });
		
		return locationId;
		
	}
	
	public static String getLocationId(String location) {
		String locationId = "";
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT ID ");
		sqlStr.append("FROM LOCATION@helpdesk ");
		sqlStr.append("WHERE NAME = '" + location + "'");
		
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		
		if (result.size() > 0){
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			locationId = reportableListObject.getValue(0);
			if (locationId == "" || locationId.length() == 0) {
				//new location
				locationId = addLocation(location);
			}
		}else{
			locationId = addLocation(location);
		}

		return locationId;
	}
	
	public static boolean addSr(
			String srId, 
			String locationId,
			String userId,
			String stage,
			String photo,
			String content,
			String deptcode,
			String realRequester,
			String srCode) {
		if (UtilDBWeb.updateQueue(sqlStr_insertSr,
				new String[] {
					srId, locationId, userId, stage, photo, content, deptcode, realRequester, srCode
				} )) {
			return true;
		}
		return false;
	}
	
	public static boolean addSrLog(
			String srLogId, 
			String srId,
			String fromState,
			String toState,
			String remarks,
			String appUser) {
		if (UtilDBWeb.updateQueue(sqlStr_insertSrLog,
				new String[] {
				srLogId, srId, fromState, toState, remarks, appUser
				} )) {
			return true;
		}
		return false;
	}
	
	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO APPUSER@helpdesk ");
		sqlStr.append("(USERID,FIRSTNAME,LASTNAME,NICKNAME,PASSWORD,USERTYPE,PHONE,PHOTO,LOGINSTATUS,DEPTCODE) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
		sqlStr_insertAppuser = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE APPUSER@helpdesk ");
		sqlStr.append("SET    FIRSTNAME = ?,LASTNAME = ?,NICKNAME = ?,PASSWORD = ?,USERTYPE = ?,PHONE = ?,PHOTO = ?,DEPTCODE = ? ");
		sqlStr.append("WHERE  USERID = ? ");
		sqlStr_updateAppuser = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE APPUSER@helpdesk ");
		sqlStr.append("SET    FIRSTNAME = ?,LASTNAME = ?,NICKNAME = ?,PHONE = ?,PHOTO = ?,DEPTCODE = ? ");
		sqlStr.append("WHERE  USERID = ? ");
		sqlStr_adminUpdateAppuser = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("DELETE FROM APPUSER@helpdesk ");
		sqlStr.append("WHERE  USERID = ? ");
		sqlStr_deleteAppuser = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE APPUSER@helpdesk ");
		sqlStr.append("SET    LOGINSTATUS = ? ");
		sqlStr.append("WHERE  USERID = ? ");
		sqlStr_logout = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO PHOTO@helpdesk ");
		sqlStr.append("(ID, URL) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?)");
		sqlStr_insertPhoto = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE APPUSER@helpdesk ");
		sqlStr.append("SET    PHOTO = ? ");
		sqlStr.append("WHERE  USERID = ? ");
		sqlStr_updateAppuserPhoto = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE SERVICEREQUEST@helpdesk ");
		sqlStr.append("SET    CONTENT = ?, UPDATETIME = CURRENT_TIMESTAMP ");
		sqlStr.append("WHERE  ID = ? ");
		sqlStr_updateSr = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE SERVICEREQUEST@helpdesk ");
		sqlStr.append("SET    PHOTO = ?, UPDATETIME = CURRENT_TIMESTAMP ");
		sqlStr.append("WHERE  ID = ? ");
		sqlStr_updateSrPhoto = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO LOCATION@helpdesk ");
		sqlStr.append("(ID, NAME, BUILDING) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?)");
		sqlStr_addLocation = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO SERVICEREQUEST@helpdesk ");
		sqlStr.append("(ID, LOCATION, REQUESTER, STATE, CREATETIME, UPDATETIME, PHOTO, CONTENT, DEPTCODE, REALREQUESTER, CODE) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?, CURRENT_TIMESTAMP, CURRENT_TIMESTAMP, ?, ?, ?, ?, ?)");
		sqlStr_insertSr = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO SERVICELOG@helpdesk ");
		sqlStr.append("(ID,REQUEST,FROMSTATE,TOSTATE,REMARKS,LOGTIME,APPUSER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?, ?, CURRENT_TIMESTAMP, ?)");
		sqlStr_insertSrLog = sqlStr.toString();
		
		properties = readProperties(DEFAULT_CONFIG);
	}	
	
	public static String getDbConf(String key) {
		return getProperty(properties, key);
	}
	
	private static Properties readProperties(String fileName) {
		try {
			Properties properties = new Properties();
			properties.load(new FileInputStream(new File(fileName)));
			return properties;
		} catch (Exception e) {
			return null;
		}
	}
	
	private static String getProperty(Properties properties, String key) {
		String result = null;

		// get value from properties
		if (properties != null) {
			try {
				result = properties.getProperty(key);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		return result;
	}
}