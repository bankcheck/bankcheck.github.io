package com.hkah.web.db;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;

import sun.misc.BASE64Decoder;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.convert.Converter;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.lowagie.text.pdf.PdfReader;
import com.lowagie.text.pdf.parser.PdfTextExtractor;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.encryption.InvalidPasswordException;
import org.apache.pdfbox.text.PDFTextStripper;

public class ArchivePdfChecking {
	private static Logger logger = Logger.getLogger(ArchivePdfChecking.class);

	/*
	public static String checkLabRptByFileId(String fileId) {
		
		String result = "match";
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select '\\\\' || store_server || '\\' || store_folder || '\\' || store_subfolder || '\\' || store_file, ");
		sqlStr.append(" substr(keyword, 20) ");
		sqlStr.append(" from file_store ");
		sqlStr.append(" where status = 'A' ");
		sqlStr.append(" and file_id = ? ");
		
		ArrayList record = UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[] {fileId});
		
		if (record.size() > 0) {
			
			ReportableListObject row = (ReportableListObject)record.get(0);
			
			ArrayList<ArchiveCaseObject> errorCases = new ArrayList<ArchiveCaseObject>();
			
			String rptPath = row.getValue(0);
			String labnum = row.getValue(1);
			
			if (!checkLabRptPdf(fileId, new File(rptPath), labnum, errorCases)) {
				result = errorCases.get(0).getErrMsg();
			}
		} else {
			result = "fileId not found";
		}
		
		return result;
	}
*/
	public static String checkLabRptByLabnum(String labnum, String testCat) {
		
		String result = "match";
		
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select '\\\\' || store_server || '\\' || store_folder || '\\' || store_subfolder || '\\' || store_file, ");
		sqlStr.append(" R.FILE_ID ");
		sqlStr.append(" from labo_report_log@LIS r ");
		sqlStr.append(" join file_store f on r.file_id = f.file_id ");
		sqlStr.append(" where f.status = 'A' ");
		sqlStr.append(" and lab_num = ? ");
		sqlStr.append(" and test_cat = ? ");
		
		ArrayList record = UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[] {labnum, testCat});
		
		if (record.size() > 0) {
			
			ReportableListObject row = (ReportableListObject)record.get(0);
			
			ArrayList<ArchiveCaseObject> errorCases = new ArrayList<ArchiveCaseObject>();
			
			String rptPath = row.getValue(0);
			String fileId = row.getValue(1);
			
			if (!checkLabRptPdf(fileId, new File(rptPath), labnum, errorCases)) {
				result = errorCases.get(0).getErrMsg();
			}
		} else {
			result = "fileId not found";
		}
		
