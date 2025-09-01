package com.hkah.client.layout.panel;

import java.util.ArrayList;
import java.util.List;

import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.event.TabPanelEvent;
import com.extjs.gxt.ui.client.widget.TabItem;
import com.extjs.gxt.ui.client.widget.TabPanel;
import com.google.gwt.user.client.ui.AbstractImagePrototype;
import com.google.gwt.user.client.ui.Widget;

public class TabbedPaneBase extends TabPanel {

	private List<TabItem> tabItemList = null;
	private boolean skipChangeState = false;

	public TabbedPaneBase() {
		super();
		init();
	}

	public void init() {
		tabItemList = new ArrayList<TabItem>();
		addListener(Events.Select, new Listener<TabPanelEvent>() {
			public void handleEvent(TabPanelEvent be) {
				if (!skipChangeState) {
					onStateChange();
				}
			}
		});
	}
	public int getSelectedIndex() {
		return tabItemList.indexOf(getSelectedItem());
	}

	@Override
	public void setBounds(int x, int y, int width, int height) {
		setLocation(x, y);
		setSize(width, height);
	}

	public void setLocation(int x, int y) {
		setPosition(x, y);
	}
	
	public void addTab(String title, Widget widget) {
		addTab(title, widget, true);
	}

	public void addTab(String title, Widget widget, boolean enable) {
		TabItem tabItem = new TabItem();
		tabItem.setHtml(title);
		tabItem.add(widget);
		tabItem.setEnabled(enable);
		this.add(tabItem);
		tabItemList.add(tabItem);
	}
	public void addTab(String title, AbstractImagePrototype icon, Widget widget, String tip) {
		TabItem tabItem = new TabItem();
		tabItem.setHtml(title);
		tabItem.setIcon(icon);
		tabItem.setToolTip(tip);
		tabItem.add(widget);
		this.add(tabItem);
		tabItemList.add(tabItem);
	}

	public void setSelectedIndex(int index) {
		TabItem item = super.getItem(index);
		if (item != null) {
			super.setSelection(item);
		}
	}

	public void setSelectedIndexWithoutStateChange(int index) {
		skipChangeState = true;
		setSelectedIndex(index);
		skipChangeState = false;
	}

	public void onStateChange() {
		// override by child
	}
}