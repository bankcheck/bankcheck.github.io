package com.hkah.util.mail;

import java.io.File;
import java.util.ArrayList;
import java.util.Properties;
import java.util.Vector;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.Message;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;

import com.hkah.config.MessageResources;
import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.PasswordUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class UtilMail implements ConstantsVariable {
	private static Logger logger = Logger.getLogger(UtilMail.class);
	private static String domain_email_suffix = null;
	private static final String TRUE = "true";
	private static String sqlStr_getEmailIDPwd = null;
	private static String sqlStr_getEmailById = null;

	public static boolean sendMail(String emailFrom, String emailTo,
			String subject, String message) {
		return sendMail(emailFrom, new String[] { emailTo }, null, null, subject, message);
	}

	public static boolean sendMail(String emailFrom, String emailTo,
			String subject, String message, boolean skipBccAdmin) {
		return sendMail(emailFrom, new String[] { emailTo }, null, null, subject, message, null, null, skipBccAdmin);
	}

	public static boolean sendMail(String emailFrom, String emailTo, String emailBCC,
			String subject, String message) {
		return sendMail(emailFrom, new String[] { emailTo }, null, new String[] { emailBCC }, subject, message);
	}

	public static boolean sendMail(String emailFrom, String emailTo, String emailBCC[],
			String subject, String message) {
		return sendMail(emailFrom, new String[] { emailTo }, null, emailBCC, subject, message);
	}

	public static boolean sendMail(String emailFrom, String emailTo, String emailBCC[], String replyTo[],
			String subject, String message) {
		return sendMail(emailFrom, new String[] { emailTo }, replyTo, emailBCC, replyTo, subject, message);
	}

	public static boolean sendMail(String emailFrom, String emailTo[], String subject, String message) {
		return sendMail(emailFrom, emailTo, null, null, subject, message);
	}

	public static boolean sendMail(String emailFrom, String emailTo[], String emailCC[], String emailBCC[],
			String subject, String message) {
		return sendMail( emailFrom, emailTo, emailCC, emailBCC, subject, message, null, null, false);
	}
	
	// can select host
	public static boolean sendMail(String host, String emailFrom, String emailTo[], String emailCC[], String emailBCC[],
			String subject, String message) {
		return sendMail(host, emailFrom, emailTo,
				emailCC, emailBCC, null,
				subject, message, null,
				null, false, false,
				null, 0);
	}

	public static boolean sendMail(String emailFrom, String emailTo[], String emailCC[], String emailBCC[],
			String replyTo[], String subject, String message) {
		return sendMail( emailFrom, emailTo, emailCC, emailBCC, replyTo, subject, message, null, null, false);
	}

	public static boolean sendMail(String emailFrom, String emailTo[],
								String emailCC[], String emailBCC[],
								String subject, String message, int priorityValue) {
		return sendMail(emailFrom, emailTo, emailCC, emailBCC, null, subject,
						message, null, null, false, false, null, priorityValue);
	}

	public static boolean sendMail(String emailFrom, String emailTo[],
									String emailCC[], String emailBCC[],
									String subject, String message, File file,
									String filename, boolean skipBccAdmin) {
		return sendMail(emailFrom, emailTo, emailCC, emailBCC, null,
						subject, message, file, filename, skipBccAdmin);
	}
	
//20211004 Arran added for sending multiple attachment
	public static boolean sendMail2(String emailFrom, String emailTo[],
			String emailCC[], String emailBCC[],
			String subject, String message, File file[],
			String filename[], boolean skipBccAdmin) {
		
		return sendMail2(ConstantsServerSide.MAIL_HOST, emailFrom, emailTo,
				emailCC, emailBCC, null,
				subject, message, file,
				filename, skipBccAdmin, false,
				null, 0);		
	}

	public static boolean sendMail(String emailFrom, String emailTo[],
							String emailCC[], String emailBCC[], String subject,
							String message, boolean includeEmailToInContent) {
		return sendMail(emailFrom, emailTo, emailCC, emailBCC, null,
						subject, message,includeEmailToInContent);
	}

	public static boolean sendMail(String emailFrom, String emailTo[],
									String emailCC[], String emailBCC[], String replyTo[],
									String subject, String message, File file,
									String filename, boolean skipBccAdmin) {
		return sendMail(emailFrom, emailTo, emailCC, emailBCC, replyTo, subject,
				message, file, filename, skipBccAdmin, false, null, 0);
	}

	public static boolean sendMail(String emailFrom, String emailTo[],
			String emailCC[], String emailBCC[], String replyTo[],
			String subject, String message,
			boolean includeEmailToInContent) {
		return sendMail(emailFrom, emailTo, emailCC, emailBCC, replyTo,
				subject, message, null, null, false, includeEmailToInContent,
				null, 0);
	}

	public static boolean sendMail(String emailFrom, String emailTo[],
									String emailCC[], String emailBCC[], String replyTo[],
									String subject, String message,
									boolean includeEmailToInContent, String emailFromName) {
		return sendMail(emailFrom, emailTo, emailCC, emailBCC, replyTo,
				subject, message, null, null, false, includeEmailToInContent,
				emailFromName, 0);
	}

	public static boolean sendMail(String emailFrom, String emailTo[],
									String emailCC[], String emailBCC[], String replyTo[],
									String subject, String message,
									String emailFromName) {
		return sendMail(emailFrom, emailTo, emailCC, emailBCC, replyTo,
				subject, message, null, null, false, false,
				emailFromName, 0);
	}
	
	public static boolean sendMail(String emailFrom, String emailTo[],
			String emailCC[], String emailBCC[], String replyTo[],
			String subject, String message, File file,
			String filename, boolean skipBccAdmin, boolean includeEmailToInContent,
			String emailFromName, int priorityValue) {
		return sendMail(ConstantsServerSide.MAIL_HOST, emailFrom, emailTo,
				emailCC, emailBCC, replyTo,
				subject, message, file,
				filename, skipBccAdmin, includeEmailToInContent,
				emailFromName, priorityValue);
	}
	
	public static boolean sendMail(String host, String emailFrom, String emailTo[],
									String emailCC[], String emailBCC[], String replyTo[],
									String subject, String message, File file,
									String filename, boolean skipBccAdmin, boolean includeEmailToInContent,
									String emailFromName, int priorityValue) {
		String newSubject = null;
		if (includeEmailToInContent) {
			StringBuffer newSubjectSB = new StringBuffer();
			newSubjectSB.append("(");
			for (int i = 0; i < emailTo.length; i++) {
				newSubjectSB.append(SPACE_VALUE);
				newSubjectSB.append(emailTo[i]);
			}
			newSubjectSB.append(")");
			newSubjectSB.append(SPACE_VALUE);
			newSubjectSB.append(subject);
			newSubject = newSubjectSB.toString();
		} else {
			newSubject = subject;
		}

		// domain email
		boolean rv1 = sendMailHelper(
				host, emailFrom, emailTo, emailCC, emailBCC,
				replyTo, newSubject, message, true, true,
				file, filename, skipBccAdmin, emailFromName, priorityValue);

		// external email
		boolean rv2 = sendMailHelper(
				host, emailFrom, emailTo, emailCC, emailBCC,
				replyTo, subject, message, true, false,
				file, filename, skipBccAdmin, emailFromName, priorityValue);

		return rv1 || rv2;
	}
	
//20211004 Arran added for sending multiple attachment 			
	public static boolean sendMail2(String host, String emailFrom, String emailTo[],
			String emailCC[], String emailBCC[], String replyTo[],
			String subject, String message, File file[],
			String filename[], boolean skipBccAdmin, boolean includeEmailToInContent,
			String emailFromName, int priorityValue) {

		String newSubject = null;

		if (includeEmailToInContent) {
			StringBuffer newSubjectSB = new StringBuffer();
			newSubjectSB.append("(");

			for (int i = 0; i < emailTo.length; i++) {
				newSubjectSB.append(SPACE_VALUE);
				newSubjectSB.append(emailTo[i]);
			}
			
			newSubjectSB.append(")");
			newSubjectSB.append(SPACE_VALUE);
			newSubjectSB.append(subject);
			newSubject = newSubjectSB.toString();
		} else {
			newSubject = subject;
		}

// domain email
		boolean rv1 = sendMailHelper(
				host, emailFrom, emailTo, emailCC, emailBCC,
				replyTo, newSubject, message, true, true,
				file, filename, skipBccAdmin, emailFromName, priorityValue);

// external email
		boolean rv2 = sendMailHelper(
				host, emailFrom, emailTo, emailCC, emailBCC,
				replyTo, subject, message, true, false,
				file, filename, skipBccAdmin, emailFromName, priorityValue);

		return rv1 || rv2;
	}

	private static boolean sendMailHelper(String host, String emailFrom,
									String emailTo[], String emailCC[],
									String emailBCC[], String replyTo[],
									String subject, String message,
									boolean specialHandleEmail, boolean isDomainOnly,
									File file, String filename, boolean skipBccAdmin,
									String emailFromName,
									int priorityValue) {

		// Get system properties
		Properties props = System.getProperties();

		// Setup mail server
		props.put("mail.transport.protocol","smtp");
		props.put("mail.smtp.host", host);
		props.put("mail.smtp.port", ConstantsServerSide.MAIL_SMTP_PORT);
		props.put("mail.smtp.auth", (specialHandleEmail && !isDomainOnly) ? TRUE : ConstantsServerSide.MAIL_SMTP_AUTH);
		props.put("mail.smtp.connectiontimeout", ConstantsServerSide.MAIL_SMTP_CONNECTIONTIMEOUT);
		props.put("mail.smtp.timeout", ConstantsServerSide.MAIL_SMTP_TIMEOUT);

		System.err.println("sendMail:host[" + host + "]emailFrom[" + emailFrom + "]subject[" + subject + "]message[HIDDEN]skipBccAdmin[" + skipBccAdmin + "]");

		String[] email_IDPwd = getIDPwd(emailFrom);
		String emailID = null;
		String emailEncryptedPwd = null;
		String emailDefault = null;
		StringBuffer emailMessage = null;

		if (email_IDPwd != null && email_IDPwd.length == 2) {
			emailID = email_IDPwd[0];
			emailEncryptedPwd = email_IDPwd[1];
			emailDefault = emailFrom;
		} else {
			emailID = ConstantsServerSide.MAIL_SMTP_USERNAME;
			emailEncryptedPwd = ConstantsServerSide.MAIL_SMTP_PASSWORD;
			emailDefault = ConstantsServerSide.MAIL_ALERT;
		}

		Authenticator authenticator = null;
		try {
			if (specialHandleEmail && !isDomainOnly) {
				authenticator = getEmailAuthenticator(emailID, emailEncryptedPwd);
			}

			// Get session
			Session session = Session.getInstance(props, authenticator);
			session.setDebug(false);

			InternetAddress emailFromInternetAddr = null;
			if (emailFromName == null || emailFromName.trim().length() == 0) {
				int index = emailFrom.indexOf("@");
				if (index > 0) {
					emailFromName = emailFrom.substring(0, index);
				} else {
					emailFromName = emailFrom;
				}
			}
			emailFromInternetAddr = new InternetAddress(emailFrom, emailFromName);

			// Define message
			MimeMessage msg = new MimeMessage(session);
			if (specialHandleEmail && !isDomainOnly) {
				msg.setFrom(new InternetAddress(emailDefault, emailFromName));
			} else {
				msg.setFrom(emailFromInternetAddr);
			}

			if (replyTo!= null && replyTo.length > 0) {
				Address[] replyAddress = new Address[replyTo.length];
				for (int i = 0; i < replyTo.length; i++) {
					if (isValidEmailAddress(replyTo[i]) && replyTo[i].length() > 0) {
						replyAddress[i] = new InternetAddress(replyTo[i]);
					}
				}
				if (replyAddress != null && replyAddress.length > 0) {
					msg.setReplyTo(replyAddress);
				}
			} else if (specialHandleEmail && !isDomainOnly) {
				msg.setReplyTo(new InternetAddress[] { emailFromInternetAddr });
			}

			//1 - highest priority to 5 - lowest priority
			if (priorityValue >= 1 && priorityValue <= 5) {
				msg.setHeader("X-Priority", String.valueOf(priorityValue));
			}

			MimeBodyPart mbp1 = new MimeBodyPart();
			MimeBodyPart mbp2 = new MimeBodyPart();
			Multipart mp = new MimeMultipart();
			boolean isDomainEmailFlag = false;

			// counter for email address
			int count = 0;

			StringBuffer sb = new StringBuffer();
			if (emailTo != null) {
				for (int i = 0; i < emailTo.length; i++) {
					isDomainEmailFlag = isDomainEmail(emailTo[i]);

					if (!specialHandleEmail || (isDomainOnly && isDomainEmailFlag) || (!isDomainOnly && !isDomainEmailFlag)) {
						if (ConstantsServerSide.DEBUG) {
							sb.append("emailTo[" + i + "][<b>" + emailTo[i] + "</b>]<br/>");
						} else {
							msg.addRecipient(Message.RecipientType.TO, new InternetAddress(emailTo[i]));
							count++;
						}
					}
				}
			}
			if (emailCC != null) {
				for (int i = 0; i < emailCC.length; i++) {
					isDomainEmailFlag = isDomainEmail(emailCC[i]);

					if (!specialHandleEmail || (isDomainOnly && isDomainEmailFlag) || (!isDomainOnly && !isDomainEmailFlag)) {
						if (ConstantsServerSide.DEBUG) {
							sb.append("emailCC[" + i + "][<b>" + emailCC[i] + "</b>]<br/>");
						} else {
							msg.addRecipient(Message.RecipientType.CC, new InternetAddress(emailCC[i]));
							count++;
						}
					}
				}
			}
			if (emailBCC != null) {
				for (int i = 0; i < emailBCC.length; i++) {
					isDomainEmailFlag = isDomainEmail(emailBCC[i]);

					if (!specialHandleEmail || (isDomainOnly && isDomainEmailFlag) || (!isDomainOnly && !isDomainEmailFlag)) {
						if (ConstantsServerSide.DEBUG) {
							sb.append("emailBCC[" + i + "][<b>" + emailBCC[i] + "</b>]<br/>");
						} else {
							msg.addRecipient(Message.RecipientType.BCC, new InternetAddress(emailBCC[i]));
							count++;
						}
					}
				}
			}

			// send copy to email admin for monitor
			if (!skipBccAdmin)
				msg.addRecipient(Message.RecipientType.BCC, new InternetAddress(ConstantsServerSide.MAIL_ADMIN));

			// append to, cc, bcc email address
			if (ConstantsServerSide.DEBUG) {
				msg.addRecipient(Message.RecipientType.TO, new InternetAddress(ConstantsServerSide.MAIL_ALERT));
				message = sb.toString() + message;
			}

			// only send email if debug or email address counter > 0
			if (ConstantsServerSide.DEBUG || count > 0) {
				msg.setSubject(subject, "utf-8");
//				msg.setText(message);

				emailMessage = new StringBuffer();
				emailMessage.append(message);
				emailMessage.append(MessageResources.getMessageTraditionalChinese("prompt.email.footer"));

				if (file != null) {
					mbp1.setContent(emailMessage.toString(), "text/html;charset=UTF-8");

					FileDataSource fds = new FileDataSource(file);
					mbp2.setDataHandler(new DataHandler(fds));
					mbp2.setFileName(filename);

					mp.addBodyPart(mbp1);
					mp.addBodyPart(mbp2);

					msg.setContent(mp, "text/html;charset=UTF-8");
				} else {
					msg.setContent(emailMessage.toString(), "text/html;charset=UTF-8");
				}

				// Send message
				logger.trace(DateTimeUtil.getCurrentDateTimeStandard()
						+ " Email sent (host: " + host + ")\n"
						+ "\tSubject: " + msg.getSubject()
						+ "\t\tFrom: " + StringUtils.join(msg.getFrom())
						+ "\t\tTo: " + StringUtils.join(msg.getRecipients(Message.RecipientType.TO), COMMA_VALUE)
						+ "\t\tCc: " + StringUtils.join(msg.getRecipients(Message.RecipientType.CC), COMMA_VALUE)
						+ "\t\tBcc: " + StringUtils.join(msg.getRecipients(Message.RecipientType.BCC), COMMA_VALUE));

				Transport.send(msg);
				return true;
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.trace(DateTimeUtil.getCurrentDateTimeStandard() + " Error send mail: " + e.getMessage());
		}
		return false;
	}
	
//20211004 Arran added for sending multiple attachment 	
	private static boolean sendMailHelper(String host, String emailFrom,
			String emailTo[], String emailCC[],
			String emailBCC[], String replyTo[],
			String subject, String message,
			boolean specialHandleEmail, boolean isDomainOnly,
			File file[], String filename[], boolean skipBccAdmin,
			String emailFromName,
			int priorityValue) {

// Get system properties
			Properties props = System.getProperties();

// Setup mail server
			props.put("mail.transport.protocol","smtp");
			props.put("mail.smtp.host", host);
			props.put("mail.smtp.port", ConstantsServerSide.MAIL_SMTP_PORT);
			props.put("mail.smtp.auth", (specialHandleEmail && !isDomainOnly) ? TRUE : ConstantsServerSide.MAIL_SMTP_AUTH);
			props.put("mail.smtp.connectiontimeout", ConstantsServerSide.MAIL_SMTP_CONNECTIONTIMEOUT);
			props.put("mail.smtp.timeout", ConstantsServerSide.MAIL_SMTP_TIMEOUT);
			
			System.err.println("sendMail:host[" + host + "]emailFrom[" + emailFrom + "]subject[" + subject + "]message[HIDDEN]skipBccAdmin[" + skipBccAdmin + "]");

			String[] email_IDPwd = getIDPwd(emailFrom);
			String emailID = null;
			String emailEncryptedPwd = null;
			String emailDefault = null;
			StringBuffer emailMessage = null;

			if (email_IDPwd != null && email_IDPwd.length == 2) {
				emailID = email_IDPwd[0];
				emailEncryptedPwd = email_IDPwd[1];
				emailDefault = emailFrom;
			} else {
				emailID = ConstantsServerSide.MAIL_SMTP_USERNAME;
				emailEncryptedPwd = ConstantsServerSide.MAIL_SMTP_PASSWORD;
				emailDefault = ConstantsServerSide.MAIL_ALERT;
			}

			Authenticator authenticator = null;
			
			try {
				if (specialHandleEmail && !isDomainOnly) {
					authenticator = getEmailAuthenticator(emailID, emailEncryptedPwd);
				}

// Get session
				Session session = Session.getInstance(props, authenticator);
				session.setDebug(false);

				InternetAddress emailFromInternetAddr = null;

				if (emailFromName == null || emailFromName.trim().length() == 0) {
					int index = emailFrom.indexOf("@");

					if (index > 0) {
						emailFromName = emailFrom.substring(0, index);
					} else {
						emailFromName = emailFrom;
					}
				}
				
				emailFromInternetAddr = new InternetAddress(emailFrom, emailFromName);

// Define message
				MimeMessage msg = new MimeMessage(session);
				
				if (specialHandleEmail && !isDomainOnly) {
					msg.setFrom(new InternetAddress(emailDefault, emailFromName));
				} else {
					msg.setFrom(emailFromInternetAddr);
				}

				if (replyTo!= null && replyTo.length > 0) {
					Address[] replyAddress = new Address[replyTo.length];
					
					for (int i = 0; i < replyTo.length; i++) {
						if (isValidEmailAddress(replyTo[i]) && replyTo[i].length() > 0) {
							replyAddress[i] = new InternetAddress(replyTo[i]);
						}
					}

					if (replyAddress != null && replyAddress.length > 0) {
						msg.setReplyTo(replyAddress);
					}
					
				} else if (specialHandleEmail && !isDomainOnly) {
					msg.setReplyTo(new InternetAddress[] { emailFromInternetAddr });
				}

//1 - highest priority to 5 - lowest priority
				if (priorityValue >= 1 && priorityValue <= 5) {
					msg.setHeader("X-Priority", String.valueOf(priorityValue));
				}

				MimeBodyPart mbp1 = new MimeBodyPart();
				
				Multipart mp = new MimeMultipart();
				boolean isDomainEmailFlag = false;

// counter for email address
				int count = 0;

				StringBuffer sb = new StringBuffer();
				if (emailTo != null) {
					for (int i = 0; i < emailTo.length; i++) {
						isDomainEmailFlag = isDomainEmail(emailTo[i]);

						if (!specialHandleEmail || (isDomainOnly && isDomainEmailFlag) || (!isDomainOnly && !isDomainEmailFlag)) {
							if (ConstantsServerSide.DEBUG) {
								sb.append("emailTo[" + i + "][<b>" + emailTo[i] + "</b>]<br/>");
							} else {
								msg.addRecipient(Message.RecipientType.TO, new InternetAddress(emailTo[i]));
								count++;
							}
						}
					}
				}
				
				if (emailCC != null) {
					for (int i = 0; i < emailCC.length; i++) {
						isDomainEmailFlag = isDomainEmail(emailCC[i]);
						
						if (!specialHandleEmail || (isDomainOnly && isDomainEmailFlag) || (!isDomainOnly && !isDomainEmailFlag)) {
							if (ConstantsServerSide.DEBUG) {
								sb.append("emailCC[" + i + "][<b>" + emailCC[i] + "</b>]<br/>");
							} else {
								msg.addRecipient(Message.RecipientType.CC, new InternetAddress(emailCC[i]));
								count++;
							}
						}
					}
				}

				if (emailBCC != null) {
					for (int i = 0; i < emailBCC.length; i++) {
						isDomainEmailFlag = isDomainEmail(emailBCC[i]);

						if (!specialHandleEmail || (isDomainOnly && isDomainEmailFlag) || (!isDomainOnly && !isDomainEmailFlag)) {
							if (ConstantsServerSide.DEBUG) {
								sb.append("emailBCC[" + i + "][<b>" + emailBCC[i] + "</b>]<br/>");
							} else {
								msg.addRecipient(Message.RecipientType.BCC, new InternetAddress(emailBCC[i]));
								count++;
							}
						}
					}
				}
				
// send copy to email admin for monitor
				if (!skipBccAdmin)
					msg.addRecipient(Message.RecipientType.BCC, new InternetAddress(ConstantsServerSide.MAIL_ADMIN));

// append to, cc, bcc email address
				if (ConstantsServerSide.DEBUG) {
					msg.addRecipient(Message.RecipientType.TO, new InternetAddress(ConstantsServerSide.MAIL_ALERT));
					message = sb.toString() + message;
				}

// only send email if debug or email address counter > 0
				if (ConstantsServerSide.DEBUG || count > 0) {
					msg.setSubject(subject, "utf-8");
//msg.setText(message);

					emailMessage = new StringBuffer();
					emailMessage.append(message);
					emailMessage.append(MessageResources.getMessageTraditionalChinese("prompt.email.footer"));
					
					if (file != null) {
						
						mbp1.setContent(emailMessage.toString(), "text/html;charset=UTF-8");
						mp.addBodyPart(mbp1);
						
						for ( int i = 0; i < file.length; i++) {
							FileDataSource fds = new FileDataSource(file[i]);
							MimeBodyPart mbp2 = new MimeBodyPart();
							
							mbp2.setDataHandler(new DataHandler(fds));
							
							if (i < filename.length)
								mbp2.setFileName(filename[i]);
							else
								mbp2.setFileName("file" + i);
		
							mp.addBodyPart(mbp2);						
						}
						
						msg.setContent(mp, "text/html;charset=UTF-8");
						
					} else {
						msg.setContent(emailMessage.toString(), "text/html;charset=UTF-8");
					}

// Send message
					logger.trace(DateTimeUtil.getCurrentDateTimeStandard()
							+ " Email sent (host: " + host + ") Testing class\n"
							+ "\tSubject: " + msg.getSubject()
							+ "\t\tFrom: " + StringUtils.join(msg.getFrom())
							+ "\t\tTo: " + StringUtils.join(msg.getRecipients(Message.RecipientType.TO), COMMA_VALUE)
							+ "\t\tCc: " + StringUtils.join(msg.getRecipients(Message.RecipientType.CC), COMMA_VALUE)
							+ "\t\tBcc: " + StringUtils.join(msg.getRecipients(Message.RecipientType.BCC), COMMA_VALUE));
					
					Transport.send(msg);
					return true;
				}
			} catch (Exception e) {
				e.printStackTrace();
				logger.trace(DateTimeUtil.getCurrentDateTimeStandard() + " Error send mail: " + e.getMessage());
			}
			return false;
	}
	
	private static boolean isDomainEmail(String email) {
		return email != null && email.toLowerCase().indexOf(getDomainEmailSuffix()) > 0;
	}

	private static String getDomainEmailSuffix() {
		if (domain_email_suffix == null) {
			domain_email_suffix = ("@" + ConstantsServerSide.SITE_CODE + ".org.hk").toLowerCase();
		}
		return domain_email_suffix;
	}

	public static boolean insertEmailLog(UserBean userbean, String keyId,
										String actType, String mailType,
										boolean success, String error) {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("INSERT INTO EMAIL_LOG( ");
		sqlStr.append("KEY_ID, ACT_TYPE, MAIL_TYPE, SEND_TIME, SENDER, ");
		sqlStr.append("SUCCESS, ERROR_MSG) VALUES('");
		sqlStr.append(keyId);
		sqlStr.append("', '");
		sqlStr.append(actType);
		sqlStr.append("', '");
		sqlStr.append(mailType);
		sqlStr.append("', ");
		sqlStr.append("SYSDATE, '");
		sqlStr.append(userbean == null ? "SYSTEM" : userbean.getLoginID());
		sqlStr.append("','");
		sqlStr.append(success?"1":"0");
		sqlStr.append("', '");
		sqlStr.append(error != null ? error : "");
		sqlStr.append("')");

		return UtilDBWeb.updateQueue(sqlStr.toString());
	}

//20230516 new report email log	for patient COVID reports
	public static String insertDMSEmailLog(String rptId, String rptType, 
			String patno, String patemail, String rptDate, String srcPath,     
			String fname, String password) {
		
		String patfname = null;
		String patgname = null;
		String patcname = null;
		String patsex = null;
		
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT PATFNAME, PATGNAME, PATCNAME, PATSEX FROM PATIENT WHERE PATNO = ?");
		
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableListHATS(sqlStr.toString(), new String[] {patno});
		ReportableListObject row = null;

		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			patfname = row.getValue(0);
			patgname = row.getValue(1);
			patcname = row.getValue(2);
			patsex   = row.getValue(3);
		}

		return insertPatDMSEmailLog( rptId, rptType, 
				patno, patfname, patgname, patcname, patsex,
				patemail, rptDate, srcPath,     
				fname, password );	
	}
	
//20230626
	public static String insertPatDMSEmailLog(String rptId, String rptType, 
			String patno, String patfname, String patgname, String patcname, String patsex, 
			String email, String rptDate, String srcPath, String fname, String password ) {
		
		return insertDMSEmailLog("PAT", rptId, rptType, patno, patfname, patgname, patcname, patsex,
			null, null, null, null,	email, rptDate, srcPath, fname, password);
	}
	
//20230516 new report email log	
	public static String insertDMSEmailLog(String rcpType, String rptId, String rptType, 
			String patno, String patfname, String patgname, String patcname, String patsex,
			String doccode, String docfname, String docgname, String regid,
			String email, String rptDate, String srcPath,     
			String fname, String password ) {
		
		StringBuffer sqlStr = new StringBuffer();		
		String logId = null;

		sqlStr.append("SELECT SEQ_DMS_EMAIL_LOG_ID.nextval FROM DUAL");
		
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableListCIS(sqlStr.toString());
		ReportableListObject row = null;

		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			logId = row.getValue(0);
		}
 
		sqlStr = new StringBuffer();	
		sqlStr.append("INSERT INTO DMS_EMAIL_LOG ( ");
		sqlStr.append(" LOG_ID,	ATTACH_NO, REPORT_ID, REPORT_TYPE, PATNO, PATFNAME, PATGNAME, PATCNAME, PATSEX, EMAIL, ");
		sqlStr.append(" REPORT_DATE, SOURCE_PATH, ATTACH_FNAME, ATTACH_PW, RECEIPIENT_TYPE, DOCCODE, DOCFNAME, DOCGNAME, REGID ) ");
		sqlStr.append(" VALUES( ?, 1, ?, ?, ?, ?, ?, ?, ?, ?, TO_DATE(?,'YYYYMMDDHH24MISS'), ?, ?, ?, ?, ?, ?, ?, ?) ");
		
		if (!UtilDBWeb.updateQueueCIS(sqlStr.toString(), new String[] {logId, rptId, rptType, 
			patno, patfname, patgname, patcname, patsex,
			email, rptDate, srcPath, fname, password, 
			rcpType, doccode, docfname, docgname, regid })) {
			
			return null;
		}
		
		return logId;
	}
	
