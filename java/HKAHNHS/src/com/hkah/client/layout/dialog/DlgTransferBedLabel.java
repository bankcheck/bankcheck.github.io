package com.hkah.client.layout.dialog;

import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.widget.Component;
import com.hkah.client.MainFrame;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTableColumn;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgTransferBedLabel extends DialogBase implements ConstantsTableColumn {
	private final static int m_frameWidth = 400;
	private final static int m_frameHeight = 280;

	private LabelBase patNoDesc = null;
	private TextReadOnly patNo = null;
	private LabelBase patNameDesc = null;
	private TextReadOnly patName = null;
	private LabelBase patCNameDesc = null;
	private TextReadOnly patCName = null;
	private LabelBase dobDesc = null;
	private TextReadOnly dob = null;
	private LabelBase patSexDesc = null;
	private TextReadOnly patSex = null;
	private LabelBase currentBedDesc = null;
	private TextReadOnly currentBed = null;
	private LabelBase newBedDesc = null;
	private TextReadOnly newBed = null;

	private BasePanel bedTransferPanel = null;

	private String regID = null;

	public DlgTransferBedLabel(MainFrame owner) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	private void initialize() {
		setTitle("Print Transfer Label");
		setContentPane(getBedTransferPanel());
	}

	public Component getDefaultFocusComponent() {
		return getButtonById(OK);
	}

	public void showDialog(String patNo, String regID, String sex, String bedCode) {
		getCurrentBed().resetText();
		getPatName().resetText();
		getPatCName().resetText();
		getDob().resetText();
		getPatSex().resetText();
		getNewBed().resetText();

		getPatNo().setText(patNo);
		getCurrentBed().setText(bedCode);

		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.PATIENT_TXCODE,
				new String[] { patNo },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getPatName().setText(mQueue.getContentField()[PATIENT_FAMILY_NAME] + " " + mQueue.getContentField()[PATIENT_GIVEN_NAME]);
					getPatCName().setText(mQueue.getContentField()[PATIENT_CHINESE_NAME]);
					getDob().setText(mQueue.getContentField()[PATIENT_DOB]);
					getPatSex().setText(mQueue.getContentField()[PATIENT_SEX]);
				}
			}
		});

		QueryUtil.executeMasterFetch(getUserInfo(), "TRANSFERBED",
				new String[] { bedCode },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getNewBed().setText(mQueue.getContentField()[0]);
				}
			}
		});

		setVisible(true);
	}


	@Override
	protected void doOkAction() {
		//print
		Map<String,String> map = new HashMap<String,String>();
		map.put("OLDBED", getCurrentBed().getText());
		map.put("NEWBED", getNewBed().getText());

		PrintingUtil.print("[Default Printer]","TransferBedLabel", map, null,
				new String[] { getPatNo().getText(), regID },
				new String[] {
					"PATNO", "PATSEX", "BIRTHDATE" ,
					"PATNAME", "PATCNAME", "BARCODE"
				});
	}

	@Override
	protected void doCancelAction() {
		dispose();
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	private BasePanel getBedTransferPanel() {
		if (bedTransferPanel == null) {
			bedTransferPanel = new BasePanel();
			bedTransferPanel.add(getPatNoDesc());
			bedTransferPanel.add(getPatNo());
			bedTransferPanel.add(getPatNameDesc());
			bedTransferPanel.add(getPatName());
			bedTransferPanel.add(getPatCNameDesc());
			bedTransferPanel.add(getPatCName());
			bedTransferPanel.add(getDobDesc());
			bedTransferPanel.add(getDob());
			bedTransferPanel.add(getPatSexDesc());
			bedTransferPanel.add(getPatSex());
			bedTransferPanel.add(getCurrentBedDesc());
			bedTransferPanel.add(getCurrentBed());
			bedTransferPanel.add(getNewBedDesc());
			bedTransferPanel.add(getNewBed());
		}
		return bedTransferPanel;
	}

	/**
	 * @return the patNoDesc
	 */
	private LabelBase getPatNoDesc() {
		if (patNoDesc == null) {
			patNoDesc = new LabelBase();
			patNoDesc.setText("Patient No.:");
			patNoDesc.setBounds(5, 5, 100, 20);
		}
		return patNoDesc;
	}

	/**
	 * @return the patNo
	 */
	private TextReadOnly getPatNo() {
		if (patNo == null) {
			patNo = new TextReadOnly();
			patNo.setBounds(120, 5, 200, 20);
		}
		return patNo;
	}

	/**
	 * @return the patNameDesc
	 */
	private LabelBase getPatNameDesc() {
		if (patNameDesc == null) {
			patNameDesc = new LabelBase();
			patNameDesc.setText("Patient Name:");
			patNameDesc.setBounds(5, 30, 100, 20);
		}
		return patNameDesc;
	}

	/**
	 * @return the patName
	 */
	private TextReadOnly getPatName() {
		if (patName == null) {
			patName = new TextReadOnly();
			patName.setBounds(120, 30, 200, 20);
		}
		return patName;
	}

	/**
	 * @return the patCNameDesc
	 */
	private LabelBase getPatCNameDesc() {
		if (patCNameDesc == null) {
			patCNameDesc = new LabelBase();
			patCNameDesc.setText("Chinese Name:");
			patCNameDesc.setBounds(5, 55, 100, 20);
		}
		return patCNameDesc;
	}

	/**
	 * @return the patCName
	 */
	private TextReadOnly getPatCName() {
		if (patCName == null) {
			patCName = new TextReadOnly();
			patCName.setBounds(120, 55, 200, 20);
		}
		return patCName;
	}

	/**
	 * @return the dobDesc
	 */
	private LabelBase getDobDesc() {
		if (dobDesc == null) {
			dobDesc = new LabelBase();
			dobDesc.setText("Date of Birth:");
			dobDesc.setBounds(5, 80, 100, 20);
		}
		return dobDesc;
	}

	/**
	 * @return the dob
	 */
	private TextReadOnly getDob() {
		if (dob == null) {
			dob = new TextReadOnly();
			dob.setBounds(120, 80, 200, 20);
		}
		return dob;
	}

	/**
	 * @return the patSexDesc
	 */
	private LabelBase getPatSexDesc() {
		if (patSexDesc == null) {
			patSexDesc = new LabelBase();
			patSexDesc.setText("Sex:");
			patSexDesc.setBounds(5, 105, 100, 20);
		}
		return patSexDesc;
	}

	/**
	 * @return the patSex
	 */
	private TextReadOnly getPatSex() {
		if (patSex == null) {
			patSex = new TextReadOnly();
			patSex.setBounds(120, 105, 200, 20);
		}
		return patSex;
	}

	/**
	 * @return the currentBedDesc
	 */
	private LabelBase getCurrentBedDesc() {
		if (currentBedDesc == null) {
			currentBedDesc = new LabelBase();
			currentBedDesc.setText("Current Bed:");
			currentBedDesc.setBounds(5, 130, 100, 20);
		}
		return currentBedDesc;
	}

	/**
	 * @return the currentBed
	 */
	private TextReadOnly getCurrentBed() {
		if (currentBed == null) {
			currentBed = new TextReadOnly();
			currentBed.setBounds(120, 130, 200, 20);
		}
		return currentBed;
	}

	/**
	 * @return the newBedDesc
	 */
	private LabelBase getNewBedDesc() {
		if (newBedDesc == null) {
			newBedDesc = new LabelBase();
			newBedDesc.setText("New Bed:");
			newBedDesc.setBounds(5, 155, 100, 20);
		}
		return newBedDesc;
	}

	/**
	 * @return the newBed
	 */
	private TextReadOnly getNewBed() {
		if (newBed == null) {
			newBed = new TextReadOnly();
			newBed.setBounds(120, 155, 200, 20);
		}
		return newBed;
	}
}