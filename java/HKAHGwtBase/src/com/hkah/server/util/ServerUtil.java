/*
 * Created on July 4, 2008
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.hkah.server.util;

import java.io.BufferedReader;
import java.io.DataOutputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.URLConnection;
import java.net.URLEncoder;

import com.hkah.client.util.TextUtil;
import com.hkah.server.connection.ConnectionFactory;
import com.hkah.shared.model.UserInfo;

/**
 * @author administrator
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class ServerUtil {

	public static String packQueue(UserInfo userInfo, String moduleCode, String txCode, String actionType,
			int qElementLen, String servletQElement,
			String structDescriptor, String[][] tableQueue,
			String jndiName, String versionNo) {
		return packQueue(userInfo, moduleCode, txCode, actionType,
				qElementLen, servletQElement,
				new String[]{structDescriptor}, new String[][][]{tableQueue},
				jndiName, versionNo);
	}

	public static String packQueue(UserInfo userInfo, String moduleCode, String txCode, String actionType,
			int qElementLen, String servletQElement,
			String[] structDescriptors, String[][][] tableQueues,
			String jndiName, String versionNo) {
		StringBuilder result = new StringBuilder();

		result.append("moduleCode=");
		result.append(moduleCode);
		result.append("&txCode=");
		result.append(txCode);
		// reserver for master action
		result.append("&actionType=");
		result.append(actionType);
		if (userInfo != null) {
			// site code
			result.append("&siteCode=");
			result.append(userInfo.getSiteCode());
			// department code
			result.append("&deptCode=");
			result.append(userInfo.getDeptCode());
			// user id
			result.append("&userID=");
			result.append(userInfo.getUserID());
		}
		// direct to hats
		result.append("&direct2DB=Y");
		// JNDI name
		result.append("&jndiName=");
		result.append(jndiName);
		// version number
		result.append("&versionNo=");
		result.append(versionNo);
		// in queue size
		result.append("&inQueueSize=");
		result.append(qElementLen);
		// in queue
		result.append("&inQueue=");
		try {
			result.append(StringUtil.replaceSpecialChar(URLEncoder.encode(servletQElement, "UTF-8")));
		} catch (UnsupportedEncodingException e) {
			result.append(StringUtil.replaceSpecialChar(servletQElement));
		}
		if (structDescriptors != null && tableQueues != null &&
				structDescriptors.length > 0 && tableQueues.length > 0) {
			for (String sd : structDescriptors) {
				result.append("&structDescriptor=");
				result.append(sd);
			}
			for (String[][] tq : tableQueues) {
				result.append("&tableQueue=");
				try {
					result.append(StringUtil.replaceSpecialChar(URLEncoder.encode(TextUtil.stringArrayArray2String(tq), "UTF-8")));
				} catch (UnsupportedEncodingException e) {
					result.append(StringUtil.replaceSpecialChar(servletQElement));
				}
			}
		}
		result.append("&clientTimeStamp=");
		result.append(System.currentTimeMillis());
		result.append(" ");

		return result.toString();
	}

	public static String connectServer(String serverUrl, String queryString)
	throws Exception {
		StringBuilder result = new StringBuilder();
		String line = null;

		URLConnection urlConn = null;
		DataOutputStream dos = null;
		BufferedReader br = null;
		try {
			urlConn = ConnectionFactory.factoryConnection(serverUrl);
			dos = new DataOutputStream(urlConn.getOutputStream());
			dos.writeBytes(queryString);
			br = new BufferedReader(new InputStreamReader(urlConn.getInputStream(), "UTF-8"));
			while ((line = br.readLine()) != null) {
				result.append(line);
				result.append("\r\n");
			}
/*
			if (urlConn.getContentLength() != -1) {
				char[] tempChar = new char[urlConn.getContentLength()];
				while (br.read(tempChar) != -1) {
				    result.append(tempChar);
				}
			}
*/
		} catch (Exception e) {
			e.printStackTrace();
			throw e;
		} finally {
			try {
				urlConn.getInputStream().close();
				urlConn.getOutputStream().close();
				dos.close();
				br.close();
			} catch (Exception e) {
			}
		}
		return result.toString();
	}
}