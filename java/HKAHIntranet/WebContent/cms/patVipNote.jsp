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
UserBean userBean = new UserBean(request);
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
String searchpatno = request.getParameter("searchpatno");
String searchname = request.getParameter("searchname");
String category = request.getParameter("category");
String category_mod = null;
String updateby = request.getParameter("updateby");
String readonly = null;
String BDAlert = null;
String patno_mod = null;

String sql;
ArrayList record = null;
ArrayList record2 = null;
ReportableListObject row = null;
JSONArray recJSON = new JSONArray();
JSONObject rowJSON;
Calendar calendar = Calendar.getInstance();
String currentDate = DateTimeUtil.formatDateTime(calendar.getTime());

try {
	
	user = userBean.getStaffID();
	if (user == null) {
		user = "relogin";
	}
	
	if (searchpatno == null) {
		searchpatno = "";
	}
	if (category == null) {
		category = "";
	}
	if (searchname == null) {
		searchname = "";
	}
	if (updateby == null) {
		updateby = "";
	}

	//user = userBean.getStaffID();
	
	//=== load patient info
	sql  = " select a.patno, a.patsex, patfname||' '||patgname as name, patcname, to_char(patbdate,'dd/mm/yyyy'), trunc(F_AGE_IN_YEAR(patbdate)) ";	
	sql += " from hat_patient a ";
	sql += " where a.patno=? ";
	
	ArrayList patInfo = UtilDBWeb.getReportableListCIS( sql, new String[]{searchpatno});
			
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
	} else {
		patno   = "";
		patsex = "";
		patname = "";
		patcname = "";
		patdob = "";
		patage = "";
		readonly = "false";
	}
		

	if ("create".equals(action)) {
		category_mod = request.getParameter("category_add");
		patno_mod = request.getParameter("patno_add");
		
		sql = "INSERT INTO PAT_VIP_NOTE ";
		sql += "(id, patno, note_date, note_type, description, status, create_user, create_date, update_user, update_date) ";
		sql += "VALUES (SEQ_PAT_VIP_NOTE.nextval, ?, to_date(?,'dd/mm/yyyy hh24:mi'), ?, ? , 'A', ?, sysdate, ?, sysdate)";
		
		if (!user.equals("relogin")){
			if ( UtilDBWeb.updateQueueCIS( sql, new String[]{ patno_mod, colDate+" "+colTime, category_mod, colDesc, user, user}) ) {
				message = "[OK] Record has been created.";
			} else {
				message = "[Error] Failed to create record.";
			}
			response.sendRedirect("patVipNote.jsp?searchpatno="+searchpatno+"&searchname="+searchname+"&category="+category+"&updateby="+updateby+"&action=search"+"&user="+user);
		}
		
		
	//=== update record (DB)
	} else if ("update".equals(action)) {
		category_mod = request.getParameter("category_upd");
		patno_mod = request.getParameter("patno_upd");
		
		sql = "UPDATE PAT_VIP_NOTE ";
		sql += " SET note_date=to_date(?,'dd/mm/yyyy hh24:mi'), description=?, note_type=?, update_user=?, update_date=sysdate, patno=? ";
		sql += " WHERE id = ? ";
		
		
		if (!user.equals("relogin")){
			if ( UtilDBWeb.updateQueueCIS( sql, new String[]{ colDate+" "+colTime, colDesc, category_mod, user, patno_mod, colKey }) ) {
				message = "[OK] data has been saved.";
			} else {
				message = "[Error] Failed to save data.";
			}
			response.sendRedirect("patVipNote.jsp?searchpatno="+searchpatno+"&searchname="+searchname+"&category="+category+"&updateby="+updateby+"&action=search"+"&user="+user);
		}
	}
	
	// load list of vip note
	sql = " select id, a.patno, note_date, (select code_value1 from ah_sys_code where code_type='VIP_NOTE_TYPE' and code_no = a.note_type) as note_type, description, update_date, update_user, ";
	sql += " (select co_lastname || ' ' || co_firstname from co_staffs@portal x where x.co_staff_id=a.update_user) as update_name, ";
	sql += " trunc(to_number(sysdate - create_date) + 1) totdays, note_type note_type_code, ";
	sql += " p.patfname || ' ' || p.patgname patname, p.patsex, to_char(p.patbdate, 'dd/mm/yyyy'), trunc(F_AGE_IN_YEAR(p.patbdate)) patage, substr(description, 1, 30) ";
	sql += " from PAT_VIP_NOTE a ";
	sql += " left outer join patient@hat p on p.patno = a.patno ";
	sql += " where status<>'X' "; 
	if ((searchpatno != null) && (searchpatno != "")) {
		sql += " and a.patno = '" + searchpatno + "'";
	} else {
//		sql += " and 1 = 2 ";
	}
	if ((category != null) && (category != "")) {
		sql += " and note_type = '" + category + "'";
	}
	if ((updateby != null) && (updateby != "")) {
		sql += " and update_user = '" + updateby + "'";
	}
	if ((searchname != null) && (searchname != "")) {
		sql += " and p.patfname || ' ' || p.patgname like '%" + searchname + "%'";
	}
		
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
		rowJSON.put("title", row.getValue(4));
		rowJSON.put("description", row.getValue(4));
		rowJSON.put("update_date", row.getValue(5));
		rowJSON.put("update_user", row.getValue(6));
		rowJSON.put("update_name", row.getValue(7));
		rowJSON.put("note_type_code", row.getValue(9));
		rowJSON.put("patname", row.getValue(10));
		rowJSON.put("patsex", row.getValue(11));
		rowJSON.put("patbd", row.getValue(12));
		rowJSON.put("patage", row.getValue(13));
		rowJSON.put("desc_display", row.getValue(14));
		// Check BD alert
		record2 = UtilDBWeb.getReportableList("select to_date(to_char(sysdate, 'dd/mm') || '/' || to_char(p.patbdate, 'yyyy'), 'dd/mm/yyyy') - p.patbdate daystobd from patient@iweb p where p.patno = '" + row.getValue(1) + "'");
		if (record2.size() > 0) {
			ReportableListObject reportableListObject = (ReportableListObject) record2.get(0);
			BDAlert = reportableListObject.getValue(0);				
			if ((Integer.parseInt(BDAlert) >= 1) && (Integer.parseInt(BDAlert) <= 7)) {
				rowJSON.put("daystobd", "Coming!");
			}
			else {
				rowJSON.put("daystobd", "");
			}
		} else {
			rowJSON.put("daystobd", "");
		}
		//
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
	<%--
	<div class="w3-col m4 w3-right">
		<em>Name:</em> <%=patname%>	<br/>
		<em>Pat#:</em> <%=patno%> &nbsp;&nbsp; 
		<%-- 
		<em>Visit#:</em> <%=regid%> <br/>
		<em>&nbsp;Bed:</em> <%=bedcode%> &nbsp;&nbsp;
		--%>
			
	<%--
		<em>Gender:</em> <%=patsex%>  
		<em>Age:</em> <%=patage%>
	</div>
	 --%>
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
		<form name=frmNew id=frmNew action="patVipNote.jsp" autocomplete="off">
		<input type="hidden" name="action" value="create" />
		<%--
		<input type="hidden" name="system" value="<%=system==null?"":system %>"/>
		--%>
		<input type="hidden" name="user" value="<%=user==null?"":user %>"/>
		<%--
		<input type="hidden" name="regid" value="<%= regid %>"/>
		 --%>
		<%--
		<input type="hidden" name="patno" value="<%= patno %>"/>
		 --%>
		<input type="hidden" name="searchpatno" id="searchpatno" value="<%= searchpatno %>"/>
		<input type="hidden" name="searchname" id="searchname" value="<%= searchname %>"/>
		<input type="hidden" name="category" value="<%= category %>"/>
		<input type="hidden" name="updateby" value="<%= updateby %>"/>
		<div class="w3-col" style="width:250px">
			<label>Date: </label>
			<input name="colDate" id=newDate type="text" class="datepickerfield" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"/>
			<br><label>Time: </label>
			<input name="colTime" id=newTime type="text" size="8" />
			<label>Category :&nbsp;</label>
			<select id="category_add" name="category_add">
			<option value="05">Alert</option>
			<option value="10">Privacy control</option>
			<option value="15">Car plate</option>
			<option value="20">Special request</option>
			<option value="25">Contact</option>
			<option value="30">Referral By</option>	
			</select>			
		</div>
		<div class="w3-col" style="width:calc(100% - 520px)">
			<label>Pat No : </label>
			<input name="patno_add" id="patno_add" type="text" maxlength="10" size="10" onblur="getRelatedInfo('patient', $(this).val(), 'patname_add')"/>
			<label>Name : </label>
			<input name="patname_add" id="patname_add" type="text" maxlength="10" size="50" readonly/>			
		</div>
		<div class="w3-col" style="width:calc(100% - 520px)">
			<label>Description: </label><textarea rows=5 name=colDesc id=newDesc style="width:calc(100% - 140px)"></textarea>			
		</div>
		</form>
		<div class="w3-col" style="width:90px;">
			<button class="w3-right" id=btnNew onclick="$('#newDesc').val()? $('#frmNew').submit() : alert('Please input Description');">Add</button><br><br>
			<%-- 
			<button class="w3-right" onclick="document.title='[close]'; close()">Close</button>
			--%>
		</div>
	</div>
