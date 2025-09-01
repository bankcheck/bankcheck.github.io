package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.widget.Component;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public abstract class DlgPBORemark extends DialogBase {
	private final static int m_frameWidth = 460;
	private final static int m_frameHeight = 170;

	private BasePanel basePanel = null;
	private LabelBase RemarkDesc = null;
	private TextString Remark = null;

	private String memDocCode = null;

	public DlgPBORemark(MainFrame owner) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("PBO Remark");
		setContentPane(getBasePanel());

		// change label
		getButtonById(OK).setText("Save", 'S');
	}

	public Component getDefaultFocusComponent() {
		return getRemark();
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String docCode) {
		memDocCode = docCode;

		getRemark().resetText();
		QueryUtil.executeMasterFetch(getUserInfo(),"DOCTOR_PBOREMARK",
				new String[] { memDocCode },
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getRemark().setText(mQueue.getContentField()[0]);
				}
			}
		});

		setVisible(true);
	}

	@Override
	public void doOkAction() {
		if (!getRemark().isEmpty() && getRemark().getText().length() > getRemark().getStringLength()) {
			Factory.getInstance().addErrorMessage("The field of remark has more than " + getRemark().getStringLength() + " characters.");
		} else { 
			QueryUtil.executeMasterAction(
					getUserInfo(), "DOCTOR_PBOREMARK", QueryUtil.ACTION_MODIFY,
					new String[] {
						memDocCode,
						getRemark().getText()
					},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					dispose();
					post();
				}
			});
		}
	}

	public abstract void post();

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getBasePanel() {
		if (basePanel == null) {
			basePanel = new BasePanel();
			basePanel.setBounds(5, 5, 421, 80);
			basePanel.add(getRemarkDesc(), null);
			basePanel.add(getRemark(), null);
			basePanel.setBorders(true);
		}
		return basePanel;
	}

	public LabelBase getRemarkDesc() {
		if (RemarkDesc == null) {
			RemarkDesc = new LabelBase();
			RemarkDesc.setText("Remark");
			RemarkDesc.setBounds(20, 25, 80, 20);
		}
		return RemarkDesc;
	}

	public TextString getRemark() {
		if (Remark == null) {
			Remark = new TextString(100);
			Remark.setBounds(110, 25, 298, 20);
		}
		return Remark;
	}
}