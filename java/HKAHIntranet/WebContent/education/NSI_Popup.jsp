<%@ page import="java.util.*" %>
<%@ page import="com.hkah.web.common.*" %>
<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%
String module = request.getParameter("module");
String subModule = request.getParameter("subModule");
String locationPath = request.getParameter("locationPath");

String resol = "vga";
if ("pem.relMtrl".equals(subModule)) {
	resol = "hvga";
}
%>
<%if("education".equals(module)){ %>
    <img src="../images/Bulb_man.gif" width="80" height="80"><font style="font-weight: bolder;color:red;font-size: large;">NSI Prevention</font>
<%}%>
	<table width="100%" border="0">
		<tr class="smallText">
			<td align="left">
				<br>
				<div id="player">

				 <%if("education".equals(module)){ %>
					<object type="application/x-shockwave-flash" data="../swf/flvplayer.swf?file=/swf/video/NSI_ep2_v2.flv" width="640" height="480">
						<param name="movie" value="../swf/flvplayer.swf?file=/swf/video/NSI_ep2_v2.flv" />
					</object>
				<%}else if("marketing".equals(module)){ %>
					<object type="application/x-shockwave-flash" data="../swf/flvplayer.swf?file=/swf/video/HKAH_Ver 1_Dr.AdamLeung.flv" width="640" height="480">
						<param name="movie" value="../swf/flvplayer.swf?file=/swf/video/HKAH_Ver 1_Dr.AdamLeung.flv" />
					</object>				
				<%}else if("PEM".equals(module)){ %>
					<object type="application/x-shockwave-flash" data="../swf/flvplayer.swf?file=/swf/video/1. Opening Remarks by Dr Frank Yeung.flv" width="<%="hvga".equals(resol) ? "480" : "640" %>" height="<%="hvga".equals(resol) ? "320" : "480" %>">
						<param name="movie" value="../swf/flvplayer.swf?file=/swf/video/1.Opening Remarks by Dr Frank Yeung.flv" />
					</object>				
				<%}else if("IC".equals(module)){ %>
					<object type="application/x-shockwave-flash" data="../swf/flvplayer.swf?file=/swf/ic/hand rubbing.flv" width="640" height="480">
						<param name="movie" value="../swf/flvplayer.swf?file=/swf/ic/hand rubbing.flv" />
					</object>
				<%}else if("GOWN".equals(module)){ %>
					<object type="application/x-shockwave-flash" data="../swf/flvplayer.swf?file=/swf/video/AVSEQ01.flv" width="640" height="480">
						<param name="movie" value="../swf/flvplayer.swf?file=/swf/video/AVSEQ01.flv" />
					</object>					
				<%}else if("twah_cme".equals(module)){ %>
					<object type="application/x-shockwave-flash" data="../swf/flvplayer.swf?file=/swf/CME/20120727/SANY0003.flv" width="640" height="480">
						<param name="movie" value="../swf/flvplayer.swf?file=/swf/CME/20120727/SANY0003.flv" />
					</object>						
 				<%} else if("twah_cme".equals(module)){ %>
					<object type="application/x-shockwave-flash" data="../swf/flvplayer.swf?file=/swf/CME/20120727/SANY0003.flv" width="640" height="480">
						<param name="movie" value="../swf/flvplayer.swf?file=/swf/CME/20120727/SANY0003.flv" />
					</object>						
				 <%}else if("MCS".equals(module)){ %>
					<object type="application/x-shockwave-flash" data="../swf/flvplayer.swf?file=/swf/MCS/Warning Messages.flv" width="640" height="480">
						<param name="movie" value="../swf/flvplayer.swf?file=/swf/MCS/Warning Messages.flv" />
					</object>						
				 <%}else if("ICN95".equals(module)){ %>
					<object type="application/x-shockwave-flash" data="../swf/flvplayer.swf?file=/swf/video/N95AVSEQ01.flv" width="640" height="480">
						<param name="movie" value="../swf/flvplayer.swf?file=/swf/video/N95AVSEQ01.flv" />
					</object>						
				 <%}else if("HH2016".equals(module)){ %>
					<object type="application/x-shockwave-flash" data="../swf/flvplayer.swf?file=/swf/HH2016.flv" width="1152" height="648">
						<param name="movie" value="../swf/flvplayer.swf?file=/swf/HH2016.flv" />
					</object>						
				 <%}else if("dischargeSummary".equals(module)){ %>
					<object type="application/x-shockwave-flash" data="../swf/flvplayer.swf?file=/swf/video/Discharge Summary.flv" width="640" height="480">
						<param name="movie" value="../swf/flvplayer.swf?file=/swf/video/Discharge Summary.flv" />
					</object>					
				 <%} else if ("other".equals(module) && !"".equals(locationPath) ){ %>
					<object type="application/x-shockwave-flash" data="../swf/flvplayer.swf?file=<%=locationPath %>" width="640" height="480">
						<param name="movie" value="../swf/flvplayer.swf?file=<%=locationPath %>" />
					</object>				 
				 <%} %>
				</div>
				<%if(!"twah_cme".equals(module)){ %>
				<div id="nsi_video_title"></div>
				<%} %>	
			</td>
		</tr>
	</table>
	<div>
	<ul>
	   <%if("education".equals(module)){ %>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/NSI_ep2_v2.flv');">NSI Prevention - Episode 2 (Washing Equipment)</a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/NSI Prevention - Episode 1 (IV Cannulation).flv');">NSI Prevention - Episode 1 (IV Cannulation)</a></li>
		<%}else if("marketing".equals(module)){ %>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/HKAH_Ver 2_Dr.PeterKing.flv');">Dr. Peter King</a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/HKAH_Ver 3_Dr.PatrickKo.flv');">Dr. Patrick Ko</a></li>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/HKAH_Ver 1_Dr.AdamLeung.flv');">Dr. Adam Leung</a></li>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/HKAH_Ver 5_Dr.ChrisWong.flv');">Dr. Chris Wong</a></li>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/HKAH_Ver 4_Dr.BoronCheng.flv');">Dr. Boron Cheng</a></li>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/HKAH_Ver 7_Dr.RyanKo.flv');">Dr. Ryan Ko</a></li>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/HKAH_Ver 6_Dr.JeffreyFung.flv');">Dr. Jeffrey Fung</a></li>
		<%}else if("GOWN".equals(module)){ %>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/AVSEQ01.flv');">Procedure in English version</a></li>
  		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/AVSEQ02.flv');">Procedure in Chinese version</a></li>
		<%}else if("ICN95".equals(module)){ %>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/N95AVSEQ01.flv');">N95 Fit Test Procedure</a></li>
	</ul>				
		<%}else if("PEM".equals(module)){ %>
		<% int i = 1; %>
		<% if (!"pem.relMtrlSharing".equals(subModule)) { %>
		<div  id="pem_sharingVideo" style="visibility:hidden">
		<ul>		
		<li>Sharing Videos<ul>
		<li><a href="javascript:void(0);" disableonclick="playMovie('/swf/video/ArtOfPossibility.flv', '<%=resol %>');"><H1 id="TS">ArtOfPossibility</H1></a></li>			
		<li><a href="javascript:void(0);" disableonclick="playMovie('/swf/video/Boot_Camp.flv', '<%=resol %>');"><H1 id="TS">Boot_Camp</H1></a></li>
		<li><a href="javascript:void(0);" disableonclick="playMovie('/swf/video/DAVID_HQ_16x9.flv', '<%=resol %>');"><H1 id="TS">DAVID_HQ_16x9</H1></a></li>
		<li><a href="javascript:void(0);" disableonclick="playMovie('/swf/video/In-Laws_HQ_4x3.flv', '<%=resol %>');"><H1 id="TS">In-Laws_HQ_4x3</H1></a></li>
		<li><a href="javascript:void(0);" disableonclick="playMovie('/swf/video/MrsBarnes.flv', '<%=resol %>');"><H1 id="TS">MrsBarnes</H1></a></li>			
		<li><a href="javascript:void(0);" disableonclick="playMovie('/swf/video/OFFICER_GENT_HQ_4x3.flv', '<%=resol %>');"><H1 id="TS">OFFICER_GENT_HQ_4x3</H1></a></li>			
		<li><a href="javascript:void(0);" disableonclick="playMovie('/swf/video/Pickle2010.flv', '<%=resol %>');"><H1 id="TS">Pickle2010</H1></a></li>
		<li><a href="javascript:void(0);" disableonclick="playMovie('/swf/video/SHARE_A_HQ_16x9.flv', '<%=resol %>');"><H1 id="TS">SHARE_A_HQ_16x9</H1></a></li>
		<li><a href="javascript:void(0);" disableonclick="playMovie('/swf/video/SHARE_E_HQ_16x9.flv', '<%=resol %>');"><H1 id="TS">SHARE_E_HQ_16x9</H1></a></li>
		<li><a href="javascript:void(0);" disableonclick="playMovie('/swf/video/SHARE_H_HQ_16x9.flv', '<%=resol %>');"><H1 id="TS">SHARE_H_HQ_16x9</H1></a></li>
		<li><a href="javascript:void(0);" disableonclick="playMovie('/swf/video/SHARE_R_HQ_16x9.flv', '<%=resol %>');"><H1 id="TS">SHARE_R_HQ_16x9</H1></a></li>
		<li><a href="javascript:void(0);" disableonclick="playMovie('/swf/video/SHARE_S_HQ_16x9.flv', '<%=resol %>');"><H1 id="TS">SHARE_S_HQ_16x9</H1></a></li>
		<li><a href="javascript:void(0);" disableonclick="playMovie('/swf/video/SOUTHWEST_NO_BULL.flv', '<%=resol %>');"><H1 id="TS">SOUTHWEST_NO_BULL</H1></a></li>
		<li><a href="javascript:void(0);" disableonclick="playMovie('/swf/video/TurningPoint_HQ_16x9.flv', '<%=resol %>');"><H1 id="TS">TurningPoint_HQ_16x9</H1></a></li>
		<li><a href="javascript:void(0);" disableonclick="playMovie('/swf/video/Whats_Your_Pickle.flv', '<%=resol %>');"><H1 id="TS">Whats_Your_Pickle</H1></a></li>
		</ul></li>			
		</ul>
		</div>	
		<%} %>
		<% if (!"pem.relMtrlTraining".equals(subModule)) { %>
		<div  id="pem_trainingVideo" style="visibility:hidden">
		<ul>		
		<li>PEM Training Videos (Mar 21,2013)<ul>
		<li><a href="javascript:void(0);" disableonclick="playMovie('/swf/video/Studor_HML Conversation middle.flv', '<%=resol %>');"><H1 id="TS">Studor_HML Conversation middle</H1></a></li>			
		<li><a href="javascript:void(0);" disableonclick="playMovie('/swf/video/Studor_HML conversation vignette LOW confrontation only.flv', '<%=resol %>');"><H1 id="TS">Studor_HML conversation vignette LOW confrontation only</H1></a></li>
		<li><a href="javascript:void(0);" disableonclick="playMovie('/swf/video/Studor_HML converstion vignette low.flv', '<%=resol %>');"><H1 id="TS">Studor_HML converstion vignette low</H1></a></li>
		<li><a href="javascript:void(0);" disableonclick="playMovie('/swf/video/Studor_HML convesation vignettes HIGH.flv', '<%=resol %>');"><H1 id="TS">Studor_HML convesation vignettes HIGH</H1></a></li>
		</ul></li>			
		</ul>
		</div>					
		<% } %>
		<% if (!"pem.relMtrlMay".equals(subModule)) { %>
		<div  id="pem_mayVideo" style="visibility:hidden">
		<ul>		
		<li>PEM 2nd Training Videos (May 2012)<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/1.Opening Remarks by Dr Frank Yeung.flv', '<%=resol %>');"><H1 id="TS">1.Opening Remarks by Dr Frank Yeung</H1></a></li>			
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/3.Review PEM Model – where we are going and why we are having PEM by Mack Rucker.flv', '<%=resol %>');"><H1 id="TS">2.Review PEM Model – where we are going and why we are having PEM by Mack Rucker</H1></a></li>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/4.Leader Rounding for Internal Customer by Kathy Perno.flv', '<%=resol %>');"><H1 id="TS">3.Leader Rounding for Internal Customer by Kathy Perno</H1></a></li>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/5.Thank you Note by Rachel Yeung.flv', '<%=resol %>');"><H1 id="TS">4.Thank you Note by Rachel Yeung</H1></a></li>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/7.The Linkage Grid Kathy Perno.flv', '<%=resol %>');"><H1 id="TS">5.The Linkage Grid Kathy Perno</H1></a></li>			
		</ul></li>			
		</ul>
		</div>	
		<%} %>
		<% if (!"pem.relMtrlFeb".equals(subModule)) { %>
		<div  id="pem_febVideo" style="visibility:hidden">
		<ul>		
		<li>PEM 1st Training Videos (Feb 2012)<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/LeaderRoundingPart1.flv', '<%=resol %>');"><H1 id="TS">Leader Rounding Part 1</H1></a></li>			
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/LeaderRoundingPart2.flv', '<%=resol %>');"><H1 id="TS">Leader Rounding Part 2</H1></a></li>			
		</ul></li>			
		</ul>
		</div>	
		<%} %>
		<% if(!"pem.relMtrlApr".equals(subModule)){ %>
		<div  id="pem_octVideo" style="visibility:hidden">
		<ul>
		<li>PEM 5th Training Videos (May 2015)
			<ul>
				<li>Day 1
					<ul>
				<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00300.flv', '<%=resol %>', null, 'Opening Remark by Dr. Frank Yeung');">
				<H1 id="TS">Opening Remark by Dr. Frank Yeung</H1></a></li>
				
				<li>AHS PEM Undpate / Best Practice (by Mack Rucker)
					<ul>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00394.flv', '<%=resol %>', null, 'AHS PEM Undpate / Best Practice (by Mack Rucker) - Clip 1');">
						<H1 id="TS">Clip 1</H1></a></li>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00395.flv', '<%=resol %>', null, 'AHS PEM Undpate / Best Practice (by Mack Rucker) - Clip 2');">
						<H1 id="TS">Clip 2</H1></a></li>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00403.flv', '<%=resol %>', null, 'AHS PEM Undpate / Best Practice (by Mack Rucker) - Clip 3');">
						<H1 id="TS">Clip 3</H1></a></li>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00408.flv', '<%=resol %>', null, 'AHS PEM Undpate / Best Practice (by Mack Rucker) - Clip 4');">
						<H1 id="TS">Clip 4</H1></a></li>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00410.flv', '<%=resol %>', null, 'AHS PEM Undpate / Best Practice (by Mack Rucker) - Clip 5');">
						<H1 id="TS">Clip 5</H1></a></li>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00414_-0230.flv', '<%=resol %>', null, 'AHS PEM Undpate / Best Practice (by Mack Rucker) - Clip 6');">
						<H1 id="TS">Clip 6</H1></a></li>														
					</ul>
				</li>

				<li>Leadership Training – Building Trust (by Mack Rucker)
					<ul>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00508.flv', '<%=resol %>', null, 'Leadership Training – Building Trust (by Mack Rucker) - Clip 1');">
						<H1 id="TS">Clip 1</H1></a></li>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00518.flv', '<%=resol %>', null, 'Leadership Training – Building Trust (by Mack Rucker) - Clip 2');">
						<H1 id="TS">Clip 2</H1></a></li>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00520.flv', '<%=resol %>', null, 'Leadership Training – Building Trust (by Mack Rucker) - Clip 3');">
						<H1 id="TS">Clip 3</H1></a></li>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00539.flv', '<%=resol %>', null, 'Leadership Training – Building Trust (by Mack Rucker) - Clip 4');">
						<H1 id="TS">Clip 4</H1></a></li>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00541.flv', '<%=resol %>', null, 'Leadership Training – Building Trust (by Mack Rucker) - Clip 5');">
						<H1 id="TS">Clip 5</H1></a></li>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00543.flv', '<%=resol %>', null, 'Leadership Training – Building Trust (by Mack Rucker) - Clip 6');">
						<H1 id="TS">Clip 6</H1></a></li>														
					</ul>
				</li>
				
				
				<li>Creating a Creation Health Culture by Ms. Mandy Persaud
					<ul>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00544.flv', '<%=resol %>', null, 'Creating a Creation Health Culture by Ms. Mandy Persaud - Clip 1');">
						<H1 id="TS">Clip 1</H1></a></li>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00554.flv', '<%=resol %>', null, 'Creating a Creation Health Culture by Ms. Mandy Persaud - Clip 2');">
						<H1 id="TS">Clip 2</H1></a></li>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00556.flv', '<%=resol %>', null, 'Creating a Creation Health Culture by Ms. Mandy Persaud - Clip 3');">
						<H1 id="TS">Clip 3</H1></a></li>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00558.flv', '<%=resol %>', null, 'Creating a Creation Health Culture by Ms. Mandy Persaud - Clip 4');">
						<H1 id="TS">Clip 4</H1></a></li>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00567.flv', '<%=resol %>', null, 'Creating a Creation Health Culture by Ms. Mandy Persaud - Clip 5');">
						<H1 id="TS">Clip 5</H1></a></li>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00569.flv', '<%=resol %>', null, 'Creating a Creation Health Culture by Ms. Mandy Persaud - Clip 6');">
						<H1 id="TS">Clip 6</H1></a></li>		
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00574.flv', '<%=resol %>', null, 'Creating a Creation Health Culture by Ms. Mandy Persaud - Clip 7');">
						<H1 id="TS">Clip 7</H1></a></li>		
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00575.flv', '<%=resol %>', null, 'Creating a Creation Health Culture by Ms. Mandy Persaud - Clip 8');">
						<H1 id="TS">Clip 8</H1></a></li>		
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00576.flv', '<%=resol %>', null, 'Creating a Creation Health Culture by Ms. Mandy Persaud - Clip 9');">
						<H1 id="TS">Clip 9</H1></a></li>												
					</ul>
				</li>
					</ul>
				</li>
				<li>Day 2
					<ul>

				<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00592_-1054.flv', '<%=resol %>', null, 'Spiritual Ambassador  (by James Wu)');">
				<H1 id="TS">Spiritual Ambassador  (by James Wu)</H1></a></li>
				<li>Spiritual Ambassador (by Mack Rucker)
					<ul>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00592_1513-.flv', '<%=resol %>', null, 'Spiritual Ambassador (by Mack Rucker) - Clip 1');">
						<H1 id="TS">Clip 1</H1></a></li>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00681.flv', '<%=resol %>', null, 'Spiritual Ambassador (by Mack Rucker) - Clip 2');">
						<H1 id="TS">Clip 2</H1></a></li>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00682_-0340.flv', '<%=resol %>', null, 'Spiritual Ambassador (by Mack Rucker) - Clip 3');">
						<H1 id="TS">Clip 3</H1></a></li>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/fbc_getservice.flv', '<%=resol %>');">
						<H1 id="TS">fbc_getservice</H1></a></li>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/JOHN_DEAN_HQ_16x9.flv', '<%=resol %>');">
						<H1 id="TS">JOHN_DEAN_HQ_16x9</H1></a></li>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/potter_count_down.flv', '<%=resol %>');">
						<H1 id="TS">potter count down</H1></a></li>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/SpiritualAmbassadors_HQ_16x9.flv', '<%=resol %>');">
						<H1 id="TS">SpiritualAmbassadors_HQ_16x9</H1></a></li>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/sv_trust.flv', '<%=resol %>');">
						<H1 id="TS">sv_trust</H1></a></li>
						<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/tvp_listen_alone.flv', '<%=resol %>');">
						<H1 id="TS">tvp_listen_alone</H1></a></li>														
					</ul>
				</li>			
				<li><a href="javascript:void(0);" onclick="playMovie('/swf/pem/5/MAH00778.flv', '<%=resol %>', null, 'Mission Retreat 2014 Review and 2015 Review (James Wu)');">
				<H1 id="TS">Mission Retreat 2014 Review and 2015 Review (James Wu)</H1></a></li>
					</ul>
				</li>			
			</ul>
		</li>
		<li>PEM 4th Training Videos (Apr 2014)<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/openingRemarks201404.flv', '<%=resol %>');">
		<H1 id="TS">1.Opening Remark by Dr. Frank Yeung</H1></a></li>			
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/whereDoWeGoFromHere.flv', '<%=resol %>');">
		<H1 id="TS">2.Whrere Do we Go From Here </H1></a></li>			
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/missionAssessment.flv', '<%=resol %>');">
		<H1 id="TS">3.Culture of Mission Assessment by Mr. Mack Rucker</H1></a></li>
		<li><a href="javascript:void(0);" onclick="">
		<H1 id="TS">4.Restful Work by Mr. Mack Rucker</H1></a></li>		
		<!-- 
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/serviceRecoveryTW.flv', '<%=resol %>');">
		<H1 id="TS">5.Report from Service Recovery by Mr Patrick Yu</H1></a></li>		
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/RRTW.flv', '<%=resol %>');">
		<H1 id="TS">6.Report from Reward & Recognition Team by Ms Florence Ng</H1></a></li>		
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/ReportfromComTeamTW.flv', '<%=resol %>');">
		<H1 id="TS">7.Report from Communication Team by Mr. Gary Ching</H1></a></li>
		-->
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/historyOf7DayAdv.flv', '<%=resol %>');">
		<H1 id="TS">5.History of Seventh-day Adventist Healthcare
			<br>     and CREATION Health for Leader, Part 1 
			<br>     by Mr. Mack Rucker and Ms Aubrey Varraux</H1></a></li>				
		</ul></li>			
		</ul>
		</div>
		<%} %>
		<% if (!"pem.relMtrlOct".equals(subModule)) { %>
		<div  id="pem_octVideo" style="visibility:hidden">
		<ul>		
		<li>PEM 3rd Training Videos (Oct 2012)<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/1.OpeningRemarksbyDrFrankYeung.flv', '<%=resol %>');"><H1 id="TS">1. Opening Remarks by Dr Frank Yeung</H1></a></li>			
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/2.AIDETbyMrMackRucker.flv', '<%=resol %>');"><H1 id="TS">2. AIDET by Mr Mack Rucker</H1></a></li>			
		</ul></li>			
		</ul>
		</div>	
		<%} %>
		<% if (!"pem.relMtrlMayAIDET".equals(subModule)) { %>
		<div  id="pem_mayAIDETVideo" style="visibility:hidden">
		<ul>		
		<li>PEM 2nd Training Videos (May 2012) - AIDET videos<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/AIDET for Physicians 7.flv', '<%=resol %>');"><H1 id="TS">AIDET for Physicians 7</H1></a></li>			
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/AIDET individual session.flv', '<%=resol %>');"><H1 id="TS">AIDET individual session</H1></a></li>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/video/AIDET-TakeII.flv', '<%=resol %>');"><H1 id="TS">AIDET-TakeII</H1></a></li>
		</ul></li>			
		</ul>
		</div>	
		<%} %>
		<% if (!"pem.relMtrl".equals(subModule)) { %><ul><li><a href="javascript:void(0);" onclick="playMovie('/swf/video/8.Ask the Basket SessionWrap up – Final words from CEO by Dr Frank Yeung.flv', '<%=resol %>');"><%=i++ %>.Ask the Basket Session & Wrap up – Final words from CEO by Dr Frank Yeung</a></li><ul><% } %>		
		<%}else if("IC".equals(module)){ %>
		<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/ic/hand rubbing.flv');">Hand Rubbing</a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/ic/hand washing.flv');">Hand Washing</a></li>
		</ul>
		<%}else if("twah_cme".equals(module)){ %>
		<div setImagePath="../images/dhtmlxTree/" class="dhtmlxTree">
		<ul>
		<li>CME Dr Lee Wai Yin – Jun 24, 2021<ul>
		<li><a href="javascript:void(0);" onclick="playMP4('/20210624/video.mp4');"><H1 id="TS">Play</H1></a></li>
		</ul></li>
		<li>CME Dr Stephen Lau – May 27, 2021<ul>
		<li><a href="javascript:void(0);" onclick="playMP4('/20210527/zoom_0.mp4');"><H1 id="TS">Play</H1></a></li>
		</ul></li>
		<li>CME Dr Edgar Lau – Apr 22, 2021<ul>
		<li><a href="javascript:void(0);" onclick="playMP4('/20210422/zoom_0.mp4');"><H1 id="TS">Play</H1></a></li>
		</ul></li>
		<li>CME Dr Derek Wong – Mar 25, 2021<ul>
		<li><a href="javascript:void(0);" onclick="playMP4('/20210325/zoom_0.mp4');"><H1 id="TS">Play</H1></a></li>
		</ul></li>
		<li>CME Dr Clarence Liu – Nov 19, 2020<ul>
		<li><a href="javascript:void(0);" onclick="playMP4('/20201119/video.mp4');"><H1 id="TS">Play</H1></a></li>
		</ul></li>
		<li>CME Dr Joseph Hui and Dr Yeung Yuk Pang – Sept 24, 2020<ul>
		<li><a href="javascript:void(0);" onclick="playMP4('/20200927/video.mp4');"><H1 id="TS">Play</H1></a></li>
		</ul></li>		
		<li>CME Dr Ho Kwok Tung – Dec 12, 2019<ul>
		<li><a href="javascript:void(0);" onclick="playMP4('/20191212/MAH01136.mp4');"><H1 id="TS">Part 1</H1></a></li>
		<li><a href="javascript:void(0);" onclick="playMP4('/20191212/MAH01137.mp4');"><H1 id="TS">Part 2</H1></a></li>		
		</ul></li>
		<li>CME Dr Sze Wing Kin and Dr Tony Ho – Nov 28, 2019<ul>
		<li><a href="javascript:void(0);" onclick="playMP4('/20191128/MAH01133a.mp4');"><H1 id="TS">Part 1</H1></a></li>
		<li><a href="javascript:void(0);" onclick="playMP4('/20191128/MAH01133b.mp4');"><H1 id="TS">Part 2</H1></a></li>		
		</ul></li>
		<li>CME Dr Sha Wai Leung – Sept 24, 2019<ul>
		<li><a href="javascript:void(0);" onclick="playMP4('/20190924/MAH01128.mp4');"><H1 id="TS">Play</H1></a></li>		
		</ul></li>
		<li>CME Dr Lau Kwok Kwong / Dr Wong Chi Keung – Jul 25, 2019<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20190725/MAH01126.flv','vga');"><H1 id="TS">Part 1</H1></a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20190725	/MAH01127.flv','vga');"><H1 id="TS">Part 2</H1></a></li>	
		</ul></li>
		<li>CME Dr David Lam / Dr Liu Tak Chiu – May 21, 2019<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20190521/MAH01124.flv','vga');"><H1 id="TS">Part 1</H1></a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20190521	/MAH01125.flv','vga');"><H1 id="TS">Part 2</H1></a></li>	
		</ul></li>
		<li>CME Dr Teoh Ming Keng – Apr 29, 2019<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20190429/MAH01123.flv','vga');"><H1 id="TS">Play</H1></a></li>	
		</ul></li>
		<li>CME Dr Yim Kin Ming – Mar 21, 2019<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20190321/MAH01114.flv','vga');"><H1 id="TS">Part 1</H1></a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20190321	/MAH01122.flv','vga');"><H1 id="TS">Part 2</H1></a></li>		
		</ul></li>
		<li>CME Dr Joyce Ng and Dr Sze Wing Kin – Feb 21, 2019<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20190221/MAH01112.flv','vga');"><H1 id="TS">Part 1</H1></a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20190221/MAH01113.flv','vga');"><H1 id="TS">Part 2</H1></a></li>		
		</ul></li>
		<li>CME Dr Lau Kai Kee – Nov 30, 2018<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20181130/MAH01110.flv','vga');"><H1 id="TS">Part 1</H1></a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20181130/MAH01111.flv','vga');"><H1 id="TS">Part 2</H1></a></li>		
		</ul></li>
		<li>CME Dr Winnie Tse – Sept 28, 2018<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20180928/00000.flv','vga');"><H1 id="TS">Part 1</H1></a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20180928/00002.flv','vga');"><H1 id="TS">Part 2</H1></a></li>		
		</ul></li>
		<li>CME Dr Lau Kwok Kwong – Jul 27, 2018<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20180727/MAH01107.flv','vga');"><H1 id="TS">Part 1</H1></a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20180727/MAH01108.flv','vga');"><H1 id="TS">Part 2</H1></a></li>		
		</ul></li>
		<li>CME Dr Ho San Ni and Dr Sin Sai Yuen – May 25, 2018<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20180525/MAH01102.flv','vga');"><H1 id="TS">Part 1</H1></a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20180525/MAH01106.flv','vga');"><H1 id="TS">Part 2</H1></a></li>		
		</ul></li>
		<li>CME Dr Stephen Chan and dr Dorothy Liu – Jan 26, 2018<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20180126/MAH01098.flv','vga');"><H1 id="TS">Video</H1></a></li>	
		</ul></li>
		<li>CME Dr Chan Wai Ling – Jan 12, 2018<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20180112/MAH01097.flv','vga');"><H1 id="TS">Video</H1></a></li>	
		</ul></li>
		<li>CME Dr Ben Chui and Dr Wales Chan – Nov 24, 2017<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20171124/MAH01093.flv','vga');"><H1 id="TS">Part 1</H1></a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20171124/MAH01094.flv','vga');"><H1 id="TS">Part 2</H1></a></li>		
		</ul></li>
		<li>CME Dr Edmond Wong / 李遜教授 – Sept 29, 2017<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20170929/MAH01081.flv','vga');"><H1 id="TS">Part 1</H1></a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20170929/MAH01082.flv','vga');"><H1 id="TS">Part 2</H1></a></li>		
		</ul></li>
		<li>CME Dr Chan Lung Wai – Sept 7, 2017<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20170907/MAH01076.flv','vga');"><H1 id="TS">Part 1</H1></a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20170907/MAH01077.flv','vga');"><H1 id="TS">Part 2</H1></a></li>		
		</ul></li>
		<li>CME Dr Leung Siu Lan / Dr Au Siu Kie – Jul 28, 2017<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20170728/MAH01073.flv','vga');"><H1 id="TS">Part 1</H1></a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20170728/MAH01074.flv','vga');"><H1 id="TS">Part 2</H1></a></li>		
		</ul></li>
		<li>CME Dr Vincent Hui – Jun 30, 2017<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20170630/MAH01058.flv','vga');"><H1 id="TS">Part 1</H1></a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20170630/MAH01059.flv','vga');"><H1 id="TS">Part 2</H1></a></li>		
		</ul></li>
		<li>CME Dr Ben Chui / Dr Au Siu Kie – Mar 31, 2017<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20170331/MAH01056.flv','vga');"><H1 id="TS">Part 1</H1></a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20170331/MAH01057.flv','vga');"><H1 id="TS">Part 2</H1></a></li>		
		</ul></li>
		<li>CME Dr Au Siu Kie / Prof Tony Mok / Prof Allen Chan – Jan 9, 2017<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20170109/MAH01039.flv','vga');"><H1 id="TS">Part 1</H1></a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20170109/MAH01040.flv','vga');"><H1 id="TS">Part 2</H1></a></li>		
		</ul></li>
		<li>CME Dr Danny Siu – Nov 25, 2016<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20161125/MAH01038.flv','vga');"><H1 id="TS">Video</H1></a></li>	
		</ul></li>
		<li>CME Dr Yeung Yeung and Dr Daniel Wu – Jun 24, 2016<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20160624/MAH01022.flv','vga');"><H1 id="TS">Part 1</H1></a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20160624/MAH01036.flv','vga');"><H1 id="TS">Part 2</H1></a></li>		
		</ul></li>
		<li>CME Dr Jeffrey Fung – Apr 29, 2016<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20160429/MAH00927.flv','vga');"><H1 id="TS">Part 1</H1></a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20160429/MAH00996.flv','vga');"><H1 id="TS">Part 2</H1></a></li>		
		</ul></li>
		<li>CME Dr Tam Cheuk Kwan – Feb 26, 2016<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20160226/MAH00925.flv','vga');"><H1 id="TS">Part 1</H1></a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20160226/MAH00926.flv','vga');"><H1 id="TS">Part 2</H1></a></li>		
		</ul></li>
		<li>CME Dr Manuel Que – Aug 14, 2015<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20150814/MAH00908.flv','vga');"><H1 id="TS">Video</H1></a></li>	
		</ul></li>
		<li>CME Dr Anthony Ng – Jun 12, 2015<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20150612/MAH00906.flv','vga');"><H1 id="TS">Video</H1></a></li>	
		</ul></li>
		<li>CME  Dr Louis Lee – Mar 27, 2015<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20150327/MAH00298.flv','vga');"><H1 id="TS">Part 1</H1></a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20150327/MAH00299.flv','vga');"><H1 id="TS">Part 2</H1></a></li>		
		</ul></li>
		<li>CME Dr Renny Yien – Dec 12, 2014<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20141212/MAH00296.flv','vga');"><H1 id="TS">Part 1</H1></a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20141212/MAH00297.flv','vga');"><H1 id="TS">Part 2</H1></a></li>		
		</ul></li>
		<li>CME Dr Dorothy Liu – Aug 29, 2014<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20140829/MAH00293.flv','vga');"><H1 id="TS">Video</H1></a></li>	
		</ul></li>
		<li>CME Dr Lau Wing Man – Jun 27, 2014<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20140627/MAH00287.flv','vga');"><H1 id="TS">Part 1</H1></a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20140627/MAH00288.flv','vga');"><H1 id="TS">Part 2</H1></a></li>
		</ul></li>	
		<li>CME Dr Cliff Chung – Apr 25, 2014<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20140425/00000.flv','vga');"><H1 id="TS">Part 1</H1></a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20140425/00001.flv','vga');"><H1 id="TS">Part 2</H1></a></li>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20140425/00002.flv','vga');"><H1 id="TS">Part 3</H1></a></li>		
		</ul></li>	
		<li>CME Dr Andrew Chung – Feb 28, 2014<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20140228/00037.flv','vga');"><H1 id="TS">Part 1</H1></a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20140228/00038.flv','vga');"><H1 id="TS">Part 2</H1></a></li>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20140228/00039.flv','vga');"><H1 id="TS">Part 3</H1></a></li>		
		</ul></li>		
		<li>CME Dr Chan Lung Wai – Jan 24, 2014<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20140124/00037.flv','vga');"><H1 id="TS">Part 1</H1></a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20140124/00038.flv','vga');"><H1 id="TS">Part 2</H1></a></li>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20140124/00039 .flv','vga');"><H1 id="TS">Part 3</H1></a></li>		
		</ul></li>
		<li>CME Dr Daniel Mok – Nov 29, 2013<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20131129/20131129DanielMok.flv','vga');"><H1 id="TS">Video</H1></a></li>	
		</ul></li>
		<li>CME Dr Chan Lung Wai and Dr. Wong Yik – Sept 27, 2013<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20130927/SANY0001.flv','vga');"><H1 id="TS">Part 1</H1></a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20130927/SANY002.flv','vga');"><H1 id="TS">Part 2</H1></a></li>					
		</ul></li>
		<li>Radio interview: Dr Chan Lung Wai – Sept 02, 2013<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20130902/radio_DrChanLungWai20130902.flv','vga');"><H1 id="TS">Audio</H1></a></li>					
		</ul></li>
		<li>CME Dr Thomas So – Jul 26, 2013<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20130726/SANY0001.flv','vga');"><H1 id="TS">Part 1</H1></a></li>					
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20130726/SANY0002.flv','vga');"><H1 id="TS">Part 2</H1></a></li>					
		</ul></li>	
		<li>CME Dr Edmund Chan – Apr 26,2013<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20130426/SANY0001.flv','vga');"><H1 id="TS">Part 1</H1></a></li>					
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20130426/SANY0002.flv','vga');"><H1 id="TS">Part 2</H1></a></li>					
		</ul></li>		
		<li>CME Dr Stephen Law - Feb 22,2013<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20130222/SANY0008.flv','vga');"><H1 id="TS">Part 1</H1></a></li>					
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20130222/SANY0009.flv','vga');"><H1 id="TS">Part 2</H1></a></li>					
		</ul></li>		
		<li>CME Prof Lee Yuk Tong - Jul 27,2012<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20120727/SANY0003.flv','vga');"><H1 id="TS">Video</H1></a></li>					
		</ul></li>					
		<li>CME Dr Anson Chow - May 25,2012<ul>
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20120525/SANY0003_001.flv','vga');"><H1 id="TS">Part 1</H1></a></li>	
		<li><a href="javascript:void(0);" onclick="playMovie('/swf/CME/20120525/SANY0004_001.flv','vga');"><H1 id="TS">Part 2</H1></a></li>					
		</ul></li>				
		</ul>		
		</div >
		<%}else if("MCS".equals(module)){ %>
		<div setImagePath="../images/dhtmlxTree/" class="dhtmlxTree">
		<ul>
		<li>MCS Training Video<ul>
			<li><a href="javascript:void(0);" onclick="playMovie('/swf/MCS/Warning Messages.flv','vga');"><H1 id="TS">Warning Messages</H1></a></li>	
			<li><a href="javascript:void(0);" onclick="playMovie('/swf/MCS/Blood transfusion.flv','vga');"><H1 id="TS">Blood transfusion</H1></a></li>
			<li><a href="javascript:void(0);" onclick="playMovie('/swf/MCS/Blood transfusion - Finish Blood Transfusion.flv','vga');"><H1 id="TS">Blood transfusion - Finish Blood Transfusion</H1></a></li>
			<li><a href="javascript:void(0);" onclick="playMovie('/swf/MCS/Blood transfusion - Interrupt Blood Transfusion.flv','vga');"><H1 id="TS">Blood transfusion - Interrupt Blood Transfusion</H1></a></li>
			<li><a href="javascript:void(0);" onclick="playMovie('/swf/MCS/Blood transfusion - Reprint Blood Pack Label.flv','vga');"><H1 id="TS">Blood transfusion - Reprint Blood Pack Label</H1></a></li>
			<li><a href="javascript:void(0);" onclick="playMovie('/swf/MCS/Blood transfusion - Restart Blood transfusion.flv','vga');"><H1 id="TS">Blood transfusion - Restart Blood transfusion</H1></a></li>
			<li><a href="javascript:void(0);" onclick="playMovie('/swf/MCS/Drug administration -  IV.flv','vga');"><H1 id="TS">Drug administration -  IV</H1></a></li>
			<li><a href="javascript:void(0);" onclick="playMovie('/swf/MCS/Drug administration - Exception - Exact Dose.flv','vga');"><H1 id="TS">Drug administration - Exception - Exact Dose</H1></a></li>
			<li><a href="javascript:void(0);" onclick="playMovie('/swf/MCS/Drug administration - Exception - Prepared Dose.flv','vga');"><H1 id="TS">Drug administration - Exception - Prepared Dose</H1></a></li>
			<li><a href="javascript:void(0);" onclick="playMovie('/swf/MCS/Drug administration - Handle Order.flv','vga');"><H1 id="TS">Drug administration - Handle Order</H1></a></li>
			<li><a href="javascript:void(0);" onclick="playMovie('/swf/MCS/Drug administration - Handle Record.flv','vga');"><H1 id="TS">Drug administration - Handle Record</H1></a></li>
			<li><a href="javascript:void(0);" onclick="playMovie('/swf/MCS/Drug administration - Oral.flv','vga');"><H1 id="TS">Drug administration - Oral</H1></a></li>
			<li><a href="javascript:void(0);" onclick="playMovie('/swf/MCS/Login.flv','vga');"><H1 id="TS">Login & Critical Value Alert</H1></a></li>
			<li><a href="javascript:void(0);" onclick="playMovie('/swf/MCS/Mobile Printer and MCS device.flv','vga');"><H1 id="TS">Mobile Printer and MCS device</H1></a></li>
			<li><a href="javascript:void(0);" onclick="playMovie('/swf/MCS/Specimen Taking.flv','vga');"><H1 id="TS">Specimen Taking</H1></a></li>
		</ul></li>			
		</ul>		
		</div >
				
		<%} %>
	</div>
<script>
	function playMP4(name) {
		$('#player').html("<video id=\"icVideo\" width=\"640\" height=\"480\" autoplay controls><source src=\"http://192.168.0.20/swf/CME/"+name+"\" type=\"video/mp4\"></video>");
	}
</script>