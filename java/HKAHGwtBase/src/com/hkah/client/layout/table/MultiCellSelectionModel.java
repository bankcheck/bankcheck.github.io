package com.hkah.client.layout.table;

import java.util.ArrayList;

import com.extjs.gxt.ui.client.GXT;
import com.extjs.gxt.ui.client.aria.FocusFrame;
import com.extjs.gxt.ui.client.core.El;
import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.store.StoreEvent;
import com.extjs.gxt.ui.client.widget.grid.CellSelectionModel;
import com.google.gwt.dom.client.Element;

public class MultiCellSelectionModel<M extends ModelData> extends CellSelectionModel<M> {
	ArrayList<CellSelection> selections = new ArrayList<CellSelection>();
	
	public ArrayList<CellSelection> getSelections() {
		return selections;
	}
	
	private boolean isSelected(int row, int cell) {
		for (CellSelection cs : selections) {
			if (cs.cell == cell && cs.row == row) {
				return true;
			}
		}
		return false;
	}
	
	private CellSelection getSelectedObject(int row, int cell) {
		for (CellSelection cs : selections) {
			if (cs.cell == cell && cs.row == row) {
				return cs;
			}
		}
		return null;
	}
	
	@Override
	public void selectCell(int row, int cell) {
		M m = listStore.getAt(row);
		if (GXT.isFocusManagerEnabled() && selectedHeader != null) {
			selectedHeader = null;
			FocusFrame.get().frame(grid);
		}
		selection = new CellSelection(m, row, cell);

		if (isSelected(row, cell)) {
			if (grid.isViewReady()) {
				Element dom = grid.getView().getCell(row, cell);
			    if (dom != null) {
			    	((El)El.fly(dom, "component")).removeStyleName("x-grid3-cell-selected");
			    	if (GXT.isAriaEnabled()) {
			    		dom.setAttribute("aria-selected", "false");
			    	}
			    }
			    selections.remove(getSelectedObject(row, cell));
		    }
		}
		else {
			if (grid.isViewReady()) {
				Element dom = grid.getView().getCell(row, cell);
			    if (dom != null) {
			      ((El)El.fly(dom, "component")).addStyleName("x-grid3-cell-selected");
			      if (GXT.isAriaEnabled()) {
			    	  dom.setAttribute("aria-selected", "true");
			    	  //grid.setAriaState("aria-activedescendant", dom.getId());
			      }
			    }
			    selections.add(selection);
				grid.getView().focusCell(row, cell, true);
			}
		}
	}
	
	@Override
	protected void onClear(StoreEvent<M> se) {
		super.onClear(se);
		selections.clear();
	}
}
