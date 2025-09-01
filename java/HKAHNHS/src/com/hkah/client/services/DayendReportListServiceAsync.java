package com.hkah.client.services;

import com.google.gwt.user.client.rpc.AsyncCallback;

public interface DayendReportListServiceAsync {
	void getReportList(String rootPath, String dayOfWeek, boolean isHistory, String filter, 
						AsyncCallback<String[]> callback);
}
