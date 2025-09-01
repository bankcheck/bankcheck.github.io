<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.util.mail.UtilMail"%>
<%@ page import="com.hkah.util.upload.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.text.DecimalFormat"%>

<%
	String admissionID = ParserUtil.getParameter(request, "admissionID");
	String receiptNo = ParserUtil.getParameter(request, "receiptNo");
	String paymentType = ParserUtil.getParameter(request, "paymentType");
	String amount = ParserUtil.getParameter(request, "amount");

	String vpc_Amount_disp = null ;
	double amt = Double.parseDouble(amount);
	DecimalFormat formatter = new DecimalFormat("###,###");
	vpc_Amount_disp = formatter.format(amt);

	String language = ParserUtil.getParameter(request, "language");
	String patno = null ;
	String patfname = null ;
	String patgname = null ;
	String patcname = null ;
	String admissionDoctor = null ;
	String createDate = null ;

	try {
		ArrayList record = AdmissionDB.get(admissionID);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
			patno = row.getValue(1);
			patfname = row.getValue(2);
			patgname = row.getValue(3);
			patcname = row.getValue(5);
			admissionDoctor = AdmissionDB.getDocName( row.getValue(64) );
			//createDate = row.getValue(77);
			createDate = row.getValue(104);
		}
	} catch (Exception e) {
		e.printStackTrace();
	}

%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
	<jsp:param name="title" value="Hong Kong Adventist Hospital" />
</jsp:include>
<script type="text/javascript" src="<html:rewrite page="/js/xepOnline.jqPlugin.js"/>" ></script>
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/registration/background.css" />" />
<head>
    <style type="text/css" media="print">
	    @page 
	    {
    	    size:  auto;   /* auto is the initial value */
        	margin: 0mm;  /* this affects the margin in the printer settings */
	    }
	    html
    	{
        	background-color: #FFFFFF; 
        	margin: 0px;  /* this affects the margin on the html before sending to printer */
    	}
    	body
    	{
        	border: solid 1px blue ;
        	margin: 10mm 15mm 10mm 15mm; /* margin you want for the content */
    	}
    </style>
    <style type="text/css">
    	td { font-size: 15pt;}
    </style>
</head>
<body>
<DIV id=wrapper class="wrapper" style="background-color:white;">
<DIV >
<DIV  style="background-color:white;">
<jsp:include page="admission_header.jsp" flush="false">
	<jsp:param name="language" value="<%=language %>" />
</jsp:include><table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td>&nbsp;</td>
</tr>
</table>
<div class="normal_area">
<div class="career_form" style="padding: 20px 18px;">

<br>

<div id="receipt">
<img src="../images/HKAH_logo_RGB.jpg" width=400px height=80px>
<table width="100%" border="0" cellpadding="0" cellspacing="0">

	<tr><td colspan="4" align="center"><font size="6">Advance Payment 按金單</font></td></tr>
	<tr><td colspan="4">&nbsp;</td><tr>
	<tr height="30"><td>Patient No.</td><td>病歷號碼  : </td><td><%=patno %></td><td></td><td></td></tr>
	<tr height="30"><td>Name</td><td>病人姓名 : </td><td><%=patfname + " " + patgname + " " + patcname %></td><td></td><td></td></tr>
	<tr height="30"><td>Doctor</td><td>主診醫生 : </td><td><%=admissionDoctor %></td><td></td><td></td></tr>
	<tr height="30"><td>Ref.</td><td>按金單號 : </td><td><%=admissionID %></td><td></td><td></td></tr>
	<tr height="30"><td colspan=2></td><td></td><td>Payment Date : </td><td><%=createDate %></td></tr>
 	<tr height="20"><td colspan=2>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>Amount 金額</td></tr>
 	<tr height="20"><td colspan=2>&nbsp;</td><td>&nbsp;</td><td>&nbsp;</td><td>&nbsp</td></tr>
 	<tr height="20"><td colspan=2>Item 要項</td><td width="50%";>Description</td><td>&nbsp;</td><td>HKD 港幣</td></tr>
 	<tr height="0" style="outline: thin solid" ><td colspan=2></td><td></td><td></td><td></td></tr>
 	<tr height="30"><td colspan=2><%=receiptNo%></td><td><%=paymentType%></td><td>&nbsp;</td><td><%=vpc_Amount_disp %></td></tr>
</table>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="20">&nbsp;</td>
	</tr>
</table>
<br />
<br />
<br />
</div>


<div class="pane">
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr class="smallText">
		<td align="center">
		<button class="btn-submit" onclick="printReceipt();return false;">Print Receipt</button>
		</td>
		<td align="center">
		<button class="btn-submit" onclick="closeReceipt();">Close</button>
		</td>
		<td align="center">
			<button class="btn-submit" onclick="return xepOnline.Formatter.Format('receipt',{pageWidth:'216mm', pageHeight:'279mm', render:'download'});">PDF</button>
		</td>
	</tr>
</table>
</div>

<a class="iframe" id="show_info_tree" href="../registration/information_tree.jsp?language=<%=language %>&style=popup" ></a>
</div>
</div>
</DIV>
</DIV>
<div  class="push"></div>
 <table  width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td>&nbsp;</td>
</tr>
</table>
</DIV>

<jsp:include page="admission_footer.jsp" flush="false" />

<script language="javascript">
function printReceipt() {
	//window.print();

	//w=window.open();
	//w.document.write($('#receipt').html());
	//w.print();
	//w.close();
	
	var printContent = document.getElementById('receipt');
	var windowUrl = 'Receipt';
    var uniqueName = new Date();
    var windowName = 'Print' + uniqueName.getTime();
    var printWindow = window.open(windowUrl, windowName, 'left=50000,top=50000,width=0,height=0');
    printWindow.document.write(printContent.innerHTML);
    printWindow.document.close();
    printWindow.focus();
    printWindow.print();
    printWindow.close();
	}
function closeReceipt() {
	window.location.href = 'online_admission_submit.jsp';
	//document.form1.action = "online_admission_submit.jsp";
	//window.location.replace("http://stackoverflow.com");
}
$(document).ready(function() {
});

</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>