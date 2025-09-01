package com.hkah.web.db.helper;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import com.hkah.web.db.SsoUserDB;

public class SSOSessionListener implements HttpSessionListener {

	@Override
	public void sessionCreated(HttpSessionEvent event) {
	
	}

	@Override
	public void sessionDestroyed(HttpSessionEvent event) {		
		SsoUserDB.deleteSessionID(event.getSession().getId());
	}
}
