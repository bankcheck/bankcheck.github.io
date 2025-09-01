package com.systematic;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.core.userdetails.User;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.provisioning.InMemoryUserDetailsManager;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;

@Configuration
public class FrancoSecurityConfig {
	@Bean
	public PasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}

	@Bean
	public UserDetailsService userDetailsService() {
		InMemoryUserDetailsManager manager = new InMemoryUserDetailsManager();
		UserDetails user1 = User.withUsername("franco").password(passwordEncoder().encode("12345"))
				.roles("role1", "role2").build();
		UserDetails user2 = User.withUsername("jane").password(passwordEncoder().encode("12345")).roles("role2")
				.build();

		manager.createUser(user1);
		manager.createUser(user2);
		return manager;
	}

	@Bean
	public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
		// Allow access to root and static content
		http.authorizeHttpRequests((authorize) -> authorize.requestMatchers("/", "*.txt").permitAll()
				.requestMatchers("/secret1/**").hasRole("role1") // Restrict access to admin pages
				.anyRequest().authenticated() // All other requests require authentication
		).formLogin(form -> form.permitAll() // Enable form-based login
		).logout(logout -> logout.permitAll());
		return http.build();
	}
}
