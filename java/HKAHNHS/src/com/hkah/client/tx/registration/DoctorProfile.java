package com.hkah.client.tx.registration;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.BaseEvent;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.util.DelayedTask;
import com.google.gwt.event.dom.client.ErrorEvent;
import com.google.gwt.event.dom.client.ErrorHandler;
import com.google.gwt.user.client.ui.HTML;
import com.google.gwt.user.client.ui.Image;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboDoctorProfile;
import com.hkah.client.layout.dialog.DlgInstruction;
import com.hkah.client.layout.dialog.DlgPBORemark;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextDoctorSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextRemark;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DoctorProfile extends MasterPanel{

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.DOCINSTRUCTION_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.DOCTORPROFILE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {};
	}

	private static String SERVER_PATH_PHOTO = null;
	private static String SERVER_PATH_SIGN = null;
	private static String SERVER_PATH_NO_IMAGE = null;

	private BasePanel rightPanel = null;
	private BasePanel leftPanel = null;

	private int TabbedPaneIndex = 0;

	protected TabbedPaneBase TabbedPane = null; // right bottom tabbedpane
	private BasePanel MasterPanel = null; // Master Panel
	private BasePanel additInfoPanel = null; // Additional Info Panel
	private JScrollPane docSpecListPanel = null;

	private LabelBase DoctorNameDesc = null;
	private ComboDoctorProfile DoctorName = null;//ComboDocName
	private LabelBase DrCodeDesc = null;
	private ComboDoctorProfile DrCode = null;
	private TextDoctorSearch drCodeSearchDelegate = null;
	private LabelBase SpecialtyDesc = null;
	private ComboDoctorProfile Specialty = null;
	private LabelBase SexDesc = null;
	private LabelBase Sex = null;
	private ButtonBase Instruction = null;
	private LabelBase DocCodeDesc = null;
	private LabelBase DocCode = null;
	private LabelBase DocTypeDesc = null;
	private LabelBase DocType = null;
	private LabelBase OTSurgeonDesc = null;
	private CheckBoxBase OTSurgeon = null;
	private LabelBase OTAnesDesc = null;
	private CheckBoxBase OTAnes = null;
	private LabelBase DeclarationOfSTODesc = null;
	private CheckBoxBase DeclarationOfSTO = null;
	private LabelBase OffTelDesc = null;
	private LabelBase OffTel = null;
	private LabelBase HomeTelDesc = null;
	private LabelBase HomeTel = null;
	private LabelBase PagerDesc = null;
	private LabelBase Pager = null;
	private LabelBase MobileDesc = null;
	private LabelBase Mobile = null;
	private LabelBase EmailDesc = null;
	private LabelBase Email = null;
	private LabelBase FaxnoDesc = null;
	private LabelBase Faxno = null;
	private LabelBase ContactAddDesc = null;
	private LabelBase ContactAdd1 = null;
	private LabelBase ContactAdd2 = null;
	private LabelBase ContactAdd3 = null;
	private LabelBase ContactAdd4 = null;
	private ButtonBase PBORemarkDesc = null;
	private TextReadOnly PBORemark = null;
	private LabelBase AnnPractLicDateDesc = null;
	private LabelBase AnnPractLicDate = null;
	private LabelBase MalpInsExpDateDesc = null;
	private LabelBase MalpInsExpDate = null;
	private LabelBase AdmissionExpDateDesc = null;
	private LabelBase AdmissionExpDate = null;
	private LabelBase OPPrivExpDateDesc = null;
	private LabelBase InsuranceCompanyDesc = null;
	private LabelBase InsuranceCompany = null;
	private LabelBase OPPrivExpDate = null;

	private LabelBase otherCodeDesc = null;
	private TextRemark otherCode = null;
	private LabelBase PriProDesc = null;
	private TextRemark PriPro = null;

	private BasePanel Photo = null;
	private HTML Line = null;
