<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.math.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.regex.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.helper.*"%>
<%@ page import="com.hkah.convert.*"%>
<%@ page import="java.io.*"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%!
%>
<%	
UserBean userBean = new UserBean(request);
response.setHeader("Pragma","no-cache");
response.setHeader("Pragma-directive","no-cache");
response.setHeader("Cache-directive","no-cache");
response.setHeader("Cache-control","no-cache");
response.setHeader("Expires","0");


String labLogID = ParserUtil.getParameter(request, "labLogID");
String labNum = "";
String testCat = "";
String rptNo = "";
String destinationDir = "";
String filePath = "";

String sLoginID = CMSDB.getDocLoginID(labLogID);
ArrayList<String> imageName = new ArrayList<String>();
boolean allowReadDoc = false;

// copy from convertPdf.jsp
String oldLabLogID = labLogID;
labLogID = CMSDB.getLatestUnblockLogID(labLogID);

ArrayList labLogList = CMSDB.getLabLogDetail(labLogID);
for (int i = 0; i < labLogList.size(); i++) {			
	ReportableListObject row = (ReportableListObject) labLogList.get(0);
	labNum = row.getValue(0);
	testCat = row.getValue(1);
	rptNo = row.getValue(2);
	filePath = row.getValue(3);
}
if (userBean.isLogin()) {
	if(labNum != null && labNum.length() > 0){
		if(CMSDB.allowReadDoc(userBean, labLogID) || userBean.isAdmin() || userBean.isAccessible("function.lab.document.view")){
			allowReadDoc = true;
		}
	}
	if(allowReadDoc){
		CMSDB.updateReadDoc(userBean, labLogID);
		if(ConstantsServerSide.DEBUG) {
			destinationDir = CMSDB.getCMSLabReportImagePath(); // converted images from pdf document are saved here	
		}

		File folder = new File(CMSDB.getCMSLabReportImagePath() + labNum + "\\" + testCat + "\\" + rptNo + "\\" );
		if (folder != null){
			File[] listOfFiles = folder.listFiles();			
			for (int i = 0; i < listOfFiles.length; i++) {
			  if (listOfFiles[i].isFile()) {    
			    imageName.add(listOfFiles[i].getName());
			  } 
			}
		}
		Collections.sort(imageName, new Comparator<String>() {
	        public int compare(String s1, String s2) {
	        	  try {
	                  int i1 = Integer.parseInt(s1.split(".png")[0]);
	                  int i2 = Integer.parseInt(s2.split(".png")[0]);
	                  return i1 - i2;
	              } catch(NumberFormatException e) {
	                  throw new AssertionError(e);
	              }
	        }
	    });

		// block 1.1 begin : re-direct the pdf to response
		if(request.getHeader("User-Agent").indexOf("Mobile") != -1) {
			System.out.print("Debug : Mobile Agent");
		} else {
			if (CMSDB.checkReportAvailable(labNum, testCat, rptNo)) {		
				if (allowReadDoc && imageName != null && imageName.size() > 0) {
					String siteCode = "hkah";
					if (ConstantsServerSide.isTWAH()){
						siteCode = "twah";
					}
					String avoidCache = String.valueOf(new Date().getTime());
					String fileName="";
					for (String s : imageName){
						fileName = s;
					}
					
					//String pdfFileName = CMSDB.getCMSLabReportImagePath().replace("\\","/") + rptNo + "/" + fileName ;
					String pdfFileName = filePath ;
					//System.out.println("pdfFileName : " + pdfFileName) ;

					//String contextPath = getServletContext().getRealPath(File.separator);
					//File pdfFile = new File(contextPath + pdfFileName);
					
					File pdfFile = new File(pdfFileName);

					response.setContentType("application/pdf");
					response.setDateHeader("Expires", 1L);
					response.setHeader("Pragma", "no-cache");
					response.setHeader("Cache-Control", "no-cache");
					response.addHeader("Cache-Control", "no-store");
					// below is for download
					//response.addHeader("Content-Disposition", "attachment; filename=" + pdfFileName);
					response.addHeader("Content-Disposition", "inline; filename=" + pdfFileName);
					response.setContentLength((int) pdfFile.length());

					FileInputStream fis = new FileInputStream(pdfFile);
					OutputStream ros = response.getOutputStream();
					int bytes;
					while ((bytes = fis.read()) != -1) {
						ros.write(bytes);
					}
					fis.close();

					ros.flush();
					ros.close();
					return;
					
				}
			}
		}
		// block 1.1 end 

	} else {

%>		
		<script language="javascript">parent.location.href = "../common/access_deny.jsp";</script>
<%

	}
}

%>
<%--
		Licensed to the Apache Software Foundation (ASF) under one or more
		contributor license agreements.  See the NOTICE file distributed with
		this work for additional information regarding copyright ownership.
		The ASF licenses this file to You under the Apache License, Version 2.0
		(the "License"); you may not use this file except in compliance with
		the License.  You may obtain a copy of the License at

				 http://www.apache.org/licenses/LICENSE-2.0

		Unless required by applicable law or agreed to in writing, software
		distributed under the License is distributed on an "AS IS" BASIS,
		WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
		See the License for the specific language governing permissions and
		limitations under the License.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
