package com.hkah.constant;

import java.util.HashMap;
import java.util.Map;

public class ConstantsEhr {
	public final static String SYSPARAM_EHRHEPRWSL = "EHRHEPRWSL";
	public final static String SYSPARAM_EHRPMIWSL = "EHRPMIWSL";
	public final static String SYSPARAM_EHRSAAMWSL = "EHRSAAMWSL";
	public final static String SYSPARAM_EHREPISWSL = "EHREPISWSL";
	public final static String SYSPARAM_EHRAAGWSL = "EHRAAGWSL";
	
	public final static String SYSPARAM_EHRCF_ENC = "EHRCF_ENC";
	public final static String SYSPARAM_EHRENCDLY = "EHRENCDLY";
	
	public final static String SYSPARAM_RIS_REPORT_SOURCE_PATH = "EHRRISSPTH";
	public final static String SYSPARAM_RIS_REPORT_TEMP_PATH = "EHRRISTPTH";

	public final static String SYSPARAM_LIS_REPORT_SOURCE_PATH = "EHRLISSPTH";
	public final static String SYSPARAM_LIS_REPORT_TEMP_PATH = "EHRLISTPTH";
	
	public final static String SYSPARAM_SMB_USERNAME = "EHRSMBUID";	
	public final static String SYSPARAM_SMB_PASSWORD = "EHRSMBPW";
	
	public final static String DOMAIN_CODE_LABGEN = "LABGEN";
	public final static String DOMAIN_CODE_LABMICRO = "LABMB";
	public final static String DOMAIN_CODE_LABAP = "LABAP";
	public final static String DOMAIN_CODE_RADI = "RAD";
	public final static String DOMAIN_CODE_DISP = "RXD";
	public final static String DOMAIN_CODE_ADR = "ADR";
	public final static String DOMAIN_CODE_ALLERGY = "AL1";
	public final static String DOMAIN_CODE_CNS = "CNS";
	public final static String DOMAIN_CODE_BIRTH = "BIRTH";
	public final static String DOMAIN_CODE_ENCTR = "ENCTR";
	public final static String DOMAIN_PMI_NOT_SEND_BLANK_PREFIX = "EHRPMIEPX";
	
	public final static String PMI_INIT_COLNAME_LABGEN = "INITLAB";
	public final static String PMI_INIT_COLNAME_LABMICRO = "INITLABMB";
	public final static String PMI_INIT_COLNAME_LABAP = "INITLABAP";
	public final static String PMI_INIT_COLNAME_RADI = "INITRIS";
	public final static String PMI_INIT_COLNAME_DISP = "INITRXD";
	public final static String PMI_INIT_COLNAME_ADR = "INITADR";
	public final static String PMI_INIT_COLNAME_ALLERGY = "INITALG";
	public final static String PMI_INIT_COLNAME_CNS = "INITCNS";
	public final static String PMI_INIT_COLNAME_BIRTH = "INITBIRTH";
	public final static String PMI_INIT_COLNAME_ENCTR = "INITENCTR";
	
	public final static String UPLOAD_MODE_NAME_BLM = "BL-M";
	public final static String UPLOAD_MODE_NAME_BL = "BL";
	public final static String UPLOAD_MODE_CODE_BLM = "DM";
	public final static String UPLOAD_MODE_CODE_BL = "INC";
	
	public final static String HL7_EVENT_CODE_A08 = "A08";
	public final static String HL7_EVENT_CODE_A28 = "A28";
	public final static String HL7_EVENT_CODE_A29 = "A29";
	public final static String HL7_EVENT_CODE_A45 = "A45";
	public final static String HL7_EVENT_CODE_A47 = "A47";
	
	public final static String HL7_EVENT_CODE_DESC_A08 = "Death";
	public final static String HL7_EVENT_CODE_DESC_A28 = "Build Consent";
	public final static String HL7_EVENT_CODE_DESC_A29 = "Revoke Consent";
	public final static String HL7_EVENT_CODE_DESC_A45 = "Episode Change";
	public final static String HL7_EVENT_CODE_DESC_A47 = "Major Key Change";
	
	public final static String HL7_MATCHING_RESULT_MATCH = "1";
	public final static String HL7_MATCHING_RESULT_NO_PMI_REC = "2";
	public final static String HL7_MATCHING_RESULT_NOT_MATCH = "3";
	public final static String HL7_MATCHING_RESULT_DATA_NOT_MATCH = "4";
	
