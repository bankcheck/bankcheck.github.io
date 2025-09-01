package com.hkah.web.schedule;

import java.util.ArrayList;

import org.apache.log4j.Logger;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;

public class NotifyPolicyReminderJob implements Job {

	// ======================================================================
	private static Logger logger = Logger.getLogger(NotifyPolicyReminderJob.class);
	private boolean running = true;
	private static String sqlStr_getSchedule = null;
	private static String sqlStr_getSchedule2 = null;
	private static String sqlStr_getSchedule3 = null;
	private static String sqlStr_getSchedule4= null;
	private static final String WEBMASTER_EMAIL = ConstantsServerSide.MAIL_ALERT;

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr_getSchedule);
		ArrayList<ReportableListObject> record2 = UtilDBWeb.getReportableList(sqlStr_getSchedule2);
		ArrayList<ReportableListObject> record3 = UtilDBWeb.getReportableList(sqlStr_getSchedule3);
		ArrayList<ReportableListObject> record4 = UtilDBWeb.getReportableList(sqlStr_getSchedule4);

		String emailFrom = WEBMASTER_EMAIL;
		//emailFrom = "terrence.leung@hkah.org.hk";
		StringBuffer commentStr = new StringBuffer();

		//Calendar cal = Calendar.getInstance();
		//System.out.println(cal.getTime());

		// Default msg content
		StringBuffer msg1 = new StringBuffer();
		StringBuffer msg_hd = new StringBuffer();
		StringBuffer msg_step = new StringBuffer();
		StringBuffer msg_tbl = new StringBuffer();
		StringBuffer msg_tbl_hd = new StringBuffer();
		StringBuffer msg_flowchart = new StringBuffer();
		StringBuffer msg_trailer = new StringBuffer();

		msg_hd.append("<body>");
		msg_hd.append("<br>Dear Policy Owner,</br>");
		msg_hd.append("<br>Please kindly review the following policy:</br>");
		msg_hd.append("</body>");

		msg_tbl_hd.append("<br></br>");
		msg_tbl_hd.append("<table>");
		msg_tbl_hd.append("<tr>");
		msg_tbl_hd.append("<th style='font-size:18px;text-align:left;background-color:#E0E0E0'>Policy No.</th>");
		msg_tbl_hd.append("<th style='font-size:18px;text-align:left;background-color:#E0E0E0'>Policy Name</th>");
		msg_tbl_hd.append("<th style='font-size:18px;text-align:left;background-color:#E0E0E0'>Owner</th>");
		msg_tbl_hd.append("<th style='font-size:18px;text-align:left;background-color:#E0E0E0'>To be Reviewed</th>");
		msg_tbl_hd.append("</tr>");

