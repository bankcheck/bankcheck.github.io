package com.hkah.servlet;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.URLEncoder;
import java.sql.Connection;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import net.sf.jasperreports.engine.JRExporter;
import net.sf.jasperreports.engine.JRExporterParameter;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.export.JRHtmlExporterParameter;
import net.sf.jasperreports.engine.export.JRPdfExporter;
import net.sf.jasperreports.engine.export.JRXlsExporter;
import net.sf.jasperreports.engine.util.JRLoader;
import net.sf.jasperreports.j2ee.servlets.ImageServlet;

import com.hkah.jasper.ReportMapDataSource;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.TextUtil;
import com.hkah.util.db.UtilDBWeb;

public class ReportServlet extends HttpServlet {

	private static final long serialVersionUID = -5295343701909694274L;
	
	private void genJasperReport(HttpServletRequest request, HttpServletResponse response) {
		String prtName = request.getParameter("prtName");
		String expFileName = request.getParameter("expFileName");
		String expFileExt = request.getParameter("expFileExt");
		String[] mapkey = request.getParameterValues("mapkey[]");
		String[] mapvalue = request.getParameterValues("mapvalue[]");
		String[] maptype = request.getParameterValues("maptype[]");

		String ds = request.getParameter("ds");
		String dispositionType = request.getParameter("dispositionType");
		
		try {
			File reportFile = new File(getServletConfig().getServletContext().getRealPath("/report/" + prtName));
			if (reportFile.exists()) {
				Connection conn = null;
				JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
		
				Map<String, Object> parameters = stringArray2ObjectMap(mapkey, mapvalue, maptype);
				parameters.put("SUBREPORT_DIR", reportFile.getParentFile().getPath() + "\\");
				
				if ("portal".equalsIgnoreCase(ds)) {
					conn = HKAHInitServlet.getDataSourceIntranet().getConnection();
				} else if ("hats".equalsIgnoreCase(ds)) {
					conn = HKAHInitServlet.getDataSourceHATS().getConnection();
				} else if ("cis".equalsIgnoreCase(ds)) {
					conn = HKAHInitServlet.getDataSourceCIS().getConnection();
				} else if ("fsd".equalsIgnoreCase(ds)) {
					conn = HKAHInitServlet.getDataSourceFSD().getConnection();
				} else if ("seed".equalsIgnoreCase(ds)) {
					conn = HKAHInitServlet.getDataSourceSEED().getConnection();
				} else if ("tah".equalsIgnoreCase(ds)) {
					conn = HKAHInitServlet.getDataSourceTAH().getConnection();
				} else {
					conn = HKAHInitServlet.getDataSourceIntranet().getConnection();
				}
		
				JasperPrint jasperPrint =
					JasperFillManager.fillReport(jasperReport, parameters, conn);
		
				request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
				OutputStream ouputStream = response.getOutputStream();
				String contentType = null;
				String fileExt = null;
				if (dispositionType == null) {
					dispositionType = "attachment";
				}
				JRExporter exporter = null;
				if ("xls".equals(expFileExt)) {
					contentType = "application/vnd.ms-excel";
					fileExt = "." + expFileExt;
					exporter = new JRXlsExporter();
				} else if ("pdf".equals(expFileExt)) {
					contentType = "application/pdf";
					fileExt = "." + expFileExt;
					exporter = new JRPdfExporter();
				}
				
				
				// encode non-ascii file name
				String encodedFileName = expFileName + fileExt;
				if (encodedFileName != null) {
					encodedFileName = URLEncoder.encode(encodedFileName, "UTF-8");
				}
				
				response.setContentType(contentType);
				response.setHeader("Content-disposition", dispositionType + "; filename=\"" + encodedFileName + "\"");
				
		        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
		        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
		        exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");
		        exporter.exportReport();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	@Override
	protected void service(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		String mode = request.getParameter("mode");
		if ("inquery".equals(mode)) {
			genJasperReport(request, response);
		} else {
			String prtName = request.getParameter("prtName");
			
			String dispositionType = request.getParameter("dispositionType");
			String[] mapkey = string2StringArray(request.getParameter("mapkey"));
			String[] mapvalue = string2StringArray(request.getParameter("mapvalue"));
			Map<String, String> map = stringArray2Map(mapkey, mapvalue);
			String[] inparam = string2StringArray(request.getParameter("inparam"));
			String[] columnName = string2StringArray(request.getParameter("columnName"));
			boolean[] isNumericColumn = string2BooleanArray(request.getParameter("isNumericColumn"));;
			String sub_prtName = request.getParameter("sub_prtName");
			String[] sub_dbparam = string2StringArray(request.getParameter("sub_dbparam"));
			String[] sub_columnName = string2StringArray(request.getParameter("sub_columnName"));
			boolean[] sub_isNumericColumn = string2BooleanArray(request.getParameter("sub_isNumericColumn"));;
			
			response.setContentType("application/pdf");
			response.setHeader("Content-disposition", "attachment; filename=\"" + prtName + ".pdf\"");
	
			try {
				//file.jasper path
				String filePath = getServletConfig().getServletContext().getRealPath("report/" + prtName + ".jasper");
	
				InputStream inputStream = new FileInputStream(filePath);
				JasperPrint jasperPrint = null;
				if (inparam != null) {
					if (sub_prtName != null) {
						// sub datasource
						((Map) map).put("sub_datasource", new ReportMapDataSource(UtilDBWeb.getFunctionResults("NHS_RPT_" + sub_prtName, sub_dbparam),
								sub_columnName, sub_isNumericColumn));
					}
					jasperPrint = JasperFillManager.fillReport(inputStream, map, new ReportMapDataSource(UtilDBWeb.getFunctionResults("NHS_RPT_" + prtName, inparam), columnName, isNumericColumn));
				} else {
					jasperPrint = JasperFillManager.fillReport(inputStream, map);
				}
				byte[] report = JasperExportManager.exportReportToPdf(jasperPrint);
	
				response.setContentLength(report.length);
				ServletOutputStream out = response.getOutputStream();
				out.write(report);
				out.flush();
				out.close();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		service(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		service(request, response);
	}//end doPost

	private Map<String, String> stringArray2Map(String[] str1, String[] str2) {
		if (str1 != null) {
			Map<String, String> map = new HashMap<String, String>();
			for (int i = 0; i < str1.length; i++) {
				map.put(str1[i], str2[i]);
			}
			return map;
		} else {
			return null;
		}
	}
	
	private Map<String, Object> stringArray2ObjectMap(String[] str1, String[] str2, String[] maptype) {
		if (str1 != null) {
			Map<String, Object> map = new HashMap<String, Object>();
			for (int i = 0; i < str1.length; i++) {
				Object value = null;
				if (maptype != null && maptype.length > i) {
					String type = maptype[i];
					if ("date".equals(type)) {
						value = DateTimeUtil.parseDate(str2[i]);
					} else {
						value = str2[i];
					}
				} else {
					value = str2[i];
				}
				map.put(str1[i], value);
			}
			return map;
		} else {
			return null;
		}
	}

	private String[] string2StringArray(String str) {
		if (str != null) {
			String [] returnArray = TextUtil.split(str);
			if (returnArray.length == 0) {
				return null;
			} else {
				return returnArray;
			}
		} else {
			return null;
		}
	}

	private boolean[] string2BooleanArray(String str) {
		if (str != null) {
			String [] returnArray = TextUtil.split(str);
			if (returnArray.length == 0) {
				return null;
			} else {
				boolean[] returnBoolean = new boolean[returnArray.length];
				for (int i = 0; i < returnArray.length; i++) {
					returnBoolean[i] = "TRUE".equals(returnArray[i]);
				}
				return returnBoolean;
			}
		} else {
			return null;
		}
	}
}// end class