package com.systematic;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@SpringBootApplication
public class FrancoBasicAOP {

	@Autowired
	FrancoService francoServiceObject;

	@RequestMapping("/")
	String home() {
		francoServiceObject.doFrancoService();
		return "Please check console.";
	}

	public static void main(String[] args) {
		SpringApplication.run(FrancoBasicAOP.class, args);
	}
}
