package com.hkah.client.util;

import java.util.HashMap;
import java.util.Map;

import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.PrinterInfo;

public class PrintingUtil implements ConstantsVariable {

	private MainFrame mainFrame = null;
	private static String printerString = null;
	private static String defaultPrinter = null;
	private static String curPtrLstString = null;
	private static String noOfPtrSet = null;
	private static String appliedSet = null;
	private static String nameOfPtrSet = null;
	private static String selectedSetString = null;

	private static HashMap<String, String> keyIsChar = new HashMap<String, String>();
	private static HashMap<String, String> keyIsNum = new HashMap<String, String>();

	private MainFrame getMainFrame() {
		return mainFrame;
	}

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

	/***************************************************************************
	 * Print Label Methods
	 **************************************************************************/

	public static String getAppletName() {
		String ret = Factory.getInstance().getPrtAppletName();
		if (ret == null || ret.isEmpty()) {
			//hardcode if cannot get applet
			//ret = "HKAH" + Factory.getInstance().getClientConfig("system.module.code") + "Applet";
			ret = "HKAHNHSApplet";
		}
		return ret;
	}

	public PrinterInfo getPrinterInfo() {
		if (getMainFrame() != null && getMainFrame().getPrinterInfo() != null) {
			return getMainFrame().getPrinterInfo();
		} else {
			return null;
		}
	}

	/***************************************************************************
	 * Print Methods
	 **************************************************************************/

	public static boolean print(String rptName,
			Map<String, String> map, String patcname) {
		return print(EMPTY_VALUE, rptName, map, patcname, null, null, 0, null, null,
						null, null, 1);
	}

	public static boolean print(String rptName,
			Map<String, String> map, String patcname, String isExportWd) {
		return print(EMPTY_VALUE, rptName, map, patcname, null, null, 0, null, null, null,
						null, 1, isExportWd, true);
	}

	public static boolean print(String rptName,
			Map<String, String> map, String patcname, int noOfCopies) {
		return print(EMPTY_VALUE, rptName, map, patcname, null, null, 0, null, null, null,
						null, noOfCopies);
	}

	public static boolean print(String prterName, String rptName,
			Map<String, String> map, String patcname) {
		return print(prterName, rptName,
						map, patcname, null, null, 0, null, null, null, null, 1);
	}

	public static boolean print(String prterName, String rptName,
			Map<String, String> map, String patcname, int noOfCopies) {
		return print(prterName, rptName,
						map, patcname, null, null, 0, null, null, null, null,
						noOfCopies);
	}

	public static boolean print(String rptName,
			Map<String, String> map, String patcname,
			String[] inParamArray, String[] columnNameArray) {
		return print(EMPTY_VALUE, rptName, map, patcname, inParamArray, columnNameArray,
						0, null, null, null, null, 1);
	}

	public static boolean print(String rptName,
			Map<String, String> map, String patcname,
			String[] inParamArray, String[] columnNameArray,
			boolean saveAs, String[] fileType) {
		return print(EMPTY_VALUE, rptName, map, patcname, inParamArray, columnNameArray,
						0, null, null, null, null, 1, saveAs, fileType);
	}

	public static boolean print(String rptName,
			Map<String, String> map, String patcname,
			String[] inParamArray, String[] columnNameArray,
			String pageSize, String pageOrientation) {
		return print(EMPTY_VALUE, rptName, map, patcname, inParamArray, columnNameArray,
						0, null, null, null, null, 1, pageSize, pageOrientation);
	}

	public static boolean print(String rptName,
			Map<String, String> map, String patcname,
			String[] inParamArray, String[] columnNameArray, int noOfCopies) {
		return print(EMPTY_VALUE, rptName, map, patcname, inParamArray, columnNameArray,
						0, null, null, null, null, noOfCopies);
	}

	public static boolean print(String prterName,
			String rptName,Map<String, String> map, String patcname,
			String[] inParamArray, String[] columnNameArray) {
		return print(prterName, rptName,
						map, patcname, inParamArray, columnNameArray, 0, null,
						null, null, null, 1);
	}

	public static boolean print(String prterName,
			String rptName, Map<String, String> map, String patcname,
			String[] inParamArray, String[] columnNameArray, boolean alertSuccess) {
		return print(prterName, rptName,
						map, patcname, inParamArray, columnNameArray, 0, null,
						null, null, null, 1, alertSuccess);
	}

