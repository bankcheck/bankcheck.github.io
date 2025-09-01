package com.hkah.web.schedule;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.web.db.StaffDB;

public class NotifySendTerminateStaffJob implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		StaffDB.sendTerminateStaffEmail();
		StaffDB.sendHireStaffEmail();
	}
}