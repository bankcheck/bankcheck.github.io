package com.hkah.server.services;

import java.io.File;
import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.google.gwt.user.server.rpc.RemoteServiceServlet;
import com.hkah.client.services.AlertService;
import com.hkah.client.util.PasswordUtil;
import com.hkah.server.util.QueryUtil;
import com.hkah.server.util.ServerUtil;
import com.hkah.server.util.StringUtil;
import com.hkah.shared.constants.ConstantsGlobal;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.UserInfo;

import jcifs.smb.NtlmPasswordAuthentication;
import jcifs.smb.SmbFile;
import jcifs.smb.SmbFileOutputStream;

@SuppressWarnings("serial")
public class AlertServiceImpl extends RemoteServiceServlet implements AlertService, ConstantsVariable {
	protected static Logger logger = Logger.getLogger(AlertServiceImpl.class);

	private static final int PROPERTIES_WIDTH = 22;
	private static final SimpleDateFormat dateF = new SimpleDateFormat("dd/MM/yyyy");
	private static final SimpleDateFormat timeF = new SimpleDateFormat("HH:mm:ss");
	private static final SimpleDateFormat filePathDateF = new SimpleDateFormat("yyyyMMddHHmmss");
	private static final String UTF8 = "UTF-8";
//	private static final String MAIL_ALERT_APPDATE = "App. Date";
//	private static final String MAIL_ALERT_DOCTORNAME = "Doctor Name";
	private static final String MAIL_PATIENT_ALERT = "MAIL_PATIENT_ALERT";
	private static final String SERVERURL_PREFIX = "http://";
	private static final String SERVERURL_SUFFIX = "/intranet/HKAHMailServlet?";

	private static String report_login_user = null;
	private static String report_login_pass = null;

	private String serverUrl = null;

	@Override
	public MessageQueue patientMailAlert(UserInfo userInfo, String patno, String funname,
			Map<String, String> params, Map<String, List<String>> addrAltdescs,
			String gAltMalEmail, String gAltMalPth, String gAltMalUrl,
			String patfname, String patgname, String patcname, String miscRemark, boolean thruUrl) {
//		System.out.println("[EmailAlert] Enter AlertServiceImpl........");
		Date now = new Date();
		StringBuffer mqStr = new StringBuffer();
		mqStr.append(MAIL_PATIENT_ALERT);
		mqStr.append(FIELD_DELIMITER);
		mqStr.append(dateF.format(now));
		mqStr.append(FIELD_DELIMITER);
		mqStr.append(timeF.format(now));
		mqStr.append(FIELD_DELIMITER);
		String returnCode = "0";
		String returnMsg = null;

		if (thruUrl) {
			returnMsg = patientMailAlertByPortal(userInfo, patno, funname, params, addrAltdescs, gAltMalEmail, gAltMalUrl, patfname, patgname, patcname, miscRemark, now);
			if (returnMsg != null) {
				returnMsg = patientMailAlertByPath(userInfo, patno, funname, params, addrAltdescs, gAltMalPth, patfname, patgname, patcname, miscRemark, now);
			}
		} else {
			returnMsg = patientMailAlertByPath(userInfo, patno, funname, params, addrAltdescs, gAltMalPth, patfname, patgname, patcname, miscRemark, now);
		}

		if (returnMsg == null) {
			returnMsg = "OK";
		}
		mqStr.append(returnCode);
		mqStr.append(FIELD_DELIMITER);
		mqStr.append(returnMsg);
		mqStr.append(FIELD_DELIMITER);
		mqStr.append(LINE_DELIMITER);

		MessageQueue mq = new MessageQueue(mqStr.toString());
		logger.debug("<<<: " + mqStr.toString());

		return mq;
	}

