package com.hkah.client.tx.admin.codetable;

import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboItemCat;
import com.hkah.client.layout.combobox.ComboItemType;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextItemCode;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class Item extends MaintenancePanel {

	private boolean returndata1 = false;
	private boolean returndata2 = false;
	private boolean checkdata = true;

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.ITEM_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.ITEM_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"Item Code",
			"Item Name",
			"Item Chinese Name",
			"Item Type",
			"Report Level",
			"Dept Service Code",
			"Dept Service Desc",
			"Dept Code",
			"Dept Name",
			"STECODE",
			"ITMPOVERRD",
			"ITMDOCCR",
			"Category",
			"Group"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				80,
				80,
				120,
				80,
				80,
				120,
				120,
				80,
				120,
				0,
				0,
				0,
				80,
				80
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel rightPanel=null;
	private ColumnLayout leftPanel=null;
	private ColumnLayout ParaPanel = null;
	private LabelBase itemCodeDesc=null;
	private TextItemCode itemCode=null;
	private LabelBase itemNameDesc=null;
	private TextString itemName=null;
	private LabelBase itemCNameDesc=null;
	private TextString itemCName=null;
	private LabelBase itmCategoryDesc=null;
	private ComboItemCat itmCategory=null;
	private LabelBase itemTypeDesc=null;
	private ComboItemType itemType=null;
	private LabelBase dptCodeDesc=null;
	private TextString dptCode=null;
	private LabelBase rptLvlDesc=null;
	private TextString rptLvl=null;
	private LabelBase grpDesc=null;
	private TextString grp=null;
	private LabelBase itmOnFeeDesc=null;
	private CheckBoxBase itmOnFee=null;
	private LabelBase docDrDesc=null;
	private CheckBoxBase docDr=null;
	private LabelBase dptServiceCodeDesc=null;
	private TextString dptServiceCode=null;
	private BasePanel ListPanel = null;

	/**
	 * This method initializes
	 *
	 */
	public Item() {
		super();
		getListTable().setHeight(300);
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
//		getJScrollPane().setBounds(15, 25, 725, 290);
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		//disableButton();
		getAppendButton().setEnabled(true);
		getModifyButton().setEnabled(true);
		getDeleteButton().setEnabled(true);
		getSaveButton().setEnabled(true);
		getSearchButton().setEnabled(true);
		//PanelUtil.setAllFieldsEditable(getParaPanel(), false);
		//this.searchAction();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getItemCode();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
		getSaveButton().setEnabled(true);
		getItemCode().setEnabled(true);
		getItemName().setEnabled(true);
		getItemType().setEnabled(true);
		getDptCode().setEnabled(true);
		getItemCName().setEnabled(true);
		getItmCategory().setEnabled(true);
		getDptServiceCode().setEnabled(true);
		getRptLvl().setEnabled(true);
		getGrp().setEnabled(true);
		getItmOnFee().setEnabled(true);
		getDocDr().setEnabled(true);
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		getItemCode().setEnabled(false);
		getItemName().setEnabled(true);
		getItemType().setEnabled(true);
		getDptCode().setEnabled(true);
		getItemCName().setEnabled(true);
		getItmCategory().setEnabled(true);
		getDptServiceCode().setEnabled(true);
		getRptLvl().setEnabled(true);
		getGrp().setEnabled(true);
		getItmOnFee().setEnabled(true);
		getDocDr().setEnabled(true);
	}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	@Override
	protected void deleteDisabledFields() {}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		return true;
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				"",
				"",
				"",
				"",
				"",
				"",
				""
		};
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		String[] selectedContent=getListSelectedRow();
		return new String[] {
				selectedContent[0]
		};
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
		int index=0;
		getItemCode().setText(outParam[index++]);
		getItemName().setText(outParam[index++]);
		getItemCName().setText(outParam[index++]);
		getItemType().setText(outParam[index++]);
		getRptLvl().setText(outParam[index++]);
		getDptServiceCode().setText(outParam[index++]);
		index++;
		getDptCode().setText(outParam[index++]);
		index++;
		index++;
		getItmOnFee().setText(outParam[index++]);
		getDocDr().setText(outParam[index++]);
		getItmCategory().setText(outParam[index++]);
		getGrp().setText(outParam[index++]);
	}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected void actionValidation(final String actionType) {
		returndata1 = false;
		returndata2 = false;
		checkdata = true;

		String txCode = ConstantsTx.LOOKUP_TXCODE;
		String[] para = null;

		if (getDptCode().getText().trim().length()>0) {
			para=new String[] {"DpServ", "DscCode", "DscCode='" + getDptCode().getText().trim() + "'"};
			QueryUtil.executeMasterFetch(getUserInfo(), txCode, para, new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					returndata1 = true;
					if (!mQueue.success()) {
						checkdata = false;
						Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_DEPARTMENT_CODE);
					}
					actionValidationPreReady(actionType);
				}
			});
		}
		if (getDptServiceCode().getText().trim().length()>0) {
			para=new String[] {"Dept", "DptCode", "DptCode='" + getDptServiceCode().getText().trim() + "'"};
			QueryUtil.executeMasterFetch(getUserInfo(), txCode, para, new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					returndata2 = true;
					if (!mQueue.success()) {
						checkdata = false;
						Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_DEPARTMENT_SERVICES_CODE);
					}
					actionValidationPreReady(actionType);
				}
			});
		} else {
			checkdata = false;
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_DEPARTMENT_SERVICES_CODE_EMPTY);
		}
	}

	private void actionValidationPreReady(String actionType) {
		if (returndata1 && returndata2) {
			actionValidationReady(actionType, checkdata);
		}
	}

	@Override
	protected void clearTableFields() {
		super.clearTableFields();
		setCurrentTable(10,"N");
		setCurrentTable(11,"N");
	}

	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[0].trim().length() == 0 || selectedContent[0] == null) {
			Factory.getInstance().addErrorMessage("Empty Item Code.");
			return false;
		} else if (selectedContent[1].trim().length() == 0 || selectedContent[1] == null) {
			Factory.getInstance().addErrorMessage("Empty Item Name.");
			return false;
		} else if (selectedContent[3].trim().length() == 0 || selectedContent[3] == null) {
			Factory.getInstance().addErrorMessage("Empty Type.");
			return false;
		} else if (selectedContent[4].trim().length() == 0 || selectedContent[4] == null) {
			Factory.getInstance().addErrorMessage("Empty Report Level.");
			return false;
		} else if (selectedContent[5].trim().length() == 0 || selectedContent[5] == null) {
			Factory.getInstance().addErrorMessage("Empty Service Code.");
			return false;
		} else if (selectedContent[12].trim().length() == 0 || selectedContent[12] == null) {
			Factory.getInstance().addErrorMessage("Empty Category.");
			return false;
		}
		return true;
	}

	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		// TODO Auto-generated method stub
		return new String[] {
				selectedContent[0],
				selectedContent[1],
				selectedContent[2],
				selectedContent[3],
				selectedContent[4],
				selectedContent[12],
				selectedContent[5],
				selectedContent[7],
				"Y".equals(selectedContent[10])?"-1":"0",
				"Y".equals(selectedContent[11])?"-1":"0",
				selectedContent[13]
		};
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

