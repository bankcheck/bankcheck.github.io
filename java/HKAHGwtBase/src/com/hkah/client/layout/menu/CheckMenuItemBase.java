package com.hkah.client.layout.menu;

import com.extjs.gxt.ui.client.GXT;
import com.extjs.gxt.ui.client.widget.menu.CheckMenuItem;
import com.google.gwt.user.client.DOM;
import com.google.gwt.user.client.Element;
import com.google.gwt.user.client.ui.Accessibility;

public class CheckMenuItemBase extends CheckMenuItem {
	private String groupStyle = "x-menu-group-item";
	private boolean isActivate = false;
	/**
	 * Creates a new check menu item.
	 */
	public CheckMenuItemBase() {
		super();
	}

	/**
	 * Creates a new check menu item.
	 * 
	 * @param text the text
	 */
	public CheckMenuItemBase(String text) {
		super(text);
	}

	public void callActivate(boolean autoExpand) {
		activate(autoExpand);
	}

	@Override
	protected void activate(boolean autoExpand) {
		super.activate(autoExpand);
		isActivate = true;
	}

	public void callDeActivate() {
		deactivate();
	}

	@Override
	protected void deactivate() {
		super.deactivate();
		isActivate = false;
	}

	public boolean isActivate() {
		return isActivate;
	}

	public void setActivate(boolean isActivate) {
		this.isActivate = isActivate;
	}

	public void setText(String text) {
		super.setHtml(text);
	}

	public String getText() {
		return super.getHtml();
	}

	@Override
	protected void onRender(Element target, int index) {
//		super.onRender(target, index);

		// from MenuItemBase
		setElement(DOM.createAnchor(), target, index);

		if (GXT.isAriaEnabled()) {
			Accessibility.setRole(getElement(), Accessibility.ROLE_MENUITEM);
		} else {
			getElement().setPropertyString("href", "#");
		}

		String s = itemStyle + (subMenu != null ? " x-menu-item-arrow" : "");
		addStyleName(s);

		if (widget != null) {
			setWidget(widget);
		} else {
			setHtml(html);
		}

		if (subMenu != null) {
			Accessibility.setState(getElement(), "aria-haspopup", "true");
		}

		// from CheckMenuItem
		setChecked(isChecked(), true);
		if (GXT.isAriaEnabled()) {
			Accessibility.setRole(getElement(), "menuitemcheckbox");
		}

		if (getGroup() != null) {
			setGroupStyle(groupStyle);
		}
	}
}