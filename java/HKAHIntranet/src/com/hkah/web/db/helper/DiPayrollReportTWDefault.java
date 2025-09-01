package com.hkah.web.db.helper;

import java.util.LinkedHashMap;
import java.util.Map;

public class DiPayrollReportTWDefault extends DiPayrollReport {
	private static Map<String, String> servcdes = new LinkedHashMap<String, String>();
	static {
		servcdes.put("MM", "MM");
		servcdes.put("XE", "XE");		
		servcdes.put("XH", "XH");
		servcdes.put("XP", "XP");
		servcdes.put("XR", "XR");
		servcdes.put("XT", "XT");
		servcdes.put("XU", "XU");
	}
	
	private static Map<String, String> slptypes = new LinkedHashMap<String, String>();
	static {
		slptypes.put("I", "In-patient");
		slptypes.put("O", "Out-patient");
	}
	
	public DiPayrollReportTWDefault() {
		super(servcdes, slptypes);
	}
}
