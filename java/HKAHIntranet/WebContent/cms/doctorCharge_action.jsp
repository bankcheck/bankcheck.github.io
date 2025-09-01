<%@ page import="java.util.*"%>
<%@ page import="org.apache.struts.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.convert.Converter"%>
<%@ page import="java.io.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>

<%
String action = request.getParameter("action");
String pqCategory = request.getParameter("pqCategory");
String patType = request.getParameter("patType");
String itmCode = request.getParameter("itmCode");
String pkgCode = request.getParameter("pkgCode");
String option = request.getParameter("option");
String curItem = request.getParameter("curItem");
String pqItmPrefix = request.getParameter("pqItmPrefix");
String contrast = request.getParameter("contrast");
String timeslot = request.getParameter("timeslot");
String price = request.getParameter("price");
String docCode = request.getParameter("docCode");
String patno = request.getParameter("patno");
String dpcid = request.getParameter("dpcid");
String clickedBox = request.getParameter("clickedBox");
String contrastDesc = request.getParameter("contrastDesc");
String disabled = request.getParameter("disabled");
String regid = request.getParameter("regid");
String version = request.getParameter("version");
String userid = request.getParameter("userid");
String selectItem = request.getParameter("selectItem");
String source = request.getParameter("source");
String slpNo = request.getParameter("slpNo");
String unit = request.getParameter("unit");
String desc = request.getParameter("desc");
boolean inhats = "Y".equals(request.getParameter("inhats"));
String keyWord = request.getParameter("keyWord");
String printOpt = request.getParameter("printOpt");
String maxUnit = request.getParameter("maxUnit");
ArrayList record = new ArrayList();
ReportableListObject row = null;

if(keyWord == null || "".equals(keyWord)){
	keyWord = "NOTSEARCH";
}

