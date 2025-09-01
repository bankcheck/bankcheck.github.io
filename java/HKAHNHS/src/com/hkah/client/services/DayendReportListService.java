package com.hkah.client.services;

import com.google.gwt.user.client.rpc.RemoteService;
import com.google.gwt.user.client.rpc.RemoteServiceRelativePath;

@RemoteServiceRelativePath("dayendreportlistservice")
public interface DayendReportListService extends RemoteService {
	public String[] getReportList(String rootPath, String dayOfWeek, boolean isHistory, String filter);
}
