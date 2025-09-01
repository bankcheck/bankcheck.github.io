package com.hkah.web.db;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.ArrayUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.pdfbox.pdmodel.PDDocument;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.convert.Converter;
import com.hkah.util.PasswordUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;
import com.hkah.web.db.helper.DoctorDetail;
import com.hkah.web.db.helper.LabReportDetail;
//import com.hkah.web.db.helper.LocationDetail;
import org.json.simple.JSONObject;
import org.json.simple.JSONArray; 

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class CMSDB {
	private static String sqlStr_getCMSPhotoBasePath = null;
	private static String sqlStr_getLISPhotoBasePath = null;
	private static String sqlStr_getServletUrl = null;
	private static String sqlStr_getServletUrlWeb = null;
	private static String sqlStr_getQRPath = null;
	private static String sqlStr_getCMSLabImagePath = null;
	private static String sqlStr_getBreastQRPath = null;

	private static final String DEFAULT_PHOTO_HOST_HKAH = "\\\\160.100.2.79";
	private static final String DEFAULT_PHOTO_HOST_TWAH = "\\\\192.168.0.21";
	private static final String DEFAULT_PHOTO_BASEPATH_UAT = "\\cms\\uat\\mobilephoto\\";
	private static final String DEFAULT_PHOTO_BASEPATH_PROD = "\\cms\\production\\mobilephoto\\";

	public final static String MODULE_CODE_CMS_IP = "I";
	public final static String MODULE_CODE_CMS_OP = "O";
	public final static String MODULE_CODE_LIS = "L";

	public final static Map<String, String> sysparams = new HashMap<String, String>();
	
	static {
		loadSysParams();
	}
	
	public static void loadSysParams() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CODE_NO, CODE_VALUE1 FROM AH_SYS_CODE WHERE code_type = 'MOBILE' OR CODE_NO LIKE 'smb_%'");
		ArrayList<ReportableListObject> result = UtilDBWeb.getReportableListCIS(sqlStr.toString());
		
		ReportableListObject row = null;
		for (int i = 0; i < result.size(); i++) {
			row = (ReportableListObject) result.get(i);
			sysparams.put(row.getFields0(), row.getFields1());
		}
	}
	
	public static String getNextCMSMID() {
		String cmsmID = null;
		// get next schedule id from db
		ArrayList result = UtilDBWeb.getReportableList(
				"SELECT MAX(CMSM_ID) + 1 FROM CMS_PHOTO@CIS");
		ReportableListObject row = null;
		if (result.size() > 0) {
			row = (ReportableListObject) result.get(0);
			cmsmID = row.getValue(0);

			// set 1 for initial
			if (cmsmID == null || cmsmID.length() == 0) return "1";
		}
		return cmsmID;
	}

	public static boolean addCMSMPhotoRecord(String cmsmID, String imagePath, String comment,
			String stecode, String patNo, String regID, String testType, String userID, String mode) {
		String module = "";

		if (MODULE_CODE_LIS.equals(mode)) {
			module = "lis_consultation";
		} else if (MODULE_CODE_CMS_IP.equals(mode)) {
			module = "ipd_consultation";
		} else {
			module = "opd_consultation";
		}

		return UtilDBWeb.updateQueue(
				"INSERT INTO CMS_PHOTO@CIS (CMSM_ID, CMSM_IMG_PATH, CMSM_COMMENT, " +
				"							 CMSM_STECODE, CMSM_PATNO, CMSM_REGID, CMSM_TESTTYPE, CMSM_MODULE, CMSM_USER_ID) " +
				"VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?  )", new String[]{cmsmID, imagePath, comment, stecode, patNo, regID, testType, module, userID});
	}

	public static String getPhotoBasePath(String mode) {
		String value = null;
		ArrayList result = null;

		if (MODULE_CODE_LIS.equals(mode)) {
			result = UtilDBWeb.getReportableList(sqlStr_getLISPhotoBasePath);
		} else {
			result = UtilDBWeb.getReportableList(sqlStr_getCMSPhotoBasePath);
		}
		ReportableListObject row = null;
		if (result.size() > 0) {
			row = (ReportableListObject) result.get(0);
			value = row.getValue(0);
		} else {
			value = (ConstantsServerSide.isTWAH() ? DEFAULT_PHOTO_HOST_TWAH : DEFAULT_PHOTO_HOST_HKAH) +
					(ConstantsServerSide.DEBUG ? DEFAULT_PHOTO_BASEPATH_UAT : DEFAULT_PHOTO_BASEPATH_PROD);
		}
		return value;
	}

	public static String getQRPath() {
		String value = null;
		ArrayList result = null;

		result = UtilDBWeb.getReportableList(sqlStr_getQRPath);

		ReportableListObject row = null;
		if (result.size() > 0) {
			row = (ReportableListObject) result.get(0);
			value = row.getValue(0);
		} else {
			value = (ConstantsServerSide.isTWAH() ? DEFAULT_PHOTO_HOST_TWAH : DEFAULT_PHOTO_HOST_HKAH) +
					(ConstantsServerSide.DEBUG ? DEFAULT_PHOTO_BASEPATH_UAT : DEFAULT_PHOTO_BASEPATH_PROD);
		}
		return value;
	}
	
	public static String getBreastQRPath() {
		String value = null;
		ArrayList result = null;

		result = UtilDBWeb.getReportableList(sqlStr_getBreastQRPath);

		ReportableListObject row = null;
		if (result.size() > 0) {
			row = (ReportableListObject) result.get(0);
			value = row.getValue(0);
		} else {
			value = (ConstantsServerSide.isTWAH() ? DEFAULT_PHOTO_HOST_TWAH : DEFAULT_PHOTO_HOST_HKAH) +
					(ConstantsServerSide.DEBUG ? DEFAULT_PHOTO_BASEPATH_UAT : DEFAULT_PHOTO_BASEPATH_PROD);
		}
		return value;
	}	
	
	public static String getServletUrl() {
		return getServletUrl(null);
	}

	public static String getServletUrl(String ver) {
		String value = null;
		String sql = (ver != null && "web".equalsIgnoreCase(ver) ? sqlStr_getServletUrlWeb : sqlStr_getServletUrl);
		ArrayList result = UtilDBWeb.getReportableList(sql);

		ReportableListObject row = null;
		if (result.size() > 0) {
			row = (ReportableListObject) result.get(0);
			value = row.getValue(0);
		}
		return value;
	}

	public static String getCMSLabReportImagePath() {
		String value = null;
		ArrayList result = UtilDBWeb.getReportableList(sqlStr_getCMSLabImagePath);

		ReportableListObject row = null;
		if (result.size() > 0) {
			row = (ReportableListObject) result.get(0);
			value = row.getValue(0);
		}
		return value;
	}

	public static ArrayList getImageDetails(String patNo, String regId, String mode, String testType) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select ");
		sqlStr.append("  cmsm_id, ");
		sqlStr.append("  cmsm_user_id, ");
		sqlStr.append("  cmsm_img_path, ");
		sqlStr.append("  cmsm_comment, ");
		sqlStr.append("  to_char(cmsm_created_date, 'dd MON yyyy hh24:mi', 'NLS_DATE_LANGUAGE=AMERICAN'), ");
		sqlStr.append("  to_char(cmsm_modified_date, 'dd/mm/yyyy hh24:mi'), ");
		sqlStr.append("  Cmsm_Patno, ");
		sqlStr.append("  Cmsm_Regid, ");
		sqlStr.append("  Cmsm_TestType ");
		sqlStr.append("from cms_photo@cis ");
		sqlStr.append("where ");

		if (MODULE_CODE_LIS.equals(mode)) {
			sqlStr.append("	 cmsm_module = 'lis_consultation' and ");
		} else if (MODULE_CODE_CMS_IP.equals(mode)) {
			sqlStr.append("	 cmsm_module = 'ipd_consultation' and ");
		} else if (MODULE_CODE_CMS_OP.equals(mode)) {
			sqlStr.append("	 cmsm_module = 'opd_consultation' and ");
		}

		sqlStr.append("  cmsm_stecode = '" + ConstantsServerSide.SITE_CODE.toLowerCase() +"' ");
		sqlStr.append("  and cmsm_patno = '" + patNo + "' ");
		if (regId != null && regId.length() > 0) {
			sqlStr.append("  and cmsm_regid = '" + regId + "' ");
		}
		if (MODULE_CODE_LIS.equals(mode)) {
			sqlStr.append("  and cmsm_testType = '" + testType + "' ");
		}
		sqlStr.append("order by cmsm_created_date desc");
