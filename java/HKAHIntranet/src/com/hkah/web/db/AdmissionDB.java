package com.hkah.web.db;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.ArrayList;

import javax.servlet.http.HttpServletResponse;

import com.hkah.config.MessageResources;
import com.hkah.constant.ConstantsErrorMessage;
import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.TextUtil;
import com.hkah.util.convert.FileConvertor;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class AdmissionDB {

	private static String sqlStr_insertAdmission = null;
	private static String sqlStr_insertOutAdmission = null;
	private static String sqlStr_updateAdmission = null;
	private static String sqlStr_updateOutAdmission = null;
	private static String sqlStr_updateAdmissionPatNo = null;
	private static String sqlStr_updateAdmissionSessionID = null;
	private static String sqlStr_cancelAdmission = null;
	private static String sqlStr_getAdmission = null;
	private static String sqlStr_getImtInfo = null;
	private static String sqlStr_updateHasImtInfo = null;
	private static String sqlStr_emailNotification = null;

	private static String sqlStr_insertDocumentAction = null;

	private static String sqlStr_insertImtInfo = null;

	private static String getNextAdmissionID() {
		String admissionID = null;

		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(HAT_ADMNO) + 1 FROM HAT_PATIENT");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			admissionID = reportableListObject.getValue(0);

			// set 1 for initial
			if (admissionID == null || admissionID.length() == 0) return "1";
		}
		return admissionID;
	}

	private static String getNextDocumentID(String admissionID) {
		String documentID = null;

		// get next document id from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(HAT_DOCUMENT_ID) + 1 FROM HAT_PATIENT_DOCUMENTS WHERE HAT_ADMNO = ?",
				new String[] { admissionID });
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			documentID = reportableListObject.getValue(0);

			// set 1 for initial
			if (documentID == null || documentID.length() == 0) return "1";
		}
		return documentID;
	}

	public static String add(UserBean userBean) {
		String admissionID = getNextAdmissionID();

		// determine login id
		String loginID = null;
		if (userBean.isLogin()) {
			loginID = userBean.getLoginID();
		} else {
			loginID = "guest";
		}

		// insert eAdmission record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertAdmission,
				new String[] { admissionID,
						loginID, loginID })) {

			return admissionID;
		} else {
			return null;
		}
	}

	public static String addOutPatient(UserBean userBean) {
		String admissionID = getNextAdmissionID();

		// determine login id
		String loginID = null;
		if (userBean.isLogin()) {
			loginID = userBean.getLoginID();
		} else {
			loginID = "guest";
		}
		// insert eAdmission record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertOutAdmission,
				new String[] { admissionID,
						loginID, loginID })) {

			return admissionID;
		} else {
			return null;
		}
	}

	public static boolean addunselectImpInfo(UserBean userBean,String docID, String admID) {
		if (UtilDBWeb.updateQueue(
				sqlStr_insertImtInfo,
				new String[] {admID, docID, userBean.getLoginID(),userBean.getLoginID()}   )) {
			return true;
		} else {
			return false;
		}
	}

	public static ArrayList getHATSRoomBedInfo(String patNo,String admDate) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select BEDCODE, ACMCODE ");
		sqlStr.append(" FROM bedprebok@iweb ");
		sqlStr.append(" where patno='"+patNo+"' ");
		sqlStr.append(" and trim(bpbhdate) = to_date('"+admDate+"','dd/mm/yyyy') ");
		sqlStr.append(" and bpbsts != 'D' ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getHATSRoomBedInfoInDateRange(String dateFrom, String dateTo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select patno,to_char(bpbhdate,'dd/mm/yyyy'),BEDCODE,ACMCODE ");
		sqlStr.append(" FROM bedprebok@iweb ");
		sqlStr.append(" where bpbsts != 'D' ");
		if (dateFrom != null && dateFrom.length() > 0) {
			sqlStr.append("AND    bpbhdate >= TO_DATE('");
			sqlStr.append(dateFrom);
			sqlStr.append(" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		}
		if (dateTo != null && dateTo.length() > 0) {
			sqlStr.append("AND    bpbhdate <= TO_DATE('");
			sqlStr.append(dateTo);
			sqlStr.append(" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
		}
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static boolean updatePatientBedNoOrACM(UserBean userBean,String bedNo, String ACM,String admissionID,String patNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE HAT_PATIENT ");
		sqlStr.append("SET       HAT_MODIFIED_USER = ?, ");
		if (!"".equals(ACM)&& ACM != null) {
			sqlStr.append(" HAT_ACTUAL_ROOM_TYPE = '"+ACM+"', ");
		}
		if (!"".equals(bedNo)&& bedNo != null) {
			sqlStr.append(" HAT_BED_NO = '"+bedNo+"', ");
		}
		sqlStr.append(" HAT_MODIFIED_DATE = SYSDATE ");
		sqlStr.append("WHERE  HAT_ADMNO = ? AND HAT_ENABLED = 1 AND HAT_PATNO = ? ");

		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {userBean.getLoginID(),admissionID,patNo} )) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean updateHATFirstUserDate(UserBean userBean,String admissionID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE HAT_PATIENT ");
		sqlStr.append("SET       HAT_FIRSTVIEW_USER = ?, ");
		sqlStr.append(" HAT_FIRSTVIEW_DATE = SYSDATE ");
		sqlStr.append("WHERE  HAT_ADMNO = ? AND HAT_ENABLED = 1");

		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {userBean.getLoginID(),admissionID} )) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean updateHasImtInfo(String admissionID) {
		return UtilDBWeb.updateQueue(
				sqlStr_updateHasImtInfo,
				new String[] {admissionID} );
	}

	public static boolean update(
			UserBean userBean, String admissionID, String patno,
			String patfname, String patgname, String patcname, String titleDesc, String titleDescOther,
			String patidno, String patpassport, String passdocument,
			String patsex, String racedesc, String racedescOther, String religion, String religionOther,
			String patbdate, String patmsts, String patmstsOther, String mothcode, String mothcodeOther, String edulevel,
			String pathtel, String patotel, String patmtel, String patftel,
			String occupation, String patemail,
			String patadd1, String patadd2, String patadd3, String pataddd, String coucode,
			String patkfname1, String patkgname1, String patkcname1, String patksex1, String patkrela1,
			String patkhtel1, String patkotel1, String patkmtel1, String patkptel1,
			String patkemail1, String patkadd11, String patkadd21, String patkadd31, String patkaddd1,
			String patkfname2, String patkgname2, String patkcname2, String patksex2, String patkrela2,
			String patkhtel2, String patkotel2, String patkmtel2, String patkptel2,
			String patkemail2, String patkadd12, String patkadd22, String patkadd32, String patkaddd2,
			String expectedAdmissionDate, String actualAdmissionDate,
			String admissiondoctor, String ward, String roomType, String bedNo, String promotionYN,
			String paymentType, String paymentTypeOther, String creditCardType, String insuranceRemarks, String insurancePolicyNo,
			String remarks, String sessionKey, String registered, String reached, String infoForPromotion) {

		return update(
				 userBean,  admissionID,  patno,
				 patfname,  patgname,  patcname,  titleDesc,  titleDescOther,
				 patidno,  patpassport,  passdocument,
				 patsex,  racedesc,  racedescOther,  religion,  religionOther,
				 patbdate,  patmsts,  patmstsOther,  mothcode,  mothcodeOther,  edulevel,
				 pathtel,  patotel,  patmtel,  patftel,
				 occupation,  patemail,
				 patadd1,  patadd2,  patadd3,  pataddd,  coucode,
				 patkfname1,  patkgname1,  patkcname1,  patksex1,  patkrela1,
				 patkhtel1,  patkotel1,  patkmtel1,  patkptel1,
				 patkemail1,  patkadd11,  patkadd21,  patkadd31,  patkaddd1,
				 patkfname2,  patkgname2,  patkcname2,  patksex2,  patkrela2,
				 patkhtel2,  patkotel2,  patkmtel2,  patkptel2,
				 patkemail2,  patkadd12,  patkadd22,  patkadd32,  patkaddd2,
				 expectedAdmissionDate,  actualAdmissionDate,
				 admissiondoctor,  ward,  roomType,  bedNo,  promotionYN,
				 paymentType,  paymentTypeOther,  creditCardType,  insuranceRemarks,  insurancePolicyNo,
				 remarks,  sessionKey,  registered,  reached,  infoForPromotion,"");

	}

	public static boolean update(
			UserBean userBean, String admissionID, String patno,
			String patfname, String patgname, String patcname, String titleDesc, String titleDescOther,
			String patidno, String patpassport, String passdocument,
			String patsex, String racedesc, String racedescOther, String religion, String religionOther,
			String patbdate, String patmsts, String patmstsOther, String mothcode, String mothcodeOther, String edulevel,
			String pathtel, String patotel, String patmtel, String patftel,
			String occupation, String patemail,
			String patadd1, String patadd2, String patadd3, String pataddd, String coucode,
			String patkfname1, String patkgname1, String patkcname1, String patksex1, String patkrela1,
			String patkhtel1, String patkotel1, String patkmtel1, String patkptel1,
			String patkemail1, String patkadd11, String patkadd21, String patkadd31, String patkaddd1,
			String patkfname2, String patkgname2, String patkcname2, String patksex2, String patkrela2,
			String patkhtel2, String patkotel2, String patkmtel2, String patkptel2,
			String patkemail2, String patkadd12, String patkadd22, String patkadd32, String patkaddd2,
			String expectedAdmissionDate, String actualAdmissionDate,
			String admissiondoctor, String ward, String roomType, String bedNo, String promotionYN,
			String paymentType, String paymentTypeOther, String creditCardType, String insuranceRemarks, String insurancePolicyNo,
			String remarks, String sessionKey, String registered, String reached, String infoForPromotion,String mktSrc) {

		String coudesc = getCountryDesc(coucode);

		if (UtilDBWeb.updateQueue(
				sqlStr_updateAdmission,
				new String[] { patno,
						patfname, patgname, patcname, titleDesc, titleDescOther,
						patidno, patpassport, passdocument,
						patsex, racedesc, racedescOther, religion, religionOther,
						patbdate, patmsts, patmstsOther, mothcode, mothcodeOther, edulevel,
						pathtel, patotel, patmtel, patftel,
						occupation, patemail,
						patadd1, patadd2, patadd3, pataddd, coucode, coudesc,
						patkfname1, patkgname1, patkcname1, patksex1, patkrela1,
						patkhtel1, patkotel1, patkmtel1, patkptel1,
						patkemail1, patkadd11, patkadd21, patkadd31, patkaddd1,
						patkfname2, patkgname2, patkcname2, patksex2, patkrela2,
						patkhtel2, patkotel2, patkmtel2, patkptel2,
						patkemail2, patkadd12, patkadd22, patkadd32, patkaddd2,
						expectedAdmissionDate, actualAdmissionDate,
						admissiondoctor, ward, roomType, bedNo, promotionYN,
						paymentType, paymentTypeOther, creditCardType, insuranceRemarks, insurancePolicyNo,
						remarks, registered, reached,
						userBean.getLoginID(), infoForPromotion ,mktSrc, admissionID})) {
			if (sessionKey != null && sessionKey.length() > 0) {
				return UtilDBWeb.updateQueue(
						sqlStr_updateAdmissionSessionID,
						new String[] { sessionKey, admissionID} );
			} else {
				return true;
			}
		} else {
			return false;
		}
	}

	public static boolean updateOutPatient(UserBean userBean,
			String admissionID, String patno, String patfname, String patgname,
			String patcname, String titleDesc, String titleDescOther,
			String patidno, String patpassport, String pattraveldoc,
			String patsex, String racedesc, String racedescOther,
			String religion, String religionOther, String patbdate,
			String patmsts, String patmstsOther, String mothcode,
			String edulevel, String edulevelOther, String pathtel,
			String patotel, String patmtel, String patftel, String occupation,
			String patemail, String patadd1, String patadd2, String patadd3,
			String patadd4, String coucode, String patkfname1,
			String patkgname1, String patkcname1, String patkrela1,
			String patkhtel1, String patkotel1, String patkmtel1,
			String patkemail1, String patkadd11, String patkadd21,
			String patkadd31, String patkadd41, String patkTitleDesc1,
			String patkTitleDescOther1, String patkcoucode1, String patkfname2,
			String patkgname2, String patkcname2, String patkrela2,
			String patkhtel2, String patkotel2, String patkmtel2,
			String patkemail2, String patkadd12, String patkadd22,
			String patkadd32, String patkadd42, String patkTitleDesc2,
			String patkTitleDescOther2, String patkcoucode2,
			String promotionYN, String remarks, String sessionKey, String registered,
			String reached, String newExpectedAdmissionDate, String newActualAdmissionDate, String attendDoctor,
			String patHowInfo, String patHowInfoOther) {

		String coudesc = getCountryDesc(coucode);
		String patkcoudesc1 = getCountryDesc(patkcoucode1);
		String patkcoudesc2 = getCountryDesc(patkcoucode2);
		if (UtilDBWeb.updateQueue(
				sqlStr_updateOutAdmission,
				new String[] {   patno,  patfname,  patgname,
						 patcname,  titleDesc,  titleDescOther,
						 patidno,  patpassport,  pattraveldoc,
						 patsex,  racedesc,  racedescOther,
						 religion,  religionOther,  patbdate,
						 patmsts,  patmstsOther,  mothcode,
						 edulevel,  edulevelOther,  pathtel,
						 patotel,  patmtel,  patftel,  occupation,
						 patemail,  patadd1,  patadd2,  patadd3,
						 patadd4,  coucode,  coudesc,  patkfname1,
						 patkgname1,  patkcname1,  patkrela1,
						 patkhtel1,  patkotel1,  patkmtel1,
						 patkemail1,  patkadd11,  patkadd21,
						 patkadd31,  patkadd41,  patkTitleDesc1,
						 patkTitleDescOther1,  patkcoucode1,  patkfname2,
						 patkgname2,  patkcname2,  patkrela2,
						 patkhtel2,  patkotel2,  patkmtel2,
						 patkemail2,  patkadd12,  patkadd22,
						 patkadd32,  patkadd42,  patkTitleDesc2,
						 patkTitleDescOther2,  patkcoucode2,
						 promotionYN, remarks,patkcoudesc1,patkcoudesc2, registered, reached,
						userBean.getLoginID(),newExpectedAdmissionDate, newActualAdmissionDate, attendDoctor,
						patHowInfo, patHowInfoOther, admissionID})) {
			if (sessionKey != null && sessionKey.length() > 0) {
				return UtilDBWeb.updateQueue(
						sqlStr_updateAdmissionSessionID,
						new String[] { sessionKey, admissionID} );
			} else {
				return true;
			}
		} else {
			return false;
		}
	}

	public static boolean updatePatNo(
			UserBean userBean, String patno, String admissionID) {
		return UtilDBWeb.updateQueue(
				sqlStr_updateAdmissionPatNo,
				new String[] { patno,
						userBean.getLoginID(), admissionID} );
	}

	public static boolean delete(
			UserBean userBean, String admissionID) {
		return UtilDBWeb.updateQueue(
				sqlStr_cancelAdmission,
				new String[] { userBean.getLoginID(), admissionID } );
	}

	public static String getDocName(String docCode) {

		String docName= null;
		ArrayList result = UtilDBWeb.getReportableList(
				" SELECT DOCFNAME || ' ' || DOCGNAME FROM DOCTOR@IWEB WHERE DOCCODE ='"+docCode+"' ");

		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			docName = reportableListObject.getValue(0);
		} else {
			docName = null;
		}
		return docName;
	}

