package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

public class ComboHealthExamCoverage extends ComboBoxBase {
	private final static String NOTCOVERED_DISPLAY = "CANNOT BILL";
	private final static String NOTCOVERED_VALUE = "CANNOT BILL";
	private final static String COVERED_DISPLAY = "CAN BILL";
	private final static String COVERED_VALUE = "CAN BILL";		
	
	public ComboHealthExamCoverage() {
		super(false);
		initContent();
	}
/*
	public void initContent() {
		// allow blank
		setShowClearButton(false);
		setAllowBlank(true);

		// initial combobox
		resetContent(ConstantsTx.HEALTHEXAMCOVERAGE_TXCODE, false, true);
		resetText();
	}
*/	
	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem( COVERED_VALUE,COVERED_DISPLAY);		
		addItem( NOTCOVERED_VALUE,NOTCOVERED_DISPLAY);
		resetText();
	}	
}
