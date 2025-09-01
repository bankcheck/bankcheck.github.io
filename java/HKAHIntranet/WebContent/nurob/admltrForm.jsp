<%@ page trimDirectiveWhitespaces="true" %>
<%@ page import="java.net.*"%>
<%@ page import="java.math.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.hkah.config.*"%>
<%@ page import="com.hkah.constant.*"%>
<%@ page import="com.hkah.util.*"%>
<%@ page import="com.hkah.util.db.*"%>
<%@ page import="com.hkah.web.common.*"%>
<%@ page import="com.hkah.web.db.*"%>
<%@ page import="com.hkah.jasper.*"%>
<%@ page import="com.hkah.servlet.*"%>
<%@ page import="net.sf.jasperreports.engine.*" %>
<%@ page import="net.sf.jasperreports.engine.util.*" %>
<%@ page import="net.sf.jasperreports.engine.export.*" %>
<%@ page import="net.sf.jasperreports.j2ee.servlets.*" %>
<%@ page import="java.io.*"%>
<%@ page import="java.util.regex.*"%>
<%!

public static Map<String, String> getQueryMap(String query)
{
    String[] params = query.split("&");
    Map<String, String> map = new HashMap<String, String>();
    for (String param : params)
    {
    	String[] array = param.split("=");
    	if (array != null) {
	        String name = (array.length > 0 ? array[0] : null);
	        String value = (array.length > 1 ? array[1] : null);
	        map.put(name, value);
    	}
    }
    return map;
}

public static Map<String, String> removeHTMLInputPrefixName(Map<String, String> params) {
	if (params == null)
		return null;
	
	Map<String, String> ret = new HashMap<String, String>();
	String matchRegex = "^((tf|st|cb|rb)_{1})";
	Matcher matcher = null;
	
	Set<String> keySet = params.keySet();
	Iterator<String> it = keySet.iterator();
	while (it.hasNext()) {
		String paramName = it.next();
		if (paramName != null && !"null".equals(paramName)) {
			String value = params.get(paramName);
			
			if (paramName.startsWith("cb_")) {
				value = ("true".equals(value)) ? "Y" : "N";
			}
			paramName = paramName.replaceAll(matchRegex, "");
			//System.out.println(" -> " + paramName);
			
			ret.put(paramName, (value == null || "null".equals(value)) ? "" : value);
		}
	}
	
	return ret;
}

// Should move to StringUtils
public static String emptyWhenNull(String value) {
	if (value == null)
		return "";
	return value;
}
%>
<%

UserBean userBean = new UserBean(request);

// Testing data
/*
NurobAdmltrDB.add(userBean, "2", "3","4","5","6", "7", "8", "01/01/2011", "0",
		            "1","2", "3","4","5","6", "7", "8", "9", "0",
		            "1","2", "3","4","5","6", "7", "8", "9", "0",
		            "1","2", "3","4","5","6", "7", "8", "9", "0",
		            "1","2", "3","4","5","6", "7", "8", "9", "0",
		            "1","2", "3","4","5","01/01/2011", "7", "8", "9", "0",
		            "1","2", "3","4","5","6");
*/

String command = ParserUtil.getParameter(request, "command");
String step = ParserUtil.getParameter(request, "step");

String formParams = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "formParams"));

String nurobAdmltrId = ParserUtil.getParameter(request, "nurobAdmltrId");
String nurobPatient = ParserUtil.getParameter(request, "nurobPatient");
String nurobAge = ParserUtil.getParameter(request, "nurobAge");
String nurobTelno = ParserUtil.getParameter(request, "nurobTelno");
String nurobBookno = ParserUtil.getParameter(request, "nurobBookno");

String nurobStatus = ParserUtil.getParameter(request, "nurobStatus");
String nurobGravida = ParserUtil.getParameter(request, "nurobGravida");
String nurobPara = ParserUtil.getParameter(request, "nurobPara");
String nurobEdc = ParserUtil.getParameter(request, "nurobEdc");
String nurobDr = ParserUtil.getParameter(request, "nurobDr");
String nurobClinic = ParserUtil.getParameter(request, "nurobClinic");
String nurobAllergy = ParserUtil.getParameter(request, "nurobAllergy");
String nurobCardiac = ParserUtil.getParameter(request, "nurobCardiac");
String nurobDiabetes = ParserUtil.getParameter(request, "nurobDiabetes");
String nurobDm = ParserUtil.getParameter(request, "nurobDm");
String nurobGdm = ParserUtil.getParameter(request, "nurobGdm");
String nurobIgt = ParserUtil.getParameter(request, "nurobIgt");
String nurobAnemia = ParserUtil.getParameter(request, "nurobAnemia");
String nurobRenal = ParserUtil.getParameter(request, "nurobRenal");
String nurobLiver = ParserUtil.getParameter(request, "nurobLiver");
String nurobResp = ParserUtil.getParameter(request, "nurobResp");
String nurobGi = ParserUtil.getParameter(request, "nurobGi");
String nurobEpilepsy = ParserUtil.getParameter(request, "nurobEpilepsy");
String nurobPsychiatric = ParserUtil.getParameter(request, "nurobPsychiatric");
String nurobImmun = ParserUtil.getParameter(request, "nurobImmun");
String nurobThyroid = ParserUtil.getParameter(request, "nurobThyroid");
String nurobSurg = ParserUtil.getParameter(request, "nurobSurg");

