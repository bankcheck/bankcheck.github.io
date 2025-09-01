package com.hkah.web.schedule;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Locale;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.sms.UtilSMS;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.EmailAlertDB;

public class NotifyPatientRecall implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		System.out.println("===== NotifyPatientRecall v1.20 Start =====");
		sendSMS(false);
		System.out.println("===== NotifyPatientRecall End =====");
	}

	// ======================================================================
	public static ArrayList getSMSList(SimpleDateFormat smf, Calendar startCal, Calendar endCal) {

		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT P.MOTHCODE, P.PATSMS,	P.PATNO, A.SEQNO, "); //0, 1, 2, 3,
		sqlStr.append(" P.PATPAGER, P.COUCODE, P.PATEMAIL, A.TYPE, "); //4, 5, 6, 7
		sqlStr.append(" TO_CHAR(A.PROPOSAL_DATE, 'DD'), TO_CHAR(A.PROPOSAL_DATE, 'MM'), ");//8, 9
		sqlStr.append(" TO_CHAR(A.PROPOSAL_DATE, 'YYYY'), TO_CHAR(A.PROPOSAL_DATE, 'HH24'), ");//10. 11
		sqlStr.append(" TO_CHAR(A.PROPOSAL_DATE, 'MI') ");//12
		sqlStr.append(" FROM PATIENT@IWEB P, PR_APPOINTMENT@CIS A ");
		
		sqlStr.append(" WHERE P.PATNO = A.PATNO ");
		sqlStr.append(" AND P.DEATH IS NULL "); 
		sqlStr.append(" AND A.SMS_STATUS IS NULL "); 
		sqlStr.append(" AND A.TYPE <> 'Wellness-PC' "); 		
		sqlStr.append(" AND TO_CHAR(A.PROPOSAL_DATE, 'YYYYMMDD') <= TO_CHAR(SYSDATE, 'YYYYMMDD') ");
		
		return UtilDBWeb.getReportableList(sqlStr.toString());	
	}

	// ======================================================================
/*
	public static boolean isSmsScheduleDay(Calendar startCal) {
		//check whether today is saturday or holiday with disable sms setting
		if (startCal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY ||
					isHolidayAndDisableSMS(startCal)) {
			return false;
		}
		return true;
	}
*/
	// ======================================================================
	public static Calendar getRecallDay(Calendar startCal, boolean ignoreSentDate) {
		// check whether today is thur or fri, then use T+3 to get the booking date

		/*		
		if (startCal.get(Calendar.DAY_OF_WEEK) == Calendar.THURSDAY ||
					startCal.get(Calendar.DAY_OF_WEEK) == Calendar.FRIDAY) {
			startCal.add(Calendar.DATE, 3);
		} else {
			//otherwise, use T+2 to get the booking date
			startCal.add(Calendar.DATE, 2);
		}

		//check whether the booking date is holiday with disable sms setting
		while(startCal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY ||
					isHolidayAndDisableSMS(startCal) ) {
			startCal.add(Calendar.DATE, 1);
		}
*/
		// set specific day (yyyy, m, d)
		// m is current month - 1, example: April = 3
		// startCal.set(2014, 3, 9);
		return startCal;
	}

	//======================================================================
/*
	private static boolean setSendSMSDate(Calendar date) {
		StringBuffer sqlStr = new StringBuffer();
		SimpleDateFormat smf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);

		sqlStr.append("UPDATE BOOKING@IWEB ");
		sqlStr.append("SET SMSSDT = NULL, SMSSDTOK = NULL, SMSRTNMSG = NULL ");
		sqlStr.append("WHERE BKGSDATE >= TO_DATE('"+smf.format(date.getTime())+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		//sqlStr.append("AND BKGSDATE <= TO_DATE('"+smf.format(date.getTime())+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");

		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
*/

	// ======================================================================
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
//		SimpleDateFormat esmf = new SimpleDateFormat("'on' EEE, MMM dd, yyyy' at 'h:mm a", Locale.ENGLISH);
		SimpleDateFormat esmf = new SimpleDateFormat("'on' EEE, MMM dd, yyyy", Locale.ENGLISH);
		SimpleDateFormat csmf = new SimpleDateFormat("M月dd日", Locale.CHINESE);
		SimpleDateFormat scsmf = new SimpleDateFormat("M月dd日", Locale.SIMPLIFIED_CHINESE);
		SimpleDateFormat jcsmf = new SimpleDateFormat("M月dd日", Locale.JAPAN);

		// Send SMS any day
