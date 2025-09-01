package com.hkah.client;

import com.extjs.gxt.ui.client.Registry;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.KeyListener;
import com.extjs.gxt.ui.client.widget.Document;
import com.google.gwt.core.client.EntryPoint;
import com.google.gwt.core.client.GWT;
import com.google.gwt.core.client.GWT.UncaughtExceptionHandler;
import com.google.gwt.dom.client.Element;
import com.google.gwt.dom.client.NativeEvent;
import com.google.gwt.event.dom.client.KeyCodes;
import com.google.gwt.user.client.DOM;
import com.google.gwt.user.client.Event;
import com.google.gwt.user.client.Event.NativePreviewEvent;
import com.google.gwt.user.client.Event.NativePreviewHandler;
import com.google.gwt.user.client.Window.Location;
import com.hkah.client.common.Factory;
import com.hkah.client.services.CommonUtilService;
import com.hkah.client.services.QueryUtilService;
import com.hkah.client.services.ReportService;
import com.hkah.client.util.CommonUtil;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.PrinterInfo;
import com.hkah.shared.model.UserInfo;

public abstract class AbstractEntryPointBase implements EntryPoint {

	public final static String QUERYUTIL_SERVICE = "queryUtilService";
	public final static String COMMONUTIL_SERVICE = "commonUtilService";
	public final static String REPORT_SERVICE = "reportService";

	private UserInfo userInfo = null;
	private PrinterInfo printerInfo = null;
//	protected boolean isPdfPrint = false;
	protected boolean isDisableApplet = false;
	protected String curProjectModule = null;

	public AbstractEntryPointBase() {
		super();
	}

	public void onModuleLoad() {
		initSystem();
		initCommmon();
		initProperties();
		initKeyEvent();
		preLoadModule();	// authentication
	}

	private void initSystem() {
		// store main frame in factory
		Factory.getInstance().setMainframe(getMainFrame());

		if (!GWT.isScript()) {
			GWT.setUncaughtExceptionHandler(new UncaughtExceptionHandler() {
				public void onUncaughtException(Throwable e) {
					e.printStackTrace();
				}
			});
		}

		// set theme (Please put in the onLoad part of the extending class
		//ThemeManager.register(Slate.SLATE);
//		GXT.setDefaultTheme(Slate.SLATE, false);

		// register service
	    Registry.register(QUERYUTIL_SERVICE, GWT.create(QueryUtilService.class));

	    Registry.register(COMMONUTIL_SERVICE, GWT.create(CommonUtilService.class));

	    Registry.register(REPORT_SERVICE, GWT.create(ReportService.class));

	    // allow child class to add service
	    initSystemPost();
	}

	private void initCommmon() {
		CommonUtil.loadComputerName();
		CommonUtil.loadComputerIP();
	}

	protected void initProperties() {
		CommonUtil.loadClientConfig();
	}

	private void initKeyEvent() {
		// http://ui-programming.blogspot.hk/2009/12/gxt-ext-gwt-how-can-i-disable-browsers.html
		disableDefaultContextMenu();
		Event.addNativePreviewHandler(new Event.NativePreviewHandler() {
			@Override
			public void onPreviewNativeEvent(NativePreviewEvent event) {
				if (event.getTypeInt() == Event.ONCONTEXTMENU) {
					event.getNativeEvent().preventDefault();
				}
			}
		});
		DOM.sinkEvents(getDocElement(), Event.ONCONTEXTMENU);

		// disable refresh button
		Event.addNativePreviewHandler(new NativePreviewHandler() {
			public void onPreviewNativeEvent(NativePreviewEvent event) {
				switch (event.getTypeInt()) {
					case Event.ONKEYDOWN:
						NativeEvent nEvent = event.getNativeEvent();
						if (nEvent.getCtrlKey() && nEvent.getKeyCode() == 'R') {
							nEvent.preventDefault();
						}

						if (nEvent.getKeyCode() == 116) {
							nEvent.preventDefault();
						}

						// prevent BACKSPACE to previous page
						if (nEvent.getKeyCode() == KeyCodes.KEY_BACKSPACE) {
					if (event.getNativeEvent().getEventTarget() != null) {
					    Element as = Element.as(event.getNativeEvent().getEventTarget());
					    boolean readOnly = as.getPropertyBoolean("readOnly");
					    boolean contentEditable = as.getPropertyBoolean("isContentEditable");	// contentEditable not work for Chrome (return false for input fields)
					    String inputType = as.getPropertyString("type");

					    try {
						    Object src = event.getSource();
					    } catch (Exception e) {
						//System.out.println(" e exception getmessage=" + e.getMessage());
					    }

					    //System.out.println(" inputType="+inputType+", contentEditable="+contentEditable+", readOnly="+readOnly);

					    if (!("text".equalsIgnoreCase(inputType) || "textarea".equalsIgnoreCase(inputType) || "password".equalsIgnoreCase(inputType)) ||
							readOnly) {
						event.getNativeEvent().stopPropagation();
						event.getNativeEvent().preventDefault();
					    }
					}
						}

						break;
				}
			}
		});
	}

