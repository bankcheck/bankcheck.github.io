<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.cache.*"%>
<%@ page import="com.hkah.util.file.UtilFile"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="org.apache.commons.lang.*"%>
<%@ page import="org.apache.commons.io.FilenameUtils"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils"%>
<%!
	private String checkAccessible(UserBean userBean, HttpSession session,
			String category, String documentID, String documentURL, String labelTitle, String folder,
			boolean mustLogin, boolean withFolder, boolean latestFile,
			boolean showSubFolder, boolean onlyShowCurrentYear, boolean showPointForm, boolean folderShowRoot, String targetContent, String showOrder,
			int currentLevel, int currentCount, String treeViewCategory, String infoID, boolean oldTreeStyle, boolean countHitRate, boolean disableDocument, 
			boolean isExpandFolder) {

		boolean showLink = false;
		boolean isFile = true;

		StringBuffer outputUrl = new StringBuffer();
		if (!mustLogin || userBean.isLogin()) {
			boolean skipFolderShow = false;
			if (documentURL != null && documentURL.length() > 0) {

				if (("twah".equals(userBean.getSiteCode()))&&(documentID != null && documentID.length() > 0) &&
						!(category.startsWith("adventist.corner"))) {
					if (countHitRate) {
						outputUrl.append("<span id=\""+documentID+"\"> (Hit Rate:"+DocumentDB.showHitRate(documentID)+") </span>");
					}
					outputUrl.append("<a href=\"javascript:void(0);\" onclick=\" ");
					outputUrl.append("changeHitRate('false','");
					outputUrl.append(documentID);
					outputUrl.append("'); return false;\" ");
					countHitRate = false;

				} else {
					outputUrl.append("<a href=\"");
					outputUrl.append(documentURL);
					outputUrl.append("\" ");
				}
				if (countHitRate) {
					outputUrl.append(" onclick=\"");
					outputUrl.append("changeHitRate('true','");
					outputUrl.append(documentID);
					outputUrl.append("');return false;\" ");
				}
				outputUrl.append("class=\"topstoryblue");
				outputUrl.append("\" target=\"");
				outputUrl.append(targetContent);
				outputUrl.append("\"><H1 id=\"TS\">");
				outputUrl.append(labelTitle);
				outputUrl.append("</H1></a>");
				if (countHitRate) {
					outputUrl.append("<span id=\""+documentID+"\">Hit Rate:"+DocumentDB.showHitRate(documentID)+"</span>");
				}
				// allow admin to edit
				if (userBean.isLogin() && userBean.isAdmin()) {
					outputUrl.append("&nbsp;[ <a href=\"javascript:void()\" onclick=\"callPopUpWindow(\'../admin/information.jsp?command=View&infoCategory=" + category +"&infoID="+ infoID +"\');\">Edit</a> ]");
				}
			} else if (latestFile) {
				isFile = !withFolder;
				showLink = documentID != null && documentID.length() > 0;
				if (showLink) {
					outputUrl.append("<a href=\"javascript:void(0);\" onclick=\" ");
					if (countHitRate) {
						outputUrl.append("changeHitRate('false','");
						outputUrl.append(documentID);
						outputUrl.append("'); ");
					} else {
						outputUrl.append("downloadFile('");
						outputUrl.append(documentID);
						outputUrl.append("', ''); ");
					}
					outputUrl.append("return false;\" class=\"topstoryblue");
					outputUrl.append("\" target=\"");
					outputUrl.append(targetContent);
					outputUrl.append("\"><H1 id=\"TS\">");
				}
				outputUrl.append(labelTitle);
				if (showLink) {
					outputUrl.append("</H1>&nbsp;(Read Only)</a>");
					if (countHitRate) {
						outputUrl.append("<span id=\""+documentID+"\">Hit Rate:"+DocumentDB.showHitRate(documentID)+"</span>");
					}
					// allow admin to edit
					if (userBean.isLogin() && userBean.isAdmin()) {
						outputUrl.append("&nbsp;[ <a href=\"javascript:void()\" onclick=\"callPopUpWindow(\'../admin/information.jsp?command=View&infoCategory=" + category +"&infoID="+ infoID +"\');\">Edit</a> ]");
					}
				}
			} else if (folderShowRoot) {
				isFile = false;
				outputUrl.append(labelTitle);
			} else {
				skipFolderShow = true;
			}

			// parse to html code
			if (outputUrl.length() > 0) {
				String hyperlink = outputUrl.toString();
				outputUrl.setLength(0);
				if (oldTreeStyle) {
					if (isFile) {
						outputUrl.append("<li><span class=\"file\">");
					} else {
						outputUrl.append("<li class=\"" + (isExpandFolder ? "open" : "closed") + "\"><span class=\"folder\">");
					}
					outputUrl.append(hyperlink);
					outputUrl.append("</span>");
				} else {
					outputUrl.append("<item");
					if (withFolder) {
						outputUrl.append(" id=\"n");
						outputUrl.append(currentCount);
						outputUrl.append("\"");
					}
					outputUrl.append(" im0=\"../" + UtilFile.fileTypeImage(hyperlink) + "\"");
					outputUrl.append(" text=\"");
					outputUrl.append(StringUtil.replaceSpecialChar4HTML(hyperlink));
					outputUrl.append("\">");
				}
			}

			if (withFolder) {
				if (oldTreeStyle && folderShowRoot) outputUrl.append("<ul>");

				boolean ascOrder = "A".equalsIgnoreCase(showOrder) ? true : false;
				boolean sortByDate = false;
				// special handling for finance category
				if ("finance".equals(category)) {
					ascOrder = true;
				}

				StringBuffer html = ServerSideFileLoader.getInstance().getFileTree(
						category, documentID,
						folder, showSubFolder, onlyShowCurrentYear, ascOrder, oldTreeStyle,
						currentLevel + 1, currentCount, sortByDate);
				if (html != null) {
					outputUrl.append(html);
				}

				if (oldTreeStyle && folderShowRoot) outputUrl.append("</ul>");
			}

			if (!skipFolderShow) {
				if (oldTreeStyle) {
					outputUrl.append("</li>");
				} else {
					outputUrl.append("</item>");
				}
			}
		}

		String displayString = outputUrl.toString();
		if (disableDocument) {
			displayString = displayString.replaceAll("href=\"javascript:downloadFile(.*?)class=\"topstoryblue\"", "");
			displayString = displayString.replaceAll("href=&quot;javascript:downloadFile(.*?)class=&quot;topstoryblue&quot;", "");
			displayString = displayString.replaceAll("href=\"(.*?)target=\"(.*?)\"", "");
		}

		return displayString.toString();
	}

	private String checkUrlPermission(UserBean userBean, HttpSession session,
			String functionID, String labelTitle, String jspPage, String targetContent, String category, String infoID, boolean oldTreeStyle) {

		if ((userBean.isLogin() && userBean.isAccessible(functionID)) || "../hat/dr_schedule_all(ie).jsp".equals(jspPage) || "../hat/dr_schedule_1024.jsp".equals(jspPage) || "../ph/drug_form_list.jsp".equals(jspPage)
				|| (jspPage != null && jspPage.contains("crm/portal/index.jsp"))) {
			StringBuffer outputUrl = new StringBuffer();
			outputUrl.append("<a href=\"");
			outputUrl.append(jspPage);
			outputUrl.append("\" class=\"topstoryblue\" target=\"");
			outputUrl.append(targetContent);
			if (!targetContent.equalsIgnoreCase("_blank")) {
				outputUrl.append("\" onclick=\"showLoadingBox('body', 500, $(window).scrollTop());\"><H1 id=\"TS\">");
			}
			else {
				outputUrl.append("\"><H1 id=\"TS\">");
			}
			if (labelTitle != null && labelTitle.length() > 0) {
				outputUrl.append(MessageResources.getMessage(session, labelTitle));
			} else {
				outputUrl.append(MessageResources.getMessage(session, functionID));
			}
			outputUrl.append("</H1></a>");
			// allow admin to edit
			if (userBean.isLogin() && userBean.isAdmin()) {
				outputUrl.append("&nbsp;[ <a href=\"javascript:void()\" onclick=\"callPopUpWindow(\'../admin/information.jsp?command=View&infoCategory=" + category +"&infoID="+ infoID +"\');\">Edit</a> ]");
			}

			String hyperlink = outputUrl.toString();
			outputUrl.setLength(0);
			if (oldTreeStyle) {
				outputUrl.append("<li>");
				outputUrl.append("<img src=\"../images/sys.gif\">&nbsp;");
				outputUrl.append(hyperlink);
				outputUrl.append("</li>");
			} else {
				hyperlink = StringUtil.replaceSpecialChar4HTML(hyperlink);
				outputUrl.setLength(0);
				outputUrl.append("<item im0=\"../sys.gif\" text=\"");
				outputUrl.append(hyperlink);
				outputUrl.append("\" />");
			}
			return outputUrl.toString();
		} else {
			return ConstantsVariable.EMPTY_VALUE;
		}
	}

	private String buildTree(UserBean userBean, HttpSession session, String category, String folder, String treeViewCategory, String itemId, boolean oldTreeStyle, boolean mustLogin, boolean countHitRate, boolean disableDocument) {
		StringBuffer sb = new StringBuffer();
		ArrayList result = AccessControlDB.getInformationList(userBean, category);
		if (result.size() > 0) {
			ReportableListObject row = null;
			String pageType = null;
			String description = null;
			String functionID = null;
			String functionURL = null;
			String subCategory = null;
			String documentID = null;
			String documentURL = null;
			String infoID = null;
			boolean withFolder = false;
			boolean latestFile = false;
			boolean showSubFolder = false;
			boolean onlyShowCurrentYear = false;
			boolean showPointForm = false;
			boolean folderShowRoot = true;
			boolean isExpandFolder = false;
			String targetContent = null;
			String showOrder = null;
			String newItemID = itemId = "0";

			for (int i = 0; i < result.size(); i++) {
				row = (ReportableListObject) result.get(i);
				pageType = row.getValue(2);
				description = row.getValue(3);
				functionID = row.getValue(4);
				functionURL = row.getValue(5);
				subCategory = row.getValue(6);
				documentID = row.getValue(7);
				documentURL = row.getValue(8);
				infoID = row.getValue(0);
				withFolder = ConstantsVariable.YES_VALUE.equals(row.getValue(9));
				latestFile = ConstantsVariable.YES_VALUE.equals(row.getValue(10));
				showSubFolder = ConstantsVariable.YES_VALUE.equals(row.getValue(11));
				onlyShowCurrentYear = ConstantsVariable.YES_VALUE.equals(row.getValue(12));
				showPointForm = ConstantsVariable.YES_VALUE.equals(row.getValue(13));
				folderShowRoot = ConstantsVariable.YES_VALUE.equals(row.getValue(14));
				targetContent = row.getValue(15);
				showOrder = row.getValue(16);
				isExpandFolder = ConstantsVariable.YES_VALUE.equals(row.getValue(17));
				if (subCategory != null && subCategory.length() > 0) {
					if (oldTreeStyle) {
						sb.append("<li class=\"" + (isExpandFolder ? "open" : "closed") + "\"><span class=\"folder\">");
						sb.append(description);
						sb.append("</span><ul>");
					} else {
						sb.append("<item id=\"");
						sb.append(newItemID);
						sb.append("\" text=\"");
						sb.append(StringUtil.replaceSpecialChar4HTML(description));
						sb.append("\"");
					}
					sb.append(buildTree(userBean, session, subCategory, folder, treeViewCategory, newItemID, oldTreeStyle, mustLogin, countHitRate, disableDocument));
					if (oldTreeStyle) {
						sb.append("</ul></li>");
					} else {
						sb.append("</item>");
					}
				} else {
					if ("PROGRAM".equals(pageType)) {
						sb.append(checkUrlPermission(userBean, session, functionID,description , functionURL, targetContent, category, infoID, oldTreeStyle));
					} else {
						sb.append(checkAccessible(userBean, session, category, documentID, documentURL, FilenameUtils.removeExtension(description), folder,
							mustLogin, withFolder, latestFile, showSubFolder, onlyShowCurrentYear,
							showPointForm, folderShowRoot, targetContent, showOrder,
							0, i, treeViewCategory, infoID, oldTreeStyle, countHitRate, disableDocument, isExpandFolder));
					}
				}
			}
		}
		return sb.toString();
	}
