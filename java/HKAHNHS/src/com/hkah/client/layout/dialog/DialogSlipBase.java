package com.hkah.client.layout.dialog;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.LayoutContainer;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.event.CallbackListener;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.layout.textfield.TextSlipMergeSearch;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;
import com.hkah.shared.model.UserInfo;

public class DialogSlipBase extends DialogBase {

	private final static String DUPLICATED_SLIP_NO = "Duplicated Slip Number";
	private final static String REDUPLICATE_SLIP_NO = "Reduplicate Slip No.!";

	private BasePanel slipPanel = null;
	private ButtonBase slpNoDesc = null;
	private TextReadOnly slpNo = null;
	private ButtonBase saveMergeSlip = null;
	private LabelBase mergeWithDesc = null;
	private TextSlipMergeSearch mergeWith1 = null;
	private TextSlipMergeSearch mergeWith2 = null;
	private TextSlipMergeSearch mergeWith3 = null;
	private TextSlipMergeSearch mergeWith4 = null;
	private TextSlipMergeSearch mergeWith5 = null;
	private TextSlipMergeSearch mergeWith6 = null;
	private TextSlipMergeSearch mergeWith7 = null;
	private TextSlipMergeSearch mergeWith8 = null;
	private TextSlipMergeSearch mergeWith9 = null;
	private TextSlipMergeSearch mergeWith10 = null;

	private DlgSlipSetPrimary dlgSlipSetPrimary = null;

	private List<String> oldSlpNo = new ArrayList<String>();
	private String lang = null;
	private String memSLPNO = null;
	private String memSLPTYPE = null;

	public DialogSlipBase(MainFrame owner, String buttonType, int frameWidth, int frameHeight) {
		super(owner, buttonType, frameWidth, frameHeight);
	}

	public Component getDefaultFocusComponent() {
		return getMergeWith1();
	}

	/***************************************************************************
	 * Get/Set Method
	 **************************************************************************/

	protected String getLanguage() {
		return lang;
	}

	protected void setLanguage(String rptLang) {
		lang = rptLang;
	}

	protected String getMemSlipNo() {
		return memSLPNO;
	}

	protected void setMemSlipNo(String slpNo) {
		memSLPNO = slpNo;

		getSlpNo().setText(memSLPNO);
	}

	protected String getMemSlipType() {
		return memSLPTYPE;
	}

