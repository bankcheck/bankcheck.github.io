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
// observe from 2018-06-13 to 2018-07-13 before go back to CMSDB
public static boolean allowReadDoc(UserBean userBean, String labLogID, String docCode) {
	StringBuffer sqlStr = new StringBuffer();
	boolean allowReadDoc = false;
	sqlStr.append("SELECT CIS_DOCCODE FROM CIS_LAB_LOG ");
	sqlStr.append("WHERE  CIS_LAB_ID = ? ");
	sqlStr.append("AND    CIS_DOCCODE in ");
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
			new String[]{labLogID, docCode, docCode, docCode, docCode, docCode, docCode});
	for (int i = 0; i < docDocList.size(); i++) {
		allowReadDoc = true;
	}

	System.out.println("[CMSDB] allowReadDoc loginID="+userBean.getLoginID()+", labLogID="+labLogID+", docCode="+docCode+", allowReadDoc="+allowReadDoc);

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

public static boolean updateReadDoc(UserBean userBean, String labLogID, String docCode) {
	StringBuffer sqlStr = new StringBuffer();
	String staffID = userBean.getStaffID();
	sqlStr.append("UPDATE CIS_LAB_LOG SET CIS_READDOC_STATUS = '1', ");
	sqlStr.append("       CO_MODIFIED_DATE=SYSDATE, CO_MODIFIED_USER=? ");
	sqlStr.append("WHERE CIS_LAB_ID = ? ");
	sqlStr.append("AND   CIS_READDOC_STATUS = '0' ");
	sqlStr.append("AND   CIS_DOCCODE in ");
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

	System.out.println("[CMSDB] updateReadDoc loginID="+userBean.getLoginID()+", labLogID="+labLogID+",docCode="+docCode);

	return UtilDBWeb.updateQueueCIS(sqlStr.toString(),
			new String[]{userBean.getLoginID(), labLogID, docCode, docCode, docCode, docCode, docCode, docCode});
}

public static String getDocLoginID(String labLogID, String labDocCode) {
	System.out.println("[CMSDB] getDocLoginID labLogID="+labLogID+", labDocCode="+labDocCode);
	
	
	StringBuffer sqlStr = new StringBuffer();
	String docCode = "";
	sqlStr.append("SELECT CIS_DOCCODE FROM CIS_LAB_LOG ");
	sqlStr.append("WHERE  CIS_LAB_ID = ? AND CO_ENABLED = '1' ");

	ArrayList docDocList = null;
	if (labDocCode != null && labDocCode.length() > 0) {
		sqlStr.append("AND CIS_DOCCODE = ? ");
		docDocList = UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[] {labLogID, labDocCode});
	} else {
		docDocList = UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[] {labLogID});
	}
	
	System.out.println("[CMSDB] getDocLoginID docDocList="+docDocList+", docDocList.isEmpty()="+docDocList.isEmpty());

	// get latest version of blocked report (same cis_lab_num, cis_logtype, cis_test_cat, cis_rpt_no)
	if (docDocList == null || docDocList.isEmpty()) {
		sqlStr.setLength(0);
		sqlStr.append("SELECT CIS_DOCCODE FROM CIS_LAB_LOG ");
		sqlStr.append("WHERE  cis_lab_id in ");
		sqlStr.append("( ");
		sqlStr.append("  select cis_lab_id ");
		sqlStr.append("  from  ");
		sqlStr.append("  ( ");
		sqlStr.append("    select cis_lab_id ");
		sqlStr.append("    from cis_lab_log ");
		sqlStr.append("    where (cis_lab_num, CIS_DOCCODE, cis_logtype, cis_test_cat, cis_rpt_no)  ");
		sqlStr.append("    in ( ");
		sqlStr.append("      select cis_lab_num, CIS_DOCCODE, cis_logtype, cis_test_cat, cis_rpt_no  ");
		sqlStr.append("      from cis_lab_log  ");
		sqlStr.append("      where  ");
		sqlStr.append("      cis_lab_id = ? ");
		sqlStr.append("      ) ");
		sqlStr.append("    and co_enabled = 1 ");
		sqlStr.append("    order by co_created_date desc ");
		sqlStr.append("  ) ");
		sqlStr.append("  where rownum = 1 ");
		sqlStr.append(") ");
		sqlStr.append("AND CO_ENABLED = '1' ");

		if (labDocCode != null && labDocCode.length() > 0) {
			sqlStr.append("AND CIS_DOCCODE = ? ");
			docDocList = UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[] {labLogID, labDocCode});
		} else {
			docDocList = UtilDBWeb.getReportableListCIS(sqlStr.toString(), new String[] {labLogID});
		}
	}
	
	System.out.println("[CMSDB] getDocLoginID docDocList.size()="+docDocList.size());

	ReportableListObject row = null;
	if (docDocList.size() > 0) {
		row = (ReportableListObject) docDocList.get(0);
		if (row.getValue(0) != null && row.getValue(0).length() > 0) {
			docCode = row.getValue(0);
		}
	}
	
	System.out.println("[CMSDB] getDocLoginID docCode="+docCode);

	return CMSDB.getPortalUserName(docCode);
}
%>
<%
UserBean userBean = new UserBean(request);
response.setHeader("Pragma","no-cache");
response.setHeader("Pragma-directive","no-cache");
response.setHeader("Cache-directive","no-cache");
response.setHeader("Cache-control","no-cache");
response.setHeader("Expires","0");

