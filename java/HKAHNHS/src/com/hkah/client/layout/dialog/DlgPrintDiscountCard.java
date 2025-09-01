package com.hkah.client.layout.dialog;

import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTableColumn;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgPrintDiscountCard extends DialogBase implements ConstantsTableColumn {
	private final static int m_frameWidth = 400;
	private final static int m_frameHeight = 200;

	private BasePanel contentPanel = null;
	private LabelBase patientNoDesc = null;
	private TextPatientNoSearch patientNoField = null;
	private LabelBase patientNameDesc = null;
	private TextString patientNameField = null;
	private LabelBase patientCNameDesc = null;
	private TextString patientCNameField = null;
	private LabelBase dueDateDesc = null;
	private TextDate dueDateField = null;

	private ButtonBase printDiscountCard = null;

	public DlgPrintDiscountCard(MainFrame owner) {
		super(owner, m_frameWidth, m_frameHeight);
		initialize();
	}

	private void initialize() {
		setTitle("Print Discount Card");
		setContentPane(getDiscountCardPanel());
	}

	@Override
	public TextPatientNoSearch getDefaultFocusComponent() {
		return getPatitentNoField();
	}

	public void showDialog() {
		setVisible(true);
		getDueDateField().setText(Factory.getInstance().getSysParameter("DCardDue"));
		resetContent();
	}

	private void resetContent() {
		getPatitentNoField().resetText();
		getPatientNameField().resetText();
		getPatientCNameField().resetText();
		getPatitentNoField().requestFocus();
	}

	private void searchPatient(String patNo) {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.PATIENT_TXCODE,
				new String[] {
					patNo
				}, new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getPatientNameField().setText(mQueue.getContentField()[PATIENT_FAMILY_NAME] + " " + mQueue.getContentField()[PATIENT_GIVEN_NAME]);
					getPatientCNameField().setText(mQueue.getContentField()[PATIENT_CHINESE_NAME]);
				} else {
					resetContent();
				}
			}
		});
	}

	protected BasePanel getDiscountCardPanel() {
		if (contentPanel == null) {
			contentPanel = new BasePanel();
			contentPanel.setBounds(5, 5, 360, 160);
			contentPanel.add(getPatientNoDesc(), null);
			contentPanel.add(getPatitentNoField(), null);
			contentPanel.add(getPatientNameDesc(), null);
			contentPanel.add(getPatientNameField(), null);
			contentPanel.add(getPatientCNameDesc(), null);
			contentPanel.add(getPatientCNameField(), null);
			contentPanel.add(getDueDateDesc(), null);
			contentPanel.add(getDueDateField(), null);
			contentPanel.add(getPrintDiscountCard(), null);
		}
		return contentPanel;
	}

	protected LabelBase getPatientNoDesc() {
		if (patientNoDesc == null) {
			patientNoDesc = new LabelBase("Patient Number:");
			patientNoDesc.setBounds(5, 5, 100, 20);
		}
		return patientNoDesc;
	}

	protected TextPatientNoSearch getPatitentNoField() {
		if (patientNoField == null) {
			patientNoField = new TextPatientNoSearch(false) {
				public void onBlur() {
					if (getPatitentNoField().getText().length()>0) {
						searchPatient(getPatitentNoField().getText().trim());
					}
				}
				public void onEnter() {
					searchPatient(getPatitentNoField().getText().trim());
				}
			};

			patientNoField.addListener(Events.KeyDown, new Listener<FieldEvent>() {
				@Override
				public void handleEvent(FieldEvent be) {
					getPatientNameField().resetText();
					getPatientCNameField().resetText();
				}
			});

			patientNoField.setBounds(110, 5, 120, 20);
		}
		return patientNoField;
	}

	protected LabelBase getPatientNameDesc() {
		if (patientNameDesc == null) {
			patientNameDesc = new LabelBase("Patient Name:");
			patientNameDesc.setBounds(5, 30, 100, 20);
		}
		return patientNameDesc;
	}

	protected TextString getPatientNameField() {
		if (patientNameField == null) {
			patientNameField = new TextString();
			patientNameField.setBounds(110, 30, 180, 20);
		}
		return patientNameField;
	}

	protected LabelBase getPatientCNameDesc() {
		if (patientCNameDesc == null) {
			patientCNameDesc = new LabelBase("Chinese Name:");
			patientCNameDesc.setBounds(5, 55, 100, 20);
		}
		return patientCNameDesc;
	}

	protected TextString getPatientCNameField() {
		if (patientCNameField == null) {
			patientCNameField = new TextString();
			patientCNameField.setBounds(110, 55, 180, 20);
		}
		return patientCNameField;
	}

	protected LabelBase getDueDateDesc() {
		if (dueDateDesc == null) {
			dueDateDesc = new LabelBase("Due Date:");
			dueDateDesc.setBounds(5, 80, 100, 20);
		}
		return dueDateDesc;
	}

	protected TextDate getDueDateField() {
		if (dueDateField == null) {
			dueDateField = new TextDate();
			dueDateField.setBounds(110, 80, 150, 20);
		}
		return dueDateField;
	}

	protected ButtonBase getPrintDiscountCard() {
		if (printDiscountCard == null) {
			printDiscountCard = new ButtonBase() {
				@Override
				public void onClick() {
					if (!getPatitentNoField().getText().isEmpty() || !getPatientNameField().isEmpty()) {
						Map<String, String> map = new HashMap<String, String>();
						map.put("PATNAME", getPatientNameField().getText());
						map.put("PATNO", getPatitentNoField().getText());
						map.put("PATCNAME", getPatientCNameField().getText());
						map.put("DUEDATE", getDueDateField().getText());

						if (!PrintingUtil.print(getMainFrame().getSysParameter("PRTPATCARD"),
												"TWAHDiscountCard", map, null)) {
							Factory.getInstance().addErrorMessage("Printing Discount Card failed.");
						}
					}
				}
			};
			printDiscountCard.setText("Print Discount Card");
			printDiscountCard.setBounds(70, 120, 120, 30);
		}
		return printDiscountCard;
	}
}
