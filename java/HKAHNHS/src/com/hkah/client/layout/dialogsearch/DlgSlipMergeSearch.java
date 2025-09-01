package com.hkah.client.layout.dialogsearch;

import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.dialog.DialogSearchBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.textfield.SearchTriggerField;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;

public class DlgSlipMergeSearch extends DialogSearchBase {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		return ConstantsTx.TRANSACTION_DETAIL_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.SLIPMERGESEARCH_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				"Reg Date",
				"Slip No.",
				"Type",
				"Status",
				"AR Code",
				"AR Name",
				"Patient No",
				"Patient Family Name",
				"Patient Given Name",
				"Dr. Code",
				"Dr. Family Name",
				"Dr. Given Name",
				"Reg Date",
				"Discharge Date",
				"Total Charge",
				"Total Payment",
				"Total Net Amount",
				"User ID",
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE
			};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				0,
				0,
				0,
				0,
				80,
				40,
				45,
				60,
				60,
				0,
				0,
				0,
				55,
				90,
				0,
				110,
				110,
				75,
				80,
				95,
				0,
				0,
				0,
				0,
				0
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel searchPanel = null;

	private JScrollPane itemScrollPanel = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */

	/**
	* This method initializes
	*
	*/
	public DlgSlipMergeSearch(SearchTriggerField textfField) {
		super(textfField, 600, 450);

		getSearchDialog().getButtonById(Dialog.YES).hide();
		getSearchDialog().getButtonById(Dialog.CANCEL).setText("Cancel", 'C');
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		return null;
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getParameter("PatNo"),
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				EMPTY_VALUE,
				NO_VALUE,
				Factory.getInstance().getUserInfo().getUserID()
			};
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected boolean isSearchFieldsEmpty() {
		return false;
	}

	@Override
	protected String getInputCriteriaMessage() {
		return ConstantsMessage.MSG_INPUT_CRITERIA;
	}

	@Override
	public void showPanel() {
		super.showPanel();
		searchAction();
	}

	@Override
	public int acceptTableColumn() {
		return 4;
	}

	@Override
	public void cancelAction() {
		getSearchDialog().setVisible(false);
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/* >>> getter methods for init the Component start from here ================================== <<< */
	@Override
	protected BasePanel getSearchPanel() {
		if (searchPanel == null) {
			searchPanel = new BasePanel();
			searchPanel.add(getItemScrollPane());
			searchPanel.setSize(600, 175);
		}
		return searchPanel;
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
			itemScrollPanel.setBounds(5, 5, 555, 355);
		}
		return itemScrollPanel;
	}
}