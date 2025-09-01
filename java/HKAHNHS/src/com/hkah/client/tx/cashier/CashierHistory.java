package com.hkah.client.tx.cashier;

import java.util.HashMap;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboCashRef;
import com.hkah.client.layout.combobox.ComboCashierHistorySortBy;
import com.hkah.client.layout.combobox.ComboPayType;
import com.hkah.client.layout.combobox.ComboPaymentStatus;
import com.hkah.client.layout.combobox.ComboPaymentType;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.SearchPaymentPanel;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class CashierHistory extends SearchPaymentPanel {
	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.CASHIERHISTORY_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return "Cashier History";
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"",
			"Type",
			"Date",
			"Payer/Recipient",
			"Amount",
			"Slip No.",
			"Description",
			"Reciept Number",
			"Status",
			"Cashier",
			"Method",
			"CtxCat",
			"CtxType",
			"IsChequeDiff",
			"TDateDiff",
			"payCode",
			"Card Type"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				0,
				60,
				70,
				180,
				70,
				80,
				120,
				100,
				50,
				50,
				100,
				0,
				0,
				0,
				0,
				0,
				100
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	// property declare start
	private BasePanel searchPanel = null;
	private BasePanel paraPanel = null;
	private JScrollPane historyScrollPanel = null;
	private BasePanel ListPanel = null;
	private LabelSmallBase payTypeDesc = null;
	private ComboPaymentType payType = null;
	private LabelSmallBase receiptDesc = null;
	private TextString receipt = null;
	private LabelSmallBase receiptNoDesc = null;
	private TextString receiptNo = null;
	private LabelSmallBase startDateDesc = null;
	private TextDate startDate = null;
	private LabelSmallBase endDateDesc = null;
	private TextDate endDate = null;
	private LabelSmallBase statusDesc = null;
	private ComboPaymentStatus status = null;
	private LabelSmallBase referenceDesc = null;
	private LabelSmallBase cashierCodeDesc = null;
	private TextString cashierCode = null;
	private LabelSmallBase paymentMethodDesc = null;
	private ComboPayType paymentMethod = null;
	private ComboCashRef Reference = null;
	private LabelSmallBase amountDesc = null;
	private TextNum amountFrom = null;
	private LabelSmallBase amountToDesc = null;
	private TextNum amountTo = null;
	private LabelSmallBase cardTypeDesc = null;
	private TextString cardType = null;
	private LabelSmallBase sortByDesc = null;
	private ComboCashierHistorySortBy sortBy = null;
	private ButtonBase voidAction = null;
	private ButtonBase rePrintAction = null;
	private String lang = null;

	/**
	 * This method initializes
	 *
	 */
	public CashierHistory() {
		super();
	}

	public boolean preAction() {
		if (!getUserInfo().isCashier()) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_NOT_CASHIER, "PBA-[Patient Business Administration System]");
			disableButton();
			return false;
		} else {
			return super.preAction();
		}
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getStartDate().setText(getMainFrame().getServerDate());
		getEndDate().setText(DateTimeUtil.getRollDate(getMainFrame().getServerDate(), 1));

		getListTable().setColumnAmount(4);

		getVoidAction().setEnabled(false);
		getRePrintAction().setEnabled(false);
		
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
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		return getPayType();
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		if (getPayType().getRawValue().isEmpty() &&
				getReceipt().isEmpty() &&
				getReceiptNo().isEmpty() &&
				getStartDate().isEmpty() &&
				getEndDate().isEmpty() &&
				getStatus().isEmpty() &&
				getReference().isEmpty()) {
			Factory.getInstance().addErrorMessage(MSG_INPUT_CRITERIA);
			return false;
		} else if (getStartDate().isEmpty() && getReceiptNo().isEmpty()) {
			//Factory.getInstance().addErrorMessage(MSG_DATE_REQUIRED, getStartDate());
			//return false;
		} else if (getEndDate().isEmpty() && getReceiptNo().isEmpty()) {
			//Factory.getInstance().addErrorMessage("The end date must be entered.", getEndDate());
			//return false;
		}

		return true;
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getPayType().getText(),
				getReceipt().getText(),
				getReceiptNo().getText(),
				getStartDate().getText(),
				getEndDate().getText(),
				getStatus().getText(),
				getReference().getText(),
				getCashierCode().getText(),
				getPaymentMethod().getText(),
				getCardType().getText(),
				getAmountFrom().getText(),
				getAmountTo().getText(),
				getSortBy().getText()
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
		doCashierHist_OnDataChanged();
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	private void doCashierHist_OnDataChanged() {
		if (getListSelectedRow() == null || (getListSelectedRow()[0]).length() == 0) {	// ctxid
			getRePrintAction().setEnabled(false);
			getVoidAction().setEnabled(false);
			return;
		}

		if (getListSelectedRow()[5].length() == 0		// slipno
				&& !"Void".equals(getListSelectedRow()[8])) {	// ctxsts
			getRePrintAction().setEnabled(true);
		} else {
			getRePrintAction().setEnabled(false);
		}

		// isChequeTransactionWithBuffer
		if (YES_VALUE.equals(getListSelectedRow()[13])) {
			getVoidAction().setEnabled(true);
		} else {
			if (YES_VALUE.equals(getListSelectedRow()[14])) {
				getVoidAction().setEnabled(true);
			} else {
				getVoidAction().setEnabled(false);
			}
		}
	}

	private void printReportAboutVoid() {
		if (getListSelectedRow()[12].equals("P")) {
			HashMap<String, String> map = new HashMap<String, String>();
			map.put("ctxId", getListSelectedRow()[0]);
			PrintingUtil.print("RptPayoutVoidSht", map, "",
					new String[] { getListSelectedRow()[0] }, new String[] {
							"CTXSNO", "CTXNAME", "CTXAMT", "CTXDESC" });
		} else if (getListSelectedRow()[12].equals("R")) {
			HashMap<String, String> map = new HashMap<String, String>();
			map.put("ctxId", getListSelectedRow()[0]);
			PrintingUtil.print("RptPettyCashVoidSht", map,"",
					new String[] { getListSelectedRow()[0] }, new String[] {
							"CTXSNO", "CTXNAME", "PAYDESC", "PAYCDESC",
							"CTXAMT", "CTXDESC" });
		}
	}

	private void voidAction() {
		QueryUtil.executeMasterAction(getUserInfo(), "CASHIERVALIDVOID", QueryUtil.ACTION_APPEND,
				new String[] {
								getListSelectedRow()[0],
								getUserInfo().getCashierCode(),
								getListSelectedRow()[15]
				}, new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					MessageBoxBase.confirm("PBA-[Cashier History]", "Are you sure you want to void this transaction?",
							new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								doCashierVoidEntry(getUserInfo(), getListSelectedRow()[0], EMPTY_VALUE, EMPTY_VALUE);
							}
						}
					});
				} else {
					Factory.getInstance().addErrorMessage(mQueue.getReturnMsg(), "PBA-[Cashier History]");
				}
			}
		});
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	/**
	 * override performListPost method
	 */
	@Override
	protected void performListPost() {
		doCashierHist_OnDataChanged();
	}

	@Override
	protected void enableButton(String mode) {
		disableButton();
		getSearchButton().setEnabled(true);
		getRefreshButton().setEnabled(true);
		getClearButton().setEnabled(true);
	}

	@Override
	public void doCashierVoidEntryReady(boolean ready) {
		if (ready) {
			if (!"N".equals(Factory.getInstance().getSysParameter("PRTVOIDS"))) {
				printReportAboutVoid();
			}
			searchAction(false);
		} else {
			Factory.getInstance().addErrorMessage(MSG_VOID_FAILED, "PBA-[Transaction Detail]");
		}
	}

	/*>>> override clearAction ======== <<<<*/
	@Override
	public void clearAction() {
		if (getClearButton().isEnabled()) {
			getPayType().clear();
			getReceipt().clear();
			getReceiptNo().clear();
			getStartDate().clear();
			getEndDate().clear();
			getReference().clear();
			getStartDate().clear();

			// copy from MasterPanelBase:
			// clear record found
			setRecordFound(false);

			enableButton();

			// call after all action done
			clearPostAction();

			// call focus component
			defaultFocus();
		}
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	@Override
	protected BasePanel getSearchPanel() {
		if (searchPanel == null) {
			searchPanel = new BasePanel();
			searchPanel.setSize(779, 528);
			searchPanel.add(getParaPanel());
			searchPanel.add(getListPanel());
			searchPanel.add(getVoidAction());
			searchPanel.add(getRePrintAction());
		}
		return searchPanel;
	}

	public BasePanel getParaPanel() {
		if (paraPanel == null) {
			paraPanel = new BasePanel();
			paraPanel.setBorders(true);
			paraPanel.setBounds(10, 10, 757, 110);
			paraPanel.add(getPayTypeDesc(), null);
			paraPanel.add(getPayType(), null);
			paraPanel.add(getReceiptDesc(), null);
			paraPanel.add(getReceipt(), null);
			paraPanel.add(getReceiptNoDesc(), null);
			paraPanel.add(getReceiptNo(), null);
			paraPanel.add(getStartDateDesc(), null);
			paraPanel.add(getStartDate(), null);
			paraPanel.add(getEndDateDesc(), null);
			paraPanel.add(getEndDate(), null);
			paraPanel.add(getStatusDesc(), null);
			paraPanel.add(getStatus(), null);
			paraPanel.add(getReferenceDesc(), null);
			paraPanel.add(getReference(), null);
			paraPanel.add(getCashierCodeDesc(), null);
			paraPanel.add(getCashierCode(), null);
			paraPanel.add(getPaymentMethodDesc(), null);
			paraPanel.add(getPaymentMethod(), null);
			paraPanel.add(getCardTypeDesc(), null);
			paraPanel.add(getCardType(), null);
			paraPanel.add(getAmountDesc(), null);
			paraPanel.add(getAmountFrom(), null);
			paraPanel.add(getAmountToDesc(), null);
			paraPanel.add(getAmountTo(), null);
			paraPanel.add(getSortByDesc(), null);
			paraPanel.add(getSortBy(), null);
		}
		return paraPanel;
	}

	/**
	 * This method initializes jScrollPane
	 *
	 * @return JScrollPane
	 */
	protected JScrollPane getHistoryScrollPanel() {
		if (historyScrollPanel == null) {
			getJScrollPane().removeViewportView(getListTable());
			historyScrollPanel = new JScrollPane();
			historyScrollPanel.setViewportView(getListTable());
			historyScrollPanel.setBounds(5, 5, 745, 335);
		}
		return historyScrollPanel;
	}

	public BasePanel getListPanel() {
		if (ListPanel == null) {
			ListPanel = new BasePanel();
			ListPanel.setEtchedBorder();
			ListPanel.setBounds(10, 130, 757, 348);
			ListPanel.add(getHistoryScrollPanel());
		}
		return ListPanel;
	}

	public LabelSmallBase getPayTypeDesc() {
		if (payTypeDesc == null) {
			payTypeDesc = new LabelSmallBase();
			payTypeDesc.setText("Payment Type");
			payTypeDesc.setBounds(5, 5, 100, 20);
		}
		return payTypeDesc;
	}

	public ComboPaymentType getPayType() {
		if (payType == null) {
			payType = new ComboPaymentType();
			payType.setBounds(110, 5, 120, 20);
		}
		return payType;
	}

	public LabelSmallBase getReceiptDesc() {
		if (receiptDesc == null) {
			receiptDesc = new LabelSmallBase();
			receiptDesc.setText("Payer/Receipt");
			receiptDesc.setBounds(255, 5, 130, 20);
		}
		return receiptDesc;
	}

	public TextString getReceipt() {
		if (receipt == null) {
			receipt = new TextString(false);
			receipt.setBounds(370, 5, 120, 20);
		}
		return receipt;
	}

	public LabelSmallBase getReceiptNoDesc() {
		if (receiptNoDesc == null) {
			receiptNoDesc = new LabelSmallBase();
			receiptNoDesc.setText("Receipt Number");
			receiptNoDesc.setBounds(515, 5, 130, 20);
		}
		return receiptNoDesc;
	}

	public TextString getReceiptNo() {
		if (receiptNo == null) {
			receiptNo = new TextString();
			receiptNo.setBounds(630, 5, 120, 20);
		}
		return receiptNo;
	}

	public LabelSmallBase getStartDateDesc() {
		if (startDateDesc == null) {
			startDateDesc = new LabelSmallBase();
			startDateDesc.setText("Start Date");
			startDateDesc.setBounds(5, 30, 100, 20);
		}
		return startDateDesc;
	}

	public TextDate getStartDate() {
		if (startDate == null) {
			startDate = new TextDate() {
				@Override
				public void onBlur() {
					super.onBlur();
					if (!isEmpty() && !isValid()) {
						clear();
					}
				};
			};
			startDate.setBounds(110, 30, 120, 20);
			startDate.setText(getMainFrame().getServerDate());
		}
		return startDate;
	}

	public LabelSmallBase getEndDateDesc() {
		if (endDateDesc == null) {
			endDateDesc = new LabelSmallBase();
			endDateDesc.setText("End Date");
			endDateDesc.setBounds(255, 30, 130, 20);
		}
		return endDateDesc;
	}

	public TextDate getEndDate() {
		if (endDate == null) {
			endDate = new TextDate() {
				@Override
				public void onBlur() {
					super.onBlur();
					if (!isEmpty() && !isValid()) {
						clear();
					}
				};
			};
			endDate.setBounds(370, 30, 120, 20);
			endDate.setText(DateTimeUtil.getRollDate(getMainFrame().getServerDate()));
		}
		return endDate;
	}

	public LabelSmallBase getStatusDesc() {
		if (statusDesc == null) {
			statusDesc = new LabelSmallBase();
			statusDesc.setText("Status");
			statusDesc.setBounds(515, 30, 130, 20);
		}
		return statusDesc;
	}

	public ComboPaymentStatus getStatus() {
		if (status == null) {
			status = new ComboPaymentStatus();
			status.setBounds(630, 30, 120, 20);
		}
		return status;
	}

	public LabelSmallBase getReferenceDesc() {
		if (referenceDesc == null) {
			referenceDesc = new LabelSmallBase();
			referenceDesc.setText("Description");
			referenceDesc.setBounds(5, 55, 100, 20);
		}
		return referenceDesc;
	}

	public ComboCashRef getReference() {
		if (Reference == null) {
			Reference = new ComboCashRef(false);
			Reference.setBounds(110, 55, 120, 20);
		}
		return Reference;
	}

	public LabelSmallBase getCashierCodeDesc() {
		if (cashierCodeDesc == null) {
			cashierCodeDesc = new LabelSmallBase();
			cashierCodeDesc.setText("Cashier Code");
			cashierCodeDesc.setBounds(255, 55, 130, 20);
		}
		return cashierCodeDesc;
	}

	public TextString getCashierCode() {
		if (cashierCode == null) {
			cashierCode = new TextString();
			cashierCode.setBounds(370, 55, 120, 20);
		}
		return cashierCode;
	}

	public LabelSmallBase getPaymentMethodDesc() {
		if (paymentMethodDesc == null) {
			paymentMethodDesc = new LabelSmallBase();
			paymentMethodDesc.setText("Payment Method");
			paymentMethodDesc.setBounds(515, 55, 130, 20);
		}
		return paymentMethodDesc;
	}

	public ComboPayType getPaymentMethod() {
		if (paymentMethod == null) {
			paymentMethod = new ComboPayType();
			paymentMethod.setBounds(630, 55, 120, 20);
			paymentMethod.removeItemAt(9);
		}
		return paymentMethod;
	}
	
	/**
	 * @return the cardTyeDesc
	 */
	private LabelSmallBase getCardTypeDesc() {
		if (cardTypeDesc == null) {
			cardTypeDesc = new LabelSmallBase();
			cardTypeDesc.setText("Card Type");
			cardTypeDesc.setBounds(5, 80, 100, 20);
		}
		return cardTypeDesc;
	}

	/**
	 * @return the cardType
	 */
	private TextString getCardType() {
		if (cardType == null) {
			cardType = new TextString();
			cardType.setBounds(110, 80, 120, 20);
		}
		return cardType;
	}
	
	/**
	 * @return the amountDesc
	 */
	private LabelSmallBase getAmountDesc() {
		if (amountDesc == null) {
			amountDesc = new LabelSmallBase();
			amountDesc.setText("Amount");
			amountDesc.setBounds(255, 80, 130, 20);
		}
		return amountDesc;
	}

	/**
	 * @return the amountFrom
	 */
	private TextNum getAmountFrom() {
		if (amountFrom == null) {
			amountFrom = new TextNum(9, 2, false, true);
			amountFrom.setBounds(370, 80, 60, 20);
		}
		return amountFrom;
	}

	/**
	 * @return the amountToDesc
	 */
	private LabelSmallBase getAmountToDesc() {
		if (amountToDesc == null) {
			amountToDesc = new LabelSmallBase();
			amountToDesc.setText("-");
			amountToDesc.setBounds(435, 80, 5, 20);
		}
		return amountToDesc;
	}

	/**
	 * @return the amountTo
	 */
	private TextNum getAmountTo() {
		if (amountTo == null) {
			amountTo = new TextNum(9, 2, false, true);
			amountTo.setBounds(445, 80, 60, 20);
		}
		return amountTo;
	}

	/**
	 * @return the sortByDesc
	 */
	private LabelSmallBase getSortByDesc() {
		if (sortByDesc == null) {
			sortByDesc = new LabelSmallBase();
			sortByDesc.setText("Sort By");
			sortByDesc.setBounds(515, 80, 130, 20);
		}
		return sortByDesc;
	}

	/**
	 * @return the sortBy
	 */
	private ComboCashierHistorySortBy getSortBy() {
		if (sortBy == null) {
			sortBy = new ComboCashierHistorySortBy();
			sortBy.setBounds(630, 80, 120, 20);
		}
		return sortBy;
	}

	public ButtonBase getVoidAction() {
		if (voidAction == null) {
			voidAction = new ButtonBase() {
				@Override
				public void onClick() {
					if (getListTable().getSelectedRow() >= 0) {
						voidAction();
					}
				}
			};
			voidAction.setText("Void", 'V');
			voidAction.setBounds(30, 485, 100, 25);
		}
		return voidAction;
	}

	public ButtonBase getRePrintAction() {
		if (rePrintAction == null) {
			rePrintAction = new ButtonBase() {
				@Override
				public void onClick() {

					HashMap<String, String> map = new HashMap<String, String>();
					map.put("ctxId", getListSelectedRow()[0]);
					map.put("isCopy", "Y");

					String paperSize = Factory.getInstance().getSysParameter("RNoPatSize");
					String printerName = "";
					if (paperSize != null && paperSize.length() > 0) {
						printerName = "HATS_"+paperSize;
					}
					
					map.put("rptType", (("Receipt".equals(getListSelectedRow()[1]))?"R":"P"));
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
					
					PrintingUtil.print(printerName,"RptReceiptNonPatient",
							map,"",
							new String[] {getListSelectedRow()[0] },
							new String[] { "CTXSNO", "CTXMETH",
									"CTXNAME", "CTXAMT", "CTXDESC",
									"CTXTDATE",
									"TRACENO","printDate","CARDTYPE"  }, 0, null, null, null, null, 1,
									Factory.getInstance().getSysParameter("RNoPatSize"));

					QueryUtil.executeMasterAction(getUserInfo(), "UpdateBalance", QueryUtil.ACTION_MODIFY,
						new String[] { getUserInfo().getCashierCode(), EMPTY_VALUE, EMPTY_VALUE, ZERO_VALUE, CASHIER_COUNT_REPRINT });
				}
			};
			rePrintAction.setText("Reprint", 'R');
			rePrintAction.setBounds(140, 485, 110, 25);
		}
		return rePrintAction;
	}
}