package com.hkah.client.layout;

import com.extjs.gxt.ui.client.widget.form.FieldSet;
import com.extjs.gxt.ui.client.widget.layout.AbsoluteLayout;
import com.google.gwt.user.client.Element;

public class FieldSetBase extends FieldSet{
	
	@Override
	protected void onRender(Element parent, int pos) {
		super.onRender(parent, pos);
		setLayout(new AbsoluteLayout());
		setStyleAttribute("padding","0px");
	}

	@Override
	public void setBounds(int x, int y, int width, int height) {
		setPosition(x, y);
		setSize(width, height);
	}

	public void setHeading(String value) {
		super.setHeadingHtml(value);
	}
}