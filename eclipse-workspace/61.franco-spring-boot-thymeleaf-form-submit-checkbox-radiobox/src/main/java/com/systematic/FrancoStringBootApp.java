package com.systematic;

import java.util.Arrays;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;

@SpringBootApplication
@Controller
public class FrancoStringBootApp {
	public static void main(String[] args) {
		SpringApplication.run(FrancoStringBootApp.class, args);
	}

	private void setConstant(Model model) {
		String[] gendersInController = new String[] { "Male", "Female" };
		String[] colorsInController = new String[] { "Purple", "Green", "Red" };
		model.addAttribute("gendersInController", gendersInController);
		model.addAttribute("colorsInController", colorsInController);
	}

	@GetMapping("/")
	public String home(Model model) {
		setConstant(model);
		FrancoStudent francoStudent = new FrancoStudent();
		francoStudent.setStudentNameInClass("Jane");
		francoStudent.setGenderInClass("Male");
		francoStudent.setLikeColorsInClass(new String[] { "Purple", "Green" });
		model.addAttribute("francoStudent", francoStudent);
		return "index";
	}

	@PostMapping("/submit")
	public String submit(@ModelAttribute FrancoStudent francoStudent, Model model) {
		setConstant(model);
		model.addAttribute("francoStudent", francoStudent);
		System.out.println("gender：" + francoStudent.getGenderInClass());
		System.out.println("likeColors：" + Arrays.toString(francoStudent.getLikeColorsInClass()));
		return "submit";
	}
}
