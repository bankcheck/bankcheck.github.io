package com.hkah.convert;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.TextUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.CRMClientDB;
import com.hkah.web.db.CRMClientInterest;
import com.hkah.web.db.CRMClientMedical;
import com.hkah.web.db.CRMClientPhysical;
import com.hkah.web.db.CRMParameter;
import com.hkah.web.db.EnrollmentDB;
import com.hkah.web.db.EventDB;
import com.hkah.web.db.ScheduleDB;

public class CRMTWAHMarketingClient {

	public static void client() {
		Connection conn = null;
		try {
			Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
			String url="jdbc:odbc:Driver={Microsoft Access Driver (*.mdb)};DBQ=C:\\Marketing.mdb;DriverID=22;READONLY=true}";
			conn = DriverManager.getConnection(url, "", "");
		} catch (Exception e) {
			e.printStackTrace();
		}

		try {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT PID, [Chinese Name], Address1, Address2, Address3, Address4, ");
			sqlStr.append("       Surname, [Last Name], Sex, DOB, Year, Telephone1, Telephone2, ");
			sqlStr.append("       Fax, Email, District, Occupation, Education, Remarks ");
			sqlStr.append("FROM   Patients ");
			sqlStr.append("Order by PID ");
			ArrayList result = UtilDBWeb.getReportableList(conn, sqlStr.toString());
			ReportableListObject rlo = null;

			String clientID = null;

			int index = 0;
			int index2 = 0;
			String dob = null;
			String year = null;
			String dob_yy = null;
			String dob_mm = null;
			String dob_dd = null;

			String sex = null;
			String sex_desc = null;

			if (result.size() > 0) {
				sqlStr.setLength(0);
				sqlStr.append("SELECT 1 FROM CRM_CLIENTS WHERE CRM_CLIENT_ID = ?");
				String sqlStr_SelectClient = sqlStr.toString();

				sqlStr.setLength(0);
				sqlStr.append("INSERT INTO CRM_CLIENTS (");
				sqlStr.append("CRM_CLIENT_ID, CRM_CHINESENAME, CRM_STREET1, CRM_STREET2, CRM_STREET3, CRM_STREET4, ");
				sqlStr.append("CRM_FIRSTNAME, CRM_LASTNAME, CRM_SEX, CRM_DOB_YY, CRM_DOB_MM, CRM_DOB_DD, CRM_MOBILE_NUMBER, CRM_HOME_NUMBER, ");
				sqlStr.append("CRM_FAX_NUMBER, CRM_EMAIL, CRM_DISTRICT_DESC, CRM_OCCUPATION_DESC, CRM_EDUCATION_LEVEL_DESC, CRM_REMARKS, ");
				sqlStr.append("CRM_CREATED_SITE_CODE, CRM_CREATED_DEPARTMENT_CODE)");
				sqlStr.append("VALUES (?, ?, ?, ?, ?, ?, ");
				sqlStr.append("?, ?, ?, ?, ?, ?, ?, ?, ");
				sqlStr.append("?, ?, ?, ?, ?, ?, ");
				sqlStr.append("?, ?) ");
				String sqlStr_InsertClient = sqlStr.toString();

				sqlStr.setLength(0);
				sqlStr.append("UPDATE CRM_CLIENTS SET ");
				sqlStr.append("CRM_CHINESENAME = ?, CRM_STREET1 = ?, CRM_STREET2 = ?, CRM_STREET3 = ?, CRM_STREET4 = ?, ");
				sqlStr.append("CRM_FIRSTNAME = ?, CRM_LASTNAME = ?, CRM_SEX = ?, CRM_DOB_YY = ?, CRM_DOB_MM = ?, CRM_DOB_DD = ?, CRM_MOBILE_NUMBER = ?, CRM_HOME_NUMBER = ?, ");
				sqlStr.append("CRM_FAX_NUMBER = ?, CRM_EMAIL = ?, CRM_DISTRICT_DESC = ?, CRM_OCCUPATION_DESC = ?, CRM_EDUCATION_LEVEL_DESC = ?, CRM_REMARKS = ?, ");
				sqlStr.append("CRM_CREATED_SITE_CODE = ?, CRM_CREATED_DEPARTMENT_CODE = ? ");
				sqlStr.append("WHERE CRM_CLIENT_ID = ?");
				String sqlStr_UpdateClient = sqlStr.toString();

				for (int i = 0; i < result.size(); i++) {
					rlo = (ReportableListObject) result.get(i);

					clientID = rlo.getValue(0);

					dob = rlo.getValue(9);
					year = rlo.getValue(10);
					if (dob != null && dob.length() == 10) {
						index = dob.indexOf("/");
						dob_dd = dob.substring(0, index);
						index2 = dob.indexOf("/", index + 1);
						dob_mm = dob.substring(index + 1, index2);
						dob_yy = dob.substring(index2 + 1);
					} else if (year != null && year.length() == 4) {
						dob_yy = year;
					} else {
						dob_dd = "";
						dob_mm = "";
						dob_yy = "";
					}

					sex_desc = rlo.getValue(8);
					if ("Male".equals(sex_desc)) {
						sex = "M";
					} else if ("Female".equals(sex_desc)) {
						sex = "F";
					} else {
						sex = null;
					}

					if (UtilDBWeb.isExist(sqlStr_SelectClient, new String[] { clientID } )) {
						if (UtilDBWeb.updateQueue(
								sqlStr_UpdateClient,
								new String[] {
										TextUtil.parseStr(rlo.getValue(1)), TextUtil.parseStr(rlo.getValue(2)).toUpperCase(), TextUtil.parseStr(rlo.getValue(3)).toUpperCase(),
										TextUtil.parseStr(rlo.getValue(4)).toUpperCase(), TextUtil.parseStr(rlo.getValue(5)).toUpperCase(),
										TextUtil.parseStr(rlo.getValue(7)).toUpperCase(), TextUtil.parseStr(rlo.getValue(6)).toUpperCase(),
										sex, dob_yy, dob_mm, dob_dd,
										TextUtil.parseStr(rlo.getValue(11)), TextUtil.parseStr(rlo.getValue(12)), TextUtil.parseStr(rlo.getValue(13)),
										TextUtil.parseStr(rlo.getValue(14)), TextUtil.parseStr(rlo.getValue(15)), TextUtil.parseStr(rlo.getValue(16)),
										TextUtil.parseStr(rlo.getValue(17)), TextUtil.parseStr(rlo.getValue(18)), ConstantsServerSide.SITE_CODE_TWAH, "750",
										clientID } )) {
						} else {
							System.err.println("[" + clientID + "] update fail");
						}
					} else {
						if (UtilDBWeb.updateQueue(
								sqlStr_InsertClient,
								new String[] {clientID,
										TextUtil.parseStr(rlo.getValue(1)), TextUtil.parseStr(rlo.getValue(2)).toUpperCase(), TextUtil.parseStr(rlo.getValue(3)).toUpperCase(),
										TextUtil.parseStr(rlo.getValue(4)).toUpperCase(), TextUtil.parseStr(rlo.getValue(5)).toUpperCase(),
										TextUtil.parseStr(rlo.getValue(7)).toUpperCase(), TextUtil.parseStr(rlo.getValue(6)).toUpperCase(),
										sex, dob_yy, dob_mm, dob_dd,
										TextUtil.parseStr(rlo.getValue(11)), TextUtil.parseStr(rlo.getValue(12)), TextUtil.parseStr(rlo.getValue(13)),
										TextUtil.parseStr(rlo.getValue(14)), TextUtil.parseStr(rlo.getValue(15)), TextUtil.parseStr(rlo.getValue(16)),
										TextUtil.parseStr(rlo.getValue(17)), TextUtil.parseStr(rlo.getValue(18)), ConstantsServerSide.SITE_CODE_TWAH, "750"
								} )) {
						} else {
							System.err.println("[" + clientID + "] create fail");
						}
					}

					// add access control
					CRMClientDB.addAccessControl(clientID, ConstantsServerSide.SITE_CODE_TWAH, "520", "SYSTEM");	// LMC
					CRMClientDB.addAccessControl(clientID, ConstantsServerSide.SITE_CODE_TWAH, "750", "SYSTEM");	// Marketing
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void seminar() {
		Connection conn = null;
		try {
			Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
			String url="jdbc:odbc:Driver={Microsoft Access Driver (*.mdb)};DBQ=C:\\Marketing.mdb;DriverID=22;READONLY=true}";
			conn = DriverManager.getConnection(url, "", "");
		} catch (Exception e) {
			e.printStackTrace();
		}

		try {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT Seminar, Date, Clients, Active, Order ");
			sqlStr.append("FROM   Seminars ");
			sqlStr.append("Order by ID ");
			ArrayList result = UtilDBWeb.getReportableList(conn, sqlStr.toString());
			ReportableListObject rlo = null;

			String eventID = null;
			String eventDesc = null;
			String eventDate = null;
			String eventSize = null;
			String eventActive = null;
			String scheduleID = null;

			if (result.size() > 0) {
				for (int i = 0; i < result.size(); i++) {
					rlo = (ReportableListObject) result.get(i);

					eventDesc = rlo.getValue(0);
					eventDate = access2OracleDate(rlo.getValue(1));
					eventSize = rlo.getValue(2);
					eventActive = rlo.getValue(3);
					eventID = EventDB.getEventID("lmc", eventDesc);
					// event
					if (eventID == null) {
						eventID = EventDB.add("lmc", null, "seminar", null, eventDesc, null, "SYSTEM");
					} else {
						EventDB.update("lmc", eventID, null, "seminar", null, eventDesc, null, "SYSTEM");
					}

					scheduleID = ScheduleDB.getScheduleID("lmc", eventID, eventDesc);
					// schedule
					if (scheduleID == null) {
						scheduleID = ScheduleDB.add("lmc", eventID, eventDesc, eventDate, eventDate, null, null, null, null, eventSize, "1".equals(eventActive)?"open":"close", "SYSTEM"); 
					} else {
						ScheduleDB.update("lmc", eventID, scheduleID, eventDesc, eventDate, eventDate, null, null, null, null, eventSize, "1".equals(eventActive)?"open":"close", "SYSTEM",null);
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void attendance() {
		Connection conn = null;
		try {
			Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
			String url="jdbc:odbc:Driver={Microsoft Access Driver (*.mdb)};DBQ=C:\\Marketing.mdb;DriverID=22;READONLY=true}";
			conn = DriverManager.getConnection(url, "", "");
		} catch (Exception e) {
			e.printStackTrace();
		}

		try {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT Seminar, PID, [Attendants No], [Create Date], User ");
			sqlStr.append("FROM   Attendants ");
			sqlStr.append("WHERE  Cancel = 0 ");
			sqlStr.append("Order by Seminar ");
			ArrayList result = UtilDBWeb.getReportableList(conn, sqlStr.toString());
			ReportableListObject rlo = null;

			String eventID = null;
			String scheduleID = null;
			String eventDesc = null;
			String patientID = null;
			String enrollNo = null;
			String createDate = null;
			String createUser = null;

			if (result.size() > 0) {
				for (int i = 0; i < result.size(); i++) {
					rlo = (ReportableListObject) result.get(i);

					eventDesc = rlo.getValue(0);
					patientID = rlo.getValue(1);
					enrollNo = rlo.getValue(2);
					createDate = access2OracleDate(rlo.getValue(3));
					createUser = rlo.getValue(4);

					// get event id
					eventID = EventDB.getEventID("lmc", eventDesc);

					// get schedule id
					scheduleID = ScheduleDB.getScheduleID("lmc", eventID, eventDesc);

					EnrollmentDB.enroll("lmc", eventID, scheduleID, enrollNo, "patient", patientID, createUser, createDate);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void interest() {
		Connection conn = null;
		try {
			Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
			String url="jdbc:odbc:Driver={Microsoft Access Driver (*.mdb)};DBQ=C:\\Marketing.mdb;DriverID=22;READONLY=true}";
			conn = DriverManager.getConnection(url, "", "");
		} catch (Exception e) {
			e.printStackTrace();
		}

		try {
			ArrayList result = null; 
			ReportableListObject rlo = null;

			// get list of hospital facility mapping table
			HashMap allCode = new HashMap();
			result = CRMParameter.getList("hospitalFacility");
			if (result.size() > 0) {
				for (int i = 0; i < result.size(); i++) {
					rlo = (ReportableListObject) result.get(i);
					allCode.put(rlo.getFields1(), rlo.getFields0());
				}
			}

			String patientID = null;
			String interestDesc = null;
			String interestID = null;
			String remark = null;

			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT PID, Interest ");
			sqlStr.append("FROM   [Patients Interest] ");
			sqlStr.append("Order by ID ");
			result = UtilDBWeb.getReportableList(conn, sqlStr.toString());

			if (result.size() > 0) {
				for (int i = 0; i < result.size(); i++) {
					rlo = (ReportableListObject) result.get(i);

					patientID = rlo.getValue(0);
					interestDesc = rlo.getValue(1);
					if (allCode.containsKey(interestDesc)) {
						interestID = (String) allCode.get(interestDesc);
						remark = null;
					}
					if (interestID == null || interestID.length() == 0) {
						interestID = ConstantsVariable.EMPTY_VALUE;
						remark = interestDesc;
					}

					if (CRMClientInterest.add(patientID, interestID, "S", remark, "SYSTEM") == null) {
						System.err.println("update fail from access[" + patientID + "][" + interestID + "][" + interestDesc + "]");
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void medical() {
		Connection conn = null;
		try {
			Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
			String url="jdbc:odbc:Driver={Microsoft Access Driver (*.mdb)};DBQ=C:\\Marketing.mdb;DriverID=22;READONLY=true}";
			conn = DriverManager.getConnection(url, "", "");
		} catch (Exception e) {
			e.printStackTrace();
		}

		try {
			ArrayList result = null; 
			ReportableListObject rlo = null;

			// get list of medical mapping table
			HashMap allCode = new HashMap();
			result = CRMParameter.getList("medical");
			if (result.size() > 0) {
				for (int i = 0; i < result.size(); i++) {
					rlo = (ReportableListObject) result.get(i);
					allCode.put(rlo.getFields1(), rlo.getFields0());
				}
			}

			String patientID = null;
			String medicalDesc = null;
			String interestID = null;
			String remark = null;

			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT PID, Disease ");
			sqlStr.append("FROM   [Patients Family History] ");
			sqlStr.append("Order by ID ");
			result = UtilDBWeb.getReportableList(conn, sqlStr.toString());

			if (result.size() > 0) {
				for (int i = 0; i < result.size(); i++) {
					rlo = (ReportableListObject) result.get(i);

					patientID = rlo.getValue(0);
					medicalDesc = rlo.getValue(1);
					if (allCode.containsKey(medicalDesc)) {
						interestID = (String) allCode.get(medicalDesc);
						remark = null;
					}
					if (interestID == null || interestID.length() == 0) {
						interestID = ConstantsVariable.EMPTY_VALUE;
						remark = medicalDesc;
					}

					if (CRMClientMedical.add(patientID, interestID, "F", remark, "SYSTEM") == null) {
						System.err.println("update fail from access[" + patientID + "][" + interestID + "][" + medicalDesc + "]");
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public static void physical() {
		// store physical code
		HashMap allPhysicalCode = new HashMap();
		allPhysicalCode.put("4", "01");		// Height
		allPhysicalCode.put("5", "02");		// Weight
		allPhysicalCode.put("6", "03");		// Blood Up
		allPhysicalCode.put("7", "04");		// Blood Down
		allPhysicalCode.put("8", "05");		// Body Fat
		allPhysicalCode.put("9", "06");		// Waist
		allPhysicalCode.put("10", "07");	// Hip
		allPhysicalCode.put("11", "08");	// Urine Glucose
		allPhysicalCode.put("13", "09");	// Blood Glucose
		allPhysicalCode.put("14", "10");	// Diabetes
		allPhysicalCode.put("15", "11");	// Cholesterol
		allPhysicalCode.put("18", "12");	// Smoking
		allPhysicalCode.put("20", "13");	// Exercies
		allPhysicalCode.put("21", "14");	// Family HD
		allPhysicalCode.put("22", "15");	// Character
		allPhysicalCode.put("23", "16");	// Soft
		allPhysicalCode.put("24", "17");	// Step
		allPhysicalCode.put("25", "18");	// Grapple
		allPhysicalCode.put("26", "19");	// One Mile

		helper("Patients Physical History", allPhysicalCode);
	}
	
	public static void digest() {
		// store physical code
		HashMap allPhysicalCode = new HashMap();
		allPhysicalCode.put("4", "20");
		allPhysicalCode.put("5", "21");
		allPhysicalCode.put("6", "22");
		allPhysicalCode.put("7", "23");
		allPhysicalCode.put("8", "24");
		allPhysicalCode.put("9", "25");
		allPhysicalCode.put("10", "26");
		allPhysicalCode.put("11", "27");
		allPhysicalCode.put("12", "28");
		allPhysicalCode.put("13", "29");
		allPhysicalCode.put("14", "30");
		allPhysicalCode.put("15", "31");
		allPhysicalCode.put("16", "32");

		helper("Digest", allPhysicalCode);
	}

	public static void ipss() {
		// store physical code
		HashMap allPhysicalCode = new HashMap();
		allPhysicalCode.put("04", "33");
		allPhysicalCode.put("05", "34");
		allPhysicalCode.put("06", "35");
		allPhysicalCode.put("07", "36");
		allPhysicalCode.put("08", "37");
		allPhysicalCode.put("09", "38");
		allPhysicalCode.put("10", "39");
		allPhysicalCode.put("11", "40");
		allPhysicalCode.put("12", "41");
		allPhysicalCode.put("13", "42");
		allPhysicalCode.put("14", "43");
		allPhysicalCode.put("15", "44");
		allPhysicalCode.put("16", "45");
		allPhysicalCode.put("17", "46");
		allPhysicalCode.put("18", "28");
        allPhysicalCode.put("19", "32");

		helper("IPSS", allPhysicalCode);
	}

	public static void helper(String tableName, HashMap allPhysicalCode) {
		Connection conn = null;
		try {
			Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
			String url="jdbc:odbc:Driver={Microsoft Access Driver (*.mdb)};DBQ=C:\\Marketing.mdb;DriverID=22;READONLY=true}";
			conn = DriverManager.getConnection(url, "", "");
		} catch (Exception e) {
			e.printStackTrace();
		}

		try {
			ArrayList result = null; 
			ReportableListObject rlo = null;

			// store seminar code
			HashMap allSeminarCode = new HashMap();
			result = EventDB.getList("lmc", null, null, null, null);
			if (result.size() > 0) {
				for (int i = 0; i < result.size(); i++) {
					rlo = (ReportableListObject) result.get(i);
					allSeminarCode.put(rlo.getFields1(), rlo.getFields0());
				}
			}

			String patientID = null;
			String eventID = null;
			String eventDesc = null;
			String eventDate = null;
			String scheduleID = null;
			String location = null;
			String figureID = null;
			String figureValue = null;

			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT * ");
			sqlStr.append("FROM   [");
			sqlStr.append(tableName);
			sqlStr.append("] ");
			result = UtilDBWeb.getReportableList(conn, sqlStr.toString());

			if (result.size() > 0) {
				for (int i = 0; i < result.size(); i++) {
					rlo = (ReportableListObject) result.get(i);

					patientID = rlo.getValue(3);
					eventDesc = rlo.getValue(1);
					eventDate = access2OracleDate(rlo.getValue(2));
					if (allSeminarCode.containsKey(eventDesc)) {
						eventID = (String) allSeminarCode.get(eventDesc);
						scheduleID = ScheduleDB.getScheduleID("lmc", eventID, eventDesc);
					} else {
						eventID = EventDB.add("lmc", null, "seminar", null, eventDesc, null, "SYSTEM");
						allSeminarCode.put(eventDesc, eventID);
						System.err.println("create event [" + eventDesc + "]");
					}

					if (scheduleID == null) {
						scheduleID = ScheduleDB.add("lmc", eventID, eventDesc, eventDate, eventDate, null, null, null, null, "200", "close", "SYSTEM");
						System.err.println("create schedule [" + eventDesc + "]");
					}

					if (eventID == null) {
						System.err.println(">>>>>>>>>>>>>> empty event ID <<<<<<<<<<<<<<<<");
					} else if (scheduleID == null) {
						System.err.println(">>>>>>>>>>>>>> empty schedule ID <<<<<<<<<<<<<<<<");
					} else {
						for (Iterator j = allPhysicalCode.keySet().iterator(); j.hasNext(); ) {
							location = (String) j.next();
							figureID = (String) allPhysicalCode.get(location);
							figureValue = rlo.getValue(Integer.parseInt(location));
							if (EnrollmentDB.enroll("lmc", eventID, scheduleID, "1", "patient", patientID, "SYSTEM", eventDate) < 0) {
								System.err.println("enrolled");
							}

							if (!CRMClientPhysical.isExist(patientID, eventID, scheduleID, figureID)) {
								CRMClientPhysical.add(patientID, eventID, scheduleID, figureID, figureValue, "SYSTEM");
							} else {
								CRMClientPhysical.update(patientID, eventID, scheduleID, figureID, figureValue, "SYSTEM");
							}
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private static String access2OracleDate(String accessDate) {
		return accessDate.substring(8, 10) + "/" + accessDate.substring(5, 7) + "/" + accessDate.substring(0, 4) + " " + accessDate.substring(11); 
	}
}