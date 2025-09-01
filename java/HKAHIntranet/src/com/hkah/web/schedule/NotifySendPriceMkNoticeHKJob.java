package com.hkah.web.schedule;

import java.util.ArrayList;
import java.util.List;

import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.util.db.UtilDBWeb;
import com.hkah.util.mail.UtilMail;
import com.hkah.web.common.ReportableListObject;

public class NotifySendPriceMkNoticeHKJob implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		StringBuffer message = new StringBuffer();
		StringBuffer sqlStr = new StringBuffer();

		String code = null;
		String csrCode = null;
		String newPrice = null;
		String newMKPrice = null;
		String unit = null;
		String codeName = null;
		String site = null;

		String getMarkUpList_sqlStr = null;
		String getMailList_sqlStr = null;
		String updateSendFlag_sqlStr = null;

		List<String> mailTo = new ArrayList<String>();

		ArrayList<ReportableListObject> appList_ArrayList = null;
		ArrayList<ReportableListObject> mailList_ArrayList = null;

		ReportableListObject reportableListObject = null;
		ReportableListObject reportableListObject2 = null;

		sqlStr.setLength(0);
		sqlStr.append("SELECT ppn.code_no,ppn.csr_code,ppn.new_price,ppn.new_markup_price,ppn.unit,Trim(ig.code_name) AS code_name,ppn.site ");
		sqlStr.append("FROM pms_price_notice ppn, ivs_goods ig ");
		sqlStr.append("WHERE ppn.code_no = ig.code_no(+) ");
		sqlStr.append("AND ppn.send_flag = 0 ");
		sqlStr.append("AND ppn.tw_csr_code IS NULL ");
		sqlStr.append("AND ppn.site = 'HKAH' ");
		sqlStr.append("ORDER BY ppn.insert_date ASC ");
		getMarkUpList_sqlStr = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT DISTINCT email ");
		sqlStr.append("FROM pms_notice_to ");
		sqlStr.append("WHERE active = 1 ");
		sqlStr.append("AND area = 'HKAH' AND type ='PM'");
		getMailList_sqlStr = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("UPDATE pms_price_notice ppn ");
		sqlStr.append("SET ppn.send_flag = 1, ");
		sqlStr.append("ppn.send_date = sysdate ");
		sqlStr.append("WHERE ppn.send_flag = 0 ");
		sqlStr.append("AND ppn.tw_csr_code IS NULL ");
		sqlStr.append("AND ppn.site = 'HKAH' ");
		sqlStr.append("AND ppn.check_no IN (SELECT check_no FROM pms_price_notice WHERE send_flag = 0 AND tw_csr_code IS NULL AND site = 'HKAH') ");
		sqlStr.append("AND ppn.code_no IN (SELECT code_no FROM pms_price_notice WHERE send_flag = 0 AND tw_csr_code IS NULL AND site = 'HKAH') ");
		updateSendFlag_sqlStr = sqlStr.toString();

		mailTo.clear();
		message.setLength(0);
		message.append("This message is auto generated from Hong Kong Adventist Hospital.<br>");
		message.append("Please do not reply to this email address.<br><br>");
		message.append("*Item price increased in HKAH* <br><br>");

		// Get markup list
		appList_ArrayList = UtilDBWeb.getReportableListTAH(getMarkUpList_sqlStr);
		for (int i = 0; i < appList_ArrayList.size(); i++) {
			reportableListObject = (ReportableListObject) appList_ArrayList.get(i);
			code = reportableListObject.getFields0();
			csrCode = reportableListObject.getFields1();
			newPrice = reportableListObject.getFields2();
			newMKPrice = reportableListObject.getFields3();
			unit = reportableListObject.getFields4();
			codeName = reportableListObject.getFields5();
			site = reportableListObject.getFields6();

			message.append("Material Code: "+code+", HKAH Bill Code: "+csrCode+", New Average Price: "+newPrice+", New Markup Price: "+newMKPrice+", Unit: "+unit+", Description: "+codeName+", Site: "+site+"<br>");
			message.append("<br>");
		}

		if (appList_ArrayList.size() > 0) {
			// Get mail list
			mailList_ArrayList = UtilDBWeb.getReportableListTAH(getMailList_sqlStr);
			for (int k = 0; k < mailList_ArrayList.size(); k++) {
				reportableListObject2 = (ReportableListObject) mailList_ArrayList.get(k);
				mailTo.add(reportableListObject2.getFields0());
			}

			// Send mail
			UtilMail.sendMail(
					ConstantsServerSide.MAIL_ALERT,
					mailTo == null ? null : mailTo.toArray(new String[mailTo.size()]),
					null,
					null,
					"Billing price markup HKAH",
					message.toString());

			UtilDBWeb.updateQueueTAH(updateSendFlag_sqlStr);
		}
	}
}