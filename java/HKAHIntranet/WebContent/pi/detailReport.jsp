<%@ page import="java.util.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="java.util.ArrayList.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.data.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="java.io.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page trimDirectiveWhitespaces="true" %>


<%!
int col = 20;
String header[] = new String[col];

final static String[] arrayErrorType = {"Equipment", "Needle Stick","Medication Error","Fall","Injury","Other"};
final static String[] arrayDeptType = {"Patient room#", "Bath in patient room","Hall","Delivery Suite","Treatment room",
										"OT/RR","Pharmacy","Radiology","OPD","ICU","Lab","Paeds","On grounds","Other"};

public class Value{
	String type;
	String count;
	public Value(String type, String count){
		this.type = type;
		this.count = count;
	}	 

}

public class GraphValue extends Value{	
	Integer month;	
	public GraphValue(String type,Integer month,String count){
		 super(type,count);
		this.month = month;
		
	}
}

public class DeptGraphValue extends Value{	
	String errorType;	
	public DeptGraphValue(String type,String errorType,String count){
		 super(type,count);
		this.errorType = errorType;
		
	}
}

public String getAnalysisGraphValueFromDB(String searchYearFrom){

	ArrayList<GraphValue> listOfValue = new ArrayList<GraphValue>(); 
	ArrayList graphRecord = getData(searchYearFrom, null, "analysisGraph",true,null);
	if(graphRecord.size() != 0){	
		for(int i =0;i< graphRecord.size();i++){
			ReportableListObject graphRow = (ReportableListObject)graphRecord.get(i);
			String incidentYear = graphRow.getValue(0);			
			Integer incidentMonth = Integer.parseInt(graphRow.getValue(1));			
			String incidentCount = graphRow.getValue(2);
			if(incidentYear != null && incidentYear.length()>0){
				GraphValue tempValue = null;
			
				if(incidentYear.equals(searchYearFrom)){
					tempValue = new GraphValue(incidentYear,incidentMonth,incidentCount);
					listOfValue.add(tempValue);
				}				
			}
		}
	}
	
	return getGraphString(createGraphValue(listOfValue));
}

public ArrayList<GraphValue> createAnalysisGraphValue(ArrayList<GraphValue> listOfValue){
	ArrayList<GraphValue> graphValue = new ArrayList<GraphValue>();
	for(int i = 1;i<=12;i++){		
		boolean monthFound = false;
		String tempType = "";
		for(GraphValue g : listOfValue){
			tempType=g.type;		
			if(g.month == i){
				graphValue.add(g);
				monthFound = true;
			}
		}
		
		if(monthFound == false){
			GraphValue tempValue = new GraphValue(tempType,i,"0");
			graphValue.add(tempValue);
		}
	}
	
	return graphValue;
}

public String getDeptBarGraphValueFromDB(String searchYearFrom,String type){
	ArrayList<DeptGraphValue> listOfValue = new ArrayList<DeptGraphValue>(); 
	ArrayList graphRecord = getData(searchYearFrom, type, "departmentFallInj",true,null);
	if(graphRecord.size() != 0){	
		for(int i =0;i< graphRecord.size();i++){
			ReportableListObject graphRow = (ReportableListObject)graphRecord.get(i);
			String departmentType = graphRow.getValue(0);			
			String errorType = graphRow.getValue(1);			
			String departmentCount = graphRow.getValue(2);
			if(errorType != null && errorType.length()>0){
				DeptGraphValue tempValue = null;
			
				if(errorType.equals(type)){
					tempValue = new DeptGraphValue(departmentType,errorType,departmentCount);
					listOfValue.add(tempValue);
				}				
			}
		}
	}	
	
	ArrayList<DeptGraphValue> graphValue = createDeptBarGraphValue(listOfValue);
	StringBuffer deptBarGraphString = new StringBuffer();

	for(int i = 0;i<graphValue.size();i++){	
		deptBarGraphString.append(graphValue.get(i).count);
		if(i<graphValue.size()-1){
			deptBarGraphString.append(",");
		}
	}
	
	return  deptBarGraphString.toString();
}

public ArrayList<DeptGraphValue> createDeptBarGraphValue(ArrayList<DeptGraphValue> listOfValue){
	ArrayList<DeptGraphValue> graphValue = new ArrayList<DeptGraphValue>();
	for(String s : arrayDeptType){		
		boolean deptFound = false;
		String tempErrorType = "";
		for(DeptGraphValue d : listOfValue){
			tempErrorType=d.errorType;		
			if(d.type.equals(s)){
				graphValue.add(d);
				deptFound = true;
			}
		}
		
		if(deptFound == false){
			DeptGraphValue tempValue = new DeptGraphValue(s,tempErrorType,"0");
			graphValue.add(tempValue);
		}
	}
	
	return graphValue;
}

public String  getDeptPieGraphValueFromDB(String searchYearFrom,String searchYearTo,String type){
	ArrayList<Value> listOfValue = new ArrayList<Value>(); 
	ArrayList graphRecord = getData(searchYearFrom, null, type,true,searchYearTo);
	if(graphRecord.size() != 0){	
		for(int i =0;i< graphRecord.size();i++){
			ReportableListObject graphRow = (ReportableListObject)graphRecord.get(i);
			String errorType = graphRow.getValue(0);			
			String errorCount = graphRow.getValue(1);			
			
			if(errorType != null && errorType.length()>0){
				Value tempValue = null;
				tempValue = new Value(errorType,errorCount);
				listOfValue.add(tempValue);
			}
		}
	}	
	ArrayList<Value>deptPieGraphValue = createDeptPieGraphValue(listOfValue);
	StringBuffer deptPieGraphString = new StringBuffer();

	for(int i = 0;i<deptPieGraphValue.size();i++){	
		deptPieGraphString.append("['"+deptPieGraphValue.get(i).type + "', " + deptPieGraphValue.get(i).count+"]");
		if(i<deptPieGraphValue.size()-1){
			deptPieGraphString.append(",");
		}
	}
	return  deptPieGraphString.toString();
}

public ArrayList<Value> createDeptPieGraphValue(ArrayList<Value> listOfValue){
	ArrayList<Value> graphValue = new ArrayList<Value>();
	for(String s : arrayErrorType){		
		boolean errorFound = false;
		for(Value v :listOfValue){
			if(v.type.equals(s)){
				graphValue.add(new Value(v.type,v.count));
				errorFound = true;
				break;
			}
		}
		if(!errorFound){
			graphValue.add(new Value(s,"0"));
		}
	}
	
	return graphValue;
}



public String getDeptGraphValueFromDB(String searchYearFrom,String type){
	ArrayList<DeptGraphValue> listOfValue = new ArrayList<DeptGraphValue>(); 
	ArrayList graphRecord = getData(searchYearFrom, type, "department",true,null);
	if(graphRecord.size() != 0){	
		for(int i =0;i< graphRecord.size();i++){
			ReportableListObject graphRow = (ReportableListObject)graphRecord.get(i);
			String departmentType = graphRow.getValue(0);			
			String errorType = graphRow.getValue(1);			
			String departmentCount = graphRow.getValue(2);
			if(departmentType != null && departmentType.length()>0){
				DeptGraphValue tempValue = null;
			
				if(departmentType.equals(type)){
					tempValue = new DeptGraphValue(departmentType,errorType,departmentCount);
					listOfValue.add(tempValue);
				}				
			}
		}
	}	
	return  getGraphString(createDeptGraphValue(listOfValue));
}

