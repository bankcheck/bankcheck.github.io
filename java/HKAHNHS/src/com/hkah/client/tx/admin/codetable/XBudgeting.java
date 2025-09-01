package com.hkah.client.tx.admin.codetable;

import com.extjs.gxt.ui.client.widget.LayoutContainer;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.combobox.ComboACMCode;
import com.hkah.client.layout.combobox.ComboBudgetType;
import com.hkah.client.layout.combobox.ComboRegType;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public abstract class XBudgeting extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public abstract String getTxCode();

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public abstract String getTitle();

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"",                 //0
				"Item Code", 		//1
				"Type",				//2
				"Pkg Code",			//3
				"Acm",              //4
				"GL Code",          //5
				"Cheaper Rate",     //6
				"Higher Rate",      //7
				"New Cheaper Rate", //8
				"New Higher Rate"   //9
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				0,
				70, //B.ITMCODE,
				70, //B.ITCTYPE,
				70, //B.PKGCODE,
				100, //B.ACMCODE,
				70, //B.GLCCODE,
				80, //B.ITCAMT1,
				80, //B.ITCAMT2,
				100, //B.ITCAMT3,
				100  //B.ITCAMT4
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="58,28"
	protected LabelBase LeftJLabel_XCategory = null;
	protected LabelBase LeftJLabel_XType = null;
	protected LabelBase LeftJLabel_XCode = null;
	private LabelBase LeftJLabel_ACMCode = null;
	private ComboBudgetType LeftJCombo_XCategory = null;
	private ComboRegType LeftJCombo_XType = null;
	private ComboACMCode LeftJCombo_ACMCode = null;
	protected TextString LeftJText_XCode = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="29,403"
	private ColumnLayout generalPanel = null;
	private BasePanel totalsPanel = null;
	protected LabelBase RightJLabel_XCategory = null;
	protected LabelBase RightJLabel_XType = null;
	protected LabelBase RightJLabel_ItemCode = null;
	private LabelBase RightJLabel_ACMCode = null;
	private LabelBase RightJLabel_CheaperRate = null;
	private LabelBase RightJLabel_HigherRate = null;
	private TextNum RightJText_CheaperRate = null;
	private TextNum RightJText_HigherRate = null;
	private ComboACMCode RightJCombo_ACMCode = null;
	private ComboBudgetType RightJCombo_XCategory = null;
	private ComboRegType RightJCombo_XType = null;
	private TextString RightJText_ItemCode = null;
	private LabelBase RightJPanel_TotalCheaperRate = null;
	private LabelBase RightJPanel_TotalHigherRate = null;
	private LabelBase RightJLabel_NewTotalCheaperRate = null;
	private LabelBase RightJLabel_NewTotalHigherRate = null;
	private TextNum RightJText_TotalCheaperRate = null;
	private TextNum RightJText_TotalHigherRate = null;
	private TextNum RightJText_NewTotalCheaperRate = null;
	private TextNum RightJText_NewTotalHigherRate = null;
	private LabelBase RightJLabel_NewCheaperRate = null;
	private LabelBase RightJLabel_NewHigherRate = null;
	private TextNum RightJText_NewCheaperRate = null;
	private TextNum RightJText_NewHigherRate = null;
	private LabelBase RightJLabel_GLCode = null;
	private TextString RightJText_GLCode = null;
	private LabelBase RightJLabel_PackageCode = null;
	private TextString RightJText_PackageCode = null;
	/**
	 * This method initializes
	 *
	 */
	public XBudgeting() {
		super();
	}

	protected LayoutContainer getBodyPanel() {
		LayoutContainer panel = new LayoutContainer();
		panel.setBorders(false);
		panel.setStyleAttribute("padding-left","10px");
//		panel.setLayout(new FlowLayout(10));
		panel.add(getLeftPanel());
		panel.add(getActionPanel());
		panel.add(getListTable());
		panel.add(getTotalsPanel());
		return panel;
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
		/*getListTable().setColumnClass(1, new ComboRegType(), false);
		getListTable().setColumnClass(3, new ComboACMCode(), false);*/
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return null;//getLeftJCombo_XCategory();
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
		/*if (ConstantsTx.ITEMBUDGETING_TXCODE == getTxCode()) {
			getRightJText_PackageCode().setEnabled(false);
		}
		getRightJText_TotalCheaperRate().setEnabled(false);
		getRightJText_TotalHigherRate().setEnabled(false);
		getRightJText_NewTotalCheaperRate().setEnabled(false);
		getRightJText_NewTotalHigherRate().setEnabled(false);*/
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		// enable/disable field
		/*getRightJCombo_XCategory().setEnabled(false);
		getRightJCombo_XType().setEnabled(false);
		getRightJText_ItemCode().setEnabled(false);
		getRightJCombo_ACMCode().setEnabled(false);
		getRightJText_GLCode().setEnabled(false);
		getRightJText_PackageCode().setEnabled(false);
		getRightJText_TotalCheaperRate().setEnabled(false);
		getRightJText_TotalHigherRate().setEnabled(false);
		getRightJText_NewTotalCheaperRate().setEnabled(false);
		getRightJText_NewTotalHigherRate().setEnabled(false);*/
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

		// Display totals
		String mode;
		if (ConstantsTx.ITEMBUDGETING_TXCODE == getTxCode()) {
			if ("D".equals(getLeftJCombo_XCategory().getText())) {
				mode = "ID";
			} else {
				mode = "IC";
			}
		} else {
			if ("D".equals(getLeftJCombo_XCategory().getText())) {
				mode = "PD";
			} else {
				mode = "PC";
			}
		}

		QueryUtil.executeMasterFetch(getUserInfo(), "BUDGET_RATE",
				new String[] { mode },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				// TODO Auto-generated method stub
				if (mQueue.success()) {
					getRightJText_TotalCheaperRate().setText(mQueue.getContentField()[0]);
					getRightJText_TotalHigherRate().setText(mQueue.getContentField()[1]);
					getRightJText_NewTotalCheaperRate().setText(mQueue.getContentField()[2]);
					getRightJText_NewTotalHigherRate().setText(mQueue.getContentField()[3]);
				}
			}
		});


		return new String[] {
				getLeftJCombo_XCategory().getText(), // CATEGORY
				getLeftJText_XCode().getText(), // ITMCODE
				getLeftJCombo_XType().getText(), // ITCTYPE
				getLeftJCombo_ACMCode().getText() // ACMCODE
		};
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		String[] selectedContent = getListSelectedRow();
		return new String[] {
				selectedContent[1]
		};
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
		int index = 0;
		//getRightJCombo_XCategory().setText(getLeftJCombo_XCategory().getText());
		getRightJCombo_XCategory().setText(outParam[index++]);
		getRightJText_ItemCode().setText(outParam[index++]);
		getRightJCombo_XType().setText(outParam[index++]);
		getRightJText_PackageCode().setText(outParam[index++]);
		getRightJCombo_ACMCode().setText(outParam[index++]);
		getRightJText_GLCode().setText(outParam[index++]);
		getRightJText_CheaperRate().setText(outParam[index++]);
		getRightJText_HigherRate().setText(outParam[index++]);
		getRightJText_NewCheaperRate().setText(outParam[index++]);
		getRightJText_NewHigherRate().setText(outParam[index++]);
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
			LeftJLabel_ACMCode = new LabelBase();
