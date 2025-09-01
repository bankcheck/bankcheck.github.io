/*
 * Created on May 21, 2010
 *
 * To change the template for this generated file go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
package com.hkah.util.cache;

import java.io.File;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.Random;

import jcifs.smb.NtlmPasswordAuthentication;
import jcifs.smb.SmbFile;

import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang.StringEscapeUtils;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.ServerUtil;
import com.hkah.util.StringUtil;
import com.hkah.util.file.UtilFile;
import com.hkah.web.common.ReportableListObject;
import com.hkah.web.db.CMSDB;
import com.hkah.web.db.DocumentDB;

/**
 * To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Generation - Code and Comments
 */
class FileFolderCache {
	private StringBuffer fileTree = null;
	private boolean expired = true;

	public FileFolderCache() {}

	/**
	 * set expire time for each object (in ms)
	 * @return x > 0 load data after x ms
	 * @return x = 0 load data at once
	 * @return x < 0 load data once only
	 */
	public int getExpireTime() {
		return 60000;
	}


	/**
	 * @return the expired
	 */
	public boolean isExpired() {
		return expired;
	}

	/**
	 * @param expired the expired to set
	 */
	public void setExpired(boolean expired) {
		this.expired = expired;
	}

	/**
	 * return stored data object
	 * @return object
	 */
	public StringBuffer getFileTree() {
		return fileTree;
	}

	/**
	 * set stored data object
	 */
	public void setFileTree(StringBuffer fileTree) {
		this.fileTree = fileTree;
	}
}

public class ServerSideFileLoader {

	//======================================================================
	private HashMap<String, FileFolderCache> hashMapData = null;
	private HashMap<String, Date> hashMapTimestamp = null;

	//======================================================================
	private static ServerSideFileLoader instance = null;

	private ServerSideFileLoader() {
		hashMapData = new HashMap<String, FileFolderCache>();
		hashMapTimestamp = new HashMap<String, Date>();
	}

	public static ServerSideFileLoader getInstance() {
		if (instance == null) {
			instance = new ServerSideFileLoader();
		}
		return instance;
	}

	public StringBuffer getFileTree(String category, String documentID,
			String fileDirectory, boolean showSubFolder, boolean onlyShowCurrentYear,
			boolean ascOrder, boolean oldTreeStyle,
			int currentLevel, int currentCount) {
		return getFileTree(category, documentID,
				fileDirectory, showSubFolder, onlyShowCurrentYear,
				ascOrder, oldTreeStyle,
				currentLevel, currentCount, false);
	}

	/**
	 * load data by transaction code
	 * @param documentID
	 * @return
	 */
	public StringBuffer getFileTree(String category, String documentID,
			String fileDirectory, boolean showSubFolder, boolean onlyShowCurrentYear,
			boolean ascOrder, boolean oldTreeStyle,
			int currentLevel, int currentCount, boolean sortByDate) {
		if (!ConstantsServerSide.CORE_SERVER && ConstantsServerSide.LOAD_BALANCE) {
			String url = null;
			String queryString = null;

			try {
				// call core server
				StringBuffer strBuf = new StringBuffer();
				strBuf.append("http://");
				strBuf.append(ConstantsServerSide.INTRANET_URL);
				strBuf.append(":8080/intranet/GetFileTree");
				url = strBuf.toString();
				strBuf.setLength(0);
				strBuf.append("category=");
				strBuf.append(category);
				strBuf.append("&documentID=");
				strBuf.append(documentID);
				strBuf.append("&fileDirectory=");
				strBuf.append(fileDirectory);
				strBuf.append("&showSubFolder=");
				strBuf.append(convertBoolean2String(showSubFolder));
				strBuf.append("&onlyShowCurrentYear=");
				strBuf.append(convertBoolean2String(onlyShowCurrentYear));
				strBuf.append("&ascOrder=");
				strBuf.append(convertBoolean2String(ascOrder));
				strBuf.append("&oldTreeStyle=");
				strBuf.append(convertBoolean2String(oldTreeStyle));
				strBuf.append("&currentLevel=");
				strBuf.append(currentLevel);
				strBuf.append("&currentCount=");
				strBuf.append(currentCount);
				strBuf.append("&sortByDate=");
				strBuf.append(convertBoolean2String(sortByDate));
				queryString = strBuf.toString();
				strBuf.setLength(0);
				strBuf.append(ServerUtil.connectServer(url, queryString));
				return strBuf;
			} catch (Exception e) {
				return getFileTreeHelper(category, documentID, fileDirectory, showSubFolder, onlyShowCurrentYear,
						ascOrder, oldTreeStyle, currentLevel, currentCount, sortByDate);
			}
		} else {
			return getFileTreeHelper(category, documentID, fileDirectory, showSubFolder, onlyShowCurrentYear,
					ascOrder, oldTreeStyle, currentLevel, currentCount, sortByDate);
		}
	}

