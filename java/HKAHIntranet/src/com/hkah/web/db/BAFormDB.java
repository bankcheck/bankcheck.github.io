package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class BAFormDB {
//	private static String sqlStr_insertDocMap = null;
//	private static String sqlStr_insertCtsLog = null;
//	private static String serverSiteCode = ConstantsServerSide.SITE_CODE;
	private static String sqlStr_insertHAForm = null;
	private static String sqlStr_updateHAForm = null;
	private static String sqlStr_fetchAccessForm = null;
//	private static String sqlStr_fetchAccessForm2_rpt = null;

	static {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("INSERT INTO BA_FORM ( ");
		sqlStr.append("SITE_CODE, BA_ID, REGID, DOCCODE,  PAT_NO, ");
		sqlStr.append("PAT_AGE, FORM_TYPE, SLPNO, SEQ_NO, ENABLED, ");
		sqlStr.append("COMPLETED, ");
		sqlStr.append("CREATE_USER, CREATE_DATE, MODIFY_USER, MODIFY_DATE, ");
		// Personal Background Section
		sqlStr.append("BA_Q1_0, BA_Q1_1, " );
		// Personal Information Section
		sqlStr.append("BA_Q1_2, BA_Q1_3, BA_Q1_4, " );
		sqlStr.append("BA_Q1_5, BA_Q1_6, BA_Q1_7, BA_Q1_8, BA_Q1_9, " );
		sqlStr.append("BA_Q1_10, BA_Q1_11, BA_Q1_12, BA_Q1_13, BA_Q1_14, BA_Q1_15, ");
		// Breast symptoms
		sqlStr.append("BA_Q1_16, BA_Q1_17, BA_Q1_18, BA_Q1_19, ");
		sqlStr.append("BA_Q1_20, BA_Q1_21, BA_Q1_22, BA_Q1_23, ");
		sqlStr.append("BA_Q1_24, BA_Q1_25, BA_Q1_26, BA_Q1_27, ");
		sqlStr.append("BA_Q1_28, BA_Q1_29, BA_Q1_30, BA_Q1_31, ");
		sqlStr.append("BA_Q1_32, BA_Q1_33, BA_Q1_34, BA_Q1_35, ");
		sqlStr.append("BA_Q1_36, BA_Q1_37, BA_Q1_38, BA_Q1_39, ");
		// Past Medical History
		sqlStr.append("BA_Q1_40, BA_Q1_41, BA_Q1_42, BA_Q1_43, ");
		sqlStr.append("BA_Q1_44, BA_Q1_45, BA_Q1_46, BA_Q1_47, BA_Q1_48, ");
		sqlStr.append("BA_Q1_49, BA_Q1_50, BA_Q1_51, BA_Q1_52, BA_Q1_53, ");
		sqlStr.append("BA_Q1_54, BA_Q1_55, BA_Q1_56, BA_Q1_57, BA_Q1_58 ");
		sqlStr.append(") ");
		sqlStr.append("VALUES ( ");
		// Personal Background Section
		sqlStr.append("?, ?, ");
		// Personal Information Section
		sqlStr.append("?, ?, ?, ");
		sqlStr.append("?, ?, ?, ?, ?, ");
		sqlStr.append("?, ");
		sqlStr.append("?, to_date(?, 'dd/mm/yyyy hh24miss'), ?, sysdate, ");
		sqlStr.append("?, ?, ?, ?, ?, ");
		sqlStr.append("?, ?, ?, ?, ?, ");
		sqlStr.append("?, ?, ?, ?, ?, ?, ");
		// Breast symptoms
		sqlStr.append("?, ?, ?, ?, ");
		sqlStr.append("?, ?, ?, ?, ");
		sqlStr.append("?, ?, ?, ?, ");
		sqlStr.append("?, ?, ?, ?, ");
		sqlStr.append("?, ?, ?, ?, ");
		sqlStr.append("?, ?, ?, ?, ");
		// Past Medical History
		sqlStr.append("?, ?, to_date(?, 'dd/mm/yyyy hh24miss'), ?, ");
		sqlStr.append("?, ?, ?, ?, ?, ");
		sqlStr.append("?, ?, ?, ?, ?, ");
		sqlStr.append("?, ?, ?, ?, ? ");
		sqlStr.append(") ");
		sqlStr_insertHAForm = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE BA_FORM ");
		sqlStr.append("SET ");
		sqlStr.append("FORM_TYPE = ?, ");
		sqlStr.append("CREATE_DATE = to_date(?, 'dd/mm/yyyy hh24miss'), ");
		sqlStr.append("MODIFY_USER = ?, MODIFY_DATE = sysdate, ");
		// Personal Background Section
		sqlStr.append("BA_Q1_0 = ?, BA_Q1_1 = ?, " );
		// Personal Information Section
		sqlStr.append("BA_Q1_2 = ?, BA_Q1_3 = ?, BA_Q1_4 = ?, " );
		sqlStr.append("BA_Q1_5 = ?, BA_Q1_6 = ?, BA_Q1_7 = ?, BA_Q1_8 = ?, BA_Q1_9 = ?, " );
		sqlStr.append("BA_Q1_10 = ?, BA_Q1_11 = ?, BA_Q1_12 = ?, BA_Q1_13 = ?, BA_Q1_14 = ?, BA_Q1_15 = ?, ");
		// Breast symptoms
		sqlStr.append("BA_Q1_16 = ?, BA_Q1_17 = ?, BA_Q1_18 = ?, BA_Q1_19 = ?, ");
		sqlStr.append("BA_Q1_20 = ?, BA_Q1_21 = ?, BA_Q1_22 = ?, BA_Q1_23 = ?, ");
		sqlStr.append("BA_Q1_24 = ?, BA_Q1_25 = ?, BA_Q1_26 = ?, BA_Q1_27 = ?, ");
		sqlStr.append("BA_Q1_28 = ?, BA_Q1_29 = ?, BA_Q1_30 = ?, BA_Q1_31 = ?, ");
		sqlStr.append("BA_Q1_32 = ?, BA_Q1_33 = ?, BA_Q1_34 = ?, BA_Q1_35 = ?, ");
		sqlStr.append("BA_Q1_36 = ?, BA_Q1_37 = ?, BA_Q1_38 = ?, BA_Q1_39 = ?, ");
		// Past Medical History
		sqlStr.append("BA_Q1_40 = ?, BA_Q1_41 = ?, BA_Q1_42 = to_date(?, 'dd/mm/yyyy hh24miss'), BA_Q1_43 = ?, ");
		sqlStr.append("BA_Q1_44 = ?, BA_Q1_45 = ?, BA_Q1_46 = ?, BA_Q1_47 = ?, BA_Q1_48 = ?, ");
		sqlStr.append("BA_Q1_49 = ?, BA_Q1_50 = ?, BA_Q1_51 = ?, BA_Q1_52 = ?, BA_Q1_53 = ?, ");
		sqlStr.append("BA_Q1_54 = ?, BA_Q1_55 = ?, BA_Q1_56 = ?, BA_Q1_57 = ?, BA_Q1_58 = ? ");
		sqlStr.append("WHERE BA_ID = ? ");
		sqlStr_updateHAForm = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT BA.SITE_CODE, BA.BA_ID, BA.REGID, BA.DOCCODE, d.DOCFNAME || ' ' || d.DOCGNAME docname, "); //0-4
		sqlStr.append("d.doccname, BA.PAT_NO, BA.PAT_AGE, BA.FORM_TYPE, BA.SLPNO, "); //5-9
		sqlStr.append("BA.SEQ_NO, BA.ENABLED, COMPLETED, BA.CREATE_USER, to_char(CREATE_DATE, 'dd/mm/yyyy'), "); //10-14
		sqlStr.append("to_char(CREATE_DATE, 'hh24:mi:ss'), BA.MODIFY_USER, to_char(MODIFY_DATE, 'dd/mm/yyyy'), to_char(MODIFY_DATE, 'hh24:mi:ss'), "); //15-18
		// Personal Background Section
		sqlStr.append("BA_Q1_0, BA_Q1_1, "); //19-20
		// Personal Information Section
		sqlStr.append("BA_Q1_2, BA_Q1_3, BA_Q1_4, BA_Q1_5, BA_Q1_6, "); //21-25
		sqlStr.append("BA_Q1_7, BA_Q1_8, BA_Q1_9, BA_Q1_10, BA_Q1_11, "); //26-30
		sqlStr.append("BA_Q1_12, BA_Q1_13, BA_Q1_14, BA_Q1_15, "); //31-34
		// Breast symptoms
		sqlStr.append("BA_Q1_16, BA_Q1_17, BA_Q1_18, BA_Q1_19, "); //35-38
		sqlStr.append("BA_Q1_20, BA_Q1_21, BA_Q1_22, BA_Q1_23, "); //39-42
		sqlStr.append("BA_Q1_24, BA_Q1_25, BA_Q1_26, BA_Q1_27, "); //43-46
		sqlStr.append("BA_Q1_28, BA_Q1_29, BA_Q1_30, BA_Q1_31, "); //47-50
		sqlStr.append("BA_Q1_32, BA_Q1_33, BA_Q1_34, BA_Q1_35, "); //51-54
		sqlStr.append("BA_Q1_36, BA_Q1_37, BA_Q1_38, BA_Q1_39, "); //55-58
		// Past Medical History
		sqlStr.append("BA_Q1_40, BA_Q1_41, to_char(BA_Q1_42, 'dd/mm/yyyy'), BA_Q1_43, "); // 59-62
		sqlStr.append("BA_Q1_44, BA_Q1_45, BA_Q1_46, BA_Q1_47, BA_Q1_48, "); //63-67
		sqlStr.append("BA_Q1_49, BA_Q1_50, BA_Q1_51, BA_Q1_52, BA_Q1_53, ");//68-72
		sqlStr.append("BA_Q1_54, BA_Q1_55, BA_Q1_56, BA_Q1_57, BA_Q1_58, ");//73-77
		// patient information
		sqlStr.append("P.PATFNAME || ' ' || P.PATGNAME PATNAME, P.PATCNAME, P.PATSEX, TO_CHAR(P.PATBDATE, 'DD/MM/YYYY') PATBDATE "); //78-81
		sqlStr.append("FROM BA_FORM BA,PATIENT@IWEB P,DOCTOR@IWEB D,CO_STAFFS ST, OPD_NX_NOTE@CIS NN ");
		sqlStr.append(" WHERE BA.PAT_NO = P.PATNO AND BA.DOCCODE = D.DOCCODE(+)AND BA.MODIFY_USER = ST.CO_STAFF_ID(+)");
		sqlStr.append(" AND BA.PAT_NO = NN.PATNO(+) AND BA.REGID = NN.REGID(+)");
		sqlStr.append(" AND BA.ENABLED = 1 AND BA.BA_ID = ? ");
		sqlStr_fetchAccessForm = sqlStr.toString();
	}

	public static String saveHAForm(UserBean userBean, String regID, String docCode, String patNo, String patAge, String formType,
			   String staffID, String createDate, String createHH, String createMM,
			   String[] qa_b)
	{
		String baID = null;

		// check patno regid
		// if new patno regid access form
		if (isNewAccessform(patNo, regID, formType)) {
			baID = getNextHAFormID();
			if (UtilDBWeb.updateQueue(sqlStr_insertHAForm,
								new String[] {ConstantsServerSide.SITE_CODE, baID, regID, docCode, patNo,
											  patAge, formType, "", "1", "1",
											  "0",
											  staffID, createDate + " " + createHH + createMM + "00", staffID,
											  // Personal Background Section
											  qa_b[0], qa_b[1], qa_b[2],
											  // Personal Information Section
											  qa_b[3], qa_b[4], qa_b[5], qa_b[6], qa_b[7],
											  qa_b[8], qa_b[9], qa_b[10], qa_b[11], qa_b[12], qa_b[13], qa_b[14], qa_b[15],
											  // Breast symptoms
											  qa_b[16], qa_b[17], qa_b[18], qa_b[19],
											  qa_b[20], qa_b[21], qa_b[22], qa_b[23],
											  qa_b[24], qa_b[25], qa_b[26], qa_b[27],
											  qa_b[28], qa_b[29], qa_b[30], qa_b[31],
											  qa_b[32], qa_b[33], qa_b[34], qa_b[35],
											  qa_b[36], qa_b[37], qa_b[38], qa_b[39],
											  // Past Medical History
											  qa_b[40], qa_b[41], qa_b[42], qa_b[43], qa_b[44], qa_b[45],
											  qa_b[46], qa_b[47], qa_b[48],
											  qa_b[49], qa_b[50], qa_b[51], qa_b[52], qa_b[53],
											  qa_b[54], qa_b[55], qa_b[56], qa_b[57], qa_b[58]
									})) {
				updateHAPatAge(baID, patNo);
				return baID;
			} else {
				return null;
			}
		} else {
			baID = getBAFormID(patNo, regID, formType);
			if (UtilDBWeb.updateQueue(sqlStr_updateHAForm,
					new String[] {formType, createDate + " " + createHH + createMM + "00", staffID,
								  // Personal Background Section
								  qa_b[0], qa_b[1],
								  // Personal Information Section
								  qa_b[2], qa_b[3], qa_b[4], qa_b[5], qa_b[6], qa_b[7],
								  qa_b[8], qa_b[9], qa_b[10], qa_b[11], qa_b[12], qa_b[13], qa_b[14], qa_b[15],
								  // Breast symptoms
								  qa_b[16], qa_b[17], qa_b[18], qa_b[19],
								  qa_b[20], qa_b[21], qa_b[22], qa_b[23],
								  qa_b[24], qa_b[25], qa_b[26], qa_b[27],
								  qa_b[28], qa_b[29], qa_b[30], qa_b[31],
								  qa_b[32], qa_b[33], qa_b[34], qa_b[35],
								  qa_b[36], qa_b[37], qa_b[38], qa_b[39],
								  // Past Medical History
								  qa_b[40], qa_b[41], qa_b[42], qa_b[43], qa_b[44], qa_b[45],
								  qa_b[46], qa_b[47], qa_b[48],
								  qa_b[49], qa_b[50], qa_b[51], qa_b[52], qa_b[53],
								  qa_b[54], qa_b[55], qa_b[56], qa_b[57], qa_b[58],
								  baID})) {
				updateHAPatAge(baID, patNo);
				return baID;
			} else {
				return null;
			}
		}
	}

	public static Boolean NeedAddRegBAForm(String patNo, String regID, String formType, String regDate) {
		String sql = null;
		String baID = null;

		if ("NORMAL".equals(formType)) {
			sql = "select ha_id from HA_FORM where ha_enabled = 1 and ha_pat_no = '" + patNo + "' and ha_regid = '" + regID + "' and ha_form_type <> 'CCR'";
		} else {
			sql = "select ha_id from HA_FORM where ha_enabled = 1 and ha_pat_no = '" + patNo + "' and ha_regid = '" + regID + "' and ha_form_type = '" + formType + "'";
		}
		sql += " and CREATE_DATE >= to_date('" + regDate + " 000000' , 'dd/mm/yyyy hh24miss') and CREATE_DATE <= to_date('" + regDate + " 235959' , 'dd/mm/yyyy hh24miss')";
		ArrayList result = UtilDBWeb.getReportableList(sql);
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			baID = reportableListObject.getValue(0);
			// set 1 for initial
			if (baID == null || baID.length() == 0) {
				return true;
			} else {
				return false;
			}
		}
		return true;
	}

	public static Boolean isNewBAForm(String patNo, String regID, String formType) {
		String sql = null;
		String baID = null;

		if (formType == null) {
			sql = "select ba_id from BA_FORM where enabled = 1 and pat_no = '" + patNo + "' and regid = '" + regID + "' and form_type <> 'CCR'";
		} else {
			sql = "select ba_id from BA_FORM where enabled = 1 and pat_no = '" + patNo + "' and regid = '" + regID + "' and form_type = '" + formType + "'";
		}
		ArrayList result = UtilDBWeb.getReportableList(sql);
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			baID = reportableListObject.getValue(0);
			// set 1 for initial
			if (baID == null || baID.length() == 0) {
				return true;
			} else {
				return false;
			}
		}
		return true;
	}

	public static String getBAFormID(String patNo, String regID, String formType) {
		String baID = null;
		String sql = null;

		if (formType == null) {
			sql = "select ba_id from BA_FORM where enabled = 1 and pat_no = '" + patNo + "' and regid = '" + regID + "' and form_type <> 'CCR' order by ba_id desc";
		} else {
			sql = "select ba_id from BA_FORM where enabled = 1 and pat_no = '" + patNo + "' and regid = '" + regID + "' and form_type = '" + formType + "' order by ba_id desc";
		}
		ArrayList result = UtilDBWeb.getReportableList(sql);
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			baID = reportableListObject.getValue(0);

			// set 1 for initial
			if (baID == null || baID.length() == 0) return "1";
		}
		return baID;
	}

	public static String getBALastestFormID(String patNo, String formType) {
		String baID = null;
		String sql = null;

		if (formType == null) {
			sql = "select ba_id from BA_FORM where enabled = 1 and pat_no = '" + patNo + "' and form_type <> 'CCR' order by ba_id desc";
		} else {
			sql = "select ba_id from BA_FORM where enabled = 1 and pat_no = '" + patNo + "' and form_type like '%BAFORM%' order by ba_id desc";
		}
		ArrayList result = UtilDBWeb.getReportableList(sql);
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			baID = reportableListObject.getValue(0);

			// set 1 for initial
			if (baID == null || baID.length() == 0) return "1";
		}
		return baID;
	}

	public static String getLatesrRegID(String patNo) {
		String regID = null;

		ArrayList result = UtilDBWeb.getReportableList("select REGID from ba_form where enabled = 1 and ba_id = (select max(BA_ID) from ba_form where pat_no = '" + patNo + "')");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			regID = reportableListObject.getValue(0);

			if (regID == null || regID.length() == 0) return "-1";
		}
		return regID;
	}

	private static Boolean isNewAccessform(String patNo, String regID, String formType) {
		String countAcessForm = null;
		String sql = null;

		if (formType == null) {
			sql = "select count(1) from BA_FORM where enabled = 1 and pat_no = '" + patNo + "'  and regid = '" + regID + "' and form_type <> 'CCR'";
		} else {
			sql = "select count(1) from BA_FORM where enabled = 1 and pat_no = '" + patNo + "'  and regid = '" + regID + "' and form_type = '" + formType + "'";
		}

		ArrayList result = UtilDBWeb.getReportableList(sql);
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			countAcessForm = reportableListObject.getValue(0);

			if ("0".equals(countAcessForm)) return true;
		}
		return false;
	}

	private static String getNextHAFormID() {
		String baID = null;

		ArrayList result = UtilDBWeb.getReportableList("SELECT MAX(BA_ID) + 1 FROM BA_FORM");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			baID = reportableListObject.getValue(0);

			// set 1 for initial
			if (baID == null || baID.length() == 0) return "1";
		}
		return baID;
	}

	//21-12-2016
	public static String getRegDocName(String regID) {
		String docName = null;

		ArrayList result = UtilDBWeb.getReportableList("select docfname || ' ' || docgname from doctor@iweb where doccode = (select doccode from reg@iweb where regid = '" + regID + "')");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			docName = reportableListObject.getValue(0);
		}
		return docName;
	}

	//21-12-2016
	public static String getRegDocCode(String regID) {
		String docCode = null;

		ArrayList result = UtilDBWeb.getReportableList("select doccode from reg@iweb where regid = '" + regID + "'");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			docCode = reportableListObject.getValue(0);
		}
		return docCode;
	}

	public static boolean completeHAForm(String baID, String completed) {
		StringBuffer sqlStr = new StringBuffer();
		String status = null;

		sqlStr.setLength(0);
		sqlStr.append("update ba_form set completed = ? where ba_id = ?");

		if ("1".equals(completed)) {
			status = "0";
		} else {
			status = "1";
		}

		UtilDBWeb.updateQueue(sqlStr.toString(), new String[]{status, baID});

		return true;
	}

	public static boolean updateHAPatAge(String baID, String patNo) {
		StringBuffer sqlStr = new StringBuffer();
		String sql = null;
		String patAge = null;
		ArrayList result = null;
		ReportableListObject reportableListObject = null;

		result = PatientDB.getPatInfo(patNo);
		if (result.size() > 0) {
			reportableListObject = (ReportableListObject) result.get(0);
			patAge = reportableListObject.getValue(5);
		}
		sqlStr.append("update ba_form set pat_age = ? where ba_id = ?");

		UtilDBWeb.updateQueue(sqlStr.toString(), new String[]{patAge, baID});

		return true;
	}

	// get the nurse note data
	public static ArrayList getNurseNote(String patNo, String regID, String seqNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select nn.TMP, substr(nn.BP, 1, INSTR(nn.bp,'/')-1), substr(nn.BP, INSTR(nn.bp,'/') + 1, 3), nn.PULSE, nn.SAO2, nn.WT, nn.HT, nn.RR, nn.HC, r.doccode  ");
		sqlStr.append("from reg@iweb r ");
		sqlStr.append("left outer join OPD_NX_NOTE@CIS nn on nn.regid = r.regid and r.patno = nn.patno and nn.seq_no = ? ");
		sqlStr.append("where r.regid = ? and r.patno = ? ");
		sqlStr.append("order by nn.seq_no desc ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{seqNo, regID, patNo});
	}

	// check if login id is medical record staff
	public static Boolean isMRStaff(String staffID) {
		StringBuffer sqlStr = new StringBuffer();
		StringBuffer sqlStrSentinel = new StringBuffer();
		StringBuffer sqlStrRpt = new StringBuffer();
		String piDeptCode = null;

		if (ConstantsServerSide.isHKAH()) {
			piDeptCode = "760";
		} else if (ConstantsServerSide.isTWAH()) {
			piDeptCode = "MR";
		}
		sqlStr.append("select 1 from co_staffs where co_department_code = '" + piDeptCode + "' and co_staff_id = ? ");
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{staffID});
		if (record.size() > 0) {
			return true;
		} else if ("admin".equals(staffID)) {
			return true;
		}
		return false;
	}
	//

	// get the saved access form
	public static ArrayList fetchAccessForm(String baID) {
		return UtilDBWeb.getReportableList(sqlStr_fetchAccessForm, new String[]{baID});
	}
