<%@ page import="java.text.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="org.apache.struts.Globals"%>
<%! 
private String showFile(String documentID, String labelTitle,boolean withFolder, boolean latestFile,
		boolean showSubFolder, boolean onlyShowCurrentYear, boolean showPointForm, String Category) {
	
		StringBuffer outputUrl = new StringBuffer();
		if (showPointForm) {
			outputUrl.append("<li>");
		} else {
/* 			outputUrl.append("<tr>");
			outputUrl.append("<td class=\"h1_margin\">"); */
		}
		if (latestFile) {
/* 			outputUrl.append("<a href=\"javascript:void(0);\" target=\"content\" onclick=\"javascript:downloadFile('");
			outputUrl.append(documentID);
			outputUrl.append("', '');\""); */
		} else if (withFolder) {
			outputUrl.append("<a href=\"javascript:slickToggle('");
			outputUrl.append(documentID);
			outputUrl.append("');\"");
		} else {
			outputUrl.append("<a href=\"#\"");
		}
/* 		outputUrl.append(" class=\"topstoryblue\"><H1 id=\"TS\">");
		outputUrl.append(labelTitle);
		outputUrl.append("</H1></a>"); */
		if (withFolder) {
			outputUrl.append("<div id=\"content-");
			outputUrl.append(documentID);
			outputUrl.append("\">");
			outputUrl.append("<ul id=\"\" style=\"padding:12px\">");
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
						documentID, filePrefix, fileSuffix, "/", showSubFolder, onlyShowCurrentYear, outputUrl, Category);
			}
			outputUrl.append("</ul>");
			outputUrl.append("</div>");
		}
		if (showPointForm) {
			outputUrl.append("</li>");
		} else {
/* 			outputUrl.append("</td>");
			outputUrl.append("</tr>"); */
		}
		return outputUrl.toString();

}

private void getFileNameList(String rootFolder, String locationPath,
		String documentID, String filePrefix, String fileSuffix, String fileDirectory,
		boolean showSubFolder, boolean onlyShowCurrentYear, StringBuffer outputUrl,String category) {
	File directory = new File(rootFolder + locationPath + fileDirectory);

	String[] children = directory.list();
	if (children != null && children.length > 0) {
		File newDirectory = null;
		String newFileName = null;
		int fileNameIndex = -1;
		boolean foundMatchFile = false;
/* 		 FilenameFilter filefilter = new FilenameFilter() {

		      public boolean accept(File dir, String name) {
		        //if the file extension is .txt return true, else false
		        return !name.toUpperCase().startsWith("THUMBS");
		      }
		    }; */
		String currentYear = String.valueOf(DateTimeUtil.getCurrentYear());
		try {
			for (int i = 0; i < children.length; i++) {
				newDirectory = new File(directory.toString() + "/" + children[i]);
				if (newDirectory.exists()) {
					if (newDirectory.isFile()
							&& (filePrefix == null || filePrefix.length() == 0 || children[i].indexOf(filePrefix) >= 0)
							&& (fileSuffix == null || fileSuffix.length() == 0 || children[i].indexOf(fileSuffix) > 0)
							&& !"Thumbs.db".equals(children[i])){
						if ("video".equals(category)) {
							outputUrl.append("<a class=\"list-group-item\"><H1 id=\"TS\">");
							outputUrl.append("<button type=\"button\" class=\"btn btn-primary\" data-toggle=\"modal\" data-target=\"#exampleModal\"");
							outputUrl.append("data-title=\""+children[i].substring(0, children[i].indexOf("."))+"\" data-video=\""+children[i]+"\">");							
							outputUrl.append("<span class=\"glyphicon glyphicon-play\"> Play</button>   ");
							outputUrl.append(children[i].substring(0, children[i].indexOf(".")));
							outputUrl.append("</H1></a>");
						
						} else {
								//outputUrl.append("<li style=\"list-style-image: url(../images/ic/starAnimated.gif)\">");
								outputUrl.append("<a href=\"javascript:void(0);\" target=\"content\" onclick=\"javascript:downloadFile('");
								outputUrl.append(documentID);
								outputUrl.append("','");
								outputUrl.append(fileDirectory);
								outputUrl.append(children[i]);
								outputUrl.append("');\" class=\"list-group-item\"><H1 id=\"TS\">");
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
								//outputUrl.append("</li>");
								foundMatchFile = true;
						}
					} else if (newDirectory.isDirectory()) {
						if (showSubFolder) {
/* 							outputUrl.append("<li style=\"list-style-image: url(../images/ic/title.gif)\"><B>");
							outputUrl.append(children[i]);
							outputUrl.append("</B></li>");
							outputUrl.append("<ul style=\" padding-left:20px;\">"); */
							
							outputUrl.append("<div class=\"panel panel-default\">");
							outputUrl.append("<a class=\"list-group-item\" data-toggle=\"collapse\" href=\"#collapse");
							outputUrl.append(children[i].replaceAll("[^A-Za-z0-9]", "")+i);
							outputUrl.append("\">");
							outputUrl.append("<span class=\"badge\">");
							outputUrl.append((newDirectory.list().length)+"</span>"+children[i]);
							outputUrl.append("</a><div class=\"panel-collapse collapse\" id=\"collapse");
							outputUrl.append(children[i].replaceAll("[^A-Za-z0-9]", "")+i);
							outputUrl.append("\"><div class=\"panel-body\">");
							getFileNameList(rootFolder, locationPath,
									documentID, filePrefix, fileSuffix, fileDirectory + children[i] + "/", true, false, outputUrl, null);
							outputUrl.append("</div></div></div>");
						}
					}
				}
			}
		} catch (Exception e) {
		}
	}
}
%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>

