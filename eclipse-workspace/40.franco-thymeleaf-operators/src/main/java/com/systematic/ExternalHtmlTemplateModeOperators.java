package com.systematic;

import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.templateresolver.ClassLoaderTemplateResolver;

class FrancoStudent {

	public FrancoStudent(String studentName) {
		super();
		this.studentName = studentName;
	}

	private String studentName;

	public String getStudentName() {
		return studentName;
	}

	public void setStudentName(String studentName) {
		this.studentName = studentName;
	}
}

public class ExternalHtmlTemplateModeOperators {
	public static void main(String[] args) {
		TemplateEngine templateEngine = new TemplateEngine();
		ClassLoaderTemplateResolver resolver = new ClassLoaderTemplateResolver();
		templateEngine.setTemplateResolver(resolver);

		Context ctx = new Context();
		ctx.setVariable("francoStudent", new FrancoStudent("Jane"));
		String resultString = templateEngine.process("index.html", ctx);
		System.out.println(resultString);
	}
}
