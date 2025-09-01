﻿﻿﻿﻿﻿<%@ page import="java.net.*"
%><%@ page import="java.io.*"
%><%@ page import="java.util.*"
%><%@ page import="javax.sql.*"
%><%@ page import="com.hkah.constant.*"
%><%@ page import="com.hkah.servlet.*"
%><%@ page import="com.hkah.util.*"
%><%@ page import="com.hkah.util.db.*"
%><%@ page import="com.hkah.web.common.*"
%><%@ page language="java" contentType="text/html; charset=utf-8"
%><%!
	private String parseUTF(String str) {
		if (str != null) {
			try {
				return URLEncoder.encode(str, "UTF-8").replace(ConstantsVariable.PLUS_VALUE, ConstantsVariable.SPACE_VALUE);
			} catch (Exception e) {
			}
		}
		return null;
	}

	private HashMap<String, StringBuffer[]> getDoctorQualificationMap() {
		HashMap<String, StringBuffer[]> doctorMap = new HashMap<String, StringBuffer[]>();

		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableListCIS("SELECT D.DOCCODE, D.QLFID, Q.QLFNAME, Q.QLFCNAME FROM DOCQLFLINK@HAT D, QUALIFICATION@HAT Q WHERE D.QLFID = Q.QLFID AND D.QLFID NOT IN ('340', '740')");
		ReportableListObject row = null;
		StringBuffer[] sb = null;
		String doccode = null;
		int qlfid = 0;

		if (record.size() > 0) {
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				doccode = row.getValue(0);
				qlfid = 0;
				try { qlfid = Integer.parseInt(row.getValue(1)); } catch (Exception e) {}

				sb = new StringBuffer[2];
				if (doctorMap.containsKey(doccode)) {
					sb = doctorMap.get(doccode);
					sb[0].append(",");
					sb[0].append(row.getValue(2));
					sb[1].append(",");
					sb[1].append(row.getValue(3));
				} else {
					sb[0] = new StringBuffer();
					sb[0].append(row.getValue(2));
					sb[1] = new StringBuffer();
					sb[1].append(row.getValue(3));
				}
				doctorMap.put(row.getValue(0), sb);
			}
		}
		return doctorMap;
	}
%><?xml version="1.0" encoding="utf-8"?>
<DoctorList>
<%
//String[] dateTag = new String[] { "", "SUN", "MON", "TUE", "WED", "THUR", "FRI", "SAT" };

// create connection
ArrayList<ReportableListObject> record = null;
ReportableListObject row = null;
StringBuffer sqlStr = new StringBuffer();

HashMap<String, String> spcENameMap = new HashMap<String, String>();
sqlStr.append("SELECT SPCCODE, SPCNAME FROM SPEC@HAT");
record = UtilDBWeb.getReportableListCIS(sqlStr.toString());
if (record.size() > 0) {
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		spcENameMap.put(row.getValue(1), row.getValue(0));
	}
}

sqlStr.setLength(0);

