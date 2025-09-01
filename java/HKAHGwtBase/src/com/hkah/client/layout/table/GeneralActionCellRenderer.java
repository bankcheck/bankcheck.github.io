package com.hkah.client.layout.table;

import java.util.List;

import com.extjs.gxt.ui.client.event.ButtonEvent;
import com.extjs.gxt.ui.client.event.SelectionListener;
import com.extjs.gxt.ui.client.store.ListStore;
import com.extjs.gxt.ui.client.widget.grid.ColumnData;
import com.extjs.gxt.ui.client.widget.grid.Grid;
import com.hkah.client.Resources;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.button.ButtonGroupBase;

public class GeneralActionCellRenderer extends GeneralGridCellRenderer {
	protected boolean hasAddButton = true;
	protected boolean hasRemoveButton = true;
	protected List<ButtonBase> preButtons = null;
	protected List<ButtonBase> postButtons = null;
	
	public GeneralActionCellRenderer() {
		super();
		setColumnWidth(60);
	}
	
	public GeneralActionCellRenderer(boolean hasAddButton,
			boolean hasRemoveButton) {
		super();
		this.hasAddButton = hasAddButton;
		this.hasRemoveButton = hasRemoveButton;
		setColumnWidth(60);
	}
	
	public GeneralActionCellRenderer(boolean hasAddButton,
			boolean hasRemoveButton, List<ButtonBase> preButtons, List<ButtonBase> postButtons) {
		super();
		this.hasAddButton = hasAddButton;
		this.hasRemoveButton = hasRemoveButton;
		this.preButtons = preButtons;
		this.postButtons = postButtons;
		setColumnWidth(60);
	}
	
	private String[] columnNames = null;
	
	public String[] getColumnNames() {
		return columnNames;
	}

	public void setColumnNames(String[] columnNames) {
		this.columnNames = columnNames;
	}

	public boolean isHasAddButton() {
		return hasAddButton;
	}

	public void setHasAddButton(boolean hasAddButton) {
		this.hasAddButton = hasAddButton;
	}

	public boolean isHasRemoveButton() {
		return hasRemoveButton;
	}

	public void setHasRemoveButton(boolean hasRemoveButton) {
		this.hasRemoveButton = hasRemoveButton;
	}
	
	public void onRemoveButtonClicked(TableData model, String property, ColumnData config,
			int rowIndex, int colIndex, ListStore<TableData> store, Grid<TableData> grid) {
		if (store.getModels().size() > 0)
			store.remove(model); 
	}
	
	public void onAddButtonClicked(TableData model, String property, ColumnData config,
			int rowIndex, int colIndex, ListStore<TableData> store, Grid<TableData> grid) {
		List<TableData> list = store.getModels();
		try {
			int columnSize = model.getSize();
			String[] columnNames = (String[]) model.getPropertyNames().toArray(new String[columnSize]);
			
			TableData newModel = new TableData(columnNames, new Object[columnSize]);
			int curModelIdx = store.indexOf(model);
			
			if (store.getModels().size() == curModelIdx + 1)
				store.add(newModel);
			else 
				store.insert(newModel, curModelIdx + 1);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	protected boolean showRemoveButton(final TableData model, final String property, final ColumnData config,
			final int rowIndex, final int colIndex, final ListStore<TableData> store, final Grid<TableData> grid) {
		return true;
	}

	
	protected boolean showAddButton(final TableData model, final String property, final ColumnData config,
			final int rowIndex, final int colIndex, final ListStore<TableData> store, final Grid<TableData> grid) {
		return true;
	}

	@Override
	public Object render(final TableData model, final String property, final ColumnData config,
			final int rowIndex, final int colIndex, final ListStore<TableData> store, final Grid<TableData> grid) {
		// TODO Auto-generated method stub
		
		boolean showRemoveButton = hasRemoveButton && showRemoveButton(model, property, config,
				rowIndex, colIndex, store, grid);
		boolean showAddButton = hasAddButton && showAddButton(model, property, config,
				rowIndex, colIndex, store, grid);
		
		int colSize = 0;
		if (preButtons != null)
			colSize += preButtons.size();
		if (showRemoveButton)
			colSize++;
		if (showAddButton)
			colSize++;
		if (postButtons != null)
			colSize += postButtons.size();
		
		ButtonGroupBase buttonGroup = new ButtonGroupBase(colSize);
		
		if (preButtons != null) {
			for (ButtonBase button : preButtons) {
				buttonGroup.add(button);
			}
		}
		
		if (showRemoveButton) {
			ButtonBase removeButton = new ButtonBase(null, Resources.ICONS.remove(), new SelectionListener<ButtonEvent>() {
				@Override
				public void componentSelected(ButtonEvent ce) {
					onRemoveButtonClicked(model, property, config,
							rowIndex, colIndex, store, grid);
				}
			});
			buttonGroup.add(removeButton);
		}
		
		if (showAddButton) {
			ButtonBase addButton = new ButtonBase(null, Resources.ICONS.add(), new SelectionListener<ButtonEvent>() {
				@Override
				public void componentSelected(ButtonEvent ce) {
					onAddButtonClicked(model, property, config,
							rowIndex, colIndex, store, grid);
				}
			});
			buttonGroup.add(addButton);
		}
		
		if (postButtons != null) {
			for (ButtonBase button : postButtons) {
				buttonGroup.add(button);
			}
		}
		
		return buttonGroup;
	}

}
