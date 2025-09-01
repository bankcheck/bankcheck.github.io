package com.hkah.web.db.helper;

import java.util.LinkedHashMap;
import java.util.Map;

public class DiPayrollReportTW3D extends DiPayrollReport {
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
	
	public static Map<String, String> payrollRpttypeHeaders = new LinkedHashMap<String, String>();
	static {
		payrollRpttypeHeaders.put("BF", "Brought Forward Outstanding AND %radPayReportMthStr% Revenue");
		payrollRpttypeHeaders.put("IC:NetAmt", "Received Hospital Income for the Month %radPayReportMthStr%");
		payrollRpttypeHeaders.put("IC:Comm", "Card Commission for the Month %radPayReportMthStr%");
		payrollRpttypeHeaders.put("IC:DRPAY", "Fee Splitting to 3D for the Month %radPayReportMthStr%");
		payrollRpttypeHeaders.put("CF", "Outstanding for the Month %radPayReportMthStr%");
	}

	public DiPayrollReportTW3D() {
		super(servcdes, slptypes, payrollRpttypeHeaders, null);
	}
}
