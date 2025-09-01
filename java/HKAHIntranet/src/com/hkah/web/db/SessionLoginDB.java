package com.hkah.web.db;

import java.util.ArrayList;
import java.util.Random;

import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class SessionLoginDB {

	private static String sqlStr_insertSessionLogin = null;
	private static String sqlStr_deleteSessionLogin = null;
	private static String sqlStr_getSessionLogin = null;
	private static String sqlStr_isExistSessionLogin = null;

	private static String generatSessionLoginID() {
		String result = "";
		Random random = new Random();

		while(result.length() < 10) {
			int randomnumber = random.nextInt();
			int tmpnumber = Math.abs((int)(36 * ((double)randomnumber / 32768)) + 48);
			/*  0 - 9, A - Z  */
			if ((tmpnumber > 47 && tmpnumber < 58) || (tmpnumber < 91 && tmpnumber > 64)) {
				/* ignore '0' and 'O' */
				if (!((char)tmpnumber == '0' || (char)tmpnumber == 'O')) {
					result = result + (char)tmpnumber;
				}
			}
		}
		return result;
	}

	public static String add(UserBean userBean, String email) {

		String sessionLoginID = null;
		String loginID = null;
		if (userBean.isLogin()) {
			loginID = userBean.getLoginID();
		}

		boolean loop = true;
		while (loop && (sessionLoginID = generatSessionLoginID()) != null && !isExist(sessionLoginID)) {
			// insert Session Login record
			UtilDBWeb.updateQueue(
				sqlStr_insertSessionLogin,
				new String[] { sessionLoginID, email,
						loginID, loginID });
			loop = false;
		}
		return sessionLoginID;
	}

	public static boolean delete(UserBean userBean, String sessionLoginID) {
		return UtilDBWeb.updateQueue(sqlStr_deleteSessionLogin, new String[] { userBean.getLoginID(), sessionLoginID });
	}

	public static ArrayList get(String sessionLoginID) {
		return UtilDBWeb.getReportableList(sqlStr_getSessionLogin, new String[] { sessionLoginID });
	}
	
	public static String getSessionEmail(String sessionLoginID) {
		ArrayList result = UtilDBWeb.getReportableList(sqlStr_getSessionLogin, new String[] { sessionLoginID });
		if(result.size()>0){
			ReportableListObject row = (ReportableListObject) result.get(0);	
			return row.getFields0();
		}else{
			return "";
		}
	}

	public static boolean isExist(String sessionLoginID) {
		return UtilDBWeb.isExist(sqlStr_isExistSessionLogin, new String[] { sessionLoginID });
	}

	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CO_SESSION_LOGIN (");
		sqlStr.append("CO_SESSION_LOGIN_ID, CO_EMAIL, ");
		sqlStr.append("CO_CREATED_USER, CO_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ");
		sqlStr.append("?, ?)");
		sqlStr_insertSessionLogin = sqlStr.toString(); 

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_SESSION_LOGIN ");
		sqlStr.append("SET    CO_ENABLED = 0, CO_MODIFIED_USER = ?, CO_MODIFIED_DATE = SYSDATE ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		sqlStr.append("AND    CO_SESSION_LOGIN_ID = ? ");
		sqlStr_deleteSessionLogin = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT CO_EMAIL ");
		sqlStr.append("FROM   CO_SESSION_LOGIN ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		sqlStr.append("AND    CO_SESSION_LOGIN_ID = ? ");
		sqlStr_getSessionLogin = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM   CO_SESSION_LOGIN ");
		sqlStr.append("WHERE  CO_SESSION_LOGIN_ID = ? ");
		sqlStr_isExistSessionLogin = sqlStr.toString();
	}
}