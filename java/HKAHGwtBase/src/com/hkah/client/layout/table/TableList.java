package com.hkah.client.layout.table;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import com.extjs.gxt.ui.client.Style.HorizontalAlignment;
import com.extjs.gxt.ui.client.Style.SelectionMode;
import com.extjs.gxt.ui.client.binding.FormBinding;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.GridEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.SelectionChangedEvent;
import com.extjs.gxt.ui.client.event.SelectionChangedListener;
import com.extjs.gxt.ui.client.store.GroupingStore;
import com.extjs.gxt.ui.client.store.ListStore;
import com.extjs.gxt.ui.client.store.Record;
import com.extjs.gxt.ui.client.widget.form.FormPanel;
import com.extjs.gxt.ui.client.widget.grid.BufferView;
import com.extjs.gxt.ui.client.widget.grid.ColumnConfig;
import com.extjs.gxt.ui.client.widget.grid.ColumnData;
import com.extjs.gxt.ui.client.widget.grid.ColumnModel;
import com.extjs.gxt.ui.client.widget.grid.Grid;
import com.extjs.gxt.ui.client.widget.grid.GridGroupRenderer;
import com.extjs.gxt.ui.client.widget.grid.GridSelectionModel;
import com.extjs.gxt.ui.client.widget.grid.GroupColumnData;
import com.extjs.gxt.ui.client.widget.grid.GroupingView;
import com.google.gwt.i18n.client.DateTimeFormat;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.tips.CustomQTip;
import com.hkah.client.util.QueryUtil;
import com.hkah.client.util.TableUtil;
import com.hkah.client.util.TextUtil;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;
import com.hkah.shared.model.UserInfo;

public class TableList extends Grid<TableData> implements ConstantsVariable {

	protected String[] columnIDs = null;
	private List<Integer> checkindex = new ArrayList<Integer>();
	private List<Integer> comboindex = new ArrayList<Integer>();
	private Map<Integer, ComboBoxBase> innerComboBox = new HashMap<Integer, ComboBoxBase>();
	private int editRow = -1;
	private boolean groupingStore = false;
	private String groupBy = null;
	private boolean addNumberingColumn = false;	// insert number column in ascending order in the table
	private GeneralGridCellRenderer preActionCellRenderer = null;	// insert a control column at the begining of table
	private GeneralGridCellRenderer postActionCellRenderer = null;	// append a control column at the end of table
	private GeneralGridCellRenderer[] actionCellRenderer = null;
	private List<ColumnConfig> configs = null;
	private boolean isNotShowMenu = true;
	protected String lastSelectedItemKey = null;
	protected int columnKey = -1;

	public static final String DEFAULT_STRUCT_DESC_TABLE = "TEMPLATE_OBJ";
	public static final int DEFAULT_STRUCT_DESC_COLUMN = 30;

	// Ricky add
	/**
	 * This method initializes
	 *
	 */
	public TableList(String[] columnNames, int[] columnWidths) {
		/*
		super();
		initColumn(columnNames, columnWidths);
		initialize();
		*/
		this(columnNames, columnWidths, false, null, null, false, null, false);
	}

	public TableList(String[] columnNames, int[] columnWidths, boolean isNotShowMenu) {

		this(columnNames, columnWidths, false, null, null, false, null, false,isNotShowMenu,null);
	}

	public TableList(String[] columnNames, int[] columnWidths,
			GeneralGridCellRenderer[] actionCellRenderer) {
		this(columnNames, columnWidths, false, null, null, false, null, false,
				actionCellRenderer);
	}

	// added by Ricky
	public TableList(String[] columnNames, int[] columnWidths,
			boolean addNumberingColumn, GeneralGridCellRenderer preActionCellRenderer, GeneralGridCellRenderer postActionCellRenderer) {
		this(columnNames, columnWidths, addNumberingColumn, preActionCellRenderer, postActionCellRenderer, false, null, false);
	}

	// added by Ricky
	public TableList(String[] columnNames, int[] columnWidths,
			boolean addNumberingColumn, GeneralGridCellRenderer preActionCellRenderer, GeneralGridCellRenderer postActionCellRenderer,
			boolean groupingStore, String groupBy, boolean addRowOnInit) {
		this(columnNames, columnWidths,
			addNumberingColumn, preActionCellRenderer, postActionCellRenderer,
			groupingStore, groupBy, addRowOnInit, null);
	}

