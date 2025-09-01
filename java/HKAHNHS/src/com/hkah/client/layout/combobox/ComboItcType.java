package com.hkah.client.layout.combobox;

public class ComboItcType extends ComboBoxBase {

	private final static String IN_PATIENT_DISPLAY="In_Patient";
	private final static String OUT_PATIENT_DISPLAY="Out_Patient";
	private final static String DAYCASE_DISPLAY="Daycase";
	private final static String IN_PATIENT_VALUE="I";
	private final static String OUT_PATIENT_VALUE="O";
	private final static String DAYCASE_VALUE="D";

	public ComboItcType() {
		super(false);
		initContent();
	}

	public void initContent() {
		// TODO Auto-generated method stub
		removeAllItems();
		addItem(IN_PATIENT_VALUE,IN_PATIENT_DISPLAY);
		addItem(OUT_PATIENT_VALUE,OUT_PATIENT_DISPLAY);
		addItem(DAYCASE_VALUE,DAYCASE_DISPLAY);
	}
}