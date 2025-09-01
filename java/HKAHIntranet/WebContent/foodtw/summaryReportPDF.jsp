<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="java.io.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="com.hkah.util.mail.UtilMail"%>
<%!
public class SummaryDetail {
	Date contDate;
	String content;

	public SummaryDetail(Date contDate, String content) {
		this.contDate = contDate;
		this.content = content;
	}

	public Date getDate() {
		return this.contDate;
	}

	public String getContent() {
		return this.content;
	}
}

private void mergeList(ArrayList bList, ArrayList lList, ArrayList dList, ArrayList srcList) {
	for (int i = 0; i < srcList.size(); i++) {
		SummaryDetail temp = (SummaryDetail)srcList.get(i);

		Date today = new Date();
		if ((temp.getDate().getDate() - today.getDate() == 1) ||
					(temp.getDate().getMonth() - today.getMonth() == 1)) {
			addToList(bList, temp);
		} else {
			if (temp.getDate().getHours() < 11) {
				addToList(bList, temp);
			} else if (temp.getDate().getHours() == 11) {
				if (temp.getDate().getMinutes() < 30) {
					addToList(bList, temp);
				} else {
					addToList(lList, temp);
				}
			} else if (temp.getDate().getHours() < 17) {
				addToList(lList, temp);
			} else if (temp.getDate().getHours() == 17) {
				if (temp.getDate().getMinutes() < 30) {
					addToList(lList, temp);
				} else {
					addToList(dList, temp);
				}
			} else {
				addToList(dList, temp);
			}
		}
	}
}

private void addToList(ArrayList originalList, SummaryDetail obj) {
	int addIndex = originalList.size();

	if (originalList.size() > 0) {
		for (int j = 0; j < originalList.size(); j++) {
			SummaryDetail temp = (SummaryDetail)originalList.get(j);
			int result = obj.getDate().compareTo(temp.getDate());
			if (result < 0) {
				addIndex = j;
				break;
			}
		}
	}

	originalList.add(addIndex, obj);
}

private ArrayList getRemark(String patNo, String regID) throws Exception{
	ArrayList patSerList = PatientDB.getFoodServiceList(patNo, regID, true, true, "0", "I", "1");
	ReportableListObject patSerRow = null;
	ArrayList tempList = new ArrayList();

	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

	if (patSerList.size() > 0) {
		for (int i = 0; i < patSerList.size(); i++) {
			patSerRow = (ReportableListObject)patSerList.get(i);
			Date today = new Date();

			if (patSerRow.getValue(20).equals("1")) {
				addToList(tempList, new SummaryDetail(
										sdf.parse(patSerRow.getValue(15)),
										"<label style='font-color:blue'><b><u>"+
										patSerRow.getValue(15)+"</u></b></label><br>"
										+"Remark: "+patSerRow.getValue(13)+
										(patSerRow.getValue(20).equals("1")&&
												(today.getDate()==Integer.parseInt(patSerRow.getValue(15).substring(0, 2)))
													?"(effective)":"")));
			}
		}
	}

	return tempList;
}

private ArrayList getSummary(String patNo, String regID, String serType) throws Exception{
	ArrayList foodOrderList = fetchOrderHistory(patNo, regID, serType);
	ArrayList detailList = new ArrayList();

	ReportableListObject foodOrderRow = null;

	SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy HH:mm");

	if (foodOrderList.size() > 0) {
		Date serDate = new Date();
		String content = "";
		String orderNo = "";

		for (int i = 0; i < foodOrderList.size(); i++) {
			foodOrderRow = (ReportableListObject)foodOrderList.get(i);

			if (foodOrderRow.getValue(1).equals("X") && !foodOrderRow.getValue(6).toUpperCase().equals("WEB")) {
					continue;
			}

			if (foodOrderRow.getValue(3).equals("now")) {
				serDate = sdf.parse(foodOrderRow.getValue(7));
			} else {
				serDate = sdf.parse(foodOrderRow.getValue(2));
				serDate.setHours(Integer.parseInt(foodOrderRow.getValue(3).split(":")[0]));
				serDate.setMinutes(Integer.parseInt(foodOrderRow.getValue(3).split(":")[1]));
			}

			content = "<label style='font-color:blue'><b><u>"+sdf.format(serDate)+
							"</u></b></label><br>Serve Type: "+((foodOrderRow.getValue(9).equals("B")?"Breakfast":
								(foodOrderRow.getValue(9).equals("L")?"Lunch":
									(foodOrderRow.getValue(9).equals("S")?"Snack":
									(foodOrderRow.getValue(9).equals("D")?"Dinner":"")))))+
							"<br>Order:<br/> "+fetchOrderDetail(foodOrderRow.getValue(0));

			//System.out.println(content);
			addToList(detailList, new SummaryDetail(serDate, content));
		}
	}

	return detailList;
}

