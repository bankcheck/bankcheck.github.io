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
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp"/>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<table width="800" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td>&nbsp;</td>
	</tr>
	<tr>
		<td align="left"><img src="../images/logo_hkah.gif" border="0" width="261" height="113" /></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
</table>
<form name="form1" enctype="multipart/form-data" action="admission.jsp" method="post">
	<table width="800" border="1" cellpadding="0" cellspacing="0">
	  <tr>
			<td colspan="5" height="25" bgcolor="#76923C">
				<table width="686" border="0" cellpadding="0" cellspacing="0">
				  <tr>
					<td class="infoSubTitle2"><font color="white"><strong>PFS information</strong></font></td>
				  </tr>
				 </table>
			</td>
		</tr>
	<tr>
		<table width="800" border="0" cellpadding="0" cellspacing="0"  style="padding:5px;">
					<tr>
						<td height="20" valign="top"><b>Employee No.:</b> </td>
						<td height="20" valign="top"></td>
						<td width="002">&nbsp;</td>
						<td height="20" valign="top"><b>Today</b> </td>
						<td height="20" valign="top"></td>
					</tr>
		</table>
	</tr>
	<tr>
		<td>
			<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">
				<tr>
					<td colspan="5" height="25" bgcolor="#CCCCCC">
						<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
								<td class="style1"><font color="white"><strong>Personal Particulars</strong></font></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Surname:</b> </td>
					<td height="20" valign="top"></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Name:</b> </td>
					<td height="20" valign="top"></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Called Name:</b> </td>
					<td height="20" valign="top"></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Age:</b> </td>
					<td height="20" valign="top"></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b></b> </td>
					<td height="20" valign="top"></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>HK ID no.:</b> </td>
					<td height="20" valign="top"></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Address:</b> </td>
					<td height="20" valign="top"></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Birthdate:</b> </td>
					<td height="20" valign="top"></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>City:</b> </td>
					<td height="20" valign="top"></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Marital Status:</b> </td>
					<td height="20" valign="top"></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Phone no.:</b> </td>
					<td height="20" valign="top"></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Gender (M/F):</b> </td>
					<td height="20" valign="top"></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Pager/Mobile:</b> </td>
					<td height="20" valign="top"></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Hospital Patient no.:</b> </td>
					<td height="20" valign="top"></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Religion 宗教:</b> </td>
					<td height="20" valign="top"></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Nationality:</b> </td>
					<td height="20" valign="top"></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Emp Visa Expire Date:</b> </td>
					<td height="20" valign="top"></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Religion:</b> </td>
					<td height="20" valign="top"></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Midwife Practising Expire Date:</b> </td>
					<td height="20" valign="top"></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Qualification:</b> </td>
					<td height="20" valign="top"></td>
				</tr>	
						
				<tr>
					<td colspan="5" height="25" bgcolor="#CCCCCC">
						<table width="686" border="0" align="center" cellpadding="0" cellspacing="0">
							<tr>
								<td class="style1"><font color="white"><strong>Employment Information</strong></font></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Status:</b> </td>
					<td height="20" valign="top"></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Name on ID:</b> </td>
					<td height="20" valign="top"></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Department:</b> </td>
					<td height="20" valign="top"></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Title on ID:</b> </td>
					<td height="20" valign="top"></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Position:</b> </td>
					<td height="20" valign="top"></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Dept on ID:</b> </td>
					<td height="20" valign="top"></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Hire Date:</b> </td>
					<td height="20" valign="top" colspan="4"></td>
				</tr>
				<tr>
					<td height="20" valign="top" colspan="5"></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Increment Date:</b> </td>
					<td height="20" valign="top"></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Health Benefits (Y/N/L):</b> </td>
					<td height="20" valign="top"></td>
				</tr>		
				<tr>
					<td height="20" valign="top"><b>HK Registered:</b> </td>
					<td height="20" valign="top"></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Pfund Type:</b> </td>
					<td height="20" valign=z"top"></td>
				</tr>		
				<tr>
					<td height="20" valign="top"><b>Practising Expire Date:</b> </td>
					<td height="20" valign="top"></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Pfund Join Date:</b> </td>
					<td height="20" valign="top"></td>
				</tr>
				<tr>
					<td height="20" valign="top" colspan="5"></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Old-Emp no.:</b></td>
					<td height="20" valign="top"></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Category (A/N/O)</b></td>
					<td height="20" valign="top"></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>ID Issue Date:</b></td>
					<td height="20" valign="top"></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>FTE count:</b></td>
					<td height="20" valign="top"></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Termination Date:</b></td>
					<td height="20" valign="top"></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b>Badge Color:</b></td>
					<td height="20" valign="top"></td>
				</tr>
				<tr>
					<td height="20" valign="top"><b>Year of Service:</b></td>
					<td height="20" valign="top"></td>
					<td width="002">&nbsp;</td>
					<td height="20" valign="top"><b></b></td>
					<td height="20" valign="top"></td>
				</tr>	
				<tr>
					<td height="20" valign="top" colspan="5"></td>
				</tr>
																																						
		</table>

	</form>
  </DIV></DIV></DIV>
</body>
</html:html>