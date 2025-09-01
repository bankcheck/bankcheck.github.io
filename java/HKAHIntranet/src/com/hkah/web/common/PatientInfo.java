package com.hkah.web.common;

import java.util.HashMap;

public class PatientInfo {
	
	private static HashMap<String, String> keyIsChar = new HashMap<String, String>();
	private static HashMap<String, String> keyIsNum = new HashMap<String, String>();
	public final static String MINUS_VALUE = "-";
	public final static String DOT_VALUE = ".";
	public final static String SPACE_VALUE = " ";
	public final static String DOLLORSIGN_VALUE = "$";
	public final static String SLASH_VALUE = "/";
	public final static String PLUS_VALUE = "+";
	public final static String PERCENTAGE_VALUE = "%";
	public final static String ZERO_VALUE = "0";
	/***************************************************************************
	 * Generate Check Digit Methods
	 **************************************************************************/

	public static void initMaps() {
		for (int i = 0; i < 10; i++) {
			keyIsNum.put(Integer.toString(i), Integer.toString(i));
		}
		int temp = 10;
		for (int i = 65; i < 91; i++) {
			keyIsNum.put(Integer.toString(temp),
					new Character((char) i).toString());
			temp++;
		}
		keyIsNum.put("36", MINUS_VALUE);
		keyIsNum.put("37", DOT_VALUE);
		keyIsNum.put("38", SPACE_VALUE);
		keyIsNum.put("39", DOLLORSIGN_VALUE);
		keyIsNum.put("40", SLASH_VALUE);
		keyIsNum.put("41", PLUS_VALUE);
		keyIsNum.put("42", PERCENTAGE_VALUE);

		for (int i = 0; i < 10; i++) {
			keyIsChar.put(Integer.toString(i), Integer.toString(i));
		}
		temp = 10;
		for (int i = 65; i < 91; i++) {
			keyIsChar.put(new Character((char) i).toString(),
					Integer.toString(temp));
			temp++;
		}
		keyIsChar.put(MINUS_VALUE, "36");
		keyIsChar.put(DOT_VALUE, "37");
		keyIsChar.put(SPACE_VALUE, "38");
		keyIsChar.put(DOLLORSIGN_VALUE, "39");
		keyIsChar.put(SLASH_VALUE, "40");
		keyIsChar.put(PLUS_VALUE, "41");
		keyIsChar.put(PERCENTAGE_VALUE, "42");
	}

	public static String getKeyIsChar(String sKey) {
		if (keyIsChar.containsKey(sKey.toUpperCase())) {
			return keyIsChar.get(sKey.toUpperCase());
		} else {
			return ZERO_VALUE;
		}
	}

	public static String getKeyIsNum(String sKey) {
		if (keyIsNum.containsKey(sKey.toUpperCase())) {
			return keyIsNum.get(sKey.toUpperCase());
		} else {
			return ZERO_VALUE;
		}
	}

	public static String generateCheckDigit(String patNo) {
		initMaps();

		int calPatNo = 0;
		int iCount = 0;

		for (int i = 0; i < patNo.length(); i++) {
			String tempChar = String.valueOf(patNo.charAt(i));
			iCount += Integer.parseInt(getKeyIsChar(tempChar));
		}
		calPatNo = iCount % 43;

		return getKeyIsNum(Integer.toString(calPatNo));
	}
	
}