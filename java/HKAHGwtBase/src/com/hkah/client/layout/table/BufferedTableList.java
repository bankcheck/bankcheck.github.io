package com.hkah.client.layout.table;

import java.util.ArrayList;
import java.util.List;

import com.extjs.gxt.ui.client.GXT;
import com.extjs.gxt.ui.client.Style.SortDir;
import com.extjs.gxt.ui.client.data.BasePagingLoadConfig;
import com.extjs.gxt.ui.client.data.BasePagingLoadResult;
import com.extjs.gxt.ui.client.data.BasePagingLoader;
import com.extjs.gxt.ui.client.data.DataProxy;
import com.extjs.gxt.ui.client.data.DataReader;
import com.extjs.gxt.ui.client.data.LoadEvent;
import com.extjs.gxt.ui.client.data.Loader;
import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.data.PagingLoadResult;
import com.extjs.gxt.ui.client.data.PagingLoader;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.MenuEvent;
import com.extjs.gxt.ui.client.event.SelectionListener;
import com.extjs.gxt.ui.client.store.ListStore;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.menu.Menu;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.hkah.client.layout.menu.CheckMenuItemBase;
import com.hkah.client.layout.menu.MenuItemBase;
import com.hkah.shared.model.MessageQueue;

public class BufferedTableList extends TableList {

	private boolean useCacheResult = false;
	private List<TableData> cacheResult = null;
	private PagingLoader<PagingLoadResult<ModelData>> loader = null;
	private MessageQueue mQueue = null;
	private BufferedTableList thisTableList = this;
	private BufferedTableView liveView = null;
	private int cursorInt = 0;
	private boolean isShowSort = false;
	private boolean isSelectOnList = true;
	private BufferedTableSelectionModel selectionModel = null;

	public BufferedTableList(String[] columnNames, int[] columnWidths) {
		super(columnNames, columnWidths, false, null, null, false, null, false, null);
	}

	public BufferedTableList(String[] columnNames, int[] columnWidths, GeneralGridCellRenderer[] actionCellRenderer) {
		super(columnNames, columnWidths, false, null, null, false, null, false, actionCellRenderer);
	}

	public BufferedTableList(String[] columnNames, int[] columnWidths,
			boolean addNumberingColumn, GeneralGridCellRenderer[] actionCellRenderer) {
		super(columnNames, columnWidths, addNumberingColumn, null, null, false, null, false, actionCellRenderer);
	}

	public BufferedTableList(String[] columnNames, int[] columnWidths,
			boolean addNumberingColumn,boolean isShowSrt,boolean isShowMenu, GeneralGridCellRenderer[] actionCellRenderer) {
		super(columnNames, columnWidths, addNumberingColumn, null, null, false, null, false,isShowMenu, actionCellRenderer);
		this.isShowSort = isShowSrt;
	}

	public BufferedTableList(String[] columnNames, int[] columnWidths,
			boolean addNumberingColumn,boolean isShowSrt,boolean isShowMenu,
			GeneralGridCellRenderer[] actionCellRenderer, int columnKey) {
		super(columnNames, columnWidths, addNumberingColumn, null, null, false, null, false,isShowMenu, actionCellRenderer);
		this.isShowSort = isShowSrt;
		this.columnKey = columnKey;
	}

	protected void initColumnHelper() {
		store = new ListStore<TableData>(getLoader());
		setView(getTableView());

		disabledStyle = null;
		baseStyle = "x-grid-panel";

		setSelectionModel(getBufferSelectionModel());
		disableTextSelection(true);
	}

	private BufferedTableSelectionModel getBufferSelectionModel() {
		if (selectionModel == null) {
			selectionModel = new BufferedTableSelectionModel(getTableView()) {
				@Override
				public void doSingleSelectPost(ModelData model, int offset) {
					if (columnKey > -1) {
						lastSelectedItemKey = model.get(thisTableList.getColumnModel().getColumnId(columnKey));
					}
				}
			};
		}
		return selectionModel;
	}

	public void keepSelection(ListStore<ModelData> displayStore) {
		if (lastSelectedItemKey != null && displayStore != null && columnKey > -1) {
			for (ModelData m : displayStore.getModels()) {
				if (m.get(thisTableList.getColumnModel().getColumnId(columnKey)).equals(lastSelectedItemKey)) {
					getView().focusRow(displayStore.indexOf(m));
					getSelectionModel().select(displayStore.indexOf(m), false);
					return;
				}
			}
		}
	}

