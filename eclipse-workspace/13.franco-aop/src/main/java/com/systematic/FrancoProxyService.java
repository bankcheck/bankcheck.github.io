package com.systematic;

import org.aspectj.lang.annotation.After;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

@Aspect
@Component
public class FrancoProxyService {
	@Before("execution(* com.systematic.*FrancoService.*(..))")
	public void before() {
		System.out.println("Before Franco Service.");
	}

	@After("execution(* com.systematic.*FrancoService.*(..))")
	public void after() {
		System.out.println("After Franco Service.");
	}
}
