/*
 * Created on February 14, 2019
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboSpecialtyCode;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsErrorMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
@SuppressWarnings("serial")
public class DlgRegistrationCheck extends DialogBase {

    private final static int m_frameWidth = 350;
    private final static int m_frameHeight = 350;
    private final static String SEARCH_VALUE = "Search";

	private BasePanel RegistrationCheckPanel = null;
	private LabelBase specialtyDESC = null;
	private ComboSpecialtyCode specialty = null;
	private LabelBase dateDESC = null;
	private TextDate dateFrom = null;
	private JScrollPane RegistrationCheckScrollPane = null;
	private TableList RegistrationCheckListTable = null;

	public DlgRegistrationCheck(MainFrame owner) {
        super(owner, OKCANCEL, m_frameWidth, m_frameHeight);

        initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Registration Check");
		setPosition(320, 150);
		setContentPane(getRegistrationCheckPanel());
	}

	@Override
	public ComboBoxBase getDefaultFocusComponent() {
		return getSpecialty();
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String specCode, String docCode) {
		setVisible(true);

		getSpecialty().setEditable(true);
		getRegistrationCheckListTable().removeAllRow();
		PanelUtil.resetAllFields(getRegistrationCheckPanel());

		// change label
		getButtonById(DialogBase.OK).setText(SEARCH_VALUE, 'S');

		if (specCode != null && specCode.length() > 0) {
			getSpecialty().setText(specCode);
		} else if (docCode != null && docCode.length() > 0) {
			QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] { "DOCTOR", "SPCCODE", "DOCCODE = '" + docCode + "'" },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						getSpecialty().setText(mQueue.getContentField()[0]);
					}
				}
			});
		}
		getDate().setText(getMainFrame().getServerDate());
	}

	@Override
	public void doOkAction() {
		if (getSpecialty().isEmpty()) {
			Factory.getInstance().addErrorMessage("Please select specialty.", getSpecialty());
			return;
		} else if (getDate().isEmpty()) {
			Factory.getInstance().addErrorMessage("The date must be entered.", getDate());
			return;
		}

		getRegistrationCheckListTable().setListTableContent(
				"REGISTRATIONCHECK",
				new String[] { getSpecialty().getText().trim(), getDate().getText().trim() }
		);
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getRegistrationCheckPanel() {
		if (RegistrationCheckPanel == null) {
			RegistrationCheckPanel = new BasePanel();
			RegistrationCheckPanel.setBounds(5, 5, 330, 305);
			RegistrationCheckPanel.add(getSpecialtyDESC(), null);
			RegistrationCheckPanel.add(getSpecialty(), null);
			RegistrationCheckPanel.add(getDateDESC(), null);
			RegistrationCheckPanel.add(getDate(), null);
			RegistrationCheckPanel.add(getRegistrationCheckScrollPane(), null);
		}
		return RegistrationCheckPanel;
	}

	public LabelBase getSpecialtyDESC() {
		if (specialtyDESC == null) {
			specialtyDESC = new LabelBase();
			specialtyDESC.setBounds(25, 10, 80, 20);
			specialtyDESC.setText("Specialty");
		}
		return specialtyDESC;
	}

	public ComboSpecialtyCode getSpecialty() {
		if (specialty == null) {
			specialty = new ComboSpecialtyCode();
			specialty.setBounds(115, 10, 180, 20);
		}
		return specialty;
	}

	public LabelBase getDateDESC() {
		if (dateDESC == null) {
			dateDESC = new LabelBase();
			dateDESC.setBounds(25, 35, 80, 20);
			dateDESC.setText("Date");
		}
		return dateDESC;
	}

	public TextDate getDate() {
		if (dateFrom == null) {
			dateFrom = new TextDate();
			dateFrom.setBounds(115, 35, 180, 20);
		}
		return dateFrom;
	}

	public TableList getRegistrationCheckListTable() {
		if (RegistrationCheckListTable == null) {
			RegistrationCheckListTable = new TableList(getRegistrationCheckColumnNames(), getRegistrationCheckColumnWidths()) {
				@Override
				public void setListTableContentPost() {
					// override for the child class
					if (getRegistrationCheckListTable().getRowCount() == 0) {
						Factory.getInstance().addErrorMessage(ConstantsErrorMessage.NO_RECORD_FOUND);
					}
				}
			};
			//RegistrationCheckListTable.setTableLength(getListWidth());
		}
		return RegistrationCheckListTable;
	}

	public JScrollPane getRegistrationCheckScrollPane() {
		if (RegistrationCheckScrollPane == null) {
			RegistrationCheckScrollPane = new JScrollPane();
			RegistrationCheckScrollPane.setViewportView(getRegistrationCheckListTable());
			RegistrationCheckScrollPane.setBounds(0, 75, 310, 185);
		}
		return RegistrationCheckScrollPane;
	}

	private int[] getRegistrationCheckColumnWidths() {
		return new int[] {10, 120, 160};
	}

	private String[] getRegistrationCheckColumnNames() {
		return new String[] {EMPTY_VALUE, "Doctor", "Registration"};
	}
}