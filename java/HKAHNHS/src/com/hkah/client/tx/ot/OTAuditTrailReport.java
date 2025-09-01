package com.hkah.client.tx.ot;


import com.hkah.client.layout.combobox.ComboUser;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.shared.constants.ConstantsTx;

public class OTAuditTrailReport extends MasterPanel{

	private static final long serialVersionUID = 1L;


	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.OTAUDITTRAILREPORT_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.OTAUDITTRAILREPORT_TITLE;
	}

	private BasePanel rightPanel=null;
	private BasePanel leftPanel=null;

	private BasePanel ParaPanel = null;

	private LabelBase DateRangeStartDesc=null;
	private TextString DateRangeStart=null;
	private LabelBase DateRangeEndDesc=null;
	private TextString DateRangeEnd=null;
	private LabelBase UserDesc=null;
	private ComboUser User = null;


	/**
	 * This method initializes
	 *
	 */
	public OTAuditTrailReport() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
		//getJScrollPane().setBounds(15, 25, 725, 290);
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
		return null;//getDateRangeStart();
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

	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected BasePanel getLeftPanel() {


		if (leftPanel==null) {
			leftPanel=new BasePanel();
			leftPanel.setSize(779, 528);
			leftPanel.add(getParaPanel(),null);

		}
		return leftPanel;

	}

	protected BasePanel getRightPanel() {

		if (rightPanel==null) {
			rightPanel=new BasePanel();
			//leftPanel.setSize(800, 530));
		}
		return rightPanel;

	}

	public BasePanel getParaPanel() {
		if (ParaPanel==null) {
			ParaPanel=new BasePanel();
			ParaPanel.add(getDateRangeStartDesc(), null);
			ParaPanel.add(getDateRangeStart(), null);
			ParaPanel.add(getDateRangeEndDesc(), null);
			ParaPanel.add(getDateRangeEnd(), null);
			ParaPanel.add(getUserDesc(), null);
			ParaPanel.add(getUser(), null);
			ParaPanel.setLocation(10,10);
			ParaPanel.setSize(449, 82);
		}
		return ParaPanel;
	}

	public LabelBase getDateRangeStartDesc() {
		if (DateRangeStartDesc==null) {
			DateRangeStartDesc=new LabelBase();
			DateRangeStartDesc.setText("<html>Date Range Start:<br>(dd/mm/yyyy)</html>");
			DateRangeStartDesc.setBounds(11, 10, 110, 30);
		}
		return DateRangeStartDesc;
	}

	public TextString getDateRangeStart() {
		if (DateRangeStart==null) {
			DateRangeStart=new TextString();
			DateRangeStart.setBounds(120, 20, 109, 20);
		 }
		return DateRangeStart;
	}

	public LabelBase getDateRangeEndDesc() {
		if (DateRangeEndDesc==null) {
			DateRangeEndDesc=new LabelBase();
			DateRangeEndDesc.setText("<html>Date Range End:<br>(dd/mm/yyyy)</html>");
			DateRangeEndDesc.setBounds(250, 12, 110, 28);
		}
		return DateRangeEndDesc;
	}

	public TextString getDateRangeEnd() {
		if (DateRangeEnd==null) {
			DateRangeEnd=new TextString();
			DateRangeEnd.setBounds(350, 20, 109, 20);
		 }
		return DateRangeEnd;
	}

	public LabelBase getUserDesc() {
		if (UserDesc==null) {
			UserDesc=new LabelBase();
			UserDesc.setText("User");
			UserDesc.setBounds(11, 50, 94, 20);
		}
		return UserDesc;
	}

	public ComboUser getUser() {
		if (User == null) {
			User = new ComboUser(true);
			User.setBounds(100, 50, 150, 20);
		}
		return User;
	}
}
