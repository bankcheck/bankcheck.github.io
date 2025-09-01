package com.hkah.client;

import com.extjs.gxt.ui.client.Registry;
import com.google.gwt.core.client.GWT;
import com.hkah.client.services.AlertService;
import com.hkah.client.services.CrystalReportService;
import com.hkah.client.services.DayendReportListService;
import com.hkah.client.services.EhrService;
import com.hkah.client.services.FileIOUtilService;

public abstract class AbstractEntryPoint extends AbstractEntryPointBase {

	public final static String ALERT_SERVICE = "alertService";
	public final static String FILE_SERVICE = "fileService";
	public final static String CRYSTAL_REPORT_SERVICE = "crystalreportservice";
	public final static String DAYEND_REPORT_LIST_SERVICE = "dayendreportlistservice";
	public final static String EHR_SERVICE = "ehrService";

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void initSystemPost() {
		Registry.register(ALERT_SERVICE, GWT.create(AlertService.class));

		Registry.register(FILE_SERVICE, GWT.create(FileIOUtilService.class));
		
		Registry.register(CRYSTAL_REPORT_SERVICE, GWT.create(CrystalReportService.class));
		
		Registry.register(DAYEND_REPORT_LIST_SERVICE, GWT.create(DayendReportListService.class));
		
		Registry.register(EHR_SERVICE, GWT.create(EhrService.class));
	}
}