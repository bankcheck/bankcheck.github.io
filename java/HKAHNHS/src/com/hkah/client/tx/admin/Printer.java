package com.hkah.client.tx.admin;

import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextAreaBase;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.tx.MasterPanel;
import com.hkah.shared.constants.ConstantsTx;

public class Printer extends MasterPanel{

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.PRINTER_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.PRINTER_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"",
				"Report Name",
				"Printer Name",
				"Printer Tray",
				"Seq#"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				10,
				200,
				200,
				100,
				100
		};
	}

	private BasePanel rightPanel=null;
	private BasePanel leftPanel=null;
	private LabelBase TrayInfDesc=null;
	private TextAreaBase TrayInf=null;
	/**
	 * This method initializes
	 *
	 */
	public Printer() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		getJScrollPane().setBounds(20, 20, 740, 370);
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		setLeftAlignPanel();
		getAppendButton().setEnabled(false);
		getCancelButton().setEnabled(true);
		getPrintButton().setEnabled(false);
		getRefreshButton().setEnabled(false);
		getCancelButton().setEnabled(false);
		getAcceptButton().setEnabled(false);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return null;
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	@Override
	protected void deleteDisabledFields() {
		// enable/disable field
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		return true;
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {};
	}

	/* >>> ~15.1~ Set Browse Output Results =============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		String[] selectedContent = getListSelectedRow();
		return new String[] {
				selectedContent[0]
		};
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		String[] para=getListTable().getSelectedRowContent();
		return new String[] {};
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {}

	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel=new BasePanel();
			leftPanel.setSize(780, 499);
			leftPanel.add(getTrayInfDesc());
			leftPanel.add(getTrayInf());
		}
		return leftPanel;
	}

	protected BasePanel getRightPanel() {

		if (rightPanel == null) {
			rightPanel=new BasePanel();
			//leftPanel.setSize(800, 530));
		}
		return rightPanel;
	}

	public LabelBase getTrayInfDesc() {
		if (TrayInfDesc == null) {
			TrayInfDesc = new LabelBase();
			TrayInfDesc.setText("Tray Information");
			TrayInfDesc.setBounds(20, 409, 106, 20);
		}
		return TrayInfDesc;
	}

	public TextAreaBase getTrayInf() {
		if (TrayInf == null) {
			TrayInf = new TextAreaBase();
			TrayInf.setBounds(127, 410, 322, 76);
		}
		return TrayInf;
	}
}