package com.hkah.client.layout.button;

import com.extjs.gxt.ui.client.widget.button.ButtonGroup;

public class ButtonGroupBase extends ButtonGroup {

	public ButtonGroupBase(int columns) {
		super(columns);
		// TODO Auto-generated constructor stub
	}
	@Override
	public void setBounds(int x, int y, int width, int height) {
		setPosition(x, y);
	    setSize(width, height);
	}
}
