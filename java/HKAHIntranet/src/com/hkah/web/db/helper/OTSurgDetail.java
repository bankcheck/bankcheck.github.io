package com.hkah.web.db.helper;

public class OTSurgDetail {
	public String otaid;
	public String patno;
	public String surgDate;
	public String surgDesc;
	public String procRemark;
	public String surgDescSec;
	public String anaesthetist;
	
	 public OTSurgDetail(String otaid, String patno, String surgDate, String surgDesc, String procRemark, String surgDescSec){
		this.otaid = otaid;
		this.patno = patno;
		this.surgDate = surgDate;
		this.surgDesc = surgDesc;
		this.procRemark = procRemark;
		this.surgDescSec = surgDescSec;
	 }
	 
	 public OTSurgDetail(String otaid, String patno, String surgDate, String surgDesc, String procRemark, String surgDescSec, String anaesthetist ){
			this.otaid = otaid;
			this.patno = patno;
			this.surgDate = surgDate;
			this.surgDesc = surgDesc;
			this.procRemark = procRemark;
			this.surgDescSec = surgDescSec;
			this.anaesthetist = anaesthetist;
		 } 	 
}
