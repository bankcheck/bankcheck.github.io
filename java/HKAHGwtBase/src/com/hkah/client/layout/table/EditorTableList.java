package com.hkah.client.layout.table;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import com.extjs.gxt.ui.client.Style.HorizontalAlignment;
import com.extjs.gxt.ui.client.Style.SelectionMode;
import com.extjs.gxt.ui.client.binding.FormBinding;
import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.BaseEvent;
import com.extjs.gxt.ui.client.event.EditorEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.GridEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.SelectionChangedEvent;
import com.extjs.gxt.ui.client.event.SelectionChangedListener;
import com.extjs.gxt.ui.client.store.ListStore;
import com.extjs.gxt.ui.client.store.Record;
import com.extjs.gxt.ui.client.util.Scroll;
import com.extjs.gxt.ui.client.widget.form.CheckBox;
import com.extjs.gxt.ui.client.widget.form.ComboBox;
import com.extjs.gxt.ui.client.widget.form.DateField;
import com.extjs.gxt.ui.client.widget.form.Field;
import com.extjs.gxt.ui.client.widget.form.FormPanel;
import com.extjs.gxt.ui.client.widget.form.NumberField;
import com.extjs.gxt.ui.client.widget.form.TextField;
import com.extjs.gxt.ui.client.widget.grid.BufferView;
import com.extjs.gxt.ui.client.widget.grid.CellEditor;
import com.extjs.gxt.ui.client.widget.grid.CheckColumnConfig;
import com.extjs.gxt.ui.client.widget.grid.ColumnConfig;
import com.extjs.gxt.ui.client.widget.grid.ColumnData;
import com.extjs.gxt.ui.client.widget.grid.ColumnModel;
import com.extjs.gxt.ui.client.widget.grid.EditorGrid;
import com.extjs.gxt.ui.client.widget.grid.Grid;
import com.extjs.gxt.ui.client.widget.grid.GridCellRenderer;
import com.extjs.gxt.ui.client.widget.grid.GridSelectionModel;
import com.google.gwt.dom.client.Element;
import com.google.gwt.i18n.client.NumberFormat;
import com.google.gwt.user.client.ui.RootPanel;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.PagingComboBoxBase;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextDateTime;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TableUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;
import com.hkah.shared.model.UserInfo;

@SuppressWarnings("rawtypes")
public class EditorTableList extends EditorGrid<TableData> implements ConstantsVariable {
	public static final String DEFAULT_STRUCT_DESC_TABLE = "TEMPLATE_OBJ";
	public static final int DEFAULT_STRUCT_DESC_COLUMN = 30;

	private static final String checkBoxYesDisplay = "<div class='x-grid3-check-col x-grid3-check-col-on x-grid3-cc-checkBox'>&#160;</div>";
	private static final String checkBoxNoDisplay = "<div class='x-grid3-check-col x-grid3-check-col x-grid3-cc-checkBox'>&#160;</div>";
	private static final String checkBoxYesFlag = "x-grid3-check-col x-grid3-check-col-on";
	private static final String checkBoxNoFlag = "x-grid3-check-col x-grid3-check-col";

	private String[] columnIDs = null;
	private List<Integer> checkindex = new ArrayList<Integer>();
	private List<Integer> comboindex = new ArrayList<Integer>();
	private Map<Integer, ComboBoxBase> innerComboBox = new HashMap<Integer, ComboBoxBase>();

	private boolean addNumberingColumn = false;	// insert number column in ascending order in the table
	private GeneralGridCellRenderer preActionCellRenderer = null;	// insert a control column at the begining of table
	private GeneralGridCellRenderer postActionCellRenderer = null;	// append a control column at the end of table
	private boolean hasEmptyRow = false;
	private boolean isForceFit = true;
	/**
	 * This method initializes
	 *
	 */
	public EditorTableList(String[] columnNames, int[] columnWidths,int columnIndex,final ComboBoxBase combo) {
//		super(new ListStore<TableData>(),new ColumnModel(new ArrayList<ColumnConfig>()));
//		cm = getColumnModel(columnNames,columnWidths);

		super(new ListStore<TableData>(), new ColumnModel(new ArrayList<ColumnConfig>()));

		ColumnModel cm = getColumnModel(columnNames,columnWidths,false,null,null,columnIndex,combo);

		this.reconfigure(new ListStore<TableData>(), cm);
		initColumn(columnNames, columnWidths, 800);
		initialize();
	}

	public EditorTableList(String[] columnNames, int[] columnWidths,Field<? extends Object>[] editors,boolean forceFit) {
//		super(new ListStore<TableData>(),new ColumnModel(new ArrayList<ColumnConfig>()));
//		cm = getColumnModel(columnNames,columnWidths);

		super(new ListStore<TableData>(), new ColumnModel(new ArrayList<ColumnConfig>()));

		ColumnModel cm = getColumnModel(columnNames,columnWidths, editors,false,null,null);
		this.isForceFit = forceFit;
		this.reconfigure(new ListStore<TableData>(), cm);
		initColumn(columnNames, columnWidths, 800);
		initialize();

		resetNonTextColumnFields(editors, true);
	}

	public EditorTableList(String[] columnNames, int[] columnWidths,Field<? extends Object>[] editors) {
//		super(new ListStore<TableData>(),new ColumnModel(new ArrayList<ColumnConfig>()));
//		cm = getColumnModel(columnNames,columnWidths);

		super(new ListStore<TableData>(), new ColumnModel(new ArrayList<ColumnConfig>()));

		ColumnModel cm = getColumnModel(columnNames,columnWidths, editors,false,null,null);

		this.reconfigure(new ListStore<TableData>(), cm);
		initColumn(columnNames, columnWidths, 800);
		initialize();

		resetNonTextColumnFields(editors, true);
	}

	// added by Ricky
	public EditorTableList(String[] columnNames, int[] columnWidths, Field[] editFields,
			boolean addNumberingColumn, GeneralGridCellRenderer preActionCellRenderer,
			GeneralGridCellRenderer postActionCellRenderer) {
		super(new ListStore<TableData>(), new ColumnModel(new ArrayList<ColumnConfig>()));

		ColumnModel cm = getColumnModel(columnNames,columnWidths, editFields,
										addNumberingColumn, preActionCellRenderer,
										postActionCellRenderer);

		this.reconfigure(new ListStore<TableData>(), cm);
		this.addNumberingColumn = addNumberingColumn;
		setPreActionCellRenderer(preActionCellRenderer);
		setPostActionCellRenderer(postActionCellRenderer);
		initColumn(columnNames, columnWidths, RootPanel.get().getOffsetWidth());
		initialize();

		resetNonTextColumnFields(editFields);
	}

