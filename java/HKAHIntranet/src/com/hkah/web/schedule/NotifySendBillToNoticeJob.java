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

public class NotifySendBillToNoticeJob implements Job {

	@Override
	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		StringBuffer message = new StringBuffer();
		StringBuffer sqlStr = new StringBuffer();

		String applyNo = null;
		String applyDept = null;
		String shippedToName = null;
		String csr_code = null;

		List<String> to = new ArrayList<String>();

		ReportableListObject reportableListObject = null;
		ReportableListObject reportableListObject2 = null;
		ReportableListObject reportableListObject3 = null;
		ArrayList<ReportableListObject> billList_ArrayList = null;
		ArrayList<ReportableListObject> billDetail_ArrayList = null;
		ArrayList<ReportableListObject> toEmail_ArrayList = null;
		String billList_sqlStr = null;
		String billDetail_sqlStr = null;
		String toEmail_sqlStr = null;
		String updateBillFlag_sqlStr = null;

		sqlStr.setLength(0);
		sqlStr.append("SELECT ibn.apply_no, ibn.apply_dept, ibn.shipped_to, ");
		sqlStr.append("       (SELECT Trim(pd.dept_ename) FROM pn_dept pd WHERE Trim(pd.dept_id) = Trim(ibn.shipped_to)) AS order_dept_name ");
		sqlStr.append("FROM   ivs_billto_notice ibn ");
        if (ConstantsServerSide.isHKAH()) {
        	sqlStr.append("WHERE TRIM(ibn.apply_dept) IN (SELECT TRIM(dept_id) FROM pn_dept WHERE area = 'HKAH') ");
        } else {
    		sqlStr.append("WHERE TRIM(ibn.apply_dept) IN (SELECT TRIM(dept_id) FROM pn_dept WHERE area = 'TWAH') ");
        }
		sqlStr.append("AND  ibn.send_flag <> 1 ");
		sqlStr.append("AND  ibn.send_date is null ");		
		sqlStr.append("ORDER BY ibn.apply_dept ASC ");
		billList_sqlStr = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT iad.code, Trim(ig.code_name) AS code_name, ig.csr_code, iad.apply_qty, ");
		sqlStr.append("       (SELECT Trim(bs.code_name) FROM bas_systm bs WHERE bs.code_type = 'UNIT' AND bs.code_no = iad.apply_unit) AS apply_unit, ");
		sqlStr.append("       iad.seq_no ");
		sqlStr.append("FROM   ivs_apply_d iad, ivs_goods ig ");
		sqlStr.append("WHERE  iad.code = ig.code_no ");
		sqlStr.append("AND    iad.apply_no = ? ");
		sqlStr.append("ORDER BY iad.seq_no ");
		billDetail_sqlStr = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT DISTINCT email ");
		sqlStr.append("FROM   pms_notice_to ");
		sqlStr.append("WHERE  Trim(unit) = ? ");
		sqlStr.append("AND    type = '1' ");
		sqlStr.append("AND    active = '1' ");
		sqlStr.append("ORDER BY 1 ASC ");
		toEmail_sqlStr = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("update ivs_billto_notice set send_flag=1, send_date=sysdate where apply_no=? and send_flag<>1 and send_date is null");
		updateBillFlag_sqlStr = sqlStr.toString();

		billList_ArrayList = UtilDBWeb.getReportableListTAH(billList_sqlStr);
		for (int i = 0; i < billList_ArrayList.size(); i++) {
			reportableListObject = (ReportableListObject) billList_ArrayList.get(i);
			applyNo = reportableListObject.getValue(0);
			applyDept = reportableListObject.getValue(1);
			shippedToName = reportableListObject.getValue(3);

			// initial variable value
			to.clear();
			message.setLength(0);

			message.append("This message is auto generated from Hong Kong Adventist Hospital.<br>");
			message.append("Please do not reply to this email address.<br><br>");
			message.append("Apply No:");
			message.append(applyNo);
			message.append(" is ordered by ");
			message.append(shippedToName);
			message.append(". The following items will charge to your department.<br>");

			// retrieve items
			billDetail_ArrayList = UtilDBWeb.getReportableListTAH(billDetail_sqlStr, new String[] { applyNo });
			for (int j = 0; j < billDetail_ArrayList.size(); j++) {
				reportableListObject2 = (ReportableListObject) billDetail_ArrayList.get(j);
				csr_code = reportableListObject2.getValue(2);
				message.append("Material Code: ");
				message.append(reportableListObject2.getValue(0));
				message.append("(");
				if (csr_code != null) message.append(csr_code);
				message.append("), Item Desc.: ");
				message.append(reportableListObject2.getValue(1));
				message.append("', Order QTY: ");
				message.append(reportableListObject2.getValue(3));
				message.append(", Unit: ");
				message.append(reportableListObject2.getValue(4));
				message.append("<br>");
			}

			// retrieve email list
			toEmail_ArrayList = UtilDBWeb.getReportableListTAH(toEmail_sqlStr, new String[] { applyDept });
			for (int k = 0; k < toEmail_ArrayList.size(); k++) {
				reportableListObject3 = (ReportableListObject) toEmail_ArrayList.get(k);
				to.add(reportableListObject3.getValue(0));
			}

			// send email
			UtilMail.sendMail(
					ConstantsServerSide.MAIL_ALERT,
					to == null ? null : to.toArray(new String[to.size()]),
					null,
					null,
					"Internal Order Charge Notice :" + applyNo,
					message.toString());

			// update flag
			if (billDetail_ArrayList.size() > 0) {
				UtilDBWeb.updateQueueTAH(updateBillFlag_sqlStr, new String[] { applyNo });
			}
		}
	}
}