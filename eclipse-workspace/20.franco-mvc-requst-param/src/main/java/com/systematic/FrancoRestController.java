package com.systematic;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class FrancoRestController {
	@RequestMapping(value = "/login")
	public String login(@RequestParam String userName) {
		return "Hello " + userName;
		// Open 20.franco-mvc-requst-param.html
	}
}
