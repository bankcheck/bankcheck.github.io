<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%!
	private String checkAccessible(HashSet hashSet, HashSet enableSet, String documentID, String labelTitle, boolean withFolder) {
		return checkAccessible(hashSet, enableSet, documentID, labelTitle, withFolder, true, true, false, true);
	}

	private String checkAccessible(HashSet hashSet, HashSet enableSet, String documentID, String labelTitle, boolean withFolder, boolean showPointForm) {
		return checkAccessible(hashSet, enableSet, documentID, labelTitle, withFolder, true, true, false, showPointForm);
	}

	private String checkAccessible(HashSet hashSet, HashSet enableSet, String documentID, String labelTitle,
			boolean withFolder, boolean latestFile,
			boolean showSubFolder, boolean onlyShowCurrentYear, boolean showPointForm) {
		if (hashSet.contains(documentID)) {
			if (withFolder) {
				enableSet.add(documentID);
			}
			StringBuffer outputUrl = new StringBuffer();
			if (showPointForm) {
				outputUrl.append("<li>");
			} else {
				outputUrl.append("<tr>");
				outputUrl.append("<td class=\"h1_margin\">");
			}
			if (latestFile) {
				outputUrl.append("<a href=\"javascript:downloadFile('");
				outputUrl.append(documentID);
				outputUrl.append("', '');\"");
			} else if (withFolder) {
				outputUrl.append("<a href=\"javascript:slickToggle('");
				outputUrl.append(documentID);
				outputUrl.append("');\"");
			} else {
				outputUrl.append("<a href=\"#\"");
			}
			outputUrl.append(" class=\"topstoryblue\"><H1 id=\"TS\">");
			outputUrl.append(labelTitle);
			outputUrl.append("</H1></a>");
			if (withFolder) {
				if (latestFile) {
					outputUrl.append("&nbsp;[<a href=\"javascript:slickToggle('");
					outputUrl.append(documentID);
					outputUrl.append("');\" class=\"topstoryblue\"><H2 id=\"blog\">Show All</H2></a>]");
				}
				outputUrl.append("<div id=\"content-");
				outputUrl.append(documentID);
				outputUrl.append("\">");
				outputUrl.append("<ul>");
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

					getFileNameList(rootFolder, locationPath,
							documentID, filePrefix, fileSuffix, "/", showSubFolder, onlyShowCurrentYear, outputUrl);
				}
				outputUrl.append("</ul>");
				outputUrl.append("</div>");
			}
			if (showPointForm) {
				outputUrl.append("</li>");
			} else {
				outputUrl.append("</td>");
				outputUrl.append("</tr>");
			}
			return outputUrl.toString();
		} else {
			return "";
		}
	}

	private void getFileNameList(String rootFolder, String locationPath,
			String documentID, String filePrefix, String fileSuffix, String fileDirectory,
			boolean showSubFolder, boolean onlyShowCurrentYear, StringBuffer outputUrl) {
		File directory = new File(rootFolder + locationPath + fileDirectory);

		String[] children = directory.list();
		if (children != null && children.length > 0) {
			File newDirectory = null;
			String newFileName = null;
			int fileNameIndex = -1;
			boolean foundMatchFile = false;
			String currentYear = String.valueOf(DateTimeUtil.getCurrentYear());
			try {
				for (int i = children.length - 1; i >= 0; i--) {
					newDirectory = new File(directory.toString() + "/" + children[i]);
					if (newDirectory.exists()) {
						if ((!"31".equals(documentID) ||!foundMatchFile)
								&& newDirectory.isFile()
								&& (filePrefix == null || filePrefix.length() == 0 || children[i].indexOf(filePrefix) >= 0)
								&& (fileSuffix == null || fileSuffix.length() == 0 || children[i].indexOf(fileSuffix) > 0)
								// special handle for GP Roster
								&& children[i].indexOf("Master.xls") < 0) {
							outputUrl.append("<li>");
							outputUrl.append("<a href=\"javascript:downloadFile('");
							outputUrl.append(documentID);
							outputUrl.append("','");
							outputUrl.append(fileDirectory);
							outputUrl.append(children[i]);
							outputUrl.append("');\" class=\"topstoryblue\"><H1 id=\"TS\">");
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
							outputUrl.append(newFileName);
							outputUrl.append("</H1></a>");
							outputUrl.append("</li>");
							foundMatchFile = true;
						} else if (newDirectory.isDirectory()
								// special handle to bypass current month in Archive of OB Bed Report
								&& (!onlyShowCurrentYear || currentYear.equals(children[i]))
								&& ((!"31".equals(documentID) && !"34".equals(documentID))
										|| (!"Current Month".equals(children[i])
												&& !"New Folder".equals(children[i]))
												&& !"OPD Dr schedule hard copies request".equals(children[i]))) {
							if (showSubFolder) {
								outputUrl.append("<li>");
								outputUrl.append(children[i]);
								outputUrl.append("</li>");
								outputUrl.append("<ul>");
							}
							getFileNameList(rootFolder, locationPath,
									documentID, filePrefix, fileSuffix, fileDirectory + children[i] + "/", false, false, outputUrl);
							if (showSubFolder) {
								outputUrl.append("</ul>");
							}
						}
					}
				}
			} catch (Exception e) {
			}
		}
	}
%>
<%
UserBean userBean = new UserBean(request);

ArrayList record = DocumentDB.getAccessable(userBean);
HashSet accessableSet = new HashSet();
HashSet enableFunctionSet = new HashSet();
if (record.size() > 0) {
	ReportableListObject row = null;
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		accessableSet.add(row.getValue(0));
	}
}
%>

<jsp:include page="../common/information_helper.jsp" flush="false">
	<jsp:param name="category" value="pi.achs" />
	<jsp:param name="skipColumnTitle" value="Y" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="oldTreeStyle" value="Y" />
</jsp:include>
<% 
	String achsRecommAndSuggDocId = null;
	if (ConstantsServerSide.isHKAH()) { achsRecommAndSuggDocId = "355"; } 
	else if (ConstantsServerSide.isTWAH()) { achsRecommAndSuggDocId = "344"; }
	else { achsRecommAndSuggDocId = "344"; }
%>
