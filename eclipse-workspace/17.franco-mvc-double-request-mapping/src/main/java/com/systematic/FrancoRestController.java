package com.systematic;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/students")
public class FrancoRestController {
	@RequestMapping("/franco")
	public String franco() {
		return "Franco";
	}

	@RequestMapping("/jane")
	public String jane() {
		return "Jane";
	}
}
