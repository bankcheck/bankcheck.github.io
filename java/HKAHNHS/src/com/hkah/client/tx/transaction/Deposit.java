package com.hkah.client.tx.transaction;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.MessageBox;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboDepositStatus;
import com.hkah.client.layout.combobox.ComboRefundMethod;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.BufferedTableList;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.ActionPaymentPanel;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class Deposit extends ActionPaymentPanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.DEPOSIT_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.DEPOSIT_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"",
			"Slip No.",
			"Item Code",
			"Status",
			"Amount",
			"Date",
			"",
			"",
			"Description"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				10,
				80,
				70,
				80,
				70,
				70,
				0,
				0,
				90
				};
	}

	private BasePanel actionPanel = null;
	private BasePanel listPanel = null;
	private LabelBase patNoDesc = null;
	private TextPatientNoSearch patNo = null;
	private LabelBase firstNameDesc = null;
	private TextString firstName = null;
	private LabelBase givenNameDesc = null;
	private TextString givenName = null;
	private LabelBase depositStsDesc = null;
	private ComboDepositStatus depositSts = null;
	private LabelBase despositDesc = null;
	private JScrollPane depositScrollPane = null;
	private LabelBase slpDesc = null;
	private BufferedTableList slpListTable = null;
	private JScrollPane slpScrollPane = null;
	private LabelBase refundMethodDesc = null;
	private ComboRefundMethod refundMethod = null;
	private ButtonBase transfer = null;
//	private TextAmount transferAmount = null;
	private ButtonBase refund = null;
	private ButtonBase writeOff = null;
	private LabelBase paymentDesc = null;
	private BufferedTableList payListTable = null;
	private JScrollPane payScrollPane = null;
