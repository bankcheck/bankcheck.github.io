package com.hkah.client.tx.admin.codetable;


import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.shared.constants.ConstantsTx;

public class CashReference extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.CASHREFERENCE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.CASHREFERENCE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"ID",
				"Reference Text"

		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				0,
				200
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;
	private LabelBase LeftJLabel_ReferenceText = null;
	private TextString LeftJText_ReferenceText = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_ReferenceText = null;
	private TextString RightJText_ReferenceText = null;

	private String id=null;  //  @jve:decl-index=0:

	/**
	 * This method initializes
	 *
	 */
	public CashReference() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		/* >>> ~7.1~ Init action (e.g. Listing, Init Comobbox ========= <<< */
		//setFullEntry(true);
		setNoGetDB(true);

		/* >>> ~7.2~ Disable Add/Modify/Delete Buttons ================ <<< */
		//setAppendButtonEnabled(false);
		//setModifyButtonEnabled(true);
		//setDeleteButtonEnabled(false);
		//setConfirmButtonEnabled(false);

		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		//performList();

	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return null;//getLeftJText_ReferenceText();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		// override function if necessary
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
		// enable/disable field
		id = null;
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		// enable/disable field

	}

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
				getLeftJText_ReferenceText().getText()
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
		int index = 0;
		id = outParam[index++];
		getRightJText_ReferenceText().setText(outParam[index++]);

	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {}

	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		return new String[] {
				id,
				selectedContent[1]
		};
	}

	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[1].trim().length()==0|| selectedContent[1]==null) {
				Factory.getInstance().addErrorMessage("Empty reference text");
				return false;
		}
		return true;
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/**
	 * This method initializes leftPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getSearchPanel() {
		if (leftPanel == null) {
			LeftJLabel_ReferenceText = new LabelBase();
//			LeftJLabel_ReferenceText.setBounds(15, 30, 121, 20);
			LeftJLabel_ReferenceText.setText("Reference Text");
			leftPanel = new ColumnLayout(2,1);
//			leftPanel.setSize(471,100);
			leftPanel.add(0,0,LeftJLabel_ReferenceText);
			leftPanel.add(1,0,getLeftJText_ReferenceText());
		}
		return leftPanel;
	}


	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			RightJLabel_ReferenceText = new LabelBase();
//			RightJLabel_ReferenceText.setBounds(15, 45, 106, 20);
			RightJLabel_ReferenceText.setText("Reference Text");
			generalPanel = new ColumnLayout(2,1);
//			generalPanel.setLayout(null);
//			generalPanel.setBounds(0, 0, 601, 121);
			generalPanel.setHeading("Cash Reference Information");
			generalPanel.add(0,0,RightJLabel_ReferenceText);
			generalPanel.add(1,0,getRightJText_ReferenceText());
		}
		return generalPanel;
	}

	/**
	 * This method initializes LeftJText_ReferenceText
	 *
	 * @return javax.swing.TextString
	 */
	private TextString getLeftJText_ReferenceText() {
		if (LeftJText_ReferenceText == null) {
			LeftJText_ReferenceText = new TextString(50);
//			LeftJText_ReferenceText.setBounds(150, 30, 211, 20);
		}
		return LeftJText_ReferenceText;
	}

	/**
	 * This method initializes RightJText_ReferenceText
	 *
	 * @return javax.swing.TextString
	 */
	private TextString getRightJText_ReferenceText() {
		if (RightJText_ReferenceText == null) {
			RightJText_ReferenceText = new TextString(50,getListTable(), 1);

		}
		return RightJText_ReferenceText;
	}
}