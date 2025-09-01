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

	@RequestMapping("/")
	String home() {
		String[] beanNames = ctx.getBeanNamesForType(FrancoBean.class);
		for (String eachBeanName : beanNames) {
			System.out.println(eachBeanName);
		}
		return "Franco: Please check console";
	}

	public static void main(String[] args) {
		SpringApplication.run(FrancoBeanApplication.class, args);
	}
}
