/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.SelectionChangedEvent;
import com.extjs.gxt.ui.client.event.SelectionChangedListener;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboACMCode;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboDocName;
import com.hkah.client.layout.combobox.ComboFinEstPdBySts;
import com.hkah.client.layout.combobox.ComboFinEstSignLoctn;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.textfield.TextDoctorSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
@SuppressWarnings("serial")
public class DlgBudgetEstBase extends DialogBase {

	private final static int m_frameWidth = 600;
	private final static int m_frameHeight = 750;
	

	private BasePanel dialogTopPanel = null;
	private BasePanel contentPanel = null;
	
	private FieldSetBase basicInfPanel = null;
	private LabelBase formABByDrB4AdmDesc = null;
	private CheckBoxBase formABByDrB4Adm = null;
	private ButtonBase  button_getExtFinEst = null;
	private DlgPbleBudgetEst dlgPbleBudgetEst = null;

	private BasePanel OSBCfmPanel = null;
	private LabelBase OSBTitle = null;
	private LabelBase OSB_BEDesc = null;
	private CheckBoxBase OSB_BE = null;
	
	private BasePanel formAPanel = null;
	private LabelBase formATitle = null;
	
	private BasePanel formBPanel = null;
	private LabelBase formBTitle = null;
	private ComboFinEstPdBySts comboFormAPdBySts = null;
	private ComboFinEstPdBySts comboFormBPdBySts = null;

	private BasePanel signPanel = null;
	private LabelBase signTitle = null;
	private LabelBase sign_FormAPatSignDesc = null;
	private ComboFinEstSignLoctn comboFormAPatSign = null;
	private LabelBase sign_FormADrSignDesc = null;
	private ComboFinEstSignLoctn comboFormADrSign = null;
	private LabelBase sign_FormBPatSignDesc = null;
	private ComboFinEstSignLoctn comboFormBPatSign = null;
	
	private BasePanel estInfo_BasInfoPanel  = null;
	private LabelBase estInfo_AttDoctorDesc = null;
	private ComboDocName estInfo_AttDoctor = null;
	private TextDoctorSearch drCodeSearchDelegate = null;
	private LabelBase estInfo_ProcDesc = null;
	private ComboBoxBase estInfo_Proc = null;
	private LabelBase estInfo_ProcGovDesc = null;
	private TextReadOnly estInfo_ProcGov = null;
	private TextString estInfo_Diag = null;
	private LabelBase estInfo_DiagDesc = null;
	private LabelBase estInfo_ClassDesc = null;
	private ComboBoxBase estInfo_Class = null;
	private LabelBase estInfo_estLenOfStayDesc = null;
	private TextString estInfo_estLenOfStay = null;
	
	private BasePanel estInfo_DocRefPanel = null;
	private LabelBase estInfo_DocRefTitle = null;
	private LabelBase estInfo_DailyDrRdFeeDesc = null;
	private TextString estInfo_DailyDrRdFeeRgeFrom = null;
	private LabelBase estInfo_DailyDrRdFeeRgeSym = null;
	private TextString estInfo_DailyDrRdFeeRgeTo = null;
	private LabelBase estInfo_SurFeeDesc = null;
	private TextString estInfo_SurFeeRgeFrom = null;
	private LabelBase estInfo_SurFeeRgeSym = null;
	private TextString estInfo_SurFeeRgeTo = null;
	private LabelBase estInfo_AnaeTstFeeDesc = null;
	private TextString estInfo_AnaeTstFeeRgeFrom = null;
	private LabelBase estInfo_AnaeTstFeeRgeSym = null;
	private TextString estInfo_AnaeTstFeeRgeTo = null;
	private LabelBase estInfo_OtherSpFeeDesc = null;
	private TextString estInfo_OtherSpFeeRgeFrom = null;
	private LabelBase estInfo_OtherSpFeeRgeSym = null;
	private TextString estInfo_OtherSpFeeRgeTo = null;
	private LabelBase estInfo_OtherFeeDesc = null;
	private TextString estInfo_OtherFeeRgeFrom = null;
	private LabelBase estInfo_OtherFeeRgeSym = null;
	private TextString estInfo_OtherFeeRgeTo = null;
	
	private BasePanel estInfo_HosRefPanel = null;
	private LabelBase estInfo_HosFeeTitle = null;
	private LabelBase estInfo_RmChrgDesc = null;
	private TextString estInfo_RmChrgRgeFrom = null;
	private LabelBase estInfo_RmChrgRgeSym = null;
	private TextString estInfo_RmChrgRgeTo = null;
	private LabelBase estInfo_OTChgDesc = null;
	private TextString estInfo_OTChgRgeFrom = null;
	private LabelBase estInfo_OTChgRgeSym = null;
	private TextString estInfo_OTChgRgeTo = null;
	private LabelBase estInfo_OtherHosFeeDesc = null;
	private TextString estInfo_OtherHosFeeRgeTo = null;
	private LabelBase estInfo_OtherHosFeeRgeSym = null;
	private TextString estInfo_OtherHosFeeRgeFrom = null;
	
	
	private FieldSetBase budgetEstDetailPanel = null;	
	private boolean isModify = false;
	private String memFESTID = null;
	private String memFrom = null;
	private String memKeyID = null;
	private String memPBPID = null;
	private String memPATNO = null;
	private String memPATNAME = null;
	private String memDOCCODE = null;
	private String memREGID = null;
	private String memSLPNO = null;


	public DlgBudgetEstBase(MainFrame owner) {
		super(owner,"yesnocancelclose", m_frameWidth, m_frameHeight);

		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Budget Estimation Information");

		setContentPane(getDialogTopPanel());
		setResizable(true);
		// change label
		getButtonById(YES).setText("Edit", 'E');
		getButtonById(NO).setText("Save", 'S');
		getButtonById(CANCEL).setText("Clear");
		getButtonById(CLOSE).setText("Close", 'C');
		
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String FestID, String From, String srcID, 
				String patno,String patName,String docCode) {
		isModify = false;
		resetContent();
		memFrom = From;
		memKeyID = srcID;
		memPATNO = patno;
		memDOCCODE = docCode;
		memPATNAME = patName;
			if ("PreBook".equals(memFrom )) {
				memPBPID = memKeyID;
			} else if ("Reg".equals(memFrom)) {
				memREGID = memKeyID;
			} else if ("TxnDtl".equals(memFrom)) {
				memSLPNO = memKeyID;
			}
			memFESTID = FestID;
			
		enableButton();
		updateContent(memFrom,memFESTID);
		setVisible(true);
	}

	
	@Override
	protected void doYesAction() {
		isModify = true;
		enableButton();
	}