	public TableList(String[] columnNames, int[] columnWidths,
			boolean addNumberingColumn, GeneralGridCellRenderer preActionCellRenderer, GeneralGridCellRenderer postActionCellRenderer,
			boolean groupingStore, String groupBy, boolean addRowOnInit, GeneralGridCellRenderer[] actionCellRenderer) {
		this(columnNames, columnWidths,
			addNumberingColumn, preActionCellRenderer, postActionCellRenderer,
			groupingStore, groupBy, addRowOnInit,false,actionCellRenderer);
	}

	public TableList(String[] columnNames, int[] columnWidths,
			boolean addNumberingColumn, GeneralGridCellRenderer preActionCellRenderer, GeneralGridCellRenderer postActionCellRenderer,
			boolean groupingStore, String groupBy, boolean addRowOnInit,boolean isNotShowMenu, GeneralGridCellRenderer[] actionCellRenderer) {
		super();
		this.addNumberingColumn = addNumberingColumn;
		setPreActionCellRenderer(preActionCellRenderer);
		setPostActionCellRenderer(postActionCellRenderer);
		setActionCellRenderer(actionCellRenderer);
		setGroupingStore(groupingStore);
		setGroupBy(groupBy);
		setNotShowMenu(isNotShowMenu);
		initColumn(columnNames, columnWidths);
		initialize();
		if (addRowOnInit) {
			addRow(new Object[]{});
		}
	}

	/**
	 * This method initializes column
	 *
	 * @return void
	 */
	protected void initColumn(String[] columnNames, int[] columnWidths) {
		configs = new ArrayList<ColumnConfig>();
		ColumnConfig column = null;
		String columnID = null;
		Vector<String> columnIDsVector = new Vector<String>();
		int width = 0;

		// pre action column
		if (getPreActionCellRenderer() != null) {
			column = new ColumnConfig();
			columnID = "pre_action_column";
			column.setId(columnID);
			int thisWidth = getPreActionCellRenderer().getColumnWidth();
			column.setWidth(thisWidth);
			width += thisWidth;
			column.setRenderer(getPreActionCellRenderer());
			column.setMenuDisabled(isNotShowMenu());
			configs.add(column);
			columnIDsVector.add(columnID);
		}

		// numbering column
		if (isAddNumberingColumn()) {
			column = new ColumnConfig();
			columnID = "numbering_column";
			column.setId(columnID);
			int thisWidth = 30;
			column.setWidth(thisWidth);
			width += thisWidth;
			column.setMenuDisabled(isNotShowMenu());
			configs.add(column);
			columnIDsVector.add(columnID);
		}

		if (columnNames != null) {
			for (int i = 0; i < columnWidths.length; i++) {
				width += columnWidths[i];
				columnID = getName2ID(columnNames[i], i);
				column = new ColumnConfig();
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
				column.setMenuDisabled(isNotShowMenu());
				configs.add(column);
				columnIDsVector.add(columnID);
				if (actionCellRenderer != null && actionCellRenderer[i] != null) {
					column.setRenderer(actionCellRenderer[i]);
				} else {
					column.setRenderer(new GeneralGridCellRenderer());
				}
			}
		}

		// post action column
		if (getPostActionCellRenderer() != null) {
			column = new ColumnConfig();
			columnID = "post_action_column";
			column.setId(columnID);
			int thisWidth = getPostActionCellRenderer().getColumnWidth();
			column.setWidth(thisWidth);
			width += thisWidth;
			column.setRenderer(getPostActionCellRenderer());
			column.setMenuDisabled(isNotShowMenu());
			configs.add(column);
			columnIDsVector.add(columnID);
		}

		if (width > 800) {
			setWidth(800);
		} else {
			setWidth(width);
		}
		setHeight(200);

		columnIDs = (String[]) columnIDsVector.toArray(new String[columnIDsVector.size()]);
		cm = new ColumnModel(configs);

		initColumnHelper();
	}

