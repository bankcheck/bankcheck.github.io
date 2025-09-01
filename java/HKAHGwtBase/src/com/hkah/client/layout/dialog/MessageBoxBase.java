package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.event.BoxComponentEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.MessageBox;
import com.hkah.client.common.Factory;

public class MessageBoxBase extends MessageBox {
	public static MessageBox alert(String title, String msg, Listener<MessageBoxEvent> callback) {
		MessageBox mb = MessageBox.alert(title, msg, callback);
		addCloseHandler(mb);
		return mb;
	}

	public static MessageBox confirm(String title, String msg, Listener<MessageBoxEvent> callback) {
		final MessageBox mb = MessageBox.confirm(title, msg, callback);

		mb.getDialog().addListener(Events.OnKeyDown, new Listener<BoxComponentEvent>() {
			@Override
			public void handleEvent(BoxComponentEvent be) {
				if (be.getKeyCode() == 89) {
					mb.getDialog().getButtonById(Dialog.YES).fireEvent(Events.Select);
				} else if (be.getKeyCode() == 78) {
					mb.getDialog().getButtonById(Dialog.NO).fireEvent(Events.Select);
				} else if (be.getKeyCode() == 37 || be.getKeyCode() == 39) {
					mb.getDialog().focus();
					if (mb.getDialog().getFocusWidget().equals(mb.getDialog().getButtonById(Dialog.NO))) {
						mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
					} else {
						mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.NO));
					}
				} else if(be.getKeyCode() == 9) {
					mb.getDialog().focus();
					if (mb.getDialog().getFocusWidget().equals(mb.getDialog().getButtonById(Dialog.NO))) {
						mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
					} else {
						mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.NO));
					}
				}
			}
		});

		addCloseHandler(mb);
		return mb;
	}

	public static MessageBox info(String title, String msg, Listener<MessageBoxEvent> callback) {
		MessageBox mb = MessageBox.info(title, msg, callback);
		addCloseHandler(mb);
		return mb;
	}

	public static MessageBox progress(String title, String msg, String progressText) {
		MessageBox mb = MessageBox.progress(title, msg, progressText);
		addCloseHandler(mb);
		return mb;
	}

	public static MessageBox prompt(String title, String msg) {
		return prompt(title, msg, false, null);
	}

	public static MessageBox prompt(String title, String msg, boolean multiline) {
		return prompt(title, msg, multiline, null);
	}

	public static MessageBox prompt(String title, String msg, boolean multiline, Listener<MessageBoxEvent> callback) {
		MessageBox mb = MessageBox.prompt(title, msg, multiline, callback);
		addCloseHandler(mb);
		return mb;
	}

	public static MessageBox prompt(String title, String msg, Listener<MessageBoxEvent> callback) {
		return prompt(title, msg, false, callback);
	}

	public static MessageBox wait(String title, String msg, String progressText) {
		MessageBox mb = MessageBox.wait(title, msg, progressText);
		addCloseHandler(mb);
		return mb;
	}

	public static void addWarningMessage(String title, String msg, Listener<MessageBoxEvent> callback) {
		MessageBox box = new MessageBoxBase();
		box.setTitleHtml(title);
		box.setMessage(msg);
		box.addCallback(callback);
		box.setButtons(MessageBox.OK);
		box.setMinWidth(470);
		box.setIcon(MessageBox.WARNING);
		addCloseHandler(box);
		box.show();
	}

	public static void addCloseHandler(MessageBox mb) {
		mb.getDialog().addListener(Events.Hide, new Listener<MessageBoxEvent>() {
			@Override
			public void handleEvent(MessageBoxEvent be) {
				// TODO Auto-generated method stub
				if (Factory.getInstance().getMainFrame().getBodyPanel()
						.getDefaultFocusComponent() != null) {
					Factory.getInstance().getMainFrame().getBodyPanel()
						.getDefaultFocusComponent().focus();
				} else {
					Factory.getInstance().getMainFrame().getBodyPanel().focus();
				}
			}
		});
	}
}