</jsp:include>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="Lab Report" />
	<jsp:param name="mustLogin" value="Y" />
	<jsp:param name="isHideTitle" value="Y" />
	<jsp:param name="sLoginID" value="<%=sLoginID %>" />
</jsp:include>
<style>​
</style>
<body style="height: 100%;width:100%">
<script type="text/javascript" src="<html:rewrite page="/js/compatibility.js"/>" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/pdf.js"/>" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/pdf.worker.js"/>" /></script>
<% 
if(CMSDB.checkReportAvailable(labNum, testCat, rptNo)){		
	if(allowReadDoc && imageName != null && imageName.size() > 0) {
		String siteCode = "hkah";
		if (ConstantsServerSide.isTWAH()){
			siteCode = "twah";
		}
		String avoidCache = String.valueOf(new Date().getTime());
		String fileName="";
		for(String s : imageName){
			fileName = s;
		}
%>
		<div style='width: 100%;' id="holder"></div>
<script>

//var url = '//mail.' + '<%=siteCode%>' + '.org.hk/cms/TempImage/' + '<%=labNum + "/" + testCat + "/" + rptNo + "/" + fileName%>';
//var url = '//localhost:8080/intranet/cms/281.pdf';
//var url = '<%=CMSDB.getCMSLabReportImagePath().replace("\\","/") + labNum + "/" + testCat + "/" + rptNo + "/" + fileName%>';
var url = '<%=filePath%>';


PDFJS.disableWorker = true;

function printIt() {
    //var wnd = window.open(url);
    //wnd.print();
    
    var canvas = document.getElementById("lab-report") ;
    var win = window.open('', '', '');
    //var html = "<img src='" + canvas.toDataURL() + "'>";
    //var html = "<head> <style type='text/css'> @page { margin: 0; } @media print { @page { size: landscape; margin: 0; } body { margin: 1.6cm; } } </style></head><body> <img src='" + canvas.toDataURL() + "'></body>";
    //var html = "<head> <style type='text/css'> @page { margin: 0; } @media print { @page { size: landscape; margin: 0; } body { margin: 1.6cm; } } </style></head><body> <img src='" + canvas.toDataURL() + "' width='80%' height='80%' type='application/pdf'></body>";
    //var html = "<head> <style type='text/css'> @page { margin: 0; } @media print { @page { size: landscape; margin: 0; } body { margin: 1.6cm; } } </style></head><body> <img src='" + canvas.toDataURL() + "'></body>";
    // for mobile
    var html = "<head></head><body> <img src='" + canvas.toDataURL() + "'></body>";
     
    win.document.write(html);
    win.document.close();
    win.focus();
    win.print();
    win.close();
}

function renderPDF(url, canvasContainer, options) {
  var options = options || { scale: 5 };
      
  function renderPage(page) {	  
      var viewport = page.getViewport(options.scale);
      var canvas = document.createElement('canvas');
      canvas.setAttribute("id", "lab-report");
      var ctx = canvas.getContext('2d');
      var renderContext = {
        canvasContext: ctx,
        viewport: viewport
      };
      
      canvas.height = viewport.height;
      canvas.width = viewport.width;
      var scaleSize =canvas.width /  document.getElementById("holder").offsetWidth;
      canvas.style.width = "100%";
      canvas.style.height = "100%";
      var divHeight = canvas.height / scaleSize;
      document.getElementById('holder').setAttribute("style","height:" + divHeight + "px");
      canvasContainer.appendChild(canvas);
      page.render(renderContext);
  }
  
  function renderPages(pdfDoc) {
      for(var num = 1; num <= pdfDoc.numPages; num++)
          pdfDoc.getPage(num).then(renderPage);
  }
  PDFJS.disableWorker = true;
  /*
  PDFJS.getDocument({
      url: url, password: '12345',
  }).then(renderPages);
  */
  var xhr = new XMLHttpRequest();
  var getLabReportUrl = '/intranet/GetLabReport?url='+ encodeURI(url) ;
  xhr.open('GET', getLabReportUrl, true);
  xhr.onload = function(e) {
      //binary form of ajax response,
      PDFJS.getDocument({data: atob( xhr.responseText ), password: '', }).then(renderPages);
      //PDFJS.getDocument({data: atob( xhr.responseText ), password: '12345', }).then(renderPages);
  };
 
  xhr.send();

}   

renderPDF(url, document.getElementById('holder'));
</script>
		
<%	 } else { %>
		<div style='font-size:190%'>Lab report cannot be found.</div>
<% 	} %>
<% } else { %>
		<div style='font-size:190%'>The result is pending, please call laboratory if required.</div>
<% } %>
<script type="text/javascript" language="JavaScript">
var idleTime = 0;
$(document).ready(function() {
	var idleInterval = setInterval(timerIncrement, 60000); // 1 minute

    //Zero the idle timer on mouse movement.
    $(this).mousemove(function (e) {
        idleTime = 0;
    });
    $(this).keypress(function (e) {
        idleTime = 0;
    });	
});

function timerIncrement() {
	 idleTime = idleTime + 1;
    if (idleTime > 9) { // 10 minutes logout
		window.location="../Logoff.do";
    }
}


</script>
<jsp:include page="../common/footer.jsp" flush="false"/>
</body>
</html:html>