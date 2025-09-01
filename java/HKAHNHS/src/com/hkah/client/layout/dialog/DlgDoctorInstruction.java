/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextRemark;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
@SuppressWarnings("serial")
public class DlgDoctorInstruction extends DialogBase {

    private final static int m_frameWidth = 600;
    private final static int m_frameHeight = 540;

	private BasePanel dialogTopPanel = null;
	private LabelBase Label_AdmDr = null;
	private LabelBase Label_TrtDr = null;
	private LabelBase Label_RegType = null;
	private LabelBase Label_PaymentInstruction = null;
	private LabelBase admDoctor = null;
	private LabelBase trtDoctor = null;
	private TextRemark instruction1 = null;
	private TextRemark instruction2 = null;
	private TextRemark paymentInstruction1 = null;
	private TextRemark paymentInstruction2 = null;

	public DlgDoctorInstruction(MainFrame owner) {
        super(owner, OK, m_frameWidth, m_frameHeight);
        initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Doctor Instructions");

		setContentPane(getDialogTopPanel());
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String dialogTitle,
			String doctorCode1, String doctorName1, String drInstruction, String drPayment,
			String doctorCode2, String doctorName2, String instruction, String payment) {
		if (dialogTitle != null && dialogTitle.length() > 0) {
			getLabel_RegType().setText("<b>" + dialogTitle + "</b>");
		}
		getAdmDr().setText(getDoctorDetail(doctorCode1, doctorName1));
		getInstruction1().setText(drInstruction);
		getPaymentInstruction1().setText(drPayment);
		getTrtDr().setText(getDoctorDetail(doctorCode2, doctorName2));
		getInstruction2().setText(instruction);
		getPaymentInstruction2().setText(payment);

		setVisible(true);
	}

	private String getDoctorDetail(String doctorCode, String doctorName) {
		StringBuffer showDetail = new StringBuffer();
		if (doctorCode != null) {
			showDetail.append("<b>");
			showDetail.append(doctorCode);
			showDetail.append("</b>");
			showDetail.append(SPACE_VALUE);
		}

		if (doctorName != null) {
			showDetail.append(doctorName);
		}

		return showDetail.toString();
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public BasePanel getDialogTopPanel() {
		if (dialogTopPanel == null) {
			dialogTopPanel = new BasePanel();
			dialogTopPanel.setEtchedBorder();
			dialogTopPanel.setBounds(6, 8, 555, 440);
			dialogTopPanel.add(getLabel_AdmDr(), null);
			dialogTopPanel.add(getAdmDr(), null);
			dialogTopPanel.add(getLabel_TrtDr(), null);
			dialogTopPanel.add(getTrtDr(), null);
			dialogTopPanel.add(getLabel_RegType(), null);
			dialogTopPanel.add(getInstruction1(), null);
			dialogTopPanel.add(getInstruction2(), null);
			dialogTopPanel.add(getLabel_PaymentInstruction(), null);
			dialogTopPanel.add(getPaymentInstruction1(), null);
			dialogTopPanel.add(getPaymentInstruction2(), null);
		}
		return dialogTopPanel;
	}

	public LabelBase getLabel_AdmDr() {
		if (Label_AdmDr == null) {
			Label_AdmDr = new LabelBase();
			Label_AdmDr.setText("<u>Admission Doctor (for Inpatient only)</u>");
			Label_AdmDr.setBounds(5, 5, 260, 20);
		}
		return Label_AdmDr;
	}

	public LabelBase getAdmDr() {
		if (admDoctor == null) {
			admDoctor = new LabelBase();
			admDoctor.setBounds(5, 30, 260, 20);
			admDoctor.focus();
		}
		return admDoctor;
	}

	public LabelBase getLabel_TrtDr() {
		if (Label_TrtDr == null) {
			Label_TrtDr = new LabelBase();
			Label_TrtDr.setText("<u>Treatment Doctor</u>");
			Label_TrtDr.setBounds(280, 5, 260, 20);
		}
		return Label_TrtDr;
	}

	public LabelBase getTrtDr() {
		if (trtDoctor == null) {
			trtDoctor = new LabelBase();
			trtDoctor.setBounds(280, 30, 260, 20);
			trtDoctor.focus();
		}
		return trtDoctor;
	}

	public LabelBase getLabel_RegType() {
		if (Label_RegType == null) {
			Label_RegType = new LabelBase();
			Label_RegType.setText("<b>UNKNOWN REGISTRATION TYPE</b>");
			Label_RegType.setBounds(215, 60, 300, 20);
		}
		return Label_RegType;
	}

	public TextRemark getInstruction1() {
		if (instruction1 == null) {
			instruction1 = new TextRemark();
			instruction1.setBounds(5, 85, 260, 150);
			instruction1.focus();
		}
		return instruction1;
	}

	public TextRemark getInstruction2() {
		if (instruction2 == null) {
			instruction2 = new TextRemark();
			instruction2.setBounds(280, 85, 260, 150);
			instruction2.focus();
		}
		return instruction2;
	}

	public LabelBase getLabel_PaymentInstruction() {
		if (Label_PaymentInstruction == null) {
			Label_PaymentInstruction = new LabelBase();
			Label_PaymentInstruction.setText("<b>PAYMENT INSTRUCTIONS</b>");
			Label_PaymentInstruction.setBounds(215, 250, 300, 20);
		}
		return Label_PaymentInstruction;
	}

	public TextRemark getPaymentInstruction1() {
		if (paymentInstruction1 == null) {
			paymentInstruction1 = new TextRemark();
			paymentInstruction1.setBounds(5, 280, 260, 150);
			paymentInstruction1.focus();
		}
		return paymentInstruction1;
	}

	public TextRemark getPaymentInstruction2() {
		if (paymentInstruction2 == null) {
			paymentInstruction2 = new TextRemark();
			paymentInstruction2.setBounds(280, 280, 260, 150);
			paymentInstruction2.focus();
		}
		return paymentInstruction2;
	}
}