//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getImagePathForPrinting(Set<String> cmsID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select ");
		sqlStr.append("  cmsm_id, ");
		sqlStr.append("  cmsm_user_id, ");
		sqlStr.append("  cmsm_img_path, ");
		sqlStr.append("  cmsm_comment, ");
		sqlStr.append("  to_char(cmsm_created_date, 'dd MON yyyy hh24:mi', 'NLS_DATE_LANGUAGE=AMERICAN'), ");
		sqlStr.append("  to_char(cmsm_modified_date, 'dd/mm/yyyy hh24:mi'), ");
		sqlStr.append("  Cmsm_Patno, ");
		sqlStr.append("  Cmsm_Regid, ");
		sqlStr.append("  Cmsm_TestType ");
		sqlStr.append("from cms_photo@cis ");
		sqlStr.append("where ");
		sqlStr.append("  cmsm_stecode = '" + ConstantsServerSide.SITE_CODE.toLowerCase() +"' ");
		int i = 0;
		for (String s : cmsID) {
			if (i == 0) {
				sqlStr.append(" and ( cmsm_id = '" + s + "' ");
			} else {
				sqlStr.append(" OR cmsm_id = '" + s + "' ");
			}
			if (i == cmsID.size()-1) {
				sqlStr.append(" ) ");
			}
			i++;
		}
		sqlStr.append("order by cmsm_created_date desc");
