package com.hkah.web.db.helper;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;
import org.apache.poi.hwpf.HWPFDocument;
import org.apache.poi.hwpf.extractor.WordExtractor;
import org.apache.poi.ss.usermodel.Workbook;

import com.hkah.constant.ConstantsServerSide;

public class DiIncomeReportHelper {
	private static Logger logger = Logger.getLogger(DiIncomeReportHelper.class);
	
	//------------------
	// Payroll reports
	//------------------
	protected static Map<String, DiPayrollReport> payrollReportsHK = new HashMap<String, DiPayrollReport>();
	static {
		payrollReportsHK.put("OOI GAIK CHENG, CLARA", new DiPayrollReportHK1325());
		payrollReportsHK.put("Radiology Associates Limited", new DiPayrollReportHKRAL());
		payrollReportsHK.put("HK RADIOLOGISTS LIMITED", new DiPayrollReportHKHKRL());
		payrollReportsHK.put("DEFAULT", new DiPayrollReportHKDefault());
	}
	
	protected static Map<String, DiPayrollReport> payrollReportsTW = new HashMap<String, DiPayrollReport>();
	static {
		payrollReportsTW.put("THREE DIMENSION MEDICAL IMAGING LIMITED", new DiPayrollReportTW3D());
		payrollReportsTW.put("Radiology Associates Limited", new DiPayrollReportTWRAL());
		payrollReportsTW.put("DEFAULT", new DiPayrollReportTWDefault());
	}
	
	protected static Map<String, DiPayrollReport> payrollReportsAMC2 = new HashMap<String, DiPayrollReport>();
	static {
		payrollReportsAMC2.put("Radiology Associates Limited", new DiPayrollReportAMC2RAL());
	}
	
	public static Map<String, Workbook> genPayrollSummaryReport(String actualrun, String endDate) {
		return genPayrollSummaryReport(actualrun, endDate, null);
	}

	public static Map<String, Workbook> genPayrollSummaryReport(String actualrun, String endDate, String payTo) {
		Map<String, Workbook> wbs = new HashMap<String, Workbook>();
		Map<String, DiPayrollReport> diPayrollReports = null;
		Set<String> keys = null;
		Iterator<String> itr = null;
		if (ConstantsServerSide.isHKAH()) {
			diPayrollReports = payrollReportsHK;
		} else if (ConstantsServerSide.isTWAH()) {
			diPayrollReports = payrollReportsTW;
		} else if (ConstantsServerSide.isAMC2()) {
			diPayrollReports = payrollReportsAMC2;
		}
		if (payTo != null && !payTo.trim().isEmpty()) {
			/*
			 * Java SE 8 or above
			 */
			/*
			wbs.put(getPayrollReportFileName(actualrun, endDate, payTo),	
					diPayrollReports.getOrDefault(payTo, diPayrollReports.get("DEFAULT")).genPayrollSummaryReport(actualrun, endDate, payTo));
			*/
			DiPayrollReport r = diPayrollReports.get(payTo);
			if (r == null) {
				r = diPayrollReports.get("DEFAULT");
			}
			wbs.put(getPayrollReportFileName(actualrun, endDate, payTo), r.genPayrollSummaryReport(actualrun, endDate, payTo));
		} else {
			if (diPayrollReports != null) {
				keys = diPayrollReports.keySet();
				itr = keys.iterator();
				while (itr.hasNext()) {
					String thisPayTo = itr.next();
					if (!"DEFAULT".equals(thisPayTo)) {
						wbs.put(getPayrollReportFileName(actualrun, endDate, thisPayTo),	
								diPayrollReports.get(thisPayTo).genPayrollSummaryReport(actualrun, endDate, thisPayTo));
					}
				}
			}
		}
		
		return wbs;
	}
	
	public static List<String> outputAllPayrollReports(String actualRun, String endPeriod, String payTo) {
		List<String> outputFilePaths = new ArrayList<String>();
		
		System.out.println("== outputAllPayrollReports ==");
		System.out.println("actualRun="+actualRun+",endPeriod="+endPeriod+",payTo="+payTo);
		
		Map<String, Workbook> wbs = null;
		Workbook wb = null;
		String fullPath = null;
		Set<String> wbsSet = null;
		Iterator<String> itr = null;
		try {
			String outputFilePath = ConstantsServerSide.TEMP_FOLDER + "/";
			wbs = genPayrollSummaryReport(actualRun, endPeriod, payTo);
			wbsSet = wbs.keySet();
			itr = wbsSet.iterator();
			while (itr.hasNext()) {
				String fileName = itr.next();
				wb = wbs.get(fileName);
				if (wb != null) {
					fullPath = outputFilePath + fileName;
					FileOutputStream os = new FileOutputStream(fullPath);
					wb.write(os);
					os.close();
					System.out.println("Workbook wrote to " + fullPath);
					outputFilePaths.add(fullPath);
					
				} else {
					System.err.println("Workbook is null");
				}	
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return outputFilePaths;
	}
	
	public static String getPayrollReportFileName(String actualrun, String endDate, String payTo) {
		String currYrMth = endDate.substring(6, 10) + " " + endDate.substring(3, 5);
		return (ConstantsServerSide.isAMC2() ? "AMC-TKP" :  ("HKAH-" + (ConstantsServerSide.isHKAH() ? "SR" : ConstantsServerSide.isTWAH() ? "TW" : ""))) + " DI Payroll - " + currYrMth + " " + payTo + ("N".equals(actualrun) ? " (Trial)" : "") + ".xls";
	}

	public static String getPayrollReportArchiveFileName(Date reportCreateDate) {
		SimpleDateFormat tsFormat = new SimpleDateFormat("yyyyMMdd_HHmmss");
		String tsStr = tsFormat.format(reportCreateDate);
		return (ConstantsServerSide.isAMC2() ? "AMC-TKP" : ("HKAH-" + (ConstantsServerSide.isHKAH() ? "SR" : ConstantsServerSide.isTWAH() ? "TW" : ""))) + "_DI_Payrolls_" + tsStr;
	}
	
	public static void testWord(String filepath) {
        File file = null;
        WordExtractor extractor = null;
        try {

            file = new File(filepath);
            FileInputStream fis = new FileInputStream(file.getAbsolutePath());
            HWPFDocument document = new HWPFDocument(fis);
            WordExtractor wordExtractor = new WordExtractor(document);
            String[] paragraphs = wordExtractor.getParagraphText();
            System.out.println("Word document has " + paragraphs.length + " paragraphs");
            for(int i=0; i<paragraphs.length; i++){
                paragraphs[i] = paragraphs[i].replaceAll("\\cM?\r?\n", "");
                System.out.println(paragraphs[i]);
            }
        } catch (Exception exep) {
        	exep.printStackTrace();
        }

	}
}
