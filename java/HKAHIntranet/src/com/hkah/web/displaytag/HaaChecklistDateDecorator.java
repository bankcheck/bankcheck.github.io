package com.hkah.web.displaytag;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.displaytag.decorator.TableDecorator;

import com.hkah.web.db.hibernate.HaaChecklistDate;

public class HaaChecklistDateDecorator extends TableDecorator {
	
	public String getInitDate() {
		HaaChecklistDate haaChecklistDate = (HaaChecklistDate)getCurrentRowObject(); 
		
		Date intiDate = haaChecklistDate.getHaaInitDate();
		
		String intiDateStr = "";
		if (intiDate != null) {
			intiDateStr = (new SimpleDateFormat("dd/MM/yyyy")).format(intiDate);
		}
		
		return intiDateStr;
	}
	
	public String getCmpltDate() {
		HaaChecklistDate haaChecklistDate = (HaaChecklistDate)getCurrentRowObject(); 
		
		Date cmltDate = haaChecklistDate.getHaaCmpltDate();
		
		String cmltDateStr = "";
		if (cmltDate != null) {
			cmltDateStr = (new SimpleDateFormat("dd/MM/yyyy")).format(cmltDate);
		}
		
		return cmltDateStr;
	}
}
