package com.hkah.client.tx.cashier;

import java.util.HashMap;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.BaseEvent;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.widget.form.RadioGroup;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboARCompany;
import com.hkah.client.layout.combobox.ComboCashRef;
import com.hkah.client.layout.combobox.ComboPayCode;
import com.hkah.client.layout.dialog.DlgReprintRpt;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.radiobutton.RadioButtonBase;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.ActionPaymentPanel;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class PaymentAndReceipt extends ActionPaymentPanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
//		return ConstantsTx.CASHPAYRCP_TXCODE;
		return "PaymentAndReceip";
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.CASHPAYRCP_TITLE;
	}

	// property declare start
	private BasePanel actionPanel = null;
	private FieldSetBase listPanel = null;
	private FieldSetBase typePanel = null;
	private BasePanel detailPanel = null;
	private BasePanel numPanel = null;
	private RadioButtonBase payout = null;
	private RadioButtonBase receipt = null;
	private RadioButtonBase advanceWithdraw = null;
	private LabelSmallBase ARDesc = null;
	private LabelSmallBase ARPrefix = null;
	private TextReadOnly AR = null;
	private LabelSmallBase NoOfCRDesc = null;
	private TextReadOnly NoOfCR = null;
	private LabelSmallBase NoOfReprintDesc = null;
	private TextReadOnly NoOfReprint = null;
	private LabelSmallBase NoOfVoidDesc = null;
	private TextReadOnly NoOfVoid = null;
	private LabelSmallBase payCodeDesc = null;
	private ComboPayCode payCode = null;
	private LabelSmallBase payDescriptDesc = null;
	private TextString payDescript = null;
	private LabelSmallBase ARCodeDesc = null;
	private ComboARCompany ARCode = null;
	private LabelSmallBase ARDescriptDesc = null;
	private TextReadOnly ARDescript = null;
	private LabelSmallBase payerReciptientDesc = null;
	private TextString payerReciptient = null;
	private LabelSmallBase referenceDesc = null;
	private BasePanel referencePanel = null;
	private RadioButtonBase referenceRa1 = null;
	private RadioButtonBase referenceRa2 = null;
	private ComboCashRef reference1 = null;
	private TextString reference2 = null;
	private LabelSmallBase amountDesc = null;
	private TextNum amount = null;
	private LabelSmallBase receiptNoDesc = null;
	private TextReadOnly receiptNo = null;

	private TableList statListTable = null;
	private JScrollPane statScrollPane = null;

	private String currLastID = null;
	private String currTranID = null;
	private String lang = null;

	private DlgReprintRpt reprintReceiptDialog = null;

	private MessageQueue preloadPayout = null;
	private MessageQueue preloadReceipt = null;

	private ButtonBase printBtn = null;
	private ButtonBase reprintBtn = null;
	/**
	 * This method initializes
	 *
	 */
	public PaymentAndReceipt() {
		super();
		setHideToolBar(true);
	}

	public boolean preAction() {
		if (!getUserInfo().isCashier()) {
			Factory.getInstance().addErrorMessage(
					ConstantsMessage.MSG_NOT_CASHIER, "PBA-[Patient Business Administration System]");
			return false;
		} else {
			return super.preAction();
		}
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setHideToolBar(false);
		return super.init();
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getStatListTable().setColumnAmount(2);
		getStatListTable().setColumnAmount(3);
		getStatListTable().setColumnAmount(4);

		QueryUtil.executeComboBox(
				getUserInfo(), ConstantsTx.PAY_CODE_TXCODE, new String[] { ONE_VALUE },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				preloadPayout = mQueue;
			}
		});

		QueryUtil.executeComboBox(
				getUserInfo(), ConstantsTx.PAY_CODE_TXCODE, new String[] { TWO_VALUE },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				preloadReceipt = mQueue;
			}
		});

		QueryUtil.executeMasterFetch(
				getUserInfo(), "PATIENTRPTLANG", new String[] { "", "" },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					lang = mQueue.getContentField()[0];
				}
			}
		});

		// reset all stored value
		defaultNewSetting();
		emptyFields();

		// reset all screen setting
		setActionType(null);
		cancelAction();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public ComboPayCode getDefaultFocusComponent() {
		return getPayCode();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
		defaultNewSetting();
		emptyFields();
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
	}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	@Override
	protected void deleteDisabledFields() {
		// enable/disable field
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		String[] selectedContent = getListSelectedRow();
		return new String[] { selectedContent[0] };
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {

	}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {
	}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {
				getUserInfo().getUserID(),
				getUserInfo().getCashierCode(),
				getPayout().isSelected() ? ONE_VALUE : (getReceipt().isSelected() ? TWO_VALUE : THREE_VALUE),
				getPayCode().getText(),
				getPayDescript().getText(),
				getARCode().getText(),
				getARDescript().getText(),
				getPayerReciptient().getText(),
				getReferenceRa1().isSelected() ? getReference1().getText() : getReference2().getText(),
				getAmount().getText(),
				// payee information
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
				memTxnAResp
				// credit card/octopus end
		};
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {
		// Factory.getInstance().addErrorMessage("Transaction Success");

		// retrieve from database
		if (getReceipt().isSelected() && returnValue != null) {
			currLastID = returnValue;
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] { "Cashtx", "CtxSNo", "Ctxid = '" + currLastID + "'" },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						currTranID = mQueue.getContentField()[0];
						getReceiptNo().setText(currTranID);
						// PrintReceiptNonPatient
						if (!"N".equals(Factory.getInstance().getSysParameter("PRTRNP"))) {
							printReceiptNonPatient("N");
						}
						getReprintBtn().setEnabled(true);
						getPrintBtn().setEnabled(true);
						//showReprintReceiptDialog(); //not show reprint dialog
					}
				}
			});
		} else if (getPayout().isSelected() && returnValue != null) {
			currLastID = returnValue;
			Factory.getInstance().addErrorMessage("Transaction Success");

		} else {
			Factory.getInstance().addErrorMessage("Transaction Success");
		}
	}

	private void printReceiptNonPatient(String isCopy) {
		HashMap<String, String> map = new HashMap<String, String>();
		map.put("ctxId", currLastID);
		map.put("isCopy",isCopy);
		map.put("watermark", CommonUtil.getReportImg("copy_watermark.gif"));

		String paperSize = Factory.getInstance().getSysParameter("RNoPatSize");
		String printerName = "";
		if (paperSize != null && paperSize.length() > 0) {
			printerName = "HATS_"+paperSize;
		}
		map.put("rptType", (getPayout().isSelected()?"P":"R"));
		Factory.getInstance().addRequiredReportDesc(map,
				   new String[] {
							"MapLanguage", "MapLanguage", "MapLanguage",
							"MapLanguage", "MapLanguage", "MapLanguage",
							"MapLanguage", "MapLanguage", "MapLanguage",
							"MapLanguage", "MapLanguage", "MapLanguage",
							"MapLanguage"
					},
				   new String[] {
							"receipt","receiptNo","Payer",
							"Copy","Date", "Desc",
							"Amount","HKD","PayOut",
							"recipientSign","recipient","staffSign",
							"witnessSign"
					},
					lang);
		PrintingUtil.print(printerName, "RptReceiptNonPatient",
				map,"",
				new String[] { currLastID },
				new String[] { "CTXSNO", "CTXMETH",
						"CTXNAME", "CTXAMT", "CTXDESC",
						"CTXTDATE",
						"TRACENO","PRINTDATE","CARDTYPE" }, 0, null, null, null, null, 1,
						Factory.getInstance().getSysParameter("RNoPatSize"));

	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	protected void actionValidation(final String actionType) {
		boolean returnValue = true;
		getSaveButton().setEnabled(false);

		if (getPayCode().isEditable() && getPayCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Method Code is empty!", getPayCode());
			returnValue = false;
		} else if (getPayCode().isEditable() && !getPayCode().isValid()) {
			Factory.getInstance().addErrorMessage("Method Code does not exist!", getPayCode());
			returnValue = false;
		} else if (getARCode().getText().trim().length() != 0 && !getARCode().isValid()) {
			Factory.getInstance().addErrorMessage("AR Code does not exist!", getARCode());
			returnValue = false;
		} else {
			double amount = 0;
			try {
				amount = Double.valueOf(getAmount().getText());
				if (getPayout().isSelected() && amount > 0) {
					Factory.getInstance().addErrorMessage("Payout amount must specify in negative value!", getAmount());
					returnValue = false;
				} else if (getReceipt().isSelected() && amount < 0) {
					Factory.getInstance().addErrorMessage("Receipt amount must specify in positive value!", getAmount());
					returnValue = false;
				}
			} catch (Exception e) {
				if (getPayout().isSelected()) {
					Factory.getInstance().addErrorMessage("Payout amount must specify in negative value!", getAmount());
				} else if (getReceipt().isSelected()) {
					Factory.getInstance().addErrorMessage("Receipt amount must specify in positive value!", getAmount());
				} else {
					Factory.getInstance().addErrorMessage("Amount Field Missing!", getAmount());
				}
				returnValue = false;
			}

			if (returnValue) {
				if (getPayerReciptient().isEditable() && getPayerReciptient().isEmpty()) {
					Factory.getInstance().addErrorMessage("Payer/Recipient Field Missing!", getPayerReciptient());
					returnValue = false;
				} else if (getReference1().isEditable() && getReference1().isEmpty()) {
					Factory.getInstance().addErrorMessage("Reference Field Missing!", getReference1());
					returnValue = false;
				} else if (getReference1().isEditable() && !getReference1().isValid()) {
					Factory.getInstance().addErrorMessage("Invalid Reference Field!", getReference1());
					returnValue = false;
				} else if (getReference2().isEditable() && getReference2().isEmpty()) {
					Factory.getInstance().addErrorMessage("Reference Field Missing!", getReference2());
					returnValue = false;
				}
			}
		}

		if (returnValue) {
			boolean hasPayCode = !getPayCode().isEmpty() && getPayCode().isValid();
			boolean hasARCode = !getARCode().isEmpty() && getPayCode().isValid();

			actionValidation(actionType, returnValue, "Transaction",
					getPayCode().getText(),
					(getPayout().isSelected() ? CASHTX_TXNTYPE_PAYOUT : (getReceipt().isSelected() ? CASHTX_TXNTYPE_RECEIVE : CASHTX_TXNTYPE_ADVANCEPAYIN)),
					getAmount().getText(), getAmount().getText(), null, null,
					hasPayCode && getPayCode().getRawTextArray().length > 2 ? getPayCode().getRawTextArray()[2] : EMPTY_VALUE,
					hasARCode && getARCode().getRawTextArray().length > 1 ? getARCode().getRawTextArray()[1] : EMPTY_VALUE,
					hasARCode && getARCode().getRawTextArray().length > 2 ? getARCode().getRawTextArray()[2] : EMPTY_VALUE,
					hasARCode && getARCode().getRawTextArray().length > 3 ? getARCode().getRawTextArray()[3] : EMPTY_VALUE,
					hasARCode && getARCode().getRawTextArray().length > 4 ? getARCode().getRawTextArray()[4] : EMPTY_VALUE,
					EMPTY_VALUE);
		} else {
			getSaveButton().setEnabled(true);
		}
	}

	/***************************************************************************
	 * Helper Methods
	 **************************************************************************/

	private void defaultNewSetting() {
		resetCardInfo();

		// set fields default
		getPayout().setSelected(true);
		setPaymentButton();

		getReferenceRa1().setSelected(true);
		setReferenceButton();
	}

	private void emptyFields() {
		getPayCode().resetText();
		getPayDescript().resetText();
		getARCode().resetText();
		getARDescript().resetText();
		getPayerReciptient().resetText();
		getReference1().resetText();
		getReference2().resetText();
		getAmount().resetText();
		getReceiptNo().resetText();
	}

	protected void showBalance() {
		QueryUtil.executeMasterBrowse(getUserInfo(),
				ConstantsTx.CASHSTAT_TXCODE,
				new String[] { getUserInfo().getCashierCode() },
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							getStatListTable().setListTableContent(mQueue);
							getAR().setText(TextUtil.formatCurrency(mQueue.getContentField()[5]));
							getNoOfCR().setText(mQueue.getContentField()[6]);
							getNoOfReprint().setText(mQueue.getContentField()[7]);
							getNoOfVoid().setText(mQueue.getContentField()[8]);
						}
					}
				});
	}

	/***************************************************************************
	 * Override Methods
	 **************************************************************************/

	@Override
	protected void enableButton(String mode) {
		super.enableButton(mode);
		if(isAppend()){
			getPrintBtn().setEnabled(false);
			getReprintBtn().setEnabled(false);
		}
		// disable search function
		getSearchButton().setEnabled(false);
		getClearButton().setEnabled(true);


		// enable table
		getStatScrollPane().setEnabled(true);

		// handle button
		setPaymentButton();
		setReferenceButton();

		// refresh balance
		showBalance();
	}

	@Override
	public void clearAction() {
		super.clearAction();
		emptyFields();
	}

	@Override
	protected void savePostAction() {
		if (getPayout().isSelected()) {
			getPrintBtn().setEnabled(true);
		}
	}

	private void setPaymentButton() {
		getReferenceRa1().setSelected(true);
		getReferenceRa2().setSelected(false);
		if (isAppend()) {
			getPayCode().setEditable(!getAdvanceWithdraw().isSelected());
			getPayDescript().setEditable(true);
			getARCode().setEditable(!getAdvanceWithdraw().isSelected());
			getPayerReciptient().setEditable(!getAdvanceWithdraw().isSelected());
			getReferenceRa1().setEnabled(!getAdvanceWithdraw().isSelected());
			getReferenceRa2().setEnabled(!getAdvanceWithdraw().isSelected());
			getReference1().setEditable(getReferenceRa1().isSelected() && !getAdvanceWithdraw().isSelected());
			getReference2().setEditable(getReferenceRa2().isSelected() && !getAdvanceWithdraw().isSelected());
			getAmount().setEditable(true);

			getPayCode().removeAllItems();
			if (getPayout().isSelected() || getReceipt().isSelected()) {
				if (preloadPayout != null && getPayout().isSelected()) {
					getPayCode().resetContent(preloadPayout);
				} else if (preloadReceipt != null && getReceipt().isSelected()) {
					getPayCode().resetContent(preloadReceipt);
				}
			}

			emptyFields();
		}
	}

	private void setReferenceButton() {
		if (isAppend()) {
			if (getReferenceRa1().isSelected()) {
				getReference1().setEditable(true);
				getReference2().setEditable(false);
			} else if (getReferenceRa2().isSelected()) {
				getReference1().setEditable(false);
				getReference2().setEditable(true);
			}
		} else {
			getReference1().setEditable(false);
			getReference2().setEditable(false);
		}
		layout();
	}

	@Override
	protected void actionValidationReady(final String actionType, boolean isValidationReady) {
		// set action type
//		setActionType(actionType);

		if (isValidationReady) {
			// set loading flag true
			getMainFrame().setLoading(true);
			QueryUtil.executeMasterAction(getUserInfo(), getTxCode(), getActionType(), getActionInputParamaters(),
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						actionValidationReadyHelper(actionType, mQueue);

						// reset action type
						resetActionType();

						// call post ready
						actionValidationPostReady(actionType);
					} else {
						Factory.getInstance().addErrorMessage(mQueue);
						if (mQueue.getContentField().length >= 2) {
							String msg = mQueue.getContentField()[1];
							if (msg != null && msg.trim().length() > 0) {
								Factory.getInstance().addSystemMessage(msg);
							}
						}
						getSaveButton().setEnabled(true);
					}
				}

				@Override
				public void onComplete() {
					super.onComplete();

					// set loading flag false
					getMainFrame().setLoading(false);
				}
			});
		} else {
			getSaveButton().setEnabled(true);
		}
	}

	/***************************************************************************
	 * Dialog Method
	 **************************************************************************/

	protected void showReprintReceiptDialog() {
		if (reprintReceiptDialog == null) {
			reprintReceiptDialog = new DlgReprintRpt(getMainFrame(), "Cash Receipt") {
				@Override
				public void reprint() {
					printReceiptNonPatient("Y");
					dispose();
				}
			};
			reprintReceiptDialog.setResizable(false);
		}
		reprintReceiptDialog.showDialog();
	}

	/***************************************************************************
	 * Layout Methods
	 **************************************************************************/

	@Override
	protected BasePanel getActionPanel() {
		if (actionPanel == null) {
			actionPanel = new BasePanel();
			actionPanel.setSize(779, 520);
			actionPanel.add(getTypePanel(), null);
			actionPanel.add(getDetailPanel(), null);
			actionPanel.add(getListPanel(), null);
			actionPanel.add(getPrintBtn(), null);
			actionPanel.add(getReprintBtn(), null);

		}
		return actionPanel;
	}

	public FieldSetBase getTypePanel() {
		if (typePanel == null) {
			typePanel = new FieldSetBase();
			typePanel.setBounds(5, 5, 360, 90);
			typePanel.setHeading("Type");
			typePanel.add(getPayout(), null);
			typePanel.add(getReceipt(), null);
			typePanel.add(getAdvanceWithdraw(), null);
			// set radio button group
			RadioGroup btg = new RadioGroup();
			btg.add(getPayout());
			btg.add(getReceipt());
			btg.add(getAdvanceWithdraw());
		}
		return typePanel;
	}

	public BasePanel getDetailPanel() {
		if (detailPanel == null) {
			detailPanel = new BasePanel();
			detailPanel.setBounds(5, 100, 360, 300);
			detailPanel.setEtchedBorder();
			detailPanel.add(getPayCodeDesc(), null);
			detailPanel.add(getPayCode(), null);
			detailPanel.add(getPayDescriptDesc(), null);
			detailPanel.add(getPayDescript(), null);
			detailPanel.add(getARCodeDesc(), null);
			detailPanel.add(getARCode(), null);
			detailPanel.add(getARDescriptDesc(), null);
			detailPanel.add(getARDescript(), null);
			detailPanel.add(getPayerReciptientDesc(), null);
			detailPanel.add(getPayerReciptient(), null);
			detailPanel.add(getReferenceDesc(), null);
			detailPanel.add(getReferencePanel(), null);
			detailPanel.add(getAmountDesc(), null);
			detailPanel.add(getAmount(), null);
			detailPanel.add(getReceiptNoDesc(), null);
			detailPanel.add(getReceiptNo(), null);
		}
		return detailPanel;
	}

	public FieldSetBase getListPanel() {
		if (listPanel == null) {
			listPanel = new FieldSetBase();
			listPanel.setHeading("Cashier Statistic");
			listPanel.setBounds(370, 5, 398, 395);
			listPanel.add(getStatScrollPane());
			listPanel.add(getNumPanel(), null);
			listPanel.add(getARDesc(), null);
			listPanel.add(getARPrefix(), null);
			listPanel.add(getAR(), null);
		}
		return listPanel;
	}

	private LabelSmallBase getARDesc() {
		if (ARDesc == null) {
			ARDesc = new LabelSmallBase();
			ARDesc.setBounds(110, 260, 50, 20);
			ARDesc.setText("AR");
		}
		return ARDesc;
	}

	private LabelSmallBase getARPrefix() {
		if (ARPrefix == null) {
			ARPrefix = new LabelSmallBase();
			ARPrefix.setBounds(180, 260, 50, 20);
			ARPrefix.setText("$");
		}
		return ARPrefix;
	}

	private TextReadOnly getAR() {
		if (AR == null) {
			AR = new TextReadOnly();
			AR.setBounds(190, 260, 80, 20);
		}
		return AR;
	}

	public BasePanel getNumPanel() {
		if (numPanel == null) {
			numPanel = new BasePanel();
			numPanel.setBounds(59, 285, 220, 80);
			numPanel.setEtchedBorder();
			numPanel.add(getNoOfCRDesc(), null);
			numPanel.add(getNoOfCR(), null);
			numPanel.add(getNoOfReprintDesc(), null);
			numPanel.add(getNoOfReprint(), null);
			numPanel.add(getNoOfVoidDesc(), null);
			numPanel.add(getNoOfVoid(), null);
		}
		return numPanel;
	}

	private RadioButtonBase getPayout() {
		if (payout == null) {
			payout = new RadioButtonBase() {
				@Override
				public void onClick() {
					setPaymentButton();
				}
			};
			payout.setText("Payout(-ve)");
			payout.setBounds(30, 0, 200, 20);
		}
		return payout;
	}

	private RadioButtonBase getReceipt() {
		if (receipt == null) {
			receipt = new RadioButtonBase() {
				@Override
				public void onClick() {
					setPaymentButton();
				}
			};
			receipt.setText("Receipt(+ve)");
			receipt.setBounds(30, 20, 200, 20);
		}
		return receipt;
	}

	private RadioButtonBase getAdvanceWithdraw() {
		if (advanceWithdraw == null) {
			advanceWithdraw = new RadioButtonBase() {
				@Override
				public void onClick() {
					setPaymentButton();
				}
			};
			advanceWithdraw.setText("Advance(+ve) & Withdraw(-ve)");
			advanceWithdraw.setBounds(30, 40, 250, 20);
		}
		return advanceWithdraw;
	}

	private LabelSmallBase getNoOfCRDesc() {
		if (NoOfCRDesc == null) {
			NoOfCRDesc = new LabelSmallBase();
			NoOfCRDesc.setText("No. of CR issued");
			NoOfCRDesc.setBounds(5, 5, 120, 20);
		}
		return NoOfCRDesc;
	}

	private TextReadOnly getNoOfCR() {
		if (NoOfCR == null) {
			NoOfCR = new TextReadOnly();
			NoOfCR.setBounds(130, 5, 80, 20);
		}
		return NoOfCR;
	}

	private LabelSmallBase getNoOfReprintDesc() {
		if (NoOfReprintDesc == null) {
			NoOfReprintDesc = new LabelSmallBase();
			NoOfReprintDesc.setText("No. of Reprint");
			NoOfReprintDesc.setBounds(5, 30, 120, 20);
		}
		return NoOfReprintDesc;
	}

	private TextReadOnly getNoOfReprint() {
		if (NoOfReprint == null) {
			NoOfReprint = new TextReadOnly();
			NoOfReprint.setBounds(130, 30, 80, 20);
		}
		return NoOfReprint;
	}

	private LabelSmallBase getNoOfVoidDesc() {
		if (NoOfVoidDesc == null) {
			NoOfVoidDesc = new LabelSmallBase();
			NoOfVoidDesc.setText("No. of Void");
			NoOfVoidDesc.setBounds(5, 55, 120, 20);
		}
		return NoOfVoidDesc;
	}

	private TextReadOnly getNoOfVoid() {
		if (NoOfVoid == null) {
			NoOfVoid = new TextReadOnly();
			NoOfVoid.setBounds(130, 55, 80, 20);
		}
		return NoOfVoid;
	}

	private LabelSmallBase getPayCodeDesc() {
		if (payCodeDesc == null) {
			payCodeDesc = new LabelSmallBase();
			payCodeDesc.setText("Method Code");
			payCodeDesc.setBounds(5, 5, 120, 20);
		}
		return payCodeDesc;
	}

	@SuppressWarnings("unchecked")
	private ComboPayCode getPayCode() {
		if (payCode == null) {
			payCode = new ComboPayCode() {
				@Override
				protected void setTextPanel(ModelData modelData) {
					if (modelData != null) {
						getPayDescript().setText((modelData.get(ONE_VALUE)).toString());
						if (CASHTX_PAYTYPE_OTHER.equals((modelData.get(TWO_VALUE)).toString())) {
							getPayerReciptient().setText(getPayDescript().getText());
						}
					}
				}

				@Override
				protected void onTwinTriggerClick(ComponentEvent ce) {
					super.onTwinTriggerClick(ce);
					if (isShowClearButton() && isEnabled() && isEditable()) {
						getPayDescript().resetText();
					}
				}
			};

			payCode.setBounds(130, 5, 210, 20);
		}
		return payCode;
	}

	private LabelSmallBase getPayDescriptDesc() {
		if (payDescriptDesc == null) {
			payDescriptDesc = new LabelSmallBase();
			payDescriptDesc.setText("Pay Descript.");
			payDescriptDesc.setBounds(5, 35, 120, 20);
		}
		return payDescriptDesc;
	}

	private TextString getPayDescript() {
		if (payDescript == null) {
			payDescript = new TextString(50, false);
			payDescript.setBounds(130, 35, 210, 20);
		}
		return payDescript;
	}

	private LabelSmallBase getARCodeDesc() {
		if (ARCodeDesc == null) {
			ARCodeDesc = new LabelSmallBase();
			ARCodeDesc.setText("AR Code");
			ARCodeDesc.setBounds(5, 65, 120, 20);
		}
		return ARCodeDesc;
	}

	@SuppressWarnings("unchecked")
	private ComboARCompany getARCode() {
		if (ARCode == null) {
			ARCode = new ComboARCompany(getARDescript(), true) {
				@Override
				public void onSelected() {
					getPayerReciptient().setText(getARDescript().getText());
				}

				@Override
				protected String getTxFrom() {
					return "cshMain";
				}

				@Override
				protected void onTwinTriggerClick(ComponentEvent ce) {
					super.onTwinTriggerClick(ce);
					if (isShowClearButton() && isEnabled() && isEditable()) {
						getPayerReciptient().resetText();
						getARDescript().resetText();
					}
				}

				@Override
				public void onUpdate() {
					if (!getARCode().isEmpty() && getARDescript().getText().isEmpty()) {
						getLoader().load();
					}
				}
			};

			ARCode.addListener(Events.OnKeyPress, new Listener() {
				@Override
				public void handleEvent(BaseEvent be) {
					getPayerReciptient().resetText();
					getARDescript().resetText();

					if (!getARCode().isEmpty()) {
						String oldValue = getARCode().getText().trim();
						getARCode().clearSelections();
						getARCode().setRawValue(oldValue);
					}
				}
			});

			ARCode.setBounds(130, 65, 178, 20);
		}
		return ARCode;
	}

	private LabelSmallBase getARDescriptDesc() {
		if (ARDescriptDesc == null) {
			ARDescriptDesc = new LabelSmallBase();
			ARDescriptDesc.setText("AR Descript");
			ARDescriptDesc.setBounds(5, 95, 120, 20);
		}
		return ARDescriptDesc;
	}

	private TextReadOnly getARDescript() {
		if (ARDescript == null) {
			ARDescript = new TextReadOnly();
			ARDescript.setBounds(130, 95, 210, 20);
		}
		return ARDescript;
	}

	private LabelSmallBase getPayerReciptientDesc() {
		if (payerReciptientDesc == null) {
			payerReciptientDesc = new LabelSmallBase();
			payerReciptientDesc.setText("Payer/Recipient");
			payerReciptientDesc.setBounds(5, 125, 120, 20);
		}
		return payerReciptientDesc;
	}

	private TextString getPayerReciptient() {
		if (payerReciptient == null) {
			payerReciptient = new TextString(50, false);
			payerReciptient.setBounds(130, 125, 210, 20);
		}
		return payerReciptient;
	}

	private LabelSmallBase getReferenceDesc() {
		if (referenceDesc == null) {
			referenceDesc = new LabelSmallBase();
			referenceDesc.setText("Description");
			referenceDesc.setBounds(5, 155, 120, 20);
		}
		return referenceDesc;
	}

	private BasePanel getReferencePanel() {
		if (referencePanel == null) {
			referencePanel = new BasePanel();
			referencePanel.setBounds(130, 155, 210, 70);
			referencePanel.add(getReferenceRa1(), null);
			referencePanel.add(getReference1(), null);
			referencePanel.add(getReferenceRa2(), null);
			referencePanel.add(getReference2(), null);
			referencePanel.setEtchedBorder();
			RadioGroup btg = new RadioGroup();
			btg.add(getReferenceRa1());
			btg.add(getReferenceRa2());
		}
		return referencePanel;
	}

	private RadioButtonBase getReferenceRa1() {
		if (referenceRa1 == null) {
			referenceRa1 = new RadioButtonBase() {
				@Override
				public void onClick() {
					setReferenceButton();
				}
			};

			referenceRa1.setBounds(5, 5, 30, 20);
		}
		return referenceRa1;
	}

	private ComboCashRef getReference1() {
		if (reference1 == null) {
			reference1 = new ComboCashRef(false);
			reference1.setBounds(40, 5, 150, 20);
		}
		return reference1;
	}

	private RadioButtonBase getReferenceRa2() {
		if (referenceRa2 == null) {
			referenceRa2 = new RadioButtonBase() {
				@Override
				public void onClick() {
					setReferenceButton();
				}
			};
			referenceRa2.setBounds(5, 35, 30, 20);
		}
		return referenceRa2;
	}

	private TextString getReference2() {
		if (reference2 == null) {
			reference2 = new TextString(50);
			reference2.setBounds(40, 35, 150, 20);
		}
		return reference2;
	}

	private LabelSmallBase getAmountDesc() {
		if (amountDesc == null) {
			amountDesc = new LabelSmallBase();
			amountDesc.setText("Amount");
			amountDesc.setBounds(5, 240, 120, 20);
		}
		return amountDesc;
	}

	private TextNum getAmount() {
		if (amount == null) {
			amount = new TextNum(8, 2, false, true);
			amount.setBounds(130, 240, 210, 20);
		}
		return amount;
	}

	private LabelSmallBase getReceiptNoDesc() {
		if (receiptNoDesc == null) {
			receiptNoDesc = new LabelSmallBase();
			receiptNoDesc.setText("Receipt No.");
			receiptNoDesc.setBounds(5, 270, 120, 20);
		}
		return receiptNoDesc;
	}

	private TextReadOnly getReceiptNo() {
		if (receiptNo == null) {
			receiptNo = new TextReadOnly();
			receiptNo.setBounds(130, 270, 210, 20);
		}
		return receiptNo;
	}

	public ButtonBase getPrintBtn() {
		if (printBtn == null) {
			printBtn = new ButtonBase() {
				@Override
				public void onClick() {
					printReceiptNonPatient("N");
					getReprintBtn().setEnabled(true);
				}
			};
			printBtn.setText("Print");
			printBtn.setBounds(5, 410,100, 30);
		}
		return printBtn;
	}

	public ButtonBase getReprintBtn() {
		if (reprintBtn == null) {
			reprintBtn = new ButtonBase() {
				@Override
				public void onClick() {
					printReceiptNonPatient("Y");
				}
			};
			reprintBtn.setText("Reprint");
			reprintBtn.setBounds(120, 410,100, 30);
		}
		return reprintBtn;
	}

	private TableList getStatListTable() {
		if (statListTable == null) {
			statListTable = new TableList(getStatColumnNames(), getStatColumnWidths());
		}
		return statListTable;
	}

	private JScrollPane getStatScrollPane() {
		if (statScrollPane == null) {
			statScrollPane = new JScrollPane();
			statScrollPane.setBounds(5, 0, 385, 255);
			statScrollPane.setViewportView(getStatListTable());
		}
		return statScrollPane;
	}

	private String[] getStatColumnNames() {
		return new String[] { "", "Type", "Receipt", "Payout", "Net", "", "", "", "" };
	}

	private int[] getStatColumnWidths() {
		return new int[] { 0, 150, 75, 75, 75, 0, 0, 0, 0 };
	}
}