/*
 * Created on April 9, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.db;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.commons.lang.StringUtils;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;
import com.hkah.web.db.helper.FsModelHelper;
import com.hkah.web.db.helper.FsModelHelper.ViewMode;
import com.hkah.web.db.model.FsCategory;
import com.hkah.web.db.model.FsFileCsv;
import com.hkah.web.db.model.FsFileIndex;
import com.hkah.web.db.model.FsFileProfile;
import com.hkah.web.db.model.FsForm;
import com.hkah.web.db.model.FsImportBatch;
import com.hkah.web.db.model.FsImportLog;

/**
 * To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Generation - Code and Comments
 */
public class ForwardScanningDB {
	private static String sqlStr_categoryList = null;
	private static String sqlStr_category = null;
	private static String sqlStr_getIcdName = null;
	private static String sqlStr_getBatchNoByImportDate = null;
	private static String sqlStr_getDefaultFormCodesByCategoryID = null;
	private static String sqlStr_addFsFileIndex = null;
	private static String sqlStr_addFsFileProfile = null;
	private static String sqlStr_addFsCategory = null;
	private static String sqlStr_addFsForm = null;
	private static String sqlStr_addFsFormAlias = null;
	private static String sqlStr_addFsImportLog = null;
	private static String sqlStr_addFsImportBatch = null;
	private static String sqlStr_updateFsFileIndex = null;
	private static String sqlStr_updateFsFileProfile = null;
	private static String sqlStr_updateFsCategory = null;
	private static String sqlStr_updateFsCategoryOrder = null;
	private static String sqlStr_updateFsForm = null;
	private static String sqlStr_updateImportLogHandle = null;
	private static String sqlStr_actualDeleteFsFileIndex = null;
	private static String sqlStr_actualDeleteFsCategory = null;
	private static String sqlStr_deleteFsFileIndex = null;
	private static String sqlStr_deprecateFsFileIndexes = null;
	private static String sqlStr_deleteFsFileProfile = null;	
	private static String sqlStr_deleteFsForm = null;
	private static String sqlStr_deleteFsFormAlias = null;
	private static String sqlStr_revertApprove = null;
	private static String sqlStr_isFormExist = null;
	private static String sqlStr_isFormAliasExist = null;
	private static String sqlStr_getLisHospnumByLabNum = null;
	private static String sqlStr_getFsLiveRecCount = null;
	private static String sqlStr_select_fileIndex = null;
	private static String sqlStr_select_fileStat = null;
	private static String sqlStr_loadSysParam = null;
	private static String sqlStr_getLastApprDateByPat = null;
	private static String sqlStr_getImportDatesByPat = null;
	private static String sqlStr_getPatMergeByFmPatno = null;
	private static String sqlStr_getPatMergeByToPatno = null;
	private static String sqlStr_getNextFsFileIndexIds = null;
	private static Map<String, String> approveStatusSql = new HashMap<String, String>();
	
	public static final String SQL_ORDER_BY_HKAH = " ORDER BY I.FS_SEQ DESC NULLS FIRST, I.FS_DUE_DATE DESC NULLS LAST, I.FS_IMPORT_DATE DESC NULLS LAST, I.FS_FILE_INDEX_ID";
	public static final String SQL_ORDER_BY_TWAH = " ORDER BY I.FS_DUE_DATE DESC NULLS LAST, FS_BATCH_NO DESC, I.FS_FILE_INDEX_ID, FS_SEQ";
	//public static final String SQL_ORDER_BY_TWAH = " ORDER BY I.FS_SEQ DESC NULLS FIRST, I.FS_DUE_DATE DESC NULLS LAST, I.FS_FILE_INDEX_ID";
	public static final String sqlStr_stat_groupBy = " GROUP BY I.FS_PATNO";
	public static final String sqlStr_stat_orderBy = " ORDER BY I.FS_PATNO";
	