System.out.println(sqlStr.toString());

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getPatientRegDates(String patNo, String mode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("Select R.REGID, to_char(REGDATE, 'dd/mm/yyyy') From Cms_Photo@cis P, HAT_REG@cis R ");
		sqlStr.append("Where Cmsm_Patno = '" + patNo + "' ");
		sqlStr.append("And   Cmsm_Stecode = '" + ConstantsServerSide.SITE_CODE.toLowerCase() +"' ");
		sqlStr.append("And   P.Cmsm_Regid = R.Regid ");
		sqlStr.append("Group By  R.Regid, R.Regdate ");
		sqlStr.append("Order By R.Regdate desc ");

		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static ArrayList getLabReport(String labNum, String testCat, String rptNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select 	LAB_NUM, TEST_CAT, RPT_NO, RPT_VERSION, SERVER, ");
		sqlStr.append("		    FOLDER, SUBFOLDER, FNAME, ENCRYPE, PASSKEY ");
		sqlStr.append("	from labo_curr_report@lis ");
		sqlStr.append("Where    LAB_NUM = '" + labNum + "' ");
		sqlStr.append("And	    TEST_CAT = '" + testCat + "' ");
		if (rptNo != null && rptNo.length() > 0) {
			sqlStr.append("And	    RPT_NO = '" + rptNo + "' ");
		}
		sqlStr.append("ORDER BY LAB_NUM, TEST_CAT, RPT_NO ");

		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}
	
	public static ArrayList getFileArchive(String fileIdList) {	
		return getFileArchive(fileIdList, "FILE_ID");			
	}
	
	public static ArrayList getFileArchive(String fileIdList, String order) {	

		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT FILE_ID, store_server, store_folder, store_subfolder, store_file, KEYWORD, ENCRYPE, PASSKEY ");
		sqlStr.append(" FROM FILE_STORE ");
		sqlStr.append(" WHERE FILE_ID in (" + fileIdList + ") " );
		sqlStr.append(" AND STATUS = 'A' ");
		
		if ( order != null && order.length() > 0 ) {
			sqlStr.append(" ORDER BY " + order);
		}
		
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableListCIS(sqlStr.toString() );			
	}

	public static String getDeptGrp(String testCat) {
		String deptGrp = "";
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DEPT_GRP, TEST_TYPE FROM LABM_TESTTYPE@LIS WHERE TEST_TYPE = '" + testCat + "'");
		ArrayList deptGrpList = UtilDBWeb.getReportableListCIS(sqlStr.toString());
		ReportableListObject row = null;
		for (int i = 0; i < deptGrpList.size(); i++) {
			row = (ReportableListObject) deptGrpList.get(0);
			if (row.getValue(0) != null && row.getValue(0).length() > 0) {
				deptGrp = row.getValue(0);
			}
		}
		return deptGrp;
	}

	public static ArrayList getReferralReport(String labNum) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT   FS_FILE_PATH, FS_FILE_INDEX_ID, FS_LAB_NUM, ");
		sqlStr.append("		    TO_CHAR(Fs_Import_Date, 'MON dd,yyyy', 'NLS_DATE_LANGUAGE=AMERICAN') ");
		sqlStr.append("FROM     FS_FILE_INDEX WHERE FS_LAB_NUM = '" + labNum + "' AND FS_ENABLED = '1' ");
		sqlStr.append("ORDER BY FS_FILE_INDEX_ID DESC ");
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}

	//Arran added new version
	public static ArrayList getReferralReport2(String labNum) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT   FS_FILE_PATH, FS_FILE_INDEX_ID, FS_LAB_NUM, ");
		sqlStr.append("		    TO_CHAR(Fs_Import_Date, 'MON dd,yyyy', 'NLS_DATE_LANGUAGE=AMERICAN') ");
		sqlStr.append("FROM     FS_FILE_INDEX WHERE FS_LAB_NUM = '" + labNum + "' AND FS_ENABLED = '1' ");
		sqlStr.append(" UNION ");
		sqlStr.append(" SELECT '\\' || server || '\' || folder || '\' || subfolder || '\' || fname, ");
		sqlStr.append(" file_id, lab_num, TO_CHAR(RPT_DATE, 'MON dd,yyyy', 'NLS_DATE_LANGUAGE=AMERICAN') ");
		sqlStr.append(" FROM labo_curr_report@lis ");
		sqlStr.append(" WHERE lab_num = '" + labNum + "' ");
		sqlStr.append(" AND test_cat = '4' ");
		sqlStr.append(" ORDER BY FS_FILE_INDEX_ID DESC ");
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}

	public static ArrayList getLabDetail(String labNum) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 	LAB_NUM, TEST_NUM, SHORT_DESC FROM LABO_DETAIL@LIS ");
		sqlStr.append("WHERE 	LAB_NUM = '" + labNum + "' AND TEST_TYPE = '3' ");
		sqlStr.append("ORDER BY SHORT_DESC ");
		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}

	public static String getPatientName(String labNum) {
		String patientName = "N/A";
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT PATIENT  FROM LABO_MASTHEAD@lis WHERE LAB_NUM = '" + labNum + "'");
		ArrayList patientList = UtilDBWeb.getReportableListCIS(sqlStr.toString());
		ReportableListObject row = null;
		for (int i = 0; i < patientList.size(); i++) {
			row = (ReportableListObject) patientList.get(0);
			if (row.getValue(0) != null && row.getValue(0).length() > 0) {
				patientName = row.getValue(0);
			}
		}
		return patientName;
	}

	public static String getPortalUserName(String docCode) {
		String docUserName = "";
		ArrayList docList = SsoUserDB.getSsoUserIdByModuleUser("doctor", docCode);
		ReportableListObject row = null;
		for (int i = 0; i < docList.size(); i++) {
			row = (ReportableListObject) docList.get(0);
			if (row.getValue(0) != null && row.getValue(0).length() > 0) {
				docUserName = row.getValue(0);
			}
		}

		return docUserName;
	}

	public static String getDocCode(UserBean userBean) {
		String docCode = "";
		// Lab DI report account is uppercase DR<doccode>
		ArrayList docList = SsoUserDB.getModuleUserIdBySsoUserId("doctor", userBean.getLoginID().toUpperCase());
		ReportableListObject row = null;
		for (int i = 0; i < docList.size(); i++) {
			row = (ReportableListObject) docList.get(0);
			if (row.getValue(0) != null && row.getValue(0).length() > 0) {
				docCode = row.getValue(0);
			}
		}
		return docCode;
	}

	public static String checkCISDoctorMapping(String docCode) {
		String docUserName = "";
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT USER_ID  FROM DOCTOR_MAPPING WHERE UPPER(DOCCODE) = UPPER('"+docCode+"')");
		//System.out.println(sqlStr.toString());
		ArrayList docList = UtilDBWeb.getReportableListCIS(sqlStr.toString());
		ReportableListObject row = null;
		for (int i = 0; i < docList.size(); i++) {
			row = (ReportableListObject) docList.get(0);
			if (row.getValue(0) != null && row.getValue(0).length() > 0) {
				docUserName = row.getValue(0);
			}
		}

		return docUserName;
	}

	public static String getDoctorName(String docCode) {
		String docName = "";
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DOCFNAME || ', ' || DOCGNAME FROM DOCTOR@IWEB WHERE UPPER(DOCCODE) = UPPER('"+docCode+"')");
		ArrayList docList = UtilDBWeb.getReportableList(sqlStr.toString());
		ReportableListObject row = null;
		for (int i = 0; i < docList.size(); i++) {
			row = (ReportableListObject) docList.get(0);
			if (row.getValue(0) != null && row.getValue(0).length() > 0) {
				docName = row.getValue(0);
			}
		}

		if ("".equals(docName)) {
			docName = docCode;
		}

		return docName;
	}

	public static String getCISDocCode(UserBean userBean) {
		String docUserName = "";
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DOCCODE  FROM DOCTOR_MAPPING WHERE UPPER(USER_ID) = UPPER('"+userBean.getStaffID()+"')");
		//System.out.println(sqlStr.toString());
		ArrayList docList = UtilDBWeb.getReportableListCIS(sqlStr.toString());
		ReportableListObject row = null;
		for (int i = 0; i < docList.size(); i++) {
			row = (ReportableListObject) docList.get(0);
			if (row.getValue(0) != null && row.getValue(0).length() > 0) {
				docUserName = row.getValue(0);
			}
		}

		return docUserName;
	}

	public static String getDoctorCodeWithUserName(String userName) {
		String docStaffID = "";
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_STAFF_ID  FROM CO_USERS WHERE UPPER(CO_USERNAME) = UPPER('"+userName+"')");

		ArrayList docList = UtilDBWeb.getReportableList(sqlStr.toString());
		ReportableListObject row = null;
		for (int i = 0; i < docList.size(); i++) {
			row = (ReportableListObject) docList.get(0);
			if (row.getValue(0) != null && row.getValue(0).length() > 0) {
				docStaffID = row.getValue(0);
				docStaffID = docStaffID.toUpperCase().startsWith("DR") ? docStaffID.substring(2) : docStaffID;
			}
		}

		return docStaffID;
	}

	public static boolean allowReadDoc(UserBean userBean, String labLogID) {
		StringBuffer sqlStr = new StringBuffer();
		String docCode = "";
		boolean allowReadDoc = false;
		docCode = getDocCode(userBean);
		sqlStr.append("SELECT CIS_DOCCODE FROM CIS_LAB_LOG@cis ");
		sqlStr.append("WHERE  CIS_LAB_ID = ? ");
		sqlStr.append("AND CIS_DOCCODE in ");
		sqlStr.append("( ");
		sqlStr.append("	select doccode from doctor@iweb ");
		sqlStr.append("	where ");
		sqlStr.append("		mstrdoccode in ");
		sqlStr.append("		(select mstrdoccode from doctor@iweb where mstrdoccode = ? or doccode = ?) ");
		sqlStr.append("		or doccode in ");
		sqlStr.append("		(select mstrdoccode from doctor@iweb where mstrdoccode = ? or doccode = ?) ");
		sqlStr.append("		or doccode in ");
		sqlStr.append("		(select doccode from doctor@iweb where mstrdoccode = ? or doccode = ?) ");
		sqlStr.append(") ");

		ArrayList docDocList = UtilDBWeb.getReportableList(sqlStr.toString(),
				new String[]{labLogID, docCode, docCode, docCode, docCode, docCode, docCode});
		for (int i = 0; i < docDocList.size(); i++) {
			allowReadDoc = true;
		}

		return allowReadDoc;
	}

	public static boolean drPortalAccExist(String hatsCode) {
		StringBuffer sqlStr = new StringBuffer();
		boolean accExist = false;
		sqlStr.append("SELECT CO_USERNAME FROM CO_USERS WHERE CO_USERNAME = 'DR" + hatsCode + "'");

		ArrayList docDocList = UtilDBWeb.getReportableList(sqlStr.toString());
		for (int i = 0; i < docDocList.size(); i++) {
			accExist = true;
		}

		return accExist;
	}

	public static ArrayList getLabLogDetail(String labLogID) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CIS_LAB_NUM, CIS_TEST_CAT, CIS_RPT_NO, CIS_FILE_PATH FROM CIS_LAB_LOG ");
		sqlStr.append("WHERE  CIS_LAB_ID = ? AND CO_ENABLED = '1' ");
		return UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[] {labLogID});
	}

	public static ArrayList getLabLogDetail(String labLogID, String docCode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CIS_LAB_NUM, CIS_TEST_CAT, CIS_RPT_NO, CIS_FILE_PATH FROM CIS_LAB_LOG@cis ");
		sqlStr.append("WHERE  CIS_LAB_ID = ? AND CO_ENABLED = '1' ");
		sqlStr.append("AND CIS_DOCCODE in ");
		sqlStr.append("( ");
		sqlStr.append("	select doccode from doctor@iweb ");
		sqlStr.append("	where ");
		sqlStr.append("		mstrdoccode in ");
		sqlStr.append("		(select mstrdoccode from doctor@iweb where mstrdoccode = ? or doccode = ?) ");
		sqlStr.append("		or doccode in ");
		sqlStr.append("		(select mstrdoccode from doctor@iweb where mstrdoccode = ? or doccode = ?) ");
		sqlStr.append("		or doccode in ");
		sqlStr.append("		(select doccode from doctor@iweb where mstrdoccode = ? or doccode = ?) ");
		sqlStr.append(") ");
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[] {labLogID, docCode, docCode, docCode, docCode, docCode, docCode});
	}

	public static String getDocLoginID(String labLogID) {
		return getDocLoginID(labLogID, null);
	}

	public static String getDocLoginID(String labLogID, String labDocCode) {
		StringBuffer sqlStr = new StringBuffer();
		String docCode = "";
		sqlStr.append("SELECT CIS_DOCCODE FROM CIS_LAB_LOG ");
		sqlStr.append("WHERE  CIS_LAB_ID = ? AND CO_ENABLED = '1' ");

		ArrayList docDocList = null;
		if (labDocCode != null && labDocCode.length() > 0) {
			sqlStr.append("AND CIS_DOCCODE = ? ");
			docDocList = UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[] {labLogID, labDocCode});
		} else {
			docDocList = UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[] {labLogID});
		}

		// get latest version of blocked report (same cis_lab_num, cis_logtype, cis_test_cat, cis_rpt_no)
		if (docDocList == null || docDocList.isEmpty()) {
			sqlStr.setLength(0);
			sqlStr.append("SELECT CIS_DOCCODE FROM CIS_LAB_LOG ");
			sqlStr.append("WHERE  cis_lab_id in ");
			sqlStr.append("( ");
			sqlStr.append("  select cis_lab_id ");
			sqlStr.append("  from  ");
			sqlStr.append("  ( ");
			sqlStr.append("    select cis_lab_id ");
			sqlStr.append("    from cis_lab_log ");
			sqlStr.append("    where (cis_lab_num, CIS_DOCCODE, cis_logtype, cis_test_cat, cis_rpt_no)  ");
			sqlStr.append("    in ( ");
			sqlStr.append("      select cis_lab_num, CIS_DOCCODE, cis_logtype, cis_test_cat, cis_rpt_no  ");
			sqlStr.append("      from cis_lab_log  ");
			sqlStr.append("      where  ");
			sqlStr.append("      cis_lab_id = ? ");
			sqlStr.append("      ) ");
			sqlStr.append("    and co_enabled = 1 ");
			sqlStr.append("    order by co_created_date desc ");
			sqlStr.append("  ) ");
			sqlStr.append("  where rownum = 1 ");
			sqlStr.append(") ");
			sqlStr.append("AND CO_ENABLED = '1' ");

			if (labDocCode != null && labDocCode.length() > 0) {
				sqlStr.append("AND CIS_DOCCODE = ? ");
				docDocList = UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[] {labLogID, labDocCode});
			} else {
				docDocList = UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[] {labLogID});
			}
		}

		ReportableListObject row = null;
		if (docDocList.size() > 0) {
			row = (ReportableListObject) docDocList.get(0);
			if (row.getValue(0) != null && row.getValue(0).length() > 0) {
				docCode = row.getValue(0);
			}
		}

		return getPortalUserName(docCode);
	}

	public static String getDocPasswordForTest(String DocNo) {
		StringBuffer sqlStr = new StringBuffer();
		String password = "";
		sqlStr.append("SELECT substr(docidno,1,4)||to_char(DOCBDATE,'MM')||to_char(DOCBDATE,'DD') psw FROM doctor@iweb d where d.doccode = '" + DocNo + "'" );

		ArrayList docDocList = UtilDBWeb.getReportableList(sqlStr.toString());
		ReportableListObject row = null;
		for (int i = 0; i < docDocList.size(); i++) {
			row = (ReportableListObject) docDocList.get(0);
			if (row.getValue(0) != null && row.getValue(0).length() > 0) {
				password = row.getValue(0);
			}
		}
		return password;
	}

	public static String getLatestUnblockLogID(String labLogID) {
		StringBuffer sqlStr = new StringBuffer();
		String unblockLogID = labLogID;
		sqlStr.append("SELECT CIS_LAB_ID FROM CIS_LAB_LOG ");
		sqlStr.append("WHERE  CIS_LAB_ID = ? AND CO_ENABLED = '1' ");

		ArrayList labIdList = UtilDBWeb.getReportableListCIS(sqlStr.toString(),
				new String[]{labLogID});

		// get latest version of unblock report (same cis_lab_num, cis_logtype, cis_test_cat, cis_rpt_no)
		if (labIdList == null || labIdList.isEmpty()) {
			sqlStr.setLength(0);
			sqlStr.append("  select cis_lab_id ");
			sqlStr.append("  from  ");
			sqlStr.append("  ( ");
			sqlStr.append("    select cis_lab_id ");
			sqlStr.append("    from cis_lab_log ");
			sqlStr.append("    where (cis_lab_num, CIS_DOCCODE, cis_logtype, cis_test_cat, cis_rpt_no)  ");
			sqlStr.append("    in ( ");
			sqlStr.append("      select cis_lab_num, CIS_DOCCODE, cis_logtype, cis_test_cat, cis_rpt_no  ");
			sqlStr.append("      from cis_lab_log  ");
			sqlStr.append("      where  ");
			sqlStr.append("      cis_lab_id = ? ");
			sqlStr.append("      ) ");
			sqlStr.append("    and co_enabled = 1 ");
			sqlStr.append("    order by co_created_date desc ");
			sqlStr.append("  ) ");
			sqlStr.append("  where rownum = 1 ");

			labIdList = UtilDBWeb.getReportableListCIS(sqlStr.toString(),
					new String[]{labLogID});

			ReportableListObject row = null;
			if (!labIdList.isEmpty()) {
				row = (ReportableListObject) labIdList.get(0);
				if (row.getValue(0) != null && row.getValue(0).length() > 0) {
					unblockLogID = row.getValue(0);
				}
			} else {
				unblockLogID = null;
			}
		}

		return unblockLogID;
	}

	public static ArrayList getLISDocInfo(String hatsCode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT LAST_NAME,FIRST_NAME,CODE,HATS_DOCCODE FROM LABM_DOCTOR@LIS WHERE HATS_DOCCODE = '" + hatsCode + "'");

		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}

	public static ArrayList getHATSDocInfo(String hatsCode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DOCCODE, DOCIDNO, to_char(DOCBDATE, 'dd/mm/yyyy'), MSTRDOCCODE FROM DOCTOR@IWEB WHERE DOCCODE = '" + hatsCode + "'");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	public static boolean checkRptSendMailStatus(String labNum, String testCat, String rptNo, String rptVersion ) {
		StringBuffer sqlStr = new StringBuffer();
		boolean needSendMail = false;

		sqlStr.append("SELECT DRMAIL_STATUS FROM LABO_CURR_REPORT@LIS ");
		sqlStr.append("where lab_num = '" + labNum + "' and test_cat = '" + testCat + "' and rpt_no = '" + rptNo + "' AND DRMAIL_STATUS = 'R' ");
		if (rptVersion != null && rptVersion.length() > 0) {
			sqlStr.append("and rpt_version = '" + rptVersion + "'");
		}

		ArrayList rptList = UtilDBWeb.getReportableListCIS(sqlStr.toString());
		ReportableListObject row = null;
		for (int i = 0; i < rptList.size(); i++) {
			row = (ReportableListObject) rptList.get(0);
			if (row.getValue(0) != null && row.getValue(0).length() > 0) {
				String emailStatus = row.getValue(0);
				if ("R".equals(emailStatus)) {
					needSendMail = true;
				}
			}
		}
		return needSendMail;
	}

	public static boolean updateReadDoc(UserBean userBean, String labLogID) {
		StringBuffer sqlStr = new StringBuffer();
		String staffID = userBean.getStaffID();
		String docCode = "";
		docCode = getDocCode(userBean);
		sqlStr.append("UPDATE CIS_LAB_LOG@cis SET CIS_READDOC_STATUS = '1', ");
		sqlStr.append("CO_MODIFIED_DATE=SYSDATE, CO_MODIFIED_USER='" + userBean.getLoginID() + "' ");
		sqlStr.append("WHERE CIS_LAB_ID = ? ");
		sqlStr.append("AND CIS_READDOC_STATUS = '0' ");
		sqlStr.append("AND CIS_DOCCODE in ");
		sqlStr.append("( ");
		sqlStr.append("	select doccode from doctor@iweb ");
		sqlStr.append("	where ");
		sqlStr.append("		mstrdoccode in ");
		sqlStr.append("		(select mstrdoccode from doctor@iweb where mstrdoccode = ? or doccode = ?) ");
		sqlStr.append("		or doccode in ");
		sqlStr.append("		(select mstrdoccode from doctor@iweb where mstrdoccode = ? or doccode = ?) ");
		sqlStr.append("		or doccode in ");
		sqlStr.append("		(select doccode from doctor@iweb where mstrdoccode = ? or doccode = ?) ");
		sqlStr.append(") ");

		//System.out.println("[CMSDB] updateReadDoc labLogID="+labLogID+",docCode="+docCode);

		return UtilDBWeb.updateQueue(sqlStr.toString(),
				new String[]{labLogID, docCode, docCode, docCode, docCode, docCode, docCode});
	}


	public static boolean updateEmailStatus(String labNum, String testCat, String rptNo, String rptVersion , String mStatus) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("update labo_report_log@lis set drmail_status='" + mStatus + "' ");
		sqlStr.append("where lab_num = '" + labNum + "' and test_cat = '" + testCat + "' and rpt_no = '" + rptNo + "' AND DRMAIL_STATUS = 'R' ");
		if (rptVersion != null && rptVersion.length() > 0) {
			sqlStr.append("and rpt_version = '" + rptVersion + "'");
		}

		//System.out.println(sqlStr.toString());
		return UtilDBWeb.updateQueueCIS(sqlStr.toString());
	}

	public static boolean checkReportAvailable(String labNum, String testCat, String rptNo) {
		StringBuffer sqlStr = new StringBuffer();
		boolean reportAvailable = false;

		sqlStr.append("SELECT DRMAIL_STATUS FROM LABO_CURR_REPORT@LIS ");
		sqlStr.append("where lab_num = '" + labNum + "' and test_cat = '" + testCat + "' and rpt_no = '" + rptNo + "' AND DRMAIL_STATUS = 'S' ");

		ArrayList rptList = UtilDBWeb.getReportableListCIS(sqlStr.toString());
		for (int i = 0; i < rptList.size(); i++) {
			reportAvailable = true;
		}
		return reportAvailable;
	}

	public static String getDocEmail(String docCode) {
		String docEmail = "";
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DOCCODE, DOCEMAIL FROM DOCTOR@IWEB WHERE DOCCODE = '" + docCode + "'");
		ArrayList docEmailList = UtilDBWeb.getReportableList(sqlStr.toString());
		ReportableListObject row = null;
		for (int i = 0; i < docEmailList.size(); i++) {
			row = (ReportableListObject) docEmailList.get(0);
			if (row.getValue(1) != null && row.getValue(1).length() > 0) {
				docEmail = row.getValue(1);
			}
		}
		return docEmail;
	}

	public static ArrayList getLabReportToSend() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT LAB_NUM, TEST_CAT, RPT_NO, RPT_VERSION, ");
		sqlStr.append("	 	  SERVER, FOLDER, SUBFOLDER, FNAME, DRMAIL_STATUS, ");
		sqlStr.append("	 	  FILE_STATUS, FILE_MESSAGE, ");
		sqlStr.append("		  DOCCODE, DOCCODE1, DOCCODE2, DOCCODE3, DOCCODE4, ");
		sqlStr.append("		  EMAIL, EMAIL1, EMAIL2, EMAIL3, EMAIL4, CRITICAL ");/*, ");
		sqlStr.append("		  LOC_CODE, LOCATION, LOC_EMAIL ");*/
		sqlStr.append("FROM   LABO_CURR_REPORT@LIS ");
		sqlStr.append("WHERE  DRMAIL_STATUS = 'R' ");
		sqlStr.append("AND    FILE_STATUS = 'A'  ");
		sqlStr.append("ORDER  BY LAB_NUM, TEST_CAT, RPT_NO, RPT_VERSION ");

		//System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}

	public static String checkPatientType(String regID) {
		String patType = "O";
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT INPID FROM REG@IWEB WHERE REGID = '" + regID + "'");
		ArrayList patTypeList = UtilDBWeb.getReportableList(sqlStr.toString());
		ReportableListObject row = null;
		for (int i = 0; i < patTypeList.size(); i++) {
			row = (ReportableListObject) patTypeList.get(0);
			if (row.getValue(0) != null && row.getValue(0).length() > 0) {
				patType = "I";
			} else {
				patType = "O";
			}
		}
		return patType;
	}

	public static boolean insertCMSLabLog(String logID, String labNum, String docCode, String logType,
										   String testCat, String rptNo, String rptVersion,
										   String fullPath, String docEmail, String sendMailStatus,
										   String readDocStatus) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("INSERT INTO CIS_LAB_LOG ");
		sqlStr.append("(CIS_LAB_ID, CIS_LAB_NUM, CIS_DOCCODE, CIS_LOGTYPE, CIS_TEST_CAT, ");
		sqlStr.append("CIS_RPT_NO, CIS_RPT_VERSION, CIS_FILE_PATH, CIS_DOC_EMAIL, CIS_SENDMAIL_STATUS, ");
		sqlStr.append("CIS_READDOC_STATUS) ");
		sqlStr.append("VALUES ('" + logID + "', '" + labNum + "' ");
		if (docCode != null && docCode.length() > 0) {
			sqlStr.append(", '" + docCode + "' ");
		} else {
			sqlStr.append(", NULL ");
		}
		if (logType != null && logType.length() > 0) {
			sqlStr.append(", '" + logType + "' ");
		} else {
			sqlStr.append(", NULL ");
		}
		if (testCat != null && testCat.length() > 0) {
			sqlStr.append(", '" + testCat + "' ");
		} else {
			sqlStr.append(", NULL ");
		}
		if (rptNo != null && rptNo.length() > 0) {
			sqlStr.append(", '" + rptNo + "' ");
		} else {
			sqlStr.append(", NULL ");
		}
		if (rptVersion != null && rptVersion.length() > 0) {
			sqlStr.append(", '" + rptVersion + "' ");
		} else {
			sqlStr.append(", NULL ");
		}
		if (fullPath != null && fullPath.length() > 0) {
			sqlStr.append(", '" + fullPath + "' ");
		} else {
			sqlStr.append(", NULL ");
		}
		if (docEmail != null && docEmail.length() > 0) {
			sqlStr.append(", '" + docEmail + "' ");
		} else {
			sqlStr.append(", NULL ");
		}
		if (sendMailStatus != null && sendMailStatus.length() > 0) {
			sqlStr.append(", '" + sendMailStatus + "' ");
		} else {
			sqlStr.append(", NULL ");
		}
		if (readDocStatus != null && readDocStatus.length() > 0) {
			sqlStr.append(", '" + readDocStatus + "' ");
		} else {
			sqlStr.append(", NULL ");
		}
		sqlStr.append(") ");

		//System.out.println(sqlStr.toString());
		return UtilDBWeb.updateQueueCIS(sqlStr.toString());
	}
	
	public static boolean updateCMSLabLogSendMailStatus(List<Integer> logIDs, String sendMailStatus) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("UPDATE CIS_LAB_LOG SET CIS_SENDMAIL_STATUS = ? ");
		sqlStr.append("WHERE CIS_LAB_ID in (" + StringUtils.join(logIDs, ",")+ ")");

		System.out.println("[CMSDB] updateCMSLabLogSendMailStatus sendMailStatus="+sendMailStatus+", sql="+sqlStr.toString());
		return UtilDBWeb.updateQueueCIS(sqlStr.toString(), new String[]{sendMailStatus});
	}
	
	public static List<String> verifyLabKeyDoccode(List<Integer> logIDs) {
		StringBuffer sqlStr = new StringBuffer();
		List<String> unmatchLogID = new ArrayList<String>();
		sqlStr.append("SELECT labl.cis_lab_id ");
		sqlStr.append("from labo_curr_report@lis labr ");
		sqlStr.append("join cis_lab_log labl on labr.lab_num = labl.cis_lab_num ");
		sqlStr.append("and labr.test_cat = labl.cis_test_cat ");
		sqlStr.append("and labr.rpt_no = labl.cis_rpt_no ");
		sqlStr.append("and labr.rpt_version = labl.cis_rpt_version ");
		sqlStr.append("where labl.CIS_LAB_ID in (" + StringUtils.join(logIDs, ",")+ ") and ");
		sqlStr.append("  ( ");
		sqlStr.append("		  (labr.doccode is null or (labr.doccode is not null and labr.doccode <> labl.cis_doccode)) ");
		sqlStr.append("		  and (labr.doccode1 is null or (labr.doccode1 is not null and labr.doccode1 <> labl.cis_doccode)) ");
		sqlStr.append("		  and (labr.doccode2 is null or (labr.doccode2 is not null and labr.doccode2 <> labl.cis_doccode)) ");
		sqlStr.append("		  and (labr.doccode3 is null or (labr.doccode3 is not null and labr.doccode3 <> labl.cis_doccode)) ");
		sqlStr.append("		  and (labr.doccode4 is null or (labr.doccode4 is not null and labr.doccode4 <> labl.cis_doccode)) ");
		sqlStr.append("  ) ");
		  
		ArrayList docDocList = UtilDBWeb.getReportableListCIS(sqlStr.toString());
		for (int i = 0; i < docDocList.size(); i++) {
			ReportableListObject row = (ReportableListObject) docDocList.get(i);
			unmatchLogID.add(row.getFields0());
		}

		return unmatchLogID;
	}

	public static boolean insertSSOUserMaping(String hatsCode, String portalLoginID) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("INSERT INTO SSO_USER_MAPPING@SSO ");
		sqlStr.append("(MODULE_CODE,MODULE_USER_ID,SSO_USER_ID) ");
		sqlStr.append("VALUES ");
		sqlStr.append("('doctor','" + hatsCode + "','" + portalLoginID + "') ");

		return UtilDBWeb.updateQueue(sqlStr.toString());
	}

	public static boolean insertSSOUser(String hatsCode, String portalLoginID, String lastName, String givenName) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("INSERT INTO SSO_USER@SSO ");
		sqlStr.append("(SSO_USER_ID,STAFF_NO,LAST_NAME,GIVEN_NAME,DISPLAY_NAME) ");
		sqlStr.append("VALUES ");
		sqlStr.append("('" + portalLoginID +"','" + portalLoginID + "','" + lastName + "','" + givenName + "','" + lastName + " " + givenName + "') ");

		return UtilDBWeb.updateQueue(sqlStr.toString());
	}

	public static boolean insertPortalAccount(String hatsCode, String portalLoginID, String lastName, String givenName, String accountPassword) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("INSERT INTO CO_USERS ");
		sqlStr.append("(CO_STAFF_ID, CO_USERNAME, CO_LASTNAME, CO_FIRSTNAME , CO_SITE_CODE, CO_STAFF_YN, CO_GROUP_ID, CO_PASSWORD) ");
		sqlStr.append("VALUES ");
		sqlStr.append("('" + portalLoginID + "', '" + portalLoginID + "', '" + lastName + "', '" + givenName + "' , '" + ConstantsServerSide.SITE_CODE + "' ");
		sqlStr.append(", 'Y' , 'doctor' , '" + PasswordUtil.cisEncryption(accountPassword) + "') ");

		System.out.println(sqlStr.toString());
		return UtilDBWeb.updateQueue(sqlStr.toString());
	}

	public static int getNextLabLogID() {
		String ssID = null;

//		ArrayList result = UtilDBWeb.getReportableListCIS("SELECT SEQ_CIS_LAB_LOG_ID.NEXTVAL FROM DUAL ");
		ArrayList result = UtilDBWeb.getReportableListCIS("SELECT MAX(CIS_LAB_ID) FROM CIS_LAB_LOG ");
		ReportableListObject row = null;
		if (result.size() > 0) {
			row = (ReportableListObject) result.get(0);
			ssID = row.getValue(0);

			// set 1 for initial
			if (ssID == null || ssID.length() == 0) return 0;
		}
		return Integer.parseInt(ssID);
	}

	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select code_value1 from ah_sys_code@cis where sys_id = 'CMS' and code_type = 'MOBILE' and code_no = 'PHOTO_PATH'");
		sqlStr_getCMSPhotoBasePath = sqlStr.toString();
		sqlStr.setLength(0);
		sqlStr.append("select code_value1 from ah_sys_code@cis where sys_id = 'LIS' and code_type = 'MOBILE' and code_no = 'PHOTO_PATH'");
		sqlStr_getLISPhotoBasePath = sqlStr.toString();
		sqlStr.setLength(0);
		sqlStr.append("select code_value1 from ah_sys_code@cis where sys_id = 'CMS' and code_type = 'MOBILE' and code_no = 'QR_PATH'");
		sqlStr_getQRPath = sqlStr.toString();
		sqlStr.setLength(0);
		sqlStr.append("select code_value1 from ah_sys_code@cis where sys_id = 'CMS' and code_type = 'MOBILE' and code_no = 'SERVLET_URL'");
		sqlStr_getServletUrl = sqlStr.toString();
		sqlStr.setLength(0);
		sqlStr.append("select code_value1 from ah_sys_code@cis where sys_id = 'CMS' and code_type = 'MOBILE' and code_no = 'SERVLET_URL_WEB'");
		sqlStr_getServletUrlWeb = sqlStr.toString();
		sqlStr.setLength(0);
		sqlStr.append("select code_value1 from ah_sys_code@cis where sys_id = 'CMS' and code_type = 'LABREPORT' and code_no = 'IMAGE_PATH'");
		sqlStr_getCMSLabImagePath = sqlStr.toString();
		sqlStr.setLength(0);		
		sqlStr.append("select code_value1 from ah_sys_code@cis where sys_id = 'CMS' and code_type = 'MOBILE' and code_no = 'BREAST_QR_PATH'");
		sqlStr_getBreastQRPath = sqlStr.toString();		
	}

	public static String createDir(String dir) {
		File createDir = new File(dir);
		if (!createDir.exists()) {
//System.out.println("creating directory: " + dir);
		    boolean result = false;
		    try{
			createDir.mkdirs();
			result = true;
		    }
		    catch(SecurityException se) {
		    }
		    if (result) {
//System.out.println("DIR created");
		    }
		}
		return createDir.getAbsolutePath();
	}

	public static void sendLabEmails() {
		System.out.println("[CMSDB] SEND LAB EMAILS");
		
		String senderMail = ConstantsServerSide.MAIL_ALERT;
		if (ConstantsServerSide.isTWAH()) {
			senderMail = "hkah-tw.lab@twah.org.hk";
		} else {
			senderMail = "hkah-sr.lab@hkah.org.hk";
		}

		ArrayList labList = CMSDB.getLabReportToSend();
		ArrayList<DoctorDetail> doctorDetailList = new ArrayList<DoctorDetail>();

		int labLogID = CMSDB.getNextLabLogID();
		ReportableListObject row = null;
		String tLabNum = null;
		String tTestCat = null;
		String tRptNo = null;
		String tRptVersion = null;
		String tServer = null;
		String tFolder = null;
		String tSubFolder = null;
		String tFName = null;
		String tDocCode = null;
		String tDocCode1 = null;
		String tDocCode2 = null;
		String tDocCode3 = null;
		String tDocCode4 = null;
		String tDocEmail = null;
		String tDocEmail1 = null;
		String tDocEmail2 = null;
		String tDocEmail3 = null;
		String tDocEmail4 = null;
		String tCritical = null;
		HashMap<String, String> listOfDocInfo = null;
		boolean isConvert = false;
		StringBuffer tFilePath = new StringBuffer();
		String storeImagePath = null;
		String destinationDir = null;
		Map.Entry pair = null;
		String docCode = null;
		String allDocEmail = null;
		boolean foundDocCode = false;
		DoctorDetail tDoc = null;
		for (int i = 0; i < labList.size(); i++) {
			row = (ReportableListObject) labList.get(i);
			tLabNum = row.getValue(0);
			tTestCat = row.getValue(1);
			tRptNo = row.getValue(2);
			tRptVersion = row.getValue(3);
			tServer = row.getValue(4);
			tFolder = row.getValue(5);
			tSubFolder = row.getValue(6);
			tFName = row.getValue(7);
			tDocCode = row.getValue(11);
			tDocCode1 = row.getValue(12);
			tDocCode2 = row.getValue(13);
			tDocCode3 = row.getValue(14);
			tDocCode4 = row.getValue(15);
			tDocEmail = row.getValue(16);
			tDocEmail1 = row.getValue(17);
			tDocEmail2 = row.getValue(18);
			tDocEmail3 = row.getValue(19);
			tDocEmail4 = row.getValue(20);
			tCritical = row.getValue(21);

			if (CMSDB.checkRptSendMailStatus(tLabNum, tTestCat, tRptNo, tRptVersion)) {
				if (tServer != null && tServer.length() > 0) {
					CMSDB.updateEmailStatus(tLabNum, tTestCat, tRptNo, tRptVersion, "S");

					listOfDocInfo = new HashMap<String, String>();

					isConvert = false;
					if (tDocCode != null && tDocCode.length() > 0) {
						listOfDocInfo.put(tDocCode, tDocEmail);
						if (tDocEmail != null && tDocEmail.length() > 0) {
							isConvert = true;
						}
					}
					if (tDocCode1 != null && tDocCode1.length() > 0) {
						listOfDocInfo.put(tDocCode1, tDocEmail1);
						if (tDocEmail1 != null && tDocEmail1.length() > 0) {
							isConvert = true;
						}
					}
					if (tDocCode2 != null && tDocCode2.length() > 0) {
						listOfDocInfo.put(tDocCode2, tDocEmail2);
						if (tDocEmail2 != null && tDocEmail2.length() > 0) {
							isConvert = true;
						}
					}
					if (tDocCode3 != null && tDocCode3.length() > 0) {
						listOfDocInfo.put(tDocCode3, tDocEmail3);
						if (tDocEmail3 != null && tDocEmail3.length() > 0) {
							isConvert = true;
						}
					}
					if (tDocCode4 != null && tDocCode4.length() > 0) {
						listOfDocInfo.put(tDocCode4, tDocEmail4);
						if (tDocEmail4 != null && tDocEmail4.length() > 0) {
							isConvert = true;
						}
					}
					tFilePath.setLength(0);

					//Convert Pdf To Images
					tFilePath.append("\\\\");
					tFilePath.append(tServer);
					tFilePath.append("\\");
					tFilePath.append(tFolder);
					tFilePath.append("\\");
					tFilePath.append(tSubFolder);
					tFilePath.append("\\");
					tFilePath.append(tFName);
					//System.out.println(isConvert + " | " + tFilePath);
					try {
						if (isConvert) {
/*
							PDDocument doc = PDDocument.load(new File(tFilePath));

							// Define the length of the encryption key.
							// Possible values are 40 or 128 (256 will be available in PDFBox 2.0).
							int keyLength = 128;

							AccessPermission ap = new AccessPermission();

							// Disable printing, everything else is allowed
							ap.setCanPrint(false);

							// Owner password (to open the file with all permissions) is "12345"
							// User password (to open the file but with restricted permissions, is empty here)
							StandardProtectionPolicy spp = new StandardProtectionPolicy("12345", "12345", ap);
							spp.setEncryptionKeyLength(keyLength);
							spp.setPermissions(ap);
							doc.protect(spp);

							String storeImagePath = CMSDB.getCMSLabReportImagePath();
							String destinationDir = CMSDB.createDir(storeImagePath+"\\"+tLabNum+"\\"+tTestCat+"\\"+tRptNo);
							FileUtils.cleanDirectory(new File(storeImagePath+"\\"+tLabNum+"\\"+tTestCat+"\\"+tRptNo));
							doc.save(destinationDir + "\\"+tFName);
							doc.close();
*/
							
							System.out.println("[CMSDB] convertPdfToImag tFilePath=" + tFilePath);

							storeImagePath = CMSDB.getCMSLabReportImagePath();
							destinationDir = CMSDB.createDir(storeImagePath+"\\"+tLabNum+"\\"+tTestCat+"\\"+tRptNo);
							FileUtils.cleanDirectory(new File(storeImagePath+"\\"+tLabNum+"\\"+tTestCat+"\\"+tRptNo));
							Converter.convertPdfToImage(tFilePath.toString(), destinationDir + "\\", 150);
						}

						for (Iterator it = listOfDocInfo.entrySet().iterator(); it.hasNext(); ) {
							pair = (Map.Entry) it.next();
							docCode = (String) pair.getKey();
							allDocEmail = (String) pair.getValue();

							foundDocCode = false;
							for (DoctorDetail d : doctorDetailList) {
								if (d.docCode.equals(docCode)) {
									foundDocCode = true;
									labLogID++;
									d.labDetailList.add(new LabReportDetail(labLogID, tLabNum, tTestCat, tRptNo, tRptVersion, tFilePath.toString(), tCritical));
									break;
								}
							}
							if (!foundDocCode) {
								tDoc = new DoctorDetail(docCode, allDocEmail);
								labLogID++;
								tDoc.labDetailList.add(new LabReportDetail(labLogID, tLabNum, tTestCat, tRptNo, tRptVersion, tFilePath.toString(), tCritical));
								doctorDetailList.add(tDoc);
							}
						}
					} catch (Exception e) {
						System.out.println(e);
					}
				} else {
					CMSDB.updateEmailStatus(tLabNum, tTestCat, tRptNo, tRptVersion, "E");
				}
			}
		}

		for (DoctorDetail d : doctorDetailList) {
			StringBuffer content = new StringBuffer();
			content.append("<div style='font-size:13px'>");
			content.append("Dear Dr " + CMSDB.getDoctorName(d.docCode) + "</br></br>");
			content.append("Please kindly find the hyperlink below for the Laboratory/Histopathology report(s) which are ready for you.</br></br>");
			content.append("<u><b><font color='red'>Effective immediately, you can now VIEW or PRINT copies of reports on your own accord.</font></b></u></br></br>");

			content.append("<table border='1'>");
			content.append("<tr bgcolor='#DCDCDC'>");
			content.append("<td>PATIENT NAME</td><td>LAB #</td><td>HYPERLINK</td>");
			content.append("</tr>");
			for (LabReportDetail l : d.labDetailList) {
				content.append(generateEmailContent(l.labNum, l.testCat, l.rptNo, d.docCode, Integer.toString(l.labLogID), l.critical));
			}
			content.append("</table></br>");
			content.append("<div style='font-size:15px;color:red;font-weight:bold;'>The password is first 4 characters of the requesting doctor's HKID + Birth Date's month + Birth Date's day</br>");
			content.append("Eg. Doctor's HKID A123456(7), Doctor's Birth Date = Jan 31,1980</br>");
			content.append("Password = A1230131</br></br></div>");
			content.append("<div style='font-size:14px;font-weight:bold;'>For any critical results, the link will be in <font color='red'>BOLD RED</font>. For any enquiry, call us @ 2835-0534 (HK), 2275-6166 (TW) or reply to this email for any questions or concerns.</div></br></br>");
			// Just for testing , must be commented after production launched
			//content.append("Doctor Account Password ( Just for Testing period Only ) : " + getDocPasswordForTest(d.docCode) + "</br></br>");
			content.append("The information contained in this transmission contain privileged and confidential information. It is intended only for the use of the person(s) named above. If you are not intended recipient, you are hereby notified that any review, dissemination, distribution, or duplication of this communication is strictly prohibited. Please contact the sender and destroy all copies of the original message.</div>");

			String[] emailArray = d.email.split(";");
			emailArray = (String[]) ArrayUtils.removeElement(emailArray, "");

			if (d.email != null && d.email.length() > 0) {
				boolean isAccountCreated = createDrPortalAccount(d.docCode);
				boolean emailSuccess = false;
				boolean okToSendEmail = true;
				if (isAccountCreated) {
					List<Integer> labLogIDs = new ArrayList<Integer>();
					for (LabReportDetail l : d.labDetailList) {
						labLogIDs.add(l.labLogID);
						
						if (!CMSDB.insertCMSLabLog(Integer.toString(l.labLogID), l.labNum, d.docCode, "MAIL", l.testCat, l.rptNo, l.rptVersion, l.filePath, d.email, "To Be Send", "0")) {
							okToSendEmail = false;
						}
						CMSDB.updateEmailStatus(l.labNum, l.testCat, l.rptNo, l.rptVersion, "S");
					}
					if (okToSendEmail) {
						List<String> unmatchList = verifyLabKeyDoccode(labLogIDs);
						if (unmatchList.isEmpty()) {
							emailSuccess = UtilMail.sendMail(senderMail, emailArray, null,
								new String[] { "ricky.leung@hkah.org.hk", "cherry.wong@hkah.org.hk" }
								, "Completed Lab/ Pathology Results Notification", content.toString());
							if (emailSuccess) {
								updateCMSLabLogSendMailStatus(labLogIDs, "Success");
							} else {
								updateCMSLabLogSendMailStatus(labLogIDs, "Send Failed");
								EmailAlertDB.sendEmail("lis.doc.acc", 
										"[" + ConstantsServerSide.SITE_CODE + "] LAB Doctor email error: failed to send email", 
										"Failed to send email<br/>" +
										"Doctor: " + d.docCode + "<br/>" +
										"CIS_LAB_ID = " + StringUtils.join(labLogIDs, ","));
							}
						} else {
							EmailAlertDB.sendEmail("lis.doc.acc", 
									"[" + ConstantsServerSide.SITE_CODE + "] LAB Doctor email error: labo_curr_report and cis_lab_log not match", 
									"Failed to insert to cis_lab_log<br/>" +
									"Doctor: " + d.docCode + "<br/>" +
									"Unmatch CIS_LAB_ID = " + StringUtils.join(unmatchList, ","));	
						}
					} else {
						EmailAlertDB.sendEmail("lis.doc.acc", 
								"[" + ConstantsServerSide.SITE_CODE + "] LAB Doctor email error: failed to insert to cis_lab_log", 
								"Failed to insert to cis_lab_log<br/>" +
								"Doctor: " + d.docCode + "<br/>" +
								"CIS_LAB_ID = " + StringUtils.join(labLogIDs, ","));
					}
				}
			} else {
				for (LabReportDetail l : d.labDetailList) {
					CMSDB.insertCMSLabLog(Integer.toString(l.labLogID), l.labNum, d.docCode, "MAIL", l.testCat, l.rptNo, l.rptVersion, l.filePath, d.email, "No Email", "0");
					CMSDB.updateEmailStatus(l.labNum, l.testCat, l.rptNo, l.rptVersion, "S");
				}
			}
		}
	}

	private static StringBuffer generateEmailContent(String labNum, String testCat, String rptNo,
			String docCode, String labLogID, String critical) {
		StringBuffer content = new StringBuffer();

		content.append("<tr>");
		content.append("<td>");
		if ("Y".equals(critical)) {
			content.append("<font color='red' style='font-weight:bold'>" + CMSDB.getPatientName(labNum) + "</font>");
		} else {
			content.append(CMSDB.getPatientName(labNum));
		}
		content.append("</td>");
		content.append("<td>");
		if ("Y".equals(critical)) {
			content.append("<font color='red' style='font-weight:bold'>" + labNum+":"+testCat+":"+rptNo + "</font>");
		} else {
			content.append(labNum+":"+testCat+":"+rptNo);
		}
		content.append("</td>");

		String url = "";
		if (ConstantsServerSide.isTWAH()) {
			if (ConstantsServerSide.DEBUG) {
				url = "http://localhost:8080/intranet/cms/convertPdfWithPW.jsp?";
				//url = "http://localhost:8080/intranet/cms/convertPdf.jsp?";
			} else {
				url = "https://mail.twah.org.hk/intranet/cms/convertPdfWithPW.jsp?";
				//url = "https://mail.twah.org.hk/intranet/cms/convertPdf.jsp?";
			}
		} else {
			if (ConstantsServerSide.DEBUG) {
				//url = "http://160.100.2.99:8080/intranet/cms/convertPdfWithPW.jsp?";
				url = "http://localhost:8080/intranet/cms/convertPdfWithPW.jsp?";
				//url = "http://160.100.2.45/intranet/cms/convertPdf.jsp?";
				//url = "http://demo3/intranet/cms/convertPdf.jsp?";
			} else {
				//url = "https://mail.hkah.org.hk/intranet/cms/convertPdf.jsp?";
				url = "https://mail.hkah.org.hk/intranet/cms/convertPdfWithPW.jsp?";
			}
		}
		content.append("<td>");
		content.append("<a href='");
		content.append(url);
		content.append("labLogID=");
		content.append(labLogID);
		content.append("&docCode=");
		content.append(docCode);
		content.append("&");
		content.append("'>link</a>");
		content.append("</td>");
		content.append("</tr>");

		return content;
	}

	public static ArrayList getPatientDetails(String patNo) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT PATNO, PATFNAME || ' ' || PATGNAME, TO_CHAR(PATBDATE, 'DD/MM/YYYY'), PATSEX FROM PATIENT@IWEB ");
		sqlStr.append("where PATNO = '" + patNo +"' ");

		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	private static boolean createDrPortalAccount(String drCode) {
		boolean isAccountCreated = true;
		if (!CMSDB.drPortalAccExist(drCode)) {
			ArrayList lis_doc_info = CMSDB.getLISDocInfo(drCode);
			ArrayList hats_doc_info =  CMSDB.getHATSDocInfo(drCode);

			String hatsCode = drCode;
			String portalLoginID = "DR"+drCode;
			String lastName = "";
			String givenName = "";
			String accountPassword = "";

			ReportableListObject row = null;
			if (lis_doc_info.size() > 0) {
				row = (ReportableListObject) lis_doc_info.get(0);
				lastName = row.getValue(0);
				givenName = row.getValue(1);
			}

			if (hats_doc_info.size() > 0) {
				row = (ReportableListObject) hats_doc_info.get(0);
				String hkidFirstFourChar = "";
				String hkidFromSearch = row.getValue(1);
				String dobFromSearch = row.getValue(2);;
				if (hkidFromSearch != null && hkidFromSearch.length() > 0) {
					hkidFirstFourChar = hkidFromSearch.substring(0, Math.min(hkidFromSearch.length(), 4));
				}
				String mmForPW = "";
				String ddForPW = "";
				if (dobFromSearch != null && dobFromSearch.length() > 0) {
					String[] splitDOB = dobFromSearch.split("/");
						if (splitDOB.length == 3) {
							mmForPW = splitDOB[1];
							ddForPW = splitDOB[0];
					}
				}
				accountPassword = hkidFirstFourChar + mmForPW + ddForPW ;
			}

			CMSDB.insertSSOUserMaping(hatsCode, portalLoginID);
			CMSDB.insertSSOUser(hatsCode, portalLoginID, lastName, givenName);
			CMSDB.insertPortalAccount(hatsCode, portalLoginID, lastName, givenName, accountPassword);

			StringBuffer content = new StringBuffer();
			content.append("SSO User (ID = " + portalLoginID + ", SSO Staff No = " + portalLoginID +")");
			content.append("<br/>");
			content.append("SSO User Mapping (Module Code = doctor, Module User ID = " + hatsCode + ", SSO User ID = " + portalLoginID + ")");
			content.append("<br/>");
			content.append("Portal User (Username = " + portalLoginID + ", Staff ID = " + portalLoginID);
			if (accountPassword.length() != 8) {
				content.append("<br/>");
				content.append("*Doctor ID, DOB info are missing. Password length = " + accountPassword.length() + ". May not login properly.");
			}

			EmailAlertDB.sendEmail("lis.doc.acc", "LAB Doctor account created - " + drCode, content.toString());
		}
		return isAccountCreated;
	}

	public static void openPasspordPDF(File file) {
		try{
			InputStream is = null;
			PDDocument document  = PDDocument.load(file,"12345");
			document.setAllSecurityToBeRemoved(true);

		} catch (IOException e) {

		}
	}
	
