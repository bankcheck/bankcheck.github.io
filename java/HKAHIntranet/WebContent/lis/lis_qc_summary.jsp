<%@ page import="java.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="org.json.simple.*"%>
<%@ page import="java.text.*"%>
<%!
public class ControlChart { 
	private String cntlNum;
    private String cntlName;
    private String lotNum;
    private String calculatedMean;
    private String calculatedSD;
    private String chartParm;
    private double min;
    private double max;
    private String step;
    private int ptCount = 0;
    private boolean error = false;
    private String message;
    
    public ControlChart(String testType, String machno, String intTcode, String cntlNum, String cntlNum1, String cntlNum2, String cntlNum3, String frDate, String toDate) {
    	
	    try {
	    	this.cntlNum = cntlNum;
	    	
	    	double rangeHi = 0;
	    	double rangeLow = 0;	    		    	
	    	
	    	ReportableListObject cntl = LabDB.getControlDetail(testType, cntlNum, machno, intTcode);
	    	if (cntl != null) {	    		
	    		this.lotNum = cntl.getValue(1);
	    		rangeHi = Double.parseDouble(cntl.getValue(4));
	    		rangeLow = Double.parseDouble(cntl.getValue(5));
	    		this.cntlName = cntl.getValue(6);
	    		this.step = cntl.getValue(9);
	    		this.max = Double.parseDouble(cntl.getValue(10));
	    		this.min = Double.parseDouble(cntl.getValue(11));
	    	}	
	    	  			
    		StringBuffer sqlStr = new StringBuffer();
   			sqlStr.append("select substr(b.seq_date, 1, 4) || '-' || substr(b.seq_date, 5 , 2) || '-' || substr(b.seq_date, 7, 2) || '(' || b.seq_num || ')', a.result, a.status ");
   			sqlStr.append("	from ( ");
   			sqlStr.append("		select labo_qc_result.*, dense_rank() over ( partition by seq_date order by seq_log ) as seq_num from labo_qc_result@lis where test_type = ? and cntl_num = ? and int_tcode = ? and equipment = ? and seq_date >= ? and seq_date <= ? and result is not null ");
   			sqlStr.append("		) a, ( ");
   			sqlStr.append("		select seq_date, dense_rank() over ( partition by seq_date order by seq_log ) as seq_num from labo_qc_result@lis where test_type = ? and cntl_num = ? and int_tcode = ? and equipment = ? and seq_date >= ? and seq_date <= ? and result is not null ");
   			sqlStr.append("			union ");
   			sqlStr.append("		select seq_date, dense_rank() over ( partition by seq_date order by seq_log ) as seq_num from labo_qc_result@lis where test_type = ? and cntl_num = ? and int_tcode = ? and equipment = ? and seq_date >= ? and seq_date <= ? and result is not null ");
   			sqlStr.append("			union ");
   			sqlStr.append("		select seq_date, dense_rank() over ( partition by seq_date order by seq_log ) as seq_num from labo_qc_result@lis where test_type = ? and cntl_num = ? and int_tcode = ? and equipment = ? and seq_date >= ? and seq_date <= ? and result is not null ");
   			sqlStr.append("		) b ");
   			sqlStr.append("	where a.seq_date (+) = b.seq_date ");
   			sqlStr.append("		and a.seq_num (+) = b.seq_num ");
   			sqlStr.append("		order by b.seq_date, b.seq_num "); 			

   			ArrayList<ReportableListObject> record = UtilDBWeb.getReportableList(sqlStr.toString(), 
   				new String[]{
   					testType, cntlNum, intTcode, machno, frDate, toDate,
   					testType, cntlNum1, intTcode, machno, frDate, toDate,  
   					testType, cntlNum2, intTcode, machno, frDate, toDate,  
   					testType, cntlNum3, intTcode, machno, frDate, toDate
   			});
   			
   			ReportableListObject row = null;	

			this.ptCount = record.size();
   			ArrayList<Double> numResultLst = new ArrayList<Double>();
   				
   	   		//JSONObject chart = new JSONObject();
   	   			
   	   		JSONObject data = new JSONObject();
   	   		ArrayList<String> labels = new ArrayList<String>();
   	   		JSONArray datasets = new JSONArray();			
   	   			
   	   		JSONObject lineDataset = new JSONObject();
   	   		lineDataset.put("borderColor", "rgba(0, 0, 139, 1)");
   	   		lineDataset.put("borderWidth", 2);
   	   		lineDataset.put("pointRadius", 0);
   	   		lineDataset.put("showLine", true);
   	   		lineDataset.put("spanGaps", true);	   	   			
   	   		ArrayList<Double> lineData = new ArrayList<Double>();
   	   			
   			JSONObject normalDataset = new JSONObject();
   	   		normalDataset.put("borderColor", "rgba(0, 0, 139, 1)");
   	   		normalDataset.put("borderWidth", 2);
   	   		normalDataset.put("pointBackgroundColor", "rgba(0, 0, 139, 1)");
   	   		normalDataset.put("pointRadius", 5);
   	   		normalDataset.put("showLine", false);	
   	   		ArrayList<Double> normalData = new ArrayList<Double>();
   	   			
   	   		JSONObject abnormalDataset = new JSONObject();
   	   		abnormalDataset.put("borderColor", "rgba(0, 255, 255, 1)");
   	   		abnormalDataset.put("pointBackgroundColor", "rgba(255, 255, 255, 1)");
   	   		abnormalDataset.put("borderWidth", 2);
   	   		abnormalDataset.put("pointRadius", 5);
   	   		abnormalDataset.put("showLine", false);
   	   		ArrayList<Double> abnormalData = new ArrayList<Double>();
   	   			
   	   		JSONObject rejectDataset = new JSONObject();
   	   		rejectDataset.put("borderColor", "rgba(255, 0, 0, 1)");
   	   		rejectDataset.put("pointBackgroundColor", "rgba(255, 255, 255, 1)");
   	   		rejectDataset.put("borderWidth", 2);
   	   		rejectDataset.put("pointRadius", 5);
   	   		rejectDataset.put("showLine", false);	
   	   		ArrayList<Double> rejectData = new ArrayList<Double>();   				   			
   			
	   		for (int i = 0; i < record.size(); i++) {
	   			row = (ReportableListObject)record.get(i);
	   				
	   			String label = row.getValue(0);
	   			String txtResult = row.getValue(1);
	   			String status = row.getValue(2);
	   					   				
	   			labels.add(label);
	   				
	   			if ((txtResult == null)||(txtResult.length() == 0)) {	   					
	   				lineData.add(null);	  
	   				normalData.add(null);
	   				abnormalData.add(null);
	   				rejectData.add(null); 						   					
	   			} else {	   					   					   				
	   				double result = LabDB.convertQcResult(txtResult);
//calculate mean, sd, and cv
					if (!"R".equals(status)) {
		   				numResultLst.add(result);
					}

//change outlier values to top and bottom of the chart for plotting
	   				if (result < min)
	   					result = min;
	   				
	   				if (result > max)
	   					result = max;
	   					 
	   				lineData.add(result);
	   				
	   				if ("R".equals(status)) {
	   					normalData.add(null);
	   					abnormalData.add(null);
	   					rejectData.add(result);		   					
	   				} else if ((result > rangeHi) || (result < rangeLow)) {
	   					normalData.add(null);
	   					abnormalData.add(result);
	   					rejectData.add(null);
	   				} else {
	   					normalData.add(result);
	   					abnormalData.add(null);
	   					rejectData.add(null);
	   				}
   				}
   			}
	   			
//calculate mean, sd, and cv		    
	    	this.calculatedMean = LabDB.QcFormat.format(LabDB.calMean(numResultLst)); 
	    	this.calculatedSD = LabDB.QcFormat.format(LabDB.calPopSD(numResultLst)); 
  			
   			lineDataset.put("data", lineData);
   			normalDataset.put("data", normalData);
   			abnormalDataset.put("data", abnormalData);
   			rejectDataset.put("data", rejectData);
   			
   			datasets.add(lineDataset);
   			datasets.add(normalDataset);
   			datasets.add(abnormalDataset);
   			datasets.add(rejectDataset);
   			
   			data.put("labels", labels);	
   			data.put("datasets", datasets);
   			
	   		this.chartParm = data.toJSONString();

		} catch (Exception e) {
			this.error = true;
			this.message = e.getMessage();
		    System.out.println(e.getMessage());	    
		}
    }
    
