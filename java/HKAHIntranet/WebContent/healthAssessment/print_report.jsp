<%@ page language="java" contentType="text/html; charset=utf-8" %>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.constant.*" %>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="java.io.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="com.google.zxing.*" %>
<%!
	public byte[] generateReport(JasperPrint jasperPrint1, JasperPrint jasperPrint2, JasperPrint jasperPrint3, JasperPrint jasperPrint4, JasperPrint jasperPrint5,
								HttpServletResponse response) {
			//throw the JasperPrint Objects in a list
			ByteArrayOutputStream baos = null;
			try {
			List<JasperPrint> jasperPrintList = new ArrayList<JasperPrint>();
			jasperPrintList.add(jasperPrint1);
			//jasperPrintList.add(jasperPrint2);
			//jasperPrintList.add(jasperPrint3);
			//jasperPrintList.add(jasperPrint4);
			//jasperPrintList.add(jasperPrint5);

			baos = new ByteArrayOutputStream();
			JRPdfExporter exporter = new JRPdfExporter();
			//Add the list as a Parameter
			exporter.setParameter(JRExporterParameter.JASPER_PRINT_LIST, jasperPrintList);
			//this will make a bookmark in the exported PDF for each of the reports
			exporter.setParameter(JRPdfExporterParameter.IS_CREATING_BATCH_MODE_BOOKMARKS, Boolean.TRUE);
			exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, baos);

			OutputStream ouputStream = response.getOutputStream();
			response.setContentType("application/pdf");

			exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
			exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../../servlets/image?image=");

			exporter.exportReport();
			ouputStream.close();
		} catch (Exception e){
		}
		return baos.toByteArray();
	}
%>
<%
UserBean userBean = new UserBean(request);

String command = request.getParameter("command");
String haID = request.getParameter("haID");
String formType = request.getParameter("formType");
String type = request.getParameter("type");
String reportName = "";
command = "pdfAction";

