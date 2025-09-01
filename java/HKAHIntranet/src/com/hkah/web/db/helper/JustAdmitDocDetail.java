package com.hkah.web.db.helper;

import java.util.ArrayList;
public class JustAdmitDocDetail{
    public String docCode;
    public String phone;
    public String phone2;
    public ArrayList<JustAdmitDetail> justAdmitDetailList = new ArrayList<JustAdmitDetail>();
    public JustAdmitDocDetail(String docCode, String phone, String phone2){
	   		this.docCode = docCode;
	   		this.phone = phone;
	   		this.phone2 = phone2;
    }    
}		

	 