package com.hkah.web.db.helper;

public class IPWardDetail {
	public String wardCode;
	public String wardName;
	public String bedString;
	public String romCode;
	public String patfname;
	public int numCount;	
	
	public IPWardDetail(String wardCode, String wardName, int numCount, String bedString){
		this(wardCode, wardName, numCount, bedString, null, null);
	}
	
	 public IPWardDetail(String wardCode, String wardName, int numCount, String bedString, String romCode, String patfname){
		this.wardCode = wardCode;
		this.wardName = wardName;
		this.romCode = romCode;
		this.numCount = numCount;
		this.bedString = bedString;
		this.patfname = patfname;
	 }    
}
