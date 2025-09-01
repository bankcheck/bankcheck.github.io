/*
 * Created on July 23, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.tx.admin.syscodetable;

import com.extjs.gxt.ui.client.widget.form.FileUploadField;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboLanguage;
import com.hkah.client.layout.combobox.ComboRLSType;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextNameChinese;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.shared.constants.ConstantsGlobal;
import com.hkah.shared.constants.ConstantsTx;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class RemindingLetterSchedule extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.REMINDING_LETTER_SCHEDULE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.REMINDING_LETTER_SCHEDULE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"RLSID",
				"Type",
				"Day",
				"Path",
				"Language",
				"Default",
				"Due"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				0,
				100,
				40,
				100,
				50,
				50,
				50
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="29,32"
	private LabelBase LeftJLabel_Type = null;
	private TextString LeftJText_Type = null;
	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_Type = null;
	private LabelBase RightJLabel_DueDay = null;
	private TextNum RightJText_DueDay = null;

	private LabelBase RightJLabel_Language = null;
	private LabelBase RightJLabel_FilePath = null;
	private LabelBase RightJLabel_Day = null;
	private LabelBase RightJLabel_Default = null;
	private TextNameChinese RightJText_FilePath = null;
	private CheckBoxBase RightJCheckBox_Default = null;
	private TextNum RightJText_Day = null;
	private FileUploadField RightButtonBase_Browse = null;
	private ComboRLSType RightJCombo_RLSType = null;
	private ComboLanguage RightJCombo_Language = null;
	private String rlsid="";  //  @jve:decl-index=0:

	private ConstantsGlobal paths=null;
	/**
	 * This method initializes
	 *
	 */
	public RemindingLetterSchedule() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		/* >>> ~7.1~ Init action (e.g. Listing, Init Comobbox ========= <<< */
		//setFullEntry(true);
		setNoGetDB(true);
		getLeftJText_Type().setEnabled(false);
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
		getListTable().setColumnClass(1, new ComboRLSType(), false);
		getListTable().setColumnClass(4, new ComboLanguage(), false);
		getListTable().setColumnClass(5, new CheckBoxBase(), false);
		getLeftJText_Type().setEnabled(false);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return null;
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		// override function if necessary
		getLeftJText_Type().setEnabled(false);
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
		getLeftJText_Type().setEnabled(false);
		//rlsid="";
		// enable/disable field
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		// enable/disable field
		getLeftJText_Type().setEnabled(false);
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
				//getLeftJText_Type().getText()
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
		rlsid=outParam[index++];
		getRightJCombo_RLSType().setText(outParam[index++]);
		getRightJText_Day().setText(outParam[index++]);
		getRightJText_FilePath().setText(outParam[index++]);
		getRightJCombo_Language().setText(outParam[index++]);
		getRightJCheckBox_Default().setSelected("Y".equals(outParam[index++]));
		getRightJText_DueDay().setText(outParam[index++]);
	}

	@Override
	protected boolean actionValidation(String[] selectedContent) {
		// TODO Auto-generated method stub
		if (selectedContent[1]==null ||selectedContent[1].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Type!");
			return false;
		} else if (selectedContent[2]==null ||selectedContent[2].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Day!");
			return false;
		} else if (selectedContent[3]==null ||selectedContent[3].trim().length()==0) {
			Factory.getInstance().addErrorMessage("Empty Path!");
			return false;
		}
		return true;
	}

	@Override
	protected void clearTableFields() {
		super.clearTableFields();
		setCurrentTable(5,"N");
	}

	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		// TODO Auto-generated method stub
		String[] param=new String[] {
			selectedContent[1],
			selectedContent[0],
			selectedContent[2],
			selectedContent[3],
			selectedContent[4],
			"Y".equals(selectedContent[5])?"-1":"0",
			selectedContent[6]
		};
		for (String string : param) {
			System.out.println(string+"===================");
		}
		return param;
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
			leftPanel = new ColumnLayout(1,1);
			leftPanel.setSize(399, 69);
			leftPanel.add(getLeftJLabel_Type(), null);
			leftPanel.add(getLeftJText_Type(), null);
		}
		return leftPanel;
	}

	/**
	 * This method initializes LeftJLabel_Type
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */


	private LabelBase getLeftJLabel_Type() {
		if (LeftJLabel_Type == null) {
			LeftJLabel_Type = new LabelBase();
			LeftJLabel_Type.setBounds(14, 15, 48, 20);
			LeftJLabel_Type.setText("Type:");
			LeftJLabel_Type.setOptionalLabel();
		}
		return LeftJLabel_Type;
	}

	/**
	 * This method initializes LeftJText_Type
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextString getLeftJText_Type() {
		if (LeftJText_Type == null) {
			LeftJText_Type = new TextString(5,true);
			LeftJText_Type.setLocation(84, 15);
			LeftJText_Type.setSize(284, 20);
		}
		return LeftJText_Type;
	}

			//rightPanel.setSize(925, 250);

	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(4,4);
			//generalPanel.setBounds(4, 0, 648, 401);
			generalPanel.setHeading("Reminding Letter Schedule");
			generalPanel.add(0,0,getRightJLabel_Type());
			generalPanel.add(1,0,getRightJCombo_RLSType());
			generalPanel.add(0,1,getRightJLabel_Day());
			generalPanel.add(1,1,getRightJText_Day());
			generalPanel.add(2,1,getRightJLabel_DueDay());
			generalPanel.add(3,1,getRightJText_DueDay());
			generalPanel.add(0,2,getRightJLabel_FilePath());
			generalPanel.add(1,2,getRightJText_FilePath());
			generalPanel.add(2,2,getRightButtonBase_Browse());
			generalPanel.add(0,3,getRightJLabel_Language());
			generalPanel.add(1,3,getRightJCombo_Language());
			generalPanel.add(2,3,getRightJLabel_Default());
			generalPanel.add(3,3,getRightJCheckBox_Default());
		}
		return generalPanel;
	}
	/**
	 * This method initializes RightJLabel_Type
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_Type() {
		if (RightJLabel_Type == null) {
			RightJLabel_Type = new LabelBase();
			RightJLabel_Type.setText("Type");
			RightJLabel_Type.setBounds(34, 38, 46, 20);
			RightJLabel_Type.setBounds(35, 38, 46, 20);
		}
		return RightJLabel_Type;
	}

	/**
	 * This method initializes RightJLabel_DueDay
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_DueDay() {
		if (RightJLabel_DueDay == null) {
			RightJLabel_DueDay = new LabelBase();
			RightJLabel_DueDay.setText("Due Day");
			RightJLabel_DueDay.setBounds(254, 87, 60, 20);
			RightJLabel_DueDay.setBounds(234, 89, 66, 20);
		}
		return RightJLabel_DueDay;
	}

	/**
	 * This method initializes RightJText_DueDay
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextNum getRightJText_DueDay() {
		if (RightJText_DueDay == null) {
			RightJText_DueDay = new TextNum(50) {
				public void onReleased() {
					setCurrentTable(6, RightJText_DueDay.getText());
				};
			};
			RightJText_DueDay.setBounds(340, 91, 154, 20);
		}
		return RightJText_DueDay;
	}
	/**
	 * This method initializes RightJLabel_Language
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_Language() {
		if (RightJLabel_Language == null) {
			RightJLabel_Language = new LabelBase();
			RightJLabel_Language.setText("Language");
			RightJLabel_Language.setBounds(32, 187, 65, 20);
		}
		return RightJLabel_Language;
	}
	/**
	 * This method initializes RightJLabel_FilePath
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_FilePath() {
		if (RightJLabel_FilePath == null) {
			RightJLabel_FilePath = new LabelBase();
			RightJLabel_FilePath.setText("File Path");
			RightJLabel_FilePath.setBounds(33, 138, 66, 20);
		}
		return RightJLabel_FilePath;
	}
	/**
	 * This method initializes RightJLabel_Day
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_Day() {
		if (RightJLabel_Day == null) {
			RightJLabel_Day = new LabelBase();
			RightJLabel_Day.setText("Day");
			RightJLabel_Day.setBounds(34, 88, 35, 20);
		}
		return RightJLabel_Day;
	}
	/**
	 * This method initializes RightJLabel_Default
	 *
	 * @return com.hkah.client.layout.label.LabelBase
	 */
	private LabelBase getRightJLabel_Default() {
		if (RightJLabel_Default == null) {
			RightJLabel_Default = new LabelBase();
			RightJLabel_Default.setText("Default");
			RightJLabel_Default.setBounds(335, 191, 52, 20);
		}
		return RightJLabel_Default;
	}
	/**
	 * This method initializes RightJText_FilePath
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextNameChinese getRightJText_FilePath() {
		if (RightJText_FilePath == null) {
			RightJText_FilePath = new TextNameChinese(getListTable(), 3);
			RightJText_FilePath.setBounds(122, 137, 342, 20);
		}
		return RightJText_FilePath;
	}

	/**
	 * This method initializes RightJCheckBox_Default
	 *
	 * @return com.hkah.client.layout.checkbox.CheckBoxBase
	 */
	private CheckBoxBase getRightJCheckBox_Default() {
		if (RightJCheckBox_Default == null) {
			RightJCheckBox_Default = new CheckBoxBase(getListTable(),5);
			RightJCheckBox_Default.setBounds(396, 186, 31, 33);
		}
		return RightJCheckBox_Default;
	}

	/**
	 * This method initializes RightJText_Day
	 *
	 * @return com.hkah.client.layout.textfield.TextString
	 */
	private TextNum getRightJText_Day() {
		if (RightJText_Day == null) {
			RightJText_Day = new TextNum(30) {
				public void onReleased() {
					setCurrentTable(2, RightJText_Day.getText());
				};
			};
			RightJText_Day.setBounds(121, 90, 108, 20);
		}
		return RightJText_Day;
	}

	/**
	 * This method initializes RightButtonBase_Browse
	 *
	 * @return javax.swing.ButtonBase
	 */
	private FileUploadField getRightButtonBase_Browse() {

		RightButtonBase_Browse = new FileUploadField();
//		 file.set
//
//		if (RightButtonBase_Browse == null) {
//			RightButtonBase_Browse = new ButtonBase("Browse...",
//				  new SelectionListener<ButtonEvent>() {
//					  public void componentSelected(ButtonEvent ce) {
//						  JFileChooser chooser;
//							chooser=new JFileChooser();
//						    chooser.setFileSelectionMode(JFileChooser.FILES_AND_DIRECTORIES);
//						    File file=new File(paths.SYSTEMPATH+"\\bin");
//						    chooser.setCurrentDirectory(file);
//					        FileFilter filter;
//					        String extt[] = { "doc","doc" };
//					        filter = new FileNameExtensionFilter("Word Document (*.doc)",extt);
//					        chooser.addChoosableFileFilter(filter);
//					        chooser.setFileFilter(filter);
//					        chooser.showOpenDialog(getUserInfo().getApplet());
//					        System.out.println(chooser.getSelectedFile().getName());
//					        getRightJText_FilePath().setText(chooser.getSelectedFile().getPath());
//					        setCurrentTable(3,RightJText_FilePath.getText());
//					  }
//				  });
//


		return RightButtonBase_Browse;
	}

	/**
	 * This method initializes RightJCombo_RLSType
	 *
	 * @return com.hkah.client.layout.combobox.ComboRLSType
	 */
	private ComboRLSType getRightJCombo_RLSType() {
		if (RightJCombo_RLSType == null) {
			RightJCombo_RLSType = new ComboRLSType() {
				public void onClick() {
					//Factory.getInstance().addErrorMessage(RightJCombo_RLSType.getSelectedIndex()+"");
					String type=RightJCombo_RLSType.getSelectedIndex()+"";
					if (type.equals("0")) {
						setCurrentTable(1,"1");
					} else {
						setCurrentTable(1,"2");
					}
				}
			};
			RightJCombo_RLSType.setBounds(122, 35, 221, 20);
		}
		return RightJCombo_RLSType;
	}

	/**
	 * This method initializes RightJCombo_Language
	 *
	 * @return com.hkah.client.layout.combobox.ComboLanguage
	 */
	private ComboLanguage getRightJCombo_Language() {
		if (RightJCombo_Language == null) {
			RightJCombo_Language = new ComboLanguage() {
				public void onClick() {
					setCurrentTable(4,RightJCombo_Language.getText());
				}
			};
			RightJCombo_Language.setBounds(113, 187, 168, 33);
		}
		return RightJCombo_Language;
	}
}