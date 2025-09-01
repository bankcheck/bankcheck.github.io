package com.hkah.servlet;

import javax.servlet.http.HttpServlet;

import org.apache.log4j.Logger;

import com.hkah.ehr.common.FactoryBase;

public class HKAHEHRInitServlet extends HttpServlet {
	protected static Logger logger = Logger.getLogger(HKAHEHRInitServlet.class);
	
	@Override
	public void init() throws javax.servlet.ServletException {
		logger.info("== HKAHEHRInitServlet ==");
		FactoryBase.getInstance().loadSysparams();
	}
}
