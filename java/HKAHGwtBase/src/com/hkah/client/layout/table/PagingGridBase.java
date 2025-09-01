package com.hkah.client.layout.table;

import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import com.extjs.gxt.ui.client.data.BaseModelData;
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
import com.extjs.gxt.ui.client.store.ListStore;
import com.extjs.gxt.ui.client.widget.LayoutContainer;
import com.extjs.gxt.ui.client.widget.form.CheckBox;
import com.extjs.gxt.ui.client.widget.form.ComboBox;
import com.extjs.gxt.ui.client.widget.form.DateField;
import com.extjs.gxt.ui.client.widget.form.Field;
import com.extjs.gxt.ui.client.widget.form.NumberField;
import com.extjs.gxt.ui.client.widget.form.SimpleComboBox;
import com.extjs.gxt.ui.client.widget.form.TextField;
import com.extjs.gxt.ui.client.widget.grid.CellEditor;
import com.extjs.gxt.ui.client.widget.grid.CheckColumnConfig;
import com.extjs.gxt.ui.client.widget.grid.ColumnConfig;
import com.extjs.gxt.ui.client.widget.grid.ColumnModel;
import com.extjs.gxt.ui.client.widget.grid.Grid;
import com.extjs.gxt.ui.client.widget.layout.FitLayout;
import com.extjs.gxt.ui.client.widget.toolbar.PagingToolBar;
import com.google.gwt.core.client.GWT;
import com.google.gwt.i18n.client.DateTimeFormat;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;
import com.hkah.shared.model.UserInfo;

public class PagingGridBase extends LayoutContainer {

	private boolean useCacheResult = false;
	private List<ModelData> cacheResult = null;
	protected String TxCode = null;
	protected String actionType = null;
	protected PagingLoader loader = null;
	private PagingToolBar toolBar = null;
	private Grid<ModelData> grid = null;
	private  String[] colIDArray = null;
	private  String[] colHeaderArray = null;
	private  int[] colWidthArray = null;
	private int RecordPerPage = 10;

	public String getTxCode() {
		return TxCode;
	}

	public void setTxCode(String txCode) {
		TxCode = txCode;
	}

	public String getActionType() {
		return actionType;
	}

	public void setActionType(String actionType) {
		this.actionType = actionType;
	}

	public Grid<ModelData> getGrid() {
		return grid;
	}

	public void setGrid(Grid<ModelData> grid) {
		this.grid = grid;
	}

	public int getRecordPerPage() {
		return RecordPerPage;
	}

	public void setRecordPerPage(int recordPerPage) {
		RecordPerPage = recordPerPage;
	}

	public void setLoader(PagingLoader loader) {
		this.loader = loader;
	}

	public PagingLoader getLoader() {
		return loader;
	}

	public void reLoad() {
		grid.getStore().removeAll();
		loader.setOffset(0);
		loader.load();
	}

	public PagingGridBase(String[] colIDArray,int[] colWidthArray,int GridHeight) {
		super();
		setColIDArray(colIDArray);
		setColWidthArray(colWidthArray);
		initialize();
		setGridHeight(GridHeight);
	}

	public PagingGridBase(String[] colIDArray,int[] colWidthArray,String[] colHeaderArray,int GridHeight) {
		super();
		setColIDArray(colIDArray);
		setColWidthArray(colWidthArray);
		setColHeaderArray(colHeaderArray);
		initialize();
		setGridHeight(GridHeight);

	}

	public PagingGridBase(int[] colWidthArray,String[] colHeaderArray,int GridHeight) {
		super();
		setColHeaderArray(colHeaderArray);
		String[] IDArray = new String[colHeaderArray.length];
		for (int i = 0; i < colHeaderArray.length; i++) {
			IDArray[i]=Integer.toString(i);
		}
		setColIDArray(IDArray);
		setColWidthArray(colWidthArray);
		initialize();
		setGridHeight(GridHeight);
	}

	public String[] getColIDArray() {
		return colIDArray;
	}

	public void setColIDArray(String[] colIDArray) {
		this.colIDArray = colIDArray;
	}

	public int[] getColWidthArray() {
		return colWidthArray;
	}

	public void setColWidthArray(int[] colWidthArray) {
		this.colWidthArray = colWidthArray;
	}

	public void setColHeaderArray(String[] colHeaderArray) {
		this.colHeaderArray = colHeaderArray;
	}

	public String[] getColHeaderArray() {
		return colHeaderArray;
	}

	public PagingGridBase getThis() {
		return this;
	}

	public void setGridHeight(int height) {
		grid.setHeight(height);
	}