	public final static String CONSENT_TO_PROVIDER_TYPE_CODE_INDEFINITE = "0";
	public final static String CONSENT_TO_PROVIDER_TYPE_CODE_ONE_YEAR = "1";
	public final static String CONSENT_TO_PROVIDER_TYPE_CODE_EMERGENCY_ACCESS = "2";
	
	public final static String CONSENT_TO_PROVIDER_TYPE_DESC_INDEFINITE = "Indefinite sharing consent";
	public final static String CONSENT_TO_PROVIDER_TYPE_DESC_ONE_YEAR = "One-Year sharing consent";
	public final static String CONSENT_TO_PROVIDER_TYPE_DESC_EMERGENCY_ACCESS = "Emergency Access";
	
	public final static String SOURCE_SYSTEM_PRI_HOSP = "EMR";
	
	// Domain - Birth
	public final static String BIRTH_TRANSACTION_TYPE_INSERT = "I";
	public final static String BIRTH_TRANSACTION_TYPE_UPDATE = "U";
	public final static String BIRTH_TRANSACTION_TYPE_DELETE = "D";
	
	public final static String BIRTH_INSTITUTION_CODE_HKAH_SR = "HKA";
	public final static String BIRTH_INSTITUTION_CODE_HKAH_TW = "TWA";
	public final static String BIRTH_INSTITUTION_DESC_HKAH_SR = "Hong Kong Adventist Hospital";
	public final static String BIRTH_INSTITUTION_DESC_HKAH_TW = "Tsuen Wan Adventist Hospital";
	
	public final static String BIRTH_LOC_CODE_BBA = "BBA";
	public final static String BIRTH_LOC_CODE_BOA = "BOA";
	public final static String BIRTH_LOC_CODE_BIH = "BIH";
	public final static String BIRTH_LOC_DESC_BBA = "Born before arrival";
	public final static String BIRTH_LOC_DESC_BOA = "Born on arrival";
	public final static String BIRTH_LOC_DESC_BIH = "Born in hospital";
	public final static String BIRTH_LOC_LTDESC_BBA = "Born before arriving the hospital";
	public final static String BIRTH_LOC_LTDESC_BOA = "Born on arriving the Accident & Emergency Department";
	public final static String BIRTH_LOC_LTDESC_BIH = "Born in hospital";
	
	public final static Map<String, String> UPLOAD_SUCCESS_CODES = new HashMap<String, String>();
	static {
		UPLOAD_SUCCESS_CODES.put("00000", "Success");
		UPLOAD_SUCCESS_CODES.put("00001", "Success (with error)");
		UPLOAD_SUCCESS_CODES.put("00002", "Success (with warning only)");
	}
	
	public final static Map<String, String> RESP_SUCCESS_CODES = new HashMap<String, String>();
	static {
		RESP_SUCCESS_CODES.put("70000", "Request completed successfully");
	}
	
	public final static Map<String, String> DOMAIN_UPLOAD_BLANK_PATHS = new HashMap<String, String>();
	static {
		DOMAIN_UPLOAD_BLANK_PATHS.put(DOMAIN_CODE_LABGEN, "uploadBlankLabGen");
		DOMAIN_UPLOAD_BLANK_PATHS.put(DOMAIN_CODE_LABAP, "uploadBlankLabAP");
		DOMAIN_UPLOAD_BLANK_PATHS.put(DOMAIN_CODE_LABMICRO, null);
		DOMAIN_UPLOAD_BLANK_PATHS.put(DOMAIN_CODE_RADI, "uploadBlankRad");
		DOMAIN_UPLOAD_BLANK_PATHS.put(DOMAIN_CODE_DISP, "uploadBlankRxd");
		DOMAIN_UPLOAD_BLANK_PATHS.put(DOMAIN_CODE_ADR, "uploadBlankAdr");
		DOMAIN_UPLOAD_BLANK_PATHS.put(DOMAIN_CODE_ALLERGY, "uploadBlankAllergy");
		DOMAIN_UPLOAD_BLANK_PATHS.put(DOMAIN_CODE_CNS, null);
		DOMAIN_UPLOAD_BLANK_PATHS.put(DOMAIN_CODE_BIRTH, "uploadBlankBirth");
		DOMAIN_UPLOAD_BLANK_PATHS.put(DOMAIN_CODE_ENCTR, "uploadBlankEncounter");
	}
}
