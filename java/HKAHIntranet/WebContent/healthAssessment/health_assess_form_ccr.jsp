<%@ page import="java.util.*"%> 
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="org.apache.struts.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%
Boolean SaveFormAction = false;
Boolean completeFormAction = false;
Boolean newForm = false;
boolean loginAction = false;
ReportableListObject row = null;
ArrayList result = null;
ArrayList resultpl = null;
String plkey = "";
String pldesc = "";
String haID = null;
String formType = "";
String q1 = "";
String q2_1 = "";
String q2_2 = "";
String q2_3 = "";
String q2_4 = "";
String q2_5 = "";
String q2_6 = "";
String q2_7 = "";
String q2_8 = "";
String q3_a1 = "";
String q3_a2 = "";
String q3_a3 = "";
String q3_a4 = "";
String q3_b1 = "";
String q3_b2 = "";
String q3_b3 = "";
String q3_c1 = "";
String q3_c2 = "";
String q3_d1 = "";
String q3_d2 = "";
String q3_d3 = "";
String q3_d4 = "";
String q3_e1 = "";
String q3_f1 = "";
String q3_f2 = "";
String q3_f3 = "";
String q3_f4 = "";
String q3_g1 = "";
String q3_g2 = "";
String q3_g3 = "";
String q3_h1 = "";
String q4_1 = "";
String q4_2 = "";
String q5_a1 = "";
String q5_a2 = "";
String q5_a3 = "";
String q5_a4 = "";
String q5_a5 = "";
String q5_a6 = "";
String q5_b1 = ""; 
String q6_a1 = "";
String q6_a2 = "";
String q6_b1 = "";
String q6_b2 = "";
String q6_c1 = "";
String q6_c2 = "";
String smoke_1 = "";
String smoke_2 = "";
String smoke_3 = "";
String smoke_4 = "";
String smoke_5 = "";
String smoke_6 = "";
String drink_1 = "";
String drink_2 = "";
String drink_3 = "";
String drink_4 = "";
String drink_5 = "";
String drink_6 = "";
String drink_7 = "";
String drink_8 = "";
String drink_9 = "";
String drink_10 = "";
String drink_11 = "";
String drink_12 = "";
String drink_13 = "";
String drink_14 = "";
String eat_1 = "";
String eat_2 = "";
String eat_3 = "";
String eat_4 = "";
String eat_5 = "";
String eat_6 = "";
String eat_7 = "";
String eat_8 = "";
String eat_9 = "";
String eat_10 = "";
String eat_11 = "";
String eat_12 = "";
String eat_13 = "";
String eat_14 = "";
String sleep_1 = "";
String sleep_2 = "";
String sport_1 = "";
String sport_2 = "";
String sport_3 = "";
String sport_4 = "";
String mood_1 = "";
String mood_2 = "";
String mood_3 = "";
String mood_4 = "";
String female_1 = "";
String female_2 = "";
String female_3 = "";
String female_4 = "";
String female_5 = "";
String female_6 = "";
String female_7 = "";
String female_8 = "";
String female_9 = "";
String female_10 = "";
String phy_1 = "";
String phy_2 = "";
String phy_3 = "";
String phy_4 = "";
String phy_5 = "";
String phy_6 = "";
String phy_7 = "";
String phy_8 = "";
String phy_9 = "";
String phy_10 = "";
String phy_11 = "";
String phy_12 = "";
String phy_13 = "";
String phy_14 = "";
String phy_15 = "";
String phy_16 = "";
String phy_17 = "";
String phy_18 = "";
String phy_19 = "";
String phy_20 = "";

// Nurse Doctor Form
String gc_1 = "";
String gc_2 = "";
String gc_3 = "";
String gc_4 = "";
String gc_5 = "";
String gc_6 = "";
String gc_7 = "";
String gc_8 = "";
String gc_9 = "";
String gc_10 = "";
String gc_11 = "";
String gc_12 = "";
String gc_13 = "";
String gc_14 = "";
String gc_15 = "";
//
String[] ent_p = new String[56];
String ls_1 = ""; 
String ls_2 = "";
String ls_3 = "";
String ls_4 = "";
String ls_5 = "";
String ls_6 = "";

String bn_1 = "";
String bn_2 = "";
String bn_3 = "";
String bn_4 = "";
String bn_5 = "";
String bn_6 = "";
String bn_7 = "";
String bn_8 = "";
String bn_9 = "";
String bn_10 = "";
String bn_11 = "";
String bn_12 = "";
String bn_13 = "";
String bn_14 = "";
String bn_15 = "";
String bn_16 = "";
String rs_1 = "";
String rs_2 = "";
String rs_3 = "";
String rs_4 = "";
String rs_5 = "";
String rs_6 = "";
String rs_7 = "";
String rs_8 = "";
String rs_9 = "";
String rs_10 = "";

String rs_11 = "";
String rs_12 = "";
String rs_13 = "";
String rs_14 = "";
String rs_15 = "";
String rs_16 = "";

String cs_1 = "";
String cs_2 = "";
String cs_3 = "";
String cs_4 = "";
String cs_5 = "";
String cs_6 = "";
String cs_7 = "";
String cs_8 = "";

String ne_1 = "";
String ne_2 = "";
String ne_3 = "";
String ne_4 = "";
String ne_5 = "";
String ne_6 = "";
String ne_7 = "";
String ne_8 = "";
String ne_9 = "";
String ne_10 = "";
String ne_11 = "";
String ne_12 = "";
String ne_13 = "";
String ne_14 = "";
String ne_15 = "";
String ne_16 = "";
String ne_17 = "";
String ne_18 = "";
String ne_19 = "";
String ne_20 = "";
String s_1 = "";
String s_2 = "";
String s_3 = "";
String s_4 = "";
String[] a_p = new String[41];
String[] mn_p = new String[15];
String completed = "0";
String remark = "";
int cnt = 0;
String ex_1 = "";
String ex_2 = "";
String createDate = "";
String createTime = "";
String q3_a5 = "";
String q3_a6 = "";
String q3_b4 = "";
String q3_b5 = "";
String q3_d5 = "";
String q3_d6 = "";
String q3_e2 = "";
String q3_e3 = "";
String q3_f5 = "";
String q3_f6 = "";
String q3_h2 = "";
String q3_i1 = "";
String q5_a7 = "";
//
String female_11 = "";
String female_12 = "";
//
String q3_d7 = "";
String q3_d8 = "";
String q3_d9 = "";
String q3_d10 = "";
//
String eat_15 = "";
String eat_16 = "";
String eat_17 = "";
String eat_18 = "";
String eat_19 = "";
String eat_20 = "";
String eat_21 = "";
String eat_22 = "";

//
String modifyDate = "";
String modifyTime = "";
String modifyUser = "";

String ultrasoundOthers = "";
String[] ultraOther1=request.getParameterValues("ultraOther1");
String[] ultraOther2=request.getParameterValues("ultraOther2");
if(ultraOther1 != null){	
    //for(String s : hatsSearchCodeArray1){
    	//ultrasoundOthers = ultrasoundOthers
    //}
    for (int i=0;i<ultraOther1.length;i++){
    	ultrasoundOthers = ultrasoundOthers + ultraOther1[i] + "<inner>" + ultraOther2[i] + "<outer>";  
    }
}
if ("<inner><outer>".equals(ultrasoundOthers)) {
	ultrasoundOthers = "";
}
String xrayOthers = "";
String[] xrayOther1=request.getParameterValues("xrayOther1");
String[] xrayOther2=request.getParameterValues("xrayOther2");
if(xrayOther1 != null){	
    //for(String s : hatsSearchCodeArray1){
    	//ultrasoundOthers = ultrasoundOthers
    //}
    for (int i=0;i<xrayOther1.length;i++){
    	xrayOthers = xrayOthers + xrayOther1[i] + "<inner>" + xrayOther2[i] + "<outer>";  
    }
}
if ("<inner><outer>".equals(xrayOthers)) {
	xrayOthers = "";
}
String otherOthers = "";
String[] otherOther1=request.getParameterValues("otherOther1");
String[] otherOther2=request.getParameterValues("otherOther2");
if(otherOther1 != null){	
    //for(String s : hatsSearchCodeArray1){
    	//ultrasoundOthers = ultrasoundOthers
    //}
    for (int i=0;i<otherOther1.length;i++){
    	otherOthers = otherOthers + otherOther1[i] + "<inner>" + otherOther2[i] + "<outer>";  
    }
}
if ("<inner><outer>".equals(otherOthers)) {
	otherOthers = "";
}

String command = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "command"));
String regID = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "regID"));
String patNo = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patNo"));
String formMode = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mode"));
String seqNo = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "seqNo"));
String patName = "";
String patCName = "";
String patAge = "";
String patSex = "";
String patDob = "";
String patConNo = "";
String docCode = "";
String docName = "";
Boolean isMRStaff = false;

ReportableListObject reportableListObject = null;
boolean patientMode = false;
boolean nurseMode = false;
boolean finishSaving = false;

//String sessionKey = request.getParameter("session");
String language = request.getParameter("language");
String staffID = request.getParameter("staffID");
String haFormPatient = "patient";

Locale locale = Locale.US;
if ("chi".equals(language)) {
	locale = Locale.TRADITIONAL_CHINESE;
} else {
	locale = Locale.US;
}

session.setAttribute( Globals.LOCALE_KEY, locale );
UserBean userBean = new UserBean(request);

//get Dr PickList
resultpl = HAFormDB.fetchDRPL();

// get pat info
result = PatientDB.getPatInfo(patNo);
if (result.size() > 0) {
	reportableListObject = (ReportableListObject) result.get(0);
	patName = reportableListObject.getValue(3);
	patCName = reportableListObject.getValue(4);
	patAge = reportableListObject.getValue(5);
	patSex = reportableListObject.getValue(1);
	patDob = reportableListObject.getValue(10);
}

//docName = HAFormDB.getRegDocName(regID);

//if ("add".equals(formMode)) {
	// get the latest saved access form
	//haID = HAFormDB.getHALastestFormID(patNo);
//} if ("edit".equals(formMode)) {
	//haID = HAFormDB.getHAFormID(patNo, regID);
//}

if (HAFormDB.isNewHAForm(patNo, regID)) {
	newForm = true;
	haID = HAFormDB.getHALastestFormID(patNo);
} else {
	newForm = false;
	haID = HAFormDB.getHAFormID(patNo, regID);	
}

result = HAFormDB.fetchAccessForm(haID);
if(result.size() > 0) {
	row = (ReportableListObject) result.get(0);
	//regID = row.getValue(287);
	haID = row.getValue(1); 
	formType = row.getValue(3);
	q1 =  row.getValue(4);
	q2_1 = row.getValue(5);
	q2_2 = row.getValue(6);
	q2_3 = row.getValue(7);
	q2_4 = row.getValue(8);
	q2_5 = row.getValue(9);
	q2_6 = row.getValue(10);
	//
	q2_7 = row.getValue(300);
	q2_8 = row.getValue(301);
	//
	q3_a1 = row.getValue(11);
	q3_a2 = row.getValue(12);
	q3_a3 = row.getValue(13);
	q3_a4 = row.getValue(14);
	q3_b1 = row.getValue(15);
	q3_b2 = row.getValue(16);
	q3_b3 = row.getValue(17);
	q3_c1 = row.getValue(18);
	q3_c2 = row.getValue(19);
	q3_d1 = row.getValue(20);
	q3_d2 = row.getValue(21);
	q3_d3 = row.getValue(22);
	q3_d4 = row.getValue(23);
	q3_e1 = row.getValue(24);
	q3_f1 = row.getValue(25);
	q3_f2 = row.getValue(26);
	q3_f3 = row.getValue(27);
	q3_f4 = row.getValue(28);
	q3_g1 = row.getValue(29);
	q3_g2 = row.getValue(30); 
	q3_g3 = row.getValue(31);
	q3_h1 = row.getValue(332);
	q4_1 = row.getValue(32); 
	q4_2 = row.getValue(33);
	q5_a1 = row.getValue(34);
	q5_a2 = row.getValue(35);
	q5_a3 = row.getValue(36);
	q5_a4 = row.getValue(37);
	q5_a5 = row.getValue(38);
	q5_a6 = row.getValue(39);
	q5_b1 = row.getValue(40);
	q6_a1 = row.getValue(41);
	q6_a2 = row.getValue(42);
	q6_b1 = row.getValue(43);
	q6_b2 = row.getValue(44);
	q6_c1 = row.getValue(45);
	q6_c2 = row.getValue(46);
	smoke_1 = row.getValue(47);
	smoke_2 = row.getValue(48);
	smoke_3 = row.getValue(49);
	smoke_4 = row.getValue(50);
	smoke_5 = row.getValue(51);
	smoke_6 = row.getValue(52);
	drink_1 = row.getValue(53);
	drink_2 = row.getValue(54);
	drink_3 = row.getValue(55);
	drink_4 = row.getValue(56);
	drink_5 = row.getValue(57);
	drink_6 = row.getValue(58);
	drink_7 = row.getValue(59);
	drink_8 = row.getValue(60);
	drink_9 = row.getValue(61);
	drink_10 = row.getValue(62);
	drink_11 = row.getValue(63);
	drink_12 = row.getValue(64);
	drink_13 = row.getValue(65);
	drink_14 = row.getValue(66);
	eat_1 = row.getValue(67);
	eat_2 = row.getValue(68);
	eat_3 = row.getValue(69);
	eat_4 = row.getValue(70);
	eat_5 = row.getValue(71);
	eat_6 = row.getValue(72);
	eat_7 = row.getValue(73);
	eat_8 = row.getValue(74);
	eat_9 = row.getValue(75);
	eat_10 = row.getValue(76);
	eat_11 = row.getValue(77);
	eat_12 = row.getValue(78);
	eat_13 = row.getValue(79);
	eat_14 = row.getValue(80);
	sleep_1 = row.getValue(81);
	sleep_2 = row.getValue(82);
	sport_1 = row.getValue(83);
	sport_2 = row.getValue(84);
	sport_3 = row.getValue(85);
	sport_4 = row.getValue(86);
	mood_1 = row.getValue(87);
	mood_2 = row.getValue(88);
	mood_3 = row.getValue(89);
	mood_4 = row.getValue(90);
	female_1 = row.getValue(91);
	female_2 = row.getValue(92);
	female_3 = row.getValue(93);
	female_4 = row.getValue(94);
	female_5 = row.getValue(95);
	female_6 = row.getValue(96);
	female_7 = row.getValue(97);
	female_8 = row.getValue(98);
	female_9 = row.getValue(99);	
	female_10 = row.getValue(100);
	phy_1 = row.getValue(101);  
	phy_2 = row.getValue(102);
	phy_3 = row.getValue(103);
	phy_4 = row.getValue(104);
	phy_5 = row.getValue(105);
	phy_6 = row.getValue(106);
	phy_7 = row.getValue(107);
	phy_8 = row.getValue(108);
	phy_9 = row.getValue(109);
	phy_10 = row.getValue(110);
	phy_11 = row.getValue(111);
	phy_12 = row.getValue(112);
	phy_13 = row.getValue(113);
	phy_14 = row.getValue(114);
	phy_15 = row.getValue(115);
	phy_16 = row.getValue(116);
	phy_17 = row.getValue(117);
	phy_18 = row.getValue(297);
	phy_19 = row.getValue(298);
	phy_20 = row.getValue(299);

	//
	q3_a5 = row.getValue(343);
	q3_a6 = row.getValue(344);
	q3_b4 = row.getValue(345);
	q3_b5 = row.getValue(346);
	q3_d5 = row.getValue(347);
	q3_d6 = row.getValue(348);
	q3_e2 = row.getValue(349);
	q3_e3 = row.getValue(350);
	q3_f5 = row.getValue(351);
	q3_f6 = row.getValue(352);
	q3_h2 = row.getValue(353);
	q3_i1 = row.getValue(354);
	q5_a7 = row.getValue(355);
	//
	female_11 = row.getValue(356);
	female_12 = row.getValue(357);
	//
	q3_d7 = row.getValue(358);
	q3_d8 = row.getValue(359);
	q3_d9 = row.getValue(360);
	q3_d10 = row.getValue(361);
	//	
	eat_15 = row.getValue(362);
	eat_16 = row.getValue(363);
	eat_17 = row.getValue(368);
	eat_18 = row.getValue(369);
	eat_19 = row.getValue(370);
	eat_20 = row.getValue(371);
	eat_21 = row.getValue(372);
	eat_22 = row.getValue(373);
	//
	modifyDate = row.getValue(365);
	modifyTime = row.getValue(366);
	modifyUser = row.getValue(367);
	
	if (!newForm) { // no need to refill medical note 
		gc_1 = row.getValue(118);	
		gc_2 = row.getValue(119);
		gc_3 = row.getValue(120);
		gc_4 = row.getValue(121);
		gc_5 = row.getValue(122);
		gc_6 = row.getValue(123);
		
		gc_7 = row.getValue(124);
		gc_8 = row.getValue(125);
		gc_9 = row.getValue(126);
		gc_10 = row.getValue(127);
		gc_11 = row.getValue(128);
		gc_12 = row.getValue(129);
		
		gc_13 = row.getValue(130);
		gc_14 = row.getValue(131);
		gc_15 = row.getValue(132);
	
		ent_p[1] = row.getValue(133);
		ent_p[2] = row.getValue(134);
		ent_p[3] = row.getValue(135);
		ent_p[4] = row.getValue(136);
		ent_p[5] = row.getValue(137);
		ent_p[6] = row.getValue(138);
		ent_p[7] = row.getValue(139);
		ent_p[8] = row.getValue(140);
		ent_p[9] = row.getValue(141);
		ent_p[10] = row.getValue(142);
		ent_p[11] = row.getValue(143);
		ent_p[12] = row.getValue(144);
		ent_p[13] = row.getValue(145);
		ent_p[14] = row.getValue(146);
		ent_p[15] = row.getValue(147);
		ent_p[16] = row.getValue(148);
		
		ent_p[17] = row.getValue(149);
		ent_p[18] = row.getValue(150);
		ent_p[19] = row.getValue(151);
		ent_p[20] = row.getValue(152);
		ent_p[21] = row.getValue(153);	
		
		ent_p[22] = row.getValue(154);
		ent_p[23] = row.getValue(155);
		ent_p[24] = row.getValue(156);
		ent_p[25] = row.getValue(157);
		ent_p[26] = row.getValue(158);
		ent_p[27] = row.getValue(159);
		ent_p[28] = row.getValue(160);
		ent_p[29] = row.getValue(161);
		ent_p[30] = row.getValue(162);
		ent_p[31] = row.getValue(163);
		ent_p[32] = row.getValue(164);
		ent_p[33] = row.getValue(165);
		ent_p[34] = row.getValue(166);
		
		ent_p[35] = row.getValue(167);
		ent_p[36] = row.getValue(168);
		ent_p[37] = row.getValue(169);
		ent_p[38] = row.getValue(170);
		ent_p[39] = row.getValue(171);
		ent_p[40] = row.getValue(172);
		ent_p[41] = row.getValue(173);
		ent_p[42] = row.getValue(174);
		ent_p[43] = row.getValue(175);
		ent_p[44] = row.getValue(176);
		ent_p[45] = row.getValue(177);
		
		ent_p[46] = row.getValue(302);
		ent_p[47] = row.getValue(303);
		ent_p[48] = row.getValue(304);
		ent_p[49] = row.getValue(305);
		ent_p[50] = row.getValue(306);
		ent_p[51] = row.getValue(307);
		
		ent_p[52] = row.getValue(314);
		ent_p[53] = row.getValue(315);
		ent_p[54] = row.getValue(316);
		ent_p[55] = row.getValue(317);
		
		ls_1 = row.getValue(178);
		ls_2 = row.getValue(179);
		ls_3 = row.getValue(180);
		ls_4 = row.getValue(181);
		ls_5 = row.getValue(182);
		ls_6 = row.getValue(183);
		
		bn_1 = row.getValue(184);
		bn_2 = row.getValue(185);
		bn_3 = row.getValue(186);
		bn_4 = row.getValue(187);
		bn_5 = row.getValue(188);
		bn_6 = row.getValue(189);
		bn_7 = row.getValue(190);
		bn_8 = row.getValue(191);
		bn_9 = row.getValue(192);
		bn_10 = row.getValue(193);
		bn_11 = row.getValue(194);
		bn_12 = row.getValue(195);
		bn_13 = row.getValue(196);
		bn_14 = row.getValue(197);
		bn_15 = row.getValue(198);
		bn_16 = row.getValue(199);
		
		rs_1 = row.getValue(200);
		rs_2 = row.getValue(201);
		rs_3 = row.getValue(202);
		rs_4 = row.getValue(203);
		rs_5 = row.getValue(204);
		rs_6 = row.getValue(205);
		rs_7 = row.getValue(206);
		rs_8 = row.getValue(207);
		rs_9 = row.getValue(208);
		rs_10 = row.getValue(209);
		
		rs_11 = row.getValue(308);
		rs_12 = row.getValue(309);
		rs_13 = row.getValue(310);
		rs_14 = row.getValue(311);
		rs_15 = row.getValue(312);
		rs_16 = row.getValue(313);
		
		
		cs_1 = row.getValue(210);
		cs_2 = row.getValue(211);
		cs_3 = row.getValue(212);
		cs_4 = row.getValue(213);
		cs_5 = row.getValue(214);
		cs_6 = row.getValue(215);
		cs_7 = row.getValue(216);
		cs_8 = row.getValue(217);
		
		ne_1 = row.getValue(218);
		ne_2 = row.getValue(219);
		ne_3 = row.getValue(220);
		ne_4 = row.getValue(221);
		ne_5 = row.getValue(222);
		ne_6 = row.getValue(223);
		ne_7 = row.getValue(224);
		ne_8 = row.getValue(225);
		ne_9 = row.getValue(226);
		ne_10 = row.getValue(227);
		ne_11 = row.getValue(228);
		ne_12 = row.getValue(229);
		ne_13 = row.getValue(230);
		ne_14 = row.getValue(231);
		ne_15 = row.getValue(232);
		ne_16 = row.getValue(233);
		ne_17 = row.getValue(234);
		ne_18 = row.getValue(235);
		ne_19 = row.getValue(236);
		ne_20 = row.getValue(237);
		
		s_1 = row.getValue(238);
		s_2 = row.getValue(239);
		s_3 = row.getValue(240);
		s_4 = row.getValue(241);
		
		a_p[0] = row.getValue(242);
		a_p[1] = row.getValue(243);
		a_p[2] = row.getValue(244);
		a_p[3] = row.getValue(245);
		a_p[4] = row.getValue(246);
		a_p[5] = row.getValue(247);
		a_p[6] = row.getValue(248);
		a_p[7] = row.getValue(249);
		a_p[8] = row.getValue(250);
		a_p[9] = row.getValue(251);
		a_p[10] = row.getValue(252);
		a_p[11] = row.getValue(253);
		a_p[12] = row.getValue(254);
		a_p[13] = row.getValue(255);
		a_p[14] = row.getValue(256);
		a_p[15] = row.getValue(257);
		a_p[16] = row.getValue(258);
		a_p[17] = row.getValue(259);
		a_p[18] = row.getValue(260);
		a_p[19] = row.getValue(261);
		a_p[20] = row.getValue(262);
		a_p[21] = row.getValue(263);
		a_p[22] = row.getValue(264);
		a_p[23] = row.getValue(265);
		a_p[24] = row.getValue(266);
		a_p[25] = row.getValue(267);
		a_p[26] = row.getValue(268);
		a_p[27] = row.getValue(269);
		a_p[28] = row.getValue(270);
		a_p[29] = row.getValue(271);
		a_p[30] = row.getValue(272);
		a_p[31] = row.getValue(273);
		
		a_p[32] = row.getValue(318);
		a_p[33] = row.getValue(319);
		a_p[34] = row.getValue(320);
		a_p[35] = row.getValue(321);
		a_p[36] = row.getValue(322);
		a_p[37] = row.getValue(323);
		a_p[38] = row.getValue(324);
		a_p[39] = row.getValue(325);
		
		a_p[40] = row.getValue(326);
		
		ex_1 = row.getValue(274);
		ex_2 = row.getValue(275);
		
		mn_p[0] = row.getValue(276);
		mn_p[1] = row.getValue(277);
		mn_p[2] = row.getValue(278);
		mn_p[3] = row.getValue(279);
		mn_p[4] = row.getValue(280);
		mn_p[5] = row.getValue(281);
		mn_p[6] = row.getValue(282);
		mn_p[7] = row.getValue(283);
		mn_p[8] = row.getValue(284);
		mn_p[9] = row.getValue(285);
		mn_p[10] = row.getValue(286);
		
		mn_p[11] = row.getValue(329);
		mn_p[12] = row.getValue(330);
		mn_p[13] = row.getValue(331);
		mn_p[14] = row.getValue(341);
		
		//q3_h1 = row.getValue(332);
		docCode = row.getValue(333);
		docName = HAFormDB.getRegDocName(regID);
		
		createDate = row.getValue(334);
		createTime = row.getValue(335);
		
		remark = row.getValue(327);	
	}
	
	if (newForm) {
		result = HAFormDB.getNurseNote(patNo, regID, seqNo);
		if(result.size() > 0) {
			row = (ReportableListObject) result.get(0);
			phy_1 = row.getValue(0);
			phy_2 = row.getValue(1);
			phy_3 = row.getValue(2);
			phy_4 = row.getValue(3);
			phy_6 = row.getValue(4);
			phy_7 = row.getValue(5); //wt
			phy_8 = row.getValue(6); //ht
			docCode = row.getValue(9); 
			docName = HAFormDB.getRegDocName(regID);
		} else {
			phy_1 = "";
			phy_2 = "";
			phy_3 = "";
			phy_4 = "";
			phy_6 = "";
			phy_7 = "";
			phy_8 = "";
			phy_5 = "";
			phy_9 = "";
			phy_10 = "";
			phy_11 = "";
			phy_12 = "";
			phy_13 = "";
			phy_14 = "";
			phy_15 = "";
			phy_16 = "";
			phy_17 = "";
			phy_18 = "";
			phy_19 = "";
			phy_20 = "";
		}
		q1 =  "Rountine Checking 一般身體檢查";
	} else {
		completed = row.getValue(328);
	}
	
} else {
	////////////////////////////////////////
	// brand new patient for first ha form
	////////////////////////////////////////
	// get nurse note info
	result = HAFormDB.getNurseNote(patNo, regID, seqNo);
	if(result.size() > 0) {
		row = (ReportableListObject) result.get(0);
		phy_1 = row.getValue(0);
		phy_2 = row.getValue(1);
		phy_3 = row.getValue(2);
		phy_4 = row.getValue(3);
		phy_6 = row.getValue(4);
		phy_7 = row.getValue(5); //wt
		phy_8 = row.getValue(6); //ht
		docCode = row.getValue(9);
		docName = HAFormDB.getRegDocName(regID);
	}
	q1 =  "Rountine Checking 一般身體檢查";
	phy_5 = "";
	phy_9 = "";
	phy_10 = "";
	phy_11 = "";
	phy_12 = "";
	phy_13 = "";
	phy_14 = "";
	phy_15 = "";
	phy_16 = "";
	phy_17 = "";
	phy_18 = "";
	phy_19 = "";
	phy_20 = "";
}