</div>

<div id="editPanel" class="w3-modal">
<div class="w3-modal-content w3-container w3-row">
	<div class="w-top-left ah-grey w3-center">
		<h4 id=editTitle>Progress Note</h4>
		<!-- <button class="w3-button w3-top-right" onclick="$('#editPanel').hide()">&times;</button> -->
	</div>
	<form name=frmEdit id=frmEdit action="patVipNote.jsp" autocomplete="off">
		<input type="hidden" name="action" id="action" />
		<input type="hidden" name="user" id="user" value="<%=user==null?"":user %>"/>
		<%--		
		<input type="hidden" name="regid" id="regid" value="<%= regid %>"/>
		 --%>
		<%--
		<input type="hidden" name="patno" id="patno" value="<%= patno %>"/>
		 --%>
		<input type="hidden" name="searchpatno" id="searchpatno" value="<%= searchpatno %>"/>
		<input type="hidden" name="searchname" id="searchname" value="<%= searchname %>"/>
		<input type="hidden" name="category" value="<%= category %>"/>
		<input type="hidden" name="updateby" value="<%= updateby %>"/>
		<input type="hidden" name="colKey" id="colKey"/>
		<div class="w3-col">
			<label>Date :</label>
			<input name="colDate" id=colDate type="text" class="datepickerfield" maxlength="12" size="12" onkeyup="validDate(this)" onblur="validDate(this)"/>
			<label>Time :</label>
			<input name="colTime" id=colTime type="text" size="8" />
			<label>Category&nbsp;</label>
			<select id="category_upd" name="category_upd">
			<option value="05" >Alert</option>
			<option value="10" >Privacy control</option>
			<option value="15" >Car plate</option>
			<option value="20" >Special request</option>
			<option value="25" >Contact</option>'	
			<option value="30" >Referral By</option>'
			</select>			
		</div>
		<div class="w3-col">
		<label>Pat No :</label>
		<input name="patno_upd" id="patno_upd" type="text" maxlength="10" size="10" onblur="getRelatedInfo('patient', $(this).val(), 'patname_upd')"/>		
		<input name="patname_upd" id="patname_upd" type="text" maxlength="10" size="30" readonly/>
		<div class="w3-col">
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