//			LeftJLabel_ACMCode.setBounds(210,45, 76, 20);
			LeftJLabel_ACMCode.setText("Acm Code");
			LeftJLabel_XCode = new LabelBase();
//			LeftJLabel_XCode.setBounds(210, 15, 76, 20);
			LeftJLabel_XCode.setText("X Code");
			LeftJLabel_XType = new LabelBase();
//			LeftJLabel_XType.setBounds(0, 45, 91, 20);
			LeftJLabel_XType.setText("X Type");
			LeftJLabel_XCategory = new LabelBase();
//			LeftJLabel_XCategory.setBounds(0, 15, 91, 20);
			LeftJLabel_XCategory.setText("X Category");
			leftPanel = new ColumnLayout(4,2);
//			leftPanel.setSize(471, 100);
			leftPanel.add(0,0,LeftJLabel_XCategory);
			leftPanel.add(0,1,LeftJLabel_XType);
			leftPanel.add(2,0,LeftJLabel_XCode);
			leftPanel.add(2,1,LeftJLabel_ACMCode);
			leftPanel.add(1,0,getLeftJCombo_XCategory());
			leftPanel.add(1,1,getLeftJCombo_XType());
			leftPanel.add(3,0,getLeftJText_XCode());
			leftPanel.add(3,1,getLeftJCombo_ACMCode());
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
			generalPanel = new ColumnLayout(8,3,new int[] {90,140,90,140,110,140,110,140});
			RightJLabel_PackageCode = new LabelBase();
