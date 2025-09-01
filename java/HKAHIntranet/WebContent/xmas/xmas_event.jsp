<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%!
private static String getNextEventID() {
	String id = null;

	ArrayList result = UtilDBWeb.getReportableList("SELECT MAX(CO_EVENT_ID) + 1 FROM CO_EVENT WHERE  CO_MODULE_CODE = 'christmas'");
	if (result.size() > 0) {
		ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
		//System.out.println(reportableListObject.getValue(0));
		id = reportableListObject.getValue(0);

		// set 1 for initial
		if (id == null || id.length() == 0) return "1";
	}
	return id;
}

private static String getNextGroupID(String eventID) {
	String id = null;

	ArrayList result = UtilDBWeb.getReportableList("SELECT MAX(CO_SCHEDULE_ID) + 1 FROM CO_SCHEDULE WHERE  CO_MODULE_CODE = 'christmas' AND CO_EVENT_ID = '"+eventID+"' ");
	if (result.size() > 0) {
		ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
		//System.out.println(reportableListObject.getValue(0));
		id = reportableListObject.getValue(0);

		// set 1 for initial
		if (id == null || id.length() == 0) return "1";
	}
	return id;
}
%>
<%
UserBean userBean = new UserBean(request);
String sitecode = "";
if(ConstantsServerSide.isHKAH()) {
	sitecode = "hkah";
}
else if(ConstantsServerSide.isTWAH()) {
	sitecode = "twah";
}
String command = request.getParameter("command");
String commandGrp = request.getParameter("commandGrp");
String commandTbl = request.getParameter("commandTbl");
String commandType = request.getParameter("commandType");

String eventName = request.getParameter("eventName");
String eventPrice = request.getParameter("eventPrice");
String eventYear_yy = request.getParameter("eventYear_yy");
String eventYear = eventYear_yy;
String eventID = request.getParameter("eventID");
String eventDate = request.getParameter("eventDate");

String groupNo = request.getParameter("groupNo");
String groupSize = request.getParameter("groupSize");
String scheduleStartDate = request.getParameter("scheduleStartDate");
String scheduleEndDate = request.getParameter("scheduleEndDate");

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean closeAction = false;
boolean viewAction = false;

boolean createGrpAction = false;
boolean updateGrpAction = false;
boolean viewGrpAction = false;

boolean updateTblAction = false;
boolean viewTblAction = false;

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

if ("create".equals(commandGrp)) {
	createGrpAction = true;
} else if ("update".equals(commandGrp)) {
	updateGrpAction = true;
} else if ("view".equals(commandGrp)) {
	viewGrpAction = true;
}

if ("update".equals(commandTbl)) {
	updateTblAction = true;
} else if ("view".equals(commandTbl)) {
	viewTblAction = true;
}

