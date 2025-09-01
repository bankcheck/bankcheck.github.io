package com.hkah.client.layout.table;

import com.extjs.gxt.ui.client.store.ListStore;
import com.extjs.gxt.ui.client.widget.grid.ColumnData;
import com.extjs.gxt.ui.client.widget.grid.Grid;
import com.extjs.gxt.ui.client.widget.grid.GridCellRenderer;
import com.hkah.shared.constants.ConstantsVariable;

public class GeneralGridCellRenderer implements GridCellRenderer<TableData>, ConstantsVariable {
	public final static int COLUMN_WIDTH = 50;
	public final static String STYLE_RED = "style='color:color:red'";
	public final static String STYLE_GREEN = "style='color:color:green'";

	private final static String DISPLAY_TAG1 = "<span ";
	private final static String DISPLAY_TAG2 = " qtip='";
	private final static String DISPLAY_TAG3 = "'>";
	private final static String DISPLAY_TAG4 = "</span>";
	private final static String NULL_VALUE = "null";

	private int columnWidth = 0;

	public int getColumnWidth() {
		return columnWidth;
	}

	public void setColumnWidth(int columnWidth) {
		this.columnWidth = columnWidth;
	}

	private static String htmlEncode(String value) {
		return value == null ? value : value
				.replace(AND_VALUE, AND_HTML_VALUE)
				.replace(GREATER_THAN_VALUE, GREATER_THAN_HTML_VALUE)
				.replace(SMALLER_THAN_VALUE, SMALLER_THAN_HTML_VALUE)
				.replace(DOUBLE_QUOTE_VALUE, DOUBLE_QUOTE_HTML_VALUE)
				.replace(SINGLE_QUOTE_VALUE, SINGLE_QUOTE_HTML_VALUE);
	}

	@Override
	public Object render(TableData model, String property,
			ColumnData config, int rowIndex, int colIndex,
			ListStore<TableData> store, Grid<TableData> grid) {
		// default qtip for the content of that cell
		return renderHelper((String) model.get(property), null);
	}

	protected String renderHelper(String textValue, String textStyle) {
		// default qtip for the content of that cell
		if (textValue != null && textValue.length() > 0 && !NULL_VALUE.equals(textValue)) {
			StringBuilder text = new StringBuilder();
			text.append(DISPLAY_TAG1);
			if (textStyle != null) {
				text.append(textStyle);
			}
			text.append(DISPLAY_TAG2);
			text.append(htmlEncode(textValue));
			text.append(DISPLAY_TAG3);
			text.append(textValue);
			text.append(DISPLAY_TAG4);
			return text.toString();
		} else {
			return EMPTY_VALUE;
		}
	}
}