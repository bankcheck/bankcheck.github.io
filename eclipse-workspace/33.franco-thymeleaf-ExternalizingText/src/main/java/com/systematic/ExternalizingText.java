package com.systematic;

import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.templateresolver.ClassLoaderTemplateResolver;

public class ExternalizingText {
	public static void main(String[] args) {
		TemplateEngine templateEngine = new TemplateEngine();
		ClassLoaderTemplateResolver resolver = new ClassLoaderTemplateResolver();
		templateEngine.setTemplateResolver(resolver);
		String resultString = templateEngine.process("externalizing-text.html", new Context());
		System.out.println(resultString);
	}
}
