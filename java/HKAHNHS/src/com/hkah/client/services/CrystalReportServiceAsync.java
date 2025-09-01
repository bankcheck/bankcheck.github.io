package com.hkah.client.services;

import com.google.gwt.user.client.rpc.AsyncCallback;

public interface CrystalReportServiceAsync {
	void getReportSource(String rptPath, String dayOfWeek, String reportname, boolean isHistory, AsyncCallback<String> callback);
}