String nurobMulti = ParserUtil.getParameter(request, "nurobMulti");
String nurobPrevious = ParserUtil.getParameter(request, "nurobPrevious");
String nurobHyper = ParserUtil.getParameter(request, "nurobHyper");

String nurobAph = ParserUtil.getParameter(request, "nurobAph");
String nurobPreterm = ParserUtil.getParameter(request, "nurobPreterm");
String nurobBadob = ParserUtil.getParameter(request, "nurobBadob");
String nurobIugr = ParserUtil.getParameter(request, "nurobIugr");
String nurobFetal = ParserUtil.getParameter(request, "nurobFetal");
String nurobRoutine = ParserUtil.getParameter(request, "nurobRoutine");
String nurobInduct = ParserUtil.getParameter(request, "nurobInduct");
String nurobElective = ParserUtil.getParameter(request, "nurobElective");
String nurobCurrmed = ParserUtil.getParameter(request, "nurobCurrmed");
String nurobRoom = ParserUtil.getParameter(request, "nurobRoom");
String nurobCord = ParserUtil.getParameter(request, "nurobCord");

String nurobTriallabor = ParserUtil.getParameter(request, "nurobTriallabor");
String nurobTrialscar = ParserUtil.getParameter(request, "nurobTrialscar");
String nurobFleet = ParserUtil.getParameter(request, "nurobFleet");
String nurobShaving = ParserUtil.getParameter(request, "nurobShaving");
String nurobPain = ParserUtil.getParameter(request, "nurobPain");
String nurobPainPeth = ParserUtil.getParameter(request, "nurobPainPeth");
String nurobNotify = ParserUtil.getParameter(request, "nurobNotify");
String nurobAnytime = ParserUtil.getParameter(request, "nurobAnytime");
String nurobAfter06 = ParserUtil.getParameter(request, "nurobAfter06");
String nurobNpo = ParserUtil.getParameter(request, "nurobNpo");
String nurobHep = ParserUtil.getParameter(request, "nurobHep");
String nurobPps = ParserUtil.getParameter(request, "nurobPps");
String nurobPost = ParserUtil.getParameter(request, "nurobPost");
String nurobCs = ParserUtil.getParameter(request, "nurobCs");

String nurobCsbtl = ParserUtil.getParameter(request, "nurobCsbtl");
String nurobCsdate = ParserUtil.getParameter(request, "nurobCsdate");
String nurobCsseltime = ParserUtil.getParameter(request, "nurobCsseltime");
String nurobGa = ParserUtil.getParameter(request, "nurobGa");
String nurobSa = ParserUtil.getParameter(request, "nurobSa");
String nurobIndication = ParserUtil.getParameter(request, "nurobIndication");
String nurobIndicationText = ParserUtil.getParameter(request, "nurobIndicationText");
String nurobAbdominal = ParserUtil.getParameter(request, "nurobAbdominal");
String nurobPublic = ParserUtil.getParameter(request, "nurobPublic");
String nurobAnesdr = ParserUtil.getParameter(request, "nurobAnesdr");
String nurobPremed = ParserUtil.getParameter(request, "nurobPremed");
String nurobPeddr = ParserUtil.getParameter(request, "nurobPeddr");
String nurobFeed = ParserUtil.getParameter(request, "nurobFeed");
String nurobOther = ParserUtil.getParameter(request, "nurobOther");

