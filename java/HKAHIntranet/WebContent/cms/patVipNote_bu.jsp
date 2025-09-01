<%@ page language="java" contentType="text/html;utf-8" pageEncoding="utf-8"%>
<%@ page import="java.io.*"%>
<%@ page import="java.util.*"%>
<%@ page import="java.net.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*"%>
<%@ page import="net.sf.jasperreports.engine.util.*"%>
<%@ page import="net.sf.jasperreports.engine.export.*"%>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*"%>
<%@ page import="org.json.*"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>

<%
String action = request.getParameter("action");
String system = request.getParameter("system");
String user = request.getParameter("user");
String regid = request.getParameter("regid");
String message = request.getParameter("message");

String colKey = request.getParameter("colKey");
String colDate = request.getParameter("colDate");
String colTime = request.getParameter("colTime");
String colTitle = "Dr Progress Note";
String colDesc = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "colDesc"));

String patno = request.getParameter("patno");
String patsex = null;
String patname = null;
String patcname = null;
String patdob = null;
String bedcode = null;	
String patage = null;
String readonly = null;

String sql;
ArrayList record = null;
ReportableListObject row = null;
JSONArray recJSON = new JSONArray();
JSONObject rowJSON;
Calendar calendar = Calendar.getInstance();
String currentDate = DateTimeUtil.formatDateTime(calendar.getTime());

try {
	
	//=== load patient info
	sql  = " select a.patno, a.patsex, patfname||' '||patgname as name, patcname, to_char(patbdate,'dd/mm/yyyy'), trunc(F_AGE_IN_YEAR(patbdate)) ";	
	sql += " from hat_patient a ";
	sql += " where a.patno=? ";
	
	ArrayList patInfo = UtilDBWeb.getReportableListCIS( sql, new String[]{patno});
	
	if (patInfo.size() > 0) {
		row = (ReportableListObject) patInfo.get(0);
		patno   = row.getValue(0);
		patsex = row.getValue(1);
		patname = row.getValue(2);
		patcname = row.getValue(3);
		patdob = row.getValue(4);
		patage = row.getValue(5);
		//bedcode = row.getValue(4);
		readonly = "false";
	}

	if ("create".equals(action)) {
			
		sql = "INSERT INTO PAT_VIP_NOTE ";
		sql += "(id, patno, note_date, description, status, create_user, create_date, update_user, update_date) ";
		sql += "VALUES (SEQ_PAT_VIP_NOTE.nextval, ?, to_date(?,'dd/mm/yyyy hh24:mi'), ? , 'A', ?, sysdate, ?, sysdate)";
		
		if ( UtilDBWeb.updateQueueCIS( sql, new String[]{ patno, colDate+" "+colTime, colDesc, user, user }) ) {
			message = "[OK] Record has been created.";
		} else {
			message = "[Error] Failed to create record.";
		}
		
	//=== update record (DB)
	} else if ("update".equals(action)) {
		
		sql = "UPDATE PAT_VIP_NOTE ";
		sql += " SET note_date=to_date(?,'dd/mm/yyyy hh24:mi'), description=?, update_user=?, update_date=sysdate ";
		sql += " WHERE id = ? ";
		
		if ( UtilDBWeb.updateQueueCIS( sql, new String[]{ colDate+" "+colTime, colDesc, user, colKey }) ) {
			message = "[OK] data has been saved.";
		} else {
			message = "[Error] Failed to save data.";
		}
	
	}
	
	// load list of progress note
	sql = " select id, patno, note_date, 'VIP' as note_type, description, update_date, update_user, ";
	sql += " (select co_lastname || ' ' || co_firstname from co_staffs@portal x where x.co_staff_id=a.update_user) as update_name, ";
	sql += " trunc(to_number(sysdate - create_date)) totdays ";
	//sql += " from PAT_VIP_NOTE a where status<>'X' and create_user=? ";	
	sql += " from PAT_VIP_NOTE a where status<>'X' ";
	sql += " order by a.create_date desc ";

	//record = UtilDBWeb.getReportableListCIS( sql, new String[]{user});
	record = UtilDBWeb.getReportableListCIS( sql, new String[]{});

	for (int i = 0; i < record.size(); i++) {
		row = (ReportableListObject) record.get(i);
		rowJSON = new JSONObject();
		rowJSON.put("id", row.getValue(0));
		rowJSON.put("patno", row.getValue(1));
		rowJSON.put("", row.getValue(2));
		rowJSON.put("note_date", row.getValue(2));
		rowJSON.put("note_type", row.getValue(3));
		rowJSON.put("", row.getValue(4));
		rowJSON.put("description", row.getValue(4));
		rowJSON.put("update_date", row.getValue(5));
		rowJSON.put("update_user", row.getValue(6));
		rowJSON.put("update_name", row.getValue(7));
		if (Integer.valueOf(row.getValue(8)) > 2) {
			rowJSON.put("canedit", "0");
		} else {
			rowJSON.put("canedit", "1");
		}
		//rowJSON.put("canedit", row.getValue(8));
		recJSON.put(rowJSON);
	}

} catch (Exception e) {
	e.printStackTrace();
}


