<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.mail.UtilMail" %>

<%!
public class ChaplainValue{
	String chapID;
	String value;
	public ChaplainValue(String chapID,String value){
		this.chapID = chapID;
		this.value = value;
	}
}

public static ArrayList checkChapExists(String chapID){
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT CHAPID  ");
	sqlStr.append("FROM CHAP_AREA ");
	sqlStr.append("WHERE CHAPID ='"+chapID+"' ");
	sqlStr.append("AND ENABLE ='1' ");

	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public static boolean insertChaplainArea(UserBean userBean,String chapID,String ward,String type){
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("INSERT INTO CHAP_AREA(ID, CHAPID," + type +",CREATE_USER,MODIFIED_USER) ");
	sqlStr.append("VALUES ('"+getNextID()+"','"+chapID+"','"+ward+"', '"+userBean.getLoginID()+"', '"+userBean.getLoginID()+"') ");
	//System.out.println(sqlStr.toString());

	return UtilDBWeb.updateQueue(sqlStr.toString());
}

public static boolean editChapArea(UserBean userBean,String chapID,String ward,String type){
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("UPDATE CHAP_AREA  ");
	sqlStr.append("SET " + type + " = '"+ward+"', ");
	sqlStr.append("ENABLE = '1', ");
	sqlStr.append("MODIFIED_DATE=SYSDATE, ");
	sqlStr.append("MODIFIED_USER='" + userBean.getLoginID() + "' ");
	sqlStr.append("WHERE CHAPID = '" + chapID + "' ");

	//System.out.println(sqlStr.toString());

	return UtilDBWeb.updateQueue(sqlStr.toString());
}

public static ArrayList checkPatientExists(String patID){
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT REF_PATNO  ");
	sqlStr.append("FROM CHAP_AREA ");
	sqlStr.append("WHERE REF_PATNO ='"+patID+"' ");
	sqlStr.append("AND ENABLE ='1' ");

	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

public static boolean insertPatientReferral(UserBean userBean,String patNo,String chapID,String chapName,String comments){
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("INSERT INTO CHAP_AREA(ID, REF_PATNO,REF_CHAPID,REF_CHAPNAME,CREATE_USER,MODIFIED_USER,REF_NOTES) ");
	sqlStr.append("VALUES ('"+getNextID()+"','"+patNo+"','"+chapID+"','"+chapName+"', '"+userBean.getLoginID()+"', '"+userBean.getLoginID()+"', '"+comments+"') ");

	//System.out.println(sqlStr.toString());

	return UtilDBWeb.updateQueue(sqlStr.toString());
}

public static boolean editPatientReferral(UserBean userBean,String patNo,String chapID,String chapName,String refComment){
	StringBuffer sqlStr = new StringBuffer();

	sqlStr.append("UPDATE CHAP_AREA  ");
	sqlStr.append("SET REF_CHAPID ='"+chapID+"', ");
	sqlStr.append("REF_CHAPNAME = '"+chapName+"', ");
	sqlStr.append("REF_NOTES ='"+refComment+"', ");
	sqlStr.append("ENABLE = '1', ");
	sqlStr.append("MODIFIED_DATE=SYSDATE, ");
	sqlStr.append("MODIFIED_USER='" + userBean.getLoginID() + "' ");
	sqlStr.append("WHERE REF_PATNO = '" + patNo + "' ");

	//System.out.println(sqlStr.toString());

	return UtilDBWeb.updateQueue(sqlStr.toString());
}

private static String getNextID() {
	String id = null;

	ArrayList result = UtilDBWeb.getReportableList("SELECT MAX(ID) + 1 FROM CHAP_AREA");
	if (result.size() > 0) {
		ReportableListObject reportableListObject = (ReportableListObject) result.get(0);
		//System.out.println(reportableListObject.getValue(0));
		id = reportableListObject.getValue(0);

		// set 1 for initial
		if (id == null || id.length() == 0) return "1";
	}
	return id;
}

public static void sendEMail(UserBean userBean,String chapName,String patNo,String patName,
		String patWard,String patBed,String patAdmissionDate,String patHospital,String patDoctor,String patCName
		,String patACM,String patLang,String patAge,String patSex,String patReligion,String patAdmissionHistory,
		String patDiagnosis,String patRepeatVisit,String chapEMail,String comment) {
	// append url
	StringBuffer message = new StringBuffer();
	message.append("<table border = '0'><tr><td  bgcolor='#E0E0E0'  style='text-align:right;'><h2>Referring Patient:</td><td bgcolor='#F7ECEC'><h2>#" +patNo+ "</td></tr><tr><td  bgcolor='#E0E0E0' style='text-align:right;'><h2>Chaplain: </td><td bgcolor='#F7ECEC'><h2>" + userBean.getUserName() + " -> " + chapName + "</td></tr>");
	message.append("<tr><td   bgcolor='#E0E0E0' style='text-align:right;'><h3>Notes: </td><td bgcolor='#F7ECEC'><h3>" + comment + "</td></tr>");
	Calendar currentDate = Calendar.getInstance();
	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy kk:mm:ss");
	message.append("<tr><td  bgcolor='#E0E0E0' style='text-align:right;'><h3>Date: </td><td bgcolor='#F7ECEC'><h3>" + sdf.format(currentDate.getTime()) + "</td></tr></table>");

	message.append("<br />");
	message.append("Referred Patient Information: ");
	message.append("<table border='0'>");
	message.append("<tr style='font-size:14px;'><td  bgcolor='#E0E0E0' style='text-align:right;'>Hospital Name</td><td bgcolor='#F7ECEC'>" + patHospital + "</td><td bgcolor='#E0E0E0' style='text-align:right;'>Doctor</td><td bgcolor='#F7ECEC'>" + patDoctor + "</td></tr>");
	message.append("<tr style='font-size:14px;'><td  bgcolor='#E0E0E0' style='text-align:right;'>Patient Number</td><td bgcolor='#F7ECEC'>" + patNo + "</td><td bgcolor='#E0E0E0' style='text-align:right;'>Admission Date</td><td bgcolor='#F7ECEC'>" + patAdmissionDate + "</td></tr>");
	message.append("<tr style='font-size:14px;'><td bgcolor='#E0E0E0' style='text-align:right;'>Patient Name</td><td bgcolor='#F7ECEC'>" + patName + "</td><td bgcolor='#E0E0E0' style='text-align:right;'>Patient Chinese Name</td><td bgcolor='#F7ECEC'>" + patCName + "</td></tr>");
	message.append("<tr style='font-size:14px;'><td bgcolor='#E0E0E0' style='text-align:right;'>Ward</td><td bgcolor='#F7ECEC' >" + patWard + "</td><td bgcolor='#E0E0E0' style='text-align:right;'>Bed</td><td bgcolor='#F7ECEC'>" + patBed + "</td></tr>");
	message.append("<tr style='font-size:14px;'><td bgcolor='#E0E0E0' style='text-align:right;'>ACM</td><td bgcolor='#F7ECEC' >" + patACM + "</td><td bgcolor='#E0E0E0' style='text-align:right;'>Language</td><td bgcolor='#F7ECEC'>" + patLang + "</td></tr>");
	message.append("<tr style='font-size:14px;'><td bgcolor='#E0E0E0' style='text-align:right;'>Age</td><td bgcolor='#F7ECEC' >" + patAge + "</td><td bgcolor='#E0E0E0' style='text-align:right;'>Sex</td><td bgcolor='#F7ECEC'>" + patSex + "</td></tr>");
	message.append("<tr style='font-size:14px;'><td bgcolor='#E0E0E0' style='text-align:right;'>Religion</td><td bgcolor='#F7ECEC' >" + patReligion + "</td><td bgcolor='#E0E0E0' style='text-align:right;'>Admission History</td><td bgcolor='#F7ECEC'>" + patAdmissionHistory + "</td></tr>");
	message.append("<tr style='font-size:14px;'><td bgcolor='#E0E0E0' style='text-align:right;'>Repeat Visit</td><td colspan='3' bgcolor='#F7ECEC' >" + patRepeatVisit + "</td></tr>");

	message.append("<tr style='font-size:14px;'><td bgcolor='#E0E0E0' style='text-align:right;'>Diagnosis</td><td colspan='3' bgcolor='#F7ECEC' >" + patDiagnosis + "</td></tr>");

	message.append("</table>");

	StringBuffer title = new StringBuffer();
	title.append("Caretracking Referral ");

	UtilMail.sendMail(
			ConstantsServerSide.MAIL_ALERT,
			chapEMail,
			(ConstantsServerSide.isHKAH()?"cherry.wong@hkah.org.hk":"im.portal@twah.org.hk"),
			title.toString(),
			message.toString());
}
%>

<%
UserBean userBean = new UserBean(request);
if (userBean == null || !userBean.isLogin()) {
	%>
	<script>
		window.open("../index.jsp", "_self");
	</script>
	<%
	return;
}

String action = request.getParameter("action");

if(action.equals("referral")){
	String patNo = request.getParameter("patNo");
	String chapID = request.getParameter("chapID");
	String chapName = request.getParameter("chapName");
	String type = request.getParameter("type");

	String patName = request.getParameter("patName");
	String patWard = request.getParameter("patWard");
	String patBed = request.getParameter("patBed");
	String patAdmissionDate  = request.getParameter("patAdmissionDate");
	String patHospital  = request.getParameter("patHospital");
	String patDoctor  = request.getParameter("patDoctor");
	String patCName= TextUtil.parseStrUTF8(
			java.net.URLDecoder.decode(
					request.getParameter("patCName").replaceAll("%", "%25")));
	String patACM  = request.getParameter("patACM");
	String patLang  = request.getParameter("patLang");
	String patAge  = request.getParameter("patAge");
	String patSex  = request.getParameter("patSex");
	String patReligion  = request.getParameter("patReligion");
	String patAdmissionHistory = request.getParameter("patAdmissionHistory");
	String patDiagnosis= TextUtil.parseStrUTF8(
			java.net.URLDecoder.decode(
					request.getParameter("patDiagnosis").replaceAll("%", "%25")));
	String patRepeatVisit = request.getParameter("patRepeatVisit");
	String chapEMail = request.getParameter("chapEMail");

	String refComment = TextUtil.parseStrUTF8(
			java.net.URLDecoder.decode(
					request.getParameter("refComment").replaceAll("%", "%25")));
	System.out.println(refComment);

	ArrayList patientRecord = checkPatientExists(patNo);
	boolean referSuccess = false;
	if(patientRecord.size() == 0)	{
		referSuccess = insertPatientReferral(userBean,patNo,chapID,chapName,refComment);
%>
		 <%=referSuccess%>
<%
		if(referSuccess == true && type.equals("sendRef")){
			if(chapEMail!= null && chapEMail.length()>0){
			sendEMail(userBean,chapName,patNo,patName,patWard,patBed,patAdmissionDate,patHospital,patDoctor,patCName,patACM
					,patLang,patAge,patSex,patReligion,patAdmissionHistory,patDiagnosis,patRepeatVisit,chapEMail,refComment);
			}else{
%>
			errorwhilemail
<%
			}

		}
	}else{
		referSuccess = editPatientReferral(userBean,patNo,chapID,chapName,refComment);
%>
		<%=referSuccess%>
<%

		if(referSuccess == true && type.equals("sendRef")){
			if(chapEMail!= null && chapEMail.length()>0){
			sendEMail(userBean,chapName,patNo,patName,patWard,patBed,patAdmissionDate,patHospital,patDoctor,patCName,patACM
					,patLang,patAge,patSex,patReligion,patAdmissionHistory,patDiagnosis,patRepeatVisit,chapEMail,refComment);
			}else{
%>
			errorwhilemail
<%
			}
		}
	}
}else{
	String type = "";
	if(action.equals("wards")){
		type="WRD_CODE";
	}else if (action.equals("languages")){
		type="MOTH_CODE";
	}else if(action.equals("religions")){
		type="RELCODE";
	}else if(action.equals("other")){
		type = "OTHER";
	}


	if(action != null && action.length() > 0 && type != null && type.length() > 0){
			ArrayList<ChaplainValue> listOfChaplain = new ArrayList<ChaplainValue>();
			Enumeration parameterList = request.getParameterNames();
			while( parameterList.hasMoreElements() )
			{
			  String chapID = parameterList.nextElement().toString();
			  if(!chapID.equals("_") && !chapID.equals("action")){
				  String[] values = request.getParameterValues( chapID );
				  String areaControl="";
				  ChaplainValue tempChaplain;
					int i = 0;
					for(String v:values){
						if(v.length()>0){
							if(i==0){
								areaControl = v;
							}else{
								areaControl = areaControl + ","+v;
							}
							i++;
						}

					}
				  	tempChaplain = new ChaplainValue(chapID,areaControl);
				  	listOfChaplain.add(tempChaplain);
			  }
			}

			for(ChaplainValue c: listOfChaplain){
				ArrayList chaplainRecord = checkChapExists(c.chapID);
					if(chaplainRecord.size() == 0)	{
%>
				<%=insertChaplainArea(userBean,c.chapID,c.value,type)%>
<%
					}else{
%>
				<%=editChapArea(userBean,c.chapID,c.value,type)%>
<%
					}
			}

		}else{
%>
		false
<%
	}
}

%>
