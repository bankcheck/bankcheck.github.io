<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
UserBean userBean = new UserBean(request);

String command = request.getParameter("command");
String admissionID = request.getParameter("admissionID");
String step = request.getParameter("step");

String patno = request.getParameter("patno");
String expectedAdmissionDate = request.getParameter("expectedAdmissionDate");
String expectedAdmissionTime = null;
String expectedAdmissionTime_hh = request.getParameter("expectedAdmissionTime_hh");
String expectedAdmissionTime_mi = request.getParameter("expectedAdmissionTime_mi");
String actualAdmissionDate = request.getParameter("actualAdmissionDate");
String actualAdmissionTime = request.getParameter("actualAdmissionTime");
String admissiondoctor = TextUtil.parseStrBIG5(request.getParameter("admissiondoctor"));
String remarks = TextUtil.parseStrBIG5(request.getParameter("remarks"));

String patidno = null;
String patidno1 = TextUtil.parseStr(request.getParameter("patidno1")).toUpperCase();
String patidno2 = TextUtil.parseStr(request.getParameter("patidno2")).toUpperCase();
String patpassport = TextUtil.parseStr(request.getParameter("patpassport")).toUpperCase();
String patbdate = TextUtil.parseStrBIG5(request.getParameter("patbdate"));
String patfname = TextUtil.parseStrBIG5(request.getParameter("patfname"));
String patgname = TextUtil.parseStrBIG5(request.getParameter("patgname"));
String titleDesc = request.getParameter("titleDesc");
String titleDescOther = TextUtil.parseStrBIG5(request.getParameter("titleDescOther"));
String patcname = TextUtil.parseStrBIG5(request.getParameter("patcname"));
String passdocument = null;
String patsex = request.getParameter("patsex");
String racedesc = request.getParameter("racedesc");
String racedescOther = TextUtil.parseStrBIG5(request.getParameter("racedescOther"));
String religion = request.getParameter("religion");
String religionOther = TextUtil.parseStrBIG5(request.getParameter("religionOther"));
String patmsts = request.getParameter("patmsts");
String mothcode = request.getParameter("mothcode");
String mothcodeOther = TextUtil.parseStrBIG5(request.getParameter("mothcodeOther"));
String edulevel = request.getParameter("edulevel");
String pathtel = TextUtil.parseStrBIG5(request.getParameter("pathtel"));
String patotel = TextUtil.parseStrBIG5(request.getParameter("patotel"));
String patmtel = TextUtil.parseStrBIG5(request.getParameter("patmtel"));
String patftel = TextUtil.parseStrBIG5(request.getParameter("patftel"));
String occupation = TextUtil.parseStrBIG5(request.getParameter("occupation"));
String patemail = TextUtil.parseStrBIG5(request.getParameter("patemail"));
String patadd1 = TextUtil.parseStrBIG5(request.getParameter("patadd1"));
String patadd2 = TextUtil.parseStrBIG5(request.getParameter("patadd2"));
String patadd3 = TextUtil.parseStrBIG5(request.getParameter("patadd3"));
String patadd4 = TextUtil.parseStrBIG5(request.getParameter("patadd4"));
String coucode = request.getParameter("coucode");
String coudesc = null;

String patkfname1 = TextUtil.parseStrBIG5(request.getParameter("patkfname1"));
String patkgname1 = TextUtil.parseStrBIG5(request.getParameter("patkgname1"));
String patkcname1 = TextUtil.parseStrBIG5(request.getParameter("patkcname1"));
String patksex1 = request.getParameter("patksex1");
String patkrela1 = TextUtil.parseStrBIG5(request.getParameter("patkrela1"));
String patkhtel1 = TextUtil.parseStrBIG5(request.getParameter("patkhtel1"));
String patkotel1 = TextUtil.parseStrBIG5(request.getParameter("patkotel1"));
String patkmtel1 = TextUtil.parseStrBIG5(request.getParameter("patkmtel1"));
String patkptel1 = TextUtil.parseStrBIG5(request.getParameter("patkptel1"));
String patkemail1 = TextUtil.parseStrBIG5(request.getParameter("patkemail1"));
String patkadd11 = TextUtil.parseStrBIG5(request.getParameter("patkadd11"));
String patkadd21 = TextUtil.parseStrBIG5(request.getParameter("patkadd21"));
String patkadd31 = TextUtil.parseStrBIG5(request.getParameter("patkadd31"));
String patkadd41 = TextUtil.parseStrBIG5(request.getParameter("patkadd41"));