Map<String, String> formParamsMap = null;
if (formParams != null) {
	formParams = URLDecoder.decode(formParams);
	formParamsMap = getQueryMap(formParams);
	formParamsMap = removeHTMLInputPrefixName(formParamsMap);

	nurobPatient = formParamsMap.get("nurobPatient");
	nurobAge = formParamsMap.get("nurobAge");
	nurobTelno = formParamsMap.get("nurobTelno");
	nurobBookno = formParamsMap.get("nurobBookno");

	nurobStatus = formParamsMap.get("nurobStatus");
	nurobGravida = formParamsMap.get("nurobGravida");
	nurobPara = formParamsMap.get("nurobPara");
	nurobEdc = formParamsMap.get("nurobEdc");
	nurobDr = formParamsMap.get("nurobDr");
	nurobClinic = formParamsMap.get("nurobClinic");
	nurobAllergy = formParamsMap.get("nurobAllergy");
	nurobCardiac = formParamsMap.get("nurobCardiac");
	nurobDiabetes = formParamsMap.get("nurobDiabetes");
	nurobDm = formParamsMap.get("nurobDm");
	nurobGdm = formParamsMap.get("nurobGdm");
	nurobIgt = formParamsMap.get("nurobIgt");
	nurobAnemia = formParamsMap.get("nurobAnemia");
	nurobRenal = formParamsMap.get("nurobRenal");
	nurobLiver = formParamsMap.get("nurobLiver");
	nurobResp = formParamsMap.get("nurobResp");
	nurobGi = formParamsMap.get("nurobGi");
	nurobEpilepsy = formParamsMap.get("nurobEpilepsy");
	nurobPsychiatric = formParamsMap.get("nurobPsychiatric");
	nurobImmun = formParamsMap.get("nurobImmun");
	nurobThyroid = formParamsMap.get("nurobThyroid");
	nurobSurg = formParamsMap.get("nurobSurg");

	nurobMulti = formParamsMap.get("nurobMulti");
	nurobPrevious = formParamsMap.get("nurobPrevious");
	nurobHyper = formParamsMap.get("nurobHyper");

	nurobAph = formParamsMap.get("nurobAph");
	nurobPreterm = formParamsMap.get("nurobPreterm");
	nurobBadob = formParamsMap.get("nurobBadob");
	nurobIugr = formParamsMap.get("nurobIugr");
	nurobFetal = formParamsMap.get("nurobFetal");
	nurobRoutine = formParamsMap.get("nurobRoutine");
	nurobInduct = formParamsMap.get("nurobInduct");
	nurobElective = formParamsMap.get("nurobElective");
	nurobCurrmed = formParamsMap.get("nurobCurrmed");
	nurobRoom = formParamsMap.get("nurobRoom");
	nurobCord = formParamsMap.get("nurobCord");

	nurobTriallabor = formParamsMap.get("nurobTriallabor");
	nurobTrialscar = formParamsMap.get("nurobTrialscar");
	nurobFleet = formParamsMap.get("nurobFleet");
	nurobShaving = formParamsMap.get("nurobShaving");
	nurobPain = formParamsMap.get("nurobPain");
	nurobPainPeth = formParamsMap.get("nurobPainPeth");
	nurobNotify = formParamsMap.get("nurobNotify");
	nurobAnytime = formParamsMap.get("nurobAnytime");
	nurobAfter06 = formParamsMap.get("nurobAfter06");
	nurobNpo = formParamsMap.get("nurobNpo");
	nurobHep = formParamsMap.get("nurobHep");
	nurobPps = formParamsMap.get("nurobPps");
	nurobPost = formParamsMap.get("nurobPost");
	nurobCs = formParamsMap.get("nurobCs");

	nurobCsbtl = formParamsMap.get("nurobCsbtl");
	nurobCsdate = formParamsMap.get("nurobCsdate");
	nurobCsseltime = formParamsMap.get("nurobCsseltime");
	nurobGa = formParamsMap.get("nurobGa");
	nurobSa = formParamsMap.get("nurobSa");
	nurobIndication = formParamsMap.get("nurobIndication");
	nurobIndicationText = formParamsMap.get("nurobIndicationText");
	nurobAbdominal = formParamsMap.get("nurobAbdominal");
	nurobPublic = formParamsMap.get("nurobPublic");
	nurobAnesdr = formParamsMap.get("nurobAnesdr");
	nurobPremed = formParamsMap.get("nurobPremed");
	nurobPeddr = formParamsMap.get("nurobPeddr");
	nurobFeed = formParamsMap.get("nurobFeed");
	nurobOther = formParamsMap.get("nurobOther");
}

String message = ParserUtil.getParameter(request, "message");
String errorMessage = ParserUtil.getParameter(request, "errorMessage");

boolean createAction = false;
boolean updateAction = false;
boolean deleteAction = false;
boolean previewAction = false;
boolean exportPdfAction = false;
boolean closeAction = false;

if ("create".equals(command)) {
	createAction = true;
} else if ("update".equals(command)) {
	updateAction = true;
} else if ("delete".equals(command)) {
	deleteAction = true;
} else if ("preview".equals(command)) {
	previewAction = true;	
} else if ("exportPdf".equals(command)) {
	exportPdfAction = true;
}