//E-FORM methods
	public static JSONObject getForm(String formID, String key1, String key2, String key3) {

		JSONObject form = new JSONObject();
		JSONArray section = new JSONArray();
		JSONObject item = null;
		
		String sectionID = null;
		  
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select sect_id, sect_seq, fld, val from gen_form@cis ");
		sqlStr.append(" where form_id = ? ");
		sqlStr.append(" and key1 = ? ");
		sqlStr.append(" and key2 = ? "); 
		sqlStr.append(" and key3 = ? ");
		//sqlStr.append(" and delete_dt is null ");
		sqlStr.append(" order by sect_id, sect_seq ");
		
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{formID, key1, key2, key3});

		ReportableListObject row = null;
			
		for (int i = 0; i < record.size(); i++) {	
			row = (ReportableListObject)record.get(i);
			
			//System.out.println("[DEBUG]" + row.getValue(2) +" : " +  row.getValue(3));
			
			if (row.getValue(0).equals(sectionID)) {
				
				if (section.size() == Integer.parseInt(row.getValue(1))) {
					item.put(row.getValue(2), row.getValue(3));
				} else {
					
					section.add(item);
					item = new JSONObject();
					item.put(row.getValue(2), row.getValue(3));
				}
				
			} else {
				
				if (item != null) {
					section.add(item);
					form.put(sectionID, section);				
				}
				
				sectionID = row.getValue(0);
				section = new JSONArray();
				item = new JSONObject();
				item.put(row.getValue(2), row.getValue(3));
			}
								
		}
		
		
		if (item != null) {
			section.add(item);
			form.put(sectionID, section);
		}
		
		return form;	
	}

	public static JSONObject getForm(String formID, String key1, String key2) {
		return getForm(formID, key1, key2, "0"); 
	}

	public static JSONObject getForm(String formID, String key1) {
		return getForm(formID, key1, "0", "0"); 
	}

	public static boolean setForm(String formID, String key1, String key2, String key3, JSONObject formData, String updateUser, String refKey1) {

		StringBuffer sqlSelSect = new StringBuffer();
		sqlSelSect.append("select distinct sect_id from gen_form@cis ");
		sqlSelSect.append(" where form_id = ? ");
		sqlSelSect.append(" and key1 = ? ");
		sqlSelSect.append(" and key2 = ? "); 
		sqlSelSect.append(" and key3 = ? ");
		
		StringBuffer sqlDelSect = new StringBuffer();
		sqlDelSect.append("delete gen_form@cis ");
		sqlDelSect.append(" where form_id = ? ");
		sqlDelSect.append(" and key1 = ? ");
		sqlDelSect.append(" and key2 = ? "); 
		sqlDelSect.append(" and key3 = ? ");
		sqlDelSect.append(" and sect_id = ? ");
		
		StringBuffer sqlDelRows = new StringBuffer();
		sqlDelRows.append("delete gen_form@cis ");
		sqlDelRows.append(" where form_id = ? ");
		sqlDelRows.append(" and key1 = ? ");
		sqlDelRows.append(" and key2 = ? "); 
		sqlDelRows.append(" and key3 = ? ");
		sqlDelRows.append(" and sect_id = ? ");
		sqlDelRows.append(" and sect_seq >= ? ");
		
		StringBuffer sqlSel = new StringBuffer();
		sqlSel.append("select count(*) from gen_form@cis ");
		sqlSel.append(" where form_id = ? ");
		sqlSel.append(" and key1 = ? ");
		sqlSel.append(" and key2 = ? "); 
		sqlSel.append(" and key3 = ? ");
		sqlSel.append(" and sect_id = ? ");
		sqlSel.append(" and sect_seq = ? ");
		sqlSel.append(" and fld = ? ");
		
		StringBuffer sqlUpd = new StringBuffer();
		sqlUpd.append("update gen_form@cis ");
		sqlUpd.append(" set val = ?, ");
		sqlUpd.append(" update_usr = ?, ");
		sqlUpd.append(" update_dt = sysdate, ");
		sqlUpd.append(" ref_Key1 = ? ");
		sqlUpd.append(" where form_id = ? ");
		sqlUpd.append(" and key1 = ? ");
		sqlUpd.append(" and key2 = ? "); 
		sqlUpd.append(" and key3 = ? ");
		sqlUpd.append(" and sect_id = ? ");
		sqlUpd.append(" and sect_seq = ? ");
		sqlUpd.append(" and fld = ? ");
		sqlUpd.append(" and (val <> ? or val is null) ");
		
	/*	
		StringBuffer sqlDel = new StringBuffer();
		sqlDel.append("delete gen_form@cis ");
		sqlDel.append(" where form_id = ? ");
		sqlDel.append(" and key1 = ? ");
		sqlDel.append(" and key2 = ? "); 
		sqlDel.append(" and key3 = ? ");
	*/	
		StringBuffer sqlIns = new StringBuffer();
		sqlIns.append("insert into gen_form@cis ");
		sqlIns.append(" (VAL, create_USR, FORM_ID, KEY1, KEY2, KEY3, SECT_ID, SECT_SEQ, FLD, REF_KEY1 ) ");
		sqlIns.append(" values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?) ");
		
		ArrayList sectList = UtilDBWeb.getReportableList(sqlSelSect.toString(), new String[]{formID, key1, key2, key3});
		for (int i = 0; i < sectList.size(); i++) {
			ReportableListObject row = (ReportableListObject)sectList.get(i);
			String sectionID = row.getValue(0);
			
			Object obj = formData.get(sectionID);
			
			if (obj == null) {
				UtilDBWeb.updateQueue(sqlDelSect.toString(),
						new String[]{formID, key1, key2, key3, sectionID});
			}
		}			
	/*
	//Old version del all entry before insert 
		UtilDBWeb.updateQueue(sqlDel.toString(),
			new String[]{formID, key1, key2, key3});
	*/	

		for(Iterator iSec = formData.keySet().iterator(); iSec.hasNext();) {
		    
			String sectionID = (String) iSec.next();
		    JSONArray section = (JSONArray)formData.get(sectionID);	        
		    
			for (int i = 0; i < section.size(); i++) {
							
				JSONObject item = (JSONObject)section.get(i);
				String sectSeq = String.valueOf(i);
				
				for(Iterator iFld = item.keySet().iterator(); iFld.hasNext();) {
					
					String field = (String)iFld.next();
																
			    	String value = (String)item.get(field);
		
			    	ArrayList record = UtilDBWeb.getReportableList(sqlSel.toString(), new String[]{formID, key1, key2, key3, sectionID, sectSeq, field});
			
			    	if (record.size() > 0) {
			    		
			    		ReportableListObject row = (ReportableListObject)record.get(0);
			    		
			    		if (Integer.parseInt(row.getValue(0)) == 0) {
			    			if (!UtilDBWeb.updateQueue(sqlIns.toString(),
			    				new String[]{value, updateUser, formID, key1, key2, key3, sectionID, sectSeq, field, refKey1})) {
			    					
			    	    		System.out.println("[setForm] fail to insert: " + value + ":" + updateUser + ":" + formID + ":" + key1 + ":" + key2 + ":" + key3 + ":" + sectionID + ":" + sectSeq + ":" + field + ":" + refKey1);
			    	    		return false;
			    			}		    					
			    		} else {
			    			if (!UtilDBWeb.updateQueue(sqlUpd.toString(),
				    			new String[]{value, updateUser, refKey1, formID, key1, key2, key3, sectionID, sectSeq, field, value})) {
			    				/*
				    	    	System.out.println("[Error:] fail to update: " + value + ":" + updateUser + ":" + formID + ":" + key1 + ":" + key2 + ":" + key3 + ":" + sectionID + ":" + sectSeq + ":" + field);
				    	    	return false;
				    	    	*/
			    			}

			    		}		    								
			    	}
				}		
		
			}
			
			UtilDBWeb.updateQueue(sqlDelRows.toString(),
				new String[]{formID, key1, key2, key3, sectionID, String.valueOf(section.size())});
		    
		}
		
		return true;
	}
	
	public static boolean setForm(String formID, String key1, String key2, JSONObject formData, String updateUser, String refKey1) {
		return setForm(formID, key1, key2, "0", formData, updateUser, refKey1);
	}

	public static boolean setForm(String formID, String key1, JSONObject formData, String updateUser, String refKey1) {
		return setForm(formID, key1, "0", "0", formData, updateUser, refKey1);
	}
	