//20181203 Arran added to get dr name with Chinese name
	public static String getDocFullName(String docCode) {

		String docName= null;
		ArrayList result = UtilDBWeb.getReportableList(
				" SELECT DOCFNAME || ' ' || DOCGNAME || ' ' || DOCCNAME FROM DOCTOR@IWEB WHERE DOCCODE ='"+docCode+"' ");

		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			docName = reportableListObject.getValue(0);
		} else {
			docName = null;
		}
		return docName;
	}

	public static ArrayList getUnselectedImtInfo(String admissionID) {
		return UtilDBWeb.getReportableList(sqlStr_getImtInfo,new String[]{admissionID});
	}

	public static ArrayList get(String admissionID) {
		return UtilDBWeb.getReportableList(sqlStr_getAdmission, new String[] { admissionID });
	}

	public static ArrayList getList(String dateFrom, String dateTo, String ward, String sortBy,
								String ordering, boolean pdf) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.setLength(0);
		sqlStr.append("SELECT hp.HAT_ADMNO, ");
		sqlStr.append("       hp.HAT_PATNO, hp.HAT_PATFNAME, hp.HAT_PATGNAME, hp.HAT_PATCNAME, hp.HAT_TITDESC, hp.HAT_TITDESC_OTHER, ");
		sqlStr.append("       hp.HAT_PATIDNO, hp.HAT_PATPASSPORT, hp.HAT_DOCUMENT, ");
		sqlStr.append("       hp.HAT_PATSEX, hp.HAT_RACDESC, hp.HAT_RACDESC_OTHER, hp.HAT_RELIGIOUS, hp.HAT_RELIGIOUS_OTHER, ");
		sqlStr.append("       TO_CHAR(hp.HAT_PATBDATE, 'dd/MM/YYYY'), hp.HAT_PATMSTS, hp.HAT_MOTHCODE, hp.HAT_MOTHCODE_OTHER, hp.HAT_EDULEVEL, ");
		sqlStr.append("       hp.HAT_PATHTEL, hp.HAT_PATOTEL, hp.HAT_PATMTEL, hp.HAT_PATFAXNO, ");
		sqlStr.append("       hp.HAT_OCCUPATION, hp.HAT_PATEMAIL, ");
		sqlStr.append("       hp.HAT_PATADD1, hp.HAT_PATADD2, hp.HAT_PATADD3, hp.HAT_PATADD4, hp.HAT_COUCODE, hp.HAT_COUDESC, ");
		sqlStr.append("       hp.HAT_PATKFNAME1, hp.HAT_PATKGNAME1, hp.HAT_PATKCNAME1, hp.HAT_PATKSEX1, hp.HAT_PATKRELA1, ");
		sqlStr.append("       hp.HAT_PATKHTEL1, hp.HAT_PATKOTEL1, hp.HAT_PATKMTEL1, hp.HAT_PATKPAGER1, ");
		sqlStr.append("       hp.HAT_PATKEMAIL1, hp.HAT_PATKADD11, hp.HAT_PATKADD21, hp.HAT_PATKADD31, hp.HAT_PATKADD41, ");
		sqlStr.append("       hp.HAT_PATKFNAME2, hp.HAT_PATKGNAME2, hp.HAT_PATKCNAME2, hp.HAT_PATKSEX2, hp.HAT_PATKRELA2, ");
		sqlStr.append("       hp.HAT_PATKHTEL2, hp.HAT_PATKOTEL2, hp.HAT_PATKMTEL2, hp.HAT_PATKPAGER2, ");
		sqlStr.append("       hp.HAT_PATKEMAIL2, hp.HAT_PATKADD12, hp.HAT_PATKADD22, hp.HAT_PATKADD32, hp.HAT_PATKADD42, ");
		sqlStr.append("       TO_CHAR(hp.HAT_EXPECTED_ADMISSION_DATE, 'dd/MM/YYYY'), TO_CHAR(hp.HAT_EXPECTED_ADMISSION_DATE, 'HH24:MI'), ");
		sqlStr.append("       TO_CHAR(hp.HAT_ACTUAL_ADMISSION_DATE, 'dd/MM/YYYY'), TO_CHAR(hp.HAT_ACTUAL_ADMISSION_DATE, 'HH24:MI'), ");
		sqlStr.append("       hp.HAT_ADMISSION_DOCTOR, hp.HAT_WARD, hp.HAT_ROOM_TYPE, hp.HAT_BED_NO, hp.HAT_PROMOTION_YN, ");
		sqlStr.append("       hp.HAT_PAYMENT_TYPE, hp.HAT_PAYMENT_TYPE_OTHER, hp.HAT_PAYMENT_CREDIT_CARD_TYPE, hp.HAT_INSURANCE_REMARKS, hp.HAT_INSURANCE_POLICY_NO, ");
		sqlStr.append("       hp.HAT_EMAIL_CONFIRM_YN, TO_CHAR(hp.HAT_EMAIL_CONFIRM_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       hp.HAT_REMARKS, hp.HAT_SESSION_ID, ");
		sqlStr.append("       TO_CHAR(hp.HAT_CREATED_DATE, 'dd/MM/YYYY HH24:MI:SS'), hp.HAT_CREATED_USER, ");
		sqlStr.append("       TO_CHAR(hp.HAT_MODIFIED_DATE, 'dd/MM/YYYY HH24:MI:SS'), hp.HAT_MODIFIED_USER, ");
		sqlStr.append("       hp.HAT_HASIMTINFO,decode(dc.countDoc,null,0,1) as countDoc, hp.HAT_ACTUAL_ROOM_TYPE, DECODE(flw.PATNO, null, '', 'Phone'), ");
		sqlStr.append("       DECODE(hp.HAT_SESSION_ID, null, DECODE(hp.HAT_CREATED_USER, 'SYSTEM', 'System ('||DECODE(flw.PATNO, null, '', 'Phone')||')', 'Web'), 'Email') AS CreatedBy, ");
		//sqlStr.append("       hp.HAT_REMARKS, hp.HAT_SESSION_ID ");
		sqlStr.append("       hp.HAT_REMARKS, hp.HAT_SESSION_ID, hp.HAT_PAYMENT_STATUS, hp.HAT_PAYMENT_RTNCODE, hp.HAT_PAYMENT_RECEIPT_NO, hp.HAT_PAYMENT_AMOUNT ");
		sqlStr.append("FROM   ");
		sqlStr.append("HAT_PATIENT hp left outer join (");
		sqlStr.append("SELECT B.PATNO, B.BPBHDATE ");
		sqlStr.append("FROM FLW_UP_HIST f1, BEDPREBOK@IWEB B ");
		sqlStr.append("WHERE f1.update_date in ");
		sqlStr.append("		(SELECT MAX(f2.update_date) ");
		sqlStr.append("		FROM FLW_UP_HIST f2 ");
		sqlStr.append("		WHERE f1.pbpid = f2.pbpid ");
		sqlStr.append("		AND f2.FLW_UP_TYPE = 'INPATPB' ");
		sqlStr.append("		GROUP BY f2.pbpid) ");
		sqlStr.append("AND f1.FLW_UP_TYPE = 'INPATPB' ");
		sqlStr.append("AND f1.FLW_UP_STATUS = '8' ");
		sqlStr.append("AND f1.PBPID = B.PBPID) flw on flw.PATNO = hp.HAT_PATNO ");
		sqlStr.append("AND TO_CHAR(flw.BPBHDATE, 'DD/MM/YYYY') = TO_CHAR(hp.HAT_EXPECTED_ADMISSION_DATE, 'dd/MM/YYYY') ");
		sqlStr.append("left outer join (select hat_admno,count(1)as countDoc from hat_patient_documents GROUP BY hat_admno) dc on ");
		sqlStr.append("dc.hat_admno = hp.hat_admno ");

		sqlStr.append("WHERE  HAT_ENABLED = 1 ");
		//sqlStr.append("AND dc.hat_admno(+) = hp.hat_admno ");
		if (dateFrom != null && dateFrom.length() > 0) {
			sqlStr.append("AND    HAT_EXPECTED_ADMISSION_DATE >= TO_DATE('");
			sqlStr.append(dateFrom);
			sqlStr.append(" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		}
		if (dateTo != null && dateTo.length() > 0) {
			sqlStr.append("AND    HAT_EXPECTED_ADMISSION_DATE <= TO_DATE('");
			sqlStr.append(dateTo);
			sqlStr.append(" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
		}
		if (ward != null && ward.length() > 0) {
			sqlStr.append("AND    HAT_WARD = '");
			sqlStr.append(ward);
			sqlStr.append("' ");
		}
		//sqlStr.append("AND flw.PATNO(+) = hp.HAT_PATNO ");
		//sqlStr.append("AND TO_CHAR(flw.BPBHDATE, 'DD/MM/YYYY') = TO_CHAR(hp.HAT_EXPECTED_ADMISSION_DATE, 'dd/MM/YYYY') ");
		sqlStr.append("AND HAT_ADMISSION_TYPE = 'I' ");
		sqlStr.append("ORDER BY ");

		if (pdf) {
			sqlStr.append("CreatedBy ASC, ");
		}

		if (ConstantsVariable.ZERO_VALUE.equals(sortBy)) {
			// Admission Date
			sqlStr.append("HAT_EXPECTED_ADMISSION_DATE");
		} else if (ConstantsVariable.ONE_VALUE.equals(sortBy)) {
			// Patient Name
			sqlStr.append("HAT_PATFNAME");
		} else if (ConstantsVariable.TWO_VALUE.equals(sortBy)) {
			// Patient Number
			sqlStr.append("HAT_PATNO");
		} else if (ConstantsVariable.THREE_VALUE.equals(sortBy)) {
			// Created Date
			sqlStr.append("HAT_CREATED_DATE");
		}	else if (ConstantsVariable.FOUR_VALUE.equals(sortBy)) {
				// Payment Method
				sqlStr.append("HAT_PAYMENT_TYPE");
		}	else if (ConstantsVariable.FIVE_VALUE.equals(sortBy)) {
			// Date of Birth
			sqlStr.append("HAT_PATBDATE");
		}	else if (ConstantsVariable.SIX_VALUE.equals(sortBy)) {
			// Room Type
			sqlStr.append("HAT_ROOM_TYPE");
		}	else if (ConstantsVariable.SEVEN_VALUE.equals(sortBy)) {
			// Ward
			sqlStr.append("HAT_WARD");
		} else if (ConstantsVariable.EIGHT_VALUE.equals(sortBy)) {
			// Ward
			sqlStr.append("hp.HAT_SESSION_ID");
		} else if (ConstantsVariable.NINE_VALUE.equals(sortBy)) {
			// Follow Up
			sqlStr.append("flw.PATNO");
		} else {
			sqlStr.append("HAT_MODIFIED_DATE");
		}

		if (ordering != null) {
			sqlStr.append(ConstantsVariable.SPACE_VALUE);
			sqlStr.append(ordering);
		} else {
			sqlStr.append(ConstantsVariable.SPACE_VALUE);
			sqlStr.append(" DESC");
		}

		sqlStr.append(", HAT_ADMNO DESC");
		// debug SQL command not properly ended 04/04/2015
		System.out.println("AdmissionDB getList=" + sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getOutPatientList(String dateFrom, String dateTo, String ward, String sortBy,
									String ordering, boolean pdf,String patientType, String patientStatus) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.setLength(0);
		sqlStr.append("SELECT hp.HAT_ADMNO, ");//0
		sqlStr.append("       hp.HAT_PATNO, hp.HAT_PATFNAME, hp.HAT_PATGNAME, hp.HAT_PATCNAME, hp.HAT_TITDESC, hp.HAT_TITDESC_OTHER, ");//1-6
		sqlStr.append("       hp.HAT_PATIDNO, hp.HAT_PATPASSPORT, hp.HAT_DOCUMENT, ");//7-9
		sqlStr.append("       hp.HAT_PATSEX, hp.HAT_RACDESC, hp.HAT_RACDESC_OTHER, hp.HAT_RELIGIOUS, hp.HAT_RELIGIOUS_OTHER, ");//10-14
		sqlStr.append("       TO_CHAR(hp.HAT_PATBDATE, 'dd/MM/YYYY'), hp.HAT_PATMSTS, hp.HAT_MOTHCODE, hp.HAT_MOTHCODE_OTHER, hp.HAT_EDULEVEL, ");//15-19
		sqlStr.append("       hp.HAT_PATHTEL, hp.HAT_PATOTEL, hp.HAT_PATMTEL, hp.HAT_PATFAXNO, ");//20-23
		sqlStr.append("       hp.HAT_OCCUPATION, hp.HAT_PATEMAIL, ");//24-25
		sqlStr.append("       hp.HAT_PATADD1, hp.HAT_PATADD2, hp.HAT_PATADD3, hp.HAT_PATADD4, hp.HAT_COUCODE, hp.HAT_COUDESC, ");//26-31
		sqlStr.append("       hp.HAT_PATKFNAME1, hp.HAT_PATKGNAME1, hp.HAT_PATKCNAME1, hp.HAT_PATKSEX1, hp.HAT_PATKRELA1, ");//32-36
		sqlStr.append("       hp.HAT_PATKHTEL1, hp.HAT_PATKOTEL1, hp.HAT_PATKMTEL1, hp.HAT_PATKPAGER1, ");//37-40
		sqlStr.append("       hp.HAT_PATKEMAIL1, hp.HAT_PATKADD11, hp.HAT_PATKADD21, hp.HAT_PATKADD31, hp.HAT_PATKADD41, ");//41-45
		sqlStr.append("       hp.HAT_PATKFNAME2, hp.HAT_PATKGNAME2, hp.HAT_PATKCNAME2, hp.HAT_PATKSEX2, hp.HAT_PATKRELA2, ");//46-50
		sqlStr.append("       hp.HAT_PATKHTEL2, hp.HAT_PATKOTEL2, hp.HAT_PATKMTEL2, hp.HAT_PATKPAGER2, ");//51-54
		sqlStr.append("       hp.HAT_PATKEMAIL2, hp.HAT_PATKADD12, hp.HAT_PATKADD22, hp.HAT_PATKADD32, hp.HAT_PATKADD42, ");//55-59
		sqlStr.append("       TO_CHAR(hp.HAT_EXPECTED_ADMISSION_DATE, 'dd/MM/YYYY'), TO_CHAR(hp.HAT_EXPECTED_ADMISSION_DATE, 'HH24:MI'), ");//60-61
		sqlStr.append("       TO_CHAR(hp.HAT_ACTUAL_ADMISSION_DATE, 'dd/MM/YYYY'), TO_CHAR(hp.HAT_ACTUAL_ADMISSION_DATE, 'HH24:MI'), ");//62-63
		sqlStr.append("       hp.HAT_ADMISSION_DOCTOR, hp.HAT_WARD, hp.HAT_ROOM_TYPE, hp.HAT_BED_NO, hp.HAT_PROMOTION_YN, ");//64-68
		sqlStr.append("       hp.HAT_PAYMENT_TYPE, hp.HAT_PAYMENT_TYPE_OTHER, hp.HAT_PAYMENT_CREDIT_CARD_TYPE, hp.HAT_INSURANCE_REMARKS, hp.HAT_INSURANCE_POLICY_NO, ");//69-73
		sqlStr.append("       hp.HAT_EMAIL_CONFIRM_YN, TO_CHAR(hp.HAT_EMAIL_CONFIRM_DATE, 'dd/MM/YYYY'), ");//74-75
		sqlStr.append("       hp.HAT_REMARKS, hp.HAT_SESSION_ID, ");//76-77
		sqlStr.append("       TO_CHAR(hp.HAT_CREATED_DATE, 'dd/MM/YYYY HH24:MI:SS'), hp.HAT_CREATED_USER, ");//78-79
		sqlStr.append("       TO_CHAR(hp.HAT_MODIFIED_DATE, 'dd/MM/YYYY HH24:MI:SS'), hp.HAT_MODIFIED_USER, ");//80-81
		sqlStr.append("       hp.HAT_HASIMTINFO,decode(dc.countDoc,null,0,1) as countDoc, hp.HAT_ACTUAL_ROOM_TYPE, '', ");//82-85
		sqlStr.append("       DECODE(hp.HAT_SESSION_ID, null, DECODE(hp.HAT_CREATED_USER, 'SYSTEM', 'System', 'Web'), 'Email') AS CreatedBy, ");//86
		sqlStr.append("       hp.HAT_COMPLETED, hp.HAT_ENABLED ");//87
		sqlStr.append("FROM   ");
		sqlStr.append("HAT_PATIENT hp ");
		//sqlStr.append("left outer join (SELECT B.PATNO, B.BPBHDATE ");
		//sqlStr.append("FROM FLW_UP_HIST f1, BEDPREBOK@IWEB B ");
		//sqlStr.append("WHERE f1.update_date in ");
		//sqlStr.append("		(SELECT MAX(f2.update_date) ");
		//sqlStr.append("		FROM FLW_UP_HIST f2 ");
		//sqlStr.append("		WHERE f1.pbpid = f2.pbpid ");
		//sqlStr.append("		AND f2.FLW_UP_TYPE = 'INPATPB' ");
		//sqlStr.append("		GROUP BY f2.pbpid) ");
		//sqlStr.append("AND f1.FLW_UP_TYPE = 'INPATPB' ");
		//sqlStr.append("AND f1.FLW_UP_STATUS = '8' ");
		//sqlStr.append("AND f1.PBPID = B.PBPID) flw on flw.PATNO = hp.HAT_PATNO ");
		//sqlStr.append("AND TO_CHAR(flw.BPBHDATE, 'DD/MM/YYYY') = TO_CHAR(hp.HAT_EXPECTED_ADMISSION_DATE, 'dd/MM/YYYY') ");
		sqlStr.append("left outer join (select hat_admno,count(1)as countDoc from hat_patient_documents GROUP BY hat_admno) dc on ");
		sqlStr.append("dc.hat_admno = hp.hat_admno ");

		sqlStr.append("WHERE   ");
		sqlStr.append(" HAT_ADMISSION_TYPE = 'O'");
		if (dateFrom != null && dateFrom.length() > 0) {
			sqlStr.append("AND    HAT_EXPECTED_ADMISSION_DATE >= TO_DATE('");
			sqlStr.append(dateFrom);
			sqlStr.append(" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		}
		if (dateTo != null && dateTo.length() > 0) {
			sqlStr.append("AND    HAT_EXPECTED_ADMISSION_DATE <= TO_DATE('");
			sqlStr.append(dateTo);
			sqlStr.append(" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
		}
		if (patientType != null && patientType.length() > 0) {
			if ("exisiting".equals(patientType)) {
				sqlStr.append("AND    HAT_PATNO IS NOT NULL ");
			} else if ("new".equals(patientType)) {
				sqlStr.append("AND    HAT_PATNO IS NULL ");
			}
		}
		if (patientStatus != null && patientStatus.length() > 0) {
			if ("complete".equals(patientStatus)) {
				sqlStr.append("AND    HAT_COMPLETED = '1' ");
			} else if ("notComplete".equals(patientStatus)) {
				sqlStr.append("AND    HAT_COMPLETED = '0' ");
			} else if ("deleted".equals(patientStatus)) {
				sqlStr.append("AND    HAT_ENABLED = '0' ");
			}
			if (!"deleted".equals(patientStatus)) {
				sqlStr.append("AND    HAT_ENABLED = '1' ");
			}
		}

		sqlStr.append("ORDER BY ");

		if (pdf) {
			sqlStr.append("CreatedBy ASC, ");
		}

		if (ConstantsVariable.ZERO_VALUE.equals(sortBy)) {
			sqlStr.append("HAT_PATFNAME");
		} else if (ConstantsVariable.ONE_VALUE.equals(sortBy)) {
			sqlStr.append("HAT_PATNO");
		} else if (ConstantsVariable.TWO_VALUE.equals(sortBy)) {
			sqlStr.append("HAT_CREATED_DATE");
		} else if (ConstantsVariable.THREE_VALUE.equals(sortBy)) {
			sqlStr.append("HAT_PATBDATE");
		} else if (ConstantsVariable.FOUR_VALUE.equals(sortBy)) {
			sqlStr.append("HAT_SESSION_ID");
		} else if (ConstantsVariable.FIVE_VALUE.equals(sortBy)) {
			//sqlStr.append("flw.PATNO");
		} else if (ConstantsVariable.SIX_VALUE.equals(sortBy)) {
			sqlStr.append("hp.HAT_EXPECTED_ADMISSION_DATE");
		} else {
			sqlStr.append("HAT_MODIFIED_DATE");
		}

		if (ordering != null) {
			sqlStr.append(ConstantsVariable.SPACE_VALUE);
			sqlStr.append(ordering);
		} else {
			sqlStr.append(ConstantsVariable.SPACE_VALUE);
			sqlStr.append(" DESC");
		}

		sqlStr.append(", HAT_ADMNO DESC");
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
}

	public static boolean isExist(UserBean userBean, String fromDate, String toDate) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM   HAT_PATIENT ");
		sqlStr.append("WHERE  HAT_SITE_CODE = '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append("AND    HAT_STAFF_ID = ? ");
		sqlStr.append("AND    HAT_FROM_DATE <= TO_DATE(?, 'dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    HAT_TO_DATE >= TO_DATE(?, 'dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND    HAT_ENABLED = 1");

		return UtilDBWeb.isExist(sqlStr.toString(),
				new String[] { userBean.getStaffID(), fromDate, toDate });
	}

	public static boolean addHATS(UserBean userBean, String admissionID) {
		ArrayList record = get(admissionID);
		if (record.size() > 0) {
			String patno = UtilDBWeb.callFunction(
					"HAT_ACT_PATIENT",
					"ADD",
					new String[] { admissionID });

			if (patno != null && patno.length() > 0&& Integer.parseInt(patno)>0) {
				System.out.println("[DEBUG] AdmissionDB  aID=<"+admissionID+"> patno=<"+patno+"> ");
				updatePatNo(userBean, patno, admissionID);
				//addMedicalRecord(patno);
			}
			if (Integer.parseInt(patno)< 0) {
				return false;
			} else {
				return true;
			}
		} else {
			return false;
		}
	}

	public static boolean updateCompleteToHATSPatient(UserBean userBean, String admissionID) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("UPDATE HAT_PATIENT ");
		sqlStr.append("SET HAT_COMPLETED = '1', ");
		sqlStr.append("HAT_MODIFIED_DATE=SYSDATE, ");
		sqlStr.append("HAT_MODIFIED_USER='" + userBean.getLoginID() + "' ");
		sqlStr.append("WHERE HAT_ADMNO = '" + admissionID + "' ");

		//System.out.println(sqlStr.toString());
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}

	public static boolean updateHATS(UserBean userBean, String admissionID) {
		ArrayList record = get(admissionID);
		if (record.size() > 0) {
			return ConstantsErrorMessage.RETURN_PASS.equals(
				UtilDBWeb.callFunction(
					"HAT_ACT_PATIENT",
					"MOD",
					new String[] { admissionID }));
		} else {
			return false;
		}
	}

	public static boolean updateUPDATELOG(UserBean userBean, String admissionID, String staffID, String verStaff) {
		ArrayList record = get(admissionID);
		ReportableListObject row = (ReportableListObject) record.get(0);
		String patno = row.getValue(1);
		if (record.size() > 0) {
			String rtn = UtilDBWeb.callFunctionHATS(
					"NHS_ACT_UPATEPATLOG",
					"ADD",
					new String[] {
							patno,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							null,
							staffID,verStaff });

				System.err.println("[updateUPDATELOG][rtn]:"+rtn+"["+rtn.indexOf("<FIELD/>0<FIELD/>")+"];[admissionID]:"+admissionID+";[patno]:"+patno+";[staffID]:"+staffID+";[verStaff]:"+verStaff);
				if(rtn.indexOf("<FIELD/>0<FIELD/>")>=0){
					return true;
				}else{
					return false;
				}
		}else{
			System.err.println("[updateUPDATELOG][false][admissionID]:"+admissionID+";[staffID]:"+staffID+";[verStaff]:"+verStaff);
			return false;
		}
	}

	public static ArrayList getHATSPatient(String patNo, String pathkid, String patbdate) {
		return UtilDBWeb.getFunctionResults("HAT_GET_PATIENT",
				new String[] { patNo==null?"":patNo, pathkid==null?"":pathkid, patbdate==null?"":patbdate });
	}

	public static ArrayList getHATSPatientList(String patNo, String pathkid, String pathtel, String patbdate, String patSex, String patFName, String patGName, String patMName,String patmtel,String patemail) {
		return UtilDBWeb.getFunctionResults("HAT_LST_PATIENT_TEST2",
				new String[] {
					patNo==null?"":patNo,
					pathkid==null?"":pathkid,
					pathtel==null?"":pathtel,
					patmtel==null?"":patmtel,
					patbdate==null?"":patbdate,
					patSex==null?"":patSex,
					patemail==null?"":patemail,
					patFName==null?"":patFName,
					patGName==null?"":patGName,
					patMName==null?"":patMName,
					"Patient Name"
				}
		);
	}


	public static String addMedicalRecord(String patNo) {
		return
				UtilDBWeb.callFunction(
					"NHS_ACT_MEDREC_ADDFORWEB@IWEB",
					"ADD",
					new String[] {
							patNo	// PATNO
					});
	}

	public static String getCountryDesc(String coucode) {
		ArrayList record = UtilDBWeb.getFunctionResults("HAT_GET_COUNTRY", new String[] { coucode==null?"":coucode });
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			return row.getValue(0);
		} else {
			return null;
		}
	}

//20180928 Arran changed to call HAT_GET_COUNTRY to avoid error
	public static String getCountryDesc2(String coucode, String language) {
		ArrayList record = UtilDBWeb.getReportableList(
				" SELECT COUDESC, COUCDESC FROM COUNTRY@IWEB WHERE COUCODE ='"+coucode+"' ");
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			if ("chi".equals(language) && !row.getValue(1).isEmpty())
				return row.getValue(1);
			else
				return row.getValue(0);
		} else {
			return null;
		}
	}

	public static String getRaceChiDesc(String racdesc) {
		ArrayList record = UtilDBWeb.getReportableList(
				" SELECT RACCHIDESC FROM RACE@IWEB WHERE RACDESC ='"+racdesc+"' ");

		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);

			if (row.getValue(0).isEmpty())
				return racdesc;
			else
				return row.getValue(0);

		} else {
			return racdesc;
		}
	}

	public static String getMktSrcDesc(String mktSrc) {
		ArrayList record = UtilDBWeb.getFunctionResults("HAT_GET_MKTSRCDESC", new String[] { mktSrc==null?"":mktSrc });
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			return row.getValue(0);
		} else {
			return null;
		}
	}

