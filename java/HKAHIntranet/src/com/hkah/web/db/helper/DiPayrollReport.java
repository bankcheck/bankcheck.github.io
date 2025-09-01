package com.hkah.web.db.helper;

import java.io.File;
import java.io.FileOutputStream;
import java.io.OutputStream;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.CreationHelper;
import org.apache.poi.ss.usermodel.DataFormat;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.DateTimeUtil;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.DiIncomeReportDB;

public abstract class DiPayrollReport {
	private static Logger logger = Logger.getLogger(DiPayrollReport.class);
	
	public static final String EXCEL_CURRENCY_FORMAT = "_(\"HK$\"* #,##0_);_(\"HK$\"* (#,##0);_(\"HK$\"* \"-\"??_);_(@_)";
	public static final String EXCEL_CURRENCY_SIMPLE_FORMAT = "_(* #,##0_);_(* (#,##0);_(* \"-\"??_);_(@_)";
	public static final String EXCEL_REPORT_DATE_FORMAT = "d/mmm/yy";
	public static final String EXCEL_ADJUST_DETAILS_DATE_FORMAT = "d/mm/yyyy";
	public static final String EXCEL_YR_MONTH_FORMAT = "yyyy-mm";
	public static final String EXCEL_MON_YR_FORMAT = "mmm-yy";
	
	public static SimpleDateFormat payrollReportMthStrDateFormat = new SimpleDateFormat(
			"MMM-yyyy");
	
	public static Map<String, String> payrollRpttypeSheetNames = new LinkedHashMap<String, String>();
	static {
		payrollRpttypeSheetNames.put("Summary", "Rad Pay Report");
		payrollRpttypeSheetNames.put("BF", "BF-NetAmt");
		payrollRpttypeSheetNames.put("IC:NetAmt", "ACTUAL-NetAmt");
		payrollRpttypeSheetNames.put("IC:Comm", "ACTUAL-Commission");
		payrollRpttypeSheetNames.put("IC:DRPAY", "ACTUAL-DRPAY");
		payrollRpttypeSheetNames.put("CF", "CF-NetAmt");
		payrollRpttypeSheetNames.put("Breakdown", "BF-Adjustment Breakdown");
	}
	
	public Map<String, String> payrollRpttypeHeaders = new LinkedHashMap<String, String>();
    {
		payrollRpttypeHeaders.put("BF", "Outstanding Revenue Brought Forward Before Radiologist Payment");
		payrollRpttypeHeaders.put("IC:NetAmt", "Revenue to Calculate for the Radiologist Payment for Paid Examinations / Procedure as of");
		payrollRpttypeHeaders.put("IC:Comm", "Card Commission as of");
		payrollRpttypeHeaders.put("IC:DRPAY", "Radiologist Payment for Paid Examinations / Procedure as of");
		payrollRpttypeHeaders.put("CF", "Outstanding Revenue Carried Forward (To Be Calculated in Later Months)");
	}
	
	public static Map<String, String> reportedByNames = new LinkedHashMap<String, String>();
	static {
		reportedByNames.put(ConstantsServerSide.SITE_CODE_HKAH, "Danny Leung");
		reportedByNames.put(ConstantsServerSide.SITE_CODE_TWAH, "Zoe Lai");
		reportedByNames.put(ConstantsServerSide.SITE_CODE_AMC2, "Andrew Tam");
	}
	
	public static List<String> adjBreakdownDetailsColHeaders = new ArrayList<String>();
	static {
		adjBreakdownDetailsColHeaders.add("Report Month");
		adjBreakdownDetailsColHeaders.add("Service");
		adjBreakdownDetailsColHeaders.add("Excode");
		adjBreakdownDetailsColHeaders.add("Exam Name");
		adjBreakdownDetailsColHeaders.add("Exdate");
		adjBreakdownDetailsColHeaders.add("Patient#");
		adjBreakdownDetailsColHeaders.add("Patient Name");
		adjBreakdownDetailsColHeaders.add("Slip#");
		adjBreakdownDetailsColHeaders.add("Original");
		adjBreakdownDetailsColHeaders.add("Billed");
		adjBreakdownDetailsColHeaders.add("Discount");
		adjBreakdownDetailsColHeaders.add("Net Amt");
		adjBreakdownDetailsColHeaders.add("Consum");
		adjBreakdownDetailsColHeaders.add("Rev Share");
		adjBreakdownDetailsColHeaders.add("Net pay");
		adjBreakdownDetailsColHeaders.add("DR Share");
		adjBreakdownDetailsColHeaders.add("DR Share Amt");
		adjBreakdownDetailsColHeaders.add("Collection Fee");
		adjBreakdownDetailsColHeaders.add("DR Pay");
		adjBreakdownDetailsColHeaders.add("Remark");
	}
	
	public static final Map<String, String> servdescs = new HashMap<String, String>();
	
	static {
		loadDpservs();
	}	
	
	// default values
	public static final int HK_HKRL_PAYROLL_HEAD_COL_NUM = 2;
	public static final int HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM = 2;
	
	private String reportedByName = "HKAH";
	
	private Map<String, String> slptypes = new LinkedHashMap<String, String>();
	private Map<String, String> servcdes = new LinkedHashMap<String, String>();

	// utils
	public int getNoOfServcde() {
		return servcdes == null ? 0 : servcdes.size();
	}
	
	public static String convertColIdx2Char(int idx) {
		return Character.toString((char) (idx + 65));
	}
	
	//------ Constructor ----------
	public DiPayrollReport() {
		this(null, null, null, null);
	}
	
	public DiPayrollReport(Map<String, String> servcdes) {
		this(servcdes, null, null, null);
	}
	
	public DiPayrollReport(Map<String, String> servcdes, Map<String, String> slptypes) {
		this(servcdes, slptypes, null, null);
	}
	
	public DiPayrollReport(Map<String, String> servcdes, Map<String, String> slptypes, Map<String, String> payrollRpttypeHeaders, String reportedBy) {
		super();
		this.servcdes = servcdes != null ? servcdes : this.servcdes; 
		this.slptypes = slptypes != null ? slptypes : this.slptypes; 
		this.payrollRpttypeHeaders = payrollRpttypeHeaders != null ? payrollRpttypeHeaders : this.payrollRpttypeHeaders; 
		this.reportedByName = reportedBy != null ? reportedBy : reportedByNames.get(ConstantsServerSide.SITE_CODE); 
	}
	
