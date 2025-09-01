package com.systematic;

import java.time.ZoneId;
import java.time.ZonedDateTime;
import java.util.Date;

import org.thymeleaf.TemplateEngine;
import org.thymeleaf.context.Context;
import org.thymeleaf.templateresolver.ClassLoaderTemplateResolver;

public class ExternalHtmlTemplateModeString {
	public static void main(String[] args) {
		TemplateEngine templateEngine = new TemplateEngine();
		ClassLoaderTemplateResolver resolver = new ClassLoaderTemplateResolver();
		templateEngine.setTemplateResolver(resolver);

		Context ctx = new Context();
		// Get the current time in Hong Kong time zone
        ZonedDateTime hongKongTime = ZonedDateTime.now(ZoneId.of("Asia/Hong_Kong"));        
        // Convert ZonedDateTime to Date
        Date fracnoDate = Date.from(hongKongTime.toInstant());
        
		ctx.setVariable("francoDate", fracnoDate);
		String resultString = templateEngine.process("index.html", ctx);
		System.out.println(resultString);
	}
}
