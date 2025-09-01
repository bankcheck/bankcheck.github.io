package com.hkah.client.layout.panel;

import com.extjs.gxt.ui.client.widget.LayoutContainer;
import com.extjs.gxt.ui.client.widget.grid.Grid;
import com.extjs.gxt.ui.client.widget.layout.FitLayout;
import com.google.gwt.user.client.Element;
import com.hkah.client.layout.table.TableData;

public class JScrollPane extends LayoutContainer {

	@Override
	protected void onRender(Element parent, int index) {
		super.onRender(parent, index);
		setBorders(true);
		setLayout(new FitLayout());
	}
	
	public void setViewportView(Grid<TableData> tableList) {
		super.add(tableList);
	}

	public void removeViewportView(Grid<TableData> tableList) {
		super.remove(tableList);
	}

	@Override
	public void setBounds(int x, int y, int width, int height) {
		setPosition(x, y);
	    setSize(width, height);
	}
}
