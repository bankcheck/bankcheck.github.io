package com.hkah.web.db;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;

import com.hkah.config.MessageResources;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.util.sms.UtilSMS;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class InPatientPreBookDB {
	public static boolean delete(UserBean userBean, String preBookID, String updateDate) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("DELETE FROM FLW_UP_HIST ");
		sqlStr.append("WHERE PBPID = '"+preBookID+"' ");
		sqlStr.append("AND UPDATE_DATE = TO_DATE('"+updateDate+"','DD/MM/YYYY HH24:MI:SS')");

		//System.out.println("--------------InPatientPreBook (delete)--------------");
		//System.out.println(sqlStr.toString());
		//System.out.println("-----------------------------------------------------------------------");

		return UtilDBWeb.updateQueue(sqlStr.toString());
	}

	public static boolean update(UserBean userBean,String patno,String preBookID,
									String bkStatus,String pboRmk,String patRmk,
									String clRmk, String ckRmk, String preferClass,
									String payMth, String insuranceRmk,
									String flwUpDate, String flwUpSts, String updateUser,
									String updateDate , String otherRmk , String otPso) {
		StringBuffer sqlStr = new StringBuffer();
		boolean success = true;

		if (patno != null && patno.length() > 0) {
			if (patRmk != null) {
				if (!updatePatientRmk(patno, patRmk)) {
					success = false;
				}
			}
		}
		if (pboRmk != null && clRmk != null) {
			if (!updateOtherRmk(patno, preBookID, pboRmk, clRmk, ckRmk)) {
				success = false;
			}
		}

		sqlStr.append("UPDATE FLW_UP_HIST SET ");
		if (flwUpDate != null && flwUpDate.length() > 0) {
			sqlStr.append("FLW_UP_DATE = TO_DATE('");
			sqlStr.append(flwUpDate);
			sqlStr.append("','DD/MM/YYYY'), ");
		}
		if (flwUpSts != null && flwUpSts.length() > 0) {
			sqlStr.append("FLW_UP_STATUS = '");
			sqlStr.append(flwUpSts);
			sqlStr.append("', ");
		}
		if (payMth != null && payMth.length() > 0) {
			sqlStr.append("PREFER_PAY_MTH = '");
			sqlStr.append(payMth);
			sqlStr.append("', ");
		}
		if (bkStatus != null && bkStatus.length() > 0) {
			sqlStr.append("BKSTS = '");
			sqlStr.append(bkStatus);
			sqlStr.append("', ");
		}
		if (insuranceRmk != null && insuranceRmk.length() > 0) {
			sqlStr.append("PREFER_PAY_MTH_REMARK = '");
			sqlStr.append(insuranceRmk.replaceAll("'", "''"));
			sqlStr.append("', ");
		}
		if (otherRmk != null && otherRmk.length() > 0) {
			sqlStr.append("FLW_UP_STATUS_REMARK = '");
			sqlStr.append(otherRmk.replaceAll("'", "''"));
			sqlStr.append("', ");
		}
		if (otPso != null && otPso.length() > 0) {
			sqlStr.append("OT_PSO = 1, ");
		} else {
			sqlStr.append("OT_PSO = 0, ");
		}
		if (preferClass != null && preferClass.length() > 0) {
			sqlStr.append("ACMCODE = '");
			sqlStr.append(preferClass);
			sqlStr.append("', ");
		}
		if (updateUser != null && updateUser.length() > 0) {
			sqlStr.append("UPDATE_USER = '");
			sqlStr.append(userBean.getLoginID());
			sqlStr.append("', ");
		}
		sqlStr.append("UPDATE_DATE = SYSDATE ");
		sqlStr.append(" WHERE PBPID = '"+preBookID+"'");
		sqlStr.append(" AND UPDATE_DATE = TO_DATE('"+updateDate+"','DD/MM/YYYY HH24:MI:SS')");

		//System.out.println("--------------InPatientPreBook (update)--------------");
		//System.out.println(sqlStr.toString());
		//System.out.println("-----------------------------------------------------------------------");

		if (!UtilDBWeb.updateQueue(sqlStr.toString())) {
			success = false;
		}

		return success;
	}

	public static boolean add(UserBean userBean,String patno,String preBookID,
								String bkStatus,String pboRmk,String patRmk,
								String clRmk, String ckRmk, String preferClass,
								String payMth, String insuranceRmk,
								String flwUpDate, String flwUpSts,String otherRmk,String otPso) {
		boolean success = true;

		if (patno != null && patno.length() > 0) {
			if (patRmk != null) {
				if (!updatePatientRmk(patno, patRmk)) {
					success = false;
				}
			}
		}
		if (pboRmk != null && clRmk != null) {
			if (!updateOtherRmk(patno, preBookID, pboRmk, clRmk, ckRmk)) {
				success = false;
			}
		}

		boolean comma = false;
		// try to insert a new record
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("INSERT INTO FLW_UP_HIST (");
		if (patno != null && patno.length() > 0) {
			sqlStr.append("PATNO ");
			comma = true;
		}
		if (flwUpDate != null && flwUpDate.length() > 0) {
			if (comma) {
				sqlStr.append(",");
			} else {
				comma = true;
			}
			sqlStr.append("FLW_UP_DATE ");
		}
		if (flwUpSts != null && flwUpSts.length() > 0) {
			if (comma) {
				sqlStr.append(",");
			} else {
				comma = true;
			}
			sqlStr.append("FLW_UP_STATUS ");
		}
		if (comma) {
			sqlStr.append(",");
		} else {
			comma = true;
		}
		sqlStr.append("UPDATE_USER, UPDATE_DATE, ");
		sqlStr.append("FLW_UP_TYPE ");
		if (payMth != null && payMth.length() > 0) {
			if (comma) {
				sqlStr.append(",");
			} else {
				comma = true;
			}
			sqlStr.append("PREFER_PAY_MTH ");
		}
		if (bkStatus != null && bkStatus.length() > 0) {
			if (comma) {
				sqlStr.append(",");
			} else {
				comma = true;
			}
			sqlStr.append("BKSTS ");
		}
		if (comma) {
			sqlStr.append(",");
		} else {
			comma = true;
		}
		sqlStr.append("PBPID ");
		if (insuranceRmk != null && insuranceRmk.length() > 0) {
			if (comma) {
				sqlStr.append(",");
			} else {
				comma = true;
			}
			sqlStr.append("PREFER_PAY_MTH_REMARK ");
		}
		if (otherRmk != null && otherRmk.length() > 0) {
			if (comma) {
				sqlStr.append(",");
			} else {
				comma = true;
			}
			sqlStr.append("FLW_UP_STATUS_REMARK ");
		}
		if (otPso != null && otPso.length() > 0) {
			if (comma) {
				sqlStr.append(",");
			} else {
				comma = true;
			}
			sqlStr.append("OT_PSO ");
		}
		if (preferClass != null && preferClass.length() > 0) {
			if (comma) {
				sqlStr.append(",");
			} else {
				comma = true;
			}
			sqlStr.append("ACMCODE ");
		}
		sqlStr.append(") VALUES (");
		comma = false;
		if (patno != null && patno.length() > 0) {
			sqlStr.append("'"+patno+"' ");
			comma = true;
		}
		if (flwUpDate != null && flwUpDate.length() > 0) {
			if (comma) {
				sqlStr.append(",");
			} else {
				comma = true;
			}
			sqlStr.append("TO_DATE('");
			sqlStr.append(flwUpDate);
			sqlStr.append("','DD/MM/YYYY') ");
		}
		if (flwUpSts != null && flwUpSts.length() > 0) {
			if (comma) {
				sqlStr.append(",");
			} else {
				comma = true;
			}
			sqlStr.append("'"+flwUpSts+"' ");
		}
		if (comma) {
			sqlStr.append(",");
		} else {
			comma = true;
		}
		sqlStr.append("'"+userBean.getLoginID()+"', ");
		sqlStr.append("SYSDATE, 'INPATPB' ");
		if (payMth != null && payMth.length() > 0) {
			if (comma) {
				sqlStr.append(",");
			} else {
				comma = true;
			}
			sqlStr.append("'"+payMth+"' ");
		}
		if (bkStatus != null && bkStatus.length() > 0) {
			if (comma) {
				sqlStr.append(",");
			} else {
				comma = true;
			}
			sqlStr.append("'"+bkStatus+"' ");
		}
		if (comma) {
			sqlStr.append(",");
		} else {
			comma = true;
		}
		sqlStr.append("'"+preBookID+"' ");
		if (insuranceRmk != null && insuranceRmk.length() > 0) {
			if (comma) {
				sqlStr.append(",");
			} else {
				comma = true;
			}
			sqlStr.append("'"+insuranceRmk.replaceAll("'", "''")+"' ");
		}
		if (otherRmk != null && otherRmk.length() > 0) {
			if (comma) {
				sqlStr.append(",");
			} else {
				comma = true;
			}
			sqlStr.append("'"+otherRmk.replaceAll("'", "''")+"' ");
		}
		if (otPso != null && otPso.length() > 0) {
			if (comma) {
				sqlStr.append(",");
			} else {
				comma = true;
			}
			sqlStr.append("1 ");
		}
		if (preferClass != null && preferClass.length() > 0) {
			if (comma) {
				sqlStr.append(",");
			} else {
				comma = true;
			}
			sqlStr.append("'"+preferClass+"' ");
		}

		sqlStr.append(")");

		//System.out.println("--------------InPatientPreBook (add)--------------");
		//System.out.println(sqlStr.toString());
		//System.out.println("-----------------------------------------------------------------------");

		if (!UtilDBWeb.updateQueue(
				sqlStr.toString())) {
			success = false;
		}

		return success;
	}

	public static boolean updateOtherRmk(String patNo, String preBookID, String pboRmk, String clRmk, String ckRmk) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("UPDATE BEDPREBOK@IWEB ");
		sqlStr.append("SET BPBRMK = '"+pboRmk.replaceAll("'", "''")+"', CABLABRMK = '"+clRmk.replaceAll("'", "''")+"' ");
		sqlStr.append("WHERE ");
		sqlStr.append("PBPID = '"+preBookID+"' ");

		//System.out.println("--------------InPatientPreBook (updateOtherRmk)--------------");
		//System.out.println(sqlStr.toString());
		//System.out.println("-----------------------------------------------------------------------");

		return UtilDBWeb.updateQueue(sqlStr.toString());
	}

	public static boolean updatePatientRmk(String patNo, String patRmk) {
		StringBuffer sqlStr = new StringBuffer();

		if (patNo != null && patNo.length() > 0) {
			sqlStr.append("UPDATE PATIENT@IWEB ");
			sqlStr.append("SET PATADDRMK = '"+patRmk.replaceAll("'", "''")+"' ");
			sqlStr.append("WHERE PATNO = '"+patNo+"' ");

			//System.out.println("--------------InPatientPreBook (updatePatientRmk)--------------");
			//System.out.println(sqlStr.toString());
			//System.out.println("-----------------------------------------------------------------------");

			return UtilDBWeb.updateQueue(sqlStr.toString());
		} else {
			return true;
		}
	}

	public static ArrayList getRmk(String patNo, String preBookID, String updateTime) {
		StringBuffer sqlStr = new StringBuffer();

		if (patNo != null && patNo.length() > 0) {
			sqlStr.append("SELECT P.PATADDRMK, B.BPBRMK, B.CABLABRMK, B.OTREMARK ");
			if (updateTime != null && updateTime.length() > 0) {
				sqlStr.append(", FUH.PREFER_PAY_MTH_REMARK , FUH.FLW_UP_STATUS_REMARK ");
			}
		} else {
			sqlStr.append("SELECT '', B.BPBRMK, B.CABLABRMK, B.OTREMARK ");
			if (updateTime != null && updateTime.length() > 0) {
				sqlStr.append(", FUH.PREFER_PAY_MTH_REMARK , FUH.FLW_UP_STATUS_REMARK ");
			}
		}

		if (patNo != null && patNo.length() > 0) {
			sqlStr.append("FROM BEDPREBOK@IWEB B, PATIENT@IWEB P ");
			if (updateTime != null && updateTime.length() > 0) {
				sqlStr.append(", FLW_UP_HIST FUH ");
			}
		} else {
			sqlStr.append("FROM BEDPREBOK@IWEB B ");
			if (updateTime != null && updateTime.length() > 0) {
				sqlStr.append(", FLW_UP_HIST FUH ");
			}
		}

		if (patNo != null && patNo.length() > 0) {
			sqlStr.append("WHERE P.PATNO = '");
			sqlStr.append(patNo);
			sqlStr.append("' ");
			sqlStr.append("AND B.PBPID = '");
			sqlStr.append(preBookID);
			sqlStr.append("' ");
			sqlStr.append("AND B.PATNO = P.PATNO ");
			if (updateTime != null && updateTime.length() > 0 && !updateTime.equals("null")) {
				sqlStr.append("AND B.PBPID = FUH.PBPID ");
				sqlStr.append("AND FUH.UPDATE_DATE = TO_DATE('"+updateTime+"','DD/MM/YYYY HH24:MI:SS') ");
			}
		} else {
			sqlStr.append("WHERE B.PBPID = '");
			sqlStr.append(preBookID);
			sqlStr.append("' ");
			if (updateTime != null && updateTime.length() > 0 && !updateTime.equals("null")) {
				sqlStr.append("AND B.PBPID = FUH.PBPID ");
				sqlStr.append("AND FUH.UPDATE_DATE = TO_DATE('"+updateTime+"','DD/MM/YYYY HH24:MI:SS') ");
			}
		}

		//System.out.println("--------------InPatientPreBook (getRmk)--------------");
		//System.out.println(sqlStr.toString());
		//System.out.println("-----------------------------------------------------------------------");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getBkStatusAndPreClassAndPreMth(String patNo, String preBookID) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT ACMCODE, BKSTS, PREFER_PAY_MTH, PREFER_PAY_MTH_REMARK, TO_CHAR(UPDATE_DATE,'DD/MM/YYYY HH24:MI:SS'), OT_PSO ");
		sqlStr.append("FROM FLW_UP_HIST FUH ");
//		if (patNo != null && patNo.length() > 0) {
//			sqlStr.append("WHERE FUH.PATNO = '"+patNo+"' ");
//		} else {
//			sqlStr.append("WHERE FUH.PATPAGER = '"+phone+"' ");
//		}
		sqlStr.append("WHERE FUH.PBPID = '"+preBookID+"' ");
		sqlStr.append("AND update_date = (");
		sqlStr.append("SELECT " );
		sqlStr.append("MAX(update_date) ");
		sqlStr.append("FROM flw_up_hist ");
//		if (patNo != null && patNo.length() > 0) {
//			sqlStr.append("WHERE patno = '");
//			sqlStr.append(patNo);
//		}
//		else {
//			sqlStr.append("WHERE patpager = '");
//			sqlStr.append(phone);
//		}
		sqlStr.append("WHERE PBPID = '");
		sqlStr.append(preBookID);
		sqlStr.append("')");

		//System.out.println("--------------InPatientPreBook (getBkStatusAndPreClassAndPreMth)--------------");
		//System.out.println(sqlStr.toString());
		//System.out.println("-----------------------------------------------------------------------");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getPatDtl(String patNo, String preBookID) {
		StringBuffer sqlStr = new StringBuffer();

		//SELECT
		if (patNo != null && patNo.length() > 0) {
			sqlStr.append("SELECT P.PATNO, P.PATSEX, "); //0, 1
			sqlStr.append("DECODE(IH.PATNO, NULL, 'NO', 'YES') as curInHse, ");//2
			sqlStr.append("P.PATFNAME||', '||P.PATGNAME AS PATNAME, P.PATCNAME, ");//3, 4
			sqlStr.append("DECODE(SIGN(TO_NUMBER(TO_CHAR(SYSDATE,'MM'))-TO_NUMBER(TO_CHAR(P.PATBDATE,'MM'))), -1, ");
			sqlStr.append("(TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-TO_NUMBER(TO_CHAR(P.PATBDATE,'YYYY'))-1)||'yr '|| ");
			sqlStr.append("(12-(TO_NUMBER(TO_CHAR(P.PATBDATE,'MM'))-TO_NUMBER(TO_CHAR(SYSDATE,'MM'))))||'mths', ");
			sqlStr.append("0, (TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-TO_NUMBER(TO_CHAR(P.PATBDATE,'YYYY')))||'yr ', ");
			sqlStr.append("1, (TO_NUMBER(TO_CHAR(SYSDATE,'YYYY'))-TO_NUMBER(TO_CHAR(P.PATBDATE,'YYYY')))||'yr '|| ");
			sqlStr.append("(TO_NUMBER(TO_CHAR(SYSDATE,'MM'))-TO_NUMBER(TO_CHAR(P.PATBDATE,'MM')))||'mths') AS AGE, ");//5
			sqlStr.append("B.PATPAGER, P.PATHTEL, P.PATEMAIL, ");//6, 7, 8
			sqlStr.append("D.DOCFNAME||', '||D.DOCGNAME AS DOCNAME, ");//9
			sqlStr.append("TO_CHAR(B.BPBHDATE, 'DD/MM/YYYY HH24:MI'), TO_CHAR(B.EDITDATE, 'DD/MM/YYYY HH24:MM'), ");//10, 11
			sqlStr.append("P.PATOTEL, B.BPBSTS, M.MOTHDESC, ");//12, 13, 14
			sqlStr.append("A.ACMNAME, W.WRDNAME, B.BEDCODE, ");//15, 16, 17
			sqlStr.append("P.PATADDRMK, ");//18
			//sqlStr.append("P.PATNO, ");
			sqlStr.append("B.BPBRMK, B.CABLABRMK ");//19, 20
			sqlStr.append(",P.PATSMS, P.COUCODE ");//21, 22
			sqlStr.append(", B.ARCCODE || ' ' || R.ARCNAME, B.COPAYTYP || ' ' || B.COPAYAMT ");//23, 24
			sqlStr.append(", TO_CHAR(B.CVREDATE, 'DD/MM/YYYY'), B.ARLMTAMT, TO_CHAR(O.OTAOSDATE, 'DD/MM/YYYY HH24:MI') ");//25, 26, 27
			sqlStr.append(", B.PATKHTEL ");//28
			sqlStr.append(", TO_CHAR(B.BPBHDATE, 'DD/MM/YYYY'), P.PATIDNO, P.PATFNAME, P.PATGNAME, ");//29, 30, 31, 32
			sqlStr.append("P.RACDESC, P.RELIGIOUS, TO_CHAR(P.PATBDATE, 'DD/MM/YYYY'), P.PATMSTS, P.MOTHCODE, P.EDULEVEL, ");//33, 34, 35, 36, 37, 38
			sqlStr.append("P.PATOTEL, P.PATFAXNO, P.OCCUPATION, P.PATADD1, P.PATADD2, P.PATADD3, W.WRDCODE, D.DOCCODE, ");//39, 40, 41, 42, 43, 44, 45, 46
			sqlStr.append("B.PBPID, ");
			sqlStr.append("(SELECT P.OTPDESC ");
			sqlStr.append("FROM OT_APP@IWEB A, OT_PROC@IWEB P ");
			sqlStr.append("WHERE A.OTPID = P.OTPID AND A.PBPID = B.PBPID AND A.OTAOSDATE = O.OTAOSDATE AND ROWNUM = 1) ");//47, 48
			//sqlStr.append(",P.PATSMS ");
		} else {
			sqlStr.append("SELECT '', B.SEX, DECODE(B.BPBSTS, 'F', 'YES', 'NO'), ");//0, 1, 2
			sqlStr.append("BPBPNAME, BPBCNAME, ");//3, 4
			sqlStr.append("'', B.PATPAGER, '', '', ");//5, 6, 7, 8
			sqlStr.append("D.DOCFNAME||', '||D.DOCGNAME AS DOCNAME, ");//9
			sqlStr.append("TO_CHAR(B.BPBHDATE, 'DD/MM/YYYY HH24:MI'), TO_CHAR(B.EDITDATE, 'DD/MM/YYYY HH24:MM'), ");//10, 11
			sqlStr.append("'', B.BPBSTS, '', ");//12, 13, 14
			sqlStr.append("A.ACMNAME, W.WRDNAME, B.BEDCODE, ");//15, 16, 17
			sqlStr.append("'', ");//18
			//sqlStr.append("P.PATNO, ");
			sqlStr.append("B.BPBRMK, B.CABLABRMK ");//19, 20
			sqlStr.append(",'0', '' ");//21, 22
			sqlStr.append(", B.ARCCODE || ' ' || R.ARCNAME, B.COPAYTYP || ' ' || B.COPAYAMT ");//23, 24
			sqlStr.append(", TO_CHAR(B.CVREDATE, 'DD/MM/YYYY'), B.ARLMTAMT, TO_CHAR(O.OTAOSDATE, 'DD/MM/YYYY HH24:MI') ");//25, 26, 27
			sqlStr.append(", B.PATKHTEL ");//28
			sqlStr.append(", TO_CHAR(B.BPBHDATE, 'DD/MM/YYYY'), B.PATIDNO, '', '', '', ");//29, 30, 31, 32, 33
			sqlStr.append("'', '', '', '', '', '', '', '', '', '', '', W.WRDCODE, D.DOCCODE, ");//34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46
			sqlStr.append("B.PBPID, ");
			sqlStr.append("(SELECT P.OTPDESC ");
			sqlStr.append("FROM OT_APP@IWEB A, OT_PROC@IWEB P ");
			sqlStr.append("WHERE A.OTPID = P.OTPID AND A.PBPID = B.PBPID AND A.OTAOSDATE = O.OTAOSDATE AND ROWNUM = 1) ");//47, 48
		}

		//FROM
		if (patNo != null && patNo.length() > 0) {
			sqlStr.append("FROM BEDPREBOK@IWEB B, PATIENT@IWEB P, DOCTOR@IWEB D, ACM@IWEB A, WARD@IWEB W, MOTHERLANG@IWEB M, ARCODE@IWEB R, ");
			sqlStr.append("(SELECT R.PATNO FROM REG@IWEB R, INPAT@IWEB I ");
			sqlStr.append("WHERE R.REGTYPE = 'I' AND I.INPDDATE IS NULL ");
			sqlStr.append("AND R.INPID = I.INPID AND R.REGSTS = 'N') IH, ");
			sqlStr.append("(SELECT * ");
			sqlStr.append("FROM OT_APP@IWEB ");
			sqlStr.append("WHERE PBPID = '"+preBookID+"' ");
			sqlStr.append("AND OTASTS = 'N' ");
			sqlStr.append("AND OTAOSDATE = (SELECT MIN(OTAOSDATE) ");
			sqlStr.append("FROM OT_APP@IWEB ");
			sqlStr.append("WHERE PBPID = '"+preBookID+"' ");
			sqlStr.append("AND OTASTS = 'N' )) O ");
		} else {
			sqlStr.append("FROM BEDPREBOK@IWEB B, DOCTOR@IWEB D, ACM@IWEB A, WARD@IWEB W, ARCODE@IWEB R, ");
			sqlStr.append("(SELECT * ");
			sqlStr.append("FROM OT_APP@IWEB ");
			sqlStr.append("WHERE PBPID = '"+preBookID+"' ");
			sqlStr.append("AND OTASTS = 'N' ");
			sqlStr.append("AND OTAOSDATE = (SELECT MIN(OTAOSDATE) ");
			sqlStr.append("FROM OT_APP@IWEB ");
			sqlStr.append("WHERE PBPID = '"+preBookID+"' ");
			sqlStr.append("AND OTASTS = 'N' )) O ");
		}

		//WHERE
		if (patNo != null && patNo.length() > 0) {
			sqlStr.append("WHERE P.PATNO = '");
			sqlStr.append(patNo);
			sqlStr.append("' ");
			sqlStr.append("AND B.PBPID = '");
			sqlStr.append(preBookID);
			sqlStr.append("' ");
			sqlStr.append("AND B.PATNO = P.PATNO ");
			sqlStr.append("AND D.DOCCODE(+) = B.DOCCODE ");
			sqlStr.append("AND A.ACMCODE(+) = B.ACMCODE ");
			sqlStr.append("AND W.WRDCODE(+) = B.WRDCODE ");
			sqlStr.append("AND M.MOTHCODE(+) = P.MOTHCODE ");
			sqlStr.append("AND R.ARCCODE(+) = B.ARCCODE ");
			sqlStr.append("AND B.PATNO = IH.PATNO(+) ");
			sqlStr.append("AND O.PBPID(+) = B.PBPID ");		
		} else {
			sqlStr.append("WHERE B.PBPID = '");
			sqlStr.append(preBookID);
			sqlStr.append("' ");
			sqlStr.append("AND D.DOCCODE(+) = B.DOCCODE ");
			sqlStr.append("AND A.ACMCODE(+) = B.ACMCODE ");
			sqlStr.append("AND W.WRDCODE(+) = B.WRDCODE ");
			sqlStr.append("AND R.ARCCODE(+) = B.ARCCODE ");
			sqlStr.append("AND O.PBPID(+) = B.PBPID ");			
		}

		System.out.println("--------------InPatientPreBook (getPatDtl)--------------");
		System.out.println(sqlStr.toString());
		System.out.println("-----------------------------------------------------------------------");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList histList(String patNo, String preBookID) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT FUH.PATNO, B.BPBPNAME, TO_CHAR(FUH.FLW_UP_DATE,'DD/MM/YYYY'), ");
		sqlStr.append("S.CO_STAFFNAME || '(' || C.CO_STAFF_ID || ')', TO_CHAR(FUH.UPDATE_DATE,'DD/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("'', FUH.PREFER_PAY_MTH, ");
		sqlStr.append("FUH.BKSTS, rownum, FUH.FLW_UP_STATUS, FUH.ACMCODE, FUH.PREFER_PAY_MTH_REMARK, ");
		sqlStr.append("C.CO_USERNAME , FUH.FLW_UP_STATUS_REMARK, FUH.OT_PSO ");
		sqlStr.append("FROM FLW_UP_HIST FUH, BEDPREBOK@IWEB B, CO_USERS C, CO_STAFFS S ");
		sqlStr.append("WHERE FUH.PBPID = '"+preBookID+"' ");
		sqlStr.append("AND B.PBPID = FUH.PBPID ");
		sqlStr.append("AND C.CO_USERNAME = FUH.UPDATE_USER ");
		sqlStr.append("AND C.CO_STAFF_ID = S.CO_STAFF_ID(+) ");
		sqlStr.append("ORDER BY FUH.UPDATE_DATE DESC ");

		//System.out.println("--------------InPatientPreBook (histList)--------------");
		//System.out.println(sqlStr.toString());
		//System.out.println("-----------------------------------------------------------------------");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getList(String docLastName, String docGivenName, String admDateFrom, String admDateTo,
									String patNo, String patName, String flwDateFrom,
									String flwDateTo, String result, String sortBy,
									String ordering, boolean report, String smsDateFrom, String smsDateTo,
									String orderDateFrom, String orderDateTo,String pbWard) {
		return getList(docLastName, docGivenName, admDateFrom, admDateTo, patNo, patName,
						flwDateFrom, flwDateTo, result, sortBy, ordering, report, smsDateFrom,
						smsDateTo, orderDateFrom, orderDateTo, new String[] { pbWard });
	}

	public static ArrayList getList(String docLastName, String docGivenName, String admDateFrom, String admDateTo,
										String patNo, String patName, String flwDateFrom,
										String flwDateTo, String result, String sortBy,
										String ordering, boolean report, String smsDateFrom, String smsDateTo,
										String orderDateFrom, String orderDateTo, String[] pbWard) {

		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("Select DISTINCT PATNO, PATNAME, PATCNAME, PATHTEL, PATOTEL, PATPAGER, PATEMAIL, ");
		sqlStr.append("  DOCCODE, ADMDATE, CURINHSE, DOCNAME, PBPID, flw_up_status, ");
		sqlStr.append("  flw_up_date, PATADDRMK, WRDNAME, BPBRMK, ACMCODE, PATKHTEL, TO_CHAR(SEND_TIME, 'DD/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("  SEND_TIME, ORDERDATE, TO_CHAR(ORDERDATE, 'DD/MM/YYYY HH24:MI'), CABLABRMK, SURTIME, ");
		sqlStr.append("  GENDER, BED, OTREMARK, OTPDESC, ");
		//sqlStr.append("(SELECT P.OTPDESC FROM OT_APP@IWEB A, OT_PROC@IWEB P WHERE A.OTPID = P.OTPID AND A.PBPID = PBPID) ");
		sqlStr.append("  BE ");
		sqlStr.append("FROM (");

		sqlStr.append("((");
		//SELECT
		sqlStr.append("SELECT P.PATNO, P.PATFNAME||', '||P.PATGNAME AS PATNAME, P.PATCNAME, ");
		sqlStr.append("  P.PATHTEL, P.PATOTEL, B.PATPAGER, P.PATEMAIL, B.DOCCODE, ");
		sqlStr.append("  TO_CHAR(B.BPBHDATE, 'DD/MM/YYYY HH24:MI') as admDate, ");
		sqlStr.append("  DECODE(IH.PATNO, NULL, 'NO', 'YES') as curInHse, ");
		sqlStr.append("  D.DOCFNAME||', '||D.DOCGNAME AS DOCNAME, B.PBPID, ");
		sqlStr.append("  fuh.flw_up_status,TO_CHAR(fuh.flw_up_date,'DD/MM/YYYY') AS flw_up_date, ");
		//sqlStr.append("P.PATNO ");
		sqlStr.append("  P.PATADDRMK, W.WRDNAME, B.BPBRMK, B.ACMCODE, B.PATKHTEL, SMS.SEND_TIME, ");
		sqlStr.append("  B.BPBODATE as orderDate, B.CABLABRMK, ");
		sqlStr.append("  TO_CHAR(O.OTAOSDATE, 'DD/MM/YYYY HH24:MI') AS SURTIME, P.PATSEX AS GENDER, ");
		sqlStr.append("  B.BEDCODE AS BED, B.OTREMARK, ");
		sqlStr.append(" (SELECT OTPDESC FROM OT_PROC@IWEB WHERE OTPID = O.OTPID) AS OTPDESC, ");
		sqlStr.append(" decode(FE.OSB_BE,'-1','YES','') AS BE ");

		//FROM
		sqlStr.append("FROM BEDPREBOK@IWEB B, PATIENT@IWEB P, DOCTOR@IWEB D, BEDPREBOK_EXTRA@IWEB BE, ");
		sqlStr.append("  (SELECT * FROM FLW_UP_HIST f1 ");
		sqlStr.append("  WHERE f1.update_date in ");
		sqlStr.append("  (SELECT MAX(f2.update_date) ");
		sqlStr.append("  FROM FLW_UP_HIST f2 ");
//		sqlStr.append("  WHERE f1.patno = f2.patno ");
		sqlStr.append("  WHERE f1.pbpid = f2.pbpid ");
		sqlStr.append("  AND f2.FLW_UP_TYPE = 'INPATPB' ");
		sqlStr.append("  GROUP BY f2.pbpid) ");
		sqlStr.append("  AND f1.FLW_UP_TYPE = 'INPATPB') FUH, WARD@IWEB W, ");
		sqlStr.append("  (SELECT R.PATNO FROM REG@IWEB R, INPAT@IWEB I ");
		sqlStr.append("  WHERE R.REGTYPE = 'I' AND I.INPDDATE IS NULL ");
		sqlStr.append("  AND R.INPID = I.INPID AND R.REGSTS = 'N') IH, ");
		sqlStr.append("  (SELECT  S.KEY_ID, S.CREATE_DATE AS SEND_TIME ");
		sqlStr.append("  FROM (SELECT * FROM SMS_LOG S1 ");
		sqlStr.append("  WHERE S1.MSG_BATCH_ID IN (SELECT MAX(S2.MSG_BATCH_ID) ");
		sqlStr.append("  FROM SMS_LOG S2 WHERE S1.KEY_ID = S2.KEY_ID AND S2.ACT_TYPE = 'INPAT') ");
		sqlStr.append("  AND S1.ACT_TYPE = 'INPAT') S, CO_USERS U, CO_STAFFS CS ");
		sqlStr.append("  WHERE S.ACT_TYPE = 'INPAT' ");
		sqlStr.append("  AND   S.SENDER = U.CO_USERNAME(+) ");
		sqlStr.append("  AND   U.CO_STAFF_ID = CS.CO_STAFF_ID(+) ");
		sqlStr.append("  ORDER BY S.CREATE_DATE DESC ) SMS, ");
		sqlStr.append("  (SELECT PBPID, OTAOSDATE, OTPID ");
		sqlStr.append("  FROM OT_APP@IWEB O1 ");
		sqlStr.append("  WHERE O1.OTAOSDATE = (SELECT MIN(O2.OTAOSDATE) ");
		sqlStr.append("  FROM OT_APP@IWEB O2 ");
		sqlStr.append("  WHERE O1.PBPID = O2.PBPID ");
		sqlStr.append("  AND O2.OTASTS = 'N' GROUP BY O2.PATNO) AND O1.OTASTS = 'N') O, ");
		sqlStr.append("  FIN_EST_HOSP@IWEB FE ");

		//WHERE
		sqlStr.append("WHERE B.PATNO = P.PATNO (+) ");
		sqlStr.append("AND B.PATNO IS NOT NULL ");
//		sqlStr.append("AND (P.PATHTEL IS NOT NULL ");
//		sqlStr.append("OR P.PATEMAIL IS NOT NULL ");
//		sqlStr.append("OR P.PATOTEL IS NOT NULL ");
//		sqlStr.append("OR P.PATPAGER IS NOT NULL) ");
		sqlStr.append("AND B.DOCCODE = D.DOCCODE (+) ");
//		sqlStr.append("AND B.PATNO = FUH.PATNO (+) ");
		sqlStr.append("AND B.PBPID = FUH.PBPID (+) ");
		sqlStr.append("AND (B.WRDCODE <> 'OB' OR B.WRDCODE is NULL) ");
		sqlStr.append("AND B.WRDCODE = W.WRDCODE (+) ");
		sqlStr.append("AND B.PATNO = IH.PATNO (+) ");
		sqlStr.append("AND B.BPBSTS <> 'D' ");
		sqlStr.append("AND to_char(B.PBPID) = SMS.KEY_ID (+) ");
		sqlStr.append("AND B.PBPID = O.PBPID (+) ");
		sqlStr.append("AND B.PBPID = FE.PBPID (+) ");
		sqlStr.append("AND B.PBPID = BE.PBPID(+) ");			
		sqlStr.append("AND BE.BPBREGTYPE = 'I' ");			

		if (docLastName != null && docLastName.length() > 0) {
			sqlStr.append("AND UPPER(TRIM(D.DOCFNAME)) LIKE UPPER('%");
			sqlStr.append(docLastName);
			sqlStr.append("%') ");
		}
		if (docGivenName != null && docGivenName.length() > 0) {
			sqlStr.append("AND UPPER(TRIM(D.DOCGNAME)) LIKE UPPER('%");
			sqlStr.append(docGivenName);
			sqlStr.append("%') ");
		}
		if (patNo != null && patNo.length() > 0) {
			sqlStr.append("AND P.PATNO = '");
			sqlStr.append(patNo);
			sqlStr.append("' ");
		}
		if (patName != null && patName.length() > 0) {
			sqlStr.append("AND UPPER(TRIM(p.patfname))||' '||UPPER(TRIM(p.patgname)) LIKE UPPER('%");
			sqlStr.append(patName);
			sqlStr.append("%') ");
		}
		if (admDateFrom != null && admDateFrom.length() > 0) {
			sqlStr.append("AND b.BPBHDATE >= TO_DATE('");
			sqlStr.append(admDateFrom +" 00:00:00");
			sqlStr.append("','DD/MM/YYYY HH24:MI:SS') ");
		}
		if (admDateTo != null && admDateTo.length() > 0) {
			sqlStr.append("AND b.BPBHDATE <= TO_DATE('");
			sqlStr.append(admDateTo +" 23:59:59");
			sqlStr.append("','DD/MM/YYYY HH24:MI:SS') ");
		}
		if (flwDateFrom != null && flwDateFrom.length() > 0) {
			sqlStr.append("AND FUH.FLW_UP_DATE >= TO_DATE('");
			sqlStr.append(flwDateFrom +" 00:00:00");
			sqlStr.append("','DD/MM/YYYY HH24:MI:SS') ");
		}
		if (flwDateTo != null && flwDateTo.length() > 0) {
			sqlStr.append("AND FUH.FLW_UP_DATE <= TO_DATE('");
			sqlStr.append(flwDateTo +" 23:59:59");
			sqlStr.append("','DD/MM/YYYY HH24:MI:SS') ");
		}
		if (smsDateFrom != null && smsDateFrom.length() > 0) {
			sqlStr.append("AND SMS.SEND_TIME >= TO_DATE('");
			sqlStr.append(smsDateFrom +" 00:00:00");
			sqlStr.append("','DD/MM/YYYY HH24:MI:SS') ");
		}
		if (smsDateTo != null && smsDateTo.length() > 0) {
			sqlStr.append("AND SMS.SEND_TIME <= TO_DATE('");
			sqlStr.append(smsDateTo +" 23:59:59");
			sqlStr.append("','DD/MM/YYYY HH24:MI:SS') ");
		}
		if (orderDateFrom != null && orderDateFrom.length() > 0) {
			sqlStr.append("AND b.BPBODATE >= TO_DATE('");
			sqlStr.append(orderDateFrom +" 00:00:00");
			sqlStr.append("','DD/MM/YYYY HH24:MI:SS') ");
		}
		if (orderDateTo != null && orderDateTo.length() > 0) {
			sqlStr.append("AND b.BPBODATE <= TO_DATE('");
			sqlStr.append(orderDateTo +" 23:59:59");
			sqlStr.append("','DD/MM/YYYY HH24:MI:SS') ");
		}

		if (result != null && result.length() > 0) {
			sqlStr.append("AND FLW_UP_STATUS = '");
			sqlStr.append(result);
			sqlStr.append("' ");
		}

		if (pbWard != null) {
			if (pbWard.length > 0) {
				sqlStr.append("AND (B.WRDCODE = '1' ");
			}
			for (int i = 0; i < pbWard.length; i++) {
				if (pbWard[i].length() > 0) {
					if (pbWard[i].equals("NONE")) {
						sqlStr.append("OR B.WRDCODE IS NULL ");
					} else {
						sqlStr.append("OR B.WRDCODE = '");
						sqlStr.append(pbWard[i]);
						sqlStr.append("' ");
					}
				}
			}
			if (pbWard.length > 0) {
				sqlStr.append(") ");
			}
		}

		sqlStr.append(")UNION(");

		sqlStr.append("SELECT '', B.BPBPNAME AS PATNAME, B.BPBCNAME, '', '', B.PATPAGER, '', ");
		sqlStr.append("B.DOCCODE, TO_CHAR(B.BPBHDATE, 'DD/MM/YYYY HH24:MI') as admDate, ");
		sqlStr.append("DECODE(B.BPBSTS, 'F', 'YES', 'NO') as curInHse, ");
		sqlStr.append("D.DOCFNAME||', '||D.DOCGNAME AS DOCNAME, ");
		sqlStr.append("B.PBPID, fuh.flw_up_status,TO_CHAR(fuh.flw_up_date,'DD/MM/YYYY') AS flw_up_date, '', ");
		sqlStr.append("W.WRDNAME, B.BPBRMK, B.ACMCODE, B.PATKHTEL, SMS.SEND_TIME, ");
		sqlStr.append("B.BPBODATE as orderDate, B.CABLABRMK, ");
		sqlStr.append("TO_CHAR(O.OTAOSDATE, 'DD/MM/YYYY HH24:MI') AS SURTIME, B.SEX AS GENDER, ");
		sqlStr.append("B.BEDCODE AS BED, B.OTREMARK, ");
		sqlStr.append("(SELECT OTPDESC FROM OT_PROC@IWEB WHERE OTPID = O.OTPID) AS OTPDESC, ");
		sqlStr.append(" decode(FE.OSB_BE,'-1','YES','') AS BE ");

		sqlStr.append("FROM BEDPREBOK@IWEB B, DOCTOR@IWEB D, BEDPREBOK_EXTRA@IWEB BE, ");
		
		// Fix bottleneck start
		// original
		/*
		sqlStr.append("(SELECT * FROM FLW_UP_HIST f1 WHERE f1.update_date = ");
		sqlStr.append("(SELECT MAX(f2.update_date) FROM FLW_UP_HIST f2 ");
//		sqlStr.append("WHERE f1.patpager = f2.patpager ");
		sqlStr.append("WHERE f1.pbpid = f2.pbpid AND f2.FLW_UP_TYPE = 'INPATPB' ");
		sqlStr.append("GROUP BY f2.pbpid) AND f1.FLW_UP_TYPE = 'INPATPB') FUH, WARD@IWEB W, ");
		*/
		sqlStr.append("  (SELECT * FROM FLW_UP_HIST f1 WHERE (pbpid, update_date) in ");
		sqlStr.append("    (");
		sqlStr.append("      select ");
		sqlStr.append("        pbpid, ");
		sqlStr.append("        max(update_date) keep (dense_rank first order by pbpid) update_date ");
		sqlStr.append("      FROM FLW_UP_HIST ");
		sqlStr.append("      group by pbpid ");
		sqlStr.append("    )");
		sqlStr.append("  AND f1.FLW_UP_TYPE = 'INPATPB') FUH, WARD@IWEB W, ");
		// Fix bottleneck end
		
		sqlStr.append("  (SELECT  S.KEY_ID, S.CREATE_DATE AS SEND_TIME ");
		sqlStr.append("  FROM (SELECT * FROM SMS_LOG S1 ");
		sqlStr.append("  WHERE S1.MSG_BATCH_ID IN (SELECT MAX(S2.MSG_BATCH_ID) FROM SMS_LOG S2 ");
		sqlStr.append("  WHERE S1.KEY_ID = S2.KEY_ID AND S2.ACT_TYPE = 'INPAT') ");
		sqlStr.append("  AND S1.ACT_TYPE = 'INPAT') S, CO_USERS U, CO_STAFFS CS ");
		sqlStr.append("  WHERE S.ACT_TYPE = 'INPAT' ");
		sqlStr.append("  AND   S.SENDER = U.CO_USERNAME(+) ");
		sqlStr.append("  AND   U.CO_STAFF_ID = CS.CO_STAFF_ID(+) ");
		sqlStr.append("  ORDER BY S.CREATE_DATE DESC ) SMS, ");
		sqlStr.append("  (SELECT PBPID, OTAOSDATE, OTPID ");
		sqlStr.append("  FROM OT_APP@IWEB O1 ");
		sqlStr.append("  WHERE O1.OTAOSDATE = (SELECT MIN(O2.OTAOSDATE) ");
		sqlStr.append("  FROM OT_APP@IWEB O2 ");
		sqlStr.append("  WHERE O1.PBPID = O2.PBPID ");
		sqlStr.append("  AND O2.OTASTS = 'N' GROUP BY O2.PATNO) AND O1.OTASTS = 'N') O, ");
		sqlStr.append("  FIN_EST_HOSP@IWEB FE ");

		sqlStr.append("WHERE B.PATNO is null ");
//		sqlStr.append("AND B.PATPAGER is not null ");
		sqlStr.append("AND B.DOCCODE = D.DOCCODE (+) ");
//		sqlStr.append("AND B.PATPAGER = FUH.PATPAGER (+) ");
		sqlStr.append("AND B.PBPID = FUH.PBPID(+) ");
		sqlStr.append("AND (B.WRDCODE <> 'OB' OR B.WRDCODE is NULL) ");
		sqlStr.append("AND B.WRDCODE = W.WRDCODE (+) ");
		sqlStr.append("AND B.BPBSTS <> 'D' ");
		sqlStr.append("AND TO_CHAR(B.PBPID) = SMS.KEY_ID (+) ");
		sqlStr.append("AND B.PBPID = O.PBPID (+) ");
		sqlStr.append("AND B.PBPID = FE.PBPID (+) ");
		sqlStr.append("AND B.PBPID = BE.PBPID(+) ");			
		sqlStr.append("AND BE.BPBREGTYPE = 'I' ");		

		if (docLastName != null && docLastName.length() > 0) {
			sqlStr.append("AND UPPER(TRIM(D.DOCFNAME)) LIKE UPPER('%");
			sqlStr.append(docLastName);
			sqlStr.append("%') ");
		}
		if (docGivenName != null && docGivenName.length() > 0) {
			sqlStr.append("AND UPPER(TRIM(D.DOCGNAME)) LIKE UPPER('%");
			sqlStr.append(docGivenName);
			sqlStr.append("%') ");
		}

		if (patNo != null && patNo.length() > 0) {
			sqlStr.append("AND B.PATNO = '");
			sqlStr.append(patNo);
			sqlStr.append("' ");
		}

		if (patName != null && patName.length() > 0) {
			sqlStr.append("AND UPPER(TRIM(B.BPBPNAME)) LIKE UPPER('%");
			sqlStr.append(patName);
			sqlStr.append("%') ");
		}

		if (admDateFrom != null && admDateFrom.length() > 0) {
			sqlStr.append("AND b.BPBHDATE >= TO_DATE('");
			sqlStr.append(admDateFrom +" 00:00:00");
			sqlStr.append("','DD/MM/YYYY HH24:MI:SS') ");
		}
		if (admDateTo != null && admDateTo.length() > 0) {
			sqlStr.append("AND b.BPBHDATE <= TO_DATE('");
			sqlStr.append(admDateTo +" 23:59:59");
			sqlStr.append("','DD/MM/YYYY HH24:MI:SS') ");
		}
		if (flwDateFrom != null && flwDateFrom.length() > 0) {
			sqlStr.append("AND FUH.FLW_UP_DATE >= TO_DATE('");
			sqlStr.append(flwDateFrom +" 00:00:00");
			sqlStr.append("','DD/MM/YYYY HH24:MI:SS') ");
		}
		if (flwDateTo != null && flwDateTo.length() > 0) {
			sqlStr.append("AND FUH.FLW_UP_DATE <= TO_DATE('");
			sqlStr.append(flwDateTo +" 23:59:59");
			sqlStr.append("','DD/MM/YYYY HH24:MI:SS') ");
		}
		if (smsDateFrom != null && smsDateFrom.length() > 0) {
			sqlStr.append("AND SMS.SEND_TIME >= TO_DATE('");
			sqlStr.append(smsDateFrom +" 00:00:00");
			sqlStr.append("','DD/MM/YYYY HH24:MI:SS') ");
		}
		if (smsDateTo != null && smsDateTo.length() > 0) {
			sqlStr.append("AND SMS.SEND_TIME <= TO_DATE('");
			sqlStr.append(smsDateTo +" 23:59:59");
			sqlStr.append("','DD/MM/YYYY HH24:MI:SS') ");
		}
		if (orderDateFrom != null && orderDateFrom.length() > 0) {
			sqlStr.append("AND b.BPBODATE >= TO_DATE('");
			sqlStr.append(orderDateFrom +" 00:00:00");
			sqlStr.append("','DD/MM/YYYY HH24:MI:SS') ");
		}
		if (orderDateTo != null && orderDateTo.length() > 0) {
			sqlStr.append("AND b.BPBODATE <= TO_DATE('");
			sqlStr.append(orderDateTo +" 23:59:59");
			sqlStr.append("','DD/MM/YYYY HH24:MI:SS') ");
		}

		if (result != null && result.length() > 0) {
			sqlStr.append("AND FLW_UP_STATUS = '");
			sqlStr.append(result);
			sqlStr.append("' ");
		}

		if (pbWard != null) {
			if (pbWard.length > 0) {
				sqlStr.append("AND (B.WRDCODE = '1' ");
			}
			for (int i = 0; i < pbWard.length; i++) {
				if (pbWard[i].length() > 0) {
					if (pbWard[i].equals("NONE")) {
						sqlStr.append("OR B.WRDCODE IS NULL ");
					}
					else {
						sqlStr.append("OR B.WRDCODE = '");
						sqlStr.append(pbWard[i]);
						sqlStr.append("' ");
					}
				}
			}
			if (pbWard.length > 0) {
				sqlStr.append(") ");
			}
		}
		sqlStr.append(")) ");
		sqlStr.append(") ");
		sqlStr.append("ORDER BY ");
		if (report) {
			sqlStr.append("WRDNAME, ");
		}
		if (sortBy.equals("ADMDATE") || sortBy.equals("SURTIME")) {
			sqlStr.append("TO_DATE("+sortBy+", 'DD/MM/YYYY HH24:MI:SS') "+ordering+" ");
		} else {
			sqlStr.append(sortBy+" "+ordering+" ");
		}
///*
		System.out.println(new Date() + "[DEBUG]");
		System.out.println("--------------InPatientPreBook (getList)--------------");
		System.out.println(sqlStr.toString());
		System.out.println("-----------------------------------------------------------------------");
//*/
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static String sendSMSToClient(UserBean userBean, String admDate, String lang, String receiver,
											String type, String keyId,String template) throws IOException {
		StringBuffer commentStr = new StringBuffer();

		if (template != null && template.equals("reminder2")) {
			if (lang.equals("eng")) {
				commentStr.append(MessageResources.getMessageEnglish("prompt.sms.reminder.heading"));
				commentStr.append("\r\n");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sms.reminder.block1")+" ");
				commentStr.append(admDate);
				commentStr.append(" ");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sms.reminder.block2a")+" ");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sms.reminder.block2b")+" ");
			} else if (lang.equals("chi")) {
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.sms.reminder.heading"));
				commentStr.append("\r\n");
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.sms.reminder.block1")+" ");
				commentStr.append(admDate);
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.sms.reminder.block2a")+" ");
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.sms.reminder.block2b")+" ");
			}
		} else {
			if (lang.equals("eng")) {
				commentStr.append(MessageResources.getMessageEnglish("prompt.sms.heading"));
				commentStr.append("\r\n");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sms.block1")+" ");
				commentStr.append(admDate);
				commentStr.append(MessageResources.getMessageEnglish("prompt.sms.block2a")+" ");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sms.block2b")+" ");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sms.block3"));
				commentStr.append("\r\n");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sms.block4"));
				commentStr.append("\r\n");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sms.block5"));
				commentStr.append("\r\n");
			} else if (lang.equals("chi")) {
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.sms.heading"));
				commentStr.append("\r\n");
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.sms.block1")+" ");
				commentStr.append(admDate);
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.sms.block2a")+" ");
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.sms.block2b")+" ");
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.sms.block3"));
				commentStr.append("\r\n");
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.sms.block4"));
				commentStr.append("\r\n");
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.sms.block5"));
				commentStr.append("\r\n");
				commentStr.append("-");
			}
		}

		return UtilSMS.sendSMS(userBean, new String[] { receiver },
							commentStr.toString(), type, keyId, null, template);
	}

	public static boolean sendEmailToClient(UserBean userBean, String admDate, String email) {
		String sessionID = SessionLoginDB.add(userBean, email);

		StringBuffer commentStr = new StringBuffer();
		commentStr.append(MessageResources.getMessageEnglish("prompt.booking.heading"));
		commentStr.append("<br>");
		commentStr.append("<br><br>");
		commentStr.append(MessageResources.getMessageEnglish("prompt.booking.step1.block1"));
		commentStr.append(" "+admDate+". ");
		commentStr.append("<br><br>");
		commentStr.append(MessageResources.getMessageEnglish("prompt.booking.step1.block2a"));
		commentStr.append(sessionID);
		commentStr.append(MessageResources.getMessageEnglish("prompt.booking.step1.block2b"));
		commentStr.append("<br><br>");                               
		commentStr.append(MessageResources.getMessageEnglish("prompt.booking.step1.block2c"));
		commentStr.append("<br><br>");                               
		commentStr.append(MessageResources.getMessageEnglish("prompt.booking.step1.block3a"));
		commentStr.append(MessageResources.getMessageEnglish("prompt.booking.step1.block3b"));
		commentStr.append("<br><br>");                               
		commentStr.append(MessageResources.getMessageEnglish("prompt.booking.step1.block4"));
		commentStr.append("<br><br>");
		commentStr.append(MessageResources.getMessageEnglish("prompt.booking.ending"));
		commentStr.append("<br>");
		commentStr.append(MessageResources.getMessageEnglish("prompt.booking.admission.office"));
		commentStr.append("<br>");
		commentStr.append(MessageResources.getMessageEnglish("prompt.booking.hospital"));
		commentStr.append("<br><br>");
		commentStr.append(MessageResources.getMessageEnglish("prompt.booking.tel"));

		commentStr.append("<br><br><br>");

		commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.booking.heading"));
		commentStr.append("<br>");
		commentStr.append("<br><br>");
		commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.booking.step1.block1a"));
		commentStr.append(" "+admDate+" ");
		commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.booking.step1.block1b"));
		commentStr.append("<br><br>");
		commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.booking.step1.block2a"));
		commentStr.append(sessionID);
		commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.booking.step1.block2b"));
		commentStr.append("<br><br>");                                          
		commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.booking.step1.block2c"));
		commentStr.append("<br><br>");                                          
		commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.booking.step1.block3a"));
		commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.booking.step1.block3b"));
		commentStr.append("<br><br>");                                          
		commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.booking.step1.block4"));
		commentStr.append("<br><br>");
		commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.booking.ending"));
		commentStr.append("<br>");
		commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.booking.hospital"));
		commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.booking.admission.office"));
		commentStr.append("<br><br>");
		commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.booking.tel"));

		return UtilMail.sendMail(
				"admission@hkah.org.hk",
				new String[] { email },
				null,
				new String[] { "admission@hkah.org.hk", "sandra.chow@hkah.org.hk","cherry.wong@hkah.org.hk","ricky.leung@hkah.org.hk", "andrew.lau@hkah.org.hk" },
				"Hong Kong Adventist Hospital –Stubbs Road (Online Registration)",
				commentStr.toString(),true);
	}

	public static String updateSentDT(String type, String BPBID, String id) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("UPDATE BEDPREBOK@IWEB ");
		if (type.equals("SMS")) {
			sqlStr.append("SET SMSSENTDT = (SELECT SEND_TIME FROM SMS_LOG WHERE MSG_BATCH_ID = '"+id+"') ");
		} else {
			sqlStr.append("SET EMAILSENTDT = SYSDATE ");
		}
		sqlStr.append("WHERE PBPID = '"+BPBID+"' ");

