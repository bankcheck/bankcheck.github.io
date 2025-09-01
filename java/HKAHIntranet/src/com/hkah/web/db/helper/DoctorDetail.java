package com.hkah.web.db.helper;

import java.util.ArrayList;
public class DoctorDetail{
    public String docCode;
    public String email;
    public ArrayList<LabReportDetail> labDetailList = new ArrayList<LabReportDetail>();
    public ArrayList<DIReportDetail> diDetailList = new ArrayList<DIReportDetail>();
    public DoctorDetail(String docCode,String email){
	   		this.docCode = docCode;
	   		this.email = email;
    }    
}		

	 