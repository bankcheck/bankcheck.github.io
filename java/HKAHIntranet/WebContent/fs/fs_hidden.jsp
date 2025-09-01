<%@ page import="java.util.*"%><%@ 
page import="com.hkah.constant.*"%><%@
page import="com.hkah.util.*"%><%@ 
page import="com.hkah.web.common.*"%><%@ 
page import="com.hkah.web.db.*"%><%

UserBean userBean = new UserBean(request);
int chk = Integer.parseInt(request.getParameter("p1")) ;
String siteCode = ConstantsServerSide.SITE_CODE;
String postDate = request.getParameter("p2");
String listReturn = null;
int rowCnt = 0;
int rowCnt1 = 0;

String rtnFlag = null;

switch(chk) 
{ 
case 1:
	ArrayList record = FsDB.existPostDate(postDate);
	ReportableListObject row = (ReportableListObject) record.get(0);

	try {
		rowCnt = Integer.parseInt(row.getValue(0));
	}
	catch (Exception ex) {
		rowCnt = 0;
	}

	ArrayList record1 = FsDB.billStatusAva(); // CHECK EXISTING BILLING STATUS
	ReportableListObject row1 = (ReportableListObject) record1.get(0);
	try {
		rowCnt1 = Integer.parseInt(row1.getValue(0));
	}
	catch (Exception ex) {
		rowCnt1 = 0;
	}
		
	if(rowCnt1>0){
		if(rowCnt>0){
			rtnFlag = "-1";		
		}else{
			rtnFlag = Integer.toString(rowCnt1);		
		}

	}else{
		rtnFlag = "-2";
	}	
	break;
case 2:
	listReturn =FsDB.execFuncGetList("F_FS_EXPORT2FLEX",userBean,postDate,siteCode);
	if(listReturn != null && "JV".equals(listReturn.substring(0,2))){
		rtnFlag = listReturn;
	}else{		
		rtnFlag = "1";	
	}
	break;
}

System.err.println("[rtnFlag]:"+rtnFlag);
%><%@ page language="java" contentType="text/html; charset=big5" %><%=rtnFlag != null ? rtnFlag : "0" %>

