<meta name = "format-detection" content = "telephone=no">
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.config.MessageResources"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="com.hkah.constant.*"%>

<% 

String hospitalName=null;
if(ConstantsServerSide.isHKAH()){
	hospitalName = "Hong Kong Adventist Hospital - Stubbs Road";
}
if(ConstantsServerSide.isTWAH()){
	hospitalName = "Hong Kong Adventist Hospital - Tsuen Wan";
}

UserBean userBean = new UserBean(request);
String staffID = request.getParameter("staffID");
String staffName = request.getParameter("staffName");
String dept = request.getParameter("dept");
if (userBean != null || userBean.isLogin()) {
	
	ArrayList record = ChapStaffDB.getStaffListWithParam(userBean,staffID,staffName,dept);
	request.setAttribute("staffList", record);
}else {

}

%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>

<html:html xhtml="true" lang="true">
	<jsp:include page="../common/header.jsp">
		<jsp:param name="nocache" value="N" />
	</jsp:include>
		
	<jsp:include page="../common/page_title.jsp" flush="false">
		<jsp:param name="pageTitle" value="function.cs.stafflist" />
		<jsp:param name="isHideTitle" value="Y" />
	</jsp:include>
	
	<style>
		TD,TH,A,SPAN,INPUT {
			font-size:16px !important;
		}
		.selected {
			background: url("../images/ui-bg_highlight-soft_75_ffe45c_1x100.png") repeat-x scroll 50% 50% #F6F6F6 !important;
		}
		.scroll-pane{
			width: 100%;
			height: 400px;
			overflow: auto;
		}					
	</style>
	
	<body>
		<DIV id=indexWrapper style="width:100%" >
			<DIV id=mainFrame style="width:100%" >
				<DIV id=contentFrame style="width:100%" >	
						<!-- updating -->
					<div id="loadingListDiv" style="display:none; position:absolute; z-index:14;" 
							class="ui-dialog ui-widget ui-widget-content ui-corner-all">
							<div class="ui-widget-header" style="font-size:16px">Updating......</div>
							<div style="font-size:16px; height:50px;">Loading the list.....</div>
					</div>					
					<!-- overlay -->
					<div id="overlay" class="ui-widget-overlay" style="display:none;"></div>	
					
					<div id="staffRemarkPanel" style="width:900px; height:600px; display:none; position:absolute; z-index:12; "
							class="ui-dialog ui-widget ui-widget-content ui-corner-all">
						<table id="staffRemarkTable">
							<tbody>
								<tr>
									<td class="ui-widget-header" colspan="3" style="width:5%; 
											color:black; height:25px; font-size:16px; 
											font-weight:bold;">
										Staff Remark
										<img src='../images/cross.jpg' style='float:right' onclick='closeStaffRemarkPanel()'/>
									</td>
								</tr>
								<tr>
									<td colspan='3' id="staffInfo">
										
									</td>
								</tr>
								<tr><td></td></tr>
								<tr>
									<td style='border-width:1px; border-style:solid; '>									
										<div id='scroll-pane' class='scroll-pane jspScrollable' style='overflow: hidden; padding: 0px; width: 890px; height:400px'>
											<table  id='staffRemarkList' style='border-width:0px;border-spacing:0px;width:100%;'>
											</table> 
										</div>										
									</td>									
								</tr>
							</tbody>
						</table>
					</div>
					
					<div id="inputEntryPanel" style="width:450px; height:360px; display:none; position:absolute; z-index:18; "
							class="ui-dialog ui-widget ui-widget-content ui-corner-all">
						<table id="inputEntryTable">
							<tbody>
								<tr>
									<td class="ui-widget-header"style="width:5%; 
											color:black; height:25px; font-size:16px; 
											font-weight:bold;">
										Record Entry
										<img src='../images/cross.jpg' style='float:right' onclick='closeInputEntryPanel()'/>
									</td>
								</tr>									
								<tr>								
									<td >
										<table id='inputEntryInfoTable' style='border-width:0px;border-spacing:0px;height:265px'>
										</table> 																		
									</td>									
								</tr>					
							</tbody>
						</table>
					</div>
								
					<!-- SEARCH PART -->
					<form name="searchForm" action="stafflist.jsp" method="get">
						<table cellpadding="0" cellspacing="5" class="contentFrameSearch" border="0" style="width:100%">
							<tr  style="width:100%">
								<td colspan="3" style="width:50%;background-color:gray; color:white;">
									<label style="font-size:30px;"><u><b>Staff List</b></u></label>
								</td>							
							</tr>
							<tr class="smallText" style="width:100%">								
								<td  class="infoLabel" style="width:12%">
									Staff ID
								</td>
								<td id="staffIDCell" style="vertical-align:top" colspan="2" class="infoData" style="width:38%">
									<input name="staffID" type="textfield" value="<%=(staffID==null)?"":staffID %>" maxlength="30" size="30" />
								</td>	
								<td class="infoLabel" style="width:12%">
									Staff Name
								</td>								
								<td id="staffNameCell" style="vertical-align:top" colspan="2" class="infoData" style="width:38%">
									<input name="staffName" type="textfield" value="<%=(staffName==null)?"":staffName %>" maxlength="30" size="30" />
								</td>												
							</tr>
							
							<tr class="smallText">
								<td class="infoLabel">
									Department
								</td>								
								<td colspan="2" class="infoData">								
									<select id="dept"></select>
								</td>	
								<td class="infoLabel">
									&nbsp;
								</td>
								<td style="vertical-align:top" colspan="2" class="infoData">
									<button type='button' style="float:right;font-size:20px;" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
									 onclick="submitAction('clear')">Reset</button>
									<button style="float:right;font-size:20px;" class = "ui-button ui-widget ui-state-default ui-corner-all ui-button-text-only"
									 onclick="submitAction('search')">Search</button>
								 </td>
							</tr>							
						</table>										
						<input type="hidden" name="dept" value="<%=(dept==null)?"":dept%>">
					</form>
					
					<display:table id="row" name="requestScope.staffList" export="false"  class="tablesorter" pagesize="200" sort="list">
						<display:column  title="Department" style="width:10%">
							<c:out value="${row.fields1}" />							
						</display:column>						
						<display:column  title="Staff ID" style="width:10%">
							<c:out value="${row.fields2}" />							
						</display:column>						
						<display:column  title="Staff Name" style="width:10%">
							<c:out value="${row.fields3}" />							
						</display:column>					
					</display:table>
				</DIV>
			</DIV>
		</DIV>
	</body>
