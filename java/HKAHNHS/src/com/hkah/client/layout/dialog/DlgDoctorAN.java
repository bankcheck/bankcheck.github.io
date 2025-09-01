package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboDoctorAN;
import com.hkah.client.layout.panel.BasePanel;

public class DlgDoctorAN extends DialogBase{

	private final static int m_frameWidth = 287;
    private final static int m_frameHeight = 134;
    public String otlid;
    public String doccode;
	private BasePanel panel = null;
	private ComboDoctorAN doctorComboBox = null;
	private ButtonBase btnSelect = null;
	private ButtonBase btnDelete = null;

	public DlgDoctorAN(MainFrame owner) {
		super(owner, m_frameWidth, m_frameHeight);
		init();
	}

	protected void init() {
		setTitle("Security Check");
		getContentPane().add(getPanel());
	}

	private BasePanel getPanel() {
		if (panel == null) {
			panel = new BasePanel();
			panel.setSize(287, 134);
			panel.add(getDoctorComboBox(), null);
			panel.add(getBtnSelect(), null);
			panel.add(getBtnDelete(), null);
		}
		return panel;
	}

	private ComboDoctorAN getDoctorComboBox() {
		if (doctorComboBox == null) {
			doctorComboBox = new ComboDoctorAN();
			doctorComboBox.setBounds(55, 14, 163, 20);
		}
		return doctorComboBox;
	}

	private ButtonBase getBtnSelect() {
		if (btnSelect == null) {
			btnSelect = new ButtonBase() {
				@Override
				public void onClick() {
					// TODO: missing logic for ok button
				}
			};
			btnSelect.setBounds(41, 60, 78, 24);
			btnSelect.setText("OK");
		}
		return btnSelect;
	}

	private ButtonBase getBtnDelete() {
		if (btnDelete == null) {
			btnDelete = new ButtonBase() {
				@Override
				public void onClick() {
					// TODO: missing logic to do delete
				}
			};
			btnDelete.setBounds(152, 60, 78, 24);
			btnDelete.setText("Delete");
		}
		return btnDelete;
	}
}