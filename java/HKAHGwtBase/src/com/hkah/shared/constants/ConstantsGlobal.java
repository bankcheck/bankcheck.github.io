package com.hkah.shared.constants;

public interface ConstantsGlobal {

	// System constants
	public final static String DSN = "Hat";
	public final static int QUERY_TIMEOUT = 1800;
	public final static int LOCKRETRYMAX = 5;
	public final static int LOCKRETRYDELAY = 1000;
	public final static String SYSTEMPATH = "c:\\" + DSN + "\\";

	public final static String INI_PBA = "C:\\Hat\\Bin\\PBA.ini";
	public final static String INI_DAYEND = "C:\\Hat\\Bin\\Dayend.ini";

	public final static String LOG_PBA = SYSTEMPATH + "bin\\PBALog.txt";
	public final static String LOG_DAYEND = SYSTEMPATH + "bin\\DayEndLog.txt";
	public final static String ALERT_MAIL_EXTENSION = ".hem";

	public final static String SESSION_PQ = "Print Queue";
	public final static String SESSION_LBLPRN = "Label Printer";
	public final static String SESSION_RPTGENSEQ = "Report Generate Sequence";
	public final static String SESSION_RPTPRTSEQ = "Report Print Sequence";

	public final static String SESSION_CSHDISPLAY = "Cashier Display";

	// Server Location
	public final static String SESSION_RPTLOCATION = "Report Location";

	// Negotiation constants
	public final static int TB_SEARCH = 1;     // Search button
	public final static int TB_INSERT = 2;     // Insert button
	public final static int TB_MODIFY = 3;     // Modify button
	public final static int TB_DELETE = 4;     // Delete button
	public final static int TB_COMMIT = 5;     // Commit button
	public final static int TB_ACCEPT = 6;     // Accept button
	public final static int TB_CANCEL = 7;     // Cancel button
	public final static int TB_CLEAR = 8;      // Clear button
	public final static int TB_REFRESH = 9;    // Refresh button
	public final static int TB_PRINT = 10;
	public final static int TB_USER = 100;

	public final static int TBM_SYNC = 0;
	public final static int TBM_CLICK = 1;
	public final static int TBM_GETPARAMETER = 2;
	public final static int TBM_USER = 100;

	// Internal constants
	public final static int DBG_TAB = 15;

	// Setting table keys
	public final static String SET_SLIP_NO = "SLIPNO";
	public final static String SET_RECEIPT_NO = "RECEIPT";
	public final static String SET_PRES_NO = "PRES";

	// Report Constant
	// Client side
	public final static String REPORT_PATH = SYSTEMPATH + "Report\\";
	public final static String PRINT_RPT_LOG = SYSTEMPATH + "Report\\RptLog.txt";
	public final static String SUB_REPORT_NAME = REPORT_PATH + "Backup.mdb";
	public final static String TEMP_MDB_NAME = REPORT_PATH + "Temp.mdb";
	public final static String REPORT_INTERACTIVE = REPORT_PATH + "Interactive\\";
	public final static String REPORT_DAYEND = REPORT_PATH + "DayEnd\\";
	public final static String REPORT_OT = REPORT_PATH + "OT\\";

	// Server side
	public final static String REPORT_AR_CMP_TEXT = "\\ARNOTE.TXT";
	public final static String REPORT_3LINES_OF_TEXT = "\\NOTE.TXT";

	public final static String REPORT_ALINES_OF_TEXT = "\\ANOTE.TXT";

	public final static String REPORT_DAYEND_DIR = "\\DayEnd\\";
	public final static String REPORT_DOC_FEE = "\\DocFeeReport\\";

	// Add by Ken(20/12/2000), for determine new sub-disease code and sub-reason code
	public final static String sNewSckCde = "DH";

	// Add by Ken(18/1/2001), for print label using code
	public final static String RPT_LBL_A = "label A";
	public final static String RPT_LBL_B = "label B";
	public final static String RPT_PICK_LST_LBL = "Pick List Label";
	public final static String RPT_MED_REC_LBL = "Medical Record Label";
	public final static String RPT_LBL_TICKET = "Ticket Label";

	// Add by Jason Lai (30/10/2002) for Patient Label
	public final static String RPT_PAT_LBL = "Patient Label";

	// By Jason 2001-09-19
	public final static String PB_NORMAL_STS = "N";
	public final static String PB_DELETE_STS = "D";

	// 2001-11-23
	public final static String gDayEndCancelSlip = "DAYENDCANS"; // raymond

	// 2002-04-19
	public final static String gLOGINTIMEO = "LOGINTIMEO";
	public final static String gSYSTIMEOUT = "SYSTIMEOUT";

	// OT misc type
	public final static String ANEST_METH = "AM";
	public final static String BLOOD_TYPE = "BT";
	public final static String DRESSING = "DR";
	public final static String DRUG = "DG";
	public final static String EQUIPMENT = "EQ";
	public final static String FUNCTION_TYPE = "FN";
	public final static String IMPLANT = "IM";
	public final static String INSTRUMENT = "IN";
	public final static String OUTCOME = "OC";
	public final static String REASON_LATE = "RL";
	public final static String OT_ROOM = "RM";
	public final static String REASON = "RN";
	public final static String OT_STAFF = "SF";
	public final static String SCHEDULE_TYPE = "ST";
	public final static String SPEC_DEST = "SD";