	/**
	 * load data by transaction code
	 * @param documentID
	 * @return
	 */
	private StringBuffer getFileTreeHelper(String category, String documentID,
			String fileDirectory, boolean showSubFolder, boolean onlyShowCurrentYear,
			boolean ascOrder, boolean oldTreeStyle,
			int currentLevel, int currentCount, boolean sortByDate) {
		FileFolderCache fileFolderCache = null;
		StringBuffer outputUrl = null;
		boolean needToRefresh = false;

		ReportableListObject row = DocumentDB.getReportableListObject(documentID);
		if (row != null) {
			String rootFolder = ConstantsServerSide.DOCUMENT_FOLDER;
			String locationPath = row.getValue(2);
			String filePrefix = row.getValue(5);
			String fileSuffix = row.getValue(6);

			// is the file located in web folder
			if ("N".equals(row.getValue(3))) {
				rootFolder = "";
			}

			if (fileDirectory == null || fileDirectory.length() == 0) {
				fileDirectory = "/";
			} else {
				fileDirectory += "/";
			}

			String keyForData = category + documentID;
			if (hashMapData.containsKey(keyForData)) {
				fileFolderCache = hashMapData.get(keyForData);
				// only check expire time if it is zero or positive integer
				if (fileFolderCache.isExpired()
				|| (
						fileFolderCache.getExpireTime() >= 0			// need to check expire time
					&&  Calendar.getInstance().getTime().getTime() >=	// current time
						hashMapTimestamp.get(keyForData).getTime() +	// object create time
						fileFolderCache.getExpireTime())				// expire time
				) {
					needToRefresh = true;
				}
			}

			if (fileFolderCache == null || needToRefresh) {
				outputUrl = new StringBuffer();
				getFileNameList(rootFolder, locationPath,
						documentID, filePrefix, fileSuffix,
						fileDirectory, showSubFolder, onlyShowCurrentYear, ascOrder, oldTreeStyle,
						currentLevel, currentCount, outputUrl, sortByDate);

				if (fileFolderCache == null) {
					fileFolderCache = new FileFolderCache();
				}
				// reload data from database
				fileFolderCache.setFileTree(outputUrl);

				// set this object is not expired
				fileFolderCache.setExpired(false);

				// refresh hashmap data for this object
				hashMapData.put(keyForData, fileFolderCache);

				// refresh timestamp for this object
				hashMapTimestamp.put(keyForData, Calendar.getInstance().getTime());
			} else {
				outputUrl = fileFolderCache.getFileTree();
			}
		}

		return outputUrl;
	}

	public void setExpired(String documentID) {
		if (hashMapData.containsKey(documentID)) {
			FileFolderCache fileFolderCache = hashMapData.get(documentID);
			fileFolderCache.setExpired(true);
		}
	}

