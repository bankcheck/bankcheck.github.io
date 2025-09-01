package com.hkah.client.tx.admin.codetable;

import java.util.HashMap;
import java.util.Map;

import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboPackageType;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.Report;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class Package extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.PACKAGE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.PACKAGE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Code",
				"Name",
				"CName",
				"Dept Code",
				"Report Level",
				"Type",
				"Alert",
				""
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				70,
				120,
				120,
				70,
				70,
				70,
				120,
				0
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;
	private LabelBase LeftJLabel_PackageCode = null;
	private TextString LeftJText_PackageCode = null;
	private LabelBase LeftJLabel_PackageName = null;
	private TextString LeftJText_PackageName = null;


	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;
	protected ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_PackageCode = null;
	private TextString RightJText_PackageCode = null;
	private LabelBase RightJLabel_PackageName = null;
	private TextString RightJText_PackageName = null;
	private LabelBase RightJLabel_DeptCode = null;
	private TextString RightJText_DeptCode = null;
	private LabelBase RightJLabel_PackageCName = null;
	private TextString RightJText_PackageCName = null;
	private LabelBase RightJLabel_ReportingLevel = null;
	private TextNum RightJText_ReportingLevel = null;
	private LabelBase RightJLabel_PackageType = null;
	private ComboPackageType RightJCombo_PackageType = null;
	private LabelBase RightJLabel_PackageAlert = null;
	private TextString RightJText_PackageAlert = null;

	/**
	 * This method initializes
	 *
	 */
	public Package() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		/* >>> ~7.1~ Init action (e.g. Listing, Init Comobbox ========= <<< */
		//setFullEntry(true);
		setNoGetDB(true);

		/* >>> ~7.2~ Disable Add/Modify/Delete Buttons ================ <<< */
		//setAppendButtonEnabled(false);
		//setModifyButtonEnabled(true);
		//setDeleteButtonEnabled(false);
		//setConfirmButtonEnabled(false);

		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		//performList();
		getListTable().setColumnClass(5, new ComboPackageType(), false);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return null;//getLeftJText_PackageCode();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		// override function if necessary
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
		// enable/disable field
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		// enable/disable field
		getRightJText_PackageCode().setEnabled(false);

	}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	@Override
	protected void deleteDisabledFields() {
		// enable/disable field
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		return true;
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getLeftJText_PackageCode().getText(),
				getLeftJText_PackageName().getText(),
				null,                                   // pkgReportLvl
				null,                                   // deptCode
				null                                   // slpNo
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
		int index = 0;
		getRightJText_PackageCode().setText(outParam[index++]);
		getRightJText_PackageName().setText(outParam[index++]);
		getRightJText_PackageCName().setText(outParam[index++]);
		getRightJText_DeptCode().setText(outParam[index++]);
		getRightJText_ReportingLevel().setText(outParam[index++]);
		getRightJCombo_PackageType().setText(outParam[index++]);
		getRightJText_PackageAlert().setText(outParam[index++]);
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {}

	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		// TODO Auto-generated method stub
		return new String[] {
				selectedContent[0],
				selectedContent[1],
				selectedContent[2],
				selectedContent[4],
				selectedContent[3],
				selectedContent[5],
				selectedContent[6]
		};
	}

	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[0].trim().length() == 0|| selectedContent[0]==null) {
			Factory.getInstance().addErrorMessage("Empty package code!");
			return false;
		} else if (selectedContent[1].trim().length() == 0||selectedContent[1]==null) {
			Factory.getInstance().addErrorMessage("Empty package name!");
			return false;
		}
		return true;
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/**
	 * This method initializes leftPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getSearchPanel() {
		if (leftPanel == null) {

			LeftJLabel_PackageName = new LabelBase();
//			LeftJLabel_PackageName.setBounds(15, 60, 121, 20);
			LeftJLabel_PackageName.setText("Package Name");
			LeftJLabel_PackageCode = new LabelBase();
//			LeftJLabel_PackageCode.setBounds(15, 15, 121, 20);
			LeftJLabel_PackageCode.setText("Package Code");
			leftPanel = new ColumnLayout(2,2);
//			leftPanel.setSize(471, 100);
			leftPanel.add(0,0,LeftJLabel_PackageCode);
			leftPanel.add(1,0,getLeftJText_PackageCode());
			leftPanel.add(0,1,LeftJLabel_PackageName);
			leftPanel.add(1,1,getLeftJText_PackageName());

		}
		return leftPanel;
	}

	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(4,4);
			RightJLabel_PackageAlert = new LabelBase();
//			RightJLabel_PackageAlert.setBounds(15, 300, 106, 20);
			RightJLabel_PackageAlert.setText("Package Alert");
			RightJLabel_PackageType = new LabelBase();
//			RightJLabel_PackageType.setBounds(15, 255, 106, 20);
			RightJLabel_PackageType.setText("Package Type");
			RightJLabel_ReportingLevel = new LabelBase();
//			RightJLabel_ReportingLevel.setBounds(15, 210, 106, 20);
			RightJLabel_ReportingLevel.setText("Reporting Level");
			RightJLabel_PackageCName = new LabelBase();
//			RightJLabel_PackageCName.setBounds(15, 165, 106, 20);
			RightJLabel_PackageCName.setText("Package CName");
			RightJLabel_DeptCode = new LabelBase();
//			RightJLabel_DeptCode.setBounds(15, 75, 106, 20);
			RightJLabel_DeptCode.setText("Dept. Code");
			RightJLabel_PackageName = new LabelBase();
//			RightJLabel_PackageName.setBounds(15, 120, 106, 20);
			RightJLabel_PackageName.setText("Package Name");
			RightJLabel_PackageCode = new LabelBase();
//			RightJLabel_PackageCode.setBounds(15, 30, 106, 20);
			RightJLabel_PackageCode.setText("Package Code");

//			generalPanel.setLayout(null);
//			generalPanel.setBounds(0, 0, 600, 346);
			generalPanel.setHeading("Package Information");
			generalPanel.add(0,0,RightJLabel_PackageCode);
			generalPanel.add(1,0,getRightJText_PackageCode());
			generalPanel.add(2,0,RightJLabel_PackageName);
			generalPanel.add(3,0,getRightJText_PackageName());
			generalPanel.add(0,1,RightJLabel_DeptCode);
			generalPanel.add(1,1,getRightJText_DeptCode());
			generalPanel.add(2,1,RightJLabel_PackageCName);
			generalPanel.add(3,1,getRightJText_PackageCName());
			generalPanel.add(0,2,RightJLabel_ReportingLevel);
			generalPanel.add(1,2,getRightJText_ReportingLevel());
			generalPanel.add(2,2,RightJLabel_PackageType);
			generalPanel.add(3,2,getRightJCombo_PackageType());
			generalPanel.add(0,3,RightJLabel_PackageAlert);
			generalPanel.add(1,3,getRightJText_PackageAlert());


		}
		return generalPanel;
	}

	/**
	 * This method initializes LeftJText_PackageCode
	 *
	 * @return javax.swing.TextString
	 */
	private TextString getLeftJText_PackageCode() {
		if (LeftJText_PackageCode == null) {
			LeftJText_PackageCode = new TextString();
//			LeftJText_PackageCode.setBounds(150, 15, 196, 20);
		}
		return LeftJText_PackageCode;
	}

	/**
	 * This method initializes LeftJText_PackageName
	 *
	 * @return javax.swing.TextString
	 */
	private TextString getLeftJText_PackageName() {
		if (LeftJText_PackageName == null) {
			LeftJText_PackageName = new TextString();
//			LeftJText_PackageName.setBounds(150, 60, 226, 20);
		}
		return LeftJText_PackageName;
	}

	/**
	 * This method initializes RightJText_PackageCode
	 *
	 * @return javax.swing.TextString
	 */
	private TextString getRightJText_PackageCode() {
		if (RightJText_PackageCode == null) {
			RightJText_PackageCode = new TextString(5,getListTable(), 0);
		}
		return RightJText_PackageCode;
	}

	/**
	 * This method initializes RightJText_PackageName
	 *
	 * @return javax.swing.TextString
	 */
	private TextString getRightJText_PackageName() {
		if (RightJText_PackageName == null) {
			RightJText_PackageName = new TextString(40,getListTable(), 1);
		}
		return RightJText_PackageName;
	}

	/**
	 * This method initializes RightJText_DeptCode
	 *
	 * @return javax.swing.TextString
	 */
	private TextString getRightJText_DeptCode() {
		if (RightJText_DeptCode == null) {
			RightJText_DeptCode = new TextString(10) {
				public void onReleased() {
					setCurrentTable(3,RightJText_DeptCode.getText());
				}
				public void onBlur() {
					QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] {"Dept","DptCode","DptCode='"+RightJText_DeptCode.getText()+"'"},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								setCurrentTable(3,RightJText_DeptCode.getText());
							} else {
								Factory.getInstance().addErrorMessage("Invalid Dept Code.");
								RightJText_DeptCode.requestFocus();
								RightJText_DeptCode.resetText();
							}
						}
					});
				};
			};
