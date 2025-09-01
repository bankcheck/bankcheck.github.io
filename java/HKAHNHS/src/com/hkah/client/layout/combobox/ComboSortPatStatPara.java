package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsVariable;

public class ComboSortPatStatPara extends ComboBoxBase{

	private final static String PATNO_DISPLAY = "Patient No";
	private final static String SURNAME_DISPLAY = "SurName";
	private final static String GIVENNAME_DISPLAY = "GivenName";
	private final static String WARD_DISPLAY = "Ward";
	private final static String DRNAME_DISPLAY = "DrName";
	private final static String ADMFROM_DISPLAY = "Admission From(Reg.Date)";
	private final static String BEDCODE_DISPLAY = "Bed Code";
	private final static String CLASS_DISPLAY = "Class";
	private final static String PATNO_VALUE = "PN";
	private final static String SURNAME_VALUE = "SN";
	private final static String GIVENNAME_VALUE = "GN";
	private final static String WARD_VALUE = "WD";
	private final static String DRNAME_VALUE = "DN";
	private final static String ADMFROM_VALUE = "AF";
	private final static String BEDCODE_VALUE = "BC";
	private final static String CLASS_VALUE = "CL";

	public ComboSortPatStatPara() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ConstantsVariable.EMPTY_VALUE,ConstantsVariable.EMPTY_VALUE);
		addItem(PATNO_VALUE, PATNO_DISPLAY);
		addItem(SURNAME_VALUE, SURNAME_DISPLAY);
		addItem(GIVENNAME_VALUE, GIVENNAME_DISPLAY);
		addItem(WARD_VALUE, WARD_DISPLAY);
		addItem(DRNAME_VALUE, DRNAME_DISPLAY);
		addItem(ADMFROM_VALUE, ADMFROM_DISPLAY);
		addItem(BEDCODE_VALUE, BEDCODE_DISPLAY);
		addItem(CLASS_VALUE, CLASS_DISPLAY);


		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setText(ConstantsVariable.EMPTY_VALUE);
	}
}