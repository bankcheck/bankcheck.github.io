package com.systematic;

import java.util.ArrayList;
import java.util.List;

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
	public String home(Model model) {
		model.addAttribute("francoStudent", new FrancoStudent("Jane", "Female"));
		List<String> genders = new ArrayList<String>();
		genders.add("Male");
		genders.add("Female");
		model.addAttribute("gendersInController", genders);
		return "index";
	}
}
