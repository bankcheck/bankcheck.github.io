package com.hkah.util.mobile;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Locale;

import com.hkah.config.MessageResources;
import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.sms.UtilSMS;
import com.hkah.web.common.ReportableListObject;
import com.spreada.utils.chinese.ZHConverter;

public class UtilMobile {

	final static SimpleDateFormat smf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
	/*
	final static SimpleDateFormat esmf = new SimpleDateFormat("'on' dd MMMM yyyy '('EEE') at 'hh:mm a", Locale.ENGLISH);
	final static SimpleDateFormat csmf = new SimpleDateFormat("MM月dd日Eahh時mm分", Locale.CHINESE);
	final static SimpleDateFormat scsmf = new SimpleDateFormat("MM月dd日Eahh时mm分", Locale.SIMPLIFIED_CHINESE);
	final static SimpleDateFormat jcsmf = new SimpleDateFormat("MM月dd日Eahh時mm分", Locale.JAPAN);
	*/
	final static SimpleDateFormat esmf = new SimpleDateFormat("'on' EEE, MMM dd, yyyy' at 'h:mm a", Locale.ENGLISH);
	final static SimpleDateFormat csmf = new SimpleDateFormat("M月dd日Eah時mm分", Locale.CHINESE);
	final static SimpleDateFormat scsmf = new SimpleDateFormat("M月dd日Eah时mm分", Locale.SIMPLIFIED_CHINESE);
	final static SimpleDateFormat jcsmf = new SimpleDateFormat("M月dd日Eah時mm分", Locale.JAPAN);

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

		sqlStr.append("UPDATE BOOKING@IWEB ");
		sqlStr.append("SET SMSSDT = NULL, SMSSDTOK = NULL, SMSRTNMSG = NULL ");
		sqlStr.append("WHERE BKGSDATE >= TO_DATE('" + smf.format(date.getTime()) + " 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
		//sqlStr.append("AND BKGSDATE <= TO_DATE('" + smf.format(date.getTime()) + " 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");

		return UtilDBWeb.updateQueue(sqlStr.toString());
	}
*/
	//======================================================================
	public static boolean updateSuccessTimeAndMsg(String id) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("UPDATE BOOKING@IWEB ");
		sqlStr.append("SET SMSSDTOK = (SELECT SEND_TIME FROM SMS_LOG WHERE KEY_ID = '"+id+"' AND SMS_AC = 'MOBILE' ), ");
		sqlStr.append("SMSRTNMSG = (SELECT RES_MSG FROM SMS_LOG WHERE KEY_ID = '"+id+"' AND SMS_AC = 'MOBILE' ) ");
		sqlStr.append("WHERE BKGID = '"+id+"' ");


