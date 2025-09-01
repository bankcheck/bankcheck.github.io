<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>conn-twah-mssql</title>
</head>
<jsp:include page="../common/header.jsp"/>
<body>

<script>
$(document).ready(function() {
	getWRB();
});

function getWRB() {
	$.ajax({
		url: "http://160.100.2.142:8080/intranet/ui/ward_classCMB.jsp?callback=?",
		data: "Type=Ward&iOS=true",
		dataType: "jsonp",
		cache: false,
		success: function(values){
			$.dump(values);
		},
		error: function(x, s, e) {
			alert(x.status);
		}
	});
}


</script>
</body>
</html>
