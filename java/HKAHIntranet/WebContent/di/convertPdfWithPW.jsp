<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.math.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.util.regex.*"%>
<%@ page import="jcifs.smb.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.helper.*"%>
<%@ page import="com.hkah.convert.*"%>
<%@ page import="java.io.*"%>
<%@ page trimDirectiveWhitespaces="true" %>
<%!
// observe from 2018-06-13 to 2018-07-13 before go back to RISDB
public static boolean allowReadDoc(UserBean userBean, String rptLogID, String docCode) {
	StringBuffer sqlStr = new StringBuffer();
	boolean allowReadDoc = false;
	sqlStr.append("SELECT DI_DOCCODE FROM DI_RPT_LOG ");
	sqlStr.append("WHERE  DI_RPT_ID = ? ");
	sqlStr.append("AND    DI_DOCCODE in ");
	sqlStr.append("( ");
	sqlStr.append("	select doccode from doctor@hat ");
	sqlStr.append("	where ");
	sqlStr.append("		mstrdoccode in ");
	sqlStr.append("		(select mstrdoccode from doctor@hat where mstrdoccode = ? or doccode = ?) ");
	sqlStr.append("		or doccode in ");
	sqlStr.append("		(select mstrdoccode from doctor@hat where mstrdoccode = ? or doccode = ?) ");
	sqlStr.append("		or doccode in ");
	sqlStr.append("		(select doccode from doctor@hat where mstrdoccode = ? or doccode = ?) ");
	sqlStr.append(") ");
	sqlStr.append("AND CO_ENABLED = '1' ");

	ArrayList docDocList = UtilDBWeb.getReportableListCIS(sqlStr.toString(),
			new String[]{rptLogID, docCode, docCode, docCode, docCode, docCode, docCode});
	for (int i = 0; i < docDocList.size(); i++) {
		allowReadDoc = true;
	}

	System.out.println("[RISDB] allowReadDoc loginID="+userBean.getLoginID()+", rptLogID="+rptLogID+", docCode="+docCode+", allowReadDoc="+allowReadDoc);

	return allowReadDoc;
}

public static String getDocCode(UserBean userBean) {
	String docCode = "";
	// Lab DI report account is uppercase DR<doccode>
	ArrayList docList = SsoUserDB.getModuleUserIdBySsoUserId("doctor", userBean.getStaffID() == null ? userBean.getLoginID().toUpperCase() : userBean.getStaffID().toUpperCase());
	for (int i = 0; i < docList.size(); i++) {
		ReportableListObject row = (ReportableListObject) docList.get(0);
		if (row.getValue(0) != null && row.getValue(0).length() > 0) {
			docCode = row.getValue(0);
		}
	}
	return docCode;
}

public static boolean updateReadDoc(UserBean userBean, String rptLogID, String docCode) {
	StringBuffer sqlStr = new StringBuffer();
	String staffID = userBean.getStaffID();
	sqlStr.append("UPDATE DI_RPT_LOG SET DI_READDOC_STATUS = '1', ");
	sqlStr.append("       CO_MODIFIED_DATE=SYSDATE, CO_MODIFIED_USER=? ");
	sqlStr.append("WHERE DI_RPT_ID = ? ");
	sqlStr.append("AND   DI_READDOC_STATUS = '0' ");
	sqlStr.append("AND   DI_DOCCODE in ");
	sqlStr.append("( ");
	sqlStr.append("	select doccode from doctor@hat ");
	sqlStr.append("	where ");
	sqlStr.append("		mstrdoccode in ");
	sqlStr.append("		(select mstrdoccode from doctor@hat where mstrdoccode = ? or doccode = ?) ");
	sqlStr.append("		or doccode in ");
	sqlStr.append("		(select mstrdoccode from doctor@hat where mstrdoccode = ? or doccode = ?) ");
	sqlStr.append("		or doccode in ");
	sqlStr.append("		(select doccode from doctor@hat where mstrdoccode = ? or doccode = ?) ");
	sqlStr.append(") ");
	sqlStr.append("AND CO_ENABLED = '1' ");

	System.out.println("[RISDB] updateReadDoc loginID="+userBean.getLoginID()+", rptLogID="+rptLogID+",docCode="+docCode);

	return UtilDBWeb.updateQueueCIS(sqlStr.toString(),
			new String[]{userBean.getLoginID(), rptLogID, docCode, docCode, docCode, docCode, docCode, docCode});
}
%>
<%
UserBean userBean = new UserBean(request);
response.setHeader("Pragma","no-cache");
response.setHeader("Pragma-directive","no-cache");
response.setHeader("Cache-directive","no-cache");
response.setHeader("Cache-control","no-cache");
response.setHeader("Expires","0");

