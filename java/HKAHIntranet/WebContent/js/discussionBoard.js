	function dbListForm_submitAction(cmd, stp, seq) {
		var siteCode = document.forms["dbListForm"].elements["siteCode"].value;
		var moduleCode = document.forms["dbListForm"].elements["moduleCode"].value;
		var moduleDescription = document.forms["dbListForm"].elements["moduleDescription"].value;
		var recordId = document.forms["dbListForm"].elements["recordId"].value;
		var recordTitle = document.forms["dbListForm"].elements["recordTitle"].value;
		
		var params = "siteCode=" + siteCode + "&moduleCode=" + moduleCode + "&moduleDescription=" + moduleDescription + "&recordId=" + recordId + "&recordTitle=" + recordTitle;
		var url = "../discussionBoard/comment_list.htm" + "?" + params;
		
		// open a popup window
		callPopUpWindow(url);
		return false;
	}
	
	function dbCommentListForm_submitAction(cmd, stp, seq) {
		if (cmd == "quickAddComment" || cmd == "createComment") {
			if (document.forms["form1"].elements["topicDesc"].value == "") {
				document.forms["form1"].elements["topicDesc"].focus();
				alert("Please input topic!");
				return false;
			}
			if (document.forms["form1"].elements["commentDesc"].value == "") {
				document.forms["form1"].elements["commentDesc"].focus();
				alert("Please input content!");
				return false;
			}
		} else if (cmd = "viewComment") {
			document.forms["form1"].action = "comment_detail.htm";
		}
		
		
		document.forms["form1"].elements["command"].value = cmd;
		document.forms["form1"].elements["step"].value = stp;
		document.forms["form1"].elements["seq"].value = seq;
		document.forms["form1"].submit();
	}
	
	function dbCommentListForm_viewCommentAction(cmd, cid) {
		document.forms["form1"].elements["command"].value = cmd;
		document.forms["form1"].elements["commentId"].value = cid;
		document.forms["form1"].action = "comment_detail.htm";
		document.forms["form1"].submit();
		
		// restore action url
		document.forms["form1"].action = "comment_list.htm";
		
		return true;
	}
	
	function dbListForm_viewCommentAction(cmd, cid) {
		var moduleCode = document.forms["dbListForm"].elements["moduleCode"].value;
		var moduleDescription = document.forms["dbListForm"].elements["moduleDescription"].value;
		var recordId = document.forms["dbListForm"].elements["recordId"].value;
		var recordTitle = document.forms["dbListForm"].elements["recordTitle"].value;
		
		var params = "command=" + cmd + "&moduleCode=" + moduleCode + "&moduleDescription=" + moduleDescription + "&recordId=" + recordId + "&recordTitle=" + recordTitle + "&commentId=" + cid;
		var url = "../discussionBoard/comment_detail.htm" + "?" + params;
		
		// open a popup window
		callPopUpWindow(url);
		return false;
	}
	
	function dbCommentDetailForm_submitAction(cmd, stp) {
		if (cmd == "goToReply") {
			
		}
		document.forms["form1"].elements["command"].value = cmd;
		document.forms["form1"].elements["step"].value = stp;
		if (cmd == "listComments") {
			document.forms["form1"].action = "comment_list.htm";
		}
		document.forms["form1"].submit();
	}
		
	function db_showhide(i, hideobj, showobj, showhidelink, hidelink, showlink){
		var showelem = document.getElementById(showobj + i);
		var hideelem = document.getElementById(hideobj + i);
		var linkelem=document.getElementById(showhidelink + i);
	
		showelem.style.display=showelem.style.display=="none"?"inline":"none";
		hideelem.style.display=hideelem.style.display=="none"?"inline":"none";
	
		if (hideelem.style.display=="none"){
			linkelem.className="invisible";
			linkelem.innerHTML = showlink;
		} else {
			linkelem.className="visible";
			linkelem.innerHTML = hidelink;
		}
	}