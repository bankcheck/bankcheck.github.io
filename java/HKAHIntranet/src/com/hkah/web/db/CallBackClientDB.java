package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class CallBackClientDB {
	/**
	 * Add a client
	 */
	public static boolean add(UserBean userBean,String patno,String seq_no,
							String recipient,String rmks_for_pbo,String rmks_for_nurse,
							String flw_up_date, String flw_up_status, String cb_success,
							String confirm_appt_date) {
		// try to insert a new record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO FLW_UP_HIST (");
		sqlStr.append("PATNO,SEQ_NO,RECIPIENT ");
		sqlStr.append(",RMKS_FOR_PBO,RMKS_FOR_NURSE ");
		if (flw_up_date != null && flw_up_date.length() > 0) {
			sqlStr.append(",FLW_UP_DATE ");
		}
		sqlStr.append(",CB_SUCCESS,FLW_UP_STATUS ");
		if (confirm_appt_date != null && confirm_appt_date.length() > 0) {
			sqlStr.append(",CONFIRM_APPT_DATE ");
		}
		sqlStr.append(",UPDATE_USER,UPDATE_DATE) ");
		sqlStr.append("VALUES (?,?,?,?,?");
		if (flw_up_date != null && flw_up_date.length() > 0) {
			sqlStr.append(", TO_DATE('");
			sqlStr.append(flw_up_date);
			sqlStr.append("','DD/MM/YYYY'), '");
		} else {
			sqlStr.append(",'");
		}
		sqlStr.append(cb_success);
		sqlStr.append("','");
		sqlStr.append(flw_up_status);
		if (confirm_appt_date != null && confirm_appt_date.length() > 0) {
			sqlStr.append("', TO_DATE('");
			sqlStr.append(confirm_appt_date);
			sqlStr.append("','DD/MM/YYYY'),'");
		} else {
			sqlStr.append("','");
		}
		sqlStr.append(userBean.getLoginID());
		sqlStr.append("',SYSDATE) ");
		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {patno, seq_no, recipient, rmks_for_pbo, rmks_for_nurse});
	}

	/**
	 * Modify a client
	 * @return whether it is successful to update the record
	 */
	public static boolean update(UserBean userBean,String patno,String seq_no,
									String recipient,String rmks_for_pbo,String rmks_for_nurse,
									String flw_up_date,String flw_up_status, String cb_success,
									String confirm_appt_date,String update_user,String update_date) {
		// try to update selected record
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE FLW_UP_HIST SET ");
		if (recipient != null && recipient.length() > 0) {
			sqlStr.append(" RECIPIENT = '");
			sqlStr.append(recipient);
			sqlStr.append("', ");
		}
		if (rmks_for_pbo != null && rmks_for_pbo.length() > 0) {
			sqlStr.append(" RMKS_FOR_PBO = '");
			sqlStr.append(rmks_for_pbo);
			sqlStr.append("', ");
		}
		if (rmks_for_nurse != null && rmks_for_nurse.length() > 0) {
			sqlStr.append(" RMKS_FOR_NURSE = '");
			sqlStr.append(rmks_for_nurse);
			sqlStr.append("', ");
		}
		if (flw_up_date != null && flw_up_date.length() > 0) {
			sqlStr.append(" FLW_UP_DATE = TO_DATE('");
			sqlStr.append(flw_up_date);
			sqlStr.append("','DD/MM/YYYY'), ");
		}
		if (cb_success != null && cb_success.length() > 0) {
			sqlStr.append(" CB_SUCCESS = ");
			sqlStr.append(cb_success);
			sqlStr.append(", ");
		}
		if (flw_up_status != null && flw_up_status.length() > 0) {
			sqlStr.append(" FLW_UP_STATUS = ");
			sqlStr.append(flw_up_status);
			sqlStr.append(", ");
		}
		if (confirm_appt_date != null && confirm_appt_date.length() > 0) {
			sqlStr.append(" CONFIRM_APPT_DATE = TO_DATE('");
			sqlStr.append(confirm_appt_date);
			sqlStr.append("','DD/MM/YYYY'), ");
		}
		if (update_user != null && update_user.length() > 0) {
			sqlStr.append(" UPDATE_USER = '");
			sqlStr.append(update_user);
			sqlStr.append("', ");
		}
		sqlStr.append("UPDATE_DATE = SYSDATE ");
		sqlStr.append(" WHERE PATNO = ?");
		sqlStr.append(" AND SEQ_NO = ?");
		sqlStr.append(" AND UPDATE_DATE = TO_DATE(?,'YYYYMMDDHH24MISS')");

		return UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] { patno,seq_no,update_date} );
	}

	public static ArrayList getPatDtl(String as_patNo,String as_seqNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("FUA.PATNO,FUA.SEQ_NO,");
		sqlStr.append("TO_CHAR(FUA.APPT_DATE,'DD/MM/YYYY') AS APPT_DATE,FUA.RMKS,FUA.APPT_STS,");
		sqlStr.append("P.PATFNAME||', '||P.PATGNAME AS PATNAME,");
		sqlStr.append("D.DOCFNAME||', '||D.DOCGNAME AS DOCNAME,");
		sqlStr.append("D.DOCCODE,");
		sqlStr.append("P.PATCNAME,P.TITDESC,P.PATSEX,");
		sqlStr.append("P.PATHTEL,P.PATOTEL,P.PATPAGER,");
		sqlStr.append("TO_CHAR(FUA.UPDATE_DATE,'DD/MM/YYYY') AS UPDATE_DATE,");
		sqlStr.append("DECODE(SIGN(TO_CHAR(PATBDATE,'MM')-TO_CHAR(SYSDATE,'MM')),-1,TO_CHAR(SYSDATE,'YYYY')-TO_CHAR(PATBDATE,'YYYY')-1,1,TO_CHAR(SYSDATE,'YYYY')-TO_CHAR(PATBDATE,'YYYY'),0,TO_CHAR(SYSDATE,'YYYY')-TO_CHAR(PATBDATE,'YYYY'))||'yr '||");
		sqlStr.append("DECODE(SIGN(TO_CHAR(PATBDATE,'MM')-TO_CHAR(SYSDATE,'MM')),-1,(12+TO_NUMBER(TO_CHAR(PATBDATE,'MM'))-TO_NUMBER(TO_CHAR(SYSDATE,'MM'))),1,TO_NUMBER(TO_CHAR(PATBDATE,'MM'))-TO_NUMBER(TO_CHAR(SYSDATE,'MM')),0,TO_NUMBER(TO_CHAR(PATBDATE,'MM'))-TO_NUMBER(TO_CHAR(SYSDATE,'MM')))||'mths' AS AGE, ");
		sqlStr.append("FUA.UPDATE_USER, FUA.APPT_TYPE ");		
		sqlStr.append("FROM ");
		sqlStr.append("FLW_UP_APPT FUA,PATIENT@HAT P,DOCTOR@HAT D ");
		sqlStr.append("WHERE FUA.PATNO = P.PATNO(+) ");
		sqlStr.append("AND FUA.DOCCODE = D.DOCCODE(+) ");
		sqlStr.append("AND FUA.PATNO = '");
		sqlStr.append(as_patNo);
		sqlStr.append("' AND FUA.SEQ_NO = '");
		sqlStr.append(as_seqNo);
		sqlStr.append("'");

		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}

	public static ArrayList histList(String as_patNo,String as_seqNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("FUH.PATNO,FUH.SEQ_NO,FUH.RECIPIENT,");
		sqlStr.append("FUH.RMKS_FOR_PBO,FUH.RMKS_FOR_NURSE,");
		sqlStr.append("TO_CHAR(FUH.FLW_UP_DATE,'YYYY/MM/DD'),FUH.CB_SUCCESS,");
		sqlStr.append("FUH.FLW_UP_STATUS,TO_CHAR(FUH.CONFIRM_APPT_DATE,'YYYY/MM/DD'),");
		sqlStr.append("FUH.UPDATE_USER,TO_CHAR(FUH.UPDATE_DATE,'YYYYMMDDHH24MISS'), ");
		sqlStr.append("FUH.CB_SUCCESS,FUH.FLW_UP_STATUS, ");
		sqlStr.append("TO_CHAR(FUH.UPDATE_DATE,'YYYY/MM/DD HH24MI'),rownum ");
		sqlStr.append("FROM FLW_UP_HIST FUH  ");
		sqlStr.append("WHERE FUH.PATNO = '");
		sqlStr.append(as_patNo);
		sqlStr.append("' AND FUH.SEQ_NO = '");
		sqlStr.append(as_seqNo);
		sqlStr.append("' ORDER BY FUH.UPDATE_DATE DESC");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getList(String as_patNo,String as_docNo,String as_patName,String as_apptDateFrom,String as_apptDateTo,String as_flwDateFrom,String as_flwDateTo,String as_hisStatus) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("fua.patno,fua.seq_no,TO_CHAR(fua.appt_date,'YYYY/MM/DD') AS appt_date,fua.rmks,DECODE(fua.appt_sts,'A','Active','X','Cancel'),");
		sqlStr.append("p.patfname||', '||p.patgname AS patname,");
		sqlStr.append("d.docfname||', '||d.docgname AS docname,");
		sqlStr.append("fuh.flw_up_status,TO_CHAR(fuh.flw_up_date,'YYYY/MM/DD') AS flw_up_date,fuh.rmks_for_pbo,");
		sqlStr.append("fuh.rmks_for_nurse,fuh.update_date, ");
		sqlStr.append("p.patcname,p.pathtel,p.patotel,p.patpager,p.titdesc,d.doccode ");
		sqlStr.append("FROM ");
		sqlStr.append("flw_up_appt fua,patient@hat p,doctor@hat d, ");
		sqlStr.append("(SELECT * FROM flw_up_hist@wwwserver f1 ");
		sqlStr.append("WHERE f1.update_date = ");
		sqlStr.append("(SELECT MAX(f2.update_date) ");
		sqlStr.append("FROM flw_up_hist@wwwserver f2 ");
		sqlStr.append("WHERE f1.patno = f2.patno ");
		sqlStr.append("AND f1.seq_no = f2.seq_no ");
		sqlStr.append("AND f2.FLW_UP_TYPE IS NULL ");
		sqlStr.append("GROUP BY f2.patno,f2.seq_no) AND f1.FLW_UP_TYPE IS NULL) fuh ");
		sqlStr.append("WHERE fua.patno = p.patno(+) ");
		sqlStr.append("AND fua.doccode = d.doccode(+) ");
		sqlStr.append("AND fua.patno = fuh.patno(+) ");
		sqlStr.append("AND fua.seq_no = fuh.seq_no(+) ");
		sqlStr.append("AND fua.appt_sts = 'A' ");
		if (as_apptDateFrom != null && as_apptDateFrom.length() > 0) {
			sqlStr.append("AND fua.appt_date >= TO_DATE('");
			sqlStr.append(as_apptDateFrom);
			sqlStr.append("','DD-MM-YYYY') ");
		}
		if (as_apptDateTo != null && as_apptDateTo.length() > 0) {
			sqlStr.append("AND fua.appt_date <= TO_DATE('");
			sqlStr.append(as_apptDateTo);
			sqlStr.append("','DD-MM-YYYY') ");
		}
		if (as_flwDateFrom != null && as_flwDateFrom.length() > 0) {
			sqlStr.append("AND fuh.flw_up_date >= TO_DATE('");
			sqlStr.append(as_flwDateFrom);
			sqlStr.append("','DD-MM-YYYY') ");
		}
		if (as_flwDateTo != null && as_flwDateTo.length() > 0) {
			sqlStr.append("AND fuh.flw_up_date <= TO_DATE('");
			sqlStr.append(as_flwDateTo);
			sqlStr.append("','DD-MM-YYYY') ");
		}
		if (as_docNo != null && as_docNo.length() > 0) {
			sqlStr.append("AND d.doccode = '");
			sqlStr.append(as_docNo);
			sqlStr.append("' ");
		}
		if (as_patNo != null && as_patNo.length() > 0) {
			sqlStr.append("AND fua.patno = '");
			sqlStr.append(as_patNo);
			sqlStr.append("' ");
		}
		if (as_patName != null && as_patName.length() > 0) {
			sqlStr.append("AND UPPER(TRIM(p.patfname))||' '||UPPER(TRIM(p.patgname)) LIKE UPPER('%");
			sqlStr.append(as_patName);
			sqlStr.append("%') ");
		}
		if (as_hisStatus != null && as_hisStatus.length() > 0) {
			sqlStr.append("AND fuh.flw_up_status = '");
			sqlStr.append(as_hisStatus);
			sqlStr.append("' ");
		} else {
			sqlStr.append("AND fuh.flw_up_status IS NULL ");
		}
		sqlStr.append("UNION ");
		sqlStr.append("SELECT ");
		sqlStr.append("fua.patno,fua.seq_no,TO_CHAR(fua.appt_date,'YYYY/MM/DD') AS appt_date,fua.rmks,DECODE(fua.appt_sts,'A','Active','X','Cancel'),");
		sqlStr.append("p.patfname||', '||p.patgname AS patname,");
		sqlStr.append("d.docfname||', '||d.docgname AS docname,");
		sqlStr.append("fuh.flw_up_status,TO_CHAR(fuh.flw_up_date,'YYYY/MM/DD') AS flw_up_date,fuh.rmks_for_pbo,");
		sqlStr.append("fuh.rmks_for_nurse,fuh.update_date, ");
		sqlStr.append("p.patcname,p.pathtel,p.patotel,p.patpager,p.titdesc,d.doccode ");
		sqlStr.append("FROM ");
		sqlStr.append("flw_up_appt fua,patient@hat p,doctor@hat d, ");
		sqlStr.append("(SELECT * FROM flw_up_hist@wwwserver f1 ");
		sqlStr.append("WHERE f1.update_date = ");
		sqlStr.append("(SELECT MAX(f2.update_date) ");
		sqlStr.append("FROM flw_up_hist@wwwserver f2 ");
		sqlStr.append("WHERE f1.patno = f2.patno ");
		sqlStr.append("AND f2.FLW_UP_TYPE IS NULL ");
		sqlStr.append("GROUP BY f2.patno,f2.seq_no) AND f1.FLW_UP_TYPE IS NULL) fuh ");
		sqlStr.append("WHERE fua.patno = p.patno(+) ");
		sqlStr.append("AND fua.doccode = d.doccode(+) ");
		sqlStr.append("AND fua.patno = fuh.patno(+) ");
		sqlStr.append("AND fua.seq_no = fuh.seq_no(+) ");
		sqlStr.append("AND fua.appt_sts = 'X' ");
		sqlStr.append("AND fuh.update_date IS NOT NULL ");
		if (as_apptDateFrom != null && as_apptDateFrom.length() > 0) {
			sqlStr.append("AND fua.appt_date >= TO_DATE('");
			sqlStr.append(as_apptDateFrom);
			sqlStr.append("','DD-MM-YYYY') ");
		}
		if (as_apptDateTo != null && as_apptDateTo.length() > 0) {
			sqlStr.append("AND fua.appt_date <= TO_DATE('");
			sqlStr.append(as_apptDateTo);
			sqlStr.append("','DD-MM-YYYY') ");
		}
		if (as_flwDateFrom != null && as_flwDateFrom.length() > 0) {
			sqlStr.append("AND fuh.flw_up_date >= TO_DATE('");
			sqlStr.append(as_flwDateFrom);
			sqlStr.append("','DD-MM-YYYY') ");
		}
		if (as_flwDateTo != null && as_flwDateTo.length() > 0) {
			sqlStr.append("AND fuh.flw_up_date <= TO_DATE('");
			sqlStr.append(as_flwDateTo);
			sqlStr.append("','DD-MM-YYYY') ");
		}
		if (as_docNo != null && as_docNo.length() > 0) {
			sqlStr.append("AND d.doccode = '");
			sqlStr.append(as_docNo);
			sqlStr.append("' ");
		}
		if (as_patNo != null && as_patNo.length() > 0) {
			sqlStr.append("AND fua.patno = '");
			sqlStr.append(as_patNo);
			sqlStr.append("' ");
		}
		if (as_patName != null && as_patName.length() > 0) {
			sqlStr.append("AND UPPER(TRIM(p.patfname))||' '||UPPER(TRIM(p.patgname)) LIKE UPPER('%");
			sqlStr.append(as_patName);
			sqlStr.append("%') ");
		}
		if (as_hisStatus != null && as_hisStatus.length() > 0) {
				sqlStr.append("AND fuh.flw_up_status = '");
				sqlStr.append(as_hisStatus);
				sqlStr.append("' ");
		} else {
			sqlStr.append("AND fuh.flw_up_status IS NULL ");
		}
		if (as_hisStatus != null && as_hisStatus.length() > 0) {
			sqlStr.append("ORDER BY appt_date DESC, patno DESC");
		} else {
			sqlStr.append("ORDER BY appt_date ASC, patno ASC");
		}
		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}

	public static String getMaxCBSuccess(String patNo,String seqNo) {
		String cbSuccess = null;
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("cb_success ");
		sqlStr.append("FROM flw_up_hist ");
		sqlStr.append("WHERE patno = '");
		sqlStr.append(patNo);
		sqlStr.append("' AND seq_no = '");
		sqlStr.append(seqNo);
		sqlStr.append("' AND update_date = (");
		sqlStr.append("SELECT " );
		sqlStr.append("MAX(update_date) ");
		sqlStr.append("FROM flw_up_hist ");
		sqlStr.append("WHERE patno = '");
		sqlStr.append(patNo);
		sqlStr.append("' AND seq_no = '");
		sqlStr.append(seqNo);
		sqlStr.append("')");

		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			cbSuccess = reportableListObject.getValue(0);
			// set 1 for initial
			if (cbSuccess == null || cbSuccess.length() == 0) return null;
		}
		return cbSuccess;
	}

	public static ArrayList statList(String fromDate,String toDate) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("(SELECT d.docgname||', '||d.docfname FROM doctor@hat d WHERE d.doccode=fua.doccode) AS doc_name,");
		sqlStr.append("COUNT(CASE WHEN fuh.cb_success = 1 AND fuh.rank = 1 THEN fua.doccode||fua.patno||fua.seq_no END) succ,");
		sqlStr.append("COUNT(CASE WHEN fuh.cb_success = 2 AND fuh.rank = 1 THEN fua.doccode||fua.patno||fua.seq_no END) not_succ,");
		sqlStr.append("COUNT(CASE WHEN fuh.cb_success = 3 AND fuh.rank = 1 THEN fua.doccode||fua.patno||fua.seq_no END) prev_book,");
		sqlStr.append("COUNT(CASE WHEN fuh.cb_success IS NULL AND (fuh.rank = 1 OR fuh.rank IS NULL) THEN fua.doccode||fua.patno||fua.seq_no END) in_prog,");
		sqlStr.append("(COUNT(CASE WHEN fuh.cb_success = 1 AND fuh.rank = 1 THEN fua.doccode||fua.patno||fua.seq_no END)+");
		sqlStr.append("COUNT(CASE WHEN fuh.cb_success = 2 AND fuh.rank = 1 THEN fua.doccode||fua.patno||fua.seq_no END)+");
		sqlStr.append("COUNT(CASE WHEN fuh.cb_success = 3 AND fuh.rank = 1 THEN fua.doccode||fua.patno||fua.seq_no END)+");
		sqlStr.append("COUNT(CASE WHEN fuh.cb_success IS NULL AND (fuh.rank = 1 OR fuh.rank IS NULL) THEN fua.doccode||fua.patno||fua.seq_no END)) total_case ");
		sqlStr.append("FROM flw_up_appt fua,(");
		sqlStr.append("SELECT f.*,");
		sqlStr.append("RANK() OVER (PARTITION BY patno, seq_no ");
		sqlStr.append("ORDER BY update_date DESC) rank ");
		sqlStr.append("FROM flw_up_hist@wwwserver f WHERE f.FLW_UP_TYPE IS NULL) fuh ");
		sqlStr.append("WHERE fua.patno = fuh.patno(+) ");
		sqlStr.append("AND fua.seq_no = fuh.seq_no(+) ");
		sqlStr.append("AND fua.appt_sts <> 'X' ");
		if (fromDate != null && fromDate.length() > 0) {
			sqlStr.append("AND fua.appt_date >= TO_DATE('");
			sqlStr.append(fromDate);
			sqlStr.append("','DD/MM/YYYY') ");
		}
		if (toDate != null && toDate.length() > 0) {
			sqlStr.append("AND fua.appt_date <= TO_DATE('");
			sqlStr.append(toDate);
			sqlStr.append("','DD/MM/YYYY') ");
		}
		sqlStr.append("GROUP BY fua.doccode");

		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}

	/**
	 * Add reject date
	 */
	// ---------------------------------------------------------------------
}