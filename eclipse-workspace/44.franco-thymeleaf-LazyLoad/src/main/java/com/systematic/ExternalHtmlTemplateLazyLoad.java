package com.systematic;

import java.util.ArrayList;
import java.util.List;

import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.context.LazyContextVariable;
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

	@Override
	public String toString() {
		return "FrancoStudent [studentName=" + studentName + "]";
	}
}

public class ExternalHtmlTemplateLazyLoad {
	public static void main(String[] args) {
		TemplateEngine templateEngine = new TemplateEngine();
		ClassLoaderTemplateResolver resolver = new ClassLoaderTemplateResolver();
		templateEngine.setTemplateResolver(resolver);

		Context ctx = new Context();
		ctx.setVariable("francoStudents", new LazyContextVariable<Object>() {
			@Override
			protected Object loadValue() {
				return getFrancoStudents();
			}
		});
		// ctx.setVariable("show", false);
		ctx.setVariable("show", true);

		String resultString = templateEngine.process("index.html", ctx);
		System.out.println(resultString);
	}

	static List<FrancoStudent> getFrancoStudents() {
		List<FrancoStudent> francoStudents = new ArrayList<FrancoStudent>();
		francoStudents.add(new FrancoStudent("Franco"));
		francoStudents.add(new FrancoStudent("Jane"));
		return francoStudents;
	}
}
