<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.ConstantsServerSide"%>;
<%@ page import="java.text.SimpleDateFormat"%>
<%@ page import="org.displaytag.decorator.*"%>
<%@ page import="org.displaytag.exception.DecoratorException"%>
<%@ page import="org.displaytag.properties.MediaTypeEnum"%>
<%!
public static ArrayList getMaskUsageHKAH(String fromDate, String toDate) {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT  ");
	sqlStr.append("    NVL(T1.DEPT_NO, T2.DEPT_NO) DEPT_NO,  ");
	sqlStr.append("    NVL(T1.DEPT_NAME, T2.DEPT_NAME) DEPT_NAME,  ");
	sqlStr.append("    NVL(T1.NO_OF_USAGE, T2.NO_OF_USAGE) DEPT_NAME,  ");
	sqlStr.append("    NVL(T1.NO_OF_HEADCOUNT, T2.NO_OF_HEADCOUNT) DEPT_NAME, ");
	sqlStr.append("    NVL(T1.Medicom_EarLpMsk_03010090050, 0), NVL(T1.Earloop_Mask_Small_03012800047, 0), NVL(T1.MedC_EarLpMsk_Ch_03012800336, 0),  ");
	sqlStr.append("    NVL(T1.Three_M_EarLpMsk_03010000094, 0), NVL(T1.MedC_TOnMsk_NoFog_03010000112, 0), NVL(T1.Haly_Duck_TieOnMsk_03010000010, 0),  ");
	sqlStr.append("    NVL(T1.Haly_FaceShieldMsk_03010000033, 0), NVL(T1.Three_M_N95_Mask_03010000019, 0), NVL(T1.Three_M_N95_C_Mask_03012100020, 0),  ");
	sqlStr.append("    NVL(T1.Three_M_RespTy_N95_03012100169, 0), NVL(T1.Three_M_VFlex_N95R_03010000207, 0), NVL(T1.Three_M_VFlex_N95R_03012800197, 0)  ");
	sqlStr.append("FROM ");
	sqlStr.append("( ");
	sqlStr.append("    SELECT DEPT_NO, (SELECT DEPT_ENAME FROM PN_DEPT PD WHERE PD.DEPT_ID = DEPT_NO) AS DEPT_NAME, NO_OF_USAGE, NO_OF_HEADCOUNT,    ");
	sqlStr.append("    NVL(Medicom_Adult_Earloop_Mask,0) AS Medicom_EarLpMsk_03010090050, NVL(Earloop_Mask_Small,0) AS Earloop_Mask_Small_03012800047, NVL(Medicom_Child_Earloop_Mask,0) AS MedC_EarLpMsk_Ch_03012800336,  ");
	sqlStr.append("    NVL(Earloop_Surgical_Mask_3M,0) AS Three_M_EarLpMsk_03010000094, NVL(Medicom_TieOn_Mask_AntiFog,0) AS MedC_TOnMsk_NoFog_03010000112, NVL(Halyard_Duckbill_TieOn_Mask,0) AS Haly_Duck_TieOnMsk_03010000010,  ");
	sqlStr.append("    NVL(Halyard_Face_Shield_Mask,0) AS Haly_FaceShieldMsk_03010000033, NVL(Three_M_B_N95_Mask,0) AS Three_M_N95_Mask_03010000019, NVL(Three_3M_N95_C_Mask,0) AS Three_M_N95_C_Mask_03012100020,  ");
	sqlStr.append("    NVL(Three_M_Flat_fold_N95,0) AS Three_M_RespTy_N95_03012100169, NVL(Three_M_VFlex_N95_Regular,0) AS Three_M_VFlex_N95R_03010000207, NVL(Three_M_VFlex_N95_Small,0) AS Three_M_VFlex_N95R_03012800197  ");
	sqlStr.append("    FROM ( ");
	sqlStr.append("        SELECT DEPT_NO, CODE, APPLY_QTY, NO_OF_USAGE, NO_OF_HEADCOUNT  ");
	sqlStr.append("        FROM ( ");
	sqlStr.append("            SELECT M.DEPT_NO, M.CODE_NO AS CODE,   ");
	sqlStr.append("            DECODE(ig.unit_flag,'1',M.end_qty,'0',ROUND(M.end_qty/ig.pack_qty,3)) AS APPLY_QTY, 0 AS NO_OF_USAGE,  0 AS NO_OF_HEADCOUNT  ");
	sqlStr.append("            FROM IVS_MONTH M, IVS_DEPT D, IVS_GOODS IG  ");
	sqlStr.append("            WHERE M.DEPT_NO = D.DEPT_NO  ");
	sqlStr.append("            AND M.STOCK_YM = D.STOCK_YM  ");
	sqlStr.append("            AND M.CODE_NO = IG.CODE_NO  ");
	sqlStr.append("            AND M.DEPT_NO IN ('MSC','CSR') ");
	sqlStr.append("            AND M.CODE_NO IN ( ");
	sqlStr.append("            '03010090050', '03012800047', '03012800336', '03010000094', '03010000112', '03010000010', '03010000033', '03010000019', '03012100020', '03012100169', '03010000207', '03012800197')  ");
	sqlStr.append("             ");
	sqlStr.append("            UNION  ");
	sqlStr.append("             ");
	sqlStr.append("            SELECT M.APPLY_DEPT AS DEPT_NO, D.CODE, D.REAL_QTY, HU.NO_OF_USAGE, HU.NO_OF_HEADCOUNT  ");
	sqlStr.append("            FROM IVS_APPLY_M M, IVS_APPLY_D D, HEADCOUNT_USAGE HU  ");
	sqlStr.append("            WHERE M.APPLY_NO = D.APPLY_NO  ");
	sqlStr.append("            AND TRIM(M.APPLY_DEPT) = HU.DEPT_NO  ");
	sqlStr.append("            AND M.APPLY_DATE >= '");
	sqlStr.append(fromDate); 
	sqlStr.append("'");
	sqlStr.append("            AND M.APPLY_DATE <= '");
	sqlStr.append(toDate); 
	sqlStr.append("'");
	//sqlStr.append("            AND M.APPLY_DEPT IN ('100','110','120','130','140','150','160','200','210','220','330','360','365','370','770','800')  ");
	sqlStr.append("            AND D.CODE IN ('03010090050', '03012800047', '03012800336', '03010000094', '03010000112', '03010000010', '03010000033', '03010000019', '03012100020', '03012100169', '03010000207', '03012800197') ");
	sqlStr.append("             ");
	sqlStr.append("        )      ");
	sqlStr.append("    ) PIVOT  ");
	sqlStr.append("    (SUM(APPLY_QTY)  ");
	sqlStr.append("    FOR CODE IN ( ");
	sqlStr.append("    '03010090050' Medicom_Adult_Earloop_Mask, '03012800047' Earloop_Mask_Small, '03012800336' Medicom_Child_Earloop_Mask,  ");
	sqlStr.append("    '03010000094' Earloop_Surgical_Mask_3M, '03010000112' Medicom_TieOn_Mask_AntiFog, '03010000010' Halyard_Duckbill_TieOn_Mask,  ");
	sqlStr.append("    '03010000033' Halyard_Face_Shield_Mask, '03010000019' Three_M_B_N95_Mask, '03012100020' Three_3M_N95_C_Mask,  ");
	sqlStr.append("    '03012100169' Three_M_Flat_fold_N95, '03010000207' Three_M_VFlex_N95_Regular, '03012800197' Three_M_VFlex_N95_Small)) order by 1 ");
	sqlStr.append(") T1 ");
	sqlStr.append("RIGHT join ");
	sqlStr.append("( ");
	sqlStr.append("    SELECT HU.DEPT_NO, PD.DEPT_ENAME AS DEPT_NAME, HU.NO_OF_USAGE, HU.NO_OF_HEADCOUNT  ");
	sqlStr.append("    FROM HEADCOUNT_USAGE HU JOIN PN_DEPT PD ON TRIM(PD.DEPT_ID) = DEPT_NO ");
	sqlStr.append("    WHERE DEPT_NO IN ('100','110','120','130','140','150','160','200','210','220','330','360','365','370','770','800') ");
	sqlStr.append("        UNION ");
	sqlStr.append("    SELECT DEPT_ID, DEPT_ENAME, 0 AS NO_OF_USAGE,  0 AS NO_OF_HEADCOUNT  ");
	sqlStr.append("    FROM PN_DEPT ");
	sqlStr.append("    WHERE DEPT_ID IN ('MSC','CSR') ");
	sqlStr.append(") T2 ");
	sqlStr.append("ON TRIM(T1.DEPT_NO) = TRIM(T2.DEPT_NO) ");
	sqlStr.append("order by 1 ");
	System.err.println(sqlStr.toString());
	return UtilDBWeb.getReportableListTAH(sqlStr.toString());
}	
%>
<%
UserBean userBean = new UserBean(request);
String serverSiteCode = ConstantsServerSide.SITE_CODE;
int noOfCol = 7;//no of column in list
String reqNo = request.getParameter("reqNo");
String itemDesc = request.getParameter("itemDesc");
String reqSeq = request.getParameter("reqSeq");
String fromDate = request.getParameter("fromDate");
String toDate = request.getParameter("toDate");
Calendar cal = Calendar.getInstance();
SimpleDateFormat dateFmt = new SimpleDateFormat("yyyyMMdd");
cal.add(Calendar.DATE, -3);
String prev4Date = dateFmt.format(cal.getTime());

