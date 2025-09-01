package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.util.db.UtilDBWeb;

public class SMSLogDB {
	public static ArrayList getInpatSMSLog(String keyID) {
		return getSMSLog("INPAT", keyID);
	}
	
	public static ArrayList getOutpatSMSLog(String keyID) {
		return getSMSLog("OUTPAT", keyID);
	}
	
	private static ArrayList getSMSLog(String actType, String keyID) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT S.MSG_BATCH_ID, DECODE(S.MSG_LANG, 'UTF8', 'CHI', 'ENG'), ");
		sqlStr.append("S.NO_OF_MSG, S.NO_OF_SUCCESS, S.REV_AREA_CODE, ");
		sqlStr.append("S.REV_MOBILE, S.REV_OPERATOR, S.RES_CODE, S.RES_MSG, ");
		sqlStr.append("DECODE(S.SUCCESS, '1', 'Yes', 'No'), ");
		sqlStr.append("TO_CHAR(S.SEND_TIME, 'DD/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("DECODE(CS.CO_STAFFNAME, null, S.SENDER, CS.CO_STAFFNAME), S.SMS_AC, ");
		sqlStr.append("S.ACT_TYPE, S.KEY_ID, S.TEMPLATE_LANG, S.SMCID, ");
		sqlStr.append("S.MSGID, TO_CHAR(S.CREATE_DATE, 'DD/MM/YYYY HH24:MI:SS') ");
		
		sqlStr.append("FROM SMS_LOG S, CO_USERS U, CO_STAFFS CS ");
		
		sqlStr.append("WHERE S.ACT_TYPE = '"+actType+"' ");
		sqlStr.append("AND	 S.KEY_ID = '"+keyID+"' ");
		sqlStr.append("AND   S.SENDER = U.CO_USERNAME(+) ");
		sqlStr.append("AND   U.CO_STAFF_ID = CS.CO_STAFF_ID(+) ");
		sqlStr.append("ORDER BY S.CREATE_DATE DESC ");
		
		//System.out.println(sqlStr.toString());
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
}
