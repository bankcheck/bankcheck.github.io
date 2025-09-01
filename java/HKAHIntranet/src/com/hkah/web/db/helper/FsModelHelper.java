package com.hkah.web.db.helper;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.math.BigDecimal;
import java.net.URLEncoder;
import java.sql.Types;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Random;
import java.util.Set;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.apache.pdfbox.multipdf.PDFMergerUtility;

import au.com.bytecode.opencsv.CSVReader;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.convert.Converter;
import com.hkah.servlet.HKAHInitServlet;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.FileUtil;
import com.hkah.util.ServerUtil;
import com.hkah.util.convert.PdfToImage;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;
import com.hkah.web.db.ForwardScanningDB;
import com.hkah.web.db.model.FsCategory;
import com.hkah.web.db.model.FsCategoryInPat;
import com.hkah.web.db.model.FsCombineFiles;
import com.hkah.web.db.model.FsFileCsv;
import com.hkah.web.db.model.FsFileDetails;
import com.hkah.web.db.model.FsFileIndex;
import com.hkah.web.db.model.FsFileProfile;
import com.hkah.web.db.model.FsFileStat;
import com.hkah.web.db.model.FsForm;
import com.hkah.web.db.model.FsImportBatch;
import com.hkah.web.db.model.FsImportLog;
import com.hkah.web.db.model.FsPatNo;

public class FsModelHelper {
	private static Logger logger = Logger.getLogger(FsModelHelper.class);
	private static FsModelHelper instance = null;
	
	private List<FsFileIndex> fileList = null;
	private List<FsCategory> categoryList = null;
	private List<FsCategory> generalCategoryList = null;
	private Map<BigDecimal, List<FsCategoryInPat>> multiCategoryGrp = null;
	
	public static final String MODULE_CODE = "forwardScanning";
	public static final String MODULE_NAME = "Forward Scanning";
	public static final String MODULE_PATH = "/fs";
	public static final String SYS_CODE_SRC_HOST = "src_host";
	public static final String SYS_CODE_SRC_HOST_SID_DEF = "src_host_sid.default";
	public static final String SYS_CODE_DEST_HOST_PATH = "dest_host_path";
	public static final String FORM_CODE_BLANK = ".";
	public static final String PAT_TYPE_CODE_IP = "I";
	public static final String PAT_TYPE_CODE_OP = "O";
	public static final String PAT_TYPE_CODE_C = "C";
	public static final String PAT_TYPE_CODE_DAYCASE = "D";
	public static final String PAT_TYPE_CODE_MASTER = "M";
	public static Map<String, String> pattypes = new HashMap<String, String>();
	{
		pattypes.put(ConstantsVariable.EMPTY_VALUE, "N/A");
		pattypes.put(PAT_TYPE_CODE_IP, "In-Patient");
		pattypes.put(PAT_TYPE_CODE_OP, "Out-Patient");
		pattypes.put(PAT_TYPE_CODE_C, "C");
		pattypes.put(PAT_TYPE_CODE_DAYCASE, "Day Case");
		pattypes.put(PAT_TYPE_CODE_MASTER, "Master");
	}
	
	public static final String FORMAT_DISPLAY_DATE_MIDDLE_ENDIAN_SHORT = "MMM d, yyyy";
	public static final SimpleDateFormat displayDateFormatMiddleEndianShort = new SimpleDateFormat(FORMAT_DISPLAY_DATE_MIDDLE_ENDIAN_SHORT, Locale.US);
	
	public static final String MODULE_UPLOAD_SUBPATH = 
			File.separator + MODULE_NAME +
			File.separator + "Import";
	public static final String MODULE_UPLOAD_SUBPATH_TEMP = MODULE_UPLOAD_SUBPATH + File.separator + "Temp";
	public static final String MODULE_UPLOAD_PATH = ConstantsServerSide.UPLOAD_WEB_FOLDER + MODULE_UPLOAD_SUBPATH;
	public static final String MODULE_UPLOAD_PATH_TEMP = MODULE_UPLOAD_PATH + File.separator + "Temp";
	public static String COMBINE_FILE_STORE_PATH = "";
	
	public static final BigDecimal TWAH_DI_CAT_ID = new BigDecimal(4);
	public static final BigDecimal TWAH_MISC_CAT_ID = new BigDecimal(20);
	public static final BigDecimal TWAH_IP_CAT_ID = new BigDecimal(5);
	public static final BigDecimal TWAH_OP_CAT_ID = new BigDecimal(2);
	public static final BigDecimal HKAH_MISC_CAT_ID = new BigDecimal(24);
	public static final BigDecimal HKAH_IP_CAT_ID = new BigDecimal(1);
	public static final BigDecimal HKAH_OP_CAT_ID = new BigDecimal(5);
	public static final BigDecimal HKAH_OP_CONS_TREAT_CAT_ID = new BigDecimal(16);
	public static final String HKAH_OP_CONS_TREAT_GRP_CODE = "OP_CONS_TREAT";
	public static final BigDecimal HKAH_RPT_LP_CAT_ID = new BigDecimal(19);
	public static final String HKAH_RPT_LP_GRP_CODE = "RPT_LP";
	public static final BigDecimal HKAH_RPT_DI_CAT_ID = new BigDecimal(20);
	public static final BigDecimal HKAH_LABPATH_CAT_ID = new BigDecimal(19);
	public static final BigDecimal HKAH_IP_MISC_CAT_ID = new BigDecimal(13);
	public static final String HKAH_IP_MISC_FORM_CODE = "MISC";
	public static final BigDecimal HKAH_OP_MISC_CAT_ID = new BigDecimal(18);
	public static final String HKAH_OP_MISC_GRP_CODE = "OP_MISC";
	public static final BigDecimal HKAH_UNKNOWN_CAT_ID = new BigDecimal(99);
	public static final BigDecimal HKAH_ONCOLOGY_CAT_ID = new BigDecimal(101);
	public static final String HKAH_ONCOLOGY_FORM_CODE = "ONCOLOGY";
	public static final String HKAH_ONCOLOGY_GRP_CODE = "ONCOL";
	public static final String HKAH_HIS_FORM_CODE = "HIS";
	public static final BigDecimal HKAH_HIS_CAT_ID = new BigDecimal(103);
	public static final BigDecimal TWAH_HIS_CAT_ID = new BigDecimal(23);
	public static final BigDecimal HKAH_IP_MISC_GRP_CODE = new BigDecimal(13);
	public static final BigDecimal HKAH_OP_MISC_TRIAGE_CAT_ID = new BigDecimal(108);
	public static final String HKAH_OP_TRI_ASSESS_GRP_CODE = "OP_TRI_ASSESS";
	public static final String HKAH_DI_REPORT_CODE = "DIAG-MOF01";
	public static final String HKAH_LABPATH_FORM_CODE = "LABPATH";
	public static final String HKAH_OLAB_FORM_CODE = "OLAB";
	public static final String HKAH_CONSENT_COLL_DATA_CODE = "PABD-MBB14";
	public static final String HKAH_PHY_ORDER_CODE = "NUADMFA02";
	public static final String HKAH_PHY_ORDER_CODE2 = "NUAD-MFA02";
	public static final String HKAH_PED_SOH_SCL_CODE = "PEDUMLC15ZA";
	public static final String HKAH_OP_TRIAGE_ASSESS_CODE = "OPDU-MOA10";
	public static final String HKAH_OP_TRIAGE_H1N1_CODE = "OPDU-MOA10c";
	public static final String HKAH_OP_PROC_TIMEO_CL_CODE = "NUADMLC08";
	public static final String HKAH_BRON_CODE = "VPMAMBB09";
	public static final String HKAH_BRON_CODE2 = "VPMA-MBB09";
	public static final String HKAH_HR_FALL_REASSES = "NUAD-MLC11";
	public static final String HKAH_HR_FALL_REASSES2 = "NUADMLC11";
	public static final String HKAH_ABDOMINAL_PAIN = "SURU-MLC13";
	public static final String HKAH_ABDOMINAL_PAIN2 = "SURUMLC13";
	public static final String HKAH_DISC_SUMM = "NUAD-MAA01";
	public static final String HKAH_DISC_SUMM2 = "NUADMAA01";
	public static final String HKAH_DISC_SUMM3 = "VPMA-MAA01";
	public static final String HKAH_DISC_SUMM4 = "VPMAMAA01";	
	public static final String HKAH_OP_REG_FORM = "PABDMOD01";
	public static final String HKAH_OP_REG_FORM2 = "PABD-MOD01";	
	public static final String HKAH_LAB_RPT_PREFIX = "CLAB";
	public static final String HKAH_LAB_RPT_MOE01 = "MOE01";
	public static final String HKAH_LAB_RPT_MOE03 = "MOE03";
	public static final List<String> HKAH_CCL_PROCEDURE_FORMS = new ArrayList<String>();
	public static final List<String> HKAH_PERI_OP_NFC_FORMS = new ArrayList<String>();
	public static final List<String> HKAH_INP_ADM_FORMS = new ArrayList<String>();
	public static final List<String> HKAH_INP_TRI_FORMS = new ArrayList<String>();
	public static final List<String> HKAH_INP_TRI_RISK_FORMS = new ArrayList<String>();
	public static final List<String> HKAH_INP_NUR_REASS_MS_FORMS = new ArrayList<String>();
	public static final List<String> HKAH_INP_NUT_RISK_SCR_FORMS = new ArrayList<String>();
	public static final List<String> HKAH_PAT_DISCH_INS = new ArrayList<String>();
	public static final List<String> HKAH_ADM_NUR_DBA = new ArrayList<String>();
	
	public static final HashMap<String, String> ALLOWCOMBINETYPES = new HashMap<String, String>();
	
	public static final BigDecimal HKAH_RPT_PM_CAT_ID = new BigDecimal(112);
	public static final BigDecimal HKAH_RPT_CRT_D_CAT_ID = new BigDecimal(113);
	public static final BigDecimal HKAH_RPT_CRT_P_CAT_ID = new BigDecimal(114);
	public static final BigDecimal HKAH_RPT_ICD_CAT_ID = new BigDecimal(115);
	public static final BigDecimal HKAH_ON_MISC_CAT_ID = new BigDecimal(116);
	public static final BigDecimal HKAH_RPT_DENTAL_CAT_ID = new BigDecimal(123);
	public static final BigDecimal HKAH_IP_FEFA_CAT_ID = new BigDecimal(127);
	public static final BigDecimal HKAH_IP_FEFB_CAT_ID = new BigDecimal(128);
	public static final BigDecimal HKAH_OP_WPR_CAT_ID = new BigDecimal(132);
	
	public static final String HKAH_RPT_PM_GRP_CODE = "RPT_PM";
	public static final String HKAH_RPT_CRT_D_GRP_CODE = "RPT_CRT_D";
	public static final String HKAH_RPT_CRT_P_GRP_CODE = "RPT_CRT_P";
	public static final String HKAH_RPT_ICD_GRP_CODE = "RPT_ICD";
	public static final String HKAH_ON_MISC_CAT_GRP_CODE = "RPT_ON_MISC";
	public static final String HKAH_RPT_DENTAL_GRP_CODE = "RPT_DENTAL";
	public static final String HKAH_IP_FEFA_GRP_CODE = "IP_FEFA";
	public static final String HKAH_IP_FEFB_GRP_CODE = "IP_FEFB";
	public static final String HKAH_OP_WPR_GRP_CODE = "OP_WPR";
	
	public static final int IMPORT_CSV_COL_SIZE = 12;
	public static final int SCAN_SUB_PATH_START_LEVEL =	2; // e.g C:\BatchesPro\Batch013\Unclassified\446718U\5.tif, level 2 is Batch013
	public static final String DOC_IMAGE_TYPE = "png";
	public static final Map<String, String> SID2srcHost = new LinkedHashMap<String, String>();
	public static final Map<String, String> stationIDs = new LinkedHashMap<String, String>();
	public static final String MSG_TREE_NOT_SHOW_LIVE = "This list will not show in LIVE mode. (No scanned approved chart)";
		
	public static final String INVCODE_REGID = "INVCODE_REGID";
	
	static {
		HKAH_INP_ADM_FORMS.add("PABDMAA01");
		HKAH_INP_ADM_FORMS.add("PABDMAA01A");
		HKAH_INP_ADM_FORMS.add("PABDMAA01a");
		HKAH_INP_ADM_FORMS.add("PABD-MAA01");
		HKAH_INP_ADM_FORMS.add("PABD-MAA01a");
		HKAH_INP_ADM_FORMS.add("PABD-MAA01B");
		HKAH_INP_ADM_FORMS.add("PABD-MAA01b");
		HKAH_INP_ADM_FORMS.add("PABDMAA01b");
		
		HKAH_INP_TRI_FORMS.add("OPDU-MOA10");
		HKAH_INP_TRI_FORMS.add("OPDUMOA10");
		
		HKAH_INP_TRI_RISK_FORMS.add("OPDU-MOA10");
		HKAH_INP_TRI_RISK_FORMS.add("OPDUMOA10");
		
		HKAH_INP_TRI_RISK_FORMS.add("OPDU-MOA10a");
		HKAH_INP_TRI_RISK_FORMS.add("OPDU-MOA10A");
		HKAH_INP_TRI_RISK_FORMS.add("OPDUMOA10A");
		HKAH_INP_TRI_RISK_FORMS.add("OPDUMOA10a");
		
		HKAH_INP_TRI_RISK_FORMS.add("OPDU-MOA10b");
		HKAH_INP_TRI_RISK_FORMS.add("OPDUMOA10B");
		HKAH_INP_TRI_RISK_FORMS.add("OPDUMOA10b");
		HKAH_INP_TRI_RISK_FORMS.add("OPDU-MOA10B");
		
		HKAH_INP_NUR_REASS_MS_FORMS.add("NUAD-MLC07");
		HKAH_INP_NUR_REASS_MS_FORMS.add("NUADMLC07");
		
		HKAH_INP_NUT_RISK_SCR_FORMS.add("NUAD-MLC07h");
		HKAH_INP_NUT_RISK_SCR_FORMS.add("NUAD-MLC07H");
		HKAH_INP_NUT_RISK_SCR_FORMS.add("NUADMLC07H");
		HKAH_INP_NUT_RISK_SCR_FORMS.add("NUADMLC07h");
		
		HKAH_PAT_DISCH_INS.add("NUAD-MLB13");
		HKAH_PAT_DISCH_INS.add("NUADMLB13");

		HKAH_ADM_NUR_DBA.add("NUAD-MLC06");
		HKAH_ADM_NUR_DBA.add("NUADMLC06");
		
		HKAH_CCL_PROCEDURE_FORMS.add("CATH-MEB04");
		HKAH_CCL_PROCEDURE_FORMS.add("CATHMEB04");
		
		HKAH_PERI_OP_NFC_FORMS.add("OPRM-MEA07a");
		HKAH_PERI_OP_NFC_FORMS.add("OPRM-MEA07A");
		HKAH_PERI_OP_NFC_FORMS.add("OPRMMEA07a");
		HKAH_PERI_OP_NFC_FORMS.add("OPRMMEA07A");
		
		ALLOWCOMBINETYPES.put("NUADMFA01", "I");	
		ALLOWCOMBINETYPES.put("NUADMFA02", "I");
		ALLOWCOMBINETYPES.put("PHARMGA02", "I");
		ALLOWCOMBINETYPES.put("PHARMGA03", "I");
		ALLOWCOMBINETYPES.put("NUADMHA06", "I");
		ALLOWCOMBINETYPES.put("NUADMHA06a", "I");
		ALLOWCOMBINETYPES.put("NUADMHA07", "I");
		ALLOWCOMBINETYPES.put("NUADMHA07a", "I");
		ALLOWCOMBINETYPES.put("NUADMHA17", "I");
		ALLOWCOMBINETYPES.put("NUADMHA18", "I");
		ALLOWCOMBINETYPES.put("HEMOMHA21", "I");
		ALLOWCOMBINETYPES.put("HEMOMHA21", "O");
		ALLOWCOMBINETYPES.put("HEMOMHA21a", "I");
		ALLOWCOMBINETYPES.put("HEMOMHA21a", "O");
		ALLOWCOMBINETYPES.put("HEMOMHA21b", "I");
		ALLOWCOMBINETYPES.put("HEMOMHA21b", "O");
		ALLOWCOMBINETYPES.put("HEMOMHA21c", "I");
		ALLOWCOMBINETYPES.put("HEMOMHA21c", "O");
		ALLOWCOMBINETYPES.put("HEMOMHA21d", "I");
		ALLOWCOMBINETYPES.put("HEMOMHA21d", "O");
		ALLOWCOMBINETYPES.put("HEMOMHA21f", "I");
		ALLOWCOMBINETYPES.put("HEMOMHA21f", "O");
		ALLOWCOMBINETYPES.put("DIETMHA22", "I");
		ALLOWCOMBINETYPES.put("NUSYMHB02", "I");
		ALLOWCOMBINETYPES.put("NUADMHB03", "I");
		ALLOWCOMBINETYPES.put("NUADMHB05", "I");
		ALLOWCOMBINETYPES.put("NUADMLC07", "I");
		ALLOWCOMBINETYPES.put("ICUNMLC07d", "I");
		ALLOWCOMBINETYPES.put("OBSUMLC06e", "I");
		ALLOWCOMBINETYPES.put("PEDUMLC07c", "I");
		ALLOWCOMBINETYPES.put("NUADMLC19", "I");
		ALLOWCOMBINETYPES.put("CPLBMHA10", "I");
		ALLOWCOMBINETYPES.put("CPLBMHA16", "I");
		ALLOWCOMBINETYPES.put("CPLAB", "O");
		ALLOWCOMBINETYPES.put("CBMISC", "I");

		ALLOWCOMBINETYPES.put("MEDUMHA02", "I");
		ALLOWCOMBINETYPES.put("MEDU-MHA02", "I");
		
		ALLOWCOMBINETYPES.put("NUADMLC08", "I");
		ALLOWCOMBINETYPES.put("NUAD-MLC08", "I");
		
		ALLOWCOMBINETYPES.put("NUADMHA01", "I");
		ALLOWCOMBINETYPES.put("NUAD-MHA01", "I");
		ALLOWCOMBINETYPES.put("200-90", "I");
		
		ALLOWCOMBINETYPES.put("NUAD-MLC11b", "I");
		ALLOWCOMBINETYPES.put("NUADMLC11B", "I");
		ALLOWCOMBINETYPES.put("NUADMLC11b", "I");
		ALLOWCOMBINETYPES.put("NUAD-MLC11B", "I");
		
		ALLOWCOMBINETYPES.put("NUAD-MLC11d", "I");
		ALLOWCOMBINETYPES.put("NUADMLC11D", "I");
		ALLOWCOMBINETYPES.put("NUADMLC11d", "I");
		ALLOWCOMBINETYPES.put("NUAD-MLC11D", "I");
		
		ALLOWCOMBINETYPES.put("NUADMHB05", "O");
		ALLOWCOMBINETYPES.put("NUAD-MHB05", "O");
		
		
//TEST COMBINE		
//ALLOWCOMBINETYPES.put("OPDUMOA01", "O");
	}
	
	public enum ViewMode {
	    DEBUG, ADMIN, PREVIEW, LIVE, FILE_STAT
	}
	
	private FsModelHelper() {
		super();
		// TODO Auto-generated constructor stub
	}

	public static FsModelHelper getInstance() {
		if (instance == null) {
			instance = new FsModelHelper();
		}
		return instance;
	}
	
	public void setCategoryList(List<FsCategory> categoryList) {
		this.categoryList = categoryList;
	}
	
	public List<FsCategory> getCategoryList() {
		return getCategoryList(true, false);
	}
	
	public List<FsCategory> getGeneralCategoryList() {
		return getCategoryList(false, true);
	}
	
	public void setFileList(List<FsFileIndex> fileList) {
		this.fileList = fileList;
	}
	
	public List<FsFileIndex> getFileList() {
		return fileList;
	}
	
	public static FsCategory getFsCategory(BigDecimal fsCategoryId) {
		String categoryId = null;
    	try {
    		categoryId = fsCategoryId.toPlainString();
    	} catch (Exception e) {
    	}
		List<FsCategory> result = FsModelHelper.getFsCategoryModels(ForwardScanningDB.getCategory(categoryId));
		if (result != null && !result.isEmpty())
			return result.get(0);
		else
			return null;
	}
	
