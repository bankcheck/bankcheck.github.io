package com.hkah.client.util;

import java.util.Map;

import com.hkah.client.event.CallbackListener;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.UserInfo;

public class Report implements ConstantsVariable {
	/**
	 * print function overload
	 * @param userInfo
	 * @param rptName - jasper file name
	 * @param map - parameters
	 */
	public static void print(UserInfo userInfo, String rptName, Map<String, String> map) {
		//print(userInfo, rptName, map, null, null, null, null, null, null, null, true);
		print(userInfo, rptName, map, null, null, true, null, null, null, false);
	}

	/**
	 * print function overload
	 * @param userInfo
	 * @param rptName - jasper file name
	 * @param map - parameters
	 * @param inparam - db parameters
	 * @param columnName - db column name
	 *
	 */
	public static void print(UserInfo userInfo,
			String rptName, Map<String, String> map, String[] inparam, String[] columnName) {
		print(userInfo, rptName, map, inparam, columnName, true, null, null, null, false);
	}

	/**
	 * print function overload
	 * @param userInfo
	 * @param rptName - jasper file name
	 * @param map - parameters
	 * @param inparam - db parameters
	 *
	 */
	public static void print(UserInfo userInfo,
			String rptName, Map<String, String> map, String[] inparam,boolean keepPanel) {
		print(userInfo, rptName, map, inparam, null, keepPanel, null, null, null, false);
	}

	public static void print(UserInfo userInfo,
			String rptName, Map<String, String> map, String[] inparam, String[] columnName,
			boolean keepPanel) {
		print(userInfo, rptName, map, inparam, columnName, null, null, null, null, null, "", keepPanel, null);
	}

	/**
	 * print function overload
	 * @param userInfo
	 * @param rptName - jasper file name
	 * @param map - parameters
	 * @param inparam - db parameters
	 * @param columnName - db column name
	 */
	public static void print(UserInfo userInfo,
			String rptName, Map<String, String> map, String[] inparam, String[] columnName,
			boolean keepPanel, CallbackListener callback, String filePath, String fileName, boolean print2Printer) {
		print(userInfo, rptName, map, inparam, columnName, null, null, null, null, null, "", keepPanel,
				callback, filePath, fileName, print2Printer);
	}

	/**
	 * print function overload
	 * @param userInfo
	 * @param rptName - jasper file name
	 * @param map - parameters
	 * @param inparam - db parameters
	 * @param columnName - db column name
	 * @param isNumericColumn - whether db column is number
	 */
	public static void print(UserInfo userInfo, String rptName, Map<String, String> map,
								String[] inparam, String[] columnName,
								boolean[] isNumericColumn) {
		print(userInfo, rptName, map, inparam, columnName, isNumericColumn, null, null, null, new boolean[0], "");
	}

	public static void print(UserInfo userInfo,
			String rptName, Map<String, String> map,
			String[] inparam, String[] columnName, boolean[] isNumericColumn,
			String sub_prtName,
			String[] sub_dbparam, String[] sub_columnName, boolean[] sub_isNumericColumn) {
		print(userInfo, rptName, map, inparam, columnName, isNumericColumn,
				new String[] { sub_prtName }, new String[][] { sub_dbparam },
				new String[][] { sub_columnName },
				new boolean[][] { sub_isNumericColumn }, null, true, null);
	}

	/**
	 * print function overload
	 * @param userInfo
	 * @param rptName - jasper file name
	 * @param map - parameters
	 * @param inparam - db parameters
	 * @param columnName - db column name
	 * @param isNumericColumn - whether db column is number
	 * @param sub_prtName - sub jasper file name
	 * @param sub_dbparam - sub db parameters
	 * @param sub_columnName - sub db column name
	 * @param sub_isNumericColumn - whether sub db column is number
	 */
	public static void print(UserInfo userInfo,
			String rptName, Map<String, String> map,
			String[] inparam, String[] columnName, boolean[] isNumericColumn,
			String sub_prtName,
			String[] sub_dbparam, String[] sub_columnName, boolean[] sub_isNumericColumn,
			String paperSize) {
		print(userInfo, rptName, map, inparam, columnName, isNumericColumn,
				new String[] { sub_prtName }, new String[][] { sub_dbparam },
				new String[][] { sub_columnName },
				new boolean[][] { sub_isNumericColumn }, paperSize, true, null);
	}