private ArrayList<ReportableListObject> fetchOrderHistory(String patNo, String regID, String serType) {
//	String date = getRegDate(patNo);

	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT * ");
	sqlStr.append("FROM (SELECT H.ORDER_NO, H.STATUS, TO_CHAR(H.SERVE_DATE, 'DD/MM/YYYY HH24:MI:SS'), H.SERVE_TIME, H.SLPAMT, ");
	sqlStr.append("H.CREATE_USER, H.UPDATE_USER, TO_CHAR(H.CREATE_DATE, 'DD/MM/YYYY HH24:MI'), H.PATNO, ");
	sqlStr.append("H.SERVE_TYPE ");
	sqlStr.append("FROM DIT_ORDER_HDR H ");
	sqlStr.append("WHERE H.PATNO = '"+patNo+"' ");
	sqlStr.append("AND H.REGID = '"+regID+"' ");
	sqlStr.append("AND H.SERVE_TYPE = '"+serType+"' ");
	//sqlStr.append("AND D.ORDER_NO = H.ORDER_NO ");
	sqlStr.append("AND H.SERVE_DATE >= TO_DATE(TO_CHAR(SYSDATE, 'DD/MM/YYYY')||' 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("AND H.SERVE_DATE <= TO_DATE(TO_CHAR(SYSDATE+1, 'DD/MM/YYYY')||' 23:59:59', 'DD/MM/YYYY HH24:MI:SS') ");
//	if (date != null) {
//		sqlStr.append("AND CREATE_DATE >= TO_DATE('"+date+"', 'DD/MM/YYYY HH24:MI:SS') ");
//	}
	sqlStr.append("ORDER BY H.ORDER_NO DESC) ");

	return UtilDBWeb.getReportableListFSD(sqlStr.toString());
}

private String fetchOrderDetail(String orderNo) {
	StringBuffer sqlStr = new StringBuffer();
	String content = "";

	sqlStr.append("SELECT ORDER_NO, ITEM_SEQ, ITEM_TYPE, ITEM_CODE, ITEM_OPT, ");
	sqlStr.append("ITEM_NAME1, ITEM_NAME2, REMARKS, ORDER_QTY, CURRENCY, AMOUNT, ");
	sqlStr.append("BILLAMT, KITCHEN ");
	sqlStr.append("FROM DIT_ORDER_DTL ");
	sqlStr.append("WHERE ORDER_NO = '"+orderNo+"' ");
	sqlStr.append("ORDER BY ITEM_SEQ ");

	ArrayList record = UtilDBWeb.getReportableListFSD(sqlStr.toString());
	if (record.size() > 0) {
		ReportableListObject row = null;
		String firstType = "";
		String subItem = "";
		int seq = 1;
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject)record.get(i);

			if (firstType.length() == 0) {
				if (!row.getValue(2).equals("M")) {
					firstType = row.getValue(2);
				}
			}

			if (row.getValue(2).equals("M")) {
				content += seq + ". " + row.getValue(5) + " X " + row.getValue(8) + "<br/>";
				seq++;
			} else if (row.getValue(2).equals("S")) {
				content += seq + ". " + row.getValue(5) + " X " + row.getValue(8) + "<br/>";
				seq++;
				if (firstType.equals("I")) {
					content += subItem;
					subItem = "";
				}
			} else if (row.getValue(2).equals("I")) {
				subItem += "&nbsp;&nbsp;&nbsp;&nbsp;" + row.getValue(5) + "<br/>";
				if (firstType.equals("S")) {
					content += "&nbsp;&nbsp;&nbsp;&nbsp;" + row.getValue(5) + "<br/>";
				}
			}
		}
	}

	return content;
}
%>
<%
UserBean userBean = new UserBean(request);

