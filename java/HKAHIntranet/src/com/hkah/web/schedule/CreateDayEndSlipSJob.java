package com.hkah.web.schedule;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.util.db.UtilDBWeb;

public class CreateDayEndSlipSJob implements Job  {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		try {
			DateFormat dateFormat = new SimpleDateFormat("dd/MM/yyyy");
			//get current date time with Date()
			Date date = new Date();
			System.out.println(dateFormat.format(date));
	  
			//get current date time with Calendar()
			Calendar cal = Calendar.getInstance();
//			if (ConstantsServerSide.SECURE_SERVER) {
				cal.add(Calendar.DATE, 1);			
//			}
			String printDate = dateFormat.format(cal.getTime()); 
			System.out.println("[printDate]:"+printDate);
			   
			String successCreate = UtilDBWeb.callFunction(
					"NHS_ACT_GENALLPATLETTER",
					null,
					new String[] {					
							printDate
					});
			
			System.out.println("[successCreate]:"+successCreate);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}