<%@ page import="java.util.*"%>
<%@ page import="org.apache.struts.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
if (session.getAttribute(Globals.LOCALE_KEY) == null) {
	// set default language
	session.setAttribute( Globals.LOCALE_KEY, Locale.US );
}
String sortColumn = request.getParameter("sortColumn");
String title = request.getParameter("title");
boolean nocache = !"N".equals(request.getParameter("nocache"));

// update session
UserBean userBean = new UserBean(request);
SsoUserDB.updateSessionID(request.getSession().getId(), userBean);
%>
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
<head>
<meta http-equiv="X-UA-Compatible" content="IE=9">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<%if (nocache) { %><meta http-equiv="Cache-Control" content="no-cache"><% } %>
<%if (title != null && title.length() > 0) { %>
	<title><%=title %></title>
<%} else { %>
	<title>Hospital Intranet</title>
<%} %>

<!-- style sheet -->
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/flora.datepicker.css" />" />
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/jquery.wysiwyg.css" />" media="screen" />
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/jquery.impromptu.css" />" media="screen" />
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/ui.tabs.css" />" />
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/jquery.tabs.css" />" />
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/colorpicker.css" />" media="screen" />
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/jquery.cleditor.css" />" media="screen"/>
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/jquery.jscrollpane.css" />" media="all"/>
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/fancybox/jquery.fancybox-1.3.4.css" />" />
<!-- jqgrid -->
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/jqgrid/ui.jqgrid.css" />" />
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/jqgrid/ui.multiselect.css" />" />
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/jqgrid/searchFilter.css" />" />
<!-- for chart -->
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/canvaschart.css" />" />
<!-- for modal -->
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/jquery.simplemodal.css" />" />
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/thickbox.css" />" />
<!-- for accordion, tabs, dialog, framework icons, processbar, highlight -->
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/jquery-ui-1.7.2.custom.css" />" />
<!-- for tree -->
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/dhtmlxtree.css" />" />
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/jquery.treeview.css" />" />
<!-- for general use -->
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/style.css" />" />
<link rel="shortcut icon" href="../images/portal.ico" type="image/x-icon" />
<!-- javascript -->
<script type="text/javascript" src="<html:rewrite page="/js/jquery-1.5.1.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.metadata.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.tablesorter.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.color.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.wysiwyg.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.validate.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.easing.1.3.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery-impromptu.2.3.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.MultiFile.pack.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.blockUI.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.corner.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/ajaxfileupload.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/ui.core.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/ui.datepicker.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/ui.tabs.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/colorpicker.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.cleditor.min.js"/>" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.maxlength.hkah.min.js"/>" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.hyjack.select.min.js"/>" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.progressbar.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/spin.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.fancybox-1.3.4.pack.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.placeholder.min.js"/>" /></script>

<!-- for chart -->
<script type="text/javascript" src="<html:rewrite page="/js/jgcharts.pack.js" />" /></script>
<!--[if IE]><script type="text/javascript" src="<html:rewrite page="/js/excanvas.js" />"></script><![endif]-->
<script type="text/javascript" src="<html:rewrite page="/js/jquery.flot.js" />"></script>
<!-- for poster -->
<script type="text/javascript" src="<html:rewrite page="/js/jquery-easing-1.3.pack.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery-easing-compatibility.1.2.pack.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/coda-slider.1.1.1.pack.js" />" /></script>
<!-- for vibrate -->
<script type="text/javascript" src="<html:rewrite page="/js/jquery.vibrate.js" />" /></script>
<!-- ajax portal -->
<!-- <script type="text/javascript" src="<html:rewrite page="/js/jquery.ui.js" />" /></script> -->
<!-- for modal -->
<script type="text/javascript" src="<html:rewrite page="/js/thickbox.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.simplemodal.js" />" /></script>
<!-- for portal framework -->
<script type="text/javascript" src="<html:rewrite page="/js/jquery-ui-1.7.2.custom.min.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery-ui-1.8.12.custom.min.js" />" /></script>
<!-- for client side date display -->
<script type="text/javascript" src="<html:rewrite page="/js/jquery.prettydate.js" />" /></script>
<!-- for play video -->
<script type="text/javascript" src="<html:rewrite page="/js/ufo.js" />" /></script>
<!-- for tree view -->
<script type="text/javascript" src="<html:rewrite page="/js/dhtmlxcommon.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/dhtmlxtree.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/dhtmlxtree_start.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.treeview.pack.js" />" /></script>
<!-- for general use -->
<script type="text/javascript" src="<html:rewrite page="/js/hkah.js" />" /></script>
<!-- for tooltip use -->
<script type="text/javascript" src="<html:rewrite page="/js/jquery.qtip-1.0.0-rc3.min.js"/>" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.supertextarea.min.js"/>" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.imagePreview.js" />" /></script>
<!-- for scrolling text use -->
<script type="text/javascript" src="<html:rewrite page="/js/jquery.Scroller-1.0.min.js"/>" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.Scroller-1.0.src.js"/>" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.dump.js"/>" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.jscrollpane.js"/>" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.mousewheel.js"/>" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/mwheelIntent.js"/>" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.exposure.min.js"/>" /></script>
<!-- jqgrid -->
<script type="text/javascript" src="<html:rewrite page="/js/jqgrid/i18n/grid.locale-en.js"/>" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqgrid/jquery.jqGrid.min.js"/>" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqgrid/ui.multiselect.js"/>" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqgrid/jquery.tablednd.js"/>" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqgrid/jquery.searchFilter.js"/>" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqgrid/jquery.contextmenu.js"/>" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqgrid/grid.setcolumns.js"/>" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqgrid/grid.postext.js"/>" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jqgrid/grid.addons.js"/>" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/swfobject.js"/>" /></script>