	private void getFileNameList(String rootFolder, String locationPath,
			String documentID, String filePrefix, String fileSuffix,
			String fileDirectory, boolean showSubFolder, boolean onlyShowCurrentYear,
			boolean ascOrder, boolean oldTreeStyle,
			int currentLevel, int currentCount, StringBuffer outputUrl,
			boolean sortByDate) {
		boolean useSamba = false;
		String path = rootFolder + locationPath + fileDirectory;
		SmbFile[] smbFiles = null;
		File[] files = null;
		String[] children = null;
		SmbFile directorySmb = null;
		File directory = null;
		
		if (ServerUtil.isUseSamba(path)) {
			useSamba = true;
			try {
				directorySmb = new SmbFile("smb:" + path.replace("\\", "/"), 
						new NtlmPasswordAuthentication("",CMSDB.sysparams.get("smb_username"), CMSDB.sysparams.get("smb_password")));
				smbFiles = directorySmb.listFiles();
				children = directorySmb.list();
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			directory = new File(path);
			files = directory.listFiles();
			children = directory.list();
		}
		
		if (sortByDate) {
			Arrays.sort(files, new Comparator<File>(){
				public int compare(File f1, File f2) {
					if (f1.isDirectory()) {
						return 1;
					} else if (f2.isDirectory()) {
						return 1;
					} else {
						return Long.valueOf(f1.lastModified()).compareTo(f2.lastModified());
					}
				}
			});

			System.out.println("children.length: "+children.length);
			for (int i = 0; i < children.length; i++) {
				System.out.println("children[i]: "+children[i]);
				System.out.println("files[i]: "+files[i].getName());
				children[i] = files[i].getName();
			}
		}

		if (children != null && children.length > 0) {
			File newDirectory = null;
			SmbFile newDirectorySmb = null;
			String newFileName = null;
			int fileNameIndex = -1;
//			boolean foundMatchFile = false;
			String currentYear = String.valueOf(DateTimeUtil.getCurrentYear());
			int IdPrefix = (new Random(new Date().getTime())).nextInt();
			try {
				int start = 0;
				int end = children.length;
				int increment = 1;
				if (!ascOrder) {
					start = children.length - 1;
					end = 0;
					increment = -1;
				}

				StringBuffer outputHyperlink = new StringBuffer();
				for (int i = start; (ascOrder && i < end) || (!ascOrder && i >= end); i += increment) {
					if (useSamba) {
						newDirectorySmb = new SmbFile(directorySmb.toString() + "/" + children[i], 
								new NtlmPasswordAuthentication("",CMSDB.sysparams.get("smb_username"), CMSDB.sysparams.get("smb_password")));
					} else {
						newDirectory = new File(directory.toString() + "/" + children[i]);
					}

					if (useSamba ? newDirectorySmb.exists() : newDirectory.exists()) {
						outputHyperlink.setLength(0);
						// File object is a non-hidden file and match prefix and suffix pattern
						if ((useSamba ? !newDirectorySmb.isDirectory() : !newDirectory.isDirectory())
								&& (useSamba ? !newDirectorySmb.isHidden() : !newDirectory.isHidden())
								&& (filePrefix == null || filePrefix.length() == 0 || (children[i] != null && children[i].indexOf(filePrefix) >= 0))
								&& (fileSuffix == null || fileSuffix.length() == 0 || (children[i] != null && children[i].indexOf(fileSuffix) >= 0))
								) {
							newFileName = children[i];
							if (filePrefix != null && filePrefix.length() > 0) {
								if ((fileNameIndex = newFileName.indexOf(filePrefix)) >= 0) {
									newFileName = newFileName.substring(fileNameIndex + filePrefix.length());
								}
							}
							if (fileSuffix != null && fileSuffix.length() > 0) {
								if ((fileNameIndex = newFileName.indexOf(fileSuffix)) >= 0) {
									newFileName = newFileName.substring(0, fileNameIndex);
								}
							}

							if ("flv".equals(FilenameUtils.getExtension(newFileName))){
								outputHyperlink.append("<a href=\"javascript:void(0);\" onclick=\"playMovie('/swf/video/");
								outputHyperlink.append(children[i]);
								outputHyperlink.append("','hvga');\" class=\"topstoryblue\"><H1 id=\"TS\">");
							} else {
								outputHyperlink.append("<a href=\"javascript:void(0);\" onclick=\"downloadFile('");
								outputHyperlink.append(documentID);
								outputHyperlink.append("','");
								outputHyperlink.append(StringEscapeUtils.escapeJavaScript(fileDirectory));
								outputHyperlink.append(StringEscapeUtils.escapeJavaScript(children[i]));
								outputHyperlink.append("');\" class=\"topstoryblue\"><H1 id=\"TS\">");
							}

							outputHyperlink.append( FilenameUtils.removeExtension(newFileName));
							outputHyperlink.append("</H1></a>");
							outputHyperlink.append("&nbsp;(Read Only)");

							if (oldTreeStyle) {
								outputUrl.append("<li><span class=\"file\">");
								outputUrl.append(outputHyperlink.toString());
								outputUrl.append("</span></li>");
							} else {
								outputUrl.append("<item im0=\"../" + UtilFile.fileTypeImage(children[i]) + "\" text=\"");
								outputUrl.append(StringUtil.replaceSpecialChar4HTML(outputHyperlink.toString()));
								outputUrl.append("\" />");
							}
//							foundMatchFile = false;

						// File object is a sub folder and other specific matchings
						} else if ((useSamba ? newDirectorySmb.isDirectory() : newDirectory.isDirectory())
								// special handle to bypass current month in Archive of OB Bed Report
								&& (!onlyShowCurrentYear || currentYear.equals(children[i]))
								&& (!"34".equals(documentID)
										|| (!"Current Month".equals(children[i])
												&& !"New Folder".equals(children[i]))
												&& !"OPD Dr schedule hard copies request".equals(children[i]))) {
							if (showSubFolder) {
								if (oldTreeStyle) {
									outputUrl.append("<li class=\"closed\"><span class=\"folder\">");
									outputUrl.append(children[i]);
									outputUrl.append("</span>");
									outputUrl.append("<ul>");
								} else {
									outputUrl.append("<item id=\"");
									// must append a unqiue prefix here
									outputUrl.append(IdPrefix);
									outputUrl.append(currentCount);
									outputUrl.append(currentLevel);
									outputUrl.append(i);
									outputUrl.append("\" text=\"");
									outputUrl.append(StringUtil.replaceSpecialChar4HTML(children[i]));
									outputUrl.append("\">");
								}
							}

							getFileNameList(rootFolder, locationPath,
									documentID, filePrefix, fileSuffix,
									fileDirectory + children[i] + "/", showSubFolder, false, ascOrder, oldTreeStyle,
									currentLevel + 1, currentCount, outputUrl, sortByDate);

							if (showSubFolder) {
								if (oldTreeStyle) {
									outputUrl.append("</ul></li>");
								} else {
									outputUrl.append("</item>");
								}
							}
						}
					}
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	private String convertBoolean2String(boolean value) {
		if (value) {
			return ConstantsVariable.YES_VALUE;
		} else {
			return ConstantsVariable.NO_VALUE;
		}
	}
}