<%
System.out.println("user : " + user);
%>
//alert('<%=user%>');
document.title = 'Progress Notes';
if ('<%=user%>' == 'relogin') {
	alert('Please login Intranet Portal');
	$('#newPanel').hide();
} else {
	showList();
	$('#newDate').val( loadTime.substr(0,10) );
	$('#newTime').val( loadTime.substr(11,5) );
	if (page.readonly) {
		$('#btnNew').hide();
	}
}

//=== show list of progress note
function showList(opt) {
	var count = 0;
	var html = '<form name=frmView id=frmView action="patVipNote.jsp" autocomplete="off"><label>Patient No.&nbsp;</label><input type="text" name="searchpatno" value="<%=searchpatno%>" size=10>&nbsp;';
	html += '<label>Name&nbsp;</label><input type="text" name="searchname" value="<%=searchname%>" size=30>&nbsp;';
	html += '<label>Category&nbsp;</label><select id="category" name="category">';
	html += '<option value=""></option>';
	html += '<option value="05" <%=("05".equals(category))?"selected":"" %>>Alert</option>';
	html += '<option value="10" <%=("10".equals(category))?"selected":"" %>>Privacy control</option>';
	html += '<option value="15" <%=("15".equals(category))?"selected":"" %>>Car plate</option>';
	html += '<option value="20" <%=("20".equals(category))?"selected":"" %>>Special request</option>';
	html += '<option value="25" <%=("25".equals(category))?"selected":"" %>>Contact</option>';
	html += '<option value="30" <%=("30".equals(category))?"selected":"" %>>Referral By</option>';
	html += '</select>';
	html += '&nbsp;<label>Staff No.&nbsp;</label><input type="text" name="updateby" value="<%=updateby%>" size=10>&nbsp;';
	html += '<button onclick=submitForm()>Search</button></input>&nbsp';
	html += '<input type="hidden" name="action" value="search" />';
	<%--
	html += '<input type="hidden" name="system" value="<%=system==null?"":system %>"/>';
	--%>	
	html += '<input type="hidden" name="user" value="<%=user==null?"":user %>"/>';
	<%--
	html += '<input type="hidden" name="regid" value="<%= regid %>"/>';
	--%>
	<%--
	html += '<input type="hidden" name="patno" value="<%= patno %>"/>'
	--%>
	html += '</form>';
	//
	html += '<table class="w3-table w3-striped w3-border">';
	html += '<tr><th width=130px>Date</th><th width=140px">Category</th>';
	html += '<th width=100px>Pat No</th><th width=200px>Name</th><th width=50px>Gender</th><th width=100px>Birth Date</th><th width=30px>Age</th><th width=100px>Birth Date Alert</th>';
	html += '<th width=380px>Description</th><th width=180px>Updated By<th> </th></tr>';
	
	for ( var i = 0; i < records.length; i++) {
//		if ((opt || records[i].note_type) == records[i].note_type) {
			html += '<tr><td>' + records[i].note_date.substr(0, 16)	+ '</td>';
			html += '<td>' + records[i].note_type + '</td>';
			html += '<td>' + records[i].patno + '</td>';
			html += '<td>' + records[i].patname + '</td>';
			html += '<td>' + records[i].patsex + '</td>';
			html += '<td>' + records[i].patbd + '</td>';
			html += '<td>' + records[i].patage + '</td>';
			html += '<td>' + records[i].daystobd + '</td>';
			html += '<td height="50">' + records[i].desc_display.replace(/\n/g,'<br>') + '</td>';
			html += '<td>' + records[i].update_name + '</td>';
			
			//if (page.readonly==false && records[i].update_user==(page.user||'n/a') )  {
			if (page.readonly==false)  {
				html += '<td><button onclick="editProgressNote(' + i + ')">Edit</button></td>'; 
			} else {
				html += '<td>&nbsp;</td>';
			}
			html += '</tr>';
			count++;
		//}
	}
		
	$('#listPanel').html( html + '</table><br>');
	$('#message').html( '&nbsp; ' + count+' rows. <span class="w3-right w3-text-orange">'+message + '&nbsp;</span>');
}