	protected void setMemSlipType(String slpType) {
		memSLPTYPE = slpType;
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	private void setExistingSlipEditable(boolean readOnly) {
		getMergeWith1().setEditable(getMergeWith1().getText().length() == 0 && readOnly);
		getMergeWith2().setEditable(getMergeWith2().getText().length() == 0 && readOnly);
		getMergeWith3().setEditable(getMergeWith3().getText().length() == 0 && readOnly);
		getMergeWith4().setEditable(getMergeWith4().getText().length() == 0 && readOnly);
		getMergeWith5().setEditable(getMergeWith5().getText().length() == 0 && readOnly);
		getMergeWith6().setEditable(getMergeWith6().getText().length() == 0 && readOnly);
		getMergeWith7().setEditable(getMergeWith7().getText().length() == 0 && readOnly);
		getMergeWith8().setEditable(getMergeWith8().getText().length() == 0 && readOnly);
		getMergeWith9().setEditable(getMergeWith9().getText().length() == 0 && readOnly);
		getMergeWith10().setEditable(getMergeWith10().getText().length() == 0 && readOnly);
	}

	protected void clearSlipField() {
		oldSlpNo.clear();

		getMergeWith1().resetText();
		getMergeWith2().resetText();
		getMergeWith3().resetText();
		getMergeWith4().resetText();
		getMergeWith5().resetText();
		getMergeWith6().resetText();
		getMergeWith7().resetText();
		getMergeWith8().resetText();
		getMergeWith9().resetText();
		getMergeWith10().resetText();
	}

	protected void loadOldSlipNo() {
		loadOldSlipNo(false);
	}

	protected void loadOldSlipNo(final boolean isAutoPrint) {
		setExistingSlipEditable(false);

		QueryUtil.executeMasterBrowse(
				getUserInfo(), ConstantsTx.GETPRIMARYSLIP_TXCODE, new String[] {getMemSlipNo()},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					String slpno = mQueue.getContentField()[0];
					if (slpno != null && slpno.length() > 0) {
						setMemSlipNo(slpno);
					}
				}
				setSlipNo(isAutoPrint);
			}
		});
	}

	private void setSlipNo(final boolean isAutoPrint) {
		QueryUtil.executeMasterBrowse(
				getUserInfo(), ConstantsTx.GETMERGEDSLIP_TXCODE, new String[] {getMemSlipNo()},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					int cnt = mQueue.getContentNum() - 1;
					if (cnt > 0) {
						getMergeWith1().setText(mQueue.getContentField()[0].replaceAll("<LINE/>", ConstantsVariable.EMPTY_VALUE));
						oldSlpNo.add(getMergeWith1().getText().trim());
						cnt--;
					}
					if (cnt > 0) {
						getMergeWith2().setText(mQueue.getContentField()[1].replaceAll("<LINE/>", ConstantsVariable.EMPTY_VALUE));
						oldSlpNo.add(getMergeWith2().getText().trim());
						cnt--;
					}
					if (cnt > 0) {
						getMergeWith3().setText(mQueue.getContentField()[2].replaceAll("<LINE/>", ConstantsVariable.EMPTY_VALUE));
						oldSlpNo.add(getMergeWith3().getText().trim());
						cnt--;
					}
					if (cnt > 0) {
						getMergeWith4().setText(mQueue.getContentField()[3].replaceAll("<LINE/>", ConstantsVariable.EMPTY_VALUE));
						oldSlpNo.add(getMergeWith4().getText().trim());
						cnt--;
					}
					if (cnt > 0) {
						getMergeWith5().setText(mQueue.getContentField()[4].replaceAll("<LINE/>", ConstantsVariable.EMPTY_VALUE));
						oldSlpNo.add(getMergeWith5().getText().trim());
						cnt--;
					}
					if (cnt > 0) {
						getMergeWith6().setText(mQueue.getContentField()[5].replaceAll("<LINE/>", ConstantsVariable.EMPTY_VALUE));
						oldSlpNo.add(getMergeWith6().getText().trim());
						cnt--;
					}
					if (cnt > 0) {
						getMergeWith7().setText(mQueue.getContentField()[6].replaceAll("<LINE/>", ConstantsVariable.EMPTY_VALUE));
						oldSlpNo.add(getMergeWith7().getText().trim());
						cnt--;
					}
					if (cnt > 0) {
						getMergeWith8().setText(mQueue.getContentField()[7].replaceAll("<LINE/>", ConstantsVariable.EMPTY_VALUE));
						oldSlpNo.add(getMergeWith8().getText().trim());
						cnt--;
					}
					if (cnt > 0) {
						getMergeWith9().setText(mQueue.getContentField()[8].replaceAll("<LINE/>", ConstantsVariable.EMPTY_VALUE));
						oldSlpNo.add(getMergeWith9().getText().trim());
						cnt--;
					}
					if (cnt > 0) {
						getMergeWith10().setText(mQueue.getContentField()[9].replaceAll("<LINE/>", ConstantsVariable.EMPTY_VALUE));
						oldSlpNo.add(getMergeWith10().getText().trim());
						cnt--;
					}
				}
				setExistingSlipEditable(true);

				if (isAutoPrint) {
					validation(true);
				}
			}
		});
	}

	@Override
	protected void doOkAction() {
		validation(true);
	}

	@Override
	protected void doYesAction() {
		validation(true);
	}

	@Override
	protected void doNoAction() {
		validation(false);
	}

	@Override
	protected void doCancelAction() {
		unlockSlips();
		super.doCancelAction();
	}

	protected void validation() {
		validation(true);
	}

	protected void validation(boolean printout) {
		checkDuplicate(printout);
	}

	protected int getOldSlpNoSize() {
		return oldSlpNo.size();
	}

	protected void bExistSlipNo(final boolean printout) {
		QueryUtil.executeMasterAction(getUserInfo(),
				"CHECKSLIPS",
				QueryUtil.ACTION_APPEND,
				new String[] {
					getMemSlipNo(),
					getMergeWith1().getText() + "," +
					getMergeWith2().getText() + "," +
					getMergeWith3().getText() + "," +
					getMergeWith4().getText() + "," +
					getMergeWith5().getText() + "," +
					getMergeWith6().getText() + "," +
					getMergeWith7().getText() + "," +
					getMergeWith8().getText() + "," +
					getMergeWith9().getText() + "," +
					getMergeWith10().getText()
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					setMergeSlip(getUserInfo(),
						getMemSlipNo(),
						getMergeWith1().getText().trim(),
						getMergeWith2().getText().trim(),
						getMergeWith3().getText().trim(),
						getMergeWith4().getText().trim(),
						getMergeWith5().getText().trim(),
						getMergeWith6().getText().trim(),
						getMergeWith7().getText().trim(),
						getMergeWith8().getText().trim(),
						getMergeWith9().getText().trim(),
						getMergeWith10().getText().trim(),
						printout);
				} else {
					Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
				}
			}
		});
	}

	protected void checkDuplicate(boolean printout) {
		if (getMemSlipNo().equals(getMergeWith1().getText().trim())) {
			Factory.getInstance().addErrorMessage(DUPLICATED_SLIP_NO, getMergeWith1());
		} else if (getMemSlipNo().equals(getMergeWith2().getText().trim())) {
			Factory.getInstance().addErrorMessage(DUPLICATED_SLIP_NO, getMergeWith2());
		} else if (getMemSlipNo().equals(getMergeWith3().getText().trim())) {
			Factory.getInstance().addErrorMessage(DUPLICATED_SLIP_NO, getMergeWith3());
		} else if (getMemSlipNo().equals(getMergeWith4().getText().trim())) {
			Factory.getInstance().addErrorMessage(DUPLICATED_SLIP_NO, getMergeWith4());
		} else if (getMemSlipNo().equals(getMergeWith5().getText().trim())) {
			Factory.getInstance().addErrorMessage(DUPLICATED_SLIP_NO, getMergeWith5());
		} else if (getMemSlipNo().equals(getMergeWith6().getText().trim())) {
			Factory.getInstance().addErrorMessage(DUPLICATED_SLIP_NO, getMergeWith6());
		} else if (getMemSlipNo().equals(getMergeWith7().getText().trim())) {
			Factory.getInstance().addErrorMessage(DUPLICATED_SLIP_NO, getMergeWith7());
		} else if (getMemSlipNo().equals(getMergeWith8().getText().trim())) {
			Factory.getInstance().addErrorMessage(DUPLICATED_SLIP_NO, getMergeWith8());
		} else if (getMemSlipNo().equals(getMergeWith9().getText().trim())) {
			Factory.getInstance().addErrorMessage(DUPLICATED_SLIP_NO, getMergeWith9());
		} else if (getMemSlipNo().equals(getMergeWith10().getText().trim())) {
			Factory.getInstance().addErrorMessage(DUPLICATED_SLIP_NO, getMergeWith10());
		} else {
			bExistSlipNo(printout);
		}
	}

	protected void lockSlips(String[] slips, final CallbackListener callbackListener) {
		QueryUtil.executeMasterAction(getUserInfo(),
				ConstantsTx.SLIPLOCK_TXCODE,
				QueryUtil.ACTION_APPEND,
				new String[] {
						Arrays.toString(slips).replaceAll("\\[", "").replaceAll("\\]", "").trim(),
						"Slip",
						CommonUtil.getComputerName(),
						getUserInfo().getUserID()
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (callbackListener != null) {
					callbackListener.handleRetBool(true, null, mQueue);
				} else {
					if (mQueue.success()) {
					}
				}
			}
		});
	}

	protected void unlockSlips() {
		unlockSlips(new String[] {
			//getMemSlipNo(),
			getMergeWith1().getText().trim(),
			getMergeWith2().getText().trim(),
			getMergeWith3().getText().trim(),
			getMergeWith4().getText().trim(),
			getMergeWith5().getText().trim(),
			getMergeWith6().getText().trim(),
			getMergeWith7().getText().trim(),
			getMergeWith8().getText().trim(),
			getMergeWith9().getText().trim(),
			getMergeWith10().getText().trim()
		});
	}

	private void unlockSlips(String[] slips) {
		QueryUtil.executeMasterAction(getUserInfo(),
				ConstantsTx.SLIPUNLOCK_TXCODE,
				QueryUtil.ACTION_APPEND,
				new String[] {
						Arrays.toString(slips).replaceAll("\\[", "").replaceAll("\\]", ""),
						"Slip",
						CommonUtil.getComputerName(),
						getUserInfo().getUserID()
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
			}
		});
	}

	protected void printReport() {}

	protected void postSetTextAction(final String slpno, final TextSlipMergeSearch slpnoField) {}

	protected void setMergeSlipReady(boolean ready, boolean printout) {
		if (ready) {
			loadOldSlipNo();
			if (printout) {
				dispose();
				printReport();
			}
		}
	}

	protected void setMergeSlip(final UserInfo userInfo, final String slpNo,
								final String sSlpNo1, final String sSlpNo2,
								final String sSlpNo3, final String sSlpNo4,
								final String sSlpNo5, final String sSlpNo6,
								final String sSlpNo7, final String sSlpNo8,
								final String sSlpNo9, final String sSlpNo10,
								boolean printout) {
		setMergeSlip(userInfo, slpNo, sSlpNo1, sSlpNo2, sSlpNo3, sSlpNo4, sSlpNo5, sSlpNo6, sSlpNo7, sSlpNo8, sSlpNo9, sSlpNo10, false, printout);
	}

	protected void setMergeSlip(final UserInfo userInfo, final String slpNo,
								final String sSlpNo1, final String sSlpNo2,
								final String sSlpNo3, final String sSlpNo4,
								final String sSlpNo5, final String sSlpNo6,
								final String sSlpNo7, final String sSlpNo8,
								final String sSlpNo9, final String sSlpNo10,
								boolean locked, final boolean printout) {
		final String usrid = userInfo.getUserID();

		if (!locked) {
			lockSlips(new String[] { slpNo, sSlpNo1, sSlpNo2, sSlpNo3, sSlpNo4, sSlpNo5 },
					new CallbackListener() {
				@Override
				public void handleRetBool(boolean ret, String result, MessageQueue mQueue) {
					if (mQueue.success()) {
						setMergeSlip(userInfo, slpNo, sSlpNo1, sSlpNo2, sSlpNo3, sSlpNo4, sSlpNo5, sSlpNo6, sSlpNo7, sSlpNo8, sSlpNo9, sSlpNo10, true, printout);
					} else {
						Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
					}
				}
			});
			return;
		}

		QueryUtil.executeMasterAction(userInfo, ConstantsTx.MERGESLIP_TXCODE, QueryUtil.ACTION_APPEND,
				new String[] {slpNo, sSlpNo1, sSlpNo2, sSlpNo3, sSlpNo4, sSlpNo5, sSlpNo6, sSlpNo7, sSlpNo8, sSlpNo9, sSlpNo10, usrid},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					setMergeSlipReady(true, printout);
				} else {
					setMergeSlipReady(false, printout);
					unlockSlips(new String[] {
							//slpNo,
							sSlpNo1, sSlpNo2, sSlpNo3, sSlpNo4, sSlpNo5, sSlpNo6, sSlpNo7, sSlpNo8, sSlpNo9, sSlpNo10
						});
				}
			}
		});
	}

	protected void isImplementMBReady(int i) {}

	protected void isImplementMB(final UserInfo userInfo, final String slpNo,
			final String sSlpNo1, final String sSlpNo2, final String sSlpNo3, final String sSlpNo4, final String sSlpNo5,
			final String sSlpNo6, final String sSlpNo7, final String sSlpNo8, final String sSlpNo9, final String sSlpNo10) {

		QueryUtil.executeMasterBrowse(userInfo,"SLIPMBLINK", new String[] {slpNo},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				int iMatch = 0;
				int iTemp = 0;
				if (mQueue.success()) {
					String result = mQueue.getContentAsQueue();

					if (sSlpNo1.length() > 0 && result.indexOf(sSlpNo1) >= 0) {
						iMatch++;
					}

					if (sSlpNo2.length() > 0 && result.indexOf(sSlpNo2) >= 0) {
						iMatch++;
					}

					if (sSlpNo3.length() > 0 && result.indexOf(sSlpNo3) >= 0) {
						iMatch++;
					}

					if (sSlpNo4.length() > 0 && result.indexOf(sSlpNo4) >= 0) {
						iMatch++;
					}

					if (sSlpNo5.length() > 0 && result.indexOf(sSlpNo5) >= 0) {
						iMatch++;
					}

					if (sSlpNo6.length() > 0 && result.indexOf(sSlpNo6) >= 0) {
						iMatch++;
					}

					if (sSlpNo7.length() > 0 && result.indexOf(sSlpNo7) >= 0) {
						iMatch++;
					}

					if (sSlpNo8.length() > 0 && result.indexOf(sSlpNo8) >= 0) {
						iMatch++;
					}

					if (sSlpNo9.length() > 0 && result.indexOf(sSlpNo9) >= 0) {
						iMatch++;
					}

					if (sSlpNo10.length() > 0 && result.indexOf(sSlpNo10) >= 0) {
						iMatch++;
					}

					if (iMatch > 0) {
						if (sSlpNo1.length() > 0) {
							iMatch-- ;
						}
						if (sSlpNo2.length() > 0) {
							iMatch-- ;
						}
						if (sSlpNo3.length() > 0) {
							iMatch-- ;
						}
						if (sSlpNo4.length() > 0) {
							iMatch-- ;
						}
						if (sSlpNo5.length() > 0) {
							iMatch-- ;
						}
						if (sSlpNo6.length() > 0) {
							iMatch-- ;
						}
						if (sSlpNo7.length() > 0) {
							iMatch-- ;
						}
						if (sSlpNo8.length() > 0) {
							iMatch-- ;
						}
						if (sSlpNo9.length() > 0) {
							iMatch-- ;
						}
						if (sSlpNo10.length() > 0) {
							iMatch-- ;
						}

						if (iMatch == 0) {
							iTemp = 1;
						} else if (iMatch < 0) {
							iTemp = -2;
						} else if (iMatch > 0) {
							iTemp = -3;
						}
					} else {
						iTemp = -1;
					}
				} else {
					iTemp = -4; //no baby
				}

				if (iTemp == 1) {
					isImplementMBReady(1);
				} else if (iTemp == -4) {
					isImplementMBReady(2);
				} else if (iTemp == -2) {
					Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_ERR_GENERAL+"\n"+ConstantsMessage.MSG_ERR_NOTALLBABY+slpNo);
					isImplementMBReady(-1);
				} else if (iTemp == 0) {
					Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_ERR_GENERAL+"\n"+ConstantsMessage.MSG_ERR_UNABLE2MERGESLIP);
					isImplementMBReady(-1);
				} else if (iTemp == -1) {
					isImplementMBReady(2);	// no match baby
				} else {
					isImplementMBReady(0);
				}
			}
		});
	}

	protected void slipLostFocus(final String slpno, final TextSlipMergeSearch slpnoField) {
		if (!slpnoField.isEditable() || slpno == null || slpno.length() == 0) return;

		QueryUtil.executeMasterBrowse( getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {"slip s,slipmerge m", "s.slpno,s.patno,m.slpno", "s.slpno=m.slpno(+) AND s.slpno='" + slpno + SINGLE_QUOTE_VALUE},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				final boolean hasmerged = mQueue.getContentField()[2].length() > 0;
				MessageQueueCallBack callBack = new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (!hasmerged) {
							Factory.getInstance().addErrorMessage("Patient Name : " + mQueue.getContentField()[0], getButtonBar().getItem(0));
						} else {
							Factory.getInstance().addErrorMessage("Slip No [" + slpno + "] has been merged!", slpnoField);
							slpnoField.resetText();
						}
					}
				};

				if (mQueue.getContentField()[0].length() > 0) {
					if (mQueue.getContentField()[1].length() > 0) {
						QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
								new String[] {"slip a,patient b", "b.patfname ||' '||b.patgname", "a.patno=b.patno and a.slpno='"+slpno+SINGLE_QUOTE_VALUE},
								callBack);
					} else {
						QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
								new String[] {"slip", "slpfname ||' '||slpgname", "slpno='"+slpno+SINGLE_QUOTE_VALUE},
								callBack);
					}
				} else {
					Factory.getInstance().addErrorMessage("No exist Slip No [" + slpno + "]!", slpnoField);
					slpnoField.resetText();
				}
			}
		});
	}

	private void setAllSlipHelper(StringBuffer allSlip, TextSlipMergeSearch mergeWith) {
		if (mergeWith.getText().length() > 0) {
			if (allSlip.length() > 0) {
				allSlip.append(", ");
			}
			allSlip.append(SINGLE_QUOTE_VALUE);
			allSlip.append(mergeWith.getText());
			allSlip.append(SINGLE_QUOTE_VALUE);
		}
	}

	protected String getAllSlip(boolean includePrimarySlip) {
		StringBuffer allSlip = new StringBuffer();
		if (includePrimarySlip) {
			allSlip.append(SINGLE_QUOTE_VALUE);
			allSlip.append(getMemSlipNo());
			allSlip.append(SINGLE_QUOTE_VALUE);
		}

		setAllSlipHelper(allSlip, getMergeWith1());
		setAllSlipHelper(allSlip, getMergeWith2());
		setAllSlipHelper(allSlip, getMergeWith3());
		setAllSlipHelper(allSlip, getMergeWith4());
		setAllSlipHelper(allSlip, getMergeWith5());
		setAllSlipHelper(allSlip, getMergeWith6());
		setAllSlipHelper(allSlip, getMergeWith7());
		setAllSlipHelper(allSlip, getMergeWith8());
		setAllSlipHelper(allSlip, getMergeWith9());
		setAllSlipHelper(allSlip, getMergeWith10());

		return allSlip.toString();
	}

	protected void slipNoChange(String slpno, final TextSlipMergeSearch slpnoField) {
		// for implementation in child class
	}

	protected void slipNoChange(String slpno) {
		slipNoChange(slpno, null);
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	protected LayoutContainer getSlipPanel() {
		if (slipPanel == null) {
			slipPanel = new BasePanel();
			slipPanel.setBounds(5, 5, 450, 185);
			slipPanel.setBorders(true);
			slipPanel.add(getSlpNoDesc(), null);
			slipPanel.add(getSlpNo(), null);
			slipPanel.add(getSaveMergeSlip(), null);
			slipPanel.add(getMergeWithDesc(), null);
			slipPanel.add(getMergeWith1(), null);
			slipPanel.add(getMergeWith2(), null);
			slipPanel.add(getMergeWith3(), null);
			slipPanel.add(getMergeWith4(), null);
			slipPanel.add(getMergeWith5(), null);
			slipPanel.add(getMergeWith6(), null);
			slipPanel.add(getMergeWith7(), null);
			slipPanel.add(getMergeWith8(), null);
			slipPanel.add(getMergeWith9(), null);
			slipPanel.add(getMergeWith10(), null);
		}
		return slipPanel;
	}

	protected ButtonBase getSlpNoDesc() {
		if (slpNoDesc == null) {
			slpNoDesc = new ButtonBase() {
				@Override
				public void onClick() {
					getDlgSlipSetPrimary().showDialog(memSLPNO, oldSlpNo);
				}
			};
			slpNoDesc.setBounds(10, 23, 120, 20);
			slpNoDesc.setText("Primary Slip No.");
		}
		return slpNoDesc;
	}

	protected TextReadOnly getSlpNo() {
		if (slpNo == null) {
			slpNo = new TextReadOnly();
			slpNo.setBounds(150, 25, 130, 20);
		}
		return slpNo;
	}

	protected ButtonBase getSaveMergeSlip() {
		if (saveMergeSlip == null) {
			saveMergeSlip = new ButtonBase() {
				@Override
				public void onClick() {
					checkDuplicate(false);
				}
			};
			saveMergeSlip.setBounds(300, 23, 130, 20);
			saveMergeSlip.setText("Save Merge Slip");
		}
		return saveMergeSlip;
	}

	protected LabelBase getMergeWithDesc() {
		if (mergeWithDesc == null) {
			mergeWithDesc = new LabelBase();
			mergeWithDesc.setBounds(30, 50, 120, 20);
			mergeWithDesc.setText("Merge With");
		}
		return mergeWithDesc;
	}

	protected TextSlipMergeSearch getMergeWith1() {
		if (mergeWith1 == null) {
			mergeWith1 = new TextSlipMergeSearch() {
				public void onBlur() {
					String slpNo1 = mergeWith1.getText().trim();
					if (slpNo1.length() > 0) {
						if (slpNo1.equals(getMemSlipNo())
								|| slpNo1.equals(getMergeWith2().getText().trim())
								|| slpNo1.equals(getMergeWith3().getText().trim())
								|| slpNo1.equals(getMergeWith4().getText().trim())
								|| slpNo1.equals(getMergeWith5().getText().trim())
								|| slpNo1.equals(getMergeWith6().getText().trim())
								|| slpNo1.equals(getMergeWith7().getText().trim())
								|| slpNo1.equals(getMergeWith8().getText().trim())
								|| slpNo1.equals(getMergeWith9().getText().trim())
								|| slpNo1.equals(getMergeWith10().getText().trim())) {

							Factory.getInstance().addErrorMessage(REDUPLICATE_SLIP_NO);
							mergeWith1.resetText();
							return;
						}

						slipLostFocus(slpNo1, this);
					}
					slipNoChange(slpNo1, this);
				}
				@Override
				public void setText(String value) {
					super.setText(value, false);
					postSetTextAction(getText(),this);
				}
			};
			mergeWith1.setBounds(150, 50, 130, 20);
		}
		return mergeWith1;
	}

	protected TextSlipMergeSearch getMergeWith2() {
		if (mergeWith2 == null) {
			mergeWith2 = new TextSlipMergeSearch() {
				public void onBlur() {
					String slpNo2 = mergeWith2.getText().trim();
					if (slpNo2.length() > 0) {
						if (slpNo2.equals(getMemSlipNo())
								|| slpNo2.equals(getMergeWith1().getText().trim())
								|| slpNo2.equals(getMergeWith3().getText().trim())
								|| slpNo2.equals(getMergeWith4().getText().trim())
								|| slpNo2.equals(getMergeWith5().getText().trim())
								|| slpNo2.equals(getMergeWith6().getText().trim())
								|| slpNo2.equals(getMergeWith7().getText().trim())
								|| slpNo2.equals(getMergeWith8().getText().trim())
								|| slpNo2.equals(getMergeWith9().getText().trim())
								|| slpNo2.equals(getMergeWith10().getText().trim())) {

							Factory.getInstance().addErrorMessage(REDUPLICATE_SLIP_NO);
							mergeWith2.resetText();
							return;
						}

						slipLostFocus(slpNo2, this);
					}
					slipNoChange(slpNo2, this);
				}
				@Override
				public void setText(String value) {
					super.setText(value, false);
					postSetTextAction(getText(),this);
				}
			};
			mergeWith2.setBounds(150, 75, 130, 20);
		}
		return mergeWith2;
	}

	protected TextSlipMergeSearch getMergeWith3() {
		if (mergeWith3 == null) {
			mergeWith3 = new TextSlipMergeSearch() {
				public void onBlur() {
					String slpNo3 = mergeWith3.getText().trim();
					if (slpNo3.length() > 0) {
						if (slpNo3.equals(getMemSlipNo())
								|| slpNo3.equals(getMergeWith1().getText().trim())
								|| slpNo3.equals(getMergeWith2().getText().trim())
								|| slpNo3.equals(getMergeWith4().getText().trim())
								|| slpNo3.equals(getMergeWith5().getText().trim())
								|| slpNo3.equals(getMergeWith6().getText().trim())
								|| slpNo3.equals(getMergeWith7().getText().trim())
								|| slpNo3.equals(getMergeWith8().getText().trim())
								|| slpNo3.equals(getMergeWith9().getText().trim())
								|| slpNo3.equals(getMergeWith10().getText().trim())) {

							Factory.getInstance().addErrorMessage(REDUPLICATE_SLIP_NO);
							mergeWith3.resetText();
							return;
						}

						slipLostFocus(slpNo3, this);
					}
					slipNoChange(slpNo3, this);
				}
				@Override
				public void setText(String value) {
					super.setText(value, false);
					postSetTextAction(getText(),this);
				}
			};
			mergeWith3.setBounds(150, 100, 130, 20);
		}
		return mergeWith3;
	}

	protected TextSlipMergeSearch getMergeWith4() {
		if (mergeWith4 == null) {
			mergeWith4 = new TextSlipMergeSearch() {
				public void onBlur() {
					String slpNo4 = mergeWith4.getText().trim();
					if (slpNo4.length() > 0) {
						if (slpNo4.equals(getMemSlipNo())
								|| slpNo4.equals(getMergeWith1().getText().trim())
								|| slpNo4.equals(getMergeWith2().getText().trim())
								|| slpNo4.equals(getMergeWith3().getText().trim())
								|| slpNo4.equals(getMergeWith5().getText().trim())
								|| slpNo4.equals(getMergeWith6().getText().trim())
								|| slpNo4.equals(getMergeWith7().getText().trim())
								|| slpNo4.equals(getMergeWith8().getText().trim())
								|| slpNo4.equals(getMergeWith9().getText().trim())
								|| slpNo4.equals(getMergeWith10().getText().trim())) {

							Factory.getInstance().addErrorMessage(REDUPLICATE_SLIP_NO);
							mergeWith4.resetText();
							return;
						}

						slipLostFocus(slpNo4, this);
					}
					slipNoChange(slpNo4, this);
				}
				@Override
				public void setText(String value) {
					super.setText(value, false);
					postSetTextAction(getText(),this);
				}
			};
			mergeWith4.setBounds(150, 125, 130, 20);
		}
		return mergeWith4;
	}

	protected TextSlipMergeSearch getMergeWith5() {
		if (mergeWith5 == null) {
			mergeWith5 = new TextSlipMergeSearch() {
				public void onBlur() {
					String slpNo5 = mergeWith5.getText().trim();
					if (slpNo5.length() > 0) {
						if (slpNo5.equals(getMemSlipNo())
								|| slpNo5.equals(getMergeWith1().getText().trim())
								|| slpNo5.equals(getMergeWith2().getText().trim())
								|| slpNo5.equals(getMergeWith3().getText().trim())
								|| slpNo5.equals(getMergeWith4().getText().trim())
								|| slpNo5.equals(getMergeWith6().getText().trim())
								|| slpNo5.equals(getMergeWith7().getText().trim())
								|| slpNo5.equals(getMergeWith8().getText().trim())
								|| slpNo5.equals(getMergeWith9().getText().trim())
								|| slpNo5.equals(getMergeWith10().getText().trim())) {

							Factory.getInstance().addErrorMessage(REDUPLICATE_SLIP_NO);
							mergeWith5.resetText();
							return;
						}

						slipLostFocus(slpNo5, this);
					}
					slipNoChange(slpNo5, this);
				}
				@Override
				public void setText(String value) {
					super.setText(value, false);
					postSetTextAction(getText(),this);
				}
			};
			mergeWith5.setBounds(150, 150, 130, 20);
		}
		return mergeWith5;
	}

	protected TextSlipMergeSearch getMergeWith6() {
		if (mergeWith6 == null) {
			mergeWith6 = new TextSlipMergeSearch() {
				public void onBlur() {
					String slpNo6 = mergeWith6.getText().trim();
					if (slpNo6.length() > 0) {
						if (slpNo6.equals(getMemSlipNo())
								|| slpNo6.equals(getMergeWith1().getText().trim())
								|| slpNo6.equals(getMergeWith2().getText().trim())
								|| slpNo6.equals(getMergeWith3().getText().trim())
								|| slpNo6.equals(getMergeWith4().getText().trim())
								|| slpNo6.equals(getMergeWith5().getText().trim())
								|| slpNo6.equals(getMergeWith7().getText().trim())
								|| slpNo6.equals(getMergeWith8().getText().trim())
								|| slpNo6.equals(getMergeWith9().getText().trim())
								|| slpNo6.equals(getMergeWith10().getText().trim())) {

							Factory.getInstance().addErrorMessage(REDUPLICATE_SLIP_NO);
							mergeWith6.resetText();
							return;
						}

						slipLostFocus(slpNo6, this);
					}
					slipNoChange(slpNo6, this);
				}
				@Override
				public void setText(String value) {
					super.setText(value, false);
					postSetTextAction(getText(),this);
				}
			};
			mergeWith6.setBounds(300, 50, 130, 20);
		}
		return mergeWith6;
	}

	protected TextSlipMergeSearch getMergeWith7() {
		if (mergeWith7 == null) {
			mergeWith7 = new TextSlipMergeSearch() {
				public void onBlur() {
					String slpNo7 = mergeWith7.getText().trim();
					if (slpNo7.length() > 0) {
						if (slpNo7.equals(getMemSlipNo())
								|| slpNo7.equals(getMergeWith1().getText().trim())
								|| slpNo7.equals(getMergeWith2().getText().trim())
								|| slpNo7.equals(getMergeWith3().getText().trim())
								|| slpNo7.equals(getMergeWith4().getText().trim())
								|| slpNo7.equals(getMergeWith5().getText().trim())
								|| slpNo7.equals(getMergeWith6().getText().trim())
								|| slpNo7.equals(getMergeWith8().getText().trim())
								|| slpNo7.equals(getMergeWith9().getText().trim())
								|| slpNo7.equals(getMergeWith10().getText().trim())) {

							Factory.getInstance().addErrorMessage(REDUPLICATE_SLIP_NO);
							mergeWith7.resetText();
							return;
						}

						slipLostFocus(slpNo7, this);
					}
					slipNoChange(slpNo7, this);
				}
				@Override
				public void setText(String value) {
					super.setText(value, false);
					postSetTextAction(getText(),this);
				}
			};
			mergeWith7.setBounds(300, 75, 130, 20);
		}
		return mergeWith7;
	}

	protected TextSlipMergeSearch getMergeWith8() {
		if (mergeWith8 == null) {
			mergeWith8 = new TextSlipMergeSearch() {
				public void onBlur() {
					String slpNo8 = mergeWith8.getText().trim();
					if (slpNo8.length() > 0) {
						if (slpNo8.equals(getMemSlipNo())
								|| slpNo8.equals(getMergeWith1().getText().trim())
								|| slpNo8.equals(getMergeWith2().getText().trim())
								|| slpNo8.equals(getMergeWith3().getText().trim())
								|| slpNo8.equals(getMergeWith4().getText().trim())
								|| slpNo8.equals(getMergeWith5().getText().trim())
								|| slpNo8.equals(getMergeWith6().getText().trim())
								|| slpNo8.equals(getMergeWith7().getText().trim())
								|| slpNo8.equals(getMergeWith9().getText().trim())
								|| slpNo8.equals(getMergeWith10().getText().trim())) {

							Factory.getInstance().addErrorMessage(REDUPLICATE_SLIP_NO);
							mergeWith8.resetText();
							return;
						}

						slipLostFocus(slpNo8, this);
					}
					slipNoChange(slpNo8, this);
				}
				@Override
				public void setText(String value) {
					super.setText(value, false);
					postSetTextAction(getText(),this);
				}
			};
			mergeWith8.setBounds(300, 100, 130, 20);
		}
		return mergeWith8;
	}

	protected TextSlipMergeSearch getMergeWith9() {
		if (mergeWith9 == null) {
			mergeWith9 = new TextSlipMergeSearch() {
				public void onBlur() {
					String slpNo9 = mergeWith9.getText().trim();
					if (slpNo9.length() > 0) {
						if (slpNo9.equals(getMemSlipNo())
								|| slpNo9.equals(getMergeWith1().getText().trim())
								|| slpNo9.equals(getMergeWith2().getText().trim())
								|| slpNo9.equals(getMergeWith3().getText().trim())
								|| slpNo9.equals(getMergeWith4().getText().trim())
								|| slpNo9.equals(getMergeWith5().getText().trim())
								|| slpNo9.equals(getMergeWith6().getText().trim())
								|| slpNo9.equals(getMergeWith7().getText().trim())
								|| slpNo9.equals(getMergeWith8().getText().trim())
								|| slpNo9.equals(getMergeWith10().getText().trim())) {

							Factory.getInstance().addErrorMessage(REDUPLICATE_SLIP_NO);
							mergeWith9.resetText();
							return;
						}

						slipLostFocus(slpNo9, this);
					}
					slipNoChange(slpNo9, this);
				}
				@Override
				public void setText(String value) {
					super.setText(value, false);
					postSetTextAction(getText(),this);
				}
			};
			mergeWith9.setBounds(300, 125, 130, 20);
		}
		return mergeWith9;
	}

	protected TextSlipMergeSearch getMergeWith10() {
		if (mergeWith10 == null) {
			mergeWith10 = new TextSlipMergeSearch() {
				public void onBlur() {
					String slpNo10 = mergeWith10.getText().trim();
					if (slpNo10.length() > 0) {
						if (slpNo10.equals(getMemSlipNo())
								|| slpNo10.equals(getMergeWith1().getText().trim())
								|| slpNo10.equals(getMergeWith2().getText().trim())
								|| slpNo10.equals(getMergeWith3().getText().trim())
								|| slpNo10.equals(getMergeWith4().getText().trim())
								|| slpNo10.equals(getMergeWith5().getText().trim())
								|| slpNo10.equals(getMergeWith6().getText().trim())
								|| slpNo10.equals(getMergeWith7().getText().trim())
								|| slpNo10.equals(getMergeWith8().getText().trim())
								|| slpNo10.equals(getMergeWith9().getText().trim())) {

							Factory.getInstance().addErrorMessage(REDUPLICATE_SLIP_NO);
							mergeWith10.resetText();
							return;
						}

						slipLostFocus(slpNo10, this);
					}
					slipNoChange(slpNo10, this);
				}
				@Override
				public void setText(String value) {
					super.setText(value, false);
					postSetTextAction(getText(),this);
				}
			};
			mergeWith10.setBounds(300, 150, 130, 20);
		}
		return mergeWith10;
	}

	/***************************************************************************
	 * Create Dialog Instance Method
	 **************************************************************************/

	private DlgSlipSetPrimary getDlgSlipSetPrimary() {
		if (dlgSlipSetPrimary == null) {
			dlgSlipSetPrimary = new DlgSlipSetPrimary(getMainFrame()) {
				@Override
				public void post(String slpno) {
					if (slpno != null && slpno.length() > 0) {
						QueryUtil.executeMasterAction(getUserInfo(),
								"SLIP_SETPRIMARY",
								QueryUtil.ACTION_APPEND,
								new String[] { slpno, getUserInfo().getUserID() },
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								if (mQueue.success()) {
									loadOldSlipNo();
									Factory.getInstance().addInformationMessage("Primary Slip setting is done.");
									dispose();
								} else {
									Factory.getInstance().addErrorMessage(mQueue.getReturnMsg());
								}
							}
						});
					} else {
						Factory.getInstance().addErrorMessage("Invalid Slip No.");
					}
				}
			};
		}
		return dlgSlipSetPrimary;
	}
}