if (ConstantsServerSide.isHKAH()) {
	sqlStr.append("SELECT DISTINCT ");
	sqlStr.append("        DR.DOCCODE, CIS.F_GET_ENG_SPCNAME(DR.DOCCODE), CIS.F_GET_CHN_SPCNAME(DR.DOCCODE), ");
	sqlStr.append("        DR.DOCFNAME, DR.DOCGNAME, ");
	sqlStr.append("        (CASE WHEN DR.DOCCNAME > ' ' THEN DR.DOCCNAME END), ");
	sqlStr.append("        CT.ECERT1, CT.ECERT2, CT.ECERT3, CT.ECERT4, CT.ECERT5, ");
	sqlStr.append("        CT.ECERT6, CT.ECERT7, CT.ECERT8, CT.ECERT9, CT.ECERT10, ");
	sqlStr.append("        CT.CCERT1, CT.CCERT2, CT.CCERT3, CT.CCERT4, CT.CCERT5, ");
	sqlStr.append("        CT.CCERT6, CT.CCERT7, CT.CCERT8, CT.CCERT9, CT.CCERT10, ");
	sqlStr.append("        DR.DOCTYPE, DR.SPCCODE, DR.DOCSDATE, ");
	sqlStr.append("        DR.TITTLE, ");
	sqlStr.append("        TO_CHAR(SH.SCHSDATE, 'YYYY-MM-DD') SDATE, ");
	sqlStr.append("        TO_CHAR(SH.SCHSDATE, 'HH24:MI') STIME, ");
	sqlStr.append("        TO_CHAR(SH.SCHEDATE, 'HH24:MI') ETIME ");
	sqlStr.append(" FROM   DOCTOR@HAT DR ");
	sqlStr.append("        LEFT OUTER JOIN SCHEDULE@HAT SH ON DR.DOCCODE = SH.DOCCODE ");
	sqlStr.append("        		AND    SH.SCHSTS IN ('N') ");
	sqlStr.append("        		AND    SH.SCHSDATE > SYSDATE ");
	sqlStr.append("        		AND    SH.SCHEDATE <= ADD_MONTHS(SYSDATE, 6) ");
	sqlStr.append("        LEFT OUTER JOIN DOCCERT@HAT CT ON DR.DOCCODE = CT.DOCCODE ");
	sqlStr.append(" WHERE  DR.DOCSTS = -1 ");
	sqlStr.append(" AND    DR.SPCCODE IN (SELECT SPCCODE FROM SPEC@HAT WHERE SPCCNAME IS NOT NULL) ");
	sqlStr.append(" AND    (DR.DOCCODE not like '9%' or (DR.DOCCODE like '9%' and LENGTH(DR.DOCCODE) <> 4)) ");
	sqlStr.append(" AND    (DR.ISPOSTSCHEDULE = -1  OR DR.DOCCODE IN (SELECT HPKEY FROM HPSTATUS@HAT WHERE HPTYPE = 'ONLINE_DR' AND HPSTATUS = 'INCLUDE')) ");
	sqlStr.append(" AND    DR.DOCCODE NOT IN (SELECT HPKEY FROM HPSTATUS@HAT WHERE HPTYPE = 'ONLINE_DR' AND HPSTATUS = 'EXCLUDE') ");
	sqlStr.append("	ORDER BY 2, DOCCODE, SDATE, STIME ");
} else if (ConstantsServerSide.isTWAH()) {
	sqlStr.append("SELECT DISTINCT ");
	sqlStr.append("        DR.DOCCODE, CIS.F_GET_ENG_SPCNAME(DR.DOCCODE), CIS.F_GET_CHN_SPCNAME(DR.DOCCODE), ");
	sqlStr.append("        DR.DOCFNAME, DR.DOCGNAME, ");
	sqlStr.append("        (CASE WHEN DR.DOCCNAME > ' ' THEN DR.DOCCNAME END), ");
	sqlStr.append("        CT.ECERT1, CT.ECERT2, CT.ECERT3, CT.ECERT4, CT.ECERT5, ");
	sqlStr.append("        CT.ECERT6, CT.ECERT7, CT.ECERT8, CT.ECERT9, CT.ECERT10, ");
	sqlStr.append("        CT.CCERT1, CT.CCERT2, CT.CCERT3, CT.CCERT4, CT.CCERT5, ");
	sqlStr.append("        CT.CCERT6, CT.CCERT7, CT.CCERT8, CT.CCERT9, CT.CCERT10, ");
	sqlStr.append("        DR.DOCTYPE, DR.SPCCODE, DR.DOCSDATE, ");
	sqlStr.append("        DR.TITTLE, ");
	sqlStr.append("        TO_CHAR(SH.SCHSDATE, 'YYYY-MM-DD') SDATE, ");
	sqlStr.append("        TO_CHAR(SH.SCHSDATE, 'HH24:MI') STIME, ");
	sqlStr.append("        TO_CHAR(SH.SCHEDATE, 'HH24:MI') ETIME ");
	sqlStr.append(" FROM   DOCTOR@HAT DR ");
	sqlStr.append("        LEFT OUTER JOIN SCHEDULE@HAT SH ON DR.DOCCODE = SH.DOCCODE ");
	sqlStr.append("        		AND    SH.SCHSTS IN ('N') ");
	sqlStr.append("        		AND    SH.SCHSDATE > SYSDATE ");
	sqlStr.append("        		AND    SH.SCHEDATE <= ADD_MONTHS(SYSDATE, 6) ");
	sqlStr.append("        LEFT OUTER JOIN DOCCERT@HAT CT ON DR.DOCCODE = CT.DOCCODE ");
	sqlStr.append(" WHERE  DR.DOCSTS = -1 ");
	sqlStr.append(" AND    DR.SPCCODE IN (SELECT SPCCODE FROM SPEC@HAT WHERE SPCCNAME IS NOT NULL) ");
	sqlStr.append(" AND    DR.DOCTYPE != 'M' ");	// M := Courtesy
	sqlStr.append(" AND    (DR.OPPEDATE IS NOT NULL OR DR.DOCCODE IN (SELECT HPKEY FROM HPSTATUS@HAT WHERE HPTYPE = 'ONLINE_DR' AND HPSTATUS = 'INCLUDE')) ");
	sqlStr.append(" AND    DR.DOCCODE NOT IN (SELECT HPKEY FROM HPSTATUS@HAT WHERE HPTYPE = 'ONLINE_DR' AND HPSTATUS = 'EXCLUDE') ");
	sqlStr.append("	ORDER BY 2, DOCCODE, SDATE, STIME ");
}