	public static List<FsCategory> getFsCategoryModels(List results) {
		List<FsCategory> list = new ArrayList<FsCategory>();
		if (results != null) {
			FsCategory fsCategory = null;
			for (int i = 0; i < results.size(); i++) {
				boolean isIp = true;
				ReportableListObject rlo = (ReportableListObject) results.get(i);
				
				BigDecimal categoryId = new BigDecimal(rlo.getValue(0));
				BigDecimal parentCategoryId = null;
				if (rlo.getValue(2) != null && !"".equals(rlo.getValue(2))) {
					parentCategoryId = new BigDecimal(rlo.getValue(2));
				}
				if (isIp) {
					fsCategory = new FsCategoryInPat();
				} else {
					fsCategory = new FsCategory();
				}
				fsCategory.setFsCategoryId(categoryId);
				fsCategory.setFsParentCategoryId(parentCategoryId);
				fsCategory.setFsName(rlo.getValue(1));

				fsCategory.setFsSeq(rlo.getValue(3));
				fsCategory.setFsIsMulti(rlo.getValue(4));
				list.add(fsCategory);
			}
		}
		return list;
	}
	
	public void resetCategoryList(boolean instanceTree) {
		List<FsCategory> thisList = null;
		if (instanceTree) {
			thisList = categoryList;
		} else {
			thisList = generalCategoryList;
		}
		
		if (thisList != null)
			thisList.clear();
	}
	
	public List<FsCategory> getCategoryList(boolean instanceTree, boolean reload) {
		List<FsCategory> thisList = null;
		if (instanceTree) {
			thisList = categoryList;
		} else {
			thisList = generalCategoryList;
		}
		
		if (thisList == null || reload) {
			List<FsCategory> list = new ArrayList<FsCategory>();
			List results = ForwardScanningDB.getCategoryList();
			
			if (results != null) {
				FsCategory fsCategory = null;
				for (int i = 0; i < results.size(); i++) {
					boolean isIp = false;
					ReportableListObject rlo = (ReportableListObject) results.get(i);
					
					BigDecimal categoryId = new BigDecimal(rlo.getValue(0));
					BigDecimal parentCategoryId = null;
					if (rlo.getValue(2) != null && !"".equals(rlo.getValue(2))) {
						parentCategoryId = new BigDecimal(rlo.getValue(2));
					}
					String isMulti = rlo.getValue(4);
					//if (ConstantsVariable.YES_VALUE.equals(isMulti) || 
					//		(parentCategoryId != null && CATEGORY_ID_IP.compareTo(parentCategoryId) == 0)) {
						isIp = true;
					//}
					if (isIp) {
						fsCategory = new FsCategoryInPat();
					} else {
						fsCategory = new FsCategory();
					}
					fsCategory.setFsCategoryId(categoryId);
					fsCategory.setFsParentCategoryId(parentCategoryId);
					fsCategory.setFsName(rlo.getValue(1));

					fsCategory.setFsSeq(rlo.getValue(3));
					fsCategory.setFsIsMulti(rlo.getValue(4));
					list.add(fsCategory);
				}
				thisList = list;
			}
			thisList = FsModelHelper.constructFsCategoryTree(thisList, null);
			
			if (instanceTree) {
				expandFsCategoryTree(thisList);
			}
		}
		
		if (instanceTree) {
			categoryList = thisList;
			return categoryList;
		} else {
			generalCategoryList = thisList;
			return generalCategoryList;
		}
	}
	
	private void resetIpPeriodGrp() {
		multiCategoryGrp = null;
		multiCategoryGrp = new LinkedHashMap<BigDecimal, List<FsCategoryInPat>>();
	}
	
	private void sortIpPeriodGrp() {
		if (multiCategoryGrp != null) {
			Set<BigDecimal> keys = multiCategoryGrp.keySet();
			Iterator<BigDecimal> itr = keys.iterator();
			while (itr.hasNext()) {
				BigDecimal key = itr.next();
				List<FsCategoryInPat> list = multiCategoryGrp.get(key);
				
				/*
				System.out.println("=========================");
				System.out.println("key " + key + ":");
				for (int i = 0; i < list.size(); i++) {
					FsCategoryInPat cat = list.get(i);
					System.out.println("  id=" + cat.getFsCategoryId_String() + 
							"  adm=" + cat.getAdmDate() + "  discharge=" + cat.getDischargeDate());
				}
				System.out.println("=========================");
				*/
				
				Collections.sort(list, new Comparator<FsCategoryInPat>() {
					@Override
					public int compare(FsCategoryInPat o1, FsCategoryInPat o2) {
						// TODO Auto-generated method stub
						Date admDate1 = o1 != null ? o1.getAdmDate() : null;
						Date admDate2 = o2 != null ? o2.getAdmDate() : null;
						
						Long diff = (admDate2 != null ? admDate2.getTime() : 0) - (admDate1 != null ? admDate1.getTime() : 0);
						int ret = 0;
					    if (diff < Integer.MIN_VALUE) {
					    	ret = Integer.MIN_VALUE;
					    } else if (diff > Integer.MAX_VALUE) {
					    	ret = Integer.MAX_VALUE;
					    } else {
					    	ret = Integer.parseInt(diff.toString());
					    }
					    return ret;
					}
				});
			}
		}
	}
	
	public static FsFileIndex getFsFile(String fileIndexId) {
		FsModelHelper fsModelHelper = FsModelHelper.getInstance();
		List<FsFileIndex> result = fsModelHelper.getFsFileModels(ForwardScanningDB.getFile(ViewMode.ADMIN, fileIndexId), ViewMode.ADMIN);
		if (result != null && !result.isEmpty()) {
			return result.get(0);
		} else {	
			return null;
		}
	}

	public List<FsFileIndex> getFsFileModels(List results, ViewMode viewMode) {
		List<FsFileIndex> fileIndexes = new ArrayList<FsFileIndex>();
		
		resetIpPeriodGrp();
		
		if (results != null) {
			for (int i = 0; i < results.size(); i++) {
				ReportableListObject rlo = (ReportableListObject) results.get(i);
				
				FsFileIndex fileIndex = new FsFileIndex();
				fileIndex.setFsFileIndexId(new BigDecimal((rlo.getValue(0))));
/*
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
 */
				fileIndex.setFsPatno(rlo.getValue(1));
				fileIndex.setFsRegid(rlo.getValue(2));
				fileIndex.setFsDueDate(DateTimeUtil.parseDateTime(rlo.getValue(3)));
				fileIndex.setFsAdmDate(DateTimeUtil.parseDateTime(rlo.getValue(4)));
				fileIndex.setFsDischargeDate(DateTimeUtil.parseDateTime(rlo.getValue(5)));
				fileIndex.setFsImportDate(DateTimeUtil.parseDateTime(rlo.getValue(17)));
				fileIndex.setFsFormName(rlo.getValue(6));
				fileIndex.setFsFilePath(rlo.getValue(7));
				fileIndex.setFsPattype(rlo.getValue(8));
				fileIndex.setFsSeq(rlo.getValue(9));
				fileIndex.setFsFormCode(rlo.getValue(14));
				fileIndex.setFsApprovedDate(DateTimeUtil.parseDateTime(rlo.getValue(18)));
				fileIndex.setFsApprovedUser(rlo.getValue(19));
				fileIndex.setFsBatchNo(rlo.getValue(20));
				fileIndex.setFsLabNum(rlo.getValue(21));
				int fsEnabled = 0;
				try {
					fsEnabled = Integer.parseInt(rlo.getValue(23));
				} catch (Exception e) {}
				fileIndex.setFsEnabled(fsEnabled);
				fileIndex.setFsImportedBy(rlo.getValue(24));
				
				List<ReportableListObject> codesAllFormat = ForwardScanningDB.getAllFormatListByFormCode(
						fileIndex.getFsFormCode(), fileIndex.getFsPattype());
				for (int j = 0; j < codesAllFormat.size(); j++) {
					ReportableListObject row = codesAllFormat.get(j);
					String master = row.getValue(0);
					String alias =  row.getValue(1);
					
					if (j == 0)
						fileIndex.setMasterFormCode(master);
					fileIndex.getFormAliases().add(alias);
				}
				fileIndex.setFsCreatedUser((rlo.getValue(24)));
				
				// special handling (HKAH)
				// if ADMIN mode, form is OP Triage Assessment (form_id: 476), put it in OP > Consultation & Treatment (cat_id; 16)
				// if ADMIN mode, form is PROCEDURE TIME OUT CHECKLIST (form_id: 1273), put it in OP > Consultation & Treatment (cat_id; 16)
				boolean isHKAHOpMisc = false;
				if (ConstantsServerSide.isHKAH()) {
					if (HKAH_OP_TRIAGE_ASSESS_CODE.equals(fileIndex.getMasterFormCode()) &&
								PAT_TYPE_CODE_OP.equals(fileIndex.getFsPattype())) {
						isHKAHOpMisc = true;
					}
					if (HKAH_OP_TRIAGE_H1N1_CODE.equals(fileIndex.getMasterFormCode()) &&
							PAT_TYPE_CODE_OP.equals(fileIndex.getFsPattype())) {
						isHKAHOpMisc = true;
					}
					if (HKAH_OP_PROC_TIMEO_CL_CODE.equals(fileIndex.getMasterFormCode()) &&
							PAT_TYPE_CODE_OP.equals(fileIndex.getFsPattype())) {
						isHKAHOpMisc = true;
					}
				}
				if (ViewMode.ADMIN.equals(viewMode) && isHKAHOpMisc) {
					fileIndex.setFsFormName(fileIndex.getFsFormName() + " [Miscellaneous in Other modes]");
				}
				
				String fileProfileId = rlo.getValue(10);
				if (fileProfileId != null && !"".equals(fileProfileId)) {
					FsFileProfile fsFileProfile = new FsFileProfile();
					fsFileProfile.setFsFileProfileId(new BigDecimal(fileProfileId));
					fsFileProfile.setFsIcdCode(rlo.getValue(16));
					fsFileProfile.setFsIcdName(rlo.getValue(11));
					
					FsCategory fsCategory = new FsCategory();
					
					if (ViewMode.ADMIN.equals(viewMode) && isHKAHOpMisc) {
						fsCategory.setFsCategoryId(HKAH_OP_CONS_TREAT_CAT_ID);
					} else {
						String categoryId = rlo.getValue(12);
						String parentCategoryId = rlo.getValue(13);
						if (categoryId != null && !"".equals(categoryId)) {
							fsCategory.setFsCategoryId(new BigDecimal(categoryId));
						}
						if (parentCategoryId != null && !"".equals(parentCategoryId)) {
							fsCategory.setFsParentCategoryId(new BigDecimal(parentCategoryId));
						}
					}
					fsFileProfile.setFsCategory(fsCategory);
					fsFileProfile.setFsFormCode(rlo.getValue(14));
					fsFileProfile.setFsStnid(rlo.getValue(22));
					fsFileProfile.setFsCreatedUser(rlo.getValue(24));
					fsFileProfile.setFsKey(rlo.getValue(25));
					fsFileProfile.setFsRisAccessionNo(rlo.getValue(26));
					fileIndex.setFsFileProfile(fsFileProfile);
					
					// store all admission, discharge date
					FsCategoryInPat ipCat = new FsCategoryInPat();
					ipCat.setAdmDate(fileIndex.getFsAdmDate());
					ipCat.setDischargeDate(fileIndex.getFsDischargeDate());
					
					ArrayList icdList = ForwardScanningDB.getIcdList(fileIndex.getFsRegid());
					if (icdList != null && !icdList.isEmpty()) {
						ReportableListObject row = (ReportableListObject) icdList.get(0);
						// set ICD code and name on the fly
						fsFileProfile.setFsIcdCode(row.getValue(1));
						fsFileProfile.setFsIcdName(row.getValue(2));
						
						ipCat.setIcdCode(row.getValue(1));
						ipCat.setIcdName(row.getValue(2));
						
						ipCat.setIcdCodeRsn(row.getValue(3));
						ipCat.setIcdNameRsn(row.getValue(4));
					}
					ipCat.setFsIsMulti(rlo.getValue(15));
					
					List<FsCategoryInPat> cats = multiCategoryGrp.get(fsCategory.getFsCategoryId());
					if (cats != null) {
						boolean add2 = true;
						for (int j = 0; j < cats.size(); j++) {
							FsCategoryInPat catIp = cats.get(j);
							if (catIp.equalsAdmDisch(ipCat.getAdmDate(), ipCat.getDischargeDate()))
								add2 = false;
						}
						if (add2) {
							cats.add(ipCat);
							//System.out.println("ADD " + fsCategory.getFsCategoryId() + ", period = " + ipCat.getIpPeriod());
						}
					} else {
						List<FsCategoryInPat> newCats = new ArrayList<FsCategoryInPat>();
						newCats.add(ipCat);
						multiCategoryGrp.put(fsCategory.getFsCategoryId(), newCats);
						//System.out.println("ADD " + fsCategory.getFsCategoryId() + ", period = " + ipCat.getIpPeriod());
					}
					
					List<FsCategoryInPat> parentCats = multiCategoryGrp.get(fsCategory.getFsParentCategoryId());
					if (parentCats != null) {
						boolean add2 = true;
						for (int j = 0; j < parentCats.size(); j++) {
							FsCategoryInPat catIp = parentCats.get(j);
							if (catIp.equalsAdmDisch(ipCat.getAdmDate(), ipCat.getDischargeDate()))
								add2 = false;
						}
						if (add2) {
							parentCats.add(ipCat);
							//System.out.println("ADD " + fsCategory.getFsParentCategoryId() + ", period = " + ipCat.getIpPeriod());
						}
					} else {
						List<FsCategoryInPat> newCats = new ArrayList<FsCategoryInPat>();
						newCats.add(ipCat);
						multiCategoryGrp.put(fsCategory.getFsParentCategoryId(), newCats);
						//System.out.println("ADD " + fsCategory.getFsParentCategoryId() + ", period = " + ipCat.getIpPeriod());
					}
				}
				
				fileIndexes.add(fileIndex);
			}
		}
		
		sortIpPeriodGrp();
		
		return fileIndexes;
	}
	
	public List<FsFileStat> getFsFileStatModels(List results, ViewMode viewMode) {
		List<FsFileStat> fsFileStats = new ArrayList<FsFileStat>();
		
		if (results != null) {
			for (int i = 0; i < results.size(); i++) {
				ReportableListObject rlo = (ReportableListObject) results.get(i);
				
				FsFileStat fileStat = new FsFileStat();
				fileStat.setFsPatno(rlo.getValue(0));
				fileStat.setNoOfBatch(new BigDecimal(rlo.getValue(1)));
				fileStat.setNoOfReg(new BigDecimal(rlo.getValue(2)));
				fileStat.setNoOfFileIndexAll(new BigDecimal(rlo.getValue(3)));
				fileStat.setNoOfFileIndexIp(new BigDecimal(rlo.getValue(4)));
				fileStat.setNoOfFileIndexOp(new BigDecimal(rlo.getValue(5)));
				fileStat.setNoOfFileIndexDc(new BigDecimal(rlo.getValue(6)));
				fileStat.setNoOfFileIndexOther(new BigDecimal(rlo.getValue(7)));
				fileStat.setFsFirstImportDate(DateTimeUtil.parseDateTime(rlo.getValue(8)));
				fileStat.setFsLatestImportDate(DateTimeUtil.parseDateTime(rlo.getValue(9)));
				fsFileStats.add(fileStat);
			}
		}
		return fsFileStats;
	}
	
	public static List<FsFileIndex> getFsFiles() {
		FsModelHelper fsModelHelper = FsModelHelper.getInstance();
		return fsModelHelper.getFsFileModels(ForwardScanningDB.getFileList(ViewMode.ADMIN), ViewMode.ADMIN);
	}
	
	public static List<FsFileIndex> searchFsFile(String patno, String regId, String formName, String formCode, String pattype,
			String dueDate, String admDateFrom, String admDateTo, String dischargeDateFrom, String dischargeDateTo, String importDateFrm, String importDateTo, String approveStatus, String batchNo,
			boolean orderByImport, boolean orderByDueDate, boolean showAutoImport, boolean showHIS, String importBy) {
		String[] importBys = null;
		if (importBy != null && !importBy.trim().isEmpty()) {
			importBy = StringUtils.deleteWhitespace(importBy);
			importBys = importBy.split(",");
		}
		
		FsModelHelper fsModelHelper = FsModelHelper.getInstance();
		return fsModelHelper.getFsFileModels(ForwardScanningDB.getFileList(ViewMode.ADMIN, patno, regId, pattype, formName, formCode,
				dueDate, admDateFrom, admDateTo, dischargeDateFrom, dischargeDateTo, importDateFrm, importDateTo, approveStatus, batchNo,
				orderByImport, orderByDueDate, showAutoImport, showHIS, importBys), ViewMode.ADMIN);
	}
	
	public static List<FsFileStat> searchFsFileStat(String patno, String regId, String formName, String formCode, String pattype,
			String dueDate, String admDateFrom, String admDateTo, String dischargeDateFrom, String dischargeDateTo, String importDateFrm, String importDateTo, String approveStatus, String batchNo,
			boolean orderByImport, boolean orderByDueDate, boolean showAutoImport, boolean showHIS) {
		FsModelHelper fsModelHelper = FsModelHelper.getInstance();
		return fsModelHelper.getFsFileStatModels(ForwardScanningDB.getFileList(ViewMode.FILE_STAT, patno, regId, pattype, formName, formCode,
				dueDate, admDateFrom, admDateTo, dischargeDateFrom, dischargeDateTo, importDateFrm, importDateTo, approveStatus, batchNo,
				orderByImport, orderByDueDate, showAutoImport, showHIS, null), ViewMode.FILE_STAT);
	}
	
	public static List<FsImportLog> searchFsImportLog(String importDateFrom, 
			String importDateTo, String batchNo, String encodedParams, String importBy,
			String importStatus, String approveStatus,String patNo) {
		FsModelHelper fsModelHelper = FsModelHelper.getInstance();
		String[] importBys = null;
		if (importBy != null && !importBy.trim().isEmpty()) {
			importBy = StringUtils.deleteWhitespace(importBy).toUpperCase();
			importBys = importBy.split(",");
		}
		
		return fsModelHelper.getFsImportLogModels(ForwardScanningDB.getImportLogList(null,
				importDateFrom, importDateTo, batchNo, encodedParams, importBys, importStatus, approveStatus, patNo));
	}
	
	public List<FsImportLog> getFsImportLogModels(List results) {
		List<FsImportLog> fsImportLogs = new ArrayList<FsImportLog>();
		
		if (results != null) {
			for (int i = 0; i < results.size(); i++) {
				ReportableListObject rlo = (ReportableListObject) results.get(i);
				
				FsImportLog fsImportLog = new FsImportLog();
				fsImportLog.setFsImportLogId(new BigDecimal((rlo.getValue(0))));
				String fileIndexId = rlo.getValue(1);
				if (fileIndexId != null && !"".equals(fileIndexId)) {
					fsImportLog.setFsFileIndexId(new BigDecimal(fileIndexId));
				}
				String batchNo = rlo.getValue(2);
				if (batchNo != null && !"".equals(batchNo)) {
					fsImportLog.setFsBatchNo(new BigDecimal(batchNo));
				}
				fsImportLog.setFsImportDate(DateTimeUtil.parseDateTime(rlo.getValue(3)));
				fsImportLog.setFsEncodedParams(rlo.getValue(4));
				fsImportLog.setFsDescription(rlo.getValue(5));
				fsImportLog.setFsHandled(rlo.getValue(6));
				fsImportLog.setFsHandledDesc(rlo.getValue(7));
				fsImportLog.setFsApprovedDate(DateTimeUtil.parseDateTime(rlo.getValue(8)));
				fsImportLog.setFsApprovedUser(rlo.getValue(9));
				int corrFsFileIndexEnabled = 0;
				try {
					corrFsFileIndexEnabled = Integer.parseInt(rlo.getValue(10));
				} catch (Exception e) {}
				fsImportLog.setFsCreatedUser(rlo.getValue(11));
				//System.out.println("Model: importLogId:"+fsImportLog.getFsImportLogId().toPlainString()+", corrFsFileIndexEnabled="+corrFsFileIndexEnabled);
				fsImportLog.setCorrFsFileIndexEnabled(corrFsFileIndexEnabled);
				
				fsImportLogs.add(fsImportLog);
			}
		}
		return fsImportLogs;
	}
	
	public static FsForm getFsForm(String formId) {
		FsModelHelper fsModelHelper = FsModelHelper.getInstance();
		List<FsForm> result = fsModelHelper.getFsFormsModels(ForwardScanningDB.getForm(formId));
		if (result != null && !result.isEmpty()) {
			return result.get(0);
		} else {	
			return null;
		}
	}
	