String rptLogID = ParserUtil.getParameter(request, "rptLogID");
String accessionNo = "";
String destinationDir = "";
String docCode = ParserUtil.getParameter(request, "docCode");

String sLoginID = null;
if (docCode != null && docCode.length() > 0) {
	sLoginID = RISDB.getDocLoginID(rptLogID, docCode);
} else {
	System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " [DI report] report invalid or expired. rptLogID="+rptLogID);
	
	%><script>alert('Report is invalid or expired.');</script><%
	return;
}

//blocked or non-existing report
if (rptLogID == null) {
	System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " [DI report] report invalid. docCode="+docCode);
	
	%><script>alert('Report is invalid.');</script><%
	return;
}

ArrayList<String> imageName = new ArrayList<String>();
ArrayList<String> imagePath = new ArrayList<String>();
boolean allowReadDoc = false;

if (userBean != null && userBean.isLogin()) {
	String loginDocCode = getDocCode(userBean);
	ArrayList rptLogList = RISDB.getRptLogDetail(rptLogID, loginDocCode);
	ReportableListObject row = null;
	if (rptLogList.size() > 0) {
		row = (ReportableListObject) rptLogList.get(0);
		docCode = loginDocCode;
		accessionNo = row.getValue(0);
	} else if (userBean.isAdmin() || userBean.isAccessible("function.di.document.view")) {
		if (docCode != null && docCode.length() > 0) {
			rptLogList = RISDB.getRptLogDetail(rptLogID, docCode);
			if (rptLogList.size() > 0) {
				row = (ReportableListObject) rptLogList.get(0);
				accessionNo = row.getValue(0);
			}
		}
	}

	if (accessionNo != null && accessionNo.length() > 0) {
		if (allowReadDoc(userBean, rptLogID, loginDocCode)) {
			allowReadDoc = true;
			updateReadDoc(userBean, rptLogID, loginDocCode);
		} else if (userBean.isAdmin() || userBean.isAccessible("function.di.document.view")) {
			allowReadDoc = true;
		}
	}

	if (allowReadDoc) {
		if (ConstantsServerSide.DEBUG) {
			destinationDir = RISDB.getDIReportImagePath(); // converted images from pdf document are saved here
		}

		File folder = new File(RISDB.getDIReportImagePath() + accessionNo + "\\" );
		if (folder != null) {
			File[] listOfFiles = folder.listFiles();
			for (int i = 0; i < listOfFiles.length; i++) {
				if (listOfFiles[i].isFile()) {
					System.out.print("debug, listOfFiles[i].getPath() " + listOfFiles[i].getPath()+"\n");
					imagePath.add("file:\\" + listOfFiles[i].getPath());
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
		System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " [DI report] Agent: " + request.getHeader("User-Agent"));
		if (request.getHeader("User-Agent").indexOf("Mobile") != -1) {
			System.out.println("  mobile");
		} else {
			if (RISDB.checkReportAvailable(accessionNo)) {
				if (allowReadDoc && imageName != null && imageName.size() > 0) {
					String siteCode = "hkah";
					if (ConstantsServerSide.isTWAH()) {
						siteCode = "twah";
					}
					String avoidCache = String.valueOf(new Date().getTime());
					String fileName="";
					for (String s : imageName) {
						fileName = s;
					}

					String pdfFileName = RISDB.getDIReportImagePath().replace("\\","/") + accessionNo + "/" + fileName ;

					//String pdfFileName = RISDB.getDIReportImagePath() + accessionNo + "\\" + fileName ;
					System.out.println("pdfFileName : " + pdfFileName) ;
					//String contextPath = getServletContext().getRealPath(File.separator);
					//File pdfFile = new File(contextPath + pdfFileName);
					
					boolean isSmaba = false;
					File pdfFile = new File(pdfFileName);
					InputStream in = null;
					SmbFile smbFile = null;
					FileInputStream fis = null;

					if (ServerUtil.isUseSamba(pdfFileName) || !pdfFile.canRead()) {
						isSmaba = true;
						smbFile = new SmbFile("smb:" + pdfFileName.replace("\\", "/"), 
								new NtlmPasswordAuthentication("",CMSDB.sysparams.get("smb_username"), CMSDB.sysparams.get("smb_password")));
						in = new SmbFileInputStream(smbFile);
					} else {
						fis = new FileInputStream(pdfFile);
					}

					response.setContentType("application/pdf");
					response.setDateHeader("Expires", 1L);
					response.setHeader("Pragma", "no-cache");
					response.setHeader("Cache-Control", "no-cache");
					response.addHeader("Cache-Control", "no-store");
					// below is for download
					//response.addHeader("Content-Disposition", "attachment; filename=" + pdfFileName);
					response.addHeader("Content-Disposition", "inline; filename=" + pdfFileName);
					response.setContentLength((int) (isSmaba ? smbFile.length() : pdfFile.length()));

					OutputStream ros = response.getOutputStream();
					if (isSmaba) {
				        byte[] b = new byte[4096];
				        int n, tot = 0;
				        while(( n = in.read( b )) > 0 ) {
				        	ros.write( b, 0, n );
				            tot += n;
				        }
				        in.close();
					} else {
						int bytes;
						while ((bytes = fis.read()) != -1) {
							ros.write(bytes);
						}
						fis.close();	
					}

					ros.flush();
					ros.close();
					return;

				}
			}
		}
		// block 1.1 end
	} else {
		%><script language="javascript">parent.location.href = "../common/access_deny.jsp";</script><%
		return;
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
	<jsp:param name="pageTitle" value="DI Report" />
	<jsp:param name="mustLogin" value="Y" />
	<jsp:param name="isHideTitle" value="Y" />
	<jsp:param name="sLoginID" value="<%=sLoginID %>" />
	<jsp:param name="sSource" value="di" />
</jsp:include>
<body style="width:100%;">
<script type="text/javascript" src="<html:rewrite page="/js/compatibility.js"/>" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/pdf.js"/>" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/pdf.worker.js"/>" /></script>
<%
if (RISDB.checkReportAvailable(accessionNo)) {
	if (allowReadDoc && imageName != null && imageName.size() > 0) {
		String siteCode = "hkah";
		if (ConstantsServerSide.isTWAH()) {
			siteCode = "twah";
		}
		String avoidCache = String.valueOf(new Date().getTime());
		String fileName="";
		for(String s : imageName) {
			fileName = s;
		}
%>
		<input type="button" value="Print" onclick=printIt()>
		<div style='width: 100%;' id="holder"></div>
<script>

var url = '<%=RISDB.getDIReportImagePath().replace("\\","/") + accessionNo + "/" + fileName%>';

PDFJS.disableWorker = true;

function printIt() {
    var canvas = document.getElementById("di-report") ;
    var win = window.open('', '', '');
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
        canvas.setAttribute("id", "di-report");

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
    var xhr = new XMLHttpRequest();
    var getRisReportUrl = '/intranet/GetRisReport?url='+ encodeURI(url) ;
    xhr.open('GET', getRisReportUrl, true);
    xhr.onload = function(e) {
        //binary form of ajax response,
        PDFJS.getDocument({data: atob( xhr.responseText ), password: '<%=RISDB.getRptDefaultPassword(RISDB.getMsgSeqByRptLogId(rptLogID))%>', }).then(renderPages);
    };

    xhr.send();
}

renderPDF(url, document.getElementById('holder'));
</script>

<%	} else { %>
		<div style='font-size:190%'>DI report cannot be found.</div>
		<%
		System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " [DI report] report cannot be found. accessionNo="+accessionNo+", allowReadDoc="+allowReadDoc+", imageName="+imageName);
		%>
<% 	} %>
<% } else { %>
		<div style='font-size:190%'>The result is pending, please call DI if required.</div>
		<%
		System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " [DI report] report pending. accessionNo="+accessionNo);
		%>
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