	private String patientMailAlertByPortal(UserInfo userInfo, String patno, String funname,
			Map<String, String> params, Map<String, List<String>> addrAltdescs, String gAltMalEmail, String gAltMalUrl,
			String patfname, String patgname, String patcname, String miscRemark, Date now) {
		String email = null;
		String key = null;
		String value = null;
		String returnMsg = null;

		Iterator<String> itr2 = null;
		StringBuffer alertList = null;
		List<String> altdescs = null;

		StringBuffer contentLines = new StringBuffer();
		StringBuffer messageLines = new StringBuffer();

		if (addrAltdescs == null || addrAltdescs.isEmpty()) {
			returnMsg = "Empty alert description.";
		} else {
			try {
				for (Iterator<String> itr = addrAltdescs.keySet().iterator(); itr.hasNext(); ) {
					email = itr.next();

					alertList = new StringBuffer();
					altdescs = addrAltdescs.get(email);
					for (String altdesc : altdescs) {
						if (altdesc != null) {
							if (alertList.length() > 0) {
								alertList.append(COMMA_VALUE);
							}
							alertList.append(altdesc);
						}
					}

					contentLines.setLength(0);
					contentLines.append("subject=");
					contentLines.append(URLEncoder.encode("HATS Alert - " + funname, UTF8));
					contentLines.append("&from=");
					contentLines.append(gAltMalEmail);
					contentLines.append("&to=");
					contentLines.append(email);
					contentLines.append("&message=");

					messageLines.setLength(0);
					messageLines.append("<table>");
					messageLines.append("<tr><td>Alert:</td><td><font color='red'>");
					messageLines.append(alertList);
					messageLines.append("</font></td></tr>");

//					if (params != null && params.containsKey(MAIL_ALERT_APPDATE)) {
//						messageLines.append("<tr><td>App. Date:</td><td>");
//						messageLines.append(params.get(MAIL_ALERT_APPDATE));
//						messageLines.append("</td></tr>");
//						params.remove(MAIL_ALERT_APPDATE);
//					}

					messageLines.append("<tr><td>Patient Name:</td><td>");
					messageLines.append(patfname);
					messageLines.append(SPACE_VALUE);
					messageLines.append(patgname);
					if (patcname != null && patcname.length() > 0) {
						messageLines.append(SPACE_VALUE);
						messageLines.append(SMALLER_THAN_VALUE);
						messageLines.append(patcname);
						messageLines.append(GREATER_THAN_VALUE);
					}
					messageLines.append("</td></tr>");

					messageLines.append("<tr><td>Patient No:</td><td>");
					messageLines.append(patno);
					messageLines.append("</td></tr>");

					messageLines.append("<tr><td>Misc Remark:</td><td>");
					messageLines.append(miscRemark);
					messageLines.append("</td></tr>");

//					if (params != null && params.containsKey(MAIL_ALERT_DOCTORNAME)) {
//						messageLines.append("<tr><td>Doctor Name:</td><td>");
//						messageLines.append(params.get(MAIL_ALERT_DOCTORNAME));
//						messageLines.append("</td></tr>");
//						params.remove(MAIL_ALERT_DOCTORNAME);
//					}

					messageLines.append("<tr><td>From:</td><td>");
					messageLines.append(userInfo.getUserName());
					messageLines.append("</td></tr>");

					if (params != null) {
					    for (itr2 = params.keySet().iterator(); itr2.hasNext(); ) {
							key = itr2.next();
							value = params.get(key);
							messageLines.append("<tr><td>");
							messageLines.append(key);
							messageLines.append(":</td><td>");
							messageLines.append(value);
							messageLines.append("</td></tr>");
						}
					}
					messageLines.append("</table>");
					contentLines.append(StringUtil.replaceSpecialChar(URLEncoder.encode(messageLines.toString(), UTF8)));

					ServerUtil.connectServer(getServletURL(gAltMalUrl), contentLines.toString());
				}
			} catch (Exception e) {
				returnMsg = "gAltMalUrl:" + gAltMalUrl + " does not exist or The user has no permission to send mail. Please contact system administrator.";
			}
		}
		return returnMsg;
	}

