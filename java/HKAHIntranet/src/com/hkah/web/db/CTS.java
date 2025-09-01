package com.hkah.web.db;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Vector;

import com.hkah.config.MessageResources;
import com.hkah.constant.ConstantsErrorMessage;
import com.hkah.constant.ConstantsServerSide;
import com.hkah.fop.CoverLetterReapplication;
import com.hkah.fop.InactiveNoticeLetter;
import com.hkah.util.TextUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class CTS {
	private static String DEFAULT_EMAIL_HKAH = "medicalaffairs@hkah.org.hk";
	private static String DEFAULT_EMAIL_TWAH = "medicalaffairs@twah.org.hk";
	private static String sqlStr_insertDocMap = null;
//	private static String sqlStr_insertCtsLog = null;
	private static String sqlStr_insertApprovalStatus = null;
	private static String sqlStr_updateDocCodeCtsRecord = null;

	private static String getDefaultEmail() {
		if (ConstantsServerSide.isTWAH()) {
			return DEFAULT_EMAIL_TWAH;
		} else {
			return DEFAULT_EMAIL_HKAH;
		}
	}

	public static ArrayList getTestRecord(String docNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("rownum, ");
		sqlStr.append("cr.ctsNo, ");
		sqlStr.append("cr.doccode, ");
		sqlStr.append("cr.record_type ");
		sqlStr.append("FROM cts_record cr ");
		if (docNo != null && docNo.length() > 0) {
			sqlStr.append("WHERE cr.doccode = '");
			sqlStr.append(docNo);
			sqlStr.append("' ");
		}
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList deleteTestRecord(String ctsNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("DELETE FROM cts_record ");
		if (ctsNo != null && ctsNo.length() > 0) {
			sqlStr.append("WHERE cts_no = '");
			sqlStr.append(ctsNo);
			sqlStr.append("' ");
		}
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getRecord(String docNo, String recType, String recStatus, String docFname, String docGname) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("cr.cts_no, ");
		sqlStr.append("cr.doccode, doc.docfname || ' ' || doc.docgname AS docname, ");
		sqlStr.append("(SELECT s.spcname FROM spec@iweb s WHERE s.spccode = doc.spccode) AS specialty, ");
		if ("N".equals(recType)) {
			sqlStr.append("null, null, ");
		} else {
			sqlStr.append("TO_CHAR(doc.docsdate,'DD/MM/YYYY'), ");
			sqlStr.append("TO_CHAR(doc.doctdate,'DD/MM/YYYY'), ");
		}
		sqlStr.append("doc.docemail, ");
		sqlStr.append("cr.record_type, ");
		sqlStr.append("cr.record_status, ");
		sqlStr.append("cr.last_stncdate, ");
		sqlStr.append("cr.password, ");
		sqlStr.append("TO_CHAR(cr.insert_date,'DD/MM/YYYY'), ");
		sqlStr.append("TO_CHAR(cr.modified_date,'DD/MM/YYYY'), ");
		sqlStr.append("cr.assign_approver, ");
		if ("N".equals(recType)) {
			sqlStr.append("null ");
			sqlStr.append("FROM cts_record cr, cts_doctor_new doc ");
			sqlStr.append("WHERE cr.cts_no = doc.cts_no ");
		} else {
			if (docNo != null && docNo.length() > 0) {
				sqlStr.append("sra.record_status ");
				sqlStr.append("FROM cts_record cr ");
				sqlStr.append("INNER JOIN cts_doctor doc ON cr.doccode = doc.doccode ");
				sqlStr.append("LEFT JOIN cts_record_approver sra ON cr.cts_no = sra.cts_no AND sra.assign_approver = '");
				sqlStr.append(docNo);
				sqlStr.append("' ");
				sqlStr.append("WHERE cr.record_type IN ('N', 'R') ");
			} else {
				sqlStr.append("null ");
				sqlStr.append("FROM cts_record cr ");
				sqlStr.append("INNER JOIN cts_doctor doc ON cr.doccode = doc.doccode ");
				sqlStr.append("WHERE cr.record_type IN ('N', 'R') ");
			}
		}
		if ((docNo != null && docNo.length() > 0) ||
		   (recType != null && recType.length() > 0) ||
		   (recStatus != null && recStatus.length() > 0) ||
		   (docFname != null && docFname.length() > 0) ||
		   (docGname != null && docGname.length() > 0)) {
			if (docNo != null && docNo.length() > 0) {
				sqlStr.append("AND cr.doccode = '");
				sqlStr.append(docNo);
				sqlStr.append("' ");
			}
			if (recType != null && recType.length() > 0) {
				sqlStr.append("AND cr.record_type = '");
				sqlStr.append(recType);
				sqlStr.append("' ");
			}
			if (recStatus != null && recStatus.length() > 0) {
				sqlStr.append("AND cr.record_status = '");
				sqlStr.append(recStatus);
				sqlStr.append("' ");
			}
			if (docFname != null && docFname.length() > 0) {
				sqlStr.append("AND UPPER(doc.docfname) LIKE UPPER('%");
				sqlStr.append(docFname);
				sqlStr.append("%') ");
			}
			if (docGname != null && docGname.length() > 0) {
				sqlStr.append("AND UPPER(doc.docgname) LIKE UPPER('%");
				sqlStr.append(docGname);
				sqlStr.append("%') ");
			}
		} else {
			sqlStr.append("AND cr.record_status NOT IN ('A','J','D') ");
		}
		sqlStr.append(" ORDER BY cr.doccode ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getNewCTSRecord(String docNo, String recType, String recStatus, String docFname, String docGname) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("DISTINCT crn.cts_no, ");
		sqlStr.append("crn.doccode,crn.docfname||' '||crn.docgname AS docname, ");
		sqlStr.append("(SELECT s.spcname FROM spec@iweb s WHERE s.spccode = crn.spccode) AS specialty, ");
		sqlStr.append("null,crn.docLicNo1, ");
		sqlStr.append("crn.docemail, ");
		sqlStr.append("crn.record_type, ");
		sqlStr.append("crn.record_status, ");
		sqlStr.append("null, "); //last_stncdate
		sqlStr.append("null, "); //crn.password
		sqlStr.append("(SELECT TO_CHAR(MIN(crl.insert_date),'DD/MM/YYYY') FROM cts_record_log crl WHERE crn.cts_no = crl.cts_no), ");
		sqlStr.append("null, ");
		sqlStr.append("null ");
		sqlStr.append("FROM CTS_DOCTOR_NEW crn ");
		sqlStr.append("WHERE 1 = 1 ");
		if ((docNo != null && docNo.length() > 0) ||
		   (recType != null && recType.length() > 0) ||
		   (recStatus != null && recStatus.length() > 0) ||
		   (docFname != null && docFname.length() > 0) ||
		   (docGname != null && docGname.length() > 0)) {
			if (docNo != null && docNo.length() > 0) {
				sqlStr.append("AND crn.doccode = '");
				sqlStr.append(docNo);
				sqlStr.append("' ");
			}
			if (recType != null && recType.length() > 0) {
				sqlStr.append("AND crn.record_type = '");
				sqlStr.append(recType);
				sqlStr.append("' ");
			}
			if (recStatus != null && recStatus.length() > 0) {
				sqlStr.append("AND crn.record_status = '");
				sqlStr.append(recStatus);
				sqlStr.append("' ");
			}
			if (docFname != null && docFname.length() > 0) {
				sqlStr.append("AND UPPER(doc.docfname) LIKE UPPER('%");
				sqlStr.append(docFname);
				sqlStr.append("%') ");
			}
			if (docGname != null && docGname.length() > 0) {
				sqlStr.append("AND UPPER(doc.docgname) LIKE UPPER('%");
				sqlStr.append(docGname);
				sqlStr.append("%') ");
			}
		} else {
			sqlStr.append("AND crn.record_status NOT IN ('A','J','D') ");
		}
		sqlStr.append(" ORDER BY crn.doccode, crn.cts_no ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getRecordWithApp(String docNo, String recType, String recStatus, String docFname, String docGname) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("cr.cts_no, ");
		sqlStr.append("cr.doccode,doc.docfname||' '||doc.docgname AS docname, ");
		sqlStr.append("(SELECT s.spcname FROM spec@iweb s WHERE s.spccode = doc.spccode) AS specialty, ");
		if ("N".equals(recType)) {
			sqlStr.append("null, ");
			sqlStr.append("null, ");
		} else {
			sqlStr.append("TO_CHAR(doc.docsdate,'DD/MM/YYYY'), ");
			sqlStr.append("TO_CHAR(doc.doctdate,'DD/MM/YYYY'), ");
		}
		sqlStr.append("doc.docemail, ");
		sqlStr.append("cr.record_type, ");
		sqlStr.append("cr.record_status, ");
		sqlStr.append("cr.last_stncdate, ");
		sqlStr.append("cr.password, ");
		sqlStr.append("TO_CHAR(cr.insert_date,'DD/MM/YYYY'), ");
		sqlStr.append("TO_CHAR(cr.modified_date,'DD/MM/YYYY'), ");
		sqlStr.append("cr.assign_approver ");
		if ("N".equals(recType)) {
			sqlStr.append("null ");
			sqlStr.append("FROM cts_record cr, cts_doctor_new doc ");
			sqlStr.append("WHERE cr.cts_no = doc.cts_no ");
		} else {
			if (docNo != null && docNo.length() > 0) {
				sqlStr.append("sra.record_status ");
				sqlStr.append("FROM cts_record cr ");
				sqlStr.append("INNER JOIN cts_doctor doc ON cr.doccode = doc.doccode ");
				sqlStr.append("LEFT JOIN cts_record_approver sra ON cr.cts_no = sra.cts_no AND sra.assign_approver = '");
				sqlStr.append(docNo);
				sqlStr.append("' ");
				sqlStr.append("WHERE cr.record_type IN ('N', 'R') ");
			} else {
				sqlStr.append("null ");
				sqlStr.append("FROM cts_record cr ");
				sqlStr.append("INNER JOIN cts_doctor doc ON cr.doccode = doc.doccode ");
				sqlStr.append("WHERE cr.record_type IN ('N', 'R') ");
			}
		}
		sqlStr.append("AND cr.record_status = '");
		sqlStr.append(recStatus);
		sqlStr.append("' ");
		if ((docNo != null && docNo.length() > 0) ||
		   (recType != null && recType.length() > 0) ||
		   (recStatus != null && recStatus.length() > 0) ||
		   (docFname != null && docFname.length() > 0) ||
		   (docGname != null && docGname.length() > 0)) {
			if (docNo != null && docNo.length() > 0) {
				sqlStr.append("AND cr.doccode = '");
				sqlStr.append(docNo);
				sqlStr.append("' ");
			}
			if (recType != null && recType.length() > 0) {
				sqlStr.append("AND cr.record_type = '");
				sqlStr.append(recType);
				sqlStr.append("' ");
			}
			if (docFname != null && docFname.length() > 0) {
				sqlStr.append("AND UPPER(doc.docfname) LIKE UPPER('%");
				sqlStr.append(docFname);
				sqlStr.append("%') ");
			}
			if (docGname != null && docGname.length() > 0) {
				sqlStr.append("AND UPPER(doc.docgname) LIKE UPPER('%");
				sqlStr.append(docGname);
				sqlStr.append("%') ");
			}
		} else {
			sqlStr.append("AND cr.record_status NOT IN ('A','J','D') ");
		}

		sqlStr.append(" ORDER BY cr.doccode ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getRecord(String recStatus, String recSpec) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("cr.cts_no, ");
		sqlStr.append("cr.doccode,doc.docfname||' '||doc.docgname AS docname, ");
		sqlStr.append("(SELECT s.spcname FROM spec@iweb s WHERE s.spccode = doc.spccode) AS specialty, ");
		sqlStr.append("cr.record_status, ");
		sqlStr.append("cr.assign_approver ");
		sqlStr.append(" FROM cts_record cr, cts_doctor doc ");
		sqlStr.append(" WHERE cr.doccode = doc.doccode ");
		sqlStr.append(" AND cr.record_status NOT IN ('N','J','D','U','P','E') ");
		if (recSpec != null && recSpec.length() > 0||
		   (recStatus != null && recStatus.length() > 0)) {
			if (recStatus != null && recStatus.length() > 0) {
				sqlStr.append("AND cr.record_status = '");
				sqlStr.append(recStatus);
				sqlStr.append("' ");
			}
			if (recSpec != null && recSpec.length() > 0) {
				sqlStr.append("AND doc.spccode = '");
				sqlStr.append(recSpec);
				sqlStr.append("' ");
			}
		} else {
			sqlStr.append("AND cr.record_status NOT IN ('A','J','D') ");
		}
		sqlStr.append(" ORDER BY cr.doccode ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getRecord(String ctsNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("cr.cts_no, ");
		sqlStr.append("cr.doccode,doc.docfname||' '||doc.docgname AS docname, ");
		sqlStr.append("(SELECT s.spcname FROM spec@iweb s WHERE s.spccode = doc.spccode) AS specialty, ");
		sqlStr.append("TO_CHAR(doc.docsdate,'DD/MM/YYYY'), ");
		sqlStr.append("TO_CHAR(doc.doctdate,'DD/MM/YYYY'), ");
		sqlStr.append("doc.docemail, ");
		sqlStr.append("cr.record_type, ");
		sqlStr.append("cr.record_status, ");
		sqlStr.append("cr.last_stncdate, ");
		sqlStr.append("cr.password, ");
		sqlStr.append("TO_CHAR(cr.insert_date,'DD/MM/YYYY'), ");
		sqlStr.append("TO_CHAR(cr.modified_date,'DD/MM/YYYY'), ");
		sqlStr.append("cr.assign_approver ");
		sqlStr.append("FROM cts_record cr, cts_doctor doc ");
		sqlStr.append("WHERE cr.doccode = doc.doccode ");
		if (ctsNo != null && ctsNo.length() > 0) {
			sqlStr.append("AND cr.cts_no = '");
			sqlStr.append(ctsNo);
			sqlStr.append("' ");
		}
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getDocList (String cts_no) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("DOCTOR.DOCCODE, ");
		sqlStr.append("DOCTOR.DOCFNAME, ");
		sqlStr.append("DOCTOR.DOCGNAME, ");
		sqlStr.append("DOCTOR.DOCSEX, ");
		sqlStr.append("DOCTOR.SPCCODE, ");
		sqlStr.append("DOCTOR.DOCEMAIL, ");
		sqlStr.append("TO_CHAR(DOCTOR.DOCSDATE,'DD/MM/YYYY'), ");
		sqlStr.append("TO_CHAR(DOCTOR.DOCTDATE,'DD/MM/YYYY'), ");
		sqlStr.append("DOCTOR.ISOTSURGEON, ");
		sqlStr.append("TO_CHAR(CTS_RECORD.INIT_CONTRACT_DATE,'DD/MM/YYYY'), ");
		sqlStr.append("DOCTOR.DOCCNAME, ");
		sqlStr.append("DOCTOR.DOCADD1, ");
		sqlStr.append("DOCTOR.DOCADD2, ");
		sqlStr.append("DOCTOR.DOCADD3, ");
		sqlStr.append("DOCTOR.DOCADD4, ");
		sqlStr.append("DOCTOR.DOCOFFADD1, ");
		sqlStr.append("DOCTOR.DOCOFFADD2, ");
		sqlStr.append("DOCTOR.DOCOFFADD3, ");
		sqlStr.append("DOCTOR.DOCOFFADD4, ");
		sqlStr.append("DOCTOR.DOCHOMADD1, ");
		sqlStr.append("DOCTOR.DOCHOMADD2, ");
		sqlStr.append("DOCTOR.DOCHOMADD3, ");
		sqlStr.append("DOCTOR.DOCHOMADD4, ");
		sqlStr.append("DOCTOR.DOCOTEL, ");
		sqlStr.append("DOCTOR.DOCFAXNO, ");
		sqlStr.append("DOCTOR.DOCPTEL, ");
		sqlStr.append("DOCTOR.DOCMTEL, ");
		sqlStr.append("DOCTOR.DOCHTEL, ");
		sqlStr.append("CTS_RECORD.HEALTH_STATUS, ");
		sqlStr.append("DOCTOR.DOCIDNO, ");
		sqlStr.append("CTS_RECORD.FOLDER_ID, ");
		sqlStr.append("CTS_RECORD.HKMC_LICNO, ");
		sqlStr.append("TO_CHAR(CTS_RECORD.HKMC_LIC_EXPDATE,'DD/MM/YYYY'), ");
		sqlStr.append("CTS_RECORD.MICD_INS_CARRIER, ");
		sqlStr.append("TO_CHAR(CTS_RECORD.MICD_INS_EXPDATE,'DD/MM/YYYY'), ");
		sqlStr.append("CTS_RECORD.RECORD_TYPE ");
		sqlStr.append("FROM (");
		sqlStr.append("SELECT ");
		sqlStr.append("doccode,docfname,docgname,doccname,docidno,docsex,spccode,docsts,doctype,");
		sqlStr.append("docpct_i,docpct_o,docpct_d,docadd1,docadd2,docadd3,dochtel,docotel,docptel,");
		sqlStr.append("doctslot,docquali,doctdate,docsdate,dochomadd1,dochomadd2,dochomadd3,docoffadd1,docoffadd2,docoffadd3,");
		sqlStr.append("doccsholy,docmtel,docemail,docfaxno,dochomadd4,docadd4,docoffadd4,docpicklist,usrid,");
		sqlStr.append("docqualify,docbdate,rptto,isdoctor,tittle,isotsurgeon,isotanesthetist,showprofile,");
		sqlStr.append("dayinstruction,inpinstruction,oupinstruction,payinstruction,1brno,docremark,");
		sqlStr.append("cpsdate,apldate,mpscdate,sldate,isotendoscopist ");
		sqlStr.append("FROM doctor@iweb doc ");
		sqlStr.append("WHERE NOT EXISTS (");
		sqlStr.append("SELECT 1 FROM cts_doctor cd ");
		sqlStr.append("WHERE cd.doccode = doc.doccode) ");
		sqlStr.append("UNION ");
		sqlStr.append("SELECT ");
		sqlStr.append("doccode,docfname,docgname,doccname,docidno,docsex,spccode,docsts,doctype, ");
		sqlStr.append("docpct_i,docpct_o,docpct_d,docadd1,docadd2,docadd3,dochtel,docotel,docptel, ");
		sqlStr.append("doctslot,docquali,doctdate,docsdate,dochomadd1,dochomadd2,dochomadd3,docoffadd1,docoffadd2,docoffadd3, ");
		sqlStr.append("doccsholy,docmtel,docemail,docfaxno,dochomadd4,docadd4,docoffadd4,docpicklist,usrid, ");
		sqlStr.append("docqualify,docbdate,rptto,isdoctor,tittle,isotsurgeon,isotanesthetist,showprofile, ");
		sqlStr.append("dayinstruction,inpinstruction,oupinstruction,payinstruction,1brno,docremark, ");
		sqlStr.append("cpsdate,apldate,mpscdate,sldate,isotendoscopist ");
		sqlStr.append("FROM CTS_DOCTOR ");
		sqlStr.append(") doctor, CTS_RECORD ");
		sqlStr.append("WHERE DOCTOR.DOCCODE = CTS_RECORD.DOCCODE ");
		sqlStr.append("AND CTS_RECORD.CTS_NO = '");
		sqlStr.append(cts_no);
		sqlStr.append("'");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getDocList1 (String docCode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append(" a.doccode, ");
		sqlStr.append(" a.docfname, ");
		sqlStr.append(" a.docgname, ");
		sqlStr.append(" a.docsex, ");
		sqlStr.append(" a.spccode, ");
		sqlStr.append(" a.docemail, ");
		sqlStr.append(" a.docadd1||' '||a.docadd2||' '||a.docadd3, ");
		sqlStr.append(" a.docsdate, ");
		sqlStr.append(" a.doctdate, ");
		sqlStr.append(" a.isotsurgeon, ");
		sqlStr.append(" a.spccode ");
		sqlStr.append("FROM ");
		sqlStr.append("(SELECT ");
		sqlStr.append("  DOCCODE, DOCFNAME, DOCGNAME, DOCCNAME, DOCIDNO, DOCSEX, SPCCODE, ");
		sqlStr.append("  DOCSTS, DOCTYPE, DOCPCT_I, DOCPCT_O, DOCPCT_D, DOCADD1, DOCADD2, DOCADD3, ");
		sqlStr.append("  DOCHTEL, DOCOTEL, DOCPTEL, DOCTSLOT, DOCQUALI, DOCTDATE, DOCSDATE, ");
		sqlStr.append("  DOCHOMADD1, DOCHOMADD2, DOCHOMADD3, DOCOFFADD1, DOCOFFADD2, DOCOFFADD3, ");
		sqlStr.append("  DOCCSHOLY, DOCMTEL, DOCEMAIL, DOCFAXNO, DOCHOMADD4, DOCADD4, DOCOFFADD4, ");
		sqlStr.append("  DOCPICKLIST, USRID, DOCQUALIFY, DOCBDATE, RPTTO, ISDOCTOR, TITTLE, ISOTSURGEON, ");
		sqlStr.append("  ISOTANESTHETIST, SHOWPROFILE, DAYINSTRUCTION, INPINSTRUCTION, OUPINSTRUCTION, ");
		sqlStr.append("  PAYINSTRUCTION, BRNO, DOCREMARK, CPSDATE, APLDATE, MPSCDATE, SLDATE, ISOTENDOSCOPIST ");
		sqlStr.append("FROM doctor@iweb doc ");
		sqlStr.append("WHERE NOT EXISTS (");
		sqlStr.append(" SELECT 1 FROM cts_doctor cd ");
		sqlStr.append(" WHERE cd.doccode = doc.doccode) ");
		sqlStr.append("UNION ");
		sqlStr.append(" SELECT ");
		sqlStr.append("  DOCCODE, DOCFNAME, DOCGNAME, DOCCNAME, DOCIDNO, DOCSEX, SPCCODE, ");
		sqlStr.append("  DOCSTS, DOCTYPE, DOCPCT_I, DOCPCT_O, DOCPCT_D, DOCADD1, DOCADD2, DOCADD3, ");
		sqlStr.append("  DOCHTEL, DOCOTEL, DOCPTEL, DOCTSLOT, DOCQUALI, DOCTDATE, DOCSDATE, ");
		sqlStr.append("  DOCHOMADD1, DOCHOMADD2, DOCHOMADD3, DOCOFFADD1, DOCOFFADD2, DOCOFFADD3, ");
		sqlStr.append("  DOCCSHOLY, DOCMTEL, DOCEMAIL, DOCFAXNO, DOCHOMADD4, DOCADD4, DOCOFFADD4, ");
		sqlStr.append("  DOCPICKLIST, USRID, DOCQUALIFY, DOCBDATE, RPTTO, ISDOCTOR, TITTLE, ISOTSURGEON, ");
		sqlStr.append("  ISOTANESTHETIST, SHOWPROFILE, DAYINSTRUCTION, INPINSTRUCTION, OUPINSTRUCTION, ");
		sqlStr.append("  PAYINSTRUCTION, BRNO, DOCREMARK, CPSDATE, APLDATE, MPSCDATE, SLDATE, ISOTENDOSCOPIST ");
		sqlStr.append(" FROM cts_doctor) a ");
		sqlStr.append(" WHERE a.doccode = '");
		sqlStr.append(docCode);
		sqlStr.append("'");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

/*
	public static ArrayList getDocList1 (String docCode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("a.cts_no, ");
		sqlStr.append("a.docfname, ");
		sqlStr.append("a.docgname, ");
		sqlStr.append("a.docsex, ");
		sqlStr.append("a.spccode, ");
		sqlStr.append("a.docemail, ");
		sqlStr.append("b.HKMC_LICNO ");
		sqlStr.append("FROM CTS_DOCTOR_NEW a, cts_record b ");
		sqlStr.append("WHERE a.cts_no = b.cts_no");
		sqlStr.append("AND b.doccode = 'N999'");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
*/

	public static ArrayList getDocList2 (String docCode, String docfName, String docgName) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("a.doccode, ");
		sqlStr.append("a.docfname, ");
		sqlStr.append("a.docgname, ");
		sqlStr.append("a.docsex, ");
		sqlStr.append("(SELECT s.spcname FROM spec@iweb s WHERE s.spccode = a.spccode), ");
		sqlStr.append("a.docemail, ");
		sqlStr.append("TO_CHAR(a.docsdate,'DD/MM/YYYY') AS docsdate, ");
		sqlStr.append("TO_CHAR(a.doctdate,'DD/MM/YYYY') AS doctdate, ");
		sqlStr.append("a.isotsurgeon, ");
		sqlStr.append("a.spccode, ");
		sqlStr.append("a.recfrom ");
		sqlStr.append("FROM ");
		sqlStr.append("(SELECT ");
		sqlStr.append("DOCCODE, DOCFNAME, DOCGNAME, DOCCNAME, DOCIDNO, DOCSEX, SPCCODE, ");
		sqlStr.append("DOCSTS, DOCTYPE, DOCPCT_I, DOCPCT_O, DOCPCT_D, DOCADD1, DOCADD2, DOCADD3, ");
		sqlStr.append("DOCHTEL, DOCOTEL, DOCPTEL, DOCTSLOT, DOCQUALI, DOCTDATE, DOCSDATE, ");
		sqlStr.append("DOCHOMADD1, DOCHOMADD2, DOCHOMADD3, DOCOFFADD1, DOCOFFADD2, DOCOFFADD3, ");
		sqlStr.append("DOCCSHOLY, DOCMTEL, DOCEMAIL, DOCFAXNO, DOCHOMADD4, DOCADD4, DOCOFFADD4, ");
		sqlStr.append("DOCPICKLIST, USRID, DOCQUALIFY, DOCBDATE, RPTTO, ISDOCTOR, TITTLE, ISOTSURGEON, ");
		sqlStr.append("ISOTANESTHETIST, SHOWPROFILE, DAYINSTRUCTION, INPINSTRUCTION, OUPINSTRUCTION, ");
		sqlStr.append("PAYINSTRUCTION, BRNO, DOCREMARK, CPSDATE, APLDATE, MPSCDATE, SLDATE, ISOTENDOSCOPIST, 'HATS' AS RECFROM ");
		sqlStr.append("FROM doctor@iweb doc ");
		sqlStr.append("WHERE NOT EXISTS (SELECT 1 FROM CTS_DOCTOR CTSDOC WHERE DOC.DOCCODE = CTSDOC.DOCCODE) ");
		if (docCode != null && docCode.length() > 0) {
			sqlStr.append("AND UPPER(DOCCODE) = UPPER('");
			sqlStr.append(docCode);
			sqlStr.append("') ");
		}
		if (docfName != null && docfName.length() > 0) {
			sqlStr.append("AND UPPER(DOCFNAME) = UPPER('");
			sqlStr.append(docfName);
			sqlStr.append("') ");
		}
		if (docgName != null && docgName.length() > 0) {
			sqlStr.append("AND UPPER(DOCGNAME) = UPPER('");
			sqlStr.append(docgName);
			sqlStr.append("') ");
		}
		sqlStr.append(" UNION ");
		sqlStr.append("SELECT ");
		sqlStr.append("DOCCODE, DOCFNAME, DOCGNAME, DOCCNAME, DOCIDNO, DOCSEX, SPCCODE, ");
		sqlStr.append("DOCSTS, DOCTYPE, DOCPCT_I, DOCPCT_O, DOCPCT_D, DOCADD1, DOCADD2, DOCADD3, ");
		sqlStr.append("DOCHTEL, DOCOTEL, DOCPTEL, DOCTSLOT, DOCQUALI, DOCTDATE, ");
		sqlStr.append("DOCSDATE, DOCHOMADD1, DOCHOMADD2, DOCHOMADD3, DOCOFFADD1, DOCOFFADD2, DOCOFFADD3, ");
		sqlStr.append("DOCCSHOLY, DOCMTEL, DOCEMAIL, DOCFAXNO, DOCHOMADD4, DOCADD4, DOCOFFADD4, ");
		sqlStr.append("DOCPICKLIST, USRID, DOCQUALIFY, DOCBDATE, RPTTO, ISDOCTOR, TITTLE, ISOTSURGEON, ");
		sqlStr.append("ISOTANESTHETIST, SHOWPROFILE, DAYINSTRUCTION, INPINSTRUCTION, OUPINSTRUCTION, ");
		sqlStr.append("PAYINSTRUCTION, BRNO, DOCREMARK, CPSDATE, APLDATE, MPSCDATE, SLDATE, ISOTENDOSCOPIST, 'PORTAL' AS RECFROM  ");
		sqlStr.append("FROM cts_doctor ");
		sqlStr.append("WHERE 1 = 1 ");
		if (docCode != null && docCode.length() > 0) {
			sqlStr.append("AND UPPER(DOCCODE) = UPPER('");
			sqlStr.append(docCode);
			sqlStr.append("') ");
		}
		if (docfName != null && docfName.length() > 0) {
			sqlStr.append("AND UPPER(DOCFNAME) = UPPER('");
			sqlStr.append(docfName);
			sqlStr.append("') ");
		}
		if (docgName != null && docgName.length() > 0) {
			sqlStr.append("AND UPPER(DOCGNAME) = UPPER('");
			sqlStr.append(docgName);
			sqlStr.append("') ");
		}
		sqlStr.append(") a");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getNewDocDtl (String ctsNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CDN.CTS_NO,CDN.DOCFNAME,CDN.DOCGNAME,CDN.DOCSEX,CDN.SPCCODE,CDN.DOCEMAIL,CR.HKMC_LICNO,CDN.DOCCNAME,");
		sqlStr.append("CDN.DOCADD1,CDN.DOCADD2,CDN.DOCADD3,CDN.DOCADD4,CDN.DOCHOMADD1,CDN.DOCHOMADD2,CDN.DOCHOMADD3,CDN.DOCHOMADD4,");
		sqlStr.append("CDN.DOCOTEL,CDN.DOCFAXNO,CDN.DOCPTEL,CDN.DOCMTEL,CDN.DOCHTEL,CDN.ISOTSURGEON,");
		sqlStr.append("CR.HEALTH_STATUS,CR.HKMC_LICNO,CR.MICD_INS_CARRIER,TO_CHAR(CR.HKMC_LIC_EXPDATE,'dd/mm/yyyy'),TO_CHAR(CR.MICD_INS_EXPDATE,'dd/mm/yyyy'),CR.RECORD_STATUS ");
		sqlStr.append("FROM CTS_DOCTOR_NEW CDN, CTS_RECORD CR ");
		sqlStr.append("WHERE CDN.CTS_NO = CR.CTS_NO ");
//		sqlStr.append("AND CR.RECORD_STATUS = 'S' ");
		if (!("null".equals(ctsNo) || ctsNo==null || ctsNo=="")) {
			sqlStr.append("AND CR.CTS_NO ='");
			sqlStr.append(ctsNo);
			sqlStr.append("'");
		}
		sqlStr.append(" ORDER BY CDN.CTS_NO DESC");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getNewCTSDtl(String ctsNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CTS_NO, DOCCODE, RECORD_TYPE, RECORD_STATUS, DOCFNAME, DOCGNAME, DOCCNAME, DOCSEX, DOCIDNO, DOCMSTS,");
		sqlStr.append("SPCCODE, DOCADD1, DOCADD2, DOCADD3, DOCADD4, DOCHOMADD1, DOCHOMADD2, DOCHOMADD3, DOCHOMADD4, DOCEMAIL, DOCPTEL,");
		sqlStr.append("DOCMTEL, DOCHTEL, DOCOTEL, DOCFAXNO, DOCACADEMIC1, DOCACADEMIC2, DOCDEGREE1, DOCDEGREE2, DOCACADEMICDATE1, DOCACADEMICDATE2,");
		sqlStr.append("DOCSPECQUAL, DOCSPECQUALSINCE, DOCSPECQUALHOSPITAL1, DOCSPECQUALHOSPITAL2, DOCSPECQUALDATEFROM1, DOCSPECQUALDATEFROM2, DOCSPECQUALDATETO1, DOCSPECQUALDATETO2, MEDINFO, DOCPREVPRACTICEADDR1,");
		sqlStr.append("DOCPREVPRACTICEADDR2, DOCPREVPRACTICEFROM1, DOCPREVPRACTICEFROM2, DOCPREVPRACTICETO1,DOCPREVPRACTICETO2,DOCMEMPROSOC1, DOCMEMPROSOC2, DOCMEMPROSOCSTATUS1, DOCMEMPROSOCSTATUS2, DOCMEMPROSOCYEAR1,");
		sqlStr.append(" DOCMEMPROSOCYEAR2,DOCACADEMYOFMED1, DOCACADEMYOFMED2, DOCACADEMYOFMEDSTATUS1, DOCACADEMYOFMEDSTATUS2, DOCACADEMYOFMEDYEAR1,DOCACADEMYOFMEDYEAR2, DOCLICNO1, DOCLICNO2, TO_CHAR(DOCLICEXPDATE1,'DD/MM/YYYY'), ");
		sqlStr.append("TO_CHAR(DOCLICEXPDATE2,'DD/MM/YYYY'),DOCINSURECARR, TO_CHAR(DOCINSURECARREXPDATE,'DD/MM/YYYY'), DOCPROFREF1, DOCPROFREF2, DOCPROFREF3, DOCPROFREFCONTACT1,");
		sqlStr.append("DOCPROFREFCONTACT2, DOCPROFREFCONTACT3, ISOTSURGEON, TO_CHAR(DOCBDATE,'DD/MM/YYYY'), DOCIDCOUN, DOCCITIZEN, MCHKNO, TO_CHAR(MCHKEXPDATE,'DD/MM/YYYY'), HOSPRATE, TO_CHAR(HOSPRATEDATE,'DD/MM/YYYY')");
		sqlStr.append("FOLDER_ID, PASSWORD");
		sqlStr.append(" FROM CTS_DOCTOR_NEW CDN ");
		sqlStr.append(" WHERE CDN.CTS_NO ='");
		sqlStr.append(ctsNo);
		sqlStr.append("'");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static String addDoc(
			UserBean userBean, String docCode, String fName, String gName, String docSex,
			String spCode, String docEmail, String docSDate, String docTDate,
			String initContactDate, String corrAddr, String isSurgeon, String health_status, String hkahLicNo) {
		StringBuffer sqlStr = new StringBuffer();

		if (docCode != null && docCode.length() > 0) {
			docCode = getNewDoc();
		}

		sqlStr.append("INSERT INTO CTS_DOCTOR ( ");
		sqlStr.append("DOCCODE, ");
		sqlStr.append("DOCFNAME, ");
		sqlStr.append("DOCGNAME, ");
		sqlStr.append("DOCSEX, ");
		sqlStr.append("SPCCODE, ");
		sqlStr.append("DOCPCT_I, ");
		sqlStr.append("DOCPCT_O, ");
		sqlStr.append("DOCPCT_D, ");
		sqlStr.append("DOCEMAIL, ");
		if (docSDate != null && docSDate.length() > 0) {
			sqlStr.append("DOCSDATE, ");
		}
		if (docTDate != null && docTDate.length() > 0) {
			sqlStr.append("DOCTDATE, ");
		}

		// NEWCTS_DOC_SEQ.nextval
		sqlStr.append("ISOTSURGEON) VALUES ( ?, ?, ?, ?, ?, '100', '100', '0', ?, ");
		if (docSDate != null && docSDate.length() > 0) {
			sqlStr.append("TO_DATE('");
			sqlStr.append(docSDate);
			sqlStr.append("','DD/MM/YYYY'), ");
		}
		if (docTDate != null && docTDate.length() > 0) {
			sqlStr.append("TO_DATE('");
			sqlStr.append(docTDate);
			sqlStr.append("','DD/MM/YYYY'), ");
		}
		sqlStr.append("TO_NUMBER('");
		sqlStr.append(isSurgeon);
		sqlStr.append("')) ");

		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {docCode, fName, gName, docSex, spCode, docEmail})) {
			String cts_no = addCtsRecord(userBean, null, docCode, "N","S", initContactDate, corrAddr, health_status, hkahLicNo);
			if ((cts_no != null||cts_no.length() > 0) &&
					UtilDBWeb.updateQueue(sqlStr_insertDocMap, new String[] { docCode,docCode }))
				{
				return cts_no;
			} else {
				return null;
			}
		} else {
			return null;
		}
	}

	public static String addNewCts(
			UserBean userBean, String fName, String gName, String docSex,
			String spCode, String docEmail, String docLicNo) {
//		String cts_no = addCtsRecord(userBean, null, "N999", "N","S", null, null, null, hkahLicNo);
		String ctsNO = getCtsNO("N");
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CTS_DOCTOR_NEW( ");
		sqlStr.append("CTS_NO, ");
		sqlStr.append("DOCCODE, ");
		sqlStr.append("RECORD_TYPE, ");
		sqlStr.append("RECORD_STATUS, ");
		sqlStr.append("DOCFNAME, ");
		sqlStr.append("DOCGNAME, ");
		sqlStr.append("DOCSEX, ");
		sqlStr.append("SPCCODE, ");
		sqlStr.append("DOCEMAIL, ");
		sqlStr.append("DOCLICNO1, ");
		sqlStr.append("FOLDER_ID, ");
				sqlStr.append("PASSWORD) VALUES ( ?, ?, ?, ?, ?, ?, ?, ?, ?, ? ");
		sqlStr.append(",cts_doctor_seq.nextval, NVL(F_CTS_PASSWORD(?,?),SUBSTR(?,1,2)||SUBSTR(TO_CHAR(SYSDATE,'yyyymmddhhmissSSSSS'), -2, 2))) ");
		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {ctsNO, "N999", "N", "S", fName, gName, docSex, spCode, docEmail, docLicNo, docLicNo, ctsNO, docLicNo})) {
				if (createCTSQuestionDtl(ctsNO,"F002A") && createCTSQuestionDtl(ctsNO,"F002B")) {
					if (insertCtsLog(ctsNO, "S", userBean.getStaffID(), userBean.getStaffID(), "")) {
						return ctsNO;
					} else {
						return null;
					}
				} else {
					return null;
				}
		} else {
			return null;
		}
	}

	public static boolean updateNewCtsStatus(
			UserBean userBean, String ctsNO, String recStatus) {
		String hkmcLicNo = null;
		String pwd = null;
		String insertBy = null;

		Vector<String> sqlValue = new Vector<String>();
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CTS_DOCTOR_NEW ");
		if ("A".equals(recStatus)) {
			sqlStr.append("SET RECORD_STATUS = DECODE(RECORD_TYPE, 'D', 'J', 'A') ");
		} else {
			sqlStr.append("SET RECORD_STATUS = ? ");
			sqlValue.add(recStatus);
		}
		sqlStr.append(" WHERE CTS_NO = '");
		sqlStr.append(ctsNO);
		sqlStr.append("'");

		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				(String[]) sqlValue.toArray(new String[sqlValue.size()]))) {

			ArrayList result = getHKMCLicNo(ctsNO);
			if (result.size() > 0) {
				ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
				hkmcLicNo = reportableListObject.getValue(0);
			}

			if (userBean.getStaffID()==null) {
				insertBy = hkmcLicNo;
			} else {
				insertBy = userBean.getStaffID();
			}

			if (insertCtsLog(ctsNO, recStatus, userBean.getStaffID(), userBean.getStaffID(), "")) {
				// send email notify
				if ("R".equals(recStatus) && !ConstantsServerSide.isTWAH()) {
					if (sendNewCTSEmail(null, "away", "", ctsNO, "", "")) {
						return true;
					} else {
						return false;
					}
				}
				return true;
			} else {
				return false;
			}
		} else {
			return false;
		}
	}

	public static boolean updateDoc(
			UserBean userBean, String cts_no, String fName, String gName, String docSex,
				String spCode, String docEmail, String docSDate, String docTDate, String initContactDate, String corrAddr,
				String doccName, String docAddr1, String docAddr2, String docAddr3, String docAddr4,
				String homeAddr1, String homeAddr2, String homeAddr3, String homeAddr4,
				String officeTel, String officeFax, String pager, String mobile, String homeTel, String isSurgeon, String ctsStatus, String health_status,
				String insureCarr, String licNo, String licExpDate, String lnsExpDate) {
		Vector<String> sqlValue = new Vector<String>();
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CTS_DOCTOR ");
		sqlStr.append("SET ");
		sqlStr.append("DOCFNAME = ?, DOCGNAME = ?, DOCSEX = ?, DOCEMAIL = ? ");
		sqlValue.add(fName);
		sqlValue.add(gName);
		sqlValue.add(docSex);
		sqlValue.add(docEmail);
		if (spCode != null && spCode.length() > 0) {
			sqlStr.append(", SPCCODE = ?");
			sqlValue.add(spCode);
		}
		if (docSDate != null && docSDate.length() > 0) {
			sqlStr.append(", DOCSDATE = TO_DATE(?, 'DD/MM/YYYY') ");
			sqlValue.add(docSDate);
		}
		if (docTDate != null && docTDate.length() > 0) {
			sqlStr.append(", DOCTDATE = TO_DATE(?, 'DD/MM/YYYY') ");
			sqlValue.add(docTDate);
		}
//		if (doccName != null && doccName.length() > 0) {
			sqlStr.append(", DOCCNAME = ?");
			sqlValue.add(doccName);
//		}
//		if (docAddr1 != null && docAddr1.length() > 0) {
			sqlStr.append(", DOCADD1 = ?");
			sqlValue.add(docAddr1);
//		}
//		if (docAddr2 != null && docAddr2.length() > 0) {
			sqlStr.append(", DOCADD2 = ?");
			sqlValue.add(docAddr2);
//		}
//		if (docAddr3 != null && docAddr3.length() > 0) {
			sqlStr.append(", DOCADD3 = ?");
			sqlValue.add(docAddr3);
//		}
//		if (docAddr4 != null && docAddr4.length() > 0) {
			sqlStr.append(", DOCADD4 = ?");
			sqlValue.add(docAddr4);
//		}
//		if (homeAddr1 != null && homeAddr1.length() > 0) {
			sqlStr.append(", DOCHOMADD1 = ?");
			sqlValue.add(homeAddr1);
//		}
//		if (homeAddr2 != null && homeAddr2.length() > 0) {
			sqlStr.append(", DOCHOMADD2 = ?");
			sqlValue.add(homeAddr2);
//		}
//		if (homeAddr3 != null && homeAddr3.length() > 0) {
			sqlStr.append(", DOCHOMADD3 = ?");
			sqlValue.add(homeAddr3);
//		}
//		if (homeAddr4 != null && homeAddr4.length() > 0) {
			sqlStr.append(", DOCHOMADD4 = ?");
			sqlValue.add(homeAddr4);
//		}
//		if (officeTel != null && officeTel.length() > 0) {
			sqlStr.append(", DOCOTEL = ?");
			sqlValue.add(officeTel);
//		}
//		if (officeFax != null && officeFax.length() > 0) {
			sqlStr.append(", DOCFAXNO = ?");
			sqlValue.add(officeFax);
//		}
//		if (pager != null && pager.length() > 0) {
			sqlStr.append(", DOCPTEL = ?");
			sqlValue.add(pager);
//		}
//		if (mobile != null && mobile.length() > 0) {
			sqlStr.append(", DOCMTEL = ?");
			sqlValue.add(mobile);
//		}
//		if (homeTel != null && homeTel.length() > 0) {
			sqlStr.append(", DOCHTEL = ?");
			sqlValue.add(homeTel);
//		}
		if (isSurgeon != null && isSurgeon.length() > 0 && !"null".equals(isSurgeon)) {
			sqlStr.append(", ISOTSURGEON = TO_NUMBER('");
			sqlStr.append(isSurgeon);
			sqlStr.append("') ");
		}
		sqlStr.append(" WHERE DOCCODE = (");
		sqlStr.append("SELECT DOCCODE FROM CTS_RECORD WHERE CTS_NO ='");
		sqlStr.append(cts_no);
		sqlStr.append("')");

		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				(String[]) sqlValue.toArray(new String[sqlValue.size()]))) {
				if (updateCtsRecord(userBean, cts_no, ctsStatus, initContactDate, corrAddr, health_status, insureCarr, licNo, licExpDate, lnsExpDate))
					{
					return true;
				} else {
					return false;
				}
		} else {
			return false;
		}
	}

	public static boolean createNewDocCTS(UserBean userBean, String ctsNo, String ctsStatus) {
		Vector<String> sqlValue = new Vector<String>();
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CTS_DOCTOR_NEW(");
		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				(String[]) sqlValue.toArray(new String[sqlValue.size()]))) {
				if (insertCtsLog(ctsNo, ctsStatus, userBean.getStaffID(), userBean.getStaffID(), "")) {
					return true;
				} else {
					return false;
				}
		} else {
			return false;
		}
	}

	public static boolean updateNewDoc(
			UserBean userBean, String cts_no, String fName, String gName, String doccName, String docSex,
				String spCode, String docEmail,
				String docAddr1, String docAddr2, String docAddr3, String docAddr4,
				String homeAddr1, String homeAddr2, String homeAddr3, String homeAddr4,
				String officeTel, String officeFax, String pager, String mobile, String homeTel, String isSurgeon, String ctsStatus, String health_status,
				String insureCarr, String hkahLicNo, String licExpDate, String lnsExpDate) {
		Vector<String> sqlValue = new Vector<String>();
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CTS_DOCTOR_NEW ");
		sqlStr.append("SET ");
		sqlStr.append("DOCFNAME = ?, ");
		sqlValue.add(fName);
		sqlStr.append("DOCGNAME = ?, ");
		sqlValue.add(gName);
		if (doccName != null && doccName.length() > 0) {
			sqlStr.append("DOCCNAME = ?, ");
			sqlValue.add(doccName);
		}
		sqlStr.append("DOCSEX = ?, ");
		sqlValue.add(docSex);
		sqlStr.append("DOCEMAIL = ?, ");
		sqlValue.add(docEmail);
		if (spCode != null && spCode.length() > 0) {
			sqlStr.append("SPCCODE = ?, ");
			sqlValue.add(spCode);
		}
		sqlStr.append("DOCADD1 = ?, ");
		sqlValue.add(docAddr1);
		sqlStr.append("DOCADD2 = ?, ");
		sqlValue.add(docAddr2);
		sqlStr.append("DOCADD3 = ?, ");
		sqlValue.add(docAddr3);
		sqlStr.append("DOCADD4 = ?, ");
		sqlValue.add(docAddr4);
		sqlStr.append("DOCHOMADD1 = ?, ");
		sqlValue.add(homeAddr1);
		sqlStr.append("DOCHOMADD2 = ?, ");
		sqlValue.add(homeAddr2);
		sqlStr.append("DOCHOMADD3 = ?, ");
		sqlValue.add(homeAddr3);
		sqlStr.append("DOCHOMADD4 = ?, ");
		sqlValue.add(homeAddr4);
		sqlStr.append("DOCOTEL = ?, ");
		sqlValue.add(officeTel);
		sqlStr.append("DOCFAXNO = ?, ");
		sqlValue.add(officeFax);
		sqlStr.append("DOCPTEL = ?, ");
		sqlValue.add(pager);
		sqlStr.append("DOCMTEL = ?, ");
		sqlValue.add(mobile);
		sqlStr.append("DOCHTEL = ? ");
		sqlValue.add(homeTel);
		if (isSurgeon != null && isSurgeon.length() > 0 && !"null".equals(isSurgeon)) {
			sqlStr.append(", ISOTSURGEON = TO_NUMBER('");
			sqlStr.append(isSurgeon);
			sqlStr.append("') ");
		}
		sqlStr.append(" WHERE CTS_NO = '");
		sqlStr.append(cts_no);
		sqlStr.append("'");

		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				(String[]) sqlValue.toArray(new String[sqlValue.size()]))) {
				if (updateNewCtsRecord(userBean, cts_no, ctsStatus, health_status, hkahLicNo, insureCarr, licExpDate, lnsExpDate)) {
					return true;
				} else {
					return false;
				}
		} else {
			return false;
		}
	}

	public static String addNewCtsDtl(
			UserBean userBean, String ctsStatus, String ctsNo, String docfName, String docgName, String doccName, String docSex, String idNo, String martialStatus, String docSpCode,
			String docAddr1, String docAddr2, String docAddr3, String docAddr4, String homeAddr1, String homeAddr2, String homeAddr3, String homeAddr4,
			String email, String pager, String mobile, String homeTel, String officeTel, String officeFax, String docAcademic1, String docAcademic2,
			String docDegree1, String docDegree2, String docAcademicDate1, String docAcademicDate2, String docSpecQual, String docSpecQualSince,
			String docSpecQualHospital1, String docSpecQualHospital2, String docSpecQualDateFrom1, String docSpecQualDateFrom2, String docSpecQualDateTo1,
			String docSpecQualDateTo2, String medInfo, String docPrevPracticeAddr1, String docPrevPracticeAddr2, String docPrevPracticeFrom1, String docPrevPracticeFrom2,
			String docPrevPracticeTo1, String docPrevPracticeTo2, String docMemProSoc1, String docMemProSoc2, String docMemProSocStatus1, String docMemProSocStatus2,
			String docMemProSocYear1, String docMemProSocYear2, String docAcademyOfMed1, String docAcademyOfMed2, String docAcademyOfMedStatus1, String docAcademyOfMedStatus2,
			String docAcademyOfMedYear1, String docAcademyOfMedYear2, String docLicNo1, String docLicNo2, String docLicExpdate1, String docLicExpdate2, String docInsureCarr,
			String docInsureCarrExpDate, String docProfRef1, String docProfRef2, String docProfRefContact1, String docProfRefContact2, String isSurgeon, String docBDate,
			String docIDCoun, String docCitizen, String folderId, String password, String rLock, String docProfRef3, String docProfRefContact3, String MCHKNo, String MCHKExpDate,
			String HospRate, String HospRateDate) {
//		String cts_no = addCtsRecord(userBean, null, "N999", "N","S", null, null, null, hkahLicNo);
		String ctsNO = getCtsNO("N");
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("INSERT INTO CTS_DOCTOR_NEW( ");
		sqlStr.append("CTS_NO,DOCCODE,RECORD_TYPE,RECORD_STATUS,DOCFNAME,DOCGNAME,DOCCNAME,DOCSEX,DOCIDNO,DOCMSTS,");
		sqlStr.append("SPCCODE,DOCADD1,DOCADD2,DOCADD3,DOCADD4,DOCHOMADD1,DOCHOMADD2,DOCHOMADD3,DOCHOMADD4,DOCEMAIL,");
		sqlStr.append("DOCPTEL,DOCMTEL,DOCHTEL,DOCOTEL,DOCFAXNO,DOCACADEMIC1,DOCACADEMIC2,DOCDEGREE1,DOCDEGREE2,DOCACADEMICDATE1,");
		sqlStr.append("DOCACADEMICDATE2,DOCSPECQUAL,DOCSPECQUALSINCE,DOCSPECQUALHOSPITAL1,DOCSPECQUALHOSPITAL2,DOCSPECQUALDATEFROM1,DOCSPECQUALDATEFROM2,DOCSPECQUALDATETO1,DOCSPECQUALDATETO2,MEDINFO,");
		sqlStr.append("DOCPREVPRACTICEADDR1,DOCPREVPRACTICEADDR2,DOCPREVPRACTICEFROM1,DOCPREVPRACTICEFROM2,DOCPREVPRACTICETO1,DOCPREVPRACTICETO2,DOCMEMPROSOC1,DOCMEMPROSOC2,DOCMEMPROSOCSTATUS1,DOCMEMPROSOCSTATUS2,");
		sqlStr.append("DOCMEMPROSOCYEAR1,DOCMEMPROSOCYEAR2,DOCACADEMYOFMED1,DOCACADEMYOFMED2,DOCACADEMYOFMEDSTATUS1,DOCACADEMYOFMEDSTATUS2,DOCACADEMYOFMEDYEAR1,DOCACADEMYOFMEDYEAR2,DOCLICNO1,DOCLICNO2,");
		sqlStr.append("DOCLICEXPDATE1,DOCLICEXPDATE2,DOCINSURECARREXPDATE,DOCINSURECARR,DOCPROFREF1,DOCPROFREF2,DOCPROFREFCONTACT1,DOCPROFREFCONTACT2,ISOTSURGEON,DOCBDATE,DOCIDCOUN,DOCCITIZEN,FOLDER_ID,");
		sqlStr.append("PASSWORD,RLOCK,DOCPROFREF3,DOCPROFREFCONTACT3,MCHKNO,MCHKEXPDATE,HOSPRATE,HOSPRATEDATE");
		sqlStr.append(") VALUES (");
		sqlStr.append(" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ");
		sqlStr.append(" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ");
		sqlStr.append(" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ");
		sqlStr.append(" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ");
		sqlStr.append(" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ");
		sqlStr.append(" ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ");
		if (docLicExpdate1 != null && docLicExpdate1.length() > 0) {
			sqlStr.append(" TO_DATE(?,'DD/MM/YYYY'),");
		} else {
			sqlStr.append(" ?,");
		}
		if (docLicExpdate2 != null && docLicExpdate2.length() > 0) {
			sqlStr.append(" TO_DATE(?,'DD/MM/YYYY'),");
		} else {
			sqlStr.append(" ?,");
		}
		if (docInsureCarrExpDate != null && docInsureCarrExpDate.length() > 0) {
			sqlStr.append(" TO_DATE(?,'DD/MM/YYYY'),");
		} else {
			sqlStr.append(" ?,");
		}
		sqlStr.append(" ?, ?, ?, ?, ?, ?,");
		if (docBDate != null && docBDate.length() > 0) {
			sqlStr.append(" TO_DATE(?,'DD/MM/YYYY'),");
		} else {
			sqlStr.append(" ?,");
		}
		sqlStr.append("?, ?,cts_doctor_seq.nextval, ");
		sqlStr.append(" NVL(F_CTS_PASSWORD(?,?),SUBSTR(?,1,2)||SUBSTR(TO_CHAR(SYSDATE,'yyyymmddhhmissSSSSS'), -2, 2)), ?, ?, ?, ?,");
		if (MCHKExpDate != null && MCHKExpDate.length() > 0) {
			sqlStr.append(" TO_DATE(?,'DD/MM/YYYY'),");
		} else {
			sqlStr.append(" ?,");
		}
		sqlStr.append(" ?,");
		if (HospRateDate != null && HospRateDate.length() > 0) {
			sqlStr.append(" TO_DATE(?,'DD/MM/YYYY'))");
		} else {
			sqlStr.append(" ?)");
		}
		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				new String[] {ctsNO, "N999", "N", ctsStatus, docfName, docgName, doccName, docSex, idNo, martialStatus,
					docSpCode, docAddr1, docAddr2, docAddr3, docAddr4, homeAddr1, homeAddr2, homeAddr3, homeAddr4, email,
					pager, mobile, homeTel, officeTel, officeFax, docAcademic1, docAcademic2, docDegree1, docDegree2, docAcademicDate1,
					docAcademicDate2, docSpecQual, docSpecQualSince, docSpecQualHospital1, docSpecQualHospital2, docSpecQualDateFrom1, docSpecQualDateFrom2, docSpecQualDateTo1, docSpecQualDateTo2, medInfo,
					docPrevPracticeAddr1, docPrevPracticeAddr2, docPrevPracticeFrom1, docPrevPracticeFrom2, docPrevPracticeTo1, docPrevPracticeTo2, docMemProSoc1, docMemProSoc2, docMemProSocStatus1, docMemProSocStatus2,
					docMemProSocYear1, docMemProSocYear2, docAcademyOfMed1, docAcademyOfMed2, docAcademyOfMedStatus1, docAcademyOfMedStatus2, docAcademyOfMedYear1, docAcademyOfMedYear2, docLicNo1, docLicNo2,
					docLicExpdate1, docLicExpdate2, docInsureCarrExpDate, docInsureCarr, docProfRef1, docProfRef2, docProfRefContact1, docProfRefContact2, isSurgeon, docBDate,
					docIDCoun, docCitizen, docLicNo1, ctsNO, docLicNo1, rLock, docProfRef3, docProfRefContact3, MCHKNo, MCHKExpDate, HospRate, HospRateDate})) {
				if (createCTSQuestionDtl(ctsNO,"F002A") && createCTSQuestionDtl(ctsNO,"F002B")) {
					if (insertCtsLog(ctsNO, "S", userBean.getStaffID(), userBean.getStaffID(), "")) {
						return ctsNO;
					} else {
						return null;
					}
				} else {
					return null;
				}
		} else {
			return null;
		}
	}

	public static boolean updateNewCTSDtl(
			UserBean userBean, String ctsStatus, String ctsNo, String docfName, String docgName, String doccName, String docSex, String idNo, String martialStatus, String docSpCode,
			String docAddr1, String docAddr2, String docAddr3, String docAddr4, String homeAddr1, String homeAddr2, String homeAddr3, String homeAddr4,
			String email, String pager, String mobile, String homeTel, String officeTel, String officeFax, String docAcademic1, String docAcademic2,
			String docDegree1, String docDegree2, String docAcademicDate1, String docAcademicDate2, String docSpecQual, String docSpecQualSince,
			String docSpecQualHospital1, String docSpecQualHospital2, String docSpecQualDateFrom1, String docSpecQualDateFrom2, String docSpecQualDateTo1,
			String docSpecQualDateTo2, String medInfo, String docPrevPracticeAddr1, String docPrevPracticeAddr2, String docPrevPracticeFrom1, String docPrevPracticeFrom2,
			String docPrevPracticeTo1, String docPrevPracticeTo2, String docMemProSoc1, String docMemProSoc2, String docMemProSocStatus1, String docMemProSocStatus2,
			String docMemProSocYear1, String docMemProSocYear2, String docAcademyOfMed1, String docAcademyOfMed2, String docAcademyOfMedStatus1, String docAcademyOfMedStatus2,
			String docAcademyOfMedYear1, String docAcademyOfMedYear2, String docLicNo1, String docLicNo2, String docLicExpdate1, String docLicExpdate2, String docInsureCarr,
			String docInsureCarrExpDate, String docProfRef1, String docProfRef2, String docProfRefContact1, String docProfRefContact2, String isSurgeon, String docBDate,
			String docIDCoun, String docCitizen, String docProfRef3, String docProfRefContact3, String MCHKNo, String MCHKExpDate, String HospRate, String HospRateDate) {

		Vector<String> sqlValue = new Vector<String>();
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CTS_DOCTOR_NEW ");
		sqlStr.append("SET ");
		if ("R".equals(ctsStatus)) {
			sqlStr.append("RECORD_STATUS = ? ");
			sqlValue.add(ctsStatus);
			sqlStr.append(",DOCFNAME = ? ");
			sqlValue.add(docfName);
		} else {
			sqlStr.append("DOCFNAME = ? ");
			sqlValue.add(docfName);
		}
		sqlStr.append(",DOCGNAME = ? ");
		sqlValue.add(docgName);
		sqlStr.append(",DOCCNAME = ? ");
		sqlValue.add(doccName);
		sqlStr.append(",DOCSEX = ? ");
		sqlValue.add(docSex);
		sqlStr.append(",DOCIDNO = ? ");
		sqlValue.add(idNo);
		sqlStr.append(",DOCMSTS = ? ");
		sqlValue.add(martialStatus);
		sqlStr.append(",SPCCODE = ? ");
		sqlValue.add(docSpCode);
		sqlStr.append(",DOCADD1 = ? ");
		sqlValue.add(docAddr1);
		sqlStr.append(",DOCADD2 = ? ");
		sqlValue.add(docAddr2);
		sqlStr.append(",DOCADD3 = ? ");
		sqlValue.add(docAddr3);
		sqlStr.append(",DOCADD4 = ? ");
		sqlValue.add(docAddr4);
		sqlStr.append(",DOCHOMADD1 = ? ");
		sqlValue.add(homeAddr1);
		sqlStr.append(",DOCHOMADD2 = ? ");
		sqlValue.add(homeAddr2);
		sqlStr.append(",DOCHOMADD3 = ? ");
		sqlValue.add(homeAddr3);
		sqlStr.append(",DOCHOMADD4 = ? ");
		sqlValue.add(homeAddr4);
		sqlStr.append(",DOCEMAIL = ? ");
		sqlValue.add(email);
		sqlStr.append(",DOCPTEL = ? ");
		sqlValue.add(pager);
		sqlStr.append(",DOCMTEL = ? ");
		sqlValue.add(mobile);
		sqlStr.append(",DOCHTEL = ? ");
		sqlValue.add(homeTel);
		sqlStr.append(",DOCOTEL = ? ");
		sqlValue.add(officeTel);
		sqlStr.append(",DOCFAXNO = ? ");
		sqlValue.add(officeFax);
		sqlStr.append(",DOCACADEMIC1 = ? ");
		sqlValue.add(docAcademic1);
		sqlStr.append(",DOCACADEMIC2 = ? ");
		sqlValue.add(docAcademic2);
		sqlStr.append(",DOCDEGREE1 = ? ");
		sqlValue.add(docDegree1);
		sqlStr.append(",DOCDEGREE2 = ? ");
		sqlValue.add(docDegree2);
		sqlStr.append(",DOCACADEMICDATE1 = ? ");
		sqlValue.add(docAcademicDate1);
		sqlStr.append(",DOCACADEMICDATE2 = ? ");
		sqlValue.add(docAcademicDate2);
		sqlStr.append(",DOCSPECQUAL = ? ");
		sqlValue.add(docSpecQual);
		sqlStr.append(",DOCSPECQUALSINCE = ? ");
		sqlValue.add(docSpecQualSince);
		sqlStr.append(",DOCSPECQUALHOSPITAL1 = ? ");
		sqlValue.add(docSpecQualHospital1);
		sqlStr.append(",DOCSPECQUALHOSPITAL2 = ? ");
		sqlValue.add(docSpecQualHospital2);
		sqlStr.append(",DOCSPECQUALDATEFROM1 = ? ");
		sqlValue.add(docSpecQualDateFrom1);
		sqlStr.append(",DOCSPECQUALDATEFROM2 = ? ");
		sqlValue.add(docSpecQualDateFrom2);
		sqlStr.append(",DOCSPECQUALDATETO1 = ? ");
		sqlValue.add(docSpecQualDateTo1);
		sqlStr.append(",DOCSPECQUALDATETO2 = ? ");
		sqlValue.add(docSpecQualDateTo2);
		sqlStr.append(",MEDINFO = ? ");
		sqlValue.add(medInfo);
		sqlStr.append(",DOCPREVPRACTICEADDR1 = ? ");
		sqlValue.add(docPrevPracticeAddr1);
		sqlStr.append(",DOCPREVPRACTICEADDR2 = ? ");
		sqlValue.add(docPrevPracticeAddr2);
		sqlStr.append(",DOCPREVPRACTICEFROM1 = ? ");
		sqlValue.add(docPrevPracticeFrom1);
		sqlStr.append(",DOCPREVPRACTICEFROM2 = ? ");
		sqlValue.add(docPrevPracticeFrom2);
		sqlStr.append(",DOCPREVPRACTICETO1 = ? ");
		sqlValue.add(docPrevPracticeTo1);
		sqlStr.append(",DOCPREVPRACTICETO2 = ? ");
		sqlValue.add(docPrevPracticeTo2);
		sqlStr.append(",DOCMEMPROSOC1 = ? ");
		sqlValue.add(docMemProSoc1);
		sqlStr.append(",DOCMEMPROSOC2 = ? ");
		sqlValue.add(docMemProSoc2);
		sqlStr.append(",DOCMEMPROSOCSTATUS1 = ? ");
		sqlValue.add(docMemProSocStatus1);
		sqlStr.append(",DOCMEMPROSOCSTATUS2 = ? ");
		sqlValue.add(docMemProSocStatus2);
		sqlStr.append(",DOCMEMPROSOCYEAR1 = ? ");
		sqlValue.add(docMemProSocYear1);
		sqlStr.append(",DOCMEMPROSOCYEAR2 = ? ");
		sqlValue.add(docMemProSocYear2);
		sqlStr.append(",DOCACADEMYOFMED1 = ? ");
		sqlValue.add(docAcademyOfMed1);
		sqlStr.append(",DOCACADEMYOFMED2 = ? ");
		sqlValue.add(docAcademyOfMed2);
		sqlStr.append(",DOCACADEMYOFMEDSTATUS1 = ? ");
		sqlValue.add(docAcademyOfMedStatus1);
		sqlStr.append(",DOCACADEMYOFMEDSTATUS2 = ? ");
		sqlValue.add(docAcademyOfMedStatus2);
		sqlStr.append(",DOCACADEMYOFMEDYEAR1 = ? ");
		sqlValue.add(docAcademyOfMedYear1);
		sqlStr.append(",DOCACADEMYOFMEDYEAR2 = ? ");
		sqlValue.add(docAcademyOfMedYear2);
		sqlStr.append(",DOCLICNO1 = ? ");
		sqlValue.add(docLicNo1);
		sqlStr.append(",DOCLICNO2 = ? ");
		sqlValue.add(docLicNo2);
		if (docLicExpdate1 != null && docLicExpdate1.length() > 0) {
			sqlStr.append(",DOCLICEXPDATE1 = TO_DATE(?,'DD/MM/YYYY') ");
			sqlValue.add(docLicExpdate1);
		}
		if (docLicExpdate2 != null && docLicExpdate2.length() > 0) {
			sqlStr.append(",DOCLICEXPDATE2 = TO_DATE(?,'DD/MM/YYYY') ");
			sqlValue.add(docLicExpdate2);
		}
		sqlStr.append(",DOCINSURECARR = ? ");
		sqlValue.add(docInsureCarr);
		if (docInsureCarrExpDate != null && docInsureCarrExpDate.length() > 0) {
			sqlStr.append(",DOCINSURECARREXPDATE = TO_DATE(?,'DD/MM/YYYY') ");
			sqlValue.add(docInsureCarrExpDate);
		}
		sqlStr.append(",DOCPROFREF1 = ? ");
		sqlValue.add(docProfRef1);
		sqlStr.append(",DOCPROFREF2 = ? ");
		sqlValue.add(docProfRef2);
		sqlStr.append(",DOCPROFREFCONTACT1 = ? ");
		sqlValue.add(docProfRefContact1);
		sqlStr.append(",DOCPROFREFCONTACT2 = ? ");
		sqlValue.add(docProfRefContact2);
		if (isSurgeon != null && isSurgeon.length() > 0 && !"null".equals(isSurgeon)) {
			sqlStr.append(",ISOTSURGEON = TO_NUMBER(?) ");
			sqlValue.add(isSurgeon);
		}
		if (docBDate != null && docBDate.length() > 0) {
			sqlStr.append(",DOCBDATE = TO_DATE(?,'DD/MM/YYYY') ");
			sqlValue.add(docBDate);
		}
		sqlStr.append(",DOCIDCOUN = ? ");
		sqlValue.add(docIDCoun);
		sqlStr.append(",DOCCITIZEN = ? ");
		sqlValue.add(docCitizen);
		sqlStr.append(",DOCPROFREF3 = ? ");
		sqlValue.add(docProfRef3);
		sqlStr.append(",DOCPROFREFCONTACT3 = ? ");
		sqlValue.add(docProfRefContact3);
		sqlStr.append(",MCHKNO = ? ");
		sqlValue.add(MCHKNo);
		if (docLicExpdate1 != null && docLicExpdate1.length() > 0) {
			sqlStr.append(",MCHKEXPDATE = TO_DATE(?,'DD/MM/YYYY') ");
			sqlValue.add(MCHKExpDate);
		}
		sqlStr.append(",HOSPRATE = ? ");
		sqlValue.add(HospRate);
		if (docLicExpdate1 != null && docLicExpdate1.length() > 0) {
			sqlStr.append(",HOSPRATEDATE = TO_DATE(?,'DD/MM/YYYY') ");
			sqlValue.add(HospRateDate);
		}
		sqlStr.append(" WHERE CTS_NO = '");
		sqlStr.append(ctsNo);
		sqlStr.append("'");

		if (UtilDBWeb.updateQueue(
			sqlStr.toString(),
			(String[]) sqlValue.toArray(new String[sqlValue.size()]))) {
			if (ctsStatus==null) {
				return true;
			} else {
				if (insertCtsLog(ctsNo, ctsStatus, userBean.getStaffID(), userBean.getStaffID(), "")) {
					return true;
				} else {
					return false;
				}
			}
		} else {
			return false;
		}
	}


	public static boolean copyDocDtlFromHATS(String docCode,String ctsNO) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO cts_doctor VALUE ");
		sqlStr.append("SELECT  ");
		sqlStr.append("doccode||'A',docfname,docgname,doccname,docidno,docsex,spccode,docsts,doctype, ");
		sqlStr.append("docpct_i,docpct_o,docpct_d,docadd1,docadd2,docadd3,dochtel,docotel,docptel, ");
		sqlStr.append("doctslot,docquali,doctdate,docsdate,dochomadd1,dochomadd2,dochomadd3,docoffadd1,docoffadd2,docoffadd3, ");
		sqlStr.append("doccsholy,docmtel,docemail,docfaxno,dochomadd4,docadd4,docoffadd4,docpicklist,usrid, ");
		sqlStr.append("docqualify,docbdate,rptto,isdoctor,tittle,isotsurgeon,isotanesthetist,showprofile, ");
		sqlStr.append("dayinstruction,inpinstruction,oupinstruction,payinstruction,1brno,docremark, ");
		sqlStr.append("cpsdate,apldate,mpscdate,sldate,isotendoscopist, ");
		sqlStr.append("cts_doctor_seq.nextval ");
		sqlStr.append("FROM ( ");
		sqlStr.append("SELECT ");
		sqlStr.append("doccode,docfname,docgname,doccname,docidno,docsex,spccode,docsts,doctype, ");
		sqlStr.append("docpct_i,docpct_o,docpct_d,docadd1,docadd2,docadd3,dochtel,docotel,docptel, ");
		sqlStr.append("doctslot,docquali,doctdate,docsdate,dochomadd1,dochomadd2,dochomadd3,docoffadd1,docoffadd2,docoffadd3, ");
		sqlStr.append("doccsholy,docmtel,docemail,docfaxno,dochomadd4,docadd4,docoffadd4,docpicklist,usrid, ");
		sqlStr.append("docqualify,docbdate,rptto,isdoctor,tittle,isotsurgeon,isotanesthetist,showprofile, ");
		sqlStr.append("dayinstruction,inpinstruction,oupinstruction,payinstruction,1brno,docremark, ");
		sqlStr.append("cpsdate,apldate,mpscdate,sldate,isotendoscopist ");
		sqlStr.append("FROM doctor@iweb ");
		sqlStr.append("WHERE DOCCODE = '");
		sqlStr.append(docCode);
		sqlStr.append("')");
		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			if (UtilDBWeb.updateQueue(sqlStr_updateDocCodeCtsRecord, new String[] {docCode,ctsNO})) {
				return true;
			} else {
				return false;
			}
		} else {
			return false;
		}
}

	public static String addCtsRecord(
		UserBean userBean, String ctsNO, String docCode, String recType, String recStatus,
		String initContactDate, String corrAddr, String health_status, String HKMC_LicNO) {

		ctsNO = getCtsNO("R");

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CTS_RECORD ( ");
		sqlStr.append("CTS_NO, ");
		sqlStr.append("DOCCODE, ");
		sqlStr.append("RECORD_TYPE, ");
		sqlStr.append("RECORD_STATUS, ");
		sqlStr.append("LAST_STNCDATE, ");
		sqlStr.append("PASSWORD, ");
		sqlStr.append("INSERT_BY, ");
		sqlStr.append("INSERT_DATE, ");
		sqlStr.append("MODIFIED_DATE ");
		if (initContactDate != null && initContactDate.length() > 0) {
			sqlStr.append(",INIT_CONTRACT_DATE ");
		}
		if (corrAddr != null && corrAddr.length() > 0) {
			sqlStr.append(",CORR_ADDR");
		}
		if (health_status != null && health_status.length() > 0) {
			sqlStr.append(",HEALTH_STATUS");
		}
		if (HKMC_LicNO != null && HKMC_LicNO.length() > 0) {
			sqlStr.append(",HKMC_LICNO");
		}
		sqlStr.append(",FOLDER_ID) VALUES ( '");
		sqlStr.append(ctsNO);
		sqlStr.append("','");
		sqlStr.append(docCode);
		sqlStr.append("','");
		sqlStr.append(recType);
		sqlStr.append("','");
		sqlStr.append(recStatus);
		sqlStr.append("',");
		sqlStr.append("null");
		sqlStr.append(",f_cts_password('");
		sqlStr.append(docCode);
		sqlStr.append("','");
		sqlStr.append(ctsNO);
		sqlStr.append("'), '");
		sqlStr.append(userBean.getStaffID());
		sqlStr.append("',SYSDATE,SYSDATE");
		if (initContactDate != null && initContactDate.length() > 0) {
			sqlStr.append(",TO_DATE('");
			sqlStr.append(initContactDate);
			sqlStr.append("','DD/MM/YYYY')");
		}
		if (corrAddr != null && corrAddr.length() > 0) {
			sqlStr.append(",'");
			sqlStr.append(corrAddr);
			sqlStr.append("'");
		}
		if (health_status != null && health_status.length() > 0) {
			sqlStr.append(",'");
			sqlStr.append(health_status.trim());
			sqlStr.append("'");
		}
		if (HKMC_LicNO != null && HKMC_LicNO.length() > 0) {
			sqlStr.append(",'");
			sqlStr.append(HKMC_LicNO.trim());
			sqlStr.append("'");
		}
		sqlStr.append(",CTS_DOCTOR_SEQ.NEXTVAL)");
		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			if ((ctsNO != null||ctsNO.length() > 0) &&
					UtilDBWeb.updateQueue(sqlStr_insertApprovalStatus, new String[] {ctsNO }) &&
					createFormQuestion(ctsNO)) {
				return ctsNO;
			} else {
				return null;
			}
		} else {
			return null;
		}
	}

	public static boolean updateCtsRecord(
			UserBean userBean, String ctsNO, String recStatus, String initContactDate, String corrAddr, String health_status, String insureCarr, String licNo, String licExpDate, String lnsExpDate) {

			String docCode = null;
			String pwd = null;
			String insertBy = null;
			Vector<String> sqlValue = new Vector<String>();
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE CTS_RECORD ");
			sqlStr.append("SET MODIFIED_DATE = SYSDATE ");
			if (recStatus != null && recStatus.length() > 0) {
				sqlStr.append(", RECORD_STATUS = ?");
				sqlValue.add(recStatus);
			}
			if (initContactDate != null && initContactDate.length() > 0) {
				sqlStr.append(", INIT_CONTRACT_DATE = TO_DATE(?,'DD/MM/YYYY') ");
				sqlValue.add(initContactDate);
			}
			if (corrAddr != null && corrAddr.length() > 0) {
				sqlStr.append(", CORR_ADDR = ? ");
				sqlValue.add(corrAddr);
			}
			if (health_status != null && health_status.length() > 0) {
				sqlStr.append(", HEALTH_STATUS = ? ");
				sqlValue.add(health_status);
			} else {
				sqlStr.append(", HEALTH_STATUS = null ");
			}
			if (licNo != null && licNo.length() > 0) {
				sqlStr.append(", HKMC_LICNO = ? ");
				sqlValue.add(licNo);
			} else {
				sqlStr.append(", HKMC_LICNO = null ");
			}
			if (licExpDate != null && licExpDate.length() > 0) {
				sqlStr.append(", HKMC_LIC_EXPDATE = TO_DATE(?,'DD/MM/YYYY') ");
				sqlValue.add(licExpDate);
			} else {
				sqlStr.append(", HKMC_LIC_EXPDATE = null ");
			}
			if (insureCarr != null && insureCarr.length() > 0) {
				sqlStr.append(", MICD_INS_CARRIER = ? ");
				sqlValue.add(insureCarr);
			} else {
				sqlStr.append(", MICD_INS_CARRIER = null ");
			}
			if (lnsExpDate != null && lnsExpDate.length() > 0) {
				sqlStr.append(", MICD_INS_EXPDATE = TO_DATE(?,'DD/MM/YYYY') ");
				sqlValue.add(lnsExpDate);
			} else {
				sqlStr.append(", MICD_INS_EXPDATE = null ");
			}
			sqlStr.append(" WHERE CTS_NO = '");
			sqlStr.append(ctsNO);
			sqlStr.append("'");
			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					(String[]) sqlValue.toArray(new String[sqlValue.size()]))) {
				docCode = getDocCode(ctsNO);

				if (userBean.getStaffID() == null) {
					insertBy = docCode;
				} else {
					insertBy = userBean.getStaffID();
				}

				if (insertCtsLog(ctsNO, recStatus, insertBy, userBean.getStaffID(), "")) {
					// send email notify
					if ("X".equals(recStatus)||"Y".equals(recStatus)||"Z".equals(recStatus)) {
						pwd = getCtsPwd(ctsNO);
						if (sendEmail(docCode, "home", userBean.getStaffID(), ctsNO, pwd, recStatus)) {
							return true;
						} else {
							return false;
						}
					} else if ("R".equals(recStatus) && !ConstantsServerSide.isTWAH()) {
						if (sendEmail(docCode, "away", "", ctsNO, "", "")) {
							return true;
						} else {
							return false;
						}
					}
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		}

	public static boolean updateNewCtsRecord(
			UserBean userBean, String ctsNO, String ctsStatus, String health_status, String hkahLicNo, String insureCarr, String licExpDate, String lnsExpDate) {
			Vector<String> sqlValue = new Vector<String>();
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE CTS_RECORD ");
			sqlStr.append("SET RECORD_STATUS = ? ");
			sqlValue.add(ctsStatus);
			sqlStr.append(",HEALTH_STATUS = ?");
			sqlValue.add(health_status);
			sqlStr.append(",HKMC_LICNO = ?");
			sqlValue.add(hkahLicNo);
			sqlStr.append(",MICD_INS_CARRIER = ?");
			sqlValue.add(insureCarr);
			if (licExpDate != null && licExpDate.length() > 0) {
				sqlStr.append(",HKMC_LIC_EXPDATE = TO_DATE(?,'DD/MM/YYYY') ");
				sqlValue.add(licExpDate);
			} else {
				sqlStr.append(",HKMC_LIC_EXPDATE = null ");
			}
			if (lnsExpDate != null && lnsExpDate.length() > 0) {
				sqlStr.append(",MICD_INS_EXPDATE = TO_DATE(?,'DD/MM/YYYY') ");
				sqlValue.add(lnsExpDate);
			} else {
				sqlStr.append(",MICD_INS_EXPDATE = null ");
			}
			sqlStr.append(" WHERE CTS_NO = '");
			sqlStr.append(ctsNO);
			sqlStr.append("'");
			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					(String[]) sqlValue.toArray(new String[sqlValue.size()]))) {
				if (insertCtsLog(ctsNO, ctsStatus, userBean.getStaffID(), userBean.getStaffID(), "")) {
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		}

	public static boolean updateCtsRecordList(
		UserBean userBean, String ctsNO, String recStatus, String initContactDate, String corrAddr, String health_status) {
		String docCode = null;
		String pwd = null;
		String insertBy = null;
		Vector<String> sqlValue = new Vector<String>();
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CTS_RECORD ");
		sqlStr.append("SET MODIFIED_DATE = SYSDATE ");
		if (recStatus != null && recStatus.length() > 0) {
			if ("A".equals(recStatus)) {
				sqlStr.append(", RECORD_STATUS = DECODE(RECORD_TYPE, 'D', 'J', 'A') ");
			} else {
				sqlStr.append(", RECORD_STATUS = ?");
				sqlValue.add(recStatus);
			}
		}
		if (initContactDate != null && initContactDate.length() > 0) {
			sqlStr.append(", INIT_CONTRACT_DATE = TO_DATE(?,'DD/MM/YYYY') ");
			sqlValue.add(initContactDate);
		}
		if (corrAddr != null && corrAddr.length() > 0) {
			sqlStr.append(", CORR_ADDR = ? ");
			sqlValue.add(corrAddr);
		}
		if (health_status != null && health_status.length() > 0) {
			sqlStr.append(", HEALTH_STATUS = ? ");
			sqlValue.add(health_status);
		}
		sqlStr.append(" WHERE CTS_NO = '");
		sqlStr.append(ctsNO);
		sqlStr.append("'");

		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				(String[]) sqlValue.toArray(new String[sqlValue.size()]))) {
			docCode = getDocCode(ctsNO);

			if (userBean.getStaffID()==null) {
				insertBy = docCode;
			} else {
				insertBy = userBean.getStaffID();
			}

			if (insertCtsLog(ctsNO, recStatus, insertBy, userBean.getStaffID(), "")) {
				// send email notify
				if ("X".equals(recStatus) || "Y".equals(recStatus) || "Z".equals(recStatus) || "U".equals(recStatus)) {
					pwd = getCtsPwd(ctsNO);

					if (sendEmail(docCode, "home", userBean.getStaffID(), ctsNO, pwd, recStatus)) {
						return true;
					} else {
						return false;
					}
				} else if ("R".equals(recStatus) && !ConstantsServerSide.isTWAH()) {
					if (sendEmail(docCode, "away", "", ctsNO, "", "")) {
						return true;
					} else {
						return false;
					}
				}
				return true;
			} else {
				return false;
			}
		} else {
			return false;
		}
	}

	public static boolean updateCtsRecordListF(
			UserBean userBean, String ctsNO, String recStatus, String renewDate1, String renewDate3) {
			String docCode = null;
			String pwd = null;
			String insertBy = null;
			Vector<String> sqlValue = new Vector<String>();
			StringBuffer sqlStr = new StringBuffer();
			String docTDate = null;

			if (renewDate1 != null && renewDate1.length() > 0) {
				docTDate = renewDate1;
			} else {
				docTDate = renewDate3;
			}

			sqlStr.append("UPDATE CTS_RECORD ");
			sqlStr.append("SET MODIFIED_DATE = SYSDATE ");
			if (recStatus != null && recStatus.length() > 0) {
				sqlStr.append(", RECORD_STATUS = ?");
				sqlValue.add(recStatus);
			}
			sqlStr.append(" WHERE CTS_NO = '");
			sqlStr.append(ctsNO);
			sqlStr.append("'");
			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					(String[]) sqlValue.toArray(new String[sqlValue.size()]))) {
				docCode = getDocCode(ctsNO);
				updateDocTDate(ctsNO, docTDate);

				if (userBean.getStaffID()==null) {
					insertBy = docCode;
				} else {
					insertBy = userBean.getStaffID();
				}

				if (insertCtsLog(ctsNO, recStatus, insertBy, userBean.getStaffID(), "")) {
					// send email notify
					if ("U".equals(recStatus)) {
						if (sendEmail4AcceptVerify(docCode, userBean.getStaffID(), ctsNO, renewDate1, renewDate3, recStatus)) {
							return true;
						} else {
							return false;
						}
					}
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		}

	public static boolean updateDocTDate(String ctsNO, String docTDate) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CTS_DOCTOR ");
		sqlStr.append("SET doctdate = TO_DATE('");
		sqlStr.append(docTDate);
		sqlStr.append("','DD/MM/YYYY') ");
		sqlStr.append(" WHERE DOCCODE = (SELECT DOCCODE FROM CTS_RECORD WHERE CTS_NO = '");
		sqlStr.append(ctsNO);
		sqlStr.append("')");

		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean approveCtsRecord(UserBean userBean, String ctsNO, String approver) {
		return updateCtsRecord(userBean, ctsNO, approver, "A", "");
	}

	public static boolean rejectCtsRecord(UserBean userBean, String ctsNO, String approver, String remarks) {
		return updateCtsRecord(userBean, ctsNO, approver, "J", remarks);
	}

	private static boolean updateCtsRecord(UserBean userBean, String ctsNO, String approver, String status, String remarks) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 1 FROM CTS_RECORD_APPROVER WHERE CTS_NO = ? ");
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {ctsNO});
		if (record.size() > 0) {
			return updateCtsRecordMultiple(userBean, ctsNO, approver, status, remarks);
		} else {
			return updateCtsRecordSingle(userBean, ctsNO, approver, status, remarks, true);
		}
	}

	private static boolean updateCtsRecordSingle(UserBean userBean, String ctsNO, String approver, String status, String remarks, boolean updateLog) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CTS_RECORD ");
		sqlStr.append("SET MODIFIED_DATE = SYSDATE, ");
		sqlStr.append(" RECORD_STATUS = ? ");
		sqlStr.append(" WHERE CTS_NO = ? ");

		if (UtilDBWeb.updateQueue(sqlStr.toString(), new String[] {status, ctsNO})) {
			if (insertCtsLog(ctsNO, status, approver, userBean.getStaffID(), remarks)) {
				return true;
			} else {
				return false;
			}
		} else {
			return false;
		}
	}

	private static boolean updateCtsRecordMultiple(UserBean userBean, String ctsNO, String approver, String status, String remarks) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CTS_RECORD_APPROVER ");
		sqlStr.append("SET MODIFIED_DATE = SYSDATE, ");
		sqlStr.append(" RECORD_STATUS = ? ");
		sqlStr.append(" WHERE CTS_NO = ? ");
		sqlStr.append(" AND   ASSIGN_APPROVER = ? ");

		if (UtilDBWeb.updateQueue(sqlStr.toString(), new String[] {status, ctsNO, approver})) {
			sqlStr.setLength(0);
			ArrayList record = null;

			if (ConstantsServerSide.isTWAH()) {
				sqlStr.append("SELECT 1 FROM CTS_RECORD_APPROVER WHERE CTS_NO = ? AND RECORD_STATUS != 'A' ");
				record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {ctsNO});
				if (record.size() == 0) {
					// update to approve if all approved
					updateCtsRecordSingle(userBean, ctsNO, approver, status, remarks, false);
				}
			} else {
				sqlStr.append("SELECT 1 FROM CTS_RECORD_APPROVER WHERE CTS_NO = ? AND RECORD_STATUS = 'A' ");
				record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {ctsNO});
				if (record.size() > 0) {
					// update to approve if any approved
					updateCtsRecordSingle(userBean, ctsNO, approver, status, remarks, false);
				}
			}

			if (insertCtsLog(ctsNO, status, approver, userBean.getStaffID(), remarks)) {
				return true;
			} else {
				return false;
			}
		} else {
			return false;
		}
	}

	public static ArrayList getRecordApproverList(String ctsNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append(" SELECT D.DOCFNAME || ' ' || D.DOCGNAME, A.RECORD_STATUS, A.MODIFIED_DATE ");
		sqlStr.append(" FROM DOCTOR@IWEB D ");
		sqlStr.append(" INNER JOIN CTS_RECORD_APPROVER A ON D.DOCCODE = A.ASSIGN_APPROVER ");
		sqlStr.append(" WHERE A.cts_no = ? ");
		sqlStr.append(" ORDER BY D.DOCFNAME, D.DOCGNAME ");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { ctsNo });
	}

	public static String execFuncNewCTSList(String txCode, UserBean userBean, String docCode, String fName, String gName, String docSex,
			String spCode, String docEmail, String docSDate, String docTDate, String isSurgeon, String isCtsDoc) {
		return (UtilDBWeb.callFunction(
				txCode,
				null,
				new String[] {
						docCode, fName, gName, docSex,
						spCode, docEmail, docSDate,
						docTDate, isSurgeon, isCtsDoc
				}));
	}

	public static ArrayList getRecordLog(String ctsNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append(" SELECT crl.cts_no, (");
		sqlStr.append(" CASE");
		sqlStr.append(" WHEN crl.record_status = 'S' THEN 'Start'");
		sqlStr.append(" WHEN crl.record_status = 'X' THEN DECODE((SELECT 1 FROM doctor@iweb doc WHERE doc.doccode = crl.ACTION_BY),1,'1st Renewal(Email) Edit by Doctor','1st Renewal(Email)')");
		sqlStr.append(" WHEN crl.record_status = 'Y' THEN DECODE((SELECT 1 FROM doctor@iweb doc WHERE doc.doccode = crl.ACTION_BY),1,'2nd Renewal(Email) Edit by Doctor','2nd Renewal(Email)')");
		sqlStr.append(" WHEN crl.record_status = 'Z' THEN DECODE((SELECT 1 FROM doctor@iweb doc WHERE doc.doccode = crl.ACTION_BY),1,'3rd Renewal(Email) Edit by Doctor','3rd Renewal(Email)')");
		sqlStr.append(" WHEN crl.record_status = 'I' THEN '1rd Renewal(Post)'");
		sqlStr.append(" WHEN crl.record_status = 'L' THEN '2rd Renewal(Post)'");
		sqlStr.append(" WHEN crl.record_status = 'K' THEN '3rd Renewal(Post)'");
		sqlStr.append(" WHEN crl.record_status = 'R' THEN 'Application received'");
		sqlStr.append(" WHEN crl.record_status = 'F' THEN 'User follow up'");
		sqlStr.append(" WHEN crl.record_status = 'V' THEN 'Information verified'");
		sqlStr.append(" WHEN crl.record_status = 'A' THEN 'Approved'");
		sqlStr.append(" WHEN crl.record_status = 'N' THEN 'Inactive'");
		sqlStr.append(" WHEN crl.record_status = 'J' THEN 'Reject'");
		sqlStr.append(" WHEN crl.record_status = 'D' THEN 'Deleted'");
		sqlStr.append(" WHEN crl.record_status = 'U' THEN 'Updated - HATs&Email'");
		sqlStr.append(" WHEN crl.record_status = 'P' THEN 'Updated - HATs&Post'");
		sqlStr.append(" WHEN crl.record_status = 'E' THEN 'Updated - No Response' END) AS status,");
		sqlStr.append(" DECODE((SELECT 1 FROM doctor@iweb doc WHERE doc.doccode = crl.ACTION_BY),1,(SELECT doc.docFname||', '||docGname FROM doctor@iweb doc WHERE doc.doccode = crl.ACTION_BY),NVL(s.co_staffname, crl.ACTION_BY)) AS insertBy,");
		sqlStr.append(" TO_CHAR(crl.insert_date,'DD/MM/YYYY HH24:MI') AS insert_date, ");
		sqlStr.append(" crl.REMARKS ");
		sqlStr.append(" FROM cts_record_log crl");
		sqlStr.append(" LEFT JOIN co_staffs s ON crl.ACTION_BY = s.co_staff_id ");
		sqlStr.append(" LEFT JOIN doctor@iweb doc ON crl.ACTION_BY = doc.doccode ");
		sqlStr.append(" WHERE crl.cts_no = ? ");
		sqlStr.append(" ORDER BY crl.insert_date DESC");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { ctsNo });
	}

	public static String getRecordType(String ctsNO) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT  ");
		sqlStr.append("record_type  ");
		sqlStr.append("FROM cts_record ");
		sqlStr.append("WHERE cts_no = '");
		sqlStr.append(ctsNO);
		sqlStr.append("'");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			String recordType = reportableListObject.getValue(0);
			return recordType;
		} else {
			return null;
		}
	}

	public static String getRecordStatus(String ctsNO) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT  ");
		sqlStr.append("record_status  ");
		sqlStr.append("FROM cts_record ");
		sqlStr.append("WHERE cts_no = '");
		sqlStr.append(ctsNO);
		sqlStr.append("'");

		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			String recordStatus = reportableListObject.getValue(0);
			return recordStatus;
		} else {
			return null;
		}
	}

	public static boolean addApproval(String ctsNO, String actionNo, String cmtName, String approvalDate) {
		String docCode = getDocCode(ctsNO);
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO docapvlink@iweb (");
		sqlStr.append("dalid,doccode,cmtname,");
		if (actionNo != null && actionNo.length() > 0) {
			sqlStr.append("actno,");
		}
		sqlStr.append("apvdate) ");
		sqlStr.append("VALUES (");
		sqlStr.append(" seq_docapvlink.nextval@iweb,'");
		sqlStr.append(docCode);
		sqlStr.append("','");
		sqlStr.append(cmtName);
		if (actionNo != null && actionNo.length() > 0) {
			sqlStr.append("','");
			sqlStr.append(actionNo);
		}
		sqlStr.append("',TO_DATE('");
		sqlStr.append(approvalDate);
		sqlStr.append("','DD/MM/YYYY')) ");

		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			return true;
		} else {
			return false;
		}
	}

	private static String getCtsNO(String ctsType) {
		String ctsNO = null;
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT '");
		sqlStr.append(ctsType);
		if ("N".equals(ctsType)) {
			sqlStr.append("'||SUBSTR('00000000'||NEW_CTS_RECORD_SEQ.NEXTVAL,-9,10) FROM DUAL");
		} else if ("R".equals(ctsType)) {
			sqlStr.append("'||SUBSTR('00000000'||CTS_RECORD_SEQ.NEXTVAL,-9,10) FROM DUAL");
		}

		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			ctsNO = reportableListObject.getValue(0);
			// set 1 for initial
			if (ctsNO == null || ctsNO.length() == 0) return "N001";
		}
		return ctsNO;

	}

	private static String getDocCode(String ctsNO) {
		String docCode = null;
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DOCCODE ");
		sqlStr.append("FROM CTS_RECORD ");
		sqlStr.append("WHERE CTS_NO = '");
		sqlStr.append(ctsNO);
		sqlStr.append("'");

		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			docCode = reportableListObject.getValue(0);
			return docCode;
		} else {
			return null;
		}
	}

	private static ArrayList getHKMCLicNo(String ctsNO) {
		String docCode = null;
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DOCLICNO1, DOCFNAME, DOCFNAME, DOCEMAIL ");
		sqlStr.append("FROM CTS_DOCTOR_NEW ");
		sqlStr.append("WHERE CTS_NO = ?");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { ctsNO });
	}

	private static String getCtsPwd(String ctsNo) {
		String pwd = null;
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT password FROM cts_record WHERE cts_no = '");
		sqlStr.append(ctsNo);
		sqlStr.append("'");

		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			pwd = reportableListObject.getValue(0);
		}
		return pwd;
	}

	public static String checkRenewRecord(String ctsNO, String pwd) {
		String docCode = null;
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DOCCODE ");
		sqlStr.append("FROM CTS_RECORD ");
		sqlStr.append("WHERE UPPER(CTS_NO) = '");
		sqlStr.append(ctsNO);
		sqlStr.append("' AND UPPER(PASSWORD) = '");
		sqlStr.append(pwd);
		sqlStr.append("' ");

		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			docCode = reportableListObject.getValue(0);
			return docCode;
		} else {
			return null;
		}
	}

	public static String getFolderId(String ctsNo) {
		StringBuffer sqlStr = new StringBuffer();
		if (ctsNo != null) {
			sqlStr.append("SELECT folder_id FROM CTS_RECORD WHERE UPPER(CTS_NO) = '");
			sqlStr.append(ctsNo);
			sqlStr.append("' ");
		} else {
			sqlStr.append("SELECT cts_doctor_seq.NEXTVAL FROM DUAL");
		}
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return null;
		}
	}

	public static String getNewFolderId(String ctsNo) {
		String folderId = null;
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT FOLDER_ID ");
		sqlStr.append("FROM CTS_DOCTOR_NEW ");
		sqlStr.append("WHERE CTS_NO = '");
		sqlStr.append(ctsNo);
		sqlStr.append("'");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			folderId = reportableListObject.getValue(0);
			return folderId;
		} else {
			return null;
		}
	}

	public static String getNewDocCts() {
		String docCode = null;
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT 'N'||SUBSTR('00000000'||TEMP_DOCCODE_SEQ.NEXTVAL,-3,10) FROM DUAL");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			docCode = reportableListObject.getValue(0);
			// set 1 for initial
			if (docCode == null || docCode.length() == 0) return "N001";
		}
		return docCode;
	}

	public static String getNewDoc() {
		String docCode = null;
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT 'N'||SUBSTR('00000000'||NEWCTS_DOC_SEQ.NEXTVAL,-3,10) FROM DUAL");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			docCode = reportableListObject.getValue(0);
		}
		return docCode;
	}

	public static String checkNewDocRecord(String ctsNO, String pwd) {
		String recStatus = null;
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT RECORD_STATUS ");
		sqlStr.append("FROM CTS_DOCTOR_NEW ");
		sqlStr.append("WHERE UPPER(CTS_NO) = '");
		sqlStr.append(ctsNO);
		sqlStr.append("' AND PASSWORD = '");
		sqlStr.append(pwd);
		sqlStr.append("' ");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			recStatus = reportableListObject.getValue(0);
			return recStatus;
		} else {
			return null;
		}
	}

	public static boolean updateCTSRecordLock(String ctsNO, String lock) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CTS_DOCTOR_NEW ");
		sqlStr.append("SET RLOCK = TO_NUMBER('");
		sqlStr.append(lock);
		sqlStr.append("')");
		sqlStr.append("WHERE UPPER(CTS_NO) = '");
		sqlStr.append(ctsNO);
		sqlStr.append("'");
		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			return true;

		} else {
			return false;
		}
	}

	public static String checkRecordLock(String ctsNO) {
		String rlock = null;
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT RLOCK ");
		sqlStr.append("FROM CTS_DOCTOR_NEW ");
		sqlStr.append("WHERE UPPER(CTS_NO) = '");
		sqlStr.append(ctsNO);
		sqlStr.append("'");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			rlock = reportableListObject.getValue(0);
			return rlock;
		} else {
			return null;
		}
	}

	public static boolean updateHatDoc(String ctsNo, String docTDate1, String docTDate3) {
		String docTDate = null;

		if (docTDate1 != null && docTDate1.length() > 0) {
			docTDate = docTDate1;
		} else {
			docTDate = docTDate3;
		}

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE doctor@iweb doc ");
		sqlStr.append("SET ");
		sqlStr.append(" docfname = ");
		sqlStr.append("(SELECT UPPER(cdoc.docfname) FROM cts_doctor cdoc WHERE cdoc.doccode = doc.doccode),");
		sqlStr.append(" docgname = ");
		sqlStr.append("(SELECT UPPER(cdoc.docgname) FROM cts_doctor cdoc WHERE cdoc.doccode = doc.doccode),");
		sqlStr.append(" doccname = ");
		sqlStr.append("(SELECT UPPER(cdoc.doccname) FROM cts_doctor cdoc WHERE cdoc.doccode = doc.doccode),");
		sqlStr.append(" docotel = ");
		sqlStr.append("(SELECT UPPER(cdoc.docotel) FROM cts_doctor cdoc WHERE cdoc.doccode = doc.doccode),");
		sqlStr.append(" docptel = ");
		sqlStr.append("(SELECT UPPER(cdoc.docptel) FROM cts_doctor cdoc WHERE cdoc.doccode = doc.doccode),");
		sqlStr.append(" docmtel = ");
		sqlStr.append("(SELECT UPPER(cdoc.docmtel) FROM cts_doctor cdoc WHERE cdoc.doccode = doc.doccode),");
		sqlStr.append(" dochtel = ");
		sqlStr.append("(SELECT UPPER(cdoc.dochtel) FROM cts_doctor cdoc WHERE cdoc.doccode = doc.doccode),");
		sqlStr.append(" dochomadd1 = ");
		sqlStr.append("(SELECT UPPER(cdoc.dochomadd1) FROM cts_doctor cdoc WHERE cdoc.doccode = doc.doccode),");
		sqlStr.append(" dochomadd2 = ");
		sqlStr.append("(SELECT UPPER(cdoc.dochomadd2) FROM cts_doctor cdoc WHERE cdoc.doccode = doc.doccode),");
		sqlStr.append(" dochomadd3 = ");
		sqlStr.append("(SELECT UPPER(cdoc.dochomadd3) FROM cts_doctor cdoc WHERE cdoc.doccode = doc.doccode),");
		sqlStr.append(" dochomadd4 = ");
		sqlStr.append("(SELECT UPPER(cdoc.dochomadd4) FROM cts_doctor cdoc WHERE cdoc.doccode = doc.doccode),");
		sqlStr.append(" docadd1 = ");
		sqlStr.append("(SELECT UPPER(cdoc.docadd1) FROM cts_doctor cdoc WHERE cdoc.doccode = doc.doccode),");
		sqlStr.append(" docadd2 = ");
		sqlStr.append("(SELECT UPPER(cdoc.docadd2) FROM cts_doctor cdoc WHERE cdoc.doccode = doc.doccode),");
		sqlStr.append(" docadd3 = ");
		sqlStr.append("(SELECT UPPER(cdoc.docadd3) FROM cts_doctor cdoc WHERE cdoc.doccode = doc.doccode),");
		sqlStr.append(" docadd4 = ");
		sqlStr.append("(SELECT UPPER(cdoc.docadd4) FROM cts_doctor cdoc WHERE cdoc.doccode = doc.doccode),");
		sqlStr.append(" docemail = ");
		sqlStr.append("(SELECT UPPER(cdoc.docemail) FROM cts_doctor cdoc WHERE cdoc.doccode = doc.doccode),");
		sqlStr.append(" docfaxno = ");
		sqlStr.append("(SELECT UPPER(cdoc.docfaxno) FROM cts_doctor cdoc WHERE cdoc.doccode = doc.doccode), ");
		sqlStr.append(" doctdate = TO_DATE('");
		sqlStr.append(docTDate);
		sqlStr.append("','DD/MM/YYYY') ");
		sqlStr.append(", apldate = ");
		sqlStr.append("(SELECT UPPER(cr.hkmc_lic_expdate) FROM cts_record cr WHERE cr.doccode = doc.doccode AND cr.cts_no = '");
		sqlStr.append(ctsNo);
//		sqlStr.append("'), docinsurcomp = ");
//		sqlStr.append("(SELECT UPPER(cr.micd_ins_carrier) FROM cts_record cr WHERE cr.doccode = doc.doccode AND cr.cts_no = '");
//		sqlStr.append(ctsNo);
		sqlStr.append("'), mpscdate = ");
		sqlStr.append("(SELECT UPPER(cr.micd_ins_expdate) FROM cts_record cr WHERE cr.doccode = doc.doccode AND cr.cts_no = '");
		sqlStr.append(ctsNo);
		sqlStr.append("') ");
		sqlStr.append(" WHERE doc.doccode = ");
		sqlStr.append("(SELECT cr.doccode FROM cts_record cr WHERE cr.cts_no = '");
		sqlStr.append(ctsNo);
		sqlStr.append("')");
		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			return true;
		} else {
			return false;
		}
	}

	public static ArrayList getSpecialty(String specCode) {
		// fetch staff
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT s.spccode,s.spcname ");
		sqlStr.append("FROM spec@iweb s ");
		if (specCode != null && specCode.length() > 0) {
			sqlStr.append("WHERE s.spccode = '");
			sqlStr.append(specCode);
			sqlStr.append("' ");
		}
		sqlStr.append("ORDER BY s.spcname ASC ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getSuppAns(String formId, String ctsNo, String quest_id) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT TRIM(CTS_QUESTION_DETAIL.SUPPORT_DETAIL) ");
		sqlStr.append(" FROM CTS_FORM, CTS_QUESTION, CTS_QUESTION_DETAIL ");
		sqlStr.append(" WHERE CTS_FORM.FORMID = CTS_QUESTION.FORMID ");
		sqlStr.append(" AND CTS_QUESTION.QUESTID = CTS_QUESTION_DETAIL.QUESTID ");
		sqlStr.append(" AND CTS_FORM.FORMID = '");
		sqlStr.append(formId);
		sqlStr.append("' ");
		sqlStr.append(" AND CTS_QUESTION_DETAIL.CTS_NO = '");
		sqlStr.append(ctsNo);
		sqlStr.append("' ");
		sqlStr.append(" AND CTS_QUESTION.QUESTID = '");
		sqlStr.append(quest_id);
		sqlStr.append("' ");
		sqlStr.append(" AND CTS_FORM.ENABLED = 1 ");
		sqlStr.append(" AND CTS_QUESTION.ENABLED = 1 ");
		sqlStr.append(" ORDER BY CTS_QUESTION.QUESTSEQ ASC");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getformQuest(String formId, String ctsNo) {
		StringBuffer sqlStr = new StringBuffer();

		if (ctsNo != null && ctsNo.length() > 0) {
			sqlStr.append(" SELECT CTS_QUESTION.QUESTID, ");
			sqlStr.append("  CTS_QUESTION.QUESTDESC, ");
			sqlStr.append("  TRIM(CTS_QUESTION_DETAIL.ANSWER), ");
			sqlStr.append("  TRIM(CTS_QUESTION_DETAIL.SUPPORT_DETAIL) ");
			sqlStr.append(" FROM CTS_FORM ");
			sqlStr.append(" INNER JOIN CTS_QUESTION ON CTS_FORM.FORMID = CTS_QUESTION.FORMID ");
			sqlStr.append(" LEFT JOIN CTS_QUESTION_DETAIL ON CTS_QUESTION.QUESTID = CTS_QUESTION_DETAIL.QUESTID ");
			sqlStr.append(" AND CTS_QUESTION_DETAIL.CTS_NO = '");
			sqlStr.append(ctsNo);
			sqlStr.append("' ");
			sqlStr.append(" WHERE CTS_FORM.FORMID = '");
			sqlStr.append(formId);
			sqlStr.append("' ");
			sqlStr.append(" AND CTS_FORM.ENABLED = 1 ");
			sqlStr.append(" AND CTS_QUESTION.ENABLED = 1 ");
			sqlStr.append(" ORDER BY CTS_QUESTION.QUESTSEQ ASC");
		} else {
			sqlStr.append("SELECT CTS_QUESTION.QUESTID, ");
			sqlStr.append("CTS_QUESTION.QUESTDESC,'N',NULL ");
			sqlStr.append(" FROM CTS_FORM, CTS_QUESTION ");
			sqlStr.append(" WHERE CTS_FORM.FORMID = CTS_QUESTION.FORMID ");
			sqlStr.append(" AND CTS_FORM.FORMID = '");
			sqlStr.append(formId);
			sqlStr.append("' ");
			sqlStr.append(" AND CTS_FORM.ENABLED = 1 ");
			sqlStr.append(" AND CTS_QUESTION.ENABLED = 1 ");
			sqlStr.append(" ORDER BY CTS_QUESTION.QUESTSEQ ASC");
		}
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}


	public static ArrayList getNewPrivilegesDtl(String ctsNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT PRIVILEGES_ID, PRIVILEGES_VALUE, OTHERS, OTHERS2 from  CTS_NEW_PRIVILEGES_DTL ");
		sqlStr.append("WHERE CTS_NO = '");
		sqlStr.append(ctsNo);
		sqlStr.append("' ORDER BY TO_NUMBER(PRIVILEGES_ID)");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getAppList(String ctsNo) {
		StringBuffer sqlStr = new StringBuffer();
		String appStatus = null;
		sqlStr.append("SELECT 'DR. '||(SELECT CD.DOCFNAME||' '||CD.DOCGNAME FROM CTS_DOCTOR CD WHERE CD.DOCCODE = CE.VALUE1), ");
		sqlStr.append(" CE.VALUE2, CE.REMARKS FROM CTS_EXTRA CE WHERE CE.CTS_NO = '");
		sqlStr.append(ctsNo);
		sqlStr.append("' AND CE.CTS_TYPE = 'APPROVAL'");
		sqlStr.append(" ORDER BY VALUE1 ASC");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList approveAll(String ctsNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CTS_EXTRA ");
		sqlStr.append("SET VALUE2 = 1 ");
		sqlStr.append("WHERE CTS_NO = '");
		sqlStr.append(ctsNo);
		sqlStr.append("AND CTS_TYPE = 'APPROVAL'");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static boolean createFormQuestion (String ctsNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT cts_no FROM cts_question_detail WHERE cts_no = '");
		sqlStr.append(ctsNo);
		sqlStr.append("' AND SUPPORT_DETAIL IS NULL");

		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() < 1) {
			StringBuffer sqlStr1 = new StringBuffer();
			sqlStr1.append("INSERT INTO CTS_QUESTION_DETAIL VALUE ");
			sqlStr1.append("SELECT '");
			sqlStr1.append(ctsNo);
			sqlStr1.append("', questid");
			sqlStr1.append(", default_val, NULL");
			sqlStr1.append(" FROM cts_question");
			sqlStr1.append(" WHERE questid LIKE 'Q%'");
			sqlStr1.append(" AND formid = 'F0001'");
			if (UtilDBWeb.updateQueue(sqlStr1.toString())) {
					return true;
			} else {
				return false;
			}
		} else {
			return false;
		}
	}

	public static boolean updatFormQuestion (String ctsNo, String questid, String answer) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CTS_QUESTION_DETAIL ");
		sqlStr.append("SET ANSWER = '");
		sqlStr.append(answer);
		sqlStr.append("' WHERE QUESTID = TRIM('");
		sqlStr.append(questid);
		sqlStr.append("') AND CTS_NO = '");
		sqlStr.append(ctsNo);
		sqlStr.append("'");

		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
				return true;
		} else {
			return false;
		}
	}

	public static boolean updatFormQuestion (String ctsNo, String questid, String answer, String supDtl) {
		StringBuffer sqlStr = new StringBuffer();
		Vector<String> sqlValue = new Vector<String>();
		sqlStr.append("UPDATE CTS_QUESTION_DETAIL ");
		sqlStr.append("SET ANSWER = ?");
		sqlValue.add(answer);
		if ("Y".equals(answer)) {
			sqlStr.append(", SUPPORT_DETAIL = ?");
			sqlValue.add(supDtl);
		} else {
			sqlStr.append(", SUPPORT_DETAIL = NULL ");
		}
		sqlStr.append(" WHERE QUESTID = TRIM('");
		sqlStr.append(questid);
		sqlStr.append("') AND CTS_NO = '");
		sqlStr.append(ctsNo);
		sqlStr.append("'");
		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				(String[]) sqlValue.toArray(new String[sqlValue.size()]))) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean createCTSQuestionDtl (String ctsNo, String formID) {
			StringBuffer sqlStr1 = new StringBuffer();
			sqlStr1.append("INSERT INTO CTS_QUESTION_DETAIL VALUE ");
			sqlStr1.append("SELECT '");
			sqlStr1.append(ctsNo);
			sqlStr1.append("', questid");
			sqlStr1.append(", default_val, NULL");
			sqlStr1.append(" FROM cts_question");
			sqlStr1.append(" WHERE questid LIKE '%Q%'");
			sqlStr1.append(" AND formid = '");
			sqlStr1.append(formID);
			sqlStr1.append("'");
			if (UtilDBWeb.updateQueue(sqlStr1.toString())) {
					return true;
			} else {
				return false;
			}
	}

	public static boolean insertNewPrivileges (String ctsNo, String id) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CTS_NEW_PRIVILEGES_DTL (");
		sqlStr.append("CTS_NO, PRIVILEGES_ID, PRIVILEGES_VALUE, OTHERS, OTHERS2) VALUES ('");
		sqlStr.append(ctsNo);
		sqlStr.append("','");
		sqlStr.append(id);
		sqlStr.append("',0,null,null)");
		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
				return true;
		} else {
			return false;
		}
	}

	public static boolean updateNewPrivileges (String ctsNo, String id, String value, String others, String others2) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CTS_NEW_PRIVILEGES_DTL ");
		sqlStr.append("SET PRIVILEGES_VALUE = '");
		sqlStr.append(value);
		sqlStr.append("'");
		if (others != null && others.length() > 0) {
			sqlStr.append(",OTHERS = '");
			sqlStr.append(others);
			sqlStr.append("'");
		} else {
			sqlStr.append(",OTHERS = null");
		}
		if (others2 != null && others2.length() > 0) {
			sqlStr.append(",OTHERS2 = '");
			sqlStr.append(others2);
			sqlStr.append("'");
		} else {
			sqlStr.append(",OTHERS2 = null");
		}
		sqlStr.append(" WHERE PRIVILEGES_ID = '");
		sqlStr.append(id);
		sqlStr.append("' AND CTS_NO = '");
		sqlStr.append(ctsNo);
		sqlStr.append("'");
		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
				return true;
		} else {
			return false;
		}
	}

	public static ArrayList getWaitAppDoc(String approver, String docNo, String recType, String recStatus, String docFname, String docGname) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append(" cr.cts_no, ");
		sqlStr.append(" cr.doccode, replace(DOC.DOCFNAME,'''','\''')||' '||replace(doc.docgname,'''','\''') AS docname, ");
		sqlStr.append(" (SELECT s.spcname FROM spec@iweb s WHERE s.spccode = doc.spccode) AS specialty, ");
		sqlStr.append(" TO_CHAR(doc.docsdate,'DD/MM/YYYY'), ");
		sqlStr.append(" TO_CHAR(doc.doctdate,'DD/MM/YYYY'), ");
		sqlStr.append(" doc.docemail, ");
		sqlStr.append(" cr.record_type, ");
		sqlStr.append(" cr.record_status, ");
		sqlStr.append(" cr.last_stncdate, ");
		sqlStr.append(" cr.password, ");
		sqlStr.append(" TO_CHAR(cr.insert_date,'DD/MM/YYYY'), ");
		sqlStr.append(" TO_CHAR(cr.modified_date,'DD/MM/YYYY'), ");
		sqlStr.append(" cr.assign_approver, ");
		sqlStr.append(" sra.record_status ");
		sqlStr.append("FROM cts_record cr ");
		sqlStr.append("INNER JOIN cts_doctor doc ON cr.doccode = doc.doccode ");
		sqlStr.append("LEFT JOIN cts_record_approver sra ON cr.cts_no = sra.cts_no and sra.assign_approver = '");
		sqlStr.append(approver);
		sqlStr.append("' ");
		sqlStr.append("WHERE (cr.assign_approver = '");
		sqlStr.append(approver);
		sqlStr.append("' OR '");
		sqlStr.append(approver);
		sqlStr.append("' IN (SELECT assign_approver FROM CTS_RECORD_APPROVER WHERE CTS_NO = cr.cts_no))");

		if (docNo != null && docNo.length() > 0) {
			sqlStr.append(" AND cr.doccode = '");
			sqlStr.append(docNo);
			sqlStr.append("' ");
		}

		if (recType != null && recType.length() > 0) {
			sqlStr.append(" AND cr.record_type = '");
			sqlStr.append(recType);
			sqlStr.append("' ");
		}

		if (recStatus != null && recStatus.length() > 0) {
			sqlStr.append(" AND cr.record_status = '");
			sqlStr.append(recStatus);
			sqlStr.append("' ");
		} else {
			sqlStr.append(" AND cr.record_status IN ('V') ");
		}

		if (docFname != null && docFname.length() > 0) {
			sqlStr.append(" AND UPPER(doc.docfname) LIKE UPPER('%");
			sqlStr.append(docFname);
			sqlStr.append("%') ");
		}

		if (docGname != null && docGname.length() > 0) {
			sqlStr.append(" AND UPPER(doc.docgname) LIKE UPPER('%");
			sqlStr.append(docGname);
			sqlStr.append("%') ");
		}
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getNewWaitAppDoc(String docNo, String recType, String recStatus, String docFname, String docGname) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("cr.cts_no, ");
		sqlStr.append("cr.doccode, replace(DOC.DOCFNAME,'''','\''')||' '||replace(doc.docgname,'''','\''') AS docname, ");
		sqlStr.append("(SELECT s.spcname FROM spec@iweb s WHERE s.spccode = doc.spccode) AS specialty, ");
		sqlStr.append("TO_CHAR(doc.docsdate,'DD/MM/YYYY'), ");
		sqlStr.append("TO_CHAR(doc.doctdate,'DD/MM/YYYY'), ");
		sqlStr.append("doc.docemail, ");
		sqlStr.append("cr.record_type, ");
		sqlStr.append("cr.record_status, ");
		sqlStr.append("cr.last_stncdate, ");
		sqlStr.append("cr.password, ");
		sqlStr.append("TO_CHAR(cr.insert_date,'DD/MM/YYYY'), ");
		sqlStr.append("TO_CHAR(cr.modified_date,'DD/MM/YYYY') ");
		sqlStr.append("FROM cts_record cr, cts_doctor doc ");
		sqlStr.append("WHERE cr.doccode = doc.doccode ");

		if (docNo != null && docNo.length() > 0) {
			sqlStr.append(" AND cr.doccode = '");
			sqlStr.append(docNo);
			sqlStr.append("' ");
		}

		if (recType != null && recType.length() > 0) {
			sqlStr.append(" AND cr.record_type = '");
			sqlStr.append(recType);
			sqlStr.append("' ");
		} else {
			sqlStr.append(" AND cr.record_type IN ('N') ");
		}

		if (recStatus != null && recStatus.length() > 0) {
			sqlStr.append(" AND cr.record_status = '");
			sqlStr.append(recStatus);
			sqlStr.append("' ");
		} else {
			sqlStr.append(" AND cr.record_status IN ('S') ");
		}

		if (docFname != null && docFname.length() > 0) {
			sqlStr.append(" AND UPPER(doc.docfname) LIKE UPPER('%");
			sqlStr.append(docFname);
			sqlStr.append("%') ");
		}

		if (docGname != null && docGname.length() > 0) {
			sqlStr.append(" AND UPPER(doc.docgname) LIKE UPPER('%");
			sqlStr.append(docGname);
			sqlStr.append("%') ");
		}
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static String getDocSmtDate(String cstNo) {
		String docSmtDate = null;
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT TO_CHAR(INSERT_DATE,'YYYYMMDD')");
		sqlStr.append(" FROM CTS_RECORD_LOG ");
		sqlStr.append(" WHERE CTS_NO = '");
		sqlStr.append(cstNo);
		sqlStr.append("' AND RECORD_STATUS = 'R' ");
		sqlStr.append(" ORDER BY INSERT_DATE DESC ");
		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			docSmtDate = reportableListObject.getValue(0);
			return docSmtDate;
		} else {
			return null;
		}
	}

	public static ArrayList getApproveList() {
		// fetch approve list
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT cts_no, cd.doccode||'-'||cd.docfname||','||cd.docgname ");
		sqlStr.append("FROM cts_record cr, cts_doctor cd ");
		sqlStr.append("WHERE cr.doccode = cd.doccode ");
		sqlStr.append("AND cr.record_status = 'A' ");
		sqlStr.append("ORDER BY cd.doccode, cr.insert_date ASC");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getNoResponse() {
		// fetch approve list
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT cts_no, cd.doccode||'-'||cd.docfname||','||cd.docgname ");
		sqlStr.append(" FROM cts_record cr, cts_doctor cd ");
		sqlStr.append(" WHERE cr.doccode = cd.doccode ");
		sqlStr.append(" AND cr.record_status IN ('X','Y','Z','I','L','K') ");
		sqlStr.append(" ORDER BY cd.doccode, cr.insert_date ASC");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static boolean createGrAppRecord (String ctsNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DISTINCT CTS_NO FROM CTS_EXTRA WHERE cts_no = '");
		sqlStr.append(ctsNo);
		sqlStr.append("' AND CTS_TYPE = 'APPROVAL'");

		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() < 1) {
			StringBuffer sqlStr1 = new StringBuffer();
			sqlStr1.append("INSERT INTO CTS_EXTRA ");
			sqlStr1.append("SELECT 'APPROVAL', '");
			sqlStr1.append(ctsNo);
			sqlStr1.append("', DOCCODE, '0', NULL ");
			sqlStr1.append("FROM CTS_DOC_APPROVER ");
			sqlStr1.append("WHERE ENABLED = 1");
			if (UtilDBWeb.updateQueue(sqlStr1.toString())) {
					return true;
			} else {
				return false;
			}
		} else {
			return false;
		}
	}

	public static String getGrAppStatus (String ctsNo, String docCode) {
		StringBuffer sqlStr = new StringBuffer();
		String appStatus = null;
		sqlStr.append("SELECT VALUE2 FROM CTS_EXTRA WHERE cts_no = '");
		sqlStr.append(ctsNo);
		sqlStr.append("' AND VALUE1 = '");
		sqlStr.append(docCode);
		sqlStr.append("' AND CTS_TYPE = 'APPROVAL'");

		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			appStatus = reportableListObject.getValue(0);
			return appStatus;
		} else {
			return "-2";
		}
	}

	public static Boolean notAllApproved (String ctsNo) {
		StringBuffer sqlStr = new StringBuffer();
		String appStatus = null;
		sqlStr.append("SELECT COUNT(VALUE1) FROM CTS_EXTRA WHERE cts_no = '");
		sqlStr.append(ctsNo);
		sqlStr.append("' AND VALUE2 = '0'");
		sqlStr.append(" AND CTS_TYPE = 'APPROVAL'");

		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);

			try {
				if (Integer.parseInt(row.getFields0())>0) {
					return true;
				} else {
					return false;
				}
			} catch (Exception e) {
				return false;
			}
		} else {
			return false;
		}
	}

	public static Boolean rejectExists (String ctsNo) {
		StringBuffer sqlStr = new StringBuffer();
		String appStatus = null;
		sqlStr.append("SELECT COUNT(VALUE1) FROM CTS_EXTRA WHERE cts_no = '");
		sqlStr.append(ctsNo);
		sqlStr.append("' AND VALUE2 = '-1'");
		sqlStr.append(" AND CTS_TYPE = 'APPROVAL'");

		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);

			try {
				if (Integer.parseInt(row.getFields0())>0) {
					return true;
				} else {
					return false;
				}
			} catch (Exception e) {
				return false;
			}
		} else {
			return false;
		}
	}

	public static String docUploadCount (String ctsNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT COUNT(CO_DOCUMENT_ID) FROM CO_DOCUMENT_GENERAL WHERE CO_MODULE_CODE='cts' AND CO_ENABLED = '0'");
		sqlStr.append(" AND CO_KEY_ID = (SELECT FOLDER_ID FROM CTS_RECORD where CTS_NO ='");
		sqlStr.append(ctsNo);
		sqlStr.append("')");

		ArrayList result = UtilDBWeb.getReportableList(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getFields0();
		} else {
			return "-1";
		}
	}

	public static void genRenewDocList(String txCode) {
		UtilDBWeb.executeFunction(txCode);
	}

	public static boolean insertCtsLog(String ctsNO, String recStatus, String approver, String staffID, String remarks) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CTS_RECORD_LOG (");
		sqlStr.append("	CTS_NO, RECORD_STATUS, ACTION_BY, INSERT_BY, INSERT_DATE, REMARKS) ");
		sqlStr.append("VALUES ('");
		sqlStr.append(ctsNO);
		sqlStr.append("',");
		if (recStatus != null && recStatus.length() > 0) {
			sqlStr.append("'");
			sqlStr.append(recStatus);
			sqlStr.append("','");
		} else {
			sqlStr.append("(SELECT RECORD_STATUS FROM CTS_RECORD WHERE CTS_NO = '");
			sqlStr.append(ctsNO);
			sqlStr.append("'),'");
		}
		sqlStr.append(approver);
		sqlStr.append("','");
		sqlStr.append(staffID);
		sqlStr.append("', sysdate,'");
		sqlStr.append(remarks);
		sqlStr.append("')");
		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			return true;
		} else {
			return false;
		}
	}

	public static ArrayList getDocList(String siteCode, String moduleCode, String documentID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_DOCUMENT_ID, CO_DIRECTORY, CO_DOCUMENT_DESC ");
		sqlStr.append("FROM   CO_DOCUMENT_GENERAL ");
		sqlStr.append("WHERE  CO_SITE_CODE = ? ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_KEY_ID = ? ");
		sqlStr.append("AND    CO_ENABLED = 1 ");
		sqlStr.append("ORDER BY CO_DOCUMENT_DESC ");

		return UtilDBWeb.getReportableList(
				sqlStr.toString(),
				new String[] {siteCode, moduleCode, documentID});
	}

	public static boolean chkApprovalDoc(String docCode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DOCCODE");
		sqlStr.append(" FROM CTS_DOC_APPROVER ");
		sqlStr.append(" WHERE DOCCODE = '");
		sqlStr.append(docCode);
		sqlStr.append("' AND ENABLED = '1'");

		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean ctsAssignDocReset(String ctsNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("DELETE CTS_RECORD_APPROVER WHERE CTS_NO = ?");

		return UtilDBWeb.updateQueue(sqlStr.toString(), new String[] {ctsNo});
	}

	public static boolean ctsAssignDoc(String ctsNo, String assignDoc) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CTS_RECORD ");
		sqlStr.append("SET ASSIGN_APPROVER = Trim(?) ");
		sqlStr.append("WHERE CTS_NO = ? ");

		if (UtilDBWeb.updateQueue(sqlStr.toString(), new String[] {assignDoc, ctsNo})) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean ctsAssignDocMultiple(String ctsNo, String assignDoc) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CTS_RECORD_APPROVER (CTS_NO, RECORD_STATUS, ASSIGN_APPROVER) SELECT CTS_NO, RECORD_STATUS, TRIM(?) FROM CTS_RECORD WHERE CTS_NO = ?");

		if (UtilDBWeb.updateQueue(sqlStr.toString(), new String[] {assignDoc, ctsNo})) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean execUptCTS(String txCode, UserBean userBean, String postDate) {
		return ConstantsErrorMessage.RETURN_PASS.equals(UtilDBWeb.callFunction(
				txCode,
				null,
				new String[] {
						userBean.getStaffID(),
						postDate
				}));
	}

	public static boolean ctsApprovalDoc (UserBean userBean, String ctsNO, String docCode, String recStatus, String command, String appRemarks) {
		Vector<String> sqlValue = new Vector<String>();
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CTS_RECORD ");
		sqlStr.append("SET MODIFIED_DATE = SYSDATE ");
		if (recStatus != null && recStatus.length() > 0) {
			sqlStr.append(", RECORD_STATUS = ?");
			sqlValue.add(recStatus);
		}
		sqlStr.append(" WHERE CTS_NO = '");
		sqlStr.append(ctsNO);
		sqlStr.append("'");

		if (UtilDBWeb.updateQueue(
				sqlStr.toString(),
				(String[]) sqlValue.toArray(new String[sqlValue.size()]))) {
			if (insertCtsLog(ctsNO, recStatus, userBean.getStaffID(), userBean.getStaffID(), "")) {
				StringBuffer sqlStr1 = new StringBuffer();
				sqlStr1.append("UPDATE CTS_EXTRA ");
				if ("approve".equals(command)) {
					sqlStr1.append("SET VALUE2 = '1' ");
				} else if ("reject".equals(command)) {
					sqlStr1.append("SET VALUE2 = '-1' ");
				} else if ("approveall".equals(command)) {
					sqlStr1.append("SET VALUE2 = '1' ");
				} else {
					sqlStr1.append("SET VALUE2 = '0' ");
				}
				sqlStr1.append(", REMARKS ='");
				sqlStr1.append(appRemarks);
				sqlStr1.append("' WHERE CTS_NO = '");
				sqlStr1.append(ctsNO);
				if ("approveall".equals(command)) {
					sqlStr1.append("' AND CTS_TYPE = 'APPROVAL' AND VALUE2 = '0'");
				} else {
					sqlStr1.append("' AND VALUE1 = '");
					sqlStr1.append(docCode);
					sqlStr1.append("' AND CTS_TYPE = 'APPROVAL'");
				}

				if (UtilDBWeb.updateQueue(sqlStr1.toString())) {
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		} else {
			return false;
		}
	}

	public static boolean ctsStatusUpt (UserBean userBean, String ctsNO, String recStatus) {
		Vector<String> sqlValue = new Vector<String>();
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE CTS_RECORD ");
		sqlStr.append("SET MODIFIED_DATE = SYSDATE, RECORD_STATUS = '");
		sqlStr.append(recStatus);
		sqlStr.append("' WHERE CTS_NO = '");
		sqlStr.append(ctsNO);
		sqlStr.append("'");

		if (UtilDBWeb.updateQueue(sqlStr.toString())) {
			if (insertCtsLog(ctsNO, recStatus, userBean.getStaffID(), userBean.getStaffID(), "")) {
				return true;
			} else {
				return false;
			}
		} else {
			return false;
		}
	}

	public static ArrayList checkNewDocExisting (String hkmclicno) {
		StringBuffer sqlStr = new StringBuffer();
		String appStatus = null;
		sqlStr.append("SELECT COUNT(1) FROM CTS_DOCTOR_NEW ");
		sqlStr.append("WHERE CTS_NO IN (");
		sqlStr.append("select cts_no from CTS_RECORD where UPPER(HKMC_LICNO) =UPPER('");
		sqlStr.append(hkmclicno);
		sqlStr.append("'))");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList checkDoctorCodeInHATS (String docCode) {
		StringBuffer sqlStr = new StringBuffer();
		String appStatus = null;
		sqlStr.append("SELECT COUNT(1) FROM DOCTOR@IWEB ");
		sqlStr.append("WHERE DOCSTS = -1 ");
		sqlStr.append("AND DOCCODE ='");
		sqlStr.append(docCode);
		sqlStr.append("'");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static String getEmailContent(String formId, String quest_id) {
		String content = null;
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT CQ.QUESTDESC FROM CTS_FORM CF, CTS_QUESTION CQ WHERE CF.FORMID = CQ.FORMID AND CF.FORMID = '" + formId+"' AND CQ.QUESTID = '" + quest_id+"' AND CF.ENABLED = 1  AND CQ.ENABLED = 1");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			content = reportableListObject.getValue(0);
			// set 1 for initial
			if (content == null || content.length() == 0) return null;
		}
		return content;
	}

	public static ArrayList getEmailList(String formId) {
		// fetch approve list
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CQ.QUESTDESC ");
		sqlStr.append("FROM CTS_FORM CF, CTS_QUESTION CQ ");
		sqlStr.append("WHERE CF.FORMID = CQ.FORMID AND CF.FORMID ='");
		sqlStr.append(formId);
		sqlStr.append("' AND CF.ENABLED = 1  AND CQ.ENABLED = 1");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getCTSNewPrivileges () {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT PRIVILEGES_ID, PRIVILEGES_DESC, ENABLED ");
		sqlStr.append("FROM CTS_NEW_PRIVILEGES ");
		sqlStr.append("ORDER BY PRIVILEGES_ID");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList fetchDocIDCoun() {
		// fetch appointment by doctor
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT COUCODE, COUDESC ");
		sqlStr.append("FROM   COUNTRY@iweb ");
		sqlStr.append("ORDER BY COUDESC ");
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static boolean sendEmail(String docCode, String callLoc, String fromStaffID, String ctsNo, String pwd, String recStatus) {
		String approvalStaffEmail = null;
		String emailFrom = null;
		String[] emailTo = null;
		String folderId = null;
		String docfname = null;
		String docgname = null;
		String[] docemail = null;
		String topic = null;
		String docSpCode = null;
		String docSpName = null;
		String renewDate = null;
		StringBuffer commentStr = null;

		Calendar calendar = Calendar.getInstance();

		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		String sysDate = dateFormat.format(calendar.getTime());
		calendar.add(Calendar.MONTH, 1);
		String sysDateNextMonth = dateFormat.format(calendar.getTime());
//		String attachment[] = null;
		// get Deadline date
		String cont1 = getEmailContent("M0001", "C0001");
		String cont2 = getEmailContent("M0001", "C0002");

		if ("away".equals(callLoc)) {
			Calendar calendar1 = Calendar.getInstance();
			SimpleDateFormat dateFormat1 = new SimpleDateFormat("yyyyMMdd");
			String submitDate = dateFormat1.format(calendar1.getTime());

			// get doctor email
			ArrayList docRecord = getDocList1(docCode);
			if (docRecord.size() > 0) {
				ReportableListObject row = (ReportableListObject) docRecord.get(0);
				docfname = row.getValue(1);
				docgname = row.getValue(2);
				docemail = getDoctorEmailList(row.getValue(5));
			}

			// get doctor attach folder number
			folderId = getFolderId(ctsNo);

			// get approval list
			ArrayList record = ApprovalUserDB.getApprovalUserList("cts", "approve", ConstantsServerSide.SITE_CODE, null, null);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				emailTo = new String[] {row.getValue(2)};
			}

			topic = "Doctor renewal information submit from " +  docfname + "," + docgname;

			// append url
			commentStr = new StringBuffer();
			commentStr.append(" <br>Doctor NO.: " + docCode);
			commentStr.append(" <br>Doctor First Name: " + docfname);
			commentStr.append(" <br>Doctor Given Name: " + docgname);
			if (ConstantsServerSide.isHKAH()) {
				commentStr.append(" <br>Please click <a href=\"\\\\hkim\\im\\VPMA\\Credential Renew Document\\");
			} else if (ConstantsServerSide.isTWAH()) {
				commentStr.append(" <br>Please click <a href=\"\\\\it-fs1\\dept\\VPMA\\Credential Renew Document\\");
			}
			commentStr.append(docCode+"-" + submitDate);
			commentStr.append("\">Intranet</a> to view the attachment.");

			if (docemail.length > 0) {
				emailFrom = docemail[0];
			}
		} else if ("home".equals(callLoc)) {
			emailFrom = UserDB.getUserEmail(null, fromStaffID);

			// get doctor email
			ArrayList docRecord = getDocList1(docCode);
			if (docRecord.size() > 0) {
				ReportableListObject row = (ReportableListObject) docRecord.get(0);
				docfname = row.getValue(1);
				docgname = row.getValue(2);
				emailTo = getDoctorEmailList(row.getValue(5));
				docSpCode = row.getValue(10);

				ArrayList record = getSpecialty(docSpCode);
				if (record.size() > 0) {
					ReportableListObject rowSpec = (ReportableListObject) record.get(0);
					docSpName =rowSpec.getValue(1);
				}
			}

			if ("X".equals(recStatus)) {
				if (ConstantsServerSide.isHKAH()) {
					topic = "Subject:  Renewal of Admission privilege";
				} else if (ConstantsServerSide.isTWAH()) {
					topic = "Renewal Application of TWAH Admission privilege";
				}
			} else if ("Y".equals(recStatus)) {
				if (ConstantsServerSide.isHKAH()) {
					topic = "Subject: Renewal of Admission privilege - 2nd reminder";
				} else if (ConstantsServerSide.isTWAH()) {
					topic = "Renewal Application of TWAH Admission privilege - reminder";
				}
			} else if ("Z".equals(recStatus)) {
				topic = "Subject: Renewal of Admission privilege - 3rd reminder";
			} else if ("U".equals(recStatus)) {
				topic = "Medical Staff Privilege Renewal";
				renewDate = pwd;
			}

			// append url
			commentStr = new StringBuffer();

			if ("X".equals(recStatus)) {
				commentStr.append("<font face=\"Arial\">");
				commentStr.append("<u>" + sysDate+"</u>");
				commentStr.append("<br>");
				commentStr.append("<br>");
				commentStr.append("Dear Dr. <u>");
				commentStr.append(TextUtil.capitailizeWord(docfname));
				commentStr.append(", ");
				commentStr.append(TextUtil.capitailizeWord(docgname));
				commentStr.append("</u>");
				commentStr.append("<br>");
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a001." + ConstantsServerSide.SITE_CODE));
				commentStr.append("<br>");
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a002.both")+" " + cont1);
				commentStr.append("<br>");
				commentStr.append("<br>");
				commentStr.append("<table border='1'><tr><td style='background-color:#AA0066;color:#FFFFFF'>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a003.both"));
				commentStr.append("</td></tr><tr><td><b>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a004a.both"));
				commentStr.append(ConstantsServerSide.OFFSITE_URL);
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a004b.both"));
				commentStr.append(ctsNo+"&docCode=" + docCode+"&siteCode=" + ConstantsServerSide.SITE_CODE);
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a005." + ConstantsServerSide.SITE_CODE));
				commentStr.append("</b><br><br>");
				commentStr.append("<b>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a006.both"));
				commentStr.append("</b><br>");
				commentStr.append("<br>Renew CTS NO.: " + ctsNo);
				commentStr.append("<br>Password: " + pwd);
				commentStr.append("<br><br><b>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a007.both"));
				commentStr.append(addMasterCodeTable(docCode));
				commentStr.append("</b><br><br></td></tr><tr><td style='background-color:#AA0066;color:#FFFFFF'>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a008.both"));
				commentStr.append("</td></tr><tr><td>");
				commentStr.append("<br><b>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a009." + ConstantsServerSide.SITE_CODE));
				commentStr.append("</b><br><b>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a010.both"));
				commentStr.append("</b><br></td></tr></table>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a012." + ConstantsServerSide.SITE_CODE));
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a013.both"));
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a014.both"));
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a015.both"));
				commentStr.append("<br><br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content8." + ConstantsServerSide.SITE_CODE));
				commentStr.append("</font>");
			} else if ("Y".equals(recStatus) || "Z".equals(recStatus)) {
				commentStr.append("<font face=\"Arial\">");
				commentStr.append("<u>" + sysDate+"</u>");
				commentStr.append("<br>");
				commentStr.append("<br>");
				commentStr.append("Dear Dr. <u>");
				commentStr.append(TextUtil.capitailizeWord(docfname));
				commentStr.append(", ");
				commentStr.append(TextUtil.capitailizeWord(docgname));
				commentStr.append("</u>");
				commentStr.append("<br>");
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a016." + ConstantsServerSide.SITE_CODE));
				commentStr.append("<br>");
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a002.both")+":");
				commentStr.append("<br>");
				commentStr.append("<br>");
				commentStr.append("<table border='1'><tr><td style='background-color:#AA0066;color:#FFFFFF'>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a003.both"));
				commentStr.append("</td></tr><tr><td><b>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a004a.both"));
				commentStr.append(ConstantsServerSide.OFFSITE_URL);
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a004b.both"));
				commentStr.append(ctsNo+"&docCode=" + docCode + "&siteCode=" + ConstantsServerSide.SITE_CODE);
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a005." + ConstantsServerSide.SITE_CODE));
				commentStr.append("</b><br><br>");
				commentStr.append("<b>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a006.both"));
				commentStr.append("</b><br>");
				commentStr.append("<br>Renew CTS NO.: " + ctsNo);
				commentStr.append("<br>Password: " + pwd);
				commentStr.append("<br><br><b>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a007.both"));
				commentStr.append(addMasterCodeTable(docCode));
				commentStr.append("</b><br><br></td></tr><tr><td style='background-color:#AA0066;color:#FFFFFF'>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a008.both"));
				commentStr.append("</td></tr><tr><td>");
				commentStr.append("<br><b>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a009." + ConstantsServerSide.SITE_CODE));
				commentStr.append("</b><br><b>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a010.both"));
				commentStr.append("</b><br></td></tr></table>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a012." + ConstantsServerSide.SITE_CODE));
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a013.both"));
				commentStr.append("<br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a014.both"));
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a015.both"));
				commentStr.append("<br><br>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content8." + ConstantsServerSide.SITE_CODE));
				commentStr.append("</font>");
			} else if ("U".equals(recStatus)) {
				commentStr.append("<font face=\"Arial\">");
				commentStr.append("<br>");
				commentStr.append("Dear Dr. <u>");
				commentStr.append(TextUtil.capitailizeWord(docfname));
				commentStr.append(", ");
				commentStr.append(TextUtil.capitailizeWord(docgname));
				commentStr.append("</u>");
				commentStr.append("<br>&nbsp;");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content9." + ConstantsServerSide.SITE_CODE)+docSpName);
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content6.both")+renewDate);
				commentStr.append("</u>.<br>&nbsp;");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content10." + ConstantsServerSide.SITE_CODE));
				commentStr.append("<br>&nbsp;");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content7.both"));
				commentStr.append("<br>&nbsp;");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content8.both"));
				commentStr.append("<br>&nbsp;");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content8." + ConstantsServerSide.SITE_CODE));
				commentStr.append("</font>");
			}

			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.hkahwebsite"));
		}

		return sendEmailHelper(emailFrom, emailTo, topic, commentStr.toString());
	}

	private static String addMasterCodeTable(String docCode) {
		StringBuffer doctorCodeTable = new StringBuffer();
		if (ConstantsServerSide.isTWAH()) {
			ArrayList docRecord = UtilDBWeb.getReportableList("SELECT DOCCODE, COMPANY, MSTRDOCCODE FROM DOCTOR@IWEB WHERE DOCSTS = -1 AND (DOCCODE = ? OR MSTRDOCCODE = ?) ORDER BY DOCCODE", new String[] {docCode, docCode});
			ReportableListObject row = null;
			doctorCodeTable.append("<br><br><table border='1'><tr><td>Doctor Code</td><td>Company</td></tr>");
			for (int i = 0; i < docRecord.size(); i++) {
				row = (ReportableListObject) docRecord.get(i);
				doctorCodeTable.append("<tr><td>");
				if (row.getValue(2).length() == 0) {
					doctorCodeTable.append("<font color='red'>*</font>");
				}
				doctorCodeTable.append(row.getValue(0));
				doctorCodeTable.append("&nbsp;</td><td>");
				doctorCodeTable.append(row.getValue(1));
				doctorCodeTable.append("&nbsp;</td></tr>");
			}
			doctorCodeTable.append("</table><br><font color='red'>*</font>indicate master code<br>");
		}
		return doctorCodeTable.toString();
	}

	public static boolean sendNewCTSEmail(String docCode, String callLoc, String fromStaffID, String ctsNo, String pwd, String recStatus) {
		String approvalStaffEmail = null;
		String emailFrom = null;
		String[] emailTo = null;
		String folderId = null;
		String docfname = null;
		String docgname = null;
		String[] docemail = null;
		String topic = null;
		String docSpCode = null;
		String docSpName = null;
		String renewDate = null;
		String docLicNo = null;
		String docPwd = null;
		StringBuffer commentStr = null;

		Calendar calendar = Calendar.getInstance();

		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		String sysDate = dateFormat.format(calendar.getTime());
		calendar.add(Calendar.MONTH, 1);
		String sysDateNextMonth = dateFormat.format(calendar.getTime());
//		String attachment[] = null;
		// get Deadline date
		String cont1 = getEmailContent("M0001", "C0001");
		String cont2 = getEmailContent("M0001", "C0002");

		if ("away".equals(callLoc)) {
			Calendar calendar1 = Calendar.getInstance();
			SimpleDateFormat dateFormat1 = new SimpleDateFormat("yyyyMMdd");
			String submitDate = dateFormat1.format(calendar1.getTime());

			if (ctsNo != null && "N".equals(ctsNo.substring(0, 1))) {
				ArrayList result = getHKMCLicNo(ctsNo);
				if (result.size() > 0) {
					ReportableListObject row = (ReportableListObject) result.get(0);
					docLicNo = row.getValue(0);
					docfname = row.getValue(1);
					docgname = row.getValue(2);
					docemail = getDoctorEmailList(row.getValue(3));
				}

				topic = "Doctor application submit from " +  docfname + "," + docgname +", CTS NO." + ctsNo;

				// append url
				commentStr = new StringBuffer();
				commentStr.append(" <br>HKMC Lic NO.: " + docLicNo);
				commentStr.append(" <br>Doctor First Name: " + docfname);
				commentStr.append(" <br>Doctor Given Name: " + docgname);

				if (docemail.length > 0) {
					emailFrom = docemail[0];
				}
			} else {
				// get doctor email
				ArrayList docRecord = getDocList1(docCode);
				if (docRecord.size() > 0) {
					ReportableListObject row = (ReportableListObject) docRecord.get(0);
					docfname = row.getValue(1);
					docgname = row.getValue(2);
					docemail = getDoctorEmailList(row.getValue(5));
				}

				// get doctor attach folder number
				folderId = getFolderId(ctsNo);

				// get approval list
				ArrayList record = ApprovalUserDB.getApprovalUserList("cts", "approve", ConstantsServerSide.SITE_CODE, null, null);
				if (record.size() > 0) {
					ReportableListObject row = (ReportableListObject) record.get(0);
					emailTo = getDoctorEmailList(row.getValue(2));
				}

				topic = "Doctor renewal information submit from " +  docfname + "," + docgname;

				// append url
				commentStr = new StringBuffer();
				commentStr.append(" <br>Doctor NO.: " + docCode);
				commentStr.append(" <br>Doctor First Name: " + docfname);
				commentStr.append(" <br>Doctor Given Name: " + docgname);
				if (ConstantsServerSide.isHKAH()) {
					commentStr.append(" <br>Please click <a href=\"\\\\hkim\\im\\VPMA\\Credential Renew Document\\");
				} else if (ConstantsServerSide.isTWAH()) {
					commentStr.append(" <br>Please click <a href=\"\\\\it-fs1\\dept\\VPMA\\Credential Renew Document\\");
				}
				commentStr.append(docCode+"-" + submitDate);
				commentStr.append("\">Intranet</a> to view the attachment.");

				if (docemail.length > 0) {
					emailFrom = docemail[0];
				}
			}
		} else if ("home".equals(callLoc)) {
			emailFrom = UserDB.getUserEmail(null, fromStaffID);

			// get doctor email
			ArrayList docRecord = getNewCTSDtl(ctsNo);
			if (docRecord.size() > 0) {
				ReportableListObject row = (ReportableListObject) docRecord.get(0);
				docfname = row.getValue(4);
				docgname = row.getValue(5);
				emailTo = new String[] {row.getValue(19)};
				docLicNo = row.getValue(58);
				docPwd = row.getValue(70);

				ArrayList record = getSpecialty(docSpCode);
				if (record.size() > 0) {
					ReportableListObject rowSpec = (ReportableListObject) record.get(0);
					docSpName =rowSpec.getValue(1);
				}
			}

			if (pwd == null) {
				pwd = docPwd;
			}

			if ("X".equals(recStatus)) {
				if (ConstantsServerSide.isHKAH()) {
					topic = "New of Admission privilege ";
				} else if (ConstantsServerSide.isTWAH()) {
					topic = "New Application of TWAH Admission privilege";
				}
			} else if ("Y".equals(recStatus)) {
				if (ConstantsServerSide.isHKAH()) {
					topic = "New of Admission privilege - 2nd reminder ";
				} else if (ConstantsServerSide.isTWAH()) {
					topic = "New Application of TWAH Admission privilege - reminder";
				}
			} else if ("Z".equals(recStatus)) {
				topic = "New of Admission privilege - 3rd reminder ";
			} else if ("U".equals(recStatus)) {
				topic = "Medical Staff Privilege Renewal";
				renewDate = pwd;
			}

			// append url
			commentStr = new StringBuffer();

			if ("X".equals(recStatus)) {
				commentStr.append("<font face=\"Arial\">");
				commentStr.append("<u>" + sysDate+"</u>");
				commentStr.append("<br>");
				commentStr.append("<br>");
				commentStr.append("Dear Dr. <u>");
				commentStr.append(TextUtil.capitailizeWord(docfname));
				commentStr.append(", ");
				commentStr.append(TextUtil.capitailizeWord(docgname));
				commentStr.append("</u>");
				commentStr.append("<br>");
				commentStr.append("</b><br>");
				commentStr.append("<br><br>");
				commentStr.append("</font>");
				commentStr.append("<br>");
				commentStr.append("<br>");
				commentStr.append("<table border='1'><tr><td style='background-color:#AA0066;color:#FFFFFF'>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a020.both"));
				commentStr.append("</td></tr><tr><td><b>");
				commentStr.append("<br>CTS NO.: " + ctsNo);
				commentStr.append("<br>Password: " + pwd);
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a004a.both"));
				commentStr.append(ConstantsServerSide.OFFSITE_URL);
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a004b.both"));
				commentStr.append(ctsNo + "&docCode=" + docCode + "&siteCode=" + ConstantsServerSide.SITE_CODE);
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a005." + ConstantsServerSide.SITE_CODE)+ctsNo+"&docCode=" + docCode+"&siteCode=" + ConstantsServerSide.SITE_CODE);
				commentStr.append("</b><br><br>");
			} else if ("Y".equals(recStatus) || "Z".equals(recStatus)) {
				commentStr.append("<font face=\"Arial\">");
				commentStr.append("<u>" + sysDate+"</u>");
				commentStr.append("<br>");
				commentStr.append("<br>");
				commentStr.append("Dear Dr. <u>");
				commentStr.append(TextUtil.capitailizeWord(docfname));
				commentStr.append(", ");
				commentStr.append(TextUtil.capitailizeWord(docgname));
				commentStr.append("</u>");
				commentStr.append("<br>");
				commentStr.append("<br>");
				commentStr.append("</b><br>");
				commentStr.append("<br>Renew CTS NO.: " + ctsNo);
				commentStr.append("<br>Password: " + pwd);
				commentStr.append("<br><br>");
				commentStr.append("</font>");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a004a.both"));
				commentStr.append(ConstantsServerSide.OFFSITE_URL);
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a004b.both"));
				commentStr.append(ctsNo + "&docCode=" + docCode + "&siteCode=" + ConstantsServerSide.SITE_CODE);
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a005." + ConstantsServerSide.SITE_CODE)+ctsNo+"&docCode=" + docCode+"&siteCode=" + ConstantsServerSide.SITE_CODE);
			} else if ("U".equals(recStatus)) {
				commentStr.append("<font face=\"Arial\">");
				commentStr.append("<br>");
				commentStr.append("Dear Dr. <u>");
				commentStr.append(TextUtil.capitailizeWord(docfname));
				commentStr.append(", ");
				commentStr.append(TextUtil.capitailizeWord(docgname));
				commentStr.append("</u>");
				commentStr.append("<br>&nbsp;");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content9." + ConstantsServerSide.SITE_CODE)+docSpName);
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content6.both")+renewDate);
				commentStr.append("</u>.<br>&nbsp;");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content10." + ConstantsServerSide.SITE_CODE));
				commentStr.append("<br>&nbsp;");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content7.both"));
				commentStr.append("<br>&nbsp;");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content8.both"));
				commentStr.append("<br>&nbsp;");
				commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content8." + ConstantsServerSide.SITE_CODE));
				commentStr.append("</font>");
			}

			commentStr.append("<br>");
			commentStr.append(MessageResources.getMessageEnglish("prompt.hkahwebsite"));
		}

		return sendEmailHelper(emailFrom, emailTo, topic, commentStr.toString());
	}

	public static boolean sendEmail4AcceptVerify(String docCode, String fromStaffID, String ctsNo, String renewDate1, String renewDate3, String recStatus) {
		String approvalStaffEmail = null;
		String emailFrom = null;
		String[] emailTo = null;
		String folderId = null;
		String docfname = null;
		String docgname = null;
		String docemail = null;
		String topic = null;
		String docSpCode = null;
		String docSpName = null;
		StringBuffer commentStr = null;

		Calendar calendar = Calendar.getInstance();

		SimpleDateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
		String sysDate = dateFormat.format(calendar.getTime());
		calendar.add(Calendar.MONTH, 1);
		String sysDateNextMonth = dateFormat.format(calendar.getTime());
//		String attachment[] = null;
		emailFrom = UserDB.getUserEmail(null, fromStaffID);

		// get doctor email
		ArrayList docRecord = getDocList1(docCode);
		if (docRecord.size() > 0) {
			ReportableListObject row = (ReportableListObject) docRecord.get(0);
			docfname = row.getValue(1);
			docgname = row.getValue(2);
			emailTo = getDoctorEmailList(row.getValue(5));
			docSpCode = row.getValue(10);

			ArrayList record = getSpecialty(docSpCode);
			if (record.size() > 0) {
				ReportableListObject rowSpec = (ReportableListObject) record.get(0);
				docSpName =rowSpec.getValue(1);
			}
		}

		topic = "Medical Staff Privilege Renewal";

		// append url
		commentStr = new StringBuffer();

		if (renewDate1 != null && renewDate1.length() > 0) {
			commentStr.append("<font face=\"Arial\">");
			commentStr.append("<u>" + sysDate+"</u>");
			commentStr.append("<br>");
			commentStr.append("Dear Dr. <u>");
			commentStr.append(TextUtil.capitailizeWord(docfname));
			commentStr.append(", ");
			commentStr.append(TextUtil.capitailizeWord(docgname));
			commentStr.append("</u>");
			commentStr.append("<br>&nbsp;");
			commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content11." + ConstantsServerSide.SITE_CODE)+docSpName);
			commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content9.both")+renewDate1);
			commentStr.append("</u>.<br>&nbsp;");
			commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content12." + ConstantsServerSide.SITE_CODE));
			commentStr.append("<br>&nbsp;");
			commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content8.both"));
			commentStr.append("<br>&nbsp;");
			commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content8." + ConstantsServerSide.SITE_CODE));
			commentStr.append("</font>");
		} else if (renewDate3 != null && renewDate3.length() > 0) {
			commentStr.append("<font face=\"Arial\">");
			commentStr.append("<u>" + sysDate+"</u>");
			commentStr.append("<br>");
			commentStr.append("Dear Dr. <u>");
			commentStr.append(TextUtil.capitailizeWord(docfname));
			commentStr.append(", ");
			commentStr.append(TextUtil.capitailizeWord(docgname));
			commentStr.append("</u>");
			commentStr.append("<br>&nbsp;");
			commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content11." + ConstantsServerSide.SITE_CODE)+docSpName);
			commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content10.both")+renewDate3);
			commentStr.append("</u>.<br>&nbsp;");
			commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content10." + ConstantsServerSide.SITE_CODE));
			commentStr.append("<br>&nbsp;");
			commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content7.both"));
			commentStr.append("<br>&nbsp;");
			commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content8.both"));
			commentStr.append("<br>&nbsp;");
			commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content8." + ConstantsServerSide.SITE_CODE));
			commentStr.append("</font>");
		} else {
			commentStr.append("<font face=\"Arial\">");
			commentStr.append("<u>" + sysDate+"</u>");
			commentStr.append("<br>");
			commentStr.append("Dear Dr. <u>");
			commentStr.append(TextUtil.capitailizeWord(docfname));
			commentStr.append(", ");
			commentStr.append(TextUtil.capitailizeWord(docgname));
			commentStr.append("</u>");
			commentStr.append("<br>&nbsp;");
			commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content11." + ConstantsServerSide.SITE_CODE)+docSpName);
			commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content10.both")+renewDate3);
			commentStr.append("</u>.<br>&nbsp;");
			commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content10." + ConstantsServerSide.SITE_CODE));
			commentStr.append("<br>&nbsp;");
			commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content7.both"));
			commentStr.append("<br>&nbsp;");
			commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content8.both"));
			commentStr.append("<br>&nbsp;");
			commentStr.append(MessageResources.getMessageEnglish("prompt.sendEmail.content8." + ConstantsServerSide.SITE_CODE));
			commentStr.append("</font>");
		}

		commentStr.append("<br>");
		commentStr.append(MessageResources.getMessageEnglish("prompt.hkahwebsite"));

		return sendEmailHelper(emailFrom, emailTo, topic, commentStr.toString());
	}

	public static boolean notifyDoctorSendMail(String docCode) {
		// get doctor email
/*
		ArrayList docRecord = getDocList1(docCode);
		if (docRecord.size() > 0) {
			ReportableListObject row = (ReportableListObject) docRecord.get(0);

			// append url
			StringBuffer commentStr = new StringBuffer();
			commentStr.append("Dear Dr. ");
			commentStr.append(row.getValue(1));
			commentStr.append(" ");
			commentStr.append(row.getValue(2));
			commentStr.append(",<br><br>Please click <a href=\"http://");
			commentStr.append(ConstantsServerSide.INTRANET_URL);
			commentStr.append("/intranet/cts/openDocApproval.jsp?command=view&docCode=");
			commentStr.append(docCode);
			commentStr.append("\">Intranet</a> or <a href=\"https://");
			commentStr.append(ConstantsServerSide.OFFSITE_URL);
			commentStr.append("/intranet/cts/openDocApproval.jsp?command=view&docCode=");
			commentStr.append(docCode);
			commentStr.append("\">Offsite</a> to view the Credential Track System - Doctor Approval.");

			return sendEmailHelper(null, row.getValue(5), "Credential Track System - Doctor Approval", commentStr.toString());
		} else {
			return false;
		}
*/
		return true;
	}

	public static void urgentSendMail() {
		StringBuffer message = new StringBuffer();
		StringBuffer sqlStr = new StringBuffer();
		boolean sendMailSuccess = false;

		String doccode = null;
		String docfname = null;
		String docgname = null;
		String MPSCDATE = null;
		String docemail = null;
		String SPECIALTY = null;
		String DOCTDATE = null;
		String getDocList_sqlStr = null;
		ArrayList<ReportableListObject> docList_ArrayList = null;
		ReportableListObject reportableListObject = null;
		Vector emailTo = new Vector();
		String[] emailListToArray = null;
		String[] mailToCcArray = new String[1];
		String vpmaEmail = getDefaultEmail();
		Calendar calendar = Calendar.getInstance();
		String currYear = Integer.toString(calendar.get(Calendar.YEAR));

		sqlStr.setLength(0);
		sqlStr.append("SELECT");
		sqlStr.append(" d.doccode, d.docfname, d.docgname, d.docemail, TO_CHAR(d.APLDATE,'DD/MM/YYYY'),(SELECT s.spcname FROM spec@iweb s WHERE s.spccode = d.spccode),TO_CHAR(D.DOCTDATE,'DD/MM/YYYY') ");
		sqlStr.append(" FROM DOCTOR@IWEB d");
		sqlStr.append(" WHERE d.APLDATE IS NOT NULL");
		// retrieve only 20191231
		sqlStr.append(" AND TRUNC(TO_DATE('20191231','YYYYMMDD'),'DD') = TRUNC(d.APLDATE,'DD' )");
		sqlStr.append(" AND D.DOCSTS = -1");
		sqlStr.append(" AND d.docemail IS NOT NULL");
		sqlStr.append(" AND d.doccode NOT IN ('N024','7724','7511','9395')");
//		sqlStr.append(" AND D.DOCCODE ='1002' ");
		sqlStr.append(" ORDER BY d.doccode ASC");
		getDocList_sqlStr = sqlStr.toString();

		// Get doctor information
		docList_ArrayList = UtilDBWeb.getReportableList(getDocList_sqlStr);

		for (int i = 0; i < docList_ArrayList.size(); i++) {
			emailTo = new Vector();
			reportableListObject = (ReportableListObject) docList_ArrayList.get(i);
			doccode = reportableListObject.getFields0();
			docfname = reportableListObject.getFields1();
			docgname = reportableListObject.getFields2();
			docemail = reportableListObject.getFields3();
			MPSCDATE = reportableListObject.getFields4();
			SPECIALTY = reportableListObject.getFields5();
			DOCTDATE = reportableListObject.getFields6();

			message.setLength(0);
			message.append("<font face=\"Arial\">");
			message.append("Dear Dr " + docfname.toUpperCase() + ", " + docgname.toUpperCase()+"<br>");
			message.append("<br>");
			message.append("Greetings from Hong Kong Adventist Hospital - Stubbs Road.<br>");
			message.append("<br>");
			message.append("Our records show that the valid period of your Annual Practising Certificate expired.  Please send a copy of the updated certificate to us.<br>");
			message.append("<br>");
			message.append("Document(s) can be submitted by either one of the following:<br>");
			message.append("By Fax: 	2574 6001<br>");
			message.append("By Email: 	" + vpmaEmail + "<br>");
			message.append("<br>");
			message.append("Please be reminded to send in your medical professional indemnity insurance certificate and Annual Practising Certificate yearly.  We appreciate your cooperation.<br>");
			message.append("<br>");
			message.append("Sincerely<br>");
			message.append("Medical Affairs Office<br>");
			message.append("Hong Kong Adventist Hospital - Stubbs Road<br>");
			message.append("<br>");
			message.append("Enquiry: 2835 0581<br>");
			message.append("</font>");

			message.append("<br>");
			message.append(MessageResources.getMessageEnglish("prompt.hkahwebsite"));

			if (docemail != null && docemail.length() > 0) {
				if (docemail.indexOf(";") > 0) {
					emailListToArray = UtilMail.splitEmailToArray(docemail);
					System.out.println("[emailListToArray]1");
				} else {
					emailTo.add(docemail);
					emailListToArray = (String[]) emailTo.toArray(new String[emailTo.size()]);
					System.out.println("[emailListToArray]2");
				}
				mailToCcArray[0] = vpmaEmail;
			} else {
				emailTo.add(vpmaEmail);
				emailListToArray = (String[]) emailTo.toArray(new String[emailTo.size()]);
				System.out.println("[emailListToArray]3");
			}

			// Send mail
			sendMailSuccess = UtilMail.sendMail(
					vpmaEmail,
					emailListToArray,
					mailToCcArray,
					null,
					"Updated APC " + currYear+" (Dr. " + docfname.toUpperCase() + ", " + docgname.toUpperCase() + " - " + doccode+")",
					message.toString());


			// reset values
			emailListToArray = null;
			emailTo = null;

			if (!sendMailSuccess) {
				System.out.println("[doccode]:" + doccode + ";[emailListToArray]:" + emailListToArray + ";[mailToCcArray]:" + mailToCcArray);
			}
		}
	}

	private static boolean sendEmailHelper(String emailFrom, String[] emailTo, String topic, String message) {
		if (emailFrom == null) {
			emailFrom = getDefaultEmail();
		}

		ArrayList alEmailList = getEmailList("M0002");
		String siteSubject = null;
		int numofrec = 0;
		if (ConstantsServerSide.isHKAH()) {
			siteSubject = " (From HKAH-SR)";
		} else if (ConstantsServerSide.isTWAH()) {
			siteSubject = " (From HKAH-TW)";
		}

		numofrec = alEmailList.size();
		String[] emailList = new String[numofrec];
		if (numofrec > 0) {
			ReportableListObject row = null;
			for (int z = 0; z < numofrec; z++) {
				row = (ReportableListObject) alEmailList.get(z);
				emailList[z] = row.getValue(0);
			}
		}

//		emailList = (String[]) alEmailList.toArray(new String[alEmailList.size()]);

		// send email
		return UtilMail.sendMail(
				getDefaultEmail(), emailTo, null, emailList, new String[] { getDefaultEmail() },
				topic + siteSubject,
				message, "Medical Affairs");
	}

	public static boolean generateCoverLetter(UserBean userBean, String ctsNo, String filename) {
		// generate pdf
		try {
			CoverLetterReapplication.toXMLfile(
					getDocList(ctsNo),
					ConstantsServerSide.UPLOAD_WEB_FOLDER + "/CTS/" + ctsNo + "/" + filename + ".fo");
			return true;
		} catch (Exception e) {}
		return false;
	}

	public static boolean generateInactLetter(UserBean userBean, String ctsNo, String filename) {
		// generate pdf
		try {
			InactiveNoticeLetter.toXMLfile(
					getDocList(ctsNo),
					ConstantsServerSide.UPLOAD_WEB_FOLDER + "/CTS/" + ctsNo + "/" + filename + ".fo");
			return true;
		} catch (Exception e) {}
		return false;
	}

	private static String[] getDoctorEmailList(String emailStr) {
		if (emailStr != null) {
			return TextUtil.split(emailStr, ";");
		} else {
			return null;
		}
	}

	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO DOCCODE_MAP (");
		sqlStr.append("DOCCODE, SUB_DOCCODE) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?)");
		sqlStr_insertDocMap = sqlStr.toString();

		StringBuffer sqlStr1 = new StringBuffer();
		sqlStr1.append("INSERT INTO CTS_QUESTION_DETAIL ");
		sqlStr1.append("SELECT ?, DOCCODE, 0, 1 FROM CTS_DOC_APPROVER WHERE ENABLED = 1 ");
		sqlStr_insertApprovalStatus = sqlStr1.toString();

//		sqlStr.setLength(0);
//		sqlStr.append("INSERT INTO CTS_RECORD_LOG (");
//		sqlStr.append("	CTS_NO, RECORD_STATUS, INSERT_BY, INSERT_DATE) ");
//		sqlStr.append("VALUES (");
//		sqlStr.append("?, ?, ?, sysdate)");
//		sqlStr_insertCtsLog = sqlStr.toString();

		StringBuffer sqlStr2 = new StringBuffer();
		sqlStr2.append("UPDATE CTS_RECORD ");
		sqlStr2.append("SET DOCCODE =?");
		sqlStr2.append(" WHERE CTS_NO =?");
		sqlStr_updateDocCodeCtsRecord = sqlStr2.toString();
	}
}