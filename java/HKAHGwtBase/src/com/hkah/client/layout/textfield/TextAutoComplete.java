package com.hkah.client.layout.textfield;


import com.extjs.gxt.ui.client.data.LoadEvent;
import com.extjs.gxt.ui.client.data.Loader;
import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.BaseEvent;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.DomEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.GridEvent;
import com.extjs.gxt.ui.client.event.KeyListener;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.util.KeyNav;
import com.google.gwt.event.dom.client.KeyCodes;
import com.google.gwt.user.client.ui.PopupPanel;
import com.hkah.client.layout.table.PagingGridBase;

public class TextAutoComplete extends TextBase {
	String txCode = null;
	String actionType = null;
	String[] param = new String[] {};
	PagingGridBase autoMatchGrid = null;
	int gridHeight = 250;
	PopupPanel autoMatchPopupPanel = null;
	
	public TextAutoComplete() {
		super();
	}
	
	public void initialize() {
		getAutoMatchPopupPanel().add(getAutoMatchGrid());
		addDefaultListener();
	}
	
	private void addDefaultListener() {
		this.addListener(Events.OnClick, new Listener<FieldEvent>() {
			@Override
			public void handleEvent(FieldEvent be) {
				// TODO Auto-generated method stub
				searchMatches();
			}
		});
		
		this.addKeyListener(new KeyListener() {
			@Override
			public void componentKeyUp(ComponentEvent event) {
				if (KeyCodes.KEY_DOWN == event.getKeyCode()) {
					//System.err.println("Key_Down Event.....");
					return;
				}
				
				if (KeyCodes.KEY_UP == event.getKeyCode()) {
					//System.err.println("Key_Up Event.....");
					return;
				}
				
				if (KeyCodes.KEY_ENTER == event.getKeyCode()) {
					//System.err.println("Key_Enter Event.....");
					return;
				}
				
				if (KeyCodes.KEY_ESCAPE == event.getKeyCode()) {
					//System.err.println("Key_Escape Event.....");
					
					close();
					return;
				}
				
				searchMatches();
			}
		});
	}
	
	protected void close() {
		getAutoMatchGrid().getGrid().getStore().removeAll();
		getAutoMatchPopupPanel().hide();
	}
	
	protected void searchMatches() {
		String text = getText();
		if (text != null && text.length() > 0) {
			setSearchParam(text);

			getAutoMatchGrid().reLoad();
			getAutoMatchPopupPanel().setPopupPosition(
					getAbsoluteLeft(), 
					getAbsoluteTop()+getHeight());
			getAutoMatchPopupPanel().show();
			searchMatchesPost();
		}
	}
	
	protected void searchMatchesPost() {
		
	}
	
	protected void setSearchParam(String key) {
		setParam(new String[] { "search", key, "" });
	}
	
	protected PopupPanel getAutoMatchPopupPanel() {
		if (autoMatchPopupPanel == null) {
			autoMatchPopupPanel = new PopupPanel(true);
			autoMatchPopupPanel.setWidth("330");
		}
		return autoMatchPopupPanel;
	}
	
	protected PagingGridBase getAutoMatchGrid() {
		if (autoMatchGrid == null) {
			autoMatchGrid = new PagingGridBase(
								getColumnID(),
								getColumnWidth(),
								getColumnNames(),
								getGridHeight()) {
				@Override
				protected void initStore() {
					loader = initLoader();
					loader.addListener(Loader.BeforeLoad, new Listener<LoadEvent>() {  
						public void handleEvent(LoadEvent be) {  	        	
							be.<ModelData> getConfig().set("start", be.<ModelData> getConfig().get("offset"));  
					        be.<ModelData> getConfig().set("txCode", getTAC().getTxCode());  
					        be.<ModelData> getConfig().set("actionType", getTAC().getActionType());  
					        be.<ModelData> getConfig().set("param", getTAC().getParam());
					        be.<ModelData> getConfig().set("colID", getTAC().getColumnID());
					    }  
					});  
				}
			};

			autoMatchGrid.addListener(KeyNav.getKeyEvent(), 
									new Listener() {
				@Override
				public void handleEvent(BaseEvent be) {
					// TODO Auto-generated method stub
					if (KeyCodes.KEY_DOWN == ((DomEvent) be).getKeyCode()) {
						//System.out.println("Key_Down Event.....");
						
					}
					
					if (KeyCodes.KEY_UP == ((DomEvent) be).getKeyCode()) {
						//System.out.println("Key_Up Event.....");
					}
					
					if (KeyCodes.KEY_ENTER == ((DomEvent) be).getKeyCode()) {
						//System.out.println("Key_Enter Event.....");
					}
					
					if (KeyCodes.KEY_ESCAPE == ((DomEvent) be).getKeyCode()) {
						//System.out.println("Key_Escape Event.....");
						
						close();
					}
				}
			});
			
			autoMatchGrid.getGrid().addListener(Events.RowDoubleClick, 
				new Listener<GridEvent>() {
					@Override
					public void handleEvent(GridEvent be) {
						// TODO Auto-generated method stub
						//System.err.println("RowDoubleClick...");
						matchGridRowDoubleClickEvent(be);
					}
			});
		}
		return autoMatchGrid;
	}
	
	protected void matchGridRowDoubleClickEvent(GridEvent ge) {
		
	}
	
	protected String[] getColumnID() {
		return null;
	}
	
	protected String[] getColumnNames() {
		return null;
	}
	
	protected int[] getColumnWidth() {
		return null;
	}
	
	public int getGridHeight() {
		return gridHeight;
	}
	
	public void setGridHeight(int gridHeight) {
		this.gridHeight = gridHeight;
	}
	
	/**
	 * @return the txCode
	 */
	public String getTxCode() {
		return txCode;
	}

	/**
	 * @param txCode the txCode to set
	 */
	public void setTxCode(String txCode) {
		this.txCode = txCode;
	}
	
	/**
	 * @return the actionType
	 */
	public String getActionType() {
		return actionType;
	}

	/**
	 * @param actionType the actionType to set
	 */
	public void setActionType(String actionType) {
		this.actionType = actionType;
	}
	
	/**
	 * @return the param
	 */
	public String[] getParam() {
		return param;
	}

	/**
	 * @param param the param to set
	 */
	public void setParam(String[] param) {
		this.param = param;
	}
	
	public TextAutoComplete getTAC() {
		return this;
	}
}
