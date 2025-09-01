/*
 * Created on July 23, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.tx.admin.codetable;

import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.KeyListener;
import com.google.gwt.event.dom.client.KeyCodes;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboPayType;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextNameChinese;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.client.util.PanelUtil;
import com.hkah.shared.constants.ConstantsTx;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class Payment extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.PAYMENT_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.PAYMENT_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"Pay Code",
				"Pay Type",
				"Pay Description",
				"Chinese Description",   //
				"GL Code",
				"GL Code Name",  //no
				"Site Code",    //site code
				"Ref. GL Code",
				"Ref. GL Code Name",//no
				"Note To A/C"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				80,
				80,
				150,
				0,
				80,
				120,
				0,
				100,
				120,
				100
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="29,32"
	private LabelBase LeftJLabel_PaymentCode = null;
	private TextString LeftJText_PaymentCode = null;
	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_PaymentCode = null;
	private TextString RightJText_PaymentCode = null;
	private LabelBase RightJLabel_PaymentDesc = null;
	private TextString RightJText_PaymentDesc = null;

	private LabelBase RightJLabel_PaymentType = null;
	private LabelBase RightJLabel_ChineseDesc = null;
	private LabelBase RightJLabel_GLCode = null;
	private LabelBase RightJLabel_RefundGLCode = null;
	private LabelBase RightJLabel_NoteToAC = null;
	private TextNameChinese RightJText_ChineseDesc = null;
	private CheckBoxBase RightJCheckBox_NoteToAC = null;
	private TextString RightJText_RefundGLCode = null;
	private TextString RightJText_GLCode = null;
	private ComboPayType RightJCombo_PayType = null;
	/**
	 * This method initializes
	 *
	 */
	public Payment() {
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

		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		//performList();
		getLeftPanel().setHeight(50);
		getListTable().setColumnClass(1, new ComboPayType(), false);
		getListTable().setColumnClass(9, new CheckBoxBase(), false);
		getListTable().setPosition(0, 30);
		PanelUtil.resetAllFields(getActionPanel());
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getLeftJText_PaymentCode();
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
		getRightJText_PaymentCode().setEnabled(false);
		getListTable().setEnabled(false);
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
				getLeftJText_PaymentCode().getText()
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
		getRightJText_PaymentCode().setText(outParam[index++]);
		getRightJCombo_PayType().setText(outParam[index++]);
		getRightJText_PaymentDesc().setText(outParam[index++]);
		getRightJText_ChineseDesc().setText(outParam[index++]);
		getRightJText_GLCode().setText(outParam[index++]);
		index++;
		index++;
		getRightJText_RefundGLCode().setText(outParam[index++]);
		index++;
		getRightJCheckBox_NoteToAC().setText(outParam[index++]);
	}

	/* >>> ~18~ Set Action Validation ===================================== <<< */
	@Override
	protected void actionValidation(String actionType) {
		if (getRightJText_PaymentCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Payment Code!", getRightJText_PaymentCode());
			actionValidationReady(actionType, false);
		} else if (getRightJText_GLCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty GL Code!", getRightJText_GLCode());
			actionValidationReady(actionType, false);
		} else if (getRightJText_RefundGLCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Refund GL Code!", getRightJText_RefundGLCode());
			actionValidationReady(actionType, false);
		} else {
			actionValidationReady(actionType, true);
		}
	}

	@Override
	protected void clearTableFields() {
		super.clearTableFields();
		setCurrentTable(9, "N");
	}

	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		// TODO Auto-generated method stub
		String[] param=new String[] {
			getRightJText_PaymentCode().getText(),
			getRightJCombo_PayType().getText(),
			getRightJText_PaymentDesc().getText(),
			getRightJText_ChineseDesc().getText(),
			getRightJText_GLCode().getText(),
			getUserInfo().getSiteCode(),
			getRightJText_RefundGLCode().getText(),
			getRightJCheckBox_NoteToAC().isSelected()?"-1":"0"
		};
		return param;
	}

	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub

		if (selectedContent[0]==null || selectedContent[0].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Payment Code!");
			return false;
		} else if (selectedContent[2]==null || selectedContent[2].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Payment Description!");
			return false;
		} else if (selectedContent[4]==null || selectedContent[4].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty GL Code!");
			return false;
		}/**/
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
//			leftPanel.setSize(398, 50);
			leftPanel.add(0,0,getLeftJLabel_PaymentCode());
			leftPanel.add(1,0,getLeftJText_PaymentCode());
		}
		return leftPanel;
	}

	/**
	 * This method initializes LeftJLabel_PaymentCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */


	private LabelBase getLeftJLabel_PaymentCode() {
		if (LeftJLabel_PaymentCode == null) {
			LeftJLabel_PaymentCode = new LabelBase();
//			LeftJLabel_PaymentCode.setBounds(14, 15, 102, 20);
			LeftJLabel_PaymentCode.setText("Payment Code:");
			LeftJLabel_PaymentCode.setOptionalLabel();
		}
		return LeftJLabel_PaymentCode;
	}

	/**
	 * This method initializes LeftJText_PaymentCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_PaymentCode() {
		if (LeftJText_PaymentCode == null) {
			LeftJText_PaymentCode = new TextString(5,true);
			LeftJText_PaymentCode.addKeyListener(new KeyListener() {
				@Override
				public void componentKeyDown(ComponentEvent event) {
					if (event.getKeyCode() == KeyCodes.KEY_TAB) {
						searchAction();
					}
				}
			});
//			LeftJText_PaymentCode.setLocation(133, 15);
//			LeftJText_PaymentCode.setSize(164, 20);
		}
		return LeftJText_PaymentCode;
	}

			//rightPanel.setSize(925, 270);


	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(4,4);
			generalPanel.setHeight(130);
			generalPanel.setHeading("Payment Information");
			generalPanel.add(0,0,getRightJLabel_PaymentCode());
			generalPanel.add(1,0,getRightJText_PaymentCode());
			generalPanel.add(2,0,getRightJLabel_PaymentDesc());
			generalPanel.add(3,0,getRightJText_PaymentDesc());
			generalPanel.add(0,1,getRightJLabel_PaymentType());
			generalPanel.add(1,1,getRightJCombo_PayType());
			generalPanel.add(2,1,getRightJLabel_ChineseDesc());
			generalPanel.add(3,1,getRightJText_ChineseDesc());
			generalPanel.add(0,2,getRightJLabel_GLCode());
			generalPanel.add(1,2,getRightJText_GLCode());
			generalPanel.add(2,2,getRightJLabel_RefundGLCode());
			generalPanel.add(3,2,getRightJText_RefundGLCode());
			generalPanel.add(0,3,getRightJLabel_NoteToAC());
			generalPanel.add(1,3,getRightJCheckBox_NoteToAC());
		}
		return generalPanel;
	}

	/**
	 * This method initializes RightJLabel_PaymentCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_PaymentCode() {
		if (RightJLabel_PaymentCode == null) {
			RightJLabel_PaymentCode = new LabelBase();
			RightJLabel_PaymentCode.setText("Payment Code");
//			RightJLabel_PaymentCode.setBounds(36, 32, 95, 20);
		}
		return RightJLabel_PaymentCode;
	}

	/**
	 * This method initializes RightJText_PaymentCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_PaymentCode() {
		if (RightJText_PaymentCode == null) {
			RightJText_PaymentCode = new TextString(5,getListTable(), 0);
		}
		return RightJText_PaymentCode;
	}

	/**
	 * This method initializes RightJLabel_PaymentDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_PaymentDesc() {
		if (RightJLabel_PaymentDesc == null) {
			RightJLabel_PaymentDesc = new LabelBase();
			RightJLabel_PaymentDesc.setText("Payment Description");
//			RightJLabel_PaymentDesc.setBounds(35, 65, 144, 20);
		}
		return RightJLabel_PaymentDesc;
	}

	/**
	 * This method initializes RightJText_PaymentDesc
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_PaymentDesc() {
		if (RightJText_PaymentDesc == null) {
			RightJText_PaymentDesc = new TextString(50,getListTable(),2);
		}
		return RightJText_PaymentDesc;
	}

	/**
	 * This method initializes RightJLabel_PaymentType
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_PaymentType() {
		if (RightJLabel_PaymentType == null) {
			RightJLabel_PaymentType = new LabelBase();
			RightJLabel_PaymentType.setText("Payment Type");
//			RightJLabel_PaymentType.setBounds(36, 95, 94, 20);
		}
		return RightJLabel_PaymentType;
	}

	/**
	 * This method initializes RightJLabel_ChineseDesc
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_ChineseDesc() {
		if (RightJLabel_ChineseDesc == null) {
			RightJLabel_ChineseDesc = new LabelBase();
			RightJLabel_ChineseDesc.setText("Chinese  Description");
//			RightJLabel_ChineseDesc.setBounds(36, 130, 148, 20);
		}
		return RightJLabel_ChineseDesc;
	}

	/**
	 * This method initializes RightJLabel_GLCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_GLCode() {
		if (RightJLabel_GLCode == null) {
			RightJLabel_GLCode = new LabelBase();
			RightJLabel_GLCode.setText("GL Code");
//			RightJLabel_GLCode.setBounds(36, 160, 88, 20);
		}
		return RightJLabel_GLCode;
	}

	/**
	 * This method initializes RightJLabel_RefundGLCode
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_RefundGLCode() {
		if (RightJLabel_RefundGLCode == null) {
			RightJLabel_RefundGLCode = new LabelBase();
			RightJLabel_RefundGLCode.setText("Refund GL Code");
//			RightJLabel_RefundGLCode.setBounds(36, 190, 106, 20);
		}
		return RightJLabel_RefundGLCode;
	}

	/**
	 * This method initializes RightJLabel_NoteToAC
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_NoteToAC() {
		if (RightJLabel_NoteToAC == null) {
			RightJLabel_NoteToAC = new LabelBase();
			RightJLabel_NoteToAC.setText("Note to A/C");
//			RightJLabel_NoteToAC.setBounds(36, 220, 80, 20);
		}
		return RightJLabel_NoteToAC;
	}

	/**
	 * This method initializes RightJText_ChineseDesc
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextNameChinese getRightJText_ChineseDesc() {
		if (RightJText_ChineseDesc == null) {
			RightJText_ChineseDesc = new TextNameChinese(getListTable(), 3);

		}
		return RightJText_ChineseDesc;
	}

	/**
	 * This method initializes RightJCheckBox_NoteToAC
	 *
	 * @return com.hkah.client.layout.checkbox.CheckBoxBase
	 */
	private CheckBoxBase getRightJCheckBox_NoteToAC() {
		if (RightJCheckBox_NoteToAC == null) {
			RightJCheckBox_NoteToAC = new CheckBoxBase(getListTable(),9);
//			RightJCheckBox_NoteToAC.setBounds(228, 220, 22, 23);
		}
		return RightJCheckBox_NoteToAC;
	}

	/**
	 * This method initializes RightJText_RefundGLCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_RefundGLCode() {
		if (RightJText_RefundGLCode == null) {
			RightJText_RefundGLCode = new TextString(8,getListTable(), 7);
		}
		return RightJText_RefundGLCode;
	}

	/**
	 * This method initializes RightJText_GLCode
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getRightJText_GLCode() {
		if (RightJText_GLCode == null) {
			RightJText_GLCode = new TextString(getListTable(), 4);
		}
		return RightJText_GLCode;
	}

	/**
	 * This method initializes RightJCombo_PayType
	 *
	 * @return com.hkah.client.layout.combobox.ComboPayType
	 */
	private ComboPayType getRightJCombo_PayType() {
		if (RightJCombo_PayType == null) {
			RightJCombo_PayType = new ComboPayType() {
				public void onClick() {
					setCurrentTable(1, RightJCombo_PayType.getText());
				}
			};
//			RightJCombo_PayType.setBounds(228, 95, 181, 20);
		}
		return RightJCombo_PayType;
	}
}