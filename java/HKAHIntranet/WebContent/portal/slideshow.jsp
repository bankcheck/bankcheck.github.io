<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="org.springframework.util.StringUtils"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%!
	public String[] getImage() {
		String[] imageName = null;
		try {
			File directory = new File(ConstantsServerSide.UPLOAD_WEB_FOLDER + "/Photo Gallery");
			String[] children = directory.list();
			if (children.length > 0) {
				imageName = new String[children.length];
				for (int i = 0; i < children.length; i++) {
					if (children[i] != null && (children[i].toUpperCase().indexOf(".SWF") > 0 ||children[i].toUpperCase().indexOf(".JPG") > 0 || children[i].toUpperCase().indexOf(".GIF") > 0)) {
						imageName[i] = children[i];
					}
				}
			}
		} catch (Exception e) {
		}
		return imageName;
	}

	private static Properties readProperties(String fileName) {
		try {
			Properties properties = new Properties();
			properties.load(new FileInputStream(new File(fileName)));
			return properties;
		} catch (Exception e) {
			return null;
		}
	}

	public static String getValue(Properties properties, String key) {
		String value = null;
		try {
			value = properties.getProperty(key);
		} catch (Exception e) {
		}

		if (value == null) {
			value = ConstantsVariable.EMPTY_VALUE;
		}
		return value;
	}

	public static LinkedHashMap<String, String> getOrderedPropertiesMap(File file, String keySuffix) {
		if (file == null) {
			return null;
		}

		LinkedHashMap<String, String> map = new LinkedHashMap<String, String>();
		BufferedReader br = null;
		try {
			br = new BufferedReader(new FileReader(file));

		    String strLine;
		    String[] keyValuePair;
		    String key = null;
		    String value = null;
		    while ((strLine = br.readLine()) != null)   {

		      keyValuePair = strLine.split("=", 2);
		      if (keyValuePair != null && keyValuePair.length == 2) {
		    	  key = keyValuePair[0];
		    	  value = keyValuePair[1];
		    	  if (key != null && StringUtils.endsWithIgnoreCase(key.trim(), keySuffix)) {
		    	  	map.put(key.trim().replace(keySuffix, "").toLowerCase(), value);
		    	  }
		      }
		    }

		} catch (Exception e) {
		} finally {
			if (br != null) {
				try {
			    	br.close();
				} catch (Exception e) {
				}
			}
		}
		return map;
	}
%>
<link rel="stylesheet" href="<html:rewrite page="/css/galleriffic-portal.css" />" type="text/css" />
<!--[if IE]><link rel="stylesheet" href="<html:rewrite page="/css/galleriffic-portal-ie.css" />" type="text/css" /><![endif]-->
	<div class="slideshow-page">
		<div id="galleriffic-content" class="galleriffic-content">
			<div class="slideshow-container">
				<div id="caption" class="caption-container"></div>
				<div id="thumbs" class="navigation">
			    	<ul class="thumbs noscript">
