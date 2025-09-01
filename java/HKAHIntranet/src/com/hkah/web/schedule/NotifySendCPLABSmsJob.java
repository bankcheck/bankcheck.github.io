package com.hkah.web.schedule;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Locale;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.config.MessageResources;
import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.util.sms.UtilSMS;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.EmailAlertDB;
import com.spreada.utils.chinese.ZHConverter;

public class NotifySendCPLABSmsJob implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " " + this.getClass().getSimpleName() + " execute");
		
		sendSMS(false);
		
		EmailAlertDB.sendSysAlertLogEmail(this.getClass().getSimpleName(), null);
	}

	//======================================================================
	private static ArrayList getSMSList(SimpleDateFormat smf, Calendar startCal,
										Calendar endCal, boolean isReceiveSMS, String smcID) {
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT ");
		sqlStr.append("a.deptaid,");
		sqlStr.append("'' AS allergy,");
		sqlStr.append("DECODE(a.pattype, 'I', 'In Patient', 'E', 'In Patient-Addon', 'O', 'Out Patient', 'F', 'Out Patient-Addon', '') AS pattype,");
		sqlStr.append("TO_CHAR(a.deptaosdate, 'DD'),");
		sqlStr.append("TO_CHAR(a.deptaosdate, 'MM'),");
		sqlStr.append("TO_CHAR(a.deptaosdate, 'YYYY'),");
		sqlStr.append("TO_CHAR(a.deptaosdate, 'HH24'),");
		sqlStr.append("TO_CHAR(a.deptaosdate, 'MI'),");
		sqlStr.append("a.deptbed,");
		sqlStr.append("a.patno,");
		sqlStr.append("a.deptafname||' '|| a.deptagname AS patname,");
		sqlStr.append("p.deptpdesc,");
		sqlStr.append("d.docfname||' '|| d.docgname,pd.docfname||' '|| pd.docgname,");
		sqlStr.append("a.deptprmk,");
		sqlStr.append("pat.patsex,");
		sqlStr.append("trunc(months_between(SYSDATE, a.deptabdate) / 12) AS age,");
		sqlStr.append("TO_CHAR(a.deptaoedate, 'DD/MM/YYYY HH24:MI'),");
		sqlStr.append("c.deptcdesc AS deptpdesc_rm,");
		sqlStr.append("DECODE(pat.pmcid, NULL, NULL, 0, NULL, 'M') AS merged,");
		sqlStr.append("a.deptafname,");
		sqlStr.append("a.deptagname,");
		sqlStr.append("DECODE(a.deptasts, 'N', 'Normal', 'F', 'Confirmed', 'C', 'Cancel', a.deptasts) AS status,");
		sqlStr.append("a.deptusrid,");
		sqlStr.append("a.deptasts,");
		sqlStr.append("DECODE(coucode,");
		sqlStr.append("'86',DECODE(INSTR(REGEXP_REPLACE(nvl(pat.patpager, a.deptatel), '[^0-9A-Za-z]', ''),'86', 1,1),1,SUBSTR(REGEXP_REPLACE(nvl(pat.patpager, a.deptatel), '[^0-9A-Za-z]', ''),3),nvl(pat.patpager, a.deptatel)),");
		sqlStr.append("'852',DECODE(INSTR(REGEXP_REPLACE(nvl(pat.patpager, a.deptatel), '[^0-9A-Za-z]', ''),'852', 1,1),1,SUBSTR(REGEXP_REPLACE(nvl(pat.patpager, a.deptatel), '[^0-9A-Za-z]', ''),4),nvl(pat.patpager, a.deptatel)),");
		sqlStr.append("'853',DECODE(INSTR(REGEXP_REPLACE(nvl(pat.patpager, a.deptatel), '[^0-9A-Za-z]', ''),'853', 1,1),1,SUBSTR(REGEXP_REPLACE(nvl(pat.patpager, a.deptatel), '[^0-9A-Za-z]', ''),4),nvl(pat.patpager, a.deptatel)),");
		sqlStr.append("patpager) AS MOBILE,");		
//		sqlStr.append("NVL(pat.patpager,a.deptatel),");				
		sqlStr.append("pat.coucode, ");
		sqlStr.append("pat.MOTHCODE,");		
//		sqlStr.append("'91041704','852','TRC'");
		sqlStr.append("a.deptaosdate,");
		sqlStr.append("pat.patsms");
		sqlStr.append(" FROM ");
		sqlStr.append("dept_app@IWEB a,");
		sqlStr.append("dept_proc@IWEB p,");
		sqlStr.append("dept_code@IWEB c,");
		sqlStr.append("patient@IWEB pat,");
		sqlStr.append("doctor@IWEB d,");
		sqlStr.append("doctor@IWEB pd");
		sqlStr.append(" WHERE a.deptpid = p.deptpid");
		sqlStr.append(" AND a.deptcid_rm = c.deptcid");
		sqlStr.append(" AND a.patno = pat.patno (+)");
		sqlStr.append(" AND a.doccode_r = d.doccode (+)");
		sqlStr.append(" AND a.doccode_p = pd.doccode (+)");
		sqlStr.append(" AND c.deptctype = 'RM'");
		sqlStr.append(" AND a.depttype = 'CPLAB' ");
		sqlStr.append(" AND trunc(a.deptaosdate, 'mi') >= TO_DATE('"+smf.format(startCal.getTime())+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append(" AND trunc(a.deptaosdate, 'mi') <= TO_DATE('"+smf.format(endCal.getTime())+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append(" AND a.deptasts = 'N' ");
		sqlStr.append(" AND a.pattype = 'O' ");
		sqlStr.append(" AND p.deptpcode IN ('CC003','CC043','CC023','CC032','CC005','CC035') ");
		sqlStr.append(" AND a.deptasts NOT IN ('P','B','U')");
//		sqlStr.append(" AND ROWNUM = 1");
		sqlStr.append(" UNION ");
		sqlStr.append("SELECT ");
		sqlStr.append("a.deptaid,");
		sqlStr.append("'' AS allergy,");
		sqlStr.append("DECODE(a.pattype, 'I', 'In Patient', 'E', 'In Patient-Addon', 'O', 'Out Patient', 'F', 'Out Patient-Addon', '') AS pattype,");
		sqlStr.append("TO_CHAR(a.deptaosdate, 'DD'),");
		sqlStr.append("TO_CHAR(a.deptaosdate, 'MM'),");
		sqlStr.append("TO_CHAR(a.deptaosdate, 'YYYY'),");
		sqlStr.append("TO_CHAR(a.deptaosdate, 'HH24'),");
		sqlStr.append("TO_CHAR(a.deptaosdate, 'MI'),");
		sqlStr.append("a.deptbed,");
		sqlStr.append("a.patno,");
		sqlStr.append("a.deptafname||' '|| a.deptagname AS patname,");
		sqlStr.append("p.deptpdesc,");
		sqlStr.append("d.docfname||' '|| d.docgname,pd.docfname||' '|| pd.docgname,");
		sqlStr.append("a.deptprmk,");
		sqlStr.append("pat.patsex,");
		sqlStr.append("trunc(months_between(SYSDATE, a.deptabdate) / 12) AS age,");
		sqlStr.append("TO_CHAR(a.deptaoedate, 'DD/MM/YYYY HH24:MI'),");
		sqlStr.append("c.deptcdesc AS deptpdesc_rm,");
		sqlStr.append("DECODE(pat.pmcid, NULL, NULL, 0, NULL, 'M') AS merged,");
		sqlStr.append("a.deptafname,");
		sqlStr.append("a.deptagname,");
		sqlStr.append("DECODE(a.deptasts, 'N', 'Normal', 'F', 'Confirmed', 'C', 'Cancel', a.deptasts) AS status,");
		sqlStr.append("a.deptusrid,");
		sqlStr.append("a.deptasts,");
		sqlStr.append("DECODE(coucode,");
		sqlStr.append("'86',DECODE(INSTR(REGEXP_REPLACE(nvl(pat.patpager, a.deptatel), '[^0-9A-Za-z]', ''),'86', 1,1),1,SUBSTR(REGEXP_REPLACE(nvl(pat.patpager, a.deptatel), '[^0-9A-Za-z]', ''),3),nvl(pat.patpager, a.deptatel)),");
		sqlStr.append("'852',DECODE(INSTR(REGEXP_REPLACE(nvl(pat.patpager, a.deptatel), '[^0-9A-Za-z]', ''),'852', 1,1),1,SUBSTR(REGEXP_REPLACE(nvl(pat.patpager, a.deptatel), '[^0-9A-Za-z]', ''),4),nvl(pat.patpager, a.deptatel)),");
		sqlStr.append("'853',DECODE(INSTR(REGEXP_REPLACE(nvl(pat.patpager, a.deptatel), '[^0-9A-Za-z]', ''),'853', 1,1),1,SUBSTR(REGEXP_REPLACE(nvl(pat.patpager, a.deptatel), '[^0-9A-Za-z]', ''),4),nvl(pat.patpager, a.deptatel)),");
		sqlStr.append("patpager) AS MOBILE,");  		
//		sqlStr.append("NVL(pat.patpager,a.deptatel) AS MOBILE,");				
		sqlStr.append("pat.coucode, ");
		sqlStr.append("pat.MOTHCODE,");		
//		sqlStr.append("'91041704','852','TRC'");
		sqlStr.append("a.deptaosdate,");
		sqlStr.append("pat.patsms");
		sqlStr.append(" FROM ");
		sqlStr.append("dept_app@IWEB a,");
		sqlStr.append("dept_proc@IWEB p,");
		sqlStr.append("dept_code@IWEB c,");
		sqlStr.append("patient@IWEB pat,");
		sqlStr.append("doctor@IWEB d,");
		sqlStr.append("doctor@IWEB pd");
		sqlStr.append(" WHERE a.deptpid = p.deptpid");
		sqlStr.append(" AND a.deptcid_rm = c.deptcid");
		sqlStr.append(" AND a.patno = pat.patno (+)");
		sqlStr.append(" AND a.doccode_r = d.doccode (+)");
		sqlStr.append(" AND a.doccode_p = pd.doccode (+)");
		sqlStr.append(" AND c.deptctype = 'RM'");
		sqlStr.append(" AND a.depttype = 'CPLAB' ");
		sqlStr.append(" AND trunc(a.deptaosdate, 'mi') >= TO_DATE('"+smf.format(startCal.getTime())+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append(" AND trunc(a.deptaosdate, 'mi') <= TO_DATE('"+smf.format(endCal.getTime())+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append(" AND a.deptasts = 'N' ");
		sqlStr.append(" AND a.pattype = 'O' ");
		sqlStr.append(" AND p.deptpcode NOT IN ('CC003','CC043','CC023','CC032','CC005','CC035') ");
		sqlStr.append(" AND a.deptasts NOT IN ('P','B','U')");
		sqlStr.append(" AND a.patno IN (");			
		sqlStr.append("SELECT ");
		sqlStr.append("a.patno");
		sqlStr.append(" FROM ");
		sqlStr.append("dept_app@IWEB a,");
		sqlStr.append("dept_proc@IWEB p,");
		sqlStr.append("dept_code@IWEB c,");
		sqlStr.append("patient@IWEB pat,");
		sqlStr.append("doctor@IWEB d,");
		sqlStr.append("doctor@IWEB pd");
		sqlStr.append(" WHERE a.deptpid = p.deptpid");
		sqlStr.append(" AND a.deptcid_rm = c.deptcid");
		sqlStr.append(" AND a.patno = pat.patno (+)");
		sqlStr.append(" AND a.doccode_r = d.doccode (+)");
		sqlStr.append(" AND a.doccode_p = pd.doccode (+)");
		sqlStr.append(" AND c.deptctype = 'RM'");
		sqlStr.append(" AND a.depttype = 'CPLAB' ");
		sqlStr.append(" AND trunc(a.deptaosdate, 'mi') >= TO_DATE('"+smf.format(startCal.getTime())+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append(" AND trunc(a.deptaosdate, 'mi') <= TO_DATE('"+smf.format(endCal.getTime())+" 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append(" AND a.deptasts = 'N' ");
		sqlStr.append(" AND a.pattype = 'O' ");
		sqlStr.append(" AND p.deptpcode IN ('CC003','CC043','CC023','CC032','CC005','CC035') ");
		sqlStr.append(" AND a.deptasts NOT IN ('P','B','U'))");
		sqlStr.append(" ORDER BY 10,29");

		System.out.println(sqlStr.toString());
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	//======================================================================
	public static boolean isSmsScheduleDay(Calendar startCal) {
		//check whether today is saturday or holiday with disable sms setting
		if (startCal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY ||
					isHolidayAndDisableSMS(startCal)) {
			return false;
		}
		return true;
	}

	//======================================================================
	public static Calendar getAppointmentDay(Calendar startCal, boolean ignoreSentDate) {
		startCal.add(Calendar.DATE, 1);
				
/*		
//check whether today is thur or fri, then use T+3 to get the booking date  
		if (startCal.get(Calendar.DAY_OF_WEEK) == Calendar.THURSDAY ||
					startCal.get(Calendar.DAY_OF_WEEK) == Calendar.FRIDAY) {
			startCal.add(Calendar.DATE, 2);				
			System.out.println("1[startCal]:"+startCal.getTime()+"["+startCal.get(Calendar.DAY_OF_WEEK)+"]");			
		} else {
			//otherwise, use T+2 to get the booking date
			startCal.add(Calendar.DATE, 1);			
			System.out.println("2[startCal]:"+startCal.getTime()+"["+startCal.get(Calendar.DAY_OF_WEEK)+"]");
		}

		//check whether the booking date is holiday with disable sms setting
		while(startCal.get(Calendar.DAY_OF_WEEK) == Calendar.SATURDAY ||
					isHolidayAndDisableSMS(startCal)) {
			System.out.println("[isSentSMS(startCal)]:"+isSentSMS(startCal));
			System.out.println("[ignoreSentDate]:"+ignoreSentDate);
			startCal.add(Calendar.DATE, 1);
			
			System.out.println("3[startCal]:"+startCal.getTime()+"["+startCal.get(Calendar.DAY_OF_WEEK)+"]");			
		}
*/
		//set specific day (yyyy, m, d)
		//m is current month - 1, example: April = 3
		//startCal.set(2014, 3, 9);
		return startCal;
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

		SimpleDateFormat esmf = new SimpleDateFormat("'on' dd/MM/yyyy' at 'h:mm a", Locale.ENGLISH);
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

		ArrayList record = getSMSList(smf, startCal, endCal, true, null);
		ReportableListObject row = null;
		String oldPatNo = null;
		System.out.println("[record.size()]:"+record.size());		
		if (record.size() > 0) {
			for(int i = 0; i < record.size(); i++) {
				row = (ReportableListObject)record.get(i);
				if(oldPatNo==null || (oldPatNo!=null && !oldPatNo.equals(row.getValue(9).trim()))){
					if (isSentSMS(startCal, row.getValue(0)) && ConstantsServerSide.isHKAH()) {
						EmailAlertDB.sendEmail("appointment.sms",
								"Hong Kong Adventist Hospital - SMS",
								"It has return message already<br/>"+
								"The sms is sent for this appointment - DEPTAID "  + row.getValue(0));
					} else if ( ConstantsServerSide.isHKAH()) {
						if ("-1".equals(row.getValue(29))) {
							String msgId = null;
							String lang = row.getValue(27);
							String docName = null;
							String dateTime = "";
							String smsContent = null;
							String type = null;
							String docTitle = null;
		
							type = UtilSMS.SMS_CPLAB;
		
							if (lang.length() <= 0) {
								lang = "ENG";
							}
		
							String phoneNo =
								getPhoneNo(row.getValue(25).trim(), row.getValue(26).trim(),
											row.getValue(9).trim(), row.getValue(0),
											lang, type);
		
							if (phoneNo != null) {//send sms
								//set the appointment date & time
								startCal.set(Integer.parseInt(row.getValue(5)), Integer.parseInt(row.getValue(4))-1,
										Integer.parseInt(row.getValue(3)), Integer.parseInt(row.getValue(6)),
										Integer.parseInt(row.getValue(7)));
		
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
		
								smsContent = getSmsContent(row.getValue(9), null, lang, dateTime, row.getValue(6));
		
								//targetPhone="91603748";//prevent send sms during testing
								if (smsContent != null) {
									if (debug) {
										EmailAlertDB.sendEmail(
												"sms.reg.alert",
												"Hong Kong Adventist Hospital - SMS",
												smsContent);
									} else {
										try {
											System.out.println("[Pat NO.]:"+row.getValue(9).trim());
											System.out.println("[Pat Name]:"+row.getValue(10));
											System.out.println("[Moth lang]:"+lang);
											System.out.println("[Phone NO.]:"+phoneNo);
											System.out.println("[Country Code]:"+row.getValue(26).trim());
											System.out.println("[Pat SMS]:"+row.getValue(29));										
											System.out.println("[smsContent]:"+smsContent);									
									
											msgId = UtilSMS.sendSMS("", new String[] { phoneNo },
													smsContent,
													type, row.getValue(0), lang, null);
											
										} catch (Exception e) {
											// TODO Auto-generated catch block
											e.printStackTrace();
										}
									}
								} else {
									if (!debug) {
										UtilSMS.saveLog("Cannot find any template",
												row.getValue(12), type, lang, null);
									}
								}
							}
						}else{
							System.out.println("[NO Pat SMS Receive][Pat NO.]:"+row.getValue(9).trim()+";[Pat Name]:"+row.getValue(10));														
						}
					}
					oldPatNo = row.getValue(9).trim();
				}
			}
		}

		EmailAlertDB.sendEmail(
				"appointment.sms",
				"Hong Kong Adventist Hospital - SMS",
				"SMS SCHEDULE START - " + currentCal.getTime() +"<br/><br/>"+
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
	private static boolean isSentSMS(Calendar date, String keyID) {
		StringBuffer sqlStr = new StringBuffer();
		Calendar currentCal = Calendar.getInstance();
		SimpleDateFormat smf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
		currentCal.add(Calendar.DATE, -7);

		sqlStr.append("SELECT 1 FROM ( ");
		sqlStr.append("SELECT DEPTAOSDATE FROM dept_app@IWEB B, ");
		sqlStr.append("(SELECT KEY_ID,ACT_TYPE FROM SMS_LOG S WHERE S.ACT_TYPE = 'CPLAB' ");
		sqlStr.append("AND S.SEND_TIME >= TO_DATE('"+smf.format(currentCal.getTime())+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		sqlStr.append("AND s.key_id = '"+keyID+"' "); 
		sqlStr.append("AND S.SUCCESS = 1 ");
		sqlStr.append("ORDER BY S.SEND_TIME DESC) S ");
		sqlStr.append("WHERE B.DEPTAID = S.KEY_ID ");
		sqlStr.append("AND B.DEPTAID = '"+keyID+"' ");		
		sqlStr.append("AND S.ACT_TYPE = 'CPLAB' ");		
		sqlStr.append("AND B.deptaosdate >= TO_DATE('"+smf.format(date.getTime())+" 00:00:00', 'DD/MM/YYYY HH24:MI:SS')) ");
		sqlStr.append("WHERE ROWNUM = 1 ");
System.err.println(sqlStr.toString());
		return (UtilDBWeb.isExist(sqlStr.toString()));
	}

	//======================================================================
	public static String getPhoneNo(String phoneNo, String couCode, String patNo,
							String bkgId, String lang, String type) {
		
		if (patNo != null && patNo.length() > 0) {
			if (phoneNo != null && phoneNo.length() > 0) {
				if (ConstantsServerSide.isHKAH() &&(couCode != null && couCode.length() > 0)) {
					if (couCode.equals("852") || couCode.equals("853")) {
						if (phoneNo.length() == 8) {
							//send
							return couCode+phoneNo;
						} else {
							//error
							UtilSMS.saveLog("The country code is 852/853, but the phone no. is not 8 digits",
										bkgId, type, lang, null);
							return null;
						}
					} else if (couCode.equals("86")) {
						if (phoneNo.substring(0, 1).equals("1") && phoneNo.length() == 11) {
							return couCode+phoneNo;
						} else {
							UtilSMS.saveLog("The country code is 86, but first letter of phone no. is not ''1'' or the phone no. is not 11 digits",
									bkgId, type, lang, null);
							return null;
						}
					} else {
						UtilSMS.saveLog("The country code is not 852/853/86",
								bkgId, type, lang, null);
						return null;
					}
				} else if (ConstantsServerSide.isTWAH()) {
					if (phoneNo.length() == 8) {
						return "852"+phoneNo;
					} else {
						return phoneNo;
					}
				} else {
					UtilSMS.saveLog("Country Code is empty value",
							bkgId, type, lang, null);
					return null;
				}
			} else {
				UtilSMS.saveLog("Phone No. is empty value",
						bkgId, type, lang, null);
				return null;
			}
		} else {
			if (phoneNo != null && phoneNo.length() > 0) {
				if (phoneNo.length() == 8) {
					return phoneNo;
				} else if (phoneNo.length() > 8) {
					if (phoneNo.substring(0, 3).equals("861") && phoneNo.length() == 13) {
						return phoneNo;
					} else if (phoneNo.substring(0, 3).equals("853") && phoneNo.length() == 11) {
						return phoneNo;
					} else {
						UtilSMS.saveLog("Phone No. is greater than 8 digits, but it does not belong to 86 or 853",
								bkgId, type, lang, null);
						return null;
					}
				} else {
					UtilSMS.saveLog("Phone No. is less than 8 digits",
							bkgId, type, lang, null);
					return null;
				}
			} else {
				UtilSMS.saveLog("Phone No. is empty value",
						bkgId, type, lang, null);
				return null;
			}
		}
	}

	//======================================================================
	private static String getSmsContent(String patNo, String smcid, String lang, String dateTime, String dateTimeHH) {
		if (ConstantsServerSide.isHKAH()) {
			return getHATemplate((patNo == null), lang, dateTime);
		} else {
			return getHATemplate((patNo == null), lang, dateTime);
		}
	}

	//======================================================================
	private static String getHATemplate(boolean newPatient, String lang, String dateTime) {
		StringBuffer smsContent = new StringBuffer();
	
		if (lang.equals("ENG")) {
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.cplab.block1"));
			smsContent.append(" " + dateTime +" ");
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.cplab.block2"));
		} else if (lang.equals("TRC")) {
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.cplab.block1"));
			smsContent.append(" " + dateTime +" ");
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.cplab.block2"));
		} else if (lang.equals("SMC")) {
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.cplab.block1"));
			smsContent.append(" " + dateTime +" ");
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.cplab.block2"));
		} else if (lang.equals("JAP")) {
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.cplab.block1"));
			smsContent.append(" " + dateTime +" ");
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.cplab.block2"));
		}
		return smsContent.toString();
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

}