package com.hkah.web.db.helper;

import java.util.LinkedHashMap;
import java.util.Map;

public class DiPayrollReportHK1325 extends DiPayrollReport {
	private static Map<String, String> servcdes = new LinkedHashMap<String, String>();
	static {
		servcdes.put("CT", "CT:20%");
		servcdes.put("JB", "JB:-");
		servcdes.put("JP", "JP (Pet CT):20%");
		servcdes.put("MR", "MRI:20%");
		servcdes.put("NU", "NM:25%");
		//servcdes.put("PS", "Pet Scan:20%");
		servcdes.put("RA", "Radiology:20%");
		servcdes.put("US", "US:20%");
	}
	
	private static Map<String, String> slptypes = new LinkedHashMap<String, String>();
	static {
		slptypes.put("I", "In-patient");
		slptypes.put("O", "Out-patient");
	}
	
	public static Map<String, String> payrollRpttypeHeaders = new LinkedHashMap<String, String>();
	static {
		payrollRpttypeHeaders.put("BF", "Outstanding Revenue Brought Forward Before Radiologist Payment");
		payrollRpttypeHeaders.put("IC:NetAmt", "Revenue to Calculate for the Radiologist Payment for Paid Examinations / Procedure as of");
		payrollRpttypeHeaders.put("IC:Comm", "Card Commission as of");
		payrollRpttypeHeaders.put("IC:DRPAY", "Radiologist Payment for Paid Examinations / Procedure as of");
		payrollRpttypeHeaders.put("CF", "Outstanding Revenue Carried Forward (To Be Calculated in Later Months)");
	}

	public DiPayrollReportHK1325() {
		super(servcdes, slptypes, payrollRpttypeHeaders, null);
	}
}
