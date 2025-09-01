package com.hkah.web.schedule;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.web.db.RadiSharingChecking;

public class VerifyRisReportJob implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		RadiSharingChecking.checkRptMsg(null, null, true);
		RadiSharingChecking.checkRisReportMsg(true);
	}
}
