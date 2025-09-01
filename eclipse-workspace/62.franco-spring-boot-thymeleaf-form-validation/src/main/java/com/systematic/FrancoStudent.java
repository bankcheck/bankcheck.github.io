package com.systematic;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;

public class FrancoStudent {
	// @NotBlank(message = "{francoStudent.name.notBlank}")
	@NotBlank(message = "Franco: Cannot blank")
	private String studentNameInClass;

	@Email(message = "Franco: Please type an email address")
	private String emailInClass;

	@Size(min = 6, message = "Franco: Password length should be least 6 chars.")
	private String passwordInClass;

	public FrancoStudent() {
		super();
	}	

	public String getStudentNameInClass() {
		return studentNameInClass;
	}

	public void setStudentNameInClass(String studentNameInClass) {
		this.studentNameInClass = studentNameInClass;
	}

	public String getEmailInClass() {
		return emailInClass;
	}

	public void setEmailInClass(String emailInClass) {
		this.emailInClass = emailInClass;
	}

	public String getPasswordInClass() {
		return passwordInClass;
	}

	public void setPasswordInClass(String passwordInClass) {
		this.passwordInClass = passwordInClass;
	}
}
