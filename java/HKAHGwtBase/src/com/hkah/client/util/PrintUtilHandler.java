package com.hkah.client.util;

import java.util.Arrays;
import java.util.Map;
import java.util.concurrent.TimeUnit;

import com.extjs.gxt.ui.client.Registry;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.google.gwt.json.client.JSONArray;
import com.google.gwt.json.client.JSONObject;
import com.google.gwt.json.client.JSONString;
import com.google.gwt.json.client.JSONValue;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.hkah.client.AbstractEntryPoint;
import com.hkah.client.common.Factory;
import com.hkah.client.event.CallbackListener;
import com.hkah.client.layout.panel.ReportPanel;
import com.hkah.client.services.ReportServiceAsync;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;
import com.hkah.shared.model.UserInfo;

public class PrintUtilHandler implements ConstantsVariable {

	public static boolean print(UserInfo userInfo, String prterName,
			String rptName, Map<String, String> map, String patcname,
			String[] inparam, String[] columnName, boolean[] isNumericColumn,
			String[] sub_prtName,
			String[][] sub_dbparam, String[][] sub_columnName, boolean[][] sub_isNumericColumn,
			int noOfCopies, String isExportWd, String paperSize, boolean keepPanel,
			boolean isPreview) {

		return print(userInfo, prterName,
				rptName, map, patcname,
				inparam, columnName, isNumericColumn,
				sub_prtName, sub_dbparam, sub_columnName, sub_isNumericColumn,
				noOfCopies, isExportWd, paperSize,
				keepPanel, true, false, true,
				null, null, null, false,
				false, EMPTY_VALUE, EMPTY_VALUE, false, null, false,
				isPreview);
	}

	public static boolean print(UserInfo userInfo,
			String rptName, Map<String, String> map,
			String[] inparam, String[] columnName, boolean[] isNumericColumn,
			String[] sub_prtName,
			String[][] sub_dbparam, String[][] sub_columnName, boolean[][] sub_isNumericColumn,
			String paperSize, boolean keepPanel, boolean showPrintBox, boolean showPDF,
			boolean reversePageOrder, CallbackListener callback, String filePath, String fileName, boolean print2Printer,
			int noOfCopies, String pageSize, String pageOrientation,
			boolean isPreview) {

		return print(userInfo, null,
				rptName, map, null,
				inparam, columnName, isNumericColumn,
				sub_prtName, sub_dbparam, sub_columnName, sub_isNumericColumn,
				noOfCopies, null, paperSize,
				keepPanel, showPrintBox, showPDF, reversePageOrder,
				callback, filePath, fileName, print2Printer,
				false, pageSize, pageOrientation, false, null, false,
				isPreview);
	}

