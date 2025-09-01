package com.hkah.web.schedule;

import java.util.Date;

import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class NotifyTestJob implements Job {

	// ======================================================================
	private static Logger logger = Logger.getLogger(NotifyTestJob.class);

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		logger.debug("doAction at " + new Date());
	}
}