//20230516 add attachment in report email log	
	public static boolean attachDMSEmailLog (String logId, String rptId, String rptType, 
			String rptDate, String srcPath, String fname, String password) {
		
		String patno = null;
		String patfname = null;
		String patgname = null;
		String patcname = null;
		String patsex = null;
		String email = null;
		String rcpType = null;
		String doccode = null;
		String docfname = null;
		String docgname = null;
		String regid = null;
		
		StringBuffer sqlStr = new StringBuffer();
		
		sqlStr.append("SELECT PATNO, PATFNAME, PATGNAME, PATCNAME, PATSEX, EMAIL, ");
		sqlStr.append(" RECEIPIENT_TYPE, DOCCODE, DOCFNAME, DOCGNAME, REGID FROM DMS_EMAIL_LOG ");
		sqlStr.append(" WHERE LOG_ID = ? AND ATTACH_NO = 1 ");
		
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[] {logId});
		ReportableListObject row = null;

		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			patno = row.getValue(0);
			patfname = row.getValue(1);
			patgname = row.getValue(2);
			patcname = row.getValue(3);	
			patsex = row.getValue(4);				
			email = row.getValue(5);	
			rcpType = row.getValue(6);	
			doccode = row.getValue(7);
			docfname = row.getValue(8);
			docgname = row.getValue(9);
			regid = row.getValue(10);
		}
		
		return attachDMSEmailLog (rcpType, logId, rptId, rptType, 
				patno, patfname, patgname, patcname, patsex, 
				doccode, docfname, docgname, regid,
				email, rptDate, srcPath, fname, password);			
	}	
	
