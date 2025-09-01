<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="java.util.Calendar"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>
<%@ page import="com.hkah.constant.ConstantsServerSide"%>
<%@ page import="com.hkah.servlet.HKAHInitServlet"%>
<% 
String fromDate = request.getParameter("fromDate");
String toDate = request.getParameter("toDate");
String leaveType = request.getParameter("leaveType");
String FTE = request.getParameter("FTE");

%>
<%!
int countIndex = 0;

private String countML(String fromDate){
	ArrayList<String> dateList = new ArrayList<String>();
	Calendar calendar = Calendar.getInstance();
	SimpleDateFormat Format = new SimpleDateFormat("dd/MM/yyyy"); 
	Calendar startCalendar = Calendar.getInstance();
	Date endDate = null;

	try{
		endDate =Format.parse(fromDate);
		}catch(Exception e){
			System.out.println(e);
		}
	int countML = 0;
	 if(endDate != null){
		 calendar.setTime(endDate);
		while(countML <50){
			endDate = calendar.getTime();
			if (isWeekday(endDate) && !isPublicHoliday(endDate)){
				countML++;
			}
			calendar.add(Calendar.DATE, 1);
		}
		return Format.format(endDate); 
	 }	
	return null;
}
private static boolean isPublicHoliday(Date date)
{
	StringBuffer sqlStr = new StringBuffer();
	ArrayList record = new ArrayList();
	
    if (date == null){
        return false;
    }
	SimpleDateFormat Format = new SimpleDateFormat("dd/MM/yyyy"); 
	sqlStr.append(" select 1 from el_public_holiday ");
	sqlStr.append(" where to_date('"+Format.format(date)+"','dd/mm/yyyy') = el_holiday ");
	record = UtilDBWeb.getReportableList(sqlStr.toString());
	if (record.size() > 0) {
		return true;
	}else{
		return false;
	}
	

    
}
private static Integer countMLHoursByPeriod(Date fromDate,Date toDate){
	int countHR = 0;
	
	Calendar calendar = Calendar.getInstance();
	 if(fromDate != null && toDate != null){
		calendar.setTime(fromDate);
		do{
			if (isWeekday(fromDate) && !isPublicHoliday(fromDate)){
				countHR++;
			}
			calendar.add(Calendar.DATE, 1);
			fromDate = calendar.getTime();						
		}while(!fromDate.after(toDate));
	 }
		return (countHR*8) ; 
}
private static boolean isWeekday(Date d)
{
    if (d == null)
        return false;

    Calendar calendar = Calendar.getInstance();
    calendar.setTime(d);
    int dayOfWeek = calendar.get(Calendar.DAY_OF_WEEK);

    return ((dayOfWeek >= Calendar.MONDAY) && (dayOfWeek <= Calendar.FRIDAY));
}
private String split(ArrayList dateList,String fromDate, String toDate,int countIndex,String leaveType,String FTE){
SimpleDateFormat Format = new SimpleDateFormat("dd/MM/yyyy"); 
Calendar fromCalendar = Calendar.getInstance();
Calendar endCalendar = Calendar.getInstance();
StringBuffer outputStr = new StringBuffer();
int getSlotHr = 0;
	try{
	fromCalendar.setTime(Format.parse(fromDate));
	endCalendar.setTime(Format.parse(toDate));
	}catch(Exception e){
		System.out.println(e);
	}
	Calendar splitCalendar = Calendar.getInstance();
	splitCalendar.set(fromCalendar.get(Calendar.YEAR),(fromCalendar.get(Calendar.MONTH)),Integer.parseInt("20"));
	if(fromCalendar.after(splitCalendar)){
		splitCalendar.add(Calendar.MONTH,1);
		System.out.println("[changeSplit]"+Format.format(splitCalendar.getTime()));
	}
	if(endCalendar.before(splitCalendar)|| endCalendar.equals(splitCalendar)){
		System.out.println("[slot]"+fromDate+"to"+toDate);
		try{
			getSlotHr = countMLHoursByPeriod(Format.parse(fromDate),Format.parse(toDate));
		}catch(Exception e){
			System.out.println(e);
		}
		countIndex++;
			outputStr.append("<tr><td class=\"infoLabel\">From</td><td width=\"30%\" class=\"fromClass\" index=\""+countIndex+"\">"+fromDate+"</td>");
			outputStr.append("<td class=\"infoLabel\">To</td><td width=\"30%\" class=\"toClass\" index=\""+countIndex+"\">"+toDate+"</td>");
			outputStr.append("<td  width=\"7%\" class=\"infoLabel\">Hour(s)</td>");
			outputStr.append("<td width=\"40%\">");
			outputStr.append("<select name=\"appliedHourAL_"+countIndex+"\" class=\"hrClass\" ");
			if("ML".equals(leaveType)){
			outputStr.append(" disabled=\"disabled\"");
			}
			outputStr.append(" index=\""+countIndex+"\">");
			if("ML".equals(leaveType)){
				outputStr.append("<option value=\""+getSlotHr+"\">"+getSlotHr+"</option>");
			}else{
				for (int i = 0; i <= 240; i++) {
					outputStr.append("<option value=\""+i+"\">"+i+"</option>");
					}
			}
			outputStr.append("</select>");
			outputStr.append("    .   ");
			outputStr.append("<select name=\"appliedHourDec1AL_"+countIndex+"\" class=\"dec1Class\" ");
			if("ML".equals(leaveType)){
				outputStr.append(" disabled=\"disabled\"");
				}
			outputStr.append(" index=\""+countIndex+"\">");
			if("0.5".equals(FTE)){
				outputStr.append("<option value=\"00\">00</option>");
				outputStr.append("<option value=\"25\">25</option>");
				outputStr.append("<option value=\"50\">50</option>");
				outputStr.append("<option value=\"75\">75</option>");
			}else{
				for (int i = 0; i < 10; i++) {
					outputStr.append("<option value=\""+i+"\">"+i+"</option>");
					}
			}
			outputStr.append("</select>");
			outputStr.append("<select name=\"appliedHourDec2AL_"+countIndex+"\" class=\"dec2Class\" ");
			if("ML".equals(leaveType)){
				outputStr.append(" disabled=\"disabled\"");
				}
			outputStr.append(" index=\""+countIndex+"\">");		
			if("0.5".equals(FTE)){
				outputStr.append("<option value=\"0\"></option>");
			}else{
				for (int i = 0; i < 10; i++) {
					outputStr.append("<option value=\""+i+"\">"+i+"</option>");
					}				
			}
			outputStr.append("</select></td>");	
			outputStr.append("</tr>");	
			
	}else if (endCalendar.after(splitCalendar)){
		System.out.println("[anotherSlot]"+fromDate+"to"+Format.format(splitCalendar.getTime()));
		System.out.println("[slot]"+fromDate+"to"+toDate);
		try{
			getSlotHr = countMLHoursByPeriod(Format.parse(fromDate),Format.parse(Format.format(splitCalendar.getTime())));
		}catch(Exception e){
			System.out.println(e);
		}
		countIndex++;
		outputStr.append("<tr><td class=\"infoLabel\">From</td><td width=\"30%\" class=\"fromClass\" index=\""+countIndex+"\">"+fromDate+"</td>");
		outputStr.append("<td class=\"infoLabel\">To</td><td width=\"30%\" class=\"toClass\" index=\""+countIndex+"\">"+Format.format(splitCalendar.getTime())+"</td>");
		outputStr.append("<td class=\"infoLabel\">Hour(s)</td>");
		outputStr.append("<td width=\"40%\">");
		outputStr.append("<select name=\"appliedHourAL_"+countIndex+"\" class=\"hrClass\"");
		if("ML".equals(leaveType)){
			outputStr.append(" disabled=\"disabled\"");
			}
		outputStr.append(" index=\""+countIndex+"\">");
		if("ML".equals(leaveType)){
			outputStr.append("<option value=\""+getSlotHr+"\">"+getSlotHr+"</option>");
		}else{
			for (int i = 0; i <= 240; i++) {
				outputStr.append("<option value=\""+i+"\">"+i+"</option>");
				}
		}
		outputStr.append("</select>");
		outputStr.append("    .   ");
		outputStr.append("<select name=\"appliedHourDec1AL_"+countIndex+"\" class=\"dec1Class\" ");
		if("ML".equals(leaveType)){
				outputStr.append(" disabled=\"disabled\"");
				}
			outputStr.append(" index=\""+countIndex+"\">");	
			if("0.5".equals(FTE)){
				outputStr.append("<option value=\"00\">00</option>");
				outputStr.append("<option value=\"25\">25</option>");
				outputStr.append("<option value=\"50\">50</option>");
				outputStr.append("<option value=\"75\">75</option>");
			}else{
				for (int i = 0; i < 10; i++) {
					outputStr.append("<option value=\""+i+"\">"+i+"</option>");
					}
			}
		outputStr.append("</select>");
		outputStr.append("<select name=\"appliedHourDec2AL_"+countIndex+"\" class=\"dec2Class\" ");
		if("ML".equals(leaveType)){
			outputStr.append(" disabled=\"disabled\"");
			}
		outputStr.append(" index=\""+countIndex+"\">");		
		if("0.5".equals(FTE)){
			outputStr.append("<option value=\"0\"></option>");
		}else{
			for (int i = 0; i < 10; i++) {
				outputStr.append("<option value=\""+i+"\">"+i+"</option>");
				}				
		}
		outputStr.append("</select></td>");	
		outputStr.append("</tr>");	
		splitCalendar.add(Calendar.DATE,1);
		outputStr.append(split(dateList,Format.format(splitCalendar.getTime()).toString(),toDate,countIndex,leaveType,FTE));
		
		//System.out.println("[SplitMethod]"+Format.format(splitCalendar.getTime()).toString()+"and"+toDate);
	}
		if(outputStr.length()>0){
			return outputStr.toString();
		}else{
			return null;
		}
}
%> 
<%
ArrayList<String> dateList = new ArrayList<String>();

%>
<table style="padding:5px;">
<%if("ML".equals(leaveType)){ 
	toDate = countML(fromDate);
	
}%>
<%=split(dateList,fromDate,toDate,countIndex,leaveType,FTE)%>

</table>