	public void reSelection(boolean scrollToRecord) {
		if (columnKey > -1) {
			if (lastSelectedItemKey != null && cacheResult != null) {
				for (ModelData m : ((BufferedTableView)thisTableList.getView()).getDisplayStore().getModels()) {
					if (m.get(thisTableList.getColumnModel().getColumnId(columnKey)).equals(lastSelectedItemKey)) {
						//getView().focusRow(((BufferedTableView)thisTableList.getView()).getDisplayStore().indexOf(m));
						getSelectionModel().select(((BufferedTableView)thisTableList.getView()).getDisplayStore().indexOf(m), false);
						return;
					}
				}

				for (TableData m : cacheResult) {
					if (m.get(thisTableList.getColumnModel().getColumnId(columnKey)).equals(lastSelectedItemKey)) {
						thisTableList.getSelectionModel().select(m, false);
						if (scrollToRecord) {
							((BufferedTableView)thisTableList.getView()).updateRows(cacheResult.indexOf(m), false);
						}
						return;
					}
				}
			}
			else {
				thisTableList.getSelectionModel().select(0, false);
			}
		}
		else {
			//original re-selection
			if (getRowCount() > 0) {
				if (cursorInt < 0) {
					// set focus to the first line
					cursorInt = 0;
				} else if (cursorInt > getRowCount()) {
					// set focus to the end of line if cursor index > record count
					cursorInt = getRowCount();
				}
				if (getSelectOnList()) {
					getView().focusRow(cursorInt);
					getSelectionModel().select(cursorInt, false);
				}
			}
		}
	}

	private BufferedTableView getTableView() {
		if (liveView == null) {
			liveView = new BufferedTableView() {
				@Override
				public void updateRowsPost(ListStore<ModelData> displayStore) {
					keepSelection(displayStore);
				}

				@Override
				protected void updateRows(int newIndex, boolean reload) {
					if (thisTableList.isViewReady() && liveScroller != null) {
						super.updateRows(newIndex, reload);
					}
					else if (newIndex == 0) {
						viewIndex = newIndex;
					}
				}

				private void restrictMenu(Menu columns) {
					int count = 0;
					for (int i = 0, len = cm.getColumnCount(); i < len; i++) {
						if (!shouldNotCount(i, true)) {
							count++;
						}
					}

					if (count == 1) {
						for (Component item : columns.getItems()) {
							CheckMenuItemBase ci = (CheckMenuItemBase) item;
							if (ci.isChecked()) {
								ci.disable();
							}
						}
					} else {
						for (Component item : columns.getItems()) {
							item.enable();
						}
					}
				}

				private boolean shouldNotCount(int columnIndex, boolean includeHidden) {
					return cm.getColumnHeader(columnIndex) == null || cm.getColumnHeader(columnIndex).equals("")
						|| (includeHidden && cm.isHidden(columnIndex)) || cm.isFixed(columnIndex);
				}

				@Override
				protected Menu createContextMenu(final int colIndex) {
					final Menu menu = new Menu();

					if (cm.isSortable(colIndex)&& isShowSort) {
						MenuItemBase item = new MenuItemBase();
						item.setText(GXT.MESSAGES.gridView_sortAscText());
						item.setIcon(getImages().getSortAsc());
						item.addSelectionListener(new SelectionListener<MenuEvent>() {
							public void componentSelected(MenuEvent ce) {
								doSort(colIndex, SortDir.ASC);
							}
						});
						menu.add(item);

						item = new MenuItemBase();
						item.setText(GXT.MESSAGES.gridView_sortDescText());
						item.setIcon(getImages().getSortDesc());
						item.addSelectionListener(new SelectionListener<MenuEvent>() {
							public void componentSelected(MenuEvent ce) {
								doSort(colIndex, SortDir.DESC);
							}
						});
						menu.add(item);
					}

					MenuItemBase columns = new MenuItemBase();
					columns.setText(GXT.MESSAGES.gridView_columnsText());
					columns.setIcon(getImages().getColumns());
					columns.setData("gxt-columns", "true");

					final Menu columnMenu = new Menu();

					int cols = cm.getColumnCount();
					for (int i = 0; i < cols; i++) {
						if (shouldNotCount(i, false)) {
							continue;
						}

						final int fcol = i;
						final CheckMenuItemBase check = new CheckMenuItemBase();
						check.setHideOnClick(false);
						check.setText(cm.getColumnHeader(i));
						check.setChecked(!cm.isHidden(i));
						check.addSelectionListener(new SelectionListener<MenuEvent>() {
							public void componentSelected(MenuEvent ce) {
								cm.setHidden(fcol, !cm.isHidden(fcol));
								restrictMenu(columnMenu);
							}
						});

						if(cm.getColumn(i).getWidth()> 0) {
							columnMenu.add(check);
						}
					}

					restrictMenu(columnMenu);
					columns.setEnabled(columnMenu.getItemCount() > 0);
					columns.setSubMenu(columnMenu);
					menu.add(columns);

					if (getMenuDefault1Listing() != null && getMenuDefault1Listing().length > 0) {
						MenuItemBase itemDefault = new MenuItemBase();
						itemDefault.setText("Default Filter");
						itemDefault.setIcon(getImages().getColumns());
						itemDefault.addSelectionListener(new SelectionListener<MenuEvent>() {
							public void componentSelected(MenuEvent ce) {
								int cols = cm.getColumnCount();
								for (int i = 0; i < cols; i++) {
									if (shouldNotCount(i, false)) {
										continue;
									}
									cm.setHidden(i,getMenuDefault1Listing()[i]);
								}
							}
						});
						menu.add(itemDefault);
					}
					return menu;
				}
			};
		}
		return liveView;
	}