public ArrayList<DeptGraphValue> createDeptGraphValue(ArrayList<DeptGraphValue> listOfValue){
	ArrayList<DeptGraphValue> graphValue = new ArrayList<DeptGraphValue>();
	for(String s : arrayErrorType){		
		boolean errorFound = false;
		String tempType = "";
		for(DeptGraphValue d : listOfValue){
			tempType=d.type;		
			if(d.errorType.equals(s)){
				graphValue.add(d);
				errorFound = true;
			}
		}
		
		if(errorFound == false){
			DeptGraphValue tempValue = new DeptGraphValue(tempType,s,"0");
			graphValue.add(tempValue);
		}
	}
	
	return graphValue;
}

public String getGraphValueFromDB(String searchYearFrom,String type){
	ArrayList<GraphValue> listOfValue = new ArrayList<GraphValue>(); 
	ArrayList graphRecord = getData(searchYearFrom, type, "incident",true,null);
	if(graphRecord.size() != 0){	
		for(int i =0;i< graphRecord.size();i++){
			ReportableListObject graphRow = (ReportableListObject)graphRecord.get(i);
			String incidentType = graphRow.getValue(0);			
			Integer incidentMonth = Integer.parseInt(graphRow.getValue(1));			
			String incidentCount = graphRow.getValue(2);
			if(incidentType != null && incidentType.length()>0){
				GraphValue tempValue = null;
			
				if(incidentType.equals(type)){
					tempValue = new GraphValue(incidentType,incidentMonth,incidentCount);
					listOfValue.add(tempValue);
				}				
			}
		}
	}
	
	return getGraphString(createGraphValue(listOfValue));
}

public ArrayList<GraphValue> createGraphValue(ArrayList<GraphValue> listOfValue){
	ArrayList<GraphValue> graphValue = new ArrayList<GraphValue>();
	for(int i = 1;i<=12;i++){		
		boolean monthFound = false;
		String tempType = "";
		for(GraphValue g : listOfValue){
			tempType=g.type;		
			if(g.month == i){
				graphValue.add(g);
				monthFound = true;
			}
		}
		
		if(monthFound == false){
			GraphValue tempValue = new GraphValue(tempType,i,"0");
			graphValue.add(tempValue);
		}
	}
	
	return graphValue;
}

private String getGraphString(ArrayList<? extends Value> graphValue){
	String graphString = "";
	for(Value g : graphValue){
		graphString = graphString + g.count + ",";
	}
	if(graphString.endsWith(",")){
		graphString = graphString.substring(0,graphString.length()-1);
	}
	
	return graphString;
}

public static int getPercentFromTotal(int subtotal, int total) {
    return (int) Math.round((((float) subtotal / (float) total) * 100));
}

public class ValueComparator implements Comparator<Value> {
    
    public int compare(Value o1, Value o2) {
        return o2.count.compareTo(o1.count);
    }
}

private HashMap makeData(String header, String row, String value) {
	HashMap rowMap = new HashMap();
	rowMap.put("header", header);
	rowMap.put("row", row);
	rowMap.put("value", value);
	
	return rowMap;
}

private void generateHeader(String type,String year) {
	if(type.equals("incidentRpt") || type.equals("analysisRpt")) {
		header[0] = "Jan";
		header[1] = "Feb";
		header[2] = "Mar";
		header[3] = "Apr";
		header[4] = "May";
		header[5] = "Jun";
		header[6] = "Jul";
		header[7] = "Aug";
		header[8] = "Sep";
		header[9] = "Oct";
		header[10] = "Nov";
		header[11] = "Dec";
		header[12] = "Total";
		header[13] = "Empty";
		header[14] = "Empty";
	}else if(type.equals("departmentRpt")){
		header[0] = "Equipment";
		header[1] = "Needle Stick";		
		header[2] = "Medication Error";
		header[3] = "Fall";
		header[4] = "Injury";
		header[5] = "Other";
		header[6] = "Total";
		header[7] = "Empty";
		header[8] = "Empty";
		header[9] = "Empty";
		header[10] = "Empty";
		header[11] = "Empty";
		header[12] = "Empty";
		header[13] = "Empty";
		header[14] = "Empty";
	}	
}

