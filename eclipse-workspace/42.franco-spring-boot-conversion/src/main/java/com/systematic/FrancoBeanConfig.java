package com.systematic;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class FrancoBeanConfig {
	@Bean
	public FrancoBigDecimalFormatter francoBigDecimalFormatter() {
		return new FrancoBigDecimalFormatter();
	}
}
