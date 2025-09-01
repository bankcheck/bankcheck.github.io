package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgUpdateRegID extends DialogBase {
	private final static int m_frameWidth = 400;
	private final static int m_frameHeight = 150;

	private BasePanel UpdRegIDPanel = null;
	private BasePanel UpdRegIDParaPanel = null;
	private LabelBase UpdRegIDPatNoDesc = null;
	private TextPatientNoSearch UpdRegIDPatNo = null;

	public DlgUpdateRegID(MainFrame owner) {
		super(owner, DialogBase.OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Update In Patient Registration ID");
		setContentPane(getUpdRegIDPanel());
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog() {
		getUpdRegIDPatNo().resetText();
		setVisible(true);
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	public TextPatientNoSearch getDefaultFocusComponent() {
		return getUpdRegIDPatNo();
	}

	@Override
	protected void doOkAction() {
		QueryUtil.executeMasterBrowse(getUserInfo(),ConstantsTx.LOOKUP_TXCODE,
				new String[] {"patient", "patno, regid_c", "patno = '"+ getUpdRegIDPatNo().getText() + "'"},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success() && mQueue.getContentField()[0].length() > 0) {
					final String tmpPatNo = mQueue.getContentField()[0];
					final String tmpRegID_C = mQueue.getContentField()[1];
					QueryUtil.executeMasterBrowse(getUserInfo(),ConstantsTx.LOOKUP_TXCODE,
							new String[] {"reg", "max(regid)", "regtype = 'I' and patno = '" + tmpPatNo + "'"},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success() && mQueue.getContentField()[0].length()>0) {
								if (!tmpRegID_C.equals(mQueue.getContentField()[0])) {
									String tmpRegID_C2;
									if (tmpRegID_C == null || tmpRegID_C.equals("")) {
										tmpRegID_C2 = "null";
									} else {
										tmpRegID_C2 = tmpRegID_C;
									}
									QueryUtil.executeMasterAction(getUserInfo(),"UPDATE",QueryUtil.ACTION_MODIFY,
											new String[] {"patient", "regid_l=" + tmpRegID_C2 + ",regid_c=" + mQueue.getContentField()[0] + ", patvcnt = patvcnt + 1 ", "patno = '"+ getUpdRegIDPatNo().getText() + "'"},
											new MessageQueueCallBack() {
										@Override
										public void onPostSuccess(MessageQueue mQueue) {
											if (mQueue.success()) {
												Factory.getInstance().addInformationMessage("Update Sucessful!");
												dispose();
											}
										}
									});
								} else {
									Factory.getInstance().addErrorMessage("No need to Update");
								}
							} else {
								Factory.getInstance().addErrorMessage("This Patient haven't reg as Inpat", getUpdRegIDPatNo());
							}
						}
					});
				} else {
					Factory.getInstance().addErrorMessage("Invalid Patient Number", getUpdRegIDPatNo());
					getUpdRegIDPatNo().resetText();
				}
			}
		});
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getUpdRegIDPanel() {
		if (UpdRegIDPanel == null) {
			UpdRegIDPanel = new BasePanel();
			UpdRegIDPanel.add(getUpdRegIDParaPanel(), null);
			UpdRegIDPanel.setBounds(5, 5, 362, 60);
		}
		return UpdRegIDPanel;
	}

	public BasePanel getUpdRegIDParaPanel() {
		if (UpdRegIDParaPanel == null) {
			UpdRegIDParaPanel = new BasePanel();
			UpdRegIDParaPanel.add(getUpdRegIDPatNoDesc(), null);
			UpdRegIDParaPanel.add(getUpdRegIDPatNo(), null);
			UpdRegIDParaPanel.setBounds(0, 0, 360, 60);
		}
		return UpdRegIDParaPanel;
	}

	private LabelBase getUpdRegIDPatNoDesc() {
		if (UpdRegIDPatNoDesc == null) {
			UpdRegIDPatNoDesc = new LabelBase();
			UpdRegIDPatNoDesc.setBounds(25, 15, 100, 20);
			UpdRegIDPatNoDesc.setText("Patient Number");
			UpdRegIDPatNoDesc.setOptionalLabel();
		}
		return UpdRegIDPatNoDesc;
	}

	public TextPatientNoSearch getUpdRegIDPatNo() {
		if (UpdRegIDPatNo == null) {
			UpdRegIDPatNo = new TextPatientNoSearch();
			UpdRegIDPatNo.setBounds(150, 15, 150, 20);
			UpdRegIDPatNo.setShowAllAlert(false);
		}
		return UpdRegIDPatNo;
	}
}