private ArrayList getData(String year,String type, String searchType,boolean displayGraph,String yearTo) {	
	String dateCol = null;
	StringBuffer sqlStr = new StringBuffer();	
	if(searchType.equals("fall")||searchType.equals("injury")||searchType.equals("special")||searchType.equals("incident")){
		dateCol = "TO_CHAR(PIR_INCIDENT_DATE, 'MM') ";
		if(displayGraph){
			if(searchType.equals("incident")){
				sqlStr.append("SELECT DECODE(PIR_INCIDENT_CLASSIFICATION, '1', 'Fall', '2', 'Fall', '3', 'Fall',");
				sqlStr.append("'4', 'Injury','5', 'Injury','6', 'Injury',");
				sqlStr.append("'7', 'Needle Stick', '8', 'Medication Error', '9', 'Equipment', '10', 'Others'");
				sqlStr.append(") AS Status, ");
			}
		}else{
			if(searchType.equals("fall")){
				sqlStr.append("SELECT DECODE(PIR_INCIDENT_CLASSIFICATION, '1', 'Patient Fall', '2', 'Staff Fall', '3', 'Visitor Fall') AS Status, ");
			}else if(searchType.equals("injury")){
				sqlStr.append("SELECT DECODE(PIR_INCIDENT_CLASSIFICATION, '4', 'Patient Injury', '5', 'Staff Injury', '6', 'Visitor Injury') AS Status, ");
			}else if(searchType.equals("special")){
				sqlStr.append("SELECT DECODE(PIR_INCIDENT_CLASSIFICATION, '7', '1001_Needle Stick', '8', '1002_Medication Error', '9', '1003_Equipment', '10', '1004_Others') AS Status, ");
			}else if(searchType.equals("incident")){
				sqlStr.append("SELECT DECODE(ENABLE, '1', 'All Incident') AS Status, ");
			}
		}
		sqlStr.append(dateCol+" AS D, ");		
		sqlStr.append("COUNT(1) AS N  ");
		
		sqlStr.append("FROM PI_REPORT ");		
		sqlStr.append("WHERE ENABLE = 1 ");
		sqlStr.append("AND PIR_INCIDENT_DATE >= TO_DATE('01/01/"+year+" 00:00:00', 'dd/mm/yyyy HH24:MI:SS') ");
		sqlStr.append("AND PIR_INCIDENT_DATE <= TO_DATE('31/12/"+year+" 23:59:59', 'dd/mm/yyyy HH24:MI:SS') ");	
		if(displayGraph){
			if(searchType.equals("incident")){
				sqlStr.append("GROUP BY DECODE(PIR_INCIDENT_CLASSIFICATION, '1', 'Fall', '2', 'Fall', '3', 'Fall', ");
				sqlStr.append("'4', 'Injury','5', 'Injury','6', 'Injury',");
				sqlStr.append("'7', 'Needle Stick', '8', 'Medication Error', '9', 'Equipment', '10', 'Others'),");
			}
		}else{
			if(searchType.equals("fall")){
				sqlStr.append("GROUP BY DECODE(PIR_INCIDENT_CLASSIFICATION, '1', 'Patient Fall', '2', 'Staff Fall', '3', 'Visitor Fall'), ");		
			}else if(searchType.equals("injury")){
				sqlStr.append("GROUP BY DECODE(PIR_INCIDENT_CLASSIFICATION, '4', 'Patient Injury', '5', 'Staff Injury', '6', 'Visitor Injury'), ");
			}else if(searchType.equals("special")){
				sqlStr.append("GROUP BY DECODE(PIR_INCIDENT_CLASSIFICATION, '7', '1001_Needle Stick', '8', '1002_Medication Error', '9', '1003_Equipment', '10', '1004_Others'), ");
			}else if(searchType.equals("incident")){
				sqlStr.append("GROUP BY DECODE(ENABLE, '1', 'All Incident'), "); 
			}
		}
		sqlStr.append(dateCol+" ");
		sqlStr.append("ORDER BY Status, ");
		sqlStr.append(dateCol+" ");				
	}else if(searchType.equals("department") || searchType.equals("departmentErrorCount")|| searchType.equals("departmentFallInj") ||searchType.equals("analysisErrorCount") ){		
		dateCol = "DECODE(PIR_INCIDENT_CLASSIFICATION, '1', 'Fall', '2', 'Fall', '3', 'Fall','4', 'Injury','5', "+
					"'Injury', '6', 'Injury', '7', 'Needle Stick', '8', "+
					"'Medication Error','9', 'Equipment','10', 'Other') ";
	
		if(displayGraph){
			if(searchType.equals("department")||searchType.equals("departmentFallInj")){
				sqlStr.append("SELECT PIR_INCIDENT_PLACE AS Status, ");
			}else if(searchType.equals("departmentErrorCount")||searchType.equals("analysisErrorCount")){				
				sqlStr.append("SELECT ");
			}
		}else{
			if(searchType.equals("department")){
				sqlStr.append("SELECT  DECODE(PIR_INCIDENT_PLACE, 'Patient room#', '1001_Patient room#', 'Bath in patient room', '1002_Bath in patient room', "+
						"'Hall', '1003_Hall', 'Delivery Suite', '1004_Delivery Suite', 'Treatment room', '1005_Treatment room', "+
						"'OT/RR', '1006_OT/RR', 'Pharmacy', '1007_Pharmacy', 'Radiology', '1008_Radiology', "+
						"'OPD', '1009_OPD','ICU', '1010_ICU','Lab', '1011_Lab','Paeds', '1012_Paeds','On grounds', '1013_On grounds', "+
						"'Other', '1014_Other') AS Status, ");
			}
		}
	
		sqlStr.append(dateCol+" AS D, ");		
		sqlStr.append("COUNT(1) AS N  ");
		if(!displayGraph){		
			if(searchType.equals("department")){
				sqlStr.append(" ,DECODE(PIR_INCIDENT_CLASSIFICATION, '1', '1005_Fall', '2', '1005_Fall', '3', '1005_Fall', "+
							  " '4', '1006_Injury', '5', '1006_Injury', '6', '1006_Injury', '7', '1002_Needle Stick', '8', '1004_Medication Error', "+
							  " '9', '1001_Equipment','10', '1007_Other')AS O "); 
			}
		}
		
		sqlStr.append("FROM PI_REPORT ");		
		sqlStr.append("WHERE ENABLE = 1 ");
		sqlStr.append("AND PIR_INCIDENT_DATE >= TO_DATE('01/01/"+year+" 00:00:00', 'dd/mm/yyyy HH24:MI:SS') ");
		if(searchType.equals("analysisErrorCount")){
			sqlStr.append("AND PIR_INCIDENT_DATE <= TO_DATE('31/12/"+yearTo+" 23:59:59', 'dd/mm/yyyy HH24:MI:SS') ");
		}else{
			sqlStr.append("AND PIR_INCIDENT_DATE <= TO_DATE('31/12/"+year+" 23:59:59', 'dd/mm/yyyy HH24:MI:SS') ");
		}
		if(displayGraph){
			if(searchType.equals("department")||searchType.equals("departmentFallInj") ){
				sqlStr.append("GROUP BY PIR_INCIDENT_PLACE , ");
			}else if(searchType.equals("departmentErrorCount")||searchType.equals("analysisErrorCount")){
				sqlStr.append("GROUP BY ");
			}
		}else{
			if(searchType.equals("department")){
				sqlStr.append("GROUP BY DECODE(PIR_INCIDENT_PLACE, 'Patient room#', '1001_Patient room#', 'Bath in patient room', '1002_Bath in patient room', "+
						"'Hall', '1003_Hall', 'Delivery Suite', '1004_Delivery Suite', 'Treatment room', '1005_Treatment room', "+
						"'OT/RR', '1006_OT/RR', 'Pharmacy', '1007_Pharmacy', 'Radiology', '1008_Radiology', "+
						"'OPD', '1009_OPD','ICU', '1010_ICU','Lab', '1011_Lab','Paeds', '1012_Paeds','On grounds', '1013_On grounds', "+
						"'Other', '1014_Other'), ");
			}	
		}
		sqlStr.append(dateCol+" ");
		if(!displayGraph){
			if(searchType.equals("department")){
				sqlStr.append(" , DECODE(PIR_INCIDENT_CLASSIFICATION, '1', '1005_Fall', '2', '1005_Fall', '3', '1005_Fall', "+
							  " '4', '1006_Injury', '5', '1006_Injury', '6', '1006_Injury', '7', '1002_Needle Stick', '8', '1004_Medication Error', "+
							  " '9', '1001_Equipment','10', '1007_Other') "); 
			}
		}
		if(displayGraph){
			if(searchType.equals("department")||searchType.equals("departmentFallInj") ){
				sqlStr.append("ORDER BY Status ");
			}else if(searchType.equals("departmentErrorCount")||searchType.equals("analysisErrorCount")){
				sqlStr.append("ORDER BY D ");
			}
		}else{
			sqlStr.append("ORDER BY Status ");
			if(searchType.equals("department")){
				sqlStr.append(", O ");
			}
		}
	}else if(searchType.equals("year")||searchType.equals("analysisGraph")){
		dateCol = "TO_CHAR(PIR_INCIDENT_DATE, 'MM') ";
		if(displayGraph){
			if(searchType.equals("analysisGraph")){
				sqlStr.append("SELECT TO_CHAR(PIR_INCIDENT_DATE, 'YYYY') AS Status, ");
			}
		}else{
			if(searchType.equals("year")){
				sqlStr.append("SELECT TO_CHAR(PIR_INCIDENT_DATE, 'YYYY') AS Status, ");
			}
		}
		sqlStr.append(dateCol+" AS D, ");		
		sqlStr.append("COUNT(1) AS N  ");
		
		sqlStr.append("FROM PI_REPORT ");		
		sqlStr.append("WHERE ENABLE = 1 ");
		sqlStr.append("AND PIR_INCIDENT_DATE >= TO_DATE('01/01/"+year+" 00:00:00', 'dd/mm/yyyy HH24:MI:SS') ");
		if(displayGraph){
			sqlStr.append("AND PIR_INCIDENT_DATE <= TO_DATE('31/12/"+year+" 23:59:59', 'dd/mm/yyyy HH24:MI:SS') ");
		}else{
			sqlStr.append("AND PIR_INCIDENT_DATE <= TO_DATE('31/12/"+yearTo+" 23:59:59', 'dd/mm/yyyy HH24:MI:SS') ");	
		}
		if(displayGraph){
			if(searchType.equals("analysisGraph")){
				sqlStr.append("GROUP BY TO_CHAR(PIR_INCIDENT_DATE, 'YYYY'), ");		
			}
		}else{
			if(searchType.equals("year")){
				sqlStr.append("GROUP BY TO_CHAR(PIR_INCIDENT_DATE, 'YYYY'), ");		
			}
		}
		sqlStr.append(dateCol+" ");
		sqlStr.append("ORDER BY Status, ");
		sqlStr.append(dateCol+" ");		
	}
	
	
	System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}
