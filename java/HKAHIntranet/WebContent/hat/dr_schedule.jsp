<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page language="java" %>
<%@ page import="java.text.*" %>
<%@ page import="java.util.*" %>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<html>
<meta http-equiv="refresh" content=1200>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<HEAD>
<TITLE>Adventist Hospital - Dr Schedule (Updated@20090806)</TITLE>

<STYLE TYPE="text/css">
body { margin-left:0px; margin-top:0px;	margin-right:0px; margin-bottom:0px;
       font-family:  "Arial", "Verdana", "sans-serif", "細明體";  font-size: 13x; }
td { font-family:  "Arial", "Verdana", "sans-serif";  font-size: 12px; }
th { font-family:  "Arial", "Verdana", "sans-serif";  font-size: 12px; }
td.sub { font-family: "Arial", "Verdana",  "sans-serif"; font-weight:700; font-size:12px; color:333333}
td.dr  { font-family: "Arial", "Verdana",  "sans-serif"; font-weight:700; font-size:12px;color:383838}
td.caption { font-family: "Verdana", "Arial"; font-weight:700; font-size:13px; color:#881188;}
</STYLE>

<%
//======== connect to database ===========
int i=0, j=0, Cnt=0;
String sysdate="", html="", sql="  ", createstamp;

html += "<script> \n";
html += " //========== Control File of Doctor Schedule ======== \n"; 
html += " var schedule = new Array(); \n";
html += " var display = new Array(); \n";
html += " var i=0;  \n";
out.println(html);

sql += " select distinct ";
sql += "   'schedule[i++] = new Array( ''' || cis.f_get_eng_spcname(a.doccode)  || ''','''  ";
sql += "    || cis.f_get_chn_spcname(a.doccode) || ''','''   || b.docfname||' '||b.docgname || ''',''' ";
sql += "    || (case when doccname>' ' then doccname end) || ''',''' || a.doccode || ''',' "; 
sql += "    || temday || ',''' || to_char(temstime,'HH24:MI')  ";
sql += "    || ''',''' || to_char(temetime,'HH24:MI') || ''' )' as line ";
sql += "    , to_char( sysdate, 'dd/mm/yyyy hh24:mi:ss' ) as dt ";
sql += " from template@hat a, doctor@hat b  ";
sql += " where a.doccode=b.doccode and docsts=-1 and b.spccode in  ";
sql += "      (select spccode from spec@hat where spccname is not null) ";
sql += " order by 1 ";

ArrayList record = UtilDBWeb.getReportableListCIS(sql);
ReportableListObject row = null;
for (i = 0; i < record.size(); i++) {
   row = (ReportableListObject) record.get(i);
   out.println( row.getValue(0) );
   sysdate = row.getValue(1);
};

out.println( " var createstamp = '" + sysdate + "';" ); 
out.println( "</script> ");
%>

<script>
  var ch_style= '<span style="font-size=17px;font-family=細明體;Font-weight=700;">'
  var en_style= '<span style="font-size=12px;font-family=Arial;Font-weight=700;Color:DarkBlue;">'
  var tm_style= '<span style="font-size=13px;font-family=Arial;Font-weight=700;Color:Black;">'
  var colors   = new Array( '#FEFEFE', '#C0F0C0', '#D0D0F0', '#F0D0D0' )
  var startpos = -1
  var speed    = 5000;  
  var skiprow  = 1;
  var MaxShow  = 22
  
function scrolltable() {   

    //startpos = ( startpos+20 > display.length? 0 : startpos + skiprow );
    startpos = (startpos + skiprow)%display.length;
    specialty = ''
    //parent.content.window.location.reload(true)
    bodyhtml = '<table border=1 width="100%" cellpadding=0 cellspacing=0 valign=top>\n'
    bodyhtml += '<tr bgcolor=#EEEEEE>'
    bodyhtml += '  <td width=26% class=caption>&nbsp;'+ch_style+'&nbsp;門診服務<br>'+en_style+'&nbsp;&nbsp;&nbsp;&nbsp;Clinic</td>\n'
    bodyhtml += '  <td width=20% class=caption>&nbsp;'+ch_style+'&nbsp;醫生/專業人士<br>'+en_style+'&nbsp;&nbsp;&nbsp;&nbsp;Doctor / Professional</td>\n'
    bodyhtml += '  <td width=9% class=caption align=center>'+ch_style+'&nbsp;星期日<br>'+en_style+'&nbsp;Sunday</td>\n'
    bodyhtml += '  <td width=9% class=caption align=center>'+ch_style+'&nbsp;星期一<br>'+en_style+'&nbsp;Monday</td>\n'
    bodyhtml += '  <td width=9% class=caption align=center>'+ch_style+'&nbsp;星期二<br>'+en_style+'&nbsp;Tuesday</td>\n'
    bodyhtml += '  <td width=9% class=caption align=center>'+ch_style+'&nbsp;星期三<br>'+en_style+'&nbsp;Wednesday</td>\n'
    bodyhtml += '  <td width=9% class=caption align=center>'+ch_style+'&nbsp;星期四<br>'+en_style+'&nbsp;Thursday</td>\n'
    bodyhtml += '  <td width=9% class=caption align=center>'+ch_style+'&nbsp;星期五<br>'+en_style+'&nbsp;Friday</td>\n'
    bodyhtml += '</tr>\n'
    bodyhtml += '<!------------------- Script to show schedule ---------------------->\n'
    ln=0;
    for (i=startpos; ln<=MaxShow; i=((i+1)%display.length)) {
      ln+= display[i][14]
	    if (display[i][0] == specialty) { 
  	     bodyhtml += '<tr bgcolor='+display[i][12]+'>\n'
      } else {
	       specialty = display[i][0]
  	     bodyhtml += '<tr bgcolor='+display[i][12]+'>\n'
         bodyhtml += '  <td class=sub rowspan='+display[i][13]+'>&nbsp;'+ch_style+display[i][1]+'</span><br>'
         bodyhtml += en_style+'&nbsp;'+display[i][0]+'</span></td>\n'
      }
     bodyhtml += '  <td class=dr>'+ch_style+'&nbsp;'+display[i][3]+'<br>&nbsp;'+en_style+display[i][2]+'</td>\n'
     bodyhtml += '  <td align=center>&nbsp;'+tm_style+display[i][6]+'</td>\n'
     bodyhtml += '  <td align=center>&nbsp;'+tm_style+display[i][7]+'</td>\n'
     bodyhtml += '  <td align=center>&nbsp;'+tm_style+display[i][8]+'</td>\n'
     bodyhtml += '  <td align=center>&nbsp;'+tm_style+display[i][9]+'</td>\n'
     bodyhtml += '  <td align=center>&nbsp;'+tm_style+display[i][10]+'</td>\n'
     bodyhtml += '  <td align=center>&nbsp;'+tm_style+display[i][11]+'</td>\n'
     bodyhtml += '</tr>\n'
   }
   bodyhtml += '</table><br>\n';
   //bodyhtml += '<p align=right style="font-size:9px;color:blue;">Displaying '+(startpos+1)+'..'+i+' of ' + display.length + '</p>\n';	
   ct = document.getElementById("list")
   ct.innerHTML=bodyhtml;
}  
</script>      


</HEAD>

<body style="overflow:hidden" onload="setInterval( 'scrolltable()', speed )">

<img width=1024 src="../images/headerlogo.png">

<div id="header1" style="position:absolute;width:500px;left:100px;top:8;height=15;">
   <font style="font-size=24px;Font-weight=700;Color:DarkBlue;">
   門 診 診 症 時 間 表</font>
</div>   

<div id="header2" style="position:absolute;width:500px;left:100px;top:35;height=20;">
   <b>Out-patient Clinic Consultation Timetable</b>
</div>

<div style="position:absolute;width:400px;left:600px;top:20;height=20;">
     <font style="font-size=13px;Font-weight=400;Color:DarkBlue;">
        敬請預約, 電話: 3651 8808<br>
        Please make appointments in advance, Telephone: 3651 8808
     </font>   
</div>

<div id="footer" style="position:absolute;width:1000px;left:10px;top:670;height=36;">
<table width=98% align=center cellpadding=0 cellspacing=0 valign=top border=0 bgcolor=lightblue>
  <tr height=6>
     <td width=10></td><td width=550></td><td width=450></td><td width=10></td>
  </tr>
  <tr><td>&nbsp;</td>
  <td align=left>
     &nbsp;門診預約服務時間: 星期一至四上午8:00至下午9:00，星期五及星期日上午8:00至下午6:00<br>
     &nbsp;Out-patient Appointment: Mon to Thur 8:00am to 9:00pm, Fri & Sun 8:00am to 6:00pm
  </td>
   <td align=right>
      &nbsp;星期六及公眾假期休息 。 Closed for Saturdays and Public Holidays<br> 
      &nbsp;設有24 小時急診服務  。 24 hours Urgent Care Services Available
   </td>
   <td></td>
  </tr>
  <tr height=6><td></td><td></td><td></td><td></td></tr>
  <tr>
  <td width=30 align=left>&nbsp;</td>
  <td align=left width=980 colspan=2>
    &nbsp;以上資料只供參考，診症時間如有更改恕不另行通知。<br>
    &nbsp;The above information is for reference only. 
    Consultation hours are subject to change without prior notice.
  </td>
  </tr>
  <tr height=6><td></td><td></td><td></td><td></td></tr>
</table>
</div>

<div id="list" style="position:absolute;width:1000px;left:10px;top:90;">
..
</div>

<!------------------- convert schedule to display format ---------------------->
<script>
 
  document.writeln('<div id="time" style="position:absolute;height:15px;width:200px;');
  document.writeln( 'top:10px;left:900px;font-size:9px;color:#CCCCCC;">' + createstamp + '</div>');
  
  j = 0
  display[0] = new Array( schedule[0][0], schedule[0][1], schedule[0][2], schedule[0][3], schedule[0][4], schedule[0][5], '', '', '', '', '', '', 0, 0, 2 )
  display[0][schedule[0][5]+5] = schedule[0][6] + ' - ' + schedule[0][7]
  
  for (i=1; i<schedule.length; i++) {
    if ( (schedule[i][0] != schedule[i-1][0]) || (schedule[i][2] != schedule[i-1][2] ) ) {
       j++
       display[j] = new Array( schedule[i][0], schedule[i][1], schedule[i][2], schedule[i][3], schedule[i][4], schedule[i][5], '', '', '', '', '', '', 0, 0, 2 )
       display[j][schedule[i][5]+5] = schedule[i][6] + ' - ' + schedule[i][7]
    } else {
       display[j][schedule[i][5]+5] += (display[j][schedule[i][5]+5]>''?'<br>':'') + schedule[i][6] + ' - ' + schedule[i][7]
       //if ( 17*display[j][14] < display[j][schedule[i][5]+5].length ) display[j][14]+=1; 
    }
  };
  
  display[display.length-1][12] = colors[(j=0)]
  display[display.length-1][13] = (k=1)
  for (i=display.length-2; i>=0; i--) {
     display[i][12] = ( display[i][0]==display[i+1][0]? colors[j%4] : colors[(++j)%4] )   // rowscolor
     display[i][13] = ( display[i][0]==display[i+1][0]? (++k) : (k=1) )   // rowspan
     if (display[i][13]<=1 && display[i][0].length>38) display[i][14]++;
     if (display[i][13]<=1 && display[i][1].length>30) display[i][14]++;
  }
  scrolltable()  
    
</script>

</body>
</HTML>
