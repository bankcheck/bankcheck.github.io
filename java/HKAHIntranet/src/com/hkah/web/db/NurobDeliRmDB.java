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

public class NurobDeliRmDB {

	private static String sqlStr_insertDeliRm = null;
	private static String sqlStr_updateDeliRm = null;
	private static String sqlStr_deleteDeliRm = null;
	private static String sqlStr_getDeliRm = null;
	//private static String sqlStr_getdocDETAILS = null;

	/*
	 * Fields:
	 * 
	 * nurob_site_code
	nurob_deli_rm_id
	nurob_mo_patno
	nurob_mo_patfname
	nurob_mo_patgname
	nurob_mo_patcname
	nurob_phys_staff_id
	nurob_phys_name
	nurob_age
	nurob_grav
	nurob_para
	nurob_edc
	nurob_abn_mat_his
	nurob_anc
	nurob_opd_visits
	nurob_feed
	nurob_rubella_titer
	nurob_hbsag
	nurob_vdrl
	nurob_hiv
	nurob_indu_pe2
	nurob_indu_pit
	nurob_iol_reason
	nurob_position
	nurob_anesthesia
	nurob_deli_date
	nurob_mode_reason
	nurob_epi_repair
	nurob_placenta
	nurob_labo_dura
	nurob_apgar_from
	nurob_apgar_to
	nurob_sex
	nurob_weight
	nurob_post_natal
	nurob_nur_assist_name
	nurob_nur_circ_name
	nurob_created_date
	nurob_created_user
	nurob_modified_date
	nurob_modified_user
	nurob_enabled
   */
	private static String getNextDeliRmID() {
		String deliRmId = null;

		// get next scheduled id from db //
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(NUROB_DELI_RM_ID) + 1 FROM NUROB_DELI_RM WHERE NUROB_SITE_CODE = ?",
				new String[] { ConstantsServerSide.SITE_CODE });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			deliRmId = reportableListObject.getValue(0);

