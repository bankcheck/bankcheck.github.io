package com.hkah.client.layout.tips;

import com.extjs.gxt.ui.client.core.Template;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.tips.QuickTip;

public class CustomQTip extends QuickTip {
	
	public CustomQTip(Component component, boolean isKeepShowing) {
		super(component);
		getToolTipConfig().setTemplate(new Template(getTemplateScript()));
		if (isKeepShowing) {
			getToolTipConfig().setDismissDelay(0);
		}
	}
	
	protected native String getTemplateScript() /*-{
	return [
		'',
		'<p>{text}</p>',
		'',
	].join("");
}-*/;
}
