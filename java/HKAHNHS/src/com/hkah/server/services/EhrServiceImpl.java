package com.hkah.server.services;

import hk.gov.ehr.service.biz.epmi.hkid.CheckDigit;

import com.google.gwt.user.server.rpc.RemoteServiceServlet;
import com.hkah.client.services.EhrService;

@SuppressWarnings("serial")
public class EhrServiceImpl extends RemoteServiceServlet implements EhrService {
	private CheckDigit cd = new CheckDigit();
	
	@Override
	public String isValidHkid(String hkid) {
		String ret = null;
		try {
			cd.isValidHkid(hkid, "E");
		} catch (Exception e) {
			ret = e.getMessage();
		}
		return ret;
	}
}