//			RightJText_DeptCode.setBounds(135, 75, 106, 20);
		}
		return RightJText_DeptCode;
	}

	/**
	 * This method initializes RightJText_PackageCName
	 *
	 * @return javax.swing.TextString
	 */
	private TextString getRightJText_PackageCName() {
		if (RightJText_PackageCName == null) {
			RightJText_PackageCName = new TextString(20,getListTable(), 2);

		}
		return RightJText_PackageCName;
	}

	/**
	 * This method initializes RightJText_ReportingLevel
	 *
	 * @return javax.swing.TextString
	 */
	private TextNum getRightJText_ReportingLevel() {
		if (RightJText_ReportingLevel == null) {
			RightJText_ReportingLevel = new TextNum(22) {
				public void onReleased() {
					setCurrentTable(4,RightJText_ReportingLevel.getText());
				}
			};
//			RightJText_ReportingLevel.setBounds(135, 210, 106, 20);

		}
		return RightJText_ReportingLevel;
	}

	/**
	 * This method initializes RightJCombo_PackageType
	 *
	 * @return javax.swing.JComboBox
	 */
	private ComboPackageType getRightJCombo_PackageType() {
		if (RightJCombo_PackageType == null) {
			RightJCombo_PackageType = new ComboPackageType() {
				public void onClick() {
					setCurrentTable(5,RightJCombo_PackageType.getText());
				}
			};
//			RightJCombo_PackageType.setBounds(135, 255, 196, 20);
		}
		return RightJCombo_PackageType;
	}

	/**
	 * This method initializes RightJText_PackageAlert
	 *
	 * @return javax.swing.TextString
	 */
	private TextString getRightJText_PackageAlert() {
		if (RightJText_PackageAlert == null) {
			RightJText_PackageAlert = new TextString(50);
//			RightJText_PackageAlert.setBounds(135, 300, 451, 20);
		}
		return RightJText_PackageAlert;
	}	
}