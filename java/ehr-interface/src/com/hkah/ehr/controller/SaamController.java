package com.hkah.ehr.controller;

import hk.gov.ehr.alert.ws.beans.LocalEMRDownloadResponseBean;
import hk.gov.ehr.hepr.ws.Response;

import java.util.ArrayList;
import java.util.List;

import org.apache.log4j.Logger;
import org.springframework.context.ApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import test.client.AlertWebServiceClient;

import com.hkah.ehr.common.FactoryBase;
import com.hkah.ehr.model.DownloadPatientAdrAndAllergyForm;
import com.hkah.ehr.model.Participant;
import com.hkah.ehr.model.Patient;
import com.hkah.ehr.model.Reg;
import com.hkah.ehr.model.StructuredAlertForm;
import com.hkah.ehr.model.UploadBlankForm;
import com.hkah.ehr.service.BirthRecordService;
import com.hkah.ehr.service.DomainCommonService;
import com.hkah.ehr.service.EncounterService;
import com.hkah.ehr.service.LabService;
import com.hkah.ehr.service.RisService;
import com.hkah.ehr.service.RxdService;
import com.hkah.ehr.service.SaamService;
import com.hkah.util.DateTimeUtil;

@Controller
public class SaamController {
	protected static Logger logger = Logger.getLogger(SaamController.class);
	

