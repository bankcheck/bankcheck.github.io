package com.systematic;

import java.util.ArrayList;
import java.util.List;

import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.templateresolver.ClassLoaderTemplateResolver;

class FrancoStudent {
	public FrancoStudent(String name) {
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

public class ExternalHtmlTemplateModeSetList {
	public static void main(String[] args) {
		List<FrancoStudent> allFrancoStudentsInController = new ArrayList<FrancoStudent>();
		allFrancoStudentsInController.add(new FrancoStudent("Franco"));
		allFrancoStudentsInController.add(new FrancoStudent("Jane"));

		TemplateEngine templateEngine = new TemplateEngine();
		ClassLoaderTemplateResolver resolver = new ClassLoaderTemplateResolver();
		templateEngine.setTemplateResolver(resolver);
		Context ctx = new Context();
		ctx.setVariable("allStudentsInTemplate", allFrancoStudentsInController);
		// index.html should be under classpath.
		String resultString = templateEngine.process("index.html", ctx);
		System.out.println(resultString);
	}
}
