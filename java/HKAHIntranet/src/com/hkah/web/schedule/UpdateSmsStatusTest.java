package com.hkah.web.schedule;

import java.io.IOException;
import java.util.Calendar;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.util.sms.UtilSMS;
import com.hkah.web.db.EmailAlertDB;

public class UpdateSmsStatusTest implements Job  {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		try {
			Calendar currentCal = Calendar.getInstance();

			EmailAlertDB.sendEmail("sms.alert",
					"[DEV] Hong Kong Adventist Hospital - UPDATE SMS STATUS (SMS_DENTAL)",
					"UPDATE STATUS START - " + currentCal.getTime());
/*
			UtilSMS.updateSmsStatus(UtilSMS.SMS_INPAT, null);
			UtilSMS.updateSmsStatus(UtilSMS.SMS_OUTPAT, null);
			UtilSMS.updateSmsStatus(UtilSMS.SMS_LMC, null);
			UtilSMS.updateSmsStatus(UtilSMS.SMS_FOUNDATION, null);
			UtilSMS.updateSmsStatus(UtilSMS.SMS_ONCOLOGY, null);
*/
			UtilSMS.updateSmsStatus(UtilSMS.SMS_DENTAL, null);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}