/* 
		if (!isSmsScheduleDay(startCal)) {
			return;
		}
*/

		startCal = getRecallDay(startCal, ignoreSentDate);
		endCal = getRecallDay(endCal, ignoreSentDate);

		// startCal.set(2014, 5, 13);
		// endCal.set(2014, 5, 13);

		ArrayList record = getSMSList(smf, startCal, endCal);
		ReportableListObject row = null;
		if (record.size() > 0) {
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);

				String msgId = null;
				String lang = row.getValue(0);
				String dateTime = "";
				String smsContent = null;
				
				String recallType = row.getValue(7);
				String patNo = row.getValue(2);
				String seqNo = row.getValue(3);

				// String type = UtilSMS.SMS_OUTPAT;				
				String type = UtilSMS.SMS_INPAT_DOCNUM;
				
				if ("Dental-teeth cleansing".equals(recallType))
					type = UtilSMS.SMS_TWDENT;
				
				if ("Dental-follow up".equals(recallType))
					type = UtilSMS.SMS_TWDENT;
				
				if ("amc2".equals(ConstantsServerSide.SITE_CODE))				
					type = UtilSMS.SMS_AMC2;

				if (lang.length() <= 0) {
					lang = "ENG";
				}

				String phoneNo = getPhoneNo(row.getValue(4).trim(), row.getValue(5).trim(), patNo, seqNo, lang, type);

				if (phoneNo != null) {// send sms
					// set the Recall date & time
					startCal.set(Integer.parseInt(row.getValue(10)), Integer.parseInt(row.getValue(9)) - 1,
							Integer.parseInt(row.getValue(8)), Integer.parseInt(row.getValue(11)),
							Integer.parseInt(row.getValue(12)));

					// set the date time format
/*
					if (lang.equals("ENG")) {
						dateTime = esmf.format(startCal.getTime());
					} else if (lang.equals("TRC")) {
						dateTime = csmf.format(startCal.getTime()).replaceAll("00分", "");
					} else if (lang.equals("SMC")) {
						dateTime = scsmf.format(startCal.getTime()).replaceAll("00分", "");
					} else if (lang.equals("JAP")) {
						dateTime = jcsmf.format(startCal.getTime()).replaceAll("00分", "");
					}
*/
					dateTime = esmf.format(startCal.getTime());
					smsContent = getSmsContent(recallType);

					// targetPhone="91603748";//prevent send sms during testing

					if (smsContent != null) {

						if (debug) {
							EmailAlertDB.sendEmail("sms.alert", "Hong Kong Adventist Hospital - SMS(Patient Recall)",
									smsContent);
						} else {
							try {
								msgId = UtilSMS.sendSMS("", new String[] { phoneNo },
										smsContent,
										type, patNo + ":" + seqNo, lang, "PRS@CIS");

								if (getSuccessOfSMS(msgId)) {
									updateSuccessTimeAndMsg(patNo, seqNo, msgId, phoneNo);
									updateSendTime(patNo, seqNo);
								}
							
								ArrayList<ReportableListObject> extraMessage = getSmsContentExtra( recallType );
								
								if ( (extraMessage != null) && (extraMessage.size() > 0) ) {
									for (int j = 0; j < extraMessage.size(); j++) {
										row = (ReportableListObject) extraMessage.get(j);
										smsContent =  row.getValue(0);
										
										if (smsContent != null) {
											msgId = UtilSMS.sendSMS("", new String[] { phoneNo },
													smsContent,
													type, patNo + ":" + seqNo, lang, "PRS@CIS");

											if (getSuccessOfSMS(msgId)) {
												updateSuccessTimeAndMsg(patNo, seqNo, msgId, phoneNo);
												updateSendTime(patNo, seqNo);
											}
										}										
									}
								}
							
							} catch (Exception e) {
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
							
						}
					} else {
						String msg = "Message template not found for message type: " + recallType;
						UtilSMS.saveLog(msg, patNo + ":" + seqNo, type, lang, "PRS@CIS");
						updateErrorMsg(patNo, seqNo, msg);
					}
			
				} else {
					String msg = "Patient mobile number not found";
					UtilSMS.saveLog(msg, patNo + ":" + seqNo, type, lang, "PRS@CIS");
					updateErrorMsg(patNo, seqNo, msg);
				}
			}
		}

		EmailAlertDB.sendEmail(
				"sms.alert",
				"Hong Kong Adventist Hospital - SMS(Patient Recall)",
				"SMS SCHEDULE START - " + currentCal.getTime() + "<br/><br/>" +
				"PATIENT RECALL DATE - " + startCal.getTime());

	}

	//======================================================================
