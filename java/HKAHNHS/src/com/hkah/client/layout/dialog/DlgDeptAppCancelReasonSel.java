package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboOTAppCancelBy;
import com.hkah.client.layout.combobox.ComboOTAppIsAdmitted;
import com.hkah.client.layout.combobox.ComboOTAppOther;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextAreaBase;

public class DlgDeptAppCancelReasonSel extends DialogBase {
	private final static int m_frameWidth = 420;
	private final static int m_frameHeight = 360;
	private BasePanel CancelReasonPanel = null;	
//	private LabelBase cancelReasonDesc = null;
//	private ComboOTAppCancelReason cancelReason = null;
	private LabelBase isAdmittedDesc = null;
	private ComboOTAppIsAdmitted isAdmitted = null;
	private LabelBase cancelByDesc = null;
	private ComboOTAppCancelBy cancelBy = null;
	private LabelBase cancelReasonDesc = null;
	private ComboOTAppOther cancelReason = null;
	private LabelBase remarkDesc = null;
	private TextAreaBase remarkTextArea = null;
	private ButtonBase saveBtn = null;
	private ButtonBase cancelBtn = null;

	private DlgDeptAppCancelReasonSel getDialog() {
		return this;
	}

	public DlgDeptAppCancelReasonSel(MainFrame owner) {
		super(owner, m_frameWidth, m_frameHeight);
		init();
	}

	protected void init() {
		setTitle("Cancel Reason");
		add(getCancelReasonPanel(),null);
	}

	public BasePanel getCancelReasonPanel() {
		if (CancelReasonPanel == null) {
			CancelReasonPanel=new BasePanel();
			CancelReasonPanel.setBounds(5, 5, 367, 204);
			//CancelReasonPanel.add(getCancelReasonDesc());
			//CancelReasonPanel.add(getCancelReason());
			CancelReasonPanel.add(getIsAdmittedDesc());
			CancelReasonPanel.add(getIsAdmitted());
			CancelReasonPanel.add(getCancelByDesc());
			CancelReasonPanel.add(getCancelBy());
			CancelReasonPanel.add(getCancelReasonDesc());
			CancelReasonPanel.add(getCancelReason());
			CancelReasonPanel.add(getRemarkDesc());
			CancelReasonPanel.add(getRemarkTextArea());
			CancelReasonPanel.add(getSaveBtn());
			CancelReasonPanel.add(getCancelBtn());

		}
		return CancelReasonPanel;
	}
/*
	public LabelBase getCancelReasonDesc() {
		if (cancelReasonDesc == null) {
			cancelReasonDesc=new LabelBase();
			cancelReasonDesc.setText("Cancel Reason");
			cancelReasonDesc.setBounds(30, 20, 120, 20);
		}
		return cancelReasonDesc;
	}

	public ComboOTAppCancelReason getCancelReason() {
		if (cancelReason == null) {
			cancelReason = new ComboOTAppCancelReason();
			cancelReason.setBounds(150, 20, 180, 20);
		}
		return cancelReason;
	}
*/
	public LabelBase getIsAdmittedDesc() {
		if (isAdmittedDesc == null) {
			isAdmittedDesc=new LabelBase();
			isAdmittedDesc.setText("Admitted");
			isAdmittedDesc.setBounds(30, 20, 120, 20);
		}
		return isAdmittedDesc;
	}

	public ComboOTAppIsAdmitted getIsAdmitted() {
		if (isAdmitted == null) {
			isAdmitted = new ComboOTAppIsAdmitted();
			isAdmitted.setBounds(150, 20, 180, 20);
		}
		return isAdmitted;
	}
	
	public LabelBase getCancelByDesc() {
		if (cancelByDesc == null) {
			cancelByDesc=new LabelBase();
			cancelByDesc.setText("Cancel Requested By");
			cancelByDesc.setBounds(30, 50, 120, 20);
		}
		return cancelByDesc;
	}

	public ComboOTAppCancelBy getCancelBy() {
		if (cancelBy == null) {
			cancelBy = new ComboOTAppCancelBy();
			cancelBy.setBounds(150, 50, 180, 20);
		}
		return cancelBy;
	}
	
	public LabelBase getCancelReasonDesc() {
		if (cancelReasonDesc == null) {
			cancelReasonDesc=new LabelBase();
			cancelReasonDesc.setText("Reason");
			cancelReasonDesc.setBounds(30, 80, 120, 20);
		}
		return cancelReasonDesc;
	}

	public ComboOTAppOther getCancelReason() {
		if (cancelReason == null) {
			cancelReason = new ComboOTAppOther();
			cancelReason.setBounds(150, 80, 180, 20);
		}
		return cancelReason;
	}

	public LabelBase getRemarkDesc() {
		if (remarkDesc == null) {
			remarkDesc=new LabelBase();
			remarkDesc.setText("Remark");
			remarkDesc.setBounds(30, 110, 120, 20);
		}
		return remarkDesc;
	}

	public TextAreaBase getRemarkTextArea() {
		if (remarkTextArea == null) {
			remarkTextArea = new TextAreaBase();
			remarkTextArea.setMaxLength(100);
			remarkTextArea.setBounds(150, 110, 210, 100);
		}
		return remarkTextArea;
	}

	public ButtonBase getSaveBtn() {
		if (saveBtn == null) {
			saveBtn = new ButtonBase() {
				@Override
				public void onClick() {
					getDialog().dispose();
					save(null, getIsAdmitted().getText(), getCancelBy().getText(),
							getCancelReason().getText(), getRemarkTextArea().getText());
				}
			};
			saveBtn.setText("Save");
			saveBtn.setBounds(70, 240, 100, 20);
		}
		return saveBtn;
	}

	public ButtonBase getCancelBtn() {
		if (cancelBtn == null) {
			cancelBtn = new ButtonBase() {
				@Override
				public void onClick() {
					getDialog().dispose();
					cancel();
				}
			};
			cancelBtn.setText("Cancel");
			cancelBtn.setBounds(210, 240, 100, 20);
		}
		return cancelBtn;
	}

	protected void save(String cancelCode, String isAdmittedCode, String cancelByCode, String otherCode, String remark) {}

	protected void cancel() {}
}