	public static boolean print(String prterName,
			String rptName, Map<String, String> map, String patcname,
			String[] inParamArray, String[] columnNameArray, int noOfCopies) {
		return print(prterName, rptName,
						map, patcname, inParamArray, columnNameArray, 0, null,
						null, null, null, noOfCopies);
	}

	public static boolean print(String prterName,
			String rptName, Map<String, String> map, String patcname,
			String[] inParamArray, String[] columnNameArray,
			int noOfSub, String[] subRptName, String[][] sub_dbParam,
			String[][] sub_colName, boolean[][]isNumericCol) {
		return print(EMPTY_VALUE, rptName, map, patcname, inParamArray, columnNameArray,
						noOfSub, subRptName, sub_dbParam, sub_colName, isNumericCol,
						1);
	}

	public static boolean print(
			String rptName, Map<String, String> map, String patcname,
			String[] inParamArray, String[] columnNameArray,
			int noOfSub, String[] subRptName, String[][] sub_dbParam,
			String[][] sub_colName, boolean[][]isNumericCol) {
		return print(EMPTY_VALUE, rptName, map, patcname, inParamArray, columnNameArray,
						noOfSub, subRptName, sub_dbParam, sub_colName, isNumericCol, 1);
	}

	public static boolean print(
			String rptName, Map<String, String> map, String patcname,
			String[] inParamArray, String[] columnNameArray,
			int noOfSub, String[] subRptName, String[][] sub_dbParam,
			String[][] sub_colName, boolean[][] isNumericCol, int noOfCopies) {
		return print(EMPTY_VALUE, rptName, map, patcname, inParamArray, columnNameArray,
						noOfSub, subRptName, sub_dbParam, sub_colName,
						isNumericCol, noOfCopies);
	}

	public static boolean print(
			String prterName, String rptName,
			Map<String, String> map, String patcname,
			String[] inParamArray, String[] columnNameArray,
			int noOfSub, String[] subRptName, String[][] sub_dbParam,
			String[][] sub_colName, boolean[][]isNumericCol, int noOfCopies) {
		return print(prterName, rptName, map, patcname, inParamArray, columnNameArray,
						noOfSub, subRptName, sub_dbParam, sub_colName, isNumericCol,
						noOfCopies, true);
	}

	public static boolean print(
			String prterName, String rptName,
			Map<String, String> map, String patcname,
			String[] inParamArray, String[] columnNameArray,
			int noOfSub, String[] subRptName, String[][] sub_dbParam,
			String[][] sub_colName, boolean[][]isNumericCol,
			int noOfCopies, boolean saveAs, String[] fileType) {
		return print(prterName, rptName, map, patcname, inParamArray, columnNameArray,
						noOfSub, subRptName, sub_dbParam, sub_colName, isNumericCol,
						noOfCopies, true, saveAs, fileType);
	}

	public static boolean print(
			String prterName, String rptName,
			Map<String, String> map, String patcname,
			String[] inParamArray, String[] columnNameArray,
			int noOfSub, String[] subRptName, String[][] sub_dbParam,
			String[][] sub_colName, boolean[][]isNumericCol,
			int noOfCopies, String pageSize) {
		return print(prterName, rptName, map, patcname, inParamArray, columnNameArray,
						noOfSub, subRptName, sub_dbParam, sub_colName, isNumericCol,
						noOfCopies, true, pageSize, null);
	}

	public static boolean print(String prterName, String rptName,
			Map<String, String> map, String patcname,
			String[] inParamArray, String[] columnNameArray,
			int noOfSub, String[] subRptName, String[][] sub_dbParam,
			String[][] sub_colName, boolean[][]isNumericCol,
			int noOfCopies, String pageSize, String pageOrientation) {
		return print(prterName, rptName, map, patcname, inParamArray, columnNameArray,
						noOfSub, subRptName, sub_dbParam, sub_colName, isNumericCol,
						noOfCopies, true, pageSize, pageOrientation);
	}

	public static boolean print(String prterName, String rptName,
			Map<String, String> map, String patcname,
			String[] inParamArray, String[] columnNameArray,
			int noOfSub, String[] subRptName, String[][] sub_dbParam,
			String[][] sub_colName, boolean[][]isNumericCol,
			int noOfCopies, boolean alertSuccess) {
		return print(prterName, rptName, map, patcname, inParamArray, columnNameArray,
						noOfSub, subRptName, sub_dbParam, sub_colName, isNumericCol,
						noOfCopies, null, alertSuccess);
	};

