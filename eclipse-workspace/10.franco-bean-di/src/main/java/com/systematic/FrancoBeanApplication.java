package com.systematic;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.annotation.Resource;

@RestController
@SpringBootApplication
public class FrancoBeanApplication {
	
	@Autowired
	ApplicationContext ctx;

	@Resource(name = "francoBean1")
	FrancoBean francoBean1;

	@Resource(name = "francoBean2")
	FrancoBean francoBean2;

	@RequestMapping("/")
	String home() {
		System.out.println(String.format("%s (%s)", francoBean1.getId(), ctx.getBean("francoBean1")));
		System.out.println(String.format("%s (%s)", francoBean2.getId(), ctx.getBean("francoBean2")));
		return "Franco: Please check console";
	}

	public static void main(String[] args) {
		SpringApplication.run(FrancoBeanApplication.class, args);
	}
}
