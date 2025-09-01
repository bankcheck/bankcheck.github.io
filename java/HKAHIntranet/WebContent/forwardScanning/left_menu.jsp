<%@ page import="java.util.*"%>
<%@ page import="java.util.regex.*"%>
<%@ page import="java.math.BigDecimal"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.db.helper.*"%>
<%@ page import="com.hkah.web.db.hibernate.*"%>
<%@ page import="com.hkah.web.db.model.*"%>
<%@ page import="com.hkah.util.*"%>
<%
UserBean userBean = new UserBean(request);
//if (!userBean.isAccessible("function.fs"))
//	return;

String pageCategory = (String) session.getAttribute(ConstantsWebVariable.KEY_SESSION_PAGE_CATEGORY);
String patno = ParserUtil.getParameter(request, "patno");
String viewMode = ParserUtil.getParameter(request, "viewMode");
String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");
String[] fsSeqs = request.getParameterValues("fsSeq");
String[] fsFileIndexIds = request.getParameterValues("fsFileIndexId");

String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");
int MAX_IMPORT_DATE_SHOW = 100;

boolean isAdminDebugMode = false;
if (FsModelHelper.ViewMode.DEBUG.equals(FsModelHelper.parseViewMode(viewMode)) ||
		FsModelHelper.ViewMode.ADMIN.equals(FsModelHelper.parseViewMode(viewMode))) {
	isAdminDebugMode = true;
}

boolean sortUpdateAction = false;
if ("sortUpdate".equals(command)) {
	sortUpdateAction = true;
}

try {
	if ("1".equals(step)) {
		if (sortUpdateAction) {
			boolean success = FsModelHelper.updateFileIndexSeqs(userBean, fsFileIndexIds, fsSeqs);
			if (success) {
				message = "Sequence order updated";
			} else {
				errorMessage = "Fail to update sequence order";
			}
		}
	}
} catch (Exception e) {
	e.printStackTrace();
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
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
<jsp:include page="../common/header.jsp"/>
<style>
a{color:#036;text-decoration:none;}a:hover{color:#ff3300;text-decoration:none;}
body { margin: 0px; font: 12px Arial, Helvetica, sans-serif; background-color: #ffffff; }

/* For menu with very long title */
.menuSmallText li a:link, .menuSmallText li a:visited { padding-top: 1px !important; font-size: 9px; }
.menuSmallText li a:hover { padding-top: 1px !important; font-size: 9px; }
.menuSmallText li a:active { padding-top: 1px !important; font-size: 9px; }
.icdcode { color: red; font-weight: bold; }
.icddesc { color: blue; font-weight: bold; }

#doc_scanning_wrapper {
	width: 100%;
	position: relative;
	height: 90%;
	/* border: 1px solid green; */
}
#mininizeTree, #showTree {
	background: #99CCFF;
	width:20px; 
	height:100%; 
	margin: 0px;
	font-weight: bold;
}
#doc_tree_remarks {
	padding: 5px;
	background: #f9edbe;
	border: 1px solid #f0c36d;
	border-radius: 2px;
	-moz-border-radius: 2px;
	-webkit-border-radius: 2px;
	box-shadow: 0 2px 4px rgba(0,0,0,0.2);
}

#doc_scanning_tree {
	/*position:absolute;*/
	top:0;
	left:0;
	height: 100%;
	width: 90%;
	/* border: 1px solid red; */
}
#doc_scanning_sizing_bar {
	position:absolute;
	float: right;
	top:0;
	right:0;
	height: 100%;
	width: 20px;
	background: #99CCFF;
	padding: 1px;
	/* border: 1px solid blue; */
}
#doc_scanning_sizing_bar_min {
	position:absolute;
	float: right;
	top:0;
	right:0;
	height: 100%;
	width: 20px;
	background: #99CCFF;
	padding: 1px;
	/* border: 1px solid yellow; */
	display:none;
}
#doc_scanning_progress {
	position:fixed;
	top:20;
	right:50;
}

/* IE hack for fixing doc_scanning_progress */
* html {
	overflow: hidden;
}
* html body,
* html #doc_scanning_wrapper {
	position:relative;
	width:100%;
	height:90%;
	overflow:auto;
}

* html #doc_scanning_progress {
	position:absolute;
}

.dummy-space {
	width: 20px;
	position:absolute;
	top:0;
	right:0;
	height: 100%;
	/*border: 1px solid green;*/
}

.file_remarks {
	padding: 0 5px;
	color: #ff0000;
	font-weight: bold;
}

.link_selected{
 	color: #70ABF4 !important 
}

.sortBtn {
	background:url('../images/sort.png');
	width:20px;
	height:20px;
}

.sortUpdateBtn {
	width:50px;
	height:20px;
}

.hideScrollY {
	overflow-y:hidden;
}

.lastUpdatedBox {
	padding: 5px;
	font: 15px bold italic;
}