try {
	if ("1".equals(step)) {
		//formParamsMap = removeHTMLInputPrefixName(formParamsMap);
		
		if (createAction) {
			nurobAdmltrId = NurobAdmltrDB.add(
					userBean,
					nurobPatient, nurobAge,
					nurobTelno, nurobBookno,
					nurobStatus, nurobGravida,
					nurobPara, nurobEdc,
					nurobDr, nurobClinic,
					nurobAllergy, nurobCardiac,
					nurobDiabetes, nurobDm,
					nurobGdm, nurobIgt,
					nurobAnemia, nurobRenal,
					nurobLiver,	nurobResp,
					nurobGi, nurobEpilepsy,
					nurobPsychiatric, nurobImmun,
					nurobThyroid, nurobSurg,
					nurobMulti, nurobPrevious,
					nurobHyper, nurobAph,
					nurobPreterm, nurobBadob,
					nurobIugr, nurobFetal,
					nurobRoutine, nurobInduct,
					nurobElective, nurobCurrmed,
					nurobRoom, nurobCord,
					nurobTriallabor, nurobTrialscar,
					nurobFleet,	nurobShaving,
					nurobPain, nurobPainPeth,
					nurobNotify,
					nurobAnytime, nurobAfter06,
					nurobNpo, nurobHep,
					nurobPps, nurobPost,
					nurobCs, nurobCsbtl,
					nurobCsdate, nurobCsseltime,
					nurobGa,
					nurobSa, nurobIndication,
					nurobIndicationText,
					nurobAbdominal, nurobPublic,
					nurobAnesdr, nurobPremed,
					nurobPeddr,	nurobFeed,
					nurobOther
				);

			if (nurobAdmltrId != null) {
				message = "Letter created.";
				createAction = false;
			} else {
				errorMessage = "Letter create fail.";
			}
		} else if (updateAction) {
			boolean success = false; 
			if (nurobAdmltrId != null) {
				success = NurobAdmltrDB.update(
						userBean,
						nurobAdmltrId, 
						nurobPatient, 
						nurobAge,
						nurobTelno, 
						nurobBookno,
						nurobStatus, 
						nurobGravida,
						nurobPara,
						nurobEdc,
						nurobDr,
						nurobClinic,
						nurobAllergy,
						nurobCardiac,
						nurobDiabetes,
						nurobDm,
						nurobGdm,
						nurobIgt,
						nurobAnemia,
						nurobRenal,
						nurobLiver, 
						nurobResp,
						nurobGi,
						nurobEpilepsy,
						nurobPsychiatric,
						nurobImmun,
						nurobThyroid,
						nurobSurg,
						nurobMulti,
						nurobPrevious,
						nurobHyper,
						nurobAph,
						nurobPreterm,
						nurobBadob,
						nurobIugr,
						nurobFetal,
						nurobRoutine,
						nurobInduct,
						nurobElective,
						nurobCurrmed,
						nurobRoom,
						nurobCord,
						nurobTriallabor,
						nurobTrialscar,
						nurobFleet, 
						nurobShaving,
						nurobPain,
						nurobPainPeth,
						nurobNotify,
						nurobAnytime,
						nurobAfter06,
						nurobNpo,
						nurobHep,
						nurobPps,
						nurobPost,
						nurobCs,
						nurobCsbtl,
						nurobCsdate,
						nurobCsseltime,
						nurobGa,
						nurobSa,
						nurobIndication,
						nurobIndicationText,
						nurobAbdominal,
						nurobPublic,
						nurobAnesdr,
						nurobPremed,
						nurobPeddr, 
						nurobFeed,
						nurobOther
					);
			}

			if (success) {
				message = "Letter updated.";
				updateAction = false;
			} else {
				errorMessage = "Letter update fail.";
			}		
		} else if (deleteAction) {
			// call db delete
			if (NurobAdmltrDB.delete(userBean, nurobAdmltrId)) {
				message = "Letter deleted.";
				deleteAction = false;
				closeAction = true;
			} else {
				errorMessage = "Letter delete fail.";
			}
		}

	} else if (previewAction || exportPdfAction) {
		File reportFile = new File(application.getRealPath("/report/nurob_admltr_report.jasper"));
		if (reportFile.exists()) {
			JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
			
			
			Map<String, Object> parameters = new HashMap<String,  Object>();
			parameters.put("BaseDir", reportFile.getParentFile());
			parameters.put("nurobAdmltrId", new BigDecimal(nurobAdmltrId));

			parameters.put("tf_nurobPatient", nurobPatient);
			parameters.put("tf_nurobAge", nurobAge);
			parameters.put("tf_nurobTelno", nurobTelno);
			parameters.put("tf_nurobBookno", nurobBookno);
			
			parameters.put("rb_nurobStatus", nurobStatus);
			parameters.put("tf_nurobGravida", nurobGravida);
			parameters.put("tf_nurobPara", nurobPara);
			parameters.put("tf_nurobEdc", nurobEdc);
			parameters.put("tf_nurobDr", nurobDr);				
			parameters.put("tf_nurobClinic", nurobClinic);
			parameters.put("tf_nurobAllergy", nurobAllergy);
			parameters.put("cb_nurobCardiac", nurobCardiac);
			parameters.put("cb_nurobDiabetes", nurobDiabetes);
			parameters.put("cb_nurobDm", nurobDm);
			parameters.put("cb_nurobGdm", nurobGdm);
			parameters.put("cb_nurobIgt", nurobIgt);
			parameters.put("cb_nurobAnemia", nurobAnemia);
			parameters.put("cb_nurobRenal", nurobRenal);
			parameters.put("cb_nurobLiver", nurobLiver);
			parameters.put("cb_nurobResp", nurobResp);
			parameters.put("cb_nurobGi", nurobGi);
			parameters.put("cb_nurobEpilepsy", nurobEpilepsy);
			parameters.put("cb_nurobPsychiatric", nurobPsychiatric);
			parameters.put("cb_nurobImmun", nurobImmun);
			parameters.put("cb_nurobThyroid", nurobThyroid);
			parameters.put("cb_nurobSurg", nurobSurg);
			
			parameters.put("cb_nurobMulti", nurobMulti);
			parameters.put("cb_nurobPrevious", nurobPrevious);
			parameters.put("cb_nurobHyper", nurobHyper);

			parameters.put("cb_nurobAph", nurobAph);
			parameters.put("cb_nurobPreterm", nurobPreterm);
			parameters.put("cb_nurobBadob", nurobBadob);
			parameters.put("cb_nurobIugr", nurobIugr);
			parameters.put("cb_nurobFetal", nurobFetal);
			parameters.put("cb_nurobRoutine", nurobRoutine);
			parameters.put("cb_nurobInduct", nurobInduct);
			parameters.put("cb_nurobElective", nurobElective);
			parameters.put("tf_nurobCurrmed", nurobCurrmed);
			parameters.put("rb_nurobRoom", nurobRoom);
			parameters.put("cb_nurobCord", nurobCord);
			
			parameters.put("cb_nurobTriallabor", nurobTriallabor);
			parameters.put("cb_nurobTrialscar", nurobTrialscar);
			parameters.put("cb_nurobFleet", nurobFleet);
			parameters.put("cb_nurobShaving", nurobShaving);
			parameters.put("cb_nurobPain", nurobPain);
			parameters.put("tf_nurobPainPeth", nurobPainPeth);
			parameters.put("cb_nurobNotify", nurobNotify);
			parameters.put("cb_nurobAnytime", nurobAnytime);
			parameters.put("cb_nurobAfter06", nurobAfter06);
			parameters.put("cb_nurobNpo", nurobNpo);
			parameters.put("cb_nurobHep", nurobHep);
			parameters.put("cb_nurobPps", nurobPps);
			parameters.put("cb_nurobPost", nurobPost);
			parameters.put("cb_nurobCs", nurobCs);
			
			parameters.put("cb_nurobCsbtl", nurobCsbtl);
			parameters.put("tf_nurobCsdate", nurobCsdate);
			parameters.put("cb_nurobCsseltime", nurobCsseltime);
			parameters.put("cb_nurobGa", nurobGa);
			parameters.put("cb_nurobSa", nurobSa);
			parameters.put("cb_nurobIndication", nurobIndication);
			parameters.put("tf_nurobIndicationText", nurobIndicationText);
			parameters.put("cb_nurobAbdominal", nurobAbdominal);
			parameters.put("cb_nurobPublic", nurobPublic);
			parameters.put("tf_nurobAnesdr", nurobAnesdr);
			parameters.put("tf_nurobPremed", nurobPremed);
			parameters.put("tf_nurobPeddr", nurobPeddr);
			parameters.put("rb_nurobFeed", nurobFeed);
			parameters.put("tf_nurobOther", nurobOther);

			/*
			if (formParamsMap != null) {
				Set<String> keys = formParamsMap.keySet();
				for (String key : keys)
				{
					parameters.put(key, formParamsMap.get(key));
				}
			}
			*/
			
			JasperPrint jasperPrint =
				JasperFillManager.fillReport(
					jasperReport,
					parameters,
					HKAHInitServlet.getDataSourceIntranet().getConnection()
				);
	
	
			request.getSession().setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE, jasperPrint);
			OutputStream ouputStream = response.getOutputStream();
			response.setHeader("Content-disposition", "attachment; filename=\"TWAH - Admission Letter for Maternity.pdf\"");
			response.setContentType("application/pdf");
			JRPdfExporter exporter = new JRPdfExporter();
	        exporter.setParameter(JRExporterParameter.JASPER_PRINT, jasperPrint);
	        exporter.setParameter(JRExporterParameter.OUTPUT_STREAM, ouputStream);
	        //exporter.setParameter(JRExporterParameter.OUTPUT_WRITER, out);
	        exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI, "../servlets/image?image=");
	
	        exporter.exportReport();
			return;
		}
	}
	
	// load data from database
	if (!createAction && !"1".equals(step)) {
		if (nurobAdmltrId != null && nurobAdmltrId.length() > 0) {
			ArrayList record = NurobAdmltrDB.get(nurobAdmltrId);
			if (record.size() > 0) {
				ReportableListObject row = (ReportableListObject) record.get(0);
				nurobPatient = row.getValue(1);
				nurobAge = row.getValue(2);
				nurobTelno = row.getValue(3);
				nurobBookno = row.getValue(4);

				nurobStatus = row.getValue(5);
				nurobGravida = row.getValue(6);
				nurobPara = row.getValue(7);
				nurobEdc = row.getValue(8);
				nurobDr = row.getValue(9);
				nurobClinic = row.getValue(10);
				nurobAllergy = row.getValue(11);
				nurobCardiac = row.getValue(12);
				nurobDiabetes = row.getValue(13);
				nurobDm = row.getValue(14);
				nurobGdm = row.getValue(15);
				nurobIgt = row.getValue(16);
				nurobAnemia = row.getValue(17);
				nurobRenal = row.getValue(18);
				nurobLiver = row.getValue(19);
				nurobResp = row.getValue(20);
				nurobGi = row.getValue(21);
				nurobEpilepsy = row.getValue(22);
				nurobPsychiatric = row.getValue(23);
				nurobImmun = row.getValue(24);
				nurobThyroid = row.getValue(25);
				nurobSurg = row.getValue(26);

				nurobMulti = row.getValue(27);
				nurobPrevious = row.getValue(28);
				nurobHyper = row.getValue(29);

				nurobAph = row.getValue(30);
				nurobPreterm = row.getValue(31);
				nurobBadob = row.getValue(32);
				nurobIugr = row.getValue(33);
				nurobFetal = row.getValue(34);
				nurobRoutine = row.getValue(35);
				nurobInduct = row.getValue(36);
				nurobElective = row.getValue(37);
				nurobCurrmed = row.getValue(38);
				nurobRoom = row.getValue(39);
				nurobCord = row.getValue(40);

				nurobTriallabor = row.getValue(41);
				nurobTrialscar = row.getValue(42);
				nurobFleet = row.getValue(43);
				nurobShaving = row.getValue(44);
				nurobPain = row.getValue(45);
				nurobPainPeth = row.getValue(46);
				nurobNotify = row.getValue(47);
				nurobAnytime = row.getValue(48);
				nurobAfter06 = row.getValue(49);
				nurobNpo = row.getValue(50);
				nurobHep = row.getValue(51);
				nurobPps = row.getValue(52);
				nurobPost = row.getValue(53);
				nurobCs = row.getValue(54);

				nurobCsbtl = row.getValue(55);
				nurobCsdate = row.getValue(56);
				nurobCsseltime = row.getValue(57);
				nurobGa = row.getValue(58);
				nurobSa = row.getValue(59);
				nurobIndication = row.getValue(60);
				nurobIndicationText = row.getValue(61);
				nurobAbdominal = row.getValue(62);
				nurobPublic = row.getValue(63);
				nurobAnesdr = row.getValue(64);
				nurobPremed = row.getValue(65);
				nurobPeddr = row.getValue(66);
				nurobFeed = row.getValue(67);
				nurobOther = row.getValue(68);
			} else {
				errorMessage = "No record found.";
				closeAction = true;
			}
		} else {
			errorMessage = "No record found.";
			closeAction = true;
		}
	}
} catch (Exception ex) {
	ex.printStackTrace();
}

