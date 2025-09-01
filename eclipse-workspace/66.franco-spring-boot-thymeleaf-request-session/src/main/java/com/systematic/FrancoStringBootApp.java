package com.systematic;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@SpringBootApplication
@Controller
public class FrancoStringBootApp {
	public static void main(String[] args) {
		SpringApplication.run(FrancoStringBootApp.class, args);
	}

	@RequestMapping("/")
	public String home(HttpServletRequest request, HttpSession session, Model model) {
		// Get the current date and time
		LocalDateTime now = LocalDateTime.now();
		DateTimeFormatter formatter = DateTimeFormatter.ofPattern("MM-dd HH:mm:ss");

		request.setAttribute("requestAttr", "Request Attribute at " + (now.format(formatter)));
		session.setAttribute("sessionAttr", "Session Attribute at " + (now.format(formatter)));

		// Add attributes to the model
		model.addAttribute("requestAttr", request.getAttribute("requestAttr"));
		model.addAttribute("sessionAttr", session.getAttribute("sessionAttr"));
		return "home";
	}

	@RequestMapping("/2")
	public String home2(HttpServletRequest request, HttpSession session, Model model) {
		// Add attributes to the model
		model.addAttribute("requestAttr", request.getAttribute("requestAttr"));
		model.addAttribute("sessionAttr", session.getAttribute("sessionAttr"));
		return "home2";
	}

	// Franco:
	// 1. http://localhost:8080/
	// 2. http://localhost:8080/2
}