	public List<FsForm> getFsFormsModels(List results) {
		List<FsForm> fsForms = new ArrayList<FsForm>();
		
		if (results != null) {
			for (int i = 0; i < results.size(); i++) {
				ReportableListObject rlo = (ReportableListObject) results.get(i);
				
				FsForm fsForm = new FsForm();
				fsForm.setFsFormId(new BigDecimal((rlo.getValue(0))));
				fsForm.setFsFormCode(rlo.getValue(1));
				fsForm.setFsFormName(rlo.getValue(2));
				String categoryId = rlo.getValue(3);
				if (categoryId != null && !"".equals(categoryId)) {
					fsForm.setFsCategoryId(new BigDecimal(categoryId));
				}
				fsForm.setFsSection(rlo.getValue(4));
				fsForm.setFsSeq(rlo.getValue(5));
				fsForm.setFsPattype(rlo.getValue(6));
				fsForm.setFsIsDefault(rlo.getValue(7));
				String chartMaxAllow = rlo.getValue(8);
				try {
					fsForm.setFsChartMaxAllow(new Integer(chartMaxAllow));
				} catch (Exception ex) {
				}
				
				fsForms.add(fsForm);
			}
		}
		return fsForms;
	}
	
	public static List<FsForm> getFsForms() {
		FsModelHelper fsModelHelper = FsModelHelper.getInstance();
		return fsModelHelper.getFsFormsModels(ForwardScanningDB.getFormList());
	}
	
	public static List<FsForm> searchFsForm(String formName, String formCode,
			String pattype, String section, String fsSeq, String formAlias, String orderBy) {
		FsModelHelper fsModelHelper = FsModelHelper.getInstance();
		return fsModelHelper.getFsFormsModels(ForwardScanningDB.getFormList(
				null, pattype, formName, formCode, section, true, orderBy));
	}
	
	public static FsImportLog getFsImportLog(String importLogId) {
		FsModelHelper fsModelHelper = FsModelHelper.getInstance();
		List<FsImportLog> result = fsModelHelper.getFsImportLogsModels(ForwardScanningDB.getImportLog(importLogId));
		if (result != null && !result.isEmpty()) {
			return result.get(0);
		} else {	
			return null;
		}
	}
	
	public List<FsImportLog> getFsImportLogsModels(List results) {
		List<FsImportLog> fsImportLogs = new ArrayList<FsImportLog>();
		
		if (results != null) {
			for (int i = 0; i < results.size(); i++) {
				ReportableListObject rlo = (ReportableListObject) results.get(i);
				
				FsImportLog fsImportLog = new FsImportLog();
				fsImportLog.setFsImportLogId(new BigDecimal((rlo.getValue(0))));
				String fileIndexId = rlo.getValue(1);
				if (fileIndexId != null && !"".equals(fileIndexId)) {
					fsImportLog.setFsFileIndexId(new BigDecimal(fileIndexId));
				}
				String batchNo = rlo.getValue(2);
				if (batchNo != null && !"".equals(batchNo)) {
					fsImportLog.setFsBatchNo(new BigDecimal(batchNo));
				}
				fsImportLog.setFsImportDate(DateTimeUtil.parseDateTime(rlo.getValue(3)));
				fsImportLog.setFsEncodedParams(rlo.getValue(4));
				fsImportLog.setFsDescription(rlo.getValue(5));
				fsImportLog.setFsHandled(rlo.getValue(6));
				fsImportLog.setFsHandledDesc(rlo.getValue(7));
				
				fsImportLogs.add(fsImportLog);
			}
		}
		return fsImportLogs;
	}
	
	public static FsFileIndex addFsFiles(UserBean userBean, String patno, String regId,
			String formName, String formCode, String pattype, String filePath, 
			String admDateStr, String dischargeDateStr, String dueDateStr, String importDateStr, 
			String seq, String categoryId, String icdCode, String icdName, String labNum, String stnid, String key, String risAccessionNo) {
		FsFileIndex fsFileIndex = new FsFileIndex();
		fsFileIndex.setFsPatno(patno);
		fsFileIndex.setFsRegid(regId);
		fsFileIndex.setFsFormName(formName);
		fsFileIndex.setFsPattype(pattype);
		fsFileIndex.setFsFilePath(filePath);
		fsFileIndex.setFsDueDate(DateTimeUtil.parseDate(dueDateStr));
		fsFileIndex.setFsAdmDate(DateTimeUtil.parseDate(admDateStr));
		fsFileIndex.setFsDischargeDate(DateTimeUtil.parseDate(dischargeDateStr));
		fsFileIndex.setFsImportDate(DateTimeUtil.parseDate(importDateStr));
		fsFileIndex.setFsSeq(seq);
		fsFileIndex.setFsLabNum(labNum);
		FsFileProfile fsFileProfile = new FsFileProfile();
		FsCategory fsCategory = new FsCategory();
		if (categoryId != null && !"".equals(categoryId)) 
			fsCategory.setFsCategoryId(new BigDecimal(categoryId));
		fsFileProfile.setFsCategory(fsCategory);
		fsFileProfile.setFsFormCode(formCode);
		fsFileProfile.setFsIcdCode(icdCode);
		fsFileProfile.setFsIcdName(icdName);
		fsFileProfile.setFsStnid(stnid);
		fsFileProfile.setFsKey(key);
		fsFileProfile.setFsRisAccessionNo(risAccessionNo);
		fsFileIndex.setFsFileProfile(fsFileProfile);
		
		return ForwardScanningDB.addFsFileIndex(userBean, fsFileIndex);
	}
	
	public static FsFileIndex updateFsFiles(UserBean userBean, String fileIndexId, String fileProfileId, String patno, String regId,
			String formName, String formCode, String pattype, String filePath, 
			String admDateStr, String dischargeDateStr, String dueDateStr, String importDateStr, String seq, String categoryId,
			String icdCode, String icdName, String labNum, String stnid, String key, String risAccessionNo) {
		BigDecimal fsFileIndexId = null;
		try {
			fsFileIndexId = new BigDecimal(fileIndexId);
		} catch (Exception ex) {
			return null;
		}
		
		FsFileIndex fsFileIndex = new FsFileIndex();
		fsFileIndex.setFsFileIndexId(fsFileIndexId);
		fsFileIndex.setFsPatno(patno);
		fsFileIndex.setFsRegid(regId);
		fsFileIndex.setFsFormName(formName);
		fsFileIndex.setFsPattype(pattype);
		fsFileIndex.setFsFilePath(filePath);
		fsFileIndex.setFsDueDate(DateTimeUtil.parseDate(dueDateStr));
		fsFileIndex.setFsAdmDate(DateTimeUtil.parseDate(admDateStr));
		fsFileIndex.setFsDischargeDate(DateTimeUtil.parseDate(dischargeDateStr));
		fsFileIndex.setFsImportDate(DateTimeUtil.parseDate(importDateStr));
		fsFileIndex.setFsSeq(seq);
		fsFileIndex.setFsLabNum(labNum);
		FsFileProfile fsFileProfile = new FsFileProfile();
		fsFileProfile.setFsFileProfileId(new BigDecimal(fileProfileId));
		FsCategory fsCategory = new FsCategory();
		if (categoryId != null && !"".equals(categoryId)) 
			fsCategory.setFsCategoryId(new BigDecimal(categoryId));
		fsFileProfile.setFsCategory(fsCategory);
		fsFileProfile.setFsFormCode(formCode);
		fsFileProfile.setFsIcdCode(icdCode);
		fsFileProfile.setFsIcdName(icdName);
		fsFileProfile.setFsStnid(stnid);
		fsFileProfile.setFsKey(key);
		fsFileProfile.setFsRisAccessionNo(risAccessionNo);
		fsFileIndex.setFsFileProfile(fsFileProfile);
		
		if (ForwardScanningDB.updateFsFile(userBean, fsFileIndex)) {
			return fsFileIndex;
		} else {
			return null;
		}
	}
	
	public static FsForm addFsForms(UserBean userBean,
			String formName, String formCode, String pattype, String section,
			String seq, String categoryId, String isDefault) {
		FsForm fsForm = new FsForm();
		fsForm.setFsFormName(formName);
		fsForm.setFsFormCode(formCode);
		fsForm.setFsPattype(pattype);
		fsForm.setFsSection(section);
		fsForm.setFsSeq(seq);
		fsForm.setFsIsDefault(isDefault);
		fsForm.setFsCategoryId(categoryId != null ? new BigDecimal(categoryId) : null);
		
		if (ForwardScanningDB.addFsForm(userBean, fsForm)) {
			return fsForm;
		} else {
			return null;
		}
	}
	
	public static FsForm updateFsForms(UserBean userBean, String formId,
			String formName, String formCode, String pattype, String section,
			String seq, String categoryId, String isDefault) {
		BigDecimal fsFormId = null;
		try {
			fsFormId = new BigDecimal(formId);
		} catch (Exception ex) {
			return null;
		}
		
		FsForm fsForm = new FsForm();
		fsForm.setFsFormId(fsFormId);
		fsForm.setFsFormCode(formCode);
		fsForm.setFsFormName(formName);
		fsForm.setFsPattype(pattype);
		fsForm.setFsSection(section);
		fsForm.setFsSeq(seq);
		fsForm.setFsCategoryId(categoryId != null ? new BigDecimal(categoryId) : null);
		fsForm.setFsIsDefault(isDefault);
		
		if (ForwardScanningDB.updateFsForm(userBean, fsForm)) {
			return fsForm;
		} else {
			return null;
		}
	}
	
	public void printCategoryTree() {
		printCategoryTree(true);
	}
	
	public void printCategoryTree(boolean instanceTree) {
		List<FsCategory> list;
		FsModelHelper helper = FsModelHelper.getInstance();
		if (instanceTree) {
			list = helper.getCategoryList();
		} else {
			list = helper.getGeneralCategoryList();
		}
		printCategoryTree(list, 0);
	}
		
	/**
	 * Prints out the tree structure of fsCategory.
	 * For debug only.
	 * 
	 * @param fsCategoryList
	 * @param debugLvl
	 */
	public static void printCategoryTree(List<FsCategory> fsCategoryList, int debugLvl) {
		if(fsCategoryList == null || fsCategoryList.isEmpty()) {
			return;
		}
		
		String lefPadding = "";
		for (int i = 0; i < debugLvl; i++) {
			lefPadding += " ";
		}
		
		List<FsCategory> childLvlList = null;
		FsCategory fsCategory = null;
		
		for (int i = 0; i < fsCategoryList.size(); i++) {
			fsCategory = fsCategoryList.get(i);
			childLvlList = fsCategory.getChildList();
			
			//System.out.println(lefPadding + "-> [" + fsCategory.getFsCategoryId() + "] " + fsCategory.getFsName() + 
			//		" (seq:" + fsCategory.getFsSeq() + ") " + 
			//		(childLvlList == null ? "no child" : "child size = " + childLvlList.size()) + " file size = " + fsCategory.getFsFileIndexes().size() + 
			//		", ID(" + fsCategory.toString() + ")");
			List<FsFileIndex> fileList = fsCategory.getFsFileIndexes();
			if (fileList != null) {
				for (int j = 0; j < fileList.size(); j++) {
					FsFileIndex file = fileList.get(j);
					//System.out.println(lefPadding + lefPadding + lefPadding + lefPadding +
					//		"(F):" + file.getFsFormName());
				}
			}
			
			FsModelHelper.printCategoryTree(fsCategory.getChildList(), debugLvl + 1);
		}
	}
	
	public void printThisIpPeriodGp() {
		if (multiCategoryGrp != null) {
			Set<BigDecimal> keys = multiCategoryGrp.keySet();
			Iterator<BigDecimal> itr2 = keys.iterator();
			while (itr2.hasNext()) {
				BigDecimal catId = itr2.next();
				//System.out.println("CatId: " + catId);
				List<FsCategoryInPat> cats = multiCategoryGrp.get(catId);
				for (int j = 0; j < cats.size(); j++) {
					FsCategoryInPat catIp = cats.get(j);
					//System.out.println("  ipPeriod = " + catIp.getIpPeriod());
				}
			} 
		}
	}
	
	public List<FsCategory> mapFileToCategoryTree(List<FsCategory> categoryTree, List<FsFileIndex> fileList) {
		if (categoryTree != null && fileList != null) {
			for (int i = 0; i < fileList.size(); i++) {
				FsFileIndex fileIndex = fileList.get(i);
				
				//System.out.println("FINDING fileIndex id:" + fileIndex.getFsFileIndexId() + ", cid=" + fileIndex.getFsFileProfile().getFsCategory().getFsParentCategoryId_String());
				
				boolean append = false;
				for (int j = 0; j < categoryTree.size() && !append; j++) {
					FsCategory category = categoryTree.get(j);
					append = matchFileToCategory(category, fileIndex);
				}
			}
		}
		return categoryTree;
	}
	
	private boolean matchFileToCategory(FsCategory category, FsFileIndex fileIndex) {
		if (category == null || fileIndex == null) {
			return false;
		}
		
		BigDecimal thisCategoryId = category.getFsCategoryId();
		
		boolean append = false;
		FsFileProfile fileProfile = fileIndex.getFsFileProfile();
		if (fileProfile != null) {
			FsCategory fileCategory = fileProfile.getFsCategory();
			
			if (fileCategory != null && fileCategory.getFsCategoryId() != null && 
					fileCategory.getFsCategoryId().compareTo(thisCategoryId) == 0) {

				if (category.isDyna()) {	// in multi level cat
					FsCategoryInPat catIp = (FsCategoryInPat) category;
					
					//System.out.println("    checking i: catIp admDate=" + catIp.getDisplayAdmDate()+", discDate="+catIp.getDisplayDischargeDate());

					if (catIp.equalsFile(fileIndex)) {
						 System.out.println(" MATCH a: id " + catIp.getFsCategoryId() + " title: " + catIp.getIpPeriod());
						append = true;
						category.appendFileIndex(fileIndex);
					}
				} else if (category.isUnderDyna()) {	// under multi level cat
					FsCategoryInPat catIp = (FsCategoryInPat) category;
					FsCategoryInPat parentCat = (FsCategoryInPat) getParentFsCategoryById(catIp);
					
					//System.out.println("    checking ii: catIp admDate=" + catIp.getDisplayAdmDate()+", discDate="+catIp.getDisplayDischargeDate());
					
					if (catIp != null && parentCat != null) {
						catIp.setAdmDate(parentCat.getAdmDate());
						catIp.setDischargeDate(parentCat.getDischargeDate());
						catIp.setIcdCode(parentCat.getIcdCode());
						catIp.setIcdName(parentCat.getIcdName());
					}
					
					if (catIp.equalsFile(fileIndex)) {
						// System.out.println(" MATCH b: id " + catIp.getFsCategoryId() + " title: " + catIp.getIpPeriod());
						append = true;
						category.appendFileIndex(fileIndex);
					}
				} else {
					append = true;
					// System.out.println(" MATCH c: id " + thisCategoryId + " title: " + category.getFsName());
					category.appendFileIndex(fileIndex);
				}
			}
			
			if (!append) {
				List<FsCategory> list = category.getChildList();
				if (list != null) {
					for (int i = 0; i < list.size() && !append; i++) {
						FsCategory iCategory = list.get(i);
						append = matchFileToCategory(iCategory, fileIndex);
					}
				}
			}
		}
		return append;
	}
	
	private List<FsCategory> groupFsFileIndexHKAH(List<FsCategory> category, int debugLvl, ViewMode viewMode) {
		if (category == null) 
			return category;
		
		// System.out.println("-- Level (" + debugLvl + ") --");
		
		for (int i = 0; i < category.size(); i++) {
			FsCategory curCategory = category.get(i);
			groupFsFileIndexHKAH(curCategory.getChildList(), debugLvl+1, viewMode);
			
			if (curCategory != null) {
				List<FsFileIndex> fsFileIndexes = curCategory.getFsFileIndexes();
				if (fsFileIndexes != null) {
					Map<String, FsCategory> grpCategorys = new HashMap<String, FsCategory>();
					
					for (int j = 0; j < fsFileIndexes.size(); j++) {
						FsFileIndex curFileIndex = fsFileIndexes.get(j);
						//System.out.println("    fileCode="+curFileIndex.getFsFormCode()+"-"+curFileIndex.getFsFormName());
						boolean groupFileIndex = true;
						
						String masterCode = null;
						String formName = null;
						
						BigDecimal curFileCatId = curFileIndex.getFsFileProfile().getFsCategory().getFsCategoryId();
						if (HKAH_IP_MISC_GRP_CODE.equals(curFileCatId) &&
								HKAH_IP_MISC_FORM_CODE.equals(curFileIndex.getFsFormCode())) {
							groupFileIndex = true;
						}
						if (HKAH_HIS_FORM_CODE.equals(curFileIndex.getFsFormCode())) {
							groupFileIndex = false;
						}
						
						if (groupFileIndex) {
							// special handling: OP Triage forms always group into a folder, only for non-admin mode
							if (HKAH_OP_TRIAGE_ASSESS_CODE.equals(curFileIndex.getMasterFormCode())
									&& !ViewMode.ADMIN.equals(viewMode)) {
								masterCode = HKAH_OP_TRI_ASSESS_GRP_CODE; 
								formName = curFileIndex.getFsFormName();
							} else if (HKAH_ONCOLOGY_FORM_CODE.equals(curFileIndex.getFsFormCode())) {
								masterCode = HKAH_ONCOLOGY_GRP_CODE; 
								formName = curCategory.getFsName();
							} else if (HKAH_OP_CONS_TREAT_CAT_ID.equals(curFileCatId)) {
								masterCode = HKAH_OP_CONS_TREAT_GRP_CODE; 
								formName = curCategory.getFsName();
							} else if (HKAH_RPT_LP_CAT_ID.equals(curFileCatId)) {
								masterCode = HKAH_RPT_LP_GRP_CODE; 
								formName = curCategory.getFsName();
							} else if (HKAH_OP_MISC_CAT_ID.equals(curFileCatId)) {
								masterCode = HKAH_OP_MISC_GRP_CODE; 
								formName = curCategory.getFsName();
							} else if (HKAH_RPT_PM_CAT_ID.equals(curFileCatId)) {
								masterCode = HKAH_RPT_PM_GRP_CODE; 
								formName = curCategory.getFsName();
							} else if (HKAH_RPT_CRT_D_CAT_ID.equals(curFileCatId)) {
								masterCode = HKAH_RPT_CRT_D_GRP_CODE; 
								formName = curCategory.getFsName();
							} else if (HKAH_RPT_CRT_P_CAT_ID.equals(curFileCatId)) {
								masterCode = HKAH_RPT_CRT_P_GRP_CODE; 
								formName = curCategory.getFsName();
							} else if (HKAH_RPT_ICD_CAT_ID.equals(curFileCatId)) {
								masterCode = HKAH_RPT_ICD_GRP_CODE; 
								formName = curCategory.getFsName();
							} else if (HKAH_ON_MISC_CAT_ID.equals(curFileCatId)) {
								masterCode = HKAH_ON_MISC_CAT_GRP_CODE; 
								formName = curCategory.getFsName();
							} else if (HKAH_RPT_DENTAL_CAT_ID.equals(curFileCatId)) {
								masterCode = HKAH_RPT_DENTAL_GRP_CODE; 
								formName = curCategory.getFsName();
							} else if (HKAH_IP_FEFA_CAT_ID.equals(curFileCatId)) {
								masterCode = HKAH_IP_FEFA_GRP_CODE; 
								formName = curCategory.getFsName();
							} else if (HKAH_OP_WPR_CAT_ID.equals(curFileCatId)) {
								masterCode = HKAH_OP_WPR_GRP_CODE; 
								//formName = curCategory.getFsName();	
							} else if (HKAH_IP_FEFB_CAT_ID.equals(curFileCatId)) {
								masterCode = HKAH_IP_FEFB_GRP_CODE;
							} else {
								masterCode = curFileIndex.getMasterFormCode();
								if (masterCode == null) {
									masterCode = curFileIndex.getFsFormCode();
								}
								formName = curFileIndex.getFsFormName();
							}
							
							
							FsCategory grpCat = grpCategorys.get(masterCode);
							if (grpCat == null) {
								grpCat = new FsCategory();
								// negate the category id to indicate this is the grouped form category under category id
								grpCat.setFsCategoryId(curCategory.getFsCategoryId().negate());
								grpCat.setFsParentCategoryId(curCategory.getFsCategoryId());
								grpCat.setFsName(formName);
								grpCat.appendFileIndex(curFileIndex);
								grpCat.setFsSeq(String.valueOf(j));
								
								//System.out.println(" New group, formCode = " + formCode + ", title: " + grpCat.getFsName());
								grpCategorys.put(masterCode, grpCat);
							} else {
								grpCat.appendFileIndex(curFileIndex);
							}
						}
					}
					
					Set<String> keys = grpCategorys.keySet();
					Iterator<String> itr = keys.iterator();
					while (itr.hasNext()) {
						String key = itr.next();
						FsCategory cat = grpCategorys.get(key);
						
						// System.out.println(" Group cat, title: " + cat.getFsName() + " size: " + cat.getFsFileIndexes().size());
						// special handling: DI forms always group into a folder
						// 					 OP Triage forms always group into a folder
						//	 				 4 Heart Ctr forms always group into folders
						//		 			 dental forms always group into folders
						if (cat.getFsFileIndexes().size() > 1 ||
								HKAH_RPT_DI_CAT_ID.equals(cat.getFsCategoryId().abs()) ||
								HKAH_OP_TRI_ASSESS_GRP_CODE.equals(key)
								) {
							if (HKAH_OP_CONS_TREAT_GRP_CODE.equals(key) 
									|| HKAH_RPT_LP_GRP_CODE.equals(key)
									|| HKAH_OP_MISC_GRP_CODE.equals(key)
									|| HKAH_ONCOLOGY_GRP_CODE.equals(key)
									|| HKAH_RPT_PM_GRP_CODE.equals(key)
									|| HKAH_RPT_CRT_D_GRP_CODE.equals(key)
									|| HKAH_RPT_CRT_P_GRP_CODE.equals(key)
									|| HKAH_RPT_ICD_GRP_CODE.equals(key)
									|| HKAH_ON_MISC_CAT_GRP_CODE.equals(key)
									|| HKAH_RPT_DENTAL_GRP_CODE.equals(key)
									|| HKAH_IP_FEFA_GRP_CODE.equals(key)
									|| HKAH_OP_WPR_GRP_CODE.equals(key)
									|| HKAH_IP_FEFB_GRP_CODE.equals(key)
									) {
								for (int j = 0; j < cat.getFsFileIndexes().size(); j++) {
									curCategory.appendFileIndex(cat.getFsFileIndexes().get(j));
								}
							} else {
								curCategory.appendChildCat(cat);
							}
							
							List<FsFileIndex> grpFileIndex = cat.getFsFileIndexes();
							for (int j = 0; j < grpFileIndex.size(); j++) {
								fsFileIndexes.remove(grpFileIndex.get(j));
							}
						}
					}
				}
			}
		}
		return category;
	}
	
