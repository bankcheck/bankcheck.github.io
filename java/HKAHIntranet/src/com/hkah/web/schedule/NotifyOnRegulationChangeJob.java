package com.hkah.web.schedule;

import java.io.File;
import java.util.Calendar;
import java.util.Date;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.util.DateTimeUtil;
import com.hkah.web.db.EmailAlertDB;

public class NotifyOnRegulationChangeJob implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		// defined which document to check
		String fname = "\\\\hkim\\im\\1 HKAH Physician\\2 Intranet Portal\\Ordinance - 100511.working.xls";
		File file = new File(fname);
		StringBuffer message = new StringBuffer();
		Long lastModified = file.lastModified();
		Date lastModifiedDate = new Date(lastModified);
		Calendar compareDate = Calendar.getInstance();
		compareDate.roll(Calendar.MONTH, -4);
		compareDate.set(Calendar.DAY_OF_MONTH,1);
		Date upperDate = compareDate.getTime();
		compareDate = Calendar.getInstance();
		Date curDate = compareDate.getTime();
		String subject = null;
		if (lastModifiedDate.after(upperDate)&& lastModifiedDate.before(curDate)) {
			message.append("Ordinance updated on: "+DateTimeUtil.formatDate(lastModifiedDate));
			subject = "Test - Ordinance updated";
		} else {
			message.append("Ordinance was not updated in the period of  "+DateTimeUtil.formatDate(upperDate)+" and "+DateTimeUtil.formatDate(curDate)+"<br>");
			message.append("The last update is on"+DateTimeUtil.formatDate(lastModifiedDate));
			subject = "Test - Ordinance has no update";
		}

		EmailAlertDB.sendEmail("ordinance.update", subject, message.toString());
	}
}