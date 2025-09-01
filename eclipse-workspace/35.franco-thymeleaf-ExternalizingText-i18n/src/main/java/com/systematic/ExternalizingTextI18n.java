package com.systematic;

import java.util.Locale;

import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.templateresolver.ClassLoaderTemplateResolver;

public class ExternalizingTextI18n {
	public static void main(String[] args) {
		TemplateEngine templateEngine = new TemplateEngine();
		ClassLoaderTemplateResolver resolver = new ClassLoaderTemplateResolver();
		templateEngine.setTemplateResolver(resolver);
		Locale.Builder localeBuilder = new Locale.Builder();
		localeBuilder.setLanguage("zh");
		// .setRegion("HK") // Set country/region
		// .setVariant("POSIX") // Set variant (optional)
		// .setExtension('u', "ca-gregory"); // Set locale extension (optional)
		Locale francoLocale = localeBuilder.build();

		Context ctx = new Context();
		ctx.setLocale(francoLocale);
		String resultString = templateEngine.process("externalizing-text.html", ctx);
		System.out.println(resultString);
	}
}
