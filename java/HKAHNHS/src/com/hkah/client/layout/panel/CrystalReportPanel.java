package com.hkah.client.layout.panel;

import java.util.Date;

import com.extjs.gxt.ui.client.Registry;
import com.extjs.gxt.ui.client.Style.LayoutRegion;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Viewport;
import com.extjs.gxt.ui.client.widget.Window;
import com.extjs.gxt.ui.client.widget.layout.BorderLayout;
import com.extjs.gxt.ui.client.widget.layout.BorderLayoutData;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.google.gwt.user.client.ui.Frame;
import com.hkah.client.AbstractEntryPoint;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.services.CrystalReportServiceAsync;

public class CrystalReportPanel extends DefaultPanel {
	private Frame frame = null;
	private boolean isEnablePrintBtn = true;

	public CrystalReportPanel(MainFrame mainFrame) {
		super();
		setHideToolBar(true);
		setMainFrame(mainFrame);
	}

	public void openReportPdf(String rptPath, String dayOfWeek, String reportname, boolean isHistory) {
		getMainFrame().setLoading(true);
		((CrystalReportServiceAsync) Registry
				.get(AbstractEntryPoint.CRYSTAL_REPORT_SERVICE)).getReportSource(
					rptPath, dayOfWeek, reportname, isHistory,
				new AsyncCallback<String>() {
					@Override
					public void onSuccess(String result) {
						if (result != null) {
							setReportUrl(result);
							getMainFrame().setLoading(false);
						} else {
							Factory.getInstance().addErrorMessage("Report not found.",
									new Listener<MessageBoxEvent>() {
										@Override
										public void handleEvent(
												MessageBoxEvent be) {
											// TODO Auto-generated method stub
											exitPanel();
										}
							});
						}
						getMainFrame().setLoading(false);
					}

					@Override
					public void onFailure(Throwable caught) {
						Factory.getInstance().addErrorMessage(caught.getMessage());
						caught.printStackTrace();
						getMainFrame().setLoading(false);
					}
				});
	}

	public void setReportUrl(String url) {
		setReportUrl(url, null, null);
	}

	public void setReportUrl(String url, Integer width, Integer height) {
		disableButton();
		getPrintButton().setEnabled(getIsEnablePrintBtn());
		setHideToolBar(false);

		frame = new Frame();
		url += "?t=" + (new Date()).getTime();
		frame.setUrl(url);
		if (width != null && height != null) {
			frame.setPixelSize(width, height);
		} else {
			frame.setPixelSize(getMainFrame().getBodyPanel().getWidth() - 20, getMainFrame().getBodyPanel().getHeight() - 40);
		}

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

	public boolean getIsEnablePrintBtn() {
		return isEnablePrintBtn;
	}

	public void setIsEnablePrintBtn(boolean isEnablePrintBtn) {
		this.isEnablePrintBtn = isEnablePrintBtn;
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
		// TODO Auto-generated method stub
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