System.out.println(DateTimeUtil.getCurrentDateTime() + " [HA print_report.jsp debug]: commnad=" + command + ", haID(before condition)=" + haID + ", formType=" + formType + ", type=" + type);
if("null".equals(haID)){
	haID = "";
}
System.out.println(DateTimeUtil.getCurrentDateTime() + " [HA print_report.jsp debug]: haID(after condition)=" + haID);
if(command != null && command.equals("pdfAction")){
	if (haID != null && haID.length() > 0) {
		ArrayList record = HAFormDB.getHAReportReport(haID);
		if (record.size() > 0  && "pdfAction".equals(command) ) {
			if ("CCR".equals(formType)) {
				reportName = "/report/HAForm_newstyle_ccr.jasper";
			} else if ("CCRP1".equals(formType)) {
				if ("OLD".equals(type)) {
					reportName = "/report/HAForm_newstyle_ccr_old_p1.jasper";
				} else {
					reportName = "/report/HAForm_newstyle_ccr_p1.jasper";
				}
			} else if ("CCRP2".equals(formType)) {
				reportName = "/report/HAForm_newstyle_ccr_p2.jasper";
			} else if ("CCRP3".equals(formType)) {
				reportName = "/report/HAForm_newstyle_ccr_p2.jasper";
			} else {
				reportName = "/report/HAForm_newstyle.jasper";
			}
			File reportFile = new File(application.getRealPath(reportName));
			//File reportFile = new File(application.getRealPath("/report/HAForm_newstyle.jasper"));
			if (reportFile.exists()) {
				JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());

				Map parameters = new HashMap();
				parameters.put("BaseDir", reportFile.getParentFile());
				ReportableListObject row = (ReportableListObject) record.get(0);

				// set report fields value
				parameters.put("patName", row.getValue(336));
				//parameters.put("patAge", row.getValue(337));
				parameters.put("patAge", row.getValue(498));
				parameters.put("patSex", row.getValue(338));
				parameters.put("patDOB", row.getValue(339));
				parameters.put("patNo", row.getValue(2));
				parameters.put("createDate", row.getValue(334));
				parameters.put("createTime", row.getValue(335));
				parameters.put("formType", row.getValue(3));
				//System.out.println("row.getValue(3) : " + row.getValue(3));
				parameters.put("completed", row.getValue(328));
				parameters.put("patCName", row.getValue(342));
				parameters.put("docName", row.getValue(340));
				//
				parameters.put("phy_1", row.getValue(101));
				parameters.put("phy_2", row.getValue(102));
				parameters.put("phy_3", row.getValue(103));
				parameters.put("phy_4", row.getValue(104));
				parameters.put("phy_5", row.getValue(105));
				parameters.put("phy_6", row.getValue(106));
				parameters.put("phy_7", row.getValue(107));
				parameters.put("phy_8", row.getValue(108));
				parameters.put("phy_9", row.getValue(109));
				parameters.put("phy_10", row.getValue(110));
				parameters.put("phy_11", row.getValue(111));
				parameters.put("phy_12", row.getValue(112));
				parameters.put("phy_13", row.getValue(113));
				parameters.put("phy_14", row.getValue(114));
				parameters.put("phy_15", row.getValue(115));
				parameters.put("phy_16", row.getValue(116));
				parameters.put("phy_17", row.getValue(117));
				parameters.put("phy_18", row.getValue(297));
				//
				parameters.put("phy_19", row.getValue(298));
				parameters.put("phy_20", row.getValue(299));

				parameters.put("q1", row.getValue(4));

				parameters.put("q2_1" , row.getValue(5));
				parameters.put("q2_2" , row.getValue(6));
				parameters.put("q2_3" , row.getValue(7));
				parameters.put("q2_4" , row.getValue(8));
				parameters.put("q2_5" , row.getValue(9));
				parameters.put("q2_6" , row.getValue(10));
				parameters.put("q2_7" , row.getValue(300));
				parameters.put("q2_8" , row.getValue(301));

				parameters.put("q3_a1",  row.getValue(11));
				parameters.put("q3_a2",  row.getValue(12));
				parameters.put("q3_a3",  row.getValue(13));
				parameters.put("q3_a4",  row.getValue(14));
				parameters.put("q3_b1",  row.getValue(15));
				parameters.put("q3_b2",  row.getValue(16));
				parameters.put("q3_b3",  row.getValue(17));
				parameters.put("q3_c1",  row.getValue(18));
				parameters.put("q3_c2",  row.getValue(19));
				parameters.put("q3_d1",  row.getValue(20));
				parameters.put("q3_d2",  row.getValue(21));
				parameters.put("q3_d3",  row.getValue(22));
				parameters.put("q3_d4",  row.getValue(23));
				parameters.put("q3_e1",  row.getValue(24));
				parameters.put("q3_f1",  row.getValue(25));
				parameters.put("q3_f2",  row.getValue(26));
				parameters.put("q3_f3",  row.getValue(27));
				parameters.put("q3_f4",  row.getValue(28));
				parameters.put("q3_g1",  row.getValue(29));
				parameters.put("q3_g2",  row.getValue(30));
				parameters.put("q3_g3",  row.getValue(31));
				parameters.put("q3_h1",  row.getValue(332));
				parameters.put("q4_1",  row.getValue(32));
				parameters.put("q4_2",  row.getValue(33));
				parameters.put("q5_a1", row.getValue(34));
				parameters.put("q5_a2", row.getValue(35));
				parameters.put("q5_a3", row.getValue(36));
				parameters.put("q5_a4", row.getValue(37));
				parameters.put("q5_a5", row.getValue(38));
				parameters.put("q5_a6", row.getValue(39));
				parameters.put("q5_b1", row.getValue(40));
				// page 2
				parameters.put("smoke_1", row.getValue(47));
				parameters.put("smoke_2", row.getValue(48));
				parameters.put("smoke_3", row.getValue(49));
				parameters.put("smoke_4", row.getValue(50));
				parameters.put("smoke_5", row.getValue(51));
				parameters.put("smoke_6", row.getValue(52));
				parameters.put("drink_1", row.getValue(53));
				parameters.put("drink_2", row.getValue(54));
				parameters.put("drink_3", row.getValue(55));
				parameters.put("drink_4", row.getValue(56));
				parameters.put("drink_5", row.getValue(57));
				parameters.put("drink_6", row.getValue(58));
				parameters.put("drink_7", row.getValue(59));
				parameters.put("drink_8", row.getValue(60));
				parameters.put("drink_9", row.getValue(61));
				parameters.put("drink_10", row.getValue(62));
				parameters.put("drink_11", row.getValue(63));
				parameters.put("drink_12", row.getValue(64));
				parameters.put("drink_13", row.getValue(65));
				parameters.put("drink_14", row.getValue(66));
				parameters.put("eat_1", row.getValue(67));
				parameters.put("eat_2", row.getValue(68));
				parameters.put("eat_3", row.getValue(69));
				parameters.put("eat_4", row.getValue(70));
				parameters.put("eat_5", row.getValue(71));
				parameters.put("eat_6", row.getValue(72));
				parameters.put("eat_7", row.getValue(73));
				parameters.put("eat_8", row.getValue(74));
				parameters.put("eat_9", row.getValue(75));
				parameters.put("eat_10", row.getValue(76));
				parameters.put("eat_11", row.getValue(77));
				parameters.put("eat_12", row.getValue(78));
				parameters.put("eat_13", row.getValue(79));
				parameters.put("eat_14", row.getValue(80));
				parameters.put("sleep_1", row.getValue(81));
				parameters.put("sleep_2", row.getValue(82));
				parameters.put("sport_1", row.getValue(83));
				parameters.put("sport_2", row.getValue(84));
				parameters.put("sport_3", row.getValue(85));
				parameters.put("sport_4", row.getValue(86));
				parameters.put("mood_1", row.getValue(87));
				parameters.put("mood_2", row.getValue(88));
				parameters.put("mood_3", row.getValue(89));
				parameters.put("mood_4", row.getValue(90));
				parameters.put("female_1", row.getValue(91));
				parameters.put("female_2", row.getValue(92));
				parameters.put("female_3", row.getValue(93));
				parameters.put("female_4", row.getValue(94));
				parameters.put("female_5", row.getValue(95));
				parameters.put("female_6", row.getValue(96));
				parameters.put("female_7", row.getValue(97));
				parameters.put("female_8", row.getValue(98));
				parameters.put("female_9", row.getValue(99));
				parameters.put("female_10", row.getValue(100));
				// page 3
				parameters.put("gc_1", row.getValue(118));
				parameters.put("gc_2", row.getValue(119));
				parameters.put("gc_3", row.getValue(120));
				parameters.put("gc_4", row.getValue(121));
				parameters.put("gc_5", row.getValue(122));
				parameters.put("gc_6", row.getValue(123));

				parameters.put("gc_7", row.getValue(124));
				parameters.put("gc_8", row.getValue(125));
				parameters.put("gc_9", row.getValue(126));
				parameters.put("gc_10", row.getValue(127));
				parameters.put("gc_11", row.getValue(128));
				parameters.put("gc_12", row.getValue(129));

				parameters.put("gc_13", row.getValue(130));
				parameters.put("gc_14", row.getValue(131));
				parameters.put("gc_15", row.getValue(132));

				parameters.put("ent_p1", row.getValue(133));
				parameters.put("ent_p2", row.getValue(134));
				parameters.put("ent_p3", row.getValue(135));
				parameters.put("ent_p4", row.getValue(136));
				parameters.put("ent_p5", row.getValue(137));
				parameters.put("ent_p6", row.getValue(138));
				parameters.put("ent_p7", row.getValue(139));
				parameters.put("ent_p8", row.getValue(140));
				parameters.put("ent_p9", row.getValue(141));
				parameters.put("ent_p10", row.getValue(142));
				parameters.put("ent_p11", row.getValue(143));
				parameters.put("ent_p12", row.getValue(144));
				parameters.put("ent_p13", row.getValue(145));
				parameters.put("ent_p14", row.getValue(146));
				parameters.put("ent_p15", row.getValue(147));
				parameters.put("ent_p16", row.getValue(148));

				parameters.put("ent_p17", row.getValue(149));
				parameters.put("ent_p18", row.getValue(150));
				parameters.put("ent_p19", row.getValue(151));
				parameters.put("ent_p20", row.getValue(152));
				parameters.put("ent_p21", row.getValue(153));

				parameters.put("ent_p22", row.getValue(154));
				parameters.put("ent_p23", row.getValue(155));
				parameters.put("ent_p24", row.getValue(156));
				parameters.put("ent_p25", row.getValue(157));
				parameters.put("ent_p26", row.getValue(158));
				parameters.put("ent_p27", row.getValue(159));
				parameters.put("ent_p28", row.getValue(160));
				parameters.put("ent_p29", row.getValue(161));
				parameters.put("ent_p30", row.getValue(162));
				parameters.put("ent_p31", row.getValue(163));
				parameters.put("ent_p32", row.getValue(164));
				parameters.put("ent_p33", row.getValue(165));
				parameters.put("ent_p34", row.getValue(166));

				parameters.put("ent_p35", row.getValue(167));
				parameters.put("ent_p36", row.getValue(168));
				parameters.put("ent_p37", row.getValue(169));
				parameters.put("ent_p38", row.getValue(170));
				parameters.put("ent_p39", row.getValue(171));
				parameters.put("ent_p40", row.getValue(172));
				parameters.put("ent_p41", row.getValue(173));
				parameters.put("ent_p42", row.getValue(174));
				parameters.put("ent_p43", row.getValue(175));
				parameters.put("ent_p44", row.getValue(176));
				parameters.put("ent_p45", row.getValue(177));

				parameters.put("ent_p46", row.getValue(302));
				parameters.put("ent_p47", row.getValue(303));
				parameters.put("ent_p48", row.getValue(304));
				parameters.put("ent_p49", row.getValue(305));
				parameters.put("ent_p50", row.getValue(306));
				parameters.put("ent_p51", row.getValue(307));

				parameters.put("ent_p52", row.getValue(314));
				parameters.put("ent_p53", row.getValue(315));
				parameters.put("ent_p54", row.getValue(316));
				parameters.put("ent_p55", row.getValue(317));
				parameters.put("ent_p56", row.getValue(387));
				parameters.put("ent_p57", row.getValue(407));

				parameters.put("ls_1", row.getValue(178));
				parameters.put("ls_2", row.getValue(179));
				parameters.put("ls_3", row.getValue(180));
				parameters.put("ls_4", row.getValue(181));
				parameters.put("ls_5", row.getValue(182));
				parameters.put("ls_6", row.getValue(183));

				// page 4
				parameters.put("bn_1",  row.getValue(184));
				parameters.put("bn_2",  row.getValue(185));
				parameters.put("bn_3",  row.getValue(186));
				parameters.put("bn_4",  row.getValue(187));
				parameters.put("bn_5",  row.getValue(188));
				parameters.put("bn_6",  row.getValue(189));
				parameters.put("bn_7",  row.getValue(190));
				parameters.put("bn_8",  row.getValue(191));
				parameters.put("bn_9",  row.getValue(192));
				parameters.put("bn_10",  row.getValue(193));
				parameters.put("bn_11",  row.getValue(194));
				parameters.put("bn_12",  row.getValue(195));
				parameters.put("bn_13",  row.getValue(196));
				parameters.put("bn_14",  row.getValue(197));
				parameters.put("bn_15",  row.getValue(198));
				parameters.put("bn_16",  row.getValue(199));

				parameters.put("rs_1",  row.getValue(200));
				parameters.put("rs_2",  row.getValue(201));
				parameters.put("rs_3",  row.getValue(202));
				parameters.put("rs_4",  row.getValue(203));
				parameters.put("rs_5",  row.getValue(204));
				parameters.put("rs_6",  row.getValue(205));
				parameters.put("rs_7",  row.getValue(206));
				parameters.put("rs_8",  row.getValue(207));
				parameters.put("rs_9",  row.getValue(208));
				parameters.put("rs_10",  row.getValue(209));

				parameters.put("rs_11",  row.getValue(308));
				parameters.put("rs_12",  row.getValue(309));
				parameters.put("rs_13",  row.getValue(310));
				parameters.put("rs_14",  row.getValue(311));
				parameters.put("rs_15",  row.getValue(312));
				parameters.put("rs_16",  row.getValue(313));


				parameters.put("cs_1",  row.getValue(210));
				parameters.put("cs_2",  row.getValue(211));
				parameters.put("cs_3",  row.getValue(212));
				parameters.put("cs_4",  row.getValue(213));
				parameters.put("cs_5",  row.getValue(214));
				parameters.put("cs_6",  row.getValue(215));
				parameters.put("cs_7",  row.getValue(216));
				parameters.put("cs_8",  row.getValue(217));

				parameters.put("ne_1",  row.getValue(218));
				parameters.put("ne_2",  row.getValue(219));
				parameters.put("ne_3",  row.getValue(220));
				parameters.put("ne_4",  row.getValue(221));
				parameters.put("ne_5",  row.getValue(222));
				parameters.put("ne_6",  row.getValue(223));
				parameters.put("ne_7",  row.getValue(224));
				parameters.put("ne_8",  row.getValue(225));
				parameters.put("ne_9",  row.getValue(226));
				parameters.put("ne_10",  row.getValue(227));
				parameters.put("ne_11",  row.getValue(228));
				parameters.put("ne_12",  row.getValue(229));
				parameters.put("ne_13",  row.getValue(230));
				parameters.put("ne_14",  row.getValue(231));
				parameters.put("ne_15",  row.getValue(232));
				parameters.put("ne_16",  row.getValue(233));
				parameters.put("ne_17",  row.getValue(234));
				parameters.put("ne_18",  row.getValue(235));
				parameters.put("ne_19",  row.getValue(236));
				parameters.put("ne_20",  row.getValue(237));

				parameters.put("s_1",  row.getValue(238));
				parameters.put("s_2",  row.getValue(239));
				parameters.put("s_3",  row.getValue(240));
				parameters.put("s_4",  row.getValue(241));

				parameters.put("a_p0",  row.getValue(242));
				parameters.put("a_p1",  row.getValue(243));
				parameters.put("a_p2",  row.getValue(244));
				parameters.put("a_p3",  row.getValue(245));
				parameters.put("a_p4",  row.getValue(246));
				parameters.put("a_p5",  row.getValue(247));
				parameters.put("a_p6",  row.getValue(248));
				parameters.put("a_p7",  row.getValue(249));
				parameters.put("a_p8",  row.getValue(250));
				parameters.put("a_p9",  row.getValue(251));
				parameters.put("a_p10",  row.getValue(252));
				parameters.put("a_p11",  row.getValue(253));
				parameters.put("a_p12",  row.getValue(254));
				parameters.put("a_p13",  row.getValue(255));
				parameters.put("a_p14",  row.getValue(256));
				parameters.put("a_p15",  row.getValue(257));
				parameters.put("a_p16",  row.getValue(258));
				parameters.put("a_p17",  row.getValue(259));
				parameters.put("a_p18",  row.getValue(260));
				parameters.put("a_p19",  row.getValue(261));
				parameters.put("a_p20",  row.getValue(262));
				parameters.put("a_p21",  row.getValue(263));
				parameters.put("a_p22",  row.getValue(264));
				parameters.put("a_p23",  row.getValue(265));
				parameters.put("a_p24",  row.getValue(266));
				parameters.put("a_p25",  row.getValue(267));
				parameters.put("a_p26",  row.getValue(268));
				parameters.put("a_p27",  row.getValue(269));
				parameters.put("a_p28",  row.getValue(270));
				parameters.put("a_p29",  row.getValue(271));
				parameters.put("a_p30",  row.getValue(272));
				parameters.put("a_p31",  row.getValue(273));

				parameters.put("a_p32",  row.getValue(318));
				parameters.put("a_p33",  row.getValue(319));
				parameters.put("a_p34",  row.getValue(320));
				parameters.put("a_p35",  row.getValue(321));
				parameters.put("a_p36",  row.getValue(322));
				parameters.put("a_p37",  row.getValue(323));
				parameters.put("a_p38",  row.getValue(324));
				parameters.put("a_p39",  row.getValue(325));

				parameters.put("a_p40",  row.getValue(326));

				// page 5
				parameters.put("ex_1", row.getValue(274));
				parameters.put("ex_2", row.getValue(275));


				parameters.put("mn_p0", row.getValue(276));
				parameters.put("mn_p1", row.getValue(277));
				parameters.put("mn_p2", row.getValue(278));
				parameters.put("mn_p3", row.getValue(279));
				parameters.put("mn_p4", row.getValue(280));
				parameters.put("mn_p5", row.getValue(281));
				parameters.put("mn_p6", row.getValue(282));
				parameters.put("mn_p7", row.getValue(283));
				parameters.put("mn_p8", row.getValue(284));
				parameters.put("mn_p9", row.getValue(285));
				parameters.put("mn_p10",row.getValue(286)+" "+row.getValue(505));

				parameters.put("mn_p11", row.getValue(329));
				parameters.put("mn_p12", row.getValue(330));
				parameters.put("mn_p13", row.getValue(331));
				parameters.put("mn_p14", row.getValue(341));
				parameters.put("mn_p15", row.getValue(375));

				parameters.put("remark", row.getValue(327));

				parameters.put("q3_a5", row.getValue(343));
				parameters.put("q3_a6", row.getValue(344));
				parameters.put("q3_b4", row.getValue(345));
				parameters.put("q3_b5", row.getValue(346));
				parameters.put("q3_d5", row.getValue(347));
				parameters.put("q3_d6", row.getValue(348));
				parameters.put("q3_e2", row.getValue(349));
				parameters.put("q3_e3", row.getValue(350));
				parameters.put("q3_f5", row.getValue(351));
				parameters.put("q3_f6", row.getValue(352));

				parameters.put("q3_h2", row.getValue(353));
				parameters.put("q3_i1", row.getValue(354));

				parameters.put("q5_a7", row.getValue(355));

				parameters.put("female_11", row.getValue(356));
				parameters.put("female_12", row.getValue(357));

				parameters.put("q3_d7", row.getValue(358));
				parameters.put("q3_d8", row.getValue(359));
				parameters.put("q3_d9", row.getValue(360));
				parameters.put("q3_d10", row.getValue(361));

				parameters.put("eat_15", row.getValue(362));
				parameters.put("eat_16", row.getValue(363));
				parameters.put("eat_17", row.getValue(368));
				parameters.put("eat_18", row.getValue(369));
				parameters.put("eat_19", row.getValue(370));
				parameters.put("eat_20", row.getValue(371));
				parameters.put("eat_21", row.getValue(372));
				parameters.put("eat_22", row.getValue(373));
				parameters.put("eat_23", row.getValue(380));
				parameters.put("eat_24", row.getValue(381));
				parameters.put("docCName", row.getValue(364));
				//
				parameters.put("drink_15", row.getValue(374));
				//
				parameters.put("a_p42", row.getValue(377));
				parameters.put("mn_p16", row.getValue(378));
				parameters.put("mn_p17", row.getValue(379));
				parameters.put("a_p41", row.getValue(376));
				//
				parameters.put("smoke_7", row.getValue(382));
				parameters.put("sleep_3", row.getValue(383));
				parameters.put("sleep_4", row.getValue(384));
				parameters.put("sleep_5", row.getValue(385));
				parameters.put("sleep_6", row.getValue(386));
				//
				parameters.put("a_p43", row.getValue(388));

				parameters.put("phy_21", row.getValue(389));
				parameters.put("phy_22", row.getValue(390));
				parameters.put("phy_23", row.getValue(391));
				parameters.put("phy_24", row.getValue(392));
				parameters.put("phy_25", row.getValue(393));
				//
				parameters.put("q3_a7", row.getValue(394));
				parameters.put("q3_b6", row.getValue(395));
				parameters.put("q3_d11", row.getValue(396));
				parameters.put("q3_e4", row.getValue(398));
				parameters.put("q3_f7", row.getValue(397));
				parameters.put("q5_a8", row.getValue(399));
				parameters.put("gc_16", row.getValue(400));
				parameters.put("gc_17", row.getValue(401));

				parameters.put("a_p44", row.getValue(402));
				parameters.put("a_p45", row.getValue(403));
				parameters.put("a_p46", row.getValue(404));

				parameters.put("q3_g4", row.getValue(405));
				parameters.put("q3_g5", row.getValue(406));

				//new ccr form
				parameters.put("mn_p18", row.getValue(408));
				parameters.put("mn_p19", row.getValue(409));
				parameters.put("mn_p20", row.getValue(410));
				parameters.put("mn_p21", row.getValue(411));
				parameters.put("mn_p22", row.getValue(412));
				parameters.put("mn_p23", row.getValue(413));
				parameters.put("mn_p24", row.getValue(414));
				parameters.put("mn_p25", row.getValue(415));
				parameters.put("mn_p26", row.getValue(416));
				parameters.put("mn_p27", row.getValue(417));
				parameters.put("mn_p28", row.getValue(418));
				parameters.put("mn_p29", row.getValue(419));
				parameters.put("mn_p30", row.getValue(420));
				parameters.put("mn_p31", row.getValue(421));
				parameters.put("mn_p32", row.getValue(422));
				parameters.put("mn_p33", row.getValue(423));
				parameters.put("mn_p34", row.getValue(424));
				parameters.put("mn_p35", row.getValue(425));
				parameters.put("mn_p36", row.getValue(426));
				parameters.put("mn_p37", row.getValue(427));
				parameters.put("mn_p38", row.getValue(428));
				parameters.put("mn_p39", row.getValue(429));
				parameters.put("mn_p40", row.getValue(430));

				parameters.put("mn_p41", row.getValue(431));
				parameters.put("mn_p42", row.getValue(432));
				parameters.put("mn_p43", row.getValue(433));
				parameters.put("mn_p44", row.getValue(434));
				parameters.put("mn_p45", row.getValue(435));
				parameters.put("mn_p46", row.getValue(436));
				parameters.put("mn_p47", row.getValue(437));
				parameters.put("mn_p48", row.getValue(438));
				parameters.put("mn_p49", row.getValue(439));
				parameters.put("mn_p50", row.getValue(440));
				parameters.put("mn_p51", row.getValue(441));
				parameters.put("mn_p52", row.getValue(442));
				parameters.put("mn_p53", row.getValue(443));

				parameters.put("mn_p54", row.getValue(444));
				parameters.put("mn_p55", row.getValue(445));
				parameters.put("mn_p56", row.getValue(446));
				parameters.put("mn_p57", row.getValue(447));
				parameters.put("mn_p58", row.getValue(448));
				parameters.put("mn_p59", row.getValue(449));
				parameters.put("mn_p60", row.getValue(450));

				// ccr p2 p3
				parameters.put("mn_p61", row.getValue(451));
				parameters.put("mn_p62", row.getValue(452));
				parameters.put("mn_p63", row.getValue(453));
				parameters.put("mn_p64", row.getValue(454));
				parameters.put("mn_p65", row.getValue(455));
				parameters.put("mn_p66", row.getValue(456));
				parameters.put("mn_p67", row.getValue(457));
				parameters.put("mn_p68", row.getValue(458));
				parameters.put("mn_p69", row.getValue(459));
				parameters.put("mn_p70", row.getValue(460));
				parameters.put("mn_p71", row.getValue(461));
				parameters.put("mn_p72", row.getValue(462));
				parameters.put("mn_p73", row.getValue(463));
				parameters.put("mn_p74", row.getValue(464));
				parameters.put("mn_p75", row.getValue(465));
				parameters.put("mn_p76", row.getValue(467));
				parameters.put("mn_p77", row.getValue(468));
				parameters.put("mn_p78", row.getValue(469));
				parameters.put("mn_p79", row.getValue(470));
				//
				parameters.put("mn_p80", row.getValue(471));
				parameters.put("mn_p81", row.getValue(472));
				parameters.put("mn_p82", row.getValue(473));
				parameters.put("mn_p83", row.getValue(474));
				parameters.put("mn_p84", row.getValue(475));

				parameters.put("mn_p85", row.getValue(476));
				parameters.put("mn_p86", row.getValue(477));
				parameters.put("mn_p87", row.getValue(478));
				parameters.put("mn_p88", row.getValue(479));
				parameters.put("mn_p89", row.getValue(480));
				parameters.put("mn_p90", row.getValue(481));
				parameters.put("mn_p91", row.getValue(482));
				parameters.put("mn_p92", row.getValue(483));
				parameters.put("mn_p93", row.getValue(484));
				parameters.put("mn_p94", row.getValue(485));
				parameters.put("mn_p95", row.getValue(486));
				parameters.put("mn_p96", row.getValue(487));
				parameters.put("mn_p97", row.getValue(488));
				parameters.put("mn_p98", row.getValue(489));
				parameters.put("mn_p99", row.getValue(490));
				parameters.put("mn_p100", row.getValue(491));
				parameters.put("mn_p101", row.getValue(492));
				parameters.put("mn_p102", row.getValue(493));
				parameters.put("mn_p103", row.getValue(494));

				parameters.put("mn_p104", row.getValue(495));
				parameters.put("mn_p105", row.getValue(496));

				parameters.put("mn_p106", row.getValue(499));
				parameters.put("mn_p107", row.getValue(500));

				parameters.put("ccr_phase", row.getValue(466));
				parameters.put("formTypeOther", row.getValue(497));

				parameters.put("pat_add1", row.getValue(501));
				parameters.put("pat_add2", row.getValue(502));
				parameters.put("pat_add3", row.getValue(503));
				parameters.put("phy_26", row.getValue(504));
				parameters.put("patConNo", row.getValue(506));

				JasperPrint jasperPrint =
					JasperFillManager.fillReport(
						jasperReport,
						parameters,
						new ReportListDataSource(record));

				generateReport(jasperPrint, jasperPrint, jasperPrint, jasperPrint, jasperPrint, response);

			}
		}
	}
}
%>