//		System.out.println("--------------InPatientPreBook (updateSentDT)--------------");
//		System.out.println(sqlStr.toString());
//		System.out.println("-----------------------------------------------------------------------");

		return String.valueOf(UtilDBWeb.updateQueue(sqlStr.toString()));

		/*sqlStr.setLength(0);
		if (type.equals("SMS")) {
			sqlStr.append("SELECT TO_CHAR(SMSSENTDT, 'DD/MM/YYYY HH24:MI') ");
		} else {
			sqlStr.append("SELECT TO_CHAR(EMAILSENTDT, 'DD/MM/YYYY HH24:MI') ");
		}
		sqlStr.append("FROM BEDPREBOK@IWEB ");
		sqlStr.append("WHERE PBPID = '"+BPBID+"' ");

		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());
		ReportableListObject row = (ReportableListObject) record.get(0);*/

//		return row.getValue(0);
	}

	public static boolean updatePatientEmail(String patno, String email) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("UPDATE PATIENT@IWEB ");
		sqlStr.append("SET PATEMAIL = '"+email+"' ");
		sqlStr.append("WHERE PATNO = '"+patno+"' ");

//		System.out.println("--------------InPatientPreBook (updatePatientEmail)--------------");
//		System.out.println(sqlStr.toString());
//		System.out.println("-----------------------------------------------------------------------");

		return UtilDBWeb.updateQueue(sqlStr.toString());
	}

	public static boolean updatePatientPager(String patno, String preBookID, String patPager) {
		StringBuffer sqlStr = new StringBuffer();

//		if (patno != null && patno.length() > 0) {
//			sqlStr.append("UPDATE PATIENT@IWEB ");
//			sqlStr.append("SET PATPAGER = '"+patPager+"' ");
//			sqlStr.append("WHERE PATNO = '"+patno+"' ");
//		} else {
			sqlStr.append("UPDATE BEDPREBOK@IWEB ");
			sqlStr.append("SET PATPAGER = '"+patPager+"' ");
			sqlStr.append("WHERE PBPID = '"+preBookID+"' ");
//		}

//		System.out.println("--------------InPatientPreBook (updatePatientPager)--------------");
//		System.out.println(sqlStr.toString());
//		System.out.println("-----------------------------------------------------------------------");

		return UtilDBWeb.updateQueue(sqlStr.toString());
	}

	public static ArrayList getCountryCode() {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT COUCODE FROM COUNTRY@IWEB ORDER BY COUCODE");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getLastAdmDate(String patNo) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT TO_CHAR(R.REGDATE, 'DD/MM/YYYY HH24:MI'), A.AMTDESC ");
		sqlStr.append("FROM REG@IWEB R, INPAT@IWEB I, ADMISSIONTYPE@IWEB A ");
		sqlStr.append("WHERE REGDATE = ( ");
		sqlStr.append("SELECT MAX(REGDATE) ");
		sqlStr.append("FROM REG@IWEB ");
		sqlStr.append("WHERE PATNO = '"+patNo+"' ");
		sqlStr.append("AND REGTYPE = 'I') ");
		sqlStr.append("AND PATNO = '"+patNo+"' ");
		sqlStr.append("AND REGTYPE = 'I' ");
		sqlStr.append("AND I.INPID = R.INPID ");
		sqlStr.append("AND I.AMTID = A.AMTID(+) ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getLastReachedBy(String preBookID) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT flw_up_status FROM FLW_UP_HIST f1 ");
		sqlStr.append("WHERE f1.update_date = ");
		sqlStr.append("(SELECT MAX(f2.update_date) ");
		sqlStr.append("FROM FLW_UP_HIST f2 ");
		sqlStr.append("WHERE f1.pbpid = f2.pbpid ");
		sqlStr.append("AND f2.FLW_UP_TYPE = 'INPATPB' ");
		sqlStr.append("GROUP BY f2.pbpid) ");
		sqlStr.append("AND f1.FLW_UP_TYPE = 'INPATPB' ");
		sqlStr.append("AND f1.PBPID = '"+preBookID+"' ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static String getLastPayMth(String patNo) {
		StringBuffer sqlStr1 = new StringBuffer();
		StringBuffer sqlStr2 = new StringBuffer();

		sqlStr1.append("SELECT CTXMETH FROM CASHTX@IWEB WHERE SLPNO = ( ");
		sqlStr1.append("SELECT SLPNO FROM REG@IWEB R WHERE R.REGTYPE = 'I' AND REGDATE = ( ");
		sqlStr1.append("SELECT MAX(REGDATE) FROM REG@IWEB R WHERE R.REGTYPE = 'I' AND PATNO = '"+patNo+"') AND REGTYPE = 'I' ");
		sqlStr1.append("AND PATNO = '"+patNo+"') ");

		sqlStr2.append("SELECT * FROM ARTX@IWEB WHERE SLPNO = ( ");
		sqlStr2.append("SELECT SLPNO FROM REG@IWEB R WHERE R.REGTYPE = 'I' AND REGDATE = ( ");
		sqlStr2.append("SELECT MAX(REGDATE) FROM REG@IWEB R WHERE R.REGTYPE = 'I' AND PATNO = '"+patNo+"') AND REGTYPE = 'I' ");
		sqlStr2.append("AND PATNO = '"+patNo+"') ");

		ArrayList record = UtilDBWeb.getReportableList(sqlStr2.toString());

		if (record.size() > 0) {
			return "Insurance";
		} else {
			record = UtilDBWeb.getReportableList(sqlStr1.toString());

			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				String payMth = row.getValue(0);
				if (payMth.equals("A")) {
					return "Autopay";
				} else if (payMth.equals("C")) {
					return "Cash";
				} else if (payMth.equals("D")) {
					return "Credit Card";
				} else if (payMth.equals("E")) {
					return "EPS";
				} else if (payMth.equals("Q")) {
					return "Cheque";
				} else if (payMth.equals("U")) {
					return "China Union Pay Card";
				}
			}
		}

		return "";
	}

	public static boolean transToPreAdmission(UserBean userBean, String patNo, String bpbID) {
		ArrayList record = getPatDtl(patNo, bpbID);

		if (record.size() > 0) {
			String admissionID = AdmissionDB.add(userBean);

			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE HAT_PATIENT ");
			sqlStr.append("SET HAT_CREATED_USER = 'SYSTEM' ");
			sqlStr.append("WHERE HAT_ADMNO = '"+admissionID+"' ");

			UtilDBWeb.updateQueue(sqlStr.toString());

			ReportableListObject row = (ReportableListObject) record.get(0);

			if (patNo != null && patNo.length() > 0) {
				return AdmissionDB.update(userBean, admissionID, row.getValue(0),
						row.getValue(31), row.getValue(32), row.getValue(4),
						null, null, row.getValue(30), null, null, row.getValue(1),
						row.getValue(33), null, row.getValue(34), null, row.getValue(35),
						row.getValue(36), row.getValue(37), null, null, row.getValue(38),
						row.getValue(7), row.getValue(39), row.getValue(6), row.getValue(40),
						row.getValue(41), row.getValue(8), row.getValue(42), row.getValue(43),
						row.getValue(44), null, row.getValue(22),
						null, null, null, null, null, null, null, null, null, null, null, null,
						null, null, null, null, null, null,
						null, null, null, null, null, null,
						null, null, null, null, row.getValue(10),
						null, AdmissionDB.getDocName(row.getValue(46)),
						(row.getValue(45).equals("IC")?"ICU":
							(row.getValue(45).equals("ME")?"Medical":
								(row.getValue(45).equals("OB")?"Obstetric":
									(row.getValue(45).equals("PD")?"Pediatric":
										(row.getValue(45).equals("SU")?"Surgical":
											(row.getValue(45).equals("IN")?"Integrated":"")))))),
						row.getValue(15), row.getValue(17), null,
						null, null, null, null, null, null, null, null, null, null);
			} else if (bpbID != null && bpbID.length() > 0) {
				return AdmissionDB.update(userBean, admissionID	, null,
						null, row.getValue(3), row.getValue(4),
						null, null, null, null, null, row.getValue(1),
						null, null, null, null, null,
						null, null, null, null, null,
						null, null, row.getValue(6), null,
						null, null, null, null,
						null, null, null,
						null, null, null, null, null, null, null, null, null, null, null, null,
						null, null, null, null, null, null,
						null, null, null, null, null, null,
						null, null, null, null, row.getValue(10),
						null, AdmissionDB.getDocName(row.getValue(46)),
						(row.getValue(45).equals("IC")?"ICU":
							(row.getValue(45).equals("ME")?"Medical":
								(row.getValue(45).equals("OB")?"Obstetric":
									(row.getValue(45).equals("PD")?"Pediatric":
										(row.getValue(45).equals("SU")?"Surgical":
											(row.getValue(45).equals("IN")?"Integrated":"")))))),
						row.getValue(15), row.getValue(17), null,
						null, null, null, null, null, null, null, null, null, null);
			}
		}
		return false;
	}
}