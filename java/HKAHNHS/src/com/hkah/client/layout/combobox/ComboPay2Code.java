/*
 * Created on August 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;

import com.extjs.gxt.ui.client.data.ModelData;
import com.hkah.client.common.Factory;
import com.hkah.shared.constants.ConstantsTx;

public class ComboPay2Code extends ComboBoxShowKey {

	public ComboPay2Code() {
		super();
	}
	
	public ComboPay2Code(String date) {
		super(date);
	}

	@Override
	public void initContent(String date) {
		// initial combobox
		resetContent(ConstantsTx.PAY_CODE2_TXCODE, new String[] { date });
	}
	
	@Override
	public String getText() {
		ModelData modelData = getValue();
		return (modelData == null ? getRawValue() : (modelData.get(ZERO_VALUE)).toString());
	}
	
	@Override
	public final void onBlur() {
		// try to locate selecteditem
		String text = getRawValue();
		if (text.length() > 0) {
			ModelData modelData = findModelByKey(text);
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
	protected void onTypeAhead() {
		if ("N".equals(Factory.getInstance().getSysParameter("AUTOCOMPAR"))) {
			return;
		} else {
			super.onTypeAhead();
		}
	}
}