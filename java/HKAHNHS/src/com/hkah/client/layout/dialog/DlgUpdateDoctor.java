package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.combobox.ComboDoctor;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextDoctorSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public abstract class DlgUpdateDoctor extends DialogBase {

	private final static int m_frameWidth = 415;
	private final static int m_frameHeight = 200;

	private BasePanel UpdDrPanel = null;
	private BasePanel UpdDrParaPanel = null;
	private LabelBase UpdateDoctorCodeDesc = null;
	private ComboDoctor UpdateDoctorCode = null;
	private TextDoctorSearch UpdateDoctorCodeSearch = null;
	private LabelBase UpdateDoctorNameDesc = null;
	private TextReadOnly UpdateDoctorName = null;

	private String memSlpNo = null;
	private String memPatNo = null;

	public DlgUpdateDoctor(MainFrame owner) {
		super(owner, DialogBase.OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Update Doctor Code");
		setContentPane(getUpdDrPanel());
		setLocation(320, 300);

		// change label
		getButtonById(OK).setText("Update", 'U');
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String slpNo, String patNo, String docCode) {
		memSlpNo = slpNo;
		memPatNo = patNo;

		setVisible(true);

		PanelUtil.resetAllFields(getUpdDrPanel());
//		if (docCode != null) {
//			getUpdateDoctorCode().setText(docCode);
//			updateDoctorName();
//		}
	}

	@Override
	public ComboDoctor getDefaultFocusComponent() {
		return getUpdateDoctorCode();
	}

	@Override
	protected void doOkAction() {
		if (getUpdateDoctorCode().isEmpty()) {
			Factory.getInstance().addErrorMessage("Empty Doctor Code.", getUpdateDoctorCode());
			return;
		}

		QueryUtil.executeMasterFetch(getUserInfo(), "DOCTOR_ACTIVE",
				new String[] {
						getUpdateDoctorCode().getText().trim()
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					QueryUtil.executeMasterAction(
							getUserInfo(), "TXNDOCTOR_MODIFY", QueryUtil.ACTION_MODIFY,
							new String[] {
								memSlpNo,
								memPatNo,
								getUpdateDoctorCode().getText(),
								Factory.getInstance().getUserInfo().getUserID()
							},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							dispose();
							post(getUpdateDoctorCode().getText(), getUpdateDoctorName().getText());
						}
					});
				} else {
					QueryUtil.executeMasterFetch(getUserInfo(), "DOCTOR",
							new String[] {
									getUpdateDoctorCode().getText().trim()
							},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								Factory.getInstance().addErrorMessage("Inactive Doctor.<br/> Admission Expiry Date: "+
										mQueue.getContentField()[21], getUpdateDoctorCode());
							} else {
								Factory.getInstance().addErrorMessage("Inactive Doctor.<br/> Cannot get Admission Expiry Date", getUpdateDoctorCode());
							}
						}
					});
				}
			}
		});
	}

	public abstract void post(String docCode, String docName);

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	private BasePanel getUpdDrPanel() {
		if (UpdDrPanel == null) {
			UpdDrPanel = new BasePanel();
			UpdDrPanel.add(getUpdDrParaPanel(), null);
			UpdDrPanel.setBounds(5, 5, 365, 205);
		}
		return UpdDrPanel;
	}

	private BasePanel getUpdDrParaPanel() {
		if (UpdDrParaPanel == null) {
			UpdDrParaPanel = new BasePanel();
			UpdDrParaPanel.setHeading("Doctor");
			UpdDrParaPanel.add(getUpdateDoctorCodeDesc(), null);
			UpdDrParaPanel.add(getUpdateDoctorCode(), null);
			UpdDrParaPanel.add(getUpdateDoctorCodeSearch(), null);
			UpdDrParaPanel.add(getUpdateDoctorNameDesc(), null);
			UpdDrParaPanel.add(getUpdateDoctorName(), null);
			UpdDrParaPanel.setBounds(5, 5, 367, 92);
		}
		return UpdDrParaPanel;
	}

	private LabelBase getUpdateDoctorCodeDesc() {
		if (UpdateDoctorCodeDesc == null) {
			UpdateDoctorCodeDesc = new LabelBase();
			UpdateDoctorCodeDesc.setBounds(27, 20, 75, 20);
			UpdateDoctorCodeDesc.setText("Doctor Code");
			UpdateDoctorCodeDesc.setOptionalLabel();
		}
		return UpdateDoctorCodeDesc;
	}

	private ComboDoctor getUpdateDoctorCode() {
		if (UpdateDoctorCode == null) {
			UpdateDoctorCode = new ComboDoctor("OrderByName") {
				@Override
				public void onSearchTriggerClick(ComponentEvent ce) {
					getUpdateDoctorCodeSearch().setValue(this.getText());
					getUpdateDoctorCodeSearch().showSearchPanel();
				}

				@Override
				protected void setTextPanel(ModelData modelData) {
					if (modelData != null) {
						getUpdateDoctorName().setText(modelData.get(ONE_VALUE).toString());
					} else {
						getUpdateDoctorName().resetText();
					}
				}
			};
			UpdateDoctorCode.setShowTextSearhPanel(true);
			UpdateDoctorCode.setBounds(107, 20, 233, 20);
		}
		return UpdateDoctorCode;
	}

	private TextDoctorSearch getUpdateDoctorCodeSearch() {
		if (UpdateDoctorCodeSearch == null) {
			UpdateDoctorCodeSearch = new TextDoctorSearch() {
				@Override
				public void searchAfterAcceptAction() {
					getUpdateDoctorCode().setText(getValue());
				}
			};
			UpdateDoctorCodeSearch.setBounds(107, 20, 233, 20);
			UpdateDoctorCodeSearch.setVisible(false);
		}
		return UpdateDoctorCodeSearch;
	}

	private LabelBase getUpdateDoctorNameDesc() {
		if (UpdateDoctorNameDesc == null) {
			UpdateDoctorNameDesc = new LabelBase();
			UpdateDoctorNameDesc.setBounds(26, 51, 75, 20);
			UpdateDoctorNameDesc.setText("Doctor Name");
			UpdateDoctorNameDesc.setOptionalLabel();
		}
		return UpdateDoctorNameDesc;
	}

	private TextReadOnly getUpdateDoctorName() {
		if (UpdateDoctorName == null) {
			UpdateDoctorName = new TextReadOnly();
			UpdateDoctorName.setBounds(107, 53, 233, 20);
		}
		return UpdateDoctorName;
	}
}