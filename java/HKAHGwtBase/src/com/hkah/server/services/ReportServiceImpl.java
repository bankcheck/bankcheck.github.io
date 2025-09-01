package com.hkah.server.services;

import java.io.File;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

import com.google.gwt.user.server.rpc.RemoteServiceServlet;
import com.hkah.client.services.ReportService;
import com.hkah.client.util.TextUtil;
import com.hkah.server.util.FileIoUtil;
import com.hkah.server.util.MessageQueueDataSource;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.UserInfo;

import jcifs.smb.SmbFile;
import jcifs.smb.SmbFileFilter;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JRPrintPage;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperPrintManager;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import net.sf.jasperreports.engine.export.JRPdfExporterParameter;
import net.sf.jasperreports.engine.export.JRXlsExporter;
import net.sf.jasperreports.engine.export.JRXlsExporterParameter;
import net.sf.jasperreports.engine.util.JRLoader;

/**
 * @author Vagner Araujo
 * */

public class ReportServiceImpl extends RemoteServiceServlet
implements ReportService, ConstantsVariable {

	private final static String FORMAT_DISPLAY_DATETIME = "dd/MM/yyyy HH:mm:ss";
	private static SimpleDateFormat dateTimeFormat = new SimpleDateFormat(FORMAT_DISPLAY_DATETIME);
	private static String os = System.getProperty("os.name").toLowerCase();
	private boolean isLinux = os.indexOf("nix") >= 0 || os.indexOf("nux") >= 0 || os.indexOf("aix") > 0;
	protected static org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger(ReportServiceImpl.class);

	/**
	 *
	 */
	private static final long serialVersionUID = -5366570979910232996L;

	@SuppressWarnings("unchecked")
	@Override
	public String print(UserInfo ui, String prtName, Map<String, String> map, String patcname,
						String[] inparam, String[] columnName, boolean[] isNumericColumn,
						String sub_prtName[], String[][] sub_dbparam, String[][] sub_columnName, boolean[][] sub_isNumericColumn,
						int noOfCopies, boolean showPrintBox, boolean showPDF, boolean reversePageOrder, String paperSize, String printPath,
						String fileName, String rptServer, String fileType) {

		if (map == null) {
			logger.debug("map is null");
		} else {
			if (patcname != null && patcname.length() > 0) {
				map.put("patcname", patcname);
			}
		}

		String filePath = null;
		JasperPrint jasperPrint = null;
		List<JasperPrint> jasperPrintList = new ArrayList<JasperPrint>();
		JRPdfExporter exporter = new JRPdfExporter();
		JRXlsExporter xlsExporter = new JRXlsExporter();
		String q = EMPTY_VALUE;

		if (paperSize == null || paperSize.length() == 0 || paperSize.equals("A4")) {
			filePath = getServletConfig().getServletContext().getRealPath("report/" + prtName);
		} else {
			filePath = getServletConfig().getServletContext().getRealPath("report/" + prtName + "_" + paperSize);
		}

		long sysTime = System.currentTimeMillis();
		String newPath = null;
		String newFileName = null;
		if (fileType != null && "xls".equals(fileType.toLowerCase())) {
			newPath = filePath + sysTime + ".xls";
			newFileName = prtName + sysTime +".xls";
		} else {
			newPath = filePath + sysTime + ".pdf";
			newFileName = prtName + sysTime + ".pdf";
		}

		if (rptServer != null && rptServer.length() > 0) {
			URL postURL = null;
			String URLContent = null;

			StringBuilder mapKey = new StringBuilder();
			StringBuilder mapValue = new StringBuilder();
			String newMapValue = null;
			String newMapKey = null;
			String inParamText = null;
			String columnNameText = null;
			JSONArray subJA = new JSONArray();
			JSONObject mainJO = new JSONObject();

			for (int i = 0; i < sub_prtName.length; i++) {
				JSONObject subJO = new JSONObject();
				subJO.put("subRptName", sub_prtName[i]);
				subJO.put("sub_dbParam", TextUtil.combine(sub_dbparam[i]));
				subJO.put("sub_colName", TextUtil.combine(sub_columnName[i]));
				subJO.put("isNumericCol", TextUtil.booleanArray2String(sub_isNumericColumn[i]));
				subJO.put("noOfCopies", Integer.toString(noOfCopies));
				subJA.add(subJO);
			}
			mainJO.put("allSub", subJA);

			if (inparam!= null) {
				inParamText = TextUtil.combine(inparam);
			}

			if (columnName != null) {
				columnNameText = TextUtil.combine(columnName);
			}

			for (Map.Entry<String, String> pairs : map.entrySet()) {
				mapKey.append(pairs.getKey());
				mapKey.append(FIELD_DELIMITER);
				mapValue.append(pairs.getValue());
				mapValue.append(FIELD_DELIMITER);
			}

			if (map != null) {
				try {
					newMapValue = java.net.URLEncoder.encode(mapValue.toString(), "UTF-8");
					newMapKey = java.net.URLEncoder.encode(mapKey.toString(), "UTF-8");
				} catch (UnsupportedEncodingException e2) {
					// TODO Auto-generated catch block
					e2.printStackTrace();
				}
			}

			URLContent = "http://" + rptServer + "/hkahnhs/getreport?prtName=" + prtName +
					"&mapkey=" + newMapKey +
					"&mapvalue=" + newMapValue +
					"&patcname=" + patcname +
					"&noOfSub=" + sub_prtName.length +
					"&exportPdf=Y";

			if (inParamText != null) {
				try {
					URLContent += "&inparam=" + URLEncoder.encode(inParamText, "ISO-8859-1");
				} catch (UnsupportedEncodingException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
			if (columnNameText != null) {
				URLContent += "&columnName=" + columnNameText;
			}
			String newJSONString = null;
			if (mainJO != null && !EMPTY_VALUE.equals(mainJO.toString())) {
				try {
					newJSONString = URLEncoder.encode(mainJO.toString(), "ISO-8859-1");

				} catch (UnsupportedEncodingException e2) {
					// TODO Auto-generated catch block
					e2.printStackTrace();
				}
				URLContent += "&JSONString=" + newJSONString;
			}

			try {
				postURL = new URL(URLContent);
			} catch (MalformedURLException e1) {
				// TODO Auto-generated catch block
				Logger.getLogger(ReportServiceImpl.class.getName()).log(Level.SEVERE, null, e1);
			}

			try {
				jasperPrint = (JasperPrint) JRLoader.loadObject(postURL);

				if (showPDF) {
					String RptPnDelay = map.get("RptPnDelay");
					if (RptPnDelay != null) {
						q = "?RptPnDelay=" + RptPnDelay;
					}

					logger.debug("return=http://" + rptServer + "/report/" + jasperPrint.getName() + ".pdf" + q);
					return "http://" + rptServer+"/report/" + jasperPrint.getName() + ".pdf" + q;
				}
			} catch (Exception e) {
				Logger.getLogger(ReportServiceImpl.class.getName()).log(Level.SEVERE, null, e);
			}
		} else {
			try {
				System.out.println("[ReportServiceImpl]Report template file: "+filePath);
				if (inparam != null) {
					if (sub_prtName != null) {
						// sub datasource
						if (sub_prtName.length > 1) {
							for (int i = 0; i < sub_prtName.length; i++) {
								((Map) map).put("SubDataSource"+String.valueOf((i+1)),
										new MessageQueueDataSource(ui, null, sub_prtName[i],
												sub_dbparam[i], sub_columnName[i],
												sub_isNumericColumn[i], true, true));
							}
						} else {
							((Map) map).put("SubDataSource",
									new MessageQueueDataSource(ui, null, sub_prtName[0],
											sub_dbparam[0], sub_columnName[0],
											sub_isNumericColumn[0], true, true));
						}
					}
					jasperPrint = JasperFillManager.fillReport(filePath + ".jasper", map,
								new MessageQueueDataSource(ui, null, prtName, inparam,
										columnName, isNumericColumn, false, true));
				} else {
					jasperPrint = JasperFillManager.fillReport(filePath + ".jasper", map);
				}
			} catch (JRException ex) {
				Logger.getLogger(ReportServiceImpl.class.getName()).log(Level.SEVERE, null, ex);
			} catch (Exception e) {
				// no data?
				Logger.getLogger(ReportServiceImpl.class.getName()).log(Level.SEVERE, null, e);
			}
		}

		try {
			if (reversePageOrder) {
				List pages = jasperPrint.getPages();
				List temp = new ArrayList(pages);

				int pageSize = pages.size();
				for (int i = 0; i < pageSize; i++) {
					jasperPrint.removePage(0);
				}
				int tempSize = temp.size();
				for (int i = 0; i < tempSize; i++) {
					jasperPrint.addPage((JRPrintPage) temp.get(tempSize - i - 1));
				}
			}

			if (showPrintBox) {
				JasperPrintManager.printReport(jasperPrint, true);
			}

			if (fileType != null && "xls".equals(fileType.toLowerCase())) {
				for (int z = 1; z <= noOfCopies; z++) {
					if (jasperPrint.getPages().size() > 0) {
						jasperPrintList.add(jasperPrint);
					}
				}

				xlsExporter.setParameter(JRExporterParameter.JASPER_PRINT_LIST, jasperPrintList);
				xlsExporter.setParameter(JRExporterParameter.OUTPUT_FILE_NAME ,newPath);
				xlsExporter.setParameter(JRExporterParameter.CHARACTER_ENCODING, "UTF-8");
				xlsExporter.setParameter(JRXlsExporterParameter.IS_ONE_PAGE_PER_SHEET, false);
				xlsExporter.setParameter(JRXlsExporterParameter.IS_AUTO_DETECT_CELL_TYPE, true);
				xlsExporter.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND, false);
				xlsExporter.setParameter(JRXlsExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS, false);
			} else if (showPDF) {
				String RptPnDelay = map.get("RptPnDelay");
				if (RptPnDelay != null) {
					q = "?RptPnDelay="+RptPnDelay;
				}

				for (int z = 1; z <= noOfCopies; z++) {
					if (jasperPrint.getPages().size() > 0) {
						jasperPrintList.add(jasperPrint);
					}
				}

				//--- embed pdf print script ---
				exporter.setParameter(JRExporterParameter.JASPER_PRINT_LIST, jasperPrintList);
				exporter.setParameter(JRExporterParameter.OUTPUT_FILE_NAME, newPath);
				String pdfPrint = map.get("pdf-print");
				System.out.println("1[RSI] pdf-print="+pdfPrint+",newPath=" + newPath);
				if (pdfPrint != null) {
					pdfPrint = YES_VALUE.equals(pdfPrint) ? EMPTY_VALUE : pdfPrint;
					String javascript = "try{trustedSilentPrint('" + pdfPrint + "');}catch(e){var errMsg = e.name+' on line '+e.lineNumber+': '+e.message;app.alert('Failed to print. Please contact IT.\\n\\n['+errMsg+']');}";
					exporter.setParameter(JRPdfExporterParameter.PDF_JAVASCRIPT, javascript);
				}
			} else if (fileName.startsWith("APPBILL")) {
				q = EMPTY_VALUE;
				String RptPnDelay = map.get("RptPnDelay");
				if (RptPnDelay != null) {
					q = "?RptPnDelay="+RptPnDelay;
				}

				//--- embed pdf print script ---
				exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
				exporter.setParameter(JRExporterParameter.OUTPUT_FILE_NAME ,newPath);
				String pdfPrint = map.get("pdf-print");
				System.out.println("1[RSI] pdf-print="+pdfPrint+",newPath="+newPath);
				if (pdfPrint != null) {
					pdfPrint = YES_VALUE.equals(pdfPrint) ? EMPTY_VALUE : pdfPrint;
					String javascript = "try{trustedSilentPrint('" + pdfPrint + "');}catch(e){var errMsg = e.name+' on line '+e.lineNumber+': '+e.message;app.alert('Failed to print. Please contact IT.\\n\\n['+errMsg+']');}";
			        exporter.setParameter(JRPdfExporterParameter.PDF_JAVASCRIPT, javascript);
				}
				exporter.exportReport();
				//JasperExportManager.exportReportToPdfFile(jasperPrint, newPath);
				//-------------

				if (paperSize == null || paperSize.length() == 0 || paperSize.equals("A4")) {
					logger.debug("return=report/" + prtName + sysTime +".pdf" + q);
					return "report/" + prtName + sysTime +".pdf" + q;
				} else {
					logger.debug("return=report/" + prtName + "_" + paperSize+ sysTime +".pdf" + q);
					return "report/" + prtName + "_" + paperSize + sysTime +".pdf" + q;
				}				
			} else if (printPath != null) {
				if (!printPath.endsWith("/") || !printPath.endsWith("\\")) {
					printPath += "/";
				}
				newFileName = printPath;

				if (fileName != null) {
					newFileName += fileName + ".pdf";
				} else {
					newFileName += sysTime + ".pdf";
				}

				JasperExportManager.exportReportToPdfFile(jasperPrint, newFileName);
				logger.debug("return=EXTFILE:" + newFileName);
				return "EXTFILE:" + newFileName;
			} else {
				logger.debug("return=noPDF");
				return "noPDF";
			}

			try {
				if (fileType != null && "xls".equals(fileType.toLowerCase())) {
					xlsExporter.exportReport();

					if (paperSize == null || paperSize.length() == 0 || paperSize.equals("A4")) {
						logger.debug("return=report/" + prtName + sysTime +".xls");
						return "report/" + prtName + sysTime +".xls";
					} else {
						logger.debug("return=report/" + prtName + "_" + paperSize+ sysTime +".xls");
						return "report/" + prtName + "_" + paperSize + sysTime +".xls";
					}
				} else {
					exporter.exportReport();
					//JasperExportManager.exportReportToPdfFile(jasperPrint, newPath);
					//-------------

					if (paperSize == null || paperSize.length() == 0 || paperSize.equals("A4")) {
						logger.debug("return=report/" + prtName + sysTime + ".pdf" + q);
						return "report/" + prtName + sysTime + ".pdf" + q;
					} else {
						logger.debug("return=report/" + prtName + "_" + paperSize+ sysTime + ".pdf" + q);
						return "report/" + prtName + "_" + paperSize + sysTime + ".pdf" + q;
					}
				}
			} catch (JRException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		} catch (JRException ex) {
			Logger.getLogger(ReportServiceImpl.class.getName()).log(Level.SEVERE, null, ex);
		} catch (Exception e) {
			// no data?
			Logger.getLogger(ReportServiceImpl.class.getName()).log(Level.SEVERE, null, e);
		}
		logger.debug("return=(null)");
		return null;
	}

	@SuppressWarnings("unchecked")
	@Override
	public String print(UserInfo ui, String[] prtName, Map<String, Map<String, String>> mapmap, String[] patcname,
						String[][] inParamArray, String[][] columnNameArray, boolean[] isNumericColumn,
						Map<Integer, String[]>subRptNameMap, Map<Integer, String[][]> sub_dbParamMap, Map<Integer,String[][]> sub_colNameMap, Map<Integer, boolean[][]>isNumericColMap,
						int[] noOfCopies, boolean showPrintBox, boolean showPDF, boolean reversePageOrder, String paperSize, String printPath,
						String fileName, String rptServer, String fileType) {

		JRPdfExporter exporter = new JRPdfExporter();
		JRXlsExporter xlsExporter = new JRXlsExporter();
		List<JasperPrint> jasperPrintList= new ArrayList<JasperPrint>();
		String patcnameStr = null;
		Map<String, String> map = null;
		String q = EMPTY_VALUE;
		String RptPnDelay = null;

		String filePath = null;
		JasperPrint jasperPrint = null;
		String strPrtName = null;
		String sub_prtName[] = null;
		String[][] sub_dbparam = null;
		String[][] sub_columnName = null;
		boolean[][] sub_isNumericColumn = null;
		String[] inparam = null;
		String[] columnName = null;

		String newPath = null;
		String newFileName = null;

		URL postURL = null;
		String URLContent = null;

		StringBuilder mapKey = null;
		StringBuilder mapValue = null;
		String newMapValue = null;
		String newMapKey = null;
		String inParamText = null;
		String columnNameText = null;
		JSONArray subJA = null;
		JSONObject mainJO = null;

		long sysTime = System.currentTimeMillis();
		for (int i = 0; i < prtName.length; i++) {
			if (isNumericColumn == null && columnNameArray != null) {
				isNumericColumn = new boolean[columnNameArray[i].length];
				for (int j = 0; j < columnNameArray[i].length; j++) {
					isNumericColumn[j] = false;
				}
			}

			map = mapmap.get(Integer.toString(i + 1));
			if (map == null) {
				logger.debug("map is null");
			} else {
				if (patcname != null && patcname.length > 0) {
					patcnameStr = getStringValue(patcname, i);
					map.put("patcname", patcnameStr);
				}
			}

			filePath = null;
			jasperPrint = null;
			strPrtName = getStringValue(prtName, i);
			sub_prtName = getStringArrayValue(subRptNameMap, i);
			sub_dbparam = getStringArrayArrayValue(sub_dbParamMap, i);
			sub_columnName = getStringArrayArrayValue(sub_colNameMap, i);
			sub_isNumericColumn = getBooleanArrayArrayValue(isNumericColMap, i);
			inparam = getStringArrayValue(inParamArray, i);
			columnName = getStringArrayValue(columnNameArray, i);
			if (paperSize == null || paperSize.length() == 0 || paperSize.equals("A4")) {
				filePath = getServletConfig().getServletContext().getRealPath("report/" + strPrtName);
			} else {
				filePath = getServletConfig().getServletContext().getRealPath("report/" + strPrtName + "_" + paperSize);
			}

			if (fileType != null && "xls".equals(fileType.toLowerCase())) {
				newPath = filePath + sysTime + ".xls";
				newFileName = strPrtName + sysTime + ".xls";
			} else {
				newPath = filePath + sysTime + ".pdf";
				newFileName = strPrtName + sysTime + ".pdf";
			}

			if (rptServer != null && rptServer.length() > 0) {
				postURL = null;
				URLContent = null;

				mapKey = new StringBuilder();
				mapValue = new StringBuilder();
				newMapValue = null;
				newMapKey = null;
				inParamText = null;
				columnNameText = null;
				subJA = new JSONArray();
				mainJO = new JSONObject();

				for (int j = 0; j < sub_prtName[i].length(); j++) {
					JSONObject subJO = new JSONObject();
					subJO.put("subRptName", sub_prtName[j]);
					subJO.put("sub_dbParam", TextUtil.combine(sub_dbparam[j]));
					subJO.put("sub_colName", TextUtil.combine(sub_columnName[j]));
					subJO.put("isNumericCol", TextUtil.booleanArray2String(sub_isNumericColumn[i]));
					subJO.put("noOfCopies",Integer.toString(noOfCopies[i]));
				}
				mainJO.put("allSub",subJA);

				if (inparam!= null) {
					inParamText = TextUtil.combine(inparam);
				}

				if (columnName != null) {
					columnNameText = TextUtil.combine(columnName);
				}

				for (Map.Entry<String, String> pairs : map.entrySet()) {
					mapKey.append(pairs.getKey());
					mapKey.append(FIELD_DELIMITER);
					mapValue.append(pairs.getValue());
					mapValue.append(FIELD_DELIMITER);
				}

				if (map != null) {
					try {
						newMapValue = java.net.URLEncoder.encode(mapValue.toString(), "UTF-8");
						newMapKey = java.net.URLEncoder.encode(mapKey.toString(), "UTF-8");
					} catch (UnsupportedEncodingException e2) {
						// TODO Auto-generated catch block
						e2.printStackTrace();
					}
				}

				URLContent = "http://" + rptServer + "hkahnhs/getreport?prtName=" + strPrtName +
						"&mapkey=" + newMapKey +
						"&mapvalue=" + newMapValue +
						"&patcname=" + patcname +
						"&noOfSub=" + sub_prtName.length +
						"&exportPdf=Y";

				if (inParamText != null) {
					try {
						URLContent += "&inparam=" + URLEncoder.encode(inParamText, "ISO-8859-1");
					} catch (UnsupportedEncodingException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					};
				}
				if (columnNameText != null) {
					URLContent += "&columnName=" + columnNameText;
				}
				String newJSONString = null;
				if (mainJO != null && !EMPTY_VALUE.equals(mainJO.toString())) {
					try {
						newJSONString = URLEncoder.encode(mainJO.toString(), "ISO-8859-1");

					} catch (UnsupportedEncodingException e2) {
						// TODO Auto-generated catch block
						e2.printStackTrace();
					}
					URLContent += "&JSONString=" + newJSONString;
				}

				try {
					postURL = new URL(URLContent);
				} catch (MalformedURLException e1) {
					// TODO Auto-generated catch block
					Logger.getLogger(ReportServiceImpl.class.getName()).log(Level.SEVERE, null, e1);
				}

				try {
					jasperPrint = (JasperPrint) JRLoader.loadObject(postURL);
					if (showPDF) {
						q = EMPTY_VALUE;
						RptPnDelay = map.get("RptPnDelay");
						if (RptPnDelay != null) {
							q = "?RptPnDelay="+RptPnDelay;
						}

						logger.debug("return=http://" + rptServer + "/report/" + jasperPrint.getName() +".pdf" + q);
						return "http://"+rptServer+"/report/" + jasperPrint.getName() +".pdf" + q;
					}
				} catch (Exception e) {
					Logger.getLogger(ReportServiceImpl.class.getName()).log(Level.SEVERE, null, e);
				}
			} else {
				try {
					if (inparam != null) {
						if (sub_prtName != null) {
							// sub datasource
							if (sub_prtName.length > 1) {
								for (int k = 0; k < sub_prtName.length; k++) {
									((Map) map).put("SubDataSource"+String.valueOf((k+1)),
											new MessageQueueDataSource(ui, null, sub_prtName[k],
													sub_dbparam[k], sub_columnName[k],
													sub_isNumericColumn[k], true, true));
								}
							} else {
								((Map) map).put("SubDataSource",
										new MessageQueueDataSource(ui, null, sub_prtName[0],
												sub_dbparam[0], sub_columnName[0],
												sub_isNumericColumn[0], true, true));
							}
						}
						jasperPrint = JasperFillManager.fillReport(filePath + ".jasper", map,
									new MessageQueueDataSource(ui, null, strPrtName, inparam,
											columnName, isNumericColumn, false, true));
					} else {
						// debug
//						System.out.println("print rptParam:");
//						Set<String> keys = map.keySet();
//						Iterator<String> itr = keys.iterator();
//						while (itr.hasNext()) {
//							String key = itr.next();
//							String value = map.get(key);
//							System.out.println("key=" + key + ", value=" + value);
//						}
						jasperPrint = JasperFillManager.fillReport(filePath + ".jasper", map);
					}
				} catch (JRException ex) {
					Logger.getLogger(ReportServiceImpl.class.getName()).log(Level.SEVERE, null, ex);
				} catch (Exception e) {
					// no data?
					Logger.getLogger(ReportServiceImpl.class.getName()).log(Level.SEVERE, null, e);
				}
			}

			try {
				if (reversePageOrder) {
					List pages = jasperPrint.getPages();
					List temp = new ArrayList(pages);

					int pageSize = pages.size();
					for (int x = 0; x < pageSize; x++) {
						jasperPrint.removePage(0);
					}
					int tempSize = temp.size();
					for (int y = 0; y < tempSize; y++) {
						jasperPrint.addPage((JRPrintPage) temp.get(tempSize-y-1));
					}
				}

				if (showPrintBox) {
					JasperPrintManager.printReport(jasperPrint,true);
				}

				if (fileType != null && "xls".equals(fileType.toLowerCase())) {
					//--- embed pdf print script ---
					for (int z = 1; z <= noOfCopies[i]; z++) {
						if (jasperPrint.getPages().size() > 0) {
							jasperPrintList.add(jasperPrint);
						}
					}

					xlsExporter.setParameter(JRExporterParameter.JASPER_PRINT_LIST, jasperPrintList);
					xlsExporter.setParameter(JRExporterParameter.OUTPUT_FILE_NAME ,newPath);
					xlsExporter.setParameter(JRExporterParameter.CHARACTER_ENCODING, "UTF-8");
					xlsExporter.setParameter(JRXlsExporterParameter.IS_ONE_PAGE_PER_SHEET, false);
					xlsExporter.setParameter(JRXlsExporterParameter.IS_AUTO_DETECT_CELL_TYPE, true);
					xlsExporter.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND, false);
					xlsExporter.setParameter(JRXlsExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS, false);
				} else if (showPDF) {
					RptPnDelay = map.get("RptPnDelay");
					if (RptPnDelay != null) {
						q = "?RptPnDelay="+RptPnDelay;
					}

					//--- embed pdf print script ---
					for (int z = 1; z <= noOfCopies[i]; z++) {
						if (jasperPrint.getPages().size() > 0) {
							jasperPrintList.add(jasperPrint);
						}
					}

					exporter.setParameter(JRExporterParameter.JASPER_PRINT_LIST, jasperPrintList);
					exporter.setParameter(JRExporterParameter.OUTPUT_FILE_NAME, newPath);
					String pdfPrint = map.get("pdf-print");
					System.out.println("5[RSI] pdf-print="+pdfPrint+", newPath=" + newPath);
					if (pdfPrint != null) {
						pdfPrint = YES_VALUE.equals(pdfPrint) ? EMPTY_VALUE : pdfPrint;
						String javascript = "try{trustedSilentPrint('" + pdfPrint + "');}catch(e){var errMsg = e.name+' on line '+e.lineNumber+': '+e.message;app.alert('Failed to print. Please contact IT.\\n\\n['+errMsg+']');}";
						exporter.setParameter(JRPdfExporterParameter.PDF_JAVASCRIPT, javascript);
					}
				} else if (printPath != null) {
					if (!printPath.endsWith("/") || !printPath.endsWith("\\")) {
						printPath += "/";
					}
					newFileName = printPath;

					if (fileName != null) {
						newFileName += fileName + ".pdf";
					} else {
						newFileName += sysTime + ".pdf";
					}

					JasperExportManager.exportReportToPdfFile(jasperPrint, newFileName);
					logger.debug("return=EXTFILE:" + newFileName);
					return "EXTFILE:" + newFileName;
				} else {
					logger.debug("return=noPDF");
					return "noPDF";
				}
			} catch (JRException ex) {
				System.out.println("1[JRException]");
				Logger.getLogger(ReportServiceImpl.class.getName()).log(Level.SEVERE, null, ex);
			} catch (Exception e) {
				System.out.println("2[JRException]");
				// no data?
				Logger.getLogger(ReportServiceImpl.class.getName()).log(Level.SEVERE, null, e);
			}
			logger.debug("return=(null)");
		}

		try {
			if (fileType != null && "xls".equals(fileType.toLowerCase())) {
			xlsExporter.exportReport();

				if (paperSize == null || paperSize.length() == 0 || paperSize.equals("A4")) {
					logger.debug("return=report/" + prtName[prtName.length-1] + sysTime +".xls");
					return "report/" + prtName[prtName.length-1] + sysTime +".xls";
				} else {
					logger.debug("return=report/" + prtName[prtName.length-1] + "_" + paperSize+ sysTime +".xls");
					return "report/" + prtName[prtName.length-1] + "_" + paperSize + sysTime +".xls";
				}
			} else {
				exporter.exportReport();

				//JasperExportManager.exportReportToPdfFile(jasperPrint, newPath);
				//-------------

				if (paperSize == null || paperSize.length() == 0 || paperSize.equals("A4")) {
					logger.debug("return=report/" + prtName[prtName.length-1] + sysTime +".pdf" + q);
					return "report/" + prtName[prtName.length-1] + sysTime +".pdf" + q;
				} else {
					logger.debug("return=report/" + prtName[prtName.length-1] + "_" + paperSize+ sysTime +".pdf" + q);
					return "report/" + prtName[prtName.length-1] + "_" + paperSize + sysTime +".pdf" + q;
				}
			}
		} catch (JRException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
	}

	@SuppressWarnings("unchecked")
	@Override
	public MessageQueue getDocFeeRptList(String path, final String[] exts) {
		MessageQueue mq = null;
		Date now = new Date();
		SimpleDateFormat dateF = new SimpleDateFormat("dd/MM/yyyy");
		SimpleDateFormat timeF = new SimpleDateFormat("HH:mm:ss");
		String contentStr = EMPTY_VALUE;
		String mqStr = "RPT_GETDOCFEERPTLIST<FIELD/>" + dateF.format(now) + FIELD_DELIMITER +
				timeF.format(now) + FIELD_DELIMITER;
		String returnCode = "0";
		String returnMsg = "OK";

		try {
			if (isLinux) {
				class SmbRptFileFilter implements SmbFileFilter {
					@Override
					public boolean accept(SmbFile file) {
						if (exts == null || exts.length == 0) {
							return true;
						}
						for (String ext : exts) {
							if (ext != null &&
									file.getName().toLowerCase().endsWith("." + ext.toLowerCase())) {
								return true;
							}
						}
						return false;
					}
				}

				SmbFile smbFile = FileIoUtil.getSmbFile(path, false);
				if (smbFile.isDirectory()) {
					SmbFile[] rpts = smbFile.listFiles(new SmbRptFileFilter());
					List<SmbFile> rpts2 = Arrays.asList(rpts);
					Collections.sort(rpts2, new Comparator<SmbFile>() {
						@Override
						public int compare(SmbFile o1, SmbFile o2) {
							try {
								if ( o1.isDirectory() && o2.isFile())
									return -1;
								if ( o1.isFile() && o2.isDirectory())
									return 1;
							} catch (Exception e) {
								return 0;
							}
							return o2.getName().compareTo(o1.getName());
						}
					});

					if (rpts2.isEmpty()) {
						returnCode = "-1";
						returnMsg = "No record found.";
					} else {
						for (int i = 0; i < rpts2.size(); i++) {
							SmbFile f = rpts2.get(i);
							String fName = f.getName();
							String fCDate = dateTimeFormat.format(new Date(f.lastModified()));
							String fSize = FileUtils.byteCountToDisplaySize(f.length());
							String fCPath = f.getCanonicalPath().replace(FileIoUtil.PROTOCOL_SMB, EMPTY_VALUE);

							contentStr += fName + FIELD_DELIMITER +
									fCDate + FIELD_DELIMITER +
									fSize + FIELD_DELIMITER +
									fCPath + FIELD_DELIMITER +
									LINE_DELIMITER;
						}
					}
				}
			} else {
				File file = new File(path);
				if (file.isDirectory()) {
					List<File> rpts2 = (List<File>) FileUtils.listFiles(file, exts, false);
					Collections.sort(rpts2, new Comparator<File>() {
						@Override
						public int compare(File o1, File o2) {
							if ( o1.isDirectory() && o2.isFile())
								return -1;
							if ( o1.isFile() && o2.isDirectory())
								return 1;
							return o2.getName().compareTo(o1.getName());
						}
					});

					if (rpts2.isEmpty()) {
						returnCode = "-1";
						returnMsg = "No record found.";
					} else {
						for (int i = 0; i < rpts2.size(); i++) {
							File f = rpts2.get(i);
							String fName = f.getName();
							String fCDate = dateTimeFormat.format(new Date(f.lastModified()));
							String fSize = FileUtils.byteCountToDisplaySize(f.length());
							String fCPath = f.getCanonicalPath();

							contentStr += fName + FIELD_DELIMITER +
									fCDate + FIELD_DELIMITER +
									fSize + FIELD_DELIMITER +
									fCPath + FIELD_DELIMITER +
									LINE_DELIMITER;
						}
					}
				}
			}
		} catch (Exception e) {
			String extStr = StringUtils.join(exts, ", ");
			returnCode = "-1";
			returnMsg = "Error listing file in path: " + path + " with extension " + extStr + ".";

			Logger.getLogger(ReportServiceImpl.class.getName()).log(Level.SEVERE, null, e);
		} finally {
			mqStr += returnCode + FIELD_DELIMITER + returnMsg + FIELD_DELIMITER + contentStr;
			mq = new MessageQueue(mqStr);

			logger.debug("<<<: " + mqStr);
		}
		return mq;
	}

	private static String getStringValue(String[] str, int index) {
		if (str != null && str.length > index) {
			return str[index];
		} else {
			return null;
		}
	}

	private static String[] getStringArrayValue(Map<Integer, String[]> map, int index) {
		if (map != null && map.containsKey(index)) {
			return map.get(index);
		} else {
			return null;
		}
	}

	private static String[][] getStringArrayArrayValue(Map<Integer, String[][]> map, int index) {
		if (map != null && map.containsKey(index)) {
			return map.get(index);
		} else {
			return null;
		}
	}

	private static boolean[][] getBooleanArrayArrayValue(Map<Integer, boolean[][]> map, int index) {
		if (map != null && map.containsKey(index)) {
			return map.get(index);
		} else {
			return null;
		}
	}

	private static String[] getStringArrayValue(String[][] str, int index) {
		if (str != null && str.length > index) {
			return str[index];
		} else {
			return null;
		}
	}
}