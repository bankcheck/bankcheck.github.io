package com.hkah.server.servlet;

import javax.servlet.http.HttpServlet;

import org.apache.log4j.Logger;

import com.hkah.server.schedule.CronScheduler;

public class JobSchedulerServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private static Logger logger = Logger.getLogger(JobSchedulerServlet.class);

	@Override
	public void init() throws javax.servlet.ServletException {
		new CronScheduler();
		logger.info("NHS Initialize quartz schedule job");
	}

	@Override
	public void destroy() {
		// do something before stop application
		super.destroy();
	}
}