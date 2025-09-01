package com.hkah.client.tx.admin.codetable;

import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboACMCode;
import com.hkah.client.layout.combobox.ComboItcType;
import com.hkah.client.layout.combobox.ComboItemType;
import com.hkah.client.layout.combobox.ComboSetPrice;
import com.hkah.client.layout.dialog.DlgCreateSet;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextItemCode;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class CreditItemCharge extends MasterPanel {

	@Override
	public String getTitle() {
		// TODO Auto-generated method stub
		return ConstantsTx.CREDITITEMCHARGE_TITLE;
	}

	@Override
	public String getTxCode() {
		// TODO Auto-generated method stub
		return ConstantsTx.CREDITITEMCHARGE_TXCODE;
	}

	@Override
	protected String[] getColumnNames() {
		// TODO Auto-generated method stub
		return new String[] {
				"",
				"Item Code",
				"Item Name",
				"Item Type",
				"Report Level",
				"Dept Service Code",
				"Dept Code"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		// TODO Auto-generated method stub
		return new int[] {
				5,
				100,
				190,
				100,
				100,
				150,
				100
		};
	}

	protected String[] getDVATableColumnNames() {
		return new String[] {
				"",					//0
				"id",				//1
				"Item Code",  		//2
				"Itc Type",		//3
				"package Code",		//4
				"package Name",		//5
				"Acm. Code",		//6
				"GL Code",			//7
				"Cheaper Rate",		//8
				"Heigher Rate",		//9
				"Set",				//10
				"Contracted%"		//11
				};
	}

	protected int[] getDVATableColumnWidths() {
		return new int[] {
					5,
					0,
					0,
					100,
					100,
					100,
					100,
					100,
					100,
					100,
					80,
					80
				};
	}


	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel leftPanel = null;  //  @jve:decl-index=0:visual-constraint="30,10"
	private BasePanel viewPanel = null;
	private LabelBase LeftJLabel_ItemCodeDesc = null;
	private TextString LeftJText_ItemCode=null;
	private LabelBase LeftJLabel_ItemTypeDesc=null;
	private ComboItemType LeftJCombo_ItemType = null;
	private LabelBase LeftJLabel_SetDesc=null;
	private ComboSetPrice LeftJCombo_Set=null;


	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="15,574"
	private BasePanel generalPanel=null;
	private TableList ItemChargeTable=null;
	private JScrollPane ItemChargeJScrollPane = null;
	private ButtonBase create_set=null;
	private ButtonBase edit_set=null;

	private LabelBase Right_ItemCodeDesc = null;
	private TextString RightJText_ItemCode=null;
	private LabelBase RightJLabel_higherRateDesc=null;
	private TextString RightJText_higherRate=null;
	private LabelBase RightJLabel_ItcTypeDesc=null;
	private ComboItcType RightJCombo_ItcType=null;
	private LabelBase RightJLabel_PackageCodeDesc=null;
	private TextString RightJText_PackageCode=null;
	private LabelBase RightJLabel_CheaeperRateDesc=null;
	private TextString RightJText_ChaeperRate=null;
	private LabelBase RightJLabel_AcmCodeDesc=null;
	private ComboACMCode RightJCombo_AcmCode=null;
	private LabelBase RightJLabel_GLCodeDesc=null;
	private TextString RightJText_GLCode=null;
	private LabelBase RightJLabel_ContractedDesc=null;
	private TextString RightJText_Contracted=null;
	private LabelBase RightJLabel_SetDesc=null;
	private ComboSetPrice RightJCombo_Set=null;
	private String cicid=null;  //  @jve:decl-index=0:
	public CreditItemCharge() {
		super();
	}

	@Override
	protected boolean init() {
		// TODO Auto-generated method stub
		setNoGetDB(true);
		setLeftAlignPanel();
		getJScrollPane().setBounds(10,200, 755,150);
		return true;
	}

	@Override
	protected void initAfterReady() {
		// TODO Auto-generated method stub
		//getItemChargeTable().addMouseListener(listTableMouseListener);
		getItemChargeTable().setColumnClass(10, new ComboSetPrice(), false);
		getItemChargeTable().setColumnClass(3, new ComboItcType(), false);
		getAppendButton().setEnabled(false);
		getCancelButton().setEnabled(true);
		getPrintButton().setEnabled(false);
		getRefreshButton().setEnabled(false);
		getCancelButton().setEnabled(false);
		getAcceptButton().setEnabled(false);

		getRightJText_ItemCode().setEnabled(false);
		getRightJText_higherRate().setEnabled(false);
		getRightJCombo_ItcType().setEnabled(false);
		getRightJText_PackageCode().setEnabled(false);
		getRightJText_ChaeperRate().setEnabled(false);
		getRightJCombo_AcmCode().setEnabled(false);
		getRightJText_GLCode().setEnabled(false);
		getRightJText_Contracted().setEnabled(false);
		getRightJCombo_Set().setEnabled(false);
	}

//	private MouseListener listTableMouseListener = new MouseAdapter() {
//		public void mouseClicked(MouseEvent e) {
//			//if (e.getClickCount()==1) {
//				if (getItemChargeTable().getSelectedRowCount()>0) {
//					getRightJText_ItemCode().setText(getListTable().getSelectedRowContent()[1]);
//					getRightJText_higherRate().setText(getItemChargeTable().getSelectedRowContent()[9]);
//					getRightJCombo_ItcType().setText(getItemChargeTable().getSelectedRowContent()[3]);
//					getRightJText_PackageCode().setText(getItemChargeTable().getSelectedRowContent()[4]);
//					getRightJText_ChaeperRate().setText(getItemChargeTable().getSelectedRowContent()[8]);
//					getRightJCombo_AcmCode().setText(getItemChargeTable().getSelectedRowContent()[6]);
//					getRightJText_GLCode().setText(getItemChargeTable().getSelectedRowContent()[7]);
//					getRightJText_Contracted().setText(getItemChargeTable().getSelectedRowContent()[11]);
//					getRightJCombo_Set().setText(getItemChargeTable().getSelectedRowContent()[10]);
//					cicid=getItemChargeTable().getSelectedRowContent()[1];
//				}
//			//}
//		}
//	};  //  @jve:decl-index=0:

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		showHistory();
		return getLeftJText_ItemCode();
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getRightJText_higherRate().getText()==null ||getRightJText_higherRate().getText().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Higher Rate.");
			actionValidationReady(actionType, false);
		} else if (getRightJCombo_ItcType().getText()==null ||getRightJCombo_ItcType().getText().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Itc Type.");
			actionValidationReady(actionType, false);
		} else if (getRightJText_GLCode().getText()==null || getRightJText_GLCode().getText().length()==0) {
			Factory.getInstance().addErrorMessage("Empty GL Code.");
			actionValidationReady(actionType, false);
		} else if (getRightJText_ChaeperRate().getText()==null || getRightJText_ChaeperRate().getText().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Chaeper Rate.");
			actionValidationReady(actionType, false);
		} else {
			actionValidationReady(actionType, true);
		}
	}

	@Override
	protected void appendDisabledFields() {
		cicid="";
		getRightJText_ItemCode().setEnabled(false);
		getRightJText_higherRate().setEnabled(true);
		getRightJCombo_ItcType().setEnabled(true);
		getRightJText_PackageCode().setEnabled(true);
		getRightJText_ChaeperRate().setEnabled(true);
		getRightJCombo_AcmCode().setEnabled(true);
		getRightJText_GLCode().setEnabled(true);
		getRightJText_Contracted().setEnabled(true);
		getRightJCombo_Set().setEnabled(true);
		//vlidaHCC();
		}
	@Override
	public void appendAction() {
		// TODO Auto-generated method stub
		getSaveButton().setEnabled(true);
		getRightJText_higherRate().resetText();
		getRightJCombo_ItcType().resetText();
		getRightJText_PackageCode().resetText();
		getRightJText_ChaeperRate().resetText();
		getRightJCombo_AcmCode().resetText();
		getRightJText_GLCode().resetText();
		getRightJText_Contracted().resetText();
		getRightJCombo_Set().resetText();
		appendDisabledFields();
		super.appendAction();

	}
	@Override
	public void saveAction() {
		// TODO Auto-generated method stub
		super.saveAction();
	}

	@Override
	protected void confirmCancelButtonClicked() {}
	@Override
	protected void deleteDisabledFields() {}

	protected String[] getBrowseInputParameters() {
		// TODO Auto-generated method stub
		return new String[] {
				getLeftJText_ItemCode().getText(),
				getLeftJCombo_ItemType().getText(),
				getUserInfo().getDeptCode()
		};
	}

	@Override
	protected String[] getFetchInputParameters() {
		// TODO Auto-generated method stub

//		if (getItemChargeTable().getSelectedRow()>0) {
			String[] selectedContent = getItemChargeTable().getSelectedRowContent();
			return new String[] {
					selectedContent[1]
			};
//		} else {
//			String[] selectedContent=getListTable().getSelectedRowContent();
//			return new String[] {selectedContent[0]};
//		}
	}

	protected String[] getActionInputParamaters() {
		// TODO Auto-generated method stub
		String[] param = new String[] {
				cicid,
				getRightJText_ItemCode().getText(),
				getRightJText_PackageCode().getText(),
				getRightJCombo_AcmCode().getText(),
				getRightJCombo_ItcType().getText(),
				getRightJText_GLCode().getText(),
				getRightJText_higherRate().getText(),
				getRightJText_ChaeperRate().getText(),
				getRightJCombo_Set().getText(),
				getRightJText_Contracted().getText()

		};
		for (String string : param) {
			System.out.println(string+"................................");
		}
		return param;
	}

	@Override
	protected void getFetchOutputValues(String[] outParam) {
		// TODO Auto-generated method stub
		showHistory();

		getRightJText_ItemCode().setText(outParam[1]);
		if (getItemChargeTable().getSelectedRowCount()>0) {
		getRightJText_higherRate().setText(getItemChargeTable().getSelectedRowContent()[9]);
		getRightJCombo_ItcType().setText(getItemChargeTable().getSelectedRowContent()[3]);
		getRightJText_PackageCode().setText(getItemChargeTable().getSelectedRowContent()[4]);
		getRightJText_ChaeperRate().setText(getItemChargeTable().getSelectedRowContent()[8]);
		getRightJCombo_AcmCode().setText(getItemChargeTable().getSelectedRowContent()[6]);
		getRightJText_GLCode().setText(getItemChargeTable().getSelectedRowContent()[7]);
		getRightJText_Contracted().setText(getItemChargeTable().getSelectedRowContent()[11]);
		getRightJCombo_Set().setText(getItemChargeTable().getSelectedRowContent()[10]);
		cicid=getItemChargeTable().getSelectedRowContent()[1];
		}
		//vlidaHCC();
	}

	private void vlidaHCC() {
		// TODO Auto-generated method stub
		if (getItemChargeTable().getSelectedRowContent()[11].length()==0) {
			getRightJText_Contracted().setEnabled(false);
		} else {
			getRightJText_higherRate().setEnabled(false);
			getRightJText_ChaeperRate().setEnabled(false);
			getRightJText_Contracted().setEnabled(true);
		}
		if (getItemChargeTable().getSelectedRowContent()[8].length()==0 || getItemChargeTable().getSelectedRowContent()[9].length()==0) {
			getRightJText_Contracted().setEnabled(true);
		} else {
			getRightJText_Contracted().setEnabled(false);
		}
	}

	protected void showHistory() {
		if (getListTable().getRowCount()>0) {
//			QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.BIRTHLOGHIS_TXCODE, new String[] {getListSelectedRow()[2]});
			QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.ADDCREDITITEM_TXCODE,
					new String[] {getListSelectedRow()[1],getLeftJCombo_Set().getText()},
					new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								getItemChargeTable().setListTableContent(mQueue);
								//getHistoryCount().setText(String.valueOf(getItemChargeTable().getRowCount()));
							} else {
								getItemChargeTable().removeAllRow();
								//clear text
								getRightJText_ItemCode().resetText();
								getRightJText_higherRate().resetText();
								getRightJCombo_ItcType().resetText();
								getRightJText_PackageCode().resetText();
								getRightJText_ChaeperRate().resetText();
								getRightJCombo_AcmCode().resetText();
								getRightJText_GLCode().resetText();
								getRightJText_Contracted().resetText();
								getRightJCombo_Set().resetText();
							}
						}
					});
		}
	}
	protected BasePanel getRightPanel() {
		// TODO Auto-generated method stub
		if (rightPanel == null) {
			// create tabbed panel
			rightPanel = new BasePanel();
			rightPanel.setSize(800, 157);
		}
		return rightPanel;
	}

	@Override
	protected void modifyDisabledFields() {
		// TODO Auto-generated method stub

		getRightJText_ItemCode().setEnabled(false);
		getRightJText_higherRate().setEnabled(true);
		getRightJCombo_ItcType().setEnabled(true);
		getRightJText_PackageCode().setEnabled(true);
		getRightJText_ChaeperRate().setEnabled(true);
		getRightJCombo_AcmCode().setEnabled(true);
		getRightJText_GLCode().setEnabled(true);
		getRightJText_Contracted().setEditable(true);
		getRightJCombo_Set().setEnabled(true);
	}

	@Override
	protected BasePanel getLeftPanel() {
		// TODO Auto-generated method stub
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.setSize(779, 308);
			leftPanel.add(getViewPanel(),null);
			leftPanel.add(getGeneralPanel(), null);
			leftPanel.add(getItemChargeJScrollPane(),null);
			leftPanel.add(getCreate_set(),null);
			leftPanel.add(getEdit_set(),null);
		}
		return leftPanel;
	}

	private TextString getLeftJText_ItemCode() {
		if (LeftJText_ItemCode == null) {
			LeftJText_ItemCode = new TextItemCode();
			LeftJText_ItemCode.setBounds(100, 15, 150, 20);
		}
		return LeftJText_ItemCode;
	}

	private ComboItemType getLeftJCombo_ItemType() {
		if (LeftJCombo_ItemType == null) {
			LeftJCombo_ItemType = new ComboItemType();
			LeftJCombo_ItemType.setBounds(580, 15, 150, 20);
		}
		return LeftJCombo_ItemType;
	}

	private ComboSetPrice getLeftJCombo_Set() {
		if (LeftJCombo_Set == null) {
			LeftJCombo_Set = new ComboSetPrice();
			LeftJCombo_Set.setBounds(320,15,150,20);
		}
		return LeftJCombo_Set;
	}

	private BasePanel getViewPanel() {
		if (viewPanel == null) {
			viewPanel = new BasePanel();
			viewPanel.setHeading("Item Information");
			viewPanel.setBounds(5, 5, 757, 55);
			viewPanel.add(getLeftJLabel_ItemCodeDesc(),null);
			viewPanel.add(getLeftJText_ItemCode(),null);
			viewPanel.add(getLeftJLabel_ItemTypeDesc(),null);
			viewPanel.add(getLeftJCombo_ItemType(),null);
			viewPanel.add(getLeftJLabel_SetDesc(),null);
			viewPanel.add(getLeftJCombo_Set(),null);
		}
		return viewPanel;
	}

	private TextString getRightJText_ItemCode() {
		if (RightJText_ItemCode == null) {
			RightJText_ItemCode = new TextString(3);
			RightJText_ItemCode.setBounds(90, 30, 166, 20);
		}
		return RightJText_ItemCode;
	}

	private TextString getRightJText_higherRate() {
		if (RightJText_higherRate == null) {
			RightJText_higherRate = new TextString(3);
			RightJText_higherRate.setBounds(345, 30, 166, 20);
		}
		return RightJText_higherRate;
	}

	private ComboItcType getRightJCombo_ItcType() {
		if (RightJCombo_ItcType == null) {
			RightJCombo_ItcType = new ComboItcType();
			RightJCombo_ItcType.setBounds(587, 30, 166, 20);
		}
		return RightJCombo_ItcType;
	}

	private TextString getRightJText_PackageCode() {
		if (RightJText_PackageCode == null) {
			RightJText_PackageCode = new TextString() {
				public void onBlur() {
					if (RightJText_PackageCode.getText()==null||RightJText_PackageCode.getText().trim().length()==0) {
						return;
					}
					QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] {"CreditPkg","pkgcode","pkgcode='"+RightJText_PackageCode.getText()+"'"},
							new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(MessageQueue mQueue) {
									if (!mQueue.success()) {
										Factory.getInstance().addErrorMessage("Invalid Package Code.");
										RightJText_PackageCode.requestFocus();
										RightJText_PackageCode.resetText();
									}
								}
							});
				};
			};
			RightJText_PackageCode.setBounds(90, 61, 166, 20);
		}
		return RightJText_PackageCode;
	}

	private TextString getRightJText_ChaeperRate() {
		if (RightJText_ChaeperRate == null) {
			RightJText_ChaeperRate = new TextString();
			RightJText_ChaeperRate.setBounds(344, 64, 166, 20);
		}
		return RightJText_ChaeperRate;
	}

	private ComboACMCode getRightJCombo_AcmCode() {
		if (RightJCombo_AcmCode == null) {
			RightJCombo_AcmCode = new ComboACMCode();
			RightJCombo_AcmCode.setBounds(587, 64, 166, 20);
		}
		return RightJCombo_AcmCode;
	}

	private TextString getRightJText_GLCode() {
		if (RightJText_GLCode == null) {
			RightJText_GLCode = new TextString() {
				public void onBlur() {
					if (RightJText_GLCode.isEmpty()) {
						return;
					}
					QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] {"glcode","glccode","glccode='"+RightJText_GLCode.getText()+"'"},
							new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(MessageQueue mQueue) {
									if (!mQueue.success()) {
										Factory.getInstance().addErrorMessage("Invalid Package Code.");
										RightJText_GLCode.requestFocus();
										RightJText_GLCode.resetText();
									}
								}
							});
				}
			};
			RightJText_GLCode.setBounds(90, 89, 166, 20);
		}
		return RightJText_GLCode;
	}

	private TextString getRightJText_Contracted() {
		if (RightJText_Contracted==null) {
			RightJText_Contracted=new TextString();
			RightJText_Contracted.setBounds(344, 89, 166, 20);
		}
		return RightJText_Contracted;
	}

	private ComboSetPrice getRightJCombo_Set() {
		if (RightJCombo_Set==null) {
			RightJCombo_Set=new ComboSetPrice();
			RightJCombo_Set.setBounds(587, 89, 166, 20);
		}
		return RightJCombo_Set;
	}

	private LabelBase getLeftJLabel_ItemCodeDesc() {
		if (LeftJLabel_ItemCodeDesc == null) {
			LeftJLabel_ItemCodeDesc = new LabelBase();
			LeftJLabel_ItemCodeDesc.setText("Item Code");
			LeftJLabel_ItemCodeDesc.setBounds(31, 16, 62, 20);
		}
		return LeftJLabel_ItemCodeDesc;
	}

	private LabelBase getLeftJLabel_ItemTypeDesc() {
		if (LeftJLabel_ItemTypeDesc == null) {
			LeftJLabel_ItemTypeDesc = new LabelBase();
			LeftJLabel_ItemTypeDesc.setText("Item Type");
			LeftJLabel_ItemTypeDesc.setBounds(500, 15, 68, 20);
	 }
		return LeftJLabel_ItemTypeDesc;
	}
	private LabelBase getLeftJLabel_SetDesc() {
		if (LeftJLabel_SetDesc == null) {
			LeftJLabel_SetDesc = new LabelBase();
			LeftJLabel_SetDesc.setText("Set");
			LeftJLabel_SetDesc.setBounds(268,15, 29, 20);
	 }
		return LeftJLabel_SetDesc;
	}
	private BasePanel getGeneralPanel() {
		if (generalPanel == null) {
			Right_ItemCodeDesc = new LabelBase();
			Right_ItemCodeDesc.setBounds(13, 30, 53, 20);
			Right_ItemCodeDesc.setText("Item Code");
			RightJLabel_higherRateDesc = new LabelBase();
			RightJLabel_higherRateDesc.setBounds(268, 30, 68, 20);
			RightJLabel_higherRateDesc.setText("Higher Rate");
			RightJLabel_ItcTypeDesc = new LabelBase();
			RightJLabel_ItcTypeDesc.setBounds(526, 30, 59, 20);
			RightJLabel_ItcTypeDesc.setText("Itc Type");
			RightJLabel_PackageCodeDesc = new LabelBase();
			RightJLabel_PackageCodeDesc.setBounds(13, 60, 71, 20);
			RightJLabel_PackageCodeDesc.setText("Package Code");
			RightJLabel_CheaeperRateDesc = new LabelBase();
			RightJLabel_CheaeperRateDesc.setBounds(267, 60, 72, 20);
			RightJLabel_CheaeperRateDesc.setText("Chaeper Rate");
			RightJLabel_AcmCodeDesc = new LabelBase();
			RightJLabel_AcmCodeDesc.setBounds(525, 60, 60, 20);
			RightJLabel_AcmCodeDesc.setText("ACM. Code");
			RightJLabel_GLCodeDesc = new LabelBase();
			RightJLabel_GLCodeDesc.setBounds(12, 89, 66, 20);
			RightJLabel_GLCodeDesc.setText("GL Code");
			RightJLabel_ContractedDesc = new LabelBase();
			RightJLabel_ContractedDesc.setBounds(266, 89, 77, 20);
			RightJLabel_ContractedDesc.setText("Contracted %");
			RightJLabel_SetDesc = new LabelBase();
			RightJLabel_SetDesc.setBounds(525, 89, 21, 20);
			RightJLabel_SetDesc.setText("Set");

			generalPanel = new BasePanel();
			generalPanel.setLayout(null);
			generalPanel.setBounds(0, 60, 765, 127);
			generalPanel.setHeading("Cashier Information");
			generalPanel.add(Right_ItemCodeDesc, null);
			generalPanel.add(RightJLabel_higherRateDesc, null);
			generalPanel.add(getRightJText_ItemCode(), null);
			generalPanel.add(getRightJText_higherRate(), null);

			generalPanel.add(RightJLabel_ItcTypeDesc, null);
			generalPanel.add(RightJLabel_PackageCodeDesc, null);
			generalPanel.add(RightJLabel_CheaeperRateDesc, null);
			generalPanel.add(RightJLabel_AcmCodeDesc, null);
			generalPanel.add(RightJLabel_GLCodeDesc,null);
			generalPanel.add(RightJLabel_ContractedDesc,null);
			generalPanel.add(RightJLabel_SetDesc,null);

			generalPanel.add(getRightJCombo_ItcType(), null);
			generalPanel.add(getRightJText_PackageCode(), null);
			generalPanel.add(getRightJText_ChaeperRate(), null);
			generalPanel.add(getRightJCombo_AcmCode(), null);
			generalPanel.add(getRightJText_GLCode(), null);
			generalPanel.add(getRightJText_Contracted(), null);
			generalPanel.add(getRightJCombo_Set(), null);
		}
		return generalPanel;
	}

	private TableList getItemChargeTable() {
		if (ItemChargeTable == null) {
			ItemChargeTable = new TableList(getDVATableColumnNames(), getDVATableColumnWidths()) {
				public void onSelectionChanged() {
					System.out.println("the value:"+getItemChargeTable().getSelectedRowContent()[1]);
					getRightJText_ItemCode().setText(getListTable().getSelectedRowContent()[1]);
					getRightJText_higherRate().setText(getItemChargeTable().getSelectedRowContent()[9]);
					getRightJCombo_ItcType().setText(getItemChargeTable().getSelectedRowContent()[3]);
					getRightJText_PackageCode().setText(getItemChargeTable().getSelectedRowContent()[4]);
					getRightJText_ChaeperRate().setText(getItemChargeTable().getSelectedRowContent()[8]);
					getRightJCombo_AcmCode().setText(getItemChargeTable().getSelectedRowContent()[6]);
					getRightJText_GLCode().setText(getItemChargeTable().getSelectedRowContent()[7]);
					getRightJText_Contracted().setText(getItemChargeTable().getSelectedRowContent()[11]);
					getRightJCombo_Set().setText(getItemChargeTable().getSelectedRowContent()[10]);
					cicid=getItemChargeTable().getSelectedRowContent()[1];
				}
			};
//			ItemChargeTable.setTableLength(getListWidth());
		}
		return ItemChargeTable;
	}

	private JScrollPane getItemChargeJScrollPane() {
		if (ItemChargeJScrollPane == null) {
			ItemChargeJScrollPane = new JScrollPane();
			ItemChargeJScrollPane.setViewportView(getItemChargeTable());
			ItemChargeJScrollPane.setBounds(10,380, 755, 150);
		}
		return ItemChargeJScrollPane;
	}

	private ButtonBase getCreate_set() {
		if (create_set==null) {
			create_set=new ButtonBase() {
				@Override
				public void onClick() {
					new DlgCreateSet(getMainFrame(), "");
				}
			};
			create_set.setText("Create a New Set");
			create_set.setBounds(10, 550, 150, 25);
		}
		return create_set;
	}

	private ButtonBase getEdit_set() {
		if (edit_set==null) {
			edit_set=new ButtonBase() {
				@Override
				public void onClick() {
					new DlgCreateSet(getMainFrame(), "editset");
				}
			};
			edit_set.setText("Edit a Set");
			edit_set.setBounds(200, 550, 150, 25);
		}
		return edit_set;
	}
}