<%
UserBean userBean = new UserBean(request);
String category = request.getParameter("Category"); 
String docID = request.getParameter("docID");
String pageTitle = category.toUpperCase();
if ("icpScope".equals(category)) {
	pageTitle = "Scope of Service";
} else if ("icpDeptP".equals(category)) {
	pageTitle = "Department Policy";
} else if ("icpCPOrgCht".equals(category)) {
	pageTitle = "Infection Control Committee - Organisation Chart";
} else if ("icpCPMin".equals(category)) {
	pageTitle = "Infection Control Committee - Minutes";
} else if ("icpLOrgC".equals(category)) {
	pageTitle = "Link Nurse and Link Person - Organisation Chart";
} else if ("icpLMin".equals(category)) {
	pageTitle = "Link Nurse and Link Person - Minutes";
} else if ("icpCPMin".equals(category)) {
	pageTitle = "Minutes";
} else if ("icpProg".equals(category)) {
	pageTitle = "Program";
} else if ("icpAudit".equals(category)) {
	pageTitle = "Audit & Surveillance";
} else if ("icVideo".equals(category)) {
	pageTitle = "Video";
} else if ("icpForm".equals(category)) {
	pageTitle = "Form";
} else if ("icpPoster".equals(category)) {
	pageTitle = "Poster";
} else if ("icpNewsletter".equals(category)) {
	pageTitle = "Newsletter";
} else if ("icpFit".equals(category)) {
	pageTitle = "Fit Test";
} else if ("icpSurveilance".equals(category)) {
	pageTitle = "Surveillance";
} else if ("icpInformation".equals(category)) {
	pageTitle = "Information";
} else if ("icpPolicy".equals(category)) {
	pageTitle = "Policy & Guideline";
}
%>

<%if("disease".equals(category)) { %>
	  <div class="list-group">
	<%
	ArrayList record_dis= ICPageDB.getByCategory("Disease",10);
		if (record_dis.size() > 0) {	
			for(int i=0;i<record_dis.size();i++){
			ReportableListObject row = (ReportableListObject) record_dis.get(i);							
	%>
			<a href="<%=row.getValue(1) %>" target="_blank" class="list-group-item">
		      <p class="list-group-item-text"><%=row.getValue(0) %></p>
		    </a>
	<% 		}
		}
	%>
	  </div>
<%} %>

<%if("calendar".equals(category)) { %>
	 	<ul class="media-list">
		<%
		Integer currentMonth = DateTimeUtil.getCurrentMonth();
		Integer currentYear = DateTimeUtil.getCurrentYear();
		ArrayList record = ICPageDB.getEvent(currentMonth,currentYear); 		
		if (record.size() > 0) {	
			for(int i=0;i<record.size();i++){
			ReportableListObject row = (ReportableListObject) record.get(i);							
	%>
	               <li class="media">
	               <div class="media-left">
	                   <div class="panel panel-danger text-center date">
	                       <div class="panel-heading month">
	                           <span class="panel-title strong">
	                               <%=row.getValue(2) %>
	                           </span>
	                       </div>
	                       <div class="panel-body day text-danger">
	                           <%=row.getValue(3) %>
	                       </div>
	                   </div>
	               </div>
	               <div class="media-body">
	                   <h4 class="media-bottom">
	                      <%=row.getValue(0) %>
	                   </h4>
	               </div>
	           </li>
	<% 		}
		}
	%>				
	 	</ul>
<%} %>
<%if("information".equals(category)) { %>
	  <div class="list-group">
	<%
	ArrayList record_dis= ICPageDB.getByCategory("Information",6);
		if (record_dis.size() > 0) {	
			for(int i=0;i<record_dis.size();i++){
			ReportableListObject row = (ReportableListObject) record_dis.get(i);							
	%>
	    <div class="list-group-item">
	        <div class="media">
	            <div class="media-left">
	                <img src="../images/ic/title.gif" style="width:20px;height:20px"/>
	            </div>
	            <div class="media-body">
	            	<%if ("Y".equals(row.getValue(3))) { %>
	            		<a href="<%=row.getValue(1) %>" target="_blank"><%=row.getValue(0) %></a>
	            	<%} else { %>
                    	<a href="javascript:void(0);" onclick="<%=row.getValue(1) %>" ><%=row.getValue(0) %></a>
                   	<%} %>
	            </div>
	        </div>
	    </div>
	<% 		}
		}
	%>
	  </div>
<%} %>

