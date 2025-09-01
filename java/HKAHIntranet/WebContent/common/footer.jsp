<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<form name="FooterForm"><input type="hidden" name="documentID" /><input type="hidden" name="fileName" />
<input type="hidden" name="isLatestFile" /></form>

<script type="text/javascript">
<!--
	var stoptask = 0;
	function stopRunningTaskImg() {
		if (window.parent.frames.length > 1) {
//			if (window.parent.frames[0].contentDocument) {
//				window.parent.frames[0].contentDocument.images['status'].src = "<html:rewrite page="/images/idle_task.gif" />";
//			} else {
//				window.parent.frames[0].document.images['status'].src = "<html:rewrite page="/images/idle_task.gif" />";
//			}
		} else {
//			document.images['status'].src = "<html:rewrite page="/images/idle_task.gif" />";
		}
	}
	if (stoptask == 0) {
//		window.setTimeout("stopRunningTaskImg()", 500);
		stoptask = 1;
	}

	function downloadFile(did) {
		document.FooterForm.action= "../documentManage/download.jsp";
		document.FooterForm.documentID.value = did;
		document.FooterForm.target = "_blank";
		document.FooterForm.submit();
		return false;
	}

	function downloadFile(did, fname) {
		document.FooterForm.action = "../documentManage/download.jsp";
		document.FooterForm.documentID.value = did;
		document.FooterForm.fileName.value = fname;
		document.FooterForm.target = "_blank";
		document.FooterForm.submit();
		return false;
	}
	
	function downloadFile(did, fname, isLatestFile) {
		//console.log('[footer] 3 did='+did);
		// hardcoded for Board and Finance member folder 2019-03-25
		if ((did == 673 || did == 674) &&
		//if ((did == 683) &&
				fname.toLowerCase().endsWith('pdf')) {
			callPopUpWindow("../documentManage/pdfjs/web/viewer.jsp?isLatestFile="+isLatestFile+"&allowOpenFile=N&documentID=" + did + "&fileName="+encodeURIComponent(fname));
		} else {
			document.FooterForm.action = "../documentManage/download.jsp";
			document.FooterForm.documentID.value = did;
			document.FooterForm.fileName.value = fname;
			document.FooterForm.isLatestFile.value = isLatestFile;
			document.FooterForm.target = "_blank";
			document.FooterForm.submit();
			return false;
		}
	}
	
	function showPdfjs(source, file, target) {
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
		
		if (target == '_self') {
			window.location.href = url;
		} else {
			callPopUpWindow(url);
		}
	}
-->
</script>
</div>
<!--DIV id=footer>
<table border="0" width="100%" cellspacing="0" cellpadding="0" bgcolor="#888888" height="1"><tr><td></td></tr></table>
<a href="http://www.hkah.org/" style="text-decoration:none;">
<div style="color:#111111; font-size:10px; text-decoration:none; font-family:Arial;">(c) Copyright 2016 Hong Kong Adventist Hospital. All Rights Reserved.
</DIV-->