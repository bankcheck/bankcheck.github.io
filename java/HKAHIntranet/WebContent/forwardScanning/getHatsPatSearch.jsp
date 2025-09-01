<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.PatientDB"%>
<%@ page import="java.io.PrintWriter" %>
<%@ page import="java.util.*"%>
<%@ page import="org.json.*" %>
<%
String message = null;
String errorMessage = null;

UserBean userBean = new UserBean(request);
if (userBean == null || !userBean.isAccessible("function.fs.file.upload")) {
	errorMessage = "No patient record access right.";
	
	JSONObject returnJSON = new JSONObject();
	returnJSON.put("message", message);
	returnJSON.put("errorMessage", errorMessage);

	response.setContentType("application/json");
	response.setCharacterEncoding("UTF-8");
	out.print(request.getParameter("callback")+"("+returnJSON.toString()+ ");");
	out.flush();
	return;
}
String patno = ParserUtil.getParameter(request, "patno");
String patidno = ParserUtil.getParameter(request, "patidno");
String patsex = ParserUtil.getParameter(request, "patsex");
String patbdateStr = ParserUtil.getParameter(request, "patbdateStr");
String pattel = ParserUtil.getParameter(request, "pattel");
String patfname = TextUtil.parseStrUTF8(request.getParameter("patfname"));
String patgname = TextUtil.parseStrUTF8(request.getParameter("patgname"));
String patmname = TextUtil.parseStrUTF8(request.getParameter("patmname"));
String patcname = TextUtil.parseStrUTF8(request.getParameter("patcname"));
String scr = ParserUtil.getParameter(request, "scr");
String ordby = ParserUtil.getParameter(request, "ordby");

JSONObject returnJSON = new JSONObject();
try {
	ArrayList record = PatientDB.listHatsPatientSearch(patno, patidno, pattel, patbdateStr, patsex, pattel, 
			patfname, patgname, patmname, patcname, scr, ordby, pattel, userBean.getLoginID());
	
	//System.out.println("[getHatsPatSearch] record size="+record.size());
	
	JSONArray patientArray = new JSONArray(); 
	ReportableListObject row = null;
	if(record.size() > 0) {
		for(int i = 0; i < record.size(); i++) {
			row = (ReportableListObject)record.get(i);
			JSONObject jsonObj = new JSONObject();
			jsonObj.put("alertcode", row.getValue(0));
			jsonObj.put("patno", row.getValue(1));
			jsonObj.put("patfname", row.getValue(2));
			jsonObj.put("patgname", row.getValue(3));
			jsonObj.put("patmname", row.getValue(4));
			jsonObj.put("patcname", row.getValue(5));
			jsonObj.put("ehrfname", row.getValue(6));
			jsonObj.put("ehrgname", row.getValue(7));
			jsonObj.put("patsex", row.getValue(8));
			jsonObj.put("patbdate", row.getValue(9));
			jsonObj.put("age", row.getValue(10));
			jsonObj.put("patpager", row.getValue(11));
			jsonObj.put("pathtel", row.getValue(12));
			jsonObj.put("patidno", row.getValue(13));
			jsonObj.put("patidcoucode", row.getValue(14));
			jsonObj.put("patvcnt", row.getValue(15));
			jsonObj.put("lastupd", row.getValue(16));
			jsonObj.put("titdesc", row.getValue(17));
			jsonObj.put("patmsts", row.getValue(18));
			jsonObj.put("racdesc", row.getValue(19));
			jsonObj.put("mothcode", row.getValue(20));
			jsonObj.put("patsex2", row.getValue(21));
			jsonObj.put("edulevel", row.getValue(22));
			jsonObj.put("religious", row.getValue(23));
			jsonObj.put("death", row.getValue(24));
			jsonObj.put("occupation", row.getValue(25));
			jsonObj.put("patmother", row.getValue(26));
			jsonObj.put("patnb", row.getValue(27));
			jsonObj.put("patsts", row.getValue(28));
			jsonObj.put("patitp", row.getValue(29));
			jsonObj.put("patstaff", row.getValue(30));
			jsonObj.put("patsms", row.getValue(31));
			jsonObj.put("patchkid", row.getValue(32));
			jsonObj.put("patemail", row.getValue(33));
			jsonObj.put("patotel", row.getValue(34));
			jsonObj.put("patfaxno", row.getValue(35));
			jsonObj.put("patadd1", row.getValue(36));
			jsonObj.put("patadd2", row.getValue(37));
			jsonObj.put("patadd3", row.getValue(38));
			jsonObj.put("loccode", row.getValue(39));
			jsonObj.put("dstname", row.getValue(40));
			jsonObj.put("coucode", row.getValue(41));
			jsonObj.put("patrmk", row.getValue(42));
			jsonObj.put("lastupd2", row.getValue(43));
			jsonObj.put("usrname", row.getValue(44));
			jsonObj.put("patkname", row.getValue(45));
			jsonObj.put("patkhtel", row.getValue(46));
			jsonObj.put("patkptel", row.getValue(47));
			jsonObj.put("patkrela", row.getValue(48));
			jsonObj.put("patkotel", row.getValue(49));
			jsonObj.put("patkmtel", row.getValue(50));
			jsonObj.put("patkemail", row.getValue(51));
			jsonObj.put("patkadd", row.getValue(52));
			jsonObj.put("patlfname", row.getValue(53));
			jsonObj.put("patlgname", row.getValue(54));
			jsonObj.put("pataddrmk", row.getValue(55));
			jsonObj.put("addrmkmodusrname", row.getValue(56));
			jsonObj.put("addrmkmoddt", row.getValue(57));
			jsonObj.put("regid_l", row.getValue(58));
			jsonObj.put("regid_c", row.getValue(59));
			jsonObj.put("tpatno", row.getValue(60));
			jsonObj.put("to_patno", row.getValue(61));
			jsonObj.put("patpagerupusrname", row.getValue(62));
			jsonObj.put("patpagerupdt", row.getValue(63));
			jsonObj.put("pathtelupusrname", row.getValue(64));
			jsonObj.put("pathtelupdt", row.getValue(65));
			jsonObj.put("patotelupusrname", row.getValue(66));
			jsonObj.put("patotelupdt", row.getValue(67));
			jsonObj.put("patfaxnoupusrname", row.getValue(68));
			jsonObj.put("patfaxnoupdt", row.getValue(69));
			jsonObj.put("pataddupusrname", row.getValue(70));
			jsonObj.put("pataddupdt", row.getValue(71));
			jsonObj.put("rmkupusrname", row.getValue(72));
			jsonObj.put("rmkupdt", row.getValue(73));
			jsonObj.put("patchkidupusrname", row.getValue(74));
			jsonObj.put("patchkidupdt", row.getValue(75));
			jsonObj.put("pdoctype", row.getValue(76));
			jsonObj.put("patmktsrc", row.getValue(77));
			jsonObj.put("ppatmktrmk", row.getValue(78));
			jsonObj.put("pdentalno", row.getValue(79));
			jsonObj.put("ppatmiscrmk", row.getValue(80));
			patientArray.put(jsonObj);
		}
	}
	
	returnJSON.put("record", patientArray);
} catch (Exception e) {
	e.printStackTrace();
	errorMessage = e.getMessage();
}

returnJSON.put("message", message);
returnJSON.put("errorMessage", errorMessage);

//System.out.println("[getHatsPatSearch] returnJSON.toString()="+returnJSON.toString());

response.setContentType("application/json");
response.setCharacterEncoding("UTF-8");
out.print(request.getParameter("callback")+"("+returnJSON.toString()+ ");");
out.flush();
%>