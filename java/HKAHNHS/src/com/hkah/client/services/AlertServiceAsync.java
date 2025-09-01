package com.hkah.client.services;

import java.util.List;
import java.util.Map;

import com.google.gwt.user.client.rpc.AsyncCallback;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.UserInfo;

public interface AlertServiceAsync {
	void patientMailAlert(UserInfo userInfo, String patno, String funname,
			Map<String, String> params, Map<String, List<String>> addrAltdescs,
			String gAltMalEmail, String gAltMalPth, String gAltMalUrl,
			String patfname, String patgname, String patcname, String miscRemark, boolean thruUrl,
			AsyncCallback<MessageQueue> callback);
}