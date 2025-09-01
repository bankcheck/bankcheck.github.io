/*
 * Created on July 25, 2011
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.shared.model;

import com.google.gwt.user.client.rpc.AsyncCallback;
import com.google.gwt.user.client.rpc.StatusCodeException;
import com.hkah.client.common.Factory;
import com.hkah.shared.constants.ConstantsErrorMessage;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public abstract class MessageQueueCallBack implements AsyncCallback<MessageQueue> {

	private final static String HTTP_ERROR_0 = "0";
	private final static String HTTP_ERROR_404 = "404";
	private final static String HTTP_ERROR_12029 = "12029";
	private final static String HTTP_ERROR_12152 = "12152";
	private final static String NOT_KNOWN = "Unknown";

	public abstract void onPostSuccess(MessageQueue mQueue);

	public final void onSuccess(MessageQueue mQueue) {
		// call onPostSuccess
		if (mQueue != null && !mQueue.success() && !ConstantsErrorMessage.NO_RECORD_FOUND.equals(mQueue.getReturnMsg())) {
			Factory.getInstance().addSystemMessage("Server", mQueue.getReturnMsg());
		}

		// avoid throw exception in onPostSuccess()
		try {
			onPostSuccess(mQueue);
		} catch (Exception e) {
			e.printStackTrace();
		}

		onComplete();
	}

	public void onFailure(Throwable caught) {
		String msg = caught == null ? NOT_KNOWN : caught.getMessage();
		String localMsg = caught == null ? NOT_KNOWN : caught.getLocalizedMessage();

		if (caught instanceof StatusCodeException) {
			// log status code to local
			Factory.getInstance().writeLogToLocal("HTTP ERROR:[" + ((StatusCodeException) caught).getStatusCode() + "]");
		} else {
			// only shown unknown message
			Factory.getInstance().addSystemMessage("Server", "Server is busy.\n" + msg + ", " + localMsg);
		}
		onComplete();
	}

	public void onComplete() {
		Factory.getInstance().hideMask();
	}
}