/**
 * jQuery Maxlength plugin
 * 
 * Modified by HKAH, 2011/12/27
 * Custom count non-ASCII character length
 * 
 * @version		$Id: jquery.maxlength.hkah.js,v 1.2 2011/12/28 01:05:32 ricky.leung Exp $
 * @package		jQuery maxlength 1.0.5
 * @copyright	Copyright (C) 2009 Emil Stjerneman / http://www.anon-design.se
 * @license		GNU/GPL, see LICENSE.txt
 */

(function($) 
{

	$.fn.maxlength = function(options)
	{
		var settings = jQuery.extend(
		{
			events:				      [], // Array of events to be triggerd
			maxCharacters:		  10, // Characters limit
			status:				      true, // True to show status indicator below the element
			statusClass:		    "status", // The class on the status div
			statusText:			    "character left", // The status text
			notificationClass:	"input-maxlength-reached",	// Will be added to the element when maxlength is reached
			showAlert: 			    false, // True to show a regular alert message
			alertText:			    "You have typed too many characters.", // Text in the alert message
			slider:				      true, // Use counter slider
			nonAsciiCharLength:		2 // The length of non-ASCII characters
		}, options );
		
		// Add the default event
		$.merge(settings.events, ['keyup']);

		return this.each(function() 
		{
			var item = $(this);
			// hkah: length of non-ASCII characters
			//var charactersLength = $(this).val().length;
			var charactersLength = unicodeLength($(this).val());
			
      // Update the status text
			function updateStatus()
			{
				var charactersLeft = settings.maxCharacters - charactersLength;
				
				if(charactersLeft < 0) 
				{
					charactersLeft = 0;
				}

				item.next("div").html(charactersLeft + " " + settings.statusText);
			}

			function checkChars() 
			{
				var valid = true;
				
				// Too many chars?
				if(charactersLength >= settings.maxCharacters) 
				{
					// Too may chars, set the valid boolean to false
					valid = false;
					// Add the notifycation class when we have too many chars
					item.addClass(settings.notificationClass);
					// Cut down the string
					// hkah: length of non-ASCII characters
					var itemLength = item.val().length;
					var itemunicodeLength = unicodeLength(item.val());
					var diff = itemunicodeLength - itemLength;
					var maxLength = settings.maxCharacters;
					item.val(item.val().substr(0,maxLength - diff));
					// Show the alert dialog box, if its set to true
					showAlert();
				} 
				else 
				{
					// Remove the notification class
					if(item.hasClass(settings.notificationClass)) 
					{
						item.removeClass(settings.notificationClass);
					}
				}

				if(settings.status)
				{
					updateStatus();
				}
			}
						
			// Shows an alert msg
			function showAlert() 
			{
				if(settings.showAlert)
				{
					alert(settings.alertText);
				}
			}

			// Check if the element is valid.
			function validateElement() 
			{
				var ret = false;
				
				if(item.is('textarea')) {
					ret = true;
				} else if(item.filter("input[type=text]")) {
					ret = true;
				} else if(item.filter("input[type=password]")) {
					ret = true;
				}

				return ret;
			}
			
			// hkah: length of non-ASCII characters
			function unicodeLength(str)
			{
				var l = 0;
				//alert("str = " + str);
				for (var i = 0; i < str.length; i++ ) {
				    if (str.charCodeAt(i) >= 127)
				    	l = l + settings.nonAsciiCharLength;
				    else 
				    	l = l + 1;
				}
				return l;
			}

			// Validate
			if(!validateElement()) 
			{
				return false;
			}
			
			// Loop through the events and bind them to the element
			$.each(settings.events, function (i, n) {
				item.bind(n, function(e) {
					// hkah: length of non-ASCII characters
					//charactersLength = item.val().length;
					charactersLength = unicodeLength(item.val());
					checkChars();
				});
			});

			// Insert the status div
			if(settings.status) 
			{
				item.after($("<div/>").addClass(settings.statusClass).html('-'));
				updateStatus();
			}

			// Remove the status div
			if(!settings.status) 
			{
				var removeThisDiv = item.next("div."+settings.statusClass);
				
				if(removeThisDiv) {
					removeThisDiv.remove();
				}

			}

			// Slide counter
			if(settings.slider) {
				item.next().hide();
				
				item.focus(function(){
					item.next().slideDown('fast');
				});

				item.blur(function(){
					item.next().slideUp('fast');
				}); 
			}

		});
	};
})(jQuery);
