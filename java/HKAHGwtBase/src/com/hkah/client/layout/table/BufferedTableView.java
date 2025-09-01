package com.hkah.client.layout.table;

import java.util.List;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.EventType;
import com.extjs.gxt.ui.client.store.ListStore;
import com.extjs.gxt.ui.client.store.StoreEvent;
import com.extjs.gxt.ui.client.util.Point;
import com.extjs.gxt.ui.client.widget.grid.ColumnModel;
import com.extjs.gxt.ui.client.widget.grid.LiveGridView;
import com.google.gwt.dom.client.Element;

public class BufferedTableView extends LiveGridView {

	public static EventType StoreSet = new EventType();
	private boolean preventCalculateVBar;
	private int scrollLeft = 0;
	private boolean reload = false;

	public ListStore<ModelData> getDisplayStore() {
		return this.ds;
	}

	public ListStore<ModelData> getCacheStore() {
		return this.liveStore;
	}
	
	public int getLiveStoreOffset() {
		return liveStoreOffset;
	}

	// see bug http://www.sencha.com/forum/showthread.php?125792-LiveGridView-with-empty-store
	@Override
	protected boolean isCached(int index) {
		if ((index < liveStoreOffset) || (index > (liveStoreOffset + getCacheSize() - getVisibleRowCount()))) {
			return false;
		}
		return true;
	}

	// see bug http://www.sencha.com/forum/showthread.php?126291-LiveGridView-doesn-t-refresh-display-when-store-is-empty@Override
	@Override
	protected void updateRows(int newIndex, boolean reload) {
		//scroller.setScrollLeft(scrollLeft);
		super.updateRows(newIndex, reload);
		
		if (!reload) {
			scrollLeft = scroller.getScrollLeft();
		}
		
		if (this.ds.getCount() == 0) {
			applyEmptyText();
		}
		
		updateRowsPost(ds);
	}
	
	public void updateRowsPost(ListStore<ModelData> displayStore) {
		
	}

	@Override
	protected void initData(ListStore ds, ColumnModel cm) {
		super.initData(ds, cm);
		fireEvent(StoreSet);
	}
	
	@Override
	protected void doLoad() {
		scrollLeft = scroller.getScrollLeft();
		setReload(true);
	    super.doLoad();
	}
	
	@Override
	protected void syncHScroll() {
		//scrollLeft = scroller.getScrollLeft();
		super.syncHScroll();
		if (reload) {
			scroller.setScrollLeft(scrollLeft);
		}
	}

	@Override
	public void onRowSelect(int rowIndex) {
		scrollLeft = scroller.getScrollLeft();
		super.onRowSelect(rowIndex);
		applyEmptyText();
		setReload(false);
		calculateVBar(false);
	}

	@Override
	public void refresh(boolean headerToo) {
		super.refresh(headerToo);
		refreshSelection();
	}
	
	@Override
	protected void processRows(int startRow, boolean skipStripe) {
		super.processRows(startRow, skipStripe);
	}

	public void refreshSelection() {
		List<ModelData> selectedItems = grid.getSelectionModel().getSelectedItems();
		for (ModelData selectedItem : selectedItems) {
			for (ModelData model : ds.getModels()) {
				if (model.equals(selectedItem)) {
					int idx = ds.indexOf(selectedItem);
					onRowSelect(idx);
					break;
				}
			}
		}
	}

	public void scrollUp() {
		if (viewIndex > 0) {
			liveScroller.setScrollTop((viewIndex - 1) * getCalculatedRowHeight());
			updateRows(viewIndex - 1, false);
		}
	}

	public void scrollDown() {
		if ((totalCount - getVisibleRowCount()) > viewIndex) {
			liveScroller.setScrollTop((viewIndex + 1) * getCalculatedRowHeight());
			updateRows(viewIndex + 1, false);
		}
	}
	
	/**
     * Handles clearing the store.
     *
     * @param se the event that cleared the store
     */
    @Override
    protected void onClear(StoreEvent<ModelData> se) {
    	boolean previous = preventCalculateVBar;
    	scrollLeft = scroller.getScrollLeft();
    	preventCalculateVBar = true;
    	refresh(false);
    	preventCalculateVBar = previous;
    }
    
    @Override
    protected void calculateVBar(boolean force) {
    	if (preventCalculateVBar) {
    		return;
    	}
    	if (!reload) {
    		scroller.setScrollLeft(scrollLeft);
    	}
    	
    	super.calculateVBar(force);
    }
    
    public void setReload(boolean reload) {
    	this.reload = reload;
    }
    
    @Override
    public Point ensureVisible(int row, int col, boolean hscroll) {
        if (grid == null || !grid.isViewReady() || row < 0 || row > ds.getCount()) {
          return null;
        }

        if (col == -1) {
          col = 0;
        }

        Element rowEl = getRow(row);
        Element cellEl = null;
        
        if (!(!hscroll && col == 0)) {
            while (cm.isHidden(col)) {
              col++;
            }
            //cellEl = getCell(row, col);

          }

        if (rowEl == null) {
          return null;
        }

        Element c = scroller.dom;

        int ctop = 0;
        Element p = rowEl, stope = el.dom;
        while (p != null && p != stope) {
          ctop += p.getOffsetTop();
          p = p.getOffsetParent().cast();
        }
        ctop -= mainHd.dom.getOffsetHeight();

        int cbot = ctop + rowEl.getOffsetHeight();

        int ch = c.getOffsetHeight();
        int stop = c.getScrollTop();
        int sbot = stop + ch;

        if (ctop < stop) {
          c.setScrollTop(ctop);
        } else if (cbot > sbot) {
          if (hscroll && (cm.getTotalWidth() > scroller.getWidth() - scrollOffset)) {
            cbot += scrollOffset;
          }
          c.setScrollTop(cbot -= ch);
        }
        
        if (hscroll && cellEl != null) {
        	/*
            int cleft = cellEl.getOffsetLeft();
            int cright = cleft + cellEl.getOffsetWidth();
            int sleft = c.getScrollLeft();
            int sright = sleft + c.getOffsetWidth();
            if (cleft < sleft) {
              c.setScrollLeft(cleft);
            } else if (cright > sright) {
              c.setScrollLeft(cright - scroller.getStyleWidth());
            }
            */
        	c.setScrollLeft(scrollLeft);
          }

        return cellEl != null ? fly(cellEl).getXY() : new Point(c.getScrollLeft(), fly(rowEl).getY());
    }
    /*
    @Override
    public void focusRow(int rowIndex) {
    	int colIndex = 0;
    	int scrollLeftIndex = scrollLeft;
    	while (scrollLeftIndex > 0) {
    		scrollLeftIndex -= grid.getColumnModel().getColumnWidth(colIndex);
    		colIndex++;
    	}
    	
    	 focusCell(rowIndex, colIndex==0?colIndex:colIndex-1, true);
    	 calculateVBar(false);
    }*/
}