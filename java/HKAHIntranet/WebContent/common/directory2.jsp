<%@ page import="jcifs.smb.*"%>
<%@ page import="java.io.File" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.file.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.Arrays"%>
<%@ page import="java.util.Comparator"%>
<%@ page import="com.hkah.convert.Converter"%>
<%@ page import="org.apache.commons.io.FilenameUtils"%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%!
	public static boolean checkEditPermission(UserBean userBean, String folderName,
			boolean isPolicy, boolean isDepartmenalSharing,
			boolean isVPA, boolean isDeptResource, boolean isFdSharing) {
		String pathSeparator = "/";
		String policyDeptName = folderName;
		if (policyDeptName != null) {
			policyDeptName = policyDeptName.replaceFirst("\\\\", "");
			int sepIdx = policyDeptName.indexOf(pathSeparator);
			if (sepIdx == 0) {
				policyDeptName = policyDeptName.substring(1, policyDeptName.length());
				sepIdx = policyDeptName.indexOf(pathSeparator);
			}
			if (sepIdx > 0) {
				policyDeptName = policyDeptName.substring(0, sepIdx);
			}
			policyDeptName = policyDeptName.replaceAll(" ", "+");
			policyDeptName = policyDeptName.replaceFirst(pathSeparator, "");
		}

		if (isDepartmenalSharing) {
			String hrSuper = "4773";
			String hrCode = ConstantsServerSide.isHKAH()?"710":"HR";

			if (userBean.isAdmin()) {
				return true;
			}

			File file = new File(folderName);
			if (!userBean.isAccessible("departmental.sharing.admin") && (
					file.getParent() != null && !(file.getParent().indexOf("D_") > -1 ||
					file.getParent().indexOf("(S_") > -1 ||
					file.getParent().indexOf("(G_") > -1))) {
				return false;
			}

			if (folderName != null && folderName.indexOf("(D_") > -1) {
				int dptCodeIndex = folderName.indexOf("(D_");
				String deptCode = folderName.substring(dptCodeIndex, folderName.indexOf(")", dptCodeIndex));
				deptCode = deptCode.substring(3);

				//if (userBean.getDeptCode().equals(deptCode)) {
					String deptHeadID = DepartmentDB.getDeptHeadID(deptCode);
					if (deptHeadID != null && deptHeadID.equals(userBean.getStaffID())) {
						return true;
					}
				//}

				if (hrSuper.equals(userBean.getStaffID()) && hrCode.equals(deptCode)) {
					return true;
				}
			} else if (folderName != null && folderName.indexOf("(S_") > -1) {
				int staffCodeIndex = folderName.indexOf("(S_");
				String staffCode = folderName.substring(staffCodeIndex, folderName.indexOf(")", staffCodeIndex));
				staffCode = staffCode.substring(3);

				if (userBean.getStaffID().equals(staffCode)) {
					return true;
				}
			} else if (folderName != null && folderName.indexOf("(G_") > -1) {
				int grpCodeIndex = folderName.indexOf("(G_");
				String grpCode = folderName.substring(grpCodeIndex, folderName.indexOf(")", grpCodeIndex));
				grpCode = grpCode.substring(3);
				String groupId = AccessControlDB.CUSTOME_GRP_CODE_PREFIX.concat(grpCode);
				if (userBean.isGroupID(groupId)) {
					return true;
				}
			}
			return false;
		} else if (isFdSharing) {
			if (userBean.isAdmin()) {
				return true;
			}
			
			boolean result = false;
			String folderDesc = null;
			//System.out.println("[directory] checkEditPermission folderName="+folderName);
			
			if (folderName != null && !folderName.isEmpty()) {
				String[] folderNames = folderName.split("/");
				if (folderNames != null &&  folderNames.length > 0) {
					if (folderNames.length > 1) {
						// check top level only
						folderDesc = folderNames[1];
					} else if (folderNames.length > 0) {
						// check top level only
						folderDesc = folderNames[0];
					}
				}
			}
			
			if (folderDesc != null && userBean.isAccessible(AccessControlDB.getFunctionIDbyDesc(folderDesc))) {
				result = true;
			}	

			//System.out.println("   result="+result);
			return result;
		} else if (isVPA) {
			return false;
		} else if (isDeptResource) {
			String thisFunctionId = "function.policy."+policyDeptName+".upload";
			return (userBean.isAccessible("function.documentManagement.upload") ||
				(isDeptResource && userBean.isAccessible(thisFunctionId)));
		} else {
			String thisFunctionId = "function.policy."+policyDeptName+".upload";
			return (userBean.isAccessible("function.documentManagement.upload") ||
				(isPolicy && userBean.isAccessible(thisFunctionId)));
		}
	}

	private static boolean isDepartmentalSharingPublicFolder(String name) {
		String[] folders = new String[] {
			"Corporate"
		};

		if (name != null) {
			for (String f : folders) {
				if (name.indexOf(f) > -1) {
					return true;
				}
			}
		}
		return false;
	}

	private static boolean isDepartmentalSharingDepartmentFolder(String name) {
		String[] folders = new String[] {
			"Department Head Retreat Presentation",
			"Department Head Retreat Poster",
			". Goal"
		};

		if (name != null) {
			for (String f : folders) {
				if (name.indexOf(f) > -1) {
					return true;
				}
			}
		}
		return false;
	}

	private static boolean checkShowFolder(UserBean userBean, String folderName, String fileName,
		boolean isDepartmenalSharing, boolean isFdSharing) {
		return checkShowFolder( userBean,folderName,fileName,isDepartmenalSharing,false, isFdSharing);
	}

	private static boolean checkShowFolder(UserBean userBean, String folderName, String fileName,
			boolean isDepartmenalSharing, boolean isHRImg, boolean isFdSharing) {
		String hrCode = ConstantsServerSide.isHKAH()?"710":"HR";
		String hrDirector = "5261";
		String hrSuper = "4773";
		String vpf = "3940";
		
		System.out.println("[directory2] checkShowFolder start folderName="+folderName+", fileName="+fileName);

		if (isDepartmenalSharing && !userBean.isAdmin()) {
			if (userBean.isGroupID("departmental.sharing.superadmin")) {
				return true;
			}

			if (folderName.endsWith("Administration") ||
					folderName.endsWith("Ancillary") ||
					folderName.endsWith("Nursing") ||
					folderName.endsWith("Support") ||
					folderName.endsWith("Corporate")) {
				if (userBean.isGroupID("departmental.sharing.admin")) {
					return true;
				}

				if (fileName.indexOf("(D_") > -1) {
					int dptCodeIndex = fileName.indexOf("(D_");
					String deptCode = fileName.substring(dptCodeIndex, fileName.indexOf(")", dptCodeIndex));
					deptCode = deptCode.substring(3);


					if (userBean.getDeptCode().equals(deptCode) ||
							(DepartmentDB.getDeptHeadID(deptCode) != null &&
									DepartmentDB.getDeptHeadID(deptCode).equals(userBean.getStaffID()))) {
						return true;
					}

					if (hrSuper.equals(userBean.getStaffID()) && hrCode.equals(deptCode)) {
						return true;
					}
				} else if (fileName != null && fileName.indexOf("(S_") > -1) {
					//System.out.println(2);
					//System.out.println("Checking Staff");
					int staffCodeIndex = fileName.indexOf("(S_");
					//System.out.println(staffCodeIndex);
					String staffCode = fileName.substring(staffCodeIndex, fileName.indexOf(")", staffCodeIndex));
					//System.out.println(staffCode);
					staffCode = staffCode.substring(3);
					//System.out.println(staffCode);

					if (userBean.getStaffID().equals(staffCode)) {
						return true;
					}
				} else if (fileName != null && fileName.indexOf("(G_") > -1) {
					int grpCodeIndex = fileName.indexOf("(G_");
					String grpCode = fileName.substring(grpCodeIndex, fileName.indexOf(")", grpCodeIndex));
					grpCode = grpCode.substring(3);
					String groupId = AccessControlDB.CUSTOME_GRP_CODE_PREFIX.concat(grpCode);
					if (userBean.isGroupID(groupId)) {
						return true;
					}
				}

				return false;
			} else if (isDepartmentalSharingPublicFolder(folderName) ||
					isDepartmentalSharingPublicFolder(fileName)) {

				return true;
			} else if (isDepartmentalSharingDepartmentFolder(folderName) ||
					isDepartmentalSharingDepartmentFolder(fileName)) {
				if (folderName.indexOf("Template") > -1) {
					return true;
				}

				if (userBean.isGroupID("departmental.sharing.admin")) {
					return true;
				}

				if (folderName.indexOf("(D_") > -1) {
					int dptCodeIndex = folderName.indexOf("(D_");
					String deptCode = folderName.substring(dptCodeIndex, folderName.indexOf(")", dptCodeIndex));
					deptCode = deptCode.substring(3);

					if (userBean.getDeptCode().equals(deptCode) ||
							(DepartmentDB.getDeptHeadID(deptCode) != null &&
									DepartmentDB.getDeptHeadID(deptCode).equals(userBean.getStaffID()))) {
						return true;
					}

					if (hrSuper.equals(userBean.getStaffID()) && hrCode.equals(deptCode)) {
						return true;
					}
				} else if (folderName != null && folderName.indexOf("(S_") > -1) {
					//System.out.println(2);
					//System.out.println("Checking Staff");
					int staffCodeIndex = folderName.indexOf("(S_");
					//System.out.println(staffCodeIndex);
					String staffCode = folderName.substring(staffCodeIndex, folderName.indexOf(")", staffCodeIndex));
					//System.out.println(staffCode);
					staffCode = staffCode.substring(3);
					//System.out.println(staffCode);

					if (userBean.getStaffID().equals(staffCode)) {
						return true;
					}
				} else if (folderName != null && folderName.indexOf("(G_") > -1) {
					int grpCodeIndex = fileName.indexOf("(G_");
					String grpCode = folderName.substring(grpCodeIndex, folderName.indexOf(")", grpCodeIndex));
					grpCode = grpCode.substring(3);
					String groupId = AccessControlDB.CUSTOME_GRP_CODE_PREFIX.concat(grpCode);
					if (userBean.isGroupID(groupId)) {
						return true;
					}
				}
				return false;
			} else {
				if ((folderName != null && folderName.indexOf("High Solid Low Report") > -1) ||
						(fileName != null && fileName.indexOf("High Solid Low Report") > -1) ||
						(folderName != null && folderName.indexOf(". Budget") > -1) ||
						(fileName != null && fileName.indexOf(". Budget") > -1) ||
						(folderName != null && folderName.indexOf(". Stop Light Report") > -1) ||
						(fileName != null && fileName.indexOf(". Stop Light Report") > -1)) {
					//System.out.println(2);

					if (folderName.indexOf("Template") > -1) {
						return true;
					}

					//System.out.println(folderName);
					if (userBean.getStaffID().equals(vpf) &&
							((folderName != null && folderName.indexOf(". Budget") > -1) ||
							(fileName != null && fileName.indexOf(". Budget") > -1))) {
						return true;
					}
					if (userBean.getStaffID().equals(hrDirector) &&
							((folderName != null && folderName.indexOf("High Solid Low Report") > -1) ||
							(fileName != null && fileName.indexOf("High Solid Low Report") > -1) ||
							(folderName != null && folderName.indexOf(". Stop Light Report") > -1) ||
							(fileName != null && fileName.indexOf(". Stop Light Report") > -1))) {
						return true;
					} else {
						if (folderName.indexOf("(D_") > -1) {
							int dptCodeIndex = folderName.indexOf("(D_");
							String deptCode = folderName.substring(dptCodeIndex, folderName.indexOf(")", dptCodeIndex));
							deptCode = deptCode.substring(3);

							if (userBean.getDeptCode().equals(deptCode) ||
									(DepartmentDB.getDeptHeadID(deptCode) != null &&
									DepartmentDB.getDeptHeadID(deptCode).equals(userBean.getStaffID()))) {
								String deptHeadID = DepartmentDB.getDeptHeadID(deptCode);
								if (deptHeadID != null && deptHeadID.equals(userBean.getStaffID())) {
									return true;
								}
							}

							if (hrSuper.equals(userBean.getStaffID()) && hrCode.equals(deptCode)) {
								return true;
							}
						} else if (folderName != null && folderName.indexOf("(S_") > -1) {
							//System.out.println(2);
							//System.out.println("Checking Staff");
							int staffCodeIndex = folderName.indexOf("(S_");
							//System.out.println(staffCodeIndex);
							String staffCode = folderName.substring(staffCodeIndex, folderName.indexOf(")", staffCodeIndex));
							//System.out.println(staffCode);
							staffCode = staffCode.substring(3);
							//System.out.println(staffCode);

							if (userBean.getStaffID().equals(staffCode)) {
								return true;
							}
						} else if (folderName != null && folderName.indexOf("(G_") > -1) {
							int grpCodeIndex = fileName.indexOf("(G_");
							String grpCode = folderName.substring(grpCodeIndex, folderName.indexOf(")", grpCodeIndex));
							grpCode = grpCode.substring(3);
							String groupId = AccessControlDB.CUSTOME_GRP_CODE_PREFIX.concat(grpCode);
							if (userBean.isGroupID(groupId)) {
								return true;
							}
						}

						return false;
					}
				} else {
					if (folderName.indexOf("Template") > -1) {
						return true;
					}

					if (folderName.indexOf("(D_") > -1) {
						int dptCodeIndex = folderName.indexOf("(D_");
						String deptCode = folderName.substring(dptCodeIndex, folderName.indexOf(")", dptCodeIndex));
						deptCode = deptCode.substring(3);

						if (userBean.getDeptCode().equals(deptCode) ||
								(DepartmentDB.getDeptHeadID(deptCode) != null &&
										DepartmentDB.getDeptHeadID(deptCode).equals(userBean.getStaffID()))) {
							String deptHeadID = DepartmentDB.getDeptHeadID(deptCode);
							if (deptHeadID != null && deptHeadID.equals(userBean.getStaffID())) {
								return true;
							}
						}

						if (hrSuper.equals(userBean.getStaffID()) && hrCode.equals(deptCode)) {
							return true;
						}
					} else if (folderName != null && folderName.indexOf("(S_") > -1) {
						//System.out.println(2);
						//System.out.println("Checking Staff");
						int staffCodeIndex = folderName.indexOf("(S_");
						//System.out.println(staffCodeIndex);
						String staffCode = folderName.substring(staffCodeIndex, folderName.indexOf(")", staffCodeIndex));
						//System.out.println(staffCode);
						staffCode = staffCode.substring(3);
						//System.out.println(staffCode);

						if (userBean.getStaffID().equals(staffCode)) {
							return true;
						}
					} else if (folderName != null && folderName.indexOf("(G_") > -1) {
						int grpCodeIndex = fileName.indexOf("(G_");
						String grpCode = folderName.substring(grpCodeIndex, folderName.indexOf(")", grpCodeIndex));
						grpCode = grpCode.substring(3);
						String groupId = AccessControlDB.CUSTOME_GRP_CODE_PREFIX.concat(grpCode);
						if (userBean.isGroupID(groupId)) {
							return true;
						}
					}
					return false;
				}
			}
		} else if (isFdSharing) {
			if (userBean.isAdmin()) {
				return true;
			}
			
			boolean result = false;
			String folderDesc = null;
			//System.out.println("[directory] checkShowFolder folderName="+folderName+", fileName="+fileName);
			
			if (folderName != null && !folderName.isEmpty()) {
				String[] folderNames = folderName.split("/");
				if (folderNames != null &&  folderNames.length > 0) {
					if (folderNames.length > 1) {
						// check top level only
						folderDesc = folderNames[1];
					} else if (folderNames.length > 0) {
						// check top level only
						folderDesc = folderNames[0];
					}
				}
			} else {
				folderDesc = fileName;
			}
			
			if (folderDesc != null && userBean.isAccessible(AccessControlDB.getFunctionIDbyDesc(folderDesc))) {
				result = true;
			}	
			
			//System.out.println("   result="+result);
			return result;
		} else {
			return true;
		}
	}