%>
<%
UserBean userBean = new UserBean(request);
String type = request.getParameter("submitType");
String reportType = request.getParameter("reportType");

String searchYearFrom = request.getParameter("searchYear_ByMonth_yy");	
String searchYearTo = request.getParameter("searchYearTo_ByMonth_yy");	
if("analysis".equals(reportType)){
	if(searchYearFrom != null && searchYearTo != null){
		Integer tempSearchYearTo = Integer.parseInt(searchYearTo);
		Integer tempSearchYearFrom = Integer.parseInt(searchYearFrom);
		searchYearTo = 	Integer.toString(Math.max(tempSearchYearFrom,tempSearchYearTo));
		searchYearFrom = Integer.toString(Math.min(tempSearchYearFrom,tempSearchYearTo));
	}
}

ArrayList<String[]> rowGroup = new ArrayList<String[]>();

StringBuffer sqlStr = new StringBuffer();

ArrayList record = null;
ReportableListObject row = null;

if((type != null && type.equals("incidentRpt") && "indicatorsAndMonth".equals(reportType))||(type != null && type.equals("departmentRpt") && "departmentAndIndicator".equals(reportType))||
		(type != null && type.equals("analysisRpt") && "analysis".equals(reportType))) {
	
	if(rowGroup.size() == 0 && type.equals("incidentRpt") && "indicatorsAndMonth".equals(reportType)) {
		rowGroup.add(new String[]{"fall", "1_Fall", "Fall_Patient Fall", "Fall_Staff Fall", "Fall_Visitor Fall", "Fall_Total "," _ "});
		rowGroup.add(new String[]{"injury", "1_Injury", "Injury_Patient Injury", "Injury_Staff Injury", "Injury_Visitor Injury", "Injury_Total  "," _ "});
		rowGroup.add(new String[]{"special", "1_Special", "Special_Needle Stick", "Special_Medication Error", "Special_Equipment", "Special_Others","Special_Total"," _ "});
		rowGroup.add(new String[]{"incident", "1_Incident", "Incident_All Incident"});	
	}else if(rowGroup.size() == 0 && type.equals("departmentRpt") && "departmentAndIndicator".equals(reportType)){
		rowGroup.add(new String[]{"department", "1_Department", "Department_Patient room#", "Department_Bath in patient room", "Department_Hall", 
				"Department_Delivery Suite","Department_Treatment room","Department_OT/RR","Department_Pharmacy",
				"Department_Radiology","Department_OPD","Department_ICU","Department_Lab","Department_Paeds",
				"Department_On grounds","Department_Other","Department_Total "});
	}
	ArrayList<String> year = new ArrayList<String>();
	if(type.equals("analysisRpt") && "analysis".equals(reportType)){
		year.add("year");
		year.add("1_Year");
		Integer intYearFrom = Integer.parseInt(searchYearFrom);
		Integer intYearTo = Integer.parseInt(searchYearTo);
		for(;intYearFrom<=intYearTo;intYearFrom++){
			year.add("Year_"+Integer.toString(intYearFrom));
		}
		year.add("Year_Total ");
		 if(rowGroup.size() == 0){
			rowGroup.add(year.toArray(new String[year.size()]));
		}
	}
	
	//jasper report
	if (searchYearFrom != null && searchYearFrom.length() > 0) {
	//if (record.size() < 0) {
		File reportFile = null ;
		if(type.equals("incidentRpt")){
			reportFile = new File(application.getRealPath("/report/RPT_INCIDENT_BYMONTH.jasper"));
		}else if (type.equals("departmentRpt")){
			reportFile = new File(application.getRealPath("/report/RPT_INCIDENT_BYDEPT.jasper"));
		}else if (type.equals("analysisRpt")){
			reportFile = new File(application.getRealPath("/report/RPT_INCIDENT_ANALYSIS.jasper"));
		}
		if (reportFile.exists()) {
			JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
	
			Map parameters = new HashMap();
			parameters.put("BaseDir", reportFile.getParentFile());				
			parameters.put("Year", searchYearFrom);
			parameters.put("YearTo", searchYearTo);
			generateHeader(type, searchYearFrom);
			
			Collection beans = new ArrayList();
			
			for(int i = 0; i < rowGroup.size(); i++) {
				String[] items = rowGroup.get(i);
				record = getData(searchYearFrom, type, items[0],false,searchYearTo);
				
				int currentRow = 0;
				int total[] = new int[col];
				
				//init array of total
				for(int counter = 0; counter < total.length; counter++){
					total[counter] = 0;
				}
				//Make the header
				for(int h = 0; h < header.length; h++) {
					if(header[h].equals("Empty")) {
						break;
					}					
					beans.add(makeData(header[h], items[1], ""));
				}
				
				//make the related data
				for(int itemIndex = 2; itemIndex < items.length; itemIndex++) {
					int rowSum = 0;	
					for(int h = 0; h < header.length; h++) {
						
						
						if(header[h].equals("Empty")) {
							break;
						}
						
						if(items[itemIndex].indexOf("Total") > -1) {
							if(header[h].equals("Total"))
								beans.add(makeData(header[h], items[itemIndex], String.valueOf(rowSum)));
							else {
								rowSum += total[h];
								beans.add(makeData(header[h], items[itemIndex], String.valueOf(total[h])));
							}
						}else {
							if(record.size() > currentRow) {
								row = (ReportableListObject) record.get(currentRow);
								String item = null;
								if((items[0].equals("special") || items[0].equals("department")) &&  row.getValue(0)!=null && row.getValue(0).length()>0) {
									item = row.getValue(0).toUpperCase().split("_")[1];									
								}
								else {
									item = row.getValue(0).toUpperCase();
								}		
							

								if(!row.getValue(0).equals("") && 
										items[itemIndex].toUpperCase().indexOf(item) > -1) {
								
									boolean equal = header[h].equals(row.getValue(1));									
									if(!equal) {
										try {	
											equal = (h+1 == Integer.parseInt(row.getValue(1)));										
										}catch(Exception e) {
											equal = false;
										}
									}
										
									if(equal) {
										currentRow++;
										rowSum += Integer.parseInt(row.getValue(2));
										total[h] += Integer.parseInt(row.getValue(2));
										
										beans.add(makeData(header[h], items[itemIndex], row.getValue(2)));
									}
									else {
										beans.add(makeData(header[h], items[itemIndex], "0"));
									}
								}
								else {
									if(items[itemIndex].indexOf(" _ ") > -1) {
										beans.add(makeData(header[h], items[itemIndex], ""));
									}
									else {
										if(header[h].equals("Total"))
											beans.add(makeData(header[h], items[itemIndex], String.valueOf(rowSum)));
										else
											beans.add(makeData(header[h], items[itemIndex], "0"));
									}
								}
							}
							else {
								if(items[itemIndex].indexOf(" _ ") > -1) {
									beans.add(makeData(header[h], items[itemIndex], ""));
								}
								else {
									if(header[h].equals("Total"))
										beans.add(makeData(header[h], items[itemIndex], String.valueOf(rowSum)));
									else
										beans.add(makeData(header[h], items[itemIndex], "0"));
								}
							}
						}
					}
				}
			}
	
			JRMapCollectionDataSource ds = new JRMapCollectionDataSource(beans);
	
			JasperPrint jasperPrint =
				JasperFillManager.fillReport(
					jasperReport,
					parameters,
					(JRDataSource)ds);
			
			
			request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
			response.setContentType("application/pdf");
			OutputStream ouputStream = response.getOutputStream();
			
			JRPdfExporter exporter = new JRPdfExporter();
	        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
	        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
	        exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");
	
	        exporter.exportReport();
	        ouputStream.close();
	        return;
		}
	  }
}
%>
<!-- this comment puts all versions of Internet Explorer into "reliable mode." -->
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%--
	Licensed to the Apache Software Foundation (ASF) under one or more
	contributor license agreements.  See the NOTICE file distributed with
	this work for additional information regarding copyright ownership.
	The ASF licenses this file to You under the Apache License, Version 2.0
	(the "License"); you may not use this file except in compliance with
	the License.  You may obtain a copy of the License at

		 http://www.apache.org/licenses/LICENSE-2.0

	Unless required by applicable law or agreed to in writing, software
	distributed under the License is distributed on an "AS IS" BASIS,
	WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
	See the License for the specific language governing permissions and
	limitations under the License.
