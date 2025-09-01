package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.layout.AbsoluteLayout;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextRemark;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgInstruction extends DialogBase {

    private final static int m_frameWidth = 600;
    private final static int m_frameHeight = 655;

	private BasePanel InstructPanel = null;
	private BasePanel InsParaPanel = null;
	private LabelBase InsDocCodeDesc = null;
	private TextReadOnly InsDocCode = null;
	private TextReadOnly InsDocName = null;
	private LabelBase CheckDateDesc = null;
	private TextDate CheckDate = null;
	private LabelBase dateDesc = null;
	private LabelBase NoAdmDesc = null;
	private TextReadOnly NoAdm = null;
	private LabelBase DCRmkDesc = null;
	private TextRemark DCRmk = null;
	private LabelBase InpatRmkDesc = null;
	private TextRemark InpatRmk = null;
	private LabelBase OutpatRmkDesc = null;
	private TextRemark OutpatRmk = null;
	private LabelBase PaymentRmkDesc = null;
	private TextRemark PaymentRmk = null;
	private LabelBase SMDRmkDesc = null;
	private TextRemark SMDRmk = null;

	private String memDocCode = null;

	public DlgInstruction(MainFrame owner) {
		super(owner, Dialog.OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	private void initialize() {
		setTitle("Instruction");
		setLayout(new AbsoluteLayout());
		add(getInstructPanel(), null);

		// change label
		getButtonById(OK).setText("Save");
		setVisible(false);
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String docCode, String docName, boolean isEnable) {
		getCheckDate().resetText();
		getNoAdm().resetText();
		getDCRmk().resetText();
		getInpatRmk().resetText();
		getOutpatRmk().resetText();
		getPaymentRmk().resetText();
		getSMDRmk().resetText();
		
		memDocCode = docCode;
		getInsDocCode().setText(memDocCode);
		getInsDocName().setText(docName);
		getDCRmk().setEditable(isEnable, true);
		getInpatRmk().setEditable(isEnable, true);
		getOutpatRmk().setEditable(isEnable, true);
		getPaymentRmk().setEditable(isEnable, true);
		getSMDRmk().setEditable(isEnable, true);
		getButtonById(OK).setEnabled(isEnable);

		QueryUtil.executeMasterBrowse(
				getUserInfo(), "DOCTOR_INSTRUCTION", new String[] { memDocCode },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					String[] temp = mQueue.getContentField();
					getDCRmk().setText(temp[2]);
					getInpatRmk().setText(temp[3]);
					getOutpatRmk().setText(temp[4]);
					getPaymentRmk().setText(temp[5]);
					getSMDRmk().setText(temp[6]);
					setVisible(true);
				}
			}
		});
	}

	@Override
	public TextDate getDefaultFocusComponent() {
		return getCheckDate();
	}

	@Override
	protected void doOkAction() {
		QueryUtil.executeMasterAction(
				getUserInfo(), ConstantsTx.DOCINSTRUCTION_TXCODE, QueryUtil.ACTION_MODIFY,
				new String[] { memDocCode, getDCRmk().getText(), getInpatRmk().getText(), getOutpatRmk().getText(), getPaymentRmk().getText(),getSMDRmk().getText()},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					Factory.getInstance().addInformationMessage("Record is Saved sucessfully.");
					dispose();
				}
			}
		});
	}

	@Override
	protected void doCancelAction() {
		post(null, null, null, null, null, null, null);
	}

	protected void post(String actionType, String strPayee, String strAdd1, String strAdd2, String strAdd3,
			String strCountry, String strReason) {
		dispose();
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getInstructPanel() {
		if (InstructPanel == null) {
			InstructPanel = new BasePanel();
			InstructPanel.add(getInsParaPanel(), null);
			InstructPanel.add(getDCRmkDesc(), null);
			InstructPanel.add(getDCRmk(), null);
			InstructPanel.add(getInpatRmkDesc(), null);
			InstructPanel.add(getInpatRmk(), null);
			InstructPanel.add(getOutpatRmkDesc(), null);
			InstructPanel.add(getOutpatRmk(), null);
			InstructPanel.add(getPaymentRmkDesc(), null);
			InstructPanel.add(getPaymentRmk(), null);
			InstructPanel.add(getSMDRmkDesc(), null);
			InstructPanel.add(getSMDRmk(), null);
			InstructPanel.setBounds(0, 0, 596, 538);
		}
		return InstructPanel;
	}

	public BasePanel getInsParaPanel() {
		if (InsParaPanel == null) {
			InsParaPanel = new BasePanel();
			InsParaPanel.setBorders(true);
			InsParaPanel.add(getInsDocCodeDesc(), null);
			InsParaPanel.add(getInsDocCode(), null);
			InsParaPanel.add(getInsDocName(), null);
			InsParaPanel.add(getCheckDateDesc(), null);
			InsParaPanel.add(getCheckDate(), null);
			InsParaPanel.add(getDateDesc(), null);
			InsParaPanel.add(getNoAdmDesc(), null);
			InsParaPanel.add(getNoAdm(), null);
			InsParaPanel.setBounds(5, 5, 572, 90);
		}
		return InsParaPanel;
	}

	public LabelBase getInsDocCodeDesc() {
		if (InsDocCodeDesc == null) {
			InsDocCodeDesc = new LabelBase();
			InsDocCodeDesc.setText("Doctor Code:");
			InsDocCodeDesc.setBounds(10, 10, 100, 20);
		}
		return InsDocCodeDesc;
	}

	public TextReadOnly getInsDocCode() {
		if (InsDocCode == null) {
			InsDocCode = new TextReadOnly();
			InsDocCode.setBounds(128, 10, 99, 20);
		}
		return InsDocCode;
	}

	/**
	 * This method initializes InsDocName
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextReadOnly getInsDocName() {
		if (InsDocName == null) {
			InsDocName = new TextReadOnly();
			InsDocName.setBounds(228, 10, 332, 20);
		}
		return InsDocName;
	}

	public LabelBase getCheckDateDesc() {
		if (CheckDateDesc == null) {
			CheckDateDesc = new LabelBase();
			CheckDateDesc.setText("Check Date:");
			CheckDateDesc.setBounds(10, 35, 100, 20);
		}
		return CheckDateDesc;
	}

	public TextDate getCheckDate() {
		if (CheckDate == null) {
			CheckDate = new TextDate() {
				public void onBlur() {
					if (!CheckDate.isEmpty()) {
						if (CheckDate.isValid()) {
							QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
									new String[] {"REG", "count(1)", "regsts = 'N' and doccode = '" + memDocCode + "' and to_char(regdate,'dd/mm/yyyy') = '" + getCheckDate().getText() + "'"},
									new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(MessageQueue mQueue) {
									if (mQueue.success()) {
										getNoAdm().setText(mQueue.getContentField()[0]);
									} else {
										getNoAdm().setText(ZERO_VALUE);
									}
								}
							});
						} else {
							Factory.getInstance().addErrorMessage("Invalid Date", CheckDate);
							CheckDate.resetText();
						}
					}
				};
			};
			CheckDate.setBounds(128, 35, 120, 20);
		}
		return CheckDate;
	}

	public LabelBase getDateDesc() {
		if (dateDesc == null) {
			dateDesc = new LabelBase();
			dateDesc.setBounds(251, 35, 87, 17);
			dateDesc.setText("DD/MM/YYYY");
		}
		return dateDesc;
	}

	public LabelBase getNoAdmDesc() {
		if (NoAdmDesc == null) {
			NoAdmDesc = new LabelBase();
			NoAdmDesc.setText("No of Admission:");
			NoAdmDesc.setBounds(10, 60, 100, 20);
		}
		return NoAdmDesc;
	}

	public TextReadOnly getNoAdm() {
		if (NoAdm == null) {
			NoAdm = new TextReadOnly();
			NoAdm.setBounds(128, 60, 120, 20);
		}
		return NoAdm;
	}

	public LabelBase getDCRmkDesc() {
		if (DCRmkDesc == null) {
			DCRmkDesc = new LabelBase();
			DCRmkDesc.setText("Daycase Remark:");
			DCRmkDesc.setBounds(5, 110, 135, 20);
		}
		return DCRmkDesc;
	}

	public TextRemark getDCRmk() {
		if (DCRmk == null) {
			DCRmk = new TextRemark();
			DCRmk.setBounds(5, 130, 575, 66);
		}
		return DCRmk;
	}

	public LabelBase getInpatRmkDesc() {
		if (InpatRmkDesc == null) {
			InpatRmkDesc = new LabelBase();
			InpatRmkDesc.setText("Inpatient Remark:");
			InpatRmkDesc.setBounds(5, 210, 135, 20);
		}
		return InpatRmkDesc;
	}

	public TextRemark getInpatRmk() {
		if (InpatRmk == null) {
			InpatRmk = new TextRemark();
			InpatRmk.setBounds(5, 230, 575, 66);
		}
		return InpatRmk;
	}

	public LabelBase getOutpatRmkDesc() {
		if (OutpatRmkDesc == null) {
			OutpatRmkDesc = new LabelBase();
			OutpatRmkDesc.setText("Outpatient Remark:");
			OutpatRmkDesc.setBounds(5, 310, 135, 20);
		}
		return OutpatRmkDesc;
	}

	public TextRemark getOutpatRmk() {
		if (OutpatRmk == null) {
			OutpatRmk = new TextRemark();
			OutpatRmk.setBounds(5, 330, 575, 66);
		}
		return OutpatRmk;
	}

	public LabelBase getPaymentRmkDesc() {
		if (PaymentRmkDesc == null) {
			PaymentRmkDesc = new LabelBase();
			PaymentRmkDesc.setText("Payment Remark:");
			PaymentRmkDesc.setBounds(5, 410, 135, 20);
		}
		return PaymentRmkDesc;
	}

	public TextRemark getPaymentRmk() {
		if (PaymentRmk == null) {
			PaymentRmk = new TextRemark();
			PaymentRmk.setBounds(5, 430, 575, 66);
		}
		return PaymentRmk;
	}
	
	public LabelBase getSMDRmkDesc() {
		if (SMDRmkDesc == null) {
			SMDRmkDesc = new LabelBase();
			SMDRmkDesc.setText("Staff Medical Discount Remark:");
			SMDRmkDesc.setBounds(5, 496, 300, 20);
		}
		return SMDRmkDesc;
	}

	public TextRemark getSMDRmk() {
		if (SMDRmk == null) {
			SMDRmk = new TextRemark();
			SMDRmk.setBounds(5, 516, 575, 66);
		}
		return SMDRmk;
	}
}