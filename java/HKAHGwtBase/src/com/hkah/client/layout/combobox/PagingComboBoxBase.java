package com.hkah.client.layout.combobox;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import com.extjs.gxt.ui.client.data.BasePagingLoadConfig;
import com.extjs.gxt.ui.client.data.BasePagingLoadResult;
import com.extjs.gxt.ui.client.data.BasePagingLoader;
import com.extjs.gxt.ui.client.data.DataProxy;
import com.extjs.gxt.ui.client.data.DataReader;
import com.extjs.gxt.ui.client.data.LoadEvent;
import com.extjs.gxt.ui.client.data.Loader;
import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.data.PagingLoadResult;
import com.extjs.gxt.ui.client.data.PagingLoader;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.Listener;
import com.extjs.gxt.ui.client.store.ListStore;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.button.Button;
import com.extjs.gxt.ui.client.widget.toolbar.PagingToolBar.PagingToolBarImages;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;

public abstract class PagingComboBoxBase extends ComboBoxBase {

	protected static final String DEFAULT_DISPLAY = ONE_VALUE;

	private PagingLoader<PagingLoadResult<ModelData>> loader = null;

	private boolean useCacheResult = false;
	private List<ModelData> cacheResult = null;
	private HashMap<String, ModelData> fullsetResult = new HashMap<String, ModelData>();

	public PagingComboBoxBase() {
		super();

		setStore(new ListStore<ModelData>(getLoader()));
//		setMinChars(2);
		setValueField(ONE_VALUE);
		setDisplayField(TWO_VALUE);

		setUseCacheResult(true);
//	    setStore(store);
		setHideTrigger(false);
//	    setForceSelection(true);
		setPageSize(10);
	    setEmptyText("All");
		setTriggerAction(TriggerAction.QUERY);
		setQueryDelay(1000);
	}

	public PagingLoader<PagingLoadResult<ModelData>> getLoader() {
		if (loader == null) {
			loader = new BasePagingLoader<PagingLoadResult<ModelData>>(new DataProxy<PagingLoadResult<ModelData>>() {
				@Override
				public void load(DataReader<PagingLoadResult<ModelData>> reader,
						Object loadConfigAsObject, final AsyncCallback<PagingLoadResult<ModelData>> callback) {

					BasePagingLoadConfig loadConfig = (BasePagingLoadConfig) loadConfigAsObject;
					final int offset = loadConfig.getOffset();
					final int limit = loadConfig.getLimit();

					// Get the results for the requested page...
					final List<ModelData> resultData = new ArrayList<ModelData>();

					if (isUseCacheResult() && offset > 0) {
						int totalLength = 0;

						// use cache
						if (cacheResult != null) {
							for (int i = offset; i < offset + limit; i++) {
								if (i < cacheResult.size()) {
									resultData.add(cacheResult.get(i));
								}
							}
							totalLength = cacheResult.size();
						}
						callback.onSuccess(new BasePagingLoadResult<ModelData>(resultData, offset, totalLength));
						afterLoad();
					} else {
						// USE queryUtil
						if (cacheResult == null) {
							cacheResult = new ArrayList<ModelData>();
						}
						cacheResult.clear();

						QueryUtil.executeComboBox(
								getUserInfo(), getTxCode(), getParam(),
								new MessageQueueCallBack() {
							@Override
							public void onPostSuccess(MessageQueue mQueue) {
								int totalLength = 0;
								if (mQueue.success()) {
									List<ModelData> list = convertMessageQueue2List(mQueue);
									if (list != null) {
										totalLength = list.size();

										for (int i = 0; i < totalLength; i++) {
											if (i >= offset && i < offset + limit) {
												resultData.add(list.get(i));
											}
											cacheResult.add(list.get(i));
											fullsetResult.put(list.get(i).get(ZERO_VALUE).toString().toUpperCase(), list.get(i));
										}
									}
								}
								callback.onSuccess(new BasePagingLoadResult<ModelData>(resultData, offset, totalLength));
								afterLoad();
							}
						});
					}
				}
			});
			loader.addListener(Loader.BeforeLoad, new Listener<LoadEvent>() {
				public void handleEvent(LoadEvent be) {
					be.<ModelData> getConfig().set("start", be.<ModelData> getConfig().get("offset"));
				}
			});
		}
		return loader;
	}

