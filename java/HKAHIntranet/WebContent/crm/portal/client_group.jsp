<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
private ArrayList fetchSubGroup(String grpID) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("select CRM_SITE_CODE, CRM_GROUP_ID, CRM_GROUP_DESC, TO_CHAR(CRM_MODIFIED_DATE, 'DD/MM/YYYY') "); 
	sqlStr.append("from CRM_GROUP "); 
	sqlStr.append("where  CRM_ENABLED = 1 "); 
	sqlStr.append("and    CRM_PARENT_GROUP_ID is not null "); 
	sqlStr.append("and    CRM_PARENT_GROUP_ID = '"+grpID+"' ");
	sqlStr.append("order by CRM_SITE_CODE, CRM_GROUP_DESC "); 
		
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);
String command = request.getParameter("command");
String siteCode = request.getParameter("siteCode");
String grpID = request.getParameter("grpID");
String grpDesc = request.getParameter("grpDesc");
String isClient = request.getParameter("isClient");
String subGroup = request.getParameter("subGroup");

String clientLeaderID[] = request.getParameterValues("clientLeaderID");
String clientLeaderIDDesc[] = null;
String clientLeaderReceiveEmail[] = null;

String clientManagerID[] = request.getParameterValues("clientManagerID");
String clientManagerIDDesc[] = null;
String clientManagerReceiveEmail[] = null;

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;
boolean viewAction = false;

String message = "";
String errorMessage = "";

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("view".equals(command)) {
	viewAction = true;
}

