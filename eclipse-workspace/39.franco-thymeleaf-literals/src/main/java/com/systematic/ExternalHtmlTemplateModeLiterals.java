package com.systematic;

import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.templateresolver.ClassLoaderTemplateResolver;

public class ExternalHtmlTemplateModeLiterals {
	public static void main(String[] args) {
		TemplateEngine templateEngine = new TemplateEngine();
		ClassLoaderTemplateResolver resolver = new ClassLoaderTemplateResolver();
		templateEngine.setTemplateResolver(resolver);

		Context ctx = new Context();
		ctx.setVariable("francoData1", "francoData1");
		String resultString = templateEngine.process("index.html", ctx);
		System.out.println(resultString);
	}
}
