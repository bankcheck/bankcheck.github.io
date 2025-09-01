/*
 * Created on February 14, 2019
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.layout.dialog;

import java.util.Date;

import com.google.gwt.user.datepicker.client.CalendarUtil;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PanelUtil;
import com.hkah.shared.constants.ConstantsErrorMessage;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
@SuppressWarnings("serial")
public class DlgQuotaCheck extends DialogBase {

	private final static int m_frameWidth = 350;
	private final static int m_frameHeight = 350;
	private final static String SEARCH_VALUE = "Search";

	private BasePanel quotaCheckPanel = null;
	private LabelBase initialAssessedDESC = null;
	private ComboBoxBase initialAssessed = null;
	private LabelBase dateFromDESC = null;
	private TextDate dateFrom = null;
	private LabelBase dateToDESC = null;
	private TextDate dateTo = null;
	private JScrollPane quotaCheckScrollPane = null;
	private TableList quotaCheckListTable = null;

	private String currDate = null;
	private String toSearchDate = null;

	public DlgQuotaCheck(MainFrame owner) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);

		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Quota Check");
		setPosition(320, 150);
		setContentPane(getquotaCheckPanel());
	}

	@Override
	public ComboBoxBase getDefaultFocusComponent() {
		return getInitialAssessed();
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String specCode) {
		setVisible(true);

		getInitialAssessed().setEditable(true);
		getquotaCheckListTable().removeAllRow();
		PanelUtil.resetAllFields(getquotaCheckPanel());

		if (TWAH_VALUE.equals(getUserInfo().getSiteCode())) {
			getInitialAssessedDESC().setText("Nature of Visit");
		}

		// change label
		getButtonById(DialogBase.OK).setText(SEARCH_VALUE, 'S');

		currDate = getMainFrame().getServerDate();

		// limit the date selection
		Date toSearchDateInDate = null;
		try {
			toSearchDateInDate = DateTimeUtil.parseDate(currDate);
			CalendarUtil.addDaysToDate(toSearchDateInDate, 7);
			toSearchDate = DateTimeUtil.formatDate(toSearchDateInDate);
		} catch (Exception e) {
		}

		getDateFrom().setText(currDate);
		getDateTo().setText(toSearchDate);
	}

	@Override
	public void doOkAction() {
		if (getInitialAssessed().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please select nature of visit.", getInitialAssessed());
			return;
		} else if (getDateFrom().isEmpty()) {
			Factory.getInstance().addErrorMessage("The start date must be entered.", getDateFrom());
			return;
		} else if (getDateTo().isEmpty()) {
			Factory.getInstance().addErrorMessage("The end date must be entered.", getDateTo());
			return;
		}

		getquotaCheckListTable().setListTableContent(
				"BOOKINGALERT",
				new String[] { getInitialAssessed().getText().trim(), getDateFrom().getText().trim(), getDateTo().getText().trim() }
		);
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getquotaCheckPanel() {
		if (quotaCheckPanel == null) {
			quotaCheckPanel = new BasePanel();
			quotaCheckPanel.setBounds(5, 5, 330, 305);
			quotaCheckPanel.add(getInitialAssessedDESC(), null);
			quotaCheckPanel.add(getInitialAssessed(), null);
			quotaCheckPanel.add(getDateFromDESC(), null);
			quotaCheckPanel.add(getDateFrom(), null);
			quotaCheckPanel.add(getDateToDESC(), null);
			quotaCheckPanel.add(getDateTo(), null);
			quotaCheckPanel.add(getquotaCheckScrollPane(), null);
		}
		return quotaCheckPanel;
	}

	public LabelBase getInitialAssessedDESC() {
		if (initialAssessedDESC == null) {
			initialAssessedDESC = new LabelBase();
			initialAssessedDESC.setBounds(25, 10, 80, 20);
			initialAssessedDESC.setText("Initial Assessed");
		}
		return initialAssessedDESC;
	}

	public ComboBoxBase getInitialAssessed() {
		if (initialAssessed == null) {
			initialAssessed = new ComboBoxBase("ALERTSRC_QUOTA", false, false, true);
			initialAssessed.setBounds(115, 10, 180, 20);
		}
		return initialAssessed;
	}

	public LabelBase getDateFromDESC() {
		if (dateFromDESC == null) {
			dateFromDESC = new LabelBase();
			dateFromDESC.setBounds(25, 35, 80, 20);
			dateFromDESC.setText("Date From");
		}
		return dateFromDESC;
	}

	public TextDate getDateFrom() {
		if (dateFrom == null) {
			dateFrom = new TextDate();
			dateFrom.setBounds(115, 35, 180, 20);
		}
		return dateFrom;
	}

	public LabelBase getDateToDESC() {
		if (dateToDESC == null) {
			dateToDESC = new LabelBase();
			dateToDESC.setText("Date To");
			dateToDESC.setBounds(25, 60, 90, 20);
		}
		return dateToDESC;
	}

	public TextDate getDateTo() {
		if (dateTo == null) {
			dateTo = new TextDate();
			dateTo.setBounds(115, 60, 180, 20);
		}
		return dateTo;
	}

	public TableList getquotaCheckListTable() {
		if (quotaCheckListTable == null) {
			quotaCheckListTable = new TableList(getQuotaCheckColumnNames(), getQuotaCheckColumnWidths()) {
				@Override
				public void setListTableContentPost() {
					// override for the child class
					if (getquotaCheckListTable().getRowCount() == 0) {
						Factory.getInstance().addErrorMessage(ConstantsErrorMessage.NO_RECORD_FOUND);
					}
				}
			};
			//quotaCheckListTable.setTableLength(getListWidth());
		}
		return quotaCheckListTable;
	}

	public JScrollPane getquotaCheckScrollPane() {
		if (quotaCheckScrollPane == null) {
			quotaCheckScrollPane = new JScrollPane();
			quotaCheckScrollPane.setViewportView(getquotaCheckListTable());
			quotaCheckScrollPane.setBounds(0, 95, 310, 165);
		}
		return quotaCheckScrollPane;
	}

	private int[] getQuotaCheckColumnWidths() {
		return new int[] {10, 120, 160};
	}

	private String[] getQuotaCheckColumnNames() {
		return new String[] {EMPTY_VALUE, "Date", "Available"};
	}
}