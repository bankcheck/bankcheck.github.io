package com.hkah.server.services;

import java.util.List;

import javax.servlet.http.HttpSession;

import com.google.gwt.user.server.rpc.RemoteServiceServlet;
import com.hkah.client.services.QueryUtilService;
import com.hkah.server.util.QueryUtil;
import com.hkah.server.util.SqlParserUtil;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.UserInfo;

/**
 * The server side implementation of the RPC service.
 */
@SuppressWarnings("serial")
public class QueryUtilServiceImpl extends RemoteServiceServlet implements QueryUtilService, ConstantsVariable {

    /**
	 * Get the current UserInfo
	 * @param userInfo
	 * @return        The current UserInfo
	 */
    public UserInfo getCurrentUserInfo() {
    	return (UserInfo)getSession().getAttribute("UserInfo");
    }

	 /**
	 * set the current UserInfo
	 * @param UserInfo userInfo
	 * @return        void
	 */
    public void setCurrentUserInfo(UserInfo userInfo) {
    	getSession().setAttribute("UserInfo", userInfo);
    }

	/**
	 * Returns the current session
	 *
	 * @return  The current Session
	 */
	 private HttpSession getSession() {
		 // Get the current request and then return its session
		 return this.getThreadLocalRequest().getSession();
	 }

	@Override
	public MessageQueue executeComboBox(UserInfo userInfo, String moduleCode, String txCode, String[] inParam) {
		return QueryUtil.proceedTx(userInfo, moduleCode, txCode, QueryUtil.getMasterServlet(), QueryUtil.ACTION_COMBOBOX, inParam, new String[0], null);
	}

	@Override
	public MessageQueue executeTx(UserInfo userInfo, String moduleCode, String txCode, String[] inParam) {
		return QueryUtil.proceedTx(userInfo, moduleCode, txCode, QueryUtil.getTxServlet(), null, inParam, new String[0], null);
	}

	@Override
	public MessageQueue executeMasterBrowse(UserInfo userInfo, String moduleCode, String txCode, String[] inParam) {
		return QueryUtil.proceedTx(userInfo, moduleCode, txCode, QueryUtil.getMasterServlet(), QueryUtil.ACTION_BROWSE, inParam, new String[0], null);
	}

	public MessageQueue executeMasterBrowse(UserInfo userInfo,
			String moduleCode, String txCode, String[] inParam, String jndiName) {
		return QueryUtil.proceedTx(userInfo, moduleCode, txCode, 
				QueryUtil.getMasterServlet(), QueryUtil.ACTION_BROWSE, inParam, null, null, jndiName);
	}

	@Override
	public MessageQueue executeMasterFetch(UserInfo userInfo, String moduleCode, String txCode, String[] inParam) {
		return QueryUtil.proceedTx(userInfo, moduleCode, txCode, QueryUtil.getMasterServlet(), QueryUtil.ACTION_FETCH, inParam, new String[0], null);
	}

	@Override
	public MessageQueue executeMasterAction(UserInfo userInfo, String moduleCode, String txCode, String actionType, String[] inParam, String structDescriptor, String[][] tableQueue) {
		return QueryUtil.proceedTx(userInfo, moduleCode, txCode, QueryUtil.getMasterServlet(), actionType, inParam, structDescriptor, tableQueue);
	}

	@Override
	public MessageQueue executeMasterAction(UserInfo userInfo, String moduleCode, String txCode, String actionType, String[] inParam, String structDescriptor, String[][] tableQueue, String jndiName) {
		return QueryUtil.proceedTx(userInfo, moduleCode, txCode, QueryUtil.getMasterServlet(), actionType, inParam, structDescriptor, tableQueue, jndiName);
	}

	@Override
	public MessageQueue executeMasterAction(UserInfo userInfo, String moduleCode, String txCode, String actionType, String[] inParam, String[] structDescriptors, String[][][] tableQueues) {
		return QueryUtil.proceedTx(userInfo, moduleCode, txCode, QueryUtil.getMasterServlet(), actionType, inParam, structDescriptors, tableQueues);
	}

	@Override
	public List<String> getQueryCols(String sqlQuery) {
		return SqlParserUtil.getSqlColsDbOracle(sqlQuery);
	}
}