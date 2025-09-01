package com.hkah.client.tx.accreceivable;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.MessageBox;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextSlipNo;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsAR;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class ARDetail extends MasterPanel implements ConstantsAR, ConstantsMessage {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.ARDETAIL_SLIP_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		if (AR_CREDIT_ALLOC.equals(memType)) {
			return "Cancel Credit Allocation";
		} else {
			return ConstantsTx.ARDETAIL_TITLE;
		}
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"",
			"Slip No.",  //ID
			"Patient",
			"Amount",
			"",
			"Tran.Date",
			"Description",
			"", ""
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				0,
				80,
				60,
				60,
				0,
				80,
				180,
				0, 0
		};
	}

	private BasePanel rightPanel = null;
	private BasePanel leftPanel = null;

	private BasePanel ParaPanel = null;

	private LabelBase outAmtDesc = null;
	private TextReadOnly outAmt = null;
	private LabelBase slipNoDesc = null;
	private TextSlipNo slipNo = null;
	private LabelBase totalAmtDesc = null;
	private TextReadOnly totalAmt = null;

	private FieldSetBase slipDetailPanel = null;
	private FieldSetBase transactionDetailPanel = null;
	private TableList HistoryTable = null;
	private JScrollPane HistoryJScrollPane = null;

	private ButtonBase cancelTransactionButton = null;

	private String memType = null;
	private String memAtxID = null;
	private String memArcCode = null;
	private String memPatNo = null;
	private String memSlipNo = null;

	/**
	 * This method initializes
	 *
	 */

	public ARDetail() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
		getJScrollPane().setBounds(5, 0, 433, 355);
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		memType = getParameter("FUNCTION");
		memAtxID = getParameter("AtxID");
		memSlipNo = getParameter("SlpNo");
		memPatNo = getParameter("PatNo");
		memArcCode = getParameter("ArcCode");

		getSlipNo().setText(memSlipNo);

		resetParameter("AtxID");
		resetParameter("SlpNo");
		resetParameter("PatNo");
		resetParameter("ArcCode");
		resetParameter("FUNCTION");

		getHistoryTable().setColumnAmount(2);

		boolean isARCreditAlloc = AR_CREDIT_ALLOC.equals(memType);
		getCancelTransactionButton().setVisible(isARCreditAlloc);
		getSlipNo().setEditableForever(isARCreditAlloc);

		if ((memSlipNo != null && memSlipNo.trim().length() > 0) ||
				(memAtxID != null && memAtxID.trim().length() > 0)) {
			searchAction();
		}
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getSlipNo();
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
		if (memAtxID == null || "".equals(memAtxID)) {
			return new String[] {
					memArcCode,
					"",
					getSlipNo().getText().trim(),
					memPatNo
			};
		} else {
			return new String[] { memArcCode, memAtxID, "", ""};
		}
	}

	/* >>> ~15.1~ Set Browse Output Results =============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		return new String[] {};
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
		getTotalAmt().setText(outParam[3]);
		getOutAmt().setText(outParam[4]);

		getHistoryTable().setListTableContent(
				ConstantsTx.ARDETAIL_TRAN_TXCODE,
				new String[] { outParam[0] }
		);
	}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {};
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {}

	/* >>> ~17~ Set Action Validation ================================= <<< */
	@Override
	protected void actionValidation(String actionType) {}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	private void close() {
		if (getListTable().getSelectedRow() < 0 || getHistoryTable().getSelectedRow() < 0) {
			return;
		}
		final String origAtxID = getListSelectedRow()[0];
		final String allocAtxID = getHistoryTable().getSelectedRowContent()[0];

		MessageBox mb =
			MessageBoxBase.confirm(MSG_PBA_SYSTEM, MSG_AR_CANCEL, new Listener<MessageBoxEvent>() {
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.ARDETAIL_SLIP_TXCODE, QueryUtil.ACTION_DELETE,
								new String[] { origAtxID, allocAtxID, getUserInfo().getUserID() },
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									if (!"0".equals(mQueue.getReturnCode())) {
										Factory.getInstance().addInformationMessage(mQueue.getReturnMsg());
									} else {
										Factory.getInstance().addInformationMessage("Cancelled successfully.");
									}
								} else {
									Factory.getInstance().addInformationMessage("Fail to Cancel.");
								}
								searchAction();
							}
						});
					}
				}
			});

		mb.getDialog().setFocusWidget(mb.getDialog().getButtonBar().getItemByItemId(Dialog.YES));
	}

	private void updateCloseButton() {
		getCancelTransactionButton().setEnabled(getHistoryTable().getRowCount() > 0 && "N".equals(getHistoryTable().getSelectedRowContent()[4]));
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void enableButton(String mode) {
		disableButton();
		getSearchButton().setEnabled(true);

		updateCloseButton();
	}

	@Override
	public void searchAction() {
		getTotalAmt().resetText();
		getOutAmt().resetText();
		getHistoryTable().removeAllRow();

		super.searchAction();
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.setSize(850, 490);
			leftPanel.add(getParaPanel(),null);
			leftPanel.add(getSlipDetailPanel(),null);
			leftPanel.add(getTransactionDetailPanel(), null);
			leftPanel.add(getCancelTransactionButton(),null);
		}
		return leftPanel;
	}

	protected BasePanel getRightPanel() {
		if (rightPanel == null) {
			rightPanel = new BasePanel();
		}
		return rightPanel;
	}

	public ButtonBase getCancelTransactionButton() {
		if (cancelTransactionButton == null) {
			cancelTransactionButton = new ButtonBase() {
				@Override
				public void onClick() {
					close();
				}
			};
			cancelTransactionButton.setText("Cancel");
			cancelTransactionButton.setBounds(465, 460, 72, 25);
		}
		return cancelTransactionButton;
	}

	public BasePanel getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new BasePanel();
			ParaPanel.add(getSlipNoDesc(), null);
			ParaPanel.add(getSlipNo(), null);
			ParaPanel.add(getTotalAmtDesc(), null);
			ParaPanel.add(getTotalAmt(), null);
			ParaPanel.add(getOutAmtDesc(), null);
			ParaPanel.add(getOutAmt(), null);
			ParaPanel.setBounds(5, 5, 800, 60);
			ParaPanel.setBorders(true);
		}
		return ParaPanel;
	}

	public LabelBase getSlipNoDesc() {
		if (slipNoDesc == null) {
			slipNoDesc = new LabelBase();
			slipNoDesc.setText("Slip Number:");
			slipNoDesc.setBounds(25, 15, 75, 20);
		}
		return slipNoDesc;
	}

	public TextSlipNo getSlipNo() {
		if (slipNo == null) {
			slipNo = new TextSlipNo();
			slipNo.setBounds(105, 15, 110, 20);
		 }
		return slipNo;
	}

	public LabelBase getTotalAmtDesc() {
		if (totalAmtDesc == null) {
			totalAmtDesc = new LabelBase();
			totalAmtDesc.setText("Total Amount:");
			totalAmtDesc.setBounds(250, 15, 80, 20);
		}
		return totalAmtDesc;
	}

	public TextReadOnly getTotalAmt() {
		if (totalAmt == null) {
			totalAmt = new TextReadOnly();
			totalAmt.setBounds(350, 15, 110, 20);
		 }
		return totalAmt;
	}

	public LabelBase getOutAmtDesc() {
		if (outAmtDesc == null) {
			outAmtDesc = new LabelBase();
			outAmtDesc.setText("Outstanding Amount");
			outAmtDesc.setBounds(500, 15, 120, 20);
		}
		return outAmtDesc;
	}

	public TextReadOnly getOutAmt() {
		if (outAmt == null) {
			outAmt = new TextReadOnly();
			outAmt.setBounds(630, 15, 120, 20);
		}
		return outAmt;
	}

	public FieldSetBase getSlipDetailPanel() {
		if (slipDetailPanel == null) {
			slipDetailPanel = new FieldSetBase();
			slipDetailPanel.setHeading("Slip Detail");
			slipDetailPanel.setBounds(5, 70, 450, 383);
			slipDetailPanel.add(getJScrollPane(), null);
		}
		return slipDetailPanel;
	}

	public FieldSetBase getTransactionDetailPanel() {
		if (transactionDetailPanel == null) {
			transactionDetailPanel = new FieldSetBase();
			transactionDetailPanel.setHeading("Transaction Detail");
			transactionDetailPanel.setBounds(455, 70, 350, 383);
			transactionDetailPanel.add(getHistoryJScrollPane(), null);
		}
		return transactionDetailPanel;
	}

	private JScrollPane getHistoryJScrollPane() {
		if (HistoryJScrollPane == null) {
			HistoryJScrollPane = new JScrollPane();
			HistoryJScrollPane.setViewportView(getHistoryTable());
			HistoryJScrollPane.setBounds(5, 0, 350, 355);
		}
		return HistoryJScrollPane;
	}

	private TableList getHistoryTable() {
		if (HistoryTable == null) {
			HistoryTable = new TableList(getDVATableColumnNames(), getDVATableColumnWidths()) {
				@Override
				public void setListTableContentPost() {
					updateCloseButton();
				}

				@Override
				public void onSelectionChanged() {
					if (AR_CREDIT_ALLOC.equals(memType)) {
						if (getHistoryTable().getSelectedRow() != -1) {
							if ("N".equals(getHistoryTable().getSelectedRowContent()[4])) {
								getCancelTransactionButton().setEnabled(true);
							} else {
								getCancelTransactionButton().setEnabled(false);
							}
						}
					}
				};
			};
//			HistoryTable.setAutoResizeMode(JTable.AUTO_RESIZE_OFF);
		}
		return HistoryTable;
	}

	protected String[] getDVATableColumnNames() {
		return new String[] {
				"",
				"Tran.Date",
				"Amount",
				"Receipt#",
				"Status"
				};
	}

	protected int[] getDVATableColumnWidths() {
		return new int[] { 0, 100, 70, 110, 50};
	}
}