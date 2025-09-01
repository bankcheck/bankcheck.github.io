package com.hkah.client.util;

import java.util.HashMap;

import com.extjs.gxt.ui.client.Registry;
import com.google.gwt.core.client.GWT;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.hkah.client.AbstractEntryPoint;
import com.hkah.client.common.Factory;
import com.hkah.client.layout.table.TableList;
import com.hkah.client.services.CommonUtilServiceAsync;
import com.hkah.shared.model.ClientConfigObject;
import com.hkah.shared.model.MessageQueue;
import com.hkah.shared.model.MessageQueueCallBack;
import com.hkah.shared.model.UserInfo;

public class CommonUtil {
//	private static final String DEFAULT_COMPUTER_NAME = "127.0.0.1";
	private static String computerName = null;
	private static String computerIP = null;
	private static String portalHost = null;
	private static String serverOS = null;

	public static void unlockRecord(UserInfo userInfo, String lockType,
			String lockKey) {
		QueryUtil.executeMasterAction(userInfo, "RECORDUNLOCK",
				QueryUtil.ACTION_APPEND, new String[] { lockType, lockKey,
						getComputerName(), userInfo.getUserID() });
	}

	public static String foundInCollection(HashMap<String, String> hash, String Key) {
		if (hash == null) {
			return null;
		} else {
			return hash.get(Key);
		}
	}

	public static void loadPortalHost() {
		((CommonUtilServiceAsync) Registry.get(AbstractEntryPoint.COMMONUTIL_SERVICE)).getPortalHost(
				new AsyncCallback<String>() {
			@Override
			public void onSuccess(String result) {
				setPortalHost(result);
			}

			@Override
			public void onFailure(Throwable caught) {
			}
		});
	}

	public static void loadComputerName() {
		((CommonUtilServiceAsync) Registry.get(AbstractEntryPoint.COMMONUTIL_SERVICE)).getComputerName(
				new AsyncCallback<String>() {
			@Override
			public void onSuccess(final String result) {
				QueryUtil.executeMasterFetch(new UserInfo(), "COMPUTERNAME", 
						new String[] { result }, 
						new MessageQueueCallBack() {
					@Override
					public void onPostSuccess(MessageQueue mQueue) {
						if (mQueue.success()) {
							setComputerName(mQueue.getContentField()[0]);
						} else {
							setComputerName(result);
						}
					}
				});
			}

			@Override
			public void onFailure(Throwable caught) {
			}
		});
	}

	public static void loadComputerIP() {
		((CommonUtilServiceAsync) Registry.get(AbstractEntryPoint.COMMONUTIL_SERVICE)).getComputerIP(
				new AsyncCallback<String>() {
			@Override
			public void onSuccess(String result) {
				setComputerIP(result);
			}

			@Override
			public void onFailure(Throwable caught) {
			}
		});
	}

	public static void loadClientConfig() {
		((CommonUtilServiceAsync) Registry.get(AbstractEntryPoint.COMMONUTIL_SERVICE)).getClientConfigObject(
				new AsyncCallback<ClientConfigObject>() {
			@Override
			public void onSuccess(ClientConfigObject result) {
				Factory.getInstance().setClientConfigObject(result);
			}

			@Override
			public void onFailure(Throwable caught) {
//				System.err.println("DEBUG loadClientConfig onFailure");
//				Factory.getInstance().addErrorMessage("System failed to load config values. Please call IT support.\n" +
//						"Error: " + caught.getMessage());
			}
		});
	}

	public static String getComputerName() {
		if (computerName != null && computerName.length() > 0) {
			return computerName;
		} else {
			return getComputerIP();
		}
	}

	public static void setComputerName(String value) {
		//System.out.println("computer name: "+value);
		computerName = value;
	}

	public static void setComputerIP(String value) {
		computerIP = value;
	}

	public static String getComputerIP() {
		return computerIP;
	}

	/**
	 * @return the portalHost
	 */
	public static String getPortalHost() {
		return portalHost;
	}
	
	public static String getOS(){
		
		((CommonUtilServiceAsync) Registry.get(AbstractEntryPoint.COMMONUTIL_SERVICE)).getServerOS(
				new AsyncCallback<String>() {
					@Override
					public void onSuccess(final String result) {
						serverOS = result;
					}

					@Override
					public void onFailure(Throwable caught) {
						serverOS = null;
					}
		});
		return serverOS;
	}
/*	
	public boolean isLinux() {
		return getServerOS().indexOf("nix") >= 0 || getServerOS().indexOf("nux") >= 0 || getServerOS().indexOf("aix") > 0;
	}
	
	public boolean isWindow() {
		return getServerOS().startsWith("windows");
	}*/

	/**
	 * @param portalHost the portalHost to set
	 */
	public static void setPortalHost(String portalHost) {
		CommonUtil.portalHost = portalHost;
	}

	public static TableList getRs2col(int len) {
		String[] colName = new String[len];
		int[] colLen = new int[len];
		for (int i = 0; i < len; i++) {
			colName[i] = "";
			colLen[i] = 0;
		}

		return new TableList(colName, colLen);
	}

	public static String right(String s, int len) {
		if (s == null) {
			return "";
		}
		if (s.length() <= len) {
			return s;
		}
		return s.substring(s.length() - len);
	}

	public static String left(String s, int len) {
		if (s == null) {
			return "";
		}
		if (s.length() <= len) {
			return s;
		}
		return s.substring(0, len);
	}

