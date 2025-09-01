package com.hkah.client.layout.dialog;

import java.util.Date;
import java.util.Map;

import com.google.gwt.user.client.Timer;
import com.google.gwt.user.client.ui.Frame;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.shared.util.UrlUtil;

public class DialogPrintReport extends DialogBase {
	
    private final static int m_frameWidth = 265;
    private final static int m_frameHeight = 140;
    
    private BasePanel panel = null;
	private LabelBase printSuccess = null;
	private LabelBase printerNameLabel = null;
	private TextString printerName = null;
    private Frame frame = new Frame();
    
	/**
	 * This method initializes
	 *
	 */
	public DialogPrintReport(String printerName) {
		super(null, OK, m_frameWidth, m_frameHeight);
		getPrinterName().setText(printerName);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Printing");
		setContentPane(getPanel());
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/
	
	public void showDialog(String url) {
		showDialog(url, false);
	}

	public void showDialog(String url, boolean isShowDialog) {
		// set url delay to avoid client retrieve faster than server pdf render
		Map<String, Object> params = UrlUtil.encapUrlQueryParams(url);
		String RptPnDelay = (String) params.get("RptPnDelay");
		int delayMillis = 0;
		if (RptPnDelay != null) {
			try {
				delayMillis = Integer.parseInt(RptPnDelay);
			} catch (Exception e) {
			}
		}
		
		if (url.indexOf("?") > -1) {
			url += "&t=" + (new Date()).getTime();
		}
		else {
			url += "?t=" + (new Date()).getTime();
		}
		
		final String url2 = url;
		if (delayMillis > 0) {
			Timer timer = new Timer() {
			      public void run() {
			    	  frame.setUrl(url2);
			      }
			    };
			timer.schedule(delayMillis);
		} else {
			frame.setUrl(url2);
		}
		frame.setPixelSize(100, 100);
		getPanel().add(frame, null);
		if (!isShowDialog) {
			setVisible(true);
		}
	    dispose();
	}
	
	@Override
	protected void doOkAction() {
		dispose();
	}
	
	/***************************************************************************
	* Layout Method
	**************************************************************************/

	/**
	 * This method initializes panel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getPanel() {
		if (panel == null) {
			panel = new BasePanel();
			panel.add(getPrintSuccessLabel(), null);
			panel.add(getPrinterNameLabel(), null);
			panel.add(getPrinterName(), null);
		}
		return panel;
	}
	
	private LabelBase getPrintSuccessLabel() {
		if (printSuccess == null) {
			printSuccess = new LabelBase();
			printSuccess.setBounds(20, 5, 100, 20);
			printSuccess.setText("Print successfully");
		}
		return printSuccess;
	}
	
	private LabelBase getPrinterNameLabel() {
		if (printerNameLabel == null) {
			printerNameLabel = new LabelBase();
			printerNameLabel.setBounds(20, 30, 30, 20);
			printerNameLabel.setText("Printer");
		}
		return printerNameLabel;
	}
	
	private TextString getPrinterName() {
		if (printerName == null) {
			printerName = new TextString(50);
			printerName.setBounds(60, 30, 160, 20);
			printerName.setEditable(false);
		}
		return printerName;
	}
	
	//====================
/*	
	public void addParameter(final UserInfo userInfo, String prtName,
			Map<String, String> map, String[] inparam, String[] columnName,
			boolean[] isNumericColumn, String[] sub_prtName,
			String[][] sub_dbparam, String[][] sub_columnName,
			boolean[][] sub_isNumericColumn) {
		addParameter(userInfo, prtName, map, inparam, columnName, isNumericColumn,
						sub_prtName, sub_dbparam, sub_columnName, sub_isNumericColumn,
						false, false, false, "", null, null);
	}
	
	public void addParameter(final UserInfo userInfo, final String prtName,
			final Map<String, String> map, final String[] inparam, final String[] columnName,
			final boolean[] isNumericColumn, final String[] sub_prtName,
			final String[][] sub_dbparam, final String[][] sub_columnName,
			final boolean[][] sub_isNumericColumn,final boolean showPrintBox,
			final boolean showPDF, final boolean reversePageOrder, final String paperSize,
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
						addParameter2(userInfo, prtName, map, inparam, columnName, isNumericColumn,
								sub_prtName, sub_dbparam, sub_columnName, sub_isNumericColumn,
								showPrintBox, showPDF, reversePageOrder, paperSize, printPath, fileName);
					}
					
					public void onFailure(Throwable caught) {
						addParameter2(userInfo, prtName, map, inparam, columnName, isNumericColumn,
								sub_prtName, sub_dbparam, sub_columnName, sub_isNumericColumn,
								showPrintBox, showPDF, reversePageOrder, paperSize, printPath, fileName);
					}
		});
	}

	protected void addParameter2(final UserInfo userInfo, final String prtName,
			final Map<String, String> map, final String[] inparam, final String[] columnName,
			final boolean[] isNumericColumn, final String[] sub_prtName,
			final String[][] sub_dbparam, final String[][] sub_columnName,
			final boolean[][] sub_isNumericColumn,final boolean showPrintBox,
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
							
							generateReport(userInfo, prtName, map, inparam, columnName,
									isNumericColumn, sub_prtName, sub_dbparam, 
									sub_columnName, sub_isNumericColumn, showPrintBox,
									showPDF, reversePageOrder, paperSize, printPath, 
									fileName, mQueue.getContentField()[1]+"/"+pathname);
						}
						else {
							generateReport(userInfo, prtName, map, inparam, columnName,
									isNumericColumn, sub_prtName, sub_dbparam, 
									sub_columnName, sub_isNumericColumn, showPrintBox,
									showPDF, reversePageOrder, paperSize, printPath, 
									fileName, null);	
						}
					}
					
					public void onFailure(Throwable caught) {
						generateReport(userInfo, prtName, map, inparam, columnName,
										isNumericColumn, sub_prtName, sub_dbparam, 
										sub_columnName, sub_isNumericColumn, showPrintBox,
										showPDF, reversePageOrder, paperSize, printPath, 
										fileName, null);	
					}
		});
	}
	
	private void generateReport(final UserInfo userInfo, String prtName,
			Map<String, String> map, String[] inparam, String[] columnName,
			boolean[] isNumericColumn, String[] sub_prtName,
			String[][] sub_dbparam, String[][] sub_columnName,
			boolean[][] sub_isNumericColumn,boolean showPrintBox,
			final boolean showPDF, boolean reversePageOrder, String paperSize,
			String printPath, String fileName, String rptServer) {
		// DEBUG
		String debugLog = "inparam: " + 
				"userInfo="+userInfo+", prtName="+prtName+", map="+map+", inparam="+Arrays.toString(inparam)+
				", columnName="+Arrays.toString(columnName)+", isNumericColumn="+Arrays.toString(isNumericColumn)+", sub_prtName="+Arrays.toString(sub_prtName)+
				", sub_dbparam="+Arrays.toString(sub_dbparam)+", sub_columnName="+Arrays.toString(sub_columnName)+", sub_isNumericColumn="+Arrays.toString(sub_isNumericColumn)+
				", showPrintBox="+showPrintBox+", showPDF="+showPDF+", reversePageOrder="+reversePageOrder+
				", paperSize="+paperSize+", printPath="+printPath+", fileName="+fileName+", rptServer="+rptServer;
		Factory.getInstance().writeLogToLocal("[ReportPanel.generateReport] print "+debugLog);
		
		((ReportServiceAsync) Registry
				.get(AbstractEntryPoint.REPORT_SERVICE)).print(userInfo, prtName, 
						map, inparam, columnName, isNumericColumn,
						sub_prtName, sub_dbparam, sub_columnName, sub_isNumericColumn,
						showPrintBox,showPDF, reversePageOrder, paperSize, 
						printPath, fileName, rptServer,
						new AsyncCallback<String>() {
					@Override
					public void onSuccess(String result) {
						if (result != null && result.length() > 0) {
							if(showPDF){
								//System.err.println("ReportPanel: "+result);
								showDialog(result);
							} else {
								Factory.getInstance().addInformationMessage("Printed.");
//								setRportonDialog(result);
							}
						} else {
							Factory.getInstance().addErrorMessage("No data for the report.", 
									new Listener<MessageBoxEvent>() {
										@Override
										public void handleEvent(
												MessageBoxEvent be) {
											// TODO Auto-generated method stub
											//exitPanel();
										}
							});
						}
						//postPrint(true, result);	// ReportPanel.java
						System.out.println("[RD] generateReport onSuccess result=" + result);
					}

					@Override
					public void onFailure(Throwable caught) {
						Factory.getInstance().addErrorMessage(caught.getMessage());
						caught.printStackTrace();
						
						//postPrint(false, caught.getMessage());	// ReportPanel.java
						System.out.println("[RD] generateReport onFailure: " + caught.getMessage());
					}
				});
	}
	
	public void addParameter2(final UserInfo userInfo, String prtName,
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
		
		showDialog(sb.toString());
	}
	
	private String string2Parameter(String str) {
		if (str != null) {
			return str;
		} else {
			return "";
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
}