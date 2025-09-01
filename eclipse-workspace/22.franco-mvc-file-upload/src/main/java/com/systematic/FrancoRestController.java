package com.systematic;

import java.io.IOException;
import java.nio.charset.StandardCharsets;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
public class FrancoRestController {
	@RequestMapping(value = "/upload")
	public String upload(@RequestParam("file") MultipartFile file) throws IOException {
		byte[] fileContent = file.getBytes();
		System.out.println(fileContent);
		System.out.println(new String(fileContent, StandardCharsets.UTF_8));
		return "Success";
		// Open 22.franco-mvc-file-upload then choose a text file.
	}
}