	//------ Methods ----------
	public Workbook genPayrollSummaryReport(
			String actualrun, String endDate, String payTo) {
		if (payTo == null || "".equals(payTo) || endDate == null
				|| "".equals(endDate)) {
			return null;
		}

		Workbook wb = null;
		ReportableListObject rlo = null;
		BigDecimal bd = null;
		Iterator<String> itr = null;
		int k = 0;
		Set<String> servcdesSet = servcdes.keySet();
		Set<String> slptypesSet = slptypes.keySet();
		
		try {
			Calendar currentCal = Calendar.getInstance();

			// Calendar startDateCal = Calendar.getInstance();
			// startDateCal.setTime(DateTimeUtil.parseDate(startDate));

			Date endDateDate = DateTimeUtil.parseDate(endDate);
			String radPayReportMthStr = payrollReportMthStrDateFormat
					.format(endDateDate);

			Calendar endDateCal = Calendar.getInstance();
			endDateCal.setTime(DateTimeUtil.parseDate(endDate));

			Calendar lastMthEndDateCal = (Calendar) endDateCal.clone();
			lastMthEndDateCal.set(Calendar.DAY_OF_MONTH, 1);
			lastMthEndDateCal.add(Calendar.DATE, -1);
			//lastMthEndDateCal.add(Calendar.MONTH, -1);
			String lastMthEndDate = DateTimeUtil.formatDate(lastMthEndDateCal.getTime());
			
			//==================
			// Report Data
			//==================
			Map<String, List<ReportableListObject>> summaryByExdateServcdeSums = new HashMap<String, List<ReportableListObject>>();
			Map<String, List<BigDecimal>> lastMthCfServcdeSums = new HashMap<String, List<BigDecimal>>();
			
			itr = slptypesSet.iterator();
			k = 0;
			while (itr.hasNext()) {
				String slptype = itr.next();
				List<BigDecimal> lastMthCfServcdeSum = new ArrayList<BigDecimal>();
				
				List<ReportableListObject> summaryByExdateServcdeSum = 
						DiIncomeReportDB.getPayrollSummaryByExdateServcdeSum("CF", slptype, actualrun, lastMthEndDate, payTo);
				
				rlo = summaryByExdateServcdeSum.get(0);
				for (int i = 0; i < getNoOfServcde(); i++) {
					try {
						bd = new BigDecimal(rlo.getValue(i));
					} catch (Exception e) { 
						bd = new BigDecimal("0");
					}
					lastMthCfServcdeSum.add(bd);
				}
				
				lastMthCfServcdeSums.put(slptype, lastMthCfServcdeSum);
				summaryByExdateServcdeSums.put(slptype, summaryByExdateServcdeSum);
			}
			
			// New method:
			wb = new HSSFWorkbook();
			// Old method:
			File file = new File("workbook.xls");
			if (!file.exists()) {
				file.createNewFile();
			}
			OutputStream inp = new FileOutputStream(file);
			// wb = WorkbookFactory.create(inp);
			
			CreationHelper createHelper = wb.getCreationHelper();
			Sheet sheet1 = wb.createSheet(payrollRpttypeSheetNames.get("Summary"));

			//==================
			// Sheets rpttype summary by exdate
			//==================
			Map<String, String> returnDataBF = new HashMap<String, String>();
			Sheet sheet2 = createSheetRpttype(wb, "BF", null, actualrun, endDate, payTo, returnDataBF);
			
			Map<String, String> returnDataICNetAmt = new HashMap<String, String>();
			Sheet sheet3 = createSheetRpttype(wb, "IC", "NetAmt", actualrun, endDate, payTo, returnDataICNetAmt);
			
			Map<String, String> returnDataICDRPAY = new HashMap<String, String>();
			Sheet sheet4 = createSheetRpttype(wb, "IC", "DRPAY", actualrun, endDate, payTo, returnDataICDRPAY);
			
			Map<String, String> returnDataICComm = new HashMap<String, String>();
			Sheet sheet4a = createSheetRpttype(wb, "IC", "Comm", actualrun, endDate, payTo, returnDataICComm);

			Map<String, String> returnDataCF = new HashMap<String, String>();
			Sheet sheet5 = createSheetRpttype(wb, "CF", null, actualrun, endDate, payTo, returnDataCF);
			
			int rowCount = 0;

			// Font
			Font header1Font = wb.createFont();
			header1Font.setFontHeightInPoints((short) 10);
			header1Font.setFontName("Arial");
			header1Font.setBoldweight(Font.BOLDWEIGHT_BOLD);

			Font header2Font = wb.createFont();
			header2Font.setFontHeightInPoints((short) 10);
			header2Font.setFontName("Arial");
			header2Font.setBoldweight(Font.BOLDWEIGHT_BOLD);
			header2Font.setUnderline(Font.U_SINGLE);

			Font normalFont = wb.createFont();
			normalFont.setFontHeightInPoints((short) 10);
			normalFont.setFontName("Arial");

			// Style
			CellStyle header1Style = wb.createCellStyle();
			header1Style.setFont(header1Font);

			CellStyle header2Style = wb.createCellStyle();
			header2Style.setFont(header2Font);

			CellStyle normalStyle = wb.createCellStyle();
			normalStyle.setFont(normalFont);

			CellStyle periodStyle = wb.createCellStyle();
			periodStyle.setFont(normalFont);
			periodStyle.setAlignment(CellStyle.ALIGN_CENTER);
			
			CellStyle reportedByStyle = wb.createCellStyle();
			reportedByStyle.setFont(normalFont);
			reportedByStyle.setAlignment(CellStyle.ALIGN_LEFT);

			CellStyle dateStyle = wb.createCellStyle();
			dateStyle.setFont(normalFont);
			dateStyle.setDataFormat(createHelper.createDataFormat().getFormat(
					"d-MMM-yy"));

			CellStyle highlightBgColorStyle = wb.createCellStyle();
			highlightBgColorStyle
					.setFillForegroundColor(IndexedColors.GREY_25_PERCENT
							.getIndex());
			highlightBgColorStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);

			CellStyle tableCellStyle = wb.createCellStyle();
			tableCellStyle.cloneStyleFrom(highlightBgColorStyle);
			tableCellStyle.setBorderBottom(CellStyle.BORDER_THIN);
			tableCellStyle.setBorderTop(CellStyle.BORDER_THIN);
			tableCellStyle.setBorderLeft(CellStyle.BORDER_THIN);
			tableCellStyle.setBorderRight(CellStyle.BORDER_THIN);
			tableCellStyle.setFont(normalFont);

			CellStyle tableCell2Style = wb.createCellStyle();
			tableCell2Style.setBorderBottom(CellStyle.BORDER_THIN);
			tableCell2Style.setBorderTop(CellStyle.BORDER_THIN);
			tableCell2Style.setBorderLeft(CellStyle.BORDER_THIN);
			tableCell2Style.setBorderRight(CellStyle.BORDER_THIN);
			tableCell2Style.setFont(normalFont);

			CellStyle tableCellNoBorderStyle = wb.createCellStyle();
			tableCellNoBorderStyle.cloneStyleFrom(highlightBgColorStyle);

			CellStyle tableCellNoBorder2Style = wb.createCellStyle();

			CellStyle tableCellBorderTopStyle = wb.createCellStyle();
			tableCellBorderTopStyle.cloneStyleFrom(highlightBgColorStyle);
			tableCellBorderTopStyle.setBorderTop(CellStyle.BORDER_THIN);

			CellStyle tableCellBorderTop2Style = wb.createCellStyle();
			tableCellBorderTop2Style.setBorderTop(CellStyle.BORDER_THIN);

			CellStyle tableCellBorderBottomStyle = wb.createCellStyle();
			tableCellBorderBottomStyle.cloneStyleFrom(highlightBgColorStyle);
			tableCellBorderBottomStyle.setBorderBottom(CellStyle.BORDER_THIN);

			CellStyle tableCellBorderBottom2Style = wb.createCellStyle();
			tableCellBorderBottom2Style.setBorderBottom(CellStyle.BORDER_THIN);

			CellStyle tableCellBorderRightStyle = wb.createCellStyle();
			tableCellBorderRightStyle.cloneStyleFrom(highlightBgColorStyle);
			tableCellBorderRightStyle.setBorderRight(CellStyle.BORDER_THIN);

			CellStyle tableCellBorderRight2Style = wb.createCellStyle();
			tableCellBorderRight2Style.setBorderRight(CellStyle.BORDER_THIN);

			DataFormat format = wb.createDataFormat();
			CellStyle totalCellStyle = wb.createCellStyle();
			totalCellStyle.cloneStyleFrom(highlightBgColorStyle);
			totalCellStyle.setBorderBottom(CellStyle.BORDER_THIN);
			totalCellStyle.setBorderTop(CellStyle.BORDER_THIN);
			totalCellStyle.setBorderLeft(CellStyle.BORDER_THIN);
			totalCellStyle.setBorderRight(CellStyle.BORDER_THIN);
			totalCellStyle.setDataFormat(format
					.getFormat(EXCEL_CURRENCY_FORMAT));
			totalCellStyle.setFont(normalFont);

			CellStyle totalCell2Style = wb.createCellStyle();
			totalCell2Style.setBorderBottom(CellStyle.BORDER_THIN);
			totalCell2Style.setBorderTop(CellStyle.BORDER_THIN);
			totalCell2Style.setBorderLeft(CellStyle.BORDER_THIN);
			totalCell2Style.setBorderRight(CellStyle.BORDER_THIN);
			totalCell2Style.setDataFormat(format
					.getFormat(EXCEL_CURRENCY_FORMAT));
			totalCell2Style.setFont(normalFont);

			CellStyle reportDateStyle = wb.createCellStyle();
			reportDateStyle.cloneStyleFrom(header1Style);
			reportDateStyle.setAlignment(CellStyle.ALIGN_LEFT);
			reportDateStyle.setDataFormat(format
					.getFormat(EXCEL_REPORT_DATE_FORMAT));

			// ----------------------
			// Sheet 1 Rad pay report
			// ----------------------
			int totalColIdx = HK_HKRL_PAYROLL_HEAD_COL_NUM + getNoOfServcde();
			//int totalIpRowIdx = 0;
			//int totalOpRowIdx = 0;
			Map<String, Integer> subTotalRowIdxs = null;
			
			Row row = sheet1.createRow((short) rowCount++);
			Cell cel0 = row.createCell(0);
			cel0.setCellValue("Diagnostic Imaging Department Radiologist Paid Report to Accounting Department");
			cel0.setCellStyle(header1Style);

			row = sheet1.createRow((short) rowCount++);
			Cell cell = row.createCell(0);
			cell.setCellValue("From:");
			cell.setCellStyle(periodStyle);

			cell = row.createCell(1);
			cell.setCellValue(DateTimeUtil.parseDate(DiIncomeReportDB.getConStartDate(payTo, endDate)));
			cell.setCellStyle(dateStyle);

			cell = row.createCell(2);
			cell.setCellValue("To:");
			cell.setCellStyle(periodStyle);

			cell = row.createCell(3);
			cell.setCellValue(DateTimeUtil.parseDate(DiIncomeReportDB.getConEndDate(payTo, endDate)));
			cell.setCellStyle(dateStyle);

			cell = row.createCell(6);
			cell.setCellValue("OOI GAIK CHENG, CLARA".equals(payTo) ? "DR " + payTo + " (1235)" : payTo);
			cell.setCellStyle(header1Style);

			rowCount++;
			rowCount++;

			//==================
			// BF 
			//==================
			row = sheet1.createRow((short) rowCount++);
			cell = row.createCell(0);
			cell.setCellValue(payrollRpttypeHeaders.get("BF").replace("%radPayReportMthStr%", radPayReportMthStr) + ":");
			cell.setCellStyle(header2Style);

			row = sheet1.createRow((short) rowCount++);
			
			//Set<String> servcdesSet = servcdes.keySet();
			itr = servcdesSet.iterator();
			k = 0;
			while (itr.hasNext()) {
				cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + k++);
				String servcdeDesc = servcdes.get(itr.next());
				try {
					servcdeDesc = servcdeDesc.split(":")[0];
				} catch (Exception e) {}
				cell.setCellValue(servcdeDesc);
				cell.setCellStyle(tableCellStyle);
			}
			