//init null value from database
for (int i=0;i<a_p.length;i++){	 
	if (a_p[i]==null ||"null".equals(a_p[i])){
    	a_p[i] = "";
	}	
}
for (int i=0;i<mn_p.length;i++){	 
	if (mn_p[i]==null ||"null".equals(mn_p[i])){
    	mn_p[i] = "";
	}	
}
for (int i=0;i<ent_p.length;i++){	 
	if (ent_p[i]==null ||"null".equals(ent_p[i])){
    	ent_p[i] = "";
	}	
}


if (language==null ||"".equals(language)){
 language="eng";
}

//if ("login".equals(command)) {
if (staffID != null && staffID.length() > 0) {
	loginAction = true;
}

if (loginAction) {
	if (haFormPatient.equals(staffID)) {
		patientMode = true;
		nurseMode = false;
	} else {
		patientMode = false;
		nurseMode = true;
		userBean = UserDB.getUserBean(request, staffID);		
	}	
}


isMRStaff = HAFormDB.isMRStaff(staffID);

System.out.println("nurseMode : " + nurseMode);
System.out.println("isMRStaff : " + isMRStaff);
System.out.println("staffID : " + staffID);
System.out.println("patNo : " + patNo);
System.out.println("regID : " + regID);
System.out.println("seqNo : " + seqNo);
System.out.println("newForm : " + newForm);
System.out.println("haid : " + haID);
//System.out.println("command : " + command);
//System.out.println("loginAction : " + loginAction);
//System.out.println("eat_7 : " + eat_7);
//System.out.println("eat_8 : " + eat_8);
//System.out.println("eat_8 : " + eat_9);

if(command != null && command.equals("save_form")) {
	formType = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "formType"));
	q1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q1"));
	q2_1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q2_1"));
	q2_2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q2_2"));
	q2_3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q2_3"));
	q2_4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q2_4"));
	q2_5 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q2_5"));
	q2_6 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q2_6"));
	q2_7 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q2_7"));
	q2_8 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q2_8"));
	q3_a1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_a1"));
	q3_a2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_a2"));
	q3_a3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_a3"));
	q3_a4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_a4"));
	q3_b1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_b1"));
	q3_b2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_b2"));
	q3_b3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_b3"));
	q3_c1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_c1"));
	q3_c2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_c2"));
	q3_d1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_d1"));
	q3_d2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_d2"));
	q3_d3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_d3"));
	q3_d4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_d4"));
	q3_e1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_e1"));
	q3_f1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_f1"));
	q3_f2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_f2"));
	q3_f3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_f3"));
	q3_f4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_f4"));
	q3_g1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_g1"));
	q3_g2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_g2"));
	q3_g3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_g3"));	
	q3_h1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_h1"));
	q4_1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q4_1"));
	q4_2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q4_2"));
	q5_a1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q5_a1"));
	q5_a2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q5_a2"));
	q5_a3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q5_a3"));
	q5_a4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q5_a4"));
	q5_a5 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q5_a5"));
	q5_a6 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q5_a6"));
	q5_b1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q5_b1"));
	q6_a1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q6_a1"));
	q6_a2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q6_a2"));
	q6_b1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q6_b1"));
	q6_b2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q6_b2"));
	q6_c1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q6_c1"));
	q6_c2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q6_c2"));
	smoke_1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "smoke_1"));
	smoke_2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "smoke_2"));
	smoke_3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "smoke_3"));
	smoke_4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "smoke_4"));
	smoke_5 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "smoke_5"));
	smoke_6 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "smoke_6"));
	drink_1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "drink_1"));
	drink_2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "drink_2"));
	drink_3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "drink_3"));
	drink_4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "drink_4"));
	drink_5 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "drink_5"));
	drink_6 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "drink_6"));
	drink_7 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "drink_7"));
	drink_8 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "drink_8"));
	drink_9 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "drink_9"));
	drink_10 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "drink_10"));
	drink_11 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "drink_11"));
	drink_12 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "drink_12"));
	drink_13 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "drink_13"));
	drink_14 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "drink_14"));
	eat_1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_1"));
	eat_2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_2"));
	eat_3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_3"));
	eat_4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_4"));
	eat_5 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_5"));
	eat_6 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_6"));
	eat_7 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_7"));
	eat_8 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_8"));
	eat_9 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_9"));
	eat_10 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_10"));
	eat_11 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_11"));
	eat_12 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_12"));
	eat_13 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_13"));
	eat_14 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_14"));
	sleep_1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "sleep_1"));
	sleep_2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "sleep_2"));
	sport_1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "sport_1"));
	sport_2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "sport_2"));
	sport_3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "sport_3"));
	sport_4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "sport_4"));
	mood_1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mood_1"));
	mood_2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mood_2"));
	mood_3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mood_3"));
	mood_4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mood_4"));
	female_1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "female_1"));
	female_2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "female_2"));
	female_3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "female_3"));
	female_4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "female_4"));
	female_5 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "female_5"));
	female_6 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "female_6"));
	female_7 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "female_7"));
	female_8 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "female_8"));
	female_9 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "female_9"));	
	female_10 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "female_10"));
	phy_1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "phy_1"));
	phy_2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "phy_2"));
	phy_3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "phy_3"));
	phy_4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "phy_4"));
	phy_5 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "phy_5"));
	phy_6 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "phy_6"));
	phy_7 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "phy_7"));
	phy_8 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "phy_8"));
	phy_9 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "phy_9"));
	phy_10 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "phy_10"));
	phy_11 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "phy_11"));
	phy_12 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "phy_12"));
	phy_13 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "phy_13"));
	phy_14 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "phy_14"));
	phy_15 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "phy_15"));
	phy_16 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "phy_16"));
	phy_17 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "phy_17"));
	phy_18 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "phy_18"));
	phy_19 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "phy_19"));
	phy_20 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "phy_20"));
	
	
	gc_1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "gc_1"));
	gc_2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "gc_2"));
	gc_3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "gc_3"));
	gc_4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "gc_4"));
	gc_5 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "gc_5"));
	gc_6 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "gc_6"));	
	
	gc_7 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "gc_7"));
	gc_8 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "gc_8"));
	gc_9 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "gc_9"));
	gc_10 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "gc_10"));
	gc_11 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "gc_11"));
	
	gc_12 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "gc_12"));	
	gc_13 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "gc_13"));
	gc_14 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "gc_14"));
	gc_15 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "gc_15"));
	
	ent_p[1] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_1"));
	ent_p[2] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_2"));
	ent_p[3] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_3"));
	ent_p[4] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_4"));
	ent_p[5] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_5"));
	ent_p[6] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_6"));
	ent_p[7] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_7"));
	ent_p[8] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_8"));
	ent_p[9] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_9"));
	ent_p[10] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_10"));
	ent_p[11] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_11"));
	ent_p[12] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_12"));
	ent_p[13] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_13"));
	ent_p[14] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_14"));
	ent_p[15] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_15"));
	ent_p[16] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_16"));
	ent_p[17] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_17"));
	ent_p[18] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_18"));
	ent_p[19] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_19"));
	ent_p[20] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_20"));
	ent_p[21] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_21"));
	
	ent_p[21] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_21"));
	ent_p[22] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_22"));
	ent_p[23] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_23"));
	ent_p[24] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_24"));
	ent_p[25] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_25"));
	ent_p[26] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_26"));
	ent_p[27] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_27"));
	ent_p[28] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_28"));
	ent_p[29] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_29"));
	ent_p[30] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_30"));
	ent_p[31] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_31"));
	ent_p[32] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_32"));
	ent_p[33] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_33"));
	ent_p[34] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_34"));
	
	ent_p[35] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_35"));
	ent_p[36] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_36"));
	ent_p[37] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_37"));
	ent_p[38] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_38"));
	ent_p[39] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_39"));
	ent_p[40] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_40"));
	ent_p[41] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_41"));
	ent_p[42] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_42"));
	ent_p[43] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_43"));
	ent_p[44] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_44"));
	ent_p[45] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_45"));
	
	ent_p[46] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_46"));
	ent_p[47] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_47"));
	ent_p[48] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_48"));
	ent_p[49] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_49"));
	ent_p[50] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_50"));
	ent_p[51] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_51"));
	
	ent_p[52] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_52"));
	ent_p[53] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_53"));
	ent_p[54] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_54"));
	ent_p[55] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_55"));
	
	ls_1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ls_1"));
	ls_2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ls_2"));
	ls_3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ls_3"));
	ls_4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ls_4"));
	ls_5 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ls_5"));
	ls_6 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ls_6"));
	
	bn_1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "bn_1"));
	bn_2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "bn_2"));
	bn_3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "bn_3"));
	bn_4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "bn_4"));
	bn_5 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "bn_5"));
	bn_6 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "bn_6"));
	bn_7 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "bn_7"));
	bn_8 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "bn_8"));
	bn_9 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "bn_9"));
	bn_10 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "bn_10"));
	bn_11 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "bn_11"));
	bn_12 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "bn_12"));
	bn_13 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "bn_13"));
	bn_14 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "bn_14"));
	bn_15 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "bn_15"));
	bn_16 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "bn_16"));
	
	rs_1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "rs_1"));
	rs_2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "rs_2"));
	rs_3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "rs_3"));
	rs_4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "rs_4"));
	rs_5 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "rs_5"));
	rs_6 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "rs_6"));
	rs_7 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "rs_7"));
	rs_8 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "rs_8"));
	rs_9 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "rs_9"));
	rs_10 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "rs_10"));
	
	rs_11 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "rs_11"));
	rs_12 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "rs_12"));
	rs_13 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "rs_13"));
	rs_14 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "rs_14"));
	rs_15 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "rs_15"));
	rs_16 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "rs_16"));
	
	cs_1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "cs_1"));
	cs_2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "cs_2"));
	cs_3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "cs_3"));
	cs_4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "cs_4"));
	cs_5 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "cs_5"));
	cs_6 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "cs_6"));
	cs_7 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "cs_7"));
	cs_8 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "cs_8"));
	
	ne_1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_1"));
	ne_2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_2"));
	ne_3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_3"));
	ne_4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_4"));
	ne_5 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_5"));
	ne_6 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_6"));
	ne_7 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_7"));
	ne_8 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_8"));
	ne_9 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_9"));
	ne_10 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_10"));
	ne_11 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_11"));
	ne_12 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_12"));
	ne_13 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_13"));
	ne_14 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_14"));
	ne_15 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_15"));
	ne_16 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_16"));
	ne_17 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_17"));
	ne_18 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_18"));
	ne_19 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_19"));
	ne_20 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_20"));
	
	s_1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "s_1"));
	s_2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "s_2"));
	s_3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "s_3"));
	s_4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "s_4"));
	
	a_p[0] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p0"));
	a_p[1] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p1"));
	a_p[2] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p2"));
	a_p[3] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p3"));
	a_p[4] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p4"));
	a_p[5] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p5"));
	a_p[6] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p6"));
	a_p[7] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p7"));
	a_p[8] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p8"));
	a_p[9] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p9"));
	a_p[10] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p10"));
	a_p[11] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p11"));
	a_p[12] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p12"));
	a_p[13] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p13"));
	a_p[14] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p14"));
	a_p[15] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p15"));
	a_p[16] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p16"));
	a_p[17] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p17"));
	a_p[18] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p18"));
	a_p[19] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p19"));
	a_p[20] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p20"));
	a_p[21] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p21"));	
	a_p[22] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p22"));
	a_p[23] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p23"));
	a_p[24] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p24"));
	a_p[25] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p25"));
	a_p[26] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p26"));
	a_p[27] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p27"));
	a_p[28] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p28"));
	a_p[29] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p29"));
	a_p[30] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p30"));
	a_p[31] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p31"));
	
	a_p[32] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p32"));
	a_p[33] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p33"));
	a_p[34] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p34"));
	a_p[35] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p35"));
	a_p[36] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p36"));
	a_p[37] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p37"));
	a_p[38] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p38"));
	a_p[39] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p39"));
	
	a_p[40] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p40"));
	
	ex_1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ex_1"));
	ex_2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ex_2"));

	mn_p[0] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p0"));
	mn_p[1] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p1"));
	mn_p[2] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p2"));
	mn_p[3] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p3"));
	mn_p[4] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p4"));
	
	//if (nurseMode) {
//		mn_p[5] = xrayOthers;
		//mn_p[8] = ultrasoundOthers;
		//mn_p[13] = otherOthers;
	//} else {
		mn_p[5] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p5"));
		mn_p[8] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p8"));
		mn_p[13] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p13"));
	//}
	
	
	mn_p[6] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p6"));
	mn_p[7] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p7"));
	
	
	mn_p[9] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p9"));
	mn_p[10] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p10"));
	mn_p[11] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p11"));
	mn_p[12] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p12"));
	
	mn_p[14] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p14"));
	
	remark = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "remark"));
	completed = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "completed"));
	
	//
	q3_a5 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_a5"));
	q3_a6 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_a6"));
	q3_b4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_b4"));
	q3_b5 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_b5"));
	q3_d5 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_d5"));
	q3_d6 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_d6"));
	q3_e2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_e2"));
	q3_e3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_e3"));
	q3_f5 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_f5"));
	q3_f6 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_f6"));
	q3_h2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_h2"));
	q3_i1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_i1"));
	q5_a7 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q5_a7"));
	//
	female_11 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "female_11"));
	female_12 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "female_12"));
	//
	q3_d7 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_d7"));
	q3_d8 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_d8"));
	q3_d9 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_d9"));
	q3_d10 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_d10"));
	
	eat_15 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_15"));
	eat_16 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_16"));
	eat_17 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_17"));
	eat_18 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_18"));
	eat_19 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_19"));
	eat_20 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_20"));
	eat_21 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_21"));
	eat_22 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_22"));
	
	SaveFormAction = true;

}
else if(command != null && command.equals("complete_form")) {	
	 
	completeFormAction = true;

} else {
	command = "view"; 
	SaveFormAction = false;
}

