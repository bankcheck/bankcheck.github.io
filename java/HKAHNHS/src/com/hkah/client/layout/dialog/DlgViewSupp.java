package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.Style.Scroll;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.GridEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.widget.form.Field;
import com.hkah.client.MainFrame;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboSuppCategory;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.table.EditorTableList;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.shared.constants.ConstantsTx;

public class DlgViewSupp extends DialogBase {

	private BasePanel patAndItemDetailPanel = null;
	private BasePanel suppPanel = null;

	private LabelBase RightJLabel_PatientNum = null;
	private TextReadOnly RightJText_PatientNum = null;
	private LabelBase RightJLabel_PatientName = null;
	private TextReadOnly RightJText_PatientName = null;
	private TextReadOnly RightJText_PatientCName = null;
	private LabelBase RightJLabel_PatientSex = null;
	private TextReadOnly RightJText_PatientSex = null;
	private LabelBase RightJLabel_DOB = null;
	private TextReadOnly RightJText_DOB = null;
	private LabelBase RightJLabel_ChargeName = null;
	private TextReadOnly RightJText_ChargeName = null;

	private LabelBase RightJLabel_SuppCategory = null;
	private ComboSuppCategory RightJText_SuppCategory = null;
	private LabelBase RightJLabel_ItemList = null;
	private EditorTableList RightJTable_ItemList = null;
	private LabelBase RightJLabel_SelectedSupp = null;
	private EditorTableList RightJTable_SelectedSupp = null;
	private LabelBase RightJLabel_ShowHist = null;
	private CheckBoxBase RightJCheckBox_ShowHist = null;

	private String stnID = null;
	private String patNo = null;
	private String patName = null;
	private String patCName = null;
	private String patSex = null;
	private String itmCode = null;
	private String itmDesc = null;
	private String slpNo = null;
	private String docCode_O = null;
	private String docCode_T = null;
	private String patDOB;

