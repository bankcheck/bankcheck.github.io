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
<% String pageTitle = "Intranet Portal Survey Result Report"; %>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=pageTitle %>" />
	<jsp:param name="category" value="<%=pageTitle %>" />
	<jsp:param name="translate" value="N" />
	<jsp:param name="mustLogin" value="N" />
	<jsp:param name="pageMap" value="N" />
</jsp:include>


<%

ArrayList record = null;
ArrayList record_textq1 = null;
ArrayList record_textq2 = null;
ArrayList record_textq3 = null;
int S1_qno = 8;
int S3_qno = 30;
int S4_qno = 30;

record = EvaluationDB.getsurveyreport("3",null,"N","1","2","3","4","5","6");
record_textq1 = EvaluationDB.getsurveyreporttext("3",null,"9");
record_textq2 = EvaluationDB.getsurveyreporttext("3",null,"70");
record_textq3 = EvaluationDB.getsurveyreporttext("3",null,"71");

ArrayList<ReportableListObject> textrecord = new ArrayList<ReportableListObject>();
ArrayList<ReportableListObject> textrecord1 = new ArrayList<ReportableListObject>();
ArrayList<ReportableListObject> textrecord2 = new ArrayList<ReportableListObject>();

for(int j=0;j<record_textq1.size();j++)
{
 ReportableListObject rowtemp = new ReportableListObject(8);
 rowtemp.setValue(0,"text");
 rowtemp.setValue(1,((ReportableListObject)record_textq1.get(j)).getFields0());
 rowtemp.setValue(2,"");
 rowtemp.setValue(3,"");
 rowtemp.setValue(4,"");
 rowtemp.setValue(5,"");
 rowtemp.setValue(6,"");
 rowtemp.setValue(7,"");
 textrecord.add(j,rowtemp);
}
for(int j=0;j<record_textq2.size();j++)
{
 ReportableListObject rowtemp = new ReportableListObject(8);
 rowtemp.setValue(0,"text");
 rowtemp.setValue(1,((ReportableListObject)record_textq2.get(j)).getFields0());
 rowtemp.setValue(2,"");
 rowtemp.setValue(3,"");
 rowtemp.setValue(4,"");
 rowtemp.setValue(5,"");
 rowtemp.setValue(6,"");
 rowtemp.setValue(7,"");
 textrecord1.add(j,rowtemp);
}

for(int j=0;j<record_textq3.size();j++)
{
 ReportableListObject rowtemp = new ReportableListObject(8);
 rowtemp.setValue(0,"text");
 rowtemp.setValue(1,((ReportableListObject)record_textq3.get(j)).getFields0());
 rowtemp.setValue(2,"");
 rowtemp.setValue(3,"");
 rowtemp.setValue(4,"");
 rowtemp.setValue(5,"");
 rowtemp.setValue(6,"");
 rowtemp.setValue(7,"");
 textrecord2.add(j,rowtemp);
}


ReportableListObject row4 = new ReportableListObject(8);
row4.setValue(0,"");
row4.setValue(1,"Rating of overall Intranet Portal");
row4.setValue(2,"Outstanding");
row4.setValue(3,"Very Good");
row4.setValue(4,"Good");
row4.setValue(5,"Fair");
row4.setValue(6,"Poor");
row4.setValue(7,"Unable to rate");

ReportableListObject row5 = new ReportableListObject(8);
row5.setValue(0,"");
row5.setValue(1,"Most frequently used sections");
row5.setValue(2,"Once daily");
row5.setValue(3,"Two or more times everyday");
row5.setValue(4,"Once every week");
row5.setValue(5,"Once every two weeks");
row5.setValue(6,"Once a month");
row5.setValue(7,"Unable to rate");

ReportableListObject textquest1 = new ReportableListObject(8);
textquest1.setValue(0,"Yes");
textquest1.setValue(1,"2 things that matters to interviewee most when using the Intranet Portal");
ReportableListObject textquest2 = new ReportableListObject(8);
textquest2.setValue(0,"Yes");
textquest2.setValue(1,"Suggestions to improve Intranet Portal");
ReportableListObject textquest3 = new ReportableListObject(8);
textquest3.setValue(0,"Yes");
textquest3.setValue(1,"Information suggested to host onto Intranet Portal");

ArrayList<ReportableListObject> printrecord = new ArrayList<ReportableListObject>();
printrecord.add(0,row4);