%>
<% if("addItm".equals(action)){ 
		record = DoctorChargeDB.currentItem(slpNo, patType, itmCode,docCode, "", "1", "DPC");
		if(record.size() > 0){
			row = (ReportableListObject) record.get(0);
			if(Integer.parseInt(row.getValue(5)) >= 0){
%>
	<tr class="eachitem" id="<%=pqCategory %><%=itmCode %>">
		<td>
			<span class="INHATS" style="display:none;"><%=inhats?"Y":"N" %></span> 
			<%if(inhats) {  %>
			IN HATS
			<%} else { %>
			<button class="removeitem" onclick="removeItem('<%=pqCategory %><%=itmCode %>')">X</button>
			<%} %>
		</td>
		<td class="itmCode" >
			<%=row.getValue(1).length()>0?row.getValue(1):"" %>
		</td>
		<td class="pkgCode" style="display:none">
			<%=row.getValue(0).length()>0?row.getValue(0):"" %>
		</td>
		<td class="itmDesc">
			<%=row.getValue(9) %><br>
			<input id="desc" class="w3-input w3-border w3-light-grey desc" type="text"  value="<%=desc == ""?"":desc %>" <%=inhats?"disabled":"" %>></input>
			
		</td>	
		<td>
			<input id="unit" class="w3-input w3-border w3-light-grey unit unitInput" type="text"  maxUnit="<%=maxUnit %>" value="<%=unit == ""?"1":unit %>" onchange="chgPrice('<%=pqCategory %><%=itmCode %>')" <%=inhats?"disabled":"" %>></input>
			<button class="w3-button w3-circle w3-black w3-tiny add" onclick="chgUnit('<%=pqCategory %><%=itmCode %>','+')" <%=inhats?"disabled":"" %>>+</button>
			<button class="w3-button w3-circle w3-teal w3-tiny less" onclick="chgUnit('<%=pqCategory %><%=itmCode %>','-')" <%=inhats?"disabled":"" %>>-</button>
		<td>
			$<input id="price" class="w3-input w3-border w3-light-grey price" type="text" style="width:80%; display:inline !important;" value="<%=price== ""?row.getValue(4):price %>" hatPrice="<%=row.getValue(4) %>" oriPrice="<%=price==""?row.getValue(4):price %>"  onchange="chgPrice('<%=pqCategory %><%=itmCode %>')" <%=inhats?"disabled":"" %>></input>
		</td>
		<td class="itemTotal"><%=(price != "" && unit != "")?Integer.parseInt(price)*Integer.parseInt(unit):row.getValue(4) %></td>
	</tr>
	<script language="JavaScript">
<%-- 	var itmSum = parseInt($('#itmSum', top.frames['summary'].document).text()) + parseInt("<%=row.getValue(4) %>");
	alert($('#itmSum', top.frames['summary'].document).text()); --%>
	$('#itmSum', top.frames['summary'].document).text(chgAmount());
	</script>
<% 
			}else {
%>
	<script language="JavaScript">
	alert ("No price for item <%=row.getValue(1).length()>0?row.getValue(1):row.getValue(0) %>.");
	</script>
<%		
			}
		}else{
%>
	<script language="JavaScript">
	alert ("Wrong item code (<%=itmCode %>)!");
	</script>
<%			
		}
	}else if ("saveCharge".equals(action)){ 
		dpcid = DoctorChargeDB.insertCharge(regid, docCode, patno, version, userid, selectItem, source);
%>
		<%=dpcid %>
<%  } else if ("addHATS".equals(action)) { 
	String result = DoctorChargeDB.addToHATS(regid, docCode, patno, dpcid, slpNo, userid);
%>
<%=result %>
<%
	}else if ("addFavor".equals(action)){ 
		String success = DoctorChargeDB.insertFavor(userid,clickedBox);
%>			
		<%=success %>
<%
	}else if ("getOption".equals(action)){
		record = DoctorChargeDB.getOption(pqCategory);
		if (record.size() > 0){%>
		<p class="">Options:</p>
		<%
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
				String prefix = "";
				if(row.getValue(1) == null || row.getValue(1).length() <= 0){
					pqItmPrefix = pqCategory;
				}else{
					pqItmPrefix = row.getValue(1);
				}
				if(row.getValue(2) == null || row.getValue(2).length() <= 0){
					prefix = row.getValue(1);
				}else{
					prefix = row.getValue(2);
				}
		%>
			<div class="w3-col w3-third" onclick="selectOption('<%=prefix %>-<%=row.getValue(3) %>')">
			<input class="" type="radio" name="select_pqOption" value="<%=prefix %>-<%=row.getValue(3) %>" id="<%=prefix %>-<%=row.getValue(3) %>" <%="R".equals(row.getValue(3))?"checked ":i == 0?"checked ":" "%> <%=disabled %>>
			<span class="w3-small">
				<span id="pqItmPrefix" style="display:none"><%=pqItmPrefix %></span>
				[<%="LB".equals(pqCategory)||"LC".equals(pqCategory)?row.getValue(3):prefix %>]
				<%="O".equals(row.getValue(3))?"Office Hour - ":"N".equals(row.getValue(3))?"After Office Hour - ":"5".equals(row.getValue(3))||"7".equals(row.getValue(3))?"After Office Hour - ":"" %>
				<%=row.getValue(0) %>
			</span>
			</div>
		<%
			}
		}
	}else if ("getItem".equals(action)){
		record = DoctorChargeDB.getFavorList(userid);
		String favorItems = "";
		if(record.size() > 0){
				row = (ReportableListObject) record.get(0);
				favorItems = row.getValue(0);
		}
		record = DoctorChargeDB.getItemType(pqCategory);
		if(record.size() == 0){
			ArrayList record1 = DoctorChargeDB.getItem(pqCategory);
		if (record1.size() > 0) {
			int divCount = 0;
%>
<%
			for (int j = 0; j < record1.size(); j++) {
			ReportableListObject row1 = (ReportableListObject) record1.get(j);
			if(j%(record1.size()/3) == 0) {
				if(divCount > 0){%>
			</div>
				<%} %>
			<div class="w3-container w3-third" id="part<%=divCount%>">			
<%			
				divCount++;
			} 
%>
				<div class="itm w3-container w3-round-small" onclick="selectItem('<%=pqCategory %><%=row1.getValue(0) %>','<%=row1.getValue(0) %>','<%=row1.getValue(3) %>');" >
						<input class=" " type="checkbox" name="select_pqItem" id="<%=pqCategory %><%=row1.getValue(0) %>" value="<%=row1.getValue(0) %>" <%=disabled %>/>
						<span class="<%=favorItems.indexOf(pqCategory+row1.getValue(0))>=0 ? 
								"w3-text-red bold" : (((pqCategory+row1.getValue(1)).toUpperCase().indexOf(keyWord.toUpperCase())>=0)?"w3-text-red bold":"")%>" >
								[<%=row1.getValue(0) %>] <%=row1.getValue(1) %></span>
				</div>
<%
			 if(j==record1.size()-1){%>
			 </div>
<%			 }
			}
		}
		}else if(record.size() > 1){
%>
<%
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
%>
			<% if (i == 0 ||i== 6 || i == 13){ %>
				<div class="itemTab w3-container w3-third" id="itemType<%=i %>"  style="" >
			<%} %>
				<p class="bold"><%=row.getValue(2) %></p>
<%
					ArrayList record1 = DoctorChargeDB.getItem(pqCategory,row.getValue(1));
					if (record1.size() > 0) {
						for (int j = 0; j < record1.size(); j++) {
							ReportableListObject row1 = (ReportableListObject) record1.get(j);
%>
					<div class="itm w3-container w3-round-small" onclick="selectItem('<%=pqCategory %><%=row1.getValue(0) %>','<%=row1.getValue(0) %>','<%=row1.getValue(3) %>');">
						<input class="" type="checkbox" name="select_pqItem" id="<%=pqCategory %><%=row1.getValue(0) %>" value="<%=row1.getValue(0) %>" <%=disabled %>/>
						<%
						Boolean inFavor = false;
						Boolean inSearch = false;
						String currentBox = pqCategory+row1.getValue(0);
						if (row1.getValue(1).toUpperCase().indexOf(keyWord.toUpperCase()) >= 0) {
							inSearch = true;
						}
						if(favorItems.indexOf(pqCategory+row1.getValue(0))>=0){
							int start = favorItems.indexOf(pqCategory+row1.getValue(0));
							int end = favorItems.indexOf(",",favorItems.indexOf(pqCategory+row1.getValue(0)));
							if(end<0){
								if(currentBox.equals(favorItems.substring(start))){
									inFavor = true;
								}
							}else{
								if(currentBox.equals(favorItems.substring(start,end))){
									inFavor = true;
								}
							}
						}

						%>
						<span class="<%=inFavor ? "w3-text-red bold" : (inSearch?"w3-text-red bold":"") %>" >[<%=row1.getValue(0) %>] <%=row1.getValue(1) %></span>
					</div>
<%
						}
					}
%>
				<% if (i== 5|| i == 12 || i == record.size()){ %>
				</div>
				<%} %>
<%
			}	
		}
	}else if ("print".equals(action)){
		record = DoctorChargeDB.getPrintReport(dpcid, printOpt);
		if(record.size()>0){
			File reportFile = new File(application.getRealPath("/report/RPT_DPCHARGE.jasper"));
			File reportDir = new File(application.getRealPath("/report/"));
			if (reportFile.exists()) {
				JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
				Map parameters = new HashMap();
				parameters.put("BaseDir", reportFile.getParentFile());		
				ArrayList record1 = DoctorChargeDB.getPrintInfo(dpcid);	
				if(record1.size()>0){
					ReportableListObject row1 = (ReportableListObject) record1.get(0);
					version = row1.getValue(1);
					parameters.put("dpcID", row1.getValue(0));
					parameters.put("patNo", row1.getValue(1));
					parameters.put("patName", row1.getValue(2));
					parameters.put("docName", row1.getValue(3));
					parameters.put("slpNo", row1.getValue(4));
					parameters.put("txnDate", row1.getValue(5));
					parameters.put("errMsg", row1.getValue(6));
					parameters.put("version", row1.getValue(7));
					parameters.put("SteCode",ConstantsServerSide.getSiteShortForm());
					parameters.put("formType",printOpt);	
				}
				JasperPrint jasperPrint =
					JasperFillManager.fillReport(
						jasperReport,
						parameters,
						new ReportListDataSource(record) {
							public Object getFieldValue(int index) throws JRException {
								String value = (String) super.getFieldValue(index);								
								return value;
							}
						});
				
				String encodedFileName = "Dr. Proc Charge Slip("+dpcid+"-"+version+").pdf";
				request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
				OutputStream ouputStream = response.getOutputStream();
				response.setContentType("application/pdf");
				response.setHeader("Content-disposition","inline; filename=\"" + encodedFileName + "\"");
				JRPdfExporter exporter = new JRPdfExporter();
		        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
		        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
		        exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");
		        exporter.setParameter(JRPdfExporterParameter.PDF_JAVASCRIPT, "this.print();");
		        exporter.exportReport();
				return;
			}
		}else{
%>
			<script language="JavaScript">
				alert("Charge Slip cannot be find. Please try again later");
				window.history.back();
			</script>
<%
		}
	}
%>