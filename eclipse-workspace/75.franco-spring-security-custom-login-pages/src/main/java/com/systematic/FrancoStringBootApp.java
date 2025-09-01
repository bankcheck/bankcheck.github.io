package com.systematic;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@SpringBootApplication
@Controller
public class FrancoStringBootApp {
	public static void main(String[] args) {
		SpringApplication.run(FrancoStringBootApp.class, args);
	}

	@GetMapping("/")
	public String home() {
		return "home";
	}

	@GetMapping("/login")
	public String login() {
		// Return the custom login view
		return "login";
	}

	@GetMapping("/secret")
	public String secret(Model model) {
		model.addAttribute("message", "This is a secret page!");
		// Return the secret view
		return "secret";
	}
}
