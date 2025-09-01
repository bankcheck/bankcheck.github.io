package com.hkah.client.tx.report;

import java.util.HashMap;
import java.util.Map;

import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboTime;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.PrintingUtil;
import com.hkah.shared.constants.ConstantsTx;

public class CSRReorderReport extends MasterPanel
{
	private static final long serialVersionUID = 1L;
	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.ARREPORTS_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.ARREPORTS_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {};
	}

	private BasePanel rightPanel=null;
	private BasePanel leftPanel=null;

	private BasePanel ContentPanel = null;
	private LabelBase DateDesc=null;
	private TextDate Date=null;
	private LabelBase TimeDesc=null;
	private ComboTime Time=null;
	private LabelBase PrinttoFileDesc=null;
	private CheckBoxBase PrinttoFile=null;
	private LabelBase PrinttoScreenDesc=null;
	private CheckBoxBase PrinttoScreen=null;
	/**
	 * This method initializes
	 *
	 */
	public CSRReorderReport() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
		//setRightAlignPanel();
		getJScrollPane().setBounds(15, 25, 725, 290);
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getSearchButton().setEnabled(false);
		getAppendButton().setEnabled(false);
		getCancelButton().setEnabled(true);
		getPrintButton().setEnabled(true);
		getRefreshButton().setEnabled(false);
		getCancelButton().setEnabled(false);
		getAcceptButton().setEnabled(false);
		getDate().setText(getMainFrame().getServerDate());
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return null;//getDate();
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

	@Override
	public void printAction() {
		if (!getPrinttoFile().isSelected() && !getPrinttoScreen().isSelected()) {

		}
		if (getPrinttoFile().isSelected()) {
//			CommonUtil.saveFile();
		}
		if (getPrinttoScreen().isSelected()) {
			String StartTime = null;
			if (getTime().getDisplayText().equals("8:00")) {
				StartTime = getTime().getDisplayText("T3");
			} else if (getTime().getDisplayText().equals("20:00")) {
				StartTime = getTime().getDisplayText("T2");
			} else if (getTime().getDisplayText().equals("15:30")) {
				StartTime = getTime().getDisplayText("T1");
			}
			Map<String, String> map = new HashMap<String, String>();
			map.put("StartDate", getDate().getText() +" "+ getTime().getDisplayText());
			map.put("EndDate", getDate().getText()+" "+ StartTime);
			map.put("SteCode", getUserInfo().getSiteCode());
			map.put("SteName", getUserInfo().getSiteName());
			PrintingUtil.print("RptCSRReOrder", map,"", new String[] {
				getDate().getText() +" "+ getTime().getDisplayText(),
				getDate().getText()+" "+ StartTime,
				getUserInfo().getSiteCode()
			}, new String[] {
				"WRDCODE",
				"ITMCODE",
				"COUNT(*)",
				"STNDESC"
			});
		}
		super.printAction();
	}

	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected BasePanel getRightPanel() {
		if (rightPanel == null) {
			rightPanel = new BasePanel();
		//	leftPanel.setSize(779, 321));
		}
		return rightPanel;
	}
	protected BasePanel getLeftPanel() {

		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.setSize(779, 321);
			leftPanel.add(getCheckBoxPanel(),null);
			//leftPanel.setSize(800, 530));
		}
		return leftPanel;
	}
	public BasePanel getCheckBoxPanel() {
		if (ContentPanel == null) {
			ContentPanel = new BasePanel();
			ContentPanel.setBorders(true);
			ContentPanel.add(getDateDesc(), null);
			ContentPanel.add(getDate(), null);
			ContentPanel.add(getTimeDesc(), null);
			ContentPanel.add(getTime(), null);
			ContentPanel.add(getPrinttoFileDesc(), null);
			ContentPanel.add(getPrinttoFile(), null);
			ContentPanel.add(getPrinttoScreenDesc(), null);
			ContentPanel.add(getPrinttoScreen(), null);
			ContentPanel.setLocation(5, 24);
			ContentPanel.setSize(574, 285);
		}
		return ContentPanel;
	}
	public LabelBase getDateDesc() {
		if (DateDesc == null) {
			DateDesc = new LabelBase();
			DateDesc.setText("Date:");
			DateDesc.setBounds(50, 60, 40, 20);
		}
		return DateDesc;
	}
	public TextDate getDate() {
		if (Date == null) {
			Date = new TextDate();
			Date.setBounds(89, 60, 119, 20);
		 }
		return Date;
	}
	public LabelBase getTimeDesc() {
		if (TimeDesc == null) {
			TimeDesc = new LabelBase();
			TimeDesc.setText("Time:");
			TimeDesc.setBounds(50, 100, 40, 20);
		}
		return TimeDesc;
	}
	public ComboTime getTime() {
		if (Time == null) {
			Time = new ComboTime();
			Time.setBounds(89, 100, 119, 20);
		 }
		return Time;
	}
	public LabelBase getPrinttoFileDesc() {
		if (PrinttoFileDesc == null) {
			PrinttoFileDesc = new LabelBase();
			PrinttoFileDesc.setText("Print To File");
			PrinttoFileDesc.setBounds(335, 189, 67, 20);
		}
		return PrinttoFileDesc;
	}
	public CheckBoxBase getPrinttoFile() {
		if (PrinttoFile == null) {
			PrinttoFile = new CheckBoxBase();
			PrinttoFile.setBounds(309, 188, 23, 20);
		 }
		return PrinttoFile;
	}
	public LabelBase getPrinttoScreenDesc() {
		if (PrinttoScreenDesc == null) {
			PrinttoScreenDesc = new LabelBase();
			PrinttoScreenDesc.setText("Print To Screen");
			PrinttoScreenDesc.setBounds(444, 188, 100, 20);
		}
		return PrinttoScreenDesc;
	}
	public CheckBoxBase getPrinttoScreen() {
		if (PrinttoScreen == null) {
			PrinttoScreen = new CheckBoxBase();
			PrinttoScreen.setBounds(419, 188, 23, 20);
		 }
		return PrinttoScreen;
	}
}