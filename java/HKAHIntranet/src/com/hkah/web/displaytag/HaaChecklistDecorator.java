package com.hkah.web.displaytag;

import java.util.Date;

import org.displaytag.decorator.TableDecorator;

import com.hkah.util.DateTimeUtil;
import com.hkah.web.db.hibernate.HaaChecklist;

public class HaaChecklistDecorator extends TableDecorator {
	
	public String getContractDate() {
		HaaChecklist haaChecklist = (HaaChecklist) getCurrentRowObject(); 
		
		Date dateFrom = haaChecklist.getHaaContractDateFrom();
		Date dateTo = haaChecklist.getHaaContractDateTo();
		
		String dateFromStr = "";
		String dateToStr = "";
		if (dateFrom != null) {
			dateFromStr = DateTimeUtil.formatDate(haaChecklist.getHaaContractDateFrom());
		}
		if (dateTo != null) {
			dateToStr = DateTimeUtil.formatDate(haaChecklist.getHaaContractDateTo());
		}
		
		return dateFromStr + " - " + dateToStr;
	}
	
	public String getStatus() {
		HaaChecklist haaChecklist = (HaaChecklist)getCurrentRowObject(); 
		
		String enabled = "";
		switch (haaChecklist.getHaaEnabled()) {
			case 0:
				enabled = "Deleted";
				break;
			case 1:
				enabled = "Normal";
				break;
			case 2:
				enabled = "Archive";
				break;
			default:
				enabled = "";
				break;
		}
		return enabled;
	}
}