<%if("isolation".equals(category)) { %>
	<%if (ConstantsServerSide.isTWAH()) {%>
		  <div class="list-group">
		<%
		ArrayList record_dis= ICPageDB.getByCategory("Isolation",10);
			if (record_dis.size() > 0) {	
				for(int i=0;i<record_dis.size();i++){
				ReportableListObject row = (ReportableListObject) record_dis.get(i);							
		%>
			<%if ("Y".equals(row.getValue(3))) { %>
			    <div class="list-group-item">
			        <div class="media">
			            <div class="media-left">
			                <img src="../images/ic/title.gif" style="width:20px;height:20px"/>
			            </div>
			            <div class="media-body">
		                    <a href="<%=row.getValue(1) %>" ><%=row.getValue(0) %></a>
			            </div>
			        </div>
			    </div>	
			<%} else { %>
			    <div class="list-group-item">
			        <div class="media">
			            <div class="media-left">
			                <img src="../images/ic/title.gif" style="width:20px;height:20px"/>
			            </div>
			            <div class="media-body">
		                    <a href="javascript:void(0);" target="content" onclick="javascript:downloadFile('<%=row.getValue(4)%>','/<%=row.getValue(1) %>');" >
		                    <%=row.getValue(0) %></a>
			            </div>
			        </div>
			    </div>			
			<%} %>	
		<% 		}
			}
		%>
		  </div>
	<%} else { %>

					<%=showFile(docID, "", true, true,true,false,false,null) %>

	<%} %>
<%} %>

<%if("icPrac".equals(category)) { %>
<%	
	String newsID = "1";
	String title = null;
	String titleImage = null;
	String newsCategory = "infection control";
	String content = null;
	if (newsID != null && newsID.length() > 0) {
	ArrayList result = null;
	// get news content

		result = NewsDB.get(userBean,newsID, newsCategory);

	if (result.size() > 0) {
		ReportableListObject row = (ReportableListObject) result.get(0);
		title = row.getValue(3);
		titleImage = row.getValue(5);


		StringBuffer contentSB = new StringBuffer();
		result = NewsDB.getContent(newsID, newsCategory);
		if (result != null) {
			for (int i = 0; i < result.size(); i++) {
				row = (ReportableListObject) result.get(i);
				contentSB.append(row.getValue(0));
			}
		}
		content = contentSB.toString();
		}
	} %>
		<div class="container">  
			<div class="panel panel-danger">
				<div class="panel-heading">
					<h3 class="panel-title">Wash HAND !!!</h3>
				</div>
				<div class="panel-body">
	    		<%if (ConstantsServerSide.isTWAH()) {%>
	    			<img class="img-responsive" src="/upload/<%=newsCategory %>/<%=newsID %>/<%=titleImage %>"/>
	    		<%} %>
	    		<br><br>
			    <p class="bg-info"><%=content %></p>
				</div>
			</div>
		</div>
<%} %>

<%if("icVideo".equals(category)) { %>
	<div class="container">  
		<div class="panel panel-danger">
			<div class="panel-heading">
				<h3 class="panel-title">Video</h3>
			</div>
			<div class="panel-body">
<%-- 	<%
	ArrayList record_dis= ICPageDB.getByCategory("Video",5);
		if (record_dis.size() > 0) {	
			for(int i=0;i<record_dis.size();i++){
			ReportableListObject row = (ReportableListObject) record_dis.get(i);				
	%>
			<p class="list-group-item">
				<%=row.getValue(0) %>
				<!-- Button trigger modal -->
				<button type="button" class="btn btn-primary" data-toggle="modal" data-target="#exampleModal" data-whatever="<%=row.getValue(0)%>" data-video="<%=row.getValue(1)%>">
				  Play
				</button>
			</p>
		<%}} %>	 --%>	
		<%=showFile(docID, "", true, true,true,false,false,"video") %>			  
			</div>
		</div>
	</div>
	<!-- Modal -->

<%} %>
<%if(category.startsWith("icp")) { %>
	<div class="container">  
		<div class="panel panel-danger">
		<div class="panel-heading">
			<h3 class="panel-title"><%=pageTitle%></h3>
		</div>
		<div class="panel-body" id="<%=category%>">
			<%=showFile(docID, "", true, true,true,false,false,null) %>
	  </div>
	 </div>
	</div>
<%} %>		