	public void initialize() {
		initStore();
		loader.load(0,RecordPerPage);
		toolBar = new PagingToolBar(RecordPerPage);
		toolBar.getElement().getStyle().setProperty("borderBottom", "none");
		toolBar.bind(loader);
		ColumnModel cm = null;
		if (getColIDArray().length>0 && getColIDArray() != null) {
			cm = getColumnModel(getColIDArray(),colHeaderArray,
					colWidthArray);
		} else {
			cm = getColumnModel(colHeaderArray,
				colWidthArray);
		}
		ListStore<ModelData> patList = new ListStore<ModelData>(loader);
		grid = new Grid<ModelData>(patList, cm);
		grid.setBorders(true);

		add(grid);
		add(toolBar);
		setLayout(new FitLayout());
	}

	protected void initStore() {
		loader = initLoader();
		loader.addListener(Loader.BeforeLoad, new Listener<LoadEvent>() {
			public void handleEvent(LoadEvent be) {
				be.<ModelData> getConfig().set("start", be.<ModelData> getConfig().get("offset"));
				be.<ModelData> getConfig().set("txCode", TxCode);
				be.<ModelData> getConfig().set("actionType", actionType);
				be.<ModelData> getConfig().set("param", new String[]{});
				be.<ModelData> getConfig().set("colID", new String[]{});
			}
		});
	}

	protected PagingLoader<PagingLoadResult<ModelData>> initLoader() {
		PagingLoader<PagingLoadResult<ModelData>> loader = new BasePagingLoader<PagingLoadResult<ModelData>>(new DataProxy<PagingLoadResult<ModelData>>() {

			@Override
			public void load(DataReader<PagingLoadResult<ModelData>> reader,
					Object loadConfigAsObject, final AsyncCallback<PagingLoadResult<ModelData>> callback) {
				GWT.log(":: PagingLoader load");

				BasePagingLoadConfig loadConfig = (BasePagingLoadConfig) loadConfigAsObject;
				final int offset = loadConfig.getOffset();
				final int limit = loadConfig.getLimit();

				// Get the results for the requested page...
				UserInfo userInfo = (UserInfo) loadConfig.get("userInfo");
				String txCode = (String) loadConfig.get("txCode");
				String actionType = (String) loadConfig.get("actionType");
				String[] param = (String[]) loadConfig.get("param");
				final String[] colID = (String[]) loadConfig.get("colID");

				if (userInfo == null) {
					userInfo = new UserInfo();
				}

				GWT.log(" offset="+offset+",limit="+limit);

				final List<ModelData> resultData = new ArrayList<ModelData>();

				if (isUseCacheResult() && offset > 0) {
					// use cache
					GWT.log(" USE cache ");
					int totalLength = 0;
					if (cacheResult != null) {
						for (int i = offset; i < offset + limit; i++) {
							if (i < cacheResult.size())
								resultData.add(cacheResult.get(i));
						}
						totalLength = cacheResult.size();
					}
					GWT.log(" USE cache totalLength = " + cacheResult.size());

					BasePagingLoadResult<ModelData> pagingLoadResult = new BasePagingLoadResult<ModelData>(resultData, offset, totalLength);
					pagingLoadResult.setTotalLength(totalLength);
					pagingLoadResult.setOffset(offset);
					callback.onSuccess(pagingLoadResult);
				} else {
					GWT.log(" USE queryUtil");
					QueryUtil.executeMasterAction(
							userInfo, txCode,actionType, param,
							new MessageQueueCallBack() {
						public void onPostSuccess(MessageQueue mQueue) {
							int totalLength = 0;
							if (mQueue.success()) {
								String[] record = TextUtil.split(mQueue.getContentAsQueue(), TextUtil.LINE_DELIMITER);
								String[] fields = null;
								getGrid().unmask(); //for unmasking if there is mask for loading data
								if (record != null)
									totalLength = record.length;

								if (cacheResult == null)
									cacheResult = new ArrayList<ModelData>();
								cacheResult.clear();

								for (int i = 0; i < record.length; i++) {
									if (record != null) {
										fields = TextUtil.split(record[i]);
										if (!TextUtil.FIELD_DELIMITER.equals(record[i])) {
											ModelData m = new BaseModelData();

											for (int j = 0; j < fields.length; j++) {
												if (colID  != null && colID.length>0) {
													m.set(colID[j], fields[j]);
												} else {
													m.set(Integer.toString(j), fields[j]);
												}
											}

											if (i >= offset && i < offset + limit)
												resultData.add(m);
											cacheResult.add(m);
										}
									}
								}
							}
							unmask(); //for unmasking if there is mask for loading data

							BasePagingLoadResult<ModelData> pagingLoadResult = new BasePagingLoadResult<ModelData>(resultData, 10, totalLength);
							pagingLoadResult.setTotalLength(totalLength);
							pagingLoadResult.setOffset(offset);
							callback.onSuccess(pagingLoadResult);
						}
					});
				}
			}
		});

		return loader;
	}

	public boolean isUseCacheResult() {
		return useCacheResult;
	}

	public static ColumnModel getColumnModel(String[] columnNames, int[] columnWidths) {
		return getColumnModel(null,columnNames, columnWidths, null,
				false, null, null);
	}

