package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTransaction;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public abstract class DlgPkgCode extends DialogBase {

	private final static int m_frameWidth = 330;
	private final static int m_frameHeight = 240;

	private BasePanel panel = null;
	private LabelBase pkgCodeDesc = null;
	private TextString pkgCode = null;
	private LabelBase pkgStnSeqDesc = null;
	private TextNum pkgStnSeq = null;

	private String memFromForm = null;
	private String memTransactionID = null;
	private boolean memIsRegisteredExam = false;

	/**
	 * This method initializes
	 *
	 */
	public DlgPkgCode(MainFrame owner) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);

		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setContentPane(getPanel());
        setTitle("Move Patient Charges to Ref.");

		// change label
		getButtonById(OK).setText("Move", 'M');
	}

	public void showDialog() {
		showDialog(null, null, false);
	}

	public void showDialog(String fromForm, String transactionID) {
		showDialog(fromForm, transactionID, false);
	}

	public void showDialog(String fromForm, String transactionID, boolean isRegisteredExam) {
		memFromForm = fromForm;
		memTransactionID = transactionID;
		memIsRegisteredExam = isRegisteredExam;

		setVisible(true);

		getPkgCode().resetText();
		getPkgStnSeqDesc().setVisible(
				( memFromForm == null || memFromForm.length() == 0 || "TxnDetails".equals(memFromForm) )
				&&
				memIsRegisteredExam
		);
		getPkgStnSeq().resetText();
		getPkgStnSeq().setVisible(getPkgStnSeqDesc().isVisible());
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	// override by child class
	public abstract void afterVerifyAction(final String movePkgCode, final String movePkgStnSeq);

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	@Override
	public void doOkAction() {
		validatePkgCode();
	}

	public TextString getDefaultFocusComponent() {
		return getPkgCode();
	}

	private void validatePkgCode() {
		// ValidatePkgCode
		if (!getPkgCode().isEmpty()) {
			QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] {"Package", "PkgCode", "PkgCode='" + getPkgCode().getText().trim() +  "' and PkgType <> '" + ConstantsTransaction.PKGTX_TYPE_NATUREOFVISIT + "'"},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success() && mQueue.getContentField()[0].length()>0) {
						validateStnSeq();
					} else {
						Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_PKG_CODE, getPkgCode());
						getPkgCode().resetText();
					}
				}
			});
		} else {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_PKG_CODE, getPkgCode());
			getPkgCode().resetText();
		}
	}

	private void validateStnSeq() {
		// ValidateStnSeq
		if (memFromForm == null || memFromForm.length() == 0 || "TxnDetails".equals(memFromForm)) {
			if (getPkgStnSeqDesc().isVisible()) {
				if (!getPkgStnSeq().isEmpty()) {
					QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] {"sliptx fm,sliptx tag,xreg reg", "tag.dixref", "fm.Slpno=tag.Slpno AND fm.itmcode=tag.itmcode AND tag.dixref=reg.stnid AND fm.stnid='" + memTransactionID + "' AND tag.stnsts='" + ConstantsTransaction.SLIPTX_STATUS_NORMAL + "' and tag.stnseq='" + getPkgStnSeq().getText() + "'"},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success() && mQueue.getContentField()[0].length()>0) {
								afterVerifyAction(getPkgCode().getText(), getPkgStnSeq().getText());
								dispose();
							} else {
								Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_MOVE_REGISTERED_EXAM_SEQ_REQUIRED, getPkgStnSeq());
								getPkgStnSeq().resetText();
							}
						}
					});
				} else {
					Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_MOVE_REGISTERED_EXAM_SEQ_REQUIRED, getPkgStnSeq());
					getPkgStnSeq().resetText();
				}
			} else {
				afterVerifyAction(getPkgCode().getText(), getPkgStnSeq().getText());
				dispose();
			}
		} else {
			afterVerifyAction(getPkgCode().getText(), getPkgStnSeq().getText());
			dispose();
		}
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/**
	 * This method initializes panel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	private BasePanel getPanel() {
		if (panel == null) {
			panel = new BasePanel();
			panel.add(getPkgCodeDesc(), null);
			panel.add(getPkgCode(), null);
			panel.add(getPkgStnSeqDesc(), null);
			panel.add(getPkgStnSeq(), null);
		}
		return panel;
	}

	public LabelBase getPkgCodeDesc() {
		if (pkgCodeDesc == null) {
			pkgCodeDesc = new LabelBase();
			pkgCodeDesc.setBounds(45, 61, 90, 20);
			pkgCodeDesc.setText("Package Code");
		}
		return pkgCodeDesc;
	}

	public TextString getPkgCode() {
		if (pkgCode == null) {
			pkgCode = new TextString();
			pkgCode.setBounds(127, 61, 100, 20);
		}
		return pkgCode;
	}

	public LabelBase getPkgStnSeqDesc() {
		if (pkgStnSeqDesc == null) {
			pkgStnSeqDesc = new LabelBase();
			pkgStnSeqDesc.setBounds(45, 101, 90, 20);
			pkgStnSeqDesc.setText("Sequence");
		}
		return pkgStnSeqDesc;
	}

	public TextNum getPkgStnSeq() {
		if (pkgStnSeq == null) {
			pkgStnSeq = new TextNum();
			pkgStnSeq.setBounds(127, 101, 100, 20);
		}
		return pkgStnSeq;
	}
}