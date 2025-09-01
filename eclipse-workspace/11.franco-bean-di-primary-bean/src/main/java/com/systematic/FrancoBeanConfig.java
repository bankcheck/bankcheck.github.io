package com.systematic;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;

@Configuration
public class FrancoBeanConfig {
	@Bean
	@Primary
	public FrancoBean francoBean1() {
		return new FrancoBean("1");
	}

	@Bean
	public FrancoBean francoBean2() {
		return new FrancoBean("2");
	}
}
