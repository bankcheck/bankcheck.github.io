package com.hkah.client.layout.dialogsearch;

import com.extjs.gxt.ui.client.util.Rectangle;
import com.hkah.client.layout.dialog.DialogSearchBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.textfield.SearchTriggerField;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;

public class DlgSubReasonSearch extends DialogSearchBase {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.SUBREASON_SEARCH_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.SUBREASON_SEARCH_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"Sub-Reason",
			"Sub-Reason Name",
			"Reason",
			"Reason Description",
			};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				120,
				250,
				80,
				250
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel searchPanel = null;
	private BasePanel ParaPanel = null;
	private LabelSmallBase srsnCodeDesc = null;
	private TextString srsnCode = null;
	private LabelSmallBase srsnNameDesc = null;
	private TextString srsnName = null;
	private LabelSmallBase reasonCodeDesc = null;
	private TextString reasonCode = null;
	private JScrollPane reasonScrollPanel = null;
	private BasePanel ListPanel = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */

	/**
	 * This method initializes
	 *
	 */
	public DlgSubReasonSearch(SearchTriggerField textField) {
		super(textField, 780, 500);
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getSrsnCode();
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getSrsnCode().getText().trim(),
				getSrsnName().getText().trim(),
				getReasonCode().getText().trim()};
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected boolean isSearchFieldsEmpty() {
		return getSrsnCode().isEmpty()
			&& getSrsnName().isEmpty()
			&& getReasonCode().isEmpty();
	}

	@Override
	protected String getInputCriteriaMessage() {
		return ConstantsMessage.MSG_INPUT_CRITERIA;
	}

	/***************************************************************************
	* Layout Method
	**************************************************************************/

	/* >>> getter methods for init the Component start from here ================================== <<< */
	@Override
	protected BasePanel getSearchPanel() {
		if (searchPanel == null) {
			searchPanel = new BasePanel();
			searchPanel.setSize(800, 175);
			searchPanel.add(getParaPanel(),null);
			searchPanel.add(getListPanel(), null);
		}
		return searchPanel;
	}

	public BasePanel getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new BasePanel();
			ParaPanel.setHeading("Sub Reason Information");
			ParaPanel.setBounds(15, 25, 734, 80);
			ParaPanel.add(getSrsnCodeDesc(),null);
			ParaPanel.add(getSrsnCode(),null);
			ParaPanel.add(getSrsnNameDesc(),null);
			ParaPanel.add(getSrsnName(),null);
			ParaPanel.add(getReasonCodeDesc(),null);
			ParaPanel.add(getReasonCode(),null);
		}
		return ParaPanel;
	}

   public LabelSmallBase getSrsnCodeDesc() {
	    if (srsnCodeDesc == null) {
	    	srsnCodeDesc = new LabelSmallBase();
	    	srsnCodeDesc.setText("Sub-Reason Code");
	    	srsnCodeDesc.setBounds(5,20, 120, 20);
	    }
		return srsnCodeDesc;
	}

	public TextString getSrsnCode() {
		 if (srsnCode == null) {
			 srsnCode = new TextString();
			 srsnCode.setBounds(130,20, 120, 20);
		}
		return srsnCode;
	}

	public LabelSmallBase getSrsnNameDesc() {
		if (srsnNameDesc == null) {
			srsnNameDesc = new LabelSmallBase();
			srsnNameDesc.setText("Sub-Reason Name");
			srsnNameDesc.setBounds(255,20, 120, 20);
	    }
		return srsnNameDesc;
	}

	public TextString getSrsnName() {
		if (srsnName == null) {
			srsnName = new TextString();
			srsnName.setBounds(380,20, 120, 20);
		}
		return srsnName;
	}

	public LabelSmallBase getReasonCodeDesc() {
		 if (reasonCodeDesc == null) {
			 reasonCodeDesc = new LabelSmallBase();
			 reasonCodeDesc.setText("Reason Code");
			 reasonCodeDesc.setBounds(5,45, 120, 20);
		}
		return reasonCodeDesc;
	}

	public TextString getReasonCode() {
		if (reasonCode == null) {
			reasonCode = new TextString();
			reasonCode.setBounds(130,45, 120, 20);
		}
		return reasonCode;
	}

	/**
	 * This method initializes reasonScrollPanel
	 *
	 * @return JScrollPane
	 */
	protected JScrollPane getReasonScrollPane() {
		if (reasonScrollPanel == null) {
			reasonScrollPanel = new JScrollPane();
			reasonScrollPanel.setViewportView(getListTable());
			reasonScrollPanel.setBounds(0, 0, 734, 280);
		}
		return reasonScrollPanel;
	}

	public BasePanel getListPanel() {
		if (ListPanel == null) {
			ListPanel = new BasePanel();
			ListPanel.setHeading("Sub Reason List");
			ListPanel.setBounds(new Rectangle(15, 140, 734, 280));
			ListPanel.add(getReasonScrollPane());
		}
		return ListPanel;
	}
}