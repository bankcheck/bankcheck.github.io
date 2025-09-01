package com.hkah.client.tx.birth;


import com.extjs.gxt.ui.client.Style.Scroll;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.store.ListStore;
import com.extjs.gxt.ui.client.widget.form.Field;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.label.LabelBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.JScrollPane;
import com.hkah.client.layout.table.EditorTableList;
import com.hkah.client.layout.table.TableData;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.client.tx.MasterPanel;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TableUtil;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public class SendQueue extends MasterPanel{

	/* >>> ~1~ Set Transaction Code ======================================= <<< */
	@Override
	public String getTxCode() {
		// tx code to communicate with server
		return ConstantsTx.SENDQUEUE_TXCODE;

	}
	/* >>> ~2~ Set Transaction Title ====================================== <<< */
	@Override
	public String getTitle() {
		return ConstantsTx.SENDQUEUE_TITLE;
	}

	private BasePanel rightPanel = null;
	private BasePanel leftPanel = null;

	private LabelBase RemarkDesc = null;
	private ButtonBase SelectAll = null;
	private ButtonBase UnConfirm = null;
	private TextReadOnly count = null;
	private LabelBase countDesc = null;
	private boolean bSelect = true;

	//Arran Added
	private EditorTableList listTable = null;
	private JScrollPane jScrollPane = null;
	private int checkedIndex = 0;

	/**
	 * This method initializes
	 *
	 */
	public SendQueue() {
		super();
	}

	/* >>> ~7~ Set Pre-checking Before Init This Function ================= <<< */
	@Override
	public boolean init() {
		setNoGetDB(true);
		setLeftAlignPanel();
		getJScrollPane().setBounds(5, 80, 770,375);
		return true;
	}

	/* >>> ~8~ Set Initial Status For This Function ======================= <<< */
	@Override
	protected void initAfterReady() {
		getListTable().setColumnClass(6,new CheckBoxBase(), false);
		disableButton();
		searchAction();
	}

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	@Override
	public TextBase getDefaultFocusComponent() {
		int resultCnt = getListTable().getRowCount();
		count.setText(String.valueOf(resultCnt));
		disableButton();
		return null;//getSelectAll();
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
		if (bSelect) {
			return new String[] {NO_VALUE};
		} else {
			return new String[] {YES_VALUE};
		}
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

	/* >>> ~3~ Set Table Column Name ====================================== <<< */
	@Override
	protected String[] getColumnNames() {
		return new String[] {
			"",
			"#",
			"Mother #",
			"Mother Name",
			"BB #",
			"BB Name",
			"Selected",
			"Date of Birth",
			"Confirmed by",
			"Confirm Date/Time", "Sel"
		};
	}

	/* >>> ~4~ Set Table Column Widths ==================================== <<< */
	@Override
	protected int[] getColumnWidths() {
		return new int[] {
				10,
				20,
				70,
				100,
				70,
				100,
				70,
				100,
				100,
				120, 0
		};
	}

	//Arran Added
	private Field<? extends Object>[] getItemDetailEditor() {
		Field<? extends Object>[] editors=new Field<?>[11];
		editors[0] = null;
		editors[1] = null;
		editors[2] = null;
		editors[3] = null;
		editors[4] = null;
		editors[5] = null;
		editors[6]= getSelChkBox();
		editors[7] = null;
		editors[8] = null;
		editors[9] = null;
		editors[10] = null;
		return editors;
	}

	private CheckBoxBase getSelChkBox() {
        CheckBoxBase ChkBox = new CheckBoxBase();

        ChkBox.addListener(Events.OnClick, new Listener<FieldEvent>() {
            @Override
            public void handleEvent(FieldEvent be) {
                // TODO Auto-generated method stub
                final int selRow = listTable.getSelectedRow();

                final ListStore<TableData> store = listTable.getStore();

                final TableData rowData = store.getAt(selRow);

                if (((CheckBoxBase)be.getField()).getValue()) {
                	rowData.set(TableUtil.getName2ID("Sel"), YES_VALUE);
                } else {
                    rowData.set(TableUtil.getName2ID("Sel"), NO_VALUE);
                }


                String line = new String();

                for (int i = 0; i < 10; i++) {
                	line = line + "," + listTable.getValueAt(selRow, i).toString();
                }
            }
        });
        return ChkBox;
    }

	protected EditorTableList getEditorListTable() {
		int sum = 0;
		if (listTable == null) {
			for (int element : getColumnWidths()) {
		        sum = sum + element;
		    }
			listTable = new EditorTableList(getColumnNames(), getColumnWidths(), getItemDetailEditor()) {
				@Override
				public void onSelectionChanged() {
					if (isAppend() || isModify()) {
						getView().focusRow(getSelectedRow());
						getSelectionModel().select(getSelectedRow(), false);
//					} else if (isNoGetDB()) {
					} else if (!isAppend() && getEditorListTable().getSelectedRow() > -1) {
						getFetchOutputValues(getListSelectedRow());
					}
				};
			};
			listTable.setWidth(sum);
			listTable.setAutoHeight(true);
			listTable.addStyleName("master-panel-table-list");
		}
		return listTable;
	}

	private BasePanel getTablePanel() {
		BasePanel tablePanel = new BasePanel();
		tablePanel.setWidth(769);
		tablePanel.setBorders(true);
		tablePanel.setScrollMode(Scroll.AUTO);
		tablePanel.add(getEditorListTable());
		tablePanel.setHeight(220);
		return tablePanel;
	}

	@Override
	protected void performList(final boolean showMessage) {
		if (isNoListDB()) {
			// skip list
			return;
		}
		if (browseValidation()) {
			// set disable fields
			setAllLeftFieldsEnabled(false);
			setAllRightFieldsEnabled(false);

			// set loading flag true
			getMainFrame().setLoading(true);

			QueryUtil.executeMasterBrowse(
					getUserInfo(), getTxCode(), getBrowseInputParameters(),
					new MessageQueueCallBack() {
						public void onPostSuccess(MessageQueue mQueue) {

							if (mQueue != null) {
								// set table
								getEditorListTable().setListTableContent(mQueue);

								// handle data one by one if necessary
								//getBrowseOutputValues(mQueue.getContentField());

								if (showMessage) {
									if (mQueue.success()) {
										Factory.getInstance().addSystemMessage("Search Completed.");
									} else {
										Factory.getInstance().addErrorMessage(mQueue);
									}
								}
							} else {
								Factory.getInstance().addErrorMessage("Fail to connect server");
							}

							// set disable left fields
							setAllLeftFieldsEnabled(true);
							if (isAppend()) {
								setAllRightFieldsEnabled(true);
								appendDisabledFields();
							} else if (isModify()) {
								setAllRightFieldsEnabled(true);
								modifyDisabledFields();
							} else if (isDelete()) {
								setAllRightFieldsEnabled(true);
								deleteDisabledFields();
							}

							// enable button in search mode
							enableButton(SEARCH_MODE);
							getSaveButton().setEnabled(true);

							// call focus component

							if (getDefaultFocusComponent() != null) {
								getDefaultFocusComponent().focus();
							} else {
								getSearchButton().focus();
							}

							performListPost();

							getMainFrame().setLoading(false);
						}
					});
		}
	}

	protected void performListPost() {
		count.setValue(getEditorListTable().getRowCount() + "");
	}

	public void tableListCellClick(int col) {
		if (col==6) {
				String newValue =ConstantsVariable.YES_VALUE.equals(getListSelectedRow()[6])?ConstantsVariable.NO_VALUE:ConstantsVariable.YES_VALUE;  //  @jve:decl-index=0:
				getListTable().setValueAt(newValue, getListTable().getSelectedRow(), 6);
			}
	}

	/* >>> getter methods for init the Component start from here================================== <<< */
	@Override
	protected BasePanel getLeftPanel() {


		if (leftPanel == null) {
			countDesc = new LabelBase();
			countDesc.setBounds(5, 460, 33, 20);
			countDesc.setText("Count:");
			count = new TextReadOnly();
			count.setBounds(40, 460, 30, 20);
			leftPanel=new BasePanel();
			leftPanel.setSize(779, 518);
			leftPanel.add(getRemarkDesc(),null);
			leftPanel.add(getSelectAll(), null);
			leftPanel.add(getUnConfirm(), null);
			leftPanel.add(count, null);
			leftPanel.add(countDesc, null);
			leftPanel.add(getJScrollPane(), null);
		}
		return leftPanel;
	}

	protected BasePanel getRightPanel() {

		if (rightPanel == null) {
			rightPanel=new BasePanel();
			//leftPanel.setSize(800, 530));
		}
		return rightPanel;
	}

	//Arran Added
	protected JScrollPane getJScrollPane() {
		if (jScrollPane == null) {
			jScrollPane = new JScrollPane();
			jScrollPane.add(getTablePanel());
			//jScrollPane.setViewportView(getListTable());
		}
		return jScrollPane;
	}

	public LabelBase getRemarkDesc() {
		if (RemarkDesc == null) {
			RemarkDesc=new LabelBase();
			RemarkDesc.setText("<html>Confirm Birth data will be shown in Send Queue and send to HKSAR Government in specified time period. User could unconfirm selected birth records for <br> modifications. User could also send selected records immediately for ad-hoc purpose.</html>");
			RemarkDesc.setBounds(5, 10, 762, 34);
		}
		return RemarkDesc;
	}

	public ButtonBase getSelectAll() {
		if (SelectAll == null) {
			SelectAll=new ButtonBase() {
				@Override
				public void onClick() {

					/*int count = getEditorListTable().getRowCount();
					String selected = new String();
					if (count>0) {
						for (int i = 0; i < count; i++) {
							if (bSelect) {
								selected = YES_VALUE;
							} else {
								selected = NO_VALUE;
							}
							//getListTable().setValueAt(bSelect?YES_VALUE:NO_VALUE,i,6);
						}
						bSelect = !bSelect;
					}*/
					bSelect = !bSelect;
					searchAction();
				}
			};
			SelectAll.setText("Select All/Unselect All");
			SelectAll.setBounds(586, 49, 180, 20);
		}
		return SelectAll;
	}

	public ButtonBase getUnConfirm() {
		if (UnConfirm == null) {
			UnConfirm=new ButtonBase() {
				@Override
				public void onClick() {

					boolean isSelect = false;
					int count = getEditorListTable().getRowCount();
					String[] BBHospNum = new String[count];
					int j = 0;

					if (count>0) {
						for (int i = 0; i < count; i++) {
							if (YES_VALUE.equals(getEditorListTable().getValueAt(i, 10).toString())) {
								BBHospNum[j++] = getEditorListTable().getValueAt(i,4).toString();
								isSelect = true;
							}
						}

						final int size = j;

						for (String element : BBHospNum) {
							String[] inParam = new String[] {
									element,
									getUserInfo().getUserID()
							};

							if (element != null) {
								QueryUtil.executeMasterAction(getUserInfo(), ConstantsTx.EBIRTHUNCONFIRM_TXCODE, QueryUtil.ACTION_MODIFY, inParam,
									new MessageQueueCallBack() {
										int i = 0;

										@Override
										public void onPostSuccess(MessageQueue mQueue) {
											// TODO Auto-generated method stub
											checkedIndex++;

											if (checkedIndex >= size) {
												bSelect = false;
												checkedIndex = 0;
												searchAction();
											}
										}
									});
								}
							}

						if (!isSelect) {
							Factory.getInstance().addErrorMessage("Please select a record.");
						}
					}
				}
			};
			UnConfirm.setText("Un-Confirm");
			UnConfirm.setBounds(5, 490, 101, 20);
		}
		return UnConfirm;
	}}