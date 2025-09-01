package com.systematic;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.validation.beanvalidation.LocalValidatorFactoryBean;

@Configuration
public class FrancoConfig {
	@Autowired
	private MessageSource messageSource;

	@Bean
	public LocalValidatorFactoryBean validator() {
		LocalValidatorFactoryBean validator = new LocalValidatorFactoryBean();
		// Use system's default messages.properties.
		validator.setValidationMessageSource(messageSource);
		return validator;
	}
}
