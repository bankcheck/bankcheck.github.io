package com.hkah.client.tx.admin.codetable;

import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.combobox.ComboACMCode;
import com.hkah.client.layout.combobox.ComboSex;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextName;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class Room extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.ROOM_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.ROOM_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Room Code",			 //ROMCODE
				"Sex",	                 //ROMSex
				"Ward Code",		     //WRDCODE
				"Ward name",			 //WRDNAME
				"Accommodation Code",	 //ACMCODE
				"Accommodation Name",	 //ACMNAME
				"Site Code",	         //STECODE
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				80,		//ROMCODE
				50,		//ROMSex
				80,		//WRDCODE
				80,		//WRDNAME
				180,		//ACMCODE
				180,     //ACMNAME
				0		//STECODE
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="10,649"
	private LabelBase LeftJLabel_RoomCode = null;
	private TextName LeftJText_RoomCode = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_RoomCode=null;
	private TextName  RightJText_RoomCode=null;
	private LabelBase RightJLabel_WardCode=null;
	private TextName  RightJText_WardCode=null;
	private LabelBase RightJLabel_AcmName=null;
	private ComboACMCode  RightJCombo_AcmCode=null;
	private LabelBase RightJLabel_Sex=null;
	private ComboSex  RightJCombo_Sex=null;

	/**
	 * This method initializes
	 *
	 */
	public Room() {
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
		//setModifyButtonEnabled(false);
		//setDeleteButtonEnabled(false);
		setNewRefresh(true);
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		//performList();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getLeftJText_RoomCode();
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
		getRightJText_RoomCode().setEnabled(false);
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
				getLeftJText_RoomCode().getText()

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
		getRightJText_RoomCode().setText(outParam[index++]);                  //ROOMCODE
		getRightJCombo_Sex().setText(outParam[index++]);               	      //ROMSex
		getRightJText_WardCode().setText(outParam[index]);				      //WARDCODE
		index++;
		index++;
		getRightJCombo_AcmCode().setSelectedIndex(outParam[index++]);	              //ACMCODE
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {}

	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		String[] param = new String[] {
				selectedContent[0],
				selectedContent[2],
				selectedContent[4],
				selectedContent[1]
		};
		for (String string : param) {
			System.out.println(string+">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
		};
		return param;
	}

	@Override
	protected boolean actionValidation(String[] selectedContent) {
		if (selectedContent[0].trim().length() == 0 || selectedContent[0] == null) {
			Factory.getInstance().addErrorMessage("Empty Room Code!");
			return false;
		}/*else if (selectedContent[1].trim().length() == 0|| selectedContent[1] == null) {
			Factory.getInstance().addErrorMessage("Empty Sex!");
			return false;
		} else if (selectedContent[2].trim().length() == 0||selectedContent[2] == null) {
			Factory.getInstance().addErrorMessage("Empty Ward Code!");
			return false;
		} else if (selectedContent[2].trim().length() > 4) {
			Factory.getInstance().addErrorMessage("Ward Code length exceed!");
			return false;
		} else if (selectedContent[4].trim().length() == 0|| selectedContent[4] == null) {
			Factory.getInstance().addErrorMessage("Empty Acm Name!");
			return false;
		} */
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
			leftPanel = new ColumnLayout(2,1);
//			leftPanel.setSize(399, 60);
			leftPanel.add(0,0,getLeftJLabel_RoomCode());
			leftPanel.add(1,0,getLeftJText_RoomCode());
		}
		return leftPanel;
	}

	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	public ColumnLayout getActionPanel() {
	   if (generalPanel == null) {
			generalPanel = new ColumnLayout(4,2);
			//generalPanel.setBounds(0, 0, 610,250);
			generalPanel.setHeading("Room Information");
			generalPanel.add(0,0,getRightJLabel_RoomCode());
			generalPanel.add(1,0,getRightJText_RoomCode());
			generalPanel.add(2,0,getRightJLabel_WardCode());
			generalPanel.add(3,0,getRightJText_WardCode());
			generalPanel.add(0,1,getRightJLabel_AcmName());
			generalPanel.add(1,1,getRightJCombo_AcmCode());
			generalPanel.add(2,1,getRightJLabel_Sex());
			generalPanel.add(3,1,getRightJCombo_Sex());
		}
		return generalPanel;
	}

	/**
	 * This method initializes leftJLabel_RoomCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	public LabelBase getLeftJLabel_RoomCode() {
		if (LeftJLabel_RoomCode == null) {
			LeftJLabel_RoomCode = new LabelBase();
//			LeftJLabel_RoomCode.setBounds(14, 15, 94, 20);
			LeftJLabel_RoomCode.setText("Room Code");
			LeftJLabel_RoomCode.setOptionalLabel();
		}
		return LeftJLabel_RoomCode;
	}

	/**
	 * This method initializes LeftJText_RoomCode
	 *
	 * @return com.hkah.client.layout.textfield.TextName
	 */
	public TextName getLeftJText_RoomCode() {
		if (LeftJText_RoomCode == null) {
			LeftJText_RoomCode = new TextName();
//			LeftJText_RoomCode.setSize(130, 20);
//			LeftJText_RoomCode.setLocation(121, 12);
		}
		return LeftJText_RoomCode;
	}

	/**
	 * This method initializes RightJLabel_RoomCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	public LabelBase getRightJLabel_RoomCode() {
		if (RightJLabel_RoomCode == null) {
			RightJLabel_RoomCode = new LabelBase();
			RightJLabel_RoomCode.setText("Room Code");
//			RightJLabel_RoomCode.setBounds(46, 33, 91, 20);
		}
		return RightJLabel_RoomCode;
	}

	/**
	 * This method initializes RightJText_RoomCode
	 *
	 * @return com.hkah.client.layout.textfield.TextName
	 */
	public TextName getRightJText_RoomCode() {
		if (RightJText_RoomCode == null) {
			RightJText_RoomCode = new TextName() {
				@Override
				public void onReleased() {
					setCurrentTable(0,RightJText_RoomCode.getText());
				}

				@Override
				public void onBlur() {
					 QueryUtil.executeTx(
							 getUserInfo(), getTxCode(),
							 new String[] { RightJText_RoomCode.getText() },
							 new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								getRightJText_RoomCode().resetText();
								Factory.getInstance().addErrorMessage("Record existed.", getRightJText_RoomCode());
							}
						}
					});
				};
			};
