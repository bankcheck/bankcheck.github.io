<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.constant.*"%>

<%
String templateCategoryID = request.getParameter("templateCategoryID");
String parentID = request.getParameter("contentParentID");
String column = request.getParameter("column");
String isMulti = request.getParameter("isMulti");
String pageID = request.getParameter("pageID");
String action = request.getParameter("action");
String reportID = request.getParameter("reportID");

ArrayList content = new ArrayList();
if(action.equals("new")) {
	if(parentID != null && parentID.length() > 0) {
		content = TemplateDB.getTemplateContentByParentID(parentID);		
	}
	else if(templateCategoryID != null && templateCategoryID.length() > 0) {
		content= TemplateDB.getTemplateContentByTemplateCategoryID(templateCategoryID);	
	}
}
else if(action.equals("view") || action.equals("edit")) {
	content = TemplateDB.getTemplateRecordAndContent(reportID, templateCategoryID, parentID, "1");
}
ReportableListObject row = null;

if(content.size() > 0) {
	int maxColumn = Integer.parseInt(column);
	int currentColumn = 0;
	if(maxColumn != 0) {
		int healthConcernRow = 0;
		
		for(int i = 0; i < content.size(); i++) {
			row = (ReportableListObject) content.get(i);
			
			int width = Integer.parseInt(row.getValue(8));
			int height = Integer.parseInt(row.getValue(9));
			int forMulti = Integer.parseInt(row.getValue(10));
			int level = Integer.parseInt(row.getValue(12));
			int needVal = Integer.parseInt(row.getValue(6));
			int promptWidth = Integer.parseInt(row.getValue(24));
			String format = row.getValue(3);
			String tab = "";
			boolean prompt = (row.getValue(2).length() > 0 && !format.equals("textarea"));
			String numOnly = "0";
			if(action.equals("new")){
				numOnly = row.getValue(25);
			}else if(action.equals("edit")){
				numOnly = row.getValue(29);
			}
			
			if(currentColumn == 0 && maxColumn != 0) {
%>
				<tr style='height:<%=(height==0?"auto":height+"px")%>'>
<%
			}
			currentColumn += Integer.parseInt(row.getValue(7));
			
			for(int k = 1; k < level; k++) {
				tab += "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp";
			}
			
			if(prompt) {
%>
					<td colspan="<%=(format.length() > 0)?1:Integer.parseInt(row.getValue(7)) %>" 
						width="<%=promptWidth%>%" style='height:<%=(height==0?"auto":height+"px")%>'>
						<%=tab+row.getValue(2) %>
					</td>
<%
			}
			
			if(format.length() > 0) {%>
					<td colspan="<%=Integer.parseInt(row.getValue(7))-((prompt)?1:0)%>" 
						width="<%=width-((prompt)?promptWidth:0)%>%" style='height:<%=(height==0?"auto":height+"px")%>'>
<%
				//name = templateContentID
				if(format.equals("input")) {
					if(action.equals("view")) {
%>
						<%=row.getValue(27)%>
<%
					}
					else if(action.equals("new") || action.equals("edit")) { 						
%>
						<input <%=("1".equals(numOnly)?"class='numbersOnly'":"") %>	optionType="input" type="text" name="<%=row.getValue(1)%>-group-1" 
							templateCategoryID="<%=templateCategoryID%>" 
							templateContentID="<%=row.getValue(1)%>" parentID="<%=row.getValue(4)%>" 
							style="width:70%;" templateRecordID="<%=action.equals("edit")?row.getValue(26):""%>" 
							recordGroupID="<%=action.equals("edit")?row.getValue(28):""%>" 
							value="<%=action.equals("edit")?row.getValue(27):""%>"/>&nbsp;
<%
						if(row.getValue(1).equals("12") ){
							if(healthConcernRow==0){
							healthConcernRow++;
%>						
								<a class="createIMG" href="javascript:void(0)" onclick="setMultiTextArea('create',this);">
									<img width="10" height="10" src="../images/plus.gif">
								</a>
<%
							}else{
%>						
								<a class="createIMG" href="javascript:void(0)" onclick="setMultiTextArea('remove',this);">
								<img width="10" height="10"  src="../images/remove-button.gif">
							</a>
<%						
							}
						}
					}
					
					if(row.getValue(5).length() > 0) {
						if(row.getValue(5).indexOf("[desc]") > -1) {
							String desc = row.getValue(5).substring(row.getValue(5).indexOf("]")+1);
%>
							<%=desc %>
<%
						}
					}
				}
				else if(format.equals("date")) {
					if(action.equals("view")) {
%>
						<%=row.getValue(27)%>
<%
					}
					else if(action.equals("new") || action.equals("edit")) {
%>
						<input optionType="date" type='textfield' class='datepickerfield' maxlength='16' size='16'
								name="<%=row.getValue(1)%>-group-1" 
								templateCategoryID="<%=templateCategoryID%>" templateContentID="<%=row.getValue(1)%>" 
								parentID="<%=row.getValue(4)%>" templateRecordID="<%=action.equals("edit")?row.getValue(26):""%>" 
								recordGroupID="<%=action.equals("edit")?row.getValue(28):""%>" 
								value="<%=action.equals("edit")?row.getValue(27):""%>"/>(DD/MM/YYYY)
<%				
					}
				}
				else if(format.equals("radio")) {
					if(action.equals("view")) {
%>
						<%=row.getValue(27)%>
<%
					}
					else if(action.equals("new") || action.equals("edit")) {
						String[] option = row.getValue(5).substring(row.getValue(5).indexOf("]")+1).split("\\|");
						
						for(int j = 0; j < option.length; j++) {
%>
							<input optionType="radio" type="radio" 
								name="<%=row.getValue(1)%>-group-1" value="<%=option[j] %>" 
								templateCategoryID="<%=templateCategoryID%>" templateContentID="<%=row.getValue(1)%>" 
								parentID="<%=row.getValue(4)%>" templateRecordID="<%=action.equals("edit")?row.getValue(26):""%>" 
								recordGroupID="<%=action.equals("edit")?row.getValue(28):""%>" 
								selected="<%=(action.equals("edit")?(row.getValue(27).equals(option[j])?"Y":"N"):"")%>" 
								<%=action.equals("edit")?(row.getValue(27).equals(option[j])?"checked":""):""%>/>&nbsp;<%=option[j] %>&nbsp;&nbsp;
<%
						}
					}
				}
				else if(format.equals("textarea")) {
					if(action.equals("view")) {
%>
						<%=tab+row.getValue(2) %><br/>
						<%=row.getValue(27).replaceAll("\r\n", "</br>")%>
						<br/>
<%
					}
					else if(action.equals("new") || action.equals("edit")) {
%>
						<%=tab+row.getValue(2) %><br/>
						<textarea optionType="textarea" 
							name="<%=row.getValue(1)%>-group-1" 
							templateCategoryID="<%=templateCategoryID%>" templateContentID="<%=row.getValue(1)%>" 
							parentID="<%=row.getValue(4)%>" style="width:90%" rows='5' 
							templateRecordID="<%=action.equals("edit")?row.getValue(26):""%>" 
							recordGroupID="<%=action.equals("edit")?row.getValue(28):""%>"><%=action.equals("edit")?row.getValue(27):""%></textarea>
<%
					}
				}
				else if(format.equals("select")) {					
					if(action.equals("view")) {
%>
						<%=row.getValue(27)%>						
<%
					}
					else if(action.equals("new") || action.equals("edit")) {
						String[] option = row.getValue(5).substring(row.getValue(5).indexOf("]")+1).split("\\|");
%>
						<select  optionType="select" 
							name="<%=row.getValue(1)%>-group-1" 
							templateCategoryID="<%=templateCategoryID%>" templateContentID="<%=row.getValue(1)%>" 
							parentID="<%=row.getValue(4)%>"
							templateRecordID="<%=action.equals("edit")?row.getValue(26):""%>" 
							recordGroupID="<%=action.equals("edit")?row.getValue(28):""%>">
							<option value=""></option>
<%
						for(int j = 0; j < option.length; j++) {
%>
							<option <%=action.equals("edit")?(row.getValue(27).equals(option[j])?"SELECTED":""):""%> 
							 value="<%=option[j]%>"><%=option[j]%></option>
<%
						}
%>
						</select>
<%
					}
				}	
				else if(format.equals("dropdowndate")) {					
					if(action.equals("view")) {
%>
						<%=row.getValue(27)%>						
<%
					}
					else if(action.equals("new") || action.equals("edit")) {
						String[] option ;			
						String day = "";
						String month = "";
						String year = "";
						if(action.equals("edit")){
							option = row.getValue(27).split("/");	
							if(option!=null){
								for(int k=0; k<option.length;k++){
									if(k==0){
										day = option[k];
									}else if(k==1){
										month = option[k];
									}else if(k==2){
										year = option[k];
									}
								}
							}
						}
						
%>						
						<select  optionType="dropdowndate" 
							name="<%=row.getValue(1)%>-day-group-1" 
							templateCategoryID="<%=templateCategoryID%>" templateContentID="<%=row.getValue(1)%>" 
							parentID="<%=row.getValue(4)%>"
							templateRecordID="<%=action.equals("edit")?row.getValue(26):""%>" 
							recordGroupID="<%=action.equals("edit")?row.getValue(28):""%>">
							<option value=""></option>
							<%for(int d = 1;d<32;d++){ %>
								<option <%=action.equals("edit")?(Integer.toString(d).equals(day)?"SELECTED":""):""%> 
								 value="<%=d%>"><%=d%></option>
							<%} %>
						</select>/
						<select  optionType="dropdowndate" 
							name="<%=row.getValue(1)%>-day-group-1" 
							templateCategoryID="<%=templateCategoryID%>" templateContentID="<%=row.getValue(1)%>" 
							parentID="<%=row.getValue(4)%>"
							templateRecordID="<%=action.equals("edit")?row.getValue(26):""%>" 
							recordGroupID="<%=action.equals("edit")?row.getValue(28):""%>">
							<option value=""></option>
							<%for(int m = 1;m<13;m++){ %>
								<option <%=action.equals("edit")?(Integer.toString(m).equals(month)?"SELECTED":""):""%> 
								 value="<%=m%>"><%=m%></option>
							<%} %>
						</select>/
						<select  optionType="dropdowndate" 
							name="<%=row.getValue(1)%>-day-group-1" 
							templateCategoryID="<%=templateCategoryID%>" templateContentID="<%=row.getValue(1)%>" 
							parentID="<%=row.getValue(4)%>"
							templateRecordID="<%=action.equals("edit")?row.getValue(26):""%>" 
							recordGroupID="<%=action.equals("edit")?row.getValue(28):""%>">
							<option value=""></option>
							<%for(int y = 2000;y<2101;y++){ %>
								<option <%=action.equals("edit")?(Integer.toString(y).equals(year)?"SELECTED":""):""%> 
								 value="<%=y%>"><%=y%></option>
							<%} %>
						</select>
						(DD/MM/YYYY)
<%
					}
				}				
				else if(format.equals("label")) {
%>
					<label><%=row.getValue(2) %></label>
<%	
				}
				else if(format.equals("table")) {
%>
					<label><%=row.getValue(2) %></label><br/>
					<jsp:include page='../template/template_table.jsp' flush='false'>
						<jsp:param name='tableID' value='<%=row.getValue(1) %>' />
						<jsp:param name='tableColumn' value='<%=row.getValue(7) %>' />
						<jsp:param name='tableIsMulti' value='<%=row.getValue(10) %>' />
						<jsp:param name='action' value='<%=action %>' />
						<jsp:param name='reportID' value='<%=reportID %>' />
						<jsp:param name='templateCategoryID' value='<%=templateCategoryID %>' />
					</jsp:include>
<%
				}
%>
					</td>
<%
			}
			if(currentColumn == maxColumn) {
				currentColumn = 0;
%>
				</tr>
<%
			}
			if(!format.equals("table")) {
%>
				<jsp:include page='../template/template_content.jsp' flush='false'>
					<jsp:param name='contentParentID' value='<%=row.getValue(1) %>' />
					<jsp:param name='column' value='<%=row.getValue(7) %>' />
					<jsp:param name='isMulti' value='<%=row.getValue(10) %>' />
					<jsp:param name='action' value='<%=action %>' />
					<jsp:param name='reportID' value='<%=reportID %>' />
				</jsp:include>
<%
			}
		}
	}
}
%>