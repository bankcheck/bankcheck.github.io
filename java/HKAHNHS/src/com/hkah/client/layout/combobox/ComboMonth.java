package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsVariable;

public class ComboMonth extends ComboBoxBase {

	private final static String JANUARY_VALUE   = "January";
	private final static String FEBRUARY_VALUE  = "February";
	private final static String MARCH_VALUE     = "March";
	private final static String APRIL_VALUE     = "April";
	private final static String MAY_VALUE       = "May";
	private final static String JUNE_VALUE      = "June";
	private final static String JULY_VALUE      = "July";
	private final static String AUGUST_VALUE    = "August";
	private final static String SEPTEMBER_VALUE = "September";
	private final static String OCTOBER_VALUE   = "October";
	private final static String NOVEMBER_VALUE  = "November";
	private final static String DECEMBER_VALUE  = "December";

	public ComboMonth() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ConstantsVariable.EMPTY_VALUE, ConstantsVariable.EMPTY_VALUE);
		addItem("01", JANUARY_VALUE);
        addItem("02", FEBRUARY_VALUE);
        addItem("03", MARCH_VALUE);
        addItem("04", APRIL_VALUE);
        addItem("05", MAY_VALUE);
        addItem("06", JUNE_VALUE);
        addItem("07", JULY_VALUE);
        addItem("08", AUGUST_VALUE);
        addItem("09", SEPTEMBER_VALUE);
        addItem("10", OCTOBER_VALUE);
        addItem("11", NOVEMBER_VALUE);
        addItem("12", DECEMBER_VALUE);

        resetText();
	}
}