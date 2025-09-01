/*
 * Created on October 12, 2011
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.db;

import java.io.File;
import java.util.ArrayList;
import java.util.Vector;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class EmailAlertDB {
	private static String sqlStr_getList = null;

	private static ArrayList<ReportableListObject> getList(String moduleCode) {
		return UtilDBWeb.getReportableList(sqlStr_getList, new String[] { ConstantsServerSide.SITE_CODE, moduleCode});
	}

	public static boolean sendEmail(String moduleCode, String topic, String comment) {
		return sendEmailAlert(moduleCode, topic, comment, new String[]{}, null, null);
	}

	public static boolean sendEmail(String moduleCode, String topic, String comment, String emailTo) {
		return sendEmailAlert(moduleCode, topic, comment, emailTo, null, null);
	}
	
	public static boolean sendEmail(String moduleCode, String topic, String comment, String[] emailTo) {
		return sendEmailAlert(moduleCode, topic, comment, emailTo, null, null);
	}

	public static boolean sendEmail(String moduleCode, String topic, String comment,
							File file, String filename) {
		return sendEmailAlert(moduleCode, topic, comment, new String[]{}, file, filename);
	}
	
	private static boolean sendEmailAlert(String moduleCode, String topic, String comment, String emailTo,
			File file, String filename) {
		return sendEmailAlert(moduleCode, topic, comment, new String[]{emailTo}, file, filename);
	}

	private static boolean sendEmailAlert(String moduleCode, String topic, String comment, String[] emailTo,
								File file, String filename) {

		ArrayList<ReportableListObject> record = getList(moduleCode);
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
			
			if (emailTo != null) {
				for (int i = 0; i < emailTo.length; i++) {
					if (emailTo[i] != null && emailTo[i].length() > 0) {
						emailListTo.add(emailTo[i]);
					}
				}
			}

			if (emailListTo.size() > 0 || emailListCC.size() > 0 || emailListBCC.size() > 0) {
				// send email for alert
				if(file != null) {
					return UtilMail.sendMail(
							((String[]) emailListFrom.toArray(new String[emailListFrom.size()]))[0],
							(String[]) emailListTo.toArray(new String[emailListTo.size()]),
							(String[]) emailListCC.toArray(new String[emailListCC.size()]),
							(String[]) emailListBCC.toArray(new String[emailListBCC.size()]),
							topic,
							comment, file, filename, false);
				} else {
					return UtilMail.sendMail(
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
	
	public static boolean sendSysAlertLogEmail(String className, String remark) {
		String topic = "Scheduled Job completed: " + className;
		String comment = "Scheduled Job completed: " + className;
		
		return sendEmail("sys.alert.log", topic, comment);
	}

	// ---------------------------------------------------------------------
	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT CO_ACTION, CO_EMAIL ");
		sqlStr.append("FROM   CO_EMAIL_ALERT ");
		sqlStr.append("WHERE  CO_SITE_CODE = ? ");
		sqlStr.append("AND    CO_MODULE_CODE = ? ");
		sqlStr.append("AND    CO_ENABLED = 1 ");
		sqlStr_getList = sqlStr.toString();
	}
}