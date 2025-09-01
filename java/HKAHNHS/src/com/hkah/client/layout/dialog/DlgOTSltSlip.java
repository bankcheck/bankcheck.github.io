package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.combobox.ComboPatientType;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.ot.OTLogBook;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgOTSltSlip extends DialogBase {
	private final static int m_frameWidth = 380;
	private final static int m_frameHeight = 220;

	private OTLogBook oTLogBook = null;
	private BasePanel calRefItemPanel = null;
	private LabelBase patNoDesc = null;
	private TextString patNo = null;
	private LabelBase dateOfOperationDesc = null;
	private TextDate dateOfOperation = null;
	private LabelBase patTypeDesc = null;
	private ComboPatientType patType = null;
	private DialogBase dlgOTSltSlipDisplayDialog = null;
	private JScrollPane dlgOTSltSlipDisplayPanel = null;
	private TableList dlgOTSltSlipDisplayTable = null;

	private String lOTA_Id = null;
	private String preSlipNum = null;
	private String sPreTyp = null;

	public DlgOTSltSlip(MainFrame owner, OTLogBook oTLogBook) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
		this.oTLogBook = oTLogBook;
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Save Slip Numbers");
		setContentPane(getSaveSlipNoPanel());
		getButtonById(OK).setText("Save", 'S');

		getDateOfOperation().setText(getMainFrame().getServerDateTime());
	}

	@Override
	public TextString getDefaultFocusComponent() {
		return getPatNo();
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String patno, String dateOfOper, String patType) {
		getPatNo().setText(patno);
		getDateOfOperation().setText(dateOfOper);
		if ("I".equalsIgnoreCase(patType)) {
			getPatType().setSelectedIndex(1);
		} else if ("O".equalsIgnoreCase(patType)) {
			getPatType().setSelectedIndex(2);
		} else if ("D".equalsIgnoreCase(patType)) {
			getPatType().setSelectedIndex(3);
		}
		preSlipNum = getParameter("SlipNo");
		lOTA_Id = getParameter("fromOTLId");
		sPreTyp = patType;

		getPatNo().setReadOnly(true);
		getPatNo().setEditable(false);
		setVisible(true);
	}

	@Override
	protected void doOkAction() {
		saveAction("0", null);
	}

	private void saveAction(String stage, String selSlipNum) {
		if ("0".equals(getPatNo().getText())) {
			Factory.getInstance().addErrorMessage("Invalid patient no!");
			return;
		}
		if (getDateOfOperation().getText().isEmpty()) {
			Factory.getInstance().addErrorMessage("The Date of Operation can't be empty!");
			return;
		}
		save(stage, selSlipNum);
	}

	private void save(String stage, final String selSlipNum) {
		QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.OTSLTSLIP_TXCODE,
				QueryUtil.ACTION_MODIFY,
				new String[] {
					getPatNo().getText(),
					getPatType().getText(),
					getDateOfOperation().getText(),
					preSlipNum,
					selSlipNum,
					lOTA_Id,
					stage,
					getMainFrame().getUserInfo().getUserID()},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					String sCurSlipNum = mQueue.getReturnMsg();
					oTLogBook.getSlipNo().setEditable(false);
					oTLogBook.getSlipNo().setText(sCurSlipNum);
					//oTLogBook.getDateOfOper().setText(getDateOfOperation().getText() + " 00:00");
					oTLogBook.getDateOfOper().setText(getDateOfOperation().getText());
					oTLogBook.getPatType().setSelectedIndex(getPatType().getSelectedIndex());
					oTLogBook.getSlipNo().setEditable(true);

					closeAction(true, true);
					oTLogBook.saveAction();
				} else if ("-100".equals(mQueue.getReturnCode())) {
					Factory.getInstance().addInformationMessage(mQueue.getReturnMsg());
				} else if ("-200".equals(mQueue.getReturnCode())) {
					getDlgOTSltSlipDisplayTable().setListTableContent(
							ConstantsTx.OTSLTSLIPSEARCH_TXCODE,
							new String[]{getPatNo().getText(),
									getPatType().getText(),
									getDateOfOperation().getText()});
					getDlgOTSltSlipDisplayDialog().show();
				} else if ("-300".equals(mQueue.getReturnCode())) {
					String sCurSlipNum = mQueue.getReturnMsg();

					String sMsg = "<br /><br /><br />1.Previous slip number: " + preSlipNum + "<br />" +
						"2.Previous Patient Type: " + sPreTyp + "<br />" +
						"3.New slip number: " + sCurSlipNum + "<br />" +
						"4.New Patient type: " + getPatType().getDisplayText() + "<br />" +
						"<br />" +
						" Please inform PBO the changes!";

					Factory.getInstance().addInformationMessage(sMsg,
							new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							save("1", selSlipNum);
						}
					});
				}
			}

		});
	}

	private void closeAction(boolean otsltslip, boolean otsltslipDisplay) {
		if (otsltslip) {
			hide();
			getDlgOTSltSlipDisplayDialog().hide();
		} else {
			if (otsltslipDisplay) {
				getDlgOTSltSlipDisplayDialog().hide();
			}
		}
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getSaveSlipNoPanel() {
		if (calRefItemPanel == null) {
			calRefItemPanel = new BasePanel();
			calRefItemPanel.setBounds(5, 5, 350, 240);
			calRefItemPanel.add(getPatNoDesc(),null);
			calRefItemPanel.add(getPatNo(),null);
			calRefItemPanel.add(getDateOfOperationDesc(),null);
			calRefItemPanel.add(getDateOfOperation(),null);
			calRefItemPanel.add(getPatTypeDesc(),null);
			calRefItemPanel.add(getPatType(),null);
		}
		return calRefItemPanel;
	}

	public LabelBase getPatNoDesc() {
		if (patNoDesc == null) {
			patNoDesc = new LabelBase();
			patNoDesc.setBounds(20, 10, 150, 20);
			patNoDesc.setText("Patient No");
		}
		return patNoDesc;
	}

	public TextString getPatNo() {
		if (patNo == null) {
			patNo = new TextString(10);
			patNo.setBounds(160, 10, 120, 20);
		}
		return patNo;
	}

	public LabelBase getDateOfOperationDesc() {
		if (dateOfOperationDesc == null) {
			dateOfOperationDesc = new LabelBase();
			dateOfOperationDesc.setBounds(20, 50, 150, 20);
			dateOfOperationDesc.setText("Date of Operation");
		}
		return dateOfOperationDesc;
	}

	public TextDate getDateOfOperation() {
		if (dateOfOperation == null) {
			dateOfOperation = new TextDate();
			dateOfOperation.setBounds(160, 50, 120, 20);
		}
		return dateOfOperation;
	}

	public LabelBase getPatTypeDesc() {
		if (patTypeDesc == null) {
			patTypeDesc = new LabelBase();
			patTypeDesc.setBounds(20, 90, 150, 20);
			patTypeDesc.setText("Patient Type");
		}
		return patTypeDesc;
	}

	public ComboPatientType getPatType() {
		if (patType == null) {
			patType = new ComboPatientType();
			patType.setBounds(160, 90, 120, 20);
		}
		return patType;
	}

	private DialogBase getDlgOTSltSlipDisplayDialog() {
		if (dlgOTSltSlipDisplayDialog == null) {
			dlgOTSltSlipDisplayDialog = new DialogBase(getMainFrame(),
					Dialog.OKCANCEL, 550, 245) {
				@Override
				public void doOkAction() {
					int idx = getDlgOTSltSlipDisplayTable().getSelectedRow();
					if (getDlgOTSltSlipDisplayTable().getSelectedRow() < 0) {
						Factory.getInstance().addErrorMessage("Please select a slip number.");
					} else {
						closeAction(false, true);
						saveAction("2", getDlgOTSltSlipDisplayTable().getRowContent(idx)[0]);
					}
				}

				@Override
				public void onClose() {
					closeAction(true, true);
				}
			};
			dlgOTSltSlipDisplayDialog.setTitle("PBA - Display Slip Number");
			dlgOTSltSlipDisplayDialog.add(getDlgOTSltSlipDisplayPanel());
		}
		return dlgOTSltSlipDisplayDialog;
	}

	private JScrollPane getDlgOTSltSlipDisplayPanel() {
		if (dlgOTSltSlipDisplayPanel == null) {
			dlgOTSltSlipDisplayPanel = new JScrollPane();
			dlgOTSltSlipDisplayPanel.setViewportView(getDlgOTSltSlipDisplayTable());
			dlgOTSltSlipDisplayPanel.setSize(515, 160);
		}
		return dlgOTSltSlipDisplayPanel;
	}

	private TableList getDlgOTSltSlipDisplayTable() {
		if (dlgOTSltSlipDisplayTable == null) {
			dlgOTSltSlipDisplayTable = new TableList(getDlgOTSltSlipDisplayTableColumnNames(),
												getDlgOTSltSlipDisplayTableColumnWidths());
			dlgOTSltSlipDisplayTable.setTableLength(430);
		}
		return dlgOTSltSlipDisplayTable;
	}

	protected String[] getDlgOTSltSlipDisplayTableColumnNames() {
		return new String[] {
				"Slip number",
				"Registration date time",
				"Discharge date time",
				"Doctor name"
		};
	}

	protected int[] getDlgOTSltSlipDisplayTableColumnWidths() {
		return new int[] {80, 120, 120, 180};
	}
}