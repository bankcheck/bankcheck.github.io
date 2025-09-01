package com.hkah.client.layout.button;

import com.extjs.gxt.ui.client.event.ButtonEvent;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.SelectionListener;
import com.extjs.gxt.ui.client.widget.button.Button;
import com.google.gwt.user.client.ui.AbstractImagePrototype;
import com.hkah.client.common.Factory;

public class ButtonBase extends Button {
	protected String permissionName = null;
	private char hotkey;
	private final static String UNDERSCORE_B4 = "<u>";
	private final static String UNDERSCORE_AT = "</u>";

	public ButtonBase() {
		super();
	}

	public ButtonBase(String text) {
		super(text);
	}

	public ButtonBase(String text, String permissionName) {
		super(text);
		setPermissionName(permissionName);
	}

	public ButtonBase(String text, SelectionListener<ButtonEvent> listener) {
		super(text, listener);
	}

	public ButtonBase(String text, SelectionListener<ButtonEvent> listener,
				String permissionName) {
		super(text, listener);
		setPermissionName(permissionName);
	}

	public ButtonBase(String text, AbstractImagePrototype icon, SelectionListener<ButtonEvent> listener) {
		this(text, icon, listener, true);
	}

	public ButtonBase(String text, AbstractImagePrototype icon,
						SelectionListener<ButtonEvent> listener,
						String permissionName) {
		this(text, icon, listener, true, permissionName);
	}

	public ButtonBase(String text, AbstractImagePrototype icon, SelectionListener<ButtonEvent> listener, boolean enable) {
		super(text, icon, listener);
		this.setEnabled(enable);
	}

	public ButtonBase(String text, AbstractImagePrototype icon,
						SelectionListener<ButtonEvent> listener, boolean enable,
						String permissionName) {
		super(text, icon, listener);
		this.setEnabled(enable);
		setPermissionName(permissionName);
	}

	@Override
	protected void onClick(ComponentEvent ce) {
		super.onClick(ce);
		onClick();
	}

	@Override
	protected void afterRender() {
	   super.afterRender();
	   if (!Factory.getInstance().checkPermission(getPermissionName())) {
		   hide();
	   }
	}

	public void onClick() {};

	public void setFocus(boolean isFocus) {
		// do nothing
		if (isFocus) {
//			setBackground(COLOR_BUTTON_FOCUSED_BACKGROUND);
//			setForeground(COLOR_BUTTON_FOCUSED_FOREGROUND);
		} else {
			if (isEnabled()) {
//				this.setBackground(COLOR_BUTTON_BACKGROUND);
//				this.setForeground(COLOR_BUTTON_FOREGROUND);
			} else {
//				this.setBackground(COLOR_BUTTON_DISABLED_BACKGROUND);
//				this.setForeground(COLOR_BUTTON_DISABLED_FOREGROUND);
			}
		}
	}

	@Override
	public void setBounds(int x, int y, int width, int height) {
		setPosition(x, y);
	    setSize(width, height);
	}

	public void setText(String text, char hotkey) {
		StringBuilder value = new StringBuilder();
		if (text != null) {
			setHotkey(hotkey);
			int index = text.indexOf(hotkey);
			value.append(text.substring(0, index));
			value.append(UNDERSCORE_B4);
			value.append(hotkey); 
			value.append(UNDERSCORE_AT);
			value.append(text.substring(index + 1));
		}
		super.setHtml(value.toString());
	}

	/**
	 * @return the permissionName
	 */
	public String getPermissionName() {
		return permissionName;
	}

	/**
	 * @param permissionName the permissionName to set
	 */
	public void setPermissionName(String permissionName) {
		this.permissionName = permissionName;
	}

	/**
	 * @return the hotkey
	 */
	public char getHotkey() {
		return hotkey;
	}

	/**
	 * @param hotkey the hotkey to set
	 */
	public void setHotkey(char hotkey) {
		if (hotkey >= 97 && hotkey <= 122) {
			this.hotkey = Character.toUpperCase(hotkey);
		} else {
			this.hotkey = hotkey;
		}
	}

	public String getText() {
		return super.getHtml();
	}
}