String patkfname2 = TextUtil.parseStrBIG5(request.getParameter("patkfname2"));
String patkgname2 = TextUtil.parseStrBIG5(request.getParameter("patkgname2"));
String patkcname2 = TextUtil.parseStrBIG5(request.getParameter("patkcname2"));
String patksex2 = request.getParameter("patksex2");
String patkrela2 = TextUtil.parseStrBIG5(request.getParameter("patkrela2"));
String patkhtel2 = request.getParameter("patkhtel2");
String patkotel2 = request.getParameter("patkotel2");
String patkmtel2 = request.getParameter("patkmtel2");
String patkptel2 = request.getParameter("patkptel2");
String patkemail2 = request.getParameter("patkemail2");
String patkadd12 = TextUtil.parseStrBIG5(request.getParameter("patkadd12"));
String patkadd22 = TextUtil.parseStrBIG5(request.getParameter("patkadd22"));
String patkadd32 = TextUtil.parseStrBIG5(request.getParameter("patkadd32"));
String patkadd42 = TextUtil.parseStrBIG5(request.getParameter("patkadd42"));

String roomType = request.getParameter("roomType");
String bedNo = request.getParameter("bedNo");
String paymentType = request.getParameter("paymentType");
String paymentTypeOther = request.getParameter("paymentTypeOther");
String creditCardType = request.getParameter("creditCardType");
String insuranceRemarks = request.getParameter("insuranceRemarks");
String insurancePolicyNo = request.getParameter("insurancePolicyNo");
String promotionYN = request.getParameter("promotionYN");
String confirmDate = null;

if (patidno1 != null && patidno2 != null) {
	patidno = patidno1 + patidno2;
}
if (expectedAdmissionTime_hh != null && expectedAdmissionTime_mi != null) {
	expectedAdmissionTime = expectedAdmissionTime_hh + ":" + expectedAdmissionTime_mi;
}

boolean printAction = false;
boolean closeAction = false;

if ("print".equals(command)) {
	printAction = true;
}

// check user right
try {
	// load data from database
	if (admissionID != null && admissionID.length() > 0) {
		ArrayList record = AdmissionDB.get(admissionID);
		if (record.size() > 0) {
			ReportableListObject row = (ReportableListObject) record.get(0);
				patno = row.getValue(1);
				patfname = row.getValue(2);
				patgname = row.getValue(3);
				patcname = row.getValue(4);
				titleDesc = row.getValue(5);
				titleDescOther = row.getValue(6);

				patidno = row.getValue(7);
				if (patidno.length() > 7) {
					int tempIDLastNo = patidno.length() - 1;
					patidno1 = patidno.substring(0, tempIDLastNo);
					patidno2 = patidno.substring(tempIDLastNo);
				} else {
					patidno1 = patidno;
					patidno2 = "";
				}
				patpassport = row.getValue(8);
				passdocument = row.getValue(9);

				patsex = row.getValue(10);
				racedesc = row.getValue(11);
				racedescOther = row.getValue(12);
				religion = row.getValue(13);
				religionOther = row.getValue(14);

				patbdate = row.getValue(15);
				patmsts = row.getValue(16);
				mothcode = row.getValue(17);
				mothcodeOther = row.getValue(18);
				edulevel = row.getValue(19);

				pathtel = row.getValue(20);
				patotel = row.getValue(21);
				patmtel = row.getValue(22);
				patftel = row.getValue(23);

				occupation = row.getValue(24);
				patemail = row.getValue(25);
				patadd1 = row.getValue(26);
				patadd2 = row.getValue(27);
				patadd3 = row.getValue(28);
				patadd4 = row.getValue(29);
				coucode = row.getValue(30);
				coudesc = row.getValue(31);

				patkfname1 = row.getValue(32);
				patkgname1 = row.getValue(33);
				patkcname1 = row.getValue(34);
				patksex1 = row.getValue(35);
				patkrela1 = row.getValue(36);

				patkhtel1 = row.getValue(37);
				patkotel1 = row.getValue(38);
				patkmtel1 = row.getValue(39);
				patkptel1 = row.getValue(40);

				patkemail1 = row.getValue(41);
				patkadd11 = row.getValue(42);
				patkadd21 = row.getValue(43);
				patkadd31 = row.getValue(44);
				patkadd41 = row.getValue(45);

				patkfname2 = row.getValue(46);
				patkgname2 = row.getValue(47);
				patkcname2 = row.getValue(48);
				patksex2 = row.getValue(49);
				patkrela2 = row.getValue(50);

				patkhtel2 = row.getValue(51);
				patkotel2 = row.getValue(52);
				patkmtel2 = row.getValue(53);
				patkptel2 = row.getValue(54);

				patkemail2 = row.getValue(55);
				patkadd12 = row.getValue(56);
				patkadd22 = row.getValue(57);
				patkadd32 = row.getValue(58);
				patkadd42 = row.getValue(59);

				expectedAdmissionDate = row.getValue(60);
				expectedAdmissionTime = row.getValue(61);
				actualAdmissionDate = row.getValue(62);
				actualAdmissionTime = row.getValue(63);
				admissiondoctor = row.getValue(64);
				roomType = row.getValue(66);
				bedNo = row.getValue(67);
				promotionYN = row.getValue(68);

				paymentType = row.getValue(68);
				paymentTypeOther = row.getValue(69);
				creditCardType = row.getValue(70);
				insuranceRemarks = row.getValue(71);
				insurancePolicyNo = row.getValue(72);
				confirmDate = row.getValue(74);
				remarks = row.getValue(76);
		} else {
			closeAction = true;
		}
	} else {
		closeAction = true;
	}
} catch (Exception e) {
	e.printStackTrace();
}
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
    Licensed to the Apache Software Foundation (ASF) under one or more
    contributor license agreements.  See the NOTICE file distributed with
    this work for additional information regarding copyright ownership.
    The ASF licenses this file to You under the Apache License, Version 2.0
    (the "License"); you may not use this file except in compliance with
    the License.  You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
