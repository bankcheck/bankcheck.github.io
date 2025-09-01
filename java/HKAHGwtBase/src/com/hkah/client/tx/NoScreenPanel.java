package com.hkah.client.tx;

import com.google.gwt.user.client.Window;
import com.hkah.client.layout.panel.BasePanel;

public class NoScreenPanel extends BasePanel {

	private final static String BLANK_TARGET = "_blank";

	/***************************************************************************
	 * Methods for child class
	 **************************************************************************/

	public void openNewWindow(String url) {
		openNewWindow(url, null);
	}
	
	public void openNewWindow(String url, String specs) {
		openNewWindow(BLANK_TARGET, url, specs);
	}

	public void openNewWindow(String target, String url, String specs) {
		Window.open(url, target, specs);
	}		
}
