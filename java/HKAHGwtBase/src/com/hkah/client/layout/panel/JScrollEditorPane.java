package com.hkah.client.layout.panel;

import com.hkah.client.layout.table.EditorTableList;

public class JScrollEditorPane extends JScrollPane {
	public void setViewportView(EditorTableList tableList) {
		super.add(tableList);
	}
}
