package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboACMCode;
import com.hkah.client.layout.combobox.ComboFreeBedCode;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.PanelUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTransaction;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public abstract class DlgTxUpdateBed extends DialogBase {

	private final static int m_frameWidth = 387;
	private final static int m_frameHeight = 230;

	private BasePanel updBedPanel = null;
	private LabelBase bedCodeDesc = null;
	private ComboFreeBedCode bedCode = null;
	private LabelBase acmCodeDesc = null;
	private ComboACMCode acmCode = null;
	private CheckBoxBase showFreeBed = null;
	private LabelBase showFreeBedDesc = null;
	private CheckBoxBase updSelectedEntry = null;
	private LabelBase updSelectedEntryDesc = null;
	private DlgConPceChange dlgConPceChange = null;

	private String memSlpNo = null;
	private String memINPID = null;
	private String memStnID = null;
	private String memAcmCode = null;
	private String memInpddate = null;
	private boolean acceptChange = false;

	public DlgTxUpdateBed(MainFrame owner) {
		super(owner, DialogBase.OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
    	setTitle("Update Slip Bed");
    	setContentPane(getUpdBedPanel());
    	setLocation(320, 300);

		// change label
		getButtonById(OK).setText("Update", 'U');
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String slpNo, String inpid, String stnid) {
		memSlpNo = slpNo;
		memINPID = inpid;
		memStnID = stnid;
		memAcmCode = null;
		acceptChange = false;

		setVisible(false);

		if (memStnID != null && memStnID.length() > 0) {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] { "SlipTx", "AcmCode", "StnID='" + memStnID + "'" },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						memAcmCode = mQueue.getContentField()[0];
					}
					showFormLoad();
				}
			});
		} else {
			showFormLoad();
		}
	}

	private void showFormLoad() {
		memInpddate = null;

		if (memINPID != null && memINPID.length() > 0) {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] { "Inpat", "Inpddate", "InPID='" + memINPID + "'" },
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						memInpddate = mQueue.getContentField()[0];
					}
					showDialogHelper();
				}
			});
		} else {
			showDialogHelper();
		}
	}

	private void showDialogHelper() {
		boolean showFreeBed = memInpddate != null && memInpddate.length() > 0;

		getShowFreeBed().setEnabled(showFreeBed);
		getUpdSelectedEntry().setEnabled(memStnID != null && memStnID.length() > 0);

		setVisible(true);

		getBedCode().setShowFreeBed(true);
		getShowFreeBed().setText(ConstantsVariable.MINUS_ONE_VALUE);
	}

	@Override
	public ComboFreeBedCode getDefaultFocusComponent() {
		return getBedCode();
	}

	@Override
	protected void doOkAction() {
		doOkPreAction(false);
	}

	private void doOkPreAction(boolean overrideYN) {
		if (!EMPTY_VALUE.equalsIgnoreCase(getBedCode().getText())
				   && !EMPTY_VALUE.equalsIgnoreCase(getAcmCode().getText())) {

			QueryUtil.executeMasterAction(getUserInfo(), "TXNBED_MODIFY", QueryUtil.ACTION_MODIFY,
					new String[] { 
									memSlpNo, memINPID, getBedCode().getText(), 
									getAcmCode().getText(), 
									memAcmCode,
									getUpdSelectedEntry().isSelected() ? YES_VALUE : NO_VALUE, 
									overrideYN ? YES_VALUE : NO_VALUE, 
									memStnID,
									acceptChange ? YES_VALUE : NO_VALUE, 
									CommonUtil.getComputerName(), 
									getUserInfo().getUserID() 
					},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						if (getUpdSelectedEntry().isSelected() && !getAcmCode().getText().equals(memAcmCode) &&
								!acceptChange) {
							getDlgConPceChange().showDialog(memSlpNo, 
															ConstantsTransaction.SLIP_TYPE_INPATIENT, 
															memAcmCode, EMPTY_VALUE, 
															getAcmCode().getText(), 
															memStnID, null);
						} else {
							doOkPostAction();
						}
					} else if ("-100".equals(mQueue.getReturnCode())) {
						MessageBoxBase.confirm(ConstantsMessage.MSG_PBA_SYSTEM, mQueue.getReturnMsg(), new Listener<MessageBoxEvent>() {
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									doOkPreAction(true);
								}
							}
						});
					} else {
						Factory.getInstance().addErrorMessage(mQueue);
					}
				}
			});
		}
	}

	private void doOkPostAction() {
		dispose();
		// call parent class
		post(getBedCode().getText());
	}

	@Override
	public void setVisible(boolean visible) {
		super.setVisible(visible);
		PanelUtil.resetAllFields(getUpdBedPanel());
	}

	public abstract void post(String bedCode);

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getUpdBedPanel() {
		if (updBedPanel == null) {
			updBedPanel = new BasePanel();
			updBedPanel.setLocation(5, 5);
			updBedPanel.setSize(360, 180);
			updBedPanel.add(getBedCodeDesc(), null);
			updBedPanel.add(getBedCode(), null);
			updBedPanel.add(getAcmCodeDesc(), null);
			updBedPanel.add(getAcmCode(), null);
			updBedPanel.add(getShowFreeBed(), null);
			updBedPanel.add(getShowFreeBedDesc(), null);
			updBedPanel.add(getUpdSelectedEntry(), null);
			updBedPanel.add(getUpdSelectedEntryDesc(), null);
		}
		return updBedPanel;
	}

	public LabelBase getBedCodeDesc() {
		if (bedCodeDesc == null) {
			bedCodeDesc = new LabelBase();
			bedCodeDesc.setText("Bed Code");
			bedCodeDesc.setBounds(30, 30, 80, 20);
		}
		return bedCodeDesc;
	}

	public ComboFreeBedCode getBedCode() {
		if (bedCode == null) {
			bedCode = new ComboFreeBedCode() {
				String [] rawText = null;

				@Override
				public void onSelected() {
					rawText = getRawTextArray();

					if (rawText != null && rawText.length > 1) {
						getAcmCode().setText(rawText[2]);
					} else {
						getAcmCode().resetText();
					}
				}

				@Override
				public void onBlur() {
					super.onBlur();
					onSelected();
				}

				@Override
				protected void resetContentPost() {
					if (getStore().getCount() > 0) {
						setSelectedIndex(0);
					}
					onSelected();
				}
			};
			bedCode.setBounds(120, 30, 180, 20);
		}
		return bedCode;
	}

	public LabelBase getAcmCodeDesc() {
		if (acmCodeDesc == null) {
			acmCodeDesc = new LabelBase();
			acmCodeDesc.setText("Acm Code");
			acmCodeDesc.setBounds(30, 60, 80, 20);
		}
		return acmCodeDesc;
	}

	public ComboACMCode getAcmCode() {
		if (acmCode == null) {
			acmCode = new ComboACMCode();
			acmCode.setBounds(120, 60, 180, 20);
		}
		return acmCode;
	}

	public CheckBoxBase getShowFreeBed() {
		if (showFreeBed == null) {
			showFreeBed = new CheckBoxBase();
			showFreeBed.setBounds(100, 90, 20, 20);
			showFreeBed.addListener(Events.OnClick, new Listener<FieldEvent>() {
				@Override
				public void handleEvent(FieldEvent be) {
					getBedCode().setShowFreeBed(((CheckBoxBase)be.getField()).getValue());
				}
			});
		}
		return showFreeBed;
	}

	public LabelBase getShowFreeBedDesc() {
		if (showFreeBedDesc == null) {
			showFreeBedDesc = new LabelBase();
			showFreeBedDesc.setText("Only Show Free Bed");
			showFreeBedDesc.setBounds(120, 90, 160, 20);
		}
		return showFreeBedDesc;
	}

	public CheckBoxBase getUpdSelectedEntry() {
		if (updSelectedEntry == null) {
			updSelectedEntry = new CheckBoxBase();
			updSelectedEntry.setBounds(100, 120, 20, 20);
		}
		return updSelectedEntry;
	}

	public LabelBase getUpdSelectedEntryDesc() {
		if (updSelectedEntryDesc == null) {
			updSelectedEntryDesc = new LabelBase();
			updSelectedEntryDesc.setText("Update Selected Entry Only");
			updSelectedEntryDesc.setBounds(120, 120, 160, 20);
		}
		return updSelectedEntryDesc;
	}

	private DlgConPceChange getDlgConPceChange() {
		if (dlgConPceChange == null) {
			dlgConPceChange = new DlgConPceChange(getMainFrame()) {
				@Override
				protected void doOkAction() {
					super.doOkAction();
				}
				
				@Override
				protected void doCancelAction() {
					super.doCancelAction();
					doOkPostAction();
				}
				
				@Override
				public void post() {
					acceptChange = true;
					doOkPreAction(false);
				}
			};
		}
		return dlgConPceChange;
	}
}