	protected void preLoadModule() {
		// get information from html
		String siteCode = Location.getParameter("siteCode");
		String userID = Location.getParameter("userID");
		String userName = Location.getParameter("userName");
		String deptCode = Location.getParameter("deptCode");
		String ssoSessionID = Location.getParameter("ssoSessionID");
		String ssoModuleCode = Location.getParameter("ssoModuleCode");
		String ssoUserID = Location.getParameter("ssoUserID");
		String parentHost = Location.getHost();
		if (siteCode != null) getUserInfo().setSiteCode(siteCode);
		if (userID != null) getUserInfo().setUserID(userID);
		if (userName != null) getUserInfo().setUserName(userName);
		if (deptCode != null) getUserInfo().setDeptCode(deptCode);
		if (parentHost != null) getUserInfo().setParentHost(parentHost);
		if (ssoSessionID != null) getUserInfo().setSsoSessionID(ssoSessionID);
		if (ssoModuleCode != null) getUserInfo().setSsoModuleCode(ssoModuleCode);
		if (ssoUserID != null) getUserInfo().setSsoUserID(ssoUserID);

		// inital user info
		if (getUserInfo().getUserID() != null) {
			// initial user
			initUserInfoFromDB();
		} else {
			// load user id from config file
			initUserInfoFromConfig();
		}

		// check parameter
		setDisableApplet(ConstantsVariable.YES_VALUE.equals(Location.getParameter("isDisableApplet")));

		if (!isDisableApplet()) {
			// get browser type (chrome, non-chrome) for printing method (pdf, applet)
			String locPath = Location.getPath();
			if (locPath != null) {
				locPath = locPath.toLowerCase();
				if (locPath.contains("chrome")) {
					setDisableApplet(true);			// available for chrome only
//					if (!locPath.contains("prod")) {	// UAT only 2017/5/15
//						setPdfPrint(true);				// (pdf javascript is disabled in new version Chrome)
//					}
				}
			}
		}
	}

	public UserInfo getUserInfo() {
		if (userInfo == null) {
			userInfo = new UserInfo();
		}
		return userInfo;
	}

	public void setUserInfo(UserInfo userInfo) {
		this.userInfo = userInfo;
	}

	public PrinterInfo getPrinterInfo() {
		if (printerInfo == null) {
			printerInfo = new PrinterInfo();
		}
		return printerInfo;
	}

	public void setPrinterInfo(PrinterInfo printerInfo) {
		this.printerInfo = printerInfo;
	}

//	public boolean isPdfPrint() {
//		return isPdfPrint;
//	}

//	public void setPdfPrint(boolean isPdfPrint) {
//		this.isPdfPrint = isPdfPrint;
//	}

	public boolean isDisableApplet() {
		return isDisableApplet;
	}

	public void setDisableApplet(boolean isDisableApplet) {
		this.isDisableApplet = isDisableApplet;
	}

	/**
	 * @return the curProjectModule
	 */
	public String getCurProjectModule() {
		return curProjectModule;
	}

	/***************************************************************************
	 * Browse Handle
	 **************************************************************************/

	public static native void redirect(String url) /*-{
		$wnd.location = url;
	}-*/;

	/**
	 * Returns the document element.
	 */
	public static native com.google.gwt.user.client.Element getDocElement() /*-{
		return $doc;
	}-*/;

	/**
	 * Disable the browser's default right click response.
	 */
	public static void disableDefaultContextMenu() {
		Document.get().addListener(Events.OnContextMenu, new KeyListener() {
			@Override
			public void handleEvent(ComponentEvent be) {
				be.preventDefault();
			}
		});
		Document.get().sinkEvents(Event.ONCONTEXTMENU);
	}

	/***************************************************************************
	 * Abstract Method
	 **************************************************************************/

	protected abstract void initSystemPost();

	protected abstract void loadModule();

	protected abstract MainFrame getMainFrame();

	public abstract void initUserInfoFromDB();

	protected abstract void initUserInfoFromConfig();
}