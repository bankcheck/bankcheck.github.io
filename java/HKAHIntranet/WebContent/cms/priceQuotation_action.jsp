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
String pqId = request.getParameter("pqId");
String clickedBox = request.getParameter("clickedBox");
String contrastDesc = request.getParameter("contrastDesc");
String disabled = request.getParameter("disabled");
String regid = request.getParameter("regid");
String version = request.getParameter("version");
String userid = request.getParameter("userid");
String selectItem = request.getParameter("selectItem");
String source = request.getParameter("source");
String group = request.getParameter("group");

ArrayList record = new ArrayList();
ReportableListObject row = null;
%>
<% if("addItm".equals(action)){ 
		record = PriceQuotationDB.currentItem(pqCategory, patType, itmCode, option, pqItmPrefix, contrast, timeslot);
		if(record.size() > 0){
			row = (ReportableListObject) record.get(0);
			if(Integer.parseInt(row.getValue(5)) >= 0){
%>
	<tr class="eachitem" id="<%=pqCategory %><%=itmCode %>">
		<td>
<%		if("XUC10".equals(row.getValue(0))||"XUC11".equals(row.getValue(0))||"XUC20".equals(row.getValue(0))||"XUC21".equals(row.getValue(0))){%>
				 Mammogram Package
<% 		}else if("XZ005".equals(row.getValue(0))||"XZ007".equals(row.getValue(0))){%>
				
<%		}else{%>
			<button class="removeitem" onclick="removeItem('<%=pqCategory %><%=itmCode %>')">X</button>
<%		} %>
		</td>
		<td class="patType" style="display:none">
			<%=patType%>
		</td>
		<td class="patTypeDesc">
			<%=row.getValue(6) %>
		</td>
		<td class="pqItmPrefix" style="display:none">
			<%=pqItmPrefix %>
		</td>
		<td class="itmCodeDesc">
			<%=row.getValue(1).length()>0?row.getValue(1):row.getValue(0) %>
		</td>
		<td class="itmCode" style="display:none">
			<%=row.getValue(0).length()>0?row.getValue(0):"" %>
		</td>
		<td class="pkgCode" style="display:none">
			<%=row.getValue(1).length()>0?row.getValue(1):"" %>
		</td>
		<td class="itmDesc">
			<%=row.getValue(2) %><%=contrastDesc!=null?"null".equals(contrastDesc)?"":" - " + contrastDesc:"" %>
		</td>
		<td class="contrastDesc" style="display:none">
			<%=contrastDesc!=null?contrastDesc:""  %>
		</td>
		<td class="timeslot" style="display:none">
			<%=row.getValue(3) %>
		</td>
		<td class="optiondesc">
			<%="O".equals(timeslot)?"Office Hour - ":"N".equals(timeslot)?"After Office Hour - ":"" %><%=row.getValue(4) %>
		</td>
		<td class="price" >
			$<%=row.getValue(5) %>
		</td>
	</tr>
	<script language="JavaScript">
	var itmSum = parseInt($('#itmSum', top.frames['summary'].document).text()) + parseInt("<%=row.getValue(5) %>");
	$('#itmSum', top.frames['summary'].document).text(itmSum);
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
	alert ("Wrong item code (<%=pqItmPrefix %><%=itmCode %>)!");
	</script>
<%			
		}
	}else if ("saveQuotation".equals(action)){ 
		pqId = PriceQuotationDB.insertNewQuotation(regid, docCode, patno, version, userid, selectItem, source);
%>
		<%=pqId %>
<%
	}else if ("addFavor".equals(action)){ 
		String success = PriceQuotationDB.insertFavor(userid,clickedBox);
%>			
		<%=success %>
<%
	}else if ("getOption".equals(action)){
		record = PriceQuotationDB.getOption(pqCategory);
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
		record = PriceQuotationDB.getFavorList(userid);
		String favorItems = "";
		if(record.size() > 0){
				row = (ReportableListObject) record.get(0);
				favorItems = row.getValue(0);
		}
		record = PriceQuotationDB.getItemType(pqCategory);
		if(record.size() == 0){
			ArrayList record1 = PriceQuotationDB.getItem(pqCategory);
			if (record1.size() > 0) {
%>
		<p class="">Item:</p>
<%
				for (int j = 0; j < record1.size(); j++) {
					ReportableListObject row1 = (ReportableListObject) record1.get(j);
%>
		<div class="itm w3-container w3-round-small" onclick="selectItem('<%=pqCategory %><%=row1.getValue(0) %>','<%=row1.getValue(0) %>');" >
				<input class=" " type="checkbox" name="select_pqItem" id="<%=pqCategory %><%=row1.getValue(0) %>" value="<%=row1.getValue(0) %>" <%=disabled %>/>
				<span class="<%=favorItems.indexOf(pqCategory+row1.getValue(0))>=0 ? "w3-text-red bold" : "" %>" >[<%=row1.getValue(0) %>] <%=row1.getValue(1) %></span>
		</div>
<%
				}
			}
		}else if(record.size() > 1){
			String column = "w3-third";
			if("EN".equals(pqCategory)){
				column = "";
			}else if ("GY".equals(pqCategory) || "OR".equals(pqCategory) || "SU".equals(pqCategory)){
				column = "w3-half";
			}
%>
		<p class="">Item:</p>
<%
			for (int i = 0; i < record.size(); i++) {
				row = (ReportableListObject) record.get(i);
%>
				<div class="itemTab w3-container <%=column %>" id="itemType<%=i %>"  style="" >
				<p class="bold"><%=row.getValue(2) %></p>
<%
					ArrayList record1 = PriceQuotationDB.getItem(pqCategory,row.getValue(1));
					if (record1.size() > 0) {
						for (int j = 0; j < record1.size(); j++) {
							ReportableListObject row1 = (ReportableListObject) record1.get(j);
%>
					<div class="itm w3-container w3-round-small" onclick="selectItem('<%=pqCategory %><%=row1.getValue(0) %>','<%=row1.getValue(0) %>');">
						<input class="" type="checkbox" name="select_pqItem" id="<%=pqCategory %><%=row1.getValue(0) %>" value="<%=row1.getValue(0) %>" <%=disabled %>/>
						<%
						Boolean inFavor = false;
						String currentBox = pqCategory+row1.getValue(0);
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
						<span class="<%=inFavor ? "w3-text-red bold" : "" %>" >[<%=row1.getValue(0) %>] <%=row1.getValue(1) %></span>
					</div>
<%
						}
					}
%>
				</div>
<%
			}	
		}
	}else if ("print".equals(action)){
		record = PriceQuotationDB.getPrintReport(pqId);
		if(record.size()>0){
			File reportFile = new File(application.getRealPath("/report/RPT_PRICE_QUOTATION.jasper"));
			File reportDir = new File(application.getRealPath("/report/"));
			if (reportFile.exists()) {
				JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
				Map parameters = new HashMap();
				parameters.put("BaseDir", reportFile.getParentFile());		
				ArrayList record1 = PriceQuotationDB.getPrintInfo(pqId);	
				if(record1.size()>0){
					ReportableListObject row1 = (ReportableListObject) record1.get(0);
					version = row1.getValue(1);
					parameters.put("pqid", row1.getValue(0));
					parameters.put("version", row1.getValue(1));
					parameters.put("createDate", row1.getValue(2));
					parameters.put("totalPrice", row1.getValue(3));
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
				
				String encodedFileName = "Price_Quotation("+pqId+"-"+version+").pdf";
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
				alert("Quotation cannot be find. Please try again later");
				window.history.back();
			</script>
<%
		}
	}
%>