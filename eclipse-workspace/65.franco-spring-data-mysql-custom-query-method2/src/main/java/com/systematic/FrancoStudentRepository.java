package com.systematic;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface FrancoStudentRepository extends JpaRepository<FrancoStudent, Long> {
	@Query("SELECT fs FROM FrancoStudent fs WHERE fs.name LIKE %:name%")
    List<FrancoStudent> findByNameContaining(@Param("name") String name);
}
