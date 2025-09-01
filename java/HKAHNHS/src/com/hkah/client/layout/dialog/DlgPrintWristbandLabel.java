package com.hkah.client.layout.dialog;

import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.widget.form.RadioGroup;
import com.hkah.client.MainFrame;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.radiobutton.RadioButtonBase;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public abstract class DlgPrintWristbandLabel extends DialogBase {

	private final static int m_frameWidth = 490;
    private final static int m_frameHeight = 200;

	private BasePanel dialogTopPanel = null;
	private LabelBase patNoDesc = null;
	private TextReadOnly patNo = null;
	private TextReadOnly patName = null;
	private LabelBase WhTypeQtn = null;
	private RadioGroup wristTypeGroup = null;
	private RadioButtonBase adultOpt = null;
	private RadioButtonBase babyOpt = null;

	private String memPatientNo = null;

	public DlgPrintWristbandLabel(MainFrame owner) {
        super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
        initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Print Wristband Label");

		setContentPane(getDialogTopPanel());

    	// change label
		getButtonById(OK).setText("Print", 'P');
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String patNo) {
		memPatientNo = patNo;
		getPatNo().setText(memPatientNo);
		getPatName().resetText();
		getAdultOpt().setSelected(true);

		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] { "Patient", "PatFName, PatGName", "PatNo = '" + memPatientNo + "'"},
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getPatName().setText(mQueue.getContentField()[0]+" "+ mQueue.getContentField()[1]);
					setVisible(true);
				} else {
					post(null);
				}
			}
		});
	}

	@Override
	protected void doOkAction() {
		QueryUtil.executeMasterFetch(getUserInfo(), "PATIENTBYNO",
				new String[] { memPatientNo }, new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mq) {
				if (mq.success()) {
					String wbdTypeQyVar = new String();
					String patType = new String();
					final HashMap<String, String> map = new HashMap<String, String>();
					map.put("patbdate", mq.getContentField()[3]+mq.getContentField()[9]);
					map.put("patno", memPatientNo);
					map.put("patsname", mq.getContentField()[0]);
					map.put("patfname", mq.getContentField()[1]);
					map.put("patsex", mq.getContentField()[5]);
					map.put("patcname", mq.getContentField()[6]);
					if (getAdultOpt().isSelected()) {
						wbdTypeQyVar = "ADWBLBLTYP";
						patType = "Adult";
					} else if (getBabyOpt().isSelected()) {
						wbdTypeQyVar = "BBWBLBLTYP";
						patType = "BABY";
					}
					prtWrtBand(patType, getSysParameter(wbdTypeQyVar), map);
				}
			}
		});
	}

	public void prtWrtBand(String patType, String WbdType,HashMap<String, String> map) {

		Map<String,String> map1 = new HashMap<String,String>();
		String patcname = null;
		for (Map.Entry<String, String> pairs : map.entrySet()) {
			if (!"patcname".equals(pairs.getKey())) {
				map1.put(pairs.getKey(),pairs.getValue());
			} else {
				patcname = pairs.getValue();
			}
		}
		String printName = null;
		if ("Adult".equals(patType)) {
			printName = getSysParameter("PRTRTWBADT");
		} else {
			printName = getSysParameter("PRTRTWBBB");
		}
		PrintingUtil.print(printName,"WristbandLabel_"+patType+"_"+WbdType,
				map1,patcname);

		dispose();
	}

	private String getSysParameter(String parcde) {
		return getMainFrame().getSysParameter(parcde);
	}

	protected abstract void post(String patNo);

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getDialogTopPanel() {
		if (dialogTopPanel == null) {
			dialogTopPanel = new BasePanel();
			dialogTopPanel.add(getPatNoDesc(), null);
			dialogTopPanel.add(getPatNo(), null);
			dialogTopPanel.add(getPatName(), null);
			dialogTopPanel.add(getWhTypeQtn(), null);
			dialogTopPanel.add(getAdultOpt(), null);
			dialogTopPanel.add(getBabyOpt(), null);
			dialogTopPanel.setBounds(5, 5, 450, 110);
			getWristTypeGroup();
		}
		return dialogTopPanel;
	}

	public LabelBase getPatNoDesc() {
		if (patNoDesc == null) {
			patNoDesc = new LabelBase();
			patNoDesc.setText("Patient No:");
			patNoDesc.setBounds(5, 5, 80, 20);
		}
		return patNoDesc;
	}

	public TextReadOnly getPatNo() {
		if (patNo == null) {
			patNo = new TextReadOnly();
			patNo.setBounds(100, 5, 80, 20);
		}
		return patNo;
	}

	public TextReadOnly getPatName() {
		if (patName == null) {
			patName = new TextReadOnly();
			patName.setBounds(185, 5, 250, 20);
		}
		return patName;
	}

	public LabelBase getWhTypeQtn() {
		if (WhTypeQtn == null) {
			WhTypeQtn = new LabelBase();
			WhTypeQtn.setText("Which WristBand type to be printed?");
			WhTypeQtn.setBounds(5, 50, 250, 20);
		}
		return WhTypeQtn;
	}

	private RadioGroup getWristTypeGroup() {
		if (wristTypeGroup == null) {
			wristTypeGroup = new RadioGroup();
			wristTypeGroup.add(getAdultOpt());
			wristTypeGroup.add(getBabyOpt());
		}
		return wristTypeGroup;
	}

	public RadioButtonBase getAdultOpt() {
		if (adultOpt == null) {
			adultOpt = new RadioButtonBase();
			adultOpt.setBounds(250, 50, 180, 20);
			adultOpt.setText("Adult");
			adultOpt.setSelected(true);
		}
		return adultOpt;
	}

	public RadioButtonBase getBabyOpt() {
		if (babyOpt == null) {
			babyOpt = new RadioButtonBase();
			babyOpt.setBounds(250, 80, 180, 20);
			babyOpt.setText("Baby");
		 }
		return babyOpt;
	}
}