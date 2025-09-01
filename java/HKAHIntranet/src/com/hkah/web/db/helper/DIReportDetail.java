package com.hkah.web.db.helper;

public class DIReportDetail {
	public int diLogID;
	public String seqNo;
	public String filePath;
	public String patNo;
	public String accessionNo;
	public String rptVersion;
	
	 public DIReportDetail(int diLogID, String seqNo, String filePath, String patNo, String accessionNo, String rptVersion){
		this.diLogID = diLogID;
		this.seqNo = seqNo;
		this.filePath = filePath;
		this.patNo = patNo;
		this.accessionNo = accessionNo;
		this.rptVersion = rptVersion;
	 }    
}
