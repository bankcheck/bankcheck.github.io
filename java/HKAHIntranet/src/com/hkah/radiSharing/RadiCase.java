package com.hkah.radiSharing;

import java.util.HashMap;

public class RadiCase{
	String accessionNo;
	String patno;
	String examType;
	String examDate;
	String imagePath;
	String reportPath;
	HashMap<String,String> reportContent;

	public RadiCase(){
		super();
	}
	public RadiCase(String accessionNo, String patno, String examType,
			String examDate, String imagePath, String reportPath,
			HashMap<String, String> reportContent) {
		this.accessionNo = accessionNo;
		this.patno = patno;
		this.examType = examType;
		this.examDate = examDate;
		this.imagePath = imagePath;
		this.reportPath = reportPath;
		this.reportContent = reportContent;
	}

	
	public String getAccessionNo() {
		return accessionNo;
	}

	public String getPatno() {
		return patno;
	}

	public String getExamType() {
		return examType;
	}

	public String getExamDate() {
		return examDate;
	}

	public String getImagePath() {
		return imagePath;
	}

	public String getReportPath() {
		return reportPath;
	}

	public HashMap<String, String> getReportContent() {
		return reportContent;
	}

	public void setAccessionNo(String accessionNo) {
		this.accessionNo = accessionNo;
	}

	public void setPatno(String patno) {
		this.patno = patno;
	}

	public void setExamType(String examType) {
		this.examType = examType;
	}

	public void setExamDate(String examDate) {
		this.examDate = examDate;
	}

	public void setImagePath(String imagePath) {
		this.imagePath = imagePath;
	}

	public void setReportPath(String reportPath) {
		this.reportPath = reportPath;
	}

	public void setReportContent(HashMap<String, String> reportContent) {
		this.reportContent = reportContent;
	}

}