//	protected JSplitPane getBodyPanel(boolean requiredScroll) {
//		// add button to left panel
//		//getLeftPanel().add(getJScrollPane(), null);
//		// add left/right pannel
//		getjSplitPane().setLeftComponent(getLeftPanel());
//
//		if (isRequiredScroll()) {
//			JScrollPane jScrollPanel = new JScrollPane(JScrollPane.VERTICAL_SCROLLBAR_ALWAYS, JScrollPane.HORIZONTAL_SCROLLBAR_NEVER);
//			jScrollPanel.setViewportView(getRightPanel());
//			//getjSplitPane().setRightComponent(jScrollPanel);
//			//jSplitPane.setRightComponent(new JScrollPane(getRightPanel(), JScrollPane.VERTICAL_SCROLLBAR_ALWAYS, JScrollPane.HORIZONTAL_SCROLLBAR_NEVER));
//		} else {
//			//getjSplitPane().setRightComponent(getRightPanel());
//		}
//		getjSplitPane().setPreferredSize(new Dimension(1017, 619));
//		getjSplitPane().setDividerLocation(395);
//		getjSplitPane().setDividerSize(3);
//		//setLeftAlignPanel();
//		return getjSplitPane();
//	}

	//action method override end
	/* >>> getter methods for init the Component start from here ================================== <<< */
	@Override
	protected ColumnLayout getSearchPanel() {
//		if (leftPanel == null) {
//			leftPanel = new ColumnLayout(1,1);
//			//leftPanel.setSize(779, 528);
//			//leftPanel.add(getParaPanel(),null);
//			//leftPanel.add(getListPanel(), null);
//		}
//		return leftPanel;

		return null;
	}

	public ColumnLayout getActionPanel() {
		if (ParaPanel == null) {
			ParaPanel = new ColumnLayout(6,4);
			ParaPanel.setHeading("Item Information");
			//ParaPanel.setSize(757, 120);
			ParaPanel.add(0,0,getItemCodeDesc());
			ParaPanel.add(1,0,getItemCode());
			ParaPanel.add(2,0,getItemNameDesc());
			ParaPanel.add(3,0,getItemName());
			ParaPanel.add(4,0,getItemTypeDesc());
			ParaPanel.add(5,0,getItemType());
			ParaPanel.add(0,1,getDptCodeDesc());
			ParaPanel.add(1,1,getDptCode());
			ParaPanel.add(2,1,getItemCNameDesc());
			ParaPanel.add(3,1,getItemCName());
			ParaPanel.add(4,1,getItmCategoryDesc());
			ParaPanel.add(5,1,getItmCategory());
			ParaPanel.add(0,2,getDptServiceCodeDesc());
			ParaPanel.add(1,2,getDptServiceCode());
			ParaPanel.add(2,2,getRptLvlDesc());
			ParaPanel.add(3,2,getRptLvl());
			ParaPanel.add(4,2,getGrpDesc());
			ParaPanel.add(5,2,getGrp());
			ParaPanel.add(0,3,getItmOnFeeDesc());
			ParaPanel.add(1,3,getItmOnFee());
			ParaPanel.add(2,3,getDocDrDesc());
			ParaPanel.add(3,3,getDocDr());
			//ParaPanel.add(6,2,itemCNameDesc);
		}
		return ParaPanel;
	}

	public LabelBase getItemCodeDesc() {
		if (itemCodeDesc == null) {
			itemCodeDesc = new LabelBase();
			itemCodeDesc.setText("Item Code");
//			itemCodeDesc.setBounds(5, 15, 90, 20);
		}
		return itemCodeDesc;
	}

	public TextItemCode getItemCode() {
		if (itemCode == null) {
			itemCode = new TextItemCode(getListTable(), 0);
		}
		return itemCode;
	}

	public LabelBase getItemNameDesc() {
		if (itemNameDesc == null) {
			itemNameDesc = new LabelBase();
			itemNameDesc.setText("Item Name");
//			itemNameDesc.setBounds(255,15,90,20);
		}
		return itemNameDesc;
	}

	public TextString getItemName() {
		if (itemName == null) {
			itemName = new TextString(getListTable(), 1);
		}
		return itemName;
	}

	public LabelBase getItemTypeDesc() {
		if (itemTypeDesc == null) {
			itemTypeDesc = new LabelBase();
			itemTypeDesc.setText("Item Type");
//			itemTypeDesc.setBounds(505, 15, 90, 20);
		}
		return itemTypeDesc;
	}

	public ComboItemType getItemType() {
		if (itemType == null) {
			itemType = new ComboItemType() {
				public void onClick() {
					setCurrentTable(3, itemType.getText());
				}
			};
//			itemType.setBounds(600, 15, 150, 20);
		}
		return itemType;
	}

	public LabelBase getDptCodeDesc() {
		if (dptCodeDesc == null) {
			dptCodeDesc = new LabelBase();
			dptCodeDesc.setText("Department Code");
//			dptCodeDesc.setBounds(5, 40, 90, 20);
		}
		return dptCodeDesc;
	}

	public TextString getDptCode() {
		if (dptCode == null) {
			dptCode = new TextString(10) {
				public void onReleased() {
					setCurrentTable(7,dptCode.getText());
				}
				public void onBlur() {
					QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] {"Dept","DptCode","DptCode='"+dptCode.getText()+"'"},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (!mQueue.success()) {
								dptCode.requestFocus();
								dptCode.resetText();
								Factory.getInstance().addErrorMessage("Invalid deparment code.");
							} else {
								setCurrentTable(7,dptCode.getText());
							}
						}
					});
				};
			};
