package com.hkah.web.db.helper;

import java.util.ArrayList;
public class LocationDetail{
    public String locCode;
    public String email;
    public String locName;
    public ArrayList<LabReportDetail> labDetailList = new ArrayList<LabReportDetail>();
    public LocationDetail(String locCode,String email, String locName){
	   		this.locCode = locCode;
	   		this.email = email;
	   		this.locName = locName;
    }    
}		

	 