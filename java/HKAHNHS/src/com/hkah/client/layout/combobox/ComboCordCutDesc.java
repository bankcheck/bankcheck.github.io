/*
 * Created on August 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboCordCutDesc extends ComboBoxBase {

	private final static String ONE_DISPLAY = "Alive";
	private final static String TWO_DISPLAY = "Neo-natal death";
	private final static String ONE_VALUE = "1";
	private final static String TWO_VALUE = "2";

	public ComboCordCutDesc() {
		super(false);
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ONE_VALUE, ONE_DISPLAY);
		addItem(TWO_VALUE, TWO_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}