%>
<%
if (session == null) {
	%><jsp:forward page="../common/access_deny.jsp" /><%
} else {
	UserBean userBean = new UserBean(request);
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm:ss");
	String rootFolder = request.getParameter("rootFolder");
	if (rootFolder == null) {
		rootFolder = ConstantsServerSide.DOCUMENT_FOLDER;
	}
	String locationPath = TextUtil.parseStrUTF8(request.getParameter("locationPath"));

	// show file
	String allowSelectFile = request.getParameter("allowSelectFile");
	boolean isAllowSelectFile = allowSelectFile != null && "Y".equals(allowSelectFile);

	// show subfolder files
	String showSubFolder = request.getParameter("showSubFolder");
	boolean isShowSubFolder = showSubFolder != null && "Y".equals(showSubFolder);
	int showSubFolderLevel = 0;
	if (isShowSubFolder) {
		try {
			showSubFolderLevel = Integer.parseInt(request.getParameter("showSubFolderLevel"));
		} catch (Exception e) {}
	}
	String policyYN = request.getParameter("policyYN");
	String icYN = request.getParameter("icYN");
	String departmentalSharingYN = request.getParameter("departmentalSharingYN");
	String fdSharingYN = request.getParameter("fdSharingYN");
	String vpaYN = request.getParameter("vpaYN");
	String deptResourceYN = request.getParameter("deptResourceYN");
	String embedVideoYN = request.getParameter("embedVideoYN");
	String hrImgYN = request.getParameter("hrImgYN");
	boolean isHRImg = ConstantsVariable.YES_VALUE.equals(hrImgYN);
	boolean isPolicy = ConstantsVariable.YES_VALUE.equals(policyYN);
	boolean isIC = ConstantsVariable.YES_VALUE.equals(icYN);
	// check permission
	boolean isPemitted = true;
	boolean isDepartmentalSharing = ConstantsVariable.YES_VALUE.equals(departmentalSharingYN);
	boolean isFdSharing = ConstantsVariable.YES_VALUE.equals(fdSharingYN);
	boolean isVPA = ConstantsVariable.YES_VALUE.equals(vpaYN);
	boolean isDeptResource = ConstantsVariable.YES_VALUE.equals(deptResourceYN);
	boolean isEmbedVideo = ConstantsVariable.YES_VALUE.equals(embedVideoYN);
	int hrPicCount = 0;
	
	System.out.println("[directory2] rootFolder="+rootFolder+", locationPath="+locationPath);
	
	// check OS
	String fullPath = (rootFolder == null ? "" : rootFolder) + locationPath;
	SmbFile smbDirectory = null;
	File directory = null;
	String path = null;
	boolean useSamba = false;
	NtlmPasswordAuthentication smbAuth = new NtlmPasswordAuthentication("",CMSDB.sysparams.get("smb_username"), CMSDB.sysparams.get("smb_password"));
	if (ServerUtil.isUseSamba(fullPath)) {
		useSamba = true;
		smbDirectory = new SmbFile("smb:" + fullPath.replace("\\", "/"), smbAuth);
		path = smbDirectory.getPath();
	} else {
		directory = new File(rootFolder + locationPath);
		path = directory.getPath();
	}
	//	File directory = new File(rootFolder + locationPath);

	SmbFile smbFile = null;
	File file = null;
	try {
		path = path.replace('\\', '/');
		int index = -1;
		if ((index = path.lastIndexOf("/")) >= 0) {
			path = path.substring(0, index);
		}
		// show go to previous directory icon
		if (!isShowSubFolder && path.length() >= (useSamba ? smbDirectory.getPath().length() : directory.getPath().length())) {
			path = path.substring(rootFolder.length()).replace('\\', '/');
%>
	<tr>
		<td colspan="4"><a href="javascript:moveDirectory('<%=StringEscapeUtils.escapeJavaScript(path) %>')"><img src="../images/undo2.gif">Parent Directory</a></td>
	</tr>
<%
		}
				
		String[] children = (useSamba ? smbDirectory.list() : directory.list());
		Arrays.sort(children, new AlphanumComparator());

		String newLocationPath = null;
		for (int i=0; i<children.length; i++) {
			if (useSamba) {
				smbFile = new SmbFile("smb:" + (rootFolder + locationPath + "/" + children[i]).replace("\\", "/"), smbAuth);
			} else {
				file = new File(rootFolder + locationPath + "/" + children[i]);
			}
			
			if ((!useSamba && file.isDirectory()) || (useSamba && smbFile.isDirectory())) {
				newLocationPath = locationPath + "/" + children[i];
				if (isShowSubFolder &&
						checkShowFolder(userBean, locationPath, file.getName(), isDepartmentalSharing, isFdSharing)) {			// show the child folder files
					if (showSubFolderLevel == 0) {
%>
	<table cellpadding="0" cellspacing="0" class="contentFrameMenu" border="1">
<%
					}
%>
	<tr class="middleText">
		<td colspan="2" align="left"><%=isDepartmentalSharing?
			(children[i].indexOf("(D_")>-1?children[i].substring(0, children[i].indexOf("(D_")):
			((children[i].indexOf("(S_")>-1?children[i].substring(0, children[i].indexOf("(S_")):children[i]))):
			children[i] %></td>
	</tr>
<%
					if (showSubFolderLevel == 0) {
%>
	<tr>
		<th width="80%" align="center"><bean:message key="prompt.name" /></th>
		<th width="20%" align="center">Link</th>
	</tr>
<%
					}
%>
<jsp:include page="directory2.jsp" flush="false">
	<jsp:param name="locationPath" value="<%=newLocationPath %>" />
	<jsp:param name="allowSelectFile" value="<%=allowSelectFile %>" />
	<jsp:param name="showSubFolder" value="<%=showSubFolder %>" />
	<jsp:param name="showSubFolderLevel" value="<%=showSubFolderLevel + 1 %>" />
	<jsp:param name="policyYN" value="<%=policyYN %>" />
	<jsp:param name="departmentalSharingYN" value="<%=departmentalSharingYN %>" />
	<jsp:param name="fdSharingYN" value="<%=fdSharingYN %>" />
</jsp:include>
<%
					if (showSubFolderLevel == 0) {
%>
	</table><br><br><br>
<%
					}
				} else {
					if (checkShowFolder(userBean, locationPath, file.getName(), isDepartmentalSharing,isHRImg, isFdSharing)) {	
						%>
							<tr class="bigText">
								<td>
						<%if (userBean.isLogin() && 
								(checkEditPermission(userBean, locationPath, isPolicy, isDepartmentalSharing, isVPA, isDeptResource, isFdSharing) || isIC)) { %>	
								<%if(isIC && file.list().length == 0) {%>	
									<a href="javascript:void()" onclick="deleteFile('<%=StringEscapeUtils.escapeJavaScript(children[i]) %>');"><img src="../images/cross_red_small.gif"></a>&nbsp;
									
								<%} %>	
									<a href="javascript:void()" onclick="renameAction(0, '<%=StringEscapeUtils.escapeJavaScript(children[i]) %>');"><img src="../images/edit1.png"></a>&nbsp;
								</td>
						<%}if( isHRImg && newLocationPath.contains("resized")){
						  }else{%>
								<td><a href="javascript:moveDirectory('<%=StringEscapeUtils.escapeJavaScript(newLocationPath) %>')"><img src="../images/folder.gif" width="24" height="24"><%=isDepartmentalSharing?
																																																	(children[i].indexOf("(D_")>-1?children[i].substring(0, children[i].indexOf("(D_")):
																																																		((children[i].indexOf("(S_")>-1?children[i].substring(0, children[i].indexOf("(S_")):children[i]))):
																																																	children[i] %></a></td>
								<td>&nbsp;</td>
								<td><%=sdf.format(new java.util.Date(useSamba ? smbFile.lastModified() : file.lastModified())) %></td>
							</tr>
						<%}
					}
				}
				} else if ("Thumbs.db".equals(children[i])) {
					// do nothing to skip it
				} else if (isHRImg) {
					if (hrPicCount == 0) {
%>	<tr>
<%
					}
%>
		<td><a href="javascript:downloadFileByFilePath('<%=StringEscapeUtils.escapeJavaScript(locationPath) %>/<%=StringEscapeUtils.escapeJavaScript(children[i]) %>')">
			<% String imgPath = "\\"+rootFolder.replace("\\\\","\\")+locationPath.substring(1)+"\\resized\\"+children[i]; %>
			<img src="<%=imgPath%>" width="300" height="200">
			<%=isDepartmentalSharing?
				(children[i].indexOf("(D_")>-1?children[i].substring(0, children[i].indexOf("(D_")):
				((children[i].indexOf("(S_")>-1?children[i].substring(0, children[i].indexOf("(S_")):children[i]))):
				children[i] %></a>
		</td>
<%
					hrPicCount++;
					if (hrPicCount == 4) {
%>
	</tr>
<%
					hrPicCount = 0;
				}
			} else if (isAllowSelectFile // allow to select files
					&& isPemitted) { // check permission
				if (isShowSubFolder &&
					checkShowFolder(userBean, locationPath, "", isDepartmentalSharing, isFdSharing)) {									// show the child folder files
%>
	<tr class="bigText">
		<td></td>
		<td><img src="../<%=IconSelector.selectIcon(children[i]) %>" width="24" height="24"><%=isDepartmentalSharing?
																									(children[i].indexOf("(D_")>-1?children[i].substring(0, children[i].indexOf("(D_")):
																										((children[i].indexOf("(S_")>-1?children[i].substring(0, children[i].indexOf("(S_")):children[i]))):
																									children[i] %></td>
		<td align="center"><a href="javascript:downloadFileByFilePath('<%=StringEscapeUtils.escapeJavaScript(locationPath) %>/<%=StringEscapeUtils.escapeJavaScript(children[i]) %>')">Click Here<img src="../images/save.gif"></a></td>
	</tr>
<%
				} else {
					if (checkShowFolder(userBean, locationPath, "", isDepartmentalSharing, isFdSharing)) {
						if (isPolicy) {
//							if (ConstantsServerSide.isTWAH() || (userBean.isAdmin() && checkEditPermission(userBean, locationPath, isPolicy, isDepartmentalSharing, isVPA) || isIC) ||
//								(!Converter.isFileExtensionAllowed(FilenameUtils.getExtension(StringEscapeUtils.escapeJavaScript(children[i]))) && !StringEscapeUtils.escapeJavaScript(children[i]).trim().endsWith(".pdf"))) {

							if ((userBean.isLogin() && (checkEditPermission(userBean, locationPath, isPolicy, isDepartmentalSharing, isVPA, isDeptResource, isFdSharing) || isIC)) || (!Converter.isFileExtensionAllowed(FilenameUtils.getExtension(StringEscapeUtils.escapeJavaScript(children[i]))) && !StringEscapeUtils.escapeJavaScript(children[i]).trim().endsWith(".pdf"))) {
								if (!StringEscapeUtils.escapeJavaScript(children[i]).trim().endsWith(".pdf") && ConstantsServerSide.isHKAH()) {	// test by Ricky, not show pdf for dept policy operator
%>
<tr class="bigText">
		<td>
<%
									if (userBean.isLogin() && (checkEditPermission(userBean, locationPath, isPolicy, isDepartmentalSharing, isVPA, isDeptResource, isFdSharing) || isIC)) {
%>
			<a href="javascript:void()" onclick="renameAction(0, '<%=StringEscapeUtils.escapeJavaScript(children[i]) %>');"><img src="../images/edit1.png"></a>&nbsp;
			<a href="javascript:void()" onclick="deleteFile('<%=StringEscapeUtils.escapeJavaScript(children[i]) %>');"><img src="../images/cross_red_small.gif"></a>&nbsp;
<%
									}
%>
		</td>
		<td>
			<a href="javascript:downloadFileByFilePath('<%=StringEscapeUtils.escapeJavaScript(locationPath) %>/<%=StringEscapeUtils.escapeJavaScript(children[i]) %>')"><img src="../<%=IconSelector.selectIcon(children[i]) %>" width="24" height="24"><%=isDepartmentalSharing?
				(children[i].indexOf("(D_")>-1?children[i].substring(0, children[i].indexOf("(D_")):
				((children[i].indexOf("(S_")>-1?children[i].substring(0, children[i].indexOf("(S_")):children[i]))):
				children[i] %></a>
		</td>
		<td><%=(useSamba ? smbFile.length() : file.length())/1024 %>KB</td>
		<td><%=sdf.format(new java.util.Date(useSamba ? smbFile.lastModified() : file.lastModified())) %></td>
	</tr>
<%
								}	// test by Ricky
								
								if (ConstantsServerSide.isTWAH()) {	
%>
<tr class="bigText">
		<td>
<%
									if (userBean.isLogin() && (checkEditPermission(userBean, locationPath, isPolicy, isDepartmentalSharing, isVPA, isDeptResource, isFdSharing) || isIC)) {
%>
			<a href="javascript:void()" onclick="renameAction(0, '<%=StringEscapeUtils.escapeJavaScript(children[i]) %>');"><img src="../images/edit1.png"></a>&nbsp;
			<a href="javascript:void()" onclick="deleteFile('<%=StringEscapeUtils.escapeJavaScript(children[i]) %>');"><img src="../images/cross_red_small.gif"></a>&nbsp;
<%
									}
%>
		</td>
		<td>
			<a href="javascript:downloadFileByFilePath('<%=StringEscapeUtils.escapeJavaScript(locationPath) %>/<%=StringEscapeUtils.escapeJavaScript(children[i]) %>')"><img src="../<%=IconSelector.selectIcon(children[i]) %>" width="24" height="24"><%=isDepartmentalSharing?
				(children[i].indexOf("(D_")>-1?children[i].substring(0, children[i].indexOf("(D_")):
				((children[i].indexOf("(S_")>-1?children[i].substring(0, children[i].indexOf("(S_")):children[i]))):
				children[i] %></a>
		</td>
		<td><%=(useSamba ? smbFile.length() : file.length())/1024 %>KB</td>
		<td><%=sdf.format(new java.util.Date(useSamba ? smbFile.lastModified() : file.lastModified())) %></td>
	</tr>
<%
								}
								
							} else {
								if (ConstantsServerSide.isTWAH()) {
%>
	<tr class="bigText">
		<td>
<%
									if (userBean.isLogin() &&
										(checkEditPermission(userBean, locationPath, isPolicy, isDepartmentalSharing, isVPA, isDeptResource, isFdSharing) || isIC)) {
%>
			<a href="javascript:void()" onclick="renameAction(0, '<%=StringEscapeUtils.escapeJavaScript(children[i]) %>');"><img src="../images/edit1.png"></a>&nbsp;
			<a href="javascript:void()" onclick="deleteFile('<%=StringEscapeUtils.escapeJavaScript(children[i]) %>');"><img src="../images/cross_red_small.gif"></a>&nbsp;
<%
									}
%>
		</td>
		<td>
			<a href="javascript:downloadFileByFilePath('<%=StringEscapeUtils.escapeJavaScript(locationPath) %>/<%=StringEscapeUtils.escapeJavaScript(children[i]) %>')"><img src="../<%=IconSelector.selectIcon(children[i]) %>" width="24" height="24"><%=isDepartmentalSharing?
				(children[i].indexOf("(D_")>-1?children[i].substring(0, children[i].indexOf("(D_")):
				((children[i].indexOf("(S_")>-1?children[i].substring(0, children[i].indexOf("(S_")):children[i]))):
				children[i] %></a>
		</td>
		<td><%=(useSamba ? smbFile.length() : file.length())/1024 %>KB</td>
		<td><%=sdf.format(new java.util.Date(useSamba ? smbFile.lastModified() : file.lastModified())) %></td>
	</tr>
<%
								} else if (StringEscapeUtils.escapeJavaScript(children[i]).trim().endsWith(".pdf")) {
%>
	<tr class="bigText">
		<td></td>
		<td>

<%
									String sourcePath = rootFolder + locationPath + "/" + children[i];
									String fileName = children[i];
%>
<% if ("achs".equals(userBean.getLoginID())) { %>
	<a href="javascript:downloadFileByFilePath('<%=StringEscapeUtils.escapeJavaScript(locationPath) %>/<%=StringEscapeUtils.escapeJavaScript(children[i]) %>')">
<% } else { %>
	<a href="javascript:showPdfjs('<%=sourcePath.replaceAll("\\\\" , "/").replace("'", "\\'")%>', '<%=fileName.replace("'", "\\'")%>')">
<% } %>
			<img src="../<%=IconSelector.selectIcon(children[i]) %>" width="24" height="24"><%=isDepartmentalSharing?
					(children[i].indexOf("(D_")>-1?children[i].substring(0, children[i].indexOf("(D_")):
					((children[i].indexOf("(S_")>-1?children[i].substring(0, children[i].indexOf("(S_")):children[i]))):
					children[i] %></a>
		</td>
		<td><%=(useSamba ? smbFile.length() : file.length())/1024 %>KB</td>
		<td><%=sdf.format(new java.util.Date(useSamba ? smbFile.lastModified() : file.lastModified())) %></td>
	</tr>
<%
								}
							}
						} else {
%>
	<tr class="bigText">
		<td>
<%
						if (userBean.isLogin() && (checkEditPermission(userBean, locationPath, isPolicy, isDepartmentalSharing, isVPA, isDeptResource, isFdSharing) || isIC)) {
%>
			<a href="javascript:void()" onclick="renameAction(0, '<%=StringEscapeUtils.escapeJavaScript(children[i]) %>');"><img src="../images/edit1.png"></a>&nbsp;
			<a href="javascript:void()" onclick="deleteFile('<%=StringEscapeUtils.escapeJavaScript(children[i]) %>');"><img src="../images/cross_red_small.gif"></a>&nbsp;
<% } %>
		</td>
		<td>
<% 
	String jsFn = null;
	if (isEmbedVideo && FileUtil.isVideo(children[i])) {
		jsFn = "playVideo";
	} else {
		jsFn = "downloadFileByFilePath";
	}
%>		
			<a href="javascript:<%=jsFn %>('<%=StringEscapeUtils.escapeJavaScript(locationPath) %>/<%=StringEscapeUtils.escapeJavaScript(children[i]) %>')"><img src="../<%=IconSelector.selectIcon(children[i]) %>" width="24" height="24"><%=isDepartmentalSharing?
				(children[i].indexOf("(D_")>-1?children[i].substring(0, children[i].indexOf("(D_")):
				((children[i].indexOf("(S_")>-1?children[i].substring(0, children[i].indexOf("(S_")):children[i]))):
				children[i] %></a>
		</td>
<% if (!isEmbedVideo) { %>
		<td><%=(useSamba ? smbFile.length() : file.length())/1024 %>KB</td>
		<td><%=sdf.format(new java.util.Date(useSamba ? smbFile.lastModified() : file.lastModified())) %></td>
<% } %>		
	</tr>
<%
						}
					}
				}
			} else { // now allow to select files
				if (isShowSubFolder && checkShowFolder(userBean, locationPath, "", isDepartmentalSharing, isFdSharing)) { // show the child folder files
%> 
	<tr class="bigText">
		<td><img src="../<%=IconSelector.selectIcon(children[i]) %>" width="24" height="24"><%=isDepartmentalSharing?
			(children[i].indexOf("(D_")>-1?children[i].substring(0, children[i].indexOf("(D_")):
			((children[i].indexOf("(S_")>-1?children[i].substring(0, children[i].indexOf("(S_")):children[i]))):
			children[i] %></td>
		<td align="center"><img src="../images/save.gif"></td>
	</tr>
<%
				} else {
					if (checkShowFolder(userBean, locationPath, "", isDepartmentalSharing, isFdSharing)) {
%>
	<tr class="bigText">
		<td></td>
		<td><img src="../<%=IconSelector.selectIcon(children[i]) %>" width="24" height="24"><%=isDepartmentalSharing?
			(children[i].indexOf("(D_")>-1?children[i].substring(0, children[i].indexOf("(D_")):
			((children[i].indexOf("(S_")>-1?children[i].substring(0, children[i].indexOf("(S_")):children[i]))):
			children[i] %></td>
		<td><%=(useSamba ? smbFile.length() : file.length())/1024 %>KB</td>
		<td><%=sdf.format(new java.util.Date(useSamba ? smbFile.lastModified() : file.lastModified())) %></td>
	</tr>
<%
					}
				}
			}
		}
	} catch (Exception e) {
		e.printStackTrace();
	}
%>
<script language="javascript">
function convertPdfToSwf(source, file) {

		var sourcePath = 'sourcePath=' + encodeURIComponent(source);
		var fileName = 'fileName=' + encodeURIComponent(file);

		var baseUrl ='../common/convertPdfToSwf.jsp';
		var url = baseUrl + '?' + sourcePath + '&' + fileName;
		window.open(url);
}

function showPdfjs(source, file) {
	var sourcePath = 'sourcePath=' + encodeURIComponent(source);
	var fileName = 'fileName=' + encodeURIComponent(file);
	var param = {
		rootFolder : encodeURIComponent(source),
		locationPath : "",
		allowPresentationMode : "Y",
		allowOpenFile : "N",
		allowDownload : "N",
		allowPrint : "N"
	};
	
	var queryStr = "";
	for (var name in param) {
	    queryStr = queryStr + "&" + name + "=" + param[name];
	}

	var baseUrl ='../documentManage/pdfjs/web/viewer.jsp';
	var url = baseUrl + '?' + queryStr;	
	//alert('url='+url);
	callPopUpWindow(url);
}
</script>
<%
}
%>