if(command != null) {
	if (SaveFormAction) { // save the form
			HAFormDB.saveHAForm(userBean, staffID,  regID, patNo, formType, q1, 
					q2_1, q2_2, q2_3, q2_4, q2_5, q2_6, q2_7, q2_8,
					q3_a1, q3_a2, q3_a3, q3_a4,
					q3_b1, q3_b2, q3_b3, q3_c1, q3_c2,
					q3_d1, q3_d2, q3_d3, q3_d4, q3_e1,
					q3_f1, q3_f2, q3_f3, q3_f4,
					q3_g1, q3_g2, q3_g3, q3_h1, q4_1, q4_2,
					q5_a1, q5_a2, q5_a3, q5_a4, q5_a5,
					q5_a6, q5_b1,
					q6_a1, q6_a2, q6_b1, q6_b2, q6_c1, q6_c2,
					smoke_1, smoke_2, smoke_3, smoke_4, smoke_5, smoke_6,
					drink_1, drink_2, drink_3, drink_4, drink_5,   
					drink_6, drink_7, drink_8, drink_9, drink_10,
					drink_11, drink_12, drink_13, drink_14,
					eat_1, eat_2, eat_3, eat_4,
					eat_5, eat_6, eat_7, eat_8, eat_9,
					eat_10, eat_11, eat_12, eat_13, eat_14,
					sleep_1, sleep_2,
					sport_1, sport_2, sport_3, sport_4,
					mood_1, mood_2, mood_3, mood_4,
					female_1, female_2, female_3, female_4, female_5,
					female_6, female_7, female_8, female_9, female_10,
					phy_1, phy_2, phy_3, phy_4, phy_5,
					phy_6, phy_7, phy_8, phy_9, phy_10,
					phy_11, phy_12, phy_13, phy_14, phy_15,
					phy_16, phy_17, phy_18, phy_19, phy_20,
					gc_1, gc_2, gc_3, gc_4, gc_5, gc_6, 
					gc_7, gc_8, gc_9, gc_10, gc_11, 
					gc_12, gc_13, gc_14, gc_15,
					ent_p,
					ls_1, ls_2, ls_3, ls_4, ls_5, ls_6,
					bn_1, bn_2, bn_3, bn_4, bn_5,
					bn_6, bn_7, bn_8, bn_9, bn_10,
					bn_11, bn_12, bn_13, bn_14, bn_15,
					bn_16,
					rs_1, rs_2, rs_3, rs_4, rs_5,
					rs_6, rs_7, rs_8, rs_9, rs_10,
					rs_11, rs_12, rs_13, rs_14, rs_15, rs_16,
					cs_1, cs_2, cs_3, cs_4, cs_5, 
					cs_6, cs_7, cs_8,
					ne_1, ne_2, ne_3, ne_4, ne_5, 
					ne_6, ne_7, ne_8, ne_9, ne_10,
					ne_11, ne_12, ne_13, ne_14, ne_15,
					ne_16, ne_17, ne_18, ne_19, ne_20,
					s_1, s_2, s_3, s_4, 
					// array
					a_p, ex_1, ex_2, mn_p, remark, completed, docCode,
					q3_a5, q3_a6, q3_b4, q3_b5,
					q3_d5, q3_d6, q3_e2, q3_e3,
					q3_f5, q3_f6, q3_h2, q3_i1,
					q5_a7, female_11, female_12,
					q3_d7, q3_d8, q3_d9, q3_d10,
					eat_15, eat_16, eat_17, eat_18, eat_19, eat_20,
					eat_21, eat_22,
					seqNo
				);
		SaveFormAction = false;
		finishSaving = true;
		//command = "view";
		//response.sendRedirect("health_assess_form.jsp?command=view&staffID=" + staffID + "&patNo=" + patNo + "&regID=" + regID);
	} else if (completeFormAction) { // Complete the form
		HAFormDB.completeHAForm(haID, completed);
	
		completeFormAction = false;
		//command = "view";
		response.sendRedirect("health_assess_form.jsp?command=view&staffID=" + staffID + "&patNo=" + patNo + "&regID=" + regID);
	}

	if (!"view".equals(command)) {
		command = "view";
		//response.sendRedirect("health_assess_form.jsp?command=view&staffID=" + staffID + "&patNo=" + patNo + "&regID=" + regID);
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
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
	<jsp:param name="title" value="Hong Kong Adventist Hospital" />
</jsp:include>
<link rel="stylesheet" type="text/css" href="<html:rewrite page="/css/registration/background.css" />" />
<head>
	<style>
		.hightLight {
				background-color:yellow !important;
		}
		.career_form table.table1 {			
			border: 1px solid #ddd;
		}
		.career_form table.table2 {			
			border: 1px solid #ddd;
		}
		td {
	    		padding: 5px; 
		}			
		
		
	</style>
</head>
<body>
<DIV id=wrapper class="wrapper" style="background-color:white;">
<DIV  style="background-color:white;">
<%--
<div class="header_top_row">
<div class="normal_area">
<table style="width:100%">
<tr>
	<td><a href="http://www.twah.org.hk/en/main" id="logo"></a></td>
	<td style="padding: 30px;" class="header_title_only">Health Assessment Form</td>
</tr>
</table>   
</div>                 
</div>
 --%>
<br/>
<div class="normal_area">
<div class="career_form" style="padding: 20px 18px;">
<form name="form1" action="health_assess_form.jsp" method="post">
<table class="table1" style="width: 100%">
	<tr>
		<td style="background: #B404AE; color: white"><font size="3"><b>身體檢查評估表 Health Assessment Form</b></font></td>
		<td>
		<table>
			<tr>
			<td>檢查日期 Date of Screening:<%if (newForm) {%><%=DateTimeUtil.getCurrentDate()%><% } else {%><%=createDate%><%} %></td>
			<td>填表時間 Time:<%if (newForm) {%><%=DateTimeUtil.getCurrentTime()%><% } else {%><%=createTime%><%} %></td>
			<td>身體檢查類別 Types of Physical Exam:
	<%		 
			 if ("0".equals(completed)) {
	%>
				<select name="formType">
					<option value="Standard PE"<%=(formType!=null && "Standard PE".equals(formType))?"selected":"" %>>Standard PE</option>									
					<option value="Prestige PE"<%=(formType!=null && "Prestige PE".equals(formType))?"selected":"" %>>Prestige PE</option>
					<option value="Premier PE"<%=(formType!=null && "Premier PE".equals(formType))?"selected":"" %>>Premier PE</option>
				</select>
	<%
			 } else {
	%>
				<%=formType%>
	<%
			 }
	%>
			</td>
			</tr>
			<tr>
			<td>更改日期 Modify Date:<%if (newForm) {%><%=DateTimeUtil.getCurrentDate()%><% } else {%><%=modifyDate%><%} %></td>
			<td>更改時間 ModifyTime:<%if (newForm) {%><%=DateTimeUtil.getCurrentTime()%><% } else {%><%=modifyTime%><%} %></td>
			<td>更改員工 Modify Staff:<%if (newForm) {%><%=""%><% } else {%><%=modifyUser%><%} %></td>
			</tr>
		</table>
		</td>
	</tr>
</table>	
<table class="table2" width="100%">
	<tr>
	<td> 
		<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td style="background: #F5A9F2;">			
			病人資料 Patient Info
			</td>
		</tr>
		<tr>
		<td>
		<table class="table2">
		<tr>
		
			<td>
				<table>
				<tr>
					<td>姓名 Name&nbsp;<input type="text" name="patName" value="<%=patName%>" readonly size=40></input></td>
					<td>中文姓名 Chinese Name&nbsp;<input type="text" name="patCName" value="<%=patCName%>" readonly size=10></input></td>
					<td>年齡 Age&nbsp;<input type="text" name="patAge" value="<%=patAge%>" readonly size=8></input></td>
					<td>性別 Sex&nbsp;<input type="text" name="patSex" value="<%=patSex%>" readonly size=1></input></td>
					<td>出生日期 DOB&nbsp;<input type="text" name="patDob" value="<%=patDob%>" readonly size=7></input></td>	
				</tr>
				</table>
			</td>
			</tr>
			<tr>
			<td>
				<table>
				<tr>
					<td>登記號碼 Hospital No&nbsp;<input type="text" name="patno" value="<%=patNo%>" readonly size=5></input></td>
<%
		if (("CCRP1".equals(formType)) || ("CCR".equals(formType))){
%>
					<td>檔案編號 Case No&nbsp;<input type="text" name="patConNo" value="<%=patConNo%>" readonly size=5></input></td>
<%
		} else {
%>
					<td>房號 Consultation No&nbsp;<input type="text" name="patConNo" value="<%=patConNo%>" readonly size=5></input></td>
<%
		} 
%>
					<%-- TEMP --%>
					<td><input type="hidden" name="docCode" value="<%=docCode%>" readonly size=5></input></td>
				</tr>
				</table>
			</td>
		</tr>
		</table>
		</td>
		</tr>
		</table>
	</td>
	</tr>
		 
	<tr>	
	<td>
		<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td style="background: #D8D8D8;">			
			<b>身體檢查 Physical Examination  (由職員填寫Staff only)</b>
			</td>			
		</tr>
		<tr>
			<td>
			<table class="table2">
			<tr>			
			<td>
				<table>
					<tr>
						<td>Temp 體溫(°C): <input type="text" name="phy_1" value="<%=phy_1%>" size=1 /></td>
						<td>BP 血壓(mmHg): <input type="text" name="phy_2" value="<%=phy_2%>" size=1 /> / <input type="text" name="phy_3" value="<%=phy_3%>" size=1 /></td>
						<td align="right">Pulse 脈搏(bpm): <input type="text" name="phy_4" value="<%=phy_4%>" size=1 /></td>
						<td align="right">Resp 呼吸(/min): <input type="text" name="phy_5" value="<%=phy_5%>" size=1 /></td>
						<td>Room Air SpO2 血氣(%): <input type="text" name="phy_6" value="<%=phy_6%>" size=1 /></td>
					</tr>
					<tr>
						<td>Weight 體重(kg): <input type="text" name="phy_7" value="<%=phy_7%>" size=1 /></td>
						<td>Height 身高(cm): <input type="text" name="phy_8" value="<%=phy_8%>" size=1 /></td>
						<td align="right">BMI 體格指數: <input type="text" name="phy_9" value="<%=phy_9%>" size=1 /></td>
						<td>Ideal Weight 理想體重(kg): <input type="text" name="phy_10" value="<%=phy_10%>" size=1 /></td>
						<td align="right">Waist Girth 腰圍(cm): <input type="text" name="phy_11" value="<%=phy_11%>" size=1 /></td>
					</tr>
				</table>
				
				<table>
						<tr>
							<td>Vision Acuity 視力</td>
							<td>L 左: <input type="text" name="phy_18" value="<%=phy_18%>" size=10 /></td>								
							<td>R 右: <input type="text" name="phy_19" value="<%=phy_19%>" size=10 /></td>
							<td><input type="radio" name="phy_20" value="0" <%if ("0".equals(phy_20) || "".equals(phy_20)) {%>checked<%} %>>&nbsp;Unaided 無需配帶眼鏡</td>
							<td><input type="radio" name="phy_20" value="1" <%if ("1".equals(phy_20)) {%>checked<%} %>>&nbsp;Aided 需配帶眼鏡</td>
						</tr>								
				</table>
					
			</td>
			</tr>
			<tr>
			<td>
				<table class="table2">
				<tr>			
				<td>
						<table>
							<tr>
							<td>
							Other Information 其他:
							</td>
								<td>Travel History 旅遊記錄:</td>
								<td><input type="radio" name="phy_12" value="0" <%if ("0".equals(phy_12) || "".equals(phy_12)) {%>checked<%} %>>&nbsp;No</td>
								<td><input type="radio" name="phy_12" value="1" <%if ("1".equals(phy_12)) {%>checked<%} %>>&nbsp;Yes</td>	
								<td><input type="text" name="phy_13" value="<%=phy_13 %>" size=20/></td>
								<td>&nbsp;&nbsp;&nbsp;&nbsp;HA:</td>
								<td><input type="radio" name="phy_14" value="0" <%if ("0".equals(phy_14) || "".equals(phy_14)) {%>checked<%} %>>&nbsp;No</td>
								<td><input type="radio" name="phy_14" value="1" <%if ("1".equals(phy_14)) {%>checked<%} %>>&nbsp;Yes</td>	
								<td><input type="text" name="phy_15" value="<%=phy_15 %>" size=20/></td>
							</tr>
							<tr>
							<td>
							</td>
								<td>Flu symptoms 流感症状:</td>
								<td><input type="radio" name="phy_16" value="0" <%if ("0".equals(phy_16) || "".equals(phy_16)) {%>checked<%} %>>&nbsp;No</td>
								<td><input type="radio" name="phy_16" value="1" <%if ("1".equals(phy_16)) {%>checked<%} %>>&nbsp;Yes</td>	
								<td><input type="text" name="phy_17" value="<%=phy_17 %>" size=20/></td>
							</tr>	
							</table>
							
							
					</td>
					</tr>
					</table>
			</td>
			</tr>
			
				<tr>	
				<td> 
					<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td style="background: #D8D8D8;">		
						<b>主要申訴 Present Chief Complaints (If any):</b>
						</td>
					</tr>
					<tr>
						<td><textarea name="q1" rows="2" cols="150"><%=q1%></textarea></td>
					</tr>
					</table>
				</td>
				</tr>
			
			
			
			</table>					
			</td>
		</tr>			
		</table>
	</td>
	</tr>

<%--  --%>

<tr>	
	<td> 
		<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td style="background: #F5A9F2;">			
			(1) 家族歷史 Family History:
			</td>
		</tr>
		<tr>
		<td>
				<table class="table2">
				<tr>
					<td><input type="checkbox" name="q2_1" value="1" <%if ("1".equals(q2_1)) {%>checked<%} %>/>&nbsp;沒有 No&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td><input type="checkbox" name="q2_2" value="1" <%if ("1".equals(q2_2)) {%>checked<%} %>/>&nbsp;中風 Stroke&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td><input type="checkbox" name="q2_3" value="1" <%if ("1".equals(q2_3)) {%>checked<%} %>/>&nbsp;高血壓 Hypertension&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td><input type="checkbox" name="q2_4" value="1" <%if ("1".equals(q2_4)) {%>checked<%} %>/>&nbsp;糖尿病 Diabetes Mellitus&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td><input type="checkbox" name="q2_5" value="1" <%if ("1".equals(q2_5)) {%>checked<%} %>/>&nbsp;癌症 Cancers&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td><input type="checkbox" name="q2_6" value="1" <%if ("1".equals(q2_6)) {%>checked<%} %>/>&nbsp;心臟病 Heart Diseases&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td><input type="checkbox" name="q2_7" value="1" <%if ("1".equals(q2_7)) {%>checked<%} %>/>&nbsp;其他 Others&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="q2_8" value="<%=q2_8%>" size=25/></td>					
					<td></td>
					<%--

					 --%>
				</tr>
				</table>
		</td>		
		</tr>
		</table>
	</td>
	</tr>
		
<%--  --%>		
	<tr>
	<td> 
		<table style="background-color:white;" width="100%">
		<tr>
			<td style="background: #F5A9F2">
			(2) 過往病歷 Past Medical History:
			</td>
		</tr>
		<tr>
		<td>
			<table class="table2">
			<tr>
			<td>
			<table>
			<tr>
			<td>
			<table>
				<tr>
				<td>A 心臟血管疾病 Cardiovascular diseases:&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q3_a5" value="1" <%if ("1".equals(q3_a5)) {%>checked<%} %>/>&nbsp;沒有 No &nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q3_a1" value="1" <%if ("1".equals(q3_a1)) {%>checked<%} %>/>&nbsp;高血壓 High Blood Pressure &nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q3_a2" value="1" <%if ("1".equals(q3_a2)) {%>checked<%} %>/>&nbsp;心絞痛 Angina &nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q3_a3" value="1" <%if ("1".equals(q3_a3)) {%>checked<%} %>/>&nbsp;中風 Stroke &nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q3_a4" value="1" <%if ("1".equals(q3_a4)) {%>checked<%} %>/>&nbsp;心臟病 Heart Diseases &nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>其他 Others:&nbsp;<input type="text" name="q3_a6" value="<%=q3_a6%>" size=20/></td>
				</tr>
			</table>
			</td>			
			</tr>
			<tr>
			<td>
				<table>
				<tr>
				<td>B 內分泌症 Endocrine diseases:&nbsp;&nbsp;&nbsp;&nbsp;</td>			
				<td><input type="checkbox" name="q3_b4" value="1" <%if ("1".equals(q3_b4)) {%>checked<%} %>/>&nbsp;沒有 No &nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q3_b1" value="1" <%if ("1".equals(q3_b1)) {%>checked<%} %>/>&nbsp;糖尿病 Diabetes Mellitus&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q3_b2" value="1" <%if ("1".equals(q3_b2)) {%>checked<%} %>/>&nbsp;腎病 Kidney Disease&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q3_b3" value="1" <%if ("1".equals(q3_b3)) {%>checked<%} %>/>&nbsp;甲狀腺病 Thyroid Disease&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>其他 Others:&nbsp;<input type="text" name="q3_b5" value="<%=q3_b5%>" size=20/></td>
				</tr>
				</table>
			</td>
			</tr>
			<tr>
			<td>
				<table>
				<tr>
				<td>C 癌症 Cancer:&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="radio" name="q3_c1" value="0" <%if ("0".equals(q3_c1) || "".equals(q3_c1)) {%>checked<%} %>>&nbsp;沒有 No</td>
				<td><input type="radio" name="q3_c1" value="1" <%if ("1".equals(q3_c1)) {%>checked<%} %>>&nbsp;有 Yes</td>
				<td>種類 Type:&nbsp;</td>
				<td><input type="text" name="q3_c2" value="<%=q3_c2%>" size=40/></td>
				</tr>
				</table>
			</td>
			</tr>
			<tr>
			<td>
				<table>
				<tr>
				<td>D 呼吸系統疾病 Respiratory diseases:&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q3_d5" value="1" <%if ("1".equals(q3_d5)) {%>checked<%} %>/>&nbsp;沒有 No &nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q3_d1" value="1" <%if ("1".equals(q3_d1)) {%>checked<%} %>/>&nbsp;哮喘 Asthma&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q3_d2" value="1" <%if ("1".equals(q3_d2)) {%>checked<%} %>/>&nbsp;支氣管炎 Bronchitis&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q3_d3" value="1" <%if ("1".equals(q3_d3)) {%>checked<%} %>/>&nbsp;肺結核 Tuberculosis&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q3_d4" value="1" <%if ("1".equals(q3_d4)) {%>checked<%} %>/>&nbsp;慢性阻塞性肺病 Chronic Obstructive Airway Disease&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>其他 Others:&nbsp;<input type="text" name="q3_d6" value="<%=q3_d6%>" size=20/></td>
				</tr>
				<tr>
				<td></td>
				<td><input type="checkbox" name="q3_d7" value="1" <%if ("1".equals(q3_d7)) {%>checked<%} %>/>&nbsp;矽肺 Silicosis&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q3_d8" value="1" <%if ("1".equals(q3_d8)) {%>checked<%} %>/>&nbsp;石綿肺症 Asbestosis&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q3_d9" value="1" <%if ("1".equals(q3_d9)) {%>checked<%} %>/>&nbsp;間皮瘤 Mesothelioma&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q3_d10" value="1" <%if ("1".equals(q3_d10)) {%>checked<%} %>/>&nbsp;肺塵埃沉着病 Pneumoconiosis&nbsp;&nbsp;&nbsp;&nbsp;</td>				
				</tr>
				</table>
			</td>
			</tr>
			<tr>
			<td>
				<table>
				<tr>
				<td>E 神經中樞系統病 Neurological diseases:&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q3_e2" value="1" <%if ("1".equals(q3_e2)) {%>checked<%} %>/>&nbsp;沒有 No &nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q3_e1" value="1" <%if ("1".equals(q3_e1)) {%>checked<%} %>/>&nbsp;癲癇病 Epilepsy&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>其他 Others:&nbsp;<input type="text" name="q3_e3" value="<%=q3_e3%>" size=20/></td>
				</tr>
				</table>
			</td>
			</tr>
			<tr>
			<td>
				<table>
				<tr>
				<td>F 痛症 Pain:&nbsp;&nbsp;&nbsp;&nbsp;</td>			
				<td><input type="checkbox" name="q3_f5" value="1" <%if ("1".equals(q3_f5)) {%>checked<%} %>/>&nbsp;沒有 No &nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q3_f1" value="1" <%if ("1".equals(q3_f1)) {%>checked<%} %>/>&nbsp;頸痛 Neck pain&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q3_f2" value="1" <%if ("1".equals(q3_f2)) {%>checked<%} %>/>&nbsp;腰脊痛 Low back pain&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q3_f3" value="1" <%if ("1".equals(q3_f3)) {%>checked<%} %>/>&nbsp;關節痛 Joint pain&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q3_f4" value="1" <%if ("1".equals(q3_f4)) {%>checked<%} %>/>&nbsp;胃痛 Stomach pain&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>其他 Others:&nbsp;<input type="text" name="q3_f6" value="<%=q3_f6%>" size=20/></td>
				</tr>
				</table>
			</td>
			</tr>
			<tr>
			<td>
				<table>
				<tr>
				<td>G 肝炎帶菌 Hepatitis:&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="radio" name="q3_g1" value="0" <%if ("0".equals(q3_g1) || "".equals(q3_c1)) {%>checked<%} %>>&nbsp;沒有 No</td>
				<td><input type="radio" name="q3_g1" value="1" <%if ("1".equals(q3_g1)) {%>checked<%} %>>&nbsp;有 Yes</td>
				<%--
				<td>型 type&nbsp;<input type="text" name="q3_g2" value="<%=q3_g2 %>" size=10/></td>
				 --%>
				<td>型 type&nbsp;
				<select name="q3_g2">
					<option value=""></option>
					<option value="0"<%=(q3_g2!=null && "0".equals(q3_g2))?"selected":"" %>>甲型 Type A</option>									
					<option value="1"<%=(q3_g2!=null && "1".equals(q3_g2))?"selected":"" %>>乙型 Type B</option>
					<option value="2"<%=(q3_g2!=null && "2".equals(q3_g2))?"selected":"" %>>丙型 Type C</option>
				</select>
				</td>
				<%--
				<td><input type="checkbox" name="q3_g3" value="1" <%if ("1".equals(q3_g3)) {%>checked<%} %>/>&nbsp;黃疸病 Jaundice&nbsp;&nbsp;&nbsp;&nbsp;</td>
				 --%>
				 <td><input type="hidden" name="q3_g3" value="1" <%if ("1".equals(q3_g3)) {%>checked<%} %>/></td>
				</tr>
				</table>
			</td>				
			</tr>
			
			<tr>
			<td>
			<table>
				<tr>
				<%--
				<td>H 其他 Others:&nbsp;&nbsp;&nbsp;&nbsp;</td>
				--%>							
				<td>H 其他病症 Others Illnesses:&nbsp;<input type="text" name="q3_h2" value="<%=q3_h2%>" size=90/></td>
				<td><input type="hidden" name="q3_h1" value="<%=q3_h1 %>" size=90/></td>
				</tr>
			</table>
			</td>
			</tr>
			
			<tr>
			<td>
			<table>
				<tr>
				<td>I 手術或其他治療 Previous Operation/Treatment :&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="text" name="q3_i1" value="<%=q3_i1 %>" size=90/></td>				
				</tr>
			</table>
			</td>
			</tr>
			
				
			</table>
			
			</td>
			</tr>
			</table>
		</td>			
		</tr>
		</table>
	</td>
	</tr>
	<tr>
	
	<td> 
		<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td style="background: #F5A9F2;">			
			(3) 過敏歷史 Allergy History:
			</td>
		</tr>
		<tr>
			<td>
			<table class="table2">
			<tr>
			<td>閣下對什麼食物/藥物有過敏反應 ? Any sensitive or allergic to food/drug?:&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td><input type="radio" name="q4_1" value="0" <%if ("0".equals(q4_1) || "".equals(q4_1)) {%>checked<%} %>>&nbsp;沒有 No</td>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td><input type="radio" name="q4_1" value="1" <%if ("1".equals(q4_1)) {%>checked<%} %>>&nbsp;有 Yes</td>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td>種類 Type:<input type="text" name="q4_2" value="<%=q4_2%>" size=50/></td>
			</tr>
			</table>			
			</td>
		</tr>
		</table>
	</td>
	</tr>
	<tr>
	
	<td> 
		<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td style="background: #F5A9F2;">			
			(4) 用藥記錄 Medication History (女性包括避孕藥物 Including contraceptives for females):
			</td>
		</tr>
		<tr>
			<td>
			<table class="table2">
			<tr>			
			<td>
				<table>
				<tr>
				<td>A</td>			
				<td>曾服用 Treated with:&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q5_a1" value="1" <%if ("1".equals(q5_a1)) {%>checked<%} %>/>&nbsp;沒有 No&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q5_a2" value="1" <%if ("1".equals(q5_a2)) {%>checked<%} %>/>&nbsp;抗凝血藥 Anticoagulants&nbsp;&nbsp;&nbsp;&nbsp;</td>			
				<td><input type="checkbox" name="q5_a3" value="1" <%if ("1".equals(q5_a3)) {%>checked<%} %>/>&nbsp;抗抑鬱藥 Antidepressants&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q5_a4" value="1" <%if ("1".equals(q5_a4)) {%>checked<%} %>/>&nbsp;類固醇 Steroid&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q5_a5" value="1" <%if ("1".equals(q5_a5)) {%>checked<%} %>/>&nbsp;鎮定劑 Tranquilizers&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="q5_a6" value="1" <%if ("1".equals(q5_a6)) {%>checked<%} %>/>&nbsp;中藥 Chinese Herbal Med&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;其他 Others&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="q5_a7" value="<%=q5_a7%>" size=25/></td>
				</tr>
				</table>
			</td>
			</tr>
			<tr>
						
			</tr>
			<tr>
			<td>
			<table>
			<tr>			
				<td>B</td>
				<td>現服藥物 Current Medications:</td>
				<td><input type="text" name="q5_b1" value="<%=q5_b1%>" size=100/></td>
				</tr>
			</table>
			</td>
			</tr>
			</table>
			</td>
		</tr>		
		</table>
	</td>
	</tr>
	
	<%-- 
	<tr>	
	<td> 
		<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td style="background: #F5A9F2;">			
			(6) 其他記錄 Other Information:
			</td>
		</tr>
		<tr>
			<td>
			<table class="table2">
			<tr>			
			<td>
				<table>
				<tr>							
				<td>A.	最近三個月內有外遊記錄Travel History in recent 3 months:&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="radio" name="q6_a1" value="0" <%if ("0".equals(q6_a1) || "".equals(q6_a1)) {%>checked<%} %>>&nbsp;沒有 No</td>
				<td><input type="radio" name="q6_a1" value="1" <%if ("1".equals(q6_a1)) {%>checked<%} %>>&nbsp;有 Yes</td>				
				<td><input type="text" name="q6_a2" value="<%=q6_a2 %>" size=60/></td>
				</tr>
				<tr>							
				<td>B.	最近兩個月曾經入住政府醫院HA Hospitalization History in recent 2 months:&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="radio" name="q6_b1" value="0" <%if ("0".equals(q6_b1) || "".equals(q6_b1)) {%>checked<%} %>>&nbsp;沒有 No</td>
				<td><input type="radio" name="q6_b1" value="1" <%if ("1".equals(q6_b1)) {%>checked<%} %>>&nbsp;有 Yes</td>				
				<td><input type="text" name="q6_b2" value="<%=q6_b2 %>" size=60/></td>
				</tr>
				<tr>							
				<td>C.	最近出現過流行性感冒徵狀記錄Recent influenza symptoms:&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="radio" name="q6_c1" value="0" <%if ("0".equals(q6_c1) || "".equals(q6_c1)) {%>checked<%} %>>&nbsp;沒有 No</td>
				<td><input type="radio" name="q6_c1" value="1" <%if ("1".equals(q6_c1)) {%>checked<%} %>>&nbsp;有 Yes</td>
				<td><input type="text" name="q6_c2" value="<%=q6_c2 %>" size=60/></td>
				</tr>
				</table>
			</td>
			</tr>
			</table>
			</td>
		</tr>		
	</table>
	</td>
	</tr>
	--%>
	
	<%--  start here 	--%>

	
	
	<%--  end here 	--%>
	<tr>
	<td><font size="3"><b>生活習慣評估 Lifestyle Assessment</b></font></td>
	</tr>
	<tr>
		
	<td> 
		<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td style="background: #F5A9F2;">			
			吸煙習慣 Smoking Status
			</td>
		</tr>
		<tr>
			<td>
			<table class="table2">
			<tr>			
			<td>
				<table>
				<tr>
				<td><input type="radio" name="smoke_1" value="0" <%if ("0".equals(smoke_1) || "".equals(smoke_1)) {%>checked<%} %>>&nbsp;從不吸煙 Never smoke</td>
				<td><input type="radio" name="smoke_1" value="1" <%if ("1".equals(smoke_1)) {%>checked<%} %>>&nbsp;有 Smoker:</td>
				<td>
					<table>
					<tr>
						<td>每天吸煙 Have <input type="text" name="smoke_2" value="<%=smoke_2 %>" size=1/> 支 cigarette(s) per day</td>
						<td>已戒煙 Ex-smoker for <input type="text" name="smoke_3" value="<%=smoke_3 %>" size=1/> 年 Years
						</td>				
					</tr>
					</table>
					<table>					
					<tr>
					<td>曾用戒煙的方式 Ways to quit:</td>							
					<td><input type="checkbox" name="smoke_4" value="1" <%if ("1".equals(smoke_4)) {%>checked<%} %>/>&nbsp;口服藥物 Oral Med</td>
					<td><input type="checkbox" name="smoke_5" value="1" <%if ("1".equals(smoke_5)) {%>checked<%} %>/>&nbsp;尼古丁替代物 (戒煙糖、香口膠、貼) Nicotine Replacement Therapy</td>
					<td><input type="checkbox" name="smoke_6" value="1" <%if ("1".equals(smoke_6)) {%>checked<%} %>/>&nbsp;減少煙支數 Decreased cigarette consumption</td>
					</tr>
					</table>
				</td>
				</tr>
				</table>
			</td>
			</tr>			
			</table>
			</td>
		</tr>		
	</table>
	</td>
	</tr>
	<tr>
		
	<td> 
		<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td style="background: #F5A9F2;">			
			飲酒習慣 Alcoholic Consumption
			</td>
		</tr>
		<tr>
			<td>
			<table class="table2">
				<tr>
				<td>
				<table>
				<tr>
				<td><input type="radio" name="drink_1" value="0" <%if ("0".equals(drink_1) || "".equals(drink_1)) {%>checked<%} %>>&nbsp;從不飲酒 Never drink</td>
				<td><input type="radio" name="drink_1" value="1" <%if ("1".equals(drink_1)) {%>checked<%} %>>&nbsp;有 Yes: </td>				
				<td>								
					<table>	
					<tr>			
						<td>每天 Daily / :<input type="text" name="drink_2" value="<%=drink_2 %>" size=1/> 次 / 每月 time (s) per week / month / year</td>
						<td>/ 每週 <input type="text" name="drink_3" value="<%=drink_3 %>" size=1/> 次 </td>
						<td>/ 每年 <input type="text" name="drink_4" value="<%=drink_4 %>" size=1/> 次 </td>
						<td><input type="checkbox" name="drink_5" value="1" <%if ("1".equals(drink_5)) {%>checked<%} %>/>&nbsp;已戒酒  Ex-drinker for:</td>
						<td><input type="text" name="drink_6" value="<%=drink_6 %>" size=1/>年 years</td>
					</tr>
					<tr>				
						<td>最常飲用 If often drink:&nbsp;<input type="checkbox" name="drink_7" value="1" <%if ("1".equals(drink_7)) {%>checked<%} %>/>&nbsp;啤酒 Beer</td>
						<td><input type="checkbox" name="drink_8" value="1" <%if ("1".equals(drink_8)) {%>checked<%} %>/>&nbsp;汽酒 Light sparkling wine</td>
						<td><input type="checkbox" name="drink_9" value="1" <%if ("1".equals(drink_9)) {%>checked<%} %>/>&nbsp;紅酒或白酒 Red Wine or Spirit</td>
						<td><input type="checkbox" name="drink_10" value="1" <%if ("1".equals(drink_10)) {%>checked<%} %>/>&nbsp;烈酒 Whisky or Brandy</td>
						<td>其他 Other:<input type="text" name="drink_11" value="<%=drink_11 %>" size=30/></td>
					</tr>
					<tr>
					<td>每次飲用份量 Unit per drink each time:</td>
					<td><input type="text" name="drink_12" value="<%=drink_12 %>" size=1/>&nbsp;罐 can(s) /</td>				
					<td><input type="text" name="drink_13" value="<%=drink_13 %>" size=1/>&nbsp;杯 glass(es) /</td>
					<td><input type="text" name="drink_14" value="<%=drink_14 %>" size=1/>&nbsp;支 bottle(s)</td>
					</tr>					
					</table>
				</td>
				</tr>
				</table>
				</td>
				</tr>				
				<tr>
				<td>				
				</td>
				</tr>
			</table>
			</td>
		</tr>		
	</table>
	</td>
	</tr>	
	<tr>
		
	<td> 
		<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td style="background: #F5A9F2;">			
			飲食習慣 Dietary Habits
			</td>
		</tr>
		<tr>
			<td>
			<table class="table2">
				<tr>
				<td>
				<table>
				<tr>				
				<td><input type="radio" name="eat_1" value="0" <%if ("0".equals(eat_1) || "".equals(eat_1)) {%>checked<%} %>>&nbsp;非素食 Non-vegetarian&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="radio" name="eat_1" value="1" <%if ("1".equals(eat_1)) {%>checked<%} %>>&nbsp;素食:   非蛋奶  /  蛋奶  /  魚 Vegetarian:  Non Ovo-lacto / Ovo-lacto / Pescetarian&nbsp;&nbsp;&nbsp;&nbsp;</td>				
				</tr>
				</table>
				<table>
				<tr>
				<td><input type="checkbox" name="eat_2" value="1" <%if ("1".equals(eat_2)) {%>checked<%} %>/>&nbsp;每天進食水果 Daily&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="text" name="eat_3" value="<%=eat_3%>" size=1/>&nbsp;個 serving of fruit&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="eat_4" value="1" <%if ("1".equals(eat_4)) {%>checked<%} %>/>&nbsp;每天進食 Daily consume</td>
				<td><input type="text" name="eat_5" value="<%=eat_5 %>" size=1/>&nbsp;碗瓜菜或沙律菜 bowl (s) of vegetables&nbsp;&nbsp;&nbsp;&nbsp;</td>				 
				</tr>
				</table>
				<table>
				<tr>
				<td><input type="checkbox" name="eat_6" value="1" <%if ("1".equals(eat_6)) {%>checked<%} %>/>&nbsp;從不 / 很少出外用膳 Never / Seldom dinning out&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;有出外用膳 Dinning out :</td>
				<td><input type="checkbox" name="eat_7" value="1" <%if ("1".equals(eat_7)) {%>checked<%} %>/>&nbsp;每日Per day</td>
				<td><input type="text" name="eat_8" value="<%=eat_8 %>" size=1/>&nbsp;次time (s)</td>
				<td>&nbsp;<input type="checkbox" name="eat_17" value="1" <%if ("1".equals(eat_17)) {%>checked<%} %>/>&nbsp;每週 Per week</td>
				<td><input type="text" name="eat_9" value="<%=eat_9 %>" size=1/>&nbsp;次time (s)</td>
				<td>&nbsp;<input type="checkbox" name="eat_18" value="1" <%if ("1".equals(eat_18)) {%>checked<%} %>/>&nbsp;每月 Per week</td>
				<td><input type="text" name="eat_10" value="<%=eat_10 %>" size=1/>&nbsp;次time (s)</td>
				</tr>
				</table>
				<table>
				<tr>
				<td><input type="checkbox" name="eat_11" value="1" <%if ("1".equals(eat_11)) {%>checked<%} %>/>&nbsp;每天飲</td>
				<td><input type="text" name="eat_12" value="<%=eat_12 %>" size=1/>&nbsp;杯清水 glass (es) of water per day&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<%-- --%>
				<td>有飲茶習慣 Drink Tea:</td>
				<td><input type="checkbox" name="eat_13" value="1" <%if ("1".equals(eat_13)) {%>checked<%} %>/>&nbsp;每日 Per day</td>
				<td><input type="text" name="eat_14" value="<%=eat_14 %>" size=1/>&nbsp;杯 cup(s)&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;<input type="checkbox" name="eat_19" value="1" <%if ("1".equals(eat_19)) {%>checked<%} %>/>&nbsp;每週 Per week</td>
				<td><input type="text" name="eat_20" value="<%=eat_20 %>" size=1/>&nbsp;次time (s)</td>
				</tr>
				<tr>
				<td></td>
				<td></td>
				<td>有飲咖啡 習慣 Drink Coffee:</td>
				<td><input type="checkbox" name="eat_15" value="1" <%if ("1".equals(eat_15)) {%>checked<%} %>/>&nbsp;每日 Per day</td>
				<td><input type="text" name="eat_16" value="<%=eat_16 %>" size=1/>&nbsp;杯 cup(s)&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;<input type="checkbox" name="eat_21" value="1" <%if ("1".equals(eat_21)) {%>checked<%} %>/>&nbsp;每週 Per week</td>
				<td><input type="text" name="eat_22" value="<%=eat_22 %>" size=1/>&nbsp;次time (s)</td>				
				</tr>
				</table>
				<%--
				<table>
				<tr>
				<td><input type="checkbox" name="eat_14" value="1" <%if ("1".equals(eat_14)) {%>checked<%} %>/>&nbsp;從不 / 很少進食宵夜 Never / seldom have late night meals&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="eat_15" value="1" <%if ("1".equals(eat_15)) {%>checked<%} %>/>&nbsp;有宵夜習慣 Have late night meals&nbsp;&nbsp;&nbsp;&nbsp;</td>
				</tr>
				</table>
				 --%>
				</td>
				</tr>				
			</table>
			</td>
		</tr>		
	</table>
	</td>
	</tr>
	<tr>
		
	<td> 
		<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td style="background: #F5A9F2;">			
			睡眠習慣 Sleeping Habits
			</td>
		</tr>
		<tr>
			<td>
			<table class="table2">
				<tr>
				<td>
				<table>
				<tr>
				<td><input type="radio" name="sleep_1" value="0" <%if ("0".equals(sleep_1) || "".equals(sleep_1)) {%>checked<%} %>>&nbsp;從來沒有失眠 No insomnia&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="radio" name="sleep_1" value="1" <%if ("1".equals(sleep_1)) {%>checked<%} %>>&nbsp;有失眠 Insomnia&nbsp;&nbsp;&nbsp;&nbsp;</td>				
				<td><input type="radio" name="sleep_1" value="2" <%if ("2".equals(sleep_1)) {%>checked<%} %>>&nbsp;間中失眠 Sometimes&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="radio" name="sleep_1" value="3" <%if ("3".equals(sleep_1)) {%>checked<%} %>>&nbsp;難以入睡 Difficulty in falling asleep&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="radio" name="sleep_1" value="4" <%if ("4".equals(sleep_1)) {%>checked<%} %>>&nbsp;容易醒 light sleeper&nbsp;&nbsp;&nbsp;&nbsp;</td>
				</tr>
				<tr>
				<td>每天平均睡眠時間 Average daily sleeping hours:</td>
				<td><input type="radio" name="sleep_2" value="0" <%if ("0".equals(sleep_2) || "".equals(sleep_2)) {%>checked<%} %>>&nbsp;少於5小時 Less than 5 hours&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="radio" name="sleep_2" value="1" <%if ("1".equals(sleep_2)) {%>checked<%} %>>&nbsp;6 – 8小時 6 - 8 hours&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="radio" name="sleep_2" value="2" <%if ("2".equals(sleep_2)) {%>checked<%} %>>&nbsp;多於 9 小時 More than 9 hours&nbsp;&nbsp;&nbsp;&nbsp;</td>
				</tr>
				</table>
				</td>
				</tr>				
			</table>
			</td>
		</tr>		
	</table>
	</td>
	</tr>		
	<tr>
		
	<td> 
		<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td style="background: #F5A9F2;">			
			運動習慣 Exercise Habits
			</td>
		</tr>
		<tr>
			<td>
			<table class="table2">
				<tr>
				<td>
				<table>
				<tr>				
				<td><input type="radio" name="sport_1" value="0" <%if ("0".equals(sport_1) || "".equals(sport_1)) {%>checked<%} %>>&nbsp;沒有 No&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="radio" name="sport_1" value="1" <%if ("1".equals(sport_1)) {%>checked<%} %>>&nbsp;有，平均每週運動 Yes.  Average&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>
					<table border=0>
					<tr>					
					<td>
						<table border=0>
						<tr>						
						<td><input type="text" name="sport_2" value="<%=sport_2 %>" size=1/>&nbsp;日 day (s) per week&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>&nbsp;那一類運動 What kind of exercise?&nbsp;<input type="text" name="sport_3" value="<%=sport_3 %>" size=60/></td>
						</tr>
						</table>
					</td>			
					</tr>
					<tr>
					<td>
						<table border=0>
						<tr>
						<td>每次運動的時間  Average length of exercise each time&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td><input type="radio" name="sport_4" value="0" <%if ("0".equals(sport_4) || "".equals(sport_4)) {%>checked<%} %>>&nbsp;少於30分鐘 Less than 30 mins&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td><input type="radio" name="sport_4" value="1" <%if ("1".equals(sport_4)) {%>checked<%} %>>&nbsp;約 1 小時 Around 1 hour&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td><input type="radio" name="sport_4" value="2" <%if ("2".equals(sport_4)) {%>checked<%} %>>&nbsp;2-3 小時 2-3 hours&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td><input type="radio" name="sport_4" value="3" <%if ("3".equals(sport_4)) {%>checked<%} %>>&nbsp;多於 3 小時 over 3 hours&nbsp;&nbsp;&nbsp;&nbsp;</td>
						</tr>
						</table>
					</td>						
					</tr>					
					</table>
				</td>
				</tr>				
				</table>
				</td>
				</tr>			
			</table>
			</td>			
		</tr>		
	</table>
	</td>
	</tr>		


	<tr>
		
	<td> 
		<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td style="background: #F5A9F2;">			
			情緒狀態 Mood Status
			</td>
		</tr>
		<tr>
		<td>		
		<table>
		<tr>
		<td>
			<table class="table2">
			<tr>
				<td>&nbsp;在過去的兩周裡，感覺自己被以下症狀所困擾的頻率是？  In the past two weeks, did you feel depressed or difficult to be happy in most of the time?</td>
			</tr>
			<tr>
			<td>
				<table>
				<tr>
				<td><input type="hidden" name="mood_1" value="1" <%if ("1".equals(mood_1)) {%>checked<%} %>/>&nbsp;1) 對任何事情都提不起興趣/感受不到興趣 You lost interest or motivation in doing anything:</td>				
				<td>&nbsp;&nbsp;&nbsp;<input type="radio" name="mood_2" value="0" <%if ("0".equals(mood_2) || "".equals(mood_2)) {%>checked<%} %>/>&nbsp;完全没有 Never</td>
				<td>&nbsp;&nbsp;&nbsp;<input type="radio" name="mood_2" value="1" <%if ("1".equals(mood_2)) {%>checked<%} %>/>&nbsp;有過幾天 A few days</td>
				<td>&nbsp;&nbsp;&nbsp;<input type="radio" name="mood_2" value="2" <%if ("2".equals(mood_2)) {%>checked<%} %>/>&nbsp;超過一半天數 More than a week</td>
				<td>&nbsp;&nbsp;&nbsp;<input type="radio" name="mood_2" value="3" <%if ("3".equals(mood_2)) {%>checked<%} %>/>&nbsp;幾乎每天 Almost every day</td>
				</tr>
				<tr>
				<td><input type="hidden" name="mood_3" value="1" <%if ("1".equals(mood_3)) {%>checked<%} %>/>&nbsp;2) 感覺沮喪的，憂鬱的，或絕望的 Felt discouraged, depressed, or hopeless:</td>
				<td>&nbsp;&nbsp;&nbsp;<input type="radio" name="mood_4" value="0" <%if ("0".equals(mood_4) || "".equals(mood_4)) {%>checked<%} %>/>&nbsp;完全没有 Never</td>
				<td>&nbsp;&nbsp;&nbsp;<input type="radio" name="mood_4" value="1" <%if ("1".equals(mood_4)) {%>checked<%} %>/>&nbsp;有過幾天 A few days</td>
				<td>&nbsp;&nbsp;&nbsp;<input type="radio" name="mood_4" value="2" <%if ("2".equals(mood_4)) {%>checked<%} %>/>&nbsp;超過一半天數 More than a week</td>
				<td>&nbsp;&nbsp;&nbsp;<input type="radio" name="mood_4" value="3" <%if ("3".equals(mood_4)) {%>checked<%} %>/>&nbsp;幾乎每天 Almost every day</td>
				</tr>				
				</table>
			</td>
			</tr>								
			</table>
		</td>		
		</tr>
		</table>
		</td>
		</tr>
		
		<tr>
		<td>
		<table style="background-color:white;" width="100%">
		<tr>
			<td style="background: #F3E2A9">
			只適用於女性 For Female Only:
			</td>
		</tr>
		<tr>
		<td>
			<table class="table2">
			<tr>
			<td>
				<table>
				<tr>			
				<td>月經週期史 Menstrual history:&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>首次經期年齡 Menarche age <input type="text" name="female_1" value="<%=female_1%>" size=2/></td>
				<td>最近一次經期 Last Menstrual Period <input type="text" name="female_2" value="<%=female_2%>" size=8 class="datepickerfield notEmpty"/>&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="female_3" value="1"/ <%if ("1".equals(female_3)) {%>checked<%} %>>&nbsp;已停經 Menopause&nbsp;&nbsp;&nbsp;&nbsp;</td>
				</tr>
				</table>
			</td>
			</tr>
			<tr>
			<td>
				<table>
				<tr>
				<td>月經狀況 Menstrual condition :&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="female_4" value="1" <%if ("1".equals(female_4)) {%>checked<%} %>/>&nbsp;不規律 Irregular&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="female_11" value="1" <%if ("1".equals(female_11)) {%>checked<%} %>/>&nbsp;規律 Regular&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="checkbox" name="female_5" value="1" <%if ("1".equals(female_5)) {%>checked<%} %>/>&nbsp;痛 Pain&nbsp;</td>
				<td><input type="checkbox" name="female_12" value="1" <%if ("1".equals(female_12)) {%>checked<%} %>/>&nbsp;不痛 Painless&nbsp;</td>
				</tr>
				</table>
			</td>
			</tr>
			<tr>
			<td>
				<table>
				<tr>
				<td>婦產科歷史  Obstetrical history:</td>									
				<td><input type="text" name="female_6" value="<%=female_6 %>" size=5/>&nbsp;G&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="text" name="female_7" value="<%=female_7 %>" size=5/>&nbsp;P&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="text" name="female_8" value="<%=female_8 %>" size=5/>&nbsp;M&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="text" name="female_9" value="<%=female_9 %>" size=5/>&nbsp;L&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td><input type="text" name="female_10" value="<%=female_10 %>" size=5/>&nbsp;T&nbsp;&nbsp;&nbsp;&nbsp;</td>
				</tr>
				</table>
			</td>
			</tr>
			</table>			
		</td>
		</tr>
		</table>
		</td>
		</tr>
		
	</table>
	</td>
	</tr>

