package com.hkah.client.layout.dialog;

import java.util.Map;

import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.form.RadioGroup;
import com.hkah.client.MainFrame;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.radiobutton.RadioButtonBase;

public abstract class DlgDayEndReport extends DialogBase {
	private final static int m_frameWidth = 500;
	private final static int m_frameHeight = 170;

	private BasePanel OPOfficePanel = null;
	private RadioButtonBase normalOpt = null;
	private RadioButtonBase dayendOpt = null;
	private LabelBase copyDesc = null;
	private BasePanel copyPanel = null;

	protected String memReportName = null;
	protected Map<String, String> memMap = null;
	protected String memStartDate = null;
	protected String memEndDate = null;
	protected String memSteCode = null;
	protected boolean memIsPrintToScreen = false;
	protected boolean memIsPrintToFile = false;

	public DlgDayEndReport(MainFrame owner) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setContentPane(getOPOfficePanel());

		// change label
		getButtonById(OK).setText("Print", 'P');

		RadioGroup btngrp = new RadioGroup();
		btngrp.add(getNormalOpt());
		btngrp.add(getDayendOpt());

		// layout
	}

	public void showDialog(String reportName, Map<String, String> map, String startDate, String endDate, String steCode, boolean isPrinttoScreen, boolean isPrinttoFile) {
		memReportName = reportName;
		memMap = map;
		memStartDate = startDate;
		memEndDate = endDate;
		memSteCode = steCode;
		memIsPrintToScreen = isPrinttoScreen;
		memIsPrintToFile = isPrinttoFile;

		getNormalOpt().setSelected(true);

		if (memReportName.equals("RptPettyCash")) {
			setTitle("Cash Management/Petty Cash Report");
		} else if (memReportName.equals("RptCshrAuditSmy")) {
			setTitle("Cashier Audit Summary");
		} else if (memReportName.equals("RptReceipt")) {
			setTitle("Receipt");
		} else {
			setTitle("Day End report");
		}

		setVisible(true);
	}

	@Override
	protected abstract void doOkAction();

	@Override
	protected void doCancelAction() {
		setVisible(false);
	}

	@Override
	public Component getDefaultFocusComponent() {
		return getOPOfficePanel();
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getOPOfficePanel() {
		if (OPOfficePanel == null) {
			OPOfficePanel = new BasePanel();
			OPOfficePanel.setBounds(5, 5, 460, 280);
			OPOfficePanel.add(getCopyPanel(), null);
		}
		return OPOfficePanel;
	}

	private BasePanel getCopyPanel() {
		if (copyPanel == null) {
			copyPanel = new BasePanel();
			copyPanel.setBounds(5, 15, 450, 65);
			copyPanel.setBorders(true);
			copyPanel.add(getCopyDesc(), null);
			copyPanel.add(getNormalOpt(), null);
			copyPanel.add(getDayendOpt(), null);
		}
		return copyPanel;
	}

	public LabelBase getCopyDesc() {
		if (copyDesc == null) {
			copyDesc = new LabelBase();
			copyDesc.setText("Select Report");
			copyDesc.setBounds(30, 10, 120, 20);
		}
		return copyDesc;
	}

	public RadioButtonBase getNormalOpt() {
		if (normalOpt == null) {
			normalOpt = new RadioButtonBase();
			normalOpt.setText("Normal");
			normalOpt.setBounds(150, 10, 180, 20);
		}
		return normalOpt;
	}

	public RadioButtonBase getDayendOpt() {
		if (dayendOpt == null) {
			dayendOpt = new RadioButtonBase();
			dayendOpt.setText("Dayend before Cashier close");
			dayendOpt.setBounds(150, 35, 180, 20);
		}
		return dayendOpt;
	}
}