	protected void initColumnHelper() {
		if (isGroupingStore()) {
			store = new GroupingStore<TableData>();
			((GroupingStore)store).groupBy(getGroupBy());
			view = new GroupingView();

			((GroupingView) view).setGroupRenderer(new GridGroupRenderer() {
				public String render(GroupColumnData data) {
					String f = cm.getColumnById(data.field).getHeaderHtml();
					String l = data.models.size() == 1 ? "Item" : "Items";
					return f + ": " + data.group + " (" + data.models.size() + " " + l + ")";
				}
			});
		} else {
			store = new ListStore<TableData>();
			view = new BufferView() {
				@Override
				public void refresh(boolean headerToo) {
					preventScrollToTopOnRefresh = true;
					super.refresh(headerToo);
				}
			};
		}
//		view.setForceFit(true);
//		setView(view);

		setSelectionModel(new GridSelectionModel<TableData>());
//		for (int i = columnWidths.length-1; i > -1; i--) {
//			if (columnWidths[i] > 0) {
//				this.setAutoExpandColumn(columnIDs[i]);
//				i = -1;
//			}
//		}
	}

	/**
	 * This method initializes this
	 *
	 * @return void
	 */
	private void initialize() {
		addStyleName("table-list");
		setQuickTip();
		setTrackMouseOver(false);
		setLoadMask(true);
		setBorders(true);
		setStripeRows(true);
		setColumnLines(true);
		getSelectionModel().setSelectionMode(SelectionMode.SINGLE);
		getSelectionModel().addSelectionChangedListener(new SelectionChangedListener<TableData>() {
			public void selectionChanged(SelectionChangedEvent se) {
				onSelectionChanged();
			}
		});
		addListener(Events.RowClick, new Listener<GridEvent>() {
			public void handleEvent(GridEvent be) {
				onClick();
			}
		});

		getView().setSortingEnabled(false);
	}

	public void setQuickTip(){
		new CustomQTip(this, true);
	}

	private int getColumnStartWith() {
		// default columns
		int numOfDefaultCol = 0;

		if (getPreActionCellRenderer() != null) {
			numOfDefaultCol++;
		}
		if (isAddNumberingColumn()) {
			numOfDefaultCol++;
		}
		if (getPostActionCellRenderer() != null) {
			numOfDefaultCol++;
		}

		return numOfDefaultCol;
	}

	/***************************************************************************
	 * Column Method
	 **************************************************************************/

	public void setColumnStyle(int col, final String style) {
		ColumnConfig column = getColumnModel().getColumn(getColumnStartWith() + col);
		column.setRenderer(new GeneralGridCellRenderer() {
			@Override
			public Object render(TableData model, String property,
					ColumnData config,
					int rowIndex, int colIndex, ListStore<TableData> store,
					Grid<TableData> grid) {
				return "<" + style + ">" + model.get(property).toString() + "</" + style + ">";
			}
		});
	}

	public void setColumnColor(int col, final String color) {
		ColumnConfig column = getColumnModel().getColumn(getColumnStartWith() + col);
		column.setRenderer(new GeneralGridCellRenderer() {
			@Override
			protected String renderHelper(String textValue, String textStyle) {
				return super.renderHelper(textValue, "style='color:" + color + "'");
			}
		});
	}

	public void setColumnValueColor(int col, final String color, final String value) {
		ColumnConfig column = getColumnModel().getColumn(getColumnStartWith() + col);
		column.setRenderer(new GeneralGridCellRenderer() {
			@Override
			public Object render(TableData model, String property,
					ColumnData config,
					int rowIndex, int colIndex, ListStore<TableData> store,
					Grid<TableData> grid) {
					if (value.equals(model.get(property).toString())) {
						return "<span style='color:"+color+"'>" + model.get(property).toString() + "</span>";
					} else {
						model.get(property).toString();
					}
					return super.render(model, property, config, rowIndex, colIndex, store, grid);

			}
		});
	}

	public void setColumnNumber(int col) {
		ColumnConfig column = getColumnModel().getColumn(getColumnStartWith() + col);
		column.setAlignment(HorizontalAlignment.RIGHT);
		column.setRenderer(new GeneralGridCellRenderer() {
			@Override
			protected String renderHelper(String textValue, String textStyle) {
				if (textValue.startsWith(ConstantsVariable.MINUS_VALUE)) {
					return super.renderHelper(textValue, STYLE_RED);
				} else {
					return super.renderHelper(textValue, STYLE_GREEN);
				}
			}
		});
	}