<% if (isAdminDebugMode) { %>.lastUpdatedBox-a<% } else { %> .lastUpdatedBox <% } %> {
	position: relative;
	top: 80px;
}
.lastUpdatedBox-a, .lastUpdatedBox table tr td {
	padding: 2px;
}

#loading_spinner {
	height: 100%;
	position:absolute;
	top: 40px;
	left: 200px;
}

#browser .folder {
	font-size: 15px;
}

.footer {
   position: fixed;
   left: 0;
   bottom: 0;
   width: 100%;
   background-color: #cccccc;
   color: white;
   text-align: right;
   padding: 5px;
   
}

.footer button {
	
}

</style>
<body leftmargin='5' topmargin='5' marginleft='5' marginleft='5' bgcolor='#ffffff'>
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<div id="doc_scanning_wrapper">
<% 
	String treeRemarks = FsModelHelper.getTreeRemark(patno, viewMode);
	if (treeRemarks != null && !treeRemarks.isEmpty()) {
%>
	<div id="doc_tree_remarks">
	<%=treeRemarks %>
	</div>
<%
	}
%>
	<div id="doc_scanning_tree">
		<ul id="browser" class="filetree">
			<div id="loading_spinner" >
			</div>
		</ul>
	</div>
	<div id="doc_scanning_sizing_bar">
		<button id="mininizeTree">&lt;</button>
	</div>
	<div id="doc_scanning_sizing_bar_min">
		<button id="showTree">&gt;</button>
	</div>
	<div>&nbsp;</div>
</div>

<% if (isAdminDebugMode) { %>
<div class="lastUpdatedBox-a">		
[Admin]<br />
Last Approval Date: <%=ForwardScanningDB.getLastApprDateByPat(patno) %><br />
<table cellpadding="0" cellspacing="0" border="0">
<% 
	List<String> impList = ForwardScanningDB.getImportDatesByPat(patno);
	for (int i = 0; i < impList.size() && i < MAX_IMPORT_DATE_SHOW; i++) { 
%>
	<tr><td><%=i == 0 ? "Import Dates:" : "" %></td><td><%=impList.get(i) %></td></tr>
<% 	} %>
<% if (impList.size() > MAX_IMPORT_DATE_SHOW) { %>
		<tr><td></td><td>......(<%=impList.size() - MAX_IMPORT_DATE_SHOW %> more)</td></tr>
<% } %>	
</table>
<% } else { %>
<div class="lastUpdatedBox">	
Last Updated Date: <%=ForwardScanningDB.getLastApprDateByPat(patno) %>
<% } %>
</div>
<div id="doc_scanning_progress" style="display:none;">
	<span class="progressBar" id="pb1"></span>
</div>
<div class="footer">
	<button name="btn_reload">Refresh</button>
	<button name="btn_close">Close</button>
</div>
<form name="sortUpdateForm" action="left_menu.jsp" method="post">
	<input type="hidden" name="patno" value="<%=patno %>" />
	<input type="hidden" name="viewMode" value="<%=viewMode %>" />
	<input type="hidden" name="command" value="sortUpdate" />	
