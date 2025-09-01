package com.systematic;

import org.springframework.context.annotation.Condition;
import org.springframework.context.annotation.ConditionContext;
import org.springframework.core.env.Environment;
import org.springframework.core.type.AnnotatedTypeMetadata;

public class FrancoCondition implements Condition {

	@Override
	public boolean matches(ConditionContext context, AnnotatedTypeMetadata metadata) {
		Environment env = context.getEnvironment();
		// You can change the port to 8081 for test fail.
		if (env.getProperty("server.port").equals("8080")) {
			return true;
		}
		return false;
	}
}