<%
if (patientMode) {
%>
	<tr>
	<td>
		<input type="hidden" name="gc_1" value="<%=gc_1%>"/>
		<input type="hidden" name="gc_2" value="<%=gc_2%>"/>
		<input type="hidden" name="gc_3" value="<%=gc_3%>"/>
		<input type="hidden" name="gc_4" value="<%=gc_4%>"/>
		<input type="hidden" name="gc_5" value="<%=gc_5%>"/>
		<input type="hidden" name="gc_6" value="<%=gc_6%>"/>
		<input type="hidden" name="gc_7" value="<%=gc_7%>"/>
		<input type="hidden" name="gc_8" value="<%=gc_8%>"/>
		<input type="hidden" name="gc_9" value="<%=gc_9%>"/>
		<input type="hidden" name="gc_10" value="<%=gc_10%>"/>
		<input type="hidden" name="gc_11" value="<%=gc_11%>"/>
		<input type="hidden" name="gc_12" value="<%=gc_12%>"/>
		<input type="hidden" name="gc_13" value="<%=gc_13%>"/>
		<input type="hidden" name="gc_14" value="<%=gc_14%>"/>
		<input type="hidden" name="gc_15" value="<%=gc_15%>"/>

		<input type="hidden" name="ent_1" value="<%=ent_p[1]%>"/>
		<input type="hidden" name="ent_2" value="<%=ent_p[2]%>"/>
		<input type="hidden" name="ent_3" value="<%=ent_p[3]%>"/>
		<input type="hidden" name="ent_4" value="<%=ent_p[4]%>"/>
		<input type="hidden" name="ent_5" value="<%=ent_p[5]%>"/>
		<input type="hidden" name="ent_6" value="<%=ent_p[6]%>"/>
		<input type="hidden" name="ent_7" value="<%=ent_p[7]%>"/>
		<input type="hidden" name="ent_8" value="<%=ent_p[8]%>"/>
		<input type="hidden" name="ent_9" value="<%=ent_p[9]%>"/>
		<input type="hidden" name="ent_10" value="<%=ent_p[10]%>"/>
		<input type="hidden" name="ent_11" value="<%=ent_p[11]%>"/>
		<input type="hidden" name="ent_12" value="<%=ent_p[12]%>"/>
		<input type="hidden" name="ent_13" value="<%=ent_p[13]%>"/>
		<input type="hidden" name="ent_14" value="<%=ent_p[14]%>"/>
		<input type="hidden" name="ent_15" value="<%=ent_p[15]%>"/>
		<input type="hidden" name="ent_16" value="<%=ent_p[16]%>"/>		
		<input type="hidden" name="ent_17" value="<%=ent_p[17]%>"/>
		<input type="hidden" name="ent_18" value="<%=ent_p[18]%>"/>
		<input type="hidden" name="ent_19" value="<%=ent_p[19]%>"/>
		<input type="hidden" name="ent_20" value="<%=ent_p[20]%>"/>
		<input type="hidden" name="ent_21" value="<%=ent_p[21]%>"/>
		<input type="hidden" name="ent_22" value="<%=ent_p[22]%>"/>
		<input type="hidden" name="ent_23" value="<%=ent_p[23]%>"/>
		<input type="hidden" name="ent_24" value="<%=ent_p[24]%>"/>
		<input type="hidden" name="ent_25" value="<%=ent_p[25]%>"/>
		<input type="hidden" name="ent_26" value="<%=ent_p[26]%>"/>
		<input type="hidden" name="ent_27" value="<%=ent_p[27]%>"/>
		<input type="hidden" name="ent_28" value="<%=ent_p[28]%>"/>
		<input type="hidden" name="ent_29" value="<%=ent_p[29]%>"/>
		<input type="hidden" name="ent_30" value="<%=ent_p[30]%>"/>
		<input type="hidden" name="ent_31" value="<%=ent_p[31]%>"/>
		<input type="hidden" name="ent_32" value="<%=ent_p[32]%>"/>
		<input type="hidden" name="ent_33" value="<%=ent_p[33]%>"/>
		<input type="hidden" name="ent_34" value="<%=ent_p[34]%>"/>
		<input type="hidden" name="ent_25" value="<%=ent_p[35]%>"/>
		<input type="hidden" name="ent_26" value="<%=ent_p[36]%>"/>		
		<input type="hidden" name="ent_27" value="<%=ent_p[37]%>"/>
		<input type="hidden" name="ent_28" value="<%=ent_p[38]%>"/>
		<input type="hidden" name="ent_29" value="<%=ent_p[39]%>"/>
		<input type="hidden" name="ent_20" value="<%=ent_p[40]%>"/>
		<input type="hidden" name="ent_41" value="<%=ent_p[41]%>"/>
		<input type="hidden" name="ent_42" value="<%=ent_p[42]%>"/>
		<input type="hidden" name="ent_43" value="<%=ent_p[43]%>"/>
		<input type="hidden" name="ent_44" value="<%=ent_p[44]%>"/>
		<input type="hidden" name="ent_45" value="<%=ent_p[45]%>"/>
		<input type="hidden" name="ent_46" value="<%=ent_p[46]%>"/>		
		<input type="hidden" name="ent_47" value="<%=ent_p[47]%>"/>
		<input type="hidden" name="ent_48" value="<%=ent_p[48]%>"/>
		<input type="hidden" name="ent_49" value="<%=ent_p[49]%>"/>
		<input type="hidden" name="ent_50" value="<%=ent_p[50]%>"/>
		<input type="hidden" name="ent_51" value="<%=ent_p[51]%>"/>

		<input type="hidden" name="ls_1" value="<%=ls_1%>"/>
		<input type="hidden" name="ls_2" value="<%=ls_2%>"/>
		<input type="hidden" name="ls_3" value="<%=ls_3%>"/>
		<input type="hidden" name="ls_4" value="<%=ls_4%>"/>
		<input type="hidden" name="ls_5" value="<%=ls_5%>"/>
		<input type="hidden" name="ls_6" value="<%=ls_6%>"/>
		<input type="hidden" name="bn_1" value="<%=bn_1%>"/>
		<input type="hidden" name="bn_2" value="<%=bn_2%>"/>
		<input type="hidden" name="bn_3" value="<%=bn_3%>"/>
		<input type="hidden" name="bn_4" value="<%=bn_4%>"/>
		<input type="hidden" name="bn_5" value="<%=bn_5%>"/>
		<input type="hidden" name="bn_6" value="<%=bn_6%>"/>
		<input type="hidden" name="bn_7" value="<%=bn_7%>"/>
		<input type="hidden" name="bn_8" value="<%=bn_8%>"/>
		<input type="hidden" name="bn_9" value="<%=bn_9%>"/>
		<input type="hidden" name="bn_10" value="<%=bn_10%>"/>
		<input type="hidden" name="bn_11" value="<%=bn_11%>"/>
		<input type="hidden" name="bn_12" value="<%=bn_12%>"/>
		<input type="hidden" name="bn_13" value="<%=bn_13%>"/>
		<input type="hidden" name="bn_14" value="<%=bn_14%>"/>
		<input type="hidden" name="bn_15" value="<%=bn_15%>"/>
		<input type="hidden" name="bn_16" value="<%=bn_16%>"/>
		<input type="hidden" name="rs_1" value="<%=rs_1%>"/>
		<input type="hidden" name="rs_2" value="<%=rs_2%>"/>
		<input type="hidden" name="rs_3" value="<%=rs_3%>"/>
		<input type="hidden" name="rs_4" value="<%=rs_4%>"/>
		<input type="hidden" name="rs_5" value="<%=rs_5%>"/>
		<input type="hidden" name="rs_6" value="<%=rs_6%>"/>
		<input type="hidden" name="rs_7" value="<%=rs_7%>"/>
		<input type="hidden" name="rs_8" value="<%=rs_8%>"/>
		<input type="hidden" name="rs_9" value="<%=rs_9%>"/>
		<input type="hidden" name="rs_10" value="<%=rs_10%>"/>
		<input type="hidden" name="cs_1" value="<%=cs_1%>"/>
		<input type="hidden" name="cs_2" value="<%=cs_2%>"/>
		<input type="hidden" name="cs_3" value="<%=cs_3%>"/>
		<input type="hidden" name="cs_4" value="<%=cs_4%>"/>
		<input type="hidden" name="cs_5" value="<%=cs_5%>"/>
		<input type="hidden" name="cs_6" value="<%=cs_6%>"/>
		<input type="hidden" name="cs_7" value="<%=cs_7%>"/>
		<input type="hidden" name="cs_8" value="<%=cs_8%>"/>
		<input type="hidden" name="ne_1" value="<%=ne_1%>"/>
		<input type="hidden" name="ne_2" value="<%=ne_2%>"/>
		<input type="hidden" name="ne_3" value="<%=ne_3%>"/>
		<input type="hidden" name="ne_4" value="<%=ne_4%>"/>
		<input type="hidden" name="ne_5" value="<%=ne_5%>"/>
		<input type="hidden" name="ne_6" value="<%=ne_6%>"/>
		<input type="hidden" name="ne_7" value="<%=ne_7%>"/>
		<input type="hidden" name="ne_8" value="<%=ne_8%>"/>
		<input type="hidden" name="ne_9" value="<%=ne_9%>"/>
		<input type="hidden" name="ne_10" value="<%=ne_10%>"/>
		<input type="hidden" name="ne_11" value="<%=ne_11%>"/>
		<input type="hidden" name="ne_12" value="<%=ne_12%>"/>
		<input type="hidden" name="ne_13" value="<%=ne_13%>"/>
		<input type="hidden" name="ne_14" value="<%=ne_14%>"/>
		<input type="hidden" name="ne_15" value="<%=ne_15%>"/>
		<input type="hidden" name="ne_16" value="<%=ne_16%>"/>		
		<input type="hidden" name="ne_16" value="<%=ne_17%>"/>
		<input type="hidden" name="ne_16" value="<%=ne_18%>"/>
		<input type="hidden" name="ne_16" value="<%=ne_19%>"/>
		<input type="hidden" name="ne_16" value="<%=ne_20%>"/>
		<input type="hidden" name="s_1" value="<%=s_1%>"/>
		<input type="hidden" name="s_2" value="<%=s_2%>"/>
		<input type="hidden" name="s_3" value="<%=s_3%>"/>
		<input type="hidden" name="s_4" value="<%=s_4%>"/>
		<input type="hidden" name="a_p0" value="<%=a_p[0]%>"/>
		<input type="hidden" name="a_p1" value="<%=a_p[1]%>"/>
		<input type="hidden" name="a_p2" value="<%=a_p[2]%>"/>
		<input type="hidden" name="a_p3" value="<%=a_p[3]%>"/>
		<input type="hidden" name="a_p4" value="<%=a_p[4]%>"/>
		<input type="hidden" name="a_p5" value="<%=a_p[5]%>"/>
		<input type="hidden" name="a_p6" value="<%=a_p[6]%>"/>
		<input type="hidden" name="a_p7" value="<%=a_p[7]%>"/>
		<input type="hidden" name="a_p8" value="<%=a_p[8]%>"/>
		<input type="hidden" name="a_p9" value="<%=a_p[9]%>"/>
		<input type="hidden" name="a_p10" value="<%=a_p[10]%>"/>
		<input type="hidden" name="a_p11" value="<%=a_p[11]%>"/>
		<input type="hidden" name="a_p12" value="<%=a_p[12]%>"/>
		<input type="hidden" name="a_p13" value="<%=a_p[13]%>"/>
		<input type="hidden" name="a_p14" value="<%=a_p[14]%>"/>
		<input type="hidden" name="a_p15" value="<%=a_p[15]%>"/>
		<input type="hidden" name="a_p16" value="<%=a_p[16]%>"/>		
		<input type="hidden" name="a_p17" value="<%=a_p[17]%>"/>
		<input type="hidden" name="a_p18" value="<%=a_p[18]%>"/>
		<input type="hidden" name="a_p19" value="<%=a_p[19]%>"/>
		<input type="hidden" name="a_p20" value="<%=a_p[20]%>"/>
		<input type="hidden" name="a_p21" value="<%=a_p[21]%>"/>
		<input type="hidden" name="a_p22" value="<%=a_p[22]%>"/>
		<input type="hidden" name="a_p23" value="<%=a_p[23]%>"/>
		<input type="hidden" name="a_p24" value="<%=a_p[24]%>"/>
		<input type="hidden" name="a_p25" value="<%=a_p[25]%>"/>
		<input type="hidden" name="a_p26" value="<%=a_p[26]%>"/>
		<input type="hidden" name="a_p27" value="<%=a_p[27]%>"/>
		<input type="hidden" name="a_p28" value="<%=a_p[28]%>"/>
		<input type="hidden" name="a_p29" value="<%=a_p[29]%>"/>
		<input type="hidden" name="a_p30" value="<%=a_p[30]%>"/>
		<input type="hidden" name="a_p31" value="<%=a_p[31]%>"/>
		<input type="hidden" name="ex_1" value="<%=ex_1%>"/>
		<input type="hidden" name="ex_1" value="<%=ex_2%>"/>
		<input type="hidden" name="mn_p0" value="<%=mn_p[0]%>"/>
		<input type="hidden" name="mn_p1" value="<%=mn_p[1]%>"/>
		<input type="hidden" name="mn_p2" value="<%=mn_p[2]%>"/>
		<input type="hidden" name="mn_p3" value="<%=mn_p[3]%>"/>
		<input type="hidden" name="mn_p4" value="<%=mn_p[4]%>"/>
		<input type="hidden" name="mn_p5" value="<%=mn_p[5]%>"/>
		<input type="hidden" name="mn_p6" value="<%=mn_p[6]%>"/>
		<input type="hidden" name="mn_p7" value="<%=mn_p[7]%>"/>
		<input type="hidden" name="mn_p8" value="<%=mn_p[8]%>"/>
		<input type="hidden" name="mn_p9" value="<%=mn_p[9]%>"/>
		<input type="hidden" name="mn_p10" value="<%=mn_p[10]%>"/>
		<input type="hidden" name="mn_p11" value="<%=mn_p[11]%>"/>
		<input type="hidden" name="mn_p12" value="<%=mn_p[12]%>"/>
		<input type="hidden" name="mn_p13" value="<%=mn_p[13]%>"/>
		<input type="hidden" name="mn_p14" value="<%=mn_p[14]%>"/>
		<input type="hidden" name="remark" value="<%=remark%>"/>
		</td>
	</tr>
<%
}
else if (nurseMode) {
%>
  <tr>
	<td align="center"><font size="5"><b>Medical Assessment (By Doctor)</b></font></td>
	</tr>
	<tr>		
	<td> 
		<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td style="background: #F5A9F2;">		
			General Condition 一般狀況
			</td>
		</tr>
		<tr>
			<td>
			<table class="table2">
			<tr>			
			<td>
				<table>
				<tr>
				<td>Pallor 蒼白</td>
				<%--
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				 --%>				
				<td><input type="radio" name="gc_1" value="0" <%if ("0".equals(gc_1) || "".equals(gc_1)) {%>checked<%} %>>&nbsp;No 否</td>
				<td><input type="radio" name="gc_1" value="1" <%if ("1".equals(gc_1)) {%>checked<%} %>>&nbsp;Yes 有</td>
				<td>:&nbsp;<input type="text" name="gc_2" value="<%=gc_2 %>" size=100/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				</tr>
				<tr>
				<td>Jaundice 黃疸</td>
				<%--
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				 --%>				
				<td><input type="radio" name="gc_3" value="0" <%if ("0".equals(gc_3) || "".equals(gc_3)) {%>checked<%} %>>&nbsp;No 否</td>
				<td><input type="radio" name="gc_3" value="1" <%if ("1".equals(gc_3)) {%>checked<%} %>>&nbsp;Yes 有</td>
				<td>:&nbsp;<input type="text" name="gc_4" value="<%=gc_4 %>" size=100/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>				
				</tr>
				<tr>
				<td>Edema 水腫</td>
				<%--
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				 --%>
				<td><input type="radio" name="gc_5" value="0" <%if ("0".equals(gc_5) || "".equals(gc_5)) {%>checked<%} %>>&nbsp;Absent 沒有</td>
				<td><input type="radio" name="gc_5" value="1" <%if ("1".equals(gc_5)) {%>checked<%} %>>&nbsp;Present 有</td>
				<td>:&nbsp;<input type="text" name="gc_6" value="<%=gc_6 %>" size=100/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>				
				</tr>
				<tr>
				<td>Skin 皮膚</td>
				<td><input type="radio" name="gc_7" value="0" <%if ("0".equals(gc_7) || "".equals(gc_7)) {%>checked<%} %>>&nbsp;Normal 正常</td>
				<td><input type="radio" name="gc_7" value="1" <%if ("1".equals(gc_7)) {%>checked<%} %>>&nbsp;Abnormal 不正常 : </td>								
				<td>
					<Table>
					<tr>
					<%--
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					 --%>
					<td><input type="checkbox" name="gc_8" value="1" <%if ("1".equals(gc_8)) {%>checked<%} %>/>&nbsp;Tinea Pedis 足癬</td>
					<td><input type="checkbox" name="gc_9" value="1" <%if ("1".equals(gc_9)) {%>checked<%} %>/>&nbsp;Tinea Cruris 股癬</td>
					<td><input type="checkbox" name="gc_10" value="1" <%if ("1".equals(gc_10)) {%>checked<%} %>/>&nbsp;Psoriasis 乾癬</td>
					<td><input type="checkbox" name="gc_11" value="1" <%if ("1".equals(gc_11)) {%>checked<%} %>/>&nbsp;Eczema 濕疹</td>
					</tr>
					</Table>				
				</td>
				</tr>
				<tr>
				<td>Nails 指甲</td>
				<td><input type="radio" name="gc_12" value="0" <%if ("0".equals(gc_12) || "".equals(gc_12)) {%>checked<%} %>>&nbsp;Normal 正常</td>
				<td><input type="radio" name="gc_12" value="1" <%if ("1".equals(gc_12)) {%>checked<%} %>>&nbsp;Abnormal 不正常: </td>								
				<td>
					<table>
					<tr>
					<%--
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					 --%>
					<td><input type="checkbox" name="gc_13" value="1" <%if ("1".equals(gc_13)) {%>checked<%} %>/>&nbsp;Clubbing 杵狀指</td>
					<td><input type="checkbox" name="gc_14" value="1" <%if ("1".equals(gc_14)) {%>checked<%} %>/>&nbsp;Tinea unguium 甲癣</td>
					<td><input type="checkbox" name="gc_15" value="1" <%if ("1".equals(gc_15)) {%>checked<%} %>/>&nbsp;Ingrowing 嵌甲</td>					
					</tr>
					</table>				
				</td>
				</tr>
				
				</table>
			</td>
			</tr>			
			</table>
			</td>
		</tr>		
		</table>
	</td>
	</tr>
	<tr>
		<td> 
		<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
		<%-- start here --%>

		
			<tr>
			<td style="background: #F5A9F2;">			
			<%--
			<td style="background: #D8D8D8">
			 --%>			
			ENT
			</td>
		</tr>
		<tr>
		<td>
		
		<table class="table2">
		<tr>
		<td>
		
		
			<table border=0>
			<tr>			
				<td>
				Throat 咽喉:
				</td>
			</tr>
			<tr>
				<td></td>
				<td>
				Tonsil 扁桃腺
				</td>
				<td><input type="radio" name="ent_1" value="0" <%if ("0".equals(ent_p[1]) || "".equals(ent_p[1])) {%>checked<%} %>>&nbsp;Normal 正常</td>
				<td><input type="radio" name="ent_1" value="1" <%if ("1".equals(ent_p[1])) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
				<td><input type="radio" name="ent_1" value="2" <%if ("2".equals(ent_p[1])) {%>checked<%} %>>&nbsp;Absent 缺少的</td>
			</tr>
			<tr>
				<td></td>
				<td>
				Tongue 舌頭
				</td>
				<td><input type="radio" name="ent_4" value="0" <%if ("0".equals(ent_p[4]) || "".equals(ent_p[4])) {%>checked<%} %>>&nbsp;Normal 正常</td>
				<td><input type="radio" name="ent_4" value="1" <%if ("1".equals(ent_p[4])) {%>checked<%} %>>&nbsp;Coated 舌苔</td>
				<%--
				<td><input type="checkbox" name="ent_4" value="1" <%if ("1".equals(ent_4)) {%>checked<%} %>/>&nbsp;Normal</td>
				<td><input type="checkbox" name="ent_5" value="1" <%if ("1".equals(ent_5)) {%>checked<%} %>/>&nbsp;Coated</td>
				 --%>
				<td>:&nbsp;<input type="text" name="ent_6" value="<%=ent_p[6] %>" size=90/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>				
			</tr>
			<tr>
				<td></td>
				<td>
				Halitosis 口臭
				</td>
				<td><input type="radio" name="ent_7" value="0" <%if ("0".equals(ent_p[7]) || "".equals(ent_p[7])) {%>checked<%} %>>&nbsp;Absent 缺少的</td>
				<td><input type="radio" name="ent_7" value="1" <%if ("1".equals(ent_p[7])) {%>checked<%} %>>&nbsp;Present 存在的</td>				
				<td>:&nbsp;<input type="text" name="ent_9" value="<%=ent_p[9] %>" size=90/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			</tr>
			<tr>			
				<td>
				Trachea 氣管
				</td>
				<td><input type="radio" name="ent_10" value="0" <%if ("0".equals(ent_p[10]) || "".equals(ent_p[10])) {%>checked<%} %>>&nbsp;Normal 正常</td>
				<td><input type="radio" name="ent_10" value="1" <%if ("1".equals(ent_p[10]) || "".equals(ent_p[10])) {%>checked<%} %>>&nbsp;Absent 缺少的</td>
				<td><input type="radio" name="ent_10" value="2" <%if ("2".equals(ent_p[10])) {%>checked<%} %>>&nbsp;Deviated 偏離</td>				
				<td>:&nbsp;<input type="text" name="ent_12" value="<%=ent_p[12] %>" size=90/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			</tr>
			<tr>			
				<td>
				Thyroid 甲狀腺
				</td>
				<td><input type="radio" name="ent_13" value="0" <%if ("0".equals(ent_p[13]) || "".equals(ent_p[13])) {%>checked<%} %>>&nbsp;Normal 正常</td>
				<td><input type="radio" name="ent_13" value="1" <%if ("1".equals(ent_p[13])) {%>checked<%} %>>&nbsp;Removed 已割除</td>
				<td><input type="radio" name="ent_13" value="2" <%if ("2".equals(ent_p[13])) {%>checked<%} %>>&nbsp;Abnorma 不正常</td>
			</tr>
			<tr>			
				<td>
				Nose 鼻:
				</td>
				<td><input type="radio" name="ent_16" value="0" <%if ("0".equals(ent_p[16]) || "".equals(ent_p[16])) {%>checked<%} %>>&nbsp;Normal 正常</td>
				<td><input type="radio" name="ent_16" value="1" <%if ("1".equals(ent_p[16])) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>				
				<td></td>
				<td>:&nbsp;<input type="text" name="ent_18" value="<%=ent_p[18] %>" size=90/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>			
			</tr>
			<tr>
			<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>
				Sinuses 鼻竇
				</td>
				<td><input type="radio" name="ent_19" value="0" <%if ("0".equals(ent_p[19]) || "".equals(ent_p[19])) {%>checked<%} %>>&nbsp;Normal 正常</td>
				<td><input type="radio" name="ent_19" value="1" <%if ("1".equals(ent_p[19])) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
				<td>:&nbsp;<input type="text" name="ent_21" value="<%=ent_p[21] %>" size=90/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			</tr>	
			</table>
		</td>
		</tr>
		
		
		<tr>
		<td>
			<table border=0>
				<tr><td>
				<table>
				<tr>
				<td>Ear 耳</td>
				</tr>
				</table>
				<table>
				<tr>	
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>
						External Canal 外耳道
					</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>									
					<td><input type="radio" name="ent_22" value="0" <%if ("0".equals(ent_p[22]) || "".equals(ent_p[22])) {%>checked<%} %>>&nbsp;Normal 正常</td>
					<td><input type="radio" name="ent_22" value="1" <%if ("1".equals(ent_p[22])) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
					<td>:&nbsp;<input type="text" name="ent_24" value="<%=ent_p[24] %>" size=90/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				</tr>
				</table>
				</td></tr>
				<tr><td>
				<table>
				<tr>	
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>					
					<td>
						Drum 鼓膜
					</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>					
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td><input type="radio" name="ent_25" value="0" <%if ("0".equals(ent_p[25]) || "".equals(ent_p[25])) {%>checked<%} %>>&nbsp;Normal 正常</td>
					<td><input type="radio" name="ent_25" value="1" <%if ("1".equals(ent_p[25])) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
					<td><input type="radio" name="ent_25" value="2" <%if ("2".equals(ent_p[25])) {%>checked<%} %>>&nbsp;Otitis 耳炎:</td>
					<td><input type="checkbox" name="ent_28" value="1" <%if ("1".equals(ent_p[28])) {%>checked<%} %>/>&nbsp;External 外耳</td>
					<td><input type="checkbox" name="ent_46" value="1" <%if ("1".equals(ent_p[46])) {%>checked<%} %>/>&nbsp;R 右</td>
					<td><input type="checkbox" name="ent_47" value="1" <%if ("1".equals(ent_p[47])) {%>checked<%} %>/>&nbsp;L 左</td>
				</tr>
				<tr>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
					<td><input type="checkbox" name="ent_29" value="1" <%if ("1".equals(ent_p[29])) {%>checked<%} %>/>&nbsp;Impacted wax 嵌塞耳垢</td>					
					<td><input type="checkbox" name="ent_48" value="1" <%if ("1".equals(ent_p[48])) {%>checked<%} %>/>&nbsp;R 右</td>
					<td><input type="checkbox" name="ent_49" value="1" <%if ("1".equals(ent_p[49])) {%>checked<%} %>/>&nbsp;L 左</td>
				</tr>
				<tr>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
				<td></td>
					<td><input type="checkbox" name="ent_30" value="1" <%if ("1".equals(ent_p[30])) {%>checked<%} %>/>&nbsp;Media 中耳</td>					
					<td><input type="checkbox" name="ent_50" value="1" <%if ("1".equals(ent_p[50])) {%>checked<%} %>/>&nbsp;R 右</td>
					<td><input type="checkbox" name="ent_51" value="1" <%if ("1".equals(ent_p[51])) {%>checked<%} %>/>&nbsp;L 左</td>
				</tr>				
				</table>
				</td></tr>
				<tr><td>
				<table>
				<tr>	
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>
						Tuning Fork Test 音差測試
					</td>
					<td><input type="radio" name="ent_31" value="0" <%if ("0".equals(ent_p[31]) || "".equals(ent_p[31])) {%>checked<%} %>>&nbsp;Normal 正常</td>
					<td><input type="radio" name="ent_31" value="1" <%if ("1".equals(ent_p[31])) {%>checked<%} %>>&nbsp;Abnormal 不正常:</td>
					<td><input type="checkbox" name="ent_33" value="1" <%if ("1".equals(ent_p[33])) {%>checked<%} %>/>&nbsp;Impaired conduction hearing 傳導性聽力受損</td>
					<td><input type="checkbox" name="ent_52" value="1" <%if ("1".equals(ent_p[52])) {%>checked<%} %>/>&nbsp;R 右</td>
					<td><input type="checkbox" name="ent_53" value="1" <%if ("1".equals(ent_p[53])) {%>checked<%} %>/>&nbsp;L 左</td>
				</tr>
				<tr>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td><input type="checkbox" name="ent_34" value="1" <%if ("1".equals(ent_p[34])) {%>checked<%} %>/>&nbsp;Impaired sensory hearing 感覺的聽力受損</td>
					<td><input type="checkbox" name="ent_54" value="1" <%if ("1".equals(ent_p[54])) {%>checked<%} %>/>&nbsp;R 右</td>
					<td><input type="checkbox" name="ent_55" value="1" <%if ("1".equals(ent_p[55])) {%>checked<%} %>/>&nbsp;L 左</td>
				</tr>
				</table>
				</td></tr>				
			</table>
		
		</td>			
		</tr>

		<tr>
		<td>
			<table border=0>
				<tr>
				<td>Eye 眼睛</td>
				</tr>
				<tr>			
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>
						Cornea 角膜
					</td>
					<td><input type="radio" name="ent_38" value="0" <%if ("0".equals(ent_p[38]) || "".equals(ent_p[38])) {%>checked<%} %>>&nbsp;Normal 正常</td>
					<td><input type="radio" name="ent_38" value="1" <%if ("1".equals(ent_p[38])) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
					<td>:&nbsp;<input type="text" name="ent_39" value="<%=ent_p[39] %>" size=100/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				</tr>
				<tr>	
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>
						Pupils 瞳孔
					</td>
					<td><input type="radio" name="ent_40" value="0" <%if ("0".equals(ent_p[40]) || "".equals(ent_p[40])) {%>checked<%} %>>&nbsp;Normal 正常</td>
					<td><input type="radio" name="ent_40" value="1" <%if ("1".equals(ent_p[40])) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
					<td>:&nbsp;<input type="text" name="ent_41" value="<%=ent_p[41] %>" size=100/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				</tr>
				<tr>	
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>
						Conjunctivae 結膜
					</td>
					<td><input type="radio" name="ent_42" value="0" <%if ("0".equals(ent_p[42]) || "".equals(ent_p[42])) {%>checked<%} %>>&nbsp;Normal 正常</td>
					<td><input type="radio" name="ent_42" value="1" <%if ("1".equals(ent_p[42])) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
					<td>:&nbsp;<input type="text" name="ent_43" value="<%=ent_p[43] %>" size=100/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				</tr>
				<tr>	
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>
						Cataract 白內障
					</td>
					<td><input type="radio" name="ent_44" value="0" <%if ("0".equals(ent_p[44]) || "".equals(ent_p[44])) {%>checked<%} %>>&nbsp;No 不</td>
					<td><input type="radio" name="ent_44" value="1" <%if ("1".equals(ent_p[44])) {%>checked<%} %>>&nbsp;Yes 是</td>
					<td>:&nbsp;<input type="text" name="ent_45" value="<%=ent_p[45] %>" size=100/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				</tr>
			</table>
		

		</td>			
		</tr>
		
		</table>
		
		
	</td>
	</tr>
	
	<%-- end here --%>	
	
		
	<tr>		
	<td> 
		<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td style="background: #F5A9F2;">						
			Lymphatic System 淋巴系統
			</td>
		</tr>
		<tr>
			<td>
			<table class="table2">
			<tr>			
			<td>
				<table>
				<tr>
				<td>Cervical Nodes 頸淋巴結</td>
				<%--
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				 --%>				
				<td><input type="radio" name="ls_1" value="0" <%if ("0".equals(ls_1) || "".equals(ls_1)) {%>checked<%} %>>&nbsp;Not Palpable 未觸及</td>
				<td><input type="radio" name="ls_1" value="1" <%if ("1".equals(ls_1)) {%>checked<%} %>>&nbsp;Palpable 觸及</td>
				<td>:&nbsp;<input type="text" name="ls_2" value="<%=ls_2 %>" size=100/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				</tr>
				<tr>
				<td>Axillary Nodes 腋下淋巴結</td>
				<%--
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				 --%>				
				<td><input type="radio" name="ls_3" value="0" <%if ("0".equals(ls_3) || "".equals(ls_3)) {%>checked<%} %>>&nbsp;Not Palpable 未觸及</td>
				<td><input type="radio" name="ls_3" value="1" <%if ("1".equals(ls_3)) {%>checked<%} %>>&nbsp;Palpable 觸及</td>
				<td>:&nbsp;<input type="text" name="ls_4" value="<%=ls_4 %>" size=100/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>				
				</tr>
				<tr>
				<td>Inguinal Nodes 腹股溝淋巴結</td>
				<%--
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
				 --%>
				<td><input type="radio" name="ls_5" value="0" <%if ("0".equals(ls_5) || "".equals(ls_5)) {%>checked<%} %>>&nbsp;Not Palpable 未觸及</td>
				<td><input type="radio" name="ls_5" value="1" <%if ("1".equals(ls_5)) {%>checked<%} %>>&nbsp;Palpable 觸及</td>
				<td>:&nbsp;<input type="text" name="ls_6" value="<%=ls_6 %>" size=100/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>				
				</tr>				
				</table>
			</td>
			</tr>			
			</table>
			</td>
		</tr>		
		</table>
	</td>
	</tr>
		

	
	
	<tr>		
	<td> 
		<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td style="background: #F5A9F2;">
			Breast / Nipple 乳房 / 乳頭
			</td>
		</tr>
		<tr>
			<td>
			<table class="table2">
			<tr>
			<td>
				<table>
				<tr>			
					<td>Left 左乳</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>				
					<td><input type="radio" name="bn_1" value="0" <%if ("0".equals(bn_1) || "".equals(bn_1)) {%>checked<%} %>>&nbsp;Normal 正常</td>
					<td><input type="radio" name="bn_1" value="1" <%if ("1".equals(bn_1)) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
					<td><input type="checkbox" name="bn_2" value="1" <%if ("1".equals(bn_2)) {%>checked<%} %>/>&nbsp;Lump 腫塊 (Size 體積:</td>
					<td><input type="text" name="bn_3" value="<%=bn_3 %>" size=5/>)</td>
					<td><input type="checkbox" name="bn_4" value="1" <%if ("1".equals(bn_4)) {%>checked<%} %>/>&nbsp;Medial 中間</td>
					<td><input type="checkbox" name="bn_5" value="1" <%if ("1".equals(bn_5)) {%>checked<%} %>/>&nbsp;Lateral 外側</td>
					<td><input type="checkbox" name="bn_6" value="1" <%if ("1".equals(bn_6)) {%>checked<%} %>/>&nbsp;Upper 上部</td>
					<td><input type="checkbox" name="bn_7" value="1" <%if ("1".equals(bn_7)) {%>checked<%} %>/>&nbsp;Lower 下部</td>
					<td><input type="checkbox" name="bn_8" value="1" <%if ("1".equals(bn_8)) {%>checked<%} %>/>&nbsp;Quadrant 四分體</td>
				</tr>
				<tr>
				<td>Right 右乳</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td><input type="radio" name="bn_9" value="0" <%if ("0".equals(bn_9) || "".equals(bn_9)) {%>checked<%} %>>&nbsp;Normal 正常</td>
					<td><input type="radio" name="bn_9" value="1" <%if ("1".equals(bn_9)) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
					<td><input type="checkbox" name="bn_10" value="1" <%if ("1".equals(bn_10)) {%>checked<%} %>/>&nbsp;Lump 腫塊 (Size 體積:</td>
					<td><input type="text" name="bn_11" value="<%=bn_11 %>" size=5/>)</td>
					<td><input type="checkbox" name="bn_12" value="1" <%if ("1".equals(bn_12)) {%>checked<%} %>/>&nbsp;Medial 中間</td>
					<td><input type="checkbox" name="bn_13" value="1" <%if ("1".equals(bn_13)) {%>checked<%} %>/>&nbsp;Lateral 外側</td>
					<td><input type="checkbox" name="bn_14" value="1" <%if ("1".equals(bn_14)) {%>checked<%} %>/>&nbsp;Upper 上部</td>
					<td><input type="checkbox" name="bn_15" value="1" <%if ("1".equals(bn_15)) {%>checked<%} %>/>&nbsp;Lower 下部</td>
					<td><input type="checkbox" name="bn_16" value="1" <%if ("1".equals(bn_16)) {%>checked<%} %>/>&nbsp;Quadrant 四分體</td>
				</tr>
				</table>
			</td>
			</tr>
			
					
			</table>
			</td>
		</tr>		
		</table>
	</td>
	</tr>	
	<tr>		
	<td> 
		<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td style="background: #F5A9F2;">
			Respiratory System 呼吸系統
			</td>
		</tr>
		<tr>
			<td>
			<table class="table2">
			<tr>
			<td>
				<table>
				<tr>			
					<td>Breath Sound 呼吸音</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>&nbsp;&nbsp;&nbsp;</td>				
					<td><input type="radio" name="rs_1" value="0" <%if ("0".equals(rs_1) || "".equals(cs_1)) {%>checked<%} %>>&nbsp;Normal 正常</td>
					<td><input type="radio" name="rs_1" value="1" <%if ("1".equals(rs_1)) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
					<td><input type="checkbox" name="rs_2" value="1" <%if ("1".equals(rs_2)) {%>checked<%} %>/>&nbsp;Wheezing 喘嗚</td>
					<td><input type="checkbox" name="rs_11" value="1" <%if ("1".equals(rs_11)) {%>checked<%} %>/>&nbsp;R 右</td>
					<td><input type="checkbox" name="rs_12" value="1" <%if ("1".equals(rs_12)) {%>checked<%} %>/>&nbsp;L 左</td>
				</tr>
				<tr>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>					
					<td><input type="checkbox" name="rs_3" value="1" <%if ("1".equals(rs_3)) {%>checked<%} %>/>&nbsp;Crackling 爆裂聲</td>
					<td><input type="checkbox" name="rs_13" value="1" <%if ("1".equals(rs_13)) {%>checked<%} %>/>&nbsp;R 右</td>
					<td><input type="checkbox" name="rs_14" value="1" <%if ("1".equals(rs_14)) {%>checked<%} %>/>&nbsp;L 左</td>					
				</tr>						
				<tr>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td><input type="checkbox" name="rs_4" value="1" <%if ("1".equals(rs_4)) {%>checked<%} %>/>&nbsp;Diminished 縮小</td>
					<td><input type="checkbox" name="rs_15" value="1" <%if ("1".equals(rs_15)) {%>checked<%} %>/>&nbsp;R 右</td>
					<td><input type="checkbox" name="rs_16" value="1" <%if ("1".equals(rs_16)) {%>checked<%} %>/>&nbsp;L 左</td>								
				</tr>
				</table>
				<table>
				<tr>
					<td>Shape of Chest 胸部形狀</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>				
					<td><input type="radio" name="rs_5" value="0" <%if ("0".equals(rs_5) || "".equals(rs_5)) {%>checked<%} %>>&nbsp;Normal 正常</td>
					<td><input type="radio" name="rs_5" value="1" <%if ("1".equals(rs_5)) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
					<td><input type="checkbox" name="rs_6" value="1" <%if ("1".equals(rs_6)) {%>checked<%} %>/>&nbsp;Barrel 桶狀</td>
					<td><input type="checkbox" name="rs_7" value="1" <%if ("1".equals(rs_7)) {%>checked<%} %>/>&nbsp;Pectus excavatum 漏斗風</td>
				</tr>
				<tr>
					<td>Percussion 叩診</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>				
					<td><input type="radio" name="rs_8" value="0" <%if ("0".equals(rs_8) || "".equals(rs_8)) {%>checked<%} %>>&nbsp;Normal 正常</td>
					<td><input type="radio" name="rs_8" value="1" <%if ("1".equals(rs_8)) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
					<td><input type="checkbox" name="rs_9" value="1" <%if ("1".equals(rs_9)) {%>checked<%} %>/>&nbsp;Impaired 受損</td>
					<td><input type="checkbox" name="rs_10" value="1" <%if ("1".equals(rs_10)) {%>checked<%} %>/>&nbsp;Hyper-resonance 過清音</td>
				</tr>
				</table>
			</td>
			</tr>
			
					
			</table>
			</td>
		</tr>		
		</table>
	</td>
	</tr>	
	<tr>		
	<td> 
		<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td style="background: #F5A9F2;">
			Cardiovascular System 心血管系統
			</td>
		</tr>
		<tr>
			<td>
			<table class="table2">
			<tr>
			<td>
				<table>
				<tr>			
					<td>Apex Beat 心尖搏動</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>				
					<td><input type="radio" name="cs_1" value="0" <%if ("0".equals(cs_1) || "".equals(cs_1)) {%>checked<%} %>>&nbsp;Normal 正常</td>
					<td><input type="radio" name="cs_1" value="1" <%if ("1".equals(cs_1)) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
					<td><input type="text" name="cs_2" value="<%=cs_2 %>" size=100/></td>								
				</tr>
				<tr>
					<td>Peripheral Pulse 外周脈搏</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>				
					<td><input type="radio" name="cs_3" value="0" <%if ("0".equals(cs_3) || "".equals(cs_3)) {%>checked<%} %>>&nbsp;Normal 正常</td>
					<td><input type="radio" name="cs_3" value="1" <%if ("1".equals(cs_3)) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
					<td><input type="text" name="cs_4" value="<%=cs_4 %>" size=100/></td>								
				</tr>
				<tr>
					<td>Neck Veins 頸靜脈</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>				
					<td><input type="radio" name="cs_5" value="0" <%if ("0".equals(cs_5) || "".equals(cs_5)) {%>checked<%} %>>&nbsp;Normal 正常</td>
					<td><input type="radio" name="cs_5" value="1" <%if ("1".equals(cs_5)) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
					<td><input type="text" name="cs_6" value="<%=cs_6 %>" size=100/></td>
				</tr>
				<tr>
					<td>Heart Murmurs 心雜音</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>				
					<td><input type="radio" name="cs_7" value="0" <%if ("0".equals(cs_7) || "".equals(cs_7)) {%>checked<%} %>>&nbsp;Normal 正常</td>
					<td><input type="radio" name="cs_7" value="1" <%if ("1".equals(cs_7)) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
					<td><input type="text" name="cs_8" value="<%=cs_8 %>" size=100/></td>					
				</tr>				
				</table>
			</td>
			</tr>
			
					
			</table>
			</td>
		</tr>		
		</table>
	</td>
	</tr>	
		
	<tr>		
	<td> 
		<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td style="background: #F5A9F2;">
				Neurological Examination 神經系統
				</td>
			</tr>
			<tr>
			<td>
				<table class="table2">
				<tr>
				<td>
	
					<table>
					<tr>
					<td>
						Motor Function 運動功能
					</td>
					</tr>
					<tr>
					<td>	
						<table>
						<tr>
							<td></td>
							<td align="right">Left 左</td>						
							<td><input type="radio" name="ne_1" value="0" <%if ("0".equals(ne_1) || "".equals(ne_1)) {%>checked<%} %>>&nbsp;Normal 正常</td>
							<td><input type="radio" name="ne_1" value="1" <%if ("1".equals(ne_1)) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
							<td><input type="text" name="ne_2" value="<%=ne_2 %>" size=100/></td>
						</tr>
						<tr>
						<td></td>
							<td align="right">Right 右</td>						
							<td><input type="radio" name="ne_3" value="0" <%if ("0".equals(ne_3) || "".equals(ne_3)) {%>checked<%} %>>&nbsp;Normal 正常</td>
							<td><input type="radio" name="ne_3" value="1" <%if ("1".equals(ne_3)) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
							<td><input type="text" name="ne_4" value="<%=ne_4 %>" size=100/></td>
						</tr>
						</table>
					</td>
					</tr>		
					<tr>
					<td>
						Superficial Reflexes 表層反射
					</td>
					</tr>
					<tr>
					<td>	
						<table>
						<tr>
							<td></td>
							<td align="right">Left 左</td>						
							<td><input type="radio" name="ne_5" value="0" <%if ("0".equals(ne_5) || "".equals(ne_5)) {%>checked<%} %>>&nbsp;Normal 正常</td>
							<td><input type="radio" name="ne_5" value="1" <%if ("1".equals(ne_5)) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
							<td><input type="text" name="ne_6" value="<%=ne_6 %>" size=100/></td>
						</tr>
						<tr>
						<td></td>
							<td align="right">Right 右</td>						
							<td><input type="radio" name="ne_7" value="0" <%if ("0".equals(ne_7) || "".equals(ne_7)) {%>checked<%} %>>&nbsp;Normal 正常</td>
							<td><input type="radio" name="ne_7" value="1" <%if ("1".equals(ne_7)) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
							<td><input type="text" name="ne_8" value="<%=ne_8 %>" size=100/></td>
						</tr>
						</table>
					</td>
					</tr>
					<tr>
					<td>
						Sensory Function 知覺功能
					</td>
					</tr>
					<tr>
					<td>	
						<table>
						<tr>
							<td></td>
							<td align="right">Left 左</td>						
							<td><input type="radio" name="ne_9" value="0" <%if ("0".equals(ne_9) || "".equals(ne_9)) {%>checked<%} %>>&nbsp;Normal 正常</td>
							<td><input type="radio" name="ne_9" value="1" <%if ("1".equals(ne_9)) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
							<td><input type="text" name="ne_10" value="<%=ne_10 %>" size=100/></td>
						</tr>
						<tr>
						<td></td>
							<td align="right">Right 右</td>						
							<td><input type="radio" name="ne_11" value="0" <%if ("0".equals(ne_11) || "".equals(ne_11)) {%>checked<%} %>>&nbsp;Normal 正常</td>
							<td><input type="radio" name="ne_11" value="1" <%if ("1".equals(ne_11)) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
							<td><input type="text" name="ne_12" value="<%=ne_12 %>" size=100/></td>
						</tr>
						</table>
					</td>
					</tr>
					<tr>
					<td>
						Deep Tendon Reflexes 深腱反射
					</td>
					</tr>
					<tr>
					<td>	
						<table>
						<tr>
							<td></td>
							<td align="right">Left 左</td>						
							<td><input type="radio" name="ne_13" value="0" <%if ("0".equals(ne_13) || "".equals(ne_13)) {%>checked<%} %>>&nbsp;Normal 正常</td>
							<td><input type="radio" name="ne_13" value="1" <%if ("1".equals(ne_13)) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
							<td><input type="text" name="ne_14" value="<%=ne_14 %>" size=100/></td>
						</tr>
						<tr>
						<td></td>
							<td align="right">Right 右</td>						
							<td><input type="radio" name="ne_15" value="0" <%if ("0".equals(ne_15) || "".equals(ne_15)) {%>checked<%} %>>&nbsp;Normal 正常</td>
							<td><input type="radio" name="ne_15" value="1" <%if ("1".equals(ne_15)) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
							<td><input type="text" name="ne_16" value="<%=ne_16 %>" size=100/></td>
						</tr>
						</table>
					</td>
					</tr>
					<tr>
					<td>
						Cranial Nerves 顱神經
					</td>
					</tr>
					<tr>
					<td>	
						<table>
						<tr>
							<td></td>
							<td align="right">Left 左</td>						
							<td><input type="radio" name="ne_17" value="0" <%if ("0".equals(ne_17) || "".equals(ne_17)) {%>checked<%} %>>&nbsp;Normal 正常</td>
							<td><input type="radio" name="ne_17" value="1" <%if ("1".equals(ne_17)) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
							<td><input type="text" name="ne_18" value="<%=ne_18 %>" size=100/></td>
						</tr>
						<tr>
						<td></td>
							<td align="right">Right 右</td>						
							<td><input type="radio" name="ne_19" value="0" <%if ("0".equals(ne_19) || "".equals(ne_19)) {%>checked<%} %>>&nbsp;Normal 正常</td>
							<td><input type="radio" name="ne_19" value="1" <%if ("1".equals(ne_19)) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
							<td><input type="text" name="ne_20" value="<%=ne_20 %>" size=100/></td>
						</tr>
						</table>
					</td>
					</tr>
					</table>
				</td>
				</tr>
				</table>	
			
			</td>					
			</tr>
		</table>
		</td>
		</tr>
		
	

	<tr>
	<td>
	<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td style="background: #F5A9F2;">
				Spine 背椎
				</td>				
			</tr>
			<tr>
			<td>
				<table class="table2">
				<tr>
				<td>
					<td><input type="radio" name="s_1" value="0" <%if ("0".equals(s_1) || "".equals(s_1)) {%>checked<%} %>>&nbsp;Normal 正常</td>
					<td><input type="radio" name="s_1" value="1" <%if ("1".equals(s_1)) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
					<td><input type="checkbox" name="s_2" value="1" <%if ("1".equals(s_2)) {%>checked<%} %>/>&nbsp;Kyphosis 脊柱後彎</td>
					<td><input type="checkbox" name="s_3" value="1" <%if ("1".equals(s_3)) {%>checked<%} %>/>&nbsp;Lordosis 脊柱前彎</td>
					<td><input type="checkbox" name="s_4" value="1" <%if ("1".equals(s_4)) {%>checked<%} %>/>&nbsp;Scoliosis 脊柱側彎</td>
				</td>
				</tr>
				</table>			
			</td>
			</tr>
	</table>
	</td>
	</tr>


	<tr>
	<td>
	<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td style="background: #F5A9F2;">
					Abdomen 腹部
				</td>
			</tr>
			<tr>
			<td>
				<table class="table2">
					<tr><td>
						<table>
						<tr>
						<td>Shape 形狀</td>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>				
						<td><input type="checkbox" name="a_p0" value="1" <%if ("1".equals(a_p[0])) {%>checked<%} %>/>&nbsp;Flat 扁平</td>
						<td><input type="checkbox" name="a_p1" value="1" <%if ("1".equals(a_p[1])) {%>checked<%} %>/>&nbsp;Scaphoid 舟狀</td>
						<td><input type="checkbox" name="a_p2" value="1" <%if ("1".equals(a_p[2])) {%>checked<%} %>/>&nbsp;Globular 球狀</td>
						<td><input type="checkbox" name="a_p3" value="1" <%if ("1".equals(a_p[3])) {%>checked<%} %>/>&nbsp;Surgical Scar noted 注意到有手術疤痕</td>
						</tr>
						</table>
					</td></tr>
					<tr><td>				
						<table>
						<tr>
						<td>Abnormal Mass 不正常踵塊</td>						
						<td><input type="radio" name="a_p4" value="0" <%if ("0".equals(a_p[4]) || "".equals(a_p[4])) {%>checked<%} %>>&nbsp;No 不</td>
						<td><input type="radio" name="a_p4" value="1" <%if ("1".equals(a_p[4])) {%>checked<%} %>>&nbsp;Yes 是</td>
						<td><input type="text" name="a_p5" value="<%=a_p[5] %>" size=100/></td>
						</tr>
						<tr>
						<td>Tenderness 壓痛</td>
						<td><input type="radio" name="a_p6" value="0" <%if ("0".equals(a_p[6]) || "".equals(a_p[6])) {%>checked<%} %>>&nbsp;No 不</td>
						<td><input type="radio" name="a_p6" value="1" <%if ("1".equals(a_p[6])) {%>checked<%} %>>&nbsp;Yes 是</td>
						<td><input type="text" name="a_p7" value="<%=a_p[7] %>" size=100/></td>
						</tr>
						<tr>
						<td>Liver 肝</td>
						<td><input type="radio" name="a_p8" value="0" <%if ("0".equals(a_p[8]) || "".equals(a_p[8])) {%>checked<%} %>>&nbsp;Not Palpable 未觸及</td>
						<td><input type="radio" name="a_p8" value="1" <%if ("1".equals(a_p[8])) {%>checked<%} %>>&nbsp;Palpable 觸及</td>
						<td><input type="text" name="a_p9" value="<%=a_p[9]%>" size=100/></td>
						</tr>
						<tr>
						<td>Spleen 脾</td>
						<td><input type="radio" name="a_p10" value="0" <%if ("0".equals(a_p[10]) || "".equals(a_p[10])) {%>checked<%} %>>&nbsp;Not Palpable 未觸及</td>
						<td><input type="radio" name="a_p10" value="1" <%if ("1".equals(a_p[10])) {%>checked<%} %>>&nbsp;Palpable 觸及</td>
						<td><input type="text" name="a_p11" value="<%=a_p[11]%>" size=100/></td>
						</tr>
						</table>
					</td></tr>	
					<tr>
					<td>
					<table>
						<tr>
						<td>Kidneys 腎</td>						
						
						<td align="right">Left 左</td>						
						<td><input type="radio" name="a_p12" value="0" <%if ("0".equals(a_p[12]) || "".equals(a_p[12])) {%>checked<%} %>>&nbsp;Not Palpable 未觸及</td>
						<td><input type="radio" name="a_p12" value="1" <%if ("1".equals(a_p[12])) {%>checked<%} %>>&nbsp;Palpable 觸及</td>
						<td><input type="text" name="a_p13" value="<%=a_p[13] %>" size=100/></td>
						</tr>
						<tr>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
						<td align="right">Right 右</td>						
						<td><input type="radio" name="a_p14" value="0" <%if ("0".equals(a_p[14]) || "".equals(a_p[14])) {%>checked<%} %>>&nbsp;Not Palpable 未觸及</td>
						<td><input type="radio" name="a_p14" value="1" <%if ("1".equals(a_p[14])) {%>checked<%} %>>&nbsp;Palpable 觸及</td>
						<td><input type="text" name="a_p15" value="<%=a_p[15] %>" size=100/></td>
						</tr>
					</table>
					</td>
					</tr>
					
					<tr>
					<td>
					<table>
					<tr>
					<td>Hernial Sites 疝門部位</td>				
					<td><input type="radio" name="a_p16" value="0" <%if ("0".equals(a_p[16]) || "".equals(a_p[16])) {%>checked<%} %>>&nbsp;Normal 正常</td>
					<td><input type="radio" name="a_p16" value="1" <%if ("1".equals(a_p[16])) {%>checked<%} %>>&nbsp;Abnormal 不正常:</td>
					<td><input type="checkbox" name="a_p17" value="1" <%if ("1".equals(a_p[17])) {%>checked<%} %>/>&nbsp;Indirect inguinal hernia 腹股溝斜疝</td>
					<td><input type="checkbox" name="a_p32" value="1" <%if ("1".equals(a_p[32])) {%>checked<%} %>/>&nbsp;R 右</td>
					<td><input type="checkbox" name="a_p33" value="1" <%if ("1".equals(a_p[33])) {%>checked<%} %>/>&nbsp;L 左</td>
					</tr>
					<tr>
					<td></td>
					<td></td>
					<td></td>
					<td><input type="checkbox" name="a_p18" value="1" <%if ("1".equals(a_p[18])) {%>checked<%} %>/>&nbsp;Direct inguinal hernia 腹股溝直疝</td>
					<td><input type="checkbox" name="a_p34" value="1" <%if ("1".equals(a_p[34])) {%>checked<%} %>/>&nbsp;R 右</td>
					<td><input type="checkbox" name="a_p35" value="1" <%if ("1".equals(a_p[35])) {%>checked<%} %>/>&nbsp;L 左</td>
					</tr>
					<tr>
					<td></td>
					<td></td>
					<td></td>
					<td><input type="checkbox" name="a_p19" value="1" <%if ("1".equals(a_p[19])) {%>checked<%} %>/>&nbsp;Umbilical hernia 臍疝氣</td>
					<td><input type="checkbox" name="a_p36" value="1" <%if ("1".equals(a_p[36])) {%>checked<%} %>/>&nbsp;R 右</td>
					<td><input type="checkbox" name="a_p37" value="1" <%if ("1".equals(a_p[37])) {%>checked<%} %>/>&nbsp;L 左</td>
					</tr>
					<tr>
					<td></td>
					<td></td>
					<td></td>
					<td><input type="checkbox" name="a_p20" value="1" <%if ("1".equals(a_p[20])) {%>checked<%} %>/>&nbsp;Femoral inguinal hernia 股及腹股溝疝</td>
					<td><input type="checkbox" name="a_p38" value="1" <%if ("1".equals(a_p[38])) {%>checked<%} %>/>&nbsp;R 右</td>
					<td><input type="checkbox" name="a_p39" value="1" <%if ("1".equals(a_p[39])) {%>checked<%} %>/>&nbsp;L 左</td>
					</tr>
					</table>
					</td>
					</tr>
					
					<tr>
					<td>
					<table>
					<tr>
					<td>Ext. Genitalia 外生殖器</td>				
					<td><input type="radio" name="a_p21" value="0" <%if ("0".equals(a_p[21]) || "".equals(a_p[21])) {%>checked<%} %>>&nbsp;Not done 未做</td>
					<td><input type="radio" name="a_p21" value="1" <%if ("1".equals(a_p[21]) || "".equals(a_p[21])) {%>checked<%} %>>&nbsp;Normal 正常</td>
					<td><input type="radio" name="a_p21" value="2" <%if ("2".equals(a_p[21])) {%>checked<%} %>>&nbsp;Abnormal 不正常:</td>
					<td><input type="text" name="a_p22" value="<%=a_p[22]%>" size=100/></td>
					</tr>
					</table>
					</td>
					</tr>
					
					<tr>
					<td>
					<table>
					<tr>
					<td>Rectal Exam 直腸檢查</td>				
					<td><input type="radio" name="a_p23" value="0" <%if ("0".equals(a_p[23]) || "".equals(a_p[23])) {%>checked<%} %>>&nbsp;Not done 未做</td>
					<td><input type="radio" name="a_p23" value="1" <%if ("1".equals(a_p[23])) {%>checked<%} %>>&nbsp;Normal 正常</td>
					<td><input type="radio" name="a_p23" value="2" <%if ("2".equals(a_p[23])) {%>checked<%} %>>&nbsp;Abnormal 不正常:</td>
					<td></td>
					<td><input type="checkbox" name="a_p24" value="1" <%if ("1".equals(a_p[24])) {%>checked<%} %>/>&nbsp;Rectocele 直腸膨出</td>		
					</tr>
					<tr>
					<td></td>		
					<td></td>
					<td></td>
					<td></td>
					<td></td>
					<td><input type="checkbox" name="a_p25" value="1" <%if ("1".equals(a_p[25])) {%>checked<%} %>/>&nbsp;Hemorrhoid 痔瘡:</td>
					<td><input type="checkbox" name="a_p26" value="1" <%if ("1".equals(a_p[26])) {%>checked<%} %>>&nbsp;Ext 外./</td>
					<td><input type="checkbox" name="a_p40" value="1" <%if ("1".equals(a_p[40])) {%>checked<%} %>>&nbsp;Int. 內</td>
					</tr>
					<tr>
					<td></td>		
					<td></td>
					<td></td>
					<td></td>
					<td></td>			
					<td><input type="checkbox" name="a_p27" value="1" <%if ("1".equals(a_p[27])) {%>checked<%} %>/>&nbsp;Enlarged Prostate</td>
					<td><b>(Male Only)</b></td>
					</tr>
					</table>
					</td>
					</tr>
					
					<tr>
					<td>
					<table>
						<tr>
						<td><b>(For Female Only)</b> Vaginal Exam 陰道檢查</td>				
						<td><input type="radio" name="a_p28" value="0" <%if ("0".equals(a_p[28]) || "".equals(a_p[28])) {%>checked<%} %>>&nbsp;Not done 未做</td>
						<td><input type="radio" name="a_p28" value="1" <%if ("1".equals(a_p[28])) {%>checked<%} %>>&nbsp;Normal 正常</td>
						<td><input type="radio" name="a_p28" value="2" <%if ("2".equals(a_p[28])) {%>checked<%} %>>&nbsp;Abnormal 不正常:</td>
						<td></td>
						</tr>
						<tr>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td><input type="checkbox" name="a_p29" value="1" <%if ("1".equals(a_p[29])) {%>checked<%} %>/>&nbsp;Cysto-urethrocele 膀胱尿道突出</td>
						</tr>
						<tr>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td><input type="checkbox" name="a_p30" value="1" <%if ("1".equals(a_p[30])) {%>checked<%} %>/>&nbsp;Cervical erosion 子宮頸糜爛 / Polyp 瘜肉</td>								
						</tr>
						<tr>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td></td>
						<td><input type="checkbox" name="a_p31" value="1" <%if ("1".equals(a_p[31])) {%>checked<%} %>/>&nbsp;Leukorrhoea 白帶</td>
						</tr>
					</table>
					</td>
					</tr>
				</table>
			</td>
			</tr>
	</table>
	</td></tr>
	
	
	<tr>
	<td>
	<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">			
			<tr>
				<td style="background: #F5A9F2;">
					Extremities 四肢
				</td>
			</tr>
			<tr>
			<td>			
				<table class="table2" width="100%">
				<tr>
				<td>
					<table>
					<tr>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>								
					<td><input type="radio" name="ex_1" value="0" <%if ("0".equals(ex_1) || "".equals(ex_1)) {%>checked<%} %>>&nbsp;Normal 正常</td>
					<td><input type="radio" name="ex_1" value="1" <%if ("1".equals(ex_1)) {%>checked<%} %>>&nbsp;Abnormal 不正常</td>
					<td><input type="text" name="ex_2" value="<%=ex_2%>" size=100/></td>
					</tr>
					</table>
				</td>							
				</tr>
				</table>
			</td>
			</tr>
	</table>
	</td>
	</tr>
	
	<tr>
	<td>
	<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">			
			<tr>
			</tr>
			<tr>
			<td>			
				<table class="table2" width="100%">
				<tr>
				<td>
					Remark 附註:					
					<table>
					<tr>
					<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
					<td><textarea name="remark" rows="6" cols="150"><%=remark%></textarea></td>
					</tr>
					</table>
				</td>							
				</tr>
				</table>
			</td>
			</tr>
	</table>
	</td>
	</tr>
	
	
	<%-- start here --%>
	<tr>
	<td>
	<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">			
			<tr>
			<td align="center"><font size="3"><b>Medical Notes 醫療記錄</b></font></td>			
			</tr>
			<tr>
				<td style="background: #F5A9F2;">
					Abnormal
				</td>
			</tr>
			<tr><td>
			<table>
				<tr>
				<td>
				<table>
				<tr>
				<td>
<%		 
		 if ("0".equals(completed)) {
%>				
				<br>Dr Pick List</br>
				<select id="drpicklist6" name="drpicklist3" onchange = "updateText('drpicklist6', 'mn_p14')">
					<option value=""></option>
					<%
					if(resultpl.size() > 0) {
						for (int i=0;i<resultpl.size();i++){ 
							row = (ReportableListObject) resultpl.get(i);
							plkey = row.getValue(0); 
							pldesc = row.getValue(1);
					%>
					<option value="<%=pldesc%>"><%=plkey%></option>									
					<%
						}
					}
					%>				
				</select>
				
				</td>
<%
		}		
%>				
				<td>
				<table>
					<tr>
					<td>Physical Findings 體檢結果:</td>
					</tr>
					<tr>
					<td><textarea id="mn_p14" name="mn_p14" rows="6" cols="150"><%=mn_p[14]%></textarea></td>
					</tr>				
				</table>
				</td>
				</tr>
				</table>
				</td>				
			</tr>
			
			<tr>
				<td>
				<table>
				<tr>
				<td>
<%		 
		 if ("0".equals(completed)) {
%>				
				<br>Dr Pick List</br>
				<select id="drpicklist3" name="drpicklist3" onchange = "updateText('drpicklist3', 'mn_p0')">
					<option value=""></option>
					<%
					if(resultpl.size() > 0) {
						for (int i=0;i<resultpl.size();i++){ 
							row = (ReportableListObject) resultpl.get(i);
							plkey = row.getValue(0); 
							pldesc = row.getValue(1);
					%>
					<option value="<%=pldesc%>"><%=plkey%></option>									
					<%
						}
					}
					%>				
				</select>
				
				</td>
<%
		}		
%>				
				<td>
				<table>
					<tr>
					<td>Laboratory Findings 檢驗結果:</td>
					</tr>
					<tr>
					<td><textarea id="mn_p0" name="mn_p0" rows="6" cols="150"><%=mn_p[0]%></textarea></td>
					</tr>				
				</table>
				</td>
				</tr>
				</table>
				</td>				
			</tr>
			<tr>
				<td>
				<table>
				<tr>
				<td>
<%		 
		 if ("0".equals(completed)) {
%>				
				<br>Dr Pick List</br>
				<select id="drpicklist4" name="drpicklist4" onchange = "updateText('drpicklist4', 'mn_p1')">
					<option value=""></option>
					<%
					if(resultpl.size() > 0) {
						for (int i=0;i<resultpl.size();i++){ 
							row = (ReportableListObject) resultpl.get(i);
							plkey = row.getValue(0); 
							pldesc = row.getValue(1);
					%>
					<option value="<%=pldesc%>"><%=plkey%></option>									
					<%
						}
					}
					%>				
				</select>
				
				</td>
<%
		}		
%>				
				<td>
				<table>
					<tr>
					<td>ECG 靜止心電圖:</td>
					</tr>
					<tr>
					<td><textarea id="mn_p1" name="mn_p1" rows="6" cols="150"><%=mn_p[1]%></textarea></td>
					</tr>				
				</table>
				</td>
				</tr>
				</table>
				</td>				
			</tr>
			
			
			<tr>
				<td>
				<table>
				<tr>
				<td>
<%		 
		 if ("0".equals(completed)) {
%>				
				<br>Dr Pick List</br>
				<select id="drpicklist5" name="drpicklist5" onchange = "updateText('drpicklist5', 'mn_p2')">
					<option value=""></option>
					<%
					if(resultpl.size() > 0) {
						for (int i=0;i<resultpl.size();i++){ 
							row = (ReportableListObject) resultpl.get(i);
							plkey = row.getValue(0); 
							pldesc = row.getValue(1);
					%>
					<option value="<%=pldesc%>"><%=plkey%></option>									
					<%
						}
					}
					%>				
				</select>
				
				</td>
<%
		}		
%>				
				<td>
				<table>
					<tr>
					<td>Treadmill 運動心電圖:</td>
					</tr>
					<tr>
					<td><textarea id="mn_p2" name="mn_p2" rows="6" cols="150"><%=mn_p[2]%></textarea></td>
					</tr>				
				</table>
				</td>
				</tr>
				</table>
				</td>				
			</tr>
			<tr>
			<td>			
			X-ray X光 :
			</td>
			</tr>
			<tr>
			<td>
				<table>
				<tr>
				<td>
<%		 
		 if ("0".equals(completed)) {
%>				
				<br>Dr Pick List</br>
				<select id="drpicklist7" name="drpicklist7" onchange = "updateText('drpicklist7', 'mn_p3')">
					<option value=""></option>
					<%
					if(resultpl.size() > 0) {
						for (int i=0;i<resultpl.size();i++){ 
							row = (ReportableListObject) resultpl.get(i);
							plkey = row.getValue(0); 
							pldesc = row.getValue(1);
					%>
					<option value="<%=pldesc%>"><%=plkey%></option>									
					<%
						}
					}
					%>				
				</select>
<%
		}		
%>				
				</td>
				<td align="right">Chest 胸部:</td>				
				<td><textarea id="mn_p3" name="mn_p3" rows="6" cols="150"><%=mn_p[3]%></textarea></td>
				</tr>
				<tr>
				<td>
<%		 
		 if ("0".equals(completed)) {
%>				
				<br>Dr Pick List</br>
				<select id="drpicklist8" name="drpicklist8" onchange = "updateText('drpicklist8', 'mn_p4')">
					<option value=""></option>
					<%
					if(resultpl.size() > 0) {
						for (int i=0;i<resultpl.size();i++){ 
							row = (ReportableListObject) resultpl.get(i);
							plkey = row.getValue(0); 
							pldesc = row.getValue(1);
					%>
					<option value="<%=pldesc%>"><%=plkey%></option>									
					<%
						}
					}
					%>				
				</select>
<%
		}		
%>				
				</td>
				<td align="right">KUB 泌尿系統:</td>				
				<td><textarea id="mn_p4" name="mn_p4" rows="6" cols="150"><%=mn_p[4]%></textarea></td>
				</tr>
				<tr>
				<td></td>
				<td align="right">Others 其他:</td>
				<td><textarea name="mn_p5" rows="5" cols="150"><%=mn_p[5]%></textarea></td>
				<td>
<%
if (newForm) {
%>				<%--
				Others : <div id='xrayOther'><input type="text" name="xrayOther1" value=""  size="10" /> <input type="text" name="xrayOther2" value=""  size="50" /> <a href="javascript:void(0);" onclick="javascript:return createItem('xrayOther');"><img src="../images/plus.gif" width="10" height="10"></a></div>
				 --%>
<%
} else {
%>

<% if(mn_p[5] != null){
	String[] outer =mn_p[5].split("<outer>");
//	System.out.println("mn_p[5] : " +  mn_p[5]);
%>
	<%--
	Others : <div id='xrayOther'>
	 --%>
<%
	for(int i=0; i<outer.length;i++){	
%>		
	
<%
		if(i!= 0){
%>
			<p id='<%=i+100%>test'>
<%			
		}
		String[] inner = outer[i].split("<inner>");
		for(int k=0; k < inner.length; k ++){
			if(k == 0){
%>
 				<%-- 
				<input type="text" name="xrayOther1" value="<%=inner[k] %>"  size="20" />
				--%>
				<%
				if  ((mn_p[5] == null) || (mn_p[5].isEmpty())) {
				%>	
				<%--	
					<input type="text" name="xrayOther2" value="<%=inner[k] %>"  size="100" />
					--%>
				<%
				}
				%>
<%			} else { %>
				<%--
				<input type="text" name="xrayOther2" value="<%=inner[k] %>"  size="100" />
					--%> 				
<%			}
		}
		
		if(i == 0){
%>
		
		<%--
		<a href="javascript:void(0);" onclick="javascript:return createItem('xrayOther');"><img src="../images/plus.gif" width="10" height="10"></a>
		 --%>
<%		
		} else {
%>
		<%--
		<a href='javascript:void(0);' onclick='javascript:return remove(<%=i+100%>);'><img src='../images/minus.gif' width='10' height='10'></a>
		 --%>
<%			
		}
	}
%>
	</div>
<%
}
%>
<%
}
%>
				</td>
				</tr>
				</table>
			</td>
			</tr>
			<tr>
			<td>			
			Ultrasound 超聲波:
			</td>
			</tr>
			<tr>
			<td>
				<table>
				<tr>
				<td>
<%		 
		 if ("0".equals(completed)) {
%>				
				<br>Dr Pick List</br>
				<select id="drpicklist11" name="drpicklist11" onchange = "updateText('drpicklist11', 'mn_p6')">
					<option value=""></option>
					<%
					if(resultpl.size() > 0) {
						for (int i=0;i<resultpl.size();i++){ 
							row = (ReportableListObject) resultpl.get(i);
							plkey = row.getValue(0); 
							pldesc = row.getValue(1);
					%>
					<option value="<%=pldesc%>"><%=plkey%></option>									
					<%
						}
					}
					%>				
				</select>
<%
		}		
%>								
				</td>
				
				<td align="right">Abdomen 腹部:</td>				
				<td><textarea id="mn_p6" name="mn_p6" rows="3" cols="150"><%=mn_p[6]%></textarea></td>
				</tr>
				<tr>
								<td>
<%		 
		 if ("0".equals(completed)) {
%>				
				<br>Dr Pick List</br>
				<select id="drpicklist12" name="drpicklist12" onchange = "updateText('drpicklist12', 'mn_p7')">
					<option value=""></option>
					<%
					if(resultpl.size() > 0) {
						for (int i=0;i<resultpl.size();i++){ 
							row = (ReportableListObject) resultpl.get(i);
							plkey = row.getValue(0); 
							pldesc = row.getValue(1);
					%>
					<option value="<%=pldesc%>"><%=plkey%></option>									
					<%
						}
					}
					%>				
				</select>
<%
		}		
%>								
				</td>
				
				<td align="right">Reproductive System 生殖系統:</td>								
				<td><textarea id="mn_p7" name="mn_p7" rows="3" cols="150"><%=mn_p[7]%></textarea></td>
				</tr>
				
				<tr>
				<td></td>
				<td align="right">Others 其他:</td>
				<td><textarea name="mn_p8" rows="5" cols="150"><%=mn_p[8]%></textarea></td>				
				
				<td>
<%
if (newForm) {
%>				
				<%-- 
				Others : <div id='ultraOther'><input type="text" name="ultraOther1" value=""  size="10" /> <input type="text" name="ultraOther2" value=""  size="50" /> <a href="javascript:void(0);" onclick="javascript:return createItem('ultraOther');"><img src="../images/plus.gif" width="10" height="10"></a></div>
				--%>
<%
} else {
%>

<% if(mn_p[8] != null){
	String[] outer =mn_p[8].split("<outer>");
//	System.out.println("mn_p[8] : " +  mn_p[8]);
%>
	<%--
	Others : <div id='ultraOther'>
	 --%>
<%
	for(int i=0; i<outer.length;i++){	
%>		
	
<%
		if(i!= 0){
%>
			<p id='<%=i+100%>test'>
<%			
		}
		String[] inner = outer[i].split("<inner>");
		for(int k=0; k < inner.length; k ++){
			if(k == 0){
%>
				<%--
				<input type="text" name="ultraOther1" value="<%=inner[k] %>"  size="20" />
				 --%>
				<%
				if  ((mn_p[8] == null) || (mn_p[8].isEmpty())) {
				%>
				<%--		
					<input type="text" name="ultraOther2" value="<%=inner[k] %>"  size="100" />
				 --%>					
				<%
				}
				%>
<%			} else { %>
				<%--
				<input type="text" name="ultraOther2" value="<%=inner[k] %>"  size="100" />
				 --%> 				
<%			}
		}
		
		if(i == 0){
%>
		<%--
		<a href="javascript:void(0);" onclick="javascript:return createItem('ultraOther');"><img src="../images/plus.gif" width="10" height="10"></a>
		 --%>
<%		
		} else {
%>
		<%--
		<a href='javascript:void(0);' onclick='javascript:return remove(<%=i+100%>);'><img src='../images/minus.gif' width='10' height='10'></a>
		 --%>
<%			
		}
	}
%>
	</div>
<%
}
%>
<%
}
%>

				</td>
				</tr>
				</table>
			</td>
			</tr>
			<tr>
			<td>			
			Miscellaneous Items 其他項目:
			</td>
			</tr>
			<tr>
			<td>
				<table>
				<tr>
				<td>
<%		 
		 if ("0".equals(completed)) {
%>				
				<br>Dr Pick List</br>
				<select id="drpicklist9" name="drpicklist9" onchange = "updateText('drpicklist9', 'mn_p11')">
					<option value=""></option>
					<%
					if(resultpl.size() > 0) {
						for (int i=0;i<resultpl.size();i++){ 
							row = (ReportableListObject) resultpl.get(i);
							plkey = row.getValue(0); 
							pldesc = row.getValue(1);
					%>
					<option value="<%=pldesc%>"><%=plkey%></option>									
					<%
						}
					}
					%>				
				</select>
<%
		}		
%>								
				</td>
				<td align="right">Bone Densitometry 骨質密度:</td>				
				<td><textarea id="mn_p11" name="mn_p11" rows="5" cols="150"><%=mn_p[11]%></textarea></td>
				</tr>
				<tr>
				<td>
<%		 
		 if ("0".equals(completed)) {
%>				
				<br>Dr Pick List</br>
				<select id="drpicklist10" name="drpicklist10" onchange = "updateText('drpicklist10', 'mn_p12')">
					<option value=""></option>
					<%
					if(resultpl.size() > 0) {
						for (int i=0;i<resultpl.size();i++){ 
							row = (ReportableListObject) resultpl.get(i);
							plkey = row.getValue(0); 
							pldesc = row.getValue(1);
					%>
					<option value="<%=pldesc%>"><%=plkey%></option>									
					<%
						}
					}
					%>
				</select>
<%
		}		
%>				
				</td>
				<td>
				<table>
				<tr>
				<td align="right">Mammogram 乳房X光造影   /  </td>
				</tr>
				<tr>
				<td align="right">Ultrasound Breast 乳房超聱波:</td>
				</tr>
				</table>
				</td>
												
				<td><textarea id="mn_p12" name="mn_p12" rows="5" cols="150"><%=mn_p[12]%></textarea></td>
				</tr>
				<tr>
				<td></td>
				<td align="right">Others 其他:</td>				
				<td><textarea name="mn_p13" rows="5" cols="150"><%=mn_p[13]%></textarea></td>
				</tr>
				</table>
			</td>
			</tr>
			</table>
			</td></tr>
			<tr>
				<td style="background: #F5A9F2;">
					Summary 總結:
				</td>
			</tr>
			<tr>
			<td>
				<table>
				<tr>
				<td>
<%		 
		 if ("0".equals(completed)) {
%>
				<br>Dr Pick List</br>
				<select id="drpicklist1" name="drpicklist1" onchange = "updateText('drpicklist1', 'mn_p9')">Dr PickList
					<option value=""></option>
					<%
					if(resultpl.size() > 0) {
						for (int i=0;i<resultpl.size();i++){ 
							row = (ReportableListObject) resultpl.get(i);
							plkey = row.getValue(0); 
							pldesc = row.getValue(1);
					%>
					<option value="<%=pldesc%>"><%=plkey%></option>
					<%
						}
					}
					%>				
				</select>
				</td>
<%		 
		 }
%>
				<td><textarea id="mn_p9" name="mn_p9" rows="6" cols="150"><%=mn_p[9]%></textarea></td>
				</tr>
				</table>
			</td>
			</tr>
			<tr>
				<td style="background: #F5A9F2;">
					Recommendations 建議:
				</td>
			</tr>
			<tr>
			<td>
				<table>
				<tr>
				<td>
<%		 
		 if ("0".equals(completed)) {
%>				
				<br>Dr Pick List</br>
				<select id="drpicklist2" name="drpicklist2" onchange = "updateText('drpicklist2', 'mn_p10')">
					<option value=""></option>
					<%
					if(resultpl.size() > 0) {
						for (int i=0;i<resultpl.size();i++){ 
							row = (ReportableListObject) resultpl.get(i);
							plkey = row.getValue(0); 
							pldesc = row.getValue(1);
					%>
					<option value="<%=pldesc%>"><%=plkey%></option>									
					<%
						}
					}
					%>				
				</select>
				
				</td>
<%
		}
%>
				<td><textarea id="mn_p10" name="mn_p10" rows="6" cols="150"><%=mn_p[10]%></textarea></td>				
				</tr>
				</table>
			</td>
			</tr>
	</table>
	</td>
	</tr>
	<%-- end here --%>
	<tr>
	<td>
	<table>
	<tr>
		<td>
		Doctor : <%=" " + docName %>
		</td>
	
	</tr>
	<tr>
	<td>		
		Report Status:
	
	<%
			//if (isMRStaff) {
	%>
	<%--
		<input type="radio" name="completed" value="1" <%if ("1".equals(completed) || "".equals(completed)) {%>checked<%} %>>&nbsp;Completed
		<input type="radio" name="completed" value="0" <%if ("0".equals(completed)) {%>checked<%} %>>&nbsp;To be completed
	 --%>	
	<%
			//} else {
	%>
			<% 
				if ("0".equals(completed)) {
			%>
					To be completed
			<%
				} else if ("1".equals(completed)) { 
			%>
					Completed	
			<%
				}
			%>			
	<%
			//}
	%>
	
	<%
		}	
	%>
	</td>
	</tr>
	</table>		
	</tr>			
	</table>
	</td>
	</tr>	
	<!-- 
	html code goes 
	-->	
	<tr>
	<td>
	<table width="100%" border=0>
		<tr><td align="center">	
	<% 
		if ("0".equals(completed)) {
	%>
	
	
		<%
			if (patientMode) {
		%>		

		<button onclick="return showconfirm('save_form');">
			儲存 Save
		</button>
		</td></tr>
		<%
			}
		%>
		<%
			if (nurseMode) {
		%>		
		<tr><td align="center">
		<button onclick="return showconfirm('save_form');">
			Save Form
		</button>
		
		<%
			}
		%>
	
	<% 
		}
	%>
	
		<%
			if (!patientMode) {
		%>
		<button onclick="return printReport('pdfAction', '<%=haID %>');">
			Print
		</button>		
		<%
			}
		%>
		
	
		<%
			if (isMRStaff) {
		%>
		<button onclick="return showconfirm('complete_form');">
			<%if ("0".equals(completed)) { %>Set Form Completed<% } else {%>Set Form Incompleted<%}%>
		</button>
		<%
			}
		%>
		</td>
		</tr>
	</table>
	</td>
	</tr>
