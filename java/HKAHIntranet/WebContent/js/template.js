/**
 * 
 */
var apis = [];
var template_loc = "div.template";
var template_menu_loc = "div#template-menu";
var template_menu_item_loc = ".template-menu-item";
var template_content_loc = "div#template-content";
var template_content_container_loc = 'div#template-content-container form';
var template_content_pane_loc = 'div.template-content-pane';
var view_type = ["Category", "Page"];
var currentViewIndex;

function loading() {
	showOverLay('body');
	showLoadingBox('body', 500);
}

function endLoading() {
	hideLoadingBox('body', 500);
	hideOverLay('body');
}

function setTemplateSize(width, height) {
	if(width) {
		$(template_loc).css("width", width);
	}
	if(height) {
		$(template_loc).css("height", height);
	}
	else {
		$(template_loc).css("height", ($(window).height()* 0.9));
	}
}

function handleRadioGroup() {
	$('input[type=radio]').click(function() {
		var grpName = $(this).attr('name');
		
		$('input:radio[name='+grpName+']').attr('selected', 'N').attr('checked', false);
		$(this).attr('selected', 'Y');
		$(this).attr('checked', true);
	});
}

function moveBackToContainer() {
	$(template_content_loc+' .jspPane').find(template_content_pane_loc)
		.each(function(i, v) {
		var target = $(template_content_container_loc)
		 				.find(template_content_pane_loc+':first');
		if(parseInt($(v).attr('order')) < parseInt(target.attr('order'))) {
			$(v).css('display', 'none');
			target.before($(v));
		}
		else {
			$(v).appendTo(template_content_container_loc).css('display', 'none');
		}
	});
}

function reinitContentForm() {
	$(template_content_loc+' div:first').data('jsp').reinitialise();
	 
	 //after reinit, the radio group cannot perform the checked value
	 $(template_content_loc+' .jspPane')
	 		.find('input:radio[selected=Y]').attr('checked', true);
	 
	 endLoading();
}

function selectTemplateItemEvent() {
	$(template_menu_loc+' '+template_menu_item_loc).unbind('click');
	$(template_menu_loc+' '+template_menu_item_loc).click(function() {
		 loading();
		 $(template_menu_loc+' .selected').removeClass('selected');
		 $(this).addClass('selected');
		 moveBackToContainer();
		 //$(template_content_loc+' .jspPane').find(template_content_pane_loc)
	 	 //		.appendTo(template_content_container_loc).css('display', 'none');
		 
		 if(view_type[currentViewIndex].toLowerCase() == "category") {
			 $(template_content_container_loc)
			 	.find('div[templateCategoryId='+$(this).attr('templateCategoryId')+']')
			 	.appendTo($(template_content_loc+' .jspPane')).css('display', '');
		 }
		 else if(view_type[currentViewIndex].toLowerCase() == "page") {
			 $(template_content_container_loc)
			 	.find('div[pageID='+$(this).attr('pageID')+']')
			 	.appendTo($(template_content_loc+' .jspPane')).css('display', '');
		 }
		 
		 setTimeout(reinitContentForm, 300);
	 });
}

function fetchMenu() {
	$(template_menu_loc+' .jspPane').html('');
	$(template_menu_loc+' .jspPane')
		.html($("div#template-menu-"+view_type[currentViewIndex].toLowerCase()).html())
		.css('display', '');
	$(template_menu_loc+' div.template-menu-pane').data('jsp').reinitialise();
	selectTemplateItemEvent();
}

function changeViewType() {
	$("div.left_choice").click(function() {
		if(currentViewIndex == 0) {
			currentViewIndex = view_type.length-1;
		}
		else {
			currentViewIndex--;
		}

		$("div.viewType").html(view_type[currentViewIndex]);
		fetchMenu();
	});
	$("div.right_choice").click(function() {
		if(currentViewIndex == (view_type.length-1)) {
			currentViewIndex = 0;
		}
		else {
			currentViewIndex++;
		}
		
		$("div.viewType").html(view_type[currentViewIndex]);
		fetchMenu();
	});
}

