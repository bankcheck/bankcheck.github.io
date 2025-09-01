package com.systematic;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

public interface FrancoStudentRepository extends JpaRepository<FrancoStudent, Long> {
	List<FrancoStudent> findByNameContaining(String name);
}