</table>

<input type="hidden" name="command" value="<%=command%>"/>
<input type="hidden" name="staffID" value="<%=staffID%>"/>
<input type="hidden" name="regID" value="<%=regID%>"/>
<input type="hidden" name="seqNo" value="<%=seqNo%>"/>
<input type="hidden" name="patNo" value="<%=patNo%>"/>
<input type="hidden" name="completed" value="<%=completed%>"/>

</form>
</div>
</div>
</DIV>
</DIV>

<%--
<div  class="push"></div>
--%>
<%--
 <table  width="100%" border="0" cellpadding="0" cellspacing="0">
<tr>
	<td>&nbsp;</td>
</tr>
</table>
 --%>

<%--
<jsp:include page="../registration/admission_footer.jsp" flush="false" />
--%>
<script language="javascript">

var i = 1;
function createItem(divname){
	//alert(divname);
	if (divname == 'ultraOther') {
	     $("<p id='"+i+"test'><input type='text' name='ultraOther1' size='20' /> <input type='text' name='ultraOther2' size='100' /> <a href='javascript:void(0);' onclick='javascript:return remove("+i+");'><img src='../images/minus.gif' width='10' height='10'></a></p>").appendTo('div#ultraOther');		
	} else if (divname == 'xrayOther') {
		$("<p id='"+i+"test'><input type='text' name='xrayOther1' size='20' /> <input type='text' name='xrayOther2' size='100' /> <a href='javascript:void(0);' onclick='javascript:return remove("+i+");'><img src='../images/minus.gif' width='10' height='10'></a></p>").appendTo('div#xrayOther');		
	} else if (divname == 'otherOther') {
		$("<p id='"+i+"test'><input type='text' name='otherOther1' size='20' /> <input type='text' name='otherOther2' size='100' /> <a href='javascript:void(0);' onclick='javascript:return remove("+i+");'><img src='../images/minus.gif' width='10' height='10'></a></p>").appendTo('div#otherOther');		
	}
     i++;
     return false;
}

