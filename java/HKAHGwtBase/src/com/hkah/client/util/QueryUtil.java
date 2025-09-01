package com.hkah.client.util;

import java.util.List;

import com.extjs.gxt.ui.client.Registry;
import com.google.gwt.core.client.GWT;
import com.google.gwt.http.client.RequestBuilder;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.google.gwt.user.client.rpc.RpcRequestBuilder;
import com.google.gwt.user.client.rpc.ServiceDefTarget;
import com.hkah.client.AbstractEntryPoint;
import com.hkah.client.layout.table.EditorTableList;
import com.hkah.client.services.QueryUtilServiceAsync;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;
import com.hkah.shared.model.UserInfo;

public class QueryUtil {
	public final static String ACTION_APPEND = "ADD";
	public final static String ACTION_MODIFY = "MOD";
	public final static String ACTION_DELETE = "DEL";
	public final static String ACTION_BROWSE = "LIS";
	public final static String ACTION_FETCH = "GET";
	public final static String SUB_ACTION_CANCEL = "CANCEL";
	public final static String SUB_ACTION_APPROVE = "APPROVE";
	public final static String SUB_ACTION_PREV = "PREV";
	private static QueryUtilServiceAsync async = null;

	private static QueryUtilServiceAsync getQueryUtilServiceAsync() {
		if (async == null) {
			async = Registry.get(AbstractEntryPoint.QUERYUTIL_SERVICE);
			ServiceDefTarget endpoint = (ServiceDefTarget) async;
			endpoint.setServiceEntryPoint(GWT.getModuleBaseURL() + "query-service");
			endpoint.setRpcRequestBuilder(new RpcRequestBuilder() {
				@Override
				protected RequestBuilder doCreate(String serviceEntryPoint) {
					RequestBuilder rb = super.doCreate(serviceEntryPoint);
					rb.setHeader("Connection", "close");
					return rb;
				}
			});
		}
		return async;
	}

	public static void executeComboBox(UserInfo userInfo, String txCode, MessageQueueCallBack callBack) {
		getQueryUtilServiceAsync().executeComboBox(userInfo, null, txCode, null, callBack);
	}

	public static void executeComboBox(UserInfo userInfo, String txCode, String[] inParam, MessageQueueCallBack callBack) {
		getQueryUtilServiceAsync().executeComboBox(userInfo, null, txCode, inParam, callBack);
	}

	public static void executeComboBox(UserInfo userInfo, String moduleCode, String txCode, MessageQueueCallBack callBack) {
		getQueryUtilServiceAsync().executeComboBox(userInfo, moduleCode, txCode, null, callBack);
	}

	public static void executeComboBox(UserInfo userInfo, String moduleCode, String txCode, String[] inParam, MessageQueueCallBack callBack) {
		getQueryUtilServiceAsync().executeComboBox(userInfo, moduleCode, txCode, inParam, callBack);
	}

	public static void executeTx(UserInfo userInfo, String txCode, MessageQueueCallBack callBack) {
		getQueryUtilServiceAsync().executeTx(userInfo, null, txCode, null, callBack);
	}

	public static void executeTx(UserInfo userInfo, String txCode, String[] inParam, MessageQueueCallBack callBack) {
		getQueryUtilServiceAsync().executeTx(userInfo, null, txCode, inParam, callBack);
	}

