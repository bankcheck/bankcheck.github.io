package com.hkah.web.db;

import java.util.ArrayList;
import java.util.List;

import org.apache.commons.lang.StringEscapeUtils;
import org.apache.commons.lang.StringUtils;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class DntTrackDB {

	private static String sqlStr_insertTrack = null;
	private static String sqlStr_updateTrack = null;
	private static String sqlStr_deleteTrack = null;
	private static String sqlStr_getTrack = null;
	//private static String sqlStr_getdocDETAILS = null;

	/*
	 * Fields:
	 * 
	 * dnt_site_code
	dnt_track_id
	dnt_instr_id
	dnt_hosp_no
	dnt_patient_name
	dnt_date
	dnt_created_date
	dnt_created_user
	dnt_modified_date
	dnt_modified_user
	dnt_enabled
   */
	private static String getNexttrackId() {
		String dntTrackId = null;

		// get next scheduled id from db //
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(DNT_TRACK_ID) + 1 FROM DNT_TRACK WHERE DNT_SITE_CODE = ?",
				new String[] { ConstantsServerSide.SITE_CODE });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			dntTrackId = reportableListObject.getValue(0);

			// set 1 for initial
			if (dntTrackId == null || dntTrackId.length() == 0) return ConstantsVariable.ONE_VALUE;
		}
		return dntTrackId;
	}

	public static String add(
			UserBean userBean,
			String dntInstruId,
			String dntHospno,
			String dntPatientname,
			String dntDate
			) {
		// get next schedule ID
		String dntTrackId = getNexttrackId();

		// try to insert a new record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertTrack,
				new String[] {
						ConstantsServerSide.SITE_CODE, dntTrackId,
						dntInstruId,
						dntHospno,
						dntPatientname,
						dntDate,
						userBean.getLoginID(), userBean.getLoginID()
				})) {
			return dntTrackId;
		} else {
			return null;
		}
	}

	public static boolean update(
			UserBean userBean,
			String dntTrackId,
			String dntInstruId,
			String dntHospno,
			String dntPatientname,
			String dntDate
	) {
		// try to update selected record
		if(UtilDBWeb.updateQueue(
				sqlStr_updateTrack,
				new String[] {
						dntInstruId,
						dntHospno,
						dntPatientname,
						dntDate,
						userBean.getLoginID(),
						ConstantsServerSide.SITE_CODE, dntTrackId,
				})) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean delete(UserBean userBean, String dntTrackId) {
		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteTrack,
				new String[] { userBean.getLoginID(), ConstantsServerSide.SITE_CODE, dntTrackId });
	}

	public static ArrayList getList(
			String dntInstruId, String dntHospno, String dntPatientname, String dntDateFrom, String dntDateTo){
		return getList(dntInstruId, dntHospno, dntPatientname, dntDateFrom, dntDateTo, 0);
	}
	public static ArrayList getList(
			String dntInstruId, String dntHospno, String dntPatientname, String dntDateFrom, String dntDateTo, int noOfMaxRecord){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append(	"select DNT_SITE_CODE, DNT_TRACK_ID," +
						" DNT_INSTRU_ID, DNT_HOSP_NO," +
						" DNT_PATIENT_NAME, DNT_DATE " +
						" from DNT_TRACK");
		sqlStr.append(" where DNT_ENABLED = 1");
		StringBuffer whereStr = new StringBuffer();
		List<String> whereParams = new ArrayList<String>();
		if(!StringUtils.isBlank(dntInstruId)){
			whereStr.append(" and UPPER(DNT_INSTRU_ID) like '%" + StringEscapeUtils.escapeSql(dntInstruId.trim().toUpperCase()) + "%'");
		}
		if(!StringUtils.isBlank(dntHospno)){
			whereStr.append(" and UPPER(DNT_HOSP_NO) like '%" + StringEscapeUtils.escapeSql(dntHospno.trim().toUpperCase()) + "%'");
		}
			if(!StringUtils.isBlank(dntDateFrom)){
			whereStr.append(" and TO_CHAR(DNT_DATE, 'dd/MM/yyyy') >= ?");
			whereParams.add(StringEscapeUtils.escapeSql(dntDateFrom.trim()));
		}
		if(!StringUtils.isBlank(dntDateTo)){
			whereStr.append(" and TO_CHAR(DNT_DATE, 'dd/MM/yyyy') <= ?");
			whereParams.add(StringEscapeUtils.escapeSql(dntDateTo.trim()));
		}
		sqlStr.append(whereStr);
		sqlStr.append(" order by DNT_INSTRU_ID desc");
		
		String[] whereParamsArray = whereParams.toArray(new String[]{});
		if (noOfMaxRecord > 0) {
			return UtilDBWeb.getReportableList(sqlStr.toString(), whereParamsArray, noOfMaxRecord);
		} else {
			return UtilDBWeb.getReportableList(sqlStr.toString(), whereParamsArray);
		}
	}

	public static ArrayList get(String dntTrackId) {
		return UtilDBWeb.getReportableList(sqlStr_getTrack, new String[] { ConstantsServerSide.SITE_CODE, dntTrackId });
	}

	static {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("INSERT INTO DNT_TRACK ");
		sqlStr.append("(DNT_SITE_CODE, DNT_TRACK_ID,");
		sqlStr.append(" DNT_INSTRU_ID, ");
		sqlStr.append(" DNT_HOSP_NO,");
		sqlStr.append(" DNT_PATIENT_NAME,");
		sqlStr.append(" DNT_DATE,");
		sqlStr.append(" DNT_CREATED_USER, DNT_MODIFIED_USER) ");
		
		sqlStr.append("VALUES");
		sqlStr.append(" (?, ?, ");
		sqlStr.append(" ?, ");
		sqlStr.append(" ?, ");
		sqlStr.append(" ?, ");
		sqlStr.append(" TO_DATE(?, 'dd/MM/yyyy HH24:MI'), ");
		sqlStr.append(" ?, ? )");
		sqlStr_insertTrack = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE DNT_TRACK ");
		sqlStr.append("SET ");
		sqlStr.append(" DNT_INSTRU_ID = ?, ");
		sqlStr.append(" DNT_HOSP_NO = ?, ");
		sqlStr.append(" DNT_PATIENT_NAME = ?, ");
		sqlStr.append(" DNT_DATE = ?, ");
		sqlStr.append(" DNT_MODIFIED_DATE = SYSDATE, DNT_MODIFIED_USER = ? ");		
		sqlStr.append("WHERE");
		sqlStr.append(" DNT_SITE_CODE = ?");
		sqlStr.append(" AND DNT_TRACK_ID = TO_NUMBER(?)");
		sqlStr.append(" AND DNT_ENABLED = 1");
		sqlStr_updateTrack = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE DNT_TRACK ");
		sqlStr.append("SET    DNT_ENABLED = 0, DNT_MODIFIED_DATE = SYSDATE, DNT_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  DNT_SITE_CODE = ? ");
		sqlStr.append("AND    DNT_TRACK_ID = ? ");
		sqlStr.append("AND    DNT_ENABLED = 1 ");
		sqlStr_deleteTrack = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append(	"SELECT " +
						"DNT_SITE_CODE, " +
						"DNT_TRACK_ID, " +
						"DNT_INSTRU_ID, " +
						"DNT_HOSP_NO, " +
						"DNT_PATIENT_NAME, " +
						"TO_CHAR(DNT_DATE, 'dd/MM/yyyy HH24:MI'), " +
						"DNT_CREATED_DATE, " +
						"DNT_CREATED_USER, " +
						"DNT_MODIFIED_DATE, " +
						"DNT_MODIFIED_USER, " +
						"DNT_ENABLED ");
		sqlStr.append("FROM   DNT_TRACK ");
		sqlStr.append("WHERE  DNT_ENABLED = 1 ");
		sqlStr.append("AND    DNT_SITE_CODE = ? ");
		sqlStr.append("AND    DNT_TRACK_ID = ? ");
		sqlStr_getTrack = sqlStr.toString();

	}
}