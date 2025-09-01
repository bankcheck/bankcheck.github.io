package com.hkah.web.db.helper;

public class LabReportDetail {
	public int labLogID;
	public String labNum;
	public String testCat;
	public String rptNo;
	public String rptVersion;	
	public String filePath;
	public String critical;
	
	 public LabReportDetail(int labLogID, String labNum, String testCat, String rptNo,
			 String rptVersion, String filePath, String critical){
		this.labLogID = labLogID;
		this.labNum = labNum;
		this.testCat = testCat;
		this.rptNo = rptNo;
		this.rptVersion = rptVersion;
		this.filePath = filePath;
		this.critical = critical;
	 }    
}
