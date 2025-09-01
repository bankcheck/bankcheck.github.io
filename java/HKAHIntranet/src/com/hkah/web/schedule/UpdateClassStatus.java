package com.hkah.web.schedule;

import java.text.SimpleDateFormat;
import java.util.Calendar;

import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.util.db.UtilDBWeb;

public class UpdateClassStatus implements Job {

	//======================================================================
	private static Logger logger = Logger.getLogger(UpdateClassStatus.class);

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		try {
			StringBuffer sqlStr = new StringBuffer();
			Calendar today = Calendar.getInstance();
			SimpleDateFormat format1 = new SimpleDateFormat("dd-MM-yyyy");

			if (today.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY
					|| today.get(Calendar.DAY_OF_WEEK) == Calendar.SUNDAY) {
				logger.info("Thread UpdateClassThread no updated in SAT and SUN.");
			} else {
		/*		if (currentCal.get(Calendar.DAY_OF_WEEK) == Calendar.MONDAY) {
					currentCal.add(Calendar.DAY_OF_MONTH, +4);
				} else {
					currentCal.add(Calendar.DAY_OF_MONTH, +6);
				}*/
				String cutoffDate = format1.format(today.getTime());

				sqlStr.append("UPDATE CO_SCHEDULE ");
				sqlStr.append("SET CO_SCHEDULE_STATUS = 'close', ");
				sqlStr.append("CO_MODIFIED_DATE = SYSDATE, ");
				sqlStr.append("CO_MODIFIED_USER = 'SYSTEM' ");
				sqlStr.append("WHERE CO_MODULE_CODE = 'education' ");
				sqlStr.append("AND TO_CHAR(CO_SCHEDULE_START, 'DD-MM-YYYY') = '");
				sqlStr.append(cutoffDate);
				sqlStr.append("' ");

				UtilDBWeb.updateQueue(sqlStr.toString());

				logger.info("Thread UpdateClassThread updated");
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}