//			RightJLabel_PackageCode.setBounds(315, 75, 121, 20);
			RightJLabel_PackageCode.setText("Package Code");
			RightJLabel_GLCode = new LabelBase();
//			RightJLabel_GLCode.setBounds(15, 120, 121, 20);
			RightJLabel_GLCode.setText("GL Code");
			RightJLabel_NewHigherRate = new LabelBase();
//			RightJLabel_NewHigherRate.setBounds(315, 225, 121, 20);
			RightJLabel_NewHigherRate.setText("New Higher Rate");
			RightJLabel_NewCheaperRate = new LabelBase();
//			RightJLabel_NewCheaperRate.setBounds(315, 180, 121, 20);
			RightJLabel_NewCheaperRate.setText("New Cheaper Rate");
			RightJLabel_HigherRate = new LabelBase();
//			RightJLabel_HigherRate.setBounds(15, 225, 121, 20);
			RightJLabel_HigherRate.setText("Higher Rate");
			RightJLabel_CheaperRate = new LabelBase();
//			RightJLabel_CheaperRate.setBounds(15, 180, 119, 20);
			RightJLabel_CheaperRate.setText("Cheaper Rate");
			RightJLabel_ACMCode = new LabelBase();
//			RightJLabel_ACMCode.setBounds(315, 120, 121, 20);
			RightJLabel_ACMCode.setText("Acm Code");
			RightJLabel_ItemCode = new LabelBase();
//			RightJLabel_ItemCode.setBounds(315, 30, 121, 20);
			RightJLabel_ItemCode.setText("Item Code");
			RightJLabel_XType = new LabelBase();
//			RightJLabel_XType.setBounds(15, 75, 121, 20);
			RightJLabel_XType.setText("X Type");
			RightJLabel_XCategory = new LabelBase();
