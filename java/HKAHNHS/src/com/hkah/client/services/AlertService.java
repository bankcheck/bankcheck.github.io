package com.hkah.client.services;

import java.util.List;
import java.util.Map;

import com.google.gwt.user.client.rpc.RemoteService;
import com.google.gwt.user.client.rpc.RemoteServiceRelativePath;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.UserInfo;

@RemoteServiceRelativePath("alertservice")
public interface AlertService extends RemoteService {
	MessageQueue patientMailAlert(UserInfo userInfo, String patno, String funname,
			Map<String, String> params, Map<String, List<String>> addrAltdescs,
			String gAltMalEmail, String gAltMalPth, String gAltMalUrl,
			String patfname, String patgname, String patcname, String miscRemark, boolean thruUrl);
}