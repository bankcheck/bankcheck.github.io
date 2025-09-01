package com.hkah.ehr.model;

import java.util.Date;

public class Reg {
	protected String regid = null;
	protected String patno = null;
	protected String slpno = null;
	protected Date regdate = null;
	protected String doccode = null;
	
	// foreign table fields
	protected Date inpddate = null;
	protected String acmname = null;
	protected String wrdname = null;
	protected String bedcode = null;
	public String getRegid() {
		return regid;
	}
	public void setRegid(String regid) {
		this.regid = regid;
	}
	public String getPatno() {
		return patno;
	}
	public void setPatno(String patno) {
		this.patno = patno;
	}
	public String getSlpno() {
		return slpno;
	}
	public void setSlpno(String slpno) {
		this.slpno = slpno;
	}
	public Date getRegdate() {
		return regdate;
	}
	public void setRegdate(Date regdate) {
		this.regdate = regdate;
	}
	public String getDoccode() {
		return doccode;
	}
	public void setDoccode(String doccode) {
		this.doccode = doccode;
	}
	public Date getInpddate() {
		return inpddate;
	}
	public void setInpddate(Date inpddate) {
		this.inpddate = inpddate;
	}
	public String getAcmname() {
		return acmname;
	}
	public void setAcmname(String acmname) {
		this.acmname = acmname;
	}
	public String getWrdname() {
		return wrdname;
	}
	public void setWrdname(String wrdname) {
		this.wrdname = wrdname;
	}
	public String getBedcode() {
		return bedcode;
	}
	public void setBedcode(String bedcode) {
		this.bedcode = bedcode;
	}
}
