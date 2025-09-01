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

public class NotifySendItemOutstandJob implements Job {

	public void execute(JobExecutionContext arg0) throws JobExecutionException {
		StringBuffer message = new StringBuffer();
		StringBuffer sqlStr = new StringBuffer();

		String applyNo = null;
		String applyDept = null;
		String applyDeptName = null;
		String code = null;
		String codeName = null;
		String csrCode = null;
		String qty = null;
		String outStandQty = null;
		String unit = null;

		String getOustandItem_sqlStr = null;
		String getOustandList_sqlStr = null;
		String getMailList_sqlStr = null;
		String updateSendFlag_sqlStr = null;

		List<String> mailTo = new ArrayList<String>();

		ArrayList<ReportableListObject> outStandList_ArrayList = null;
		ArrayList<ReportableListObject> outStandItem_ArrayList = null;
		ArrayList<ReportableListObject> mailList_ArrayList = null;

		ReportableListObject reportableListObject = null;
		ReportableListObject reportableListObject2 = null;
		ReportableListObject reportableListObject3 = null;

		sqlStr.setLength(0);
		sqlStr.append("SELECT iam.apply_no, Trim(iam.apply_dept) AS applyDept, (SELECT Trim(pd.dept_ename) FROM pn_dept pd WHERE pd.dept_id = iam.apply_dept) AS dept_name ");
		sqlStr.append("FROM ivs_apply_m iam ");
        if (ConstantsServerSide.isHKAH()) {
        	sqlStr.append("WHERE iam.apply_dept IN (SELECT dept_id FROM pn_dept WHERE area = 'HKAH') ");
        } else {
    		sqlStr.append("WHERE iam.apply_dept IN (SELECT dept_id FROM pn_dept WHERE area = 'TWAH') ");
		}
		sqlStr.append("AND iam.apply_no IN (");
		sqlStr.append("SELECT DISTINCT apply_no ");
		sqlStr.append("FROM ivs_item_outstanding_notice ");
		sqlStr.append("WHERE send_flag<>1) ");
		sqlStr.append("ORDER BY iam.apply_no ASC");
		getOustandList_sqlStr = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT DISTINCT iion.code, Trim(ig.code_name) AS code_name, ig.csr_code, iion.apply_qty, iion.outstanding_qty, ");
		sqlStr.append("(SELECT Trim(bs.code_name) FROM bas_systm bs WHERE bs.code_type = 'UNIT' AND bs.code_no = iad.apply_unit) AS apply_unit, ");
		sqlStr.append("iad.seq_no ");
		sqlStr.append("FROM ivs_item_outstanding_notice iion, ivs_apply_d iad, ivs_goods ig ");
		sqlStr.append("WHERE iion.apply_no = iad.apply_no(+) ");
		sqlStr.append("AND iion.code = iad.code(+) ");
		sqlStr.append("AND iad.code = ig.code_no(+) ");
		sqlStr.append("AND iion.apply_no = ? ");
		sqlStr.append("ORDER BY iad.seq_no ");
		getOustandItem_sqlStr = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("SELECT DISTINCT email ");
		sqlStr.append("FROM ivs_notice_to ");
		sqlStr.append("WHERE Trim(unit) = ? ");
		sqlStr.append("AND type = '1' ");
		sqlStr.append("AND active = '1' ");
		sqlStr.append("ORDER BY staff_no ASC");
		getMailList_sqlStr = sqlStr.toString();

		sqlStr.setLength(0);
		sqlStr.append("update ivs_item_outstanding_notice ");
		sqlStr.append("set send_flag=1, send_date=sysdate ");
		sqlStr.append("where apply_no=? ");
		sqlStr.append("and send_flag<>1");
		updateSendFlag_sqlStr = sqlStr.toString();

		// Get markup list
		outStandList_ArrayList = UtilDBWeb.getReportableListTAH(getOustandList_sqlStr);
		for (int i = 0; i < outStandList_ArrayList.size(); i++) {
			reportableListObject = (ReportableListObject) outStandList_ArrayList.get(i);
			applyNo = reportableListObject.getFields0();
			applyDept = reportableListObject.getFields1();
			applyDeptName = reportableListObject.getFields2();

			mailTo.clear();
			message.setLength(0);
			message.append("This message is auto generated from Hong Kong Adventist Hospital.<br>");
			message.append("Please do not reply to this email address.<br><br>");
			message.append("*'Internal Order Items Outstanding Notice :"+applyNo+" by department: "+applyDeptName+"* <br><br>");

			outStandItem_ArrayList = UtilDBWeb.getReportableListTAH(getOustandItem_sqlStr, new String[] { applyNo });
			for (int j = 0; j < outStandItem_ArrayList.size(); j++) {
				reportableListObject3 = (ReportableListObject) outStandItem_ArrayList.get(j);
				code = reportableListObject3.getFields0();
				codeName = reportableListObject3.getFields1();
				csrCode = reportableListObject3.getFields2();
				qty = reportableListObject3.getFields3();
				outStandQty = reportableListObject3.getFields4();
				unit = reportableListObject3.getFields5();

				message.append("Material Code: "+code+"("+csrCode+"), Item Desc.: "+codeName+", Order QTY: "+qty+", Outstanding QTY: "+outStandQty+", Unit: "+unit+"<br>");
			}

			if (outStandList_ArrayList.size() > 0) {
				// Get mail list
				mailList_ArrayList = UtilDBWeb.getReportableListTAH(getMailList_sqlStr, new String[] { applyDept });
				for (int k=0 ; k<mailList_ArrayList.size(); k++) {
					reportableListObject2 = (ReportableListObject) mailList_ArrayList.get(k);
					mailTo.add(reportableListObject2.getFields0());
				}

				// Send mail
				UtilMail.sendMail(
						ConstantsServerSide.MAIL_ALERT,
						mailTo == null?null:mailTo.toArray(new String[mailTo.size()]),
						null,
						null,
						"Apply No:"+applyNo+" by department: "+applyDeptName+" , following item(s) is/are out of stock",
						message.toString());

				UtilDBWeb.updateQueueTAH(updateSendFlag_sqlStr, new String[] {applyNo});
			}
		}
	}
}