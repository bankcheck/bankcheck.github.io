package com.hkah.server.servlet;

import java.io.IOException;
import java.io.ObjectOutputStream;
import java.text.SimpleDateFormat;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import com.hkah.client.util.TextUtil;
import com.hkah.server.util.MessageQueueDataSource;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.UserInfo;

import net.sf.jasperreports.engine.JRParameter;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;

public class GetReport extends HttpServlet implements ConstantsVariable {

	private static final long serialVersionUID = -5295343701909694274L;
	private static final SimpleDateFormat orgFormat = new SimpleDateFormat("ddMMyyyy");
	private static final SimpleDateFormat newFormat = new SimpleDateFormat("yyyyMMdd");
	private static final String JASPER_EXTENSION = ".jasper";
	private static final String PDF_EXTENSION = ".pdf";
//	protected static org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger(GetReport.class);

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		this.doPost(req , resp) ;
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		System.out.println("[GetReport] Starting get report.........");

		JasperPrint jp = generateReport(request);

		if (jp != null) {
			response.setContentType("application/octet-stream;charset=UTF-8");
			ServletOutputStream outputStream = response.getOutputStream();
//			response.setHeader("Content-disposition", "attachment; filename=\"" + prtName + ".pdf\"");

			ObjectOutputStream out = new ObjectOutputStream(outputStream);
			out.writeObject(jp);
			out.flush();
			out.close();
		}
	}//end doPost

	protected JasperPrint generateReport(HttpServletRequest request) {
		String prtName = request.getParameter("prtName");
		UserInfo ui = new UserInfo();
		String[] mapkey = TextUtil.string2StringArray(TextUtil.parseStrUTF8(request.getParameter("mapkey")));
		String[] mapvalue = TextUtil.string2StringArray(TextUtil.parseStrUTF8(request.getParameter("mapvalue")));
		String patcname = TextUtil.parseStrUTF8(request.getParameter("patcname"));
		Map<String, String> map = TextUtil.stringArray2Map(mapkey, mapvalue);
		String[] inparam = TextUtil.string2StringArray(request.getParameter("inparam"));
		String[] columnName = TextUtil.string2StringArray(request.getParameter("columnName"));
		boolean[] isNumericColumn = TextUtil.string2BooleanArray(request.getParameter("isNumericColumn"));;
		String noOfSub = request.getParameter("noOfSub");
		String JSONString = request.getParameter(TextUtil.parseStrUTF8("JSONString"));
		int subNo = Integer.parseInt(noOfSub);
		String[] sub_prtName = new String[subNo];
		String[][] sub_dbparam = new String[subNo][];
		String[][] sub_columnName = new String[subNo][];
		boolean[][] sub_isNumericColumn = new boolean[subNo][];
//		boolean returnJP = "TRUE".equals(request.getParameter("returnJP")==null?"":request.getParameter("returnJP").toUpperCase());
		String[] sub_rptDirectDB = new String[subNo];
		String[] sub_rptModule = new String[subNo];
		String rptDirectDB = request.getParameter("rptDirectDB");
		String rptModule = request.getParameter("rptModule");
		String pageSize = request.getParameter("pageSize");
		String exportPdf = request.getParameter("exportPdf");
		String isIgnorePagination = request.getParameter("isIgnorePagination");
		String rptPrintDate = request.getParameter("rptPrintDate");

		// convert map to map2
		Map<String, Object> map2 = new HashMap<String, Object>();
		map2.putAll(map);

		if (patcname != null && !EMPTY_VALUE.equals(patcname)) {
			map2.put("patcname", patcname);
		}
		if ("true".equalsIgnoreCase(isIgnorePagination)) {
			System.out.println("[GetReport] isIgnorePagination set to true");
			map2.put(JRParameter.IS_IGNORE_PAGINATION, Boolean.TRUE);
		}
		if (inparam != null) {
			for (int i = 0; i < inparam.length; i++) {
				System.out.println("inparam[" + i + "]:" + inparam[i]);
			}
		}

		if (subNo > 0) {
			if (JSONString != null && !EMPTY_VALUE.equals(JSONString)) {
				JSONParser pars = new JSONParser();
				JSONObject allSubJO = null;
				try {
					allSubJO = (JSONObject)pars.parse(JSONString);
				} catch (ParseException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
					System.out.println(e);
				}
				System.out.println("[GetReport] allSubJO key:" + allSubJO==null ? EMPTY_VALUE : allSubJO.keySet().toString());
				System.out.println("[GetReport] allSubJO COntent:" + allSubJO == null ? EMPTY_VALUE : allSubJO.values().toString());
				JSONArray allSubJA = (JSONArray)allSubJO.get((String) "allSub");
				System.out.println("[GetReport] allSubJA size:" + allSubJA == null ? EMPTY_VALUE : allSubJA.size());
				JSONObject subJO = null;
				for (int i = 0; i < subNo; i++) {
					subJO = (JSONObject) allSubJA.get(i);
					if (subJO != null) {
						System.out.println("[GetReport] subJO:" + subJO.toJSONString().toString());
						sub_prtName[i] = (String) subJO.get("subRptName");
						System.out.println("[GetReport] prtName:" + sub_prtName[i]);
						sub_dbparam[i] = TextUtil.string2StringArray((String) subJO.get("sub_dbParam"));
						sub_columnName[i] = TextUtil.string2StringArray((String) subJO.get("sub_colName"));
						sub_isNumericColumn[i] = TextUtil.string2BooleanArray((String) subJO.get("isNumericCol"));
						sub_rptDirectDB[i] = (String) subJO.get("subRptDirectDB");
						sub_rptModule[i] = (String) subJO.get("subRptModule");
					}
				}
			}
		}

//		logger.debug("in GetReport>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
//		logger.debug("print inparam: ui="+ui.getSiteCode());
//		logger.debug("prtName="+prtName);
//		logger.debug("patcname="+patcname);
//		logger.debug("map2="+map2);
//		logger.debug("inparam="+Arrays.toString(inparam));
//		logger.debug("columnName="+Arrays.toString(columnName));
//		logger.debug("isNumericColumn="+Arrays.toString(isNumericColumn));
//		logger.debug("noOfSub="+noOfSub);
//		logger.debug("JSONString="+JSONString);
//		logger.debug("sub_prtName="+Arrays.toString(sub_prtName));
//		if (sub_prtName != null) {
//			for (int i=0; i<sub_prtName.length;i++) {
//				logger.debug("sub_dbparam[" + i + "]="+Arrays.toString(sub_dbparam[i]));
//				logger.debug("sub_columnName[" + i + "]="+Arrays.toString(sub_columnName[i]));
//				logger.debug("sub_isNumericColumn[" + i + "]="+Arrays.toString(sub_isNumericColumn[i]));
//			}
//		}
//		logger.debug("sub_rptDirectDB="+Arrays.toString(sub_rptDirectDB));
//		logger.debug("sub_rptModule="+Arrays.toString(sub_rptModule));
//		logger.debug("pageSize="+pageSize);
//		logger.debug("exportPdf="+exportPdf);
//		logger.debug("isIgnorePagination="+isIgnorePagination);
//		logger.debug("rptPrintDate="+rptPrintDate);

		try {
			// file.jasper path
			String filePath = null;
			if (pageSize == null || pageSize.length() == 0 || pageSize.equals("A4")) {
				filePath = getServletConfig().getServletContext().getRealPath("report/" + prtName + JASPER_EXTENSION);
			} else {
				filePath = getServletConfig().getServletContext().getRealPath("report/" + prtName + UNDERSCORE_VALUE + pageSize + JASPER_EXTENSION);
			}

			System.out.println("[GetReport] filePath: " + filePath);

			JasperPrint jasperPrint = null;
			if (inparam != null) {
				if (sub_prtName != null && subNo > 0) {
					// sub datasource
					if (sub_prtName.length > 1) {
						for (int i = 0; i < sub_prtName.length; i++) {
							System.out.println("[GetReport] SubReport Process 2......");
							((Map<String, Object>) map2).put("SubDataSource" + String.valueOf((i + 1)),
									new MessageQueueDataSource(ui, sub_rptModule[i],
											sub_prtName[i],
											sub_dbparam[i], sub_columnName[i],
											sub_isNumericColumn[i], true,
											sub_rptDirectDB[i], true));
						}
					} else {
						System.out.println("[GetReport] SubReport Process 4......");
						((Map<String, Object>) map2).put("SubDataSource",
								new MessageQueueDataSource(ui, sub_rptModule[0],
										sub_prtName[0],
										sub_dbparam[0], sub_columnName[0],
										sub_isNumericColumn[0], true,
										sub_rptDirectDB[0], true));
					}//else subreport
				}

				System.out.println("[GetReport] End SubReport Process......");
				System.out.println("[GetReport] Fill Report Process......");
				jasperPrint = JasperFillManager.fillReport(filePath, map2,
						new MessageQueueDataSource(ui, rptModule, prtName, inparam,
								columnName, isNumericColumn, false, rptDirectDB, true));
			} else {
				System.out.println("[GetReport] Fill Report Process......");
				jasperPrint = JasperFillManager.fillReport(filePath, map2);
			}
//			byte[] report = JasperExportManager.exportReportToPdf(jasperPrint);

//			response.setContentLength(report.length);
//			ServletOutputStream out = response.getOutputStream();
			System.out.println("[GetReport] Fetching outputstream.....");
//			System.out.println("after jasperPrint:"+jasperPrint.getName());
			jasperPrint.setName(prtName);
			long sysTime = System.currentTimeMillis();

			String reformattedStr = rptPrintDate;
			if (rptPrintDate != null) {
				try {
					reformattedStr = newFormat.format(orgFormat.parse(rptPrintDate));
				} catch (Exception e) {
//					e.printStackTrace();
					System.out.println("[GetReport] e.getMessage: " + e.getMessage() + " in rptPrintDate");
				}
			}

			String reportName = null;
			if (reformattedStr != null && reformattedStr.length() > 0 && !"null".equals(reformattedStr)) {
				reportName = jasperPrint.getName() + UNDERSCORE_VALUE + reformattedStr + UNDERSCORE_VALUE + sysTime;
			} else {
				reportName = jasperPrint.getName() + sysTime;
			}
			System.out.println("[GetReport] Setting report name to [" + reportName + "]");
			jasperPrint.setName(reportName);

			if (exportPdf != null && exportPdf.equals(YES_VALUE)) {
				String exportReportName = null;
				if (reformattedStr != null) {
					exportReportName = jasperPrint.getName() + PDF_EXTENSION;
				} else {
					exportReportName = filePath.substring(0, filePath.length() - 7) + sysTime + PDF_EXTENSION;
				}
				System.out.println("[GetReport] export report to [" + exportReportName + "]");
				JasperExportManager.exportReportToPdfFile(jasperPrint, exportReportName);
			}

			return jasperPrint;
		} catch (Exception e) {
			System.out.println("[GetReport] e.getMessage: " + e.getMessage());
			System.out.println("[GetReport] e.getLocalizedMessage(): " + e.getLocalizedMessage());
			for (StackTraceElement error : e.getStackTrace()) {
				System.out.println("[GetReport] Class: " + error.getClassName());
				System.out.println("[GetReport] File: " + error.getFileName());
				System.out.println("[GetReport] Line: " + error.getLineNumber());
				System.out.println("[GetReport] Medthod: " + error.getMethodName());
			}
			e.printStackTrace();
			return null;
		}
	}
}// end class