			// set 1 for initial
			if (deliRmId == null || deliRmId.length() == 0) return ConstantsVariable.ONE_VALUE;
		}
		return deliRmId;
	}

	public static String add(
			UserBean userBean,
			String nurobMoPatno,
			String nurobMoPatname,
			String nurobMoPatfname,
			String nurobMoPatgname,
			String nurobMoPatcname,
			String nurobPhysStaffId,
			String nurobPhysName,
			String nurobAge,
			String nurobGrav,
			String nurobPara,
			String nurobEdc,
			String nurobAbnMatHis,
			String nurobAnc,
			String nurobOpdVisits,
			String nurobFeed,
			String nurobRubellaTiter,
			String nurobHbsag,
			String nurobVdrl,
			String nurobHiv,
			String nurobInduPe2,
			String nurobInduPit,
			String nurobIolReason,
			String nurobPosition,
			String nurobAnesthesia,
			String nurobDeliDate,
			String nurobModeReason,
			String nurobEpiRepair,
			String nurobPlacenta,
			String nurobLaboDura,
			String nurobApgarFrom,
			String nurobApgarTo,
			String nurobSex,
			String nurobWeight,
			String nurobPostNatal,
			String nurobNurAssistName,
			String nurobNurCircName
	) {
		// get next schedule ID
		String deliRmId = getNextDeliRmID();

		// try to insert a new record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertDeliRm,
				new String[] {
						ConstantsServerSide.SITE_CODE, deliRmId,
						nurobMoPatname,
						nurobMoPatno, nurobMoPatfname,
						nurobMoPatgname, nurobMoPatcname,
						nurobPhysStaffId, nurobPhysName,
						nurobAge, nurobGrav,
						nurobPara, nurobEdc,
						nurobAbnMatHis, nurobAnc,
						nurobOpdVisits, nurobFeed,
						nurobRubellaTiter, nurobHbsag,
						nurobVdrl, nurobHiv,
						nurobInduPe2, nurobInduPit,
						nurobIolReason, nurobPosition,
						nurobAnesthesia, nurobDeliDate,
						nurobModeReason, nurobEpiRepair,
						nurobPlacenta, nurobLaboDura,
						nurobApgarFrom, nurobApgarTo,
						nurobSex, nurobWeight,
						nurobPostNatal, nurobNurAssistName,
						nurobNurCircName,
						userBean.getLoginID(), userBean.getLoginID()
				})) {
			return deliRmId;
		} else {
			return null;
		}
	}

	public static boolean update(
			UserBean userBean,
			String nurobDeliRmId,
			String nurobMoPatno,
			String nurobMoPatname,
			String nurobMoPatfname,
			String nurobMoPatgname,
			String nurobMoPatcname,
			String nurobPhysStaffId,
			String nurobPhysName,
			String nurobAge,
			String nurobGrav,
			String nurobPara,
			String nurobEdc,
			String nurobAbnMatHis,
			String nurobAnc,
			String nurobOpdVisits,
			String nurobFeed,
			String nurobRubellaTiter,
			String nurobHbsag,
			String nurobVdrl,
			String nurobHiv,
			String nurobInduPe2,
			String nurobInduPit,
			String nurobIolReason,
			String nurobPosition,
			String nurobAnesthesia,
			String nurobDeliDate,
			String nurobModeReason,
			String nurobEpiRepair,
			String nurobPlacenta,
			String nurobLaboDura,
			String nurobApgarFrom,
			String nurobApgarTo,
			String nurobSex,
			String nurobWeight,
			String nurobPostNatal,
			String nurobNurAssistName,
			String nurobNurCircName
	) {
		// try to update selected record
		if(UtilDBWeb.updateQueue(
				sqlStr_updateDeliRm,
				new String[] {
						nurobMoPatname,
						nurobMoPatno,
						//nurobMoPatfname,
						//nurobMoPatgname,
						nurobMoPatcname,
						//nurobPhysStaffId,
						nurobPhysName,
						nurobAge,
						nurobGrav,
						nurobPara,
						nurobEdc,
						nurobAbnMatHis,
						nurobAnc,
						nurobOpdVisits,
						nurobFeed,
						nurobRubellaTiter,
						nurobHbsag,
						nurobVdrl,
						nurobHiv,
						nurobInduPe2,
						nurobInduPit,
						nurobIolReason,
						nurobPosition,
						nurobAnesthesia,
						nurobDeliDate,
						nurobModeReason,
						nurobEpiRepair,
						nurobPlacenta,
						nurobLaboDura,
						nurobApgarFrom,
						nurobApgarTo,
						nurobSex,
						nurobWeight,
						nurobPostNatal,
						nurobNurAssistName,
						nurobNurCircName,
						userBean.getLoginID(),
						ConstantsServerSide.SITE_CODE, nurobDeliRmId,
				})) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean delete(UserBean userBean, String nurobDeliRmId) {
		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteDeliRm,
				new String[] { userBean.getLoginID(), ConstantsServerSide.SITE_CODE, nurobDeliRmId });
	}

	public static ArrayList getList(
			String nurobMoPatno, String name, String nurobPhysName, String nurobDeliDateFrom, String nurobDeliDateTo){
		return getList(nurobMoPatno, name, nurobPhysName, nurobDeliDateFrom, nurobDeliDateTo, 0);
	}
	public static ArrayList getList(
			String nurobMoPatno, String name, String nurobPhysName, String nurobDeliDateFrom, String nurobDeliDateTo, int noOfMaxRecord){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append(	"select NUROB_SITE_CODE, NUROB_DELI_RM_ID," +
						" NUROB_MO_PATNO, NUROB_MO_PATNAME," +
						" NUROB_MO_PATFNAME, NUROB_MO_PATGNAME," +
						" NUROB_MO_PATCNAME, NUROB_PHYS_NAME," +
						" NUROB_AGE " +
						" from NUROB_DELI_RM");
		sqlStr.append(" where NUROB_ENABLED = 1");
		StringBuffer whereStr = new StringBuffer();
		List<String> whereParams = new ArrayList<String>();
		if(!StringUtils.isBlank(nurobMoPatno)){
			whereStr.append(" and UPPER(NUROB_MO_PATNO) like '%" + StringEscapeUtils.escapeSql(nurobMoPatno.trim().toUpperCase()) + "%'");
		}
		if(!StringUtils.isBlank(name)){
			whereStr.append(" and UPPER(NUROB_MO_PATNAME) like '%" + StringEscapeUtils.escapeSql(name.trim().toUpperCase()) + "%'" +
							" or UPPER(NUROB_MO_PATFNAME) like '%" + StringEscapeUtils.escapeSql(name.trim().toUpperCase()) + "%'" +
							" or UPPER(NUROB_MO_PATGNAME) like '%" + StringEscapeUtils.escapeSql(name.trim().toUpperCase()) + "%'" +
							" or UPPER(NUROB_MO_PATCNAME) like '%" + StringEscapeUtils.escapeSql(name.trim().toUpperCase()) + "%'");
		}
		if(!StringUtils.isBlank(nurobPhysName)){
			whereStr.append(" and UPPER(NUROB_PHYS_NAME) like '%" + StringEscapeUtils.escapeSql(nurobPhysName.trim().toUpperCase()) + "%'");
		}
		if(!StringUtils.isBlank(nurobDeliDateFrom)){
			whereStr.append(" and TO_CHAR(NUROB_DELI_DATE, 'dd/MM/yyyy') >= ?");
			whereParams.add(StringEscapeUtils.escapeSql(nurobDeliDateFrom.trim()));
		}
		if(!StringUtils.isBlank(nurobDeliDateTo)){
			whereStr.append(" and TO_CHAR(NUROB_DELI_DATE, 'dd/MM/yyyy') <= ?");
			whereParams.add(StringEscapeUtils.escapeSql(nurobDeliDateTo.trim()));
		}
		sqlStr.append(whereStr);
		sqlStr.append(" order by NUROB_MO_PATNO desc");
		
		String[] whereParamsArray = whereParams.toArray(new String[]{});
		if (noOfMaxRecord > 0) {
			return UtilDBWeb.getReportableList(sqlStr.toString(), whereParamsArray, noOfMaxRecord);
		} else {
			return UtilDBWeb.getReportableList(sqlStr.toString(), whereParamsArray);
		}
	}

	public static ArrayList get(String nurobDeliRmId) {
		return UtilDBWeb.getReportableList(sqlStr_getDeliRm, new String[] { ConstantsServerSide.SITE_CODE, nurobDeliRmId });
	}

	static {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("INSERT INTO NUROB_DELI_RM ");
		sqlStr.append("(NUROB_SITE_CODE, NUROB_DELI_RM_ID,");
		sqlStr.append(" NUROB_MO_PATNAME, ");
		sqlStr.append(" NUROB_MO_PATNO, NUROB_MO_PATFNAME,");
		sqlStr.append(" NUROB_MO_PATGNAME, NUROB_MO_PATCNAME,");
		sqlStr.append(" NUROB_PHYS_STAFF_ID, NUROB_PHYS_NAME,");
		sqlStr.append(" NUROB_AGE, NUROB_GRAV, ");
		sqlStr.append(" NUROB_PARA, NUROB_EDC, ");
		sqlStr.append(" NUROB_ABN_MAT_HIS, NUROB_ANC, ");
		sqlStr.append(" NUROB_OPD_VISITS, NUROB_FEED, ");
		sqlStr.append(" NUROB_RUBELLA_TITER, NUROB_HBSAG, ");
		sqlStr.append(" NUROB_VDRL, NUROB_HIV, ");
		sqlStr.append(" NUROB_INDU_PE2, NUROB_INDU_PIT, ");
		sqlStr.append(" NUROB_IOL_REASON, NUROB_POSITION, ");
		sqlStr.append(" NUROB_ANESTHESIA, NUROB_DELI_DATE, ");
		sqlStr.append(" NUROB_MODE_REASON, NUROB_EPI_REPAIR, ");
		sqlStr.append(" NUROB_PLACENTA, NUROB_LABO_DURA, ");
		sqlStr.append(" NUROB_APGAR_FROM, NUROB_APGAR_TO, ");
		sqlStr.append(" NUROB_SEX, NUROB_WEIGHT, ");
		sqlStr.append(" NUROB_POST_NATAL, NUROB_NUR_ASSIST_NAME, ");
		sqlStr.append(" NUROB_NUR_CIRC_NAME, ");
		sqlStr.append(" NUROB_CREATED_USER, NUROB_MODIFIED_USER) ");
		
		sqlStr.append("VALUES");
		sqlStr.append(" (?, ?, ");
		sqlStr.append(" ?, ");
		sqlStr.append(" ?, ?, ");
		sqlStr.append(" ?, ?, ");
		sqlStr.append(" ?, ?, ");
		sqlStr.append(" ?, ?, ");
		sqlStr.append(" ?, TO_DATE(?, 'dd/MM/yyyy'), ");
		sqlStr.append(" ?, ?, ");
		sqlStr.append(" ?, ?, ");
		sqlStr.append(" ?, ?, ");
		sqlStr.append(" ?, ?, ");
		sqlStr.append(" ?, ?, ");
		sqlStr.append(" ?, ?, ");
		sqlStr.append(" ?, TO_DATE(?, 'dd/MM/yyyy HH24:MI'), ");
		sqlStr.append(" ?, ?, ");
		sqlStr.append(" ?, ?, ");
		sqlStr.append(" ?, ?, ");
		sqlStr.append(" ?, ?, ");
		sqlStr.append(" ?, ?, ");
		sqlStr.append(" ?, ");
		sqlStr.append(" ?, ?) ");
		sqlStr_insertDeliRm = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE NUROB_DELI_RM ");
		sqlStr.append("SET ");
		//sqlStr.append(" NUROB_SITE_CODE = ?, NUROB_DELI_RM_ID,");
		sqlStr.append(" NUROB_MO_PATNAME = ?, NUROB_MO_PATNO = ?,");
		//sqlStr.append(" NUROB_MO_PATFNAME, NUROB_MO_PATGNAME = ?,");
		//sqlStr.append(" NUROB_PHYS_STAFF_ID = ?,");
		sqlStr.append(" NUROB_MO_PATCNAME = ?, NUROB_PHYS_NAME = ?,");
		sqlStr.append(" NUROB_AGE = TO_NUMBER(?), NUROB_GRAV = ?, ");
		sqlStr.append(" NUROB_PARA = ?, NUROB_EDC = TO_DATE(?, 'dd/MM/yyyy'), ");
		sqlStr.append(" NUROB_ABN_MAT_HIS = ?, NUROB_ANC = ?, ");
		sqlStr.append(" NUROB_OPD_VISITS = ?, NUROB_FEED = ?, ");
		sqlStr.append(" NUROB_RUBELLA_TITER = ?, NUROB_HBSAG = ?, ");
		sqlStr.append(" NUROB_VDRL = ?, NUROB_HIV = ?, ");
		sqlStr.append(" NUROB_INDU_PE2 = ?, NUROB_INDU_PIT = ?, ");
		sqlStr.append(" NUROB_IOL_REASON = ?, NUROB_POSITION = ?, ");
		sqlStr.append(" NUROB_ANESTHESIA = ?, NUROB_DELI_DATE = TO_DATE(?, 'dd/MM/yyyy HH24:MI'), ");
		sqlStr.append(" NUROB_MODE_REASON = ?, NUROB_EPI_REPAIR = ?, ");
		sqlStr.append(" NUROB_PLACENTA = ?, NUROB_LABO_DURA = TO_NUMBER(?), ");
		sqlStr.append(" NUROB_APGAR_FROM = TO_NUMBER(?), NUROB_APGAR_TO = TO_NUMBER(?), ");
		sqlStr.append(" NUROB_SEX = ?, NUROB_WEIGHT = TO_NUMBER(?), ");
		sqlStr.append(" NUROB_POST_NATAL = ?, NUROB_NUR_ASSIST_NAME = ?, ");
		sqlStr.append(" NUROB_NUR_CIRC_NAME = ?, ");
		sqlStr.append(" NUROB_MODIFIED_DATE = SYSDATE, NUROB_MODIFIED_USER = ? ");		
		sqlStr.append("WHERE");
		sqlStr.append(" NUROB_SITE_CODE = ?");
		sqlStr.append(" AND NUROB_DELI_RM_ID = TO_NUMBER(?)");
		sqlStr.append(" AND NUROB_ENABLED = 1");
		sqlStr_updateDeliRm = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE NUROB_DELI_RM ");
		sqlStr.append("SET    NUROB_ENABLED = 0, NUROB_MODIFIED_DATE = SYSDATE, NUROB_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  NUROB_SITE_CODE = ? ");
		sqlStr.append("AND    NUROB_DELI_RM_ID = ? ");
		sqlStr.append("AND    NUROB_ENABLED = 1 ");
		sqlStr_deleteDeliRm = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append(	"SELECT " +
						"NUROB_SITE_CODE, " +
						"NUROB_DELI_RM_ID, " +
						"NUROB_MO_PATNO, " +
						"NUROB_MO_PATNAME, " +
						"NUROB_MO_PATFNAME, " +
						"NUROB_MO_PATGNAME, " +
						"NUROB_MO_PATCNAME, " +
						"NUROB_PHYS_STAFF_ID, " +
						"NUROB_PHYS_NAME, " +
						"NUROB_AGE, " +
						"NUROB_GRAV, " +
						"NUROB_PARA, " +
						"TO_CHAR(NUROB_EDC, 'dd/MM/yyyy'), " +
						"NUROB_ABN_MAT_HIS, " +
						"NUROB_ANC, " +
						"NUROB_OPD_VISITS, " +
						"NUROB_FEED, " +
						"NUROB_RUBELLA_TITER, " +
						"NUROB_HBSAG, " +
						"NUROB_VDRL, " +
						"NUROB_HIV, " +
						"NUROB_INDU_PE2, " +
						"NUROB_INDU_PIT, " +
						"NUROB_IOL_REASON, " +
						"NUROB_POSITION, " +
						"NUROB_ANESTHESIA, " +
						"TO_CHAR(NUROB_DELI_DATE, 'dd/MM/yyyy HH24:MI'), " +
						"NUROB_MODE_REASON, " +
						"NUROB_EPI_REPAIR, " +
						"NUROB_PLACENTA, " +
						"NUROB_LABO_DURA, " +
						"NUROB_APGAR_FROM, " +
						"NUROB_APGAR_TO, " +
						"NUROB_SEX, " +
						"NUROB_WEIGHT, " +
						"NUROB_POST_NATAL, " +
						"NUROB_NUR_ASSIST_NAME, " +
						"NUROB_NUR_CIRC_NAME, " +
						"NUROB_CREATED_DATE, " +
						"NUROB_CREATED_USER, " +
						"NUROB_MODIFIED_DATE, " +
						"NUROB_MODIFIED_USER, " +
						"NUROB_ENABLED ");
		sqlStr.append("FROM   NUROB_DELI_RM ");
		sqlStr.append("WHERE  NUROB_ENABLED = 1 ");
		sqlStr.append("AND    NUROB_SITE_CODE = ? ");
		sqlStr.append("AND    NUROB_DELI_RM_ID = ? ");
		sqlStr_getDeliRm = sqlStr.toString();

	}
}