<%@ page import="java.util.*"
%><%@ page import="com.hkah.util.*"
%><%@ page import="com.hkah.web.common.*"
%><%@ page import="com.hkah.web.db.*"%><%
String patno = request.getParameter("patno");

String patfname = null;
String patgname = null;
String titleDesc = null;
String titleDescOther = null;
String patcname = null;

String patidno = request.getParameter("patidno");
String patidno1 = null;
String patidno2 = null;
String patpassport = request.getParameter("patpassport");
String patsex = null;
String racedesc = null;
String racedescOther = null;
String religion = null;
String religionOther = null;
String patbdate = request.getParameter("patbdate");
String patmsts = null;
String mothcode = null;
String mothcodeOther = null;
String edulevel = null;
String pathtel = null;
String patotel = null;
String patmtel = null;
String patftel = null;
String occupation = null;
String patemail = null;
String patadd1 = null;
String patadd2 = null;
String patadd3 = null;
String patadd4 = null;
String loccode = null;
String coucode = null;

String patkfname1 = null;
String patkgname1 = null;
String patkcname1 = null;
String patksex1 = null;
String patkrela1 = null;
String patkhtel1 = null;
String patkotel1 = null;
String patkmtel1 = null;
String patkptel1 = null;
String patkemail1 = null;
String patkadd11 = null;
String patkadd21 = null;
String patkadd31 = null;
String patkadd41 = null;

