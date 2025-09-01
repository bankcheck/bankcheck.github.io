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
	public SecurityFilterChain securityFilterChain(HttpSecurity httpSecurity) throws Exception {
		// Allow access to root and static content
		httpSecurity.authorizeHttpRequests(authorize -> authorize
				// Allow access to login and home
				.requestMatchers("/login", "/").permitAll()
				// Protect /secret
				.requestMatchers("/secret").authenticated()
				// All other requests require authentication
				.anyRequest().authenticated())
				// Custom login page
				.formLogin(form -> form.loginPage("/login").permitAll())
				// Redirect to home page after logout
				.logout(logout -> logout.logoutSuccessUrl("/").permitAll());
		return httpSecurity.build();
	}
}
