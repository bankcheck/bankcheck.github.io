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
public static ArrayList getMaskUsageTWAH(String fromDate, String toDate) {
	StringBuffer sqlStr = new StringBuffer();
	sqlStr.append("SELECT  ");
	sqlStr.append("    NVL(T1.DEPT_NO, T2.DEPT_NO) DEPT_NO,  ");
	sqlStr.append("    NVL(T1.DEPT_NAME, T2.DEPT_NAME) DEPT_NAME,  ");
	sqlStr.append("    NVL(T1.NO_OF_USAGE, T2.NO_OF_USAGE) DEPT_NAME,  ");
	sqlStr.append("    NVL(T1.NO_OF_HEADCOUNT, T2.NO_OF_HEADCOUNT) DEPT_NAME, ");
	sqlStr.append("    NVL(T1.Medicom_EarLpMsk_03010090050, 0), NVL(T1.Earloop_Mask_Small_03012800047, 0), NVL(T1.Surgical_Mask_3Ply_03010000352, 0), ");
	sqlStr.append("    NVL(T1.Three_M_EarLpMsk_03010000094, 0), NVL(T1.MedC_TOnMsk_NoFog_03010000112, 0), NVL(T1.Haly_Duck_TieOnMsk_03010000010, 0), ");
	sqlStr.append("    NVL(T1.Haly_FaceShieldMsk_03010000033, 0), NVL(T1.Three_M_N95_Mask_03010000019, 0), NVL(T1.Three_M_N95_C_Mask_03012100020, 0), ");
	sqlStr.append("    NVL(T1.Three_M_RespTy_N95_03012100169, 0), NVL(T1.Sanitizer500ML_03284400355, 0), NVL(T1.Aniosgel85NPC500ml_03284400206, 0), ");
    sqlStr.append("    NVL(T1.MedicomGown40gBlue_03030060090, 0), NVL(T1.N95_1805_03010000207, 0), NVL(T1.Three_M_VFlex_N95R_03012800197, 0), ");
    sqlStr.append("    NVL(T1.AniosScrub500ML_03284400216, 0), NVL(T1.AniosScrub1000ml_03284400222, 0), NVL(T1.ThreeMHandRub500ml_03284400225, 0), ");
    sqlStr.append("    NVL(T1.SurgicalMask2ply_03010000351, 0), NVL(T1.MaskAdultBlue_03010000346, 0), NVL(T1.LSNonIndPackingGRN_03010000349, 0), ");    
    sqlStr.append("    NVL(T1.MaskGreen3Ply_03010000350, 0), NVL(T1.MedicomFullShield_03010000227, 0), NVL(T1.Face_Shield_03010000356, 0), ");    
    sqlStr.append("    NVL(T1.FaceShield9x13_03010000353, 0), NVL(T1.AsianGoggle_03010000070, 0), NVL(T1.ThreeM_N95_1804_03010000338, 0), ");    
    sqlStr.append("    NVL(T1.N95_1804S_Resp_SM_03010000339, 0), NVL(T1.SlimBlueGloveXS_03022800177, 0), NVL(T1.Slim_Blue_Glove_S_03022800178, 0), ");    
    sqlStr.append("    NVL(T1.SlimBlueGloveM_03022900179, 0), NVL(T1.SlimBlueGloveL_03023000180, 0), NVL(T1.MicroTouchGlovesS_03022800155, 0), ");
    sqlStr.append("    NVL(T1.MicroTouchGlovesM_03022900156, 0), NVL(T1.MicroTouchGlovesL_03023000157, 0), NVL(T1.MicroTouchGlovesXL_03023000160, 0), ");    
    sqlStr.append("    NVL(T1.APOKCGownL_03030000087, 0), NVL(T1.MediSterileGownXL_03030000155, 0), NVL(T1.CPEGownFreeSize_03030000173, 0), ");    
    sqlStr.append("    NVL(T1.Cap21Blue_03364260009, 0), NVL(T1.Cap21White_03364230010, 0), NVL(T1.AlcoholSwabSterile_03080000060, 0), ");    
    sqlStr.append("    NVL(T1.PreseptTablets05g_03184800016, 0), NVL(T1.PreseptTablets25g_03184800017, 0), NVL(T1.LotionCleanPink1L_08016600084, 0), ");    
    sqlStr.append("    NVL(T1.Genius2Thermometer_03200000026, 0), NVL(T1.WelchATherProbeCvr_03200000207, 0), NVL(T1.WelchallynOralTemp_03200000015, 0), ");
    sqlStr.append("    NVL(T1.MedicomGownsYel_03030000088, 0) ");    
	sqlStr.append("FROM ");
	sqlStr.append("( ");
	sqlStr.append("    SELECT DEPT_NO, (SELECT DEPT_ENAME FROM PN_DEPT PD WHERE PD.DEPT_ID = DEPT_NO) AS DEPT_NAME, NO_OF_USAGE, NO_OF_HEADCOUNT,    ");
	sqlStr.append("    NVL(Medicom_Adult_Earloop_Mask,0) AS Medicom_EarLpMsk_03010090050, NVL(Earloop_Mask_Small,0) AS Earloop_Mask_Small_03012800047, NVL(Surgical_Mask_3Ply,0) AS Surgical_Mask_3Ply_03010000352,  ");
	sqlStr.append("    NVL(Earloop_Surgical_Mask_3M,0) AS Three_M_EarLpMsk_03010000094, NVL(Medicom_TieOn_Mask_AntiFog,0) AS MedC_TOnMsk_NoFog_03010000112, NVL(Halyard_Duckbill_TieOn_Mask,0) AS Haly_Duck_TieOnMsk_03010000010,  ");
	sqlStr.append("    NVL(Halyard_Face_Shield_Mask,0) AS Haly_FaceShieldMsk_03010000033, NVL(Three_M_B_N95_Mask,0) AS Three_M_N95_Mask_03010000019, NVL(Three_3M_N95_C_Mask,0) AS Three_M_N95_C_Mask_03012100020,  ");
	sqlStr.append("    NVL(Three_M_Flat_fold_N95,0) AS Three_M_RespTy_N95_03012100169, NVL(Hand_Sanitizer_500ML,0) AS Sanitizer500ML_03284400355, NVL(Aniosgel_85_NPC_500ml,0) AS Aniosgel85NPC500ml_03284400206, ");
    sqlStr.append("    NVL(Medicom_Gown_40g_blue,0) AS MedicomGown40gBlue_03030060090, NVL(N95_1805,0) AS N95_1805_03010000207, NVL(Three_M_VFlex_N95_Small,0) AS Three_M_VFlex_N95R_03012800197, ");
    sqlStr.append("    NVL(Anios_Scrub_Chlor_500ML,0) AS AniosScrub500ML_03284400216, NVL(Anios_Airless_Scrub_1000ml,0) AniosScrub1000ml_03284400222, NVL(ThreeM_Avagard9250HandRub500ml,0) AS ThreeMHandRub500ml_03284400225, ");
    sqlStr.append("    NVL(Surgical_Mask_2ply,0) AS SurgicalMask2ply_03010000351, NVL(Mask_Adult_Blue,0) AS MaskAdultBlue_03010000346, NVL(Livingstone_Non_IndPacking_GRN,0) AS LSNonIndPackingGRN_03010000349, ");
    sqlStr.append("    NVL(ThreeM_Ear_Mask_3Ply,0) AS MaskGreen3Ply_03010000350, NVL(Medicom_Full_Face_Shield,0) AS MedicomFullShield_03010000227, NVL(Face_Shield,0) AS Face_Shield_03010000356, ");
    sqlStr.append("    NVL(Face_Shield_9x13,0) AS FaceShield9x13_03010000353, NVL(Asian_Goggle_WVent,0) AS AsianGoggle_03010000070, NVL(ThreeM_N95_1804,0) AS ThreeM_N95_1804_03010000338, ");    
    sqlStr.append("    NVL(N95_1804S_Resp_SM,0) AS N95_1804S_Resp_SM_03010000339, NVL(Slim_Blue_Glove_XS,0) AS SlimBlueGloveXS_03022800177, NVL(Slim_Blue_Glove_S,0) AS Slim_Blue_Glove_S_03022800178, ");    
    sqlStr.append("    NVL(Slim_Blue_Glove_M,0) AS SlimBlueGloveM_03022900179, NVL(Slim_Blue_Glove_L,0) AS SlimBlueGloveL_03023000180, NVL(Micro_Touch_Gloves_S,0) AS MicroTouchGlovesS_03022800155, ");    
    sqlStr.append("    NVL(Micro_Touch_Gloves_M,0) AS MicroTouchGlovesM_03022900156, NVL(Micro_Touch_Gloves_L,0) AS MicroTouchGlovesL_03023000157, NVL(Micro_Touch_Gloves_XL,0) AS MicroTouchGlovesXL_03023000160, ");    
    sqlStr.append("    NVL(APO_KC_Gown_L,0) AS APOKCGownL_03030000087, NVL(Medicom_Sterile_Gown_XL,0) AS MediSterileGownXL_03030000155, NVL(CPE_Gown_FreeSize,0) AS CPEGownFreeSize_03030000173, ");    
    sqlStr.append("    NVL(Cap_21_Blue,0) AS Cap21Blue_03364260009, NVL(Cap_21_White,0) AS Cap21White_03364230010, NVL(Alcohol_Swab_Sterile,0) AS AlcoholSwabSterile_03080000060, ");    
    sqlStr.append("    NVL(Presept_Tablets_05g,0) AS PreseptTablets05g_03184800016, NVL(Presept_Tablets_25g,0) AS PreseptTablets25g_03184800017, NVL(Lotion_Clean_Pink_1L,0) AS LotionCleanPink1L_08016600084, ");
    sqlStr.append("    NVL(Genius_2_Thermometer,0) AS Genius2Thermometer_03200000026, NVL(WelchAllyn_ProbeCover,0) AS WelchATherProbeCvr_03200000207, NVL(Welchallyn_Oral_Temp,0) AS WelchallynOralTemp_03200000015, ");       
    sqlStr.append("    NVL(Medicom_Gowns_Yelllow,0) AS MedicomGownsYel_03030000088 ");    
	sqlStr.append("    FROM ( ");
	sqlStr.append("        SELECT DEPT_NO, CODE, APPLY_QTY, NO_OF_USAGE, NO_OF_HEADCOUNT  ");
	sqlStr.append("        FROM ( ");
	sqlStr.append("            SELECT M.DEPT_NO, M.CODE_NO AS CODE,   ");
	sqlStr.append("            DECODE(ig.unit_flag,'1',M.end_qty,'0',ROUND(M.end_qty/ig.pack_qty,3)) AS APPLY_QTY, 0 AS NO_OF_USAGE,  0 AS NO_OF_HEADCOUNT  ");
	sqlStr.append("            FROM IVS_MONTH M, IVS_DEPT D, IVS_GOODS IG  ");
	sqlStr.append("            WHERE M.DEPT_NO = D.DEPT_NO  ");
	sqlStr.append("            AND M.STOCK_YM = D.STOCK_YM  ");
	sqlStr.append("            AND M.CODE_NO = IG.CODE_NO  ");
	sqlStr.append("            AND M.DEPT_NO IN ('MSC') ");
	sqlStr.append("            AND M.CODE_NO IN ( ");
	sqlStr.append("            '03010090050', '03012800047', '03010000352',");
	sqlStr.append("            '03010000094', '03010000112', '03010000010',");
	sqlStr.append("            '03010000033', '03010000019', '03012100020',");
	sqlStr.append("            '03012100169', '03284400355', '03284400206',");
	sqlStr.append("            '03030060090', '03010000207', '03012800197',");
    sqlStr.append("            '03284400216', '03284400222', '03284400225',");
	sqlStr.append("            '03010000351', '03010000346', '03010000349',");
	sqlStr.append("            '03010000350', '03010000227', '03010000356',");
	sqlStr.append("            '03010000353', '03010000070', '03010000338',");
	sqlStr.append("            '03010000339', '03022800177', '03022800178',");
	sqlStr.append("            '03022900179', '03023000180', '03022800155',");
	sqlStr.append("            '03022900156', '03023000157', '03023000160',");
	sqlStr.append("            '03030000087', '03030000155', '03030000173',");
	sqlStr.append("            '03364260009', '03364230010', '03080000060',");
	sqlStr.append("            '03184800016', '03184800017', '08016600084',");
	sqlStr.append("            '03200000026', '03200000207', '03200000015',");	
	sqlStr.append("            '03030000088') ");	
	sqlStr.append("             ");
	sqlStr.append("            UNION  ");
	sqlStr.append("             ");
	sqlStr.append("            SELECT M.APPLY_DEPT AS DEPT_NO, D.CODE, D.REAL_QTY, HU.NO_OF_USAGE, HU.NO_OF_HEADCOUNT  ");
	sqlStr.append("            FROM IVS_APPLY_M M, IVS_APPLY_D D, HEADCOUNT_USAGE HU  ");
	sqlStr.append("            WHERE M.APPLY_NO = D.APPLY_NO  ");
	sqlStr.append("            AND TRIM(M.APPLY_DEPT) = HU.DEPT_NO  ");
	sqlStr.append("            AND HU.AREA = 'TWAH'  ");	
	sqlStr.append("            AND M.APPLY_DATE >= '");
	sqlStr.append(fromDate); 
	sqlStr.append("'");
	sqlStr.append("            AND M.APPLY_DATE <= '");
	sqlStr.append(toDate); 
	sqlStr.append("'");
	//sqlStr.append("            AND M.APPLY_DEPT IN ('100','110','120','130','140','150','160','200','210','220','330','360','365','370','770','800')  ");
	sqlStr.append("            AND D.CODE IN (");
	sqlStr.append("            '03010090050', '03012800047', '03010000352',");
	sqlStr.append("            '03010000094', '03010000112', '03010000010',");
	sqlStr.append("            '03010000033', '03010000019', '03012100020',");
	sqlStr.append("            '03012100169', '03284400355', '03284400206',");
	sqlStr.append("            '03030060090', '03010000207', '03012800197',");
    sqlStr.append("            '03284400216', '03284400222', '03284400225',");
	sqlStr.append("            '03010000351', '03010000346', '03010000349',");
	sqlStr.append("            '03010000350', '03010000227', '03010000356',");
	sqlStr.append("            '03010000353', '03010000070', '03010000338',");
	sqlStr.append("            '03010000339', '03022800177', '03022800178',");
	sqlStr.append("            '03022900179', '03023000180', '03022800155',");
	sqlStr.append("            '03022900156', '03023000157', '03023000160',");
	sqlStr.append("            '03030000087', '03030000155', '03030000173',");
	sqlStr.append("            '03364260009', '03364230010', '03080000060',");
	sqlStr.append("            '03184800016', '03184800017', '08016600084',");
	sqlStr.append("            '03200000026', '03200000207', '03200000015',");	
	sqlStr.append("            '03030000088') ");
	sqlStr.append("             ");
	sqlStr.append("        )      ");
	sqlStr.append("    ) PIVOT  ");
	sqlStr.append("    (SUM(APPLY_QTY)  ");
	sqlStr.append("    FOR CODE IN ( ");
	sqlStr.append("    '03010090050' Medicom_Adult_Earloop_Mask, '03012800047' Earloop_Mask_Small, '03010000352' Surgical_Mask_3Ply,  ");
	sqlStr.append("    '03010000094' Earloop_Surgical_Mask_3M, '03010000112' Medicom_TieOn_Mask_AntiFog, '03010000010' Halyard_Duckbill_TieOn_Mask,  ");
	sqlStr.append("    '03010000033' Halyard_Face_Shield_Mask, '03010000019' Three_M_B_N95_Mask, '03012100020' Three_3M_N95_C_Mask,  ");
	sqlStr.append("    '03012100169' Three_M_Flat_fold_N95, '03284400355' Hand_Sanitizer_500ML, '03284400206' Aniosgel_85_NPC_500ml, ");
    sqlStr.append("    '03030060090' Medicom_Gown_40g_blue, '03010000207' N95_1805, '03012800197' Three_M_VFlex_N95_Small, ");
    sqlStr.append("    '03284400216' Anios_Scrub_Chlor_500ML, '03284400222' Anios_Airless_Scrub_1000ml, '03284400225' ThreeM_Avagard9250HandRub500ml, ");
    sqlStr.append("    '03010000351' Surgical_Mask_2ply, '03010000346' Mask_Adult_Blue, '03010000349' Livingstone_Non_IndPacking_GRN, ");
    sqlStr.append("    '03010000350' ThreeM_Ear_Mask_3Ply, '03010000227' Medicom_Full_Face_Shield, '03010000356' Face_Shield, ");
    sqlStr.append("    '03010000353' Face_Shield_9x13, '03010000070' Asian_Goggle_WVent, '03010000338' ThreeM_N95_1804, ");
    sqlStr.append("    '03010000339' N95_1804S_Resp_SM, '03022800177' Slim_Blue_Glove_XS, '03022800178' Slim_Blue_Glove_S, ");        
    sqlStr.append("    '03022900179' Slim_Blue_Glove_M, '03023000180' Slim_Blue_Glove_L, '03022800155' Micro_Touch_Gloves_S, ");
    sqlStr.append("    '03022900156' Micro_Touch_Gloves_M, '03023000157' Micro_Touch_Gloves_L, '03023000160' Micro_Touch_Gloves_XL, ");        
    sqlStr.append("    '03030000087' APO_KC_Gown_L, '03030000155' Medicom_Sterile_Gown_XL, '03030000173' CPE_Gown_FreeSize, ");
    sqlStr.append("    '03364260009' Cap_21_Blue, '03364230010' Cap_21_White, '03080000060' Alcohol_Swab_Sterile, ");
    sqlStr.append("    '03184800016' Presept_Tablets_05g, '03184800017' Presept_Tablets_25g, '08016600084' Lotion_Clean_Pink_1L, ");
    sqlStr.append("    '03200000026' Genius_2_Thermometer, '03200000207'  WelchAllyn_ProbeCover, '03200000015' Welchallyn_Oral_Temp, ");
    sqlStr.append("    '03030000088' Medicom_Gowns_Yelllow )) order by 1 ");	
	sqlStr.append(") T1 ");
	sqlStr.append("RIGHT join ");
	sqlStr.append("( ");
	sqlStr.append("    SELECT HU.DEPT_NO, PD.DEPT_ENAME AS DEPT_NAME, HU.NO_OF_USAGE, HU.NO_OF_HEADCOUNT  ");
	sqlStr.append("    FROM HEADCOUNT_USAGE HU JOIN PN_DEPT PD ON TRIM(PD.DEPT_ID) = DEPT_NO ");
	sqlStr.append("    WHERE HU.AREA = 'TWAH'  ");	
//	sqlStr.append("    WHERE DEPT_NO IN ('100','110','120','130','140','150','160','200','210','220','330','360','365','370','770','800') ");
	sqlStr.append("        UNION ");
	sqlStr.append("    SELECT DEPT_ID, DEPT_ENAME, 0 AS NO_OF_USAGE,  0 AS NO_OF_HEADCOUNT  ");
	sqlStr.append("    FROM PN_DEPT ");
	sqlStr.append("    WHERE DEPT_ID IN ('MSC') ");
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

al_epo = getMaskUsageTWAH(fromDate,toDate);;

request.setAttribute("EPO",al_epo);

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
	<display:column style="width:5%; text-align:center" title="Surgical_Mask_3Ply
	03010000352">	
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
    <display:column style="width:5%; text-align:center" title="Pacomeri Hand Sanitizer 500ml
    03284400355">
		<div>${EPO[resList_rowNum - 1].fields14}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="Aniosgel 85 NPC 500ml
    03284400206">
		<div>${EPO[resList_rowNum - 1].fields15}</div>
	</display:column>		
    <display:column style="width:5%; text-align:center" title="Medicom Gown 40g blue
    03030060090">
		<div>${EPO[resList_rowNum - 1].fields16}</div>
	</display:column>	
    <display:column style="width:5%; text-align:center" title="3M N95 V-Flex Regular
    03010000207">
		<div>${EPO[resList_rowNum - 1].fields17}</div>
	</display:column>	
    <display:column style="width:5%; text-align:center" title="3M N95 V-Flex Small
    03012800197">
		<div>${EPO[resList_rowNum - 1].fields18}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="Anios Scrub Chlorthexidine 4% 500ml
    03284400216">
		<div>${EPO[resList_rowNum - 1].fields19}</div>
	</display:column>	
    <display:column style="width:5%; text-align:center" title="Anios Airless Scrub 4% 1000ml
    03284400222">
		<div>${EPO[resList_rowNum - 1].fields20}</div>
	</display:column>	
    <display:column style="width:5%; text-align:center" title="3M Avagard 9250 Hand Rub Chlorhexidine Gluconate 0.5% 500ml
    03284400225">
		<div>${EPO[resList_rowNum - 1].fields21}</div>
	</display:column>	
    <display:column style="width:5%; text-align:center" title="Surgical Mask (2-ply)
    03010000351">
		<div>${EPO[resList_rowNum - 1].fields22}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="Face Mask Adult
    03010000346">
		<div>${EPO[resList_rowNum - 1].fields23}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="{Livingstone} 3-ply Mask (Non-Individual Packing) Green                                                                                                                            
    03010000349">
		<div>${EPO[resList_rowNum - 1].fields24}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="{Livingstone} 3-ply Mask (Individual Packing) Green
    03010000350">
		<div>${EPO[resList_rowNum - 1].fields25}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="{Medicom} SafeWear Full Face Shield
    03010000227">
		<div>${EPO[resList_rowNum - 1].fields26}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="Face Shield
    03010000356">
		<div>${EPO[resList_rowNum - 1].fields27}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="{Healthmark} Face Shield with Drape Size                                                                                                                                          
    03010000353">
		<div>${EPO[resList_rowNum - 1].fields28}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="{Uvex} Asian Goggle, Clear Acetate, With Vent
    03010000070">
		<div>${EPO[resList_rowNum - 1].fields29}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="{3M} N95 1804 Vflex HC Resp Surg Mask
    03010000338">
		<div>${EPO[resList_rowNum - 1].fields30}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="{3M} N95 1804S Vflex HC Resp Surg Mask SM
    03010000339">
		<div>${EPO[resList_rowNum - 1].fields31}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="{Medicom} Safetouch Slim Blue PF Glove - XS
    03022800177">
		<div>${EPO[resList_rowNum - 1].fields32}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="{Medicom} Safetouch Slim Blue PF Glove - S
    03022800178">
		<div>${EPO[resList_rowNum - 1].fields33}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="{Medicom} Safetouch Slim Blue PF Glove - M
    03022900179">
		<div>${EPO[resList_rowNum - 1].fields34}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="{Medicom} Safetouch Slim Blue PF Glove - L
    03023000180">
		<div>${EPO[resList_rowNum - 1].fields35}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="{Ansell} Micro-Touch Accelerator-Free Gloves Size S
    03022800155">
		<div>${EPO[resList_rowNum - 1].fields36}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="{Ansell} Micro-Touch Accelerator-Free Gloves Size M                                                                                                                    
    03022900156">
		<div>${EPO[resList_rowNum - 1].fields37}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="{Ansell} Micro-Touch Accelerator-Free Gloves Size L
    03023000157">
		<div>${EPO[resList_rowNum - 1].fields38}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="{Ansell} Micro-Touch Accelerator-Free Gloves Size XL
    03023000160">
		<div>${EPO[resList_rowNum - 1].fields39}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="{Halyard} APO KC Surgical Gown L (Large)
    03030000087">
		<div>${EPO[resList_rowNum - 1].fields40}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="{Medicom} Sterile Surgical Gown - XL
    03030000155">
		<div>${EPO[resList_rowNum - 1].fields41}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="{Med-Con} CPE Gown Free Size (Individual Pack)
    03030000173">
		<div>${EPO[resList_rowNum - 1].fields42}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="Bouffant Cap 21 inch 25gsm Blue
    03364260009">
		<div>${EPO[resList_rowNum - 1].fields43}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="Bouffant Cap 21 inch 25gsm White
    03364230010">
		<div>${EPO[resList_rowNum - 1].fields44}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="{TCM} Alcohol Swab Sterile
    03080000060">
		<div>${EPO[resList_rowNum - 1].fields45}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="Presept Tablets 0.5g
    03184800016">
		<div>${EPO[resList_rowNum - 1].fields46}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="Presept Tablets 2.5g
    03184800017">
		<div>${EPO[resList_rowNum - 1].fields47}</div>
	</display:column>																							
    <display:column style="width:5%; text-align:center" title="{Kleenex} Lotion Skin Cleanser Pink 1L
    08016600084">
		<div>${EPO[resList_rowNum - 1].fields48}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="{Covidien} Probe Cover for Genius 2 Thermometer
    03200000026">
		<div>${EPO[resList_rowNum - 1].fields49}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="Welch Allyn Ear Thermometer Probe cove                                                                                                                                  
    03200000207">
		<div>${EPO[resList_rowNum - 1].fields50}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="{Welchallyn} Probe Covers-Oral Temp
    03200000015">
		<div>${EPO[resList_rowNum - 1].fields51}</div>
	</display:column>
    <display:column style="width:5%; text-align:center" title="{Medicom} Isolation Gowns 40g - Yellow
    03030000088">
		<div>${EPO[resList_rowNum - 1].fields52}</div>
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