<%@ page import="java.io.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="sun.misc.BASE64Decoder"%>
<%@ page import="java.awt.image.BufferedImage"%>
<%@ page import="javax.imageio.ImageIO"%>

<%@ page language="java" contentType="text/html; charset=utf-8"
	pageEncoding="utf-8"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta http-equiv="Pragma" content="no-cache">
<meta http-equiv="Cache-Control" content="no-cache">
<meta http-equiv="Expires" content="0">

<title>Doctor List</title>
<style>
body{
	background-color: rgb(249, 243, 247);
	text-align: center;
	color: rgb(153, 21, 87);
}
h1{
	text-decoration:underline;
}
table{
	margin-left:auto; 
    margin-right:auto;
}
input[type=button]{
	color: rgb(153, 21, 87);
    background-color: rgb(237, 180, 208);
    float: left;
    border: none;
    outline: none;
    cursor: pointer;
    padding: 14px 16px;
    transition: 0.3s;
    border-radius: 12px;
}
</style>
<script>
	function submitAction(dept,name) {
		document.docList.deptCode.value = dept;
		document.docList.dept.value = name;
		document.getElementById('docList').action = 'docList_jasper.jsp';
		document.docList.submit();
	}
</script>
</head>
<body>
	<form name="docList" id="docList" action="" method="post">
		<div id = "button">
			<h1>Doctor Photo by Ward</h1>
			<h3>Please select the department to print doctor list</h3>
			<table>
				<tr>
					<td><input type="button" value="CCIC"
						onclick="return submitAction('200','CCIC');" /></td>
					<td><input type="button" value="CPLab"
						onclick="return submitAction('210','CPLab');" /></td>
					<td><input type="button" value="Ped"
						onclick="return submitAction('130','Ped');" /></td>
					<td><input type="button" value="SCU"
						onclick="return submitAction('160','SCU');" /></td>
					<td><input type="button" value="U200"
						onclick="return submitAction('U200','U200');" /></td>
					<td><input type="button" value="U300"
						onclick="return submitAction('U300','U300');" /></td>
					<td><input type="button" value="U500"
						onclick="return submitAction('U500','U500');" /></td>
					<td><input type="button" value="ICU"
						onclick="return submitAction('100','ICU');" /></td>
					<td><input type="button" value="OB"
						onclick="return submitAction('120','OB');" /></td>
					<td><input type="button" value="OT"
						onclick="return submitAction('360','OT');" /></td>
					<td><input type="button" value="HD"
						onclick="return submitAction('330','HD');" /></td>
					<td><input type="button" value="Endo and SSU"
						onclick="return submitAction('365-362','Endo and SSU');" /></td>
				</tr>
			</table>
			<input type="hidden" id="deptCode" name="deptCode" value="" />
			<input type="hidden" id="dept" name="dept" value="" />
			</div>
	</form>

</body>
</html>