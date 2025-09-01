package com.systematic;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class FrancoBeanConfig {
	@Bean(value = "francoBean1")
	@ConditionOnFrancoCondition
	public FrancoBean francoBean1() {
		return new FrancoBean("1");
	}
}