	private List<FsCategory> expandFsCategoryTree(List<FsCategory> topLevel) {
		if (topLevel != null && multiCategoryGrp != null) {

			List<FsCategory> toBeRemove = new ArrayList<FsCategory>();
			List<FsCategory> toBeAdd = new ArrayList<FsCategory>();
			Map<Integer, List<FsCategory>> toBeAddInOrder = new HashMap<Integer, List<FsCategory>>();

			for (int i = 0; i < topLevel.size(); i++) {
				FsCategory top = topLevel.get(i);
				
				if (ConstantsVariable.YES_VALUE.equals(top.getFsIsMulti())) {
					List<FsCategoryInPat> cats = multiCategoryGrp.get(top.getFsCategoryId());
					if (cats != null) {
						toBeAdd = new ArrayList<FsCategory>();
						for (int j = 0; j < cats.size(); j++) {
							FsCategoryInPat catInpat = cats.get(j);
							
							FsCategoryInPat topInPat = FsCategoryInPat.createInstance((FsCategoryInPat) top, catInpat);
							topInPat.setFsName(topInPat.getDecodeDisplayFsName());
							toBeAdd.add(topInPat);
							toBeAddInOrder.put(i, toBeAdd);
						}
						toBeRemove.add(top);
					}
				}
			}
			Set<Integer> keys = toBeAddInOrder.keySet();
			Iterator<Integer> itr = keys.iterator();
			while (itr.hasNext()) {
				Integer index = itr.next();
				topLevel.addAll(index, toBeAddInOrder.get(index));
			}
			topLevel.removeAll(toBeRemove);
			
			for (int i = 0; i < topLevel.size(); i++) {
				expandFsCategoryTree(topLevel.get(i));
			}
		}
		return topLevel;
	}
	
	private FsCategory expandFsCategoryTree(FsCategory parent) {
		List<FsCategory> children = null;
		if (parent == null)
			return null;
		
		children = parent.getChildList();
		if (children != null && multiCategoryGrp != null) {
			List<FsCategory> toBeRemove = new ArrayList<FsCategory>();
			List<FsCategory> toBeAdd = new ArrayList<FsCategory>();
			Map<Integer, List<FsCategory>> toBeAddInOrder = new HashMap<Integer, List<FsCategory>>();
			
			for (int i = 0; i < children.size(); i++) {
				FsCategory child = children.get(i);
				
				if (ConstantsVariable.YES_VALUE.equals(child.getFsIsMulti())) {
					List<FsCategoryInPat> cats = multiCategoryGrp.get(child.getFsCategoryId());
					if (cats != null) {
						toBeAdd = new ArrayList<FsCategory>();
						for (int j = 0; j < cats.size(); j++) {
							FsCategoryInPat catInpat = cats.get(j);
							
							FsCategoryInPat childInPat = FsCategoryInPat.createInstance((FsCategoryInPat) child, catInpat);
							childInPat.setFsName(childInPat.getDecodeDisplayFsName());
							toBeAdd.add(childInPat);
							toBeAddInOrder.put(i, toBeAdd);
						}
						toBeRemove.add(child);
					}
				}
			}
			Set<Integer> keys = toBeAddInOrder.keySet();
			Iterator<Integer> itr = keys.iterator();
			while (itr.hasNext()) {
				Integer index = itr.next();
				children.addAll(index, toBeAddInOrder.get(index));
			}
			children.removeAll(toBeRemove);
			
			for (int i = 0; i < children.size(); i++) {
				FsCategory child = children.get(i);
				FsCategory retChild = expandFsCategoryTree(child);
			}
		}

		return parent;
	}
	
	/**
	 * 
	 * @param coDocscanList
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static List<FsCategory> constructFsCategoryTree(List<FsCategory> fsCategoryList, BigDecimal fsCategoryId) {
		List<FsCategory> parentLvlList = new ArrayList<FsCategory>();
		List<FsCategory> childLvlList = new ArrayList<FsCategory>();
		
		// Step 1, get a list of top level parent
		FsCategory content = null;
		for (int i = 0; i < fsCategoryList.size(); i++) {
			content = fsCategoryList.get(i);
			if (content != null) {
				if ((content.getFsParentCategoryId() == null && fsCategoryId == null) ||
						(fsCategoryId != null && fsCategoryId.equals(content.getFsParentCategoryId()))) {
					parentLvlList.add(content);
				} else {
					childLvlList.add(content);
				}
			}
		}
		
		// sort childLvlList by parent ID (Important!)
		Collections.sort(childLvlList, new Comparator<FsCategory>() {
			@Override
			public int compare(FsCategory o1, FsCategory o2) {
				// TODO Auto-generated method stub
				BigDecimal pid1 = o1.getFsParentCategoryId();
				BigDecimal pid2 = o2.getFsParentCategoryId();
				return (pid1 == null ? 0 : pid1.intValue()) - (pid2 == null ? 0 : pid2.intValue());
			}
		});
		
		// Step 2, add child to their parent
		for (int i = 0; i < childLvlList.size(); i++) {
			wrapFsCategoryChild(parentLvlList, childLvlList.get(i), 0);
		}
		
		for (int i = 0; i < parentLvlList.size(); i++) {
			FsCategory c = parentLvlList.get(i);
		}
		
		return parentLvlList;
	}
	
	private static void wrapFsCategoryChild(List<FsCategory> fsCategoryList, 
			FsCategory content, int debug_level) {
		if (fsCategoryList == null || content == null) {
			return;
		}
		
		BigDecimal id = null;
		if (content != null && content.getFsParentCategoryId() != null) {
			id = content.getFsParentCategoryId();
			
			FsCategory parent = null;
			List<FsCategory> childList = null;
			boolean isFound = false;
			// Find content's parent and wrap it in 
			for (int i = 0; i < fsCategoryList.size() && !isFound; i++) {
				parent = fsCategoryList.get(i);
				if (parent != null) {
					childList = parent.getChildList();
					
					if (id.compareTo(parent.getFsCategoryId()) == 0) {
						// Parent matched
						if (childList == null) {
							childList = new ArrayList<FsCategory>();
						}
						childList.add(content);
						parent.setChildList(childList);
						isFound = true;
					} else {
						// Parent not matched, recursive to find the immediate parent until deepest level is reached
						wrapFsCategoryChild(childList, content, debug_level+1);
					}
				}
			}
			
			if (isFound) {
				boolean removeSuccess = fsCategoryList.remove(content);
			}
		}
	}
	
	public boolean removeEmptyBranch(List<FsCategory> categoryTree) {
		if (categoryTree == null) 
			return true;
		
		List<FsCategory> toBeRemove = new ArrayList<FsCategory>();
		for (int i = 0; i < categoryTree.size(); i++) {
			FsCategory category = categoryTree.get(i);
			
			if (category.getFsFileIndexes() == null || category.getFsFileIndexes().isEmpty()) {
				if (category.getChildList() != null && !category.getChildList().isEmpty()) {
					if (removeEmptyBranch(category.getChildList())) {
						//System.out.println(" == remove: " + category.getFsName() + ", " + category.getFsCategoryId());
						toBeRemove.add(category);
					}
				} else {
						//System.out.println(" == remove: " + category.getFsName() + ", " + category.getFsCategoryId());
						toBeRemove.add(category);
				}
			} else {
				removeEmptyBranch(category.getChildList());
			}
		}
		
		categoryTree.removeAll(toBeRemove);
		
		if (categoryTree.isEmpty()) {
			return true;
		} else {
			return false;
		}
	}
	
	public FsCategory getFsCategoryById(BigDecimal categoryId) {
		return getFsCategoryById(this.getCategoryList(), categoryId);
	}
	
	public static FsCategory getFsCategoryById(List<FsCategory> categoryTree, BigDecimal categoryId) {
		if (categoryTree == null || categoryTree.isEmpty() || categoryId == null) {
			return null;
		}
		
		for (int i = 0; i < categoryTree.size(); i++) {
			FsCategory category = categoryTree.get(i);
			FsCategory ret = null;
			if (category != null && categoryId.compareTo(category.getFsCategoryId()) == 0) {
				return category;
			} else {
				ret = getFsCategoryById(category.getChildList(), categoryId);
			}
			
			if (ret != null)
				return ret;
		}
		return null;
	}
	
	public FsCategory getParentFsCategoryById(FsCategory childCat) {
		return getParentFsCategoryById(this.getCategoryList(), childCat);
	}
	
	public FsCategory getParentFsCategoryById(List<FsCategory> categoryTree, FsCategory childCat) {
		if (categoryTree == null || categoryTree.isEmpty() || childCat == null) {
			return null;
		}
		
		BigDecimal cid = childCat.getFsCategoryId();
		if (cid != null) {
			for (int i = 0; i < categoryTree.size(); i++) {
				FsCategory category = categoryTree.get(i);
				List<FsCategory> children = category.getChildList();
				
				for (int j = 0; j < children.size(); j++) {
					FsCategory iChild = children.get(j);
					if (iChild != null && cid.compareTo(iChild.getFsCategoryId()) == 0) {
						if (iChild.isUnderInPat() && childCat.isUnderInPat()) {
							FsCategoryInPat iChildIP = (FsCategoryInPat) iChild;
							FsCategoryInPat childCatIP = (FsCategoryInPat) childCat;
							if (iChildIP.equalsCategory(childCatIP)) {
								return category;
							}
						} else {
							return category;
						}
					}
				}
				
				FsCategory ret = getParentFsCategoryById(children, childCat);
				if (ret != null) {
					return ret;
				}
			}
		}
		return null;
	}
	
	
	public static String getFsCategoryTreeHTML(List<FsCategory> list, FsCategory itemCategory, boolean isEditable, LinkedHashMap<String, String> catBreadCrumb) {
		if (list == null)
			return null;
		
		StringBuffer outputStr = new StringBuffer();
		
		for (int i = 0; i < list.size(); i++) {
			FsCategory category = list.get(i);
			if (category != null) {
				String categoryTitle = category.getFsName();
				List<FsCategory> children = category.getChildList();
				List<FsFileIndex> fsFileIndexes = category.getFsFileIndexes();
				FsFileIndex fsFileIndex = null;
				if (fsFileIndexes != null && fsFileIndexes.size() > 0) {
					fsFileIndex = fsFileIndexes.get(0);
				}
				
				boolean isSelected = false;
				boolean isAlongPath = false;
				String categoryId = null;
				if (category != null && category.getFsCategoryId() != null) {
					categoryId = category.getFsCategoryId().toPlainString();
					if (itemCategory != null && itemCategory.getFsCategoryId() != null) {
						isSelected = category.getFsCategoryId().equals(itemCategory.getFsCategoryId());
					}
					if (catBreadCrumb != null && catBreadCrumb.get(categoryId) != null) {
						isAlongPath = true;
					}
				}
				
				
				outputStr.append("<li name=\"bc" + categoryId + "\" class=\"" + (isAlongPath ? "open" : "closed") + (isSelected ? " highlight" : " normal") + "\">");
				outputStr.append("<span class=\"folder" + (isSelected ? " matchedCat" : "") + "\">");
				if (isEditable) {
					outputStr.append("<input type=\"radio\" id=\"catsel" + categoryId + "\" name=\"categorySelect\" value=\"" + categoryId + "\" " + 
							(isSelected ? "checked=\"checked\"" : "")+ " />" + categoryTitle);
				} else {
					outputStr.append(categoryTitle);
				}
				outputStr.append("</span>");
				
				if (children != null && children.size() > 0) {
					outputStr.append("<ul>");
					outputStr.append(getFsCategoryTreeHTML(children, itemCategory, isEditable, catBreadCrumb));
					outputStr.append("</ul>");
				}
				
				outputStr.append("</li>");
			}
		}
		
		return outputStr.toString();
	}

	public static LinkedHashMap<String, String> getCategoryBreadCrumb(List<FsCategory> list, String itemCategoryId) {
		for (int i = 0; i < list.size(); i++) {
			FsCategory category = list.get(i);
			LinkedHashMap<String, String> ret = matchCategory(category, itemCategoryId);
			if (ret != null)
				return ret;
		}
		return null;
	}

	private static LinkedHashMap<String, String> matchCategory(FsCategory category, String itemCategoryId) {
		if (itemCategoryId == null)
			return null;
		
		String thisCatId = category.getFsCategoryId().toPlainString();
		String thisCatTitle = category.getFsName();
		if (itemCategoryId.equals(thisCatId)) {
			LinkedHashMap<String, String> ret = new LinkedHashMap<String, String>();
			ret.put(thisCatId, thisCatTitle);
			return ret;
		} else {
			List<FsCategory> children = category.getChildList();
			LinkedHashMap<String, String> ret = null;
			for (int i = 0; i < children.size(); i++) {
				FsCategory child = children.get(i);
				LinkedHashMap<String, String> childRet = matchCategory(child, itemCategoryId);
				if (childRet != null) {
					ret = new LinkedHashMap<String, String>();
					ret.put(thisCatId, thisCatTitle);
					ret.putAll(childRet);
					return ret;
				}
			}
		}
		return null;
	}
	
	//====================================//
	// Import file index csv 
	//====================================//
	public static String[] indexFileHeader = new String[]{
		"Patient Code",
		"Doc Creation Date",
		"Form Code",
		"Document Filename with Full Path",
		"File Doc Type",
		"Reg ID",
		"Document Sequence Number",
		"Adm Date",
		"Discharge Date",
		"Replace Code",
		"Lab Num",
		"Station ID"
	};
	
	public static List<FsFileCsv> loadFileCsv(String filePath) {
		List<FsFileCsv> fileCsvs = null;
		try {
			File file = new File(filePath);
			fileCsvs = loadFileCsv(file);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return fileCsvs;
	}
	/*
	public static List<FsFileCsv> loadFileCsv(File file) {
		List<FsFileCsv> fileCsvs = null;
		try {
			if (file.isFile()) {
				fileCsvs = loadFileCsv(file);
			}
			
			//if (deleteSrcFile)
			//	FileUtils.forceDelete(file);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return fileCsvs;
	}
	*/
	public static List<FsFileCsv> loadFileCsv(File file) {
		if (file == null || !file.isFile())
			return null;
		
		List<FsFileCsv> fileCsvs = new ArrayList<FsFileCsv>();
		CSVReader reader = null;
		try {
			reader = new CSVReader(new FileReader(file));
			boolean hasHeader = true;
			String[] nextLine = null;
			String[] headers = null;
			String[] values = null;
			int colSize = IMPORT_CSV_COL_SIZE;
			FsFileCsv fileCsv = null;
			while ((nextLine = reader.readNext()) != null) {
				// read header
				if (hasHeader) {
					if (nextLine != null) {
						headers = new String[colSize];
						for (int i = 0; i < colSize; i++) {
							if (i < nextLine.length)
								headers[i] = nextLine[i];
						}
					}
					hasHeader = false;
				} else {
					StringBuffer paramStr = new StringBuffer();
					int dataColSize = 0;
					values = new String[colSize];
					for (int i = 0; i < colSize; i++) {
						try {
							values[i] = nextLine[i];
							dataColSize = i + 1;
						} catch (Exception ex) {}
						
						// construct query string parameters
						if (paramStr.length() > 0)
							paramStr.append("&");
						if (headers != null && i < headers.length) {
							paramStr.append(headers[i]);
							paramStr.append("=");
						}
						if (values[i] != null)
							paramStr.append(values[i]);
					}
					
					fileCsv = new FsFileCsv();
					fileCsv.setPatientCode(StringUtils.trim(values[0]));
					String docCreationDateStr = values[1];
					if (docCreationDateStr != null) {
						fileCsv.setDocCreationDate(DateTimeUtil.parseDate(docCreationDateStr));
					}
					
					// support bar code type: code 3 of 9 (no start end) (* at the begining and ending)
					String formCode = StringUtils.trim(values[2]);
					if (formCode != null) {
						if (formCode.startsWith("*") && formCode.endsWith("*")) {
							formCode = formCode.substring(1, formCode.length() - 1);
						}
						formCode = formCode.trim();
					}
					
					
					fileCsv.setFormCode(formCode);
					fileCsv.setFilePath(StringUtils.trim(values[3]));
					fileCsv.setFileDocType(StringUtils.trim(values[4]));
					fileCsv.setRegID(StringUtils.trim(values[5]));
					String docSeqNoStr = StringUtils.trim(values[6]);
					try {
						fileCsv.setDocSeqNo(new Integer(docSeqNoStr));
					} catch (Exception e) {
					}
					String admDateStr = values[7];
					if (docCreationDateStr != null) {
						fileCsv.setAdmDate(DateTimeUtil.parseDate(admDateStr));
					}
					String dischargeDateStr = values[8];
					if (docCreationDateStr != null) {
						fileCsv.setDischargeDate(DateTimeUtil.parseDate(dischargeDateStr));
					}
					String replaceCode = StringUtils.trim(values[9]);
					try {
						fileCsv.setReplaceCode(new Integer(replaceCode));
					} catch (Exception e) {
					}
					
					fileCsv.setLabNum(StringUtils.trim(values[10]));
					fileCsv.setParamStr(paramStr.toString());
					fileCsv.setStationId(values[11]);
					fileCsvs.add(fileCsv);
				}
			}
		} catch (ArrayIndexOutOfBoundsException e) {
			System.err.println("Forward Scanning: The loaded file is not a valid csv index file.");
		} catch (FileNotFoundException e) {
			// TODO Auto-generated catch block
			System.err.println("Forward Scanning: The loaded file is not found.");
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			if (reader != null)
				try {
					reader.close();
				} catch (IOException e) {
				}
		}

		return fileCsvs;
	}
	
