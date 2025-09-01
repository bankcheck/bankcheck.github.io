package com.hkah.client.layout.panel;

import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Layout;
import com.extjs.gxt.ui.client.widget.LayoutContainer;
import com.extjs.gxt.ui.client.widget.layout.AbsoluteLayout;
import com.extjs.gxt.ui.client.widget.layout.FitLayout;
import com.extjs.gxt.ui.client.widget.layout.FlowLayout;
import com.google.gwt.user.client.Element;
import com.google.gwt.user.client.ui.Widget;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.event.CallbackListener;
import com.hkah.shared.constants.ConstantsUi;
import com.hkah.shared.model.PrinterInfo;
import com.hkah.shared.model.UserInfo;

public class BasePanel extends LayoutContainer {

	private MainFrame mainFrame = null;
	private String permissionName = null;

	@Override
	protected void onRender(Element parent, int index) {
		super.onRender(parent, index);
		Layout layout = null;
		if ("flow".equals(ConstantsUi.LAYOUT_BASEPANEL)) {
			layout = new FlowLayout();
		} else if ("absolute".equals(ConstantsUi.LAYOUT_BASEPANEL)) {
			layout = new AbsoluteLayout();
		} else if ("fit".equals(ConstantsUi.LAYOUT_BASEPANEL)) {
			layout = new FitLayout();
		}
		setLayout(layout);
	}

	/**
	 * this method will be called before the panel initial
	 * @return true if validation and authorization is okay
	 */
	public boolean preAction() {
		// do something for validation and authorization
		return true;
	}

	/**
	 * this method will be call after the panel initial
	 * @return void
	 */
	public void postAction() {
		// do nothing
	}

	/**
	 * this method will be call when the panel recall
	 * @return void
	 */
	public void rePostAction() {
		// do nothing
	}

	/**
	 * @return Returns the mainframe
	 */
	public MainFrame getMainFrame() {
		return mainFrame;
	}
	
	/**
	 * this method will be call when the panel is hidden
	 * @return void
	 */
	public void hideAction() {
		// do nothing
	}

	/**
	 * @param applet The mainFrame to set.
	 */
	public void setMainFrame(MainFrame mainFrame) {
		this.mainFrame = mainFrame;
	}

	/**
	 * @return Returns the userinfo.
	 */
	public UserInfo getUserInfo() {
		if (getMainFrame() != null && getMainFrame().getUserInfo() != null) {
			return getMainFrame().getUserInfo();
		} else {
			return Factory.getInstance().getUserInfo();
		}

	}
	
	public PrinterInfo getPrinterInfo() {	
		if (getMainFrame() != null && getMainFrame().getPrinterInfo() != null) {
			return getMainFrame().getPrinterInfo();
		} else {
			return null;
		}
	}

	/**
	 * this method will be called when user press ESC button
	 * @return true if the function is ready to exit
	 */
	public void performEscAction(CallbackListener callbackListener) {
		if (callbackListener != null) {
			callbackListener.handleRetBool(true, null, null);
		}
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

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	@Override
	public void setBounds(int x, int y, int width, int height) {
		setPosition(x, y);
		setSize(width, height);
	}
	
	@Override
	public void setLayout(Layout layout) {
		if (layout != null) {			
			super.setLayout(layout);
		}
	}

	public void setHeading(String text){
		if (text != null) {
			setBorders(true);
//			super.setHeading(text);
		}
	}

	public void setTitledBorder(){
		setBorders(true);
	}

	public void setEtchedBorder(){
		setBorders(true);
	}

	public void setLocation(int left, int top){
		setPosition(left, top);
	}

	@Override
	public boolean remove(Widget widget) {
		if (this.getItems().contains(widget)){			
			return super.remove(widget);
		} else {
			return false;
		}
	}

	/***************************************************************************
	 * Abstract Method for implement in Master Panel
	 **************************************************************************/

	/* >>> ~9~ Set Default First Focus Component ========================== <<< */
	public Component getDefaultFocusComponent() {
		return this;
	}
}