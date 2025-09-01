package com.systematic;

import java.util.HashMap;
import java.util.Map;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Scope;
import org.thymeleaf.TemplateEngine;
import org.thymeleaf.spring6.SpringTemplateEngine;
import org.thymeleaf.spring6.view.ThymeleafView;
import org.thymeleaf.spring6.view.ThymeleafViewResolver;

@Configuration
public class FrancoThymeleafViewConfig {
	@Bean
	public ThymeleafViewResolver viewResolver(TemplateEngine engine) {
		ThymeleafViewResolver viewResolver = new ThymeleafViewResolver();
		viewResolver.setTemplateEngine((SpringTemplateEngine) engine);
		viewResolver.setCache(false);
		// Set order if you have multiple view resolvers
		viewResolver.setOrder(1);
		return viewResolver;
	}

	@Bean
	@Scope("prototype")
	public ThymeleafView francoView() {
		System.out.println("Creating Franco View");
		ThymeleafView view = new ThymeleafView("francoView");
		Map<String, String> francoStaticVars = new HashMap<String, String>();
		francoStaticVars.put("francoWelcome", "Welcome by Franco");
		view.setStaticVariables(francoStaticVars);
		return view;
	}
}
