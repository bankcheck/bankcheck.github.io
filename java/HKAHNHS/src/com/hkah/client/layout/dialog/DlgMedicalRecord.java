package com.hkah.client.layout.dialog;

import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.label.LabelSmallBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgMedicalRecord extends DialogBase {
	private final static int m_frameWidth = 600;
	private final static int m_frameHeight = 600;

	private TableList medRecListTable = null;
	private BasePanel contentPanel = null;
	private BasePanel medRecPanel = null;
	private JScrollPane medRecScrollPane = null;
	
	private LabelSmallBase curMedRecLabel = null;
	private TextReadOnly curMedRec = null;
	
	private JScrollPane volumeScrollPane  = null;
	private TableList volumeListTable = null;
	private LabelSmallBase volListLabel = null;


	public DlgMedicalRecord(MainFrame owner) {
		super(owner, OK, m_frameWidth, m_frameHeight);
		initialize();
	}

	/**
	 * This method initializes this
	 *
	 */
	private void initialize() {
		setTitle("Medical Record");
		setContentPane(getContentPanel());
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(final String patno) {
		QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.MEDCHART_TXCODE,
				new String[] { patno, ConstantsVariable.NO_VALUE },
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					getVolumeListTable().setListTableContent(mQueue);
					getVolumeListTable().setColumnValueColor(12, "green",getMainFrame().getSysParameter("MRMIDGRN"));
					
					QueryUtil.executeMasterFetch(getUserInfo(), "MEDREC_FILL_PAPERPRI",
							new String[] { patno },
							new MessageQueueCallBack() {
						public void onPostSuccess(final MessageQueue mQueue) {
							if (mQueue.success()) {								
								String mrhid = mQueue.getContentField()[6];
								getINJText_Med().setText(patno+"/"+mQueue.getContentField()[5]);
								
								QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.MEDRCDHIS_TXCODE,
										new String[] { mrhid, ConstantsVariable.NO_VALUE },
										new MessageQueueCallBack() {
									@Override
									public void onPostSuccess(MessageQueue mQueue) {
										if (mQueue.success()) {
											getMedRecListTable().setListTableContent(mQueue);
										} else {
											Factory.getInstance().addErrorMessage("Cannot find any record.");
										}

										setVisible(true);
									}
								});
								
								
							}
						}
					});
				
/*					
					QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.MEDRCDHIS_TXCODE,
							new String[] { mrhid, ConstantsVariable.NO_VALUE },
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								getMedRecListTable().setListTableContent(mQueue);
							} else {
								Factory.getInstance().addErrorMessage("Cannot find any record.");
							}

							setVisible(true);
						}
					});*/
				} else {
					Factory.getInstance().addErrorMessage("Cannot find any record.");
				}
			}
		});
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	private BasePanel getContentPanel() {
		if (contentPanel == null) {
			contentPanel = new BasePanel();
			contentPanel.setBounds(0, 0, 560, 600);
			contentPanel.add(getINJLabel_VolListLabel(), null);
			contentPanel.add(getVolumeScrollPane(), null);
			contentPanel.add(getMedRecPanel(), null);

		}
		return contentPanel;
	}
	
	private BasePanel getMedRecPanel() {
		if (medRecPanel == null) {
			medRecPanel = new BasePanel();
			medRecPanel.setBounds(5, 220, 560, 280);
			medRecPanel.add(getINJLabel_CurMedRec());
			medRecPanel.add(getINJText_Med());
			medRecPanel.add(getMedRecScrollPane(), null);
		}
		return medRecPanel;
	}

	private JScrollPane getMedRecScrollPane() {
		if (medRecScrollPane == null) {
			medRecScrollPane = new JScrollPane();
			medRecScrollPane.setBounds(5, 30, 560, 250);
			medRecScrollPane.setViewportView(getMedRecListTable());
		}
		return medRecScrollPane;
	}
	
	private LabelSmallBase getINJLabel_CurMedRec() {
		if (curMedRecLabel == null) {
			curMedRecLabel = new LabelSmallBase();
			curMedRecLabel.setText("Current Volume");
			curMedRecLabel.setBounds(5, 5, 90, 20);
		}
		return curMedRecLabel;
	}

	private TextReadOnly getINJText_Med() {
		if (curMedRec == null) {
			curMedRec = new TextReadOnly();
			curMedRec.setBounds(95, 5, 125, 20);
		}
		return curMedRec;
	}

	private TableList getMedRecListTable() {
		if (medRecListTable == null) {
			medRecListTable = new TableList(getMedRecColumnNames(), getMedRecColumnWidths());
			medRecListTable.setHeight(250);
		}
		return medRecListTable;
	}

	private int[] getMedRecColumnWidths() {
		return new int[] {
				10,0,0,
				0,
				120,0,
				100,0,
				80,
				120,0,
				80,
				120,
				110,0,
				70,0,
				110
		};
	}

	private String[] getMedRecColumnNames() {
		return new String[] {
				"","","",
				"Activity",
				"Date/Time","",
				"Dispatch","",
				"Doctor",
				"Remarks","",
				"Return",
				"Return Date/Time",
				"Request Location","",
				"Medical","",
				"User"
		};
	}
	
	private LabelSmallBase getINJLabel_VolListLabel() {
		if (volListLabel == null) {
			volListLabel = new LabelSmallBase();
			volListLabel.setText("Volume List");
			volListLabel.setBounds(5, 5, 90, 20);
		}
		return volListLabel;
	}
	
	private JScrollPane getVolumeScrollPane() {
		if (volumeScrollPane == null) {
			volumeScrollPane = new JScrollPane();
			volumeScrollPane.setBounds(5, 25, 560, 180);
			volumeScrollPane.setViewportView(getVolumeListTable());
		}
		return volumeScrollPane;
	}

	private TableList getVolumeListTable() {
		if (volumeListTable == null) {
			volumeListTable = new TableList(getVolumeColumnNames(), getVolumeColumnWidths());
			volumeListTable.setHeight(180);
		}
		return volumeListTable;
	}

	private int[] getVolumeColumnWidths() {
		return new int[] {
				10,
				80,0,
				0,0,
				120,0,
				120,0,
				0,
				0,0,
				100,0,
				100,
				120,
				0,0,0,0,0,0
		};
	}

	private String[] getVolumeColumnNames() {
		return new String[] {
				"",
				"Record ID","",
				"User","",
				"Storage Location","",
				"Current Location","",
				"Doctor",
				"Remarks","",
				"Media Type","",
				"Chart Status",
				"At",
				"","","","","",""
		};
	}
}