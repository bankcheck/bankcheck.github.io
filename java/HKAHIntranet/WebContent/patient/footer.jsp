<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<table style="width:100%">
	<tr><td>&nbsp;</td></tr>
	<tr>
		<td align="center">
			<button style="font-size:24px;" 
					class = 'ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only' 
					onclick="return backToMain();">
				<img src="../images/undo2.gif">&nbsp;Back to Home 回主頁
			</button>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>

<script>
function backToMain() {
	document.form1.action = "../patient/";
	hideLoadingBox();
	document.form1.submit();
}
</script>