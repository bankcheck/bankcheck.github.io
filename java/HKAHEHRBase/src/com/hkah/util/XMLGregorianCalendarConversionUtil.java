/**
 * Copy from https://gist.github.com/musubu/2552948
 */
package com.hkah.util;

import javax.xml.datatype.DatatypeConfigurationException;
import javax.xml.datatype.DatatypeFactory;
import javax.xml.datatype.XMLGregorianCalendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.TimeZone;

public class XMLGregorianCalendarConversionUtil {
	private static DatatypeFactory datatypeFactory = null;

	static {
		try {
			datatypeFactory = DatatypeFactory.newInstance();
		} catch (DatatypeConfigurationException e) {
			throw new IllegalStateException(
					"Error while trying to obtain a new instance of DatatypeFactory",
					e);
		}
	}

	public static XMLGregorianCalendar asXMLGregorianCalendar(Date date) {
		if (date == null) {
			return null;
		} else {
			GregorianCalendar gregorianCalendar = new GregorianCalendar();
			gregorianCalendar.setTimeInMillis(date.getTime());
			gregorianCalendar.setTimeZone(TimeZone.getTimeZone("UTC"));
			return datatypeFactory.newXMLGregorianCalendar(gregorianCalendar);
		}
	}

	public static Date asDate(XMLGregorianCalendar xmlGregorianCalendar) {
		if (xmlGregorianCalendar == null) {
			return null;
		} else {
			return xmlGregorianCalendar.toGregorianCalendar().getTime();
		}
	}
}