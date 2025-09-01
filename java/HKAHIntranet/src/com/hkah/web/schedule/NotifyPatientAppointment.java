package com.hkah.web.schedule;

import java.net.InetAddress;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Locale;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.config.MessageResources;
import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.util.sms.UtilSMS;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.EmailAlertDB;
import com.spreada.utils.chinese.ZHConverter;

public class NotifyPatientAppointment implements Job {

	private static String sqlStr_updateSMSReturnMsg_Booking4Patient_Success = null;
	private static String sqlStr_updateSMSReturnMsg_Booking4Patient_Sent = null;
	private static String sqlStr_updateSMSReturnMsg_PatientActivity_Success = null;
	private static String sqlStr_updateSMSReturnMsg_PatientActivity_Sent = null;

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		sendSMS(false);
	}

	//======================================================================
	public static ArrayList getSMSList(SimpleDateFormat smf, Calendar startCal,
										Calendar endCal, boolean isReceiveSMS, String smcID) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT P.MOTHCODE, B.BKGPNAME, P.PATSMS, B.SMCID, BKGMTEL, ");//0, 1, 2, 3, 4
		sqlStr.append("D.DOCFNAME || ' ' || D.DOCGNAME, D.DOCCNAME, ");//5, 6
		sqlStr.append("TO_CHAR(B.BKGSDATE, 'DD'), TO_CHAR(B.BKGSDATE, 'MM'), ");//7, 8
		sqlStr.append("TO_CHAR(B.BKGSDATE, 'YYYY'), TO_CHAR(B.BKGSDATE, 'HH24'), ");//9, 10
		sqlStr.append("TO_CHAR(B.BKGSDATE, 'MI'), B.BKGID, B.SMSSDTOK, ");//11, 12, 13
		if (ConstantsServerSide.isTWAH()) {
			sqlStr.append("P.PATNO, P.PATPAGER, B.SMCID, P.COUCODE, ");//14, 15, 16, 17
		} else {
			sqlStr.append("P.PATNO, P.PATPAGER, B.SMCID, CD.CO_DISPLAYNAME, P.COUCODE, ");//14, 15, 16, 17, 18
		}
		sqlStr.append("D.TITTLE, B.SMSRTNMSG, TO_CHAR(B.BKGSDATE, 'DD/MM/YYYY'), ");//19, 20, 21 (18,19,20 tw)
		sqlStr.append("S.DOCCODE, B.BKGSTS, P.PATEMAIL, D.SPCCODE, B.BKGPCNAME ");//22, 23, 24, 25, 26 (21,22,23,24,25 tw)
		if (ConstantsServerSide.isHKAH()) {
			sqlStr.append(", PE.PATPGRCOUCODE ");//27
		}
		if (ConstantsServerSide.isTWAH()) {
			sqlStr.append("FROM BOOKING@IWEB B, SCHEDULE@IWEB S, DOCTOR@IWEB D, PATIENT@IWEB P ");
		} else {
			sqlStr.append("FROM BOOKING@IWEB B, SCHEDULE@IWEB S, DOCTOR@IWEB D, PATIENT@IWEB P, CO_DOCTORS CD, PATIENT_EXTRA@IWEB PE ");
		}
		sqlStr.append("WHERE B.BKGSDATE >= ");
		sqlStr.append("TO_DATE('" + smf.format(startCal.getTime()) + " 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND   B.BKGSDATE <= ");
		sqlStr.append("TO_DATE('" + smf.format(endCal.getTime()) + " 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND   S.SCHID(+) = B.SCHID ");
		sqlStr.append("AND   D.DOCCODE(+) = S.DOCCODE ");
		sqlStr.append("AND   P.PATNO(+) = B.PATNO ");
		if (ConstantsServerSide.isHKAH()) {
			sqlStr.append("AND	 CD.CO_DOC_CODE(+) = S.DOCCODE ");
			sqlStr.append("AND   P.PATNO = PE.PATNO(+) ");
		}
		sqlStr.append("AND   B.BKGSTS = 'N' ");
		sqlStr.append("AND   (B.USRID <> 'HACCESS' OR (B.USRID = 'HACCESS' AND B.SMCID IS NOT NULL)) ");
		if (ConstantsServerSide.isHKAH()) {
			sqlStr.append("AND   CD.CO_DOC_CODE(+) = S.DOCCODE ");
		}
		if (isReceiveSMS) {
			sqlStr.append("AND   (P.PATSMS = '-1' OR P.PATNO IS NULL) ");
			sqlStr.append("AND   (B.PATNO NOT IN ");
			sqlStr.append("( ");
			sqlStr.append("SELECT P.PATNO ");
			sqlStr.append("FROM PATIENT@IWEB P, BOOKING@IWEB B ");
			sqlStr.append("WHERE P.PATSMS = '0' ");
			sqlStr.append("AND B.BKGSDATE >= ");
			sqlStr.append("TO_DATE('" + smf.format(startCal.getTime()) + " 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
			sqlStr.append("AND   B.BKGSDATE <= ");
			sqlStr.append("TO_DATE('" + smf.format(endCal.getTime()) + " 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
			sqlStr.append("AND   P.PATNO = B.PATNO ");
			sqlStr.append("AND   B.BKGSTS = 'N' ");
			sqlStr.append(") OR B.PATNO IS NULL) ");
		} else {
			sqlStr.append("AND	 (P.PATSMS = '0') ");
		}
		if (ConstantsServerSide.isHKAH()) {
			if (smcID != null && smcID.length() > 0 ) {
				if ( "rehab".equals(smcID)) {
					sqlStr.append("AND  (B.SMCID = '5' OR B.SMCID = '6' OR B.SMCID = '7' OR B.SMCID = '8' OR B.SMCID = '10') ");
				} else {
					sqlStr.append("AND  B.SMCID = '" + smcID + "' ");
				}
				sqlStr.append("AND  B.SMCID <> '11' "); // IGNORE DENTAL APPOINTMENT
			}
			sqlStr.append("AND (B.SMCID   <> '99' OR B.SMCID IS NULL) "); // IGNORE SEND SMS
/*			sqlStr.append("AND   D.DOCCODE <> 'OPDN' "); // IGNORE OPD
			sqlStr.append("AND   D.DOCCODE <> 'OPDG' ");
			sqlStr.append("AND   D.DOCCODE <> 'OPD1' ");
			sqlStr.append("AND   D.DOCCODE <> 'OPD7' ");*/
			sqlStr.append("AND   D.DOCCODE <> 'N020' ");
			sqlStr.append("AND   D.DOCCODE <> 'N024' ");
			//sqlStr.append("AND   D.DOCCODE <> 'N026' "); alan siu
			sqlStr.append("AND   D.DOCCODE <> 'N034' ");
			sqlStr.append("AND   D.DOCCODE <> 'COVID' ");
			sqlStr.append("AND   D.DOCCODE <> 'HC' ");
			sqlStr.append("AND   B.SMSSDT IS NULL ");// for whose are not processed
		} else { //TWAH
			sqlStr.append(" AND  B.SMCID IS NOT NULL ");
			if (smcID != null && smcID.length() > 0 ) {
				sqlStr.append("AND  B.SMCID = '" + smcID + "' ");
				if ("1".equals(smcID) || "2".equals(smcID)) {
					sqlStr.append("AND  D.DOCCODE IN ( 'G137','G139','GE01') ");
				}
			}
			sqlStr.append("AND   B.SMSSDT IS NULL ");// for whose are not processed
		}
		System.out.println("[NotifyPatientAppointment getList]" + sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	//======================================================================
	public static boolean isSmsScheduleDay(Calendar startCal) {
		//check whether today is saturday or holiday with disable sms setting
		if (startCal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY ) {
			return false;
		}
		return true;
	}

	//======================================================================
	public static Calendar getAppointmentDay(Calendar startCal, boolean ignoreSentDate) {
		//check whether today is thur or fri, then use T+3 to get the booking date
		if (startCal.get(Calendar.DAY_OF_WEEK) == Calendar.THURSDAY ||
					startCal.get(Calendar.DAY_OF_WEEK) == Calendar.FRIDAY) {
			startCal.add(Calendar.DATE, 3);
		} else {
			//otherwise, use T+2 to get the booking date
			startCal.add(Calendar.DATE, 2);
		}

		//check whether the booking date is holiday with disable sms setting
		while(startCal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY ||
					isHolidayAndDisableSMS(startCal) || (!ignoreSentDate && isSentSMS(startCal))) {
			startCal.add(Calendar.DATE, 1);
		}

		//set specific day (yyyy, m, d)
		//m is current month - 1, example: April = 3
		//startCal.set(2014, 3, 9);
		return startCal;
	}

/*
	//======================================================================
	private static boolean setSendSMSDate(Calendar date) {
		StringBuffer sqlStr = new StringBuffer();
		SimpleDateFormat smf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);

		sqlStr.append("UPDATE BOOKING@IWEB ");
		sqlStr.append("SET SMSSDT = NULL, SMSSDTOK = NULL, SMSRTNMSG = NULL ");
		sqlStr.append("WHERE BKGSDATE >= TO_DATE('" + smf.format(date.getTime()) + " 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		//sqlStr.append("AND BKGSDATE <= TO_DATE('" + smf.format(date.getTime()) + " 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");

		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
*/
	public static boolean isAppendSMS(String type, String key) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT HPSTATUS ");
		sqlStr.append("FROM   HPSTATUS@IWEB ");
		sqlStr.append("WHERE  HPTYPE = ? ");
		sqlStr.append("AND    HPKEY = ? ");
		sqlStr.append("AND    HPACTIVE = -1");

		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{type, key});

		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			return "-1".equals(row.getValue(0));
		} else {
			return false;
		}
	}

	public static boolean isSpecialSpec(String key, String spcCode) {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT COUNT(1) ");
		sqlStr.append("FROM   HPSTATUS@IWEB ");
		sqlStr.append("WHERE  HPTYPE = 'SPSMS' ");
		sqlStr.append("AND    HPKEY = ? ");
		sqlStr.append("AND    HPSTATUS = ? ");
		sqlStr.append("AND    HPACTIVE = -1");

		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[]{key, spcCode});

		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			return "1".equals(row.getValue(0));
		} else {
			return false;
		}
	}

	//======================================================================
	public static void sendSMS(boolean ignoreSentDate) {
		// get current day
		Calendar startCal = Calendar.getInstance();
		Calendar endCal = Calendar.getInstance();
		sendSMS(startCal, endCal, ignoreSentDate);
	}

	public static void sendSMS(Calendar startCal, boolean ignoreSentDate) {
		// get current day
		sendSMS(startCal, startCal, ignoreSentDate);
	}

	public static void sendSMS(Calendar startCal, Calendar endCal, boolean ignoreSentDate) {
		// get current day
		Calendar currentCal = Calendar.getInstance();
		boolean debug = false;
		boolean sendEmail = false;

		SimpleDateFormat smf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
		/*
		SimpleDateFormat esmf = new SimpleDateFormat("'on' dd MMMM yyyy '('EEE') at 'hh:mm a", Locale.ENGLISH);
		SimpleDateFormat csmf = new SimpleDateFormat("MM月dd日Eahh時mm分", Locale.CHINESE);
		SimpleDateFormat scsmf = new SimpleDateFormat("MM月dd日Eahh时mm分", Locale.SIMPLIFIED_CHINESE);
		SimpleDateFormat jcsmf = new SimpleDateFormat("MM月dd日Eahh時mm分", Locale.JAPAN);
		*/
		SimpleDateFormat esmf = new SimpleDateFormat("'on' EEE, MMM dd, yyyy' at 'h:mm a", Locale.ENGLISH);
		SimpleDateFormat csmf = new SimpleDateFormat("M月dd日Eah時mm分", Locale.CHINESE);
		SimpleDateFormat scsmf = new SimpleDateFormat("M月dd日Eah时mm分", Locale.SIMPLIFIED_CHINESE);
		SimpleDateFormat jcsmf = new SimpleDateFormat("M月dd日Eah時mm分", Locale.JAPAN);

		if (!isSmsScheduleDay(startCal)) {
			return;
		}

		startCal = getAppointmentDay(startCal, ignoreSentDate);
		endCal = getAppointmentDay(endCal, ignoreSentDate);

		//startCal.set(2014, 5, 13);
		//endCal.set(2014, 5, 13);

		String serverIP = null;
		try {
			serverIP = InetAddress.getLocalHost().getHostAddress();
		} catch (Exception e) {
		}

		ArrayList record = getSMSList(smf, startCal, endCal, true, null);
		ReportableListObject row = null;
		if (record.size() > 0) {
			for(int i = 0; i < record.size(); i++) {
				row = (ReportableListObject)record.get(i);

				if (row.getValue(20) != null && row.getValue(20).length() > 0 && ConstantsServerSide.isHKAH()) {
					System.out.println("The sms is sent for this appointment");
					EmailAlertDB.sendEmail("appointment.sms",
							"Hong Kong Adventist Hospital - SMS",
							"It has return message already<br/>" +
							"The sms is sent for this appointment - BKGID "  + row.getValue(12));
				} else if (row.getValue(19) != null && row.getValue(19).length() > 0 && ConstantsServerSide.isTWAH()) {
					System.out.println("The sms is sent for this appointment");
					EmailAlertDB.sendEmail("appointment.sms",
							"Hong Kong Adventist Hospital - SMS",
							"It has return message already<br/>" +
							"The sms is sent for this appointment - BKGID "  + row.getValue(12));
				} else {
				//if (row.getValue(2).equals("-1")) {
					String msgId = null;
					String smcid = row.getValue(16);
					String lang = row.getValue(0);
					String docName = null;
					String dateTime = "";
					String smsContent = null;
					String type = null;
					String docTitle = null;
					String patname = row.getValue(1);
					String patcname = null;

					if (ConstantsServerSide.isHKAH()) {
						patcname = row.getValue(26);
					} else {
						patcname = row.getValue(25);
					}

					if (ConstantsServerSide.isHKAH()) {
						if (smcid == null || smcid.length() <= 0) {
							smcid = "1";//set to default - registration desk
						}

						if (row.getValue(14).length() <= 0) {
							smcid = "1";
						}

						if (smcid.equals("4")) {
							type = UtilSMS.SMS_ONCOLOGY;
						} else if (smcid.equals("5") || smcid.equals("6") ||
									smcid.equals("7") || smcid.equals("8") || smcid.equals("10")) {
							type = UtilSMS.SMS_REHAB;
						} else if (smcid.equals("9") || smcid.equals("12")) {
							type = UtilSMS.SMS_OUTPAT;
						} else if (smcid.equals("13")) {
							type = UtilSMS.SMS_LMC;
						} else {
							type = UtilSMS.SMS_OUTPAT;
						}
						if (lang.length() <= 0) {
							lang = "ENG";
						}
					} else {
						if (smcid != null && smcid.length() > 0 ) {
							if (smcid.equals("1") || smcid.equals("2")) {
								type = UtilSMS.SMS_TWWC;
								if (smcid.equals("1")) {
										lang = "TRC";
								} else {
									lang = "ENG";
								}
							} else if (smcid.equals("3") || smcid.equals("4") || smcid.equals("5") || smcid.equals("6")) {
								type = UtilSMS.SMS_TWFD;
								if (smcid.equals("3") || smcid.equals("5")) {
										lang = "TRC";
								} else {
									lang = "ENG";
								}
							}
						}
					}

					//String phoneNo = "69010602";
					String phoneNo = getPhoneNo(row.getValue(4).trim(), row.getValue(18).trim(),
									row.getValue(14).trim(), row.getValue(12),
									lang, smcid, type, (ConstantsServerSide.isHKAH()?row.getValue(27).trim():null));
					System.out.println("[NotifyPatientAppointment -" + row.getValue(12)+"-getPhoneNo]" + phoneNo);
					if (phoneNo != null) {//send sms
						//set the appointment date & time
						startCal.set(Integer.parseInt(row.getValue(9)), Integer.parseInt(row.getValue(8))-1,
								Integer.parseInt(row.getValue(7)), Integer.parseInt(row.getValue(10)),
								Integer.parseInt(row.getValue(11)));

						//set the display name of doctor
						if (ConstantsServerSide.isHKAH()) {
							docTitle = row.getValue(19).length() > 0?row.getValue(19).trim():"";
						} else {
							docTitle = row.getValue(18).length() > 0?row.getValue(18).trim():"";
						}

						if (lang.equals("ENG") || lang.equals("JAP")) {
							if ((row.getValue(17).length() > 0) && ConstantsServerSide.isHKAH()) {
								docName = row.getValue(17);
							} else if ((row.getValue(22).startsWith("OPD")) && ConstantsServerSide.isHKAH()) {
								docName = row.getValue(22);
							} else if ((row.getValue(5).startsWith("DIETITIAN")) && ConstantsServerSide.isTWAH()) {
								docName = row.getValue(5).replace("DIETITIAN","");
							} else {
								docName = row.getValue(5);
							}

							if ((smcid.equals("9") || smcid.equals("12") || smcid.equals("13")) && ConstantsServerSide.isHKAH()) {
								if (lang.equals("JAP")) {
									docName = MessageResources.getMessageJapanese("prompt.sms.fs.dietitianTitle") + docName;
								} else {
									docName = docName + " " + MessageResources.getMessageEnglish("prompt.sms.fs.dietitianTitle");
								}
							} else if ((docTitle.length() > 0 )) {
								docName = docTitle + " " + docName;
							}
						} else if (lang.equals("TRC")) {
							if ((smcid.equals("9") || smcid.equals("12") || smcid.equals("13")) && ConstantsServerSide.isHKAH()) {
								if (row.getValue(6).length() > 0) {
									docName = row.getValue(6);
								} else if (row.getValue(17).length() > 0) {
									docName = row.getValue(17);
								} else {
									docName = row.getValue(5);
								}

								docName = docName + MessageResources.getMessageTraditionalChinese("prompt.sms.fs.dietitianTitle");

							} else if (row.getValue(6).length() > 0) {
								docName = row.getValue(6);
								if (docTitle.length() > 0) {
									if (docTitle.trim().equals("DR.")) {
										docName = docName + MessageResources.getMessageTraditionalChinese("prompt.sms.op.doctitle");
									} else if (docTitle.trim().equals("MS") || docTitle.trim().equals("MISS")) {
										docName = docName + MessageResources.getMessageTraditionalChinese("prompt.sms.op.ms");
									}
								}
							} else {
								if (row.getValue(17).length() > 0 && ConstantsServerSide.isHKAH()) {
									docName = row.getValue(17);
								} else if ((row.getValue(22).startsWith("OPD")) && ConstantsServerSide.isHKAH()) {
									docName = row.getValue(22);
								} else if ((row.getValue(5).startsWith("DIETITIAN")) && ConstantsServerSide.isTWAH()) {
									docName = row.getValue(5).replace("DIETITIAN","");
								} else {
									docName = row.getValue(5);
								}
								if (docTitle.length() > 0) {
									docName = docTitle.trim() + " " + docName;
								}
							}
						} else {
							if ((smcid.equals("9") || smcid.equals("12")|| smcid.equals("13")) && ConstantsServerSide.isHKAH()) {
								if (row.getValue(6).length() > 0) {
									docName = row.getValue(6);
								} else if (row.getValue(17).length() > 0) {
									docName = row.getValue(17);
								} else {
									docName = row.getValue(5);
								}

								docName = docName + MessageResources.getMessageSimplifiedChinese("prompt.sms.fs.dietitianTitle");

							} else if (row.getValue(6).length() > 0) {
								docName = ZHConverter.convert(row.getValue(6), ZHConverter.SIMPLIFIED);
								if (docTitle.length() > 0) {
									if (docTitle.trim().equals("DR.")) {
										docName = docName + MessageResources.getMessageSimplifiedChinese("prompt.sms.op.doctitle");
									} else if (docTitle.trim().equals("MS") || docTitle.trim().equals("MISS")) {
										docName = docName + MessageResources.getMessageSimplifiedChinese("prompt.sms.op.ms");
									}
								}
							} else {
								if (row.getValue(17).length() > 0 && ConstantsServerSide.isHKAH()) {
									docName = row.getValue(17);
								} else if ((row.getValue(22).startsWith("OPD")) && ConstantsServerSide.isHKAH()) {
									docName = row.getValue(22);
								} else if ((row.getValue(5).startsWith("DIETITIAN")) && ConstantsServerSide.isTWAH()) {
									docName = row.getValue(5).replace("DIETITIAN","");
								} else {
									docName = row.getValue(5);
								}
								if (docTitle.length() > 0) {
									docName = docTitle.trim() + " " + docName;
								}
							}
						}

						//set the date time format
						if (lang.equals("ENG")) {
							dateTime = esmf.format(startCal.getTime());
						} else if (lang.equals("TRC")) {
							dateTime = csmf.format(startCal.getTime()).replaceAll("00分", "");
						} else if (lang.equals("SMC")) {
							dateTime = scsmf.format(startCal.getTime()).replaceAll("00分", "");
						} else if (lang.equals("JAP")) {
							dateTime = jcsmf.format(startCal.getTime()).replaceAll("00分", "");
						}

						if (ConstantsServerSide.isHKAH()) {
							smsContent = getSmsContent(row.getValue(14), smcid, lang, docName.toUpperCase(), dateTime, row.getValue(25), patname, patcname);
						} else {
							smsContent = getSmsContent(row.getValue(14), smcid, lang, docName.toUpperCase(), dateTime, row.getValue(24), patname, patcname);
						}

						System.out.println("[NotifyPatientAppointment -" + row.getValue(12) + "-getSmsContent]" + smsContent);
						if (smsContent != null) {
							if (debug) {
								EmailAlertDB.sendEmail(
										"sms.reg.alert",
										"Hong Kong Adventist Hospital - SMS",
										smsContent);
							} else {
								try {
									System.out.println("[NotifyPatientAppointment -" + row.getValue(12) + "-sendSMS]type:" + type
											+ " lang:" + lang + " smcid:" + smcid);

									msgId = UtilSMS.sendSMS("", new String[] { phoneNo },
											smsContent,
											type, row.getValue(12), lang, smcid);

									if (getSuccessOfSMS(msgId)) {
										updateSuccessTimeAndMsg_Booking4Patient(row.getValue(12), msgId, true);
										updateSendTime(row.getValue(12));
									}

									if (row.getValue(14) != null && row.getValue(14).length() > 0) {
										updateSuccessTimeAndMsg_PatientActivity(serverIP, row.getValue(14), msgId, true);
									}

									if (sendEmail) {
										if (row.getValue(24).length() > 0) {
											if (UtilMail.sendMail(
													"regdesk@hkah.org.hk",
													new String[] { row.getValue(24) },
													null,
													null,
													"Hong Kong Adventist Hospital - Reminder",
													smsContent, false)) {
												UtilMail.insertEmailLog(null, row.getValue(12),
													"OUTPAT", "APPTREMINDER", true, "");
											} else {
												UtilMail.insertEmailLog(null, row.getValue(12),
													"OUTPAT", "APPTREMINDER", false, "");
											}
										}
									}
								} catch (Exception e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
							}
						} else {
							if (!debug) {
								UtilSMS.saveLog("Cannot find any template",
										row.getValue(12), type, lang, smcid);
								updateErrorMsg(row.getValue(12), "BKERR08");
							}
						}
					}
				}
			}
		}

		EmailAlertDB.sendEmail(
				"appointment.sms",
				"Hong Kong Adventist Hospital - SMS",
				"SMS SCHEDULE START - " + currentCal.getTime() +"<br/><br/>" +
				"BOOKING DATE - " + startCal.getTime());
	}

	//======================================================================
	private static boolean isHolidayAndDisableSMS(Calendar date) {
		StringBuffer sqlStr = new StringBuffer();
		SimpleDateFormat smf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);

		sqlStr.append("SELECT 1 ");
		sqlStr.append("FROM EL_PUBLIC_HOLIDAY ");
		sqlStr.append("WHERE EL_SITE_CODE = ? ");
		sqlStr.append("AND TO_CHAR(EL_HOLIDAY, 'DD/MM/YYYY') = ? ");
		sqlStr.append("AND EL_SMS_ENABLE = 0 ");

		return (UtilDBWeb.isExist(sqlStr.toString(), new String[] { ConstantsServerSide.SITE_CODE, smf.format(date.getTime()) }));
	}

	//======================================================================
	private static boolean isSentSMS(Calendar date) {
		StringBuffer sqlStr = new StringBuffer();
		Calendar currentCal = Calendar.getInstance();
		SimpleDateFormat smf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
		currentCal.add(Calendar.DATE, -7);

		sqlStr.append("SELECT 1 FROM ( ");
		sqlStr.append("SELECT BKGSDATE FROM BOOKING@IWEB B, ");
		sqlStr.append("(SELECT KEY_ID FROM SMS_LOG S WHERE S.ACT_TYPE = 'OUTPAT' ");
		sqlStr.append("AND S.SEND_TIME >= TO_DATE('" + smf.format(currentCal.getTime()) + " 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		//sqlStr.append("AND S.SUCCESS = 1 ");
		sqlStr.append("ORDER BY S.SEND_TIME DESC) S ");
		sqlStr.append("WHERE B.BKGID = S.KEY_ID ");
		sqlStr.append("AND B.BKGSDATE >= TO_DATE('" + smf.format(date.getTime()) + " 00:00:00', 'DD/MM/YYYY HH24:MI:SS')) ");
		sqlStr.append("WHERE ROWNUM = 1 ");

		return (UtilDBWeb.isExist(sqlStr.toString()));
	}

	//======================================================================
	public static String getPhoneNo(String phoneNo, String couCode, String patNo,
							String bkgId, String lang, String smcId, String type, String mobCouCode) {
		String countryCode = null;
			if (!"".equals(mobCouCode) && mobCouCode != null) {
				countryCode = mobCouCode;
			} else if (!"".equals(couCode) && couCode != null) {
				countryCode = couCode;
			}
			System.out.println("[NotifyPatientAppointment 556-" + bkgId + "]CountryCode:" + countryCode + " PhoneNo:" + phoneNo);
		if (patNo != null && patNo.length() > 0) {
			if (phoneNo != null && phoneNo.length() > 0) {
				if (ConstantsServerSide.isHKAH() &&(countryCode != null && countryCode.length() > 0)) {
					if (countryCode.equals("852") || countryCode.equals("853")) {
						if (phoneNo.length() == 8) {
							//send
							return countryCode+phoneNo;
						} else {
							//error
							UtilSMS.saveLog("The country code is 852/853, but the phone no. is not 8 digits",
										bkgId, type, lang, smcId);
							updateErrorMsg(bkgId, "BKERR01");
							return null;
						}
					} else if (couCode.equals("86")) {
						if (phoneNo.substring(0, 1).equals("1") && phoneNo.length() == 11) {
							return countryCode+phoneNo;
						} else {
							UtilSMS.saveLog("The country code is 86, but first letter of phone no. is not ''1'' or the phone no. is not 11 digits",
									bkgId, type, lang, smcId);
							updateErrorMsg(bkgId, "BKERR02");
							return null;
						}
					} else {
						// sms not restricting country in SR
						return countryCode+phoneNo;

						/*UtilSMS.saveLog("The country code is not 852/853/86",
								bkgId, type, lang, smcId);
						updateErrorMsg(bkgId, "BKERR03");
						return null;*/
					}
				} else if (ConstantsServerSide.isTWAH()) {
					if (phoneNo.length() == 8) {
						return "852"+phoneNo;
					} else {
						return phoneNo;
					}
				} else {
					UtilSMS.saveLog("Country Code is empty value",
							bkgId, type, lang, smcId);
					updateErrorMsg(bkgId, "BKERR04");
					return null;
				}
			} else {
				UtilSMS.saveLog("Phone No. is empty value",
						bkgId, type, lang, smcId);
				updateErrorMsg(bkgId, "BKERR05");
				return null;
			}
		} else {
			if (phoneNo != null && phoneNo.length() > 0) {
				if (phoneNo.length() == 8) {
					return "852"+phoneNo;
				} else if (phoneNo.length() > 8) {
					if (phoneNo.substring(0, 3).equals("861") && phoneNo.length() == 13) {
						return phoneNo;
					} else if (phoneNo.substring(0, 3).equals("853") && phoneNo.length() == 11) {
						return phoneNo;
					} else {
						if (!ConstantsServerSide.isHKAH()) {
							UtilSMS.saveLog("Phone No. is greater than 8 digits, but it does not belong to 86 or 853",
									bkgId, type, lang, smcId);
							updateErrorMsg(bkgId, "BKERR06");
							return null;
						} else {
							//not restricting country
							return phoneNo;
						}
					}
				} else {
					UtilSMS.saveLog("Phone No. is less than 8 digits",
							bkgId, type, lang, smcId);
					updateErrorMsg(bkgId, "BKERR07");
					return null;
				}
			} else {
				UtilSMS.saveLog("Phone No. is empty value",
						bkgId, type, lang, smcId);
				updateErrorMsg(bkgId, "BKERR05");
				return null;
			}
		}
	}

	//======================================================================
	private static String getSmsContent(String patNo, String smcid, String lang,
			String docName, String dateTime, String spcCode, String patname, String patcname) {
		String smsContent = null;
		if (ConstantsServerSide.isHKAH()) {
		if (smcid.equals("5") || smcid.equals("6") || smcid.equals("7") || smcid.equals("8") || smcid.equals("10")) {
			if ((patNo == null) || patNo.length() <= 0) {
			smsContent = null;
			} else {
			smsContent = getRehabTemplate( lang, docName, dateTime, smcid);
			}
		} else if (smcid.equals("9") ||smcid.equals("12") || smcid.equals("13")) {
			if ((patNo == null) || patNo.length() <= 0) {
			smsContent =  null;
			} else {
				if (smcid.equals("9")) {
				smsContent =  getFSTemplate( lang, docName, dateTime);
				} else if (smcid.equals("13")) {
				smsContent =  getLMCTemplate( lang, docName, dateTime);
				} else {
				smsContent =  getFS7Template( lang, docName, dateTime);
				}
			}
		} else if (smcid.equals("11")) {
			if ((patNo == null) || patNo.length() <= 0) {
			smsContent =  getnewDentalTemplate(docName, dateTime);
			} else {
			smsContent =  getDentalTemplate( lang, docName, dateTime);
			}
		} else if (smcid.equals("1") || smcid.equals("2") || smcid.equals("3") || smcid.equals("4")) {
			if ((patNo == null) || patNo.length() <= 0) {
			smsContent =  getnewPatientTemplate(docName, dateTime, spcCode);
			} else if (smcid.equals("1")) {
			if (docName.startsWith("OPD") || docName.startsWith("WOUND") ) {
			smsContent =  getOPDRegTemplate(lang,dateTime);
			} else {
				smsContent =  getRegDeskTemplate((patNo == null), lang, docName, dateTime, spcCode);
			}
			} else if (smcid.equals("2")) {
			smsContent =  getHCTemplate((patNo == null), lang, docName, dateTime);
			} else if (smcid.equals("3")) {
			smsContent =  getHATemplate((patNo == null), lang, docName, dateTime);
			} else if (smcid.equals("4")) {
			smsContent =  getOncologyTemplate((patNo == null), lang, docName, dateTime);
			} else {
			smsContent =  null;
			}
		 }
		} else { //TW
			if (smcid.equals("1") || smcid.equals("2")) {
			smsContent =  getWCTemplate(lang, docName, dateTime);
			} else if (smcid.equals("3") || smcid.equals("4")) {
			smsContent =  getFD1Template(lang, docName, dateTime, patname, patcname);
			} else if (smcid.equals("5") || smcid.equals("6")) {
			smsContent =  getFD3Template(lang, docName, dateTime, patname, patcname);
			} else {
			smsContent =  getWCTemplate(lang, docName, dateTime);
			}
		}

		if (isAppendSMS("ICSMS","ISAPPEND")) {
			if (smcid.equals("1") || smcid.equals("2") ) {
				smsContent =  smsContent + getICTemplate(lang);
			} else {
				smsContent =  smsContent + getICOtherTemplate(lang);
			}
		}

		return smsContent;
	}

	//======================================================================

	private static String getICTemplate(String lang) {
		StringBuffer smsContent = new StringBuffer();
		if (lang.equals("ENG")) {
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.ic"));
		} else if (lang.equals("TRC")) {
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.ic"));
		} else if (lang.equals("SMC")) {
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.ic"));
		} else if (lang.equals("JAP")) {
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.ic"));
		}

		return smsContent.toString();
	}

	private static String getICOtherTemplate(String lang) {
		StringBuffer smsContent = new StringBuffer();
		if (lang.equals("ENG")) {
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.ic.other"));
		} else if (lang.equals("TRC")) {
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.ic.other"));
		} else if (lang.equals("SMC")) {
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.ic.other"));
		} else if (lang.equals("JAP")) {
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.ic.other"));
		}

		return smsContent.toString();
	}

	private static String getRehabTemplate( String lang, String docName, String dateTime, String smcid) {
		StringBuffer smsContent = new StringBuffer();
		String link = "https://mail.hkah.org.hk/online/documentManage/download.jsp?documentID=";
		if (smcid.equals("5")) {
			link = link + "623";
		} else if (smcid.equals("6")) {
			link = link + "624";
		} else if (smcid.equals("7")) {
			link = link + "625";
		} else if (smcid.equals("8")) {
			link = link + "626";
		}

		if (lang.equals("ENG")) {
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.rehab.block1"));
			smsContent.append(" " + dateTime + ".");
			if (smcid.equals("5") || smcid.equals("6") || smcid.equals("7") || smcid.equals("8")) {
				smsContent.append(MessageResources.getMessageEnglish("prompt.sms.rehab.block2a"));
				smsContent.append(" " + link + " ");
				smsContent.append(MessageResources.getMessageEnglish("prompt.sms.rehab.block2b"));
				smsContent.append(MessageResources.getMessageEnglish("prompt.sms.rehab.block3a"));
			}
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.rehab.block3b"));
		} else if (lang.equals("TRC")) {
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.rehab.block1"));
			smsContent.append(" " + dateTime + "。");
			if (smcid.equals("5") || smcid.equals("6") || smcid.equals("7") || smcid.equals("8")) {
				smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.rehab.block2"));
				smsContent.append(" " + link + "。");
				smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.rehab.block3a"));
			}
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.rehab.block3b"));
		} else if (lang.equals("SMC")) {
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.rehab.block1"));
			smsContent.append(" " + dateTime + "。");
			if (smcid.equals("5") || smcid.equals("6") || smcid.equals("7") || smcid.equals("8")) {
				smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.rehab.block2"));
				smsContent.append(" " + link + "。");
				smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.rehab.block3a"));
			}
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.rehab.block3b"));
		} else if (lang.equals("JAP")) {
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.rehab.block1"));
			smsContent.append(" " + dateTime + ".");
			if (smcid.equals("5") || smcid.equals("6") || smcid.equals("7") || smcid.equals("8")) {
				smsContent.append(MessageResources.getMessageJapanese("prompt.sms.rehab.block2a"));
				smsContent.append(" " + link + " ");
				smsContent.append(MessageResources.getMessageJapanese("prompt.sms.rehab.block2b"));
				smsContent.append(MessageResources.getMessageJapanese("prompt.sms.rehab.block3a"));
			}
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.rehab.block3b"));
		}
		return smsContent.toString();
	}

	//======================================================================
	private static String getFSTemplate( String lang, String docName, String dateTime) {
		StringBuffer smsContent = new StringBuffer();

		if (lang.equals("ENG")) {
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.fs.block1"));
			smsContent.append(" " + docName + " ");
			smsContent.append("" + dateTime + ". ");
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.fs.block2"));
		} else if (lang.equals("TRC")) {
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.fs.block1"));
			smsContent.append("" + docName + ", ");
			smsContent.append("" + dateTime + ". ");
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.fs.block2"));
		} else if (lang.equals("SMC")) {
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.fs.block1"));
			smsContent.append("" + docName + ", ");
			smsContent.append("" + dateTime + ". ");
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.fs.block2"));
		} else if (lang.equals("JAP")) {
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.fs.block1"));
			smsContent.append("" + docName + "、");
			smsContent.append("" + dateTime + ". ");
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.fs.block2"));
		}
		return smsContent.toString();
	}

	private static String getFS7Template( String lang, String docName, String dateTime) {
		StringBuffer smsContent = new StringBuffer();

		if (lang.equals("ENG")) {
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.fs7.block1"));
			smsContent.append(" " + docName + " ");
			smsContent.append("" + dateTime + ". ");
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.fs7.block2"));
		} else if (lang.equals("TRC")) {
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.fs7.block1"));
			smsContent.append("" + docName + ", ");
			smsContent.append("" + dateTime + ". ");
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.fs7.block2"));
		} else if (lang.equals("SMC")) {
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.fs7.block1"));
			smsContent.append("" + docName + ", ");
			smsContent.append("" + dateTime + ". ");
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.fs7.block2"));
		} else if (lang.equals("JAP")) {
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.fs7.block1"));
			smsContent.append("" + docName + "、");
			smsContent.append("" + dateTime + ". ");
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.fs7.block2"));
		}
		return smsContent.toString();
	}
	//======================================================================
	private static String getLMCTemplate( String lang, String docName, String dateTime) {
		StringBuffer smsContent = new StringBuffer();

		if (lang.equals("ENG")) {
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.lmc.block1"));
			smsContent.append(" " + docName + " ");
			smsContent.append("" + dateTime + ". ");
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.lmc.block2"));
		} else if (lang.equals("TRC")) {
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.lmc.block1"));
			smsContent.append("" + docName + ", ");
			smsContent.append("" + dateTime + ". ");
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.lmc.block2"));
		} else if (lang.equals("SMC")) {
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.lmc.block1"));
			smsContent.append("" + docName + ", ");
			smsContent.append("" + dateTime + ". ");
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.lmc.block2"));
		} else if (lang.equals("JAP")) {
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.lmc.block1"));
			smsContent.append("" + docName + "、");
			smsContent.append("" + dateTime + ". ");
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.lmc.block2"));
		}
		return smsContent.toString();
	}

	//======================================================================
	private static String getnewDentalTemplate(String docName, String dateTime) {
		StringBuffer smsContent = new StringBuffer();

		smsContent.append(MessageResources.getMessageEnglish("prompt.sms.dental.newpatient.block1"));
		smsContent.append(" ");
		smsContent.append(docName);
		smsContent.append(" ");
		smsContent.append(dateTime);
		smsContent.append(MessageResources.getMessageEnglish("prompt.sms.dental.newpatient.block2"));

		return smsContent.toString();
	}

	private static String getDentalTemplate(String lang, String docName, String dateTime) {
		StringBuffer smsContent = new StringBuffer();

		if (lang.equals("ENG")) {
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.dental.block1"));
			smsContent.append(" ");
			smsContent.append(docName);
			smsContent.append(" ");
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.dental.block2"));
		} else if (lang.equals("TRC")) {
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.dental.block1"));
			smsContent.append(docName);
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.dental.block2"));
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.dental.block3"));
		} else if (lang.equals("SMC")) {
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.dental.block1"));
			smsContent.append(docName);
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.dental.block2"));
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.dental.block3"));
		} else if (lang.equals("JAP")) {
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.dental.block1"));
			smsContent.append(docName);
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.dental.block2"));
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.dental.block3"));
		}

		return smsContent.toString();
	}

	//======================================================================
	private static String getnewPatientTemplate(String docName, String dateTime, String spcCode) {
		StringBuffer smsContent = new StringBuffer();

		smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.newpatient.block1"));
		smsContent.append(" ");
		smsContent.append(docName);
		smsContent.append(" ");
		smsContent.append(dateTime);
		smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.newpatient.block2"));
		if (isSpecialSpec("IS1F", spcCode)) {
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.newpatient.block3"));
		}
		smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.newpatient.block4"));

		return smsContent.toString();
	}

	//======================================================================
	private static String getOncologyTemplate(boolean newPatient, String lang,
												String docName, String dateTime) {
		StringBuffer smsContent = new StringBuffer();

		if (lang.equals("ENG")) {
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.oncology.block1"));
			smsContent.append(" ");
			smsContent.append(docName);
			smsContent.append(" ");
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.oncology.block2"));
		} else if (lang.equals("TRC")) {
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.oncology.block1"));
			smsContent.append(docName);
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.oncology.block2"));
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.oncology.block3"));
		} else if (lang.equals("SMC")) {
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.oncology.block1"));
			smsContent.append(docName);
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.oncology.block2"));
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.oncology.block3"));
		} else if (lang.equals("JAP")) {
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.oncology.block1"));
			smsContent.append(dateTime);
			smsContent.append(" ");
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.oncology.block2"));
			smsContent.append(docName);
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.oncology.block3"));
		}

		return smsContent.toString();
	}

	//======================================================================
	private static String getHATemplate(boolean newPatient, String lang, String docName,
										String dateTime) {
		StringBuffer smsContent = new StringBuffer();

		if (lang.equals("ENG")) {
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.ha.block1"));
			smsContent.append(" ");
			smsContent.append(docName);
			smsContent.append(" ");
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.ha.block2"));
		} else if (lang.equals("TRC")) {
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.ha.block1"));
			smsContent.append(docName);
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.ha.block2"));
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.ha.block3"));
		} else if (lang.equals("SMC")) {
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.ha.block1"));
			smsContent.append(docName);
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.ha.block2"));
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.ha.block3"));
		} else if (lang.equals("JAP")) {
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.ha.block1"));
			smsContent.append(docName);
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.ha.block2"));
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.ha.block3"));
		}

		return smsContent.toString();
	}

	//======================================================================
	private static String getHCTemplate(boolean newPatient, String lang, String docName,
										String dateTime) {
		StringBuffer smsContent = new StringBuffer();

		if (lang.equals("ENG")) {
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.hc.block1"));
			smsContent.append(" ");
			smsContent.append(docName);
			smsContent.append(" ");
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.hc.block2"));
		} else if (lang.equals("TRC")) {
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.hc.block1"));
			smsContent.append(docName);
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.hc.block2"));
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.hc.block3"));
		} else if (lang.equals("SMC")) {
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.hc.block1"));
			smsContent.append(docName);
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.hc.block2"));
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.hc.block3"));
		} else if (lang.equals("JAP")) {
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.hc.block1"));
			smsContent.append(docName);
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.hc.block2"));
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.hc.block3"));
		}

		return smsContent.toString();
	}

	private static String getRegDeskTemplate(boolean newPatient, String lang,
											String docName, String dateTime, String spcCode) {
		StringBuffer smsContent = new StringBuffer();

		if (lang.equals("ENG")) {
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.reg.block1"));
			smsContent.append(" ");
			smsContent.append(docName);
			smsContent.append(" ");
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.reg.block2"));
			if (isSpecialSpec("IS1F", spcCode)) {
				smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.reg.block3"));
			}
			if (isSpecialSpec("ISGF", spcCode)) {
				smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.reg.block3.gf"));
			}
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.reg.block4"));
		} else if (lang.equals("TRC")) {
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.reg.block1"));
			smsContent.append(docName);
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.reg.block2"));
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.reg.block3"));
			if (isSpecialSpec("IS1F", spcCode)) {
				smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.reg.block4"));
			}
			if (isSpecialSpec("ISGF", spcCode)) {
				smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.reg.block4.gf"));
			}
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.reg.block5"));
		} else if (lang.equals("SMC")) {
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.reg.block1"));
			smsContent.append(docName);
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.reg.block2"));
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.reg.block3"));
			if (isSpecialSpec("IS1F", spcCode)) {
				smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.reg.block4"));
			}
			if (isSpecialSpec("IS1F", spcCode)) {
				smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.reg.block4.gf"));
			}
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.reg.block5"));
		} else if (lang.equals("JAP")) {
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.reg.block1"));
			smsContent.append(docName);
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.reg.block2"));
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.reg.block3"));
			if (isSpecialSpec("IS1F", spcCode)) {
				smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.reg.block4"));
			} else if (isSpecialSpec("ISGF", spcCode)) {
				smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.reg.block4.gf"));
			} else {
				smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.reg.block5"));
			}
		}

		return smsContent.toString();
	}

	private static String getOPDRegTemplate(String lang, String dateTime) {
		StringBuffer smsContent = new StringBuffer();

		if (lang.equals("ENG")) {
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.opdreg.block1"));
			smsContent.append(" ");
			smsContent.append(dateTime+". ");
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.opdreg.block2"));
		} else if (lang.equals("TRC")) {
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.opdreg.block1"));
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.opdreg.block2"));
		} else if (lang.equals("SMC")) {
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.opdreg.block1"));
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.opdreg.block2"));
		} else if (lang.equals("JAP")) {
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.opdreg.block1"));
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.opdreg.block2"));
		}

		return smsContent.toString();
	}

	private static String getWCTemplate(String lang, String docName, String dateTime) {
		StringBuffer smsContent = new StringBuffer();

		if (lang.equals("ENG")) {
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.wc.app.block1"));
			smsContent.append(" ");
			smsContent.append(docName);
			smsContent.append(" ");
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.wc.app.block2"));
		} else if (lang.equals("TRC")) {
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.wc.app.block1"));
			smsContent.append(" ");
			smsContent.append(docName);
			smsContent.append(" ");
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.wc.app.block2"));
		}

		return smsContent.toString();
	}

	private static String getFD1Template(String lang, String docName, String dateTime, String patname, String patcname) {
		StringBuffer smsContent = new StringBuffer();

		if (lang.equals("ENG")) {
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.fd1.app.block1"));
			smsContent.append(" ");
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.fd1.app.block2"));
			smsContent.append(" ");
			smsContent.append(patname);
			smsContent.append(" ");
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.fd1.app.block3"));
			smsContent.append(" ");
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.fd1.app.block4"));
		} else if (lang.equals("TRC")) {
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.fd1.app.block1"));
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.fd1.app.block2"));
			smsContent.append(" ");
			smsContent.append(patcname);
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.fd1.app.block3"));
			smsContent.append(" ");
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.fd1.app.block4"));
		}

		return smsContent.toString();
	}

	private static String getFD3Template(String lang, String docName, String dateTime, String patname, String patcname) {
		StringBuffer smsContent = new StringBuffer();

		if (lang.equals("ENG")) {
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.fd3.app.block1"));
			smsContent.append(" ");
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.fd3.app.block2"));
			smsContent.append(" ");
			smsContent.append(patname);
			smsContent.append(" ");
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.fd3.app.block3"));
			smsContent.append(" ");
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.fd3.app.block4"));
		} else if (lang.equals("TRC")) {
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.fd3.app.block1"));
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.fd3.app.block2"));
			smsContent.append(" ");
			smsContent.append(patname);
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.fd3.app.block3"));
			smsContent.append(" ");
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.fd3.app.block4"));
		}

		return smsContent.toString();
	}

	//======================================================================
	private static boolean updateSendTime(String id) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("UPDATE BOOKING@IWEB ");
		sqlStr.append("SET SMSSDT = SYSDATE ");
		sqlStr.append("WHERE BKGID = '"+id+"' ");

		//System.out.println("--------------Notify Patient Appointment (updateSendTime)--------------");
		//System.out.println(sqlStr.toString());
		//System.out.println("-----------------------------------------------------------------------");

		return UtilDBWeb.updateQueue(sqlStr.toString());
	}

	//======================================================================
	private static boolean getSuccessOfSMS(String msgId) {
		StringBuffer sql_getSuccessStats = new StringBuffer();

		sql_getSuccessStats.append("SELECT SUCCESS ");
		sql_getSuccessStats.append("FROM SMS_LOG ");
		sql_getSuccessStats.append("WHERE MSG_BATCH_ID = '"+msgId+"' ");

		ArrayList record = UtilDBWeb.getReportableList(sql_getSuccessStats.toString());
		ReportableListObject row = null;

		if (record.size() > 0) {
			row = (ReportableListObject)record.get(0);

			return row.getValue(0).equals("1");
		} else {
			return false;
		}
	}

	//======================================================================
	private static boolean updateErrorMsg(String id, String msg) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("UPDATE BOOKING@IWEB ");
		sqlStr.append("SET SMSRTNMSG = '"+msg+"' ");
		sqlStr.append("WHERE BKGID = '"+id+"' ");

		//System.out.println("--------------Notify Patient Appointment (updateErrorMsg)--------------");
		//System.out.println(sqlStr.toString());
		//System.out.println("-----------------------------------------------------------------------");

		return UtilDBWeb.updateQueue(sqlStr.toString());
	}

	//======================================================================
	private static boolean updateSuccessTimeAndMsg_Booking4Patient(String bkgid, String msgId, boolean success) {
		if (success) {
			return UtilDBWeb.updateQueue(sqlStr_updateSMSReturnMsg_Booking4Patient_Success, new String[] {msgId, msgId, bkgid});
		} else {
			return UtilDBWeb.updateQueue(sqlStr_updateSMSReturnMsg_Booking4Patient_Sent, new String[] {msgId, msgId, bkgid});
		}
	}

	//======================================================================
	private static boolean updateSuccessTimeAndMsg_PatientActivity(String serverIP, String patNo, String msgId, boolean success) {
		if (success) {
			return UtilDBWeb.updateQueue(sqlStr_updateSMSReturnMsg_PatientActivity_Success, new String[] {patNo, msgId, serverIP, msgId});
		} else {
			return UtilDBWeb.updateQueue(sqlStr_updateSMSReturnMsg_PatientActivity_Sent, new String[] {patNo, serverIP});
		}
	}

	static {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE BOOKING@IWEB ");
		sqlStr.append("SET SMSSDTOK = (SELECT SEND_TIME FROM SMS_LOG WHERE MSG_BATCH_ID = ?), ");
		sqlStr.append("    SMSRTNMSG = (SELECT RES_MSG FROM SMS_LOG WHERE MSG_BATCH_ID = ?), ");
		sqlStr.append("    SMSSDT = SYSDATE ");
		sqlStr.append("WHERE BKGID = ? ");
		sqlStr_updateSMSReturnMsg_Booking4Patient_Success = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE BOOKING@IWEB ");
		sqlStr.append("SET SMSSDTOK = 'SENT', ");
		sqlStr.append("    SMSSDT = SYSDATE ");
		sqlStr.append("WHERE BKGID = ? ");
		sqlStr_updateSMSReturnMsg_Booking4Patient_Sent = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO PATIENT_ACTIVITY_LOG@IWEB (PATNO, MODULE, ACTION_TYPE, REMARK, PCNAME, CREATED_USER, UPDATED_USER, ACTION_USER, ACTION_DATE) ");
		sqlStr.append("VALUES (?, 'SMS', 'BOOKING', (SELECT RES_MSG FROM SMS_LOG WHERE MSG_BATCH_ID = ?), ?, 'SYSTEM', 'SYSTEM', 'SYSTEM', (SELECT SEND_TIME FROM SMS_LOG WHERE MSG_BATCH_ID = ?)) ");
		sqlStr_updateSMSReturnMsg_PatientActivity_Success = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO PATIENT_ACTIVITY_LOG@IWEB (PATNO, MODULE, ACTION_TYPE, REMARK, PCNAME, CREATED_USER, UPDATED_USER, ACTION_USER, ACTION_DATE) ");
		sqlStr.append("VALUES (?, 'SMS', 'BOOKING', 'SENT', ?, 'SYSTEM', 'SYSTEM', 'SYSTEM', SYSDATE) ");
		sqlStr_updateSMSReturnMsg_PatientActivity_Sent = sqlStr.toString();
	}
}