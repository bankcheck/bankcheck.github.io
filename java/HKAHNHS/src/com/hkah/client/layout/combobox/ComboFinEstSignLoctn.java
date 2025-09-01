/*
 * Created on August 4, 2008
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
public class ComboFinEstSignLoctn extends ComboBoxBase {



	public ComboFinEstSignLoctn() {
		super(false,false,true,true);
//		setItemSelector(".x-combo-listfixedheight-item");
//		setTemplate(getTemplateScript());
		initContent();
	}

//	protected native String getTemplateScript() /*-{
//	return [
//		'<tpl for="."><div role="listitem" class="x-combo-listfixedheight-item">',
//		'{1}',
//		'</div></tpl>',
//	].join("");
//}-*/;	
	
	public void initContent() {
		// initial combobox
		this.removeAllItems();
		resetContent("FINESTSIGNLOCTN");
	}
}