package com.hkah.client.layout.dialog;

import java.util.HashMap;
import java.util.Map;

import com.extjs.gxt.ui.client.Style.HorizontalAlignment;
import com.extjs.gxt.ui.client.event.ButtonEvent;
import com.extjs.gxt.ui.client.event.ComponentEvent;
import com.extjs.gxt.ui.client.event.SelectionListener;
import com.extjs.gxt.ui.client.util.IconHelper;
import com.extjs.gxt.ui.client.util.KeyNav;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Dialog;
import com.extjs.gxt.ui.client.widget.Layout;
import com.extjs.gxt.ui.client.widget.button.Button;
import com.extjs.gxt.ui.client.widget.layout.AbsoluteLayout;
import com.google.gwt.user.client.Element;
import com.hkah.client.MainFrame;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.util.PanelUtil;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.PrinterInfo;
import com.hkah.shared.model.UserInfo;


public class DialogBase extends Dialog implements ConstantsVariable {

	private MainFrame mainFrame = null;
	private Map<String, String> param = null;
	private DialogBase thisDialog = this;

	protected SelectionListener<ButtonEvent> l = new SelectionListener<ButtonEvent>() {
		@Override
		public void componentSelected(ButtonEvent ce) {
			onButtonPressed(ce.getButton());
		}
	};

	public DialogBase() {
		init(null, null, -1, -1, true, null);
	}

	public DialogBase(Map<String, String> param) {
		super();
		init(null, null, -1, -1, true, param);
	}

	public DialogBase(MainFrame owner, boolean modal) {
		super();
		init(owner, null, -1, -1, modal, null);
	}

	public DialogBase(MainFrame owner, String buttonType) {
		super();
		init(owner, buttonType, -1, -1, true, null);
	}

	public DialogBase(MainFrame owner, int frameWidth, int frameHeight) {
		super();
		init(owner, null, frameWidth, frameHeight, true, null);
	}

	public DialogBase(MainFrame owner, String buttonType, boolean modal) {
		super();
		init(owner, buttonType, -1, -1, modal, null);
	}

	public DialogBase(MainFrame owner, String buttonType, int frameWidth, int frameHeight) {
		init(owner, buttonType, frameWidth, frameHeight, true, null);
	}

	public DialogBase(MainFrame owner, String buttonType, int frameWidth, int frameHeight, boolean modal) {
		init(owner, buttonType, frameWidth, frameHeight, true, null);
	}

	protected void init(MainFrame owner, String buttonType, int frameWidth, int frameHeight, boolean modal,
			Map<String, String> param) {
		mainFrame = owner;
		this.param = param;

		if (buttonType != null) {
			setButtons(buttonType);
			if (!OK.equals(buttonType)) {
				// no allow to click close button
				setClosable(false);
			}
		} else {
			getButtonBar().removeAll();
			setButtons(EMPTY_VALUE);
		}
		setButtonAlign(HorizontalAlignment.CENTER);
		setIcon(IconHelper.createStyle("user"));
		setBodyBorder(true);
		setBodyStyle("padding: 8px;background: none");
		setModal(true);
		setSize(frameWidth, frameHeight);
		setResizable(false);

		// focus
		setDefaultFocusComponent();
	}

	public PrinterInfo getPrinterInfo() {
		if (getMainFrame() != null && getMainFrame().getPrinterInfo() != null) {
			return getMainFrame().getPrinterInfo();
		} else {
			return null;
		}
	}

	public Component getDefaultFocusComponent() {
		return null;
	}

	protected void setDefaultFocusComponent() {
		// focus
		if (getDefaultFocusComponent() != null) {
			setFocusWidget(getDefaultFocusComponent());
		} else if (getButtonById(OK) != null) {
			setFocusWidget(getButtonById(OK));
		} else if (getButtonById(YES) != null) {
			setFocusWidget(getButtonById(YES));
		} else if (getButtonById(CANCEL) != null) {
			setFocusWidget(getButtonById(CANCEL));
		}
	}

	protected void setDefaultFocusComponent(Component component) {
		setFocusWidget(component);
	}

	public DialogBase getContentPane() {
		return this;
	}

	protected void setContentPane(BasePanel bp) {
		add(bp);
	}

	public void setTitle(String text) {
		setHeadingHtml(text);
	}

	public void setLocation(int x, int y) {
		setPagePosition(x, y);
	}

	public void dispose() {
		setVisible(false);
		onPreClose();
	}

	private void onPreClose() {
		onClose();
		Factory.getInstance().focusPanel(getMainFrame());
	}

	public void onClose() {}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	public void hide() {
		super.hide();
		onPreClose();
	}

	@Override
	protected void onHide() {
		super.onHide();
		onPreClose();
	}

	@Override
	protected void onRender(Element parent, int index) {
		super.onRender(parent, index);

		KeyNav<ComponentEvent> keyNav = new KeyNav<ComponentEvent>(this) {
			@Override
			public void handleEvent(ComponentEvent ce) {
//				ce.preventDefault();
				if (ce.isAltKey() && ce.getKeyCode() >= 65 && ce.getKeyCode() <= 90) {
					PanelUtil.getButton2Click(thisDialog, (char) ce.getKeyCode());
					PanelUtil.getButton2Click(thisDialog, thisDialog.getButtonBar(), (char) ce.getKeyCode());
				} else if (ce.isControlKey() && ce.getKeyCode() == 90) {
					hide();
				} else {
					otherHandleEvent(ce);
				}

				if (ce.getKeyCode() == 13) {
					enterEvent();
				}
				if (ce.getKeyCode() == 9 || ce.getKeyCode() == 37 || ce.getKeyCode() == 39) {
					TabAndArrowKeyEvent(ce);
				} 
			}
		};
	}

