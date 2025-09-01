package com.systematic;

import java.util.List;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class FrancoSpringDataApp {
	public static void main(String[] args) {
		SpringApplication.run(FrancoSpringDataApp.class, args);
	}

	@Autowired
	private FrancoStudentRepository francoStudentRepository;

	// Get all data
	@GetMapping(value = "/", produces = MediaType.APPLICATION_JSON_VALUE)
	public List<FrancoStudent> getAllUsers() {
		return francoStudentRepository.findAll();
	}

	// Get data by id
	@GetMapping(value = "/get/{id}", produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<?> getUserById(@PathVariable Long id) {

		Optional<FrancoStudent> studentOptional = francoStudentRepository.findById(id);

		if (studentOptional.isPresent()) {
			return ResponseEntity.ok(studentOptional.get()); // Return the found student
		} else {
			return ResponseEntity.status(404).body("No student found with ID: " + id); // Custom message for not found
		}
	}

	// Get data by name
	@GetMapping(value = "/getByName/{name}", produces = MediaType.APPLICATION_JSON_VALUE)
	public ResponseEntity<?> getStudentsByName(@PathVariable String name) {
		List<FrancoStudent> students = francoStudentRepository.findByNameContaining(name);

		if (!students.isEmpty()) {
			return ResponseEntity.ok(students); // Return the list of found students
		} else {
			return ResponseEntity.status(404).body("No students found with name containing: " + name); // Custom message
																										// for not found
		}
	}

	// Insert data
	@GetMapping("/add/{name}")
	public String addStudent(@PathVariable String name) {
		FrancoStudent francoStudent = new FrancoStudent();
		francoStudent.setName(name);
		francoStudentRepository.save(francoStudent);
		return "Franco Studnet added: " + name;
	}

	// Update data
	@GetMapping("/update/{id}/{name}")
	public ResponseEntity<String> updateStudent(@PathVariable Long id, @PathVariable String name) {
		return francoStudentRepository.findById(id).map(francoStudent -> {
			francoStudent.setName(name);
			francoStudentRepository.save(francoStudent);
			return ResponseEntity.ok("User updated: " + name);
		}).orElse(ResponseEntity.status(404).body("No student found with ID: " + id));
	}

	// Delete User
	@GetMapping("/delete/{id}")
	public ResponseEntity<String> deleteStudent(@PathVariable Long id) {
		return francoStudentRepository.findById(id).map(francoStudent -> {
			francoStudentRepository.delete(francoStudent);
			return ResponseEntity.ok("User deleted: " + francoStudent.getName());
		}).orElse(ResponseEntity.status(404).body("No student found with ID: " + id));
	}
}
