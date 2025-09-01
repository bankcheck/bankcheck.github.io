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
public class ComboAppSortby extends ComboBoxBase {

	private final static String STARTDATE_DISPLAY = "Start Date/Time";
	private final static String ENDDATE_DISPLAY = "End Date/Time";
	private final static String STATUS_DISPLAY = "Status";
	private final static String PATNO_DISPLAY = "Patient No";
	private final static String PATNAME_DISPLAY = "Patient Name";
	private final static String ROOMSTARTDATE_DISPLAY = "Room and Start Date/Time";
	private final static String PROCCODE_DISPLAY = "Procedure Code";
	private final static String SURGEON_DISPLAY = "Surgeon";
	private final static String ANESTHER_DISPLAY = "Anesthetist";
	private final static String ENDOSCOPIST_DISPLAY = "Endoscopist";
	private final static String PATTYPEDAYCASE_DISPLAY = "Filter by DayCase";
	private final static String STARTDATE_VALUE = "A.OTAOSDATE";
	private final static String ENDDATE_VALUE = "A.OTAOEDATE";
	private final static String STATUS_VALUE = "A.OTASTS";
	private final static String PATNO_VALUE = "A.PATNO";
	private final static String PATNAME_VALUE = "A.OTAFNAME";
	private final static String ROOMSTARTDATE_VALUE = "C.OTCDESC,A.OTAOSDATE";
	private final static String PROCCODE_VALUE = "P.OTPDESC";
	private final static String SURGEON_VALUE = "SD.DOCFNAME";
	private final static String ANESTHER_VALUE = "AD.DOCFNAME";
	private final static String ENDOSCOPIST_VALUE = "ED.DOCFNAME";
	private final static String PATTYPEDAYCASE_VALUE = "DAYCASE";


	public ComboAppSortby() {
		super();
		setMinListWidth(200);
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem( STARTDATE_VALUE,STARTDATE_DISPLAY);
		addItem( ENDDATE_VALUE,ENDDATE_DISPLAY);
		addItem( STATUS_VALUE,STATUS_DISPLAY);
		addItem( PATNO_VALUE,PATNO_DISPLAY);
		addItem( PATNAME_VALUE,PATNAME_DISPLAY);
		addItem( ROOMSTARTDATE_VALUE,ROOMSTARTDATE_DISPLAY);
		addItem( PROCCODE_VALUE,PROCCODE_DISPLAY);
		addItem( SURGEON_VALUE,SURGEON_DISPLAY);
		addItem( ANESTHER_VALUE,ANESTHER_DISPLAY);
		addItem( ENDOSCOPIST_VALUE,ENDOSCOPIST_DISPLAY);
		addItem( PATTYPEDAYCASE_VALUE,PATTYPEDAYCASE_DISPLAY);
		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}