//			dptCode.setBounds(100, 40, 150, 20);
		}
		return dptCode;
	}

	public LabelBase getItemCNameDesc() {
		if (itemCNameDesc == null) {
			itemCNameDesc = new LabelBase();
			itemCNameDesc.setText("Item CName");
//			itemCNameDesc.setBounds(255, 40, 90, 20);
		}
		return itemNameDesc;
	}

	public TextString getItemCName() {
		if (itemCName == null) {
			itemCName = new TextString(getListTable(), 2);

		}
		return itemCName;
	}

	public LabelBase getItmCategoryDesc() {
		if (itmCategoryDesc == null) {
			itmCategoryDesc = new LabelBase();
			itmCategoryDesc.setText("Category");
//			itmCategoryDesc.setBounds(505, 40, 90, 20);
		}
		return itmCategoryDesc;
	}

	public ComboItemCat getItmCategory() {
		if (itmCategory == null) {
			itmCategory = new ComboItemCat() {
				public void onClick() {
					setCurrentTable(12,itmCategory.getText());
				}
			};
//			itmCategory.setBounds(600, 40, 150, 20);
		}
		return itmCategory;
	}

	public LabelBase getDptServiceCodeDesc() {
		if (dptServiceCodeDesc == null) {
			dptServiceCodeDesc = new LabelBase();
			dptServiceCodeDesc.setText("Service Code");
//			dptServiceCodeDesc.setBounds(5, 65, 90, 20);
		}
		return dptServiceCodeDesc;
	}

	public TextString getDptServiceCode() {
		if (dptServiceCode == null) {
			dptServiceCode = new TextString() {
				public void onReleased() {
					setCurrentTable(5,dptServiceCode.getText());
				}
				public void onBlur() {
					QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] {"DpServ","DscCode","DscCode='"+dptServiceCode.getText()+"'"},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (!mQueue.success()) {
								dptServiceCode.requestFocus();
								dptServiceCode.resetText();
								Factory.getInstance().addErrorMessage("Invalid department services code.");
							} else {
								setCurrentTable(5,dptServiceCode.getText());
							}
						}
					});

				};
			};
