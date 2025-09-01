package com.systematic;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class FrancoStringBootApp {
	public static void main(String[] args) {
		SpringApplication.run(FrancoStringBootApp.class, args);
	}

	@GetMapping("/")
	public String francohome() {
		return "Franco Home Page";
	}

	// Please go to console to find the password. Then use username "user" and
	// password displayed on console to login.
}
