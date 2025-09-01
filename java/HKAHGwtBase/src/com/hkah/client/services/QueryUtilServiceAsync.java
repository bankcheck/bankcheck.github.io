package com.hkah.client.services;

import java.util.List;

import com.google.gwt.user.client.rpc.AsyncCallback;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.UserInfo;

/**
 * The async counterpart of <code>QueryUtil</code>.
 */
public interface QueryUtilServiceAsync {
	void executeComboBox(UserInfo userInfo, String moduleCode, String txCode, String[] inParam, AsyncCallback<MessageQueue> callback);

	void executeTx(UserInfo userInfo, String moduleCode, String txCode, String[] inParam, AsyncCallback<MessageQueue> callback);

	void executeMasterBrowse(UserInfo userInfo, String moduleCode, String txCode, String[] inParam, AsyncCallback<MessageQueue> callback);

	void executeMasterBrowse(UserInfo userInfo, String moduleCode, String txCode, String[] inParam,String jndiName, AsyncCallback<MessageQueue> callback);

	void executeMasterFetch(UserInfo userInfo, String moduleCode, String txCode, String[] inParam, AsyncCallback<MessageQueue> callback);

	void executeMasterAction(UserInfo userInfo, String moduleCode, String txCode, String actionType, String[] inParam, String structDescriptor, String[][] tableQueue, AsyncCallback<MessageQueue> callback);

	void executeMasterAction(UserInfo userInfo, String moduleCode, String txCode, String actionType, String[] inParam, String structDescriptor, String[][] tableQueue, String jndiName, AsyncCallback<MessageQueue> callback);
	
	void executeMasterAction(UserInfo userInfo, String moduleCode, String txCode, String actionType, String[] inParam, String[] structDescriptor, String[][][] tableQueue, AsyncCallback<MessageQueue> callback);
	
	void getQueryCols(String sqlQuery, AsyncCallback<List<String>> callback);
}
