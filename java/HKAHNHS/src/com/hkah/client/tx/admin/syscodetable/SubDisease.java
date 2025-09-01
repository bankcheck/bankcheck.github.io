package com.hkah.client.tx.admin.syscodetable;

import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class SubDisease extends MaintenancePanel{

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.SUBDISEASE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.SUBDISEASE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"",
			"Code",
			"Sub-Disease",
			"NewCode",
			"Tab No.",
			"Row No.",
			"Sick Code",
			"Abbreviation",
			"IsPaired",
			"Sick Description"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				0,
				50,
				180,
				0,
				50,
				50,
				70,
				80,
				0,
				180
		};
	}

	private BasePanel rightPanel=null;
	private ColumnLayout leftPanel=null;
	private LabelBase OnlyNewCodeDesc=null;
	private CheckBoxBase OnlyNewCode=null;

	private ColumnLayout ParaPanel = null;
	private LabelBase CodeDesc=null;
	private TextString Code=null;
	private LabelBase SubDisNameDesc=null;
	private TextString SubDisName=null;
	private LabelBase TabNoDesc=null;
	private TextNum TabNo=null;
	private LabelBase RowNoDesc=null;
	private TextNum RowNo=null;
	private LabelBase SickCodeDesc=null;
	private TextString SickCode=null;
	private LabelBase AbbrDesc=null;
	private TextString Abbr=null;
	private LabelBase NewCodeDesc=null;
	private CheckBoxBase NewCode=null;
	private LabelBase IsPairDesc=null;
	private CheckBoxBase IsPair=null;

	private String oldCode = null;

//	private JScrollPane JScrollPane = null;
	private BasePanel ListPanel = null;  //  @jve:decl-index=0:visual-constraint="41,180"

	/**
	 * This method initializes
	 *
	 */
	public SubDisease() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
