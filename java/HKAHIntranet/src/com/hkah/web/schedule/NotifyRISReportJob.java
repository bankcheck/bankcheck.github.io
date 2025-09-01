package com.hkah.web.schedule;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.web.db.RISDB;


public class NotifyRISReportJob implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		RISDB.sendRISEmails();
	}
}