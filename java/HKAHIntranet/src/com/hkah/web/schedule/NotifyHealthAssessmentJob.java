package com.hkah.web.schedule;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.Locale;

import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.config.MessageResources;
import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.sms.UtilSMS;
import com.hkah.web.common.ReportableListObject;

public class NotifyHealthAssessmentJob implements Job {

	// ======================================================================
	private static Logger logger = Logger.getLogger(NotifyHealthAssessmentJob.class);
	private static final String dblink = ConstantsServerSide.DEBUG ? "@iweb_uat" : "@iweb";
	private static String sendType = null;

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		Calendar cal = Calendar.getInstance();
		Calendar cal2 = cal;
		Calendar cal3 = cal;
		Calendar cal4 = cal;
		SimpleDateFormat smf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
		SimpleDateFormat smfShort = new SimpleDateFormat("d/M/yy", Locale.ENGLISH);
		SimpleDateFormat jcsmfShort = new SimpleDateFormat("yyyy年M月d日", Locale.JAPAN);
		SimpleDateFormat chismfShort = new SimpleDateFormat("M月d日", Locale.CHINESE);
		cal4.add(Calendar.DATE, 40);
		String smsContentDate = chismfShort.format(cal4.getTime());
		ArrayList record = null;
		ArrayList recordT2CIS = null;
		ArrayList recordT2CIS2 = null;
		ArrayList recordT2CIS3 = null;
		ReportableListObject row = null;
		StringBuffer sqlStr = new StringBuffer();
		String insertT2CIS_sqlStr = null;

		sqlStr.setLength(0);
		sqlStr.append("INSERT INTO PR_APPOINTMENT (");
		sqlStr.append("PATNO, SEQNO, TYPE, LOCATION, PROPOSAL_DATE, ACTUAL_DATE, REMARK, CREATE_BY, CREATE_DATE, UPDATE_BY, "); // 0-9
		sqlStr.append("UPDATE_DATE, CANCEL_BY, CANCEL_DATE, SMS_ID, SMSSDT, SMSSDTOK, SMSRTNMSG, SMS_STATUS, SMS_MOBILE"); //10-18
		sqlStr.append(") VALUES(");
		sqlStr.append("?, TO_NUMBER(?), ?, null, sysdate, null, null, 'SYSTEM', sysdate, 'SYSTEM',");
		sqlStr.append("sysdate, null, null, ?, sysdate, sysdate, ?, ?, ?)");

		insertT2CIS_sqlStr = sqlStr.toString();
		
