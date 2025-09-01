package com.systematic;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
public class FrancoController {
	@RequestMapping(value = "/controller-hello")
	@ResponseBody
	public String hello() {
		return "Controller-Hello";
	}
}
