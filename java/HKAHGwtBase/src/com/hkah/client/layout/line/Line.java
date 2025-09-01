package com.hkah.client.layout.line;

import com.extjs.gxt.ui.client.widget.LayoutContainer;

public class Line extends LayoutContainer {
	public Line(){
		super();
		setStyleAttribute("border-top", "1px solid black");
	}
	 
	public void setColor(String color){
		 setStyleAttribute("border-top",new String("1px solid ").concat(color));
		 layout();
	 }

	public void setBounds(int x, int y, int length) {
		setPosition(x, y);
	    setSize(length, 0);
		layout();
	}

	public void setBounds(int x, int y, int length, int height) {
		setPosition(x, y);
	    setSize(length, height);
		layout();
	}
}