cal = Calendar.getInstance();
cal.add(Calendar.DATE, -1);
String prev1Date = dateFmt.format(cal.getTime());
System.out.println("[prev4Date]:"+prev4Date+";[prev1Date]"+prev1Date);

ArrayList al_epo = null;

if ("hkah".equals(serverSiteCode)) {					
	//al_epo = EPORequestDB.getMaskUsageHKAH(fromDate,toDate);
	al_epo = getMaskUsageHKAH(fromDate,toDate);
} else if ("twah".equals(serverSiteCode)) {
	al_epo = EPORequestDB.getMaskUsageTWAH(fromDate,toDate);
}

request.setAttribute("EPO",al_epo);
int epoSize = al_epo.size();
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
<jsp:include page="../common/header.jsp"/>
<body>
<bean:define id="functionLabel"><bean:message key="function.epo.list" /></bean:define>
<bean:define id="notFoundMsg"><bean:message key="message.notFound" arg0="<%=functionLabel %>" /></bean:define>
<font size="4" color="red">From:</font><font size="4" color="blue"><%=fromDate %></font><font size="4" color="red"> To:</font><font size="4" color="blue"><%=toDate %></font>
<display:table id="resList" name="EPO" export="true" pagesize="<%=userBean.getNoOfRecPerPage() %>" class="tablesorter">	     
	<display:column title="&nbsp;" media="html" style="width:2%"><%=pageContext.getAttribute("resList_rowNum")%>)</display:column>	   
	<display:column style="width:5%; text-align:center" title="Dept No.">	
		<div>${EPO[resList_rowNum - 1].fields0}</div>
    </display:column>    				           	
    <display:column  style="width:10%; text-align:center" title="Dept Name">
		<div>${EPO[resList_rowNum - 1].fields1}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="Mask Usage">
		<div>${EPO[resList_rowNum - 1].fields2}</div>
	</display:column>	
	<display:column style="width:5%; text-align:center" title="No Of Headcount">	
		<div>${EPO[resList_rowNum - 1].fields3}</div>
    </display:column>
	<display:column style="width:5%; text-align:center" title="Medicom EarLoop Mask
	03010090050">	
		<div>${EPO[resList_rowNum - 1].fields4}</div>
    </display:column>
	<display:column style="width:5%; text-align:center" title="Earloop Mask (Small)
	03012800047">	
		<div>${EPO[resList_rowNum - 1].fields5}</div>
    </display:column>
	<display:column style="width:5%; text-align:center" title="Medicom Earloop Mask Child Blue
	03012800336">	
		<div>${EPO[resList_rowNum - 1].fields6}</div>
    </display:column>    
	<display:column style="width:5%; text-align:center" title="3M EarLoop Mask
	03010000094">	
		<div>${EPO[resList_rowNum - 1].fields7}</div>
    </display:column>
    <display:column style="width:5%; text-align:center" title="Medicom Tie-On Mask Anti-Fog Adult
    03010000112">
		<div>${EPO[resList_rowNum - 1].fields8}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="Halyard Duckbill Tie-on Mask                                                                                                                                                    
    03010000010">
		<div>${EPO[resList_rowNum - 1].fields9}</div>
	</display:column>	   
    <display:column style="width:5%; text-align:center" title="Halyard FaceShield Mask
    03010000033">
		<div>${EPO[resList_rowNum - 1].fields10}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="3M N95 Mask(B)
    03010000019">
		<div>${EPO[resList_rowNum - 1].fields11}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="3M N95 Mask(C) 
    03012100020">
		<div>${EPO[resList_rowNum - 1].fields12}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="3M N95 Flat-fold
    03012100169">
		<div>${EPO[resList_rowNum - 1].fields13}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="3M N95 V-Flex Regular
    03010000207">
		<div>${EPO[resList_rowNum - 1].fields14}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="3M N95 V-Flex Small
    03012800197">
		<div>${EPO[resList_rowNum - 1].fields15}</div>
	</display:column>									
	<display:setProperty name="basic.msg.empty_list" value="<%=notFoundMsg %>"/>	           					            
</display:table>
<table cellpadding="0" cellspacing="5"
	class="contentFrameMenu" border="0">
	<tr class="smallText">
		<td align="center">
			<button onclick="return closeAction();"><bean:message key="button.close" /></button>			
		</td>			
	</tr>
</table>
</body>
</html:html>
<script type="text/javascript">
function closeAction() {
	window.close();
}
</script>