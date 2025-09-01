package com.systematic;

import org.springframework.beans.factory.config.ConfigurableBeanFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Scope;

@Configuration
public class FrancoBeanConfig {
	@Bean
	@Scope(value = ConfigurableBeanFactory.SCOPE_SINGLETON)
	public FrancoBean francoBean1Singleton() {
		return new FrancoBean("1");
	}

	@Bean
	@Scope(value = ConfigurableBeanFactory.SCOPE_PROTOTYPE)
	public FrancoBean francoBean2Prototype() {
		return new FrancoBean("2");
	}
}
