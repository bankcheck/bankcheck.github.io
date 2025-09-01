<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<% if (ConstantsServerSide.isHKAH()) { %>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr><td class="title">Clinical Forms <img src="../images/title_arrow.gif"></td></tr>
	<tr><td height="2" bgcolor="#840010"></td></tr>
	<tr><td height="10"></td></tr>
</table>
<table border="1" style="width:100%">
<tr><th>Code</th><th>Form Name</th><th>Status</th><th>Date Revised</th></tr>
	<tr>
		<td>
		<a class="topstoryblue" onclick=" downloadFile('453', ''); return false;" href="javascript:void(0);">
		LSMC-MOA15
		</a>
		</td>
		<td>
		<a class="topstoryblue" onclick=" downloadFile('453', ''); return false;" href="javascript:void(0);">
		Lifestyle and Spiritual Affairs (LSA) Referral Form
		</a>
		</td>
		<td>e-form</td>
		<td>May-13</td>
	</tr>
	<tr>
		<td>
		<a class="topstoryblue" onclick=" downloadFile('553', ''); return false;" href="javascript:void(0);">
		NUAD-MLC08
		</a>
		</td>
		<td>
		<a class="topstoryblue" onclick=" downloadFile('553', ''); return false;" href="javascript:void(0);">
		Procedure Time Out Checklist
		</a>
		</td>
		<td>e-form</td>
		<td>Dec-15</td>
	</tr>
	<tr>
		<td>
		<a class="topstoryblue" onclick=" downloadFile('599', ''); return false;" href="javascript:void(0);">
		VPPS-MBA005
		</a>
		</td>
		<td>
		<a class="topstoryblue" onclick=" downloadFile('599', ''); return false;" href="javascript:void(0);">
		Financial Consent for Minor OPD Procedures
		</a>
		</td>
		<td>e-form</td>
		<td>Jul-13</td>
	</tr>	
</table>
<%    } %>