	@RequestMapping(value = "openStructuredAlert", method = RequestMethod.GET)
	public String openStructuredAlert (
			@ModelAttribute("structuredAlertForm") StructuredAlertForm structuredAlertForm,
			BindingResult bresult, ModelMap model) {
	/*
	old

	Call from CIS:
	http://160.100.3.22/AdaptationFrame/html/AdaptationFrame.jsp?
	sex=F&engSurName=WONG&engGivenName=SIU%20CHUN%20JENNY&mrnPatientIdentity=499405&dob=23-Dec-1976&
	doctype=ID&docnum=K6155448&userRight=A&login=admin&loginName=Administrator&
	userRank=720&userRankDesc=720&hospitalCode=AH&systemLogin=ALERT_ALLERGY&sourceSystem=CIS
	*/
	
	/*
	Call from CMS-IP:
	Key	Value
	Request	GET /HKAHCMS/ha/postHaStruAlertMod.jsp?
	
	host=160.100.2.73&port=80&login=admin&loginId=admin&loginName=Administrator&userRank=A&userRankDesc=null&
	userRight=A&actionCode=summary&loginId=admin&doctype=&docnum=&hkid=WB0000947&ehrno=475144182220&
	patNo=511963&engSurName=DUMMY&engGivenName=PATIENT%20ONE&chiName=&dob=08-May-1988&age=28%20yr%2011%20mth&
	sex=M 
	
	HTTP/1.1
	*/
		ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
		DomainCommonService domainCommonService = (DomainCommonService) context.getBean("domainCommonService");

		// major ids
		String mrnPatientIdentity = structuredAlertForm.getMrnPatientIdentity();
		String patientEhrNo = structuredAlertForm.getEhrno();
		String patno = structuredAlertForm.getPatno();
		String regid = structuredAlertForm.getRegid();
		String showRegInfo = structuredAlertForm.getShowRegInfo();
		Reg r = null;
		
		logger.info("request: mrnPatientIdentity="+mrnPatientIdentity+", patno="+patno+", patientEhrNo="+patientEhrNo+", regid="+regid+", showRegInfo="+showRegInfo);
		
		if (regid != null) {
			patno = domainCommonService.getPatNoByRegID(regid);
			if ("Y".equalsIgnoreCase(showRegInfo)) {
				r = domainCommonService.getReg(regid);
			}
		}
		if (mrnPatientIdentity == null) {
			mrnPatientIdentity =  patno;
		}
		
		String doctype = null;
		String docnum = null;
		String hkid = null;
		String engSurName = null;
		String engGivenName = null;
		String chiName = null;
		String sex = null;
		String dob = null;
		String age = null;
		
		Participant pEhr = null;
		boolean getEhrInfoByEhrno = false;
		if (patientEhrNo != null) {
			pEhr = domainCommonService.getEhrHl7ParticipantByEhrNo(patientEhrNo);
			getEhrInfoByEhrno = true;
		} else {
			pEhr = domainCommonService.getEhrHl7ParticipantByPatNo(mrnPatientIdentity);
			getEhrInfoByEhrno = false;
		}
		
		if (pEhr == null || pEhr.getEhrNo() == null) {
			// use HATS patient info
			Patient pHATS = domainCommonService.getHATSPatient(patno);
			if (pHATS != null && pHATS.getPatno() != null) {
				hkid = pHATS.getPatidno();
				engSurName = pHATS.getPatfname();
				engGivenName = pHATS.getPatgname();
				chiName = pHATS.getPatcname();
				sex = pHATS.getPatsex();
				dob = DateTimeUtil.formatEhrDobEdmy(pHATS.getPatbdate());
				age = pHATS.getAge();
				
				logger.info("Get HATS patient info by patno="+patno);
			} else {
				logger.info("Patient info not found");
			}
		} else {
			// use eHR patient info
			patientEhrNo = pEhr.getEhrNo();
			mrnPatientIdentity = pEhr.getPatientKey();
			patno = pEhr.getPatientKey();
			
			doctype = pEhr.getDocType();
			docnum = pEhr.getDocNo();
			hkid = pEhr.getHkid();
			engSurName = pEhr.getPersonEngSurname();
			engGivenName = pEhr.getPersonEngGivenName();
			sex = pEhr.getSex();
			dob = pEhr.getBirthDate();
			age = pEhr.getAge();
			
			logger.info("Get eHR patient info by " + (getEhrInfoByEhrno ? "ehrno=" + patientEhrNo : "patno=" + patno));
		}
		
		String admD = null;
		String disD = null;
		String attdoc = null;
		String condoc = null;
		String spec = null;
		String classNum = null;
		String ward = null;
		String bed = null;
		String details = null;
		if (r != null) {
			admD = DateTimeUtil.formatEhrDobEdmy(r.getRegdate());
			disD = DateTimeUtil.formatEhrDobEdmy(r.getInpddate());
			//attdoc = null;
			//condoc = null;
			//spec = null;
			classNum = r.getAcmname();
			ward = r.getWrdname();
			bed = r.getBedcode();
		} else {
			admD = structuredAlertForm.getAdmD();
			disD = structuredAlertForm.getDisD();
			attdoc = structuredAlertForm.getAttdoc();
			condoc = structuredAlertForm.getCondoc();
			spec = structuredAlertForm.getSpec();
			classNum = structuredAlertForm.getClassNum();
			ward = structuredAlertForm.getWard();
			bed = structuredAlertForm.getBed();
			details = structuredAlertForm.getDetails();
		}
		
		// allow user to view the eHR record details in Read only mode if userRight is General (cannot edit)
		String actionCode = structuredAlertForm.getActionCode();
		String userRight = structuredAlertForm.getUserRight();
		if ("G".equals(userRight)) {
			actionCode = "update";
		}
		
		model.addAttribute("url", FactoryBase.getInstance().getSysparamValue("EHRSAAMLNK"));
		model.addAttribute("systemLogin", FactoryBase.getInstance().getSysparamValue("saam.systemLogin"));
		model.addAttribute("sourceSystem", structuredAlertForm.getSourceSystem());
		
		model.addAttribute("login", structuredAlertForm.getLogin());
		model.addAttribute("loginName", structuredAlertForm.getLoginName());
		model.addAttribute("userRank", structuredAlertForm.getUserRank());
		model.addAttribute("userRankDesc", structuredAlertForm.getUserRankDesc());
		model.addAttribute("userRight", userRight);
		model.addAttribute("hospitalCode", FactoryBase.getInstance().getSysparamValue("app.hospitalCode"));
		model.addAttribute("hospitalName", FactoryBase.getInstance().getSysparamValue("app.hospitalName"));
		model.addAttribute("actionCode", actionCode);
		
		model.addAttribute("mrnDisplayLabelP", FactoryBase.getInstance().getSysparamValue("saam.mrnDisplayLabelP"));
		model.addAttribute("mrnDisplayLabelE", FactoryBase.getInstance().getSysparamValue("saam.mrnDisplayLabelE"));
		model.addAttribute("mrnDisplayType", FactoryBase.getInstance().getSysparamValue("saam.mrnDisplayType"));
		
		model.addAttribute("mrnPatientEncounterNo", structuredAlertForm.getMrnPatientEncounterNo());
		model.addAttribute("mrnPatientIdentity", mrnPatientIdentity);	// =patno
		model.addAttribute("patientEhrNo", patientEhrNo);
		model.addAttribute("doctype", doctype);
		model.addAttribute("docnum", docnum);
		model.addAttribute("hkid", hkid);
		model.addAttribute("engSurName", engSurName);
		model.addAttribute("engGivenName", engGivenName);
		model.addAttribute("chiName", chiName);
		model.addAttribute("sex", sex);
		model.addAttribute("dob", dob);
		model.addAttribute("age", age);

		model.addAttribute("admD", admD);
		model.addAttribute("disD", disD);
		model.addAttribute("attdoc", attdoc);
		model.addAttribute("condoc", condoc);
		model.addAttribute("spec", spec);
		model.addAttribute("classNum", classNum);
		model.addAttribute("ward", ward);
		model.addAttribute("bed", bed);
		model.addAttribute("details", details);
		
		return "structuredAlert";
	}		
	
