package com.hkah.client.layout.dialog;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.store.Record;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.LayoutContainer;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.combobox.ComboChartLocation;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TableUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class DlgMRTransfer extends DialogBase {
	private final static int m_frameWidth = 500;
	private final static int m_frameHeight = 210;

	private DlgPrtCallChart chartDlg = null;
	private BasePanel body = null;
	private LabelBase descLabel = null;
	private LabelBase chartLocationDesc = null;
	private ComboChartLocation chartLocation = null;
	private LabelBase requiredByDesc = null;
	private TextReadOnly requiredByText = null;
	private LabelBase purposeDesc = null;
	private TextReadOnly purposeText = null;

//	private String recordID = null;
	private String patNo = null;
	private String volNo = null;
	private String requiredBy = null;
	private String requiredByDisplay = null;
	private String purpose = null;

	public DlgMRTransfer(DlgPrtCallChart chartDlg, MainFrame owner) {
		super(owner, OKCANCEL, m_frameWidth, m_frameHeight);
		this.chartDlg = chartDlg;
		initialize();
	}

	private void initialize() {
		setTitle("Chart Transfer");
		getContentPane().add(getBodyPanel(), null);

		getButtonById(OK).setText("Save", 'S');

	    setVisible(false);
	}

	public ComboChartLocation getDefaultFocusComponent() {
		return getComboChartLocation();
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void showDialog(String patNo, String volNo, String requiredBy, String requiredByDisplay, String purpose) {
		setPatNo(patNo);
		setVolNo(volNo);
		setRequiredBy(requiredBy);
		setRequiredByDisplay(requiredByDisplay);
		setPurpose(purpose);
//		recordID = patNo + "/" + volNo;

		getRequiredByText().setText(requiredByDisplay);
		getPurposeText().setText(purpose);

		setVisible(true);
	}

	protected void doOkAction() {
		if (!getComboChartLocation().isEmpty() && getComboChartLocation().isValid()) {
			MessageBoxBase.confirm("Confirm", "Are you sure to transfer chart to " +
					getComboChartLocation().getDisplayText() + " ?",
					new Listener<MessageBoxEvent>() {
				@Override
				public void handleEvent(MessageBoxEvent be) {
					if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
						saveAction();
					}
				}
			});
		} else {
			//error
			Factory.getInstance().addErrorMessage("Invalid Chart Location.");
		}
	}

	/**
	 * @return the patNo
	 */
	public String getPatNo() {
		return patNo;
	}

	/**
	 * @param patNo the patNo to set
	 */
	public void setPatNo(String patNo) {
		this.patNo = patNo;
	}

	/**
	 * @return the volNo
	 */
	public String getVolNo() {
		return volNo;
	}

	/**
	 * @param volNo the volNo to set
	 */
	public void setVolNo(String volNo) {
		this.volNo = volNo;
	}

	/**
	 * @return the requiredBy
	 */
	public String getRequiredBy() {
		return requiredBy;
	}

	/**
	 * @param requiredBy the requiredBy to set
	 */
	public void setRequiredBy(String requiredBy) {
		this.requiredBy = requiredBy;
	}

	/**
	 * @return the requiredByDisplay
	 */
	public String getRequiredByDisplay() {
		return requiredByDisplay;
	}

	/**
	 * @param requiredByDisplay the requiredByDisplay to set
	 */
	public void setRequiredByDisplay(String requiredByDisplay) {
		this.requiredByDisplay = requiredByDisplay;
	}

	/**
	 * @return the purpose
	 */
	public String getPurpose() {
		return purpose;
	}

	/**
	 * @param purpose the purpose to set
	 */
	public void setPurpose(String purpose) {
		this.purpose = purpose;
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	private LayoutContainer getBodyPanel() {
		if (body == null) {
			body = new BasePanel();
			body.add(getDescLabel());
			body.add(getChartLocationDesc());
			body.add(getComboChartLocation());
			body.add(getRequiredByDesc());
			body.add(getRequiredByText());
			body.add(getPurposeDesc());
			body.add(getPurposeText());
		}
		return body;
	}

	private LabelBase getDescLabel() {
		if (descLabel == null) {
			descLabel = new LabelBase("Transfer Chart to another department");
			descLabel.setStyleAttribute("font-weight", "bold");
			descLabel.setBounds(10, 5, 300, 30);
		}
		return descLabel;
	}

	private LabelBase getChartLocationDesc() {
		if (chartLocationDesc == null) {
			chartLocationDesc = new LabelBase("Chart Location");
			chartLocationDesc.setBounds(10, 40, 120, 20);
		}
		return chartLocationDesc;
	}

	private ComboChartLocation getComboChartLocation() {
		if (chartLocation == null) {
			chartLocation = new ComboChartLocation();
			chartLocation.setBounds(150, 40, 250, 20);
		}
		return chartLocation;
	}

	private LabelBase getRequiredByDesc() {
		if (requiredByDesc == null) {
			requiredByDesc = new LabelBase("Required By");
			requiredByDesc.setBounds(10, 70, 120, 20);
		}
		return requiredByDesc;
	}

	private TextReadOnly getRequiredByText() {
		if (requiredByText == null) {
			requiredByText = new TextReadOnly();
			requiredByText.setBounds(150, 70, 250, 20);
		}
		return requiredByText;
	}

	private LabelBase getPurposeDesc() {
		if (purposeDesc == null) {
			purposeDesc = new LabelBase("Purpose");
			purposeDesc.setBounds(10, 100, 120, 20);
		}
		return purposeDesc;
	}

	private TextReadOnly getPurposeText() {
		if (purposeText == null) {
			purposeText = new TextReadOnly();
			purposeText.setBounds(150, 100, 250, 20);
		}
		return purposeText;
	}

	private void saveAction() {
		QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				new String[] {
						"MedRecHdr h, MedRecDtl d",
						"h.MrhID, h.MrhSts, d.MrlID_S",
						"h.MrdID = d.MrdID and PatNo = '"+patNo+
						"' and MrhVolLab "+(volNo==null?"is null":("= '"+volNo+"' "))
				},
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					if (mQueue.getContentField()[0].length() > 0) {
						if (mQueue.getContentField()[1].equals("N")) {
							QueryUtil.executeMasterAction(
								Factory.getInstance().getUserInfo(),
								ConstantsTx.MRTRANSFER_TXCODE,
								QueryUtil.ACTION_APPEND,
								new String[] {
									mQueue.getContentField()[0],
									"T",
									Factory.getInstance().getUserInfo().getUserID(),
									mQueue.getContentField()[2],
									getComboChartLocation().getText(),
									getRequiredBy(),
									getRequiredByDisplay(),
									getPurpose()
								},
								new MessageQueueCallBack() {
									@Override
									public void onPostSuccess(
											MessageQueue mQueue) {
										if (mQueue.success()) {
											TableData data = chartDlg.getVolumeList().getSelectedItems().get(0);
											Record r = chartDlg.getVolumeList().getStore().getRecord(data);
											r.set(TableUtil.getName2ID("Current Location"), getComboChartLocation().getDisplayText());
											r.commit(true);
											chartDlg.getVolumeList().getStore().commitChanges();
										} else {
											//error
											Factory.getInstance().addErrorMessage("Error in transfering chart location. [Insert Data]");
										}
										dispose();
									}
								});
						} else {
							Factory.getInstance().addErrorMessage("Medical record is deleted or missing.");
							dispose();
						}
					} else {
						Factory.getInstance().addErrorMessage("Medical record is deleted or missing.");
						dispose();
					}
				} else {
					Factory.getInstance().addErrorMessage("Error in transfering chart location. [Retrieve Data]");
					dispose();
				}
			}
		});
	}
}