if (record.size() > 0) {
for(int k=0;k<S1_qno;k++)
	{
  	printrecord.add(k+1,(ReportableListObject) record.get(k));
	}
printrecord.add(S1_qno+1,row5);
for(int k=S1_qno;k<S1_qno+S3_qno;k++)
	{
  	printrecord.add(k+2,(ReportableListObject) record.get(k));
	}
printrecord.add(S1_qno+S3_qno+2,row4);
for(int k=S1_qno+S3_qno;k<S1_qno+S3_qno+S4_qno;k++)
{
	printrecord.add(k+3,(ReportableListObject) record.get(k));
}
printrecord.add(S1_qno+S3_qno+S4_qno+3,textquest1);

for(int k=0;k<textrecord.size();k++)
{
	printrecord.add(S1_qno+S3_qno+S4_qno+4+k,textrecord.get(k));
}
printrecord.add(S1_qno+S3_qno+S4_qno+textrecord.size()+4,textquest2);

for(int k=0;k<textrecord1.size();k++)
{
	printrecord.add(S1_qno+S3_qno+S4_qno+textrecord.size()+5+k,textrecord1.get(k));
}
printrecord.add(S1_qno+S3_qno+S4_qno+textrecord.size()+textrecord1.size()+5,textquest3);
for(int k=0;k<textrecord2.size();k++)
{
	printrecord.add(S1_qno+S3_qno+S4_qno+textrecord.size()+textrecord1.size()+6+k,textrecord2.get(k));
}

}


request.setAttribute("hkah_intranet",printrecord);

%>

<bean:define id="functionLabel"><bean:message key="function.accessControl.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<table><tr><td height = 20></td></tr></table>
<display:table id="row2" name="requestScope.hkah_intranet" export="true"  class="tablesorter">
<%	if (((ReportableListObject)pageContext.getAttribute("row2")).getFields0() == "Yes") {  %>
	<display:column title="" style="width:40%;font-weight:bold;background-color:#6b8899; font-size:14px;"><c:out value="${row2.fields1}" /></display:column>
	<display:column title="" style="width:10%;text-align: center;bold;background-color:#6b8899;"><c:out value="${row2.fields2}" /></display:column>
	<display:column title="" style="width:10%;text-align: center;bold;background-color:#6b8899;"><c:out value="${row2.fields3}" /></display:column>
	<display:column title="" style="width:10%;text-align: center;bold;background-color:#6b8899;"><c:out value="${row2.fields4}" /></display:column>
	<display:column title="" style="width:10%;text-align: center;bold;background-color:#6b8899;"><c:out value="${row2.fields5}" /></display:column>
	<display:column title="" style="width:10%;text-align: center;bold;background-color:#6b8899;"><c:out value="${row2.fields6}" /></display:column>
	<display:column title="" style="width:10%;text-align: center;bold;background-color:#6b8899;"><c:out value="${row2.fields7}" /></display:column>
<%}else if (((ReportableListObject)pageContext.getAttribute("row2")).getFields0() == "text") { %>
   	<display:column title="" style="width:40%;font-weight:bold; font-size:14px;"><c:out value="${row2.fields1}" /></display:column>
	<display:column title="" style="width:10%;text-align: center;bold;"><c:out value="${row2.fields2}" /></display:column>
	<display:column title="" style="width:10%;text-align: center;bold;"><c:out value="${row2.fields3}" /></display:column>
	<display:column title="" style="width:10%;text-align: center;bold;"><c:out value="${row2.fields4}" /></display:column>
	<display:column title="" style="width:10%;text-align: center;bold;"><c:out value="${row2.fields5}" /></display:column>
	<display:column title="" style="width:10%;text-align: center;bold;"><c:out value="${row2.fields6}" /></display:column>
	<display:column title="" style="width:10%;text-align: center;bold;"><c:out value="${row2.fields7}" /></display:column>
<%} else { %>
	<display:column title="Question" style="width:40%"><c:out value="${row2.fields1}" /></display:column>
	<display:column title="" style="width:10%;text-align: center"><c:out value="${row2.fields2}" /></display:column>
	<display:column title="" style="width:10%;text-align: center"><c:out value="${row2.fields3}" /></display:column>
	<display:column title="" style="width:10%;text-align: center"><c:out value="${row2.fields4}" /></display:column>
	<display:column title="" style="width:10%;text-align: center"><c:out value="${row2.fields5}" /></display:column>
	<display:column title="" style="width:10%;text-align: center"><c:out value="${row2.fields6}" /></display:column>
	<display:column title="" style="width:10%;text-align: center"><c:out value="${row2.fields7}" /></display:column>
<%} %>

	


	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>
	<display:setProperty name="sort.amount" value="list"/>
</display:table>




</DIV>
</DIV></DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>