//		msg_step.append("<br>Steps:</br>");
		if (ConstantsServerSide.isTWAH()) {
			msg_step.append("<body>");
			msg_step.append("1. Soft copy of the policies can be found in <u><a href=\"\\\\it-fs1\\dept\\AH_bulletin\\AH_Doc\\Policy Manual (AH)\\twah\\hospital\\Main, Hospital Policy Master Index.doc\">\\\\it-fs1\\dept\\AH_bulletin\\AH_Doc\\Policy Manual (AH)\\twah\\hospital\\Main, Hospital Policy Master Index.doc</a></u></br>");
			msg_step.append("2. Review and update the policy. Please kindly <b>underline</b> the part of the policy that has changed for ease of reading. ");
			msg_step.append("The old underline should be removed every time on the next revision.</br>");
			msg_step.append("3. You are recommended to adopt the standard template format : <u><a href=\"\\\\it-fs1\\Public\\TW_Intranet\\Policy and Procedure\\Policy Standard Format_20210325.doc\">link</a></u> </br>");
			msg_step.append("<br><img src=\"https://" + ConstantsServerSide.OFFSITE_URL +  "/intranet/images/pi/policy format_twah_2021.jpg\" alt=\"PolicyFormat\"></br>");

			msg_step.append("4. You may use the reference of the following hyperlink:</br>");
			msg_step.append("<br><i>Hong Kong Ordinances: <u><a href=\"http://www.legislation.gov.hk\">www.legislation.gov.hk</a></u></i></br>");
			msg_step.append("<i>DOH's Code of Practices: <u><a href=\"https://www.orphf.gov.hk/files/file/PHF(E)%2011A%20CoP%20PH_Eng.pdf\">https://www.orphf.gov.hk/files/file/PHF(E) 11A CoP PH_Eng.pdf</a></u></i></br>");
			//msg_step.append("<i>ACHS EQuIP 6 (Hong Kong GUIDE): <u><a href=\"\\\\it-fs1\\5\\Public\\Performance Improvement Dept\\ACHS Standard EQuIP 6\\160921-ACHS EQuIP6 HK Guide Book 1-Final.pdf\">Book 1- Clinical Function</a></u></i></br>");
			//msg_step.append("<i> & <u><a href=\"\\\\it-fs1\\5\\Public\\Performance Improvement Dept\\ACHS Standard EQuIP 6\\160922-ACHS EQuIP6 HK Guide Book 2-Final.pdf\">Book 2- Support and Corporate Function</a></u></i></br>");
			msg_step.append("<i><u><a href=\"\\\\it-fs1\\5\\Public\\Performance Improvement Dept\\JCI\\JCI 7th Edition 2020.pdf\">JCI: JCI\\7th Edition 2020 Standard</a></u></i></br>");
			//msg_step.append("<i>Trent: <u><a href=\"http://www.qha-trent.co.uk\">www.qha-trent.co.uk</a></u></i></br>");
			msg_step.append("</body>");

			msg_trailer.append("<body>");
			msg_trailer.append("<br>Please ignore this email if you have done the revision. Note that the new or revised policy will only be uploaded ");
			msg_trailer.append("after the AC has approved the last meeting minutes (ie around 2 weeks after your discussion at AC.)</br>");
			msg_trailer.append("<br>Thank You.</br>");
			msg_trailer.append("</body>");
		} else {
			msg_step.append("<body>");
			msg_step.append("1. Soft copy of the policies can be found in <u><a href=\"\\\\www-server\\policy\\hospital-wide\\INDEX.doc\">//www-server/policy/hospital-wide/INDEX.doc</a></u></br>");
			msg_step.append("2. Review and update the policy. Please kindly <b>underline</b> the part of the policy that has changed for ease of reading. ");
			msg_step.append("The old underline should be removed every time on the next revision.</br>");
			//msg_step.append("3. Risk rate the policy using the attached risk assessment code with the following policy format. </br>");
			//msg_step.append("Please put down extreme high risk, high risk, moderate risk or low risk for risk level.</br>");
			//msg_step.append("<br><img src=\"https://" + ConstantsServerSide.OFFSITE_URL +  "/intranet/images/pi/policy format.jpg\" alt=\"PolicyFormat\"></br>");
			msg_step.append("<br><img src=\"https://" + ConstantsServerSide.OFFSITE_URL +  "/intranet/images/pi/policy format_hkah_2021.png\" alt=\"PolicyFormat\"></br>");
			//msg_step.append("<br><img src=\"https://" + ConstantsServerSide.OFFSITE_URL +  "/intranet/images/pi/Risk Assessment Code 1704.jpg\" width=\"600\" height=\"700\" alt=\"RiskAssessmentCode\"></br>");

			msg_step.append("3. You may use the reference of the following hyperlink:</br>");
			msg_step.append("<br><i>Hong Kong Ordinances: <u><a href=\"http://www.legislation.gov.hk\">www.legislation.gov.hk</a></u></i></br>");
			//msg_step.append("<i>DOH's Code of Practices: <u><a href=\"https://www.orphf.gov.hk/files/file/PHF(E)%2011A%20CoP%20PH_Eng.pdf\">https://www.orphf.gov.hk/files/file/PHF(E) 11A CoP PH_Eng.pdf</a></u></i></br>");
			msg_step.append("<i>DOH's Code of Practices: <u><a href=\"\\\\it-fs1\\5\\Public\\Performance Improvement Dept\\DOH\\Cap 633_CoP_draft_20181227.pdf\">Code of Practice for Private Hospitals</a></u></i></br>");
			//msg_step.append("<i>ACHS EQuIP 6 (Hong Kong GUIDE): <u><a href=\"\\\\it-fs1\\5\\Public\\Performance Improvement Dept\\ACHS Standard EQuIP 6\\160921-ACHS EQuIP6 HK Guide Book 1-Final.pdf\">Book 1- Clinical Function</a></u></i></br>");
			//msg_step.append("<i> & <u><a href=\"\\\\it-fs1\\5\\Public\\Performance Improvement Dept\\ACHS Standard EQuIP 6\\160922-ACHS EQuIP6 HK Guide Book 2-Final.pdf\">Book 2- Support and Corporate Function</a></u></i></br>");
			//msg_step.append("<i><u><a href=\"\\\\it-fs1\\5\\Public\\Performance Improvement Dept\\JCI\\JCI 6th Edition 2017.pdf\">JCI: JCI\\6th Edition 2017 Standard</a></u></i></br>");
			msg_step.append("<i>JCI (7th Edition): <u><a href=\"\\\\it-fs1\\5\\Public\\Performance Improvement Dept\\JCI\\JCI 7th Edition 2020.pdf\">Joint Commission International Accreditation Standards for Hospitals</a></u></i></br>");
			//msg_step.append("<i>Trent: <u><a href=\"http://www.qha-trent.co.uk\">www.qha-trent.co.uk</a></u></i></br>");
			msg_step.append("<br>4. After the revision, please process your revised policy according to the Flow Chart below. ");
			msg_step.append("For more details, you may read Policy GLD-010 Policies and Standard Operating Procedures.</br>");
			msg_step.append("</body>");

			msg_trailer.append("<body>");
			msg_trailer.append("<br>Please ignore this email if you have done the revision. Note that the new or revised policy will only be uploaded ");
			msg_trailer.append("after the AC has approved the last meeting minutes (ie around 2 weeks after your discussion at AC.)</br>");
			msg_trailer.append("<br>Thanks!</br>");
			msg_trailer.append("</body>");

//			msg_flowchart.append("<br><img src=\"..\\images\\pi\\FlowChart.jpg\" width=\"220\" height=\"277\" alt=\"The FLowChart\"></br>");
//			msg_flowchart.append("<br><img src=\"https://mail.hkah.org.hk/intranet/images/pi/FlowChart.jpg\" width=\"600\" height=\"700\" alt=\"The FLowChart Test\"></br>");
			msg_flowchart.append("<br><img src=\"https://" + ConstantsServerSide.OFFSITE_URL +  "/intranet/images/pi/GLD-010 Policy and Procedure  Appendix A 2021.png\" width=\"600\" height=\"750\" alt=\"FLowChart\"></br>");
		}

		/* 1. send the record of review date 90 day after today */
		if (record.size() > 0) {
			msg1.setLength(0);
			msg1.append("<body>");
			msg1.append("<br><b>This is an auto email reminder generated by the PRRP (Policy Revision Reminder Program) ");
			msg1.append("designed for hospital wide policy (First reminder)</b></br>");
			msg1.append("</body>");

			ReportableListObject row = null;
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);	// loop for each PI_POLICY_REMINDER to construct table to be attached.
				msg_tbl.setLength(0);
				msg_tbl.append("<tr>");
				msg_tbl.append("<td style='font-size:18px;text-align:left;background-color:#E0E0E0'>" + row.getFields1() + "</td>");
				msg_tbl.append("<td style='font-size:18px;text-align:left;background-color:#E0E0E0'>" + row.getFields2() + "</td>");
				msg_tbl.append("<td style='font-size:18px;text-align:left;background-color:#E0E0E0'>" + row.getFields3() + "</td>");
				msg_tbl.append("<td style='font-size:18px;text-align:left;background-color:#E0E0E0'>" + row.getFields5() + "</td>");
				msg_tbl.append("</tr>");
				msg_tbl.append("</table>");	// complete the above table frame (in msg_tbl_hd)
				msg_tbl.append("<br></br>");	// complete the above table frame (in msg_tbl_hd)

				// One PI_POLICY_REMINDER record, construct one record in table (with multiple recipients within owner field)
				UtilMail.sendMail(
					emailFrom, row.getFields4().split(";"),
					null, "terrence.leung@hkah.org.hk".split(";"), "(Policy Reminder)", msg1.toString() + msg_hd.toString() + msg_tbl_hd.toString() + msg_tbl.toString() + msg_step.toString() + msg_flowchart.toString() + msg_trailer.toString());
			}
		}

		/* 2. send the record of review date 60 day after today */
		if (record2.size() > 0) {
			msg1.setLength(0);
			msg1.append("<body>");
			msg1.append("<br><b>This is an auto email reminder generated by the PRRP (Policy Revision Reminder Program) ");
			msg1.append("designed for hospital wide policy (Second reminder)</b></br>");
			msg1.append("</body>");

			ReportableListObject row2 = null;
			for (int i = 0; i < record2.size(); i++) {
				row2 = (ReportableListObject) record2.get(i);	// loop for each PI_POLICY_REMINDER to construct table to be attached.
				msg_tbl.setLength(0);
				msg_tbl.append("<tr>");
				msg_tbl.append("<td style='font-size:18px;text-align:left;background-color:#E0E0E0'>" + row2.getFields1() + "</td>");
				msg_tbl.append("<td style='font-size:18px;text-align:left;background-color:#E0E0E0'>" + row2.getFields2() + "</td>");
				msg_tbl.append("<td style='font-size:18px;text-align:left;background-color:#E0E0E0'>" + row2.getFields3() + "</td>");
				msg_tbl.append("<td style='font-size:18px;text-align:left;background-color:#E0E0E0'>" + row2.getFields5() + "</td>");
				msg_tbl.append("</tr>");
				msg_tbl.append("</table>");	// complete the above table frame (in msg_tbl_hd)
				msg_tbl.append("<br></br>");	// complete the above table frame (in msg_tbl_hd)

				// One PI_POLICY_REMINDER record, construct one record in table (with multiple recipients within owner field)
				UtilMail.sendMail(
					emailFrom, row2.getFields4().split(";"),
					null, "terrence.leung@hkah.org.hk".split(";"), "(Policy Reminder)", msg1.toString() + msg_hd.toString() + msg_tbl_hd.toString() + msg_tbl.toString() + msg_step.toString() + msg_flowchart.toString() + msg_trailer.toString());
			}
		}

		/* 3. send the record of review date 30 day after today */
		if (record3.size() > 0) {
			msg1.setLength(0);
			msg1.append("<body>");
			msg1.append("<br><b>This is an auto email reminder generated by the PRRP (Policy Revision Reminder Program) ");
			msg1.append("designed for hospital wide policy (Third reminder)</b></br>");
			msg1.append("</body>");

			ReportableListObject row3 = null;
			for (int i = 0; i < record3.size(); i++) {
				row3 = (ReportableListObject) record3.get(i);	// loop for each PI_POLICY_REMINDER to construct table to be attached.
				msg_tbl.setLength(0);
				msg_tbl.append("<tr>");
				msg_tbl.append("<td style='font-size:18px;text-align:left;background-color:#E0E0E0'>" + row3.getFields1() + "</td>");
				msg_tbl.append("<td style='font-size:18px;text-align:left;background-color:#E0E0E0'>" + row3.getFields2() + "</td>");
				msg_tbl.append("<td style='font-size:18px;text-align:left;background-color:#E0E0E0'>" + row3.getFields3() + "</td>");
				msg_tbl.append("<td style='font-size:18px;text-align:left;background-color:#E0E0E0'>" + row3.getFields5() + "</td>");
				msg_tbl.append("</tr>");
				msg_tbl.append("</table>");	// complete the above table frame (in msg_tbl_hd)
				msg_tbl.append("<br></br>");	// complete the above table frame (in msg_tbl_hd)

				// One PI_POLICY_REMINDER record, construct one record in table (with multiple recipients within owner field)
				UtilMail.sendMail(
					emailFrom, row3.getFields4().split(";"),
					null, "terrence.leung@hkah.org.hk".split(";"), "(Policy Reminder)", msg1.toString() + msg_hd.toString() + msg_tbl_hd.toString() + msg_tbl.toString() + msg_step.toString() + msg_flowchart.toString() + msg_trailer.toString());
			}
		}

		/* 4. send the record of expired review date */
		if (record4.size() > 0) {
			msg1.setLength(0);
			msg1.append("<body>");
			msg1.append("<br><b>This is an auto email reminder generated by the PRRP (Policy Revision Reminder Program) ");
			msg1.append("designed for hospital wide policy</b><b style='color:#FF0000'> (Overdue)</b></br>");
			msg1.append("</body>");

			ReportableListObject row4 = null;
			for (int i = 0; i < record4.size(); i++) {
				row4 = (ReportableListObject) record4.get(i);	// loop for each PI_POLICY_REMINDER to construct table to be attached.
				msg_tbl.setLength(0);
				msg_tbl.append("<tr>");
				msg_tbl.append("<td style='font-size:18px;text-align:left;background-color:#E0E0E0'>" + row4.getFields1() + "</td>");
				msg_tbl.append("<td style='font-size:18px;text-align:left;background-color:#E0E0E0'>" + row4.getFields2() + "</td>");
				msg_tbl.append("<td style='font-size:18px;text-align:left;background-color:#E0E0E0'>" + row4.getFields3() + "</td>");
				msg_tbl.append("<td style='font-size:18px;text-align:left;background-color:#E0E0E0'>" + row4.getFields5() + "</td>");
				msg_tbl.append("</tr>");
				msg_tbl.append("</table>");	// complete the above table frame (in msg_tbl_hd)
				msg_tbl.append("<br></br>");	// complete the above table frame (in msg_tbl_hd)

				// One PI_POLICY_REMINDER record, construct one record in table (with multiple recipients within owner field)
				UtilMail.sendMail(
					emailFrom, row4.getFields4().split(";"),
					null, "terrence.leung@hkah.org.hk".split(";"), "(Policy Reminder)", msg1.toString() + msg_hd.toString() + msg_tbl_hd.toString() + msg_tbl.toString() + msg_step.toString() + msg_flowchart.toString() + msg_trailer.toString());
			}
		}
	}

	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.setLength(0);
		sqlStr.append("SELECT PIPRID, PIPR_NO, PIPR_PNAME, PIPR_OWNER, PIPR_EMAIL, to_char(PIPR_TO_BE_REVIEWED_DATE, 'YYYY-MM-DD'), PIPR_SUGGESTED_REFERENCE ");
		sqlStr.append("FROM   PI_POLICY_REMINDER ");
		sqlStr.append("WHERE  PIPR_ENABLED = '1' ");
		sqlStr.append("AND    (TRUNC(PIPR_TO_BE_REVIEWED_DATE) = TRUNC(SYSDATE + 90)) ");
		sqlStr.append("ORDER BY PIPR_TO_BE_REVIEWED_DATE ");
		sqlStr_getSchedule = sqlStr.toString();		// **** 90 no of day before sending reminder ****
	}


	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.setLength(0);
		sqlStr.append("SELECT PIPRID, PIPR_NO, PIPR_PNAME, PIPR_OWNER, PIPR_EMAIL, to_char(PIPR_TO_BE_REVIEWED_DATE, 'YYYY-MM-DD'), PIPR_SUGGESTED_REFERENCE ");
		sqlStr.append("FROM   PI_POLICY_REMINDER ");
		sqlStr.append("WHERE  PIPR_ENABLED = '1' ");
		sqlStr.append("AND    (TRUNC(PIPR_TO_BE_REVIEWED_DATE) = TRUNC(SYSDATE + 60)) ");
		sqlStr.append("ORDER BY PIPR_TO_BE_REVIEWED_DATE ");
		sqlStr_getSchedule2 = sqlStr.toString();		// **** 60 no of day before sending reminder ****
	}

	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.setLength(0);
		sqlStr.append("SELECT PIPRID, PIPR_NO, PIPR_PNAME, PIPR_OWNER, PIPR_EMAIL, to_char(PIPR_TO_BE_REVIEWED_DATE, 'YYYY-MM-DD'), PIPR_SUGGESTED_REFERENCE ");
		sqlStr.append("FROM   PI_POLICY_REMINDER ");
		sqlStr.append("WHERE  PIPR_ENABLED = '1' ");
		sqlStr.append("AND    (TRUNC(PIPR_TO_BE_REVIEWED_DATE) = TRUNC(SYSDATE + 30)) ");
		sqlStr.append("ORDER BY PIPR_TO_BE_REVIEWED_DATE ");
		sqlStr_getSchedule3 = sqlStr.toString();		// **** 30 no of day before sending reminder ****
	}

	static {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.setLength(0);
		sqlStr.append("SELECT PIPRID, PIPR_NO, PIPR_PNAME, PIPR_OWNER, PIPR_EMAIL, to_char(PIPR_TO_BE_REVIEWED_DATE, 'YYYY-MM-DD'), PIPR_SUGGESTED_REFERENCE ");
		sqlStr.append("FROM   PI_POLICY_REMINDER ");
		sqlStr.append("WHERE  PIPR_ENABLED = '1' ");
		sqlStr.append("AND    (TRUNC(PIPR_TO_BE_REVIEWED_DATE) <= TRUNC(SYSDATE)) ");
		sqlStr.append("ORDER BY PIPR_TO_BE_REVIEWED_DATE ");
		sqlStr_getSchedule4 = sqlStr.toString();		// **** reached the no of day before sending reminder ****
	}
}