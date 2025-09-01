package com.hkah.web.db.helper;

import java.util.ArrayList;
public class OTDocDetail{
    public String docCode;
    public String docType;
    public String phone;
    public String phone2;
    public ArrayList<OTSurgDetail> otSurgDetailList = new ArrayList<OTSurgDetail>();
    
    public OTDocDetail(String docCode, String phone, String phone2){
    	this(docCode, phone, phone2, null);
    }
    
    public OTDocDetail(String docCode, String phone, String phone2, String docType){
	   		this.docCode = docCode;
	   		this.phone = phone;
	   		this.phone2 = phone2;
	   		this.docType = docType;
    }    
}		

	 