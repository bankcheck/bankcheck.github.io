package com.hkah.client.layout.dialogsearch;

import com.extjs.gxt.ui.client.widget.Component;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.combobox.ComboOrderBy;
import com.hkah.client.layout.combobox.ComboSearchCriteria;
import com.hkah.client.layout.combobox.ComboSex;
import com.hkah.client.layout.dialog.DialogSearchBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.textfield.SearchTriggerField;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextPhone;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTableColumn;
import com.hkah.shared.constants.ConstantsTx;

public class DlgPatientSearch extends DialogSearchBase implements ConstantsTableColumn {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		return ConstantsTx.PATIENT_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return "Patient Business Administration System - [Patient Search]";
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Alert",			// ALERT
				"Patient No.",		// PATNO
				"Family Name",		// PATFNAME
				"Given Name",		// PATGNAME
				"Maiden Name",		// PATMNAME
				"Chinese Name",		// PATCNAME
				"EHR Family Name",	// E.EHRFNAME
				"EHR Given Name",	// E.EHRGNAME
				"Sex",				// PATSEX
				"Date of Birth",	// PATBDATE
				"",					// AGE
				"Mobile Phone",		// PATPAGER
				"Home Phone",		// PATHTEL
				"ID No.",			// PATIDNO
				"",					// PATIDCOUCODE
				"No. of Visit",		// PATVCNT
				"Last Visit",		// LASTUPD
				"",					// TITDESC
				"",					// PATMSTS
				"",					// RACDESC
				"",					// MOTHCODE
				"",					// PATSEX
				"",					// EDULEVEL
				"",					// RELIGIOUS
				"",					// DEATH
				"",					// OCCUPATION
				"",					// PATMOTHER
				"",					// PATNB
				"",					// PATSTS
				"",					// PATITP
				"",					// PATSTAFF
				"",					// PATSMS
				"",					// PATCHKID
				"",					// PATEMAIL
				"",					// PATOTEL
				"",					// PATFAXNO
				"",					// PATADD1
				"",					// PATADD2
				"",					// PATADD3
				"",					// LOCCODE
				"",					// DSTCODE
				"",					// COUCODE
				"",					// PATRMK
				"",					// LASTUPD
				"",					// USRID
				"",					// PATKNAME
				"",					// PATKHTEL
				"",					// PATKPTEL
				"",					// PATKRELA
				"",					// PATKOTEL
				"",					// PATKMTEL
				"",					// PATKEMAIL
				"",					// PATKADD
				"Long Family Name",	// PATLFNAME
				"Long Given name",	// PATLGNAME
				"",					// PATADDRMK
				"",					// USR.USRNAME
				"",					// ADDRMKMODDT
				"",					// REGID_L
				"",					// REGID_C
				"",					// PATPHOTO.PATNO
				"",					// PATMERCHT.TO_PATNO
				"",					// PATPAGERUPUSRNAME
				"",					// PATPAGERUPDT
				"",					// PATHTELUPUSRNAME
				"",					// PATHTELUPDT
				"",					// PATOTELUPUSRNAME
				"",					// PATOTELUPDT
				"",					// PATFAXNOUPUSRNAME
				"",					// PATFAXNOUPDT
				"",					// PATADDUPUSRNAME
				"",					// PATADDUPDT
				"",					// RMKUPUSRNAME
				"",					// RMKUPDT
				"",					// PATCHKIDUPUSRNAME
				"",					// PATCHKIDUPDT
				"", 				// DOCTYPE
				"",					// PATMKTSRC
				"",					// PATMKTRMK
				"",					// DENTALNO
				""					// PATMISCRMK
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				70,		// ALERT
				70,		// PATNO
				80,		// PATFNAME
				110,	// PATGNAME
				80,		// PATMNAME
				85,		// PATCNAME
				105, 	// E.EHRFNAME
				100,	// E.EHRGNAME
				35,		// PATSEX
				75,		// PATBDATE
				0,		// AGE
				80,		// PATPAGER
				80,		// PATHTEL
				60,		// PATIDNO
				0,		// PATIDCOUCODE
				65,		// PATVCNT
				75,		// LASTUPD
				0,		// TITDESC
				0,		// PATMSTS
				0,		// RACDESC
				0,		// MOTHCODE
				0,		// PATSEX
				0,		// EDULEVEL
				0,		// RELIGIOUS
				0,		// DEATH
				0,		// OCCUPATION
				0,		// PATMOTHER
				0,		// PATNB
				0,		// PATSTS
				0,		// PATITP
				0,		// PATSTAFF
				0,		// PATSMS
				0,		// PATCHKID
				0,		// PATEMAIL
				0,		// PATOTEL
				0,		// PATFAXNO
				0,		// PATADD1
				0,		// PATADD2
				0,		// PATADD3
				0,		// LOCCODE
				0,		// DSTCODE
				0,		// COUCODE
				0,		// PATRMK
				0,		// LASTUPD
				0,		// USRID
				0,		// PATKNAME
				0,		// PATKHTEL
				0,		// PATKPTEL
				0,		// PATKRELA
				0,		// PATKOTEL
				0,		// PATKMTEL
				0,		// PATKEMAIL
				0,		// PATKADD
				HKAH_VALUE.equals(Factory.getInstance().getUserInfo().getSiteCode())?110:0,	// PATLFNAME
				HKAH_VALUE.equals(Factory.getInstance().getUserInfo().getSiteCode())?120:0,	// PATLGNAME
				0,		// PATADDRMK
				0,		// USR.USRNAME
				0,		// ADDRMKMODDT
				0,		// REGID_L
				0,		// REGID_C
				0,		// PATPHOTO.PATNO
				0,		// PATMERCHT.TO_PATNO
				0,		// PATPAGERUPUSRNAME
				0,		// PATPAGERUPDT
				0,		// PATHTELUPUSRNAME
				0,		// PATHTELUPDT
				0,		// PATOTELUPUSRNAME
				0,		// PATOTELUPDT
				0,		// PATFAXNOUPUSRNAME
				0,		// PATFAXNOUPDT
				0,		// PATADDUPUSRNAME
				0,		// PATADDUPDT
				0,		// RMKUPUSRNAME
				0,		// RMKUPDT
				0,		// PATCHKIDUPUSRNAME
				0,		// PATCHKIDUPDT
				0,		// DOCTYPE
				0,		// PATMKTSRC
				0,		// PATMKTRMK
				0,		// DENTALNO
				0		// PATMISCRMK
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel searchPanel = null;