--%>
<%@ page language="java" contentType="text/html; charset=big5" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp">
	<jsp:param name="title" value="Hong Kong Adventist Hospital" />
</jsp:include>
<%if (closeAction) { %>
<script type="text/javascript">window.close();</script>
<%} else { %>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<table width="650" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td align="right">
<a href="javascript:void(0);" onclick="window.print()">Print</a><br />
		</td>
	</tr>
</table>
<table width="650" border="0" cellpadding="0" cellspacing="0">
<%if(!printAction){ %>
	<tr>
		<td height="20" colspan="3">&nbsp;</td>
	</tr>
	<tr>
		<td height="20" colspan="3">
			<table width="700" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td valign="top" colspan="3"><%=MessageResources.getMessageEnglish("label.health.care.advisory") %> <%=MessageResources.getMessageTraditionalChinese("label.health.care.advisory") %> (<a href="javascript:void(0);" onclick="downloadFile('75');return false;" target="_blank">Read and Agreed �w�\Ū�ΦP�N</a>)</td>
				</tr>
				<tr>
					<td height="20" colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td valign="top" width="5%">
						<img src="../images/tick_green_small.gif" />
					</td>
					<td valign="top" width="60%">
						I have read this &quot;Health Care Advisory&quot;. I understand and accept that the hospital services will be charged according to my choice of room category. <br />���H�w�M���\Ū�H�W&quot;��|����&quot;�C���H���ըñ�����|���O�N�ھڥ��H�ҿ�ܪ��ж����O�ӭp��C
					</td>
					<td valign="top" align="center" width="35%">My room choice is<br /> ���H��ܩж����O��<br>
<%		if ("Private".equals(roomType)) {
				%><span class="infoResult">Private �Y��</span><%
			} else if ("Semi-Private".equals(roomType)) {
				%><span class="infoResult">Semi-Private �G��</span><%
			} %>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="3">&nbsp;</td>
	</tr>
<%} %>
	<tr>
		<td colspan="3" height="25">
			<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td class="style1"  <%if(printAction){ %>style="font-size:180%; "<%} %>><font color="black"><strong>Hospital Information ��|���</strong></font></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="3">&nbsp;</td>
	</tr>
	<tr <%if(printAction){ %>style="font-size:180%; "<%} %>>
		<td height="40" valign="top" bgcolor="#F9F9F9" >Hospital No. (Office Use Only �줽�ǱM��)<br />��|�s��
			<span class="infoResult"><%=patno==null?"":patno %></span>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			Admitting Doctor<br />�D�E���
			<span class="infoResult"><%=admissiondoctor==null?"":(AdmissionDB.getDocName(admissiondoctor)==null?admissiondoctor:AdmissionDB.getDocName(admissiondoctor)) %></span>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="3">&nbsp;</td>
	</tr>
	<tr <%if(printAction){ %>style="font-size:180%; "<%} %>>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			Admission date & time (DD ��/MM ��/YYYY �~ HH ��:MM ��)<br />�J�|���
			<span class="infoResult"><%=expectedAdmissionDate==null?"":expectedAdmissionDate %></span>
			<span class="infoResult"><%=expectedAdmissionTime==null?"":expectedAdmissionTime %></span>
		</td>
		<td width="2%" valign="top">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			Bed No.<br />�ɦ�s��
			<span class="infoResult"><%=bedNo==null?"":bedNo %></span>
		</td>
	</tr>
	<tr >
		<td height="20" colspan="3">&nbsp;</td>
	</tr>
	<tr <%if(printAction){ %>style="font-size:180%; "<%} %>>
		<td height="40" colspan="3" valign="top" bgcolor="#F9F9F9">Remarks<br />����
			<span class="infoResult"><%=remarks==null?"":remarks %></span><br />
		</td>
	</tr>
	<tr>
		<td height="20" colspan="3">&nbsp;</td>
	</tr>
</table>
<table width="650" border="0" cellpadding="0" cellspacing="0" <%if(printAction){ %>style="font-size:180%; "<%} %>>
	<tr>
		<td colspan="6" height="25">
			<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td class="style1"><font color="black"><strong>Personal Information �ӤH���</strong></font></td>
				</tr>
			</table>
		</td>
	</tr>

	<tr>
		<td height="40" valign="top" colspan="3" bgcolor="#F9F9F9">
			Hong Kong I.D. Card<br />���䨭���Ҹ��X <span class="infoResult"><%=patidno1==null?"":patidno1 %>(<%=patidno2==null?"":patidno2 %>)</span><br /><br />
			Passport No.<br />�@�Ӹ��X <span class="infoResult"><%=patpassport==null?"":patpassport %></span>
		</td>
<%if(!printAction){ %>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			Date of Birth (DD ��/MM ��/YYYY �~)<br />�X�ͤ��
			<span class="infoResult"><%=patbdate==null?"":patbdate %></span>
		</td>
<%} %>
	</tr>

	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9">
			Family Name as on I.D. Card/Passport<br />�m (�^��)
				<span class="infoResult"><%=patfname==null?"":patfname %></span>
		</td>
		<td width="2">&nbsp;</td>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9">
			Given Name as on I.D. Card/Passport<br />�W (�^��)
			<span class="infoResult"><%=patgname==null?"":patgname %></span>
		</td>
		<td width="2">&nbsp;</td>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9">
			Title<br />�ٿ�
			<span class="infoResult"><%=titleDesc==null?"":titleDesc %></span><br />
			Others<br />��L :
			<span class="infoResult"><%=titleDescOther==null?"":titleDescOther %></span>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="40" valign="top" bgcolor="#F9F9F9">Chinese Name<br />����m�W
			<span class="infoResult"><%=patcname==null?"":patcname %></span>
		</td>
		<td width="2">&nbsp;</td>
		
		<td height="40" valign="top" bgcolor="#F9F9F9">
			Sex<br />�ʧO
<%	if ("M".equals(patsex)) {
			%><span class="infoResult"><bean:message key="label.male" /></span><%
		} else if ("F".equals(patsex)) {
			%><span class="infoResult"><bean:message key="label.female" /></span><%
		} else {
			%><span class="infoResult">Others ��L</span><%
		} %>
		</td>
		<td width="2">&nbsp;</td>
<%if(!printAction){ %>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			Marital Status<br />�B�ê��p
<%	if ("S".equals(patmsts)) {
			%><span class="infoResult">Single ���B</span><%
		} else if ("M".equals(patmsts)) {
			%><span class="infoResult">Married �w�B</span><%
		} else if ("D".equals(patmsts)) {
			%><span class="infoResult">Divorce ���B></span><%
		} else if ("X".equals(patmsts)) {
			%><span class="infoResult">Separate ���~</span><%
		} else {
			%><span class="infoResult">Other ��L></span><%
		} %>
		</td>
<%} %>
	</tr>
<%if(!printAction){ %>	
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			Ethnic Group<br />�ر�
			<span class="infoResult"><%=racedesc==null?"":racedesc %></span><br />
			Others<br />��L :<span class="infoResult"><%=racedescOther==null?"":racedescOther %></span>
			<br />(For hospital statistic purpose �@����|�έp��)
		</td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			Religion<br />�v��
<%	if ("NO".equals(religion)) {
			%><span class="infoResult">None �S��</span><%
		} else if ("BU".equals(religion)) {
			%><span class="infoResult">Buddhism ���</span><%
		} else if ("CA".equals(religion)) {
			%><span class="infoResult">Catholic �ѥD��</span><%
		} else if ("CH".equals(religion)) {
			%><span class="infoResult">Christian �����</span><%
		} else if ("HI".equals(religion)) {
			%><span class="infoResult">Hinduism �L�ױ�</span><%
		} else if ("SH".equals(religion)) {
			%><span class="infoResult">Shintoism �饻���D��</span><%
		} else if ("SD".equals(religion)) {
			%><span class="infoResult">SDA ����_�{�w�����</span><%
		} else {
			%><span class="infoResult">Others ��L</span><%
		} %>
			<span class="infoResult"><%=religionOther==null?"":religionOther %></span>
		</td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			Education Level<br />�Ш|�{��
			<span class="infoResult"><%=edulevel==null?"":edulevel %></span>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td width="2" colspan="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			Spoken Language<br />�y��
<%	if ("ENG".equals(mothcode)) {
			%><span class="infoResult">English �^�y</span><%
		} else if ("CTE".equals(mothcode)) {
			%><span class="infoResult">Cantonese �s�F��</span><%
		} else if ("MAN".equals(mothcode)) {
			%><span class="infoResult">Mandarin ��y</span><%
		} else if ("JAP".equals(mothcode)) {
			%><span class="infoResult">Japanese �饻�y</span><%
		} else {
			%><span class="infoResult">Others ��L</span><%
		} %><br />
			Others<br />��L :<span class="infoResult"><%=mothcodeOther==null?"":mothcodeOther %></span>
		</td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			Occupation<br />¾�~
			<span class="infoResult"><%=occupation==null?"":occupation %></span>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="20" colspan="5" bgcolor="#F9F9F9">
			Contact Telephone Number<br />�p���q��<br />
			<table width=100%">
				<tr>
					<td height="40" valign="top" bgcolor="#F9F9F9">Home<br />��v
						<span class="infoResult"><%=pathtel==null?"":pathtel %></span>
					</td>
					<td width="2">&nbsp;</td>
					<td height="40" valign="top" bgcolor="#F9F9F9">Office<br />�줽��
						<span class="infoResult"><%=patotel==null?"":patotel %></span>
					</td>
				</tr>
				<tr>
					<td height="40" valign="top" bgcolor="#F9F9F9">Mobile/Pager No<br />�ⴣ���X/�ǩI�����X
						<span class="infoResult"><%=patmtel==null?"":patmtel %></span>
					</td>
					<td width="2">&nbsp;</td>
					<td height="40" valign="top" bgcolor="#F9F9F9">Fax No<br />�ǯu���X
						<span class="infoResult"><%=patftel==null?"":patftel %></span>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="20" colspan="5">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td height="40" valign="top" bgcolor="#F9F9F9">
						Email Address<br />�q�l�a�}
						<span class="infoResult"><%=patemail==null?"":patemail %></span>
					</td>
					<td width="2">&nbsp;</td>
					<td height="40" valign="top" colspan="3" bgcolor="#F9F9F9">
						Address<br />�a�}<br />
						<span class="infoResult"><%=patadd1==null?"":patadd1 %></span>
						<span class="infoResult"><%=patadd2==null?"":patadd2 %></span>
						<span class="infoResult"><%=patadd3==null?"":patadd3 %></span>
						<span class="infoResult"><%=coudesc==null?"":coudesc %></span>
					</td>
				</tr>
			</table>
		</td>
	</tr>
<%} %>
</table>
<%if(!printAction){ %>	
<table width="650" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" height="25">
			<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td class="style1"><font color="black"><strong>Emergency Contact Person Information ����p���H��� (1)</strong></font></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9">
			Family Name<br />�m (�^��)
			<span class="infoResult"><%=patkfname1==null?"":patkfname1 %></span>
		</td>
		<td width="2">&nbsp;</td>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9">
			Given Name<br />�W (�^��)
			<span class="infoResult"><%=patkgname1==null?"":patkgname1 %></span>
		</td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">Chinese Name<br />����m�W
			<span class="infoResult"><%=patkcname1==null?"":patkcname1 %></span>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="40" valign="top" bgcolor="#F9F9F9">
			Sex<br />�ʧO
<%	if ("M".equals(patksex1)) {
			%><span class="infoResult"><bean:message key="label.male" /></span><%
		} else if ("F".equals(patksex1)) {
			%><span class="infoResult"><bean:message key="label.female" /></span><%
		} else {
			%><span class="infoResult">Others ��L</span><%
		} %>
		</td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9" colspan=3">
			Contact Telephone Number<br />�p���q��<br />
			<table width=100%">
				<tr>
					<td height="40" valign="top" bgcolor="#F9F9F9">Home<br />��v
						<span class="infoResult"><%=patkhtel1==null?"":patkhtel1 %></span>
					</td>
					<td width="2">&nbsp;</td>
					<td height="40" valign="top" bgcolor="#F9F9F9">Office.<br />�줽��
						<span class="infoResult"><%=patkotel1==null?"":patkotel1 %></span>
					</td>
				</tr>
				<tr>
					<td height="40" valign="top" bgcolor="#F9F9F9">Mobile<br />�ⴣ���X
						<span class="infoResult"><%=patkmtel1==null?"":patkmtel1 %></span>
					</td>
					<td width="2">&nbsp;</td>
					<td height="40" valign="top" bgcolor="#F9F9F9">Pager No<br />�ǩI���X
						<span class="infoResult"><%=patkptel1==null?"":patkptel1 %></span>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="20" valign="top" bgcolor="#F9F9F9">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td height="40" valign="top">
						Relationship<br />���Y
						<span class="infoResult"><%=patkrela1==null?"":patkrela1 %></span>
						<br /><br /><br />
						Email Address<br />�q�l�a�}
						<span class="infoResult"><%=patkemail1==null?"":patkemail1 %></span>
					</td>
			</table>
		</td>
		<td width="2">&nbsp;</td>
		<td height="20" valign="top" bgcolor="#F9F9F9" colspan="3">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td width="2">&nbsp;</td>
					<td height="40" valign="top" colspan="3" bgcolor="#F9F9F9">
						Address<br />�a�}<br />
						<span class="infoResult"><%=patkadd11==null?"":patkadd11 %></span>
						<span class="infoResult"><%=patkadd21==null?"":patkadd21 %></span>
						<span class="infoResult"><%=patkadd31==null?"":patkadd31 %></span>
						<span class="infoResult"><%=patkadd41==null?"":patkadd41 %></span>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>

