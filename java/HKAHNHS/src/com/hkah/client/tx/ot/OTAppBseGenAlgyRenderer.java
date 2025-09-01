package com.hkah.client.tx.ot;

import com.extjs.gxt.ui.client.store.ListStore;
import com.extjs.gxt.ui.client.widget.grid.ColumnData;
import com.extjs.gxt.ui.client.widget.grid.Grid;
import com.hkah.client.layout.table.GeneralActionCellRenderer;
import com.hkah.client.layout.table.TableData;

public class OTAppBseGenAlgyRenderer extends GeneralActionCellRenderer {
	@Override
	public Object render(final TableData model, final String property, final ColumnData config,
			final int rowIndex, final int colIndex, final ListStore<TableData> store, final Grid<TableData> grid) {
		final String ALLEGY_ALERT_CSS = "allegy-alert";
		if (config.style == null) {
            config.css = ALLEGY_ALERT_CSS;
        } else if (!config.css.contains(ALLEGY_ALERT_CSS)) {
            config.css = ALLEGY_ALERT_CSS + config.css;
        }

        return model.get(property);
	}
}
