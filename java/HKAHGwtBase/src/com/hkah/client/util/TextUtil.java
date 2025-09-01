/*
 * Created on August 1, 2008
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.util;

import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import com.google.gwt.i18n.client.NumberFormat;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;

/**
 * @author administrator
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class TextUtil implements ConstantsVariable {

	/***************************************************************************
	 * Main Method
	 **************************************************************************/

	@SuppressWarnings("rawtypes")
	public static String combine(List substrings) {
		return combine(substrings, FIELD_DELIMITER);
	}

	public static String combine(String[] substrings) {
		return combine(substrings, FIELD_DELIMITER);
	}

	@SuppressWarnings("rawtypes")
	public static String combine(List substrings, String delimiter) {
		int size = substrings.size();
		String[] tmp = new String[size];

		if (substrings != null) {
			for (int i = 0; i < size; i++) {
				if (substrings.get(i) != null) {
					tmp[i] = substrings.get(i).toString();
				} else {
					tmp[i] = null;
				}
			}
		}

		return combine(tmp, delimiter);
	}

	public static String combine(String[] substrings, String delimiter) {
		StringBuilder result = new StringBuilder();

		if (substrings != null) {
			for (int i = 0; i < substrings.length; i++) {
				if (substrings[i] != null) {
					// trim and append string
					result.append(substrings[i].trim());
				}
				if (!(i == substrings.length -1 && LINE_DELIMITER.equals(substrings[i])))
					result.append(delimiter);
			}
		}

		return result.toString();
	}

	public static String[] split(String query) {
		return split(query, FIELD_DELIMITER);
	}

	public static String[] split(String query, String delimiter) {
		ArrayList<String> result = new ArrayList<String>();
		int index = 0;
		while (true) {
			int pointer = query.indexOf(delimiter, index);
			if (pointer < 0) {
				result.add(query.substring(index, query.length()).trim());
				break;
			} else {
				result.add(query.substring(index, pointer).trim());
				index = pointer + delimiter.length();
			}
			// remove last empty element
			if (pointer == query.length() - delimiter.length()) {
				break;
			}

		}
		return (String[]) result.toArray(new String[0]);
	}

	public static String[] split(String content, int maxLengthPerEach) {
		Vector<String> newContent = new Vector<String>();
		if (content != null) {
			splitHelper(content, newContent, 0, maxLengthPerEach);
			return (String []) newContent.toArray(new String[newContent.size()]);
		} else {
			return null;
		}
	}

	private static void splitHelper(String content, Vector<String> newContent, int index, int maxLengthPerEach) {
		if (content.length() > maxLengthPerEach * (index + 1)) {
			newContent.add(content.substring(maxLengthPerEach * index, maxLengthPerEach * (index + 1)));
			splitHelper(content, newContent, index + 1, maxLengthPerEach);
		} else {
			newContent.add(content.substring(maxLengthPerEach * index));
		}
	}

	/***************************************************************************
	 * Convert Method
	 **************************************************************************/

	public static Vector<String[]> messageQueue2Vector(MessageQueue mQueue) {
		Vector<String[]> vector = new Vector<String[]>();
		if (mQueue.success()) {
			String[] record = split(mQueue.getContentAsQueue(), LINE_DELIMITER);
			for (int i = 0; i < record.length; i++) {
				vector.add(split(record[i]));
			}
		}
		return vector;
	}

	public static HashMap<String, String[]> messageQueue2HashMap(MessageQueue mQueue) {
		HashMap<String, String[]> hashMap = new HashMap<String, String[]>();
		if (mQueue.success()) {
			String[] record = split(mQueue.getContentAsQueue(), LINE_DELIMITER);
			String[] row = null;
			for (int i = 0; i < record.length; i++) {
				row = split(record[i]);
				hashMap.put(row[0], row);
			}
		}
		return hashMap;
	}

	public static Object[] stringArray2ObjectArray(String[] array) {
		Object[] row = null;
		if (array != null) {
			row = new Object[array.length];
			for (int i = 0; i < array.length; i++) {
				if (array[i] != null) {
					row[i] = array[i];
				} else {
					row[i] = ConstantsVariable.EMPTY_VALUE;
				}
			}
		}
		return row;
	}

	public static String stringArrayArray2String(String[][] array) {
		StringBuilder sb = new StringBuilder();

		if (array != null) {
			for (int i = 0; i < array.length; i++) {
				for (int j = 0; j < array[i].length; j++) {
					if (array[i][j] != null && array[i][j].length() > 0) {
						sb.append(trimSpecialChar(array[i][j]).trim());
					}
					sb.append(ConstantsVariable.FIELD_DELIMITER);
				}
				sb.append(ConstantsVariable.LINE_DELIMITER);
			}
		}

		return sb.toString();
	}

	public static Map<String, String> stringArray2Map(String[] str1, String[] str2) {
		if (str1 != null) {
			Map<String, String> map = new HashMap<String, String>();
			for (int i = 0; i < str1.length; i++) {
				map.put(str1[i], str2[i]);
			}
			return map;
		} else {
			return null;
		}
	}

	public static String[] string2StringArray(String str) {
		if (str != null) {
			String [] returnArray = split(str);
			if (returnArray.length == 0) {
				return null;
			} else {
				return returnArray;
			}
		} else {
			return null;
		}
	}

	public static boolean[] string2BooleanArray(String str) {
		if (str != null) {
			String [] returnArray = split(str);
			if (returnArray.length == 0) {
				return null;
			} else {
				boolean[] returnBoolean = new boolean[returnArray.length];
				for (int i = 0; i < returnArray.length; i++) {
					returnBoolean[i] = "TRUE".equals(returnArray[i]);
				}
				return returnBoolean;
			}
		} else {
			return null;
		}
	}
	
	
	public static String booleanArray2String(boolean[] str) {
		if (str != null) {
			String[] returnStr = new String[str.length];
			for (int i = 0; i < str.length; i++) {
				returnStr[i] = str[i]?"TRUE":"FALSE";
			}
			return combine(returnStr);
		} else {
			return null;
		}
	}
	
	public static String boolean2String(boolean str) {
			String returnStr = "";
				returnStr = str?"TRUE":"FALSE";
				
			return returnStr;
	}
	
	
	
	public static String replaceAll(String originalString, String from, String to) {
		StringBuilder result = new StringBuilder();

		if (originalString != null && from != null && to != null) {
			int originalLength = originalString.length();
			int fromLength = from.length();

			for (int i = 0; i < originalString.length(); i++) {
				if (i + fromLength <= originalLength && from.equals(originalString.substring(i, i + fromLength))) {
					result.append(to);
					i += fromLength - 1;
				} else {
					result.append(originalString.charAt(i));
				}
			}
		} else {
			result.append(originalString);
		}

		return result.toString();
	}

	/***************************************************************************
	 * Check Format Method
	 **************************************************************************/

	/*
	 * To check if pass-in string in this object is all digit (only check for digit)
	 */
	public static boolean isAllDigit(String checkString) {

		int index = 0;

		while (index < checkString.length()) {
			if (Character.isDigit(checkString.charAt(index++)) == false)
				return false;
		}
		return true;

	}

	/*
	 * To check if pass-in string in this object is value number (include decimal places)
	 */
	public static boolean isNumber(String checkString) {
		if (checkString != null) {
			try {
				Double.valueOf(checkString);
				return true;
			} catch (Exception e) {
				// exception will be thrown during a string parse to double
			}
		}
		return false;
	}

	public static boolean isFloat(String s) {
		try {
			Float.parseFloat(s);
			return true;
		} catch (Exception e) {}
		return false;
	}

	public static boolean isPositiveInteger(String s) {
		int number = -1;
		try {
			number = Integer.parseInt(s);
			if (number > 0) {
				return true;
			}
		} catch (Exception e) {}
		return false;
	}

	public static boolean isNegativeInteger(String s) {
		int number = -1;
		try {
			number = Integer.parseInt(s);
			if (number <= 0) {
				return true;
			}
		} catch (Exception e) {}
		return false;
	}

	public static boolean isInteger(String s) {
		try {
			Integer.parseInt(s);
			return true;
		} catch (Exception e) {}
		return false;
	}

	/**
	 * @return 0 if equal, > 0 is first > second, < 0 is first < second
	 */
	public static int compareIntegerTo(String s1, String s2) {
		int number1 = -1;
		int number2 = -1;
		try {
			number1 = Integer.parseInt(s1);
		} catch (Exception e) {}
		try {
			number2 = Integer.parseInt(s2);
		} catch (Exception e) {}

		if (number1 != -1 && number2 != -1) {
			if (number1 == number2) {
				return 0;
			} else if (number1 > number2) {
				return 1;
			} else {
				return -1;
			}
		} else {
			return -2;
		}
	}

	/***************************************************************************
	 * Parse Method
	 **************************************************************************/

	/**
	 * to parse string for web
	 * @param value
	 * @return
	 */
	public static String parseStr(String value) {
		if (value != null) {
			return value.trim();
		} else {
			return EMPTY_VALUE;
		}
	}

	/**
	 * to parse string for handle non-western character
	 * @param value
	 * @return
	 */
	public static String parseStrUTF8(String value) {
		if (value != null && value.length() > 0) {
			String newValue = parseStr(value);
			try {
				newValue = new String(newValue.getBytes("ISO-8859-1"), "UTF-8");
			} catch (UnsupportedEncodingException e) {}
			return newValue;
		} else {
			return value;
		}
	}

	/**
	 * to parse string for handle non-western character
	 * @param value
	 * @return
	 */
	public static String parseStrBIG5(String value) {
		value = parseStr(value);
		if (value.length() > 0) {
			try {
				value = new String(value.getBytes("ISO-8859-1"), "BIG5");
			} catch (UnsupportedEncodingException e) {}
		}
		return value;
	}

	/**
	 * to parse string for handle non-western character
	 * @param value
	 * @return
	 */
	public static String parseStrISO(String value) {
		value = parseStr(value);
		if (value.length() > 0) {
			try {
				value = new String(value.getBytes("UTF-8"), "ISO-8859-1");
			} catch (UnsupportedEncodingException e) {}
		}
		return value;
	}

	/**
	 * to parse string for handle name
	 * @param value
	 * @return
	 */
	public static String parseStrName(String value) {
		value = parseStr(value);
		if (value.length() > 0) {
			value = value.substring(0, 1).toUpperCase() + value.substring(1).toLowerCase();
		}
		return value;
	}

	/***************************************************************************
	 * Formatting Method
	 **************************************************************************/

	public static String formatCurrency(String value) {
		double doubleValue = 0;
		try {
			doubleValue = Double.parseDouble(value);
		} catch (Exception e) {}
		return formatCurrency(doubleValue);
	}

	public static String formatCurrency(double value) {
		return NumberFormat.getDecimalFormat().format(value);
	}

	public static String formatColorCurrency(String value) {
		double doubleValue = 0;
		try {
			doubleValue = Double.parseDouble(value);
		} catch (Exception e) {}
		return formatColorCurrency(doubleValue);
	}

	
	public static String formatColorCurrency(double value) {
		if (value < 0) {
			return "<span style='color:red'>" + NumberFormat.getDecimalFormat().format(value) + "</span>";
		} else {
			return "<span style='color:green'>" + NumberFormat.getDecimalFormat().format(value) + "</span>";
		}
	}

	/***************************************************************************
	 * Case Method
	 **************************************************************************/

	/**
	 * change value to upper case and special handle non-western characters
	 * @param value
	 * @return
	 */
	public static String toUpperCase(String value) {
		if (value != null) {
			StringBuilder tmpString = new StringBuilder();
			for (int i = 0; i < value.length(); i++) {
				if (value.charAt(i) >= 'a' && value.charAt(i) <= 'z') {
					tmpString.append(value.substring(i, i + 1).toUpperCase());
				} else {
					tmpString.append(value.charAt(i));
				}
			}
			return tmpString.toString();
		} else {
			return value;
		}
	}
	
	public static boolean isExceedMaxLengthByAscCode(String str, int maxLen) {
		int totalLength = 0; 
		
		for (char s : str.toCharArray()) {
			int sCode = (int)s;
			if (sCode >= 0 && sCode <= 255) {
				totalLength += 1;
			}
			else {
				totalLength += 2;
			}
		}
		
		if (totalLength > maxLen) {
			return true;
		}
		return false;
	}
	
	public static boolean isChinese(String str) {
		for (char s : str.toCharArray()) {
			int sCode = (int)s;
			if ((sCode < 32 || sCode > 126) && sCode != 9 && sCode != 13 && sCode != 10) {
				return true;
			}
		}
		return false;
	}
	
	public static String trimToEmpty(String str) {
		String ret = str;
		if (ret != null) {
			ret = ret.trim();
		} else {
			ret = "";
		}
		return ret;
	}

	public static String trimSpecialChar(String str) {
		// remove no-break whitespace
		str = str.replace('\u00A0',' ').trim();
		str = str.replace('\u2007',' ').trim();
		str = str.replace('\u202F',' ').trim();

		return str;
	}
}