    public String getCntlNum() {
    	return this.cntlNum;
    }   
    
    public String getCntlName() {
    	return this.cntlName;
    }   
    
    public String getLotNum() {
    	return this.lotNum;
    }  
    
    public String getCalculatedMean() {
    	return this.calculatedMean;	
    }
    
    public String getCalculatedSD() {
    	return this.calculatedSD;
    }   
    
    public String getChartParm() {
    	return this.chartParm;
    }
    
    public double getMin() {
		return min;
	}

	public double getMax() {
		return max;
	}

	public String getStep() {
		return step;
	}
    
    public boolean isError() {
    	return this.error;
    }
    
    public String getMessage() {
    	return this.message;
    }
    
    public int getPtCount() {
    	return this.ptCount;
    }
} 



public static ArrayList<ReportableListObject> getTestList(String testType, String cntlNum1, String cntlNum2, String cntlNum3) {
	
	StringBuffer sqlStr = new StringBuffer();

	if ((cntlNum1 != null) && !cntlNum1.isEmpty()) {
		sqlStr.append("SELECT p.int_tcode, p.code from labm_prices@lis p ");
		sqlStr.append(" inner join labo_qc_norm@lis n on p.int_tcode = n.int_tcode ");
		sqlStr.append(" where n.cntl_num = '" + cntlNum1 + "' and n.test_type = '" + testType + "' ");
	}
	
	if ((cntlNum2 != null) && !cntlNum2.isEmpty()) {
		
		if (sqlStr.length() > 0)
			sqlStr.append(" intersect ");
			
		sqlStr.append("SELECT p.int_tcode, p.code from labm_prices@lis p ");
		sqlStr.append(" inner join labo_qc_norm@lis n on p.int_tcode = n.int_tcode ");
		sqlStr.append(" where n.cntl_num = '" + cntlNum2 + "' and n.test_type = '" + testType + "' ");
	}
	
	if ((cntlNum3 != null) && !cntlNum3.isEmpty()) {
		
		if (sqlStr.length() > 0)
			sqlStr.append(" intersect ");
			
		sqlStr.append("SELECT p.int_tcode, p.code from labm_prices@lis p ");
		sqlStr.append(" inner join labo_qc_norm@lis n on p.int_tcode = n.int_tcode ");
		sqlStr.append(" where n.cntl_num = '" + cntlNum3 + "' and n.test_type = '" + testType + "' ");
	}
	
	sqlStr.append(" ORDER BY CODE ");

	return  UtilDBWeb.getReportableList(sqlStr.toString());		
}
%>
<%
String frDate = request.getParameter("frDate");
String toDate = request.getParameter("toDate");
String testType = request.getParameter("testType");
String machno = request.getParameter("machno");
String intTcode = request.getParameter("intTcode");
String cntlNum1 = request.getParameter("cntlNum1");
String cntlNum2 = request.getParameter("cntlNum2");
String cntlNum3 = request.getParameter("cntlNum3");
String user = request.getParameter("user");

