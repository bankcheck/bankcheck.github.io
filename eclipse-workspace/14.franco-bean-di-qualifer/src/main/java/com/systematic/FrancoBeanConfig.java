package com.systematic;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class FrancoBeanConfig {
	@Bean	
	public FrancoBean francoBean1() {
		return new FrancoBean("1");
	}

	@Bean
	public FrancoBean francoBean2() {
		return new FrancoBean("2");
	}
}
