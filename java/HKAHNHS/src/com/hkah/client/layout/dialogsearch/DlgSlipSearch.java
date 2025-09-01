package com.hkah.client.layout.dialogsearch;

import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.dialog.DialogSearchBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.textfield.SearchTriggerField;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;

public class DlgSlipSearch extends DialogSearchBase {
	protected String dptCode = null;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		return ConstantsTx.SLIPSEARCH_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return "Slip Search Dialog";
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Slip No",
				"",
				"",
				"",
				"",
				"",
				"",
				"",
				"",
				"",
				"",
				"",
				"",
				"",
				"Registration Date",
				"",
				"Total Net Amount"
				};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
			120,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			0,
			120,
			0,
			120
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel searchPanel = null;
	private ColumnLayout columnPanel = null;

	private TextString slpno = null;
	private LabelSmallBase patNoDesc = null;
	private TextString patNo = null;
	private LabelSmallBase patNameDesc = null;
	private TextString patName = null;
	private JScrollPane itemScrollPanel = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */

	/**
	* This method initializes
	*
	*/
	public DlgSlipSearch(SearchTriggerField textfField) {
		super(textfField, 600, 450);

		dptCode = getUserInfo().getDeptCode();
		getSearchDialog().getButtonById(Dialog.YES).hide();
		getSearchDialog().getButtonById(Dialog.NO).setText("OK");
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		return getSlpno();
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getParameter("PatNo"),
				null,
				getParameter("SlpType"),
				getParameter("SlipSts"),
				null,
				null,
				null,
				(!getUserInfo().isPBO() ? dptCode : null)
		};
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected boolean isSearchFieldsEmpty() {
		return getPatNo().isEmpty()
			&& getPatName().isEmpty();
	}

	@Override
	protected String getInputCriteriaMessage() {
		return ConstantsMessage.MSG_INPUT_CRITERIA;
	}

	@Override
	public void showPanel() {
		super.showPanel();
		setValues();
		searchAction();
	}

	protected void setValues() {
		getPatNo().setText(getParameter("PatNo"));
		getPatName().setText(getParameter("PatFName") + " " + getParameter("PatGName"));
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/* >>> getter methods for init the Component start from here ================================== <<< */
	@Override
	protected BasePanel getSearchPanel() {
		if (searchPanel == null) {
			searchPanel = new BasePanel();
			searchPanel.add(getItemSearchPanel(), null);
			searchPanel.add(getItemScrollPane());
			searchPanel.setSize(600, 175);
		}
		return searchPanel;
	}

	protected ColumnLayout getItemSearchPanel() {
		if (columnPanel == null) {
			columnPanel = new ColumnLayout(4, 1, new int[] {250, 400, 250, 600});
			columnPanel.setBounds(15, 5, 600, 100);
			columnPanel.add(0, 0, getPatNoDesc());
			columnPanel.add(1, 0, getPatNo());
			columnPanel.add(2, 0, getPatNameDesc());
			columnPanel.add(3, 0, getPatName());
		}
		return columnPanel;
	}

	// dummy
	public TextString getSlpno() {
		if (slpno == null) {
			slpno = new TextString();
		}
		return slpno;
	}

	public LabelSmallBase getPatNoDesc() {
		if (patNoDesc == null) {
			patNoDesc = new LabelSmallBase();
			patNoDesc.setText("Patient No");
		}
		return patNoDesc;
	}

	public TextString getPatNo() {
		if (patNo == null) {
			patNo = new TextString();
			patNo.setEditable(false);
		}
		return patNo;
	}

	public LabelSmallBase getPatNameDesc() {
		if (patNameDesc == null) {
			patNameDesc = new LabelSmallBase();
			patNameDesc.setText("Patient Name");
		}
		return patNameDesc;
	}

	public TextString getPatName() {
		if (patName == null) {
			patName = new TextString();
			patName.setEditable(false);
		}
		return patName;
	}

	/**
	 * This method initializes itemScrollPanel
	 *
	 * @return JScrollPane
	 */
	protected JScrollPane getItemScrollPane() {
		if (itemScrollPanel == null) {
			itemScrollPanel = new JScrollPane();
			itemScrollPanel.setViewportView(getListTable());
			itemScrollPanel.setBounds(15, 80, 550, 285);
		}
		return itemScrollPanel;
	}
}