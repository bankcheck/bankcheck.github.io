package com.hkah.web.displaytag;

import java.util.Date;

import org.displaytag.decorator.TableDecorator;

import com.hkah.util.DateTimeUtil;
import com.hkah.web.db.hibernate.MpaMeeting;

public class MpaMeetingDecorator extends TableDecorator {
	
	public String getDate() {
		MpaMeeting mpaMeeting = (MpaMeeting)getCurrentRowObject(); 
		
		Date date = mpaMeeting.getDate();
		
		String dateStr = "";
		if (date != null) {
			dateStr = DateTimeUtil.formatDate(date);
		}
		
		return dateStr;
	}
}
