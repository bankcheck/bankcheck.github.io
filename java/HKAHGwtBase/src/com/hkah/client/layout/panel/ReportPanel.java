package com.hkah.client.layout.panel;

import java.util.Date;
import java.util.Map;

import com.extjs.gxt.ui.client.Style.LayoutRegion;
import com.extjs.gxt.ui.client.widget.Viewport;
import com.extjs.gxt.ui.client.widget.Window;
import com.extjs.gxt.ui.client.widget.layout.BorderLayout;
import com.extjs.gxt.ui.client.widget.layout.BorderLayoutData;
import com.google.gwt.user.client.Timer;
import com.google.gwt.user.client.ui.Frame;
import com.hkah.shared.util.UrlUtil;

public class ReportPanel extends DefaultPanel {

	private Frame frame = null;

	/**
	 * This method initializes
	 *
	 */
	public ReportPanel() {
		super();
		setHideToolBar(true);
	}

	/**
	 * initial the screen layout and listener
	 */
	public void postAction() {
		disableButton();
		// preview mode
		getPrintButton().setEnabled(true);
		getCancelButton().setEnabled(true);
	}

	public void setReportUrl(String url) {
		setHideToolBar(false);

		frame = new Frame();
		
		// set url delay to avoid client retrieve faster than server pdf render
		Map<String, Object> params = UrlUtil.encapUrlQueryParams(url);
		String RptPnDelay = (String) params.get("RptPnDelay");
		int delayMillis = 0;
		if (RptPnDelay != null) {
			try {
				delayMillis = Integer.parseInt(RptPnDelay);
			} catch (Exception e) {
			}
		}
		
		if (url.indexOf("?") > -1) {
			url += "&t=" + (new Date()).getTime();
		}
		else {
			url += "?t=" + (new Date()).getTime();
		}
		
		final String url2 = url;
		if (delayMillis > 0) {
			Timer timer = new Timer() {
			      public void run() {
			    	  frame.setUrl(url2);
			      }
			    };
			timer.schedule(delayMillis);
		} else {
			frame.setUrl(url2);
		}
		frame.setPixelSize(getMainFrame().getBodyPanel().getWidth()-20, getMainFrame().getBodyPanel().getHeight()-40);
		
		Window w = new Window();
	    w.setModal(true);
	    w.setMaximizable(true);
	    w.setResizable(false);
	    w.setClosable(false);
	    w.setBodyBorder(false);
	    w.setBorders(false);
	    w.setCollapsible(false);
	    w.setDraggable(false);
	    w.setHeaderVisible(false);
	    w.setHideCollapseTool(true);
	    w.add(frame);

		Viewport viewport = new Viewport();
		final BorderLayout borderLayout = new BorderLayout();
		viewport.setLayout(borderLayout);

		BorderLayoutData menuBarToolBarLayoutData = new BorderLayoutData(LayoutRegion.NORTH, 25);
		menuBarToolBarLayoutData.setCollapsible(false);
		menuBarToolBarLayoutData.setSplit(false);
		viewport.add(getToolBar(), menuBarToolBarLayoutData);

		BorderLayoutData mainContentsLayoutData = new BorderLayoutData(LayoutRegion.CENTER);
		mainContentsLayoutData.setCollapsible(false);
		mainContentsLayoutData.setFloatable(true);
		viewport.add(w, mainContentsLayoutData);

		add(viewport);
		layout();
	}

	public void postPrint(boolean success, String result) {
		
	}

	@Override
	public void searchAction() {
		// TODO Auto-generated method stub

	}

	@Override
	public void appendAction() {
		// TODO Auto-generated method stub

	}

	@Override
	public void modifyAction() {
		// TODO Auto-generated method stub

	}

	@Override
	public void deleteAction() {
		// TODO Auto-generated method stub

	}

	@Override
	public void saveAction() {
		// TODO Auto-generated method stub

	}

	@Override
	public void acceptAction() {
		// TODO Auto-generated method stub

	}

	@Override
	public void cancelAction() {
		getMainFrame().exitPanel();
	}

	@Override
	public void clearAction() {
		// TODO Auto-generated method stub

	}

	@Override
	public void refreshAction() {
		// TODO Auto-generated method stub

	}

	@Override
	public void printAction() {
		// TODO Auto-generated method stub

	}

	@Override
	public String getTxCode() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String getTitle() {
		// TODO Auto-generated method stub
		return null;
	}
}