	@RequestMapping(value = "downloadPatientAdrAndAllergy", method = RequestMethod.POST)
	public String downloadPatientAdrAndAllergy(
			@ModelAttribute("downloadPatientAdrAndAllergyForm") DownloadPatientAdrAndAllergyForm downloadPatientAdrAndAllergyForm,
			BindingResult bresult, ModelMap model) {
		ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
		AlertWebServiceClient alertWebServiceClient = (AlertWebServiceClient) context.getBean("alertWebServiceClient");

		String ehrNo = null;
		String patNo = null;
		String userID = null;
		String moduleCode = null;
		String responseCode = null;
		String responseMessage = null;
		
		try {
			ehrNo = downloadPatientAdrAndAllergyForm.getEhrNo();
			patNo = downloadPatientAdrAndAllergyForm.getPatNo();
			userID = downloadPatientAdrAndAllergyForm.getUserID();
			moduleCode = downloadPatientAdrAndAllergyForm.getModuleCode();
			
			logger.info("[downloadPatientAdrAndAllergy] Download allergy and ADR [patNo=" + patNo + ", userID=" + userID + ", moduleCode=" + moduleCode + "] Start");
			
			if (patNo == null) {
				responseCode = "AH_ERR_NO_PATNO";
				responseMessage = "No patient no.";
			} else if (userID == null) {
				responseCode = "AH_ERR_NO_USERID";
				responseMessage = "No user ID: " + userID + ".";
			} else {
				LocalEMRDownloadResponseBean res = alertWebServiceClient.downloadAdrAllergy(patNo, userID);
				responseCode = res.getResponseCode();
				responseMessage = res.getResponseMessage();
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			
			responseCode = "AH_ERR_EHRALERT";
			responseMessage = e.getMessage();
		}
		
		logger.info("[downloadPatientAdrAndAllergy] Download allergy and ADR [patNo=" + patNo + ", userID=" + userID + ", moduleCode=" + moduleCode + "] End, Response[" + responseCode + " - " + responseMessage + "]");
		
		model.addAttribute("responseCode", responseCode);
		model.addAttribute("responseMessage", responseMessage);
      
		return "response";
	}
	
	@RequestMapping(value = "uploadBlankAdr", method = RequestMethod.POST)
	public String uploadBlankAdr(
			@ModelAttribute("uploadBlankForm") UploadBlankForm uploadBlankForm,
			BindingResult bresult, ModelMap model) {
		ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
		SaamService saamService = (SaamService) context.getBean("saamService");
		
		String ehrNo = null;
		String patNo = null;
		String userID = null;
		String uploadMode = null;
		String responseCode = null;
		String responseMessage = null;
		List<String> patnos = new ArrayList<String>();
		
		try {
			ehrNo = uploadBlankForm.getEhrNo();
			patNo = uploadBlankForm.getPatNo();
			userID = uploadBlankForm.getUserID();
			uploadMode = uploadBlankForm.getUploadMode();
			
			logger.info("[patNo=" + patNo + ", userID=" + userID + "] Start");

			if (patNo == null) {
				responseCode = "AH_ERR_NO_PATNO";
				responseMessage = "No patient no.";
			} else if (userID == null) {
				responseCode = "AH_ERR_NO_USERID";
				responseMessage = "No user ID: " + userID + ".";
			} else {
				patnos.add(patNo);
				Response res = saamService.uploadBlankAdr(patnos);
				if (res != null) {
					responseCode = res.getResponseCode();
					responseMessage = res.getResponseMessage();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			
			responseCode = "AH_ERR_EHRALERT";
			responseMessage = e.getMessage();
		}
		
		logger.info("upload blank [patNo=" + patNo + ", userID=" + userID + "] End, Response[" + responseCode + " - " + responseMessage + "]");
		
		model.addAttribute("responseCode", responseCode);
		model.addAttribute("responseMessage", responseMessage);
      
		return "response";
	}
	
	@RequestMapping(value = "uploadBlankAllergy", method = RequestMethod.POST)
	public String uploadBlankAllergy(
			@ModelAttribute("uploadBlankForm") UploadBlankForm uploadBlankForm,
			BindingResult bresult, ModelMap model) {
		ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
		SaamService saamService = (SaamService) context.getBean("saamService");
		
		String ehrNo = null;
		String patNo = null;
		String userID = null;
		String uploadMode = null;
		String responseCode = null;
		String responseMessage = null;
		List<String> patnos = new ArrayList<String>();
		
		try {
			ehrNo = uploadBlankForm.getEhrNo();
			patNo = uploadBlankForm.getPatNo();
			userID = uploadBlankForm.getUserID();
			uploadMode = uploadBlankForm.getUploadMode();
			
			logger.info("[patNo=" + patNo + ", userID=" + userID + "] Start");

			if (patNo == null) {
				responseCode = "AH_ERR_NO_PATNO";
				responseMessage = "No patient no.";
			} else if (userID == null) {
				responseCode = "AH_ERR_NO_USERID";
				responseMessage = "No user ID: " + userID + ".";
			} else {
				patnos.add(patNo);
				Response res = saamService.uploadBlankAllergy(patnos);
				if (res != null) {
					responseCode = res.getResponseCode();
					responseMessage = res.getResponseMessage();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			
			responseCode = "AH_ERR_EHRALERT";
			responseMessage = e.getMessage();
		}
		
		logger.info("upload blank [patNo=" + patNo + ", userID=" + userID + "] End, Response[" + responseCode + " - " + responseMessage + "]");
		
		model.addAttribute("responseCode", responseCode);
		model.addAttribute("responseMessage", responseMessage);
      
		return "response";
	}
	
	@RequestMapping(value = "uploadBlankBirth", method = RequestMethod.POST)
	public String uploadBlankBirth(
			@ModelAttribute("uploadBlankForm") UploadBlankForm uploadBlankForm,
			BindingResult bresult, ModelMap model) {
		ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
		BirthRecordService birthRecordService = (BirthRecordService) context.getBean("birthRecordService");
		
		String ehrNo = null;
		String patNo = null;
		String userID = null;
		String uploadMode = null;
		String responseCode = null;
		String responseMessage = null;
		List<String> patnos = new ArrayList<String>();
		
		try {
			ehrNo = uploadBlankForm.getEhrNo();
			patNo = uploadBlankForm.getPatNo();
			userID = uploadBlankForm.getUserID();
			uploadMode = uploadBlankForm.getUploadMode();
			
			logger.info("[patNo=" + patNo + ", userID=" + userID + "] Start");

			if (patNo == null) {
				responseCode = "AH_ERR_NO_PATNO";
				responseMessage = "No patient no.";
			} else if (userID == null) {
				responseCode = "AH_ERR_NO_USERID";
				responseMessage = "No user ID: " + userID + ".";
			} else {
				patnos.add(patNo);
				Response res = birthRecordService.uploadBlankBirthRecord(patnos);
				if (res != null) {
					responseCode = res.getResponseCode();
					responseMessage = res.getResponseMessage();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			
			responseCode = "AH_ERR_EHRALERT";
			responseMessage = e.getMessage();
		}
		
		logger.info("upload blank [patNo=" + patNo + ", userID=" + userID + "] End, Response[" + responseCode + " - " + responseMessage + "]");
		
		model.addAttribute("responseCode", responseCode);
		model.addAttribute("responseMessage", responseMessage);
      
		return "response";
	}
	
	@RequestMapping(value = "uploadBlankEncounter", method = RequestMethod.POST)
	public String uploadBlankEncounter(
			@ModelAttribute("uploadBlankForm") UploadBlankForm uploadBlankForm,
			BindingResult bresult, ModelMap model) {
		ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
		EncounterService encounterService = (EncounterService) context.getBean("encounterService");
		
		String ehrNo = null;
		String patNo = null;
		String userID = null;
		String uploadMode = null;
		String responseCode = null;
		String responseMessage = null;
		List<String> patnos = new ArrayList<String>();
		
		try {
			ehrNo = uploadBlankForm.getEhrNo();
			patNo = uploadBlankForm.getPatNo();
			userID = uploadBlankForm.getUserID();
			uploadMode = uploadBlankForm.getUploadMode();
			
			logger.info("[patNo=" + patNo + ", userID=" + userID + "] Start");

			if (patNo == null) {
				responseCode = "AH_ERR_NO_PATNO";
				responseMessage = "No patient no.";
			} else if (userID == null) {
				responseCode = "AH_ERR_NO_USERID";
				responseMessage = "No user ID: " + userID + ".";
			} else {
				patnos.add(patNo);
				Response res = encounterService.uploadBlank(patnos);
				if (res != null) {
					responseCode = res.getResponseCode();
					responseMessage = res.getResponseMessage();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			
			responseCode = "AH_ERR_EHRALERT";
			responseMessage = e.getMessage();
		}
		
		logger.info("upload blank [patNo=" + patNo + ", userID=" + userID + "] End, Response[" + responseCode + " - " + responseMessage + "]");
		
		model.addAttribute("responseCode", responseCode);
		model.addAttribute("responseMessage", responseMessage);
      
		return "response";
	}
	
	@RequestMapping(value = "uploadBlankRad", method = RequestMethod.POST)
	public String uploadBlankRad(
			@ModelAttribute("uploadBlankForm") UploadBlankForm uploadBlankForm,
			BindingResult bresult, ModelMap model) {
		ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
		RisService risService = (RisService) context.getBean("risService");
		
		String ehrNo = null;
		String patNo = null;
		String userID = null;
		String uploadMode = null;
		String responseCode = null;
		String responseMessage = null;
		List<String> patnos = new ArrayList<String>();
		
		try {
			ehrNo = uploadBlankForm.getEhrNo();
			patNo = uploadBlankForm.getPatNo();
			userID = uploadBlankForm.getUserID();
			uploadMode = uploadBlankForm.getUploadMode();
			
			logger.info("[patNo=" + patNo + ", userID=" + userID + "] Start");

			if (patNo == null) {
				responseCode = "AH_ERR_NO_PATNO";
				responseMessage = "No patient no.";
			} else if (userID == null) {
				responseCode = "AH_ERR_NO_USERID";
				responseMessage = "No user ID: " + userID + ".";
			} else {
				patnos.add(patNo);
				Response res = risService.uploadBlank(patnos);
				if (res != null) {
					responseCode = res.getResponseCode();
					responseMessage = res.getResponseMessage();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			
			responseCode = "AH_ERR_EHRALERT";
			responseMessage = e.getMessage();
		}
		
		logger.info("upload blank [patNo=" + patNo + ", userID=" + userID + "] End, Response[" + responseCode + " - " + responseMessage + "]");
		
		model.addAttribute("responseCode", responseCode);
		model.addAttribute("responseMessage", responseMessage);
      
		return "response";
	}
	
	@RequestMapping(value = "uploadBlankRxd", method = RequestMethod.POST)
	public String uploadBlankRxd(
			@ModelAttribute("uploadBlankForm") UploadBlankForm uploadBlankForm,
			BindingResult bresult, ModelMap model) {
		ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
		RxdService rxdService = (RxdService) context.getBean("rxdService");
		
		String ehrNo = null;
		String patNo = null;
		String userID = null;
		String uploadMode = null;
		String responseCode = null;
		String responseMessage = null;
		List<String> patnos = new ArrayList<String>();
		
		try {
			ehrNo = uploadBlankForm.getEhrNo();
			patNo = uploadBlankForm.getPatNo();
			userID = uploadBlankForm.getUserID();
			uploadMode = uploadBlankForm.getUploadMode();
			
			logger.info("[patNo=" + patNo + ", userID=" + userID + "] Start");

			if (patNo == null) {
				responseCode = "AH_ERR_NO_PATNO";
				responseMessage = "No patient no.";
			} else if (userID == null) {
				responseCode = "AH_ERR_NO_USERID";
				responseMessage = "No user ID: " + userID + ".";
			} else {
				patnos.add(patNo);
				Response res = rxdService.uploadBlank(patnos);
				if (res != null) {
					responseCode = res.getResponseCode();
					responseMessage = res.getResponseMessage();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			
			responseCode = "AH_ERR_EHRALERT";
			responseMessage = e.getMessage();
		}
		
		logger.info("upload blank [patNo=" + patNo + ", userID=" + userID + "] End, Response[" + responseCode + " - " + responseMessage + "]");
		
		model.addAttribute("responseCode", responseCode);
		model.addAttribute("responseMessage", responseMessage);
      
		return "response";
	}
	
	@RequestMapping(value = "uploadBlankLabGen", method = RequestMethod.POST)
	public String uploadBlankLabGen(
			@ModelAttribute("uploadBlankForm") UploadBlankForm uploadBlankForm,
			BindingResult bresult, ModelMap model) {
		ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
		LabService labService = (LabService) context.getBean("labService");
		
		String ehrNo = null;
		String patNo = null;
		String userID = null;
		String uploadMode = null;
		String responseCode = null;
		String responseMessage = null;
		List<String> patnos = new ArrayList<String>();
		
		try {
			ehrNo = uploadBlankForm.getEhrNo();
			patNo = uploadBlankForm.getPatNo();
			userID = uploadBlankForm.getUserID();
			uploadMode = uploadBlankForm.getUploadMode();
			
			logger.info("[patNo=" + patNo + ", userID=" + userID + "] Start");

			if (patNo == null) {
				responseCode = "AH_ERR_NO_PATNO";
				responseMessage = "No patient no.";
			} else if (userID == null) {
				responseCode = "AH_ERR_NO_USERID";
				responseMessage = "No user ID: " + userID + ".";
			} else {
				patnos.add(patNo);
				Response res = labService.uploadBlankLabGen(patnos);
				if (res != null) {
					responseCode = res.getResponseCode();
					responseMessage = res.getResponseMessage();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			
			responseCode = "AH_ERR_EHRALERT";
			responseMessage = e.getMessage();
		}
		
		logger.info("upload blank [patNo=" + patNo + ", userID=" + userID + "] End, Response[" + responseCode + " - " + responseMessage + "]");
		
		model.addAttribute("responseCode", responseCode);
		model.addAttribute("responseMessage", responseMessage);
      
		return "response";
	}
	
	@RequestMapping(value = "uploadBlankLabAP", method = RequestMethod.POST)
	public String uploadBlankLabAP(
			@ModelAttribute("uploadBlankForm") UploadBlankForm uploadBlankForm,
			BindingResult bresult, ModelMap model) {
		ApplicationContext context = new ClassPathXmlApplicationContext("ClientContext.xml");
		LabService labService = (LabService) context.getBean("labService");
		
		String ehrNo = null;
		String patNo = null;
		String userID = null;
		String uploadMode = null;
		String responseCode = null;
		String responseMessage = null;
		List<String> patnos = new ArrayList<String>();
		
		try {
			ehrNo = uploadBlankForm.getEhrNo();
			patNo = uploadBlankForm.getPatNo();
			userID = uploadBlankForm.getUserID();
			uploadMode = uploadBlankForm.getUploadMode();
			
			logger.info("[patNo=" + patNo + ", userID=" + userID + "] Start");

			if (patNo == null) {
				responseCode = "AH_ERR_NO_PATNO";
				responseMessage = "No patient no.";
			} else if (userID == null) {
				responseCode = "AH_ERR_NO_USERID";
				responseMessage = "No user ID: " + userID + ".";
			} else {
				patnos.add(patNo);
				Response res = labService.uploadBlankLabAP(patnos);
				if (res != null) {
					responseCode = res.getResponseCode();
					responseMessage = res.getResponseMessage();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			logger.error(e.getMessage());
			
			responseCode = "AH_ERR_EHRALERT";
			responseMessage = e.getMessage();
		}
		
		logger.info("upload blank [patNo=" + patNo + ", userID=" + userID + "] End, Response[" + responseCode + " - " + responseMessage + "]");
		
		model.addAttribute("responseCode", responseCode);
		model.addAttribute("responseMessage", responseMessage);
      
		return "response";
	}
}
