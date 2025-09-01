<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
</jsp:include>
<body>
</body>
<script type="text/javascript">
var url = "../documentManage/download.jsp";
var method = "post";
var inputs = "<input type='hidden' name='documentID' value='628'/>";
$('<form action="'+ url +'" method="'+ (method||'post') +'">'+inputs+'</form>')
.appendTo('body').submit().remove();
</script>
</html:html>