	// override in child class
	protected void otherHandleEvent(ComponentEvent ce) {}

	@Override
	public void setVisible(boolean visible) {
		super.setVisible(visible);

		if (visible) {
			setDefaultFocusComponent();
		}
	}

	/***************************************************************************
	 * Button Method
	 **************************************************************************/

	protected void createButtons() {
		getButtonBar().removeAll();
		setFocusWidget(null);
		if (getButtons().indexOf(OK) != -1) {
			ButtonBase okBtn = new ButtonBase();
			okBtn.setText(okText, 'O');
			okBtn.setItemId(OK);
			okBtn.addSelectionListener(l);
			setFocusWidget(okBtn);
			addButton(okBtn);
		}

		if (getButtons().indexOf(YES) != -1) {
			ButtonBase yesBtn = new ButtonBase();
			yesBtn.setText(yesText, 'Y');
			yesBtn.setItemId(YES);
			yesBtn.addSelectionListener(l);
			setFocusWidget(yesBtn);
			addButton(yesBtn);
		}

		if (getButtons().indexOf(NO) != -1) {
			ButtonBase noBtn = new ButtonBase();
			noBtn.setText(noText, 'N');
			noBtn.setItemId(NO);
			noBtn.addSelectionListener(l);
			setFocusWidget(noBtn);
			addButton(noBtn);
		}

		if (getButtons().indexOf(CANCEL) != -1) {
			ButtonBase cancelBtn = new ButtonBase();
			cancelBtn.setText(cancelText, 'C');
			cancelBtn.setItemId(CANCEL);
			cancelBtn.addSelectionListener(l);
			setFocusWidget(cancelBtn);
			addButton(cancelBtn);
		}

		if (getButtons().indexOf(CLOSE) != -1) {
			ButtonBase closeBtn = new ButtonBase();
			closeBtn.setText(closeText, 'C');
			closeBtn.setItemId(CLOSE);
			closeBtn.addSelectionListener(l);
			addButton(closeBtn);
		}
	}

	@Override
	public void onButtonPressed(Button button) {
		if (OK.equals(button.getItemId())) {
			doOkAction();
		} else if (CANCEL.equals(button.getItemId())) {
			doCancelAction();
		} else if (YES.equals(button.getItemId())) {
			doYesAction();
		} else if (NO.equals(button.getItemId())) {
			doNoAction();
		} else {
			super.onButtonPressed(button);
		}
	}

	@Override
	public ButtonBase getButtonById(String string) {
		return (ButtonBase) fbar.getItemByItemId(string);
	}

	/***************************************************************************
	 * Layout Method
	 **************************************************************************/

	@Override
	public void setLayout(Layout layout) {
		if (layout == null) {
			super.setLayout(new AbsoluteLayout());
		} else {
			super.setLayout(layout);
		}
	}

	/***************************************************************************
	 * Helper Method
	 **************************************************************************/

	public void addInformationMessage(String title, String content) {
		setTitle(title);
		addText(content);
	}

	public void addInformationMessage(String text) {
		addInformationMessage(EMPTY_VALUE, text);
	}

	protected void doOkAction() {
		// implement for child class
		dispose();
	}

	protected void doCancelAction() {
		// implement for child class
		dispose();
	}

	protected void doYesAction() {
		// implement for child class
		dispose();
	}

	protected void doNoAction() {
		// implement for child class
		dispose();
	}

	/***************************************************************************
	 * Other Method
	 **************************************************************************/

	protected UserInfo getUserInfo() {
		return mainFrame.getUserInfo();
	}

	protected MainFrame getMainFrame() {
		return mainFrame;
	}

	public String getParamValue(String key) {
		if (param == null) {
			return null;
		}
		return param.get(key);
	}

	public String setParamValue(String key, String value) {
		if (param == null) {
			param = new HashMap<String, String>();
		}
		return param.put(key, value);
	}

	public void clearParam() {
		if (param != null) {
			param.clear();
		}
	}

	public void enterEvent() {}
	
	public void TabAndArrowKeyEvent(ComponentEvent ce) {}

	public void setHeading(String value) {
		super.setHeadingHtml(value);
	}

	/***************************************************************************
	 * Store Value for Panel to Panel
	 **************************************************************************/

	public void setParameter(String key, String value) {
		Factory.getInstance().getValueObjectPerPanel().put(key, value);
	}

	public void resetParameter(String key) {
		Factory.getInstance().getValueObjectPerPanel().put(key, EMPTY_VALUE);
	}

	public String getParameter(String key) {
		return (String) Factory.getInstance().getValueObjectPerPanel().get(key);
	}

	/***************************************************************************
	 * Override Method
	 **************************************************************************/

	@Override
	protected void doFocus() {
		setDefaultFocusComponent();
		super.doFocus();
	}
}