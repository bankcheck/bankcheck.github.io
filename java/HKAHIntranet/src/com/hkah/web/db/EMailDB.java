package com.hkah.web.db;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Vector;

import com.hkah.config.MessageResources;
import com.hkah.constant.ConstantsErrorMessage;
import com.hkah.constant.ConstantsServerSide;
import com.hkah.fop.CoverLetterReapplication;
import com.hkah.fop.InactiveNoticeLetter;
import com.hkah.util.TextUtil;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.common.UserBean;

public class EMailDB {
	private static String serverSiteCode = ConstantsServerSide.SITE_CODE;	

	public static boolean sendEmail(String receiverEMail, String subject, String content) {
		StringBuffer commentStr = null;

		boolean sendMailSuccess = false;
		commentStr = new StringBuffer();	
		commentStr.append(content);

		sendMailSuccess = UtilMail.sendMail(
				ConstantsServerSide.MAIL_ALERT, new String[] { receiverEMail }, null, new String[] { ConstantsServerSide.MAIL_ADMIN }, null,
				subject + ("hkah".equals(serverSiteCode)?"(From HKAH-SR)":"(From HKAH-TW)"),
				commentStr.toString(), "hkah".equals(serverSiteCode)?"Hong Kong Adventist Hospital - Stubbs Road":"Hong Kong Adventist Hospital - Tsuen Wan");
			
		return sendMailSuccess;
	}
}