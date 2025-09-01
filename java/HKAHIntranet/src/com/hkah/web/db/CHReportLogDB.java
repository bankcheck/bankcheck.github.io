package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;

public class CHReportLogDB {

	public static void addErrorLog(String module, String patNo, String path,
									String keyID, String detail) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("INSERT INTO CH_REPORT_LOG(CO_SITE_CODE, CH_REPORT_ID, ");
		sqlStr.append("CH_REPORT_MODULE, CH_REPORT_PATNO, CH_REPORT_PATH, ");
		sqlStr.append("CH_REPORT_KEY_ID, CH_REPORT_DETAIL) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ?, ?, ?, ?) ");
		
		UtilDBWeb.updateQueue(sqlStr.toString(), 
								new String[] {  
									ConstantsServerSide.SITE_CODE,
									getNextID(module),
									module,
									patNo, 
									path,
									keyID,
									detail
								});
	}
	
	private static String getNextID(String module) {
		String rid = null;

		ArrayList result = UtilDBWeb.getReportableList(
									"SELECT MAX(CH_REPORT_ID) + 1 " +
									"FROM CH_REPORT_LOG " +
									"WHERE CH_REPORT_MODULE = '"+module+"'");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			rid = reportableListObject.getValue(0);

			// set 1 for initial
			if (rid == null || rid.length() == 0) return "1";
		}
		return rid;
	}
}