	public static String format(String s, String format) {
		String str = format + s;
		return str.substring(str.length() - format.length());
	}

	public static String[] arrryCopy(String[] arr) {
		String[] back = new String[arr.length];
		for (int i = 0; i < arr.length; i++) {
			back[i] = arr[i];
		}
		return back;
	}

	public static String[] getTableSelectRowContent(TableList tableList){
		return tableList.getSelectedRowContent();
	}

	public static int getTableSelectRow(TableList list) {
		if (list == null || list.getRowCount() <= 0) {
			return -1;
		}

		if (list.getSelectedRow() < 0) {
			return 0;
		} else {
			return list.getSelectedRow();
		}
	}

	public static boolean checkHKID(String HKID) {
		if (HKID.length() == 10 || HKID.length() == 11) {
			if (")".equals(right(HKID, 1))
					&& "(".equals(left(right(HKID, 3), 1))) {
				if (HKID.charAt(0) >= 'A' && HKID.charAt(0) <= 'Z') {
					if ((HKID.length() == 11 && HKID.charAt(1) >= 'A' && HKID
							.charAt(1) <= 'Z') || HKID.length() == 10) {
						return true;
					}
				}
			}
		}
		return false;
	}

	public static String formatString(int length,String pad,String src){
		StringBuilder sb = new StringBuilder(src);
		if (src.length() < length) {
			for (int i = 0; i < length - src.length(); i++){
				sb.append(pad);
			}
		}
		return sb.toString();
	}

//	public static String getCISColor(UserInfo userInfo, String patno,
//			String updDate) {
//		String rtnValue = "";
//		MessageQueueCallBack callBack = new MessageQueueCallBack() {
//			@Override
//			public void onPostSuccess(MessageQueue mQueue) {
//				// TODO Auto-generated method stub
//			}
//		};
//		QueryUtil.executeMasterFetch(userInfo, "LOOKUP", new String[] {
//				"ext_get_pat_allergy_date",
//				"to_char(update_date,'dd/mm/yyyy hh:mi')",
//				"patno='" + patno + "'" }, callBack);
//		MessageQueue mQueue1 = callBack.getMessageQueue();
//		QueryUtil.executeMasterFetch(userInfo, "LOOKUP", new String[] {
//				"ext_get_pat_allergy", "count(*)", "patno='" + patno + "'" },
//				callBack);
//		MessageQueue mQueue2 = callBack.getMessageQueue();
//		QueryUtil
//				.executeMasterFetch(userInfo, "LOOKUP", new String[] {
//						"ext_get_pat_allergy", "count(*)",
//						"patno='" + patno + "' and Cancel_Date is not null" },
//						callBack);
//		MessageQueue mQueue3 = callBack.getMessageQueue();
//		if (mQueue1.success() && mQueue2.success() && mQueue3.success()) {
//			if ("0".equals(mQueue2.getContentField()[0])) {
//				if (!"".equals(mQueue1.getContentField()[0])) {
//					rtnValue = "&HC000&";
//				} else {
//					rtnValue = "vbWhite";
//				}
//			} else {
//				if (!mQueue3.getContentField()[0].equals(mQueue2
//						.getContentField()[0])) {
//					rtnValue = "vbRed";
//				} else {
//					rtnValue = "&HC000&";
//				}
//			}
//		} else {
//			rtnValue = "vbBlue";
//		}
//		return rtnValue;
//	}
//
//	public static boolean checkButtonEnable(UserInfo userInfo, String name,
//			String key) {
//		QueryUtil.executeMasterFetch(userInfo, "CHECKFUNCTION", new String[] {
//				name, key, userInfo.getUserID() }, new MessageQueueCallBack() {
//					@Override
//					public void onPostSuccess(MessageQueue mQueue) {
//						// TODO Auto-generated method stub
//					}
//				});
//		if ("0".equals(mQueue.getContentField()[0])) {
//			return true;
//		} else {
//			return false;
//		}
//	}

	public static String getReportImg(String imgName) {
		String path= GWT.getHostPageBaseURL()+ "images/" + imgName;
		return path;
	}

	public static String getReportDir() {
		return GWT.getHostPageBaseURL() + "report/";
	}

//	public static String getSysparam(UserInfo userInfo, String parcde) {
//		MessageQueueCallBack callBack = new MessageQueueCallBack() {
//			@Override
//			public void onPostSuccess(MessageQueue mQueue) {
//				// TODO Auto-generated method stub
//			}
//		};
//		QueryUtil.executeMasterFetch(userInfo, "SYSPARAM",
//				new String[] { parcde }, callBack);
//		MessageQueue mQueue = callBack.getMessageQueue();
//		if (mQueue.success()) {
//			return mQueue.getContentField()[1];
//		} else {
//			return "";
//		}
//	}
//
//	public static String saveFile() {
//		String file = null;
//		JFileChooser jc = new JFileChooser();
//		jc.setDialogTitle("Save File");
//		jc.setFileFilter(new FileNameExtensionFilter("Excel Files (*.xls)",
//				new String[] { "xls" }));
//		int flag = jc.showSaveDialog(null);
//		if (flag == 0) {
//			File f = jc.getSelectedFile();
//			file = f.getAbsolutePath() + ".xls";
//			try {
//				FileWriter out = new FileWriter(file);
//				out.close();
//			} catch (Exception e) {
//				e.printStackTrace();
//			}
//		}
//		return file;
//	}
}