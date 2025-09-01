package com.hkah.client.util;

import com.hkah.shared.constants.ConstantsVariable;

public class TableUtil implements ConstantsVariable {

	public static String getName2ID(String columnName) {
		Integer colid = new Integer(0);
		StringBuilder columnID = new StringBuilder();
		if (columnName != null) {
			if (!"".equals(columnName.trim())) {
				// skip special character
				columnName = TextUtil.replaceAll(columnName, DOT_VALUE, SPACE_VALUE);
				// remove space
				String[] word = TextUtil.split(columnName, SPACE_VALUE);
				String temp = null;
				for (int i = 0; i < word.length; i++) {
					temp = word[i].trim();
					if (temp.length() > 0) {
						if (i == 0) {
							columnID.append(temp.substring(0, 1).toLowerCase());
						} else {
							columnID.append(temp.substring(0, 1).toUpperCase());
						}
						columnID.append(temp.substring(1).toLowerCase());
					}
				}
			} else {
				colid = colid + 1;
				columnID = new StringBuilder(colid.toString());
			}
		}
		return columnID.toString();
	}
}