ArrayList record = null;
if ((patno != null && patno.length() > 0) || (patbdate != null && patbdate.length() > 0)) {
	if (patno != null && patno.length() > 0) {
		record = AdmissionDB.getHATSPatient(patno, null, null);
	} else if (patidno != null && patidno.length() > 0) {
		record = AdmissionDB.getHATSPatient(null, patidno, patbdate);
	} else if (patpassport != null && patpassport.length() > 0) {
		record = AdmissionDB.getHATSPatient(null, patpassport, patbdate);
	}
	if (record != null && record.size() > 0) {
		ReportableListObject row = (ReportableListObject) record.get(0);
		patno = row.getValue(0);
		patfname = row.getValue(1);
		patgname = row.getValue(2);
		titleDesc = row.getValue(3);
		patcname = row.getValue(4);
		patidno = row.getValue(5);
		if (patidno.length() >= 8 && patidno.length() <= 9) {
			patidno1 = patidno.substring(0, 7);
			patidno2 = patidno.substring(7);
		} else {
			patpassport = patidno;
		}
		patsex = row.getValue(6);
		racedesc = row.getValue(7);
		religion = row.getValue(8);
		patbdate = row.getValue(9);

		patmsts = row.getValue(10);
		mothcode = row.getValue(11);
		edulevel = row.getValue(12);
		pathtel = row.getValue(13);
		patotel = row.getValue(14);
		patmtel = row.getValue(15);
		patftel = row.getValue(16);
		occupation = row.getValue(17);
		patemail = row.getValue(18);
		patadd1 = row.getValue(19);
		patadd2 = row.getValue(20);
		patadd3 = row.getValue(21);
		String patkname = row.getValue(22);
		int index = patkname.indexOf(" ");
		if (index > 0) {
			patkfname1 = patkname.substring(0, index);
			patkgname1 = patkname.substring(index + 1);
		}
		patkrela1 = row.getValue(23);
		patkhtel1 = row.getValue(24);
		patkptel1 = row.getValue(25);
		patkotel1 = row.getValue(26);
		patkmtel1 = row.getValue(27);
		patkemail1 = row.getValue(28);
		String patkadd = row.getValue(29);
		String[] patkaddArray = TextUtil.split(patkadd, ",");
		if (patkaddArray.length == 4) {
			patkadd11 = patkaddArray[0];
			patkadd21 = patkaddArray[1];
			patkadd31 = patkaddArray[2];
		} else {
			patkaddArray = TextUtil.split(patkadd, 40);
			patkadd11 = patkaddArray.length > 0 ? patkaddArray[0] : null;
			patkadd21 = patkaddArray.length > 1 ? patkaddArray[1] : null;
			patkadd31 = patkaddArray.length > 2 ? patkaddArray[2] : null;
		}
		loccode = row.getValue(30);
		coucode = row.getValue(31);
	}
}
%><%@ page language="java" contentType="text/html; charset=utf-8" %><%=record != null && record.size() > 0 ? record.size() : 0 %>
<input type="hidden" name="hats_patno" value="<%=patno==null?"":patno %>" />
<input type="hidden" name="hats_patfname" value="<%=patfname==null?"":patfname %>" />
<input type="hidden" name="hats_patgname" value="<%=patgname==null?"":patgname %>" />
<input type="hidden" name="hats_titleDesc" value="<%=titleDesc==null?"":titleDesc %>" />
<input type="hidden" name="hats_patcname" value="<%=patcname==null?"":patcname %>" />
<input type="hidden" name="hats_patidno" value="<%=patidno==null?"":patidno %>" />
<input type="hidden" name="hats_patidno1" value="<%=patidno1==null?"":patidno1 %>" />
<input type="hidden" name="hats_patidno2" value="<%=patidno2==null?"":patidno2 %>" />
<input type="hidden" name="hats_patpassport" value="<%=patpassport==null?"":patpassport %>" />
<input type="hidden" name="hats_patsex" value="<%=patsex==null?"":patsex %>" />
<input type="hidden" name="hats_racedesc" value="<%=racedesc==null?"":racedesc %>" />
<input type="hidden" name="hats_religion" value="<%=religion==null?"":religion %>" />
<input type="hidden" name="hats_patbdate" value="<%=patbdate==null?"":patbdate %>" />
<input type="hidden" name="hats_patmsts" value="<%=patmsts==null?"":patmsts %>" />
<input type="hidden" name="hats_mothcode" value="<%=mothcode==null?"":mothcode %>" />
<input type="hidden" name="hats_edulevel" value="<%=edulevel==null?"":edulevel %>" />
<input type="hidden" name="hats_pathtel" value="<%=pathtel==null?"":pathtel %>" />
<input type="hidden" name="hats_patotel" value="<%=patotel==null?"":patotel %>" />
<input type="hidden" name="hats_patmtel" value="<%=patmtel==null?"":patmtel %>" />
<input type="hidden" name="hats_patftel" value="<%=patftel==null?"":patftel %>" />
<input type="hidden" name="hats_occupation" value="<%=occupation==null?"":occupation %>" />
<input type="hidden" name="hats_patemail" value="<%=patemail==null?"":patemail %>" />
<input type="hidden" name="hats_patadd1" value="<%=patadd1==null?"":patadd1 %>" />
<input type="hidden" name="hats_patadd2" value="<%=patadd2==null?"":patadd2 %>" />
<input type="hidden" name="hats_patadd3" value="<%=patadd3==null?"":patadd3 %>" />
<input type="hidden" name="hats_patkfname1" value="<%=patkfname1==null?"":patkfname1 %>" />
<input type="hidden" name="hats_patkgname1" value="<%=patkgname1==null?"":patkgname1 %>" />
<input type="hidden" name="hats_patkrela1" value="<%=patkrela1==null?"":patkrela1 %>" />
<input type="hidden" name="hats_patkhtel1" value="<%=patkhtel1==null?"":patkhtel1 %>" />
<input type="hidden" name="hats_patkotel1" value="<%=patkotel1==null?"":patkotel1 %>" />
<input type="hidden" name="hats_patkmtel1" value="<%=patkmtel1==null?"":patkmtel1 %>" />
<input type="hidden" name="hats_patkptel1" value="<%=patkptel1==null?"":patkptel1 %>" />
<input type="hidden" name="hats_patkemail1" value="<%=patkemail1==null?"":patkemail1 %>" />
<input type="hidden" name="hats_patkadd11" value="<%=patkadd11==null?"":patkadd11 %>" />
<input type="hidden" name="hats_patkadd21" value="<%=patkadd21==null?"":patkadd21 %>" />
<input type="hidden" name="hats_patkadd31" value="<%=patkadd31==null?"":patkadd31 %>" />
<input type="hidden" name="hats_loccode" value="<%=loccode==null?"":loccode %>" />
<input type="hidden" name="hats_coucode" value="<%=coucode==null?"":coucode %>" />