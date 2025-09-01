package com.hkah.client.tx.cashier;

import com.extjs.gxt.ui.client.widget.Component;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.tx.SearchPanel;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;

public class CashierSessionHistory extends SearchPanel {
	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.CASHIERSESSIONHISTORY_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return "Cashier Session History";
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"Cashier",
			"User ID",
			"Start Time",
			"End Time",
			"No. of Reprint",
			"No. of Receipt Issued",
			"No. of Void",
			""
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				70,
				70,
				120,
				120,
				100,
				130,
				90,
				0
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	// property declare start
	private BasePanel searchPanel = null;
	private BasePanel paraPanel = null;
	private JScrollPane historyScrollPanel = null;
	private BasePanel ListPanel = null;
	private LabelSmallBase startDateDesc = null;
	private TextDate startDate = null;
	private LabelSmallBase endDateDesc = null;
	private TextDate endDate = null;
	private LabelSmallBase cashierCodeDesc = null;
	private TextReadOnly cashierCode = null;

	/**
	 * This method initializes
	 *
	 */
	public CashierSessionHistory() {
		super();
	}

	public boolean preAction() {
		if (!getUserInfo().isCashier()) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_NOT_CASHIER, "PBA-[Patient Business Administration System]");
			disableButton();
			return false;
		} else {
			return super.preAction();
		}
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getStartDate().setText(getMainFrame().getServerDate());
		getEndDate().setText(DateTimeUtil.getRollDate(getMainFrame().getServerDate(), 1));
		getCashierCode().setText(getUserInfo().getCashierCode());

		getListTable().setColumnAmount(4);
		getListTable().setColumnAmount(5);
		getListTable().setColumnAmount(6);

		enableButton();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		return getStartDate();
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		if (getStartDate().isEmpty() &&
				getEndDate().isEmpty()) {
			Factory.getInstance().addErrorMessage(MSG_INPUT_CRITERIA);
			return false;
		} else {
			return true;
		}
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getStartDate().getText(),
				getEndDate().getText(),
				getCashierCode().getText()
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
		doCashierHist_OnDataChanged();
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	private void doCashierHist_OnDataChanged() {
		disableButton();
		getSearchButton().setEnabled(true);
		getPrintButton().setEnabled(getListTable().getRowCount() > 0);
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	/**
	 * override performListPost method
	 */
	@Override
	protected void performListPost() {
		doCashierHist_OnDataChanged();
	}

	@Override
	protected void enableButton(String mode) {
		doCashierHist_OnDataChanged();
	}

	/*>>> override clearAction ======== <<<<*/
	@Override
	public void clearAction() {
		if (getClearButton().isEnabled()) {
			getStartDate().clear();
			getEndDate().clear();

			// copy from MasterPanelBase:
			// clear record found
			setRecordFound(false);

			enableButton();

			// call after all action done
			clearPostAction();

			// call focus component
			defaultFocus();
		}
	}

	@Override
	public void printAction() {
		if (getListTable().getSelectedRow() >= 0) {
			Cashiers.printReport(new String[] {
					getCashierCode().getText(),
					getListTable().getSelectedRowContent()[2],
					getListTable().getSelectedRowContent()[3],
					getListTable().getSelectedRowContent()[4],
					getListTable().getSelectedRowContent()[5],
					getListTable().getSelectedRowContent()[6],
					getListTable().getSelectedRowContent()[7]},
					YES_VALUE);
		} else {
			Factory.getInstance().addErrorMessage("Please select a record to print.", "PBA-[Cashier Session History]");
		}
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	@Override
	protected BasePanel getSearchPanel() {
		if (searchPanel == null) {
			searchPanel = new BasePanel();
			searchPanel.setSize(779, 528);
			searchPanel.add(getParaPanel());
			searchPanel.add(getListPanel());
		}
		return searchPanel;
	}

	public BasePanel getParaPanel() {
		if (paraPanel == null) {
			paraPanel = new BasePanel();
			paraPanel.setBorders(true);
			paraPanel.setBounds(10, 10, 757, 30);
			paraPanel.add(getStartDateDesc(), null);
			paraPanel.add(getStartDate(), null);
			paraPanel.add(getEndDateDesc(), null);
			paraPanel.add(getEndDate(), null);
			paraPanel.add(getCashierCodeDesc(), null);
			paraPanel.add(getCashierCode(), null);
		}
		return paraPanel;
	}

	/**
	 * This method initializes jScrollPane
	 *
	 * @return JScrollPane
	 */
	protected JScrollPane getHistoryScrollPanel() {
		if (historyScrollPanel == null) {
			getJScrollPane().removeViewportView(getListTable());
			historyScrollPanel = new JScrollPane();
			historyScrollPanel.setViewportView(getListTable());
			historyScrollPanel.setBounds(5, 5, 745, 425);
		}
		return historyScrollPanel;
	}

	public BasePanel getListPanel() {
		if (ListPanel == null) {
			ListPanel = new BasePanel();
			ListPanel.setEtchedBorder();
			ListPanel.setBounds(10, 50, 757, 438);
			ListPanel.add(getHistoryScrollPanel());
		}
		return ListPanel;
	}

	public LabelSmallBase getStartDateDesc() {
		if (startDateDesc == null) {
			startDateDesc = new LabelSmallBase();
			startDateDesc.setText("Start Date");
			startDateDesc.setBounds(5, 5, 100, 20);
		}
		return startDateDesc;
	}

	public TextDate getStartDate() {
		if (startDate == null) {
			startDate = new TextDate() {
				@Override
				public void onBlur() {
					super.onBlur();
					if (!isEmpty() && !isValid()) {
						clear();
					}
				};
			};
			startDate.setBounds(110, 5, 120, 20);
			startDate.setText(getMainFrame().getServerDate());
		}
		return startDate;
	}

	public LabelSmallBase getEndDateDesc() {
		if (endDateDesc == null) {
			endDateDesc = new LabelSmallBase();
			endDateDesc.setText("End Date");
			endDateDesc.setBounds(255, 5, 130, 20);
		}
		return endDateDesc;
	}

	public TextDate getEndDate() {
		if (endDate == null) {
			endDate = new TextDate() {
				@Override
				public void onBlur() {
					super.onBlur();
					if (!isEmpty() && !isValid()) {
						clear();
					}
				};
			};
			endDate.setBounds(370, 5, 120, 20);
			endDate.setText(DateTimeUtil.getRollDate(getMainFrame().getServerDate()));
		}
		return endDate;
	}

	public LabelSmallBase getCashierCodeDesc() {
		if (cashierCodeDesc == null) {
			cashierCodeDesc = new LabelSmallBase();
			cashierCodeDesc.setText("Cashier Code");
			cashierCodeDesc.setBounds(515, 5, 130, 20);
		}
		return cashierCodeDesc;
	}

	public TextReadOnly getCashierCode() {
		if (cashierCode == null) {
			cashierCode = new TextReadOnly();
			cashierCode.setBounds(630, 5, 120, 20);
		}
		return cashierCode;
	}
}