	public static boolean print(String prterName, String rptName,
			Map<String, String> map, String patcname,
			String[] inParamArray, String[] columnNameArray,
			int noOfSub, String[] subRptName, String[][] sub_dbParam,
			String[][] sub_colName, boolean[][]isNumericCol,
			int noOfCopies, boolean alertSuccess, boolean saveAs,
			String[] fileType) {
		return print(prterName, rptName, map, patcname, inParamArray, columnNameArray,
						noOfSub, subRptName, sub_dbParam, sub_colName, isNumericCol,
						noOfCopies, null, alertSuccess, saveAs, fileType);
	};

	public static boolean print(String prterName, String rptName,
			Map<String, String> map, String patcname,
			String[] inParamArray, String[] columnNameArray,
			int noOfSub, String[] subRptName, String[][] sub_dbParam,
			String[][] sub_colName, boolean[][]isNumericCol,
			int noOfCopies, boolean alertSuccess, boolean saveAs,
			String[] fileType, boolean isIgnorePagination) {
		return print(prterName, rptName, map, patcname, inParamArray, columnNameArray,
						noOfSub, subRptName, sub_dbParam, sub_colName, isNumericCol,
						noOfCopies, null, alertSuccess, saveAs, fileType, isIgnorePagination);
	};

	public static boolean print(String prterName, String rptName,
			Map<String, String> map, String patcname,
			String[] inParamArray, String[] columnNameArray,
			int noOfSub, String[] subRptName, String[][] sub_dbParam,
			String[][] sub_colName, boolean[][]isNumericCol,
			int noOfCopies,	boolean alertSuccess, String pageSize, String pageOrientation) {
		return print(prterName, rptName, map, patcname, inParamArray, columnNameArray,
						noOfSub, subRptName, sub_dbParam, sub_colName, isNumericCol,
						noOfCopies, null, alertSuccess, pageSize, pageOrientation, false, null, false);
	};

	public static boolean print(String prterName, String rptName,
			Map<String, String> map, String patcname,
			String[] inParamArray, String[] columnNameArray,
			int noOfSub, String[] subRptName, String[][] sub_dbParam,
			String[][] sub_colName, boolean[][]isNumericCol,
			int noOfCopies, String isExportWd, boolean alertSuccess) {
		return print(prterName, rptName, map, patcname, inParamArray, columnNameArray,
						noOfSub, subRptName, sub_dbParam, sub_colName, isNumericCol,
						noOfCopies, isExportWd, alertSuccess, EMPTY_VALUE, EMPTY_VALUE, false, null, false);
	}

	public static boolean print(String prterName, String rptName,
			Map<String, String> map, String patcname,
			String[] inParamArray, String[] columnNameArray,
			int noOfSub, String[] subRptName, String[][] sub_dbParam,
			String[][] sub_colName, boolean[][]isNumericCol,
			int noOfCopies, String isExportWd, boolean alertSuccess,
			boolean saveAs, String[] fileType, boolean isIgnorePagination) {
		return print(prterName, rptName, map, patcname, inParamArray, columnNameArray,
						noOfSub, subRptName, sub_dbParam, sub_colName, isNumericCol,
						noOfCopies, isExportWd, alertSuccess, EMPTY_VALUE, EMPTY_VALUE, saveAs, fileType, isIgnorePagination);
	}

	public static boolean print(String prterName, String rptName,
			Map<String, String> map, String patcname,
			String[] inParamArray, String[] columnNameArray,
			int noOfSub, String[] subRptName, String[][] sub_dbParam,
			String[][] sub_colName, boolean[][]isNumericCol,
			int noOfCopies, String isExportWd, boolean alertSuccess,
			boolean saveAs, String[] fileType) {
		return print(prterName, rptName, map, patcname, inParamArray, columnNameArray,
						noOfSub, subRptName, sub_dbParam, sub_colName, isNumericCol,
						noOfCopies, isExportWd, alertSuccess, EMPTY_VALUE, EMPTY_VALUE, saveAs, fileType, false);
	}

	public static boolean print(String prterName, String rptName,
			Map<String, String> map, String patcname,
			String[] inParamArray, String[] columnNameArray,
			int noOfSub, String[] subRptName, String[][] sub_dbParam,
			String[][] sub_colName, boolean[][]isNumericCol,
			int noOfCopies, String isExportWd, boolean alertSuccess,
			String pageSize, boolean saveAs, String[] fileType) {
		return print(prterName, rptName, map,
						patcname, inParamArray, columnNameArray,
						noOfSub, subRptName, sub_dbParam,
						sub_colName, isNumericCol,
						noOfCopies, isExportWd, alertSuccess,
						pageSize, null, saveAs, fileType, false);
	}

