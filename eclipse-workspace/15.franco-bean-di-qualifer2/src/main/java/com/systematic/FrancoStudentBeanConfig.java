package com.systematic;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class FrancoStudentBeanConfig {
	@Bean
	@FrancoStudentQualifier(type = "Programming")
	public FrancoStudentBean francoBean1() {
		return new FrancoStudentBean("1");
	}

	@Bean
	@FrancoStudentQualifier(type = "Networking")
	public FrancoStudentBean francoBean2() {
		return new FrancoStudentBean("2");
	}
}