System.out.println("[doctor_list_dev] sql="+sqlStr.toString());

record = UtilDBWeb.getReportableListCIS(sqlStr.toString());

boolean isPrintDeptTag = false;
boolean isPrintDocTag = false;

//String filePathDest = null;
String deptCode_delimiter = " / ";
String deptCode_prev = null;
String deptCode_curr = null;
String docCode_prev = null;
String docCode_curr = null;
String deptCodeDis_en = null;
String deptCodeDis_tc = null;
String deptCodeSubDis_en = null;
String deptCodeSubDis_tc = null;

int temday_curr = -1;
int deptCode_delimiterIndex_en = -1;
int deptCode_delimiterIndex_tc = -1;

HashMap<String, StringBuffer[]> doctorQualificationMap = null;

System.out.println("[doctor_list_dev] record size="+record.size());

if (record.size() > 0) {
	temday_curr = -1;
	doctorQualificationMap = getDoctorQualificationMap();
	StringBuffer doctorTypeEn = new StringBuffer();
	StringBuffer doctorTypeTc = new StringBuffer();
	String title_en = null;
	String title_tc = null;
	StringBuffer[] val = null;
	String dateStr = null;
	boolean sameDate = false;
	boolean isDocLastRow = false;

	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		docCode_curr = row.getValue(0);
		deptCode_curr = row.getValue(1);
		if ("ENT".equalsIgnoreCase(deptCode_curr)) {
			deptCode_curr = "OTORHINOLARYNGOLOGY";
		}
		try {
			temday_curr = Integer.parseInt(row.getValue(26));
		} catch (Exception e) {}

		// if not equal previous dept code, print doctor department name tag
		isPrintDeptTag = false;
		if (deptCode_prev == null || !deptCode_curr.equals(deptCode_prev)) {
			isPrintDeptTag = true;
		}

		// if not equal previous doctor code, print doctor code name tag
		isPrintDocTag = false;
		if (docCode_curr == null || !docCode_curr.equals(docCode_prev)) {
			isPrintDocTag = true;
			sameDate = false;
//			filePathDest = ConstantsServerSide.DOCTOR_PHOTO_DEST + File.separator + docCode_curr + ".jpg";

			// check doctor image
//			if (!ConstantsServerSide.DEBUG) {
//				FileUtil.copyFile(
//						ConstantsServerSide.DOCTOR_PHOTO_SRC + File.separator + docCode_curr + ".jpg",
//						filePathDest,
//						true
//				);
//			}
		}
		title_en = row.getValue(29);
		title_tc = "";
		if (title_en != null) {
			if (title_en.toUpperCase().startsWith("DR")) {
				title_tc = "醫生";
			} else if (title_en.toUpperCase().startsWith("MRS") || title_en.toUpperCase().startsWith("MS")) {
				title_tc = "女士";
			} else if (title_en.toUpperCase().startsWith("MR")) {
				title_tc = "先生";
			}
		}

		// close previous flag
		if (isPrintDocTag && i > 0) {
%>
<% if (dateStr != null) { %>
		</d<%=dateStr %>>
<% } %>		
      </timetable>
    </Doctor>
<%
		}

		if (isPrintDeptTag) {
			if (i > 0) {
%>
  </DoctorDepartment>
<%
			}
			deptCodeDis_en = deptCode_curr;
			deptCodeDis_tc = row.getValue(2);
			deptCodeSubDis_en = null;
			deptCodeSubDis_tc = null;
			deptCode_delimiterIndex_en = deptCodeDis_en.indexOf(deptCode_delimiter);
			deptCode_delimiterIndex_tc = deptCodeDis_tc.indexOf(deptCode_delimiter);
			if (deptCode_delimiterIndex_en >= 0 && deptCode_delimiterIndex_tc >= 0) {
				// english description
				deptCodeSubDis_en = deptCodeDis_en.substring(deptCode_delimiterIndex_en + 3);
				deptCodeDis_en = deptCodeDis_en.substring(0, deptCode_delimiterIndex_en);
				// chinese description
				deptCodeSubDis_tc = deptCodeDis_tc.substring(deptCode_delimiterIndex_tc + 3);
				deptCodeDis_tc = deptCodeDis_tc.substring(0, deptCode_delimiterIndex_tc);
			}
%>
  <DoctorDepartment>
  	<DoctorSpecCode><%=row.getValue(27) %></DoctorSpecCode>
    <DoctorDepartmentName_en><%=StringUtil.replaceSpecialChar4HTML(deptCodeDis_en) %></DoctorDepartmentName_en>
    <DoctorDepartmentName_tc><%=deptCodeDis_tc %></DoctorDepartmentName_tc>
<%
			if (deptCodeSubDis_en != null && deptCodeSubDis_tc != null) {
%>
    <DoctorSubSpecCode><%=spcENameMap.get(deptCodeSubDis_en) %></DoctorSubSpecCode>
    <DoctorDepartmentSubName_en><%=StringUtil.replaceSpecialChar4HTML(deptCodeSubDis_en) %></DoctorDepartmentSubName_en>
    <DoctorDepartmentSubName_tc><%=deptCodeSubDis_tc %></DoctorDepartmentSubName_tc>
<%
			}
		}

		if (isPrintDocTag) {
%>
    <Doctor>
      <Doctor_code><%=row.getValue(0) %></Doctor_code>
      <Name_en><%=title_en %><%=title_en == null || title_en.isEmpty() ? "" : " " %><%=StringUtil.replaceSpecialChar4HTML(row.getValue(3)) %> <%=StringUtil.replaceSpecialChar4HTML(row.getValue(4)) %></Name_en>
<% if ("2074".equals(row.getValue(0)) || "U207".equals(row.getValue(0))) { %>
		<Name_tc>王明晧<%=title_tc %></Name_tc>
<% } else { %>
      <Name_tc><%=row.getValue(5) %><%=title_tc %></Name_tc>
<% } %>
      <cv_en><![CDATA[
	      <%=row.getValue(6)  %>
	      <%=row.getValue(7)  %>
	      <%=row.getValue(8)  %>
	      <%=row.getValue(9)  %>
	      <%=row.getValue(10) %>
	      <%=row.getValue(11) %>
	      <%=row.getValue(12) %>
	      <%=row.getValue(13) %>
	      <%=row.getValue(14) %>
	      <%=row.getValue(15) %>
      ]]></cv_en>
      <cv_tc><![CDATA[
	      <%=row.getValue(16) %>
	      <%=row.getValue(17) %>
	      <%=row.getValue(18) %>
	      <%=row.getValue(19) %>
	      <%=row.getValue(20) %>
	      <%=row.getValue(21) %>
	      <%=row.getValue(22) %>
	      <%=row.getValue(23) %>
	      <%=row.getValue(24) %>
	      <%=row.getValue(25) %>
      ]]></cv_tc>
   	  <Doctor_startDate><%=row.getValue(28) %></Doctor_startDate>
<%
		doctorTypeEn.setLength(0);
		doctorTypeTc.setLength(0);
		if ("I".equals(row.getValue(26))) {
			doctorTypeEn.append("ADVENTIST HEALTH PHYSICIAN");
			doctorTypeTc.append("本院醫生");
		}
		if (doctorQualificationMap.containsKey(docCode_curr)) {
			val = doctorQualificationMap.get(docCode_curr);
			if (doctorTypeEn.length() > 0) {
				doctorTypeEn.append(",");
			}
			if (doctorTypeTc.length() > 0) {
				doctorTypeTc.append(",");
			}
			doctorTypeEn.append(val[0].toString());
			doctorTypeTc.append(val[1].toString());
		}
		if(doctorTypeEn.length() > 0) {
%>
      <DoctorType_en><![CDATA[<%=doctorTypeEn %>]]></DoctorType_en>
<%    	}
		if(doctorTypeTc.length() > 0) {
			%>
      <DoctorType_tc><![CDATA[<%=doctorTypeTc %>]]></DoctorType_tc>
<%    	} %>
      <timetable>
<%
		}

		sameDate = (dateStr != null && dateStr.equals(row.getValue(30)));
		if(row.getValue(30) != null && !row.getValue(30).isEmpty()){
%>

<% if (!sameDate) { %>  
  <% if (!isPrintDocTag) { %>   		
</d<%=dateStr %>>
  <% } %>  
<d<%=row.getValue(30) %>>
<% } %>  
       		<TIME><%=row.getValue(31) %> - <%=row.getValue(32) %></TIME>    	
<%
dateStr = row.getValue(30);

		}
		// store current doc code
		docCode_prev = docCode_curr;

		// store current dept code
		deptCode_prev = deptCode_curr;
	}
%>

<% if (dateStr != null) { %>       		
</d<%=dateStr %>>
<% } %>   

      </timetable>
    </Doctor>
  </DoctorDepartment>
<%
}
%></DoctorList>