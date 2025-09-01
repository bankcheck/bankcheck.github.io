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
	public String home() {
		return "Franco Home Page";
	}

	@GetMapping("/secret1")
	public String secret1() {
		return "Franco Secret Page 1";
	}

	@GetMapping("/authorization-error")
	public String authorizationError() {
		return "Access Denied: You do not have permission to access this resource.";
	}

	@GetMapping("/secret2")
	public String secret2() {
		return "Franco Secret Page 2";
	}

	// http://localhost:8080/secret1, login with Jane as Jane does not have the
	// role1, error pages are shown.
}
