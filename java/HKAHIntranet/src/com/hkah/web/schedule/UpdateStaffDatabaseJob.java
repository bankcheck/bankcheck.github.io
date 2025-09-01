package com.hkah.web.schedule;

import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.web.db.HelpDeskDB;
import com.hkah.web.db.ScheduleDB;
import com.hkah.web.db.StaffDB;

public class UpdateStaffDatabaseJob implements Job {

	//======================================================================
	private static Logger logger = Logger.getLogger(UpdateStaffDatabaseJob.class);

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		StaffDB.update();
		logger.info("Thread UpdateStaffDatabaseThread StaffList updated");
		ScheduleDB.expire("education", "SYSTEM");
//		logger.info("Thread UpdateStaffDatabaseThread Schedule expired");
		
		// syn HelpDesk user
		if (ConstantsServerSide.isTWAH() || ConstantsServerSide.isHKAH()) {
			HelpDeskDB.synchronizePortalUser();
			HelpDeskDB.synchronizePortalPassword();
			logger.info("Thread UpdateStaffDatabaseThread HelpDesk all user password syn");
		}
	}
}