package com.systematic;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.security.web.WebAttributes;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpServletRequest;

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

	@GetMapping("/login/error")
	public String loginError(HttpServletRequest request, Model model) {
		AuthenticationException authenticationException = (AuthenticationException) request.getSession()
				.getAttribute(WebAttributes.AUTHENTICATION_EXCEPTION);

		String errorMessage = "Authentication failed. Please try again.";

		if (authenticationException instanceof UsernameNotFoundException
				|| authenticationException instanceof BadCredentialsException) {
			errorMessage = "Authentication error. Please check your username and password";
		} else {
			errorMessage = "Authentication error. Please try again.";
		}

		model.addAttribute("error", errorMessage);
		return "login"; // Return to the login page with an error message
	}

	@GetMapping("/secret")
	public String secret(Model model) {
		model.addAttribute("message", "This is a secret page!");
		// Return the secret view
		return "secret";
	}
}
