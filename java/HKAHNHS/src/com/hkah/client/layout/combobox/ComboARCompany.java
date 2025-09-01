/*
 * Created on August 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;

import com.extjs.gxt.ui.client.data.ModelData;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.Events;
import com.extjs.gxt.ui.client.event.FieldEvent;
import com.extjs.gxt.ui.client.event.Listener;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.textfield.TextARCodeSearch;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.shared.constants.ConstantsTx;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboARCompany extends PagingComboBoxBase {
	private TextARCodeSearch searchArCode = null;
	private boolean loadTemplate = false;
	private boolean autoComplete = false;

	public ComboARCompany() {
		super();
		initSettings();
	}

	public ComboARCompany(TextReadOnly showTextPanel) {
		super();
		setShowTextPanel(showTextPanel);
		initSettings();
	}

	public ComboARCompany(boolean showTextSearchPanel) {
		super();
		setShowTextSearhPanel(showTextSearchPanel);
		initSettings();
		initSearchField();
	}

	public ComboARCompany(TextReadOnly showTextPanel, boolean showTextSearchPanel) {
		super();
		setShowTextPanel(showTextPanel);
		setShowTextSearhPanel(showTextSearchPanel);
		initSettings();
		initSearchField();
	}
	
	public ComboARCompany(boolean showTextSearchPanel, boolean autoComplete) {
		super();
		setShowTextSearhPanel(showTextSearchPanel);
		this.autoComplete = autoComplete;
		initSettings();
		initSearchField();
	}

	private void initSearchField() {
		searchArCode = new TextARCodeSearch(){
			@Override
			protected void postAcceptAction() {
				acceptPostAction();
			}
		};
		searchArCode.addListener(Events.Focus, new Listener<FieldEvent>() {
			@Override
			public void handleEvent(FieldEvent be) {
				// TODO Auto-generated method stub
				getThis().setText(searchArCode.getText());
				getThis().focus();
				getThis().getLoader().load();
				getThis().expand();
			}
		});
	}

	@Override
	public void initSettings() {
		setTxCode(ConstantsTx.AR_COMPANY_TXCODE);
		setItemSelector("div.search-item");
		if (!loadTemplate) {
			setTemplate(getTemplateScript());
			loadTemplate = true;
		}
		setEmptyText(EMPTY_VALUE);
		setMinListWidth(400);
		setDisplayField(ZERO_VALUE);
		preloadContent();
	}

	@Override
	protected final String[] getParam() {
		return new String[] {getTxFrom(), getRawValue(), getTxDate()};
	}

	protected native String getTemplateScript() /*-{
		return [
			'<tpl for="."><div role="listitem" class="search-item">',
			'<h5><span>{0}</span>{1}</h5>',
			'</div></tpl>',
		].join("");
	}-*/;

	/***************************************************************************
	* For child class override
	**************************************************************************/

	protected String getTxFrom() {
		return null;
	}

	protected String getTxDate() {
		return null;
	}

	@Override
	public void onSearchTriggerClick(ComponentEvent ce) {
		searchArCode.showSearchPanel();
	}

	public TextARCodeSearch getSearchArCode() {
		return this.searchArCode;
	}

	public ComboARCompany getThis() {
		return this;
	}
	
	@Override
	public String getText() {
		ModelData modelData = getValue();
		return (modelData == null ? getRawValue() : (modelData.get(ZERO_VALUE)).toString());
	}

	@Override
	protected void onTypeAhead() {
		if ("N".equals(Factory.getInstance().getSysParameter("AUTOCOMPAR")) && !autoComplete) {
			return;
		} else {
			super.onTypeAhead();
		}
	}
	
	protected void acceptPostAction() {
		// for override if necessary
	}
}