//20181205 Arran added to get marketing source based on language
	public static String getMktSrcDesc2(String mktSrc, String language) {

		ArrayList record = UtilDBWeb.getReportableList(
				" SELECT MKTSRCDESC, MKTSRCCDESC FROM MARKETINGSOURCE@IWEB WHERE MKTSRCCODE ='"+mktSrc+"' ");

		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			if ("chi".equals(language) && !row.getValue(1).isEmpty())
				return row.getValue(1);
			else
				return row.getValue(0);
		} else {
			return null;
		}

	}

	public static boolean sendEmailNotifyStaff(String admissionID,String type) {
		// append url
		String title = "";
		if ("out".equals(type)) {
			title = "New Out-Patient (From Intranet Portal - Out-patient Online Registration.)";
		} else {
			title = "New In-Patient (From Intranet Portal - Admission at Ward)";
		}

		StringBuffer commentStr = new StringBuffer();
		if ("out".equals(type)) {
			commentStr.append("Dear staff, ");
		} else {
			commentStr.append("New In-Patient arrived ");
		}

		commentStr.append("<br>Please click <a href=\"http://");
		commentStr.append(ConstantsServerSide.INTRANET_URL);
		if ("out".equals(type)) {
			commentStr.append("/intranet/registration/out_admission.jsp?command=view&admissionID=");
		} else {
			commentStr.append("/intranet/registration/admission.jsp?command=view&admissionID=");
		}
		commentStr.append(admissionID);
		commentStr.append("\">Intranet</a> or <a href=\"https://");
		commentStr.append(ConstantsServerSide.OFFSITE_URL);
		if ("out".equals(type)) {
			commentStr.append("/intranet/registration/out_admission.jsp?command=view&admissionID=");
		} else {
			commentStr.append("/intranet/registration/admission.jsp?command=view&admissionID=");
		}
		commentStr.append(admissionID);
		if ("out".equals(type)) {
			commentStr.append("\">Offsite</a> Out-patient Online Registration.");
		} else {
			commentStr.append("\">Offsite</a> to view the Admission at Ward.");
		}

		String[] emailTo = getStaffEmail(type).split(";");
		String emailForm;
		String[] bcc = null;
		if ("out".equals(type)) {
			emailForm = "regdesk@hkah.org.hk";
			//emailTo = new String[] { "regdesk@hkah.org.hk" };
			bcc = new String[] { "im.web@hkah.org.hk" };
		} else {
			emailForm = "admission@hkah.org.hk";
			//emailTo = new String[] { "admission@hkah.org.hk", "sandra.chow@hkah.org.hk" };
			bcc = new String[] { "im.web@hkah.org.hk" };
		}

		// send email
		boolean success = UtilMail.sendMail(emailForm, emailTo, null, bcc, title, commentStr.toString());

		UtilMail.insertEmailLog(null, admissionID, "out".equals(type)?"OUTPAT":"INPAT",
								"NotifyStaff", success, null);

		return success;
	}

	/**
	 * Email link for Online Registration step 1
	 * @param userBean
	 * @param email
	 */
	public static boolean sendEmailNotifyClient(UserBean userBean, String email) {
		return sendEmailNotifyClient(userBean, email, null);
	}

	public static boolean sendEmailNotifyClient(UserBean userBean, String email, String type) {
		String sessionID = SessionLoginDB.add(userBean, email);

		// append url
		StringBuffer commentStr = new StringBuffer();
		if ("out".equals(type)) {
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.heading"));
			commentStr.append("<br><br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.step1.block1"));
			commentStr.append("<br><br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.step1.block2a"));
			commentStr.append(sessionID);
			commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.step1.block2b"));
			commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.step1.block2c"));
			commentStr.append("<br><br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.ending"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.admission.office"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.booking.hospital"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.tel"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.fax"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.email"));
			commentStr.append("<br><br>");

			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.heading"));
			commentStr.append("<br><br>");
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.step1.block1"));
			commentStr.append("<br><br>");
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.step1.block2a"));
			commentStr.append(sessionID);
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.step1.block2b"));
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.step1.block2c"));
			commentStr.append("<br><br>");
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.ending"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.admission.office"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.booking.hospital"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.tel"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.fax"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.email"));
		} else {
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.heading"));
			commentStr.append("<br>");
			commentStr.append("<br><br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step1.block1"));
			commentStr.append("<br><br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step1.block1a"));
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step1.block1a.sub1a"));
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step1.block1a.sub1b"));
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step1.block1b"));
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step1.block2a"));
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step1.block2b"));
			commentStr.append(sessionID);
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step1.block2c"));
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step1.block2d"));
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step1.block2e"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step1.block3a"));
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step1.block3b"));
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step1.block3c"));
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step1.block3d"));
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step1.block3e"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step1.block4a"));
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step1.block4b"));
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step1.block4c"));
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step1.block4d"));
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step1.block4e"));
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step1.block4f"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step1.block5"));
			commentStr.append("<br><br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.ending"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.admission.office"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.tel"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.fax"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.email"));

			commentStr.append("<br><br><br><br><br><br><br>");

			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.heading"));
			commentStr.append("<br>");
			commentStr.append("<br><br>");
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step1.block1"));
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step1.block1a"));
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step1.block1a.sub1a"));
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step1.block1a.sub1b"));
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step1.block1b"));
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step1.block2a"));
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step1.block2b"));
			commentStr.append(sessionID);
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step1.block2c"));
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step1.block2d"));
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step1.block2e"));
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step1.block3a"));
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step1.block3b"));
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step1.block3c"));
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step1.block3d"));
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step1.block3e"));
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step1.block4a"));
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step1.block4b"));
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step1.block4c"));
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step1.block4d"));
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step1.block4e"));
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step1.block4f"));
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step1.block4g"));
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step1.block5a"));
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step1.block5b"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.admission.office"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.tel"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.fax"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.email"));
		}
		String emailFrom;
		String[] bcc;
		String actType;
		if ("out".equals(type)) {
			emailFrom = "regdesk@hkah.org.hk";
			bcc = new String[] { "regdesk@hkah.org.hk", "im.web@hkah.org.hk" };
			actType = "OUTPAT";
		} else {
			emailFrom = "admission@hkah.org.hk";
			bcc = new String[] { "admission@hkah.org.hk", "sandra.chow@hkah.org.hk", "im.web@hkah.org.hk" };
			actType = "INPAT";
		}


		boolean success = UtilMail.sendMail(
							emailFrom, new String[] { email }, null, bcc,
							"Hong Kong Adventist Hospital –Stubbs Road (Online Registration)",
							commentStr.toString(),true);

		UtilMail.insertEmailLog(userBean, sessionID, actType, "ONREG", success, null);

		return success;
	}

	public static boolean sendEmailNotifyClient(UserBean userBean, String email, String type,
							String appointmentDate, String appointmentTime_hh, String appointmentTime_mi,
							String attendDoctor) {

		ArrayList<ReportableListObject> record = UtilDBWeb.getFunctionResults("HAT_CMB_DOCTOR", new String[] { "Pre-addmission" });
		ReportableListObject row = null;
		String doctorName = "";
		if (record.size() > 0) {
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				if (row.getValue(0).equals(attendDoctor)) {
					doctorName = row.getValue(1) + " " + row.getValue(2);
				}
			}
		}

		String sessionID = SessionLoginDB.add(userBean, email);

		StringBuffer commentStr = new StringBuffer();

		commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.heading"));
		commentStr.append("<br><br>");
		commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.step1.block1"));
		commentStr.append("<br><br>");
		commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.step1.block2a"));
		commentStr.append(sessionID);
		commentStr.append("&appointmentDate="+appointmentDate);
		commentStr.append("&appointmentTime_hh="+appointmentTime_hh);
		commentStr.append("&appointmentTime_mi="+appointmentTime_mi);
		commentStr.append("&attendDoctor="+attendDoctor);
		commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.step1.block2b"));
		commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.step1.block2c"));
		commentStr.append("<br><br>");
		commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.feeposter"));
		commentStr.append("<br><br>");

		commentStr.append("<table style='width:100%'><tr><td style='width:50%'>");
		commentStr.append(MessageResources.getMessageEnglish("out.adm.attDoctor") + " :");
		commentStr.append("</td><td>" + doctorName);
		commentStr.append("</td>");
		commentStr.append("<tr><td>");
		commentStr.append(MessageResources.getMessageEnglish("out.adm.appDate"));
		commentStr.append(MessageResources.getMessageEnglish("adm.ddmmyyyy.hhmm")+ " :");
		commentStr.append("</td><td>");
		commentStr.append(appointmentDate + " " + appointmentTime_hh + ":" + appointmentTime_mi);
		commentStr.append("</td></tr></table>");
		commentStr.append("<br>");
		commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.ending"));
		commentStr.append("<br>");
		commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.admission.office"));
		commentStr.append("<br>");
		commentStr.append(MessageResources.getMessageEnglish("prompt.booking.hospital"));
		commentStr.append("<br>");
		commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.tel"));
		commentStr.append("<br>");
		commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.fax"));
		commentStr.append("<br>");
		commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.email"));
		commentStr.append("<br><br>");

		commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.heading"));
		commentStr.append("<br><br>");
		commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.step1.block1"));
		commentStr.append("<br><br>");
		commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.step1.block2a"));
		commentStr.append(sessionID);
		commentStr.append("&appointmentDate="+appointmentDate);
		commentStr.append("&appointmentTime_hh="+appointmentTime_hh);
		commentStr.append("&appointmentTime_mi="+appointmentTime_mi);
		commentStr.append("&attendDoctor="+attendDoctor);
		commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.step1.block2b"));
		commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.step1.block2c"));
		commentStr.append("<br><br>");
		commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.feeposter"));
		commentStr.append("<br><br>");

		commentStr.append("<table style='width:100%'><tr><td style='width:50%'>");
		commentStr.append(MessageResources.getMessageTraditionalChinese("out.adm.attDoctor") + " :");
		commentStr.append("</td><td>" + doctorName);
		commentStr.append("</td>");
		commentStr.append("<tr><td>");
		commentStr.append(MessageResources.getMessageTraditionalChinese("out.adm.appDate"));
		commentStr.append(MessageResources.getMessageTraditionalChinese("adm.ddmmyyyy.hhmm")+ " :");
		commentStr.append("</td><td>");
		commentStr.append(appointmentDate + " " + appointmentTime_hh + ":" + appointmentTime_mi);
		commentStr.append("</td></tr></table>");
		commentStr.append("<br>");
		commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.ending"));
		commentStr.append("<br>");
		commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.admission.office"));
		commentStr.append("<br>");
		commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.booking.hospital"));
		commentStr.append("<br>");
		commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.tel"));
		commentStr.append("<br>");
		commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.fax"));
		commentStr.append("<br>");
		commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.email"));

		String emailFrom;
		String[] bcc;
		String actType;

		emailFrom = "regdesk@hkah.org.hk";
		bcc = new String[] { "regdesk@hkah.org.hk", "im.web@hkah.org.hk" };
		actType = "OUTPAT";

		boolean success = UtilMail.sendMail(
							emailFrom, new String[] { email }, null, bcc,
							"Hong Kong Adventist Hospital –Stubbs Road (Online Registration)",
							commentStr.toString(),true);

		UtilMail.insertEmailLog(userBean, sessionID, actType, "ONREG", success, null);

		return success;
	}

	/**
	 * Auto Reply for Online Registration step 3
	 * @param email
	 */
	public static boolean sendEmailAutoNotifyClient(String admissionID, String email, String type) {
		// append url
		StringBuffer commentStr = new StringBuffer();

		if ("out".equals(type)) {
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.heading"));
			commentStr.append("<br><br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step3.block1"));
			commentStr.append("<br><br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.ending"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.admission.office"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.booking.hospital"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.tel"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.fax"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.email"));

			commentStr.append("<br><br>");

			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.heading"));
			commentStr.append("<br><br>");
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step3.block1"));
			commentStr.append("<br><br>");
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.ending"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.admission.office"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.booking.hospital"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.tel"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.fax"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.email"));
		} else {
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.heading"));
			commentStr.append("<br>");
			commentStr.append("<br><br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step3.block1"));
			commentStr.append("<br><br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.ending"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.admission.office"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.tel"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.fax"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.email"));

			commentStr.append("<br><br>");

			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.heading"));
			commentStr.append("<br>");
			commentStr.append("<br><br>");
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step3.block1"));
			commentStr.append("<br><br>");
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.ending"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.admission.office"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.tel"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.fax"));
			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.email"));
		}

		String emailFrom;
		String[] bcc = null;
		if ("out".equals(type)) {
			emailFrom = "regdesk@hkah.org.hk";
			bcc = new String[] { "im.web@hkah.org.hk" };
		} else {
			emailFrom = "admission@hkah.org.hk";
			bcc = new String[] { "im.web@hkah.org.hk" };
		}

		// send email
		boolean success = UtilMail.sendMail(
								emailFrom,
								new String[] { email },
								null, bcc,
								"Hong Kong Adventist Hospital –Stubbs Road (Auto Reply for Online Registration)",
								commentStr.toString());

		UtilMail.insertEmailLog(null, admissionID, "out".equals(type)?"OUTPAT":"INPAT",
									"NotifyClient", success, null);

		return success;
	}

