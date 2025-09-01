<%@ page import="java.util.Date"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.web.common.UserBean"%>
<%@ page import="com.hkah.web.db.helper.FsModelHelper"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.util.*"%>
<%!
public static List getListOfFsFiles(String patno, String formCode) {
	List<String> params = new ArrayList<String>();
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT  I.FS_FILE_INDEX_ID ");
	sqlStr.append("FROM    FS_FILE_INDEX I JOIN FS_FILE_PROFILE P ON I.FS_FILE_INDEX_ID = P.FS_FILE_INDEX_ID ");
	sqlStr.append("WHERE   I.FS_ENABLED = '1' ");
	if(patno != null && !patno.isEmpty()){
		sqlStr.append("AND  I.FS_PATNO = ? ");
		params.add(patno);
	}
	if(formCode != null && !formCode.isEmpty()){
		sqlStr.append("AND  P.FS_FORM_CODE = ? ");
		params.add(formCode);
	}
	if (params.isEmpty()) {
		sqlStr.append("AND  1 = 2 ");
	}
	sqlStr.append("AND	   I.FS_APPROVED_DATE IS NOT NULL ");
	sqlStr.append("AND     I.FS_APPROVED_USER IS NOT NULL ");

	System.out.println("[fs/index.jsp] sql=["+sqlStr.toString()+"] patno="+patno+", formCode="+formCode);

	String[] paramsArray = params.toArray(new String[]{});
	List result = UtilDBWeb.getReportableListCIS(sqlStr.toString(), paramsArray);
	return result;
}

%>
<%
UserBean userBean = new UserBean(request);
String requestURL = request.getRequestURL().toString();
String servletPath = request.getServletPath();
String treeSubLink = "/common/pat_main.jsp";
String qryStrCategory = "category=fs";
String qryStrPatno = "patno=";
String qryStrViewMode = "viewMode=";
String treeLink = requestURL.replace(servletPath, "") + treeSubLink;
String patno = request.getParameter("patno");
String formCode = ParserUtil.getParameter(request, "formCode");
String viewMode = request.getParameter("viewMode");
String isMerge = request.getParameter("isMerge");
if (viewMode == null) {
	viewMode = FsModelHelper.ViewMode.PREVIEW.toString();
}
String currentDateStr = DateTimeUtil.formatDate(new Date());

boolean canList = userBean.isAccessible("function.fs.file.list");
boolean canUpload = userBean.isAccessible("function.fs.file.upload");
boolean canImportList = userBean.isAccessible("function.fs.import.list");
boolean canImportLogList = userBean.isAccessible("function.fs.importLog.list");
boolean canBatchList = userBean.isAccessible("function.fs.batch.list");
boolean canCategoryList = userBean.isAccessible("function.fs.category.list");
boolean canFormList = userBean.isAccessible("function.fs.form.list");
boolean canSysparamList = userBean.isAccessible("function.fs.sysparam.list");
boolean canStatList = userBean.isAccessible("function.fs.file_stat.list");
boolean canFs = userBean.isAccessible("function.fs");
boolean canMerge = userBean.isAccessible("function.fs.merge");
boolean canInpDischargeList = userBean.isAccessible("function.fs.inpDischarge.list");