	public EditorTableList(String[] columnNames, int[] columnWidths, Field[] editFields,
			boolean addNumberingColumn, GeneralGridCellRenderer preActionCellRenderer,
			GeneralGridCellRenderer postActionCellRenderer ,boolean forceFit) {
		super(new ListStore<TableData>(), new ColumnModel(new ArrayList<ColumnConfig>()));

		ColumnModel cm = getColumnModel(columnNames,columnWidths, editFields,
										addNumberingColumn, preActionCellRenderer,
										postActionCellRenderer);

		this.isForceFit = forceFit;
		this.reconfigure(new ListStore<TableData>(), cm);
		this.addNumberingColumn = addNumberingColumn;
		setPreActionCellRenderer(preActionCellRenderer);
		setPostActionCellRenderer(postActionCellRenderer);
		initColumn(columnNames, columnWidths, RootPanel.get().getOffsetWidth());
		initialize();

		resetNonTextColumnFields(editFields);
	}

	public EditorTableList(String[] columnNames, int[] columnWidths, Field[] editFields,
			boolean addNumberingColumn, GeneralGridCellRenderer preActionCellRenderer,
			GeneralGridCellRenderer postActionCellRenderer, boolean afterEditEvent,
			boolean hasEmptyRow,boolean showColumnHeader) {
		super(new ListStore<TableData>(), new ColumnModel(new ArrayList<ColumnConfig>()));

		ColumnModel cm = getColumnModel(columnNames,columnWidths, editFields,
										addNumberingColumn, preActionCellRenderer,
										postActionCellRenderer,showColumnHeader);

		this.reconfigure(new ListStore<TableData>(), cm);
		this.addNumberingColumn = addNumberingColumn;
		setPreActionCellRenderer(preActionCellRenderer);
		setPostActionCellRenderer(postActionCellRenderer);
		setHasEmptyRow(hasEmptyRow);
		initColumn(columnNames, columnWidths, RootPanel.get().getOffsetWidth());
		initialize();

		resetNonTextColumnFields(editFields);

		if (afterEditEvent) {
			addAfterEditListenter();
		}
	}

	public EditorTableList(String[] columnNames, int[] columnWidths, Field[] editFields,
			boolean addNumberingColumn, GeneralGridCellRenderer preActionCellRenderer,
			GeneralGridCellRenderer postActionCellRenderer, boolean afterEditEvent,
			boolean hasEmptyRow) {
		super(new ListStore<TableData>(), new ColumnModel(new ArrayList<ColumnConfig>()));

		ColumnModel cm = getColumnModel(columnNames,columnWidths, editFields,
										addNumberingColumn, preActionCellRenderer,
										postActionCellRenderer);

		this.reconfigure(new ListStore<TableData>(), cm);
		this.addNumberingColumn = addNumberingColumn;
		setPreActionCellRenderer(preActionCellRenderer);
		setPostActionCellRenderer(postActionCellRenderer);
		setHasEmptyRow(hasEmptyRow);
		initColumn(columnNames, columnWidths, RootPanel.get().getOffsetWidth());
		initialize();

		resetNonTextColumnFields(editFields);

		if (afterEditEvent) {
			addAfterEditListenter();
		}
	}

	/**
	 * This method initializes column
	 *
	 * @return void
	 */
	private void initColumn(String[] columnNames, int[] columnWidths,
					int maxWidth) {
		List<ColumnConfig> configs = new ArrayList<ColumnConfig>();
		ColumnConfig column = null;
		String columnID = null;
		Vector<String> columnIDsVector = new Vector<String>();
		int width=0;
		// pre action
		if (getPreActionCellRenderer() != null) {
			column = new ColumnConfig();
			columnID = "pre_action_column";
			column.setId(columnID);
			int columnWidth = getPreActionCellRenderer().getColumnWidth();
			column.setWidth(columnWidth);
			width += columnWidth;
			column.setRenderer(getPreActionCellRenderer());
			column.setMenuDisabled(true);
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
			column.setMenuDisabled(true);
			configs.add(column);
			columnIDsVector.add(columnID);
		}
		if (columnNames != null) {
			for (int i = 0; i < columnWidths.length; i++) {
				width=width+columnWidths[i];
				columnID = getName2ID(columnNames[i], i);
				column = new ColumnConfig();
				if (columnID != null) {
					column.setId(columnID);
				}
				column.setHeaderHtml(columnNames[i]);
				column.setRowHeader(false);
				if (columnWidths[i] > 0) {
					column.setWidth(columnWidths[i]);
				} else {
					column.setHidden(true);
				}
				column.setMenuDisabled(true);
				configs.add(column);
				columnIDsVector.add(columnID);
			}
		}
		// post action
		if (getPostActionCellRenderer() != null) {
			column = new ColumnConfig();
			columnID = "post_action_column";
			column.setId(columnID);
			int columnWidth = getPostActionCellRenderer().getColumnWidth();
			column.setWidth(columnWidth);
			width += columnWidth;
			column.setRenderer(postActionCellRenderer);
			column.setMenuDisabled(true);
			configs.add(column);
			columnIDsVector.add(columnID);
		}


		if (width > maxWidth) {
			setWidth(maxWidth);
		} else {
			setWidth(width);
		}
		setHeight(200);
		//cm = new ColumnModel(configs);
		store = getStore();
		view = new BufferView();
		setSelectionModel(new GridSelectionModel<TableData>());
		columnIDs = (String[]) columnIDsVector.toArray(new String[columnIDsVector.size() ]);
	}