	public static boolean print(UserInfo userInfo, String prterName,
			String rptName, Map<String, String> map, String patcname,
			String[] inparam, String[] columnName, boolean[] isNumericColumn,
			String[] sub_prtName, String[][] sub_dbparam, String[][] sub_columnName, boolean[][] sub_isNumericColumn,
			int noOfCopies, String isExportWd, String paperSize,
			boolean keepPanel, boolean showPrintBox, final boolean showPDF, final boolean reversePageOrder,
			CallbackListener callback, final String filePath, final String fileName, final boolean print2Printer,
			boolean alertSuccess, String pageSize, String pageOrientation, boolean saveAs, String[] fileType, boolean isIgnorePagination,
			boolean isPreview) {

		if (isNumericColumn == null && columnName != null) {
			isNumericColumn = new boolean[columnName.length];
			for (int i = 0; i < columnName.length; i++) {
				isNumericColumn[i] = false;
			}
		}

		if (isPreview) {
			return previewHelper(userInfo,
				rptName, map, patcname,
				inparam, columnName, isNumericColumn,
				sub_prtName, sub_dbparam, sub_columnName, sub_isNumericColumn,
				noOfCopies, isExportWd, paperSize, keepPanel, showPrintBox, showPDF,
				reversePageOrder, callback, filePath, fileName, print2Printer);
		} else {
			return printHelper(prterName==null?EMPTY_VALUE:prterName.replaceAll(SPACE_VALUE, PLUS_VALUE),
				rptName, map, patcname,
				inparam, columnName, isNumericColumn,
				sub_prtName, sub_dbparam, sub_columnName, sub_isNumericColumn,
				noOfCopies, isExportWd, alertSuccess, paperSize, pageOrientation, saveAs, fileType, isIgnorePagination);
		}
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
	private static boolean previewHelper(final UserInfo userInfo,
			final String rptName, final Map<String, String> map, final String patcname,
			final String[] inparam, final String[] columnName, final boolean[] isNumericColumn,
			final String[] sub_prtName,
			final String[][] sub_dbparam, final String[][] sub_columnName, final boolean[][] sub_isNumericColumn,
			final int noOfCopies, final String isExportWd, final String paperSize,
			final boolean keepPanel, final boolean showPrintBox, final boolean showPDF, final boolean reversePageOrder,
			final CallbackListener callback, final String filePath, final String fileName, final boolean print2Printer) {
		ReportPanel report = new ReportPanel() {
			@Override
			public void printAction() {
				String printerName = EMPTY_VALUE;
				if (paperSize != null && paperSize.length() > 0) {
					printerName = "HATS_" + paperSize;
				}

//				if (Factory.getInstance().getMainFrame().isPdfPrint()) {
//					// pdf print
//					if (map != null) {
//						map.put("pdf-print", printerName.isEmpty() ? ConstantsVariable.YES_VALUE : printerName);
//					}
//					DialogPrintReport d = new DialogPrintReport(printerName);
//					d.addParameter(userInfo, rptName, map, inparam, columnName,
//						isNumericColumn, sub_prtName, sub_dbparam,
//						sub_columnName, sub_isNumericColumn,
//						showPrintBox, showPDF, reversePageOrder, paperSize, filePath, fileName);
//				} else {
					// applet print
					// preview to print hardcopy
					print(userInfo, printerName, rptName, map, patcname,
							inparam, columnName, isNumericColumn,
							sub_prtName, sub_dbparam, sub_columnName, sub_isNumericColumn,
							noOfCopies, isExportWd, paperSize, keepPanel, false);
//				}
			}

			@Override
			public void postPrint(boolean success, String result) {
//				System.err.println("[DEEBUG] Report.print postPrint success="+success+", result="+result+", print2Printer="+print2Printer);
				if (success) {
					if (print2Printer) {
						printAction();
					}
				}
				if (callback != null) {
					callback.handleRetBool(success, result, null);
				}
			}
		};

		addParameter(report, userInfo, rptName, map, patcname,
				inparam, columnName, isNumericColumn,
				sub_prtName, sub_dbparam, sub_columnName, sub_isNumericColumn,
				showPrintBox, showPDF, reversePageOrder, paperSize, filePath, fileName);

		if (showPDF) {
			Factory.getInstance().showPanel(report, keepPanel);
		}

		return true;
	}




	private static boolean printHelper(final String prterName, String rptName,
			Map<String, String> map, String patcname,
			String[] inParamArray, String[] columnNameArray, final boolean[] isNumericColumn,
			String[] subRptName,
			String[][] sub_dbParam, String[][] sub_colName, boolean[][]isNumericCol,
			int noOfCopies, String isExportWd, final boolean alertSuccess,
			final String pageSize, String pageOrientation, boolean saveAs, String[] fileType,
			boolean isIgnorePagination) {
		int noOfSub = subRptName == null ? 0 : subRptName.length;
//		if (Factory.getInstance().getMainFrame().isPdfPrint()) {
//			if (map != null) {
//				map.put("pdf-print", (prterName == null || prterName.isEmpty()) ? ConstantsVariable.YES_VALUE : prterName);
//			}
//			DialogPrintReport d = new DialogPrintReport(prterName);
//			d.addParameter(null, rptName, map, inParamArray, columnNameArray,
//					null, subRptName, sub_dbParam,
//					sub_colName, isNumericCol,
//				false,true,false, pageSize, null, rptName);
//			return true;
//		} else {
			StringBuilder mapKey = new StringBuilder();
			StringBuilder mapValue = new StringBuilder();

			for (Map.Entry<String, String> pairs : map.entrySet()) {
				mapKey.append(pairs.getKey());
				mapKey.append(FIELD_DELIMITER);
				mapValue.append(pairs.getValue());
				mapValue.append(FIELD_DELIMITER);
			}

			String inParam = null;
			String columnName = null;

			if (inParamArray != null) {
				inParam = TextUtil.combine(inParamArray);
			}

			if (columnNameArray != null) {
				columnName = TextUtil.combine(columnNameArray);
			}
			String subRptJSONString = formSubRptJSONString(noOfSub, subRptName, sub_dbParam,
															sub_colName, isNumericCol);

			String numOfCopies = Integer.toString(noOfCopies);

			if (Factory.getInstance().getMainFrame().isDisableApplet()) {
				if (fileType != null && "xls".equals(fileType[0].toLowerCase())) {
					((ReportServiceAsync) Registry
							.get(AbstractEntryPoint.REPORT_SERVICE)).print(Factory.getInstance().getUserInfo(),
									rptName, map, patcname,
									inParamArray, columnNameArray, isNumericColumn,
									subRptName, sub_dbParam, sub_colName, isNumericCol,
									noOfCopies, false, true, false,
									EMPTY_VALUE, null, null, null, fileType[0],
									new AsyncCallback<String>() {
								@Override
								public void onSuccess(String result) {
									if (result != null && result.length() > 0) {
										callPrint2Printer(prterName, result);
									}
								}

								@Override
								public void onFailure(Throwable caught) {
									// TODO Auto-generated method stub
								}
							});
				} else {
					System.err.println("[patcname]:"+patcname);
					((ReportServiceAsync) Registry
							.get(AbstractEntryPoint.REPORT_SERVICE)).print(Factory.getInstance().getUserInfo(),
									rptName, map, patcname,
									inParamArray, columnNameArray, isNumericColumn,
									subRptName, sub_dbParam, sub_colName, isNumericCol,
									noOfCopies, false, true, false,
									EMPTY_VALUE, null, null, null, null,
									new AsyncCallback<String>() {
								@Override
								public void onSuccess(String result) {
									if (result != null && result.length() > 0) {
										callPrint2Printer(prterName, result);
									}
								}

								@Override
								public void onFailure(Throwable caught) {
									// TODO Auto-generated method stub
								}
							});
				}
				return true;
			} else {
				return print(prterName, rptName, mapKey.toString(), mapValue.toString(),
						patcname, inParam, columnName, String.valueOf(noOfSub),
						subRptJSONString, EMPTY_VALUE, numOfCopies, isExportWd, alertSuccess,
						pageSize, pageOrientation, String.valueOf(saveAs), Arrays.toString(fileType),
						String.valueOf(isIgnorePagination));
			}
//			}
		}

	private static native boolean print(String prterName,
			String rptName, String mapKey,
			String mapValue, String patcname, String inParam,
			String columnName, String noOfSub, String subRptJSONString,
			String returnJP, String noOfCopies, String isExportWd,
			boolean alertSuccess, String pageSize, String pageOrientation,
			String saveAs, String fileType, String isIgnorePagination) /*-{
		var appletName = @com.hkah.client.util.PrintingUtil::getAppletName()();
		if (appletName == null || appletName == '') {
			alert('Cannot get applet:' + appletName);
		}

		var result = $wnd.getApplet(appletName).getJasperPrint(prterName, rptName, mapKey, mapValue,
											patcname, inParam, columnName, noOfSub,
											subRptJSONString, "-1", false, false, false, false,
											returnJP, "N", noOfCopies, isExportWd,
											pageSize, pageOrientation, saveAs, fileType,
											isIgnorePagination);
		if (result) {
			if (alertSuccess) {
				alert("print successfully!");
			}
		} else {
			alert(result);
			alert("print fail.");
		}
		return result;
	}-*/;

	private static native boolean callPrint2Printer(String prterName, String url) /*-{
		var newUrl = window.location.href;
		var index = newUrl.indexOf('NHS');
		if (index > 0) {
			index = newUrl.indexOf('/', index + 1);
//			alert('1[index]:'+index+';[url]:'+newUrl.substring(0, index) + "/" + url);
			if (index > 0) {
				window.location.href = "NHSClientApp:" + prterName + ":" + newUrl.substring(0, index) + "/" + url;
			}
		} else {
			index = newUrl.indexOf('/', 9);
//			alert('2[index]:'+index+';[url]:'+'NHSClientApp:' + prterName + ":" + newUrl.substring(0, index) + "/" + url);
			if (index > 0) {
				window.location.href = "NHSClientApp:" + prterName + ":" + newUrl.substring(0, index) + "/" + url;
			}
		}
		return true;
	}-*/;

	public static boolean printBatch(final String prterName, String[] rptName,
			Map<String, Map<String, String>>map, String[] patcname,
			String[][] inParamArray, String[][] columnNameArray,
			int[] noOfSub, Map<Integer, String[]>subRptNameMap, Map<Integer, String[][]> sub_dbParamMap,
			Map<Integer,String[][]> sub_colNameMap, Map<Integer, boolean[][]>isNumericColMap,
			boolean[] externalResources, int[] exCodeInParamIndex, boolean[] getExMsgEng, boolean[] getExMsgTRC,
			boolean[] getExMsgSMC, boolean[] returnJP, int[] noOfCopies,
			String[] pageSize, String pageOrientation, final boolean alertSuccess) {

		boolean isNumericColumn[] = null;
		if (Factory.getInstance().getMainFrame().isDisableApplet()) {
			((ReportServiceAsync) Registry
					.get(AbstractEntryPoint.REPORT_SERVICE)).print(Factory.getInstance().getUserInfo(), rptName,
							map, patcname, inParamArray, columnNameArray, isNumericColumn,
							subRptNameMap, sub_dbParamMap, sub_colNameMap, isNumericColMap,
							noOfCopies, false, true, false,
							EMPTY_VALUE, null, null, null, null,
							new AsyncCallback<String>() {
						@Override
						public void onSuccess(String result) {
							if (result != null && result.length() > 0) {
								callPrint2Printer(prterName, result);
							}
						}

						@Override
						public void onFailure(Throwable caught) {
							Factory.getInstance().addInformationMessage("[fail]");
							// TODO Auto-generated method stub
						}
					});
/*
			for (int i = 0; i < rptName.length; i++) {
				if (isNumericColumn == null && columnNameArray != null) {
					isNumericColumn = new boolean[columnNameArray[i].length];
					for (int j = 0; j < columnNameArray[i].length; j++) {
						isNumericColumn[j] = false;
					}
				}

				((ReportServiceAsync) Registry
						.get(AbstractEntryPoint.REPORT_SERVICE)).print(Factory.getInstance().getUserInfo(), getStringValue(rptName, i),
								map.get(Integer.toString(i+1)), getStringValue(patcname, i), getStringArrayValue(inParamArray, i), getStringArrayValue(columnNameArray, i), isNumericColumn,
								getStringArrayValue(subRptNameMap, i), getStringArrayArrayValue(sub_dbParamMap, i), getStringArrayArrayValue(sub_colNameMap, i), getBooleanArrayArrayValue(isNumericColMap, i),
								false, true, false, EMPTY_VALUE,
								null, null, null,
								new AsyncCallback<String>() {
							@Override
							public void onSuccess(String result) {
								if (result != null && result.length() > 0) {
									callPrint2Printer(prterName, result);
								}
							}

							@Override
							public void onFailure(Throwable caught) {
								Factory.getInstance().addInformationMessage("[fail]");
								// TODO Auto-generated method stub
							}
						});
			}
*/
			return true;
		} else {
			String[] mapKeyArray = new String[rptName.length];
			String[] mapValueArray = new String[rptName.length];
			String[] subRptJSONStringArray = new String[rptName.length];
			for (int k = 0; k < rptName.length; k++) {
					StringBuilder mapKey = new StringBuilder();
					StringBuilder mapValue = new StringBuilder();
					for (Map.Entry<String, String> pairs : map.get(Integer.toString(k+1)).entrySet()) {
						mapKey.append(pairs.getKey());
						mapKey.append(FIELD_DELIMITER);
						mapValue.append(pairs.getValue());
						mapValue.append(FIELD_DELIMITER);
					}
					mapKeyArray[k] = mapKey.toString();
					mapValueArray[k] = mapValue.toString();
					if (noOfSub != null) {
						if (noOfSub[k]>0) {
							subRptJSONStringArray[k] = formSubRptJSONString(noOfSub[k],
							subRptNameMap.get(k),
							sub_dbParamMap.get(k),
							sub_colNameMap.get(k),
							isNumericColMap.get(k));
						}
					}

//					String numOfCopies = Integer.toString(noOfCopies[k]);
			}

			String multiRptJSONString = formMultiRptJSONString(
											rptName.length, rptName,patcname, mapKeyArray,
											mapValueArray, inParamArray, columnNameArray,
											noOfSub, subRptJSONStringArray,
											externalResources, exCodeInParamIndex,
											getExMsgEng, getExMsgTRC, getExMsgSMC,
											returnJP, noOfCopies, pageSize, pageOrientation);

			return printBatch(prterName,
					multiRptJSONString,
					Integer.toString(rptName.length), alertSuccess);
		}
	}

	private static String[][] getStringArrayArrayValue(Map<Integer, String[][]> map, int index) {
		if (map != null && map.containsKey(index)) {
			return map.get(index);
		} else {
			return null;
		}
	}

	private static String[] getStringArrayValue(Map<Integer, String[]> map, int index) {
		if (map != null && map.containsKey(index)) {
			return map.get(index);
		} else {
			return null;
		}
	}

	private static String[] getStringArrayValue(String[][] str, int index) {
		if (str != null && str.length > index) {
			return str[index];
		} else {
			return null;
		}
	}

	private static String getStringValue(String[] str, int index) {
		if (str != null && str.length > index) {
			return str[index];
		} else {
			return null;
		}
	}

	private static boolean[][] getBooleanArrayArrayValue(Map<Integer, boolean[][]> map, int index) {
		if (map != null && map.containsKey(index)) {
			return map.get(index);
		} else {
			return null;
		}
	}

	public static native boolean printBatch(
			String prterName, String allRptJSONString, String rptNo,
			boolean alertSuccess) /*-{
		var appletName = @com.hkah.client.util.PrintingUtil::getAppletName()();
		if (appletName == null || appletName == '') {
			alert('Cannot get applet:' + appletName);
		}

		var result = $wnd.getApplet(appletName).getMultiJasperPrint(prterName,allRptJSONString,
											rptNo,"N","1");
		if (result) {
			if (alertSuccess) {
				alert("print successfully!");
			}
		} else {
			alert(result);
			alert("print fail.");
		}
		return result;
	}-*/;

	private static String formSubRptJSONString(int noOfSub, String[] subRptName,
			String[][] sub_dbparam,
			String[][] sub_columnName,
			boolean[][] sub_isNumericColumn) {
		JSONArray subJA = new JSONArray();
		JSONObject mainJO = new JSONObject();
		for (int i=0;i<noOfSub;i++) {
			JSONObject subJO = new JSONObject();
			subJO.put("subRptName", new JSONString(subRptName[i]));
			subJO.put("sub_dbParam", new JSONString(TextUtil.combine(sub_dbparam[i])));
			subJO.put("sub_colName", new JSONString(TextUtil.combine(sub_columnName[i])));
			subJO.put("isNumericCol", new JSONString(TextUtil.booleanArray2String(sub_isNumericColumn[i])));
			subJA.set(i, (JSONValue)subJO);
		}
		mainJO.put("allSub", (JSONValue)subJA);
		return mainJO.toString();
	}

	private static String formMultiRptJSONString(int noOfRpt,
			String[] RptName, String[] rpt_patcname,
			String[] mapKey, String[] mapValue,
			String[][] dbparam, String[][] columnName,
			int[] noOfSub, String[]subRptJSONString,
			boolean[] externalResources, int[] exCodeInParamIndex,
			boolean[] getExMsgEng, boolean[] getExMsgTRC,
			boolean[] getExMsgSMC, boolean[] returnJP, int[] noOfCopies,
			String[] pageSize, String pageOrientation) {

		JSONArray subJA = new JSONArray();
		JSONObject mainJO = new JSONObject();

		for (int i = 0; i < noOfRpt; i++) {
			JSONObject subJO = new JSONObject();
			subJO.put("RptName", new JSONString(RptName[i]));
			if (rpt_patcname != null && rpt_patcname[i] != null) {
				subJO.put("patcname", new JSONString(rpt_patcname[i]));
			}
			subJO.put("mapKey", new JSONString(mapKey[i]));
			subJO.put("mapValue", new JSONString(mapValue[i]));
			subJO.put("inParam", new JSONString(TextUtil.combine(dbparam[i])));
			subJO.put("columnName", new JSONString(TextUtil.combine(columnName[i])));
			if (noOfSub != null) {
				if (noOfSub[i] > 0 ) {
					subJO.put("noOfSub", new JSONString(String.valueOf(noOfSub[i])));
					subJO.put("subRptJSONString", new JSONString(subRptJSONString[i]));
				}
			}
			if (externalResources != null && externalResources.length > 0) {
				if (externalResources[i] == true) {
					subJO.put("externalResources", new JSONString(String.valueOf(externalResources[i])));
					subJO.put("exCodeInParamIndex", new JSONString(String.valueOf(exCodeInParamIndex[i])));
					subJO.put("getExMsgEng", new JSONString(String.valueOf(getExMsgEng[i])));
					subJO.put("getExMsgTRC", new JSONString(String.valueOf(getExMsgTRC[i])));
					subJO.put("getExMsgSMC", new JSONString(String.valueOf(getExMsgSMC[i])));
					subJO.put("returnJP", new JSONString(String.valueOf(returnJP[i])));
				}
			}
			subJO.put("noOfCopies", new JSONString(Integer.toString(noOfCopies[i])));

			if (pageSize != null && pageSize.length > 0) {
				subJO.put("pageSize", new JSONString(String.valueOf(pageSize[i])));
			}

			if (pageOrientation != null) {
				subJO.put("pageOrientation", new JSONString(String.valueOf(pageOrientation)));
			}

			subJA.set(i, (JSONValue)subJO);
		}
		mainJO.put("allRpt", (JSONValue)subJA);
		return mainJO.toString();
	}

	/***************************************************************************
	 * Preview Methods
	 **************************************************************************/

	private void addParameter(ReportPanel report, UserInfo userInfo, String prtName,
			Map<String, String> map, String patcname,
			String[] inparam, String[] columnName, boolean[] isNumericColumn,
			String[] sub_prtName, String[][] sub_dbparam, String[][] sub_columnName, boolean[][] sub_isNumericColumn) {
		addParameter(report, userInfo, prtName, map, patcname,
				inparam, columnName, isNumericColumn,
				sub_prtName, sub_dbparam, sub_columnName, sub_isNumericColumn,
				false, false, false, EMPTY_VALUE, null, null);
	}

	private static void addParameter(final ReportPanel report, final UserInfo userInfo, final String prtName,
			final Map<String, String> map, final String patcname,
			final String[] inparam, final String[] columnName, final boolean[] isNumericColumn,
			final String[] sub_prtName, final String[][] sub_dbparam, final String[][] sub_columnName, final boolean[][] sub_isNumericColumn,
			final boolean showPrintBox, final boolean showPDF, final boolean reversePageOrder, final String paperSize,
			final String printPath, final String fileName) {
		QueryUtil.executeMasterFetch(Factory.getInstance().getUserInfo(), "SYSPARAM",
				new String[] { "RptPnDelay" },
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						// TODO Auto-generated method stub
						if (mQueue.success()) {
							if (map != null) {
								map.put("RptPnDelay", mQueue.getContentField()[1]);
							}
						}
						addParameter2(report, userInfo, prtName, map, patcname,
								inparam, columnName, isNumericColumn,
								sub_prtName, sub_dbparam, sub_columnName, sub_isNumericColumn,
								showPrintBox, showPDF, reversePageOrder, paperSize,
								printPath, fileName);
					}

					public void onFailure(Throwable caught) {
						addParameter2(report, userInfo, prtName, map, patcname,
								inparam, columnName, isNumericColumn,
								sub_prtName, sub_dbparam, sub_columnName, sub_isNumericColumn,
								showPrintBox, showPDF, reversePageOrder, paperSize,
								printPath, fileName);
					}
		});
	}

	private static void addParameter2(final ReportPanel report, final UserInfo userInfo, final String prtName,
			final Map<String, String> map, final String patcname,
			final String[] inparam, final String[] columnName, final boolean[] isNumericColumn, final String[] sub_prtName,
			final String[][] sub_dbparam, final String[][] sub_columnName, final boolean[][] sub_isNumericColumn, final boolean showPrintBox,
			final boolean showPDF, final boolean reversePageOrder, final String paperSize,
			final String printPath, final String fileName) {
		QueryUtil.executeMasterFetch(Factory.getInstance().getUserInfo(), "SYSPARAM",
				new String[] { "rptServer" },
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						// TODO Auto-generated method stub
						if (mQueue.success()) {
							String pathname = com.google.gwt.user.client.Window.Location.getPath().split("/")[1];

							generateReport(report, userInfo, prtName, map, patcname,
									inparam, columnName, isNumericColumn,
									sub_prtName, sub_dbparam, sub_columnName, sub_isNumericColumn,
									showPrintBox, showPDF, reversePageOrder, paperSize, printPath,
									fileName, mQueue.getContentField()[1]+"/"+pathname);
						} else {
							generateReport(report, userInfo, prtName, map, patcname,
									inparam, columnName, isNumericColumn,
									sub_prtName, sub_dbparam, sub_columnName, sub_isNumericColumn,
									showPrintBox, showPDF, reversePageOrder, paperSize, printPath,
									fileName, null);
						}
					}

					public void onFailure(Throwable caught) {
						generateReport(report, userInfo, prtName, map, patcname,
								inparam, columnName, isNumericColumn,
								sub_prtName, sub_dbparam, sub_columnName, sub_isNumericColumn,
								showPrintBox, showPDF, reversePageOrder, paperSize, printPath,
								fileName, null);
					}
		});
	}
