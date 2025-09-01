package com.hkah.ehr.model;

public class Participant extends org.hl7.v3.Participant {
	protected String age;
	protected boolean active;

	public String getAge() {
		return age;
	}

	public void setAge(String age) {
		this.age = age;
	}

	public boolean isActive() {
		return active;
	}

	public void setActive(boolean active) {
		this.active = active;
	}
}
