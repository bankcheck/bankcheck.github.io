package com.hkah.client.layout.dialogsearch;

import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboDocType;
import com.hkah.client.layout.combobox.ComboSex;
import com.hkah.client.layout.dialog.DialogSearchBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.textfield.SearchTriggerField;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextSpecialtySearch;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;

public class DlgDoctorSearch extends DialogSearchBase {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.DOCTORSEARCH_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.DOCTORSEARCH_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"",
				"MSTR Doc Code",            // 0
				"Doctor Code",              // 1
				"Family Name",              // 2
				"Given Name",               // 3
				"Company",                  // 4
				"Sex",                      // 5
				"Specialty Name",           // 6
				"Specialty Code",           // 7
				"Mobile Phone",             // 8
				"Pager",                    // 9
				"Home Phone",               // 10
				"Office Phone",             // 11
				"Email",                    // 12
				"Doctor Type",              // 13
				"Office Address line 1",    // 14
				"Office Address line 2",    // 15
				"Office Address line 3",    // 16
				"Office Address line 4",    // 17
				"Admission Expiry Date"     // 18
			};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				10,
				80,                         // 0
				70,                         // 1
				80,                         // 2
				120,                        // 3
				150,                        // 4
				50,                         // 5
				100,                        // 6
				80,                         // 7
				100,                        // 8
				80,                         // 9
				80,                         // 10
				80,                         // 11
				80,                         // 12
				80,                         // 13
				150,                        // 14
				150,                        // 15
				150,                        // 16
				150,                        // 17
				100                         // 18
			};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel searchPanel = null;
	private FieldSetBase columnPanel = null;
	private LabelSmallBase LeftJLabel_DoctorCode = null;
	private TextString LeftJText_DoctorCode = null;
	private LabelSmallBase LeftJLabel_DoctorFamilyName = null;
	private TextString LeftJText_DoctorFamilyName = null;
	private LabelSmallBase LeftJLabel_DoctorGivenName = null;
	private TextString LeftJText_DoctorGivenName = null;
	private LabelSmallBase LeftJLabel_Sex = null;
	private ComboSex LeftJCombo_Sex = null;
	private ComboDocType LeftCombo_Type = null;
	private LabelSmallBase LeftJLabel_Type = null;
	private LabelSmallBase LeftJLabel_SpecialityCode = null;
	private TextSpecialtySearch LeftJText_SpecialityCode = null;
	private LabelSmallBase LeftJLabel_DOB = null;
	private LabelSmallBase LeftJLabel_Active = null;
	private CheckBoxBase LeftJCheck_Active = null;
	private TextDate LeftJText_DOB = null;
	private JScrollPane doctorScrollPane = null;
	private TextReadOnly docNameField = null;
	private LabelSmallBase LeftJLabel_Company = null;
	private TextString LeftJText_Company = null;
	private LabelSmallBase LeftJLabel_MstrDocCode = null;
	private TextString LeftJText_MstrDocCode = null;
	private LabelSmallBase LeftJLabel_Email = null;
	private TextString LeftJText_Email = null;
	private boolean filterDocCode = false;

	private final int Col_0 = 0;
	private final int Col_DOCMSTRCODE = 1;
	private final int Col_DOCCODE = 2;
	private final int Col_DOCFNAME = 3;
	private final int Col_DOCGNAME = 4;
	private final int Col_DOCCOMPANY = 5;
	private final int Col_DOCSEX = 6;
	private final int Col_DOCSPECNAME = 7;
	private final int Col_DOCSPECCODE = 8;
	private final int Col_DOCMPHONE = 9;
	private final int Col_DOCPAGER = 10;
	private final int Col_DOCHPHONE = 11;
	private final int Col_DOCOPHONE = 12;
	private final int Col_DOCEMAIL = 13;
	private final int Col_DOCTYPE = 14;
	private final int Col_DOCADD1 = 15;
	private final int Col_DOCADD2 = 16;
	private final int Col_DOCADD3 = 17;
	private final int Col_DOCADD4 = 18;
	private final int Col_DOCADMEXPDATE = 19;

	public DlgDoctorSearch(SearchTriggerField textField) {
		this(textField, null, false);
	}

	public DlgDoctorSearch(SearchTriggerField textField, TextReadOnly docNameField, boolean filterDocCode) {
		super(textField, 780, 540);
		this.docNameField = docNameField;
		this.filterDocCode = filterDocCode;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getLeftPanel().setPosition(10, 20);
		getListTable().setColumnClass(Col_DOCSEX, new ComboSex(), false);
		getListTable().setColumnClass(Col_DOCTYPE , new ComboDocType(), false);
		disableButton();
		getSearchButton().setEnabled(true);
		getClearButton().setEnabled(true);
		getLeftJCheck_Active().setSelected(true);
		getRightPanel().setVisible(false);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		disableButton();
		getSearchButton().setEnabled(true);
		getClearButton().setEnabled(true);
		if (getListTable().getRowCount() > 0) {
			getAcceptButton().setEnabled(true);
		} else {
			getAcceptButton().setEnabled(false);
		}
		return getLeftJText_DoctorCode();
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getLeftJText_DoctorCode().getText().toUpperCase(),
				getLeftJText_DoctorFamilyName().getText().toUpperCase(),
				getLeftJText_DoctorGivenName().getText().toUpperCase(),
				getLeftJCombo_Sex().getText().toUpperCase(),
				getLeftCombo_Type().getText().toUpperCase(),
				getLeftJText_SpecialityCode().getText().toUpperCase(),
				getLeftJText_DOB().getText(),
				getLeftJCheck_Active().isSelected()?"-1":"0",
				getLeftJText_Company().getText().toUpperCase(),
				getRightJText_MstrDocCode().getText(),
				getLeftJText_Email().getText(),
				filterDocCode?"Y":"N"
		};
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		String[] selectedContent = getListSelectedRow();
		return new String[] {
				selectedContent[Col_DOCCODE]
		};
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected boolean isSearchFieldsEmpty() {
		return getLeftJText_DoctorCode().isEmpty()
			&& getLeftJText_DoctorFamilyName().isEmpty()
			&& getLeftJText_DoctorGivenName().isEmpty()
			&& getLeftJCombo_Sex().isEmpty()
			&& getLeftCombo_Type().isEmpty()
			&& getLeftJText_SpecialityCode().isEmpty()
			&& getLeftJText_DOB().isEmpty()
			&& getLeftJText_Company().isEmpty()
			&& getRightJText_MstrDocCode().isEmpty()
			&& getLeftJText_Email().isEmpty();
	}

	@Override
	protected String getInputCriteriaMessage() {
		return ConstantsMessage.MSG_INPUT_CRITERIA;
	}

	@Override
	public void showPanel() {
		super.showPanel();
		getLeftJCheck_Active().setSelected(true);
		if (getListTable().getRowCount() > 0) {
			getAcceptButton().setEnabled(true);
		} else {
			getAcceptButton().setEnabled(false);
		}
	}

	@Override
	public int acceptTableColumn() {
		return Col_DOCCODE;
	}

	@Override
	protected void acceptPostAction() {
		if (docNameField != null) {
			docNameField.setText(getListTable().getSelectedRowContent()[Col_DOCFNAME] + " " + getListTable().getSelectedRowContent()[Col_DOCGNAME]);
		}
	}

	@Override
	protected boolean triggerSearchField() {
		if (getLeftJText_SpecialityCode().isFocusOwner()) {
			getLeftJText_SpecialityCode().checkTriggerBySearchKey();
			return true;
		} else {
			return false;
		}
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	protected BasePanel getSearchPanel() {
		if (searchPanel == null) {
			searchPanel = new BasePanel();
			searchPanel.add(getDoctorSearchPanel(), null);
			searchPanel.add(getDoctorScrollPanel());
			searchPanel.setSize(800, 300);
		}
		return searchPanel;
	}

	/**
	 * This method initializes leftPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected FieldSetBase getDoctorSearchPanel() {
		if (columnPanel == null) {
			columnPanel = new FieldSetBase();
			columnPanel.setBounds(10, 10, 734, 135);
			columnPanel.setHeading("Doctor Information");
			columnPanel.add(getLeftJLabel_DoctorCode(), null);
			columnPanel.add(getLeftJText_DoctorCode(), null);
			columnPanel.add(getLeftJLabel_DoctorFamilyName(), null);
			columnPanel.add(getLeftJText_DoctorFamilyName(), null);
			columnPanel.add(getLeftJLabel_DoctorGivenName(), null);
			columnPanel.add(getLeftJText_DoctorGivenName(), null);
			columnPanel.add(getLeftJLabel_MstrDocCode(), null);
			columnPanel.add(getRightJText_MstrDocCode(), null);
			columnPanel.add(getLeftJLabel_Type(), null);
			columnPanel.add(getLeftCombo_Type(), null);
			columnPanel.add(getLeftJLabel_SpecialityCode(), null);
			columnPanel.add(getLeftJText_SpecialityCode(), null);
			columnPanel.add(getLeftJLabel_DOB(), null);
			columnPanel.add(getLeftJText_DOB(), null);
			columnPanel.add(getLeftJLabel_Sex(), null);
			columnPanel.add(getLeftJCombo_Sex(), null);
			columnPanel.add(getLeftJLabel_Company(), null);
			columnPanel.add(getLeftJText_Company(), null);
			columnPanel.add(getLeftJLabel_Active(), null);
			columnPanel.add(getLeftJCheck_Active(), null);
			columnPanel.add(getLeftJLabel_Email(), null);
			columnPanel.add(getLeftJText_Email(), null);
		}
		return columnPanel;
	}

	private LabelSmallBase getLeftJLabel_DoctorCode() {
		if (LeftJLabel_DoctorCode == null) {
			LeftJLabel_DoctorCode = new LabelSmallBase();
			LeftJLabel_DoctorCode.setBounds(10, 0, 78, 20);
			LeftJLabel_DoctorCode.setText("Doctor Code ");
		}
		return LeftJLabel_DoctorCode;
	}

	/**
	 * This method initializes LeftJText_DoctorCode
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextString getLeftJText_DoctorCode() {
		if (LeftJText_DoctorCode == null) {
			LeftJText_DoctorCode = new TextString();
			LeftJText_DoctorCode.setBounds(100, 0, 120, 20);
		}
		return LeftJText_DoctorCode;
	}

	/**
	 * This method initializes LeftJLabel_DoctorFamilyName
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getLeftJLabel_DoctorFamilyName() {
		if (LeftJLabel_DoctorFamilyName == null) {
			LeftJLabel_DoctorFamilyName = new LabelSmallBase();
			LeftJLabel_DoctorFamilyName.setBounds(251, 0, 83, 20);
			LeftJLabel_DoctorFamilyName.setText("Family Name ");
		}
		return LeftJLabel_DoctorFamilyName;
	}

	/**
	 * This method initializes LeftJText_DoctorFamilyName
	 *
	 * @return com.hkah.client.layout.textfield.TextName
	 */
	private TextString getLeftJText_DoctorFamilyName() {
		if (LeftJText_DoctorFamilyName == null) {
			LeftJText_DoctorFamilyName = new TextString();
			LeftJText_DoctorFamilyName.setBounds(335, 0, 120, 20);
		}
		return LeftJText_DoctorFamilyName;
	}

	/**
	 * This method initializes LeftJLabel_DoctorGivenName
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getLeftJLabel_DoctorGivenName() {
		if (LeftJLabel_DoctorGivenName == null) {
			LeftJLabel_DoctorGivenName = new LabelSmallBase();
			LeftJLabel_DoctorGivenName.setBounds(485, 0, 90, 20);
			LeftJLabel_DoctorGivenName.setText("Given Name ");
		}
		return LeftJLabel_DoctorGivenName;
	}

	/**
	 * This method initializes LeftJText_DoctorGivenName
	 *
	 * @return com.hkah.client.layout.textfield.TextName
	 */
	private TextString getLeftJText_DoctorGivenName() {
		if (LeftJText_DoctorGivenName == null) {
			LeftJText_DoctorGivenName = new TextString();
			LeftJText_DoctorGivenName.setBounds(580, 0, 130, 20);
		}
		return LeftJText_DoctorGivenName;
	}

	private LabelSmallBase getLeftJLabel_MstrDocCode() {
		if (LeftJLabel_MstrDocCode == null) {
			LeftJLabel_MstrDocCode = new LabelSmallBase();
			LeftJLabel_MstrDocCode.setBounds(10, 25, 78, 20);
			LeftJLabel_MstrDocCode.setText("MSTR Doc Code ");
		}
		return LeftJLabel_MstrDocCode;
	}

	private TextString getRightJText_MstrDocCode() {
		if (LeftJText_MstrDocCode == null) {
			LeftJText_MstrDocCode = new TextString();
			LeftJText_MstrDocCode.setBounds(100, 25, 120, 20);
		}
		return LeftJText_MstrDocCode;
	}

	/**
	 * This method initializes LeftJLabel_Type
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getLeftJLabel_Type() {
		if (LeftJLabel_Type == null) {
			LeftJLabel_Type = new LabelSmallBase();
			LeftJLabel_Type.setBounds(251, 25, 83, 20);
			LeftJLabel_Type.setText("Type ");
		}
		return LeftJLabel_Type;
	}

	/**
	 * This method initializes LeftCombo_DocType
	 *
	 * @return com.hkah.client.layout.combobox.ComboDocType
	 */
	private ComboDocType getLeftCombo_Type() {
		if (LeftCombo_Type == null) {
			LeftCombo_Type = new ComboDocType();
			LeftCombo_Type.setBounds(335, 25, 120, 20);
		}
		return LeftCombo_Type;
	}

	/**
	 * This method initializes LeftJLabel_SpecialityCode
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getLeftJLabel_SpecialityCode() {
		if (LeftJLabel_SpecialityCode == null) {
			LeftJLabel_SpecialityCode = new LabelSmallBase();
			LeftJLabel_SpecialityCode.setBounds(485, 25, 91, 20);
			LeftJLabel_SpecialityCode.setText("Speciality Code ");
		}
		return LeftJLabel_SpecialityCode;
	}

	/**
	 * This method initializes LeftJText_SpecialityCode
	 *
	 * @return com.hkah.client.layout.textfield.TextBase
	 */
	private TextSpecialtySearch getLeftJText_SpecialityCode() {
		if (LeftJText_SpecialityCode == null) {
			LeftJText_SpecialityCode = new TextSpecialtySearch();
			LeftJText_SpecialityCode.setBounds(580, 25, 130, 20);
		}
		return LeftJText_SpecialityCode;
	}

	/**
	 * This method initializes LeftJLabel_DOB
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getLeftJLabel_DOB() {
		if (LeftJLabel_DOB == null) {
			LeftJLabel_DOB = new LabelSmallBase();
			LeftJLabel_DOB.setBounds(10, 50, 75, 20);
			LeftJLabel_DOB.setText("DOB ");
		}
		return LeftJLabel_DOB;
	}

	/**
	 * This method initializes LeftJText_DOB
	 *
	 * @return com.hkah.client.layout.textfield.TextDate
	 */
	private TextDate getLeftJText_DOB() {
		if (LeftJText_DOB == null) {
			LeftJText_DOB = new TextDate();
			LeftJText_DOB.setBounds(100, 50, 120, 20);
		}
		return LeftJText_DOB;
	}

	/**
	 * This method initializes LeftJLabel_Sex
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getLeftJLabel_Sex() {
		if (LeftJLabel_Sex == null) {
			LeftJLabel_Sex = new LabelSmallBase();
			LeftJLabel_Sex.setBounds(251, 50, 83, 20);
			LeftJLabel_Sex.setText("Sex ");
		}
		return LeftJLabel_Sex;
	}

	/**
	 * This method initializes LeftJCombo_Sex
	 *
	 * @return com.hkah.client.layout.combobox.ComboSex
	 */
	private ComboSex getLeftJCombo_Sex() {
		if (LeftJCombo_Sex == null) {
			LeftJCombo_Sex = new ComboSex();
			LeftJCombo_Sex.setBounds(335, 50, 120, 20);
		}
		return LeftJCombo_Sex;
	}

	private LabelSmallBase getLeftJLabel_Company() {
		if (LeftJLabel_Company == null) {
			LeftJLabel_Company = new LabelSmallBase();
			LeftJLabel_Company.setBounds(485, 50, 91, 20);
			LeftJLabel_Company.setText("Company ");
		}
		return LeftJLabel_Company;
	}

	private TextString getLeftJText_Company() {
		if (LeftJText_Company == null) {
			LeftJText_Company = new TextString();
			LeftJText_Company.setBounds(580, 50, 130, 20);
		}
		return LeftJText_Company;
	}

	private LabelSmallBase getLeftJLabel_Email() {
		if (LeftJLabel_Email == null) {
			LeftJLabel_Email = new LabelSmallBase();
			LeftJLabel_Email.setBounds(10, 75, 100, 20);
			LeftJLabel_Email.setText("Email ");
		}
		return LeftJLabel_Email;
	}

	private TextString getLeftJText_Email() {
		if (LeftJText_Email == null) {
			LeftJText_Email = new TextString();
			LeftJText_Email.setBounds(100, 75, 200, 20);
		}
		return LeftJText_Email;
	}

	/**
	 * This method initializes LeftJLabel_Active
	 *
	 * @return com.hkah.client.layout.label.LabelSmallBase
	 */
	private LabelSmallBase getLeftJLabel_Active() {
		if (LeftJLabel_Active == null) {
			LeftJLabel_Active = new LabelSmallBase();
			LeftJLabel_Active.setBounds(485, 75, 78, 20);
			LeftJLabel_Active.setText("Active ");
		}
		return LeftJLabel_Active;
	}

	/**
	 * This method initializes LeftJCheckBox_Active
	 *
	 * @return com.hkah.client.layout.checkbox.CheckBoxBase
	 */
	private CheckBoxBase getLeftJCheck_Active() {
		if (LeftJCheck_Active == null) {
			LeftJCheck_Active = new CheckBoxBase();
			LeftJCheck_Active.setBounds(485, 75, 78, 20);
		}
		return LeftJCheck_Active;
	}

	/**
	 * This method initializes jScrollPane
	 *
	 * @return JScrollPane
	 */
	protected JScrollPane getDoctorScrollPanel() {
		if (doctorScrollPane == null) {
			doctorScrollPane = new JScrollPane();
			doctorScrollPane.setViewportView(getListTable());
			doctorScrollPane.setBounds(10, 155, 734, 280);
		}
		return doctorScrollPane;
	}
}