	public static ColumnModel getColumnModel(String[] columnID,String[] columnNames, int[] columnWidths) {
		return getColumnModel(columnID,columnNames, columnWidths, null,
				false, null, null);
	}

	public static ColumnModel getColumnModel(String[] columnIDArray, String[] columnNames, int[] columnWidths, Field[] editFields,
			boolean addNumberingColumn, GeneralGridCellRenderer preActionCellRenderer, GeneralGridCellRenderer postActionCellRenderer) {
		List<ColumnConfig> configs = new ArrayList<ColumnConfig>();
		ColumnConfig column = null;
		String columnID = null;
		Vector<String> columnIDsVector = new Vector<String>();
		int width=0;
		// pre action
		if (preActionCellRenderer != null) {
			column = new ColumnConfig();
			columnID = "pre_action_column";
			column.setId(columnID);
			int columnWidth = preActionCellRenderer.getColumnWidth();
			column.setWidth(columnWidth);
			width += columnWidth;
			column.setRenderer(preActionCellRenderer);
			configs.add(column);
			columnIDsVector.add(columnID);
		}
		// numbering (do not get config from columnNames and column Widths
		if (addNumberingColumn) {
			column = new ColumnConfig();
			columnID = "numbering_column";
			column.setId(columnID);
			column.setWidth(10);
			width += 10;
			configs.add(column);
			columnIDsVector.add(columnID);
		}
		if (columnNames != null) {
			for (int i = 0; i < columnWidths.length; i++) {
				width=width+columnWidths[i];
				if (columnIDArray != null && columnIDArray.length>0) {
					columnID = columnIDArray[i];
				} else {
					columnID = Integer.toString(i);
				}
				if (editFields != null && editFields[i] instanceof CheckBox) {
					column = new CheckColumnConfig();
				}
				else {
					column = new ColumnConfig();
				}
				if (columnID != null) {
					column.setId(columnID);
				}
				column.setHeaderHtml(columnNames[i]);
				column.setRowHeader(true);
				if (columnWidths[i] > 0) {
					column.setWidth(columnWidths[i]);
				} else {
					column.setHidden(true);
				}
				configs.add(column);
				columnIDsVector.add(columnID);

				CellEditor editor = null;
				if (editFields != null && editFields[i] != null) {
					final Field curObj = editFields[i];
					if (curObj instanceof ComboBox) {
						 editor = new CellEditor(curObj) {
								@Override
								public Object preProcessValue(Object value) {
								  if (value == null) {
										return value;
									}
									return ((SimpleComboBox) curObj).findModel(value.toString());
								}

								@Override
								public Object postProcessValue(Object value) {
									if (value == null) {
										return null;
									}

									String valueAttr = null;
									if (getField() instanceof ComboBox)
										valueAttr = ((ComboBox) getField()).
										getValueField();

									if (valueAttr == null)
										valueAttr = "value";
									return ((ModelData) value).get(valueAttr);
								}
						  };
					}
					else if (curObj instanceof NumberField) {
						editor = new CellEditor(curObj);
					}
					else if (curObj instanceof DateField) {
						editor = new CellEditor(curObj);
					}
					else if (curObj instanceof CheckBox) {
						editor = new CellEditor(curObj);
					}
					else {
						// TextField as default editor
						editor = new CellEditor(new TextField<String>());
					}
				}

				column.setEditor(editor);
				if (editor != null && editor.getField() instanceof DateField) {
					column.setDateTimeFormat(DateTimeFormat.getFormat("dd/MM/yyyy"));
				}
			}
		}
		// post action
		if (postActionCellRenderer != null) {
			column = new ColumnConfig();
			columnID = "post_action_column";
			int columnWidth = postActionCellRenderer.getColumnWidth();
			column.setWidth(columnWidth);
			width += columnWidth;
			column.setRenderer(postActionCellRenderer);
			configs.add(column);
			columnIDsVector.add(columnID);
		}

		return  new ColumnModel(configs);
	}

	public static String getName2ID(String columnName) {
		StringBuilder columnID = new StringBuilder();
		if (columnName != null) {
			// skip special character
			columnName = TextUtil.replaceAll(columnName,
					ConstantsVariable.DOT_VALUE, ConstantsVariable.SPACE_VALUE);

			// remove space
			String[] word = TextUtil.split(columnName, ConstantsVariable.SPACE_VALUE);
			String temp = null;
			for (int i = 0; i < word.length; i++) {
				temp = word[i].trim();
				if (temp.length() > 0) {
					if (i == 0) {
						columnID.append(temp.substring(0, 1).toLowerCase());
					} else {
						columnID.append(temp.substring(0, 1).toUpperCase());
					}
					columnID.append(temp.substring(1).toLowerCase());
				}
			}
		}
		return columnID.toString();
	}
}