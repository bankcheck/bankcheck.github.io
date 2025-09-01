package com.systematic;

import java.util.Map;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

@RestController
@ResponseBody
public class FrancoRestController {
	@RequestMapping(value = "/login")
	public String login(@RequestParam Map<String, String> values) {
		return String.format("userName: %s, password: %s", values.get("userName"), values.get("password"));
		// 21.franco-mvc-requst-param-multiple
	}
}
