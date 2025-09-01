package com.hkah.client.layout.table;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.BaseEvent;
import com.extjs.gxt.ui.client.event.GridEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.store.Store;
import com.extjs.gxt.ui.client.store.StoreEvent;
import com.extjs.gxt.ui.client.store.StoreListener;
import com.extjs.gxt.ui.client.widget.grid.Grid;
import com.extjs.gxt.ui.client.widget.grid.GridSelectionModel;
import com.google.gwt.user.client.Command;
import com.google.gwt.user.client.DeferredCommand;

public class BufferedTableSelectionModel<M extends ModelData> extends GridSelectionModel<ModelData>{

	private BufferedTableView gridView;
	private boolean selectFirstOnNextLoad = true;

	public BufferedTableSelectionModel(BufferedTableView view) {
		this.gridView = view;
		view.addListener(view.StoreSet, new Listener<BaseEvent>() {
			public void handleEvent(BaseEvent be) {
				
				// LiveGridView uses two ListStore's. One contains just the models that are currently
				// displayed on the screen, and the other is a cache store that contains more
				// models (e.g. 200 at default).
				// As default the GridSelection model uses the cache store, which results in wrong
				// selection of items. Therefore we need to use only the display store in the
				// selection model.
				listStore = gridView.getDisplayStore();
				store = gridView.getDisplayStore();
				store.addStoreListener(new StoreListener<ModelData>() {
					@Override
					public void storeAdd(StoreEvent<ModelData> se) {
						super.storeAdd(se);
						gridView.refreshSelection();
						
						// This is just a handy feature, to select the first item on next reload.
						if (selectFirstOnNextLoad) {
							selectFirstOnNextLoad = false;
							DeferredCommand.addCommand(new Command() {
								public void execute() {
									select(0, false);
								}
							});
						}
					}
				});
			}
		});
	}
	
	/**
	 * 
	 * @return returns true if first model in currently displayed list of models is selected on next reload
	 */
	public boolean isSelectFirstOnNextLoad() {
		return selectFirstOnNextLoad;
	}

	/**
	 * Use this method if you want to select the first model on next reload (defaults to false)
	 * 
	 * @param selectFirstOnNextLoad
	 */
	public void setSelectFirstOnNextLoad(boolean selectFirstOnNextLoad) {
		this.selectFirstOnNextLoad = selectFirstOnNextLoad;
	}
	
	@Override
	public void bindGrid(Grid grid) {
		super.bindGrid(grid);
		listStore = gridView.getDisplayStore();
	}
	
	@Override
	public void bind(Store store) {
		super.bind(store);
		this.store = gridView.getDisplayStore();
	}
	
	/**
	 * The selection list is automatically cleared when models are removed from
	 * the display store (e.g. when you scroll up or down). We need to change this
	 * behavior so that selections are remembered, even if store changes content.
	 * Therefore the methods refresh() and onClear() are overridden to do nothing.
	 * 
	 * Use this method instead to clear selected items.
	 */
	public void clearSelected() {
		selected.clear();
		lastSelected = null;
	}
	
	@SuppressWarnings("rawtypes")
	@Override
	protected void doSingleSelect(ModelData model, boolean supressEvent) {
		super.doSingleSelect(model, supressEvent);
		doSingleSelectPost(model, gridView.getLiveStoreOffset());
	}
	
	public void doSingleSelectPost(ModelData model, int offset) {
		
	}
	
	@Override
	public void refresh() {}
	
	@Override
	protected void onClear(StoreEvent<ModelData> se) {}
	
	@Override
	protected void onKeyUp(GridEvent<ModelData> e) {
		if (!hasPrevious()) {
			gridView.scrollUp();
		}
		super.onKeyUp(e);
	}
	
	@Override
	protected void onKeyDown(GridEvent<ModelData> e) {
		if (!hasNext()) {
			gridView.scrollDown();
		}
		super.onKeyDown(e);
	}
}
