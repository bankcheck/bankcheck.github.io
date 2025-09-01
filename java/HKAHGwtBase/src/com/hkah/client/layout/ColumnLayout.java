package com.hkah.client.layout;

import com.extjs.gxt.ui.client.widget.LayoutContainer;
import com.extjs.gxt.ui.client.widget.form.FieldSet;
import com.extjs.gxt.ui.client.widget.layout.ColumnData;
import com.extjs.gxt.ui.client.widget.layout.FlowLayout;
import com.google.gwt.user.client.ui.Widget;

public class ColumnLayout extends FieldSet {

	private static final long serialVersionUID = 1L;

	private LayoutContainer[][] containers;

	public ColumnLayout(int columnNumber, int rowNumber) {
		this(columnNumber, rowNumber, null, null);
	}

	public ColumnLayout(int columnNumber, int rowNumber, int[] columnWidths) {
		this(columnNumber, rowNumber, columnWidths, null);
	}

	public ColumnLayout(int columnNumber, int rowNumber, int[] columnWidths, int[] rowHeight) {
		setBorders(false);
		setLayout(new com.extjs.gxt.ui.client.widget.layout.ColumnLayout());

		int width=0;
		if (columnWidths != null) {
			for (int i = 0; i < columnWidths.length; i++) {
				width += columnWidths[i];
			}
		} else {
			width = columnNumber * 150;
		}
		int height=0;
		if (rowHeight != null) {
			for (int i = 0; i < rowHeight.length; i++) {
				height += rowHeight[i];
			}
		} else {
			height = rowNumber * 25 + 20;
		}

		LayoutContainer container = null;
		containers = new LayoutContainer[rowNumber][columnNumber];
		for (int i = 0; i < columnNumber; i++) {
			container = new LayoutContainer();
			for (int j = 0; j < rowNumber; j++) {
				containers[j][i] = new LayoutContainer();
				containers[j][i].setLayout(new FlowLayout());
				if (rowHeight != null) {
					containers[j][i].setHeight(rowHeight[j]);
				} else {
					containers[j][i].setHeight(25);
				}
				if (columnWidths != null) {
					containers[j][i].setWidth(columnWidths[i]);
				} else {
					containers[j][i].setWidth(150);
				}
//				containers[j][i].setStyleAttribute("padding-left", "0px");
//				if(i>0 && i%2==0){
//					containers[j][i].setStyleAttribute("margin-left", "10px");
//				}
//				if(j!=0){
//					containers[j][i].setStyleAttribute("margin-top", "10px");
//				}
				container.add(containers[j][i]);
			}

			if (columnWidths != null) {
				add(container, new ColumnData(columnWidths[i] / (width + 1.0)));
			} else {
				add(container, new ColumnData(1.0 / columnNumber));
			}
		}

		setSize(width, height);
		setStyleAttribute("margin-bottom", "5px");
		if (getHeading() == null) {
			setStyleAttribute("padding-top", "5px");
		}
		layout();
	}

	public void setHeading(String title) {
		if (title != null) {
			setBorders(true);
			super.setHeadingHtml(title);
		}
	}

	public String getHeading() {
		return super.getHeadingHtml();
	}

	@Override
	public void setBorders(boolean show) {
		super.setBorders(show);
		if (show) {
			setStyleAttribute("border-color", "#b5b8c8");
			setStyleAttribute("padding", "5px");
			setStyleAttribute("margin", "0px");
		} else {
			setStyleAttribute("padding", "0px");
			setStyleAttribute("margin", "0px");
		}
	}

	public void add(int gridx, int gridy, Widget comp) {
		containers[gridy][gridx].add(comp);
	}

	@Override
	public void setBounds(int x, int y, int width, int height) {
		setPosition(x, y);
		setSize(width, height);
	}
}