--%>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean" %>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html" %>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic" %>
<%@ taglib uri="/WEB-INF/displaytag.tld" prefix="display" %>
<%@ taglib uri="/WEB-INF/c.tld" prefix="c" %>
<html:html xhtml="true" lang="true">
<jsp:include page="../pi/jqplotHeader.jsp"/>
<style>


</style>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>

<DIV id=contentFrame>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="PI Report" />
	<jsp:param name="category" value="Report" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>

<form name="search_form" action="detailReport.jsp" method="post" target="_blank">
<table style="width:100%" cellpadding="0" cellspacing="5"
	class="contentFrameSearch" border="0">	
	<tr class="smallText" >
		<td class="infoLabel" width="10%">Report Type</td>
		<td class="infoData" width="40%" >
			<select onchange=checkSelectedReportType(this); id="reportType" name="reportType">
				<option <%=("indicatorsAndMonth".equals(reportType)?"SELECTED":"") %> value="indicatorsAndMonth">Indicators and Month</option>
				<option <%=("departmentAndIndicator".equals(reportType)?"SELECTED":"") %> value="departmentAndIndicator">Department and Indicator</option>
				<option <%=("analysis".equals(reportType)?"SELECTED":"") %> value="analysis">Analysis, Internal Comparison</option>
			</select>
		</td>
	</tr>
	<tr class="smallText" >
		<td class="infoLabel" width="10%">Year</td>
		<td class="infoData" width="40%" >
		
			<jsp:include page="../ui/dateCMB.jsp" flush="false"> 
				<jsp:param name="label" value="searchYear_ByMonth" />
				<jsp:param name="day_yy" value="<%=searchYearFrom %>" />
				<jsp:param name="yearRange" value="5" />
				<jsp:param name="isYearOnly" value="Y" />
			</jsp:include>
		<span id="reportYear" style="display:none;">
			-
			<jsp:include page="../ui/dateCMB.jsp" flush="false"> 
				<jsp:param name="label" value="searchYearTo_ByMonth" />
				<jsp:param name="day_yy" value="<%=searchYearTo %>" />
				<jsp:param name="yearRange" value="5" />
				<jsp:param name="isYearOnly" value="Y" />
			</jsp:include>
		</span>
		</td>
	</tr>
	<tr><td>&nbsp;</td></tr>
	<tr class="smallText">
		<td colspan="4" align="center">
			<button onclick="return genRpt();">Generate Report</button>
			<button onclick="return genGraph();">Generate Graphs</button>
			<input type="hidden" name="submitType" value=""/>
		</td>
	</tr>
	<tr><td><input type="hidden" name="submitType" value=""/></td></tr>
</table>
</form>
<%
String graphLabelTitle = null;
if("indicatorsAndMonth".equals(reportType)){
	graphLabelTitle = "Indicator And Month";
}else if("departmentAndIndicator".equals(reportType)){
	graphLabelTitle = "Department And Indicator";
}else if("analysis".equals(reportType)){
	graphLabelTitle = "Analysis, Internal Comparison";
}
if(searchYearFrom != null && searchYearFrom.length()>0){
	graphLabelTitle = graphLabelTitle + " | " + searchYearFrom;
	if(reportType.equals("analysis")){
		graphLabelTitle = graphLabelTitle + " - " + searchYearTo;
	}
}
if(graphLabelTitle != null && graphLabelTitle.length()>0){
	graphLabelTitle = "(According to " + graphLabelTitle + ")";
}
%>
<table width="100%"><tr><td class="infoSubTitle5">Incident Graphs <%=(graphLabelTitle!=null?graphLabelTitle:"") %></td></tr></table>
<table id="indicatorTable" style="display:none"width="100%" border="0" cellspacing="20">	
	<tr>
		<td width="50%">
			<div style="height:230px;width:100%;"  id="fallGraph" >		
			</div>
		</td>
		<td width="50%">
			<div style="height:230px;width:100%;"  id="injuryGraph" >		
			
			</div>
		</td>
	</tr>
	<tr>
		<td width="50%">
			<div style="height:230px;width:100%;"  id="needleStickGraph" >		
			</div>
		</td>
		<td width="50%">
			<div style="height:230px;width:100%;"  id="medicationErrorGraph" >		
			
			</div>
		</td>
	</tr>
	<tr>
		<td width="50%">
			<div style="height:230px;width:100%;"  id="equipmentGraph" >		
			</div>
		</td>
		<td width="50%">
			<div style="height:230px;width:100%;"  id="othersGraph" >		
			
			</div>
		</td>
	</tr>
