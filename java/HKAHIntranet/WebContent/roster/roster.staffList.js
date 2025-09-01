/**
 * version 0.1 for ../roster/staffList.jsp 
 */
var gridWidth, gridHeight;
var editLastValue = "";
var lastClickInput = "";

function showAlertDialog(alertMsg) {
	$('#alertDialog').css('left', $(window).width()/2-$('#alertDialog').width()/2);
	$('#alertDialog').css('top', $(window).height()/2-$('#alertDialog').height()/2);
	
	$('#alertMsg').html(alertMsg);
	
	showOverLay('body', 100);
	$('#alertDialog').show();
}

function showAddDialog() {
	$('#addDialog').css('left', $(window).width()/2-$('#addDialog').width()/2);
	$('#addDialog').css('top', $(window).height()/2-$('#addDialog').height()/2);
	$('#submitAdd').attr('disabled', true);
	$('#staffNameValue').html('');
	$('input#addStaffID').val('');
	$('#deptValue').html('');
	$('#postValue').val('');
	$('#inchargeValue').attr('checked', false);
	$('.emptyAlert').remove();
	
	$('#addDialog').show();
}

function submitDialogBtnEvent() {
	$('.submitDialogBtn').click(function() {
		if ($(this).attr('id') === 'submitDelete') {
			showLoadingBox('body', 100);
			showOverLay('body', 110);
			
			var selectIndex = $('#rosterStaffGrid').jqGrid('getGridParam','selrow');
			var selectedStaffID = $('#rosterStaffGrid').jqGrid('getCell', selectIndex, 'staffID');
			
			$.ajax({
				url: '../roster/staffListCMB.jsp',
				data: 'action=delete&staffID='+selectedStaffID,
				cache: false,
				async: false,
				type: 'POST',
				success: function (data, textStatus, jqXHR) {
							$('.cancelDialogBtn').trigger('click');
							hideLoadingBox('body', 100);
							
							if ($.trim(data) == 'true') {
								showAlertDialog('Success');
								$('#rosterStaffGrid').trigger("reloadGrid");
							}
							else {
								showAlertDialog('Fail');
							}
						 },
				error: function(x, s, e) {
							$('.cancelDialogBtn').trigger('click');
							hideLoadingBox('body', 100);
							
							showAlertDialog("Error in Add Staff");
					   }
			});
		}
		else if ($(this).attr('id') === 'submitAdd') {
			if ($('#postValue').val().length > 0) {
				showLoadingBox('body', 100);
				showOverLay('body', 110);
				
				$.ajax({
					url: '../roster/staffListCMB.jsp',
					data: 'action=add&staffID='+$('input#addStaffID').val()+
							'&post='+$('#postValue').val()+
							'&incharge='+$('#inchargeValue').attr('checked'),
					cache: false,
					async: false,
					type: 'POST',
					success: function (data, textStatus, jqXHR) {
								$('.cancelDialogBtn').trigger('click');
								hideLoadingBox('body', 100);
								
								if ($.trim(data) == 'true') {
									showAlertDialog('Success');
									$('#rosterStaffGrid').trigger("reloadGrid");
								}
								else {
									showAlertDialog('Fail');
								}
							 },
					error: function(x, s, e) {
								$('.cancelDialogBtn').trigger('click');
								hideLoadingBox('body', 100);
								
								showAlertDialog("Error in Add Staff");
						   }
				});
			}
			else {
				$('#postValue').after('<div class="emptyAlert"><span style="color:red">Please fill it.</span></div>');
			}
		}
	});
}

function cancelDialogBtnEvent() {
	$('.cancelDialogBtn').click(function() {
		$this = $(this).parent();
		while ($this.parent()[0].tagName !== 'BODY') {
			$this = $this.parent();
		}
		$this.hide();
		hideOverLay('body');
	});
}

function editChangeEvent() {
	$("#rosterStaffGrid").find('input.editable').unbind('change');
	$("#rosterStaffGrid").find('input.editable').change(function() {
		$(this).parent().parent().addClass('data-changed');
	});
}