	private static String getNextFsFileIndexId() {
		String fsFileIndexId = null;
		String sql = null;
		if (true) {
			sql = "SELECT SEQ_FS_FILE_INDEX_ID.NEXTVAL FROM DUAL";
		} else {
			sql = "SELECT MAX(FS_FILE_INDEX_ID) + 1 FROM FS_FILE_INDEX";
		}
		
		ArrayList result = UtilDBWeb
				.getReportableListCIS(sql);
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result
					.get(0);
			fsFileIndexId = reportableListObject.getValue(0);

			// set 1 for initial
			if (fsFileIndexId == null || fsFileIndexId.length() == 0)
				return ConstantsVariable.ONE_VALUE;
		}
		return fsFileIndexId;
	}
	
	public static List<BigDecimal> getNextFsFileIndexIds(int total) {
		List<BigDecimal> fsFileIndexIds = new ArrayList<BigDecimal>();
		ArrayList result = UtilDBWeb
				.getReportableListCIS(sqlStr_getNextFsFileIndexIds, new String[]{String.valueOf(total)});
		
		for (int i = 0; i < result.size(); i++) {
			ReportableListObject row = (ReportableListObject) result.get(i);
			fsFileIndexIds.add(new BigDecimal(row.getFields0()));
		}
		return fsFileIndexIds;
	}

	private static String getNextFsCategoryId() {
		String fsCategoryId = null;

		ArrayList result = UtilDBWeb
				.getReportableListCIS(
						"SELECT MAX(FS_CATEGORY_ID) + 1 FROM FS_CATEGORY");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			fsCategoryId = reportableListObject.getValue(0);

			// set 1 for initial
			if (fsCategoryId == null
					|| fsCategoryId.length() == 0)
				return ConstantsVariable.ONE_VALUE;
		}
		return fsCategoryId;
	}
	
	private static String getNextFsFormId() {
		String fsFormId = null;

		ArrayList result = UtilDBWeb
				.getReportableListCIS(
						"SELECT MAX(FS_FORM_ID) + 1 FROM FS_FORM");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			fsFormId = reportableListObject.getValue(0);

			// set 1 for initial
			if (fsFormId == null
					|| fsFormId.length() == 0)
				return ConstantsVariable.ONE_VALUE;
		}
		return fsFormId;
	}
	
	private static String getNextFsFormAliasId() {
		String fsFormAliasId = null;

		ArrayList result = UtilDBWeb
				.getReportableListCIS(
						"SELECT MAX(FS_FORM_ALIAS_ID) + 1 FROM FS_FORM_ALIAS");
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			fsFormAliasId = reportableListObject.getValue(0);

			// set 1 for initial
			if (fsFormAliasId == null
					|| fsFormAliasId.length() == 0)
				return ConstantsVariable.ONE_VALUE;
		}
		return fsFormAliasId;
	}
	
	private static String getNextFsImportLogId() {
		String fsImportId = null;
		String sql = null;
		if (true) {
			sql = "SELECT SEQ_FS_IMPORT_LOG_ID.NEXTVAL FROM DUAL";
		} else {
			sql = "SELECT MAX(FS_IMPORT_LOG_ID) + 1 FROM FS_IMPORT_LOG";
		}
		
		ArrayList result = UtilDBWeb
				.getReportableListCIS(sql);
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			fsImportId = reportableListObject.getValue(0);

			// set 1 for initial
			if (fsImportId == null
					|| fsImportId.length() == 0)
				return ConstantsVariable.ONE_VALUE;
		}
		return fsImportId;
	}
	
	public static String getNextFsBatchNo() {
		String fsBatchNo = null;
		String sql = null;
		if (true) {
			sql = "SELECT SEQ_FS_BATCH_NO.NEXTVAL FROM DUAL";
		} else {
			sql = "SELECT MAX((COALESCE(FS_BATCH_NO, 0))) + 1 FROM FS_IMPORT_LOG";
		}
		
		ArrayList result = UtilDBWeb
				.getReportableListCIS(sql);
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			fsBatchNo = reportableListObject.getValue(0);

			// set 1 for initial
			if (fsBatchNo == null
					|| fsBatchNo.length() == 0)
				return ConstantsVariable.ONE_VALUE;
		}
		return fsBatchNo;
	}
	
	public static ArrayList getFileList(ViewMode mode) {
		return getFile(mode, null);
	}
	
	public static ArrayList getFile(ViewMode mode, String fileIndexId) {
		return getFileList(mode, fileIndexId, null, null, null, null, null, null, null,
				null, null, null, null, null, null, null, null,
				false, false, true, true, null, null);
	}
	
	public static ArrayList getFileIndex(ViewMode mode, String patno) {
		return getFileList(mode, null, patno, null, null, null, null, null, null,
				null, null, null, null, null, null, null, null,
				false, false, true, true, null, null);
	}
	
	public static ArrayList getFileIndex(ViewMode mode, String patno, boolean orderByImport, boolean orderByDueDate) {
		return getFileList(mode, null, patno, null, null, null, null, null, null, null,
				null, null, null, null, null, null, null,
				orderByImport, orderByDueDate, true, true, null, null);
	}
	
	public static ArrayList getFileParentCat(ViewMode mode, String patno, boolean orderByImport, boolean orderByDueDate, String parentCat) {
		return getFileList(mode, null, patno, null, null, null, null, null, null, null,
				null, null, null, null, null, null, null,
				orderByImport, orderByDueDate, true, true, null, parentCat);
	}
	
	public static ArrayList getFileIndexFormExceeded(String formCode, String patno, String pattype) {
		return ForwardScanningDB.getFileList(ViewMode.ADMIN, patno, null, pattype, null, 
				formCode, null, null, null, null, null, null, null, null, null, true, true, true, true, null);
	}
	
	public static ArrayList getFileList(ViewMode mode, String patno, String regId, String pattype, String formName, String formCode,
			String dueDate, String admDateFrom, String admDateTo, String dischargeDateFrom, String dischargeDateTo, String importDateFrm, 
			String importDateTo, String approveStatus, String batchNo, boolean orderByImport, boolean orderByDueDate, boolean showAutoImport, boolean showHIS,
			String[] importBys) {
		return getFileList(mode, null, null, patno, regId, pattype, formName, formCode,
				dueDate, admDateFrom, admDateTo, dischargeDateFrom, dischargeDateTo, importDateFrm, importDateTo, approveStatus, batchNo,
				orderByImport, orderByDueDate, showAutoImport, showHIS, importBys, null);
	}

	public static ArrayList getFileList(ViewMode mode, String fileIndexId, String patnoExact, String patno, String regId, String pattype, String formName, String formCode,
			String dueDate, String admDateFrom, String admDateTo, String dischargeDateFrom, String dischargeDateTo, String importDateFrm, String importDateTo, String approveStatus, String batchNo,
			boolean orderByImport, boolean orderByDueDate, boolean showAutoImport, boolean showHIS, String[] importBys, String parentCat) {	
		List<String> params = new ArrayList<String>();
		StringBuffer sqlStr = new StringBuffer();
		
		if (ViewMode.FILE_STAT.equals(mode)) {
			sqlStr.append(sqlStr_select_fileStat);
		} else {
			sqlStr.append(sqlStr_select_fileIndex);
		}
		sqlStr.append("FROM   	FS_FILE_INDEX I LEFT JOIN FS_FILE_PROFILE P ");
		sqlStr.append(" ON	I.FS_FILE_INDEX_ID = P.FS_FILE_INDEX_ID ");
		sqlStr.append("	LEFT JOIN FS_CATEGORY C ");
		sqlStr.append(" ON	P.FS_CATEGORY_ID = C.FS_CATEGORY_ID ");
		sqlStr.append("	LEFT JOIN FS_IMPORT_LOG L ");
		sqlStr.append(" ON	L.FS_FILE_INDEX_ID = I.FS_FILE_INDEX_ID ");
		sqlStr.append(" LEFT JOIN CO_USERS@portal U ");
		sqlStr.append(" ON I.FS_CREATED_USER = U.CO_USERNAME ");
		sqlStr.append("WHERE ");
		if (mode.equals(ViewMode.LIVE)) {
			sqlStr.append("	I.FS_ENABLED = 1 ");
		} else {
			sqlStr.append("	I.FS_ENABLED >= 1 ");
		}
		if (fileIndexId != null && !"".equals(fileIndexId)) {
			sqlStr.append(" AND I.FS_FILE_INDEX_ID = ?");
			params.add(fileIndexId);
		}
		if (patnoExact != null) {
			sqlStr.append(" AND I.FS_PATNO = ?");
			params.add(patnoExact);
		} else {
			if (patno != null && !"".equals(patno)) {
				sqlStr.append(" AND (I.FS_PATNO like '" + patno.trim().toUpperCase() + "%' OR I.FS_PATNO like '" + patno.trim().toLowerCase() + "%')");
			}
		}
		if (regId != null && !"".equals(regId)) {
			sqlStr.append(" AND I.FS_REGID like '%" + regId.trim() + "%'");
		}
		if (pattype != null && !"".equals(pattype)) {
			sqlStr.append(" AND I.FS_PATTYPE = ?");
			params.add(pattype.trim());
		}
		if (formName != null && !"".equals(formName)) {
			sqlStr.append(" AND UPPER(I.FS_FORM_NAME) like '%" + formName.toUpperCase() + "%'");
		}
		if (formCode != null && !"".equals(formCode)) {
			sqlStr.append(" AND UPPER(P.FS_FORM_CODE) like '%" + formCode.toUpperCase() + "%'");
		}
		if (dueDate != null && !"".equals(dueDate)) {
			sqlStr.append(" AND TO_DATE(?, 'DD/MM/YYYY') = TRUNC(I.FS_DUE_DATE)");
			params.add(dueDate);
		}
		if (admDateFrom != null && !"".equals(admDateFrom)) {
			sqlStr.append(" AND TO_DATE(?, 'DD/MM/YYYY') <= TRUNC(I.FS_ADM_DATE)");
			params.add(admDateFrom);
		}
		if (admDateTo != null && !"".equals(admDateTo)) {
			sqlStr.append(" AND TO_DATE(?, 'DD/MM/YYYY') >= TRUNC(I.FS_ADM_DATE)");
			params.add(admDateTo);
		}
		if (dischargeDateFrom != null && !"".equals(dischargeDateFrom)) {
			sqlStr.append(" AND TO_DATE(?, 'DD/MM/YYYY') <= TRUNC(I.FS_DISCHARGE_DATE)");
			params.add(dischargeDateFrom);
		}
		if (dischargeDateTo != null && !"".equals(dischargeDateTo)) {
			sqlStr.append(" AND TO_DATE(?, 'DD/MM/YYYY') >= TRUNC(I.FS_DISCHARGE_DATE)");
			params.add(dischargeDateTo);
		}
		if (importDateFrm != null && !"".equals(importDateFrm)) {
			sqlStr.append(" AND TRUNC(I.FS_IMPORT_DATE) >= TO_DATE(?, 'DD/MM/YYYY')");
			params.add(importDateFrm);
		}
		if (importDateTo != null && !"".equals(importDateTo)) {
			sqlStr.append(" AND TRUNC(I.FS_IMPORT_DATE) <= TO_DATE(?, 'DD/MM/YYYY')");
			params.add(importDateTo);
		}
		if (importBys != null && importBys.length > 0) {
			sqlStr.append(" AND (I.FS_CREATED_USER IN ('" + StringUtils.join(importBys, "','") + "')");
			sqlStr.append(" OR U.CO_STAFF_ID IN ('" + StringUtils.join(importBys, "','") + "'))");
		}
		if (batchNo != null && !"".equals(batchNo)) {
			sqlStr.append(" AND L.FS_BATCH_NO = ?");
			params.add(batchNo);
		}
		if (parentCat != null && !"".equals(parentCat)) {
			sqlStr.append(" AND (C.FS_CATEGORY_ID IN ("+parentCat +") OR C.FS_PARENT_CATEGORY_ID IN ("+parentCat +") ) ");
		}
		if (!showAutoImport) {
			sqlStr.append(" AND (l.fs_description not like '%auto import%' or l.fs_description is null)");
		}
		if (!showHIS) {
			sqlStr.append(" AND (L.FS_ENCODED_PARAMS not like '%Form Code=HIS%' or l.FS_ENCODED_PARAMS is null)");
		}
		
		if (mode.equals(ViewMode.DEBUG) || mode.equals(ViewMode.ADMIN) || mode.equals(ViewMode.FILE_STAT)) {
			// approve status
			String approveStatusStr = approveStatusSql.get(approveStatus);
			if (approveStatusStr != null) {
				sqlStr.append(" AND");
				sqlStr.append(approveStatusStr);
			}
		} else {
			// preview, live mode can access approved forms only
			sqlStr.append(" AND");
			sqlStr.append(approveStatusSql.get("P"));
		}
		if (mode.equals(ViewMode.LIVE)) {
			// 2. hide all images if either only DI auto import (no scanned charts) 
			//    or HIS in a particular patno
			sqlStr.append(" AND CMS_UTL_FS_LIVE_REC_COUNT('" + patnoExact + "', '" + ConstantsServerSide.SITE_CODE + "') > 0");
		}
		
		if (mode.equals(ViewMode.FILE_STAT)) {
			sqlStr.append(sqlStr_stat_groupBy);
			sqlStr.append(sqlStr_stat_orderBy);
		} else if (ConstantsServerSide.isHKAH()) {
			// FS_SEQ is used to override ordering, should set to null when import!  (2013-07-12)
			sqlStr.append(SQL_ORDER_BY_HKAH);
		} else {
			// to be deployed after KCP in twah is updated (2013-07-16)
			if (orderByImport) {
				sqlStr.append(" ORDER BY I.FS_IMPORT_DATE DESC NULLS LAST, I.FS_FILE_INDEX_ID, FS_SEQ");
				// sqlStr.append(" ORDER BY I.FS_SEQ DESC NULLS FIRST, I.FS_IMPORT_DATE DESC NULLS LAST, I.FS_FILE_INDEX_ID");
			} else if (orderByDueDate) {
				sqlStr.append(SQL_ORDER_BY_TWAH);
				// sqlStr.append(" ORDER BY I.FS_SEQ DESC NULLS FIRST, I.FS_DUE_DATE DESC NULLS LAST, I.FS_FILE_INDEX_ID");
			} else {
				sqlStr.append(" ORDER BY I.FS_FILE_INDEX_ID");
			}
		}
		
		//System.out.println("DEBUG: ForwardScanningDB getFileList SQL: " + sqlStr.toString());
		String[] paramsArray = params.toArray(new String[]{});
		return UtilDBWeb.getReportableListCIS(
				sqlStr.toString(), paramsArray);
	}
	
	public static ArrayList getFileIndexFilePath(String[] fileIndexIds) {
		// fetch user
		List<String> params = new ArrayList<String>();
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("	FS_FILE_INDEX_ID, ");
		sqlStr.append("	FS_FILE_PATH ");
		sqlStr.append("FROM   	FS_FILE_INDEX ");
		sqlStr.append("WHERE ");
		sqlStr.append("	FS_ENABLED >= 1 ");
		sqlStr.append(" AND FS_FILE_INDEX_ID IN (" + StringUtils.join(fileIndexIds, ",") + ")");
		
		//System.out.println("DEBUG: ForwardScanningDB getFileList SQL: " + sqlStr.toString());
		String[] paramsArray = params.toArray(new String[]{});
		return UtilDBWeb.getReportableListCIS(
				sqlStr.toString(), paramsArray);
	}
	
	public static ArrayList getForm(String formId) {
		return getFormList(formId, null, null, null, null, false, null);
	}
	
	public static ArrayList getFormList() {
		return getFormList(null, null, null, null, null, true, null);
	}
	
	public static ArrayList getFormList(String formId, String pattype, String formName, String formCode,
			String section, boolean isSearchFormAlias, String orderBy) {
		// fetch user
		List<String> params = new ArrayList<String>();
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DISTINCT ");
		sqlStr.append("	F.FS_FORM_ID, ");
		sqlStr.append("	F.FS_FORM_CODE, ");
		sqlStr.append("	F.FS_FORM_NAME, ");
		sqlStr.append("	F.FS_CATEGORY_ID, ");
		sqlStr.append("	F.FS_SECTION, ");
		sqlStr.append("	F.FS_SEQ, ");
		sqlStr.append("	F.FS_PATTYPE, ");
		sqlStr.append("	F.FS_IS_DEFAULT, ");
		sqlStr.append("	F.FS_CHART_MAX_ALLOW ");
		sqlStr.append("FROM   FS_FORM F ");
		sqlStr.append(" LEFT JOIN FS_FORM_ALIAS A ");
		sqlStr.append("   ON F.FS_FORM_ID = A.FS_FORM_ID ");
		StringBuffer sqlStrWhere = new StringBuffer();
		if (formId != null && !"".equals(formId)) {
			if (sqlStrWhere.length() > 0 )
				sqlStrWhere.append(" AND");
			sqlStrWhere.append(" F.FS_FORM_ID = ?");
			params.add(formId);
		}
		if (pattype != null && !"".equals(pattype)) {
			if (sqlStrWhere.length() > 0 )
				sqlStrWhere.append(" AND");
			sqlStrWhere.append(" F.FS_PATTYPE = ?");
			params.add(pattype);
		}
		if (formName != null && !"".equals(formName)) {
			if (sqlStrWhere.length() > 0 )
				sqlStrWhere.append(" AND");
			sqlStrWhere.append(" UPPER(F.FS_FORM_NAME) like '%" + formName.toUpperCase() + "%'");
		}
		if (formCode != null && !"".equals(formCode)) {
			if (sqlStrWhere.length() > 0 )
				sqlStrWhere.append(" AND");
			sqlStrWhere.append(" (");
			sqlStrWhere.append(" UPPER(F.FS_FORM_CODE) like '%" + formCode.toUpperCase() + "%'");
			if (isSearchFormAlias) {
				sqlStrWhere.append(" OR UPPER(A.FS_FORM_CODE) like '%" + formCode.toUpperCase() + "%'");
			}
			sqlStrWhere.append(" )");
		}
		if (section != null && !"".equals(section)) {
			if (sqlStrWhere.length() > 0 )
				sqlStrWhere.append(" AND");
			sqlStrWhere.append(" UPPER(F.FS_SECTION) like '%" + section.toUpperCase() + "%'");
		}
		if (sqlStrWhere.length() > 0)
			sqlStrWhere.insert(0, "WHERE ");
		sqlStr.append(sqlStrWhere);
		if (orderBy != null && !"".equals(orderBy)) {
			sqlStr.append(" ORDER BY " + orderBy);
		} else {
			sqlStr.append(" ORDER BY F.FS_SEQ, F.FS_FORM_ID");
		}
		
		String[] paramsArray = params.toArray(new String[]{});
		return UtilDBWeb.getReportableListCIS(
				sqlStr.toString(), paramsArray);
	}
	
	public static String getDefaultFormCodeByCategoryID(String categoryID) {
		String formCode = null;
		
		ArrayList record = getDefaultFormCodesByCategoryID(categoryID);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			formCode = row.getFields1();
		}
		return formCode;
	}
	
	public static ArrayList getDefaultFormCodesByCategoryID(String categoryId) {
		return UtilDBWeb.getReportableListCIS(
				sqlStr_getDefaultFormCodesByCategoryID, new String[]{ categoryId });
		
	}
	
	public static List getImportLog(String importLogId) {
		return getImportLogList(importLogId, null, null, null, null, null, null, null,null);
	}
	
	public static List getImportLogList(String importLogId, String importDateFrom, String importDateTo, String batchNo,
			String encodedParams, String[] importBy, String importStatus, String approveStatus,String patNo) {
		List<String> params = new ArrayList<String>();
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("	L.FS_IMPORT_LOG_ID, ");
		sqlStr.append("	L.FS_FILE_INDEX_ID, ");
		sqlStr.append("	L.FS_BATCH_NO, ");
		sqlStr.append("	TO_CHAR(L.FS_IMPORT_DATE, 'DD/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("	L.FS_ENCODED_PARAMS, ");
		sqlStr.append("	L.FS_DESCRIPTION, ");
		sqlStr.append("	L.FS_HANDLED, ");
		sqlStr.append("	L.FS_HANDLED_DESC, ");
		sqlStr.append("	TO_CHAR(I.FS_APPROVED_DATE, 'DD/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("	I.FS_APPROVED_USER, ");
		sqlStr.append("	I.FS_ENABLED, ");
		sqlStr.append("	I.FS_CREATED_USER ");
		sqlStr.append("FROM   FS_IMPORT_LOG L ");
		sqlStr.append(" LEFT JOIN FS_FILE_INDEX I ");
		sqlStr.append("  ON L.FS_FILE_INDEX_ID = I.FS_FILE_INDEX_ID ");
		sqlStr.append(" LEFT JOIN CO_USERS@portal U ");
		sqlStr.append("  ON L.FS_CREATED_USER = U.CO_USERNAME ");
		StringBuffer sqlStrWhere = new StringBuffer();
		if (importLogId != null && !"".equals(importLogId)) {
			if (sqlStrWhere.length() > 0 )
				sqlStrWhere.append(" AND");
			sqlStrWhere.append(" L.FS_IMPORT_LOG_ID = ?");
			params.add(importLogId);
		}
		if (batchNo != null && !"".equals(batchNo)) {
			if (sqlStrWhere.length() > 0 )
				sqlStrWhere.append(" AND");
			sqlStrWhere.append(" L.FS_BATCH_NO = ?");
			params.add(batchNo);
		}
		if (encodedParams != null && !"".equals(encodedParams)) {
			if (sqlStrWhere.length() > 0 )
				sqlStrWhere.append(" AND");
			sqlStrWhere.append(" L.FS_ENCODED_PARAMS like '%" + encodedParams + "%'");
		}
		if (importBy != null && importBy.length > 0) {
			if (sqlStrWhere.length() > 0 )
				sqlStrWhere.append(" AND");
			sqlStrWhere.append(" (L.FS_CREATED_USER IN ('" + StringUtils.join(importBy, "','") + "')");
			sqlStrWhere.append(" OR U.CO_STAFF_ID IN ('" + StringUtils.join(importBy, "','") + "'))");
		}
		if (importDateFrom != null && !"".equals(importDateFrom)) {
			if (sqlStrWhere.length() > 0 )
				sqlStrWhere.append(" AND");
			importDateFrom = importDateFrom + " 000000";
			sqlStrWhere.append(" TO_DATE(?, 'DD/MM/YYYY HH24MISS') <= L.FS_IMPORT_DATE");
			params.add(importDateFrom);
		}
		if (importDateTo != null && !"".equals(importDateTo)) {
			if (sqlStrWhere.length() > 0 )
				sqlStrWhere.append(" AND");
			
			importDateTo = importDateTo + " 000000";
			sqlStrWhere.append(" TO_DATE(?, 'DD/MM/YYYY HH24MISS') + 1 > L.FS_IMPORT_DATE");
			params.add(importDateTo);
		}
		if(patNo != null && !"".equals(patNo)){
			if (sqlStrWhere.length() > 0 )
				sqlStrWhere.append(" AND");
			sqlStrWhere.append(" L.FS_ENCODED_PARAMS LIKE '%Patient Code=" + patNo +"%'");			
		}
		if (importStatus != null ) {
			if ("S".equals(importStatus)) {
				if (sqlStrWhere.length() > 0 )
					sqlStrWhere.append(" AND");
				sqlStrWhere.append(" L.FS_FILE_INDEX_ID IS NOT NULL");
			} else if ("F".equals(importStatus)) {
				if (sqlStrWhere.length() > 0 )
					sqlStrWhere.append(" AND");
				sqlStrWhere.append(" L.FS_FILE_INDEX_ID IS NULL AND (L.FS_HANDLED IS NULL OR L.FS_HANDLED <> 'Y')");
			} else if ("H".equals(importStatus)) {
				if (sqlStrWhere.length() > 0 )
					sqlStrWhere.append(" AND");
				sqlStrWhere.append(" L.FS_FILE_INDEX_ID IS NULL AND L.FS_HANDLED = 'Y'");
			}
		}
		String approveStatusStr = approveStatusSql.get(approveStatus);
		if (approveStatusStr != null) {
			if (sqlStrWhere.length() > 0 )
				sqlStrWhere.append(" AND");
			sqlStrWhere.append(approveStatusStr);
		}

		if (sqlStrWhere.length() > 0)
			sqlStrWhere.insert(0, "WHERE ");
		sqlStr.append(sqlStrWhere);
		sqlStr.append(" ORDER BY L.FS_BATCH_NO DESC, L.FS_IMPORT_DATE DESC, L.FS_IMPORT_LOG_ID");
		
		// System.out.println("getImportLogList sql = " + sqlStr.toString());
		String[] paramsArray = params.toArray(new String[]{});
		return UtilDBWeb.getReportableListCIS(sqlStr.toString(), paramsArray);
	}
	
	public static List getCategory(String categoryId) {
		return UtilDBWeb.getReportableListCIS(
				sqlStr_category, new String[]{ categoryId });
	}
	
	public static List getCategoryList() {
		return UtilDBWeb.getReportableListCIS(
				sqlStr_categoryList);
	}
	
	public static List getCategoryListByParentId(BigDecimal fsParentCategoryId) {
		String parentId = null;
		try {
			parentId = fsParentCategoryId.toPlainString();
		} catch (Exception ex) {
		}
		
		List<String> params = new ArrayList<String>();
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.setLength(0);
		sqlStr.append("SELECT FS_CATEGORY_ID, FS_NAME, FS_PARENT_CATEGORY_ID, FS_SEQ, FS_IS_MULTI ");
		sqlStr.append("FROM   FS_CATEGORY ");
		sqlStr.append("WHERE  ");
		if (parentId == null) {
			sqlStr.append("FS_PARENT_CATEGORY_ID IS NULL ");
		} else { 
			sqlStr.append("FS_PARENT_CATEGORY_ID = ? ");
			params.add(parentId);
		}
		sqlStr.append("ORDER BY FS_SEQ, FS_CATEGORY_ID");
		
		String[] paramsArray = params.toArray(new String[]{});
		return UtilDBWeb.getReportableListCIS(
				sqlStr.toString(), paramsArray);
	}
	

	public static String getMatchedCategoryId(FsFileCsv fsFileCsv) {
		if (fsFileCsv == null) {
			return null;
		}
		String categoryId = null;
		String formCode = fsFileCsv.getFormCode();
		String fileDocType = fsFileCsv.getFileDocType();
		
		// Special logic: 
		// For site HKAH, if form code is blank or null, 
		//				  if file doc type = I, map it to category In-patient - Miscellaneous (category id = 13)
		//		  		  otherwise, map all to category Outpatient - Miscellaneous (category id = 18)
		// For site TWAH, if form code is blank or null, map it to Corresp. & Misc. (category id = 20)
		//				  if form code CANNOT map to any category, map it to Corresp. & Misc. (category id = 20)
		//
		// *form code "." is treated as blank
		if (formCode == null || "".equals(formCode) || FsModelHelper.FORM_CODE_BLANK.equals(formCode)) {
			if (ConstantsServerSide.isHKAH()) {
				if (FsModelHelper.PAT_TYPE_CODE_IP.equals(fileDocType))
					categoryId = FsModelHelper.HKAH_IP_MISC_CAT_ID.toPlainString();
				else
					categoryId = FsModelHelper.HKAH_OP_MISC_CAT_ID.toPlainString();
			} else if (ConstantsServerSide.isTWAH()) {
				categoryId = FsModelHelper.TWAH_MISC_CAT_ID.toPlainString();
			} else if (ConstantsServerSide.isAMC2()) {
				categoryId = getDefaultFormCodeByCategoryID(formCode);
			}
		} else {
			FsForm form = getFsFormByFsFileCsv(fsFileCsv);
			if (form != null) {
				categoryId = form.getFsCategoryId().toPlainString();
			} else {
				if (ConstantsServerSide.isTWAH()) {
					if (categoryId == null) {
						categoryId = FsModelHelper.TWAH_MISC_CAT_ID.toPlainString();
					}
				}
			}
			
			// check if category exist
			List categories = ForwardScanningDB.getCategory(categoryId);
			if (categories == null || categories.isEmpty()) {
				if (ConstantsServerSide.isHKAH())
					categoryId = FsModelHelper.HKAH_UNKNOWN_CAT_ID.toPlainString();
				else 
					categoryId = null;
			}
		}
		
		return categoryId;
	}
	
	public static List<FsCategory> getFsCategoryAncestors(BigDecimal fsCategoryId, Integer maxLevel) {
		if (fsCategoryId == null) {
			return null;
		}
		final int MAX_LOOP = 100;
		List categoryList = null;
		List tempList = null;
		boolean isSearchEnd = false;
		
		try {
			String categoryId = null;
			try {
				categoryId = fsCategoryId.toPlainString();
			} catch (Exception ex) {
			}
			
			categoryList = UtilDBWeb.getReportableListCIS(
					sqlStr_category, new String[]{ categoryId });
			
			if (categoryList != null && !categoryList.isEmpty()) {
				ReportableListObject row = (ReportableListObject) categoryList.get(0);
				String parentId = row.getValue(2);
				
				tempList = new ArrayList();
				tempList.add(row);
				
				while (!isSearchEnd) {
					categoryList = UtilDBWeb.getReportableListCIS(
							sqlStr_category, new String[]{ parentId });
					
					if (categoryList != null && !categoryList.isEmpty()) {
						row = (ReportableListObject) categoryList.get(0);
						tempList.add(0, categoryList.get(0));
						parentId = row.getValue(2);
					} else {
						isSearchEnd = true;
					}
					
					if (!isSearchEnd && 
							(tempList.size() >= maxLevel || tempList.size() >= MAX_LOOP)) {
						isSearchEnd = true;
					}
				}
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		
		return FsModelHelper.getFsCategoryModels(tempList);
	}
	
	public static FsForm getFsFormByFsFileCsv(FsFileCsv fsFileCsv) {
		if (fsFileCsv == null) {
			return null;
		}
		return getFsForm(fsFileCsv.getFormCode(), fsFileCsv.getFileDocType());
	}
	
	public static FsForm getFsFormByFsFileIndex(FsFileIndex fsFileIndex) {
		if (fsFileIndex == null) {
			return null;
		}
		return getFsForm(fsFileIndex.getFsFormCode(), fsFileIndex.getFsPattype());
	}

	public static FsForm getFsForm(String formCode, String pattype) {
		String formName = null;
		
		// search alias
		if (!ForwardScanningDB.isFormExist(formCode, pattype)) {
			ArrayList formCodes = ForwardScanningDB.getFormCodeByAlias(formCode, pattype);
			if (formCodes != null && formCodes.size() > 0) {
				ReportableListObject row = (ReportableListObject) formCodes.get(0);
				formCode = row.getFields0();
			}
		}

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT ");
		sqlStr.append("  FS_FORM_ID, FS_FORM_CODE, FS_FORM_NAME, FS_CATEGORY_ID ,FS_SECTION, FS_SEQ, FS_PATTYPE, FS_IS_DEFAULT ");
		sqlStr.append("FROM ");
		sqlStr.append("( ");
		sqlStr.append("SELECT ");
		sqlStr.append("* ");
		sqlStr.append("FROM FS_FORM ");
		sqlStr.append("WHERE ");
		sqlStr.append("  (FS_FORM_CODE = ? AND (FS_PATTYPE = ? OR FS_PATTYPE IS NULL)) ");
		sqlStr.append("  OR (FS_FORM_CODE IS NULL AND (FS_FORM_NAME = ? AND (FS_PATTYPE = ? OR FS_PATTYPE IS NULL))) ");
		sqlStr.append("  OR ((? = '' or ? is null) AND FS_FORM_CODE = ? AND FS_IS_DEFAULT = 'Y') ");
		sqlStr.append("ORDER BY FS_FORM_CODE, FS_PATTYPE ");
		sqlStr.append(") ");
		sqlStr.append("WHERE ROWNUM = 1");

		List result = UtilDBWeb.getReportableListCIS(
				sqlStr.toString(),
				new String[] { formCode, pattype, formName, pattype, pattype, pattype, formCode });

		FsForm form = null;
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			form = new FsForm();
			form.setFsFormId(new BigDecimal(row.getValue(0)));
			form.setFsFormCode(row.getValue(1));
			form.setFsFormName(row.getValue(2));
			form.setFsCategoryId(new BigDecimal(row.getValue(3)));
			form.setFsSection(row.getValue(4));
			form.setFsSeq(row.getValue(5));
			form.setFsPattype(row.getValue(6));
			form.setFsIsDefault(row.getValue(7));
		}
		return form;
	}
	
	public static ArrayList getIcdList(String regId) {
		if (regId == null)
			return null;
		
		ArrayList result = UtilDBWeb.getReportableList(sqlStr_getIcdName, new String[]{regId, regId});
		/*
		String icdCode = null;
		String icdDesc = null;
		if (result.size() > 0) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			icdCode = row.getValue(1);
			icdDesc = row.getValue(2);
		}
		*/
		return result;
	}

	public static FsFileIndex addFsFileIndex(UserBean userBean,
			FsFileIndex fsFileIndex) {

		if (fsFileIndex.getFsFileIndexId() == null) {
			fsFileIndex.setFsFileIndexId(new BigDecimal(getNextFsFileIndexId()));
		}
		
		String id = fsFileIndex.getFsFileIndexId().toPlainString();
		boolean success = false;
		success = UtilDBWeb.updateQueueCIS(
				sqlStr_addFsFileIndex,
				new String[] {
						id,
						fsFileIndex.getFsPatno(),
						fsFileIndex.getFsRegid(),
						DateTimeUtil.formatDate(fsFileIndex.getFsDueDate()),
						DateTimeUtil.formatDate(fsFileIndex.getFsAdmDate()),
						DateTimeUtil.formatDate(fsFileIndex.getFsDischargeDate()),
						DateTimeUtil.formatDateTime(fsFileIndex.getFsImportDate()),
						fsFileIndex.getFsFormName(),
						fsFileIndex.getFsFilePath(),
						fsFileIndex.getFsPattype(), fsFileIndex.getFsSeq(),
						fsFileIndex.getFsLabNum(),
						userBean.getLoginID(), userBean.getLoginID(),
						fsFileIndex.getFsApprovedUser(), 
						DateTimeUtil.formatDateTime(fsFileIndex.getFsApprovedDate())});
		
		if (success) {
			success = addFsFileProfile(userBean, id, fsFileIndex.getFsFileProfile());
			if (success) {
				return fsFileIndex;
			} else {
				success = UtilDBWeb.updateQueueCIS(
						sqlStr_actualDeleteFsFileIndex, new String[] {id});
			}
		}
		return null;
	}

	public static boolean addFsFileProfile(UserBean userBean,
			String fsFileIndexId, FsFileProfile fsFileProfile) {
		// FsFileProfileId same as fsFileIndexId
		FsCategory thisCategory = fsFileProfile.getFsCategory();
		String categoryId = (thisCategory != null ? 
				(thisCategory.getFsCategoryId() != null ? thisCategory.getFsCategoryId().toString() : "") : null);

		return UtilDBWeb.updateQueueCIS(sqlStr_addFsFileProfile,
				new String[] {fsFileIndexId, fsFileIndexId, fsFileProfile.getFsIcdCode(), fsFileProfile.getFsIcdName(),
						categoryId, fsFileProfile.getFsFormCode(), 
						fsFileProfile.getFsStnid(), fsFileProfile.getFsRisAccessionNo(), fsFileProfile.getFsKey(),
						userBean.getLoginID(), userBean.getLoginID() });
	}
	
	public static boolean updateFsFile(UserBean userBean, FsFileIndex fsFileIndex) {
		if (fsFileIndex == null || fsFileIndex.getFsFileIndexId() == null)
			return false;
		
		FsFileProfile fsFileProfile = fsFileIndex.getFsFileProfile();
		FsCategory fsCategory = null;
		if (fsFileProfile != null) {
			fsCategory = fsFileProfile.getFsCategory();
		}
		String categoryId = null;
		if (fsCategory != null) {
			BigDecimal fsCategoryId = fsCategory.getFsCategoryId();
			if (fsCategoryId != null)
				categoryId = fsCategoryId.toPlainString();
		}

		boolean success = UtilDBWeb.updateQueueCIS(sqlStr_updateFsFileIndex,
				new String[] { fsFileIndex.getFsPatno(), fsFileIndex.getFsRegid(), DateTimeUtil.formatDate(fsFileIndex.getFsDueDate()),
						DateTimeUtil.formatDate(fsFileIndex.getFsAdmDate()), DateTimeUtil.formatDate(fsFileIndex.getFsDischargeDate()), 
						fsFileIndex.getFsFormName(), fsFileIndex.getFsFilePath(), fsFileIndex.getFsPattype(), fsFileIndex.getFsSeq(),
						fsFileIndex.getFsLabNum(), userBean.getLoginID(), fsFileIndex.getFsFileIndexId().toPlainString() });
		if (success && fsFileProfile != null) {
			success = UtilDBWeb.updateQueueCIS(sqlStr_updateFsFileProfile,
					new String[] { fsFileProfile.getFsIcdCode(), fsFileProfile.getFsIcdName(), categoryId, fsFileProfile.getFsFormCode(),
							fsFileProfile.getFsStnid(), fsFileProfile.getFsRisAccessionNo(), fsFileProfile.getFsKey(),
							userBean.getLoginID(), fsFileIndex.getFsFileIndexId().toPlainString() });
		}
		return success;
	}
	
	public static boolean deleteFsFile(UserBean userBean, String fsFileIndexId) {		
		boolean success = UtilDBWeb.updateQueueCIS(
				sqlStr_deleteFsFileIndex, new String[] { userBean.getLoginID(), fsFileIndexId });
		if (success) {
			success = UtilDBWeb.updateQueueCIS(
					sqlStr_deleteFsFileProfile, new String[] { userBean.getLoginID(), fsFileIndexId });
		}
		return success;
	}
	
	public static boolean deprecateFsFile(UserBean userBean, String prevHisFidsStr) {
		boolean success = false;
		if (prevHisFidsStr != null && !prevHisFidsStr.trim().isEmpty()) {
			success = UtilDBWeb.updateQueueCIS(
					sqlStr_deprecateFsFileIndexes.replace("#1", prevHisFidsStr), new String[] { userBean.getLoginID()});
		}
		return success;
	}
	
	public static boolean deleteFsFile(UserBean userBean, String patno, String importDate) {
		return deleteFsFile(userBean, patno, importDate, null, null);
	}
	
	public static boolean deleteFsFile(UserBean userBean, String patno, String importDate,
			String formCode, String approveStatus) {
		List<String> params = new ArrayList<String>();
		// get list
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT I.FS_FILE_INDEX_ID ");
		sqlStr.append("FROM   FS_FILE_INDEX I ");
		sqlStr.append("	LEFT JOIN FS_IMPORT_LOG L ON I.FS_FILE_INDEX_ID = L.FS_FILE_INDEX_ID ");
		sqlStr.append("	LEFT JOIN FS_FILE_PROFILE P ON I.FS_FILE_INDEX_ID = P.FS_FILE_INDEX_ID ");
		sqlStr.append("WHERE  1 = 1 ");
		if (patno != null && !"".equals(patno)) {
			sqlStr.append("  AND I.FS_PATNO = ?");
			params.add(patno);
		}
		if (importDate != null && !"".equals(importDate)) {
			sqlStr.append("  AND TO_DATE(?, 'DD/MM/YYYY') = TRUNC(L.FS_IMPORT_DATE)");
			params.add(importDate);
		}
		if (formCode != null && !"".equals(formCode)) {
			sqlStr.append("  AND P.FS_FORM_CODE = ?");
			params.add(formCode);
		}
		String approveStatusStr = approveStatusSql.get(approveStatus);
		if (approveStatusStr != null) {
			if (sqlStr.length() > 0 )
				sqlStr.append(" AND");
			sqlStr.append(approveStatusStr);
		}
		
		ArrayList list = UtilDBWeb.getReportableListCIS(sqlStr.toString(), params.toArray(new String[]{}));
		if (list == null || list.size() == 0) {
			return false;
		}
		String[] fsFileIndexes = new String[list.size()];
		for (int i = 0; i < list.size(); i++) {
			ReportableListObject row = (ReportableListObject) list.get(i);
			fsFileIndexes[i] = row.getFields0();
		}
		
		// delete FS_FILE_INDEX
		sqlStr.setLength(0);
		sqlStr.append("UPDATE ");
		sqlStr.append("	FS_FILE_INDEX ");
		sqlStr.append("SET ");
		sqlStr.append("	FS_ENABLED = 0, FS_MODIFIED_DATE = sysdate, FS_MODIFIED_USER = ? ");
		
		String[] ids = splitParamArray(fsFileIndexes);
		StringBuffer whereSql = new StringBuffer();
		for(int j=0;j<ids.length;j++){
		   if(j==0){	
			   whereSql.append("WHERE");
		   }else{
			   whereSql.append("OR");
		   }
		   whereSql.append(" FS_FILE_INDEX_ID IN (" + ids[j] + ") ");
		}
		sqlStr.append(whereSql);
		
		boolean success = UtilDBWeb.updateQueueCIS(
				sqlStr.toString(), new String[]{ userBean.getLoginID()});
		if (success) {
			sqlStr.setLength(0);
			sqlStr.append("UPDATE ");
			sqlStr.append("	FS_FILE_PROFILE ");
			sqlStr.append("SET ");
			sqlStr.append("	FS_ENABLED = 0, FS_MODIFIED_DATE = sysdate, FS_MODIFIED_USER = ? ");
			sqlStr.append(whereSql);
			
			success = UtilDBWeb.updateQueueCIS(
					sqlStr.toString(), new String[]{ userBean.getLoginID()});
		}
		return success;
	}
	
	public static boolean deleteFsFile(UserBean userBean, String[] fsFileIndexIds) {
		if (fsFileIndexIds == null || fsFileIndexIds.length == 0) {
			return false;
		}
		
		String[] splitFsFileIndexId = fsFileIndexIds[0].split(",");
		String[] tempFsFileIndexId = new String[(int)Math.ceil(splitFsFileIndexId.length/1000.0)];
		
		for(int i=0;i<tempFsFileIndexId.length;i++){
			tempFsFileIndexId[i] = StringUtils.join(Arrays.copyOfRange(splitFsFileIndexId,(i*1000),(((splitFsFileIndexId.length)<(((i+1)*1000)))?(splitFsFileIndexId.length):(((i+1)*1000))) ), ",");
		}
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE	FS_FILE_INDEX ");
		sqlStr.append("SET ");
		sqlStr.append("	FS_ENABLED = 0, FS_MODIFIED_DATE = sysdate, FS_MODIFIED_USER = ? ");
		
		StringBuffer sqlWhereStr = new StringBuffer();
		for(int j=0;j<tempFsFileIndexId.length;j++){
		   if(j==0){	
			   sqlWhereStr.append("WHERE  	FS_FILE_INDEX_ID IN (" + tempFsFileIndexId[j] + ") ");
		   }else{
			   sqlWhereStr.append("OR  	FS_FILE_INDEX_ID IN (" + tempFsFileIndexId[j] + ") ");
		   }
		}
		sqlStr.append(sqlWhereStr);
		sqlStr.append("	AND		FS_ENABLED >= 1");
		
		boolean success = UtilDBWeb.updateQueueCIS(
				sqlStr.toString(), new String[]{userBean.getLoginID()});
		
		if (success) {
			sqlStr.setLength(0);
			sqlStr.append("UPDATE ");
			sqlStr.append("	FS_FILE_PROFILE ");
			sqlStr.append("SET ");
			sqlStr.append("	FS_ENABLED = 0, FS_MODIFIED_DATE = sysdate, FS_MODIFIED_USER = ? ");
			sqlStr.append(sqlWhereStr);
			sqlStr.append("	AND		FS_ENABLED >= 1");
			
			success = UtilDBWeb.updateQueueCIS(
					sqlStr.toString(), new String[]{ userBean.getLoginID()});
		}
		return success;
	}
	
	public static boolean deleteFsCategory(UserBean userBean, String categoryId) {
		boolean success = UtilDBWeb.updateQueueCIS(
				sqlStr_actualDeleteFsCategory, new String[] { categoryId });
		return success;
	}
	
	public static boolean updateFsCategorySortOrder(BigDecimal[] ids, UserBean userBean) {
		if (ids == null) {
			return false;
		}
		
		boolean success = true;
		for (int i = 0; i < ids.length && success; i++) {
			if (ids[i] != null) {
				try {
					success = UtilDBWeb.updateQueueCIS(sqlStr_updateFsCategoryOrder,
							new String[] {String.valueOf(i), ids[i].toPlainString()});
				} catch (Exception e) {
					success = false;
				}
			}
		}
		
		return success;
	}
	
	public static FsCategory addFsCategory(UserBean userBean, FsCategory fsCategory) {
		if (fsCategory == null)
			return null;
		
		String id = getNextFsCategoryId();
		fsCategory.setFsCategoryId(new BigDecimal(id));
		boolean success = false;
		success = UtilDBWeb.updateQueueCIS(
				sqlStr_addFsCategory,
				new String[] {
						fsCategory.getFsCategoryId_String(),
						fsCategory.getFsName(),
						fsCategory.getFsParentCategoryId_String(),
						fsCategory.getFsSeq(),
						fsCategory.getFsIsMulti() });
		
		if (success)
			return fsCategory;
		else 
			return null;
	}
	
	public static FsCategory updateFsCategory(UserBean userBean, FsCategory fsCategory) {
		if (fsCategory == null)
			return null;
		
		boolean success = false;
		success = UtilDBWeb.updateQueueCIS(
				sqlStr_updateFsCategory,
				new String[] {
						fsCategory.getFsName(),
						fsCategory.getFsParentCategoryId_String(),
						fsCategory.getFsSeq(),
						fsCategory.getFsIsMulti(),
						fsCategory.getFsCategoryId_String() });
		
		if (success)
			return fsCategory;
		else 
			return null;
	}

	public static boolean addFsForm(UserBean userBean, FsForm fsForm) {

		String id = getNextFsFormId();
		fsForm.setFsFormId(new BigDecimal(id));
		boolean success = false;
		success = UtilDBWeb.updateQueueCIS(
				sqlStr_addFsForm,
				new String[] {
						id,
						fsForm.getFsFormCode(),
						fsForm.getFsFormName(),
						fsForm.getFsCategoryId() != null ? fsForm.getFsCategoryId().toPlainString() : null,
						fsForm.getFsSection(),
						fsForm.getFsSeq(),
						fsForm.getFsPattype(),
						fsForm.getFsIsDefault()
				});
		
		return success;
	}
	
	public static boolean updateFsForm(UserBean userBean, FsForm fsForm) {
		if (fsForm == null || fsForm.getFsFormId() == null)
			return false;
		
		String categoryId = fsForm.getFsCategoryId() != null ? fsForm.getFsCategoryId().toPlainString() : null;
		String formId = fsForm.getFsFormId() != null ? fsForm.getFsFormId().toPlainString() : null;

		boolean success = UtilDBWeb.updateQueueCIS(sqlStr_updateFsForm,
				new String[] { 
					fsForm.getFsFormCode(), fsForm.getFsFormName(), categoryId,
					fsForm.getFsSection(), fsForm.getFsSeq(), fsForm.getFsPattype(), fsForm.getFsIsDefault(), formId
				});
		return success;
	}
	
	public static boolean deleteFsForm(UserBean userBean, String fsFormId) {
		boolean success = UtilDBWeb.updateQueueCIS(
				sqlStr_deleteFsForm, new String[] { fsFormId });
		return success;
	}
	
	public static FsImportLog addFsImportLog(UserBean userBean, FsImportLog fsImportLog) {
		String id = getNextFsImportLogId();
		fsImportLog.setFsImportLogId(new BigDecimal(id));
		boolean success = false;
		success = UtilDBWeb.updateQueueCIS(
				sqlStr_addFsImportLog,
				new String[] {
						id,
						DateTimeUtil.formatDateTime(fsImportLog.getFsImportDate()),
						fsImportLog.getFsFileIndexId() != null ? fsImportLog.getFsFileIndexId().toPlainString() : null,
						fsImportLog.getFsBatchNo() != null ? fsImportLog.getFsBatchNo().toPlainString() : null,
						fsImportLog.getFsEncodedParams(), fsImportLog.getFsDescription(), userBean.getLoginID()
				});
		
		return success ? fsImportLog : null;
	}
	
	public static FsImportBatch addFsImportBatch(UserBean userBean, FsImportBatch fsImportBatch) {
		boolean success = false;
		success = UtilDBWeb.updateQueueCIS(
				sqlStr_addFsImportBatch,
				new String[] {
						fsImportBatch.getFsBatchNo().toString(),
						fsImportBatch.getFsIndexFileName(),
						userBean.getLoginID()
				});
		
		return success ? fsImportBatch : null;
	}

	public static boolean updateImportLogHandle(UserBean userBean, String importLogId, boolean isHandled, String handledDesc) {
		if (importLogId == null) {
			return false;
		}
		
		boolean success = true;
		try {
			success = UtilDBWeb.updateQueueCIS(sqlStr_updateImportLogHandle,
					new String[] {isHandled ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE, 
							handledDesc, importLogId});
		} catch (Exception e) {
			success = false;
		}
		
		return success;
	}
	
	public static String getBatchNoByImportDate(Date importDate) {
		if (importDate == null)
			return null;

		String BatchNo = null;
		String importDateStr = DateTimeUtil.formatDateTime(importDate);
		ArrayList result = UtilDBWeb.getReportableListCIS(sqlStr_getBatchNoByImportDate, new String[]{importDateStr});
		if (result != null && !result.isEmpty()) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			BatchNo = row.getValue(0);
		}
		return BatchNo;
	}
	
	public static ArrayList getFormAliasList(String formId) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT	FS_FORM_ALIAS_ID, FS_FORM_CODE ");
		sqlStr.append("FROM   	FS_FORM_ALIAS ");
		sqlStr.append("WHERE	FS_FORM_ID = ? ");
		sqlStr.append("ORDER BY FS_FORM_CODE");
		
		return UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[]{formId});
	}
	
	public static List<String> getBatchFileNames(Date greaterThan) {
		List<String> fileNames = new ArrayList<String>();
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT	FS_INDEX_FILE_NAME, TO_DATE(FS_CREATED_DATE, 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("FROM   	fs_import_batch ");
		if (greaterThan != null) {
			sqlStr.append("WHERE	FS_CREATED_DATE > TO_DATE(" + DateTimeUtil.formatDateTime(greaterThan) + ", 'DD/MM/YYYY HH24:MI:SS')");
		}
		sqlStr.append("ORDER BY FS_CREATED_DATE DESC");
		
		List<ReportableListObject> results = UtilDBWeb.getReportableListCIS(sqlStr.toString());
		for (int i = 0; i < results.size(); i++) {
			ReportableListObject rlo = (ReportableListObject) results.get(i);
			fileNames.add(rlo.getValue(0));
		}
		
		return fileNames;
	}
	
	public static List<FsImportBatch> getRelatedImportedBatches(String fileNamePrefix) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT	FS_BATCH_NO, FS_INDEX_FILE_NAME, TO_DATE(FS_CREATED_DATE, 'DD/MM/YYYY HH24:MI:SS'), FS_CREATED_USER ");
		sqlStr.append("FROM   	fs_import_batch ");
		sqlStr.append("WHERE	FS_INDEX_FILE_NAME LIKE '" + fileNamePrefix + "%' ");
		sqlStr.append("ORDER BY FS_CREATED_DATE DESC");
		
		List<ReportableListObject> results = UtilDBWeb.getReportableListCIS(sqlStr.toString());
		List<FsImportBatch> batches = new ArrayList<FsImportBatch>();
		FsImportBatch batch = null;
		for (int i = 0; i < results.size(); i++) {
			ReportableListObject rlo = (ReportableListObject) results.get(i);
			batch = new FsImportBatch();
			batch.setFsBatchNo(new BigDecimal(rlo.getFields0()));
			batch.setFsIndexFileName(rlo.getFields1());
			batch.setFsCreatedDate(DateTimeUtil.parseDateTime(rlo.getFields2()));
			batch.setFsCreatedUser(rlo.getFields3());
			
			batches.add(batch);
		}
		return batches;
	}
	
	public static ArrayList getAllFormatListByFormCode(String formCodeOrAlias, String fsPattype) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select 	distinct f.fs_form_code master, a.fs_form_code alias ");
		sqlStr.append("FROM   	fs_form f join fs_form_alias a on f.fs_form_id = a.fs_form_id ");
		sqlStr.append("WHERE	(f.fs_form_code = ? or a.fs_form_code = ?) ");
		sqlStr.append("And 	    (FS_PATTYPE is null or (FS_PATTYPE is not null and (? = FS_PATTYPE or (? is null and fs_is_default = 'Y'))))");
		sqlStr.append("ORDER BY A.FS_FORM_CODE");
		
		return UtilDBWeb.getReportableListCIS(sqlStr.toString(), 
				new String[]{formCodeOrAlias, formCodeOrAlias, fsPattype, fsPattype});
	}
	
	public static ArrayList getFormCodeByAlias(String formAlias, String pattype) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT	F.FS_FORM_CODE ");
		sqlStr.append("FROM   	FS_FORM_ALIAS A JOIN FS_FORM F ON A.FS_FORM_ID = F.FS_FORM_ID ");
		sqlStr.append("WHERE	A.FS_FORM_CODE = ? ");
		sqlStr.append("	AND (F.FS_PATTYPE = ? OR F.FS_PATTYPE IS NULL) ");
		
		return UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[]{formAlias, pattype});
	}
	
	public static boolean addFormAlias(UserBean userBean, String formId, String formAlias) {
		String formAliasId = ForwardScanningDB.getNextFsFormAliasId();
		return UtilDBWeb.updateQueueCIS(sqlStr_addFsFormAlias,
				new String[] { formId, formAliasId, formAlias} );
	}
	
	public static boolean deleteFormAlias(UserBean userBean, String fsFormAliasId) {
		boolean success = UtilDBWeb.updateQueueCIS(
				sqlStr_deleteFsFormAlias, new String[] { fsFormAliasId });
		return success;
	}
	
	public static boolean isFormExist(String fsformCode, String pattype) {
		ArrayList list = UtilDBWeb.getReportableListCIS(
				sqlStr_isFormExist, new String[] { fsformCode, pattype, pattype });
		if (list != null && list.size() > 0)
			return true;
		else 
			return false;
	}
	
	public static boolean isFormAliasExist(String fsformCode) {
		ArrayList list = UtilDBWeb.getReportableListCIS(
				sqlStr_isFormAliasExist, new String[] { fsformCode, fsformCode });
		if (list != null && list.size() > 0)
			return true;
		else 
			return false;
	}
	
	public static boolean approveFileIndex(UserBean userBean, String[] fsFileIndexId) {
		if (fsFileIndexId == null || fsFileIndexId.length == 0) {
			return false;
		}
		
		String[] splitFsFileIndexId = fsFileIndexId[0].split(",");
		String[] tempFsFileIndexId = new String[(int)Math.ceil(splitFsFileIndexId.length/1000.0)];
		
		for(int i=0;i<tempFsFileIndexId.length;i++){
			tempFsFileIndexId[i] = StringUtils.join(Arrays.copyOfRange(splitFsFileIndexId,(i*1000),(((splitFsFileIndexId.length)<(((i+1)*1000)))?(splitFsFileIndexId.length):(((i+1)*1000))) ), ",");
		}
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE	FS_FILE_INDEX ");
		sqlStr.append("SET		FS_APPROVED_DATE = sysdate, FS_APPROVED_USER = ?, ");
		sqlStr.append("			FS_MODIFIED_DATE = sysdate, FS_MODIFIED_USER = ? ");
		//sqlStr.append("WHERE  	FS_FILE_INDEX_ID IN (" + StringUtils.join(fsFileIndexId, ",") + ") ");
		sqlStr.append("WHERE		FS_ENABLED >= 1 ");
		
		for(int j=0;j<tempFsFileIndexId.length;j++){
		   if(j==0){	
			 sqlStr.append("AND  	(FS_FILE_INDEX_ID IN (" + tempFsFileIndexId[j] + ") ");
		   }else{
			 sqlStr.append("OR  	FS_FILE_INDEX_ID IN (" + tempFsFileIndexId[j] + ") ");
		   }
		}
		if (tempFsFileIndexId.length > 0) {
			sqlStr.append(")");
		}
		
		//System.out.println("DEBUG: approveFileIndex sql="+sqlStr.toString());
		return UtilDBWeb.updateQueueCIS(sqlStr.toString(), new String[]{ userBean.getLoginID(), userBean.getLoginID()});
	}
	
	private static String[] splitParamArray(String[] arr) {
		if (arr == null) {
			return null;
		}
		
		String[] splitArr = new String[(int)Math.ceil(arr.length/1000.0)];
		for(int i = 0; i < splitArr.length; i++){
			splitArr[i] = StringUtils.join(Arrays.copyOfRange(arr,(i*1000),(((arr.length)<(((i+1)*1000)))?(arr.length):(((i+1)*1000))) ), ",");
		}
		
		return splitArr;
	}
	
	public static String getLisHospnumByLabNum(String labNum) {
		String hospnum = null;
		ArrayList result = UtilDBWeb.getReportableList(sqlStr_getLisHospnumByLabNum, new String[]{labNum});
		if (!result.isEmpty()) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			hospnum = row.getValue(0);
		}
		return hospnum;
	}
	
	public static int getFsLiveRecCount(String patno, String siteCode) {
		int count = 0;
		ArrayList result = UtilDBWeb.getReportableListCIS(sqlStr_getFsLiveRecCount, 
				new String[]{patno, siteCode});
		if (!result.isEmpty()) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			String countStr = row.getValue(0);
			try {
				count = Integer.parseInt(countStr);
			} catch (Exception ex) {}
		}
		return count;
	}
	
	public static ArrayList getPrevFileIndexByLabNum(String labNum) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT 	FS_FILE_INDEX_ID, FS_PATNO, FS_APPROVED_USER, ");
		sqlStr.append("	TO_CHAR(FS_APPROVED_DATE, 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("FROM 	FS_FILE_INDEX ");
		sqlStr.append("WHERE 	FS_LAB_NUM = ?");
		sqlStr.append("AND	 	FS_ENABLED = 1");
		sqlStr.append("ORDER BY 	FS_FILE_INDEX_ID");
		return UtilDBWeb.getReportableListCIS(sqlStr.toString(), 
				new String[] { labNum });
	}
	
	public static boolean updateFsFileIndexSeq(UserBean userBean, String fsFileIndexId, String seq) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("UPDATE FS_FILE_INDEX ");
		sqlStr.append("SET ");
		sqlStr.append("  FS_SEQ = ? ");
		//sqlStr.append("  FS_MODIFIED_DATE = sysdate, ");
		//sqlStr.append("  FS_MODIFIED_USER = ? ");
		sqlStr.append("WHERE FS_FILE_INDEX_ID = ? ");
		
		return UtilDBWeb.updateQueueCIS(
				sqlStr.toString(), new String[]{ seq, fsFileIndexId});
	}
	
	// 2013-11-27 preserve original seq not implemented
	/*
	public static Map<String, String> getFsSeqs(String[] fsFileIndexIds) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT I.FS_FILE_INDEX, I.FS_SEQ ");
		sqlStr.append("FROM FS_FILE_INDEX I ");
		sqlStr.append("  LEFT JOIN FS_FILE_PROFILE P ");
		sqlStr.append("    ON  I.FS_FILE_INDEX_ID = P.FS_FILE_INDEX_ID ");
		sqlStr.append("  LEFT JOIN FS_IMPORT_LOG L on I.FS_FILE_INDEX_ID = L.FS_FILE_INDEX_ID ");
		sqlStr.append("WHERE I.FS_ENABLED >= 1 ");
		sqlStr.append("AND I.FS_FILE_INDEX_ID in ('" + StringUtils.join(fsFileIndexIds, ",") + "')");
		if (ConstantsServerSide.isHKAH()) {
			sqlStr.append(SQL_ORDER_BY_HKAH);
		} else if (ConstantsServerSide.isTWAH()) {
			sqlStr.append(SQL_ORDER_BY_TWAH);
		}
		
		return getFsSeqsMaps(UtilDBWeb.getReportableListCIS(sqlStr.toString()));
	}
	
	public static LinkedHashMap<String, String> getFsSeqsByPatCatId(String patno, String catId) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT I.FS_FILE_INDEX, I.FS_SEQ ");
		sqlStr.append("FROM FS_FILE_INDEX I ");
		sqlStr.append("  LEFT JOIN FS_FILE_PROFILE P ");
		sqlStr.append("    ON  I.FS_FILE_INDEX_ID = P.FS_FILE_INDEX_ID ");
		sqlStr.append("  LEFT JOIN FS_IMPORT_LOG L on I.FS_FILE_INDEX_ID = L.FS_FILE_INDEX_ID ");
		sqlStr.append("WHERE I.FS_ENABLED >= 1 ");
		sqlStr.append("AND I.FS_PATNO = ? ");
		sqlStr.append("AND P.FS_CATEGOTY_ID = ?");
		if (ConstantsServerSide.isHKAH()) {
			sqlStr.append(SQL_ORDER_BY_HKAH);
		} else if (ConstantsServerSide.isTWAH()) {
			sqlStr.append(SQL_ORDER_BY_TWAH);
		}
		
		return getFsSeqsMaps(UtilDBWeb.getReportableListCIS(sqlStr.toString(),
				new String[]{patno, catId}));
	}
	
	private static LinkedHashMap<String, String> getFsSeqsMaps(ArrayList<ReportableListObject> result) {
		LinkedHashMap<String, String> maps = new LinkedHashMap<String, String>();
		Iterator<ReportableListObject> itr = result.iterator();
		while (itr.hasNext()) {
			ReportableListObject row = itr.next();
			String fsFileIndex = row.getFields0();
			String fsSeq = row.getFields1();
			maps.put(fsFileIndex, fsSeq);
		}
		return maps;
	}
	*/
	
	public static boolean revertApprove(UserBean userBean, String fsFileIndexId) {
		return UtilDBWeb.updateQueueCIS(
				sqlStr_revertApprove, new String[]{userBean.getLoginID(), fsFileIndexId});
	}
	
	public static String getLastApprDateByPat(String patno) {
		List result = UtilDBWeb.getReportableListCIS(
				sqlStr_getLastApprDateByPat.toString(), new String[]{patno});
		if (!result.isEmpty()) {
			ReportableListObject row = (ReportableListObject) result.get(0);
			return row.getValue(0);
		}
		return null;
	}
	
	public static List<String> getImportDatesByPat(String patno) {
		List<String> importDates = new ArrayList<String>();
		List results = UtilDBWeb.getReportableListCIS(
				sqlStr_getImportDatesByPat.toString(), new String[]{patno});
		for (int i = 0; i < results.size(); i++) {
			ReportableListObject rlo = (ReportableListObject) results.get(i);
			importDates.add(rlo.getValue(0));
		}
		return importDates;
	}
	
	public static Set<String> getPatMergeByFmPatno(String fmPatno) {
		return getPatMergeByPatno(fmPatno, true, false);
	}
	
	public static Set<String> getPatMergeByToPatno(String toPatno) {
		return getPatMergeByPatno(toPatno, false, true);
	}
	
	public static Set<String> getPatMergeByPatno(String patno, boolean isByFmPatno, boolean isByToPatno) {
		String sqlStr = null;
		if (isByFmPatno) {
			sqlStr = sqlStr_getPatMergeByFmPatno;
		} else if (isByToPatno) {
			sqlStr = sqlStr_getPatMergeByToPatno;
		}
			
		List results = UtilDBWeb.getReportableListCIS(
				sqlStr.toString(), new String[]{patno});
		Set<String> mergePatnos = new HashSet<String>();
		for (int i = 0; i < results.size(); i++) {
			ReportableListObject rlo = (ReportableListObject) results.get(i);
			if (isByFmPatno) {
				mergePatnos.add(rlo.getValue(1));
			} else {
				mergePatnos.add(rlo.getValue(0));
			}
		}
		return mergePatnos;
	}
	
	public static ArrayList getFilePathsByIds(String[] fsFileIndexId) {
		if (fsFileIndexId == null || fsFileIndexId.length == 0) {
			return null;
		}
		
		String[] tempFsFileIndexId = new String[(int)Math.ceil(fsFileIndexId.length/1000.0)];
		
		for(int i=0;i<tempFsFileIndexId.length;i++){
			tempFsFileIndexId[i] = StringUtils.join(Arrays.copyOfRange(fsFileIndexId,(i*1000),(((fsFileIndexId.length)<(((i+1)*1000)))?(fsFileIndexId.length):(((i+1)*1000))) ), ",");
		}
		
		StringBuffer sqlStr = new StringBuffer();
		//sqlStr.append("SELECT	FS_FILE_PATH ");
		
		sqlStr.append("SELECT  ");
		//sqlStr.append("  I.FS_PATNO,  ");
		sqlStr.append("  I.FS_FILE_PATH, ");
		sqlStr.append("  CASE WHEN P.FS_CATEGORY_ID IN  ");
		
		if (ConstantsServerSide.isHKAH()) {
			sqlStr.append("  ( ");
			// IP
			sqlStr.append("    SELECT FS_CATEGORY_ID ");
			sqlStr.append("    FROM FS_CATEGORY ");
			sqlStr.append("   START WITH FS_CATEGORY_ID = 1 ");
			sqlStr.append("  CONNECT BY PRIOR FS_CATEGORY_ID = FS_PARENT_CATEGORY_ID ");
			sqlStr.append("  ) THEN ");
			sqlStr.append("      'Inpatient/' || 'Admission ' || TO_CHAR(I.FS_ADM_DATE, 'YYYY-MM-DD') ||  ");
			sqlStr.append("      CASE WHEN I.FS_ADM_DATE = I.FS_DISCHARGE_DATE OR I.FS_DISCHARGE_DATE IS NULL  ");
			sqlStr.append("        THEN '' ELSE ' to ' || TO_CHAR(I.FS_DISCHARGE_DATE, 'YYYY-MM-DD')  ");
			sqlStr.append("      END || '/'");
			sqlStr.append("  ELSE ");
			sqlStr.append("    CASE WHEN  ");
			sqlStr.append("    P.FS_CATEGORY_ID IN  ");
			sqlStr.append("    ( ");
			// OP
			sqlStr.append("      SELECT FS_CATEGORY_ID ");
			sqlStr.append("      FROM FS_CATEGORY ");
			sqlStr.append("     START WITH FS_CATEGORY_ID = 5 ");
			sqlStr.append("    CONNECT BY PRIOR FS_CATEGORY_ID = FS_PARENT_CATEGORY_ID ");
			sqlStr.append("    ) THEN 'Outpatient/' ELSE ");
			sqlStr.append("        CASE WHEN  ");
			sqlStr.append("        P.FS_CATEGORY_ID IN  ");
			sqlStr.append("        ( ");
			// DI
			sqlStr.append("          SELECT FS_CATEGORY_ID ");
			sqlStr.append("          FROM FS_CATEGORY ");
			sqlStr.append("         START WITH FS_CATEGORY_ID = 20 ");
			sqlStr.append("        CONNECT BY PRIOR FS_CATEGORY_ID = FS_PARENT_CATEGORY_ID ");
			sqlStr.append("        ) THEN 'DI reports/' ELSE ");
			sqlStr.append("          CASE WHEN  ");
			sqlStr.append("          P.FS_CATEGORY_ID IN  ");
			sqlStr.append("          ( ");
			// Lab
			sqlStr.append("            SELECT FS_CATEGORY_ID ");
			sqlStr.append("            FROM FS_CATEGORY ");
			sqlStr.append("           START WITH FS_CATEGORY_ID = 19 ");
			sqlStr.append("          CONNECT BY PRIOR FS_CATEGORY_ID = FS_PARENT_CATEGORY_ID ");
			sqlStr.append("          ) THEN 'Lab reports/' ELSE 'Miscellaneous/' END ");
			sqlStr.append("        END ");
			sqlStr.append("      END ");
		} else if (ConstantsServerSide.isTWAH()) {
			sqlStr.append("  ( ");
			sqlStr.append("    SELECT FS_CATEGORY_ID ");
			sqlStr.append("    FROM FS_CATEGORY ");
			sqlStr.append("   START WITH FS_CATEGORY_ID = 1 ");
			sqlStr.append("  CONNECT BY PRIOR FS_CATEGORY_ID = FS_PARENT_CATEGORY_ID ");
			sqlStr.append("  ) THEN 'General/' ELSE  ");
			sqlStr.append("    CASE WHEN  ");
			sqlStr.append("    P.FS_CATEGORY_ID IN  ");
			sqlStr.append("    ( ");
			sqlStr.append("      SELECT FS_CATEGORY_ID ");
			sqlStr.append("      FROM FS_CATEGORY ");
			sqlStr.append("     START WITH FS_CATEGORY_ID = 2 ");
			sqlStr.append("    CONNECT BY PRIOR FS_CATEGORY_ID = FS_PARENT_CATEGORY_ID ");
			sqlStr.append("    ) THEN 'Out-patient/' ELSE ");
			sqlStr.append("        CASE WHEN  ");
			sqlStr.append("        P.FS_CATEGORY_ID IN  ");
			sqlStr.append("        ( ");
			sqlStr.append("          SELECT FS_CATEGORY_ID ");
			sqlStr.append("          FROM FS_CATEGORY ");
			sqlStr.append("         START WITH FS_CATEGORY_ID = 3 ");
			sqlStr.append("        CONNECT BY PRIOR FS_CATEGORY_ID = FS_PARENT_CATEGORY_ID ");
			sqlStr.append("        ) THEN 'Lab or Pathology/' ELSE ");
			sqlStr.append("          CASE WHEN  ");
			sqlStr.append("          P.FS_CATEGORY_ID IN  ");
			sqlStr.append("          ( ");
			sqlStr.append("            SELECT FS_CATEGORY_ID ");
			sqlStr.append("            FROM FS_CATEGORY ");
			sqlStr.append("           START WITH FS_CATEGORY_ID = 4 ");
			sqlStr.append("          CONNECT BY PRIOR FS_CATEGORY_ID = FS_PARENT_CATEGORY_ID ");
			sqlStr.append("          ) THEN 'DI/' ELSE  ");
			sqlStr.append("            CASE WHEN  ");
			sqlStr.append("            P.FS_CATEGORY_ID IN  ");
			sqlStr.append("            ( ");
			sqlStr.append("              SELECT FS_CATEGORY_ID ");
			sqlStr.append("              FROM FS_CATEGORY ");
			sqlStr.append("             START WITH FS_CATEGORY_ID = 5 ");
			sqlStr.append("            CONNECT BY PRIOR FS_CATEGORY_ID = FS_PARENT_CATEGORY_ID ");
			sqlStr.append("  		   ) THEN ");
			sqlStr.append("              'IP or Day Case or Clinical/' || 'Admission ' || TO_CHAR(I.FS_ADM_DATE, 'YYYY-MM-DD') ||  ");
			sqlStr.append("               CASE WHEN I.FS_ADM_DATE = I.FS_DISCHARGE_DATE OR I.FS_DISCHARGE_DATE IS NULL  ");
			sqlStr.append("                 THEN '' ELSE ' to ' || TO_CHAR(I.FS_DISCHARGE_DATE, 'YYYY-MM-DD')  ");
			sqlStr.append("               END || '/'");
			sqlStr.append("            ELSE ");
			sqlStr.append("              CASE WHEN  ");
			sqlStr.append("              P.FS_CATEGORY_ID IN  ");
			sqlStr.append("              ( ");
			sqlStr.append("                SELECT FS_CATEGORY_ID ");
			sqlStr.append("                FROM FS_CATEGORY ");
			sqlStr.append("               START WITH FS_CATEGORY_ID = 6 ");
			sqlStr.append("              CONNECT BY PRIOR FS_CATEGORY_ID = FS_PARENT_CATEGORY_ID ");
			sqlStr.append("              ) THEN 'Oncology/' ELSE ");
			sqlStr.append("               CASE WHEN  ");
			sqlStr.append("                P.FS_CATEGORY_ID IN  ");
			sqlStr.append("                ( ");
			sqlStr.append("                  SELECT FS_CATEGORY_ID ");
			sqlStr.append("                  FROM FS_CATEGORY ");
			sqlStr.append("                 START WITH FS_CATEGORY_ID = 20 ");
			sqlStr.append("                CONNECT BY PRIOR FS_CATEGORY_ID = FS_PARENT_CATEGORY_ID ");
			sqlStr.append("                ) THEN 'Corresp. & Misc./' ELSE ");
			sqlStr.append("                 CASE WHEN  ");
			sqlStr.append("                  P.FS_CATEGORY_ID IN  ");
			sqlStr.append("                  ( ");
			sqlStr.append("                    SELECT FS_CATEGORY_ID ");
			sqlStr.append("                    FROM FS_CATEGORY ");
			sqlStr.append("                   START WITH FS_CATEGORY_ID = 21 ");
			sqlStr.append("                  CONNECT BY PRIOR FS_CATEGORY_ID = FS_PARENT_CATEGORY_ID ");
			sqlStr.append("                  ) THEN 'Archive (before 2009)/' ELSE ");
			sqlStr.append("                   CASE WHEN  ");
			sqlStr.append("                    P.FS_CATEGORY_ID IN  ");
			sqlStr.append("                    ( ");
			sqlStr.append("                      SELECT FS_CATEGORY_ID ");
			sqlStr.append("                      FROM FS_CATEGORY ");
			sqlStr.append("                     START WITH FS_CATEGORY_ID = 22 ");
			sqlStr.append("                    CONNECT BY PRIOR FS_CATEGORY_ID = FS_PARENT_CATEGORY_ID ");
			sqlStr.append("                    ) THEN 'Other/' ELSE ");
			sqlStr.append("                  'Other/' END ");
			sqlStr.append("                END ");
			sqlStr.append("              END ");
			sqlStr.append("            END ");
			sqlStr.append("          END ");
			sqlStr.append("        END ");
			sqlStr.append("      END ");
			sqlStr.append("    END ");
		} else {
			sqlStr.append("  CASE WHEN P.FS_CATEGORY_ID IS NULL THEN '' ELSE '' ");
		}
		sqlStr.append("  END \"Folder\" ");
		
		//sqlStr.append("FROM 	FS_FILE_INDEX ");
		
		sqlStr.append("FROM  ");
		sqlStr.append("  FS_FILE_INDEX I  ");
		sqlStr.append("  JOIN FS_FILE_PROFILE P ON I.FS_FILE_INDEX_ID = P.FS_FILE_INDEX_ID ");
		
		for(int j=0;j<tempFsFileIndexId.length;j++){
		   if(j==0){	
			   sqlStr.append("WHERE ");
			   sqlStr.append("(I.FS_FILE_INDEX_ID IN (" + tempFsFileIndexId[j] + ") ");
		   }else{
			   sqlStr.append("OR  	I.FS_FILE_INDEX_ID IN (" + tempFsFileIndexId[j] + ") ");
		   }
		}
		if (tempFsFileIndexId.length > 0) {
			sqlStr.append(") ");
		}
		sqlStr.append("ORDER BY I.FS_FILE_PATH");
		
		//System.out.println("DEBUG: getFilePathsByIds sql="+sqlStr.toString());
		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}
	
	public static ArrayList getNotApproveCount(String[] fsFileIndexId) {
		if (fsFileIndexId == null || fsFileIndexId.length == 0) {
			return null;
		}
		
		String[] splitFsFileIndexId = fsFileIndexId[0].split(",");
		String[] tempFsFileIndexId = new String[(int)Math.ceil(splitFsFileIndexId.length/1000.0)];
		
		for(int i=0;i<tempFsFileIndexId.length;i++){
			tempFsFileIndexId[i] = StringUtils.join(Arrays.copyOfRange(splitFsFileIndexId,(i*1000),(((splitFsFileIndexId.length)<(((i+1)*1000)))?(splitFsFileIndexId.length):(((i+1)*1000))) ), ",");
		}
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT	FS_PATNO, COUNT(1) ");
		sqlStr.append("FROM 	FS_FILE_INDEX ");
		sqlStr.append("WHERE		FS_ENABLED >= 1 ");
		sqlStr.append("AND		FS_APPROVED_DATE IS NULL AND FS_APPROVED_USER IS NULL ");
		sqlStr.append("AND 		FS_PATNO IN ( ");
		sqlStr.append("	SELECT	FS_PATNO ");
		sqlStr.append("	FROM	FS_FILE_INDEX ");
		for(int j=0;j<tempFsFileIndexId.length;j++){
		   if(j==0){	
			 sqlStr.append("WHERE  	(FS_FILE_INDEX_ID IN (" + tempFsFileIndexId[j] + ") ");
		   }else{
			 sqlStr.append("OR  	FS_FILE_INDEX_ID IN (" + tempFsFileIndexId[j] + ") ");
		   }
		}
		if (tempFsFileIndexId.length > 0) {
			sqlStr.append(")");
		}
		sqlStr.append("	)");
		sqlStr.append("GROUP BY FS_PATNO ");
		sqlStr.append("ORDER BY FS_PATNO ");
		
		//System.out.println("DEBUG: getNotApproveCount sql="+sqlStr.toString());
		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}
	
	public static ArrayList getPrevApprovedHIS(List<String> labnum) {
		if (labnum == null || labnum.isEmpty()) {
			return null;
		}
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT	FS_LAB_NUM, FS_PATNO ");
		sqlStr.append("FROM 	FS_FILE_INDEX ");
		sqlStr.append("WHERE	FS_ENABLED > 0 ");
		sqlStr.append("AND		FS_APPROVED_DATE IS NOT NULL AND FS_APPROVED_USER IS NOT NULL ");
		sqlStr.append("AND 		FS_LAB_NUM IN ('");
		sqlStr.append(StringUtils.join(labnum, "','"));
		sqlStr.append("') ");
		sqlStr.append("GROUP BY FS_LAB_NUM, FS_PATNO ");
		sqlStr.append("ORDER BY FS_LAB_NUM, FS_PATNO ");
		
		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}
	
	public static ArrayList getFileIndexDetails(String[] fsFileIndexId) {
		if (fsFileIndexId == null || fsFileIndexId.length == 0) {
			return null;
		}
		
		String[] splitFsFileIndexId = fsFileIndexId[0].split(",");	
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT    I.FS_FILE_INDEX_ID, I.FS_PATNO, P.FS_CATEGORY_ID, I.FS_FILE_PATH, P.FS_FORM_CODE, I.FS_PATTYPE, ");
		sqlStr.append("			 TO_CHAR(I.FS_ADM_DATE, 'DD/MM/YYYY HH24:MI:SS'), TO_CHAR(I.FS_DISCHARGE_DATE, 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("from FS_FILE_INDEX I ");
		sqlStr.append("	JOIN FS_FILE_PROFILE P on I.FS_FILE_INDEX_ID = P.FS_FILE_INDEX_ID ");
		sqlStr.append("	JOIN FS_IMPORT_LOG L on I.FS_FILE_INDEX_ID = L.FS_FILE_INDEX_ID ");
		sqlStr.append("WHERE     1=1 ");
		if (splitFsFileIndexId.length > 0){
			sqlStr.append("AND (");
			for(int i = 0; i < splitFsFileIndexId.length; i++){
				if( i == 0){
					sqlStr.append("I.FS_FILE_INDEX_ID = '" + splitFsFileIndexId[i] + "'");
				} else {
					sqlStr.append("OR I.FS_FILE_INDEX_ID = '" + splitFsFileIndexId[i] + "'");
				}
			}
			sqlStr.append(" ) ");
		} else {
			return null;
		}		
		 if (ConstantsServerSide.isHKAH()) {
			sqlStr.append(SQL_ORDER_BY_HKAH);
		} else {
			sqlStr.append(SQL_ORDER_BY_TWAH);		
		}
		//System.out.println(sqlStr.toString());		
		
		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}
	
	public static List getListOfFsFiles(String patNo) {	
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT  FS_FILE_INDEX_ID ");
		sqlStr.append("FROM    FS_FILE_INDEX ");
		sqlStr.append("WHERE   FS_PATNO = '" + patNo + "' ");
		sqlStr.append("AND	   FS_APPROVED_DATE IS NOT NULL "); 
		sqlStr.append("AND     FS_APPROVED_USER IS NOT NULL ");
		sqlStr.append("AND     FS_ENABLED = '1' ");

		List result = UtilDBWeb.getReportableListCIS(sqlStr.toString());
		return result;
	}
	
	public static List getListOfFsFiles(String patno, String formCode) {	
		List<String> params = new ArrayList<String>();
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT  I.FS_FILE_INDEX_ID ");
		sqlStr.append("FROM    FS_FILE_INDEX I JOIN FS_FILE_PROFILE P ON I.FS_FILE_INDEX_ID = P.FS_FILE_INDEX_ID ");
		sqlStr.append("WHERE   I.FS_ENABLED = '1' ");
		if(patno != null && !patno.isEmpty()){
			sqlStr.append("AND  I.FS_PATNO = ? ");
			params.add(patno);
		}
		if(formCode != null && !formCode.isEmpty()){
			sqlStr.append("AND  P.FS_FORM_CODE = ? ");
			params.add(formCode);
		}
		if (params.isEmpty()) {
			sqlStr.append("AND  1 = 2 ");
		}
		sqlStr.append("AND	   I.FS_APPROVED_DATE IS NOT NULL "); 
		sqlStr.append("AND     I.FS_APPROVED_USER IS NOT NULL ");

		String[] paramsArray = params.toArray(new String[]{});
		List result = UtilDBWeb.getReportableListCIS(sqlStr.toString(), paramsArray);
		return result;
	}
	
	public static List getListOfFsFilesByIds(String[] fsFileIndexIds) {	
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT  FS_FILE_INDEX_ID ");
		sqlStr.append("FROM    FS_FILE_INDEX ");
		sqlStr.append("WHERE   FS_PATNO IN (SELECT FS_PATNO FROM FS_FILE_INDEX WHERE FS_FILE_INDEX_ID IN (" + StringUtils.join(fsFileIndexIds, ",") + ")) ");
		sqlStr.append("AND	   FS_APPROVED_DATE IS NOT NULL "); 
		sqlStr.append("AND     FS_APPROVED_USER IS NOT NULL ");
		sqlStr.append("AND     FS_ENABLED = '1' ");

		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}
	
	public static List<ReportableListObject> getAdmInfoByRegId(String regId) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select 	r.patno, r.regid, to_char(r.regdate, 'dd/mm/yyyy'), to_char(inp.inpddate, 'dd/mm/yyyy') ");
		sqlStr.append("from 	reg@iweb r left join inpat@iweb inp on r.inpid = inp.inpid ");
		sqlStr.append("WHERE	r.REGID = ? and r.regsts = 'N' ");
		return UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{regId});
	}
	
	public static ArrayList loadSysParam() {
		return UtilDBWeb.getReportableListCIS(sqlStr_loadSysParam.toString());
	}
	
	public static List<ReportableListObject> getInpDischargeList(String inpDischargeDateFrom, String inpDischargeDateTo, String importStatus, String approveStatus) {
		String sqlStr_getInpDischargeList = null;
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select  ");
		sqlStr.append("	inpddate, patno, patfname, patgname, regid, import_dates, approved_dates, ");
		sqlStr.append("	LISTAGG(vol_loc, ';') WITHIN GROUP (ORDER BY vol_loc) vol_locs ");
		sqlStr.append("from (  ");
		
		sqlStr.append("select  ");
		sqlStr.append("  to_char(a.inpddate, 'dd/mm/yyyy hh24:mi:ss') INPDDATE, a.patno, a.patfname, a.patgname, a.regid, b.vol_loc ");
		sqlStr.append("  , listagg(to_char(a.fs_import_date, 'dd/mm/yyyy hh24:mi:ss'),';') within group( order by a.fs_import_date desc) import_dates ");
		sqlStr.append("  , listagg(to_char(a.fs_approved_date, 'dd/mm/yyyy hh24:mi:ss'),';') within group( order by a.fs_import_date desc) approved_dates ");
		sqlStr.append("from ( ");
		sqlStr.append("  select  ");
		sqlStr.append("    r.patno, p.patfname, p.patgname, r.regid, ");
		sqlStr.append("    inp.inpddate, ");
		sqlStr.append("    i.fs_import_date, i.fs_approved_date ");
		sqlStr.append("  from reg@hat r join inpat@hat inp on r.inpid = inp.inpid ");
		sqlStr.append("  left join patient@hat p on r.patno = p.patno ");
		sqlStr.append("  left join  ");
		sqlStr.append("  ( ");
		sqlStr.append("    select distinct fs_patno, fs_regid, fs_import_date, fs_approved_date ");
		sqlStr.append("    from fs_file_index  ");
		sqlStr.append("    where fs_enabled > 0 ");
		sqlStr.append("  ) i on r.patno = i.fs_patno and r.regid = i.fs_regid ");
		sqlStr.append("  where 1=1 ");
		//sqlStr.append("  --inp.inpddate between trunc(sysdate) - 11 and trunc(sysdate) - 10 ");
		if (inpDischargeDateFrom != null && !inpDischargeDateFrom.isEmpty()) {
			sqlStr.append(" and inp.inpddate >= to_date('" + inpDischargeDateFrom + " 00:00:00', 'dd/mm/yyyy hh24:mi:ss') ");
		}
		if (inpDischargeDateTo != null && !inpDischargeDateTo.isEmpty()) {
			sqlStr.append(" and inp.inpddate < to_date('" + inpDischargeDateTo + " 00:00:00', 'dd/mm/yyyy hh24:mi:ss') + 1 ");
		}
		//sqlStr.append("  inp.inpddate between to_date('" + inpDischargeDateFrom + " 00:00:00', 'dd/mm/yyyy hh24:mi:ss') and to_date('" + inpDischargeDateTo + " 00:00:00', 'dd/mm/yyyy hh24:mi:ss') + 1 ");
		sqlStr.append("  and regsts = 'N' ");
		sqlStr.append(") a ");
		sqlStr.append("left join  ");
		sqlStr.append("( ");
		sqlStr.append("	SELECT ");
		sqlStr.append("	H.PATNO, ");
		sqlStr.append("	'(' || H.MRHVOLLAB || ') ' || DECODE(D.MRLID_R, NULL, L1.MRLDESC,L2.MRLDESC) vol_loc ");
		sqlStr.append("	FROM MEDRECHDR@hat H, MEDRECDTL@hat D, ");
		sqlStr.append("	MEDRECLOC@hat L1,MEDRECLOC@hat L2 ");
		sqlStr.append("	WHERE H.MRDID = D.MRDID ");
		sqlStr.append("	AND D.MRLID_L = L1.MRLID(+) ");
		sqlStr.append("	AND D.MRLID_R = L2.MRLID(+) ");
		sqlStr.append("	AND H.MRHSTS <> 'P' ");
		sqlStr.append(") b on a.patno = b.patno ");
		sqlStr.append("group by  ");
		sqlStr.append("  a.patno, a.patfname, a.patgname, a.regid, a.inpddate, b.vol_loc ");
		sqlStr.append("having 1=1 ");
		if ("Y".equals(importStatus) || "N".equals(importStatus)) {
			sqlStr.append(" and listagg(to_char(a.fs_import_date, 'dd/mm/yyyy hh24:mi:ss'),';') within group( order by a.fs_import_date desc) is" + ("Y".equals(importStatus) ? " not" : "") + " null ");
		}
		if ("Y".equals(approveStatus) || "N".equals(approveStatus)) {
			sqlStr.append(" and listagg(to_char(a.fs_approved_date, 'dd/mm/yyyy hh24:mi:ss'),';') within group( order by a.fs_import_date desc) is" + ("Y".equals(approveStatus) ? " not" : "") + " null ");
		}
		
		sqlStr.append(") ");
		sqlStr.append("group by inpddate, patno, patfname, patgname, regid, import_dates, approved_dates ");
		sqlStr.append("order by inpddate ");
		sqlStr_getInpDischargeList = sqlStr.toString();
		
		//System.out.println("DEBUG getInpDischargeList sql=" + sqlStr_getInpDischargeList.toString());
		
		return UtilDBWeb.getReportableListCIS(sqlStr_getInpDischargeList.toString());
	}

	// ===================

	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT FS_CATEGORY_ID, FS_NAME, FS_PARENT_CATEGORY_ID, FS_SEQ, FS_IS_MULTI ");
		sqlStr.append("FROM   FS_CATEGORY ");
		sqlStr.append("ORDER BY FS_SEQ, FS_CATEGORY_ID");
		sqlStr_categoryList = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT FS_CATEGORY_ID, FS_NAME, FS_PARENT_CATEGORY_ID, FS_SEQ, FS_IS_MULTI ");
		sqlStr.append("FROM   FS_CATEGORY ");
		sqlStr.append("WHERE  FS_CATEGORY_ID = ? ");
		sqlStr_category = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT ");
		sqlStr.append("  R.REGID ");
		sqlStr.append("  , S.SDSCODE "); 
		sqlStr.append("  , S.SDSDESC "); 
		sqlStr.append("  , n.SRSNCODE "); 
		sqlStr.append("  , n.SRSNDESC "); 
		sqlStr.append("FROM REG@iweb R ");
		sqlStr.append("  INNER JOIN INPAT@iweb I ");
		sqlStr.append("   ON R.INPID = I.INPID ");
		sqlStr.append("  LEFT JOIN SDISEASE@iweb S ");
		sqlStr.append("    ON I.SDSCODE = S.SDSCODE ");
		sqlStr.append("  left join sreason@iweb n ");
		sqlStr.append("    on i.rsncode = N.srsncode ");
		sqlStr.append("where R.REGID = ? ");
		sqlStr.append("UNION ");
		sqlStr.append("SELECT ");
		sqlStr.append("  R.REGID ");
		sqlStr.append("  , S.SDSCODE ");  
		sqlStr.append("  , S.SDSDESC ");
		sqlStr.append("  , n.SRSNCODE "); 
		sqlStr.append("  , n.SRSNDESC "); 
		sqlStr.append("FROM reg@iweb r ");
		sqlStr.append("  inner join DAYPAT@iweb D ");
		sqlStr.append("   ON R.DAYPID = D.DAYPID ");
		sqlStr.append("  LEFT JOIN SDISEASE@iweb S ");
		sqlStr.append("    on d.sdscode = s.sdscode ");
		sqlStr.append("  left join sreason@iweb n ");
		sqlStr.append("    on d.rsncode = N.srsncode ");
		sqlStr.append("where R.REGID = ? ");
		sqlStr_getIcdName = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT FS_FORM_ID, FS_FORM_CODE, FS_FORM_NAME, FS_PATTYPE ");
		sqlStr.append("FROM   FS_FORM ");
		sqlStr.append("WHERE  FS_CATEGORY_ID = ? ");
		sqlStr.append("AND  FS_IS_DEFAULT = 'Y' ");
		sqlStr.append("ORDER BY  FS_SEQ, FS_FORM_ID ");
		sqlStr_getDefaultFormCodesByCategoryID = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE FS_FILE_INDEX SET FS_ENABLED = 0, FS_MODIFIED_DATE = sysdate, FS_MODIFIED_USER = ? WHERE FS_FILE_INDEX_ID = ?");
		sqlStr_deleteFsFileIndex = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE FS_FILE_PROFILE SET FS_ENABLED = 0, FS_MODIFIED_DATE = sysdate, FS_MODIFIED_USER = ? WHERE FS_FILE_INDEX_ID = ?");
		sqlStr_deleteFsFileProfile = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE FS_FILE_INDEX SET FS_ENABLED = 2, FS_MODIFIED_DATE = sysdate, FS_MODIFIED_USER = ? WHERE FS_FILE_INDEX_ID in (#1)");
		sqlStr_deprecateFsFileIndexes = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("DELETE FROM FS_FILE_INDEX WHERE FS_FILE_INDEX_ID = ?");
		sqlStr_actualDeleteFsFileIndex = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("DELETE FROM FS_CATEGORY WHERE FS_CATEGORY_ID = ?");
		sqlStr_actualDeleteFsCategory = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("DELETE FROM FS_FORM WHERE FS_FORM_ID = ?");
		sqlStr_deleteFsForm = sqlStr.toString();
	
		sqlStr.setLength(0);
		sqlStr.append("DELETE FROM FS_FORM_ALIAS WHERE FS_FORM_ALIAS_ID = ?");
		sqlStr_deleteFsFormAlias = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE FS_FILE_INDEX SET FS_APPROVED_USER = null, FS_APPROVED_DATE = null, ");
		sqlStr.append(" FS_MODIFIED_USER = ?, FS_MODIFIED_DATE = sysdate WHERE FS_FILE_INDEX_ID = ?");
		sqlStr_revertApprove = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO FS_FILE_INDEX ");
		sqlStr.append("(FS_FILE_INDEX_ID, FS_PATNO, FS_REGID, ");
		sqlStr.append(" FS_DUE_DATE, FS_ADM_DATE, FS_DISCHARGE_DATE, FS_IMPORT_DATE, ");
		sqlStr.append(" FS_FORM_NAME, FS_FILE_PATH, FS_PATTYPE, FS_SEQ, FS_LAB_NUM, ");
		sqlStr.append(" FS_CREATED_USER, FS_MODIFIED_USER, FS_APPROVED_USER, FS_APPROVED_DATE)");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ");
		sqlStr.append("TO_DATE(?, 'DD/MM/YYYY'), TO_DATE(?, 'DD/MM/YYYY'), TO_DATE(?, 'DD/MM/YYYY'), TO_DATE(?, 'DD/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("?, ?, ?, ?, ?, ");
		sqlStr.append("?, ?, ?, TO_DATE(?, 'DD/MM/YYYY HH24:MI:SS'))");
		sqlStr_addFsFileIndex = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO FS_FILE_PROFILE ");
		sqlStr.append("(FS_FILE_PROFILE_ID, FS_FILE_INDEX_ID, ");
		sqlStr.append(" FS_ICD_CODE, FS_ICD_NAME, FS_CATEGORY_ID, FS_FORM_CODE, ");
		sqlStr.append(" FS_STNID, FS_RIS_ACCESSION_NO, FS_KEY, ");
		sqlStr.append(" FS_CREATED_USER, FS_MODIFIED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ");
		sqlStr.append("?, ?, ?, ?, ");
		sqlStr.append("?, ?, ?, ");
		sqlStr.append("?, ?)");
		sqlStr_addFsFileProfile = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO FS_CATEGORY ");
		sqlStr.append("(FS_CATEGORY_ID, FS_NAME, ");
		sqlStr.append(" FS_PARENT_CATEGORY_ID, FS_SEQ, FS_IS_MULTI) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ");
		sqlStr.append("?, ?, ?)");
		sqlStr_addFsCategory = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO FS_FORM ");
		sqlStr.append("(FS_FORM_ID, FS_FORM_CODE, FS_FORM_NAME, ");
		sqlStr.append(" FS_CATEGORY_ID, FS_SECTION, FS_SEQ, FS_PATTYPE, FS_IS_DEFAULT) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?, ");
		sqlStr.append("?, ?, ?, ?, ?)");
		sqlStr_addFsForm = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO FS_FORM_ALIAS ");
		sqlStr.append("(FS_FORM_ID, FS_FORM_ALIAS_ID, FS_FORM_CODE) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?)");
		sqlStr_addFsFormAlias = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO FS_IMPORT_LOG ");
		sqlStr.append("(FS_IMPORT_LOG_ID, FS_IMPORT_DATE, FS_FILE_INDEX_ID, ");
		sqlStr.append(" FS_BATCH_NO, FS_ENCODED_PARAMS, FS_DESCRIPTION, FS_CREATED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, TO_DATE(?, 'DD/MM/YYYY HH24:MI:SS'), ?, ");
		sqlStr.append("?, ?, ?, ?)");
		sqlStr_addFsImportLog = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO FS_IMPORT_BATCH ");
		sqlStr.append("(FS_BATCH_NO, FS_INDEX_FILE_NAME, FS_CREATED_USER) ");
		sqlStr.append("VALUES ");
		sqlStr.append("(?, ?, ?)");
		sqlStr_addFsImportBatch = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE FS_CATEGORY ");
		sqlStr.append("SET ");
		sqlStr.append("  FS_NAME = ?, ");
		sqlStr.append("  FS_PARENT_CATEGORY_ID = ?, ");
		sqlStr.append("  FS_SEQ = ?, ");
		sqlStr.append("  FS_IS_MULTI = ? ");
		sqlStr.append("WHERE FS_CATEGORY_ID = ? ");
		sqlStr_updateFsCategory = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE FS_FILE_INDEX ");
		sqlStr.append("SET ");
		sqlStr.append("  FS_PATNO = ?, ");
		sqlStr.append("  FS_REGID = ?, ");
		sqlStr.append("  FS_DUE_DATE = TO_DATE(?, 'DD/MM/YYYY'), ");
		sqlStr.append("  FS_ADM_DATE = TO_DATE(?, 'DD/MM/YYYY'), ");
		sqlStr.append("  FS_DISCHARGE_DATE = TO_DATE(?, 'DD/MM/YYYY'), ");
		sqlStr.append("  FS_FORM_NAME = ?, ");
		sqlStr.append("  FS_FILE_PATH = ?, ");
		sqlStr.append("  FS_PATTYPE = ?, ");
		sqlStr.append("  FS_SEQ = ?, ");
		sqlStr.append("  FS_LAB_NUM = ?, ");
		sqlStr.append("  FS_MODIFIED_DATE = sysdate, ");
		sqlStr.append("  FS_MODIFIED_USER = ? ");
		sqlStr.append("WHERE FS_FILE_INDEX_ID = ? ");
		sqlStr_updateFsFileIndex = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE FS_FILE_PROFILE ");
		sqlStr.append("SET ");
		sqlStr.append("  FS_ICD_CODE = ?, ");
		sqlStr.append("  FS_ICD_NAME = ?, ");
		sqlStr.append("  FS_CATEGORY_ID = ?, ");
		sqlStr.append("  FS_FORM_CODE = ?, ");
		sqlStr.append("  FS_STNID = ?, ");
		sqlStr.append("  FS_RIS_ACCESSION_NO = ?, ");
		sqlStr.append("  FS_KEY = ?, ");
		sqlStr.append("  FS_MODIFIED_DATE = sysdate, ");
		sqlStr.append("  FS_MODIFIED_USER = ? ");
		sqlStr.append("WHERE FS_FILE_INDEX_ID = ? ");
		sqlStr_updateFsFileProfile = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE FS_CATEGORY ");
		sqlStr.append("SET ");
		sqlStr.append("  FS_SEQ = ? ");
		sqlStr.append("WHERE FS_CATEGORY_ID = ? ");
		sqlStr_updateFsCategoryOrder = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE FS_FORM ");
		sqlStr.append("SET ");
		sqlStr.append("  FS_FORM_CODE = ?, ");
		sqlStr.append("  FS_FORM_NAME = ?, ");
		sqlStr.append("  FS_CATEGORY_ID = ?, ");
		sqlStr.append("  FS_SECTION = ?, ");
		sqlStr.append("  FS_SEQ = ?, ");
		sqlStr.append("  FS_PATTYPE = ?, ");
		sqlStr.append("  FS_IS_DEFAULT = ? ");
		sqlStr.append("WHERE FS_FORM_ID = ? ");
		sqlStr_updateFsForm = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("UPDATE FS_IMPORT_LOG ");
		sqlStr.append("SET ");
		sqlStr.append("  FS_HANDLED = ?, ");
		sqlStr.append("  FS_HANDLED_DESC = ? ");
		sqlStr.append("WHERE FS_IMPORT_LOG_ID = ? ");
		sqlStr_updateImportLogHandle = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT 	FS_BATCH_NO ");
		sqlStr.append("FROM 	FS_IMPORT_LOG ");
		sqlStr.append("WHERE 	TO_CHAR(FS_IMPORT_DATE, 'DD/MM/YYYY HH24:MI:SS') = ? ");
		sqlStr.append("GROUP BY FS_BATCH_NO ");
		sqlStr.append("ORDER BY FS_BATCH_NO DESC ");
		sqlStr_getBatchNoByImportDate = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT 	1 ");
		sqlStr.append("FROM   	FS_FORM ");
		sqlStr.append("WHERE	FS_FORM_CODE = ? and ");
		sqlStr.append("	(FS_PATTYPE = ? or ( ? is null and fs_is_default = 'Y'))");
		sqlStr_isFormExist = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT 	1 ");
		sqlStr.append("FROM   	FS_FORM ");
		sqlStr.append("WHERE	FS_FORM_CODE = ?");
		sqlStr.append("	UNION ");
		sqlStr.append("SELECT 	1 ");
		sqlStr.append("FROM   	FS_FORM_ALIAS ");
		sqlStr.append("WHERE	FS_FORM_CODE = ?");
		sqlStr_isFormAliasExist = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT 	hospnum ");
		sqlStr.append("FROM 	labo_masthead@lis ");
		sqlStr.append("WHERE 	lab_num = ?");
		sqlStr_getLisHospnumByLabNum = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT 	CMS_UTL_FS_LIVE_REC_COUNT(?, ?) ");
		sqlStr.append("FROM 	dual ");
		sqlStr_getFsLiveRecCount = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT ");
		sqlStr.append("	I.FS_FILE_INDEX_ID, ");
		sqlStr.append("	I.FS_PATNO, ");
		sqlStr.append("	I.FS_REGID, ");
		sqlStr.append("	TO_CHAR(I.FS_DUE_DATE, 'DD/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("	TO_CHAR(I.FS_ADM_DATE, 'DD/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("	TO_CHAR(I.FS_DISCHARGE_DATE, 'DD/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("	I.FS_FORM_NAME, ");
		sqlStr.append("	I.FS_FILE_PATH, ");
		sqlStr.append("	I.FS_PATTYPE, ");
		sqlStr.append("	I.FS_SEQ, ");
		sqlStr.append("	P.FS_FILE_PROFILE_ID, ");
		sqlStr.append("	P.FS_ICD_NAME, ");
		sqlStr.append("	P.FS_CATEGORY_ID, ");
		sqlStr.append("	C.FS_PARENT_CATEGORY_ID, ");
		sqlStr.append("	P.FS_FORM_CODE, ");
		sqlStr.append("	C.FS_IS_MULTI, ");
		sqlStr.append("	P.FS_ICD_CODE, ");
		sqlStr.append("	TO_CHAR(I.FS_IMPORT_DATE, 'DD/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("	TO_CHAR(I.FS_APPROVED_DATE, 'DD/MM/YYYY HH24:MI:SS'), ");
		sqlStr.append("	I.FS_APPROVED_USER, ");
		sqlStr.append("	L.FS_BATCH_NO, ");
		sqlStr.append("	I.FS_LAB_NUM, ");
		sqlStr.append("	P.FS_STNID, ");
		sqlStr.append("	I.FS_ENABLED, ");
		sqlStr.append("	I.FS_CREATED_USER, ");
		sqlStr.append("	P.FS_KEY, ");
		sqlStr.append("	P.FS_RIS_ACCESSION_NO ");
		sqlStr_select_fileIndex = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT ");
		sqlStr.append("	I.Fs_Patno, ");
		sqlStr.append("	Count(Distinct L.Fs_Batch_No) Noofbatch, ");
		sqlStr.append("	Count(Distinct i.Fs_Regid) Noofreg, ");
		sqlStr.append("	Count(1) Nooffileindexall,  ");
		sqlStr.append("	Count(Case When i.Fs_Pattype = 'I' Then 1 End) Nooffileindexip, ");
		sqlStr.append("	Count(Case When i.Fs_Pattype = 'O' Then 1 End) Nooffileindexop, ");
		sqlStr.append("	Count(Case When i.Fs_Pattype = 'D' Then 1 End) Nooffileindexdc, ");
		sqlStr.append("	Count(Case When i.Fs_Pattype Is Null Or i.Fs_Pattype Not In ('I', 'O', 'D') Then 1 End) Nooffileindexother, ");
		sqlStr.append("	Max(to_char(I.Fs_Import_Date, 'dd/MM/yyyy HH24:MI:SS')) Keep (Dense_Rank First Order By I.Fs_Import_Date) Fsfirstimportdate, ");
		sqlStr.append("	Max(to_char(I.Fs_Import_Date, 'dd/MM/yyyy HH24:MI:SS')) Keep (Dense_Rank last Order By I.Fs_Import_Date) FsLatestimportdate ");
		sqlStr_select_fileStat = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT 	TO_CHAR(max(FS_APPROVED_DATE), 'dd MON yyyy HH24:MI:ss', 'NLS_DATE_LANGUAGE=AMERICAN') ");
		sqlStr.append("FROM   	FS_FILE_INDEX ");
		sqlStr.append("WHERE	FS_PATNO = ? AND FS_ENABLED >= 1");
		sqlStr_getLastApprDateByPat = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("Select TO_CHAR(i.Fs_Import_Date, 'dd MON yyyy HH24:MI:ss', 'NLS_DATE_LANGUAGE=AMERICAN') ");
		sqlStr.append("From Fs_File_Index I Left Join Fs_Import_Log L On I.Fs_File_Index_Id = L.Fs_File_Index_Id ");
		sqlStr.append("Where i.Fs_Patno = ? AND i.FS_ENABLED >= 1 AND i.Fs_Import_Date is not null ");
		sqlStr.append("AND (l.fs_description not like '%auto import%' or l.fs_description is null)");
		sqlStr.append("Group By i.Fs_Patno, i.Fs_Import_Date ");
		sqlStr.append("ORDER BY i.Fs_Import_Date desc ");
		sqlStr_getImportDatesByPat = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT ");
		sqlStr.append("	code_type, code_no, code_value1, code_value2, remarks ");
		sqlStr.append("FROM 	AH_SYS_CODE ");
		sqlStr.append("WHERE 	SYS_ID = 'FS'");
		sqlStr.append("ORDER BY code_type, code_no");
		sqlStr_loadSysParam = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT 	FM_PATNO, TO_PATNO ");
		sqlStr.append("FROM 	pat_merge_log ");
		sqlStr.append("WHERE 	table_name = 'FS_FILE_INDEX' ");
		sqlStr.append("AND	 	FM_PATNO = ?");
		sqlStr_getPatMergeByFmPatno = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT 	FM_PATNO, TO_PATNO ");
		sqlStr.append("FROM 	pat_merge_log ");
		sqlStr.append("WHERE 	table_name = 'FS_FILE_INDEX' ");
		sqlStr.append("AND	 	TO_PATNO = ?");
		sqlStr_getPatMergeByToPatno = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("select SEQ_FS_FILE_INDEX_ID.nextval ");
		sqlStr.append("from ( ");
		sqlStr.append("	select level ");
		sqlStr.append("	from dual ");
		sqlStr.append("	connect by level < ? + 1 ");
		sqlStr.append(")");
		sqlStr_getNextFsFileIndexIds = sqlStr.toString();
		
		approveStatusSql.put("", null);	// All
		approveStatusSql.put("A", null);	// All
		approveStatusSql.put("P", " (I.FS_APPROVED_DATE IS NOT NULL AND I.FS_APPROVED_USER IS NOT NULL) ");	// Approved
		approveStatusSql.put("N", " (I.FS_ENABLED >= 1 AND (I.FS_APPROVED_DATE IS NULL AND I.FS_APPROVED_USER IS NULL)) ");	// Not approve
		approveStatusSql.put("I", " (I.FS_ENABLED = 0 OR I.FS_FILE_INDEX_ID IS NULL) ");	// File Invalid
		approveStatusSql.put("H", " (I.FS_ENABLED = 2) ");	// Admin only, not show in LIVE mode
	}
}