	// for child override
	public boolean[] getMenuDefault1Listing() {
		return null;
	}

	// for child override
	public boolean[] getMenuDefault2Listing() {
		return null;
	}

	private PagingLoader<PagingLoadResult<ModelData>> getLoader() {
		if (loader == null) {
			loader = new BasePagingLoader<PagingLoadResult<ModelData>>(new DataProxy<PagingLoadResult<ModelData>>() {
				@Override
				public void load(DataReader<PagingLoadResult<ModelData>> reader,
						Object loadConfigAsObject, final AsyncCallback<PagingLoadResult<ModelData>> callback) {

					BasePagingLoadConfig loadConfig = (BasePagingLoadConfig) loadConfigAsObject;
					final int offset = loadConfig.getOffset();
					final int limit = loadConfig.getLimit();
					//System.err.println("offset: "+offset);
					//System.err.println("limit: "+limit);

					// Get the results for the requested page...
					final List<ModelData> resultData = new ArrayList<ModelData>();
					int totalLength = 0;

					if (isUseCacheResult() && offset > 0) {
						//System.err.println("Use cache result....");
						// use cache
						if (cacheResult != null) {
							for (int i = offset; i < offset + limit; i++) {
								if (i < cacheResult.size()) {
									resultData.add(cacheResult.get(i));
								}
							}
							totalLength = cacheResult.size();
						}
					} else {
						if (cacheResult == null) {
							cacheResult = new ArrayList<TableData>();
						}
						cacheResult.clear();

						if (getMessageQueue() != null) {
							List<TableData> list = MessageQueue2List(getMessageQueue());
							if (list != null) {
								totalLength = list.size();
//								mask(); //for unmasking if there is mask for loading data

								for (int i = 0; i < totalLength; i++) {
									if (i >= offset && i < offset + limit) {
										resultData.add(list.get(i));
									}
									cacheResult.add(list.get(i));
								}
							}
//							unmask(); //for unmasking if there is mask for loading data
						}
					}
					callback.onSuccess(new BasePagingLoadResult<ModelData>(resultData, offset, totalLength));
				}
			}) {
				@Override
				protected void onLoadSuccess(Object loadConfig, PagingLoadResult<ModelData> result) {
					super.onLoadSuccess(loadConfig, result);
					/* here you do the re-selection */
					reSelection(false);
				}
			};
			loader.addListener(Loader.BeforeLoad, new Listener<LoadEvent>() {
				public void handleEvent(LoadEvent be) {
					if (getStore().getCount() == 0) {
						be.<ModelData> getConfig().set("start", 0);
						be.<ModelData> getConfig().set("offset", 0);
					}
					else {
						be.<ModelData> getConfig().set("start", be.<ModelData> getConfig().get("offset"));
						be.<ModelData> getConfig().set("offset", be.<ModelData> getConfig().get("offset"));
					}
				}
			});
		}
		return loader;
	}

	@Override
	protected void setListTableContent(MessageQueue mQueue, boolean clearTable) {
		setListTableContentPrev();
		cursorInt = getSelectedRow();

		// clear table
		if (clearTable) {
			removeAllRow();
			lastSelectedItemKey = null;
		}

		setMessageQueue(mQueue);
		getStore().getLoader().load();

		setListTableContentPost();
		getView().layout();
	}

	/***************************************************************************
	 * Get/Set/Remove Functions
	 **************************************************************************/

	public MessageQueue getMessageQueue() {
		return mQueue;
	}

	public void setMessageQueue(MessageQueue mQueue) {
		this.mQueue = mQueue;
	}

	public boolean isUseCacheResult() {
		return useCacheResult;
	}

	public void setUseCacheResult(boolean useCacheResult) {
		this.useCacheResult = useCacheResult;
	}

	public boolean isShowSort() {
		return isShowSort;
	}

	public void setShowSort(boolean isShowSort) {
		this.isShowSort = isShowSort;
	}

	public boolean getSelectOnList() {
		return isSelectOnList;
	}

	public void setSelectOnList(boolean selectOnList) {
		this.isSelectOnList = selectOnList;
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	public int getRowCount() {
		if (cacheResult != null) {
			return cacheResult.size();
		} else {
			return 0;
		}
	}

	@Override
	public String getValueAt(int row, int column) {
		if (cacheResult != null && cacheResult.size() > row) {
			return cacheResult.get(row).getValue(column).toString();
		} else {
			return null;
		}
	}

	@Override
	public void removeAllRow() {
		if (getRowCount() > 0) {
			super.removeAllRow();
			setMessageQueue(null);
			//getTableView().updateRows(0, false);
			if (cacheResult != null) {
				cacheResult.clear();
			}
			((BufferedTableView)getView()).updateRows(0, false);
			((BufferedTableView)getView()).scrollToTop();
			//getTableView().refresh(true);
			getStore().getLoader().load();
//			getTableView().refreshRow();
		}
	}
}