//	private LabelBase Line = null;
	private Image img = null;

	private LabelBase DocSignHeading = null;
	private BasePanel DocSign = null;
	private Image img1 = null;

	private DlgInstruction InsDialog = null;
	private DlgPBORemark PBORemarkDialog = null;

	private String memDocCode = EMPTY_VALUE;
	private String memDocName = EMPTY_VALUE;
	private String picPath = EMPTY_VALUE;
	private String signPath = EMPTY_VALUE;
	private LabelBase SpecListDesc = null;
	private TableList SpecListTable = null;
	private BasePanel linePanel = null;

	private DelayedTask taTask = null;
	private int typeAheadDelay = 250;

	/**
	 * This method initializes
	 *
	 */
	public DoctorProfile() {
		super();
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
		clearAllField(null);

		if (YES_VALUE.equals(getSysParameter("DRSWOTRCDE")) && !isDisableFunction("viewOtherCode", "DoctorProfile")) {
			getPBORemarkDesc().setVisible(true);
			getPBORemark().setVisible(true);
			getPriProDesc().setBounds(532, 415, 141, 20);
			getPriPro().setBounds(532, 440, 280, 90);
			getOtherCode().setVisible(true);
			getOtherCodeDesc().setVisible(true);
		}

		picPath = getSysParameter("DOCPICPATH");
		if (!"\\".equals(CommonUtil.right(picPath, 1))) {
			picPath+="\\";
		}
		signPath = getSysParameter("DOCFULPATH");
		if (!"\\".equals(CommonUtil.right(signPath, 1))) {
			signPath+="\\";
		}
		getPhoto().setUrl(getServerPathNoImage());
		getDocSign().setUrl(getServerPathNoImage());
		getTabbedPane().setSelectedIndex(0);
		enableButton();
		PanelUtil.setAllFieldsEditable(getRightPanel(), true);

		getInstruction().setEnabled(false);
		getPBORemarkDesc().setEnabled(false);
		getPriPro().setReadOnly(true);

		memDocCode = EMPTY_VALUE;

		if (taTask == null) {
			taTask = new DelayedTask(new Listener<BaseEvent>() {
				public void handleEvent(BaseEvent be) {
					doSearch();
				}
			});
		}
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return null;//getDoctorName();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {}

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
		return new String[] {};
	}

	/* >>> ~15.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {}

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
		getInstruction().setEnabled(true);
		showDoctorPhoto(true);
		showDoctorSign(true);

		getDocCode().setText(outParam[0]);
		getDocType().setText(outParam[72]);
		getSex().setText(outParam[5]);
		getOTSurgeon().setSelected(YES_VALUE.equals(outParam[42]));
		getOTAnes().setSelected(YES_VALUE.equals(outParam[43]));
		getDeclarationOfSTO().setSelected(YES_VALUE.equals(outParam[74]));
		getOffTel().setText(outParam[17]);
		getHomeTel().setText(outParam[16]);
		getPager().setText(outParam[18]);
		getMobile().setText(outParam[30]);
		getEmail().setText(outParam[31]);
		getFaxno().setText(outParam[32]);
		getContactAdd1().setText(outParam[13]);
		getContactAdd2().setText(outParam[14]);
		getContactAdd3().setText(outParam[15]);
		getContactAdd4().setText(outParam[34]);
		getPBORemark().setText(outParam[73]);
		getAnnPractLicDate().setText(outParam[68]);
		getMalpInsExpDate().setText(outParam[69]);
		getAdmissionExpDate().setText(outParam[21]);
		getOPPrivExpDate().setText(outParam[70]);
		getInsuranceCompany().setText(outParam[71]);

		QueryUtil.executeMasterBrowse(
				getUserInfo(), "DOC_PRIVILEGE", new String[] { memDocCode },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					String temp = mQueue.getContentAsQueue().replaceAll("<FIELD/>", EMPTY_VALUE).replaceAll("<LINE/>", "\n");
					getPriPro().setText(temp);
					getPriPro().setReadOnly(true);
				} else {
					getPriPro().resetText();
				}
			}
		});

		QueryUtil.executeMasterFetch(getUserInfo(),"DOCTOR_OTHERCODE",
				new String[] { memDocCode },
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					String temp = mQueue.getContentAsQueue().replaceAll("<FIELD/>", SPACE_VALUE).replaceAll("<LINE/>", "\n");
					getOtherCode().setText(temp);
					getOtherCode().setReadOnly(true);
				} else {
					getOtherCode().resetText();
				}
			}
		});

		getPBORemarkDesc().setEnabled(!isDisableFunction("pboRemark", "DoctorProfile"));

		// fill data in Instruction Dialog
		memDocName = outParam[1]+" "+outParam[2] + " " + outParam[3];
		if (!isDisableFunction("AdditionalTab", "DoctorProfile")) {
			getSpecListTable().setListTableContent("SUBSPECIALTY", new String[] { memDocCode });
		}
		getPriPro().setReadOnly(true);
		layout();
	}

	/* >>> ~16.2~ Set Action Output Parameters ============================ <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {};
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	private String getServerPathPhoto() {
		if (SERVER_PATH_PHOTO == null) {
			SERVER_PATH_PHOTO = "http://" + getSysParameter("ptIgUrlSte") + "/intranet/hat/docPhoto.jsp?doccode=";
		}
		return SERVER_PATH_PHOTO;
	}

	private String getServerPathSign() {
		if (SERVER_PATH_SIGN == null) {
			SERVER_PATH_SIGN = "http://" + getSysParameter("ptIgUrlSte") + "/intranet/hat/docSign.jsp?doccode=";
		}
		return SERVER_PATH_SIGN;
	}

	private String getServerPathNoImage() {
		if (SERVER_PATH_NO_IMAGE == null) {
			SERVER_PATH_NO_IMAGE = "http://" + getSysParameter("ptIgUrlSte") + "/hats/images/Photo Not Available.jpg";
		}
		return SERVER_PATH_NO_IMAGE;
	}

	private void doSearch(ModelData modelData, ComboBoxBase comp, boolean forceUpdate) {
		if (modelData != null) {
			final String doccode = modelData.get(ZERO_VALUE).toString();
			if (doccode.equals(memDocCode)  && !forceUpdate) return;
			clearAllField(comp);
			memDocCode = doccode;

			if (!comp.equals(getDoctorName())) {
				getDoctorName().setSelectedIndex(doccode);
			}
			if (!comp.equals(getDrCode())) {
				getDrCode().setSelectedIndex(doccode);
			}
			if (!comp.equals(getSpecialty())) {
				getSpecialty().setSelectedIndex(doccode);
			}

			taTask.delay(typeAheadDelay);
		} else {
			clearAllField(comp);
		}
	}

	private void doSearch() {
		writeLog("DoctorProfile", "Info", "Searching by Doccode: " + memDocCode + " ("+DateTimeUtil.getCurrentDateTime()+")");

		QueryUtil.executeMasterFetch(
				getUserInfo(), ConstantsTx.DOCTOR_TXCODE, new String[] {memDocCode},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					writeLog("DoctorProfile", "Info", "Returned Doccode: "+mQueue.getContentField()[0]+ " ("+DateTimeUtil.getCurrentDateTime()+")");
					if (mQueue.getContentField()[0].equals(memDocCode)) {
						getFetchOutputValues(mQueue.getContentField());
					}
				}
			}
		});
	}

	/*
	 * showDoctorPhoto()
	 */
	private void showDoctorPhoto(boolean showImage) {
		if (!showImage) {
			getPhoto().setUrl(getServerPathNoImage());
		} else {
			getPhoto().setUrl(getServerPathPhoto() + memDocCode);
		}
	}

	private void showDoctorSign(boolean showImage) {
		if (!showImage) {
			getDocSign().setUrl(getServerPathNoImage());
		} else {
			if (signPath == null || "".equals(signPath) ||
					memDocCode  == null || "".equals(memDocCode)) {
				if ((getDocSign().getUrl().contains("NotFound.jpg") || getDocSign().getUrl().contains("Not Available"))) {
					getDocSign().setUrl(getServerPathNoImage());
				}
			} else {
				getDocSign().setUrl(getServerPathSign() + memDocCode);
			}
		}
	}

	private void clearAllField(ComboBoxBase comp) {
		memDocCode = null;

		if (comp == null || !comp.equals(getDoctorName())) {
			getDoctorName().resetText();
		}

		if (comp == null || !comp.equals(getDrCode())) {
			getDrCode().resetText();
		}

		if (comp == null || !comp.equals(getSpecialty())) {
			getSpecialty().resetText();
		}

		getSex().resetText();
		getDocCode().resetText();
		getDocType().resetText();
		getOTSurgeon().setSelected(false);
		getOTAnes().setSelected(false);
		getDeclarationOfSTO().setSelected(false);
		getOffTel().resetText();
		getHomeTel().resetText();
		getPager().resetText();
		getMobile().resetText();
		getFaxno().resetText();
		getEmail().resetText();
		getContactAdd1().resetText();
		getContactAdd2().resetText();
		getContactAdd3().resetText();
		getContactAdd4().resetText();
		getPBORemark().resetText();
		getPriPro().resetText();
		getAnnPractLicDate().resetText();
		getMalpInsExpDate().resetText();
		getAdmissionExpDate().resetText();
		getOPPrivExpDate().resetText();
		getOtherCode().resetText();

		showDoctorPhoto(false);
		showDoctorSign(false);

		getInstruction().setEnabled(false);
		getPBORemarkDesc().setEnabled(false);
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void proExitPanel() {
		initAfterReady();

		if (taTask != null) {
			taTask.cancel();
			taTask = null;
		}
	}

	@Override
	protected void enableButton(String mode) {
		// disable all button
		disableButton();
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/


	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.setSize(788, 570);
			leftPanel.add(getTabbedPane(), null);
		}
		return leftPanel;
	}

	protected BasePanel getRightPanel() {
		if (rightPanel == null) {
			rightPanel = new BasePanel();
//			rightPanel.setSize(800, 530));
		}
		return rightPanel;
	}

	public BasePanel getMasterPanel() {
		if (MasterPanel == null) {
			MasterPanel = new BasePanel();
			MasterPanel.setBounds(0, 0, 825, 550);
			MasterPanel.add(getDoctorNameDesc(), null);
			MasterPanel.add(getDoctorName(), null);
			MasterPanel.add(getDrCodeDesc(), null);
			MasterPanel.add(getDrCode(), null);
			MasterPanel.add(getDrCodeSearchDelegate(), null);
			MasterPanel.add(getSpecialtyDesc(), null);
			MasterPanel.add(getSpecialty(), null);
			MasterPanel.add(getSexDesc(), null);
			MasterPanel.add(getSex(), null);
			MasterPanel.add(getLinePanel(), null);
			MasterPanel.add(getInstruction(), null);
			MasterPanel.add(getDocCodeDesc(), null);
			MasterPanel.add(getDocCode(), null);
			MasterPanel.add(getDocTypeDesc(), null);
			MasterPanel.add(getDocType(), null);
			MasterPanel.add(getOTSurgeonDesc(), null);
			MasterPanel.add(getOTSurgeon(), null);
			MasterPanel.add(getOTAnesDesc(), null);
			MasterPanel.add(getOTAnes(), null);
			MasterPanel.add(getDeclarationOfSTODesc(), null);
			MasterPanel.add(getDeclarationOfSTO(), null);
			MasterPanel.add(getOffTelDesc(), null);
			MasterPanel.add(getOffTel(), null);
			MasterPanel.add(getHomeTelDesc(), null);
			MasterPanel.add(getHomeTel(), null);
			MasterPanel.add(getPagerDesc(), null);
			MasterPanel.add(getPager(), null);
			MasterPanel.add(getMobileDesc(), null);
			MasterPanel.add(getMobile(), null);
			MasterPanel.add(getEmailDesc(), null);
			MasterPanel.add(getEmail(), null);
			MasterPanel.add(getFaxnoDesc(), null);
			MasterPanel.add(getFaxno(), null);
			MasterPanel.add(getContactAddDesc(), null);
			MasterPanel.add(getContactAdd1(), null);
			MasterPanel.add(getContactAdd2(), null);
			MasterPanel.add(getContactAdd3(), null);
			MasterPanel.add(getContactAdd4(), null);
			MasterPanel.add(getPBORemarkDesc(), null);
			MasterPanel.add(getPBORemark(), null);
			MasterPanel.add(getPriProDesc(), null);
			MasterPanel.add(getPriPro(), null);
			MasterPanel.add(getOtherCodeDesc(), null);
			MasterPanel.add(getOtherCode(), null);
			MasterPanel.add(getPhotoFrame(), null);
		}
		return MasterPanel;
	}

	public BasePanel getAdditInfoPanel() {
		if (additInfoPanel == null) {
			additInfoPanel = new BasePanel();
			additInfoPanel.setBounds(0, 0, 825, 550);
			additInfoPanel.add(getAnnPractLicDateDesc(), null);
			additInfoPanel.add(getAnnPractLicDate(), null);
			additInfoPanel.add(getMalpInsExpDateDesc(), null);
			additInfoPanel.add(getMalpInsExpDate(), null);
			additInfoPanel.add(getAdmissionExpDateDesc(), null);
			additInfoPanel.add(getAdmissionExpDate(), null);
			additInfoPanel.add(getOPPrivExpDateDesc(), null);
			additInfoPanel.add(getOPPrivExpDate(), null);
			additInfoPanel.add(getInsuranceCompanyDesc(), null);
			additInfoPanel.add(getInsuranceCompany(), null);
			additInfoPanel.add(getDocSignFrameHeading(), null);
			additInfoPanel.add(getDocSignFrame(), null);
			additInfoPanel.add(getSpecListDesc(), null);
			additInfoPanel.add(getSpecListPanel(), null);
		}
		return additInfoPanel;
	}

	public TabbedPaneBase getTabbedPane() {
		if (TabbedPane == null) {
			TabbedPane = new TabbedPaneBase() {
				public void onStateChange() {
					int selectedIndex = TabbedPane.getSelectedIndex();

					if (memDocCode == null || memDocCode.length() == 0) {
						TabbedPane.setSelectedIndexWithoutStateChange(0);
						return;
					}

					setTabbedPaneIndex(TabbedPane.getSelectedIndex());
					enableButton();
				}
			};
			TabbedPane.setBounds(0, 0, 830, 570);
			TabbedPane.addTab("<u>G</u>eneral info", getMasterPanel());
			if (!isDisableFunction("AdditionalTab", "DoctorProfile")) {
				TabbedPane.addTab("<u>A</u>dditional Info", getAdditInfoPanel());
			}
		}
		return TabbedPane;
	}
