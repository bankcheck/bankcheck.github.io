package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgWeeklyBillHistory extends DialogBase {

    private final static int m_frameWidth = 1000;
    private final static int m_frameHeight = 465;

	private ButtonBase rollbackButton = null;    
	private TableList weeklyBillListTable = null;
	private JScrollPane weeklyBillScrollPane = null;
	private BasePanel dialogTopPanel = null;	
	
	private ButtonBase close = null;
	
	private String memSlpNo;
	private String memPatNo;
	
	public DlgWeeklyBillHistory(MainFrame owner) {
		super(owner,  m_frameWidth, m_frameHeight);
		initialize();
	}
	
	private void initialize() {
		setTitle("Weekly Bill List");
    	setContentPane(getDialogTopPanel());
	}
	
	public TableList getWeeklyBillListTable() {
		if (weeklyBillListTable == null) {
			weeklyBillListTable = new TableList(getWBColumnNames(), getWBColumnWidths()){
				public void onSelectionChanged() {
					if (weeklyBillListTable.getSelectedRow() > -1) {
						if("1".equals(getWeeklyBillListTable().getSelectedRowContent()[11])&&
								"1".equals(getWeeklyBillListTable().getSelectedRowContent()[12])){
							getRollBackButton().setEnabled(true);
							System.out.println("getRollBackButton[true]");							
						}else{
							System.out.println("getRollBackButton[false]");
							getRollBackButton().setEnabled(false);
						};
					} else {
						getRollBackButton().setEnabled(false);
					}
				}
			};
		}
		return weeklyBillListTable;
	}

	public JScrollPane getWeekBillScrollPane() {
		if (weeklyBillScrollPane == null) {
			weeklyBillScrollPane = new JScrollPane();
			weeklyBillScrollPane.setBounds(5, 5, 960, 380);
			weeklyBillScrollPane.setViewportView(getWeeklyBillListTable());
		}
		return weeklyBillScrollPane;
	}

	private int[] getWBColumnWidths() {
		return new int[] { 70, 80, 150, 60, 80, 80, 100, 80, 60, 60, 100, 40, 0};
	}

	private String[] getWBColumnNames() {
		return new String[] { "Patient NO.","Slip NO.","Patient Name","Bed Code" ,"Reg Date", "Slip Type" ,"Amount" ,"Print Date", "Bill Type","Modified By","Modified Date","Active",""};
	}	
	
	@Override
	public Component getDefaultFocusComponent() {
		return null;
	}

	public void showDialog(String slpNo, String patNo){
		setVisible(true);
		memSlpNo = slpNo;
		memPatNo = patNo;
		searchAction(memSlpNo,memPatNo);	
	}
	
	public void searchAction(String slpNo, String patNo){
		getWeeklyBillListTable().removeAllRow();
		getWeeklyBillListTable().setEnabled(true);
		
		String whereSQLString = null;
		if(patNo != null && patNo.length()>0){
			whereSQLString = "PATNO = '" + patNo;
		}else{
			whereSQLString = "SLPNO = '" + slpNo;
		}

		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {"DAYENDSLIPS"
							, "PATNO,SLPNO,PATNAME,BEDCODE,TO_CHAR(REGDATE,'DD/MM/YYYY'),DECODE(SLPTYPE,'I','In Patient','O','Out Patient','D','Daycase',SLPTYPE),OUTAMT,TO_CHAR(PRINTDATE,'DD/MM/YYYY'),DECODE(BILLTYPE,'H','High Bill','W','Weekly Bill'),NVL((SELECT SUBSTR(USRNAME,6) FROM USR WHERE USR.USRID = DAYENDSLIPS.MODUSRID),MODUSRID),MODDATE,ENABLED,row_number() over (partition by PATNO, slpno order by printdate desc ) row_order"
							, whereSQLString + "' Order by SLPNO DESC, PRINTDATE DESC"},
				new MessageQueueCallBack() {
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getWeeklyBillListTable().setListTableContent(mQueue);
					getWeeklyBillListTable().setSelectRow(0);			

					if (weeklyBillListTable.getSelectedRow() > -1) {
						if("1".equals(getWeeklyBillListTable().getSelectedRowContent()[11])&&
								"1".equals(getWeeklyBillListTable().getSelectedRowContent()[12])){							
							getRollBackButton().setEnabled(true);
						}else{							
							getRollBackButton().setEnabled(false);
						};
					} else {						
						getRollBackButton().setEnabled(false);
					}					
				}
			}
		});
	}	
	
	public BasePanel getDialogTopPanel() {
		if (dialogTopPanel == null) {
			dialogTopPanel = new BasePanel();
			dialogTopPanel.setBounds(0, 0, 640, 380);
			dialogTopPanel.add(getWeekBillScrollPane(), null);
			dialogTopPanel.add(getRollBackButton());			
			dialogTopPanel.add(getClose());
		}
		return dialogTopPanel;
	}
	
	public ButtonBase getRollBackButton() {
		if (rollbackButton == null) {
			rollbackButton = new ButtonBase("Rollback Interim Bill"){
				@Override
				public void onClick() {
					int selRow = getWeeklyBillListTable().getSelectedRow();
					if( selRow != -1){
						final String printDate = getWeeklyBillListTable().getSelectedRowContent()[7];  
						final String patNo = getWeeklyBillListTable().getSelectedRowContent()[0];
						final String slpNo = getWeeklyBillListTable().getSelectedRowContent()[1];
						
						MessageBoxBase.confirm("Weekly Bill History", "Confirm rollback"+" Patient No.:"+patNo+";Slip No.:"+slpNo+" on"+printDate,new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									getMainFrame().setLoading(true);									
									QueryUtil.executeMasterAction(getUserInfo(), "GENALLPATLETTER_WPAT", "DEL",
											new String[] {					
												printDate,
												patNo,
												slpNo,
												Factory.getInstance().getUserInfo().getUserID()
											},
										new MessageQueueCallBack() {
										@Override
										public void onPostSuccess(MessageQueue mQueue) {
											if (mQueue.success()) {
												getMainFrame().setLoading(false);												
												Factory.getInstance().addInformationMessage(
														"Save success.",
														new Listener<MessageBoxEvent>() {
															@Override
															public void handleEvent(
																	MessageBoxEvent be) {
																searchAction(memSlpNo,memPatNo);
															}
														});
											} else {
												getMainFrame().setLoading(false);
											}
										}
									});	
								}
							}
						});						
					}
/*					
							
					final String printDate = getMainFrame().getServerDate(); 

					if (!getPatientCode().isEmpty()) {
//						if (!getRollbackBillType().isEmpty() && !printDate.isEmpty()) {
							QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
									new String[] {"DAYENDSLIPS", "count(1)", "patno = '"+ getPatientCode().getText() +"'"},
									new MessageQueueCallBack() {
								@Override
								public void onPostSuccess(MessageQueue mQueue) {
									if (mQueue.success()) {
										if("0".equals(mQueue.getContentField()[0])){
											Factory.getInstance().addErrorMessage("No such High Bill for Patient NO.:"+getPatientCode().getText()+" on " + getWeeklyDateStart().getText());
										}else{
											MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Confirm rollback?",new Listener<MessageBoxEvent>() {
												@Override
												public void handleEvent(MessageBoxEvent be) {
													if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
														getMainFrame().setLoading(true);									

														QueryUtil.executeMasterAction(getUserInfo(), "GENALLPATLETTER_WPAT", "DEL",
																new String[] {					
																	null,
																	getPatientCode().getText()
																},
															new MessageQueueCallBack() {
															@Override
															public void onPostSuccess(MessageQueue mQueue) {
																if (mQueue.success()) {
																	getMainFrame().setLoading(false);												
																	Factory.getInstance().addInformationMessage(
																			"Save success.",
																			new Listener<MessageBoxEvent>() {
																				@Override
																				public void handleEvent(
																						MessageBoxEvent be) {
																				}
																			});
																} else {
																	getMainFrame().setLoading(false);
																}
															}
														});	
													}
												}
											});
										}
									}
								}
							});	
						} else {
							Factory.getInstance().addErrorMessage("Please select rollback bill type.");
						}
//					} else {
//						Factory.getInstance().addErrorMessage("Please enter Patient NO");
//					}
*/					
				}	
			};
			rollbackButton.setEnabled(false);
			rollbackButton.setBounds(350, 395, 120, 25);				
		}
		return rollbackButton;
	}	
		
	public ButtonBase getClose() {
		if (close == null) {
			close = new ButtonBase() {
				@Override
				public void onClick() {
					memSlpNo = null;
					memPatNo = null;
					dispose();
				}
			};
			close.setText("Close", 'C');
			close.setBounds(500, 395, 90, 25);
		}
		return close;
	}	
}
