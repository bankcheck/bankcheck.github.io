<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@	page import="java.text.*"%>

<%!

private static ArrayList getAllBeds(String ward) {

StringBuffer sqlStr = new StringBuffer();
sqlStr.append("SELECT B.BEDCODE ");
sqlStr.append("FROM BED@IWEB B,ROOM@IWEB M,WARD@IWEB W ");
sqlStr.append("WHERE   B.ROMCODE = M.ROMCODE ");
sqlStr.append("AND    M.WRDCODE = W.WRDCODE ");
sqlStr.append("AND		B.BEDOFF = '-1' ");
if(ward!=null && ward.length()>0){
	sqlStr.append("AND W.WRDCODE = '" + ward +"' ");
}
sqlStr.append("ORDER BY B.BEDCODE ");

//System.out.println(sqlStr.toString());

return UtilDBWeb.getReportableList(sqlStr.toString());
}

/*
SELECT DECODE(H.HAT_ACMCODE, NULL, I.ACMCODE, H.HAT_ACMCODE) , I.BEDCODE, R.PATNO, P.PATSEX, R.DOCCODE, B.CABLABRMK, B.ESTSTAYLEN
FROM REG@IWEB R, INPAT@IWEB I, BEDPREBOK@IWEB B, PATIENT@IWEB P, HAT_BED_DETAIL H
WHERE R.REGSTS = 'N'
AND   R.REGTYPE = 'I'
AND   I.INPDDATE IS null
AND   R.PBPID = B.PBPID(+)
AND   R.INPID = I.INPID
AND   P.PATNO = R.PATNO
AND   H.HAT_BEDCODE(+) = I.BEDCODE
AND   ((H.HAT_PERIOD >= TO_DATE(TO_CHAR(SYSDATE, 'dd/mm/yyyy')||' 00:00:00', 'DD/MM/YYYY HH24:MI:SS')
AND   H.HAT_PERIOD <= TO_DATE(TO_CHAR(SYSDATE, 'dd/mm/yyyy')||' 23:59:59', 'DD/MM/YYYY HH24:MI:SS')) OR H.HAT_PERIOD IS NULL)
*/