<script type="text/javascript">


<%
boolean issortable = !"N".equals(request.getParameter("issortable"));

//decide whether table is sortable, default is true(created by cherry)
%>
	function showLoadingBox(target, time, top) {
		if($('div#loadingBox').length  <= 0) {
			var imgPath;
			if(window.location.href.indexOf('crm/portal') > -1) {
				imgPath = "../../images/";
			}
			else {
				imgPath = "../images/";
			}
			$('<div id="loadingBox" class="loading">'+'<strong>Loading...</strong><br/><img src="'+imgPath+'loadingAnimation.gif"/></div>')
				.appendTo(target);
		}

		$(target).find('div#loadingBox').css('left', $(window).width()/2-$('div#loadingBox').width()/2);//$(target).position().left
		if (top) {
			$(target).find('div#loadingBox').css('top', top);//(top?top:$(target).position().top)
		}
		else {
			$(target).find('div#loadingBox').css('top', $(window).height()/2-$('div#loadingBox').height()/2);//(top?top:$(target).position().top)
		}
		$(target).find('div#loadingBox').fadeIn(time);
	}

	function hideLoadingBox(target, time) {
		$(target).find('div#loadingBox').fadeOut(time);
	}

	function showOverLay(target, zindex) {
		if (!zindex) {
			zindex = '11';
		}
		if($('div#overlay').length  <= 0) {
			$('<div id="overlay" class="ui-widget-overlay" style="display:none; z-index:'+zindex+';"></div>')
				.appendTo(target);
		}

		$(target).find('div#overlay').css('height', $(document).height());
		$(target).find('div#overlay').css('width', $(document).width());
		$(target).find('div#overlay').css('display', '');
	}

	function hideOverLay(target) {
		$(target).find('div#overlay').css('display', 'none');
	}

	$(document).ready(function() {
		var defaultText = 'Write a comment...';
<%	if (issortable == false) { %>
if ($('table').tablesorter) {
		$('table').tablesorter({ headers: { <%=sortColumn%>: { sorter: false} } });
}		
<%	} else if (issortable == true) { %>
if ($('table').tablesorter) {
		$("table").tablesorter({<%if (sortColumn != null) { %>sortList: [[<%=sortColumn %>,0]], <%} %>widgets: ['zebra']});
}		
<%	} %>
if ($('#wysiwyg').wysiwyg) {
		$('#wysiwyg').wysiwyg();
}		
if ($('#wysiwyg1').wysiwyg) {
		$('#wysiwyg1').wysiwyg();
}		
if ($('#wysiwyg2').wysiwyg) {
		$('#wysiwyg2').wysiwyg();
}	
if ($('#cleditor').cleditor) {
		$('#cleditor').cleditor();
}
if ($('#browser').treeview) {
		$("#browser").treeview({animated: "fast"});
}		
		$('input').filter('.datepickerfield').datepicker({ showOn: 'button', buttonImageOnly: true, buttonImage: "../images/calendar.jpg" });
		$('input').filter('.touppercase').keyup(function(){ this.value = this.value.toUpperCase(); });
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
			return false;
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
			return false;
		});
		$(".pane .btn-click").click(function(){
			$(this).parents(".pane").animate({ backgroundColor: "#fff568" }, "fast")
			.animate({ backgroundColor: "#F9F3F7" }, "slow")
			return false;
		});
	});

	function deleteAction() { submitAction('delete', 1); }

	function deleteAction2() { submitAction('delete', 3); }

	function goToCasAuth() { window.parent.location.href = "../casAuth.jsp"; }

	function clickIE4(){ if (event.button==2){ return false; } }
	function clickNS4(e){ if (document.layers || document.getElementById&&!document.all){ if (e.which==2||e.which==3){ return false; } } } if (document.layers){ document.captureEvents(Event.MOUSEDOWN); document.onmousedown=clickNS4; } else if (document.all&&!document.getElementById){ document.onmousedown=clickIE4; } document.oncontextmenu=new Function("return false")
-->
</script>
</head>