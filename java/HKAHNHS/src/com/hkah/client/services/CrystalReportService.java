package com.hkah.client.services;

import com.google.gwt.user.client.rpc.RemoteService;
import com.google.gwt.user.client.rpc.RemoteServiceRelativePath;

@RemoteServiceRelativePath("crystalreportservice")
public interface CrystalReportService extends RemoteService {
	public String getReportSource(String rptPath, String dayOfWeek, String reportname, boolean isHistory);
}
