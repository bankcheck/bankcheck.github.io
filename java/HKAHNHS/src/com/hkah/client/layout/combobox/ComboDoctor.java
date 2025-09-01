/*
 * Created on August 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;

import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.shared.constants.ConstantsTx;
import com.hkah.shared.constants.ConstantsVariable;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboDoctor extends ComboBoxShowKey {

	public ComboDoctor() {
		super();
	}

	public ComboDoctor(String source) {
		super(source);
	}

	public ComboDoctor(boolean showKey, String source) {
		super(showKey, source);
	}

	public ComboDoctor(boolean showKey, String source, boolean showKeyOnly) {
		super(showKey, source);
		setShowKeyOnly(showKeyOnly);
	}

	public ComboDoctor(boolean showKey, String source, boolean showKeyOnly, String displayFormat) {
		super(showKey, source);
		setDefaultDisplayFormat(displayFormat);
		setShowKeyOnly(showKeyOnly);
	}

	public ComboDoctor(TextReadOnly showTextPanel) {
		super();
		setShowTextPanel(showTextPanel);
	}

	@Override
	public void initContent(String source) {
		// initial combobox
		resetContent(ConstantsTx.DOCTOR_TXCODE, new String[] { source, ConstantsVariable.NO_VALUE });
	}
}