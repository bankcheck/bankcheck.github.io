package com.hkah.servlet;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.web.db.helper.FsModelHelper;

public class ClearTempFileListener implements HttpSessionListener {

	@Override
	public void sessionCreated(HttpSessionEvent arg0) {
		// TODO Auto-generated method stub
	}
	
	@Override
	public void sessionDestroyed(HttpSessionEvent event) {
		// TODO Auto-generated method stub
		
		// clear Forward Scanning temp import files
		if (!ConstantsServerSide.isAMC()) {
			FsModelHelper.deleteTempImportFile(event.getSession().getId());
		}
	}
}
