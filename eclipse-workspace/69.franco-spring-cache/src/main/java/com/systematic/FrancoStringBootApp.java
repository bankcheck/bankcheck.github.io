package com.systematic;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
@EnableCaching
public class FrancoStringBootApp {
	public static void main(String[] args) {
		SpringApplication.run(FrancoStringBootApp.class, args);
	}

	@Autowired
	private FrancoCalculationService francoCalculationService;

	@GetMapping("/francocalculate")
	public String calculate(@RequestParam int number) {
		int result = francoCalculationService.francoSlowCalculation(number);
		return "Result: " + result;
	}
	
	@GetMapping("/franco-clear-cache")
	public String clearCache() {
		francoCalculationService.clearCache();
		return "Cache cleared!";
	}
}