	private int prevSelectedRow = -1;
	private int prevSelectedCol = -1;
	private boolean validating = false;
	private int orgSelectedSuppRow = 0;

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.SUPP_TITLE;
	}

	public DlgViewSupp(MainFrame owner, String slpNo, String patNo,
					   String patname, String patcname,
					   String regDate, String patSex, String patDOB) {
		super(owner,830,600);
		this.slpNo = slpNo;
		this.patNo = patNo;
		this.patName = patname;
		this.patCName = patcname;
		this.patSex = patSex;
		this.patDOB = patDOB;

		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		getRightJTable_ItemList().setEnabled(true);
		getRightJTable_SelectedSupp().setEnabled(true);
		getRightJCheckBox_ShowHist().setEnabled(true);

		getRightJText_PatientNum().setText(patNo);
		getRightJText_PatientName().setText(patName);
		getRightJText_PatientCName().setText(patCName);
		getRightJText_PatientSex().setText(patSex);
		getRightJText_DOB().setText(patDOB);

		add(getPatientAndItemDetailPanel(),null);
		add(getSuppPanel(),null);
		reloadTableList(true,false);
	}

	public BasePanel getPatientAndItemDetailPanel() {
		if (patAndItemDetailPanel == null) {
			patAndItemDetailPanel = new BasePanel();
			patAndItemDetailPanel.setEtchedBorder();
			patAndItemDetailPanel.setBounds(5,0,800, 55);

			patAndItemDetailPanel.add(getRightJLabel_PatientNum(), null);
			patAndItemDetailPanel.add(getRightJText_PatientNum(), null);
			patAndItemDetailPanel.add(getRightJLabel_PatientName(), null);
			patAndItemDetailPanel.add(getRightJText_PatientName(), null);
			patAndItemDetailPanel.add(getRightJText_PatientCName(), null);
			patAndItemDetailPanel.add(getRightJLabel_PatientSex(), null);
			patAndItemDetailPanel.add(getRightJText_PatientSex(), null);
			patAndItemDetailPanel.add(getRightJLabel_DOB(), null);
			patAndItemDetailPanel.add(getRightJText_DOB(), null);
		}
		return patAndItemDetailPanel;
	}

	public BasePanel getSuppPanel() {
		if (suppPanel == null) {
			suppPanel = new BasePanel();
			suppPanel.setEtchedBorder();
			suppPanel.setBounds(5,51,800,420);

			BasePanel aSuppTablePanel = new BasePanel();
			aSuppTablePanel.setScrollMode(Scroll.AUTO);
			aSuppTablePanel.setEtchedBorder();
			aSuppTablePanel.setBounds(5, 5, 790, 200);
			aSuppTablePanel.add(getRightJTable_ItemList(), null);

			BasePanel sSuppTablePanel = new BasePanel();
			sSuppTablePanel.setScrollMode(Scroll.AUTO);
			sSuppTablePanel.setEtchedBorder();
			sSuppTablePanel.setBounds(5, 245, 790, 170);
			sSuppTablePanel.add(getRightJTable_SelectedSupp(), null);

			suppPanel.add(getRightJLabel_ItemList(), null);
			suppPanel.add(aSuppTablePanel, null);
			suppPanel.add(getRightJLabel_SelectedSupp(), null);
			suppPanel.add(getRightJLabel_ShowHist(), null);
			suppPanel.add(getRightJCheckBox_ShowHist(), null);
			suppPanel.add(sSuppTablePanel, null);
		}
		return suppPanel;
	}

	public LabelBase getRightJLabel_PatientNum() {
		if (RightJLabel_PatientNum == null) {
			RightJLabel_PatientNum = new LabelBase();
			RightJLabel_PatientNum.setText("Patient Number");
			RightJLabel_PatientNum.setBounds(15, 5, 90, 20);
		}
		return RightJLabel_PatientNum;
	}

	public TextReadOnly getRightJText_PatientNum() {
		if (RightJText_PatientNum == null) {
			RightJText_PatientNum = new TextReadOnly();
			RightJText_PatientNum.setBounds(110, 5, 90, 20);
		}
		return RightJText_PatientNum;
	}

	public LabelBase getRightJLabel_PatientName() {
		if (RightJLabel_PatientName == null) {
			RightJLabel_PatientName = new LabelBase();
			RightJLabel_PatientName.setText("Patient Name");
			RightJLabel_PatientName.setBounds(230, 5, 90, 20);
		}
		return RightJLabel_PatientName;
	}

	public TextReadOnly getRightJText_PatientName() {
		if (RightJText_PatientName == null) {
			RightJText_PatientName = new TextReadOnly();
			RightJText_PatientName.setBounds(325, 5, 200, 20);
		}
		return RightJText_PatientName;
	}

	public TextReadOnly getRightJText_PatientCName() {
		if (RightJText_PatientCName == null) {
			RightJText_PatientCName = new TextReadOnly();
			RightJText_PatientCName.setBounds(530, 5, 90, 20);
		}
		return RightJText_PatientCName;
	}

	public LabelBase getRightJLabel_PatientSex() {
		if (RightJLabel_PatientSex == null) {
			RightJLabel_PatientSex = new LabelBase();
			RightJLabel_PatientSex.setText("Sex");
			RightJLabel_PatientSex.setBounds(15, 30, 90, 20);
		}
		return RightJLabel_PatientSex;
	}

	public TextReadOnly getRightJText_PatientSex() {
		if (RightJText_PatientSex == null) {
			RightJText_PatientSex = new TextReadOnly();
			RightJText_PatientSex.setBounds(110, 30, 90, 20);
		}
		return RightJText_PatientSex;
	}

	public LabelBase getRightJLabel_DOB() {
		if (RightJLabel_DOB == null) {
			RightJLabel_DOB = new LabelBase();
			RightJLabel_DOB.setText("DOB");
			RightJLabel_DOB.setBounds(230, 30, 90, 20);
		}
		return RightJLabel_DOB;
	}

	public TextReadOnly getRightJText_DOB() {
		if (RightJText_DOB == null) {
			RightJText_DOB = new TextReadOnly();
			RightJText_DOB.setBounds(325, 30, 295, 20);
		}
		return RightJText_DOB;
	}

	public LabelBase getRightJLabel_ItemList() {
		if (RightJLabel_ItemList == null) {
			RightJLabel_ItemList = new LabelBase();
			RightJLabel_ItemList.setStyleAttribute("font-wight", "bold");
			RightJLabel_ItemList.setBounds(5, 40, 90, 20);

		}
		return RightJLabel_ItemList;
	}

	public EditorTableList getRightJTable_ItemList() {
		if (RightJTable_ItemList == null) {
			RightJTable_ItemList =
					new EditorTableList(geItemListColumnNames(),
										getItemListColumnWidths(),
										geItemListFields(), false,
										null, null) {
				@Override
				public void setListTableContentPost() {
					if (getStore().getCount() > 0) {
						reloadTableList(false,true);
					}
				}
			};
			RightJTable_ItemList.setId("item-list-table");
			RightJTable_ItemList.setAutoHeight(true);
			RightJTable_ItemList.addListener(Events.RowClick,
					new Listener<GridEvent>() {
						@Override
						public void handleEvent(GridEvent be) {
							// TODO Auto-generated method stub
							reloadTableList(false,true);
						}
					});
		}
		return RightJTable_ItemList;
	}

	private String[] geItemListColumnNames() {
		return new String[] { "stdid","Reg Date", "Type", "Slip No","Charge Code",
							  "Charge Name","Amount", "Dr.Code","Dr. Name","Txn Date" };
	}

	private int[] getItemListColumnWidths() {
		return new int[] { 0,100,50,100,80,165,50,50,165,80 };
	}

	private Field[] geItemListFields() {
		return new Field[] { null, null, null,null, null, null,null, null, null, null};
	}

	public LabelBase getRightJLabel_SelectedSupp() {
		if (RightJLabel_SelectedSupp == null) {
			RightJLabel_SelectedSupp = new LabelBase();
			RightJLabel_SelectedSupp.setText("Detail");
			RightJLabel_SelectedSupp.setStyleAttribute("font-wight", "bold");
			RightJLabel_SelectedSupp.setBounds(5, 220, 90, 20);
		}
		return RightJLabel_SelectedSupp;
	}

	public LabelBase getRightJLabel_ShowHist() {
		if (RightJLabel_ShowHist == null) {
			RightJLabel_ShowHist = new LabelBase();
			RightJLabel_ShowHist.setText("Show History");
			RightJLabel_ShowHist.setBounds(685, 220, 80, 20);
		}
		return RightJLabel_ShowHist;
	}

	public CheckBoxBase getRightJCheckBox_ShowHist() {
		if (RightJCheckBox_ShowHist == null) {
			RightJCheckBox_ShowHist = new CheckBoxBase();
			RightJCheckBox_ShowHist.setBounds(770, 220, 10, 20);
			RightJCheckBox_ShowHist.addListener(Events.OnClick,
				new Listener<FieldEvent>() {
					@Override
					public void handleEvent(FieldEvent be) {
						// TODO Auto-generated method stub
						boolean checked = getRightJCheckBox_ShowHist().getValue();
						reloadTableList(false, true);
					}
				});
		}
		return RightJCheckBox_ShowHist;
	}

	public EditorTableList getRightJTable_SelectedSupp() {
		if (RightJTable_SelectedSupp == null) {
			RightJTable_SelectedSupp =
				new EditorTableList(getSelectedSuppColumnNames(),
									getSelectedSuppColumnWidths(),
									getSelectedSuppFields(), false,
									null, null);
			RightJTable_SelectedSupp.setId("selected-supp-table");
			RightJTable_SelectedSupp.setAutoHeight(true);

		}
		return RightJTable_SelectedSupp;
	}

	private String[] getSelectedSuppColumnNames() {
		return new String[] { "TSLID", "Category Code", "Supp Code", "Description",
						"Order By", "Treat By", "Remark", "Added By",
						"Add Date", "Cancel By", "Cancel Date", "Add Time",
						"Cancel Time" };
	}

	private int[] getSelectedSuppColumnWidths() {
		return new int[] { 0, 100, 80, 130, 70, 70, 300, 80, 80, 80, 80,
							  0,0 };
	}

	private Field[] getSelectedSuppFields() {
		return new Field[] { null, null, null, null, null,
						null, null, null, null, null, null, null,
						null };
	}

	public void reloadTableList(boolean isItem, boolean isSelected) {
		if (isItem) {
			getRightJTable_ItemList().setListTableContent(
				"Item_Withsupp",
				new String[] { patNo}
			);
		}

		if (isSelected) {
			getRightJTable_SelectedSupp().setListTableContent(
					ConstantsTx.SUPP_TXCODE,
					new String[] {
							"false",
							getRightJCheckBox_ShowHist().getValue().toString(),
							getRightJTable_ItemList().getSelectedRowContent()[0],
							""
					});
		}
	}
}