			int bfServcdeHeaderRowIdx = rowCount;
			Map<String, Integer> bfSlptypeRowIdx = new LinkedHashMap<String, Integer>();

			cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + getNoOfServcde());
			cell.setCellValue("Total");
			cell.setCellStyle(tableCellStyle);
			
			
			// loop for slptypes
			subTotalRowIdxs = new HashMap<String, Integer>();
			itr = slptypesSet.iterator();
			k = 0;
			while (itr.hasNext()) {
				String slptype = itr.next();
				String slptypeDesc = slptypes.get(slptype);
				
				String BFCurrentMthRowIdx = returnDataBF.get("row:currentMth:" + slptype);
				String BFTotalMthRowIdx = returnDataBF.get("row:total:" + slptype);
				
				row = sheet1.createRow((short) rowCount++);
				int lastMthCfRowIdx = rowCount;
				bfSlptypeRowIdx.put(slptype, lastMthCfRowIdx);
				
				cell = row.createCell(0);
				cell.setCellValue(slptypeDesc + ":");
				cell.setCellStyle(tableCellBorderTopStyle);

				cell = row.createCell(1);
				cell.setCellValue("From Revenue B.F.");
				cell.setCellStyle(tableCellStyle);

				List<BigDecimal> thisLastMthCfServcdeSum = lastMthCfServcdeSums.get(slptype);
				for (int i = 0; i < getNoOfServcde(); i++) {
					cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + i);
					cell.setCellValue(thisLastMthCfServcdeSum.get(i).doubleValue());
					cell.setCellStyle(totalCellStyle);
				}
				
				cell = row.createCell(totalColIdx);
				cell.setCellFormula("SUM(" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM) + (rowCount) + ":" + convertColIdx2Char(totalColIdx - 1) + (rowCount) + ")");
				cell.setCellStyle(totalCellStyle);
				//------------
				
				row = sheet1.createRow((short) rowCount++);
				cell = row.createCell(0);
				cell.setCellStyle(tableCellNoBorderStyle);

				cell = row.createCell(1);
				cell.setCellValue("From " + radPayReportMthStr + " Revenue");
				cell.setCellStyle(tableCellStyle);
				
				for (int i = 0; i < getNoOfServcde(); i++) {
					cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + i);
					cell.setCellFormula("'" + payrollRpttypeSheetNames.get("BF") + "'!" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + i) + BFCurrentMthRowIdx);
					cell.setCellStyle(totalCellStyle);
				}

				cell = row.createCell(totalColIdx);
				cell.setCellFormula("SUM(" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM) + rowCount + ":" + convertColIdx2Char(totalColIdx - 1) + rowCount + ")");
				cell.setCellStyle(totalCellStyle);
				//------------
				
				row = sheet1.createRow((short) rowCount++);
				cell = row.createCell(0);
				cell.setCellStyle(tableCellNoBorderStyle);

				cell = row.createCell(1);
				cell.setCellValue("From " + radPayReportMthStr + " Adjustment");
				cell.setCellStyle(tableCellStyle);

				// ='BF-NetAmt'!C14-'BF-NetAmt'!C13-'Rad Pay Report'!C7
				for (int i = 0; i < getNoOfServcde(); i++) {
					cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + i);
					cell.setCellFormula("'" + payrollRpttypeSheetNames.get("BF") + "'!" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM+ i) + BFTotalMthRowIdx + "-" +
							"'" + payrollRpttypeSheetNames.get("BF") + "'!" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM+ i) + BFCurrentMthRowIdx + "-" +
							convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + i) + lastMthCfRowIdx);
					cell.setCellStyle(totalCellStyle);
				}

				cell = row.createCell(totalColIdx);
				cell.setCellFormula("SUM(" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM) + rowCount + ":" + convertColIdx2Char(totalColIdx - 1) + rowCount + ")");
				cell.setCellStyle(totalCellStyle);
				//------------

				row = sheet1.createRow((short) rowCount++);
				cell = row.createCell(0);
				cell.setCellStyle(tableCellBorderBottomStyle);

				cell = row.createCell(1);
				cell.setCellValue("Sub-total:");
				cell.setCellStyle(tableCellStyle);
				
				subTotalRowIdxs.put(slptype, rowCount);

				// =SUM(C7:C9)
				for (int i = 0; i < getNoOfServcde(); i++) {
					cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + i);
					cell.setCellFormula("SUM(" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + i) + (rowCount - 3) + ":" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + i) + (rowCount - 1) + ")");
					cell.setCellStyle(totalCellStyle);
				}

				cell = row.createCell(totalColIdx);
				cell.setCellFormula("SUM(" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM) + rowCount + ":" + convertColIdx2Char(totalColIdx - 1) + rowCount + ")");
				cell.setCellStyle(totalCellStyle);
				//------------
				
				// separator line
				row = sheet1.createRow((short) rowCount++);
				for (int i = 0; i < HK_HKRL_PAYROLL_HEAD_COL_NUM + getNoOfServcde() + 1; i++) {
					cell = row.createCell(i);
					if (i == HK_HKRL_PAYROLL_HEAD_COL_NUM + getNoOfServcde()) {
						cell.setCellStyle(tableCellBorderRightStyle);
					} else {
						cell.setCellStyle(tableCellNoBorderStyle);
					}
				}

				//-----------------------
			}
			//-----------------------

			row = sheet1.createRow((short) rowCount++);
			cell = row.createCell(0);
			cell.setCellValue("Total:");
			cell.setCellStyle(tableCellStyle);

			cell = row.createCell(1);
			cell.setCellStyle(tableCellStyle);

			// ==SUM(C10,C15)
			for (int i = 0; i < getNoOfServcde(); i++) {
				StringBuffer formula = new StringBuffer();
				itr = slptypesSet.iterator();
				while (itr.hasNext()) {
					String slptype = itr.next();
					Integer subTotalRowIdx = subTotalRowIdxs.get(slptype);
					if (formula.length() > 0) {
						formula.append(",");
					}
					formula.append(convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + i) + subTotalRowIdx.toString());
				}
				formula.append(")");
				
				cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + i);
				cell.setCellFormula("SUM(" + formula.toString());
				cell.setCellStyle(totalCellStyle);
			}
			
			cell = row.createCell(totalColIdx);
			cell.setCellFormula("SUM(" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM) + rowCount + ":" + convertColIdx2Char(totalColIdx - 1) + rowCount + ")");
			cell.setCellStyle(totalCellStyle);
			//--------------
			
			rowCount++;
			rowCount++;

			//==================
			// IC ACTUAL-NetAmt
			//==================
			row = sheet1.createRow((short) rowCount++);
			cell = row.createCell(0);
			cell.setCellValue(payrollRpttypeHeaders.get("IC:NetAmt").replace("%radPayReportMthStr%", radPayReportMthStr) + ":");
			cell.setCellStyle(header2Style);

			cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + getNoOfServcde());
			cell.setCellValue(DateTimeUtil.parseDate(endDate));
			cell.setCellStyle(reportDateStyle);

			row = sheet1.createRow((short) rowCount++);
			
			itr = servcdesSet.iterator();
			k = 0;
			while (itr.hasNext()) {
				cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + k++);
				String servcdeDesc = servcdes.get(itr.next());
				try {
					servcdeDesc = servcdeDesc.split(":")[0];
				} catch (Exception e) {}
				cell.setCellValue(servcdeDesc);
				cell.setCellStyle(tableCellStyle);
			}

			cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + getNoOfServcde());
			cell.setCellValue("Total");
			cell.setCellStyle(tableCellStyle);
			//--------------
			
			// loop for slptypes
			subTotalRowIdxs = new HashMap<String, Integer>();
			itr = slptypesSet.iterator();
			k = 0;
			while (itr.hasNext()) {
				String slptype = itr.next();
				String slptypeDesc = slptypes.get(slptype);
				
				String ICNetAmtCurrentMthRowIdx = returnDataICNetAmt.get("row:currentMth:" + slptype);
				String ICNetAmtTotalMthRowIdx = returnDataICNetAmt.get("row:total:" + slptype);
				
				row = sheet1.createRow((short) rowCount++);
				cell = row.createCell(0);
				cell.setCellValue(slptypeDesc + ":");
				cell.setCellStyle(tableCellBorderTopStyle);

				cell = row.createCell(1);
				cell.setCellValue("From Revenue B.F.");
				cell.setCellStyle(tableCellStyle);

				for (int i = 0; i < getNoOfServcde(); i++) {
					cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + i);
					cell.setCellFormula("'" + payrollRpttypeSheetNames.get("IC:NetAmt") + "'!" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + i) + ICNetAmtTotalMthRowIdx + "-" +
						"'" + payrollRpttypeSheetNames.get("IC:NetAmt") + "'!" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM+ i) + ICNetAmtCurrentMthRowIdx);
					cell.setCellStyle(totalCellStyle);
				}

				cell = row.createCell(totalColIdx);
				cell.setCellFormula("SUM(" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM) + rowCount + ":" + convertColIdx2Char(totalColIdx - 1) + rowCount + ")");
				cell.setCellStyle(totalCellStyle);
				//-----------------

				row = sheet1.createRow((short) rowCount++);
				cell = row.createCell(0);
				cell.setCellStyle(tableCellNoBorderStyle);
				
				cell = row.createCell(1);
				cell.setCellValue("From " + radPayReportMthStr + " Revenue");
				cell.setCellStyle(tableCellStyle);

				for (int i = 0; i < getNoOfServcde(); i++) {
					cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + i);
					cell.setCellFormula("'" + payrollRpttypeSheetNames.get("IC:NetAmt") + "'!" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + i) + ICNetAmtCurrentMthRowIdx);
					cell.setCellStyle(totalCellStyle);
				}

				cell = row.createCell(totalColIdx);
				cell.setCellFormula("SUM(" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM) + rowCount + ":" + convertColIdx2Char(totalColIdx - 1) + rowCount + ")");
				cell.setCellStyle(totalCellStyle);
				//------------------

				row = sheet1.createRow((short) rowCount++);
				cell = row.createCell(0);
				cell.setCellStyle(tableCellBorderBottomStyle);
				
				cell = row.createCell(1);
				cell.setCellValue("Sub-total:");
				cell.setCellStyle(tableCellStyle);
				
				subTotalRowIdxs.put(slptype, rowCount);

				// =SUM(C7:C9)
				for (int i = 0; i < getNoOfServcde(); i++) {
					cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + i);
					cell.setCellFormula("SUM(" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + i) + (rowCount - 2) + ":" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + i) + (rowCount - 1) + ")");
					cell.setCellStyle(totalCellStyle);
				}

				cell = row.createCell(totalColIdx);
				cell.setCellFormula("SUM(" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM) + rowCount + ":" + convertColIdx2Char(totalColIdx - 1) + rowCount + ")");
				cell.setCellStyle(totalCellStyle);
				//------------
				
				// separator line
				row = sheet1.createRow((short) rowCount++);
				for (int i = 0; i < HK_HKRL_PAYROLL_HEAD_COL_NUM + getNoOfServcde() + 1; i++) {
					cell = row.createCell(i);
					if (i == HK_HKRL_PAYROLL_HEAD_COL_NUM + getNoOfServcde()) {
						cell.setCellStyle(tableCellBorderRightStyle);
					} else {
						cell.setCellStyle(tableCellNoBorderStyle);
					}
				}
				//-----------------------
			}
			//------------

			row = sheet1.createRow((short) rowCount++);
			cell = row.createCell(0);
			cell.setCellValue("Total:");
			cell.setCellStyle(tableCellStyle);

			cell = row.createCell(1);
			cell.setCellStyle(tableCellStyle);

			for (int i = 0; i < getNoOfServcde(); i++) {
				StringBuffer formula = new StringBuffer();
				itr = slptypesSet.iterator();
				while (itr.hasNext()) {
					String slptype = itr.next();
					Integer subTotalRowIdx = subTotalRowIdxs.get(slptype);
					if (formula.length() > 0) {
						formula.append(",");
					}
					formula.append(convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + i) + subTotalRowIdx.toString());
				}
				formula.append(")");
				
				cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + i);
				cell.setCellFormula("SUM(" + formula.toString());
				cell.setCellStyle(totalCellStyle);
			}

			cell = row.createCell(totalColIdx);
			cell.setCellFormula("SUM(" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM) + rowCount + ":" + convertColIdx2Char(totalColIdx - 1) + rowCount + ")");
			cell.setCellStyle(totalCellStyle);
			//--------------
			
			rowCount++;
			rowCount++;

			//==================
			// IC Comm
			//==================
			if (payrollRpttypeHeaders.get("IC:Comm") != null) {
				row = sheet1.createRow((short) rowCount++);
				cell = row.createCell(0);
				cell.setCellValue(payrollRpttypeHeaders.get("IC:Comm").replace("%radPayReportMthStr%", radPayReportMthStr) + ":");
				cell.setCellStyle(header2Style);
	
				cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + getNoOfServcde());
				cell.setCellValue(DateTimeUtil.parseDate(endDate));
				cell.setCellStyle(reportDateStyle);
	
				row = sheet1.createRow((short) rowCount++);
				
				itr = servcdesSet.iterator();
				k = 0;
				while (itr.hasNext()) {
					cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + k++);
					String servcdeDesc = servcdes.get(itr.next());
					try {
						servcdeDesc = servcdeDesc.split(":")[0];
					} catch (Exception e) {}
					cell.setCellValue(servcdeDesc);
					cell.setCellStyle(tableCellStyle);
				}
	
				cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + getNoOfServcde());
				cell.setCellValue("Total");
				cell.setCellStyle(tableCellStyle);
				//--------------
				
				// loop for slptypes
				subTotalRowIdxs = new HashMap<String, Integer>();
				itr = slptypesSet.iterator();
				k = 0;
				while (itr.hasNext()) {
					String slptype = itr.next();
					String slptypeDesc = slptypes.get(slptype);
					
					String ICCommCurrentMthRowIdx = returnDataICNetAmt.get("row:currentMth:" + slptype);
					String ICCommTotalMthRowIdx = returnDataICNetAmt.get("row:total:" + slptype);
					
					/*
					row = sheet1.createRow((short) rowCount++);
					cell = row.createCell(0);
					cell.setCellValue(slptypeDesc + ":");
					cell.setCellStyle(tableCellBorderTopStyle);
	
					cell = row.createCell(1);
					cell.setCellValue("From Revenue B.F.");
					cell.setCellStyle(tableCellStyle);
	
					for (int i = 0; i < getNoOfServcde(); i++) {
						cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + i);
						cell.setCellFormula("'" + payrollRpttypeSheetNames.get("IC:NetAmt") + "'!" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + i) + ICNetAmtTotalMthRowIdx + "-" +
							"'" + payrollRpttypeSheetNames.get("IC:NetAmt") + "'!" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM+ i) + ICNetAmtCurrentMthRowIdx);
						cell.setCellStyle(totalCellStyle);
					}
	
					cell = row.createCell(totalColIdx);
					cell.setCellFormula("SUM(" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM) + rowCount + ":" + convertColIdx2Char(totalColIdx - 1) + rowCount + ")");
					cell.setCellStyle(totalCellStyle);
					//-----------------
					*/
	
					/*
					row = sheet1.createRow((short) rowCount++);
					cell = row.createCell(0);
					cell.setCellStyle(tableCellNoBorderStyle);
					
					cell = row.createCell(1);
					cell.setCellValue("From " + radPayReportMthStr + " Revenue");
					cell.setCellStyle(tableCellStyle);
	
					for (int i = 0; i < getNoOfServcde(); i++) {
						cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + i);
						cell.setCellFormula("'" + payrollRpttypeSheetNames.get("IC:NetAmt") + "'!" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + i) + ICNetAmtCurrentMthRowIdx);
						cell.setCellStyle(totalCellStyle);
					}
	
					cell = row.createCell(totalColIdx);
					cell.setCellFormula("SUM(" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM) + rowCount + ":" + convertColIdx2Char(totalColIdx - 1) + rowCount + ")");
					cell.setCellStyle(totalCellStyle);
					//------------------
					*/
	
					row = sheet1.createRow((short) rowCount++);
					cell = row.createCell(0);
					cell.setCellValue(slptypeDesc + ":");
					cell.setCellStyle(tableCellStyle);
					
					cell = row.createCell(1);
					cell.setCellValue("Sub-total:");
					cell.setCellStyle(tableCellStyle);
					
					subTotalRowIdxs.put(slptype, rowCount);
	
					for (int i = 0; i < getNoOfServcde(); i++) {
						cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + i);
						cell.setCellFormula("'" + payrollRpttypeSheetNames.get("IC:Comm") + "'!" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + i) + ICCommTotalMthRowIdx);
						cell.setCellStyle(totalCellStyle);
					}
	
					cell = row.createCell(totalColIdx);
					cell.setCellFormula("SUM(" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM) + rowCount + ":" + convertColIdx2Char(totalColIdx - 1) + rowCount + ")");
					cell.setCellStyle(totalCellStyle);
					//------------
					
					// separator line
					row = sheet1.createRow((short) rowCount++);
					for (int i = 0; i < HK_HKRL_PAYROLL_HEAD_COL_NUM + getNoOfServcde() + 1; i++) {
						cell = row.createCell(i);
						if (i == HK_HKRL_PAYROLL_HEAD_COL_NUM + getNoOfServcde()) {
							cell.setCellStyle(tableCellBorderRightStyle);
						} else {
							cell.setCellStyle(tableCellNoBorderStyle);
						}
					}
					//-----------------------
				}
				//------------
	
				row = sheet1.createRow((short) rowCount++);
				cell = row.createCell(0);
				cell.setCellValue("Total:");
				cell.setCellStyle(tableCellStyle);
	
				cell = row.createCell(1);
				cell.setCellStyle(tableCellStyle);
	
				for (int i = 0; i < getNoOfServcde(); i++) {
					StringBuffer formula = new StringBuffer();
					itr = slptypesSet.iterator();
					while (itr.hasNext()) {
						String slptype = itr.next();
						Integer subTotalRowIdx = subTotalRowIdxs.get(slptype);
						if (formula.length() > 0) {
							formula.append(",");
						}
						formula.append(convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + i) + subTotalRowIdx.toString());
					}
					formula.append(")");
					
					cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + i);
					cell.setCellFormula("SUM(" + formula.toString());
					cell.setCellStyle(totalCellStyle);
				}
	
				cell = row.createCell(totalColIdx);
				cell.setCellFormula("SUM(" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM) + rowCount + ":" + convertColIdx2Char(totalColIdx - 1) + rowCount + ")");
				cell.setCellStyle(totalCellStyle);
				//--------------
				
				rowCount++;
				rowCount++;
			}

			//==================
			// IC DRPAY
			//==================
			row = sheet1.createRow((short) rowCount++);
			cell = row.createCell(0);
			cell.setCellValue(payrollRpttypeHeaders.get("IC:DRPAY").replace("%radPayReportMthStr%", radPayReportMthStr) + ":");
			cell.setCellStyle(header2Style);
			
			cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + getNoOfServcde());
			cell.setCellValue(DateTimeUtil.parseDate(endDate));
			cell.setCellStyle(reportDateStyle);

			row = sheet1.createRow((short) rowCount++);
			
			itr = servcdesSet.iterator();
			k = 0;
			while (itr.hasNext()) {
				cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + k++);
				String servcdeDesc = servcdes.get(itr.next());
				try {
					servcdeDesc = servcdeDesc.split(":")[0] + " (" + servcdeDesc.split(":")[1] + ")";
				} catch (Exception e) {}
				cell.setCellValue(servcdeDesc);
				cell.setCellStyle(tableCellStyle);
			}

			cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + getNoOfServcde());
			cell.setCellValue("Total");
			cell.setCellStyle(tableCellStyle);
			//--------------
			
			// loop for slptypes
			subTotalRowIdxs = new HashMap<String, Integer>();
			itr = slptypesSet.iterator();
			k = 0;
			while (itr.hasNext()) {
				String slptype = itr.next();
				String slptypeDesc = slptypes.get(slptype);
				
				String ICDRPAYCurrentMthRowIdx = returnDataICDRPAY.get("row:currentMth:" + slptype);
				String ICDRPAYTotalMthRowIdx = returnDataICDRPAY.get("row:total:" + slptype);
				
				String ICCommCurrentMthRowIdx = returnDataICComm.get("row:currentMth:" + slptype);
				String ICCommTotalMthRowIdx = returnDataICComm.get("row:total:" + slptype);
				
				row = sheet1.createRow((short) rowCount++);
				cell = row.createCell(0);
				cell.setCellValue(slptypeDesc + ":");
				cell.setCellStyle(tableCellBorderTopStyle);

				cell = row.createCell(1);
				cell.setCellValue("Cal. From Revenue B.F.");
				cell.setCellStyle(tableCellStyle);

				for (int i = 0; i < getNoOfServcde(); i++) {
					cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + i);
					cell.setCellFormula("'" + payrollRpttypeSheetNames.get("IC:DRPAY") + "'!" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + i) + ICDRPAYTotalMthRowIdx + "-" +
						"'" + payrollRpttypeSheetNames.get("IC:DRPAY") + "'!" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM+ i) + ICDRPAYCurrentMthRowIdx);
					cell.setCellStyle(totalCellStyle);
				}

				cell = row.createCell(totalColIdx);
				cell.setCellFormula("SUM(" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM) + rowCount + ":" + convertColIdx2Char(totalColIdx - 1) + rowCount + ")");
				cell.setCellStyle(totalCellStyle);
				//-----------------
				
				row = sheet1.createRow((short) rowCount++);
				cell = row.createCell(0);
				cell.setCellStyle(tableCellNoBorderStyle);

				cell = row.createCell(1);
				cell.setCellValue("From " + radPayReportMthStr + " Revenue");
				cell.setCellStyle(tableCellStyle);

				for (int i = 0; i < getNoOfServcde(); i++) {
					cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + i);
					cell.setCellFormula("'" + payrollRpttypeSheetNames.get("IC:DRPAY") + "'!" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + i) + ICDRPAYCurrentMthRowIdx);
					cell.setCellStyle(totalCellStyle);
				}

				cell = row.createCell(totalColIdx);
				cell.setCellFormula("SUM(" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM) + rowCount + ":" + convertColIdx2Char(totalColIdx - 1) + rowCount + ")");
				cell.setCellStyle(totalCellStyle);
				//------------------

				row = sheet1.createRow((short) rowCount++);
				cell = row.createCell(0);
				cell.setCellStyle(tableCellBorderBottomStyle);
				
				cell = row.createCell(1);
				cell.setCellValue("Sub-total:");
				cell.setCellStyle(tableCellStyle);
				
				subTotalRowIdxs.put(slptype, rowCount);

				// =SUM(C7:C9)
				for (int i = 0; i < getNoOfServcde(); i++) {
					cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + i);
					cell.setCellFormula("SUM(" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + i) + (rowCount - 2) + ":" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + i) + (rowCount - 1) + ")");
					cell.setCellStyle(totalCellStyle);
				}

				cell = row.createCell(totalColIdx);
				cell.setCellFormula("SUM(" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM) + rowCount + ":" + convertColIdx2Char(totalColIdx - 1) + rowCount + ")");
				cell.setCellStyle(totalCellStyle);
				//------------

				// separator line
				row = sheet1.createRow((short) rowCount++);
				for (int i = 0; i < HK_HKRL_PAYROLL_HEAD_COL_NUM + getNoOfServcde() + 1; i++) {
					cell = row.createCell(i);
					if (i == HK_HKRL_PAYROLL_HEAD_COL_NUM + getNoOfServcde()) {
						cell.setCellStyle(tableCellBorderRightStyle);
					} else {
						cell.setCellStyle(tableCellNoBorderStyle);
					}
				}
			}
			//------------
			
			row = sheet1.createRow((short) rowCount++);
			cell = row.createCell(0);
			cell.setCellValue("Total:");
			cell.setCellStyle(tableCellStyle);
			
			cell = row.createCell(1);
			cell.setCellStyle(tableCellStyle);

			for (int i = 0; i < getNoOfServcde(); i++) {
				StringBuffer formula = new StringBuffer();
				itr = slptypesSet.iterator();
				while (itr.hasNext()) {
					String slptype = itr.next();
					Integer subTotalRowIdx = subTotalRowIdxs.get(slptype);
					if (formula.length() > 0) {
						formula.append(",");
					}
					formula.append(convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + i) + subTotalRowIdx.toString());
				}
				formula.append(")");
				
				cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + i);
				cell.setCellFormula("SUM(" + formula.toString());
				cell.setCellStyle(totalCellStyle);
			}

			cell = row.createCell(totalColIdx);
			cell.setCellFormula("SUM(" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM) + rowCount + ":" + convertColIdx2Char(totalColIdx - 1) + rowCount + ")");
			cell.setCellStyle(totalCellStyle);
			//--------------
			
			rowCount++;
			rowCount++;

			//==================
			// CF
			//==================
			row = sheet1.createRow((short) rowCount++);
			cell = row.createCell(0);
			cell.setCellValue(payrollRpttypeHeaders.get("CF").replace("%radPayReportMthStr%", radPayReportMthStr) + ":");
			cell.setCellStyle(header2Style);

			row = sheet1.createRow((short) rowCount++);
			
			itr = servcdesSet.iterator();
			k = 0;
			while (itr.hasNext()) {
				cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + k++);
				String servcdeDesc = servcdes.get(itr.next());
				try {
					servcdeDesc = servcdeDesc.split(":")[0];
				} catch (Exception e) {}
				cell.setCellValue(servcdeDesc);
				cell.setCellStyle(tableCellStyle);
			}

			cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + getNoOfServcde());
			cell.setCellValue("Total");
			cell.setCellStyle(tableCellStyle);
			//--------------

			// loop for slptypes
			subTotalRowIdxs = new HashMap<String, Integer>();
			itr = slptypesSet.iterator();
			k = 0;
			while (itr.hasNext()) {
				String slptype = itr.next();
				String slptypeDesc = slptypes.get(slptype);
				
				String CFCurrentMthRowIdx = returnDataCF.get("row:currentMth:" + slptype);
				String CFTotalMthRowIdx = returnDataCF.get("row:total:" + slptype);
				
				row = sheet1.createRow((short) rowCount++);
				cell = row.createCell(0);
				cell.setCellValue(slptypeDesc + ":");
				cell.setCellStyle(tableCellBorderTopStyle);

				cell = row.createCell(1);
				cell.setCellValue("From Revenue B.F.");
				cell.setCellStyle(tableCellStyle);

				for (int i = 0; i < getNoOfServcde(); i++) {
					cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + i);
					cell.setCellFormula("'" + payrollRpttypeSheetNames.get("CF") + "'!" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + i) + CFTotalMthRowIdx + "-" +
						"'" + payrollRpttypeSheetNames.get("CF") + "'!" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM+ i) + CFCurrentMthRowIdx);
					cell.setCellStyle(totalCellStyle);
				}

				cell = row.createCell(totalColIdx);
				cell.setCellFormula("SUM(" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM) + rowCount + ":" + convertColIdx2Char(totalColIdx - 1) + rowCount + ")");
				cell.setCellStyle(totalCellStyle);
				//-----------------
				
				row = sheet1.createRow((short) rowCount++);
				cell = row.createCell(0);
				cell.setCellStyle(tableCellNoBorderStyle);

				cell = row.createCell(1);
				cell.setCellValue("From " + radPayReportMthStr + " Revenue");
				cell.setCellStyle(tableCellStyle);

				for (int i = 0; i < getNoOfServcde(); i++) {
					cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + i);
					cell.setCellFormula("'" + payrollRpttypeSheetNames.get("CF") + "'!" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + i) + CFCurrentMthRowIdx);
					cell.setCellStyle(totalCellStyle);
				}

				cell = row.createCell(totalColIdx);
				cell.setCellFormula("SUM(" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM) + rowCount + ":" + convertColIdx2Char(totalColIdx - 1) + rowCount + ")");
				cell.setCellStyle(totalCellStyle);
				//------------------
				
				row = sheet1.createRow((short) rowCount++);
				cell = row.createCell(0);
				cell.setCellStyle(tableCellBorderBottomStyle);	
				
				cell = row.createCell(1);
				cell.setCellValue("Sub-total:");
				cell.setCellStyle(tableCellStyle);

				subTotalRowIdxs.put(slptype, rowCount);

				// =SUM(C7:C9)
				for (int i = 0; i < getNoOfServcde(); i++) {
					cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + i);
					cell.setCellFormula("SUM(" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + i) + (rowCount - 2) + ":" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + i) + (rowCount - 1) + ")");
					cell.setCellStyle(totalCellStyle);
				}

				cell = row.createCell(totalColIdx);
				cell.setCellFormula("SUM(" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM) + rowCount + ":" + convertColIdx2Char(totalColIdx - 1) + rowCount + ")");
				cell.setCellStyle(totalCellStyle);
				//------------

				// separator line
				row = sheet1.createRow((short) rowCount++);
				for (int i = 0; i < HK_HKRL_PAYROLL_HEAD_COL_NUM + getNoOfServcde() + 1; i++) {
					cell = row.createCell(i);
					if (i == HK_HKRL_PAYROLL_HEAD_COL_NUM + getNoOfServcde()) {
						cell.setCellStyle(tableCellBorderRightStyle);
					} else {
						cell.setCellStyle(tableCellNoBorderStyle);
					}
				}
				//-----------------------
			}
			//------------
			
			row = sheet1.createRow((short) rowCount++);
			cell = row.createCell(0);
			cell.setCellValue("Total:");
			cell.setCellStyle(tableCellStyle);

			cell = row.createCell(1);
			cell.setCellStyle(totalCellStyle);

			for (int i = 0; i < getNoOfServcde(); i++) {
				StringBuffer formula = new StringBuffer();
				itr = slptypesSet.iterator();
				while (itr.hasNext()) {
					String slptype = itr.next();
					Integer subTotalRowIdx = subTotalRowIdxs.get(slptype);
					if (formula.length() > 0) {
						formula.append(",");
					}
					formula.append(convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + i) + subTotalRowIdx.toString());
				}
				formula.append(")");
				
				cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + i);
				cell.setCellFormula("SUM(" + formula.toString());
				cell.setCellStyle(totalCellStyle);
			}

			cell = row.createCell(totalColIdx);
			cell.setCellFormula("SUM(" + convertColIdx2Char(HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM) + rowCount + ":" + convertColIdx2Char(totalColIdx - 1) + rowCount + ")");
			cell.setCellStyle(totalCellStyle);
			//--------------

			rowCount++;
			rowCount++;
			
			//==================
			// Report footer
			//==================
			row = sheet1.createRow((short) rowCount++);
			cell = row.createCell(0);
			cell.setCellValue("Report Date:");
			cell.setCellStyle(normalStyle);

			cell = row.createCell(1);
			cell.setCellValue(DateTimeUtil.parseDate(endDate));
			cell.setCellStyle(reportDateStyle);

			cell = row.createCell(3);
			cell.setCellValue("Reported By:");
			cell.setCellStyle(periodStyle);

			cell = row.createCell(4);
			cell.setCellValue(reportedByNames.get(ConstantsServerSide.SITE_CODE));
			cell.setCellStyle(reportedByStyle);
			
			Sheet sheet = wb.getSheetAt(0);
			sheet.setColumnWidth(0, 15 * 256);
			sheet.autoSizeColumn(1);
			for (int i = 0; i < getNoOfServcde(); i++) {
				sheet.setColumnWidth(HK_HKRL_PAYROLL_HEAD_COL_NUM + i, 16 * 256);
			}
			sheet.setColumnWidth(HK_HKRL_PAYROLL_HEAD_COL_NUM + getNoOfServcde(), 16 * 256);

			// create adjustment breakdown sheet
			Sheet sheetAdjBreakdown = createSheetAdjBreakdown(wb, bfServcdeHeaderRowIdx, bfSlptypeRowIdx,
					actualrun, endDate, payTo);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return wb;
	}
	
	protected Sheet createSheetRpttype(Workbook wb, String rpttype, String rpttypeSub, 
			String actualRun, String endDate, String payTo, Map<String, String> returnData) {
		// Font
		Font headerPatTypeFont = wb.createFont();
		headerPatTypeFont.setFontHeightInPoints((short) 9);
		headerPatTypeFont.setFontName("Arial");
		headerPatTypeFont.setBoldweight(Font.BOLDWEIGHT_BOLD);

		Font headerTblFont = wb.createFont();
		headerTblFont.setFontHeightInPoints((short) 9);
		headerTblFont.setFontName("新細明體");

		Font normalFont = wb.createFont();
		normalFont.setFontHeightInPoints((short) 9);
		normalFont.setFontName("Arial");

		// Style
		CellStyle headerPatTypeStyle = wb.createCellStyle();
		headerPatTypeStyle.setFont(headerPatTypeFont);

		CellStyle headerTblStyle = wb.createCellStyle();
		headerTblStyle.setFont(headerTblFont);

		CellStyle highlightBgColorStyle = wb.createCellStyle();
		highlightBgColorStyle
				.setFillForegroundColor(IndexedColors.GREY_25_PERCENT
						.getIndex());
		highlightBgColorStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);

		CellStyle tblHeaderStyle = wb.createCellStyle();
		tblHeaderStyle.cloneStyleFrom(highlightBgColorStyle);
		tblHeaderStyle.setAlignment(CellStyle.ALIGN_CENTER);
		tblHeaderStyle.setBorderBottom(CellStyle.BORDER_THIN);
		tblHeaderStyle.setBorderTop(CellStyle.BORDER_THIN);
		tblHeaderStyle.setBorderLeft(CellStyle.BORDER_THIN);
		tblHeaderStyle.setBorderRight(CellStyle.BORDER_THIN);
		tblHeaderStyle.setFont(normalFont);
		
		DataFormat format = wb.createDataFormat();
		CellStyle tableCellStyle = wb.createCellStyle();
		tableCellStyle.setDataFormat(format
				.getFormat(EXCEL_CURRENCY_SIMPLE_FORMAT));
		tableCellStyle.setAlignment(CellStyle.ALIGN_RIGHT);
		tableCellStyle.setFont(normalFont);
		
		CellStyle totalCellStyle = wb.createCellStyle();
		totalCellStyle.cloneStyleFrom(tableCellStyle);
		totalCellStyle.setFont(headerPatTypeFont);
		
		CellStyle mthCellStyle = wb.createCellStyle();
		mthCellStyle.setDataFormat(format
				.getFormat(EXCEL_YR_MONTH_FORMAT));
		mthCellStyle.setAlignment(CellStyle.ALIGN_RIGHT);
		mthCellStyle.setFont(normalFont);

		// ----------------------
		// Sheet by month
		// ----------------------
		Sheet sheet = wb.createSheet(payrollRpttypeSheetNames.get(
				rpttype + (rpttypeSub == null ? "" : ":" + rpttypeSub)));
		sheet.setColumnWidth(0, 12 * 256);
		sheet.setColumnWidth(1, 12 * 256);
		returnData = returnData == null ? returnData = new HashMap<String, String>() : returnData;
		
		int rowCount = 0;
		Row row = null;
		Cell cell = null;
		Iterator<String> itr = null;
		Iterator<String> itr2 = null;
		int k = 0;
				
		Set<String> slptypesSet = slptypes.keySet();
		itr = slptypesSet.iterator();
		k = 0;
		while (itr.hasNext()) {
			String slptype = itr.next();
			
			List<ReportableListObject> summaryByExdateServcde = null;
			if ("DRPAY".equals(rpttypeSub)) {
				summaryByExdateServcde = 
						DiIncomeReportDB.getPayrollSummaryByExdateDrpayServcde(rpttype, slptype, actualRun, endDate, payTo);
			} else if ("Comm".equals(rpttypeSub)) {
				summaryByExdateServcde = 
						DiIncomeReportDB.getPayrollSummaryByExdateCommServcde(rpttype, slptype, actualRun, endDate, payTo);
			} else {
				summaryByExdateServcde = 
						DiIncomeReportDB.getPayrollSummaryByExdateServcde(rpttype, slptype, actualRun, endDate, payTo);
			}
			
			// Table header
			row = sheet.createRow((short) rowCount++);
			cell = row.createCell(0);
			cell.setCellValue(slptypes.get(slptype));
			cell.setCellStyle(headerPatTypeStyle);

			row = sheet.createRow((short) rowCount++);
			cell = row.createCell(0);
			cell.setCellValue("Month");
			cell.setCellStyle(tblHeaderStyle);

			cell = row.createCell(1);
			cell.setCellValue("Total");
			cell.setCellStyle(tblHeaderStyle);

			Set<String> servcdesSet = servcdes.keySet();
			itr2 = servcdesSet.iterator();
			int l = 0;
			while (itr2.hasNext()) {
				int curCol = HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + l;
				String key = itr2.next();
				cell = row.createCell(curCol);
				cell.setCellValue("(" + key + ")");
				cell.setCellStyle(tblHeaderStyle);
				
				sheet.setColumnWidth(curCol, 12 * 256);
				l++;
			}
			
			// Month detail
			int startRow = rowCount + 1;
			for (int i = 0; i < summaryByExdateServcde.size(); i++) {
				ReportableListObject rlo = summaryByExdateServcde.get(i);
				row = sheet.createRow((short) rowCount++);
				for (int j = 0; j < HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + getNoOfServcde(); j++) {
					cell = row.createCell(j);
					String val = rlo.getValue(j);
					if (j== 0) {
						try {
							if (val != null && !val.isEmpty()) {
								cell.setCellValue(DateTimeUtil.parseDateReverse(val));
							}
						} catch (Exception e) {
							System.err.println("Cannot parse " + val + " to date");
						}
					} else if (j== 1) {
						cell.setCellFormula("SUM(C" + (rowCount) + ":I" + (rowCount) + ")");
					} else {
						try {
							if (val != null && !val.isEmpty()) {
								cell.setCellValue(Double.parseDouble(val));
							}
						} catch (Exception e) {
							System.err.println("Cannot parse " + val + " to dobule");
						}
					}
					cell.setCellStyle(j == 0 ? mthCellStyle : tableCellStyle);
				}
			}
			
			// Total row
			returnData.put("row:currentMth:" + slptype, String.valueOf(rowCount));
			
			row = sheet.createRow((short) rowCount++);
			cell = row.createCell(1);
			cell.setCellFormula("SUM(B" + (startRow) + ":B" + (rowCount - 1) + ")");
			cell.setCellStyle(totalCellStyle);
			for (int i = 0; i < getNoOfServcde(); i++) {
				String colChar = convertColIdx2Char(2 + i);
				cell = row.createCell(2 + i);
				cell.setCellFormula("SUM(" + colChar + startRow + ":" + colChar + (rowCount - 1) + ")");
				cell.setCellStyle(totalCellStyle);
			}
			returnData.put("row:total:" + slptype, String.valueOf(rowCount));
			
			rowCount++;
		}
		return sheet;
	}

	protected Sheet createSheetAdjBreakdown(Workbook wb, int servcdeHeaderRowIdx, Map<String, Integer> slptypeRowIdx, 
			String actualrun, String endDate, String payTo) {
		// Font
		Font header2Font = wb.createFont();
		header2Font.setFontHeightInPoints((short) 10);
		header2Font.setFontName("Arial");
		header2Font.setBoldweight(Font.BOLDWEIGHT_BOLD);
		header2Font.setUnderline(Font.U_SINGLE);
		
		Font headerPatTypeFont = wb.createFont();
		headerPatTypeFont.setFontHeightInPoints((short) 9);
		headerPatTypeFont.setFontName("Arial");
		headerPatTypeFont.setBoldweight(Font.BOLDWEIGHT_BOLD);

		Font normalFont = wb.createFont();
		normalFont.setFontHeightInPoints((short) 10);
		normalFont.setFontName("Arial");

		// Style
		CellStyle header2Style = wb.createCellStyle();
		header2Style.setFont(header2Font);
		
		CellStyle headerPatTypeStyle = wb.createCellStyle();
		headerPatTypeStyle.setFont(headerPatTypeFont);
		
		CellStyle highlightBgColorStyle = wb.createCellStyle();
		highlightBgColorStyle
				.setFillForegroundColor(IndexedColors.GREY_25_PERCENT
						.getIndex());
		highlightBgColorStyle.setFillPattern(CellStyle.SOLID_FOREGROUND);
		
		CellStyle tableCellStyle = wb.createCellStyle();
		tableCellStyle.cloneStyleFrom(highlightBgColorStyle);
		tableCellStyle.setBorderBottom(CellStyle.BORDER_THIN);
		tableCellStyle.setBorderTop(CellStyle.BORDER_THIN);
		tableCellStyle.setBorderLeft(CellStyle.BORDER_THIN);
		tableCellStyle.setBorderRight(CellStyle.BORDER_THIN);
		tableCellStyle.setFont(normalFont);
		
		CellStyle tableCellBorderTopStyle = wb.createCellStyle();
		tableCellBorderTopStyle.cloneStyleFrom(highlightBgColorStyle);
		tableCellBorderTopStyle.setBorderTop(CellStyle.BORDER_THIN);
		
		DataFormat format = wb.createDataFormat();
		CellStyle totalCellStyle = wb.createCellStyle();
		totalCellStyle.cloneStyleFrom(highlightBgColorStyle);
		totalCellStyle.setBorderBottom(CellStyle.BORDER_THIN);
		totalCellStyle.setBorderTop(CellStyle.BORDER_THIN);
		totalCellStyle.setBorderLeft(CellStyle.BORDER_THIN);
		totalCellStyle.setBorderRight(CellStyle.BORDER_THIN);
		totalCellStyle.setDataFormat(format
				.getFormat(EXCEL_CURRENCY_FORMAT));
		totalCellStyle.setFont(normalFont);
		
		CellStyle adjTotalCellStyle = wb.createCellStyle();
		adjTotalCellStyle.setBorderBottom(CellStyle.BORDER_DOUBLE);
		adjTotalCellStyle.setBorderTop(CellStyle.BORDER_THIN);
		adjTotalCellStyle.setDataFormat(format
				.getFormat(EXCEL_CURRENCY_FORMAT));
		adjTotalCellStyle.setFont(headerPatTypeFont);
		

		// ----------------------
		// Sheet by month
		// ----------------------
		Sheet sheet = wb.createSheet("BF-Adjustment Breakdown");
		sheet.setColumnWidth(0, 15 * 256);
		sheet.setColumnWidth(1, 30 * 256);
		for (int i = 0; i < getNoOfServcde(); i++) {
			sheet.setColumnWidth(HK_HKRL_PAYROLL_HEAD_COL_NUM + i, 16 * 256);
		}
		sheet.setColumnWidth(HK_HKRL_PAYROLL_HEAD_COL_NUM + getNoOfServcde(), 18 * 256);	// Total
		for (int i = HK_HKRL_PAYROLL_HEAD_COL_NUM + getNoOfServcde() + 1; i < 19; i++) {
			sheet.setColumnWidth(i, 12 * 256);
		}
		sheet.setColumnWidth(19, 40 * 256);	// Remark
		
		int rowCount = 0;
		Row row = null;
		Cell cell = null;
		Iterator<String> itr = null;
		Iterator<String> itr2 = null;
		int k = 0;
		String summarySheetName = payrollRpttypeSheetNames.get("Summary");
		String lastMthEndDate = null;
		try {
			Calendar lastMthEndDateCal = Calendar.getInstance();
			lastMthEndDateCal.setTime(DateTimeUtil.parseDate(endDate));
			lastMthEndDateCal.add(Calendar.MONTH, -1);
			lastMthEndDateCal.set(Calendar.DATE, lastMthEndDateCal.getActualMaximum(Calendar.DAY_OF_MONTH));
			lastMthEndDate = DateTimeUtil.formatDate(lastMthEndDateCal.getTime());
		} catch (Exception ex) {
			System.out.println("createSheetAdjBreakdown lastMthEndDate error:" + ex.getMessage());
		}
		Date endDateDate = DateTimeUtil.parseDate(endDate);
		String radPayReportMthStr = payrollReportMthStrDateFormat
				.format(endDateDate);
		
		// Table header
		row = sheet.createRow((short) rowCount++);
		cell = row.createCell(0);
		cell.setCellValue("Outstanding Revenue Brought Forward Before Radiologist Payment");
		cell.setCellStyle(header2Style);
		
		Set<String> slptypesSet = slptypes.keySet();
		itr = slptypesSet.iterator();
		while (itr.hasNext()) {
			String slptype = itr.next();
			
			// separator
			row = sheet.createRow((short) rowCount++);
			row = sheet.createRow((short) rowCount++);
			
			// servcde header
			row = sheet.createRow((short) rowCount++);
			
			Set<String> servcdesSet = servcdes.keySet();
			itr2 = servcdesSet.iterator();
			k = 0;
			while (itr2.hasNext()) {
				int curCol = HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + k;
				String key = itr2.next();
				cell = row.createCell(curCol);
				cell.setCellFormula("'" + summarySheetName + "'!" + convertColIdx2Char(curCol) + servcdeHeaderRowIdx);
				cell.setCellStyle(tableCellStyle);
				
				k++;
			}
			
			cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + getNoOfServcde());
			cell.setCellFormula("'" + summarySheetName + "'!" + convertColIdx2Char(HK_HKRL_PAYROLL_HEAD_COL_NUM + getNoOfServcde()) + servcdeHeaderRowIdx);
			cell.setCellStyle(tableCellStyle);

			
			// servcde adjustment row
			int r = slptypeRowIdx.get(slptype);
			int adjRowIdx = r + 2;
			row = sheet.createRow((short) rowCount++);
			cell = row.createCell(0);
			cell.setCellFormula("'" + summarySheetName + "'!" + convertColIdx2Char(0) + r);
			cell.setCellStyle(tableCellBorderTopStyle);

			cell = row.createCell(1);
			cell.setCellFormula("'" + summarySheetName + "'!" + convertColIdx2Char(1) + adjRowIdx);
			cell.setCellStyle(tableCellStyle);
			
			itr2 = servcdesSet.iterator();
			k = 0;
			while (itr2.hasNext()) {
				int curCol = HK_HKRL_PAYROLL_MTH_HEAD_COL_NUM + k;
				String key = itr2.next();
				cell = row.createCell(curCol);
				cell.setCellFormula("'" + summarySheetName + "'!" + convertColIdx2Char(curCol) + adjRowIdx);
				cell.setCellStyle(totalCellStyle);
				
				k++;
			}
			
			cell = row.createCell(HK_HKRL_PAYROLL_HEAD_COL_NUM + getNoOfServcde());
			cell.setCellFormula("'" + summarySheetName + "'!" + convertColIdx2Char(HK_HKRL_PAYROLL_HEAD_COL_NUM + getNoOfServcde()) + adjRowIdx);
			cell.setCellStyle(totalCellStyle);
			
			// details
			itr2 = servcdesSet.iterator();
			k = 0;
			List<ReportableListObject> diffs = null;
			List<ReportableListObject> list = null;
			List<String> thisServcdes = new ArrayList<String>();
			String examdt1 = null;
			String examdt2 = null;
				
			diffs = DiIncomeReportDB.getPayrollSummaryByExdateDiff("BF", endDate, "CF", lastMthEndDate, slptype, actualrun, payTo);
			ReportableListObject rlo = diffs.get(0);
			for (int i = 2; i < rlo.getSize(); i++) {
				thisServcdes.add(rlo.getValue(i));
			}
			
			String thisServcde = null;
			String thisExamdt = null;
			for (int i = 0; i < thisServcdes.size(); i++) {
				row = sheet.createRow((short) rowCount++);
				
				thisServcde = thisServcdes.get(i);
				int headerRow = rowCount;
				int detailLastRow = rowCount;
				int count = 0;
				boolean diffExists = false;
				detailLastRow++;
				detailLastRow++;
				
				for (int j = 1; j < diffs.size(); j++) {
					rlo = diffs.get(j);
					examdt1 = rlo.getFields0();
					examdt2 = rlo.getFields1();
					thisExamdt = examdt1 == null ? examdt2 : examdt1;
					thisExamdt = thisExamdt == null ? thisExamdt : thisExamdt.substring(0, 7);
					
					String servcdeDiff = rlo.getValue(i + 2);
					if (servcdeDiff != null && !"0".equals(servcdeDiff)) {
						// get diff (adjustment or canceled)
						list = DiIncomeReportDB.getAdjustDetails("CF", lastMthEndDate, "BF", endDate, slptype, actualrun, payTo, thisServcde, thisExamdt, true);
						count += list.size();
						detailLastRow = printAdjBreakdownDetails(wb, sheet, detailLastRow, endDate, thisServcde, list);
						
						// get diff (previous exam reported in this month)
						list = DiIncomeReportDB.getAdjustDetails("BF", endDate, "CF", lastMthEndDate, slptype, actualrun, payTo, thisServcde, thisExamdt, false);
						count += list.size();
						detailLastRow = printAdjBreakdownDetails(wb, sheet, detailLastRow, endDate, thisServcde, list);

						diffExists = true;
					}
				}
				
				if (diffExists) {
					row = sheet.createRow((short) rowCount++);
					
					// servcde header
					row = sheet.createRow((short) headerRow++);
					cell = row.createCell(0);
					cell.setCellValue("(" + thisServcde + ")");
					cell.setCellStyle(headerPatTypeStyle);
					
					// column headers
					row = sheet.createRow((short) headerRow++);
					for (int j = 0; j < adjBreakdownDetailsColHeaders.size(); j++) {
						cell = row.createCell(j);
						cell.setCellValue(adjBreakdownDetailsColHeaders.get(j));
						cell.setCellStyle(headerPatTypeStyle);
					}
					
					// servcde total
					row = sheet.createRow((short) detailLastRow++);
					row = sheet.createRow((short) detailLastRow++);
					cell = row.createCell(0);
					cell.setCellValue("TOTAL " + slptypes.get(slptype).toUpperCase() + 
							" (" + (servdescs.get(thisServcde) == null ? thisServcde : servdescs.get(thisServcde)) + 
							") OUTSTADNING REVENUE BROUGHT FORWARD (" + radPayReportMthStr + " ADJUSTMENT)");
					cell.setCellStyle(headerPatTypeStyle);
					
					cell = row.createCell(14);
					cell.setCellFormula("SUM(O" + (headerRow + 1) + ":O" + (headerRow + count) + ")" );
					cell.setCellStyle(adjTotalCellStyle);
					
					detailLastRow++;
				} else {
					detailLastRow--;
					detailLastRow--;
					detailLastRow--;
				}
				rowCount = detailLastRow;
			}
		}
		return sheet;
	}
	
	private int printAdjBreakdownDetails(Workbook wb, Sheet sheet, int rowCount, String endDate, String servcde, List<ReportableListObject> details) {
		if (details == null || details.isEmpty()) {
			return rowCount;
		}

		// Font
		Font normalFont = wb.createFont();
		normalFont.setFontHeightInPoints((short) 10);
		normalFont.setFontName("Arial");

		// Style
		CellStyle normalStyle = wb.createCellStyle();
		normalStyle.setFont(normalFont);
		
		DataFormat format = wb.createDataFormat();
		CellStyle mthCellStyle = wb.createCellStyle();
		mthCellStyle.setDataFormat(format
				.getFormat(EXCEL_MON_YR_FORMAT));
		mthCellStyle.setAlignment(CellStyle.ALIGN_RIGHT);
		mthCellStyle.setFont(normalFont);
		
		CellStyle adjustDetailsDateStyle = wb.createCellStyle();
		adjustDetailsDateStyle.setDataFormat(format
				.getFormat(EXCEL_ADJUST_DETAILS_DATE_FORMAT));
		adjustDetailsDateStyle.setAlignment(CellStyle.ALIGN_RIGHT);
		
		CellStyle rightStyle = wb.createCellStyle();
		rightStyle.cloneStyleFrom(normalStyle);
		rightStyle.setAlignment(CellStyle.ALIGN_RIGHT);
		
		CellStyle leftStyle = wb.createCellStyle();
		leftStyle.cloneStyleFrom(normalStyle);
		leftStyle.setAlignment(CellStyle.ALIGN_LEFT);

		CellStyle currencyStyle = wb.createCellStyle();
		currencyStyle.cloneStyleFrom(rightStyle);
		currencyStyle.setDataFormat(format
				.getFormat(EXCEL_CURRENCY_SIMPLE_FORMAT));

		ReportableListObject rlo = null;
		Row row = null;
		Cell cell = null;
		CellStyle cs = null;
		for (int i = 0; i < details.size(); i++) {
			row = sheet.createRow((short) rowCount++);
			
			rlo = details.get(i);
			for (int j = 0; j < rlo.getSize(); j++) {
				cell = row.createCell(j);
				String val = rlo.getValue(j);
				
				if (j == 0) {
					cs = mthCellStyle;
					cell.setCellValue(DateTimeUtil.parseDate(val));
				} else if (j == 4) {
					cs = adjustDetailsDateStyle;
					cell.setCellValue(val);
				} else if (j > 7 && j != 15 && j < 19) {	
					cs = currencyStyle;
					try {
						if (val != null && !val.isEmpty()) {
							cell.setCellValue(Double.parseDouble(val));
						}
					} catch (Exception e) {
						//System.err.println("Cannot parse " + val + " to dobule");
					}
				} else if (j == 4 || j == 5 || (j > 7 && j < 19)) {	
					cs = rightStyle;
					cell.setCellValue(val);
				} else {
					cs = normalStyle;
					cell.setCellValue(val);
				}
				cell.setCellStyle(cs);
			}
		}
		
		return rowCount;
	}
	
	public static void loadDpservs() {
		List list = DiIncomeReportDB.getDpservs();
		for (int i = 0; i < list.size(); i++) {
			ReportableListObject row = (ReportableListObject) list.get(i);
			String dsccode = row.getValue(0);
			String dscdesc = row.getValue(1);
			servdescs.put(dsccode, dscdesc);
		}
	}
}
