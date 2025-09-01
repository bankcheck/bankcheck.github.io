package com.systematic;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@SpringBootApplication
public class FrancoBeanApplication {

	@Autowired
	ApplicationContext ctx;

	@Autowired
	FrancoBean francoBean1Singleton;

	@Autowired
	FrancoBean francoBean2Prototype;

	@RequestMapping("/")
	String home() {
		System.out.println(String.format("%s (%s)", francoBean1Singleton.getId(), ctx.getBean("francoBean1Singleton")));
		System.out.println(String.format("%s (%s)", francoBean2Prototype.getId(), ctx.getBean("francoBean2Prototype")));
		return "Franco: Please check console";
	}

	public static void main(String[] args) {
		SpringApplication.run(FrancoBeanApplication.class, args);
	}
}
