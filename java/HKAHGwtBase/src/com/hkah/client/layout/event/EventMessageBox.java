package com.hkah.client.layout.event;

import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.MessageBox;
import com.extjs.gxt.ui.client.widget.button.Button;

public abstract class EventMessageBox extends MessageBoxEvent {

	public EventMessageBox(MessageBox messageBox, Dialog window, Button buttonClicked) {
		super(messageBox, window, buttonClicked);
	}
}
