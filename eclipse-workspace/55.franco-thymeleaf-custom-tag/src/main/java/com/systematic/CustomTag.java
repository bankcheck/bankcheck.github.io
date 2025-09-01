package com.systematic;

import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.templateresolver.ClassLoaderTemplateResolver;

public class CustomTag {
	public static void main(String[] args) {
		TemplateEngine templateEngine = new TemplateEngine();
		ClassLoaderTemplateResolver resolver = new ClassLoaderTemplateResolver();
		templateEngine.setTemplateResolver(resolver);
		templateEngine.addDialect(new FrancoTagDialect());

		Context ctx = new Context();
		ctx.setVariable("man", false);
		String resultString = templateEngine.process("index.html", ctx);
		System.out.println(resultString);
	}
}
