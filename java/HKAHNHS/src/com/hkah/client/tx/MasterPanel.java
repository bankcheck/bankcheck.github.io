/*
 * Created on 2011-04-06
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.tx;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.widget.Component;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.table.GeneralGridCellRenderer;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.util.AlertCheck;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public abstract class MasterPanel extends MasterPanelBase implements ConstantsMessage {

	private boolean isLCDInitial = false;
	private AlertCheck alertCheck = null;

	protected String memAcmCode = null;
	protected String memBedCode = null;
	protected ArrayList<String> colKey = null;
	protected TableList addEntryTable = null;

	public MasterPanel() {
		super();
	}

	public MasterPanel(boolean hasLeftPanel) {
		super(hasLeftPanel);
	}

	public MasterPanel(String layoutMode) {
		super(layoutMode);
	}

	@Override
	protected GeneralGridCellRenderer[] getActionCellRenderer() {
		return getColumnRenderer();
	};

	/* >>> ~4b~ Set Table Column Cell Renderer ========================== <<< */
	protected GeneralGridCellRenderer[] getColumnRenderer() {
		return null;
	}

	/***************************************************************************
	* Create Instance Method
	**************************************************************************/

	protected AlertCheck getAlertCheck() {
		if (alertCheck == null) {
			alertCheck = new AlertCheck();
		}
		return alertCheck;
	}

	/***************************************************************************
	 * Error Message Methods
	 **************************************************************************/

	protected void addErrorMessage(String message) {
		Factory.getInstance().addErrorMessage(message, "PBA-[" + getTitle() + "]");
	}

	protected void addErrorMessage(String message, Component comp) {
		Factory.getInstance().addErrorMessage(message, "PBA-[" + getTitle() + "]", comp);
	}

	/***************************************************************************
	 * LCD Display Methods
	 **************************************************************************/

	protected void doLCDInitial() {
		if (getUserInfo().isCashier() && !isLCDInitial && YES_VALUE.equals(getSysParameter("AllowLCD"))) {
			isLCDInitial = true;
			doLCDInitialHelper();
		}
	}

	private native void doLCDInitialHelper() /*-{
		$wnd.getApplet("HKAHNHSApplet").doLCDInitial("COM1");
	}-*/;

	protected void doLCDDisplay(String line1, String line2) {
		if (getUserInfo().isCashier() && YES_VALUE.equals(getSysParameter("AllowLCD"))) {
			doLCDInitial();
			doLCDDisplayHelper(line1, line2);
		}
	}

	private native void doLCDDisplayHelper(String line1, String line2) /*-{
		$wnd.getApplet("HKAHNHSApplet").doLCDDisplay("COM1", line1, line2, "Y", "N");
	}-*/;

	/***************************************************************************
	 * Asychronize Methods
	 **************************************************************************/

	protected void canProceed() {
		canProceed(null, false);
	}

	protected void canProceed(String actionType) {
		canProceed(actionType, false);
	}

	protected void canProceed(final String actionType, boolean isDayend) {
		QueryUtil.executeTx(getUserInfo(), "CHK_CANPROCEED",
				new String[] { getUserInfo().getSiteCode(), isDayend ? ConstantsVariable.YES_VALUE:ConstantsVariable.NO_VALUE },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue != null) {
					canProceedReady(actionType, mQueue.success());
				} else {
					canProceedReady(actionType, false);
				}
			}
		});
	}

	protected void canProceedReady(boolean isProceedReady) {
		// implement in child class
	}

	protected void canProceedReady(String actionType, boolean isProceedReady) {
		// implement in child class
		canProceedReady(isProceedReady);
	}

	// synchronize call
	public String getSysParameter(String parcde) {
		return getMainFrame().getSysParameter(parcde);
	}

	protected TableList getAddEntryTable() {
		if (addEntryTable == null) {
			addEntryTable = new TableList(getAddEntryColumnNames(), getAddEntryColumnWidths()) {
				@Override
				public void postSaveTable(boolean success, Integer rtnCode,
						String rtnMsg) {
					postSaveAddEntryTable(success, rtnCode, rtnMsg);
				}
			};
		}
		return addEntryTable;
	}

	private String[] getAddEntryColumnNames() {
		return new String[] {
				"SlipNo",				// 00
				"ItemCode",				// 01
				"ItemType",				// 02
				"EntryType",			// 03
				"StnOAmt",				// 04
				"StnBAmt",				// 05
				"DoctorCode",			// 06
				"ReportLevel",			// 07
				"AccomodationCode",		// 08
				"Discount",				// 09
				"PackageCode",			// 10
				"capturedate",			// 11
				"TransactionDate",		// 12
				"Description",			// 13
				"Status",				// 14
				"GlcCode",				// 15
				"ReferenceID",			// 16
				"CashierClosed",		// 17
				"BedCode",				// 18
				"dixref",               // 19
				"flagToDi",				// 20
				"ConPceSetFlag",		// 21
				"Cpsid",				// 22
				"as_unit",				// 23
				"Stndesc1",				// 24
				"IRefNo"				// 25
		};
	}

	protected int[] getAddEntryColumnWidths() {
		return new int[] {
				0,0,0,0,0,0,0,0,0,0,
				0,0,0,0,0,0,0,0,0,0,
				0,0,0,0,0,0
		};
	}

	protected void postSaveAddEntryTable(boolean success, Integer rtnCode,
			String rtnMsg) {
		// override for the child class
	}

	public void AddEntryReady(String slpNo, String entry) {}

	public void AddEntry(final String SlipNo, String ItemCode, String ItemType,
							String EntryType, String StnOAmt, String StnBAmt,
							String DoctorCode, String ReportLevel,
							String AccomodationCode, String Discount,
							String PackageCode, String capturedate,
							String TransactionDate, String Description,
							String Status, String GlcCode, String ReferenceID,
							boolean CashierClosed, String BedCode, String dixref,
							boolean flagToDi, String ConPceSetFlag, String Cpsid,
							String as_unit, String Stndesc1, String IRefNo) {
		String txCode = "ADDENTRY";
		String[] para = new String[] {
				  SlipNo      ,
				  ItemCode    ,
				  ItemType    ,
				  EntryType   ,
				  StnOAmt.trim().length()==0?"0":StnOAmt,
				  StnBAmt.trim().length()==0?"0":StnBAmt,
				  DoctorCode  ,
				  ReportLevel ,
				  AccomodationCode  ,
				  Discount.trim().length()==0?"0":Discount,
				  PackageCode ,
				  capturedate ,
				  TransactionDate,
				  Description ,
				  Status      ,
				  GlcCode     ,
				  ReferenceID ,
				  CashierClosed?MINUS_ONE_VALUE:ZERO_VALUE, //-1-true,0-false
				  BedCode     ,
				  dixref      ,
				  flagToDi?MINUS_ONE_VALUE:ZERO_VALUE, //-1-true,0-false
				  ConPceSetFlag,
				  Cpsid       ,
				  as_unit     ,
				  Stndesc1    ,
				  IRefNo,
				  getUserInfo().getUserID()
		};
		QueryUtil.executeMasterAction(
				getUserInfo(), txCode, QueryUtil.ACTION_APPEND, para, new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							AddEntryReady(SlipNo, mQueue.getReturnCode());
						} else {
							AddEntryReady(SlipNo, EMPTY_VALUE);
						}
					}
				});
	}

	public void AddPackageEntryReady(String slpNo, String entry) {}

	public void AddPackageEntry(final String SlipNo, String PackageCode,
								String ItemCode, String StnOAmt, String StnBAmt,
								String DoctorCode, String ReportLevel,
								String AccomodationCode, String capturedate,
								String TransactionDate, String Description,
								String Status, boolean CashierClosed,
								String BedCode, String dixref, boolean flagToDi,
								String ConPceSetFlag, String UnitAmt, String Stndesc1,
								String IRefNo, boolean isPkgcodeInLkUpGlccode) {
		String txCode = "ADDPKGENTRY";
		String[] para = new String[] {
				  SlipNo      ,
				  PackageCode ,
				  ItemCode    ,
				  StnOAmt.trim().length()==0?"0":StnOAmt,
				  StnBAmt.trim().length()==0?"0":StnBAmt,
				  DoctorCode  ,
				  ReportLevel ,
				  AccomodationCode  ,
				  capturedate ,
				  TransactionDate,
				  Description ,
				  Status      ,
				  //CashierClosed?MINUS_ONE_VALUE:ZERO_VALUE, //-1-true,0-false
				  BedCode     ,
				  dixref      ,
				  flagToDi?MINUS_ONE_VALUE:ZERO_VALUE, //-1-true,0-false
				  ConPceSetFlag,
				  UnitAmt     ,
				  Stndesc1    ,
				  IRefNo	  ,
				  //vDeptCode	  ,
				  //vGlcCode	  ,
				  isPkgcodeInLkUpGlccode?MINUS_ONE_VALUE:ZERO_VALUE, //-1-true,0-false
				  getUserInfo().getUserID()
		};
		QueryUtil.executeMasterAction(
				getUserInfo(), txCode, QueryUtil.ACTION_APPEND, para, new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					AddPackageEntryReady(SlipNo, mQueue.getReturnCode());
				} else {
					AddPackageEntryReady(SlipNo, EMPTY_VALUE);
				}
			}
		});
	}

	protected void lockRecord(final String lockType, final String lockKey) {
		lockRecord(lockType, lockKey, null);
	}

	protected void lockRecord(final String lockType, final String lockKey, final String[] record) {
		QueryUtil.executeMasterAction(getUserInfo(), "RECORDLOCK",
				QueryUtil.ACTION_APPEND, new String[] { lockType, lockKey, CommonUtil.getComputerName(), getUserInfo().getUserID() },
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				lockRecordReady(lockType, lockKey, record, mQueue.success(), mQueue.getReturnMsg());
			}
		});
	}

	protected void lockRecordReady(final String lockType, final String lockKey, String[] record, boolean lock) {}

	protected void lockRecordReady(final String lockType, final String lockKey, String[] record, boolean lock, String returnMessage) {
		lockRecordReady(lockType, lockKey, record, lock);
	}

	protected void unlockRecord(final String lockType, final String lockKey) {
		unlockRecord(lockType, lockKey, null);
	}

	protected void unlockRecord(final String lockType, final String lockKey, final String[] record) {
		QueryUtil.executeMasterAction(getUserInfo(), "RECORDUNLOCK",
				QueryUtil.ACTION_APPEND, new String[] { lockType, lockKey, CommonUtil.getComputerName(), getUserInfo().getUserID() },
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				unlockRecordReady(lockType, lockKey, record, mQueue.success(), mQueue.getReturnMsg());
			}
		});
	}

	protected void unlockRecordReady(final String lockType, final String lockKey, String[] record, boolean unlock, String returnMessage) {}

	public void IsCashierClosedReady(boolean ready) {}

	public void IsCashierClosed(String CashierTransactionID) {
		if (getUserInfo().isCashier()) {
			QueryUtil.executeMasterAction(getUserInfo(), "ISCASHIERCLOSED", QueryUtil.ACTION_APPEND,
					new String[] { CashierTransactionID, getUserInfo().getCashierCode() },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(final MessageQueue mQueue) {
					IsCashierClosedReady(mQueue.success());
				}
			});
		}
	}

	/***************************************************************************
	 * Helper Methods
	 **************************************************************************/

	private void initColKey() {
		colKey = new ArrayList<String>();

		for (int i = 0; i < 10; i++) {
			colKey.add(String.valueOf(i));
		}

		for (int i = 65; i < 91; i++) {
			colKey.add(String.valueOf(((char)i)));
		}

		colKey.add("-");
		colKey.add(".");
		colKey.add(" ");
		colKey.add("$");
		colKey.add("/");
		colKey.add("+");
		colKey.add("%");
	}

	protected boolean isDisableFunction(String fscKey) {
		return getMainFrame().isDisableFunction(fscKey);
	}

	protected boolean isDisableFunction(String fscKey, String fscParent) {
		return getMainFrame().isDisableFunction(fscKey, fscParent);
	}

