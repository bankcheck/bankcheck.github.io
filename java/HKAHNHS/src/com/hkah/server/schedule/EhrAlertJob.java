package com.hkah.server.schedule;

import java.util.Date;

import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.server.util.QueryUtil;
import com.hkah.shared.model.MessageQueue;

public class EhrAlertJob implements Job {
	protected static Logger logger = Logger.getLogger(EhrAlertJob.class);
	public static final String EHR_PMI_ALERT_CODE = "EHRPMIALT";

	@Override
	public void execute(JobExecutionContext context) throws JobExecutionException {
		logger.debug("Job EhrAlertJob execute: job key= " + context.getJobDetail().getKey() + " executing at " + new Date());
		ehrPmiAlert();
	}

	private void ehrPmiAlert() {
		// get PATEHRHIST records
		MessageQueue mq = QueryUtil.proceedTx(null, "NHS", "LOOKUP", QueryUtil.getMasterServlet(),
				"GET", new String[]{"SYSPARAM", "PARAM1, PARAM2", "PARCDE = '" + EHR_PMI_ALERT_CODE + "'"}, null, new String[0][0]);
		if (mq.success()) {
			String lastAlert = mq.getContentField()[0];
			String lastAlertFormat = mq.getContentField()[1];
			logger.debug("Got sysparam EHRPMIALT timestamp = " + lastAlert + " (format: " + lastAlertFormat + ")");

			// get EHR_PMIHIST history created date > lastAlert

			// set email alert by message types, see AlertServiceImpl.java to send email

			// update sysparam EHRPMIALT to latest alert check timestamp
		} else {
			logger.debug("Cannot get last alert timestamp");
		}
	}
}