//			RightJLabel_XCategory.setBounds(15, 30, 121, 20);
			RightJLabel_XCategory.setText("X Category");

			//generalPanel.setBounds(7, 0, 600, 287);
			generalPanel.setHeading("Item Information");
			generalPanel.add(0,0,RightJLabel_XCategory);
			generalPanel.add(2,0,RightJLabel_XType);
			generalPanel.add(4,0,RightJLabel_ItemCode);
			generalPanel.add(6,0,RightJLabel_ACMCode);
			generalPanel.add(0,1,RightJLabel_CheaperRate);
			generalPanel.add(2,1,RightJLabel_HigherRate);
			generalPanel.add(1,0,getRightJCombo_XCategory());
			generalPanel.add(3,0,getRightJCombo_XType());
			generalPanel.add(5,0,getRightJText_ItemCode());
			generalPanel.add(7,0,getRightJCombo_ACMCode());
			generalPanel.add(1,1,getRightJText_CheaperRate());
			generalPanel.add(3,1,getRightJText_HigherRate());

			generalPanel.add(4,1,RightJLabel_NewCheaperRate);
			generalPanel.add(6,1,RightJLabel_NewHigherRate);
			generalPanel.add(5,0,getRightJText_NewCheaperRate());
			generalPanel.add(7,0,getRightJText_NewHigherRate());
			generalPanel.add(0,2,RightJLabel_GLCode);
			generalPanel.add(1,2,getRightJText_GLCode());
			generalPanel.add(2,2,RightJLabel_PackageCode);
			generalPanel.add(3,2,getRightJText_PackageCode());
		}
		return generalPanel;
	}

	/**
	 * This method initializes LeftJCombo_XCategory
	 *
	 * @return javax.swing.JComboBox
	 */
	private ComboBudgetType getLeftJCombo_XCategory() {
		if (LeftJCombo_XCategory == null) {
			LeftJCombo_XCategory = new ComboBudgetType();
//			LeftJCombo_XCategory.setBounds(90, 15, 106, 20);
		}
		return LeftJCombo_XCategory;
	}

	/**
	 * This method initializes LeftJCombo_XType
	 *
	 * @return javax.swing.JComboBox
	 */
	private ComboRegType getLeftJCombo_XType() {
		if (LeftJCombo_XType == null) {
			LeftJCombo_XType = new ComboRegType();
//			LeftJCombo_XType.setBounds(90,45, 106, 20);
		}
		return LeftJCombo_XType;
	}

	/**
	 * This method initializes LeftJCombo_ACMCode
	 *
	 * @return javax.swing.JComboBox
	 */
	private ComboACMCode getLeftJCombo_ACMCode() {
		if (LeftJCombo_ACMCode == null) {
			LeftJCombo_ACMCode = new ComboACMCode();
//			LeftJCombo_ACMCode.setBounds(285, 45, 91, 20);
		}
		return LeftJCombo_ACMCode;
	}

	/**
	 * This method initializes LeftJText_XCode
	 *
	 * @return javax.swing.JTextField
	 */
	private TextString getLeftJText_XCode() {
		if (LeftJText_XCode == null) {
			LeftJText_XCode = new TextString();
//			LeftJText_XCode.setBounds(285, 15, 91, 20);
		}
		return LeftJText_XCode;
	}

	/**
	 * This method initializes totalsPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getTotalsPanel() {
		if (totalsPanel == null) {
			RightJLabel_NewTotalHigherRate = new LabelBase();
			RightJLabel_NewTotalHigherRate.setBounds(300, 55, 166, 20);
			RightJLabel_NewTotalHigherRate.setText("New Total Higher Rate");
			RightJLabel_NewTotalCheaperRate = new LabelBase();
			RightJLabel_NewTotalCheaperRate.setBounds(300, 30, 166, 20);
			RightJLabel_NewTotalCheaperRate.setText("New Total Cheaper Rate");
			RightJPanel_TotalHigherRate = new LabelBase();
			RightJPanel_TotalHigherRate.setBounds(15, 55, 121, 20);
			RightJPanel_TotalHigherRate.setText("Total Higher Rate");
			RightJPanel_TotalCheaperRate = new LabelBase();
			RightJPanel_TotalCheaperRate.setBounds(15, 30, 121, 20);
			RightJPanel_TotalCheaperRate.setText("Total Cheaper Rate");
			totalsPanel = new BasePanel();
//			totalsPanel.setLayout(null);
//			totalsPanel.setBounds(5, 349, 601, 88);
//			totalsPanel.setHeading("Totals");
			totalsPanel.add(RightJPanel_TotalCheaperRate, null);
			totalsPanel.add(RightJPanel_TotalHigherRate, null);
			totalsPanel.add(RightJLabel_NewTotalCheaperRate, null);
			totalsPanel.add(RightJLabel_NewTotalHigherRate, null);
			totalsPanel.add(getRightJText_TotalCheaperRate(), null);
			totalsPanel.add(getRightJText_TotalHigherRate(), null);
			totalsPanel.add(getRightJText_NewTotalCheaperRate(), null);
			totalsPanel.add(getRightJText_NewTotalHigherRate(), null);
		}
		return totalsPanel;
	}

	/**
	 * This method initializes RightJText_CheaperRate
	 *
	 * @return javax.swing.JTextField
	 */
	private TextNum getRightJText_CheaperRate() {
		if (RightJText_CheaperRate == null) {
			RightJText_CheaperRate = new TextNum(32, 2) {
				public void onReleased() {
					setCurrentTable(6,RightJText_CheaperRate.getText());
				}
			};
//			RightJText_CheaperRate.setBounds(150, 180, 136, 20);
		}
		return RightJText_CheaperRate;
	}

	/**
	 * This method initializes RightJText_HigherRate
	 *
	 * @return javax.swing.JTextField
	 */
	private TextNum getRightJText_HigherRate() {
		if (RightJText_HigherRate == null) {
			RightJText_HigherRate = new TextNum(32, 2) {
				public void onReleased() {
					setCurrentTable(7,RightJText_HigherRate.getText());
				}
			};
//			RightJText_HigherRate.setBounds(150, 225, 136, 20);
		}
		return RightJText_HigherRate;
	}

	/**
	 * This method initializes RightJCombo_ACMCode
	 *
	 * @return javax.swing.JComboBox
	 */
	private ComboACMCode getRightJCombo_ACMCode() {
		if (RightJCombo_ACMCode == null) {
			RightJCombo_ACMCode = new ComboACMCode() {
				public void onClick() {
					setCurrentTable(4,RightJCombo_ACMCode.getText());
				}
			};
//			RightJCombo_ACMCode.setBounds(450, 120, 136, 20);
		}
		return RightJCombo_ACMCode;
	}

	/**
	 * This method initializes RightJCombo_XCategory
	 *
	 * @return javax.swing.JComboBox
	 */
	private ComboBudgetType getRightJCombo_XCategory() {
		if (RightJCombo_XCategory == null) {
			RightJCombo_XCategory = new ComboBudgetType() {
				public void onClick() {
					setCurrentTable(0,RightJCombo_XCategory.getText());
				}
			};
//			RightJCombo_XCategory.setBounds(150, 30, 136, 20);
		}
		return RightJCombo_XCategory;
	}

	/**
	 * This method initializes RightJCombo_XType
	 *
	 * @return javax.swing.JComboBox
	 */
	private ComboRegType getRightJCombo_XType() {
		if (RightJCombo_XType == null) {
			RightJCombo_XType = new ComboRegType() {
				public void onClick() {
					setCurrentTable(2,RightJCombo_XType.getText());
				}
			};
//			RightJCombo_XType.setBounds(150, 75, 136, 20);
		}
		return RightJCombo_XType;
	}

	/**
	 * This method initializes RightJText_ItemCode
	 *
	 * @return javax.swing.JTextField
	 */
	private TextString getRightJText_ItemCode() {
		if (RightJText_ItemCode == null) {
			RightJText_ItemCode = new TextString() {
				@Override
				public void onReleased() {
					setCurrentTable(1,RightJText_ItemCode.getText());
				}

				@Override
				public void onBlur() {
					QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] {"Item","ITMCODE","ITMCODE='"+RightJText_ItemCode.getText()+"'"},
							new MessageQueueCallBack() {
						@Override
							public void onPostSuccess(MessageQueue mQueue) {
								// TODO Auto-generated method stub
								if (mQueue.success()) {
									setCurrentTable(1, RightJText_ItemCode.getText());
								} else {
									Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_ITEM_CODE, RightJText_ItemCode.getText());
									/*RightJText_ItemCode.resetText();
									RightJText_ItemCode.requestFocus();*/
								}
							}
						});
				};
			};
