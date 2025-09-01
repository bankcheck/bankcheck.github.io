/*
 * Created on October 15, 2014
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.data.ModelData;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboDoctorLocation;
import com.hkah.client.layout.combobox.ComboSpecialtyCode;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.util.PanelUtil;
import com.hkah.shared.constants.ConstantsErrorMessage;
import com.hkah.shared.constants.ConstantsTx;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
@SuppressWarnings("serial")
public abstract class DlgSlotSearch extends DialogBase {

    private final static int m_frameWidth = 350;
    private final static int m_frameHeight = 350;
    private final static String SEARCH_VALUE = "Search";
    private final static String OK_VALUE = "OK";

	private BasePanel slotSearchPanel = null;
	private LabelBase slotSearchSpecialityDESC = null;
	private ComboSpecialtyCode slotSearchSpeciality = null;
	private LabelBase slotSearchDescriptionDESC = null;
	private TextReadOnly slotSearchDescription = null;
	private LabelBase slotSearchDocLocationDESC = null;
	private ComboDoctorLocation slotSearchDocLocation = null;
	private JScrollPane slotSearchScrollPane = null;
	private TableList slotSearchListTable = null;

	private boolean searchMode = false;

	public DlgSlotSearch(MainFrame owner) {
        super(owner, OKCANCEL, m_frameWidth, m_frameHeight);

        initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Slot Search");
		setPosition(320, 150);
		setContentPane(getSlotSearchPanel());
	}

	@Override
	public ComboBoxBase getDefaultFocusComponent() {
		return getSlotSearchSpeciality();
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String specCode) {
		setVisible(true);
		searchMode = true;

		getSlotSearchSpeciality().setEditable(true);
		getSlotSearchListTable().removeAllRow();
		PanelUtil.resetAllFields(getSlotSearchPanel());

		// change label
		getButtonById(DialogBase.OK).setText(SEARCH_VALUE, 'S');

		if (specCode != null && specCode.length() > 0) {
			getSlotSearchSpeciality().removeAllItems();
			getSlotSearchSpeciality().addItem(specCode);
			getSlotSearchSpeciality().setText(specCode);
			getSlotSearchSpeciality().setEditable(false);
		} else {
			getSlotSearchSpeciality().resetContent(ConstantsTx.LIST_SPECIALTY_TXCODE);
		}
	}

	@Override
	public void doOkAction() {
		if (!searchMode) {
			post(getSlotSearchListTable().getSelectedRowContent());
			dispose();
		} else {
			if (!getSlotSearchSpeciality().isEmpty()) {
				getSlotSearchListTable().setListTableContent(
						ConstantsTx.SLOTBYSPEC_TXCODE,
						new String[] { getSlotSearchSpeciality().getText().trim(), getSlotSearchDocLocation().getText().trim(), getUserInfo().getSiteCode() }
				);
			} else {
				Factory.getInstance().addErrorMessage(ConstantsErrorMessage.NO_RECORD_FOUND);
			}
		}
	}

	protected abstract void post(String[] para);

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getSlotSearchPanel() {
		if (slotSearchPanel == null) {
			slotSearchPanel = new BasePanel();
			slotSearchPanel.setBounds(5, 5, 330, 305);
			slotSearchPanel.add(getSlotSearchSpecialityDESC(), null);
			slotSearchPanel.add(getSlotSearchSpeciality(), null);
			slotSearchPanel.add(getSlotSearchDescriptionDESC(), null);
			slotSearchPanel.add(getSlotSearchDescription(), null);
			slotSearchPanel.add(getSlotSearchDocLocationDESC(), null);
			slotSearchPanel.add(getSlotSearchDocLocation(), null);
			slotSearchPanel.add(getSlotSearchScrollPane(), null);
		}
		return slotSearchPanel;
	}

	public LabelBase getSlotSearchSpecialityDESC() {
		if (slotSearchSpecialityDESC == null) {
			slotSearchSpecialityDESC = new LabelBase();
			slotSearchSpecialityDESC.setBounds(25, 10, 80, 20);
			slotSearchSpecialityDESC.setText("Speciality");
		}
		return slotSearchSpecialityDESC;
	}

	public ComboSpecialtyCode getSlotSearchSpeciality() {
		if (slotSearchSpeciality == null) {
			slotSearchSpeciality = new ComboSpecialtyCode(getSlotSearchDescription()) {
				@Override
				public void initContent(String value) {
					// skip load from db
				}

				@Override
				protected void setTextPanel(ModelData modelData) {
					super.setTextPanel(modelData);
					if (modelData != null) {
						getButtonById(DialogBase.OK).setText(SEARCH_VALUE, 'S');
					}
				}
			};
			slotSearchSpeciality.setBounds(115, 10, 180, 20);
		}
		return slotSearchSpeciality;
	}

	public LabelBase getSlotSearchDescriptionDESC() {
		if (slotSearchDescriptionDESC == null) {
			slotSearchDescriptionDESC = new LabelBase();
			slotSearchDescriptionDESC.setBounds(25, 35, 80, 20);
			slotSearchDescriptionDESC.setText("Description");
		}
		return slotSearchDescriptionDESC;
	}

	public TextReadOnly getSlotSearchDescription() {
		if (slotSearchDescription == null) {
			slotSearchDescription = new TextReadOnly();
			slotSearchDescription.setBounds(115, 35, 180, 20);
		}
		return slotSearchDescription;
	}

	public LabelBase getSlotSearchDocLocationDESC() {
		if (slotSearchDocLocationDESC == null) {
			slotSearchDocLocationDESC = new LabelBase();
			slotSearchDocLocationDESC.setText("Doctor Location");
			slotSearchDocLocationDESC.setBounds(25, 60, 90, 20);
		}
		return slotSearchDocLocationDESC;
	}

	public ComboDoctorLocation getSlotSearchDocLocation() {
		if (slotSearchDocLocation == null) {
			slotSearchDocLocation = new ComboDoctorLocation();
			slotSearchDocLocation.setBounds(115, 60, 180, 20);
		}
		return slotSearchDocLocation;
	}

	public TableList getSlotSearchListTable() {
		if (slotSearchListTable == null) {
			slotSearchListTable = new TableList(getSlotSearchColumnNames(), getSlotSearchColumnWidths()) {
				@Override
				public void setListTableContentPost() {
					// override for the child class
					if (getSlotSearchListTable().getRowCount() > 0) {
						getButtonById(DialogBase.OK).setText(OK_VALUE, 'O');
						searchMode = false;
					} else {
						Factory.getInstance().addErrorMessage(ConstantsErrorMessage.NO_RECORD_FOUND);
					}
				}
			};
			//slotSearchListTable.setTableLength(getListWidth());
		}
		return slotSearchListTable;
	}

	public JScrollPane getSlotSearchScrollPane() {
		if (slotSearchScrollPane == null) {
			slotSearchScrollPane = new JScrollPane();
			slotSearchScrollPane.setViewportView(getSlotSearchListTable());
			slotSearchScrollPane.setBounds(0, 95, 310, 165);
		}
		return slotSearchScrollPane;
	}

	private int[] getSlotSearchColumnWidths() {
		return new int[] {10, 0, 90, 130, 65};
	}

	private String[] getSlotSearchColumnNames() {
		return new String[] {EMPTY_VALUE, "SCHID", "Doctor Code", "Time", "Duration"};
	}
}