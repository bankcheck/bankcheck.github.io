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
    jasperPrintList.add(jasperPrint2);
    jasperPrintList.add(jasperPrint3);
    jasperPrintList.add(jasperPrint4);
    jasperPrintList.add(jasperPrint5);

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

command = "pdfAction";

if(command != null && command.equals("pdfAction")){	
	if (haID != null && haID.length() > 0) {
		ArrayList record = HAFormDB.getHAReportReport(haID);	
		if (record.size() > 0  && "pdfAction".equals(command) ) {
			// Report page 1
			File reportFile = new File(application.getRealPath("/report/HAForm.jasper"));
			if (reportFile.exists()) {
				JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
				
				Map parameters = new HashMap();
				parameters.put("BaseDir", reportFile.getParentFile());
				ReportableListObject row = (ReportableListObject) record.get(0);				
				
				// set report fields value
				parameters.put("patName", row.getValue(336));
				parameters.put("patAge", row.getValue(337));
				parameters.put("patSex", row.getValue(338));
				parameters.put("patDOB", row.getValue(339));
				parameters.put("patNo", row.getValue(2));
				parameters.put("createDate", row.getValue(334));
				parameters.put("createTime", row.getValue(335));
				parameters.put("formType", row.getValue(3));
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
				


				JasperPrint jasperPrint =
					JasperFillManager.fillReport(
						jasperReport,
						parameters,
						new ReportListDataSource(record));
				
				File reportFile2 = new File(application.getRealPath("/report/HAForm_p2.jasper"));				
				JasperReport jasperReport2 = (JasperReport)JRLoader.loadObject(reportFile2.getPath());				
				Map parameters2 = new HashMap();
				// Report page 2				
				// set report fields value
				parameters2.put("patName", row.getValue(336));
				parameters2.put("patAge", row.getValue(337));
				parameters2.put("patSex", row.getValue(338));
				parameters2.put("patDOB", row.getValue(339));
				parameters2.put("patNo", row.getValue(2));
				parameters2.put("createDate", row.getValue(334));
				parameters2.put("createTime", row.getValue(335));
				parameters2.put("formType", row.getValue(3));
				parameters2.put("completed", row.getValue(328));
				parameters2.put("BaseDir", reportFile.getParentFile());
				parameters2.put("patCName", row.getValue(342));
				parameters2.put("docName", row.getValue(340));
				
				parameters2.put("smoke_1", row.getValue(47));
				parameters2.put("smoke_2", row.getValue(48));
				parameters2.put("smoke_3", row.getValue(49));
				parameters2.put("smoke_4", row.getValue(50));
				parameters2.put("smoke_5", row.getValue(51));
				parameters2.put("smoke_6", row.getValue(52));
				parameters2.put("drink_1", row.getValue(53));
				parameters2.put("drink_2", row.getValue(54));
				parameters2.put("drink_3", row.getValue(55));
				parameters2.put("drink_4", row.getValue(56));
				parameters2.put("drink_5", row.getValue(57));
				parameters2.put("drink_6", row.getValue(58));
				parameters2.put("drink_7", row.getValue(59));
				parameters2.put("drink_8", row.getValue(60));
				parameters2.put("drink_9", row.getValue(61));
				parameters2.put("drink_10", row.getValue(62));
				parameters2.put("drink_11", row.getValue(63));
				parameters2.put("drink_12", row.getValue(64));
				parameters2.put("drink_13", row.getValue(65));
				parameters2.put("drink_14", row.getValue(66));
				parameters2.put("eat_1", row.getValue(67));
				parameters2.put("eat_2", row.getValue(68));
				parameters2.put("eat_3", row.getValue(69));
				parameters2.put("eat_4", row.getValue(70));
				parameters2.put("eat_5", row.getValue(71));
				parameters2.put("eat_6", row.getValue(72));
				parameters2.put("eat_7", row.getValue(73));
				parameters2.put("eat_8", row.getValue(74));
				parameters2.put("eat_9", row.getValue(75));
				parameters2.put("eat_10", row.getValue(76));
				parameters2.put("eat_11", row.getValue(77));
				parameters2.put("eat_12", row.getValue(78));
				parameters2.put("eat_13", row.getValue(79));
				parameters2.put("eat_14", row.getValue(80));
				parameters2.put("sleep_1", row.getValue(81));
				parameters2.put("sleep_2", row.getValue(82));
				parameters2.put("sport_1", row.getValue(83));
				parameters2.put("sport_2", row.getValue(84));
				parameters2.put("sport_3", row.getValue(85));
				parameters2.put("sport_4", row.getValue(86));
				parameters2.put("mood_1", row.getValue(87));
				parameters2.put("mood_2", row.getValue(88));
				parameters2.put("mood_3", row.getValue(89));
				parameters2.put("mood_4", row.getValue(90));
				parameters2.put("female_1", row.getValue(91));
				parameters2.put("female_2", row.getValue(92));
				parameters2.put("female_3", row.getValue(93));
				parameters2.put("female_4", row.getValue(94));
				parameters2.put("female_5", row.getValue(95));
				parameters2.put("female_6", row.getValue(96));
				parameters2.put("female_7", row.getValue(97));
				parameters2.put("female_8", row.getValue(98));
				parameters2.put("female_9", row.getValue(99));	
				parameters2.put("female_10", row.getValue(100));
				//
				JasperPrint jasperPrint2 =
					JasperFillManager.fillReport(
						jasperReport2,
						parameters2,
						new ReportListDataSource(record));
				
				
				File reportFile3 = new File(application.getRealPath("/report/HAForm_p3.jasper"));				
				JasperReport jasperReport3 = (JasperReport)JRLoader.loadObject(reportFile3.getPath());				
				Map parameters3 = new HashMap();
				// Report page 3				
				// set report fields value
				parameters3.put("patName", row.getValue(336));
				parameters3.put("patAge", row.getValue(337));
				parameters3.put("patSex", row.getValue(338));
				parameters3.put("patDOB", row.getValue(339));
				parameters3.put("patNo", row.getValue(2));
				parameters3.put("createDate", row.getValue(334));
				parameters3.put("createTime", row.getValue(335));
				parameters3.put("formType", row.getValue(3));
				parameters3.put("completed", row.getValue(328));
				parameters3.put("BaseDir", reportFile.getParentFile());
				parameters3.put("patCName", row.getValue(342));
				parameters3.put("docName", row.getValue(340));
				
				parameters3.put("gc_1", row.getValue(118));	
				parameters3.put("gc_2", row.getValue(119));
				parameters3.put("gc_3", row.getValue(120));
				parameters3.put("gc_4", row.getValue(121));
				parameters3.put("gc_5", row.getValue(122));
				parameters3.put("gc_6", row.getValue(123));
				
				parameters3.put("gc_7", row.getValue(124));
				parameters3.put("gc_8", row.getValue(125));
				parameters3.put("gc_9", row.getValue(126));
				parameters3.put("gc_10", row.getValue(127));
				parameters3.put("gc_11", row.getValue(128));
				parameters3.put("gc_12", row.getValue(129));
				
				parameters3.put("gc_13", row.getValue(130));
				parameters3.put("gc_14", row.getValue(131));
				parameters3.put("gc_15", row.getValue(132));
			
				parameters3.put("ent_p1", row.getValue(133));
				parameters3.put("ent_p2", row.getValue(134));
				parameters3.put("ent_p3", row.getValue(135));
				parameters3.put("ent_p4", row.getValue(136));
				parameters3.put("ent_p5", row.getValue(137));
				parameters3.put("ent_p6", row.getValue(138));
				parameters3.put("ent_p7", row.getValue(139));
				parameters3.put("ent_p8", row.getValue(140));
				parameters3.put("ent_p9", row.getValue(141));
				parameters3.put("ent_p10", row.getValue(142));
				parameters3.put("ent_p11", row.getValue(143));
				parameters3.put("ent_p12", row.getValue(144));
				parameters3.put("ent_p13", row.getValue(145));
				parameters3.put("ent_p14", row.getValue(146));
				parameters3.put("ent_p15", row.getValue(147));
				parameters3.put("ent_p16", row.getValue(148));
				
				parameters3.put("ent_p17", row.getValue(149));
				parameters3.put("ent_p18", row.getValue(150));
				parameters3.put("ent_p19", row.getValue(151));
				parameters3.put("ent_p20", row.getValue(152));
				parameters3.put("ent_p21", row.getValue(153));	
				
				parameters3.put("ent_p22", row.getValue(154));
				parameters3.put("ent_p23", row.getValue(155));
				parameters3.put("ent_p24", row.getValue(156));
				parameters3.put("ent_p25", row.getValue(157));
				parameters3.put("ent_p26", row.getValue(158));
				parameters3.put("ent_p27", row.getValue(159));
				parameters3.put("ent_p28", row.getValue(160));
				parameters3.put("ent_p29", row.getValue(161));
				parameters3.put("ent_p30", row.getValue(162));
				parameters3.put("ent_p31", row.getValue(163));
				parameters3.put("ent_p32", row.getValue(164));
				parameters3.put("ent_p33", row.getValue(165));
				parameters3.put("ent_p34", row.getValue(166));
				
				parameters3.put("ent_p35", row.getValue(167));
				parameters3.put("ent_p36", row.getValue(168));
				parameters3.put("ent_p37", row.getValue(169));
				parameters3.put("ent_p38", row.getValue(170));
				parameters3.put("ent_p39", row.getValue(171));
				parameters3.put("ent_p40", row.getValue(172));
				parameters3.put("ent_p41", row.getValue(173));
				parameters3.put("ent_p42", row.getValue(174));
				parameters3.put("ent_p43", row.getValue(175));
				parameters3.put("ent_p44", row.getValue(176));
				parameters3.put("ent_p45", row.getValue(177));
				
				parameters3.put("ent_p46", row.getValue(302));
				parameters3.put("ent_p47", row.getValue(303));
				parameters3.put("ent_p48", row.getValue(304));
				parameters3.put("ent_p49", row.getValue(305));
				parameters3.put("ent_p50", row.getValue(306));
				parameters3.put("ent_p51", row.getValue(307));
				
				parameters3.put("ent_p52", row.getValue(314));
				parameters3.put("ent_p53", row.getValue(315));
				parameters3.put("ent_p54", row.getValue(316));
				parameters3.put("ent_p55", row.getValue(317));
				
				parameters3.put("ls_1", row.getValue(178));
				parameters3.put("ls_2", row.getValue(179));
				parameters3.put("ls_3", row.getValue(180));
				parameters3.put("ls_4", row.getValue(181));
				parameters3.put("ls_5", row.getValue(182));
				parameters3.put("ls_6", row.getValue(183));

				//
				JasperPrint jasperPrint3 =
					JasperFillManager.fillReport(
						jasperReport3,
						parameters3,
						new ReportListDataSource(record));
				
				File reportFile4 = new File(application.getRealPath("/report/HAForm_p4.jasper"));				
				JasperReport jasperReport4 = (JasperReport)JRLoader.loadObject(reportFile4.getPath());				
				Map parameters4 = new HashMap();
				// Report page 3				
				// set report fields value
				parameters4.put("patName", row.getValue(336));
				parameters4.put("patAge", row.getValue(337));
				parameters4.put("patSex", row.getValue(338));
				parameters4.put("patDOB", row.getValue(339));
				parameters4.put("patNo", row.getValue(2));
				parameters4.put("createDate", row.getValue(334));
				parameters4.put("createTime", row.getValue(335));
				parameters4.put("formType", row.getValue(3));
				parameters4.put("completed", row.getValue(328));
				parameters4.put("BaseDir", reportFile.getParentFile());
				parameters4.put("patCName", row.getValue(342));
				parameters4.put("docName", row.getValue(340));
				
				parameters4.put("bn_1",  row.getValue(184));
				parameters4.put("bn_2",  row.getValue(185));
				parameters4.put("bn_3",  row.getValue(186));
				parameters4.put("bn_4",  row.getValue(187));
				parameters4.put("bn_5",  row.getValue(188));
				parameters4.put("bn_6",  row.getValue(189));
				parameters4.put("bn_7",  row.getValue(190));
				parameters4.put("bn_8",  row.getValue(191));
				parameters4.put("bn_9",  row.getValue(192));
				parameters4.put("bn_10",  row.getValue(193));
				parameters4.put("bn_11",  row.getValue(194));
				parameters4.put("bn_12",  row.getValue(195));
				parameters4.put("bn_13",  row.getValue(196));
				parameters4.put("bn_14",  row.getValue(197));
				parameters4.put("bn_15",  row.getValue(198));
				parameters4.put("bn_16",  row.getValue(199));
				
				parameters4.put("rs_1",  row.getValue(200));
				parameters4.put("rs_2",  row.getValue(201));
				parameters4.put("rs_3",  row.getValue(202));
				parameters4.put("rs_4",  row.getValue(203));
				parameters4.put("rs_5",  row.getValue(204));
				parameters4.put("rs_6",  row.getValue(205));
				parameters4.put("rs_7",  row.getValue(206));
				parameters4.put("rs_8",  row.getValue(207));
				parameters4.put("rs_9",  row.getValue(208));
				parameters4.put("rs_10",  row.getValue(209));
				
				parameters4.put("rs_11",  row.getValue(308));
				parameters4.put("rs_12",  row.getValue(309));
				parameters4.put("rs_13",  row.getValue(310));
				parameters4.put("rs_14",  row.getValue(311));
				parameters4.put("rs_15",  row.getValue(312));
				parameters4.put("rs_16",  row.getValue(313));
				
				
				parameters4.put("cs_1",  row.getValue(210));
				parameters4.put("cs_2",  row.getValue(211));
				parameters4.put("cs_3",  row.getValue(212));
				parameters4.put("cs_4",  row.getValue(213));
				parameters4.put("cs_5",  row.getValue(214));
				parameters4.put("cs_6",  row.getValue(215));
				parameters4.put("cs_7",  row.getValue(216));
				parameters4.put("cs_8",  row.getValue(217));
				
				parameters4.put("ne_1",  row.getValue(218));
				parameters4.put("ne_2",  row.getValue(219));
				parameters4.put("ne_3",  row.getValue(220));
				parameters4.put("ne_4",  row.getValue(221));
				parameters4.put("ne_5",  row.getValue(222));
				parameters4.put("ne_6",  row.getValue(223));
				parameters4.put("ne_7",  row.getValue(224));
				parameters4.put("ne_8",  row.getValue(225));
				parameters4.put("ne_9",  row.getValue(226));
				parameters4.put("ne_10",  row.getValue(227));
				parameters4.put("ne_11",  row.getValue(228));
				parameters4.put("ne_12",  row.getValue(229));
				parameters4.put("ne_13",  row.getValue(230));
				parameters4.put("ne_14",  row.getValue(231));
				parameters4.put("ne_15",  row.getValue(232));
				parameters4.put("ne_16",  row.getValue(233));
				parameters4.put("ne_17",  row.getValue(234));
				parameters4.put("ne_18",  row.getValue(235));
				parameters4.put("ne_19",  row.getValue(236));
				parameters4.put("ne_20",  row.getValue(237));
				
				parameters4.put("s_1",  row.getValue(238));
				parameters4.put("s_2",  row.getValue(239));
				parameters4.put("s_3",  row.getValue(240));
				parameters4.put("s_4",  row.getValue(241));
				
				parameters4.put("a_p0",  row.getValue(242));
				parameters4.put("a_p1",  row.getValue(243));
				parameters4.put("a_p2",  row.getValue(244));
				parameters4.put("a_p3",  row.getValue(245));
				parameters4.put("a_p4",  row.getValue(246));
				parameters4.put("a_p5",  row.getValue(247));
				parameters4.put("a_p6",  row.getValue(248));
				parameters4.put("a_p7",  row.getValue(249));
				parameters4.put("a_p8",  row.getValue(250));
				parameters4.put("a_p9",  row.getValue(251));
				parameters4.put("a_p10",  row.getValue(252));
				parameters4.put("a_p11",  row.getValue(253));
				parameters4.put("a_p12",  row.getValue(254));
				parameters4.put("a_p13",  row.getValue(255));
				parameters4.put("a_p14",  row.getValue(256));
				parameters4.put("a_p15",  row.getValue(257));
				parameters4.put("a_p16",  row.getValue(258));
				parameters4.put("a_p17",  row.getValue(259));
				parameters4.put("a_p18",  row.getValue(260));
				parameters4.put("a_p19",  row.getValue(261));
				parameters4.put("a_p20",  row.getValue(262));
				parameters4.put("a_p21",  row.getValue(263));
				parameters4.put("a_p22",  row.getValue(264));
				parameters4.put("a_p23",  row.getValue(265));
				parameters4.put("a_p24",  row.getValue(266));
				parameters4.put("a_p25",  row.getValue(267));
				parameters4.put("a_p26",  row.getValue(268));
				parameters4.put("a_p27",  row.getValue(269));
				parameters4.put("a_p28",  row.getValue(270));
				parameters4.put("a_p29",  row.getValue(271));
				parameters4.put("a_p30",  row.getValue(272));
				parameters4.put("a_p31",  row.getValue(273));
				
				parameters4.put("a_p32",  row.getValue(318));
				parameters4.put("a_p33",  row.getValue(319));
				parameters4.put("a_p34",  row.getValue(320));
				parameters4.put("a_p35",  row.getValue(321));
				parameters4.put("a_p36",  row.getValue(322));
				parameters4.put("a_p37",  row.getValue(323));
				parameters4.put("a_p38",  row.getValue(324));
				parameters4.put("a_p39",  row.getValue(325));
				
				parameters4.put("a_p40",  row.getValue(326));

				//
				JasperPrint jasperPrint4 =
					JasperFillManager.fillReport(
						jasperReport4,
						parameters4,
						new ReportListDataSource(record));

				File reportFile5  = new File(application.getRealPath("/report/HAForm_p5.jasper"));				
				JasperReport jasperReport5 = (JasperReport)JRLoader.loadObject(reportFile5 .getPath());				
				Map parameters5 = new HashMap();
				// Report page 3				
				// set report fields value
				parameters5.put("patName", row.getValue(336));
				parameters5.put("patAge", row.getValue(337));
				parameters5.put("patSex", row.getValue(338));
				parameters5.put("patDOB", row.getValue(339));
				parameters5.put("patNo", row.getValue(2));
				parameters5.put("createDate", row.getValue(334));
				parameters5.put("createTime", row.getValue(335));
				parameters5.put("formType", row.getValue(3));
				parameters5.put("completed", row.getValue(328));
				parameters5.put("BaseDir", reportFile.getParentFile());
				parameters5.put("patCName", row.getValue(342));
				parameters5.put("docName", row.getValue(340));
				
				parameters5.put("a_p0",  row.getValue(242));
				parameters5.put("a_p1",  row.getValue(243));
				parameters5.put("a_p2",  row.getValue(244));
				parameters5.put("a_p3",  row.getValue(245));
				parameters5.put("a_p4",  row.getValue(246));
				parameters5.put("a_p5",  row.getValue(247));
				parameters5.put("a_p6",  row.getValue(248));
				parameters5.put("a_p7",  row.getValue(249));
				parameters5.put("a_p8",  row.getValue(250));
				parameters5.put("a_p9",  row.getValue(251));
				parameters5.put("a_p10",  row.getValue(252));
				parameters5.put("a_p11",  row.getValue(253));
				parameters5.put("a_p12",  row.getValue(254));
				parameters5.put("a_p13",  row.getValue(255));
				parameters5.put("a_p14",  row.getValue(256));
				parameters5.put("a_p15",  row.getValue(257));
				parameters5.put("a_p16",  row.getValue(258));
				parameters5.put("a_p17",  row.getValue(259));
				parameters5.put("a_p18",  row.getValue(260));
				parameters5.put("a_p19",  row.getValue(261));
				parameters5.put("a_p20",  row.getValue(262));
				parameters5.put("a_p21",  row.getValue(263));
				parameters5.put("a_p22",  row.getValue(264));
				parameters5.put("a_p23",  row.getValue(265));
				parameters5.put("a_p24",  row.getValue(266));
				parameters5.put("a_p25",  row.getValue(267));
				parameters5.put("a_p26",  row.getValue(268));
				parameters5.put("a_p27",  row.getValue(269));
				parameters5.put("a_p28",  row.getValue(270));
				parameters5.put("a_p29",  row.getValue(271));
				parameters5.put("a_p30",  row.getValue(272));
				parameters5.put("a_p31",  row.getValue(273));
				
				parameters5.put("a_p32",  row.getValue(318));
				parameters5.put("a_p33",  row.getValue(319));
				parameters5.put("a_p34",  row.getValue(320));
				parameters5.put("a_p35",  row.getValue(321));
				parameters5.put("a_p36",  row.getValue(322));
				parameters5.put("a_p37",  row.getValue(323));
				parameters5.put("a_p38",  row.getValue(324));
				parameters5.put("a_p39",  row.getValue(325));				
				parameters5.put("a_p40",  row.getValue(326));
				
				parameters5.put("ex_1", row.getValue(274));
				parameters5.put("ex_2", row.getValue(275));

				
				parameters5.put("mn_p0", row.getValue(276));
				parameters5.put("mn_p1", row.getValue(277));
				parameters5.put("mn_p2", row.getValue(278));
				parameters5.put("mn_p3", row.getValue(279));
				parameters5.put("mn_p4", row.getValue(280));
				parameters5.put("mn_p5", row.getValue(281));
				parameters5.put("mn_p6", row.getValue(282));
				parameters5.put("mn_p7", row.getValue(283));
				parameters5.put("mn_p8", row.getValue(284));
				parameters5.put("mn_p9", row.getValue(285));
				parameters5.put("mn_p10", row.getValue(286));
				
				parameters5.put("mn_p11", row.getValue(329));
				parameters5.put("mn_p12", row.getValue(330));
				parameters5.put("mn_p13", row.getValue(331));
				parameters5.put("mn_p14", row.getValue(341));
				
				parameters5.put("remark", row.getValue(327));

				
				JasperPrint jasperPrint5 =
						JasperFillManager.fillReport(
							jasperReport5,
							parameters5,
							new ReportListDataSource(record));
				
				generateReport(jasperPrint, jasperPrint2, jasperPrint3, jasperPrint4, jasperPrint5, response);				

			}
		}
	}
}
%>
