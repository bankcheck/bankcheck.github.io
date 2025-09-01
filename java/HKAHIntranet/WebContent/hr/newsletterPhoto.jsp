<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
public String[] getImage(String folderName) {
	String[] imageName = null;
	try {
		File directory = new File("\\\\hknas\\TO IT CHERRY\\"+folderName);
		String[] children = directory.list();
		if (children.length > 0) {
			imageName = new String[children.length];
			for (int i = 0; i < children.length; i++) {
					if(children[i] != null && children[i].indexOf(".") > -1) {
						imageName[i] = children[i];
					}
				//}
			}
		}
	} catch (Exception e) {
	}
	return imageName;
}
public String[] getFolder() {
	String[] imageName = null;
	try {
		File directory = new File("\\\\hknas\\TO IT CHERRY\\");
		String[] children = directory.list();
		if (children.length > 0) {
			imageName = new String[children.length];
			for (int i = 0; i < children.length; i++) {
					if(children[i] != null) {
						imageName[i] = children[i];
					}
				//}
			}
		}
	} catch (Exception e) {
	}
	return imageName;
}
%>
<%
String folderName = request.getParameter("folderName");
String type = request.getParameter("type");
UserBean userBean = new UserBean(request);
String userID = request.getParameter("userID");
int hrPicCount = 0;
%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp"/>
	<body>
<table width="100%" cellpadding="0" cellspacing="0" border="0">
	<tr class="smallText">
		<td class="portletCaption"><%if(folderName!=null){%>Folder:<%=folderName %>
									<%}else{%>Newsletter Photo Management<%}%></td>
	</tr>
<%if(userBean.isAdmin()|| "4683".equals(userBean.getStaffID())|| "4683".equals(userID)){ %>
	<tr class="smallText">
		<td class="portletCaption">HyperLink: <a href="http://www-server/intranet/hr/newsletterPhoto.jsp?folderName=<%=folderName %>">
						https://mail.hkah.org.hk/online/hr/newsletterPhoto.jsp?folderName=<%=folderName %>
						</a> </td>
	</tr>
<%} %>
</table>
	<%
	  if("listFolder".equals(type)){
		  	String[] folders = getFolder();
	%><table width="100%" cellpadding="0" cellspacing="0" border="0">
	<%	  	for(String folder: folders) {%>
				<tr class="bigText">
				<a href="https://mail.hkah.org.hk/online/hr/newsletterPhoto.jsp?userID=<%=userBean.getStaffID()%>&folderName=<%=folder%>">
				<%=folder%>
				</a>
				</td></tr>  		
	<%  	}%>
		</table>	
	<%  }else{
			String[] images = getImage(folderName+"\\resized");
	%>
			<div id="main">	
				<div class="panel">
					<ul id='images'>
		<%
				for(String image: images) {
					if ("Thumbs.db".equals(image)) {
						// do nothing to skip it
					}else if(image != null) {
						String imgPath = "https://mail.hkah.org.hk/online/documentManage/download.jsp?hrImgYN=Y&locationPath=\\/"
										 +folderName+"/resized/"+image;
						String orgImgPath = "https://mail.hkah.org.hk/online/documentManage/download.jsp?hrImgYN=Y&locationPath=\\/"
							 +folderName+"/"+image;
						if(hrPicCount ==0){				
						%><tr>
						<%} %>
						 	<td> 
							<a href="<%=orgImgPath%>">
							<img src="<%=imgPath%>" width="300" height="200">
							</a>
							</td>
						 <%hrPicCount++;
						   if(hrPicCount==4){
						 %> </tr>
							<% hrPicCount =0;
							} %>
	<%				}
				}
	   }
	%>
				</ul>
				<div id="controls"></div>
				<div class="clear"></div>
			</div>
			<div id="exposure"></div>			
			<div class="clear"></div>
		</div>
	</body>
</html:html>

<script>
	
</script>
