package com.hkah.util.mail;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
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

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.ehr.common.FactoryBase;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.PasswordUtil;
import com.hkah.util.db.ConnUtil;
import com.hkah.web.common.ReportableListObject;

/**
 * Modified access DB method
 * 
 * @author ricky_leung
 *
 */
public class UtilMail2 implements ConstantsVariable {
	private static Logger logger = Logger.getLogger(UtilMail2.class);
	private static String domain_email_suffix = null;
	private static final String TRUE = "true";
	private static String sqlStr_getMailAlertList = null;
	private static String sqlStr_getEmailIDPwd = null;
	
	static {
		StringBuffer sqlStr = new StringBuffer();

		sqlStr.append("SELECT CO_EMAIL_ID, CO_EMAIL_PWD ");
		sqlStr.append("FROM   CO_EMAIL_IDPWD@PORTAL ");
		sqlStr.append("WHERE  CO_SITE_CODE = ? ");
		sqlStr.append("AND    CO_EMAIL = ? ");
		sqlStr.append("AND    CO_ENABLED = 1 ");
		sqlStr_getEmailIDPwd = sqlStr.toString();
		
		sqlStr.setLength(0);
		sqlStr.append("SELECT CO_ACTION, CO_EMAIL ");
		sqlStr.append("FROM   CO_EMAIL_ALERT@PORTAL ");
		sqlStr.append("WHERE  CO_SITE_CODE = ? ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_ENABLED = 1 ");
		sqlStr_getMailAlertList = sqlStr.toString();
	}

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
				ConstantsServerSide.MAIL_HOST, emailFrom, emailTo, emailCC, emailBCC,
				replyTo, newSubject, message, true, true,
				file, filename, skipBccAdmin, emailFromName, priorityValue);

		// not support external email yet
		/*
		// external email
		boolean rv2 = sendMailHelper(
				ConstantsServerSide.MAIL_HOST, emailFrom, emailTo, emailCC, emailBCC,
				replyTo, subject, message, true, false,
				file, filename, skipBccAdmin, emailFromName, priorityValue);
		*/
		
		// twah email
		boolean rv3 = sendMailHelper(
				FactoryBase.getInstance().getSysparamValue("EHRMTWHOST"), 
				FactoryBase.getInstance().getSysparamValue("EHRMTWAALE"),
				emailTo, emailCC, emailBCC,
				replyTo, subject, message, true, true,
				file, filename, true, emailFromName, priorityValue);
		
		//return rv1 || rv2 || rv3;
		return rv1 || rv3;
	}

	private static boolean sendMailHelper(String host, String emailFrom,
									String emailTo[], String emailCC[],
									String emailBCC[], String replyTo[],
									String subject, String message,
									boolean specialHandleEmail, boolean isDomainOnly,
									File file, String filename, boolean skipBccAdmin,
									String emailFromName,
									int priorityValue) {
		// temp for twah
		boolean isTwahHost = false;
		if (host != null && (host.contains("it-mx") || host.startsWith("192.168."))) {
			isTwahHost = true;
		}
		
		/*
		logger.debug("ConstantsServerSide.DEBUG="+ConstantsServerSide.DEBUG);
		logger.debug("ConstantsServerSide.SITE_CODE="+ConstantsServerSide.SITE_CODE);
		logger.debug("ConstantsServerSide.SITE_CODE="+ConstantsServerSide.MAIL_ALERT);
		logger.debug("ConstantsServerSide.SITE_CODE="+ConstantsServerSide.MAIL_ADMIN);
		logger.debug("isTwahHost="+isTwahHost);
		logger.debug("specialHandleEmail="+specialHandleEmail);
		logger.debug("isDomainOnly="+isDomainOnly);
		logger.debug("specialHandleEmail="+specialHandleEmail);
		logger.debug("skipBccAdmin="+skipBccAdmin);
		*/
		
		// Get system properties
		Properties props = System.getProperties();

		// Setup mail server
		if (isTwahHost) {
			props.put("mail.transport.protocol",FactoryBase.getInstance().getSysparamValue("EHRMTWPROT"));
			props.put("mail.smtp.host", host);
			props.put("mail.smtp.port", FactoryBase.getInstance().getSysparamValue("EHRMTWPORT"));
			props.put("mail.smtp.auth", FactoryBase.getInstance().getSysparamValue("EHRMTWAUTH"));
			props.put("mail.smtp.connectiontimeout", ConstantsServerSide.MAIL_SMTP_CONNECTIONTIMEOUT);
			props.put("mail.smtp.timeout", ConstantsServerSide.MAIL_SMTP_TIMEOUT);
		} else {
			props.put("mail.transport.protocol","smtp");
			props.put("mail.smtp.host", host);
			props.put("mail.smtp.port", ConstantsServerSide.MAIL_SMTP_PORT);
			props.put("mail.smtp.auth", (specialHandleEmail && !isDomainOnly) ? TRUE : ConstantsServerSide.MAIL_SMTP_AUTH);
			props.put("mail.smtp.connectiontimeout", ConstantsServerSide.MAIL_SMTP_CONNECTIONTIMEOUT);
			props.put("mail.smtp.timeout", ConstantsServerSide.MAIL_SMTP_TIMEOUT);
		}

		String[] email_IDPwd = getIDPwd(emailFrom);
		String emailID = null;
		String emailEncryptedPwd = null;
		String emailDefault = null;

		if (email_IDPwd != null && email_IDPwd.length == 2) {
			emailID = email_IDPwd[0];
			emailEncryptedPwd = email_IDPwd[1];
			emailDefault = emailFrom;
		} else {
			if (isTwahHost) {
				emailID = FactoryBase.getInstance().getSysparamValue("EHRMTWUSER");
				emailEncryptedPwd = FactoryBase.getInstance().getSysparamValue("EHRMTWPW");
				emailDefault = FactoryBase.getInstance().getSysparamValue("EHRMTWAALE");
			} else {
				emailID = ConstantsServerSide.MAIL_SMTP_USERNAME;
				emailEncryptedPwd = ConstantsServerSide.MAIL_SMTP_PASSWORD;
				emailDefault = ConstantsServerSide.MAIL_ALERT;
			}
		}
		
		/*
		logger.debug("emailID="+emailID);
		logger.debug("emailEncryptedPwd="+emailEncryptedPwd);
		logger.debug("emailDefault="+emailDefault);
		 */
		
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
					if (isTwahHost) {
						if (isDomainEmailTwah(emailTo[i])) {
							msg.addRecipient(Message.RecipientType.TO, new InternetAddress(emailTo[i]));
							
							//logger.debug("add TO 1:"+emailTo[i]);
							count++;
						}
					} else {
						isDomainEmailFlag = isDomainEmail(emailTo[i]);
	
						if (!specialHandleEmail || (isDomainOnly && isDomainEmailFlag) || (!isDomainOnly && !isDomainEmailFlag)) {
							if (ConstantsServerSide.DEBUG) {
								sb.append("emailTo[" + i + "][<b>" + emailTo[i] + "</b>]<br/>");
							} else {
								msg.addRecipient(Message.RecipientType.TO, new InternetAddress(emailTo[i]));
								
								//logger.debug("add TO 2:"+emailTo[i]);
								count++;
							}
						}
					}
				}
			}
			if (emailCC != null) {
				for (int i = 0; i < emailCC.length; i++) {
					if (isTwahHost) {
						if (isDomainEmailTwah(emailCC[i])) {
							msg.addRecipient(Message.RecipientType.CC, new InternetAddress(emailCC[i]));
							
							//logger.debug("add CC 1:"+emailCC[i]);
							count++;
						}
					} else {
						isDomainEmailFlag = isDomainEmail(emailCC[i]);
	
						if (!specialHandleEmail || (isDomainOnly && isDomainEmailFlag) || (!isDomainOnly && !isDomainEmailFlag)) {
							if (ConstantsServerSide.DEBUG) {
								sb.append("emailCC[" + i + "][<b>" + emailCC[i] + "</b>]<br/>");
							} else {
								msg.addRecipient(Message.RecipientType.CC, new InternetAddress(emailCC[i]));
								
								//logger.debug("add CC 2:"+emailCC[i]);
								count++;
							}
						}
					}
				}
			}
			if (emailBCC != null) {
				for (int i = 0; i < emailBCC.length; i++) {
					if (isTwahHost) {
						if (isDomainEmailTwah(emailBCC[i])) {
							msg.addRecipient(Message.RecipientType.BCC, new InternetAddress(emailBCC[i]));
							
							//logger.debug("add BCC 1:"+emailBCC[i]);
							count++;
						}
					} else {
						isDomainEmailFlag = isDomainEmail(emailBCC[i]);
	
						if (!specialHandleEmail || (isDomainOnly && isDomainEmailFlag) || (!isDomainOnly && !isDomainEmailFlag)) {
							if (ConstantsServerSide.DEBUG) {
								sb.append("emailBCC[" + i + "][<b>" + emailBCC[i] + "</b>]<br/>");
							} else {
								msg.addRecipient(Message.RecipientType.BCC, new InternetAddress(emailBCC[i]));
								
								//logger.debug("add BCC 2:"+emailBCC[i]);
								count++;
							}
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
				if(file != null) {
					mbp1.setContent(message, "text/html;charset=UTF-8");

					FileDataSource fds = new FileDataSource(file);
					mbp2.setDataHandler(new DataHandler(fds));
					mbp2.setFileName(filename);

					mp.addBodyPart(mbp1);
					mp.addBodyPart(mbp2);

					msg.setContent(mp, "text/html;charset=UTF-8");
				} else {
					msg.setContent(message, "text/html;charset=UTF-8");
				}

				// Send message
				logger.debug(DateTimeUtil.getCurrentDateTimeStandard()
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
			logger.error("Error send mail: " + e.getMessage());
		}
		return false;
	}

	private static boolean isDomainEmail(String email) {
		return email != null && email.toLowerCase().indexOf(getDomainEmailSuffix()) > 0;
	}
	
	private static boolean isDomainEmailTwah(String email) {
		return email != null && email.toLowerCase().indexOf("twah.org.hk") > 0;
	}

	private static String getDomainEmailSuffix() {
		if (domain_email_suffix == null) {
			//domain_email_suffix = ("@" + ConstantsServerSide.SITE_CODE + ".org.hk").toLowerCase();
			domain_email_suffix = ("@hkah.org.hk").toLowerCase();
		}
		return domain_email_suffix;
	}

	public static int insertEmailLog(String loginID, String keyId,
										String actType, String mailType,
										boolean success, String error) {
        Connection conn = null;
        PreparedStatement ps = null;
        String sql;
        int result = 0;
       
		try {
			sql = "INSERT INTO EMAIL_LOG@PORTAL"
					+ "(KEY_ID, ACT_TYPE, MAIL_TYPE, SEND_TIME, SENDER, SUCCESS, ERROR_MSG) "
					+ "VALUES(?, ?, ?, SYSDATE, ?, ?, ?)";
			conn = ConnUtil.getDataSourceCIS().getConnection();
	        ps = conn.prepareStatement(sql);
        	ps.setString(1, keyId);
        	ps.setString(2, actType);
        	ps.setString(3, mailType);
        	ps.setString(4, loginID);
        	ps.setString(5, success?"1":"0");
        	ps.setString(6, error);
        
        	result = ps.executeUpdate();
			ps.clearParameters();
        } catch (Exception e) {
            logger.error("insertEmailLog error: " + e.getMessage());
            e.printStackTrace();
        } finally {
        	try {
        		if (ps != null)
        			ps.close();
        		
        		ConnUtil.closeConnection(conn);
        	} catch(Exception e) {
                logger.error("insertEmailLog cannot close connection");
                e.printStackTrace();
        	}
        }
		return result;
	}

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
		PreparedStatement ps = null;
		ResultSet rs = null;
		Connection conn = null;
		String[] result = null;
		
		try {
			conn = ConnUtil.getDataSourceCIS().getConnection();
			ps = conn.prepareStatement(sqlStr_getEmailIDPwd);
			ps.setString(1, ConstantsServerSide.SITE_CODE);
			ps.setString(2, emailFrom);
			rs = ps.executeQuery();
			
			if (rs.next()) {
				result = new String[]{rs.getString(1), rs.getString(2)};
			}
		} catch (Exception e) {
		    logger.error("getIDPwd Error: " + e.getMessage());
		    e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				
				if (ps != null)
					ps.close();
				
				ConnUtil.closeConnection(conn);
			} catch(Exception e) {
		        logger.error("getIDPwd Cannot close connection");
		        e.printStackTrace();
			}
		}	
		return result;
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
	    
	    if(emailTo.length()>0){
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
	
	//******** Data access *********//
	public static List<ReportableListObject> getMailAlertList(String moduleCode) {
		PreparedStatement ps = null;
		ResultSet rs = null;
		Connection conn = null;
		List<ReportableListObject> result = new ArrayList<ReportableListObject>();
		int colCount = 2;
		
		try {
			conn = ConnUtil.getDataSourceCIS().getConnection();
			ps = conn.prepareStatement(sqlStr_getMailAlertList);
			ps.setString(1, ConstantsServerSide.SITE_CODE);
			ps.setString(2, moduleCode);
			rs = ps.executeQuery();
			
			while (rs.next()) {
				ReportableListObject row = new ReportableListObject(colCount);
				row.setValue(0, rs.getString(1));
				row.setValue(1, rs.getString(2));
				result.add(row);
			}
		} catch (Exception e) {
		    logger.error("getMailAlertList Error: " + e.getMessage());
		    e.printStackTrace();
		} finally {
			try {
				if (rs != null)
					rs.close();
				
				if (ps != null)
					ps.close();
				
				ConnUtil.closeConnection(conn);
			} catch(Exception e) {
		        logger.error("getMailAlertList Cannot close connection");
		        e.printStackTrace();
			}
		}	
		return result;
	}

	public static boolean sendEmailAlert(String moduleCode, String topic, String comment) {
		return sendEmailAlert(moduleCode, topic, comment, null, null);
	}

	public static boolean sendEmailAlert(String moduleCode, String topic, String comment,
								File file, String filename) {

		List<ReportableListObject> record = getMailAlertList(moduleCode);
		if (record.size() > 0) {
			Vector<String> emailListFrom = new Vector<String>();
			Vector<String> emailListTo = new Vector<String>();
			Vector<String> emailListCC = new Vector<String>();
			Vector<String> emailListBCC = new Vector<String>();
			ReportableListObject row = null;
			String action = null;
			String email = null;

			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				action = row.getValue(0);
				email = row.getValue(1);
				if ("from".equals(action)) {
					emailListFrom.add(email);
				} else if ("to".equals(action)) {
					emailListTo.add(email);
				} else if ("cc".equals(action)) {
					emailListCC.add(email);
				} else if ("bcc".equals(action)) {
					emailListBCC.add(email);
				}
			}

			// default from email
			if (emailListFrom.size() == 0) {
				emailListFrom.add(ConstantsServerSide.MAIL_ALERT);
			}

			if (emailListTo.size() > 0 || emailListCC.size() > 0 || emailListBCC.size() > 0) {
				// send email for alert
				if(file != null) {
					return sendMail(
							((String[]) emailListFrom.toArray(new String[emailListFrom.size()]))[0],
							(String[]) emailListTo.toArray(new String[emailListTo.size()]),
							(String[]) emailListCC.toArray(new String[emailListCC.size()]),
							(String[]) emailListBCC.toArray(new String[emailListBCC.size()]),
							topic,
							comment, file, filename, false);
				} else {
					return sendMail(
							((String[]) emailListFrom.toArray(new String[emailListFrom.size()]))[0],
							(String[]) emailListTo.toArray(new String[emailListTo.size()]),
							(String[]) emailListCC.toArray(new String[emailListCC.size()]),
							(String[]) emailListBCC.toArray(new String[emailListBCC.size()]),
							topic,
							comment);
				}
			}
		}
		return false;
	}
}