</table>
<table id="departmentTable" style="display:none" width="100%" border="0"  cellspacing="20">
	<tr>
		<td width="50%">
			<div style="height:440px;width:70%;" id="departBarGraph">
			</div>
		</td>
		<td width="50%">
			<div style="height:440px;width:70%;" id="departPieGraph">
			</div>
		</td>
	</tr>
	<tr>
		<td width="50%">
			<div style="height:300px;width:100%;"  id="deptInjGraph" >		
			</div>
		</td>
		<td width="50%">
			<div style="height:300px;width:100%;"  id="deptFallGraph" >		
			</div>
		</td>
	</tr>
</table>

<table id="analysisTable" style="display:none" width="100%" border="0"  cellspacing="20">
	<tr>
		<td width="50%">
			<div style="height:440px;width:100%;" id="analysisGraph">
			</div>
		</td>
		<td width="50%">
			<div style="height:440px;width:70%;" id="analysisPieGraph">
			</div>
		</td>
	</tr>	
	<tr>
		<td>
		</td>
		
<%
if(searchYearFrom!= null && searchYearFrom.length()>0 && searchYearTo!=null && searchYearTo.length()>0 && "analysis".equals(reportType)){
	ArrayList graphRecord = getData(searchYearFrom, null, "analysisErrorCount",true,searchYearTo);
	ArrayList<Value> listOfAnalysisIncidentValue = new ArrayList<Value>(); 
	if(graphRecord.size() != 0){	
		for(int i =0;i< graphRecord.size();i++){
			ReportableListObject graphRow = (ReportableListObject)graphRecord.get(i);
			
			listOfAnalysisIncidentValue.add(new Value(graphRow.getValue(0),graphRow.getValue(1)));
		}
	}
	
	Collections.sort(listOfAnalysisIncidentValue, new ValueComparator());
	int allIncidentCount = 0;
	for(Value v:listOfAnalysisIncidentValue){
		allIncidentCount = allIncidentCount + Integer.parseInt(v.count);
	}
	if(listOfAnalysisIncidentValue.size()>0){ %>
		<td >		
			<table width="350px" border="0">
			<tr ><td colspan="3" class="infoSubTitle5">Top 3 major incidents (See pie chart)</td></tr>
			<tr style="font-size:15px;"><td bgcolor="#1E8EDE" style="color:white">Type</td><td bgcolor="#1E8EDE" style="color:white">No. of Incident</td><td bgcolor="#1E8EDE" style="color:white">Percentage</td></tr>
			<%
			int topThree = 1;
			for(Value v:listOfAnalysisIncidentValue){			
				if(topThree <=3){
			%>
			<tr style="font-size:14px;">
			<td bgcolor="#E0E0E0"><%=v.type %></td><td bgcolor="#F7ECEC"><%=v.count %></td><td bgcolor="#F7ECEC"><%=getPercentFromTotal(Integer.parseInt(v.count),allIncidentCount) %>%</td>
			</tr>
			<%
				}
				topThree++;
			}
			%>
			</table>
		</td>
<%
	}
}
%>
	</tr>	
</table>
</DIV>
</DIV>
</DIV>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>

<script language="javascript">
	$(document).ready(function(){
		checkSelectedReportType($('#reportType option:selected'));
	});
	
	function checkSelectedReportType(obj){
		reportType = $('#reportType option:selected').val();
		if(reportType == 'indicatorsAndMonth' || reportType == 'departmentAndIndicator'){
			$('#reportYear').hide();			
		}else if(reportType == 'analysis'){
			$('#reportYear').show();
		}
	}
	
	function genRpt(type) {
		if($('#reportType :selected').val() == 'indicatorsAndMonth'){
			$('input[name=submitType]').val('incidentRpt');
		}else if($('#reportType :selected').val() == 'departmentAndIndicator'){
			$('input[name=submitType]').val('departmentRpt');
		}else if($('#reportType :selected').val() == 'analysis'){
			$('input[name=submitType]').val('analysisRpt');
		}
		document.search_form.submit();
		$('input[name=submitType]').val('');
	}
	
	function genGraph(){		
		$('form[name=search_form]').attr('target','');	
		document.search_form.submit();
	}
	
<%	
	if(searchYearFrom != null &&searchYearFrom.length()>0 && "indicatorsAndMonth".equals(reportType)){			
		String fallGraphString = getGraphValueFromDB(searchYearFrom,"Fall");
		String injuryGraphString = getGraphValueFromDB(searchYearFrom,"Injury");
		String needleStickGraphString = getGraphValueFromDB(searchYearFrom,"Needle Stick");
		String medicationErrorGraphString = getGraphValueFromDB(searchYearFrom,"Medication Error");
		String equipmentGraphString = getGraphValueFromDB(searchYearFrom,"Equipment");
		String othersGraphString = getGraphValueFromDB(searchYearFrom,"Others");
		
%>
	var fallGraphValue = [
	<%=fallGraphString%>
	];
	
	var injuryGraphValue = [
	<%=injuryGraphString%>
	];
	
	var needleStickGraphValue = [
	<%=needleStickGraphString%>
	];
	
	var medicationErrorGraphValue = [
	<%=medicationErrorGraphString%>
	];
	var equipmentGraphValue = [
	<%=equipmentGraphString%>
	];
	var othersGraphValue = [
	<%=othersGraphString%>
	];
	
		
	$(document).ready(function(){
		$('#indicatorTable').show();	
		
		displayEventGraph(fallGraphValue,'fallGraph','Fall Incient');
		displayEventGraph(injuryGraphValue,'injuryGraph','Injury Incident');
		displayEventGraph(needleStickGraphValue,'needleStickGraph','Needle Stick');
		displayEventGraph(medicationErrorGraphValue,'medicationErrorGraph','Medication Error');
		displayEventGraph(equipmentGraphValue,'equipmentGraph','Equipment');
		displayEventGraph(othersGraphValue,'othersGraph','Others');	
		
		
	});
<%}%>