	/**
	 * This method initializes this
	 *
	 * @return void
	 */
	private void initialize() {
		setTrackMouseOver(false);
		setLoadMask(true);
		setBorders(true);
		setStripeRows(true);
		setColumnLines(true);
		if (isHasEmptyRow()) {
			addEmptyRow(1);
		}
		getView().setForceFit(isForceFit);
		getSelectionModel().setSelectionMode(SelectionMode.SINGLE);
		getSelectionModel().addSelectionChangedListener(new SelectionChangedListener<TableData>() {
			public void selectionChanged(SelectionChangedEvent se) {
				onSelectionChanged();
			}
		});
		this.addListener(Events.RowClick, new Listener<GridEvent>() {
			public void handleEvent(GridEvent be) {
				onClick();
			}
		});
		this.addListener(Events.ViewReady, new Listener<GridEvent>() {
			public void handleEvent(GridEvent be) {
				be.getGrid().getView().refresh(true);
			}
		});
		this.addListener(Events.Resize, new Listener<GridEvent>() {
			@Override
			public void handleEvent(GridEvent be) {
				// TODO Auto-generated method stub
				/*
				EditorTableList table = (EditorTableList) be.getGrid();
				int colCount = be.getGrid().getColumnModel().getColumnCount();
				int width[] = new int [colCount];
				int totalWidth = 0;
				for (int i = 0; i < colCount; i++) {
					width[i] = be.getGrid().getColumnModel().getColumnWidth(i);
					totalWidth += width[i];
				}
				for (int i = 0; i < colCount; i++) {
					if ((table.getPreActionCellRenderer() != null && i == 0) ||
						(table.isAddNumberingColumn() && (i == 0 || i == 1)) ||
						(table.getPostActionCellRenderer() != null &&
								i == colCount-1)) {
						continue;
					}
					int newWidth = (int)
							Math.round((width[i]*1.0/totalWidth) *be.getWidth());
					be.getGrid().getColumnModel()
						.setColumnWidth(i, newWidth);
				}
				be.getGrid().getView().refresh(true);
				*/
			}
		});

		getView().setSortingEnabled(false);
	}

	/***************************************************************************
	 * Column Method
	 **************************************************************************/

	public void setColumnColor(int col, final String color) {
		ColumnConfig column = getColumnModel().getColumn(col);
		column.setRenderer(new GeneralGridCellRenderer() {
			@Override
			public Object render(TableData model, String property,
					ColumnData config,
					int rowIndex, int colIndex, ListStore<TableData> store,
					Grid<TableData> grid) {
				String columnValue = (String) model.get(property);
				return "<span style='color:" + color + "'>" +columnValue + "</span>";
			}
		});
	}

	public void setColumnContextColor(int colStart,int colEnd, final String colColor,
			final String contextColor) {
		for (int col = colStart; col <= colEnd; col++) {
			ColumnConfig column = getColumnModel().getColumn(col);
			column.setRenderer(new GeneralGridCellRenderer() {
				@Override
				public Object render(TableData model, String property,
						ColumnData config,
						int rowIndex, int colIndex, ListStore<TableData> store,
						Grid<TableData> grid) {
					String columnValue = (String) model.get(property);
					return "<span style='color:" + colColor + "'>" +
							"<font color=\""+contextColor+"\">" +columnValue + "</font></span>";
				}
			});
		}
	}

	public void setColumnColor(int colStart,int colEnd, final String color) {
		for (int col = colStart; col <= colEnd; col++) {
			ColumnConfig column = getColumnModel().getColumn(col);
			column.setRenderer(new GeneralGridCellRenderer() {
				@Override
				public Object render(TableData model, String property,
						ColumnData config,
						int rowIndex, int colIndex, ListStore<TableData> store,
						Grid<TableData> grid) {
					String columnValue = (String) model.get(property);
					return "<span style='color:" + color + "'>" +columnValue + "</span>";
				}
			});
		}
	}

	public void setColumnColorByID(String colID, final String color) {
		ColumnConfig column = getColumnModel().getColumnById(colID);
		column.setRenderer(new GeneralGridCellRenderer() {
			@Override
			public Object render(TableData model, String property,
					ColumnData config,
					int rowIndex, int colIndex, ListStore<TableData> store,
					Grid<TableData> grid) {
				String columnValue = (String) model.get(property) == null ? "" : (String) model.get(property);
				return "<span style='color:" + color + "'><b>" + columnValue + "</b></span>";
			}
		});
	}

	public void setColumnAmount(int col) {
		setColumnAmount(col, false);
	}

	public void setColumnAmount(int col, final boolean isDecimalFormat) {
		ColumnConfig column = getColumnModel().getColumn(col);
		column.setAlignment(HorizontalAlignment.RIGHT);
		column.setRenderer(new GeneralGridCellRenderer() {
			@Override
			public Object render(TableData model, String property,
					ColumnData config,
					int rowIndex, int colIndex, ListStore<TableData> store,
					Grid<TableData> grid) {
				if (isDecimalFormat) {
					double value = 0;
					try {
						value = Double.parseDouble(model.get(property).toString());

						if (value < 0) {
							return "<span style='color:red'>" + NumberFormat.getDecimalFormat().format(value) + "</span>";
						} else {
							return "<span style='color:green'>" + NumberFormat.getDecimalFormat().format(value) + "</span>";
						}
					} catch (Exception e) {
						return super.render(model, property, config, rowIndex, colIndex, store, grid);
					}
				}
				else {
					String columnValue = (String) model.get(property);
					if (model.get(property) != null) {
						if (((String) model.get(property)).startsWith(MINUS_VALUE)) {
							return "<span style='color:red'>" + columnValue + "</span>";
						} else {
							return "<span style='color:green'>" + columnValue + "</span>";
						}
					} else {
						return columnValue;
					}
				}
			}
		});
	}

	public void resetNonTextColumnFields(Field[] editFields) {
		resetNonTextColumnFields(editFields, false);
	}

	public void resetNonTextColumnFields(Field[] editFields, boolean setIndexOnly) {
		if (editFields != null) {
			for (int i = 0; i < editFields.length; i++) {
				if (editFields[i] instanceof CheckBoxBase ||
					editFields[i] instanceof ComboBoxBase) {
					setColumnClass(i, editFields[i], true, setIndexOnly);
				}
			}
		}
	}

	public void setColumnClassIndex(int col, final Object objectClass) {
		if (objectClass instanceof CheckBoxBase) {
			checkindex.add(col);
		} else if (objectClass instanceof ComboBoxBase) {
			comboindex.add(col);
			innerComboBox.put(col, (ComboBoxBase) objectClass);
		}
	}

	public void setColumnClass(int col, final Object objectClass, boolean isColumnEditable) {
		setColumnClass(col, objectClass, isColumnEditable, false);
	}

