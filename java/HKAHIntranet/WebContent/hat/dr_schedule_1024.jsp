<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page language="java" %>
<%@ page import="java.util.*" %>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<html>
<meta http-equiv="refresh" content=1200>
<meta http-equiv="Content-Type" content="text/html; charset=big5">
<HEAD>
<TITLE>Adventist Hospital - Doctor Schedule </TITLE>
<!-- (Updated@201303)  -->
<STYLE TYPE="text/css">
body { margin-left:0px; margin-top:0px;	margin-right:0px; margin-bottom:0px;
       font-family:  "Arial", "Verdana", "sans-serif";  font-size: 13x; }
td { font-family:  "Arial", "Verdana", "sans-serif";  font-size: 13px; }
th { font-family:  "Arial", "Verdana", "sans-serif";  font-size: 12px; }
#remarks table td { align: left; valign: top; padding: 0px 5px 10px 5px; }
td.sub { font-family: "Arial", "Verdana",  "sans-serif"; font-weight:700; font-size:12px; color:333333}
td.dr  { font-family: "Arial", "Verdana",  "sans-serif"; font-weight:700; font-size:12px;color:383838}
td.caption { font-family: "Verdana", "Arial"; font-weight:700; font-size:13px; color:#881188;}
div.ucc {
	margin: 15px 0;
	font-family: "Arial", "Verdana",  "sans-serif";  font-size:14px;
}
div.link {
	display: inline;
	font-weight:bold; color:#1a0dab;
}
div.link a {
    text-decoration: none;
    color:#1a0dab;
    border: 3px solid #881188;
    background: 	#fde9f4;
    padding: 5px;
}
div.link a:hover {
    text-decoration: underline;
}
</STYLE>

<%
//======== connect to database ===========
String mode = request.getParameter("m");
String sysdate="", html="", sql="", createstamp;

html += "<script> \n";
html += " //========== Control File of Doctor Schedule ======== \n";
html += " var schedule = new Array(); \n";
html += " var display = new Array(); \n";
html += " var i=0;  \n";
out.println(html);

sql += " select 'schedule[i++] = new Array( ''' || spec_ename || ''',''' || spec_cname || ''',''' ";
sql += "    || docename || ''','''||doccname || ";
sql += ( (mode==null)?  "'''" : "'</span> ('||doccode||')''" );
sql += "    , '''|| doccode || ''',' || opd_day || ',''' || start_time || ''',''' || end_time ||''','''||doctype||''' )' as line  ";
sql += "    , to_char( sysdate, 'dd/mm/yyyy hh24:mi:ss' ) as dt  ";
sql += " from HAT_DRSCHEDULE  ";
sql += " order by 1 ";

ArrayList record = UtilDBWeb.getReportableListCIS(sql);
ReportableListObject row = null;
for (int i = 0; i < record.size(); i++) {
   row = (ReportableListObject) record.get(i);
   out.println( row.getValue(0) );
   sysdate = row.getValue(1);
};

out.println( " var createstamp = '" + sysdate + "';" );
out.println( "</script> ");
%>

<script>
  var ch_style= '<span style="font-size=12px;Font-weight=400;">'
  var en_style= '<span style="font-size=10px;font-family=Arial;Font-weight=400;Color:DarkBlue;">'
  var tm_style= '<span style="font-size=10px;font-family=Arial;Font-weight=400;Color:Black;">'
  var ap_style= '<span style="font-size=12px;font-family=Arial;Font-weight=700;Color:DarkRed;">'
  var sm_style= '<span style="font-size=10px;font-family=Arial;Font-weight=400;Color:DarkRed;">'
  var colors   = new Array( '#FEFEFE', '#C0F0C0', '#D0D0F0', '#F0D0D0' );
  var startpos = -1
  var speed    = 3000;
  var skiprow  = 1;
  var MaxShow  = 22

function scrolltable() {

    specialty = ''
    bodyhtml = '<table border=1 width="100%" cellpadding=0 cellspacing=0 valign=top>\n'
    bodyhtml += '<tr bgcolor=#EEEEEE>'
    bodyhtml += '  <td width=20% class=caption>&nbsp;'+ch_style+'&nbsp;門診服務<br>'+en_style+'&nbsp;&nbsp;&nbsp;&nbsp;Clinic</td>\n'
    bodyhtml += '  <td width=20% class=caption>&nbsp;'+ch_style+'&nbsp;醫生/專業人士<br>'+en_style+'&nbsp;&nbsp;&nbsp;&nbsp;Doctor / Professional</td>\n'
    bodyhtml += '  <td width=10% class=caption align=center>'+ch_style+'&nbsp;星期日<br>'+en_style+'&nbsp;Sunday</td>\n'
    bodyhtml += '  <td width=10% class=caption align=center>'+ch_style+'&nbsp;星期一<br>'+en_style+'&nbsp;Monday</td>\n'
    bodyhtml += '  <td width=10% class=caption align=center>'+ch_style+'&nbsp;星期二<br>'+en_style+'&nbsp;Tuesday</td>\n'
    bodyhtml += '  <td width=10% class=caption align=center>'+ch_style+'&nbsp;星期三<br>'+en_style+'&nbsp;Wednesday</td>\n'
    bodyhtml += '  <td width=10% class=caption align=center>'+ch_style+'&nbsp;星期四<br>'+en_style+'&nbsp;Thursday</td>\n'
    bodyhtml += '  <td width=10% class=caption align=center>'+ch_style+'&nbsp;星期五<br>'+en_style+'&nbsp;Friday</td>\n'
    bodyhtml += '</tr>\n'
    bodyhtml += '<!------------------- Script to show schedule ---------------------->\n'

    for (i=0; i<display.length; i++) {
	    if (display[i][0] == specialty) {
  	     bodyhtml += '<tr bgcolor='+display[i][12]+'>\n'
      } else {
	       specialty = display[i][0]
  	     bodyhtml += '<tr bgcolor='+display[i][12]+'>\n'
         bodyhtml += '  <td class=sub rowspan='+display[i][13]+'>&nbsp;'+ch_style+display[i][1]+'</span><br>'
         bodyhtml += en_style+'&nbsp;'+display[i][0]+'</span></td>\n'
      }

      //if (display[i][4] == '1499') {
      if (display[i][15] == 'I') {
        bodyhtml += '  <td class=dr>'+ch_style+'&nbsp;'+display[i][3]+'<br>&nbsp;'+en_style+display[i][2]
        bodyhtml += '  <br>&nbsp;&nbsp;'+sm_style+'本院醫生<br>&nbsp;&nbsp;Adventist Health Physician</td>\n'
      } else {
        bodyhtml += '  <td class=dr>'+ch_style+'&nbsp;'+display[i][3]+'<br>&nbsp;'+en_style+display[i][2]+'</td>\n'
      }

     if (display[i][6] == "By Appointment") {
       bodyhtml += '  <td align=center colspan=6>&nbsp;'+ap_style+display[i][6]+'</td>\n';
     } else {
       bodyhtml += '  <td align=center>&nbsp;'+tm_style+display[i][6]+'</td>\n'
       bodyhtml += '  <td align=center>&nbsp;'+tm_style+display[i][7]+'</td>\n'
       bodyhtml += '  <td align=center>&nbsp;'+tm_style+display[i][8]+'</td>\n'
       bodyhtml += '  <td align=center>&nbsp;'+tm_style+display[i][9]+'</td>\n'
       bodyhtml += '  <td align=center>&nbsp;'+tm_style+display[i][10]+'</td>\n'
       bodyhtml += '  <td align=center>&nbsp;'+tm_style+display[i][11]+'</td>\n'
     }
     bodyhtml += '</tr>\n'
   }
   bodyhtml += '</table><br>\n';
   ct = document.getElementById("list")
   ct.innerHTML=bodyhtml;
}
</script>

</HEAD>

<body>

<img width=980 src="../images/headerlogo.png">

<div id="header1" style="position:absolute;width:500px;left:10px;top:293px;height=15px;">
   <font style="font-size=24px;Font-weight=700;Color:DarkBlue;">
   門 診 診 症 時 間 表</font>
</div>   

<div id="header2" style="position:absolute;width:500px;left:10px;top:270px;height=20px;">
   <b>Out-patient Clinic Consultation Timetable</b>
</div>

<!----------------- added remarks by ck on 20120727 -------------------->
<div id="remarks" style="position:absolute;width:980px;left:10px;top:85px;">
<table width="99%" cellpadding=0 cellspacing=0 valign=top border=0 bgcolor=lightblue>
  <tr height=6>
     <td width="40%"></td><td width="60%"></td>
  </tr>
  <tr>
  	<td>
請致電 <b>2275 6888</b> 查詢及預約，以確定您的應診時間。
	</td>
  <td>
Please call <b>2275 6888</b> for an enquiry or appointment.
   </td>
  </tr>
  <tr>
  	<td>
(預約牙科或口腔頜面外科請致電 <b>2276 7111</b>)
  	</td>
  	<td>
(For Dental or Oral & Maxillofacial Surgery appointment please call <b>22767111</b>)
  	</td>  	
  </tr>
  <tr>
  	<td>
本院提供 24小時急診服務, 星期六 (安息日) 及醫院假期休息
  	</td>
  	<td>
24-hour Urgent Care Service is available, Closed on Saturdays (Sabbath) and Hospital holidays
  	</td>  	
  </tr>
  <tr>
  	<td>
以下資料僅作參考之用，院方可能會作出更改。
  	</td>
  	<td>
The below information is for your reference only, it may be changed without notice.
  	</td>  	
  </tr>
  <tr height=10><td></td><td></td>
</table>
<div class="ucc">
  		請按此閱讀最新時間表 Please click here for the most update time table
	  	<div class="link">
			<a href="https://www.twah.org.hk/getfile/index/action/images/name/UCC_schedule.pdf">Urgent Care Center Consultation Timetable 急診中心診症時間表</a>
		</div>
</div>
</div>
<!------------------- end. 20120727 ---------------------->

<div id="list" style="position:absolute;width:980px;left:10px;top:317px;">
</div>

<!------------------- convert schedule to display format ---------------------->
<script>

  document.writeln('<div id="time" style="position:absolute;height:15px;width:200px;');
  document.writeln( 'top:277px;left:600px;font-size:9px;color:#CCCCCC;">Printed Version<br>' + createstamp + '</div>');

  j = 0;
  i = 0;
  display[0] = new Array( schedule[0][0], schedule[0][1], schedule[0][2], schedule[0][3], schedule[0][4], schedule[0][5], '', '', '', '', '', '', 0, 0, 2, schedule[0][8]  )
  if (schedule[i][5]>0) {
     display[j][schedule[i][5]+5] = schedule[i][6] + ' - ' + schedule[i][7];
  } else {
     display[j][6] = "By Appointment";
  };  

  for (i=1; i<schedule.length; i++) {
    if ( (schedule[i][0] != schedule[i-1][0]) || (schedule[i][2] != schedule[i-1][2] ) ) {
       j++
       display[j] = new Array( schedule[i][0], schedule[i][1], schedule[i][2], schedule[i][3], schedule[i][4], schedule[i][5], '', '', '', '', '', '', 0, 0, 2, schedule[i][8]  )
       if (schedule[i][5]>0) {
         display[j][schedule[i][5]+5] = schedule[i][6] + ' - ' + schedule[i][7];
       } else {
         display[j][6] = "By Appointment";
       };
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
  }
  scrolltable()

</script>

</body>
</HTML>