if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }

%>
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
<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<html:html xhtml="true" lang="true">
<jsp:include page="../common/header.jsp">
	<jsp:param name="nocache" value="N" />
</jsp:include>
<style>
	/*paste this stuff just below it to make it self-clearing */
	.formBlock:after { content: "."; display: block; height: 0; clear: both; visibility: hidden; }
	.formBlock { display: inline-block; _height: 1%; }
	.formBlock { display: block; }
	#reportFormIFrame { height: 800px; width: 100%; } 
</style>
<body>
<DIV id=indexWrapper>
<DIV id=mainFrame>
<DIV id=contentFrame>
<%
	String title = null;
	String commandType = null;
	String mustLogin = "Y";
	if (createAction) {
		commandType = "create";
		// can create by guest
		mustLogin = "N";
	} else if (updateAction) {
		commandType = "update";
	} else if (deleteAction) {
		commandType = "delete";
	} else {
		commandType = "view";
	}
	// set submit label
	title = "function.nurob.admltr." + commandType;
	
	String accessControl = "Y";
	if (ConstantsServerSide.DEBUG) {
		accessControl = "N";
	} 
%>
<jsp:include page="../common/page_title.jsp" flush="false">
	<jsp:param name="pageTitle" value="<%=title %>" />
	<jsp:param name="mustLogin" value="<%=mustLogin %>" />
	<jsp:param name="accessControl" value="<%=accessControl %>" />
	<jsp:param name="keepReferer" value="N" />
