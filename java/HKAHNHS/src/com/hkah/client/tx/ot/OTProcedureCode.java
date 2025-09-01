package com.hkah.client.tx.ot;

import com.extjs.gxt.ui.client.widget.LayoutContainer;
import com.extjs.gxt.ui.client.widget.layout.FlowLayout;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboProType;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class OTProcedureCode extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		return ConstantsTx.OTPROCEDURECODE_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.OTPROCEDURECODE_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			" ",
			"Procedure Code",
			"Short Form",
			"Description",
			"Type",
			"Package",
			"Surcharge",
			"Duration",
			"Interval",
			"Active",
			"otpid",
			"isupd"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				10,
				100,
				80,
				150,
				50,
				70,
				70,
				70,
				70,
				55,
				0,
				0
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private BasePanel leftPanel = null;
	private LabelBase ShowActiveDesc = null;
	private CheckBoxBase ShowActive = null;

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel editPanel = null;
	private LabelBase ProCodeDesc = null;
	private TextString ProCode = null;
	private LabelBase ShortFormDesc = null;
	private TextString ShortForm = null;
	private LabelBase TypeDesc = null;
	private ComboProType Type = null;
	private LabelBase DescrDesc = null;
	private TextString Descr = null;
	private LabelBase PkgCodeDesc = null;
	private TextString PkgCode = null;
	private LabelBase SurchargeDesc = null;
	private TextString Surcharge = null;
	private LabelBase DurationDesc = null;
	private TextNum Duration = null;
	private LabelBase IntervalDesc = null;
	private TextString Interval = null;
	private LabelBase ActiveDesc = null;
	private CheckBoxBase Active = null;

	/**
	 * This method initializes
	 *
	 */
	public OTProcedureCode() {
		super();
		getListTable().setBounds(10, 20, 780, 310);
//		getJScrollPane().setBounds(10, 50, 780, 500);
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		enableButton(null);
		searchAction();
		getListTable().setEnabled(true);
		getListTable().removeAllRow();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return null;//getShowActive();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {
		getShowActive().setEnabled(false);
		getProCode().setEnabled(true);
		getShortForm().setEnabled(true);
		getDescr().setEnabled(true);
		getType().setEnabled(true);
		getPkgCode().setEnabled(true);
		getSurcharge().setEnabled(true);
		getDuration().setEnabled(true);
		getInterval().setEnabled(true);
		getActive().setEnabled(true);
		getProCode().requestFocus();
	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
		getShowActive().setEnabled(false);
		getProCode().setEnabled(true);
		getShortForm().setEnabled(true);
		getDescr().setEnabled(true);
		getType().setEnabled(true);
		getPkgCode().setEnabled(true);
		getSurcharge().setEnabled(true);
		getDuration().setEnabled(true);
		getInterval().setEnabled(true);
		getActive().setEnabled(true);
		getProCode().requestFocus();
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
				getShowActive().isSelected()?"-1":"0"
		};
	}

	/* >>> ~16.1~ Set Fetch Input Parameters ============================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		String[] selectedContent = getListSelectedRow();
		return new String[] {
				selectedContent[10]
		};
	}

	/* >>> ~16.2~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
		int index = 0;
		index++;
		getProCode().setText(outParam[index++]);
		getShortForm().setText(outParam[index++]);
		getDescr().setText(outParam[index++]);
		getType().setSelectedIndex(outParam[index++]);
		getPkgCode().setText(outParam[index++]);
		getSurcharge().setText(outParam[index++]);
		getDuration().setText(outParam[index++]);
		getInterval().setText(outParam[index++]);
		getActive().setSelected("Y".equals(outParam[index++]));
	}

	/* >>> ~22~ Set Action Input Parameters per table ===================== <<< */
	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		return new String[] {
				selectedContent[10],
				getProCode().getText(),
				getShortForm().getText(),
				getDescr().getText(),
				getType().getText(),
				getPkgCode().getText(),
				getSurcharge().getText(),
				getDuration().getText(),
				getInterval().getText(),
				getActive().isSelected()?"-1":"0",
				getUserInfo().getSiteCode(),
				selectedContent[11]
			};
	}

	/* >>> ~23~ Set Action Validation per table =========================== <<< */
	@Override
	protected boolean actionValidation(String[] selectedContent) {
		if (selectedContent[1] == null || selectedContent[1].trim().length() == 0) {
			Factory.getInstance().addErrorMessage("Procedure Code is mandatory.");
			return false;
		}
		if (selectedContent[2] == null || selectedContent[2].trim().length() == 0) {
			Factory.getInstance().addErrorMessage("Short From is mandatory.");
			return false;
		}
		if (selectedContent[3] == null || selectedContent[3].trim().length() == 0) {
			Factory.getInstance().addErrorMessage("Description Code is mandatory.");
			return false;
		}
		if (selectedContent[4] == null || selectedContent[4].trim().length() == 0) {
			Factory.getInstance().addErrorMessage("Type is mandatory.");
			return false;
		}
//		if (selectedContent[5].trim().length() > 0) {
//			MessageQueueCallBack callBack = new MessageQueueCallBack() {
//				@Override
//				public void onPostSuccess(MessageQueue mQueue) {
//					// TODO Auto-generated method stub
//				}
//			};
//			QueryUtil.executeMasterFetch(getUserInfo(), "PACKAGE", new String[] {selectedContent[5].trim().toUpperCase()}, callBack);
//			MessageQueue mQueue = callBack.getMessageQueue();
//			if (!mQueue.success()) {
//				Factory.getInstance().addErrorMessage("Package Code does not exist.");
//				return false;
//			}
//		}
		return true;
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void enableButton(String mode) {
		super.enableButton(mode);
		getShowActive().setSelected(true);
		getShowActive().setEnabled(true);
		getAppendButton().setEnabled(!isDisableFunction("TB_INSERT", "mntOTProc"));
		getModifyButton().setEnabled(!isDisableFunction("TB_MODIFY", "mntOTProc"));
		getDeleteButton().setEnabled(!isDisableFunction("TB_DELETE", "mntOTProc"));

		if (isAppend() || isModify() || isDelete()) {
			getAppendButton().setEnabled(false);
			getModifyButton().setEnabled(false);
			getDeleteButton().setEnabled(false);
			getSearchButton().setEnabled(false);
			getClearButton().setEnabled(true);
		} else {
			getRefreshButton().setEnabled(false);
			getSearchButton().setEnabled(true);
			getClearButton().setEnabled(false);
		}

		if (getListTable().getRowCount() == 0) {
			getModifyButton().setEnabled(false);
			getDeleteButton().setEnabled(false);
		}
	}

	@Override
	protected void setAllRightFieldsEnabled(boolean enable) {
		PanelUtil.setAllFieldsEditable(getEditPanel(), enable);
	}
/*
	@Override
	protected void listTablePostSaveTable(boolean success) {
		if (success) {
			if (isDelete()) {
				Factory.getInstance().addInformationMessage("Record deleted.");
			}
			setActionType(null);
			enableButton();
			searchAction();
		} else {
			if (isDelete()) {
				Factory.getInstance().addErrorMessage("Record delete fail.");
			}
		}
	}
*/
	@Override
	public void saveAction() {
		saveAction(false);
		enableButton(null);
	}

	@Override
	protected void savePostAction() {
		setActionType(null);
		enableButton(null);
		searchAction();
	}

	@Override
	public void appendAction() {
		super.appendAction();
		getProCode().reset();
		getShortForm().reset();
		getDescr().reset();
		getListTable().setValueAt(getType().getDisplayText(), getListTable().getSelectedRow(), 4);
		getPkgCode().reset();
		getSurcharge().reset();
		getListTable().setValueAt("0", getListTable().getSelectedRow(), 7);
		getInterval().reset();
		getActive().setSelected(true);
		getListTable().setValueAt("Y", getListTable().getSelectedRow(), 9);
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected LayoutContainer getBodyPanel() {
		LayoutContainer panel = new LayoutContainer();
		panel.setBorders(false);
		panel.setLayout(new FlowLayout(10));
		panel.setStyleAttribute("padding-left","10px");
		panel.add(getLeftPanel());
		panel.add(getEditPanel());
		panel.add(getListTable());
		return panel;
	}

	@Override
	protected BasePanel getLeftPanel() {
		if (leftPanel == null) {
			leftPanel = new BasePanel();
			leftPanel.add(getShowActiveDesc());
			leftPanel.add(getShowActive());
			leftPanel.setBounds(10, 0, 780, 20);
		}
		return leftPanel;
	}

	@Override
	protected ColumnLayout getSearchPanel() {
		return null;
	}

	@Override
	protected LayoutContainer getActionPanel() {
		return null;
	}

	public BasePanel getEditPanel() {
		if (editPanel == null) {
			editPanel = new BasePanel();
			editPanel.setBorders(true);
			editPanel.add(getEditPanel());
			editPanel.add(getProCodeDesc(), null);
			editPanel.add(getProCode(), null);
			editPanel.add(getShortFormDesc(), null);
			editPanel.add(getShortForm(), null);
			editPanel.add(getTypeDesc(), null);
			editPanel.add(getType(), null);
			editPanel.add(getDescrDesc(), null);
			editPanel.add(getDescr(), null);
			editPanel.add(getPkgCodeDesc(), null);
			editPanel.add(getPkgCode(), null);
			editPanel.add(getSurchargeDesc(), null);
			editPanel.add(getSurcharge(), null);
			editPanel.add(getDurationDesc(), null);
			editPanel.add(getDuration(), null);
			editPanel.add(getIntervalDesc(), null);
			editPanel.add(getInterval(), null);
			editPanel.add(getActiveDesc(), null);
			editPanel.add(getActive(), null);
			editPanel.setBounds(10, 10, 780, 175);
		}
		return editPanel;
	}

	private LabelBase getShowActiveDesc() {
		if (ShowActiveDesc == null) {
			ShowActiveDesc = new LabelBase();
			ShowActiveDesc.setText("Show Active");
			ShowActiveDesc.setBounds(5, 5, 70, 20);
		}
		return ShowActiveDesc;
	}

	private CheckBoxBase getShowActive() {
		if (ShowActive == null) {
			ShowActive = new CheckBoxBase() {
				@Override
				public void onClick() {
					searchAction();
				}
			};
			ShowActive.setSelected(true);
			ShowActive.setBounds(85, 5, 18, 20);
		 }
		return ShowActive;
	}

	private LabelBase getProCodeDesc() {
		if (ProCodeDesc == null) {
			ProCodeDesc = new LabelBase();
			ProCodeDesc.setText("Procedure Code");
			ProCodeDesc.setBounds(30, 10, 95, 20);
		}
		return ProCodeDesc;
	}

	private TextString getProCode() {
		if (ProCode == null) {
			ProCode = new TextString(20, false) {
				@Override
				public void onReleased() {
					getListTable().setValueAt(getProCode().getText(), getListTable().getSelectedRow(), 1);
				};
			};
			ProCode.setBounds(135, 10, 155, 20);
		}
		return ProCode;
	}

	private LabelBase getShortFormDesc() {
		if (ShortFormDesc == null) {
			ShortFormDesc = new LabelBase();
			ShortFormDesc.setText("Short Form");
			ShortFormDesc.setBounds(340, 10, 90, 20);
		}
		return ShortFormDesc;
	}

	private TextString getShortForm() {
		if (ShortForm == null) {
			ShortForm = new TextString(15, false) {
				@Override
				public void onReleased() {
					getListTable().setValueAt(getShortForm().getText(), getListTable().getSelectedRow(), 2);
				};
			};
			ShortForm.setBounds(430, 10, 155, 20);
		 }
		return ShortForm;
	}

	private LabelBase getTypeDesc() {
		if (TypeDesc == null) {
			TypeDesc = new LabelBase();
			TypeDesc.setText("Type");
			TypeDesc.setBounds(30, 40, 95, 20);
		}
		return TypeDesc;
	}

	public ComboProType getType() {
		if (Type == null) {
			Type = new ComboProType() {
				@Override
				public void onSelected() {
					getListTable().setValueAt(getType().getDisplayText().toUpperCase(), getListTable().getSelectedRow(), 4);
				};
			};
			Type.setBounds(135, 40, 155, 20);
		 }
		return Type;
	}

	private LabelBase getDescrDesc() {
		if (DescrDesc == null) {
			DescrDesc = new LabelBase();
			DescrDesc.setText("Description");
			DescrDesc.setBounds(340, 40, 90, 20);
		}
		return DescrDesc;
	}

	private TextString getDescr() {
		if (Descr == null) {
			Descr = new TextString(100, false) {
				@Override
				public void onReleased() {
					getListTable().setValueAt(getDescr().getText(), getListTable().getSelectedRow(), 3);
				};
			};

			Descr.setBounds(430, 40, 320, 20);
		 }
		return Descr;
	}

	private LabelBase getPkgCodeDesc() {
		if (PkgCodeDesc == null) {
			PkgCodeDesc = new LabelBase();
			PkgCodeDesc.setText("Package Code");
			PkgCodeDesc.setBounds(30, 70, 95, 20);
		}
		return PkgCodeDesc;
	}

	private TextString getPkgCode() {
		if (PkgCode == null) {
			PkgCode = new TextString() {
				@Override
				public void onReleased() {
					setCurrentTable(5, PkgCode.getText().toUpperCase());
				}

				@Override
				public void onBlur() {
					if (PkgCode.getText().trim().length()>0) {
						QueryUtil.executeMasterFetch(getUserInfo(), "PACKAGE", new String[] {PkgCode.getText().toUpperCase()},
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (!mQueue.success()) {
									Factory.getInstance().addErrorMessage("Package Code does not exist.", PkgCode);
									PkgCode.resetText();
									setCurrentTable(5, EMPTY_VALUE);
								}
							}
						});
					}
				};
			};
			PkgCode.setBounds(135, 71, 155, 20);
		 }
		return PkgCode;
	}

	private LabelBase getSurchargeDesc() {
		if (SurchargeDesc == null) {
			SurchargeDesc = new LabelBase();
			SurchargeDesc.setText("Surcharge");
			SurchargeDesc.setBounds(340, 71, 90, 20);
		}
		return SurchargeDesc;
	}

	private TextString getSurcharge() {
		if (Surcharge == null) {
			Surcharge = new TextString(getListTable(), 6);
			Surcharge.setBounds(430, 71, 155, 20);
		 }
		return Surcharge;
	}

	private LabelBase getDurationDesc() {
		if (DurationDesc == null) {
			DurationDesc = new LabelBase();
			DurationDesc.setText("Duration");
			DurationDesc.setBounds(30, 100, 95, 20);
		}
		return DurationDesc;
	}

	private TextNum getDuration() {
		if (Duration == null) {
			Duration = new TextNum(5) {
				@Override
				public void onReleased() {
					getListTable().setValueAt(getDuration().getText(), getListTable().getSelectedRow(), 7);
				};
			};
			Duration.setBounds(135, 100, 155, 20);
		 }
		return Duration;
	}

	private LabelBase getIntervalDesc() {
		if (IntervalDesc == null) {
			IntervalDesc = new LabelBase();
			IntervalDesc.setText("Interval");
			IntervalDesc.setBounds(340, 100, 95, 20);
		}
		return IntervalDesc;
	}

	private TextString getInterval() {
		if (Interval == null) {
			Interval = new TextString(getListTable(), 8);
			Interval.setBounds(430, 100, 155, 20);
		 }
		return Interval;
	}

	private LabelBase getActiveDesc() {
		if (ActiveDesc == null) {
			ActiveDesc = new LabelBase();
			ActiveDesc.setText("Active");
			ActiveDesc.setBounds(30, 130, 95, 20);
		}
		return ActiveDesc;
	}

	private CheckBoxBase getActive() {
		if (Active == null) {
			Active = new CheckBoxBase(getListTable(), 9);
			Active.setBounds(130, 130, 20, 20);
		}
		return Active;
	}
}