function findViewTypeIndex(type) {
	$.each(view_type, function(i, v) {
		if($.trim(v) == $.trim(type)) {
			currentViewIndex = i;
		}
	});
}

function initScroll(target, autoReinitialise) {
	//destroyScroll();
	$(target).find('.scroll-pane').each(
			function()
			{
				apis.push($(this).jScrollPane({autoReinitialise:autoReinitialise}).data().jsp);
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

function resize() {
	$(template_menu_loc+' div.template-menu-pane').data('jsp').reinitialise();
	$(template_content_loc+' div.template-content-pane').data('jsp').reinitialise();
}

function submitEvent() {
	$('.template-button-set').find('button').click(function() {
		var answer = confirm("Do you confirm?");
		
		if(answer) {
			var oDate = new Date();	
			$(template_menu_loc+' .selected').removeClass('selected');
			moveBackToContainer();
			var command = $(this).attr('id');
			$('input[name=command]').val($(this).attr('id'));
			
			if(command == 'submit' || command == 'delete') {
				loading();
				
				$.ajax({
					type: 'POST',
					url: "../template/save.jsp?callback=?",
					data: $('form[name=templateForm]').serialize(),
					dataType: "jsonp",
					async: false,
					success: function(values) {
						endLoading();
						$(values).each(function(i, v) {
							if(values.success) {
								if(command == 'delete') {
									var url = template_view_url
												.substring(0, 
													((template_view_url.indexOf("?") > -1)?
														template_view_url.indexOf("?"):
															template_view_url.length));
									
									window.open(url, "_self");
								}
								else {
									var url = template_view_url;
									
									if(template_view_url.indexOf("?") > -1) {
										url += "&";
									}
									else {
										url += "?";
									}
									//remove window cacheing displaying old result									
									url += "reportID="+values.reportID+"&qt="+oDate.getTime();
									
									window.open(url, "_self");
								}
							}
							else {
								alert(values.errMsg);
							}
						});
					},
					error: function() {
						endLoading();;
						alert("Error: Ajax Error");
					}
				});
			}
			else if(command == 'edit'){
				var url = template_edit_url;
				
				if(template_edit_url.indexOf("?") > -1) {
					url += "&";
				}
				else {
					url += "?";
				}
				
				//remove window cacheing displaying old result					
				url += "reportID="+$('input[name=reportID]').val()+"&qt="+oDate.getTime();				
				window.open(url, "_self");
			}
			else if(command == 'cancel') {
				var url = template_view_url;
				
				if(template_edit_url.indexOf("?") > -1) {
					url += "&";
				}
				else {
					url += "?";
				}
								
				//remove window cacheing displaying old result					
				url += "reportID="+$('input[name=reportID]').val()+"&qt="+oDate.getTime();	
				window.open(url, "_self");
			}
		}
	});
}

function getMstsName(mstsCode){		
	if(mstsCode=='S'){
		mstsCode='Single';
	}else if(mstsCode == 'M'){
		mstsCode='Married';
	}
	return mstsCode;
}

function getRelName(relCode){		
	if(relCode=='CH'){
		relCode='CHRISTIAN';
	}else if(relCode == 'SH'){
		relCode='SHINTOISM';
	}else if(relCode == 'HI'){
		relCode='HINDUISM';
	}else if(relCode == 'OT'){
		relCode='OTHERS';
	}else if(relCode == 'BU'){
		relCode='BUDDHISM';
	}else if(relCode == 'CA'){
		relCode='CATHOLIC';
	}else if(relCode == 'SD'){
		relCode='SDA';
	}else if(relCode == 'NO'){
		relCode='NONE';
	}else if(relCode == 'PR'){
		relCode='PROTESTANT';
	}	
	return relCode;
}

function setAutoFillBasicInfo(){
	$('input[templatecontentid=2]').blur(function(evt) {
		if($('input[templatecontentid=2]').val()){
			$.ajax({
				url: "../ui/patientInfoCMB.jsp?callback=?",
				data: "patno="+$('input[templatecontentid=2]').val(),
				dataType: "jsonp",
				async: false,
				cache:false,
				dataType: "jsonp",
				success: function(values){					
					$('input[templatecontentid=3]').val(values['PATFNAME']);
					$('input[templatecontentid=4]').val(getMstsName(values['PATMSTS']));
					$('input[templatecontentid=5]').val(values['PATGNAME']);
					
					$('input[templatecontentid=6]').val(getRelName(values['RELIGIOUS']));					
					if(values['PATSEX']=='F'){	
						$("input[templatecontentid=7]:eq(0)").attr("checked", "checked");						
					}else if(values['PATSEX']=='M'){						
						$("input[templatecontentid=7]:eq(1)").attr("checked", "checked");						
					}else{
						$("input[templatecontentid=7]").removeAttr("checked");
					}
					$('input[templatecontentid=8]').val(values['AGE']);
					$('input[templatecontentid=9]').val(values['PATBDATE']);
					$('input[templatecontentid=10]').val(values['OCCUPATION']);
					$('input[templatecontentid=11]').val(values['EMERPERSON']);
					
				},
				error: function(x, s, e) {
					
				}
			});
		}
	});
}

function setFirstLetterCap(){
	$('input[templatecontentid=3]').keyup(function(evt) {
		capitalize(this);
	});
	$('input[templatecontentid=5]').keyup(function(evt) {
		capitalize(this);
	});
}

function setMultiTextArea(type,obj){	
	if(type=='create'){
		var newRow = $(obj).parents().eq(1).clone();
		$(newRow).find(".createIMG").remove();	
		$(newRow).find("input").val("");
		$(newRow).find("td").append('<a class="createIMG" href="javascript:void(0)" onclick="setMultiTextArea(\'remove\',this);">' + 
							'<img width="10" height="10"  src="../images/remove-button.gif"></a>');
		
		var mainBody = $(obj).parents().eq(2);		
		//alert($(firstRow).html());
		$(mainBody).append('<tr style="height:auto">'+$(newRow).html()+'</tr>');
	}else if(type=='remove'){
		$(obj).parents().eq(1).remove();
	}
}

function setNumberOnly(){	
	$('.numbersOnly').keypress(function(event) {		
		  // Backspace, tab, enter, end, home, left, right
		  // We don't support the del key in Opera because del == . == 46.
		  var controlKeys = [8, 9, 13, 35, 36, 37, 39];
		  // IE doesn't support indexOf
		  var isControlKey = controlKeys.join(",").match(new RegExp(event.which));
		  // Some browsers just don't raise events for control keys. Easy.
		  // e.g. Safari backspace.
		  if (!event.which || // Control keys in most browsers. e.g. Firefox tab is 0
		      (48 <= event.which && event.which <= 57) || // Always 1 through 9
		      isControlKey) { // Opera assigns values for control keys.
		    return;
		  } else {
		    event.preventDefault();
		  }
	});
}

function capitalize(input){	
	if (input.value.charAt(0) != input.value.charAt(0).toUpperCase()){
	    input.value = input.value.replace(input.value.charAt(0),input.value.charAt(0).toUpperCase());	
	}
}

$(document).ready(function() {
	setTemplateSize();
	initScroll("div.template", false);
	findViewTypeIndex($("div.viewType").html());
	changeViewType();
	handleRadioGroup();
	
	$(window).bind('resize', resize);
	
	fetchMenu();
	$(template_menu_loc+' '+template_menu_item_loc+":first").trigger('click');
	
	submitEvent();
	
	if(!template_view_url) {
		alert("Please declare the url of viewing report");
	}
	if(!template_edit_url) {
		alert("Please declare the url of editing report");
	}
	
	setAutoFillBasicInfo();
	setFirstLetterCap();
	setNumberOnly();
});