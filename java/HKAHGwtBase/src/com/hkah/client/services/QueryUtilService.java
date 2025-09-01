/*
 * Created on July 4, 2008
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.client.services;

import java.util.List;

import com.google.gwt.user.client.rpc.RemoteService;
import com.google.gwt.user.client.rpc.RemoteServiceRelativePath;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.UserInfo;

/**
 * The client side stub for the RPC service.
 */
@RemoteServiceRelativePath("query-service")
public interface QueryUtilService extends RemoteService {
	public MessageQueue executeComboBox(UserInfo userInfo, String moduleCode, String txCode, String[] inParam);

	public MessageQueue executeTx(UserInfo userInfo, String moduleCode, String txCode, String[] inParam);

	public MessageQueue executeMasterBrowse(UserInfo userInfo, String moduleCode, String txCode, String[] inParam);

	public MessageQueue executeMasterBrowse(UserInfo userInfo, String moduleCode, String txCode, String[] inParam,String jndiName);

	public MessageQueue executeMasterFetch(UserInfo userInfo, String moduleCode, String txCode, String[] inParam);

	public MessageQueue executeMasterAction(UserInfo userInfo, String moduleCode, String txCode, String actionType, String[] inParam, String structDescriptor, String[][] tableQueue);

	public MessageQueue executeMasterAction(UserInfo userInfo, String moduleCode, String txCode, String actionType, String[] inParam, String structDescriptor, String[][] tableQueue, String jndiName);
	
	public MessageQueue executeMasterAction(UserInfo userInfo, String moduleCode, String txCode, String actionType, String[] inParam, String[] structDescriptors, String[][][] tableQueues);
	
	public List<String> getQueryCols(String sqlQuery);
}