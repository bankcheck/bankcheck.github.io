package com.hkah.client.util;

import com.hkah.client.common.Factory;
import com.hkah.client.event.CallbackListener;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class OTTmpUtil {
	public static final String TXCODE = "OTTmpUtil.generateReport";
	
	public static void generateReport(final String path, final String valueJSONStr,
			final CallbackListener listner) {
		System.out.println("[DEBUG] OTTmpUtil generateReport path="+path);
		
		Factory.getInstance().showMask();
		QueryUtil.executeMasterBrowse(
				Factory.getInstance().getUserInfo(), 
				ConstantsTx.LOOKUP_TXCODE, 
				new String [] {
					"dual", 
					"SEQ_DRPREPORT.NEXTVAL",
					"1=1"
				}, 
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						// TODO Auto-generated method stub
						if (mQueue.success()) {
							String drpid = mQueue.getContentField()[0];
							
							System.out.println("[DEBUG] OTTmpUtil call openOTReport drpid="+drpid);
							
							String errMsg = openOTReport(drpid, path, true, valueJSONStr,
									false, Factory.getInstance().getUserInfo().getUserID());
							
							System.out.println("[DEBUG] OTTmpUtil call openOTReport drpid="+drpid+", errMsg="+errMsg);
							
							MessageQueue mq = null;
							String serverDate = Factory.getInstance().getMainFrame().getServerDate();
							String serverTime = Factory.getInstance().getMainFrame().getServerTime();
							if (errMsg != null && errMsg.length() > 0) {
								mq = new MessageQueue(TextUtil.combine(new String[]{
										TXCODE, 
										serverDate,
										serverTime,
										"-1",
										errMsg
										}));
							} else {
								mq = new MessageQueue(TextUtil.combine(new String[]{
										TXCODE, 
										serverDate,
										serverTime,
										drpid,
										"OK"
										}));
							}
							
							listner.handleRetBool(true, errMsg, mq);
							Factory.getInstance().hideMask();
						} else {
							Factory.getInstance()
								.addErrorMessage("Fail to generate report ID.");
							Factory.getInstance().hideMask();
						}
					}
				});
	}
	
	public static native String openOTReport(String drpid, String path, 
			boolean replaceWord, String valueJSONStr,
			boolean readOnly, String user) /*-{
		var applet = $wnd.document.getElementById('HKAHNHSApplet');
		return applet.openOTTmpReport(drpid, path, replaceWord, valueJSONStr, readOnly, user);
	}-*/;
}