//=== new or edit progress note
function editProgressNote (idx) {
	if (records[idx].update_user==page.user) {
		if (records[idx].canedit==1) {
			$('#editPanel').show();
			$('#colDate').val( formatDate( records[idx].note_date ) );
			$('#colTime').val( records[idx].note_date.substr(11,5) );
			//$('#colTitle').val(records[idx].title);	
			$('#colTitle').val('title');
			$('#colDesc').val(records[idx].description);	
			$('#updateStamp').html( 'Last updated by ' + records[idx].update_user + ' on ' + records[idx].update_date.substr(0,16) );
			$('#action').val('update');
			$('#colKey').val(records[idx].id);
			//$('#category').val(records[idx].note_type_code);
			$("#category_upd option[value='" + records[idx].note_type_code + "']").attr("selected", true);
			$('#patno_upd').val(records[idx].patno);
			$('#patname_upd').val(records[idx].patname);
		} else {
			alert("You can not edit a record created more than 2 days ago");
		}
	} else {
		alert("You can not edit other's record");
	}
}

//=== convert date form yyyy-mm-dd hh:mm to [dd/mm/yyyy]
function formatDate( dt ) {
	return dt.substr(8,2) + '/' + dt.substr(5,2) + '/' + dt.substr(0,4);
}

//=== validate and submit form
function submitForm() {
	// validation here
	// submit form
	if ('<%=user%>' == 'relogin') {
		alert('Please login Intranet Portal');
		$('#newPanel').hide();
		$('listPanel').hide();
	} else {
		$("#frmEdit").submit();	
	}
	
}

function getRelatedInfo(type, key, dom) {
	//alert(dom);
	if(type == 'patient') {
		$.ajax({
			url: "../ui/patientInfoCMB.jsp?callback=?",
			data: "patno="+key,
			dataType: "jsonp",
			cache: false,
			success: function(values){
				$('#'+dom).val(values['PATNAME']);				
				
			},
			error: function(x, s, e) {						
				$('#'+dom).val('');
				if(key.length > 0)
					alert("No Such Patient!");
			}
		});
	}
}

</script>

</html:html>