		return result;
	}
	
	public static String checkLabRptByDateRange(String fromDate, String toDate) {
		
		int success = 0;
		String result = "";		
		ArrayList<ArchiveCaseObject> errorCases = new ArrayList<ArchiveCaseObject>();

		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select '\\\\' || store_server || '\\' || store_folder || '\\' || store_subfolder || '\\' || store_file, ");
		sqlStr.append(" R.FILE_ID, lab_num, TEST_CAT ");
		sqlStr.append(" from labo_report_log@LIS r ");
		sqlStr.append(" join file_store f on r.file_id = f.file_id ");
		sqlStr.append(" where f.status = 'A' ");
		sqlStr.append(" and to_char(rpt_date, 'yyyymmdd') >= ? ");
		sqlStr.append(" and to_char(rpt_date, 'yyyymmdd') <= ?  and length(lab_num) = 8 ");
		
		ArrayList record = UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[] {fromDate, toDate});
		logger.trace("Start Checking "+fromDate+" to "+ toDate);
		for (int i = 0; i < record.size(); i++) {
			ReportableListObject row = (ReportableListObject)record.get(i);
			
			String rptPath = row.getValue(0);
			String fileId = row.getValue(1);
			String labnum = row.getValue(2);
			String testCat = row.getValue(3);
			logger.error("[labnum:"+labnum+"]");

			if (checkLabRptPdf(fileId, new File(rptPath), labnum, errorCases))
				success++;	
		}
		logger.trace("End Checking "+fromDate+" to "+ toDate);

		for (ArchiveCaseObject obj : errorCases) {
			result = result + "<br//>" + obj.getFileId() + ": " + obj.getErrMsg();
		}
		result =  result + "<br//>Number of match: " + success; 
		logger.trace("result="+result);

		return result;
	}
	
	private static boolean checkLabRptPdf(String fileId, File file, String labnum, 
		ArrayList<ArchiveCaseObject> errorCases) {
		
		boolean success = true;
//		PdfReader reader = null;
		String report_labnum = null;
		
/*		try {
			reader = new PdfReader(file.getAbsolutePath());
	        int n = reader.getNumberOfPages(); 
	        PdfTextExtractor extractor = new PdfTextExtractor(reader);
	        
	        for (int i = 1; i <= n; i++) {
		        String content = extractor.getTextFromPage(i);
		         logger.trace("[ArchivePdfChecking] labnum: " + labnum + " page" + i + " content:\n" + content);
	        }
	        
	        
//Only check first page of lab report	        	        
	        String content = extractor.getTextFromPage(1).replace("\n", "").replace("\r", "");
	         System.out.println("[labnum:"+labnum+"] content:\n" + content);
	        
	        if ( !content.contains(labnum) ) {
				success = false;
				errorCases.add(new ArchiveCaseObject(fileId, file.getAbsolutePath(), "labnum " + labnum + " mismatch"));
				logger.info("[labnum:"+labnum+"] mismatch");

	        }
	
		}
		catch (Exception e) {
			success = false;
			e.printStackTrace();
			errorCases.add(new ArchiveCaseObject(fileId, file.getAbsolutePath(), e.getMessage()));
		}
		finally {
			if (reader != null) {
				reader.close();
			}
		}*/
		
	      PDDocument document = null;
		try {
			document = PDDocument.load(file);
			
		      //Instantiate PDFTextStripper class
		      PDFTextStripper pdfStripper = null;
			try {
				pdfStripper = new PDFTextStripper();
				pdfStripper.setStartPage(1);
				pdfStripper.setEndPage(2);
			} catch (IOException e) {
				// TODO Auto-generated catch block
				success = false;
				errorCases.add(new ArchiveCaseObject(fileId, file.getAbsolutePath(), "labnum " + labnum + " mismatch"));
				logger.error("[labnum:"+labnum+"] pdfStripper IOException error");

				e.printStackTrace();
			}

		      //Retrieving text from PDF document
		      String text = null;
			try {
				text = pdfStripper.getText(document).replace("\n", "").replace("\r", "");
					
			         //System.out.println("[labnum:"+labnum+"] text:\n" + text);
			        
			        if ( !text.contains(labnum) ) {
						success = false;
						errorCases.add(new ArchiveCaseObject(fileId, file.getAbsolutePath(), "labnum " + labnum + " mismatch"));
						logger.info("[labnum:"+labnum+"] mismatch");
		
			        }
			} catch (IOException e) {
				// TODO Auto-generated catch block
				success = false;
				errorCases.add(new ArchiveCaseObject(fileId, file.getAbsolutePath(), "labnum " + labnum + " mismatch"));
				logger.error("[labnum:"+labnum+"] pdfStripper.getText(document) IOException error");

				e.printStackTrace();
			}
		      //System.out.println(text);

		      //Closing the document
		      try {
				document.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				success = false;
				errorCases.add(new ArchiveCaseObject(fileId, file.getAbsolutePath(), "labnum " + labnum + " mismatch"));

				logger.error("[labnum:"+labnum+"] document.close() IOException error");

				e.printStackTrace();
			}
		} catch (InvalidPasswordException e1) {
			// TODO Auto-generated catch block
			success = false;
			errorCases.add(new ArchiveCaseObject(fileId, file.getAbsolutePath(), "labnum " + labnum + " mismatch"));

			logger.error("[labnum:"+labnum+"] PDDocument.load(file) InvalidPasswordException error");
			e1.printStackTrace();
		} catch (IOException e1) {
			success = false;
			// TODO Auto-generated catch block
			logger.error("[labnum:"+labnum+"] PDDocument.load(file)IOException error");
			e1.printStackTrace();
		}



	      
		return success;
	}
}
	
class ArchiveCaseObject {
	String fileId;
	String rptPath;
	String errMsg;
	
	/**
	 * @return the errMsg
	 */
	public String getErrMsg() {
		return errMsg;
	}

	/**
	 * @param errMsg the errMsg to set
	 */
	public void setErrMsg(String errMsg) {
		this.errMsg = errMsg;
	}

	public ArchiveCaseObject(String fileId,	String rptPath, String errMsg) {
		this.fileId = fileId;
		this.rptPath = rptPath;
		this.errMsg = errMsg;
	}
	
	/**
	 * @return the FileId
	 */
	public String getFileId() {
		return fileId;
	}
	/**
	 * @return the rptPath
	 */
	public String getRptPath() {
		return rptPath;
	}
	/**
	 * @param FileId the FileId to set
	 */
	public void setFileId(String fileId) {
		this.fileId = fileId;
	}
	/**
	 * @param rptPath the rptPath to set
	 */
	public void setRptPath(String rptPath) {
		this.rptPath = rptPath;
	}
}