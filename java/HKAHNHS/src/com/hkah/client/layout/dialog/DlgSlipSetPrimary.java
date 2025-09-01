package com.hkah.client.layout.dialog;

import java.util.List;

import com.hkah.client.MainFrame;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;

public abstract class DlgSlipSetPrimary extends DialogBase {

	private final static int m_frameWidth = 415;
	private final static int m_frameHeight = 150;

	private BasePanel UpdateSlipPanel = null;
	private BasePanel SelectPrimarySlipPanel = null;
	private LabelBase UpdateSlipPrimaryDesc = null;
	private ComboBoxBase UpdateSlipPrimary = null;

	public DlgSlipSetPrimary(MainFrame owner) {
		super(owner, DialogBase.OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Select Primary Slip");
		setContentPane(getUpdateSlipPanel());
		setLocation(320, 300);

		// change label
		getButtonById(OK).setText("Save", 'S');
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String slpNo, List<String> slpNoList) {
		setVisible(false);

		getUpdateSlipPrimary().removeAllItems();
		getUpdateSlipPrimary().addItem(slpNo);
		for (int i = 0; i < slpNoList.size(); i++) {
			getUpdateSlipPrimary().addItem(slpNoList.get(i));
		}
		getUpdateSlipPrimary().setSelectedIndex(0);

		setVisible(true);
	}

	@Override
	public ComboBoxBase getDefaultFocusComponent() {
		return getUpdateSlipPrimary();
	}

	@Override
	protected void doOkAction() {
		post(getUpdateSlipPrimary().getText());
	}

	public abstract void post(String slpno);

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	private BasePanel getUpdateSlipPanel() {
		if (UpdateSlipPanel == null) {
			UpdateSlipPanel = new BasePanel();
			UpdateSlipPanel.add(getSelectPrimarySlipPanel(), null);
			UpdateSlipPanel.setBounds(5, 5, 365, 205);
		}
		return UpdateSlipPanel;
	}

	private BasePanel getSelectPrimarySlipPanel() {
		if (SelectPrimarySlipPanel == null) {
			SelectPrimarySlipPanel = new BasePanel();
			SelectPrimarySlipPanel.add(getUpdateSlipPrimaryDesc(), null);
			SelectPrimarySlipPanel.add(getUpdateSlipPrimary(), null);
			SelectPrimarySlipPanel.setBounds(5, 5, 367, 92);
		}
		return SelectPrimarySlipPanel;
	}

	private LabelBase getUpdateSlipPrimaryDesc() {
		if (UpdateSlipPrimaryDesc == null) {
			UpdateSlipPrimaryDesc = new LabelBase();
			UpdateSlipPrimaryDesc.setBounds(27, 20, 75, 20);
			UpdateSlipPrimaryDesc.setText("Slip No.");
			UpdateSlipPrimaryDesc.setOptionalLabel();
		}
		return UpdateSlipPrimaryDesc;
	}

	private ComboBoxBase getUpdateSlipPrimary() {
		if (UpdateSlipPrimary == null) {
			UpdateSlipPrimary = new ComboBoxBase();
			UpdateSlipPrimary.setBounds(107, 20, 233, 20);
		}
		return UpdateSlipPrimary;
	}
}
