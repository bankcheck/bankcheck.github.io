/*
 * Created on July 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.util;

import java.util.List;

import com.extjs.gxt.ui.client.util.KeyNavListener;
import com.extjs.gxt.ui.client.widget.Component;
import com.extjs.gxt.ui.client.widget.Container;
import com.extjs.gxt.ui.client.widget.LayoutContainer;
import com.extjs.gxt.ui.client.widget.TabItem;
import com.extjs.gxt.ui.client.widget.TabPanel;
import com.extjs.gxt.ui.client.widget.button.ButtonBar;
import com.extjs.gxt.ui.client.widget.form.LabelField;
import com.extjs.gxt.ui.client.widget.form.NumberField;
import com.hkah.client.layout.ColumnLayout;
import com.hkah.client.layout.button.ButtonBase;
import com.hkah.client.layout.checkbox.CheckBoxBase;
import com.hkah.client.layout.combobox.ComboBoxBase;
import com.hkah.client.layout.combobox.PagingComboBoxBase;
import com.hkah.client.layout.dialog.DialogBase;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.layout.panel.TabbedPaneBase;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.layout.textfield.SearchTriggerField;
import com.hkah.client.layout.textfield.TextAreaBase;
import com.hkah.client.layout.textfield.TextBase;
import com.hkah.client.layout.textfield.TextDate;
import com.hkah.client.layout.textfield.TextDateTimeWithoutSecond;
import com.hkah.client.layout.textfield.TextDateTimeWithoutSecondWithCheckBox;
import com.hkah.client.layout.textfield.TextDateWithCheckBox;
import com.hkah.client.layout.textfield.TextNum;
import com.hkah.client.layout.textfield.TextReadOnly;
import com.hkah.shared.constants.ConstantsVariable;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class PanelUtil {

//	private static KeyListener keyDownListener = new KeyAdapter() {
//		public void keyReleased(KeyEvent e) {
//			Component comp = (Component) e.getSource();
//			if (e.getKeyCode() == KeyEvent.VK_DOWN
//					&& (!(comp.getParent() instanceof ComboBoxBase) || !((ComboBoxBase) comp.getParent()).isPopupVisible())) {
//				comp.transferFocus();
//			}
//		}
//	};
//
//	private static KeyListener keyEnterListener = new KeyAdapter() {
//		public void keyReleased(KeyEvent e) {
//			if (e.getKeyCode() == KeyEvent.VK_ENTER) {
//				Component comp = (Component) e.getSource();
//				comp.transferFocus();
//			}
//		}
//	};
//
//	public static Component getLastComponent(JComponent container) {
//		Component result = null;
//		int compCount = container.getComponentCount();
//
//		for (int i = compCount - 1; i >= 0 && result == null; i--) {
//			Component comp = container.getComponent(i);
//			if (comp.isVisible()) {
//				if ((comp instanceof TextBase
//						|| comp instanceof TextAreaBase || comp instanceof ComboBoxBase)
//						|| comp instanceof ButtonBase || comp instanceof RadioButtonBase
//						&& comp.isEnabled()) {
//					result = comp;
//				} else if (comp instanceof JPanel) {
//					result = getLastComponent((JPanel) comp);
//				} else if (comp instanceof JTabbedPane) {
//					result = getLastComponent((JComponent) ((JTabbedPane) comp).getSelectedComponent());
//				}
//			}
//		}
//		return result;
//	}
//
	public static void addLastFieldKeyListener(Component container, KeyNavListener keyListener) {
//		addLastFieldKeyListener(container, getLastComponent(container), keyListener);
	}

	public static void addLastFieldKeyListener(Component container, Component lastComp, KeyNavListener keyListener) {
//		removeAllFieldsKeyListener(container, keyListener);
//		if (lastComp != null) {
//			lastComp.addKeyListener(keyListener);
//		}
	}

	public static void initUpDownEnterKeyListener(Component container) {
//		initUpDownEnterKeyListener(container, getLastComponent(container));
	}

	public static void initUpDownEnterKeyListener(Component container, Component lastComp) {
//		setFlowKeyListener(container, lastComp, true);
//		if (lastComp != null) {
//			lastComp.removeKeyListener(keyDownListener);
//			lastComp.removeKeyListener(keyEnterListener);
//		}
	}

	public static void removeAllFieldsKeyListener(Component container, KeyNavListener keyListener) {
//		int compNum = container.getComponentCount();
//
//		for (int i = 0; i < compNum; i++) {
//			Component comp = container.getComponent(i);
//			if (!comp.isVisible() || !comp.isEnabled()) {
//				continue;
//			}
//
//			if (comp instanceof TextBase
//					|| comp instanceof TextAreaBase || comp instanceof ComboBoxBase
//					|| comp instanceof ButtonBase || comp instanceof RadioButtonBase) {
//				comp.removeKeyListener(keyListener);
//			} else if (comp instanceof JPanel) {
//				removeAllFieldsKeyListener((JPanel) comp, keyListener);
//			} else if (comp instanceof JTabbedPane) {
//				for (int j = ((JTabbedPane) comp).getComponentCount() - 1; j >= 0 ; j--) {
//					removeAllFieldsKeyListener((JComponent) ((JTabbedPane) comp).getComponentAt(j), keyListener);
//				}
//			}
//		}
	}

	public static void setFirstComponentFocus(LayoutContainer container) {
		Component comp = getFirstComponentFocusHelper(container);
		if (comp != null) {
			comp.focus();
		}
	}

	private static Component getFirstComponentFocusHelper(LayoutContainer container) {
		Component compFocus = null;

		for (Component comp : container.getItems()) {
			if (((comp instanceof TextBase && ((TextBase) comp).isEditable())
					|| (comp instanceof TextAreaBase && ((TextAreaBase) comp).isEditable())
					|| comp instanceof ComboBoxBase)
//					&& comp.isFocusable()
					&& comp.isVisible() && comp.isEnabled()) {
				compFocus = comp;
			} else if (comp instanceof BasePanel) {
				compFocus = getFirstComponentFocusHelper((BasePanel) comp);
			} else if (comp instanceof TabPanel) {
				for (TabItem ti :((TabPanel)comp).getItems()) {
					compFocus = getFirstComponentFocusHelper(ti);
				}
			}
		}
		return compFocus;
	}

	public static void setAllFieldsEditable(LayoutContainer container, boolean isEditable) {
		setAllFields(container, isEditable);
	}

	private static void setAllFields(LayoutContainer container, boolean isEditable) {
//		container.setVisible(isEnable);
		for (Component comp : container.getItems()) {
//			if (comp.isVisible()) {
				if (comp instanceof LayoutContainer) {
					if (comp != container)
						setAllFields((LayoutContainer)comp, isEditable);
//				} else if (comp instanceof JScrollPane) {
//					setAllFieldsEnabled(((JScrollPane) comp).getViewport(), isEnable);
//				} else if (comp instanceof JTabbedPane) {
//					for (int j = ((JTabbedPane) comp).getComponentCount() - 1; j >= 0 ; j--) {
//						setAllFieldsEnabled((JComponent) ((JTabbedPane) comp).getComponentAt(j), isEnable);
//					}
				} else if (comp instanceof TabPanel) {
					for (TabItem ti :((TabPanel)comp).getItems()) {
						setAllFields(ti, isEditable);
					}
				} else if (comp instanceof TextBase) {
					((TextBase) comp).setEditable(isEditable);
				} else if (comp instanceof TextNum) {
					((TextNum) comp).setEditable(isEditable);
				} else if (comp instanceof SearchTriggerField) {
					((SearchTriggerField) comp).setEditable(isEditable);
				} else if (comp instanceof TextAreaBase) {
					((TextAreaBase) comp).setEditable(isEditable);
				} else if (comp instanceof TextDate) {
					((TextDate) comp).setEditable(isEditable);
				} else if (comp instanceof TextDateWithCheckBox) {
					((TextDateWithCheckBox) comp).setEditable(isEditable);
				} else if (comp instanceof TextDateTimeWithoutSecond) {
					((TextDateTimeWithoutSecond) comp).setEditable(isEditable);
				} else if (comp instanceof TextDateTimeWithoutSecondWithCheckBox) {
					((TextDateTimeWithoutSecondWithCheckBox) comp).setEditable(isEditable);
				} else if (comp instanceof ComboBoxBase) {
					((ComboBoxBase) comp).setEditable(isEditable);
				} else if (comp instanceof CheckBoxBase) {
					((CheckBoxBase) comp).setEditable(isEditable);
				} else if (!(comp instanceof LabelField)) {
					comp.setEnabled(isEditable);
				}
//			}
		}
	}

	public static void setAllFieldsReadOnly(LayoutContainer container, boolean isReadOnly) {
		setAllFieldsReadOnly(container, isReadOnly, false);
	}

	public static void setAllFieldsReadOnly(LayoutContainer container, boolean isReadOnly, boolean overrideEditableForever) {
//		container.setVisible(isEnable);
		for (Component comp : container.getItems()) {
//			if (comp.isVisible()) {
				if (comp instanceof LayoutContainer) {
					if (comp != container) setAllFieldsReadOnly((LayoutContainer) comp, isReadOnly);
//				} else if (comp instanceof JScrollPane) {
//					setAllFieldsEnabled(((JScrollPane) comp).getViewport(), isEnable);
//				} else if (comp instanceof JTabbedPane) {
//					for (int j = ((JTabbedPane) comp).getComponentCount() - 1; j >= 0 ; j--) {
//						setAllFieldsEnabled((JComponent) ((JTabbedPane) comp).getComponentAt(j), isEnable);
//					}
				} else {
					setAllFieldsReadOnly(comp, isReadOnly, overrideEditableForever);
				}
//			}
		}
	}

	public static void setAllFieldsReadOnly(Component comp, boolean isReadOnly, boolean overrideEditableForever) {
		if (comp instanceof TabPanel) {
			for (TabItem ti :((TabPanel) comp).getItems()) {
				setAllFieldsReadOnly(ti, isReadOnly);
			}
		} else if (comp instanceof TextBase) {
			if (overrideEditableForever) ((TextBase) comp).setEditableForever(!isReadOnly);
			((TextBase) comp).setReadOnly(isReadOnly);
		} else if (comp instanceof TextNum) {
			if (overrideEditableForever) ((TextNum) comp).setEditableForever(!isReadOnly);
			((TextNum) comp).setReadOnly(isReadOnly);
		} else if (comp instanceof SearchTriggerField) {
			if (overrideEditableForever) ((SearchTriggerField) comp).setEditableForever(!isReadOnly);
			((SearchTriggerField) comp).setReadOnly(isReadOnly);
		} else if (comp instanceof TextAreaBase) {
			if (overrideEditableForever) ((TextAreaBase) comp).setEditableForever(!isReadOnly);
			((TextAreaBase) comp).setReadOnly(isReadOnly);
		} else if (comp instanceof TextDate) {
			if (overrideEditableForever) ((TextDate) comp).setEditableForever(!isReadOnly);
			((TextDate) comp).setReadOnly(isReadOnly);
		} else if (comp instanceof TextDateWithCheckBox) {
			if (overrideEditableForever) ((TextDateWithCheckBox) comp).getDateField().setEditableForever(!isReadOnly);
			((TextDateWithCheckBox) comp).setReadOnly(isReadOnly);
		} else if (comp instanceof TextDateTimeWithoutSecond) {
			if (overrideEditableForever) ((TextDateTimeWithoutSecond) comp).setEditableForever(!isReadOnly);
			((TextDateTimeWithoutSecond) comp).setReadOnly(isReadOnly);
		} else if (comp instanceof TextDateTimeWithoutSecondWithCheckBox) {
			if (overrideEditableForever) ((TextDateTimeWithoutSecondWithCheckBox) comp).getDateField().setEditableForever(!isReadOnly);
			((TextDateTimeWithoutSecondWithCheckBox) comp).setReadOnly(isReadOnly);
		} else if (comp instanceof ComboBoxBase) {
			if (overrideEditableForever) ((ComboBoxBase) comp).setEditableForever(!isReadOnly);
			((ComboBoxBase) comp).setReadOnly(isReadOnly);
		} else if (comp instanceof PagingComboBoxBase) {
			if (overrideEditableForever) ((PagingComboBoxBase) comp).setEditableForever(!isReadOnly);
			((PagingComboBoxBase) comp).setReadOnly(isReadOnly);
		} else if (comp instanceof CheckBoxBase) {
			if (overrideEditableForever) ((CheckBoxBase) comp).setEditableForever(!isReadOnly);
			((CheckBoxBase) comp).setReadOnly(isReadOnly);
		} else if (!(comp instanceof LabelField)) {
			//comp.setReadOnly(isReadOnly);
		}
	}

	public static void setFieldsVisible(LayoutContainer container, String fieldName, boolean isVisible) {
		for (Component comp : container.getItems()) {
//			if (fieldName == null || fieldName.equals(comp.getName())) {
//				comp.setVisible(isVisible);
//			}
//
//			if (comp instanceof JPanel) {
//				setFieldsVisible((JPanel) comp, fieldName, isVisible);
//			} else if (comp instanceof JScrollPane) {
//				setFieldsVisible(((JScrollPane) comp).getViewport(), fieldName, isVisible);
//			} else if (comp instanceof JTabbedPane) {
//				for (int j = ((JTabbedPane) comp).getComponentCount() - 1; j >= 0 ; j--) {
//					setFieldsVisible((JComponent) ((JTabbedPane) comp).getComponentAt(j), fieldName, isVisible);
//				}
//			}
		}
	}

	public static void resetAllFieldsStatus(LayoutContainer container) {
//		for (Component comp : container.getItems()) {
//			if (comp instanceof TextBase) {
//				((TextBase) comp).setErrorField(false);
//			} else if (comp instanceof TextAreaBase) {
//				((TextAreaBase) comp).setErrorField(false);
//			} else if (comp instanceof TextNum) {
//				((TextNum) comp).setErrorField(false);
//			} else if (comp instanceof TextDate) {
//				((TextDate) comp).setErrorField(false);
//			} else if (comp instanceof ComboBoxBase) {
//				((ComboBoxBase) comp).setErrorField(false);
//			} else if (comp instanceof SearchTriggerField) {
//				((SearchTriggerField) comp).setErrorField(false);
//			} else if (comp instanceof BasePanel) {
//				resetAllFieldsStatus((BasePanel) comp);
//			}
//		}
	}

	public static void resetAllTabbedPanelFields(TabbedPaneBase tabbedPanel) {
		for (TabItem container : tabbedPanel.getItems()) {
			for (Component comp : container.getItems()) {
				if (comp instanceof TextReadOnly) {
					if (((TextReadOnly) comp).isAllowReset()) {
						((TextReadOnly) comp).setText(ConstantsVariable.EMPTY_VALUE);
					}
				} else if (comp instanceof TextBase){
					((TextBase) comp).resetText();
					((TextBase) comp).setErrorField(false);
				} else if (comp instanceof TextNum){
					((TextNum) comp).resetText();
					((TextNum) comp).setErrorField(false);
				} else if (comp instanceof TextAreaBase) {
					((TextAreaBase) comp).setText(ConstantsVariable.EMPTY_VALUE);
					//((TextAreaBase) comp).setErrorField(false);
//				} else if (comp instanceof TextWithButton) {
//					((TextWithButton) comp).resetText();
//					((TextWithButton) comp).setErrorField(false);
				} else if (comp instanceof ComboBoxBase) {
					//if (((ComboBoxBase) comp).getItemCount() > 0) {
						((ComboBoxBase) comp).setSelectedIndex(0);
					//}
					((ComboBoxBase) comp).setErrorField(false);
				} else if (comp instanceof BasePanel) {
					resetAllFields((BasePanel) comp);
				}
			}
		}
	}
	public static void resetColumnLayoutAllFields(ColumnLayout container) {
		for (Component comp : container.getItems()) {
			if (comp instanceof LayoutContainer) {
				resetAllFields((LayoutContainer) comp);
			}
		}
	}

	public static void resetAllFields(LayoutContainer container) {
		if (container == null) {
			// return if container is null
			return;
		}
		for (Component comp : container.getItems()) {
			if (comp instanceof TextReadOnly) {
				if (((TextReadOnly) comp).isAllowReset()) {
					((TextReadOnly) comp).setText(ConstantsVariable.EMPTY_VALUE);
				}
			} else if (comp instanceof TextBase){
				((TextBase) comp).resetText();
				((TextBase) comp).setErrorField(false);
			} else if (comp instanceof TextNum){
				((TextNum) comp).resetText();
				((TextNum) comp).setErrorField(false);
			} else if (comp instanceof TextAreaBase) {
				((TextAreaBase) comp).setText(ConstantsVariable.EMPTY_VALUE);
				//((TextAreaBase) comp).setErrorField(false);
//			} else if (comp instanceof TextWithButton) {
//				((TextWithButton) comp).resetText();
//				((TextWithButton) comp).setErrorField(false);
			} else if (comp instanceof ComboBoxBase) {
				((ComboBoxBase) comp).resetText();
				((ComboBoxBase) comp).setErrorField(false);
			} else if (comp instanceof PagingComboBoxBase) {
				((PagingComboBoxBase) comp).setText(ConstantsVariable.EMPTY_VALUE);
				((PagingComboBoxBase) comp).setErrorField(false);
			} else if(comp instanceof CheckBoxBase){
				((CheckBoxBase)comp).setSelected(false);
			} else if (comp instanceof TextDate) {
				((TextDate) comp).resetText();
			} else if (comp instanceof TextDateWithCheckBox) {
				((TextDateWithCheckBox) comp).resetText();
			} else if (comp instanceof TextDateTimeWithoutSecond) {
				((TextDateTimeWithoutSecond) comp).resetText();
			} else if (comp instanceof TextDateTimeWithoutSecondWithCheckBox) {
				((TextDateTimeWithoutSecondWithCheckBox) comp).resetText();
			} else if (comp instanceof NumberField) {
				((NumberField) comp).setValue(null);
			} else if (comp instanceof TableList) {
				((TableList) comp).removeAllRow();
			} else if (comp instanceof LayoutContainer) {
				if (comp != container)
					resetAllFields((LayoutContainer) comp);
			} else if (comp instanceof TabbedPaneBase) {
				resetAllTabbedPanelFields((TabbedPaneBase)comp);
			} else if (comp instanceof SearchTriggerField) {
				((SearchTriggerField) comp).resetText();
				((SearchTriggerField) comp).setErrorField(false);
			}
		}
	}

	/**
	 * The Following Code tries to initialize the Focus Travesal Sequence
	 * according to the getComponent() Sequence.
	 */
	private static void setFlowKeyListener(LayoutContainer container, final Component lastComp, boolean isEnterAcceptable) {
//		Component comp = null;
//		Component nextTmp = lastComp;
		for (Component comp : container.getItems()) {
//			if (!comp.isVisible() || !comp.isEnabled()) {
//				continue;
//			}
//
//			if (comp instanceof TextBase
//					|| comp instanceof TextAreaBase || comp instanceof ComboBoxBase
//				|| comp instanceof ButtonBase || comp instanceof RadioButtonBase) {
//				if (comp != lastComp) {
//					setComponentKeyListener(comp, nextTmp, isEnterAcceptable);
//					nextTmp = comp;
//				}
//			} else if (comp instanceof TextWithButton) {
//				if (comp != lastComp) {
//					comp = ((TextWithButton) comp).requestFocusField();
//					setComponentKeyListener(comp, nextTmp, isEnterAcceptable);
//					nextTmp = comp;
//				}
//			} else if (comp instanceof JPanel) {
//				setFlowKeyListener((JComponent) comp, lastComp, isEnterAcceptable);
//			} else if (comp instanceof JTabbedPane) {
//				for (int j = ((JTabbedPane) comp).getComponentCount() - 1; j >= 0 ; j--) {
//					setFlowKeyListener((JComponent) ((JTabbedPane) comp).getComponentAt(j), lastComp, isEnterAcceptable);
//				}
//			}
		}
	}