<%	
if(searchYearFrom != null &&searchYearFrom.length()>0 && "departmentAndIndicator".equals(reportType)){		
	String patientRoomGraphString = getDeptGraphValueFromDB(searchYearFrom,"Patient room#");
	String bathRoomGraphString = getDeptGraphValueFromDB(searchYearFrom,"Bath in patient room");
	String hallGraphString = getDeptGraphValueFromDB(searchYearFrom,"Hall");
	String deliverySuiteGraphString = getDeptGraphValueFromDB(searchYearFrom,"Delivery Suite");
	String treatmentRoomGraphString = getDeptGraphValueFromDB(searchYearFrom,"Treatment room");
	String otRrGraphString = getDeptGraphValueFromDB(searchYearFrom,"OT/RR");
	String pharmacyGraphString = getDeptGraphValueFromDB(searchYearFrom,"Pharmacy");
	String radiologyGraphString = getDeptGraphValueFromDB(searchYearFrom,"Radiology");
	String opdGraphString = getDeptGraphValueFromDB(searchYearFrom,"OPD");
	String icuGraphString = getDeptGraphValueFromDB(searchYearFrom,"ICU");
	String labGraphString = getDeptGraphValueFromDB(searchYearFrom,"Lab");
	String paedsGraphString = getDeptGraphValueFromDB(searchYearFrom,"Paeds");
	String onGroundsGraphString = getDeptGraphValueFromDB(searchYearFrom,"On grounds");
	String otherGraphString = getDeptGraphValueFromDB(searchYearFrom,"Other");
%>
var patientRoomGraphValue = [
    <%=patientRoomGraphString%>
];
var bathRoomGraphValue = [
    <%=bathRoomGraphString%>
];
var hallGraphValue = [
	<%=hallGraphString%>
];  
var deliverySuiteGraphValue = [
	<%=deliverySuiteGraphString%>
]; 
var treatmentRoomGraphValue = [
    <%=treatmentRoomGraphString%>
]; 
var otRrGraphValue = [
	<%=otRrGraphString%>
]; 
var pharmacyGraphValue = [
	<%=pharmacyGraphString%>
];
var radiologyGraphValue = [
    <%=radiologyGraphString%>
];
var opdGraphValue = [
    <%=opdGraphString%>
];
var icuGraphValue = [
    <%=icuGraphString%>
];
var labGraphValue = [
    <%=labGraphString%>
];
var paedsGraphValue = [
    <%=paedsGraphString%>
];
var onGroundsGraphValue = [
    <%=onGroundsGraphString%>
];
var otherGraphValue = [
  	<%=otherGraphString%>
];

<%
	String deptPieGraphString = getDeptPieGraphValueFromDB(searchYearFrom,null,"departmentErrorCount");
	String deptBarInjGraphString = getDeptBarGraphValueFromDB(searchYearFrom,"Injury");
	String deptBarFallGraphString = getDeptBarGraphValueFromDB(searchYearFrom,"Fall");
%>
	var deptPieGraphValue = [<%=deptPieGraphString.toString()%>];
	 var deptBarInjGraphValue = [<%=deptBarInjGraphString%>];
	 var deptBarFallGraphValue = [<%=deptBarFallGraphString%>];
	 
$(document).ready(function(){
	$('#departmentTable').show();
	displayDeptBarGraph([patientRoomGraphValue, bathRoomGraphValue, hallGraphValue,
                         deliverySuiteGraphValue,treatmentRoomGraphValue,otRrGraphValue,
                         pharmacyGraphValue,radiologyGraphValue,opdGraphValue,
                         icuGraphValue,labGraphValue,paedsGraphValue,
                         onGroundsGraphValue,otherGraphValue]);	
	displayDeptPieGraph('departPieGraph',deptPieGraphValue);
	displayDeptIncidentBarGraph("deptInjGraph",deptBarInjGraphValue,"Injury");
	displayDeptIncidentBarGraph("deptFallGraph",deptBarFallGraphValue,"Fall");
	
});
<%}%>

<%	
if(searchYearFrom != null && searchYearFrom.length()>0 && searchYearTo!= null  && searchYearTo.length()>0 && 
	"analysis".equals(reportType)){
	
	Integer intYearFrom = Integer.parseInt(searchYearFrom);
	Integer intYearTo = Integer.parseInt(searchYearTo);
	ArrayList<String> listOfAnalysisGraphValue = new ArrayList<String>();
	StringBuffer legendString = new StringBuffer();
	for(;intYearFrom<=intYearTo;intYearFrom++){
		listOfAnalysisGraphValue.add(getAnalysisGraphValueFromDB(Integer.toString(intYearFrom)));
		legendString.append("'"+Integer.toString(intYearFrom)+"'");
		if(intYearFrom<intYearTo){
			legendString.append(",");
		}
	}
	StringBuffer analysisGraphString=new StringBuffer();
	for(int i = 0;i<listOfAnalysisGraphValue.size();i++){
		analysisGraphString.append("["+ listOfAnalysisGraphValue.get(i) + "]");
		if(i<listOfAnalysisGraphValue.size()-1){
			analysisGraphString.append(",");
		}
	}	
	
	String analysisPieGraphString = getDeptPieGraphValueFromDB(searchYearFrom,searchYearTo,"analysisErrorCount");
%>

var analysisGraphArray = [<%=analysisGraphString.toString()%>];
var analysisLegendString = [<%=legendString.toString()%>]
var analysisPieGraphValue = [<%=analysisPieGraphString.toString()%>];

$(document).ready(function(){	
	$('#analysisTable').show();
	displayAnalysisIncidentBarGraph('analysisGraph',analysisGraphArray,analysisLegendString);
	displayDeptPieGraph('analysisPieGraph',analysisPieGraphValue);
});
<%}%>

function displayEventGraph(type,graphID,graphTitle){
	
	var maxY = Math.max.apply(Math,type);
	if(maxY == 0){
		maxY = 1;
	}else{
		maxY = maxY * 1.5;
	}

	var plot2 = $.jqplot(graphID, [type], {
		   title: {
			   text:graphTitle,
			   fontSize: '15pt',  
			   fontFamily: 'Tahoma',  
			   fontWeight:'bold'		
		   },			   
		   seriesColors: ["#295c8e"],		 	
		   axesDefaults: {  
			  tickRenderer: $.jqplot.CanvasAxisTickRenderer ,  
			  tickOptions: {
		          fontSize: '10pt',  
			      fontFamily: 'Tahoma',  
			      fontWeight:'bold'			      
			      }  
			  },  
			  seriesDefaults: {  	
				  shadow: false, 				  
			     pointLabels: {  
			         show: true,  
			         edgeTolerance: 5  ,			    	        
			    	 formatString: '%s' 
			     },  
			     markerOptions: {  
			    	 shadow: false, 
			     
			        show: true,       
			        style: 'filledCircle'       
	    	      }  
		       },  
		 axes: {
			 xaxis: {
			 	renderer: $.jqplot.CategoryAxisRenderer,
			 	 tickOptions: {		
	                    showGridline: false
	                }		,
			    ticks: ["Jan", "Feb", "Mar", "Apr", "May",
				        "Jun", "Jul", "Aug", "Sep", "Oct",
				       "Nov", "Dec"]
				     },    
				     
			  yaxis: {
				  tickOptions: {
		                formatString: '%.1f '
		            },			  
				 min:-1,
				 max:maxY,			
				label:'No. of Case',
			    labelRenderer: $.jqplot.CanvasAxisLabelRenderer
			
			 }
		 }
	});         
}