	public static void print(UserInfo userInfo,
			String rptName, Map<String, String> map,
			String[] inparam, String[] columnName, boolean[] isNumericColumn,
			String[] sub_prtName,
			String[][] sub_dbparam, String[][] sub_columnName,
			boolean[][] sub_isNumericColumn, String paperSize) {
		print(userInfo, rptName, map, inparam, columnName, isNumericColumn,
				sub_prtName, sub_dbparam, sub_columnName, sub_isNumericColumn,
				paperSize, true, null);
	}

	public static void print(UserInfo userInfo,
			String rptName, Map<String, String> map,
			String[] inparam, String[] columnName, boolean[] isNumericColumn,
			String[] sub_prtName,
			String[][] sub_dbparam, String[][] sub_columnName,
			boolean[][] sub_isNumericColumn, String paperSize, boolean keepPanel,
			CallbackListener callback) {
		print(userInfo, rptName, map, inparam, columnName, isNumericColumn,
				sub_prtName, sub_dbparam, sub_columnName,
				sub_isNumericColumn, paperSize, keepPanel, false, true, false, callback, null, null, false);
	}

	/**
	 * main print function
	 * @param userInfo
	 * @param rptName - jasper file name
	 * @param map - parameters
	 * @param inparam - db parameters
	 * @param columnName - db column name
	 * @param isNumericColumn - whether db column is number
	 * @param sub_prtName - sub jasper file name
	 * @param sub_dbparam - sub db parameters
	 * @param sub_columnName - sub db column name
	 * @param sub_isNumericColumn - whether sub db column is number
	 * @param keepPanel - whether exit previous panel
	 */
	public static void print(UserInfo userInfo,
			String rptName, Map<String, String> map,
			String[] inparam, String[] columnName, boolean[] isNumericColumn,
			String[] sub_prtName,
			String[][] sub_dbparam, String[][] sub_columnName,
			boolean[][] sub_isNumericColumn, String paperSize, boolean keepPanel,
			CallbackListener callback, String filePath, String fileName,
			boolean print2Printer) {
		print(userInfo, rptName, map, inparam, columnName, isNumericColumn,
				sub_prtName, sub_dbparam, sub_columnName,
				sub_isNumericColumn, paperSize, keepPanel, false, true, false, callback, filePath, fileName,
				print2Printer);
	}

	public static void print(UserInfo userInfo,
			final String rptName, final Map<String, String> map,
			final String[] inparam, final String[] columnName, boolean[] isNumericColumn,
			final String[] sub_prtName,
			final String[][] sub_dbparam, final String[][] sub_columnName,
			final boolean[][] sub_isNumericColumn, final String paperSize,
			boolean keepPanel,boolean showPrintBox, boolean showPDF,
			boolean reversePageOrder) {
		print(userInfo,
				rptName, map,
				inparam, columnName, isNumericColumn,
				sub_prtName,
				sub_dbparam, sub_columnName,
				sub_isNumericColumn, paperSize,
				keepPanel, showPrintBox, showPDF,
				reversePageOrder, null, null, null, false);
	}

	/**
	 * main print function
	 * @param userInfo
	 * @param rptName - jasper file name
	 * @param map - parameters
	 * @param inparam - db parameters
	 * @param columnName - db column name
	 * @param isNumericColumn - whether db column is number
	 * @param sub_prtName - sub jasper file name
	 * @param sub_dbparam - sub db parameters
	 * @param sub_columnName - sub db column name
	 * @param sub_isNumericColumn - whether sub db column is number
	 * @param keepPanel - whether exit previous panel
	 * @param showPrintBox - show print box
	 * @param showPDF - show the export PDF
	 */
	public static void print(final UserInfo userInfo,
			final String rptName, final Map<String, String> map,
			final String[] inparam, final String[] columnName, final boolean[] isNumericColumn,
			final String[] sub_prtName,
			final String[][] sub_dbparam, final String[][] sub_columnName,
			final boolean[][] sub_isNumericColumn, final String paperSize,
			boolean keepPanel, final boolean showPrintBox, final boolean showPDF,
			final boolean reversePageOrder, final CallbackListener callback, final String filePath, final String fileName,
			final boolean print2Printer) {

		PrintUtilHandler.print(userInfo, EMPTY_VALUE,
				rptName, map, null,
				inparam, columnName, isNumericColumn,
				sub_prtName, sub_dbparam, sub_columnName, sub_isNumericColumn,
				1, null, paperSize,
				keepPanel, showPrintBox, showPDF, reversePageOrder,
				callback, filePath, fileName, print2Printer,
				true, EMPTY_VALUE, null, false, null, false,
				true);
	}

	public void onReportReady(String result) {}
}