		return UtilDBWeb.updateQueue(sqlStr.toString());
	}

	public static boolean saveMsgLog(String errMsg, String keyId, String type, String tempLang, String smcId, int success) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("INSERT INTO SMS_LOG(");
		sqlStr.append("RES_MSG, SUCCESS, SEND_TIME, SENDER, ACT_TYPE, KEY_ID, TEMPLATE_LANG, SMCID, SMS_AC ) ");
		sqlStr.append("VALUES (");
		sqlStr.append("'"+errMsg+"', ");
		sqlStr.append("'"+success+"', ");
		sqlStr.append("SYSDATE, ");
		sqlStr.append("'SYSTEM', ");
		sqlStr.append("'"+type+"', ");
		sqlStr.append("'"+keyId+"', ");
		sqlStr.append("'"+tempLang+"', ");
		sqlStr.append("'"+smcId+"', ");
		sqlStr.append("'MOBILE') ");

		return UtilDBWeb.updateQueue(sqlStr.toString());
	}

	public static HashMap<String, String> getMsgContent(String patno, String smcid, String lang,
			String doccode, String docname, String doccname,
			String bkgsday, String bkgsmonth, String bkgsyear, String bkgshour, String bkgsminute,
			String countrycode, String title) {
		Calendar startCal = Calendar.getInstance();
		HashMap<String, String> docName = new HashMap<String, String>();
		HashMap<String, String> dateTime = new HashMap<String, String>();
		HashMap<String, String> msgContents = new HashMap<String, String>();
		String type = null;
		HashMap<String, String> docTitle = new HashMap<String, String>();
		if (ConstantsServerSide.isHKAH()) {
			if (smcid == null || smcid.length() <= 0) {
				smcid = "1";//set to default - registration desk
			}

			if (patno == null || patno.length() <= 0) {
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
				}
			}
		}

		if (patno != null) {//send sms
			//set the appointment date & time
			startCal.set(Integer.parseInt(bkgsyear), Integer.parseInt(bkgsmonth) - 1,
					Integer.parseInt(bkgsday), Integer.parseInt(bkgshour),
					Integer.parseInt(bkgsminute));

			//set the display name of doctor
			docTitle.put("JAP",title.length() > 0?title.trim():"");
			docTitle.put("ENG",title.length() > 0?title.trim():"");
			docTitle.put("TRC",title.length() > 0?title.trim():"");
			docTitle.put("SMC",title.length() > 0?title.trim():"");

			if ((countrycode.length() > 0) && ConstantsServerSide.isHKAH()) {
				docName.put("ENG", countrycode);
				docName.put("JAP", countrycode);
				docName.put("TRC", countrycode);
				docName.put("SMC", countrycode);
			} else if ((doccode.startsWith("OPD")) && ConstantsServerSide.isHKAH()) {
				docName.put("ENG", doccode);
				docName.put("JAP", doccode);
				docName.put("TRC", doccode);
				docName.put("SMC", doccode);
			} else {
				docName.put("ENG", docname);
				docName.put("JAP", docname);
				docName.put("TRC", docname);
				docName.put("SMC", docname);
			}

			if (docTitle.get("TRC").length() > 0 || docTitle.get("SMC").length() > 0) {
				docName.put("TRC", docTitle.get("TRC").trim() + " " + docName.get("TRC"));
				docName.put("SMC", docTitle.get("SMC").trim() + " " + docName.get("SMC"));
			}

			if (doccname.length() > 0) {
				docName.put("TRC", doccname);
				docName.put("SMC", ZHConverter.convert(doccname, ZHConverter.SIMPLIFIED));

				if (docTitle.get("TRC").length() > 0 ||docTitle.get("SMC").length() > 0 ) {
					if (docTitle.get("TRC").trim().equals("DR.") || docTitle.get("SMC").trim().equals("DR.")) {
						docName.put("TRC",docName.get("TRC") + MessageResources.getMessageTraditionalChinese("prompt.sms.op.doctitle"));
						docName.put("SMC",docName.get("SMC") + MessageResources.getMessageSimplifiedChinese("prompt.sms.op.doctitle"));

					} else if (docTitle.get("TRC").trim().equals("MS") || docTitle.get("TRC").trim().equals("MISS")||
							docTitle.get("SMC").trim().equals("MS") || docTitle.get("SMC").trim().equals("MISS")) {
						docName.put("TRC",docName.get("TRC") + MessageResources.getMessageTraditionalChinese("prompt.sms.op.ms"));
						docName.put("SMC",docName.get("SMC") + MessageResources.getMessageSimplifiedChinese("prompt.sms.op.ms"));
					}
				}
			}

			if ((smcid.equals("9") || smcid.equals("12") || smcid.equals("13")) && ConstantsServerSide.isHKAH()) {

				docName.put("JAP",MessageResources.getMessageJapanese("prompt.sms.fs.dietitianTitle") + docName.get("JAP"));
				docName.put("ENG",docTitle.get(lang) + " " + docName.get(lang));

				if (doccname.length() > 0) {
					docName.put("TRC", doccname);
					docName.put("SMC", doccname);

				} else if (countrycode.length() > 0) {
					docName.put("TRC", countrycode);
					docName.put("SMC", countrycode);

				} else {
					docName.put("TRC", docname);
					docName.put("SMC", docname);

				}
				docName.put("TRC",docName + MessageResources.getMessageTraditionalChinese("prompt.sms.fs.dietitianTitle"));
				docName.put("SMC",docName + MessageResources.getMessageSimplifiedChinese("prompt.sms.fs.dietitianTitle"));
			} else if (docTitle.get("JAP").length() > 0 || docTitle.get("ENG").length() > 0) {
				docName.put("JAP",docTitle.get("JAP") + " " + docName.get("JAP"));
				docName.put("ENG",docTitle.get("ENG") + " " + docName.get("ENG"));
			}

			//set the date time format
			dateTime.put("ENG", esmf.format(startCal.getTime()));
			dateTime.put("TRC", csmf.format(startCal.getTime()).replaceAll("00分", ""));
			dateTime.put("SMC", scsmf.format(startCal.getTime()).replaceAll("00分", ""));
			dateTime.put("JAP", jcsmf.format(startCal.getTime()).replaceAll("00分", ""));

			/*msgContent = getMsgContent(patno, smcid, lang, docName.toUpperCase(), dateTime);*/
			msgContents.put("ENG", getMsgContent(patno, smcid, "ENG", docName.get("ENG").toUpperCase(), dateTime.get("ENG")));
			msgContents.put("TRC", getMsgContent(patno, smcid, "TRC", docName.get("TRC"), dateTime.get("TRC")));
			msgContents.put("SMC", getMsgContent(patno, smcid, "SMC", docName.get("SMC"), dateTime.get("SMC")));
			msgContents.put("JAP", getMsgContent(patno, smcid, "JAP", docName.get("JAP"), dateTime.get("JAP")));
		}
		return msgContents;
	}

	private static String getMsgContent(String patNo, String smcid, String lang,
			String docName, String dateTime) {
		if (ConstantsServerSide.isHKAH()) {
			if (smcid.equals("5") || smcid.equals("6") || smcid.equals("7") || smcid.equals("8") || smcid.equals("10")) {
				if ((patNo == null) || patNo.length() <= 0) {
					return null;
				} else {
					return getRehabTemplate( lang, docName, dateTime, smcid);
				}
			} else if (smcid.equals("9") ||smcid.equals("12") || smcid.equals("13")) {
				if ((patNo == null) || patNo.length() <= 0) {
					return null;
				} else {
					if (smcid.equals("9")) {
						return getFSTemplate( lang, docName, dateTime);
					} else if (smcid.equals("13")) {
						return getLMCTemplate( lang, docName, dateTime);
					} else {
						return getFS7Template( lang, docName, dateTime);
					}
				}

			} else if (smcid.equals("11")) {
				if ((patNo == null) || patNo.length() <= 0) {
					return getnewDentalTemplate(docName, dateTime);
				} else {
					return getDentalTemplate( lang, docName, dateTime);
				}
			}

			if ((patNo == null) || patNo.length() <= 0) {
				return getnewPatientTemplate(docName, dateTime);
			} else if (smcid.equals("1")) {
				if (docName.startsWith("OPD")) {
					return getOPDRegTemplate(lang,dateTime);
				} else {
					return getRegDeskTemplate((patNo == null), lang, docName, dateTime);
				}
			} else if (smcid.equals("2")) {
				return getHCTemplate((patNo == null), lang, docName, dateTime);
			} else if (smcid.equals("3")) {
				return getHATemplate((patNo == null), lang, docName, dateTime);
			} else if (smcid.equals("4")) {
				return getOncologyTemplate((patNo == null), lang, docName, dateTime);
			} else {
				return null;
			}
		} else {
			if (smcid.equals("1") || smcid.equals("2")) {
				return getWCTemplate(lang, docName, dateTime);
			} else {
				return getWCTemplate(lang, docName, dateTime);
			}
		}
	}

	//======================================================================
	private static boolean isHolidayAndDisableSMS(Calendar date) {
		StringBuffer sqlStr = new StringBuffer();

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


	//======================================================================

	//======================================================================
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
	private static String getnewPatientTemplate(String docName, String dateTime) {
		StringBuffer smsContent = new StringBuffer();

		smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.newpatient.block1"));
		smsContent.append(" ");
		smsContent.append(docName);
		smsContent.append(" ");
		smsContent.append(dateTime);
		smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.newpatient.block2"));

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
											String docName, String dateTime) {
		StringBuffer smsContent = new StringBuffer();

		if (lang.equals("ENG")) {
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.reg.block1"));
			smsContent.append(" ");
			smsContent.append(docName);
			smsContent.append(" ");
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageEnglish("prompt.sms.op.reg.block2"));
		} else if (lang.equals("TRC")) {
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.reg.block1"));
			smsContent.append(docName);
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.reg.block2"));
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageTraditionalChinese("prompt.sms.op.reg.block3"));
		} else if (lang.equals("SMC")) {
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.reg.block1"));
			smsContent.append(docName);
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.reg.block2"));
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageSimplifiedChinese("prompt.sms.op.reg.block3"));
		} else if (lang.equals("JAP")) {
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.reg.block1"));
			smsContent.append(docName);
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.reg.block2"));
			smsContent.append(dateTime);
			smsContent.append(MessageResources.getMessageJapanese("prompt.sms.op.reg.block3"));
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
		sql_getSuccessStats.append("WHERE key = '"+msgId+"' ");

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
}