/*
	public void addParameter2(final ReportPanel report, final UserInfo userInfo, String prtName,
			Map<String, String> map, String[] inparam, String[] columnName,
			boolean[] isNumericColumn, String sub_prtName[],
			String[][] sub_dbparam, String[][] sub_columnName,
			boolean[][] sub_isNumericColumn) {
		StringBuilder sb = new StringBuilder();
		sb.append("/getreport?prtName=");
		sb.append(prtName);
		sb.append("&mapkey=");
		sb.append(string2Parameter(stringArray2String((String[]) map.keySet().toArray(new String[0]))));
		sb.append("&mapvalue=");
		sb.append(string2Parameter(stringArray2String((String[]) map.values().toArray(new String[0]))));
		sb.append("&inparam=");
		sb.append(string2Parameter(stringArray2String(inparam)));
		sb.append("&columnName=");
		sb.append(string2Parameter(stringArray2String(columnName)));
		sb.append("&isNumericColumn=");
		sb.append(string2Parameter(booleanArray2String(isNumericColumn)));
		for (int i = 0; i < sub_prtName.length; i++) {
			sb.append("&sub_prtName"+String.valueOf((i+1))+"=");
			sb.append(string2Parameter(sub_prtName[i]));
		}
		for (int i = 0; i < sub_dbparam.length; i++) {
			sb.append("&sub_dbparam"+String.valueOf((i+1))+"=");
			sb.append(string2Parameter(stringArray2String(sub_dbparam[i])));
		}
		for (int i = 0; i < sub_columnName.length; i++) {
			sb.append("&sub_columnName"+String.valueOf((i+1))+"=");
			sb.append(string2Parameter(stringArray2String(sub_columnName[i])));
		}
		for (int i = 0; i < sub_isNumericColumn.length; i++) {
			sb.append("&sub_isNumericColumn"+String.valueOf((i+1))+"=");
			sb.append(string2Parameter(booleanArray2String(sub_isNumericColumn[i])));
		}
		sb.append("&noOfSub=");
		sb.append(String.valueOf(sub_prtName.length));
		sb.append("&RptPnDelay=");
		sb.append(map.get("RptPnDelay"));

		report.setReportUrl(sb.toString());
	}

	private String string2Parameter(String str) {
		if (str != null) {
			return str;
		} else {
			return EMPTY_VALUE;
		}
	}

	private String stringArray2String(String[] str) {
		if (str != null) {
			return TextUtil.combine(str);
		} else {
			return null;
		}
	}

	private String booleanArray2String(boolean[] str) {
		if (str != null) {
			String[] returnStr = new String[str.length];
			for (int i = 0; i < str.length; i++) {
				returnStr[i] = str[i]?"TRUE":"FALSE";
			}
			return stringArray2String(returnStr);
		} else {
			return null;
		}
	}
*/
	private static void generateReport(final ReportPanel report, final UserInfo userInfo, String prtName,
			Map<String, String> map, String patcname,
			String[] inparam, String[] columnName, boolean[] isNumericColumn,
			String[] sub_prtName, String[][] sub_dbparam, String[][] sub_columnName, boolean[][] sub_isNumericColumn,
			boolean showPrintBox, final boolean showPDF, boolean reversePageOrder, String paperSize,
			String printPath, final String fileName, String rptServer) {
		// DEBUG
		String debugLog = "inparam: " +
				"userInfo="+userInfo+", prtName="+prtName+", map="+map+", patcname="+patcname+", inparam="+Arrays.toString(inparam)+
				", columnName="+Arrays.toString(columnName)+", isNumericColumn="+Arrays.toString(isNumericColumn)+", sub_prtName="+Arrays.toString(sub_prtName)+
				", sub_dbparam="+Arrays.toString(sub_dbparam)+", sub_columnName="+Arrays.toString(sub_columnName)+", sub_isNumericColumn="+Arrays.toString(sub_isNumericColumn)+
				", showPrintBox="+showPrintBox+", showPDF="+showPDF+", reversePageOrder="+reversePageOrder+
				", paperSize="+paperSize+", printPath="+printPath+", fileName="+fileName+", rptServer="+rptServer;

		Factory.getInstance().writeLogToLocal("[ReportPanel.generateReport] print "+debugLog);

		((ReportServiceAsync) Registry
				.get(AbstractEntryPoint.REPORT_SERVICE)).print(userInfo,
						prtName, map, patcname,
						inparam, columnName, isNumericColumn,
						sub_prtName, sub_dbparam, sub_columnName, sub_isNumericColumn,
						1, showPrintBox, showPDF, reversePageOrder,
						paperSize, printPath, fileName, rptServer, null,
						new AsyncCallback<String>() {
					@Override
					public void onSuccess(String result) {
						if (result != null && result.length() > 0) {
							if (showPDF) {
								report.setReportUrl(result);
							} else {
								if (fileName != null && fileName.length() > 0) {
									if (!"APPBILL".equals(fileName)){
										Factory.getInstance().addInformationMessage("Printed.");
									}
								} else {
									Factory.getInstance().addInformationMessage("Printed.");
								}
//								setRportonDialog(result);
							}
						} else {
							Factory.getInstance().addErrorMessage("No data for the report.",
									new Listener<MessageBoxEvent>() {
										@Override
										public void handleEvent(
												MessageBoxEvent be) {
											// TODO Auto-generated method stub
											report.exitPanel();
										}
							});
						}
						report.postPrint(true, result);
					}

					@Override
					public void onFailure(Throwable caught) {
						Factory.getInstance().addErrorMessage(caught.getMessage());
						caught.printStackTrace();

						report.postPrint(false, caught.getMessage());
					}
				});
	}
}