	private BasePanel CrPanel1 = null;	// criteria part 1 panel
	private LabelSmallBase CrJLabel_PATNO = null;
	private TextString CrJText_PATNO = null;
	private LabelSmallBase CrJLabel_PATIDNO = null;
	private TextString CrJText_PATIDNO = null;
//	private LabelSmallBase CrJLabel_PATHTEL = null;	// Home Phone
//	private TextPhone CrJText_PATHTEL = null;
	private LabelSmallBase CrJLabel_PATBDATE = null;
	private TextDate CrJText_PATBDATE = null;
	private LabelSmallBase CrJLabel_PATSex = null;
	private ComboSex CrJCombo_PATSex = null;
//	private LabelSmallBase CrJLabel_PATMTEL = null;	// Home Phone
//	private TextPhone CrJText_PATMTEL = null;
	private LabelSmallBase CrJLabel_PATTEL = null;
	private TextPhone CrJText_PATTEL = null;

	private BasePanel CrPanel2 = null;	// criteria part 2 panel
	private LabelSmallBase CrJLabel_PATFNAME = null;
	private TextString CrJText_PATFNAME = null;
	private LabelSmallBase CrJLabel_PATGNAME = null;
	private TextString CrJText_PATGNAME = null;
	private LabelSmallBase CrJLabel_PATMNAME = null;
	private TextString CrJText_PATMNAME = null;
	private LabelSmallBase CrJLabel_PATCNAME = null;
	private TextString CrJText_PATCNAME = null;
	private LabelSmallBase CrJLabel_SCR = null;	//Search Criteria
	private ComboSearchCriteria CrJCombo_SCR = null;
	private LabelSmallBase CrJLabel_OrdBy = null;
	private ComboOrderBy CrJCombo_OrdBy = null;

	private JScrollPane patientScrollPanel = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */

	public DlgPatientSearch(SearchTriggerField textfField) {
		super(textfField);
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getListTable().setColumnColor(PATIENT_ALERT, "red");
		getListTable().setColumnClass(PATIENT_SEX, new ComboSex(), false);
		getListTable().setColumnAmount(PATIENT_NO_OF_VISIT);
		getCrJText_PATNO().focus();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public Component getDefaultFocusComponent() {
		return getCrJText_PATNO();
	}
	
	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		if (!getCrJText_PATBDATE().isEmpty() && !getCrJText_PATBDATE().isValid()) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_INVALID_DATE, getCrJText_PATBDATE());
			return false;
		} else {
			return super.browseValidation();
		}
	}	

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				QueryUtil.ACTION_BROWSE,
				getCrJText_PATNO().getText().trim(),
				getCrJText_PATIDNO().getText().trim(),
				EMPTY_VALUE, //getCrJText_PATHTEL().getText().trim(),
				getCrJText_PATBDATE().getText().trim(),
				getCrJCombo_PATSex().isValid() ? getCrJCombo_PATSex().getText().trim() : getCrJCombo_PATSex().getRawValue(),
				EMPTY_VALUE, //getCrJText_PATMTEL().getText().trim(),
				getCrJText_PATFNAME().getText().trim(),
				getCrJText_PATGNAME().getText().trim(),
				getCrJText_PATMNAME().getText().trim(),
				getCrJText_PATCNAME().getText().trim(),
				getCrJCombo_SCR().isValid() ? getCrJCombo_SCR().getText().trim() : getCrJCombo_SCR().getRawValue(),
				getCrJCombo_OrdBy().isValid() ? getCrJCombo_OrdBy().getText().trim() : getCrJCombo_OrdBy().getRawValue(),
				getCrJText_PATTEL().getText().trim(),
				getUserInfo().getUserID()
			};
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected boolean isSearchFieldsEmpty() {
		return getCrJText_PATNO().isEmpty()
				&& getCrJText_PATIDNO().isEmpty()
//				&& getCrJText_PATHTEL().isEmpty()
				&& getCrJText_PATBDATE().isEmpty()
				&& getCrJCombo_PATSex().isEmpty()
//				&& getCrJText_PATMTEL().isEmpty()
				&& getCrJText_PATFNAME().isEmpty()
				&& getCrJText_PATGNAME().isEmpty()
				&& getCrJText_PATMNAME().isEmpty()
				&& getCrJText_PATCNAME().isEmpty()
				&& getCrJText_PATTEL().isEmpty();
	}

	@Override
	protected String getInputCriteriaMessage() {
		return ConstantsMessage.MSG_INPUT_CRITERIA;
	}

	@Override
	public int acceptTableColumn() {
		return PATIENT_NUMBER;
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/* >>> getter methods for init the Component start from here ================================== <<< */
	@Override
	protected BasePanel getSearchPanel() {
		if (searchPanel == null) {
			searchPanel = new BasePanel();
			searchPanel.add(getCrPanel1(), null);
			searchPanel.add(getCrPanel2(), null);
			searchPanel.add(getPatientScrollPanel(), null);
			searchPanel.setSize(800, 205);
		}
		return searchPanel;
	}

	// Left Search criteria part1
	public BasePanel getCrPanel1() {
		if (CrPanel1 == null) {
			CrPanel1 = new BasePanel();
			CrPanel1.setTitledBorder();
			CrPanel1.add(getCrJLabel_PATNO(), null);
			CrPanel1.add(getCrJText_PATNO(), null);
			CrPanel1.add(getCrJLabel_PATIDNO(), null);
			CrPanel1.add(getCrJText_PATIDNO(), null);
//			CrPanel1.add(getCrJLabel_PATHTEL(), null);
//			CrPanel1.add(getCrJText_PATHTEL(), null);
			CrPanel1.add(getCrJLabel_PATBDATE(), null);
			CrPanel1.add(getCrJText_PATBDATE(), null);
			CrPanel1.add(getCrJLabel_PATSex(), null);
			CrPanel1.add(getCrJCombo_PATSex(), null);
//			CrPanel1.add(getCrJLabel_PATMTEL(), null);
//			CrPanel1.add(getCrJText_PATMTEL(), null);
			CrPanel1.add(getCrJLabel_PATTEL(), null);
			CrPanel1.add(getCrJText_PATTEL(), null);
			CrPanel1.setBounds(10, 10, 734, 60);
		}
		return CrPanel1;
	}

	private LabelSmallBase getCrJLabel_PATNO() {
		if (CrJLabel_PATNO == null) {
			CrJLabel_PATNO = new LabelSmallBase();
			CrJLabel_PATNO.setText("Patient No.");
			CrJLabel_PATNO.setBounds(4, 5, 100, 20);
		}
		return CrJLabel_PATNO;
	}

	public TextString getCrJText_PATNO() {
		if (CrJText_PATNO == null) {
			CrJText_PATNO = new TextString();
			CrJText_PATNO.setBounds(99, 5, 120, 20);
		}
		return CrJText_PATNO;
	}

	private LabelSmallBase getCrJLabel_PATIDNO() {
		if (CrJLabel_PATIDNO == null) {
			CrJLabel_PATIDNO = new LabelSmallBase();
			CrJLabel_PATIDNO.setText("ID/Passport No.");
			CrJLabel_PATIDNO.setBounds(234, 5, 100, 20);
		}
		return CrJLabel_PATIDNO;
	}

	public TextString getCrJText_PATIDNO() {
		if (CrJText_PATIDNO == null) {
			CrJText_PATIDNO = new TextString(20, true);
			CrJText_PATIDNO.setBounds(339, 5, 120, 20);
		}
		return CrJText_PATIDNO;
	}

	private LabelSmallBase getCrJLabel_PATSex() {
		if (CrJLabel_PATSex == null) {
			CrJLabel_PATSex = new LabelSmallBase();
			CrJLabel_PATSex.setText("Sex");
			CrJLabel_PATSex.setBounds(474, 5, 100, 20);
		}
		return CrJLabel_PATSex;
	}

	private ComboSex getCrJCombo_PATSex() {
		if (CrJCombo_PATSex == null) {
			CrJCombo_PATSex = new ComboSex();
			CrJCombo_PATSex.setBounds(569, 5, 120, 20);
		}
		return CrJCombo_PATSex;
	}
/*
	private LabelSmallBase getCrJLabel_PATHTEL() {
		if (CrJLabel_PATHTEL == null) {
			CrJLabel_PATHTEL = new LabelSmallBase();
			CrJLabel_PATHTEL.setText("Home Phone");
			CrJLabel_PATHTEL.setBounds(464, 5, 100, 20);
		}
		return CrJLabel_PATHTEL;
	}

	public TextPhone getCrJText_PATHTEL() {
		if (CrJText_PATHTEL == null) {
			CrJText_PATHTEL = new TextPhone();
			CrJText_PATHTEL.setBounds(569, 5, 120, 20);
		}
		return CrJText_PATHTEL;
	}
*/
	private LabelSmallBase getCrJLabel_PATBDATE() {
		if (CrJLabel_PATBDATE == null) {
			CrJLabel_PATBDATE = new LabelSmallBase();
			CrJLabel_PATBDATE.setText("Date of Birth");
			CrJLabel_PATBDATE.setBounds(4, 30, 100, 20);
		}
		return CrJLabel_PATBDATE;
	}

	public TextDate getCrJText_PATBDATE() {
		if (CrJText_PATBDATE == null) {
			CrJText_PATBDATE = new TextDate();
			CrJText_PATBDATE.setBounds(99, 30, 120, 20);
		}
		return CrJText_PATBDATE;
	}
/*
	private LabelSmallBase getCrJLabel_PATMTEL() {
		if (CrJLabel_PATMTEL == null) {
			CrJLabel_PATMTEL = new LabelSmallBase();
			CrJLabel_PATMTEL.setText("Mobile Phone");
			CrJLabel_PATMTEL.setBounds(464, 30, 100, 20);
		}
		return CrJLabel_PATMTEL;
	}

	public TextPhone getCrJText_PATMTEL() {
		if (CrJText_PATMTEL == null) {
			CrJText_PATMTEL = new TextPhone();
			CrJText_PATMTEL.setBounds(569, 30, 120, 20);
		}
		return CrJText_PATMTEL;
	}
*/
	private LabelSmallBase getCrJLabel_PATTEL() {
		if (CrJLabel_PATTEL == null) {
			CrJLabel_PATTEL = new LabelSmallBase();
			CrJLabel_PATTEL.setText("Home No. / Mobile No. / Office No. / Fax No.");
			CrJLabel_PATTEL.setBounds(234, 30, 250, 20);
		}
		return CrJLabel_PATTEL;
	}

	public TextPhone getCrJText_PATTEL() {
		if (CrJText_PATTEL == null) {
			CrJText_PATTEL = new TextPhone();
			CrJText_PATTEL.setBounds(474, 30, 120, 20);
		}
		return CrJText_PATTEL;
	}

	// Left Search criteria part2
	public BasePanel getCrPanel2() {
		if (CrPanel2 == null) {
			CrPanel2 = new BasePanel();
			CrPanel2.setTitledBorder();
			CrPanel2.add(getCrJLabel_PATFNAME(), null);
			CrPanel2.add(getCrJText_PATFNAME(), null);
			CrPanel2.add(getCrJLabel_PATGNAME(), null);
			CrPanel2.add(getCrJText_PATGNAME(), null);
			CrPanel2.add(getCrJLabel_PATMNAME(), null);
			CrPanel2.add(getCrJText_PATMNAME(), null);
			CrPanel2.add(getCrJLabel_PATCNAME(), null);
			CrPanel2.add(getCrJText_PATCNAME(), null);
			CrPanel2.add(getCrJLabel_SCR(), null);
			CrPanel2.add(getCrJCombo_SCR(), null);
			CrPanel2.add(getCrJLabel_OrdBy(), null);
			CrPanel2.add(getCrJCombo_OrdBy(), null);
			CrPanel2.setBounds(10, 80, 734, 60);
		}
		return CrPanel2;
	}

	private LabelSmallBase getCrJLabel_PATFNAME() {
		if (CrJLabel_PATFNAME == null) {
			CrJLabel_PATFNAME = new LabelSmallBase();
			CrJLabel_PATFNAME.setText("Family Name");
			CrJLabel_PATFNAME.setBounds(4, 5, 100, 20);
		}
		return CrJLabel_PATFNAME;
	}

	public TextString getCrJText_PATFNAME() {
		if (CrJText_PATFNAME == null) {
			CrJText_PATFNAME = new TextString(20, true);
			CrJText_PATFNAME.setBounds(99, 5, 120, 20);
		}
		return CrJText_PATFNAME;
	}

	private LabelSmallBase getCrJLabel_PATGNAME() {
		if (CrJLabel_PATGNAME == null) {
			CrJLabel_PATGNAME = new LabelSmallBase();
			CrJLabel_PATGNAME.setText("Given Name");
			CrJLabel_PATGNAME.setBounds(234, 5, 100, 20);
		}
		return CrJLabel_PATGNAME;
	}

	public TextString getCrJText_PATGNAME() {
		if (CrJText_PATGNAME == null) {
			CrJText_PATGNAME = new TextString(20, true);
			CrJText_PATGNAME.setBounds(339, 5, 120, 20);
		}
		return CrJText_PATGNAME;
	}

	private LabelSmallBase getCrJLabel_PATMNAME() {
		if (CrJLabel_PATMNAME == null) {
			CrJLabel_PATMNAME = new LabelSmallBase();
			CrJLabel_PATMNAME.setText("Maiden Name");
			CrJLabel_PATMNAME.setBounds(474, 5, 100, 20);
		}
		return CrJLabel_PATMNAME;
	}

	public TextString getCrJText_PATMNAME() {
		if (CrJText_PATMNAME == null) {
			CrJText_PATMNAME = new TextString(20, true);
			CrJText_PATMNAME.setBounds(569, 5, 120, 20);
		}
		return CrJText_PATMNAME;
	}

	private LabelSmallBase getCrJLabel_PATCNAME() {
		if (CrJLabel_PATCNAME == null) {
			CrJLabel_PATCNAME = new LabelSmallBase();
			CrJLabel_PATCNAME.setText("Chinese Name");
			CrJLabel_PATCNAME.setBounds(4, 30, 100, 20);
		}
		return CrJLabel_PATCNAME;
	}

	private TextString getCrJText_PATCNAME() {
		if (CrJText_PATCNAME == null) {
			CrJText_PATCNAME = new TextString();
			CrJText_PATCNAME.setBounds(99, 30, 120, 20);
		}
		return CrJText_PATCNAME;
	}

	private LabelSmallBase getCrJLabel_SCR() {
		if (CrJLabel_SCR == null) {
			CrJLabel_SCR = new LabelSmallBase();
			CrJLabel_SCR.setText("Search Criteria");
			CrJLabel_SCR.setBounds(234, 30, 100, 20);
		}
		return CrJLabel_SCR;
	}

	private ComboSearchCriteria getCrJCombo_SCR() {
		if (CrJCombo_SCR == null) {
			CrJCombo_SCR = new ComboSearchCriteria();
			CrJCombo_SCR.setBounds(339, 30, 120, 20);
		}
		return CrJCombo_SCR;
	}

	private LabelSmallBase getCrJLabel_OrdBy() {
		if (CrJLabel_OrdBy == null) {
			CrJLabel_OrdBy = new LabelSmallBase();
			CrJLabel_OrdBy.setText("Order By");
			CrJLabel_OrdBy.setBounds(474, 30, 100, 20);
		}
		return CrJLabel_OrdBy;
	}

	private ComboOrderBy getCrJCombo_OrdBy() {
		if (CrJCombo_OrdBy == null) {
			CrJCombo_OrdBy = new ComboOrderBy();
			CrJCombo_OrdBy.setBounds(569, 30, 120, 20);
		}
		return CrJCombo_OrdBy;
	}

	/**
	 * This method initializes jScrollPane
	 *
	 * @return JScrollPane
	 */
	protected JScrollPane getPatientScrollPanel() {
		if (patientScrollPanel == null) {
			patientScrollPanel = new JScrollPane();
			patientScrollPanel.setViewportView(getListTable());
			patientScrollPanel.setBounds(10, 150, 734, 330);
		}
		return patientScrollPanel;
	}
}