//20230516 add attachment in report email log	
	public static boolean attachDMSEmailLog (String rcpType, String logId, String rptId, String rptType, 
			String patno, String patfname, String patgname, String patcname, String patsex, 
			String doccode, String docfname, String docgname, String regid, 
			String email, String rptDate, String srcPath, String fname, String password) {
		
		StringBuffer sqlStr = new StringBuffer();		
		String attachNo = null;

		sqlStr.append("SELECT max(ATTACH_NO) + 1 FROM DMS_EMAIL_LOG ");
		sqlStr.append(" WHERE LOG_ID = ?");

		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[] {logId});
		ReportableListObject row = null;

		if (record.size() > 0) {
			row = (ReportableListObject) record.get(0);
			attachNo = row.getValue(0);
		}

		sqlStr = new StringBuffer();	
		sqlStr.append("INSERT INTO DMS_EMAIL_LOG( ");
		sqlStr.append(" LOG_ID,	ATTACH_NO, REPORT_ID, REPORT_TYPE, ");
		sqlStr.append(" PATNO, PATFNAME, PATGNAME, PATCNAME, PATSEX, DOCCODE, DOCFNAME, DOCGNAME, REGID, ");		
		sqlStr.append(" EMAIL, REPORT_DATE, SOURCE_PATH, ATTACH_FNAME, ATTACH_PW, RECEIPIENT_TYPE) ");
		sqlStr.append(" VALUES( ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, TO_DATE(?,'YYYYMMDDHH24MISS'), ?, ?, ?, ?) ");
		
		return UtilDBWeb.updateQueueCIS(sqlStr.toString(), new String[] {logId, attachNo, rptId, rptType,
				patno, patfname, patgname, patcname, patsex, doccode, docfname, docgname, regid, 
				email, rptDate, srcPath, fname, password, rcpType});			
	}
	
