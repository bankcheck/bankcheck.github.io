package com.systematic;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class FrancoRestController {
	@RequestMapping(value = "restcontroller-hello")
	public String hello() {
		return "RestController Hello";
	}
}
