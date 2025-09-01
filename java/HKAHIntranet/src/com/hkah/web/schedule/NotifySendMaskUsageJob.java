package com.hkah.web.schedule;

import java.util.ArrayList;
import java.util.Vector;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.config.MessageResources;
import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.EmailAlertDB;
import com.hkah.web.db.FsDB;
import com.hkah.web.db.StaffDB;
import com.hkah.web.db.UserDB;

public class NotifySendMaskUsageJob implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		StringBuffer sqlStr = new StringBuffer();
		String serverSiteCode = ConstantsServerSide.SITE_CODE;
		boolean sendMailSuccess = false;
		StringBuffer commentStr = null;
		String topic = null;
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat dateFmt = new SimpleDateFormat("yyyyMMdd");
		
		cal.add(Calendar.DATE, -3);
		String prev4Date = dateFmt.format(cal.getTime());
		
		cal = Calendar.getInstance();
		cal.add(Calendar.DATE, -1);
		String prev1Date = dateFmt.format(cal.getTime());
        System.out.println("[prev4Date]:"+prev4Date+";[prev1Date]"+prev1Date);
		
		
		// append url
		commentStr = new StringBuffer();
		topic = "Mask usage From: "+prev4Date+" TO:"+prev1Date;

		if ("hkah".equals(serverSiteCode)) {					
			commentStr.append("<br>Please click <a href=\'http://www-server/intranet/epo/maskUsageList.jsp?fromDate="+prev4Date+"&toDate="+prev1Date);
			commentStr.append("\'><font size='6'>VIEW</font></a>");
		} else if ("twah".equals(serverSiteCode)) {
			commentStr.append("<br>Please click <a href=\'http://192.168.0.20/intranet/epo/maskUsageList.jsp?fromDate="+prev4Date+"&toDate="+prev1Date);
			commentStr.append("\'><font size='6'>VIEW</font></a>");
		}				

		EmailAlertDB.sendEmail("mask.usage", topic, commentStr.toString());
	}
}