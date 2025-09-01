package com.hkah.client.layout.combobox;


/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboDeptAppSortBy extends ComboBoxBase {

	private final static String STARTDATE_DISPLAY = "Start Date/Time";
	private final static String ENDDATE_DISPLAY = "End Date/Time";
	private final static String STATUS_DISPLAY = "Status";
	private final static String PATNO_DISPLAY = "Patient No";
	private final static String PATNAME_DISPLAY = "Patient Name";
	private final static String ROOMSTARTDATE_DISPLAY = "Room and Start Date/Time";
	private final static String PROCCODE_DISPLAY = "Procedure Code";
	private final static String STARTDATE_VALUE = "A.DEPTAOSDATE";
	private final static String ENDDATE_VALUE = "A.DEPTAOEDATE";
	private final static String STATUS_VALUE = "A.DEPTASTS";
	private final static String PATNO_VALUE = "A.PATNO";
	private final static String PATNAME_VALUE = "A.DEPTAFNAME";
	private final static String ROOMSTARTDATE_VALUE = "C.DEPTCDESC,A.DEPTAOSDATE";
	private final static String PROCCODE_VALUE = "P.DEPTPDESC";

	public ComboDeptAppSortBy() {
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

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}