	public static void executeTx(UserInfo userInfo, String txCode, String[] inParam) {
		getQueryUtilServiceAsync().executeTx(userInfo, null, txCode, inParam, new MessageQueueCallBack(){
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				// TODO Auto-generated method stub
			}});
	}

	public static void executeTx(UserInfo userInfo, String moduleCode, String txCode, MessageQueueCallBack callBack) {
		getQueryUtilServiceAsync().executeTx(userInfo, moduleCode, txCode, null, callBack);
	}

	public static void executeTx(UserInfo userInfo, String moduleCode, String txCode, String[] inParam, MessageQueueCallBack callBack) {
		getQueryUtilServiceAsync().executeTx(userInfo, moduleCode, txCode, inParam, callBack);
	}

	public static void executeMasterBrowse(UserInfo userInfo, String txCode, String[] inParam, MessageQueueCallBack callBack) {
		getQueryUtilServiceAsync().executeMasterBrowse(userInfo, null, txCode, inParam, callBack);
	}

	public static void executeMasterBrowse(UserInfo userInfo, String moduleCode, String txCode, String[] inParam, MessageQueueCallBack callBack) {
		getQueryUtilServiceAsync().executeMasterBrowse(userInfo, moduleCode, txCode, inParam, callBack);
	}

	public static void executeMasterBrowse(UserInfo userInfo, String moduleCode,String jndiName, String txCode,
			String[] inParam, MessageQueueCallBack callBack) {
		getQueryUtilServiceAsync().executeMasterBrowse(userInfo, moduleCode, txCode, inParam, jndiName, callBack);
	}

	public static void executeMasterFetch(UserInfo userInfo, String txCode, String[] inParam, MessageQueueCallBack callBack) {
		getQueryUtilServiceAsync().executeMasterFetch(userInfo, null, txCode, inParam, callBack);
	}

	public static void executeMasterFetch(UserInfo userInfo, String moduleCode, String txCode, String[] inParam, MessageQueueCallBack callBack) {
		getQueryUtilServiceAsync().executeMasterFetch(userInfo, moduleCode, txCode, inParam, callBack);
	}

	public static void executeMasterAction(UserInfo userInfo, String txCode, String actionType, String[] inParam) {
		getQueryUtilServiceAsync().executeMasterAction(userInfo, null, txCode, actionType, inParam, new String[0], null, new MessageQueueCallBack(){
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				// TODO Auto-generated method stub
			}});
	}

	public static void executeMasterAction(UserInfo userInfo, String moduleCode, String txCode, String actionType, String[] inParam) {
		getQueryUtilServiceAsync().executeMasterAction(userInfo, moduleCode, txCode, actionType, inParam, new String[0], null, new MessageQueueCallBack(){
			@Override
			public void onPostSuccess(MessageQueue mQueue) {
				// TODO Auto-generated method stub
			}});
	}

	public static void executeMasterAction(UserInfo userInfo, String txCode, String actionType, String[] inParam, MessageQueueCallBack callBack) {
		getQueryUtilServiceAsync().executeMasterAction(userInfo, null, txCode, actionType, inParam, new String[0], null, callBack);
	}

	public static void executeMasterAction(UserInfo userInfo, String moduleCode, String txCode, String actionType, String[] inParam, MessageQueueCallBack callBack) {
		getQueryUtilServiceAsync().executeMasterAction(userInfo, moduleCode, txCode, actionType, inParam, new String[0], null, callBack);
	}

	public static void executeMasterAction(UserInfo userInfo, String moduleCode, String txCode, String actionType, String[] inParam, String jndiName, MessageQueueCallBack callBack) {
		getQueryUtilServiceAsync().executeMasterAction(userInfo, moduleCode, txCode, actionType, inParam, null, null, jndiName, callBack);
	}

	public static void executeMasterAction(UserInfo userInfo, String txCode, String actionType, String[] inParam, String[][] tableQueue, MessageQueueCallBack callBack) {
		getQueryUtilServiceAsync().executeMasterAction(userInfo, null, txCode, actionType, inParam, EditorTableList.DEFAULT_STRUCT_DESC_TABLE, tableQueue, callBack);
	}

	public static void executeMasterAction(UserInfo userInfo, String txCode, String actionType, String[] inParam, String structDescriptor, String[][] tableQueue, MessageQueueCallBack callBack) {
		getQueryUtilServiceAsync().executeMasterAction(userInfo, null, txCode, actionType, inParam, structDescriptor, tableQueue, callBack);
	}

	public static void executeMasterAction(UserInfo userInfo, String moduleCode, String txCode, String actionType, String[] inParam, String structDescriptor, String[][] tableQueue, MessageQueueCallBack callBack) {
		getQueryUtilServiceAsync().executeMasterAction(userInfo, moduleCode, txCode, actionType, inParam, structDescriptor, tableQueue, callBack);
	}

	// multi table
	public static void executeMasterAction(UserInfo userInfo, String txCode, String actionType, String[] inParam, String[] structDescriptors, String[][][] tableQueues, MessageQueueCallBack callBack) {
		getQueryUtilServiceAsync().executeMasterAction(userInfo, null, txCode, actionType, inParam, structDescriptors, tableQueues, callBack);
	}

	public static void executeMasterAction(UserInfo userInfo, String moduleCode, String txCode, String actionType, String[] inParam, String[] structDescriptors, String[][][] tableQueues, MessageQueueCallBack callBack) {
		getQueryUtilServiceAsync().executeMasterAction(userInfo, moduleCode, txCode, actionType, inParam, structDescriptors, tableQueues, callBack);
	}

	// sql statment util
	public static void getQueryCols(String sqlQuery, AsyncCallback<List<String>> callback) {
		getQueryUtilServiceAsync().getQueryCols(sqlQuery, callback);
	}
}