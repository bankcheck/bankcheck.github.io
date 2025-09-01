package com.systematic;

import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.templateresolver.ClassLoaderTemplateResolver;

public class ExternalHtmlTemplateModeNumberFormat {
	public static void main(String[] args) {
		TemplateEngine templateEngine = new TemplateEngine();
		ClassLoaderTemplateResolver resolver = new ClassLoaderTemplateResolver();
		templateEngine.setTemplateResolver(resolver);

		Double francoNumber1 = 2222.9999;
		Double francoNumber2 = 0.55;
		Context ctx = new Context();
		ctx.setVariable("francoNumber1", francoNumber1);
		ctx.setVariable("francoNumber2", francoNumber2);
		String resultString = templateEngine.process("index.html", ctx);
		System.out.println(resultString);
	}
}
