/*
 * Created on 2019-01-30
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.tx;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.MessageBox;
import com.extjs.gxt.ui.client.widget.ProgressBar;
import com.google.gwt.user.client.Timer;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.dialog.DlgAddress;
import com.hkah.client.layout.dialog.DlgCardInfo;
import com.hkah.client.layout.dialog.DlgCardInfo_Octopus;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsCashiers;
import com.hkah.shared.constants.ConstantsSpectra;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;
import com.hkah.shared.model.UserInfo;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public abstract class MasterPaymentPanel extends MasterPanel implements ConstantsSpectra, ConstantsCashiers {

	protected final static String CASHTX_METHODCODE_CASH = "01";
	protected final static String CASHTX_METHODCODE_CHEQUE = "03";
	protected final static String TXN_REFUND_ITMCODE = "REF";

	private final static String TXTYPE_CODE_ALIPAY = "a";
	private final static String TXTYPE_DESC_ALIPAY = "ALIPAY";
	private final static String TXTYPE_CODE_WECHATPAY = "w";
	private final static String TXTYPE_DESC_WECHATPAY = "WECHATPAY";

	private final static String INPUT_TIMEOUT = "INPUT TIMEOUT";
	private final static int ECR_WAIT_TIME_HKAH = 60;
	private final static int ECR_WAIT_TIME_TWAH = 120;

	protected static Timer memPre_ECRTimer = null;
	protected static Timer memPre_VOIDTimer = null;
	protected static String memPre_returnMsg = null;

	protected String memPre_cardTxType = null;
	protected String memPre_cashierTransactionID = null;
	protected String memPre_actionType = null;
	protected String memPre_actionDescription = null;
	protected String memPre_txnType = null;
	protected String memPre_paymentType = null;
	protected String memPre_methodCode = null;
	protected static String memPre_slipNo = null;
	protected String memPre_slipSeq = null;
	protected String memPre_ctnID = null;
	protected String memPre_ctxTrace = null;

	protected String memPaymentType = null;
	protected String memPayee = null;
	protected String memPatAddr1 = null;
	protected String memPatAddr2 = null;
	protected String memPatAddr3 = null;
	protected String memCountry = null;
	protected String memReason = null;
	protected String memPaymentAmount = null;

	protected boolean memS9000YN = false;
	protected String memTmpReceiptNumber = null;
	protected String memTxnType = null;
	protected String memTxnEcrRef = null;
	protected String memTxnAmount = null;
	protected String memTxnRespCode = null;
	protected String memTxnRespText = null;
	protected String memTxnDateTime = null;
	protected String memTxnCardType = null;
	protected String memTxnCardNo = null;
	protected String memTxnExpiryDate = null;
	protected String memTxnCardHolder = null;
	protected String memTxnTerminalNo = null;
	protected String memTxnMerchantNo = null;
	protected String memTxnStoreNo = null;
	protected String memTxnTraceNo = null;
	protected String memTxnBatchNo = null;
	protected String memTxnAppCode = null;
	protected String memTxnRefNo = null;
	protected String memTxnRRNo = null;
	protected String memTxnVDate = null;
	protected String memTxnDAccount = null;
	protected String memTxnAResp = null;
//	protected String memCUPPassword = null;

	public final static String CASHTX_PAYTYPE_CHEQUE = "Q";
	public final static String CASHTX_STS_NORMAL = "N";
	public final static String CASHTX_STS_REVERSE = "R";
	public final static String CASHTX_STS_VOID = "V";
	public final static String CASHTX_STS_REFUNDED = "F";
	public final static String CARDTX_STS_INITIAL = "I";
	public final static String CARDTX_STS_NORMAL = "N";
	public final static String CASHTX_TXNTYPE_RECEIVE = "R";

	protected DlgAddress dlgAddress = null;
	private DlgCardInfo_Octopus dlgCardInfo_Octopus = null;
	private DlgCardInfo dlgCardInfo = null;
//	private DlgVoidCUPPwd dlgVoidCUPPwd = null;

//	private String cashiervoidentry = EMPTY_VALUE;
//	private String CtnID = null;
//	private String GType = null;
//	private boolean CardError = false;
//	private String type = null;
//	private String[] rs = null;

	@Override
	public void postAction() {
		// for parent class call
		super.postAction();
		if (Factory.getInstance().getMainFrame().isDisableApplet()) {
			startWebsocket();
		}
	}

	@Override
	protected void proExitPanel() {
		// for parent class call
		super.proExitPanel();
		if (Factory.getInstance().getMainFrame().isDisableApplet()) {
//			stopWebsocket();
		}
	}

	/***************************************************************************
	 * Dialog Methods
	 **************************************************************************/

	public DlgAddress getDlgAddress() {
		if (dlgAddress == null) {
			dlgAddress = new DlgAddress(getMainFrame()) {
				@Override
				protected void post(String actionType, String strPayee, String strAdd1, String strAdd2, String strAdd3,
						String strCountry, String strReason) {
					super.post(actionType, strPayee, strAdd1, strAdd2, strAdd3, strCountry, strReason);
					memPayee = strPayee;
					memPatAddr1 = strAdd1;
					memPatAddr2 = strAdd2;
					memPatAddr3 = strAdd3;
					memCountry = strCountry;
					memReason = strReason;

					if (memPayee != null && memPayee.trim().length() > 0) {
						actionValidationReady(actionType, true);
					} else {
//						Factory.getInstance().addErrorMessage(MSG_DEPOSIT_REFUND_FAIL);
						actionValidationReady(actionType, false);
					}
				}
			};
		}
		return dlgAddress;
	}

	public DlgCardInfo_Octopus getDlgCardInfo_Octopus() {
		if (dlgCardInfo_Octopus == null) {
			dlgCardInfo_Octopus = new DlgCardInfo_Octopus(getMainFrame()) {
				@Override
				public void post(String actionType, String actionDescription, boolean confirmed, String cardNo, String transactionDateTime) {
					super.post(actionType, actionDescription, confirmed, cardNo, transactionDateTime);
					if (confirmed) {
						memTxnCardNo = cardNo;
						memTxnDateTime = transactionDateTime;
						actionValidationReady(actionType, true);
					} else {
						Factory.getInstance().addErrorMessage(actionDescription + " Fail.");
						actionValidationReady(actionType, false);
					}
				}
			};
		}
		return dlgCardInfo_Octopus;
	}

	public DlgCardInfo getDlgCardInfo() {
		if (dlgCardInfo == null) {
			dlgCardInfo = new DlgCardInfo(getMainFrame()) {
				@Override
				public void post(String actionType, String actionDescription,
						boolean confirmed, String terminalNo, String merchantNo, String cardType,
						String cardNo, String batchNo, String traceNo, String ecrRef, String appCode,
						String refNo, String transactionDateTime, String expiryDate) {
					super.post(actionType, actionDescription,
							confirmed, terminalNo, merchantNo, cardType,
							cardNo, batchNo, traceNo, ecrRef, appCode,
							refNo, transactionDateTime, expiryDate);
					if (confirmed) {
						memTxnTerminalNo = terminalNo;
						memTxnMerchantNo = merchantNo;
						memTxnCardType = cardType;
						memTxnCardNo = cardNo;
						memTxnBatchNo = batchNo;
						memTxnTraceNo = traceNo;
						memTxnEcrRef = ecrRef;
						memTxnAppCode = appCode;
						memTxnRefNo = refNo;
						memTxnDateTime = transactionDateTime;
						memTxnExpiryDate = expiryDate;
						actionValidationReady(actionType, true);
					} else {
						Factory.getInstance().addErrorMessage(actionDescription + " Fail.");
						actionValidationReady(actionType, false);
					}
				}
			};
		}
		return dlgCardInfo;
	}
