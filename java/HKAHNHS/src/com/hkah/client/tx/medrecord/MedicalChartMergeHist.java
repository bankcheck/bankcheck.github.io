package com.hkah.client.tx.medrecord;
import java.util.ArrayList;
import java.util.List;

import com.extjs.gxt.ui.client.widget.Component;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.shared.constants.ConstantsTx;

public class MedicalChartMergeHist extends MaintenancePanel{

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.MEDCHARTMERGEHIST_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.MEDCHARTMERGEHIST_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				10,
				80,
				90,100,100,34,75,0,
				90,100,100,34,75,0,
				75
			};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
						"",
						"Merge Date",
						"From Patient",
						"F.Name",
						"G.Name",
						"Sex",
						"D.O.B.",
						"",
						"To Patient",
						"F.Name",
						"G.Name",
						"Sex",
						"D.O.B.",
						"",
						"User"
				};
	}

	// property declare start
	private ColumnLayout rightPanel=null;

	private ColumnLayout searchPanel = null;
	private BasePanel leftPanel = null;
	private LabelBase fromPatNoDesc = null;
	private TextDate fromDate = null;
	private LabelBase toPatNoDesc = null;
	private TextDate toDate = null;

	/**
	 * This method initializes
	 *
	 */
	public MedicalChartMergeHist() {
		super();
		getListTable().setHeight(400);
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		enableButton(null);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		return getFromDate();
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
		return new String[] {
				getFromDate().getText(),
				getToDate().getText()
		};
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

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {}

	/* >>> ~22~ Set Action Input Parameters per table ===================== <<< */
	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		String[] inParm =  new String[] {
				getFromDate().getText().trim(),
				getToDate().getText().trim(),
				selectedContent[2],
				selectedContent[3],
				selectedContent[1],
				getUserInfo().getUserID()
		};
		return inParm;
	}

	/* >>> ~23~ Set Action Validation per table =========================== <<< */
	@Override
	protected boolean actionValidation(String[] selectedContent) {
		return true;
	}
	
	@Override
	protected void enableButton(String mode) {
		// disable all button
		disableButton();
		
		getSearchButton().setEnabled(true);
		getAcceptButton().setEnabled(true);
	}

	// action method override start
	@Override
	public void acceptAction() {
		if (getListTable().getRowCount()>0) {
			List<String[]> list = new ArrayList<String[]>();
			list.add(getListSelectedRow());
			setParameter("PATMER", list);
			showPanel(new MedicalChartMerge(), false, true);		
		}
	}

	/* >>> getter methods for init the Component start from here================================== <<< */

	protected ColumnLayout getActionPanel() {
		if (rightPanel == null) {
			rightPanel = new ColumnLayout(1,1);
			rightPanel.setSize(900, 24);
		}
		return rightPanel;
	}
	
	public ColumnLayout getSearchPanel() {
		if (searchPanel == null) {
			searchPanel = new ColumnLayout(1, 1);
			searchPanel.add(0, 0, getLeftPanel());
		}
		return searchPanel;
	}	

	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.add(getFromDateDesc());
			leftPanel.add(getFromDate());
			leftPanel.add(getToDateDesc());
			leftPanel.add(getToDate());			
			leftPanel.setSize(900, 50);			
		}	
		return leftPanel;		
	}				

	public LabelBase getFromDateDesc() {
		if (fromPatNoDesc == null) {
			fromPatNoDesc = new LabelBase();
			fromPatNoDesc.setText("Merge From Date");
			fromPatNoDesc.setBounds(0, 30, 100, 20);
		}
		return fromPatNoDesc;
	}

	public TextDate getFromDate() {
		if (fromDate == null) {
			fromDate = new TextDate();
			fromDate.setBounds(105, 30, 120, 20);
		}
		return fromDate;
	}

	public LabelBase getToDateDesc() {
		if (toPatNoDesc == null) {
			toPatNoDesc = new LabelBase();
			toPatNoDesc.setText("Merge To Date");
			toPatNoDesc.setBounds(270, 30, 90, 20);
		}
		return toPatNoDesc;
	}

	public TextDate getToDate() {
		if (toDate == null) {
			toDate = new TextDate();
			toDate.setBounds(365, 30, 120, 20);
		}
		return toDate;
	}
}