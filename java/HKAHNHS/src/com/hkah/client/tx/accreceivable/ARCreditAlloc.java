package com.hkah.client.tx.accreceivable;

import com.extjs.gxt.ui.client.Style.Scroll;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.MessageBox;
import com.google.gwt.event.dom.client.KeyCodes;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboPatientType;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextReadOnlyAmount;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsAR;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class ARCreditAlloc extends MasterPanel implements ConstantsAR {
	private final static int SLIP_ALLOCATE_COLUMN = 7;
	private final static int COMPANY_ALLOCATE_COLUMN = 5;
	private String memAllowAmt = null;
	private String memAllocAmt = null;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.ARCREDITALLOC_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.ARCREDITALLOC_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				EMPTY_VALUE,EMPTY_VALUE,
				"Payment Amount",
				"Allocated Amount", EMPTY_VALUE,
				"Transaction Date",
				"Reciept No",
				"Status",
				"Description"};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
							10, 0, 110, 110, 0, 100, 100, 60, 220
					};
	}

	private BasePanel rightPanel = null;
	private BasePanel leftPanel = null;

	private FieldSetBase ParaPanel = null;

	private LabelBase PayerCodeDesc = null;
	private TextReadOnly PayerCode = null;
	private TextReadOnly PayerName = null;
	private LabelBase AllowAmtDesc = null;
	private TextReadOnlyAmount allowAmt = null;
	private TextNum CLAmountToAllocate = null;
	private TextReadOnly PatientNameDisplay = null;
	private LabelBase PayAmtDesc = null;
	private TextReadOnlyAmount payAmt = null;
	private LabelBase AllocAmtDesc = null;
	private TextReadOnlyAmount allocAmt = null;
	private LabelBase CLDescriptionDesc = null;
	private TextReadOnly CLDescription = null;
	private LabelBase CLReferenceDesc = null;
	private TextReadOnly CLReference = null;
	private LabelBase VoucherNoDesc = null;
	private TextString PolicyNo = null;
	private LabelBase PatientNameDisplayDesc = null;
	private TextString VoucherNo = null;
	private LabelBase PatientNoDisplayDesc = null;
	private TextReadOnly PatientNoDisplay = null;

	private ButtonBase CancelCreditAllocationButton = null;
	private int TabbedPaneIndex = 0;
	private TabbedPaneBase TabbedPane = null;

	private BasePanel SLPanel = null;
	private FieldSetBase SLSearchPanel = null;
	private LabelBase PatientNoDesc = null;
	private TextString PatientNo = null;
	private LabelBase PatientNameDesc = null;
	private TextString PatientName = null;
	private LabelBase SlipNoDesc = null;
	private TextString SlipNo = null;
	private LabelBase AmountRangeDesc = null;
	private TextNum AmountFrom = null;
	private LabelBase AmountToDesc = null;
	private TextNum AmountTo = null;
	private LabelBase PatientTypeDesc = null;
	private CheckBoxBase ChkNoPatientNo = null;
	private JScrollPane slipLvlJScrollPane = null;
	private TableList slipLvlEListTable = null;

	private BasePanel CLPanel = null;
	private LabelBase CLAmountToAllocateDesc = null;
	private TableList compLvlEListTable = null;
	private BasePanel compLvlJScrollPane = null;
	private LabelBase PolicyNoDesc = null;
	private TextNum AmountToAllocate = null;
	private LabelBase AmountToAllocateDesc = null;
	private ComboPatientType PatientType = null;
	private JScrollPane ARPJScrollPanel = null;
	private TableList ARPayment = null;

	private String memArcCode = null;
	private boolean loadSlipLevel = false;
	private boolean loadCompanyLevel = false;

	private String memAllocPaymentID = null;
	private Double prevSlipAllowAmt = 0.0d;
	private int memLastARPaymentRow = -1;

	private double amountAllocated = 0;

	/**
	 * This method initializes
	 *
	 */
	public ARCreditAlloc() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		Factory.getInstance().writeLogToLocal("--------------------------------");
		Factory.getInstance().writeLogToLocal("Load AR Credit Allocation.......");
		prevSlipAllowAmt = 0.0d;
		memLastARPaymentRow = -1;
		amountAllocated = 0;

		getARPayment().setColumnAmount(2);
		getARPayment().setColumnAmount(3);
		getARPayment().setColumnAmount(4);
		getSlipLvlEListTable().setColumnAmount(6);
		getSlipLvlEListTable().setColumnClass(12, new ComboPatientType(), false);
		getCompLvlEListTable().setColumnAmount(4);

		if (getParameter("ArcCode") != null) {
			memArcCode = getParameter("ArcCode");
			getPayerCode().setText(memArcCode);
			getPayerName().setText(getParameter("ArcName"));
		}

		resetParameter("ArcCode");
		resetParameter("ArcName");
		memAllocPaymentID = null;
		
		Factory.getInstance().writeLogToLocal("AR Code: "+memArcCode);

		getChkNoPatientNo().setSelected(true);
		getTabbedPane().setSelectedIndexWithoutStateChange(0);
		showPayment();
		enableButton();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		if (getTabbedPane().getSelectedIndex() == 0) {
			if (getPatientNo().getText().length() > 0 || 
					getSlipNo().getText().length() > 0 || getPolicyNo().getText().length() > 0 ||
					getVoucherNo().getText().length() > 0 || getPatientType().getText().length() > 0 ||
					getPatientName().getText().length() > 0 || getAmountFrom().getText().length() > 0 ||
					getAmountTo().getText().length() > 0) {
				return getAmountToAllocate();
			}
		}
		
		if (getTabbedPane().getSelectedIndex() == 0) {
			if (Factory.getInstance().getSysParameter("ALFOCUS").equals("SLPNO")) {
				return getSlipNo();
			}
			else {
				return getAmountToAllocate();
			}
		}
		else {
			return getCLAmountToAllocate();
		}
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
		if (getTabbedPane().getSelectedIndex() == 1) {
			return new String[] {
									"COMPANYLVL", memArcCode, EMPTY_VALUE,
									EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE,
									EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE,
									EMPTY_VALUE, EMPTY_VALUE
			}; 
		} else {
			return new String[] {
									"SLIPLVL", memArcCode,
									getPatientNo().getText().trim(),
									getChkNoPatientNo().isSelected()?"Y":"N",
									getSlipNo().getText().trim(),
									getPolicyNo().getText().trim(),
									getVoucherNo().getText().trim(),
									getPatientType().getText().trim(),
									getPatientName().getText().trim(),
									getAmountFrom().getText().trim(),
									getAmountTo().getText().trim()
			};
		}
	}

	/* >>> ~15.1~ Set Browse Output Results =============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {
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
		if (getTabbedPane().getSelectedIndex() == 0) {
			getPatientNoDisplay().setText(outParam[2]);
			getPatientNameDisplay().setText(outParam[3]);
			getAmountToAllocate().setText(outParam[SLIP_ALLOCATE_COLUMN]);
		} else if (getTabbedPane().getSelectedIndex() == 1) {
			getCLDescription().setText(outParam[1]);
			getCLReference().setText(outParam[2]);
			getCLAmountToAllocate().setText(outParam[COMPANY_ALLOCATE_COLUMN]);
		}
		focusCurrentAmtToAllocate(false);
	}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {};
	}

	/* >>> ~17~ Set Action Validation ================================= <<< */

	/***************************************************************************
	 * TableEditor Method
	 **************************************************************************/

	private TableList getSlipLvlEListTable() {
		if (slipLvlEListTable == null) {
			slipLvlEListTable = new TableList(getSLTableColumnNames(),
													getSLTableColumnWidths()) {
				@Override
				public void onSelectionChanged() {
					tableSelectionChange();
					focusCurrentAmtToAllocate(false);
				}
				
				@Override
				public void onClick() {
					tableSelectionChange();
					focusCurrentAmtToAllocate(false);
				}
				
				@Override
				public void postCommitTable() {
					showPayment();
				}
				
				@Override
				public void postSaveTable(boolean success, Integer rtnCode, String rtnMsg) {
					if (success) {
						Factory.getInstance().writeLogToLocal("Slip Table saved successfully.");
						if (rtnMsg != null && rtnMsg.length() > 0 && !rtnMsg.equalsIgnoreCase("null")) {
							Factory.getInstance().addErrorMessage(rtnMsg);
						}
						//clear search
						resetSearchField();
						getSearchButton().setEnabled(true);
						focusCurrentAmtToAllocate(true);
						showPayment();
					} else {
						Factory.getInstance().writeLogToLocal("Slip Table fail to save.");
						if (rtnMsg != null && rtnMsg.length() > 0) {
							Factory.getInstance().addErrorMessage(rtnMsg);
						}
					}
				}
			};
			slipLvlEListTable.getView().setSortingEnabled(false);
			slipLvlEListTable.setAutoHeight(false);
			slipLvlEListTable.setAutoWidth(false);
			slipLvlEListTable.setColumnAmount(6);
			slipLvlEListTable.setWidth(728);	
			slipLvlEListTable.setHeight(130);
		}
		return slipLvlEListTable;
	}

	private String[] getSLTableColumnNames() {
		return new String[] {
				EMPTY_VALUE,"ATXID",
				"Patient No.",
				"Patient Name",
				"Slip No.",
				"AR Date",
				"Outstanding Amt.",
				"Amount to Allocate", EMPTY_VALUE,
				"Status",
				"Policy#",
				"Voucher#",
				"Type"
		};
	}

	private int[] getSLTableColumnWidths() {
		return new int[] { 5, 0, 60, 230, 80, 70, 100, 110, 0, 0, 80, 60, 25};
	}

	private TableList getCompLvlEListTable() {
		if (compLvlEListTable == null) {
			compLvlEListTable = new TableList(getCLTableColumnNames(),
													getCLTableColumnWidths()) {
				@Override
				public void onSelectionChanged() {
					tableSelectionChange();
					focusCurrentAmtToAllocate(false);
				};
				
				@Override
				public void onClick() {
					tableSelectionChange();
					focusCurrentAmtToAllocate(false);
				}
				
				@Override
				public void postCommitTable() {
					showPayment();
				}

				@Override
				public void postSaveTable(boolean success, Integer rtnCode, String rtnMsg) {
					if (success) {
						Factory.getInstance().writeLogToLocal("Company Table saved successfully.");
						resetSearchField();
						getSearchButton().setEnabled(true);
						focusCurrentAmtToAllocate(true);
						showPayment();
					} else {
						Factory.getInstance().writeLogToLocal("Company Table saved successfully.");
						if (rtnMsg != null && rtnMsg.length() > 0) {
							Factory.getInstance().addErrorMessage(rtnMsg);
						}
					}
				}
			};
			
			compLvlEListTable.getView().setSortingEnabled(false);
			compLvlEListTable.setAutoHeight(true);
			compLvlEListTable.setAutoWidth(false);
			compLvlEListTable.setColumnAmount(4);

			//compLvlEListTable.setColumnAmount(5);
			compLvlEListTable.setWidth(728);
		}
		return compLvlEListTable;
	}

	private String[] getCLTableColumnNames() {
		return new String[] {
				EMPTY_VALUE,
				"Description",
				"Reference",
				"Transaction Date",
				"Outstanding Amt.",
				"Amount to Allocate",
				"Status",
				EMPTY_VALUE,
				"ATXAMT",
				"ATXSAMT",
				"ATXID"
		};
	}

	private int[] getCLTableColumnWidths() {
		return new int[] { 10, 150, 70, 120, 140, 140, 55, 0, 0, 0, 0 };
	}

	private TableList getCurrentEditorListTable() {
		if (getTabbedPane().getSelectedIndex() == 1) {
			return getCompLvlEListTable();
		} else {
			return getSlipLvlEListTable();
		}
	}
	
	private void focusCurrentAmtToAllocate(boolean reset) {
		if (getTabbedPane().getSelectedIndex() == 1) {
			if (reset) {
				getCLAmountToAllocate().resetText();
				prevSlipAllowAmt = 0.0d;
			}
			getCLAmountToAllocate().requestFocus();
		} else {
			if (reset) {
				getAmountToAllocate().resetText();
				prevSlipAllowAmt = 0.0d;
			}
			getAmountToAllocate().requestFocus();
		}
	}

	public void setTabbedPaneIndex(int index) {
		this.TabbedPaneIndex = index;
	}

	public int getTabbedPaneIndex() {
		return TabbedPaneIndex;
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void enableButton(String mode) {
		disableButton();
		getSaveButton().setEnabled(getCurrentEditorListTable().getStore().getModifiedRecords().size() > 0);
		Factory.getInstance().writeLogToLocal("[ARCreditAlloc enableButton]save button:Status:"+(getCurrentEditorListTable().getStore().getModifiedRecords().size() > 0));
		getCancelButton().setEnabled(getCurrentEditorListTable().getStore().getModifiedRecords().size() > 0);
		
		boolean isDirty = isEditing();
		getSaveButton().setEnabled(isDirty);
		getCancelButton().setEnabled(isDirty);
		getSearchButton().setEnabled(getTabbedPane().getSelectedIndex() == 0 && !getSaveButton().isEnabled());
		getCancelCreditAllocation().setEnabled(true);
	}

	@Override
	public void searchAction() {
		Factory.getInstance().writeLogToLocal("Search Action: search button is "+(getSearchButton().isEnabled()?"enable":"disable"));
		if (getSearchButton().isEnabled()) {
			setActionType(QueryUtil.ACTION_FETCH);
			if (getTabbedPane().getSelectedIndex() == 1) {
				loadCompanyLevel = false;
			} else {
				getPatientNoDisplay().resetText();
				getPatientNameDisplay().resetText();
				getAmountToAllocate().resetText();
				loadSlipLevel = false;
			}
			super.searchAction();
		}
	}

	@Override
	public void cancelAction() {
		if (getCancelButton().isEnabled()) {
			MessageBoxBase.confirm(MSG_PBA_SYSTEM, MSG_CANCEL_WARNING,
					new Listener<MessageBoxEvent>() {
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						getSearchButton().setEnabled(true);
						showPayment();
					}
				}
			});
		}
	}

	@Override
	public void rePostAction() {
		Factory.getInstance().writeLogToLocal("Repost Action......");
		showPayment();
	}

	@Override
	public void saveAction() {
		if (getSaveButton().isEnabled()) {		
			getSaveButton().setEnabled(false);
			Factory.getInstance().writeLogToLocal("[ARCreditAlloc saveAction]save button disabled:Status:"+getSaveButton().isEnabled());
			performAction(ACTION_SAVE);
		}
	}

	@Override
	protected void actionValidationReady(final String actionType, boolean isValidationReady) {
		if (isValidationReady) {
			getMainFrame().setLoading(true);

			int oamtCol = getCurrentTableAmtColIdx()[0];
			final int aamtCol = getCurrentTableAmtColIdx()[1];
			final int rownum = getCurrentEditorListTable().getSelectedRow();

			String aamtStr = (String) getCurrentEditorListTable().getValueAt(rownum, aamtCol);
			String oamtStr = (String) getCurrentEditorListTable().getValueAt(rownum, oamtCol);
			oamtStr = oamtStr.replaceAll(",", "");
			boolean isEdited = isEditing();

			if (getCurrentEditorListTable().equals(getSlipLvlEListTable()) && isEdited) {
				double aamt = 0.0d;
				double oamt = 0.0d;
				try {
					aamt = Double.parseDouble(aamtStr);
					oamt = Double.parseDouble(oamtStr);

					if (aamt > 0) {
						if (aamt <= oamt) {
							if (sumAllAmt() <= Double.parseDouble(memAllocAmt) * -1) {
								//save
								commitCreditAllocation();
							} else {
								Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_ALLOWED_AMOUNT,
										new Listener<MessageBoxEvent>() {
									@Override
									public void handleEvent(MessageBoxEvent be) {
										getCurrentEditorListTable().setValueAt("", rownum, aamtCol);
										getCurrentEditorListTable().setSelectRow(rownum);
										focusCurrentAmtToAllocate(true);
										
										enableButton();
									}
								});
							}
						} else {
							Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_ALLOCATED_AMOUNT,
									new Listener<MessageBoxEvent>() {
								@Override
								public void handleEvent(MessageBoxEvent be) {
									getCurrentEditorListTable().setValueAt("", rownum, aamtCol);
									getCurrentEditorListTable().setSelectRow(rownum);
									focusCurrentAmtToAllocate(true);

									enableButton();
								}
							});
						}
					} else {
						Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_POSITIVE_AMOUNT,
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								getCurrentEditorListTable().setValueAt("", rownum, aamtCol);
								getCurrentEditorListTable().setSelectRow(rownum);
								focusCurrentAmtToAllocate(true);

								enableButton();
							}
						});
					}
				} catch (Exception e) {
					if (aamtStr == null || aamtStr.trim().length() == 0) {
						if (sumAllAmt() <= Double.parseDouble(memAllocAmt) * -1) {
							//save
							commitCreditAllocation();
						} else {
							Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_ALLOWED_AMOUNT,
									new Listener<MessageBoxEvent>() {
								@Override
								public void handleEvent(MessageBoxEvent be) {
									getCurrentEditorListTable().setValueAt("", rownum, aamtCol);
									getCurrentEditorListTable().setSelectRow(rownum);
									focusCurrentAmtToAllocate(true);

									enableButton();
								}
							});
						}
					} else {
						Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_POSITIVE_AMOUNT,
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								getCurrentEditorListTable().setValueAt("", rownum, aamtCol);
								getCurrentEditorListTable().setSelectRow(rownum);
								focusCurrentAmtToAllocate(true);

								enableButton();
							}
						});
					}
				}
			}

			if (getCurrentEditorListTable().equals(getCompLvlEListTable()) && isEdited) {
				double aamt = 0.0d;
				double oamt = 0.0d;
				try {
					aamt = Double.parseDouble(aamtStr);
					oamt = Double.parseDouble(oamtStr);

					if (aamt > 0) {
						if (aamt <= oamt) {
							if (sumAllAmt() <= Double.parseDouble(memAllocAmt) * -1) {
								//save
								commitCreditAllocation();
							} else {
								Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_ALLOWED_AMOUNT,
										new Listener<MessageBoxEvent>() {
									@Override
									public void handleEvent(MessageBoxEvent be) {
										getCurrentEditorListTable().setValueAt("", rownum, aamtCol);
										getCurrentEditorListTable().setSelectRow(rownum);
										focusCurrentAmtToAllocate(true);

										enableButton();
									}
								});
							}
						} else {
							Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_ALLOCATED_AMOUNT,
									new Listener<MessageBoxEvent>() {
								@Override
								public void handleEvent(MessageBoxEvent be) {
									getCurrentEditorListTable().setValueAt("", rownum, aamtCol);
									getCurrentEditorListTable().setSelectRow(rownum);
									focusCurrentAmtToAllocate(true);

									enableButton();
								}
							});
						}
					} else {
						Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_POSITIVE_AMOUNT,
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								getCurrentEditorListTable().setValueAt("", rownum, aamtCol);
								getCurrentEditorListTable().setSelectRow(rownum);
								focusCurrentAmtToAllocate(true);

								enableButton();
							}
						});
					}
				} catch (Exception e) {
					if (aamtStr == null || aamtStr.trim().length() == 0) {
						if (sumAllAmt() <= Double.parseDouble(memAllocAmt) * -1) {
							//save
							commitCreditAllocation();
						} else {
							Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_ALLOWED_AMOUNT,
									new Listener<MessageBoxEvent>() {
								@Override
								public void handleEvent(MessageBoxEvent be) {
									getCurrentEditorListTable().setValueAt("", rownum, aamtCol);
									getCurrentEditorListTable().setSelectRow(rownum);
									focusCurrentAmtToAllocate(true);

									enableButton();
								}
							});
						}
					} else {
						Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_POSITIVE_AMOUNT,
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								getCurrentEditorListTable().setValueAt("", rownum, aamtCol);
								getCurrentEditorListTable().setSelectRow(rownum);
								focusCurrentAmtToAllocate(true);

								enableButton();
							}
						});
					}
				}
			}
		}
		getMainFrame().setLoading(false);
	}

	@Override
	protected void performListSetListTable(MessageQueue mQueue) {
		Factory.getInstance().writeLogToLocal("performListSetListTable: mQueue is "+mQueue.getContentAsQueue());
		getCurrentEditorListTable().setListTableContent(mQueue);
		getCurrentEditorListTable().getView().layout();
		getCurrentEditorListTable().setSelectRow(0);
	}
	
	@Override
	protected void searchPostAction() {
		getMainFrame().setLoading(false);
		defaultFocus();
	}

	@Override
	protected void performListNoRecordPostMsg(MessageQueue mQueue) {}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	private void commitCreditAllocation() {
		Factory.getInstance().writeLogToLocal("commitCreditAllocation.....");
		if (getCurrentEditorListTable().getRowCount() > 0) {
			getMainFrame().setLoading(true);
			Factory.getInstance().writeLogToLocal("Start to save the table......");
			Factory.getInstance().writeLogToLocal("memAllocPaymentID: "+memAllocPaymentID);
			getCurrentEditorListTable().saveTable(getTxCode(),
					new String[] {
							getUserInfo().getUserID(),
							memAllocPaymentID,
							getCurrentEditorListTable().equals(getSlipLvlEListTable())?"SLPLVL":"COMPLVL"
					},
					true,
					false,
					false,
					false,
					true,
					getTxCode());
		}
	}

	private void showARPAmt() {
		if (getARPayment().getSelectedRowContent() != null) {
			try {
				getPayAmt().setText(getARPayment().getSelectedRowContent()[2]);
				getAllocAmt().setText(getARPayment().getSelectedRowContent()[3]);
				getAllowAmt().setText(getARPayment().getSelectedRowContent()[4]);
			}
			catch (Exception e) {
				e.printStackTrace();
			}
			memAllocAmt = getARPayment().getSelectedRowContent()[4].replaceAll(",", "");
			memAllowAmt = getARPayment().getSelectedRowContent()[4].replaceAll(",", "");;
		}
	}

	private void showPayment() {
		getPayAmt().resetText();
		getAllocAmt().resetText();
		memAllocAmt = getAllocAmt().getText();
		getAllowAmt().resetText();
		memAllowAmt = getAllowAmt().getText();
		prevSlipAllowAmt = 0.0d;
		amountAllocated = 0;
		controlSlipLvlFields(true);
		
		Factory.getInstance().writeLogToLocal("showPayment.....");

		QueryUtil.executeMasterBrowse(
				getUserInfo(), ConstantsTx.ARCREDITALLOC_TXCODE,
				new String[] {
						EMPTY_VALUE, memArcCode, EMPTY_VALUE, EMPTY_VALUE,
						EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE,
						EMPTY_VALUE, EMPTY_VALUE, EMPTY_VALUE
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				Factory.getInstance().writeLogToLocal("showPayment: "+mQueue.success());
				Factory.getInstance().writeLogToLocal("showPayment record count: "+mQueue.getContentAsQueue());
				if (mQueue.success()) {
					getARPayment().setListTableContent(mQueue);
					showLevel(true);
					enableButton();
				} else if(Integer.parseInt(mQueue.getReturnCode()) < 0){
					getARPayment().removeAllRow();
					showLevel(true);
				}
			}
		});
	}

	private void showLevel(boolean allowRefresh) {
		Factory.getInstance().writeLogToLocal("show Level.....");
		Factory.getInstance().writeLogToLocal("current tab is "+getTabbedPane().getSelectedIndex());
		Factory.getInstance().writeLogToLocal("allowRefresh: "+allowRefresh);
		Factory.getInstance().writeLogToLocal("loadSlipLevel: "+loadSlipLevel);
		Factory.getInstance().writeLogToLocal("loadCompanyLevel: "+loadCompanyLevel);
		
		if (getTabbedPane().getSelectedIndex() == 0 && (allowRefresh || !loadSlipLevel)) {
			Factory.getInstance().writeLogToLocal("show slip Level.....");
			Factory.getInstance().writeLogToLocal("showLevel search button: "+getSearchButton().isEnabled());
			searchAction();
			loadSlipLevel = true;
		} else if (getTabbedPane().getSelectedIndex() == 1 && (allowRefresh || !loadCompanyLevel)) {
			Factory.getInstance().writeLogToLocal("show company Level.....");
			Factory.getInstance().writeLogToLocal("showLevel search button: "+getSearchButton().isEnabled());
			searchAction();
			loadCompanyLevel = true;
		}
		enableButton();
	}

	private int[] getCurrentTableAmtColIdx() {
		int oamtCol = -1;
		int aamtCol = -1;
		if (getCurrentEditorListTable().equals(getSlipLvlEListTable())) {
			oamtCol = 6;
			aamtCol = 7;
		} else if (getCurrentEditorListTable().equals(getCompLvlEListTable())) {
			oamtCol = 4;
			aamtCol = 5;
		}

		return new int[] {oamtCol, aamtCol};
	}

	private Double sumAllAmt() {
		return amountAllocated;
		/*
		int aamtCol = getCurrentTableAmtColIdx()[1];
		Double sumAllAmt = 0.0d;

		if (getCurrentEditorListTable().getRowCount() > 0) {
			int rowCount = getCurrentEditorListTable().getRowCount();
			String atxAAmt = null;

			for (int i = 0; i < rowCount; i++) {
				getCurrentEditorListTable().setSelectRow(i);
				if (getCurrentEditorListTable().getValueAt(i, aamtCol) != null) {
					atxAAmt = (String) getCurrentEditorListTable().getValueAt(i, aamtCol).trim();

					if (atxAAmt.trim() != null && atxAAmt.trim().length() > 0) {
						Double aamt = 0.0d;
						try {
							aamt = Double.parseDouble(atxAAmt);
						} catch (Exception ex) {
						}
						sumAllAmt = sumAllAmt + aamt;
					}
				}
			}
		}
		return sumAllAmt;
		*/
	}

	private void tableSelectionChange() {
		try {
			int aamtCol = getCurrentTableAmtColIdx()[1];
			int selRow = getCurrentEditorListTable().getSelectedRow();
			if (selRow >= 0) {
				String aamt = getCurrentEditorListTable().getValueAt(selRow, aamtCol);

				if (getCurrentEditorListTable().equals(getSlipLvlEListTable())) {
					getPatientNoDisplay().setText(getCurrentEditorListTable().getSelectedRowContent()[2]);
					getPatientNameDisplay().setText(getCurrentEditorListTable().getSelectedRowContent()[3]);
					getAmountToAllocate().setText(aamt);
				} else if (getCurrentEditorListTable().equals(getCompLvlEListTable())) {
					getCLDescription().setText(getCurrentEditorListTable().getSelectedRowContent()[1]);
					getCLReference().setText(getCurrentEditorListTable().getSelectedRowContent()[2]);
					getCLAmountToAllocate().setText(aamt);
				}
				if (aamt.length() > 0) {
					prevSlipAllowAmt = Double.parseDouble(aamt);
				}
				else {
					prevSlipAllowAmt = 0.0d;
				}
				memAllocPaymentID = getARPayment().getSelectedRowContent()[1];
			}
			if (getTabbedPane().getSelectedIndex() == 0) {
				controlSlipLvlFields(!isEditing());
			}
			enableButton();
			focusCurrentAmtToAllocate(false);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	private void controlSlipLvlFields(boolean enable) {
		getPatientNo().setEditable(enable);
		getChkNoPatientNo().setEditable(enable);
		getSlipNo().setEditable(enable);
		getPolicyNo().setEditable(enable);
		getPatientNo().setEditable(enable);
		getVoucherNo().setEditable(enable);
		getPatientType().setEditable(enable);
		getPatientName().setEditable(enable);
		getAmountFrom().setEditable(enable);
		getAmountTo().setEditable(enable);
	}
	
	private void resetSearchField() {
		getPatientNo().resetText();
		getSlipNo().resetText();
		getPolicyNo().resetText();
		getPatientNo().resetText();
		getVoucherNo().resetText();
		getPatientType().resetText();
		getPatientName().resetText();
		getAmountFrom().resetText();
		getAmountTo().resetText();
	}

	private boolean validateAllocateAmt() {
		//System.out.println("memAllowAmt: "+memAllowAmt);
		//System.out.println("isUserStopEdit: "+isUserStopEdit);
		//System.out.println("isValidated: "+isValidated);
		int oamtCol = getCurrentTableAmtColIdx()[0];
		final int aamtCol = getCurrentTableAmtColIdx()[1];
		final int selectedRow = getCurrentEditorListTable().getSelectedRow();

		String modAamt = null;
		modAamt = (String) getCurrentEditorListTable().getValueAt(selectedRow, aamtCol);
		String oamtStr = (String) getCurrentEditorListTable().getValueAt(selectedRow, oamtCol);
		oamtStr = oamtStr.replaceAll(",", "");
		final Double oldPreSlipAllowAmt = prevSlipAllowAmt;

		if (modAamt != null && modAamt.trim().length() > 0) {
			double amtValue = -1;

			try {
				amtValue = Double.parseDouble(modAamt);
			} catch (Exception e) {
				Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_POSITIVE_AMOUNT,
						new Listener<MessageBoxEvent>() {
					@Override
					public void handleEvent(MessageBoxEvent be) {
						// TODO Auto-generated method stub
						
					}
				});
				Double value = Double.parseDouble(memAllowAmt) - oldPreSlipAllowAmt;
				getAllowAmt().setText(String.valueOf(value));
				memAllowAmt = String.valueOf(value);
				amountAllocated = amountAllocated - oldPreSlipAllowAmt;

				getCurrentEditorListTable().setValueAt("", selectedRow, aamtCol);
				getCurrentEditorListTable().setSelectRow(selectedRow);
				focusCurrentAmtToAllocate(true);
				controlSlipLvlFields(!isEditing());
				enableButton();
				return false;
			}

			if (amtValue < 0) {
				Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_POSITIVE_AMOUNT,
						new Listener<MessageBoxEvent>() {
					@Override
					public void handleEvent(MessageBoxEvent be) {
						// TODO Auto-generated method stub
						
					}
				});
				Double value = Double.parseDouble(memAllowAmt) - oldPreSlipAllowAmt;
				getAllowAmt().setText(String.valueOf(value));
				memAllowAmt = String.valueOf(value);
				amountAllocated = amountAllocated - oldPreSlipAllowAmt;

				getCurrentEditorListTable().setValueAt("", selectedRow, aamtCol);
				getCurrentEditorListTable().setSelectRow(selectedRow);
				focusCurrentAmtToAllocate(true);
				controlSlipLvlFields(!isEditing());
				enableButton();
				return false;
			}

			if (Double.parseDouble(oamtStr) < Double.parseDouble(modAamt)) {
				Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_ALLOCATED_AMOUNT,
						new Listener<MessageBoxEvent>() {
					@Override
					public void handleEvent(MessageBoxEvent be) {
						// TODO Auto-generated method stub
						
					}
				});
				Double value = Double.parseDouble(memAllowAmt) - oldPreSlipAllowAmt;
				getAllowAmt().setText(String.valueOf(value));
				memAllowAmt = String.valueOf(value);
				amountAllocated = amountAllocated - oldPreSlipAllowAmt;

				getCurrentEditorListTable().setValueAt("", selectedRow, aamtCol);
				getCurrentEditorListTable().setSelectRow(selectedRow);
				focusCurrentAmtToAllocate(true);
				controlSlipLvlFields(!isEditing());
				enableButton();
				return false;
			}

			//System.out.println(Integer.parseInt(modAamt) > Double.parseDouble(memAllowAmt)*-1);
			//System.out.println(sumAllAmt());

			if (Double.parseDouble(modAamt) > (Double.parseDouble(memAllowAmt)-prevSlipAllowAmt)*-1) {
				if ((sumAllAmt()+Double.parseDouble(modAamt)-prevSlipAllowAmt) > Double.parseDouble(memAllocAmt) * -1) {
					Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_ALLOWED_AMOUNT,
							new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							// TODO Auto-generated method stub
							
						}
					});
					Double value = Double.parseDouble(memAllowAmt) - oldPreSlipAllowAmt;
					getAllowAmt().setText(String.valueOf(value));
					memAllowAmt = String.valueOf(value);
					amountAllocated = amountAllocated - oldPreSlipAllowAmt;

					getCurrentEditorListTable().setValueAt("", selectedRow, aamtCol);
					getCurrentEditorListTable().setSelectRow(selectedRow);
					focusCurrentAmtToAllocate(true);
					controlSlipLvlFields(!isEditing());
					enableButton();
					return false;
				}
			}

			Double value = Double.parseDouble(memAllowAmt) + Double.parseDouble(modAamt) - prevSlipAllowAmt;
			getAllowAmt().setText(String.valueOf(value));
			memAllowAmt = String.valueOf(value);
		} else {
			Double value = Double.parseDouble(memAllowAmt) + 0 - prevSlipAllowAmt;
			getAllowAmt().setText(String.valueOf(value));
			memAllowAmt = String.valueOf(value);
		}
		amountAllocated += Double.parseDouble(modAamt.length()>0?modAamt:"0") - prevSlipAllowAmt;
		return true;
	}

	private void confirmSaveDialog() {
		MessageBox saveMb = MessageBoxBase.confirm(MSG_PBA_SYSTEM, ConstantsMessage.MSG_SAVE_CREDIT_ALLOCATION,
					new Listener<MessageBoxEvent>() {
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						saveAction();
					} else {
						getSearchButton().setEnabled(true);
						showPayment();
					}
				}
			});
		saveMb.show();
		saveMb.getDialog().focus();
		saveMb.getDialog().setFocusWidget(saveMb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.setSize(816, 573);
			leftPanel.add(getPayerCodeDesc(), null);
			leftPanel.add(getPayerCode(), null);
			leftPanel.add(getPayerName(), null);
			leftPanel.add(getParaPanel(), null);
			leftPanel.add(getTabbedPane(), null);
			leftPanel.add(getCancelCreditAllocation(), null);
		}
		return leftPanel;
	}

	protected BasePanel getRightPanel() {
		if (rightPanel == null) {
			rightPanel = new BasePanel();
		}
		return rightPanel;
	}

	public LabelBase getPayerCodeDesc() {
		if (PayerCodeDesc == null) {
			PayerCodeDesc = new LabelBase();
			PayerCodeDesc.setText("Payer Code");
			PayerCodeDesc.setBounds(10, 5, 80, 20);
		}
		return PayerCodeDesc;
	}

	public TextReadOnly getPayerCode() {
		if (PayerCode == null) {
			PayerCode = new TextReadOnly();
			PayerCode.setBounds(89, 5, 103, 20);
		}
		return PayerCode;
	}

	public TextReadOnly getPayerName() {
		if (PayerName == null) {
			PayerName = new TextReadOnly();
			PayerName.setBounds(195, 5, 354, 20);
		}
		return PayerName;
	}

	public FieldSetBase getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new FieldSetBase();
			ParaPanel.setBounds(5, 30, 880, 150);
			ParaPanel.setHeading("AR Payment");
			ParaPanel.add(getPayAmtDesc(), null);
			ParaPanel.add(getPayAmt(), null);
			ParaPanel.add(getAllocAmtDesc(), null);
			ParaPanel.add(getAllocAmt(), null);
			ParaPanel.add(getAllowAmtDesc(), null);
			ParaPanel.add(getAllowAmt(), null);
			ParaPanel.add(getARPJScrollPanel(), null);
		}
		return ParaPanel;
	}

	public LabelBase getPayAmtDesc() {
		if (PayAmtDesc == null) {
			PayAmtDesc = new LabelBase();
			PayAmtDesc.setText("Payment Amount");
			PayAmtDesc.setBounds(20, 0, 100, 20);
		}
		return PayAmtDesc;
	}

	public TextReadOnlyAmount getPayAmt() {
		if (payAmt == null) {
			payAmt = new TextReadOnlyAmount();
			payAmt.setBounds(120, 0, 82, 20);
		}
		return payAmt;
	}

	public LabelBase getAllocAmtDesc() {
		if (AllocAmtDesc == null) {
			AllocAmtDesc = new LabelBase();
			AllocAmtDesc.setText("Allocated Amount");
			AllocAmtDesc.setBounds(250, 0, 110, 20);
		}
		return AllocAmtDesc;
	}

	public TextReadOnlyAmount getAllocAmt() {
		if (allocAmt == null) {
			allocAmt = new TextReadOnlyAmount() {
				@Override
				public void setText(String value) {
					super.setText(value);

					if (getARPayment().getRowCount() > 0) {
						try {
							getARPayment().setValueAt(TextUtil.formatColorCurrency(Double.parseDouble(value.replaceAll(",", ""))), getARPayment().getSelectedRow(), 3);
						}
						catch (Exception e) {
							getARPayment().setValueAt(value, getARPayment().getSelectedRow(), 3);
						}
					}
				}
			};
			allocAmt.setBounds(357, 0, 82, 20);
		}
		return allocAmt;
	}

	public LabelBase getAllowAmtDesc() {
		if (AllowAmtDesc == null) {
			AllowAmtDesc = new LabelBase();
			AllowAmtDesc.setText("Amount Allowed to Allocate");
			AllowAmtDesc.setBounds(525, 0, 160, 20);
		}
		return AllowAmtDesc;
	}

	public TextReadOnlyAmount getAllowAmt() {
		if (allowAmt == null) {
			allowAmt = new TextReadOnlyAmount() {
				@Override
				public void setText(String value) {
					super.setText(value);

					double amount = 0;
					if (value.length() > 0) {
						try {
							amount += Double.parseDouble(getPayAmt().getText()) * -1;
						} catch (Exception e) {
						}

						try {
							amount += Double.parseDouble(value);
						} catch (Exception e) {
						}

						getAllocAmt().setText(TextUtil.formatCurrency(amount));
					}
				}
			};
			allowAmt.setBounds(684, 0, 82, 20);
		}
		return allowAmt;
	}

	/**
	 * This method initializes ARPJScrollPanel
	 *
	 * @return javax.swing.JScrollPane
	 */
	private JScrollPane getARPJScrollPanel() {
		if (ARPJScrollPanel == null) {
			ARPJScrollPanel = new JScrollPane();
			ARPJScrollPanel.setBounds(20, 22, 850, 105);
			ARPJScrollPanel.setViewportView(getARPayment());
		}
		return ARPJScrollPanel;
	}

	/**
	 * This method initializes ARPayment
	 *
	 * @return com.hkah.client.layout.table.TableList
	 */
	private TableList getARPayment() {
		if (ARPayment == null) {
			ARPayment = new TableList(getColumnNames(), getColumnWidths()) {
				public void onSelectionChanged() {
					if (isEditing()) {
						if (getARPayment().getSelectedRow() != memLastARPaymentRow) {
							getARPayment().setSelectRow(memLastARPaymentRow);
							confirmSaveDialog();
						}
						return;
					}
					showARPAmt();
					memLastARPaymentRow = getARPayment().getSelectedRow();
					if (memLastARPaymentRow > -1) {
						memAllocPaymentID = getARPayment().getSelectedRowContent()[1];
					}
				}

				@Override
				public void setListTableContentPost() {
					// override for the child class
					setSelectRow(0);
					showARPAmt();
				}
			};
			ARPayment.getView().setSortingEnabled(false);
		}
		return ARPayment;
	}

	public TabbedPaneBase getTabbedPane() {
		if (TabbedPane == null) {
			TabbedPane = new TabbedPaneBase() {
				public void onStateChange() {
					if (isEditing()) {
						getTabbedPane().setSelectedIndexWithoutStateChange(getTabbedPane().getSelectedIndex()==0?1:0);
						confirmSaveDialog();
					} else {
						showLevel(false);
					}
				}
			};

			TabbedPane.setBounds(5, 185, 880, 420);
			TabbedPane.addTab("Slip Level", getSLPanel());
			TabbedPane.addTab("Company Level", getCLPanel());
		}
		return TabbedPane;
	}

	public BasePanel getSLPanel() {
		if (SLPanel == null) {
			SLPanel = new BasePanel();
			SLPanel.add(getSLSearchPanel(), null);
			SLPanel.add(getPatientNoDisplayDesc(), null);
			SLPanel.add(getPatientNoDisplay(), null);
			SLPanel.add(getPatientNameDisplayDesc(), null);
			SLPanel.add(getPatientNameDisplay(), null);
			SLPanel.add(getAmountToAllocate(), null);
			SLPanel.add(getAmountToAllocateDesc(), null);
			SLPanel.add(getSlipLvlJScrollPane(), null);
			SLPanel.setBounds(5, 5, 870, 500);
		}
		return SLPanel;
	}
	
	public FieldSetBase getSLSearchPanel() {
		if (SLSearchPanel == null) {
			SLSearchPanel = new FieldSetBase();
			SLSearchPanel.setHeading("Search Criteria");
			SLSearchPanel.add(getPatientNoDesc(), null);
			SLSearchPanel.add(getPatientNo(), null);
			SLSearchPanel.add(getPatientNameDesc(), null);
			SLSearchPanel.add(getPatientName(), null);
			SLSearchPanel.add(getChkNoPatientNo(), null);
			SLSearchPanel.add(getSlipNoDesc(), null);
			SLSearchPanel.add(getSlipNo(), null);
			SLSearchPanel.add(getAmountRangeDesc(), null);
			SLSearchPanel.add(getAmountFrom(), null);
			SLSearchPanel.add(getAmountToDesc(), null);
			SLSearchPanel.add(getAmountTo(), null);
			SLSearchPanel.add(getPolicyNoDesc(), null);
			SLSearchPanel.add(getPolicyNo(), null);
			SLSearchPanel.add(getVoucherNoDesc(), null);
			SLSearchPanel.add(getVoucherNo(), null);
			SLSearchPanel.add(getPatientTypeDesc(), null);
			SLSearchPanel.add(getPatientType(), null);
			SLSearchPanel.setBounds(5, 5, 850, 80);
		}
		return SLSearchPanel;
	}

	public LabelBase getPatientNoDesc() {
		if (PatientNoDesc == null) {
			PatientNoDesc = new LabelBase();
			PatientNoDesc.setText("Patient #");
			PatientNoDesc.setBounds(5, 0, 60, 20);
		}
		return PatientNoDesc;
	}

	public TextString getPatientNo() {
		if (PatientNo == null) {
			PatientNo = new TextString();
			PatientNo.setBounds(70, 0, 80, 20);
		}
		return PatientNo;
	}

	public CheckBoxBase getChkNoPatientNo() {
		if (ChkNoPatientNo == null) {
			ChkNoPatientNo = new CheckBoxBase() {
				public void onClick() {
					getPatientNo().setEditableForever(ChkNoPatientNo.isSelected());
				}
			};
			ChkNoPatientNo.setBounds(155, 0, 20, 20);
			ChkNoPatientNo.setSelected(true);
		}
		return ChkNoPatientNo;
	}
	
	public LabelBase getPatientNameDesc() {
		if (PatientNameDesc == null) {
			PatientNameDesc = new LabelBase();
			PatientNameDesc.setText("Patient Name");
			PatientNameDesc.setBounds(195, 0, 80, 20);
		}
		return PatientNameDesc;
	}
	
	public TextString getPatientName() {
		if (PatientName == null) {
			PatientName = new TextString();
			PatientName.setBounds(280, 0, 100, 20);
		}
		return PatientName;
	}

	public LabelBase getSlipNoDesc() {
		if (SlipNoDesc == null) {
			SlipNoDesc = new LabelBase();
			SlipNoDesc.setText("Slip #");
			SlipNoDesc.setBounds(405, 0, 40, 20);
		}
		return SlipNoDesc;
	}

	public TextString getSlipNo() {
		if (SlipNo == null) {
			SlipNo = new TextString();
			SlipNo.setBounds(490, 0, 120, 20);
		}
		return SlipNo;
	}
	
	public LabelBase getAmountRangeDesc() {
		if (AmountRangeDesc == null) {
			AmountRangeDesc = new LabelBase();
			AmountRangeDesc.setText("Amount");
			AmountRangeDesc.setBounds(630, 0, 50, 20);
		}
		return AmountRangeDesc;
	}
	
	public TextNum getAmountFrom() {
		if (AmountFrom == null) {
			AmountFrom = new TextNum();
			AmountFrom.setBounds(685, 0, 70, 20);
		}
		return AmountFrom;
	}
	
	public LabelBase getAmountToDesc() {
		if (AmountToDesc == null) {
			AmountToDesc = new LabelBase();
			AmountToDesc.setText("-");
			AmountToDesc.setBounds(760, 0, 5, 20);
		}
		return AmountToDesc;
	}
	
	public TextNum getAmountTo() {
		if (AmountTo == null) {
			AmountTo = new TextNum();
			AmountTo.setBounds(770, 0, 70, 20);
		}
		return AmountTo;
	}

	public LabelBase getPolicyNoDesc() {
		if (PolicyNoDesc == null) {
			PolicyNoDesc = new LabelBase();
			PolicyNoDesc.setBounds(5, 25, 60, 20);
			PolicyNoDesc.setText("Policy #");
		}
		return PolicyNoDesc;
	}

	public TextString getPolicyNo() {
		if (PolicyNo == null) {
			PolicyNo = new TextString();
			PolicyNo.setBounds(70, 25, 80, 20);
		}
		return PolicyNo;
	}

	public LabelBase getVoucherNoDesc() {
		if (VoucherNoDesc == null) {
			VoucherNoDesc = new LabelBase();
			VoucherNoDesc.setText("Voucher #");
			VoucherNoDesc.setBounds(195, 25, 80, 20);
		}
		return VoucherNoDesc;
	}

	public TextString getVoucherNo() {
		if (VoucherNo == null) {
			VoucherNo = new TextString();
			VoucherNo.setBounds(280, 25, 100, 20);
		}
		return VoucherNo;
	}

	public LabelBase getPatientTypeDesc() {
		if (PatientTypeDesc == null) {
			PatientTypeDesc = new LabelBase();
			PatientTypeDesc.setText("Patient Type");
			PatientTypeDesc.setBounds(405, 25, 80, 20);
		}
		return PatientTypeDesc;
	}

	/**
	 * This method initializes PatientType
	 *
	 * @return javax.swing.JComboBox
	 */
	private ComboPatientType getPatientType() {
		if (PatientType == null) {
			PatientType = new ComboPatientType();
			PatientType.setBounds(490, 25, 120, 20);
		}
		return PatientType;
	}

	public LabelBase getPatientNoDisplayDesc() {
		if (PatientNoDisplayDesc == null) {
			PatientNoDisplayDesc = new LabelBase();
			PatientNoDisplayDesc.setText("Patient No.");
			PatientNoDisplayDesc.setBounds(10, 90, 70, 20);
		}
		return PatientNoDisplayDesc;
	}

	public TextReadOnly getPatientNoDisplay() {
		if (PatientNoDisplay == null) {
			PatientNoDisplay = new TextReadOnly();
			PatientNoDisplay.setBounds(80, 90, 80, 20);
		}
		return PatientNoDisplay;
	}

	public LabelBase getPatientNameDisplayDesc() {
		if (PatientNameDisplayDesc == null) {
			PatientNameDisplayDesc = new LabelBase();
			PatientNameDisplayDesc.setText("Patient Name");
			PatientNameDisplayDesc.setBounds(180, 90, 80, 20);
		}
		return PatientNameDisplayDesc;
	}

	public TextReadOnly getPatientNameDisplay() {
		if (PatientNameDisplay == null) {
			PatientNameDisplay = new TextReadOnly();
			PatientNameDisplay.setBounds(265, 90, 180, 20);
		}
		return PatientNameDisplay;
	}

	public LabelBase getAmountToAllocateDesc() {
		if (AmountToAllocateDesc == null) {
			AmountToAllocateDesc = new LabelBase();
			AmountToAllocateDesc.setBounds(475, 90, 110, 20);
			AmountToAllocateDesc.setText("Amount to Allocate");
		}
		return AmountToAllocateDesc;
	}

	public TextNum getAmountToAllocate() {
		if (AmountToAllocate == null) {
			AmountToAllocate = new TextNum(9, 2) {
				@Override
				protected void onReleased(int KeyCode) {
					int selRow = getSlipLvlEListTable().getSelectedRow();
					if (getText().length() > 10) {
						resetText();
					}
					
					if (KeyCodes.KEY_DOWN == KeyCode) {
						if (selRow < 0) {
							getSlipLvlEListTable().setSelectRow(0);
						}
						else {
							if (getSlipLvlEListTable().getRowCount() == (selRow+1)) {
								return;
							}
							else {
								getSlipLvlEListTable().setSelectRow(selRow+1);
							}
						}
						focus();
					}
					else if (KeyCodes.KEY_UP == KeyCode) {
						if (selRow < 0) {
							getSlipLvlEListTable().setSelectRow(0);
						}
						else {
							if (getSlipLvlEListTable().getRowCount() == 0) {
								return;
							}
							else {
								getSlipLvlEListTable().setSelectRow(selRow-1);
							}
						}
						focus();
					}
					else {
						getSlipLvlEListTable().setValueAt(getText(), selRow, SLIP_ALLOCATE_COLUMN);
						validateAllocateAmt();
						
						if (getText().length() == 0) {
							prevSlipAllowAmt = 0.0d;
						}
						else {
							prevSlipAllowAmt = Double.parseDouble(getText());
						}
					}
					controlSlipLvlFields(!(getText().length()>0) && !isEditing());
					enableButton();
				}
			};
			AmountToAllocate.setBounds(590, 90, 150, 20);
		}
		return AmountToAllocate;
	}

	/**
	 * This method initializes jScrollPane
	 *
	 * @return JScrollPane
	 */
	protected JScrollPane getSlipLvlJScrollPane() {
		if (slipLvlJScrollPane == null) {
			slipLvlJScrollPane = new JScrollPane();
			slipLvlJScrollPane.setBorders(true);
			//slipLvlJScrollPane.setScrollMode(Scroll.AUTO);
			slipLvlJScrollPane.setViewportView(getSlipLvlEListTable());
			slipLvlJScrollPane.setBounds(10, 120, 850, 260);
		}
		return slipLvlJScrollPane;
	}

	public BasePanel getCLPanel() {
		if (CLPanel == null) {
			CLPanel = new BasePanel();
			CLPanel.add(getCLDescriptionDesc(), null);
			CLPanel.add(getCLDescription(), null);
			CLPanel.add(getCLReferenceDesc(), null);
			CLPanel.add(getCLReference(), null);
			CLPanel.add(getCLAmountToAllocateDesc(), null);
			CLPanel.add(getCLAmountToAllocate(), null);
			CLPanel.add(getCompLvlJScrollPane(), null);
			CLPanel.setBounds(5, 5, 870, 420);
		}
		return CLPanel;
	}

	public LabelBase getCLDescriptionDesc() {
		if (CLDescriptionDesc == null) {
			CLDescriptionDesc = new LabelBase();
			CLDescriptionDesc.setText("Description");
			CLDescriptionDesc.setBounds(20, 3, 72, 20);
		}
		return CLDescriptionDesc;
	}

	public TextReadOnly getCLDescription() {
		if (CLDescription == null) {
			CLDescription = new TextReadOnly();
			CLDescription.setBounds(92, 3, 228, 20);
		}
		return CLDescription;
	}

	public LabelBase getCLReferenceDesc() {
		if (CLReferenceDesc == null) {
			CLReferenceDesc = new LabelBase();
			CLReferenceDesc.setText("Reference");
			CLReferenceDesc.setBounds(350, 3, 60, 20);
		}
		return CLReferenceDesc;
	}

	public TextReadOnly getCLReference() {
		if (CLReference == null) {
			CLReference = new TextReadOnly();
			CLReference.setBounds(415, 3, 120, 20);
		}
		return CLReference;
	}

	public LabelBase getCLAmountToAllocateDesc() {
		if (CLAmountToAllocateDesc == null) {
			CLAmountToAllocateDesc = new LabelBase();
			CLAmountToAllocateDesc.setText("Amount to Allocate");
			CLAmountToAllocateDesc.setBounds(555, 3, 110, 20);
		}
		return CLAmountToAllocateDesc;
	}

	public TextNum getCLAmountToAllocate() {
		if (CLAmountToAllocate == null) {
			CLAmountToAllocate = new TextNum(9, 2) {
				@Override
				protected void onReleased(int KeyCode) {
					int selRow = getCompLvlEListTable().getSelectedRow();
					if (getText().length() > 10) {
						resetText();
					}
					
					if (KeyCodes.KEY_DOWN == KeyCode) {
						if (selRow < 0) {
							getCompLvlEListTable().setSelectRow(0);
						}
						else {
							if (getCompLvlEListTable().getRowCount() == (selRow+1)) {
								return;
							}
							else {
								getCompLvlEListTable().setSelectRow(selRow+1);
							}
						}
						focus();
					}
					else if (KeyCodes.KEY_UP == KeyCode) {
						if (selRow < 0) {
							getCompLvlEListTable().setSelectRow(0);
						}
						else {
							if (getCompLvlEListTable().getRowCount() == 0) {
								return;
							}
							else {
								getCompLvlEListTable().setSelectRow(selRow-1);
							}
						}
						focus();
					}
					else {
						getCompLvlEListTable().setValueAt(getText(), selRow, COMPANY_ALLOCATE_COLUMN);
						validateAllocateAmt();
						
						if (getText().length() == 0) {
							prevSlipAllowAmt = 0.0d;
						}
						else {
							prevSlipAllowAmt = Double.parseDouble(getText());
						}
					}
					controlSlipLvlFields(!(getText().length()>0) && !isEditing());
					enableButton();
				}
			};
			CLAmountToAllocate.setBounds(664, 3, 102, 20);
		}
		return CLAmountToAllocate;
	}

	private BasePanel getCompLvlJScrollPane() {
		if (compLvlJScrollPane == null) {
			compLvlJScrollPane = new BasePanel();
			compLvlJScrollPane.setBorders(true);
			compLvlJScrollPane.setScrollMode(Scroll.AUTO);
			compLvlJScrollPane.add(getCompLvlEListTable());
			compLvlJScrollPane.setBounds(20, 31, 850, 350);
		}
		return compLvlJScrollPane;
	}

	public ButtonBase getCancelCreditAllocation() {
		if (CancelCreditAllocationButton == null) {
			CancelCreditAllocationButton = new ButtonBase() {
				@Override
				public void onClick() {
					if (isEditing()) {
						//Confirm
						confirmSaveDialog();
						return;
					}

					if (getTabbedPane().getSelectedIndex() == 0) {
						if (getSlipLvlEListTable().getSelectedRow() > -1) {
							setParameter("SlpNo", getSlipLvlEListTable().getSelectedRowContent()[4]);
						} else {
							setParameter("SlpNo", "");
						}
					} else {
						if (getCompLvlEListTable().getSelectedRow() > -1) {
							setParameter("AtxID", getCompLvlEListTable().getSelectedRowContent()[10]);
						} else {
							setParameter("AtxID", "");
						}
					}
					setParameter("ArcCode", memArcCode);
					setParameter("FUNCTION", AR_CREDIT_ALLOC);

					showPanel(new ARDetail());
				}
			};
			CancelCreditAllocationButton.setText("Cancel Credit Allocation", 'e');
			CancelCreditAllocationButton.setBounds(25, 610, 177, 25);
		}
		return CancelCreditAllocationButton;
	}
	
	protected boolean isEditing() {
		return amountAllocated > 0;
	}
}