//			RightJText_ItemCode.setBounds(456, 30, 136, 20);
		}
		return RightJText_ItemCode;
	}

	/**
	 * This method initializes RightJText_TotalCheaperRate
	 *
	 * @return javax.swing.JTextField
	 */
	private TextNum getRightJText_TotalCheaperRate() {
		if (RightJText_TotalCheaperRate == null) {
			RightJText_TotalCheaperRate = new TextNum();
			RightJText_TotalCheaperRate.setBounds(150, 30, 121, 20);
		}
		return RightJText_TotalCheaperRate;
	}

	/**
	 * This method initializes RightJText_TotalHigherRate
	 *
	 * @return javax.swing.JTextField
	 */
	private TextNum getRightJText_TotalHigherRate() {
		if (RightJText_TotalHigherRate == null) {
			RightJText_TotalHigherRate = new TextNum();
			RightJText_TotalHigherRate.setBounds(150, 55, 121, 20);
		}
		return RightJText_TotalHigherRate;
	}

	/**
	 * This method initializes RightJText_NewTotalCheaperRate
	 *
	 * @return javax.swing.JTextField
	 */
	private TextNum getRightJText_NewTotalCheaperRate() {
		if (RightJText_NewTotalCheaperRate == null) {
			RightJText_NewTotalCheaperRate = new TextNum();
			RightJText_NewTotalCheaperRate.setBounds(480, 30, 106, 20);
		}
		return RightJText_NewTotalCheaperRate;
	}

	/**
	 * This method initializes RightJText_NewTotalHigherRate
	 *
	 * @return javax.swing.JTextField
	 */
	private TextNum getRightJText_NewTotalHigherRate() {
		if (RightJText_NewTotalHigherRate == null) {
			RightJText_NewTotalHigherRate = new TextNum();
			RightJText_NewTotalHigherRate.setBounds(480,55, 106, 20);
		}
		return RightJText_NewTotalHigherRate;
	}

	/**
	 * This method initializes RightJText_NewCheaperRate
	 *
	 * @return javax.swing.JTextField
	 */
	private TextNum getRightJText_NewCheaperRate() {
		if (RightJText_NewCheaperRate == null) {
			RightJText_NewCheaperRate = new TextNum(32, 2) {
				public void onReleased() {
					setCurrentTable(8,RightJText_NewCheaperRate.getText());
				}
			};
			RightJText_NewCheaperRate.setStyleAttribute("margin-top","3px");
//			RightJText_NewCheaperRate.setBounds(450,180, 136, 20);
		}
		return RightJText_NewCheaperRate;
	}

	/**
	 * This method initializes RightJText_NewHigherRate
	 *
	 * @return javax.swing.JTextField
	 */
	private TextNum getRightJText_NewHigherRate() {
		if (RightJText_NewHigherRate == null) {
			RightJText_NewHigherRate = new TextNum(32, 2) {
				public void onReleased() {
					setCurrentTable(9,RightJText_NewHigherRate.getText());
				}
			};
			RightJText_NewHigherRate.setStyleAttribute("margin-top","3px");
//			RightJText_NewHigherRate.setBounds(450, 225, 136, 20);
		}
		return RightJText_NewHigherRate;
	}

	/**
	 * This method initializes RightJText_GLCode
	 *
	 * @return javax.swing.JTextField
	 */
	private TextString getRightJText_GLCode() {
		if (RightJText_GLCode == null) {
			RightJText_GLCode = new TextString() {
				public void onReleased() {
					setCurrentTable(5, RightJText_GLCode.getText());
				}
				public void onBlur() {
					QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] {"Glcode", "glccode","glccode='" + RightJText_GLCode.getText() + "'"},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								setCurrentTable(5, RightJText_GLCode.getText());
							} else {
								/*RightJText_GLCode.resetText();
								RightJText_GLCode.requestFocus();*/
								Factory.getInstance().addErrorMessage("Invalidate GL Code.");
							}
						}
					});

				};
			};
//			RightJText_GLCode.setBounds(150, 120, 136, 20);
		}
		return RightJText_GLCode;
	}

	/**
	 * This method initializes RightJText_PackageCode
	 *
	 * @return javax.swing.JTextField
	 */
	private TextString getRightJText_PackageCode() {
		if (RightJText_PackageCode == null) {
			RightJText_PackageCode = new TextString() {
				public void onReleased() {
					setCurrentTable(3, RightJText_PackageCode.getText());
				}
				public void onBlur() {
					if (RightJText_PackageCode.getText().trim().length()==0||RightJText_PackageCode.getText() == null) {
						return;
					}
					QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] {"Package","PkgCode","PkgCode='"+RightJText_PackageCode.getText()+"'"},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								setCurrentTable(3,RightJText_PackageCode.getText());
							} else {
								/*RightJText_PackageCode.requestFocus();
								RightJText_PackageCode.resetText();*/
								Factory.getInstance().addErrorMessage("Invalid Package Code.");
							}
						}
					});
				};
			};
//			RightJText_PackageCode.setBounds(450, 75, 136, 20);
		}
		return RightJText_PackageCode;
	}
}