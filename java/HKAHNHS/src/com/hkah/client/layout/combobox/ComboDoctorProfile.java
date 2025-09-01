/*
 * Created on July 5, 2014
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.layout.combobox;

import com.hkah.shared.constants.ConstantsTx;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class ComboDoctorProfile extends ComboBoxShowKey {
	private String criteria = EMPTY_VALUE;
	private boolean loadTemplate = false;

	public ComboDoctorProfile(String criteria) {
		super(false, criteria);
		setMinListWidth(400);
	}

	@Override
	protected native String getTemplateScript() /*-{
		return [
			'<tpl for="."><div role="listitem" class="search-item">',
			'<b>{1}</b>&nbsp;{2}&nbsp;{3}',
			'</div></tpl>',
		].join("");
	}-*/;

	@Override
	public void initContent(String criteria) {
		// initial combobox
		resetContent(ConstantsTx.DOCTORPROFILE_TXCODE, new String[] {criteria});
	}
	
	public void checkTriggerBySearchKey() {
		// overriden by child class
	}
}