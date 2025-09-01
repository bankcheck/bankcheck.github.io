<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="org.apache.struts.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.util.db.UtilDBWeb"%>

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
//String formType = "";
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
String q3_g4 = "";
String q3_g5 = "";
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
String smoke_7 = "";
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
String drink_15 = "";
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
String sleep_3 = "";
String sleep_4 = "";
String sleep_5 = "";
String sleep_6 = "";
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
String phy_21 = "";
String phy_22 = "";
String phy_23 = "";
String phy_24 = "";
String phy_25 = "";
String phy_26 = "";

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
String gc_16 = "";
String gc_17 = "";
//
String[] ent_p = new String[58];
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

//String ne_1 = "";
//String ne_2 = "";
//String ne_3 = "";
//String ne_4 = "";
//String ne_5 = "";
//String ne_6 = "";
//String ne_7 = "";
//String ne_8 = "";
//String ne_9 = "";
//String ne_10 = "";
//String ne_11 = "";
//String ne_12 = "";
//String ne_13 = "";
//String ne_14 = "";
//String ne_15 = "";
//String ne_16 = "";
//String ne_17 = "";
//String ne_18 = "";
//String ne_19 = "";
//String ne_20 = "";
String[] ne_p = new String[20];
String s_1 = "";
String s_2 = "";
String s_3 = "";
String s_4 = "";
String[] a_p = new String[47];
String[] mn_p = new String[120];
String completed = "0";
String remark = "";
int cnt = 0;
String ex_1 = "";
String ex_2 = "";
String createDate = "";
String createTime = "";
String createmm = "";
String createhh = "";
String q3_a5 = "";
String q3_a6 = "";
String q3_a7 = "";
String q3_b4 = "";
String q3_b5 = "";
String q3_b6 = "";
String q3_d5 = "";
String q3_d6 = "";
String q3_e2 = "";
String q3_e3 = "";
String q3_e4 = "";
String q3_f5 = "";
String q3_f6 = "";
String q3_f7 = "";
String q3_h2 = "";
String q3_i1 = "";
String q5_a7 = "";
String q5_a8 = "";
//
String female_11 = "";
String female_12 = "";
//
String q3_d7 = "";
String q3_d8 = "";
String q3_d9 = "";
String q3_d10 = "";
String q3_d11 = "";
//
String eat_15 = "";
String eat_16 = "";
String eat_17 = "";
String eat_18 = "";
String eat_19 = "";
String eat_20 = "";
String eat_21 = "";
String eat_22 = "";
String eat_23 = "";
String eat_24 = "";
//
String ccr_phase = "";
String formTypeOther = "";

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
String formType = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "formType"));
String regDate = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "regDate"));

String patName = "";
String patCName = "";
String patAge = "";
String patSex = "";
String patDob = "";

//20250219 Arran added patConNo								
String patConNo = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patConNo"));				
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

//for detail entry
String reqStatus = TextUtil.parseStrUTF8((String) request.getAttribute("reqStatus"));
String amtID = TextUtil.parseStrUTF8((String) request.getAttribute("amtID"));
//


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
if ("NORMAL".equals(formType)) {
	formType = null;
}

if (HAFormDB.isNewHAForm(patNo, regID, formType)) {
	newForm = true;
	haID = HAFormDB.getHALastestFormID(patNo, formType);
} else {
	newForm = false;
	haID = HAFormDB.getHAFormID(patNo, regID, formType);
}

if (formType == null) {
	formType = "NORMAL";
}
System.out.println("formType : " + formType);
System.out.println("newForm : " + newForm);
System.out.println("haid : " + haID);