//	protected String getCheckCode(String patNo) {
//		int key = calculatePatNo(patNo);
//
//		if (colKey == null) {
//			initColKey();
//		}
//
//		String checkCode = "0";
//		try {
//			checkCode = colKey.get(key);
//		} catch (Exception e) {
//
//		}
//		return checkCode;
//	}

//	private int calculatePatNo(String patNo) {
//		int sum = 0;
//
//		if (patNo != null && patNo.length() > 0) {
//			for (int i = 0; i < patNo.length(); i++) {
//				sum += Integer.parseInt(String.valueOf(patNo.charAt(i)));
//			}
//		}
//
//		return sum%43;
//	}

	protected String calFurGrtAmt(String value) {
		String sFurGrtAmt = ZERO_VALUE;
		String fgamtRate = getSysParameter("FGAMTRATE");

		try {
			if (!value.isEmpty() && !"NULL".equals(fgamtRate) && !"EMPTY".equals(fgamtRate) && !"NIL".equals(fgamtRate)) {
				// use bigdecimal to handle rounding
				BigDecimal amount = (new BigDecimal(value))
						.multiply(new BigDecimal(fgamtRate))
						.divide(new BigDecimal(100), BigDecimal.ROUND_HALF_EVEN);
				sFurGrtAmt = String.valueOf(amount.intValue());
			}
		} catch (Exception e) {}
		return sFurGrtAmt;
	}

	protected String calFurGrtDate(String value) {
		String sFurGrtDate = EMPTY_VALUE;
		String fgpreDays = getSysParameter("FGPREDAYS");

		try {
			if (!value.isEmpty() && !"NULL".equals(fgpreDays) && !"EMPTY".equals(fgpreDays) && !"NIL".equals(fgpreDays)) {
				sFurGrtDate = DateTimeUtil.getRollDate(value, Integer.parseInt(fgpreDays) * -1);
			}
		} catch (Exception e) {}
		return sFurGrtDate;
	}

	protected void writeLog(String module, String logAction, String remark) {
		Factory.getInstance().writeLog(module, logAction, remark);
	}

	@Override
	protected void performList(final boolean showMessage) {
		if (isNoListDB() && browseValidation()) {
			Factory.getInstance().writeLogToLocal("[MasterPanel] Call perform list......");
			Factory.getInstance().writeLogToLocal("[MasterPanel] TxCode: "+getTxCode());
		}
		super.performList(showMessage);
	}

	@Override
	public void performListCallBackPost(MessageQueue mQueue) {
		super.performListCallBackPost(mQueue);
		Factory.getInstance().writeLogToLocal("[MasterPanel] TxCode: "+getTxCode());
		Factory.getInstance().writeLogToLocal("[MasterPanel] performListCallBackPost......");
	}

	protected boolean printDepositReceipt(String slpno, String lang, String itemDesc,
										String desc, String chiDesc, String txnDate,
										String amount, String isCopy,String txnDateLong) {
		Map<String,String> map = new HashMap<String,String>();
		map.put("ITEM_DESC", itemDesc);
		map.put("DESC", desc);
		map.put("CDESC", chiDesc);
		map.put("TXDATE", txnDate);
		map.put("AMOUNT", amount);
		map.put("ISCOPY", isCopy);
		map.put("watermark", CommonUtil.getReportImg("copy_watermark.gif"));
		map.put("DOCBKGCPY",Factory.getInstance().getSysParameter("DOCBKGCPY"));
		map.put("SUBREPORT_DIR", CommonUtil.getReportDir());
		map.put("AppIOSQRImg",CommonUtil.getReportImg("AppIOSQRCode.png"));
		map.put("AppAndImg",CommonUtil.getReportImg("AppAndQRCode.png"));
		map.put("isShwPromo",Factory.getInstance().getSysParameter("isShwPromo"));

		Factory.getInstance().addRequiredReportDesc(map,
			new String[] {
				"MapLanguage", "MapLanguage", "MapLanguage",
				"MapLanguage", "MapLanguage", "MapLanguage",
				"MapLanguage", "MapLanguage", "MapLanguage",
				"MapLanguage","MapLanguage","MapLanguage"
			},
			new String[] {
				"Deposit", "PatNo", "PatName", "TreDr", "BillNo","Date",
				"Item", "Amount", "Copy", "Page", "HKD","OpTreDr"
			},
			lang);

		String paperSize = Factory.getInstance().getSysParameter("DpPgSizeT");
		String printerName = EMPTY_VALUE;
		if (paperSize != null && paperSize.length() > 0) {
			printerName = "HATS_"+paperSize;
		} else {
			printerName = "DEFAULT";
		}
		String reportName = EMPTY_VALUE;
		if (HKAH_VALUE.equals(getUserInfo().getSiteCode())) {
			reportName = "Deposit_"+HKAH_VALUE;
		} else {
			map.put("TXDATELG", txnDateLong.substring(0,txnDateLong.length()-9));
			reportName = "Deposit";
		}

		return PrintingUtil.print(printerName, reportName, map, EMPTY_VALUE,
				new String[] { slpno },
				new String[] {
					"SLPNO", "PATNO", "PATNAME",
					"PATCNAME", "DOCNAME", "DOCCNAME", "CURDATE"
				},
				0, null, null, null, null, 1,
				Factory.getInstance().getSysParameter("DpPgSizeT"));
	}
}