package com.hkah.client.layout.label;

import com.extjs.gxt.ui.client.widget.Status;

public class StatusBase extends Status {

	public void setText(String text) {
		super.setHtml(text);
	}

	public String getText() {
		return super.getHtml();
	}
}