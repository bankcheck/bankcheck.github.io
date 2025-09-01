package com.hkah.client.tx.report;

import java.util.List;

import com.google.gwt.user.client.rpc.AsyncCallback;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.combobox.ComboHatsQuery;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.table.BufferedTableList;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.tx.MaintenancePanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class HatsQuery extends MaintenancePanel {

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return null;
	}

	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return null;
	}

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
				"",
				""
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				200,
				400
		};
	}

	/* >>> ~5~ Set Left Side Fields ======================================= <<< */
	private ColumnLayout leftPanel = null;  //  @jve:decl-index=0:visual-constraint="10,649"

	/* >>> ~6~ Set Right Side Fields ====================================== <<< */
	private BasePanel rightPanel = null;  //  @jve:decl-index=0:visual-constraint="12,14"
	private ColumnLayout generalPanel = null;
	private LabelBase RightJLabel_SelectTable = null;
	private ComboHatsQuery RightJText_SelectTable = null;
	private ButtonBase RightJButton_SelectTable = null;
	private TableList tempTable = null;

	private String oldCode = null;

	private String memUrl = "http://www-server/intranet/documentManage/download.jsp?documentID=635";
	private final static String WEBSIT_COMMAND = "Show Courtesy Discount Policy";
	private ButtonBase ButtonBase_WebSite = null;
	private LabelBase RightJLabel_WebSite = null;
	/**
	 * This method initializes
	 *
	 */
	public HatsQuery() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		getListTable().hide();
		displayEmptyTable();
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getSearchButton().setEnabled(false);
		getAppendButton().setEnabled(false);
		getRightJText_SelectTable().setEnabled(true);
		getRightJButton_SelectTable().setEnabled(true);
		getRightJText_SelectTable().clear();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		return null;
	}

	/* >>> ~10~ Do something after action perform ========================= <<< */
	@Override
	protected void confirmCancelButtonClicked() {
		// override function if necessary
	}

	/* >>> ~11~ Set Disable Fields When Append ButtonBase Is Clicked ====== <<< */
	@Override
	protected void appendDisabledFields() {

	}

	/* >>> ~12~ Set Disable Fields When Modify ButtonBase Is Clicked ====== <<< */
	@Override
	protected void modifyDisabledFields() {
	}

	/* >>> ~13~ Set Disable Fields When Delete ButtonBase Is Clicked ====== <<< */
	@Override
	protected void deleteDisabledFields() {
		// enable/disable field
	}

	/* >>> ~14~ Set Browse Validation ===================================== <<< */
	@Override
	protected boolean browseValidation() {
		return true;
	}

	/* >>> ~15~ Set Browse Input Parameters =============================== <<< */
	@Override
	protected String[] getBrowseInputParameters() {
		return new String[] {
				EMPTY_VALUE,
				EMPTY_VALUE
		};
	}

	/* >>> ~16~ Set Fetch Input Parameters ================================ <<< */
	@Override
	protected String[] getFetchInputParameters() {
		String[] selectedContent = getListSelectedRow();

		return new String[] {
				selectedContent[0]
		};
	}

	/* >>> ~16.1~ Set Fetch Output Results ================================ <<< */
	@Override
	protected void getFetchOutputValues(String[] outParam) {
		int index = 0;
	}

	@Override
	public boolean isTableViewOnly() {
		return true;
	}

	@Override
	protected String[] getActionInputParamaters(String[] selectedContent) {
		return new String[] {
				selectedContent[0],
				selectedContent[1],
				oldCode
		};
	}

	@Override
	protected boolean actionValidation(String[] selectedContent) {
		return true;
	}

	@Override
	protected void enableButton(String mode) {
		super.enableButton(mode);
		if (isAppend() || isModify()) {
			getClearButton().setEnabled(true);
			getSearchButton().setEnabled(false);
		} else {
			getClearButton().setEnabled(false);
			getSearchButton().setEnabled(true);
		}
		getRefreshButton().setEnabled(false);
	}

	@Override
	public void cancelYesAction() {
		searchAction();
	}

	@Override
	protected void performListPost() {
		if(getListTable().getRowCount() > 0) {
			getListTable().setSelectRow(0);
		}
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	/**
	 * This method initializes leftPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getSearchPanel() {
		if (leftPanel == null) {
//			leftPanel.setSize(495, 110);

		}
		return leftPanel;
	}

	/**
	 * This method initializes generalPanel
	 *
	 * @return com.hkah.client.layout.panel.BasePanel
	 */
	protected ColumnLayout getActionPanel() {
		if (generalPanel == null) {
			generalPanel = new ColumnLayout(3,1, new int[] {80, 450, 100});
			generalPanel.setBounds(0, 0, 650, 40);
			generalPanel.add(0,0,getRightJLabel_SelectTable());
			generalPanel.add(1,0,getRightJText_SelectTable());
			generalPanel.add(2,0,getRightJButton_SelectTable());
//			generalPanel.add(3,0,getButtonBase_WebSite());
		}
		return generalPanel;
	}

	private LabelBase getRightJLabel_SelectTable() {
		if (RightJLabel_SelectTable == null) {
			RightJLabel_SelectTable = new LabelBase();
			RightJLabel_SelectTable.setText("Select Table");
//			RightJLabel_ReligiousCode.setBounds(44, 33, 121, 20);
		}
		return RightJLabel_SelectTable;
	}

	private ComboHatsQuery getRightJText_SelectTable() {
		if (RightJText_SelectTable == null) {
			RightJText_SelectTable = new ComboHatsQuery();
			RightJText_SelectTable.setWidth(450);
		}
		return RightJText_SelectTable;
	}

	public ButtonBase getRightJButton_SelectTable() {
		if (RightJButton_SelectTable == null) {
			RightJButton_SelectTable = new ButtonBase() {
				@Override
				public void onClick() {
					Factory.getInstance().showMask();
					QueryUtil.executeMasterFetch(getUserInfo(), ConstantsTx.LOOKUP_TXCODE,
							new String[] { "AA_QUERY", "STATEMENT", "name='" + getRightJText_SelectTable().getDisplayText() + "'" },
							new MessageQueueCallBack() {
						@Override
						public void onPostSuccess(MessageQueue mQueue) {
							if (mQueue.success()) {
								final String stmt = mQueue.getContentField()[0];
								QueryUtil.executeMasterBrowse(getUserInfo(), "LOOKUP_EMPTY",
										new String[] { stmt, "", "" },
										new MessageQueueCallBack() {
									@Override
									public void onPostSuccess(final MessageQueue mQueue) {
										if (mQueue.success()) {
											// get column names
											QueryUtil.getQueryCols(stmt,
													new AsyncCallback<List<String>>() {
														@Override
														public void onFailure(
																Throwable caught) {
															displayQueryTable(mQueue, null);
														}

														@Override
														public void onSuccess(
																List<String> result) {
															displayQueryTable(mQueue, result);
														}
											});
										} else {
											displayEmptyTable();
											Factory.getInstance().addErrorMessage("No data found in reply of this query.");
										}
									}

									@Override
									public void onComplete() {
										// do not hideMask
									}
								});
							} else {
								displayEmptyTable();
								Factory.getInstance().addErrorMessage("Cannot find query.");
							}
						}

						@Override
						public void onComplete() {
							// do not hideMask
						}
					});
				}
			};
			RightJButton_SelectTable.setText("View");
		}
		return RightJButton_SelectTable;
	}

	private void displayQueryTable(MessageQueue mQueue, List<String> colHeaders) {
		getBodyPanel().remove(tempTable);
		getBodyPanel().remove(getButtonBase_WebSite());

		String[] record = TextUtil.split(mQueue.getContentAsQueue(), TextUtil.LINE_DELIMITER);
		if(record.length > 0) {
			int numOfColumns = TextUtil.split(record[0]).length;
			int numOfColHeaders = colHeaders == null ? 0 : colHeaders.size();

			String[] colName = new String[numOfColumns];
			for (int i=0; i < numOfColumns; i++) {
				if (numOfColHeaders >= numOfColumns) {
					colName[i] = colHeaders.get(i);
				} else {
					colName[i] = Integer.toString(i+1);
				}
			}

			int[] colWidth = new int[numOfColumns];
			for (int i=0; i < numOfColumns; i++) {
				colWidth[i] = 100;
				if("Name".equals(colName[i])) {
					colWidth[i] = 150;
				}
			}

			tempTable = new BufferedTableList(
					colName,
					colWidth,
					getActionCellRenderer()) {
				@Override
				public void setListTableContentPost() {
					super.setListTableContentPost();
					Factory.getInstance().hideMask();
				}
			};
			tempTable.setWidth(815);
			tempTable.setHeight(350);
			getBodyPanel().add(tempTable);
			getBodyPanel().add(getButtonBase_WebSite());
			getBodyPanel().layout(true);
			tempTable.setListTableContent(mQueue);
		}
	}

	private void displayEmptyTable() {
		getBodyPanel().remove(tempTable);
		getBodyPanel().remove(getButtonBase_WebSite());
		tempTable = new TableList(
				new String[] {
						"",
						""
				},
				new int[] {
						100,
						100
				},
				getActionCellRenderer());
		tempTable.setWidth(815);
		tempTable.setHeight(350);
		getBodyPanel().add(tempTable);
		getBodyPanel().add(getRightJLabel_WebSite());
		getBodyPanel().add(getButtonBase_WebSite());
		getBodyPanel().layout(true);
		Factory.getInstance().hideMask();
	}

	public static BasePanel openWebQuery() {
		return new BasePanel();
	}

	private LabelBase getRightJLabel_WebSite() {
		if (RightJLabel_WebSite == null) {
			RightJLabel_WebSite = new LabelBase();
			RightJLabel_WebSite.setText("");
			RightJLabel_WebSite.setWidth(80);
			RightJLabel_WebSite.setHeight(20);
		}
		return RightJLabel_WebSite;
	}

	public ButtonBase getButtonBase_WebSite() {
		if (ButtonBase_WebSite == null) {
			ButtonBase_WebSite = new ButtonBase() {
				@Override
				public void onClick() {
					openNewWindow(memUrl);
				}
			};
			ButtonBase_WebSite.setText(WEBSIT_COMMAND);
			ButtonBase_WebSite.setWidth(200);
			ButtonBase_WebSite.setHeight(40);
//			ButtonBase_WebSite.setBounds(0, 800, 150, 40);
			getBodyPanel().add(ButtonBase_WebSite);
			getBodyPanel().layout(true);
		}
		return ButtonBase_WebSite;
	}
}