/*	
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
*/
	//======================================================================
/*
	private static boolean isSentSMS(Calendar date) {
		StringBuffer sqlStr = new StringBuffer();
		Calendar currentCal = Calendar.getInstance();
		SimpleDateFormat smf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
		currentCal.add(Calendar.DATE, -7);

		sqlStr.append("SELECT 1 FROM ( ");
		sqlStr.append("SELECT BKGSDATE FROM BOOKING@IWEB B, ");
		sqlStr.append("(SELECT KEY_ID FROM SMS_LOG S WHERE S.ACT_TYPE = 'OUTPAT' ");
		sqlStr.append("AND S.SEND_TIME >= TO_DATE('"+smf.format(currentCal.getTime())+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		//sqlStr.append("AND S.SUCCESS = 1 ");
		sqlStr.append("ORDER BY S.SEND_TIME DESC) S ");
		sqlStr.append("WHERE B.BKGID = S.KEY_ID ");
		sqlStr.append("AND B.BKGSDATE >= TO_DATE('"+smf.format(date.getTime())+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS')) ");
		sqlStr.append("WHERE ROWNUM = 1 ");

		return (UtilDBWeb.isExist(sqlStr.toString()));
	}
*/
	// ======================================================================
	public static String getPhoneNo(String phoneNo, String couCode, String patNo,
			String seqNo, String lang, String type) {
		String msg;

		if (phoneNo != null && phoneNo.length() > 0) {
			if (couCode != null && couCode.length() > 0) {
				if (couCode.equals("852") || couCode.equals("853")) {
					if (phoneNo.length() == 8) {
						// send
						return couCode + phoneNo;
						
					} else if ( (phoneNo.length() == 11) && (phoneNo.startsWith("852") || phoneNo.startsWith("853")) ) {
						return phoneNo;

					} else {
						// error
						msg = "The country code is 852/853, but the phone no. is not 8 digits";
						UtilSMS.saveLog(msg, patNo + ":" + seqNo, type, lang, "PRS@CIS");
						updateErrorMsg(patNo, seqNo, msg);
						return null;
					}
				} else if (couCode.equals("86")) {
					if (phoneNo.substring(0, 1).equals("1") && phoneNo.length() == 11) {
						return couCode + phoneNo;
					} else {
						// error
						msg = "The country code is 86, but first letter of phone no. is not ''1'' or the phone no. is not 11 digits";
						UtilSMS.saveLog(msg, patNo + ":" + seqNo, type, lang, "PRS@CIS");
						updateErrorMsg(patNo, seqNo, msg);
						return null;
					}
				} else {
					// error
					msg = "The country code is not 852/853/86";
					UtilSMS.saveLog(msg, patNo + ":" + seqNo, type, lang, "PRS@CIS");
					updateErrorMsg(patNo, seqNo, msg);
					return null;
				}
			} else if (ConstantsServerSide.isTWAH()) {
				if (phoneNo.length() == 8) {
					return "852" + phoneNo;
				} else {
					return phoneNo;
				}
			} else {
				// error
				msg = "Country Code is empty value";
				UtilSMS.saveLog(msg, patNo + ":" + seqNo, type, lang, "PRS@CIS");
				updateErrorMsg(patNo, seqNo, msg);
				return null;
			}
		} else {
			// error
			msg = "Phone No. is empty value";
			UtilSMS.saveLog(msg, patNo + ":" + seqNo, type, lang, "PRS@CIS");
			updateErrorMsg(patNo, seqNo, msg);
			return null;
		}
	}

	// ======================================================================
	public static String getSmsContent( String type ) {
		String smsContent = null;
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT CODE_VALUE1 || chr(10) || CODE_VALUE2 FROM AH_SYS_CODE@CIS ");
		sqlStr.append(" WHERE CODE_TYPE = 'PR_MESSAGE' ");
		sqlStr.append(" AND STATUS = 'V' ");
		sqlStr.append(" AND CODE_NO = ? ");

		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { type });
		ReportableListObject row = null;

		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);			
			smsContent = row.getValue(0);
		}
		
		return smsContent;
	}
	
	// ======================================================================
	public static ArrayList<ReportableListObject> getSmsContentExtra( String type ) {
		
		ArrayList<ReportableListObject> smsExtra = null;
		
		String remarks = null;
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT REMARKS FROM AH_SYS_CODE@CIS ");
		sqlStr.append(" WHERE CODE_TYPE = 'PR_MESSAGE' ");
		sqlStr.append(" AND STATUS = 'V' ");
		sqlStr.append(" AND CODE_NO = ? ");
		sqlStr.append(" AND REMARKS IS NOT NULL ");
		
		ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { type });
		ReportableListObject row = null;

		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);			
			remarks = row.getValue(0);
			
			sqlStr = new StringBuffer();
			sqlStr.append("SELECT CODE_VALUE1 || chr(10) || CODE_VALUE2 FROM AH_SYS_CODE@CIS ");
			sqlStr.append(" WHERE CODE_TYPE = 'PR_MSG_EXTRA' ");
			sqlStr.append(" AND STATUS = 'V' ");
			sqlStr.append(" AND CODE_NO in (" + remarks + ")");
			
			smsExtra = UtilDBWeb.getReportableList( sqlStr.toString() );
		}
		
		return smsExtra;
	}

	// ======================================================================
	private static boolean updateSendTime(String patNo, String seqNo) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("UPDATE PR_APPOINTMENT@CIS ");
		sqlStr.append(" SET SMSSDT = SYSDATE ");
		sqlStr.append(" WHERE PATNO = ? ");
		sqlStr.append(" AND SEQNO = ? ");

		return UtilDBWeb.updateQueue(sqlStr.toString(), new String[] { patNo, seqNo });
	}

	// ======================================================================
	public static boolean getSuccessOfSMS(String msgId) {
		StringBuffer sql_getSuccessStats = new StringBuffer();

		sql_getSuccessStats.append("SELECT SUCCESS ");
		sql_getSuccessStats.append("FROM SMS_LOG ");
		sql_getSuccessStats.append("WHERE MSG_BATCH_ID = '" + msgId + "' ");

		ArrayList record = UtilDBWeb.getReportableList(sql_getSuccessStats.toString());
		ReportableListObject row = null;

		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);

			return row.getValue(0).equals("1");
		} else {
			return false;
		}
	}

	// ======================================================================
	private static boolean updateErrorMsg(String patNo, String seqNo, String msg) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("UPDATE PR_APPOINTMENT@CIS ");
		sqlStr.append(" SET SMS_STATUS = 'E', ");
		sqlStr.append(" SMSRTNMSG = ? ");
		sqlStr.append(" WHERE PATNO = ? ");
		sqlStr.append(" AND SEQNO = ? ");

		return UtilDBWeb.updateQueue(sqlStr.toString(), new String[] { msg, patNo, seqNo });
	}

	// ======================================================================
	private static boolean updateSuccessTimeAndMsg(String patNo, String seqNo, String msgId, String phoneNo) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("UPDATE PR_APPOINTMENT@CIS ");
		sqlStr.append(" SET SMS_STATUS = 'S', ");
		sqlStr.append(" SMS_ID = '" + msgId + "', ");
		sqlStr.append(" SMS_MOBILE = '" + phoneNo + "', ");
		sqlStr.append(" SMSSDTOK = (SELECT SEND_TIME FROM SMS_LOG WHERE MSG_BATCH_ID = '" + msgId + "' and SMCID = 'PRS@CIS' and rownum = 1), ");
		sqlStr.append(" SMSRTNMSG = (SELECT RES_MSG FROM SMS_LOG WHERE MSG_BATCH_ID = '" + msgId + "' and SMCID = 'PRS@CIS' and rownum = 1) ");
		sqlStr.append(" WHERE PATNO = '" + patNo + "' ");
		sqlStr.append(" AND SEQNO = " + seqNo);

		return UtilDBWeb.updateQueue(sqlStr.toString(), new String[] {});
	}
}