public static ArrayList getBedsClass(String wardCode){
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT H.HAT_ACMCODE,HAT_BEDCODE ");
	sqlStr.append("FROM HAT_BED_DETAIL H ");
	sqlStr.append("WHERE   ((H.HAT_PERIOD >= TO_DATE(TO_CHAR(SYSDATE, 'dd/mm/yyyy')||' 00:00:00', 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("AND   H.HAT_PERIOD <= TO_DATE(TO_CHAR(SYSDATE, 'dd/mm/yyyy')||' 23:59:59', 'DD/MM/YYYY HH24:MI:SS')) OR H.HAT_PERIOD IS NULL) ");
	sqlStr.append("AND   H.HAT_WRDCODE = '" + wardCode +"' ");
	sqlStr.append("ORDER BY H.HAT_ACMCODE,HAT_BEDCODE ");
	
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private static ArrayList getBedStatus(String wardCode) {

	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT I.ACMCODE,B.BEDCODE,R.PATNO ,PAT.PATSEX,D.DOCFNAME||' '||D.DOCGNAME, ");
	sqlStr.append("P.CABLABRMK , DECODE(P.ESTSTAYLEN,NULL,3,P.ESTSTAYLEN) ,TO_CHAR(R.REGDATE , 'DD/MM/YYYY HH24:MI:SS') ");
	sqlStr.append("FROM  REG@IWEB R, INPAT@IWEB I, BEDPREBOK@IWEB P,");
	sqlStr.append("WARD@IWEB W, ROOM@IWEB M, BED@IWEB B,DOCTOR@IWEB D,PATIENT@IWEB PAT ");
	sqlStr.append("WHERE  R.INPID = I.INPID ");
	sqlStr.append("AND PAT.PATNO = R.PATNO ");
	sqlStr.append("AND    I.BEDCODE = B.BEDCODE ");
	sqlStr.append("AND    B.ROMCODE = M.ROMCODE ");
	sqlStr.append("AND    M.WRDCODE = W.WRDCODE ");
	sqlStr.append("AND R.PBPID = P.PBPID(+) ");
	sqlStr.append("AND D.DOCCODE(+) = R.DOCCODE ");
	sqlStr.append("AND I.INPDDATE IS null ");
	sqlStr.append("AND R.REGTYPE = 'I' ");
	sqlStr.append("AND R.REGSTS = 'N' ");
	
	if(wardCode!=null && wardCode.length()>0){
		sqlStr.append("AND W.WRDCODE = '" + wardCode +"' ");
	}
	sqlStr.append("ORDER BY  B.BEDCODE ");
	
	//System.out.println(sqlStr.toString());

	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private static ArrayList getToBeAdmitPatient(String wardCode) {
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("	SELECT P.ACMCODE,P.BEDCODE, P.PATNO,P.PATFNAME||' '||P.PATGNAME,P.SEX,D.DOCFNAME||' '||D.DOCGNAME,P.CABLABRMK,DECODE(P.ESTSTAYLEN,NULL,3,P.ESTSTAYLEN) ,TO_CHAR(P.BPBHDATE , 'DD/MM/YYYY HH24:MI:SS') ,P.PBPID ");
	sqlStr.append("	FROM BEDPREBOK@IWEB P,DOCTOR@IWEB D ");
	sqlStr.append("	WHERE P.BPBHDATE  >= SYSDATE  ");
	sqlStr.append("AND P.BPBSTS = 'N' ");
	sqlStr.append("AND D.DOCCODE(+) = P.DOCCODE  ");
	if(wardCode!=null && wardCode.length()>0){
		sqlStr.append("	AND P.WRDCODE = '" + wardCode +"' ");	
	}

	sqlStr.append("ORDER BY P.BEDCODE, P.BPBHDATE");
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}

private static ArrayList getOTProc(String pbpID) {
	
	StringBuffer sqlStr = new StringBuffer();
	
	sqlStr.append("SELECT P.OTPDESC , A.PBPID ");
	sqlStr.append("FROM OT_APP@IWEB A, OT_PROC@IWEB P ");
	sqlStr.append("WHERE A.OTPID = P.OTPID  ");
	if(pbpID!=null && pbpID.length()>0){
		sqlStr.append("AND A.PBPID = '" + pbpID +"' ");	
	}

	sqlStr.append("ORDER BY P.OTPDESC");
	//System.out.println(sqlStr.toString());
	return UtilDBWeb.getReportableList(sqlStr.toString());
}


private ArrayList<String> fetchAllWardCode() {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT W.WRDCODE, WRDNAME ");
	sqlStr.append("FROM WARD@IWEB W ");
	sqlStr.append("WHERE W.WRDNAME not like '%CLOSED%' ");
	sqlStr.append("ORDER BY W.WRDCODE ");
	
	ArrayList record = UtilDBWeb.getReportableList(sqlStr.toString());
	ArrayList<String> wards = new ArrayList<String>();
	ReportableListObject row = null;
	
	if(record.size() > 0) {
		for(int i = 0; i < record.size(); i++) {
			row = (ReportableListObject) record.get(i);
			wards.add(row.getValue(0));
		}
	}
	
	return wards;
}

private String getEstimatedDischargeDate(String tempAdmitDate, String tempStayLength){
	String stayLength = tempStayLength;
	String admitDateD = tempAdmitDate;
	String eDate ="";
	if(stayLength.length()>0 && admitDateD.length()>0){
			
		String[] admitADate = admitDateD.split(" ");
		String[] admitDate = admitADate[0].split("/");
		String admitDay = admitDate[0];
		String admitMonth = admitDate[1];
		String admitYear = admitDate[2];
		
		String[] admitTime = admitADate[1].split(":");
		String admitHour = admitTime[0];
		String admitMinute = admitTime[1];
		
		Calendar estDischargeDate = Calendar.getInstance();
	
		estDischargeDate.set( Integer.parseInt(admitYear),  Integer.parseInt(admitMonth)-1,  Integer.parseInt(admitDay), 
				 Integer.parseInt(admitHour),  Integer.parseInt(admitMinute)) ;
		estDischargeDate.add(Calendar.DAY_OF_MONTH,Integer.parseInt(stayLength));
		
		SimpleDateFormat sdfd = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
		eDate = sdfd.format(estDischargeDate.getTime());
	}
		return eDate;
}
%>

<%
String ward = request.getParameter("ward");
String afterToday = request.getParameter("add");

Calendar cal = Calendar.getInstance();
cal.add(Calendar.DAY_OF_MONTH, Integer.parseInt(afterToday));
SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy", Locale.ENGLISH);
String date = sdf.format(cal.getTime());


ArrayList<String> wards = fetchAllWardCode();

String[] units = new String[]{"ICU", "IU", "Medical", "OB", "Pediatric", "Surgical", "Specialty", "OT<br/>Cases", "CCIC<br/>Cases"};

%>

	<tr>
		<td rowspan="2" >
<%
		for(int i = 0; i < 6; i++) {
%>
				<div style="float:left; width:100%;">
					<div style="float:left"><input index=<%=i %> name="ward" type="radio" value="<%=units[i]%>"/><label><%=units[i]%></label></div>
				</div>
<%		
		}
%>
		</td><td>&nbsp;</td><td colspan="12"><div id="targetWardLabel"></div></td>
	</tr>
	<tr>
		<td>&nbsp;</td>
		<td colspan='12'  class="title" style="width:11%; border-style:outset; border-width:1px;">
			<span class="date"><font size="3"><%=date %></font></span>
		</td>		
	</tr>
	<tr>
		<td colspan='2'>&nbsp;</td>
		<td colspan='5' class="current_patient" style="border-style:outset; border-width:1px;">
			<span class="date"><font size="3">Current Patient</font></span>
		</td>
		<td colspan='7' class="to_be_admit" style="border-style:outset; border-width:1px;">
			<span class="date"><font size="3">To be Admit</font></span>
		</td>
	</tr>
	<tr>	
		<td style="width:7%; border-style:outset; border-width:1px;" class="booked">Class</td>	
		<td style="width:6%; border-style:outset; border-width:1px;" class="booked">Bed</td>		
		<td style="width:7%; border-style:outset; border-width:1px;" class="booked">Pat No.</td>
		<td style="width:5%; border-style:outset; border-width:1px;" class="booked">Gender</td>
		<td style="width:8%; border-style:outset; border-width:1px;" class="booked">Dr. Name</td>
		<td style="width:8%; border-style:outset; border-width:1px;" class="booked">Diagnosis</td>
		<td style="width:6%; border-style:outset; border-width:1px;" class="booked">Estimated Discharge</td>
		<td style="width:7%; border-style:outset; border-width:1px;" class="booked">Pat No.</td>
		<td style="width:8%; border-style:outset; border-width:1px;" class="booked">Name</td>
		<td style="width:5%; border-style:outset; border-width:1px;" class="booked">Gender</td>
		<td style="width:8%; border-style:outset; border-width:1px;" class="booked">Dr. Name</td>
		<td style="width:8%; border-style:outset; border-width:1px;" class="booked">Diagnosis</td>
		<td style="width:7%; border-style:outset; border-width:1px;" class="booked">Estimated Discharge</td>
		<td style="width:10%; border-style:outset; border-width:1px;" class="booked">OT Proc</td>
	</tr>
<%
ArrayList allBeds = getAllBeds((String)wards.get(Integer.parseInt(ward)));
ArrayList bedsClass = getBedsClass((String)wards.get(Integer.parseInt(ward)));
ArrayList currentPatientRecord = getBedStatus((String)wards.get(Integer.parseInt(ward)));
ArrayList toBeAdmitPatientRecord = getToBeAdmitPatient((String)wards.get(Integer.parseInt(ward)));

ArrayList<String> bedIDList = new ArrayList<String>();
ArrayList<BedClass> bedClassList = new ArrayList<BedClass>();
ArrayList<CurrentPatient> currentPatientList = new ArrayList<CurrentPatient>();
ArrayList<ToBeAdmitPatient> toBeAdmitPatientList = new ArrayList<ToBeAdmitPatient>();

if(allBeds.size() != 0){	
	for(int i = 0;i< allBeds.size();i++){
		ReportableListObject allBedsRow = (ReportableListObject)allBeds.get(i);
		bedIDList.add(allBedsRow.getValue(0));	
	}
}



if(bedsClass.size() != 0){	
	for(int i = 0;i< bedsClass.size();i++){
		ReportableListObject allBedsClassRow = (ReportableListObject)bedsClass.get(i);			
		BedClass tempBedClass = new BedClass(allBedsClassRow.getValue(0),allBedsClassRow.getValue(1));
		bedClassList.add(tempBedClass);
	}
}

ArrayList<BedClass> allBedClassList = new ArrayList<BedClass>();

for(BedClass bc : bedClassList){
	
	BedClass tempBedClass = null;
	for(String b : bedIDList){
		if(b.equals(bc.bed)){
			tempBedClass = new BedClass(bc.classType,bc.bed);
			bedIDList.remove(bc.bed);
			allBedClassList.add(tempBedClass);	
			break;
		}
	}
}

for(String s : bedIDList){
	BedClass tempBedClass = new BedClass(null,s);
	allBedClassList.add(tempBedClass);
}
/*
for(BedClass bc : allBedClassList){
	System.out.println("CLASS " + bc.classType + " BED " + bc.bed);
}
*/
for(BedClass bc : bedClassList){
	String acm = bc.classType;	
	boolean patientFound = false;
	for(int i = 0;i< currentPatientRecord.size();i++){		
		ReportableListObject currentPatientRow = (ReportableListObject)currentPatientRecord.get(i);	
		if(currentPatientRow.getValue(1).equals(bc.bed)){
			 acm = bc.classType;
			if(acm == null){
				acm = currentPatientRow.getValue(0);
			}
			String eDate = getEstimatedDischargeDate( currentPatientRow.getValue(7),currentPatientRow.getValue(6));
							
			CurrentPatient tempPatient = new CurrentPatient(acm,currentPatientRow.getValue(1)
				,currentPatientRow.getValue(2),currentPatientRow.getValue(3),currentPatientRow.getValue(4)
				,currentPatientRow.getValue(5),eDate);			
			currentPatientList.add(tempPatient);
			patientFound = true;
			break;			
		}	
	}
	if(patientFound == false){
		CurrentPatient tempPatient = new CurrentPatient(acm,bc.bed,null,null,null,null,null);			
			currentPatientList.add(tempPatient);
	}
	
	boolean toBeAdmitPatientFound = false;
	for(int i = 0;i< toBeAdmitPatientRecord.size();i++){		
		ReportableListObject toBeAdmitPatientRow = (ReportableListObject)toBeAdmitPatientRecord.get(i);	
		if(toBeAdmitPatientRow.getValue(1).equals(bc.bed)){
		
			String eDate = getEstimatedDischargeDate( toBeAdmitPatientRow.getValue(8),toBeAdmitPatientRow.getValue(7));
							
			ToBeAdmitPatient tempPatient = new ToBeAdmitPatient(toBeAdmitPatientRow.getValue(0),toBeAdmitPatientRow.getValue(1)
				,toBeAdmitPatientRow.getValue(2),toBeAdmitPatientRow.getValue(3),toBeAdmitPatientRow.getValue(4)
				,toBeAdmitPatientRow.getValue(5),toBeAdmitPatientRow.getValue(6),eDate,toBeAdmitPatientRow.getValue(9));			
			toBeAdmitPatientList.add(tempPatient);
			toBeAdmitPatientFound = true;
			break;			
		}	
	}
	if(toBeAdmitPatientFound == false){
		ToBeAdmitPatient tempPatient = new ToBeAdmitPatient(acm,bc.bed,null,null,null,null,null,null,null);			
			toBeAdmitPatientList.add(tempPatient);
	}
			
}
	
for(CurrentPatient cp : currentPatientList){
	String acm = cp.classType;
	if(acm.equals("I")){
		acm = "VIP";
	}else if(acm.equals("P")){
		acm = "PRIVATE";
	}else if(acm.equals("S")){
		acm = "SEMI-PRIVATE";
	}else if(acm.equals("T")){
		acm = "STANDARD";
	}else{
		acm = "no_patient";
	}
%>
	<tr>
	<td class='<%=acm %>'><%=(!acm.equals("no_patient"))?acm:"" %></td>
	<td class='<%=acm %>'><%=(cp.bed!=null)?cp.bed:"" %></td>
	<td class='<%=(cp.patNo==null)?"no_patient":"current_patient" %>'><%=(cp.patNo!=null)?cp.patNo:"" %></td>
	<td class='<%=(cp.patNo==null)?"no_patient":"current_patient"%>'><%=(cp.gender!=null)?cp.gender:"" %></td>
	<td class='<%=(cp.patNo==null)?"no_patient":"current_patient"%>'><%=(cp.drName!=null)?cp.drName:"" %></td>
	<td class='<%=(cp.patNo==null)?"no_patient":"current_patient"%>'><%=(cp.diagnosis!=null)?cp.diagnosis:"" %></td>
	<td class='<%=(cp.patNo==null)?"no_patient":"current_patient"%>'><%=(cp.estimatedDischarge!=null)?cp.estimatedDischarge:""%></td>	
	
<%


	for(ToBeAdmitPatient tbap:toBeAdmitPatientList){
		if(cp.bed.equals(tbap.bed)){
%>
	<td class='<%=(tbap.patNo==null)?"no_patient":"to_be_admit"  %>'><%=(tbap.patNo!=null)?tbap.patNo:"" %></td>
	<td class='<%=(tbap.patNo==null)?"no_patient":"to_be_admit"  %>'><%=(tbap.patName!=null)?tbap.patName:"" %></td>
	<td class='<%=(tbap.patNo==null)?"no_patient":"to_be_admit"  %>'><%=(tbap.gender!=null)?tbap.gender:"" %></td>
	<td class='<%=(tbap.patNo==null)?"no_patient":"to_be_admit"  %>'><%=(tbap.drName!=null)?tbap.drName:"" %></td>
	<td class='<%=(tbap.patNo==null)?"no_patient":"to_be_admit"  %>'><%=(tbap.diagnosis!=null)?tbap.diagnosis:""%></td>
	<td class='<%=(tbap.patNo==null)?"no_patient":"to_be_admit"  %>'><%=(tbap.estimatedDischarge!=null)?tbap.estimatedDischarge:"" %></td>	
<%
	String otProcRecord = null;
	if(tbap.pbpID!=null){
		ArrayList toBeAdmitPatientOTProcRecord = getOTProc(tbap.pbpID);		
		for(int i = 0;i< toBeAdmitPatientOTProcRecord.size();i++){		
			ReportableListObject toBeAdmitPatientOTProcRow = (ReportableListObject)toBeAdmitPatientOTProcRecord.get(i);	
			if(toBeAdmitPatientOTProcRow.getValue(0).length()>0){
				if(i == 0){
					otProcRecord = toBeAdmitPatientOTProcRow.getValue(0);
				}else{
					otProcRecord = otProcRecord + " , " + toBeAdmitPatientOTProcRow.getValue(0);
				}
			}
		}		
	}
%>
	<td class='<%=(tbap.patNo==null)?"no_patient":"to_be_admit"  %>'><%=(otProcRecord!=null)?otProcRecord:"" %></td>	
	
	</tr>
<%		
	}
}
}
	
%>
<%!
public class  CurrentPatient{
	String classType;
	String bed;
	String patNo;
	String gender;
	String drName;
	String diagnosis;
	String estimatedDischarge;
	
	public CurrentPatient(String classType, String bed,String patNo, String gender,
			String drName , String diagnosis,String estimatedDischarge){
		
		this.classType = classType;
		this.bed =  bed;
		this.patNo = patNo;
		this.gender = gender;
		this.drName = drName;
		this.diagnosis = diagnosis;
		this.estimatedDischarge = estimatedDischarge;
	}
	
}

public class ToBeAdmitPatient{
	String classType;
	String bed;
	String patNo;
	String patName;
	String gender;
	String drName;
	String diagnosis;
	String estimatedDischarge;
	String pbpID;
	
	public ToBeAdmitPatient(String classType, String bed,String patNo, String patName,String gender,
			String drName , String diagnosis,String estimatedDischarge,String pbpID){
		
		this.classType = classType;
		this.bed =  bed;
		this.patNo = patNo;
		this.patName = patName;
		this.gender = gender;
		this.drName = drName;
		this.diagnosis = diagnosis;
		this.estimatedDischarge = estimatedDischarge;
		this.pbpID = pbpID;
	}
}

public class BedClass{
	String classType;
	String bed;
	
	
	public BedClass(String classType, String bed){		
		this.classType = classType;
		this.bed =  bed;		
	}
}

%>

	
	
	
	
	