/*
	public BasePanel getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new BasePanel();
			ParaPanel.add(getLJLabel_PatNo(), null);
			ParaPanel.add(getLJText_PatNo(), null);
			ParaPanel.add(getLJLabel_FamName(), null);
			ParaPanel.add(getLJText_FamName(), null);
			ParaPanel.add(getLJLabel_GivenName(), null);
			ParaPanel.add(getLJText_GivenName(), null);
			ParaPanel.setBounds(5, 5, 757, 72));
		}
		return ParaPanel;
	}
*/
	public LabelBase getDoctorNameDesc() {
		if (DoctorNameDesc == null) {
			DoctorNameDesc = new LabelBase();
			DoctorNameDesc.setText("Doctor Name:");
			DoctorNameDesc.setBounds(10, 10, 119, 20);
			DoctorNameDesc.setOptionalLabel();
		}
		return DoctorNameDesc;
	}

	public ComboDoctorProfile getDoctorName() {
		if (DoctorName == null) {
			DoctorName = new ComboDoctorProfile("DOCTOR_NAME") {
				@Override
				protected void onTypeAhead() {
					String text = getRawValue().trim();
					if (getStore().getCount() > 0 && text != null && text.length() > 0) {
						ModelData modelDataRaw = findModelByDisplayText(text);//findModelByKey(text);
						ModelData modelDataList = getStore().getAt(0);
						if (modelDataRaw != null && !modelDataList.equals(modelDataRaw)) {
//							System.err.println("3onTypeAhead: "+propertyEditor.getStringValue(modelDataRaw)+" ("+propertyEditor.getStringValue(modelDataRaw).length()+")");
//							setRawValue(propertyEditor.getStringValue(modelDataRaw));
//							System.err.println("2onTypeAhead: "+getRawValue()+" ("+getRawValue().length()+")");
							return;
						}
					}
					super.onTypeAhead();

					if (text.length() > 0) {
//						writeLog("DoctorProfile", "Info", "Doctor Name: "+text);
						doSearch(findModelByDisplayText(text), this, false);
					} else {
						clearAllField(null);
					}
//					DoctorName.setCursorPos(0);
				}

				@Override
				protected void setTextPanel(ModelData modelData) {
//					System.err.println("1setTextPanel: "+getRawValue()+" ("+getRawValue().length()+")");
					if (getRawValue().trim().length() == 0) {
						clearAllField(null);
					} else if (getRawValue().trim().length() > 0 && isFocusOwner()) {
//						writelog("DoctorProfile", "Info", "Doctor Name: "+getRawValue());
						doSearch(modelData, this, false);
					}
				}

				@Override
				protected void onReleased() {
//					System.err.println("1onReleased: "+getRawValue()+" ("+getRawValue().length()+")");
					super.onReleased();
					if (getRawValue().trim().length() == 0) {
						clearAllField(null);
					} else {
//						System.err.println("2onReleased: "+findModelByDisplayText(getRawValue()));
//						writelog("DoctorProfile", "Info", "Doctor Name: "+getRawValue());
						doSearch(findModelByDisplayText(getRawValue().trim()), this, true);
					}
				}

				@Override
				protected void onTwinTriggerClick(ComponentEvent ce) {
					super.onTwinTriggerClick(ce);
					clearAllField(null);
				}
			};
			DoctorName.setBounds(130, 10, 385, 20);
		}
		return DoctorName;
	}

	public LabelBase getDrCodeDesc() {
		if (DrCodeDesc == null) {
			DrCodeDesc = new LabelBase();
			DrCodeDesc.setText("Dr. Code:");
			DrCodeDesc.setBounds(10, 35, 119, 20);
			DrCodeDesc.setOptionalLabel();
		}
		return DrCodeDesc;
	}

	public ComboDoctorProfile getDrCode() {
		if (DrCode == null) {
			DrCode = new ComboDoctorProfile("DOCTOR") {
				@Override
				protected void onTypeAhead() {
					String text = getRawValue().trim();
					if (getStore().getCount() > 0 && text != null && text.length() > 0) {
						ModelData modelDataRaw = findModelByDisplayText(text);//findModelByKey(text);
						ModelData modelDataList = getStore().getAt(0);
						if (modelDataRaw != null && !modelDataList.equals(modelDataRaw)) {
//							System.err.println("3onTypeAhead: "+propertyEditor.getStringValue(modelDataRaw)+" ("+propertyEditor.getStringValue(modelDataRaw).length()+")");
//							setRawValue(propertyEditor.getStringValue(modelDataRaw));
//							System.err.println("2onTypeAhead: "+getRawValue()+" ("+getRawValue().length()+")");
							return;
						}
					}
					super.onTypeAhead();

					if (text.length() > 0) {
//						writelog("DoctorProfile", "Info", "Doctor Code: "+text);
						doSearch(findModelByDisplayText(text), this, false);
					} else {
						clearAllField(null);
					}
//					DoctorName.setCursorPos(0);
				}

				@Override
				protected void setTextPanel(ModelData modelData) {
//					System.err.println("2setTextPanel: "+getRawValue()+" ("+getRawValue().length()+")");
					if (getRawValue().trim().length() == 0) {
						clearAllField(null);
					} else if (getRawValue().trim().length() > 0 && isFocusOwner()) {
//						writelog("DoctorProfile", "Info", "Doctor Code: "+getRawValue().trim());
						doSearch(modelData, this, false);
					}
				}

				@Override
				protected void onReleased() {
//					System.err.println("onReleased: "+getRawValue()+" ("+getRawValue().length()+")");
					super.onReleased();
					if (getRawValue().trim().length() == 0) {
						clearAllField(null);
					} else {
//						writelog("DoctorProfile", "Info", "Doctor Code: "+getRawValue().trim());
						doSearch(findModelByDisplayText(getRawValue().trim()), this, true);
					}
				}

				@Override
				protected void onTwinTriggerClick(ComponentEvent ce) {
					super.onTwinTriggerClick(ce);
					clearAllField(null);
				}

				@Override
				public void onSearchTriggerClick(ComponentEvent ce) {
					getDrCodeSearchDelegate().setValue(this.getText());
					getDrCodeSearchDelegate().showSearchPanel();
				}

				@Override
				public void checkTriggerBySearchKey() {
					getDrCodeSearchDelegate().setValue(this.getText());
					getDrCodeSearchDelegate().checkTriggerBySearchKey();
				}
			};
			DrCode.setShowTextSearhPanel(true);
			DrCode.setBounds(130, 35, 385, 20);
		}
		return DrCode;
	}

	public TextDoctorSearch getDrCodeSearchDelegate() {
		if (drCodeSearchDelegate == null) {
			drCodeSearchDelegate = new TextDoctorSearch() {
				@Override
				public void searchAfterAcceptAction() {
					getDrCode().setText(getValue());
					doSearch(getDrCode().getValue(), getDrCode(), true);
				}
			};
			drCodeSearchDelegate.setBounds(10, 35, 70, 20);
			drCodeSearchDelegate.setVisible(false);
		}
		return drCodeSearchDelegate;
	}

	public LabelBase getSpecialtyDesc() {
		if (SpecialtyDesc == null) {
			SpecialtyDesc = new LabelBase();
			SpecialtyDesc.setText("Specialty");
			SpecialtyDesc.setBounds(10, 60, 119, 20);
			SpecialtyDesc.setOptionalLabel();
		}
		return SpecialtyDesc;
	}

	public ComboDoctorProfile getSpecialty() {
		if (Specialty == null) {
			Specialty = new ComboDoctorProfile("SPECIALTY") {
				@Override
				protected void onTypeAhead() {
					String text = getRawValue().trim();
					if (getStore().getCount() > 0 && text != null && text.length() > 0) {
						ModelData modelDataRaw = findModelByDisplayText(text);//findModelByKey(text);
						ModelData modelDataList = getStore().getAt(0);
						if (modelDataRaw != null && !modelDataList.equals(modelDataRaw)) {
//							System.err.println("3onTypeAhead: "+propertyEditor.getStringValue(modelDataRaw)+" ("+propertyEditor.getStringValue(modelDataRaw).length()+")");
//							setRawValue(propertyEditor.getStringValue(modelDataRaw));
//							System.err.println("2onTypeAhead: "+getRawValue()+" ("+getRawValue().length()+")");
							return;
						}
					}
					super.onTypeAhead();

					if (text.length() > 0) {
//						writelog("DoctorProfile", "Info", "Specialty: "+text);
						doSearch(findModelByDisplayText(text), this, false);
					} else {
						clearAllField(null);
					}
//					DoctorName.setCursorPos(0);
				}

				@Override
				protected void setTextPanel(ModelData modelData) {
//					System.err.println("3setTextPanel: "+getRawValue()+" ("+getRawValue().length()+")");
					if (getRawValue().trim().length() == 0) {
						clearAllField(null);
					} else if (getRawValue().trim().length() > 0 && isFocusOwner()) {
//						writelog("DoctorProfile", "Info", "Specialty: "+getRawValue().trim());
						doSearch(modelData, this, false);
					}
				}

				@Override
				protected void onReleased() {
//					System.err.println("onReleased: "+getRawValue()+" ("+getRawValue().length()+")");
					super.onReleased();
					if (getRawValue().trim().length() == 0) {
						clearAllField(null);
					} else {
//						writelog("DoctorProfile", "Info", "Specialty: "+getRawValue().trim());
						doSearch(findModelByDisplayText(getRawValue().trim()), this, true);
					}
				}

				@Override
				protected void onTwinTriggerClick(ComponentEvent ce) {
					super.onTwinTriggerClick(ce);
					clearAllField(null);
				}
			};
			Specialty.setBounds(130, 60, 385, 20);
		}
		return Specialty;
	}

	public LabelBase getSexDesc() {
		if (SexDesc == null) {
			SexDesc = new LabelBase();
			SexDesc.setText("Sex");
			SexDesc.setBounds(10, 85, 119, 20);
		}
		return SexDesc;
	}

	public LabelBase getSex() {
		if (Sex == null) {
			Sex = new LabelBase();
			Sex.resetText();
			Sex.setBounds(130, 85, 128, 20);
		}
		return Sex;
	}

	public ButtonBase getInstruction() {
		if (Instruction == null) {
			Instruction = new ButtonBase() {
				@Override
				public void onClick() {
					if (memDocCode.length() > 0 && getDrCode().getText().length() > 0) {
						getInstructionDialog().showDialog(memDocCode, memDocName, !isDisableFunction("EDIT", "DoctorProfile"));
					}
				}
			};
			Instruction.setText("Instruction");
			Instruction.setBounds(405, 85, 110, 25);
		}
		return Instruction;
	}

	public BasePanel getLinePanel() {
		if (linePanel == null) {
			linePanel = new BasePanel();
			linePanel.setBounds(10, 110, 510, 10);
			linePanel.add(getLine(), null);
		}
		return linePanel;
	}

	public HTML getLine() {
		if (Line == null) {
			Line = new HTML("<hr COLOR=\"red\" />");
		}
		return Line;
	}

	public LabelBase getDocCodeDesc() {
		if (DocCodeDesc == null) {
			DocCodeDesc = new LabelBase();
			DocCodeDesc.setText("Doctor Code:");
			DocCodeDesc.setBounds(10, 130, 119, 20);
		}
		return DocCodeDesc;
	}

	public LabelBase getDocCode() {
		if (DocCode == null) {
			DocCode = new LabelBase();
			DocCode .setText("-");
			DocCode.setBounds(130, 130, 19, 20);
		}
		return DocCode;
	}

	public LabelBase getDocTypeDesc() {
		if (DocTypeDesc == null) {
			DocTypeDesc = new LabelBase();
			DocTypeDesc.setText("Doctor Type:");
			DocTypeDesc.setBounds(278, 130, 119, 20);
		}
		return DocTypeDesc;
	}

	public LabelBase getDocType() {
		if (DocType == null) {
			DocType = new LabelBase();
			DocType.setBounds(397, 130, 128, 20);
		}
		return DocType;
	}

	public LabelBase getOTSurgeonDesc() {
		if (OTSurgeonDesc == null) {
			OTSurgeonDesc = new LabelBase();
			OTSurgeonDesc.setText("OT Surgeon:");
			OTSurgeonDesc.setBounds(10, 155, 119, 20);
		}
		return OTSurgeonDesc;
	}

	public CheckBoxBase getOTSurgeon() {
		if (OTSurgeon == null) {
			OTSurgeon = new CheckBoxBase();
			OTSurgeon.setBounds(130, 155, 19, 20);
			OTSurgeon.setEditable(false);
		}
		return OTSurgeon;
	}

	public LabelBase getOTAnesDesc() {
		if (OTAnesDesc == null) {
			OTAnesDesc = new LabelBase();
			OTAnesDesc.setText("OT Anesthetist:");
			OTAnesDesc.setBounds(278, 155, 119, 20);
		}
		return OTAnesDesc;
	}

	public CheckBoxBase getOTAnes() {
		if (OTAnes == null) {
			OTAnes = new CheckBoxBase();
			OTAnes.setEditable(false);
			OTAnes.setBounds(397, 155, 19, 20);
			OTSurgeon.setEditable(false);
		}
		return OTAnes;
	}
	
	public LabelBase getDeclarationOfSTODesc() {
		if (DeclarationOfSTODesc == null) {
			DeclarationOfSTODesc = new LabelBase();
			DeclarationOfSTODesc.setText("Declaration of Secured Text Order via cell phone usage");
			DeclarationOfSTODesc.setBounds(10, 180, 350, 20);
		}
		return DeclarationOfSTODesc;
	}

	public CheckBoxBase getDeclarationOfSTO() {
		if (DeclarationOfSTO == null) {
			DeclarationOfSTO = new CheckBoxBase();
			DeclarationOfSTO.setBounds(361, 180, 19, 20);
			DeclarationOfSTO.setEditable(false);
		}
		return DeclarationOfSTO;
	}

	public LabelBase getOffTelDesc() {
		if (OffTelDesc == null) {
			OffTelDesc = new LabelBase();
			OffTelDesc.setText("Office Phone:");
			OffTelDesc.setBounds(10, 205, 119, 20);
		}
		return OffTelDesc;
	}

	public LabelBase getOffTel() {
		if (OffTel == null) {
			OffTel = new LabelBase();
			OffTel.setText("-");
			OffTel.setBounds(130, 205, 128, 20);
		}
		return OffTel;
	}

	public LabelBase getHomeTelDesc() {
		if (HomeTelDesc == null) {
			HomeTelDesc = new LabelBase();
			HomeTelDesc.setText("Home Phone:");
			HomeTelDesc.setBounds(278, 205, 119, 20);
		}
		return HomeTelDesc;
	}

	public LabelBase getHomeTel() {
		if (HomeTel == null) {
			HomeTel = new LabelBase();
			HomeTel.setText("-");
			HomeTel.setBounds(397, 205, 128, 20);
		}
		return HomeTel;
	}

	public LabelBase getPagerDesc() {
		if (PagerDesc == null) {
			PagerDesc = new LabelBase();
			PagerDesc.setText("Pager");
			PagerDesc.setBounds(10, 230, 119, 20);
		}
		return PagerDesc;
	}

	public LabelBase getPager() {
		if (Pager == null) {
			Pager = new LabelBase();
			Pager.setText("-");
			Pager.setBounds(130, 230, 128, 20);

		}
		return Pager;
	}

	public LabelBase getMobileDesc() {
		if (MobileDesc == null) {
			MobileDesc = new LabelBase();
			MobileDesc.setText("Mobile:");
			MobileDesc.setBounds(278, 230, 119, 20);
		}
		return MobileDesc;
	}

	public LabelBase getMobile() {
		if (Mobile == null) {
			Mobile = new LabelBase();
			Mobile.setText("-");
			Mobile.setBounds(397, 230, 128, 20);
		}
		return Mobile;
	}

	public LabelBase getFaxnoDesc() {
		if (FaxnoDesc == null) {
			FaxnoDesc = new LabelBase();
			FaxnoDesc.setText("Fax No:");
			FaxnoDesc.setBounds(10, 255, 119, 20);
		}
		return FaxnoDesc;
	}

	public LabelBase getFaxno() {
		if (Faxno == null) {
			Faxno = new LabelBase();
			Faxno.setText("-");
			Faxno.setBounds(130, 255, 128, 20);
		}
		return Faxno;
	}

	public LabelBase getEmailDesc() {
		if (EmailDesc == null) {
			EmailDesc = new LabelBase();
			EmailDesc.setText("Email:");
			EmailDesc.setBounds(10, 280, 119, 20);
		}
		return EmailDesc;
	}

	public LabelBase getEmail() {
		if (Email == null) {
			Email = new LabelBase();
			Email.setText("-");
			Email.setBounds(130, 280, 500, 20);
		}
		return Email;
	}

	public LabelBase getContactAddDesc() {
		if (ContactAddDesc == null) {
			ContactAddDesc = new LabelBase();
			ContactAddDesc.setText("Contact Address:");
			ContactAddDesc.setBounds(10, 300, 119, 20);
		}
		return ContactAddDesc;
	}

	public LabelBase getContactAdd1() {
		if (ContactAdd1 == null) {
			ContactAdd1 = new LabelBase();
			ContactAdd1.setText("-");
			ContactAdd1.setBounds(130, 300, 386, 20);
		}
		return ContactAdd1;
	}

	public LabelBase getContactAdd2() {
		if (ContactAdd2 == null) {
			ContactAdd2 = new LabelBase();
			ContactAdd2.setText("-");
			ContactAdd2.setBounds(130, 320, 386, 20);
		}
		return ContactAdd2;
	}

	public LabelBase getContactAdd3() {
		if (ContactAdd3 == null) {
			ContactAdd3 = new LabelBase();
			ContactAdd3.setText("-");
			ContactAdd3.setBounds(130, 340, 386, 20);
		}
		return ContactAdd3;
	}

	public LabelBase getContactAdd4() {
		if (ContactAdd4 == null) {
			ContactAdd4 = new LabelBase();
			ContactAdd4.setText("-");
			ContactAdd4.setBounds(130, 360, 386, 20);
		}
		return ContactAdd4;
	}

	public ButtonBase getPBORemarkDesc() {
		if (PBORemarkDesc == null) {
			PBORemarkDesc = new ButtonBase() {
				@Override
				public void onClick() {
					if (memDocCode.length() > 0 && getDrCode().getText().length() > 0) {
						getPBORemarkDialog().showDialog(memDocCode);
					}
				}
			};
			PBORemarkDesc.setText("PBO Remark");
			PBORemarkDesc.setBounds(10, 385, 110, 25);
			PBORemarkDesc.setVisible(false);
		}
		return PBORemarkDesc;
	}

	public TextReadOnly getPBORemark() {
		if (PBORemark == null) {
			PBORemark = new TextReadOnly();
			PBORemark.setText("-");
			PBORemark.setBounds(130, 385, 386, 20);
			PBORemark.setVisible(false);
		}
		return PBORemark;
	}

	public LabelBase getOtherCodeDesc() {
		if (otherCodeDesc == null) {
			otherCodeDesc = new LabelBase();
			otherCodeDesc.setText("Other Doctor Code:");
			otherCodeDesc.setBounds(10, 415, 141, 20);
			otherCodeDesc.setVisible(false);
		}
		return otherCodeDesc;
	}

	public TextRemark getOtherCode() {
		if (otherCode == null) {
			otherCode = new TextRemark();
			otherCode.setBounds(10, 440, 450, 90);
			otherCode.setVisible(false);
		}
		return otherCode;
	}

	public LabelBase getPriProDesc() {
		if (PriProDesc == null) {
			PriProDesc = new LabelBase();
			PriProDesc.setText("Privileges / Procedure:");
			PriProDesc.setBounds(532, 415, 141, 20);
		}
		return PriProDesc;
	}

	public TextRemark getPriPro() {
		if (PriPro == null) {
			PriPro = new TextRemark();
			PriPro.setBounds(532, 440, 280, 90);
		}
		return PriPro;
	}

	public Image getPhoto() {
		if (img == null) {
			img = new Image();
			img.setUrl(getServerPathNoImage());
			img.addErrorHandler(new ErrorHandler() {
				@Override
				public void onError(ErrorEvent event) {
					img.setUrl(getServerPathNoImage());
				}
			});
			img.setPixelSize(260, 340);
		}
		return img;
	}

	public BasePanel getPhotoFrame() {
		if (Photo == null) {
			Photo = new BasePanel();
			Photo.setBounds(532, 10, 260, 340);
			Photo.setBorders(true);
//			Photo.setHorizontalAlignment(LabelBase.CENTER);
//			Photo.setBorder(BorderFactory.createLineBorder(Color.black));
//			Photo.setText("<html><center>PHOTO <br>IS <br>NOT AVAILABLE</center></html>");
			Photo.add(getPhoto());
		}
		return Photo;
	}

	public LabelBase getAnnPractLicDateDesc() {
		if (AnnPractLicDateDesc == null) {
			AnnPractLicDateDesc = new LabelBase();
			AnnPractLicDateDesc.setText("Annual Practising Licence Date (effective until):");
			AnnPractLicDateDesc.setBounds(10, 10, 300, 20);
		}
		return AnnPractLicDateDesc;
	}

	public LabelBase getAnnPractLicDate() {
		if (AnnPractLicDate == null) {
			AnnPractLicDate = new LabelBase();
			AnnPractLicDate.setBounds(320, 10, 128, 20);
		}
		return AnnPractLicDate;
	}

	public LabelBase getMalpInsExpDateDesc() {
		if (MalpInsExpDateDesc == null) {
			MalpInsExpDateDesc = new LabelBase();
			MalpInsExpDateDesc.setText("Malpractice Insurance Expiry Date (effective until):");
			MalpInsExpDateDesc.setBounds(10, 35, 300, 20);
		}
		return MalpInsExpDateDesc;
	}

	public LabelBase getMalpInsExpDate() {
		if (MalpInsExpDate == null) {
			MalpInsExpDate = new LabelBase();
			MalpInsExpDate.setBounds(320, 35, 128, 20);
		}
		return MalpInsExpDate;
	}

	public LabelBase getAdmissionExpDateDesc() {
		if (AdmissionExpDateDesc == null) {
			AdmissionExpDateDesc = new LabelBase();
			AdmissionExpDateDesc.setText("Admission Expiry Date:");
			AdmissionExpDateDesc.setBounds(10, 60, 300, 20);
		}
		return AdmissionExpDateDesc;
	}

	public LabelBase getAdmissionExpDate() {
		if (AdmissionExpDate == null) {
			AdmissionExpDate = new LabelBase();
			AdmissionExpDate.setBounds(320, 60, 128, 20);
		}
		return AdmissionExpDate;
	}

	public LabelBase getOPPrivExpDateDesc() {
		if (OPPrivExpDateDesc == null) {
			OPPrivExpDateDesc = new LabelBase();
			OPPrivExpDateDesc.setText("OP Privilege Expiry Date:");
			OPPrivExpDateDesc.setBounds(10, 85, 300, 20);
		}
		return OPPrivExpDateDesc;
	}

	public LabelBase getOPPrivExpDate() {
		if (OPPrivExpDate == null) {
			OPPrivExpDate = new LabelBase();
			OPPrivExpDate.setBounds(320, 85, 128, 20);
		}
		return OPPrivExpDate;
	}

	private LabelBase getInsuranceCompanyDesc() {
		if (InsuranceCompanyDesc == null) {
			InsuranceCompanyDesc = new LabelBase();
			InsuranceCompanyDesc.setText("Insurance Company");
			InsuranceCompanyDesc.setBounds(10, 110, 300, 20);
		}
		return InsuranceCompanyDesc;
	}

	private LabelBase getInsuranceCompany() {
		if (InsuranceCompany == null) {
			InsuranceCompany = new LabelBase();
			InsuranceCompany.setBounds(320, 110, 150, 20);
		}
		return InsuranceCompany;
	}

	public LabelBase getDocSignFrameHeading() {
		if (DocSignHeading == null) {
			DocSignHeading = new LabelBase();
			DocSignHeading.setText("Doctor's Full / Initialing Signature");
			DocSignHeading.setStyleAttribute("font-weight", "bold");
			DocSignHeading.setBounds(460, 5, 340, 20);
		}
		return DocSignHeading;
	}

	public BasePanel getDocSignFrame() {
		if (DocSign == null) {
			DocSign = new BasePanel();
			DocSign.setHeading("Doctor's Full / Initialing Signature");
			DocSign.setBorders(true);
			DocSign.add(getDocSign());
			DocSign.setBounds(460, 30, 340, 260);
		}
		return DocSign;
	}

	public Image getDocSign() {
		if (img1 == null) {
			img1 = new Image();
			img1.setUrl(getServerPathNoImage());
			img1.addErrorHandler(new ErrorHandler() {
				@Override
				public void onError(ErrorEvent event) {
					img1.setUrl(getServerPathNoImage());
				}
			});
			img1.setPixelSize(340, 260);
		}
		return img1;
	}

	private LabelBase getSpecListDesc() {
		if (SpecListDesc == null) {
			SpecListDesc = new LabelBase();
			SpecListDesc.setText("Sub Sepciality List");
			SpecListDesc.setBounds(10, 300, 300, 20);
		}
		return SpecListDesc;
	}

	private JScrollPane getSpecListPanel() {
		if (docSpecListPanel == null) {
			docSpecListPanel = new JScrollPane();
			docSpecListPanel.setViewportView(getSpecListTable());
			docSpecListPanel.setBounds(10, 330, 790, 170);
		}
		return docSpecListPanel;
	}

	private TableList getSpecListTable() {
		if (SpecListTable == null) {
			SpecListTable = new TableList(getSepcListTableColumnNames(), getSepcListListTableColumnWidths());
/*
			, false, null, new GeneralGridCellRenderer() {
				@Override
				public Object render(TableData model, String property,
						ColumnData config, int rowIndex, int colIndex,
						ListStore<TableData> store, Grid<TableData> grid) {

					String columnValue = (String) model.get(property);
//					System.err.println("[colIndex]:"+colIndex+";[columnValue]:"+columnValue);
					if (colIndex == 2) {
						if ("-1".equals(columnValue)) {
							return "<input type='checkbox' name='isofficial' value='' checked>";
						} else {
							return "<input type='checkbox' name='isofficial' value=''>";
						}
					} else {
						return super.render(model, property, config, rowIndex, colIndex, store, grid);
					}
				}
			});
*/
			SpecListTable.setTableLength(getListWidth());
			SpecListTable.setColumnClass(2, new CheckBoxBase(), false);
		}
		return SpecListTable;
	}

	protected String[] getSepcListTableColumnNames() {
		return new String[] {"Specialty Code",
				"Specialty Name",//index=25
				"Offical"
		};
	}

	protected int[] getSepcListListTableColumnWidths() {
		return new int[] {150, 500, 50};
	}

	public DlgInstruction getInstructionDialog() {
		if (InsDialog == null) {
			InsDialog = new DlgInstruction(getMainFrame());
		}
		return InsDialog;
	}

	public DlgPBORemark getPBORemarkDialog() {
		if (PBORemarkDialog == null) {
			PBORemarkDialog = new DlgPBORemark(getMainFrame()) {
				@Override
				public void post() {
					// refresh doctor info
					doSearch();
					setVisible(false);
				}
			};
		}
		return PBORemarkDialog;
	}

	public void setTabbedPaneIndex(int index) {
		this.TabbedPaneIndex = index;
	}

	public int getTabbedPaneIndex() {
		return TabbedPaneIndex;
	}

	@Override
	protected boolean triggerSearchField() {
		if (getDrCode().isFocusOwner()) {
			getDrCode().checkTriggerBySearchKey();
		}
		return true;
	}
}