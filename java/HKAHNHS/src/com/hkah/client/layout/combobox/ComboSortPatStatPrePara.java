package com.hkah.client.layout.combobox;

public class ComboSortPatStatPrePara extends ComboBoxBase{

	private final static String PATNO_DISPLAY = "Patient No";
	private final static String NAME_DISPLAY = "Name";
	private final static String CHINAME_DISPLAY = "Chinese Name";
	private final static String DRNAME_DISPLAY = "Dr Name";
	private final static String WARD_DISPLAY = "Ward";
	private final static String SCHDADMDATE_DISPLAY = "Schd Adm Date";
	private final static String EDC_DISPLAY = "EDC Date";
	private final static String BOOKINGNO_DISPLAY = "Booking #";
	private final static String DOCUMENT_DISPLAY = "Document #";
	private final static String CLASS_DISPLAY = "Class";
	private final static String BE_DISPLAY = "*BE";
	private final static String PATNO_VALUE = "PN";
	private final static String NAME_VALUE = "NA";
	private final static String CHINAME_VALUE = "CN";
	private final static String DRNAME_VALUE = "DN";
	private final static String WARD_VALUE = "WD";
	private final static String SCHDADMDATE_VALUE = "SD";
	private final static String EDC_VALUE = "ED";
	private final static String BOOKINGNO_VALUE = "BN";
	private final static String DOCUMENT_VALUE= "DM";
	private final static String CLASS_VALUE= "CL";
	private final static String BE_VALUE= "BE";


	public ComboSortPatStatPrePara() {
		super();
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(PATNO_VALUE, PATNO_DISPLAY);
		addItem(NAME_VALUE, NAME_DISPLAY);
		addItem(CHINAME_VALUE, CHINAME_DISPLAY);
		addItem(DRNAME_VALUE, DRNAME_DISPLAY);
		addItem(WARD_VALUE,WARD_DISPLAY);
		addItem(SCHDADMDATE_VALUE, SCHDADMDATE_DISPLAY);
		addItem(EDC_VALUE, EDC_DISPLAY);
		addItem(BOOKINGNO_VALUE, BOOKINGNO_DISPLAY);
		addItem(DOCUMENT_VALUE, DOCUMENT_DISPLAY);
		addItem(CLASS_VALUE, CLASS_DISPLAY);
		addItem(BE_VALUE, BE_DISPLAY);
		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(4);
	}
}