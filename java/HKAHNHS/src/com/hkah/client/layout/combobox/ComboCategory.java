/*
 * Created on August 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;

import com.extjs.gxt.ui.client.data.ModelData;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.shared.constants.ConstantsTx;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboCategory extends ComboBoxShowKey {

	public ComboCategory() {
		super();
		setMinListWidth(200);
	}

	public ComboCategory(TextReadOnly showTextPanel) {
		super();
		setShowTextPanel(showTextPanel);
		setMinListWidth(200);
	}

	@Override
	public void initContent(String value) {
		// initial combobox
		resetContent(ConstantsTx.PATIENT_CATEGORY_TXCODE);
	}

	public String getPcyID() {
		ModelData modelData = getValue();
		return (modelData == null ? getRawValue() : (modelData.get(TWO_VALUE)).toString());
	}

	public void setPcyID(String pcyID) {
		setSelectedIndex(findModel(TWO_VALUE, pcyID));
	}
}