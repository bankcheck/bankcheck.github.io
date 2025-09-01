package com.hkah.client.tx.transaction;

import java.math.BigDecimal;

import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.GridEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.form.Field;
import com.extjs.gxt.ui.client.widget.layout.AbsoluteLayout;
import com.extjs.gxt.ui.client.widget.layout.FlowLayout;
import com.google.gwt.i18n.client.NumberFormat;
import com.google.gwt.user.client.Element;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.EditorTableList;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextAmount;
import com.hkah.client.tx.ActionPaymentPanel;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsSlipPaymentAllocation;
import com.hkah.shared.constants.ConstantsTransaction;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class SlipPaymentAllocation extends ActionPaymentPanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.SLIPPAYMENTALLOCATION_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.SLIPPAYMENTALLOCATION_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"",
			"Pkg Code",
			"Item",
			"Description",
			"Doctor",
			"Amount",
			"StnID",
			"Capture Date"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				10,
				80,
				80,
				300,
				80,
				80,
				0,
				0
		};
	}

	private BasePanel actionPanel = null;

	private LabelBase AmountDesc = null;
	private TextAmount Amount = null;
	private ButtonBase Allocate = null;

	private FieldSetBase drChgPanelWrapper = null;
	private BasePanel DrChgPanel = null;
	private TableList DrChgTable = null;
	private JScrollPane DrChgSP = null;

	private FieldSetBase paymentPanelWrapper = null;
	private BasePanel PaymentPanel = null;
	private TableList PaymentTable = null;
	private JScrollPane PaymentSP = null;

	private FieldSetBase allocatedChgPayPanelWrapper = null;
	private BasePanel AllocatedChgPayPanel = null;
	private EditorTableList AllocatedChgPayTable=null;

	private JScrollPane AllocatedChgPaySP = null;
	private String memSlpType = "";
	private String memSlpNo = "";
	private boolean memArLocked = false;

	/**
	 *
	 * This method initializes
	 *
	 */
	public SlipPaymentAllocation() {
		super();
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		memArLocked = false;
		memSlpType = getParameter("SlpType");
		memSlpNo = getParameter("SlpNo");

		getDrChgTable().setColumnAmount(5);
		getPaymentTable().setColumnAmount(5);
		getAllocatedChgPayTable().setColumnAmount(6);

		disableButton();

		QueryUtil.executeMasterAction(getUserInfo(), "SlpPayAllLockAR", QueryUtil.ACTION_APPEND,
				new String[] { memSlpNo, CommonUtil.getComputerName(), getUserInfo().getUserID() },
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				lockRecordReady(null, null, null, mQueue.success(), mQueue.getReturnMsg());
			}
		});

		searchAction();
	}

	@Override
	protected void lockRecordReady(final String lockType, final String lockKey, String[] record, boolean lock, String returnMessage) {
		if (lock) {
			memArLocked = true;
		} else {
			memArLocked = false;
			Factory.getInstance().addErrorMessage(MSG_ARCODE_LOCK + "<br>Please try again!");
		}
		updateAmt();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextAmount getDefaultFocusComponent() {
		return getAmount();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		refreshAction();
	}

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
		return null;
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		return null;
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {

	}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {};
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {}

	@Override
	protected void performListPost() {}

	@Override
	protected void performListNoRecordPostMsg(MessageQueue mQueue) {}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void proExitPanel() {
		QueryUtil.executeMasterAction(getUserInfo(), "SlpPayAllUnLockAR", QueryUtil.ACTION_APPEND,
				new String[] { memSlpNo, CommonUtil.getComputerName(), getUserInfo().getUserID() });
	}

	@Override
	public void searchAction() {
		super.searchAction();
		setActionType(null);
		// focus on search panel

		String[] inParam = new String[] { memSlpNo };
		getDrChgTable().setListTableContent(getTxCode(), inParam);
		getPaymentTable().setListTableContent("TXNSLIPPAYALL_PAY", inParam);
		getAllocatedChgPayTable().setListTableContent("TXNSLIPPAYALL_ALL", inParam);
	}

	@Override
	public void saveAction() {
		if (getSaveButton().isEnabled()) {
			if (getAllocatedChgPayTable().getRowCount() > 0) {
				getAllocatedChgPayTable().saveTable(
						"TXNSLIPPAYALL_PAY1",
						new String[] { EMPTY_VALUE },
						"SLPPAYDTLLIST",
						false,
						false,
						false,
						true,
						"TXNSLIPPAYALL_PAY1"
					);
			}
		}
	}

	@Override
	public void deleteAction() {
		if (getDeleteButton().isEnabled()) {
			// let action type set before call performGet()
			setActionType(QueryUtil.ACTION_DELETE);
			enableButton(QueryUtil.ACTION_DELETE);

			MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Cancel the allocated payment?", new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						String[] selectedContent = getAllocatedChgPayTable().getSelectedRowContent();
						String []inPara = new String[] {
						selectedContent[8],
						"",
						"1",
						getUserInfo().getUserID()
				};
				QueryUtil.executeMasterAction(getUserInfo(), "SLPPAYALLREVERSE2", QueryUtil.ACTION_APPEND, inPara,
						new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								deletePostAction();
							}

							@Override
							public void onFailure(Throwable caught) {
								Factory.getInstance().addErrorMessage("Fail to delete allocated payment");
							}
						});
					}
				}
			});
		}
	}

	@Override
	public void deletePostAction() {
		initAfterReady();
	}

	@Override
	protected void cancelPostAction() {
		super.cancelPostAction();
		initAfterReady();
	}

	@Override
	protected void enableButton(String mode) {
		disableButton();
		getDeleteButton().setEnabled(isDeleteButtonEnable());
	}
	
	private boolean isDeleteButtonEnable() {
		// only not paid to doctor persisted slppaydtl can be deleted, and not in allocating mode
		boolean isEnable = false;
		if (!isAppend() && getAllocatedChgPayTable().getRowCount() > 0) {
			String[] row = getAllocatedChgPayTable().getSelectedRowContent();
			if (row != null) {		
				//spdid	// 8	//sphid	// 19
				if (row[8] != null && !row[8].isEmpty() && (row[19] == null || row[19].isEmpty())) {
					isEnable = true;
				}
			}
		}
		return isEnable;
	}

	/***************************************************************************
	 * Doctor Charge Method
	 **************************************************************************/

	private JScrollPane getDrChgSP() {
		if (DrChgSP == null) {
			DrChgSP = new JScrollPane();
			DrChgSP.setViewportView(getDrChgTable());
			DrChgSP.setBounds(10, 25, 725, 100);
		}
		return DrChgSP;
	}

	private TableList getDrChgTable() {
		if (DrChgTable == null) {
			DrChgTable = new TableList(getColumnNames(), getColumnWidths()) {
				@Override
				public void setListTableContentPost() {
					updateAmt();
				}

				@Override
				public void onSelectionChanged() {
					updateAmt();
				};
			};
			DrChgTable.setTableLength(getListWidth());
			DrChgTable.addListener(Events.RowClick, new Listener<GridEvent>() {
				@Override
				public void handleEvent(GridEvent be) {
					updateAmt();
				}
			});
		}
		return DrChgTable;
	}

	/***************************************************************************
	 * Payment Table Method
	 **************************************************************************/

	private JScrollPane getPaymentSP() {
		if (PaymentSP == null) {
			PaymentSP = new JScrollPane();
			PaymentSP.setViewportView(getPaymentTable());
			PaymentSP.setBounds(10, 25, 725, 110);
		}
		return PaymentSP;
	}

	private TableList getPaymentTable() {
		if (PaymentTable == null) {
			PaymentTable = new TableList(getPaymentTableColumnNames(), getPaymentTableColumnWidths()) {
				@Override
				public void setListTableContentPost() {
					updateAmt();
				}

				@Override
				public void onSelectionChanged() {
					updateAmt();
				};
			};
			PaymentTable.setTableLength(getListWidth());
			PaymentTable.addListener(Events.RowClick, new Listener<GridEvent>() {
				@Override
				public void handleEvent(GridEvent be) {
					updateAmt();
				}
			});
			//PatStatusTable.setColumnClass(0, ComboPackage.class, true);
			//PatStatusTable.setColumnClass(1, String.class, true);
		}
		return PaymentTable;
	}

	protected String[] getPaymentTableColumnNames() {
		return new String[] {
				"KEY",
				"Payment Type",
				"Item",
				"Description",
				"AR Code",
				"Amount",
				"Receive Date",
				"PAYREF",
				"STNXREF"
			};
	}

	protected int[] getPaymentTableColumnWidths() {
		return new int[] {
				0,
				120,
				80,
				200,
				80,
				80,
				120,
				0,
				0
			};
	}

	/***************************************************************************
	 * Allocated Charge and Payment Table Method
	 **************************************************************************/

	private JScrollPane getAllocatedChgPaySP() {
		if (AllocatedChgPaySP == null) {
			AllocatedChgPaySP = new JScrollPane();
			AllocatedChgPaySP.setViewportView(getAllocatedChgPayTable());
			AllocatedChgPaySP.setBounds(10, 25, 725, 130);
		}
		return AllocatedChgPaySP;
	}

	private EditorTableList getAllocatedChgPayTable() {
		if (AllocatedChgPayTable == null) {
			AllocatedChgPayTable = new EditorTableList(
					getAllocatedChgPayTableColumnNames(),
					getAllocatedChgPayTableColumnWidths(),
					getAllocatedChgPayTableColumnFields(),
					false, null, null, false) {
				@Override
				public void setListTableContentPost() {
					enableButton(getActionType());
				}

				@Override
				public void postSaveTable(boolean success, Integer rtnCode, String rtnMsg) {
					if (success) {
						String[] para = new String[] {"slip", "slpmanall = -1", "slpno ='" + memSlpNo + "'"};
						QueryUtil.executeMasterAction(getUserInfo(), "UPDATE", QueryUtil.ACTION_MODIFY, para,
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								// TODO Auto-generated method stub
								initAfterReady();
							}
						});
					}
				}
				
				@Override
				public void onSelectionChanged() {
					getDeleteButton().setEnabled(isDeleteButtonEnable());
				}
			};
			AllocatedChgPayTable.setTableLength(getListWidth());
		}
		return AllocatedChgPayTable;
	}

	protected String[] getAllocatedChgPayTableColumnNames() {
		return new String[] {
				"",
				"Item",
				"Dr. Code",
				"Charge Description",
				"AR Code",
				"Payment Description",
				"Allocated Amt",
				"Capture Date",
				"SpdID",
				"StnID",
				"slpno",
				"stntype",
				"slptype",
				"spdsts",
				"payref",
				"ctnctype",
				"crarate",
				"spdcamt",
				"spdpamt",
				"sphid"};
	}

	protected Field[] getAllocatedChgPayTableColumnFields() {
		return new Field[] { null, null, null, null, null, null, null, null, null,
				 null, null, null, null, null, null, null, null, null, null, null};
	}

 	protected int[] getAllocatedChgPayTableColumnWidths() {
		return new int[] { 0, 50, 50, 190, 80, 190, 80, 70,
				0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0};
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void doAll(final String[] para) {
		QueryUtil.executeMasterAction(getUserInfo(), "TXNSlIPPAYALL_PAY", QueryUtil.ACTION_APPEND, para,
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					// doAllSuccess();
				} else {
					Factory.getInstance().addErrorMessage("Add pay alloc failed.", "Error");
				}
			}
		});
	}

	protected void updateAmt() {
		String[] row_drchg = null;
		String chgAmt = null;
		String[] row_payment = getPaymentTable().getSelectedRowContent();
		String payAmt = null;

		if (getDrChgTable().getSelectedRow() >= 0) {
			row_drchg = getDrChgTable().getSelectedRowContent();
			chgAmt = row_drchg[5];
			if (chgAmt != null && chgAmt.indexOf("-") == 0) {
				chgAmt.replace("-", "");
			}
		}

		if (getPaymentTable().getSelectedRow() >= 0) {
			row_payment = getPaymentTable().getSelectedRowContent();
			payAmt = row_payment[5];
		}

		BigDecimal zeroBD = new BigDecimal("0");
		BigDecimal amtBD = new BigDecimal("0");
		if (chgAmt != null && payAmt != null) {
			BigDecimal chgAmtIntBD = new BigDecimal("0");
			BigDecimal payAmtIntBD = new BigDecimal("0");
			
			try {
				chgAmtIntBD = new BigDecimal(chgAmt);
				
				payAmtIntBD = (new BigDecimal(payAmt)).abs();
			} catch (Exception e) {}
			if (chgAmtIntBD.compareTo(payAmtIntBD) > 0) {
				amtBD = payAmtIntBD;
			} else {
				amtBD = chgAmtIntBD;
			}
		}

		if (getPaymentTable().getSelectedRow() >= 0 && amtBD.compareTo(zeroBD) != 0) {
			getAmount().setText(amtBD.toPlainString());
			getAllocate().setEnabled(memArLocked);
		} else {
			getAmount().setText(ZERO_VALUE);
			getAllocate().setEnabled(false);
		}
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	@Override
	protected BasePanel getActionPanel() {
		if (actionPanel == null) {
			actionPanel = new BasePanel();
			actionPanel.setSize(779, 494);
			actionPanel.add(getDrChgPanelWrapper(), null);
			actionPanel.add(getPaymentPanelWrapper(), null);
			actionPanel.add(getAllocatedChgPayPanelWrapper(), null);
			actionPanel.add(getAmount(), null);
			actionPanel.add(getAllocate(), null);
			actionPanel.add(getAmountDesc(), null);
		}
		return actionPanel;
	}

	public FieldSetBase getDrChgPanelWrapper() {
		if (drChgPanelWrapper == null) {
			drChgPanelWrapper = new FieldSetBase();
			drChgPanelWrapper.setLayout(new AbsoluteLayout());
			drChgPanelWrapper.setHeading("Doctor Charges in Slip");
			drChgPanelWrapper.setBounds(8, 10, 757, 135);
			drChgPanelWrapper.add(getDrChgPanel());
		}
		return drChgPanelWrapper;
	}

	public BasePanel getDrChgPanel() {
		if (DrChgPanel == null) {
			DrChgPanel = new BasePanel() {
				@Override
				protected void onRender(Element parent, int index) {
					super.onRender(parent, index);
					setLayout(new FlowLayout());
				}
			};
			DrChgPanel.add(getDrChgSP(), null);;
			DrChgPanel.setBounds(8, 0, 757, 135);
		}
		return DrChgPanel;
	}

	public FieldSetBase getPaymentPanelWrapper() {
		if (paymentPanelWrapper == null) {
			paymentPanelWrapper = new FieldSetBase();
			paymentPanelWrapper.setLayout(new AbsoluteLayout());
			paymentPanelWrapper.setHeading("Payment (Cash or AR Allocated Payment)");
			paymentPanelWrapper.setBounds(8, 146, 757, 145);
			paymentPanelWrapper.add(getPaymentPanel());
		}
		return paymentPanelWrapper;
	}

	public BasePanel getPaymentPanel() {
		if (PaymentPanel == null) {
			PaymentPanel = new BasePanel() {
				@Override
				protected void onRender(Element parent, int index) {
					super.onRender(parent, index);
					setLayout(new FlowLayout());
				}
			};
			PaymentPanel.add(getPaymentSP(), null);
			PaymentPanel.setBounds(8, 0, 757, 145);
		}
		return PaymentPanel;
	}

	public FieldSetBase getAllocatedChgPayPanelWrapper() {
		if (allocatedChgPayPanelWrapper == null) {
			allocatedChgPayPanelWrapper = new FieldSetBase();
			allocatedChgPayPanelWrapper.setLayout(new AbsoluteLayout());
			allocatedChgPayPanelWrapper.setHeading("Allocated Charges and Payment");
			allocatedChgPayPanelWrapper.setBounds(8, 317, 757, 169);
			allocatedChgPayPanelWrapper.add(getAllocatedChgPayPanel());
		}
		return allocatedChgPayPanelWrapper;
	}

	public BasePanel getAllocatedChgPayPanel() {
		if (AllocatedChgPayPanel == null) {
			AllocatedChgPayPanel = new BasePanel() {
				@Override
				protected void onRender(Element parent, int index) {
					super.onRender(parent, index);
					setLayout(new FlowLayout());
				}
			};
			AllocatedChgPayPanel.add(getAllocatedChgPaySP(), null);
			AllocatedChgPayPanel.setBounds(8, 0, 757, 169);

		}
		return AllocatedChgPayPanel;
	}

	public LabelBase getAmountDesc() {
		if (AmountDesc == null) {
			AmountDesc = new LabelBase();
			AmountDesc.setText("Amount");
			AmountDesc.setBounds(11, 295, 68, 20);
		}
		return AmountDesc;
	}

	public TextAmount getAmount() {
		if (Amount == null) {
			Amount = new TextAmount(ConstantsTransaction.MAX_AMOUNT_LIMIT - 2, 2, true);
			Amount.setBounds(78, 295, 119, 20);
		 }
		return Amount;
	}

	public ButtonBase getAllocate() {
		if (Allocate == null) {
			Allocate = new ButtonBase() {
				@Override
				public void onClick() {
					String amount = getAmount().getText();
					if (amount == null || amount.trim().length() == 0) {
						amount = ZERO_VALUE;
					}
					if (getPaymentTable().getRowCount() <= 0) {
						getAllocate().setEnabled(false);
						return;
					}

					final String[] row1 = getDrChgTable().getSelectedRowContent();
					final String[] row2 = getPaymentTable().getSelectedRowContent();

					BigDecimal zeroBD = new BigDecimal("0");
					BigDecimal amountBD = null;
					try {
						amountBD = new BigDecimal(amount);
					} catch (NumberFormatException nfex) {
						amountBD = new BigDecimal("0");
					}
					BigDecimal stnnamtPayDB = null;
					try {
						stnnamtPayDB = new BigDecimal(row2[5]);
					} catch (NumberFormatException nfex) {
						stnnamtPayDB = new BigDecimal("0");
					}
					BigDecimal stnnamtChgDB = null;
					try {
						stnnamtChgDB = new BigDecimal(row1[5]);
					} catch (NumberFormatException nfex) {
						stnnamtChgDB = new BigDecimal("0");
					}
					
					BigDecimal payAmtBD = amountBD.add(stnnamtPayDB);
					BigDecimal chgAmtBD = stnnamtChgDB.subtract(amountBD);

					if (chgAmtBD.compareTo(zeroBD) < 0) {
						Factory.getInstance().addErrorMessage(ConstantsSlipPaymentAllocation.MSG_SPA_ALLOCATED_AMOUNT_EXCESS_CHG, "PBA - [Slip Payment Allocation]");
						return;
					} else if (payAmtBD.compareTo(zeroBD) > 0) {
						Factory.getInstance().addErrorMessage(ConstantsSlipPaymentAllocation.MSG_SPA_ALLOCATED_AMOUNT_EXCESS_PAY, "PBA - [Slip Payment Allocation]");
						return;
					}

					getAllocatedChgPayTable().addRow(new String[] {
							null,
							row1[2],
							row1[4],
							row1[3],
							row2[4],
							row2[3],
							amount,
							getMainFrame().getServerDate(),
							null, //SPDID
							row1[6], //STNID
							memSlpNo,	//SLPNO
							row2[1],	//STNTYPE
							memSlpType,	//SLPTYPE
							ConstantsSlipPaymentAllocation.SLIP_PAYMENT_USER_ALLOCATE,	//SPDSTS
							row2[7],	//PAYREF
							null,	//CTNCTYPE
							null,	//CRARATE
							NumberFormat.getDecimalFormat().format(chgAmtBD),	//SPDCAMT
							NumberFormat.getDecimalFormat().format(payAmtBD),	//SPDPAMT
							null //SPHID
					});
					final int addRowNum = getAllocatedChgPayTable().getRowCount() - 1;

					if (ConstantsTransaction.SLIPTX_TYPE_PAYMENT_C.equals(row2[1])) {
						getMainFrame().setLoading(true);
						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
								new String[] {"cashtx ctx, cardtx ctn, cardrate cr",
									"craname, crarate",
									"ctxid = " + row2[8] +
									" and ctx.ctnid = ctn.ctnid " +
									" and (" +
									"  (ctx.ctxmeth <> '"  + CASHTX_PAYTYPE_EPS + "'" +
									" and upper(rtrim(ctn.ctnctype)) = cr.craname) or" +
									"  (ctx.ctxmeth = '"  + CASHTX_PAYTYPE_EPS + "'" +
									" and cr.craname = 'EPS')" +
									" )"},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									if (mQueue.getContentField()[0] != null && mQueue.getContentField()[0].length() > 0) {
										getAllocatedChgPayTable().setValueAt(mQueue.getContentField()[0], addRowNum, 15);
									}
									if (mQueue.getContentField()[1] != null && mQueue.getContentField()[1].length() > 0) {
										getAllocatedChgPayTable().setValueAt(mQueue.getContentField()[1], addRowNum, 16);
									}
								}
							}

							@Override
							public void onComplete() {
								super.onComplete();
								Factory.getInstance().getMainFrame().setLoading(false);
							}
						});
					}

					if (ConstantsTransaction.SLIPTX_TYPE_PAYMENT_A.equals( row2[1])) {
						getMainFrame().setLoading(true);
						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
								new String[] {"artx ar, arptx arp, cashtx ctx, cardtx ctn, cardrate cr",
									"craname, crarate",
									"ar.atxid = "+row2[7]+" and ar.arpid = arp.arpid "+
									" and arp.arprecno = ctx.ctxsno and ctx.ctnid is not null and ctx.ctnid = ctn.ctnid and ("+
									"(ctx.ctxmeth <>'"+CASHTX_PAYTYPE_EPS+"' and upper(rtrim(ctn.ctnctype)) = cr.craname) or("+
									" ctx.ctxmeth ='"+CASHTX_PAYTYPE_EPS+"' and cr.craname = 'EPS')) "
									},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									if (mQueue.getContentField()[0] != null && mQueue.getContentField()[0].length() > 0) {
										getAllocatedChgPayTable().setValueAt(mQueue.getContentField()[0], addRowNum, 15);
									}
									if (mQueue.getContentField()[1] != null && mQueue.getContentField()[1].length() > 0) {
										getAllocatedChgPayTable().setValueAt(mQueue.getContentField()[1], addRowNum, 16);
									}
								}
							}

							@Override
							public void onComplete() {
								super.onComplete();
								Factory.getInstance().getMainFrame().setLoading(false);
							}
						});
					}

					if (ConstantsTransaction.SLIPTX_TYPE_DEPOSIT_I.equals( row2[1])) {
						getMainFrame().setLoading(true);
						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
								new String[] { "sliptx", "paymethod,cardrate", "stnid = "+row2[0].substring(1) },
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									if (mQueue.getContentField()[0] != null && mQueue.getContentField()[0].length() > 0) {
										getAllocatedChgPayTable().setValueAt(mQueue.getContentField()[0], addRowNum, 15);
									}
									if (mQueue.getContentField()[1] != null && mQueue.getContentField()[1].length() > 0 &&
											mQueue.getContentField()[0].length() > 0) {
										getAllocatedChgPayTable().setValueAt(mQueue.getContentField()[1], addRowNum, 16);
									}
								}
							}

							@Override
							public void onComplete() {
								super.onComplete();
								Factory.getInstance().getMainFrame().setLoading(false);
							}
						});
					}

					int paySelectRow = CommonUtil.getTableSelectRow(getPaymentTable());
					int rowcount = getPaymentTable().getRowCount();
					//row2[5] = String.valueOf(payAmtBD);
					row2[5] = payAmtBD.toPlainString();
					if (payAmtBD.compareTo(zeroBD) == 0) {
						getPaymentTable().removeRow(paySelectRow);
					} else {
						String[] pay = getPaymentTable().getSelectedRowContent();
						BigDecimal stnnamtBD = new BigDecimal(pay[5]);
						getPaymentTable().setValueAt(stnnamtBD.add(amountBD).toPlainString(), paySelectRow, 5);
					}

					int chrgselectRow = CommonUtil.getTableSelectRow(getDrChgTable());
					row1[5] = String.valueOf(chgAmtBD);
					if (chgAmtBD.compareTo(zeroBD) <= 0) {
						getDrChgTable().removeRow(chrgselectRow);
						if (chrgselectRow >= getDrChgTable().getRowCount()) {
							chrgselectRow -= 1;
						}
						getDrChgTable().setSelectRow(chrgselectRow);
						if (chrgselectRow != -1) {
//							getAmount().setText(getDrChgTable().getRowContent(chrgselectRow)[5]);
						}
					} else {
						getDrChgTable().setValueAt(String.valueOf(row1[5]), chrgselectRow, 5);
//						getAmount().setText(row1[5]);
					}
					updateAmt();

					if (paySelectRow != (rowcount - 1)) {
						getPaymentTable().setRowSelectionInterval(0, 0);
					}

					if (getAllocatedChgPayTable().getRowCount() > 0) {
						disableButton();
						getSaveButton().setEnabled(true);
						getCancelButton().setEnabled(true);
					} else {
						disableButton();
					}

					setActionType(QueryUtil.ACTION_APPEND);
				}
			};
			Allocate.setText("Allocate");
			Allocate.setBounds(207, 295, 88, 25);
		}
		return Allocate;
	}
}