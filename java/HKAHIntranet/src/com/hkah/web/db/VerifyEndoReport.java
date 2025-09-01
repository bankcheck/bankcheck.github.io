package com.hkah.web.db;

import java.io.File;
import java.util.ArrayList;

import com.lowagie.text.pdf.PdfReader;
import com.lowagie.text.pdf.parser.PdfTextExtractor;

public class VerifyEndoReport {
	public static int checkReport(String patNo, String rptPath) {
		ArrayList<EndoReportObject> errorCases = new ArrayList<EndoReportObject>();
		int page = checkPdfReport(new File(rptPath), patNo, errorCases);
		if (page > 0) {
			return page;
		}
		else {
			String content = "";
			content += "--------------------------------------------------------------<br/>";
			content += "Patient No: "+errorCases.get(0).getPatNo()+"<br/>";
			content += "Report Path: "+errorCases.get(0).getRptPath()+"<br/><br/>";
			content += "Error Msg: "+errorCases.get(0).getErrMsg()+"<br/><br/>";
			//System.out.println(content);

			EmailAlertDB.sendEmail("endo.report", "Endo Report Not Match", content);

			CHReportLogDB.addErrorLog("ENDO", errorCases.get(0).getPatNo(), 
					errorCases.get(0).getRptPath(), null, 
					"Error Msg: "+errorCases.get(0).getErrMsg());
			
			return errorCases.get(0).getPageCnt();
		}
	}

	private static int checkPdfReport(File file, String patNo,
								ArrayList<EndoReportObject> errorCases) {
		boolean success = true;
		PdfReader reader = null;
		int n = 0;

		try {
			reader = new PdfReader(file.getAbsolutePath());
			n = reader.getNumberOfPages();
	        PdfTextExtractor extractor = new PdfTextExtractor(reader);

	        for (int i = 1; i <= n; i++) {
	        	String content = extractor.getTextFromPage(i).replace("\n", "").replace("\r", "");
	        	//System.out.println(content);
	        	String[] headfoot = new String[2];
        		try {
            		headfoot[0] = content.substring(0, content.indexOf("Patient No. :")-"Patient No. :".length());
            		headfoot[1] = content.substring(content.indexOf("Patient No. :")-"Patient No. :".length());
        		}
        		catch (Exception e) {

        		}

        		if (headfoot != null) {
        			String patNo_footer = null;

        			if (headfoot[1] != null) {
        				patNo_footer = getPdfData(headfoot[1], "Patient No. :", "Name").trim();
        				//System.out.println(patNo_footer);
        			}

        			if (patNo.equals(patNo_footer)) {

        			}
        			else {
        				success = false;
        				errorCases.add(new EndoReportObject(patNo, file.getAbsolutePath(), "Patient no. is not match", -1));
        			}
        		}
        		else {
        			success = false;
        			errorCases.add(new EndoReportObject(patNo, file.getAbsolutePath(), "No content/Cannot get any content", -2));
        		}
	        }
		}
		catch (Exception e) {
			success = false;
			e.printStackTrace();
			errorCases.add(new EndoReportObject(patNo, file.getAbsolutePath(), e.getMessage(), -3));
		}
		finally {
			if (reader != null) {
				reader.close();
			}
		}

		if (success) {
			return n;
		}
		else {
			return 0;
		}
	}

	private static String getPdfData(String content, String start, String end) {
		return content.substring(
				content.indexOf(start)+start.length(),
				content.indexOf(end));
	}
}

class EndoReportObject {
	String patNo = null;
	String rptPath = null;
	String errMsg = null;
	int pageCnt = 0;

	public EndoReportObject(String patNo, String rptPath, String errMsg, int pageCnt) {
		this.patNo = patNo;
		this.rptPath = rptPath;
		this.errMsg = errMsg;
		this.pageCnt = pageCnt;
	}

	/**
	 * @return the patNo
	 */
	public String getPatNo() {
		return patNo;
	}

	/**
	 * @return the rptPath
	 */
	public String getRptPath() {
		return rptPath;
	}

	/**
	 * @return the errMsg
	 */
	public String getErrMsg() {
		return errMsg;
	}

	/**
	 * @param patNo the patNo to set
	 */
	public void setPatNo(String patNo) {
		this.patNo = patNo;
	}

	/**
	 * @param rptPath the rptPath to set
	 */
	public void setRptPath(String rptPath) {
		this.rptPath = rptPath;
	}

	/**
	 * @param errMsg the errMsg to set
	 */
	public void setErrMsg(String errMsg) {
		this.errMsg = errMsg;
	}

	/**
	 * @return the pageCnt
	 */
	public int getPageCnt() {
		return pageCnt;
	}

	/**
	 * @param pageCnt the pageCnt to set
	 */
	public void setPageCnt(int pageCnt) {
		this.pageCnt = pageCnt;
	}
}