//20230516 update report email log
	public static boolean updateDMSEmailLog(String logId, String message, boolean success) {		
		return updateDMSEmailLog(logId, message, success, null, "OUTPAT");
	}		
	
//20230516 update report email log
	public static boolean updateDMSEmailLog(String logId, String message, boolean success, UserBean userbean, String actType) {
				
		StringBuffer sqlStr = new StringBuffer();
				
		sqlStr.append("SELECT REPORT_ID, REPORT_TYPE FROM DMS_EMAIL_LOG ");
		sqlStr.append(" WHERE LOG_ID = ?");

		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[] {logId});
		ReportableListObject row = null;
		
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			String rptId = row.getValue(0);
			String rptType =  row.getValue(1);
			
			insertEmailLog(userbean, rptId,	actType, rptType, success, message);
		}
		
		sqlStr = new StringBuffer();
		
		sqlStr.append("UPDATE DMS_EMAIL_LOG ");
		sqlStr.append(" SET SENT_DATE = SYSDATE, ");		
		if (success)
			sqlStr.append(" SUCCESS = 1, ");
		else
			sqlStr.append(" SUCCESS = 0, ");			
		sqlStr.append(" RETURN_MESSAGE = ? ");
		sqlStr.append(" WHERE LOG_ID = ?");
		
		return UtilDBWeb.updateQueueCIS(sqlStr.toString(), new String[] {message, logId});
	}			