	public static Integer[] infoCodes(List<FsFileCsv> fsFileCsvs) {
		List<Integer> retList = new ArrayList<Integer>();
		
		if (fsFileCsvs != null) {
			for (int i = 0; i < fsFileCsvs.size(); i++) {
				FsFileCsv csv = fsFileCsvs.get(i);
				
				if (ConstantsServerSide.isHKAH() &&
						csv.isFormBelongsTo(HKAH_PED_SOH_SCL_CODE, null)) {
					retList.add(2);
				}
			}
		}
		if (!isFormExceeded6(fsFileCsvs)) {
			retList.add(9);
		}
		if (!isFormExceeded7(fsFileCsvs)) {
			retList.add(10);
		}
		if (!isFormExists1(fsFileCsvs)) {
			retList.add(11);
		}
		if (ConstantsServerSide.isHKAH() && !isFormExists10(fsFileCsvs)) {
			retList.add(12);
		}
		
		retList.addAll(isFormExists(fsFileCsvs));
		return retList.toArray(new Integer[retList.size()]);
	}
	
	public static Integer[] invalidCodes(List<FsFileCsv> fsFileCsvs) {
		List<Integer> retList = new ArrayList<Integer>();
		
		if (fsFileCsvs != null) {
			for (int i = 0; i < fsFileCsvs.size(); i++) {
				FsFileCsv csv = fsFileCsvs.get(i);
				if (!csv.isValidated()) {
					retList.add(-1);
				}
			}
		}
		
		if (!isCsvPatientNoAllSame(fsFileCsvs)) {
			retList.add(-2);
			
		}
		if (!isCsvFormCodeNotExist(fsFileCsvs)) {
			retList.add(-3);
		}
		if (!isFormExceeded(fsFileCsvs)) {
			retList.add(-4);
		}
		if (!isFormExceeded4(fsFileCsvs)) {
			retList.add(-7);
		}
		if (!isFormExceeded5(fsFileCsvs)) {
			retList.add(-8);
		}
		if (!isRegIdNotMatch(fsFileCsvs)) {
			retList.add(-9);
		}
		if (!isFormExceeded8(fsFileCsvs)) {
			retList.add(-10);
		}
		if (!isFormExceeded9(fsFileCsvs)) {
			retList.add(-11);
		}		
		return retList.toArray(new Integer[retList.size()]);
	}
	
	public static boolean isCsvPatientNoAllSame(List<FsFileCsv> fsFileCsvs) {
		boolean valid = true;
		if (fsFileCsvs != null) {
			Set<String> patientNos = new HashSet<String>();
			for (int i = 0; i < fsFileCsvs.size(); i++) {
				FsFileCsv csv = fsFileCsvs.get(i);
				if (i > 0 && !patientNos.contains(csv.getPatientCode())) {
					csv.setDiffPatCodeFromBatch(true);
					valid = false;
				} else {
					patientNos.add(csv.getPatientCode());
				}
			}
		}
		return valid;
	}
	
	public static boolean isCsvFormCodeNotExist(List<FsFileCsv> fsFileCsvs) {
		boolean valid = true;
		if (fsFileCsvs != null) {
			for (int i = 0; i < fsFileCsvs.size(); i++) {
				FsFileCsv csv = fsFileCsvs.get(i);
				if (!csv.isFormCodeValid()) {
					csv.setInvalidFormCode(true);
					valid = false;
				}
			}
		}
		return valid;
	}
	
	public static boolean isFormExceeded(List<FsFileCsv> fsFileCsvs) {
		boolean valid = true;
		Map<String, Integer> rows = new HashMap<String, Integer>();
		
		if (fsFileCsvs != null) {
			for (int i = 0; i < fsFileCsvs.size(); i++) {
				FsFileCsv csv = fsFileCsvs.get(i);
				String formCode = csv.getFormCode();
				
				// hard code
				// PABD-MBB14 - Consent to Collection of data
				if (ConstantsServerSide.isHKAH()) {
					if (HKAH_CONSENT_COLL_DATA_CODE.equals(formCode)) {
						String fileDocType = csv.getFileDocType();
						String key = null;
						
						if ("I".equals(fileDocType)) {
							String admDate = csv.getAdmDateDisplay();
							String dischDate = csv.getDischargeDateDisplay();
							
							key = HKAH_CONSENT_COLL_DATA_CODE + "_" + 
									fileDocType + "_" + 
									admDate + "_" + 
									dischDate;
						} else {
							key = HKAH_CONSENT_COLL_DATA_CODE + "_" + fileDocType;
						}
						
						Integer cnt = rows.get(key);
						if (cnt == null) {
							cnt = new Integer(0);
						} else {
							cnt++;
						}
						if (cnt != null && cnt > 0) {
							valid = false;
						}
						// System.out.println("DEBUG: key="+key+", cnt="+cnt);
						rows.put(key, cnt);
					}
				}
			}
		}
		return valid;
	}
	
	public static boolean isFormExceeded2(List<FsFileCsv> fsFileCsvs) {
		boolean valid = true;
		Map<String, Integer> rows = new HashMap<String, Integer>();
		
		if (fsFileCsvs != null) {
			FsFileCsv csv = fsFileCsvs.get(0);
			String patno = csv.getPatientCode();
			
			for (int i = 0; i < fsFileCsvs.size(); i++) {
				csv = fsFileCsvs.get(i);
				String formCode = csv.getFormCode();
				
				// hard code
				if (ConstantsServerSide.isHKAH()) {
					// NUAD-MFA02 - Physician orders 
					if (HKAH_PHY_ORDER_CODE.equals(formCode) || HKAH_PHY_ORDER_CODE2.equals(formCode)) {
						String fileDocType = csv.getFileDocType();
						String key = null;
						
						if ("I".equals(fileDocType)) {
							key = HKAH_PHY_ORDER_CODE + "_" + 
									fileDocType;
						}
						
						Integer cnt = rows.get(key);
						if (cnt == null) {
							cnt = new Integer(0);
						} else {
							cnt++;
						}
						if (cnt != null && cnt > 0) {
							valid = false;
						}
						rows.put(key, cnt);
					}
				}
			}
		}
		return valid;
	}
	
	public static List<Integer> isFormExists(List<FsFileCsv> fsFileCsvs) {
		Integer[] cnt = new Integer[]{0, 0, 0};
		List<Integer> infoCodes = new ArrayList<Integer>();
		
		if (fsFileCsvs != null) {
			FsFileCsv csv = fsFileCsvs.get(0);
			
			for (int i = 0; i < fsFileCsvs.size(); i++) {
				csv = fsFileCsvs.get(i);
				String formCode = csv.getFormCode();
				String patType = csv.getFileDocType();
				
				if (ConstantsServerSide.isHKAH()) {
					if (HKAH_BRON_CODE.equals(formCode) || HKAH_BRON_CODE2.equals(formCode)) {
						cnt[0] += 1;
					}
					if (PAT_TYPE_CODE_IP.equalsIgnoreCase(patType) && 
							(HKAH_HR_FALL_REASSES.equals(formCode) || HKAH_HR_FALL_REASSES2.equals(formCode))) {
						cnt[1] += 1;
					}
					if (HKAH_ABDOMINAL_PAIN.equals(formCode) || HKAH_ABDOMINAL_PAIN2.equals(formCode)) {
						cnt[2] += 1;
					}
				}
			}
			if (cnt[0] > 0) {
				infoCodes.add(6);
			}
			if (cnt[1] > 0) {
				infoCodes.add(7);
			}
			if (cnt[2] > 0) {
				infoCodes.add(8);
			}
		}
		return infoCodes;
	}
	
	public static boolean isFormExceeded3(List<FsFileCsv> fsFileCsvs) {
		boolean valid = true;
		Map<String, Integer> rows = new HashMap<String, Integer>();
		
		if (fsFileCsvs != null) {
			FsFileCsv csv = fsFileCsvs.get(0);
			String patno = csv.getPatientCode();
			int cnt = 0;
			
			for (int i = 0; i < fsFileCsvs.size(); i++) {
				csv = fsFileCsvs.get(i);
				String formCode = csv.getFormCode();
				
				// hard code
				if (ConstantsServerSide.isHKAH()) {
					// Bronchoscopy
					if (HKAH_BRON_CODE.equals(formCode) || HKAH_BRON_CODE2.equals(formCode)) {
						cnt++;
					}
				}
			}
			if (cnt > 0) {
				valid = false;
			}
		}
		return valid;
	}
	
	public static boolean isFormExceeded4(List<FsFileCsv> fsFileCsvs) {
		boolean valid = true;
		Map<String, Integer> rows = new HashMap<String, Integer>();
		
		if (fsFileCsvs != null) {
			for (int i = 0; i < fsFileCsvs.size(); i++) {
				FsFileCsv csv = fsFileCsvs.get(i);
				String formCode = csv.getFormCode();
				
				if (ConstantsServerSide.isHKAH()) {
					if (HKAH_DISC_SUMM.equals(formCode) || 
							HKAH_DISC_SUMM2.equals(formCode) ||
							HKAH_DISC_SUMM3.equals(formCode) ||
							HKAH_DISC_SUMM4.equals(formCode)) {
						String fileDocType = csv.getFileDocType();
						String key = null;
						
						if ("I".equals(fileDocType)) {
							String admDate = csv.getAdmDateDisplay();
							String dischDate = csv.getDischargeDateDisplay();
							
							key = HKAH_DISC_SUMM + "_" + 
									fileDocType + "_" + 
									admDate + "_" + 
									dischDate;
						} else {
							key = HKAH_DISC_SUMM + "_" + fileDocType;
						}
						
						Integer cnt = rows.get(key);
						if (cnt == null) {
							cnt = new Integer(0);
						} else {
							cnt++;
						}
						if (cnt != null && cnt > 0) {
							valid = false;
						}
						// System.out.println("DEBUG: key="+key+", cnt="+cnt);
						rows.put(key, cnt);
					}
				}
			}
		}
		return valid;
	}
	
	public static boolean isFormExceeded5(List<FsFileCsv> fsFileCsvs) {
		boolean valid = true;
		Map<String, Integer> rows = new HashMap<String, Integer>();
		
		if (fsFileCsvs != null) {
			for (int i = 0; i < fsFileCsvs.size(); i++) {
				FsFileCsv csv = fsFileCsvs.get(i);
				String formCode = csv.getFormCode();
				
				if (ConstantsServerSide.isHKAH()) {
					if (HKAH_INP_ADM_FORMS.contains(formCode)) {
						String fileDocType = csv.getFileDocType();
						String key = null;
						
						if ("I".equals(fileDocType)) {
							String admDate = csv.getAdmDateDisplay();
							String dischDate = csv.getDischargeDateDisplay();
							
							key = HKAH_INP_ADM_FORMS.get(0) + "_" + 
									fileDocType + "_" + 
									admDate + "_" + 
									dischDate;
						} else {
							key = HKAH_INP_ADM_FORMS.get(0) + "_" + fileDocType;
						}
						
						Integer cnt = rows.get(key);
						if (cnt == null) {
							cnt = new Integer(0);
						} else {
							cnt++;
						}
						if (cnt != null && cnt > 0) {
							valid = false;
						}
						// System.out.println("DEBUG: key="+key+", cnt="+cnt);
						rows.put(key, cnt);
					}
				}
			}
		}
		return valid;
	}
	
	public static boolean isFormExceeded6(List<FsFileCsv> fsFileCsvs) {
		boolean valid = true;
		//Map<String, Integer> rows = new HashMap<String, Integer>();
		
		if (fsFileCsvs != null) {
			for (int i = 0; i < fsFileCsvs.size() && valid; i++) {
				FsFileCsv csv = fsFileCsvs.get(i);
				String formCode = csv.getFormCode();
				
				if (ConstantsServerSide.isHKAH()) {
					if (HKAH_INP_TRI_FORMS.contains(formCode) && "O".equals(csv.getFileDocType())) {
						valid = false;
						
						// System.out.println("isFormExceeded6 false formCode="+formCode+", pattype="+csv.getFileDocType());
						//rows.put(key, cnt);
					}
				}
			}
		}
		return valid;
	}
	
	public static boolean isFormExceeded7(List<FsFileCsv> fsFileCsvs) {
		boolean valid = true;
		Map<String, Integer> rows = new HashMap<String, Integer>();
		
		if (fsFileCsvs != null) {
			for (int i = 0; i < fsFileCsvs.size(); i++) {
				FsFileCsv csv = fsFileCsvs.get(i);
				String formCode = csv.getFormCode();
				
				if (ConstantsServerSide.isHKAH()) {
					if (HKAH_INP_TRI_RISK_FORMS.contains(formCode)) {
						String fileDocType = csv.getFileDocType();
						String key = null;
						
						if ("I".equals(fileDocType)) {
							String patno = csv.getPatientCode();
							String admDate = csv.getAdmDateDisplay();
							String dischDate = csv.getDischargeDateDisplay();
							
							key = "HKAH_INP_TRI_RISK_FORMS" + "_" + 
									patno + "_" + 
									fileDocType + "_" + 
									admDate + "_" + 
									dischDate;

							Integer cnt = rows.get(key);
							if (cnt == null) {
								cnt = new Integer(0);
							} else {
								cnt++;
							}
							if (cnt != null && cnt > 0) {
								valid = false;
							}
							
							// System.out.println("[isFormExceeded7] DEBUG: key="+key+", cnt="+cnt);
							rows.put(key, cnt);
						}
					}
				}
			}
		}
		return valid;
	}
	
	public static boolean isFormExceeded8(List<FsFileCsv> fsFileCsvs) {
		boolean valid = true;
		Map<String, Integer> rows = new HashMap<String, Integer>();
		
		if (fsFileCsvs != null) {
			for (int i = 0; i < fsFileCsvs.size(); i++) {
				FsFileCsv csv = fsFileCsvs.get(i);
				String formCode = csv.getFormCode();
				
				if (ConstantsServerSide.isHKAH()) {
					if (HKAH_PAT_DISCH_INS.contains(formCode)) {
						String fileDocType = csv.getFileDocType();
						String key = null;
						
						if ("I".equals(fileDocType)) {
							String admDate = csv.getAdmDateDisplay();
							String dischDate = csv.getDischargeDateDisplay();
							
							key = HKAH_PAT_DISCH_INS.get(0) + "_" + 
									fileDocType + "_" + 
									admDate + "_" + 
									dischDate;
						} else {
							key = HKAH_PAT_DISCH_INS.get(0) + "_" + fileDocType;
						}
						
						Integer cnt = rows.get(key);
						if (cnt == null) {
							cnt = new Integer(0);
						} else {
							cnt++;
						}
						if (cnt != null && cnt > 0) {
							valid = false;
						}
						rows.put(key, cnt);
					}
				}
			}
		}
		return valid;
	}
	
	public static boolean isFormExceeded9(List<FsFileCsv> fsFileCsvs) {
		boolean valid = true;
		Map<String, Integer> rows = new HashMap<String, Integer>();
		
		if (fsFileCsvs != null) {
			for (int i = 0; i < fsFileCsvs.size(); i++) {
				FsFileCsv csv = fsFileCsvs.get(i);
				String formCode = csv.getFormCode();
				
				if (ConstantsServerSide.isHKAH()) {
					if (HKAH_ADM_NUR_DBA.contains(formCode)) {
						String fileDocType = csv.getFileDocType();
						String key = null;
						
						if ("I".equals(fileDocType)) {
							String admDate = csv.getAdmDateDisplay();
							String dischDate = csv.getDischargeDateDisplay();
							
							key = HKAH_ADM_NUR_DBA.get(0) + "_" + 
									fileDocType + "_" + 
									admDate + "_" + 
									dischDate;
						} else {
							key = HKAH_ADM_NUR_DBA.get(0) + "_" + fileDocType;
						}
						
						Integer cnt = rows.get(key);
						if (cnt == null) {
							cnt = new Integer(0);
						} else {
							cnt++;
						}
						if (cnt != null && cnt > 0) {
							valid = false;
						}
						// System.out.println("DEBUG: key="+key+", cnt="+cnt);
						rows.put(key, cnt);
					}
				}
			}
		}
		return valid;
	}
	
	public static boolean isFormExists1(List<FsFileCsv> fsFileCsvs) {
		boolean valid = true;
		Map<String, Set<String>> rows = new HashMap<String, Set<String>>();
		boolean exist1 = false;
		
		if (fsFileCsvs != null) {
			for (int i = 0; i < fsFileCsvs.size(); i++) {
				FsFileCsv csv = fsFileCsvs.get(i);
				String formCode = csv.getFormCode();
				
				if (ConstantsServerSide.isHKAH()) {
					if (HKAH_INP_NUR_REASS_MS_FORMS.contains(formCode)) {
						String fileDocType = csv.getFileDocType();
						String key = null;
						
						if ("I".equals(fileDocType)) {
							String admDate = csv.getAdmDateDisplay();
							String dischDate = csv.getDischargeDateDisplay();
							
							key = fileDocType + "_" + 
									admDate + "_" + 
									dischDate;
						} else {
							key = fileDocType;
						}
						
						Set<String> values = rows.get(key);
						if (values == null) {
							values = new HashSet<String>();
						}
						values.add(HKAH_INP_NUR_REASS_MS_FORMS.get(0));
						rows.put(key, values);
						
						exist1 = true;
					}
					
					if (HKAH_INP_NUT_RISK_SCR_FORMS.contains(formCode)) {
						String fileDocType = csv.getFileDocType();
						String key = null;
						
						if ("I".equals(fileDocType)) {
							String admDate = csv.getAdmDateDisplay();
							String dischDate = csv.getDischargeDateDisplay();
							
							key = fileDocType + "_" + 
									admDate + "_" + 
									dischDate;
						} else {
							key = fileDocType;
						}
						
						Set<String> values = rows.get(key);
						if (values == null) {
							values = new HashSet<String>();
						}
						values.add(HKAH_INP_NUT_RISK_SCR_FORMS.get(0));
						rows.put(key, values);
					}
				}
			}
			
			if (exist1) {
				//System.out.println("isExists HKAH_INP_NUR_REASS_MS_FORMS");
				
				Set<String> keys = rows.keySet();
				Iterator<String> itr = keys.iterator();
				while (itr.hasNext()) {
					String key = itr.next();
					Set<String> vals = rows.get(key);
					
					//System.out.println("  key="+key);
					//System.out.println("  contain HKAH_INP_NUR_REASS_MS_FORMS="+vals.contains(HKAH_INP_NUR_REASS_MS_FORMS.get(0)));
					//System.out.println("  contain HKAH_INP_NUT_RISK_SCR_FORMS="+vals.contains(HKAH_INP_NUT_RISK_SCR_FORMS.get(0)));
					
					if (vals.contains(HKAH_INP_NUR_REASS_MS_FORMS.get(0)) && 
							!vals.contains(HKAH_INP_NUT_RISK_SCR_FORMS.get(0))) {
						valid = false;
					}
				}
			}
		}
		return valid;
	}
	
	
	public static boolean isFormExists10(List<FsFileCsv> fsFileCsvs) {
		boolean valid = true;

		Map<String, Integer> rows = new HashMap<String, Integer>();
		Map<String, Map<String, Integer>> regs = new HashMap<String, Map<String, Integer>>();
		
		if (fsFileCsvs != null) {
			for (int i = 0; i < fsFileCsvs.size(); i++) {
				boolean contains1 = false;
				boolean contains2 = false;
				FsFileCsv csv = fsFileCsvs.get(i);
				String formCode = csv.getFormCode();
				
				if (HKAH_CCL_PROCEDURE_FORMS.contains(formCode)) {
					contains1 = true;
				}
				if (HKAH_PERI_OP_NFC_FORMS.contains(formCode)) {
					contains2 = true;
				}
				
				if (contains1 || contains2) {
					String fileDocType = csv.getFileDocType();
					String regKey = null;
					String key = contains1 ? HKAH_CCL_PROCEDURE_FORMS.get(0) : HKAH_PERI_OP_NFC_FORMS.get(0);
					
					if ("I".equals(fileDocType)) {
						String admDate = csv.getAdmDateDisplay();
						String dischDate = csv.getDischargeDateDisplay();
						
						regKey = fileDocType + "_" + 
								admDate + "_" + 
								dischDate;
					} else {
						regKey = fileDocType;
					}
					
					Map<String, Integer> thisRow = regs.get(regKey);
					thisRow = thisRow == null ? new HashMap<String, Integer>() : thisRow; 
					Integer cnt = thisRow.get(key);
					
					if (cnt == null) {
						cnt = new Integer(0);
					} else {
						cnt++;
					}

					thisRow.put(key, cnt);
					regs.put(regKey, thisRow);
					
					if (thisRow != null && thisRow.size() > 1) {
						valid = false;
					}
					// System.out.println("DEBUG: key="+key+", cnt="+cnt);
				}
			}
		}
		return valid;
	}
	