	public void setColumnAmount(int col) {
		ColumnConfig column = getColumnModel().getColumn(getColumnStartWith() + col);
		column.setAlignment(HorizontalAlignment.RIGHT);
		column.setRenderer(new GeneralGridCellRenderer() {
			@Override
			public Object render(TableData model, String property,
					ColumnData config,
					int rowIndex, int colIndex, ListStore<TableData> store,
					Grid<TableData> grid) {
				double value = 0;
				try {
					value = Double.parseDouble(model.get(property).toString());
					return TextUtil.formatColorCurrency(value);
				} catch (Exception e) {
					return super.render(model, property, config, rowIndex, colIndex, store, grid);
				}
			}
		});
	}

	public void setColumnClass(int col, final Object objectClass,  boolean isColumnEditable) {
		ColumnConfig column = getColumnModel().getColumn(getColumnStartWith() + col);
		if (objectClass instanceof CheckBoxBase) {
			checkindex.add(col);
		} else if (objectClass instanceof ComboBoxBase) {
			comboindex.add(col);
			innerComboBox.put(col,(ComboBoxBase)objectClass);
		} else if (objectClass instanceof Date) {
			column.setDateTimeFormat(DateTimeFormat.getFormat("MM/dd/yyyy"));
		}
		column.setRenderer(new GeneralGridCellRenderer() {
			@Override
			public Object render(TableData model, String property,
					ColumnData config,
					int rowIndex, int colIndex, ListStore<TableData> store,
					Grid<TableData> grid) {
				if (objectClass instanceof CheckBoxBase) {
					if (model.get(property).equals(ConstantsVariable.YES_VALUE) || model.get(property).equals(ConstantsVariable.MINUS_ONE_VALUE)) {
						return "<div class='x-grid3-check-col x-grid3-check-col-on x-grid3-cc-checkBox'>&#160;</div>";
					} else {
						return "<div class='x-grid3-check-col x-grid3-check-col x-grid3-cc-checkBox'>&#160;</div>";
					}
				} else if (objectClass instanceof ComboBoxBase) {
					return ((ComboBoxBase)objectClass).getDisplayText( model.get(property).toString());
				} else {
					return objectClass;
				}
			}
		});
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

	protected List<TableData> MessageQueue2List(MessageQueue mQueue) {
		if (mQueue != null && mQueue.success()) {
			String[] record = TextUtil.split(mQueue.getContentAsQueue(), TextUtil.LINE_DELIMITER);
			String[] fields = null;
			String[] content = null;
			int numOfCol = 0;
			int colCount = 0;
			List<TableData> list = new ArrayList<TableData>();

			// default columns
			int numOfDefaultCol = getColumnStartWith();

			for (int i = 0; i < record.length; i++) {
				fields = TextUtil.split(record[i]);

				if (i == 0) {
					numOfCol = fields.length + numOfDefaultCol;
				}
				content = new String[numOfCol];
				colCount = 0;
				if (getPreActionCellRenderer() != null) {
					content[colCount++] = null;
				}
				if (isAddNumberingColumn()) {
					content[colCount++] = String.valueOf(i + 1);
				}
				if (!TextUtil.FIELD_DELIMITER.equals(record[i])) {
//					addRow(fields);
					for (int n=0; n<fields.length; n++) {
						content[colCount++] = fields[n];
					}
				}
				if (getPostActionCellRenderer() != null) {
					content[colCount++] = null;
				}

				if (columnIDs.length == content.length) {
					list.add(new TableData(columnIDs, TextUtil.stringArray2ObjectArray(content)));
				} else {
					System.err.print(mQueue.getTxCode()+":");
					System.err.println("The number of Column ID [" + columnIDs.length + "] and Content [" + content.length + "] are not match");
				}
			}
			return list;
		} else {
			return null;
		}
	}

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
	}

	public void setListTableContent(MessageQueue mQueue) {
		setListTableContent(mQueue, true);
	}

