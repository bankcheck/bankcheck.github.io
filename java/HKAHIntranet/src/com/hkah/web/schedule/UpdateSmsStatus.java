package com.hkah.web.schedule;

import java.io.IOException;
import java.util.Calendar;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.sms.UtilSMS;
import com.hkah.web.db.EmailAlertDB;

public class UpdateSmsStatus implements Job  {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		try {
			Calendar currentCal = Calendar.getInstance();

			EmailAlertDB.sendEmail("sms.alert",
					"Hong Kong Adventist Hospital - UPDATE SMS STATUS",
					"UPDATE STATUS START - " + currentCal.getTime());

			// for HKAH only
			if (ConstantsServerSide.isHKAH()) {
				UtilSMS.updateSmsStatus(UtilSMS.SMS_INPAT, null);
				UtilSMS.updateSmsStatus(UtilSMS.SMS_OUTPAT, null);
				UtilSMS.updateSmsStatus(UtilSMS.SMS_LMC, null);
				UtilSMS.updateSmsStatus(UtilSMS.SMS_FOUNDATION, null);
				UtilSMS.updateSmsStatus(UtilSMS.SMS_ONCOLOGY, null);
				UtilSMS.updateSmsStatus(UtilSMS.SMS_DENTAL, null);
				UtilSMS.updateSmsStatus(UtilSMS.SMS_REHAB, null);
				//UtilSMS.updateSmsStatus(UtilSMS.SMS_FOODSERVICE, null);
				UtilSMS.updateSmsStatus(UtilSMS.SMS_HA, null);
			}

			// for TWAH only
			if (ConstantsServerSide.isTWAH()) {
				UtilSMS.updateSmsStatus(UtilSMS.SMS_OT, null);
				UtilSMS.updateSmsStatus(UtilSMS.SMS_INPAT_DOCNUM, null);
				UtilSMS.updateSmsStatus(UtilSMS.SMS_TWWC, null);
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
}