package com.hkah.web.db;

import java.util.ArrayList;

import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class DoctorDB {
	private static String sqlStr_insertDoctor = null;
	private static String sqlStr_updateDoctor = null;
	private static String sqlStr_deleteDoctor = null;

	private static String getNextDoctorID() {
		String doctorID = null;

		// get next schedule id from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(CO_DOCTOR_ID) + 1 FROM CO_DOCTORS");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			doctorID = reportableListObject.getValue(0);

			// set 1 for initial
			if (doctorID == null || doctorID.length() == 0) return "1";
		}
		return doctorID;
	}

	/**
	 * Add a client
	 */
	public static String add(UserBean userBean) {

		// get next client ID
		String doctorID = getNextDoctorID();

		// try to insert a new record
		if (UtilDBWeb.updateQueue(
				sqlStr_insertDoctor,
				new String[] {
						doctorID,
						userBean.getLoginID(), userBean.getLoginID() })) {
			return doctorID;
		} else {
			return null;
		}
	}

	/**
	 * Modify a client
	 * @return whether it is successful to update the record
	 */
	public static boolean update(UserBean userBean, String doctorID,
			String lastName, String firstName, String chineseName,
			String officePhone, String mobilePhone,
			String specialtyCode, String specialtyDesc, String document,
			String credential, String interest) {

		// try to update selected record
		return UtilDBWeb.updateQueue(
				sqlStr_updateDoctor,
				new String[] {
						lastName, firstName, chineseName,
						officePhone, mobilePhone,
						specialtyCode, specialtyDesc, document,
						credential, interest,
						userBean.getLoginID(), doctorID});
	}

	public static boolean delete(UserBean userBean,
			String doctorID) {
		// try to delete selected record
		return UtilDBWeb.updateQueue(
				sqlStr_deleteDoctor,
				new String[] { userBean.getLoginID(), doctorID } );
	}

	public static ArrayList get(String doctorID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_LASTNAME, CO_FIRSTNAME, CO_CHINESENAME, ");
		sqlStr.append("       CO_OFFICE_NUMBER, CO_MOBILE_NUMBER, ");
		sqlStr.append("       CO_SPECIALTY_CODE, CO_SPECIALTY_DESC, CO_DOCUMENTS, CO_CREDENTIAL, CO_INTEREST, ");
		sqlStr.append("       CO_CREATED_DATE, CO_CREATED_USER, ");
		sqlStr.append("       CO_MODIFIED_DATE, CO_MODIFIED_USER ");
		sqlStr.append("FROM   CO_DOCTORS ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		sqlStr.append("AND    CO_DOCTOR_ID = ?");

		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { doctorID });
	}

	public static ArrayList getList(String specialtyCode) {
		// fetch client
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_DOCTOR_ID, ");
		sqlStr.append("       CO_LASTNAME, CO_FIRSTNAME, CO_CHINESENAME, ");
		sqlStr.append("       CO_SPECIALTY_CODE, CO_SPECIALTY_DESC, ");
		sqlStr.append("       TO_CHAR(CO_CREATED_DATE, 'DD/MM/YYYY'), ");
		sqlStr.append("       TO_CHAR(CO_MODIFIED_DATE, 'DD/MM/YYYY') ");
		sqlStr.append("FROM   CO_DOCTORS ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		if (specialtyCode != null && specialtyCode.length() > 0) {
			sqlStr.append("AND   CO_SPECIALTY_CODE = '");
			sqlStr.append(specialtyCode);
			sqlStr.append("' ");
		}
		sqlStr.append("ORDER BY CO_MODIFIED_DATE, CO_CREATED_DATE, CO_DOCTOR_ID");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static ArrayList getHATSDoctor(String doctorID) {
		// fetch client
		StringBuffer sqlStr = new StringBuffer();
				
		sqlStr.append("SELECT D.DOCFNAME, D.DOCGNAME, ");
		sqlStr.append(" NVL2( F.FILE_ID, '\\\\' || F.STORE_SERVER || '\\' || F.STORE_FOLDER || '\\' || F.STORE_SUBFOLDER || '\\' || F.STORE_FILE, NULL) ");
		sqlStr.append(" FROM DOCTOR@IWEB D ");
		sqlStr.append(" LEFT OUTER JOIN DOCTOR_EXTRA@IWEB E ON D.DOCCODE = E.DOCCODE ");
		sqlStr.append(" LEFT OUTER JOIN FILE_STORE@CIS F ON E.CTS_ARCHIVE_FILE_ID = F.FILE_ID AND F.STATUS = 'A' ");
		sqlStr.append(" WHERE D.DOCCODE = ? ");
		
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { doctorID });
	}
	
	public static ArrayList getHATSDocInfo(String hatsCode) {
		return getHATSDocInfo(hatsCode, false);
	}
	
	public static ArrayList getHATSDocInfo(String hatsCode, boolean isGetMasterInfo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DOCCODE, DOCIDNO, to_char(DOCBDATE, 'dd/mm/yyyy'), MSTRDOCCODE, DOCFNAME, DOCGNAME FROM DOCTOR@IWEB ");
		if (isGetMasterInfo) {
			sqlStr.append("WHERE DOCCODE IN (SELECT MSTRDOCCODE FROM DOCTOR@IWEB where DOCCODE = '" + hatsCode + "') ");
			sqlStr.append("OR (DOCCODE = '" + hatsCode + "' AND MSTRDOCCODE IS NULL) ");
		} else {
			sqlStr.append("WHERE DOCCODE = '" + hatsCode + "'");
		}
		
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
	
	public static String getDoctorFullName(String docCode) {
		ArrayList docList = getHATSDocInfo(docCode, false);
		ReportableListObject row = null;
		String docName = null;
		String docFName = null;
		String docGName = null;
		for (int i = 0; i < docList.size(); i++) {
			row = (ReportableListObject) docList.get(0);
			docFName = row.getValue(4);
			docGName = row.getValue(5);
			
			docName = (docFName == null ? "" : docFName + ", ") + (docGName == null ? "" : docGName);
		}

		return docName;
	}

	// ---------------------------------------------------------------------
	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("INSERT INTO CO_DOCTORS ");
		sqlStr.append("(CO_DOCTOR_ID, ");
		sqlStr.append(" CO_CREATED_USER, CO_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ");
		sqlStr.append(" ?, ?)");
		sqlStr_insertDoctor = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_DOCTORS ");
		sqlStr.append("SET    CO_LASTNAME = ?, CO_FIRSTNAME = ?, CO_CHINESENAME = ?, ");
		sqlStr.append("       CO_OFFICE_NUMBER = ?, CO_MOBILE_NUMBER = ?, ");
		sqlStr.append("       CO_SPECIALTY_CODE = ?, CO_SPECIALTY_DESC = ?, CO_DOCUMENTS = ?, ");
		sqlStr.append("       CO_CREDENTIAL = ?, CO_INTEREST = ?, ");
		sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		sqlStr.append("AND    CO_DOCTOR_ID = ?");
		sqlStr_updateDoctor = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE CO_DOCTORS ");
		sqlStr.append("SET    CO_ENABLED = 0, CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = ? ");
		sqlStr.append("WHERE  CO_ENABLED = 1 ");
		sqlStr.append("AND    CO_DOCTOR_ID = ?");
		sqlStr_deleteDoctor = sqlStr.toString();

	}
}
