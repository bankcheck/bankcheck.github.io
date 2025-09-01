package com.hkah.web.db.helper;

public class JustAdmitDetail extends IPAppointDetail {
	public String patfname;
	public String romCode;
	
	public JustAdmitDetail(String regid, String patno, String patfname, String wardCode, String wardName, String bedCode, String romCode, String dateStr){
		super(regid, patno, wardCode, wardName, bedCode, dateStr);
		this.patfname = patfname;
		this.romCode = romCode;
	}
}