	private String patientMailAlertByPath(UserInfo userInfo, String patno, String funname,
			Map<String, String> params, Map<String, List<String>> addrAltdescs, String gAltmAlPth,
			String patfname, String patgname, String patcname, String miscRemark, Date now) {
		boolean isWindow = System.getProperty("os.name").toLowerCase().startsWith("windows");
		int seqNo = (int) (Math.random() * 1000);

		String email = null;
		String key = null;
		String value = null;
		String line = null;
		String login_user = getReportLoginID();
		String login_pass = getReportLoginPwd();
		String returnMsg = null;
		int len = -1;

		File winfile = null;
		SmbFile linuxfile = null;
		SmbFileOutputStream fos = null;
		Iterator<String> itr2 = null;
		StringBuffer alertList = null;
		List<String> altdescs = null;
		byte[] contentInBytes = null;
		NtlmPasswordAuthentication auth = null;

		List<String> contentLines = new ArrayList<String>();

		if (addrAltdescs == null || addrAltdescs.isEmpty()) {
			returnMsg = "Empty alert description.";
		} else {
			try {
				if (!isWindow) {
					auth = new NtlmPasswordAuthentication(EMPTY_VALUE, login_user, login_pass);
				}
				for (Iterator<String> itr = addrAltdescs.keySet().iterator(); itr.hasNext(); ) {
					email = itr.next();

					alertList = new StringBuffer();
					altdescs = addrAltdescs.get(email);
					for (String altdesc : altdescs) {
						if (altdesc != null) {
							if (alertList.length() > 0) {
								alertList.append(COMMA_VALUE);
							}
							alertList.append(altdesc);
						}
					}

					contentLines.clear();
					contentLines.add("[subject]");
					contentLines.add("HATS Alert - " + funname);
					contentLines.add("[receipants]");
					contentLines.add(email);
					contentLines.add("[content]");
					contentLines.add("From                  :" + userInfo.getUserName());
					contentLines.add("Patient No            :" + patno);
					contentLines.add("Name                  :" + patfname + " " + patgname + " (" + patcname + ")");
					contentLines.add("Alert                 :" + alertList);
					contentLines.add("Misc Remark           :" + miscRemark);
					if (params != null) {
						for (itr2 = params.keySet().iterator(); itr2.hasNext(); ) {
							key = itr2.next();
							value = params.get(key);

							len = key.length();
							if (len > PROPERTIES_WIDTH) {
								line = key;
								contentLines.add(line);

								line = "                      :" + value;
								contentLines.add(line);
							} else {
								key = StringUtils.rightPad(key, PROPERTIES_WIDTH);
								line = key + ":" + value;
								contentLines.add(line);
							}
						}
					}

//					System.out.println("[EmailAlert] Finish to generate the content of email.........");
					if (isWindow) {
//						System.out.println("[EmailAlert] Generate file to window platform.........");
						winfile = new File(gAltmAlPth + File.separator + filePathDateF.format(now) + seqNo + ConstantsGlobal.ALERT_MAIL_EXTENSION);
//						System.out.println("[EmailAlert] File path: " + gAltmAlPth + File.separator + filePathDateF.format(now) + seqNo + ConstantsGlobal.ALERT_MAIL_EXTENSION);
						FileUtils.writeLines(winfile, contentLines);
					} else {
//						System.out.println("[EmailAlert] Generate file to linux platform.........");
						linuxfile = new SmbFile("smb:" + gAltmAlPth.replace("\\", "/") + "/" + filePathDateF.format(now) + seqNo + ConstantsGlobal.ALERT_MAIL_EXTENSION, auth);

//						System.out.println("[EmailAlert] File path: " + "smb:" + gAltmAlPth.replace("\\", "/") + "/" + filePathDateF.format(now) + seqNo + ConstantsGlobal.ALERT_MAIL_EXTENSION);

						if (!linuxfile.exists()) {
//							System.out.println("[EmailAlert] create file......");
							linuxfile.createNewFile();
						}

//						System.out.println("[EmailAlert] file exist: " + linuxfile.exists());

						fos = new SmbFileOutputStream(linuxfile);

						for (String content : contentLines) {
//							System.out.println("[EmailAlert] content: "+content);
							contentInBytes = (content+"\r\n").getBytes();
							fos.write(contentInBytes);
						}
						fos.flush();
						fos.close();
					}

					seqNo++;
				}
			} catch (IOException e) {
				returnMsg = "gAltmAlPth:" + gAltmAlPth + " does not exist or The user has no permission to create mail file in the folder. Please contact system administrator.";
			}
		}
		return returnMsg;
	}


	private String getServletURL(String gAltMalUrl) {
		if (serverUrl == null) {
			serverUrl = SERVERURL_PREFIX + gAltMalUrl + SERVERURL_SUFFIX;
		}
		return serverUrl;
	}

	private String getReportLoginID() {
		if (report_login_user == null) {
			report_login_user = getSystemParameter("DERptUser");
		}
		return report_login_user;
	}

	private String getReportLoginPwd() {
		if (report_login_pass == null) {
			report_login_pass = PasswordUtil.cisDecryption(getSystemParameter("DERptPwd"));
		}
		return report_login_pass;
	}

	private String getSystemParameter(String paramName) {

		MessageQueue mQueue = QueryUtil.proceedTx(
				new UserInfo(), "NHS",
				ConstantsTx.SYSTEMPARAMETER_TXCODE,
				QueryUtil.getMasterServlet(),
				QueryUtil.ACTION_FETCH,
				new String[] { paramName },
				null, null, QueryUtil.getJndiName());
		if (mQueue.success()) {
			return mQueue.getContentField()[1];
		} else {
			return null;
		}
	}
}