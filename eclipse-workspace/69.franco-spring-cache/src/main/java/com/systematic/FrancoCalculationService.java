package com.systematic;

import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;

@Service
public class FrancoCalculationService {
	@Cacheable("calculations")
	public int francoSlowCalculation(int number) {
		try {
			Thread.sleep(3000); // Simulate slow calculation
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		return number * number; // Return the square of the number
	}

	@CacheEvict(value = "calculations", allEntries = true)
	public void clearCache() {
		// Method to clear the cache
	}
}