</jsp:include>
<!-- Display message -->
<jsp:include page="../common/message.jsp" flush="false">
	<jsp:param name="message" value="<%=message %>" />
	<jsp:param name="errorMessage" value="<%=errorMessage %>" />
</jsp:include>
<form name="form1" action="<html:rewrite page="/nurob/admltrForm.jsp" />" method="post">
<div class="pane">
	<table width="100%" border="0">
		<tr class="smallText">
			<td align="center">
	<%	if (closeAction) { %>
				<button onclick="window.close();" class="btn-click"><bean:message key="button.close" /></button>
	<%	} else if (createAction) { %>
				<button onclick="return submitAction('<%=commandType %>', 1);" class="btn-click"><bean:message key="button.save" /> - <bean:message key="<%=title %>" /></button>
	<%	} else { %>
				<button onclick="return submitAction('update', 1);" class="btn-click"><bean:message key="button.update" /></button>
				<button class="btn-delete" ><bean:message key="button.delete" /></button>
				<button onclick="return submitAction('preview', 0);" class="btn-click">Generate PDF file</button>
	<%	}  %>
			</td>
		</tr>
	</table>
</div>

<input type="hidden" name="command" />
<input type="hidden" name="step" />
<input type="hidden" name="nurobAdmltrId" value="<%=nurobAdmltrId %>" />
<input type="hidden" name="formParams" />
</form>

