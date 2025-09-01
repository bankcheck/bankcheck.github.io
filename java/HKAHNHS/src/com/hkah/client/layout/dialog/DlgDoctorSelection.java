package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboDoctorSel;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.tx.admin.syscodetable.Doctor;

public class DlgDoctorSelection extends DialogBase{

	private LabelBase LblDoc;
	private ComboDoctorSel CboDoc;
	private ButtonBase BtnOk;
	private ButtonBase BtnCancel;
	private final static int m_frameWidth = 287;
    private final static int m_frameHeight = 134;
    private BasePanel panel = null;

	public DlgDoctorSelection(MainFrame owner) {
		super(owner, m_frameWidth, m_frameHeight);
		init();
	}

	protected void init() {
		setTitle("Doctor Selection");
		getContentPane().add(getPanel());
	}

	private BasePanel getPanel() {
		if (panel == null) {
			panel = new BasePanel();
			panel.setSize(300,72);
			panel.add(getLabDoc(), null);
			panel.add(getCboDoc(), null);
			panel.add(getBtnOk(), null);
			panel.add(getBtnCancel(), null);
		}
		return panel;
	}

	private LabelBase getLabDoc() {
		if (LblDoc == null) {
			LblDoc = new LabelBase("Doctor");
			LblDoc.setBounds(10,10, 45, 20);
		}
		return LblDoc;
	}

	private ComboDoctorSel getCboDoc() {
		if (CboDoc == null) {
			CboDoc = new ComboDoctorSel();
			CboDoc.setBounds(55, 10, 200, 20);
		}
		return CboDoc;
	}

	private ButtonBase getBtnOk() {
		if (BtnOk == null) {
			BtnOk = new ButtonBase("OK") {
				@Override
				public void onClick() {
					// TODO Auto-generated method stub
					super.onClick();
					((Doctor) (getMainFrame().getAppletBodyPanel())).itemShareLoad(getCboDoc().getText());
					dispose();
				}
			};
			BtnOk.setBounds(85, 50, 50, 20);
		}
		return BtnOk;
	}

	private ButtonBase getBtnCancel() {
		if (BtnCancel == null) {
			BtnCancel = new ButtonBase("Cancel") {
				@Override
				public void onClick() {
					// TODO Auto-generated method stub
					super.onClick();
					dispose() ;
				}
			};
			BtnCancel.setBounds(160, 50, 50, 20);
		}
		return BtnCancel;
	}
}