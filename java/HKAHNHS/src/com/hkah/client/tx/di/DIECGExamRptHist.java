package com.hkah.client.tx.di;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.MessageBox;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboSlipStatus;
import com.hkah.client.layout.combobox.ComboSlipType;
import com.hkah.client.layout.dialog.DlgCreateSlip;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.textfield.TextDateWithCheckBox;
import com.hkah.client.layout.textfield.TextDoctorSearch;
import com.hkah.client.layout.textfield.TextName;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextSlipNo;
import com.hkah.client.tx.SearchPanel;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTransaction;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DIECGExamRptHist extends SearchPanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.TRANSACTION_DETAIL_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.SLIPSEARCH_TITLE;
	}

	/**
	 * This method initializes
	 */
	public DIECGExamRptHist() {
		super();
	}

	public DIECGExamRptHist(BasePanel panelFrom) {
		super();
		this.panelFrom = panelFrom;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				EMPTY_VALUE,
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
				"Reg Date",
				"Discharge Date",
				"Total Charge",
				"Total Payment",
				"Total Net Amt",
				"User ID",
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				"Slip Date"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				15,
				15,
				20,
				YES_VALUE.equals(getSysParameter("TxRegDt")) ? 110 : 0,
				80,
				35,
				40,
				55,
				60,
				60,
				110,
				110,
				55,
				90,
				120,
				110,
				110,
				85,
				90,
				100,
				60,
				0,
				0,
				0,
				110
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
	private BasePanel listPanel = null;
	private LabelSmallBase LeftJLabel_PatientNo = null;
	private TextPatientNoSearch LeftJText_PatientNo = null;
	private LabelSmallBase LeftJLabel_SlipNo = null;
	private TextSlipNo LeftJText_SlipNo = null;
	private LabelSmallBase LeftJLabel_SlipType = null;
	private ComboSlipType LeftJCombo_SlipType = null;
	private LabelSmallBase LeftJLabel_SlipStatus = null;
	private ComboSlipStatus LeftJCombo_SlipStatus = null;
	private LabelSmallBase LeftJLabel_PatientFamilyName = null;
	private TextName LeftJText_PatientFamilyName = null;
	private LabelSmallBase LeftJLabel_PatientGivenName = null;
	private TextName LeftJText_PatientGivenName = null;
	private LabelSmallBase LeftJLabel_DoctorCode = null;
	private TextDoctorSearch LeftJText_DoctorCode = null;
	private LabelSmallBase LeftJLabel_RegDateFrom = null;
	private TextDateWithCheckBox LeftJText_RegDateFrom = null;
	private CheckBoxBase LeftJRadioButton_NoPatientNumber = null;
	private LabelSmallBase LeftJLabel_NoPatientNumber = null;
	private LabelSmallBase LeftJLabel_SlipCount = null;
	private TextReadOnly LeftJText_SlipCountDesc = null;

	private JScrollPane slipScrollPanel = null;
	private ButtonBase newSlip = null;
	private ButtonBase reOpenSlip = null;
	private ButtonBase cancelSlip = null;
	private ButtonBase reactiveSlip = null;
	private ButtonBase unlockSlip = null;
	private ButtonBase unmergeSlip = null;
	private DlgCreateSlip dlgCreateSlip = null;

	private LabelSmallBase forDesc1 = null;
	private LabelSmallBase forDesc2 = null;

	private String memSlpNo = null;
//	private String memPrevSlpNo = null;

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		memSlpNo = getParameter("FromSlpNo");
//		memPrevSlpNo = getParameter("PrevSlpNo");

		clearAction();

//		getListTable().setColumnClass(5, new ComboSlipType(), false);
//		getListTable().setColumnClass(6, new ComboSlipStatus(), false);
		getListTable().setColumnAmount(17);
		getListTable().setColumnAmount(18);
		getListTable().setColumnAmount(19);
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
		if (!getLeftJText_PatientNo().isEmpty()
				|| !getLeftJText_SlipNo().isEmpty()
				|| (!getLeftJCombo_SlipType().isEmpty() && getLeftJCombo_SlipStatus().isActive())
				|| (!getLeftJText_RegDateFrom().isEmpty() && getLeftJText_RegDateFrom().isValid())) {
			return true;
		} else if (getLeftJText_PatientNo().isEmpty() && getLeftJText_SlipNo().isEmpty() && getLeftJCombo_SlipStatus().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please select slip status.", getLeftJCombo_SlipStatus());
			return false;
		} else if (!getLeftJText_RegDateFrom().isEmpty() && !getLeftJText_RegDateFrom().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid reg date from.", getLeftJText_RegDateFrom());
			return false;
		} else if (
			getLeftJCombo_SlipType().getText().isEmpty() &&
			getLeftJText_PatientFamilyName().isEmpty() &&
			getLeftJText_PatientGivenName().isEmpty() &&
			getLeftJText_DoctorCode().isEmpty()
		) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_INPUT_CRITERIA, "Slip Search", getDefaultFocusComponent());
			return false;
		} else {
			Factory.getInstance().addErrorMessage("Please input reg date from.", getLeftJText_RegDateFrom());
			return false;
		}
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getLeftJText_PatientNo().getText(),
				getLeftJText_SlipNo().getText(),
				getLeftJCombo_SlipType().getText(),
				getLeftJCombo_SlipStatus().getText(),
				getLeftJText_PatientFamilyName().getText(),
				getLeftJText_PatientGivenName().getText(),
				getLeftJText_DoctorCode().getText(),
				getLeftJText_RegDateFrom().getText(),
				getLeftJRadioButton_NoPatientNumber().isSelected()?YES_VALUE:NO_VALUE,
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
		return new String[] { selectedContent[4] };
	}

	@Override
	protected void getFetchOutputValues(String[] outParam) {
		slipButtonChange();
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	protected boolean isAcceptButtonEnable() {
		return false;
	}

	private void slipButtonChange() {
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
				memSlpNo = para[4];  //set the current slip No.
				getReOpenSlip().setEnabled(
						ConstantsTransaction.SLIP_STATUS_CLOSE.equals(para[6]) &&
						!isDisableFunction("btnReopen", "srhSlip"));
				getCancelSlip().setEnabled(
						ConstantsTransaction.SLIP_STATUS_OPEN.equals(para[6]) &&
						ZERO_VALUE.equals(para[19]) &&	// SlpNAmt = 0
						ZERO_VALUE.equals(para[23]) &&	// not allow delete if the slip is linked with OT log
						!isDisableFunction("btnCancel", "srhSlip"));
				getReActiveSlip().setEnabled(
						ConstantsTransaction.SLIP_STATUS_REMOVE.equals(para[6]) &&
						!isDisableFunction("cmdReActive", "srhSlip"));
				getUnmergeSlip().setEnabled(
						para[2].length() > 0 &&
						!isDisableFunction("btnUnmerge", "srhSlip"));
			}
			getUnlockSlip().setEnabled(!isDisableFunction("btnUnlock", "srhSlip"));

			getAcceptButton().setEnabled(isAcceptButtonEnable());
		}
	}

	@Override
	public int getColumnKey() {
		return 4;
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

	protected void setEditablePatientNo() {
		// check no patient no cb
		if (getLeftJRadioButton_NoPatientNumber().isSelected()) {
			getLeftJText_PatientNo().setEditableForever(false);
		} else {
			getLeftJText_PatientNo().setEditableForever(true);
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
				getLeftJCombo_SlipType().setSelectedIndex(ConstantsVariable.EMPTY_VALUE);
			} else if (getUserInfo().isDayCase()) {
				getLeftJCombo_SlipType().setSelectedIndex(ConstantsTransaction.SLIP_TYPE_DAYCASE);
			} else if (getUserInfo().isOutPatient()) {
				getLeftJCombo_SlipType().setSelectedIndex(ConstantsTransaction.SLIP_TYPE_OUTPATIENT);
			} else if (getUserInfo().isInPatient()) {
				getLeftJCombo_SlipType().setSelectedIndex(ConstantsTransaction.SLIP_TYPE_INPATIENT);
			} else {
				getLeftJCombo_SlipType().setSelectedIndex(ConstantsVariable.EMPTY_VALUE);
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
			setParameter("SlpNo", getListSelectedRow()[4]);
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
		getLeftJCombo_SlipStatus().setSelectedIndex(0);
		setEditablePatientNo();
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

		if (!getLeftJText_PatientNo().isEmpty()) {
			getLeftJText_PatientNo().checkMergePatient();
		} else if (getCurrentListTable().getRowCount() == 1) {
			String patno = getCurrentListTable().getRowContent(0)[9];
			if (patno != null && patno.length() > 0) {
				getLeftJText_PatientNo().checkPatientAlert(patno);
			}
		}
	}

	/**
	 * override enableButton method
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
		} else if (getLeftJText_DoctorCode().isFocusOwner()) {
			getLeftJText_DoctorCode().checkTriggerBySearchKey();
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
				public void post(String slipNo) {
					lockRecord("Slip", slipNo, new String[] { "accept", "newSlip" });
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
			leftPanel.add(getListPanel(), null);
			leftPanel.add(getNewSlip(), null);
			leftPanel.add(getReOpenSlip(), null);
			leftPanel.add(getCancelSlip(), null);
			leftPanel.add(getReActiveSlip(), null);
			leftPanel.add(getUnlockSlip(), null);
			leftPanel.add(getUnmergeSlip(), null);
			leftPanel.add(getForDesc1(), null);
			leftPanel.add(getForDesc2(), null);
			leftPanel.add(getSlipCount(), null);
			leftPanel.add(getSlipCountDesc(), null);
		}
		return leftPanel;
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
			listPanel.setBounds(5, 90, 815, 407);
			listPanel.add(getSlipScrollPanel());
		}
		return listPanel;
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
			paraPanel.setBounds(5, 5, 815, 80);
			paraPanel.add(getLeftJLabel_PatientNo(), null);
			paraPanel.add(getLeftJText_PatientNo(), null);
			paraPanel.add(getLeftJLabel_SlipNo(), null);
			paraPanel.add(getLeftJText_SlipNo(), null);
			paraPanel.add(getLeftJLabel_SlipType(), null);
			paraPanel.add(getLeftJCombo_SlipType(), null);
			paraPanel.add(getLeftJLabel_SlipStatus(), null);
			paraPanel.add(getLeftJCombo_SlipStatus(), null);
			paraPanel.add(getLeftJLabel_PatientFamilyName(), null);
			paraPanel.add(getLeftJText_PatientFamilyName(), null);
			paraPanel.add(getLeftJLabel_PatientGivenName(), null);
			paraPanel.add(getLeftJText_PatientGivenName(), null);
			paraPanel.add(getLeftJLabel_DoctorCode(), null);
			paraPanel.add(getLeftJText_DoctorCode(), null);
			paraPanel.add(getLeftJLabel_RegDateFrom(), null);
			paraPanel.add(getLeftJText_RegDateFrom(), null);
			paraPanel.add(getLeftJRadioButton_NoPatientNumber(), null);
			paraPanel.add(getLeftJLabel_NoPatientNumber(), null);
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
			LeftJLabel_PatientNo.setText("Patient Number");
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
			LeftJText_PatientNo = new TextPatientNoSearch(true, false) {
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
//					getLeftJText_SlipNo().focus();
				}

				@Override
				protected void showMergePatientPost() {
					showSearchPanel();
					resetText();
				}
			};
//			LeftJText_PatientNo.setShowAllAlert(false);
			LeftJText_PatientNo.setBounds(100, 5, 120, 20);
			LeftJText_PatientNo.setShowAlertByRequest(true);
		}
		return LeftJText_PatientNo;
	}

	/**
	 * This method initializes LeftJLabel_SlipNo
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getLeftJLabel_SlipNo() {
		if (LeftJLabel_SlipNo == null) {
			LeftJLabel_SlipNo = new LabelSmallBase();
			LeftJLabel_SlipNo.setBounds(265, 5, 130, 20);
			LeftJLabel_SlipNo.setText("Slip Number");
			LeftJLabel_SlipNo.setOptionalLabel();
		}
		return LeftJLabel_SlipNo;
	}

	/**
	 * This method initializes LeftJText_SlipNo
	 *
	 * @return com.hkah.client.layout.textfield.TextSlipNo
	 */
	private TextSlipNo getLeftJText_SlipNo() {
		if (LeftJText_SlipNo == null) {
			LeftJText_SlipNo = new TextSlipNo();
			LeftJText_SlipNo.setBounds(400, 5, 120, 20);
		}
		return LeftJText_SlipNo;
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
			LeftJLabel_SlipType.setText("Slip Type");
			LeftJLabel_SlipType.setOptionalLabel();
		}
		return LeftJLabel_SlipType;
	}

	/**
	 * This method initializes LeftJCombo_SlipType
	 *
	 * @return com.hkah.client.layout.combo.HKAHComboSlipType
	 */
	private ComboSlipType getLeftJCombo_SlipType() {
		if (LeftJCombo_SlipType == null) {
			LeftJCombo_SlipType = new ComboSlipType();
			LeftJCombo_SlipType.setBounds(675, 5, 120, 20);
		}
		return LeftJCombo_SlipType;
	}

	/**
	 * This method initializes LeftJLabel_SlipStatus
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getLeftJLabel_SlipStatus() {
		if (LeftJLabel_SlipStatus == null) {
			LeftJLabel_SlipStatus = new LabelSmallBase();
			LeftJLabel_SlipStatus.setBounds(5, 28, 100, 20);
			LeftJLabel_SlipStatus.setText("Slip Status");
			LeftJLabel_SlipStatus.setOptionalLabel();
		}
		return LeftJLabel_SlipStatus;
	}

	/**
	 * This method initializes LeftJCombo_SlipStatus
	 *
	 * @return com.hkah.client.layout.combo.HKAHComboSlipStatus
	 */
	private ComboSlipStatus getLeftJCombo_SlipStatus() {
		if (LeftJCombo_SlipStatus == null) {
			LeftJCombo_SlipStatus = new ComboSlipStatus();
			LeftJCombo_SlipStatus.setBounds(100, 28, 120, 20);
		}
		return LeftJCombo_SlipStatus;
	}

	/**
	 * This method initializes LeftJLabel_PatientFamilyName
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getLeftJLabel_PatientFamilyName() {
		if (LeftJLabel_PatientFamilyName == null) {
			LeftJLabel_PatientFamilyName = new LabelSmallBase();
			LeftJLabel_PatientFamilyName.setBounds(265, 28, 130, 20);
			LeftJLabel_PatientFamilyName.setText("Patient Family Name");
			LeftJLabel_PatientFamilyName.setOptionalLabel();
		}
		return LeftJLabel_PatientFamilyName;
	}

	/**
	 * This method initializes LeftJText_PatientFamilyName
	 *
	 * @return com.hkah.client.layout.textfield.TextName
	 */
	private TextName getLeftJText_PatientFamilyName() {
		if (LeftJText_PatientFamilyName == null) {
			LeftJText_PatientFamilyName = new TextName();
			LeftJText_PatientFamilyName.setBounds(400, 28, 120, 20);
		}
		return LeftJText_PatientFamilyName;
	}

	/**
	 * This method initializes LeftJLabel_PatientGivenName
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getLeftJLabel_PatientGivenName() {
		if (LeftJLabel_PatientGivenName == null) {
			LeftJLabel_PatientGivenName = new LabelSmallBase();
			LeftJLabel_PatientGivenName.setBounds(550, 28, 130, 20);
			LeftJLabel_PatientGivenName.setText("Patient Given Name");
			LeftJLabel_PatientGivenName.setOptionalLabel();
		}
		return LeftJLabel_PatientGivenName;
	}

	/**
	 * This method initializes LeftJText_PatientGivenName
	 *
	 * @return com.hkah.client.layout.textfield.TextName
	 */
	private TextName getLeftJText_PatientGivenName() {
		if (LeftJText_PatientGivenName == null) {
			LeftJText_PatientGivenName = new TextName();
			LeftJText_PatientGivenName.setBounds(675, 28, 120, 20);
		}
		return LeftJText_PatientGivenName;
	}

	/**
	 * This method initializes LeftJLabel_DoctorCode
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getLeftJLabel_DoctorCode() {
		if (LeftJLabel_DoctorCode == null) {
			LeftJLabel_DoctorCode = new LabelSmallBase();
			LeftJLabel_DoctorCode.setBounds(5, 51, 100, 20);
			LeftJLabel_DoctorCode.setText("Doctor Code");
			LeftJLabel_DoctorCode.setOptionalLabel();
		}
		return LeftJLabel_DoctorCode;
	}

	/**
	 * This method initializes LeftJText_DoctorCode
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextDoctorSearch getLeftJText_DoctorCode() {
		if (LeftJText_DoctorCode == null) {
			LeftJText_DoctorCode = new TextDoctorSearch();
			LeftJText_DoctorCode.setBounds(100, 51, 120, 20);
		}
		return LeftJText_DoctorCode;
	}

	/**
	 * This method initializes LeftJLabel_RegDateFrom
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getLeftJLabel_RegDateFrom() {
		if (LeftJLabel_RegDateFrom == null) {
			LeftJLabel_RegDateFrom = new LabelSmallBase();
			LeftJLabel_RegDateFrom.setBounds(265, 51, 100, 20);
			LeftJLabel_RegDateFrom.setText("Reg Date From");
			LeftJLabel_RegDateFrom.setOptionalLabel();
		}
		return LeftJLabel_RegDateFrom;
	}

	/**
	 * This method initializes LeftJText_RegDateFrom
	 *
	 * @return com.hkah.client.layout.textfield.TextDateWithCheckBox
	 */
	private TextDateWithCheckBox getLeftJText_RegDateFrom() {
		if (LeftJText_RegDateFrom == null) {
			LeftJText_RegDateFrom = new TextDateWithCheckBox();
			LeftJText_RegDateFrom.setBounds(400, 51, 120, 20);
		}
		return LeftJText_RegDateFrom;
	}

	/**
	 * This method initializes LeftJRadioButton_NoPatientNumber
	 *
	 * @return com.hkah.client.layout.button.RadioButtonBase
	 */
	private CheckBoxBase getLeftJRadioButton_NoPatientNumber() {
		if (LeftJRadioButton_NoPatientNumber == null) {
			LeftJRadioButton_NoPatientNumber = new CheckBoxBase() {
				public void onClick() {
					if (LeftJRadioButton_NoPatientNumber.isSelected()) {
						getLeftJText_PatientNo().setEditableForever(false);
						getLeftJText_PatientNo().resetText();
						getLeftJText_SlipNo().focus();
					} else {
						getLeftJText_PatientNo().setEditableForever(true);
						getLeftJText_PatientNo().requestFocus();
					}
				}
			};
			LeftJRadioButton_NoPatientNumber.setBounds(615, 55, 20, 20);
		}
		return LeftJRadioButton_NoPatientNumber;
	}

	/**
	 * This method initializes LeftJLabel_NoPatientNumber
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getLeftJLabel_NoPatientNumber() {
		if (LeftJLabel_NoPatientNumber == null) {
			LeftJLabel_NoPatientNumber = new LabelSmallBase();
			LeftJLabel_NoPatientNumber.setBounds(637, 55, 210, 20);
			LeftJLabel_NoPatientNumber.setText("This Slip has No Patient Number");
			LeftJLabel_NoPatientNumber.setOptionalLabel();
		}
		return LeftJLabel_NoPatientNumber;
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
			slipScrollPanel.setBounds(5, 5, 803, 397);
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

	private LabelSmallBase getForDesc1() {
		if (forDesc1 == null) {
			forDesc1 = new LabelSmallBase();
			forDesc1.setText("#--- OB Letter<br>*---- Remarks");
			forDesc1.setBounds(580, 495, 100, 40);
			forDesc1.setRemarkLabel();
		}
		return forDesc1;
	}

	private LabelSmallBase getForDesc2() {
		if (forDesc2 == null) {
			forDesc2 = new LabelSmallBase();
			forDesc2.setText("M--- Merged<br>P---- Primary");
			forDesc2.setBounds(660, 495, 100, 40);
			forDesc2.setRemarkLabel();
		}
		return forDesc2;
	}

	private LabelSmallBase getSlipCount() {
		if (LeftJLabel_SlipCount == null) {
			LeftJLabel_SlipCount = new LabelSmallBase();
			LeftJLabel_SlipCount.setText("Count:");
			LeftJLabel_SlipCount.setBounds(740, 500, 45, 20);
		}
		return LeftJLabel_SlipCount;
	}

	private TextReadOnly getSlipCountDesc() {
		if (LeftJText_SlipCountDesc == null) {
			LeftJText_SlipCountDesc = new TextReadOnly();
			LeftJText_SlipCountDesc.setBounds(775, 500, 45, 20);
			LeftJText_SlipCountDesc.setText(ZERO_VALUE);
			LeftJText_SlipCountDesc.setAllowReset(false);
		}
		return LeftJText_SlipCountDesc;
	}
}