String site = null;
String ward = request.getParameter("ward");
String type = request.getParameter("type");

SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");

if (userBean != null && userBean.isLogin()) {
	boolean success = false;
	ArrayList record =PatientDB.getInPatList(ward, null, false);

	if (record.size() > 0) {
		int length = 0;
		ReportableListObject row = null;
		for (int i = 0; i < record.size(); i++) {
			row = (ReportableListObject)record.get(i);
			String breakfast = "";
			String lunch = "";
			String dinner = "";

			ArrayList bList = getSummary(row.getValue(7), row.getValue(5), "B");
			ArrayList lList = getSummary(row.getValue(7), row.getValue(5), "L");
			ArrayList sList = getSummary(row.getValue(7), row.getValue(5), "S");
			ArrayList dList = getSummary(row.getValue(7), row.getValue(5), "D");
			ArrayList rList = getRemark(row.getValue(7), row.getValue(5));

			mergeList(bList, lList, dList, sList);
			mergeList(bList, lList, dList, rList);

			for (int j = 0; j < bList.size(); j++) {
				breakfast += ((SummaryDetail)bList.get(j)).getContent() + "<br/>";
			}
			for (int j = 0; j < lList.size(); j++) {
				lunch += ((SummaryDetail)lList.get(j)).getContent() + "<br/>";
			}
			for (int j = 0; j < dList.size(); j++) {
				dinner += ((SummaryDetail)dList.get(j)).getContent() + "<br/>";
			}

			row.setValue(13, breakfast);
			row.setValue(14, lunch);
			row.setValue(15, dinner);
			row.setValue(6, PatientDB.getInpatientAllergy(row.getValue(7), row.getValue(3)));
			//System.out.println(row.getValue(1));
		}

		if ( ConstantsServerSide.SITE_CODE_HKAH.equalsIgnoreCase(userBean.getSiteCode())) {
			site = "Hong Kong Adventist Hospital- Stubbs Road";
		} else if (ConstantsServerSide.SITE_CODE_TWAH.equalsIgnoreCase(userBean.getSiteCode())) {
			site = "Hong Kong Adventist Hospital - Tsuen Wan";
		}

		File reportFile;

		if (type.equals("default")) {
			reportFile = new File(application.getRealPath("/report/RPT_FS_SUMMARY.jasper"));
		} else {
			reportFile = new File(application.getRealPath("/report/RPT_FS_SUMMARY_SMALL_FONT.jasper"));
		}

		if (reportFile.exists()) {
			JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());

			Map parameters = new HashMap();
			parameters.put("BaseDir", reportFile.getParentFile());
			parameters.put("Site", site);

			JasperPrint jasperPrint =
				JasperFillManager.fillReport(
					jasperReport,
					parameters,
					new ReportListDataSource(record));

			File pdf = File.createTempFile("fs_summary_"+sdf.format(new Date())+".", ".pdf");
			JasperExportManager.exportReportToPdfStream(jasperPrint, new FileOutputStream(pdf));

			success =
				//UtilMail.sendMail(ConstantsServerSide.MAIL_ALERT, new String[]{"andrew.lau@hkah.org.hk"}, null, null, "Food Service - Summary",
				//		"Please refer to the attached document.", pdf, "FS_SUMMARY_"+ward.toUpperCase()+"_"+sdf.format(new Date())+".pdf");
				EmailAlertDB.sendEmail("fs.summary."+ward.toLowerCase(), "Food Service - Summary",
							"Please refer to the attached document.", pdf, "FS_SUMMARY_"+ward.toUpperCase()+"_"+sdf.format(new Date())+".pdf");
			boolean fileDeleted = pdf.delete();
			System.out.println("[FoodTW]Temp File Deleted: "+fileDeleted);
		}
	}

%>
		<%=success %>
<%
} else {
%>
	<script>
		window.open("../foodtw/index.jsp", "_self");
	</script>
<%
	return;
}
%>