try{
	if("new".equals(command)) {		
		command = "create";
		createAction = true;
	}else if("edit".equals(command)) {
		command = "update";
		updateAction = true;
	}else if("new".equals(commandGrp)){
		commandGrp = "create";
		createGrpAction = true;
	}else if("edit".equals(commandGrp)){
		commandGrp = "update";
		updateGrpAction = true;
	}else if("edit".equals(commandTbl)){	
		commandTbl = "update";
		updateTblAction = true;
	}else {		
		if("event".equals(commandType)){		
			if (createAction) {
				StringBuffer sqlStr = new StringBuffer();
				
				eventID = getNextEventID();
				
				sqlStr.setLength(0);		
				sqlStr.append("	INSERT INTO CO_EVENT(CO_SITE_CODE,CO_MODULE_CODE,CO_EVENT_ID,CO_EVENT_DESC,CO_EVENT_CATEGORY, ");
				sqlStr.append("        CO_EVENT_TYPE,CO_EVENT_REMARK,CO_EVENT_TYPE2,CO_REQUIRE_ASSESSMENT_PASS,CO_CREATED_USER, ");
				sqlStr.append("        CO_MODIFIED_USER, CO_EVENT_REMARK2) ");
				sqlStr.append("VALUES ('"+sitecode+"','christmas','"+eventID+"','"+eventName+"','other','party',");
				sqlStr.append("        '"+eventPrice+"','"+eventYear+"','N','"+userBean.getLoginID()+"','"+userBean.getLoginID()+"', '"+eventDate+"')");
					
				if (UtilDBWeb.updateQueue(
						sqlStr.toString())) {
					message = "Christmas Event created.";
					createAction = false;
					viewAction = true;
					command = "view";
					commandGrp = "view";					
				} else {
					errorMessage = "Christmas Event create fail.";
					eventID = null;
				}
				
			} else if (updateAction) {
				StringBuffer sqlStr = new StringBuffer();
			
				sqlStr.append("UPDATE CO_EVENT ");
				sqlStr.append("SET    CO_EVENT_DESC = '"+eventName+"', CO_EVENT_REMARK= '"+eventPrice+"' , CO_EVENT_TYPE2 = '"+eventYear+"', ");
				sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = '"+userBean.getLoginID()+"', CO_EVENT_REMARK2 = '"+eventDate+"' ");
				sqlStr.append("WHERE  CO_ENABLED = 1 ");
				sqlStr.append("AND    CO_EVENT_ID = '"+eventID+"' ");
				sqlStr.append("AND    CO_MODULE_CODE = 'christmas' ");
				
				if (UtilDBWeb.updateQueue(sqlStr.toString())) {
					message = "Christmas Event updated.";
					updateAction = false;
					command = "view";
				} else {
					errorMessage = "Christmas Event update fail.";
				}
			} else if (deleteAction) {
				
				StringBuffer sqlStr = new StringBuffer();
				sqlStr.append("UPDATE CO_EVENT ");
				sqlStr.append("SET    CO_ENABLED = 0, CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = '"+userBean.getLoginID()+"' ");
				sqlStr.append("WHERE  CO_ENABLED = 1 ");
				sqlStr.append("AND    CO_EVENT_ID = '"+eventID+"'");
				sqlStr.append("AND    CO_MODULE_CODE = 'christmas' ");
				
				if (UtilDBWeb.updateQueue(sqlStr.toString())) {
					message = "Christmas Event removed.";
					closeAction = true;
				} else {
					errorMessage = "Christmas Event remove fail.";
				}
			}
		}else if("group".equals(commandType)){
			if (createGrpAction) {
				StringBuffer sqlStr = new StringBuffer();
				
				boolean createGrpSuccess = false;
				for(int i=1; i<=Integer.parseInt(groupNo)+2;i++){
					sqlStr.setLength(0);
					boolean createCancel = false;
					boolean createWaiting = false;
					boolean createGroup = false;
					if(Integer.parseInt(groupNo)+2 - i == 1){
						createWaiting = true;
					}else if(Integer.parseInt(groupNo)+2 - i == 0){
						createCancel = true;						
					}else{
						createGroup = true;
					}
					
					String tempGroupName = "Group "+i;
					String tempGroupSize = groupSize;
					if(createWaiting){
						tempGroupName = "Waiting";
						tempGroupSize = "0";
					}else if(createCancel){
						tempGroupName = "Cancel";
						tempGroupSize = "0";
					}
										
					sqlStr.append("	INSERT INTO CO_SCHEDULE(CO_SITE_CODE,CO_MODULE_CODE,CO_EVENT_ID,CO_SCHEDULE_ID,CO_SCHEDULE_DESC,CO_SCHEDULE_START, ");
					sqlStr.append("        CO_SCHEDULE_END,CO_SCHEDULE_SIZE,CO_CREATED_USER,CO_MODIFIED_USER) ");			
					sqlStr.append("VALUES ('"+sitecode+"','christmas','"+eventID+"','"+getNextGroupID(eventID)+"','"+tempGroupName+"',");
					sqlStr.append("TO_DATE('"+scheduleStartDate+"' , 'DD/MM/YYYY'),TO_DATE('"+scheduleEndDate+"' , 'DD/MM/YYYY')");
					sqlStr.append(",'"+tempGroupSize+"','"+userBean.getLoginID()+"','"+userBean.getLoginID()+"')");
									
					if (UtilDBWeb.updateQueue(sqlStr.toString())) {						
						createGrpSuccess = true;
					} else {
						createGrpSuccess = false;
					}
				}
				if(createGrpSuccess){
					message = "Christmas Group created.";
					createGrpAction = false;
					viewGrpAction = true;						
					commandGrp = "view";
					commandTbl = "view";
				}else{
					errorMessage = "Christmas Group create fail.";
					eventID = null;
				}
			} else if(updateGrpAction){
				StringBuffer sqlStr = new StringBuffer();
				
				sqlStr.append("UPDATE CO_SCHEDULE ");
				sqlStr.append("SET    CO_SCHEDULE_START = TO_DATE('"+scheduleStartDate+"' , 'DD/MM/YYYY'), CO_SCHEDULE_END = TO_DATE('"+scheduleEndDate+"' , 'DD/MM/YYYY'), ");
				sqlStr.append("       CO_SCHEDULE_SIZE = '"+groupSize+"', ");
				sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = '"+userBean.getLoginID()+"' ");
				sqlStr.append("WHERE  CO_ENABLED = 1 ");
				sqlStr.append("AND    CO_EVENT_ID = '"+eventID+"' ");
				sqlStr.append("AND    CO_MODULE_CODE = 'christmas' ");
				sqlStr.append("AND    CO_SCHEDULE_DESC NOT IN ('Waiting','Cancel') ");
								
				if (UtilDBWeb.updateQueue(sqlStr.toString())) {
					message = "Christmas Group updated.";
					updateGrpAction = false;
					commandGrp = "view";
				} else {
					errorMessage = "Christmas Group update fail.";
				}
			}
		}else if("table".equals(commandType)){
			if(updateTblAction){
				boolean updateTblSuccess = false;
				for (Enumeration e = request.getParameterNames(); e.hasMoreElements();) {
				 String param= e.nextElement().toString();
					if(param.contains("groupTableInsert")){						
						StringBuffer sqlStr = new StringBuffer();
						String tableID = request.getParameter(param);
						String groupID = param.replace("groupTableInsert","");
												
						sqlStr.append("UPDATE CO_SCHEDULE ");
						sqlStr.append("SET    CO_LOCATION_DESC = '"+tableID+"', ");
						sqlStr.append("       CO_MODIFIED_DATE = SYSDATE, CO_MODIFIED_USER = '"+userBean.getLoginID()+"' ");
						sqlStr.append("WHERE  CO_ENABLED = 1 ");
						sqlStr.append("AND    CO_EVENT_ID = '"+eventID+"' ");
						sqlStr.append("AND    CO_SCHEDULE_ID = '"+groupID+"' ");
						sqlStr.append("AND    CO_MODULE_CODE = 'christmas' ");
						sqlStr.append("AND    CO_SCHEDULE_DESC NOT IN ('Waiting','Cancel') ");
						
						if (UtilDBWeb.updateQueue(sqlStr.toString())) {						
							updateTblSuccess = true;
						} else {
							updateTblSuccess = false;
						}
						
					}
				}
				if(updateTblSuccess){
					message = "Group Table updated.";
					updateTblAction = false;
					commandTbl = "view";
				} else {
					errorMessage = "Group Table update fail.";
				}
			}			
		}
	}

	if (eventID!=null && eventID.length()>0) {
		StringBuffer sqlStr = new StringBuffer();
	
		sqlStr.setLength(0);
		sqlStr.append("SELECT  CO_EVENT_ID, CO_EVENT_DESC,CO_EVENT_TYPE2,CO_EVENT_REMARK ");
		sqlStr.append("FROM    CO_EVENT ");
		sqlStr.append("WHERE   CO_MODULE_CODE = 'christmas' ");
		sqlStr.append("AND     CO_ENABLED = 1 ");
		sqlStr.append("AND     CO_EVENT_ID = '"+eventID+"' ");
		
		ArrayList eventRecord = UtilDBWeb.getReportableList(sqlStr.toString());
		if (eventRecord.size() > 0) {			
			ReportableListObject eventRow = (ReportableListObject) eventRecord.get(0);			
			eventName = eventRow.getValue(1);
			eventYear = eventRow.getValue(2);
			eventPrice = eventRow.getValue(3);
		} 	
		
		sqlStr.setLength(0);
	
		sqlStr.append(" SELECT   CO_SCHEDULE_SIZE,TO_CHAR(CO_SCHEDULE_START, 'DD/MM/YYYY'),TO_CHAR(CO_SCHEDULE_END, 'DD/MM/YYYY'), ");
		sqlStr.append("(SELECT MAX(CO_SCHEDULE_ID) -2 ");
		sqlStr.append("FROM CO_SCHEDULE ");
		sqlStr.append("WHERE  CO_MODULE_CODE = 'christmas' ");
		sqlStr.append("AND CO_ENABLED = '1' ");
		sqlStr.append("AND CO_EVENT_ID = '"+eventID+"') "); 
		sqlStr.append("FROM CO_SCHEDULE ");
		sqlStr.append("WHERE  CO_MODULE_CODE = 'christmas' ");
		sqlStr.append("AND CO_EVENT_ID = '"+eventID+"' ");
		sqlStr.append("AND CO_SCHEDULE_ID = '1' ");		
		sqlStr.append("AND CO_ENABLED = '1' ");		
		
		ArrayList groupRecord = UtilDBWeb.getReportableList(sqlStr.toString());
		if (groupRecord.size() > 0) {			
			ReportableListObject groupRow = (ReportableListObject) groupRecord.get(0);			

			groupNo = groupRow.getValue(3);
			groupSize = groupRow.getValue(0);
			scheduleStartDate = groupRow.getValue(1);
		 	scheduleEndDate = groupRow.getValue(2);
		}else{
			groupNo = "";
			groupSize = "";
			scheduleStartDate = "";
		 	scheduleEndDate = "";
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
<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp"/>
	<%if (closeAction) { %>
		<script type="text/javascript">window.close();</script>
	<%} else { %>
	<body>
		<jsp:include page="../common/banner2.jsp"/>
		<div id="indexWrapper">
			<div id="mainFrame">
				<div id="contentFrame">
					<%	String title = null;						
						title = "function.xmas." + command;	%>			
					<jsp:include page="../common/page_title.jsp" flush="false">
						<jsp:param name="pageTitle" value="<%=title %>" />
						<jsp:param name="category" value="group.xmas" />
						<jsp:param name="keepReferer" value="N" />
						<jsp:param name="accessControl" value="N"/>
					</jsp:include>			
					<font color="blue"><%=message %></font>
					<font color="red"><%=errorMessage %></font>
					
					<form name="form1" action="xmas_event.jsp" method="post">
						<table cellpadding="0" cellspacing="5"
											class="contentFrameMenu" border="0">						
							<tr class="smallText">
								<td class="infoLabel" width="30%">
									Name
								</td>
								<td class="infoData" width="70%">
								<%	if (createAction || updateAction) { %>
										<input type="textfield" name="eventName" value="<%=eventName==null?"":eventName %>" maxlength="100" size="50">
								<%	} else { %>
										<%=eventName==null?"":eventName %>
								<%	} %>
								</td>
							</tr>
							<tr class="smallText">
								<td class="infoLabel" width="30%">
									Price
								</td>
								<td class="infoData" width="70%">
								<%	if (createAction || updateAction) { %>
										<input type="textfield" name="eventPrice" value="<%=eventPrice==null?"":eventPrice %>" maxlength="100" size="50">
								<%	} else { %>
										<%=eventPrice==null?"":eventPrice %>
								<%	} %>
								</td>
							</tr>
							
							<tr class="smallText">
								<td class="infoLabel" width="30%">
									Year
								</td>
								<td class="infoData" width="70%">
								<%								
								if (createAction || updateAction) { %>															
										<jsp:include page="../ui/dateCMB.jsp" flush="false"> 
										<jsp:param name="label" value="eventYear" />								
										<jsp:param name="yearRange" value="5" />									
										<jsp:param name="day_yy" value="<%=eventYear %>" />
										<jsp:param name="defaultValue" value="N" />
										<jsp:param name="isYearOnly" value="Y" />
										<jsp:param name="isObBkUse" value="Y" />										
										<jsp:param name="allowEmpty" value="N"/>									
										<jsp:param name="isYearOrderDesc" value="N"/>
										</jsp:include>										
								<%	} else { %>
										<%=eventYear==null?"":eventYear %>
								<%	} %>
								</td>
							</tr>
							
							<tr class="smallText">
								<td class="infoLabel" width="30%">
									Event Date
								</td>
								<td class="infoData" width="70%">
								<%								
								if (createAction || updateAction) { %>															
										<input type="textfield" name="eventDate" id="eventDate" 
												class="datepickerfield" value="<%=eventDate==null?"":eventDate %>" maxlength="10" size="9" onkeyup="validDate(this)" 
												onblur="validDate(this)"></input>										
								<%	} else { %>
										<%=eventDate==null?"":eventDate %>
								<%	} %>
								</td>
							</tr>
						</table>
						<div class="pane">
							<table width="100%" border="0">
								<tr class="smallText">
									<td align="center">
									<%	if (createAction || updateAction || deleteAction) { %>
										<button onclick="return submitAction('<%=command %>','event');" class="btn-click">
											<bean:message key="button.save" /> - <bean:message key="<%=title %>" />
										</button>
											<%if(createAction){%>
												<button onclick="window.close();" class="btn-click">
													<bean:message key="button.cancel" /> - <bean:message key="<%=title %>" />
												</button>
											<%}else{%>										
												<button onclick="return submitAction('view','event');" class="btn-click">
													<bean:message key="button.cancel" /> - <bean:message key="<%=title %>" />
												</button>
									<%		}
										} else { %>
										<button onclick="return submitAction('edit','event');" class="btn-click">
											<bean:message key="function.xmas.update" />
										</button>
										<button onclick="return submitAction('delete','event')" class="btn-click"><bean:message key="function.xmas.delete" /></button>
									<%	} 	%>
									</td>
								</tr>
							</table>
						</div>
					
						<%	if(!createAction){
							title = null;							
							title = "function.xmas.group." + commandGrp; %>
						
						<jsp:include page="../common/page_title.jsp" flush="false">
							<jsp:param name="pageTitle" value="<%=title %>" />
							<jsp:param name="category" value="group.xmas" />
							<jsp:param name="keepReferer" value="N" />
							<jsp:param name="accessControl" value="N"/>
						</jsp:include>		
						
						<table cellpadding="0" cellspacing="5"
											class="contentFrameMenu" border="0">						
							<tr class="smallText">
								<td class="infoLabel" width="30%">
									Number of Groups
								</td>
								<td class="infoData" width="70%">
								<%	if (createGrpAction) { %>
										<select name='groupNo'>
										<%for(int i = 1 ; i <= 50;i++){%>
											<option value=<%=i%>><%=i%></option>
										<%}%>										
										</select>
								<%	} else { %>
										<%=groupNo==null?"":groupNo %>
								<%	} %>
								</td>
							</tr>	
							<tr class="smallText">
								<td class="infoLabel" width="30%">
									Group Size
								</td>
								<td class="infoData" width="70%">
								<%	if (createGrpAction || updateGrpAction) { %>
										<select name='groupSize'>
										<%for(int i = 1 ; i <= 25;i++){%>
											<option <%=Integer.toString(i).equals(groupSize)?" selected":"" %> value=<%=i%>><%=i%></option>
										<%}%>										
										</select>
								<%	} else { %>
										<%=groupSize==null?"":groupSize %>
								<%	} %>
								</td>
							</tr>
							<tr class="smallText">
								<td class="infoLabel" width="30%">
									Schedule start date
								</td>
								<td class="infoData" width="70%">	
								<%	if (createGrpAction || updateGrpAction) { %>							
								<input type="textfield" name="scheduleStartDate" id="scheduleStartDate" 
								class="datepickerfield" value="<%=scheduleStartDate==null?"":scheduleStartDate %>" maxlength="10" size="9" onkeyup="validDate(this)" 
								onblur="validDate(this)"></input>
								<%}else{ %>
									<%=scheduleStartDate==null?"":scheduleStartDate  %>
								<%} %>
								</td>
							</tr>			
							<tr class="smallText">
								<td class="infoLabel" width="30%">
									Schedule End date
								</td>
								<td class="infoData" width="70%">	
								<%	if (createGrpAction || updateGrpAction) { %>							
								<input type="textfield" name="scheduleEndDate" id="scheduleEndDate" 
								class="datepickerfield" value="<%=scheduleEndDate==null?"":scheduleEndDate  %>" maxlength="10" size="9" onkeyup="validDate(this)" 
								onblur="validDate(this)"></input>
								<%}else{ %>
									<%=scheduleEndDate==null?"":scheduleEndDate  %>
								<%} %>
								</td>
							</tr>						
						</table>
						<div class="pane">
							<table width="100%" border="0">
								<tr class="smallText">
									<td align="center">	
									<%	if (createGrpAction || updateGrpAction) { %>										
										<button onclick="return submitAction('','group','<%=commandGrp %>');" class="btn-click">
											<bean:message key="button.save" /> - <bean:message key="<%=title %>" />
										</button>
										<button onclick="return submitAction('','group','view');" class="btn-click">
											<bean:message key="button.cancel" /> - <bean:message key="<%=title %>" />
										</button>
									<%}else{
										if(groupNo!=null&&groupNo.length()>0){%>
										<button onclick="return submitAction('','group','edit');" class="btn-click">
											<bean:message key="function.xmas.group.update" />
										</button>											
										<%}else{%>
										<button onclick="return submitAction('','group','new');" class="btn-click">
											<bean:message key="function.xmas.group.create" />
										</button>
									<%	}}%>
									</td>
								</tr>
							</table>
						</div>
						
							<%if(groupNo!=null&&groupNo.length()>0){
							title = null;							
							title = "function.xmas.table." + commandTbl; %>
						
							<jsp:include page="../common/page_title.jsp" flush="false">
								<jsp:param name="pageTitle" value="<%=title %>" />
								<jsp:param name="category" value="group.xmas" />
								<jsp:param name="keepReferer" value="N" />
								<jsp:param name="accessControl" value="N"/>
							</jsp:include>		
							<table border="0" style="width:100%">
							<%	StringBuffer sqlStr = new StringBuffer();
								sqlStr.setLength(0);
																
								sqlStr.append("SELECT   CO_SCHEDULE_ID	,CO_SCHEDULE_DESC, CO_LOCATION_DESC ");								 
								sqlStr.append("FROM     CO_SCHEDULE ");
								sqlStr.append("WHERE    CO_MODULE_CODE = 'christmas' ");
								sqlStr.append("AND      CO_EVENT_ID = '"+eventID+"' ");								
								sqlStr.append("AND      CO_SCHEDULE_DESC NOT IN ('Waiting','Cancel') ");
								sqlStr.append("AND 	    CO_ENABLED = '1' ");
								sqlStr.append("ORDER BY CO_SCHEDULE_ID ");
								ArrayList groupListRecord = UtilDBWeb.getReportableList(sqlStr.toString());
								for(int i = 0; i < groupListRecord.size(); i++) {			
									ReportableListObject groupListRow = (ReportableListObject) groupListRecord.get(i);	
									String groupName = groupListRow.getValue(1);
									String groupTableName = groupListRow.getValue(2);
									String groupID = groupListRow.getValue(0);
								%>
								<tr>
									<td class="infoLabel" width="30%"><%=groupName%> - Table No.</td>
									<td class="infoData" width="70%">
									<%	if (updateTblAction) { %>
										<input type="textfield" name="groupTableInsert<%=groupID %>" value="<%=groupTableName==null?"":groupTableName%>" maxlength="100" size="50">
									<%}else{ %>
										<%=groupListRow.getValue(2)%>
									<%} %>
									</td>
								</tr>
								<%}%>							
							</table>
							<div class="pane">
								<table width="100%" border="0">
									<tr class="smallText">
										<td align="center">	
										<%	if (updateTblAction) { %>										
											<button onclick="return submitAction('','table','','<%=commandTbl %>');" class="btn-click">
												<bean:message key="button.save" /> - <bean:message key="<%=title %>" />
											</button>
											<button onclick="return submitAction('','table','','view');" class="btn-click">
												<bean:message key="button.cancel" /> - <bean:message key="<%=title %>" />
											</button>
										<%}else{%>											
											<button onclick="return submitAction('','table','','edit');" class="btn-click">
												<bean:message key="function.xmas.table.update" />
											</button>
										<%}%>
										</td>
									</tr>
								</table>
							</div>
							<%}%>
													
						<%} %>
						
						
						<input type="hidden" name="command" value="<%=command%>" />
						<input type="hidden" name="commandGrp" value="<%=commandGrp %>" />
						<input type="hidden" name="commandTbl" value="<%=commandTbl %>" />
						<input type="hidden" name="commandType" value="<%=commandType%>"/>
						<input type="hidden" name="eventID" value="<%=eventID %>"/>
					</form>
				</div>
			</div>
		</div>
		<jsp:include page="../common/footer.jsp" flush="false" />
	</body>
	<%} %>
</html:html>
<script language="javascript">
	function submitAction(cmd,cmdType,cmdGrp,cmdTbl) {			
		if(cmd == 'delete'){
			 var deleteRecord = confirm("Delete event ?");
			 if( deleteRecord == true ){
				 sendActions(cmd,cmdType,cmdGrp,cmdTbl);
			 }
		}else{
			sendActions(cmd,cmdType,cmdGrp,cmdTbl);
		}
	}
	
	function sendActions(cmd,cmdType,cmdGrp,cmdTbl){
		if(cmd){			
			document.form1.command.value = cmd;
		}
		if(cmdType){
			document.form1.commandType.value = cmdType;
		}
		if(cmdGrp){			
			document.form1.commandGrp.value = cmdGrp;
		}		
		if(cmdTbl){			
			document.form1.commandTbl.value = cmdTbl;
		}
		
		if(cmdType == 'group' && cmdGrp != 'view'){		
			if($('#scheduleStartDate').val()){				
				if(!validDate(document.form1.scheduleStartDate)){
					alert('Schedule start date not valid');
					return false;
				}
			}
			if($('#scheduleEndDate').val()){				
				if(!validDate(document.form1.scheduleEndDate)){
					alert('Schedule end date not valid');
					return false;
				}
			}
				
		}
		
		document.form1.submit();
	}
</script>