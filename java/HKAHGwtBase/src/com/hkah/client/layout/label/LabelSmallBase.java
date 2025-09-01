package com.hkah.client.layout.label;

public class LabelSmallBase extends LabelBase {

	private static final String FONT_LABEL = "font-size";
	private static final String FONT_SIZE = "11";

	public LabelSmallBase() {
		super();
		setStyleAttribute(FONT_LABEL, FONT_SIZE);
	}

	public LabelSmallBase(String text) {
		super(text);
		setStyleAttribute(FONT_LABEL, FONT_SIZE);
	}
}