result = HAFormDB.fetchAccessForm(haID);
if(result.size() > 0) {
	row = (ReportableListObject) result.get(0);
	//regID = row.getValue(287);
	haID = row.getValue(1);
	//formType = row.getValue(3);
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
	phy_21 = row.getValue(389);
	phy_22 = row.getValue(390);
	phy_23 = row.getValue(391);
	phy_24 = row.getValue(392);
	phy_25 = row.getValue(393);
	phy_26 = row.getValue(504);
	//
	q3_a5 = row.getValue(343);
	q3_a6 = row.getValue(344);
	q3_a7 = row.getValue(394);
	q3_b4 = row.getValue(345);
	q3_b5 = row.getValue(346);
	q3_b6 = row.getValue(395);
	q3_d5 = row.getValue(347);
	q3_d6 = row.getValue(348);
	q3_e2 = row.getValue(349);
	q3_e3 = row.getValue(350);
	q3_e4 = row.getValue(398);
	q3_f5 = row.getValue(351);
	q3_f6 = row.getValue(352);
	q3_f7 = row.getValue(397);
	q3_h2 = row.getValue(353);
	q3_i1 = row.getValue(354);
	q5_a7 = row.getValue(355);
	q5_a8 = row.getValue(399);
	//
	female_11 = row.getValue(356);
	female_12 = row.getValue(357);
	//
	q3_d7 = row.getValue(358);
	q3_d8 = row.getValue(359);
	q3_d9 = row.getValue(360);
	q3_d10 = row.getValue(361);
	q3_d11 = row.getValue(396);
	//
	eat_15 = row.getValue(362);
	eat_16 = row.getValue(363);
	eat_17 = row.getValue(368);
	eat_18 = row.getValue(369);
	eat_19 = row.getValue(370);
	eat_20 = row.getValue(371);
	eat_21 = row.getValue(372);
	eat_22 = row.getValue(373);
	eat_23 = row.getValue(380);
	eat_24 = row.getValue(381);
	//
	drink_15 = row.getValue(374);
	smoke_7 = row.getValue(382);
	sleep_3 = row.getValue(383);
	sleep_4 = row.getValue(384);
	sleep_5 = row.getValue(385);
	sleep_6 = row.getValue(386);
	//
	ent_p[56] = row.getValue(387);
	ent_p[57] = row.getValue(407);
	//a_p[43] = row.getValue(388);

	ccr_phase = row.getValue(466);
//20250219 Arran added patConNo	
	patConNo = row.getValue(506);

	modifyDate = row.getValue(365);
	modifyTime = row.getValue(366);
	modifyUser = row.getValue(367);
	//
	// 12-12-2016
	//docCode = row.getValue(333);
	//docName = HAFormDB.getRegDocName(docCode);


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
		gc_16 = row.getValue(400);
		gc_17 = row.getValue(401);

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

		//ne_1 = row.getValue(218);
		//ne_2 = row.getValue(219);
		//ne_3 = row.getValue(220);
		//ne_4 = row.getValue(221);
		//ne_5 = row.getValue(222);
		//ne_6 = row.getValue(223);
		//ne_7 = row.getValue(224);
		//ne_8 = row.getValue(225);
		//ne_9 = row.getValue(226);
		//ne_10 = row.getValue(227);
		//ne_11 = row.getValue(228);
		//ne_12 = row.getValue(229);
		//ne_13 = row.getValue(230);
		//ne_14 = row.getValue(231);
		//ne_15 = row.getValue(232);
		//ne_16 = row.getValue(233);
		//ne_17 = row.getValue(234);
		//ne_18 = row.getValue(235);
		//ne_19 = row.getValue(236);
		//ne_20 = row.getValue(237);
		ne_p[0] = row.getValue(218);
		ne_p[1] = row.getValue(219);
		ne_p[2] = row.getValue(220);
		ne_p[3] = row.getValue(221);
		ne_p[4] = row.getValue(222);
		ne_p[5] = row.getValue(223);
		ne_p[6] = row.getValue(224);
		ne_p[7] = row.getValue(225);
		ne_p[8] = row.getValue(226);
		ne_p[9] = row.getValue(227);
		ne_p[10] = row.getValue(228);
		ne_p[11] = row.getValue(229);
		ne_p[12] = row.getValue(230);
		ne_p[13] = row.getValue(231);
		ne_p[14] = row.getValue(232);
		ne_p[15] = row.getValue(233);
		ne_p[16] = row.getValue(234);
		ne_p[17] = row.getValue(235);
		ne_p[18] = row.getValue(236);
		ne_p[19] = row.getValue(237);


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
		a_p[41] = row.getValue(376);
		a_p[42] = row.getValue(377);
		a_p[43] = row.getValue(388);
		a_p[44] = row.getValue(402);
		a_p[45] = row.getValue(403);
		a_p[46] = row.getValue(404);
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
		mn_p[15] = row.getValue(375);
		mn_p[16] = row.getValue(378);
		mn_p[17] = row.getValue(379);



		mn_p[30] = row.getValue(420);
		mn_p[61] = row.getValue(451);
		mn_p[62] = row.getValue(452);
		mn_p[63] = row.getValue(453);
		mn_p[64] = row.getValue(454);
		mn_p[65] = row.getValue(455);
		mn_p[66] = row.getValue(456);
		mn_p[67] = row.getValue(457);
		mn_p[68] = row.getValue(458);
		mn_p[36] = row.getValue(426);
		mn_p[38] = row.getValue(428);
		mn_p[39] = row.getValue(429);
		//mn_p[40] = row.getValue(430);
		//
		mn_p[69] = row.getValue(459);
		mn_p[70] = row.getValue(460);
		mn_p[71] = row.getValue(461);
		mn_p[72] = row.getValue(462);
		mn_p[73] = row.getValue(463);
		mn_p[74] = row.getValue(464);
		mn_p[75] = row.getValue(465);
		//
		mn_p[76] = row.getValue(467);
		mn_p[77] = row.getValue(468);
		mn_p[78] = row.getValue(469);
		mn_p[79] = row.getValue(470);
		//
		mn_p[41] = row.getValue(431);
		mn_p[42] = row.getValue(432);
		mn_p[43] = row.getValue(433);
		mn_p[44] = row.getValue(434);
		mn_p[45] = row.getValue(435);
		mn_p[46] = row.getValue(436);
		mn_p[47] = row.getValue(437);
		mn_p[48] = row.getValue(438);
		//
		mn_p[49] = row.getValue(439);
		mn_p[50] = row.getValue(440);
		mn_p[51] = row.getValue(441);
		mn_p[52] = row.getValue(442);
		mn_p[53] = row.getValue(443);
		//
		mn_p[54] = row.getValue(444);
		mn_p[55] = row.getValue(445);
		mn_p[56] = row.getValue(446);
		mn_p[57] = row.getValue(447);
		mn_p[58] = row.getValue(448);
		mn_p[59] = row.getValue(449);
		mn_p[60] = row.getValue(450);
		//
		mn_p[96] = row.getValue(487);
		//
		mn_p[97] = row.getValue(488);
		mn_p[98] = row.getValue(489);
		mn_p[99] = row.getValue(490);
		mn_p[100] = row.getValue(491);
		mn_p[101] = row.getValue(492);
		mn_p[102] = row.getValue(493);
		mn_p[103] = row.getValue(494);
		mn_p[104] = row.getValue(495);
		mn_p[105] = row.getValue(496);
		mn_p[106] = row.getValue(499);
		mn_p[107] = row.getValue(500);


		// Progress of Previous Goals 較早前的目標之進展:
		mn_p[85] = row.getValue(476);
		mn_p[86] = row.getValue(477);
		mn_p[87] = row.getValue(478);
		mn_p[88] = row.getValue(479);
		mn_p[89] = row.getValue(480);
		mn_p[90] = row.getValue(481);
		mn_p[91] = row.getValue(482);
		mn_p[92] = row.getValue(483);
		mn_p[93] = row.getValue(484);
		mn_p[94] = row.getValue(485);
		mn_p[95] = row.getValue(486);
		//

		q3_g4 = row.getValue(405);
		q3_g5 = row.getValue(406);

		//q3_h1 = row.getValue(332);
		// remark 21-12-2016
		//docCode = row.getValue(333);
		docCode = HAFormDB.getRegDocCode(regID);
		docName = HAFormDB.getRegDocName(regID);

		// 19-06-2017
		if (("".equals(docCode)) || docCode == null) {
			docCode = row.getValue(333);
			docName = row.getValue(340);
		}

		createDate = row.getValue(334);
		createTime = row.getValue(335);
		createhh = createTime.substring(0, 2);
		createmm = createTime.substring(3, 5);
		//15:31:03
		System.out.println(createTime);
		System.out.println(createTime.substring(0, 2));
		System.out.println(createTime.substring(3, 5));

		remark = row.getValue(327);

		formTypeOther = row.getValue(497);
		patAge = row.getValue(498);
	}

	if (newForm) {

		// load p1 fields to p2
		if ("CCRP3".equals(formType)) {
			mn_p[36] = row.getValue(463);
			mn_p[38] = row.getValue(464);
			mn_p[39] = row.getValue(465);
			mn_p[61] = row.getValue(452);
			mn_p[85] = row.getValue(488);
			mn_p[87] = row.getValue(489);
			mn_p[89] = row.getValue(490);
			mn_p[91] = row.getValue(491);
			mn_p[93] = row.getValue(492);
			mn_p[95] = row.getValue(493);
		} else if ("CCRP2".equals(formType)) {
			mn_p[36] = row.getValue(426);
			mn_p[38] = row.getValue(428);
			mn_p[39] = row.getValue(429);
			//mn_p[40] = row.getValue(430);

			mn_p[61] = row.getValue(421);
			mn_p[85] = row.getValue(430);
			mn_p[87] = row.getValue(471);
			mn_p[89] = row.getValue(472);
			mn_p[91] = row.getValue(473);
			mn_p[93] = row.getValue(474);
			mn_p[95] = row.getValue(475);
		}
		//

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
			docCode = HAFormDB.getRegDocCode(regID);
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
			phy_21 = "";
			phy_22 = "";
			phy_23 = "";
			phy_24 = "";
			phy_25 = "";
			phy_26 = "";
		}
		q1 =  "Routine Checking 一般身體檢查";
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
		docCode = HAFormDB.getRegDocCode(regID);
		docName = HAFormDB.getRegDocName(regID);
	}
	q1 =  "Routine Checking 一般身體檢查";
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
	phy_21 = "";
	phy_22 = "";
	phy_23 = "";
	phy_24 = "";
	phy_25 = "";
	phy_26 = "";
	System.out.println("regDate : " + regDate);
	if ((regDate != "") && (regDate != null)) {
		createDate = regDate;
	}
	else {
		regDate = DateTimeUtil.getCurrentDateTime().substring(0, 10);
		createDate = DateTimeUtil.getCurrentDateTime().substring(0, 10);
	}
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
for (int i=0;i<ne_p.length;i++){
	if (ne_p[i]==null ||"null".equals(ne_p[i])){
		ne_p[i] = "";
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
	q3_g4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_g4"));
	q3_g5 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_g5"));
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
	smoke_7 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "smoke_7"));
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
	sleep_3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "sleep_3"));
	sleep_4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "sleep_4"));
	sleep_5 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "sleep_5"));
	sleep_6 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "sleep_6"));
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
	phy_21 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "phy_21"));
	phy_22 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "phy_22"));
	phy_23 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "phy_23"));
	phy_24 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "phy_24"));
	phy_25 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "phy_25"));
	phy_26 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "phy_26"));


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
	gc_16 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "gc_16"));
	gc_17 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "gc_17"));

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
	ent_p[56] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_56"));
	ent_p[57] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ent_57"));

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

	ne_p[0] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_p0"));
	ne_p[1] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_p1"));
	ne_p[2] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_p2"));
	ne_p[3] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_p3"));
	ne_p[4] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_p4"));
	ne_p[5] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_p5"));
	ne_p[6] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_p6"));
	ne_p[7] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_p7"));
	ne_p[8] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_p8"));
	ne_p[9] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_p9"));
	ne_p[10] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_p10"));
	ne_p[11] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_p11"));
	ne_p[12] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_p12"));
	ne_p[13] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_p13"));
	ne_p[14] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_p14"));
	ne_p[15] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_p15"));
	ne_p[16] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_p16"));
	ne_p[17] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_p17"));
	ne_p[18] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_p18"));
	ne_p[19] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ne_p19"));

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
	a_p[41] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p41"));
	a_p[42] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p42"));
	a_p[43] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p43"));
	a_p[44] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p44"));
	a_p[45] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p45"));
	a_p[46] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "a_p46"));

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
	q3_a7 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_a7"));
	q3_b4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_b4"));
	q3_b5 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_b5"));
	q3_b6 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_b6"));
	q3_d5 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_d5"));
	q3_d6 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_d6"));
	q3_e2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_e2"));
	q3_e3 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_e3"));
	q3_e4 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_e4"));
	q3_f5 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_f5"));
	q3_f6 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_f6"));
	q3_f7 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_f7"));
	q3_h2 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_h2"));
	q3_i1 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_i1"));
	q5_a7 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q5_a7"));
	q5_a8 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q5_a8"));
	//
	female_11 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "female_11"));
	female_12 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "female_12"));
	//
	q3_d7 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_d7"));
	q3_d8 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_d8"));
	q3_d9 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_d9"));
	q3_d10 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_d10"));
	q3_d11 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "q3_d11"));

	eat_15 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_15"));
	eat_16 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_16"));
	eat_17 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_17"));
	eat_18 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_18"));
	eat_19 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_19"));
	eat_20 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_20"));
	eat_21 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_21"));
	eat_22 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_22"));
	eat_23 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_23"));
	eat_24 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eat_24"));

	drink_15 = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "drink_15"));
	mn_p[15] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p15"));
	mn_p[16] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p16"));
	mn_p[17] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p17"));

	createDate = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "date_from"));
	createhh = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "timeOfOccurrence_hh"));
	createmm = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "timeOfOccurrence_mi"));

	//new ccr ph2 and ph3
	mn_p[30] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p30"));
	mn_p[61] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p61"));
	mn_p[62] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p62"));
	mn_p[63] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p63"));
	mn_p[64] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p64"));
	mn_p[65] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p65"));
	mn_p[66] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p66"));
	mn_p[67] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p67"));
	mn_p[68] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p68"));
	mn_p[36] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p36"));
	mn_p[38] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p38"));
	mn_p[39] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p39"));
	//
	mn_p[69] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p69"));
	mn_p[70] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p70"));
	mn_p[71] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p71"));
	mn_p[72] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p72"));
	mn_p[73] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p73"));
	mn_p[74] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p74"));
	mn_p[75] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p75"));
	//
	mn_p[76] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p76"));
	mn_p[77] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p77"));
	mn_p[78] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p78"));
	mn_p[79] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p79"));
	//
	mn_p[41] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p41"));
	mn_p[42] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p42"));
	mn_p[43] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p43"));
	mn_p[44] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p44"));
	mn_p[45] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p45"));
	mn_p[46] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p46"));
	mn_p[47] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p47"));
	mn_p[48] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p48"));
	//
	mn_p[49] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p49"));
	mn_p[50] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p50"));
	mn_p[51] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p51"));
	mn_p[52] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p52"));
	mn_p[53] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p53"));
	//
	mn_p[54] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p54"));
	mn_p[55] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p55"));
	mn_p[56] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p56"));
	mn_p[57] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p57"));
	mn_p[58] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p58"));
	mn_p[59] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p59"));
	mn_p[60] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p60"));

	// Progress of Previous Goals 較早前的目標之進展:
	mn_p[85] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p85"));
	mn_p[86] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p86"));
	mn_p[87] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p87"));
	mn_p[88] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p88"));
	mn_p[89] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p89"));
	mn_p[90] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p90"));
	mn_p[91] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p91"));
	mn_p[92] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p92"));
	mn_p[93] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p93"));
	mn_p[94] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p94"));
	mn_p[95] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p95"));
	mn_p[96] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p96"));
	//
	mn_p[97] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p97"));
	mn_p[98] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p98"));
	mn_p[99] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p99"));
	mn_p[100] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p100"));
	mn_p[101] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p101"));
	mn_p[102] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p102"));
	mn_p[103] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p103"));
	mn_p[104] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p104"));
	mn_p[105] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p105"));
	//
	mn_p[106] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p106"));
	mn_p[107] = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "mn_p107"));
