package com.hkah.server.util;

import java.io.IOException;

import org.apache.log4j.Logger;

import com.hkah.client.util.TextUtil;
import com.hkah.server.config.ClientConfig;
import com.hkah.shared.constants.ConstantsVariable;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.UserInfo;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
public class QueryUtil implements ConstantsVariable {
	private final static String INVALID_TXCODE_VALUE = "Invalid Input : Please input Tx Code ";
	private final static String URL1_VALUE = "://";
	private final static String URL2_VALUE = ":";
	private final static String URL3_VALUE = "/";
	private final static String QUERYSTR_VALUE = "queryStr: ";
	private final static String INPARAMSTR_VALUE = "inParamStr: ";
	private final static String INPUT_VALUE = ">>> ";
	private final static String OUTPUT_VALUE = "<<< ";
	private final static String TABLEQUEUE_VALUE = "tableQueue: ";
	private final static String QUOTA1_VALUE = "[";
	private final static String QUOTA2_VALUE = "]";

	public final static String ACTION_APPEND = "ADD";
	public final static String ACTION_MODIFY = "MOD";
	public final static String ACTION_DELETE = "DEL";
	public final static String ACTION_BROWSE = "LIS";
	public final static String ACTION_FETCH = "GET";
	public final static String ACTION_COMBOBOX = "CMB";
	public final static String SUB_ACTION_CANCEL = "CANCEL";

	private static String memHost = null;
	private static String memPort = null;
	private static String memProtocol = null;
	private static String memContextRoot = null;

	private static String memModuleCode = null;
	private static String memTxServlet = null;
	private static String memTxMasterServlet = null;
	private static String memJndiName = null;
	private static String memVersionNumber = null;

	protected static Logger logger = Logger.getLogger(QueryUtil.class);

	private static String getModuleCode() {
		if (memModuleCode == null) {
			memModuleCode = ClientConfig.getObject().getModuleCode();
		}
		return memModuleCode;
	}

	public static String getTxServlet() {
		if (memTxServlet == null) {
			memTxServlet = ClientConfig.getObject().getTxServlet();
		}
		return memTxServlet;
	}

	public static String getMasterServlet() {
		if (memTxMasterServlet == null) {
			memTxMasterServlet = ClientConfig.getObject().getMasterServlet();
		}
		return memTxMasterServlet;
	}

	public static String getJndiName() {
		if (memJndiName == null) {
			memJndiName = ClientConfig.getObject().getJndiName();
		}
		return memJndiName;
	}

	public static String setJndiName(String jndiName) {
		if (memJndiName == null) {
			memJndiName = jndiName;
		}
		return memJndiName;
	}

	public static String getConfigJndiName() {
		return ClientConfig.getObject().getJndiName();
	}

	public static String getVersionNumber() {
		if (memVersionNumber == null) {
			memVersionNumber = ClientConfig.getObject().getVersionNo();
		}
		return memVersionNumber;
	}

	public static MessageQueue executeTx(UserInfo userInfo, String moduleCode, String txCode, String[] inParam) {
		return proceedTx(userInfo, moduleCode, txCode, getTxServlet(), null, inParam, new String[0], null);
	}

	public static MessageQueue executeTx(UserInfo userInfo, String moduleCode, String txCode, String[] inParam, String directDB) {
		return proceedTx(userInfo, moduleCode, txCode, getTxServlet(), null, inParam, null, null, directDB);
	}

	public static MessageQueue proceedTx(UserInfo userInfo, String moduleCode, String txCode, String servletName, String actionType, String[] inParam, String structDescriptor, String[][] tableQueue) {
		if (txCode != null) {
			return proceedTxHelper(userInfo, moduleCode, txCode, servletName, actionType, inParam, structDescriptor, tableQueue, null);
		} else {
			logger.error(INVALID_TXCODE_VALUE);
			return null;
		}
	}

