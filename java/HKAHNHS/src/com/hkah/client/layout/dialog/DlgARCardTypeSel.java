/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.client.layout.dialog;

import java.util.HashMap;
import java.util.Map;

import com.google.gwt.event.dom.client.ErrorEvent;
import com.google.gwt.event.dom.client.ErrorHandler;
import com.google.gwt.user.client.ui.Image;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.radiobutton.RadioButtonBase;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
@SuppressWarnings("serial")
public abstract class DlgARCardTypeSel extends DialogBase {

    private final static int m_frameWidth = 705;
    private final static int m_frameHeight = 600;

    private final static String SERVER_PATH_PREFIX = "http://";
    private final static String SERVER_PATH_SUFFIX = "/intranet/hat/arCardImage.jsp?arcard=";
    private final static String SERVER_PATH_NO_IMAGE_SUFFIX = "/intranet/images/Photo Not Available.jpg";
    private String imageNotFoundUrl = null;
    private String imageUrl = null;

    private final static String CONFIRM_COMMAND = "OK";
	private final static String Cancel_COMMAND = "Cancel";
	private final static String PREVIOUS_COMMAND = "Previous Page";
	private final static String NEXT_COMMAND = "Next Page";

	private FieldSetBase dialogTopPanel = null;
	private BasePanel dialogBtmPanel = null;

	private ButtonBase ButtonBase_Confirm = null;
	private ButtonBase ButtonBase_Cancel = null;
	private ButtonBase ButtonBase_PrevPage = null;
	private ButtonBase ButtonBase_NextPage = null;

	private TextReadOnly Text_TotalNoOfPage = null;
	private TextReadOnly Text_CurrentNoOfPage = null;

	private LabelBase Label_TotalNoOfPage = null;
	private LabelBase Label_CurrentNoOfPage = null;

	private LabelBase radioLabelDesc1 = null;
	private LabelBase radioLabelDesc2 = null;
	private LabelBase radioLabelDesc3 = null;
	private LabelBase radioLabelDesc4 = null;
	private LabelBase radioLabelDesc5 = null;
	private LabelBase radioLabelDesc6 = null;

	protected RadioButtonBase TpRadio_Card1 = null;
	protected RadioButtonBase TpRadio_Card2 = null;
	protected RadioButtonBase TpRadio_Card3 = null;
	protected RadioButtonBase TpRadio_Card4 = null;
	protected RadioButtonBase TpRadio_Card5 = null;
	protected RadioButtonBase TpRadio_Card6 = null;

	private BasePanel Photo1 = null;
	private BasePanel Photo2 = null;
	private BasePanel Photo3 = null;
	private BasePanel Photo4 = null;
	private BasePanel Photo5 = null;
	private BasePanel Photo6 = null;

	private Image img1 = null;
	private Image img2 = null;
	private Image img3 = null;
	private Image img4 = null;
	private Image img5 = null;
	private Image img6 = null;

	private Map<Integer, String> memFileMap = new HashMap<Integer, String>();
	private Map<String, String> memActIDMap = new HashMap<String, String>();
	private Map<String, String> memARCardCodeMap = new HashMap<String, String>();
	private Map<String, String> memArDescMap = new HashMap<String, String>();

	private String memArcCode = null;
	private String memActCode = null;
	private String memArDesc = null;
	private String memActID = null;
	private int memCurrPage = 0;
	private int memTotalNoPage = 0;
	private String memParentName = null;

	private boolean memHighlightCard = true;

	public DlgARCardTypeSel(MainFrame owner, String parentName) {
	super(owner, null, m_frameWidth, m_frameHeight);
	memParentName = parentName;
		initialize();
	}

