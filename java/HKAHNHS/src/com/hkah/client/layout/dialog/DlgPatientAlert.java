/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.event.BaseEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.Listener;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextAreaBase;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTableColumn;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;
import com.hkah.shared.model.UserInfo;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class DlgPatientAlert extends DialogBase implements ConstantsTableColumn {

    private final static int m_frameWidth = 450;
    private final static int m_frameHeight = 280;

	private BasePanel dialogTopPanel = null;
	private TabbedPaneBase alertTabbedPanel = null;
	private TableList specListTable = null;
	private JScrollPane specScrollPane = null;
	private BasePanel remarkPanel = null;
	private LabelBase AJLabel_Remark = null;
	private TextReadOnly AJText_Remark = null;
	private LabelBase AJLabel_AdditionalRemark = null;
	private TextAreaBase TextArea_AdditionalRemark = null;

	private String memPatNo = null;
	private boolean isRemarkLoaded = false;

	public DlgPatientAlert(MainFrame owner) {
        super(owner, OK, m_frameWidth, m_frameHeight);
        initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Patient Alert");

		setContentPane(getDialogTopPanel());
		addListener(Events.Hide, new Listener<BaseEvent>() {
			@Override
			public void handleEvent(BaseEvent be) {
				dlgClose();
			}
		});
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void doOkAction() {
		post(true);
		super.doOkAction();
	}

	protected void post(boolean success) {
		// for child class implement
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String patno) {
		setVisible(false);
		memPatNo = patno;
		isRemarkLoaded = false;

		getAlertTabbedPanel().setSelectedIndexWithoutStateChange(0);
		getAJText_Remark().resetText();
		getTextArea_AdditionalRemark().resetText();

		UserInfo userInfo = Factory.getInstance().getUserInfo();
		String userId = userInfo == null ? "" : userInfo.getUserID();

		QueryUtil.executeMasterBrowse(userInfo, "PATIENT_ALERT",
				new String[] { patno, userId },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getSpecListTable().setListTableContent(mQueue);
					setVisible(true);
				} else {
					post(false);
				}
			}
		});
	}

	protected void dlgClose() {
		post(true);
	};

	private void showPatientRemark() {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.PATIENT_TXCODE,
				new String[] { memPatNo },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getAJText_Remark().setText(mQueue.getContentField()[PATIENT_REMARK]);
					getTextArea_AdditionalRemark().setText(mQueue.getContentField()[PATIENT_ADDITIONAL_REMARK]);
				}
			}
		});
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getDialogTopPanel() {
		if (dialogTopPanel == null) {
			dialogTopPanel = new BasePanel();
			dialogTopPanel.setBounds(0, 0, 420, 190);
			dialogTopPanel.add(getAlertTabbedPanel(), null);
		}
		return dialogTopPanel;
	}

	public TabbedPaneBase getAlertTabbedPanel() {
		if (alertTabbedPanel == null) {
			alertTabbedPanel = new TabbedPaneBase() {
				@Override
				public void onStateChange() {
					if (getSelectedIndex() == 1 && !isRemarkLoaded) {
						showPatientRemark();
						isRemarkLoaded = true;
					}
				}
			};
			alertTabbedPanel.setBounds(0, 0,420, 195);
			alertTabbedPanel.addTab("<u>A</u>lert", getSpecScrollPane());
			alertTabbedPanel.addTab("<u>R</u>emark", getRemarkPanel());
		}
		return alertTabbedPanel;
	}

	public JScrollPane getSpecScrollPane() {
		if (specScrollPane == null) {
			specScrollPane = new JScrollPane();
			specScrollPane.setBounds(5, 5, 415, 166);
			specScrollPane.setViewportView(getSpecListTable());
		}
		return specScrollPane;
	}

	public TableList getSpecListTable() {
		if (specListTable == null) {
			specListTable = new TableList(getSpecColumnNames(), getSpecColumnWidths());
		}
		return specListTable;
	}

	private int[] getSpecColumnWidths() {
		return new int[] { 50, 355, 0, 0, 0 };
	}

	private String[] getSpecColumnNames() {
		return new String[] { "Alert Code", "Alert Description", "", "", "" };
	}

	public BasePanel getRemarkPanel() {
		if (remarkPanel == null) {
			remarkPanel = new BasePanel();
			remarkPanel.setBounds(0, 0, 345, 185);
			remarkPanel.add(getAJLabel_Remark(), null);
			remarkPanel.add(getAJText_Remark(), null);
			remarkPanel.add(getAJLabel_AdditionalRemark(), null);
			remarkPanel.add(getTextArea_AdditionalRemark(), null);
		}
		return remarkPanel;
	}

	public LabelBase getAJLabel_Remark() {
		if (AJLabel_Remark == null) {
			AJLabel_Remark = new LabelBase();
			AJLabel_Remark.setText("Remark");
			AJLabel_Remark.setBounds(5, 5, 60, 20);
		}
		return AJLabel_Remark;
	}

	public TextReadOnly getAJText_Remark() {
		if (AJText_Remark == null) {
			AJText_Remark = new TextReadOnly();
			AJText_Remark.setBounds(60, 5, 290, 20);
		}
		return AJText_Remark;
	}

	public LabelBase getAJLabel_AdditionalRemark() {
		if (AJLabel_AdditionalRemark == null) {
			AJLabel_AdditionalRemark = new LabelBase();
			AJLabel_AdditionalRemark.setText("Additional Remark");
			AJLabel_AdditionalRemark.setBounds(5, 30, 346, 20);
		}
		return AJLabel_AdditionalRemark;
	}

	public TextAreaBase getTextArea_AdditionalRemark() {
		if (TextArea_AdditionalRemark == null) {
			TextArea_AdditionalRemark = new TextAreaBase(false);
			TextArea_AdditionalRemark.setBounds(5, 50, 346, 110);
		}
		return TextArea_AdditionalRemark;
	}
}