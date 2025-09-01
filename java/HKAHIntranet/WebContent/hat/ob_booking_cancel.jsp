<%
String obbookingID = request.getParameter("obbookingID");
%>
<table>
	<tr>
		<td class="infoLabel" width="20%">Cancel Reason</td>
		<td class="infoData" width="80%">
			<select name="reason">
				<option value="Miscarriage">Miscarriage</option>
				<option value="Early Birth">Early Birth</option>
				<option vlaue="others">Others</option>
			</select>
		</td>
	</tr>
<!--
	<tr>
		<td class="infoLabel" width="20%">Attachment</td>
		<td class="infoData" width="80%" colspan="3">
			<input type="file" name="regForm" size="50" class="multi" maxlength="10">
		</td>
	</tr>
-->
	<tr>
		<td colspan="2">
			<button onclick="return submitAction('cancel', '1', '<%=obbookingID %>');" class="btn-click">Confirm Cancel</button>
			<button onclick="return submitAction('cancel', '0', '');" class="btn-click">Abort</button>
		</td>
	</tr>
</table>