if("Y".equals(isMerge)){
	List records = getListOfFsFiles(patno, formCode);
	//List records = ForwardScanningDB.getListOfFsFiles(patno, formCode);

	StringBuffer sqlStr = new StringBuffer();
	if(records.size() != 0){
		for(int r = 0; r < records.size(); r++){
			ReportableListObject row = (ReportableListObject)records.get(r);
			if( r == 0){
				sqlStr.append(row.getValue(0));
			} else {
				sqlStr.append(","+row.getValue(0));
			}
		}
		String[] array = new String[1];
		array[0] = sqlStr.toString();
		FsModelHelper.mergePdfFiles(ForwardScanningDB.getFileIndexDetails(array));
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
<jsp:include page="../common/header.jsp"/>
<style>
table#content { border: 0; width: 200px; margin: 0 auto; }
table#content td { padding: 10px; border: 2px solid #C8BBBE; }
#panel { width: 100%; margin: 10px 5px; }
#panel .dailyOpBox { margin: 5px 0; padding: 5px; background: #CCEEFF; }
#panel .configStatBox { margin: 5px 0; padding: 5px; background: #ECE5B6; }
#panel .previewBox { display: block; margin: 5px 0; padding: 5px; background: #C8BBBE; }
#patmerge_alert_box {
	padding: 5px;
	background: #ffff99;
	border: 1px solid #f0c36d;
	border-radius: 2px;
	-moz-border-radius: 2px;
	-webkit-border-radius: 2px;
	box-shadow: 0 2px 4px rgba(0,0,0,0.2);
}
</style>
<body leftmargin='5' topmargin='5' marginleft='5' marginleft='5' bgcolor='#ffffff'>
<div id=indexWrapper>
	<div id=mainFrame>
		<div id="contentFrame">
<jsp:include page="../common/page_title.jsp">
	<jsp:param name="pageTitle" value="function.fs.admin" />
	<jsp:param name="loadBalance" value="N" />
</jsp:include>
			<form name="form1">
				<table id="panel">
					<tr>
						<td>
							Patient No.: <input type="text" name="patno" id="patno" value="<%=patno == null ? "" : patno %>" maxlength="10" size="10" />
						</td>
					</tr>
					<tr>
						<td>
<% if (canList || canUpload || canImportList || canImportLogList || canMerge || canInpDischargeList) { %>
							<div class="dailyOpBox"><div class="subTitle">Daily Operations</div>
	<%if (canList) { %><button onclick="return submitAction('file_list');">File Index</button><% } %>
	<%if (canUpload) { %><button onclick="return submitAction('file_upload');">Upload File</button><% } %>
	<%if (canImportList) { %><button onclick="return submitAction('import');">Import CSV</button><% } %>
	<%if (canImportLogList) { %><button onclick="return submitAction('importLog_list');">View Import Log</button><% } %>
	<%if (canBatchList) { %><button onclick="return submitAction('batch_list');">Batch List</button><% } %>
	<%if (canInpDischargeList) { %><button onclick="return submitAction('inp_discharge_list');">Discharge List</button><% } %>
	<%if (canList) { %><button onclick="return submitAction('file_list_archive');">Download Charts</button><% } %>
	<%if (canMerge) { %>
		<button onclick="return submitAction('merge');">Merge PDFs</button>
		Form Code:
		<input type="text" name="formCode" id="formCode" value="<%=formCode == null ? "" : formCode %>" maxlength="20" size="20" />
	<% } %>
							</div>
<% } %>
<% if (canCategoryList || canFormList || canSysparamList || canStatList) { %>
							<div class="configStatBox"><div class="subTitle">Configuration and Statistics</div>
	<%if (canCategoryList) { %><button onclick="return submitAction('category_list');">Tree Category</button><% } %>
	<%if (canFormList) { %><button onclick="return submitAction('form_list');">Form</button><% } %>
	<%if (canSysparamList) { %><button onclick="return submitAction('sysparam_list');">System Parameters</button><% } %>
	<%if (canStatList) { %><button onclick="return submitAction('file_stat_list');">Statistics</button><% } %>
							</div>
<% } %>
<%if (canFs) { %>
							<div class="previewBox">
								<div class="subTitle">Preview</div>
								<table>
									<tr>
										<td>
											<textarea id="treeLink" rows="1" cols="150" readonly="readonly"><%=treeLink %></textarea>
										</td>
									</tr>
									<tr>
										<td>
											Mode:
											<input type="radio" name="viewMode" value="<%=FsModelHelper.ViewMode.DEBUG.toString() %>"<%="debug".equalsIgnoreCase(viewMode) ? " checked=\"checked\"" : "" %> />
											<%=FsModelHelper.ViewMode.DEBUG.toString() %>
											<input type="radio" name="viewMode" value="<%=FsModelHelper.ViewMode.ADMIN.toString() %>"<%="admin".equalsIgnoreCase(viewMode) ? " checked=\"checked\"" : "" %> />
											<%=FsModelHelper.ViewMode.ADMIN.toString() %>
											<input type="radio" name="viewMode" value="<%=FsModelHelper.ViewMode.PREVIEW.toString() %>"<%="preview".equalsIgnoreCase(viewMode) ? " checked=\"checked\"" : "" %> />
											<%=FsModelHelper.ViewMode.PREVIEW.toString() %>
											<input type="radio" name="viewMode" value="<%=FsModelHelper.ViewMode.LIVE.toString() %>"<%="live".equalsIgnoreCase(viewMode) ? " checked=\"checked\"" : "" %> />
											<%=FsModelHelper.ViewMode.LIVE.toString() %>
											<span style="margin: 5px;">
												<button onclick="return submitAction('tree');">Show Tree</button>
												<button id="btn_copyTreeLink" onclick="">Copy the link</button>
											</span>
										</td>
									</tr>
								</table>
							</div>
<% } %>
							<div id="patmerge_alert_box"></div>
						</td>
					<tr>
				</table>
				<input type="hidden" name="command" />
			</form>
		</div>
	</div>
</div>
<script language="javascript">
	$(document).ready(function(){
		$('#patno').keyup(function(){
			updateTreeLink();
			if ($('#patno').val().length > 5) {
				checkPatMerge($('#patno').val().trim());
			}
		});
		$("input[name='viewMode']").each(function(){
			$(this).change(function(){
				updateTreeLink();
			});
		});
		$('#btn_copyTreeLink').click(function(){
			if (copyToClipboard(document.getElementById('treeLink').value)) {
				alert("The URL is copied to clipboard.");
			}
		});
		$('#patmerge_alert_box').hide();
		$('#patno').focus();
	});

	function submitAction(cmd) {
		if (cmd == 'tree') {
			if ($('#patno').val() == '') {
				alert('Please enter Patient No.');
				$('#patno').focus();
				return false;
			}
			callPopUpWindow(createTreeLink());
			return false;
		} else {
			if (cmd == 'file_list') {
				$('<input>').attr({
				    type: 'hidden',
				    name: 'importDate',
				    value: '<%=currentDateStr %>'
				}).appendTo('form[name=form1]');
<% if (userBean.getLoginID() != null && userBean.getLoginID().startsWith("mrscan")) {
	// default search import by for mrscan* accounts
%>
				$('<input>').attr({
				    type: 'hidden',
				    name: 'importBy',
				    value: '<%=userBean.getLoginID() %>'
				}).appendTo('form[name=form1]');	
<% } %>

<% 	if (ConstantsServerSide.isAMC1() || ConstantsServerSide.isAMC2()) { %>
				$('<input>').attr({
				    type: 'hidden',
				    name: 'approveStatus',
				    value: 'A'
				}).appendTo('form[name=form1]');
<% } %>
			} else if (cmd == 'file_list_archive') {
				if ($('#patno').val() == '') {
					alert('Please input Patient No.');
					$('#patno').focus();
					return false;
				}
				$('<input>').attr({
				    type: 'hidden',
				    name: 'approveStatus',
				    value: 'P'
				}).appendTo('form[name=form1]');

				$('<input>').attr({
				    type: 'hidden',
				    name: 'showAutoImport',
				    value: 'Y'
				}).appendTo('form[name=form1]');

				$('<input>').attr({
				    type: 'hidden',
				    name: 'showHIS',
				    value: 'Y'
				}).appendTo('form[name=form1]');

				$('<input>').attr({
				    type: 'hidden',
				    name: 'mode',
				    value: 'archive'
				}).appendTo('form[name=form1]');

				cmd = 'file_list';
			} else if (cmd == 'file_stat_list') {
				document.form1.patno.value = '';
			} else if (cmd == 'importLog_list' && document.form1.patno.value == '') {
				$('<input>').attr({
				    type: 'hidden',
				    name: 'importDate',
				    value: '<%=currentDateStr %>'
				}).appendTo('form[name=form1]');
<% if (userBean.getLoginID() != null && userBean.getLoginID().startsWith("mrscan")) {
	// default search import by for mrscan* accounts
%>
				$('<input>').attr({
				    type: 'hidden',
				    name: 'importBy',
				    value: '<%=userBean.getLoginID() %>'
				}).appendTo('form[name=form1]');
<% } %>
			} else if (cmd == 'merge') {
				cmd = 'index';
				$('<input>').attr({
				    type: 'hidden',
				    name: 'isMerge',
				    value: 'Y'
				}).appendTo('form[name=form1]');
			} else if (cmd == 'file_upload') {
				if ($('#patno').val() == '') {
					alert('Please enter Patient No.');
					$('#patno').focus();
					return false;
				}
			}

			var url = cmd +'.jsp';
			document.form1.action = url;
			document.form1.submit();

			showLoadingBox('body', 500, $(window).scrollTop());
			return false;
		}
		return false;
	}

	function createTreeLink() {
		return "<%=treeLink %>?<%=qryStrCategory %>&<%=qryStrPatno %>" + $('#patno').val() + "&<%=qryStrViewMode %>" + $('input[name="viewMode"]:checked').val();
	}

	function updateTreeLink() {
		$('#treeLink').val(createTreeLink());
	}

	function checkPatMerge(fmPatno) {
		$('#patmerge_alert_box').load('checkPatMerge.jsp?action=getToPatno&fmPatno=' + fmPatno + '&ts=' + (new Date().getTime()),
				function( response, status, xhr ) {
			if (status == 'success') {
				//alert("ret=<" + response.trim() + ">");
				$('#patmerge_alert_box').html( response );
				if (response.trim() == '') {
					$('#patmerge_alert_box').hide();
				} else {
					$('#patmerge_alert_box').show();
				}

			} else if ( status == "error" ) {
			    var msg = "Check patient merge error: ";
			    $( "#error" ).html( msg + xhr.status + " " + xhr.statusText );
			  }
		});

		$('#patmerge_alert_box').load('checkPatMerge.jsp?action=getFmPatno&fmPatno=' + fmPatno + '&ts=' + (new Date().getTime()),
				function( response, status, xhr ) {
			if (status == 'success') {
				$('#patmerge_alert_box').html( response );
				if (response.trim() == '') {
					$('#patmerge_alert_box').hide();
				} else {
					$('#patmerge_alert_box').show();
				}

			} else if ( status == "error" ) {
			    var msg = "Check patient merge error: ";
			    $( "#error" ).html( msg + xhr.status + " " + xhr.statusText );
			  }
		});
	}

	keepAlive();
</script>
<jsp:include page="../common/footer.jsp" flush="false"/>
</body>
</html:html>