<%
	boolean noImage = false;

	// ---------------
	// display image by the order of the item in description text file
	// ---------------
	LinkedHashMap<String, String> orderedHeadlineMap = new LinkedHashMap<String, String>();
	LinkedHashMap<String, String> orderedCaptionMap = new LinkedHashMap<String, String>();
	String headlineSuffix = ".headline";
	String captionSuffix = ".caption";

	// read the description file
	String descriptionFilePath = null;
	if (ConstantsServerSide.SITE_CODE_HKAH.equalsIgnoreCase(ConstantsServerSide.SITE_CODE)) {
		descriptionFilePath = ConstantsServerSide.UPLOAD_WEB_FOLDER + "/Photo Gallery/description.txt";
	} else if (ConstantsServerSide.SITE_CODE_TWAH.equalsIgnoreCase(ConstantsServerSide.SITE_CODE)) {
		descriptionFilePath = "\\\\192.168.0.20\\document\\Upload\\Photo Gallery\\description.txt";
	} else {
		// default
		descriptionFilePath = ConstantsServerSide.UPLOAD_WEB_FOLDER + "/Photo Gallery/description.txt";
	}

	File file = new File(descriptionFilePath);

	orderedHeadlineMap = getOrderedPropertiesMap(file, headlineSuffix);
	orderedCaptionMap = getOrderedPropertiesMap(file, captionSuffix);

	String[] galleryImage = getImage();

	Set<String> keys = null;
	Iterator<String> itr = null;
	String imageName = null;

	// create a set that contains names of existing images
	Map<String, String> galleryNameMap = new HashMap<String, String>();
	if (galleryImage != null) {
		for (String name : galleryImage) {
			if (name != null) {
				galleryNameMap.put(name.toLowerCase(), name);
			}
		}
	}
	Set<String> displayGallerySet = new LinkedHashSet<String>();

	// get an ordered gallery name set from properties file
	keys = orderedHeadlineMap.keySet();
	itr = keys.iterator();
	while (itr.hasNext()) {
		imageName = itr.next();
		if (imageName != null && galleryNameMap.containsKey(imageName.toLowerCase())) {
			displayGallerySet.add(galleryNameMap.get(imageName.toLowerCase()));
		}
	}
	// append gallery does not included in properties file
	itr = galleryNameMap.values().iterator();
	while (itr.hasNext()) {
		imageName = itr.next();
		if (imageName != null && !displayGallerySet.contains(imageName)) {
			// displayGallerySet.add(imageName.toLowerCase());
			displayGallerySet.add(imageName);
		}
	}

	// add images to player
	int i = 1;
	if (displayGallerySet != null && !displayGallerySet.isEmpty()) {
		int digit = 0;
		try {
			digit = Integer.toString(orderedHeadlineMap.size()).length();
		} catch (Exception e) {
		}
		String seqNum = null;

		itr = displayGallerySet.iterator();
		String galleryImageName = null;
		String swfName = null;
		boolean isSWF = false;

		while (itr.hasNext()) {
			galleryImageName = (String) itr.next();
			isSWF = false;
			if("SWF".equals(galleryImageName.toUpperCase().substring(0,3) )){
				isSWF = true;
				swfName = galleryImageName.substring(4,(galleryImageName.length()-4))+".swf";
			}

			// caution: the order of photo seq number start from left, i.e. order of 2 is less than 10 !!
			seqNum = org.apache.commons.lang.StringUtils.leftPad(String.valueOf(i), digit, "0");
			%>
				        <li>
				            <a class="thumb" name="photo_<%=seqNum %>" href="/upload/Photo%20Gallery/<%=galleryImageName %>" title="<%=galleryImageName %>">
				                <img src="/upload/Photo%20Gallery/<%=galleryImageName %>" alt="<%=galleryImageName %>" />
				            </a>


				            <div class="caption">
<% String headline = orderedHeadlineMap.get(galleryImageName.toLowerCase()) == null ? "" : orderedHeadlineMap.get(galleryImageName.toLowerCase()); %>
				            	<span class="headline-text"><%=headline %></span>
				            	<span class="caption-text"><%=orderedCaptionMap.get(galleryImageName.toLowerCase()) == null ? "" : orderedCaptionMap.get(galleryImageName.toLowerCase()) %></span>
				            	<%if(isSWF){ %>
					            	<div style="position:relative;top:50px;">
					            	<%if (ConstantsServerSide.SITE_CODE_TWAH.equalsIgnoreCase(ConstantsServerSide.SITE_CODE)) { %>
						            	<a  href="http://192.168.0.20/swf/Ground%20Breaking%20(21).swf?keepThis=true&TB_iframe=true&height=400&width=500" class="thickbox button" alt="1">
					            	<%}else{ %>
						            	<a  href="http://www-server/swf/<%=swfName%>?keepThis=true&TB_iframe=true&height=400&width=500" class="thickbox button" alt="1">
									<%} %>
						            	<span>Watch the Video</span>
						            	</a>
					            	</div>
					            <%} %>
					            <div class="download">
					            	<a href="/upload/Photo%20Gallery/<%=galleryImageName %>" class="fancybox" title="<%=headline %>"><img src="<html:rewrite page="/images/gallery/full_size.gif" />" alt="<bean:message key="button.fullSize" />" /></a>
								</div>
				            </div>
				        </li>
			<%
			i++;
		}
	} else {
		// no image to display
		noImage = true;
	}
%>
			    	</ul>
				</div>

				<div id="slideshow" class="slideshow"></div>
				<div id="loading" class="loader"></div>
			</div>
			<div id="controls" class="controls"></div>
			<div style="clear: both;"></div>
		</div>
	</div>
