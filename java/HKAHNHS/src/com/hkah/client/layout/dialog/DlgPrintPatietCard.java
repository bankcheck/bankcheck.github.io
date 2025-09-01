package com.hkah.client.layout.dialog;

import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.widget.Component;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextPatientNoSearch;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTableColumn;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgPrintPatietCard extends DialogBase implements ConstantsTableColumn {
	private final static int m_frameWidth = 450;
	private final static int m_frameHeight = 330;

	private BasePanel contentPanel = null;
	private LabelBase patientNoDesc = null;
	private TextPatientNoSearch patientNoField = null;
	private LabelBase patientNameDesc = null;
	private LabelBase patientNameField = null;
	private LabelBase patientCNameField = null;
	private LabelBase dateOfBirthDesc = null;
	private LabelBase dateOfBirthField = null;
	private LabelBase sexDesc = null;
	private LabelBase sexField = null;
	private ButtonBase printPatientCard = null;
	private ButtonBase printEmbossCard = null;
	private ButtonBase printDiscountCard = null;
	private ButtonBase printPatientCardCustom = null;
	private ButtonBase printEmbossCardCustom = null;
	private ButtonBase printPatientCardCustom2 = null;
	private ButtonBase printEmbossCardCustom2 = null;
	private DlgPrintDiscountCard dlgDiscountCard = null;
	private FieldSetBase outPatientPanel = null;
	private FieldSetBase inPatientPanel = null;

	private String patFname = null;
	private String patGname = null;
	private String patLFname = null;
	private String patLGname = null;
	private boolean isPatientLongName = false;

	public DlgPrintPatietCard(MainFrame owner) {
		super(owner, m_frameWidth, m_frameHeight);
		initialize();
	}

	private void initialize() {
		setTitle("Print Patient Card");
		setContentPane(getPatientCardPanel());
	}

	@Override
	public Component getDefaultFocusComponent() {
		if (!getPatitentNoField().isReadOnly()) {
			return getPatitentNoField();
		} else {
			return getPrintPatientCard();
		}
	}

	public void showDialog() {
		setVisible(true);
		resetContent();
		getPatitentNoField().setEditableForever(true);
		getPatitentNoField().setReadOnly(false);
	}

	public void showDialog(String patNo) {
		setVisible(true);
		resetContent();
		getPatitentNoField().setText(patNo);
		getPatitentNoField().setEditableForever(false);
		getPatitentNoField().setReadOnly(true);
		searchPatient(patNo);
		getPrintPatientCard().focus();
	}

	private void resetContent() {
		getPatitentNoField().resetText();
		getPatientNameField().resetText();
		getPatientCNameField().resetText();
		getDateOfBirthField().resetText();
		getSexField().resetText();
		patFname = null;
		patGname = null;
		isPatientLongName = false;
		getDefaultFocusComponent().focus();
	}

	private void searchPatient(String patNo) {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.PATIENT_TXCODE,
				new String[] {
					patNo
				}, new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					isPatientLongName = false;
					patFname = mQueue.getContentField()[PATIENT_FAMILY_NAME];
					patGname = mQueue.getContentField()[PATIENT_GIVEN_NAME];
					patLFname = null;
					patLGname = null;
					if (HKAH_VALUE.equals(Factory.getInstance().getUserInfo().getSiteCode())
							&& (mQueue.getContentField()[PATIENT_LONG_FAMILY_NAME].length() > 0
							||  mQueue.getContentField()[PATIENT_LONG_GIVEN_NAME].length() > 0)) {
						patLFname = mQueue.getContentField()[PATIENT_LONG_FAMILY_NAME];
						patLGname = mQueue.getContentField()[PATIENT_LONG_GIVEN_NAME];
						if (patLFname.length() > 30) {
							isPatientLongName = true;
						}
					}
					getPatientNameField().setText(patFname + " " + patGname);
					getPatientCNameField().setText(mQueue.getContentField()[PATIENT_CHINESE_NAME]);
					getDateOfBirthField().setText(mQueue.getContentField()[PATIENT_DOB]);
					getSexField().setText(mQueue.getContentField()[PATIENT_SEX]);
				} else {
					resetContent();
				}
			}
		});
	}

	private String getPatientCardName() {
		if (Factory.getInstance().getMainFrame().isDisableApplet()) {
			if (HKAH_VALUE.equals(getUserInfo().getSiteCode())) {
				return "PatientCard_TWAH";
			} else {
				return "PatientCard_HKAH";
			}
		} else {
			return "PatientCard_" + Factory.getInstance().getUserInfo().getSiteCode();
		}
	}
	protected BasePanel getPatientCardPanel() {
		if (contentPanel == null) {
			contentPanel = new BasePanel();
			contentPanel.setBounds(5, 5, 410, 160);
			contentPanel.add(getPatientNoDesc(), null);
			contentPanel.add(getPatitentNoField(), null);
			contentPanel.add(getPatientNameDesc(), null);
			contentPanel.add(getPatientNameField(), null);
			contentPanel.add(getPatientCNameField(), null);
			contentPanel.add(getDateOfBirthDesc(), null);
			contentPanel.add(getDateOfBirthField(), null);
			contentPanel.add(getSexDesc(), null);
			contentPanel.add(getSexField(), null);
			contentPanel.add(getOutPatientPanel(), null);
			if (YES_VALUE.equals(getMainFrame().getSysParameter("CARDOTHLOC"))) {
				contentPanel.add(getInPatientPanel(), null);
			}
/*
			contentPanel.add(getPrintPatientCard(), null);
			if (HKAH_VALUE.equals(Factory.getInstance().getUserInfo().getSiteCode())) {
				contentPanel.add(getPrintEmbossCard(), null);
			} else if (TWAH_VALUE.equals(Factory.getInstance().getUserInfo().getSiteCode())) {
				contentPanel.add(getPrintDiscountCard(), null);
			} if (getMainFrame().getSysParameter("CARDOTHLOC").equals(YES_VALUE)) {
				contentPanel.add(getPrintPatientCardCustom(), null);
				contentPanel.add(getPrintEmbossCardCustom(), null);
				contentPanel.add(getPrintPatientCardCustom2(), null);
				contentPanel.add(getPrintEmbossCardCustom2(), null);
			}
*/
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
				@Override
				public void onBlur() {
					if (getPatitentNoField().getText().length()>0) {
						searchPatient(getPatitentNoField().getText().trim());
					}
				}

				@Override
				public void onEnter() {
					searchPatient(getPatitentNoField().getText().trim());
				}
			};

			patientNoField.addListener(Events.KeyDown, new Listener<FieldEvent>() {
				@Override
				public void handleEvent(FieldEvent be) {
					if (be.isAltKey()) {
						return;
					}

					patFname = null;
					patGname = null;
					getPatientNameField().resetText();
					getPatientCNameField().resetText();
					getDateOfBirthField().resetText();
					getSexField().resetText();
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

	protected LabelBase getPatientNameField() {
		if (patientNameField == null) {
			patientNameField = new LabelBase();
			patientNameField.setBounds(110, 30, 300, 30);
		}
		return patientNameField;
	}

	protected LabelBase getPatientCNameField() {
		if (patientCNameField == null) {
			patientCNameField = new LabelBase();
			patientCNameField.setBounds(300, 30, 60, 20);
			patientCNameField.setVisible(false);
		}
		return patientCNameField;
	}

	protected LabelBase getDateOfBirthDesc() {
		if (dateOfBirthDesc == null) {
			dateOfBirthDesc = new LabelBase("Date of Birth:");
			dateOfBirthDesc.setBounds(5, 60, 100, 20);
		}
		return dateOfBirthDesc;
	}

	protected LabelBase getDateOfBirthField() {
		if (dateOfBirthField == null) {
			dateOfBirthField = new LabelBase();
			dateOfBirthField.setBounds(110, 60, 100, 20);
		}
		return dateOfBirthField;
	}

	protected LabelBase getSexDesc() {
		if (sexDesc == null) {
			sexDesc = new LabelBase("Sex:");
			sexDesc.setBounds(5, 80, 100, 20);
		}
		return sexDesc;
	}

	protected LabelBase getSexField() {
		if (sexField == null) {
			sexField = new LabelBase();
			sexField.setBounds(110, 80, 20, 20);
		}
		return sexField;
	}

	protected FieldSetBase getOutPatientPanel() {
		if (outPatientPanel == null) {
			outPatientPanel = new FieldSetBase();
			outPatientPanel.setBounds(15, 100, 380, 70);
			outPatientPanel.setHeading("Out-patient");
			outPatientPanel.add(getPrintPatientCard(), null);
			if (HKAH_VALUE.equals(Factory.getInstance().getUserInfo().getSiteCode())) {
				outPatientPanel.add(getPrintEmbossCard(), null);
			} else if (TWAH_VALUE.equals(Factory.getInstance().getUserInfo().getSiteCode())) {
				outPatientPanel.add(getPrintDiscountCard(), null);
			}
		}
		return outPatientPanel;
	}

	protected ButtonBase getPrintPatientCard() {
		if (printPatientCard == null) {
			printPatientCard = new ButtonBase() {
				@Override
				public void onClick() {
					if (!getPatitentNoField().getText().isEmpty()) {
						String newbarcode = getPatitentNoField().getText().trim() +
											PrintingUtil.generateCheckDigit(
													getPatitentNoField().getText().trim()).toString()+"#";

						Map<String, String> map = new HashMap<String, String>();
						if (patLFname != null && patLGname != null) {
							map.put("PATFNAME", patLFname);
							map.put("PATGNAME", patLGname);
						} else {
							map.put("PATFNAME", patFname);
							map.put("PATGNAME", patGname);
						}
						map.put("PATNO", getPatitentNoField().getText().trim());
						map.put("PATCNAME", getPatientCNameField().getText());
						map.put("BARCODE",  newbarcode);

						if (!PrintingUtil.print(getMainFrame().getSysParameter("PRTPATCARD"),
								getPatientCardName(),
								map, null)) {
							Factory.getInstance().addErrorMessage("Printing Patient Card failed.");
						}
					} else {
						Factory.getInstance().addErrorMessage("Please input patient no.", getPatitentNoField());
					}
				}
			};
			printPatientCard.setText("Print Patient Card", 'P');
			printPatientCard.setBounds(15, 0, 160, 30);
		}
		return printPatientCard;
	}

	protected ButtonBase getPrintEmbossCard() {
		if (printEmbossCard == null) {
			printEmbossCard = new ButtonBase() {
				@Override
				public void onClick() {
					if (!getPatitentNoField().getText().isEmpty()) {
						try {
							String data = "\r\n<";
							data += patFname.toUpperCase()+"\r\n";
							data += patGname.toUpperCase()+"\r\n";
							data += DateTimeUtil.format(DateTimeUtil.parseDate(getDateOfBirthField().getText()),
															"MMM dd, yyyy").toUpperCase();
							data += "    "+getSexField().getText().toUpperCase()+"\r\n";
							data += getPatitentNoField().getText().trim()+">";

							print(getMainFrame().getSysParameter("PRTMRCARD"), "1",
									data, true);
						} catch (Exception e) {
							e.printStackTrace();
							Factory.getInstance().addErrorMessage("Fail to Print Emboss Card.");
						}
					} else {
						Factory.getInstance().addErrorMessage("Please input patient no.", getPatitentNoField());
					}
				}
			};
			printEmbossCard.setText("Print Emboss Card", 'E');
			printEmbossCard.setBounds(200, 0, 165, 30);
			printEmbossCard.setEnabled(false);
		}
		return printEmbossCard;
	}

	protected ButtonBase getPrintDiscountCard() {
		if (printDiscountCard == null) {
			printDiscountCard = new ButtonBase() {
				@Override
				public void onClick() {
					getDiscountCardDailog().showDialog();
				}
			};
			printDiscountCard.setText("Print Discount Card");
			printDiscountCard.setBounds(190, 0, 165, 30);
		}
		return printDiscountCard;
	}

	protected FieldSetBase getInPatientPanel() {
		if (inPatientPanel == null) {
			inPatientPanel = new FieldSetBase();
			inPatientPanel.setBounds(15, 180, 380, 100);
			inPatientPanel.setHeading("In-patient");
			inPatientPanel.add(getPrintPatientCardCustom(), null);
			inPatientPanel.add(getPrintEmbossCardCustom(), null);
			inPatientPanel.add(getPrintPatientCardCustom2(), null);
			inPatientPanel.add(getPrintEmbossCardCustom2(), null);
		}
		return inPatientPanel;
	}

	protected ButtonBase getPrintPatientCardCustom() {
		if (printPatientCardCustom == null) {
			printPatientCardCustom = new ButtonBase() {
				@Override
				public void onClick() {
					if (!getPatitentNoField().getText().isEmpty()) {
						String newbarcode = getPatitentNoField().getText().trim() +
											PrintingUtil.generateCheckDigit(
													getPatitentNoField().getText().trim()).toString()+"#";

						Map<String, String> map = new HashMap<String, String>();
						if (patLFname != null && patLGname != null) {
							map.put("PATFNAME", patLFname);
							map.put("PATGNAME", patLGname);
						} else {
							map.put("PATFNAME", patFname);
							map.put("PATGNAME", patGname);
						}
						map.put("PATNO", getPatitentNoField().getText().trim());
						map.put("PATCNAME", getPatientCNameField().getText());
						map.put("BARCODE",  newbarcode);

						if (!PrintingUtil.print(getMainFrame().getSysParameter("PRTPTCARD2"),
								getPatientCardName(),
								map, null)) {
							Factory.getInstance().addErrorMessage("Printing Patient Card failed.");
						}
					} else {
						Factory.getInstance().addErrorMessage("Please input patient no.", getPatitentNoField());
					}
				}
			};
			printPatientCardCustom.setText("Print Patient Card (IPB)");
			printPatientCardCustom.setBounds(15, 0, 160, 30);
		}
		return printPatientCardCustom;
	}

	protected ButtonBase getPrintEmbossCardCustom() {
		if (printEmbossCardCustom == null) {
			printEmbossCardCustom = new ButtonBase() {
				@Override
				public void onClick() {
					if (!getPatitentNoField().getText().isEmpty()) {
						try {
							String data = "\r\n<";
							data += patFname.toUpperCase()+"\r\n";
							data += patGname.toUpperCase()+"\r\n";
							data += DateTimeUtil.format(DateTimeUtil.parseDate(getDateOfBirthField().getText()),
															"MMM dd, yyyy").toUpperCase();
							data += "    "+getSexField().getText().toUpperCase()+"\r\n";
							data += getPatitentNoField().getText().trim()+">";

							print(getMainFrame().getSysParameter("PRTMRCARD2"), "1",
									data, true);
						} catch (Exception e) {
							e.printStackTrace();
							Factory.getInstance().addErrorMessage("Fail to Print Emboss Card.");
						}
					} else {
						Factory.getInstance().addErrorMessage("Please input patient no.", getPatitentNoField());
					}
				}
			};
			printEmbossCardCustom.setText("Print Emboss Card (IPB)");
			printEmbossCardCustom.setEnabled(false);
			printEmbossCardCustom.setBounds(200, 0, 165, 30);
		}
		return printEmbossCardCustom;
	}

	protected ButtonBase getPrintPatientCardCustom2() {
		if (printPatientCardCustom2 == null) {
			printPatientCardCustom2 = new ButtonBase() {
				@Override
				public void onClick() {
					if (!getPatitentNoField().getText().isEmpty()) {
						String newbarcode = getPatitentNoField().getText().trim() +
											PrintingUtil.generateCheckDigit(
													getPatitentNoField().getText().trim()).toString()+"#";

						Map<String, String> map = new HashMap<String, String>();
						if (patLFname != null && patLGname != null) {
							map.put("PATFNAME", patLFname);
							map.put("PATGNAME", patLGname);
						} else {
							map.put("PATFNAME", patFname);
							map.put("PATGNAME", patGname);
						}
						map.put("PATNO", getPatitentNoField().getText().trim());
						map.put("PATCNAME", getPatientCNameField().getText());
						map.put("BARCODE",  newbarcode);

						if (!PrintingUtil.print(getMainFrame().getSysParameter("PRTPTCARD3"),
								getPatientCardName(),
								map, null)) {
							Factory.getInstance().addErrorMessage("Printing Patient Card failed.");
						}
					} else {
						Factory.getInstance().addErrorMessage("Please input patient no.", getPatitentNoField());
					}
				}
			};
			printPatientCardCustom2.setText("Print Patient Card (Info)");
			printPatientCardCustom2.setBounds(15, 35, 160, 30);
		}
		return printPatientCardCustom2;
	}

	protected ButtonBase getPrintEmbossCardCustom2() {
		if (printEmbossCardCustom2 == null) {
			printEmbossCardCustom2 = new ButtonBase() {
				@Override
				public void onClick() {
					if (!getPatitentNoField().getText().isEmpty()) {
						try {
							String data = "\r\n<";
							data += patFname.toUpperCase()+"\r\n";
							data += patGname.toUpperCase()+"\r\n";
							data += DateTimeUtil.format(DateTimeUtil.parseDate(getDateOfBirthField().getText()),
															"MMM dd, yyyy").toUpperCase();
							data += "    "+getSexField().getText().toUpperCase()+"\r\n";
							data += getPatitentNoField().getText().trim()+">";

							print(getMainFrame().getSysParameter("PRTMRCARD3"), "1",
									data, true);
						}
						catch (Exception e) {
							e.printStackTrace();
							Factory.getInstance().addErrorMessage("Fail to Print Emboss Card.");
						}
					} else {
						Factory.getInstance().addErrorMessage("Please input patient no.", getPatitentNoField());
					}
				}
			};
			printEmbossCardCustom2.setText("Print Emboss Card (Info)");
			printEmbossCardCustom2.setEnabled(false);
			printEmbossCardCustom2.setBounds(200, 35, 165, 30);
		}
		return printEmbossCardCustom2;
	}

	private DlgPrintDiscountCard getDiscountCardDailog() {
		if (dlgDiscountCard == null) {
			dlgDiscountCard = new DlgPrintDiscountCard(getMainFrame());
		}
		return dlgDiscountCard;
	}

	public static boolean print(String printerName, String noOfCopies, String data, final boolean alertSuccess) {
		if (Factory.getInstance().getMainFrame().isDisableApplet()) {
			// TODO: implement new print method
			return printGreenCard(printerName, noOfCopies, data, alertSuccess);
		} else {
			return printGreenCard(printerName, noOfCopies, data, alertSuccess);
		}
	}

	public static native boolean printGreenCard(String printerName, String noOfCopies, String data,
			boolean alertSuccess) /*-{
		var appletName = @com.hkah.client.util.PrintingUtil::getAppletName()();
		if (appletName == null || appletName == '') {
			alert('Cannot get applet:' + appletName);
		}

		var applet = $wnd.document.getElementById(appletName);
		var result = applet.printGreenCard(printerName, noOfCopies, data);

		if (result) {
			if (alertSuccess) {
				alert("print successfully!");
			}
		} else {
			alert(result);
			alert("print fail.");
		}
		return result;
	}-*/;
}