	public void setColumnClass(int col, final Object objectClass, boolean isColumnEditable, boolean setIndexOnly) {
		if (objectClass instanceof CheckBoxBase) {
			checkindex.add(col);
		} else if (objectClass instanceof ComboBoxBase) {
			comboindex.add(col);
			innerComboBox.put(col, (ComboBoxBase) objectClass);
		}

		if (!setIndexOnly) {
			ColumnConfig column = getColumnModel().getColumn(col);
			if (objectClass instanceof ComboBoxBase && isColumnEditable) {
				column.setEditor( new CellEditor((ComboBoxBase) objectClass) {
					@Override
					public Object preProcessValue(Object value) {
						if (value == null) {
							return value;
						}
						return ((ComboBoxBase) objectClass).findModel(value.toString());
					}

					@Override
					public Object postProcessValue(Object value) {
						if (value == null) {
							return value;
						}
						return ((ComboBoxBase) objectClass).getText();
					}
				});
			}
			column.setRenderer(new GridCellRenderer<TableData>() {
				@Override
				public Object render(TableData model, String property,
						ColumnData config,
						int rowIndex, int colIndex, ListStore<TableData> store,
						Grid<TableData> grid) {

					if (model.get(property) != null) {
						if (objectClass instanceof CheckBoxBase) {
							if (YES_VALUE.equals(model.get(property))) {
								return checkBoxYesDisplay;
							} else {
								return checkBoxNoDisplay;
							}
						} else if (objectClass instanceof ComboBoxBase) {
							return ((ComboBoxBase) objectClass).getDisplayText(model.get(property).toString());
						} else {
							return objectClass;
						}
					} else {
						return objectClass;
					}
				}
			});
		}
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	@Override
	public void setBounds(int x, int y, int width, int height) {
		setPosition(x, y);
		setSize(width, height);
	}

	/***************************************************************************
	 * Action Method
	 **************************************************************************/

	@Override
	protected void onDoubleClick(GridEvent<TableData> e) {
		super.onDoubleClick(e);
		doubleClick();
	}

	public void onSelectionChanged() {};
	public void doubleClick() {};
	public void onClick() {};

	/***************************************************************************
	 * Set Table Data Method
	 **************************************************************************/

	public void setListTableContent(List<TableData> list) {
		removeAllRow();
		if (list != null && list.size() > 0) {
			getStore().add(list);
		}

		// set focus the first line
		if (getRowCount() > 0) {
			getView().focusRow(0);
			getSelectionModel().select(0, false);
		}

		if (isHasEmptyRow()) {
			addEmptyRow(1);
		}
	}

	private void setListTableContentHelper(MessageQueue mQueue) {
		if (mQueue != null && mQueue.success()) {
			String[] record = TextUtil.split(mQueue.getContentAsQueue(), TextUtil.LINE_DELIMITER);
			String[] fields = null;
			Object[] content = null;
			int numOfCol = 0;
			int colCount = 0;
			List<TableData> list = new ArrayList<TableData>();

			// default columns
			int numOfDefaultCol = 0;

			if (getPreActionCellRenderer() != null) {
				numOfDefaultCol++;
			}
			if (addNumberingColumn) {
				numOfDefaultCol++;
			}
			if (getPostActionCellRenderer() != null) {
				numOfDefaultCol++;
			}

			for (int i = 0; i < record.length; i++) {
				fields = TextUtil.split(record[i]);

				if (i == 0) {
					numOfCol = fields.length + numOfDefaultCol;
				}
				content = new Object[numOfCol];
				colCount = 0;
				if (getPreActionCellRenderer() != null) {
					content[colCount++] = null;
				}
				if (addNumberingColumn) {
					content[colCount++] = String.valueOf(i+1);
				}
				if (!TextUtil.FIELD_DELIMITER.equals(record[i])) {
//					addRow(fields);
					for (int n=0; n<fields.length; n++) {
						if (fields[n].equals(null)) {
							content[colCount++] = EMPTY_VALUE;
						} else {
							ColumnConfig config = getColumnModel().getColumns().get(n);
							if (config instanceof CheckColumnConfig) {
								if (YES_VALUE.equals(fields[n])) {
									content[colCount++] = true;
								} else {
									content[colCount++] = Boolean.parseBoolean(fields[n]);
								}
							} else if (config.getDateTimeFormat() != null) {
								TextDate date = new TextDate();
								if (fields[n] != null &&
										fields[n].length() > 0) {
									date.setText(fields[n]);
									content[colCount++] = date.getValue();
								} else {
//									config.setEditor(editor)
//									date.clear();
//									row[n] = date.getValue();
									content[colCount++] = date.getValue();
								}
							} else {
								content[colCount++] = fields[n];
							}
						}
					}
				}
				if (getPostActionCellRenderer() != null) {
					content[colCount++] = null;
				}

				if (columnIDs.length == content.length) {
					TableData td = new TableData(columnIDs, content);
					list.add(td);
				} else {
					System.err.print(mQueue.getTxCode() +":");
					System.err.println("The number of Column ID [" + columnIDs.length + "] and Content [" + content.length + "] are not match");
				}
			}
			if (list != null && list.size() > 0) {
				getStore().add(list);
			}
		}
	}

	public void setListTableContent(MessageQueue mQueue) {
		setListTableContent(mQueue, true);
	}

	public void setListTableContent(MessageQueue mQueue, boolean clearTable) {
		int cursorInt = getSelectedRow();

		// clear table
		if (clearTable) {
			removeAllRow();
		}

		setListTableContentHelper(mQueue);

		if (clearTable && getRowCount() > 0) {
			if (cursorInt <= 0) {
				// set focus to the first line
				cursorInt = 0;
			} else if (cursorInt > getRowCount()) {
				// set focus to the end of line if cursor index > record count
				cursorInt = getRowCount() - 1;
			}
			getView().focusRow(cursorInt);
			getSelectionModel().select(cursorInt, false);
		}

		if (isHasEmptyRow()) {
			addEmptyRow(1);
		}
	}

	public void setSelectedItemContent(TableData newTd) {
		TableData oldTd = getSelectionModel().getSelectedItem();
		int storeIndex = getStore().getModels().indexOf(oldTd);

		getStore().getModels().set(storeIndex, newTd);

		getView().refresh(true);
		repaint();
	}

	public void setListTableContent(String txCode, String[] param) {
		QueryUtil.executeMasterBrowse(getUserInfo(),
				txCode, param,
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				setListTableContent(mQueue);
				setListTableContentPost();
			}
		});
	}

	public void setListTableContent(String txCode, String[] param, String moduleCode) {
		QueryUtil.executeMasterBrowse(getUserInfo(),
				moduleCode, txCode, param,
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				setListTableContent(mQueue);
				setListTableContentPost();
			}
		});
	}

	public void setListTableContent(String txCode, String[] param, String moduleCode,
			String jndiName) {
		QueryUtil.executeMasterBrowse(getUserInfo(),
				moduleCode, jndiName, txCode, param,
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				setListTableContent(mQueue);
				setListTableContentPost();
			}
		});
	}

	public void appendListTableContent(MessageQueue mQueue) {
		setListTableContent(mQueue, false);
		setListTableContentPost();
	}

	public void appendListTableContent(String txCode, String[] inParm) {
		QueryUtil.executeMasterBrowse(getUserInfo(),
				txCode, inParm,
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				appendListTableContent(mQueue);
			}
		});
	}

	public void setListTableContentPost() {
		// override for the child class
	}

	public void addRow(Object[] rowData) {
		getStore().add(new TableData(columnIDs, rowData));
	}

	public void addRow(Object[][] rowData) {
		if (rowData != null) {
			for (int i = 0; i < rowData.length; i++) {
				addRow(rowData[i]);
			}
		}
	}

	public void removeRow(int rowIndex) {
		getStore().remove(rowIndex);
	}

	public void removeAllRow() {
		getStore().removeAll();
	}

	public void removeSelectedRow() {
		getStore().remove(getSelectionModel().getSelectedItem());
	}

	/***************************************************************************
	 * Get/Set Method
	 **************************************************************************/

	/**
	 * @return the hasEmptyRow
	 */
	public boolean isHasEmptyRow() {
		return hasEmptyRow;
	}

	/**
	 * @param hasEmptyRow the hasEmptyRow to set
	 */
	public void setHasEmptyRow(boolean hasEmptyRow) {
		this.hasEmptyRow = hasEmptyRow;
	}

	public boolean isAddNumberingColumn() {
		return addNumberingColumn;
	}

	public void setAddNumberingColumn(boolean addNumberingColumn) {
		this.addNumberingColumn = addNumberingColumn;
	}

	public GeneralGridCellRenderer getPreActionCellRenderer() {
		return preActionCellRenderer;
	}

	public void setPreActionCellRenderer(GeneralGridCellRenderer preActionCellRenderer) {
		this.preActionCellRenderer = preActionCellRenderer;
	}

	public GeneralGridCellRenderer getPostActionCellRenderer() {
		return postActionCellRenderer;
	}

	public void setPostActionCellRenderer(GeneralGridCellRenderer postActionCellRenderer) {
		this.postActionCellRenderer = postActionCellRenderer;
	}

	public int getSelectedRowCount() {
		return getSelectionModel().getSelectedItems().size();
	}

	public int getRowCount() {
		return getStore().getCount();
	}

	public String[] getSelectedRowContent() {
		TableData td = getSelectionModel().getSelectedItem();
		return getRowContent(td);
	}

	public String[] getRowContent(int rowIndex) {
		TableData td = (TableData) getStore().getAt(rowIndex);
		return getRowContent(td);
	}

	private String[] getRowContent(TableData td) {
		String[] row = new String[getColumnCount()];
//		for (int i = 0; i < getColumnModel().getColumnCount(); i++) {
		for (int i = 0; i < td.getSize(); i++) {
//			if (checkindex.contains(i)) {
//				if (td.getValue(i).equals("Y")) {
//					row[i]="-1";
//				} else {
//					row[i]="0";
//				}
//			} else {
				row[i] = td.getValue(i).toString();
//			}
		}
		return row;
	}

	public List<TableData> getSelectedItems() {
		return getSelectionModel().getSelectedItems();
	}

	/**
	 * Returns the index of the first selected row, -1 if no row is selected.
	 * @return the index of the first selected row
	 */
	public int getSelectedRow() {
		return getStore().indexOf(getSelectionModel().getSelectedItem());
	}

	public void setColumnRenderer(int colIndex, GeneralGridCellRenderer renderer) {
		cm.getColumn(colIndex).setRenderer(renderer);
	}

	/**
	 * Remark: must set table AutoHeight true to get all row value from view
	 * @param row
	 * @param column
	 * @return
	 */
	public String getValueAt(int row, int column) {
		Element element = getView().getCell(row, column);
		String elementInnerHTML = null;
		if (element != null) {
			elementInnerHTML = element.getInnerHTML();
			if (elementInnerHTML != null) {
				if (elementInnerHTML.indexOf(checkBoxYesFlag) >= 0) {
					return YES_VALUE;
				} else if (elementInnerHTML.indexOf(checkBoxNoFlag) >= 0) {
					return NO_VALUE;
				} else if (comboindex.contains(column)) {
					return innerComboBox.get(column).getTextByDisplayText(element.getInnerText());
				} else {
					return element.getInnerText();
				}
			} else {
				return element.getInnerText();
			}
		} else {
			return null;
		}
		//getStore().getAt(index)
	}

	/**
	 * Sets the value for the cell in the table model at <code>row</code>
	 * and <code>column</code>.
	 */
	public void setValueAt(String aValue, int row, int column) {
		try {
			Scroll scroll = getView().getScroller().getScroll();
			if (checkindex.contains(column)) {
				((TableData) getStore().getAt(row)).setValue(column, aValue.equals(YES_VALUE) ? true : false);
				if (aValue.equals(YES_VALUE)) {
					getView().getCell(row, column).setInnerHTML(checkBoxYesDisplay);
				} else {
					getView().getCell(row, column).setInnerHTML(checkBoxNoDisplay);
				}
			} else if (comboindex.contains(column)) {
				((TableData) getStore().getAt(row)).setValue(column, aValue);
				getView().getCell(row, column).setInnerText(innerComboBox.get(column).getDisplayText(aValue));
			} else {
				((TableData) getStore().getAt(row)).setValue(column, aValue);
//				getStore().getAt(row).setValue(column, aValue);
			}
			getView().refresh(true);
			getView().getScroller().setScrollLeft(scroll.getScrollLeft());
			getView().getScroller().setScrollTop(scroll.getScrollTop());
			//getStore().commitChanges();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public String[][] getTableValues() {
		return getTableValues(null);
	}

	public String[][] getTableValues(String structDesc) {
		List<TableData> tableData = getStore().getModels();
		int rowCount = tableData.size();
		int colCount = getColumnCount();
		int colStart = 0;
		int colEnd = colCount;

		if (getPreActionCellRenderer() != null) {
			colStart = 1;
			colEnd = colCount - 1;
			colCount--;
		}
		if (getPostActionCellRenderer() != null) {
			colEnd = colCount - 1;
			colCount--;
		}

		String[][] sourceTableV = null;
		if (structDesc != null && DEFAULT_STRUCT_DESC_TABLE.equals(structDesc)) {
			sourceTableV = new String[rowCount][DEFAULT_STRUCT_DESC_COLUMN];
		} else {
			sourceTableV = new String[rowCount][colCount];
		}

		for (int k = 0; k < rowCount; k++) {
			for (int l = colStart, i = 0; l < colEnd || i < colCount; l++, i++) {
				sourceTableV[k][i] = getValueAt(k, l);
			}
		}

		return sourceTableV;
	}

	public String[][] getTableValues2(String structDesc, List<Record> tableData) {
		int rowCount = getRowCount();
		int colCount = getColumnCount();
		int colStart = 0;
		int colEnd = colCount;

		if (getPreActionCellRenderer() != null) {
			colStart = 1;
			colEnd = colCount - 1;
			colCount--;
		}
		if (getPostActionCellRenderer() != null) {
			colEnd = colCount - 1;
			colCount--;
		}

		String[][] sourceTableV = null;
		if (structDesc != null && DEFAULT_STRUCT_DESC_TABLE.equals(structDesc)) {
			sourceTableV = new String[rowCount][DEFAULT_STRUCT_DESC_COLUMN];
		} else {
			sourceTableV = new String[rowCount][colCount];
		}

		for (int k = 0; k < rowCount; k++) {
			for (int l = colStart, i = 0; l < colEnd || i < colCount; l++, i++) {
				this.setSelectRow(k);
				sourceTableV[k][i] = getValueAt(k, l);
			}
		}

		return sourceTableV;
	}

	public boolean removeBlankRow(boolean isRemoveBlankRow) {
		boolean hasBlankRow = false;
		String[][] tabvalue = getTableValues();
		List<Integer> rowsToDel = new ArrayList<Integer>();
		boolean isBlankRow = true;
		if (tabvalue != null) {
			for (int i = 0; i < tabvalue.length; i++) {
				if (tabvalue[i] != null) {
					isBlankRow = true;
					for (int j = 0; j < tabvalue[i].length; j++) {
						if (tabvalue[i][j] != null && !tabvalue[i][j].trim().isEmpty()) {
							isBlankRow = false;
						}
					}
					if (isBlankRow) {
						hasBlankRow = true;
						if (isRemoveBlankRow) {
							rowsToDel.add(i);
						}
					}
				}
			}
		}
		if (isRemoveBlankRow) {
			for (int i = rowsToDel.size() - 1; i >= 0; i--) {
				removeRow(i);
			}
		}
		return hasBlankRow;
	}

	private String getName2ID(String columnName, int i) {
		StringBuilder columnID = new StringBuilder();
		if (columnName != null && columnName.trim().length() > 0) {
			columnID = new StringBuilder(TableUtil.getName2ID(columnName));
		} else {
			columnID = new StringBuilder(String.valueOf(i));
		}
		return columnID.toString();
	}

	public int getName2ColIdx(String columnName) {
		String columnID = TableUtil.getName2ID(columnName);
		int ret = -1;
		for (int i = 0; i < columnIDs.length; i++) {
			if (columnID.equals(columnIDs[i])) {
				ret = i;
			}
		}
		return ret;
	}

	 public void setSelectionMode(SelectionMode selectionMode) {
		 getSelectionModel().setSelectionMode(selectionMode);
	}

	public void setSelectRow(int rowIndex) {
		getView().focusRow(rowIndex);
		getSelectionModel().select(rowIndex, false);
	}

	public void setRowSelectionInterval(int rowIndex1,int rowIndex2) {
		setSelectRow(rowIndex1);
	}

	public void setTableLength(int length) {
		setWidth(length);
	}

	public void setTableHeight(int height) {
		setHeight(height);
	}

	public int getColumnCount() {
		return columnIDs.length;
	}

	public String[] getColumnIDs() {
		return columnIDs;
	}

	public Vector getDataVector() {
		return null;
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void selectAll() {
		getSelectionModel().selectAll();
	}

	public void setBinding(FormPanel panel) {
		if (panel != null) {
			final FormBinding formBindings = new FormBinding(panel, true);
			getSelectionModel().addListener(
					Events.SelectionChange,
					new Listener<SelectionChangedEvent<TableData>>() {
				@Override
				public void handleEvent(SelectionChangedEvent<TableData> tableData) {
					if (tableData.getSelection().size() > 0) {
						formBindings.bind((TableData) tableData.getSelection().get(0));
					} else {
						formBindings.unbind();
					}
				}
			});
		}
	}

	public ColumnModel getColumnModel(String[] columnNames, int[] columnWidths,
			boolean addNumberingColumn, GeneralGridCellRenderer preActionCellRenderer, GeneralGridCellRenderer postActionCellRenderer,
			int columnIndex,final ComboBox combo) {

		Field[] fields = null;
		if (columnWidths != null) {
			int colSize = columnWidths.length;
			fields = new Field[colSize];
			if (columnIndex >= 0 && columnIndex < colSize) {
				fields[columnIndex] = combo;
			}
		}
		return getColumnModel(columnNames, columnWidths, fields,
				addNumberingColumn, preActionCellRenderer, postActionCellRenderer,true);
	}

	/**
	 * For multiple combobox or other non-text field columns
	 *
	 * @param columnNames
	 * @param columnWidths
	 * @param editFields
	 * @param addNumberingColumn
	 * @param preActionCellRenderer
	 * @param postActionCellRenderer
	 * @return
	 */
	public ColumnModel getColumnModel(String[] columnNames, int[] columnWidths,Field[] editFields,
			boolean addNumberingColumn, GeneralGridCellRenderer preActionCellRenderer, GeneralGridCellRenderer postActionCellRenderer) {

		return getColumnModel(columnNames, columnWidths, editFields,
				addNumberingColumn, preActionCellRenderer, postActionCellRenderer,true);
	}

	public ColumnModel getColumnModel(String[] columnNames, int[] columnWidths, Field[] editFields,
			boolean addNumberingColumn, GeneralGridCellRenderer preActionCellRenderer, GeneralGridCellRenderer postActionCellRenderer,
			boolean showColumnHeader) {
		List<ColumnConfig> configs = new ArrayList<ColumnConfig>();
		ColumnConfig column = null;
		String columnID = null;
		Vector<String> columnIDsVector = new Vector<String>();
//		int width = 0;
		// pre action
		if (preActionCellRenderer != null) {
			column = new ColumnConfig();
			columnID = "pre_action_column";
			column.setId(columnID);
			int columnWidth = preActionCellRenderer.getColumnWidth();
			column.setWidth(columnWidth);
//			width += columnWidth;
			column.setRenderer(preActionCellRenderer);
			column.setMenuDisabled(true);
			configs.add(column);
			columnIDsVector.add(columnID);
		}
		// numbering (do not get config from columnNames and column Widths
		if (addNumberingColumn) {
			column = new ColumnConfig();
			columnID = "numbering_column";
			column.setId(columnID);
			column.setWidth(10);
//			width += 10;
			column.setMenuDisabled(true);
			configs.add(column);
			columnIDsVector.add(columnID);
		}
		if (columnNames != null) {
			for (int i = 0; i < columnWidths.length; i++) {
//				width += columnWidths[i];
				columnID = TableUtil.getName2ID(columnNames[i]);
				if (editFields != null && editFields[i] instanceof CheckBox) {
					column = new CheckColumnConfig();
				} else {
					column = new ColumnConfig();
				}
				if (columnID != null) {
					column.setId(columnID);
				}
				if (showColumnHeader) {
					column.setHeaderHtml(columnNames[i]);
				}
				column.setRowHeader(true);
				if (columnWidths[i] > 0) {
					column.setWidth(columnWidths[i]);
				} else {
					column.setHidden(true);
				}
				//configs.add(column);
				columnIDsVector.add(columnID);

				CellEditor editor = null;
				if (editFields != null && editFields[i] != null) {
					final Field curObj = editFields[i];
					final int colIndex = i;
					if (curObj instanceof ComboBox) {
						editor = new CellEditor(editFields[i]) {
							@Override
							public Object preProcessValue(Object value) {
								if (value == null) {
									return value;
								}
								System.out.println("DEBUG: EditorTableList .preProcessValue value.toString() = " + value.toString());
								/*
								if (innerComboBox.get(col) instanceof PagingComboBoxBase) {
									if (value == null) {
										return null;
									}
									PagingComboBoxBase pc = ((PagingComboBoxBase) curObj);

									String valueAttr = pc.getValueField();

									if (valueAttr == null) {
										valueAttr = "value";
									}

									int totalPage = pc.getPagingToolBar().getTotalPages();

									if (pc.getStore().findModel(valueAttr, value) != null) {
										return pc.getStore().findModel(valueAttr, value);
									} else {
*//*
										while (pc.getPagingToolBar().getActivePage() != pc.getCurrentPage().intValue()) {
											if (pc.getCurrentPage() > pc.getPagingToolBar().getActivePage()) {
												pc.getPagingToolBar().previous();
											} else if (pc.getCurrentPage() < pc.getPagingToolBar().getActivePage()) {
												pc.getPagingToolBar().next();
											}
											pc.setCurrentPage(Integer.valueOf(pc.getPagingToolBar().getActivePage()));
										}

										return pc.getStore().findModel(valueAttr, value);

										for (int i = 0; i < totalPage; i++) {
											if (pc.getStore().findModel(valueAttr, value) != null) {
												return pc.getStore().findModel(valueAttr, value);
											}
											pc.getPagingToolBar().next();
										}
										return null;
*//*
//										return pc.getStore().findModel(valueAttr, value);
//									}
								} else {
								*/
									if (curObj instanceof PagingComboBoxBase) {
										ModelData modelData = ((PagingComboBoxBase) curObj).findModelByKey(value.toString());
										if (modelData == null) {
											modelData = ((PagingComboBoxBase) curObj).findModelByDisplayText(value.toString());
										}
										return modelData;
									} else if (curObj instanceof ComboBoxBase) {
										ModelData modelData = ((ComboBoxBase) curObj).findModelByKey(value.toString());
										if (modelData == null) {
											modelData = ((ComboBoxBase) curObj).findModelByDisplayText(value.toString());
										}
										return modelData;
									} else {
										return value;
									}
//								}
							}

							@Override
							public Object postProcessValue(Object value) {
								if (value == null) {
									return null;
								}

								//System.out.println("DEBUG: EditorTableList .postProcessValue valueAttr=" + valueAttr + ", ((ModelData) value).get(valueAttr) = " + ((ModelData) value).get(valueAttr));
								if (curObj instanceof PagingComboBoxBase) {
									return ((PagingComboBoxBase) curObj).getText();
								} else {
									return ((ComboBoxBase) curObj).getDisplayText();
								}
							}
						};
						editor.addListener(Events.StartEdit, new Listener<EditorEvent>() {
							public void handleEvent(EditorEvent be) {
								((ComboBox) curObj).setSelectOnFocus(true);
							}
						});
					} else if (curObj instanceof NumberField) {
						editor = new CellEditor(curObj) {
							@Override
							public Object preProcessValue(Object value) {
								try {
									return Integer.parseInt(value.toString());
								} catch (Exception e) {
									try {
										return Double.parseDouble(value.toString());
									} catch (Exception e1) {
										return null;
									}
								}
							}

							@Override
							public Object postProcessValue(Object value) {
								return getField().getValue();
							}

							@Override
							protected void onBlur(FieldEvent fe) {
								super.onBlur(fe);
								curObj.fireEvent(Events.OnBlur);
							}
						};
						editor.addListener(Events.StartEdit, new Listener<EditorEvent>() {
							public void handleEvent(EditorEvent be) {
								((NumberField) curObj).setSelectOnFocus(true);
							}
						});
					} else if (curObj instanceof DateField) {
						editor = new CellEditor(curObj) {
							@Override
							public Object preProcessValue(Object value) {
								if (value == null) {
									return null;
								} else if (value.toString().length() == 0) {
									return null;
								} else {
									return value;
								}
							}

							@Override
							public Object postProcessValue(Object value) {
								return getField().getValue();
							}
						};
						editor.addListener(Events.StartEdit, new Listener<EditorEvent>() {
							public void handleEvent(EditorEvent be) {
								((DateField) curObj).setSelectOnFocus(true);
							}
						});
					} else if (curObj instanceof CheckBox) {
						editor = new CellEditor(curObj);
					} else if (curObj instanceof TextField) {
						editor = new CellEditor(curObj);
						editor.addListener(Events.StartEdit, new Listener<EditorEvent>() {
							public void handleEvent(EditorEvent be) {
								((TextField) curObj).setSelectOnFocus(true);
							}
						});
					} else {
						// TextField as default editor
						final Field curObj2 = (Field) (new TextField<String>());
						editor = new CellEditor(curObj2);
						editor.addListener(Events.StartEdit, new Listener<EditorEvent>() {
							public void handleEvent(EditorEvent be) {
								((TextField) curObj2).setSelectOnFocus(true);
							}
						});
					}

					//editor keydown event
					editor.getField().addListener(Events.KeyDown, new Listener<FieldEvent>() {
						@Override
						public void handleEvent(FieldEvent be) {
							columnKeyDownHandler(be, colIndex);
						}
					});

					editor.getField().addListener(Events.Blur, new Listener<FieldEvent>() {
						@Override
						public void handleEvent(FieldEvent be) {
							columnBlurHandler(be, colIndex);
						}
					});

					editor.addListener(Events.StartEdit, new Listener<EditorEvent>() {
						public void handleEvent(EditorEvent be) {
							columnStartEditHandler(be, colIndex);
						}
					});

					editor.addListener(Events.CancelEdit, new Listener<EditorEvent>() {
						public void handleEvent(EditorEvent be) {
							columnCancelEditHandler(be, colIndex);
						}
					});

					column.setEditor(editor);

					if (editor != null && editor.getField() instanceof DateField) {
						if (editor.getField() instanceof TextDate) {
							column.setDateTimeFormat(((TextDate)editor.getField()).getDateTimeFormat());
						}

						if (editor.getField() instanceof TextDateTime) {
							column.setDateTimeFormat(((TextDateTime)editor.getField()).getDateTimeFormat());
						}
					}
				}

				column.setMenuDisabled(true);
				configs.add(column);
			}
		}
		// post action
		if (postActionCellRenderer != null) {
			column = new ColumnConfig();
			columnID = "post_action_column";
			int columnWidth = postActionCellRenderer.getColumnWidth();
			column.setWidth(columnWidth);
//			width += columnWidth;
			column.setRenderer(postActionCellRenderer);
			column.setMenuDisabled(true);
			configs.add(column);
			columnIDsVector.add(columnID);
		}

		return new ColumnModel(configs);
	}

	protected void columnKeyDownHandler(FieldEvent be, int editingCol) {

	}

	protected void columnBlurHandler(FieldEvent be, int editingCol) {

	}

	protected void columnStartEditHandler(EditorEvent be, int editingCol) {

	}

	protected void columnCancelEditHandler(EditorEvent be, int editingCol) {

	}

//	private void setCombo(int col, ComboBoxBase combo) {
//		comboindex.add(col);
//		innerComboBox.put(col, combo);
//	}

	public void addEmptyRow(int numOfRow) {
		// TODO Auto-generated method stub
		Object[][] rows = new Object[numOfRow][];
		for (int i = 0; i < numOfRow; i++) {
			rows[i] = new Object[]{};
		}
		addRow(rows);
	}

	public void afterEdit(int row) {
		if (getStore().getModifiedRecords().size() > 0 &&
				row == this.getRowCount() - 1) {
			addEmptyRow(1);
		}
	}

	public void editCellAt(int row, int col) {
		// TODO Auto-generated method stub
	}

	/***************************************************************************
	 * Save Table Method
	 **************************************************************************/

	public void saveTable(String txCode,
			String[] param,
			final String objectName) {
		saveTable(txCode,
				param, DEFAULT_STRUCT_DESC_TABLE,
				false, false,
				true,
				true,
				true,
				objectName);
	}

	public void saveTable(String txCode,
			String[] param,
			final boolean commit, boolean saveIfModified,
			final boolean showSuccessMsg,
			final boolean showFailMsg,
			final boolean showDbMsg,
			final String objectName) {
		saveTable(txCode,
				param, DEFAULT_STRUCT_DESC_TABLE,
				commit, saveIfModified,
				showSuccessMsg,
				showFailMsg,
				showDbMsg,
				objectName);
	}

	public void saveTable(String txCode,
			String[] param, String structDesc,
			final boolean commit, boolean saveIfModified,
			final boolean showSuccessMsg,
			final boolean showFailMsg,
			final String objectName) {
		saveTable(txCode,
				param, structDesc,
				commit, saveIfModified,
				showSuccessMsg,
				showFailMsg,
				false,
				objectName);
	}

	public void saveTable(
			String txCode,
			String[] param, String structDesc,
			final boolean commit, boolean saveIfModified,
			final boolean showSuccessMsg,
			final boolean showFailMsg,
			final boolean showDbMsg,
			final String objectName) {
		List<Record> modRecords = getStore().getModifiedRecords();

		if (modRecords.size() > 0 || !saveIfModified) {
			QueryUtil.executeMasterAction(getUserInfo(),
				txCode, QueryUtil.ACTION_MODIFY,
				param,
				structDesc, getTableValues2(structDesc, modRecords),
				new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						String retCode = mQueue.getReturnCode();
						String rtnDBMsg = mQueue.getReturnMsg();
						int retCodeInt = -1;
						try {
							retCodeInt = Integer.parseInt(retCode);
						} catch (Exception ex) {}

						if (mQueue.success()) {
							String outMsg = "";
							if (retCodeInt >= 0) {
								outMsg = objectName+" save successful.";
							} else {
								outMsg = "("+objectName+") Error code: "
									+ retCodeInt;
							}

							if (showDbMsg) {
								complete(true, rtnDBMsg, retCodeInt);
							} else {
								complete(true, outMsg, retCodeInt);
							}
						} else {
							complete(false,
								(showDbMsg?rtnDBMsg:"("+objectName+") Fail to connect service."),
								retCodeInt);
						}
					}

					@Override
					public void onFailure(Throwable caught) {
						// TODO Auto-generated method stub
						super.onFailure(caught);
						if (showFailMsg) {
							complete(false, caught.getMessage(), -1);
						}
					}

					public void complete(boolean success, String msg, int rtnCode) {
						if (success) {
							if (commit) {
								commitTable();
							}

							if (showSuccessMsg) {
								Factory.getInstance().addInformationMessage(msg);
							}
						} else {
							if (showFailMsg) {
								Factory.getInstance().addErrorMessage(
									"Cannot save "+objectName+".\n"
									+ "(" + msg + ")");
							}
						}
						postSaveTable(success, rtnCode, msg);
					}
			});
		}
	}

	public void postSaveTable(boolean success, Integer rtnCode, String rtnMsg) {
		// override for the child class
	}

	public void commitTable() {
		List<Record> modRecords = getStore().getModifiedRecords();

		for (int j = 0; j < modRecords.size(); j++) {
			Record record = modRecords.get(j);
			record.commit(true);
		}

		getStore().commitChanges();
		postCommitTable();
	}

	public void postCommitTable() {};

	/***************************************************************************
	 * Listener Method
	 **************************************************************************/

	private void addAfterEditListenter() {
		addListener(Events.AfterEdit, new Listener<GridEvent>() {
			@Override
			public void handleEvent(GridEvent be) {
				afterEdit(be.getRowIndex());
			}
		});
	}

	public void removeAfterEditListener() {
		this.removeListener(Events.AfterEdit, (Listener<? extends BaseEvent>) this.getListeners(Events.AfterEdit));
	}

	/***************************************************************************
	 * Other Method
	 **************************************************************************/

	protected UserInfo getUserInfo() {
		return Factory.getInstance().getUserInfo();
	}
}