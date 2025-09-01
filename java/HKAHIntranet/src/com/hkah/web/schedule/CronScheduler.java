package com.hkah.web.schedule;

import java.util.ArrayList;

import org.apache.log4j.Logger;
import org.quartz.CronTrigger;
import org.quartz.JobDetail;
import org.quartz.Scheduler;
import org.quartz.SchedulerFactory;
import org.quartz.impl.StdSchedulerFactory;

import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;

public class CronScheduler {
	private static final String JOB_VALUE = "Job";
	private static Logger logger = Logger.getLogger(CronScheduler.class);
	private static String sqlStr_getSchedule = null;

	public CronScheduler(String serverType) {
		try {
			SchedulerFactory sf = new StdSchedulerFactory();
			Scheduler sche = sf.getScheduler();
			sche.start();

			/***************************************************************************
			 * JobDetail
			 **************************************************************************/

			JobDetail jobDetail = null;

			// Scheduling example
			//"0 0 12 * * ?" Fire at 12pm (noon) every day
			//"0/2 * * * * ?" Fire at every 2 seconds every day
			//
			// see official document for detail:
			// http://www.quartz-scheduler.org/docs/tutorial/TutorialLesson06.html

			/***************************************************************************
			 * CronTrigger
			 **************************************************************************/

			CronTrigger jobTrigger = null;

			/***************************************************************************
			 * scheduleJob
			 **************************************************************************/

			ClassLoader classLoader = CronScheduler.class.getClassLoader();

			ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr_getSchedule, new String[] { serverType });
			ReportableListObject row = null;
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				try {
					
					jobDetail = new JobDetail(row.getFields0(), JOB_VALUE, classLoader.loadClass(row.getFields1()));
					jobTrigger = new CronTrigger(row.getFields0(), JOB_VALUE, row.getFields2());
					sche.scheduleJob(jobDetail, jobTrigger);

					logger.info("CronScheduler create schedule task for " + row.getFields0() + " successfully.");
				} catch (Exception e) {
					logger.info("CronScheduler fail to create schedule task for " + row.getFields0() + ".");
					e.printStackTrace();
				}
			}

			logger.info("CronScheduler start up successful.");
		} catch (Exception ex) {
			ex.printStackTrace();
			logger.error("CronScheduler start up fail.");
		}
	}

	static {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.setLength(0);
		sqlStr.append("SELECT CO_JOB_NAME, CO_JOB_CLASS, CO_CRON_EXPRESSION ");
		sqlStr.append("FROM   CO_SCHEDULE_SERVER ");
		sqlStr.append("WHERE  CO_ENABLED = '1' ");
		sqlStr.append("AND    CO_SCHEDULE_TYPE = ? ");
		sqlStr.append("ORDER BY CO_SCHEDULE_ID ");
		sqlStr_getSchedule = sqlStr.toString();
	}
}