</form>
<script type="text/javascript">
	$(document).ready(function() {
		$('#mininizeTree').click(function() {
			//console.log('clicked!');
			$('#forwardScanning_frameset', window.parent.document).attr('cols', '35px, *');
			$('#doc_scanning_sizing_bar_min').show();
			$('#doc_scanning_sizing_bar').hide();
		});
		
		$('#showTree').click(function() {
			//console.log('doc_scanning_sizing_bar_min clicked!');
			$('#forwardScanning_frameset', window.parent.document).attr('cols', '450px, *');
			$('#doc_scanning_sizing_bar').show();
			$('#doc_scanning_sizing_bar_min').hide();
		});
		
		$('.dlfilelink').click(function() {
			//showProgress();
		});
		
		$("#pb1").progressBar();
		
		$('.sortOrder-box').hide();
		$('.sortUpdateBtn').hide();
		$('.sortBtn').click(function() {
			var cName = $(this).attr('name');
			if (cName != '') {
				$('input[name=' + cName + '-update]').toggle();
				$('span[name=fsSeq-' + cName + '-box]').toggle();
			}
		});
		
		$('.sortUpdateBtn').click(function() {
			var cName = $(this).attr('name');
			if (cName != '') {
				cName = cName.split('-')[0];
				var form = $("form[name=sortUpdateForm]");
				//alert('cName=' + cName+', length='+$('input[name=fsSeq-' + cName + ']').length);
				$('input[name=fsSeq-' + cName + ']').each(function() {
					form.append("<input type='hidden' name='fsSeq' value='" + $(this).val() + "' />");
					form.append("<input type='hidden' name='fsFileIndexId' value='" + $(this).attr('fid') + "' />");
				});
				form.append("<input type='hidden' name='step' value='1' />");
				form.submit();
			}
		});
		
		$('button[name=btn_close]').click(function() {
			top.close();
		});
		
		$('button[name=btn_reload]').click(function() {
			location.reload();
		});
		
		var target = document.getElementById('loading_spinner');
		var spinner = new Spinner().spin(target);
		getFsItemTree('<%=patno %>','<%=viewMode %>');
	});
	
	function submitAction(cmd, step, keyId) {
		if (step == '1') {			
			if (cmd == 'approve') {
				var promptMsg= 'Confirm approve?';
				$.prompt(promptMsg,{
					buttons: { Ok: true, Cancel: false },
					callback: function(v,m,f){
						if (v){
							submit: submitAction(cmd, 2, keyId);
							return true;
						} else {
							return false;
						}
					},
					prefix:'cleanblue'
				});
				return false;
			} else if (cmd == 'updateSortOrder') {
				// show input box
			} else if (cmd == 'view') {
				callPopUpWindow("file_detail.jsp?command=" + cmd + "&fileIndexId=" + keyId);
				return false;
			} else if (cmd == 'downloadImages') {
				callPopUpWindow("downloadZip.jsp?command=" + cmd + "&keyId=" + keyId + "&patno=<%=patno %>");
				return false;
			}  
		} else if (step == '2') {
			if (cmd == 'approve') {
				approve(keyId);
			}
		}
	}
	
	function submitAction(cmd, step, keyId, categoryTitle){
		if (step == '1') {			
			if (cmd == 'approve') {
				var promptMsg= 'Confirm approve?';
				$.prompt(promptMsg,{
					buttons: { Ok: true, Cancel: false },
					callback: function(v,m,f){
						if (v){
							submit: submitAction(cmd, 2, keyId);
							return true;
						} else {
							return false;
						}
					},
					prefix:'cleanblue'
				});
				return false;
			} else if (cmd == 'updateSortOrder') {
				// show input box
			} else if (cmd == 'view') {
				callPopUpWindow("file_detail.jsp?command=" + cmd + "&fileIndexId=" + keyId);
				return false;
			} else if (cmd == 'downloadImages') {
				callPopUpWindow("downloadZip.jsp?command=" + cmd + "&keyId=" + keyId + "&patno=<%=patno %>&categoryTitle="+categoryTitle);
				return false;
			}  
		} else if (step == '2') {
			if (cmd == 'approve') {
				approve(keyId);
			}
		}
	}
	
	function approve(keyId) {
		var params = {
					command: 'approve',
					keyId: keyId,
					timestamp: new Date()
				};
		
		$.ajax({
			  type: 'POST',
			  url: 'approveFileIndex.jsp',
			  data: params,
			  cache: false,
			  success: function(data) {
				  if (data.indexOf("OK") >= 0) {
					  document.location.reload();
				  } else {
					  alert(data + ' Please contact IT support.');
				  }
				  
			  },
			  error: function() {
			  	  alert('System error. Please contact IT support.');
			  }
		});
	}
	
	/*===
		Download progress bar
	=====*/
	function getFsItemTree(patno, viewMode) {
		$.ajax({
			  type: 'GET',
			  url: 'getItemTreeHTML.jsp?patno='+patno+'&viewMode='+viewMode+'&ts='+(new Date()).getTime(),
			  success: function(data) {
				  $("#browser").html(data);
				  $("#browser").treeview({animated: "fast"});
				  <% if (isAdminDebugMode) { %>
				  	$('.lastUpdatedBox-a').css('top', '0');
				  <% } else { %>
				  	$('.lastUpdatedBox').css('top', '0');
				  <% } %>
			  }
		});
	}
	
	var c=0;
	var t;
	var timer_is_on=0;	// only 1 timer is running each time
		
	function reloadProgress() {
		$.ajax({
			  type: 'POST',
			  url: '../documentManage/progress.jsp?type=download',
			  success: function(data) {
				  data = $.trim(data);
				  $("#pb1").progressBar(data);
					if (data == '100') {
						clearProgress();
					}
			  }
		});
	}

	function timedCount() {			
		c=c+1;
		reloadProgress();
		t=setTimeout("timedCount()",50);
	}

	function showProgress() {
		if (!timer_is_on) {
			$.ajax({
				  type: 'POST',
				  url: '../documentManage/progress.jsp?cmd=reset&type=download',
				  success: function(data) {
					  timer_is_on=1;
					  timedCount();
					  $('#doc_scanning_progress').show();
				  }
			});
		}
	}
	
	function clearProgress() {
		setTimeout("$('#doc_scanning_progress').fadeOut('fast');", 1500);
		setTimeout("$('#pb1').progressBar(0);", 2300);
		clearTimeout(t);
		timer_is_on = 0;
	}
	
	function linkSelected(obj){
		$(".link_selected").removeClass("link_selected");
		$(obj).children().addClass('link_selected');		
	}
</script>
<jsp:include page="../common/footer.jsp" flush="false"/>
</body>
</html:html>