	// OT Appoint Browse
	public final static int EDITMODE = 1;
	public final static int INSERTMODE = 2;
	public final static String OT_APPSTS_N = "N"; // NORMAL
	public final static String OT_APPSTS_C = "C"; // CANCEL
	public final static String OT_APPSTS_F = "F"; // CONFIRM

	// NEW/EDIT OT APPOINT
	public final static int CBO_PROCEDURE = 1;
	public final static int CBO_SURGEON = 2;
	public final static int CBO_ANESTHETIST = 3;

	// BROWSE/NEW/EDIT OT LOG
	public final static String OT_LOG_MODE_SEARCH = "1";
	public final static String OT_LOG_MODE_NEW = "2";
	public final static String OT_LOG_MODE_EDIT = "3";

	// NEW/EDIT OT LOG
	public final static int CBO_PROCPRIM = 1;
	public final static int CBO_SURGPRIM = 2;
	public final static int CBO_ANESPRIM = 3;

	// OT LOG MATERIAL
	public final static String OT_GRD_IM = "IM";
	public final static String OT_GRD_EQ = "EQ";
	public final static String OT_GRD_IN = "IN";
	public final static String OT_GRD_DG = "DG";

	// OT STATUS
	public final static String OT_STS_ACTIVE = "A";
	public final static String OT_STS_CLOSE = "C";
	public final static String OT_STS_DELETE = "X";

	// HOME LEAVE MODE
	public final static int HL_MODE_SEARCH = 1;
	public final static int HL_MODE_NEW = 2;
	public final static int HL_MODE_EDIT = 3;

	public final static String OT_EMERGENCY = "ot_emergency";
	public final static String OT_NOT_EMERGENCY = "ot_not_emergency";

	public final static String XAPP_STATUS_CANCEL = "C";
	public final static String XREG_STATUS_NORMAL = "N";
	public final static String XREG_STATUS_USER_REVERSE = "U";

	// OB Booking
	public final static String OB_STS_WAITING = "S";

	//Med Record

	public final static String NEWPATSTORAGELOCATION = "01";
	public final static String NEWPATCURRENTLOCATION = "02";
	public final static String NEWPATVOLUMENO = "03";
	public final static String NEWPATMEDIATYPE = "04";
	public final static String NEWVOLSTORAGELOCATION = "05";
	public final static String NEWVOLCURRENTLOCATION = "06";
	public final static String NEWVOLVOLUMENO = "07";
	public final static String NEWVOLMEDIATYPE = "08";
	public final static String IPSTORAGELOCATION = "09";
	public final static String IPCURRENTLOCATION = "10";
	public final static String OPSTORAGELOCATION = "11";
	public final static String OPCURRENTLOCATION = "12";
	public final static String DCSTORAGELOCATION = "13";
	public final static String DCCURRENTLOCATION = "14";

	public final static String MEDICAL_RECORD_ID_STR  = "/"; //raymond change V/ to /

	public final static String MEDICAL_RECORD_NORMAL  = "N";
	public final static String MEDICAL_RECORD_MISSING  = "M";
	public final static String MEDICAL_RECORD_DELETE  = "D";
	public final static String MEDICAL_RECORD_PERMANENT  = "P";   //Added by Johnson on Jun 01,2004

	public final static String MEDICAL_RECORD_X_CREATE  = "C";
	public final static String MEDICAL_RECORD_X_TRANSFER  = "T";
	public final static String MEDICAL_RECORD_X_MISSING  = "M";
	public final static String MEDICAL_RECORD_X_DELETE  = "D";

	//public final static String BARCODE_PREFIX_LOCATION  = "+"
	public final static String BARCODE_PREFIX_LOCATION  = "$A";
	public final static String BARCODE_PREFIX_DOCTOR  = "$B";
	public final static String BARCODE_PREFIX_RECORDID  = "-C/";
	public final static String BARCODE_PREFIX_RECORDID_2  = "C/";

	public final static String BARCODE_PREFIX_BUTTON  = "%%";

	public final static String BARCODE_PREFIX_NEW  = "%%NEW";
	public final static String BARCODE_PREFIX_SAVE  = "%%SAV";
	public final static String BARCODE_PREFIX_DELETE  = "%%DEL";
	//Added by Johnson on Oct 23,2003---Start
	public final static String BARCODE_PREFIX_SEARCH  = "%%SRH";
	public final static String BARCODE_PREFIX_SEARCH1  = "" ;     //Added by Johnson on May 24,2004
	public final static String BARCODE_PREFIX_PRINT  = "%%PRN";
	//Added by Johnson on Oct 23,2003---End
	public final static String MSG_DUPLICATE_VOL_LAB  = "Volume number exists!";
	public final static String MSG_FIELD_NO_BLANK  = "%P1% cannot be blank";
	public final static String MSG_MEDICAL_RECORD_REMARK_TOO_LONG  = "Requestor/Rmk too long.";

	public final static String MSG_PATNO_NO_BLANK  = "Patient No. cannot be blank";

	public final static int OTP2 = 2; //Conditionally compiles variables
}
