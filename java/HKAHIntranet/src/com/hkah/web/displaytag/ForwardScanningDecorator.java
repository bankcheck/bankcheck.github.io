package com.hkah.web.displaytag;

import java.util.Date;

import org.displaytag.decorator.TableDecorator;

import com.hkah.util.DateTimeUtil;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.model.FsFileIndex;
import com.hkah.web.db.model.FsForm;
import com.hkah.web.db.model.FsImportLog;

public class ForwardScanningDecorator extends TableDecorator {
	public String getFsPattypeDisplay() {
		Object obj = getCurrentRowObject();
		FsFileIndex fsFileIndex = null;
		FsForm fsForm = null;
		String fsPattype = null;
		if (obj instanceof FsFileIndex) {
			fsFileIndex = (FsFileIndex) obj;
			fsPattype = fsFileIndex.getFsPattype();
		} else if (obj instanceof FsForm) {
			fsForm = (FsForm) obj;
			fsPattype = fsForm.getFsPattype();
		}
		
		String displayStr = "";
		if ("I".equals(fsPattype)) {
			displayStr = "In-Patient";
		} else if ("O".equals(fsPattype)) {
			displayStr = "Out-Patient";
		} else if ("D".equals(fsPattype)) {
			displayStr = "Day Case";
		} else if ("D".equals(fsPattype)) {
			displayStr = fsPattype;
		}
		
		return displayStr;
	}
	
	public String getFsAdmDateDisplay() {
		FsFileIndex fsFileIndex = (FsFileIndex) getCurrentRowObject(); 
		
		Date date = fsFileIndex.getFsAdmDate();
		
		String dateStr = "";
		if (date != null) {
			dateStr = DateTimeUtil.formatDate(date);
		}
		
		return dateStr;
	}
	
	public String getFsDischargeDateDisplay() {
		FsFileIndex fsFileIndex = (FsFileIndex) getCurrentRowObject(); 
		
		Date date = fsFileIndex.getFsDischargeDate();
		
		String dateStr = "";
		if (date != null) {
			dateStr = DateTimeUtil.formatDate(date);
		}
		
		return dateStr;
	}
	
	public String getFsDueDateDisplay() {
		FsFileIndex fsFileIndex = (FsFileIndex) getCurrentRowObject(); 
		
		Date date = fsFileIndex.getFsDueDate();
		
		String dateStr = "";
		if (date != null) {
			dateStr = DateTimeUtil.formatDate(date);
		}
		
		return dateStr;
	}
	
	public String getFsImportDateDisplay() {
		Object obj = getCurrentRowObject();
		FsFileIndex fsFileIndex = null;
		FsImportLog fsImportLog = null;
		Date date = null;
		if (obj instanceof FsFileIndex) {
			fsFileIndex = (FsFileIndex) obj;
			date = fsFileIndex.getFsImportDate();
		} else if (obj instanceof FsImportLog) {
			fsImportLog = (FsImportLog) obj;
			date = fsImportLog.getFsImportDate();
		}
		
		String dateStr = "";
		if (date != null) {
			dateStr = DateTimeUtil.formatDateTime(date);
		}
		return dateStr;
	}
	
	public String getFsApprovedDateDisplay() {
		Object obj = getCurrentRowObject();
		FsFileIndex fsFileIndex = null;
		FsImportLog fsImportLog = null;
		Date date = null;
		if (obj instanceof FsFileIndex) {
			fsFileIndex = (FsFileIndex) obj;
			date = fsFileIndex.getFsApprovedDate();
		} else if (obj instanceof FsImportLog) {
			fsImportLog = (FsImportLog) obj;
			date = fsImportLog.getFsApprovedDate();
		}
		
		String dateStr = "";
		if (date != null) {
			dateStr = DateTimeUtil.formatDateTime(date);
		}
		return dateStr;
	}
	
	public String getFsEncodedParamsLiteDisplay() {
		FsImportLog fsImportLog = (FsImportLog) getCurrentRowObject(); 
		String str = fsImportLog.getFsEncodedParams();
		String returnStr = "";
		if (str != null) {
			int length = str.length() > 100 ? 100 : str.length();
			returnStr = str.substring(0, length - 1);
			returnStr += "...";
		}
		return returnStr;
	}
	
	public String getFormCodeAndRemark() {
		String ret = null;
		try {
			FsFileIndex fsFileIndex = (FsFileIndex) getCurrentRowObject(); 
		
			if (fsFileIndex != null) {
				String formCode = fsFileIndex.getFsFileProfile().getFsFormCode();
				String labNum = fsFileIndex.getFsLabNum();
				String key = fsFileIndex.getFsFileProfile().getFsKey();
				String num = labNum == null || labNum.isEmpty() ? key : labNum;
				ret = formCode + (num == null || num.isEmpty() ? "" : "<br />(no.:" + num + ")");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		return ret;
	}
	
	public String getInpDischargeImportDateDisplay() {
		String ret = "";
		Object obj = getCurrentRowObject();
		ReportableListObject row = null;
		if (obj instanceof ReportableListObject) {
			row = (ReportableListObject) obj;
			
			String importDates = row.getFields5();
			if (importDates != null) {
				String[] values = importDates.split(";");
				for (String value : values) {
					ret += (ret.isEmpty() ? "" : "<br />") + value;
				}
			}
		}
		return ret;
	}
	
	public String getInpDischargeApproveDateDisplay() {
		String ret = "";
		Object obj = getCurrentRowObject();
		ReportableListObject row = null;
		if (obj instanceof ReportableListObject) {
			row = (ReportableListObject) obj;
			
			String importDates = row.getFields6();
			if (importDates != null) {
				String[] values = importDates.split(";");
				for (String value : values) {
					ret += (ret.isEmpty() ? "" : "<br />") + value;
				}
			}
		}
		return ret;
	}
	
	public String getVolCurrentChartLocDisplay() {
		String ret = "";
		Object obj = getCurrentRowObject();
		ReportableListObject row = null;
		if (obj instanceof ReportableListObject) {
			row = (ReportableListObject) obj;
			
			String volCurrentChartLoc = row.getFields7();
			if (volCurrentChartLoc != null) {
				String[] values = volCurrentChartLoc.split(";");
				for (String value : values) {
					ret += (ret.isEmpty() ? "" : "<br />") + value;
				}
			}
		}
		return ret;
	}
}