//	private boolean patNoError = false;

	private String memActionType = null;
	private String memAvailDeposit_Slpno = null;
	private String memAvailDeposit_ItmCode = null;
	private String memAvailDeposit_Amount = null;
	private String memAvailDeposit_dpsid = null;
	private String memAvailSlip_Slpno = null;

	private static final String DEPOSIT_STATUS_AVAILABLE = "A";

	/**
	 * This method initializes
	 *
	 */
	public Deposit() {
		super();
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getListTable().setColumnAmount(4);
		getPayListTable().setColumnAmount(1);
		setNoListDB(false);

		String patno = getParameter("PatNo");
		if (patno != null && patno.length() > 0) {
			getPatNo().setText(patno);
			getPatNo().onBlur();

			resetParameter("PatNo");
		}
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextPatientNoSearch getDefaultFocusComponent() {
		return getPatNo();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	@Override
	protected void deleteDisabledFields() {
		// enable/disable field
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		return true;
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
			null,
			getPatNo().getText().trim(),
			getDepositSts().getText().trim(),
			getFirstName().getText().trim(),
			getGivenName().getText().trim(),
			null
		};
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		String[] selectedContent = getListSelectedRow();
		return new String[] {
				selectedContent[0]
		};
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
		showPaymentDetail();
		enableButton();
	}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {
	}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {
				memActionType,
				memAvailDeposit_Slpno,
				memAvailDeposit_dpsid,
				memAvailDeposit_ItmCode,
				memAvailSlip_Slpno,
				getRefundMethod().getText(),
				memPayee,
				memPatAddr1,
				memPatAddr2,
				memPatAddr3,
				memCountry,
				memReason,
				// ecr
				memS9000YN ? YES_VALUE: NO_VALUE,
				memTmpReceiptNumber,
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
				memTxnAResp,
				// credit card/octopus end
				CommonUtil.getComputerName(),
				getUserInfo().getCashierCode(),
				getUserInfo().getUserID()
		};
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(final String actionType) {
		actionValidation(actionType, true, "Deposit refund",
				getRefundMethod().getText(), CASHTX_TXNTYPE_PAYOUT, memAvailDeposit_Amount, memAvailDeposit_Amount,
				getPatNo().getText(), memAvailDeposit_Slpno, null, null,
				null, null, null, null);
	}

	/***************************************************************************
	 * Override Methods
	 **************************************************************************/
	@Override
	protected void actionValidationReadyHelper(String actionType, MessageQueue mQueue) {
		//refund successfully
		if (mQueue.success()) {
			Factory.getInstance().addInformationMessage("Deposit successfully refunded");
		}
	}

	@Override
	protected void proExitPanel() {
		setActionType(null);
	}

	@Override
	protected void enableButton(String mode) {
		disableButton();
		getSearchButton().setEnabled(true);
		getRefreshButton().setEnabled(getListTable().getRowCount() > 0 || getSlpListTable().getRowCount() > 0);

		if (getListTable().getRowCount() > 0 && Deposit.DEPOSIT_STATUS_AVAILABLE.equals(getListSelectedRow()[3])) {
			getTransfer().setEnabled(getSlpListTable().getRowCount() > 0);
			getWriteOff().setEnabled(true);
			getRefund().setEnabled(getUserInfo().isCashier());
		} else {
			getTransfer().setEnabled(false);
			getRefund().setEnabled(false);
			getWriteOff().setEnabled(false);
		}
	}

	@Override
	protected void loadRelatedTable() {
		super.loadRelatedTable();
		showSlip();
		enableButton();
	}

	@Override
	protected void performListNoRecordPostMsg(MessageQueue mQueue) {
	}

	@Override
	protected void performList(final boolean showMessage) {
		// clean up other tables
		getSlpListTable().removeAllRow();
		getPayListTable().removeAllRow();

		super.performList(showMessage);
	}

	@Override
	protected void actionValidationPostReady(String actionType) {
		searchAction(false);
		super.actionValidationPostReady(actionType);
	}

	/***************************************************************************
	 * Helper Methods
	 **************************************************************************/

	private void showSlip() {
		// show slip detail
		getSlpListTable().setListTableContent(getTxCode(),
				new String[] {
					"slip",
					getPatNo().getText().trim(),
					null,
					getFirstName().getText().trim(),
					getGivenName().getText().trim(),
					null
				});
		showPaymentDetail();
		enableButton();
	}

	private void showPaymentDetail() {
		getPayListTable().removeAllRow();

		if (getListTable().getRowCount() > 0 && getListSelectedRow()[1].length() > 0) {
			getPayListTable().setListTableContent(getTxCode(),
					new String[] {
						"pay",
						null,
						null,
						null,
						null,
						getListSelectedRow()[1]
					});
		}
	}

	private void showPatInfo(String patNo) {
		if (patNo != null && patNo.length() > 0) {
			QueryUtil.executeMasterFetch(getUserInfo(), "PATIENTBYNO", new String[] { patNo },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						getFirstName().setText(mQueue.getContentField()[0]);
						getGivenName().setText(mQueue.getContentField()[1]);
					} else {
						getPatNo().resetText();
						getFirstName().resetText();
						getGivenName().resetText();
						getPatNo().focus();
						Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_PATIENT_NO, getPatNo());
					}
				}
			});
		}
	}

	private void transfer() {
		memActionType = "TRANSFER";
		memAvailDeposit_Slpno = getListSelectedRow()[1];
		memAvailDeposit_ItmCode = getListSelectedRow()[2];
		memAvailDeposit_Amount = null;
		memAvailDeposit_dpsid = getListSelectedRow()[6];
		memAvailSlip_Slpno = getSlpListTable().getSelectedRowContent()[1];
		try {
			MessageBox mb = MessageBoxBase.confirm(MSG_PBA_SYSTEM, ConstantsMessage.MSG_DEPOSIT_TRANSFER + " " + memAvailSlip_Slpno,
					new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						actionHelper(ConstantsMessage.MSG_DEPOSIT_TRANSFER_SUCCESS);
					}
				}
			});

			mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
		} catch (Exception e) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_DEPOSIT_TRANSFER_FAIL);
		}
	}

	private void writeOff() {
		memActionType = "WRITEOFF";
		memAvailDeposit_Slpno = getListSelectedRow()[1];
		memAvailDeposit_ItmCode = null;
		memAvailDeposit_Amount = null;
		memAvailDeposit_dpsid = getListSelectedRow()[6];
		memAvailSlip_Slpno = null;
		try {
			MessageBox mb = MessageBoxBase.confirm(MSG_PBA_SYSTEM, ConstantsMessage.MSG_DEPOSIT_WRITEOFF,
					new Listener<MessageBoxEvent>() {
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						actionHelper(ConstantsMessage.MSG_DEPOSIT_WRITEOFF_SUCCESS);
					}
				}
			});

			mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
		} catch (Exception e) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_DEPOSIT_WRITEOFF_FAIL);
		}
	}

	private void refund() {
		memActionType = "REFUND";
		memAvailDeposit_Slpno = getListSelectedRow()[1];
		memAvailDeposit_ItmCode = null;
		memAvailDeposit_Amount = getListSelectedRow()[4];
		memAvailDeposit_dpsid = getListSelectedRow()[6];
		memAvailSlip_Slpno = null;
		try {
			MessageBox mb = MessageBoxBase.confirm(MSG_PBA_SYSTEM, ConstantsMessage.MSG_DEPOSIT_REFUND,
					new Listener<MessageBoxEvent>() {
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						// reset value
						resetCardInfo();

						setActionType(QueryUtil.ACTION_APPEND);
						actionValidation(QueryUtil.ACTION_APPEND);
					}
				}
			});

			mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
		} catch (Exception e) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_DEPOSIT_REFUND_FAIL);
		}
	}

	private void actionHelper(final String successMessage) {
		QueryUtil.executeMasterAction(getUserInfo(),
				getTxCode(),
				QueryUtil.ACTION_APPEND,
				getActionInputParamaters(),
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					Factory.getInstance().addInformationMessage(successMessage);
					searchAction(false);
				} else {
					Factory.getInstance().addErrorMessage(mQueue);
				}
			}}
		);
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	@Override
	protected BasePanel getActionPanel() {
		if (actionPanel == null) {
			actionPanel = new BasePanel();
			actionPanel.setSize(735, 580);
			actionPanel.add(getListPanel(), null);
		}
		return actionPanel;
	}

	private BasePanel getListPanel() {
		if (listPanel == null) {
			listPanel = new BasePanel();
			listPanel.setEtchedBorder();
			listPanel.setBounds(5, 5, 715, 510);
			listPanel.add(getPatNoDesc(), null);
			listPanel.add(getPatNo(), null);
			listPanel.add(getFirstNameDesc(), null);
			listPanel.add(getFirstName(), null);
			listPanel.add(getGivenNameDesc(), null);
			listPanel.add(getGivenName(), null);
			listPanel.add(getDepositStsDesc(), null);
			listPanel.add(getDespositDesc(), null);
			listPanel.add(getDepositSts(), null);
			listPanel.add(getDepositScrollPane());
			listPanel.add(getSlpDesc(), null);
			listPanel.add(getSlpScrollPane());
			listPanel.add(getTransfer(), null);
//			listPanel.add(getTransferAmount(), null);
			listPanel.add(getRefundMethodDesc(), null);
			listPanel.add(getRefundMethod(), null);
			listPanel.add(getRefund(), null);
			listPanel.add(getWriteOff(), null);
			listPanel.add(getPaymentDesc(), null);
			listPanel.add(getPayScrollPane());
		}
		return listPanel;
	}

	/**
	 * This method initializes jScrollPane
	 *
	 * @return JScrollPane
	 */
	private JScrollPane getDepositScrollPane() {
		if (depositScrollPane == null) {
			depositScrollPane = new JScrollPane();
			depositScrollPane.setViewportView(getListTable());
			depositScrollPane.setBounds(5, 90, 430, 200);
		}
		return depositScrollPane;
	}

	private int[] getSlpColumnWidths() {
		return new int[] {
				10,
				100,
				120,
				0
				};
	}

	private String[] getSlpColumnNames() {
		return new String[] {
			"",
			"Slip No.",
			"Patient Type",
			"Status"

		};
	}

	private BufferedTableList getSlpListTable() {
		if (slpListTable == null) {
			slpListTable = new BufferedTableList(getSlpColumnNames(), getSlpColumnWidths()) {
				@Override
				public void setListTableContent(String txCode, String[] param) {
					getMainFrame().setLoading(true);
					super.setListTableContent(txCode, param);
				}

				@Override
				public void setListTableContentPost() {
					// refresh button status
					enableButton();

					getMainFrame().setLoading(false);

//					if (getListTable().getRowCount() <= 0 && getSlpListTable().getRowCount() <= 0) {
//						Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_NO_RECORD_FOUND);
//					}
				}
			};
			slpListTable.setTableLength(getListWidth());
		}
		return slpListTable;
	}

	private JScrollPane getSlpScrollPane() {
		if (slpScrollPane == null) {
			slpScrollPane = new JScrollPane();
			slpScrollPane.setViewportView(getSlpListTable());
			slpScrollPane.setBounds(455, 90, 250, 200);
		}
		return slpScrollPane;
	}

	private int[] getPayColumnWidths() {
		return new int[] {
			10,
			60,
			80,
			80,
			70,
			70,
			250,
			80,
			110,
			100,
			60,
			0, 0, 0, 0
		};
	}

	private String[] getPayColumnNames() {
		return new String[] {
			"",
			"Amount",
			"User",
			"Reference No",
			"Cap. Date",
			"Trans. Date",
			"Description",
			"Type",
			"Card#",
			"Holder",
			"Trace#",
			"", "", "", ""
		};
	}

	private BufferedTableList getPayListTable() {
		if (payListTable == null) {
			payListTable = new BufferedTableList(getPayColumnNames(), getPayColumnWidths()) {
				@Override
				public void setListTableContent(String txCode, String[] param) {
					getMainFrame().setLoading(true);
					super.setListTableContent(txCode, param);
				}

				@Override
				public void setListTableContentPost() {
					getMainFrame().setLoading(false);
				}
			};
			payListTable.setTableLength(getListWidth());
		}
		return payListTable;
	}

	private JScrollPane getPayScrollPane() {
		if (payScrollPane == null) {
			payScrollPane = new JScrollPane();
			payScrollPane.setViewportView(getPayListTable());
			payScrollPane.setBounds(5, 350, 700, 150);
		}
		return payScrollPane;
	}

	private LabelBase getPatNoDesc() {
		if (patNoDesc == null) {
			patNoDesc = new LabelBase();
			patNoDesc.setText("Patient No.");
			patNoDesc.setBounds(5, 5, 100, 20);
		}
		return patNoDesc;
	}

	private TextPatientNoSearch getPatNo() {
		if (patNo == null) {
			patNo = new TextPatientNoSearch(true, false) {
				@Override
				public void onReleased() {
					getFirstName().resetText();
					getGivenName().resetText();

					if (getListTable().getRowCount() > 0) {
						getListTable().removeAllRow();
					}
					if (getSlpListTable().getRowCount() > 0) {
						getSlpListTable().removeAllRow();
					}
					if (getPayListTable().getRowCount() > 0) {
						getPayListTable().removeAllRow();
					}
					enableButton();
				}

				@Override
				protected void checkPatient(boolean isExistPatient, boolean bySearchkey) {
					if (!isExistPatient) {
						getPatNo().resetText();
						getFirstName().resetText();
						getGivenName().resetText();
						Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_PATIENT_NO, getPatNo());
					} else {
						showPatInfo(getPatNo().getText().trim());
					}
				}

				@Override
				protected void showMergePatientPost() {
					Factory.getInstance().addErrorMessage(
							ConstantsMessage.MSG_PATIENT_NO, null,
							new Listener<MessageBoxEvent>() {
								@Override
								public void handleEvent(MessageBoxEvent be) {
									getPatNo().clear();
									getFirstName().resetText();
									getGivenName().resetText();
									getPatNo().focus();
								}
							});
				}

				@Override
				protected void actionAfterOK() {
					// for child class implement
					onBlur();
				}
			};
			patNo.setBounds(110, 5, 100, 20);
		}
		return patNo;
	}

	private LabelBase getFirstNameDesc() {
		if (firstNameDesc == null) {
			firstNameDesc = new LabelBase();
			firstNameDesc.setText("Family Name");
			firstNameDesc.setBounds(215, 5, 100, 20);
		}
		return firstNameDesc;
	}

	private TextString getFirstName() {
		if (firstName == null) {
			firstName = new TextString();
			firstName.setBounds(320, 5, 120, 20);
		}
		return firstName;
	}

	private LabelBase getGivenNameDesc() {
		if (givenNameDesc == null) {
			givenNameDesc = new LabelBase();
			givenNameDesc.setText("Given Name");
			givenNameDesc.setBounds(445, 5, 100, 20);
		}
		return givenNameDesc;
	}

	private TextString getGivenName() {
		if (givenName == null) {
			givenName = new TextString();
			givenName.setBounds(550, 5, 120, 20);
		}
		return givenName;
	}

	private LabelBase getDepositStsDesc() {
		if (depositStsDesc == null) {
			depositStsDesc = new LabelBase();
			depositStsDesc.setText("Deposit Status");
			depositStsDesc.setBounds(5, 30,100, 20);
		}
		return depositStsDesc;
	}

	private ComboDepositStatus getDepositSts() {
		if (depositSts == null) {
			depositSts = new ComboDepositStatus();
			depositSts.setBounds(110, 30,120, 20);
		}
		return depositSts;
	}

	private LabelBase getDespositDesc() {
		if (despositDesc == null) {
			despositDesc = new LabelBase();
			despositDesc.setText("Available Deposit");
			despositDesc.setBounds(5, 60,120, 20);
		}
		return despositDesc;
	}

	private LabelBase getSlpDesc() {
		if (slpDesc == null) {
			slpDesc = new LabelBase();
			slpDesc.setText("Available Slip");
			slpDesc.setBounds(455, 60,120, 20);
		}
		return slpDesc;
	}

	private ButtonBase getTransfer() {
		if (transfer == null) {
			transfer = new ButtonBase() {
				@Override
				public void onClick() {
					transfer();
				}
			};
			transfer.setText("Transfer", 'T');
			transfer.setBounds(5, 295, 90, 25);
		}
		return transfer;
	}

