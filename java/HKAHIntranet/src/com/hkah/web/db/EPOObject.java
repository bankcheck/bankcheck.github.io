package com.hkah.web.db;

import java.io.Serializable;

public class EPOObject implements Serializable {
	private String fields1 = null;
	private String fields2 = null;
	private String fields3 = null;
	private Integer fields4 = null;
	private Double fields5 = null;
	private Double fields6 = null;
	private String fields7 = null;

	public EPOObject(String fields1, String fields2, String fields3, String fields7, Double fields6, Integer fields4, Double fields5) {
		this.fields1 = fields1;
		this.fields2 = fields2;
		this.fields3 = fields3;
		this.fields7 = fields7;
		this.fields6 = fields6;
		this.fields4 = fields4;		
		this.fields5 = fields5;
	}	

	public String getFields1() {
		return fields1;
	}

	public void setFields1(String fields1) {
		this.fields1 = fields1;
	}

	public String getFields2() {
		return fields2;
	}

	public void setFields2(String fields2) {
		this.fields2 = fields2;
	}

	public String getFields3() {
		return fields3;
	}

	public void setFields3(String fields3) {
		this.fields3 = fields3;
	}

	public Integer getFields4() {
		return fields4;
	}

	public void setFields4(Integer fields4) {
		this.fields4 = fields4;
	}

	public Double getFields5() {
		return fields5;
	}

	public void setFields5(Double fields5) {
		this.fields5 = fields5;
	}

	public Double getFields6() {
		return fields6;
	}

	public void setFields6(Double fields6) {
		this.fields6 = fields6;
	}

	public String getFields7() {
		return fields7;
	}

	public void setFields7(String fields7) {
		this.fields7 = fields7;
	}	

}
