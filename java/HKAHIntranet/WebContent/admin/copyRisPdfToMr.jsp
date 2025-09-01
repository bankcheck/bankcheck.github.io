<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="org.apache.commons.io.FileUtils" %>
<%@ page import="java.util.*" %>
<%@ page import="java.io.*" %>
<%!
/*
-- pdf not match case (2011 Nov 11)
select * from ris_report_message@hat
where
msg_seq_no in
(13696,
15789,
15815,
15817,
15819,
15821,
15824,
15826,
15828,
15831,
15833,
15836,
16075,
18698,
20542,
20549,
21271,
21272,
21655,
21889,
24409,
24602,
24602,
24848,
24849,
24850,
25319,
25319,
25319,
25319,
25319,
25319,
25820,
26567,
26567,
27236,
27248,
27263,
27269,
27569,
28378,
28378,
28585,
29970,
29970,
29970,
29970,
29970,
30347,
31617,
31621,
31621,
31870,
31870,
31870,
31870,
31870,
32812,
40664,
40667,
40675,
40678,
40678,
40678,
40691,
40691,
40696,
40748,
40753,
40771,
40771,
40771,
40786,
40797,
40797,
40799,
40800,
40800,
40800,
40828,
40830,
40834,
40850,
40852,
40855,
40859
);
-- 61
*/
public static String copyFile() {
	StringBuffer outStr = new StringBuffer();
	String mrpdfBasePath = "\\\\160.100.2.79\\mrpdf\\";
	String destPath = null;
	// 20131112 Anson corrected 44 cases
	try {
		StringBuffer sqlStr = new StringBuffer();
		sqlStr.append("select msg_seq_no, report_path ");
		sqlStr.append("from Ris_Report_Message@Hat M ");
		sqlStr.append("Where ");
		sqlStr.append("M.His_Rtn_Msg Not Like '%ERROR%'");
		sqlStr.append("And M.Ris_Accession_No Not In ");
		sqlStr.append("(");
		sqlStr.append("'HKADI1300013948R',");
		sqlStr.append("'HKADI1300013950P',");
		sqlStr.append("'HKADI1300013951M',");
		sqlStr.append("'HKADI1300018749Q',");
		sqlStr.append("'HKADI1300016331K',");
		sqlStr.append("'HKADI1300013279P',");
		sqlStr.append("'HKADI1300013245R'");
		sqlStr.append(") ");
		sqlStr.append("And m.Msg_Seq_No In ");
		sqlStr.append("(");
		sqlStr.append("'13696',");
		sqlStr.append("'15789',");
		sqlStr.append("'15815',");
		sqlStr.append("'15817',");
		sqlStr.append("'15819',");
		sqlStr.append("'15821',");
		sqlStr.append("'15824',");
		sqlStr.append("'15826',");
		sqlStr.append("'15828',");
		sqlStr.append("'15831',");
		sqlStr.append("'15833',");
		sqlStr.append("'15836',");
		sqlStr.append("'16075',");
		sqlStr.append("'18698',");
		sqlStr.append("'20542',");
		sqlStr.append("'20549',");
		sqlStr.append("'21271',");
		sqlStr.append("'21272',");
		sqlStr.append("'21655',");
		sqlStr.append("'21889',");
		sqlStr.append("'24409',");
		sqlStr.append("'24602',");
		sqlStr.append("'24602',");
		sqlStr.append("'24848',");
		sqlStr.append("'24849',");
		sqlStr.append("'24850',");
		sqlStr.append("'25319',");
		sqlStr.append("'25319',");
		sqlStr.append("'25319',");
		sqlStr.append("'25319',");
		sqlStr.append("'25319',");
		sqlStr.append("'25319',");
		sqlStr.append("'25820',");
		sqlStr.append("'26567',");
		sqlStr.append("'26567',");
		sqlStr.append("'27236',");
		sqlStr.append("'27248',");
		sqlStr.append("'27263',");
		sqlStr.append("'27269',");
		sqlStr.append("'27569',");
		sqlStr.append("'28378',");
		sqlStr.append("'28378',");
		sqlStr.append("'28585',");
		sqlStr.append("'29970',");
		sqlStr.append("'29970',");
		sqlStr.append("'29970',");
		sqlStr.append("'29970',");
		sqlStr.append("'29970',");
		sqlStr.append("'30347',");
		sqlStr.append("'31617',");
		sqlStr.append("'31621',");
		sqlStr.append("'31621',");
		sqlStr.append("'31870',");
		sqlStr.append("'31870',");
		sqlStr.append("'31870',");
		sqlStr.append("'31870',");
		sqlStr.append("'31870',");
		sqlStr.append("'32812',");
		sqlStr.append("'40664',");
		sqlStr.append("'40667',");
		sqlStr.append("'40675',");
		sqlStr.append("'40678',");
		sqlStr.append("'40678',");
		sqlStr.append("'40678',");
		sqlStr.append("'40691',");
		sqlStr.append("'40691',");
		sqlStr.append("'40696',");
		sqlStr.append("'40748',");
		sqlStr.append("'40753',");
		sqlStr.append("'40771',");
		sqlStr.append("'40771',");
		sqlStr.append("'40771',");
		sqlStr.append("'40786',");
		sqlStr.append("'40797',");
		sqlStr.append("'40797',");
		sqlStr.append("'40799',");
		sqlStr.append("'40800',");
		sqlStr.append("'40800',");
		sqlStr.append("'40800',");
		sqlStr.append("'40828',");
		sqlStr.append("'40830',");
		sqlStr.append("'40834',");
		sqlStr.append("'40850',");
		sqlStr.append("'40852',");
		sqlStr.append("'40855',");
		sqlStr.append("'40859'");
		sqlStr.append(") ");
		ArrayList risMRList = UtilDBWeb.getReportableListCIS(sqlStr.toString());

		for (int i = 0; i < risMRList.size(); i++) {
			ReportableListObject rlo = (ReportableListObject) risMRList.get(i);
			String msgSeqNo = rlo.getFields0();
			String reportPath = rlo.getFields1();

			sqlStr.setLength(0);
			sqlStr.append("select folder, fname ");
			sqlStr.append("from dms_pat_rec_ris_20131112 ");
			sqlStr.append("Where ");
			sqlStr.append("keyword like '%msgid=" + msgSeqNo + "%'");
			ArrayList cisDmsPatRecRisList = UtilDBWeb.getReportableListCIS(sqlStr.toString());
			if (!cisDmsPatRecRisList.isEmpty()) {
				ReportableListObject rlo2 = (ReportableListObject) cisDmsPatRecRisList.get(0);
				String oFolder = rlo2.getFields0();
				String oFname = rlo2.getFields1();

				destPath = mrpdfBasePath + oFolder + "\\" + oFname;
			} else {
				outStr.append("Cannot find msgSeqNo="+msgSeqNo+" in dms_pat_rec_ris_20131112" + "<br/>");
			}

			File srcFile = new File(reportPath);
			File destFile = new File(destPath);

			outStr.append("Copy from "+ srcFile.getCanonicalPath() + " to " + destFile.getCanonicalPath() + "<br/>");
			FileUtils.copyFile(srcFile, destFile);
		}
	} catch (Exception e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
		outStr.append(e.getMessage() + "<br/>");
	}
	return outStr.toString();
}
%>
<%
	UserBean userBean = new UserBean(request);
	boolean isRun = false;
	String ret = null;
	if (userBean.isAdmin()) {
		isRun = true;
		ret = copyFile();
	}

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>testCheckDocument</title>
</head>
<body>
Run copyRisPdfToMr
<%
	if (isRun) {
%>
 completed:<br />
<%=ret %>
<%
	} else {
%>
	Access Denied.
<%
	}
%>
</body>
</html>