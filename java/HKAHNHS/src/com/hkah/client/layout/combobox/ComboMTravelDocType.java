package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsVariable;

public class ComboMTravelDocType extends ComboBoxBase {

	private final static String DISPLAY_1 = "1";
	private final static String DISPLAY_2 = "2";
	private final static String DISPLAY_3 = "3";
	private final static String DISPLAY_4 = "4";
	private final static String DISPLAY_5 = "5";
	private final static String DISPLAY_6 = "6";
	private final static String DISPLAY_7 = "7";
	private final static String DISPLAY_8 = "8";
	private final static String DISPLAY_9 = "9";
	private final static String DISPLAY_A = "A";
	private final static String DISPLAY_B = "B";
	private final static String DISPLAY_C = "C";
	private final static String DISPLAY_D = "D";
	private final static String DISPLAY_E = "E";
	private final static String DISPLAY_G = "G";
	private final static String DISPLAY_H = "H";
	private final static String DISPLAY_I = "I";
	private final static String DISPLAY_J = "J";
	private final static String DISPLAY_K = "K";
	private final static String DISPLAY_L = "L";
	private final static String DISPLAY_M = "M";
	private final static String DISPLAY_N = "N";
	private final static String DISPLAY_Y = "Y";
	private final static String DISPLAY_Z = "Z";

	private final static String VALUE_1 = "(AO) Certificate of Entitlement to the Right of Abode in the HKSAR";
	private final static String VALUE_2 = "(AR) Adopted Children Register (include those issued by HKSAR and non-HKSAR government authorities)";
	private final static String VALUE_3 = "(BC) Hong Kong Birth Certificate";
	private final static String VALUE_4 = "(CI) Hong Kong Certificate of Identity";
	private final static String VALUE_5 = "(CS) Documents issued by HKSAR Correctional Services Department";
	private final static String VALUE_6 = "(DI) Hong Kong Document of Identity";
	private final static String VALUE_7 = "(EC) Exemption Certificate";
	private final static String VALUE_8 = "(EN) Hong Kong Entry Permit";
	private final static String VALUE_9 = "(ID) Hong Kong Identity Card";
	private final static String VALUE_A = "(NA) No identity document";
	private final static String VALUE_B = "(OB) Birth Certificate issued by non-HKSAR government authority";
	private final static String VALUE_C = "(OC) Other identity/travel documents issued by the People Republic of China government /authorising agent";
	private final static String VALUE_D = "(OI) Other documents issued by HKSAR Immigration Department";
	private final static String VALUE_E = "(OP) Other travel documents issued by non-PRC government/authorising agent";
	private final static String VALUE_G = "(OW) One-way Permit";
	private final static String VALUE_H = "(PD) Documents issued by the Police Department";
	private final static String VALUE_I = "(PS) HKSAR Passport";
	private final static String VALUE_J = "(RE) Recognizance";
	private final static String VALUE_K = "(RP) Re-entry Permit";
	private final static String VALUE_L = "(TW) Two-way Permit";
	private final static String VALUE_M = "(CU) Documents issued by HKSAR Custom & Excise Department";
	private final static String VALUE_N = "(OH) Travel document issued by the People Republic of China government/authorising agent to HK residents";
	private final static String VALUE_Y = "(PC) [Type of Identity Document] for episodes registered prior to the implementation date";
	private final static String VALUE_Z = "(AU) Automatic Generated";

	public ComboMTravelDocType() {
		super(true);
		initContent();
	}

	public void initContent() {
		// initial combobox
		removeAllItems();
		addItem(ConstantsVariable.EMPTY_VALUE,ConstantsVariable.EMPTY_VALUE);
		addItem(DISPLAY_1, VALUE_1);
		addItem(DISPLAY_2, VALUE_2);
		addItem(DISPLAY_3, VALUE_3);
		addItem(DISPLAY_4, VALUE_4);
		addItem(DISPLAY_5, VALUE_5);
		addItem(DISPLAY_6, VALUE_6);
		addItem(DISPLAY_7, VALUE_7);
		addItem(DISPLAY_8, VALUE_8);
		addItem(DISPLAY_9, VALUE_9);
		addItem(DISPLAY_A, VALUE_A);
		addItem(DISPLAY_B, VALUE_B);
		addItem(DISPLAY_C, VALUE_C);
		addItem(DISPLAY_D, VALUE_D);
		addItem(DISPLAY_E, VALUE_E);
		addItem(DISPLAY_G, VALUE_G);
		addItem(DISPLAY_H, VALUE_H);
		addItem(DISPLAY_I, VALUE_I);
		addItem(DISPLAY_J, VALUE_J);
		addItem(DISPLAY_K, VALUE_K);
		addItem(DISPLAY_L, VALUE_L);
		addItem(DISPLAY_M, VALUE_M);
		addItem(DISPLAY_N, VALUE_N);
		addItem(DISPLAY_Y, VALUE_Y);
		addItem(DISPLAY_Z, VALUE_Z);

		resetText();
	}

	@Override
	public void resetText() {
		super.resetText();
		setSelectedIndex(0);
	}
}