package com.systematic;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@SpringBootApplication
@Controller
public class FrancoStringBootApp {
	public static void main(String[] args) {
		SpringApplication.run(FrancoStringBootApp.class, args);
	}

	@RequestMapping("/")
	public String home(Model model) {
		model.addAttribute("authorNameFromController", "Franco");
		model.addAttribute("companyNameFromController", "Systematic");
		return "home";
	}
}
