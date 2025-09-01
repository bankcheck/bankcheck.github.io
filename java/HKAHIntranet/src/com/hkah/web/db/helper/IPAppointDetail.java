package com.hkah.web.db.helper;

public class IPAppointDetail {
	public String regid;
	public String patno;
	public String wardCode;	
	public String wardName;
	public String bedCode;
	public String dateStr;
	
	 public IPAppointDetail(String regid, String patno, String wardCode, String wardName, String bedCode, String dateStr){
		this.regid = regid;
		this.patno = patno;
		this.wardCode = wardCode;		
		this.wardName = wardName;
		this.bedCode = bedCode;
		this.dateStr = dateStr;
	 }    
}