	public static MessageQueue proceedTx(UserInfo userInfo, String moduleCode, String txCode, String servletName, String actionType, String[] inParam, String[] structDescriptors, String[][][] tableQueues) {
		if (txCode != null) {
			return proceedTxHelper(userInfo, moduleCode, txCode, servletName, actionType, inParam, structDescriptors, tableQueues, null);
		} else {
			logger.error(INVALID_TXCODE_VALUE);
			return null;
		}
	}

	public static MessageQueue proceedTx(UserInfo userInfo, String moduleCode, String txCode, String servletName,
			String actionType, String[] inParam, String structDescriptor, String[][] tableQueue,String directDB) {
		//setJndiName(directDB);	// This will affect other query jndi
		if (txCode != null) {
			return proceedTxHelper(userInfo, moduleCode, txCode, servletName,
					actionType, inParam, structDescriptor, tableQueue, directDB);
		} else {
			logger.error(INVALID_TXCODE_VALUE);
			return null;
		}
	}

	private static MessageQueue proceedTxHelper(UserInfo userInfo, String moduleCode, String txCode, String servletName, String actionType, String[] inParam, String structDescriptor, String[][] tableQueue, String jndiName) {
		if (tableQueue != null) {
			return proceedTxHelper(userInfo, moduleCode, txCode, servletName, actionType, inParam, new String[]{structDescriptor}, new String[][][]{tableQueue}, jndiName);
		} else {
			return proceedTxHelper(userInfo, moduleCode, txCode, servletName, actionType, inParam, new String[]{structDescriptor}, null, jndiName);
		}
	}

	private static MessageQueue proceedTxHelper(UserInfo userInfo, String moduleCode, String txCode, String servletName, String actionType, String[] inParam, String[] structDescriptors, String[][][] tableQueues, String jndiName) {
		MessageQueue result = null;

		try {
			result = new MessageQueue(connectServer2Server(userInfo, moduleCode, servletName, txCode, actionType, inParam, structDescriptors, tableQueues, jndiName), true);

			if (result.success()) {
				if (result.getContentLineCount() > 1000) {
					logger.error("too many records (" + result.getContentLineCount() + ") @ (" + txCode + ")");
				}
			} else {
				logger.error(result.getReturnMsg());
				try {
					if (Integer.parseInt(result.getReturnCode().trim()) == -999) {
						String errString = "Error : " + result.getReturnCode() + " " + result.getReturnMsg();
						if (errString.indexOf("Database") < 0) {
							logger.error("Database error!!! \n" + errString);
						} else {
							logger.error("Fatal Error!!!" + errString);
						}
					}
				} catch (Exception e) {
					logger.error(e);
				}
			}
		} catch (Exception e) {
			logger.error(e);
			if (result != null) {
				logger.error("output queue:[" + result.getText() + "]");
			}
			e.printStackTrace();
		}
		return result;
	}

