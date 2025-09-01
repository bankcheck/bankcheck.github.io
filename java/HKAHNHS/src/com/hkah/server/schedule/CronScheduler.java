package com.hkah.server.schedule;

import org.apache.log4j.Logger;
import org.quartz.Scheduler;
import org.quartz.SchedulerFactory;
import org.quartz.impl.StdSchedulerFactory;

public class CronScheduler {
	private static Logger logger = Logger.getLogger(CronScheduler.class);
	
	public CronScheduler() {
		try {
			SchedulerFactory sf = new StdSchedulerFactory();
	        Scheduler sche = sf.getScheduler();
	        
	        // JobDetail
	        /*
	        JobDetail ehrAlertJobD = newJob(EhrAlertJob.class)
	        		.withIdentity("job1", "group1")
	        		.build(); 
	        		*/

	        // CronTrigger
	        /*
	        CronTrigger ehrAlertTrigger = newTrigger()
	        		.withIdentity("trigger1", "group1")
	        		.withSchedule(cronSchedule("0 0/1 * * * ?"))	// every minutes
	        		.forJob("job1", "group1")
	        		.build();
	        */
	        
	        // Schedule
	        //sche.scheduleJob(ehrAlertJobD, ehrAlertTrigger);
	        
	        sche.start();
		} catch (Exception ex) {
			ex.printStackTrace();
			logger.error("NHS CronScheduler start up fail.");
		}
	}
}