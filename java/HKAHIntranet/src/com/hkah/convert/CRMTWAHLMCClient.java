package com.hkah.convert;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.ArrayList;
import java.util.HashMap;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.TextUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.CRMClientDB;
import com.hkah.web.db.CRMParameter;
import com.hkah.web.db.EventDB;
import com.hkah.web.db.ScheduleDB;

public class CRMTWAHLMCClient {
	public static void client() {
		Connection conn = null;
		try {
			Class.forName("sun.jdbc.odbc.JdbcOdbcDriver");
			String url="jdbc:odbc:Driver={Microsoft Access Driver (*.mdb)};DBQ=C:\\LM.mdb;DriverID=22;READONLY=true}";
			conn = DriverManager.getConnection(url, "", "");
		} catch (Exception e) {
			e.printStackTrace();
		}

		try {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT CID, HCN, [Chinese Name], [Given Name], [Last Name], ");
			sqlStr.append("       [Mobile Phone], [Home Phone], Address1, Address2, Address3, ");
			sqlStr.append("       Fax, Email, Remark, [Title Eng], [Title Chi], Sex, DOB, HKID,  ");
			sqlStr.append("       [Office Phone], District, HKNo, TWNo, ");
			sqlStr.append("       [Passport Type], [Passport No], [Expiry Date], ");
			sqlStr.append("       [Contact Person], [Contact Person No], ");
			sqlStr.append("       Occupation, Education, Source, Introducer ");
			sqlStr.append("FROM   Clients Order by CID ");
			ArrayList result = UtilDBWeb.getReportableList(conn, sqlStr.toString());

			ReportableListObject rlo = null;
			ArrayList result2 = CRMParameter.getList("occupation");
			HashMap occupationHashMap = new HashMap();
			for (int i = 0; i < result2.size(); i++) {
				rlo = (ReportableListObject) result2.get(i);
				occupationHashMap.put(rlo.getValue(1), rlo.getValue(0));
			}
			result2 = CRMParameter.getList("education");
			HashMap educationHashMap = new HashMap();
			for (int i = 0; i < result2.size(); i++) {
				rlo = (ReportableListObject) result2.get(i);
				educationHashMap.put(rlo.getValue(1), rlo.getValue(0));
			}

			int index = 0;
			int index2 = 0;

			String clientID = null;
			String title_desc1 = null;
			String title_desc2 = null;
			String title = null;
			String chineseName = null;
			String street1 = null;
			String street2 = null;
			String street3 = null;
			String street4 = null;
			String firstName = null;
			String lastName = null;
			String sex = null;
			String sex_desc = null;
			String dob = null;
			String dob_yy = null;
			String dob_mm = null;
			String dob_dd = null;
			String hkid = null;
			String mobileNumber = null;
			String homeNumber = null;
			String officeNumber = null;
			String faxNumber = null;
			String email = null;
			String area = null;
			String areaID = null;
			String occupation_desc = null;
			String occupationID = null;
			String education_desc = null;
			String educationID = null;
			String contract_person = null;
			String contract_person_no = null;
			String remarks = null;

			if (result.size() > 0) {

				for (int i = 0; i < result.size(); i++) {
					rlo = (ReportableListObject) result.get(i);

					clientID = null;
					chineseName = TextUtil.parseStr(rlo.getValue(2));
					firstName = TextUtil.parseStr(rlo.getValue(3)).toUpperCase();
					lastName = TextUtil.parseStr(rlo.getValue(4)).toUpperCase();
					mobileNumber = TextUtil.parseStr(rlo.getValue(5));
					homeNumber = TextUtil.parseStr(rlo.getValue(6));
					street1 = TextUtil.parseStr(rlo.getValue(7)).toUpperCase();
					street2 = TextUtil.parseStr(rlo.getValue(8)).toUpperCase();
					street3 = TextUtil.parseStr(rlo.getValue(9)).toUpperCase();
					faxNumber = TextUtil.parseStr(rlo.getValue(10));
					email = TextUtil.parseStr(rlo.getValue(11));
					remarks = TextUtil.parseStr(rlo.getValue(12));
					title = null;
					title_desc1 = TextUtil.parseStr(rlo.getValue(13));
					title_desc2 = TextUtil.parseStr(rlo.getValue(14));
					if (title_desc1 != null && title_desc1.length() > 0 && title_desc2 != null && title_desc2.length() > 0) {
						if ("Mr.".equals(title_desc1) || "先生".equals(title_desc2)) {
							title = "1";
						} else if ("Miss".equals(title_desc1) || "小姐".equals(title_desc2)) {
							title = "2";
						} else if ("Mrs.".equals(title_desc1) || "Ms".equals(title_desc1) || "Madam".equals(title_desc1) || title_desc2.indexOf("女") >= 0) {
							title = "3";
						} else {
							System.err.println("not found in title:[" + title_desc1 + "][" + title_desc2 + "]");
						}
					}
					sex = null;
					sex_desc = rlo.getValue(15);
					if (sex_desc != null && sex_desc.length() > 0) {
						if ("M".equals(sex_desc) || sex_desc.indexOf("男") >= 0) {
							sex = "M";
						} else if ("F".equals(sex_desc) || sex_desc.indexOf("女") >= 0) {
							sex = "F";
						} else {
							System.err.println("not found in sex:[" + sex + "]");
						}
					}
					dob = rlo.getValue(16);
					dob_dd = null;
					dob_mm = null;
					dob_yy = null;
					if (dob != null && dob.length() >= 8) {
						index = dob.indexOf("/");
						if (index >  0) {
							dob_dd = dob.substring(0, index);
							index2 = dob.indexOf("/", index + 1);
							if (index2 > 0) {
								dob_mm = dob.substring(index + 1, index2);
								dob_yy = dob.substring(index2 + 1);
							}
						}
					}
					hkid = TextUtil.parseStr(rlo.getValue(17)).toUpperCase();
					officeNumber = TextUtil.parseStr(rlo.getValue(18));
					area = TextUtil.parseStr(rlo.getValue(19));
					if ("香港".equals(area)) {
						areaID = "1";
					} else if ("九龍".equals(area)) {
						areaID = "2";
					} else if ("新界".equals(area)) {
						areaID = "3";
					}
					contract_person = TextUtil.parseStr(rlo.getValue(25));
					contract_person_no = TextUtil.parseStr(rlo.getValue(26));
					occupationID = null;
					occupation_desc = TextUtil.parseStr(rlo.getValue(27));
					if (occupation_desc != null && occupation_desc.length() > 0) {
						if (occupationHashMap.containsKey(occupation_desc)) {
							occupationID = (String) occupationHashMap.get(occupation_desc);
						} else if (occupation_desc.indexOf("專業") >= 0) {
							occupationID = "2";
						} else if (occupation_desc.indexOf("文職") >= 0) {
							occupationID = "4";
						} else if (occupation_desc.indexOf("自僱") >= 0) {
							occupationID = "6";
						} else if (occupation_desc.indexOf("退休") >= 0) {
							occupationID = "11";
						} else {
							System.err.println("not found in occupation:[" + occupation_desc + "]");
						}
					}
					educationID = null;
					education_desc = TextUtil.parseStr(rlo.getValue(28));
					if (education_desc != null && education_desc.length() > 0) {
						if (educationHashMap.containsKey(education_desc)) {
							educationID = (String) occupationHashMap.get(education_desc);
						} else {
							System.err.println("not found in education:[" + education_desc + "]");
						}
					}

					try {
						result2 = CRMClientDB.getList(lastName, firstName, chineseName, sex, officeNumber, homeNumber, mobileNumber, hkid);
					} catch (Exception e) {
						System.err.println("error in getList([" + lastName + "][" + firstName + "][" + chineseName + "][" + sex + "][" + officeNumber + "][" + homeNumber + "][" + mobileNumber + "][" + hkid + "])");
					}

					if (result2.size() == 1) {
						rlo = (ReportableListObject) result2.get(0);
						clientID = rlo.getValue(0);
						if (!CRMClientDB.update(clientID, lastName, firstName, chineseName, title, null, sex,
								dob_yy, dob_mm, dob_dd, null, null, null, null, educationID, occupationID,
								hkid, null, street1, street2, street3, street4, null, areaID, null, null,
								homeNumber, officeNumber, mobileNumber, faxNumber, email,
								contract_person, contract_person_no, null, null, null, "Y", null, new String[] { ConstantsServerSide.SITE_CODE_TWAH + "-520", ConstantsServerSide.SITE_CODE_TWAH + "-750" }, ConstantsServerSide.SITE_CODE_TWAH, "520", "SYSTEM",null)) {
							System.err.println("[" + clientID + "] update fail");
						}
					} else {
						if (CRMClientDB.add(lastName, firstName, chineseName, title, null, sex,
								dob_yy, dob_mm, dob_dd, null, null, null, null, educationID, occupationID,
								hkid, null, street1, street2, street3, street4, null, areaID, null, null,
								homeNumber, officeNumber, mobileNumber, faxNumber, email,
								contract_person, contract_person_no, null, null, null, "Y", null, new String[] { "twah-520", "twah-750" }, "twah", "520", "SYSTEM",null,null,false) == null) {
							System.err.println("[" + clientID + "] create fail");
						}
					}
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
			String url="jdbc:odbc:Driver={Microsoft Access Driver (*.mdb)};DBQ=C:\\LM.mdb;DriverID=22;READONLY=true}";
			conn = DriverManager.getConnection(url, "", "");
		} catch (Exception e) {
			e.printStackTrace();
		}

		try {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT Type, Event, [Event Date], Place, Doctor, Active, Order ");
			sqlStr.append("FROM   Events ");
			sqlStr.append("Order by Type, Event, [Event Date] ");
			ArrayList result = UtilDBWeb.getReportableList(conn, sqlStr.toString());
			ReportableListObject rlo = null;

			String eventDesc = null;
			String scheduleDesc = null;
			String eventDate = null;
			String place = null;
			String doctor = null;
			String eventActive = null;

			String eventID = null;
			String eventType = null;
			String scheduleID = null;

			if (result.size() > 0) {
				for (int i = 0; i < result.size(); i++) {
					rlo = (ReportableListObject) result.get(i);

					eventDesc = rlo.getValue(0).trim();
					scheduleDesc = rlo.getValue(1).trim();
					eventDate = access2OracleDate(rlo.getValue(2).trim());
					if ("Newstart".equals(eventDesc)) {
						eventType = "newstart";
					} else if ("Funfit".equals(eventDesc)) {
						eventType = "funfit";
					} else if ("查詢".equals(eventDesc)) {
						eventType = "enquire";
					} else if ("Quit Now".equals(eventDesc)) {
						eventType = "quitnow";
					} else if ("CC".equals(eventDesc)) {
						eventType = "cc";
					}
					eventActive = rlo.getValue(3);
					eventID = EventDB.getEventID("crm", eventDesc, "lmc", eventType);
					// event
					if (eventID == null) {
						eventID = EventDB.add("crm", null, "lmc", eventType, eventDesc, null, "SYSTEM");
					} else {
						EventDB.update("crm", eventID, null, "lmc", eventType, eventDesc, null, "SYSTEM");
					}

					scheduleID = ScheduleDB.getScheduleIDByDateTime("crm", eventID, eventDate, eventDate);
					// schedule
					if (scheduleID == null) {
						scheduleID = ScheduleDB.add("crm", eventID, scheduleDesc, eventDate, eventDate, null, null, place, doctor, "0", "1".equals(eventActive)?"open":"close", "SYSTEM"); 
					} else {
						ScheduleDB.update("crm", eventID, scheduleID, scheduleDesc, eventDate, eventDate, null, null, place, doctor, "0", "1".equals(eventActive)?"open":"close", "SYSTEM",null);
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