//20180928 Arran added to send email with admissionID
	public static boolean sendEmailAutoNotifyClient(String admissionID, String type) {
		String patmail = null;
		ArrayList record = get(admissionID);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			patmail = row.getValue(25) ;
		}

		return sendEmailAutoNotifyClient(admissionID, patmail, type);
	}

	/**
	 * Auto Reply for Online Registration step 3
	 * @param email
	 */
	public static boolean sendEmailAutoNotifyClientPayment(String admissionID, String type) {
		String patname = null, patcname = null, patmail = null, receiptNo = null, payDate = null, payAmt = null, patTit = null, patTitChi = " ", payTypeDisp = null, payAppCode = null, payType = null, transNo = null ;
		ArrayList record = get(admissionID);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			 patname = row.getValue(2) + " " + row.getValue(3) ;
			 patcname = row.getValue(4) ;
			 if ( patcname == null || patcname.isEmpty() ) {
				 patcname = patname ;
			 }
			 patmail = row.getValue(25) ;
			 // use HAT_PAYMENT_TRANS_NO instead of HAT_PAYMENT_RECEIPT_NO
			 receiptNo = row.getValue(101) ;
			 transNo = row.getValue(111) ;

			 // use HAT_PAYMENT_TRAN_AMT instead of HAT_PAYMENT_AMOUNT
			 // payAmt = row.getValue(102) ;
			 payAmt = row.getValue(109) ;
			 if (!(payAmt == null || payAmt.isEmpty())) {
				 DecimalFormat formatter = new DecimalFormat("#,###,###");
				 payAmt = formatter.format(Long.parseLong(payAmt));
			 }

			 payDate = row.getValue(105) ;
			 patTit = row.getValue(106) ;
			 payTypeDisp = row.getValue(107) ;
			 if ("MasterCard".equals(payTypeDisp) ){
				 payTypeDisp = payTypeDisp + "萬事達" ;
			 } else if ("UnionPay".equals(payTypeDisp)) {
				 payTypeDisp = payTypeDisp + "銀聯" ;
			 }
			 payType = row.getValue(69) ;
			 if ( patTit != null && !patTit.isEmpty() ) {
				 if ( "MRS".equals(patTit) || "MRS.".equals(patTit)  ) { patTitChi = "太太"; } else if ( "MISS".equals(patTit) || "MISS.".equals(patTit) ) { patTitChi = "小姐"; } else if ( "MR".equals(patTit) || "MR.".equals(patTit) ) { patTitChi = "先生"; } else if ( "MS".equals(patTit) || "MS.".equals(patTit) ) { patTitChi = "女士"; }
			 }
			 payAppCode = row.getValue(108) ;
		};
		// append url
		StringBuffer commentStr = new StringBuffer();
		//String emailSubject = "HKAH-SR ( Auto-reply email - Ref.no. " + admissionID + ")" ;
		String emailSubject = "HKAH-SR ( Auto-reply email - Order ID/No. " + transNo + ")" ;

		commentStr.append("Dear " + patTit + " " + patname + ",");
		commentStr.append("<br><br>");

		if ( "VISA_MASTER".equals( payType ) || "UNION_PAY".equals( payType ) ) {
			commentStr.append("Thank you for using Hong Kong Adventist Hospital – Stubbs Road Online check-in service. This auto-reply email acknowledge your payment and registration process.<br>");
			commentStr.append("<br>");
			commentStr.append("It will take around 12 to 24 hours to process your information. Once it has completed, you will receive a Registration Confirmation email.<br>");
			commentStr.append("Please retain this email as your payment confirmation slip.<br>");
			commentStr.append("<br>");
			commentStr.append("Should there be any query, please feel free to contact us.<br>");
			commentStr.append("<br>");
			commentStr.append("Yours sincerely<br>");
			commentStr.append("Admission Office<br>");
			commentStr.append("Tel: 3651 8740<br>");
			commentStr.append("Fax: 3651 8801<br>");
			commentStr.append("Email: admission@hkah.org.hk<br>");
			commentStr.append("<br>");
			commentStr.append("<br>");
			commentStr.append("網上登記通知<br>");
			commentStr.append("<br>");
			commentStr.append("親愛的 " + patcname + patTitChi + ":<br>");
			commentStr.append("<br>");
			commentStr.append("多謝使用香港港安醫院 – 司徒拔道的網上登記服務。此乃自動回覆電郵以確認是次付款及網上登記。<br>");
			commentStr.append("<br>");
			commentStr.append("閣下的資料將於12-24小時內核實，並於完成後透過電郵通知閣下。<br>");
			commentStr.append("請保留此電子郵件作為閣下的付款確認單。<br>");
			commentStr.append("<br>");
			commentStr.append("如有任何查詢，請聯絡我們。<br>");
			commentStr.append("<br>");
			//commentStr.append("此致<br>");
			commentStr.append("香港港安醫院 – 司徒拔道<br>");
			commentStr.append("電話: 3651 8740<br>");
			commentStr.append("傳真: 3651 8801<br>");
			commentStr.append("電郵: admission@hkah.org.hk<br>");
			commentStr.append("<br>");

			commentStr.append("<br>");

			commentStr.append("<br>");
			commentStr.append("<center>Confirmation of Payment 付款確認</center><br>");
			commentStr.append("Your payment to <b>Hong Kong Adventist Hospital – Stubbs Road</b> has been received. Here are the details.<br>");
			commentStr.append("閣下支付予<b>香港港安醫院 – 司徒拔道</b>的款項已收妥 。詳情如下：<br>");
			commentStr.append("<br>");
			commentStr.append("<table>");
			// use transNo instead of receiptNo
			//commentStr.append("<tr><td>Reference Number 心考編號</td><td>:</td><td>" + receiptNo + "</td></tr>");
			commentStr.append("<tr><td>Order ID/No. 訂單編號 :</td><td>:</td><td>" + transNo + "</td></tr>");
			commentStr.append("<tr><td>Transaction Date 交易日期</td><td>:</td><td>" + payDate + "</td></tr>");
			commentStr.append("<tr><td>Cardholder Name 付款人姓名</td><td>:</td><td>" + patname + "</td></tr>");
			commentStr.append("<tr><td>Transaction Amount 交易金額</td><td>:</td><td>$ " + payAmt + "</td></tr>");
			commentStr.append("<tr><td>Transaction Currency 交易貨幣</td><td>:</td><td>" + "Hong Kong Dollar 港幣" + "</td></tr>");
			commentStr.append("<tr><td>Payment Type 付款方法</td><td>:</td><td>" + payTypeDisp + "</td></tr>");
			commentStr.append("<tr><td>Approval Code 授權編號</td><td>:</td><td>" + payAppCode + "</td></tr>");
			commentStr.append("<tr><td>Description of Goods/ Services 產品/服務描述</td><td>:</td><td>" + "Medical Care 醫療保健" + "</td></tr>");
			commentStr.append("<tr><td>Transaction Type 交易類別</td><td>:</td><td>" + "SALE 銷售" + "</td></tr>");
			commentStr.append("</table><br>");

			commentStr.append("<br>");
//			commentStr.append("This email is automatically sent by computer system. Please DO NOT REPLY.<br>");
//			commentStr.append("此乃電腦系統自動發出之電子郵件，請不要回覆。<br>");
//			commentStr.append("<br>");
//			commentStr.append("This e-mail (and any attachment (s)) is confidential and for use only by intended recipient (s). Access by others is unauthorised. Its content should not be relied upon and no liability or responsibility is accepted by us, without our subsequent written confirmation of its content. If you are not an intended recipient, please notify us promptly and delete all copies and note that any disclosure, copying, distribution or any action taken or omitted to be taken in reliance on the information it contains is prohibited and may be unlawful.<br>");
//			commentStr.append("<br>");
		} else {
			commentStr.append("<br>");
			commentStr.append("This auto-reply email acknowledge your registration process.  It will take around 12 to 24 hours to process your information.  Once it has completed, you will receive a Registration Confirmation email.<br>");
			commentStr.append("<br>");
			commentStr.append("<br>");
			commentStr.append("<br>");
//			commentStr.append("Yours sincerely<br>");
			commentStr.append("Admission Office<br>");
			commentStr.append("Hong Kong Adventist Hospital - Stubbs Road<br>");
			commentStr.append("Tel: 3651 8740<br>");
			commentStr.append("Fax: 3651 8801<br>");
			commentStr.append("Email: admission@hkah.org.hk<br>");
			commentStr.append("<br>");
			commentStr.append("<br>");
			commentStr.append("親愛的 " + patcname + patTitChi + ":<br>");
			commentStr.append("<br>");
			commentStr.append("<br>");
			commentStr.append("此乃自動回覆的訊息。您的資料正在處理中，一旦完成登記程序，本院會透過電郵向您確認。<br>");
			commentStr.append("<br>");
			commentStr.append("<br>");
//			commentStr.append("此致<br>");
			commentStr.append("香港港安醫院 – 司徒拔道<br>");
			commentStr.append("電話: 3651 8740<br>");
			commentStr.append("傳真: 3651 8801<br>");
			commentStr.append("電郵: admission@hkah.org.hk<br>");
			commentStr.append("<br>");
		}

		//if ("out".equals(type)) {
		//} else {
		//}

		String emailFrom;
		String[] bcc = null;
		if ("out".equals(type)) {
			emailFrom = "regdesk@hkah.org.hk";
			bcc = new String[] { "im.web@hkah.org.hk" };
		} else {
			emailFrom = "admission@hkah.org.hk";
			bcc = new String[] { "im.web@hkah.org.hk" };
		}

		// send email
		boolean success = UtilMail.sendMail(
								emailFrom,
								new String[] { patmail },
								null, bcc,
//								"Hong Kong Adventist Hospital –Stubbs Road (Auto Reply for Online Registration)",
								emailSubject,
								commentStr.toString());

		UtilMail.insertEmailLog(null, admissionID, "out".equals(type)?"OUTPAT":"INPAT",
									"NotifyClient", success, null);

		return success;
	}


	/**
	 * Email Reply for Online Registration step 4
	 * @param userBean
	 * @param admissionID
	 * @return
	 */
	public static boolean sendEmailConfirmClient(
			UserBean userBean, String admissionID, String type) {

		ArrayList record = get(admissionID);
		boolean success = false;
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			String email = row.getValue(25);
			if (email==null || "".equals(email)) {
				return false;
			}

			String patname = row.getValue(2) + " " + row.getValue(3) ;
			String patcname = row.getValue(4) ;

			if ( patcname == null || patcname.isEmpty() ) {
				 patcname = patname ;
			}

			String patTit = row.getValue(106) ;
			String patTitChi = null;

			if ( patTit != null && !patTit.isEmpty() ) {
				if ( "MRS".equals(patTit) || "MRS.".equals(patTit)  ) {
					patTitChi = "太太";
				} else if ( "MISS".equals(patTit) || "MISS.".equals(patTit) ) {
					patTitChi = "小姐";
				} else if ( "MR".equals(patTit) || "MR.".equals(patTit) ) {
					patTitChi = "先生";
				} else if ( "MS".equals(patTit) || "MS.".equals(patTit) ) {
					patTitChi = "女士";
				}
			}

			// append url
			StringBuffer commentStr = new StringBuffer();

			if ("out".equals(type)) {
				commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.heading"));
				commentStr.append("<br><br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.step4.block1"));
				commentStr.append("<br><br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.step4.block2"));
				commentStr.append("<br><br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.step4.block4"));
				commentStr.append("<br><br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.ending"));
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.admission.office"));
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.booking.hospital"));
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.tel"));
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.fax"));
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.out.onlinereg.email"));

				commentStr.append("<br><br>");

				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.heading"));
				commentStr.append("<br>");
				commentStr.append("<br><br>");
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.step4.block1"));
				commentStr.append("<br><br>");
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.step4.block2"));
				commentStr.append("<br><br>");
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.step4.block4"));
				commentStr.append("<br><br>");
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.ending"));
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.admission.office"));
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.booking.hospital"));
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.tel"));
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.fax"));
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.out.onlinereg.email"));
			} else {
				//20181029 Arran modified to use name
				//commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.heading"));
				commentStr.append("Dear " + patTit + " " + patname + ",");

				commentStr.append("<br>");
				commentStr.append("<br><br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step4.block1"));
				commentStr.append("<br><br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step4.block2"));
				commentStr.append("<br><br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step4.block3"));
				commentStr.append("<br><br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.step4.block4"));
				commentStr.append("<br><br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.ending"));
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.admission.office"));
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.tel"));
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.fax"));
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.onlinereg.email"));

				commentStr.append("<br><br>");

				//20181029 Arran modified to use name
				//commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.heading"));
				commentStr.append("親愛的 " + patcname + " " + patTitChi + "：");

				commentStr.append("<br>");
				commentStr.append("<br><br>");
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step4.block1"));
				commentStr.append("<br><br>");
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step4.block2"));
				commentStr.append("<br><br>");
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step4.block3"));
				commentStr.append("<br><br>");
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.step4.block4"));
				commentStr.append("<br><br>");
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.ending"));
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.admission.office"));
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.tel"));
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.fax"));
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageTraditionalChinese("prompt.onlinereg.email"));
			}
			String emailFrom;
			String[] bcc = null;
			if ("out".equals(type)) {
				emailFrom = "regdesk@hkah.org.hk";
				bcc = new String[] { "regdesk@hkah.org.hk", "im.web@hkah.org.hk" };
			} else {
				emailFrom = "admission@hkah.org.hk";
				bcc = new String[] { "admission@hkah.org.hk", "sandra.chow@hkah.org.hk", "im.web@hkah.org.hk" };
			}

			// send email
			if (UtilMail.sendMail(
				emailFrom,
				new String[] { email },
				null, bcc,
				"Hong Kong Adventist Hospital –Stubbs Road (Online Registration Confirmation)",
				commentStr.toString(),true)) {

				success =  UtilDBWeb.updateQueue(
											sqlStr_emailNotification,
											new String[] { ConstantsVariable.YES_VALUE,
													userBean.getLoginID(), admissionID} );

				UtilMail.insertEmailLog(null, admissionID, "out".equals(type)?"OUTPAT":"INPAT",
						"ConfirmReg", success, null);
			}
		}
		return success;
	}

	public static String insertDocument(UserBean userBean, String admissionID, String document) {
		// get next document ID
		String documentID = getNextDocumentID(admissionID);

		// try to insert a new record
		if (UtilDBWeb.updateQueue(sqlStr_insertDocumentAction,
				new String[] { admissionID, documentID, document, userBean.getLoginID(), userBean.getLoginID() })) {
			return documentID;
		} else {
			return null;
		}
	}

	public static ArrayList getDocumentList(String admissionID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT HAT_DOCUMENT_ID, HAT_DOCUMENT_DESC ");
		sqlStr.append("FROM   HAT_PATIENT_DOCUMENTS ");
		sqlStr.append("WHERE  HAT_ENABLED = 1 ");
		sqlStr.append("AND    HAT_ADMNO = ? ");
		sqlStr.append("ORDER BY HAT_DOCUMENT_DESC ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { admissionID });
	}

	public static void getAdmissionForm(HttpServletResponse response, String admissionID) {
		ArrayList record = get(admissionID);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			String patno = row.getValue(1);
			String patfname = row.getValue(2);
			String patgname = row.getValue(3);
			String patcname = row.getValue(4);
			String titleDesc = row.getValue(5);

			String patidno = row.getValue(7);
			if (patidno.length() == 0) {
				patidno = row.getValue(8);
			}

			String patsex = row.getValue(10);
			String patsexDesc = null;
			if (patsex != null && patsex.length() > 0) {
				if ("M".equals(patsex)) {
					patsexDesc = "Male";
				} else if ("F".equals(patsex)) {
					patsexDesc = "Female";
				}
			} else {
				patsexDesc = "Other";
			}
			String race = row.getValue(11);
			String raceOther = row.getValue(12);
			String raceDesc = null;
			if (race != null && race.length() > 0) {
				raceDesc = race;
			} else {
				raceDesc = raceOther;
			}
			String religion = row.getValue(13);
			String religionOther = row.getValue(14);
			String regligionDesc = null;
			if (religion != null && religion.length() > 0) {
				if ("NO".equals(religion)) {
					regligionDesc = "None";
				} else if ("BU".equals(religion)) {
					regligionDesc = "Buddhism";
				} else if ("CA".equals(religion)) {
					regligionDesc = "Catholic";
				} else if ("CH".equals(religion)) {
					regligionDesc = "Christian";
				} else if ("HI".equals(religion)) {
					regligionDesc = "Hinduism";
				} else if ("SH".equals(religion)) {
					regligionDesc = "Shintoism";
				} else if ("SD".equals(religion)) {
					regligionDesc = "SDA";
				} else {
					regligionDesc = "Others";
				}
			} else {
				regligionDesc = religionOther;
			}

			String patbdate = row.getValue(15);
			String patmsts = row.getValue(16);
			String patmstsDesc = null;
			if ("S".equals(patmsts)) {
				patmstsDesc = "Single";
			} else if ("M".equals(patmsts)) {
				patmstsDesc = "Married";
			} else if ("D".equals(patmsts)) {
				patmstsDesc = "Divorce";
			} else if ("X".equals(patmsts)) {
				patmstsDesc = "Separate";
			} else {
				patmstsDesc = "Other";
			}
			String mothcode = row.getValue(17);
			String mothcodeDesc = null;
			if ("ENG".equals(mothcode)) {
				mothcodeDesc = "English";
			} else if ("CTE".equals(mothcode)) {
				mothcodeDesc = "Cantonese";
			} else if ("MAN".equals(mothcode)) {
				mothcodeDesc = "Mandarin";
			} else if ("JAP".equals(mothcode)) {
				mothcodeDesc = "Japanese";
			} else {
				mothcodeDesc = "Others";
			}
			String edulevel = row.getValue(19);

			String pathtel = row.getValue(20);
			String patotel = row.getValue(21);
			String patmtel = row.getValue(22);
			String patftel = row.getValue(23);

			String occupation = row.getValue(24);
			String patemail = row.getValue(25);
			String patadd1 = row.getValue(26);
			String patadd2 = row.getValue(27);
			String patadd3 = row.getValue(28);
			String patadd4 = row.getValue(29);
			String coucode = row.getValue(30);
			String coudesc = row.getValue(31);

			String patkfname1 = row.getValue(32);
			String patkgname1 = row.getValue(33);
			String patkcname1 = row.getValue(34);
			String patksex1 = row.getValue(35);
			String patkrela1 = row.getValue(36);

			String patkhtel1 = row.getValue(37);
			String patkotel1 = row.getValue(38);
			String patkmtel1 = row.getValue(39);
			String patkptel1 = row.getValue(40);

			String patkemail1 = row.getValue(41);
			String patkadd11 = row.getValue(42);
			String patkadd21 = row.getValue(43);
			String patkadd31 = row.getValue(44);
			String patkadd41 = row.getValue(45);

			String expectedAdmissionDate = row.getValue(60);
			String expectedAdmissionTime = row.getValue(61);
			String actualAdmissionDate = row.getValue(62);
			String actualAdmissionTime = row.getValue(63);
			String admissionDateTime = null;
			if (actualAdmissionDate != null && actualAdmissionDate.length() > 0
					&& actualAdmissionDate != null && actualAdmissionDate.length() > 0) {
				admissionDateTime = actualAdmissionDate + ConstantsVariable.SPACE_VALUE + actualAdmissionTime;
			} else {
				admissionDateTime = expectedAdmissionDate + ConstantsVariable.SPACE_VALUE + expectedAdmissionTime;
			}
			String admissiondoctor = row.getValue(64);
			String ward = row.getValue(65);
			String roomType = row.getValue(66);
			String bedNo = row.getValue(67);
			String promotionYN = row.getValue(68);

			String paymentType = row.getValue(69);
			String paymentTypeOther = row.getValue(70);
			String insuranceRemarks = row.getValue(71);
			String insurancePolicyNo = row.getValue(72);
			String confirmDate = row.getValue(74);
			String remarks = row.getValue(75);
			String updateUser = row.getValue(78);

			// handle patientk name
			String patname = null;
			StringBuffer patnameSB = new StringBuffer();
			if (patfname != null && patfname.length() > 0) {
				patnameSB.append(patfname.trim());
			}
			if (patgname != null && patgname.length() > 0) {
				patnameSB.append(ConstantsVariable.SPACE_VALUE);
				patnameSB.append(patgname.trim());
			}
			patname = patnameSB.toString().trim().toUpperCase();

			String patkadd = null;
			StringBuffer pataddSB = new StringBuffer();
			if (patkadd11 != null && patkadd11.length() > 0) {
				pataddSB.append(patkadd11.trim());
			}
			if (patkadd21 != null && patkadd21.length() > 0) {
				pataddSB.append(ConstantsVariable.SPACE_VALUE);
				pataddSB.append(patkadd21.trim());
			}
			if (patkadd31 != null && patkadd31.length() > 0) {
				pataddSB.append(ConstantsVariable.SPACE_VALUE);
				pataddSB.append(patkadd31.trim());
			}
			if (patkadd41 != null && patkadd41.length() > 0) {
				pataddSB.append(ConstantsVariable.SPACE_VALUE);
				pataddSB.append(patkadd41.trim());
			}
			patkadd = pataddSB.toString().trim().toUpperCase();

			StringBuffer tempStrBuffer = new StringBuffer();
			tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
			tempStrBuffer.append(File.separator);
			tempStrBuffer.append("Admission at ward");
			tempStrBuffer.append(File.separator);
			tempStrBuffer.append("AdmissionForm Blank.xml");
			String sourceFilename = tempStrBuffer.toString();

			tempStrBuffer.setLength(0);
			tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
			tempStrBuffer.append(File.separator);
			tempStrBuffer.append("Admission at ward");
			tempStrBuffer.append(File.separator);
			tempStrBuffer.append(admissionID);
			tempStrBuffer.append(File.separator);
			tempStrBuffer.append("AdmissionForm.doc");
			String targetFilename = tempStrBuffer.toString();

			// create folder if necessary
			File targetFile = new File(targetFilename);
			if (!targetFile.getParentFile().exists()) {
				targetFile.getParentFile().mkdir();
			}

			// read file and replace
			String thisLine = null;
			String newLine = null;
			DataInputStream br = null;
			DataOutputStream bw = null;

			try {
				br = new DataInputStream(new BufferedInputStream(new FileInputStream(sourceFilename)));
				bw = new DataOutputStream(new BufferedOutputStream(new FileOutputStream(targetFile)));

				while ((thisLine = br.readLine()) != null) {
					// while loop begins here
					newLine = TextUtil.replaceAll(thisLine, "#PatientID#", patno);
					newLine = TextUtil.replaceAll(newLine, "#PatientDateOfBirth#", patbdate);
					newLine = TextUtil.replaceAll(newLine, "#PatientSex#", patsexDesc);
					newLine = TextUtil.replaceAll(newLine, "#PatientTelNumber#", pathtel);
					newLine = TextUtil.replaceAll(newLine, "#PatientMobilePhone#", patmtel);
					newLine = TextUtil.replaceAll(newLine, "#PatientWorkTelNumber#", patotel);
					newLine = TextUtil.replaceAll(newLine, "#PatientEthnicGroup#", raceDesc);
					newLine = TextUtil.replaceAll(newLine, "#PatientReligion#", regligionDesc);
					newLine = TextUtil.replaceAll(newLine, "#PatientAddressLine1#", patadd1);
					newLine = TextUtil.replaceAll(newLine, "#PatientAddressLine2#", patadd2);
					newLine = TextUtil.replaceAll(newLine, "#PatientAddressLine3#", patadd3);
					newLine = TextUtil.replaceAll(newLine, "#PatientCountry#", coudesc);

					newLine = TextUtil.replaceAll(newLine, "#PatientSurname#", patfname);
					newLine = TextUtil.replaceAll(newLine, "#PatientForename#", patgname);
					newLine = TextUtil.replaceAll(newLine, "#PatientHKIDNumber#", patidno);
					newLine = TextUtil.replaceAll(newLine, "#PatientMaritalStatus#", patmstsDesc);
					newLine = TextUtil.replaceAll(newLine, "#PatientEducationLevel#", edulevel);
					newLine = TextUtil.replaceAll(newLine, "#PatientOccupation#", occupation);
					newLine = TextUtil.replaceAll(newLine, "#PatientSpokenLanguage#", mothcodeDesc);
					newLine = TextUtil.replaceAll(newLine, "#PatientEmail#", patemail);

					newLine = TextUtil.replaceAll(newLine, "#NOKSurname#", patkfname1);
					newLine = TextUtil.replaceAll(newLine, "#NOKForename#", patkgname1);
					newLine = TextUtil.replaceAll(newLine, "#NOKRelationship#", patkrela1);
					newLine = TextUtil.replaceAll(newLine, "#NOKOffNumber#", patkotel1);
					newLine = TextUtil.replaceAll(newLine, "#NOKMobNumber#", patkmtel1);
					newLine = TextUtil.replaceAll(newLine, "#NOKPagNumber#", patkptel1);
					newLine = TextUtil.replaceAll(newLine, "#NOKTelNumber#", patkhtel1);
					newLine = TextUtil.replaceAll(newLine, "#NOKAddressLine1#", patkadd);
					newLine = TextUtil.replaceAll(newLine, "#PatientKinEmail#", patkemail1);

					newLine = TextUtil.replaceAll(newLine, "#ClinicianCode#", ConstantsVariable.EMPTY_VALUE);
					newLine = TextUtil.replaceAll(newLine, "#Clinician#", admissiondoctor);
					newLine = TextUtil.replaceAll(newLine, "#AdmissionDate#", admissionDateTime);
					newLine = TextUtil.replaceAll(newLine, "#IntendedManagement#", ConstantsVariable.EMPTY_VALUE);
					newLine = TextUtil.replaceAll(newLine, "#ServicePoint#", ConstantsVariable.EMPTY_VALUE);
					newLine = TextUtil.replaceAll(newLine, "#AdministrativeCategory#", roomType);
					newLine = TextUtil.replaceAll(newLine, "#RoomCode#", ConstantsVariable.EMPTY_VALUE);
					newLine = TextUtil.replaceAll(newLine, "#BedCode#", bedNo);
					newLine = TextUtil.replaceAll(newLine, "#SlipNo#", ConstantsVariable.EMPTY_VALUE);
					newLine = TextUtil.replaceAll(newLine, "#InsurancePolicyNumber#", insurancePolicyNo);
					newLine = TextUtil.replaceAll(newLine, "#InsuranceCompany#", ConstantsVariable.EMPTY_VALUE);
					newLine = TextUtil.replaceAll(newLine, "#VoucherNo#", ConstantsVariable.EMPTY_VALUE);
					newLine = TextUtil.replaceAll(newLine, "#UserName#", updateUser);

					bw.writeBytes(newLine);
					bw.writeBytes("\n");
				}
				br.close();
				bw.close();

				// convert to pdf
				FileConvertor.createBatch(targetFilename);
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				try {
					if (br != null) { br.close(); }
				} catch (Exception e) {}
				try {
					if (bw != null) { bw.close(); }
				} catch (Exception e) {}
			} // end try
		}
	}

	// add by Abraham for VPC, 20160815 (VPC_SECURE, VPC_ACCESS, VPC_MERC, VPC_RETURN : begin
	public static ArrayList getVpcParams() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select ");
		sqlStr.append("(SELECT PARAM1 FROM SYSPARAM@IWEB where PARCDE = 'VPC_SECURE' ) vpc_secure, ");
		sqlStr.append("(SELECT PARAM1 FROM SYSPARAM@IWEB where PARCDE = 'VPC_ACCESS' ) vpc_access, ");
		sqlStr.append("(SELECT PARAM1 FROM SYSPARAM@IWEB where PARCDE = 'VPC_MERC' ) vpc_merc, ");
		sqlStr.append("(SELECT PARAM1 FROM SYSPARAM@IWEB where PARCDE = 'VPC_RETURN' ) vpc_return from dual ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	// end

// 20181002 Arran added for union pay
	public static ArrayList getUpopParams() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select ");
		sqlStr.append("(SELECT PARAM1 FROM SYSPARAM@IWEB where PARCDE = 'UPOP_MID' ) UPOP_MID, ");
		sqlStr.append("(SELECT PARAM1 FROM SYSPARAM@IWEB where PARCDE = 'UPOP_PFX' ) UPOP_PFX, ");
		sqlStr.append("(SELECT PARAM1 FROM SYSPARAM@IWEB where PARCDE = 'UPOP_PW' ) UPOP_PW, ");
		sqlStr.append("(SELECT PARAM1 FROM SYSPARAM@IWEB where PARCDE = 'UPOP_ENV' ) UPOP_ENV, ");
		sqlStr.append("(SELECT PARAM1 FROM SYSPARAM@IWEB where PARCDE = 'UPOP_RET' ) UPOP_RET from dual ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	// end

// 20181018 Arran added for union pay admin page
	public static String getUpopAdminURL() {
		String URL = null;

		ArrayList result = UtilDBWeb.getReportableList(
			"SELECT PARAM1 FROM SYSPARAM@IWEB where PARCDE = 'UPOP_ADMIN' ");

		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			URL = reportableListObject.getValue(0);
		}

		return URL;
	}

// 20181018 Arran added for Visa/Mastercard admin page
	public static String getVpcAdminURL() {
		String URL = null;

		ArrayList result = UtilDBWeb.getReportableList(
			"SELECT PARAM1 FROM SYSPARAM@IWEB where PARCDE = 'VPC_ADMIN' ");

		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			URL = reportableListObject.getValue(0);
		}

		return URL;
	}

