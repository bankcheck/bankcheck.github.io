package com.systematic;

import java.util.ArrayList;
import java.util.List;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.thymeleaf.context.LazyContextVariable;

class FrancoStudent {
	public FrancoStudent(String studentName) {
		super();
		this.studentName = studentName;
	}

	private String studentName;

	public String getStudentName() {
		return studentName;
	}

	public void setStudentName(String studentName) {
		this.studentName = studentName;
	}

	@Override
	public String toString() {
		return "FrancoStudent [studentName=" + studentName + "]";
	}
}

@SpringBootApplication
@Controller
public class FrancoStringBootApp {
	public static void main(String[] args) {
		SpringApplication.run(FrancoStringBootApp.class, args);
	}

	@RequestMapping("/")
	public String home(Model model) {
		model.addAttribute("francoStudents", new LazyContextVariable<Object>() {
			@Override
			protected Object loadValue() {
				return getFrancoStudents();
			}
		});
		// model.addAttribute("show", false);
		model.addAttribute("show", true);

		return "home";
	}

	static List<FrancoStudent> getFrancoStudents() {
		List<FrancoStudent> francoStudents = new ArrayList<FrancoStudent>();
		francoStudents.add(new FrancoStudent("Franco"));
		francoStudents.add(new FrancoStudent("Jane"));
		return francoStudents;
	}
}
