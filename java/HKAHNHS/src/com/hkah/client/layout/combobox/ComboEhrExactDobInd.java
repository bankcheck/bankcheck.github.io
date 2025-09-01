package com.hkah.client.layout.combobox;

import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.shared.constants.ConstantsVariable;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboEhrExactDobInd extends ComboBoxBase {

	private final static String EDMY_DISPLAY = "EDMY";
	private final static String EMY_DISPLAY = "EMY";
	private final static String EY_DISPLAY = "EY";
	private final static String EDMY_VALUE = "EDMY";
	private final static String EMY_VALUE = "EMY";
	private final static String EY_VALUE = "EY";

	public ComboEhrExactDobInd() {
		super();
		initContent();
	}

	public ComboEhrExactDobInd(TextReadOnly showTextPanel) {
		super(false, showTextPanel);
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ConstantsVariable.EMPTY_VALUE, ConstantsVariable.EMPTY_VALUE);
		addItem(EDMY_VALUE, EDMY_DISPLAY);
		addItem(EMY_VALUE, EMY_DISPLAY);
		addItem(EY_VALUE, EY_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}