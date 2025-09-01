	function validDate(obj) {
		date=obj.value
		if (/[^\d/]|(\/\/)/g.test(date)) {
			obj.value=obj.value.replace(/[^\d/]/g,'');
			obj.value=obj.value.replace(/\/{2}/g,'/');
			return;
		}
		if (/^\d{2}$/.test(date)) {
			obj.value=obj.value+'/';
			return;
		}
		if (/^\d{2}\/\d{2}$/.test(date)) {
			obj.value=obj.value+'/';
			return;
		}
		if (!/^\d{2}\/\d{2}\/\d{4}$/.test(date)) {
			return;
		}
		test1=(/^\d{2}\/?\d{2}\/\d{4}$/.test(date))
		date=date.split('/')
		d=new Date(date[2],date[1]-1,date[0])
		test2=(1*date[0]==d.getDate() && 1*date[1]==(d.getMonth()+1) && 1*date[2]==d.getFullYear())
		if (test1 && test2) return true;
		obj.select();
		obj.focus();
		return false;
	}
	
	function checkDate(obj,msg) {	
		date=obj.value;
		var seldd = date.substring(0,2);
		var selMM = date.substring(3,5);
		var selyyyy = date.substring(6,12);
//		var selDateStr = selyyyy+selMM+seldd;
		var selDate = new Date(selyyyy,selMM-1,seldd);	
		var today = new Date();
/*		
		var dd = today.getDate();
		var MM = today.getMonth()+1;
		var yyyy = today.getYear();
		var todayStr = yyyy.toString()+MM.toString()+dd.toString();
*/		
		if(selDate<today){
			$.prompt(msg,{prefix:'cleanblue'});
		};
	}	

	function validTime(obj) {
		time=obj.value
		if (/^\d{2}$/.test(time)) {
			obj.value=obj.value+':';
			return;
		}
		if (/^\d{2}\:\d{2}$/.test(time)) {
			obj.value=obj.value+':';
			return;
		}
		if (!/^\d{1,2}\:\d{2}\:\d{2}$/.test(time)) {
			return;
		}
		test1=(/^\d{1,2}\:?\d{2}\:\d{2}$/.test(time))
		time=time.split(':')
		test2=(1*time[0]< 24 && 1*time[1]< 60 && 1*time[2]< 60)
		if (test1 && test2) return true;
		obj.select();
		obj.focus();
		return false;
	}

	function parseDateTime(datetime_str) {
		if (datetime_str.length == 19) {
			var date_str = datetime_str.substring(0, 10);
			var time_str = datetime_str.substring(11, 19);
			date_str = date_str.split('/')
			time_str=time_str.split(':')
			return new Date(date_str[2],date_str[1]-1,date_str[0],time_str[0],time_str[1],time_str[2]);
		} else {
			return new Date();
		}
	}

	function parseDate(datetime_str) {
		if (datetime_str.length == 10) {
			var date_str = datetime_str.substring(0, 10);
			date_str = date_str.split('/')
			return new Date(date_str[2],date_str[1]-1,date_str[0]);
		} else {
			return new Date();
		}
	}
	
	function callPopUpWindow(URL, width, height) {
		var isIE=(navigator.appName.indexOf("Microsoft")!=-1)?1:0;
		var version = parseFloat(navigator.appVersion.split("MSIE")[1]);
		var popwidth = window.screen.availWidth ? window.screen.availWidth : screen.width;
		var popheight = window.screen.availHeight ? window.screen.availHeight : screen.height;
		if (isIE && version == 6) {
			popwidth = popwidth - 10;
			popheight = popheight - 35;
		} else {
			popwidth = popwidth - 20;
			popheight = popheight - 100;
		}

		if (width) {
			popwidth = width;
		}
		
		if (height) {
			popheight = height;
		}
		
	 	params  = 'width='+popwidth;
 		params += ',height='+popheight;
 		params += ',screenX=0,screenY=0,top=0,left=0';
 		params += ',scrollbars=yes,resizable=yes,status=no,toolbar=no,menubar=no,location=no';

		if (!window.window1) {
			// has not yet been defined (e.g. fullscreen=yes)
			window1 = window.open(URL, "", params);
			window1.focus();
		} else {
			// has been defined
			if (!window1.closed) {
				// still open
				window1.location = URL;
				window1.focus();
			} else {
				window1 = window.open(URL, "", params);
				window1.focus();
			}
		}
	}
	
	function callPopUpWindowMX(URL) {
		if (!window.window1) {
			// has not yet been defined (e.g. fullscreen=yes)
			window1 = window.open(URL, "", "scrollbars=1");
			window1.moveTo(0,0);
			window1.resizeTo(screen.width,screen.height);			
			window1.focus();
		} else {
			// has been defined
			if (!window1.closed) {
				// still open
				window1.location = URL;
				window1.moveTo(0,0);
				window1.resizeTo(screen.width,screen.height);				
				window1.focus();
			} else {
				window1 = window.open(URL, "", "scrollbars=1");
				window1.moveTo(0,0);
				window1.resizeTo(screen.width,screen.height);				
				window1.focus();
			}
		}
	}
	

	function callPopUpWindowSML(URL) {
		if (!window.window1) {
			// has not yet been defined (e.g. fullscreen=yes)
			window1 = window.open(URL, "", "scrollbars=1");
			window1.moveTo(0,0);
			window1.resizeTo(screen.width/2,screen.height/2);			
			window1.focus();
		} else {
			// has been defined
			if (!window1.closed) {
				// still open
				window1.location = URL;
				window1.moveTo(0,0);
				window1.resizeTo(screen.width/2,screen.height/2);				
				window1.focus();
			} else {
				window1 = window.open(URL, "", "scrollbars=1");
				window1.moveTo(0,0);
				window1.resizeTo(screen.width/2,screen.height/2);				
				window1.focus();
			}
		}
	}
	
	function callPopUpWindow2(URL) {
		var isIE=(navigator.appName.indexOf("Microsoft")!=-1)?1:0;
		var version = parseFloat(navigator.appVersion.split("MSIE")[1]);
		var popwidth = window.screen.availWidth ? window.screen.availWidth : screen.width;
		var popheight = window.screen.availHeight ? window.screen.availHeight : screen.height;
		if (isIE && version == 6) {
			popwidth = popwidth - 10;
			popheight = popheight - 35;
		}

	 	params  = 'width='+popwidth;
 		params += ',height='+popheight;
 		params += ',screenX=0,screenY=0,top=0,left=0';
 		params += ',scrollbars=yes,resizable=yes,status=no,toolbar=no,menubar=no,location=no';

		if (!window.window2) {
			// has not yet been defined
			window2 = window.open(URL, "", params);
			window2.focus();
		} else {
			// has been defined
			if (!window2.closed) {
				// still open
				window2.location = URL;
				window2.focus();
			} else {
				window2 = window.open(URL, "", params);
				window2.focus();
			}
		}
	}
	
	//Copy to clipboard: ref http://forum.moztw.org/viewtopic.php?p=131407
	function copyToClipboard(txt) {
	    var copied = false;
	     if(window.clipboardData) {
	        window.clipboardData.clearData();
	        window.clipboardData.setData("Text", txt);
	        copied = true;
	     } else if (window.netscape) {
	        try {
	           netscape.security.PrivilegeManager.enablePrivilege("UniversalXPConnect");
	        } catch (e) {
	           alert("Browser denied copy function.\nPlease enter 'about:config' in the address bar.\n，Set property: 'signed.applets.codebase_principal_support' to 'true'.");
	        }
	        var clip = Components.classes['@mozilla.org/widget/clipboard;1']
	        .createInstance(Components.interfaces.nsIClipboard);
	        if (!clip)
	           return;
	        var trans = Components.classes['@mozilla.org/widget/transferable;1']
	        .createInstance(Components.interfaces.nsITransferable);
	        if (!trans)
	           return;
	        trans.addDataFlavor('text/unicode');
	        var str = new Object();
	        var len = new Object();
	        var str = Components.classes["@mozilla.org/supports-string;1"]
	        .createInstance(Components.interfaces.nsISupportsString);
	        var copytext = txt;
	        str.data = copytext;
	        trans.setTransferData("text/unicode",str,copytext.length*2);
	        var clipid = Components.interfaces.nsIClipboard;
	        if (!clip)
	           return false;
	        clip.setData(trans,null,clipid.kGlobalClipboard);
	        copied = true;
	     }
	     if (copied)
	    	 return true;
	     else 
	    	 return false;
	}    

	// ajax: call the function to create the XMLHttpRequest object
	function createRequestObject() {
		var tmpXmlHttpObject;

		//depending on what the browser supports, use the right way to create the XMLHttpRequest object
		if (window.XMLHttpRequest) {
			// Mozilla, Safari would use this method ...
			tmpXmlHttpObject = new XMLHttpRequest();

		} else if (window.ActiveXObject) {
			// IE would use this method ...
			tmpXmlHttpObject = new ActiveXObject("Microsoft.XMLHTTP");
		}

		return tmpXmlHttpObject;
	}

	function lockColumn() {
		var table = document.getElementById('row');
		var button = document.getElementById('toggle');
		var cTR = table.getElementsByTagName('TR');  //collection of rows
		var cTH = table.getElementsByTagName('TH');  //collection of rows

		if (table.rows[0].cells[1].className == '') {
			for (i = 0; i < cTR.length; i++) {
				var tr = cTR.item(i);
				tr.cells[1].className = 'locked'
			}
			button.innerText = "Unlock First Column";
			for (i = 0; i < cTH.length; i++) {
				var th = cTH.item(i);
				th.cells[1].className = ''
			}
		} else {
			for (i = 0; i < cTR.length; i++) {
				var tr = cTR.item(i);
				tr.cells[1].className = ''
			}
			button.innerText = "Lock First Column";
			for (i = 0; i < cTH.length; i++) {
				var th = cTH.item(i);
				th.cells[1].className = ''
			}
		}
	}

	function moveItem(formName, addItemName, removeItemName) {
		var source= document.forms[formName].elements[removeItemName];
		var dest = document.forms[formName].elements[addItemName];
		var oOption;
		var foundOption;

	    if (source.selectedIndex >= 0) {
			for (i = source.options.length - 1; i >= 0; i--) {
				if (source.options[i].selected) {
					oOption = source.removeChild(source.options[i]);
					oOption.selected = false;

					// avoid duplicate insert
					foundOption = false;
					for (j = dest.options.length - 1; !foundOption && j >= 0; j--) {
						if (dest.options[j].value == oOption.value) {
							foundOption = true;
						}
					}
					if (!foundOption) {
						dest.appendChild(oOption);
					}
				}
			}
		}
		return false;
	}

	function removeDuplicateItem(formName, removeItemName, referItemName) {
		var source= document.forms[formName].elements[removeItemName];
		var dest = document.forms[formName].elements[referItemName];
		var oOption;
		var foundOption;

		for (i = source.options.length - 1; i >= 0; i--) {
			foundOption = false;
			for (j = dest.options.length - 1; !foundOption && j >= 0; j--) {
				if (dest.options[j].value == source.options[i].value) {
					foundOption = true;
					oOption = source.removeChild(source.options[i]);
					oOption.selected = false;
				}
			}
		}
		return false;
	}

	function selectItem(formName, itemName) {
		var source= document.forms[formName].elements[itemName];

		for (i = source.options.length - 1; i >= 0; i--) {
			source.options[i].selected = true;
		}
		return false;
	}
	
	function checkRadioByObj(radioObj, value, notUncheckOther) {
		if (radioObj) {
			for(var i = 0; i < radioObj.length; i++) {
				if (!notUncheckOther) {
					radioObj[i].checked = false;
				}
				if(radioObj[i].value == value) {
					radioObj[i].checked = true;
				}
			}
		}
	}
	
	function getRadioCheckedValue(radioObj) {
		if (radioObj) {
			for (var i=0; i < radioObj.length; i++) {
			   if (radioObj[i].checked) {
			      return radioObj[i].value;
		      }
		   }
		}
	}

	var colorPoint = 1;
	function doBlink() {
	  // Blink, Blink, Blink...
	  var blink = document.all.tags("BLINK")
	  colorPoint = (colorPoint % 8) + 1;
	  for (var i=0; i < blink.length; i++)
	    //blink[i].style.visibility = blink[i].style.visibility == "" ? "hidden" : ""
	    blink[i].className = "labelColor" + colorPoint;
	}

	function startBlink() {
	  // Make sure it is IE4
	  if (document.all)
	    setInterval("doBlink()",500)
	}
	window.onload = startBlink;

	function getWindowsSize() {
		/*
		 * Browser Window Size in JavaScript
		 * http://www.javascripter.net/faq/browserw.htm
		 */
		var winW = 630, winH = 460;	// for very old broswer
		if (document.body && document.body.offsetWidth) {
			winW = document.body.offsetWidth;
			winH = document.body.offsetHeight;
		}
		if (document.compatMode=='CSS1Compat' &&
				document.documentElement &&
				document.documentElement.offsetWidth ) {
			winW = document.documentElement.offsetWidth;
			winH = document.documentElement.offsetHeight;
		}
		if (window.innerWidth && window.innerHeight) {
			winW = window.innerWidth;
			winH = window.innerHeight;
		}
		return {'width': winW, 'height': winH}
	}
	
	// keep session alive
	function keepAlive(interval) {
		if (interval == null) {
			interval = 1000*60*25; //default 25 mins
		}
		setInterval(keepAliveRun, interval);
	}
	
	function keepAliveRun() {
		$.ajax({
			type: "POST",
			url: window.location.pathname.substring(0, window.location.pathname.indexOf('/',2)) + "/common/keepAlive.jsp",
			success: function(values){
				//alert('Session extended: ' + new Date());
			},
			error: function(jqXHR, textStatus, errorThrown) {
				//alert('Error extending session: ' + new Date());
			}
		});
	}
	
	String.prototype.endsWith = function(suffix) {
	    return this.indexOf(suffix, this.length - suffix.length) !== -1;
	};