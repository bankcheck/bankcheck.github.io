package com.systematic;

import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;

public class HtmlTemplateMode {
	public static void main(String[] args) {
		TemplateEngine templateEngine = new TemplateEngine();
		Context ctx = new Context();
		String resultString = templateEngine.process("<input type='' th:value='Franco'/>", ctx);
		System.out.println(resultString);
		// <input type='' th:value='Franco'/> ==> <input type='' value='Franco'/>
	}
}
