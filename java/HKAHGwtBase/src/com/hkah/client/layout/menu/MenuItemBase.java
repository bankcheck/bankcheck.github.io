package com.hkah.client.layout.menu;

import com.extjs.gxt.ui.client.GXT;
import com.extjs.gxt.ui.client.event.MenuEvent;
import com.extjs.gxt.ui.client.event.SelectionListener;
import com.extjs.gxt.ui.client.widget.menu.MenuItem;
import com.google.gwt.user.client.DOM;
import com.google.gwt.user.client.Element;
import com.google.gwt.user.client.ui.AbstractImagePrototype;
import com.google.gwt.user.client.ui.Accessibility;

public class MenuItemBase extends MenuItem {
	private boolean isActivate = false;
	/**
	 * Creates a new item.
	 */
	public MenuItemBase() {
		super();
	}

	/**
	 * Creates a new item with the given text.
	 *
	 * @param text the item's text
	 */
	public MenuItemBase(String text) {
		super(text);
	}

	/**
	 * Creates a new item.
	 *
	 * @param text the item's text
	 * @param icon the item's icon
	 */
	public MenuItemBase(String text, AbstractImagePrototype icon) {
		super(text, icon);
	}

	/**
	 * Creates a new item.
	 *
	 * @param text the item's text
	 * @param icon the item's icon
	 * @param listener the selection listener
	 */
	public MenuItemBase(String text, AbstractImagePrototype icon,
						SelectionListener<? extends MenuEvent> listener) {
		super(text, icon, listener);
	}

	/**
	 * Creates a new item.
	 *
	 * @param text the item text
	 * @param listener the selection listener
	 */
	public MenuItemBase(String text, SelectionListener<? extends MenuEvent> listener) {
		super(text, listener);
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
	}
}