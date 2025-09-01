package com.systematic;

import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.templateresolver.ClassLoaderTemplateResolver;

class DataClass {
	public DataClass(String name) {
		super();
		this.name = name;
	}

	private String name;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
}

public class ExternalHtmlTemplateModeSetVariable {
	public static void main(String[] args) {
		TemplateEngine templateEngine = new TemplateEngine();
		ClassLoaderTemplateResolver resolver = new ClassLoaderTemplateResolver();
		templateEngine.setTemplateResolver(resolver);
		Context ctx = new Context();
		ctx.setVariable("data", new DataClass("Franco from DataClass object"));
		// index.html should be under classpath.
		String resultString = templateEngine.process("index.html", ctx);
		System.out.println(resultString);
	}
}
