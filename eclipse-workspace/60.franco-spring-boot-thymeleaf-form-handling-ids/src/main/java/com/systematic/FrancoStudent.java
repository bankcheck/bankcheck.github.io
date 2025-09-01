package com.systematic;

public class FrancoStudent {
	private String studentNameInClass;
	private String genderInClass;

	public FrancoStudent() {
		super();
	}

	public FrancoStudent(String studentName, String gender) {
		super();
		this.studentNameInClass = studentName;
		this.genderInClass = gender;
	}

	public String getStudentNameInClass() {
		return studentNameInClass;
	}

	public void setStudentNameInClass(String studentNameInClass) {
		this.studentNameInClass = studentNameInClass;
	}

	public String getGenderInClass() {
		return genderInClass;
	}

	public void setGenderInClass(String genderInClass) {
		this.genderInClass = genderInClass;
	}
}