	public static boolean print(String prterName, String rptName,
			Map<String, String> map, String patcname,
			String[] inParamArray, String[] columnNameArray,
			int noOfSub, String[] subRptName, String[][] sub_dbParam,
			String[][] sub_colName, boolean[][]isNumericCol,
			int noOfCopies, String isExportWd, final boolean alertSuccess,
			String pageSize, String pageOrientation, boolean saveAs, String[] fileType,
			boolean isIgnorePagination) {
		return PrintUtilHandler.print(Factory.getInstance().getUserInfo(),
				prterName,
				rptName, map, patcname,
				inParamArray, columnNameArray, null,
				subRptName, sub_dbParam, sub_colName, isNumericCol,
				noOfCopies, isExportWd, null,
				true, false, true, false,
				null, null, null, false,
				alertSuccess, pageSize, pageOrientation, saveAs, fileType, isIgnorePagination, false);
	}

	public static boolean printBatch(String prterName, String[] rptName,
			Map<String, Map<String, String>> map, String[] patcname,
			String[][] inParamArray, String[][] columnNameArray,
			int[] noOfSub, Map<Integer, String[]> subRptNameMap,
			Map<Integer, String[][]> sub_dbParamMap,
			Map<Integer, String[][]> sub_colNameMap, int[] noOfCopies,
			String[] pageSize, String pageOrientation,
			boolean alertSuccess) {
		return printBatch(prterName, rptName, map, patcname, inParamArray,
						columnNameArray, noOfSub, subRptNameMap, sub_dbParamMap,
						sub_colNameMap, null, null, null, null, null, null,
						null, noOfCopies, pageSize, pageOrientation, alertSuccess);
	}

	public static boolean printBatch(String prterName, String[] rptName, Map<String, Map<String, String>>map,
			String[] patcname, String[][] inParamArray, String[][] columnNameArray,
			int[] noOfSub, Map<Integer, String[]>subRptNameMap,
			Map<Integer, String[][]> sub_dbParamMap, Map<Integer,String[][]> sub_colNameMap,
			Map<Integer, boolean[][]>isNumericColMap, boolean[] externalResources,
			int[] exCodeInParamIndex, boolean[] getExMsgEng, boolean[] getExMsgTRC,
			boolean[] getExMsgSMC, boolean[] returnJP, int[] noOfCopies,
			String[] pageSize, String pageOrientation, final boolean alertSuccess) {
		return PrintUtilHandler.printBatch(prterName, rptName, map,
				patcname, inParamArray, columnNameArray,
				noOfSub, subRptNameMap,
				sub_dbParamMap, sub_colNameMap,
				isNumericColMap, externalResources,
				exCodeInParamIndex, getExMsgEng, getExMsgTRC,
				getExMsgSMC, returnJP, noOfCopies,
				pageSize, pageOrientation, alertSuccess);
	}

	/***************************************************************************
	 * Printer List Methods
	 **************************************************************************/

	public static native void getPrinterListFromApp() /*-{
		var appletName = @com.hkah.client.util.PrintingUtil::getAppletName()();
		if (appletName == null || appletName == '') {
			alert('Cannot get applet:' + appletName);
		}

		var result = $wnd.getApplet(appletName).getPrinterList();
		@com.hkah.client.util.PrintingUtil::printerString = result;
	}-*/;

	public static native void getDefaultPrinterFromApp() /*-{
		var appletName = @com.hkah.client.util.PrintingUtil::getAppletName()();
		if (appletName == null || appletName == '') {
			alert('Cannot get applet:' + appletName);
		}

		var result = $wnd.getApplet(appletName).getDefaultPrinter();
		@com.hkah.client.util.PrintingUtil::defaultPrinter = result;
	}-*/;

	public void setPrterLtFromApp(String listString) {
		setPrinterString(listString);
	}

	public void setDefaultPrterFromApp(String defaultPrinter) {
		setDefaultPrinter(defaultPrinter);
	}

	public static String getDefaultPrinter() {
		if (EMPTY_VALUE.equals(defaultPrinter) || defaultPrinter == null) {
			getDefaultPrinterFromApp();
		}
		return defaultPrinter;
	}

	public static void setDefaultPrinter(String defaultPrinter) {
		PrintingUtil.defaultPrinter = defaultPrinter;
	}

