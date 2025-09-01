package com.hkah.client.layout.textfield;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.dialog.DialogSearchBase;
import com.hkah.client.layout.dialog.DlgOSBillAlert;
import com.hkah.client.layout.dialog.DlgPatientAlert;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.dialogsearch.DlgPatientSearch;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTableColumn;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class TextPatientNoSearch extends SearchTriggerField implements ConstantsMessage, ConstantsTableColumn {

	private DlgPatientSearch dlgPatientSearch = null;
	private DlgPatientAlert dlgPatientAlert = null;
	private DlgOSBillAlert dlgOSBillAlert = null;
	private String oldPatientNo = null;
	private boolean isShowAllAlert = true;
	private boolean isCheckDeathPatient = false;
	private boolean isShowAlert = true;
	private boolean isShowAlertByRequest = false;
	private boolean isMergePatientNo = false;
	private boolean isCheckOSBill = false;

	public TextPatientNoSearch() {
		super();
	}

	public TextPatientNoSearch(boolean showAlert) {
		super();
		setShowAlert(showAlert);
	}

	public TextPatientNoSearch(boolean showSearchTrigger, boolean showAlert) {
		super(!showSearchTrigger);
		setShowAlert(showAlert);
	}

	public TextPatientNoSearch(boolean showSearchTrigger, boolean showAlert, boolean checkOSBill) {
		super(!showSearchTrigger);
		setShowAlert(showAlert);
		setCheckOSBill(checkOSBill);
	}

	public TextPatientNoSearch(boolean showSearchTrigger, boolean triggerBySearchKey,
								boolean showAlert, boolean checkOSBill) {
		super(!showSearchTrigger, true, triggerBySearchKey);
		setShowAlert(showAlert);
		setCheckOSBill(checkOSBill);
	}

	public TextPatientNoSearch(boolean showAlert, TableList table, int column) {
		super(false, table, column);
		setShowAlert(showAlert);
	}

	public TextPatientNoSearch(boolean showSearchTrigger, boolean showAlert, TableList table, int column) {
		super(!showSearchTrigger, table, column);
		setShowAlert(showAlert);
	}

	@Override
	public void onBlur() {
		super.onBlur();
		if (isShowAllAlert() && !isShowAlertByRequest() && getText().length() > 0) {
			if (isCheckDeathPatient()) {
				checkDeathPatient();
			} else {
				checkDeathPatientPost();
			}
		}
	}

	public void onBlurPost() {
		// override in child class
	}

	/***************************************************************************
	 * Step 0. Check Death Patient
	 **************************************************************************/

	public void checkDeathPatient() {
		String patientNo = getText().trim();
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.PATIENT_TXCODE,
				new String[] { patientNo },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(final MessageQueue chkDeath) {
				if (chkDeath.success()) {
					final String[] para = chkDeath.getContentField();
					if (para[PATIENT_DEATH] != null && para[PATIENT_DEATH].trim().length() > 0) {
						MessageBoxBase.confirm(MSG_PBA_SYSTEM, MSG_PATIENT_DEATH, new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									checkDeathPatientDialogYes(chkDeath);
									checkDeathPatientPost();
								} else {
									checkDeathPatientDialogNo();
								}
							}
						});
					} else {
						checkDeathPatientDialogYes(chkDeath);
						checkDeathPatientPost();
					}
				}
			}
		});
	}

	protected void checkDeathPatientDialogYes(MessageQueue chkDeath) {
		// for child class implement
	}

	protected void checkDeathPatientDialogNo() {
		// for child class implement
	}

	protected void checkDeathPatientPost() {
		checkMergePatient();
	}

	public boolean isCheckDeathPatient() {
		return isCheckDeathPatient;
	}

	public void setCheckDeathPatient(boolean value) {
		isCheckDeathPatient = value;
	}

	/***************************************************************************
	 * Step 1. Check Merge Patient
	 **************************************************************************/

	public void checkMergePatient() {
		checkMergePatient(false);
	}

	public void checkMergePatient(final boolean bySearchKey) {
		setMergePatientNo(false);

		String patientNo = getText().trim();
		if (patientNo.length() > 0 && (!isSkipCheckPatient() || !patientNo.equals(getOldPatientNo()))) {
			QueryUtil.executeMasterFetch(getUserInfo(), "PATIENT_NO_EXIST", new String[] { patientNo },
					new MessageQueueCallBack() {
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						boolean isExistPatient = YES_VALUE.equals(mQueue.getContentField()[0]);
						String mergedPatientNo = mQueue.getContentField()[1];
						String mergedFromPatientNo = mQueue.getContentField()[2];

						if (mergedPatientNo != null && mergedPatientNo.length() > 0) {
							showMergePatient(mergedPatientNo);
						} else {
							if (ConstantsVariable.YES_VALUE.equals(Factory.getInstance().getSysParameter("MERGEDTOAL"))
									&& mergedFromPatientNo != null && mergedFromPatientNo.length() > 0) {
								showMergeFromPatient(mergedFromPatientNo);
							}
							checkPatient(isExistPatient, bySearchKey);
						}
					}
				}
			});
		}
	}

	protected void checkPatient(boolean isExistPatient, boolean bySearchKey) {
		if (isExistPatient) {
			// store old patient no
			setOldPatientNo(getText());

			// after check whether it is merge
			onBlurPost();
			if (isShowAlert() || isShowAlertByRequest()) {
				checkPatientAlert();
			} else {
				checkPatientAlertPost();
			}
		} else if (bySearchKey) {
			showSearchPanel();
		}
	}

	public void showMergeFromPatient(String fromPatientNo) {
		StringBuffer msg = new StringBuffer();
		msg.append("From ");
		msg.append(fromPatientNo);
		msg.append(" to ");
		msg.append(getText()+"<br/>");
		msg.append("Patient: "+getText()+" already included Patient: ");
		msg.append(fromPatientNo);
		msg.append("'s records.");

		final boolean isShowAllAlert = isShowAllAlert();
		setShowAllAlert(false);

		Factory.getInstance().addInformationMessage(msg.toString(),
				new Listener<MessageBoxEvent>() {
			@Override
			public void handleEvent(MessageBoxEvent be) {
				showMergeFromPatientPost();
				setShowAllAlert(isShowAllAlert);
			}
		});
	}

	public void showMergePatient(String toPatientNo) {
		StringBuffer msg = new StringBuffer();
		msg.append("Patient: ");
		msg.append(getText());
		msg.append(" has been merged to Patient: ");
		msg.append(toPatientNo);
		msg.append(".\nPlease change patient card.");

//		resetText();
		setMergePatientNo(true);
		final boolean isShowAllAlert = isShowAllAlert();
		setShowAllAlert(false);

		Factory.getInstance().addErrorMessage(msg.toString(), null, null, null,
				new Listener<MessageBoxEvent>() {
			@Override
			public void handleEvent(MessageBoxEvent be) {
				showMergePatientPost();
				setShowAllAlert(isShowAllAlert);
			}
		});
	}

	public boolean isShowAllAlert() {
		return isShowAllAlert;
	}

	public void setShowAllAlert(boolean value) {
		isShowAllAlert = value;
	}

	protected void showMergeFromPatientPost() {
		// for child class implement
	}

	protected void showMergePatientPost() {
		// for child class implement
	}

	public boolean isMergePatientNo() {
		return isMergePatientNo;
	}

	public void setMergePatientNo(boolean value) {
		isMergePatientNo = value;
	}

	/***************************************************************************
	 * Step 2. Check Patient Alert
	 **************************************************************************/

	public void checkPatientAlert() {
		getDlgPatientAlert().showDialog(getText());
	}

	public void checkPatientAlert(String patno) {
		getDlgPatientAlert().showDialog(patno);
	}

	protected void checkPatientAlertPost() {
		if (isCheckOSBill()) {
			checkOSBill();
		} else {
			actionAfterOK();
		}
	}

	public void setShowAlert(boolean value) {
		isShowAlert = value;
	}

	public boolean isShowAlert() {
		return isShowAlert;
	}

	public void setShowAlertByRequest(boolean value) {
		isShowAlertByRequest = value;
	}

	public boolean isShowAlertByRequest() {
		return isShowAlertByRequest;
	}

	/***************************************************************************
	 * Step 3. Check Outstanding Bill
	 **************************************************************************/

	private void checkOSBill() {
		getDlgOSBillAlert().showDialog(getText());
		actionAfterOK();
	}

	public void setCheckOSBill(boolean value) {
		isCheckOSBill = value;
	}

	public boolean isCheckOSBill() {
		return isCheckOSBill;
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	public void resetText() {
		setOldPatientNo(null);
		super.resetText();
	}

	/***************************************************************************
	 * Dialog Method
	 **************************************************************************/

	@Override
	protected DialogSearchBase getSearchDialog() {
		if (dlgPatientSearch == null) {
			dlgPatientSearch = new DlgPatientSearch(this) {
				@Override
				protected void acceptPostAction() {
					checkPatientAlertPost();
				}
			};
		}
		return dlgPatientSearch;
	}

	private DlgPatientAlert getDlgPatientAlert() {
		if (dlgPatientAlert == null) {
			dlgPatientAlert = new DlgPatientAlert(Factory.getInstance().getMainFrame()) {
				@Override
				protected void post(boolean success) {
					if (success && getSpecListTable().getRowCount() > 0) {
						for (int i = 0; i < getSpecListTable().getRowCount(); i++) {
							if ("1".equals(getSpecListTable().getRowContent(i)[4])) {
								checkPatientAlertAction(
										getSpecListTable().getRowContent(i)[2],
										getSpecListTable().getRowContent(i)[3]
								);
								break;
							}
						}
					}
					// call alert post
					checkPatientAlertPost();
				}
			};
		}
		return dlgPatientAlert;
	}

	private DlgOSBillAlert getDlgOSBillAlert() {
		if (dlgOSBillAlert == null) {
			dlgOSBillAlert = new DlgOSBillAlert(Factory.getInstance().getMainFrame()) {
				@Override
				protected void post(boolean success) {
					actionAfterOK();
				}
			};
		}
		return dlgOSBillAlert;
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	protected void actionAfterOK() {
		// for child class implement
	}

	protected void checkPatientAlertAction(String pcyCode, String arcCode) {
		// for child class implement
	}

	/**
	 * @return the oldPatientNo
	 */
	public String getOldPatientNo() {
		return oldPatientNo;
	}

	/**
	 * @param oldPatientNo the oldPatientNo to set
	 */
	public void setOldPatientNo(String oldPatientNo) {
		this.oldPatientNo = oldPatientNo;
	}

	protected boolean isSkipCheckPatient() {
		return true;
	}

	@Override
	public void checkTriggerBySearchKey() {
		//setSearchKey
		if (isFocusOwner()) {
			if (getText().trim().length() == 0) {
				showSearchPanel();
			} else {
				if (isShowAllAlert()) {
					checkMergePatient(true);
				}
			}
		}
	}
}