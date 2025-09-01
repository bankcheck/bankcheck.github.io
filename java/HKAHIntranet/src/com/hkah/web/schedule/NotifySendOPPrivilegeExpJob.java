package com.hkah.web.schedule;

import java.util.ArrayList;
import java.util.Vector;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;

public class NotifySendOPPrivilegeExpJob implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		StringBuffer message = new StringBuffer();
		StringBuffer sqlStr = new StringBuffer();

		String doccode = null;
		String docfname = null;
		String docgname = null;
		String docspec =  null;
		String doctype =  null;
		String ipshare =  null;
		String opshare =  null;
		String daycaseshare =  null;
		String oppexpdate =  null;
		String getDocList_sqlStr = null;
		ArrayList<ReportableListObject> docList_ArrayList = null;
		ReportableListObject reportableListObject = null;
		Vector emailTo = new Vector();
		String[] emailListToArray = null;
		String[] mailToCcArray = new String[1];
		String email1 = "medicalaffairs@hkah.org.hk";
		String email2 = "daisy.sin@hkah.org.hk";

		sqlStr.setLength(0);
		sqlStr.append(" SELECT D.DOCCODE, D.DOCGNAME, D.DOCFNAME, S.SPCNAME, DECODE(DOCTYPE,'M','COURTESY','C','CONSULTANT','I','INHOUSE') AS DOCTYPE, ");
		sqlStr.append(" DOCPCT_I, DOCPCT_O, DOCPCT_D, TO_CHAR(OPPEDATE,'DD/MM/YYYY') ");
		sqlStr.append(" FROM DOCTOR@iweb D ");
		sqlStr.append(" INNER JOIN SPEC@iweb S ON D.SPCCODE = S.SPCCODE ");
		sqlStr.append(" WHERE TRUNC(D.OPPEDATE) - 120 = TRUNC(SYSDATE) ");
		sqlStr.append(" AND DOCSTS = -1 ");
		getDocList_sqlStr = sqlStr.toString();

		// Get doctor information
		docList_ArrayList = UtilDBWeb.getReportableList(getDocList_sqlStr);

		for (int i = 0; i < docList_ArrayList.size(); i++) {
			emailTo = new Vector();
			reportableListObject = (ReportableListObject) docList_ArrayList.get(i);
			doccode = reportableListObject.getFields0();
			docfname = reportableListObject.getFields1();
			docgname = reportableListObject.getFields2();
			docspec = reportableListObject.getFields3();
			doctype = reportableListObject.getFields4();
			ipshare = reportableListObject.getFields5();
			opshare = reportableListObject.getFields6();
			daycaseshare = reportableListObject.getFields7();
			oppexpdate = reportableListObject.getFields8();

			message.setLength(0);
			message.append("<font face=\"Arial\">");
			message.append("<table>");
			message.append("<tr><td width='45%'><u>Description</u></td><td colspan=3><u>Details</u></td></tr>");
			message.append("<tr><td width='45%'>Doctor Code:</td><td colspan=3>"+doccode+"</td></tr>");
			message.append("<tr><td width='40%'>Doctor Name:</td><td width='20%'>"+docfname+"</td><td width='20%' colspan=2>"+docgname+"</td></tr>");
			message.append("<tr><td width='40%'>Doctor Type:</td><td colspan=3>"+doctype+"</td></tr>");
			message.append("<tr><td width='25%'>Specialty Code:</td><td colspan=3>"+docspec+"</td></tr>");
			message.append("<tr><td width='40%'>Misc Remark:</td><td width='20%'>IP%"+ipshare+"</td>");
			message.append("<td width='20%'>OP%"+opshare+"</td><td width='20%'>DayCase %"+daycaseshare+"</td></tr>");
			message.append("<tr><td width='25%'>Alert:</td><td colspan=3>"+oppexpdate+"</td></tr></table>");
			message.append("<br><br>");
//			message.append("******************************");
//			message.append("Please do not reply to this computer generated email.");
//			message.append("******************************");
//			message.append("</font>");
//			message.append("<br><br>");
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

			emailTo.add(email1);
			emailTo.add(email2);
			emailListToArray = (String[]) emailTo.toArray(new String[emailTo.size()]);
//			System.out.println("[email1]:"+email1+";[email2]:"+email2);

			// Send mail
			UtilMail.sendMail(
					ConstantsServerSide.MAIL_ALERT,
					emailListToArray,
					null,
					null,
					"HATS Alert – OP Privilege Expiry (Contract)",
					message.toString());

			// reset values
			emailListToArray = null;
			emailTo = null;
		}
	}
}