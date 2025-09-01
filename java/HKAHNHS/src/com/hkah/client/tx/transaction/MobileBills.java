package com.hkah.client.tx.transaction;

import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.MessageBox;
import com.google.gwt.core.client.GWT;
import com.hkah.client.common.Factory;
import com.hkah.client.event.CallbackListener;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboBillStatus;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboCardType;
import com.hkah.client.layout.combobox.ComboRefundMethod;
import com.hkah.client.layout.dialog.DialogBase;
import com.hkah.client.layout.dialog.DlgBrowserPanel;
import com.hkah.client.layout.dialog.DlgPDFPanel;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.BufferedTableList;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextAreaBase;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.ActionPaymentPanel;
import com.hkah.client.util.AppStmtUtil;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.Report;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class MobileBills	 extends ActionPaymentPanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return "APPBILL";
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return "Mobile Payment";
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"",
			"Bill No.",
			"Desc",
			"Bill Amt",
			"Paid Amt",
			"Remark",
			"Date",
			"Status",
			"slip",
			"Remain Amt",
			"slip type"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				10,
				80,
				80,
				50,
				70,
				100,
				80,
				50,
				100,
				0,
				50
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
	private LabelBase billStsDesc = null;
	private ComboBillStatus billSts = null;
	private LabelSmallBase RightJLabel_Source = null;
	private ComboBoxBase RightJCombo_Source = null;
	private ButtonBase newBill = null;
	private ButtonBase viewpdf = null;
	private ButtonBase closeBill = null;
	private ButtonBase reGenBill = null;
	private DlgPDFPanel viewPDFPanel = null;
	private ButtonBase newSlip = null;
	private LabelBase despositDesc = null;
	private JScrollPane billScrollPane = null;
	private LabelBase slpDesc = null;
	private TableList slpListTable = null;
	private JScrollPane slpScrollPane = null;
	private LabelBase cardTypeDesc = null;
	private ComboBoxBase cardType = null;
	private ButtonBase transfer = null;
	private LabelBase paymentDesc = null;
	private TableList payListTable = null;
	private JScrollPane payScrollPane = null;
	
	private ButtonBase remarkAction = null;
	private DialogBase remarkDialog = null;
	private FieldSetBase remarkTopPanel = null;
	private TextAreaBase remark_update = null;

	private static final String PDF_suffix = ".pdf";
	private static final int col_slipType = 10; 
	private static final int col_remainAmt = 9;
	private static final String slipType_Inpat = "I";
	private static final String slipType_Outpat = "O";
	/**
	 * This method initializes
	 *
	 */
	public MobileBills() {
		super();
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getListTable().setColumnAmount(4);
		getListTable().setColumnAmount(3);
		
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
			"",
			getPatNo().getText().trim(),
			getBillSts().getText(),
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
		showSlip();
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
		};
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(final String actionType) {

	}

	/***************************************************************************
	 * Override Methods
	 **************************************************************************/
	@Override
	protected void actionValidationReadyHelper(String actionType, MessageQueue mQueue) {

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
		getDeleteButton().setEnabled(getListTable().getSelectedRowCount() > 0);

		if (getListTable().getRowCount() > 0 && getPayListTable().getRowCount() > 0) {
			if (!"T".equals(getPayListTable().getSelectedRowContent()[8]) && getUserInfo().isCashier()) {	
					getTransfer().setEnabled(getSlpListTable().getRowCount() > 0);
			}

		} else {
			getTransfer().setEnabled(false);
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
	
	@Override
	public void deleteAction() {
		if (getListTable().getSelectedRowCount() > 0) {
			QueryUtil.executeMasterAction(getUserInfo(),
					"APPBILL",
					QueryUtil.ACTION_DELETE,
					new String[]{null,null,null,null,null,null,null,null, getUserInfo().getUserID(),null,getListTable().getSelectedRowContent()[1],null,null },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						Factory.getInstance().addInformationMessage("Bill Deleted!");
						searchAction(false);
					} else {
						Factory.getInstance().addErrorMessage(mQueue);
					}
				}}
			);
		}
		
		
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
						(getListTable().getRowCount() > 0 && getListSelectedRow()[1].length() > 0)?getListSelectedRow()[8]:null
					});
		//showPaymentDetail();
		enableButton();
	}

	private void showPaymentDetail() {
		getPayListTable().removeAllRow();

		if (getListTable().getRowCount() > 0 && getListSelectedRow()[1].length() > 0) {
			getPayListTable().setListTableContent(getTxCode(),
					new String[] {
						"pay",
						getPatNo().getText().trim(),
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
		if (!"".equals(getCardType().getText())) {
				try {
					MessageBox mb = MessageBoxBase.confirm(MSG_PBA_SYSTEM, ConstantsMessage.MSG_BILL_TRANSFER + " " + 				
								"<br>Slip No:"+getSlpListTable().getSelectedRowContent()[1]
		                         +"<br>Bill No:"+getListSelectedRow()[1],
							new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								actionHelper("Payment Transferred");
							}
						}
					});
		
					mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
				} catch (Exception e) {
					Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_BILL_TRANSFER_FAIL);
				}
		} else {
				Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_BILL_CARDTYPEEMPTY);
		}
	}


	private void actionHelper(final String successMessage) {
		if (getSlpListTable().getSelectedRowContent()[1] != null && getSlpListTable().getSelectedRowContent()[1].length() > 0) {
			QueryUtil.executeMasterFetch(getUserInfo(), "CARDNEWREF",
					new String[] { getSlpListTable().getSelectedRowContent()[1] },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					StringBuffer ecrRef = new StringBuffer();
					String ecr = null;
					ecrRef.append("000000");
					ecrRef.append(mQueue.getContentField()[0]);
					if (ecrRef.length() > 16) {
						ecr = ecrRef.substring(ecrRef.length() - 16);
					} else {
						ecr = ecrRef.toString();
					}
					
					QueryUtil.executeMasterAction(getUserInfo(),
							"APPBILL_TRANSFER",
							QueryUtil.ACTION_APPEND,
							new String[]{getListSelectedRow()[1],getPayListTable().getSelectedRowContent()[7],
											getSlpListTable().getSelectedRowContent()[1],ecr, getUserInfo().getUserID(),
											getCardType().getText()},
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
			});
		}

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
			listPanel.add(getBillStsDesc(), null);
			listPanel.add(getDespositDesc(), null);
			listPanel.add(getBillSts(), null);
			listPanel.add(getBillScrollPane());
			listPanel.add(getSlpDesc(), null);
			listPanel.add(getViewPdf(), null);
			listPanel.add(getReGenBill(), null);
			listPanel.add(getRemarkAction(),null);
			listPanel.add(getSlpScrollPane());
			listPanel.add(getTransfer(), null);
			listPanel.add(getCardTypeDesc(), null);
			listPanel.add(getCardType(), null);
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
	private JScrollPane getBillScrollPane() {
		if (billScrollPane == null) {
			billScrollPane = new JScrollPane();
			billScrollPane.setViewportView(getListTable());
			billScrollPane.setBounds(5, 90, 430, 200);
		}
		return billScrollPane;
	}

	private int[] getSlpColumnWidths() {
		return new int[] {
				10,
				100,
				120
				};
	}

	private String[] getSlpColumnNames() {
		return new String[] {
			"",
			"Slip No.",
			"Outstanding Amount"

		};
	}

	private TableList getSlpListTable() {
		if (slpListTable == null) {
			slpListTable = new TableList(getSlpColumnNames(), getSlpColumnWidths()) {
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
			80,
			80,
			80,
			100,
			100,
			100,
			0,
			80
		};
	}	

	private String[] getPayColumnNames() {
		return new String[] {
			"",
			"Amount",
			"App Payment Ref No",
			"Trans. Date",
			"Payment Type",
			"Card#",
			"Bank Tx. No",
			"",
			"status"
			
		};
	}

	private TableList getPayListTable() {
		if (payListTable == null) {
			payListTable = new TableList(getPayColumnNames(), getPayColumnWidths()) {
				@Override
				public void setListTableContent(String txCode, String[] param) {
					getMainFrame().setLoading(true);
					super.setListTableContent(txCode, param);
				}

				@Override
				public void setListTableContentPost() {
					getMainFrame().setLoading(false);
				}
				
				@Override
				public void onSelectionChanged() {
					if (payListTable.getRowCount() > 0) {
						getTransfer().setEnabled(!"T".equals(payListTable.getSelectedRowContent()[8]) && getUserInfo().isCashier());
						if (payListTable.getSelectedRowContent()[4] != null && payListTable.getSelectedRowContent()[4].length() > 0) {
							getCardType().refreshContent(new String[]{payListTable.getSelectedRowContent()[4]});
						} 
					} else {
						getCardType().resetText();
					}
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

	private LabelBase getBillStsDesc() {
		if (billStsDesc == null) {
			billStsDesc = new LabelBase();
			billStsDesc.setText("Bill Type");
			billStsDesc.setBounds(5, 30,100, 20);
		}
		return billStsDesc;
	}

	private ComboBillStatus getBillSts() {
		if (billSts == null) {
			billSts = new ComboBillStatus();
			billSts.setBounds(110, 30,120, 20);
		}
		return billSts;
	}
	
	public LabelSmallBase getRightJLabel_Source() {
		if (RightJLabel_Source == null) {
			RightJLabel_Source = new LabelSmallBase();
			RightJLabel_Source.setText("Status");
			RightJLabel_Source.setBounds(235, 30,50, 20);
		}
		return RightJLabel_Source;
	}

	public ComboBoxBase getRightJCombo_Source() {
		if (RightJCombo_Source == null) {
			RightJCombo_Source = new ComboBoxBase("TRANSSRC", false, false, true);
			RightJCombo_Source.setBounds(290, 30, 65, 20);
		}
		return RightJCombo_Source;
	}


	
	private LabelBase getDespositDesc() {
		if (despositDesc == null) {
			despositDesc = new LabelBase();
			despositDesc.setText("Bills");
			despositDesc.setBounds(5, 60,120, 20);
		}
		return despositDesc;
	}
	
	private ButtonBase getNewBills() {
		if (newBill == null) {
			newBill = new ButtonBase() {
				@Override
				public void onClick() {
				}
			};
			newBill.setText("Create Bill");
			newBill.setBounds(130, 60, 90, 25);
		}
		return newBill;
	}
	
	private ButtonBase getViewPdf() {
		if (viewpdf == null) {
			viewpdf = new ButtonBase() {
				@Override
				public void onClick() {
					
					getViewPDFPanel().showDialog(getSysParameter("ABillPathV")+getListSelectedRow()[1]);
				}
			};
			viewpdf.setText("View Statement");
			viewpdf.setBounds(80, 60, 90, 25);
		}
		return viewpdf;
	}
	
	private DlgPDFPanel getViewPDFPanel() {
		if(viewPDFPanel == null) {
			viewPDFPanel = new DlgPDFPanel(getMainFrame());
			
		}
		return viewPDFPanel;
		
	}
	
	private ButtonBase getReGenBill() {
		if (reGenBill == null) {
			reGenBill = new ButtonBase() {
				@Override
				public void onClick() {
					if(getListTable().getSelectedRowContent()[col_slipType].equals(slipType_Outpat)) {
						AppStmtUtil.genOPStatement(getListSelectedRow()[8], getListSelectedRow()[1], getListSelectedRow()[5], null, null);
					} else if(getListTable().getSelectedRowContent()[col_slipType].equals(slipType_Inpat)) {
						AppStmtUtil.genIPStatement(getListSelectedRow()[8], getListSelectedRow()[1], getParameter("PatNo"), getListSelectedRow()[5], null);
					}
				}
			};
			reGenBill.setText("Regenerate Stmt");
			reGenBill.setBounds(170, 60, 100, 25);
		}
		return reGenBill;
	}
	

	
	
	private ButtonBase getCloseBill() {
		if (closeBill == null) {
			closeBill = new ButtonBase() {
				@Override
				public void onClick() {
					if (Integer.parseInt(getListTable().getSelectedRowContent()[col_remainAmt]) == 0 ){
						MessageBoxBase.confirm("Mobile Bill", ConstantsMessage.MSG_BILL_ISClOSEBILL,
								new Listener<MessageBoxEvent>() {
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									QueryUtil.executeMasterAction(getUserInfo(), "APPBILL_CLOSE", QueryUtil.ACTION_APPEND,
											new String[] {getListTable().getSelectedRowContent()[1]},
											new MessageQueueCallBack() {
										@Override
										public void onPostSuccess(MessageQueue mQueue) {
											if (mQueue.success()) {
												Factory.getInstance().addInformationMessage("Bill Closed");
												searchAction(false);

											} else {
												//Factory.getInstance().addErrorMessage(mQueue, getPkgCode());
											}
										}
									});
								} 
							}
						});
					}
				}
			};
			closeBill.setText("Close Bill");
			closeBill.setVisible(false);
			closeBill.setBounds(300, 60, 90, 25);
		}
		return closeBill;
	}

	private LabelBase getSlpDesc() {
		if (slpDesc == null) {
			slpDesc = new LabelBase();
			slpDesc.setText("Available Slip");
			slpDesc.setBounds(455, 60,120, 20);
		}
		return slpDesc;
	}
	
	private ButtonBase getNewSlip() {
		if (newSlip == null) {
			newSlip = new ButtonBase() {
				@Override
				public void onClick() {
				}
			};
			newSlip.setText("Create Slip");
			newSlip.setBounds(580, 60, 90, 25);
			newSlip.isVisible(false);	
		}
		return newSlip;
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
			transfer.setBounds(260, 295, 90, 25);
		}
		return transfer;
	}
	
	private LabelBase getCardTypeDesc() {
		if (cardTypeDesc == null) {
			cardTypeDesc = new LabelBase();
			cardTypeDesc.setText("Card Type");
			cardTypeDesc.setBounds(5, 295, 60, 20);
		}
		return cardTypeDesc;
	}

	public ComboBoxBase getCardType() {
		if (cardType == null) {
			cardType = new ComboBoxBase("APPBILLCARDTYPE",new String[]{null}, false, true, false);
			cardType.setBounds(70, 295, 180, 20);
		}
		return cardType;
	}


	private LabelBase getPaymentDesc() {
		if (paymentDesc == null) {
			paymentDesc = new LabelBase();
			paymentDesc.setText("Payment Detail");
			paymentDesc.setBounds(5, 325, 120, 20);
		}
		return paymentDesc;
	}
	
	// remark  start
	private ButtonBase getRemarkAction() {
		if (remarkAction == null) {
			remarkAction = new ButtonBase() {
				@Override
				public void onClick() {
					QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] {"APPBILLS", "BILLREMARK", "BILLID ='"+getListTable().getSelectedRowContent()[1]+"' "},
							new MessageQueueCallBack() {
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								getRemark_update().setText(mQueue.getContentField()[0]);
								getRemarkDialog().setVisible(true);
							}
						}});
					
				}
			};
			remarkAction.setText("Update Remark");
			remarkAction.setBounds(300, 60, 90, 25);
		}
		return remarkAction;
	}
	
	public DialogBase getRemarkDialog() {
		if (remarkDialog == null) {
			remarkDialog = new DialogBase(getMainFrame(), DialogBase.OKCANCEL, 600, 400) {
				@Override
				public TextAreaBase getDefaultFocusComponent() {
					return getRemark_update();
				}

				@Override
				public void doOkAction() {
					doRemark();
				}
			};
			remarkDialog.setTitle("Remark");
			remarkDialog.setLayout(null);
			remarkDialog.setPosition(300, 100);
			remarkDialog.add(getRemarkTopPanel(), null);

			// change label
			remarkDialog.getButtonById(DialogBase.OK).setText("Update");
		}
		return remarkDialog;
	}

	private FieldSetBase getRemarkTopPanel() {
		if (remarkTopPanel == null) {
			remarkTopPanel = new FieldSetBase();
			remarkTopPanel.setBounds(5, 5, 500, 300);
			remarkTopPanel.setHeading("Update remark");
			remarkTopPanel.add(getRemark_update(), null);
		}
		return remarkTopPanel;
	}

	private TextAreaBase getRemark_update() {
		if (remark_update == null) {
			remark_update = new TextAreaBase();
			remark_update.setMaxLength(500);
			remark_update.setStyleAttribute("white-space", "pre-wrap");
			remark_update.setBounds(10, 5, 480, 290);
		}
		return remark_update;
	}
	
	private void doRemark() {
		QueryUtil.executeMasterAction(getUserInfo(), "APPBILLS_RMK", QueryUtil.ACTION_MODIFY,
				new String[] {
					getListTable().getSelectedRowContent()[1],
					getRemark_update().getText().trim(),
					getUserInfo().getUserID()
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getRemark_update().resetText();
					getRemarkDialog().setVisible(false);
					searchAction();
				} else {
					Factory.getInstance().addErrorMessage(mQueue);
				}
			}
		});
	}	
}
