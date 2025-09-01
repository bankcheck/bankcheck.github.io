package com.hkah.web.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.hkah.config.MessageResources;
import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.DateTimeUtil;
import com.hkah.util.FileUtil;
import com.hkah.util.ParserUtil;
import com.hkah.util.upload.HttpFileUpload;
import com.hkah.web.common.UserBean;
import com.hkah.web.db.DocumentDB;
import com.hkah.web.db.HAACheckListDB2;
import com.hkah.web.db.hibernate.HaaChecklist;
import com.hkah.web.db.hibernate.HaaChecklistDate;
import com.hkah.web.db.hibernate.HaaChecklistId;
import com.hkah.web.struts.Select;

public class HealthAssessmentController extends AbstractController  {

    protected final Log logger = LogFactory.getLog(getClass());
    
    private String requestName;
    private static String siteCode = ConstantsServerSide.SITE_CODE;
    
    public ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	siteCode = ConstantsServerSide.SITE_CODE;
    	
    	if ("check_list".equals(getRequestName()) ) {
    		return getCheckList(request, response);
    	} else if ("checkitem".equals(getRequestName()) ) {
    		return getCheckitem(request, response);
    	} else {
    		return null;
    	}
    }
    
    private ModelAndView getCheckList(HttpServletRequest request, HttpServletResponse response) {
    	System.out.println("======= getCheckList() ===========");
    	HttpSession session = request.getSession();
    	
    	UserBean userBean = new UserBean(request);

    	String command = request.getParameter("command");
    	String haaID = request.getParameter("HaaID");
    	String enabled = request.getParameter("enabled");

    	String message = request.getParameter("message");
    	String errorMessage = request.getParameter("errorMessage");

    	boolean archiveAction = false;
    	HaaChecklist haaChecklist = null;
    	
    	if ("archive".equals(command)) {
    		archiveAction = true;
    	}

    	try {
    		if (archiveAction) {
    			// archive ha
				int haaIDValue;
				try {
					haaIDValue = Integer.parseInt(haaID);
				} catch (NumberFormatException nfe) {
					haaIDValue = -1;
				}
    			haaChecklist = HAACheckListDB2.get(new HaaChecklistId(siteCode, haaIDValue));
    			
    			if (HAACheckListDB2.archive(userBean, haaChecklist)) {
    				message = "Corporation archived.";
    				archiveAction = false;
    			} else {
    				errorMessage = "Corporation archive fail.";
    			}
    		}
    	} catch (Exception e) {
    		e.printStackTrace();
    	}

    	if (enabled == null) {
    		enabled = ConstantsVariable.ONE_VALUE;
    	}

    	// clear all expired file
    	HAACheckListDB2.expiredContract(userBean);
    	
    	HashMap<String, String> haaBusinessTypeHashSet = new HashMap<String, String>();
    	haaBusinessTypeHashSet.put("NB", MessageResources.getMessage(session, "label.newBusiness"));
    	haaBusinessTypeHashSet.put("RB", MessageResources.getMessage(session, "label.renewalBusiness"));
    	haaBusinessTypeHashSet.put("PM", MessageResources.getMessage(session, "label.promotion"));

    	if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
    	if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
    	
    	Map<String, Object> model = new HashMap<String, Object>();
    	model.put("message", message);
    	model.put("errorMessage", errorMessage);
    	model.put("userBean", userBean);
    	model.put("table", HAACheckListDB2.getList(userBean, enabled));
    	model.put("haaBusinessTypeHashSet", haaBusinessTypeHashSet);
    	model.put("enabled", enabled);
    	model.put("isAdmin", userBean.isAdmin());
    	model.put("pageSize", userBean.getNoOfRecPerPage());
    	
    	return new ModelAndView("healthAssessment/check_list3", "healthAssessment", model);
    }
    
    public ModelAndView getCheckitem(HttpServletRequest request, HttpServletResponse response) {
    	boolean fileUpload = false;
    	if (HttpFileUpload.isMultipartContent(request)){
    		HttpFileUpload.toUploadFolder(
    			request,
    			ConstantsServerSide.DOCUMENT_FOLDER,
    			ConstantsServerSide.TEMP_FOLDER,
    			ConstantsServerSide.UPLOAD_FOLDER
    		);
    		fileUpload = true;
    	}

    	UserBean userBean = new UserBean(request);

    	String command = ParserUtil.getParameter(request, "command");
    	String step = ParserUtil.getParameter(request, "step");

    	String haaID = ParserUtil.getParameter(request, "HaaID");
    	String seq = ParserUtil.getParameter(request, "seq");
    	String corporationName = ParserUtil.getParameter(request, "corporationName");
    	String businessType = ParserUtil.getParameter(request, "businessType");
    	String contractDateFrom = ParserUtil.getParameter(request, "contractDateFrom");
    	Date contractDateFromDate = null;
    	if (contractDateFrom != null) {
    		contractDateFromDate = DateTimeUtil.parseDate(contractDateFrom);
    	}
    	String contractDateTo = ParserUtil.getParameter(request, "contractDateTo");
    	Date contractDateToDate = null;
    	if (contractDateTo != null) {
    		contractDateToDate = DateTimeUtil.parseDate(contractDateTo);
    	}
    	String enabled = ParserUtil.getParameter(request, "enabled");

    	String initDate = ParserUtil.getParameter(request, "initDate");
    	String completeDate = ParserUtil.getParameter(request, "completeDate");

    	String message = ParserUtil.getParameter(request, "message");
    	String errorMessage = ParserUtil.getParameter(request, "errorMessage");

    	HaaChecklist haaChecklist = null;
    	List<HaaChecklistDate> progressList = null;
    	if (fileUpload) {
    		// create new record
    		if ("create".equals(command) && "1".equals(step)) {
    			// get project id with dummy data
    			haaChecklist = HAACheckListDB2.add(userBean);
    			haaID = String.valueOf(haaChecklist.getId().getHaaChecklistId());
    		}

    		String[] fileList = (String[]) request.getAttribute("filelist");
    		if (fileList != null) {
    			StringBuffer tempStrBuffer = new StringBuffer();

    			tempStrBuffer.append(ConstantsServerSide.UPLOAD_WEB_FOLDER);
    			tempStrBuffer.append(File.separator);
    			tempStrBuffer.append("Health Assessment");
    			tempStrBuffer.append(File.separator);
    			tempStrBuffer.append(haaID);
    			tempStrBuffer.append(File.separator);
    			String baseUrl = tempStrBuffer.toString();

    			tempStrBuffer.setLength(0);
    			tempStrBuffer.append(File.separator);
    			tempStrBuffer.append("upload");
    			tempStrBuffer.append(File.separator);
    			tempStrBuffer.append("Health Assessment");
    			tempStrBuffer.append(File.separator);
    			tempStrBuffer.append(haaID);
    			String webUrl = tempStrBuffer.toString();

    			for (int i = 0; i < fileList.length; i++) {
    				FileUtil.moveFile(
    					ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
    					baseUrl + fileList[i]
    				);
    				DocumentDB.add(userBean, "haa", haaID, webUrl, fileList[i]);
    			}
    		}
    	}

    	boolean createAction = false;
    	boolean updateAction = false;
    	boolean updateDateAction = false;
    	boolean deleteAction = false;
    	boolean closeAction = false;

    	if ("create".equals(command)) {
    		createAction = true;
    	} else if ("update".equals(command)) {
    		updateAction = true;
    	} else if ("delete".equals(command)) {
    		deleteAction = true;
    	} else if ("updateDate".equals(command)) {
    		updateDateAction = true;
    	}

    	try {
    		if ("1".equals(step)) {
    			if (createAction) {
    				// initial create id
    				if (haaID == null) {
    	    			haaChecklist = HAACheckListDB2.add(userBean);
    	    			haaID = String.valueOf(haaChecklist.getId().getHaaChecklistId());
    				}

    				// call db insert corporation name, business type
    				int haaIDValue;
    				try {
    					haaIDValue = Integer.parseInt(haaID);
    				} catch (NumberFormatException nfe) {
    					haaIDValue = -1;
    				}
    				if (HAACheckListDB2.update(userBean, haaIDValue, corporationName, businessType, contractDateFromDate, contractDateToDate, enabled)) {
    					message = "Corporation created.";
    					createAction = false;
    				} else {
    					errorMessage = "Corporation create fail.";
    				}
    			} else if (updateAction) {
    				// call db update corporation name, business type
    				int haaIDValue;
    				try {
    					haaIDValue = Integer.parseInt(haaID);
    				} catch (NumberFormatException nfe) {
    					haaIDValue = -1;
    				}
    				if (HAACheckListDB2.update(userBean, haaIDValue, corporationName, businessType, contractDateFromDate, contractDateToDate, enabled)) {
    					message = "Corporation updated.";
    					updateAction = false;
    				} else {
    					errorMessage = "Corporation update fail.";
    				}
    				deleteAction = false;
    			} else if (deleteAction) {
    				int haaIDValue;
    				try {
    					haaIDValue = Integer.parseInt(haaID);
    				} catch (NumberFormatException nfe) {
    					haaIDValue = -1;
    				}
    				haaChecklist = HAACheckListDB2.get(new HaaChecklistId(siteCode, haaIDValue));
    				
    				if (HAACheckListDB2.delete(userBean, haaChecklist)) {
    					message = "Corporation deleted.";
    					deleteAction = false;
    				} else {
    					errorMessage = "Corporation delete fail.";
    				}
    				deleteAction = false;
    			} else if (updateDateAction) {
    				// call db update complete date
    				int haaIDValue;
    				try {
    					haaIDValue = Integer.parseInt(haaID);
    				} catch (NumberFormatException nfe) {
    					haaIDValue = -1;
    				}
    				int seqValue;
    				try {
    					seqValue = Integer.parseInt(seq);
    				} catch (NumberFormatException nfe) {
    					seqValue = -1;
    				}
    				Date initDateObj = DateTimeUtil.parseDate(initDate);
    				Date completeDateObj = DateTimeUtil.parseDate(completeDate);
    				if (HAACheckListDB2.updateDate(userBean, siteCode, haaIDValue, seqValue, initDateObj, completeDateObj)) {
    					message = "Progress date updated.";
    				}
    				updateDateAction = false;
    			}
    			step = null;
    		}

    		// load data from database
    		if (!createAction && !"1".equals(step)) {
    			if (haaID != null && haaID.length() > 0) {
    				int haaIDValue;
    				try {
    					haaIDValue = Integer.parseInt(haaID);
    				} catch (NumberFormatException nfe) {
    					haaIDValue = -1;
    				}
    				
    				// clear expired file
    				HAACheckListDB2.expiredContract(userBean, new HaaChecklistId(siteCode, haaIDValue));
    				
    				haaChecklist = HAACheckListDB2.get(new HaaChecklistId(siteCode, haaIDValue));
    				
    				if (haaChecklist == null) {
    					closeAction = true;
    				}
    			} else {
    				closeAction = true;
    			}
    		}
    	} catch (Exception e) {
    		e.printStackTrace();
    	}

    	if (haaID != null && haaID.length() > 0) {
			int haaIDValue;
			try {
				haaIDValue = Integer.parseInt(haaID);
			} catch (NumberFormatException nfe) {
				haaIDValue = -1;
			}
    		progressList = HAACheckListDB2.getDateProgress(userBean, new HaaChecklistId(siteCode, haaIDValue));
    	}
    	
    	// ui logic
    	String title = null;
    	String commandType = null;
    	if (createAction) {
    		commandType = "create";
    	} else if (updateAction || updateDateAction) {
    		commandType = "update";
    	} else if (deleteAction) {
    		commandType = "delete";
    	} else {
    		commandType = "view";
    	}
    	// set submit label
    	title = "function.haa." + commandType;

    	// update command type
    	if (updateDateAction) {
    		commandType = "updateDate";
    	}
    	
    	// Create select options for business type
    	List<Select> businessTypeOptionsList = new ArrayList<Select>();
    	businessTypeOptionsList.add(new Select("NB", "New Business"));
    	businessTypeOptionsList.add(new Select("RB", "Renewal Business"));
    	businessTypeOptionsList.add(new Select("PM", "Promotion"));
    	
    	String allowRemove = updateAction ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE;
    	
    	if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
    	if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
    	
    	Map<String, Object> model = new HashMap<String, Object>();
    	model.put("title", title);
    	model.put("message", message);
    	model.put("errorMessage", errorMessage);
    	model.put("seq", seq);
    	model.put("commandType", commandType);
    	model.put("createAction", createAction);
    	model.put("updateAction", updateAction);
    	model.put("updateDateAction", updateDateAction);
    	model.put("deleteAction", deleteAction);
    	model.put("closeAction", closeAction);
    	model.put("userBean", userBean);
    	haaID = haaID == null ? "" : haaID;
    	model.put("haaID", haaID);
    	model.put("allowRemove", allowRemove);
    	
    	// Encapsulate checklist values in haaChecklist object
    	haaChecklist = haaChecklist == null ? new HaaChecklist() : haaChecklist;
    	model.put("haaChecklist", haaChecklist);   
    	model.put("progressList", progressList);  
    	
    	//--------------------
    	// Discussion board plugin
    	//--------------------
//    	public static Map<String, Object> getModelMap(HttpServletRequest request, HttpServletResponse response, 
//    			String siteCode, String moduleCode, String moduleDescription, String recordId, String recordTitle, Integer numOfTopics) {
    	model.put("discussionBoard", DiscussionBoardController.getModelMap(request, response, siteCode, 
    			"haa", MessageResources.getMessage(request.getSession(), "label.ha"), haaID, haaChecklist.getHaaCorpName(), 5));
    	
    	return new ModelAndView("healthAssessment/checkitem3", "healthAssessment", model);

    }
    
	public String getRequestName() {
		return requestName;
	}

	public void setRequestName(String requestName) {
		this.requestName = requestName;
	}

}
