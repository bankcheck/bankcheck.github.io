<%@ page import="java.util.*"%><%@ 
page import="com.hkah.util.*"%><%@
page import="com.hkah.util.db.*"%><%@
page import="com.hkah.web.common.*"%><%@ 
page import="com.hkah.web.db.*"%><%
 
int chk =  Integer.parseInt(request.getParameter("p1")) ;
System.err.println("[chk]:"+chk);
String rtnFlag = null;
int alreadyOrder = 0;
String login = null;
String pwd = null;
String userType = null;
String patNo = null;
String rtn = null;
int noOfReq = 0;

switch(chk) 
{ 
case 1:
	login = request.getParameter("p2");
	pwd = request.getParameter("p3");
	pwd = PasswordUtil.cisEncryption(pwd);
	System.err.println("[login]:"+login+";[pwd]:"+pwd);		
	ArrayList<ReportableListObject> record = null;
	record = UtilDBWeb.getFunctionResultsHATS("NHS_ACT_LOGON_SECHKUPPAT", new String[] { login, pwd, "counterSign2", null });
	if (record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);

		rtnFlag = row.getValue(0);
		System.err.println("0[rtnFlag]:"+rtnFlag+";[login]:"+login+";");
		if("counterSign2".equals(rtnFlag)){
			rtnFlag = "-1";
		}else if(login.equals(rtnFlag)){
			rtnFlag = "1";
		}else{
			rtnFlag = "1";			
		}
	}else{
		rtnFlag = "-2";
	}
	System.err.println("[rtnFlag]:"+rtnFlag);
	break;
case 2:	
	patNo = request.getParameter("p2");		
	ArrayList<ReportableListObject> record2 = null;
	record2 = UtilDBWeb.getFunctionResultsHATS("HKAH.NHS_GET_PATIENT", new String[] { patNo });
	if (record2.size() > 0) {
		ReportableListObject row = (ReportableListObject) record2.get(0);
		rtnFlag = row.getValue(31);
		System.out.println("0[rtnFlag]:"+rtnFlag+";[patNo]:"+patNo+";");
	}else{
		rtnFlag = "-2";
	}	
	break;	
}

%><%@ page language="java" contentType="text/html; charset=big5" %><%=rtnFlag != null ? rtnFlag : "0" %>

