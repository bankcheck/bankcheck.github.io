package com.systematic;

import java.io.IOException;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpServletResponse;

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

	@GetMapping("/trigger-403")
	public void trigger403(HttpServletResponse response) throws IOException {
		response.sendError(HttpStatus.FORBIDDEN.value(), "Forbidden");
	}

	@GetMapping("/")
	public String home() {
		return "Franco Home";
	}
}