String testCode = null;
String testName = null;

ReportableListObject test = LabDB.getTestByIntTcode(intTcode);

if (test != null) {
	testCode = test.getValue(0);
	testName = test.getValue(1);
}

%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html>
<jsp:include page="../common/header.jsp"/> 
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<script src="../js/chart.js"></script>
<title>QC Summary</title>
</head>
<body style="background: lightyellow">
<form name="form1" id="form1" method="get" >
<input type="hidden" name="frDate" id="frDate" value="<%=frDate==null?"":frDate %>"/>
<input type="hidden" name="toDate" id="toDate" value="<%=toDate==null?"":toDate %>"/>
<input type="hidden" name="testType" id="testType" value="<%=testType==null?"":testType %>"/>
<input type="hidden" name="machno" id="machno" value="<%=machno==null?"":machno %>"/>
<input type="hidden" name="cntlNum1" id="cntlNum1" value="<%=cntlNum1==null?"":cntlNum1 %>"/>
<input type="hidden" name="cntlNum2" id="cntlNum2" value="<%=cntlNum2==null?"":cntlNum2 %>"/>
<input type="hidden" name="cntlNum3" id="cntlNum3" value="<%=cntlNum3==null?"":cntlNum3 %>"/>
<input type="hidden" name="user" id="user" value="<%=user==null?"":user %>"/>
<table border=0 style="width:1200px">
<tr>
<td>From:</td><td><%=frDate %></td><td colspan=2>Instrument: <%=LabDB.getInstrumentName(testType, machno) %></td></tr>
<tr>
<td>To:</td><td><%=toDate %></td>
	<td>Test Code:  <select name='intTcode' id='intTcode' onChange='submit()'>
	<%
		ArrayList rec = getTestList(testType, cntlNum1, cntlNum2, cntlNum3);
		ReportableListObject row = null;
		
		for (int i = 0; i < rec.size(); i++) {	
			row = (ReportableListObject)rec.get(i);
			
		%>		
			<option value="<%=row.getValue(0) %>" <%=row.getValue(0).equals(intTcode)?"selected":"" %> ><%=row.getValue(1) %></option>
		<%
		}
	%>	
 	</select>
	</td>
	<td>Name: <%=testName %></td>
