package com.hkah.client.layout.dialog;

import java.util.Date;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.KeyListener;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.form.RadioGroup;
import com.extjs.gxt.ui.client.widget.layout.AbsoluteLayout;
import com.google.gwt.user.datepicker.client.CalendarUtil;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.FieldSetBase;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.ComboDayOfweek;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.radiobutton.RadioButtonBase;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextAreaBase;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.DateTimeUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgChgScheduleDetail extends DialogBase {

    private final static int m_frameWidth = 400;
    private final static int m_frameHeight = 400;

	private FieldSetBase dialogTopPanel = null;
	private LabelBase docNameDesc = null;
	private RadioButtonBase byCurSchedule = null;
	private RadioButtonBase byDateRange = null;
	private RadioGroup btnGoup = null;
	private LabelBase dFromDateDesc = null;
	private TextDate dFromDate = null;
	private LabelBase dToDateDesc = null;
	private TextDate dToDate = null;
	private LabelBase dayOfWeekDesc = null;
	private ComboDayOfweek dayOfWeek = null;
	private TextAreaBase Text_RmderRmk = null;
	private LabelBase Label_RmderRmk = null;
	private CheckBoxBase isUpLocation = null;
	private LabelSmallBase isUpLocationDesc = null;
	private ComboBoxBase location = null;	
	private CheckBoxBase isUpRemark = null;

	private String memDocCode = null;
	private String memSchID = null;
	private String memSource = null;
	
	public DlgChgScheduleDetail(MainFrame owner) {
		super(owner, Dialog.OKCANCEL, m_frameWidth, m_frameHeight);
		initialize();
	}

	private void initialize() {
		setTitle("Change Schedule Details");
		setLayout(new AbsoluteLayout());
		add(getDialogTopPanel(), null);

		// limit the date selection
		Date toDate = DateTimeUtil.parseDateTime(getMainFrame().getServerDateTime());
		getDFromDate().setMinValue(toDate);
		CalendarUtil.addDaysToDate(toDate, 1);
		getDToDate().setMinValue(toDate);

		// change label
		getButtonById(OK).setText("Save");
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String schID, final String docCode, final String from) {
		// reset date range
		getDFromDate().resetText();
		getDToDate().resetText();
		getIsUpRemark().reset();
		getIsUpLocation().reset();
		getDayOfWeek().reset();
		getLocation().reset();
		getDayOfWeek().resetText();
		getText_RmderRmk().reset();
		memSchID = schID;
		memDocCode = docCode;
		memSource = from;
		
		if("Y".equals(Factory.getInstance().getSysParameter("DISABLERM"))) {
			getIsUpLocation().setVisible(false);
			getIsUpLocation().setSelected(false);
			getIsUpLocationDesc().setVisible(false);
			getLocation().setVisible(false);
		}
		
		if(("WEEKLY").equals(from)) {
			getByCurSchedule().setEnabled(false);
			getByCurSchedule().setVisible(false);
			getDayOfWeek().setVisible(true);
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] { "DOCTOR", 
				"DOCCODE||' ('||DOCFNAME||' '||DOCGNAME||') '",
				"DOCCODE = '"+memDocCode+"'"},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						displaySchInfo(memDocCode, mQueue.getContentField()[0],null, null);
						
					} 
				}
			});
		}
		
		
		if (schID != null && schID.trim().length() > 0) {
			QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
					new String[] { "SCHEDULE S, DOCTOR D, SCHEDULE_EXTRA SE", 
				"S.DOCCODE,D.DOCFNAME||' '||D.DOCGNAME, TO_CHAR(S.SCHSDATE, 'DD/MM/YYYY HH24:MI'),TO_CHAR(S.SCHEDATE, 'HH24:MI'),S.DOCPRACTICE, SE.RMID ",
				"S.DOCCODE = D.DOCCODE AND S.SCHID = SE.SCHID(+) AND S.SCHID = '"+schID+"'"},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						String[] result = mQueue.getContentField();
						memDocCode = result[0];
						displaySchInfo(result[0], result[1], result[2], result[3]);
						if (!"".equals(result[4]) && result[4] != null) {
							getText_RmderRmk().setText(result[4]);
						}
						if (!"".equals(result[5]) && result[5] != null) {
							getLocation().setText(result[5]);
						}
					} 
				}
			});
		} else {
		}
	}

	private void displaySchInfo(String docCode, String docName, String sTime, String eTime) {
		StringBuffer doctorDesc = new StringBuffer();
		if (!"".equals(memSchID) && memSchID != null) {
			doctorDesc.append("[");
			doctorDesc.append(docCode.trim());
			doctorDesc.append("] ");
			doctorDesc.append(docName+"("+sTime+"-"+eTime+")");

			getByCurSchedule().setText(doctorDesc.toString());
			getByCurSchedule().setVisible(true);
			getByCurSchedule().setEnabled(true);

			getByCurSchedule().setSelected(true);

		} else {
			getByCurSchedule().setVisible(false);
			getByCurSchedule().setEnabled(false);
			getByCurSchedule().resetText();
			getDocNameDesc().setText(docName);
			getDocNameDesc().setVisible(true);

		}



		setVisible(true);
	}

	private boolean isValidate(String startdate, String enddate) {
		String errorMsg = null;
		if (!getDFromDate().isValid() || !getDToDate().isValid()) {
			errorMsg = ConstantsMessage.MSG_INVALID_TIME;
		} else if (DateTimeUtil.compareTo(getMainFrame().getServerDate(), startdate) > 0) {
			errorMsg = ConstantsMessage.MSG_PASTDATENOTALLOWED;
		}
		if (errorMsg != null) {
			Factory.getInstance().addErrorMessage(errorMsg, "PBA - [Change Schedule Details]", getDFromDate());
			return false;
		} else {
			return true;
		}
	}

	@Override
	protected void doOkAction() {
		doSave();
	}

	private void doSave() {


		Factory.getInstance().showMask(getDialogTopPanel());

			QueryUtil.executeMasterAction(getUserInfo(),
					"SCHEDULE_DETAILS",
					QueryUtil.ACTION_APPEND,
					new String[] {
						getByCurSchedule().isSelected()?memSchID:null,
						memDocCode,
						getDFromDate().getText().trim(),
						getDToDate().getText().trim(),
						!"".equals(getDayOfWeek().getText().trim())?getDayOfWeek().getText():"",
						getIsUpRemark().isSelected()?getText_RmderRmk().getText():"",
						getIsUpLocation().isSelected()?getLocation().getText():"",
						getUserInfo().getUserID()
					},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						Factory.getInstance().addInformationMessage("Details Updated Successfully.", "PBA - [Update Schedule Details]",
								new Listener<MessageBoxEvent>() {
									@Override
									public void handleEvent(
											MessageBoxEvent be) {
										// TODO Auto-generated method stub
										dispose();
									}
						});
					} 
				}


				@Override
				public void onComplete() {
					super.onComplete();
					Factory.getInstance().hideMask(getDialogTopPanel());
				}
			});

	}


	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/* >>> override getListWidth for adjust the width of the table list========<<<< */
	protected int getListWidth() {
		return 790;
	}

	private FieldSetBase getDialogTopPanel() {
		if (dialogTopPanel == null) {
			dialogTopPanel = new FieldSetBase();
			dialogTopPanel.setHeading("Information");
			dialogTopPanel.setBounds(5, 5, 380, 300);
			dialogTopPanel.add(getDocNameDesc(), null);
			dialogTopPanel.add(getByCurSchedule(), null);
			dialogTopPanel.add(getByDateRange(), null);
			dialogTopPanel.add(getDFromDateDesc(), null);
			dialogTopPanel.add(getDFromDate(), null);
			dialogTopPanel.add(getDToDateDesc(), null);
			dialogTopPanel.add(getDToDate(), null);
			dialogTopPanel.add(getDayOfWeekDesc(), null);
			dialogTopPanel.add(getDayOfWeek(), null);
			dialogTopPanel.add(getIsUpLocation(), null);
			dialogTopPanel.add(getIsUpLocationDesc(), null);
			dialogTopPanel.add(getLocation(), null);
			dialogTopPanel.add(getLabel_RmderRmk(), null);
			dialogTopPanel.add(getText_RmderRmk(), null);
			dialogTopPanel.add(getIsUpRemark(), null);
			getBtnGoup();
		}
		return dialogTopPanel;
	}
	
	private LabelBase getDocNameDesc() {
		if (docNameDesc == null) {
			docNameDesc = new LabelBase();
			docNameDesc.setText("Doctor");
			docNameDesc.setBounds(5, 5, 200, 20);
			docNameDesc.setVisible(false);
		}
		return docNameDesc;
	}

	private RadioButtonBase getByCurSchedule() {
		if (byCurSchedule == null) {
			byCurSchedule = new RadioButtonBase() {
				public void onClick() {
					getDFromDate().setEnabled(getByDateRange().isSelected());
					getDToDate().setEnabled(getByDateRange().isSelected());
				}
			};
			byCurSchedule.setText("By Current Schedule");
			byCurSchedule.setBounds(5, 5, 200, 20);
		}
		return byCurSchedule;
	}

	private RadioButtonBase getByDateRange() {
		if (byDateRange == null) {
			byDateRange = new RadioButtonBase() {
				public void onClick() {
					getDFromDate().setEnabled(getByDateRange().isSelected());
					getDToDate().setEnabled(getByDateRange().isSelected());
					if (!"WEEKLY".equals (memSource)) {
						getText_RmderRmk().clear();
						getLocation().clear();
					}
				}
			};
			byDateRange.setText("By Date Range");
			byDateRange.setBounds(5, 25, 200, 20);
		}
		return byDateRange;
	}



	private RadioGroup getBtnGoup() {
		if (btnGoup == null) {
			btnGoup = new RadioGroup();
			btnGoup.add(getByCurSchedule());
			btnGoup.add(getByDateRange());
		}
		return btnGoup;
	}

	private LabelBase getDFromDateDesc() {
		if (dFromDateDesc == null) {
			dFromDateDesc = new LabelBase();
			dFromDateDesc.setText("From Date");
			dFromDateDesc.setBounds(35, 50, 80, 20);
		}
		return dFromDateDesc;
	}

	private TextDate getDFromDate() {
		if (dFromDate == null) {
			dFromDate = new TextDate();
			dFromDate.setBounds(110, 50, 150, 20);
		}
		return dFromDate;
	}

	private LabelBase getDToDateDesc() {
		if (dToDateDesc == null) {
			dToDateDesc = new LabelBase();
			dToDateDesc.setText("To");
			dToDateDesc.setBounds(35, 75, 80, 20);
		}
		return dToDateDesc;
	}

	private TextDate getDToDate() {
		if (dToDate == null) {
			dToDate = new TextDate();
			dToDate.setBounds(110, 75, 150, 20);
		}
		return dToDate;
	}
	
	public LabelBase getDayOfWeekDesc() {
		if (dayOfWeekDesc == null) {
			dayOfWeekDesc = new LabelBase();
			dayOfWeekDesc.setText("Day of Week");
			dayOfWeekDesc.setBounds(35, 100, 120, 20);
		}
		return dayOfWeekDesc;
	}

	public ComboDayOfweek getDayOfWeek() {
		if (dayOfWeek == null) {
			dayOfWeek = new ComboDayOfweek() {
				@Override
				protected void setTextPanel(ModelData modelData) {
					QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] { "TEMPLATE", 
						"DOCPRACTICE,RMID ",
						"DOCCODE = '"+memDocCode+"' AND TEMDAY = '"+Integer.toString(getSelectedIndex())+"' "},
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								getText_RmderRmk().setText(mQueue.getContentField()[0]);
								getLocation().setText(mQueue.getContentField()[1]);
							} 
						}
					});
				}
			};
			dayOfWeek.setBounds(110, 100, 120, 20);
		}
		return dayOfWeek;
	}

	public CheckBoxBase getIsUpLocation() {
		if (isUpLocation == null) {
			isUpLocation = new CheckBoxBase();
			isUpLocation.setBounds(5, 125, 30, 20);
		}
		return isUpLocation;
	}

	private LabelSmallBase getIsUpLocationDesc() {
		if (isUpLocationDesc == null) {
			isUpLocationDesc = new LabelSmallBase();
			isUpLocationDesc.setText("Room");
			isUpLocationDesc.setBounds(35, 125, 60, 20);
		}
		return isUpLocationDesc;
	}

	private ComboBoxBase getLocation() {
		if (location == null) {
			location = new ComboBoxBase("DRROOM", false, true, true){
				@Override
				public void onSelected() {
					 getIsUpLocation().setSelected(true);
				}
			};
			location.setBounds(95, 125, 158, 20);
		}
		return location;
	}

	public CheckBoxBase getIsUpRemark() {
		if (isUpRemark == null) {
			isUpRemark = new CheckBoxBase();
			isUpRemark.setBounds(5, 145, 30, 20);
		}
		return isUpRemark;
	}	
	
	public LabelBase getLabel_RmderRmk() {
		if (Label_RmderRmk == null) {
			Label_RmderRmk = new LabelBase();
			Label_RmderRmk.setText("Remark: ");
			Label_RmderRmk.setBounds(35, 145, 50, 20);
		}
		return Label_RmderRmk;
	}

	public TextAreaBase getText_RmderRmk() {
		if (Text_RmderRmk == null) {
			Text_RmderRmk = new TextAreaBase(true);
			Text_RmderRmk.setEditable(true);
			Text_RmderRmk.setMaxLength(250);
			Text_RmderRmk.setBounds(35, 165, 300, 80);
			Text_RmderRmk.addKeyListener(new KeyListener() {
				public void componentKeyPress(ComponentEvent event) {
					super.componentKeyPress(event);
					getIsUpRemark().setSelected(true);		
				}
			});
		}
		return Text_RmderRmk;
	}
}