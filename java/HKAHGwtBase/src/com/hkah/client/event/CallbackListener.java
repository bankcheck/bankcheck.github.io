package com.hkah.client.event;

import com.hkah.shared.model.MessageQueue;

public abstract class CallbackListener {
	public void handleRetBool(boolean ret, String result, MessageQueue mQueue){};
}
