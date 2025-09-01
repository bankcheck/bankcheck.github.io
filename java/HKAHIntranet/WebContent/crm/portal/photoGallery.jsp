<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%!
public String[] getImage() {
	String[] imageName = null;
	try {
		File directory = new File(ConstantsServerSide.UPLOAD_WEB_FOLDER + "/CRM/photo");
		String[] children = directory.list();
		if (children.length > 0) {
			imageName = new String[children.length];
			for (int i = 0; i < children.length; i++) {
				//if (children[i] != null && (children[i].toUpperCase().indexOf(".SWF") > 0 ||children[i].toUpperCase().indexOf(".JPG") > 0 || children[i].toUpperCase().indexOf(".GIF") > 0)) {
					if(children[i] != null && children[i].indexOf(".") > -1) {
						imageName[i] = children[i];
					}
				//}
			}
		}
	} catch (Exception e) {
	}
	return imageName;
}
%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<html:html xhtml="true" lang="true">
	<jsp:include page="header.jsp"/>
	<body>
<%
		String[] images = getImage();
%>
		<div id="main">
			<div class="panel">
				<ul id='images'>
	<%
				for(String image: images) {
					if(image != null) {
	%>
					<li><a href="/upload/CRM/photo/<%=image %>"></a><img src="/upload/CRM/photo/<%=image %>"/></li>
	<%
					}
				}
	%>
				</ul>
				<div id="controls"></div>
				<div class="clear"></div>
			</div>
			<div id="exposure"></div>			
			<div class="clear"></div>
		</div>
	</body>
</html:html>

<script>
	$(document).ready( function(){
		var gallery = $('#images');
		gallery.exposure({controlsTarget : '#controls',
			controls : { prevNext : true, pageNumbers : true, firstLast : false },
			visiblePages : 2,
			pageSize: 4,
			stretchToMaxSize: true,
			fixedContainerSize : true,
			autostartSlideshow: true,
			showExtraData: false,
			onThumb : function(thumb) {
				var li = thumb.parents('li');				
				var fadeTo = li.hasClass($.exposure.activeThumbClass) ? 1 : 0.3;
				
				thumb.height('75px');
				thumb.css({display : 'none', opacity : fadeTo}).stop().fadeIn(200);
				
				thumb.hover(function() { 
					thumb.fadeTo('fast',1); 
				}, function() { 
					li.not('.' + $.exposure.activeThumbClass).children('img').fadeTo('fast', 0.3); 
				});
			},
			onImage : function(image, imageData, thumb) {
				
				var radio = (330/image.height());
				image.height('320px');
				if (navigator.appName == 'Microsoft Internet Explorer') {
					image.width(image.width()*radio+'px')
				}
				
				$('.exposureWrapper').width(image.width()).height(image.height());
				$('.exposureTarget').height(image.height());
				var centeringMargin = ($('.exposureTarget').width()-image.width())/2;
				image.css('marginLeft', centeringMargin + 'px');
				// Fade out the previous image.
				image.siblings('.' + $.exposure.lastImageClass).stop().fadeOut(500, function() {
					$(this).remove();
				});
				
				// Fade in the current image.
				image.hide().stop().fadeIn(1000);

				// Fade in selected thumbnail (and fade out others).
				if (gallery.showThumbs && thumb && thumb.length) {
					thumb.parents('li').siblings().children('img.' + $.exposure.selectedImageClass).stop().fadeTo(200, 0.3, function() { $(this).removeClass($.exposure.selectedImageClass); });			
					thumb.fadeTo('fast', 1).addClass($.exposure.selectedImageClass);
				}
			},
			onPageChanged : function() {
				// Fade in thumbnails on current page.
				gallery.find('li.' + $.exposure.currentThumbClass).hide().stop().fadeIn('fast');
			}
		});
	});
</script>
