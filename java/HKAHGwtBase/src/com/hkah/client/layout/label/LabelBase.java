package com.hkah.client.layout.label;

import com.extjs.gxt.ui.client.widget.form.LabelField;
import com.hkah.shared.constants.ConstantsVariable;

public class LabelBase extends LabelField {

	private static final String TEXT_ALIGN = "text-align";
	private static final String ALIGN_RIGHT = "right";
	private static final String ALIGN_CENTER = "center";
	private static final String FONT_COLOR = "color";
	private static final String COLOR_BLUE = "blue";
	private static final String COLOR_GREEN = "green";
	private static final String COLOR_RED = "red";

	private String separator = null;

	public LabelBase() {
		super();
	}

	public LabelBase(String text) {
		super(text);
	}
	
	public LabelBase(String text, String separator) {
		super(text);
		this.separator = separator;
	}

	public void setOptionalLabel() {
		setStyleAttribute(FONT_COLOR, COLOR_BLUE);
	}
	
	public void setRemarkLabel() {
		setStyleAttribute(FONT_COLOR, COLOR_GREEN);
	}

	public void setCompulsoryLabel() {
//		setStyleAttribute(FONT_COLOR, COLOR_RED);
		setStyleAttribute(FONT_COLOR, COLOR_BLUE);
	}

	@Override
	public void setBounds(int x, int y, int width, int height) {
		setPosition(x, y);
	    setSize(width, height);
	}

	public void setLocation(int x, int y) {
		setPosition(x, y);
	}

	public String getText() {
		String ret = null;
		String value = super.getValue().toString();
		if (value == null) {
			ret = ConstantsVariable.EMPTY_VALUE;
		} else {
			if (separator != null) {
				int sLen = separator.length();
				ret = value.substring(0, value.length() - sLen - 1);
			} else {
				ret = value;
			}
		}
		return ret;
	}
	
	public void setText(String text) {
		if (separator != null) {
			super.setValue(text + separator);
		} else {
			super.setValue(text);
		}
	}

	public void resetText() {
		setText(ConstantsVariable.EMPTY_VALUE);
	}

	public void setHorizontalAlignment(String value) {
		setStyleAttribute(TEXT_ALIGN, value);
	}

	public void setAlignmentRight() {
		setHorizontalAlignment(ALIGN_RIGHT);
	}

	public void setAlignmentCenter() {
		setHorizontalAlignment(ALIGN_CENTER);
	}
}