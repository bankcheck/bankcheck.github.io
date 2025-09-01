/*
 * Created on July 4, 2008
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.util;

import java.util.Date;

import com.extjs.gxt.ui.client.util.DateWrapper;
import com.google.gwt.i18n.client.DateTimeFormat;
import com.google.gwt.i18n.client.DateTimeFormat.PredefinedFormat;
import com.hkah.shared.constants.ConstantsVariable;

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
	private final static String FORMAT_DISPLAY_TIME = "HH:mm:ss";
	private final static String FORMAT_DISPLAY_TIME_WITHOUT_SECOND = "HH:mm";
	private final static String FORMAT_DATETIME = "yyyy/MM/dd HH:mm:ss";
	private final static String FORMAT_DISPLAY_YEARMONTH = "yyyyMM";
	private final static String FORMAT_DISPLAY_DATABASEDATE = "DD-MON-RR";
	private final static String FORMAT_HA_DOB = "dd-MMM-yyyy";
	private final static String FORMAT_HA_L_DATETIME = "dd-MMM-yyyy HH:mm:ss";
	private final static String FORMAT_OTNOTE_DOB = "MMM dd, yyyy";
	private final static String FORMAT_OTNOTE_DATETIME = "MMM dd, yyyy hh:mm";
	private final static String FORMAT_PB_MSG_DATETIME = "MMM, yyyy";
	private final static String FORMAT_EHR_PNI_DOB = "yyyy-MM-dd HH:mm:ss.sss";
	
	private final static DateTimeFormat DATABASEDATEFormat = DateTimeFormat.getFormat(FORMAT_DISPLAY_DATABASEDATE);
	private final static DateTimeFormat HATSDateTimeFormat = DateTimeFormat.getFormat(FORMAT_HATS_DATETIME);
	private final static DateTimeFormat displayDateTimeFormat = DateTimeFormat.getFormat(FORMAT_DISPLAY_DATETIME);
	private final static DateTimeFormat displayDateTimeFormatWithoutSecond = DateTimeFormat.getFormat(FORMAT_DISPLAY_DATETIME_WITHOUT_SECOND);
	private final static DateTimeFormat displayDateFormat = DateTimeFormat.getFormat(FORMAT_DISPLAY_DATE);
	private final static DateTimeFormat displayDateFormatReverse = DateTimeFormat.getFormat(FORMAT_DISPLAY_DATE_REVERSE);
	private final static DateTimeFormat displayDBDateFormat = DateTimeFormat.getFormat(FORMAT_DISPLAY_DBDATE);
	private final static DateTimeFormat displayTimeFormat = DateTimeFormat.getFormat(FORMAT_DISPLAY_TIME);
	private final static DateTimeFormat displayTimeWithoutSecondFormat = DateTimeFormat.getFormat(FORMAT_DISPLAY_TIME_WITHOUT_SECOND);
	private final static DateTimeFormat dateTimeFormat = DateTimeFormat.getFormat(FORMAT_DATETIME);
	private final static DateTimeFormat displayYearMonthFormat = DateTimeFormat.getFormat(FORMAT_DISPLAY_YEARMONTH);
	private final static DateTimeFormat haDobDateFormat = DateTimeFormat.getFormat(FORMAT_HA_DOB);
	private final static DateTimeFormat haLDateTimeFormat = DateTimeFormat.getFormat(FORMAT_HA_L_DATETIME);
	private final static DateTimeFormat otNoteDobDateTimeForamt = DateTimeFormat.getFormat(FORMAT_OTNOTE_DOB);
	private final static DateTimeFormat otNoteDateTimeForamt = DateTimeFormat.getFormat(FORMAT_OTNOTE_DATETIME);
	private final static DateTimeFormat pbMsgDateTimeForamt = DateTimeFormat.getFormat(FORMAT_PB_MSG_DATETIME);
	private final static DateTimeFormat ehrPmiDOBDateTimeForamt = DateTimeFormat.getFormat(FORMAT_EHR_PNI_DOB);

	/***************************************************************************
	 * Conversion Method
	 **************************************************************************/

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
	
	public static Date parseDataBaseDate(String date) {
		try {
			return DATABASEDATEFormat.parse(date);
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

	public static String format(Date date, PredefinedFormat format) {
		try {
			return DateTimeFormat.getFormat(format).format(date);
		} catch (Exception ex) {
			ex.printStackTrace();
			return null;
		}
	}
	
	public static String format(Date date, String format) {
		try {
			return DateTimeFormat.getFormat(format).format(date);
		} catch (Exception ex) {
			ex.printStackTrace();
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
	
	public static String formatTimeWithoutSecond(Date time) {
		try {
			return displayTimeWithoutSecondFormat.format(time);
		} catch (Exception ex) {
			return null;
		}
	}

	public static Date parseDBDate(String date) {
		try {
			return displayDBDateFormat.parse(date);
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

	public static String formatYearMonth(Date date) {
		try {
			return displayYearMonthFormat.format(date);
		} catch (Exception ex) {
			return null;
		}
	}
	
	public static Date parseHaDobDate(String date) {
		try {
			return haDobDateFormat.parse(date);
		} catch (Exception ex) {
			return null;
		}
	}

	public static String formatHaBobDate(Date date) {
		try {
			return haDobDateFormat.format(date);
		} catch (Exception ex) {
			return null;
		}
	}
	
	public static Date parseHaLDateTime(String date) {
		try {
			return haLDateTimeFormat.parse(date);
		} catch (Exception ex) {
			return null;
		}
	}

	public static String formatHaLDateTime(Date date) {
		try {
			return haLDateTimeFormat.format(date);
		} catch (Exception ex) {
			return null;
		}
	}
	
	public static Date parseOtNoteDobDateTime(String date) {
		try {
			return otNoteDobDateTimeForamt.parse(date);
		} catch (Exception ex) {
			return null;
		}
	}
	
	public static String formatOtNoteDobDateTime(Date date) {
		try {
			return otNoteDobDateTimeForamt.format(date);
		} catch (Exception ex) {
			return null;
		}
	}
	
	public static Date parseOtNoteDateTime(String date) {
		try {
			return otNoteDateTimeForamt.parse(date);
		} catch (Exception ex) {
			return null;
		}
	}
	
	public static String formatOtNoteDateTime(Date date) {
		try {
			return otNoteDateTimeForamt.format(date);
		} catch (Exception ex) {
			return null;
		}
	}
	
	public static Date parsePbMsgDateTime(String date) {
		try {
			return pbMsgDateTimeForamt.parse(date);
		} catch (Exception ex) {
			return null;
		}
	}
	
	public static String formatPbMsgDateTime(Date date) {
		try {
			return pbMsgDateTimeForamt.format(date);
		} catch (Exception ex) {
			return null;
		}
	}
	
	public static Date parseEhrPmiDOBDateTime(String date) {
		try {
			return ehrPmiDOBDateTimeForamt.parse(date);
		} catch (Exception ex) {
			return null;
		}
	}
	
	public static String formatEhrPmiDOBDateTime(Date date) {
		try {
			return ehrPmiDOBDateTimeForamt.format(date);
		} catch (Exception ex) {
			return null;
		}
	}

	public static String dateFormat(Date date, String format) {
		return DateTimeFormat.getFormat(format).format(date);
	}

	public static Date toDate(String dt, String format) {
		return DateTimeFormat.getFormat(format).parse(dt);
	}

	/***************************************************************************
	 * Get Current Date/Time Method
	 **************************************************************************/

//
//	Please use getMainFrame().getServerDateTime()
//	to get DB date time
//
	/**
	 * Returns current date and time in format
	 */
	public static String getCurrentDateTime() {
		return formatDateTime(new Date());
	}

	/**
	 * Returns current date and time in format
	 */
	public static String getCurrentDateTime(long timediff) {
		Date date = new Date();
		date.setTime((new Date().getTime()) + timediff);
		return formatDateTime(date);
	}

//
//	Please use getMainFrame().getServerDate()
//	to get DB date
//
	/**
	 * Returns current date in format
	 */
	public static String getCurrentDate() {
		return formatDate(new Date());
	}

	/**
	 * Returns current date in format
	 */
	public static String getCurrentDate(long timediff) {
		Date date = new Date();
		date.setTime((new Date().getTime()) + timediff);
		return formatDate(date);
	}

//
//	Please use getMainFrame().getServerTime()
//	to get DB time
//
	/**
	 * Returns current time in format
	 */
	public static String getCurrentTime() {
		return formatTime(new Date());
	}

	/**
	 * Returns current time in format
	 */
	public static String getCurrentTime(long timediff) {
		Date date = new Date();
		date.setTime((new Date().getTime()) + timediff);
		return formatTime(date);
	}
	
	public static String getCurentTimeWithoutSecond(long timediff) {
		Date date = new Date();
		date.setTime((new Date().getTime()) + timediff);
		return formatTimeWithoutSecond(date);
	}

//	/**
//	 * Returns current date in format
//	 */
//	public static String getCurrentDateTimeStandard() {
//		return formatDateTimeStandard(new Date());
//	}

//	/**
//	 * Returns current date in format
//	 */
//	public static String getCurrentDateTimeWithoutSecond() {
//		return formatDateTimeWithoutSecond(new Date());
//	}

	/**
	 * @return the current next date in format dd/MM/yyyy
	 */
	public static String getRollDate(String currentDate) {
		return getRollDate(currentDate, 1);
	}

	/**
	 * @return the current next date in format dd/MM/yyyy
	 */
	public static String getRollDate(String currentDate, long numOfDay) {
		Date date = new Date();
		date.setTime((parseDate(currentDate).getTime()) + 1000*60*60*24 * numOfDay);
		return formatDate(date);
	}

	/**
	 * Returns Date field in daily used format
	 */
	public static String getCurrentDay() {
		return getCurrentDay(null);
	}

	public static String getCurrentDay(Date date) {
		if (date == null) {
			date = new Date();
		}
		return format(date, PredefinedFormat.DAY);
	}

	/**
	 * Returns the Month field in daily used format
	 */
	public static String getCurrentMonth() {
		return getCurrentMonth(null);
	}

	public static String getCurrentMonth(Date date) {
		if (date == null) {
			date = new Date();
		}
		return format(date, PredefinedFormat.MONTH);
	}

	/**
	 * Returns the Year in daily used format
	 */
	public static String getCurrentYear() {
		return getCurrentYear(null);
	}

	public static String getCurrentYear(Date date) {
		if (date == null) {
			date = new Date();
		}
		return format(date, PredefinedFormat.YEAR);
	}

//	/**
//	 * Returns the Hour in daily used format
//	 */
//	public static int getCurrentHour() {
//		return getCurrentHour(null);
//	}
//
//	public static int getCurrentHour(Date date) {
//		Calendar calendar = Calendar.getInstance();
//		if (date != null) {
//			calendar.setTime(date);
//		}
//		return calendar.get(Calendar.HOUR_OF_DAY);
//	}
//
//	/**
//	 * return current week range
//	 */
//	public static String[] getCurrentWeekRange() {
//		Calendar calendar = Calendar.getInstance();
//		int dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);
//		// roll to sunday
//		calendar.add(Calendar.DAY_OF_YEAR, 1 - dayOfWeek);
//		String[] returnDateRange = new String[2];
//		returnDateRange[0] = formatDate(calendar.getTime());
//		// roll to saturday
//		calendar.add(Calendar.DAY_OF_YEAR, 6);
//		returnDateRange[1] = formatDate(calendar.getTime());
//		return returnDateRange;
//	}
//
//	/**
//	 * return current month range
//	 */
//	public static String[] getCurrentMonthRange() {
//		Calendar calendar = Calendar.getInstance();
//		calendar.set(Calendar.DATE, 1);
//		String[] returnDateRange = new String[2];
//		returnDateRange[0] = formatDate(calendar.getTime());
//		// get the last day of this month
//		calendar.add(Calendar.MONTH, 1);
//		calendar.add(Calendar.DAY_OF_YEAR, -1);
//		returnDateRange[1] = formatDate(calendar.getTime());
//		return returnDateRange;
//	}
//
//	/**
//	 * return current year range
//	 */
//	public static String[] getCurrentYearRange() {
//		int current_yy = getCurrentYear();
//		String[] returnDateRange = new String[2];
//		returnDateRange[0] = "01/01/" + current_yy;
//		returnDateRange[1] = "31/12/" + current_yy;
//		return returnDateRange;
//	}
//
//	public static String getRollDate(int day, int month, int year) {
//		return getRollDate(Calendar.getInstance().getTime(), day, month, year);
//	}
//
//	public static String getRollDate(String date, int day, int month, int year) {
//		return getRollDate(parseDate(date), day, month, year);
//	}
//
//	public static String getRollDate(Date date, int day, int month, int year) {
//		Calendar calendar = Calendar.getInstance();
//		calendar.setTime(date);
//
//		try {
//			calendar.add(Calendar.DATE, day);
//			calendar.add(Calendar.MONTH, month);
//			calendar.add(Calendar.YEAR, year);
//			return formatDate(calendar.getTime());
//		} catch (Exception ex) {
//			return null;
//		}
//	}

	/***************************************************************************
	 * Comparsion Method
	 **************************************************************************/

	/**
	 * @return 0 if equal, > 0 is first > second, < 0 is first < second
	 */
	public static int compareTo(String firstDate, String secondDate) {
		String firstTime = "0000";
		String secondTime = "0000";
		
		if (firstDate != null && firstDate.length() == 16 && secondDate != null && secondDate.length() == 16) {
			firstTime = firstDate.substring(11, 13) + firstDate.substring(14, 16);
			secondTime = secondDate.substring(11, 13) + secondDate.substring(14, 16);
			
			firstDate = firstDate.substring(0, 10);
			secondDate = secondDate.substring(0, 10);
		}
		
		if (firstDate != null && firstDate.length() == 10 && secondDate != null && secondDate.length() == 10) {
			if (!firstDate.equals(secondDate)) {
				String parseFirstDate = date4Compare(firstDate);
				String parseSecondDate = date4Compare(secondDate);
				return parseFirstDate.compareTo(parseSecondDate);
			} else {
				// check h part
				return Integer.parseInt(firstTime) - Integer.parseInt(secondTime);
			}
		} else {
			return -2;
		}
	}

	/**
	 * @return true if startTime >= endTime, else return false
	 */
	public static boolean timeCompare(String startTime, String endTime) {
		int sh;
		int ss;
		int eh;
		int es;
		if (Integer.valueOf(startTime.substring(0,1)) == 0) {
			sh=Integer.valueOf(startTime.substring(1,2));
		} else {
			sh=Integer.valueOf(startTime.substring(0,2));
		}
		
		ss=Integer.valueOf(startTime.substring(3,5));
		
		if (Integer.valueOf(endTime.substring(0,1)) == 0) {
			eh=Integer.valueOf(endTime.substring(1,2));
		} else {
			eh=Integer.valueOf(endTime.substring(0,2));
		}
		
		es=Integer.valueOf(endTime.substring(3,5));
		
		if (sh>eh) {
			return true;
		} else if (sh==eh) {
			if (ss>=es) {
				return true;
			} else {
				return false;
			}
		} else {
			return false;
		}
	}
	
	public static String timeAdd(int addsecond,String time) {
		int sh;
		int ss;
		String h;
		String s;
		if (Integer.valueOf(time.substring(0,1)) == 0) {
			sh=Integer.valueOf(time.substring(1,2));
		} else {
			sh=Integer.valueOf(time.substring(0,2));
		}
		if (Integer.valueOf(time.substring(3,4)) == 0) {
			ss=Integer.valueOf(time.substring(3,4));
		} else {
			ss=Integer.valueOf(time.substring(3,5));
		}
		
		sh=sh + (ss+addsecond)/60;
		ss=(ss+addsecond)%60;
		if (sh<10) {
			h="0"+String.valueOf(sh);
		} else {
			h=String.valueOf(sh);
		}
		if (ss<10) {
			s="0"+String.valueOf(ss);
		} else {
			s=String.valueOf(ss);
		}
		return h+":"+s;

	}

	public static int dateDiff(String dt1, String dt2) {
		if (!isDate(dt1) || !isDate(dt2)) {
			return -1;
		}
		Date d1 = toDate(dt1, "dd/MM/yyyy");
		Date d2 = toDate(dt2, "dd/MM/yyyy");
		long diff = d1.getTime() - d2.getTime();
		long days = diff / (1000 * 60 * 60 * 24);
		return (int) days;
	}

	/**
	 * return two datetime diff in second
	 * @param dt1
	 * @param dt2
	 * @return
	 */
	public static long dateTimeDiff(String dt1, String dt2) {
		Date ddt1 = parseDateTime(dt1);
		Date ddt2 = parseDateTime(dt2);

		if (ddt1 == null || ddt2 == null) {
			return -1;
		} else {
			return ddt1.getTime() - ddt2.getTime();
		}
	}

	/**
	 * return two time diff in second
	 * @param startTime
	 * @param endTime
	 * @return
	 */
	public static int timeDiff(String startTime, String endTime) {
		int sh;
		int ss;
		int eh;
		int es;
		if (Integer.valueOf(startTime.substring(0, 1)) == 0) {
			sh = Integer.valueOf(startTime.substring(1, 2));
		} else {
			sh = Integer.valueOf(startTime.substring(0, 2));
		}
		if (Integer.valueOf(startTime.substring(3, 4)) == 0) {
			ss = Integer.valueOf(startTime.substring(4, 5));
		} else {
			ss = Integer.valueOf(startTime.substring(3, 5));
		}
		if (Integer.valueOf(endTime.substring(0, 1)) == 0) {
			eh = Integer.valueOf(endTime.substring(1, 2));
		} else {
			eh = Integer.valueOf(endTime.substring(0, 2));
		}
		if (Integer.valueOf(endTime.substring(3, 4)) == 0) {
			es = Integer.valueOf(endTime.substring(4, 5));
		} else {
			es = Integer.valueOf(endTime.substring(3, 5));
		}
		int i = (eh-sh) * 60 + (es - ss);
		return i;
	}

	public static String date4Compare(String date) {
		return date4Compare(date, false);
	}

	public static String date4Compare(String date, boolean withDelimiter) {
		if (date != null && date.length() == 10) {
			StringBuilder sb = new StringBuilder();
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

	// get the day of weekend(0-7)
	public static int getDayOfWeek(String date, String format) {
		int day=-1;
		DateTimeFormat dfs = DateTimeFormat.getFormat(format);
		try {
			Date d = dfs.parse(date);
			DateWrapper cal = new DateWrapper(d);
			day = cal.getDay();
		} catch (Exception e) {
			day = -1;
			return day;
		}
		return day;
	}
	
	public static int getCurrentDayofWeek() {
		int day=-1;
		
		try {
			Date d = new Date();
			DateWrapper cal = new DateWrapper(d);
			day = cal.getDay();
		} catch (Exception e) {
			day = -1;
			return day;
		}
		return day;
	}

	/***************************************************************************
	 * Validation Method
	 **************************************************************************/

	public static boolean isValidDate(String date) {
		return parseDate(date) != null;
	}

	public static boolean isValidDateTime(String date) {
		return parseDateTime(date) != null;
	}

	public static boolean isValidDateTimeWithSecond(String date) {
		return parseDateTimeWithoutSecond(date) != null;
	}

	public static boolean isValidTime(String time) {
		if (time != null && time.length() == 5
				&& (((time.charAt(0) == '0' || time.charAt(0) == '1') && time.charAt(1) >= '0' && time.charAt(1) <= '9') || (time.charAt(0) == '2' && time.charAt(1) >= '0' && time.charAt(1) <= '3')) 
				&&  time.charAt(2) == ':'
				&& (time.charAt(3) >= '0' && time.charAt(3) <= '5')
				&& (time.charAt(4) >= '0' && time.charAt(4) <= '9')
				) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean isDate(String dt) {
		return isDate(dt, displayDateFormat);
	}

	public static boolean isDateTime(String dt) {
		return isDate(dt, displayDateTimeFormat);
	}

	public static boolean isExpiryDate(String dt) {
		if (dt != null && dt.length() == 4) {
			try {
				int month = Integer.parseInt(dt.substring(0, 2));
				int year = Integer.parseInt(dt.substring(2));
				int current_year = Integer.parseInt(getCurrentYear().substring(2));
				return month >= 1 && month <= 12 && year >= current_year;	
			} catch (Exception e) {}
		}
		return false;
	}

	public static boolean isDateTimeWithoutSecond(String dt) {
		return isDate(dt, displayDateTimeFormatWithoutSecond);
	}

	private static boolean isDate(String dt, DateTimeFormat dfs) {
		if (dt == null) {
			return false;
		}
		try {
			return dt.equals(dfs.format(dfs.parse(dt)));
		} catch (Exception e) {
			return false;
		}
	}

	/***************************************************************************
	 * Amendment Method
	 **************************************************************************/

	public static String getStartTime(String datetime) {
		if (datetime != null && datetime.length() >= 10) {
			return datetime.substring(0, 10) + " 00:00";
		} else {
			return null;
		}
	}
	
	public static String getEndTime(String datetime) {
		if (datetime != null && datetime.length() >= 10) {
			return datetime.substring(0, 10) + " 23:59";
		} else {
			return null;
		}
	}
}