		if (ConstantsServerSide.isHKAH()) {
			cal.add(Calendar.MONTH, -11);
			record = getSMSList(smf.format(cal.getTime()),"PE-S");

			if (record.size() > 0) {
				for(int i = 0; i < record.size(); i++) {
					row = (ReportableListObject) record.get(i);

					String patNo = row.getValue(0);
					String lang = row.getValue(1);
					String smsContent = "";
					if (lang.length() <= 0) {
						lang = "ENG";
					}

					String phoneNo =
						UtilSMS.getPhoneNo(row.getValue(2).trim(), row.getValue(3).trim(),
										row.getValue(0).trim(), row.getValue(4),
										lang, "", "HA");

					Date lastRegdate = DateTimeUtil.parseDate(row.getValue(5));
					String lastRegdateStr = null;
					if (lang.equals("ENG")) {
						lastRegdateStr = smfShort.format(lastRegdate);
					} else {
						lastRegdateStr = jcsmfShort.format(lastRegdate);
					}

					smsContent = getHATemplate("HA", lang, lastRegdateStr);

//					System.out.println("["+i+"] patNo="+patNo+", lang="+lang+", smsContent=<"+smsContent+">");

					if (smsContent != null) {
						try {
							String msgId = UtilSMS.sendSMS("", new String[] { phoneNo },
									smsContent,
									"HA",  row.getValue(4).trim() , lang, "");
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
					}
				}
			}
		} else if (ConstantsServerSide.isTWAH()) {
			sendType = "Wellness-PC";
			String patNo = null;
			String seqNo = null;
			String lang = null;
			String smsContent = null;

			if ("Wellness-PC".equals(sendType)) {
//				1st Year
				cal.add(Calendar.MONTH, -11);
				System.out.println("[cal.getTime()]:"+cal.getTime());
				recordT2CIS = getSMSList(smf.format(cal.getTime()),null);
				if (recordT2CIS.size() > 0) {
					for(int i = 0; i < recordT2CIS.size(); i++) {
						row = (ReportableListObject)recordT2CIS.get(i);

						patNo = row.getValue(0);
						seqNo = getNextSeq(patNo);

						lang = row.getValue(1);
						smsContent = "";
						if (lang.length() <= 0) {
							lang = "TRC";
						}

						String phoneNo = UtilSMS.getPhoneNo(row.getValue(2).trim(), row.getValue(3).trim(),
											row.getValue(0).trim(), row.getValue(4),
											lang, "", UtilSMS.SMS_TWMKT);

						smsContent = getHATemplate(UtilSMS.SMS_TWMKT, lang, smsContentDate);
/*
						Vector emailTo = new Vector();
						String[] emailListToArray = new String[1];
						String[] mailToCcArray = new String[1];
						boolean sendMailSuccess = false;
						emailListToArray[0]="terence.ho@hkah.org.hk";
						mailToCcArray[0] = "terence.ho@hkah.org.hk";
						// Send mail
						sendMailSuccess = UtilMail.sendMail(
								ConstantsServerSide.MAIL_ALERT,
								emailListToArray,
								mailToCcArray,
								null,
								"TEST HEALTH ASS SMS",
								smsContent);
*/
						if (smsContent != null) {
							try {
								String msgId = UtilSMS.sendSMS("", new String[] { phoneNo },
										smsContent,
										UtilSMS.SMS_TWMKT,  row.getValue(4).trim() , lang, "");
								System.out.println("YR1["+i+"] msgId"+msgId+" patNo="+patNo+",phoneNo"+phoneNo+", lang="+lang+", smsContent=<"+smsContent+">");
								if (msgId!=null&&phoneNo!=null) {
									UtilDBWeb.updateQueueCIS(insertT2CIS_sqlStr, new String[] { patNo, seqNo, sendType, msgId, "OK", "S", phoneNo});
								}
							} catch (IOException e) {
								System.out.println("YR1["+i+"] patNo="+patNo+",phoneNo"+phoneNo+", lang="+lang+", smsContent=<"+smsContent+">");
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						}
					}
				}

//				2nd Year
				cal2.add(Calendar.MONTH, -23);
				System.out.println("[cal2.getTime()]:"+cal2.getTime());
				recordT2CIS2 = getSMSList(smf.format(cal2.getTime()),null);
				row = null;
				patNo = null;
				seqNo = null;
				lang = null;
				smsContent = null;

				if (recordT2CIS2.size() > 0) {
					for(int i = 0; i < recordT2CIS2.size(); i++) {
						row = (ReportableListObject)recordT2CIS2.get(i);
						patNo = row.getValue(0);
						seqNo = getNextSeq(patNo);

						lang = row.getValue(1);
						smsContent = "";
						if (lang.length() <= 0) {
							lang = "TRC";
						}

						String phoneNo = UtilSMS.getPhoneNo(row.getValue(2).trim(), row.getValue(3).trim(),
											row.getValue(0).trim(), row.getValue(4),
											lang, "", UtilSMS.SMS_TWMKT);

						smsContent = getHATemplate(UtilSMS.SMS_TWMKT, lang, smsContentDate);

						if (smsContent != null) {
							try {
								String msgId = UtilSMS.sendSMS("", new String[] { phoneNo },
										smsContent,
										UtilSMS.SMS_TWMKT,  row.getValue(4).trim() , lang, "");
								System.out.println("YR2["+i+"] msgId"+msgId+" patNo="+patNo+",phoneNo"+phoneNo+", lang="+lang+", smsContent=<"+smsContent+">");
								if (msgId!=null&&phoneNo!=null) {
									UtilDBWeb.updateQueueCIS(insertT2CIS_sqlStr, new String[] { patNo, seqNo, sendType, msgId, "OK", "S", phoneNo});
								}
							} catch (IOException e) {
								System.out.println("YR2["+i+"] patNo="+patNo+",phoneNo"+phoneNo+", lang="+lang+", smsContent=<"+smsContent+">");
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						}
					}
				}

//				3rd Year
				cal3.add(Calendar.MONTH, -35);
				recordT2CIS3 = getSMSList(smf.format(cal3.getTime()),null);
				System.out.println("[cal3.getTime()]:"+cal3.getTime());
				row = null;
				patNo = null;
				seqNo = null;
				lang = null;
				smsContent = null;
//				phoneNo = null;

				if (recordT2CIS3.size() > 0) {
					for(int i = 0; i < recordT2CIS3.size(); i++) {
						row = (ReportableListObject)recordT2CIS3.get(i);
						patNo = row.getValue(0);
						seqNo = getNextSeq(patNo);

						lang = row.getValue(1);
						smsContent = "";
						if (lang.length() <= 0) {
							lang = "TRC";
						}

						String phoneNo = UtilSMS.getPhoneNo(row.getValue(2).trim(), row.getValue(3).trim(),
											row.getValue(0).trim(), row.getValue(4),
											lang, "", UtilSMS.SMS_TWMKT);

						smsContent = getHATemplate(UtilSMS.SMS_TWMKT, lang, smsContentDate);

						if (smsContent != null) {
							try {
								String msgId = UtilSMS.sendSMS("", new String[] { phoneNo },
										smsContent,
										UtilSMS.SMS_TWMKT,  row.getValue(4).trim() , lang, "");
								System.out.println("YR3["+i+"] msgId"+msgId+" patNo="+patNo+",phoneNo"+phoneNo+", lang="+lang+", smsContent=<"+smsContent+">");
								if (msgId!=null&&phoneNo!=null) {
									UtilDBWeb.updateQueueCIS(insertT2CIS_sqlStr, new String[] { patNo, seqNo, sendType, msgId, "OK", "S", phoneNo});
								}
							} catch (IOException e) {
								System.out.println("YR3["+i+"] patNo="+patNo+",phoneNo"+phoneNo+", lang="+lang+", smsContent=<"+smsContent+">");
								// TODO Auto-generated catch block
								e.printStackTrace();
							}
						}
					}
				}
			}
		}
	}

	public static ArrayList getSMSList(String date, String pkgCode) {
		StringBuffer sqlStr = new StringBuffer();
		if (ConstantsServerSide.isHKAH()) {
			sqlStr.append("SELECT	 DISTINCT(A.PATNO), P.MOTHCODE, B.BKGMTEL,  P.COUCODE,  B.BKGID, to_char(a.regdate, 'dd/mm/yyyy') ");
			sqlStr.append("from 	 reg@IWEB a, slip@IWEB S, PATIENT@IWEB P, BOOKING@IWEB B, REGPKGLINK@IWEB K ");
			sqlStr.append("WHERE 	 A.SLPNO=S.SLPNO ");
//			sqlStr.append("and 		 regdate >= to_date('20/06/2017 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
			sqlStr.append("and 		 regdate >= to_date('" + date + " 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
//			sqlStr.append("and 		 regdate <= to_date('20/06/2017 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
			sqlStr.append("and 		 regdate <= to_date('" + date + " 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
			sqlStr.append("AND 		 A.REGSTS='N' ");
			sqlStr.append("AND 		 S.SLPSTS <> 'R' ");
			sqlStr.append("AND  	 A.PATNO = P.PATNO(+) ");
			sqlStr.append("AND  	 P.PATNO = B.PATNO ");
			sqlStr.append("AND   	 a.BKGID = B.BKGID ");
//			sqlStr.append("AND 		 P.PATSMS = '-1' ");
			sqlStr.append("AND       A.REGID = K.REGID ");
			sqlStr.append("AND       K.PKGCODE = '" + pkgCode + "' ");
			System.out.println(sqlStr.toString());
		} else {
			sqlStr.append("SELECT	 DISTINCT(A.PATNO), P.MOTHCODE, B.BKGMTEL,  P.COUCODE,  B.BKGID, to_char(a.regdate, 'dd/mm/yyyy') ");
			sqlStr.append("from 	 reg@IWEB a, slip@IWEB S, PATIENT@IWEB P, BOOKING@IWEB B, SLIPTX@IWEB K ");
			sqlStr.append("WHERE 	 A.SLPNO=S.SLPNO ");
			//sqlStr.append("and 		 regdate >= to_date('01/03/2017 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
			sqlStr.append("and 		 regdate >= to_date('" + date + " 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
			//sqlStr.append("and 		 regdate <= to_date('01/03/2017 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
			sqlStr.append("and 		 regdate <= to_date('" + date + " 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
			sqlStr.append("AND 		 A.REGSTS='N' ");
			sqlStr.append("AND 		 S.SLPSTS <> 'R' ");
			sqlStr.append("AND  	 A.PATNO = P.PATNO(+) ");
			sqlStr.append("AND  	 P.PATNO = B.PATNO ");
			sqlStr.append("AND   	 a.BKGID = B.BKGID ");
			sqlStr.append("AND 		 P.PATSMS = '-1' ");
			sqlStr.append("AND       S.SLPNO=K.SLPNO ");
			sqlStr.append("AND REGEXP_LIKE(K.PKGCODE,'^P005$|^P006$|^P005A$|^P006A$|^P003$|^P004$|^P003A$|^P004A$|^PRCHC$|^PRCH3$|^PRCHD$|^PRCH2$|^P001$|^P002$|^P016$|^P017$|^PMF|^PMM|^PTF|^PTM|^PSF|^PSM");
			sqlStr.append("|^P007$|^P010$|^P011$|^P012$|^P018$|^P019$|^P020|^P021|^P022$|^P023$|^PRCH1$|^PRCH4$|^PRCH5$|^PRF01$|^PRM01$|^WC");
			sqlStr.append("')");
		}
		return UtilDBWeb.getReportableList(sqlStr.toString());
	}
/*
	public static String getPhoneNo(String phoneNo, String couCode, String patNo,
			String bkgId, String lang, String smcId, String type) {
		if (patNo != null && patNo.length() > 0) {
			if (phoneNo != null && phoneNo.length() > 0) {
				if (couCode != null && couCode.length() > 0) {
					if (couCode.equals("852") || couCode.equals("853")) {
						if (phoneNo.length() == 8) {
							//send
							return couCode+phoneNo;
						} else {
							//error
							UtilSMS.saveLog("The country code is 852/853, but the phone no. is not 8 digits",
										bkgId, type, lang, smcId);
							return null;
						}
					} else if (couCode.equals("86")) {
						if (phoneNo.substring(0, 1).equals("1") && phoneNo.length() == 11) {
							return couCode+phoneNo;
						} else {
							UtilSMS.saveLog("The country code is 86, but first letter of phone no. is not ''1'' or the phone no. is not 11 digits",
									bkgId, type, lang, smcId);
							return null;
						}
					} else {
						UtilSMS.saveLog("The country code is not 852/853/86",
								bkgId, type, lang, smcId);
						return null;
					}
				} else {
					UtilSMS.saveLog("Country Code is empty value",
							bkgId, type, lang, smcId);
					return null;
				}
				} else {
					UtilSMS.saveLog("Phone No. is empty value",
							bkgId, type, lang, smcId);
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
									bkgId, type, lang, smcId);
							return null;
						}
					} else {
						UtilSMS.saveLog("Phone No. is less than 8 digits",
								bkgId, type, lang, smcId);
						return null;
					}
				} else {
					UtilSMS.saveLog("Phone No. is empty value",
							bkgId, type, lang, smcId);
					return null;
				}
			}
		}
*/
	private static String getNextSeq(String patNo) {
		String seqNo = null;
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT MAX(SEQNO) FROM PR_APPOINTMENT WHERE PATNO = '");
		sqlStr.append(patNo);
		sqlStr.append("'");

		ArrayList result = UtilDBWeb.getReportableListCIS(sqlStr.toString());
		if (result.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
			seqNo = reportableListObject.getValue(0);
			// set 1 for initial
			if (seqNo == null || seqNo.length() == 0) {
				 return "1";
			} else {
				return seqNo;
			}
		} else {
			return "1";
		}
	}

	private static String getHATemplate(String type, String lang, String dateStr) {
		StringBuffer smsContent = new StringBuffer();
		if ("HA".equals(type)) {
			if (lang.equals("ENG")) {
				smsContent.append(MessageResources.getMessageEnglish("prompt.sms.ha.block1", dateStr));
			} else if (lang.equals("TRC")) {
				smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.ha.block1", dateStr));
			} else if (lang.equals("SMC")) {
				smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.ha.block1", dateStr));
			} else if (lang.equals("JAP")) {
				smsContent.append(MessageResources.getMessageJapanese("prompt.sms.ha.block1", dateStr));
			}
		} else if (UtilSMS.SMS_TWMKT.equals(type)) {
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.wc.pc.block1"));
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.wc.pc.block2", dateStr));
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.wc.pc.block3"));
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.wc.pc.block4"));
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.wc.pc.block5"));			
		}

		return smsContent.toString();
	}
}