package com.hkah.web.schedule;

import java.util.ArrayList;

import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.PatientDB;

public class UpdatePatientAllergyJob implements Job  {

	//======================================================================
	private static Logger logger = Logger.getLogger(UpdatePatientAllergyJob.class);

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT WRDCODE FROM HAT_PATIENT_ALLERGY WHERE PATNO ='0' AND UPDATED = 1 AND ROWNUM = 1 ");

		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());
		if (record.size() <= 0) {
			UtilDBWeb.updateQueue("UPDATE HAT_PATIENT_ALLERGY SET UPDATED = 1 WHERE PATNO ='0' ");
			record = UtilDBWeb.getReportableList(sqlStr.toString());
		}

		ArrayList wrdCode = new ArrayList();

//		System.out.println(new Date()+" [Allergy] Starting the Schedule.....");

		if (record.size() > 0) {
			ReportableListObject row = null;
			row = (ReportableListObject) record.get(0);

			UtilDBWeb.updateQueue("UPDATE HAT_PATIENT_ALLERGY SET UPDATED = 0 WHERE PATNO ='0' AND WRDCODE = '"+row.getValue(0)+"' ");
			PatientDB.updateInpatAllergy(row.getValue(0));
		}

//		System.out.println(new Date()+" [Allergy] Terminating the Schedule.....");

		logger.info("Thread UpdatePatientAllergyThread updated");
	}
}