	public DlgARCardTypeSel(MainFrame owner) {
	super(owner, null, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("AR Card Type Select");
		BasePanel panel = new BasePanel();
		panel.setLayout(null);
		panel.setSize(m_frameWidth, m_frameHeight);
		panel.add(getDialogTopPanel(), null);
		panel.add(getDialogBtmPanel(), null);
		getContentPane().add(panel, null);
		this.setClosable(false);
	}

	@Override
	protected void doOkAction() {
		if ("ARCardLink".equals(memParentName)) {
			super.dispose();
		} else {
			if (memActCode != null && memActCode.length() > 0) {
				super.dispose();
			} else {
				Factory.getInstance().addErrorMessage("Please select card.", getButtonBase_Confirm());
			}
		}
	}

	@Override
	protected void doCancelAction() {
//		super.dispose();
		dispose();
	}


	@Override
	public void dispose() {
		super.dispose();
/*
		if ("ARCardLink".equals(memParentName)) {
			super.dispose();
		} else {
			if (memActCode != null && memActCode.length() > 0) {
				super.dispose();
			} else {
				Factory.getInstance().addErrorMessage("Please select card.", getButtonBase_Confirm());
			}
		}
*/
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String arcCode) {
		showDialog(arcCode, null, true);
	}

	public void showDialog(String arcCode, String actID) {
		showDialog(arcCode, actID, true);
	}

	public void showDialog(String arcCode, String actID, boolean activeOnly) {
		showDialog(arcCode, actID, activeOnly, true);
	}

	public void showDialog(String arcCode, String actID, boolean activeOnly, boolean highlightCard) {
		memArcCode = arcCode;
		memActCode = null;
		memActID = actID;
		memHighlightCard = highlightCard;
		setVisible(false);
		initCardInfo(activeOnly);
	}

	private void initCardInfo(boolean activeOnly) {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {
						"arcardtype",
						"actid, actcode, ACTDESC, ACTCODE",
						"arccode = upper('" + memArcCode + "') "+
						(activeOnly?" and actactive = -1":"")+" order by ACTDESC"
				},
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					String[] record = TextUtil.split(mQueue.getContentAsQueue(), TextUtil.LINE_DELIMITER);
					String[] fields = null;
					memActIDMap.clear();
					memFileMap.clear();
					memARCardCodeMap.clear();
					memArDescMap.clear();

					for (int i = 0; i < record.length; i++) {
						fields = TextUtil.split(record[i]);
						memActIDMap.put(fields[1], fields[0]);
						memFileMap.put(i, fields[1]);
						memArDescMap.put(fields[1], fields[2]);
						memARCardCodeMap.put(fields[1], fields[3]);
					}

					memTotalNoPage = (int) Math.ceil((double) memFileMap.size() / 6);
					getText_TotalNoOfPage().setText(String.valueOf(memTotalNoPage));
					setCardPhoto(1);

					setVisible(true);
				}
				else {
					noCardSelection();
				}
			}
		});

		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {"arcode", "arcname", "arccode = '" + memArcCode + "'"},
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getDialogTopPanel().setHeading(mQueue.getContentField()[0]);
				} else {
					getDialogTopPanel().setHeading(memArcCode);
				}
			}
		});
		getTpRadio_Card1().reset();
	}

	public void noCardSelection() {

	}

	private void setCardPhoto(int currPage) {
		memCurrPage = currPage;
		memActCode = null;

		// set button status
		getText_CurrentNoOfPage().setText(String.valueOf(currPage));
		getButtonBase_PrevPage().setEnabled(memCurrPage > 1 && memTotalNoPage > 1);
		getButtonBase_NextPage().setEnabled(memCurrPage < memTotalNoPage);

	    String value = null;
//	    String value2 = null;
	    String value3 = null;
	    for (int i = 0; i < 6; i++) {
		value = (String) memFileMap.get((memCurrPage - 1) * 6 + i);
//			value2 = (String) memArDescMap.get(value);
			value3 = (String) memARCardCodeMap.get(value);

		if (i == 0) {
			setCardPhotoHelper(getPhoto1(), getTpRadio_Card1(), getPhotoFrame1(), getRadioLabel1(), value, value3);
		} else if (i == 1) {
			setCardPhotoHelper(getPhoto2(), getTpRadio_Card2(), getPhotoFrame2(), getRadioLabel2(), value, value3);
		} else if (i == 2) {
			setCardPhotoHelper(getPhoto3(), getTpRadio_Card3(), getPhotoFrame3(), getRadioLabel3(), value, value3);
		} else if (i == 3) {
			setCardPhotoHelper(getPhoto4(), getTpRadio_Card4(), getPhotoFrame4(), getRadioLabel4(), value, value3);
		} else if (i == 4) {
			setCardPhotoHelper(getPhoto5(), getTpRadio_Card5(), getPhotoFrame5(), getRadioLabel5(), value, value3);
		} else if (i == 5) {
			setCardPhotoHelper(getPhoto6(), getTpRadio_Card6(), getPhotoFrame6(), getRadioLabel6(), value, value3);
		}
	    }
	}

	private void setCardPhotoHelper(Image photo, RadioButtonBase radioCard, BasePanel photoFrame, LabelBase checkLabel, String value, String value2) {
		if (value != null) {
			photo.setUrl(getImageURL() + value);
			if (memArcCode.length() > 0) {
				if (value.indexOf("-") > 0) {
//					radioCard.setText(value);
//					radioCard.setText(value2);
					checkLabel.setText(value2);
				} else {
//					radioCard.setText(memArcCode + " - " + value);
//					radioCard.setText(value2);
					checkLabel.setText(value2);
				}
			} else {
//				radioCard.setText(memArcCode + " - " + value);
//				radioCard.setText(value2);
				checkLabel.setText(value2);
			}

//			radioCard.setText(memArcCode + " - " + value.substring(memArcCode.length() + 3));
			radioCard.setVisible(true);
			radioCard.setSelected(false);
			photoFrame.setVisible(true);

			if (memActIDMap.get(value).equals(memActID)) {
				radioCard.setSelected(true);
				if (memHighlightCard) {
					radioCard.setStyleAttribute("background-color", "yellow");
				}
				radioCard.onClick();
			}
			else {
				radioCard.setSelected(false);
				radioCard.setStyleAttribute("background-color", "");
			}
		} else {
			photo.setUrl(EMPTY_VALUE);
			radioCard.setVisible(false);
			radioCard.setSelected(false);
			photoFrame.setVisible(false);
			checkLabel.clear();
		}
	}

	public abstract void post(String ArcCode, String ARCardType, String ARCardName, String ARCardDesc, String ARCardCode);

	private String getImageNotFound() {
		if (imageNotFoundUrl == null) {
			imageNotFoundUrl = SERVER_PATH_PREFIX + Factory.getInstance().getSysParameter("PORTALURL") + SERVER_PATH_NO_IMAGE_SUFFIX;
		}
		return imageNotFoundUrl;
	}

	private String getImageURL() {
		if (imageUrl == null) {
			imageUrl = SERVER_PATH_PREFIX + Factory.getInstance().getSysParameter("PORTALURL") + SERVER_PATH_SUFFIX;
		}
		return imageUrl;
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	public FieldSetBase getDialogTopPanel() {
		if (dialogTopPanel == null) {
			dialogTopPanel = new FieldSetBase();
			dialogTopPanel.setHeading("AR Card Type");
			dialogTopPanel.add(getTpRadio_Card1(), null);
			dialogTopPanel.add(getRadioLabel1(), null);
			dialogTopPanel.add(getPhotoFrame1(), null);
			dialogTopPanel.add(getTpRadio_Card2(), null);
			dialogTopPanel.add(getRadioLabel2(), null);
			dialogTopPanel.add(getPhotoFrame2(), null);
			dialogTopPanel.add(getTpRadio_Card3(), null);
			dialogTopPanel.add(getRadioLabel3(), null);
			dialogTopPanel.add(getPhotoFrame3(), null);
			dialogTopPanel.add(getTpRadio_Card4(), null);
			dialogTopPanel.add(getRadioLabel4(), null);
			dialogTopPanel.add(getPhotoFrame4(), null);
			dialogTopPanel.add(getTpRadio_Card5(), null);
			dialogTopPanel.add(getRadioLabel5(), null);
			dialogTopPanel.add(getPhotoFrame5(), null);
			dialogTopPanel.add(getTpRadio_Card6(), null);
			dialogTopPanel.add(getRadioLabel6(), null);
			dialogTopPanel.add(getPhotoFrame6(), null);
			dialogTopPanel.setBounds(5, 0, 660, 515);
		}
		return dialogTopPanel;
	}

	public BasePanel getDialogBtmPanel() {
		if (dialogBtmPanel == null) {
			dialogBtmPanel = new BasePanel();
			dialogBtmPanel.setEtchedBorder();
			dialogBtmPanel.add(getButtonBase_Confirm(), null);
			dialogBtmPanel.add(getButtonBase_Cancel(), null);
			dialogBtmPanel.add(getButtonBase_PrevPage());
			dialogBtmPanel.add(getButtonBase_NextPage());
			dialogBtmPanel.add(getLabel_TotalNoOfPage());
			dialogBtmPanel.add(getText_TotalNoOfPage(), null);
			dialogBtmPanel.add(getLabel_CurrentNoOfPage());
			dialogBtmPanel.add(getText_CurrentNoOfPage(), null);
			dialogBtmPanel.setBounds(5, 520, 660, 35);
		}
		return dialogBtmPanel;
	}

	public RadioButtonBase getTpRadio_Card1() {
		if (TpRadio_Card1 == null) {
			TpRadio_Card1 = new RadioButtonBase() {
				@Override
				public void onClick() {
					memActCode = (String) memFileMap.get((memCurrPage - 1) * 6 + 0);
					memArDesc = TpRadio_Card1.getBoxLabel();
				}
			};
			TpRadio_Card1.setText("");
			TpRadio_Card1.setBounds(5, 109, 240, 40);
		}
		return TpRadio_Card1;
	}

	public LabelBase getRadioLabel1() {
		if (radioLabelDesc1 == null) {
			radioLabelDesc1 = new LabelBase();
			radioLabelDesc1.setText("");
			radioLabelDesc1.setBounds(25, 119, 300, 35);
		}
		return radioLabelDesc1;
	}

	public BasePanel getPhotoFrame1() {
		if (Photo1 == null) {
			Photo1 = new BasePanel();
			Photo1.setBorders(true);
			Photo1.add(getPhoto1());
			Photo1.setBounds(40, 0, 180, 120);
		}
		return Photo1;
	}

	public Image getPhoto1() {
		if (img1 == null) {
			img1 = new Image();
			img1.addErrorHandler(new ErrorHandler() {
				@Override
				public void onError(ErrorEvent event) {
					img1.setUrl(getImageNotFound());
				}
		    });
			img1.setPixelSize(180, 120);
		}
		return img1;
	}

	public RadioButtonBase getTpRadio_Card2() {
		if (TpRadio_Card2 == null) {
			TpRadio_Card2 = new RadioButtonBase() {
				@Override
				public void onClick() {
					memActCode = (String) memFileMap.get((memCurrPage - 1) * 6 + 1);
					memArDesc = TpRadio_Card2.getBoxLabel();
				}
			};
			TpRadio_Card2.setText("");
			TpRadio_Card2.setBounds(5, 274, 240, 40);
		}
		return TpRadio_Card2;
	}

	public LabelBase getRadioLabel2() {
		if (radioLabelDesc2 == null) {
			radioLabelDesc2 = new LabelBase();
			radioLabelDesc2.setText("");
			radioLabelDesc2.setBounds(25, 284, 300, 35);
		}
		return radioLabelDesc2;
	}

	public BasePanel getPhotoFrame2() {
		if (Photo2 == null) {
			Photo2 = new BasePanel();
			Photo2.setBorders(true);
			Photo2.add(getPhoto2());
			Photo2.setBounds(40, 165, 180, 120);
		}
		return Photo2;
	}

	public Image getPhoto2() {
		if (img2 == null) {
			img2 = new Image();
			img2.addErrorHandler(new ErrorHandler() {
				@Override
				public void onError(ErrorEvent event) {
					img2.setUrl(getImageNotFound());
				}
		    });
			img2.setPixelSize(180, 120);
		}
		return img2;
	}

	public RadioButtonBase getTpRadio_Card3() {
		if (TpRadio_Card3 == null) {
			TpRadio_Card3 = new RadioButtonBase() {
				@Override
				public void onClick() {
					memActCode = (String) memFileMap.get((memCurrPage - 1) * 6 + 2);
					memArDesc = TpRadio_Card3.getBoxLabel();
				}
			};
			TpRadio_Card3.setText("");
			TpRadio_Card3.setBounds(5, 439, 240, 40);
		}
		return TpRadio_Card3;
	}

	public LabelBase getRadioLabel3() {
		if (radioLabelDesc3 == null) {
			radioLabelDesc3 = new LabelBase();
			radioLabelDesc3.setText("");
			radioLabelDesc3.setBounds(25, 449, 300, 35);
		}
		return radioLabelDesc3;
	}

	public BasePanel getPhotoFrame3() {
		if (Photo3 == null) {
			Photo3 = new BasePanel();
			Photo3.setBorders(true);
			Photo3.add(getPhoto3());
			Photo3.setBounds(40, 330, 180, 120);
		}
		return Photo3;
	}

	public Image getPhoto3() {
		if (img3 == null) {
			img3 = new Image();
			img3.addErrorHandler(new ErrorHandler() {
				@Override
				public void onError(ErrorEvent event) {
					img3.setUrl(getImageNotFound());
				}
		    });
			img3.setPixelSize(180, 120);
		}
		return img3;
	}

	public RadioButtonBase getTpRadio_Card4() {
		if (TpRadio_Card4 == null) {
			TpRadio_Card4 = new RadioButtonBase() {
				@Override
				public void onClick() {
					memActCode = (String) memFileMap.get((memCurrPage - 1) * 6 + 3);
					memArDesc = TpRadio_Card4.getBoxLabel();
				}
			};
			TpRadio_Card4.setText("");
			TpRadio_Card4.setBounds(335, 109, 240, 40);
		}
		return TpRadio_Card4;
	}

	public LabelBase getRadioLabel4() {
		if (radioLabelDesc4 == null) {
			radioLabelDesc4 = new LabelBase();
			radioLabelDesc4.setText("");
			radioLabelDesc4.setBounds(355, 119, 300, 35);
		}
		return radioLabelDesc4;
	}

	public BasePanel getPhotoFrame4() {
		if (Photo4 == null) {
			Photo4 = new BasePanel();
			Photo4.setBorders(true);
			Photo4.add(getPhoto4());
			Photo4.setBounds(370, 0, 180, 120);
		}
		return Photo4;
	}

	public Image getPhoto4() {
		if (img4 == null) {
			img4 = new Image();
			img4.addErrorHandler(new ErrorHandler() {
				@Override
				public void onError(ErrorEvent event) {
					img4.setUrl(getImageNotFound());
				}
		    });
			img4.setPixelSize(180, 120);
		}
		return img4;
	}

	public RadioButtonBase getTpRadio_Card5() {
		if (TpRadio_Card5 == null) {
			TpRadio_Card5 = new RadioButtonBase() {
				@Override
				public void onClick() {
					memActCode = (String) memFileMap.get((memCurrPage - 1) * 6 + 4);
					memArDesc = TpRadio_Card5.getBoxLabel();
				}
			};
			TpRadio_Card5.setText("");
			TpRadio_Card5.setBounds(335, 274, 240, 40);
		}
		return TpRadio_Card5;
	}

	public LabelBase getRadioLabel5() {
		if (radioLabelDesc5 == null) {
			radioLabelDesc5 = new LabelBase();
			radioLabelDesc5.setText("");
			radioLabelDesc5.setBounds(355, 284, 300, 35);
		}
		return radioLabelDesc5;
	}

	public BasePanel getPhotoFrame5() {
		if (Photo5 == null) {
			Photo5 = new BasePanel();
			Photo5.setBorders(true);
			Photo5.add(getPhoto5());
			Photo5.setBounds(370, 165, 180, 120);
		}
		return Photo5;
	}

	public Image getPhoto5() {
		if (img5 == null) {
			img5 = new Image();
			img5.addErrorHandler(new ErrorHandler() {
				@Override
				public void onError(ErrorEvent event) {
					img5.setUrl(getImageNotFound());
				}
		    });
			img5.setPixelSize(180, 120);
		}
		return img5;
	}

	public RadioButtonBase getTpRadio_Card6() {
		if (TpRadio_Card6 == null) {
			TpRadio_Card6 = new RadioButtonBase() {
				@Override
				public void onClick() {
					memActCode = (String) memFileMap.get((memCurrPage - 1) * 6 + 5);
					memArDesc = TpRadio_Card6.getBoxLabel();
				}
			};
			TpRadio_Card6.setText("");
			TpRadio_Card6.setBounds(335, 439, 240, 40);
		}
		return TpRadio_Card6;
	}

	public LabelBase getRadioLabel6() {
		if (radioLabelDesc6 == null) {
			radioLabelDesc6 = new LabelBase();
			radioLabelDesc6.setText("");
			radioLabelDesc6.setBounds(355, 449, 300, 35);
		}
		return radioLabelDesc6;
	}

	public BasePanel getPhotoFrame6() {
		if (Photo6 == null) {
			Photo6 = new BasePanel();
			Photo6.setBorders(true);
			Photo6.add(getPhoto6());
			Photo6.setBounds(370, 330, 180, 120);
		}
		return Photo6;
	}

	public Image getPhoto6() {
		if (img6 == null) {
			img6 = new Image();
			img6.addErrorHandler(new ErrorHandler() {
				@Override
				public void onError(ErrorEvent event) {
					img6.setUrl(getImageNotFound());
				}
		    });
			img6.setPixelSize(180, 120);
		}
		return img6;
	}

	public LabelBase getLabel_TotalNoOfPage() {
		if (Label_TotalNoOfPage == null) {
			Label_TotalNoOfPage = new LabelBase();
			Label_TotalNoOfPage.setText("Total Pages");
			Label_TotalNoOfPage.setBounds(390, 5, 80, 20);
		}
		return Label_TotalNoOfPage;
	}

	public TextReadOnly getText_TotalNoOfPage() {
		if (Text_TotalNoOfPage == null) {
			Text_TotalNoOfPage = new TextReadOnly();

			Text_TotalNoOfPage.setBounds(470, 5, 30, 20);
		}
		return Text_TotalNoOfPage;
	}

	public LabelBase getLabel_CurrentNoOfPage() {
		if (Label_CurrentNoOfPage == null) {
			Label_CurrentNoOfPage = new LabelBase();
			Label_CurrentNoOfPage.setText("Current Page");
			Label_CurrentNoOfPage.setBounds(520, 5, 80, 20);
		}
		return Label_CurrentNoOfPage;
	}

	public TextReadOnly getText_CurrentNoOfPage() {
		if (Text_CurrentNoOfPage == null) {
			Text_CurrentNoOfPage = new TextReadOnly();
			Text_CurrentNoOfPage.setBounds(600, 5, 30, 20);
		}
		return Text_CurrentNoOfPage;
	}

	public ButtonBase getButtonBase_Confirm() {
		if (ButtonBase_Confirm == null) {
			ButtonBase_Confirm = new ButtonBase() {
				@Override
				public void onClick() {
					if (memActCode != null && memActCode.length() > 0) {
						if (memActIDMap.containsKey(memActCode)) {
							post(memArcCode, memActIDMap.get(memActCode), memActCode,
									memArDescMap.get(memActCode), memARCardCodeMap.get(memActCode));
//							dispose();
							doOkAction();
						} else {
							if (memActIDMap.containsKey(memActCode.substring(memActCode.indexOf("-")+1).trim())) {
								post(memArcCode, memActIDMap.get(memActCode.substring(memActCode.indexOf("-")+1).trim()),
										memActCode, memArDescMap.get(memActCode.substring(memActCode.indexOf("-")+1).trim()),
										memARCardCodeMap.get(memActCode.substring(memActCode.indexOf("-")+1).trim()));
//								dispose();
								doOkAction();
							}
						}
					} else {
						Factory.getInstance().addErrorMessage("Please select card.", getButtonBase_Confirm());
/*
						MessageBoxBase.confirm(ConstantsMessage.MSG_PBA_SYSTEM, "No card type is selected. Do you still want to continue?",
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									post(null, null, null, null, null);
									dispose();
								}
							}
						});
*/
					}
				}
			};
			ButtonBase_Confirm.setText(CONFIRM_COMMAND);
			ButtonBase_Confirm.setBounds(20, 5, 80, 25);
		}
		return ButtonBase_Confirm;
	}

	public ButtonBase getButtonBase_Cancel() {
		if (ButtonBase_Cancel == null) {
			ButtonBase_Cancel = new ButtonBase() {
				@Override
				public void onClick() {
					doCancelAction();
				}
			};
			ButtonBase_Cancel.setText(Cancel_COMMAND);
			ButtonBase_Cancel.setBounds(110, 5, 80, 25);
		}
		return ButtonBase_Cancel;
	}

	public ButtonBase getButtonBase_PrevPage() {
		if (ButtonBase_PrevPage == null) {
			ButtonBase_PrevPage = new ButtonBase() {
				@Override
				public void onClick() {
					if (memCurrPage - 1 <= 0) {
						Factory.getInstance().addErrorMessage("This is the first page!");
					} else {
						setCardPhoto(memCurrPage - 1);
					}
				}
			};
			ButtonBase_PrevPage.setText(PREVIOUS_COMMAND);
			ButtonBase_PrevPage.setBounds(200, 5, 80, 25);
		}
		return ButtonBase_PrevPage;
	}

	public ButtonBase getButtonBase_NextPage() {
		if (ButtonBase_NextPage == null) {
			ButtonBase_NextPage = new ButtonBase() {
				@Override
				public void onClick() {
					if (memCurrPage + 1 <= memTotalNoPage) {
						setCardPhoto(memCurrPage + 1);
					} else {
						Factory.getInstance().addErrorMessage("No more next page!");
					}
				}
			};
			ButtonBase_NextPage.setText(NEXT_COMMAND);
			ButtonBase_NextPage.setBounds(290, 5, 80, 25);
		}
		return ButtonBase_NextPage;
	}
}