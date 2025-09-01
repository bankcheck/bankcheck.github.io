package com.hkah.client.tx.transaction;

import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MessageBoxEvent;
import com.extjs.gxt.ui.client.store.ListStore;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.grid.ColumnData;
import com.extjs.gxt.ui.client.widget.grid.Grid;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboTelLogSortby;
import com.hkah.client.layout.dialog.DlgPkgCode;
import com.hkah.client.layout.dialog.MessageBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.GeneralGridCellRenderer;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextSlipNo;
import com.hkah.client.layout.textfield.TextString;
import com.hkah.client.tx.ActionPanel;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsMessage;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class TelLog extends ActionPanel {
	// property declare start
	private BasePanel actionPanel = null;
	private BasePanel ParaPanel = null;

	private LabelBase slipNoDesc = null;
	private TextSlipNo slipNo = null;
	private LabelBase chgCodeDesc = null;
	private TextString chgCode = null;
	private CheckBoxBase history = null;
	private LabelBase historyDesc = null;
	private LabelBase fromDateDesc = null;
	private TextDate fromDate = null;
	private LabelBase toDateDesc = null;
	private TextDate toDate = null;
	private LabelBase sortByDesc = null;
	private ComboTelLogSortby sortBy = null;

	private JScrollPane logScrollPane = null;

	private ButtonBase deleteLog = null;
	private ButtonBase moveItem2Ref = null;
	private ButtonBase moveItem2Chg = null;
	private ButtonBase moveAllItem2Ref = null;
	private ButtonBase moveAllItem2Chg = null;

	private DlgPkgCode telLogDialog = null;

	private String sSlpNos = null;
	private String sSrhSlpNo = null;

	private String memCurrentRegid = null;
	private String memSlipNo = null;
	private String memMovePkgCode = null;
	private boolean memOverride = false;

	private final String TX_R_VALUE = "R";
	private final String TX_ALERT_COLOR = "red";
	private final String TX_NORMAL_COLOR = "black";

	// change red color in table column if tx is R
	GeneralGridCellRenderer txColumn = new GeneralGridCellRenderer() {
		@Override
		public Object render(TableData model, String property,
				ColumnData config, int rowIndex, int colIndex,
				ListStore<TableData> store, Grid<TableData> grid) {
			super.render(model, property, config, rowIndex, colIndex, store, grid);
			String columnValue = (String) model.get(property);
			String style = TX_R_VALUE.equals(columnValue) ? TX_ALERT_COLOR : TX_NORMAL_COLOR;
			return "<span style='color:" + style + "'>" + columnValue + "</span>";
		}
	};

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.TELLOG_TXCODE;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.TELLOG_TITLE;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"",
			"From System",
			"Tx",
			"Slip No.",
			"Charge Code",
			"Unit",
			"Amount",
			"I-Ref",
			"Reason of Failed",
			"Status",
			"Deleted User",
			"Date",
			"Doctor",
			"Acm Code",
			"Transaction Date",
			"Description 1",
			"Charge Type",
			"Dept Code",
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				0,
				80,
				40,
				80,
				80,
				50,
				60,
				80,
				180,
				60,
				80,
				110,
				80,
				80,
				110,
				110,
				80,
				80
		};
	}

	protected GeneralGridCellRenderer[] getActionCellRenderer() {
		return new GeneralGridCellRenderer[] {
				null,
				null,
				txColumn,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null
		};
	}

	/**
	 * This method initializes
	 *
	 */
	public TelLog() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		boolean returnInit = super.init();
		setNoListDB(false);
		return returnInit;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		memCurrentRegid = getParameter("CurrentRegid");
		memSlipNo = getParameter("CurrentSlpNo");

		if (memCurrentRegid != null && memCurrentRegid.length() > 0) {
			getSlipNo().setReadOnly(true);
		}

		getSlipNo().setText(memSlipNo);
		setSlipToText(memCurrentRegid);

		// clean up stored parameter
		removeParameter("CurrentRegid");
		removeParameter("CurrentSlpNo");

		clearPostAction();
		searchAction(false);
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return getSlipNo();
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	@Override
	protected void deleteDisabledFields() {}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		if (
				getSlipNo().isEmpty() &&
				getChgCode().isEmpty() &&
				getFromDate().isEmpty() &&
				getToDate().isEmpty()
		) {
			Factory.getInstance().addErrorMessage(ConstantsMessage.MSG_INPUT_CRITERIA, "Tellog", getDefaultFocusComponent());
			return false;
		} else {
			return true;
		}
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				getSlipNo().getText().trim(),
				sSrhSlpNo,
				getChgCode().getText().trim(),
				getHistory().isSelected()?ONE_VALUE:ZERO_VALUE,
				getFromDate().getText().trim(),
				getToDate().getText().trim(),
				getSortBy().getText()
		};
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		return null;
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
		if (outParam != null) {
			boolean enable = !TX_R_VALUE.equals(outParam[2]) && !DELETE_VALUE.equals(outParam[9]);
			getDelete().setEnabled(!DELETE_VALUE.equals(outParam[9]));
			getMoveItem2Ref().setEnabled(enable);
			getMoveItem2Chg().setEnabled(enable);
			getMoveAllItem2Chg().setEnabled(enable);
		} else {
			getDelete().setEnabled(false);
			getMoveItem2Ref().setEnabled(false);
			getMoveItem2Chg().setEnabled(false);
			getMoveAllItem2Chg().setEnabled(false);
		}
		getMoveAllItem2Ref().setEnabled(false);

		// reset value when change table list selection
		memMovePkgCode = null;
		memOverride = false;
	}

	/* >>> ~15~ Set Fetch Output Results ============================== <<< */
	@Override
	protected void getBrowseOutputValues(String[] outParam) {}

	/* >>> ~17~ Set Action Input Parameters =============================== <<< */
	@Override
	protected String[] getActionInputParamaters() {
		return new String[] {};
	}

	/* >>> ~16.1~ Set Action Output Parameters =========================== <<< */
	@Override
	protected void getNewOutputValue(String returnValue) {}

	/***************************************************************************
	 * Override Methods
	 **************************************************************************/

	@Override
	protected void enableButton(String mode) {
		super.enableButton(mode);

		// enable/disable function
		disableButton();
		getSearchButton().setEnabled(true);
		getClearButton().setEnabled(true);

		// enable table
		if (memSlipNo != null) {
			getSlipNo().setReadOnly(true);
		} else {
			getSlipNo().setEnabled(true);
		}

		getChgCode().setEnabled(true);
		getHistory().setEnabled(true);
		getHistory().setEditable(true);
		getFromDate().setEnabled(true);
		getToDate().setEnabled(true);
		getSortBy().setEnabled(true);

		getLogScrollPane().setEnabled(true);
	}

	@Override
	protected void clearPostAction() {
		enableButton(null);

		if (sSlpNos != null) {
			getSlipNo().setText(sSlpNos);
		}
		getSortBy().setSelectedIndex(0);
	}

	/**
	 * override performListPost method
	 */
	@Override
	protected void performListPost() {
		super.performListPost();
		if (getListTable().getRowCount() > 0) {
			getFetchOutputValues(getListTable().getSelectedRowContent());
		} else {
			getFetchOutputValues(null);
		}
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	private void postTransaction(final String action) {
		if (getListTable().getRowCount() > 0 && getListTable().getSelectedRowContent() != null) {
			QueryUtil.executeMasterAction(getUserInfo(),
					getTxCode(), QueryUtil.ACTION_MODIFY,
					new String[] {action, getListTable().getSelectedRowContent()[0], getUserInfo().getUserID(), getUserInfo().getSiteCode(), memMovePkgCode, memOverride ? YES_VALUE : NO_VALUE},
					new MessageQueueCallBack() {
				@Override
				public void onPostSuccess(MessageQueue mQueue) {
					if (mQueue.success()) {
						if (action == null || !"D".equals(action.toUpperCase())) {
							Factory.getInstance().addInformationMessage(mQueue.getReturnMsg(),
									new Listener<MessageBoxEvent>() {
								@Override
								public void handleEvent(MessageBoxEvent be) {
									searchAction();
								}
							});
						} else {
							searchAction();
						}
					} else if ("-100".equals(mQueue.getReturnCode())) {
						// need user interaction
						MessageBoxBase.confirm(MSG_PBA_SYSTEM, mQueue.getReturnMsg(),
								new Listener<MessageBoxEvent>() {
							@Override
							public void handleEvent(MessageBoxEvent be) {
								if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
									getTelLogDialog(action).showDialog("TelLog", memSlipNo);
								}
							}
						});
					} else {
						Factory.getInstance().addErrorMessage(mQueue);
					}
				}
			});
		} else {
			 Factory.getInstance().addErrorMessage("Please select a record.", "PBA-[Log]");
		}
	}

	private DlgPkgCode getTelLogDialog(final String action) {
		if (telLogDialog == null) {
			telLogDialog = new DlgPkgCode(getMainFrame()) {
				@Override
				public void afterVerifyAction(final String movePkgCode, final String movePkgStnSeq) {
					if (movePkgCode != null) {
						memMovePkgCode = movePkgCode;
						memOverride = true;

						postTransaction(action);
					}
				}
			};
		}
		return telLogDialog;
	}

	private void setSlipToText(String lRegid) {
		String[] para = null;
		if (lRegid == null || lRegid.trim().length() == 0 || ZERO_VALUE.equals(lRegid)) {
			 para = new String[] {"slip", "slpNO", "slpsts<>'R' and slpno='" + getSlipNo().getText().trim() + "'"};
		} else {
			 para = new String[] {"slip", "slpNO", "slpsts<>'R' and regid=" + lRegid};
		}

		QueryUtil.executeMasterBrowse(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
				para,
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				if (mQueue.success()) {
					StringBuffer sSlpNosSB = new StringBuffer();
					StringBuffer sSrhSlpNoSB = new StringBuffer();

					TableList list = CommonUtil.getRs2col(1);
					list.setListTableContent(mQueue);
					if (list.getRowCount() >= 0 && list.getRowCount() < 100) {
						for (int i=0; i<list.getRowCount(); i++) {
							if (i > 0) {
								sSlpNosSB.append(",");
								sSrhSlpNoSB.append(",");
							}
							sSlpNosSB.append(list.getRowContent(i)[0]);
							sSrhSlpNoSB.append("'");
							sSrhSlpNoSB.append(list.getRowContent(i)[0]);
							sSrhSlpNoSB.append("'");
						}
					}
					sSlpNos = sSlpNosSB.toString();
					sSrhSlpNo = sSrhSlpNoSB.toString();

					getSlipNo().setText(sSlpNos);
					//searchAction();
				}
			}
		});
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected BasePanel getActionPanel() {
		if (actionPanel == null) {
			actionPanel = new BasePanel();
			actionPanel.setSize(779, 528);
			actionPanel.add(getParaPanel(), null);
			actionPanel.add(getLogScrollPane(), null);
			actionPanel.add(getDelete(), null);
			actionPanel.add(getMoveItem2Chg(), null);
			actionPanel.add(getMoveItem2Ref(), null);
			actionPanel.add(getMoveAllItem2Chg(), null);
			actionPanel.add(getMoveAllItem2Ref(), null);
		}
		return actionPanel;
	}

	public BasePanel getParaPanel() {
		if (ParaPanel == null) {
			ParaPanel = new BasePanel();
			ParaPanel.setEtchedBorder();
			ParaPanel.setBounds(5, 5, 757, 80);
			ParaPanel.add(getSlipNoDesc(), null);
			ParaPanel.add(getSlipNo(), null);
			ParaPanel.add(getChgCodeDesc(), null);
			ParaPanel.add(getChgCode(), null);
			ParaPanel.add(getHistoryDesc(), null);
			ParaPanel.add(getHistory(), null);
			ParaPanel.add(getFromDateDesc(), null);
			ParaPanel.add(getFromDate(), null);
			ParaPanel.add(getToDateDesc(), null);
			ParaPanel.add(getToDate(), null);
			ParaPanel.add(getSortByDesc(), null);
			ParaPanel.add(getSortBy(), null);
		}
		return ParaPanel;
	}

	public LabelBase getSlipNoDesc() {
		if (slipNoDesc == null) {
			slipNoDesc = new LabelBase();
			slipNoDesc.setText("Slip No.");
			slipNoDesc.setBounds(5, 10, 80, 20);
		}
		return slipNoDesc;
	}

	public TextSlipNo getSlipNo() {
		if (slipNo == null) {
			slipNo = new TextSlipNo();
			slipNo.setBounds(70, 10, 450, 20);
		}
		return slipNo;
	}

	public LabelBase getChgCodeDesc() {
		if (chgCodeDesc == null) {
			chgCodeDesc = new LabelBase();
			chgCodeDesc.setText("Charge Code");
			chgCodeDesc.setBounds(535, 10, 130, 20);
		}
		return chgCodeDesc;
	}

	public TextString getChgCode() {
		if (chgCode == null) {
			chgCode = new TextString();
			chgCode.setBounds(630, 10, 120, 20);
		}
		return chgCode;
	}

	public LabelBase getHistoryDesc() {
		if (historyDesc == null) {
			historyDesc = new LabelBase();
			historyDesc.setText("History");
			historyDesc.setBounds(6, 40, 80, 20);
		}
		return historyDesc;
	}

	public CheckBoxBase getHistory() {
		if (history == null) {
			history = new CheckBoxBase();
			history.setBounds(60, 40, 25, 20);
		}
		return history;
	}

	public LabelBase getFromDateDesc() {
		if (fromDateDesc == null) {
			fromDateDesc = new LabelBase();
			fromDateDesc.setText("From Date");
			fromDateDesc.setBounds(120, 40, 80, 20);
		}
		return fromDateDesc;
	}

	public TextDate getFromDate() {
		if (fromDate == null) {
			fromDate = new TextDate();
			fromDate.setBounds(190, 40, 120, 20);
		}
		return fromDate;
	}

	public LabelBase getToDateDesc() {
		if (toDateDesc == null) {
			toDateDesc = new LabelBase();
			toDateDesc.setText("To Date");
			toDateDesc.setBounds(330, 40, 80, 20);
		}
		return toDateDesc;
	}

	public TextDate getToDate() {
		if (toDate == null) {
			toDate = new TextDate();
			toDate.setBounds(400, 40, 120, 20);
		}
		return toDate;
	}

	public LabelBase getSortByDesc() {
		if (sortByDesc == null) {
			sortByDesc = new LabelBase();
			sortByDesc.setText("Sort By");
			sortByDesc.setBounds(535, 40, 80, 20);
		}
		return sortByDesc;
	}

	public ComboTelLogSortby getSortBy() {
		if (sortBy == null) {
			sortBy = new ComboTelLogSortby();
			sortBy.setBounds(630, 40, 120, 20);
		}
		return sortBy;
	}

	protected JScrollPane getLogScrollPane() {
		if (logScrollPane == null) {
			logScrollPane = new JScrollPane();
			logScrollPane.setBounds(5, 90, 757, 345);
			logScrollPane.setViewportView(getListTable());
		}
		return logScrollPane;
	}

	public ButtonBase getDelete() {
		if (deleteLog == null) {
			deleteLog = new ButtonBase() {
				@Override
				public void onClick() {
					MessageBoxBase.confirm(MSG_PBA_SYSTEM, "Are you sure to delete?", new Listener<MessageBoxEvent>() {
						@Override
						public void handleEvent(MessageBoxEvent be) {
							if (Dialog.YES.equalsIgnoreCase(be.getButtonClicked().getItemId())) {
								postTransaction("D");
							}
						}
					});
				}
			};
			deleteLog.setText("Delete");
			deleteLog.setBounds(10, 445, 100, 25);
		}
		return deleteLog;
	}

	public ButtonBase getMoveItem2Ref() {
		if (moveItem2Ref == null) {
			moveItem2Ref = new ButtonBase() {
				@Override
				public void onClick() {
					postTransaction("I2R");
				}
			};
			moveItem2Ref.setText("Move Item to Ref");
			moveItem2Ref.setBounds(120, 445, 120, 25);
		}
		return moveItem2Ref;
	}

	public ButtonBase getMoveItem2Chg() {
		if (moveItem2Chg == null) {
			moveItem2Chg = new ButtonBase() {
				@Override
				public void onClick() {
					postTransaction("I2C");
				}
			};
			moveItem2Chg.setText("Move Item to Charge");
			moveItem2Chg.setBounds(250, 445, 120, 25);
		}
		return moveItem2Chg;
	}

	public ButtonBase getMoveAllItem2Ref() {
		if (moveAllItem2Ref == null) {
			moveAllItem2Ref = new ButtonBase() {
				@Override
				public void onClick() {
					postTransaction("AI2R");
				}
			};
			moveAllItem2Ref.setText("Move All Item to Ref");
			moveAllItem2Ref.setBounds(380, 445, 120, 25);
		}
		return moveAllItem2Ref;
	}

	public ButtonBase getMoveAllItem2Chg() {
		if (moveAllItem2Chg == null) {
			moveAllItem2Chg = new ButtonBase() {
				@Override
				public void onClick() {
					postTransaction("AI2C");
				}
			};
			moveAllItem2Chg.setText("Move All Item to Charge");
			moveAllItem2Chg.setBounds(510, 445, 120, 25);
		}
		return moveAllItem2Chg;
	}
}