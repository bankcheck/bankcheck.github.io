/*
 * Created on August 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;


public class ComboOTCType extends ComboBoxBase {

	private final static String AM_DISPLAY = "Anesthetic Method";
	private final static String AM_VALUE = "AM";
	private final static String BT_DISPLAY = "Blood Type";
	private final static String BT_VALUE = "BT";
	private final static String DR_DISPLAY = "Dressing";
	private final static String DR_VALUE = "DR";
	private final static String DG_DISPLAY = "Drug";
	private final static String DG_VALUE = "DG";
	private final static String EQ_DISPLAY = "Equipment";
	private final static String EQ_VALUE = "EQ";
	private final static String FN_DISPLAY = "Function";
	private final static String FN_VALUE = "FN";	
	private final static String IM_DISPLAY = "Implant";
	private final static String IM_VALUE = "IM";
	private final static String IN_DISPLAY = "Instrument";
	private final static String IN_VALUE = "IN";
	private final static String OC_DISPLAY = "Outcome";
	private final static String OC_VALUE = "OC";
	private final static String RL_DISPLAY = "Reason for late";
	private final static String RL_VALUE = "RL";
	private final static String RM_DISPLAY = "OT Room";
	private final static String RM_VALUE = "RM";
	private final static String RN_DISPLAY = "Reason";
	private final static String RN_VALUE = "RN";
	private final static String SF_DISPLAY = "OT Staff";
	private final static String SF_VALUE = "SF";
	private final static String SD_DISPLAY = "Specimen Destination";
	private final static String SD_VALUE = "SD";
	private final static String ST_DISPLAY = "Schedule Type";
	private final static String ST_VALUE = "ST";
	

	public ComboOTCType() {
		super(true);
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem( AM_VALUE,AM_DISPLAY );
		addItem( BT_VALUE,BT_DISPLAY );
		addItem( DR_VALUE,DR_DISPLAY );
		addItem( DG_VALUE,DG_DISPLAY );
		addItem( EQ_VALUE,EQ_DISPLAY );
		addItem( FN_VALUE,FN_DISPLAY );
		addItem( IM_VALUE,IM_DISPLAY );
		addItem( IN_VALUE,IN_DISPLAY );
		addItem( OC_VALUE,OC_DISPLAY );
		addItem( RL_VALUE,RL_DISPLAY );
		addItem( RM_VALUE,RM_DISPLAY );
		addItem( RN_VALUE,RN_DISPLAY );
		addItem( SF_VALUE,SF_DISPLAY );		
		addItem( ST_VALUE,ST_DISPLAY );
		addItem( SD_VALUE,SD_DISPLAY );

		resetText();
	}
}