function remove(removeID){ 
     var id = removeID + 'test';
     $( "#" + id ).remove();
     return false;
}

function printReport(action, haID) {
	if(action == 'pdfAction') {					
		callPopUpWindow("print_report.jsp?command="+action+"&haID="+haID);
	}	
	return false;
}

function updateText(pickname, editname){
    var input = $('#' + editname);
    input.val(input.val() + $('#' + pickname).find(":selected").attr('value') + '\n');
    
}

function showconfirm(cmd) {
	var msg = '';

	if (cmd == 'save_form') {
		msg = 'Are you sure to save this record ?\n確定儲存 ?\n';
	} else if (cmd == 'complete_form') {
		msg = 'Are you sure ?';
	}
	$.prompt(msg, {
		buttons: { Ok: true, Cancel: false },
		callback: function(v,m,f){
			if (v ){
				submitAction(cmd);								
			}
		},
		prefix:'cleanblue'
	});
	return false;
}

function submitAction(cmd) {
	var msg = '';
	//if (document.form1.q1.value == '') {
		//msg = msg + '請輸入主要申訴\nPlease input Present Chief Complaints\n';
		//alert(msg);
		//$("input[name=patNo]").focus();
		//$("textarea[name=q1]").focus();
		//// alert($(focusField).css());
		//return false;
	//} else {
		//alert('Saving.....' + cmd);
		document.form1.command.value = cmd;		
		document.form1.submit();
	//}
}

