package com.systematic;

import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.templateresolver.ClassLoaderTemplateResolver;

class FrancoStudent {
	public FrancoStudent(String studentName, Integer age, String gender) {
		super();
		this.studentName = studentName;
		this.age = age;
		this.gender = gender;
	}

	private String studentName;

	public String getStudentName() {
		return studentName;
	}

	public void setStudentName(String studentName) {
		this.studentName = studentName;
	}

	private Integer age;

	public Integer getAge() {
		return age;
	}

	public void setAge(Integer age) {
		this.age = age;
	}

	private String gender;

	public String getGender() {
		return gender;
	}

	public void setGender(String gender) {
		this.gender = gender;
	}

	@Override
	public String toString() {
		return "FrancoStudent [studentName=" + studentName + ", age=" + age + ", gender=" + gender + "]";
	}
}

public class ExternalHtmlTemplateHtmlForm {
	public static void main(String[] args) {
		TemplateEngine templateEngine = new TemplateEngine();
		ClassLoaderTemplateResolver resolver = new ClassLoaderTemplateResolver();
		templateEngine.setTemplateResolver(resolver);

		Context ctx = new Context();
		ctx.setVariable("francoFormName", "franco-form-name");
		ctx.setVariable("francoStudent", new FrancoStudent("Jane", 18, "F"));

		String resultString = templateEngine.process("index.html", ctx);
		System.out.println(resultString);
	}
}
