package com.hkah.client.tx.admin.security;


import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboDept;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.tx.MasterPanel;
import com.hkah.shared.constants.ConstantsTx;

public class DepartmentCharge extends MasterPanel{

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.DEPARTMENTCHARGE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.DEPARTMENTCHARGE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			" ",
			"Regular",
			"Description"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
			10,
			100,
			300
		};
	}

	private BasePanel rightPanel=null;
	private BasePanel leftPanel=null;

	private LabelBase DeptCodeDesc=null;
	private ComboDept DeptCode=null;
	private ButtonBase SlipNo=null;
	private ButtonBase OTLogID=null;
	private ButtonBase Check=null;
	private TextReadOnly Spellsql=null;

	private JScrollPane JScrollPane = null;
	private BasePanel ListPanel = null;

	/**
	 * This method initializes
	 *
	 */
	public DepartmentCharge() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
		getJScrollPane().setBounds(24, 25, 706, 120);
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
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
		return null;//getDeptCode();
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
	protected void getFetchOutputValues(String[] outParam) {

	}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {};
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {}

	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.setSize(779, 528);
			leftPanel.add(getDeptCodeDesc(), null);
			leftPanel.add(getDeptCode(), null);
			leftPanel.add(getListPanel(), null);
			leftPanel.add(getSlipNo(), null);
			leftPanel.add(getOTLogID(), null);
			leftPanel.add(getCheck(), null);
		}
		return leftPanel;
	}

	protected BasePanel getRightPanel() {

		if (rightPanel == null) {
			rightPanel = new BasePanel();
			//leftPanel.setSize(800, 530));
		}
		return rightPanel;

	}

	public LabelBase getDeptCodeDesc() {
		if (DeptCodeDesc == null) {
			DeptCodeDesc = new LabelBase();
			DeptCodeDesc.setText("Department Code");
			DeptCodeDesc.setBounds(10, 20, 104, 20);
		}
		return DeptCodeDesc;
	}

	public ComboDept getDeptCode() {
		if (DeptCode == null) {
			DeptCode = new ComboDept();
			DeptCode.setBounds(114, 20, 200, 20);
		}
		return DeptCode;
	}

	public ButtonBase getSlipNo() {
		if (SlipNo == null) {
			SlipNo = new ButtonBase() {
				@Override
				public void onClick() {
				}
			};
			SlipNo.setText("Slip Number");
			SlipNo.setBounds(34, 457, 107, 20);
		}
		return SlipNo;
	}

	public ButtonBase getOTLogID() {
		if (OTLogID == null) {
			OTLogID = new ButtonBase() {
				@Override
				public void onClick() {
				}
			};
			OTLogID.setText("OT Log ID");
			OTLogID.setBounds(147, 457, 107, 20);
		}
		return OTLogID;
	}

	public ButtonBase getCheck() {
		if (Check == null) {
			Check = new ButtonBase() {
				@Override
				public void onClick() {
				}
			};
			Check.setText("Check");
			Check.setBounds(259, 457, 107, 20);
		}
		return Check;
	}

	public TextReadOnly getSpellsql() {
		if (Spellsql == null) {
			Spellsql = new TextReadOnly();
			Spellsql.setBounds(24, 163, 706, 212);
		}
		return Spellsql;
	}

	public BasePanel getListPanel() {
		if (ListPanel == null) {
			ListPanel = new BasePanel();
			ListPanel.setHeading("Regular / Surchange");
			ListPanel.setBounds(10, 50, 757, 398);
			this.getLeftPanel().remove(this.getJScrollPane());
			ListPanel.add(getJScrollPane());
			ListPanel.add(getSpellsql(), null);
		}
		return ListPanel;
	}
}