//20250219 Arran added patConNo	
	patConNo = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "patConNo"));				

	ccr_phase = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "ccr_phase"));

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
		// check form input date (createdate) is null
		if ((createDate == "") || (createDate == null)) {
			createDate = DateTimeUtil.getCurrentDateTime().substring(0, 10);
		}
		String[] createDateArray = new String[]{createDate, createhh, createmm};
		
		haID = HAFormDB.saveHAForm(userBean, staffID,  regID, patNo, formType, q1,
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
					ne_p,
					s_1, s_2, s_3, s_4,
					// array
					a_p, ex_1, ex_2, mn_p, remark, completed, docCode,
					q3_a5, q3_a6, q3_b4, q3_b5,
					q3_d5, q3_d6, q3_e2, q3_e3,
					q3_f5, q3_f6, q3_h2, q3_i1,
					q5_a7, female_11, female_12,
					q3_d7, q3_d8, q3_d9, q3_d10,
					eat_15, eat_16, eat_17, eat_18, eat_19, eat_20,
					eat_21, eat_22, drink_15, eat_23, eat_24,
					smoke_7, sleep_3, sleep_4, sleep_5, sleep_6,
					phy_21, phy_22, phy_23, phy_24, phy_25,
					q3_a7, q3_b6, q3_d11, q3_f7, q3_e4,
					q5_a8, gc_16, gc_17, q3_g4, q3_g5,
					seqNo, createDateArray,
//20250314 Arran added patConNo					
					ccr_phase, formTypeOther, phy_26, patConNo					
				);
		SaveFormAction = false;
		finishSaving = true;
		//command = "view";
		//response.sendRedirect("health_assess_form.jsp?command=view&staffID=" + staffID + "&patNo=" + patNo + "&regID=" + regID);
	} else if (completeFormAction) { // Complete the form
		HAFormDB.completeHAForm(haID, completed);

		completeFormAction = false;
		//command = "view";
		response.sendRedirect("health_assess_form_ccrp2.jsp?command=view&staffID=" + staffID + "&patNo=" + patNo + "&regID=" + regID + "&seqNo=" + seqNo + "&formType=" + formType);
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
<form name="form1" action="health_assess_form_ccrp2.jsp" method="post">
<table class="table1" style="width: 100%">
	<tr>
		<td style="background: <%if ("CCRP2".equals(formType)) {%>#58ACFA<%} else {%>#688A08<%} %>; color: white"><font size="3"><b>肺塵埃沉着病及間皮瘤病人 社區綜合復康計劃<br/>身體檢查評估表<br/>CCR HEALTH ASSESSMENT FORM</b></font></td>
		<td>
		<table>
			<tr>
			<%--
			<td>檢查日期 Date of Screening:<%if (newForm) {%><%=DateTimeUtil.getCurrentDate()%><% } else {%><%=createDate%><%} %></td>
			--%>
			<td>檢查日期 Date of Screening:<input type="textfield" name="date_from" id="date_from" class="datepickerfield" value="<%=createDate %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"></input></td>
			<%--
			<td>填表時間 Time:<%if (newForm) {%><%=DateTimeUtil.getCurrentTime()%><% } else {%><%=createTime%><%} %></td>
			--%>
			<td>填表時間 Time:
									<jsp:include page="../ui/timeCMB.jsp" flush="false">
									<jsp:param name="label" value="timeOfOccurrence" />
									<jsp:param name="time" value='<%=((createhh==null||createmm==null)?"":(createhh+":"+createmm)) %>' />
									<jsp:param name="allowEmpty" value="Y" />
									<jsp:param name="defaultValue" value='<%=((createhh==null||createmm==null))?"N":"Y"%>' />
								</jsp:include>
			</td>
<%
		if (!formType.substring(0, 3).equals("CCR")) {
%>
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
<%
		} else {
%>
			<td><input type="hidden" name="formType" value="<%=formType%>" readonly size=5></input></td>
<%
		}
%>
			</tr>
			<tr>
			<td>更改日期 Modify Date: <%if (newForm) {%><%=DateTimeUtil.getCurrentDate()%><% } else {%><%=modifyDate%><%} %></td>
			<td>更改時間 ModifyTime: <%if (newForm) {%><%=DateTimeUtil.getCurrentTime()%><% } else {%><%=modifyTime%><%} %></td>
			<td>更改員工 Modify Staff: <%if (newForm) {%><%=""%><% } else {%><%=modifyUser%><%} %></td>
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
			<td style="background: #D8D8D8;">
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
					<td>檔案編號 Case No&nbsp;<input type="text" name="patConNo" value="<%=patConNo==null?"":patConNo %>" <%=patConNo==null||patConNo==""?"":"readonly" %> size=10></input></td>
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
				<table border=0>
					<tr>
						<td>Temp 體溫(°C): <input type="text" name="phy_1" value="<%=phy_1%>" size=1 /></td>
						<td>BP 血壓(mmHg): <input type="text" name="phy_2" value="<%=phy_2%>" size=1 /> / <input type="text" name="phy_3" value="<%=phy_3%>" size=1 /></td>
						<td align="right">Pulse 脈搏(bpm): <input type="text" name="phy_4" value="<%=phy_4%>" size=1 /></td>
						<td align="right">Resp 呼吸(/min): <input type="text" name="phy_5" value="<%=phy_5%>" size=1 /></td>
						<td>SpO2 血氧(%): <input type="text" name="phy_6" value="<%=phy_6%>" size=1 /></td>
<%
		if (formType.substring(0, 3).equals("CCR")) {
%>
						<td><input type="radio" name="phy_23" value="0" <%if ("0".equals(phy_23) || "".equals(phy_23)) {%>checked<%} %>>
						Room Air:
						<%--
						<input type="text" name="phy_21" value="<%=phy_21%>" size=1 /></td>
						 --%>
						<td><input type="radio" name="phy_23" value="1" <%if ("1".equals(phy_23)) {%>checked<%} %>>
						N.C.in <input type="text" name="phy_22" value="<%=phy_22%>" size=1 />L O2</td>
						<td>CO一氧化碳(ppm):<input type="text" name="phy_26" value="<%=phy_26%>" size=2 /></td>
<%
		}
%>
					</tr>
					<tr>
						<td>Weight 體重(kg): <input type="text" name="phy_7" value="<%=phy_7%>" size=1 /></td>
						<td>Height 身高(cm): <input type="text" name="phy_8" value="<%=phy_8%>" size=1 /></td>
						<td align="right">BMI 體格指數: <input type="text" name="phy_9" value="<%=phy_9%>" size=1 /></td>
						<td>Ideal Weight 理想體重(kg): <input type="text" name="phy_10" value="<%=phy_10%>" size=1 /></td>
						<td align="right">Waist Girth 腰圍(cm): <input type="text" name="phy_11" value="<%=phy_11%>" size=1 /></td>
					</tr>
				</table>
<%--
				<table>
						<tr>
							<td>Vision Acuity 視力</td>
							<td>L 左: <input type="text" name="phy_18" value="<%=phy_18%>" size=10 /></td>
							<td>R 右: <input type="text" name="phy_19" value="<%=phy_19%>" size=10 /></td>
							<td><input type="radio" name="phy_20" value="0" <%if ("0".equals(phy_20) || "".equals(phy_20)) {%>checked<%} %>>&nbsp;Unaided 無需配帶眼鏡</td>
							<td><input type="radio" name="phy_20" value="1" <%if ("1".equals(phy_20)) {%>checked<%} %>>&nbsp;Aided 需配帶眼鏡</td>
						</tr>
 --%>
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
		</table>
		</td>
		</tr>
	</table>


	<%--
	 --%>


	<table style="background-color:white;" width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
	<td align="center"><font size="3"><b>Medical Notes 醫療記錄</b></font></td>
	</tr>
	<tr>
		<td style="background: #A9D0F5;">
		&nbsp;&nbsp;
		</td>
	</tr>
	<tr>
		<td>
		<%
		if ("CCRP2".equals(formType)) {
		%>
			CCR Phase TWO
		<%
		} else {
		%>
			CCR Phase THREE
		<%
		}
		%>
		<input type="text" name="ccr_phase" value="<%=ccr_phase%>" size=5 maxlength=15/>
		</td>
	</tr>
	<tr>
		<%--
		<td>Lab Results 其他化驗結果:</td>
		 --%>
		<td>Significant Findings 重要的檢查結果如下:</td>
	</tr>
	<tr>
		<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<textarea id="mn_p0" name="mn_p0" rows="6" cols="150"><%=mn_p[0]%></textarea></td>
	</tr>

	<%--
	<tr>
		<td>Significant Investigations Findings 重要的檢查結果如下 (Details see original full investigation report 有關細節請看原報告):</td>
	</tr>

	<tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<textarea id="mn_p1" name="mn_p1" rows="6" cols="150"><%=mn_p[1]%></textarea></td>
	</tr>
	 --%>
  	<tr>
 	<td style="background: #A9D0F5;">Careplan Meeting Records 護理計劃會議記錄  (Date of Careplan Meeting 會議日期:<input type="text" name="mn_p30" class="datepickerfield" value="<%=mn_p[30] %>" maxlength="10" size="10" onkeyup="validDate(this)" onblur="validDate(this)"></input>&nbsp;)</td>
 	</tr>
	<tr>
 	<td><b>Problems Identified / Progress 發現的問題 / 進展:</b></td>
 	</tr>
	<tr>
 	<td>Previous problems:</td>
 	</tr>
 	<tr>
 		<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<textarea name="mn_p61" rows="3" cols="150"><%=mn_p[61]%></textarea></td>
 	</tr>
	<tr>
 	<td>New problems:</td>
 	</tr>
 	<tr>
 		<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<textarea name="mn_p62" rows="3" cols="150"><%=mn_p[62]%></textarea></td>
 	</tr>
	<tr>
 	<td><b>Progress of Previous Goals 較早前的目標之進展:</b></td>
 	</tr>
 	<tr>
 	<td>
	 	<table border=0>
	 	<tr>
	 	<td>
 		 	<table border=0>
		 	<tr>
		 	<td>1. 6-min Walk Test 六分鐘步行測試</td>
		 	<td><input type="radio" name="mn_p63" value="0" <%if ("0".equals(mn_p[63])) {%>checked<%} %>>&nbsp;Achieved 達到</td>
			<td><input type="radio" name="mn_p63" value="1" <%if ("1".equals(mn_p[63])) {%>checked<%} %>>&nbsp;Not achieved 未達到</td>
			<td><input type="radio" name="mn_p63" value="2" <%if ("2".equals(mn_p[63]) || "".equals(mn_p[63])) {%>checked<%} %>>&nbsp;N/A不適用</td>
			</tr>
			<tr>
		 	<td>2. Hand Grip Strength Test (Right / Left) 手握力測試</td>
		 	<td><input type="radio" name="mn_p64" value="0" <%if ("0".equals(mn_p[64])) {%>checked<%} %>>&nbsp;Achieved 達到</td>
			<td><input type="radio" name="mn_p64" value="1" <%if ("1".equals(mn_p[64])) {%>checked<%} %>>&nbsp;Not achieved 未達到</td>
			<td><input type="radio" name="mn_p64" value="2" <%if ("2".equals(mn_p[64]) || "".equals(mn_p[64])) {%>checked<%} %>>&nbsp;N/A不適用</td>
			</tr>
			<tr>
		 	<td>3. Prescribed Exercise Level 安排之運動級別</td>
		 	<td><input type="radio" name="mn_p65" value="0" <%if ("0".equals(mn_p[65])) {%>checked<%} %>>&nbsp;Achieved 達到</td>
			<td><input type="radio" name="mn_p65" value="1" <%if ("1".equals(mn_p[65])) {%>checked<%} %>>&nbsp;Not achieved 未達到</td>
			<td><input type="radio" name="mn_p65" value="2" <%if ("2".equals(mn_p[65]) || "".equals(mn_p[65])) {%>checked<%} %>>&nbsp;N/A不適用</td>
			</tr>
			<tr>
			<td>4. Reduce hospitalization, no episodes over 減少入院次數, 沒有入院超過 :<input type="text" name="mn_p36" value="<%=mn_p[36]%>" size=5 maxlength=15></br>&nbsp;&nbsp;&nbsp;&nbsp;months (s) 個月</input></td>
		 	<td><input type="radio" name="mn_p66" value="0" <%if ("0".equals(mn_p[66])) {%>checked<%} %>>&nbsp;Achieved 達到</td>
			<td><input type="radio" name="mn_p66" value="1" <%if ("1".equals(mn_p[66])) {%>checked<%} %>>&nbsp;Not achieved 未達到</td>
			<td><input type="radio" name="mn_p66" value="2" <%if ("2".equals(mn_p[66]) || "".equals(mn_p[66])) {%>checked<%} %>>&nbsp;N/A不適用</td>
			</tr>
			<tr>
			<td>5.&nbsp;&nbsp;<textarea name="mn_p38" rows="4" cols="90"><%=mn_p[38]%></textarea></td>
		 	<td><input type="radio" name="mn_p67" value="0" <%if ("0".equals(mn_p[67])) {%>checked<%} %>>&nbsp;Achieved 達到</td>
			<td><input type="radio" name="mn_p67" value="1" <%if ("1".equals(mn_p[67])) {%>checked<%} %>>&nbsp;Not achieved 未達到</td>
			<td><input type="radio" name="mn_p67" value="2" <%if ("2".equals(mn_p[67]) || "".equals(mn_p[67])) {%>checked<%} %>>&nbsp;N/A不適用</td>
			</tr>
			<tr>
			<td>6.&nbsp;&nbsp;<textarea name="mn_p39" rows="4" cols="90"><%=mn_p[39]%></textarea></td>
		 	<td><input type="radio" name="mn_p68" value="0" <%if ("0".equals(mn_p[68])) {%>checked<%} %>>&nbsp;Achieved 達到</td>
			<td><input type="radio" name="mn_p68" value="1" <%if ("1".equals(mn_p[68])) {%>checked<%} %>>&nbsp;Not achieved 未達到</td>
			<td><input type="radio" name="mn_p68" value="2" <%if ("2".equals(mn_p[68]) || "".equals(mn_p[68])) {%>checked<%} %>>&nbsp;N/A不適用</td>
			</tr>
			<tr>
			<td>7.&nbsp;&nbsp;<textarea name="mn_p85" rows="4" cols="90"><%=mn_p[85]%></textarea></td>
			<td><input type="radio" name="mn_p86" value="0" <%if ("0".equals(mn_p[86])) {%>checked<%} %>>&nbsp;Achieved 達到</td>
			<td><input type="radio" name="mn_p86" value="1" <%if ("1".equals(mn_p[86])) {%>checked<%} %>>&nbsp;Not achieved 未達到</td>
			<td><input type="radio" name="mn_p86" value="2" <%if ("2".equals(mn_p[86]) || "".equals(mn_p[68])) {%>checked<%} %>>&nbsp;N/A不適用</td>
			</tr>
			<tr>
			<td>8.&nbsp;&nbsp;<textarea name="mn_p87" rows="4" cols="90"><%=mn_p[87]%></textarea></td>
			<td><input type="radio" name="mn_p88" value="0" <%if ("0".equals(mn_p[88])) {%>checked<%} %>>&nbsp;Achieved 達到</td>
			<td><input type="radio" name="mn_p88" value="1" <%if ("1".equals(mn_p[88])) {%>checked<%} %>>&nbsp;Not achieved 未達到</td>
			<td><input type="radio" name="mn_p88" value="2" <%if ("2".equals(mn_p[88]) || "".equals(mn_p[88])) {%>checked<%} %>>&nbsp;N/A不適用</td>
			</tr>
			<tr>
			<td>9.&nbsp;&nbsp;<textarea name="mn_p89" rows="4" cols="90"><%=mn_p[89]%></textarea></td>
			<td><input type="radio" name="mn_p90" value="0" <%if ("0".equals(mn_p[90])) {%>checked<%} %>>&nbsp;Achieved 達到</td>
			<td><input type="radio" name="mn_p90" value="1" <%if ("1".equals(mn_p[90])) {%>checked<%} %>>&nbsp;Not achieved 未達到</td>
			<td><input type="radio" name="mn_p90" value="2" <%if ("2".equals(mn_p[90]) || "".equals(mn_p[90])) {%>checked<%} %>>&nbsp;N/A不適用</td>
			</tr>
			<tr>
			<td>10.&nbsp;&nbsp;<textarea name="mn_p91" rows="4" cols="90"><%=mn_p[91]%></textarea></td>
			<td><input type="radio" name="mn_p92" value="0" <%if ("0".equals(mn_p[92])) {%>checked<%} %>>&nbsp;Achieved 達到</td>
			<td><input type="radio" name="mn_p92" value="1" <%if ("1".equals(mn_p[92])) {%>checked<%} %>>&nbsp;Not achieved 未達到</td>
			<td><input type="radio" name="mn_p92" value="2" <%if ("2".equals(mn_p[92]) || "".equals(mn_p[92])) {%>checked<%} %>>&nbsp;N/A不適用</td>
			</tr>
			<tr>
			<td>11.&nbsp;&nbsp;<textarea name="mn_p93" rows="4" cols="90"><%=mn_p[93]%></textarea></td>
			<td><input type="radio" name="mn_p94" value="0" <%if ("0".equals(mn_p[94])) {%>checked<%} %>>&nbsp;Achieved 達到</td>
			<td><input type="radio" name="mn_p94" value="1" <%if ("1".equals(mn_p[94])) {%>checked<%} %>>&nbsp;Not achieved 未達到</td>
			<td><input type="radio" name="mn_p94" value="2" <%if ("2".equals(mn_p[94]) || "".equals(mn_p[92])) {%>checked<%} %>>&nbsp;N/A不適用</td>
			</tr>
			<tr>
			<td>12.&nbsp;&nbsp;<textarea name="mn_p95" rows="4" cols="90"><%=mn_p[95]%></textarea></td>
			<td><input type="radio" name="mn_p96" value="0" <%if ("0".equals(mn_p[96])) {%>checked<%} %>>&nbsp;Achieved 達到</td>
			<td><input type="radio" name="mn_p96" value="1" <%if ("1".equals(mn_p[96])) {%>checked<%} %>>&nbsp;Not achieved 未達到</td>
			<td><input type="radio" name="mn_p96" value="2" <%if ("2".equals(mn_p[96]) || "".equals(mn_p[92])) {%>checked<%} %>>&nbsp;N/A不適用</td>

			</tr>
			</table>
		</td>
		</tr>
		</table>
	</td>
	</tr>
 	<tr>
 	<td><b>New Goals and Actions 新目標及行動:</b></td>
 	</tr>
 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;1.&nbsp;&nbsp;6-min Walk Test 六分鐘步行測試: ≥&nbsp;&nbsp;<input type="text" name="mn_p69" value="<%=mn_p[69]%>" size=5 maxlength=15>&nbsp;&nbsp;m 米</input></td>
 	</tr>
 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;2.&nbsp;&nbsp;Hand Grip Strength Test (Right / Left) 手握力測試 (右 / 左): ≥&nbsp;&nbsp;<input type="text" name="mn_p70" value="<%=mn_p[70]%>" size=5 maxlength=15>&nbsp;&nbsp;kg 公斤 / ≥&nbsp;&nbsp;</input><input type="text" name="mn_p71" value="<%=mn_p[71]%>" size=5 maxlength=15>&nbsp;&nbsp;kg 公斤&nbsp;&nbsp;</input></td>
 	</tr>
 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;3.&nbsp;&nbsp;Prescribed Exercise Level 安排之運動級別:&nbsp;&nbsp;<input type="text" name="mn_p72" value="<%=mn_p[72]%>" size=100></input></td>
 	</tr>
 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;4.&nbsp;&nbsp;Reduce hospitalization, no episodes over 減少入院治療次數, &nbsp;&nbsp;<input type="text" name="mn_p73" value="<%=mn_p[73]%>" size=5 maxlength=15>&nbsp;&nbsp;months 個月之內沒有入院</input></td>
 	</tr>
 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;5.&nbsp;&nbsp;<textarea name="mn_p74" rows="4" cols="150"><%=mn_p[74]%></textarea></td>
 	</tr>
 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;6.&nbsp;&nbsp;<textarea name="mn_p75" rows="4" cols="150"><%=mn_p[75]%></textarea></td>
 	</tr>
 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;7.&nbsp;&nbsp;<textarea name="mn_p97" rows="4" cols="150"><%=mn_p[97]%></textarea></td>
 	</tr>
 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;8.&nbsp;&nbsp;<textarea name="mn_p98" rows="4" cols="150"><%=mn_p[98]%></textarea></td>
 	</tr>
 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;9.&nbsp;&nbsp;<textarea name="mn_p99" rows="4" cols="150"><%=mn_p[99]%></textarea></td>
 	</tr>
	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;10.&nbsp;&nbsp;<textarea name="mn_p100" rows="4" cols="150"><%=mn_p[100]%></textarea></td>
 	</tr>
 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;11.&nbsp;&nbsp;<textarea name="mn_p101" rows="4" cols="150"><%=mn_p[101]%></textarea></td>
 	</tr>
 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;12.&nbsp;&nbsp;<textarea name="mn_p102" rows="4" cols="150"><%=mn_p[102]%></textarea></td>
 	</tr>
 	<tr>
 	<td><b>Further Actions 進一步的行動:</b></td>
 	</tr>
 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="mn_p41" value="1" <%if ("1".equals(mn_p[41])) {%>checked<%} %>/>&nbsp;Arrange exercise training at 安排運動訓練在: /&nbsp;
 	 	<input type="text" name="mn_p42" value="<%=mn_p[42]%>" size=100></input></td>
 	</tr>
 	<tr>
 		<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="mn_p76" value="1" <%if ("1".equals(mn_p[76])) {%>checked<%} %>/>&nbsp;continue exercise training at 運動訓練繼續在:
		<input type="text" name="mn_p105" value="<%=mn_p[105]%>" size=100></input></td>
 	</tr>
 	<tr>
 	 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="mn_p106" value="1" <%if ("1".equals(mn_p[106])) {%>checked<%} %>/>&nbsp;( Max. frequency / week每週最多次數: 3&nbsp;&nbsp;&nbsp;&nbsp;  Patient requests no. of frequency / week 病人要求每週次數:
		<input type="text" name="mn_p107" value="<%=mn_p[107]%>" size=10></input> ):</td>
 	</tr>
 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="mn_p43" value="1" <%if ("1".equals(mn_p[43])) {%>checked<%} %>/>&nbsp;Prescribe 安排/&nbsp;&nbsp;<input type="checkbox" name="mn_p77" value="1" <%if ("1".equals(mn_p[77])) {%>checked<%} %>/>&nbsp;continue 繼續使用:</td>
 	</tr>
 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;wheelchair for transport 輪椅作運送</td>
 	</tr>
 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="mn_p44" value="1" <%if ("1".equals(mn_p[44])) {%>checked<%} %>/>&nbsp;Prescribe other necessary rehabilitation aids安排其他必需的復康輔助器: &nbsp;&nbsp;
	 	<input type="text" name="mn_p45" value="<%=mn_p[45]%>" size=100></input></td>
 	</tr>


 	 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
 	<input type="checkbox" name="mn_p46" value="1" <%if ("1".equals(mn_p[46])) {%>checked<%} %>/>&nbsp;Arrange 安排 /&nbsp;
 	<input type="checkbox" name="mn_p78" value="1" <%if ("1".equals(mn_p[78])) {%>checked<%} %>/>continue 繼續使用
	</td>
 	</tr>
 	<tr>
 	<td>
	 	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Portable oxygen concentrator during exercise 手提式氧氣機 &nbsp;(<input type="text" name="mn_p47" value="<%=mn_p[47]%>" size=5 maxlength=15></input>L/min via nasal cannula 升/分鐘經鼻導管)

 	</td>
 	</tr>


 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="mn_p49" value="1" <%if ("1".equals(mn_p[49])) {%>checked<%} %>/>&nbsp;Arrange 安排/
 														<input type="checkbox" name="mn_p79" value="1" <%if ("1".equals(mn_p[79])) {%>checked<%} %>/>&nbsp;continue 繼續使用
 	</td>
	</tr>
 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;taxi / rehab taxi / rehab bus for transport to exercise training centre
			/的士 / 復康的士 / 復康巴士 往返 復康訓練中心 / 香港港安醫院 - 荃灣 / 肺塵埃沉着病判傷委員會</td>
 	</tr>


 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="mn_p50" value="1" <%if ("1".equals(mn_p[50])) {%>checked<%} %>/>&nbsp;Refresher training on inhaler & spacer technique 進修培訓有關吸入器及儲霧罐的技巧</td>
 	</tr>
 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="mn_p51" value="1" <%if ("1".equals(mn_p[51])) {%>checked<%} %>/>&nbsp;Encourage participation in patient support group 鼓勵參加病人互助小組</td>
 	</tr>
 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="mn_p52" value="1" <%if ("1".equals(mn_p[52])) {%>checked<%} %>/>&nbsp;Referral to 轉介到:
 		<textarea name="mn_p53" rows="4" cols="150"><%=mn_p[53]%></textarea>
 	</td>
 	</tr>
 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="mn_p54" value="1" <%if ("1".equals(mn_p[54])) {%>checked<%} %>/>&nbsp;Refresher training on breathing technique and dyspnea management 進修培訓有關呼吸技巧及呼吸困難的管理</td>
 	</tr>
 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="mn_p55" value="1" <%if ("1".equals(mn_p[55])) {%>checked<%} %>/>&nbsp;Advise to take Ventolin inhaler immediately before exercise training 建議在運動訓練前立即使用泛得林定量噴霧劑</td>
 	</tr>
 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="mn_p56" value="1" <%if ("1".equals(mn_p[56])) {%>checked<%} %>/>&nbsp;Introduce health education talks 介紹合適的健康教育講座 (E.G.例如:
 		<input type="text" name="mn_p57" value="<%=mn_p[57]%>" size=100> &nbsp;)</input>
 	</td>
 	</tr>
 	 
 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="mn_p103" value="1" <%if ("1".equals(mn_p[103])) {%>checked<%} %>/>&nbsp;Smoking cessation service: Assessment and advice 戒煙服務評估及輔導</td>
 	</tr>
	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="mn_p58" value="1" <%if ("1".equals(mn_p[58])) {%>checked<%} %>/>&nbsp;Refer / continue smoking cessation service 轉介/繼續戒煙服務</td>
 	</tr>

 	<tr>
 	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" name="mn_p59" value="1" <%if ("1".equals(mn_p[59])) {%>checked<%} %>/>&nbsp;Others 其他:
 		<textarea name="mn_p60" rows="4" cols="150"><%=mn_p[60]%></textarea>
 	</td>

 	</tr>




<%--
 	<tr>
 	<td>
 		<table border=1>
	 	<tr>
	 	<td>2. Hand Grip Strength Test (Right / Left) 手握力測試</td>
	 	<td>
	 	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	 	</td>
	 	<td>
	 	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	 	</td>
	 	<td><input type="radio" name="mn_p64" value="0" <%if ("0".equals(mn_p[64])) {%>checked<%} %>>&nbsp;Achieved 達到</td>
		<td><input type="radio" name="mn_p64" value="1" <%if ("1".equals(mn_p[64])) {%>checked<%} %>>&nbsp;Not achieved 未達到</td>
		<td><input type="radio" name="mn_p64" value="2" <%if ("2".equals(mn_p[64]) || "".equals(mn_p[64])) {%>checked<%} %>>&nbsp;N/A不適用</td>
		</tr>
		</table>
 	</td>
 	</tr>
 	<tr>
 	<td>
 		<table border=1>
	 	<tr>
	 	<td>3. Prescribed Exercise Level 安排之運動級別</td>
	 	<td>
	 	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	 	</td>
	 	<td>
	 	&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	 	</td>
	 	<td><input type="radio" name="mn_p65" value="0" <%if ("0".equals(mn_p[65])) {%>checked<%} %>>&nbsp;Achieved 達到</td>
		<td><input type="radio" name="mn_p65" value="1" <%if ("1".equals(mn_p[65])) {%>checked<%} %>>&nbsp;Not achieved 未達到</td>
		<td><input type="radio" name="mn_p65" value="2" <%if ("2".equals(mn_p[65]) || "".equals(mn_p[65])) {%>checked<%} %>>&nbsp;N/A不適用</td>
		</tr>
		</table>
 	</td>
 	</tr>
 --%>





<%--  End here --%>

	<tr>
	</tr>
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
			</td>
		</tr>
		</table>
	</td>
	</tr>


	</table>


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
				<button onclick="return printReport('pdfAction', '<%=haID %>', '<%=formType%>');">
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

function printReport(action, haID, ccr) {
	if(action == 'pdfAction') {
		callPopUpWindow("print_report.jsp?command="+action+"&haID="+haID+"&formType="+ccr);
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