function displayDeptBarGraph(graphValue){
	  plot3 = $.jqplot('departBarGraph', graphValue, {
		  title: {
			   text:'Unit Incident Report',
			   fontSize: '15pt',  
			   fontFamily: 'Tahoma',  
			   fontWeight:'bold'		
		   },			      
		  	stackSeries: true,
		  	axesDefaults: {  
				  tickRenderer: $.jqplot.CanvasAxisTickRenderer ,  
				  tickOptions: {
   			          fontSize: '10pt',  
   				      fontFamily: 'Tahoma',  
   				      fontWeight:'bold'			      
   				      }  
				  },
	         seriesDefaults:{
	             renderer:$.jqplot.BarRenderer,
	             shadow: false, 	            
	             pointLabels: {
	            	 show: true,
	            	 ypadding : 0,
			    	 formatString: '%s' }
	         },
	         series: [{label: 'Patient room#'},
	                  {label: 'Bath in patient room'},
	                  {label: 'Hall'},
	                  {label: 'Delivery Suite'},
	                  {label: 'Treatment room'},
	                  {label: 'OT/RR'},
	                  {label: 'Pharmacy'},
	                  {label: 'Radiology'},
	                  {label: 'OPD'},
	                  {label: 'ICU'},
	                  {label: 'Lab'},
	                  {label: 'Paeds'},
	                  {label: 'On grounds'},
	                  {label: 'Other'}],
	         axes: {
				 xaxis: {
				 	renderer: $.jqplot.CategoryAxisRenderer,
				 	 tickOptions: {		
				 		 angle: -30	,
				 		 showGridline: false		                    
		                },
				    ticks: ["Equipment", "Needle Stick","Medication Error", "Fall",
					        "Injury", "Other"]
					     },
					     yaxis: {
							  tickOptions: {
					                formatString: '%.1f '
					            },	 			  
							 					 
							  label:'No. of Incident',
					          labelRenderer: $.jqplot.CanvasAxisLabelRenderer
						 	}
			 },
	         legend: {
	        	 show: true,
	        	    location: 'e',
	        	    placement: 'outside'
	        	    
	         }     
	     });
}


function displayDeptIncidentBarGraph(graphType,value,graphTitle){
	var ticks = ['Patient room#','Bath in patient room','Hall','Delivery Suite',
	             'Treatment room','OT/RR','Pharmacy','Radiology','OPD','ICU','Lab','Paeds',
	             'On grounds','Other'];

	var maxY = Math.max.apply(Math,value);
	if(maxY == 0){
		maxY = 1;
	}else{
		maxY = maxY * 1.5;
	}
	
         plot2 = $.jqplot(graphType, [value], {
        	 title: {
				   text:graphTitle,
				   fontSize: '15pt',  
				   fontFamily: 'Tahoma',  
				   fontWeight:'bold'		
			   },     
             seriesDefaults: {
           	  shadow: false,           
                 renderer:$.jqplot.BarRenderer,
                 rendererOptions:{ varyBarColor : true },
                 pointLabels: {show: true,
                	 ypadding : 0,
			    	 formatString: '%s'}
             },
             axesDefaults: {  
			  tickRenderer: $.jqplot.CanvasAxisTickRenderer ,  
			  tickOptions: {
		          fontSize: '10pt',  
			      fontFamily: 'Tahoma',  
			      fontWeight:'bold'			      
			      }  
			  },
             axes: {
                 xaxis: {
                     renderer: $.jqplot.CategoryAxisRenderer,                     
                     ticks: ticks,
                     tickOptions:{
                    	 angle: -30,
                    	 showGridline: false
                     }
                     
                 },
                 yaxis: {
				  tickOptions: {
		                formatString: '%.1f '
		            },	   			  
				 min:0,
				 max:maxY,
				  label:'No. of Incident',
		          labelRenderer: $.jqplot.CanvasAxisLabelRenderer
			 	}
             },
             series: [
             {seriesColors: [ "#4BB2C5", "#EAA228", "#C5B47F9","#579575",
                              "#839557", "#958C12", "#953579", "#4B5DE4",
                              "#D8B83F", "#FF5800", "#0085CC", "#C747A3",
                              "#CDDF54", "#FBD178"]}
             ]
         });
}

function displayDeptPieGraph(graphType,graphValue){
	var plot1 = jQuery.jqplot (graphType, [graphValue],
            {
		  title: {
			   text:'Unit Incident Report',
			   fontSize: '15pt',  
			   fontFamily: 'Tahoma',  
			   fontWeight:'bold'		
		   },			              
              seriesDefaults: {
            	  shadow: false, 
                renderer: jQuery.jqplot.PieRenderer,
                rendererOptions: {
                	sliceMargin: 4, 
                  showDataLabels: true
                }
              },
              legend: { show:true, location: 'e' }
            }
          );

}


function displayAnalysisIncidentBarGraph(graphType,graphArray,legendString){	
	var maxY = 0;
	for (var i in graphArray) {		
		if($.isArray(graphArray[i])){
		  if(Math.max.apply(Math,graphArray[i]) > maxY){
				maxY = 	Math.max.apply(Math,graphArray[i]);  
		  }
		}
	}
	
	if(maxY==0){
		maxY = 1;
	}else{
		maxY = maxY*1.5;
	}
	
	var plot5 = $.jqplot(graphType, graphArray, {
		   title: {
			   text:'Incident Summary',
			   fontSize: '15pt',  
			   fontFamily: 'Tahoma',  
			   fontWeight:'bold'		
		   },			   
		
		   axesDefaults: {  
			  tickRenderer: $.jqplot.CanvasAxisTickRenderer ,  
			  tickOptions: {
		          fontSize: '10pt',  
			      fontFamily: 'Tahoma',  
			      fontWeight:'bold'			      
			      }  
			  },  
			  seriesDefaults: {  	
				  shadow: false, 				  
			     pointLabels: {  
			         show: true,  
			         edgeTolerance: 5  ,			    	        
			    	 formatString: '%s' 
			     },  
			     markerOptions: {  
			    	 shadow: false, 
			     
			        show: true,       
			        style: 'filledCircle'       
	    	      }  
		       }, 
		       legend: {
		            show: true,
		            placement: 'insideGrid',
		            labels:legendString,
		            location: 'ne',
		            rowSpacing: '0px'
		        },
		 axes: {
			 xaxis: {
			 	renderer: $.jqplot.CategoryAxisRenderer,
			 	 tickOptions: {		
	                    showGridline: false
	                }		,
			    ticks: ["Jan", "Feb", "Mar", "Apr", "May",
				        "Jun", "Jul", "Aug", "Sep", "Oct",
				       "Nov", "Dec"]
				     },    
				     
			  yaxis: {
				  tickOptions: {
		                formatString: '%.1f '
		            },			  
				 min:-1,
				 max:maxY,			
				label:'No. of Case',
			    labelRenderer: $.jqplot.CanvasAxisLabelRenderer
			
			 }
		 }
	});   
}

</script>