	public static String[] getPrinterArray() {
		if (EMPTY_VALUE.equals(printerString) || printerString == null) {
			getPrinterListFromApp();
		}
		String[] printerArray = TextUtil.split(printerString);
		return printerArray;
	}

	public static void setPrinterString(String printerString) {
		PrintingUtil.printerString = printerString;
	}

	//From PrinterConfig//

	public static native void changePrinterSet(String setNo) /*-{
		var appletName = @com.hkah.client.util.PrintingUtil::getAppletName()();
		if (appletName == null || appletName == '') {
			alert('Cannot get applet:' + appletName);
		}

		$wnd.getApplet(appletName).setAppliedSetNo(setNo);

	}-*/;

	public static native void reloadConfig() /*-{
		var appletName = @com.hkah.client.util.PrintingUtil::getAppletName()();
		if (appletName == null || appletName == '') {
			alert('Cannot get applet:' + appletName);
		}

		$wnd.getApplet(appletName).reloadConfig();

	}-*/;

	private static native void getCurPrinterListFromApp() /*-{
		var appletName = @com.hkah.client.util.PrintingUtil::getAppletName()();
		if (appletName == null || appletName == '') {
			alert('Cannot get applet:' + appletName);
		}

		var result = $wnd.getApplet(appletName).getCurPrinterSetList();
		@com.hkah.client.util.PrintingUtil::curPtrLstString = result;
	}-*/;

	public static HashMap<String, String> getCurPrinterListMap() {
		getCurPrinterListFromApp();
		return getPrtListMap(curPtrLstString);
	}

	private static native void getNoOfPrinterSetFromApp() /*-{
		var appletName = @com.hkah.client.util.PrintingUtil::getAppletName()();
		if (appletName == null || appletName == '') {
			alert('Cannot get applet:' + appletName);
		}

		var result = $wnd.getApplet(appletName).getNoOfPrinterSet();
		@com.hkah.client.util.PrintingUtil::noOfPtrSet = result;
	}-*/;

	public static String getNoOfPrinterSet() {
		getNoOfPrinterSetFromApp();
		return noOfPtrSet;
	}

	private static native void getPrinterNameSetFromApp() /*-{
		var appletName = @com.hkah.client.util.PrintingUtil::getAppletName()();
		if (appletName == null || appletName == '') {
			alert('Cannot get applet:' + appletName);
		}

		var result = $wnd.getApplet(appletName).getPrinterNameSet();
		@com.hkah.client.util.PrintingUtil::nameOfPtrSet = result;
	}-*/;

	public static HashMap<String, String> getPrinterNameSet() {
		getPrinterNameSetFromApp();
		return getPrtListMap(nameOfPtrSet);
	}

	private static native void getAppliedSetNoFromApp() /*-{
		var appletName = @com.hkah.client.util.PrintingUtil::getAppletName()();
		if (appletName == null || appletName == '') {
			alert('Cannot get applet:' + appletName);
		}

		var result = $wnd.getApplet(appletName).getAppliedSetNo();
		@com.hkah.client.util.PrintingUtil::appliedSet = result;
	}-*/;

	public static String getAppliedSetNo() {
		getAppliedSetNoFromApp();
		return appliedSet;
	}

	private static native void getSelectedPrinterSetListFromApp(String setNo) /*-{
		var appletName = @com.hkah.client.util.PrintingUtil::getAppletName()();
		if (appletName == null || appletName == '') {
			alert('Cannot get applet:' + appletName);
		}

		var result = $wnd.getApplet(appletName).getSelectedPrinterSetList(setNo);
		@com.hkah.client.util.PrintingUtil::selectedSetString = result;
	}-*/;

	public static HashMap<String, String> getSelectedPrinterSetMap(String setNo) {
		getSelectedPrinterSetListFromApp(setNo);
		return getPrtListMap(selectedSetString);
	}

	private static HashMap<String, String> getPrtListMap(String listStr) {
		if (!EMPTY_VALUE.equals(listStr)) {
			String[] listArray = TextUtil.split(listStr.replaceAll("[{}]", SPACE_VALUE), ",");
			HashMap<String, String> Map = new HashMap<String, String>();
			String[] row = null;
			for (int i = 0; i < listArray.length; i++) {
				row = TextUtil.split(listArray[i], EQUAL_VALUE);
				Map.put(row[0], row[1]);
			}
			return Map;
		}
		return null;
	}
}