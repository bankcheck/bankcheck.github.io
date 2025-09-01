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
public class BLogSortby extends ComboBoxBase {

	private final static String BBPATNO_DISPLAY = "BB PatNo";
	private final static String MPATNO_DISPLAY = "Mother PatNo";
	private final static String BBDOB_DISPLAY = "BB D.O.B";
	private final static String BATCHNO_DISPLAY = "Batch No";
	private final static String BRETURNNO_DISPLAY = "Birth Return No";
	private final static String STATUS_DISPLAY = "Status";
	private final static String BBPATNO_VALUE = "BB_PATNO";
	private final static String MPATNO_VALUE = "MO_PATNO";
	private final static String BBDOB_VALUE = "BB_DOB";
	private final static String BATCHNO_VALUE = "BATCHNO";
	private final static String BRETURNNO_VALUE = "BIRTHRETURNNO";
	private final static String STATUS_VALUE = "RECSTATUS";

	public BLogSortby() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ConstantsVariable.EMPTY_VALUE, ConstantsVariable.EMPTY_VALUE);
		addItem(BBPATNO_VALUE, BBPATNO_DISPLAY);
		addItem(MPATNO_VALUE, MPATNO_DISPLAY);
		addItem(BBDOB_VALUE, BBDOB_DISPLAY);
		addItem(BATCHNO_VALUE, BATCHNO_DISPLAY);
		addItem(BRETURNNO_VALUE, BRETURNNO_DISPLAY);
		addItem(STATUS_VALUE, STATUS_DISPLAY);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(BBDOB_VALUE);
	}
}