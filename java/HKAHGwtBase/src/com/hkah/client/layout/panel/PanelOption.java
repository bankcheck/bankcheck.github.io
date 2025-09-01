package com.hkah.client.layout.panel;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Info;
import com.extjs.gxt.ui.client.widget.button.Button;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.event.EventMessageBox;

public class PanelOption {
	final static Listener<MessageBoxEvent> callback = new Listener<MessageBoxEvent>() {
		public void handleEvent(MessageBoxEvent ce) {
			Button btn = ce.getButtonClicked();
			Info.display("MessageBox", "The '{0}' button was pressed", btn.getHtml());
		}
	};

	public static void addInformationMessage(String title, String message) {
		MessageBoxBase.info(title, message, callback);
	}

	public static void addConfirmYNDialog(String title, String message, EventMessageBox event) {
		MessageBoxBase.confirm(title, message, callback);   
	} 
}