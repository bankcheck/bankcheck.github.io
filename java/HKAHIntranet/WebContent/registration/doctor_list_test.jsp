<%@ page import="java.net.*"
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
	private HashMap<String, String> getSpecCode() {
		HashMap<String, String> spcENameMap = new HashMap<String, String>();
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableListCIS("SELECT SPCCODE, SPCNAME FROM spec@hat");
		if (record.size() > 0) {
			ReportableListObject row = null;
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				spcENameMap.put(row.getValue(1), row.getValue(0));
			}
		}
		return spcENameMap;
	}

	private HashMap<String, Vector> getUnavailableSchedule() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT DOCCODE, TO_CHAR(SCHSDATE, 'dd/mm/yyyy HH24:MI:SS'), TO_CHAR(SCHEDATE, 'dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("FROM   SCHEDULE@IWEB ");
		sqlStr.append("WHERE  SCHSTS='N' ");
		sqlStr.append("AND    SCHSDATE >= SYSDATE ");
		sqlStr.append("ORDER BY SCHSDATE ");

		HashMap<String, Vector> schedule = new HashMap<String, Vector>();
		ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString());
		if (record.size() > 0) {
			ReportableListObject row = null;
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				updateMap(schedule, row.getValue(0), row.getValue(1), row.getValue(2));
			}
		}
		return schedule;
	}

	private void updateMap(HashMap<String, Vector> data, String docCode, String timeFrom, String timeTo) {
		// get old map
		Vector<String> oldMap = null;
		if (data.containsKey(docCode)) {
			oldMap = data.get(docCode);
		} else {
			oldMap = new Vector<String>();
		}

		oldMap.add(timeFrom + " - " + timeTo);

		// put it back to hash
		data.put(docCode, oldMap);
	}

	private ArrayList<ReportableListObject> getDoctorList() {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("SELECT * FROM(");
		sqlStr.append(" SELECT DISTINCT ");
		sqlStr.append("        DR.DOCCODE, CIS.F_GET_ENG_SPCNAME(DR.DOCCODE), CIS.F_GET_CHN_SPCNAME(DR.DOCCODE), ");
		sqlStr.append("        DR.DOCFNAME, DR.DOCGNAME, ");
		sqlStr.append("        (CASE WHEN DR.DOCCNAME > ' ' THEN DR.DOCCNAME END), ");
		sqlStr.append("        CT.ECERT1, CT.ECERT2, CT.ECERT3, CT.ECERT4, CT.ECERT5, ");
		sqlStr.append("        CT.ECERT6, CT.ECERT7, CT.ECERT8, CT.ECERT9, CT.ECERT10, ");
		sqlStr.append("        CT.CCERT1, CT.CCERT2, CT.CCERT3, CT.CCERT4, CT.CCERT5, ");
		sqlStr.append("        CT.CCERT6, CT.CCERT7, CT.CCERT8, CT.CCERT9, CT.CCERT10, ");
		sqlStr.append("        SH.TEMDAY, TO_CHAR(SH.TEMSTIME,'HH24:MI'), TO_CHAR(SH.TEMETIME,'HH24:MI'), DR.DOCTYPE, DR.SPCCODE, QL.QLFID, TO_CHAR(DR.DOCSDATE, 'dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append(" FROM   DOCTOR@HAT DR, TEMPLATE@HAT SH, DOCCERT@HAT CT, DOCQLFLINK@HAT QL ");
		sqlStr.append(" WHERE  DR.DOCCODE = SH.DOCCODE ");
		sqlStr.append("AND    DR.DOCCODE = QL.DOCCODE (+) ");
		sqlStr.append(" AND    DR.DOCCODE = CT.DOCCODE (+) ");
		sqlStr.append(" AND    DR.DOCSTS = -1 ");
		sqlStr.append(" AND    DR.SPCCODE IN (SELECT SPCCODE FROM SPEC@HAT WHERE SPCCNAME IS NOT NULL) ");
		sqlStr.append("UNION");
		sqlStr.append(" SELECT DISTINCT ");
		sqlStr.append("        DR.DOCCODE, CIS.F_GET_ENG_SPCNAME(DR.DOCCODE), CIS.F_GET_CHN_SPCNAME(DR.DOCCODE), ");
		sqlStr.append("        DR.DOCFNAME, DR.DOCGNAME, ");
		sqlStr.append("        (CASE WHEN DR.DOCCNAME > ' ' THEN DR.DOCCNAME END), ");
		sqlStr.append("        CT.ECERT1, CT.ECERT2, CT.ECERT3, CT.ECERT4, CT.ECERT5, ");
		sqlStr.append("        CT.ECERT6, CT.ECERT7, CT.ECERT8, CT.ECERT9, CT.ECERT10, ");
		sqlStr.append("        CT.CCERT1, CT.CCERT2, CT.CCERT3, CT.CCERT4, CT.CCERT5, ");
		sqlStr.append("        CT.CCERT6, CT.CCERT7, CT.CCERT8, CT.CCERT9, CT.CCERT10, ");
		sqlStr.append("		   NULL, NULL, NULL, DR.DOCTYPE, DR.SPCCODE, null, null ");
		sqlStr.append(" FROM   DOCTOR@HAT DR, DOCCERT@HAT CT ");
		sqlStr.append(" WHERE  DR.DOCCODE = CT.DOCCODE (+) ");
		sqlStr.append(" AND    DR.DOCSTS = -1 ");
		sqlStr.append(" AND    DR.OPPEDATE IS NOT NULL ");
		sqlStr.append(" AND    DR.SPCCODE IN (SELECT SPCCODE FROM SPEC@HAT WHERE SPCCNAME IS NOT NULL) ");
		sqlStr.append(" AND    NOT EXISTS (SELECT 1 FROM TEMPLATE@HAT a WHERE a.DOCCODE = DR.DOCCODE)");
		sqlStr.append("	)");
		sqlStr.append("	ORDER BY 2, DOCCODE, TEMDAY, 28 ");

		return UtilDBWeb.getReportableListCIS(sqlStr.toString());
	}

	private String parseUTF(String str) {
		if (str != null) {
			try {
				return URLEncoder.encode(str, "UTF-8").replace(ConstantsVariable.PLUS_VALUE, ConstantsVariable.SPACE_VALUE);
			} catch (Exception e) {
			}
		}
		return null;
	}
%><?xml version="1.0" encoding="utf-8"?>
<DoctorList>
<%
String[] dateTag = new String[] { "", "SUN", "MON", "TUE", "WED", "THUR", "FRI", "SAT" };

// create connection
ArrayList<ReportableListObject> record = null;
ReportableListObject row = null;
StringBuffer sqlStr = new StringBuffer();

HashMap<String, String> spcENameMap = getSpecCode();
HashMap<String, Vector> unavailableSchedule = getUnavailableSchedule();
record = getDoctorList();

boolean isPrintDeptTag = false;
boolean isPrintDocTag = false;

String filePathDest = null;
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

Vector unavailableScheduleTime = null;

if (record.size() > 0) {
	temday_curr = -1;
	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		docCode_curr = row.getValue(0);
		deptCode_curr = row.getValue(1);
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
			filePathDest = ConstantsServerSide.DOCTOR_PHOTO_DEST + File.separator + docCode_curr + ".jpg";

			// check doctor image
			if (!ConstantsServerSide.DEBUG) {
				FileUtil.copyFile(
						ConstantsServerSide.DOCTOR_PHOTO_SRC + File.separator + docCode_curr + ".jpg",
						filePathDest,
						true
				);
			}
		}

		if (isPrintDocTag && i > 0) {
%>
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
  	<DoctorSpecCode><%=row.getValue(30) %></DoctorSpecCode>
    <DoctorDepartmentName_en><%=parseUTF(deptCodeDis_en) %></DoctorDepartmentName_en>
    <DoctorDepartmentName_tc><%=deptCodeDis_tc %></DoctorDepartmentName_tc>
<%
			if (deptCodeSubDis_en != null && deptCodeSubDis_tc != null) {
%>
    <DoctorSubSpecCode><%=spcENameMap.get(deptCodeSubDis_en) %></DoctorSubSpecCode>
    <DoctorDepartmentSubName_en><%=parseUTF(deptCodeSubDis_en) %></DoctorDepartmentSubName_en>
    <DoctorDepartmentSubName_tc><%=deptCodeSubDis_tc %></DoctorDepartmentSubName_tc>
<%
			}
		}

		if (isPrintDocTag) {
%>
    <Doctor>
      <Name_en><%=parseUTF(row.getValue(3)) %>, <%=parseUTF(row.getValue(4)) %></Name_en>
      <Name_tc><%=row.getValue(5) %></Name_tc>
      <image_path>/doctorPhoto/<%=docCode_curr %>.jpg</image_path>
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
      <Doctor_startDate><%=row.getValue(32) %></Doctor_startDate>
<%
		if ("100".equals(row.getValue(31))) {
%>
      <DoctorType_en>CONSULTANT ANAESTHESIOLOGIST</DoctorType_en>
      <DoctorType_tc>麻醉科顧問醫生</DoctorType_tc>
<%
		} else if ("200".equals(row.getValue(31))) {
%>
       <DoctorType_en>CONSULTANT CARDIOLOGIST</DoctorType_en>
       <DoctorType_tc>心臟科顧問醫生</DoctorType_tc>
<%
		} else if ("300".equals(row.getValue(31))) {
%>
	  <DoctorType_en>CONSULTANT OBSTETRICIAN AND GYNAECOLOGIST</DoctorType_en>
	  <DoctorType_tc>婦產科顧問醫生</DoctorType_tc>
<%
	    } else if ("400".equals(row.getValue(31))) {
%>
	  <DoctorType_en>CONSULTANT OPHTHALMOLOGIST</DoctorType_en>
	  <DoctorType_tc>眼科顧問醫生</DoctorType_tc>
<%
	    } else if ("500".equals(row.getValue(31))) {
%>
	  <DoctorType_en>CONSULTANT PAEDIATRICIAN</DoctorType_en>
	  <DoctorType_tc>兒科顧問醫生</DoctorType_tc>
<%
	    } else if ("600".equals(row.getValue(31))) {
%>
	  <DoctorType_en>CONSULTANT SURGEON</DoctorType_en>
	  <DoctorType_tc>外科顧問醫生</DoctorType_tc>
<%
		} else if ("I".equals(row.getValue(29))) {
%>
      <DoctorType_en>In-house Physician</DoctorType_en>
      <DoctorType_tc>本院醫生</DoctorType_tc>
<%
		}

		if (unavailableSchedule.containsKey(docCode_curr)) {
			unavailableScheduleTime = unavailableSchedule.get(docCode_curr);
%>
      <UnavailableTimetable>
<%
			for (int j = 0; j < unavailableScheduleTime.size(); j++) {
%>
				<DateTime><%=unavailableScheduleTime.get(j) %></DateTime>
<%
			}
%>
      </UnavailableTimetable>
<%
		}
%>
      <timetable>
<%
		}
		if (temday_curr >=0 && temday_curr <= 7) {
%>
      <<%=dateTag[temday_curr] %>>
        <TIME><%=row.getValue(27) %> - <%=row.getValue(28) %></TIME>
      </<%=dateTag[temday_curr] %>>
<%
		}
		// store current doc code
		docCode_prev = docCode_curr;

		// store current dept code
		deptCode_prev = deptCode_curr;
	}
%>
      </timetable>
    </Doctor>
  </DoctorDepartment>
<%
}
%></DoctorList>