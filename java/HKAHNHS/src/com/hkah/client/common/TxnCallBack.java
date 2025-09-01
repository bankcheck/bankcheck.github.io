package com.hkah.client.common;

import com.hkah.client.tx.transaction.TransactionDetail;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class TxnCallBack implements ConstantsVariable {
	private static TxnCallBack txnCallBack = null;
	private TransactionDetail txnPanel = null;
	private String slpNo = null;
	private boolean manual = false;
	private boolean discharge = false;

	private static MessageQueueCallBack fetchDetailCallBack = null;
	private static MessageQueueCallBack slpAlertCallBack = null;
	private static MessageQueueCallBack slpReportLangCallBack = null;
	private static MessageQueueCallBack actionValidationCallBack = null;
	private static MessageQueueCallBack doPostTrasactionsCallBack = null;
	private static MessageQueueCallBack checkSlipBeforeCloseCallBack = null;
	private static MessageQueueCallBack setCmdPrtSuppStatusCallBack = null;
	private static MessageQueueCallBack updateSlipStatusCallBack = null;
	private static MessageQueueCallBack changeAmountCallBack = null;
	private static MessageQueueCallBack checkPkgCodeStnidCallBack = null;
	private static MessageQueueCallBack cancelPkgCallBack = null;
	private static MessageQueueCallBack checkArCardRemarkCallBack = null;
	private static MessageQueueCallBack checkArCardRemarkForStatementCallBack = null;

	// hidden constructor
	private TxnCallBack() {
		super();
	}

	public static TxnCallBack getInstance() {
		if (txnCallBack == null) {
			txnCallBack = new TxnCallBack();
		}
		return txnCallBack;
	}

	public MessageQueueCallBack getCheckArCardRemarkForStatementCallBack(TransactionDetail txn) {
		this.txnPanel = txn;
		if (checkArCardRemarkForStatementCallBack == null) {
			checkArCardRemarkForStatementCallBack = new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					txnPanel.checkArCardRemarkForStatement(mQueue);
				}
			};
		}
		return checkArCardRemarkForStatementCallBack;
	}

	public MessageQueueCallBack getCheckArCardRemarkCallBack(TransactionDetail txn) {
		this.txnPanel = txn;
		if (checkArCardRemarkCallBack == null) {
			checkArCardRemarkCallBack = new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					txnPanel.checkArCardRemark(mQueue);
				}
			};
		}
		return checkArCardRemarkCallBack;
	}

	public MessageQueueCallBack getCancelPkgCallBack(TransactionDetail txn) {
		this.txnPanel = txn;
		if (cancelPkgCallBack == null) {
			cancelPkgCallBack = new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					txnPanel.cancelPkgCallBackSuccess(mQueue);
				};
			};
		}
		return cancelPkgCallBack;
	}

	public MessageQueueCallBack getCheckPkgCodeStnidCallBack(TransactionDetail txn) {
		this.txnPanel = txn;
		if (checkPkgCodeStnidCallBack == null) {
			checkPkgCodeStnidCallBack = new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					txnPanel.checkPkgCodeStnid(mQueue);
				}
			};
		}
		return checkPkgCodeStnidCallBack;
	}

	public MessageQueueCallBack getChangeAmountCallBack(TransactionDetail txn) {
		this.txnPanel = txn;
		if (changeAmountCallBack == null) {
			changeAmountCallBack = new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					txnPanel.changeAmountCallBackSuccess(mQueue);
				}
			};
		}
		return changeAmountCallBack;
	}

	public MessageQueueCallBack getUpdateSlipStatusCallBack(TransactionDetail txn) {
		this.txnPanel = txn;
		if (updateSlipStatusCallBack == null) {
			updateSlipStatusCallBack = new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					txnPanel.updateSlipStatusSuccess(mQueue);
				}

				@Override
				public void onFailure(Throwable caught) {
					Factory.getInstance().addErrorMessage("Fail to update slip.");
				}
			};
		}
		return updateSlipStatusCallBack;
	}

	public MessageQueueCallBack getSetCmdPrtSuppStatusCallBack(TransactionDetail txn) {
		this.txnPanel = txn;
		if (setCmdPrtSuppStatusCallBack == null) {
			setCmdPrtSuppStatusCallBack = new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					txnPanel.setCmdPrtSuppStatusSuccess(mQueue);
				}
			};
		}
		return setCmdPrtSuppStatusCallBack;
	}

	public MessageQueueCallBack getCheckSlipBeforeCloseCallBack(TransactionDetail txn, String slpNoVal,
			boolean manualVal, boolean dischargeVal) {
		this.txnPanel = txn;
		this.slpNo = slpNoVal;
		this.manual = manualVal;
		this.discharge = dischargeVal;

		if (checkSlipBeforeCloseCallBack == null) {
			checkSlipBeforeCloseCallBack = new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					txnPanel.checkSlipBeforeCloseSuccess(mQueue, slpNo, manual, discharge);
				}
			};
		}
		return checkSlipBeforeCloseCallBack;
	}

	public MessageQueueCallBack getDoPostTransactionCallBack(TransactionDetail txn) {
		this.txnPanel = txn;
		if (doPostTrasactionsCallBack == null) {
			doPostTrasactionsCallBack = new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					txnPanel.doPostTrasactionsSuccess(mQueue);
				}
			};
		}
		return doPostTrasactionsCallBack;
	}

	public MessageQueueCallBack getActionValidationCallBack(TransactionDetail txn) {
		this.txnPanel = txn;
		if (actionValidationCallBack == null) {
			actionValidationCallBack = new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					txnPanel.actionValidationSuccess(mQueue);
				}
			};
		}
		return actionValidationCallBack;
	}

	public MessageQueueCallBack getSlpReportLangCallBack(TransactionDetail txn) {
		this.txnPanel = txn;
		if (slpReportLangCallBack == null) {
			slpReportLangCallBack = new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						txnPanel.setReportLang(mQueue.getContentField()[0]);
					}
				}
			};
		}
		return slpReportLangCallBack;
	}

	public MessageQueueCallBack getSlpAlertCallBack(TransactionDetail txn) {
		this.txnPanel = txn;
		if (slpAlertCallBack == null) {
			slpAlertCallBack = new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						// popup alert
						for (int i = 0; i < mQueue.getContentLineCount(); i++) {
							Factory.getInstance().addErrorMessage(mQueue.getContentField()[i]);
						}
					}
				}
			};
		}
		return slpAlertCallBack;
	}

	public MessageQueueCallBack getFetchDetailCallBack(TransactionDetail txn) {
		this.txnPanel = txn;
		if (fetchDetailCallBack == null) {
			fetchDetailCallBack = new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						txnPanel.getFetchDetailReady(mQueue.getContentField());
					} else {
						txnPanel.refreshButton();
					}
				}

				@Override
				public void onComplete() {
					super.onComplete();
					txnPanel.setLoadingScreen(false);
				}
			};
		}
		return fetchDetailCallBack;
	}
}