	public static boolean isRegIdNotMatch(List<FsFileCsv> fsFileCsvs) {
		boolean valid = true;
		Map<String, Integer> rows = new HashMap<String, Integer>();
		
		if (fsFileCsvs != null) {
			for (int i = 0; i < fsFileCsvs.size(); i++) {
				FsFileCsv csv = fsFileCsvs.get(i);
				
				if (csv.getRegID() != null && !csv.getRegID().trim().isEmpty()) {
					try {
						BigDecimal bd = new BigDecimal(csv.getRegID());
						
						List<ReportableListObject> result = ForwardScanningDB.getAdmInfoByRegId(csv.getRegID());
						if (!result.isEmpty()) {
							ReportableListObject row = result.get(0);
							String patnoFromRegID = row.getFields0();
							String admDateFromRegID = row.getFields2();
							String dischargeDateFromRegID = row.getFields3();
							
							if (patnoFromRegID != null && !patnoFromRegID.equals(csv.getPatientCode())) {
								csv.addInvalidCode(INVCODE_REGID + ":" + "PATNO");
								valid = false;
							}
							if (admDateFromRegID != null && !admDateFromRegID.equals(csv.getAdmDateDisplay())) {
								csv.addInvalidCode(INVCODE_REGID + ":" + "ADMDATE");
								valid = false;
							}
							if (dischargeDateFromRegID != null && !dischargeDateFromRegID.equals(csv.getDischargeDateDisplay())) {
								csv.addInvalidCode(INVCODE_REGID + ":" + "DISCHARGEDATE");
								valid = false;
							}
						} else {
							csv.addInvalidCode(INVCODE_REGID + ":" + "REGID");
							valid = false;	
						}
					} catch (NumberFormatException ex) {
						System.err.println("FsModelHelper.isRegIdNotMatch Reg ID is not a valid number: " + csv.getRegID());
					}
				}
			}
		}
		return valid;
	}
	
