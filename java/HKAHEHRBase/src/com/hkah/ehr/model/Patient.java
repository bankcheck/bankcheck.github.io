package com.hkah.ehr.model;

import java.util.Date;

public class Patient {
	protected String patno = null;
	protected String patfname = null;
	protected String patgname = null;
	protected String patcname = null;
	protected String patidno = null;
	protected Date patbdate = null;
	protected String age = null;
	protected String patsex = null;
	protected String doctype = null;
	
	public String getPatno() {
		return patno;
	}
	public void setPatno(String patno) {
		this.patno = patno;
	}
	public String getPatfname() {
		return patfname;
	}
	public void setPatfname(String patfname) {
		this.patfname = patfname;
	}
	public String getPatgname() {
		return patgname;
	}
	public void setPatgname(String patgname) {
		this.patgname = patgname;
	}
	public String getPatcname() {
		return patcname;
	}
	public void setPatcname(String patcname) {
		this.patcname = patcname;
	}
	public String getPatidno() {
		return patidno;
	}
	public void setPatidno(String patidno) {
		this.patidno = patidno;
	}
	public Date getPatbdate() {
		return patbdate;
	}
	public void setPatbdate(Date patbdate) {
		this.patbdate = patbdate;
	}
	public String getAge() {
		return age;
	}
	public void setAge(String age) {
		this.age = age;
	}
	public String getPatsex() {
		return patsex;
	}
	public void setPatsex(String patsex) {
		this.patsex = patsex;
	}
	public String getDoctype() {
		return doctype;
	}
	public void setDoctype(String doctype) {
		this.doctype = doctype;
	}
}
