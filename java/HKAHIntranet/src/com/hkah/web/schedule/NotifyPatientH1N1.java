package com.hkah.web.schedule;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Locale;

import org.apache.commons.lang.ArrayUtils;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.util.sms.UtilSMS;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.EmailAlertDB;
import com.hkah.web.schedule.NotifyPatientCovidTW.covidReport;

public class NotifyPatientH1N1 implements Job {
	
	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		System.out.println("[NotifyPatientH1N1] ===== Start =====");
		sendNotification();
		System.out.println("[NotifyPatientH1N1] ===== End =====");
	}

	// ======================================================================
	private static ArrayList getList() {

		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT P.MOTHCODE, P.PATSMS,	  P.PATNO, "); //0, 1, 2,
		sqlStr.append(" P.PATPAGER, NVL(PE.PATPGRCOUCODE, P.COUCODE), P.PATEMAIL, "); //3, 4, 5,
		sqlStr.append(" D.LAB_NUM, M.LOC_CODE, M.TYPE, "); //6, 7, 8 
		sqlStr.append(" TO_CHAR(D.REPORT_DT, 'DD/MM/YYYY'), "); //9
		sqlStr.append(" MAX(DECODE(D.TEST_NUM, 'FRSV', D.RESULT, null)), "); //10
		sqlStr.append(" MAX(DECODE(D.TEST_NUM, 'HFLUA', D.RESULT, null)), "); //11
		sqlStr.append(" MAX(DECODE(D.TEST_NUM, 'HFLUB', D.RESULT, null)), "); //12
		sqlStr.append(" MAX(DECODE(D.TEST_NUM, 'XSAR', D.RESULT, null)), "); //13
		sqlStr.append(" R.PAT_NOTIFY_STATUS, R.PAT_EMAIL_STATUS "); //14, 15
		sqlStr.append(" FROM PATIENT@IWEB P LEFT OUTER JOIN PATIENT_EXTRA@IWEB PE ON P.PATNO = PE.PATNO ");
		sqlStr.append(" JOIN LABO_MASTHEAD@LIS M ON P.PATNO = M.HOSPNUM ");
		sqlStr.append(" JOIN LABO_DETAIL@LIS D ON D.LAB_NUM = M.LAB_NUM ");
		sqlStr.append(" JOIN LABO_REPORT_LOG@LIS R ON D.LAB_NUM = R.LAB_NUM AND R.TEST_CAT = 'M' ");
		sqlStr.append(" WHERE D.PROFILE = 'H1N1' "); 		
		sqlStr.append(" AND D.STATUS = '2' ");
		sqlStr.append(" AND (R.PAT_NOTIFY_STATUS = 'R' OR R.PAT_EMAIL_STATUS = 'R') ");
		sqlStr.append(" AND D.TEST_TYPE <> '0' ");
		sqlStr.append(" AND M.TYPE = 'O' ");
		sqlStr.append(" AND (M.LOC_CODE IS NULL OR M.LOC_CODE NOT IN ('AMC', 'AMC2') ) ");
		sqlStr.append(" AND R.RPT_DATE > SYSDATE - 1 ");
		sqlStr.append(" group by P.MOTHCODE, P.PATSMS,	P.PATNO, ");
		sqlStr.append(" P.PATPAGER, NVL(PE.PATPGRCOUCODE, P.COUCODE), P.PATEMAIL, "); 
		sqlStr.append(" D.LAB_NUM, M.LOC_CODE, M.TYPE, ");
		sqlStr.append(" TO_CHAR(D.REPORT_DT, 'DD/MM/YYYY'), "); 
		sqlStr.append(" R.PAT_NOTIFY_STATUS, R.PAT_EMAIL_STATUS "); 
				
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}

	// ======================================================================
	
	public static void sendNotification() {
		// get current day
		Calendar currentCal = Calendar.getInstance();
		boolean debug = false;
/*
		SimpleDateFormat smf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
		SimpleDateFormat esmf = new SimpleDateFormat("'on' EEE, MMM dd, yyyy", Locale.ENGLISH);
		SimpleDateFormat csmf = new SimpleDateFormat("M月dd日", Locale.CHINESE);
		SimpleDateFormat scsmf = new SimpleDateFormat("M月dd日", Locale.SIMPLIFIED_CHINESE);
		SimpleDateFormat jcsmf = new SimpleDateFormat("M月dd日", Locale.JAPAN);
*/
		ArrayList record = getList();
		ReportableListObject row = null;
		if (record.size() > 0) {
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);

				String msgId = null;
				String lang = row.getValue(0);
				String smsContent = null;
				String emailContent = null;

				String patNo = row.getValue(2);
				String email = row.getValue(5);
				String labnum = row.getValue(6);
				String result = row.getValue(7);
				String location = row.getValue(7);
				String rptDate = row.getValue(9);
				String resultV = row.getValue(10);
				String resultA = row.getValue(11);
				String resultB = row.getValue(12);
				String resultC = row.getValue(13);

				String SmsStatus = row.getValue(14);
				String emailStatus = row.getValue(15);

				if (lang.length() <= 0) {
					lang = "ENG";
				}
				
				String type = UtilSMS.SMS_HKLAB;
				
				if ("R".equals(SmsStatus)) {

					String phoneNo = getPhoneNo(row.getValue(3).trim(), row.getValue(4).trim(), lang, type, labnum);
								
					if (phoneNo != null) {// send sms
							
						try {
						
							if ("TRC".equals(lang)) 
								smsContent = getSmsContentTrc(resultA, resultB, resultC, resultV, patNo, rptDate);
							else 
								smsContent = getSmsContentEng1(resultA, resultB, resultC, resultV, patNo, rptDate);

							msgId = UtilSMS.sendSMS("", new String[] { phoneNo },
									smsContent,
									type, labnum, lang, "H1N1");
	
							if (getSuccessOfSMS(msgId))
								updateSMSSuccessTimeAndMsg(labnum, msgId);
							
							//Thread.sleep(4000);
	
						} catch (Exception e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						
					} else {
						String msg = "Patient mobile number empty or invalid";
						updateSMSErrorMsg(labnum, msg);
					}
				}
				
				if ("R".equals(emailStatus)) {

					if (email.length() > 0) {// send email
						
						emailContent = getEmailContent(lang, resultA, resultB, resultC, resultV, patNo, rptDate);
						
						//File map = new File("/images/email/map.jpg");
						//File map = new File("\\\\hkim\\IM\\Common\\web\\map.jpg");
						//String filename = "map.jpg";
						String title = null;
						
						if ("TRC".equals(lang)) {
							title = "甲型乙型流感檢測結果";
						} else if ("SMC".equals(lang)) {
							title = "甲型乙型流感检测结果";
						} else {
							title = "Result of Influenza A & B by PCR Test";
						}
						
						if (UtilMail.sendMail(
								"hkahsrcovid@hkah.org.hk",
								new String[] { email },
								null,
								null, 
								title,
								emailContent, false)) {
							
							UtilMail.insertEmailLog(null, labnum,
								type, "H1N1", true, "");
							
							updateEmailSuccessTimeAndMsg(labnum);
							
						} else {
							UtilMail.insertEmailLog(null, labnum,
								type, "H1N1", false, "");
							
							updateEmailErrorMsg(labnum, "Email sent failed");
						}
					} else {
						updateEmailErrorMsg(labnum, "No email address");
					}
				}
				
			}				
		} 

	}

	// ======================================================================
	public static String getPhoneNo(String phoneNo, String couCode,
			String lang, String type, String labnum) {
		
		String msg;
		
		if (phoneNo != null && phoneNo.length() > 0) {
			
			try {
				long l = Long.parseLong(couCode + phoneNo);
			} catch (Exception e) {				
				msg = "Phone No. is invalid: " + couCode + phoneNo;
				UtilSMS.saveLog(msg, labnum, type, lang, "COVID");
				updateSMSErrorMsg(labnum, msg);
				e.printStackTrace();
				return null;
			}
						
			if (couCode != null && couCode.length() > 0) {
				if (couCode.equals("852") || couCode.equals("853")) {
					if (phoneNo.length() == 8) {
						// send
						return couCode + phoneNo;
						
					} else if ( (phoneNo.length() == 11) && (phoneNo.startsWith("852") || phoneNo.startsWith("853")) ) {
						return phoneNo;
						
					} else {
						// error
						/* send anyway
						msg = "The country code is 852/853, but the phone no. is not 8 digits";
						UtilSMS.saveLog(msg, labnum, type, lang, "COVID");
						updateErrorMsg(labnum, msg);
						return null;
						*/
						return couCode + phoneNo;
					}
				} else if (couCode.equals("86")) {
					if (phoneNo.substring(0, 1).equals("1") && phoneNo.length() == 11) {
						return couCode + phoneNo;
					} else {
						// error
						/* send anyway
						msg = "The country code is 86, but first letter of phone no. is not ''1'' or the phone no. is not 11 digits";
						UtilSMS.saveLog(msg, labnum, type, lang, "COVID");
						updateErrorMsg(labnum, msg);
						return null;
						*/
						return couCode + phoneNo;
					}
				} else {
					// error
					/*
					msg = "The country code is not 852/853/86";
					UtilSMS.saveLog(msg, labnum, type, lang, "COVID");
					updateErrorMsg(labnum, msg);
					return null;
					*/
					// send international SMS
					return couCode + phoneNo;
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
				UtilSMS.saveLog(msg, labnum, type, lang, "COVID");
				updateSMSErrorMsg(labnum, msg);
				return null;
			}
			
		} else {
			// error
			msg = "Phone No. is empty value";
			UtilSMS.saveLog(msg, labnum, type, lang, "COVID");
			updateSMSErrorMsg(labnum, msg);
			return null;
		}
	}

	// ======================================================================
	private static String getSmsContentTrc(String resultA, String resultB, String resultC, String resultV, String patno, String rptDate) {
		
		StringBuffer content = new StringBuffer();
		String maskedPatno = getMaskedNum(patno);
		
		String engTxtC;
		String trcTxtC;
		String smcTxtC;
		
		String engTxtA;
		String trcTxtA;
		String smcTxtA;
		
		String engTxtB;
		String trcTxtB;
		String smcTxtB;
		
		String engTxtV;
		String trcTxtV;
		String smcTxtV;
		
		try {
			
			if (Float.parseFloat(resultC) >= 100) {
				engTxtC = "Detected";
				trcTxtC = "陽性";
				smcTxtC = "阳性";
			} else {
				engTxtC = "NOT Detected";
				trcTxtC = "陰性";
				smcTxtC = "阴性";
			}
			
			if (Float.parseFloat(resultA) >= 100) {
				engTxtA = "Positive";
				trcTxtA = "陽性";
				smcTxtA = "阳性";
			} else {
				engTxtA = "Negative";
				trcTxtA = "陰性";
				smcTxtA = "阴性";
			}
			
			if (Float.parseFloat(resultB) >= 100) {
				engTxtB = "Positive";
				trcTxtB = "陽性";
				smcTxtB = "阳性";
			} else {
				engTxtB = "Negative";
				trcTxtB = "陰性";
				smcTxtB = "阴性";
			}
			
			if (Float.parseFloat(resultV) >= 100) {
				engTxtV = "Positive";
				trcTxtV = "陽性";
				smcTxtV = "阳性";
			} else {
				engTxtV = "Negative";
				trcTxtV = "陰性";
				smcTxtV = "阴性";
			}
			
			content.append("香港港安－司徒拔道提示：病人編號" + maskedPatno + "：報告簽發日期:" + rptDate + " CO呈" + trcTxtC + "反應，A呈" + trcTxtA + "反應/B呈" + trcTxtB + "反應/V呈" + trcTxtV + "反應，如上述檢測當中驗出陽性，本院職員會與你聯絡。\n\n");
			content.append("是次檢測不提供健康證明書。如需領取化驗結果正本，請閣下或已授權人士親臨本院病歷部領取, 36518809");
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
			
		return content.toString();
	}
	
	//======================================================================
	private static String getSmsContentEng1(String resultA, String resultB, String resultC, String resultV, String patno, String rptDate) {
		
		StringBuffer content = new StringBuffer();
		String maskedPatno = getMaskedNum(patno);
		
		String engTxtC;
		String trcTxtC;
		String smcTxtC;
		
		String engTxtA;
		String trcTxtA;
		String smcTxtA;
		
		String engTxtB;
		String trcTxtB;
		String smcTxtB;
		
		String engTxtV;
		String trcTxtV;
		String smcTxtV;
		
		try {
			
			if (Float.parseFloat(resultC) >= 100) {
				engTxtC = "Detected";
				trcTxtC = "陽性";
				smcTxtC = "阳性";
			} else {
				engTxtC = "NOT Detected";
				trcTxtC = "陰性";
				smcTxtC = "阴性";
			}
			
			if (Float.parseFloat(resultA) >= 100) {
				engTxtA = "Positive";
				trcTxtA = "陽性";
				smcTxtA = "阳性";
			} else {
				engTxtA = "Negative";
				trcTxtA = "陰性";
				smcTxtA = "阴性";
			}
			
			if (Float.parseFloat(resultB) >= 100) {
				engTxtB = "Positive";
				trcTxtB = "陽性";
				smcTxtB = "阳性";
			} else {
				engTxtB = "Negative";
				trcTxtB = "陰性";
				smcTxtB = "阴性";
			}
			
			if (Float.parseFloat(resultV) >= 100) {
				engTxtV = "Positive";
				trcTxtV = "陽性";
				smcTxtV = "阳性";
			} else {
				engTxtV = "Negative";
				trcTxtV = "陰性";
				smcTxtV = "阴性";
			}
			
			content.append("HKAH-Stubbs Road Reminder: " + maskedPatno + ": Report Issued Date: " + rptDate + " CO " + engTxtC + ", A " + engTxtA + "/B " + engTxtB + "/V " + engTxtV + ". In case of any positive/detected results, our nurse will contact you for any follow up actions.\n\n");
			content.append("An official health certificate will not be provided. If a hard copy lab report is needed, kindly collect by yourself/ an authorized person @Medical Records, 36518809.");			

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	
		return content.toString();
	}

	// ======================================================================
/*	
	private static String getSmsContentEng2() {	
		StringBuffer content = new StringBuffer();
		content.append("If a hard copy test report is needed, kindly collect by yourself/ an authorized person @Medical Records (Time: Mon-Friday: 0900–1730, Sun: 0900-1300). EN: 36518809.");			
		return content.toString();
	}
*/
	// ======================================================================
	private static String getEmailContent(String lang, String resultA, String resultB, String resultC, String resultV, String patno, String rptDate) {
		
		StringBuffer content = new StringBuffer();
		String maskedPatno = getMaskedNum(patno);
		
		String engTxtC;
		String trcTxtC;
		String smcTxtC;
		
		String engTxtA;
		String trcTxtA;
		String smcTxtA;
		
		String engTxtB;
		String trcTxtB;
		String smcTxtB;
		
		String engTxtV;
		String trcTxtV;
		String smcTxtV;
		
		try {
		
			if (Float.parseFloat(resultC) >= 100) {
				engTxtC = "Detected";
				trcTxtC = "陽性";
				smcTxtC = "阳性";
			} else {
				engTxtC = "NOT Detected";
				trcTxtC = "陰性";
				smcTxtC = "阴性";
			}
			
			if (Float.parseFloat(resultA) >= 100) {
				engTxtA = "Positive";
				trcTxtA = "陽性";
				smcTxtA = "阳性";
			} else {
				engTxtA = "Negative";
				trcTxtA = "陰性";
				smcTxtA = "阴性";
			}
			
			if (Float.parseFloat(resultB) >= 100) {
				engTxtB = "Positive";
				trcTxtB = "陽性";
				smcTxtB = "阳性";
			} else {
				engTxtB = "Negative";
				trcTxtB = "陰性";
				smcTxtB = "阴性";
			}
			
			if (Float.parseFloat(resultV) >= 100) {
				engTxtV = "Positive";
				trcTxtV = "陽性";
				smcTxtV = "阳性";
			} else {
				engTxtV = "Negative";
				trcTxtV = "陰性";
				smcTxtV = "阴性";
			}
			
			if ("TRC".equals(lang)) {
				content.append("<u>[報告簽發日期: " + rptDate + "]</u><br/>");
				content.append("病人編號 (" + maskedPatno + ")<br/><br/>");
				content.append("CO <b><u>呈" + trcTxtC + "反應</u></b><br/>");
				content.append("A <b><u>呈" + trcTxtA + "反應</u></b><br/>");
				content.append("B <b><u>呈" + trcTxtB + "反應</u></b><br/>");
				content.append("V <b><u>呈" + trcTxtV + "反應</u></b><br/><br/>");
				
				content.append("如上述檢測當中驗出陽性，本院職員會與你聯絡。<br/><br/>");
				content.append("請閣下或授權人士(需攜同授權書的正本及病人身份證明文件的副本)需領取報告正本，詳情如下：<br/><br/>");
	
				content.append("<ul><li><b>領取地點：</b>本院病歷部（位於港安大廈，詳見地圖）</li>");
				content.append("<li>(時間： 星期一至五: 09:00 – 17:30, 星期日: 09:00 – 13:00)</li>"); 
				content.append("<li><b>授權書：</b><a href='" + getAuthURL(lang) + "'>" + getAuthURL(lang) + "</a></li>");
				content.append("<li><b>查詢：</b>36518809 </li></ul><br/>");
				
				content.append("&nbsp;&nbsp;此致<br/>");
				content.append("親愛的病人及家屬<br/>");
				content.append("香港港安醫院－司徒拔道謹啟");
				content.append("<br/><img src='http://mail.hkah.org.hk/online/images/email/map.png'/>");
					
			} else if ("SMC".equals(lang)) {
				content.append("<u>[报告签發日期: " + rptDate + "]</u><br/>");
				content.append("病人编号 (" + maskedPatno + ")<br/><br/>");
				content.append("CO <b><u>呈" + smcTxtC + "反应</u></b><br/>");
				content.append("A <b><u>呈" + smcTxtA + "反应</u></b><br/>");
				content.append("B <b><u>呈" + smcTxtB + "反应</u></b><br/>");
				content.append("V <b><u>呈" + smcTxtV + "反应</u></b><br/><br/>");
				
				content.append("如上述检测当中验出阳性，本院职员会与你联络。<br/><br/>");
				content.append("请阁下或授权人士(需携同授权书的正本及病人身份证明文件的副本)需领取报告正本，详情如下：<br/><br/>");
	
				content.append("<ul><li><b>领取地点：</b>本院病历部（位于港安大厦，详见地图）</li>");
				content.append("<li>(时间： 星期一至五: 09:00 – 17:30, 星期日: 09:00 – 13:00)</li>"); 
				content.append("<li><b>授权书：</b><a href='" + getAuthURL(lang) + "'>" + getAuthURL(lang) + "</a></li>");
				content.append("<li><b>查询：</b>36518809 </li></ul><br/>");
				
				content.append("&nbsp;&nbsp;此致<br/>");
				content.append("亲爱的病人及家属<br/>");
				content.append("香港港安医院－司徒拔道谨启");
				content.append("<br/><img src='http://mail.hkah.org.hk/online/images/email/map.png'/>");
			} else {
				content.append("<b><u>[Report Issued Date: " + rptDate + "]</u></b><br/>");
				content.append("[Patient No. " + maskedPatno + "]:<br/><br/>");
				content.append("CO <b><u>" + engTxtC + "</u></b><br/>");
				content.append("A <b><u>" + engTxtA + "</u></b><br/>");
				content.append("B <b><u>" + engTxtB + "</u></b><br/>");
				content.append("V <b><u>" + engTxtV + "</u></b><br/><br/>");
				
				content.append("In case of any positive/ detected results, our nurse will contact you for any follow up actions.<br/><br/>");
				content.append("If a hard copy test report is needed, kindly collect by yourself/ an authorized person (bring a hard copy of the authorization letter, and a copy of the patient’s identification document), details as follows:<br/><br/>");
				
				content.append("<ul><li><b>Location:</b>Medical Record (Located at La Rue Building, please see map)</li>");
				content.append("<li>(Time: Mon-Friday: 09:00–17:30, Sun: 09:00-13:00).</li>"); 
				content.append("<li><b>Authorization Letter:</b><a href='" + getAuthURL(lang) + "'>" + getAuthURL(lang) + "</a></li>");
				content.append("<li><b>Enquiries:</b>36518809 </li></ul><br/>");
				
				content.append("Hong Kong Adventist Hospital – Stubbs Road");
				content.append("<br/><img src='http://mail.hkah.org.hk/online/images/email/map.png'/>");
			}
		
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
					
		return content.toString();
	}

	
	// ======================================================================
	private static String getMaskedNum(String num) {
		int maskedLen = 3;
		String maskChar = "X";
		int index = num.length() - maskedLen;
		String markedNum = "";
		
		if (num.length() <= maskedLen)
			return num;
		
		for (int i = 0; i < index; i++) {
			markedNum += maskChar;
		}
		
		return markedNum + num.substring(index);
	}
	
	// ======================================================================
	private static boolean getSuccessOfSMS(String msgId) {
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
	private static boolean updateSMSErrorMsg(String labnum, String msg) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("UPDATE LABO_REPORT_LOG@LIS ");
		sqlStr.append(" SET PAT_NOTIFY_STATUS = 'E', ");
		sqlStr.append(" PAT_RTNMSG = PAT_RTNMSG || ? || '; ' ");
		sqlStr.append(" WHERE LAB_NUM = ? ");
		sqlStr.append(" AND TEST_CAT = 'M'");
		
		return UtilDBWeb.updateQueue(sqlStr.toString(), new String[] { msg, labnum });
	}
	
	// ======================================================================
	private static boolean updateEmailErrorMsg(String labnum, String msg) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("UPDATE LABO_REPORT_LOG@LIS ");
		sqlStr.append(" SET PAT_EMAIL_STATUS = 'E', ");
		sqlStr.append(" PAT_RTNMSG = PAT_RTNMSG || ? || '; ' ");
		sqlStr.append(" WHERE LAB_NUM = ? ");
		sqlStr.append(" AND TEST_CAT = 'M'");
		
		return UtilDBWeb.updateQueue(sqlStr.toString(), new String[] { msg, labnum });
	}

	// ======================================================================
	private static boolean updateSMSSuccessTimeAndMsg(String labnum, String msgId) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("UPDATE LABO_REPORT_LOG@LIS ");
		sqlStr.append(" SET PAT_NOTIFY_STATUS = 'S', ");
		sqlStr.append(" PAT_NOTIFY_DATE = SYSDATE, ");
		sqlStr.append(" PAT_RTNMSG = PAT_RTNMSG || 'SMS' || ? || ':' || (SELECT RES_MSG FROM SMS_LOG WHERE MSG_BATCH_ID = ? and SMCID = 'COVID' and rownum = 1) || '; ' ");
		sqlStr.append(" WHERE LAB_NUM = ? ");
		sqlStr.append(" AND TEST_CAT = 'M'");

		return UtilDBWeb.updateQueue(sqlStr.toString(), new String[] {msgId, msgId, labnum});
	}
	
	// ======================================================================
	private static boolean updateEmailSuccessTimeAndMsg(String labnum) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("UPDATE LABO_REPORT_LOG@LIS ");
		sqlStr.append(" SET PAT_EMAIL_STATUS = 'S', ");
		sqlStr.append(" PAT_NOTIFY_DATE = SYSDATE, ");
		sqlStr.append(" PAT_RTNMSG = PAT_RTNMSG || 'Email sent successfully; ' ");
		sqlStr.append(" WHERE LAB_NUM = ? ");
		sqlStr.append(" AND TEST_CAT = 'M'");

		return UtilDBWeb.updateQueue(sqlStr.toString(), new String[] {labnum});
	}
	
	// ======================================================================	
	private static String getAuthURL(String lang){
		
		StringBuffer sqlStr = new StringBuffer();
		String AuthLetterURL = "https://www.hkah.org.hk/getimage/index/action/images/name/601a39a186e71.pdf";

		sqlStr.append("select PARAM1, PARAM2 from sysparam where parcde='AUTHLETTER'");
		
		ArrayList record = UtilDBWeb.getReportableListHATS(sqlStr.toString());
		ReportableListObject row = null;

		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			
			if ("TRC".equals(lang)) {
				AuthLetterURL = row.getValue(1);
			} else {
				AuthLetterURL = row.getValue(0);
			}
		}
        
        return AuthLetterURL;
	}
}
