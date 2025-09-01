package com.hkah.client.tx.report;

import com.hkah.client.common.Factory;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.tx.NoScreenPanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class LabSummaryReport extends NoScreenPanel {

private String commandLine = ""; 
	/**
	 * This method initializes
	 *
	 */
	public boolean preAction() {
		openLabSystem();
		//Factory.getInstance().showPanel(getMainFrame(), panel, false,false);
		return true;
	}
	
	public void postAction() {
		Factory.getInstance().showPanel();
	}

	public void openLabSystem() {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE, 
				new String[] { "CUSRPT", "CURPATH, CURCHKUSRID", "CURID = 6" }, 
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					if (Factory.getInstance().getMainFrame().isDisableApplet()) {
						openLIS4Exe(getCommandLine());
					} else {
						openLIS4Applet(mQueue.getContentField()[0] + getCommandLine());
					}
				} else {
					Factory.getInstance().addErrorMessage("Cannot open the report.");
				}
			}
		});
	}
	
	public String getCommandLine() {
		return " "+Factory.getInstance().getUserInfo().getUserID()+
		   " "+"000000"+
		   " "+getMainFrame().getServerDate()+
		   " "+getMainFrame().getServerDate();
	}
	
	public void setCommandLine(String commandLine) {
		this.commandLine = commandLine;
	}

	private native void openLIS4Exe(String cmd) /*-{
	if (cmd.length > 0) {
		alert(cmd);
		window.location.href = "NHSClientLIS:" + cmd;
	}

	}-*/;

	private native void openLIS4Applet(String cmd) /*-{
		alert(cmd);
		var appletName = @com.hkah.client.util.PrintingUtil::getAppletName()();
		if (appletName == null || appletName == '') {
			alert('Cannot get applet:' + appletName);
		}

		var applet = $wnd.document.getElementById(appletName);
		applet.openLIS(cmd);

	}-*/;
}