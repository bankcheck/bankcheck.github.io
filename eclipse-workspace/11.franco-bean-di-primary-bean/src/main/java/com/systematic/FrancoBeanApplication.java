package com.systematic;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@SpringBootApplication
public class FrancoBeanApplication {

	@Autowired
	FrancoBean francoBean;

	@RequestMapping("/")
	String home() {
		System.out.println(String.format("%s (%s)", francoBean.getId(), francoBean.toString()));
		return "Franco: Please check console";
	}

	public static void main(String[] args) {
		SpringApplication.run(FrancoBeanApplication.class, args);
	}
}
