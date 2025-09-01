package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.widget.form.RadioGroup;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.radiobutton.RadioButtonBase;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public abstract class DlgChgRptLvl extends DialogBase {

	private final static int m_frameWidth = 520;
	private final static int m_frameHeight = 480;

	private BasePanel rlvlPanel = null;
	private FieldSetBase rlvlModePanel = null;
	private LabelBase rlvlSlpnoDesc = null;
	private TextReadOnly rlvlSlpno = null;
	private LabelBase rlvlSeqnoDesc = null;
	private TextReadOnly rlvlSeqno = null;
	private LabelBase rlvlItmCodeDesc = null;
	private TextReadOnly rlvlItmCode = null;
	private LabelBase rlvlDescDesc = null;
	private TextReadOnly rlvlDesc = null;
	private LabelBase rlvlSvCodeDesc = null;
	private TextReadOnly rlvlSvCode = null;
	private LabelBase rlvlStsDesc = null;
	private TextReadOnly rlvlSts = null;
	private LabelBase rlvlOrlvlDesc = null;
	private TextReadOnly rlvlOrlvl = null;
	private LabelBase rlvlNrlvlDesc = null;
	private TextString rlvlNrlvl = null;
	private LabelBase rlvlClsDesc = null;
	private RadioButtonBase rlvlCurrentItem = null;
	private RadioButtonBase rlvlSameItem = null;
	private RadioButtonBase rlvlSamePkg = null;
	private RadioButtonBase rlvlSameDptSv = null;
	private RadioButtonBase rlvlSameDpt = null;

	private String itmCode = null;
	private String pkg = null;
	private String dept = null;

	public DlgChgRptLvl(MainFrame owner) {
		super(owner, DialogBase.OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
    	setTitle("Change Report Level");
    	setContentPane(getRlvlPanel());
    	setLocation(200, 100);
	}

	/***************************************************************************
	 * Abstract Method
	 **************************************************************************/

	public abstract void post();

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String slpNo, String seqNo, String itmCode, String description, String serviceCode,
			String status, String originalLevel, String pItmCode, String pkgCode, String dpt) {
		getRlvlSlpno().setText(slpNo);
		getRlvlSeqno().setText(seqNo);
		getRlvlItmCode().setText(itmCode);
		getRlvlDesc().setText(description);
		getRlvlSvCode().setText(serviceCode);
		getRlvlSts().setText(getStatusDescription(status));
		getRlvlOrlvl().setText(originalLevel);

		setPItmCode(pItmCode);	// drug item code
		setPackage(pkgCode);
		String rlvldpt = dpt;
		if (rlvldpt != null && rlvldpt.indexOf("-") > 0) {
			rlvldpt = rlvldpt.substring(0, 4);
		}
		setDepartment(rlvldpt);

		// default value
		getRlvlNrlvl().resetText();
		getRlvlCurrentItem().setSelected(true);

		setVisible(true);
	}

	@Override
	public TextString getDefaultFocusComponent() {
		return getRlvlNrlvl();
	}

	@Override
	protected void doOkAction() {
		int level = 0;
		
		try {
			level = Integer.valueOf(getRlvlNrlvl().getText().trim());
		}
		catch (Exception e) {
		}

		if (getRlvlNrlvl().isEmpty() || !TextUtil.isNumber(getRlvlNrlvl().getText().trim())) {
			Factory.getInstance().addErrorMessage("Report level should be numeric.", "PBA-[Change Report Level]", getRlvlNrlvl());
			return;
		} else if (level < 1 || level > 7) {
			Factory.getInstance().addErrorMessage("Report level should be between 1 and 7.", "PBA-[Change Report Level]", getRlvlNrlvl());
			return;
		} else if (level == 5) {
			if (getPItmCode() != null && getPItmCode().length() > 0) {
				if (!getRlvlItmCode().getText().equals(getPItmCode())) {
					Factory.getInstance().addErrorMessage("This is not a drug code.", "PBA-[Change Report Level]", getRlvlNrlvl());
					return;
				}
			} else {
				Factory.getInstance().addErrorMessage("System error.", "PBA-[Change Report Level]", getRlvlNrlvl());
				return;
			}
		} else if ((level == 4 || level == 7) && (getPackage() == null || getPackage().length() == 0)) {
			Factory.getInstance().addErrorMessage("Package Code is Empty.", "PBA-[Change Report Level]", getRlvlNrlvl());
			return;
		}

		String opt = "";
		if (getRlvlCurrentItem().isSelected()) {
			 opt = "0";
		} else if (getRlvlSameItem().isSelected()) {
			opt = "1";
		} else if (getRlvlSamePkg().isSelected()) {
			opt = "2";
		} else if (getRlvlSameDptSv().isSelected()) {
			opt = "3";
		} else if (getRlvlSameDpt().isSelected()) {
			opt = "4";
		}

		QueryUtil.executeMasterAction(getUserInfo(), "CHGRPTLVL", QueryUtil.ACTION_MODIFY,
				new String[] {getRlvlSlpno().getText(),
					getRlvlSeqno().getText(),
					getRlvlItmCode().getText(),
					getRlvlNrlvl().getText().trim(),
					getPackage(),
					getDepartment(),
					getRlvlSvCode().getText(),
					opt
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				Factory.getInstance().addInformationMessage("Update Report Level success.", "PBA-[Change Report Level]");
				dispose();
				post();
			}

			public void onFailure(Throwable caught) {
				Factory.getInstance().addErrorMessage("Update Report Level Fail.", "PBA-[Change Report Level]");
				dispose();
			}
		});
	}

	public void setPItmCode(String value) {
		itmCode = value;
	}

	public String getPItmCode() {
		return itmCode;
	}

	public void setPackage(String value) {
		pkg = value;
	}

	public String getPackage() {
		return pkg;
	}

	public void setDepartment(String value) {
		dept = value;
	}

	public String getDepartment() {
		return dept;
	}

	private String getStatusDescription(String status) {
		if ("C".equals(status)) {
			return "System Cancel";
		} else if ("U".equals(status)) {
			return "User Cancel";
		} else if ("N".equals(status)) {
			return "Normal";
		} else if ("T".equals(status)) {
			return "Transfer";
		} else if ("R".equals(status)) {
			return "Reverse";
		} else if ("A".equals(status)) {
			return "Adjust";
		} else {
			return "N/A";
		}
	}
	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getRlvlPanel() {
		if (rlvlPanel == null) {
			rlvlPanel = new BasePanel();
			rlvlPanel.setBounds(5, 5, 500, 420);
			rlvlPanel.add(getRlvlModePanel(), null);
			rlvlPanel.add(getRlvlSlpnoDesc(), null);
			rlvlPanel.add(getRlvlSlpno(), null);
			rlvlPanel.add(getRlvlSeqnoDesc(), null);
			rlvlPanel.add(getRlvlSeqno(), null);
			rlvlPanel.add(getRlvlItmCodeDesc(), null);
			rlvlPanel.add(getRlvlItmCode(), null);
			rlvlPanel.add(getRlvlDescDesc(), null);
			rlvlPanel.add(getRlvlDesc(), null);
			rlvlPanel.add(getRlvlSvCodeDesc(), null);
			rlvlPanel.add(getRlvlSvCode(), null);
			rlvlPanel.add(getRlvlStsDesc(), null);
			rlvlPanel.add(getRlvlSts(), null);
			rlvlPanel.add(getRlvlOrlvlDesc(), null);
			rlvlPanel.add(getRlvlOrlvl(), null);
			rlvlPanel.add(getRlvlNrlvlDesc(), null);
			rlvlPanel.add(getRlvlNrlvl(), null);
			rlvlPanel.add(getRlvlClsDesc(), null);
		}
		return rlvlPanel;
	}

	public FieldSetBase getRlvlModePanel() {
		if (rlvlModePanel == null) {
			rlvlModePanel = new FieldSetBase();
			rlvlModePanel.setHeading("Mode");
			rlvlModePanel.setBounds(0, 230, 480, 160);
			rlvlModePanel.add(getRlvlCurrentItem(), null);
			rlvlModePanel.add(getRlvlSameItem(), null);
			rlvlModePanel.add(getRlvlSamePkg(), null);
			rlvlModePanel.add(getRlvlSameDptSv(), null);
			rlvlModePanel.add(getRlvlSameDpt(), null);
			RadioGroup btngrp = new RadioGroup();
			btngrp.add(getRlvlCurrentItem());
			btngrp.add(getRlvlSameItem());
			btngrp.add(getRlvlSamePkg());
			btngrp.add(getRlvlSameDptSv());
			btngrp.add(getRlvlSameDpt());
		}
		return rlvlModePanel;
	}

	public LabelBase getRlvlSlpnoDesc() {
		if (rlvlSlpnoDesc == null) {
			rlvlSlpnoDesc = new LabelBase();
			rlvlSlpnoDesc.setText("Slip No");
			rlvlSlpnoDesc.setBounds(5, 5, 100, 20);
		}
		return rlvlSlpnoDesc;
	}

	public TextReadOnly getRlvlSlpno() {
		if (rlvlSlpno == null) {
			rlvlSlpno = new TextReadOnly();
			rlvlSlpno.setBounds(110, 5, 120, 20);
		}
		return rlvlSlpno;
	}

	public LabelBase getRlvlSeqnoDesc() {
		if (rlvlSeqnoDesc == null) {
			rlvlSeqnoDesc = new LabelBase();
			rlvlSeqnoDesc.setText("Seq No");
			rlvlSeqnoDesc.setBounds(5, 30, 100, 20);
		}
		return rlvlSeqnoDesc;
	}

	public TextReadOnly getRlvlSeqno() {
		if (rlvlSeqno == null) {
			rlvlSeqno = new TextReadOnly();
			rlvlSeqno.setBounds(110, 30, 80, 20);
		}
		return rlvlSeqno;
	}

	public LabelBase getRlvlItmCodeDesc() {
		if (rlvlItmCodeDesc == null) {
			rlvlItmCodeDesc = new LabelBase();
			rlvlItmCodeDesc.setText("Item code");
			rlvlItmCodeDesc.setBounds(5, 55, 100, 20);
		}
		return rlvlItmCodeDesc;
	}

	public TextReadOnly getRlvlItmCode() {
		if (rlvlItmCode == null) {
			rlvlItmCode = new TextReadOnly();
			rlvlItmCode.setBounds(110, 55, 80, 20);
		}
		return rlvlItmCode;
	}

	public LabelBase getRlvlDescDesc() {
		if (rlvlDescDesc == null) {
			rlvlDescDesc = new LabelBase();
			rlvlDescDesc.setText("Description");
			rlvlDescDesc.setBounds(5, 80, 100, 20);
		}
		return rlvlDescDesc;
	}

	public TextReadOnly getRlvlDesc() {
		if (rlvlDesc == null) {
			rlvlDesc = new TextReadOnly();
			rlvlDesc.setBounds(110, 80, 250, 20);
		}
		return rlvlDesc;
	}

	public LabelBase getRlvlSvCodeDesc() {
		if (rlvlSvCodeDesc == null) {
			rlvlSvCodeDesc = new LabelBase();
			rlvlSvCodeDesc.setText("Service Code");
			rlvlSvCodeDesc.setBounds(5, 105, 100, 20);
		}
		return rlvlSvCodeDesc;
	}

	public TextReadOnly getRlvlSvCode() {
		if (rlvlSvCode == null) {
			rlvlSvCode = new TextReadOnly();
			rlvlSvCode.setBounds(110, 105, 80, 20);
		}
		return rlvlSvCode;
	}

	public LabelBase getRlvlStsDesc() {
		if (rlvlStsDesc == null) {
			rlvlStsDesc = new LabelBase();
			rlvlStsDesc.setText("Status");
			rlvlStsDesc.setBounds(5, 130, 100, 20);
		}
		return rlvlStsDesc;
	}

	public TextReadOnly getRlvlSts() {
		if (rlvlSts == null) {
			rlvlSts = new TextReadOnly();
			rlvlSts.setBounds(110, 130, 80, 20);
		}
		return rlvlSts;
	}

	public LabelBase getRlvlOrlvlDesc() {
		if (rlvlOrlvlDesc == null) {
			rlvlOrlvlDesc = new LabelBase();
			rlvlOrlvlDesc.setText("Old Report Level");
			rlvlOrlvlDesc.setBounds(5, 155, 100, 20);
		}
		return rlvlOrlvlDesc;
	}

	public TextReadOnly getRlvlOrlvl() {
		if (rlvlOrlvl == null) {
			rlvlOrlvl = new TextReadOnly();
			rlvlOrlvl.setBounds(110, 155, 80, 20);
		}
		return rlvlOrlvl;
	}

	public LabelBase getRlvlNrlvlDesc() {
		if (rlvlNrlvlDesc == null) {
			rlvlNrlvlDesc = new LabelBase();
			rlvlNrlvlDesc.setText("New Report Level");
			rlvlNrlvlDesc.setBounds(5, 180, 120, 20);
		}
		return rlvlNrlvlDesc;
	}

	public TextString getRlvlNrlvl() {
		if (rlvlNrlvl == null) {
			rlvlNrlvl = new TextString(1);
			rlvlNrlvl.setBounds(110, 180, 80, 20);
		}
		return rlvlNrlvl;
	}

	public LabelBase getRlvlClsDesc() {
		if (rlvlClsDesc == null) {
			rlvlClsDesc = new LabelBase();
			String txt = "<html>Report Level:<br>"
					  +"1=Department Service Description<br>"
					  +"2=Department Description<br>"
					  +"3=Item Description<br>"
					  +"4=Package Name(one line)<br>"
					  +"5=Drug Name Details<br>"
					  +"6=Department Service Description&Item Description<br>"
					  +"7=Package Name(multi sections)<br>"
					  +"</html>";
			rlvlClsDesc.setText(txt);
			rlvlClsDesc.setBounds(195, 110, 300, 130);
		}
		return rlvlClsDesc;
	}

	public RadioButtonBase getRlvlCurrentItem() {
		if (rlvlCurrentItem == null) {
			rlvlCurrentItem = new RadioButtonBase();
			rlvlCurrentItem.setText("Current Item");
			rlvlCurrentItem.setBounds(80, 0, 180, 20);
		}
		return rlvlCurrentItem;
	}

	public RadioButtonBase getRlvlSameItem() {
		if (rlvlSameItem == null) {
			rlvlSameItem = new RadioButtonBase();
			rlvlSameItem.setText("Same Item");
			rlvlSameItem.setBounds(80, 25, 180, 20);
		}
		return rlvlSameItem;
	}

	public RadioButtonBase getRlvlSamePkg() {
		if (rlvlSamePkg == null) {
			rlvlSamePkg = new RadioButtonBase();
			rlvlSamePkg.setText("Same Package");
			rlvlSamePkg.setBounds(80, 50, 180, 20);
		}
		return rlvlSamePkg;
	}

	public RadioButtonBase getRlvlSameDptSv() {
		if (rlvlSameDptSv == null) {
			rlvlSameDptSv = new RadioButtonBase();
			rlvlSameDptSv.setText("Same Department Service");
			rlvlSameDptSv.setBounds(80, 75, 180, 20);
		}
		return rlvlSameDptSv;
	}

	public RadioButtonBase getRlvlSameDpt() {
		if (rlvlSameDpt == null) {
			rlvlSameDpt = new RadioButtonBase();
			rlvlSameDpt.setText("Same Department");
			rlvlSameDpt.setBounds(80, 100, 180, 20);
		}
		return rlvlSameDpt;
	}
}