<% if (!noImage) { %>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.galleriffic.js" />" /></script>
<script type="text/javascript" src="<html:rewrite page="/js/jquery.opacityrollover.js" />" /></script>
<!-- We only want the thunbnails to display when javascript is disabled -->
<script type="text/javascript">
	document.write('<style>.noscript { display: none; }</style>');
</script>
<script language="javascript">
	$(document).ready(function(){
			// We only want these styles applied when javascript is enabled
			// $('div.navigation').css({'width' : '300px', 'float' : 'left'});
			$('div.galleriffic-content').css('display', 'block');

			// Initially set opacity on thumbs and add
			// additional styling for hover effect on thumbs
			var onMouseOutOpacity = 0.67;
			$('#thumbs ul.thumbs li').opacityrollover({
				mouseOutOpacity:   onMouseOutOpacity,
				mouseOverOpacity:  1.0,
				fadeSpeed:         'fast',
				exemptionSelector: '.selected'
			});

		    var gallery = $('#thumbs').galleriffic({
		        delay:                     5000, // in milliseconds
		        numThumbs:                 4, // The number of thumbnails to show page
		        preloadAhead:              10, // Set to -1 to preload all images
		        enableTopPager:            false,
		        enableBottomPager:         true,
		        maxPagesToShow:            5,  // The maximum number of pages to display in either the top or bottom pager
		        imageMaxWidth:			   400,	// The maximum width of slideshow picture, set to 0 to unlimit the width
		        imageMaxHeight:			   300,	// The maximum height of slideshow picture, set to 0 to unlimit the height
		        imageContainerSel:         '#slideshow', // The CSS selector for the element within which the main slideshow image should be rendered
		        controlsContainerSel:      '#controls', // The CSS selector for the element within which the slideshow controls should be rendered
		        captionContainerSel:       '#caption', // The CSS selector for the element within which the captions should be rendered
		        loadingContainerSel:       '#loading', // The CSS selector for the element within which should be shown when an image is loading
		        renderSSControls:          true, // Specifies whether the slideshow's Play and Pause links should be rendered
		        renderNavControls:         true, // Specifies whether the slideshow's Next and Previous links should be rendered
				playLinkText:              '<img src="../images/gallery/play.gif" />',
				playLinkTitle:             '<%=MessageResources.getMessage(session, "button.playSlideshow") %>',
				pauseLinkText:             '<img src="../images/gallery/pause.gif" />',
				pauseLinkTitle:            '<%=MessageResources.getMessage(session, "button.pauseSlideshow") %>',
				prevLinkText:              '<img src="../images/gallery/previous.gif" />',
				prevLinkTitle:             '<%=MessageResources.getMessage(session, "button.previous") %>',
				nextLinkText:              '<img src="../images/gallery/next.gif" />',
				nextLinkTitle:             '<%=MessageResources.getMessage(session, "button.next") %>',
		        nextPageLinkText:          '<%=MessageResources.getMessage(session, "button.nextPage") %> &rsaquo;',
		        prevPageLinkText:          '&lsaquo; <%=MessageResources.getMessage(session, "button.prevPage") %>',
		        enableHistory:             false, // Specifies whether the url's hash and the browser's history cache should update when the current slideshow image changes
		        enableKeyboardNavigation:  true, // Specifies whether keyboard navigation is enabled
		        autoStart:                 true, // Specifies whether the slideshow should be playing or paused when the page first loads
		        syncTransitions:           true, // Specifies whether the out and in transitions occur simultaneously or distinctly
		        defaultTransitionDuration: 900, // If using the default transitions, specifies the duration of the transitions
				onSlideChange:             function(prevIndex, nextIndex) {
					// 'this' refers to the gallery, which is an extension of $('#thumbs')
					this.find('ul.thumbs').children()
						.eq(prevIndex).fadeTo('fast', onMouseOutOpacity).end()
						.eq(nextIndex).fadeTo('fast', 1.0);
				},
				onTransitionIn:   function(slide, caption, isSync) {
	                slide.fadeTo(this.getDefaultTransitionDuration(isSync), 1.0);
	                if (caption){
	                    caption.fadeTo(this.getDefaultTransitionDuration(isSync), 1.0);

	                    $('a.fancybox').fancybox({
	                    	'titlePosition' 	: 'over',
							'titleFormat'		: function(title, currentArray, currentIndex, currentOpts) {
													return '<span id="fancybox-title-over">' + title + '</span>';
				        						  }
	                    });
	                }
	            },
		        onPageTransitionOut:       function(callback) {
						this.fadeTo('fast', 0.0, callback);
					},
				onPageTransitionIn:        function() {
						this.fadeTo('fast', 1.0);
					},
				onPageTransitionOut:	   undefined,
				onPageTransitionIn:		   undefined,
		        onImageAdded:              undefined, // accepts a delegate like such: function(imageData, $li) { ... }
		        onImageRemoved:            undefined  // accepts a delegate like such: function(imageData, $li) { ... }
		    });
	});
</script>
		<% } else { %>
<style>
	div.slideshow-page { display: none; }
</style>
		<% } %>