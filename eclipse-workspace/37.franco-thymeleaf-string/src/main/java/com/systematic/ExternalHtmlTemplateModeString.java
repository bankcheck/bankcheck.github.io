package com.systematic;

import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.templateresolver.ClassLoaderTemplateResolver;

class FrancoStudent {
	public FrancoStudent(Integer id, String studentName) {
		super();
		this.id = id;
		this.studentName = studentName;
	}

	private Integer id;

	public Integer getId() {
		return id;
	}

	public void setId(Integer id) {
		this.id = id;
	}

	private String studentName;

	public String getStudentName() {
		return studentName;
	}

	public void setStudentName(String studentName) {
		this.studentName = studentName;
	}

	@Override
	public String toString() {
		return "FrancoStudent [id=" + id + ", studentName=" + studentName + "]";
	}
}

public class ExternalHtmlTemplateModeString {
	public static void main(String[] args) {
		TemplateEngine templateEngine = new TemplateEngine();
		ClassLoaderTemplateResolver resolver = new ClassLoaderTemplateResolver();
		templateEngine.setTemplateResolver(resolver);

		FrancoStudent jane = new FrancoStudent(1, "Jane");
		Context ctx = new Context();
		ctx.setVariable("jane", jane);
		String resultString = templateEngine.process("index.html", ctx);
		System.out.println(resultString);
	}
}