// 20181002 Arran added
	public static String getStaffEmail(String type) {
		String email = null;
		ArrayList result = null;

		if ("out".equals(type))
			result = UtilDBWeb.getReportableList(
					"SELECT PARAM1 FROM SYSPARAM@IWEB where PARCDE = 'REGOUTMAIL' ");
		else
			result = UtilDBWeb.getReportableList(
					"SELECT PARAM1 FROM SYSPARAM@IWEB where PARCDE = 'REGINPMAIL' ");

		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			email = reportableListObject.getValue(0);
		}

		return email;
	}
	// end

	public static boolean updatePaymentMethod(String admissionID, String paymentType, String paymentTypeOther, String paymentCreditCardType, String paymentAmount, String insuranceRemarks, String paymentDeclare ) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("UPDATE HAT_PATIENT ");
		sqlStr.append("SET HAT_PAYMENT_TYPE = '" + paymentType + "', HAT_PAYMENT_TYPE_OTHER = '" + paymentTypeOther + "', HAT_PAYMENT_CREDIT_CARD_TYPE = '" + paymentCreditCardType + "', HAT_PAYMENT_AMOUNT = " + paymentAmount + ", HAT_INSURANCE_REMARKS = '" + insuranceRemarks + "' " + ", HAT_PATIENT_DECLARE = '" + paymentDeclare + "' " );
		sqlStr.append("WHERE HAT_ADMNO = " + admissionID + " ");

		//System.out.println(sqlStr.toString());
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}

	public static boolean updatePaymentReturn(String admissionID, String paymentStatus, String paymentRtncode, String paymentReceiptNo
			,String paymentCardType, String paymentTransNo, String paymentApprovalCode, String paymentTranAmt, String paymentTranCur ) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("UPDATE HAT_PATIENT ");
		sqlStr.append("SET HAT_PAYMENT_STATUS = '" + paymentStatus + "', HAT_PAYMENT_RTNCODE = '" + paymentRtncode + "' , HAT_PAYMENT_RECEIPT_NO = '" + paymentReceiptNo + "' " );
		sqlStr.append(", hat_payment_credit_card_type = '" + paymentCardType + "', hat_payment_trans_no = '" + paymentTransNo + "', hat_payment_approval_code = '" + paymentApprovalCode + "', hat_payment_date = sysdate " );
		sqlStr.append(", hat_payment_tran_amt = " + paymentTranAmt + ", hat_payment_tran_cur = '" + paymentTranCur + "'" );
		sqlStr.append("WHERE HAT_ADMNO = '" + admissionID + "' ");

		//System.out.println(sqlStr.toString());
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}


	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO HAT_PATIENT (");
		sqlStr.append("HAT_ADMNO, ");
		sqlStr.append("HAT_CREATED_USER, HAT_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ");
		sqlStr.append("?, ?)");
		sqlStr_insertAdmission = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO HAT_PATIENT (");
		sqlStr.append("HAT_ADMNO,HAT_ADMISSION_TYPE, ");
		sqlStr.append("HAT_CREATED_USER, HAT_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?,'O', ");
		sqlStr.append("?, ?)");
		sqlStr_insertOutAdmission = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE HAT_PATIENT ");
		sqlStr.append("SET    HAT_PATNO = ?, ");
		sqlStr.append("       HAT_PATFNAME = ?, HAT_PATGNAME = ?, HAT_PATCNAME = ?, HAT_TITDESC = ?, HAT_TITDESC_OTHER = ?, ");
		sqlStr.append("       HAT_PATIDNO = ?, HAT_PATPASSPORT = ?, HAT_DOCUMENT = ?, ");
		sqlStr.append("       HAT_PATSEX = ?, HAT_RACDESC = ?, HAT_RACDESC_OTHER = ?, HAT_RELIGIOUS = ?, HAT_RELIGIOUS_OTHER = ?, ");
		sqlStr.append("       HAT_PATBDATE = TO_DATE(?, 'dd/MM/YYYY'), HAT_PATMSTS = ?, HAT_PATMSTS_OTHER = ?, HAT_MOTHCODE = ?, HAT_MOTHCODE_OTHER = ?, HAT_EDULEVEL = ?, ");
		sqlStr.append("       HAT_PATHTEL = ?, HAT_PATOTEL = ?, HAT_PATMTEL = ?, HAT_PATFAXNO = ?, ");
		sqlStr.append("       HAT_OCCUPATION = ?, HAT_PATEMAIL = ?, ");
		sqlStr.append("       HAT_PATADD1 = ?, HAT_PATADD2 = ?, HAT_PATADD3 = ?, HAT_PATADD4 = ?, HAT_COUCODE = ?, HAT_COUDESC = ?, ");
		sqlStr.append("       HAT_PATKFNAME1 = ?, HAT_PATKGNAME1 = ?, HAT_PATKCNAME1 = ?, HAT_PATKSEX1 = ?, HAT_PATKRELA1 = ?, ");
		sqlStr.append("       HAT_PATKHTEL1 = ?, HAT_PATKOTEL1 = ?, HAT_PATKMTEL1 = ?, HAT_PATKPAGER1 = ?, ");
		sqlStr.append("       HAT_PATKEMAIL1 = ?, HAT_PATKADD11 = ?, HAT_PATKADD21 = ?, HAT_PATKADD31 = ?, HAT_PATKADD41 = ?, ");
		sqlStr.append("       HAT_PATKFNAME2 = ?, HAT_PATKGNAME2 = ?, HAT_PATKCNAME2 = ?, HAT_PATKSEX2 = ?, HAT_PATKRELA2 = ?, ");
		sqlStr.append("       HAT_PATKHTEL2 = ?, HAT_PATKOTEL2 = ?, HAT_PATKMTEL2 = ?, HAT_PATKPAGER2 = ?, ");
		sqlStr.append("       HAT_PATKEMAIL2 = ?, HAT_PATKADD12 = ?, HAT_PATKADD22 = ?, HAT_PATKADD32 = ?, HAT_PATKADD42 = ?, ");
		sqlStr.append("       HAT_EXPECTED_ADMISSION_DATE = TO_DATE(?, 'dd/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("       HAT_ACTUAL_ADMISSION_DATE = TO_DATE(?, 'dd/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("       HAT_ADMISSION_DOCTOR = ?, HAT_WARD = ?, HAT_ROOM_TYPE = ?, HAT_BED_NO = ?, HAT_PROMOTION_YN = ?, ");
		sqlStr.append("       HAT_PAYMENT_TYPE = ?, HAT_PAYMENT_TYPE_OTHER = ?, HAT_PAYMENT_CREDIT_CARD_TYPE = ?, HAT_INSURANCE_REMARKS = ?, HAT_INSURANCE_POLICY_NO = ?, ");
		sqlStr.append("       HAT_REMARKS = ?, ");
		sqlStr.append("       HAT_REGISTERED_BY = ?, ");
		sqlStr.append("       HAT_REACHED_BY = ?, ");
		sqlStr.append("       HAT_MODIFIED_DATE = SYSDATE, HAT_MODIFIED_USER = ? , HAT_INFOFORPROMOTION = ?, HAT_PATMKTSRC = ? ");
		sqlStr.append("WHERE  HAT_ADMNO = ? AND HAT_ENABLED = 1");
		sqlStr_updateAdmission = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("update HAT_PATIENT  ");
		sqlStr.append("set   ");
		sqlStr.append("HAT_PATNO = ?,        HAT_PATFNAME = ?, HAT_PATGNAME =   ?, HAT_PATCNAME =  ?, ");
		sqlStr.append("HAT_TITDESC =  ?, HAT_TITDESC_OTHER =  ?,        HAT_PATIDNO =  ?, HAT_PATPASSPORT =  ?, ");
		sqlStr.append("HAT_DOCUMENT = ?, HAT_PATSEX = ?, HAT_RACDESC = ?, HAT_RACDESC_OTHER =  ?, ");
		sqlStr.append("HAT_RELIGIOUS = ?, HAT_RELIGIOUS_OTHER = ?,        HAT_PATBDATE = TO_DATE( ?, 'dd/MM/YYYY'), ");
		sqlStr.append("HAT_PATMSTS =  ?, HAT_PATMSTS_OTHER = ?, HAT_MOTHCODE =  ?, HAT_EDULEVEL = ?,  ");
		sqlStr.append("HAT_EDULEVEL_OTHER = ? , HAT_PATHTEL = ?, ");
		sqlStr.append("HAT_PATOTEL = ?, HAT_PATMTEL = ?, HAT_PATFAXNO = ?, HAT_OCCUPATION = ?, HAT_PATEMAIL = ?, ");
		sqlStr.append("HAT_PATADD1 = ?, HAT_PATADD2 = ?, HAT_PATADD3 = ?, HAT_PATADD4 = ?, ");
		sqlStr.append("HAT_COUCODE = ?, HAT_COUDESC =  ?, ");
		sqlStr.append("HAT_PATKFNAME1 = ?, HAT_PATKGNAME1 = ?, HAT_PATKCNAME1 = ?, HAT_PATKRELA1 = ?, ");
		sqlStr.append("HAT_PATKHTEL1 = ?, HAT_PATKOTEL1 = ?, HAT_PATKMTEL1 = ?,   HAT_PATKEMAIL1 =  ?, ");
		sqlStr.append("HAT_PATKADD11 = ?, HAT_PATKADD21 = ?, HAT_PATKADD31 = ?, HAT_PATKADD41 = ?, ");
		sqlStr.append("HAT_PATKTITLEDESC1 = ?, HAT_PATKTITLEDESC_OTHER1 = ?, HAT_PATKCOUCODE1 = ?, ");
		sqlStr.append("HAT_PATKFNAME2 = ?, ");
		sqlStr.append("HAT_PATKGNAME2 = ?, HAT_PATKCNAME2 = ?,  HAT_PATKRELA2 = ?,        HAT_PATKHTEL2 = ?, ");
		sqlStr.append("HAT_PATKOTEL2 = ?, HAT_PATKMTEL2 = ?,  HAT_PATKEMAIL2 = ?, HAT_PATKADD12 = ?, ");
		sqlStr.append("HAT_PATKADD22 = ?, HAT_PATKADD32 = ?, HAT_PATKADD42 = ?, ");
		sqlStr.append("HAT_PATKTITLEDESC2 = ?, HAT_PATKTITLEDESC_OTHER2 = ?, HAT_PATKCOUCODE2 = ?, ");
		sqlStr.append("HAT_PROMOTION_YN = ?, ");
		sqlStr.append("HAT_REMARKS = ?, ");
		sqlStr.append("HAT_PATKCOUDESC1 = ?, ");
		sqlStr.append("HAT_PATKCOUDESC2 = ?, ");
		sqlStr.append("HAT_REGISTERED_BY = ?, HAT_REACHED_BY = ?, HAT_MODIFIED_DATE = sysdate, HAT_MODIFIED_USER = ?, ");
		sqlStr.append("HAT_EXPECTED_ADMISSION_DATE = TO_DATE(?, 'dd/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("HAT_ACTUAL_ADMISSION_DATE = TO_DATE(?, 'dd/MM/YYYY HH24:MI:SS'), HAT_ADMISSION_DOCTOR = ?, ");
		sqlStr.append("HAT_WAY_HEAR = ? , HAT_WAY_HEAR_OTHER = ? ");
		sqlStr.append("where  HAT_ADMNO = ? and HAT_ENABLED = 1 ");

		sqlStr_updateOutAdmission = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE HAT_PATIENT ");
		sqlStr.append("SET    HAT_PATNO = ?, ");
		sqlStr.append("       HAT_MODIFIED_DATE = SYSDATE, HAT_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  HAT_ADMNO = ? AND HAT_ENABLED = 1");
		sqlStr_updateAdmissionPatNo = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE HAT_PATIENT ");
		sqlStr.append("SET    HAT_SESSION_ID = ? ");
		sqlStr.append("WHERE  HAT_ADMNO = ? AND HAT_ENABLED = 1");
		sqlStr_updateAdmissionSessionID = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE HAT_PATIENT ");
		sqlStr.append("SET    HAT_HASIMTINFO = 'Y' ");
		sqlStr.append("WHERE  HAT_ADMNO = ? AND HAT_ENABLED = 1");
		sqlStr_updateHasImtInfo = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE HAT_PATIENT ");
		sqlStr.append("SET    HAT_ENABLED = 0, HAT_MODIFIED_DATE = SYSDATE, HAT_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  HAT_ADMNO = ? AND HAT_ENABLED = 1");
		sqlStr_cancelAdmission = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT HAT_ADMNO, ");
		sqlStr.append("       HAT_PATNO, HAT_PATFNAME, HAT_PATGNAME, HAT_PATCNAME, HAT_TITDESC, HAT_TITDESC_OTHER, ");
		sqlStr.append("       HAT_PATIDNO, HAT_PATPASSPORT, HAT_DOCUMENT, ");
		sqlStr.append("       HAT_PATSEX, HAT_RACDESC, HAT_RACDESC_OTHER, HAT_RELIGIOUS, HAT_RELIGIOUS_OTHER, ");
		sqlStr.append("       TO_CHAR(HAT_PATBDATE, 'dd/MM/YYYY'), HAT_PATMSTS, HAT_MOTHCODE, HAT_MOTHCODE_OTHER, HAT_EDULEVEL, ");
		sqlStr.append("       HAT_PATHTEL, HAT_PATOTEL, HAT_PATMTEL, HAT_PATFAXNO, ");
		sqlStr.append("       HAT_OCCUPATION, HAT_PATEMAIL, ");
		sqlStr.append("       HAT_PATADD1, HAT_PATADD2, HAT_PATADD3, HAT_PATADD4, HAT_COUCODE, HAT_COUDESC, ");
		sqlStr.append("       HAT_PATKFNAME1, HAT_PATKGNAME1, HAT_PATKCNAME1, HAT_PATKSEX1, HAT_PATKRELA1, ");
		sqlStr.append("       HAT_PATKHTEL1, HAT_PATKOTEL1, HAT_PATKMTEL1, HAT_PATKPAGER1, ");
		sqlStr.append("       HAT_PATKEMAIL1, HAT_PATKADD11, HAT_PATKADD21, HAT_PATKADD31, HAT_PATKADD41, ");
		sqlStr.append("       HAT_PATKFNAME2, HAT_PATKGNAME2, HAT_PATKCNAME2, HAT_PATKSEX2, HAT_PATKRELA2, ");
		sqlStr.append("       HAT_PATKHTEL2, HAT_PATKOTEL2, HAT_PATKMTEL2, HAT_PATKPAGER2, ");
		sqlStr.append("       HAT_PATKEMAIL2, HAT_PATKADD12, HAT_PATKADD22, HAT_PATKADD32, HAT_PATKADD42, ");
		sqlStr.append("       TO_CHAR(HAT_EXPECTED_ADMISSION_DATE, 'dd/MM/YYYY'), TO_CHAR(HAT_EXPECTED_ADMISSION_DATE, 'HH24:MI'), ");
		sqlStr.append("       TO_CHAR(HAT_ACTUAL_ADMISSION_DATE, 'dd/MM/YYYY'), TO_CHAR(HAT_ACTUAL_ADMISSION_DATE, 'HH24:MI'), ");
		sqlStr.append("       HAT_ADMISSION_DOCTOR, HAT_WARD, HAT_ROOM_TYPE, HAT_BED_NO, HAT_PROMOTION_YN, ");
		sqlStr.append("       HAT_PAYMENT_TYPE, HAT_PAYMENT_TYPE_OTHER, HAT_PAYMENT_CREDIT_CARD_TYPE, HAT_INSURANCE_REMARKS, HAT_INSURANCE_POLICY_NO, ");
		sqlStr.append("       HAT_EMAIL_CONFIRM_YN, TO_CHAR(HAT_EMAIL_CONFIRM_DATE, 'dd/MM/YYYY'), ");
		sqlStr.append("       HAT_REMARKS, TO_CHAR(HAT_CREATED_DATE, 'dd/MM/YYYY HH24:MI:SS'), HAT_CREATED_USER, HAT_MODIFIED_USER, ");
		sqlStr.append("       HAT_REACHED_BY, HAT_REGISTERED_BY,HAT_FIRSTVIEW_USER,HAT_FIRSTVIEW_DATE, ");
		sqlStr.append("       HAT_PATKCOUCODE1, HAT_PATKCOUDESC1, HAT_PATKCOUCODE2, HAT_PATKCOUDESC2, ");
		sqlStr.append("       HAT_PATMSTS_OTHER ,HAT_EDULEVEL_OTHER,HAT_PATKTITLEDESC1 ,HAT_PATKTITLEDESC_OTHER1, ");
		sqlStr.append("       HAT_PATKTITLEDESC2 ,HAT_PATKTITLEDESC_OTHER2, HAT_COMPLETED, HAT_WAY_HEAR, HAT_WAY_HEAR_OTHER, ");
		sqlStr.append("       HAT_INFOFORPROMOTION, HAT_PATMSTS_OTHER, ");
		sqlStr.append("       HAT_PAYMENT_STATUS, HAT_PAYMENT_RTNCODE, HAT_PAYMENT_RECEIPT_NO, HAT_PAYMENT_AMOUNT,");//99
		// for vpc ( END )
		sqlStr.append("       HAT_PATMKTSRC, UPPER(TO_CHAR(HAT_CREATED_DATE, 'dd mon YYYY', 'NLS_DATE_LANGUAGE=ENGLISH')), "); //103
		// for vpc (2 begin )
		sqlStr.append("       TO_CHAR( HAT_PAYMENT_DATE, 'Mon DD, YYYY HH24:MI', 'NLS_DATE_LANGUAGE=ENGLISH' ), HAT_TITDESC, decode(HAT_PAYMENT_TYPE, 'VISA_MASTER', HAT_PAYMENT_CREDIT_CARD_TYPE, 'UNION_PAY', HAT_PAYMENT_CREDIT_CARD_TYPE, HAT_PAYMENT_TYPE), HAT_PAYMENT_APPROVAL_CODE, "); //105
		sqlStr.append("       HAT_PAYMENT_TRAN_AMT, HAT_PAYMENT_TRAN_CUR, HAT_PAYMENT_TRANS_NO, HAT_PATIENT_DECLARE "); //112
		// for vpc (2 end )
		sqlStr.append("FROM   HAT_PATIENT ");
		sqlStr.append("WHERE  HAT_ENABLED = 1 ");
		sqlStr.append("AND    HAT_ADMNO = ? ");
		sqlStr_getAdmission = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE HAT_PATIENT ");
		sqlStr.append("SET    HAT_EMAIL_CONFIRM_YN = ?, HAT_EMAIL_CONFIRM_DATE = SYSDATE, ");
		sqlStr.append("       HAT_MODIFIED_DATE = SYSDATE, HAT_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  HAT_ADMNO = ? AND HAT_ENABLED = 1");
		sqlStr_emailNotification = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO HAT_PATIENT_DOCUMENTS ");
		sqlStr.append("(HAT_ADMNO, HAT_DOCUMENT_ID, HAT_DOCUMENT_DESC, ");
		sqlStr.append(" HAT_CREATED_USER, HAT_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ");
		sqlStr.append(" ?, ?)");
		sqlStr_insertDocumentAction = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO HAT_PATIENT_IMTINFO ( ");
		sqlStr.append("HAT_ADMNO, HAT_IMTINFO_ID, ");
		sqlStr.append("HAT_CREATED_USER, HAT_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?,?, ");
		sqlStr.append("?, ?)");
		sqlStr_insertImtInfo = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT DISTINCT HAT_IMTINFO_ID, ");
		sqlStr.append("HAT_ADMNO ");
		sqlStr.append("FROM HAT_PATIENT_IMTINFO ");
		sqlStr.append("WHERE HAT_ADMNO = ?  ");
		sqlStr_getImtInfo = sqlStr.toString();

	}
}