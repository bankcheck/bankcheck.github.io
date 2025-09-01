package com.hkah.web.schedule;

import java.util.ArrayList;
import java.util.Vector;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.config.MessageResources;
import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;

public class NotifySendAlertMalInsuExpJob implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		StringBuffer message = new StringBuffer();
		StringBuffer sqlStr = new StringBuffer();

		String doccode = null;
		String docfname = null;
		String docgname = null;
//		String MPSCDATE = null;
		String docemail = null;
		String SPECIALTY = null;
		String DOCTDATE = null;
		String getDocList_sqlStr = null;
		ArrayList<ReportableListObject> docList_ArrayList = null;
		ReportableListObject reportableListObject = null;
		Vector<String> emailTo = null;
		String[] emailListToArray = null;
		String[] mailToCcArray = new String[1];
		String vpmaEmail = null;
		String serverSiteCode = ConstantsServerSide.SITE_CODE;

		if ("hkah".equals(serverSiteCode)) {
			vpmaEmail = "medicalaffairs@hkah.org.hk";
		} else if ("twah".equals(serverSiteCode)) {
			vpmaEmail = "carmen.ng@twah.org.hk";
		}

		sqlStr.setLength(0);
		sqlStr.append(" SELECT d.doccode, d.docfname, d.docgname, d.docemail, TO_CHAR(d.MPSCDATE, 'DD/MM/YYYY'), (SELECT s.spcname FROM spec@iweb s WHERE s.spccode = d.spccode), TO_CHAR(D.DOCTDATE,'DD/MM/YYYY') ");
		sqlStr.append(" FROM DOCTOR@IWEB d ");
		sqlStr.append(" WHERE d.MPSCDATE IS NOT NULL ");
		sqlStr.append(" AND TRUNC(SYSDATE + 15, 'DD') = TRUNC(d.MPSCDATE, 'DD') ");
		sqlStr.append(" AND D.DOCSTS = -1 ");
		sqlStr.append(" ORDER BY d.doccode ASC ");
		getDocList_sqlStr = sqlStr.toString();

		// Get doctor information
		docList_ArrayList = UtilDBWeb.getReportableList(getDocList_sqlStr);

		for (int i = 0; i < docList_ArrayList.size(); i++) {
			emailTo = new Vector<String>();
			reportableListObject = (ReportableListObject) docList_ArrayList.get(i);
			doccode = reportableListObject.getFields0();
			docfname = reportableListObject.getFields1();
			docgname = reportableListObject.getFields2();
			docemail = reportableListObject.getFields3();
//			MPSCDATE = reportableListObject.getFields4();
			SPECIALTY = reportableListObject.getFields5();
			DOCTDATE = reportableListObject.getFields6();

			message.setLength(0);
			message.append("<font face=\"Arial\">");
			message.append("Dear Dr ");
			message.append(docfname);
			message.append(" ");
			message.append(docgname);
			message.append("<br>");
			message.append("<br>");
			if ("hkah".equals(serverSiteCode)) {
				message.append("Greetings from Hong Kong Adventist Hospital - Stubbs Road.<br>");
			} else if ("twah".equals(serverSiteCode)) {
				message.append("Greetings from Hong Kong Adventist Hospital - Tsuen Wan.<br>");
			}
			message.append("<br>");
			message.append("Our records show that the valid period of your Medical Professional Indemnity insurance certificate expired in this month..  Please send an copy of the updated certificate to us when received.<br>");
			message.append("<br>");
			message.append("Document(s) can be submitted by either one of the following:<br>");
			if ("hkah".equals(serverSiteCode)) {
				message.append("By Fax: 	2574 6001<br>");
			} else if ("twah".equals(serverSiteCode)) {
				message.append("By Fax: 	2275 6473<br>");
			}
			message.append("By Email: 	");
			message.append(vpmaEmail);
			message.append("<br>");
			message.append("<br>");
			if ("hkah".equals(serverSiteCode)) {
				message.append("Kindly please (if applicable) fill the attached \"Letter of Authorization\" for giving consent to Hong Kong Medical Association (the HKMA) and The Medical Protection Society Limited (MPS) to disclose and transfer to the Hospital your information on Membership Grade and MPS Membership Valid Period.<br>");
				message.append("<br>");
			}
			message.append("For your kind reference, the expiry date of your admission privileges in the area of <b>");
			message.append(SPECIALTY);
			message.append("</b> is on <b>");
			message.append(DOCTDATE);
			message.append("</b>.<br>");
			message.append("<br>");
			message.append("Please be reminded to send in your Medical Professional Indemnity insurance certificate and Annual Practising Certificate yearly.");
			message.append("<br>");
			message.append("We appreciate your cooperation.  The Hospital would like to thank you for your dedication in your specialty and the support.<br>");
			message.append("<br>");
			message.append("Sincerely<br>");
			message.append("Medical Affairs Office<br>");
			if ("hkah".equals(serverSiteCode)) {
				message.append("Hong Kong Adventist Hospital – Stubbs Road<br>");
				message.append("<br>");
				message.append("Enquiry: 2835 0581<br>");
			} else if ("twah".equals(serverSiteCode)) {
				message.append("Hong Kong Adventist Hospital - Tsuen Wan<br>");
				message.append("<br>");
				message.append("Enquiry: 2275 6711<br>");
			}
			message.append("</font>");

			message.append("<br>");
			message.append(MessageResources.getMessageEnglish("prompt.hkahwebsite"));
//			message.append("<br><table border='0'><tr><td align=\"center\" style=\"color:#AA0066\"><font face=\"Arial\" style=\"font-size: 10pt;\" size=\"2\"><b>");
//			message.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a019.both"));
//			message.append("</b></font></td></tr><tr><td align=\"center\" style=\"color:#AA0066\"><font face=\"Arial\" style=\"font-size: 10pt;\" size=\"1\">");
//			message.append("<span lang=ZH-TW style=\"font-size:10.5pt;font-family:\"新細明體\",\"serif';color:#CC0099\">延續基督的醫治大能</span>");
//			message.append("</font></td></tr><tr><td align=\"left\" align=\"left\" style=\"color:#0009AB\"><font face=\"Arial\" style=\"font-size: 8pt;\" size=\"1\"><u>");
//			message.append("DISCLAIMER:");
//			message.append("</u></font></td></tr><tr><td align=\"left\" style=\"color:#0009AB\"><font face=\"Arial\" style=\"font-size: 10pt;\" size=\"1\">");
//			message.append(MessageResources.getMessageEnglish("prompt.sendEmail.content.a018.both"));
//			message.append("</font></td></tr>");
//			message.append("</table>");

			if (docemail != null && docemail.length() > 0) {
				if (docemail.indexOf(";") > 0) {
					emailListToArray = UtilMail.splitEmailToArray(docemail);
				} else {
					emailTo.add(docemail);
					emailListToArray = (String[]) emailTo.toArray(new String[emailTo.size()]);
				}
				mailToCcArray[0] = vpmaEmail;
			} else {
				emailTo.add(vpmaEmail);
				emailListToArray = (String[]) emailTo.toArray(new String[emailTo.size()]);
			}

			// Send mail
			UtilMail.sendMail(
					ConstantsServerSide.MAIL_ALERT,
					emailListToArray,
					mailToCcArray,
					null,
					"Updated Medical Professional Indemnity Insurance Certificate (Dr. " + docfname + " " + docgname + " - " + doccode + ")",
					message.toString());

			// reset values
			emailListToArray = null;
			emailTo = null;
		}
	}
}