	protected void setListTableContent(MessageQueue mQueue, boolean clearTable) {
		setListTableContentPrev();
		int cursorInt = getSelectedRow();

		// clear table
		if (clearTable) {
			removeAllRow();
		}

		List<TableData> list = MessageQueue2List(mQueue);
		if (list != null && list.size() > 0) {
			getStore().add(list);
		}

		if (clearTable) {
			setFocusRow(cursorInt);
		}
		setListTableContentPost();
	}

	public void setListTableContent(String txCode, String[] param) {
		QueryUtil.executeMasterBrowse(
				getUserInfo(), txCode, param,
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				setListTableContent(mQueue);
			}
		});
	}

	public void setListTableContent(String txCode, String[] param, String moduleCode) {
		QueryUtil.executeMasterBrowse(
				getUserInfo(), moduleCode, txCode, param,
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
		QueryUtil.executeMasterBrowse(
				getUserInfo(), txCode, inParm,
				new MessageQueueCallBack() {
					public void onPostSuccess(MessageQueue mQueue) {
						appendListTableContent(mQueue);
					}
				});
	}

	public void setListTableContentPrev() {

	}

	public void setListTableContentPost() {
		// override for the child class
		focus();
	}

	public void addRow() {
		getStore().add(new TableData(columnIDs, new Object[columnIDs.length]));
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
		setFocusRow(rowIndex);
	}

	public void removeAllRow() {
		getStore().removeAll();
	}

	public int findRow(int column, String key) {
		for (int i = 0; i < getRowCount(); i++) {
			if (getRowContent(i)[column].equals(key)) {
				return i;
			}
		}
		return -1;
	}

	/***************************************************************************
	 * Get/Set Method
	 **************************************************************************/

	public boolean isGroupingStore() {
		return groupingStore;
	}

	public void setGroupingStore(boolean groupingStore) {
		this.groupingStore = groupingStore;
	}

	public String getGroupBy() {
		return groupBy;
	}

	public void setGroupBy(String groupBy) {
		this.groupBy = groupBy;
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

	public void setPreActionCellRenderer(
			GeneralGridCellRenderer preActionCellRenderer) {
		this.preActionCellRenderer = preActionCellRenderer;
	}

	public GeneralGridCellRenderer getPostActionCellRenderer() {
		return postActionCellRenderer;
	}

	public void setPostActionCellRenderer(
			GeneralGridCellRenderer postActionCellRenderer) {
		this.postActionCellRenderer = postActionCellRenderer;
	}

	public GeneralGridCellRenderer[] getActionCellRenderer() {
		return actionCellRenderer;
	}

	public void setActionCellRenderer(GeneralGridCellRenderer[] actionCellRenderer) {
		this.actionCellRenderer = actionCellRenderer;
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

	public String getSelectedCellContent(int column) {
		TableData td = getSelectionModel().getSelectedItem();
		return getRowContent(td)[getColumnStartWith() + column];
	}

	public String[] getRowContent(int rowIndex) {
		TableData td = (TableData)getStore().getAt(rowIndex);
		return getRowContent(td);
	}

	private String[] getRowContent(TableData td) {
		String[] row = null;
		if (td != null) {
			row = new String[td.getSize()];
			for (int i=0;i<getColumnModel().getColumnCount();i++) {
//				if (checkindex.contains(i)) {
//					if (td.getValue(i).equals(ConstantsVariable.YES_VALUE)) {
//						row[i]="-1";
//					} else {
//						row[i]="0";
//					}
//				} else {
					row[i] = td.getValue(i).toString();
//				}
			}
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

	public String getValueAt(int row, int column) {
//		return getView().getCell(row, column).getInnerText().toString();
		return getStore().getAt(row).getValue(column).toString();
	}

	/**
	 * Sets the value for the cell in the table model at <code>row</code>
	 * and <code>column</code>.
	 */
	public void setValueAt(String aValue, int row, int column) {
		if (getView().getCell(row, column) == null) return;

		try {
//			Scroll scroll = getView().getScroller().getScroll();
			if (checkindex.contains(column)) {
				((TableData) getStore().getAt(row)).setValue(column, aValue);
				if (aValue.equals(ConstantsVariable.YES_VALUE)) {
					getView().getCell(row, column).setInnerHTML("<div class='x-grid3-check-col x-grid3-check-col-on x-grid3-cc-checkBox'>&#160;</div>");
				} else {
					getView().getCell(row, column).setInnerHTML("<div class='x-grid3-check-col x-grid3-check-col x-grid3-cc-checkBox'>&#160;</div>");
				}
			} else if (comboindex.contains(column)) {
					((TableData) getStore().getAt(row)).setValue(column, aValue);
				getView().getCell(row, column).setInnerText(innerComboBox.get(column).getDisplayText(aValue));
			} else {
				((TableData) getStore().getAt(row)).setValue(column, aValue);
//				getStore().getAt(row).setValue(column, aValue);
			}
			getView().refresh(true);
//			getView().getScroller().setScrollLeft(scroll.getScrollLeft());
//			getView().getScroller().setScrollTop(scroll.getScrollTop());
//			getStore().commitChanges();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void resetValueAt(int row, int column) {
		setValueAt(EMPTY_VALUE, row, column);
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
//				this.setSelectRow(k);
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

	protected int getEditRow() {
		return editRow;
	}

	public void setEditRow() {
		editRow = getSelectedRow();
	}

	/***************************************************************************
	 * SaveTable Method
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
			String[] param,
			boolean saveIfModified,
			final boolean showSuccessMsg,
			final boolean showFailMsg,
			final String objectName) {
		saveTable(txCode,
				param, DEFAULT_STRUCT_DESC_TABLE,
				false, saveIfModified,
				showSuccessMsg,
				showFailMsg,
				false,
				objectName);
	}

	// saveTable copied from EditorTableList()
	public void saveTable(String txCode,
			String[] param, String structDesc,
			boolean saveIfModified,
			final boolean showSuccessMsg,
			final boolean showFailMsg,
			final String objectName) {
		saveTable(txCode,
				param, structDesc,
				false, saveIfModified,
				showSuccessMsg,
				showFailMsg,
				false,
				objectName);
	}

	public void saveTable(
			String txCode,
			String[] param, String structDesc,
			boolean saveIfModified,
			final boolean showSuccessMsg,
			final boolean showFailMsg,
			final boolean showDbMsg,
			final String objectName) {
		saveTable(txCode,
				param, structDesc,
				false, saveIfModified,
				showSuccessMsg,
				showFailMsg,
				showDbMsg,
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

	public void commitTable() {
		List<Record> modRecords = getStore().getModifiedRecords();

		for (int j = 0; j < modRecords.size(); j++) {
			Record record = modRecords.get(j);
			record.commit(true);
		}

		getStore().commitChanges();
		postCommitTable();
	}

	public void postSaveTable(boolean success, Integer rtnCode, String rtnMsg) {
		// override for the child class
	}

	public void postCommitTable() {};

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	private void setFocusRow(int selectedRow) {
		if (getRowCount() > 0) {
			if (selectedRow < 0) {
				// set focus to the first line
				selectedRow = 0;
			} else if (selectedRow > getRowCount() - 1) {
				// set focus to the end of line if cursor index > record count
				selectedRow = getRowCount() - 1;
			}
			getView().focusRow(selectedRow);
			getSelectionModel().select(selectedRow, false);
		}
	}

	public void selectAll() {
		getSelectionModel().selectAll();
	}

	public void setBinding(FormPanel panel) {
		if (panel != null) {
			final FormBinding formBindings = new FormBinding(panel, true);
			getSelectionModel().addListener(
					Events.SelectionChange,
					new Listener<SelectionChangedEvent<TableData>>() {
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

	public void editCellAt(int row, int col) {}

	public void reSelection(boolean scrollToRecord) {

	}

	public boolean isLastRow() {
		return getRowCount() == getSelectedRow() + 1;
	}

	public boolean isNotShowMenu() {
		return isNotShowMenu;
	}

	public void setNotShowMenu(boolean isNotShowMenu) {
		this.isNotShowMenu = isNotShowMenu;
	}

	public void setLastSelectedItemKey(String key) {
		this.lastSelectedItemKey = key;
	}

	public String getLastSelectedItemKey() {
		return this.lastSelectedItemKey;
	}

	/***************************************************************************
	 * Other Method
	 **************************************************************************/

	protected UserInfo getUserInfo() {
		return Factory.getInstance().getUserInfo();
	}
}