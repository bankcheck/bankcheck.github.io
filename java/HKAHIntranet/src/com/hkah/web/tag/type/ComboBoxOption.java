/*
 * Created on February 8, 2009
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.web.tag.type;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboBoxOption {

	private String value = null;
	private String text = null;

	/**
	 * Constructor for ComboBoxOption.
	 */
	public ComboBoxOption() {
		super();
	}

	public ComboBoxOption(String value, String text) {
		this.value = value;
		this.text = text;
	}

	/**
	 * Returns the text.
	 * @return String
	 */
	public String getText() {
		return text;
	}

	/**
	 * Returns the value.
	 * @return String
	 */
	public String getValue() {
		return value;
	}

	/**
	 * Sets the text.
	 * @param text The text to set
	 */
	public void setText(String text) {
		this.text = text;
	}

	/**
	 * Sets the value.
	 * @param value The value to set
	 */
	public void setValue(String value) {
		this.value = value;
	}
}
