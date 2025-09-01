package com.hkah.client.tx.transaction;

import java.util.List;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboPkgJoined;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.tx.SearchPanel;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTransaction;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class PackageTransactionEntry extends SearchPanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.PACKAGETRANSACTIONENTRY_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.PACKAGETRANSACTIONENTRY_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"",
				"Seq No",
				"Pkg Code",
				"Item Code",
				"Amount",//PtnBAmt
				"Doctor Code",
				"Date",
				"Status",
				"Description",
				"Unit",
				"I-Ref",
				"GLCCODE",
				"PTNRLVL",
				"PtnOAmt",
				"ptn id",
				"SlpNo",
				"ItmType",
				"SpcName",
				"PtnCDate",
				"DscCode",
				"ptndesc1",
				"PtnDesc",
				"DIXREF",
				"PTNDIFLAG",
				"PTNCPSFLAG"
		};
	}

	protected int[] getColumnWidths() {
		return new int[] {
				10,
				45,
				60,
				60,
				70,
				75,
				80,
				40,
				180,
				40,
				80,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0,
				0
		};
	}

	private BasePanel searchPanel = null;
	private BasePanel listPanel = null;
	private BasePanel btnPanel = null;
	private BasePanel ParaPanel = null;
	private LabelBase SlipNoDesc = null;
	private TextReadOnly SlipNo = null;
	private LabelBase PatientDesc = null;
	private TextReadOnly PatientNo = null;
	private TextReadOnly PatientName = null;
	private LabelBase BedCodeDesc = null;
	private TextReadOnly BedCode = null;
	private LabelBase AdmDateDesc = null;
	private TextReadOnly AdmDate = null;
	private LabelBase DocDesc = null;
	private TextReadOnly DocCode = null;
	private TextReadOnly DocName = null;
	private LabelBase AcmCodeDesc = null;
	private TextReadOnly AcmCode = null;
	private LabelBase DischargeDateDesc = null;
	private TextReadOnly DischargeDate = null;
	private LabelBase BalanceDesc = null;
	private TextReadOnly Balance = null;
	private LabelBase PackageJoinDesc = null;
	private ComboPkgJoined PackageJoin = null;
	private LabelBase ShowHistoryDesc = null;
	private CheckBoxBase ShowHistory = null;

	private ButtonBase btnAddCharges = null;
	private ButtonBase btnAdjust = null;
	private ButtonBase btnCancel = null;
	private ButtonBase btnMoveItem = null;
	private ButtonBase btnMovePackage = null;
	private ButtonBase btnChgItemPkgCode = null;
	private ButtonBase btnChgPkgCode = null;

	private String memSlpType = null;
	private String memGlcCode = null;

	/**
	 * This method initializes
	 *
	 */
	public PackageTransactionEntry() {
		super();
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getListTable().setColumnAmount(4);

		getSlipNo().setText(getParameter("SlpNo"));
		getPatientNo().setText(getParameter("PatNo"));
		getPatientName().setText(getParameter("PatName"));
		getBedCode().setText(getParameter("BedCode"));
		getAdmDate().setText(getParameter("RegDate"));
		getDocCode().setText(getParameter("DocCode"));
		getDocName().setText(getParameter("DocName"));
		getAcmCode().setText(getParameter("AcmCode"));
		getDischargeDate().setText(getParameter("InpDDate"));
		memSlpType = getParameter("SlpType");
		memGlcCode = getParameter("GlcCode");

		// inital comobobox
		getPackageJoin().initContent(getSlipNo().getText());

		// reset parameter from previous screen
//		resetParameter("SlpNo");
//		resetParameter("PatNo");
//		resetParameter("PatName");
//		resetParameter("BedCode");
//		resetParameter("RegDate");
//		resetParameter("DocCode");
//		resetParameter("DocName");
//		resetParameter("AcmCode");
//		resetParameter("InpDDate");
//		resetParameter("SlpType");

		if (!getSlipNo().isEmpty()) {
			searchAction();
		}
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public ComboPkgJoined getDefaultFocusComponent() {
		return getPackageJoin();
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
				getSlipNo().getText(),
				(getShowHistory().isSelected() ? YES_VALUE : NO_VALUE)
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
		String[] para=getListTable().getSelectedRowContent();
		if (para!=null&&para.length>0) {
			if (ConstantsTransaction.SLIPTX_STATUS_ADJUST.equalsIgnoreCase(para[7])) {
				PanelUtil.setAllFieldsEditable(getBtnPanel(), true);
				getBtnAdjust().setEnabled(false);
			} else if (ConstantsTransaction.SLIPTX_STATUS_NORMAL.equalsIgnoreCase(para[7])) {
				PanelUtil.setAllFieldsEditable(getBtnPanel(), true);
			} else if (ConstantsTransaction.SLIPTX_STATUS_CANCEL.equalsIgnoreCase(para[7]) || ConstantsTransaction.SLIPTX_STATUS_MOVE.equalsIgnoreCase(para[7])) {
				   PanelUtil.setAllFieldsEditable(getBtnPanel(), false);
				  getBtnAddCharges().setEnabled(true);
			}
		}
	}

	/***************************************************************************
	 * Helper Methods
	 **************************************************************************/

	@Override
	public void searchAction() {
		searchAction(false);
	}

	@Override
	public void refreshAction() {
		if (getRefreshButton().isEnabled()) {
			searchAction();
		}
	}

	@Override
	protected void performListPost() {
		if (getListTable().getRowCount() > 0) {
			 TableData data = null;
			 int bl = 0;
			 List<TableData> tableData = getListTable().getStore().getModels();
			 for (int i = 0; i < tableData.size(); i++) {
				if ("N".equals(((TableData)tableData.get(i)).getValue(7)) ||
						"A".equals(((TableData)tableData.get(i)).getValue(7))) {
					data = (TableData) tableData.get(i);
					bl += Integer.parseInt((String) data.getValue(4));
				}
			}
			getBalance().setText(String.valueOf(bl));
		} else {
			getBalance().setText(ZERO_VALUE);
		}
		enableButton();
	}

	@Override
	protected void enableButton(String mode) {
		disableButton();
		getRefreshButton().setEnabled(true);

		boolean hasRecord = getListTable().getRowCount() > 0;
		getBtnAdjust().setEnabled(hasRecord);
		getBtnCancel().setEnabled(hasRecord);
		getBtnChgPkgCode().setEnabled(hasRecord);
		getBtnMoveItem().setEnabled(hasRecord);
		getBtnMovePackage().setEnabled(hasRecord);
		getBtnChgItemPkgCode().setEnabled(hasRecord);

		getListTable().onSelectionChanged();
	}

	/***************************************************************************
	 * Helper Methods
	 **************************************************************************/

	private void setSlipTxParam() {
		String[] para = null;
		if (getListTable().getSelectedRow() >= 0) {
			para = getListTable().getSelectedRowContent();
		} else {
			para = getListTable().getRowContent(0);
		}
		if (para != null) {
			setParameter("PtnID", para[14]);
			setParameter("SlpNo", getSlipNo().getText());
			setParameter("PtnDesc", para[8]);
			setParameter("DocCode", getDocCode().getText());
			setParameter("AcmCode", getAcmCode().getText());
			setParameter("SlpType", memSlpType);
			setParameter("GlcCode", memGlcCode);
			setParameter("PatNo", getPatientNo().getText());
			setParameter("PatName", getPatientName().getText());
			setParameter("BedCode",getBedCode().getText());
			setParameter("RegDate", getAdmDate().getText());
			setParameter("DocName",getDocName().getText());

			setParameter("PkgCode", para[2]);
			setParameter("ItmCode", para[3]);
			setParameter("PtnOAmt", para[13]);
			setParameter("PtnBAmt", para[4]);
			setParameter("PtnSts", para[7]);
			setParameter("PtnRLvl", para[12]);
			setParameter("PtnTDate", para[6]);
		}
	}

	// set slip package tx parameter
	private void setModifySlipTxParam() {
		String[] para = getListTable().getSelectedRowContent();
		
		if (para != null) {
			setParameter("PtnID", para[14]);
			setParameter("PtnDesc", para[8]);
			setParameter("PtnSeq", para[1]);
			setParameter("SlpNo", getSlipNo().getText());
			setParameter("PtnTDate", para[6]);
			setParameter("PkgCode", para[2]);
			setParameter("ItmCode", para[3]);
			setParameter("DocCode", getDocCode().getText());
			setParameter("AcmCode", getAcmCode().getText());
			setParameter("GlcCode", memGlcCode);
			setParameter("PtnOAmt", para[13]);
			setParameter("PtnBAmt", para[4]);
			setParameter("PtnSts", para[7]);
			setParameter("PtnRLvl", para[12]);
		}
	}

	/***************************************************************************
	 * Layout Methods
	 **************************************************************************/

	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected BasePanel getSearchPanel() {
		if (searchPanel == null) {
			searchPanel = new BasePanel();
			searchPanel.setSize(779, 468);
			searchPanel.add(getParaPanel(), null);
			searchPanel.add(getPackageJoinDesc(), null);
			searchPanel.add(getPackageJoin(), null);
			searchPanel.add(getShowHistoryDesc(), null);
			searchPanel.add(getShowHistory(), null);
			searchPanel.add(getListPanel(), null);
			searchPanel.add(getBtnPanel(), null);
		}
		return searchPanel;
	}

	public BasePanel getListPanel() {
		if (listPanel == null) {
			listPanel = new BasePanel();
			listPanel.setHeading("Package Tracsaction");
			listPanel.setBounds(5, 160, 758, 288);
			getJScrollPane().setBounds(3, 3, 750, 280);
			getLeftPanel().remove(getJScrollPane());
			listPanel.add(getJScrollPane());
		}
		return listPanel;
	}

	public BasePanel getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new BasePanel();
			ParaPanel.setBounds(5, 5, 757, 102);
			ParaPanel.setBorders(true);
			ParaPanel.add(getSlipNoDesc(), null);
			ParaPanel.add(getSlipNo(), null);
			ParaPanel.add(getPatientDesc(), null);
			ParaPanel.add(getPatientName(), null);
			ParaPanel.add(getBedCodeDesc(), null);
			ParaPanel.add(getBedCode(), null);
			ParaPanel.add(getAdmDateDesc(), null);
			ParaPanel.add(getAdmDate(), null);
			ParaPanel.add(getDocDesc(), null);
			ParaPanel.add(getDocCode(), null);
			ParaPanel.add(getDocName(), null);
			ParaPanel.add(getAcmCodeDesc(), null);
			ParaPanel.add(getAcmCode(), null);
			ParaPanel.add(getDischargeDateDesc(), null);
			ParaPanel.add(getDischargeDate(), null);
			ParaPanel.add(getBalanceDesc(), null);
			ParaPanel.add(getBalance(), null);
			ParaPanel.add(getPatientNo(), null);
		}
		return ParaPanel;
	}

	public LabelBase getSlipNoDesc() {
		if (SlipNoDesc == null) {
			SlipNoDesc = new LabelBase();
			SlipNoDesc.setText("Slip Number");
			SlipNoDesc.setBounds(25, 10, 90, 20);
		}
		return SlipNoDesc;
	}

	public TextReadOnly getSlipNo() {
		if (SlipNo == null) {
			SlipNo = new TextReadOnly();
			SlipNo.setBounds(123, 10, 130, 20);
		}
		return SlipNo;
	}

	public LabelBase getPatientDesc() {
		if (PatientDesc == null) {
			PatientDesc = new LabelBase();
			PatientDesc.setText("Patient");
			PatientDesc.setBounds(277, 10, 48, 20);
		}
		return PatientDesc;
	}

	public TextReadOnly getPatientNo() {
		if (PatientNo == null) {
			PatientNo = new TextReadOnly();
			PatientNo.setBounds(325, 10, 79, 20);
		}
		return PatientNo;
	}

	public TextReadOnly getPatientName() {
		if (PatientName == null) {
			PatientName = new TextReadOnly();
			PatientName.setBounds(410, 10, 150, 20);
		}
		return PatientName;
	}

	public LabelBase getBedCodeDesc() {
		if (BedCodeDesc == null) {
			BedCodeDesc = new LabelBase();
			BedCodeDesc.setText("Bed");
			BedCodeDesc.setBounds(588, 10, 62, 20);
		}
		return BedCodeDesc;
	}

	public TextReadOnly getBedCode() {
		if (BedCode == null) {
			BedCode = new TextReadOnly();
			BedCode.setBounds(649, 10, 95, 20);
		}
		return BedCode;
	}

	public LabelBase getAdmDateDesc() {
		if (AdmDateDesc == null) {
			AdmDateDesc = new LabelBase();
			AdmDateDesc.setText("Admission Date");
			AdmDateDesc.setBounds(25, 40, 90, 20);
		}
		return AdmDateDesc;
	}

	public TextReadOnly getAdmDate() {
		if (AdmDate == null) {
			AdmDate = new TextReadOnly();
			AdmDate.setBounds(123, 40, 130, 20);
		}
		return AdmDate;
	}

	public LabelBase getDocDesc() {
		if (DocDesc == null) {
			DocDesc = new LabelBase();
			DocDesc.setText("Doctor");
			DocDesc.setBounds(277, 40, 48, 20);
		}
		return DocDesc;
	}

	public TextReadOnly getDocCode() {
		if (DocCode == null) {
			DocCode = new TextReadOnly();
			DocCode.setBounds(325, 40, 79, 20);
		}
		return DocCode;
	}

	public TextReadOnly getDocName() {
		if (DocName == null) {
			DocName = new TextReadOnly();
			DocName.setBounds(410, 40, 150, 20);
		}
		return DocName;
	}

	public LabelBase getAcmCodeDesc() {
		if (AcmCodeDesc == null) {
			AcmCodeDesc = new LabelBase();
			AcmCodeDesc.setText("Acm Code");
			AcmCodeDesc.setBounds(588, 40, 62, 20);
		}
		return AcmCodeDesc;
	}

	public TextReadOnly getAcmCode() {
		if (AcmCode == null) {
			AcmCode = new TextReadOnly();
			AcmCode.setBounds(649, 40, 95, 20);
		}
		return AcmCode;
	}

	public LabelBase getDischargeDateDesc() {
		if (DischargeDateDesc == null) {
			DischargeDateDesc = new LabelBase();
			DischargeDateDesc.setText("Discharge Date");
			DischargeDateDesc.setBounds(25, 70, 90, 20);
		}
		return DischargeDateDesc;
	}

	public TextReadOnly getDischargeDate() {
		if (DischargeDate == null) {
			DischargeDate = new TextReadOnly();
			DischargeDate.setBounds(123, 70, 130, 20);
		}
		return DischargeDate;
	}

	public LabelBase getBalanceDesc() {
		if (BalanceDesc == null) {
			BalanceDesc = new LabelBase();
			BalanceDesc.setText("Balance");
			BalanceDesc.setBounds(277, 70, 48, 20);
		}
		return BalanceDesc;
	}

	public TextReadOnly getBalance() {
		if (Balance == null) {
			Balance = new TextReadOnly();
			Balance.setBounds(325, 70, 79, 20);
		}
		return Balance;
	}

	public LabelBase getPackageJoinDesc() {
		if (PackageJoinDesc == null) {
			PackageJoinDesc = new LabelBase();
			PackageJoinDesc.setText("Package Joined");
			PackageJoinDesc.setBounds(40, 115, 95, 20);
		}
		return PackageJoinDesc;
	}

	public ComboPkgJoined getPackageJoin() {
		if (PackageJoin == null) {
			PackageJoin = new ComboPkgJoined();
			PackageJoin.setBounds(136, 115, 125, 20);
		}
		return PackageJoin;
	}

	public LabelBase getShowHistoryDesc() {
		if (ShowHistoryDesc == null) {
			ShowHistoryDesc = new LabelBase();
			ShowHistoryDesc.setText("Show History");
			ShowHistoryDesc.setBounds(307, 115, 104, 20);
		}
		return ShowHistoryDesc;
	}

	public CheckBoxBase getShowHistory() {
		if (ShowHistory == null) {
			ShowHistory = new CheckBoxBase() {
				public void onClick() {
					searchAction();
				}
			};
			ShowHistory.setBounds(284, 115, 22, 20);
		}
		return ShowHistory;
	}

	public BasePanel getBtnPanel() {
		if (btnPanel == null) {
			btnPanel = new BasePanel();
			btnPanel.setBounds(10, 460, 756, 172);
			btnPanel.add(getBtnAddCharges(), null);
			btnPanel.add(getBtnAdjust(), null);
			btnPanel.add(getBtnCancel(), null);
			btnPanel.add(getBtnChgPkgCode(), null);
			btnPanel.add(getBtnMoveItem(), null);
			btnPanel.add(getBtnMovePackage(), null);
			btnPanel.add(getBtnChgItemPkgCode(), null);
		}
		return btnPanel;
	}

	public ButtonBase getBtnAddCharges() {
		if (btnAddCharges == null) {
			btnAddCharges = new ButtonBase() {
				@Override
				public void onClick() {
					setSlipTxParam();
					showPanel(new PackageChargeCapture());
				}
			};
			btnAddCharges.setText("Add Charges", 'A');
			btnAddCharges.setBounds(9, 5, 100, 25);
		}
		return btnAddCharges;
	}

	public ButtonBase getBtnAdjust() {
		if (btnAdjust == null) {
			btnAdjust = new ButtonBase() {
				@Override
				public void onClick() {
					setModifySlipTxParam();
					setParameter("TransactionMode", ConstantsTransaction.TXN_ADJUST_MODE);
					setParameter("doUpdatePkgCode", NO_VALUE);
					showPanel(new PackageModification());
				}
			};
			btnAdjust.setText("Adjust", 'd');
			btnAdjust.setBounds(114, 5, 69, 25);
		}
		return btnAdjust;
	}

	public ButtonBase getBtnCancel() {
		if (btnCancel == null) {
			btnCancel = new ButtonBase() {
				@Override
				public void onClick() {
					MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Do you want to cancel the transaction with the item code?",new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								QueryUtil.executeMasterAction(getUserInfo(), "SetPackageEntry", QueryUtil.ACTION_MODIFY,
										new String[] {getListTable().getSelectedRowContent()[14],ConstantsTransaction.SLIPTX_STATUS_CANCEL,""},
										new MessageQueueCallBack() {
									@Override
									public void onPostSuccess(MessageQueue mQueue) {
										// TODO Auto-generated method stub
										refreshAction();
									}
								});
							}
						}
					});
				}
			};
			btnCancel.setText("Cancel", 'C');
			btnCancel.setBounds(188, 5, 71, 25);
		}
		return btnCancel;
	}

	public ButtonBase getBtnMoveItem() {
		if (btnMoveItem == null) {
			btnMoveItem = new ButtonBase() {
				@Override
				public void onClick() {
					MessageBoxBase.confirm(MSG_PBA_SYSTEM, MSG_MOVEITM_TOSLIPTX, new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								if (getListTable().getSelectedRow() > -1) {
									QueryUtil.executeMasterAction(
											getUserInfo(),
											"MovePackageToSlip",
											QueryUtil.ACTION_APPEND,
											new String[] {
												getSlipNo().getText(),
												getListTable().getSelectedRowContent()[14],
												null,
												getUserInfo().getUserID()
											},
											new MessageQueueCallBack() {
										@Override
										public void onPostSuccess(MessageQueue mQueue) {
											// TODO Auto-generated method stub
											if (mQueue.success()) {
												refreshAction();
											} else {
												Factory.getInstance().addErrorMessage(mQueue);
											}
										}
									});
								} else {
									Factory.getInstance().addErrorMessage("Please select a row.");
								}
							}
						}
					});
				}
			};
			btnMoveItem.setText("Move Item", 'M');
			btnMoveItem.setBounds(264, 5, 100, 25);
		}
		return btnMoveItem;
	}

	public ButtonBase getBtnMovePackage() {
		if (btnMovePackage == null) {
			btnMovePackage = new ButtonBase() {
				@Override
				public void onClick() {
					MessageBoxBase.confirm(MSG_PBA_SYSTEM, MSG_MOVEPKG_TOSLIPTX, new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								if (getListTable().getSelectedRow() > -1) {
									QueryUtil.executeMasterAction(
											getUserInfo(),
											"MovePackageToSlip",
											QueryUtil.ACTION_APPEND,
											new String[] {
												getSlipNo().getText(),
												getListTable().getSelectedRowContent()[14],
												getListTable().getSelectedRowContent()[2],
												getUserInfo().getUserID()
											},
											new MessageQueueCallBack() {
										@Override
										public void onPostSuccess(MessageQueue mQueue) {
											// TODO Auto-generated method stub
											if (mQueue.success()) {
												refreshAction();
											} else {
												Factory.getInstance().addErrorMessage(mQueue);
											}
										}
									});
								} else {
									Factory.getInstance().addErrorMessage("Please select a row.");
								}
							}
						}
					});
				}
			};
			btnMovePackage.setText("Move Package", 'o');
			btnMovePackage.setBounds(370, 5, 109, 25);
		}
		return btnMovePackage;
	}

	public ButtonBase getBtnChgItemPkgCode() {
		if (btnChgItemPkgCode == null) {
			btnChgItemPkgCode = new ButtonBase() {
				@Override
				public void onClick() {
					String[] para = null;
					para = getListTable().getSelectedRowContent();
					
					if (para != null) {
						setModifySlipTxParam();
						setParameter("TransactionMode", ConstantsTransaction.TXN_CHANGE_MODE);
						setParameter("doUpdatePkgCode", NO_VALUE);
						showPanel(new PackageModification());
					}
				}
			};
			btnChgItemPkgCode.setText("Change Item PkgCode", 'I');
			btnChgItemPkgCode.setBounds(485, 5, 154, 25);
		}
		return btnChgItemPkgCode;
	}

	public ButtonBase getBtnChgPkgCode() {
		if (btnChgPkgCode == null) {
			btnChgPkgCode = new ButtonBase() {
				@Override
				public void onClick() {
					String[] para = null;
					para = getListTable().getSelectedRowContent();
					
					if (para != null) {
						setModifySlipTxParam();
						setParameter("TransactionMode", ConstantsTransaction.TXN_CHANGE_MODE);
						setParameter("doUpdatePkgCode", YES_VALUE);
						showPanel(new PackageModification());
					}
				}
			};
			btnChgPkgCode.setText("Change PkgCode", 'P');
			btnChgPkgCode.setBounds(644, 5, 117, 25);
		}
		return btnChgPkgCode;
	}
}