<!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
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
		See the License for the specifi	c language governing permissions and
		limitations under the License.
--%>


<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.web.db.*"%>
<%UserBean userBean = new UserBean(request); 

%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp">
<jsp:param name="issortable" value="N" />
</jsp:include>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<% String pageTitle = "IT Services Survey 2010 Result Report"; %>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=pageTitle %>" />
	<jsp:param name="category" value="<%=pageTitle %>" />
	<jsp:param name="translate" value="N" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="pageMap" value="N" />
</jsp:include>


<%

ArrayList record = null;
ReportableListObject row = null;

record = EvaluationDB.getsurveyreport("2","hkah","N","1","2","3","4","5","7");
System.out.println(record);
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i); %>
		
<%		
	}
}
%>


<%

ArrayList record1 = null;
ReportableListObject row1 = null;
record1 = EvaluationDB.getsurveyreport("2","twah","N","1","2","3","4","5","7");
if (record1.size() > 0) {
	for (int i = 0; i < record1.size(); i++) {
		row1 = (ReportableListObject) record1.get(i); %>
		
<%		
	}
	
}

%>
<%
ReportableListObject row4 = new ReportableListObject(9);
row4.setValue(0,"hkah");
for(int i=1; i<9; i++)
	row4.setValue(i,"");

ArrayList<ReportableListObject> printrecord = new ArrayList<ReportableListObject>();
printrecord.add(0,row4);

for(int k=0;k<record.size();k++)
{
  printrecord.add(k+1,(ReportableListObject) record.get(k));
}
int countrecord = 0;
ReportableListObject row3 = new ReportableListObject(9);
row3.setValue(0,"twah");
for(int i=1; i<9; i++)
	row3.setValue(i,"");

printrecord.add(record.size()+1,row3);

for(int j=record.size()+2;j<record.size()+record1.size()+2;j++)
{
  printrecord.add(j,(ReportableListObject) record1.get(countrecord));
  countrecord++;
}
request.setAttribute("hkah_list",printrecord);

%>

<bean:define id="functionLabel"><bean:message key="function.accessControl.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<table><tr><td height = 20></td></tr></table>
<display:table id="row2" name="requestScope.hkah_list" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">
	<display:column title="Question No" style="width:15%" ><c:out value="${row2.fields0}" /></display:column>
	<display:column title="Question" style="width:25%"><c:out value="${row2.fields1}" /></display:column>
	<display:column title="1" style="width:10%;text-align: center"><c:out value="${row2.fields2}" /></display:column>
	<display:column title="2" style="width:10%;text-align: center"><c:out value="${row2.fields3}" /></display:column>
	<display:column title="3" style="width:10%;text-align: center"><c:out value="${row2.fields4}" /></display:column>
	<display:column title="4" style="width:10%;text-align: center"><c:out value="${row2.fields5}" /></display:column>
	<display:column title="5" style="width:10%;text-align: center"><c:out value="${row2.fields6}" /></display:column>
	<display:column title="N/A" style="width:10%;text-align: center" ><c:out value="${row2.fields7}" /></display:column>

	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
	<display:setProperty name="sort.amount" value="list"/>
</display:table>




</DIV>
</DIV></DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>