package com.hkah.client.tx.registration;

import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.form.RadioGroup;
import com.google.gwt.user.client.ui.HTML;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.dialog.DialogBase;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.radiobutton.RadioButtonBase;
import com.hkah.client.layout.textfield.TextDateTime;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.PrintingUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class PrintOBCert extends MasterPanel {

	public PrintOBCert() {
		super();
	}

	@Override
	protected String[] getColumnNames() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected int[] getColumnWidths() {
		// TODO Auto-generated method stub
		return null;
	}

	private BasePanel rightPanel = null;
	private FieldSetBase dlgPanel = null;
	private FieldSetBase InfoPanel = null;
	private FieldSetBase subInfoPanel = null;
	private LabelBase bkNoDesc = null;
	private TextString bookingNo = null;
	private LabelBase certNoDesc = null;
	private TextString certNo = null;
	private LabelBase hosNameEnDesc = null;
	private TextString hosNameEn = null;
	private LabelBase hosNameChiDesc = null;
	private TextString hosNameChi = null;
	private LabelBase patNameDesc = null;
	private TextString patName = null;
	private LabelBase patNameChiDesc = null;
	private TextString patNameChi = null;
	private LabelBase patNoDesc = null;
	private TextString patNo = null;
	private LabelBase patDOBDesc = null;
	private TextDateTime patDOB = null;
	private RadioButtonBase patDocExPmOpt = null;
	private TextString patDocExPm = null;
	private RadioButtonBase patDocOtherOpt = null;
	private TextString patDocOther = null;
	private LabelBase  patHusNameDesc = null;
	private TextString patHusName = null;
	private LabelBase patHusNameChiDesc = null;
	private TextString patHusNameChi = null;
	private LabelBase patHusIDDesc = null;
	private TextString patHusID = null;
	private LabelBase patSpseOfHKRtDesc = null;
	private RadioButtonBase patPRtYesOpt = null;
	private RadioButtonBase patPRtNoOpt = null;
	private RadioButtonBase patPRtUknOpt = null;
	private LabelBase patHusDOBDesc = null;
	private TextDateTime patHusDOB = null;
	private LabelBase patCaseDrDesc = null;
	private TextString patCaseDr = null;
	private LabelBase drMCHDesc = null;
	private TextString drMCH = null;
	private LabelBase drTelPgrDesc = null;
	private TextString drTelPgr = null;
	private LabelBase patAntDateDesc = null;
	private TextDateTime patAntDate1 = null;
	private TextDateTime patAntDate2 = null;
	private TextDateTime patAntDate3 = null;
	private TextDateTime patAntDate4 = null;
	private TextDateTime patAntDate5 = null;
	private TextDateTime patAntDate6 = null;
	private LabelBase patEDCDesc = null;
	private TextDateTime patEDC = null;
	private LabelBase certValTilDesc = null;
	private TextDateTime certValTil = null;
	private LabelBase certIssByDesc = null;
	private TextString certIssBy = null;
	private LabelBase certIssDateDesc = null;
	private TextDateTime certIssDate = null;
	private LabelBase patMCertNoDesc = null;
	private TextString patMCertNo = null;
	private LabelBase patMDateDesc = null;
	private TextDateTime patMDate = null;
	private String currSlpNo = null;
	private String currPatNo = null;
	private ButtonBase printCert = null;
	private ButtonBase printConsent = null;
	private String patSex = null;
	private String currMode = null;
	private HTML Line = null;
	private BasePanel linePanel = null;
	private ButtonBase rptBtn = null;
	private ComboBoxBase statusCombo = null;
	private LabelBase statusDesc = null;
	private LabelBase repltRsnDesc = null;
	private ComboBoxBase repltRsnCombo = null;
	private LabelBase updateDtDesc = null;
	private TextDateTime updateDt = null;
	private LabelBase newCertDesc = null;
	private TextString newCert = null;
	private DialogBase toDateDialog = null;
	private LabelBase dlgToDateDesc = null;
	private TextDateTime dlgToDate = null;

	@Override
	protected BasePanel getLeftPanel() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected BasePanel getRightPanel() {
		if (rightPanel == null) {
			rightPanel = new BasePanel();
			rightPanel.setSize(800, 800);
			rightPanel.add(getInfoPanel(), null);
		}
		return rightPanel;
	}

	public boolean init() {
		setNoGetDB(true);
		//setLeftAlignPanel();
		setRightAlignPanel();
		getJScrollPane().setBounds(15, 25, 725, 290);

		RadioGroup patDocgrp = new RadioGroup();
		patDocgrp.add(getPatDocExPmOpt());
		patDocgrp.add(getPatDocOtherOpt());
		RadioGroup spseGrp = new RadioGroup();
		spseGrp.add(getPatPRtYesOpt());
		spseGrp.add(getPatPRtNoOpt());
		spseGrp.add(getPatPRtUknOpt());

		currSlpNo = getParameter("SlpNo");
		currPatNo = getParameter("patNo");
		currMode  = getParameter("currMode");
		if ("searchCert".equals(currMode)) {
			getInfoPanel().setVisible(true);
			getBkNoDesc().setVisible(true);
			getBooking().setVisible(true);
		}
		resetParameter("SlpNo");
		resetParameter("patNo");
		resetParameter("currMode");

		return true;
	}

	@Override
	protected void initAfterReady() {
		setRecordFound(false);
		setSearchButtonEnabled(false);
		setAppendButtonEnabled(false);
		setModifyButtonEnabled(true);
		QueryUtil.executeMasterFetch(getUserInfo(), getTxCode(), getFetchInputParameters(),
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getFetchOutputValues(mQueue.getContentField());
				}
			}
		});
		if ("searchCert".equals(currMode)) {
			getInfoPanel().setHeading("Searching OB Certificate");
			setAllLeftFieldsEnabled(true);

			getBkNoDesc().setVisible(false);
			getBooking().setVisible(false);

			getSubInfoPanel().setVisible(false);
			getHosNameEnDesc().setVisible(false);
			getHosNameEn().setVisible(false);
			getHosNameChiDesc().setVisible(false);
			getHosNameChi().setVisible(false);
			getPatHusNameDesc().setVisible(false);
			getPatHusName().setVisible(false);
			getPatHusNameChiDesc().setVisible(false);
			getPatHusNameChi().setVisible(false);
			getPatHusIDDesc().setVisible(false);
			getPatHusID().setVisible(false);
			getPatHusDOBDesc().setVisible(false);
			getPatHusDOB().setVisible(false);
			getPatMCertNoDesc().setVisible(false);
			getPatMCertNo().setVisible(false);
			getPatMDateDesc().setVisible(false);
			getPatMDate().setVisible(false);
			getPrintCert().setVisible(true);
			getPrintConsent().setVisible(true);
			getBkNoDesc().setBounds(5, 30,140, 20);
			getBooking().setBounds(90, 30,180, 20);
			getPatSpseOfHKRtDesc().setBounds(5,135,240, 20);
			getPatPRtYesOpt().setBounds(247,135,5, 20);
			getPatPRtNoOpt().setBounds(300, 135,5, 20);
			getPatPRtUknOpt().setBounds(350, 135,10, 20);
			getPatCaseDrDesc().setBounds(5,165,128, 20);
			getPatCaseDr().setBounds(130,165,250, 20);
			getDrMCHDesc().setBounds(5,195,160, 20);
			getDrMCH().setBounds(166,195,200, 20);
			getDrTelPgrDesc().setBounds(380,195,155, 20);
			getDrTelPgr().setBounds(535,195,200, 20);
			getPatAntDateDesc().setBounds(5,225,155, 20);
			getPatAntDate1().setBounds(162,225,100, 20);
			getPatAntDate2().setBounds(263,225,100, 20);
			getPatAntDate3().setBounds(364,225,100, 20);
			getPatAntDate4().setBounds(162,250,100, 20);
			getPatAntDate5().setBounds(263,250,100, 20);
			getPatAntDate6().setBounds(364,250,100, 20);
			getPatEDCDesc().setBounds(5,277,175, 20);
			getPatEDC().setBounds(180,277,90, 20);
			getCertValTilDesc().setBounds(280,277,165, 20);
			getCertValTil().setBounds(445,277,90, 20);
			getCertIssByDesc().setBounds(5,307,65, 20);
			getCertIssBy().setBounds(70,307,200, 20);
			getCertIssDate().setBounds(445,307,90, 20);
			getCertIssDateDesc().setBounds(310,307,100, 20);
			getPrintCert().setBounds(132, 455, 120, 30);
			getPrintConsent().setBounds(255, 455, 120, 30);
		} else {
			getLinePanel().setVisible(false);
			getStatusComBo().setVisible(false);
			getStatusDesc().setVisible(false);
			getRepltRsnDesc().setVisible(false);
			getRepltRsnComBo().setVisible(false);
			getUpdateDtDesc().setVisible(false);
			getUpdateDt().setVisible(false);
			getNewCertDesc().setVisible(false);
			getNewCert().setVisible(false);
			getRptBtn().setVisible(false);
			getBooking().setEnabled(true);
			getHosNameEnDesc().setVisible(false);
			getHosNameEn().setVisible(false);
			getHosNameChiDesc().setVisible(false);
			getHosNameChi().setVisible(false);
			getCertIssDate().setText(getMainFrame().getServerDate());
			getCertIssBy().setText(getUserInfo().getUserID());
			getPrintCert().setEnabled(false);
			getPrintConsent().setEnabled(false);
			getRptBtn().setEnabled(false);
		}
		getCertNo().requestFocus();
	}

	@Override
	protected void confirmCancelButtonClicked() {
		setAllRightFieldsEnabled(false);
	}

	@Override
	protected void appendDisabledFields() {
		// TODO Auto-generated method stub
	}

	@Override
	protected void modifyDisabledFields() {
	}

	@Override
	protected void deleteDisabledFields() {
		// TODO Auto-generated method stub
	}

	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {};
	}

	@Override
	protected String[] getFetchInputParameters() {
		return new String[] {
				"searchCert".equals(currMode)?getCertNo().getText():currSlpNo,
				getCertNo().getText(),
				currMode
		};
	}

	public void saveAction() {
		setActionType(QueryUtil.ACTION_MODIFY);
		if (getSaveButton().isEnabled()) {
			actionValidation(ACTION_SAVE);
		}
	}

	@Override
	protected void actionValidation(final String actionType) {
		if (!getCertNo().isEmpty()) {
			MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Update OB Certificate Infofrmation?",
					new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						actionValidationReady(actionType, true);
					}
				}
			});
		} else {
			Factory.getInstance().addErrorMessage("Cert No can not be Empty!", getCertNo());
		}
	}


	@Override
	protected void actionValidationReady(final String actionType, boolean isValidationReady) {
		super.actionValidationReady(actionType, isValidationReady);
	}

	@Override
	protected void savePostAction() {
		if ("searchCert".equals(currMode)) {
			Factory.getInstance().addInformationMessage("Cert updated.");
		} else {
			Factory.getInstance().addInformationMessage("Cert added.");
			getPrintCert().setEnabled(true);
			getPrintConsent().setEnabled(true);

		}
		setAllRightFieldsEnabled(false);
		getModifyButton().setEnabled(true);
		getPrintCert().setEnabled(true);
		getPrintConsent().setEnabled(true);
		getRptBtn().setEnabled(true);
		getSaveButton().setEnabled(false);
	}

	@Override
	protected void getFetchOutputValues(String[] outParam) {
		if (outParam != null && outParam.length > 0
				&& "searchCert".equals(currMode)
				&& "".equals(getCertNo().getText())
				&& "".equals(getBooking().getText())) {
			getCertNo().setText(outParam[0]);
		} else if (outParam != null && outParam.length > 0) {
			updateContent(outParam);
		}
	}

	@Override
	protected String[] getActionInputParamaters() {
		if ("searchCert".equals(currMode)) {
			return
				new String[] {
					currMode,
					getCertNo().getText(),
					getBooking().getText(),
					getPatNo().getText(),
					getPatName().getText(),
					getPatNameChi().getText(),
					getPatDOB().getText(),
					getPatDocExPmOpt().isSelected()?"L":"O",
					"".equals(getPatDocExPm().getText())?
							getPatDocOther().getText():getPatDocExPm().getText(),
					getPatPRtYesOpt().isSelected()?"Y":
						(getPatPRtNoOpt().isSelected()?"N":"U"),
					getPatCaseDr().getText(),
					getDrMCH().getText(),
					getDrTelPgr().getText(),
					getPatAntDate1().getText(),
					getPatAntDate2().getText(),
					getPatAntDate3().getText(),
					getPatAntDate4().getText(),
					getPatAntDate5().getText(),
					getPatAntDate6().getText(),
					getPatEDC().getText(),
					getPatHusName().getText(),
					getPatHusNameChi().getText(),
					getPatHusID().getText(),
					getPatPRtYesOpt().isSelected()?"Y":
						(getPatPRtNoOpt().isSelected()?"N":"U"),
					getPatHusDOB().getText(),
					getPatMDate().getText(),
					getPatMCertNo().getText(),
					getCertIssDate().getText(),
					getCertIssBy().getText(),
					getStatusComBo().getText(),
					getCertValTil().getText(),
					getUpdateDt().getText(),
					getRepltRsnComBo().getText(),
					getNewCert().getText(),getUserInfo().getUserID()};
		} else {
			return
				new String[] {
					currMode,
					getCertNo().getText(),
					getBooking().getText(),
					getPatNo().getText(),
					getPatName().getText(),
					getPatNameChi().getText(),
					getPatDOB().getText(),
					getPatDocExPmOpt().isSelected()?"L":"O",
						"".equals(getPatDocExPm().getText())?
							getPatDocOther().getText():getPatDocExPm().getText(),
					getPatPRtYesOpt().isSelected()?"Y":
						(getPatPRtNoOpt().isSelected()?"N":"U"),
					getPatCaseDr().getText(),
					getDrMCH().getText(),
					getDrTelPgr().getText(),
					getPatAntDate1().getText(),
					getPatAntDate2().getText(),
					getPatAntDate3().getText(),
					getPatAntDate4().getText(),
					getPatAntDate5().getText(),
					getPatAntDate6().getText(),
					getPatEDC().getText(),
					getPatHusName().getText(),
					getPatHusNameChi().getText(),
					getPatHusID().getText(),
					getPatPRtYesOpt().isSelected()?"Y":
						(getPatPRtNoOpt().isSelected()?"N":"U"),
					getPatHusDOB().getText(),
					getPatMDate().getText(),
					getPatMCertNo().getText(),
					getCertIssDate().getText(),
					getCertIssBy().getText(),
					"1",
					getCertValTil().getText(),
					"","","",""};
		}
	}

	@Override
	public String getTxCode() {
		return ConstantsTx.OBPRTCERT_TXCODE;
	}

	@Override
	public String getTitle() {
		return ConstantsTx.OBPRTCERT_TITLE;
	}

	@Override
	protected void enableButton(String mode) {
		setSearchButtonEnabled(false);

		super.enableButton(mode);
		if(!"newCert".equals(currMode)) {
			getPrintCert().setEnabled(true);
			getPrintConsent().setEnabled(true);
			getRptBtn().setEnabled(true);
			getModifyButton().setEnabled(true);
		}
		if (("searchCert").equals(currMode)) {
			setAllRightFieldsEnabled(true);
			getModifyButton().setEnabled(false);
			getSaveButton().setEnabled(true);
		}
		setAllRightFieldsEnabled(true);

		getModifyButton().setEnabled(false);
		getSaveButton().setEnabled(true);

		getAppendButton().setEnabled(false);
		getDeleteButton().setEnabled(false);
	}

	private void updateContent(MessageQueue mQueue) {
		if (mQueue.success()) {
			String[] outParam = mQueue.getContentField();
			updateContent(outParam);
		}
	}

	private void updateContent(String[] outParam) {
		int index = 0;
		  getBooking().setText(outParam[index++]);
		  getPatName().setText(outParam[index++]);
		  getPatNameChi().setText(outParam[index++]);
		  getPatNo().setText(outParam[index++]);
		  getPatDOB().setText(outParam[index++]);
		  if ("L".equals(outParam[index++])) {
			  getPatDocExPmOpt().setSelected(true);
			  getPatDocExPm().setText(outParam[index++]);
			  getPatDocOther().setEditable(false);
		  } else {
			  getPatDocOtherOpt().setSelected(true);
			  getPatDocOther().setText(outParam[index++]);
			  getPatDocExPm().setEditable(false);
		  }
		  getPatHusName().setText(outParam[index++]);
		  getPatHusNameChi().setText(outParam[index++]);
		  getPatHusID().setText(outParam[index++]);
		  String tempHusDocType = outParam[index++];
		  if ("".equals(tempHusDocType) || "U".equals(tempHusDocType)) {
			  getPatPRtUknOpt().setSelected(true);
		  } else if ("1".equals(tempHusDocType)||"3".equals(tempHusDocType)
					|| "4".equals(tempHusDocType) || "6".equals(tempHusDocType)
					|| "7".equals(tempHusDocType) || "9".equals(tempHusDocType)
					|| "G".equals(tempHusDocType) || "J".equals(tempHusDocType)
					|| "K".equals(tempHusDocType) || "N".equals(tempHusDocType)
					|| "I".equals(tempHusDocType) || "Y".equals(tempHusDocType)) {
			  getPatPRtYesOpt().setSelected(true);
		  } else {
			  getPatPRtNoOpt().setSelected(true);
		  }
		  getPatHusDOB().setText(outParam[index++]);
		  index++;
		  getPatCaseDr().setText(outParam[index++]);
		  getDrMCH().setText(outParam[index++]);
		  getDrTelPgr().setText(outParam[index++]);
		  getPatAntDate1().setText(outParam[index++]);
		  getPatAntDate2().setText(outParam[index++]);
		  getPatAntDate3().setText(outParam[index++]);
		  getPatAntDate4().setText(outParam[index++]);
		  getPatAntDate5().setText(outParam[index++]);
		  getPatAntDate6().setText(outParam[index++]);
		  getPatEDC().setText(outParam[index++]);
		  getCertValTil().setText(outParam[index++]);
		  patSex = outParam[index++];
		  if (!"newCert".equals(currMode)) {
			  getCertIssBy().setText(outParam[index++]);
			  getCertIssDate().setText(outParam[index++]);
			  getCertValTil().setText(outParam[index++]);
			  getStatusComBo().setText(outParam[index++]);
			  getRepltRsnComBo().setText(outParam[index++]);
			  getUpdateDt().setText(outParam[index++]);
			  getNewCert().setText(outParam[index++]);
		  }

		  if ("newCert".equals(currMode)&& getCertNo().isEmpty()) {
			  getCertNo().setText(outParam[index+7]);
		  }

		  setRecordFound(true);
	}

	public FieldSetBase getInfoPanel() {
			if (InfoPanel == null) {
				InfoPanel = new FieldSetBase();
				InfoPanel.setHeading("Printing OB Certificate");
				InfoPanel.setBounds(5, 5, 770, 770);
				InfoPanel.add(getBkNoDesc(), null);
				InfoPanel.add(getBooking(), null);
				InfoPanel.add(getCertNoDesc(), null);
				InfoPanel.add(getCertNo(), null);
				InfoPanel.add(getRptBtn(), null);
				InfoPanel.add(getSubInfoPanel(), null);
			}
			return InfoPanel;
	}

	public FieldSetBase getDlgPanel() {
		if (dlgPanel == null) {
			dlgPanel = new FieldSetBase();
			dlgPanel.add(getDlgToDateDesc(), null);
			dlgPanel.add(getDlgToDate(), null);
			dlgPanel.setBounds(5, 5, 360, 100);
		}
		return dlgPanel;
	}

	public FieldSetBase getSubInfoPanel() {
		if (subInfoPanel == null) {
			subInfoPanel = new FieldSetBase();
			subInfoPanel.setBounds(5, 5, 770, 740);
			subInfoPanel.setBorders(false);
			subInfoPanel.add(getHosNameEnDesc(), null);
			subInfoPanel.add(getHosNameEn(), null);
			subInfoPanel.add(getHosNameChiDesc(), null);
			subInfoPanel.add(getHosNameChi(), null);
			subInfoPanel.add(getPatNameDesc(), null);
			subInfoPanel.add(getPatName() , null);
			subInfoPanel.add(getPatNameChiDesc(), null);
			subInfoPanel.add(getPatNameChi(), null);
			subInfoPanel.add(getPatNoDesc(), null);
			subInfoPanel.add(getPatNo(), null);
			subInfoPanel.add(getPatDOBDesc(), null);
			subInfoPanel.add(getPatDOB(), null);
			subInfoPanel.add(getPatDocExPmOpt(), null);
			subInfoPanel.add(getPatDocExPm(), null);
			subInfoPanel.add(getPatDocOtherOpt(), null);
			subInfoPanel.add(getPatDocOther(), null);
			subInfoPanel.add(getPatHusNameDesc(), null);
			subInfoPanel.add(getPatHusName(), null);
			subInfoPanel.add(getPatHusNameChiDesc(), null);
			subInfoPanel.add(getPatHusNameChi(), null);
			subInfoPanel.add(getPatHusIDDesc(), null);
			subInfoPanel.add(getPatHusID(), null);
			subInfoPanel.add(getPatSpseOfHKRtDesc(), null);
			subInfoPanel.add(getPatPRtYesOpt(), null);
			subInfoPanel.add(getPatPRtNoOpt(), null);
			subInfoPanel.add(getPatPRtUknOpt(), null);
			subInfoPanel.add(getPatHusDOBDesc(), null);
			subInfoPanel.add(getPatHusDOB(), null);
			subInfoPanel.add(getPatCaseDrDesc(), null);
			subInfoPanel.add(getPatCaseDr(), null);
			subInfoPanel.add(getDrMCHDesc(), null);
			subInfoPanel.add(getDrMCH(), null);
			subInfoPanel.add(getDrTelPgrDesc(), null);
			subInfoPanel.add(getDrTelPgr(), null);
			subInfoPanel.add(getPatAntDateDesc(), null);
			subInfoPanel.add(getPatAntDate1(), null);
			subInfoPanel.add(getPatAntDate2(), null);
			subInfoPanel.add(getPatAntDate3(), null);
			subInfoPanel.add(getPatAntDate4(), null);
			subInfoPanel.add(getPatAntDate5(), null);
			subInfoPanel.add(getPatAntDate6(), null);
			subInfoPanel.add(getPatEDCDesc(), null);
			subInfoPanel.add(getPatEDC(), null);
			subInfoPanel.add(getCertValTilDesc(), null);
			subInfoPanel.add(getCertValTil(), null);
			subInfoPanel.add(getCertIssBy(), null);
			subInfoPanel.add(getCertIssDate(), null);
			subInfoPanel.add(getCertIssByDesc(), null);
			subInfoPanel.add(getCertIssDateDesc(), null);
			subInfoPanel.add(getPatMCertNoDesc(), null);
			subInfoPanel.add(getPatMCertNo(), null);
			subInfoPanel.add(getPatMDateDesc(), null);
			subInfoPanel.add(getPatMDate(), null);
			subInfoPanel.add(getPrintCert(), null);
			subInfoPanel.add(getPrintConsent(), null);
			subInfoPanel.add(getLinePanel(), null);
			subInfoPanel.add(getStatusDesc(), null);
			subInfoPanel.add(getStatusComBo(), null);
			subInfoPanel.add(getRepltRsnComBo(), null);
			subInfoPanel.add(getRepltRsnDesc(), null);
			subInfoPanel.add(getUpdateDtDesc(), null);
			subInfoPanel.add(getUpdateDt(), null);
			subInfoPanel.add(getNewCertDesc(), null);
			subInfoPanel.add(getNewCert(), null);
		}
		return subInfoPanel;
	}

	public LabelBase getBkNoDesc() {
		if (bkNoDesc == null) {
			bkNoDesc = new LabelBase();
			bkNoDesc.setText("Booking No:");
			bkNoDesc.setBounds(5, 0, 80, 20);
		}
		return bkNoDesc;
	}

	public TextString getBooking() {
		if (bookingNo == null) {
			bookingNo = new TextString() {
				@Override
				public void onBlur() {
					if (!bookingNo.isEmpty()&& !isModify()) {
						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.OBPRTCERT_TXCODE,
								new String[] {
									bookingNo.getText(),"",
									("newCert".equals(currMode))?"seachCtByBkNo":"searchCert"
								}, new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									updateContent(mQueue);
									getSubInfoPanel().setVisible(true);
									getBkNoDesc().setVisible(true);
									getBooking().setVisible(true);
								} else {
									Factory.getInstance().addErrorMessage("This Booking Number does not exist");
									resetCurrentFields();
									getSubInfoPanel().setVisible(false);
									getBkNoDesc().setVisible(false);
									getBooking().setVisible(false);
								}
							}
						});
					} else {
						resetCurrentFields();
						getSubInfoPanel().setVisible(false);
					}
				}
			};
			bookingNo.setBounds(90, 0, 180, 20);
		}
		return bookingNo;
	}

	public LabelBase getCertNoDesc() {
		if (certNoDesc == null) {
			certNoDesc = new LabelBase();
			certNoDesc.setText("Certificate No:");
			certNoDesc.setBounds(322, 0, 80, 20);
		}
		return certNoDesc;
	}

	public TextString getCertNo() {
		if (certNo == null) {
			certNo = new TextString() {
				@Override
				public void onBlur() {
					if ("searchCert".equals(currMode) && !certNo.isEmpty()) {
						QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.OBPRTCERT_TXCODE,
								new String[] {
									"",getCertNo().getText(),currMode
								}, new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									updateContent(mQueue);
									getSubInfoPanel().setVisible(true);
									getBkNoDesc().setVisible(true);
									getBooking().setVisible(true);
								} else {
									Factory.getInstance().addErrorMessage("This Cert does not exist");
									getSubInfoPanel().setVisible(false);
									getBkNoDesc().setVisible(false);
									getBooking().setVisible(false);
								}
							}
						});
					}
				}
			};
			certNo.setBounds(404, 0, 180, 20);
		}
		return certNo;
	}

	public LabelBase getHosNameEnDesc() {
		if (hosNameEnDesc == null) {
			hosNameEnDesc = new LabelBase();
			hosNameEnDesc.setText("Hospital Name(English):");
			hosNameEnDesc.setBounds(5, 30, 140, 20);
		}
		return hosNameEnDesc;
	}

	public TextString getHosNameEn() {
		 if (hosNameEn == null) {
			hosNameEn = new TextString();
			hosNameEn.setText("Hong Kong Adventist Hospital");
			hosNameEn.setReadOnly(true);
			hosNameEn.setBounds(147, 30, 170, 20);
		}
		return hosNameEn;
	}

	public LabelBase getHosNameChiDesc() {
		if (hosNameChiDesc == null) {
			hosNameChiDesc = new LabelBase();
			hosNameChiDesc.setText("Chinese:");
			hosNameChiDesc.setBounds(322, 30, 50, 20);
		}
		return hosNameChiDesc;
	}

	public TextString getHosNameChi() {
		if (hosNameChi == null) {
			hosNameChi = new TextString();
			hosNameChi.setText("��w��|");
			hosNameChi.setReadOnly(true);
			hosNameChi.setBounds(374,30,130, 20);
		}
		return hosNameChi;
	}

	public LabelBase getPatNameDesc() {
		if (patNameDesc == null) {
			patNameDesc = new LabelBase();
			patNameDesc.setText("Name (English):");
			patNameDesc.setBounds(5, 54, 100, 20);
		}
		return patNameDesc;
	}

	public TextString getPatName() {
		if (patName == null) {
			patName = new TextString(82);
			patName.setBounds(105, 54, 170, 20);
		}
		return patName;
	}

	public LabelBase getPatNameChiDesc() {
		if (patNameChiDesc == null) {
			patNameChiDesc = new LabelBase();
			patNameChiDesc.setText("Name (Chinese): ");
			patNameChiDesc.setBounds(322, 54, 110, 20);
		}
		return patNameChiDesc;
	}

	public TextString getPatNameChi() {
		if (patNameChi == null) {
			patNameChi = new TextString();
			patNameChi.setBounds(434, 54, 120, 20);
		}
		return patNameChi;
	}

	public LabelBase getPatNoDesc() {
		if (patNoDesc == null) {
			patNoDesc = new LabelBase();
			patNoDesc.setText("Hospital Number: ");
			patNoDesc.setBounds(5, 78, 100, 20);
		}
		return patNoDesc;
	}

	public TextString getPatNo() {
		if (patNo == null) {
			patNo = new TextString();
			patNo.setBounds(107, 78, 100, 20);
		}
		return patNo;
	}

	public LabelBase getPatDOBDesc() {
		if (patDOBDesc == null) {
			patDOBDesc = new LabelBase();
			patDOBDesc.setText("Date Of Birth");
			patDOBDesc.setBounds(322, 78, 80, 20);
		}
		return patDOBDesc;
	}

	public TextDateTime getPatDOB() {
		if (patDOB == null) {
			patDOB = new TextDateTime(true, false);
			patDOB.setBounds(404, 78, 100, 20);
		}
		return patDOB;
	}

	public RadioButtonBase getPatDocExPmOpt() {
		if (patDocExPmOpt == null) {
			patDocExPmOpt = new RadioButtonBase() {
				@Override
				public void onClick() {
					getPatDocOther().resetText();
					getPatDocOther().setEditable(false);
					getPatDocExPm().setEditable(true);
				}
			};
			patDocExPmOpt.setText("Exit-entry Permit: ");
			patDocExPmOpt.setSelected(false);
			patDocExPmOpt.setBounds(5, 115, 110, 20);
		}
		return patDocExPmOpt;
	}

	public TextString getPatDocExPm() {
		if (patDocExPm == null) {
			patDocExPm = new TextString();
			patDocExPm.setBounds(123, 110, 160, 20);
		}
		return patDocExPm;
	}

	public RadioButtonBase getPatDocOtherOpt() {
		if (patDocOtherOpt == null) {
			patDocOtherOpt = new RadioButtonBase() {
				@Override
				public void onClick() {
					getPatDocExPm().resetText();
					getPatDocExPm().setEditable(false);
					getPatDocOther().setEditable(true);
				}
			};
			patDocOtherOpt.setText("Others: ");
			patDocOtherOpt.setSelected(false);
			patDocOtherOpt.setBounds(322, 110, 60, 20);
		}
		return patDocOtherOpt;
	}

	public TextString getPatDocOther() {
		if (patDocOther == null) {
			patDocOther = new TextString();
			patDocOther.setBounds(386, 110, 140, 20);
		}
		return patDocOther;
	}

	public LabelBase getPatHusNameDesc() {
		if (patHusNameDesc == null) {
			patHusNameDesc = new LabelBase();
			patHusNameDesc.setText("Husb Name(Eng): ");
			patHusNameDesc.setBounds(5, 135, 120, 20);
		}
		return patHusNameDesc;
	}

	public TextString getPatHusName() {
		if (patHusName == null) {
			patHusName = new TextString();
			patHusName.setBounds(127, 135, 180, 20);
		}
		return patHusName;
	}

	public LabelBase getPatHusNameChiDesc() {
		if (patHusNameChiDesc == null) {
			patHusNameChiDesc = new LabelBase();
			patHusNameChiDesc.setText("Husb Name(Chi):");
			patHusNameChiDesc.setBounds(322, 135, 100, 20);
		}
		return patHusNameChiDesc;
	}

	public TextString getPatHusNameChi() {
		if (patHusNameChi == null) {
			patHusNameChi = new TextString();
			patHusNameChi.setBounds(424, 135, 100, 20);
		}
		return patHusNameChi;
	}

	public LabelBase getPatHusIDDesc() {
		if (patHusIDDesc == null) {
			patHusIDDesc = new LabelBase();
			patHusIDDesc.setText("Husb ID: ");
			patHusIDDesc.setBounds(526, 135, 80, 20);
		}
		return patHusIDDesc;
	}

	public TextString getPatHusID() {
		if (patHusID == null) {
			patHusID = new TextString();
			patHusID.setBounds(590, 135, 100, 20);
		}
		return patHusID;
	}

	public LabelBase getPatSpseOfHKRtDesc() {
		if (patSpseOfHKRtDesc == null) {
			patSpseOfHKRtDesc = new LabelBase();
			patSpseOfHKRtDesc.setText("Spouse of Hong Kong permanent resident:");
			patSpseOfHKRtDesc.setBounds(5, 165, 240, 20);
		}
		return patSpseOfHKRtDesc;
	}

	public RadioButtonBase getPatPRtYesOpt() {
		if (patPRtYesOpt == null) {
			patPRtYesOpt = new RadioButtonBase();
			patPRtYesOpt.setText("Yes");
			patPRtYesOpt.setBounds(247, 165, 5, 20);
		}
		return patPRtYesOpt;
	}

	public RadioButtonBase getPatPRtNoOpt() {
		if (patPRtNoOpt == null) {
			patPRtNoOpt = new RadioButtonBase();
			patPRtNoOpt.setText("No");
			patPRtNoOpt.setBounds(300, 165, 5, 20);
		}
		return patPRtNoOpt;
	}

	public RadioButtonBase getPatPRtUknOpt() {
		if (patPRtUknOpt == null) {
			patPRtUknOpt = new RadioButtonBase();
			patPRtUknOpt.setText("Unknown");
			patPRtUknOpt.setBounds(350, 165, 10, 20);
		}
		return patPRtUknOpt;
	}

	public LabelBase getPatHusDOBDesc() {
		if (patHusDOBDesc == null) {
			patHusDOBDesc = new LabelBase();
			patHusDOBDesc.setText("Husb DOB: ");
			patHusDOBDesc.setBounds(526, 165, 70, 20);
		}
		return patHusDOBDesc;
	}

	public TextDateTime getPatHusDOB() {
		if (patHusDOB == null) {
			patHusDOB = new TextDateTime(true, false);
			patHusDOB.setBounds(590, 165, 120, 20);
		}
		return patHusDOB;
	}

	public LabelBase getPatCaseDrDesc() {
		if (patCaseDrDesc == null) {
			patCaseDrDesc = new LabelBase();
			patCaseDrDesc.setText("Name of Case Doctor:");
			patCaseDrDesc.setBounds(5, 195, 128, 20);
		}
		return patCaseDrDesc;
	}

	public TextString getPatCaseDr() {
		if (patCaseDr == null) {
			patCaseDr = new TextString();
			patCaseDr.setBounds(130, 195, 250, 20);
		}
		return patCaseDr;
	}

	public LabelBase getDrMCHDesc() {
		if (drMCHDesc == null) {
			drMCHDesc = new LabelBase();
			drMCHDesc.setText("MCHK Registration Number:");
			drMCHDesc.setBounds(5, 225, 160, 20);
		}
		return drMCHDesc;
	}

	public TextString getDrMCH() {
		if (drMCH == null) {
			drMCH = new TextString();
			drMCH.setBounds(166, 225, 200, 20);
		}
		return drMCH;
	}

	public LabelBase getDrTelPgrDesc() {
		if (drTelPgrDesc == null) {
			drTelPgrDesc = new LabelBase();
			drTelPgrDesc.setText("Telephone /Pager Number:");
			drTelPgrDesc.setBounds(380, 225, 155, 20);
		}
		return drTelPgrDesc;
	}

	public TextString getDrTelPgr() {
		if (drTelPgr == null) {
			drTelPgr = new TextString();
			drTelPgr.setBounds(535, 225, 200, 20);
		}
		return drTelPgr;
	}

	public LabelBase getPatAntDateDesc() {
		if (patAntDateDesc == null) {
			patAntDateDesc = new LabelBase();
			patAntDateDesc.setText("Date(s) of Antenatal Check-up Conducted by Case Doctor:");
			patAntDateDesc.setBounds(5, 255, 155, 20);
		}
		return patAntDateDesc;
	}


	public TextDateTime getPatAntDate1() {
		if (patAntDate1 == null) {
			patAntDate1 = new TextDateTime(true, false);
			patAntDate1.setBounds(162, 255, 100, 20);
		}
		return patAntDate1;
	}

	public TextDateTime getPatAntDate2() {
		if (patAntDate2 == null) {
			patAntDate2 = new TextDateTime(true, false);
			patAntDate2.setBounds(263, 255, 100, 20);
		}
		return patAntDate2;
	}

	public TextDateTime getPatAntDate3() {
		if (patAntDate3 == null) {
			patAntDate3 = new TextDateTime(true, false);
			patAntDate3.setBounds(364, 255, 100, 20);
		}
		return patAntDate3;
	}

	public TextDateTime getPatAntDate4() {
		if (patAntDate4 == null) {
			patAntDate4 = new TextDateTime(true, false);
			patAntDate4.setBounds(162, 277, 100, 20);
		}
		return patAntDate4;
	}

	public TextDateTime getPatAntDate5() {
		if (patAntDate5 == null) {
			patAntDate5 = new TextDateTime(true, false);
			patAntDate5.setBounds(263, 277, 100, 20);
		}
		return patAntDate5;
	}

	public TextDateTime getPatAntDate6() {
		if (patAntDate6 == null) {
			patAntDate6 = new TextDateTime(true, false);
			patAntDate6.setBounds(364, 277, 100, 20);
		}
		return patAntDate6;
	}

	public LabelBase getPatEDCDesc() {
		if (patEDCDesc == null) {
			patEDCDesc = new LabelBase();
			patEDCDesc.setText("Expected Date of Confinement:");
			patEDCDesc.setBounds(5, 307, 175, 20);
		}
		return patEDCDesc;
	}

	public TextDateTime getPatEDC() {
		if (patEDC == null) {
			patEDC = new TextDateTime(true, false);
			patEDC.setBounds(180, 307, 90, 20);
		}
		return patEDC;
	}

	public LabelBase getCertValTilDesc() {
		if (certValTilDesc == null) {
			certValTilDesc = new LabelBase();
			certValTilDesc.setText("This Certificate is Valid Until:");
			certValTilDesc.setBounds(280, 307, 165, 20);
		}
		return certValTilDesc;
	}

	public TextDateTime getCertValTil() {
		if (certValTil == null) {
			certValTil = new TextDateTime(true, false);
			certValTil.setBounds(445, 307, 90, 20);
		}
		return certValTil;
	}

	public LabelBase getCertIssByDesc() {
		if (certIssByDesc == null) {
			certIssByDesc = new LabelBase();
			certIssByDesc.setText("Issued By:");
			certIssByDesc.setBounds(5, 337, 65, 20);
		}
		return certIssByDesc;
	}

	public TextString getCertIssBy() {
		if (certIssBy == null) {
			certIssBy = new TextString();
			certIssBy.setBounds(70,337,200, 20);
		}
		return certIssBy;
	}

	public LabelBase getCertIssDateDesc() {
		if (certIssDateDesc == null) {
			certIssDateDesc = new LabelBase();
			certIssDateDesc.setText("Date of Issue:");
			certIssDateDesc.setBounds(310, 337, 100, 20);
		}
		return certIssDateDesc;
	}

	public TextDateTime getCertIssDate() {
		if (certIssDate == null) {
			certIssDate = new TextDateTime(true, false);
			certIssDate.setBounds(445, 337, 90, 20);
		}
		return certIssDate;
	}

	public LabelBase getPatMCertNoDesc() {
		if (patMCertNoDesc == null) {
			patMCertNoDesc = new LabelBase();
			patMCertNoDesc.setText("Marriage Cert:");
			patMCertNoDesc.setBounds(5, 367, 65, 20);
		}
		return patMCertNoDesc;
	}

	public TextString getPatMCertNo() {
		if (patMCertNo == null) {
			patMCertNo = new TextString();
			patMCertNo.setBounds(70, 367, 200, 20);
		}
		return patMCertNo;
	}

	public LabelBase getPatMDateDesc() {
		if (patMDateDesc == null) {
			patMDateDesc = new LabelBase();
			patMDateDesc.setText("Date of Marriage:");
			patMDateDesc.setBounds(310, 367, 100, 20);
		}
		return patMDateDesc;
	}

	public TextDateTime getPatMDate() {
		if (patMDate == null) {
			patMDate = new TextDateTime(true, false);
			patMDate.setBounds(445, 367, 90, 20);
		}
		return patMDate;
	}

	public ButtonBase getPrintCert() {
		if (printCert == null) {
			printCert = new ButtonBase() {
				@Override
				public void onClick() {
					Map<String, String> map = new HashMap<String, String>();
					map.put("SUBREPORT_DIR",CommonUtil.getReportDir());
					map.put("ImgTick", CommonUtil.getReportImg("tick.gif"));
					map.put("HospitalNo", getPatNo().getText());
					map.put("PatName"   , getPatName().getText());
					map.put("PatCName"  , getPatNameChi().getText());
					map.put("DOB"       , getPatDOB().getText());
					map.put("PatIdNo"   , "".equals(getPatDocExPm().getText())?
												getPatDocOther().getText():getPatDocExPm().getText());
					map.put("ExDate"    , getPatEDC().getText());
					map.put("IssueDt"   , getCertIssDate().getText());
					map.put("EXDate60"  , getCertValTil().getText());
					map.put("patdoctype", getPatDocExPmOpt().isSelected()?"E":"O");
					map.put("docname"  ,  getPatCaseDr().getText());
					map.put("docptel"   , getDrTelPgr().getText());
					map.put("hkmclicno" , getDrMCH().getText());
					map.put("antchkdt1" , getPatAntDate1().getText());
					map.put("antchkdt2" , getPatAntDate2().getText());
					map.put("antchkdt3" , getPatAntDate3().getText());
					map.put("antchkdt4" , getPatAntDate4().getText());
					map.put("antchkdt5" , getPatAntDate5().getText());
					map.put("antchkdt6" , getPatAntDate6().getText());
					map.put("faCname"   , getPatHusNameChi().getText());
					map.put("husname"  ,  getPatHusName().getText());
					map.put("faHkic"    , getPatHusID().getText());
					map.put("IssueBy"   , getCertIssBy().getText());
					PrintingUtil.print("", "PrintOBCert_"+getSysParameter("curtSite"),
							map, null);
				}
			};
			printCert.setText("Print Cert");
			printCert.setBounds(10, 407, 100, 30);
		}
		return printCert;
	}

	public ButtonBase getPrintConsent() {
		if (printConsent == null) {
			printConsent = new ButtonBase() {
				@Override
				public void onClick() {
					Map<String, String> map = new HashMap<String, String>();
					map.put("PatIdNo", "".equals(getPatDocExPm().getText())?
							getPatDocOther().getText():getPatDocExPm().getText());
					map.put("PatName", getPatName().getText());
					map.put("PatCName", getPatNameChi().getText());
					map.put("IssueDt", getCertIssDate().getText());
					map.put("DOB", getPatDOB().getText());
					map.put("LogoImg", CommonUtil.getReportImg
							(Factory.getInstance().getSysParameter("curtSite")+"_rpt_logo.jpg"));
					map.put("patSex", patSex);
					map.put("patNo", getPatNo().getText());
					map.put("certNo",getCertNo().getText());
					map.put("ImgTick", CommonUtil.getReportImg("tick.gif"));
					map.put("SUBREPORT_DIR",CommonUtil.getReportDir());
					PrintingUtil.print("", "PrintOBCertConsent_"+getSysParameter("curtSite"),
							map, null);
				}
			};
			printConsent.setText("Print Consent Form");
			printConsent.setBounds(132, 407, 120, 30);
		}
		return printConsent;
	}

	public ButtonBase getRptBtn() {
		if (rptBtn == null) {
			rptBtn = new ButtonBase() {
				@Override
				public void onClick() {
					showToDateDlg();
				}
			};
			rptBtn.setText("Print Weekly Report");
			rptBtn.setBounds(10, 470, 120, 30);
		}
		return rptBtn;
	}

	public BasePanel getLinePanel() {
		if (linePanel  == null) {
			linePanel = new BasePanel();
			linePanel.setBounds(10, 340, 725, 5);
			linePanel.add(getLine(), null);
		}
		return linePanel;
	}

	public HTML getLine() {
		if (Line == null) {
			Line = new HTML("<hr COLOR=\"red\" />");
		}
		return Line;
	}

	public LabelBase getStatusDesc() {
		if (statusDesc  == null) {
			statusDesc = new LabelBase();
			statusDesc.setText("Status:");
			statusDesc.setBounds(5, 375, 40, 20);
		}
		return statusDesc;
	}

	public ComboBoxBase getStatusComBo() {
		if (statusCombo == null) {
			statusCombo = new ComboBoxBase("OBCERT", new String[]{"status"}, false);
			statusCombo.setBounds(42, 375, 220, 20);
		}
		return statusCombo;
	}

	public LabelBase getRepltRsnDesc() {
		if (repltRsnDesc  == null) {
			repltRsnDesc = new LabelBase();
			repltRsnDesc.setText("Reason for Replacement:");
			repltRsnDesc.setBounds(280, 375, 160, 20);
		}
		return repltRsnDesc;
	}

	public ComboBoxBase getRepltRsnComBo() {
		if (repltRsnCombo == null) {
			repltRsnCombo = new ComboBoxBase("OBCERT", new String[]{"repltrsn"}, false);
			repltRsnCombo.setBounds(445, 375, 220, 20);
		}
		return repltRsnCombo;
	}

	public LabelBase getUpdateDtDesc() {
		if (updateDtDesc  == null) {
			updateDtDesc = new LabelBase();
			updateDtDesc.setText("Update Date:");
			updateDtDesc.setBounds(5, 405, 60, 20);
		}
		return updateDtDesc;
	}

	public TextDateTime getUpdateDt() {
		if (updateDt == null) {
			updateDt = new TextDateTime(true, false);
			updateDt.setBounds(70, 405, 120, 20);
		}
		return updateDt;
	}

	public LabelBase getNewCertDesc() {
		if (newCertDesc == null) {
			newCertDesc = new LabelBase();
			newCertDesc.setText("New Certificate:");
			newCertDesc.setBounds(280, 405, 120, 20);
		}
		return newCertDesc;
	}

	public TextString getNewCert() {
		if (newCert == null) {
			newCert = new TextString();
			newCert.setBounds(382, 405, 100, 20);
		}
		return newCert;
	}

	public LabelBase getDlgToDateDesc() {
		if (dlgToDateDesc == null) {
			dlgToDateDesc = new LabelBase();
			dlgToDateDesc.setText("To Date:");
			dlgToDateDesc.setBounds(5, 0, 300, 20);
		}
		return dlgToDateDesc;
	}

	public TextDateTime getDlgToDate() {
		if (dlgToDate  == null) {
			dlgToDate = new TextDateTime(true, false);
			dlgToDate.setBounds(5, 30, 200, 20);
		}
		return dlgToDate;
	}

	private void showToDateDlg() {
		if (toDateDialog == null) {
			toDateDialog = new DialogBase(getMainFrame(),Dialog.OKCANCEL) {
				@Override
				public void doOkAction() {
					Map<String, String> map = new HashMap<String, String>();
					PrintingUtil.print("", "RPTOBCERT", map, "",
							new String[] {
								getDlgToDate().getText()
							},
							new String[] {
							"CERTNO", "PATNAME", "PATCNAME", "PATNO",
							"PATDOB", "PATDOCTYPE", "PATIDNO", "ISHKSPOUSE",
							"DRNAME", "DRMCHKNO", "DRTEL", "ANTCHKDT1",
							"ANTCHKDT2", "ANTCHKDT3", "ANTCHKDT4",
							"ANTCHKDT5", "ANTCHKDT6", "PATEDC",
							"CISEDATE", "REMARK", "ISVALID", "invalidrsn",
							"cancelDate", "REPLTRSN", "HUSNAME",
							"HUSCNAME", "HUSIDNO", "ISHUSHKPM",
							"HUSDOB", "PATMDATE", "PATMCTNO"
							},
							0, null, null, null, null, 1,
							false, true, new String[] { "xls" });
					hide();
				}
			};
			toDateDialog.setTitle("Print Report");
			toDateDialog.setBounds(320, 260, 300, 200);
			toDateDialog.add(getDlgPanel(), null);
		}
		toDateDialog.setResizable(false);
		toDateDialog.setVisible(true);
	}
}