package com.systematic;

import org.springframework.web.bind.annotation.MatrixVariable;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class FrancoRestController {
	@RequestMapping("/students/{studentName}")
	public String students(
			@PathVariable("studentName")String francoStudentName,
			@MatrixVariable String gender,
			@MatrixVariable String grade) {
		return String.format("Hello %s (%s) in grade %s", francoStudentName, gender, grade);
		// http://localhost:8080/students/franco;grade=12;gender=M
		// http://localhost:8080/students/franco;gender=M;grade=12
	}
}
