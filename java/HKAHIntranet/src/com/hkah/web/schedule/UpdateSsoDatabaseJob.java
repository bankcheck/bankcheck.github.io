package com.hkah.web.schedule;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.web.db.SsoUserDB;

public class UpdateSsoDatabaseJob implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		SsoUserDB.getAllUserFromMasterSystem(); // update sso user
	}
}