<script type="text/javascript">
<!--//

<%
String sortColumn = request.getParameter("sortColumn");
boolean nocache = !"N".equals(request.getParameter("nocache"));
boolean issortable = !"N".equals(request.getParameter("issortable"));

//decide whether table is sortable, default is true(created by cherry)
%>
	$(document).ready(function() {
		var defaultText = 'Write a comment...';
<%	if (issortable == false) { %>
		$('table').tablesorter({ headers: { <%=sortColumn%>: { sorter: false} } });
<%	} else if (issortable == true) { %>
		$("table").tablesorter({<%if (sortColumn != null) { %>sortList: [[<%=sortColumn %>,0]], <%} %>widgets: ['zebra']});
<%	} %>
		$('#wysiwyg').wysiwyg();
		$('#wysiwyg1').wysiwyg();
		$('#wysiwyg2').wysiwyg();
		
		$("#browser").treeview({animated: "fast"});
		$('input').filter('.datepickerfield').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });
		$('textarea').filter('.comment').val(defaultText)
			.focus(function() {
				if ( this.value == defaultText ) this.value = '';
			}).blur(function() {
				if ( !$.trim( this.value ) ) this.value = defaultText;
			});
		$(".pane .btn-delete").click(function(){
			$(this).parents(".pane").animate({ backgroundColor: "#fbc7c7" }, "fast")
			.animate({ backgroundColor: "#F9F3F7" }, "slow")
			$.prompt('<bean:message key="message.record.delete" />!',{
				buttons: { Ok: true, Cancel: false },
				callback: function(v,m,f){
					if (v){
						submit: deleteAction()
						return true;
					} else {
						return false;
					}
				},
				prefix:'cleanblue'
			});
		});
		$(".pane .btn-delete2").click(function(){
			$(this).parents(".pane").animate({ backgroundColor: "#fbc7c7" }, "fast")
			.animate({ backgroundColor: "#F9F3F7" }, "slow")
			$.prompt('<bean:message key="message.record.delete" />!',{
				buttons: { Ok: true, Cancel: false },
				callback: function(v,m,f){
					if (v){
						submit: deleteAction2()
						return true;
					} else {
						return false;
					}
				},
				prefix:'cleanblue'
			});
		});
		$(".pane .btn-click").click(function(){
			$(this).parents(".pane").animate({ backgroundColor: "#fff568" }, "fast")
			.animate({ backgroundColor: "#F9F3F7" }, "slow")
			return false;
		});
	});
//-->
</script>