	/**
	 * send queue to servlet
	 */
	private static String connectServer2Server(UserInfo userInfo, String moduleCode, String servletName, String txCode, String actionType, String[] inParam, String[] structDescriptors, String[][][] tableQueues, String jndiName) throws Exception {
		String result = null;
		String inParamStr = null;
		String queryStr = null;

		try {
			// get config
			setHostAddress(
					ClientConfig.getObject().getDefaultProtocol(),
					ClientConfig.getObject().getDefaultHost(),
					ClientConfig.getObject().getDefaultPort()
				);
			setContextRoot(ClientConfig.getObject().getContextRoot());
		} catch (Exception ex) {
			logger.error(ex);
		}

		try {
			StringBuilder strBuf = new StringBuilder();
			inParamStr = TextUtil.combine(inParam);
			if (jndiName == null) {
				jndiName = getConfigJndiName();
			}
			queryStr = getParamString(userInfo, moduleCode, txCode, actionType, inParamStr, inParam==null?0:inParam.length, structDescriptors, tableQueues, jndiName);

			result = ServerUtil.connectServer(getServletURL(servletName), queryStr);
			strBuf.setLength(0);
			strBuf.append(INPUT_VALUE);
			strBuf.append(QUERYSTR_VALUE);
			strBuf.append(QUOTA1_VALUE);
			strBuf.append(queryStr);
			strBuf.append(QUOTA2_VALUE);
			logger.debug(strBuf.toString());
			strBuf.setLength(0);
			strBuf.append(INPUT_VALUE);
			strBuf.append(INPARAMSTR_VALUE);
			strBuf.append(QUOTA1_VALUE);
			strBuf.append(inParamStr);
			strBuf.append(QUOTA2_VALUE);
			logger.debug(strBuf.toString());
			if (tableQueues != null && tableQueues.length > 0) {
				for (int i = 0; i < tableQueues.length; i ++) {
					strBuf.setLength(0);
					strBuf.append(INPUT_VALUE);
					strBuf.append(TABLEQUEUE_VALUE);
					strBuf.append(QUOTA1_VALUE);
					strBuf.append(i);
					strBuf.append(QUOTA2_VALUE);
					strBuf.append(QUOTA1_VALUE);
					strBuf.append(TextUtil.stringArrayArray2String(tableQueues[i]));
					strBuf.append(QUOTA2_VALUE);
					logger.debug(strBuf.toString());
				}
			}

			strBuf.setLength(0);
			strBuf.append(OUTPUT_VALUE);
			strBuf.append(QUOTA1_VALUE);
			if (result != null && result.length() > 1000) {
				strBuf.append(result.substring(0, 1000));
				strBuf.append(DOT_VALUE);
				strBuf.append(DOT_VALUE);
				strBuf.append(DOT_VALUE);
				strBuf.append(SMALLER_THAN_VALUE);
				strBuf.append(result.length());
				strBuf.append(GREATER_THAN_VALUE);
			} else {
				strBuf.append(result);
			}
			strBuf.append(QUOTA2_VALUE);
			logger.debug(strBuf.toString());
		} catch (IOException ioe) {
			logger.error(ioe);
			System.err.println("IO Error result=" + result);
		} catch (Exception e) {
			logger.error(e);
		}
		return result;
	}

	/**
	 * @param memContextRoot the memContextRoot to set
	 */
	public static void setContextRoot(String contextRoot) {
		memContextRoot = contextRoot;
	}

	/**
	 * @return
	 */
	public static String getServletURL(String servletName) {
		StringBuilder sb = new StringBuilder();
		sb.append(memProtocol);
		sb.append(URL1_VALUE);
		sb.append(getHost());
		sb.append(URL2_VALUE);
		sb.append(memPort);
		sb.append(URL3_VALUE);
		sb.append(getContextRoot());
		sb.append(URL3_VALUE);
		sb.append(servletName);
		return sb.toString();
	}

	public static void setHostAddress(String pProtocol, String pHost, String pPort) {
		memProtocol = pProtocol;
		memHost = pHost;
		memPort = pPort;
	}

	/**
	 * @return the memContextRoot
	 */
	public static String getContextRoot() {
		return memContextRoot;
	}

	/**
	 * @return the memHost
	 */
	public static String getHost() {
		return memHost;
	}

	private static String getParamString(UserInfo userInfo, String moduleCode, String txCode, String actionType,
			String queueStr, int queueCount,
			String[] structDescriptors, String[][][] tableQueues, String jndiName) {
		//check if the inParam is null
		String result = ServerUtil.packQueue(
				(userInfo == null ? new UserInfo() : userInfo),
				(moduleCode == null ? getModuleCode() : moduleCode),
				txCode, actionType,
				queueCount,
				queueStr,
				structDescriptors,
				tableQueues,
				jndiName,
				getVersionNumber()
		);

		// take client side log for each server call
		//Factory.getInstance().clientLog(userInfo, result);

		return result;
	}
}