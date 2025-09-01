package com.hkah.client.tx.report;

import com.hkah.client.layout.table.TableData;
import com.hkah.client.util.TableUtil;

public class ReprintDayendSelectedReports extends ReprintDayendReports {

	private static final String[] selectedReport = {
		"rptArAdjust.rpt",
		"rptCshrAuditSmy.rpt",
		"rptDepSettle.rpt",
		"rptNoteToAcc.rpt",
		"rptPettyCash.rpt",
		"rptReceipt.rpt",
		"rptRefList.rpt",
		"rptRejChqLst.rpt"
	};

	@Override
	protected TableData filterReportList(String result) {
		TableData td = null;
		for (int i = 0; td == null && i < selectedReport.length; i++) {
			if (result.equals(selectedReport[i])) {
				td = new TableData(new String[]{ TableUtil.getName2ID("Name") }, new Object[]{ result });
			}
		}
		return td;
	}
}