</html:html>

<script type="text/javascript" >
	var apis = [];
	function submitAction(command) {			
		if(command == 'search') {
			showLoadingBox('body', 500, $(window).scrollTop());
			document.searchForm.submit();
		}else if(command == 'clear'){
			$('#contentFrame').find('input[name=staffID]').val('');
			$('#contentFrame').find('input[name=staffName]').val('');			
			$('#contentFrame').find('select#dept :nth-child(1)').attr('selected', 'selected');
			$('#contentFrame').find('input[name=dept]').val('ALL');
		}			
		return false;
	}
	
	
	
	function initScroll(pane) {
		destroyScroll();		
	$(pane).each(
			function()
			{
				apis.push($(this).jScrollPane({autoReinitialise:false}).data().jsp);
			}
		);
		return false;
	}
	
	function destroyScroll() {
		if (apis.length) {
			$.each(
				apis,
				function(i) {
					this.destroy();
				}
			);
			apis = [];
		}
		return false;
	}

	function createClickableRow(){		
		$('#row td').each(function(i,v) {	
			$(this).click(function(){				
				createPanel('','list',$.trim( $(this).parent('tr').find("td").eq(1).html()));
			});
		});
	}
	
	function saveRecord(type,ssID){
		showLoadingBox('body', 500, $(window).scrollTop());
		
		if(type=='save'){
			var staffID = 'staffID='  + $('div#staffRemarkPanel').find('#staffInfo').find('#staffID').html();
			var staffName = 'staffName=' + $('div#staffRemarkPanel').find('#staffInfo').find('#staffName').html();				
			var status = 'status=';
			var remark = 'remark=' + encodeURIComponent($('textarea#recordEntry').val());
			var servCategory = 'servCategory=' + $('div#inputEntryPanel').find('#inputEntryTable').find('#inputEntryInfoTable').find('#servCategory').html();
			var servItem = 'servItem=' + $('div#inputEntryPanel').find('#inputEntryTable').find('#inputEntryInfoTable').find('#servItem').html();
			var recordTime = 'recordTime=' + $('select[name=recordDate_hh] :selected').val() + ':' + $('select[name=recordDate_mi] :selected').val() ;
			var recordDate = 'recordDate=' +  $('select[name=recordDate_dd] :selected').val() + '/' + $('select[name=recordDate_mm] :selected').val() + '/' + $('select[name=recordDate_yy] :selected').val();
			//alert(remark)
			var baseUrl ='../chaplaincy/staffVisitHistory.jsp?action=insert';		
			var url = baseUrl + '&' + staffID + '&' + staffName  + '&' + status + '&' + remark + '&' + servCategory + '&' + servItem + '&' + recordDate + '&' + recordTime;	
			
			$.ajax({
				url: url,
				async: false,
				cache:false,
				success: function(values){					
					if(values) {
						if(values.indexOf('true') > -1) {
							alert('Record Added Successfully.');	
							
							closeInputEntryPanel();
							getViewRecord('','list', $('div#staffRemarkPanel').find('#staffInfo').find('#staffID').html());
							$('textarea#recordEntry').val('') ;							
							}						
						else {
							alert('Error occured while adding record.');
						}
					}
				},
				error: function() {
					alert('Error occured while adding record.');
					
				}
			});
		}else if(type=='edit'){
			
			var remark = 'remark=' + encodeURIComponent($('textarea#recordEntry').val());
			var editDate = 'editDate=' + $('select[name=editDate_dd] :selected').val() + '/' + $('select[name=editDate_mm] :selected').val() + '/' + $('select[name=editDate_yy] :selected').val();
			var editTime = 'editTime=' + $('select[name=editDate_hh] :selected').val() + ':' + $('select[name=editDate_mi] :selected').val();
			var baseUrl ='../chaplaincy/staffVisitHistory.jsp?action=edit';	
			var staffID = 'staffID='  + $('div#staffRemarkPanel').find('#staffInfo').find('#staffID').html();
			
			var url = baseUrl + '&' + remark+ '&ssID='+ssID + '&' + editDate + '&' + editTime + '&' + staffID;
			
			$.ajax({
				url: url,
				async: false,
				cache:false,
				success: function(values){
					if(values) {
						if(values.indexOf('true') > -1) {	
							alert('Record Added Successfully.');	
							
							getViewRecord('','list', $('div#staffRemarkPanel').find('#staffInfo').find('#staffID').html());							
							 createPanel('','editRecord','',ssID);							 
							 closeInputEntryPanel() ;							 							
						}
						else {
							alert('Error occured while updating record.');
						}
					}
				},
				error: function() {
					alert('Error occured while updating record.');
				}
			});
		}
	
		hideLoadingBox('body', 500);	
	}
	
	function editRemark(ssID){		
		 createPanel('','editRecord','',ssID);		
	}
	
	function deleteRemark(ssID){			
		   var deleteRemark = confirm("Delete remark ?");
		   if( deleteRemark == true ){	
			  showLoadingBox('body', 500, $(window).scrollTop());				
			  var staffID = 'staffID='  + $('div#staffRemarkPanel').find('#staffInfo').find('#staffID').html();
		      var baseUrl ='../chaplaincy/staffVisitHistory.jsp?action=delete' + '&' + staffID;		
				var url = baseUrl + '&ssID=' + ssID;	
				$.ajax({
					url: url,
					async: false,
					cache:false,
					success: function(values){
						if(values) {							
							if(values.indexOf('true') > -1) {																							
								getViewRecord('','list', $('div#staffRemarkPanel').find('#staffInfo').find('#staffID').html());
								
							}
							else {
								alert('Error occured while deleteing record.');
							}
						}
					},
					error: function() {
						alert('Error occured while deleteing record.');
					}
				});
				
				hideLoadingBox('body', 500);	
				
		   }else{		      			
		   }
	}
	
	function createPanel(button_id,type,staffID,ssID){
		if(type=="list"){
			staffBasicInfo(staffID);
			getViewRecord('',type,staffID);
				
			$('div#overlay').css('height', $(document).height());
			$('div#overlay').css('width', $(document).width());
			$('div#overlay').css('display', '');
			
			$('div#staffRemarkPanel').css('top', $(window).scrollTop());
			$('div#staffRemarkPanel').css('left', 5);
			$('div#staffRemarkPanel').css('display', '');
		}
		else if(type == 'record' || type == 'editRecord'){
			$('div#overlay').css('z-index', '15');
			$('div#inputEntryPanel').css('top', $(window).scrollTop()+($(window).height()-$('div#inputEntryPanel').height())/2);
			$('div#inputEntryPanel').css('left', ($(window).width()-$('div#inputEntryPanel').width())/2);
			$('div#inputEntryPanel').css('display', '');
			if(type == 'record'){
				getViewRecord(button_id,type);
			}
			else{
				getViewRecord('',type,'',ssID);
			}
		}
	}
	
	function getViewRecord(button_id,type,staffID,ssID) {	
		var baseUrl ='../chaplaincy/staffVisitHistory.jsp?action=view&serType=chaplaincy';			
		var url='';		
		if(type == 'list'){			
				var getListParam ='&getList=Y' +'&staffID='+staffID;
				url = baseUrl + getListParam;				
			}
		else if(type == 'record'){			
				var setRecordParam ='&setRecord=Y'+'&buttonID=' + button_id;
				url = baseUrl + setRecordParam;
			}
		else if(type == 'editRecord'){				
			var editRecordParam ='&editRecord=Y'+'&ssID=' + ssID;			
			url = baseUrl + editRecordParam;
		}		
		$.ajax({
			url: url,
			async: true,
			cache:false,
			success: function(values){
				if(values) {					
					if(type=='list') {
						$('#staffRemarkList').html(values);
						selectRecordEvent();						
						apis[0].reinitialise();						
					}
					else if(type=='record' || type=='editRecord'){
						$('#inputEntryInfoTable').html(values);						
					}					
				}
				hideLoadingBox('body', 500);				
				resizeStaffRemarkPanel();
			},
			error: function() {
				alert('Error occured.');
			}
		});
	}
	
	function closeStaffRemarkPanel() {
		$('div#staffRemarkPanel').css('display', 'none');
		showLoadingBox('body', 500, $(window).scrollTop());
		$('div#loadingListDiv').css('left', $(document).width()/2-$('div#loadingListDiv').width()/2);
		$('div#loadingListDiv').css('top', $(window).scrollTop()+$(window).height()/2-$('div#loadingListDiv').height()/2);
		$('div#loadingListDiv').css('display', '');
		
		hideLoadingBox('body', 500);
		$('div#overlay').css('display', 'none');
		$('div#loadingListDiv').css('display', 'none');
	}
	
	function closeInputEntryPanel() {		
		$('button.record').each(function(i, v) {
			if(this.id == 'Chronological_History_Show'){											
			}else if(this.id == 'Chronological_History_Hide'){
			
			}				
			else{
				$(this).removeClass('selected');
			}
		});				
		$('div#overlay').css('z-index', '12');
		$('div#inputEntryPanel').css('display', 'none');
	}
	
	function selectRecordEvent() {		
		$('button.record').each(function(i, v) {
			if(this.id == 'Chronological_History_Show'){
				$(this).click(function() {		
					$('button#Chronological_History_Hide').addClass('selected');	
					$('button#Chronological_History_Hide').css('display', '');
					$('div#chronologicalRow').css('display', '');
					$(this).css('display', 'none');					
					apis[0].reinitialise();
				});								
			}else if(this.id == 'Chronological_History_Hide'){
				$(this).click(function() {	
					$(this).removeClass('selected');
					$('div#chronologicalRow').css('display', 'none');
					$(this).css('display', 'none');
					$('button#Chronological_History_Show').css('display', '');					
					apis[0].reinitialise();
				});	
			}else if(this.id == 'Staff_Contact_Info_Show'){
				$(this).click(function() {	
					$('button#Staff_Contact_Info_Hide').addClass('selected');	
					$('button#Staff_Contact_Info_Hide').css('display', '');				
					$('div#StaffContactInfo').css('display', '');
					$(this).css('display','none');					
					resizeStaffRemarkPanel();
				});	
			}else if(this.id == 'Staff_Contact_Info_Hide'){
				$(this).click(function() {	
					$(this).removeClass('selected');
					$('div#StaffContactInfo').css('display', 'none');
					$(this).css('display', 'none');
					$('button#Staff_Contact_Info_Show').css('display', '');					
					resizeStaffRemarkPanel();
				});	
			}else if(this.id == 'Primary_Contact_Info_Show'){
				$(this).click(function() {	
					$('button#Primary_Contact_Info_Hide').addClass('selected');	
					$('button#Primary_Contact_Info_Hide').css('display', '');					
					$('div#primaryContactInfo').css('display', '');
					$(this).css('display','none');					
					resizeStaffRemarkPanel();
				});	
			}else if(this.id == 'Primary_Contact_Info_Hide'){
				$(this).click(function() {	
					$(this).removeClass('selected');
					$('div#primaryContactInfo').css('display', 'none');				
					$(this).css('display', 'none');
					$('button#Primary_Contact_Info_Show').css('display', '');					
					resizeStaffRemarkPanel();
				});	
			}else{
				$(this).click(function() {				
					$(this).addClass('selected');	
					createPanel(this.id,'record');
				});
			}			 
		});		
	}
	
	function resizeStaffRemarkPanel(){	
		$('#staffRemarkPanel').height( $('#staffRemarkTable').height() + 8);		
	}
		
	function staffBasicInfo(staffID) {	
		var baseUrl ='../chaplaincy/trackingLogHeader.jsp?';		
		var url = baseUrl + '&type=staff' + '&staffID='+ staffID;		
		$('#staffInfo').html('');
		
		$.ajax({
			url: url,
			async: true,
			cache:false,
			success: function(values){				
				if(values) {						
						$('#staffInfo').html(values);
						if($('#team20DateCB').is(':checked')){
							$('span[name = team20ShowSpan]').show();
						}else{
							$('span[name = team20ShowSpan]').hide();
						}
				}
			},
			error: function() {
				alert('Error occured while updating record.');
			}
		});			
	}
	
	function getDeptCode(type, val) {
		$.ajax({
			url: "../ui/deptCodeCMB.jsp",
			async: false,
			cache:false,
			data: "allowAll=Y"+"&deptCode="+val,
			success: function(values){
			
				$('select#'+type.toLowerCase()).html("<option value='ALL'>ALL</option>"+values);			
				selectEvent(type);
				
		},
			error: function() {
				alert('error');
			}
		});
	}
	
	function selectEvent(type) {
		$('select#'+type.toLowerCase()).change(function() {
			$('option:selected', this).each(function(){
				$('input[name='+type.toLowerCase()+']').val(this.value);
		    });
		}).trigger('change');
	}
	
	function updateStaffInvolvement(staffID, type , subType){
		showLoadingBox('body', 500, $(window).scrollTop());			
			
		$.ajax({
			url: '../chaplaincy/staffVisitHistory.jsp?action=insertInvolvement'+ 
				'&staffID='+staffID+'&type='+type+'&subType='+subType+'&isChecked='+$('#'+subType).is(':checked'),
				async: false,
				cache:false,
				success: function(values){
					if(values) {									
						if(values.indexOf('false') > -1) {									
							alert("Error occured while updating staff involvement.");
						}else{
							if(type=='memberships' && subType=='team20DateCB'){
								if($('#team20DateCB').is(':checked')){
									$('span[name = team20ShowSpan]').show();
								}else{
									$('span[name = team20ShowSpan]').hide();
								}
							}
						}
					}
				},
				error: function() {
					alert('Error occured.');
				}
		});
		
		hideLoadingBox('body', 500);
	}
	
	function actionStaffTeam20Date(module,staffID,type,subType){
		if(module=="edit"){
			$('span[name=team20LabelSpan]').hide();
			$('span[name=team20DateSpan]').show();
			
		}else if (module == "save"){
			showLoadingBox('body', 500, $(window).scrollTop());	
			var team20Day = $('select[name=team20Date_dd]').val();
			var team20Month = $('select[name=team20Date_mm]').val();
			var team20Year = $('select[name=team20Date_yy]').val();
			$.ajax({
				url: '../chaplaincy/staffVisitHistory.jsp?action=insertTeam20Date'+ 
					'&staffID='+staffID+'&team20Day='+team20Day+'&team20Month='+team20Month+'&team20Year='+team20Year
					+'&type='+type+'&subType='+subType,
					async: false,
					cache:false,
					success: function(values){
						if(values) {									
							if(values.indexOf('false') > -1) {									
								alert("Error occured while updating staff involvement.");
							}else{				
								staffBasicInfo(staffID);
								alert('Staff Team 20 Effective Date updated.');
							}
						}
					},
					error: function() {
						alert('Error occured.');
					}
			});
			
			hideLoadingBox('body', 500);
		}else if (module == "cancel"){
			$('span[name=team20LabelSpan]').show();
			$('span[name=team20DateSpan]').hide();
					
		}else if(module == "remove"){
			var removeEffectiveDate = confirm("Remove Team 20 Effective Date ?");
			if( removeEffectiveDate == true ){	
				$.ajax({
					url: '../chaplaincy/staffVisitHistory.jsp?action=removeTeam20Date'+ 
						'&staffID='+staffID	+'&type='+type+'&subType='+subType,
						async: false,
						cache:false,
						success: function(values){
							if(values) {									
								if(values.indexOf('false') > -1) {									
									alert("Error occured while removing Team 20 Effective Date.");
								}else{		
									staffBasicInfo(staffID);
									alert('Staff Team 20 Effective Date removed.');
								}
							}
						},
						error: function() {
							alert('Error occured.');
						}
				});
			}
		}
	}
	
		
	$(document).ready(function() {			
		showLoadingBox('body', 500, $(window).scrollTop());
		$('div#overlay').css('height', $(document).height());
		$('div#overlay').css('width', $(document).width());
		$('div#overlay').css('display', '');
		$('div#overlay').css('z-index', '12');
		$('div#loadingListDiv').css('left', $(document).width()/2-$('div#loadingListDiv').width()/2);
		$('div#loadingListDiv').css('top', $(window).scrollTop()+$(window).height()/2-$('div#loadingListDiv').height()/2);
		$('div#loadingListDiv').css('display', '');
		
		createClickableRow();
		
		getDeptCode('Dept', $('input[name=dept]').val());
		
		hideLoadingBox('body', 500);		
		$('div#overlay').css('display', 'none');
		$('div#loadingListDiv').css('display', 'none');
		initScroll('.scroll-pane');
	
	});
</script>