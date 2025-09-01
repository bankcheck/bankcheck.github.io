/*
 * Created on July 3, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.common;

import java.util.Map;

import com.hkah.client.MainFrame;
import com.hkah.client.layout.panel.BasePanel;
import com.hkah.client.util.CommonUtil;
import com.hkah.client.util.QueryUtil;
import com.hkah.shared.constants.ConstantsKey;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class Factory extends FactoryBase {

	// variable
	private static Factory factory = null;
	private static Integer[] functionKeys = new Integer[] {
													ConstantsKey.ALT_KEY,
													ConstantsKey.CTRL_KEY,
													ConstantsKey.SHIFT_KEY,
													ConstantsKey.F1_KEY,
													ConstantsKey.F2_KEY,
													ConstantsKey.F3_KEY,
													ConstantsKey.F4_KEY,
													ConstantsKey.F5_KEY,
													ConstantsKey.F6_KEY,
													ConstantsKey.F7_KEY,
													ConstantsKey.F8_KEY,
													ConstantsKey.F9_KEY,
													ConstantsKey.F10_KEY,
													ConstantsKey.F11_KEY,
													ConstantsKey.F12_KEY
											};

	// hidden constructor
	private Factory() {
		super();
	}

	public static Factory getInstance() {
		if (factory == null) {
			factory = new Factory();
		}
		return factory;
	}

	public void showPanel2(MainFrame mainFrame, BasePanel panel, boolean keepPanel,
			BasePanel oldPanel, boolean isOldPanel) {
		super.showPanel2(mainFrame, panel, keepPanel, oldPanel, isOldPanel);

		// refresh menu enable/disable
		refreshMenuBarStatus();
	}

	private void refreshMenuBarStatus() {
		getMainFrame().refreshMenuBarStatus();
	}

	public String getSysParameter(String parcde) {
		return getMainFrame().getSysParameter(parcde);
	}

	public boolean isDisableFunction(String fscKey) {
		return getMainFrame().isDisableFunction(fscKey);
	}

	public boolean isDisableFunction(String fscKey, String fscParent) {
		return getMainFrame().isDisableFunction(fscKey, fscParent);
	}

	public boolean isFunctionKey(int keyCode) {
		for (Integer key : functionKeys) {
			if (key == keyCode) {
				return true;
			}
		}
		return false;
	}

	public void addRequiredReportDesc(Map map, String[] type, String[] id, String lang) {
		for (int i = 0; i < type.length; i++) {
			String desc = getMainFrame().getRptDescMap(type[i].toUpperCase()+"_"+id[i].toUpperCase()+"_"+lang.toUpperCase());
			map.put(id[i], desc);
		}
	}

	public String getPhotoIsNotAvilableImg() {
		return "http://" +  getMainFrame().getSysParameter("ptIgUrlSte") + "/hats/images/Photo Not Available.jpg";
	}

	public String getCurrentSteCode() {
		return getMainFrame().getCurrentSteCode();
	}

	public void writeLog(String module, String logAction, String remark) {
		writeLog(module, logAction, remark, null);
	}

	public void writeLog(String module, String logAction, String remark, String userID) {
		QueryUtil.executeMasterAction(getUserInfo(), "SysLog", QueryUtil.ACTION_APPEND,
				new String[] {
					module, logAction, remark, (userID == null ? getUserInfo().getUserID() : userID), CommonUtil.getComputerName()
				},
				Factory.getInstance().getSyslogCallBack());
	}
}