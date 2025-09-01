package com.hkah.client.tx.transaction;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.MessageBox;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboARCompany;
import com.hkah.client.layout.combobox.ComboDeptService;
import com.hkah.client.layout.combobox.ComboSlipType;
import com.hkah.client.layout.dialog.DlgCreateSlip;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.tx.SearchPanel;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTransaction;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class SlipSearchByAR extends SearchPanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.SLIPSEARCH_BYITEM_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.SLIPSEARCH_BYITEM_TITLE;
	}

	/**
	 * This method initializes
	 */
	public SlipSearchByAR() {
		super();
	}

	public SlipSearchByAR(BasePanel panelFrom) {
		super();
		this.panelFrom = panelFrom;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				EMPTY_VALUE,
				EMPTY_VALUE,
				"Reg Date",
				"Slip No.",
				"Type",
				"Status",
				"AR Code",
				"AR Name",
				"Patient No",
				"Patient Family Name",
				"Patient Given Name",
				"Dr. Code",
				"Dr. Family Name",
				"Dr. Given Name",
				"Description",
				"Description1",
				"Amount",
				"Slip Remark",
				"User ID",
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				"Days"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				0,//15,
				0,//15,
				110,
				80,
				0,//40,
				45,
				60,
				0,//60,
				0,//60,
				0,//110,
				0,//110,
				55,
				0,//90,
				0,//120,
				100,
				150,
				50,
				95,
				0,//60,
				0,
				0,
				0,
				35
		};
	}


	/* >>> ~4a~ Set Table Column Menu  ==================================== <<< */
	@Override
	public boolean getNotShowMenu() {
		return false;
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel panelFrom = null;
	private BasePanel leftPanel = null;
	private BasePanel paraPanel = null;
	private BasePanel RTPanel = null; // right top panel
	private BasePanel listPanel = null;
	private LabelSmallBase LeftJLabel_PatientNo = null;
	private TextPatientNoSearch LeftJText_PatientNo = null;
	private LabelSmallBase LeftJLabel_ServiceCode = null;
	private ComboDeptService LeftJText_ServiceCode = null;
	private LabelSmallBase LeftJLabel_SlipType = null;
	private ComboSlipType LeftJCombo_SlipType = null;
	private LabelSmallBase LeftJLabel_ARCompanyCode = null;
	private ComboARCompany LeftJCombo_ARCompanyCode = null;
	private LabelSmallBase LeftJLabel_DateFrom = null;
	private TextDate LeftJText_DateFrom = null;
	private LabelSmallBase LeftJLabel_DateTo = null;
	private TextDate LeftJText_DateTo = null;

	private LabelSmallBase RTJLabel_PATNO = null;
	private TextReadOnly RTJText_PatientNumber = null;
	private LabelSmallBase RTJLabel_PATName = null;
	private TextReadOnly RTJText_PatientName = null;

	private LabelSmallBase LeftJLabel_SlipCount = null;
	private TextReadOnly LeftJText_SlipCountDesc = null;

	private JScrollPane slipScrollPanel = null;
	private ButtonBase newSlip = null;
	private ButtonBase reOpenSlip = null;
	private ButtonBase cancelSlip = null;
	private ButtonBase reactiveSlip = null;
	private ButtonBase unlockSlip = null;
	private ButtonBase unmergeSlip = null;
	private LabelSmallBase forDesc = null;
	private DlgCreateSlip dlgCreateSlip = null;

	private String memSlpNo = null;
//	private String memPrevSlpNo = null;

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		memSlpNo = getParameter("FromSlpNo");
//		memPrevSlpNo = getParameter("PrevSlpNo");

		clearAction();

//		getListTable().setColumnClass(4, new ComboSlipType(), false);
//		getListTable().setColumnClass(5, new ComboSlipStatus(), false);
		getListTable().setColumnAmount(16);
		getListTable().setColumnAmount(17);
		getListTable().setColumnAmount(18);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		if (getListTable().getRowCount() > 0) {
			return getListTable();
		} else {
			return getLeftJText_PatientNo();
		}
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		if (getLeftJText_PatientNo().isEmpty()) {
			Factory.getInstance().addErrorMessage(MSG_PATIENT_NO, getLeftJText_PatientNo());
			return false;
		} else if (getLeftJText_DateFrom().isEmpty()) {
			Factory.getInstance().addErrorMessage(MSG_DATE_REQUIRED, getLeftJText_DateFrom());
			return false;
		} else {
			return true;
		}
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getLeftJText_PatientNo().getText(),
				getLeftJText_ServiceCode().getText(),
				getLeftJCombo_SlipType().getText(),
				getLeftJCombo_ARCompanyCode().getText(),
				getLeftJText_DateFrom().getText(),
				getLeftJText_DateTo().getText(),
				Factory.getInstance().getUserInfo().getUserID()
		};
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		String[] selectedContent = null;
		if (getListSelectedRow() == null) {
			selectedContent = getListTable().getRowContent(0);
		} else {
			selectedContent = getListSelectedRow();
		}
		if ("srhPatStsView".equals(getParameter("Form") != null)) {
			return new String[] { getParameter("slpNo") };
		}
		return new String[] { selectedContent[3] };
	}

	@Override
	protected void getFetchOutputValues(String[] outParam) {
		slipButtonChange();
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	protected boolean isAcceptButtonEnable() {
		return true;
	}

	private void slipButtonChange() {
		getRTJText_PatientNumber().resetText();
		getRTJText_PatientName().resetText();
		getNewSlip().setEnabled(getUserInfo().isOutPatient());
		getReOpenSlip().setEnabled(false);
		getCancelSlip().setEnabled(false);
		getReActiveSlip().setEnabled(false);
		getUnlockSlip().setEnabled(false);
		getUnmergeSlip().setEnabled(false);
		getAcceptButton().setEnabled(false);
		memSlpNo = null;

		if (getListTable().getRowCount() > 0) {
			String[] para = getListTable().getSelectedRowContent();
			if (para != null && para.length > 0) {
				getRTJText_PatientNumber().setText(para[8]);
				getRTJText_PatientName().setText(para[9] + SPACE_VALUE + para[10]);

				memSlpNo = para[3];  //set the current slip No.
				getReOpenSlip().setEnabled(
						ConstantsTransaction.SLIP_STATUS_CLOSE.equals(para[5]) &&
						!isDisableFunction("btnReopen", "srhSlip"));
				getCancelSlip().setEnabled(
						ConstantsTransaction.SLIP_STATUS_OPEN.equals(para[5]) &&
						ZERO_VALUE.equals(para[18]) &&	// SlpNAmt = 0
						ZERO_VALUE.equals(para[22]) &&	// not allow delete if the slip is linked with OT log
						!isDisableFunction("btnCancel", "srhSlip"));
				getReActiveSlip().setEnabled(
						ConstantsTransaction.SLIP_STATUS_REMOVE.equals(para[5]) &&
						!isDisableFunction("cmdReActive", "srhSlip"));
			}
			getUnlockSlip().setEnabled(!isDisableFunction("btnUnlock", "srhSlip"));
			getUnmergeSlip().setEnabled(!isDisableFunction("btnUnmerge", "srhSlip"));

			getAcceptButton().setEnabled(isAcceptButtonEnable());
		}
	}

	// open, close, cancel slip method
	private void updateARCompanyCode(final String slpNo, final String method) {
		QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.SLIP_TXCODE,
				QueryUtil.ACTION_MODIFY, new String[] { method, slpNo, getMainFrame().getComputerIP(), getUserInfo().getUserID() },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					if (!"close".equals(method)) {
						searchAction(true);
					} else {
						showPanel(new TransactionDetail());
					}
				}
				unlockRecord("Slip", slpNo);
			}
			@Override
			public void onFailure(Throwable caught) {
				unlockRecord("Slip", slpNo);
				Factory.getInstance().addErrorMessage("Error in updating Slip.");
			}
		});
	}

	@Override
	public int getColumnKey() {
		return 3;
	}

	private void lockRecord(String action) {
		if (getListTable().getSelectedRow() >= 0) {
			if ("unlock".equals(action)) {
				QueryUtil.executeMasterFetch(getUserInfo(), "SLIPLOCK",
						new String[] { memSlpNo },
						new MessageQueueCallBack() {
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							MessageBox mb = MessageBoxBase.confirm(MSG_PBA_SYSTEM,  "The slip is locked by " + mQueue.getContentField()[1] + ". Do you want to unlock the selected slip?",
									new Listener<MessageBoxEvent>() {
								@Override
								public void handleEvent(MessageBoxEvent be) {
									if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
										QueryUtil.executeMasterAction(getUserInfo(), "RECORDUNLOCK_BYOTHER",
												QueryUtil.ACTION_APPEND, new String[] { "Slip", memSlpNo, CommonUtil.getComputerName(), getUserInfo().getUserID() },
												new MessageQueueCallBack() {
											public void onPostSuccess(MessageQueue mQueue) {
												Factory.getInstance().addErrorMessage("Slip is unlocked!");
											}
										});
									}
								}
							});

							mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
						} else {
							Factory.getInstance().addErrorMessage("Select a locked slip, please!");
						}
					}
				});
			} else if ("unmerge".equals(action)) {
				QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.GETMERGEDSLIP_TXCODE,
						new String[] { memSlpNo },
						new MessageQueueCallBack() {
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							int cnt = mQueue.getContentNum() - 1;
							if (cnt > 0) {
								StringBuffer sb = new StringBuffer();
								sb.append(mQueue.getContentField()[0].replaceAll("<LINE/>", ConstantsVariable.EMPTY_VALUE));
								cnt--;
								if (cnt > 0) {
									sb.append(ConstantsVariable.COMMA_VALUE);
									sb.append(ConstantsVariable.SPACE_VALUE);
									sb.append(mQueue.getContentField()[1].replaceAll("<LINE/>", ConstantsVariable.EMPTY_VALUE));
									cnt--;
								}
								if (cnt > 0) {
									sb.append(ConstantsVariable.COMMA_VALUE);
									sb.append(ConstantsVariable.SPACE_VALUE);
									sb.append(mQueue.getContentField()[2].replaceAll("<LINE/>", ConstantsVariable.EMPTY_VALUE));
									cnt--;
								}
								if (cnt > 0) {
									sb.append(ConstantsVariable.COMMA_VALUE);
									sb.append(ConstantsVariable.SPACE_VALUE);
									sb.append(mQueue.getContentField()[3].replaceAll("<LINE/>", ConstantsVariable.EMPTY_VALUE));
									cnt--;
								}
								if (cnt > 0) {
									sb.append(ConstantsVariable.COMMA_VALUE);
									sb.append(ConstantsVariable.SPACE_VALUE);
									sb.append(mQueue.getContentField()[4].replaceAll("<LINE/>", ConstantsVariable.EMPTY_VALUE));
									cnt--;
								}

								MessageBox mb = MessageBoxBase.confirm(MSG_PBA_SYSTEM,  "The slip is merged with " + sb.toString() + ". Do you want to unmerge the selected slip?",
										new Listener<MessageBoxEvent>() {
									@Override
									public void handleEvent(MessageBoxEvent be) {
										if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
											QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.MERGESLIP_TXCODE,
													QueryUtil.ACTION_DELETE, new String[] { memSlpNo, null, null, null, null, null, null, null, null, null, null, getUserInfo().getUserID() },
													new MessageQueueCallBack() {
												public void onPostSuccess(MessageQueue mQueue) {
													Factory.getInstance().addErrorMessage("Slip is unmerged!");
												}
											});
										}
									}
								});

								mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
							} else {
								Factory.getInstance().addErrorMessage("Select a merged slip, please!");
							}
						} else {
							Factory.getInstance().addErrorMessage("Select a merged slip, please!");
						}
					}
				});
			} else {
				lockRecord("Slip", memSlpNo, new String[] { action });
			}
		} else {
			Factory.getInstance().addErrorMessage("Select a slip, please!");
		}
	}

	@Override
	protected void lockRecordReady(final String lockType, final String lockKey, String[] record, boolean lock, String returnMessage) {
		if (!lock) {
			Factory.getInstance().addErrorMessage(returnMessage);
		} else if ("accept".equals(record[0])) {
			// store parameter
			setParameter("SlpNo", lockKey);

			// show transaction detail
			showPanel(new TransactionDetail());

//			clearAction();
		} else if ("reopen".equals(record[0])) {
			MessageBox mb =MessageBoxBase.confirm(MSG_PBA_SYSTEM,  "Do you want to reopen the selected slip?",
					new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						updateARCompanyCode(lockKey, "open");
					} else if (Dialog.NO.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						unlockRecord("Slip", lockKey);
					}
				}
			});

			mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
		} else if ("cancel".equals(record[0])) {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {"sliptx", "stnid", "slpno ='" + lockKey + "'"},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					String cancelMessage = null;
					if (mQueue.success()) {
						cancelMessage = MSG_CANCEL_SLIP_HAS_DETAILS;
					} else {
						cancelMessage = ConstantsMessage.MSG_CANCEL_SLIP;
					}
					MessageBox mb = MessageBoxBase.confirm(MSG_PBA_SYSTEM,  cancelMessage,
							new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								updateARCompanyCode(lockKey, "cancel");
							} else if (Dialog.NO.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								unlockRecord("Slip", lockKey);
							}
						}
					});

					mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
				}
			});
		} else if ("reactive".equals(record[0])) {
			MessageBox mb = MessageBoxBase.confirm(MSG_PBA_SYSTEM,  "Do you want to reactive the selected slip?",
					new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						updateARCompanyCode(lockKey, "reactive");
					} else if (Dialog.NO.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						unlockRecord("Slip", lockKey);
					}
				}
			});

			mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
		}
	}

	private void selectDefaultSlipType() {
		if ("AMC".equals(Factory.getInstance().getCurrentSteCode())) {
			getLeftJCombo_SlipType().setSelectedIndex(ConstantsTransaction.SLIP_TYPE_OUTPATIENT);
		} else {
			if ((getUserInfo().isInPatient() && getUserInfo().isOutPatient() && getUserInfo().isDayCase()) ||
					(getUserInfo().isInPatient() && getUserInfo().isOutPatient()) ||
					(getUserInfo().isInPatient() && getUserInfo().isDayCase()) ||
					(getUserInfo().isOutPatient() && getUserInfo().isDayCase())) {
				getLeftJCombo_SlipType().setSelectedIndex(ConstantsTransaction.SLIP_TYPE_OUTPATIENT);
			} else if (getUserInfo().isDayCase()) {
				getLeftJCombo_SlipType().setSelectedIndex(ConstantsTransaction.SLIP_TYPE_DAYCASE);
			} else if (getUserInfo().isOutPatient()) {
				getLeftJCombo_SlipType().setSelectedIndex(ConstantsTransaction.SLIP_TYPE_OUTPATIENT);
			} else if (getUserInfo().isInPatient()) {
				getLeftJCombo_SlipType().setSelectedIndex(ConstantsTransaction.SLIP_TYPE_INPATIENT);
			} else {
				getLeftJCombo_SlipType().setSelectedIndex(ConstantsTransaction.SLIP_TYPE_OUTPATIENT);
			}
		}
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	public void rePostAction() {
		clearAction();
	}

	@Override
	public void searchAction() {
		getLeftJText_PatientNo().setOldPatientNo(null);
		if (!triggerSearchField()) {
			if (!getLeftJText_PatientNo().isEmpty()) {
//				getLeftJText_PatientNo().checkMergePatient(false);
			} else {
				getLeftJText_PatientNo().checkPatientAlert();
			}
		}
		searchAction(true);
	}

	/**
	 * override acceptAction method
	 */
	@Override
	public void acceptAction() {
		if ("HomeLeave".equals(getParameter("AcceptClass"))) {
			setParameter("SlpNo", getListSelectedRow()[3]);
			setParameter("AcceptClass", "SlipSearch");
			showPanel(panelFrom, false, true);
		} else {
			lockRecord("accept");
		}
	}

	/**
	 * override clearPostAction method
	 */
	@Override
	protected void clearPostAction() {
		// set default value for combobox
		selectDefaultSlipType();
		getLeftJCombo_ARCompanyCode().resetText();
		getSlipCountDesc().setText(ZERO_VALUE);
	}

	/**
	 * override performListPost method
	 */
	@Override
	protected void performListPost() {
		if (getCurrentListTable().getRowCount() == 0) {
			// reset form if empty table
			clearAction();
		} else {
			getSlipCountDesc().setText(String.valueOf(getCurrentListTable().getRowCount()));
		}
		slipButtonChange();
	}

	/**
	 * override performListPost method
	 */
	@Override
	protected void enableButton(String mode) {
		disableButton();

		getSearchButton().setEnabled(true);
		getAcceptButton().setEnabled(isAcceptButtonEnable());
		getClearButton().setEnabled(true);
		getRefreshButton().setEnabled(true);

		slipButtonChange();
	}


	@Override
	protected boolean triggerSearchField() {
		if (getLeftJText_PatientNo().isFocusOwner()) {
			getLeftJText_PatientNo().checkTriggerBySearchKey();
			return true;
		} else {
			return false;
		}
	}

	/***************************************************************************
	 * Dialog Method
	 **************************************************************************/

	private DlgCreateSlip getDlgCreateSlip() {
		if (dlgCreateSlip == null) {
			dlgCreateSlip = new DlgCreateSlip(getMainFrame()) {
				@Override
				public void post(String ServiceCode) {
					lockRecord("Slip", ServiceCode, new String[] { "accept" });
					dispose();
				}
			};
		}
		return dlgCreateSlip;
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/**
	 * This method initializes leftPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	@Override
	protected BasePanel getSearchPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.setSize(825, 528);
			leftPanel.add(getParaPanel(), null);
			leftPanel.add(getRTPanel(), null);
			leftPanel.add(getListPanel(), null);
			leftPanel.add(getNewSlip(), null);
			leftPanel.add(getReOpenSlip(), null);
			leftPanel.add(getCancelSlip(), null);
			leftPanel.add(getReActiveSlip(), null);
			leftPanel.add(getUnlockSlip(), null);
			leftPanel.add(getUnmergeSlip(), null);
			leftPanel.add(getForDesc(), null);
			leftPanel.add(getSlipCount(), null);
			leftPanel.add(getSlipCountDesc(), null);
		}
		return leftPanel;
	}

	/**
	 * This method initializes paraPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	public BasePanel getParaPanel() {
		if (paraPanel == null) {
			paraPanel = new BasePanel();
			paraPanel.setBorders(true);
			paraPanel.setBounds(5, 5, 815, 55);
			paraPanel.add(getLeftJLabel_PatientNo(), null);
			paraPanel.add(getLeftJText_PatientNo(), null);
			paraPanel.add(getLeftJLabel_ServiceCode(), null);
			paraPanel.add(getLeftJText_ServiceCode(), null);
			paraPanel.add(getLeftJLabel_SlipType(), null);
			paraPanel.add(getLeftJCombo_SlipType(), null);
			paraPanel.add(getLeftJLabel_ARCompanyCode(), null);
			paraPanel.add(getLeftJCombo_ARCompanyCode(), null);
			paraPanel.add(getLeftJLabel_DateFrom(), null);
			paraPanel.add(getLeftJText_DateFrom(), null);
			paraPanel.add(getLeftJLabel_DateTo(), null);
			paraPanel.add(getLeftJText_DateTo(), null);
		}
		return paraPanel;
	}

	/**
	 * This method initializes LeftJLabel_PatientNo
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getLeftJLabel_PatientNo() {
		if (LeftJLabel_PatientNo == null) {
			LeftJLabel_PatientNo = new LabelSmallBase();
			LeftJLabel_PatientNo.setBounds(5, 5, 100, 20);
			LeftJLabel_PatientNo.setText("<font color='blue'>Patient Number</font>");
			LeftJLabel_PatientNo.setOptionalLabel();
		}
		return LeftJLabel_PatientNo;
	}

	/**
	 * This method initializes LeftJText_PatientNo
	 *
	 * @return com.hkah.client.layout.textfield.TextPatientNo
	 */
	private TextPatientNoSearch getLeftJText_PatientNo() {
		if (LeftJText_PatientNo == null) {
			LeftJText_PatientNo = new TextPatientNoSearch(true, true) {
				protected void checkPatient(boolean isExistPatient, boolean bySearchKey) {
					super.checkPatient(isExistPatient, bySearchKey);
					if (isExistPatient && bySearchKey) {
						getLeftJText_PatientNo().checkPatientAlert();
						searchAction(true);
					}
				}

				@Override
				protected void showMergeFromPatientPost() {
					getLeftJText_PatientNo().checkPatientAlert();
//					searchAction(true);
//					getLeftJText_ServiceCode().focus();
				}

				@Override
				protected void showMergePatientPost() {
					showSearchPanel();
					resetText();
				}
			};
//			LeftJText_PatientNo.setShowAllAlert(false);
			LeftJText_PatientNo.setBounds(100, 5, 120, 20);
		}
		return LeftJText_PatientNo;
	}

	/**
	 * This method initializes LeftJLabel_ServiceCode
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getLeftJLabel_ServiceCode() {
		if (LeftJLabel_ServiceCode == null) {
			LeftJLabel_ServiceCode = new LabelSmallBase();
			LeftJLabel_ServiceCode.setBounds(265, 5, 130, 20);
			LeftJLabel_ServiceCode.setText("<font color='blue'>Service Code</font>");
			LeftJLabel_ServiceCode.setOptionalLabel();
		}
		return LeftJLabel_ServiceCode;
	}

	/**
	 * This method initializes LeftJText_ServiceCode
	 *
	 * @return com.hkah.client.layout.textfield.TextServiceCode
	 */
	private ComboDeptService getLeftJText_ServiceCode() {
		if (LeftJText_ServiceCode == null) {
			LeftJText_ServiceCode = new ComboDeptService();
			LeftJText_ServiceCode.setBounds(400, 5, 120, 20);
		}
		return LeftJText_ServiceCode;
	}

	/**
	 * This method initializes LeftJLabel_SlipType
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getLeftJLabel_SlipType() {
		if (LeftJLabel_SlipType == null) {
			LeftJLabel_SlipType = new LabelSmallBase();
			LeftJLabel_SlipType.setBounds(550, 5, 130, 20);
			LeftJLabel_SlipType.setText("<font color='blue'>Slip Type</font>");
		}
		return LeftJLabel_SlipType;
	}

	/**
	 * This method initializes LeftJCombo_SlipType
	 *
	 * @return com.hkah.client.layout.combo.ComboSlipType
	 */
	private ComboSlipType getLeftJCombo_SlipType() {
		if (LeftJCombo_SlipType == null) {
			LeftJCombo_SlipType = new ComboSlipType();
			LeftJCombo_SlipType.setBounds(675, 5, 120, 20);
		}
		return LeftJCombo_SlipType;
	}

	/**
	 * This method initializes LeftJLabel_ARCompanyCode
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getLeftJLabel_ARCompanyCode() {
		if (LeftJLabel_ARCompanyCode == null) {
			LeftJLabel_ARCompanyCode = new LabelSmallBase();
			LeftJLabel_ARCompanyCode.setBounds(5, 28, 100, 20);
			LeftJLabel_ARCompanyCode.setText("<font color='blue'>AR Code</font>");
		}
		return LeftJLabel_ARCompanyCode;
	}

	/**
	 * This method initializes LeftJCombo_ARCompanyCode
	 *
	 * @return com.hkah.client.layout.combo.HKAHComboBoxBase
	 */
	private ComboARCompany getLeftJCombo_ARCompanyCode() {
		if (LeftJCombo_ARCompanyCode == null) {
			LeftJCombo_ARCompanyCode = new ComboARCompany();
			LeftJCombo_ARCompanyCode.setBounds(100, 28, 120, 20);
		}
		return LeftJCombo_ARCompanyCode;
	}

	/**
	 * This method initializes LeftJLabel_DateFrom
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getLeftJLabel_DateFrom() {
		if (LeftJLabel_DateFrom == null) {
			LeftJLabel_DateFrom = new LabelSmallBase();
			LeftJLabel_DateFrom.setBounds(265, 28, 130, 20);
			LeftJLabel_DateFrom.setText("<font color='blue'>Date From</font>");
			LeftJLabel_DateFrom.setOptionalLabel();
		}
		return LeftJLabel_DateFrom;
	}

	/**
	 * This method initializes LeftJText_DateFrom
	 *
	 * @return com.hkah.client.layout.textfield.TextName
	 */
	private TextDate getLeftJText_DateFrom() {
		if (LeftJText_DateFrom == null) {
			LeftJText_DateFrom = new TextDate();
			LeftJText_DateFrom.setBounds(400, 28, 120, 20);
		}
		return LeftJText_DateFrom;
	}

	/**
	 * This method initializes LeftJLabel_DateTo
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getLeftJLabel_DateTo() {
		if (LeftJLabel_DateTo == null) {
			LeftJLabel_DateTo = new LabelSmallBase();
			LeftJLabel_DateTo.setBounds(550, 28, 130, 20);
			LeftJLabel_DateTo.setText("<font color='blue'>Date To</font>");
			LeftJLabel_DateTo.setOptionalLabel();
		}
		return LeftJLabel_DateTo;
	}

	/**
	 * This method initializes LeftJText_DateTo
	 *
	 * @return com.hkah.client.layout.textfield.TextName
	 */
	private TextDate getLeftJText_DateTo() {
		if (LeftJText_DateTo == null) {
			LeftJText_DateTo = new TextDate();
			LeftJText_DateTo.setBounds(675, 28, 120, 20);
		}
		return LeftJText_DateTo;
	}

	public BasePanel getRTPanel() {
		if (RTPanel == null) {
			RTPanel = new BasePanel();
			RTPanel.setBorders(true);
			RTPanel.setBounds(5, 65, 815, 30);
			RTPanel.add(getRTJLabel_PATNO(), null);
			RTPanel.add(getRTJText_PatientNumber(), null);
			RTPanel.add(getRTJLabel_PATName(), null);
			RTPanel.add(getRTJText_PatientName(), null);
		}
		return RTPanel;
	}

	private LabelSmallBase getRTJLabel_PATNO() {
		if (RTJLabel_PATNO == null) {
			RTJLabel_PATNO = new LabelSmallBase();
			RTJLabel_PATNO.setText("Patient Number");
			RTJLabel_PATNO.setBounds(10, 3, 100, 20);
		}
		return RTJLabel_PATNO;
	}

	private TextReadOnly getRTJText_PatientNumber() {
		if (RTJText_PatientNumber == null) {
			RTJText_PatientNumber = new TextReadOnly();
			RTJText_PatientNumber.setBounds(100, 3, 80, 20);
		}
		return RTJText_PatientNumber;
	}

	private LabelSmallBase getRTJLabel_PATName() {
		if (RTJLabel_PATName == null) {
			RTJLabel_PATName = new LabelSmallBase();
			RTJLabel_PATName.setText("Patient Name");
			RTJLabel_PATName.setBounds(200, 3, 95, 20);
		}
		return RTJLabel_PATName;
	}

	private TextReadOnly getRTJText_PatientName() {
		if (RTJText_PatientName == null) {
			RTJText_PatientName = new TextReadOnly();
			RTJText_PatientName.setBounds(285, 3, 180, 20);
		}
		return RTJText_PatientName;
	}

	/**
	 * This method initializes leftPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	public BasePanel getListPanel() {
		if (listPanel == null) {
			listPanel = new BasePanel();
			listPanel.setEtchedBorder();
			listPanel.setBounds(5, 100, 815, 395);
			listPanel.add(getSlipScrollPanel());
		}
		return listPanel;
	}

	/**
	 * This method initializes jScrollPane
	 *
	 * @return JScrollPane
	 */
	protected JScrollPane getSlipScrollPanel() {
		if (slipScrollPanel == null) {
			getJScrollPane().removeViewportView(getListTable());
			slipScrollPanel = new JScrollPane();
			slipScrollPanel.setViewportView(getListTable());
			slipScrollPanel.setBounds(5, 5, 803, 383);
		}
		return slipScrollPanel;
	}

	private ButtonBase getNewSlip() {
		if (newSlip == null) {
			newSlip = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgCreateSlip().showDialog(isAcceptButtonEnable());
				}
			};
			newSlip.setText("New Slip", 'N');
			newSlip.setBounds(10, 500, 80, 25);
		}
		return newSlip;
	}

	private ButtonBase getReOpenSlip() {
		if (reOpenSlip == null) {
			reOpenSlip = new ButtonBase() {
				@Override
				public void onClick() {
					lockRecord("reopen");
				}
			};
			reOpenSlip.setText("Reopen Slip", 'R');
			reOpenSlip.setBounds(95, 500, 90, 25);
		}
		return reOpenSlip;
	}

	private ButtonBase getCancelSlip() {
		if (cancelSlip == null) {
			cancelSlip = new ButtonBase() {
				@Override
				public void onClick() {
					lockRecord("cancel");
				}
			};
			cancelSlip.setText("Cancel Slip", 'C');
			cancelSlip.setBounds(190, 500, 90, 25);
		}
		return cancelSlip;
	}

	private ButtonBase getReActiveSlip() {
		if (reactiveSlip == null) {
			reactiveSlip = new ButtonBase() {
				@Override
				public void onClick() {
					lockRecord("reactive");
				}
			};
			reactiveSlip.setText("Re-Active Slip", 'A');
			reactiveSlip.setBounds(285, 500, 90, 25);
		}
		return reactiveSlip;
	}

	private ButtonBase getUnlockSlip() {
		if (unlockSlip == null) {
			unlockSlip = new ButtonBase() {
				@Override
				public void onClick() {
					lockRecord("unlock");
				}
			};
			unlockSlip.setText("Unlock Slip", 'l');
			unlockSlip.setBounds(380, 500, 90, 25);
		}
		return unlockSlip;
	}

	private ButtonBase getUnmergeSlip() {
		if (unmergeSlip == null) {
			unmergeSlip = new ButtonBase() {
				@Override
				public void onClick() {
					lockRecord("unmerge");
				}
			};
			unmergeSlip.setText("Unmerge Slip", 'm');
			unmergeSlip.setBounds(475, 500, 90, 25);
		}
		return unmergeSlip;
	}

	private LabelSmallBase getSlipCount() {
		if (LeftJLabel_SlipCount == null) {
			LeftJLabel_SlipCount = new LabelSmallBase();
			LeftJLabel_SlipCount.setText("Count:");
			LeftJLabel_SlipCount.setBounds(640, 500, 45, 20);
		}
		return LeftJLabel_SlipCount;
	}

	private TextReadOnly getSlipCountDesc() {
		if (LeftJText_SlipCountDesc == null) {
			LeftJText_SlipCountDesc = new TextReadOnly();
			LeftJText_SlipCountDesc.setBounds(675, 500, 45, 20);
			LeftJText_SlipCountDesc.setText(ZERO_VALUE);
			LeftJText_SlipCountDesc.setAllowReset(false);
		}
		return LeftJText_SlipCountDesc;
	}

	private LabelSmallBase getForDesc() {
		if (forDesc == null) {
			forDesc = new LabelSmallBase();
			forDesc.setText("<font color='green'>#---For OB Letter<br>*---For Remarks</font>");
			forDesc.setBounds(735, 495, 120, 40);
		}
		return forDesc;
	}
}