</tr>
</table>
</form>
<table >
<%
ArrayList<ControlChart> QcSummary = new ArrayList<ControlChart>();

if ((cntlNum1 != null) && !cntlNum1.isEmpty()) 	
	QcSummary.add(new ControlChart(testType, machno, intTcode, cntlNum1, cntlNum1, cntlNum2, cntlNum3, frDate, toDate));

if ((cntlNum2 != null) && !cntlNum2.isEmpty())	
	QcSummary.add(new ControlChart(testType, machno, intTcode, cntlNum2, cntlNum1, cntlNum2, cntlNum3, frDate, toDate));

if ((cntlNum3 != null) && !cntlNum3.isEmpty()) 
	QcSummary.add(new ControlChart(testType, machno, intTcode, cntlNum3, cntlNum1, cntlNum2, cntlNum3, frDate, toDate));

for (ControlChart chart : QcSummary) {
%>
<tr><td colspan=2>Control:<br/><%=chart.getCntlName() %></td>
	<td rowspan=5>
        <canvas id="chart<%=chart.getCntlNum() %>" height=300 style="background: lightgray" ></canvas>
    </td>
</tr>
<tr><td colspan=2>Lot Number:<br/><%=chart.getLotNum() %></td></tr>
<tr><td>Mean =</td><td><%=chart.getCalculatedMean() %></td></tr>
<tr><td>&sigma; =</td><td><%=chart.getCalculatedSD() %></td></tr>
<tr><td colspan=2><button type="button" onclick="window.open('lis_qc_chart.jsp?frDate=<%=frDate %>&toDate=<%=toDate %>&testType=<%=testType %>&machno=<%=machno %>&intTcode=<%=intTcode %>&cntlNum=<%=chart.getCntlNum() %>&user=<%=user %>', '_blank', 'location=no,menubar=no,toolbar=no,scrollbars=yes,status=no,resizable=yes,width=1300,height=900')">
		Show Detail
	</button></td></tr>
<%
}
%>
</table>
<script>
<%
for (ControlChart chart : QcSummary) {
	if (chart.isError()) {		
%>
alert('<%=chart.getCntlName() %>: <%=chart.getMessage() %>');
<%
	} else {
%>
$('#chart<%=chart.getCntlNum() %>').attr('width',40 + <%=chart.getPtCount() %> * 20);
const ctx<%=chart.getCntlNum() %> = document.getElementById('chart<%=chart.getCntlNum() %>');
new Chart(ctx<%=chart.getCntlNum() %>, getLjParm(<%=chart.getMin() %>, <%=chart.getMax() %>, <%=chart.getStep() %>, <%=chart.getChartParm() %>) );
<%
	}
}
%>
$('#intTcode').focus();

function getLjParm(yMin, yMax, step, data) {	
	
	let chartParm =
	{
		"data": data,
		"type":"line",
		"options":{
			"scales":{
				"y":{
					"min":yMin,
					"max":yMax,					
					"grid":{
						"color":"rgba(0, 0, 0, 0.5)"
					},
					"ticks":{
						"stepSize":step,
						"callback":function(value) {
					    	return fixDec(value);
					    }
					}
				},
				"x":{
					"grid":{
						"color":"rgba(0, 0, 0, 0.5)"
					},
					"ticks":{
						"autoSkip":false
					},
				}
			},
			"plugins":{
				"legend":{
					"display":false
				},
		        "tooltip":{
		            "enabled":false  
		        }
			},
			"responsive":false
		}	
	};	
			
	return chartParm;
}

function fixDec(val) {
	return Number(val.toFixed(<%=LabDB.QcDecimal %>)).toString();
}
</script>
</body>
</html>