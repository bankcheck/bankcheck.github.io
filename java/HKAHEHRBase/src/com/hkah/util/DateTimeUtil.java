/*
 * Created on July 4, 2008
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.util;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

import javax.xml.datatype.DatatypeConfigurationException;
import javax.xml.datatype.DatatypeFactory;
import javax.xml.datatype.XMLGregorianCalendar;

import com.hkah.constant.ConstantsVariable;

/**
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class DateTimeUtil {
	private final static String FORMAT_HATS_DATETIME = "EEE dd-MMM-yyyy HH:mm:ss";
	private final static String FORMAT_DISPLAY_DATETIME = "dd/MM/yyyy HH:mm:ss";
	private final static String FORMAT_DISPLAY_DATETIME_WITHOUT_SECOND = "dd/MM/yyyy HH:mm";
	private final static String FORMAT_DISPLAY_DATE = "dd/MM/yyyy";
	private final static String FORMAT_DISPLAY_DATE_REVERSE = "yyyy/MM/dd";
	private final static String FORMAT_DISPLAY_DBDATE = "ddMMyyyy";
	private final static String FORMAT_DISPLAY_DBTIMESTAMPE = "yyyyMMddHHmmss";
	private final static String FORMAT_DISPLAY_TIME = "HH:mm:ss";
	private final static String FORMAT_DATETIME = "yyyy/MM/dd HH:mm:ss";
	private final static String FORMAT_EHR_DATETIME = "yyyy-MM-dd HH:mm:ss.sss";
	private final static String FORMAT_EHR_DOB_EDMY = "dd-MMM-yyyy";
	private final static String FORMAT_EHR_DOB_EMY = "MMM-yyyy";
	private final static String FORMAT_EHR_DOB_EY = "yyyy";
	
	public final static String DB_DISPLAY_DATE = "DD/MM/YYYY";
	public final static String DB_DISPLAY_DATETIME = "DD/MM/YYYY HH24:MI:SS";
	public final static String DB_EHR_DATETIME_NO_MILLISEC = "YYYY-MM-DD HH24:MI:SS";
	public final static String DB_EHR_DATE_SIMPLE = "YYYYMMDD";

	private final static SimpleDateFormat HATSDateTimeFormat = new SimpleDateFormat(FORMAT_HATS_DATETIME);
	private final static SimpleDateFormat displayDateTimeFormat = new SimpleDateFormat(FORMAT_DISPLAY_DATETIME);
	private final static SimpleDateFormat displayDateTimeFormatWithoutSecond = new SimpleDateFormat(FORMAT_DISPLAY_DATETIME_WITHOUT_SECOND);
	private final static SimpleDateFormat displayDateFormat = new SimpleDateFormat(FORMAT_DISPLAY_DATE);
	private final static SimpleDateFormat displayDateFormatReverse = new SimpleDateFormat(FORMAT_DISPLAY_DATE_REVERSE);
	private final static SimpleDateFormat displayDBDateFormat = new SimpleDateFormat(FORMAT_DISPLAY_DBDATE);
	private final static SimpleDateFormat displayDBTimestampFormat = new SimpleDateFormat(FORMAT_DISPLAY_DBTIMESTAMPE);
	private final static SimpleDateFormat displayTimeFormat = new SimpleDateFormat(FORMAT_DISPLAY_TIME);
	private final static SimpleDateFormat dateTimeFormat = new SimpleDateFormat(FORMAT_DATETIME);
	private final static SimpleDateFormat ehrDateTimeFormat = new SimpleDateFormat(FORMAT_EHR_DATETIME);
	private final static SimpleDateFormat ehrDobEdmyFormat = new SimpleDateFormat(FORMAT_EHR_DOB_EDMY);
	private final static SimpleDateFormat ehrDobEmyFormat = new SimpleDateFormat(FORMAT_EHR_DOB_EMY);
	private final static SimpleDateFormat ehrDobEyFormat = new SimpleDateFormat(FORMAT_EHR_DOB_EY);

	static {
		HATSDateTimeFormat.setLenient(false);
		displayDateTimeFormat.setLenient(false);
		displayDateTimeFormatWithoutSecond.setLenient(false);
		displayDateFormat.setLenient(false);
		displayDateFormatReverse.setLenient(false);
		displayTimeFormat.setLenient(false);
		dateTimeFormat.setLenient(false);
		ehrDateTimeFormat.setLenient(false);
		ehrDobEdmyFormat.setLenient(false);
		ehrDobEmyFormat.setLenient(false);
		ehrDobEyFormat.setLenient(false);
	}

	public static Date parseHATSDateTime(String dateTime) {
		try {
			return HATSDateTimeFormat.parse(dateTime);
		} catch (Exception ex) {
			return null;
		}
	}

	public static String formatHATSDateTime(Date date) {
		try {
			return HATSDateTimeFormat.format(date);
		} catch (Exception ex) {
			return null;
		}
	}

	public static Date parseDateTime(String dateTime) {
		try {
			return displayDateTimeFormat.parse(dateTime);
		} catch (Exception ex) {
			return null;
		}
	}

	public static String formatDateTime(Date date) {
		try {
			return displayDateTimeFormat.format(date);
		} catch (Exception ex) {
			return null;
		}
	}

	public static String formatDateTimeStandard(Date date) {
		try {
			return dateTimeFormat.format(date);
		} catch (Exception ex) {
			return null;
		}
	}

	public static Date parseDateTimeWithoutSecond(String dateTime) {
		try {
			return displayDateTimeFormatWithoutSecond.parse(dateTime);
		} catch (Exception ex) {
			return null;
		}
	}

	public static String formatDateTimeWithoutSecond(Date date) {
		try {
			return displayDateTimeFormatWithoutSecond.format(date);
		} catch (Exception ex) {
			return null;
		}
	}

	public static Date parseDate(String date) {
		try {
			return displayDateFormat.parse(date);
		} catch (Exception ex) {
			return null;
		}
	}

	public static Date parseDBTimestamp(String date) {
		try {
			return displayDBTimestampFormat.parse(date);
		} catch (Exception ex) {
			return null;
		}
	}

	public static String formatDate(Date date) {
		try {
			return displayDateFormat.format(date);
		} catch (Exception ex) {
			return null;
		}
	}

	public static Date parseDateReverse(String date) {
		try {
			return displayDateFormatReverse.parse(date);
		} catch (Exception ex) {
			return null;
		}
	}

	public static String formatDateReverse(Date date) {
		try {
			return displayDateFormatReverse.format(date);
		} catch (Exception ex) {
			return null;
		}
	}
	
	public static Date parseTime(String time) {
		try {
			return displayTimeFormat.parse(time);
		} catch (Exception ex) {
			return null;
		}
	}

	public static String formatTime(Date time) {
		try {
			return displayTimeFormat.format(time);
		} catch (Exception ex) {
			return null;
		}
	}

	public static String formatDBDate(Date date) {
		try {
			return displayDBDateFormat.format(date);
		} catch (Exception ex) {
			return null;
		}
	}
	
	public static String formatDBTimestamp(Date date) {
		try {
			return displayDBTimestampFormat.format(date);
		} catch (Exception ex) {
			return null;
		}
	}
	
	public static Date parseEhrDateTime(String time) {
		try {
			return ehrDateTimeFormat.parse(time);
		} catch (Exception ex) {
			return null;
		}
	}
	
	public static String formatEhrDateTime(Date date) {
		try {
			return ehrDateTimeFormat.format(date);
		} catch (Exception ex) {
			return null;
		}
	}

	public static Date parseEhrDobEdmy(String time) {
		try {
			return ehrDobEdmyFormat.parse(time);
		} catch (Exception ex) {
			return null;
		}
	}
	
	public static String formatEhrDobEdmy(Date date) {
		try {
			return ehrDobEdmyFormat.format(date);
		} catch (Exception ex) {
			return null;
		}
	}
	
	public static Date parseEhrDobEmy(String time) {
		try {
			return ehrDobEmyFormat.parse(time);
		} catch (Exception ex) {
			return null;
		}
	}
	
	public static String formatEhrDobEmy(Date date) {
		try {
			return ehrDobEmyFormat.format(date);
		} catch (Exception ex) {
			return null;
		}
	}
	
	public static Date parseEhrDobEy(String time) {
		try {
			return ehrDobEyFormat.parse(time);
		} catch (Exception ex) {
			return null;
		}
	}
	
	public static String formatEhrDobEy(Date date) {
		try {
			return ehrDobEyFormat.format(date);
		} catch (Exception ex) {
			return null;
		}
	}

	/**
	 * Returns current date in format
	 */
	public static String getCurrentDate() {
		return formatDate(new Date());
	}

	/**
	 * Returns current time in format
	 */
	public static String getCurrentTime() {
		return formatTime(new Date());
	}

	/**
	 * Returns current date and time in format
	 */
	public static String getCurrentDateTime() {
		return formatDateTime(new Date());
	}


	/**
	 * Returns current date in format
	 */
	public static String getCurrentDateTimeStandard() {
		return formatDateTimeStandard(new Date());
	}

	/**
	 * Returns current date in format
	 */
	public static String getCurrentDateTimeWithoutSecond() {
		return formatDateTimeWithoutSecond(new Date());
	}

	/**
	 * Returns Date field in daily used format
	 */
	public static int getCurrentDay() {
		return getCurrentDay(null);
	}

	public static int getCurrentDay(Date date) {
		Calendar calendar = Calendar.getInstance();
		if (date != null) {
			calendar.setTime(date);
		}
		return calendar.get(Calendar.DATE);
	}

	/**
	 * Returns the Month field in daily used format
	 */
	public static int getCurrentMonth() {
		return getCurrentMonth(null);
	}

	public static int getCurrentMonth(Date date) {
		Calendar calendar = Calendar.getInstance();
		if (date != null) {
			calendar.setTime(date);
		}
		return calendar.get(Calendar.MONTH) + 1;
	}

	/**
	 * Returns the Year in daily used format
	 */
	public static int getCurrentYear() {
		return getCurrentYear(null);
	}

	public static int getCurrentYear(Date date) {
		Calendar calendar = Calendar.getInstance();
		if (date != null) {
			calendar.setTime(date);
		}
		return calendar.get(Calendar.YEAR);
	}

	/**
	 * Returns the Hour in daily used format
	 */
	public static int getCurrentHour() {
		return getCurrentHour(null);
	}

	public static int getCurrentHour(Date date) {
		Calendar calendar = Calendar.getInstance();
		if (date != null) {
			calendar.setTime(date);
		}
		return calendar.get(Calendar.HOUR_OF_DAY);
	}

	/**
	 * return current week range
	 */
	public static String[] getCurrentWeekRange() {
		Calendar calendar = Calendar.getInstance();
		int dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);
		// roll to sunday
		calendar.add(Calendar.DAY_OF_YEAR, 1 - dayOfWeek);
		String[] returnDateRange = new String[2];
		returnDateRange[0] = formatDate(calendar.getTime());
		// roll to saturday
		calendar.add(Calendar.DAY_OF_YEAR, 6);
		returnDateRange[1] = formatDate(calendar.getTime());
		return returnDateRange;
	}

	/**
	 * return current month range
	 */
	public static String[] getCurrentMonthRange() {
		Calendar calendar = Calendar.getInstance();
		calendar.set(Calendar.DATE, 1);
		String[] returnDateRange = new String[2];
		returnDateRange[0] = formatDate(calendar.getTime());
		// get the last day of this month
		calendar.add(Calendar.MONTH, 1);
		calendar.add(Calendar.DAY_OF_YEAR, -1);
		returnDateRange[1] = formatDate(calendar.getTime());
		return returnDateRange;
	}

	/**
	 * return current year range
	 */
	public static String[] getCurrentYearRange() {
		return getYearRange(0);
	}
	
	public static String[] getLastYearRange() {
		return getYearRange(-1);
	}
	public static String[] getNextYearRange() {
		return getYearRange(1);
	}
	
	public static String[] getYearRange(int offset) {
		int yy = getCurrentYear() + offset;
		String[] returnDateRange = new String[2];
		returnDateRange[0] = "01/01/" + yy;
		returnDateRange[1] = "31/12/" + yy;
		return returnDateRange;
	}

	public static String getRollDate(int day, int month, int year) {
		return getRollDate(Calendar.getInstance().getTime(), day, month, year);
	}

	public static String getRollDate(String date, int day, int month, int year) {
		return getRollDate(parseDate(date), day, month, year);
	}

	public static String getRollDate(Date date, int day, int month, int year) {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(date);

		try {
			calendar.add(Calendar.DATE, day);
			calendar.add(Calendar.MONTH, month);
			calendar.add(Calendar.YEAR, year);
			return formatDate(calendar.getTime());
		} catch (Exception ex) {
			return null;
		}
	}

	/**
	 * @return 0 if equal, 1 is first > second, -1 is first < second
	 */
	public static int compareTo(String firstDate, String secondDate) {
		if (firstDate != null && firstDate.length() == 10 && secondDate != null && secondDate.length() == 10) {
			if (!firstDate.equals(secondDate)) {
				String parseFirstDate = date4Compare(firstDate);
				String parseSecondDate = date4Compare(secondDate);
				return parseFirstDate.compareTo(parseSecondDate);
			} else {
				return 0;
			}
		} else {
			return 0;
		}
	}

	public static String date4Compare(String date) {
		return date4Compare(date, false);
	}

	public static String date4Compare(String date, boolean withDelimiter) {
		if (date != null && date.length() == 10) {
			StringBuffer sb = new StringBuffer();
			sb.append(date.substring(6));
			if (withDelimiter) sb.append(ConstantsVariable.MINUS_VALUE);
			sb.append(date.substring(3, 5));
			if (withDelimiter) sb.append(ConstantsVariable.MINUS_VALUE);
			sb.append(date.substring(0, 2));
			return sb.toString();
		} else {
			return date;
		}
	}
}