%>
<%
	UserBean userBean = new UserBean(request);

	String columnTitle = request.getParameter("columnTitle");
	String category = request.getParameter("category");
	String folder = request.getParameter("folder");
	String treeViewCategory = request.getParameter("treeViewCategory");
	Random rand = (new Random(new Date().getTime()));
	int idPrefix = rand.nextInt();

	boolean adminStyle = ConstantsVariable.YES_VALUE.equals(request.getParameter("adminStyle"));
	boolean mustLogin = !ConstantsVariable.NO_VALUE.equals(request.getParameter("mustLogin"));
	boolean skipColumnTitle = ConstantsVariable.YES_VALUE.equals(request.getParameter("skipColumnTitle"));
	boolean skipTreeview = ConstantsVariable.YES_VALUE.equals(request.getParameter("skipTreeview"));
	boolean oldTreeStyle = ConstantsVariable.YES_VALUE.equals(request.getParameter("oldTreeStyle"));
	boolean countHitRate = ConstantsVariable.YES_VALUE.equals(request.getParameter("countHitRate"));
	boolean disableDocument = ConstantsVariable.YES_VALUE.equals(request.getParameter("disableDocument"));

	if (!skipColumnTitle && (columnTitle == null || columnTitle.length() == 0)) {
		columnTitle = category.toUpperCase();
	}

	// set default tree view category as category itself
	if (treeViewCategory == null || treeViewCategory.length() == 0) {
		treeViewCategory = category;
	}

	String itemId = "t0-" + (columnTitle == null ? "" : (StringEscapeUtils.escapeHtml(columnTitle) + idPrefix++));

	StringBuffer sb = new StringBuffer();
	sb.append(buildTree(userBean, session, category, folder, treeViewCategory, itemId, oldTreeStyle, mustLogin, countHitRate, disableDocument));
	if (sb.length() > 0) {
		if (!skipColumnTitle) {
			%><table width="100%" border="0" cellspacing="0" cellpadding="0">
				<tr><td class="title"><%=columnTitle %> <img src="../images/title_arrow.gif"></td></tr>
				<tr><td height="2" bgcolor="#840010"></td></tr>
				<tr><td height="10"></td></tr>
			</table><%
		}
		if (!skipTreeview) {
			if (oldTreeStyle) {
				%><ul id="browser" class="filetree"><%
			} else {
				%><div id="treeboxbox_<%=treeViewCategory %>" setImagePath="../images/dhtmlxTree/" class="dhtmlxTree"><xmp><%
			}
		}
		if (adminStyle) {
			if (oldTreeStyle) {
				%><li class="closed"><span class="folder"><%=columnTitle %></span><ul><%
			} else {
				// append a unqiue prefix here
				%><item id="<%=itemId %>" text="<%=StringUtil.replaceSpecialChar4HTML(columnTitle) %>"><%
			}
		}

		%><%=sb.toString() %><%

		if (adminStyle) {
			if (oldTreeStyle) {
				%></ul></li><%
			} else {
				%></item><%
			}
		}
		if (!skipTreeview) {
			if (oldTreeStyle) {
				%></ul><%
			} else {
				%></xmp></div><%
			}
		}
	}
%>