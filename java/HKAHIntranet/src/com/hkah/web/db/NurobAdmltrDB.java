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

public class NurobAdmltrDB {
	private static String sqlStr_insertNurobAdmltr = null;
	private static String sqlStr_updateNurobAdmltr = null;
	private static String sqlStr_deleteNurobAdmltr = null;
	private static String sqlStr_getNurobAdmltr = null;

	private static String getNextNurobAdmltrID() {
		String nurobAdmltrID = null;

		// get next NurobAdmltr id from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(NUROB_ADMLTR_ID) + 1 FROM NUROB_ADMLTR");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			nurobAdmltrID = reportableListObject.getValue(0);

			// set 1 for initial
			if (nurobAdmltrID == null || nurobAdmltrID.length() == 0) return ConstantsVariable.ONE_VALUE;
		}
		return nurobAdmltrID;
	}
	
	public static String add(UserBean userBean, 
			String nurobPatient, 
			String nurobAge,
			String nurobTelno, 
			String nurobBookno,
			String nurobStatus, 
			String nurobGravida,
			String nurobPara,
			String nurobEdc,
			String nurobDr,
			String nurobClinic,
			String nurobAllergy,
			String nurobCardiac,
			String nurobDiabetes,
			String nurobDm,
			String nurobGdm,
			String nurobIgt,
			String nurobAnemia,
			String nurobRenal,
			String nurobLiver, 
			String nurobResp,
			String nurobGi,
			String nurobEpilepsy,
			String nurobPsychiatric,
			String nurobImmun,
			String nurobThyroid,
			String nurobSurg,
			String nurobMulti,
			String nurobPrevious,
			String nurobHyper,
			String nurobAph,
			String nurobPreterm,
			String nurobBadob,
			String nurobIugr,
			String nurobFetal,
			String nurobRoutine,
			String nurobInduct,
			String nurobElective,
			String nurobCurrmed,
			String nurobRoom,
			String nurobCord,
			String nurobTriallabor,
			String nurobTrialscar,
			String nurobFleet, 
			String nurobShaving,
			String nurobPain,
			String nurobPainPeth,
			String nurobNotify,
			String nurobAnytime,
			String nurobAfter06,
			String nurobNpo,
			String nurobHep,
			String nurobPps,
			String nurobPost,
			String nurobCs,
			String nurobCsbtl,
			String nurobCsdate,
			String nurobCsseltime,
			String nurobGa,
			String nurobSa,
			String nurobIndication,
			String nurobIndicationText,
			String nurobAbdominal,
			String nurobPublic,
			String nurobAnesdr,
			String nurobPremed,
			String nurobPeddr, 
			String nurobFeed,
			String nurobOther) {
		// get next nurobAdmltr ID
		String nurobAdmltrID = getNextNurobAdmltrID();

		// try to insert a new record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertNurobAdmltr,
				new String[] { nurobAdmltrID,
						ConstantsServerSide.SITE_CODE,
						nurobPatient, 
						nurobAge,
						nurobTelno, 
						nurobBookno,
						nurobStatus, 
						nurobGravida,
						nurobPara,
						nurobEdc,
						nurobDr,
						nurobClinic,
						nurobAllergy,
						nurobCardiac,
						nurobDiabetes,
						nurobDm,
						nurobGdm,
						nurobIgt,
						nurobAnemia,
						nurobRenal,
						nurobLiver, 
						nurobResp,
						nurobGi,
						nurobEpilepsy,
						nurobPsychiatric,
						nurobImmun,
						nurobThyroid,
						nurobSurg,
						nurobMulti,
						nurobPrevious,
						nurobHyper,
						nurobAph,
						nurobPreterm,
						nurobBadob,
						nurobIugr,
						nurobFetal,
						nurobRoutine,
						nurobInduct,
						nurobElective,
						nurobCurrmed,
						nurobRoom,
						nurobCord,
						nurobTriallabor,
						nurobTrialscar,
						nurobFleet, 
						nurobShaving,
						nurobPain,
						nurobNotify,
						nurobAnytime,
						nurobAfter06,
						nurobNpo,
						nurobHep,
						nurobPps,
						nurobPost,
						nurobCs,
						nurobCsbtl,
						nurobCsdate,
						nurobGa,
						nurobSa,
						nurobIndication,
						nurobAbdominal,
						nurobPublic,
						nurobAnesdr,
						nurobPremed,
						nurobPeddr, 
						nurobFeed,
						nurobOther,
						nurobIndicationText,
						nurobPainPeth,
						nurobCsseltime,
						userBean.getLoginID(), 
						userBean.getLoginID() })) {
			return nurobAdmltrID;
		} else {
			return null;
		}
	}

	
	public static boolean update(
			UserBean userBean,
			String nurobDeliRmId, 
			String nurobPatient, 
			String nurobAge,
			String nurobTelno, 
			String nurobBookno,
			String nurobStatus, 
			String nurobGravida,
			String nurobPara,
			String nurobEdc,
			String nurobDr,
			String nurobClinic,
			String nurobAllergy,
			String nurobCardiac,
			String nurobDiabetes,
			String nurobDm,
			String nurobGdm,
			String nurobIgt,
			String nurobAnemia,
			String nurobRenal,
			String nurobLiver, 
			String nurobResp,
			String nurobGi,
			String nurobEpilepsy,
			String nurobPsychiatric,
			String nurobImmun,
			String nurobThyroid,
			String nurobSurg,
			String nurobMulti,
			String nurobPrevious,
			String nurobHyper,
			String nurobAph,
			String nurobPreterm,
			String nurobBadob,
			String nurobIugr,
			String nurobFetal,
			String nurobRoutine,
			String nurobInduct,
			String nurobElective,
			String nurobCurrmed,
			String nurobRoom,
			String nurobCord,
			String nurobTriallabor,
			String nurobTrialscar,
			String nurobFleet, 
			String nurobShaving,
			String nurobPain,
			String nurobPainPeth,
			String nurobNotify,
			String nurobAnytime,
			String nurobAfter06,
			String nurobNpo,
			String nurobHep,
			String nurobPps,
			String nurobPost,
			String nurobCs,
			String nurobCsbtl,
			String nurobCsdate,
			String nurobCsseltime,
			String nurobGa,
			String nurobSa,
			String nurobIndication,
			String nurobIndicationText,
			String nurobAbdominal,
			String nurobPublic,
			String nurobAnesdr,
			String nurobPremed,
			String nurobPeddr, 
			String nurobFeed,
			String nurobOther
	) {
		// try to update selected record
		if(UtilDBWeb.updateQueue(
				sqlStr_updateNurobAdmltr,
				new String[] {
						nurobPatient, 
						nurobAge,
						nurobTelno, 
						nurobBookno,
						nurobStatus, 
						nurobGravida,
						nurobPara,
						nurobEdc,
						nurobDr,
						nurobClinic,
						nurobAllergy,
						nurobCardiac,
						nurobDiabetes,
						nurobDm,
						nurobGdm,
						nurobIgt,
						nurobAnemia,
						nurobRenal,
						nurobLiver, 
						nurobResp,
						nurobGi,
						nurobEpilepsy,
						nurobPsychiatric,
						nurobImmun,
						nurobThyroid,
						nurobSurg,
						nurobMulti,
						nurobPrevious,
						nurobHyper,
						nurobAph,
						nurobPreterm,
						nurobBadob,
						nurobIugr,
						nurobFetal,
						nurobRoutine,
						nurobInduct,
						nurobElective,
						nurobCurrmed,
						nurobRoom,
						nurobCord,
						nurobTriallabor,
						nurobTrialscar,
						nurobFleet, 
						nurobShaving,
						nurobPain,
						nurobPainPeth,
						nurobNotify,
						nurobAnytime,
						nurobAfter06,
						nurobNpo,
						nurobHep,
						nurobPps,
						nurobPost,
						nurobCs,
						nurobCsbtl,
						nurobCsdate,
						nurobCsseltime,
						nurobGa,
						nurobSa,
						nurobIndication,
						nurobIndicationText,
						nurobAbdominal,
						nurobPublic,
						nurobAnesdr,
						nurobPremed,
						nurobPeddr, 
						nurobFeed,
						nurobOther,
						userBean.getLoginID(),
						ConstantsServerSide.SITE_CODE, nurobDeliRmId,
				})) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean delete(UserBean userBean, String nurobAdmltrId) {
		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteNurobAdmltr,
				new String[] { userBean.getLoginID(), ConstantsServerSide.SITE_CODE, nurobAdmltrId });
	}
	
	/*
	 * ============================
	 * Below have not been modified
	 * ============================
	 */

	/**
	 * Modify a news
	 * @return whether it is successful to update the record
	 */
	/*
	public static boolean update(UserBean userBean,
			String nurobAdmltrID, String nurobPatient, String nurobAge, String nurobTelno,
			String nurobBookno, String nurobStatus, String nurobGravida, String nurobPara,
			String nurobEdc, String nurobDr, String nurobClinic, String nurobAllergy,
			String nurobCardiac, String nurobDiabetes, String nurobDm, String nurobGdm,
			String nurobIgt, String nurobAnemia, String nurobRenal, String nurobLiver,
			String nurobResp, String nurobGi, String nurobEpilepsy, String nurobPsychiatric,
			String nurobImmun, String nurobThyroid, String nurobSurg, String nurobMulti,
			String nurobPrevious, String nurobHyper, String nurobAph, String nurobPreterm,
			String nurobBadob, String nurobIugr, String nurobFetal, String nurobRoutine,
			String nurobInduct, String nurobElective, String nurobCurrmed, String nurobRoom,
			String nurobCord, String nurobTriallabor, String nurobTrialscar, String nurobFleet,
			String nurobShaving, String nurobPain, String nurobNotify, String nurobAnytime,
			String nurobAfter06, String nurobNpo, String nurobHep, String nurobPps,
			String nurobPost, String nurobCs, String nurobCsbtl, String nurobCsdate,
			String nurobGa, String nurobSa, String nurobIndication, String nurobAbdominal,
			String nurobPublic, String nurobAnesdr, String nurobPremed, String nurobPeddr,
			String nurobFeed, String nurobOther,
			String nurobEnabled) {

		// try to update selected record
		if (UtilDBWeb.updateQueue(
				sqlStr_updateNurobAdmltr,
				new String[] {
						nurobAdmltrID,  nurobPatient,  nurobAge,  nurobTelno,  nurobBookno,
						nurobStatus,  nurobGravida,  nurobPara,  nurobEdc,  nurobDr,  nurobClinic,
						nurobAllergy,  nurobCardiac,  nurobDiabetes,  nurobDm,  nurobGdm,  nurobIgt,
						nurobAnemia,  nurobRenal,  nurobLiver,  nurobResp,  nurobGi,  nurobEpilepsy,
						nurobPsychiatric,  nurobImmun,  nurobThyroid,  nurobSurg,  nurobMulti,
						nurobPrevious,  nurobHyper,  nurobAph,  nurobPreterm,  nurobBadob,  nurobIugr,
						nurobFetal,  nurobRoutine,  nurobInduct,  nurobElective,  nurobCurrmed,
						nurobRoom,  nurobCord,  nurobTriallabor,  nurobTrialscar,  nurobFleet,
						nurobShaving,  nurobPain,  nurobNotify,  nurobAnytime,  nurobAfter06,
						nurobNpo,  nurobHep,  nurobPps,  nurobPost,  nurobCs,  nurobCsbtl,
						nurobCsdate,  nurobGa,  nurobSa,  nurobIndication,  nurobAbdominal,
						nurobPublic,  nurobAnesdr,  nurobPremed,  nurobPeddr,  nurobFeed,
						nurobOther,  userBean.getLoginID(), userBean.getLoginID() })) {

			// delete existing content
			// deleteContent(userBean, newsID, newsCategory);

			// set content
			// addContent(userBean, newsID, newsCategory, processContent(content));

			return true;
		} else {
			return false;
		}
	}
	*/
	
	public static ArrayList get(String nurobAdmltrID) {
		return UtilDBWeb.getReportableList(sqlStr_getNurobAdmltr, new String[] { ConstantsServerSide.SITE_CODE, nurobAdmltrID });
	}
	
	public static ArrayList getList(
			String nurobPatient, String nurobAge, String nurobTelno, String nurobBookno, String nurobEdc, String nurobDr, String nurobClinic){
		return getList(nurobPatient, nurobAge, nurobTelno, nurobBookno, nurobEdc, nurobDr, nurobClinic, 0);
	}
	
	public static ArrayList getList(
			String nurobPatient, String nurobAge, String nurobTelno, String nurobBookno, String nurobEdc, String nurobDr, String nurobClinic, int noOfMaxRecord){
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append(	"select NUROB_ADMLTR_ID, " +
						" NUROB_PATIENT, NUROB_AGE," +
						" NUROB_TELNO, NUROB_BOOKNO," +
						" NUROB_STATUS, TO_CHAR(NUROB_EDC, 'dd/MM/yyyy')," +
						" NUROB_DR, NUROB_CLINIC" +
						" from NUROB_ADMLTR");
		sqlStr.append(" where NUROB_ENABLED = 1");
		StringBuffer whereStr = new StringBuffer();
		List<String> whereParams = new ArrayList<String>();
		if(!StringUtils.isBlank(nurobPatient)){
			whereStr.append(" and UPPER(NUROB_PATIENT) like '%" + StringEscapeUtils.escapeSql(nurobPatient.trim().toUpperCase()) + "%'");
		}
		if(!StringUtils.isBlank(nurobAge)){
			whereStr.append(" and NUROB_AGE like '%" + StringEscapeUtils.escapeSql(nurobAge.trim().toUpperCase()) + "%'");
		}
		if(!StringUtils.isBlank(nurobTelno)){
			whereStr.append(" and UPPER(NUROB_TELNO) like '%" + StringEscapeUtils.escapeSql(nurobTelno.trim().toUpperCase()) + "%'");
		}
		if(!StringUtils.isBlank(nurobBookno)){
			whereStr.append(" and UPPER(NUROB_BOOKNO) like '%" + StringEscapeUtils.escapeSql(nurobBookno.trim().toUpperCase()) + "%'");
		}
		if(!StringUtils.isBlank(nurobEdc)){
			whereStr.append(" and TO_CHAR(NUROB_EDC, 'dd/MM/yyyy') = ?");
			whereParams.add(StringEscapeUtils.escapeSql(nurobEdc.trim()));
		}
		if(!StringUtils.isBlank(nurobDr)){
			whereStr.append(" and UPPER(NUROB_DR) like '%" + StringEscapeUtils.escapeSql(nurobDr.trim().toUpperCase()) + "%'");
		}
		if(!StringUtils.isBlank(nurobClinic)){
			whereStr.append(" and UPPER(NUROB_CLINIC) like '%" + StringEscapeUtils.escapeSql(nurobClinic.trim().toUpperCase()) + "%'");
		}

		sqlStr.append(whereStr);
		sqlStr.append(" order by NUROB_ADMLTR_ID desc");
		
		String[] whereParamsArray = whereParams.toArray(new String[]{});
		if (noOfMaxRecord > 0) {
			return UtilDBWeb.getReportableList(sqlStr.toString(), whereParamsArray, noOfMaxRecord);
		} else {
			return UtilDBWeb.getReportableList(sqlStr.toString(), whereParamsArray);
		}
	}

	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO NUROB_ADMLTR ");
		sqlStr.append("(NUROB_ADMLTR_ID, NUROB_SITE_CODE, ");
		sqlStr.append("NUROB_PATIENT, NUROB_AGE, ");
		sqlStr.append("NUROB_TELNO, NUROB_BOOKNO, ");
		sqlStr.append("NUROB_STATUS, NUROB_GRAVIDA, ");
		sqlStr.append("NUROB_PARA, NUROB_EDC, ");
		sqlStr.append("NUROB_DR, NUROB_CLINIC, ");
		sqlStr.append("NUROB_ALLERGY, NUROB_CARDIAC, ");
		sqlStr.append("NUROB_DIABETES, NUROB_DM, ");
		sqlStr.append("NUROB_GDM, NUROB_IGT, ");
		sqlStr.append("NUROB_ANEMIA, NUROB_RENAL, ");
		sqlStr.append("NUROB_LIVER, NUROB_RESP, ");
		sqlStr.append("NUROB_GI, NUROB_EPILEPSY, ");
		sqlStr.append("NUROB_PSYCHIATRIC, NUROB_IMMUN, ");
		sqlStr.append("NUROB_THYROID, NUROB_SURG, ");
		sqlStr.append("NUROB_MULTI, NUROB_PREVIOUS, ");
		sqlStr.append("NUROB_HYPER, NUROB_APH, ");
		sqlStr.append("NUROB_PRETERM, NUROB_BADOB, ");
		sqlStr.append("NUROB_IUGR, NUROB_FETAL, ");
		sqlStr.append("NUROB_ROUTINE, NUROB_INDUCT, ");
		sqlStr.append("NUROB_ELECTIVE, NUROB_CURRMED, ");
		sqlStr.append("NUROB_ROOM, NUROB_CORD, ");
		sqlStr.append("NUROB_TRIALLABOR, NUROB_TRIALSCAR, ");
		sqlStr.append("NUROB_FLEET, NUROB_SHAVING, ");
		sqlStr.append("NUROB_PAIN, NUROB_NOTIFY, ");
		sqlStr.append("NUROB_ANYTIME, NUROB_AFTER06, ");
		sqlStr.append("NUROB_NPO, NUROB_HEP, ");
		sqlStr.append("NUROB_PPS, NUROB_POST, ");
		sqlStr.append("NUROB_CS, NUROB_CSBTL, ");
		sqlStr.append("NUROB_CSDATE, ");
		sqlStr.append("NUROB_GA, NUROB_SA, ");
		sqlStr.append("NUROB_INDICATION, NUROB_ABDOMINAL, ");
		sqlStr.append("NUROB_PUBLIC, NUROB_ANESDR, ");
		sqlStr.append("NUROB_PREMED, NUROB_PEDDR, ");
		sqlStr.append("NUROB_FEED, NUROB_OTHER, ");
		sqlStr.append("NUROB_INDICATION_TEXT, NUROB_PAIN_PETH, NUROB_CSSELTIME, ");
		sqlStr.append("NUROB_CREATED_USER, NUROB_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, to_date(?, 'dd/MM/yyyy'), ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ");
		sqlStr.append("to_date(?, 'dd/MM/yyyy'), ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ");
		sqlStr.append("?, ?, ?, ");
		sqlStr.append("?, ?) ");
		sqlStr_insertNurobAdmltr = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE NUROB_ADMLTR ");
		sqlStr.append("SET ");
		sqlStr.append("  NUROB_PATIENT = ?, NUROB_AGE = ?, ");
		sqlStr.append("  NUROB_TELNO = ?, NUROB_BOOKNO = ?, ");
		sqlStr.append("  NUROB_STATUS = ?, NUROB_GRAVIDA = ?, ");
		sqlStr.append("  NUROB_PARA = ?, NUROB_EDC = to_date(?, 'dd/MM/yyyy'), ");
		sqlStr.append("  NUROB_DR = ?, NUROB_CLINIC = ?, ");
		sqlStr.append("  NUROB_ALLERGY = ?, NUROB_CARDIAC = ?, ");
		sqlStr.append("  NUROB_DIABETES = ?, NUROB_DM = ?, ");
		sqlStr.append("  NUROB_GDM = ?, NUROB_IGT = ?, ");
		sqlStr.append("  NUROB_ANEMIA = ?, NUROB_RENAL = ?, ");
		sqlStr.append("  NUROB_LIVER = ?, NUROB_RESP = ?, ");
		sqlStr.append("  NUROB_GI = ?, NUROB_EPILEPSY = ?, ");
		sqlStr.append("  NUROB_PSYCHIATRIC = ?, NUROB_IMMUN = ?, ");
		sqlStr.append("  NUROB_THYROID = ?, NUROB_SURG = ?, ");
		sqlStr.append("  NUROB_MULTI = ?, NUROB_PREVIOUS = ?, ");
		sqlStr.append("  NUROB_HYPER = ?, NUROB_APH = ?, ");
		sqlStr.append("  NUROB_PRETERM = ?, NUROB_BADOB = ?, ");
		sqlStr.append("  NUROB_IUGR = ?, NUROB_FETAL = ?, ");
		sqlStr.append("  NUROB_ROUTINE = ?, NUROB_INDUCT = ?, ");
		sqlStr.append("  NUROB_ELECTIVE = ?, NUROB_CURRMED = ?, ");
		sqlStr.append("  NUROB_ROOM = ?, NUROB_CORD = ?, ");
		sqlStr.append("  NUROB_TRIALLABOR = ?, NUROB_TRIALSCAR = ?, ");
		sqlStr.append("  NUROB_FLEET = ?, NUROB_SHAVING = ?, ");
		sqlStr.append("  NUROB_PAIN = ?, NUROB_PAIN_PETH = ?, ");
		sqlStr.append("  NUROB_NOTIFY = ?, ");
		sqlStr.append("  NUROB_ANYTIME = ?, NUROB_AFTER06 = ?, ");
		sqlStr.append("  NUROB_NPO = ?, NUROB_HEP = ?, ");
		sqlStr.append("  NUROB_PPS = ?, NUROB_POST = ?, ");
		sqlStr.append("  NUROB_CS = ?, NUROB_CSBTL = ?, ");
		sqlStr.append("  NUROB_CSDATE = to_date(?, 'dd/MM/yyyy'), NUROB_CSSELTIME = ?, ");
		sqlStr.append("  NUROB_GA = ?, NUROB_SA = ?, ");
		sqlStr.append("  NUROB_INDICATION = ?, NUROB_INDICATION_TEXT = ?, ");
		sqlStr.append("  NUROB_ABDOMINAL = ?, ");
		sqlStr.append("  NUROB_PUBLIC = ?, NUROB_ANESDR = ?, ");
		sqlStr.append("  NUROB_PREMED = ?, NUROB_PEDDR = ?, ");
		sqlStr.append("  NUROB_FEED = ?, NUROB_OTHER = ?, ");
		sqlStr.append("  NUROB_MODIFIED_DATE = SYSDATE, NUROB_MODIFIED_USER = ? ");		
		sqlStr.append("WHERE");
		sqlStr.append("  NUROB_SITE_CODE = ?");
		sqlStr.append("  AND NUROB_ADMLTR_ID = TO_NUMBER(?)");
		sqlStr.append("  AND NUROB_ENABLED = 1");
		sqlStr_updateNurobAdmltr = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE NUROB_ADMLTR ");
		sqlStr.append("SET    NUROB_ENABLED = 0, NUROB_MODIFIED_DATE = SYSDATE, NUROB_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  NUROB_SITE_CODE = ? ");
		sqlStr.append("AND    NUROB_ADMLTR_ID = ? ");
		sqlStr.append("AND    NUROB_ENABLED = 1 ");
		sqlStr_deleteNurobAdmltr = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT ");
		sqlStr.append("  NUROB_ADMLTR_ID, ");
		sqlStr.append("  NUROB_PATIENT, NUROB_AGE, ");
		sqlStr.append("  NUROB_TELNO, NUROB_BOOKNO, ");
		sqlStr.append("  NUROB_STATUS, NUROB_GRAVIDA, ");
		sqlStr.append("  NUROB_PARA, to_char(NUROB_EDC, 'dd/MM/yyyy'), ");
		sqlStr.append("  NUROB_DR, NUROB_CLINIC, ");
		sqlStr.append("  NUROB_ALLERGY, NUROB_CARDIAC, ");
		sqlStr.append("  NUROB_DIABETES, NUROB_DM, ");
		sqlStr.append("  NUROB_GDM, NUROB_IGT, ");
		sqlStr.append("  NUROB_ANEMIA, NUROB_RENAL, ");
		sqlStr.append("  NUROB_LIVER, NUROB_RESP, ");
		sqlStr.append("  NUROB_GI, NUROB_EPILEPSY, ");
		sqlStr.append("  NUROB_PSYCHIATRIC, NUROB_IMMUN, ");
		sqlStr.append("  NUROB_THYROID, NUROB_SURG, ");
		sqlStr.append("  NUROB_MULTI, NUROB_PREVIOUS, ");
		sqlStr.append("  NUROB_HYPER, NUROB_APH, ");
		sqlStr.append("  NUROB_PRETERM, NUROB_BADOB, ");
		sqlStr.append("  NUROB_IUGR, NUROB_FETAL, ");
		sqlStr.append("  NUROB_ROUTINE, NUROB_INDUCT, ");
		sqlStr.append("  NUROB_ELECTIVE, NUROB_CURRMED, ");
		sqlStr.append("  NUROB_ROOM, NUROB_CORD, ");
		sqlStr.append("  NUROB_TRIALLABOR, NUROB_TRIALSCAR, ");
		sqlStr.append("  NUROB_FLEET, NUROB_SHAVING, ");
		sqlStr.append("  NUROB_PAIN, NUROB_PAIN_PETH, ");
		sqlStr.append("  NUROB_NOTIFY, ");
		sqlStr.append("  NUROB_ANYTIME, NUROB_AFTER06, ");
		sqlStr.append("  NUROB_NPO, NUROB_HEP, ");
		sqlStr.append("  NUROB_PPS, NUROB_POST, ");
		sqlStr.append("  NUROB_CS, NUROB_CSBTL, ");
		sqlStr.append("  to_char(NUROB_CSDATE, 'dd/MM/yyyy'), NUROB_CSSELTIME, ");
		sqlStr.append("  NUROB_GA, NUROB_SA, ");
		sqlStr.append("  NUROB_INDICATION, NUROB_INDICATION_TEXT, ");
		sqlStr.append("  NUROB_ABDOMINAL, ");
		sqlStr.append("  NUROB_PUBLIC, NUROB_ANESDR, ");
		sqlStr.append("  NUROB_PREMED, NUROB_PEDDR, ");
		sqlStr.append("  NUROB_FEED, NUROB_OTHER, ");
		sqlStr.append("  NUROB_CREATED_DATE, NUROB_MODIFIED_USER, ");
		sqlStr.append("  NUROB_MODIFIED_DATE, NUROB_MODIFIED_USER ");
		sqlStr.append("FROM   NUROB_ADMLTR ");
		sqlStr.append("WHERE  NUROB_ENABLED = 1 ");
		sqlStr.append("  AND    NUROB_SITE_CODE = ? ");
		sqlStr.append("	 AND    NUROB_ADMLTR_ID = ? ");
		sqlStr_getNurobAdmltr = sqlStr.toString();
	}
}