//			dptServiceCode.setBounds(100, 65, 150, 20);
		}
		return dptServiceCode;
	}

	public LabelBase getRptLvlDesc() {
		if (rptLvlDesc == null) {
			rptLvlDesc = new LabelBase();
			rptLvlDesc.setText("Report Level");
//			rptLvlDesc.setBounds(255, 65, 90, 20);
		}
		return rptLvlDesc;
	}

	public TextString getRptLvl() {
		if (rptLvl == null) {
			rptLvl = new TextString(getListTable(), 4);
		}
		return rptLvl;
	}

	public LabelBase getGrpDesc() {
		if (grpDesc == null) {
			grpDesc = new LabelBase();
			grpDesc.setText("Group");
//			grpDesc.setBounds(405, 65, 50, 20);
		}
		return grpDesc;
	}

	public TextString getGrp() {
		if (grp == null) {
			grp = new TextString(1,getListTable(), 13);
		}
		return grp;
	}

	public LabelBase getItmOnFeeDesc() {
		if (itmOnFeeDesc == null) {
			itmOnFeeDesc = new LabelBase();
			itmOnFeeDesc.setText("<html>Print Item On Override Fee Report</html>");
//			itmOnFeeDesc.setBounds(505, 65, 70, 40);
		}
		return itmOnFeeDesc;
	}

	public CheckBoxBase getItmOnFee() {
		if (itmOnFee == null) {
			itmOnFee = new CheckBoxBase(getListTable(),10);
		}
		return itmOnFee;
	}

	public LabelBase getDocDrDesc() {
		if (docDrDesc == null) {
			docDrDesc = new LabelBase();
			docDrDesc.setText("Dr.Cr.");
			docDrDesc.setBounds(610, 65, 40, 20);
		}
		return docDrDesc;
	}

	public CheckBoxBase getDocDr() {
		if (docDr == null) {
			docDr = new CheckBoxBase(getListTable(),11);
			docDr.setBounds(655, 65, 29, 20);
		}
		return docDr;
	}

	public BasePanel getListPanel() {
		if (ListPanel == null) {
			ListPanel = new BasePanel();
			ListPanel.setHeading("Item List");
//			ListPanel.setBounds(5, 130, 757, 336);
			this.getLeftPanel().remove(this.getJScrollPane());
			ListPanel.add(getJScrollPane());
		}
		return ListPanel;
	}
}