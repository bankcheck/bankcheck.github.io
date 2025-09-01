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

	@GetMapping("/trigger-error")
	public String triggerError() {
		// This will intentionally throw a NullPointerException
		throw new NullPointerException("This is a test error!");
	}

	@GetMapping("/")
	public String home() {
		return "Franco Home";
	}
}
