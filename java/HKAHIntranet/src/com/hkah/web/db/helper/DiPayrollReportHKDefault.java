package com.hkah.web.db.helper;

import java.util.LinkedHashMap;
import java.util.Map;

public class DiPayrollReportHKDefault extends DiPayrollReport {
	private static Map<String, String> servcdes = new LinkedHashMap<String, String>();
	static {
		servcdes.put("CT", "CT");
		servcdes.put("JP", "JP (Pet CT)");
		servcdes.put("MR", "MRI");
		servcdes.put("NU", "NM");
		servcdes.put("PS", "Pet Scan");
		servcdes.put("RA", "Radiology");
		servcdes.put("US", "US");
	}
	
	private static Map<String, String> slptypes = new LinkedHashMap<String, String>();
	static {
		slptypes.put("I", "In-patient");
		slptypes.put("O", "Out-patient");
	}

	public DiPayrollReportHKDefault() {
		super(servcdes, slptypes);
	}
}