/*
	// get the saved access form
	public static ArrayList fetchDRPL() {
		return UtilDBWeb.getReportableList("select pl_key, pl_desc from ha_form_dr_pl order by pl_key", new String[]{});
	}
*/
	public static ArrayList getRegReportList(String drCode, String patNo, String patName, String patIDNo, String patTel, String completed, String form_date_from, String form_date_to) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("select to_char(r.regdate, 'dd/mm/yyyy'), r.patno, r.regid, p.patgname || ' ' || p.patfname patname, p.patcname, p.patidno, to_char(p.patbdate, 'dd/mm/yyyy'), p.patsex, p.patadd1 || ' ' || p.patadd2 || ' ' || p.patadd3 addr, p.pathtel, d.doccode, d.docfname || ' ' || d.docgname docname ");
		sqlStr.append("from reg@iweb r ");
		sqlStr.append("join patient@iweb p on p.patno = r.patno ");
		sqlStr.append("join doctor@iweb d on d.doccode = r.doccode ");
		sqlStr.append("where 1=1 ");

		if (form_date_from != null && form_date_from.length() > 0) {
			sqlStr.append(" and r.regdate >= to_date('" + form_date_from + " 000000' , 'dd/mm/yyyy hh24miss') ");
			//sql += "AND P.PIR_INCIDENT_DATE >= TO_DATE('"+incident_date_from+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ";
		}

		if (form_date_from != null && form_date_from.length() > 0) {
			sqlStr.append(" and r.regdate<= to_date('" + form_date_to + " 235959' , 'dd/mm/yyyy hh24miss') ");
		}

		if (patNo != null && patNo.length() > 0) {
			sqlStr.append(" AND r.patno like '%"+patNo+"%' ");
		}

		if (patName != null && patName.length() > 0) {
			sqlStr.append(" AND upper(p.patgname || ' ' || p.patfname) like upper('%"+patName+"%') ");
		}

		if (patIDNo != null && patIDNo.length() > 0) {
			sqlStr.append("AND upper(p.patidno) like upper('%"+patIDNo+"%') ");
		}

		if (patTel != null && patTel.length() > 0) {
			sqlStr.append("AND p.pathtel like '%"+patTel+"%' ");
		}

		// if dr mode, filter his own patient
		if (drCode != null && drCode.length() > 0) {
			sqlStr.append("and r.doccode = '" + drCode + "' ");
		}
		//
		sqlStr.append("order by r.regdate desc ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getHAReportList(String drCode, String patNo, String patName, String patIDNo, String patTel, String completed, String form_date_from, String form_date_to) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("select to_char(ha.create_date, 'dd/mm/yyyy'), ha.ha_id, ha.create_user, to_char(ha.modify_date, 'dd/mm/yyyy'), ha.modify_user, patno, patgname || ' ' || patfname patname, ");
		sqlStr.append("patcname, patidno, to_char(patbdate, 'dd/mm/yyyy'), patsex, patadd1 || ' ' || patadd2 || ' ' || patadd3 addr, pathtel, ha.ha_regid, ");
		sqlStr.append("ha.COMPLETED, ha.ha_doccode, d.docfname || ' ' || docgname, HA_FORM_TYPE, NN_SEQ_NO ");
		sqlStr.append("from ha_form ha join patient@iweb p on ha.ha_pat_no = p.patno ");
		sqlStr.append("join doctor@iweb d on ha.ha_doccode = d.doccode ");
		sqlStr.append("where 1=1 and ha_enabled = 1 ");

		if (form_date_from != null && form_date_from.length() > 0) {
			sqlStr.append(" and ha.create_date >= to_date('" + form_date_from + " 000000' , 'dd/mm/yyyy hh24miss') ");
		}

		if (form_date_from != null && form_date_from.length() > 0) {
			sqlStr.append(" and ha.create_date <= to_date('" + form_date_to + " 235959' , 'dd/mm/yyyy hh24miss') ");
		}

		if (patNo != null && patNo.length() > 0) {
			sqlStr.append(" AND patno like '%"+patNo+"%' ");
		}

		if (patName != null && patName.length() > 0) {
			sqlStr.append(" AND upper(patgname || ' ' || patfname) like upper('%"+patName+"%') ");
		}

		if (patIDNo != null && patIDNo.length() > 0) {
			sqlStr.append("AND upper(patidno) like upper('%"+patIDNo+"%') ");
		}

		if (patTel != null && patTel.length() > 0) {
			sqlStr.append("AND pathtel like '%"+patTel+"%' ");
		}

		if (completed != null && completed.length() > 0) {
			sqlStr.append("AND completed like '%"+completed+"%' ");
		}

		// if dr mode, filter his own patient
		if (drCode != null && drCode.length() > 0) {
			sqlStr.append("AND ha.ha_pat_no in (select patno from reg@iweb where doccode = '" + drCode + "') ");
		}
		//

		sqlStr.append("order by ha.create_date desc ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getHAReportList_newway(String drCode, String patNo, String patName, String patIDNo, String patTel, String completed, String form_date_from, String form_date_to) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("select to_char(regdate, 'dd/mm/yyyy'), null ha_id, null create_user, null modify_date, null modify_user, r.patno, ");
		sqlStr.append("patgname || ' ' || patfname patname, patcname, patidno, to_char(patbdate, 'dd/mm/yyyy'), patsex,   				");
		sqlStr.append("patadd1 || ' ' || patadd2 || ' ' || patadd3 addr, pathtel, regid,  				null completed, ");
		sqlStr.append("doccode, docfname || ' ' || docgname docname, null ha_form_type, null nn_seq_no 			       ");
		sqlStr.append("from reg@iweb r ");
		sqlStr.append("join patient@iweb p on p.patno = r.patno ");
		sqlStr.append("join doctor@iweb d on d.doccode = r.doccode  ");
		sqlStr.append("where exists");
		sqlStr.append("			(select 1 from sliptx@iweb x where r.slpno=x.slpno and stnsts='N' ");
		sqlStr.append("				and pkgcode in ('P001','P002','P003','P004','P005','P006','PSM30','PSF30','P003A','P004A','P005A','P006A') ");
		sqlStr.append(" 		) ");

		if (form_date_from != null && form_date_from.length() > 0) {
			sqlStr.append(" and regdate >= to_date('" + form_date_from + " 000000' , 'dd/mm/yyyy hh24miss') ");
		}

		if (form_date_from != null && form_date_from.length() > 0) {
			sqlStr.append(" and regdate <= to_date('" + form_date_to + " 235959' , 'dd/mm/yyyy hh24miss') ");
		}

		if (patNo != null && patNo.length() > 0) {
			sqlStr.append(" AND patno like '%"+patNo+"%' ");
		}

		if (patName != null && patName.length() > 0) {
			sqlStr.append(" AND upper(patgname || ' ' || patfname) like upper('%"+patName+"%') ");
		}

		if (patIDNo != null && patIDNo.length() > 0) {
			sqlStr.append("AND upper(patidno) like upper('%"+patIDNo+"%') ");
		}

		if (patTel != null && patTel.length() > 0) {
			sqlStr.append("AND pathtel like '%"+patTel+"%' ");
		}

		if (completed != null && completed.length() > 0) {
			sqlStr.append("AND completed like '%"+completed+"%' ");
		}

		// if dr mode, filter his own patient
		if (drCode != null && drCode.length() > 0) {
			sqlStr.append("AND ha.ha_pat_no in (select patno from reg@iweb where doccode = '" + drCode + "') ");
		}
		//

		sqlStr.append("order by regdate desc ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getHAReportList_complex(String drCode, String patNo, String patName, String patIDNo, String patTel, String completed, String form_date_from, String form_date_to) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append(" select to_char(create_date, 'dd/mm/yyyy'), ha_id, create_user, ");
		sqlStr.append(" 		to_char(modify_date, 'dd/mm/yyyy'), modify_user, patno, patname, patcname, patidno, to_char(patbdate, 'dd/mm/yyyy'), ");
		sqlStr.append("			patsex, addr, pathtel, ha_regid, COMPLETED, doccode, docname , HA_FORM_TYPE, NN_SEQ_NO, hasForm  ");
		sqlStr.append(" from ( ");
		sqlStr.append("      select 'hasForm' hasform, ha.create_date, ha.ha_id, ha.create_user, ");
		sqlStr.append(" 	   	ha.modify_date, ha.modify_user, patno,  ");
		sqlStr.append(" 		patgname || ' ' || patfname patname, patcname, patidno,  ");
		sqlStr.append(" 		patbdate, patsex, ");
		sqlStr.append(" 		patadd1 || ' ' || patadd2 || ' ' || patadd3 addr, pathtel, ha.ha_regid,  ");
		sqlStr.append(" 		ha.COMPLETED, ha.ha_doccode doccode, d.docfname || ' ' || docgname docname, HA_FORM_TYPE, NN_SEQ_NO  ");
		sqlStr.append("			from ha_form ha  ");
		sqlStr.append("			join patient@iweb p on ha.ha_pat_no = p.patno ");
		sqlStr.append("			join doctor@iweb d on ha.ha_doccode = d.doccode ");
		sqlStr.append("			where ha_enabled = 1 ");
		sqlStr.append("					and ha.create_date >= to_date('" + form_date_from + " 000000', 'dd/mm/yyyy hh24miss') ");
		sqlStr.append(" 				and ha.create_date <= to_date('" + form_date_to + " 235959', 'dd/mm/yyyy hh24miss') ");
		sqlStr.append("			union all ");
		sqlStr.append("			select 'noForm', null create_date, null ha_id, null create_user, ");
		sqlStr.append(" 	 			null modify_date, null modify_user, h.patno, ");
		sqlStr.append(" 				p.patgname || ' ' || p.patfname patname, p.patcname, p.patidno,  ");
		sqlStr.append(" 				p.patbdate, p.patsex,  ");
		sqlStr.append(" 				p.patadd1 || ' ' || p.patadd2 || ' ' || p.patadd3 addr, p.pathtel, h.regid, ");
		sqlStr.append(" 				null completed, h.doccode, d.docfname || ' ' || docgname docname, null ha_form_type, null nn_seq_no ");
		sqlStr.append("			from (");
		sqlStr.append(" 			select r.regdate, r.regid, r.patno, r.doccode ");
		sqlStr.append("				from reg@iweb r ");
		sqlStr.append(" 			where ");
		sqlStr.append(" 				regdate >= to_date('" + form_date_from + " 000000', 'dd/mm/yyyy hh24miss') ");
		sqlStr.append(" 				and regdate <= to_date('" + form_date_to + " 235959', 'dd/mm/yyyy hh24miss') ");
		sqlStr.append(" 				and exists (select 1 from sliptx@iweb x where r.slpno=x.slpno and stnsts='N'");
		sqlStr.append(" 						and pkgcode in ('P001','P002','P003','P004','P005','P006','PSM30','PSF30','P003A','P004A','P005A','P006A') ");
		sqlStr.append(" 							)");
		sqlStr.append(" 			) h ");
		sqlStr.append("			join patient@iweb p on h.patno = p.patno ");
		sqlStr.append("			join doctor@iweb d on h.doccode = d.doccode ");
		sqlStr.append("			where not exists (");
		sqlStr.append("					select 1 from ha_form ha where 1=1 and ha_enabled = 1 and ha.ha_pat_no = h.patno and ha.ha_regid = h.regid ");
		sqlStr.append(" 				) ");
		sqlStr.append(" 	) ");
		sqlStr.append("where 1=1 ");

		if (form_date_from != null && form_date_from.length() > 0) {
			sqlStr.append(" and create_date >= to_date('" + form_date_from + " 000000' , 'dd/mm/yyyy hh24miss') ");
		}

		if (form_date_from != null && form_date_from.length() > 0) {
			sqlStr.append(" and create_date <= to_date('" + form_date_to + " 235959' , 'dd/mm/yyyy hh24miss') ");
		}

		if (patNo != null && patNo.length() > 0) {
			sqlStr.append(" AND patno like '%"+patNo+"%' ");
		}

		if (patName != null && patName.length() > 0) {
			sqlStr.append(" AND upper(patgname || ' ' || patfname) like upper('%"+patName+"%') ");
		}

		if (patIDNo != null && patIDNo.length() > 0) {
			sqlStr.append("AND upper(patidno) like upper('%"+patIDNo+"%') ");
		}

		if (patTel != null && patTel.length() > 0) {
			sqlStr.append("AND pathtel like '%"+patTel+"%' ");
		}

		if (completed != null && completed.length() > 0) {
			sqlStr.append("AND completed like '%"+completed+"%' ");
		}

		// if dr mode, filter his own patient
		if (drCode != null && drCode.length() > 0) {
			sqlStr.append("AND ha_pat_no in (select patno from reg@iweb where doccode = '" + drCode + "') ");
		}
		//

		sqlStr.append(" order by create_date desc ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getHAReportReport(String baID) {
		return UtilDBWeb.getReportableList(sqlStr_fetchAccessForm, new String[]{baID});
	}
}