<% if (patkfname2 != null && patkfname2.length() > 0 && patkgname2 != null && patkgname2.length() > 0) { %>
<table width="650" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" height="25">
			<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td class="style1"><font color="black"><strong>Emergency Contact Person Information ����p���H��� (2)</strong></font></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9">Family Name<br />�m (�^��)
			<span class="infoResult"><%=patkfname2==null?"":patkfname2 %></span>
		</td>
		<td width="2">&nbsp;</td>
		<td width="32%" height="40" valign="top" bgcolor="#F9F9F9">Given Name<br />�W (�^��)
			<span class="infoResult"><%=patkgname2==null?"":patkgname2 %></span>
		</td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9">Chinese Name<br />����m�W
			<span class="infoResult"><%=patkcname2==null?"":patkcname2 %></span>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="40" valign="top" bgcolor="#F9F9F9">Sex<br />�ʧO
<%	if ("M".equals(patksex2)) {
			%><span class="infoResult"><bean:message key="label.male" /></span><%
		} else if ("F".equals(patksex2)) {
			%><span class="infoResult"><bean:message key="label.female" /></span><%
		} else {
			%><span class="infoResult">Others ��L</span><%
		} %>
		</td>
		<td width="2">&nbsp;</td>
		<td height="40" valign="top" bgcolor="#F9F9F9" colspan=3">
			Contact Telephone Number<br />�p���q��<br />
			<table width=100%">
				<tr>
					<td height="40" valign="top" bgcolor="#F9F9F9">Home<br />��v
						<span class="infoResult"><%=patkhtel2==null?"":patkhtel2 %></span>
					</td>
					<td width="2" valign="top">&nbsp;</td>
					<td height="40" valign="top" bgcolor="#F9F9F9">Office.<br />�줽��
						<span class="infoResult"><%=patkotel2==null?"":patkotel2 %></span>
					</td>
				</tr>
				<tr>
					<td height="40" valign="top" bgcolor="#F9F9F9">Mobile<br />�ⴣ���X
						<span class="infoResult"><%=patkmtel2==null?"":patkmtel2 %></span>
					</td>
					<td width="2" valign="top">&nbsp;</td>
					<td height="40" valign="top" bgcolor="#F9F9F9">Pager No<br />�ǩI���X
						<span class="infoResult"><%=patkptel2==null?"":patkptel2 %></span>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="20" valign="top" bgcolor="#F9F9F9">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td height="40" valign="top">
						Relationship<br />���Y
						<span class="infoResult"><%=patkrela2==null?"":patkrela2 %></span>
						<br /><br /><br />
						Email Address<br />�q�l�a�}
						<span class="infoResult"><%=patkemail2==null?"":patkemail2 %></span>
					</td>
				</tr>
			</table>
		</td>
		<td width="2">&nbsp;</td>
		<td height="20" valign="top" bgcolor="#F9F9F9" colspan="3">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td height="40" valign="top" colspan="3" bgcolor="#F9F9F9">
						Address<br />�a�}<br>
						<span class="infoResult"><%=patkadd12==null?"":patkadd12 %></span>
						<span class="infoResult"><%=patkadd22==null?"":patkadd22 %></span>
						<span class="infoResult"><%=patkadd32==null?"":patkadd32 %></span>
						<span class="infoResult"><%=patkadd42==null?"":patkadd42 %></span>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<%} %>
