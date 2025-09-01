package com.hkah.web.db.helper;

import java.util.LinkedHashMap;
import java.util.Map;

public class DiPayrollReportHKHKRL extends DiPayrollReport {
	private static Map<String, String> servcdes = new LinkedHashMap<String, String>();
	static {
		servcdes.put("CT", "CT:25%");
		servcdes.put("JB", "JB:-");
		servcdes.put("JP", "JP (Pet CT):20%");
		servcdes.put("MR", "MRI:25%");
		servcdes.put("NU", "NM:25%");
		//servcdes.put("PS", "Pet Scan:20%");
		servcdes.put("RA", "Radiology:20%");
		servcdes.put("US", "US:25%");
	}
	
	private static Map<String, String> slptypes = new LinkedHashMap<String, String>();
	static {
		slptypes.put("I", "In-patient");
		slptypes.put("O", "Out-patient");
	}

	public DiPayrollReportHKHKRL() {
		super(servcdes, slptypes);
	}
}
