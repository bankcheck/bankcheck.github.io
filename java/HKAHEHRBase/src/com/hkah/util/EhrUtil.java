package com.hkah.util;

public class EhrUtil {
	public static String convertToEngFullName(String engSurname, String engGivenName) {
		String engFullName = null;
		
		if (engSurname != null) {
			engFullName = engSurname;
		}
		if (engGivenName != null) {
			if (engFullName != null) {
				engFullName += ", ";
			} else {
				engFullName = "";
			}
			engFullName += engGivenName;
		}
		return engFullName;
	}
}