	/***************************************************************************
	 * Override Functions
	 **************************************************************************/

	@Override
	public boolean isValid() {
//		super.isValid() && findModelByDisplayText(getRawValue()) != null;
		ModelData modelData = findModelByKey(getRawValue());
		if (modelData != null) {
			if (getValue() == null || !getValue().equals(modelData)) {
				setValue(modelData);
			}
			return true;
		} else {
			return false;
		}
	}
	
	@Override
	public String getDisplayField() {
		if (getDisplayFieldCustom() != null) {
			return DISPLAY_FIELD_CUSTOME_NAME;
		} else {
			return super.getDisplayField();
		}
	}

	@Override
	public void setText(String key, boolean allowUpdate) {
		if (key != null && key.length() > 0) {
			ModelData modelData = findModelByKey(key, true);
			setRawValue(key);
			
			if (modelData != null) {
				getStore().clearFilters();
				setEditable(false);
				setSelectedIndex(modelData);
				setEditable(true);
			} else {
				setStoreValue(key);
				doQuery(key, true);
			}
		} else {
			callClearButton(true);
		}
	}

	@Override
	public final void onBlur() {
		// try to locate selecteditem
		String text = getRawValue();
		if (text.length() > 0) {
			ModelData modelData = findModelByKey(text, true);
			if (modelData != null) {
				getStore().clearFilters();
				setSelectedIndex(modelData);

				onSelected();
			} else if (getForceSelection()) {
				setStoreValue(text);
				doQuery(text, true);
			}
		} else if (getForceSelection()) {
			callClearButton(true);
		}

		// override by child class when lost focus
		onUpdate();
	}

	@Override
	public ModelData findModelByKey(String key) {
		return findModelByKey(key, false);
	}

	public ModelData findModelByKey(String key, boolean resetStore) {
		ModelData modelData = null;
		if (key != null && key.length() > 0) {
			modelData = super.findModelByKey(key);
			if (modelData != null) {
				return modelData;
			} else if (fullsetResult.size() > 0) {
				modelData = fullsetResult.get(key.toUpperCase());
				if (modelData != null && resetStore) {
					removeAllItems();
					getStore().add(modelData);
				}
			}
		}
		return modelData;
	}
	
	@Override
	public String getText() {
		ModelData modelData = getValue();
		return (modelData == null ? getRawValue() : (modelData.get(ZERO_VALUE)).toString());
	}

	/***************************************************************************
	 * Helper Functions
	 **************************************************************************/

	private void afterLoad() {
		ModelData modelData = null;
		String key = getRawValue();
		if (key != null) {
			modelData = findModelByKey(key);
			if (modelData != null) {
				onSelected();
				setSelectedIndex(modelData, false);
			} else {
				setSelectedIndex(modelData);
				// keep raw value
				setRawValue(key);
			}
		} else {
			setSelectedIndex(modelData);
		}
		refreshPageToolBar();
	}
	
	private void refreshPageToolBar() {
		if (pageTb != null) {
			for (Component c : pageTb.getItems()) {
				if (c instanceof Button) {
					((Button)c).fireEvent(Events.Enable);
				}
			}
			pageTb.layout();
		}
	}

	// load all the content in to full set list
	public void preloadContent() {
		QueryUtil.executeComboBox(
				getUserInfo(), getTxCode(), getParam(),
				new MessageQueueCallBack() {
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				int totalLength = 0;
				if (mQueue.success()) {
					List<ModelData> list = convertMessageQueue2List(mQueue);
					if (list != null) {
						totalLength = list.size();
						for (int i = 0; i < totalLength; i++) {
							fullsetResult.put(list.get(i).get(ZERO_VALUE).toString().toUpperCase(), list.get(i));
						}
					}
				}
			}
		});
	}

	/***************************************************************************
	 * Get/Set/Remove Functions
	 **************************************************************************/

	public boolean isUseCacheResult() {
		return useCacheResult;
	}

	public void setUseCacheResult(boolean useCacheResult) {
		this.useCacheResult = useCacheResult;
	}

	/***************************************************************************
	 * Abstract Method
	 **************************************************************************/

	protected abstract String[] getParam();

	protected abstract void initSettings();
}