<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%
UserBean userBean = new UserBean(request);
String serverSiteCode = ConstantsServerSide.SITE_CODE;

String mealID = request.getParameter("mealID");
String mealType = request.getParameter("mealType");
String reqStatus = request.getParameter("reqStatus");
boolean allowAll = "Y".equals(request.getParameter("allowAll"));
boolean allowEmpty = "Y".equals(request.getParameter("allowEmpty"));

if (allowEmpty) {
	String emptyLabel = request.getParameter("emptyLabel");
	System.err.println("[emptyLabel]:"+emptyLabel);	
%><option value=""><%=emptyLabel %></option><%
}
ArrayList record = null;
System.err.println("[reqStatus]:"+reqStatus+";[allowAll]:"+allowAll+";[dept]:"+userBean.getDeptCode());
if(reqStatus==null){
	if(allowAll){
		record = FsDB.getList("",mealType,userBean.getDeptCode());			
	}else{
		record = FsDB.getList(mealID, mealType, userBean.getDeptCode());			
	}	
}else{
	if("S".equals(reqStatus)){
		record = FsDB.getList("",mealType,userBean.getDeptCode());
	}else{
		if(allowAll){
			record = FsDB.getList("", mealType, userBean.getDeptCode());		
		}else{
			record = FsDB.getList(mealID, mealType, userBean.getDeptCode());
		}
	}	
}

ReportableListObject row = null;

if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
%><option value="<%=row.getValue(0) %>"<%=row.getValue(0).equals(mealID)?" selected":"" %>><%=row.getValue(1) %></option><%
	}
}
%>