<%	if (!closeAction) { %>
<iframe id="reportFormIFrame" name="reportFormIFrame" src="nurob_admltr_report.html" onload="initIframeForm();">
	<p>Sorry, system is busy right now. Please contact Information Management Department, 2835 0606 ext. 1606.</p>
</iframe>
<%	} %>

<script language="javascript">
function initIframeForm() {
<%	if (createAction) { %>
	callInitFields();
<%	} else { %>
	callChangeAlert();
<%	} %>
	callSetValue();
}

function submitAction(cmd, stp) {
	if (cmd == 'create' || cmd == 'update' ||cmd == 'preview') {
		var formVar = window.frames.reportFormIFrame.getValues();
		if (formVar) { 
			document.form1.formParams.value = $.param(formVar);
		}
		
		if (stp == 1) {
			
		}
	}
	
	document.form1.command.value = cmd;
	document.form1.step.value = stp;
	document.form1.submit();
}

function callInitFields() {
	window.frames.reportFormIFrame.initFields();
}

function callSetValue() {
	var params = {
		tf_nurobPatient:'<%=emptyWhenNull(nurobPatient) %>',
		tf_nurobAge:'<%=emptyWhenNull(nurobAge) %>',
		
		tf_nurobPatient:'<%=emptyWhenNull(nurobPatient) %>',
		tf_nurobAge:'<%=emptyWhenNull(nurobAge) %>',
		tf_nurobTelno:'<%=emptyWhenNull(nurobTelno) %>',
		tf_nurobBookno:'<%=emptyWhenNull(nurobBookno) %>',
	
		rb_nurobStatus:'<%=emptyWhenNull(nurobStatus) %>',
		tf_nurobGravida:'<%=emptyWhenNull(nurobGravida) %>',
		tf_nurobPara:'<%=emptyWhenNull(nurobPara) %>',
		tf_nurobEdc:'<%=emptyWhenNull(nurobEdc) %>',
		tf_nurobDr:'<%=emptyWhenNull(nurobDr) %>',	
		tf_nurobClinic:'<%=emptyWhenNull(nurobClinic) %>',
		tf_nurobAllergy:'<%=emptyWhenNull(nurobAllergy) %>',
		cb_nurobCardiac:'<%=emptyWhenNull(nurobCardiac) %>',
		cb_nurobDiabetes:'<%=emptyWhenNull(nurobDiabetes) %>',
		cb_nurobDm:'<%=emptyWhenNull(nurobDm) %>',
		cb_nurobGdm:'<%=emptyWhenNull(nurobGdm) %>',
		cb_nurobIgt:'<%=emptyWhenNull(nurobIgt) %>',
		cb_nurobAnemia:'<%=emptyWhenNull(nurobAnemia) %>',
		cb_nurobRenal:'<%=emptyWhenNull(nurobRenal) %>',
		cb_nurobLiver:'<%=emptyWhenNull(nurobLiver) %>',
		cb_nurobResp:'<%=emptyWhenNull(nurobResp) %>',
		cb_nurobGi:'<%=emptyWhenNull(nurobGi) %>',
		cb_nurobEpilepsy:'<%=emptyWhenNull(nurobEpilepsy) %>',
		cb_nurobPsychiatric:'<%=emptyWhenNull(nurobPsychiatric) %>',
		cb_nurobImmun:'<%=emptyWhenNull(nurobImmun) %>',
		cb_nurobThyroid:'<%=emptyWhenNull(nurobThyroid) %>',
		cb_nurobSurg:'<%=emptyWhenNull(nurobSurg) %>',
	
		cb_nurobMulti:'<%=emptyWhenNull(nurobMulti) %>',
		cb_nurobPrevious:'<%=emptyWhenNull(nurobPrevious) %>',
		cb_nurobHyper:'<%=emptyWhenNull(nurobHyper) %>',

		cb_nurobAph:'<%=emptyWhenNull(nurobAph) %>',
		cb_nurobPreterm:'<%=emptyWhenNull(nurobPreterm) %>',
		cb_nurobBadob:'<%=emptyWhenNull(nurobBadob) %>',
		cb_nurobIugr:'<%=emptyWhenNull(nurobIugr) %>',
		cb_nurobFetal:'<%=emptyWhenNull(nurobFetal) %>',
		cb_nurobRoutine:'<%=emptyWhenNull(nurobRoutine) %>',
		cb_nurobInduct:'<%=emptyWhenNull(nurobInduct) %>',
		cb_nurobElective:'<%=emptyWhenNull(nurobElective) %>',
		tf_nurobCurrmed:'<%=emptyWhenNull(nurobCurrmed) %>',
		rb_nurobRoom:'<%=emptyWhenNull(nurobRoom) %>',
		cb_nurobCord:'<%=emptyWhenNull(nurobCord) %>',
	
		cb_nurobTriallabor:'<%=emptyWhenNull(nurobTriallabor) %>',
		cb_nurobTrialscar:'<%=emptyWhenNull(nurobTrialscar) %>',
		cb_nurobFleet:'<%=emptyWhenNull(nurobFleet) %>',
		cb_nurobShaving:'<%=emptyWhenNull(nurobShaving) %>',
		cb_nurobPain:'<%=emptyWhenNull(nurobPain) %>',
		tf_nurobPainPeth:'<%=emptyWhenNull(nurobPainPeth) %>',
		cb_nurobNotify:'<%=emptyWhenNull(nurobNotify) %>',
		cb_nurobAnytime:'<%=emptyWhenNull(nurobAnytime) %>',
		cb_nurobAfter06:'<%=emptyWhenNull(nurobAfter06) %>',
		cb_nurobNpo:'<%=emptyWhenNull(nurobNpo) %>',
		cb_nurobHep:'<%=emptyWhenNull(nurobHep) %>',
		cb_nurobPps:'<%=emptyWhenNull(nurobPps) %>',
		cb_nurobPost:'<%=emptyWhenNull(nurobPost) %>',
		cb_nurobCs:'<%=emptyWhenNull(nurobCs) %>',
	
		cb_nurobCsbtl:'<%=emptyWhenNull(nurobCsbtl) %>',
		tf_nurobCsdate:'<%=emptyWhenNull(nurobCsdate) %>',
		cb_nurobCsseltime:'<%=emptyWhenNull(nurobCsseltime) %>',
		cb_nurobGa:'<%=emptyWhenNull(nurobGa) %>',
		cb_nurobSa:'<%=emptyWhenNull(nurobSa) %>',
		cb_nurobIndication:'<%=emptyWhenNull(nurobIndication) %>',
		tf_nurobIndicationText:'<%=emptyWhenNull(nurobIndicationText) %>',
		cb_nurobAbdominal:'<%=emptyWhenNull(nurobAbdominal) %>',
		cb_nurobPublic:'<%=emptyWhenNull(nurobPublic) %>',
		tf_nurobAnesdr:'<%=emptyWhenNull(nurobAnesdr) %>',
		tf_nurobPremed:'<%=emptyWhenNull(nurobPremed) %>',
		tf_nurobPeddr:'<%=emptyWhenNull(nurobPeddr) %>',
		rb_nurobFeed:'<%=emptyWhenNull(nurobFeed) %>',
		tf_nurobOther:'<%=emptyWhenNull(nurobOther) %>'
	};
	window.frames.reportFormIFrame.setValues(params);
}

function callChangeAlert() {
	window.frames.reportFormIFrame.addChangeAlertEvent();
}

</script>

</DIV>
</DIV>
</DIV>

<jsp:include page="../common/footer.jsp" flush="false" />
</body>
</html:html>
