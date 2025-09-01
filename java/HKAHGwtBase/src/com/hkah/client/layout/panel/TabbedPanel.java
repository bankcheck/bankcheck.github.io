package com.hkah.client.layout.panel;

import com.extjs.gxt.ui.client.widget.TabItem;
import com.extjs.gxt.ui.client.widget.TabPanel;

public class TabbedPanel extends TabPanel {
	public void setSelectedIndex(int index) {
		TabItem item = super.getItem(index);
		if (item != null) {
			super.setSelection(item);
		}
	}
}