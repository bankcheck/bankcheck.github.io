package com.systematic;

import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class FrancoRestController {
	@RequestMapping("/students/{studentName}")
	public String students(@PathVariable("studentName") String francoStudentName) {
		return "Hello " + francoStudentName;
	}
}