	@Override
	protected void doNoAction() {
		QueryUtil.executeMasterAction(getUserInfo(), "FINESTHOSP", QueryUtil.ACTION_MODIFY,
				new String[] { 
					memFESTID,
					memPBPID,
					memREGID,
					memSLPNO,
					memPATNO,
					getEstInfo_AttDoctor().getText(),
					getEstInfo_Proc().getText(),
					getEstInfo_Diag().getText(),
					getEstInfo_EstLenOfStay().getText(),
					getEstInfo_Class().getText(),
					getFrmABByDrB4Adm().isSelected()?"-1":"0",
					getBE().isSelected()?"-1":"0",		
					getComboFormAPdBySts().getText(),
					getComboFormBPdBySts().getText(),
					getComboFormAPatSign().getText(),
					getComboFormADrSign().getText(),
					getComboFormBPatSign().getText(),
					getEstInfo_DailyDrRdFeeRgeFrom().getText(),
					getEstInfo_DailyDrRdFeeRgeTo().getText(),
					getEstInfo_SurFeeRgeFrom().getText(),
					getEstInfo_SurFeeRgeTo().getText(),
					getEstInfo_AnaeTstFeeRgeFrom().getText(),
					getEstInfo_AnaeTstFeeRgeTo().getText(),
					getEstInfo_OtherSpFeeRgeFrom().getText(),
					getEstInfo_OtherSpFeeRgeTo().getText(),
					getEstInfo_OtherFeeRgeFrom().getText(),
					getEstInfo_OtherFeeRgeTo().getText(),
					getEstInfo_RmChrgRgeFrom().getText(),
					getEstInfo_RmChrgRgeTo().getText(),
					getEstInfo_OTChgRgeFrom().getText(),
					getEstInfo_OTChgRgeTo().getText(),
					getEstInfo_OtherHosFeeRgeFrom().getText(),
					getEstInfo_OtherHosFeeRgeTo().getText(),
					Factory.getInstance().getUserInfo().getUserID()
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					isModify = false;
					enableButton();
					post(mQueue.getReturnCode(),getBE().isSelected());
				} else {
					Factory.getInstance().addErrorMessage(mQueue);
				}
			}
		});
	}
	
	@Override
	protected void doCancelAction() {
		PanelUtil.resetAllFields(getBudgetEstDetailPanel());
	}

	private void updateContent(String from,String key) {
		QueryUtil.executeMasterFetch(getUserInfo(),"FINESTHOSP",
				new String[] { from,key },
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					memFESTID = mQueue.getContentField()[0];
					memPBPID =  mQueue.getContentField()[1];
					memREGID =  mQueue.getContentField()[2];;
					memSLPNO =  mQueue.getContentField()[3];;
					getEstInfo_AttDoctor().setText(mQueue.getContentField()[5]);
					getEstInfo_Proc().setText(mQueue.getContentField()[6]);
					getEstInfo_ProcGov().setText(mQueue.getContentField()[7]);
					getEstInfo_Diag().setText(mQueue.getContentField()[8]);
					getEstInfo_EstLenOfStay().setText(mQueue.getContentField()[9]);
					getEstInfo_Class().setText(mQueue.getContentField()[10]);
					getFrmABByDrB4Adm().setSelected(MINUS_ONE_VALUE.equals(mQueue.getContentField()[11]));
					getBE().setSelected(MINUS_ONE_VALUE.equals(mQueue.getContentField()[12]));		
					getComboFormAPdBySts().setText(mQueue.getContentField()[13]);
					getComboFormBPdBySts().setText(mQueue.getContentField()[14]);
					getComboFormAPatSign().setText(mQueue.getContentField()[15]);
					getComboFormADrSign().setText(mQueue.getContentField()[16]);
					getComboFormBPatSign().setText(mQueue.getContentField()[17]);
					getEstInfo_DailyDrRdFeeRgeFrom().setText(mQueue.getContentField()[18]);
					getEstInfo_DailyDrRdFeeRgeTo().setText(mQueue.getContentField()[19]);
					getEstInfo_SurFeeRgeFrom().setText(mQueue.getContentField()[20]);
					getEstInfo_SurFeeRgeTo().setText(mQueue.getContentField()[21]);
					getEstInfo_AnaeTstFeeRgeFrom().setText(mQueue.getContentField()[22]);
					getEstInfo_AnaeTstFeeRgeTo().setText(mQueue.getContentField()[23]);
					getEstInfo_OtherSpFeeRgeFrom().setText(mQueue.getContentField()[24]);
					getEstInfo_OtherSpFeeRgeTo().setText(mQueue.getContentField()[25]);
					getEstInfo_OtherFeeRgeFrom().setText(mQueue.getContentField()[26]);
					getEstInfo_OtherFeeRgeTo().setText(mQueue.getContentField()[27]);
					getEstInfo_RmChrgRgeFrom().setText(mQueue.getContentField()[28]);
					getEstInfo_RmChrgRgeTo().setText(mQueue.getContentField()[29]);
					getEstInfo_OTChgRgeFrom().setText(mQueue.getContentField()[30]);
					getEstInfo_OTChgRgeTo().setText(mQueue.getContentField()[31]);
					getEstInfo_OtherHosFeeRgeFrom().setText(mQueue.getContentField()[32]);
					getEstInfo_OtherHosFeeRgeTo().setText(mQueue.getContentField()[33]);
				}
			}});
	}
	
	private void checkGovProc(String proccode) {
		
	}
	
	public void post(String srcNo, boolean isBE){};
	
	private void resetContent(){
		memFESTID = EMPTY_VALUE;
		memFrom  = EMPTY_VALUE;
		memKeyID = EMPTY_VALUE;
		memPBPID = EMPTY_VALUE;
		memPATNO = EMPTY_VALUE;
		memREGID = EMPTY_VALUE;
		memSLPNO = EMPTY_VALUE;
		PanelUtil.resetAllFields(getContentPanel());
	}
	
	protected void enableButton() {
		PanelUtil.setAllFieldsEditable(getContentPanel(), isModify);

		if (memFrom != null) {
			if (isModify) {
				getButtonById(YES).setEnabled(false);
				getButtonById(NO).setEnabled(true);
				getButtonById(CANCEL).setEnabled(true);
			} else {
				getButtonById(YES).setEnabled(true);
				getButtonById(NO).setEnabled(false);
				getButtonById(CANCEL).setEnabled(false);
			}
		} 
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/
	
	
	public BasePanel getDialogTopPanel() {
		if (dialogTopPanel == null) {
			dialogTopPanel = new BasePanel();
			dialogTopPanel.setBounds(0, 0, 600, 750);
			dialogTopPanel.add(getContentPanel(), null);
		}
		return dialogTopPanel;
	}
	
	public BasePanel getContentPanel() {
		if (contentPanel == null) {
			contentPanel = new BasePanel();
			contentPanel.setBounds(0, 0, 565, 720);
			contentPanel.add(getBasicInfPanel(), null);
			contentPanel.add(getBudgetEstDetailPanel(), null);
		}
		return contentPanel;
	}
	
	public FieldSetBase getBasicInfPanel() {
		if (basicInfPanel == null) {
			basicInfPanel = new FieldSetBase();
			basicInfPanel.setHeading("A. Basic Information");
			basicInfPanel.add(getFormABByDrB4AdmDesc(), null);
			basicInfPanel.add(getFrmABByDrB4Adm(), null);
			basicInfPanel.add(getButton_getExtFinEst(), null);
			basicInfPanel.add(getOSBCfmPanel(), null);
			basicInfPanel.add(getFormAPanel(), null);
			basicInfPanel.add(getFormBPanel(), null);
			basicInfPanel.add(getSignPanel(), null);
			basicInfPanel.setBounds(5, 0, 565, 265);
		}
		return basicInfPanel;
	}
	
	protected LabelBase getFormABByDrB4AdmDesc() {
		if (formABByDrB4AdmDesc == null) {
			formABByDrB4AdmDesc = new LabelBase();
			formABByDrB4AdmDesc.setText("Form AB By Doctor Before Admission");
			formABByDrB4AdmDesc.setBounds(5, 0, 210, 20);
		}
		return formABByDrB4AdmDesc;
	}
	
	private DlgPbleBudgetEst getDlgPbleBudgetEst() {
		if (dlgPbleBudgetEst == null) {
			dlgPbleBudgetEst = new DlgPbleBudgetEst(getMainFrame()){
				@Override
				public void post(String[] value,String option) {
						getEstInfo_AttDoctor().setText(value[3]);
						getEstInfo_Proc().setText(value[4]);
						getEstInfo_Diag().setText(value[6]);
						getEstInfo_EstLenOfStay().setText(value[7]);
						getEstInfo_Class().setText(value[8]);
					if("both".equals(option)){
						getEstInfo_DailyDrRdFeeRgeFrom().setText(value[10]);
						getEstInfo_DailyDrRdFeeRgeTo().setText(value[11]);
						getEstInfo_SurFeeRgeFrom().setText(value[12]);
						getEstInfo_SurFeeRgeTo().setText(value[13]);
						getEstInfo_AnaeTstFeeRgeFrom().setText(value[14]);
						getEstInfo_AnaeTstFeeRgeTo().setText(value[15]);
						getEstInfo_OtherSpFeeRgeFrom().setText(value[16]);
						getEstInfo_OtherSpFeeRgeTo().setText(value[17]);
						getEstInfo_OtherFeeRgeFrom().setText(value[18]);
						getEstInfo_OtherFeeRgeTo().setText(value[19]);
						getEstInfo_RmChrgRgeFrom().setText(value[20]);
						getEstInfo_RmChrgRgeTo().setText(value[21]);
						getEstInfo_OTChgRgeFrom().setText(value[22]);
						getEstInfo_OTChgRgeTo().setText(value[23]);
						getEstInfo_OtherHosFeeRgeFrom().setText(value[24]);
						getEstInfo_OtherHosFeeRgeTo().setText(value[25]);
					} else if ("A".equals(option)) {
						getEstInfo_DailyDrRdFeeRgeFrom().setText(value[10]);
						getEstInfo_DailyDrRdFeeRgeTo().setText(value[11]);
						getEstInfo_SurFeeRgeFrom().setText(value[12]);
						getEstInfo_SurFeeRgeTo().setText(value[13]);
						getEstInfo_AnaeTstFeeRgeFrom().setText(value[14]);
						getEstInfo_AnaeTstFeeRgeTo().setText(value[15]);
						getEstInfo_OtherSpFeeRgeFrom().setText(value[16]);
						getEstInfo_OtherSpFeeRgeTo().setText(value[17]);
						getEstInfo_OtherFeeRgeFrom().setText(value[18]);
						getEstInfo_OtherFeeRgeTo().setText(value[19]);
					} else if ("B".equals(option)) {
						getEstInfo_RmChrgRgeFrom().setText(value[20]);
						getEstInfo_RmChrgRgeTo().setText(value[21]);
						getEstInfo_OTChgRgeFrom().setText(value[22]);
						getEstInfo_OTChgRgeTo().setText(value[23]);
						getEstInfo_OtherHosFeeRgeFrom().setText(value[24]);
						getEstInfo_OtherHosFeeRgeTo().setText(value[25]);
					}
						dispose();
				}
			};
		}
		return dlgPbleBudgetEst;
	}

	protected CheckBoxBase getFrmABByDrB4Adm() {
		if (formABByDrB4Adm == null) {
			formABByDrB4Adm = new CheckBoxBase();
			formABByDrB4Adm.setBounds(220, 0, 20, 20);
		}
		return formABByDrB4Adm;
	}
	
	protected BasePanel getOSBCfmPanel() {
		if (OSBCfmPanel == null) {
			OSBCfmPanel = new BasePanel();
			OSBCfmPanel.setBounds(0, 20, 647, 40);
			OSBCfmPanel.add(getOSBTitle(), null);
			OSBCfmPanel.add(getBEDesc(), null);
			OSBCfmPanel.add(getBE(), null);
		}
		return OSBCfmPanel;
	}
	
	private LabelBase getOSBTitle() {
		if (OSBTitle == null) {
			OSBTitle = new LabelBase();
			OSBTitle.setText("<b>One Stop Booking Confirmation</b>");
			OSBTitle.setBounds(5, 0, 300, 20);
		}
		return OSBTitle;
	}
	
	protected LabelBase getBEDesc() {
		if (OSB_BEDesc == null) {
			OSB_BEDesc = new LabelBase();
			OSB_BEDesc.setText("*BE");
			OSB_BEDesc.setBounds(7, 20, 20, 20);
		}
		return OSB_BEDesc;
	}

	protected CheckBoxBase getBE() {
		if (OSB_BE == null) {
			OSB_BE = new CheckBoxBase();
			OSB_BE.setBounds(30, 20, 20, 20);
		}
		return OSB_BE;
	}
	
	protected BasePanel getFormAPanel() {
		if (formAPanel == null) {
			formAPanel = new BasePanel();
			formAPanel.setBounds(0, 60, 647, 40);
			formAPanel.add(getFormATitle(), null);
			formAPanel.add(getComboFormAPdBySts(), null);
		}
		return formAPanel;
	}
	
	private LabelBase getFormATitle() {
		if (formATitle == null) {
			formATitle = new LabelBase();
			formATitle.setText("<b>Form A</b>");
			formATitle.setBounds(5, 0, 300, 20);
		}
		return formATitle;
	}
	
	private ComboFinEstPdBySts getComboFormAPdBySts() {
		if (comboFormAPdBySts == null) {
			comboFormAPdBySts = new ComboFinEstPdBySts(true);
			comboFormAPdBySts.setBounds(7, 20, 200, 20);
			comboFormAPdBySts.setMinListWidth(300);
		}
		return comboFormAPdBySts;
	}
	
	protected BasePanel getFormBPanel() {
		if (formBPanel == null) {
			formBPanel = new BasePanel();
			formBPanel.setBounds(0, 100, 647, 40);
			formBPanel.add(getFormBTitle(), null);
			formBPanel.add(getComboFormBPdBySts(), null);
		}
		return formBPanel;
	}
	
	private LabelBase getFormBTitle() {
		if (formBTitle == null) {
			formBTitle = new LabelBase();
			formBTitle.setText("<b>Form B</b>");
			formBTitle.setBounds(5, 0, 300, 20);
		}
		return formBTitle;
	}
	
	private ComboFinEstPdBySts getComboFormBPdBySts() {
		if (comboFormBPdBySts == null) {
			comboFormBPdBySts = new ComboFinEstPdBySts(false);
			comboFormBPdBySts.setBounds(7, 20, 200, 20);
			comboFormBPdBySts.setMinListWidth(300);
		}
		return comboFormBPdBySts;
	}

	
	protected BasePanel getSignPanel() {
		if (signPanel == null) {
			signPanel = new BasePanel();
			signPanel.setBounds(0, 140, 647, 100);
			signPanel.add(getSignTitle(), null);
			signPanel.add(getSign_FormAPatSignDesc(), null);
			signPanel.add(getComboFormAPatSign(), null);
			signPanel.add(getSign_FormADrSignDesc(), null);
			signPanel.add(getComboFormADrSign(), null);
			signPanel.add(getSign_FormBPatSignDesc(), null);
			signPanel.add(getComboFormBPatSign(), null);
		}
		return signPanel;
	}
	
	private LabelBase getSignTitle() {
		if (signTitle == null) {
			signTitle = new LabelBase();
			signTitle.setText("<b>Signature</b>");
			signTitle.setBounds(5, 0, 300, 20);
		}
		return signTitle;
	}
	
	protected LabelBase getSign_FormADrSignDesc() {
		if (sign_FormADrSignDesc == null) {
			sign_FormADrSignDesc = new LabelBase();
			sign_FormADrSignDesc.setText("Form A Doctor Signature");
			sign_FormADrSignDesc.setBounds(7, 20, 155, 20);
		}	
		return sign_FormADrSignDesc;
	}
	
	private ComboFinEstSignLoctn getComboFormADrSign() {
		if (comboFormADrSign == null) {
			comboFormADrSign = new ComboFinEstSignLoctn();
			comboFormADrSign.setBounds(160, 20, 200, 20);
		}
		return comboFormADrSign;
	}
	
	protected LabelBase getSign_FormAPatSignDesc() {
		if (sign_FormAPatSignDesc == null) {
			sign_FormAPatSignDesc = new LabelBase();
			sign_FormAPatSignDesc.setText("Form A Patient Signature");
			sign_FormAPatSignDesc.setBounds(7, 45, 150, 20);
		}
		return sign_FormAPatSignDesc;
	}
	
	private ComboFinEstSignLoctn getComboFormAPatSign() {
		if (comboFormAPatSign == null) {
			comboFormAPatSign = new ComboFinEstSignLoctn();
			comboFormAPatSign.setBounds(160, 45, 200, 20);
		}
		return comboFormAPatSign;
	}
	
	protected LabelBase getSign_FormBPatSignDesc() {
		if (sign_FormBPatSignDesc == null) {
			sign_FormBPatSignDesc = new LabelBase();
			sign_FormBPatSignDesc.setText("Form B Patient Signature");
			sign_FormBPatSignDesc.setBounds(7, 70, 145, 20);
		}
		return sign_FormBPatSignDesc;
	}
	
	private ComboFinEstSignLoctn getComboFormBPatSign() {
		if (comboFormBPatSign == null) {
			comboFormBPatSign = new ComboFinEstSignLoctn();
			comboFormBPatSign.setBounds(160, 70, 200, 20);
		}
		return comboFormBPatSign;
	}

	public FieldSetBase getBudgetEstDetailPanel() {
		if (budgetEstDetailPanel == null) {
			budgetEstDetailPanel = new FieldSetBase();
			budgetEstDetailPanel.setHeading("B. Estimation Information");
			budgetEstDetailPanel.add(getEstBasInfoPanel(), null);
			budgetEstDetailPanel.add(getEstInfo_DocRefPanel(), null);
			budgetEstDetailPanel.add(getEstInfo_HosRefPanel(), null);
			budgetEstDetailPanel.setBounds(6, 270, 580, 400);
		}
		return budgetEstDetailPanel;
	}
	
	public BasePanel getEstBasInfoPanel() {
		if (estInfo_BasInfoPanel == null) {
			estInfo_BasInfoPanel = new BasePanel();
			estInfo_BasInfoPanel.add(getEstInfo_AttDoctorDesc(), null);
			estInfo_BasInfoPanel.add(getEstInfo_AttDoctor(), null);
			estInfo_BasInfoPanel.add(getButton_getExtFinEst(), null);
			estInfo_BasInfoPanel.add(getEstInfo_ProcDesc(), null);
			estInfo_BasInfoPanel.add(getEstInfo_Proc(), null);
			estInfo_BasInfoPanel.add(getEstInfo_ProcGovDesc(), null);
			estInfo_BasInfoPanel.add(getEstInfo_ProcGov(), null);
			estInfo_BasInfoPanel.add(getEstInfo_DiagDesc(), null);
			estInfo_BasInfoPanel.add(getEstInfo_Diag(), null);
			estInfo_BasInfoPanel.add(getEstInfo_ClassDesc(), null);  
			estInfo_BasInfoPanel.add(getEstInfo_Class(), null);  
			estInfo_BasInfoPanel.add(getEstInfo_EstLenOfStayDesc(), null);  
			estInfo_BasInfoPanel.add(getEstInfo_EstLenOfStay(), null);  
			estInfo_BasInfoPanel.setBounds(0, 0, 580, 90);
		}
		return estInfo_BasInfoPanel;
	}
	
	protected LabelBase getEstInfo_AttDoctorDesc() {
		if (estInfo_AttDoctorDesc == null) {
			estInfo_AttDoctorDesc = new LabelBase();
			estInfo_AttDoctorDesc.setText("Attending Doctor");
			estInfo_AttDoctorDesc.setBounds(5, 0,100, 20);
		}
		return estInfo_AttDoctorDesc;
	}
	
	
	public ComboDocName getEstInfo_AttDoctor() {
		if (estInfo_AttDoctor == null) {
			estInfo_AttDoctor = new ComboDocName(true, true) {
				@Override
				public void onSearchTriggerClick(ComponentEvent ce) {
					getDrCodeSearchDelegate().setValue(this.getText());
					getDrCodeSearchDelegate().showSearchPanel();
				}
			};
			estInfo_AttDoctor.setShowTextSearhPanel(true);
			estInfo_AttDoctor.setMinListWidth(300);
			estInfo_AttDoctor.setBounds(110, 0, 225, 20);
		}
		return estInfo_AttDoctor;
	}
	
	private ButtonBase getButton_getExtFinEst() {
		if (button_getExtFinEst == null) {
			button_getExtFinEst = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgPbleBudgetEst().showDialog(memPATNO,memPATNAME,memDOCCODE);
				}
			};
			button_getExtFinEst.setEnabled(true);
			button_getExtFinEst.setText("Check existing Estimation");
			button_getExtFinEst.setBounds(340, 0, 150, 20);
		}
		return button_getExtFinEst;
	}
	
	public TextDoctorSearch getDrCodeSearchDelegate() {
		if (drCodeSearchDelegate == null) {
			drCodeSearchDelegate = new TextDoctorSearch() {
				@Override
				public void searchAfterAcceptAction() {
					getEstInfo_AttDoctor().setText(getValue());
				}
			};
			drCodeSearchDelegate.setBounds(0,-100, 225, 20);
			drCodeSearchDelegate.setVisible(false);
		}
		return drCodeSearchDelegate;
	}
	
	protected LabelBase getEstInfo_ProcDesc() {
		if (estInfo_ProcDesc == null) {
			estInfo_ProcDesc = new LabelBase();
			estInfo_ProcDesc.setText("Procedure/Surgical Operation");
			estInfo_ProcDesc.setBounds(5, 25,165, 20);
		}
		return estInfo_ProcDesc;
	}
	
	protected ComboBoxBase getEstInfo_Proc() {
		if (estInfo_Proc == null) {
			estInfo_Proc = new ComboBoxBase("OTPROCFEST", false, false, true);
			estInfo_Proc.setMinListWidth(450);
			estInfo_Proc.addSelectionChangedListener(new SelectionChangedListener<ModelData>() {
				public void selectionChanged(SelectionChangedEvent se) {
					QueryUtil.executeMasterFetch(getUserInfo(),"FINESTPRCGOV",
							new String[] { getEstInfo_Proc().getText() },
							new MessageQueueCallBack() {
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								getEstInfo_ProcGov().setText(mQueue.getContentField()[0]);
							} else {
								getEstInfo_ProcGov().resetText();
							}
						}});
				}
			});
			estInfo_Proc.setBounds(170, 25, 350, 20);
		}
		return estInfo_Proc;
	}
	
	protected LabelBase getEstInfo_ProcGovDesc() {
		if (estInfo_ProcGovDesc == null) {
			estInfo_ProcGovDesc = new LabelBase();
			estInfo_ProcGovDesc.setText("Elective Procedure");
			estInfo_ProcGovDesc.setBounds(5, 50,165, 20);
		}
		return estInfo_ProcGovDesc;
	}
	
	protected TextReadOnly getEstInfo_ProcGov() {
		if (estInfo_ProcGov == null) {
			estInfo_ProcGov = new TextReadOnly();
			estInfo_ProcGov.setBounds(130, 50, 350, 20);
		}
		return estInfo_ProcGov;
	}

	protected LabelBase getEstInfo_DiagDesc() {
		if (estInfo_DiagDesc == null) {
			estInfo_DiagDesc = new LabelBase();
			estInfo_DiagDesc.setText("Provisional Diagnosis");
			estInfo_DiagDesc.setBounds(5, 75,120, 20);
		}
		return estInfo_DiagDesc;
	}
	
	protected TextString getEstInfo_Diag() {
		if (estInfo_Diag == null) {
			estInfo_Diag = new TextString();
			estInfo_Diag.setBounds(130, 75, 350, 20);
		}
		return estInfo_Diag;
	}
	
	public LabelBase getEstInfo_ClassDesc() {
		if (estInfo_ClassDesc == null) {
			estInfo_ClassDesc = new LabelBase();
			estInfo_ClassDesc.setText("Class of Ward");
			estInfo_ClassDesc.setBounds(5, 100, 100, 20);
		}
		return estInfo_ClassDesc;
	}

	public ComboBoxBase getEstInfo_Class() {
		if (estInfo_Class == null) {
			estInfo_Class = new ComboBoxBase("FINACM", true, false, false);
			estInfo_Class.setBounds(105, 100, 140, 20);
		}
		return estInfo_Class;
	}

	public LabelBase getEstInfo_EstLenOfStayDesc() {
		if (estInfo_estLenOfStayDesc == null) {
			estInfo_estLenOfStayDesc = new LabelBase();
			estInfo_estLenOfStayDesc.setText("Estimated Length of Stay");
			estInfo_estLenOfStayDesc.setBounds(250, 100, 148, 20);
		}
		return estInfo_estLenOfStayDesc;
	}

	public TextString getEstInfo_EstLenOfStay() {
		if (estInfo_estLenOfStay == null) {
			estInfo_estLenOfStay = new TextString();
			estInfo_estLenOfStay.setBounds(400, 100, 80, 20);
		}
		return estInfo_estLenOfStay;
	}
	
	protected BasePanel getEstInfo_DocRefPanel() {
		if (estInfo_DocRefPanel == null) {
			estInfo_DocRefPanel = new BasePanel();
			estInfo_DocRefPanel.setBounds(0, 120, 647, 125);
			estInfo_DocRefPanel.add(getEstInfo_DocRefTitle(), null);
			estInfo_DocRefPanel.add(getEstInfo_DailyDrRdFeeDesc(), null);
			estInfo_DocRefPanel.add(getEstInfo_DailyDrRdFeeRgeFrom(), null);
			estInfo_DocRefPanel.add(getEstInfo_DailyDrRdFeeRgeSym(), null);
			estInfo_DocRefPanel.add(getEstInfo_DailyDrRdFeeRgeTo(), null);
			estInfo_DocRefPanel.add(getEstInfo_SurFeeDesc(), null);
			estInfo_DocRefPanel.add(getEstInfo_SurFeeRgeFrom(), null);
			estInfo_DocRefPanel.add(getEstInfo_SurFeeRgeSym(), null);
			estInfo_DocRefPanel.add(getEstInfo_SurFeeRgeTo(), null);
			estInfo_DocRefPanel.add(getEstInfo_AnaeTstFeeDesc(), null);
			estInfo_DocRefPanel.add(getEstInfo_AnaeTstFeeRgeFrom(), null);
			estInfo_DocRefPanel.add(getEstInfo_AnaeTstFeeRgeSym(), null);
			estInfo_DocRefPanel.add(getEstInfo_AnaeTstFeeRgeTo(), null);
			estInfo_DocRefPanel.add(getEstInfo_OtherSpFeeDesc(), null);
			estInfo_DocRefPanel.add(getEstInfo_OtherSpFeeRgeFrom(), null);
			estInfo_DocRefPanel.add(getEstInfo_OtherSpFeeRgeSym(), null);
			estInfo_DocRefPanel.add(getEstInfo_OtherSpFeeRgeTo(), null);
			estInfo_DocRefPanel.add(getEstInfo_OtherFeeDesc(), null);
			estInfo_DocRefPanel.add(getEstInfo_OtherFeeRgeFrom(), null);
			estInfo_DocRefPanel.add(getEstInfo_OtherFeeRgeSym(), null);
			estInfo_DocRefPanel.add(getEstInfo_OtherFeeRgeTo(), null);
		}
		return estInfo_DocRefPanel;
	}
	
	private LabelBase getEstInfo_DocRefTitle() {
		if (estInfo_DocRefTitle == null) {
			estInfo_DocRefTitle = new LabelBase();
			estInfo_DocRefTitle.setText("<b>Doctor Reference Range</b>");
			estInfo_DocRefTitle.setBounds(5, 0, 300, 20);
		}
		return estInfo_DocRefTitle;
	}
	
	protected LabelBase getEstInfo_DailyDrRdFeeDesc() {
		if (estInfo_DailyDrRdFeeDesc == null) {
			estInfo_DailyDrRdFeeDesc = new LabelBase();
			estInfo_DailyDrRdFeeDesc.setText("Daily Doctor's Round Fee");
			estInfo_DailyDrRdFeeDesc.setBounds(7, 20, 200, 20);
		}
		return estInfo_DailyDrRdFeeDesc;
	}
	
	public TextString getEstInfo_DailyDrRdFeeRgeFrom() {
		if (estInfo_DailyDrRdFeeRgeFrom == null) {
			estInfo_DailyDrRdFeeRgeFrom = new TextString();
			estInfo_DailyDrRdFeeRgeFrom.setBounds(210, 20, 80, 20);
		}
		return estInfo_DailyDrRdFeeRgeFrom;
	}
	
	protected LabelBase getEstInfo_DailyDrRdFeeRgeSym() {
		if (estInfo_DailyDrRdFeeRgeSym == null) {
			estInfo_DailyDrRdFeeRgeSym = new LabelBase();
			estInfo_DailyDrRdFeeRgeSym.setText("~");
			estInfo_DailyDrRdFeeRgeSym.setBounds(295, 20, 20, 20);
		}
		return estInfo_DailyDrRdFeeRgeSym;
	}
	
	public TextString getEstInfo_DailyDrRdFeeRgeTo() {
		if (estInfo_DailyDrRdFeeRgeTo == null) {
			estInfo_DailyDrRdFeeRgeTo = new TextString();
			estInfo_DailyDrRdFeeRgeTo.setBounds(310, 20, 80, 20);
		}
		return estInfo_DailyDrRdFeeRgeTo;
	}
	
	protected LabelBase getEstInfo_SurFeeDesc() {
		if (estInfo_SurFeeDesc == null) {
			estInfo_SurFeeDesc = new LabelBase();
			estInfo_SurFeeDesc.setText("Surgical Fee");
			estInfo_SurFeeDesc.setBounds(7, 45, 200, 20);
		}
		return estInfo_SurFeeDesc;
	}
	
	public TextString getEstInfo_SurFeeRgeFrom() {
		if (estInfo_SurFeeRgeFrom == null) {
			estInfo_SurFeeRgeFrom = new TextString();
			estInfo_SurFeeRgeFrom.setBounds(210, 45, 80, 20);
		}
		return estInfo_SurFeeRgeFrom;
	}
	
	protected LabelBase getEstInfo_SurFeeRgeSym() {
		if (estInfo_SurFeeRgeSym == null) {
			estInfo_SurFeeRgeSym = new LabelBase();
			estInfo_SurFeeRgeSym.setText("~");
			estInfo_SurFeeRgeSym.setBounds(295, 45, 20, 20);
		}
		return estInfo_SurFeeRgeSym;
	}
	
	public TextString getEstInfo_SurFeeRgeTo() {
		if (estInfo_SurFeeRgeTo == null) {
			estInfo_SurFeeRgeTo = new TextString();
			estInfo_SurFeeRgeTo.setBounds(310, 45, 80, 20);
		}
		return estInfo_SurFeeRgeTo;
	}
	
	protected LabelBase getEstInfo_AnaeTstFeeDesc() {
		if (estInfo_AnaeTstFeeDesc == null) {
			estInfo_AnaeTstFeeDesc = new LabelBase();
			estInfo_AnaeTstFeeDesc.setText("Anaesthetist's Fee");
			estInfo_AnaeTstFeeDesc.setBounds(7, 70, 200, 20);
		}
		return estInfo_AnaeTstFeeDesc;
	}
	
	public TextString getEstInfo_AnaeTstFeeRgeFrom() {
		if (estInfo_AnaeTstFeeRgeFrom == null) {
			estInfo_AnaeTstFeeRgeFrom = new TextString();
			estInfo_AnaeTstFeeRgeFrom.setBounds(210, 70, 80, 20);
		}
		return estInfo_AnaeTstFeeRgeFrom;
	}
	
	protected LabelBase getEstInfo_AnaeTstFeeRgeSym() {
		if (estInfo_AnaeTstFeeRgeSym == null) {
			estInfo_AnaeTstFeeRgeSym = new LabelBase();
			estInfo_AnaeTstFeeRgeSym.setText("~");
			estInfo_AnaeTstFeeRgeSym.setBounds(295, 70, 20, 20);
		}
		return estInfo_AnaeTstFeeRgeSym;
	}
	
	public TextString getEstInfo_AnaeTstFeeRgeTo() {
		if (estInfo_AnaeTstFeeRgeTo == null) {
			estInfo_AnaeTstFeeRgeTo = new TextString();
			estInfo_AnaeTstFeeRgeTo.setBounds(310, 70, 80, 20);
		}
		return estInfo_AnaeTstFeeRgeTo;
	}
	
	protected LabelBase getEstInfo_OtherSpFeeDesc() {
		if (estInfo_OtherSpFeeDesc == null) {
			estInfo_OtherSpFeeDesc = new LabelBase();
			estInfo_OtherSpFeeDesc.setText("Other Specialists' Consultation Fee");
			estInfo_OtherSpFeeDesc.setBounds(7, 95, 200, 20);
		}
		return estInfo_OtherSpFeeDesc;
	}
	
	public TextString getEstInfo_OtherSpFeeRgeFrom() {
		if (estInfo_OtherSpFeeRgeFrom == null) {
			estInfo_OtherSpFeeRgeFrom = new TextString();
			estInfo_OtherSpFeeRgeFrom.setBounds(210, 95, 80, 20);
		}
		return estInfo_OtherSpFeeRgeFrom;
	}
	
	protected LabelBase getEstInfo_OtherSpFeeRgeSym() {
		if (estInfo_OtherSpFeeRgeSym == null) {
			estInfo_OtherSpFeeRgeSym = new LabelBase();
			estInfo_OtherSpFeeRgeSym.setText("~");
			estInfo_OtherSpFeeRgeSym.setBounds(295, 95, 20, 20);
		}
		return estInfo_OtherSpFeeRgeSym;
	}
	
	public TextString getEstInfo_OtherSpFeeRgeTo() {
		if (estInfo_OtherSpFeeRgeTo == null) {
			estInfo_OtherSpFeeRgeTo = new TextString();
			estInfo_OtherSpFeeRgeTo.setBounds(310, 95, 80, 20);
		}
		return estInfo_OtherSpFeeRgeTo;
	}
	
	protected LabelBase getEstInfo_OtherFeeDesc() {
		if (estInfo_OtherFeeDesc == null) {
			estInfo_OtherFeeDesc = new LabelBase();
			estInfo_OtherFeeDesc.setText("Other Items and Charges");
			estInfo_OtherFeeDesc.setBounds(7, 120, 200, 20);
		}
		return estInfo_OtherFeeDesc;
	}
	
	public TextString getEstInfo_OtherFeeRgeFrom() {
		if (estInfo_OtherFeeRgeFrom == null) {
			estInfo_OtherFeeRgeFrom = new TextString();
			estInfo_OtherFeeRgeFrom.setBounds(210, 120, 80, 20);
		}
		return estInfo_OtherFeeRgeFrom;
	}
	
	protected LabelBase getEstInfo_OtherFeeRgeSym() {
		if (estInfo_OtherFeeRgeSym == null) {
			estInfo_OtherFeeRgeSym = new LabelBase();
			estInfo_OtherFeeRgeSym.setText("~");
			estInfo_OtherFeeRgeSym.setBounds(295, 120, 20, 20);
		}
		return estInfo_OtherFeeRgeSym;
	}
	
	public TextString getEstInfo_OtherFeeRgeTo() {
		if (estInfo_OtherFeeRgeTo == null) {
			estInfo_OtherFeeRgeTo = new TextString();
			estInfo_OtherFeeRgeTo.setBounds(310, 120, 80, 20);
		}
		return estInfo_OtherFeeRgeTo;
	}
	
	protected BasePanel getEstInfo_HosRefPanel() {
		if (estInfo_HosRefPanel == null) {
			estInfo_HosRefPanel = new BasePanel();
			estInfo_HosRefPanel.setBounds(0, 270, 647, 75);
			estInfo_HosRefPanel.add(getEstInfo_HosFeeTitle(), null);
			estInfo_HosRefPanel.add(getEstInfo_RmChrgDesc(), null);
			estInfo_HosRefPanel.add(getEstInfo_RmChrgRgeFrom(), null);
			estInfo_HosRefPanel.add(getEstInfo_RmChrgRgeSym(), null);
			estInfo_HosRefPanel.add(getEstInfo_RmChrgRgeTo(), null);
			estInfo_HosRefPanel.add(getEstInfo_OTChgDesc(), null);
			estInfo_HosRefPanel.add(getEstInfo_OTChgRgeFrom(), null);
			estInfo_HosRefPanel.add(getEstInfo_OTChgRgeSym(), null);
			estInfo_HosRefPanel.add(getEstInfo_OTChgRgeTo(), null);
			estInfo_HosRefPanel.add(getEstInfo_OtherHosFeeDesc(), null);
			estInfo_HosRefPanel.add(getEstInfo_OtherHosFeeRgeFrom(), null);
			estInfo_HosRefPanel.add(getEstInfo_OtherHosFeeRgeSym(), null);
			estInfo_HosRefPanel.add(getEstInfo_OtherHosFeeRgeTo(), null);
		}
		return estInfo_HosRefPanel;
	}
	
	private LabelBase getEstInfo_HosFeeTitle() {
		if (estInfo_HosFeeTitle == null) {
			estInfo_HosFeeTitle = new LabelBase();
			estInfo_HosFeeTitle.setText("<b>Hospital Reference Range</b>");
			estInfo_HosFeeTitle.setBounds(5, 0, 300, 20);
		}
		return estInfo_HosFeeTitle;
	}
	
	protected LabelBase getEstInfo_RmChrgDesc() {
		if (estInfo_RmChrgDesc == null) {
			estInfo_RmChrgDesc = new LabelBase();
			estInfo_RmChrgDesc.setText("Room Charge");
			estInfo_RmChrgDesc.setBounds(7, 20, 200, 20);
		}
		return estInfo_RmChrgDesc;
	}
	
	public TextString getEstInfo_RmChrgRgeFrom() {
		if (estInfo_RmChrgRgeFrom == null) {
			estInfo_RmChrgRgeFrom = new TextString();
			estInfo_RmChrgRgeFrom.setBounds(210, 20, 80, 20);
		}
		return estInfo_RmChrgRgeFrom;
	}
	
	protected LabelBase getEstInfo_RmChrgRgeSym() {
		if (estInfo_RmChrgRgeSym == null) {
			estInfo_RmChrgRgeSym = new LabelBase();
			estInfo_RmChrgRgeSym.setText("~");
			estInfo_RmChrgRgeSym.setBounds(295, 20, 20, 20);
		}
		return estInfo_RmChrgRgeSym;
	}
	
	public TextString getEstInfo_RmChrgRgeTo() {
		if (estInfo_RmChrgRgeTo == null) {
			estInfo_RmChrgRgeTo = new TextString();
			estInfo_RmChrgRgeTo.setBounds(310, 20, 80, 20);
		}
		return estInfo_RmChrgRgeTo;
	}
	
	protected LabelBase getEstInfo_OTChgDesc() {
		if (estInfo_OTChgDesc == null) {
			estInfo_OTChgDesc = new LabelBase();
			estInfo_OTChgDesc.setText("OT and Associated Matls Chg");
			estInfo_OTChgDesc.setBounds(7, 45, 200, 20);
		}
		return estInfo_OTChgDesc;
	}
	
	public TextString getEstInfo_OTChgRgeFrom() {
		if (estInfo_OTChgRgeFrom == null) {
			estInfo_OTChgRgeFrom = new TextString();
			estInfo_OTChgRgeFrom.setBounds(210, 45, 80, 20);
		}
		return estInfo_OTChgRgeFrom;
	}
	
	protected LabelBase getEstInfo_OTChgRgeSym() {
		if (estInfo_OTChgRgeSym == null) {
			estInfo_OTChgRgeSym = new LabelBase();
			estInfo_OTChgRgeSym.setText("~");
			estInfo_OTChgRgeSym.setBounds(295, 45, 20, 20);
		}
		return estInfo_OTChgRgeSym;
	}
	
	public TextString getEstInfo_OTChgRgeTo() {
		if (estInfo_OTChgRgeTo == null) {
			estInfo_OTChgRgeTo = new TextString();
			estInfo_OTChgRgeTo.setBounds(310, 45, 80, 20);
		}
		return estInfo_OTChgRgeTo;
	}
	
	protected LabelBase getEstInfo_OtherHosFeeDesc() {
		if (estInfo_OtherHosFeeDesc == null) {
			estInfo_OtherHosFeeDesc = new LabelBase();
			estInfo_OtherHosFeeDesc.setText("Other Hospital Charges");
			estInfo_OtherHosFeeDesc.setBounds(7, 70, 200, 20);
		}
		return estInfo_OtherHosFeeDesc;
	}
	
	public TextString getEstInfo_OtherHosFeeRgeFrom() {
		if (estInfo_OtherHosFeeRgeFrom == null) {
			estInfo_OtherHosFeeRgeFrom = new TextString();
			estInfo_OtherHosFeeRgeFrom.setBounds(210, 70, 80, 20);
		}
		return estInfo_OtherHosFeeRgeFrom;
	}
	
	protected LabelBase getEstInfo_OtherHosFeeRgeSym() {
		if (estInfo_OtherHosFeeRgeSym == null) {
			estInfo_OtherHosFeeRgeSym = new LabelBase();
			estInfo_OtherHosFeeRgeSym.setText("~");
			estInfo_OtherHosFeeRgeSym.setBounds(295, 70, 20, 20);
		}
		return estInfo_OtherHosFeeRgeSym;
	}
	
	public TextString getEstInfo_OtherHosFeeRgeTo() {
		if (estInfo_OtherHosFeeRgeTo == null) {
			estInfo_OtherHosFeeRgeTo = new TextString();
			estInfo_OtherHosFeeRgeTo.setBounds(310, 70, 80, 20);
		}
		return estInfo_OtherHosFeeRgeTo;
	}

}