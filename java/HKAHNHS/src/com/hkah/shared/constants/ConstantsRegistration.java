package com.hkah.shared.constants;

public interface ConstantsRegistration {

	// Current Registration Mode
	public final static String REG_INPATIENT = "I";
	public final static String REG_DAYCASE = "D";
	public final static String REG_NORMAL = "O";
	public final static String REG_WALKIN = "W";
	public final static String REG_PRIORITY = "P";
	public final static String REG_URGENTCARE = "U";
	public final static String REG_NOTHING = "N";

	public final static String REG_TYPE_INPATIENT = "I";
	public final static String REG_TYPE_OUTPATIENT = "O";
	public final static String REG_TYPE_DAYCASE = "D";
	public final static String REG_TYPE_CANCEL = "C";

	public final static String REG_CAT_NORMAL = "N";
	public final static String REG_CAT_WALKIN = "W";
	public final static String REG_CAT_PRIORITY = "P";
	public final static String REG_CAT_URGENTCARE = "U";
	
	public final static String DOCLOCTION_WELLBABY = "WB";

	public final static String REG_DISPLAY_NORMAL = "Normal";
	public final static String REG_DISPLAY_WALKIN = "Walk-In";
	public final static String REG_DISPLAY_PRIORITY = "Priority";
	public final static String REG_DISPLAY_URGENTCARE = "Urgent-Care";

	public final static String REG_STS_NORMAL = "N";
	public final static String REG_STS_CANCEL = "C";

	// Current Operation Mode (Patient)
	public final static String REG_MODE_SEARCH = "0";
	public final static String REG_MODE_EDIT = "1";
	public final static String REG_MODE_ADDNEW = "2";

	// BedCheckStatus
	public final static String BED_OK = "0";
	public final static String BED_NOT_AVAILABLE = "1";
	public final static String BED_WRONG_SEX = "2";
	public final static String BED_NOT_CLEAN = "3";

	public final static String DOCHIST_NOCHANGE = "N";
	public final static String DOCHIST_CHANGED = "C";

	public final static String BED_STS_FREE = "F";
	public final static String BED_STS_OCCUPY = "O";

	public final static String gNEXTPATNO = "NEXTPATNO";

	public final static String SCH_CONFIRM = "F";
}