<table width="650" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" height="25">
			<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td class="style1"><font color="black"><strong>Method of Payment �I�ڤ�k</strong></font></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="20" colspan="5" bgcolor="#F9F9F9">
			*All accounts must either be guaranteed by an insurance company or settled before discharge. Please ensure the insurance or corporate company contracts with this hospital are valid.<br />
			�Ҧ���ᥲ���ѫO�I���q�O�ҩΥX�|�e�M�I�C�нT�O�ӫO�I�Υ��~���q�P���|���X�����ġC
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" height="20" bgcolor="#F9F9F9">
			<font color="red">*</font>I have read and agreed to the terms and conditions detailed on the "Daily Room Rate and Advance Payment" and then advise on the following (<a href="http://www.hkah.org.hk/new/eng/hospitalization_fi.htm" target="_blank">Read and Agreed</a>)<br />
			���H�w�\Ū�ΦP�N"�C��Я��M�wú����"�ô��ѥH�U��� (<a href="http://www.hkah.org.hk/new/chi/hospitalization_fi.htm" target="_blank">�w�\Ū�ΦP�N</a>)
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" height="20" bgcolor="#F9F9F9">
			Method of Payment �I�ڤ�k
<%	if ("CASH".equals(paymentType)) {
			%><span class="infoResult">Cash �{��</span><%
		} else if ("EPS".equals(paymentType)) {
			%><span class="infoResult">EPS �����</span><%
		} else if ("CREDIT CARD".equals(paymentType)) {
			%><span class="infoResult">Credit Card �H�Υd</span><%
			if (creditCardType != null && creditCardType.length() > 0) {
				%><span class="infoResult"> - <%=creditCardType %></span><%
			}			
		} else if ("CUP CARD".equals(paymentType)) {
			%><span class="infoResult">Cup Card ���p�d</span><%
		} else if ("INSURANCE".equals(paymentType)) {
			%><span class="infoResult">Insurance A/C �����O�I</span><br />
				Remarks ����<br /><span class="infoResult"><%=insuranceRemarks==null?"":insuranceRemarks %></span><br />
				Policy No. �O�I�s��<br /><span class="infoResult"><%=insurancePolicyNo==null?"":insurancePolicyNo %></span><%
		} else if ("CORPORATE".equals(paymentType)) {
			%><span class="infoResult">Corporate A/C ���q���</span><%
		} else if ("CREDIT CARD AUTH".equals(paymentType)) {
			%><span class="infoResult">Credit Card Authorization Form �H�Υd���v��</span><%
		} else if ("OTHER".equals(paymentType)) {
			%><span class="infoResult">Others ��L:<%=paymentTypeOther==null?"":paymentTypeOther %></span><%
		} %>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" height="25">
			<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td class="style1"><font color="black"><strong>Patient's Agreement �f�H��ĳ</strong></font></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="6">
			<table width="700" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td valign="top">(1)</td><td>The above information given by me is true and correct to the best of my personal knowledge;</td>
				</tr>
				<tr>
					<td valign="top">(2)</td><td>I have read and agreed to the terms and conditions detailed on the "Daily Room Rate and Advance Payment";</td>
				</tr>
				<tr>
					<td valign="top">(3)</td><td>I have read and agreed to the terms and conditions detailed on the "Health Care Advisory".  I understand and accept that the hospital services will be charged according to my choice of room category;</td>
				</tr>
				<tr>
					<td valign="top">(4)</td><td>I understand that the Hospital is committed to providing healthy menu to patients. To implement the said principle, vegetarian meal is the only choice available in this hospital;</td>
				</tr>
				<tr>
					<td valign="top">(5)</td><td>I receive and acknowledge the terms and conditions detailed on the "Patient Admission" and "Patient's Charter";</td>
				</tr>
				<tr>
					<td valign="top">(6)</td><td>I agree to pay the Hospital��s current rates and charges at the time the services rendered in respect of the facilities used and treatment received by me and all other incidental charges incurred;</td>
				</tr>
				<tr>
					<td valign="top">(7)</td><td>I agree to use solely the medicines provided by the Hospital during the hospitalization;</td>
				</tr>
				<tr>
					<td valign="top">(8)</td><td>I authorize the Hospital to contact my insurer and release my information required regarding my case to the insurance      company for verification of coverage under my insurance policy; and</td>
				</tr>
				<tr>
					<td valign="top">(9)</td><td>I agree to pay any outstanding charges that have not been paid or covered by my insurer.</td>
				</tr>
				<tr>
					<td width="31">&nbsp;</td><td width="669">&nbsp;</td>
				</tr>
				<tr>
					<td valign="top">(1)</td><td>���H���ѤW�z���@����Ʃ󥻤H���ӤH�{���d�򤺥��ݯu��M���T�F</td>
				</tr>
				<tr>
					<td valign="top">(2)</td><td>���H�w�\Ū�ΦP�N"�C��Я��M�wú����"�W���@�����ڡF</td>
				</tr>
				<tr>
					<td valign="top">(3)</td><td>���H�w�M���\Ū�ΦP�N"��|����"�W���@�����ڡC���H���ըñ�����|���O�N�ھڥ��H�ҿ�ܪ��ж����O�ӭp��F</td>
				</tr>
				<tr>
					<td valign="top">(4)</td><td>���H������|�P�O���Ѱ��d���������f�H�C���i�榹�ؼСA��|�������u���������\�F</td>
				</tr>
				<tr>
					<td valign="top">(5)</td><td>���H��x�α���"�J�|����"��"�f�H�v�q�P�d��"�W���@�����ڡF</td>
				</tr>
				<tr>
					<td valign="top">(6)</td><td>���H�P�N��I�@���P���H�������v���B�]�I�ΪA�ȨϥΡA�ΰ��o�ƬG���һݪ��O��;</td>
				</tr>
				<tr>
					<td valign="top">(7)</td><td>���H�P�N�b�d�|�����u�|�ϥΥ���|�������Ī�;</td>
				</tr>
				<tr>
					<td valign="top">(8)</td><td>���H�����|�P���H���ӫO�H�p���ô���P���H�������f����ơA�H�K�O�I���q�@��֫O�B���Юֵ{��; ��</td>
				</tr>
				<tr>
					<td valign="top">(9)</td><td>���H�P�N��I�Ҧ��B�~�O�ΩΫO�I���q�ҥ���ӫO���O�ΡC</td>
				</tr>
				<tr>
					<td width="31">&nbsp;</td><td width="669">&nbsp;</td>
				</tr>
				<tr>
					<td valign="top" colspan="2">
					<ul>
						<li>Patient Admission �J�|���� (<a href="javascript:void(0);" onclick="downloadFile('76');return false;" target="_blank">Click here �Ы���</a>)</li>
						<li>Patient's Charter �f�H�v�q�P�d�� (<a href="http://www.hkah.org.hk/new/eng/download/Patient_Charter.pdf" target="_blank">Click here �Ы���</a>)</li>
						<li>Why Vegetarian Diet ������n���� (<a href="http://www.hkah.org.hk/new/eng/download/Why_Vegetarian_Diet.pdf" target="_blank">Click here �Ы���</a>)</li>
					</ul></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="6" height="25">
			<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td class="style1"><font color="black"><strong>Signee's Acknowledgement ñ�p�H�P�N��</strong></font></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td colspan="6">
			<table width="700" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td valign="top">&nbsp;</td>
					<td>I, the undersigned, accept full responsibility for the settlement of all expenses incurred by the patient.<br/>
						��ñ�p�H���v�t�d��I�H�W�f�H���@���O�ΡC</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td valign="top">
<%	if ("Y".equals(promotionYN)) {
			%><img src="../images/tick_green_small.gif" /><%
		} else {
			%><img src="../images/cross_red_small.gif" /><%
		} %>
					</td>
					<td>We will periodically send you hospital and medical information. If you would like to receive such information, please tick the box.<br />
						�ڭ̷|���դU�w���H�W���|��������T�C�p�դU�P�N�A�Щ���W��W�縹�C</td>
				</tr>
			</table>
<%} %>
		<br /></td>
	</tr>
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr >
		<td colspan="6" height="25">
			<table width="686" border="0" align="center" cellpadding="0" cellspacing="0" <%if(printAction){ %>style="font-size:180%; "<%} %>>
				<tr>
					<td class="style1"><font color="black"><strong>Other Information ��L���</strong></font></td>
				</tr>
			</table>
		</td>
	</tr>
	
	<tr>
		<td height="20" colspan="5">&nbsp;</td>
	</tr>
	<tr>
		<td height="20" colspan="5">
<%if(printAction){ 
	ArrayList recordImtInfo = AdmissionDB.getUnselectedImtInfo(admissionID); 
	if(recordImtInfo.size() >0){
 %>
		<table <%if(printAction){ %>style="font-size:180%; "<%} %>>
			<tr><td class="style1"><font color="black"><strong>Below are the Important Information that patient has not read:</strong></td></tr>
			<% 
			Map<String, String> infoMap	 = new HashMap<String, String>();
			infoMap.put("76","label.patient.admission");
			infoMap.put("390","label.patients.charter");
			infoMap.put("391","label.why.vegetarian.diet");
			infoMap.put("75","label.health.care.advisory");
			infoMap.put("392","label.daily.room.rate");
			/* infoMap.put("394","label.pre-anaesthesia.questionnaire"); */
//20181102 Arran fixed mis-match			
			infoMap.put("118","label.renovation.letter");
			
			   if(recordImtInfo.size() >0){
				   for(int i=0;i<recordImtInfo.size();i++){
				   	ReportableListObject row1 = (ReportableListObject) recordImtInfo.get(i);%>	
				   	<tr><td><%=MessageResources.getMessageEnglish(infoMap.get(row1.getValue(0))) %>  <%=MessageResources.getMessageTraditionalChinese( infoMap.get(row1.getValue(0)))%></td></tr>
				   				   
			<% 		}
				}%>
		</table>
<%
	}
 } %>
			<ul id="browser" class="filetree">
<% if(!printAction){ %>
<jsp:include page="../registration/important_information.jsp" flush="false">
	<jsp:param name="source" value="registration" />
</jsp:include>
<%} %>
<jsp:include page="admission_document.jsp" flush="false">
	<jsp:param name="admissionID" value="<%=admissionID %>" />
</jsp:include>
			</ul>
		</td>
	</tr>
</table>
<br /><p /><br />
<% if(!printAction){ %>
<table width="650" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>Signature of  *Patient / Responsible Party:</td><td>Date:</td>
	</tr>
	<tr>
		<td height="2">&nbsp;</td>
	</tr>
	<tr>
		<td>�f�H�έt�d�Hñ�p			  			___________________________________</td><td>��� ________________________</td>
	</tr>
	<tr>
		<td height="2">&nbsp;</td>
	</tr>
	<tr>
		<td>Name of Patient / Responsible Party:</td><td>Relationship:</td>
	</tr>
	<tr>
		<td height="2">&nbsp;</td>
	</tr>
	<tr>
		<td>�f�H�έt�d�H�m�W 						_____________________________________</td><td>���Y ________________________</td>
	</tr>
</table>
<br /><br /><br />
<table width="650" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>If there is any inconsistency or ambiguity between the English version and the Chinese version, the English version shall prevail.<br />���^�媩���p���[���A���H�^�媩�����ǡC</td>
	</tr>
</table>
<%} %>
</DIV>

</DIV></DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
<%} %>
</html:html>