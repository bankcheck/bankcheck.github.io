package com.systematic;

import org.springframework.boot.autoconfigure.condition.ConditionalOnClass;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class FrancoBeanConfig {
	@Bean(value = "francoBean1")
	@ConditionalOnClass(name = "com.systematic.SomeLibraryClass") // Throw exception!!
	// @ConditionalOnClass(name = "com.systematic.FrancoBeanApplication")
	public FrancoBean francoBean1() {
		return new FrancoBean("1");
	}
}