//			RightJText_RoomCode.setBounds(183, 33, 91, 20);
		}
		return RightJText_RoomCode;
	}

	/**
	 * This method initializes RightJLabel_WardCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	public LabelBase getRightJLabel_WardCode() {
		if (RightJLabel_WardCode == null) {
			RightJLabel_WardCode = new LabelBase();
//			RightJLabel_WardCode.setBounds(46, 75, 91, 20);
			RightJLabel_WardCode.setText("Ward Code");
			RightJLabel_WardCode.setOptionalLabel();
		}
		return RightJLabel_WardCode;
	}

	/**
	 * This method initializes RightJText_WardCode
	 *
	 * @return com.hkah.client.layout.textfield.TextName
	 */
	public TextName getRightJText_WardCode() {
		if (RightJText_WardCode == null) {
			RightJText_WardCode = new TextName() {
				@Override
				public void onReleased() {
					QueryUtil.executeTx(
							getUserInfo(), getTxCode(), new String[] { RightJText_RoomCode.getText().trim() },
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								getRightJText_RoomCode().resetText();
								Factory.getInstance().addErrorMessage("Record existed.", getRightJText_RoomCode());
							} else {
								setCurrentTable(2, RightJText_WardCode.getText());
							}
						}
					});
				}

				@Override
				public void onBlur() {
					String txCode = ConstantsTx.LOOKUP_TXCODE;
					String[] para = new String[] {"WARD","wrdcode","wrdcode='"+getRightJText_WardCode().getText().trim()+"'"};
					QueryUtil.executeMasterFetch(
							getUserInfo(), txCode, para,
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (!mQueue.success()) {
								Factory.getInstance().addErrorMessage("Invalid Ward Code!", getRightJText_WardCode());
								getRightJText_WardCode().requestFocus();
								getRightJText_WardCode().resetText();
							} else {
								setCurrentTable(2,RightJText_WardCode.getText());
							}
						}
					});
				};
			};
//			RightJText_WardCode.setBounds(184, 75,91, 20);
		}
		return RightJText_WardCode;
	}

	/**
	 * This method initializes RightJLabel_AcmName
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	public LabelBase getRightJLabel_AcmName() {
		if (RightJLabel_AcmName == null) {
			RightJLabel_AcmName = new LabelBase();
			RightJLabel_AcmName.setText("Acm Name");
//			RightJLabel_AcmName.setBounds(46,117,91, 20);
		}
		return RightJLabel_AcmName;
	}

	/**
	 * This method initializes RightJCombo_AcmCode
	 *
	 * @return  com.hkah.client.layout.combobox.ComboBoxBase
	 */
	public ComboACMCode getRightJCombo_AcmCode() {
		if (RightJCombo_AcmCode == null) {
			RightJCombo_AcmCode = new ComboACMCode() {
				@Override
				public void onClick() {
					setCurrentTable(4,RightJCombo_AcmCode.getText());
				}
			};
//			RightJCombo_AcmCode.setBounds(184, 117, 91, 30);
			RightJCombo_AcmCode.setSelectedIndex(-1);
		}
		return RightJCombo_AcmCode;
	}

	/**
	 * This method initializes RightJLabel_Sex
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	public LabelBase getRightJLabel_Sex() {
		if (RightJLabel_Sex == null) {
			RightJLabel_Sex = new LabelBase();
//			RightJLabel_Sex.setBounds(46, 159, 91, 20);
			RightJLabel_Sex.setText("Sex");
			RightJLabel_Sex.setOptionalLabel();
		}
		return RightJLabel_Sex;
	}

	/**
	 * This method initializes RightJCombo_Sex
	 *
	 * @return  com.hkah.client.layout.combobox.ComboSex
	 */
	public ComboSex getRightJCombo_Sex() {
		if (RightJCombo_Sex == null) {
			RightJCombo_Sex = new ComboSex() {
				public void onClick() {
					setCurrentTable(1,RightJCombo_Sex.getText());
				}
			};
//			RightJCombo_Sex.setBounds(184, 159, 118, 20);
			RightJCombo_Sex.setSelectedIndex(-1);
		}
		return RightJCombo_Sex;
	}
}