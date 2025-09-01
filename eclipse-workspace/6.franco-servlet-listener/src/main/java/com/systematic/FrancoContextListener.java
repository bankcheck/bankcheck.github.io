package com.systematic;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

@WebListener
public class FrancoContextListener implements ServletContextListener {
	public void contextInitialized(ServletContextEvent sce) {
		System.out.println("Context Initialized / Application started");
	}

	public void contextDestroyed(ServletContextEvent sce) {
		System.out.println("Context Destroyed / Application stopped");
	}
}