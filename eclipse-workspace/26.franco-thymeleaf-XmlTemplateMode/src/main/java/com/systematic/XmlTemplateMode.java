package com.systematic;

import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.templatemode.TemplateMode;
import org.thymeleaf.templateresolver.StringTemplateResolver;

public class XmlTemplateMode {
	public static void main(String[] args) {
		TemplateEngine templateEngine = new TemplateEngine();

		StringTemplateResolver resolver = new StringTemplateResolver();
		resolver.setTemplateMode(TemplateMode.XML);

		templateEngine.setTemplateResolver(resolver);
		Context ctx = new Context();
		String resultString = templateEngine.process("<student th:attr='id=Franco'></student>", ctx);
		System.out.println(resultString);
		// <student th:attr='id=Franco'></student> to <student id="Franco"></student>
	}
}
