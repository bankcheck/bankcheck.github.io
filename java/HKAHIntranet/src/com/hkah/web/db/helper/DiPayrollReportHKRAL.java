package com.hkah.web.db.helper;

import java.util.LinkedHashMap;
import java.util.Map;

public class DiPayrollReportHKRAL extends DiPayrollReport {
	private static Map<String, String> servcdes = new LinkedHashMap<String, String>();
	static {
		servcdes.put("CT", "CT:22.5%");
		servcdes.put("JB", "JB:22.5%");
		servcdes.put("JP", "JP (Pet CT):20%");		
		servcdes.put("MR", "MRI:22.5%");
		servcdes.put("NU", "NM:25%");
		//servcdes.put("PS", "Pet Scan:20%");
		servcdes.put("RA", "Radiology:22.5%");
		servcdes.put("US", "US:30%");
	}
	
	private static Map<String, String> slptypes = new LinkedHashMap<String, String>();
	static {
		slptypes.put("D", "Day Case");
		slptypes.put("I", "In-patient");
		slptypes.put("O", "Out-patient");
	}
	
	public static Map<String, String> payrollRpttypeHeaders = new LinkedHashMap<String, String>();
	static {
		payrollRpttypeHeaders.put("BF", "Brought Forward Outstanding AND %radPayReportMthStr% Revenue");
		payrollRpttypeHeaders.put("IC:NetAmt", "Received Hospital Income for the Month %radPayReportMthStr%");
		payrollRpttypeHeaders.put("IC:Comm", "Card Commission for the Month %radPayReportMthStr%");
		payrollRpttypeHeaders.put("IC:DRPAY", "Fee Splitting to RAL for the Month %radPayReportMthStr%");
		payrollRpttypeHeaders.put("CF", "Outstanding for the Month %radPayReportMthStr%");
	}

	public DiPayrollReportHKRAL() {
		super(servcdes, slptypes, payrollRpttypeHeaders, null);
	}
}