//	private TextAmount getTransferAmount() {
//		if (transferAmount == null) {
//			transferAmount = new TextAmount();
//			transferAmount.setBounds(105, 295, 100, 20);
//		}
//		return transferAmount;
//	}

	private LabelBase getRefundMethodDesc() {
		if (refundMethodDesc == null) {
			refundMethodDesc = new LabelBase();
			refundMethodDesc.setText("Refund Method");
			refundMethodDesc.setBounds(265, 295, 100, 20);
		}
		return refundMethodDesc;
	}

	private ComboRefundMethod getRefundMethod() {
		if (refundMethod == null) {
			refundMethod = new ComboRefundMethod();
			refundMethod.setBounds(355, 295, 120, 20);
		}
		return refundMethod;
	}

	private ButtonBase getRefund() {
		if (refund == null) {
			refund = new ButtonBase() {
				@Override
				public void onClick() {
					if (!getRefundMethod().isEmpty()) {
						refund();
					} else {
						Factory.getInstance().addErrorMessage("Refund method cannot be empty.","Alert", getRefundMethod());
					}
				}
			};
			refund.setText("Refund");
			refund.setBounds(480, 295, 80, 25);
		}
		return refund;
	}

	private ButtonBase getWriteOff() {
		if (writeOff == null) {
			writeOff = new ButtonBase() {
				@Override
				public void onClick() {
					writeOff();
				}
			};
			writeOff.setText("Write Off");
			writeOff.setBounds(615, 295, 90, 25);
		}
		return writeOff;
	}

	private LabelBase getPaymentDesc() {
		if (paymentDesc == null) {
			paymentDesc = new LabelBase();
			paymentDesc.setText("Payment Detail");
			paymentDesc.setBounds(5, 325, 120, 20);
		}
		return paymentDesc;
	}
}