%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html:html xhtml="true" lang="true">

<jsp:include page="../common/header.jsp" />
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/w3.hkah.css" />" />

<head>
	<meta http-equiv="Pragma" content="no-cache">
	<meta http-equiv="Cache-Control" content="no-cache">
	<style>
		label { font-weight:600; color:steelblue; }
		em { font-size:12px; font-weight:600; color:lightgrey; }
		textarea { background: #f5f1ee; }
		textarea:hover { background: #ffc;}
		#message { color:white;width:100%;bottom:0px;position:fixed;font-size:12px;}
	</style>
</head>

<body style="background: aliceblue;">

<div class="w3-container w3-row ah-pink" id=header>
	<div class="w3-col m7">
		<h3>VIP Note</h3>
	</div>
	<div class="w3-col m4 w3-right">
		<em>Name:</em> <%=patname%>	<br/>
		<em>Pat#:</em> <%=patno%> &nbsp;&nbsp; 
		<%-- 
		<em>Visit#:</em> <%=regid%> <br/>
		<em>&nbsp;Bed:</em> <%=bedcode%> &nbsp;&nbsp;
		--%> 
		<em>Gender:</em> <%=patsex%>  
		<em>Age:</em> <%=patage%>
	</div>
</div>

<div id=message class="ah-grey">msg</div>

<div class="w3-row">
	<div id=buttonPanel class="w3-container" style="margin-top:4px;margin-bottom:4px;">
		<%--
		<div class="w3-col m9">
			<form action="">
			<label><input type="radio" name="scope" onclick="showList('CMS')" />CMS (Dr. Progress Notes)</label>&nbsp; 
			<label><input type="radio" name="scope" onclick="showList('NIS')" />NIS (Nursing Notes)</label> 
			<label><input type="radio" name="scope" checked onclick="showList()" />Show All </label>&nbsp; 
			</form>
		</div>
		 --%>
		<div class="w3-right w3-hide">
			<button onclick="editProgressNote()">New VIP Note</button>
			<button onclick="document.title='[close]'; close()">Close</button>
		</div>
	</div>
	<div id=listPanel class="w3-container" style="height:calc(100vh - 240px);overflow:auto"></div>
	<div id=newPanel class="w3-container w3-row" style="height:110px;margin:12px;">
		<form name=frmNew id=frmNew action="patVipNote.jsp" method="post" autocomplete="off">
		<input type="hidden" name="action" value="create" />
		<input type="hidden" name="system" value="<%=system==null?"":system %>"/>
		<input type="hidden" name="user" value="<%=user==null?"":user %>"/>
		<input type="hidden" name="regid" value="<%= regid %>"/>
		<input type="hidden" name="patno" value="<%= patno %>"/>
		<div class="w3-col" style="width:250px">
			<label>Date: </label>
			<input name="colDate" id=newDate type="text" class="datepickerfield" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/>
			<br><label>Time: </label>
			<input name="colTime" id=newTime type="text" size="8" />			
		</div>
		<div class="w3-col" style="width:calc(100vw - 520px)">
			<label>Description: </label><textarea rows=5 name=colDesc id=newDesc style="width:calc(100vw - 640px)"></textarea>
		</div>
		</form>
		<div class="w3-col" style="width:90px;">
			<button class="w3-right" id=btnNew onclick="$('#newDesc').val()? $('#frmNew').submit() : alert('Please input Description');">Add</button><br><br>
			<button class="w3-right" onclick="document.title='[close]'; close()">Close</button>
		</div>
	</div>
</div>

<div id="editPanel" class="w3-modal">
<div class="w3-modal-content w3-container w3-row">
	<div class="w-top-left ah-grey w3-center">
		<h4 id=editTitle>Progress Note</h4>
		<!-- <button class="w3-button w3-top-right" onclick="$('#editPanel').hide()">&times;</button> -->
	</div>
	<form name=frmEdit id=frmEdit action="patVipNote.jsp" method="post" autocomplete="off">
		<input type="hidden" name="action" id="action" />
		<input type="hidden" name="system" id="system" value="<%=system==null?"":system %>"/>
		<input type="hidden" name="user" id="user" value="<%=user==null?"":user %>"/>
		<input type="hidden" name="regid" id="regid" value="<%= regid %>"/>
		<input type="hidden" name="patno" id="patno" value="<%= patno %>"/>
		<input type="hidden" name="colKey" id="colKey"/>
		<div class="w3-col">
			<label>Date :</label>
			<input name="colDate" id=colDate type="text" class="datepickerfield" maxlength="12" size="12" onkeyup="validDate(this)" onblur="validDate(this)"/>
			<label>Time :</label>
			<input name="colTime" id=colTime type="text" size="8" />
		</div>
		<label>Description</label>
		<textarea class="w3-input" rows=12 name=colDesc id=colDesc></textarea>
	</form>
	<small id=updateStamp></small><br/><br/>
	<button id="submit" accesskey="s" onclick="submitForm()">Save</button>
	<button class="w3-right" onclick="$('#editPanel').hide()">Close</button>
	<br/><br/>
</div>
</div>

</body>

<script language="JavaScript">

<% 
out.println("var loadTime = '" + currentDate + "'; ");
out.println("var message = '" + (message==null? "" : message) + "'; ");
out.println("var page = { user:'" + user + "', regid:" + regid + ", patno:'" + patno + "', readonly:" + readonly +  " }; " );
out.println("var records = " + recJSON.toString() + "; " );
%>

document.title = 'Progress Notes'
showList()
$('#newDate').val( loadTime.substr(0,10) )
$('#newTime').val( loadTime.substr(11,5) )
if (page.readonly) $('#btnNew').hide() 

//=== show list of progress note
function showList(opt) {
	var count = 0
	var html = '姓名 Name<input type="text" name="patName" value="343360" size=40></input></td><table class="w3-table w3-striped w3-border">'
	html += '<tr><th width=130px>Date</th><th width=90px">Category</th>'
	html += '<th width=580px>Description</th><th width=180px>Updated By<th> </th></tr>';
	
	for ( var i = 0; i < records.length; i++) {
		if ((opt || records[i].note_type) == records[i].note_type) {
			html += '<tr><td>' + records[i].note_date.substr(0, 16)	+ '</td>'
			html += '<td>' + records[i].note_type + '</td>'
			//html += '<td>' + records[i].title + '</td>'
			html += '<td>' + records[i].description.replace(/\n/g,'<br>') + '</td>'
			html += '<td>' + records[i].update_name + '</td>'
			
			//if (page.readonly==false && records[i].update_user==(page.user||'n/a') )  {
			if (page.readonly==false)  {
				html += '<td><button onclick="editProgressNote(' + i + ')">Edit</button></td>' 
			} else {
				html += '<td>&nbsp;</td>'
			}
			html += '</tr>'
			count++
		}
	}
	
	$('#listPanel').html( html + '</table><br>')
	$('#message').html( '&nbsp; ' + count+' rows. <span class="w3-right w3-text-orange">'+message + '&nbsp;</span>')
}

//=== new or edit progress note
function editProgressNote (idx) {
	if (records[idx].update_user==page.user) {
		if (records[idx].canedit==1) {
			$('#editPanel').show()
			$('#colDate').val( formatDate( records[idx].note_date ) )
			$('#colTime').val( records[idx].note_date.substr(11,5) )
			//$('#colTitle').val(records[idx].title)	
			$('#colTitle').val('title')
			$('#colDesc').val(records[idx].description)	
			$('#updateStamp').html( 'Last updated by ' + records[idx].update_user + ' on ' + records[idx].update_date.substr(0,16) )
			$('#action').val('update')
			$('#colKey').val(records[idx].id)
		} else {
			alert("You can not edit a record created more than 2 days ago");
		}
	} else {
		alert("You can not edit other's record");
	}
}

//=== convert date form yyyy-mm-dd hh:mm to [dd/mm/yyyy]
function formatDate( dt ) {
	return dt.substr(8,2) + '/' + dt.substr(5,2) + '/' + dt.substr(0,4)
}

//=== validate and submit form
function submitForm() {
	// validation here
	// submit form
	$("#frmEdit").submit();
}

</script>

</html:html>