try{
	if("new".equals(command)) {
		siteCode = ConstantsServerSide.SITE_CODE;
		command = "create";
		createAction = true;
	}
	else if("edit".equals(command)) {
		command = "update";
		updateAction = true;
	}
	else {
		if ((createAction || updateAction) && 
				(grpDesc == null || grpDesc.length() == 0)) {
			errorMessage = MessageResources.getMessage(session, "error.crm.group.required");
		}
		else if (createAction) {
			StringBuffer sqlStr = new StringBuffer();
			
			sqlStr.append("SELECT COUNT(1) + 1 FROM CRM_GROUP ");
			ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				grpID =  row.getValue(0);
				
				sqlStr.setLength(0);
				sqlStr.append("INSERT INTO CRM_GROUP ");
				sqlStr.append("(CRM_SITE_CODE, CRM_GROUP_ID, CRM_GROUP_DESC, CRM_CREATED_USER, CRM_CREATED_SITE_CODE, ");
				sqlStr.append("CRM_CREATED_DAPARTMENT_CODE, CRM_MODIFIED_USER) ");
				sqlStr.append("VALUES ");
				sqlStr.append("(?, ?, ?, ?, ?, ?, ?)");
		
				if (UtilDBWeb.updateQueue(
						sqlStr.toString(),
						new String[] { siteCode, grpID, grpDesc, userBean.getLoginID(), ConstantsServerSide.SITE_CODE, 
										userBean.getDeptCode(), userBean.getLoginID()} )) {
					message = "Client Group created.";
					createAction = false;
					
					for(int i = 1; i <= Integer.parseInt(subGroup); i++){
						sqlStr.setLength(0);
						sqlStr.append("SELECT COUNT(1) + 1 FROM CRM_GROUP ");
						ArrayList subGroupRecord = UtilDBWeb.getReportableList(sqlStr.toString());
						if (subGroupRecord.size() > 0) {
							ReportableListObject subGroupRow = (ReportableListObject) subGroupRecord.get(0);
							String subGrpID =  subGroupRow.getValue(0);
							
							sqlStr.setLength(0);
							sqlStr.append("INSERT INTO CRM_GROUP ");
							sqlStr.append("(CRM_SITE_CODE, CRM_GROUP_ID, CRM_GROUP_DESC, CRM_PARENT_GROUP_ID, CRM_CREATED_USER, CRM_CREATED_SITE_CODE, ");
							sqlStr.append("CRM_CREATED_DAPARTMENT_CODE, CRM_MODIFIED_USER) ");
							sqlStr.append("VALUES ");
							sqlStr.append("(?, ?, ?, ?, ?, ?, ?, ?)");
					
							if (UtilDBWeb.updateQueue(
									sqlStr.toString(),
									new String[] { siteCode, subGrpID,  grpDesc+" - S"+i , grpID, userBean.getLoginID(), ConstantsServerSide.SITE_CODE, 
													userBean.getDeptCode(), userBean.getLoginID()} )) {
								message = "Sub Group created.";
								createAction = false;																
							} else {
								errorMessage = "Error occured while sub groups were creating.";
							}
						}
					}
				} else {
					errorMessage = "Client Group create fail.";
				}
			} else {
				errorMessage = "Client Group create fail.";
			}
		} else if (updateAction) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE CRM_GROUP ");
			sqlStr.append("SET    CRM_SITE_CODE = ?, CRM_GROUP_DESC = ?, ");
			sqlStr.append("       CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
			sqlStr.append("WHERE  CRM_ENABLED = 1 ");
			sqlStr.append("AND    CRM_GROUP_ID = ?");			
	
			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { siteCode, grpDesc, userBean.getLoginID(), grpID } )) {
				message = "Client Group updated.";
				updateAction = false;
			} else {
				errorMessage = "Client Group update fail.";
			}
		} else if (deleteAction) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("UPDATE CRM_GROUP ");
			sqlStr.append("SET    CRM_ENABLED = 0, CRM_MODIFIED_DATE = SYSDATE, CRM_MODIFIED_USER = ? ");
			sqlStr.append("WHERE  CRM_ENABLED = 1 ");
			sqlStr.append("AND    CRM_GROUP_ID = ?");
	
			if (UtilDBWeb.updateQueue(
					sqlStr.toString(),
					new String[] { userBean.getLoginID(), grpID } )) {
				message = "Client Group removed.";
				closeAction = true;
			} else {
				errorMessage = "Client Group remove fail.";
			}
		}
	}
	
	if(!createAction){		
		if (grpID != null && grpID.length() > 0  ) {
			StringBuffer sqlStr = new StringBuffer();
			sqlStr.append("SELECT CRM_SITE_CODE, CRM_GROUP_DESC ");
			sqlStr.append("FROM   CRM_GROUP ");
			sqlStr.append("WHERE  CRM_ENABLED = 1 ");
			sqlStr.append("AND    CRM_GROUP_ID = ?");	
			
			ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { grpID });
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				siteCode = row.getValue(0);
				grpDesc = row.getValue(1);
				
				sqlStr.setLength(0);
				sqlStr.append("SELECT COUNT(CRM_GROUP_ID) ");
				sqlStr.append("FROM   CRM_GROUP "); 
				sqlStr.append("where  CRM_ENABLED = 1 ");
				sqlStr.append("AND    CRM_PARENT_GROUP_ID = '"+grpID+"' ");
				ArrayList subGrpRecord = UtilDBWeb.getReportableList(sqlStr.toString());
				if (subGrpRecord.size() > 0) {
					ReportableListObject subGrpRow = (ReportableListObject) subGrpRecord.get(0);
					subGroup = subGrpRow.getValue(0);
				}
			} else {
				closeAction = true;
			}
		} else {
			closeAction = true;
		}
	}
	
	if (grpID != null && grpID.length() > 0) {
		StringBuffer sqlStr = new StringBuffer();
		ArrayList record =null;
		
		
		sqlStr.setLength(0);
	
		sqlStr.append("select    C.CRM_CLIENT_ID, C.CRM_LASTNAME, C.CRM_FIRSTNAME, G.CRM_RECEIVE_EMAIL "); 
		sqlStr.append("from      CRM_GROUP_COMMITTEE G, CRM_CLIENTS C ");
		sqlStr.append("where     G.CRM_CLIENT_ID  = C.CRM_CLIENT_ID ");
		sqlStr.append("and       G.CRM_ENABLED = 1 ");
		sqlStr.append("and       G.CRM_GROUP_ID = ? ");
		sqlStr.append("and       G.CRM_GROUP_ID = C.CRM_GROUP_ID ");
		sqlStr.append("and       G.CRM_GROUP_POSITION = 'team_leader' "); 
		sqlStr.append("ORDER BY  C.CRM_LASTNAME, C.CRM_FIRSTNAME ");
		
		record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { grpID });
		if (record.size() > 0) {
			clientLeaderID = new String[record.size()];
			clientLeaderIDDesc = new String[record.size()];
			clientLeaderReceiveEmail = new String[record.size()];
			ReportableListObject row = null;
			
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				String tempClientID = row.getValue(0);
				String clientName = row.getValue(1) +", "+row.getValue(2);
				clientLeaderID[i] = tempClientID;
				clientLeaderIDDesc[i] = clientName;
				clientLeaderReceiveEmail[i] = row.getValue(3);
			}
		} else {
			clientLeaderID = null;
			clientLeaderIDDesc = null;
		}		
		
		request.setAttribute("sub_group_list", fetchSubGroup(grpID));
	}
	
	
	if (grpID != null && grpID.length() > 0) {
		StringBuffer sqlStr = new StringBuffer();
		ArrayList record =null;
		
		
		sqlStr.setLength(0);
		
		sqlStr.append("select    C.CRM_CLIENT_ID, C.CRM_LASTNAME, C.CRM_FIRSTNAME, G.CRM_RECEIVE_EMAIL "); 
		sqlStr.append("from      CRM_GROUP_COMMITTEE G, CRM_CLIENTS C ");
		sqlStr.append("where     G.CRM_CLIENT_ID  = C.CRM_CLIENT_ID ");
		sqlStr.append("and       G.CRM_ENABLED = 1 ");
		sqlStr.append("and       G.CRM_GROUP_ID = ? ");		
		sqlStr.append("and       G.CRM_GROUP_POSITION = 'case_manager' "); 
		sqlStr.append("ORDER BY  C.CRM_LASTNAME, C.CRM_FIRSTNAME ");
		
		//System.out.println(sqlStr.toString());
		
		record = UtilDBWeb.getReportableList(sqlStr.toString(), new String[] { grpID });
		if (record.size() > 0) {
			clientManagerID = new String[record.size()];
			clientManagerIDDesc = new String[record.size()];
			clientManagerReceiveEmail = new String[record.size()];
			ReportableListObject row = null;
		
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				String tempClientID = row.getValue(0);
				String clientName = row.getValue(1) +", "+row.getValue(2);
				clientManagerID[i] = tempClientID;
				clientManagerIDDesc[i] = clientName;
				clientManagerReceiveEmail[i] = row.getValue(3);
			}
		} else {
			clientManagerID = null;
			clientManagerIDDesc = null;
		}
		
	}
	
}
catch (Exception e) {
	e.printStackTrace();
}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
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
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
	<jsp:include page="header.jsp"/>
	<%if (closeAction) { %>
		<script type="text/javascript">window.close();</script>
	<%} else { %>
	<body>
		<jsp:include page="../../common/banner2.jsp"/>
		<div id="indexWrapper">
			<div id="mainFrame">
				<div id="contentFrame">
					<%
						String title = null;
						// set submit label
						title = "function.crm.group." + command;
					%>
			<%if(!"Y".equals(isClient)){ %>
					<jsp:include page="../../common/page_title.jsp" flush="false">
						<jsp:param name="pageTitle" value="<%=title %>" />
						<jsp:param name="category" value="group.crm" />
						<jsp:param name="keepReferer" value="N" />
					</jsp:include>
			<%} %>
					<font color="blue"><%=message %></font>
					<font color="red"><%=errorMessage %></font>
					<form name="form1" action="client_group.jsp" method="post">
						<table cellpadding="0" cellspacing="5"
											class="contentFrameMenu" border="0">
							<tr class="smallText">
								<td class="infoLabel" width="30%">
									<bean:message key="prompt.site" />
								</td>
								<td class="infoData" width="70%">
								<%	if (createAction || updateAction) { %>
									<jsp:include page="../../ui/siteCodeRDB.jsp" flush="false">
										<jsp:param name="allowAll" value="N" />
										<jsp:param name="siteCode" value="<%=siteCode %>" />
									</jsp:include>
								<%	} else { %>
									<%=siteCode==null?"N/A":siteCode.toUpperCase() %>
								<%	} %>
								</td>
							</tr>
							<tr class="smallText">
								<td class="infoLabel" width="30%">
									<bean:message key="prompt.description" />
								</td>
								<td class="infoData" width="70%">
								<%	if (createAction || updateAction) { %>
										<input type="textfield" name="grpDesc" value="<%=grpDesc==null?"":grpDesc %>" maxlength="100" size="50">
								<%	} else { %>
										<%=grpDesc==null?"":grpDesc %>
								<%	} %>
								</td>
							</tr>
							<tr class="smallText">
								<td class="infoLabel" width="30%">
									Number of Sub Group
								</td>
								<td class="infoData" width="70%">
								<%	if (createAction) { %>
									<select name="subGroup">
									 <%for(int i = 0; i < 11; i++){ %>
									   <option value="<%=i%>"><%=i %></option>
									 <%} %>									  
									</select> 
								<%	} else { %>
									<%=subGroup==null?"0":subGroup %>											
	   							<%	} %>
								</td>
							</tr>
						</table>
						<div class="pane">
							<table width="100%" border="0">
								<tr class="smallText">
									<td align="center">
									<%if(!"Y".equals(isClient)){
									if (createAction || updateAction || deleteAction) { %>
										<button onclick="return submitAction('<%=command %>');" class="btn-click">
											<bean:message key="button.save" /> - <bean:message key="<%=title %>" />
										</button>
										<button onclick="return submitAction('view');" class="btn-click">
											<bean:message key="button.cancel" /> - <bean:message key="<%=title %>" />
										</button>
									<%	} else { %>
										<button onclick="return submitAction('edit');" class="btn-click">
											<bean:message key="function.crm.group.update" />
										</button>
										<button class="btn-delete"><bean:message key="function.crm.group.delete" /></button>
									<%	} 
									}
									%>
									</td>
								</tr>
							</table>
						</div>
						<input type="hidden" name="command" value="" />
						<input type="hidden" name="grpID" value="<%=grpID %>"/>
					</form>
					
					<%	if (!createAction) { %>
					<form name="form2" method="post" >
					<div align="center">
					<table cellpadding="0" style="width:50%;" border="0" cellspacing="1"
						class="contentFrameMenu" border="0">
						<tr class="smallText" style="width:50%;">
							<td class="infoLabel" style="text-align:center;" width="50%">Team Leader</td>
							<td class="infoLabel" style="text-align:center;" width="50%">Receive Email</td>
						</tr>	
						
					<%
									if (clientLeaderID != null) {
										for (int i = 0; i < clientLeaderID.length; i++) {
											
					%>
					<tr class="smallText">
					<td class="infoData" style="text-align:center;">											
					<%					try {
					%><bean:message key="<%=clientLeaderIDDesc[i] %>" /><%
											} catch (Exception e) {
					%><%=clientLeaderIDDesc[i] %><%
											}
					%>
					</td>
					<td class="infoData" style="text-align:center;">
						<input type="checkbox" name="" onClick="changeReceiveEmailStatus('team_leader','<%=clientLeaderID[i]%>','<%=grpID%>',this)" <%=("1".equals(clientLeaderReceiveEmail[i])?"checked":"") %>/>
					</td>
					</tr>	
					<%	
										}
									}
					 %>								
							
						<tr class="smallText">
						<td align="center" colspan="2">
						<button onclick="return updateTeam('update','leader');" class="btn-click">Update Team Leader</button>
						</td>
						</tr>				
					</table>	
					
					<table cellpadding="0" style="width:50%;" border="0" cellspacing="1"
						class="contentFrameMenu" border="0">
						<tr class="smallText" style="width:50%;">
							<td class="infoLabel" style="text-align:center;" width="50%">Case Manager</td>
							<td class="infoLabel" style="text-align:center;" width="50%">Receive Email</td>
						</tr>	
					<%
									if (clientManagerID != null) {
										for (int i = 0; i < clientManagerID.length; i++) {
					%>
						<tr class="smallText">
					<td class="infoData" style="text-align:center;">		
					<%
											try {
					%><bean:message key="<%=clientManagerIDDesc[i] %>" /><br/><%
											} catch (Exception e) {
					%><%=clientManagerIDDesc[i] %><br/><%
											}
					%>
					</td>
					<td class="infoData" style="text-align:center;">
						<input type="checkbox" name="" onClick="changeReceiveEmailStatus('case_manager','<%=clientManagerID[i]%>','<%=grpID%>',this)" <%=("1".equals(clientManagerReceiveEmail[i])?"checked":"") %> />
					</td>
					</tr>											
					<%
										}
									}
								 %>								
							<tr class="smallText">
						<td align="center" colspan="2">
						<button onclick="return updateTeam('update','manager');" class="btn-click">Update Case Manager</button>
						</td>
						</tr>								
					</table>
					</div>
					
					<input type="hidden" name="command">
					<input type="hidden" name="grpID" value="<%=grpID%>">					
					<input type="hidden" name="clientGroupID" value="<%=grpID%>">
					<input type="hidden" name="clientGroupDesc" value="<%=grpDesc%>">
					<input type="hidden" name="isClient" value="<%=isClient%>">				
					</form>
					
					
					<br/>
					<div  style="background-color:#32A2F2;color:white;font-size:120%;font-weight:bold;text-align:left;">
						Available Sub Team
					</div>
					
					<bean:define id="functionLabel">
						<bean:message key="function.crm.group.list" />
					</bean:define>
					<bean:define id="notFoundMsg">
						<bean:message key="message.notFound" arg0="<%=functionLabel %>" />
					</bean:define>
					<display:table id="row" name="requestScope.sub_group_list" 
							export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" 
							class="tablesorter">
						<display:column title="" style="width:5%">
							<%=pageContext.getAttribute("row_rowNum")%>)
						</display:column>
						<display:column property="fields0" titleKey="prompt.site" class="smallText" style="width:10%" />
						<display:column property="fields2" title="Sub Team Name" class="smallText" style="width:10%" />
						<display:column property="fields3" titleKey="prompt.modifiedDate" class="smallText" style="width:10%" />
						<display:column titleKey="prompt.action" media="html" class="smallText" style="width:15%">
							<button onclick="return editSubGroup( '<c:out value="${row.fields1}" />');">
								Edit Sub Team
							</button>												
						</display:column>
						<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
					</display:table>
					<%} %>
					
					<script language="javascript">
						function editSubGroup(gid) {
							
							callPopUpWindow("client_subgroup.jsp?command=view&subGrpID="+gid);
														
							return false;
						}
					
						function changeReceiveEmailStatus(type,clientID,groupID,checkbox){														
							var url ='../../crm/portal/receiveEmailStatus.jsp?type='+type+'&clientID='+clientID+'&groupID='+groupID+'&checked='+checkbox.checked;
							
							$.ajax({
								url: url,
								async:true,
								cache:false,
								success: function(values){
									if(values.indexOf('false')!=-1){	
										alert('Error occurred while updating receive email status.');																	
									}								
								},
								error: function() {					
									alert('Error occurred while updating receive email status.');	
								}
							});
						}				
					
						function updateTeam(cmd,type){
							if(type == 'leader'){
								document.form2.action = "client_group_leader.jsp";
							}else if (type == 'manager'){
								document.form2.action = "client_group_caseManager.jsp";
							}
							document.form2.command.value = cmd;							
							document.form2.submit();
						}
					
						function submitAction(cmd) {
						<%	if (createAction || updateAction) { %>
								if (cmd == 'create' || cmd == 'update') {
									if (document.form1.grpDesc.value == '') {
										alert("<bean:message key="error.crm.group.required" />.");
										document.form1.grpDesc.focus();
										return false;
									}
								}
						<%	} %>
							document.form1.command.value = cmd;
							document.form1.submit();
						}
					</script>
				</div>
			</div>
		</div>
		<jsp:include page="../../common/footer.jsp" flush="false" />
	</body>
	<%} %>
</html:html>