//	private static void setComponentKeyListener(final Component currComponent, final Component nextComponent, boolean isEnterAcceptable) {
//		if (isEnterAcceptable) {
//			currComponent.addKeyListener(new KeyAdapter() {
//				public void keyReleased(KeyEvent e) {
//					if (e.getKeyCode() == KeyEvent.VK_ENTER) {
//						nextComponent.requestFocus();
//					}
//				}
//			});
//		}
//		currComponent.addKeyListener(new KeyAdapter() {
//			public void keyReleased(KeyEvent e) {
//				if (e.getKeyCode() == KeyEvent.VK_DOWN
//						&& (!(currComponent instanceof ComboBoxBase) || !((ComboBoxBase) currComponent).isPopupVisible())) {
//					nextComponent.requestFocus();
//				}
//			}
//		});
//		nextComponent.addKeyListener(new KeyAdapter() {
//			public void keyReleased(KeyEvent e) {
//				if (e.getKeyCode() == KeyEvent.VK_UP
//						&& (!(nextComponent instanceof ComboBoxBase) || !((ComboBoxBase) nextComponent).isPopupVisible())) {
//					currComponent.requestFocus();
//				}
//			}
//		});
//	}

	/*
	 * Enhance Container method getItemByItemId to search item by itemId recursively
	 */
	public static Object getItemByItemIdR(Container container, String itemId) {
		if (container == null)
			return null;

		Component item = container.getItemByItemId(itemId);
		if (item == null) {
			List items = container.getItems();
			for (Object obj : items) {
				if (obj instanceof Container) {
					Object ret = getItemByItemIdR((Container) obj, itemId);
					if (ret != null) {
						return ret;
					}
				}
			}
			return null;
		} else {
			return item;
		}
	}

	/*
	 * search button for hotkey
	 */
	public static void getButton2Click(LayoutContainer container, char hotkey) {
		if (container == null)
			return;

		for (Component comp : container.getItems()) {
			if (comp instanceof ButtonBase
					&& ((ButtonBase) comp).isEnabled()
					&& hotkey == ((ButtonBase) comp).getHotkey()) {
				((ButtonBase) comp).onClick();
				break;
			}
			else if (comp instanceof TabPanel && comp != container) {
				getButton2Click((LayoutContainer)((TabPanel) comp).getSelectedItem(), hotkey);
			}
			else if (comp instanceof LayoutContainer && comp != container) {
				getButton2Click((LayoutContainer) comp, hotkey);
			}
		}
	}

	/*
	 * search button for hotkey
	 */
	public static void getButton2Click(DialogBase dialog, ButtonBar container, char hotkey) {
		if (container == null)
			return;

		for (Component comp : container.getItems()) {
			if (comp instanceof ButtonBase
					&& ((ButtonBase) comp).isEnabled()
					&& hotkey == ((ButtonBase) comp).getHotkey()) {
						dialog.onButtonPressed(((ButtonBase) comp));
			} else if (comp instanceof LayoutContainer) {
				if (comp != container) {
					getButton2Click(dialog, (ButtonBar) comp, hotkey);
				}
			}
		}
	}
}