//		getJScrollPane().setBounds(10, 30, 730, 210);
		getLeftPanel().setBounds(500, 120, 0, 0);
		
		getListTable().setPosition(0 , 30);
		getListTable().setHeight(300);
		
		getAppendButton().setEnabled(true);
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		/*getAppendButton().setEnabled(false);
		getCancelButton().setEnabled(true);
		getPrintButton().setEnabled(false);
		getRefreshButton().setEnabled(false);
		getCancelButton().setEnabled(false);
		getAcceptButton().setEnabled(false);*/
		getAppendButton().setEnabled(true);
		getOnlyNewCode().setSelected(true);
		searchAction();
		

	}
	
	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getCode();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
		getCode().setEnabled(true);
		getCode().resetText();
		getSubDisName().setEnabled(true);
		getSubDisName().resetText();
		getTabNo().setEnabled(true);
		getTabNo().resetText();
		getRowNo().setEnabled(true);
		getRowNo().resetText();
		getSickCode().setEnabled(true);
		getSickCode().resetText();
		getAbbr().setEnabled(true);
		getAbbr().resetText();
		getNewCode().setEnabled(true);
		getNewCode().setSelected(false);
		getIsPair().setEnabled(true);
		getIsPair().setSelected(false);
				
		getListTable().setEnabled(false);
	}
	
	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		getCode().setEnabled(true);
		getSubDisName().setEnabled(true);
		getTabNo().setEnabled(true);
		getRowNo().setEnabled(true);
		getSickCode().setEnabled(true);
		getAbbr().setEnabled(true);
		getNewCode().setEnabled(true);
		getIsPair().setEnabled(true);
		
		getModifyButton().setEnabled(false);
		getDeleteButton().setEnabled(false);
		getListTable().setEnabled(false);
		oldCode = getCode().getText();		
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
				getOnlyNewCode().isSelected()?"-1":null
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
		int index=0;
		index++;
		getCode().setText(outParam[index++]);
		getSubDisName().setText(outParam[index++]);
		getNewCode().setSelected(("Y".equals(outParam[index++])));
		getTabNo().setText(outParam[index++]);
		getRowNo().setText(outParam[index++]);
		getSickCode().setText(outParam[index++]);
		getAbbr().setText(outParam[index++]);
		getIsPair().setSelected("Y".equals(outParam[index++]));
		index++;
	}

	/* >>> ~21~ Set Add New Row toclearPostAction table ============================== <<< */
	@Override
	protected void clearTableFields() {
		super.clearTableFields();
		setCurrentTable(3, "N");
		setCurrentTable(8, "N");
	}

	/* >>> ~22~ Set Action Input Parameters per table ===================== <<< */
	protected String[] getActionInputParamaters(String[] selectedContent) {
		// TODO Auto-generated method stub
		return new String[] {
			selectedContent[1],
			selectedContent[6],
			selectedContent[2],
			"Y".equals(selectedContent[3])?"-1":"0",
			selectedContent[4],
			selectedContent[5],
			selectedContent[7],
			"Y".equals(selectedContent[8])?"-1":"0",
			oldCode
		};
	}

	/* >>> ~23~ Set Action Validation per table =========================== <<< */
	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[1].trim().length() == 0 || selectedContent[1] == null) {
			Factory.getInstance().addErrorMessage("Empty Code!");
			return false;
		} else if (selectedContent[2].trim().length() == 0 || selectedContent[2] == null) {
			Factory.getInstance().addErrorMessage("Empty Sub-Disease Name!");
			return false;
		} else if (selectedContent[6].trim().length() == 0 || selectedContent[6] == null) {
			Factory.getInstance().addErrorMessage("Empty Sick Code!");
			return false;
		}
		return true;
	}
	
	@Override
	public void appendAction(){
		if (getAppendButton().isEnabled() && addActionValidation()) {
			clearTableFields();
			super.appendAction(false);
		}
	}
	
	@Override
	public boolean isTableViewOnly() {
		return false;
	}
	
	@Override
	protected void enableButton(String mode) {	
		super.enableButton(mode);
		if (isAppend() || isModify()){
			getClearButton().setEnabled(true);
			getSearchButton().setEnabled(false);
		}else{
			getClearButton().setEnabled(false);
			getSearchButton().setEnabled(true);
		}
		getRefreshButton().setEnabled(false);
	}
	

	@Override
	public void cancelYesAction() {
		searchAction();		
	}
	
	@Override
	public void clearAction() {
		clearTableFields();
		getCode().setText(EMPTY_VALUE);
		getSubDisName().setText(EMPTY_VALUE);
		getTabNo().setText(EMPTY_VALUE);
		getRowNo().setText(EMPTY_VALUE);
		getSickCode().setText(EMPTY_VALUE);
		getAbbr().setText(EMPTY_VALUE);
	}
	
	
	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected ColumnLayout getSearchPanel() {

		if (leftPanel == null) {
			leftPanel = new ColumnLayout(2,1 ,new int[] {95,30});
//			leftPanel.setSize(779, 528);
//			leftPanel.add(getParaPanel(),null);
//			leftPanel.add(getListPanel(), null);
			leftPanel.add(0,0,getOnlyNewCodeDesc());
			leftPanel.add(1,0,getOnlyNewCode());
			//leftPanel.setBounds(20,500,800, 100);
		}
		return leftPanel;
	}

	public LabelBase getOnlyNewCodeDesc() {
		if (OnlyNewCodeDesc == null) {
			OnlyNewCodeDesc = new LabelBase();
			OnlyNewCodeDesc.setText("New Code Only");
//			OnlyNewCodeDesc.setBounds(585, 161, 90, 20);
		}
		return OnlyNewCodeDesc;
	}

	public CheckBoxBase getOnlyNewCode() {
		if (OnlyNewCode == null) {
			OnlyNewCode = new CheckBoxBase() {
				public void onClick() {
					searchAction();
				}
			};
//			OnlyNewCode.setBounds(675, 161, 24, 20);
		 }
		return OnlyNewCode;
	}


	public ColumnLayout getActionPanel() {
		if (ParaPanel == null) {
			ParaPanel = new ColumnLayout(4,4,new int[] {80,180,120,270});
			ParaPanel.setHeading("Sub-Disease Informatiion");
			ParaPanel.add(0,0,getCodeDesc());
			ParaPanel.add(1,0,getCode());
			ParaPanel.add(2,0,getSubDisNameDesc());
			ParaPanel.add(3,0,getSubDisName());
			ParaPanel.add(0,1,getTabNoDesc());
			ParaPanel.add(1,1,getTabNo());
			ParaPanel.add(2,1,getRowNoDesc());
			ParaPanel.add(3,1,getRowNo());
			ParaPanel.add(0,2,getSickCodeDesc());
			ParaPanel.add(1,2,getSickCode());
			ParaPanel.add(2,2,getAbbrDesc());
			ParaPanel.add(3,2,getAbbr());
			ParaPanel.add(0,3,getNewCodeDesc());
			ParaPanel.add(1,3,getNewCode());
			ParaPanel.add(2,3,getIsPairDesc());
			ParaPanel.add(3,3,getIsPair());
//			ParaPanel.setSize(757, 146);
//			ParaPanel.add(getOnlyNewCodeDesc(), null);
			ParaPanel.setBounds(0, 0, 650, 125);
		}
		return ParaPanel;
	}

	public LabelBase getCodeDesc() {
		if (CodeDesc == null) {
			CodeDesc = new LabelBase();
			CodeDesc.setText("Code");
//			CodeDesc.setBounds(10, 20, 83, 20);
		}
		return CodeDesc;
	}

	public TextString getCode() {
		if (Code == null) {
			Code = new TextString() {
				@Override
				public void onReleased() {
					setCurrentTable(1,Code.getText());
				}
				
				@Override
				public void onBlur() {
					if(isAppend() || isModify()){
						if(!getCode().isEmpty()){
							if(isModify() && oldCode.equals(getCode().getText())){								
							}else{								
								QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,new String[] {"sdisease","sdscode"," sdscode='"+Code.getText()+"'"},
										new MessageQueueCallBack() {
									@Override
									public void onPostSuccess(MessageQueue mQueue) {
										if (mQueue.success()) {
											Factory.getInstance().addErrorMessage("Record exists.",getCode());
											getCode().resetText();
											setCurrentTable(1,"");
										} else {
											setCurrentTable(1,Code.getText());
										}
									}
								});
							}
						}
					}
				}
			};
			Code.setBounds(0, 0, 150, 20);

		 }
		return Code;
	}

	public LabelBase getSubDisNameDesc() {
		if (SubDisNameDesc == null) {
			SubDisNameDesc = new LabelBase();
			SubDisNameDesc.setText("Sub-Disease Name");
//			SubDisNameDesc.setBounds(269, 21, 126, 20);
		}
		return SubDisNameDesc;
	}

	public TextString getSubDisName() {
		if (SubDisName == null) {
			SubDisName = new TextString(){
				@Override
				public void onReleased() {
					setCurrentTable(2,SubDisName.getText());
				}			
			};
			SubDisName.setBounds(0, 0, 250, 20);
		 }
		return SubDisName;
	}

	public LabelBase getTabNoDesc() {
		if (TabNoDesc == null) {
			TabNoDesc = new LabelBase();
			TabNoDesc.setText("Tab No.");
			//TabNoDesc.setBounds(10, 50, 83, 20);
		}
		return TabNoDesc;
	}

	public TextNum getTabNo() {
		if (TabNo == null) {
			TabNo = new TextNum(30) {
				public void onReleased() {
					setCurrentTable(4,TabNo.getText());
				}
			};
			TabNo.setBounds(0, 0, 150, 20);
		 }
		return TabNo;
	}

	public LabelBase getRowNoDesc() {
		if (RowNoDesc == null) {
			RowNoDesc = new LabelBase();
			RowNoDesc.setText("Row No.");
//			RowNoDesc.setBounds(268, 50, 126, 20);
		}
		return RowNoDesc;
	}

	public TextNum getRowNo() {
		if (RowNo == null) {
			RowNo = new TextNum(30) {
				public void onReleased() {
					setCurrentTable(5,RowNo.getText());
				}
			};
			RowNo.setBounds(0, 0, 250, 20);
		 }
		return RowNo;
	}

	public LabelBase getSickCodeDesc() {
		if (SickCodeDesc == null) {
			SickCodeDesc = new LabelBase();
			SickCodeDesc.setText("Sick Code");
//			SickCodeDesc.setBounds(10, 80, 83, 20);
		}
		return SickCodeDesc;
	}
	public TextString getSickCode() {
		if (SickCode == null) {
			SickCode = new TextString() {
				@Override
				public void onReleased() {
					setCurrentTable(6, SickCode.getText());
				}

				@Override
				public void onBlur() {
					if(isAppend() || isModify()){
						if(!getSickCode().getText().isEmpty()){
							QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
									new String[] {"sdisease","sckcode","sckcode='"+SickCode.getText()+"'"},
									new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(MessageQueue mQueue) {
									if (mQueue.success()) {
										setCurrentTable(6,SickCode.getText());
									} else {
										Factory.getInstance().addErrorMessage("Invalida Sick Code.", getSickCode());
										SickCode.resetText();
										setCurrentTable(6,"");
									}
								}
							});
						}
					}
				};
			};
			SickCode.setBounds(0, 0, 159, 20);
		 }
		return SickCode;
	}

	public LabelBase getAbbrDesc() {
		if (AbbrDesc == null) {
			AbbrDesc = new LabelBase();
			AbbrDesc.setText("Abbrreviation");
//			AbbrDesc.setBounds(269, 80, 126, 20);
		}
		return AbbrDesc;
	}

	public TextString getAbbr() {
		if (Abbr == null) {
			Abbr = new TextString(){
				@Override
				public void onReleased() {
					setCurrentTable(7, Abbr.getText());
				}

			};
			Abbr.setBounds(0, 0, 250, 20);

		 }
		return Abbr;
	}

	public LabelBase getNewCodeDesc() {
		if (NewCodeDesc == null) {
			NewCodeDesc = new LabelBase();
			NewCodeDesc.setText("New Code");
//			NewCodeDesc.setBounds(10, 110, 83, 20);
		}
		return NewCodeDesc;
	}

	public CheckBoxBase getNewCode() {
		if (NewCode == null) {
			NewCode = new CheckBoxBase(getListTable(),3);
			NewCode.setBounds(0, 0, 20, 20);
		 }
		return NewCode;
	}

	public LabelBase getIsPairDesc() {
		if (IsPairDesc == null) {
			IsPairDesc = new LabelBase();
			IsPairDesc.setText("Is Paired");
//			IsPairDesc.setBounds(269, 110, 126, 20);
		}
		return IsPairDesc;
	}

	public CheckBoxBase getIsPair() {
		if (IsPair == null) {
			IsPair = new CheckBoxBase(getListTable(),8);
			IsPair.setBounds(0, 0, 20, 20);
		 }
		return IsPair;
	}

	public BasePanel getListPanel() {
		if (ListPanel == null) {
			ListPanel = new BasePanel();
//			ListPanel.setHeading("Sub-Disease Listing");
			this.getLeftPanel().remove(this.getJScrollPane());
			ListPanel.add(getJScrollPane());
//			ListPanel.setBounds(10, 181, 757, 263);
			//ListTable_JScrollPane.setBounds(6, 46, 380, 95));
		}
		return ListPanel;
	}
}