	public List<FsFileCsv> importAll(UserBean userBean, String filePath) {
		List<FsFileCsv> fileCsvs = null;
		try {
			File file = new File(filePath);
			fileCsvs = importAll(userBean, file);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return fileCsvs;
	}
	
	public List<FsFileCsv> importAll(UserBean userBean, File file) {
		List<FsFileCsv> fileCsvs = null;
		try {
			fileCsvs = FsModelHelper.loadFileCsv(file);
			if (fileCsvs != null)
				fileCsvs = FsModelHelper.importFsFile(userBean, fileCsvs, file.getName());
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return fileCsvs;
	}
	
	/*
	 * importFsFile
	 * 
	 * 3 types of index (same index fields)
	 * A) Normal form index
	 * B) Lab (Histopathology form index)
	 * C) Oncology
	 * ------------------------------------
	 * A) Index csv file must have non-empty Patient Code field,
	 *    otherwise, it will throw alert message
	 * 
	 * B) Index csv file must have non-empty Lab Num field
	 *    Patient Code must be empty,
	 *    otherwise, it will throw alert message
	 */
	public static List<FsFileCsv> importFsFile(UserBean userBean, List<FsFileCsv> fileCsvs, String fileName) {
		if (fileCsvs == null)
			return null;
		
		Date importDate = Calendar.getInstance().getTime();
		String importBatchNo = ForwardScanningDB.getNextFsBatchNo();
		int total = fileCsvs.size();
		boolean isUnqiuePatient = fileCsvPatientSet(fileCsvs).size() == 1;
		List<BigDecimal> ids = ForwardScanningDB.getNextFsFileIndexIds(total);
		
		System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + 
				" [FsModelHelper] importFsFile fileCsvs size="+total+
				", ids size="+ids.size()+", importBatchNo="+importBatchNo+
				", importDate="+DateTimeUtil.formatDateTimeStandard(importDate));
		
		logBatch(userBean, importBatchNo, fileName);
		
		for (int i = 0; i < total; i++) {
			FsFileCsv fileCsv = fileCsvs.get(i);
			boolean success = false;
			boolean isLab = false;
			
			FsFileIndex fsFileIndex = null;
			String description = "";
			try {
				String labNum = fileCsv.getLabNum();
				String patientCode = fileCsv.getPatientCode();
				if (labNum != null && !"".equals(labNum)) {
					isLab = true;
					description += "Referral lab form(HIS).";
				}
				
				FsForm form = ForwardScanningDB.getFsFormByFsFileCsv(fileCsv);
				String categoryId = ForwardScanningDB.getMatchedCategoryId(fileCsv);
				
				fsFileIndex = new FsFileIndex();
				fsFileIndex.setFsFileIndexId(ids.get(i));
				//System.out.println("  ids("+i+")="+ids.get(i));
				
				fsFileIndex.setFsImportDate(importDate);
				fileCsv.setImportDate(importDate);
				
				if (isLab) {
					String hospnum = ForwardScanningDB.getLisHospnumByLabNum(labNum);
					if (patientCode != null && !patientCode.isEmpty() && !patientCode.equals(hospnum)) {
						// PatientCode is not empty and conflict with hospnum fetch from LIS by labnum
						description += "Patient Code: " + patientCode + " not MATCH with LIS (" + hospnum + "). Make sure it is correct, otherwise, leave field blank.";
						throw new Exception(description);
					} else {
						fsFileIndex.setFsPatno(hospnum);
					}
				} else {
					if (patientCode == null || "".equals(patientCode)) {
						// PatientCode is empty
						description += "Patient Code is empty.";
						throw new Exception(description);
					} else {
						fsFileIndex.setFsPatno(patientCode);
					}
				}
				// TESTING 2013-11-27 preserve original seq not implemented
				/*
				if ("13711441".equals(labNum)) {
					fsFileIndex.setFsPatno("500023");
				}
				// TESTING END
				 */
				fsFileIndex.setFsLabNum(labNum);
				
				if (fileCsv.getRegID() != null && !"".equals(fileCsv.getRegID())) {
					try {
						new BigDecimal(fileCsv.getRegID());
					} catch (Exception e) {
						// RegId is not a number
						description += "Reg ID format is invalid.";
						throw new Exception(description);
					}
				}
				fsFileIndex.setFsRegid(fileCsv.getRegID());
				
				FsCategory fsCategory = new FsCategory();
				if (categoryId != null) {
					fsCategory.setFsCategoryId(new BigDecimal(categoryId));
				} else {
					// fail to map to any tree, should throw error
					// update (12-Jan-2012): allow no mapping to any category
					description += "Warning: No category matched.";
				}
				
				// SPECIAL SCENARIO for HKAH DI reports:
				// If manual import, the date is not the document date, 
				// the sort order in the tree mixed with auto import will be incorrect.
				// In normal case, no manual scan for DI report, but sometimes it needs 
				// manaul scan, so set docuemnt date of these manual scan DI report (DIAG-MOF01) forms 
				// before auto import effective date is from 24 April 2013 00:00, to avoid sorting problem.
				// (requested by Jason - MR 2013 April 24)
				//
				// For lab reports, set docuemnt date of these manual scan report (CLAB-MOA01x) forms 
				// before auto import effective date from 21 Aug 2017 00:00, to avoid sorting problem.
				// (requested by Jason - MR 2017 August 28)
				Date docDate = null;
				if (ConstantsServerSide.isHKAH() && HKAH_DI_REPORT_CODE.equals(form.getFsFormCode())) {
					Calendar cal = Calendar.getInstance();
					cal.set(Calendar.YEAR, 2013);
					cal.set(Calendar.MONTH, Calendar.APRIL);
					cal.set(Calendar.DATE, 23);
					cal.set(Calendar.HOUR_OF_DAY, 0);
					cal.set(Calendar.MINUTE, 0);
					cal.set(Calendar.SECOND, 0);
					docDate = cal.getTime(); 
					
					description += " Document Date is set to 24 April 2013 (Original is " + DateTimeUtil.formatDate(fileCsv.getDocCreationDate()) + ")";
				} else if (ConstantsServerSide.isHKAH() && HKAH_RPT_LP_CAT_ID.equals(fsCategory.getFsCategoryId()) && 
						form != null && 
						((form.getFsFormCode().startsWith(HKAH_LAB_RPT_PREFIX) && (form.getFsFormCode().contains(HKAH_LAB_RPT_MOE01))) ||
								HKAH_OLAB_FORM_CODE.equals(form.getFsFormCode())
						)) {
					Calendar cal = Calendar.getInstance();
					cal.set(Calendar.YEAR, 2017);
					cal.set(Calendar.MONTH, Calendar.AUGUST);
					cal.set(Calendar.DATE, 20);
					cal.set(Calendar.HOUR_OF_DAY, 0);
					cal.set(Calendar.MINUTE, 0);
					cal.set(Calendar.SECOND, 0);
					docDate = cal.getTime(); 
					
					description += " Document Date is set to 20 August 2017 (Original is " + DateTimeUtil.formatDate(fileCsv.getDocCreationDate()) + ")";
				/*
				-- rule removed, requested by Jason - MR 2020 Oct 27)
				} else if (ConstantsServerSide.isHKAH() && 
						(HKAH_OP_REG_FORM.equals(form.getFsFormCode()) || HKAH_OP_REG_FORM2.equals(form.getFsFormCode())) &&
						isUnqiuePatient) {
					Calendar cal = Calendar.getInstance();
					cal.set(Calendar.YEAR, 2016);
					cal.set(Calendar.MONTH, Calendar.FEBRUARY);
					cal.set(Calendar.DATE, 2);
					cal.set(Calendar.HOUR_OF_DAY, 0);
					cal.set(Calendar.MINUTE, 0);
					cal.set(Calendar.SECOND, 0);
					docDate = cal.getTime(); 
					
					description += " Document Dae is set to 02 Feb 2016 (Original is " + DateTimeUtil.formatDate(fileCsv.getDocCreationDate()) + ")";
				*/
				} else {
					docDate = fileCsv.getDocCreationDate();
				}
				
				fsFileIndex.setFsDueDate(docDate);
				fsFileIndex.setFsAdmDate(fileCsv.getAdmDate());
				fsFileIndex.setFsDischargeDate(fileCsv.getDischargeDate());
				if (form != null)
					fsFileIndex.setFsFormName(form.getFsFormName());
				fsFileIndex.setFsFilePath(fileCsv.getFilePath());
				String sid = fileCsv.getStationId();
				if (sid == null || sid.isEmpty()) {
					sid = SID2srcHost.get(SYS_CODE_SRC_HOST_SID_DEF);
				}
				fsFileIndex.setStationId(sid);
				try {
					transferScannedFile(fsFileIndex);
				} catch (Exception e) {
					// fail to move the scanned file to permanent store place
					//description = "Cannot move the scanned file to permanent store place.";
					description += e.getMessage();
					throw new Exception(description);
				}
				
				fsFileIndex.setFsPattype(fileCsv.getFileDocType());
				if (fileCsv.getDocSeqNo() != null)
					fsFileIndex.setFsSeq(fileCsv.getDocSeqNo().toString());
				fsFileIndex.setFsCreatedUser(userBean.getLoginID());
				fsFileIndex.setFsModifiedUser(userBean.getLoginID());
				
				// get ICD code and name on the fly
				/*
				String icdCode = null;
				String icdName = null;
				ArrayList icdList = ForwardScanningDB.getIcdList(fileCsv.getRegID());
				if (icdList != null && !icdList.isEmpty()) {
					ReportableListObject row = (ReportableListObject) icdList.get(0);
					icdCode = row.getValue(1);
					icdName = row.getValue(2);
				}
				*/
				
				FsFileProfile fsFileProfile = new FsFileProfile();
				fsFileProfile.setFsFileIndex(fsFileIndex);
				//fsFileProfile.setFsIcdCode(icdCode);
				//fsFileProfile.setFsIcdName(icdName);
				if (isLab) {
					if (!HKAH_HIS_FORM_CODE.equals(fileCsv.getFormCode())) {
						description += " Form with labnum but not HIS."; 
					}
				}
				fsFileProfile.setFsFormCode(fileCsv.getFormCode());

				fsFileProfile.setFsCategory(fsCategory);
				fsFileIndex.setFsFileProfile(fsFileProfile);
				
				// SPECIAL SCENARIO for HKAH Referral Lab (HIS)
				// if there is already Referral Lab form with same labnum, deprecate all the previous ones.
				// 2013-11-15
				Set<String> prevHisFIds = new LinkedHashSet<String>();
				if (ConstantsServerSide.isHKAH() && isLab) {
					ArrayList prev = ForwardScanningDB.getPrevFileIndexByLabNum(labNum);
					for (int j = 0; j < prev.size(); j++) {
						ReportableListObject row = (ReportableListObject) prev.get(j);
						prevHisFIds.add(row.getValue(0));
						String prevPatno = row.getValue(1);
						
						//fsFileIndex.setFsApprovedUser(approvedUser);
						//fsFileIndex.setFsApprovedDate(DateTimeUtil.parseDateTime(approvedDate));
						if (fsFileIndex.getFsPatno() != null &&
								!fsFileIndex.getFsPatno().equals(prevPatno)) {
							description += " Warning: previous patient no. is different: (" + prevPatno +").";
						}
					}
				}
				
				if ("Y".equals(SID2srcHost.get("is_auto_approve"))) {
					fsFileIndex.setFsApprovedUser(userBean.getLoginID());
					fsFileIndex.setFsApprovedDate(importDate);
				}
				
				fsFileIndex = ForwardScanningDB.addFsFileIndex(userBean, fsFileIndex);
				if (fsFileIndex != null) {
					if (isLab) {
						String prevHisFidsStr = StringUtils.join(prevHisFIds, ",");
						if (ForwardScanningDB.deprecateFsFile(userBean, prevHisFidsStr)) {
							// 2013-11-27 preserve original seq not implemented
							description += "Deprecate previous HIS form (file index id: " + 
								prevHisFidsStr + ").";
						} else {
							description += "Failed to deprecate previous HIS form (file index id: " + 
							prevHisFidsStr + ").";
						}
					}
					
					fileCsv.setImported(true);
					success = true;
				} else {
					// fail to insert file index record to database
					description = "Cannot save file index record.";
					throw new Exception(description);
				}
			} catch (Exception ex) {
				description = ex.getMessage();
				System.err.println("[FsModelHelper] importFsFile error: " + description);
				ex.printStackTrace();
				success = false;
			}
			
			logImport(userBean, fsFileIndex, fileCsv, importBatchNo, success, description);
		}

		return fileCsvs;
	}
	
	protected static FsImportLog logImport(UserBean userBean, FsFileIndex fsFileIndex, FsFileCsv fileCsv, 
			String importBatchNo, boolean success, String description) {
		if (fileCsv == null || fsFileIndex == null)
			return null;
		
		FsImportLog fsImportLog = new FsImportLog();
		if (success) {
			fsImportLog.setFsFileIndexId(fsFileIndex.getFsFileIndexId());
		} else {
			fsImportLog.setFsFileIndexId(null);
		}
		fsImportLog.setFsBatchNo(importBatchNo == null ? null : new BigDecimal(importBatchNo));
		fsImportLog.setFsImportDate(fsFileIndex.getFsImportDate());
		fsImportLog.setFsEncodedParams(fileCsv.getParamStr());
		fsImportLog.setFsDescription(description);
		fsImportLog.setFsCreatedUser(userBean.getLoginID());
		
		return ForwardScanningDB.addFsImportLog(userBean, fsImportLog);
	}
	
	protected static FsImportBatch logBatch(UserBean userBean, String importBatchNo, String fileName) {
		if (importBatchNo == null)
			return null;
		
		FsImportBatch fsImportBatch = new FsImportBatch();
		fsImportBatch.setFsBatchNo(importBatchNo == null ? null : new BigDecimal(importBatchNo));
		fsImportBatch.setFsIndexFileName(fileName);
		
		return ForwardScanningDB.addFsImportBatch(userBean, fsImportBatch);
	}
	
	public static boolean updateImportLogHandle(UserBean userBean, String importLogId, boolean isHandled, String handledDesc) {
		try {
			if (ForwardScanningDB.updateImportLogHandle(userBean, importLogId, isHandled, handledDesc)) {
				return true;
			} else {
				return false;
			}
		} catch (Exception ex) {
			return false;
		}

	}
	
	public static FsFileIndex transferScannedFile(FsFileIndex fsFileIndex) throws Exception {
		//System.out.println("DEBUG: transferScannedFile : " + fsFileIndex);
		if (fsFileIndex == null)
			return null;
		
		String srcPath = fsFileIndex.getFsFilePath();
		// decode scanned files, use host ip if the path point to local drive
		String filePrefix = FilenameUtils.getPrefix(srcPath); 
		if (fsFileIndex.getStationID() != null && !fsFileIndex.getStationID().isEmpty()) {
			if (filePrefix != null && !filePrefix.startsWith("\\\\")) {
				String srcHost = SID2srcHost.get(SYS_CODE_SRC_HOST + "." + fsFileIndex.getStationID());
				if (srcHost == null) {
					throw new Exception("Cannot find file src host");
				}
				srcPath = srcPath.replace(filePrefix, "\\\\" + srcHost + "\\");
			}
		}
		String descPath = storeScannedFile(srcPath, fsFileIndex.getFsPatno(), fsFileIndex.getStationID());
		fsFileIndex.setFsFilePath(descPath);
		
		return fsFileIndex;
	}
	
	public static String storeScannedFile(String srcFilePath, String patno, String stationID) throws Exception {
		if (srcFilePath == null)
			throw new Exception("File path is empty.");
		String newPath = null;
		String descSubPath = null;
		
		File srcFile = new File(srcFilePath);
		File destFile = null;
		if (srcFile.exists()) {
			String srcTruePath = srcFile.getCanonicalPath();
			String destHost = SID2srcHost.get(SYS_CODE_DEST_HOST_PATH);
			if (stationID != null && !stationID.isEmpty()) {
				int index = FilenameUtils.getPrefixLength(srcTruePath);
				
				if (index >= 0) {
					descSubPath = srcTruePath.substring(index);
					for (int i = 1; i < SCAN_SUB_PATH_START_LEVEL; i++) {
						if (descSubPath != null) {
							int levelIndex = descSubPath.indexOf(File.separator);
							if (levelIndex >= 0) {
								descSubPath = descSubPath.substring(levelIndex);
							}
						}
					}
				}
				if (destHost == null) {
					throw new Exception("Cannot find store file path");
				}
				destFile = new File(destHost  + descSubPath);
			} else {
				descSubPath = FilenameUtils.getName(srcTruePath);
				
				// html file upload 
				destFile = new File(destHost + getStorageFilePath(descSubPath, patno));
			}
			
			if (ServerUtil.isUseSamba(destFile.getPath())) {
				newPath = FileUtil.moveFileLinuxToWin(srcFile.getPath(), destFile.getPath(), 
						SID2srcHost.get("smb_username"), SID2srcHost.get("smb_password"), true, true);
			} else {
				FileUtils.copyFile(srcFile, destFile);
				newPath = destFile.getPath();
			}
		} else {
			throw new Exception("Cannot find file: " + srcFilePath);
		}
		//System.out.println("DEBUG: storeScannedFile move scan pdf form : " + srcFilePath + " to " + newPath);
		return newPath;
	}
	
	public static String getStorageFilePath(String subPath, String patno) {
		String ret = null;
		
		// AMC2 or other sites use /<patno>/<original file name>
		ret = (patno == null || patno.isEmpty() ? "" : patno + "\\") + subPath;
		
		return ret;
	}
	
	public static File moveToTempFolder(String sessionId, String filePath, boolean clearDestFolder) throws Exception {
		// move to temp folder
		File csvFile = new File(filePath);
		File destFolder = new File(MODULE_UPLOAD_PATH_TEMP + File.separator + sessionId);
		if (clearDestFolder) {
			if (destFolder.exists() && destFolder.isDirectory()) {
				FileUtils.cleanDirectory(destFolder);
			}
		}
		File destFile = new File(MODULE_UPLOAD_PATH_TEMP + File.separator + sessionId + File.separator + csvFile.getName());
		if (destFile.exists()) {
			FileUtils.forceDelete(destFile);
		}
		FileUtils.moveFile(csvFile, destFile);
		//System.out.println("DEBUG: file is moved to: " + destFile.getAbsolutePath());
		return destFile;
	}
	
	public static void backupBatchImportFile(String sessionId, String batchNo) throws Exception {
		String srcFolderPath = MODULE_UPLOAD_PATH_TEMP + File.separator + sessionId;
		File srcFolder = new File(srcFolderPath);
		if (srcFolder != null) {
			File[] files = srcFolder.listFiles();
			for (File file : files) {
				File destFile = new File(MODULE_UPLOAD_PATH + File.separator + batchNo + File.separator + file.getName());
				if (destFile.exists()) {
					FileUtils.forceDelete(destFile);
				}
				FileUtils.moveFile(file, destFile);
			}
		}
		// delete temp folder
		deleteTempImportFile(sessionId);
		//System.out.println("DEBUG: backupBatchImportFile (Batch No:"+batchNo+") done.");
	}
	
	public static void clearAllTempImportFiles() {
		String fileFullPath = MODULE_UPLOAD_PATH_TEMP;
		
		try {
			File folder = new File(fileFullPath);
			if (folder.exists() && folder.isDirectory()) {
				File[] files = folder.listFiles();
				for (File file : files) {
					FileUtils.forceDelete(file);
				}
			}
		} catch (Exception e) {
			logger.error("Cannot delete all containing files/directories in : " + fileFullPath);
		}
	}
	
	public static boolean deleteTempImportFile(String subTempFolderName) {
		String fileFullPath = MODULE_UPLOAD_PATH_TEMP + File.separator + subTempFolderName;
		boolean success = false;
		
		try {
			File folder = new File(fileFullPath);
			if (folder.exists() && folder.isDirectory()) {
				FileUtils.forceDelete(folder);
				success = true;
			}
		} catch (Exception e) {
			logger.error("Cannot delete directories and its containing files/directories: " + fileFullPath);
			e.printStackTrace();
		}
		//System.out.println("DEBUG: clearTempImportFile (subTempFolderName = "+subTempFolderName+")");
		return success;
	}
	
	public static Map<String, String> getImportFileNamePaths(String batchNo) {
		if (batchNo == null || "".equals(batchNo.trim()))
			return null;
		
		Map<String, String> paths = new HashMap<String, String>();
		String suffixPath = File.separator + batchNo;
		File folder = new File(MODULE_UPLOAD_PATH + suffixPath);
		if (folder.isDirectory()) {
			File[] files = folder.listFiles();
			for (File file : files) {
				paths.put(file.getName(), 
						File.separator + "Upload" + File.separator + MODULE_UPLOAD_SUBPATH + File.separator + suffixPath + File.separator + file.getName());
			}
		}
		return paths;
	}
	
	public static List<String> duplicateBatchs(String fileName) {
		if (fileName == null || "".equals(fileName.trim()))
			return null;
		
		List<String> existBatchNos = new ArrayList<String>();
		File uploadBasePath = new File(MODULE_UPLOAD_PATH);
		String[] fileNames = uploadBasePath.list();
		for (int i = 0; i < fileNames.length; i++) {
			String fName = fileNames[i];
			File file = new File(MODULE_UPLOAD_PATH + File.separator + fName);
			if (file.isDirectory()) {
				String[] subFileNames = file.list();
				for (int j = 0; j < subFileNames.length; j++) {
					String subFName = subFileNames[j];
					if (fileName.equals(subFName)) {
						existBatchNos.add(fName);
					}
				}
			} else {
				if (fileName.equals(fName)) {
					existBatchNos.add(fName);
				}
			}
			file = null;
		}
		
		return existBatchNos;
	}
	
	public static String getTreeEntryDisplayTitle(FsFileIndex fsFileIndex, String viewModeStr, 
			FsCategory fsCategory, int size, int i) {
		String fileName = "";
		
		if (fsCategory != null 
				&& (fsCategory.getFsCategoryId().intValue() < 0 
						|| (ConstantsServerSide.isHKAH() && fsCategory.isOpConsTreat())
						|| (ConstantsServerSide.isHKAH() && fsCategory.isRptLb())
						|| (ConstantsServerSide.isHKAH() && fsCategory.isOpMisc())
						|| (ConstantsServerSide.isHKAH() && fsCategory.isOncology() && HKAH_ONCOLOGY_FORM_CODE.equals(fsFileIndex.getFsFormCode()))
						|| (ConstantsServerSide.isHKAH() && HKAH_HIS_CAT_ID.equals(fsCategory.getFsCategoryId())))
						|| (ConstantsServerSide.isHKAH() && 
								(HKAH_RPT_PM_CAT_ID.equals(fsCategory.getFsCategoryId()) ||
								HKAH_RPT_CRT_D_CAT_ID.equals(fsCategory.getFsCategoryId()) ||
								HKAH_RPT_CRT_P_CAT_ID.equals(fsCategory.getFsCategoryId()) ||
								HKAH_RPT_ICD_CAT_ID.equals(fsCategory.getFsCategoryId()) ||
								HKAH_ON_MISC_CAT_ID.equals(fsCategory.getFsCategoryId()) ||
								HKAH_RPT_DENTAL_CAT_ID.equals(fsCategory.getFsCategoryId()) ||
								HKAH_IP_FEFA_CAT_ID.equals(fsCategory.getFsCategoryId()) ||
								HKAH_OP_WPR_CAT_ID.equals(fsCategory.getFsCategoryId()) ||
								HKAH_IP_FEFB_CAT_ID.equals(fsCategory.getFsCategoryId())
								)
							)
				) {
		    if (ConstantsServerSide.isHKAH() 
		    		&& (fsCategory.isOpConsTreat() 
		    				|| fsCategory.isRptLb())) {
				String formName = fsFileIndex.getFsFormName();
				fileName = String.valueOf(size - i) + " - " + formName;
		    } else if (ConstantsServerSide.isHKAH() && fsCategory.isOpMisc()) {
		    	fileName = String.valueOf(size - i);
		    } else if (ConstantsServerSide.isHKAH() && HKAH_HIS_CAT_ID.equals(fsCategory.getFsCategoryId())) {
		    	// format e.g.: Scanned: Feb 25, 2013 <doc date>
		    	String dateStr = null;
		    	if (fsFileIndex.getFsDueDate() != null) {
		    		dateStr = displayDateFormatMiddleEndianShort.format(fsFileIndex.getFsDueDate());
		    	} else {
		    		dateStr = "No date provided";
		    	}
		    	String labnumStr = fsFileIndex.getFsLabNum() == null ? "" : " (Lab#:" + (fsFileIndex.getFsFileProfile().getFsKey() != null && !fsFileIndex.getFsFileProfile().getFsKey().isEmpty() ? fsFileIndex.getFsFileProfile().getFsKey() : fsFileIndex.getFsLabNum()) + ")";
		    	String replaceStr = "";
		    	// not show in LIVE mode, because it has been replaced by newer version
		    	if (fsFileIndex.getFsEnabled() == 2) {
		    		replaceStr = " [R]";
		    	}
		    	fileName = "Scanned: " + dateStr + labnumStr + replaceStr;
		    } else if (fsCategory.isUnderOP()) {
				fileName = String.valueOf(size - i);
			} else if (fsCategory.isUnderInPat() ||
					HKAH_RPT_DENTAL_CAT_ID.equals(fsCategory.getFsCategoryId())) {
				fileName = String.valueOf(i + 1);
			} else if (fsCategory.isUnderLab()) {
				fileName = String.valueOf(size - i);
			} else {
				fileName = String.valueOf(size - i);
			}
		} else {
			fileName = fsFileIndex.getTreeDisplayName();
		}
		
		
		if (fsFileIndex.getFsFileProfile().isRisAutoImport()) {
			if (ViewMode.ADMIN.toString().equalsIgnoreCase(viewModeStr)) {
				fileName += " [AUTO] ";
			} else if (ViewMode.DEBUG.toString().equalsIgnoreCase(viewModeStr)) {
				fileName += " [AUTO (stnid:" + fsFileIndex.getFsFileProfile().getFsStnid() + ")] ";
			}
		} else if (fsFileIndex.getFsFileProfile().isLisAutoImport()) {
			if (ViewMode.ADMIN.toString().equalsIgnoreCase(viewModeStr)) {
				fileName += " [AUTO] ";
			} else if (ViewMode.DEBUG.toString().equalsIgnoreCase(viewModeStr)) {
				fileName += " [AUTO (LIS key:" + fsFileIndex.getFsFileProfile().getFsKey() + ")] ";
			}
		}
		
		return fileName;
	}
	
	public static List<FsCategory> getCategoryAncestors(FsCategory fsCategory) {
		if (fsCategory == null) {
			return null;
		}
		
		FsModelHelper helper = FsModelHelper.getInstance();
		List<FsCategory> catList = helper.getCategoryList(false, false);
		List<FsCategory> ancestors = new ArrayList<FsCategory>();
		if (catList != null) {
			for (int i = 0; i < catList.size(); i++) {
				FsCategory cat = catList.get(i);
				
				List<FsCategory> temp = getCategoryAncestor(cat, fsCategory);
				if (temp != null && !temp.isEmpty()) {
					ancestors.addAll(temp);
				}
			}
		}
		
		return ancestors;
	}
	
	private static List<FsCategory> getCategoryAncestor(FsCategory curCat, FsCategory subject) {
		if (curCat == null || subject == null) {
			return null;
		}
		
		List<FsCategory> descendants = new ArrayList<FsCategory>();
		
		BigDecimal subjCatId = subject.getFsCategoryId();
		if (subjCatId.intValue() < 0)
			subjCatId = subjCatId.negate();
		
		if (curCat.getFsCategoryId().equals(subjCatId)) {
			// System.out.println("  MATCHED  id:" + curCat.getFsCategoryId());
			descendants.add(curCat);
		} else {
			List<FsCategory> children = curCat.getChildList();
			if (children != null) {
				for (int i = 0; i < children.size(); i++) {
					FsCategory cat = children.get(i);
					//System.out.println(" find:" + cat.getFsCategoryId_String());
					
					List<FsCategory> temp = getCategoryAncestor(cat, subject);
					if (temp != null && !temp.isEmpty()) {
						descendants.addAll(temp);
						descendants.add(curCat);
					}
					/*
					if (pid.equals(cat.getFsCategoryId())) {
						ancestors.addAll(getCategoryAncestor(cat));
					}
					*/
				}
			}
		}
		return descendants;
	}
	
	public static String getFullPdfToImagePath(String tempPdfPath) {
		if (tempPdfPath == null) {
			return null;
		}
		return ConstantsServerSide.TEMP_FOLDER + MODULE_PATH + tempPdfPath;
	}
	
	public static String getTempPdfToImagePath(String pdfPath) {
		return getTempPdfToImagePath(pdfPath, false, true, null);
	}
	
	public static String getTempPdfToImagePath(String pdfPath, int page) {
		return getTempPdfToImagePath(pdfPath, false, true, page);
	}
	
	public static String getTempPdfToImagePath(String pdfPath, boolean fullPath, boolean withFileExt, Integer page) {
		if (pdfPath == null)
			return null;
		
		int slashIdx = pdfPath.lastIndexOf("/");
		if (slashIdx < 0)
			slashIdx = pdfPath.lastIndexOf("\\");
		String path = pdfPath.substring(0, slashIdx);
		String fileName = pdfPath.substring(slashIdx, pdfPath.lastIndexOf("."));
		if (page != null) {
			fileName += page.toString();
		}
		String outputPath = path + fileName;
		
		// for security reason, do not release full output path to client
		String ret = null;
		if (fullPath) {
			ret = ConstantsServerSide.TEMP_FOLDER + MODULE_PATH + outputPath;
		} else {
			ret = outputPath;
		}
		
		if (withFileExt) {
			ret += "." + DOC_IMAGE_TYPE;
		}
		return ret;
	}
	
	public static void createPdfImage(String[] fileIndexIds) {
		ArrayList list = ForwardScanningDB.getFileIndexFilePath(fileIndexIds);
		for (int i = 0; i < list.size(); i++) {
			ReportableListObject row = (ReportableListObject) list.get(i);
			String filePath = row.getValue(1);
			
			if (filePath != null) {
				String outputPathWithFileName = "";
				try {
					int slashIdx = filePath.lastIndexOf("/");
					if (slashIdx < 0)
						slashIdx = filePath.lastIndexOf("\\");
					String path = filePath.substring(0, slashIdx);
					String outputPath = ConstantsServerSide.TEMP_FOLDER + MODULE_PATH + path;
					outputPathWithFileName = getTempPdfToImagePath(filePath, true, false, null);
					
					FileUtils.forceMkdir(new File(outputPath));
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				try {
					Converter.convertPdfToImage(filePath, outputPathWithFileName, 100);
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}
	}
	
	public static void clearAllPreviewImages() {
		try {
			FileUtils.deleteDirectory(new File(ConstantsServerSide.TEMP_FOLDER + MODULE_PATH));
		} catch (Exception e) {
			logger.error("Cannot delete forward scanning preview images directories in : " + ConstantsServerSide.TEMP_FOLDER + MODULE_PATH);
		}
	}
	
	//=============================//
	// document view tree utils
	//=============================//
	public static String treeDisplayNameRemark(FsFileIndex fsFileIndex, String viewModeStr) {
		String ret = "";
		if (ViewMode.DEBUG.toString().equalsIgnoreCase(viewModeStr) || 
				ViewMode.ADMIN.toString().equalsIgnoreCase(viewModeStr)) {
			if (!fsFileIndex.isApproved())
			ret += "(NOT APPROVE)";
		}
		return ret;
	}

	public static String treeAction(FsFileIndex fsFileIndex, String viewMode) {
		StringBuffer ret = new StringBuffer();
		if (ViewMode.ADMIN.toString().equalsIgnoreCase(viewMode)) {
			// Disable approve button from 27 May 2013
			/*
			if (!fsFileIndex.isApproved()) {
				ret += "<button onclick=\"return submitAction('approve', 1, '" + fsFileIndex.getFsFileIndexId() + "');\">Approve</button>";
			}
			*/
			ret.append("<button onclick=\"return submitAction('view', 1, '" + fsFileIndex.getFsFileIndexId() + "');\">View</button>");
		}
		return ret.toString();
	}
	
	public static String downloadZip(String ids, String viewMode, String categoryTitle) {
		StringBuffer ret = new StringBuffer();
		if (ViewMode.ADMIN.toString().equalsIgnoreCase(viewMode)) {
			ret.append("<button style=\"font-size: 12px\"onclick=\"return submitAction('downloadImages', 1, '"+ ids +"', '"+categoryTitle+"');\">Zip</button>");
		}
		return ret.toString();
	}

	public static boolean checkApprove(FsCategory category,String viewMode){
		boolean haveNotApprove = false;
		
		if (category != null) {
			List<FsCategory> children = category.getChildList();
			List<FsFileIndex> fsFileIndexes = category.getFsFileIndexes();
			FsFileIndex fsFileIndex = null;
			if (fsFileIndexes != null && fsFileIndexes.size() > 0) {
				fsFileIndex = fsFileIndexes.get(0);
			}
			
			if (children != null && children.size() > 0) {
				for(FsCategory c : children){
					haveNotApprove = checkApprove(c, viewMode);
					if(haveNotApprove){
						return haveNotApprove;
					}
					
				}
			}
			if (fsFileIndexes != null) {
				for (int j = 0; j < fsFileIndexes.size(); j++) {
					fsFileIndex = fsFileIndexes.get(j);					
					if("(NOT APPROVE)".equals(treeDisplayNameRemark(fsFileIndex, viewMode))){
						haveNotApprove = true;
						return haveNotApprove;
					}
				}
			}		
		}
		
		return haveNotApprove;	
	}
	
	public static boolean revertApprove(UserBean userBean, FsFileIndex fsFileIndex) {
		if (fsFileIndex != null) {
			return ForwardScanningDB.revertApprove(userBean, fsFileIndex.getFsFileIndexId().toPlainString());
		}	
		return false;
	}

	public static String getFsItemTree(List<FsCategory> list, String viewMode, String patNo,String admDate, String dischargeDate) {
		StringBuffer outputStr = new StringBuffer();
		
		Random rand = null;
		for (int i = 0; i < list.size(); i++) {
			FsCategory category = list.get(i);
			boolean haveNotApprove = checkApprove(category,viewMode);
			
			if (category != null) {
				try{
					FsCategoryInPat inpatCategory = (FsCategoryInPat) category;
					admDate = inpatCategory.getDisplayAdmDate();
					dischargeDate = inpatCategory.getDisplayDischargeDate();
				} catch (Exception e){
					
				}
				
				String categoryTitle = category.getFsName();	

				BigDecimal fsCategoryId = category.getFsCategoryId();
				List<FsCategory> children = category.getChildList();
				String prtCat = fsCategoryId.toPlainString();
				if (children != null && children.size() > 0) {
					FsCategory child = children.get(0);
					if(child.getFsCategoryId().intValue() > 0){
						prtCat += ", " + child.getFsCategoryId();
					}
				}
				List<FsFileIndex> fsFileIndexes = category.getFsFileIndexes();
				FsFileIndex fsFileIndex = null;
				Long s2 = 0l;
				String prtFileIndex = "";
				if (fsFileIndexes != null && fsFileIndexes.size() > 0) {
					fsFileIndex = fsFileIndexes.get(0);
					s2 = Long.parseLong(fsFileIndex.getFsFileIndexId().toPlainString());
				}
				ArrayList fileList = ForwardScanningDB.getFileParentCat(parseViewMode(viewMode), patNo, false, true, prtCat);
				for (int j = 0; j < fileList.size(); j++) {
					ReportableListObject row = (ReportableListObject) fileList.get(j);
					if(j != 0 ) prtFileIndex += ",";
					prtFileIndex += row.getValue(0);
				}
				
				Long s0 = (new Date()).getTime();
				Long s1 = Long.parseLong(category.getFsCategoryId_String());
				rand = new Random(s0 + s1 - s2);
				String suffix = String.valueOf(Math.abs(rand.nextLong()));
				//System.out.println("DEBUG *** seedT="+seedT + ", suffix="+suffix+", cid=" + fsCategoryId);
				String catCssName = "c" + fsCategoryId + suffix;
				
				outputStr.append("<li class=\"closed\">");
				outputStr.append("<span class=\"folder\" style=\"font-weight: bold;\">" + categoryTitle +
							"<span class=\"file_remarks\"> " +(haveNotApprove?"(NOT APPROVE)":"")+"</span>");
				if(!(category.getFsParentCategoryId() != null  && category.getFsParentCategoryId().compareTo(BigDecimal.ZERO) != 0)){
					outputStr.append(downloadZip(prtFileIndex, viewMode, categoryTitle));
				}
				outputStr.append("</span>");
				// group action
				if (ViewMode.DEBUG.toString().equals(viewMode)) {
					if (fsFileIndexes != null && fsFileIndexes.size() > 1) {
						outputStr.append("<input name=\"" + catCssName + "\" class=\"sortBtn\" type=\"button\" />");
						outputStr.append("<input name=\"" + catCssName + "-update\" class=\"sortUpdateBtn\" type=\"button\" value=\"Save\" />");
					}
				}
				
				
				// mix group category and single fileIndex together
				int seqCount = 0;
				List<FsCategory> grpChildren = new ArrayList<FsCategory>();
				if (children != null) {
					for (int j = 0; j < children.size(); j++) {
						FsCategory child = children.get(j);
						if (child.getFsCategoryId().intValue() < 0) {
							// this includes grouped files, must follow current level fileIndex sequence
							child.getFsSeq();
						}
					}
				}
				
				// 1. sub-categories				
				outputStr.append("<ul>");
				outputStr.append(getFsItemTree(children, viewMode, patNo, admDate, dischargeDate));				
				outputStr.append("</ul>");
				
				// 2. immediate child file indexes
				if (fsFileIndexes != null) {
					int cnt = fsFileIndexes.size();
					HashMap<String, String> combinedFormCodeAndId = new HashMap<String, String>();
					
					for (int j = 0; j < fsFileIndexes.size(); j++) {
						fsFileIndex = fsFileIndexes.get(j);
						FsFileProfile fsFileProfile = fsFileIndex.getFsFileProfile();
						String filePath = null;
						try {
							filePath = URLEncoder.encode(fsFileIndex.getFsFilePath(), "UTF-8");
						} catch (Exception e) {
							filePath = fsFileIndex.getFsFilePath();
						}
						
						outputStr.append("<ul>");
						
						boolean alreadyDisplay = false;						
						for (Map.Entry<String, String> entry : combinedFormCodeAndId.entrySet()){
						    if (entry.getKey().equals(fsCategoryId.toString().replace("-", "")) && entry.getValue().equals(fsFileProfile.getFsFormCode())){
						    	alreadyDisplay = true;
							}
						}	
						
						//if ((ViewMode.ADMIN.toString().equals(viewMode) || ViewMode.LIVE.toString().equals(viewMode)) && alreadyDisplay == false) {
						if ((ViewMode.PREVIEW.toString().equals(viewMode) || ViewMode.LIVE.toString().equals(viewMode))  && alreadyDisplay == false) {
							String combineFilePath = "";
							
							if((admDate == null && dischargeDate == null) || (admDate != null && admDate.length() == 0 && dischargeDate != null && dischargeDate.length() == 0)){
								combineFilePath = FsModelHelper.COMBINE_FILE_STORE_PATH + patNo + "/" + fsCategoryId.toString().replace("-", "") + "_" + fsFileProfile.getFsFormCode() + "/combined_files.pdf";
							} else {
								combineFilePath = FsModelHelper.COMBINE_FILE_STORE_PATH + patNo + "/" + fsCategoryId.toString().replace("-", "") + "_" + fsFileProfile.getFsFormCode() + "/" + (admDate == null ? "" : admDate) + "-" + (dischargeDate == null ? "" : dischargeDate) + "/combined_files.pdf";
							}

							File f = new File(combineFilePath);
							if(f.exists() && !f.isDirectory()) { 
								String tempCombinedFilePath = "";
								try {
									tempCombinedFilePath = URLEncoder.encode(f.getAbsolutePath(), "UTF-8");
								} catch (Exception e) {
								}
								
								outputStr.append("<li class=\"closed\">");
								outputStr.append("<span class=\"file\"><a onclick=linkSelected(this); class=\"dlfilelink\" href=\"..\\forwardScanning\\preview.jsp?filePath=" + 
										tempCombinedFilePath +
										"\" class=\"topstoryblue previewdoc\" target=\"fs_content\"><H1 id=\"TS\">");							
								outputStr.append("Combined File - " + fsFileIndex.getFsFormName() +
										"</H1></a>" +
										"</span>");
								outputStr.append("</li>");
								combinedFormCodeAndId.put(fsCategoryId.toString().replace("-", ""), fsFileProfile.getFsFormCode());
						 	}
						}
												
						boolean haveCombinedFiles = false;						
						for (Map.Entry<String, String> entry : combinedFormCodeAndId.entrySet()){
						    if (entry.getKey().equals(fsCategoryId.toString().replace("-", "")) && entry.getValue().equals(fsFileProfile.getFsFormCode())){
						    	haveCombinedFiles = true;
							}
						}	
						
//						if (ViewMode.LIVE.toString().equals(viewMode) && haveCombinedFiles == true){
						if ((ViewMode.PREVIEW.toString().equals(viewMode) || ViewMode.LIVE.toString().equals(viewMode)) && haveCombinedFiles == true){
							
						} else {
							outputStr.append("<li class=\"closed\">");
							outputStr.append("<span class=\"file\"><a onclick=linkSelected(this); class=\"dlfilelink\" href=\"..\\forwardScanning\\preview.jsp?filePath=" + 
									filePath +
									"\" class=\"topstoryblue previewdoc\" target=\"fs_content\"><H1 id=\"TS\">");
							if (ViewMode.DEBUG.equals(viewMode)) {
								outputStr.append("<span name='fsSeq-" + catCssName + "-box' class='sortOrder-box'>" + cnt-- + " <input type='text' name='fsSeq-" + catCssName + "' class='sortOrder " + catCssName + "' fid='" + fsFileIndex.getFsFileIndexId().toPlainString() + "' size='1' value='' /></span>");
							}
							outputStr.append(getTreeEntryDisplayTitle(fsFileIndex, viewMode, category, fsFileIndexes.size(), j) + 
									"</H1></a><span class=\"file_remarks\">" + 
									treeDisplayNameRemark(fsFileIndex, viewMode) +
									"</span>" +
									treeAction(fsFileIndex, viewMode) +
									"</span>");
							outputStr.append("</li>");
						}
						outputStr.append("</ul>");					
					}
				}
				
				outputStr.append("</li>");
			}
		}
		return outputStr.toString();
	}
	
	public static String getTreeRemark(String patno, String viewModeStr) {
		return getTreeRemark(patno, parseViewMode(viewModeStr));
	}
	
	public static String getTreeRemark(String patno, ViewMode viewMode) {
		StringBuffer sb = new StringBuffer();
		if (!viewMode.equals(ViewMode.LIVE) && !showTreesInLiveMode(patno)) {
			sb.append(MSG_TREE_NOT_SHOW_LIVE);
		}
		return sb.toString();
	}
	
	/**
	 * Return 3 stat numbers in an array
	 * 
	 * @param list
	 * @return
	 */
	public static BigDecimal[] getStatCounts(List<FsFileStat> list) {
		Set<String> patnos = new HashSet<String>();
		BigDecimal noOfFile = new BigDecimal(0);
		BigDecimal noOfBatch = new BigDecimal(0);
		for (FsFileStat s : list) {
			patnos.add(s.getFsPatno());
			noOfFile = noOfFile.add(s.getNoOfFileIndexAll());
			noOfBatch = noOfBatch.add(s.getNoOfBatch());
		}
		return new BigDecimal[]{noOfFile, new BigDecimal(patnos.size()), noOfBatch};
	}
	
	public boolean specialHandle(List<FsCategory> categoryTree, ViewMode viewMode) {
		if (categoryTree == null) 
			return false;
		boolean ret = false;
		
		if (ConstantsServerSide.isHKAH() && !ViewMode.LIVE.equals(viewMode)) {
			for (int i = 0; i < categoryTree.size(); i++) {
				FsCategory category = categoryTree.get(i);
				
				List<FsFileIndex> indexes = category.getFsFileIndexes();
				boolean exit = false;
				for (int j = 0; j < indexes.size() && !exit; j++) {
					FsFileIndex f = indexes.get(j);
					
					FsForm form = ForwardScanningDB.getFsFormByFsFileIndex(f);
					if (form != null && HKAH_HIS_FORM_CODE.equals(form.getFsFormCode())) {
						category.setFsName(category.getFsName() + "<span class=\"file_remarks\">[REPLACED[R] ver will not show in LIVE mode]</span>");
						exit = true;
					}
				}
				List<FsCategory> cats = category.getChildList();
				if (cats != null && !cats.isEmpty()) {
					specialHandle(cats, viewMode);
				}
			}
		}
		/*
		if (ConstantsServerSide.isHKAH()) {
			// 1. hide HIS forms/category if LAB form exists
			boolean labExists = false;
			
			for (int i = 0; i < categoryTree.size(); i++) {
				FsCategory category = categoryTree.get(i);
				
				List<FsFileIndex> indexes = category.getFsFileIndexes();
				for (int j = 0; j < indexes.size(); j++) {
					FsFileIndex f = indexes.get(j);
					
					FsForm form = ForwardScanningDB.getFsFormByFsFileIndex(f);
					if (form != null && HKAH_LABPATH_FORM_CODE.equals(form.getFsFormCode())) {
						labExists = true;
					}
				}
				List<FsCategory> cats = category.getChildList();
				FsCategory cToBeRemove = null;
				if (labExists) {
					
					for (int j = 0; j < cats.size(); j++) {
						FsCategory c = cats.get(j);
						
						if (HKAH_HIS_CAT_ID.equals(c.getFsCategoryId())) {
							cToBeRemove = c;
						}
					}
					if (cToBeRemove != null) {
						// 20131112 show Lab Path and HIS
						/*
						if (viewMode.equals(ViewMode.PREVIEW) || viewMode.equals(ViewMode.LIVE)) {
							cats.remove(cToBeRemove);
						} else {
							cToBeRemove.setFsName(cToBeRemove.getFsName() + " [HIDE in live mode]");
						}
						*//*
						ret = true;
					}
				}
				
				if (cats != null && !cats.isEmpty()) {
					specialHandle(cats, viewMode);
				}
			}
		}
		*/
		return ret;
	}
	
	public static boolean showTreesInLiveMode(String patno) {
		// 2. hide all images if either only DI auto import (no scanned charts) 
		//    or HIS 
		return ForwardScanningDB.getFsLiveRecCount(
				patno, ConstantsServerSide.SITE_CODE) > 0;
	}
	
	public static boolean updateFileIndexSeqs(UserBean userBean, String[] fileIndexIds ,String[] fsSeqs) {
		if (fileIndexIds == null) {
			return false;
		}
		
		boolean success = false;
		int size = fileIndexIds.length;
		for (int i = 0; i < fileIndexIds.length; i++) {
			int seq = size - i;
			success = ForwardScanningDB.updateFsFileIndexSeq(userBean, fileIndexIds[i], Integer.toString(seq));
		}
		return success;
	}
	
	public static void loadSysParam() {
		ArrayList list = ForwardScanningDB.loadSysParam();
		for (int i = 0; i < list.size(); i++) {
			ReportableListObject row = (ReportableListObject) list.get(i);
			String codeNo = row.getValue(1);
			String codeValue1 = row.getValue(2);
			//String codeValue2 = row.getValue(3);
			SID2srcHost.put(codeNo, codeValue1);
			
			if (codeNo.startsWith(SYS_CODE_SRC_HOST + ".")) {
				String stationID = codeNo.substring(SYS_CODE_SRC_HOST.length() + 1);
				stationIDs.put(stationID, codeValue1);
			}
		}
	}
	
	public static ViewMode parseViewMode(String viewModeStr) {
		ViewMode viewMode = null;
		try {
			viewMode = ViewMode.valueOf(viewModeStr.toUpperCase());
		} catch (Exception ex) {}
		// default
		if (viewMode == null) {
			viewMode = ViewMode.LIVE;
		}
		return viewMode;
	}
	
	// 2013-11-27 preserve original seq not implemented
	/*
	public static void remainHisSeq(String fIdOld, String fIdNew,
			String patno, String catId) {
		// for HKAH only 2013-11-18
		System.out.println("remainHisSeq");
		LinkedHashMap<String, String> fId2fSeqNos = ForwardScanningDB.getFsSeqsByPatCatId(patno, catId);
		if (fId2fSeqNos.containsKey(fIdOld)) {
			// update seq_no
			String seq = fId2fSeqNos.get(fIdOld);
			System.out.println("seq="+seq);
			if (seq != null) {
				fId2fSeqNos.put(fIdNew, fId2fSeqNos.get(fIdOld));
			} else {
				// check if all seq null
				boolean isAllNull = true;
				for (String value: fId2fSeqNos.values()) {
				    // using ArrayList#contains
				    if (value != null) {
				    	isAllNull = false;
				    }
				}
				if (isAllNull) {
					insertSeq(fId2fSeqNos);
				}
			}
		}
		
		// update all seq no in this cat id
		UserBean userBean = new UserBean();
		userBean.setLoginID("SYSTEM");
		Iterator<Entry<String, String>> iterator = fId2fSeqNos.entrySet().iterator();
		while (iterator.hasNext()) {
			Map.Entry<String, String> mapEntry = (Map.Entry) iterator.next();
			ForwardScanningDB.updateFsFileIndexSeq(userBean, mapEntry.getKey(), mapEntry.getValue());
		}
	}
	
	public static void insertSeq(LinkedHashMap<String, String> fId2fSeqNos) {
		System.out.println("insertSeq");
		if (fId2fSeqNos == null) {
			return;
		}
		int cnt = fId2fSeqNos.size();
		System.out.println("size="+cnt);
		LinkedHashMap<String, String> ret = new LinkedHashMap<String, String>();
		Iterator<String> it = fId2fSeqNos.keySet().iterator();
		while (it.hasNext()) {
			String fId = it.next();
			ret.put(fId, String.valueOf(cnt--));
		}
	}
	*/
	
	//=============================//
	// Main method to list the tree
	//=============================//
	public static List<FsCategory> getFsCategoryTreeWithFiles(String patno, String viewModeStr) {
		return getFsCategoryTreeWithFiles(patno, parseViewMode(viewModeStr));
	}
	
	public static List<FsCategory> getFsCategoryTreeWithFiles(String patno, ViewMode viewMode) {
		FsModelHelper fsModelHelper = FsModelHelper.getInstance();
		fsModelHelper.setFileList(fsModelHelper.getFsFileModels(
				ForwardScanningDB.getFileIndex(viewMode, patno, false, true), viewMode));
		//if (showTrees(patno, viewMode)) {
			List<FsCategory> categories = fsModelHelper.getCategoryList(true, true);
			fsModelHelper.mapFileToCategoryTree(categories, fsModelHelper.getFileList());
			if (ConstantsServerSide.isHKAH())
				fsModelHelper.groupFsFileIndexHKAH(categories, 0, viewMode);
		//} else {
		//	fsModelHelper.resetCategoryList(true);
		//}
		if (!viewMode.equals(ViewMode.DEBUG))
			fsModelHelper.removeEmptyBranch(fsModelHelper.getCategoryList(true, false));
		fsModelHelper.specialHandle(fsModelHelper.getCategoryList(true, false), viewMode);
		
		return fsModelHelper.getCategoryList();
	}
	//============================//
	
	public static void mergePdfFiles(ArrayList record){
		ArrayList<FsPatNo> fsPatNo_list = new ArrayList<FsPatNo>();
		if(record.size() != 0){			
			for(int r = 0; r < record.size(); r++){
				ReportableListObject row = (ReportableListObject)record.get(r);
				String rPatNo = row.getValue(1);		
				BigDecimal rCategoryId = new BigDecimal(row.getValue(2));
				String rFilePath = row.getValue(3);
				String rFormCode = row.getValue(4);
				String rPatType = row.getValue(5);
				SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
				String rAdmDate = "";
				String rDisDate = "";
				
				try{
					rAdmDate =  FsModelHelper.displayDateFormatMiddleEndianShort.format(formatter.parse(row.getValue(6)));
					rDisDate =  FsModelHelper.displayDateFormatMiddleEndianShort.format(formatter.parse(row.getValue(7)));
				} catch (Exception e) {					
				}				
				
				boolean alreadyExist = false;
				int tempFoundId = -1;
				for(int i = 0; i < fsPatNo_list.size() ; i++){
					if(fsPatNo_list.get(i).getFsPatno().equals(rPatNo)){
						alreadyExist = true;
						tempFoundId = i;
						break;
					}		
				}
				
				if(alreadyExist){
					fsPatNo_list.get(tempFoundId).setFileDetails(new FsFileDetails(rCategoryId, rFilePath, rFormCode, rPatType, rAdmDate, rDisDate));
				} else {
					FsPatNo tempFsPatNo = new FsPatNo();
					tempFsPatNo.setFsPatno(rPatNo);
					tempFsPatNo.setFileDetails(new FsFileDetails(rCategoryId, rFilePath, rFormCode, rPatType, rAdmDate, rDisDate));
					fsPatNo_list.add(tempFsPatNo);
				}
			}			
			
			for(FsPatNo l : fsPatNo_list){			
				ArrayList<FsCombineFiles> fsCombineFiles_list = new ArrayList<FsCombineFiles>();
				for (FsFileDetails f : l.getFileDetails()){
					boolean alreadyExist = false;
					int tempFoundId = -1;
					for(int i = 0; i < fsCombineFiles_list.size(); i++){
						if(f.getFsCategoryId().equals(fsCombineFiles_list.get(i).getFsCategoryId())){
							for(FsFileDetails cf : fsCombineFiles_list.get(i).getFileDetails()){
								if(f.getFsAdmDate().equals(cf.getFsAdmDate()) && f.getFsDisDate().equals(cf.getFsDisDate())){								
									if(f.getFsFormCode().toUpperCase().equals(cf.getFsFormCode().toUpperCase())){
										alreadyExist = true;
										tempFoundId = i;
										break;
									}
								}
							}
						}			
					}		
					
					if(alreadyExist){
						fsCombineFiles_list.get(tempFoundId).setFileDetails(f);
					} else {
						FsCombineFiles tempCombineFile = new FsCombineFiles();
						tempCombineFile.setFsCategoryId(f.getFsCategoryId());
						tempCombineFile.setFileDetails(f);
						fsCombineFiles_list.add(tempCombineFile);
					}		
				}
				
				for(FsCombineFiles s : fsCombineFiles_list){			
					PDFMergerUtility ut = new PDFMergerUtility();
					int toBeMergeFiles = 0;
					for(FsFileDetails k : s.getFileDetails()){
						for (Map.Entry<String, String> entry : FsModelHelper.ALLOWCOMBINETYPES.entrySet()){
						    if (entry.getKey().toUpperCase().equals(k.getFsFormCode().trim().toUpperCase()) && entry.getValue().toUpperCase().equals(k.getFsPatType().trim().toUpperCase())){
								try{
							    	ut.addSource(k.getFsFilePath());
									toBeMergeFiles ++;		
								} catch (Exception e){
									System.out.println(e);
								}
							}
						}	
					}				
					
					
					if(toBeMergeFiles > 1){	
						File f = new File(FsModelHelper.COMBINE_FILE_STORE_PATH + l.getFsPatno() + "/" + s.getFsCategoryId() + "_" + s.getFileDetails().get(0).getFsFormCode());
						if(f.exists() && f.isDirectory()) {
							MergeFiles(s, l, ut);
						} else {
							boolean success = (new File(FsModelHelper.COMBINE_FILE_STORE_PATH + l.getFsPatno() + "/" + s.getFsCategoryId() + "_" + s.getFileDetails().get(0).getFsFormCode())).mkdirs();	
							if (success){
								MergeFiles(s, l, ut);
							}
						}
					}
				}
			}
		}
	}
	
	private static String GenCombineFilePath(FsCombineFiles s, FsPatNo l){
		String combinedFilePath = "";
		if(s.getFileDetails().size() > 0){
			if(s.getFileDetails().get(0).getFsAdmDate().length() == 0 && s.getFileDetails().get(0).getFsDisDate().length() == 0){
				combinedFilePath = FsModelHelper.COMBINE_FILE_STORE_PATH + l.getFsPatno() + "/" + s.getFsCategoryId() + "_" + s.getFileDetails().get(0).getFsFormCode() + "/combined_files.pdf";
			} else { 
				File f = new File(FsModelHelper.COMBINE_FILE_STORE_PATH + l.getFsPatno() + "/" + s.getFsCategoryId()  + "_" + s.getFileDetails().get(0).getFsFormCode()+ "/" + s.getFileDetails().get(0).getFsAdmDate() + "-" + s.getFileDetails().get(0).getFsDisDate());
				if(f.exists() && f.isDirectory()) {
					combinedFilePath = FsModelHelper.COMBINE_FILE_STORE_PATH + l.getFsPatno() + "/" + s.getFsCategoryId() + "_" + s.getFileDetails().get(0).getFsFormCode() + "/" + s.getFileDetails().get(0).getFsAdmDate() + "-" + s.getFileDetails().get(0).getFsDisDate() + "/combined_files.pdf";
				} else {
					boolean success = (new File(FsModelHelper.COMBINE_FILE_STORE_PATH + l.getFsPatno() + "/" + s.getFsCategoryId() + "_" + s.getFileDetails().get(0).getFsFormCode() + "/" + s.getFileDetails().get(0).getFsAdmDate() + "-" + s.getFileDetails().get(0).getFsDisDate())).mkdirs();
					if(success){
						combinedFilePath = FsModelHelper.COMBINE_FILE_STORE_PATH + l.getFsPatno() + "/" + s.getFsCategoryId() + "_" + s.getFileDetails().get(0).getFsFormCode() + "/" + s.getFileDetails().get(0).getFsAdmDate() + "-" + s.getFileDetails().get(0).getFsDisDate() + "/combined_files.pdf";
					}
				}
			}
		} else {
			combinedFilePath = FsModelHelper.COMBINE_FILE_STORE_PATH + l.getFsPatno() + "/" + s.getFsCategoryId() + "_" + s.getFileDetails().get(0).getFsFormCode() + "/combined_files.pdf";
		}
		return combinedFilePath;
	}
	
	private static void MergeFiles(FsCombineFiles s, FsPatNo l,PDFMergerUtility ut){		
		String combinedFilePath = "";
		combinedFilePath = GenCombineFilePath(s, l);
		ut.setDestinationFileName(combinedFilePath);
		try{					
			ut.mergeDocuments();
		} catch (Exception e){
		}
	}
	
	private static Set<String> fileCsvPatientSet(List<FsFileCsv> fileCsvs) {
		Set<String> patSet = new HashSet<String>();
		for (int i = 0; i < fileCsvs.size(); i++) {
			FsFileCsv fileCsv = fileCsvs.get(i);
			try {
				patSet.add(fileCsv.getPatientCode().trim());
			} catch (Exception ex) {
			}
		}
		return patSet;
	}
	
	static {
		loadSysParam();
		COMBINE_FILE_STORE_PATH = SID2srcHost.get(SYS_CODE_DEST_HOST_PATH) + "Combine" + File.separator;
	}	
}


