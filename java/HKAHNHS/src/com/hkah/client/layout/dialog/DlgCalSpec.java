package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboDept;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextItemCodeSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgCalSpec extends DialogBase {
	private final static int m_frameWidth = 480;
	private final static int m_frameHeight = 280;

	private BasePanel calSpecPanel = null;
	private LabelBase calSpecDptDesc = null;
	private ComboDept calSpecDpt = null;
	private LabelBase calSpecItmCodeDesc = null;
	private TextItemCodeSearch calSpecItmCode = null;
	private LabelBase calSpecItmTypeDesc = null;
	private CheckBoxBase calSpecHos = null;
	private LabelBase calSpecHosDesc = null;
	private CheckBoxBase calSpecDoc = null;
	private LabelBase calSpecDocDesc = null;
	private CheckBoxBase calSpecSpe = null;
	private LabelBase calSpecSpeDesc = null;
	private CheckBoxBase calSpecOth = null;
	private LabelBase calSpecOthDesc = null;
	private LabelBase calSpecDateFromDesc = null;
	private TextDate calSpecDateFrom = null;
	private LabelBase calSpecDateToDesc = null;
	private TextDate calSpecDateTo = null;
	private LabelBase calSpecnamtDesc = null;
	private TextReadOnly calSpecnamt = null;

	private String memRegDate = "";
	private String memSLPNO = "";

	public DlgCalSpec(MainFrame owner) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
    	initialize();
    }

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Calculate Spec");
		setContentPane(getCalSpecPanel());

		// change label
		getButtonById(OK).setText("Calculate", 'C');
	}

	public ComboDept getDefaultFocusComponent() {
		return getCalSpecDpt();
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String slpNo, String regDate) {
		memSLPNO = slpNo;
		memRegDate = regDate;

		getCalSpecDpt().clear();
		getCalSpecItmCode().clear();
		getCalSpecHos().setSelected(false);
		getCalSpecDoc().setSelected(false);
		getCalSpecSpe().setSelected(false);
		getCalSpecOth().setSelected(false);
		getCalSpecnamt().resetText();
		setVisible(true);

		if (memRegDate == null||memRegDate.trim().length()==0) {
			getCalSpecDateFrom().setText(getMainFrame().getServerDate());
		} else {
			if (memRegDate.length()>10) {
				getCalSpecDateFrom().setText(memRegDate.substring(0,10));

			} else {
				getCalSpecDateFrom().setText(memRegDate);
			}
		}
		getCalSpecDateTo().setText(getMainFrame().getServerDate());
	}

	public void calc() {
		if (getCalSpecDateFrom().isEmpty() || !getCalSpecDateFrom().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid From date format.", "PBA-[Calculate Spec]", getCalSpecDateFrom());
			return;
		} else if (getCalSpecDateTo().isEmpty() || !getCalSpecDateTo().isValid()) {
			Factory.getInstance().addErrorMessage("Invalid To date format.", "PBA-[Calculate Spec]", getCalSpecDateTo());
			return;
		} else if (DateTimeUtil.dateDiff(getCalSpecDateTo().getText(), getCalSpecDateFrom().getText())<0) {
			Factory.getInstance().addErrorMessage("To date should not be earlier then from date", "PBA-[Calculate Spec]", getCalSpecDateTo());
			return;
		}

		String itmCode = getCalSpecItmCode().getText().trim();
		if (itmCode != null && !itmCode.isEmpty()) {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {"Item", "ItmCode","ItmCode='" + itmCode.trim() + "'"},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						postCalc(mQueue.getContentField()[0]);
					} else {
						getCalSpecnamt().resetText();
						Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_ITEM_CODE, "PBA-[Calculate Spec]", getCalSpecItmCode());
					}
				}
			});
		} else {
			postCalc(null);
		}
	}

	private void postCalc(String itmCode) {
		QueryUtil.executeMasterFetch(
				getUserInfo(), "CALSPECAMT",
				new String[] {
					memSLPNO,
					memRegDate,
					getCalSpecDpt().getText().trim(),
					itmCode,
					getCalSpecHos().isSelected()?"H":"",
					getCalSpecDoc().isSelected()?"D":"",
					getCalSpecSpe().isSelected()?"S":"",
					getCalSpecOth().isSelected()?"O":"",
					getCalSpecDateFrom().getText(),
					getCalSpecDateTo().getText()},
				new MessageQueueCallBack() {
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							getCalSpecnamt().setText(mQueue.getContentField()[0]);
						}
					}
				});
	}

	/***************************************************************************
	 * @Override Method
	 **************************************************************************/

	@Override
	protected void doOkAction() {
		calc();
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getCalSpecPanel() {
		if (calSpecPanel == null) {
			calSpecPanel = new BasePanel();
			calSpecPanel.setBounds(5, 5, 440, 250);
			calSpecPanel.add(getCalSpecDptDesc(),null);
			calSpecPanel.add(getCalSpecDpt(),null);
			calSpecPanel.add(getCalSpecItmCodeDesc(),null);
			calSpecPanel.add(getCalSpecItmCode(),null);
			calSpecPanel.add(getCalSpecItmTypeDesc(),null);
			calSpecPanel.add(getCalSpecHos(),null);
			calSpecPanel.add(getCalSpecHosDesc(),null);
			calSpecPanel.add(getCalSpecDoc(),null);
			calSpecPanel.add(getCalSpecDocDesc(),null);
			calSpecPanel.add(getCalSpecSpe(),null);
			calSpecPanel.add(getCalSpecSpeDesc(),null);
			calSpecPanel.add(getCalSpecOth(),null);
			calSpecPanel.add(getCalSpecOthDesc(),null);
			calSpecPanel.add(getCalSpecDateFromDesc(),null);
			calSpecPanel.add(getCalSpecDateFrom(),null);
			calSpecPanel.add(getCalSpecDateToDesc(),null);
			calSpecPanel.add(getCalSpecDateTo(),null);
			calSpecPanel.add(getCalSpecnamtDesc(),null);
			calSpecPanel.add(getCalSpecnamt(),null);
		}
		return calSpecPanel;
	}

	public LabelBase getCalSpecDptDesc() {
		if (calSpecDptDesc == null) {
			calSpecDptDesc = new LabelBase();
			calSpecDptDesc.setText("Department");
			calSpecDptDesc.setBounds(50, 5, 80, 20);
		}
		return calSpecDptDesc;
	}

	public ComboDept getCalSpecDpt() {
		if (calSpecDpt == null) {
			calSpecDpt = new ComboDept(false, "NAME");
			calSpecDpt.setBounds(160, 5, 180, 20);
		}
		return calSpecDpt;
	}

	public LabelBase getCalSpecItmCodeDesc() {
		if (calSpecItmCodeDesc == null) {
			calSpecItmCodeDesc = new LabelBase();
			calSpecItmCodeDesc.setText("Item Code");
			calSpecItmCodeDesc.setBounds(50, 30, 80, 20);
		}
		return calSpecItmCodeDesc;
	}

	public TextItemCodeSearch getCalSpecItmCode() {
		if (calSpecItmCode == null) {
			calSpecItmCode = new TextItemCodeSearch() {
				public void onBlur() {
					calSpecItmCode.setText(calSpecItmCode.getText().toUpperCase());
				}
			};
			calSpecItmCode.setBounds(160,30, 180, 20);
		}
		return calSpecItmCode;
	}

	public LabelBase getCalSpecItmTypeDesc() {
		if (calSpecItmTypeDesc == null) {
			calSpecItmTypeDesc = new LabelBase();
			calSpecItmTypeDesc.setText("Item Type");
			calSpecItmTypeDesc.setBounds(50, 55, 80, 20);
		}
		return calSpecItmTypeDesc;
	}

	public CheckBoxBase getCalSpecHos() {
		if (calSpecHos == null) {
			calSpecHos = new CheckBoxBase();
			calSpecHos.setBounds(160, 55, 20, 20);
		}
		return calSpecHos;
	}

	public LabelBase getCalSpecHosDesc() {
		if (calSpecHosDesc == null) {
			calSpecHosDesc = new LabelBase();
			calSpecHosDesc.setText("Hospital");
			calSpecHosDesc.setBounds(180, 55, 50, 20);
		}
		return calSpecHosDesc;
	}

	public CheckBoxBase getCalSpecDoc() {
		if (calSpecDoc == null) {
			calSpecDoc = new CheckBoxBase();
			calSpecDoc.setBounds(240, 55, 20, 20);
		}
		return calSpecDoc;
	}

	public LabelBase getCalSpecDocDesc() {
		if (calSpecDocDesc == null) {
			calSpecDocDesc = new LabelBase();
			calSpecDocDesc.setText("Doctor");
			calSpecDocDesc.setBounds(260, 55, 50, 20);
		}
		return calSpecDocDesc;
	}

	public CheckBoxBase getCalSpecSpe() {
		if (calSpecSpe == null) {
			calSpecSpe = new CheckBoxBase();
			calSpecSpe.setBounds(160, 80, 20, 20);
			calSpecSpe.setSelected(true);
		}
		return calSpecSpe;
	}

	public LabelBase getCalSpecSpeDesc() {
		if (calSpecSpeDesc == null) {
			calSpecSpeDesc = new LabelBase();
			calSpecSpeDesc.setText("Special");
			calSpecSpeDesc.setBounds(180, 80, 50, 20);
		}
		return calSpecSpeDesc;
	}

	public CheckBoxBase getCalSpecOth() {
		if (calSpecOth == null) {
			calSpecOth = new CheckBoxBase();
			calSpecOth.setBounds(240, 80, 20, 20);
		}
		return calSpecOth;
	}

	public LabelBase getCalSpecOthDesc() {
		if (calSpecOthDesc == null) {
			calSpecOthDesc = new LabelBase();
			calSpecOthDesc.setText("Other");
			calSpecOthDesc.setBounds(260, 80, 50, 20);
		}
		return calSpecOthDesc;
	}

	public LabelBase getCalSpecDateFromDesc() {
		if (calSpecDateFromDesc == null) {
			calSpecDateFromDesc = new LabelBase();
			calSpecDateFromDesc.setText("From");
			calSpecDateFromDesc.setBounds(50, 105, 80, 20);
		}
		return calSpecDateFromDesc;
	}

	public TextDate getCalSpecDateFrom() {
		if (calSpecDateFrom == null) {
			calSpecDateFrom = new TextDate();
			calSpecDateFrom.setBounds(160,105, 120, 20);
		}
		return calSpecDateFrom;
	}

	public LabelBase getCalSpecDateToDesc() {
		if (calSpecDateToDesc == null) {
			calSpecDateToDesc = new LabelBase();
			calSpecDateToDesc.setText("To");
			calSpecDateToDesc.setBounds(50, 130, 80, 20);
		}
		return calSpecDateToDesc;
	}

	public TextDate getCalSpecDateTo() {
		if (calSpecDateTo == null) {
			calSpecDateTo = new TextDate();
			calSpecDateTo.setBounds(160,130, 120, 20);
		}
		return calSpecDateTo;
	}

	public LabelBase getCalSpecnamtDesc() {
		if (calSpecnamtDesc == null) {
			calSpecnamtDesc = new LabelBase();
			calSpecnamtDesc.setText("Item Charge Net Amount");
			calSpecnamtDesc.setBounds(5, 155, 160, 20);
		}
		return calSpecnamtDesc;
	}

	public TextReadOnly getCalSpecnamt() {
		if (calSpecnamt == null) {
			calSpecnamt = new TextReadOnly();
			calSpecnamt.setBounds(160,155, 180, 20);
		}
		return calSpecnamt;
	}
}