String oldLabLogID = ParserUtil.getParameter(request, "labLogID");
String labLogID = null;
String labNum = "";
String testCat = "";
String rptNo = "";
String destinationDir = "";
String filePath = "";
String docCode = ParserUtil.getParameter(request, "docCode");

String sLoginID = null;
if (docCode != null && docCode.length() > 0) {
	//sLoginID = CMSDB.getDocLoginID(oldLabLogID, docCode);
	sLoginID = getDocLoginID(oldLabLogID, docCode);
} else {
	System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " [Lab report] report invalid or expired. sLoginID="+sLoginID);
	
	%><script>alert('Report is invalid or expired.');</script><%
	return;
}

// copy from convertPdf.jsp
labLogID = CMSDB.getLatestUnblockLogID(oldLabLogID);

// blocked or non-existing report
if (labLogID == null) {
	System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " [Lab report] report is recalled. docCode="+docCode+", oldLabLogID="+oldLabLogID);
	
	%><script>alert('Report is recalled.');</script><%
	return;
}

ArrayList<String> imageName = new ArrayList<String>();
boolean allowReadDoc = false;

System.out.println("[CMSDB] docCode="+docCode+", sLoginID="+sLoginID);

if (userBean != null && userBean.isLogin()) {
	String loginDocCode = getDocCode(userBean);
	ArrayList labLogList = CMSDB.getLabLogDetail(labLogID, loginDocCode);
	ReportableListObject row = null;
	if (labLogList.size() > 0) {
		row = (ReportableListObject) labLogList.get(0);
		docCode = loginDocCode;
		labNum = row.getValue(0);
		testCat = row.getValue(1);
		rptNo = row.getValue(2);
		filePath = row.getValue(3);
	} else if (userBean.isAdmin() || userBean.isAccessible("function.lab.document.view")) {
		if (docCode != null && docCode.length() > 0) {
			labLogList = CMSDB.getLabLogDetail(labLogID, docCode);
			if (labLogList.size() > 0) {
				row = (ReportableListObject) labLogList.get(0);
				labNum = row.getValue(0);
				testCat = row.getValue(1);
				rptNo = row.getValue(2);
				filePath = row.getValue(3);
			}
		}
	}

	if (labNum != null && labNum.length() > 0) {
		if (allowReadDoc(userBean, labLogID, loginDocCode)) {
			allowReadDoc = true;
			updateReadDoc(userBean, labLogID, loginDocCode);
		} else if (userBean.isAdmin() || userBean.isAccessible("function.lab.document.view")) {
			allowReadDoc = true;
		}
	}

	if (allowReadDoc) {
		if (ConstantsServerSide.DEBUG) {
			destinationDir = CMSDB.getCMSLabReportImagePath(); // converted images from pdf document are saved here
		}
		
		System.out.println("[cms convertPdfWithPW] CMSDB.getCMSLabReportImagePath()="+CMSDB.getCMSLabReportImagePath()+", labNum="+labNum+", testCat="+testCat+", rptNo="+rptNo);

		File folder = new File(CMSDB.getCMSLabReportImagePath() + labNum + "\\" + testCat + "\\" + rptNo + "\\" );
		if (folder != null) {
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
		System.out.println(DateTimeUtil.getCurrentDateTimeStandard() + " [Lab report] Agent: " + request.getHeader("User-Agent"));
		if (request.getHeader("User-Agent").indexOf("Mobile") != -1) {
			System.out.println("  mobile");
		} else {
			if (CMSDB.checkReportAvailable(labNum, testCat, rptNo)) {
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

					//String pdfFileName = CMSDB.getCMSLabReportImagePath().replace("\\","/") + rptNo + "/" + fileName ;
					String pdfFileName = filePath ;
					//System.out.println("pdfFileName : " + pdfFileName) ;

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
	<jsp:param name="pageTitle" value="Lab Report" />
	<jsp:param name="mustLogin" value="Y" />
	<jsp:param name="isHideTitle" value="Y" />
	<jsp:param name="sLoginID" value="<%=sLoginID %>" />
	<jsp:param name="sSource" value="lab" />
</jsp:include>
<body style="height: 100%;width:100%">
<script type="text/javascript" src="<html:rewrite page="/js/compatibility.js"/>" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/pdf.js"/>" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/pdf.worker.js"/>" /></script>
<%
if (CMSDB.checkReportAvailable(labNum, testCat, rptNo)) {
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
		<div style='width: 100%;' id="holder"></div>
<script>

var url = '<%=filePath.replace("\\", "\\\\") %>';

PDFJS.disableWorker = true;

function printIt() {
    var canvas = document.getElementById("lab-report") ;
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
    var xhr = new XMLHttpRequest();
    var getLabReportUrl = '/intranet/GetLabReport?url='+ encodeURI(url) ;
    xhr.open('GET', getLabReportUrl, true);
    xhr.onload = function(e) {
        //binary form of ajax response,
        PDFJS.getDocument({data: atob( xhr.responseText ), password: '', }).then(renderPages);
    };

    xhr.send();
}

renderPDF(url, document.getElementById('holder'));
</script>

<%	} else { %>
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