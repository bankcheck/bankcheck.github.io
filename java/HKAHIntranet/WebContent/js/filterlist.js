/*==================================================*
 $Id: filterlist.js,v 1.2 2010/05/21 03:40:55 ricky.leung Exp $
 Copyright 2003 Patrick Fitzgerald
 http://www.barelyfitz.com/webdesign/articles/filterlist/

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
 *==================================================*/
 
/*==================================================*
 Modified by Ricky Leung (HKAH) 2010/03/30
 
 The program select the matched option in the list instead of filtering out other options
*==================================================*/

function filterlist(selectobj, filtertextbox) {

  //==================================================
  // PARAMETERS
  //==================================================

  // HTML SELECT object
  // For example, set this to document.myform.myselect
  this.selectobj = selectobj;
  this.filtertextbox = filtertextbox;

  // Flags for regexp matching.
  // "i" = ignore case; "" = do not ignore case
  // You can use the set_ignore_case() method to set this
  this.flags = 'i';

  // Which parts of the select list do you want to match?
  this.match_text = true;
  this.match_value = false;

  // You can set the hook variable to a function that
  // is called whenever the select list is filtered.
  // For example:
  // myfilterlist.hook = function() { }

  // Flag for debug alerts
  // Set to true if you are having problems.
  this.show_debug = false;
  
  this.isInitState = true;
  
  // Store the previous searched result
  // Search from this index if user press "Enter" key
  this.previousMatchedIndex = -1;

  //==================================================
  // METHODS
  //==================================================

  //--------------------------------------------------
  this.init = function() {
    // This method initilizes the object.
    // This method is called automatically when you create the object.
    // You should call this again if you alter the selectobj parameter.

    if (!this.selectobj) return this.debug('selectobj not defined');
    if (!this.selectobj.options) return this.debug('selectobj.options not defined');
    
    // set a default value inside the filtering text box

    // Make a copy of the select list options array
    /*
    this.optionscopy = new Array();
    if (this.selectobj && this.selectobj.options) {
      for (var i=0; i < this.selectobj.options.length; i++) {

        // Create a new Option
        this.optionscopy[i] = new Option();

        // Set the text for the Option
        this.optionscopy[i].text = selectobj.options[i].text;

        // Set the value for the Option.
        // If the value wasn't set in the original select list,
        // then use the text.
        if (selectobj.options[i].value) {
          this.optionscopy[i].value = selectobj.options[i].value;
        } else {
          this.optionscopy[i].value = selectobj.options[i].text;
        }

      }
    }
    */
  }

  //--------------------------------------------------
  this.reset = function() {
    // This method resets the select list to the original state.
    // It also unselects all of the options.

    this.set('');
  }


  //--------------------------------------------------
  /* 
  // Original core function
  /*
    this.set = function(pattern) {
    // This method removes all of the options from the select list,
    // then adds only the options that match the pattern regexp.
    // It also unselects all of the options.

    var loop=0, index=0, regexp, e;

    if (!this.selectobj) return this.debug('selectobj not defined');
    if (!this.selectobj.options) return this.debug('selectobj.options not defined');

    // Clear the select list so nothing is displayed
    this.selectobj.options.length = 0;

    // Set up the regular expression.
    // If there is an error in the regexp,
    // then return without selecting any items.
    try {

      // Initialize the regexp
      regexp = new RegExp(pattern, this.flags);

    } catch(e) {

      // There was an error creating the regexp.

      // If the user specified a function hook,
      // call it now, then return
      if (typeof this.hook == 'function') {
        this.hook();
      }

      return;
    }

    // Loop through the entire select list and
    // add the matching items to the select list
    for (loop=0; loop < this.optionscopy.length; loop++) {

      // This is the option that we're currently testing
      var option = this.optionscopy[loop];

      // Check if we have a match
      if ((this.match_text && regexp.test(option.text)) ||
          (this.match_value && regexp.test(option.value))) {

        // We have a match, so add this option to the select list
        // and increment the index

        this.selectobj.options[index++] =
          new Option(option.text, option.value, false);

      }
    }

    // If the user specified a function hook,
    // call it now
    if (typeof this.hook == 'function') {
      this.hook();
    }

  }
  */
  
  this.trim = function(string) {
  	return string.replace(/^\s*/, "").replace(/\s*$/, "");
  }

  // Modified core function
  this.set = function(pattern, event) {
  	this.isInitState = false;
  	
    // This method select the most matched option.
    // It also unselects all of the options.

    var loop=0, index=0, regexp, e, beginIndex=0;
    
    if (!this.selectobj) return this.debug('selectobj not defined');
    if (!this.selectobj.options) return this.debug('selectobj.options not defined');

	if (isPressedEnterKey(event)) {
		if (this.selectobj.selectedIndex >= 0) {
			beginIndex = (this.selectobj.selectedIndex + 1) % this.selectobj.length;
		} else {
			beginIndex = (this.previousMatchedIndex + 1) % this.selectobj.length;
		}
	}

    // Loop through the entire select list and
    // select the matched one
    pattern= this.trim(pattern);
    if (pattern.length > 0) {
	    var isFound = false;
	    for (loop=beginIndex; !isFound && loop < this.selectobj.length; loop++) {
	
	      // This is the option that we're currently testing
	      var option = this.selectobj[loop];
	
	      // Check if we have a match
	      var lPattern = pattern.toLowerCase();
	      var IOptionValue = option.value.toLowerCase();
	      var IOptionText = option.text.toLowerCase();
	      if ((this.match_value && IOptionValue.indexOf(lPattern) >= 0) || 
	      		(this.match_text && IOptionText.indexOf(lPattern) >= 0)) {
	          this.selectobj.selectedIndex = loop;
	          this.previousMatchedIndex = loop;
	          isFound = true;
	      }
	    }
	    
	    // remove select if no match
	    if (!isFound) {
	    	this.selectobj.selectedIndex = -1;
	    	this.previousMatchedIndex = -1;
	    }
	
	    // If the user specified a function hook,
	    // call it now
	    if (typeof this.hook == 'function') {
	      this.hook();
	    }
	 } else {
	 	this.selectobj.selectedIndex = -1;
	 	this.previousMatchedIndex = -1;
	 }

  }


  //--------------------------------------------------
  this.set_ignore_case = function(value) {
    // This method sets the regexp flags.
    // If value is true, sets the flags to "i".
    // If value is false, sets the flags to "".

    if (value) {
      this.flags = 'i';
    } else {
      this.flags = '';
    }
  }


  //--------------------------------------------------
  this.debug = function(msg) {
    if (this.show_debug) {
      alert('FilterList: ' + msg);
    }
  }


  //==================================================
  // Initialize the object
  //==================================================
  this.init();

}

function isPressedEnterKey(event) {
  if (window.event) {
  	event = window.event;
  } 
  return event.keyCode == 13;
}