function generateRosterStaffGrid() {
	$("#rosterStaffGrid").jqGrid({
		url: "../roster/staffListCMB.jsp?action=view",
		datatype: "json",
		jsonReader: {
		    repeatitems: false
		},
		colNames: ['Staff ID', 'Staff Name', 'Post', 'In-Charge'], 
		colModel: [ 
		            {
		            	name: 'staffID', 
		            	index: 'staffID', 
		            	width: gridWidth/8, 
		            	editable: false, 
		            	sortable: false
		            },
		            {
		            	name: 'staffName', 
		            	index: 'staffName', 
		            	width: gridWidth/3, 
		            	editable: false, 
		            	sortable: false 
		            },
		            {
		            	name: 'post', 
		            	index: 'post', 
		            	width: gridWidth/3, 
		            	editable: true, 
		            	sortable: false 
		            },
		            {
		            	name: 'incharge', 
		            	index: 'incharge', 
		            	width: gridWidth/7, 
		            	editable: true, 
		            	sortable: false,
		            	formatter: 'checkbox',
		            	edittype: "checkbox"
		           	}
		          ],
		rowNum: 100, 
		rowList: [], 
		viewrecords: true, 
		shrinkToFit: true, 
		caption: "Roster - Staff List ("+deptDesc+')', 
		width: gridWidth, 
		height: gridHeight,
		pager: '#rosterStaffPager',
		onSelectRow: function(rowid, status, e) {
		},
		loadComplete: function(data) {
			//gridResize();
		},
		loadError: function(xhr, status, error) {
			alert('[generateRosterStaffGrid]\nHTTP status code: ' + xhr.status + '\n' +
		              'textStatus: ' + status + '\n' +
		              'errorThrown: ' + error);
		},
		beforeProcessing: function(data, status, xhr) {
		},
		gridComplete: function() {
			$('#rosterStaffGrid-cancelall').hide();
		}
	});
	
	$("#rosterStaffGrid").jqGrid(
			'navGrid',"#rosterStaffPager",
			{	
				edit:false,
				add:false,
				del:false,
				search:false,
				refresh:false
			});
	$("#rosterStaffGrid").jqGrid(
			'inlineNav',"#rosterStaffPager", 
			{
				edit:false,
				add:false,
				del:false,
				save:false,
				cancel:false
			});
	$("#rosterStaffGrid").jqGrid(
			'bindKeys', 
			{
				onEnter: function(rowid) { 
						   		alert("You enter a row with id:"+rowid);
						   },
				scrollingRows: true
			});
	$("#rosterStaffGrid").jqGrid(
			'navButtonAdd',"#rosterStaffPager",
			{ 
			  	caption:"Add", 
			 	onClickButton: 
			 		function() {
			 			showOverLay('body', 100);
			 			showAddDialog();
				  	}, 
			  	position: "last", 
			  	title:"", 
			  	cursor: "pointer",
			  	buttonicon:"ui-icon-plus",
			  	id: "rosterStaffGrid-add"
			});
	$("#rosterStaffGrid").jqGrid(
			'navButtonAdd',"#rosterStaffPager",
			{ 
			  	caption:"Edit", 
			 	onClickButton: 
			 		function() {
			 			$('#rosterStaffGrid-cancelall').show();
			 			$('#rosterStaffGrid-editall').hide();
			 			$('#rosterStaffGrid-add').hide();
			 			$('#rosterStaffGrid-delete').hide();
			 			
					  	var $this = $('#rosterStaffGrid'), 
					  		ids = $this.jqGrid('getDataIDs'), 
					  		i, l = ids.length;
						for (i = l-1; i >= 0; i--) {
						    $this.jqGrid('editRow', ids[i], true);
						}
						$this.trigger('scroll');
						$this.jqGrid('resetSelection');
						
						//input change event
						editChangeEvent();
				  	}, 
			  	position: "last", 
			  	title:"", 
			  	cursor: "pointer",
			  	buttonicon:"ui-icon-pencil",
			  	id: "rosterStaffGrid-editall"
			});
	$("#rosterStaffGrid").jqGrid(
			'navButtonAdd',"#rosterStaffPager",
			{
				caption:"Cancel",
				onClickButton: 
			 		function() {
			 			$('#rosterStaffGrid-cancelall').hide();
			 			$('#rosterStaffGrid-editall').show();
			 			$('#rosterStaffGrid-add').show();
			 			$('#rosterStaffGrid-delete').show();
			 			
					  	$('#rosterStaffGrid').trigger("reloadGrid");
				  	}, 
			  	position: "last", 
			  	title:"", 
			  	cursor: "pointer",
			  	buttonicon:"ui-icon-cancel",
			  	id: "rosterStaffGrid-cancelall"
			});
	$("#rosterStaffGrid").jqGrid(
			'navButtonAdd',"#rosterStaffPager",
			{
				caption:"Delete",
				onClickButton: 
			 		function() {
			 			
					  	$('#rosterStaffGrid').trigger("reloadGrid");
				  	}, 
			  	position: "last", 
			  	title:"", 
			  	cursor: "pointer",
			  	buttonicon:"ui-icon-trash",
			  	id: "rosterStaffGrid-delete"
			});
}

function getStaffInfo(staffID) {
	$.ajax({
		url: "../ui/staffInfoCMB.jsp?callback=?",
		data: "staffid="+staffID,
		dataType: "jsonp",
		cache: false,
		success: function(values){
			$('#staffNameValue').html(values['STAFFNAME']);
			$('#deptValue').html(values['DEPTDESC']);
			$('#submitAdd').attr('disabled', false);
		},
		error: function(x, s, e) {
			$('#submitAdd').attr('disabled', true);
			$('#staffNameValue').html('<span style="color:red">No such staff!</span>');
			$('#deptValue').html('');
		}
	});
}

function staffIDFieldOnBlur() {
	$('input#addStaffID').blur(function() {
		$('#submitAdd').attr('disabled', true);
		getStaffInfo($(this).val());
	});
}

$(document).ready(function() {
	gridWidth = $(document).width()/1.15;
	gridHeight = $(document).height()/1.15;
	
	generateRosterStaffGrid();
	
	submitDialogBtnEvent();
	cancelDialogBtnEvent();
	staffIDFieldOnBlur();
});