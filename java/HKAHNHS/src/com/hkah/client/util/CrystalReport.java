package com.hkah.client.util;

import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.panel.CrystalReportPanel;
import com.hkah.client.tx.report.ReprintDayendReports;

public class CrystalReport {

	
	public static void print(MainFrame mainFrame, String rootPath, final String subDir,
			final String dayOfWeek, final String reportName, boolean isHistory) {
		
		print(mainFrame, rootPath, subDir, dayOfWeek, reportName, isHistory,true);
	}
	
	public static void print(MainFrame mainFrame, String rootPath, final String subDir,
								final String dayOfWeek, final String reportName, boolean isHistory, boolean isEnablePrintBtn) {
		CrystalReportPanel report = new CrystalReportPanel(mainFrame) {
			@Override
			public void printAction() {
				// TODO Auto-generated method stub
				ReprintDayendReports.print(subDir+"\\"+dayOfWeek+"\\", reportName, "", "1", "A4",
						String.valueOf(false), false);
			}
		};
		report.setIsEnablePrintBtn(isEnablePrintBtn);
		report.openReportPdf(rootPath+subDir, dayOfWeek, reportName, isHistory);
		Factory.getInstance().showPanel(report, true);
	}
}