$(document).ready(function() {
	$("textarea[name=q1]").focus();
	
	ReadonlyForm(<%if ("1".equals(completed)) {%>true<%} else {%>false<%} %>);
	<%
	//System.out.println("finishSaving : " + finishSaving);
	if (finishSaving){
	%>
		alert('Form Saved')
	<%	
	}
	%>
	});


function ReadonlyForm(Formcomplete){
	
	if (Formcomplete) {
		$('div.career_form input[type=text]').attr("readonly","readonly");
		$("div.career_form input:radio").attr('disabled',true);
		$("div.career_form input[type=checkbox]").attr('disabled',true);
		$('div.career_form textarea').attr("readonly","readonly");
	}

	return true;
}


function changeLang(lang){
	alert(document.form1.action);
	return false;
}

function closeAction() {
	//var yes = confirm("Are you sure to close this page?\nThe admission form will be removed.");
	var yes = true;
	if (yes) {
		window.open('', '_self', '');
		window.close();
	}
}

function checkSelect_tmp() {
    if ($("input[id='1']:checked").val()) {
         if ($("input[id='7']:checked").val() ||
        	 $("input[id='8']:checked").val() ||
        	 $("input[id='9']:checked").val() ||
        	 $("input[id='10']:checked").val()) {
                jQuery("#2").attr('checked', $("input[id='7']:checked").val());
                jQuery("#3").attr('checked', $("input[id='8']:checked").val());
                jQuery("#4").attr('checked', $("input[id='9']:checked").val());
                jQuery("#5").attr('checked', $("input[id='10']:checked").val());
             	jQuery("#7").attr('checked', false);
             	jQuery("#8").attr('checked', false);
             	jQuery("#9").attr('checked', false);
             	jQuery("#10").attr('checked', false);                
         }
    } else if ($("input[id='6']:checked").val()) {
         if ($("input[id='2']:checked").val() ||
        	 $("input[id='3']:checked").val() ||
        	 $("input[id='4']:checked").val() ||
        	 $("input[id='5']:checked").val()) {
                jQuery("#7").attr('checked', $("input[id='2']:checked").val());
                jQuery("#8").attr('checked', $("input[id='3']:checked").val());
                jQuery("#9").attr('checked', $("input[id='4']:checked").val());
                jQuery("#10").attr('checked', $("input[id='5']:checked").val());
             	jQuery("#2").attr('checked', false);
             	jQuery("#3").attr('checked', false);
             	jQuery("#4").attr('checked', false);
             	jQuery("#5").attr('checked', false);
         }
    }           
}

function checkSelect2_tmp() {
	if ($("input[id='2']:checked").val() ||
			$("input[id='3']:checked").val() ||
			$("input[id='4']:checked").val()||
			$("input[id='5']:checked").val()) {
           jQuery("#1").attr('checked', true);
           jQuery("#6").attr('checked', false);
   } else if ($("input[id='7']:checked").val() ||
		   $("input[id='8']:checked").val() ||
		   $("input[id='9']:checked").val() ||
		   $("input[id='10']:checked").val()) {
	   jQuery("#1").attr('checked', false);
       jQuery("#6").attr('checked', true);
   }           

}
</script>
<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>