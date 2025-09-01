package com.systematic;

public class FrancoStudent {
	private String studentNameInClass;
	private String genderInClass;
	private String[] likeColorsInClass;

	public FrancoStudent() {
		super();
	}

	public FrancoStudent(String studentNameInClass, String genderInClass, String[] likeColorsInClass) {
		super();
		this.studentNameInClass = studentNameInClass;
		this.genderInClass = genderInClass;
		this.likeColorsInClass = likeColorsInClass;
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

	public String[] getLikeColorsInClass() {
		return likeColorsInClass;
	}

	public void setLikeColorsInClass(String[] likeColorsInClass) {
		this.likeColorsInClass = likeColorsInClass;
	}	
}