//================================================================================	
	
	public static String getRefKey1(String formID, String key1, String key2, String key3) {

		JSONObject form = new JSONObject();
		JSONArray section = new JSONArray();
		JSONObject item = null;
		
		String sectionID = null;
		String refKey = null;
		  
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select max(REF_KEY1) from gen_form@cis ");
		sqlStr.append(" where form_id = ? ");
		sqlStr.append(" and key1 = ? ");
		sqlStr.append(" and key2 = ? "); 
		sqlStr.append(" and key3 = ? ");
		
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{formID, key1, key2, key3});

		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject)record.get(0);
			refKey = row.getValue(0);
		}
		
		return refKey;	
	}
	
	public static String getRefKey1(String formID, String key1, String key2) {		
		return getRefKey1(formID, key1, key2, "0");	
	}
	
	public static String getRefKey1(String formID, String key1) {		
		return getRefKey1(formID, key1, "0", "0");	
	}	
	
//================================================================================		

	public static ReportableListObject getFormVersion(String formID, String date) {
		
		ReportableListObject row = null;
		
		try {				
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT form_location, rpt_location, form_ver, active_dt ");
			sqlStr.append(" FROM GEN_FORM_HEADER ");
			sqlStr.append(" WHERE FORM_ID = '" + formID + "' ");
			sqlStr.append(" and form_ver = ");
			sqlStr.append(" (select nvl(max(form_ver),1) from GEN_FORM_HEADER ");
			sqlStr.append("  WHERE FORM_ID = '" + formID + "' ");
			sqlStr.append("  AND	active_dt < " + date + " ) ");
					 
			ArrayList record = UtilDBWeb.getReportableListCIS(sqlStr.toString());
			
			//System.out.println("[DEBUG] " + sqlStr);			
			if (record.size() > 0)
				row = (ReportableListObject) record.get(0);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return row;
	}
	
	public static ReportableListObject getFormVersion(String formID, String date, String format) {		
		String formatDate = "TO_DATE('" + date + "', '" + format + "')";			
		return getFormVersion(formID, formatDate);		
	}
	
	public static ReportableListObject getCurrentForm (String formID) {				
		return getFormVersion(formID, "SYSDATE");		
	}
	
	public static String getCISusername(String userId) {
		
		String username = null;
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("select user_name from ah_sys_user where user_id = ?");
		ArrayList record = UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[] {userId});
		
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			username = row.getValue(0);
		} else {
			username = userId;
		}
		
		return username;
	}
//
}