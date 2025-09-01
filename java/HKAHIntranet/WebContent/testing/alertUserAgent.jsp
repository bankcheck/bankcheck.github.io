<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Alert User Agent string</title>
</head>
<body>
<script type="text/javascript" language="javascript">
	isIE();
	function isIE() {
		  var myNav = navigator.userAgent.toLowerCase();
		  var ret = (myNav.indexOf('msie') != -1) ? parseInt(myNav.split('msie')[1]) : false;
		  alert('userAgent='+myNav+'\n\nIE ver='+ret);
		  return ret;
	}
</script>
</body>
</html>