package com.hkah.client.layout.table;

public class GroupingTableList extends TableList {
	public GroupingTableList(String[] columnNames, int[] columnWidths, String groupBy) {
		this(columnNames, columnWidths, groupBy,
				false, null, null);
		// TODO Auto-generated constructor stub
	}
	
	public GroupingTableList(String[] columnNames, int[] columnWidths, String groupBy,
			boolean addNumberingColumn, GeneralGridCellRenderer preActionColumn, GeneralGridCellRenderer postActionColumn) {
		super(columnNames, columnWidths, addNumberingColumn, preActionColumn, postActionColumn, true, groupBy, false);
		// TODO Auto-generated constructor stub
	}
}