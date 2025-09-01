/*
 * Created on August 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsVariable;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboOTRoom extends ComboBoxBase {

	private final static String OR1_DISPLAY = "OR 1";
	private final static String OR2_DISPLAY = "OR 2";
	private final static String OR3_DISPLAY = "OR 3";
	private final static String CATHLAB1_DISPLAY = "CATH LAB 1";
	private final static String ENDOSCOPYROOI_DISPLAY = "ENDOSCOPY ROOI";
	private final static String MOBILEPROCEDU_DISPLAY = "MOBILE PROEDU";
	private final static String OR1_VALUE = "OR1";
	private final static String OR2_VALUE = "OR2";
	private final static String OR3_VALUE = "OR3";
	private final static String CATHLAB1_VALUE = "CL1";
	private final static String ENDOSCOPYROOI_VALUE = "ERI";
	private final static String MOBILEPROCEDU_VALUE = "MPU";

	public ComboOTRoom() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ConstantsVariable.EMPTY_VALUE, ConstantsVariable.EMPTY_VALUE);
		addItem(OR1_VALUE, OR1_DISPLAY);
		addItem(OR2_VALUE, OR2_DISPLAY);
		addItem(OR3_VALUE, OR3_DISPLAY);
		addItem(CATHLAB1_VALUE, CATHLAB1_DISPLAY);
		addItem(ENDOSCOPYROOI_VALUE, ENDOSCOPYROOI_DISPLAY);
		addItem(MOBILEPROCEDU_VALUE, MOBILEPROCEDU_DISPLAY);
	}
}