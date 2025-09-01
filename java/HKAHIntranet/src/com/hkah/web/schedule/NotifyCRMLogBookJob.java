package com.hkah.web.schedule;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.CRMClientDB;
import com.hkah.web.db.helper.ClientLogBookEmail;

public class NotifyCRMLogBookJob implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		ArrayList<ClientLogBookEmail> listOfClientsNotFinish = new ArrayList<ClientLogBookEmail>();

		ArrayList allClientRecord = CRMClientDB.getListOfClientsWithIDPWChangedWithGroupID();

		ReportableListObject allClientRow = null;
		String clientID = null;
//		String clientEmail = null;
		String clientName = null;
		String clientUserName = null;
		String logBookLatestDate = null;
		ArrayList logBookRecord = null;
		ReportableListObject logBookRow = null;
		Calendar logBookDate = null;
		String[] date = null;
		String year = null;
		String month = null;
		String day = null;
		Boolean clientNotFinishLogBook = false;
		String noOfWeeks = null;
		ArrayList clientTeamRecord = null;
		boolean clientLogBookFound = false;
		ReportableListObject clientTeamRow = null;
//		String teamLeader = null;
		String teamLeaderEmail = null;
//		String teamManager = null;
		String teamManagerEmail = null;
		String teamName = null;
		String emailTo = null;
		StringBuffer displayMessage = null;
		String title = "Log Book Alert";

		for (int i = 0; i < allClientRecord.size(); i++) {
			allClientRow = (ReportableListObject)allClientRecord.get(i);
			clientID = allClientRow.getValue(0);
//			clientEmail = allClientRow.getValue(1);
			clientName = allClientRow.getValue(2);
			clientUserName = allClientRow.getValue(3);

			logBookRecord = CRMClientDB.getClientLogBookLatestRecord(clientID);
			if (logBookRecord.size() > 0) {
				logBookRow = (ReportableListObject)logBookRecord.get(0);
				logBookLatestDate = logBookRow.getValue(1);
			}

			if (logBookLatestDate != null && logBookLatestDate.length() > 0) {
				logBookDate = Calendar.getInstance();
				date = logBookLatestDate.split(" ");
				year = date[0].split("-")[0];
				month = date[0].split("-")[1];
				day = date[0].split("-")[2];

				logBookDate.set(Integer.parseInt(year), Integer.parseInt(month)-1, Integer.parseInt(day));
				logBookDate.set(Calendar.HOUR_OF_DAY, 0);
				logBookDate.set(Calendar.MINUTE, 0);
				logBookDate.set(Calendar.SECOND, 0);

				clientNotFinishLogBook = false;
				noOfWeeks = "";
				if (haveNotFinishLogBookWithinWeek(4, logBookDate)) {
					clientNotFinishLogBook = true;
					noOfWeeks = "4";
				} else if (haveNotFinishLogBookWithinWeek(3,logBookDate)) {
					clientNotFinishLogBook = true;
					noOfWeeks = "3";
				} else if (haveNotFinishLogBookWithinWeek(2,logBookDate)) {
					clientNotFinishLogBook = true;
					noOfWeeks = "2";
				}

				if (clientNotFinishLogBook) {
					clientTeamRecord = CRMClientDB.getClientTeamInfo(clientID, null);
					if (clientTeamRecord.size() > 0) {
						clientTeamRow = (ReportableListObject)clientTeamRecord.get(0);
//						teamLeader = clientTeamRow.getValue(2);
						teamLeaderEmail = clientTeamRow.getValue(4);
//						teamManager = clientTeamRow.getValue(3);
						teamManagerEmail = clientTeamRow.getValue(5);
						teamName = clientTeamRow.getValue(0);

						emailTo = null;
						if ("4".equals(noOfWeeks)) {
//							emailTo = "nfsit@hotmail.com";
							emailTo = "health.promotion@hkah.org.hk";
						} else if (noOfWeeks.equals("3")) {
							emailTo = teamManagerEmail;
						} else if (noOfWeeks.equals("2")) {
							emailTo = teamLeaderEmail;
						}
						if (emailTo==null && emailTo.length()==0) {
//							emailTo = "nfsit@hotmail.com";
							emailTo = "health.promotion@hkah.org.hk";
						}

						displayMessage.setLength(0);
						displayMessage.append("<hr>");
						displayMessage.append("<table>");
						displayMessage.append("<tr>");
						displayMessage.append("<td style='font-size:18px;text-align:left;background-color:#E0E0E0'>Client Name</td>");
						displayMessage.append("<td style='font-size:18px;background-color:#F7ECEC'>");
						displayMessage.append(clientName);
						displayMessage.append("</td>");
						displayMessage.append("<td style='font-size:18px;text-align:left;background-color:#E0E0E0'>Client User Name</td>");
						displayMessage.append("<td style='font-size:18px;background-color:#F7ECEC'>");
						displayMessage.append(clientUserName);
						displayMessage.append("</td>");
						displayMessage.append("</tr>");
						displayMessage.append("<tr>");
						displayMessage.append("<td style='font-size:18px;text-align:left;background-color:#E0E0E0'>Team Name</td>");
						displayMessage.append("<td style='font-size:18px;background-color:#F7ECEC' colspan='3'>");
						displayMessage.append(teamName);
						displayMessage.append("</td>");
						displayMessage.append("</tr>");
						displayMessage.append("<tr>");
						displayMessage.append("<td style='font-size:18px;text-align:left;background-color:#E0E0E0'>Message</td>");
						displayMessage.append("<td style='font-size:18px;background-color:#F7ECEC' colspan='3'>");
						displayMessage.append("Client have not complete Log Book for "+noOfWeeks+" weeks");
						displayMessage.append("</td>");
						displayMessage.append("</tr>");
						displayMessage.append("</table>");

						clientLogBookFound = false;
						for(ClientLogBookEmail c : listOfClientsNotFinish) {

							if (c.emailTo.equals(emailTo)) {
								c.message = c.message + displayMessage.toString();
								c.title = title;
								clientLogBookFound = true;
								break;
							}
						}
						if (!clientLogBookFound) {
							listOfClientsNotFinish.add(new ClientLogBookEmail(emailTo,displayMessage.toString(), title));
						}
					}
				}
			}
		}

		for (ClientLogBookEmail c : listOfClientsNotFinish) {
			UtilMail.sendMail(ConstantsServerSide.MAIL_ALERT, c.emailTo, c.title, c.message);
		}
	}

	// ======================================================================
	private static Boolean haveNotFinishLogBookWithinWeek(int noOfWeeks,Calendar logBookDate) {
		Boolean haveNotFinishLogBook = false;

		Calendar noOfWeek = Calendar.getInstance();
		noOfWeek.set(Calendar.HOUR_OF_DAY, 23);
		noOfWeek.set(Calendar.MINUTE, 59);
		noOfWeek.set(Calendar.SECOND, 59);
		noOfWeek.add(Calendar.DAY_OF_MONTH,-(7*noOfWeeks));
		noOfWeek.set(Calendar.DAY_OF_WEEK, Calendar.SATURDAY);
		if (logBookDate.before(noOfWeek)) {
			haveNotFinishLogBook = true;
		}

		SimpleDateFormat df = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
//		System.out.println("logBookDate = " + df.format(logBookDate.getTime()) + " Before Date = " + df.format(noOfWeek.getTime()));

		return haveNotFinishLogBook;
	}
}