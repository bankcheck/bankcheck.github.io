/*
 * Image preview script 
 * powered by jQuery (http://www.jquery.com)
 * 
 * written by Alen Grakalic (http://cssglobe.com)
 * 
 * for more info visit http://cssglobe.com/post/1695/easiest-tooltip-and-image-preview-using-jquery
 *
 * edited by Ricky Leung (Hong Kong Adventist Hospital)
 */
 
this.imagePreview = function(config){	
	/* CONFIG */
	xOffset = config.xOffset;
	yOffset = config.yOffset;
	
	width = config.width;
	height = config.height;
	
	// these 2 variable determine popup's distance from the cursor
	// you might want to adjust to get the right result
		
	/* END CONFIG */
	$("a.preview").hover(function(e){
		this.t = this.title;
		this.title = "";	
		$("#preview").remove();
		$("body").append("<div id='preview'><div id='ip-close'><img id='ip-close-img' src='../images/cross.jpg' /><span id='ip-title'>" + this.t + "</span></div><iframe id='ip.frame' style='width:" + width + "px; height:" + height + "px;' src='pdfPreview.jsp?imagePath=" + this.href + "&path=part'></iframe></div>");								 
		$("#preview")
			.css("position", "absolute")
			.css("top",(e.pageY - xOffset) + "px")
			.css("left", (e.pageX - yOffset) + "px")
			.css("width", width + "px")
			.css("height", height + "px")
			.fadeIn("fast");
		$("#ip-close")
			.css("background", "#CCFFFF");
		$("#ip-title")
			.css("font", "14px")
			.css("font-weight", "bold");
		$("#ip-close-img")
			.css("cursor", "pointer")
			.css("margin", "2px")
			.click(function(e){
				$("#preview").remove();
			});
    },
	function(){
		this.title = this.t;	
		//$("#preview").remove();
    });
	
	$("a.preview").click(function(e){
		return false;
	});
};