//	
	
	public static boolean isValidEmailAddress(String email) {
	       boolean result = true;

	       if (email != null) {
		       try {
		          InternetAddress emailAddr = new InternetAddress(email);
		          emailAddr.validate();
		       } catch (AddressException ex) {
		          result = false;
		       }
	       } else {
	    	   result = false;
	       }
	       return result;
	}

	private static String[] getIDPwd(String emailFrom) {
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr_getEmailIDPwd,
				new String[]{ConstantsServerSide.SITE_CODE, emailFrom});
		if (record.size() == 1) {
			ReportableListObject recordRow = (ReportableListObject) record.get(0);
			return new String[] { recordRow.getValue(0), recordRow.getValue(1) };
		} else {
			return null;
		}
	}
	
	public static String getEmailById(String emailId) {
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr_getEmailById,
				new String[]{ConstantsServerSide.SITE_CODE, emailId});
		String ret = null;
		if (!record.isEmpty()) {
			ReportableListObject recordRow = (ReportableListObject) record.get(0);
			ret = recordRow.getFields0();
		}
		return ret;
	}

	public static String[] splitEmailToArray(String emailTo) {
		Vector<String> emailListTo = new Vector<String>();
		String[] emailListToArray = null;
		String emailToOrg = null;

	    emailToOrg=emailTo;

	    int j=0;
	    for (int i = 0 ;  i < emailToOrg.length(); i ++) {
	    	if (emailTo.indexOf(";")==i-j) {
	    		emailListTo.add(emailTo.substring(0, emailTo.indexOf(";")).trim());
	    		emailTo=emailTo.substring(emailTo.indexOf(";")+1, emailTo.length()).trim();
	    		j=i;
	    	}
	    }

	    if (emailTo.length()>0){
	    	emailListTo.add(emailTo.substring(0, emailTo.length()).trim());
	    	emailListToArray = (String[]) emailListTo.toArray(new String[emailListTo.size()]);
	    }

	    return emailListToArray;
	}

	private static Authenticator getEmailAuthenticator(final String defaultEmailID, final String defaultEmailEncryptedPwd) {
		return new Authenticator() {
			protected PasswordAuthentication getPasswordAuthentication() {
				return new PasswordAuthentication(defaultEmailID, PasswordUtil.cisDecryption(defaultEmailEncryptedPwd));
			}
		};
	}

	static {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT CO_EMAIL_ID, CO_EMAIL_PWD ");
		sqlStr.append("FROM   CO_EMAIL_IDPWD ");
		sqlStr.append("WHERE  CO_SITE_CODE = ? ");
		sqlStr.append("AND    CO_EMAIL = ? ");
		sqlStr.append("AND    CO_ENABLED = 1 ");
		sqlStr_getEmailIDPwd = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT CO_EMAIL ");
		sqlStr.append("FROM   CO_EMAIL_IDPWD ");
		sqlStr.append("WHERE  CO_SITE_CODE = ? ");
		sqlStr.append("AND    CO_EMAIL_ID = ? ");
		sqlStr.append("AND    CO_ENABLED = 1 ");
		sqlStr_getEmailById = sqlStr.toString();
	}
	
}