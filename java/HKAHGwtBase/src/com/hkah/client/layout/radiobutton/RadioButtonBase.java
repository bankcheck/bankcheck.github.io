/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.radiobutton;

import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.widget.form.Radio;
import com.hkah.shared.constants.ConstantsVariable;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class RadioButtonBase extends Radio {

	public void setText(String value) {
		super.setBoxLabel(value);
	}

	public void resetText() {
		setText(ConstantsVariable.EMPTY_VALUE);
	}

	public boolean isSelected() {
		return super.getValue();
	}

	@Override
	protected final void onClick(ComponentEvent ce) {
		super.onClick(ce);
		onClick();
	} 

	public void onClick() {
		// override by child class when key released
	}

	public void setSelected(boolean value){
		setValue(value);
	}
	
	@Override
	public void setBounds(int x, int y, int width, int height) {
		setPosition(x, y);
	    setSize(width, height);
	}

	public void setEditable(boolean editable) {
		setReadOnly(!editable);
	}
}