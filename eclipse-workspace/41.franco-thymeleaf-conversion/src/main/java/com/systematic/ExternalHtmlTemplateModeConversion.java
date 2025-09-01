package com.systematic;

import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.templateresolver.ClassLoaderTemplateResolver;
import org.thymeleaf.standard.StandardDialect;
import org.thymeleaf.standard.expression.IStandardConversionService;

class FrancoStudent {
	public FrancoStudent(String studentName, Integer age) {
		super();
		this.studentName = studentName;
		this.age = age;
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

	@Override
	public String toString() {
		return "FrancoStudent [studentName=" + studentName + ", age=" + age + "]";
	}
}

public class ExternalHtmlTemplateModeConversion {
	public static void main(String[] args) {
		TemplateEngine templateEngine = new TemplateEngine();
		ClassLoaderTemplateResolver resolver = new ClassLoaderTemplateResolver();
		templateEngine.setTemplateResolver(resolver);
		
		IStandardConversionService francoConversionService = new FrancoConversionService();
		StandardDialect dialect = new StandardDialect();
		dialect.setConversionService(francoConversionService);
		templateEngine.setDialect(dialect);

		Context ctx = new Context();
		ctx.setVariable("francoStudent", new FrancoStudent("Jane", 18));
		String resultString = templateEngine.process("index.html", ctx);
		System.out.println(resultString);
	}
}