/*
	public DlgVoidCUPPwd getDlgVoidCUPPwd() {
		if (dlgVoidCUPPwd == null) {
			dlgVoidCUPPwd = new DlgVoidCUPPwd(getMainFrame()) {
				@Override
				public void post(String cashierTransactionID, String slipNo, String slipSeq, String ctnID, String ctxTrace, String ctxMethod, String password) {
					super.post(cashierTransactionID, slipNo, slipSeq, ctnID, ctxTrace, ctxMethod, password);
					if (password != null) {
						memCUPPassword = password;
						doCashierVoidEntry_Card(cashierTransactionID, slipNo, slipSeq, ctnID, ctxTrace, ctxMethod);
					}
				}
			};
		}
		return dlgVoidCUPPwd;
	}
*/
	/***************************************************************************
	 * Card Payment Methods
	 **************************************************************************/

	private native String doCardPayment4Applet(String action, String amount_org, String amount, String approvalCode, String traceCode, String cardType, String ecrref, String password, String waitTime) /*-{
		return $wnd.getApplet("HKAHNHSApplet").doCardPayment("COM2", action, amount_org, amount, approvalCode, traceCode, cardType, ecrref, password, waitTime);
	}-*/;

	private native boolean doCardPayment4Exe(String action, String amount_org, String amount, String approvalCode, String traceCode, String cardType, String ecrref, String password, String slipNo) /*-{
		var newUrl = window.location.href;
		var index = newUrl.indexOf('/HKAH');
		var queryStr = "";
		if (index > 0) {
			var index2 = newUrl.indexOf('/', index + 1);
			if (index2 > 0) {
				queryStr = newUrl.substring(0, index2);
			} else {
				index2 = newUrl.indexOf('/', 9);
				if (index2 > 0) {
					queryStr = newUrl.substring(0, index2);
				}
//				queryStr = "http://160.100.3.39:8080/HKAHNHS_UAT";
			}
		}

		if (queryStr.length > 0) {
			window.location.href = "NHSClientCashier:" + $wnd.getWebSocketID() + "<FIELD/>" +
				queryStr + "/hkahnhs/websocket<FIELD/>" +
				action + "<FIELD/>" +
				amount_org + "<FIELD/>" +
				amount + "<FIELD/>" +
				approvalCode + "<FIELD/>" +
				traceCode + "<FIELD/>" +
				cardType + "<FIELD/>" +
				ecrref + "<FIELD/>" +
				password + "<FIELD/>" +
				slipNo + "<FIELD/>";
		}
		return true;
	}-*/;

	private native void doCardCloseConnection() /*-{
		$wnd.getApplet("HKAHNHSApplet").doCardCloseConnection();
	}-*/;

	public static native void startWebsocket() /*-{
		$wnd.connectWebsocket();
		$wnd.MasterPanel_doECRAfterECR = function(msg) {
			return @com.hkah.client.tx.MasterPaymentPanel::doECRAfterECR(Ljava/lang/String;)(msg);
		};
	}-*/;

	public static native void stopWebsocket() /*-{
		$wnd.disconnectWebsocket();
	}-*/;

	protected void resetCardInfo() {
		memS9000YN = false;
		memPaymentType = null;
		memPayee = null;
		memPatAddr1 = null;
		memPatAddr2 = null;
		memPatAddr3 = null;
		memCountry = null;
		memReason = null;
		memTmpReceiptNumber = null;
		memTxnType = null;
		memTxnEcrRef = null;
		memTxnAmount = null;
		memTxnRespCode = null;
		memTxnRespText = null;
		memTxnDateTime = null;
		memTxnCardType = null;
		memTxnCardNo = null;
		memTxnExpiryDate = null;
		memTxnCardHolder = null;
		memTxnTerminalNo = null;
		memTxnMerchantNo = null;
		memTxnStoreNo = null;
		memTxnTraceNo = null;
		memTxnBatchNo = null;
		memTxnAppCode = null;
		memTxnRefNo = null;
		memTxnRRNo = null;
		memTxnVDate = null;
		memTxnDAccount = null;
		memTxnAResp = null;
//		memCUPPassword = null;
		memPaymentAmount = null;
	}

	private String parseCardMsg(String returnMsg) {
		String responseCode =  null;

		try {
			int index = -1;
			if (returnMsg != null && (index = returnMsg.indexOf(MENU_DELIMITER)) >= 0) {
				String returnCode = returnMsg.substring(0, index);
				String returnQueue = returnMsg.substring(index + 1);

				if (returnCode.charAt(0) == '-') {
					return null;
				}

				switch (returnQueue.charAt(0)) {
					case '0':	// EDC Sales
					case '1':	// Offline
					case '2':	// Refund
					case '3':	// Void
					case '4':	// Retrieval
					case '8':	// Auth
					case 'L':	// Instalment Sale
						memTxnType = returnQueue.substring(0, 1);
						memTxnEcrRef = returnQueue.substring(1, 17);
						memTxnAmount = returnQueue.substring(17, 29);
						memTxnRespCode = returnQueue.substring(41, 43);
						memTxnRespText = returnQueue.substring(43, 63);
						memTxnDateTime = returnQueue.substring(63, 75);
						memTxnCardType = returnQueue.substring(75, 85);
						memTxnCardNo = returnQueue.substring(85, 104);
						memTxnExpiryDate = returnQueue.substring(104, 108);
						memTxnCardHolder = returnQueue.substring(108, 131);
						memTxnTerminalNo = returnQueue.substring(131, 139);
						memTxnMerchantNo = returnQueue.substring(139, 154);
						memTxnTraceNo = returnQueue.substring(154, 160);
						memTxnBatchNo = returnQueue.substring(160, 166);
						memTxnAppCode = returnQueue.substring(166, 172);
						memTxnRRNo = returnQueue.substring(172, 184);
						break;
					case '5':	// Sale
					case '6':	// Transaction Retrieval
					case 'J':	// EPS-CUP Sale
					case 'O':	// EPS-CUP Void
						memTxnType = returnQueue.substring(0, 1);
						memTxnEcrRef = returnQueue.substring(1, 17);
						memTxnAmount = returnQueue.substring(17, 29);
						memTxnRespCode = returnQueue.substring(41, 44);
						memTxnRespText = returnQueue.substring(44, 64);
						memTxnDateTime = returnQueue.substring(64, 76);
						memTxnCardNo = returnQueue.substring(76, 95);
						memTxnMerchantNo = returnQueue.substring(95, 104);
						memTxnStoreNo = returnQueue.substring(104, 107);
						memTxnTerminalNo = returnQueue.substring(107, 110);
						memTxnTraceNo = returnQueue.substring(110, 116);
						memTxnVDate = returnQueue.substring(116, 120);
						memTxnDAccount = returnQueue.substring(120, 136);
						memTxnAResp = returnQueue.substring(136, 156);
						break;
					case 'a':  // CUP online sale
					case 'b':  // CUP offline Sale
					case 'c':  // CUP Pre-Auth
					case 'd':  // CUP Void transaction
					case 'h':  // CUP Retrieval
					case 'l':  // CUP Refund
						memTxnType = returnQueue.substring(0, 1);
						memTxnEcrRef = returnQueue.substring(1, 17);
						memTxnAmount = returnQueue.substring(17, 29);
						memTxnRespCode = returnQueue.substring(41, 43);
						memTxnRespText = returnQueue.substring(43, 63);
						memTxnDateTime = returnQueue.substring(63, 75);
						memTxnCardType = returnQueue.substring(75, 85);
						memTxnCardNo = returnQueue.substring(85, 104);
						memTxnExpiryDate = returnQueue.substring(104, 108);
						memTxnTerminalNo = returnQueue.substring(108, 116);
						memTxnMerchantNo = returnQueue.substring(116, 131);
						memTxnTraceNo = returnQueue.substring(131, 137);
						memTxnBatchNo = returnQueue.substring(137, 143);
						memTxnAppCode = returnQueue.substring(143, 149);
						memTxnRefNo = returnQueue.substring(149, 161);
						memTxnRRNo = returnQueue.substring(161, 173);
						break;
					case 'A':	// QR Sale
					case 'B':	// QR Void
						memTxnType = returnQueue.substring(0, 1);
						memTxnEcrRef = returnQueue.substring(1, 17);
						memTxnAmount = returnQueue.substring(17, 29);
						memTxnRespCode = returnQueue.substring(41, 43);
						memTxnRespText = returnQueue.substring(43, 83);
						memTxnDateTime = returnQueue.substring(83, 95);
						memTxnCardType = convertQRTxType2CardType(returnQueue.substring(227, 228));
						memTxnCardNo = returnQueue.substring(155, 187);
						memTxnTerminalNo = returnQueue.substring(95, 103);
						memTxnMerchantNo = returnQueue.substring(103, 143);
						memTxnTraceNo = returnQueue.substring(143, 149);
						memTxnBatchNo = returnQueue.substring(149, 155);
						memTxnRefNo = returnQueue.substring(187, 227);
						break;
					case 'C':	// QR Refund
						memTxnType = returnQueue.substring(0, 1);
						memTxnEcrRef = returnQueue.substring(1, 17);
						memTxnAmount = returnQueue.substring(29, 41);
						memTxnRespCode = returnQueue.substring(41, 43);
						memTxnRespText = returnQueue.substring(43, 83);
						memTxnDateTime = returnQueue.substring(83, 95);
						memTxnCardType = convertQRTxType2CardType(returnQueue.substring(227, 228));
						memTxnCardNo = returnQueue.substring(155, 187);
						memTxnTerminalNo = returnQueue.substring(95, 103);
						memTxnMerchantNo = returnQueue.substring(103, 143);
						memTxnTraceNo = returnQueue.substring(143, 149);
						memTxnBatchNo = returnQueue.substring(149, 155);
						memTxnRRNo = returnQueue.substring(228, 268);
						memTxnRefNo = returnQueue.substring(268, 308);
						break;
					case 'X':
						memTxnRespCode = returnQueue.substring(41, 43);
						memTxnRespText = returnQueue.substring(43, 63);
						break;
				}
				responseCode = returnQueue.substring(41, 43).trim();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return responseCode;
	}

	/***************************************************************************
	 * Card Payment Methods
	 **************************************************************************/

	protected void actionValidation(final String actionType, final boolean returnValue, final String actionDescription,
			final String methodCode, final String txnType, final String originalAmount, final String paymentAmount,
			final String patNo, final String slipNo,
			String paymentType, final String payee, final String payAdd1, final String payAdd2, final String payAdd3, final String country) {
		// reset value
		resetCardInfo();
		// need payee info for cheque only
		if (returnValue && CASHTX_METHODCODE_CHEQUE.equals(methodCode) && CASHTX_TXNTYPE_PAYOUT.equals(txnType)) {
			// call dlg address
			if (patNo != null && patNo.length() > 0) {
				getDlgAddress().showDialog(actionType, patNo);
			} else {
				getDlgAddress().showDialog(actionType, payee, payAdd1, payAdd2, payAdd3, country);
			}
			writeLog(actionDescription, methodCode + "-" + txnType + "-" + paymentAmount, "Start PostTransaction for Cheque (" + slipNo + ")");
		} else if (returnValue) {
			memPaymentType = paymentType;
			if (memPaymentType == null) {
				QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
						new String [] { "PayCode", "PayType", "PayCode = '" + methodCode + "'"},
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							memPaymentType = mQueue.getContentField()[0];
							actionValidationHelper(actionType, returnValue, actionDescription, methodCode, txnType, originalAmount, paymentAmount, memPaymentType, slipNo);
						}
					}
				});
			} else {
				actionValidationHelper(actionType, returnValue, actionDescription, methodCode, txnType, originalAmount, paymentAmount, memPaymentType, slipNo);
			}
			writeLog(actionDescription, methodCode + "-" + txnType + "-" + originalAmount + "-" + paymentAmount, "Start PostTransaction for Non-Cheque (" + slipNo + ")");
		} else {
			actionValidationReady(actionType, returnValue);
		}
	}

	private void actionValidationHelper(final String actionType, boolean returnValue, final String actionDescription,
			final String methodCode, final String txnType, final String originalAmount, final String paymentAmount,
			final String paymentType, final String slipNo) {
		// log
		writeLog(actionDescription, methodCode + "-" + txnType, paymentAmount + " (" + slipNo + ")");
		memPaymentAmount = paymentAmount;

		if (CASHTX_PAYTYPE_OCTOPUS.equals(paymentType)) {
			getDlgCardInfo_Octopus().showDialog(actionType, actionDescription);
		} else if (CASHTX_PAYTYPE_EPS.equals(paymentType)
				|| CASHTX_PAYTYPE_CARD.equals(paymentType)
				|| CASHTX_PAYTYPE_CUP.equals(paymentType)
				|| CASHTX_PAYTYPE_QR.equals(paymentType)) {
			if (("Transaction".equals(actionDescription) && !CASHTX_TXNTYPE_RECEIVE.equals(txnType))) {
				memTmpReceiptNumber = EMPTY_VALUE;
			} else {
				// CASHTX_TXNTYPE_RECEIVE
				memTmpReceiptNumber = getTmpReceiptNumber();
			}

			if (slipNo != null && slipNo.length() > 0) {
				QueryUtil.executeMasterFetch(getUserInfo(), "CARDNEWREF",
						new String[] { slipNo },
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (CASHTX_PAYTYPE_EPS.equals(paymentType)
								&& YES_VALUE.equals(getMainFrame().getSysParameter("EPSREFSTN"))) {
							String[] tempSplit = mQueue.getContentField()[0].split("-");
							memTxnEcrRef = getEcrRef(tempSplit[0] + tempSplit[1].charAt(tempSplit[1].length() - 1), 12);
						} else {
							memTxnEcrRef = getEcrRef(mQueue.getContentField()[0]);
						}
						Factory.getInstance().writeLogToLocal("[MasterPanel] [before doECR preTx memTxnEcrRef wf slpno]:" + memTxnEcrRef);
						doECR_PreTransaction(actionType, actionDescription, txnType, originalAmount, paymentAmount, paymentType, methodCode, slipNo);
					}
				});
			} else {
				if (CASHTX_PAYTYPE_EPS.equals(paymentType)
						&& YES_VALUE.equals(getMainFrame().getSysParameter("EPSREFSTN"))) {
					memTxnEcrRef = getEcrRef(memTmpReceiptNumber.replace(":",""), 12);
				} else {
					memTxnEcrRef = getEcrRef(memTmpReceiptNumber);
				}
				doECR_PreTransaction(actionType, actionDescription, txnType, originalAmount, paymentAmount, paymentType, methodCode, slipNo);
			}
		} else {
			actionValidationReady(actionType, true);
		}
	}

	private String getTmpReceiptNumber() {
		StringBuffer receiptNumber = new StringBuffer();
		receiptNumber.append(getUserInfo().getUserID());
		receiptNumber.append(getMainFrame().getServerTime());
		return receiptNumber.toString();
	}

	private String getEcrRef(String receiptNumber) {
		return getEcrRef(receiptNumber,16);
	}

	private String getEcrRef(String receiptNumber,int ecrRefLength) {
		StringBuffer ecrRef = new StringBuffer();
		ecrRef.append("000000");
		ecrRef.append(receiptNumber);
		if (ecrRef.length() > ecrRefLength) {
			return ecrRef.substring(ecrRef.length() - ecrRefLength);
		} else {
			return ecrRef.toString();
		}
	}

	private void doECR_PreTransaction(final String actionType, final String actionDescription, final String txnType, final String originalAmount, final String paymentAmount, final String paymentType, final String methodCode, final String slipNo) {
		if (NO_VALUE.equals(getSysParameter("AllowCardM"))) {
			doECR_Error(actionType, actionDescription, txnType, paymentType, methodCode, slipNo, "Manual input transaction mode.");
		} else {
			String cardTxType = null;
			if (CASHTX_PAYTYPE_EPS.equals(memPaymentType)) {
				cardTxType = S9000_TXN_EPS_SALE;
			} else if (CASHTX_PAYTYPE_CUP.equals(memPaymentType)) {
				if (CASHTX_TXNTYPE_PAYOUT.equals(txnType)) {
					cardTxType = S9090_TXN_CUP_REFUND;
				} else {
					cardTxType = S9090_TXN_CUP_SALE;
				}
			} else if (CASHTX_PAYTYPE_QR.equals(memPaymentType)) {
				if (CASHTX_TXNTYPE_PAYOUT.equals(txnType)) {
					cardTxType = S9090_TXN_QR_REFUND;
				} else {
					cardTxType = S9090_TXN_QR_SALE;
				}
			} else {
				if (CASHTX_TXNTYPE_PAYOUT.equals(txnType)) {
					cardTxType = S9000_TXN_REFUND;
				} else {
					cardTxType = S9000_TXN_CARD_SALE;
				}
			}

			final MessageBox progressBox = MessageBoxBase.progress("Payment Processing", EMPTY_VALUE, EMPTY_VALUE);
			final ProgressBar progressBar = progressBox.getProgressBar();
			memPre_ECRTimer = new Timer() {
				float i = 0;

				@Override
				public void run() {
					progressBar.show();
					progressBar.updateProgress(i / getECRWaitingTime(), (int) i + " sec(s)");

					i += 1;
					if (i > getECRWaitingTime()) {
						// stop schedule
						cancel();

						// close progress box
						progressBox.close();

						// close card connection
						if (!Factory.getInstance().getMainFrame().isDisableApplet()) {
							doCardCloseConnection();
						}

						// handle card timeout error
						doECR_Error(actionType, actionDescription, txnType, paymentType, methodCode, slipNo, INPUT_TIMEOUT);
					}
				}

				@Override
				public void cancel() {
					super.cancel();

					// close progress box
					progressBox.close();

					if (Factory.getInstance().getMainFrame().isDisableApplet() && memPre_returnMsg != null) {
						String returnMsg = memPre_returnMsg;
						memPre_returnMsg = null;
						doECR_PreTransactionAfterECR(returnMsg);
					}
				}
			};
			memPre_ECRTimer.scheduleRepeating(1000);

			memPre_cardTxType = cardTxType;
			memPre_actionType = actionType;
			memPre_actionDescription = actionDescription;
			memPre_txnType = txnType;
			memPre_paymentType = paymentType;
			memPre_methodCode = methodCode;
			memPre_slipNo = slipNo;

			if (Factory.getInstance().getMainFrame().isDisableApplet()) {
				memPre_returnMsg = null;
				doCardPayment4Exe(TextUtil.parseStr(cardTxType),
						originalAmount.indexOf("-") == 0 ? originalAmount.substring(1) : originalAmount,
						paymentAmount.indexOf("-") == 0 ? paymentAmount.substring(1) : paymentAmount,
						EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE, TextUtil.parseStr(memTxnEcrRef), EMPTY_VALUE, TextUtil.parseStr(slipNo));
			} else {
				// store return message
				Factory.getInstance().writeLogToLocal("[MasterPanel] [before doCardPayment memTxnEcrRef]:" + TextUtil.parseStr(memTxnEcrRef));
				String returnMsg = null;
				try {
					returnMsg = doCardPayment4Applet(TextUtil.parseStr(memPre_cardTxType),
							originalAmount.indexOf("-") == 0 ? originalAmount.substring(1) : originalAmount,
							paymentAmount.indexOf("-") == 0 ? paymentAmount.substring(1) : paymentAmount,
							EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE, TextUtil.parseStr(memTxnEcrRef), EMPTY_VALUE,
							String.valueOf(getECRWaitingTime()));
				} catch (Exception e) {}

				// cancel timer
				memPre_ECRTimer.cancel();

				doECR_PreTransactionAfterECR(returnMsg);
			}
		}
	}

	private void doECR_PreTransactionAfterECR(String returnMsg) {
		memPre_ECRTimer = null;

		doECR_PostTransaction(memPre_actionType, memPre_actionDescription, memPre_txnType, memPre_paymentType, memPre_methodCode, memPre_slipNo, returnMsg);
	}

	private void doECR_PostTransaction(final String actionType, final String actionDescription, final String txnType, final String paymentType, final String methodCode, final String slipNo, final String returnMsg) {
		try {
			int index = -1;
			if (returnMsg != null && (index = returnMsg.indexOf(MENU_DELIMITER)) >= 0) {
				String responseCode = parseCardMsg(returnMsg);
				if (responseCode == null) {
					doECR_Error(actionType, actionDescription, txnType, paymentType, methodCode, slipNo, MSG_S9000_INITERROR);
					return;
				}

				// skip time out
				if ("249".equals(responseCode)) {
					doECR_Error(actionType, actionDescription, txnType, paymentType, methodCode, slipNo, "Transaction timeout.");
				} else if (!S9000_RST_ACCEPT.equals(responseCode) && !S9000_EPS_ACCEPT.equals(responseCode)) {
					doECR_Error(actionType, actionDescription, txnType, paymentType, methodCode, slipNo,
							memTxnRespText == null ? MSG_CASHTX_FAILED + "(Error Code:" + memTxnRespCode + ")"
									:MSG_CASHTX_FAILED+"\n(Error Msg:" + memTxnRespText + " Error Code:" + memTxnRespCode + ")");
				} else {
					memS9000YN = true;
					actionValidationReady(actionType, true);
//					Factory.getInstance().addInformationMessage(MSG_CASHTX_SUCCESS);
					//Factory.getInstance().addInformationMessage(actionDescription + " Success.");
				}
			} else {
				doECR_Error(actionType, actionDescription, txnType, paymentType, methodCode, slipNo, MSG_SPECTRA_FAILURE);
			}
		} catch (Exception e) {
			Factory.getInstance().addErrorMessage(e.getMessage());
		}
	}

	private void doECR_Error(final String actionType, final String actionDescription, final String txnType, final String paymentType, final String methodCode, final String slipNo, String errorMsg) {
		MessageBoxBase.alert("Message", errorMsg,
				new Listener<MessageBoxEvent>() {
			@Override
			public void handleEvent(MessageBoxEvent be) {
				getDlgCardInfo().showDialog(actionType, actionDescription, txnType, paymentType, methodCode, slipNo);
			}
		});
	}

	private static void doECRAfterECR(String returnMsg) {
		int index = -1;
		if (returnMsg != null && (index = returnMsg.indexOf(MENU_DELIMITER)) >= 0) {
			String slpNo = returnMsg.substring(0, index);
			if (slpNo.length() == 0 || MINUS_ONE_VALUE.equals(slpNo) || memPre_slipNo.equals(slpNo)) {
				memPre_returnMsg = returnMsg.substring(index + 1);
				if (memPre_ECRTimer != null) {
					memPre_ECRTimer.cancel();
				}
				if (memPre_VOIDTimer != null) {
					memPre_VOIDTimer.cancel();
				}
			}
		}
	}

	/***************************************************************************
	 * Card Void Payment Methods
	 **************************************************************************/

	public void doCashierVoidEntryReady(boolean ready) {}

	public void doCashierVoidEntry(final UserInfo userInfo, final String cashierTransactionID, final String slipNo, final String slipSeq) {
		// reset value
		resetCardInfo();
		memTmpReceiptNumber = getTmpReceiptNumber();
		memTxnEcrRef = getEcrRef(memTmpReceiptNumber);

		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {"CashTx csh, CardTx cd", "csh.CtxMeth, cd.CtnTrace", "csh.CtnID = cd.CtnID (+) AND csh.CtxID =" + cashierTransactionID},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					String[] rs = mQueue.getContentField();
					final String ctxMethod = rs[0];
					final String ctxTrace = rs[1];

					QueryUtil.executeMasterAction(getUserInfo(), "CashierVoidEntry", QueryUtil.ACTION_APPEND,
							new String[] { cashierTransactionID, getUserInfo().getCashierCode(), getUserInfo().getUserID() },
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(final MessageQueue mQueue) {
							if (mQueue.success()) {
								// ReturnCode 0: ctnID empty
								String ctnID = ZERO_VALUE.equals(mQueue.getReturnCode()) ? EMPTY_VALUE : mQueue.getReturnCode();
								if (ctnID != null && ctnID.length() > 0) {
									if (CASHTX_PAYTYPE_OCTOPUS.equals(ctxMethod)) {
										doCashierVoidEntry_Post(cashierTransactionID, slipNo, slipSeq, ctnID, ctxTrace, false, false);
//									} else if (CASHTX_PAYTYPE_CUP.equals(ctxMethod)) {
										// Bug 936, Mary said no need to input CUP password from HATS
//										getDlgVoidCUPPwd().showDialog(cashierTransactionID, slipNo, slipSeq, ctnID, ctxTrace, ctxMethod);
									} else {
										doCashierVoidEntry_Card(cashierTransactionID, slipNo, slipSeq, ctnID, ctxTrace, ctxMethod);
									}
								} else {
									doCashierVoidEntry_Post(cashierTransactionID, slipNo, slipSeq, ctnID, ctxTrace, false, false);
								}
							} else {
								Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
							}
						}
					});
				} else {
					Factory.getInstance().addErrorMessage(MSG_VOID_FAILED);
				}
			}
		});
	}

	private void doCashierVoidEntry_Card(final String cashierTransactionID, final String slipNo, final String slipSeq, final String ctnID, final String ctxTrace, String ctxMethod) {
		if (NO_VALUE.equals(getSysParameter("AllowCardM"))) {
			doCashierVoidEntry_Error(cashierTransactionID, slipNo, slipSeq, ctnID, ctxTrace, "Manual input transaction (Void) mode.");
		} else {
			final MessageBox progressBox = MessageBoxBase.progress("Credit Card Processing", EMPTY_VALUE, EMPTY_VALUE);
			final ProgressBar progressBar = progressBox.getProgressBar();
			memPre_VOIDTimer = new Timer() {
				float i = 0;

				@Override
				public void run() {
					progressBar.show();
					progressBar.updateProgress(i / getECRWaitingTime(), (int) i + " sec(s)");

					i += 1;
					if (i > getECRWaitingTime()) {
						// stop schedule
						cancel();

						// close progress box
						progressBox.close();

						// close card connection
						if (!Factory.getInstance().getMainFrame().isDisableApplet()) {
							doCardCloseConnection();
						}

						// handle card timeout error
						doCashierVoidEntry_Error(cashierTransactionID, slipNo, slipSeq, ctnID, ctxTrace, INPUT_TIMEOUT);
					}
				}

				@Override
				public void cancel() {
					super.cancel();

					// close progress box
					progressBox.close();

					if (Factory.getInstance().getMainFrame().isDisableApplet() && memPre_returnMsg != null) {
						String returnMsg = memPre_returnMsg;
						memPre_returnMsg = null;
						doCashierVoidEntryAfterECR_CardPost(returnMsg);
					}
				}
			};
			memPre_VOIDTimer.scheduleRepeating(1000);

			// store return message
			String cardTxType = null;
			if (CASHTX_PAYTYPE_CUP.equals(ctxMethod)) {
				cardTxType = S9090_TXN_CUP_VOID;
			} else if (CASHTX_PAYTYPE_QR.equals(ctxMethod)) {
				cardTxType = S9090_TXN_QR_VOID;
			} else {
				cardTxType = S9000_TXN_VOID;
			}

			memPre_cardTxType = cardTxType;
			memPre_cashierTransactionID = cashierTransactionID;
			memPre_slipNo = slipNo;
			memPre_slipSeq = slipSeq;
			memPre_ctnID = ctnID;

			if (Factory.getInstance().getMainFrame().isDisableApplet()) {
				memPre_returnMsg = null;
				doCardPayment4Exe(cardTxType, EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE, ctxTrace, EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE, TextUtil.parseStr(slipNo));
			} else {
				String returnMsg = null;
				try {
					returnMsg = doCardPayment4Applet(cardTxType, EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE, ctxTrace, EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE, String.valueOf(getECRWaitingTime()));
				} catch (Exception e) {}

				// cancel timer
				memPre_VOIDTimer.cancel();

				doCashierVoidEntryAfterECR_CardPost(returnMsg);
			}
		}
	}

	private void doCashierVoidEntryAfterECR_CardPost(String returnMsg) {
		memPre_VOIDTimer = null;

		doCashierVoidEntry_CardPost(memPre_cashierTransactionID, memPre_slipNo, memPre_slipSeq, memPre_ctnID, memPre_ctxTrace, returnMsg);
	}

	private void doCashierVoidEntry_CardPost(String cashierTransactionID, String slipNo, String slipSeq, String ctnID, String ctxTrace, String returnMsg) {
		try {
			int index = -1;
			if (returnMsg != null && (index = returnMsg.indexOf(MENU_DELIMITER)) >= 0) {
				String responseCode = parseCardMsg(returnMsg);
				if (responseCode == null) {
					doCashierVoidEntry_Error(cashierTransactionID, slipNo, slipSeq, ctnID, ctxTrace, MSG_S9000_INITERROR);
					return;
				}

				// skip time out
				if ("249".equals(responseCode)) {
					doCashierVoidEntry_Error(cashierTransactionID, slipNo, slipSeq, ctnID, ctxTrace, "Transaction timeout.");
				} else if (!S9000_RST_ACCEPT.equals(responseCode) && !S9000_EPS_ACCEPT.equals(responseCode)) {
					doCashierVoidEntry_Error(cashierTransactionID, slipNo, slipSeq, ctnID, ctxTrace, memTxnRespText == null ? MSG_CASHTX_FAILED : memTxnRespText);
				} else {
					doCashierVoidEntry_Post(cashierTransactionID, slipNo, slipSeq, ctnID, ctxTrace, false, false);
					Factory.getInstance().addInformationMessage(MSG_CASHTX_SUCCESS);
				}
			} else {
				doCashierVoidEntry_Error(cashierTransactionID, slipNo, slipSeq, ctnID, ctxTrace, MSG_SPECTRA_FAILURE);
			}
		} catch (Exception e) {
			Factory.getInstance().addErrorMessage(e.getMessage());
		}
	}

	private void doCashierVoidEntry_Error(final String cashierTransactionID, final String slipNo, final String slipSeq, final String ctnID, final String ctxTrace, String errorMsg) {
		MessageBoxBase.alert("Message", errorMsg,
				new Listener<MessageBoxEvent>() {
			@Override
			public void handleEvent(MessageBoxEvent be) {
				doCashierVoidEntry_Post(cashierTransactionID, slipNo, slipSeq, ctnID, ctxTrace, true, false);
			}
		});
	}

	private void doCashierVoidEntry_Post(final String cashierTransactionID, final String slipNo, final String slipSeq, final String ctnID, final String traceNo, final boolean cardError, boolean cardForceYN) {
		QueryUtil.executeMasterAction(getUserInfo(), "CashierVoidEntryPost", QueryUtil.ACTION_APPEND,
				new String[] {
					cashierTransactionID,
					slipNo,
					slipSeq,
					getUserInfo().getCashierCode(),
					ctnID,
					cardError?YES_VALUE:NO_VALUE,
					cardForceYN?YES_VALUE:NO_VALUE,
					getUserInfo().getUserID(),
					// credit card/octopus begin
					memTxnType,
					memTxnEcrRef,
					memTxnAmount,
					memTxnRespCode,
					memTxnRespText,
					memTxnDateTime,
					memTxnCardType,
					memTxnCardNo,
					memTxnExpiryDate,
					memTxnCardHolder,
					memTxnTerminalNo,
					memTxnMerchantNo,
					memTxnStoreNo,
					memTxnTraceNo,
					memTxnBatchNo,
					memTxnAppCode,
					memTxnRefNo,
					memTxnRRNo,
					memTxnVDate,
					memTxnDAccount,
					memTxnAResp
					// credit card/octopus end
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(final MessageQueue mQueue) {
				if (mQueue.success()) {
					doCashierVoidEntryReady(true);
				} else if ("-100".equals(mQueue.getReturnCode())) {
					MessageBoxBase.confirm(MSG_PBA_SYSTEM, mQueue.getReturnMsg(),
							new Listener<MessageBoxEvent>() {
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								MessageBoxBase.alert("Message", MSG_CARD_TRACE_NO + traceNo,
										new Listener<MessageBoxEvent>() {
									@Override
									public void handleEvent(MessageBoxEvent be) {
										doCashierVoidEntry_Post(cashierTransactionID, slipNo, slipSeq, ctnID, traceNo, cardError, true);
									}
								});
							} else {
								doCashierVoidEntry_Clear(ctnID);
							}
						}
					});
				} else {
					Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
				}
			}
		});
	}

	private void doCashierVoidEntry_Clear(String ctnID) {
		// clean up temp record
		QueryUtil.executeMasterAction(getUserInfo(), "CashierVoidEntryClear", QueryUtil.ACTION_APPEND,
				new String[] { ctnID },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(final MessageQueue mQueue) {
				if (mQueue.success()) {
					doCashierVoidEntryReady(false);
				}
			}
		});
	}

	private String convertQRTxType2CardType(String txType) {
		if (TXTYPE_CODE_ALIPAY.equals(txType)) {
			return TXTYPE_DESC_ALIPAY;
		} else if (TXTYPE_CODE_WECHATPAY.equals(txType)) {
			return TXTYPE_DESC_WECHATPAY;
		} else {
			return txType;
		}
	}

	private int getECRWaitingTime() {
		if ("TWAH".equals(Factory.getInstance().getClientConfigObject().getSiteCode())) {
			return ECR_WAIT_TIME_TWAH;
		} else {
			return ECR_WAIT_TIME_HKAH;
		}
	}
}