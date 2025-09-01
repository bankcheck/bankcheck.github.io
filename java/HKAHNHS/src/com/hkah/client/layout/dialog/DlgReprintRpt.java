package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.widget.form.RadioGroup;
import com.hkah.client.MainFrame;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.radiobutton.RadioButtonBase;
import com.hkah.client.layout.textfield.TextReadOnly;

public class DlgReprintRpt extends DialogBase {

	private final static int m_frameWidth = 400;
	private final static int m_frameHeight = 200;

	private BasePanel reprintPanel = null;
	private BasePanel topPanel = null;
	private BasePanel btmPanel = null;
	private TextReadOnly rptName = null;
	private LabelBase reprintLabel = null;
	private String[] memParameter = null;
	private boolean isShowPreview = false;
	private LabelBase copyDesc = null;
	private RadioButtonBase copyYesOpt = null;
	private RadioButtonBase copyNoOpt = null;

	public DlgReprintRpt(MainFrame owner, String reportName) {
		super(owner, YESNOCANCEL, m_frameWidth, m_frameHeight);

		initialize(reportName);
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize(String reportName) {
		setTitle("Re-print report");
		setContentPane(getReprintPanel());
		getButtonById(CANCEL).setText("Print To Screen");
		getButtonById(CANCEL).setVisible(isShowPreview);
		getRptName().setText(reportName);
		RadioGroup btngrp = new RadioGroup();
		btngrp.add(getCopyYesOpt());
		btngrp.add(getCopyNoOpt());
	}

	public ButtonBase getDefaultFocusComponent() {
		return getButtonById(NO);
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog() {
		showDialog(false, null);
	}

	public void showDialog(boolean copyOpt) {
		showDialog(copyOpt, null);
	}

	public void showDialog(String parameter[]) {
		showDialog(false, parameter);
	}

	public void showDialog(boolean copyOpt, String parameter[]) {
		if (copyOpt) {
			getCopyDesc().show();
			getCopyYesOpt().show();
			getCopyNoOpt().show();
			getCopyYesOpt().setSelected(true);
		}
		else {
			getCopyDesc().hide();
			getCopyYesOpt().hide();
			getCopyNoOpt().hide();
		}
		setParameter(parameter);
		layout();
		setVisible(true);
		setFocusWidget(getButtonById(NO));
	}

	public void showDialog(String parameter[],boolean isShwPreview) {
		isShowPreview = isShwPreview;
		getButtonById(CANCEL).setVisible(isShowPreview);
		setParameter(parameter);
		setVisible(true);
		setFocusWidget(getButtonById(NO));
	}

	@Override
	protected void doYesAction() {
		reprint();
	}

	@Override
	protected void doNoAction() {
		super.doCancelAction();
		postAction();
	}

	@Override
	protected void doCancelAction() {
		doPreviewRpt();
	}

	public void doPreviewRpt(){};

	public void reprint() {}

	public void postAction() {}

	public void setParameter(String[] parameter) {
		memParameter = parameter;
	}

	public String[] getParameter() {
		return memParameter;
	}

	@Override
	public void TabAndArrowKeyEvent(ComponentEvent ce) {
		if (ce.getKeyCode() == 9) {
			this.focus();
			if (getFocusWidget().equals(getButtonById(YES))) {
				setFocusWidget(getButtonById(NO));
				getButtonById(NO).focus();
			} else if (getFocusWidget().equals(getButtonById(NO))) {
				setFocusWidget(getButtonById(YES));
				getButtonById(YES).focus();
			}
		} else if (ce.getKeyCode() == 37 || ce.getKeyCode() == 39) {
			if (getFocusWidget().equals(getButtonById(YES))) {
				setFocusWidget(getButtonById(NO));
				getButtonById(NO).focus();
			} else if (getFocusWidget().equals(getButtonById(NO))) {
				setFocusWidget(getButtonById(YES));
				getButtonById(YES).focus();
			}
		}
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	protected BasePanel getReprintPanel() {
		if (reprintPanel == null) {
			reprintPanel = new BasePanel();
			reprintPanel.setBounds(5, 5,380, 220);
			reprintPanel.add(getTopPanel(), null);
			reprintPanel.add(getBtmPanel(), null);
		}
		return reprintPanel;
	}

	protected BasePanel getTopPanel() {
		if (topPanel == null) {
			topPanel = new BasePanel();
			topPanel.setBounds(10, 5, 360, 60);
			topPanel.add(getReprintLabel(), null);
			topPanel.add(getRptName(), null);
			topPanel.add(getCopyDesc(), null);
			topPanel.add(getCopyYesOpt(), null);
			topPanel.add(getCopyNoOpt(), null);
		}
		return topPanel;
	}

	public BasePanel getBtmPanel() {
		if (btmPanel == null) {
			btmPanel = new BasePanel();
			btmPanel.setBounds(50, 70, 360, 60);
		}
		return btmPanel;
	}

	protected LabelBase getReprintLabel() {
		if (reprintLabel == null) {
			reprintLabel = new LabelBase();
			reprintLabel.setText("Re-print the following report?");
			reprintLabel.setBounds(20, 10, 300, 20);
		}
		return reprintLabel;
	}

	protected TextReadOnly getRptName() {
		if (rptName == null) {
			rptName = new TextReadOnly();
			rptName.setBounds(20, 40, 300, 20);
		}
		return rptName;
	}

	protected LabelBase getCopyDesc() {
		if (copyDesc == null) {
			copyDesc = new LabelBase();
			copyDesc.setText("Is it a copy?");
			copyDesc.setBounds(20, 65, 120, 20);
		}
		return copyDesc;
	}

	protected RadioButtonBase getCopyYesOpt() {
		if (copyYesOpt == null) {
			copyYesOpt = new RadioButtonBase();
			copyYesOpt.setText("Yes");
			copyYesOpt.setBounds(150, 65, 50, 20);
		}
		return copyYesOpt;
	}

	protected RadioButtonBase getCopyNoOpt() {
		if (copyNoOpt == null) {
			copyNoOpt = new RadioButtonBase();
			copyNoOpt.setText("No");
			copyNoOpt.setSelected(true);
			copyNoOpt.setBounds(205, 65, 50, 20);
		}
		return copyNoOpt;
	}
}