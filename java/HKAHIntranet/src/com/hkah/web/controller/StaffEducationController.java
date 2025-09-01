package com.hkah.web.controller;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.AbstractController;

import com.hkah.config.MessageResources;
import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.util.FileUtil;
import com.hkah.util.ParserUtil;
import com.hkah.util.TextUtil;
import com.hkah.util.upload.HttpFileUpload;
import com.hkah.web.common.UserBean;
import com.hkah.web.db.DocumentDB;
import com.hkah.web.db.StaffEducationDB;
import com.hkah.web.db.helper.StaffEducationModelHelper;
import com.hkah.web.db.hibernate.EeMenuContent;
import com.hkah.web.db.hibernate.EeMenuContentId;
import com.hkah.web.db.hibernate.EeMenuDocumentId;
import com.hkah.web.db.hibernate.EeMenuModule;
import com.hkah.web.db.hibernate.EeMenuModuleId;

public class StaffEducationController extends AbstractController  {
    protected final Log logger = LogFactory.getLog(getClass());
    
    public static final String MODULE_NAME = "education";
    
    public static final String MODULE_CODE_HOSPITAL_POLICIES = "education.hep";
    public static final String MODULE_CODE_INSERVICE_CALENDAR = "education.is_cal";
    public static final String MODULE_CODE_INSERVICE_INFO = "education.is_info";
    public static final String MODULE_CODE_INSERVICE_CONTENT = "education.is_content";
    public static final String MODULE_CODE_OTHER_INSERVICE = "education.other_is";
    public static final String MODULE_CODE_CONT_EXT_EDU = "education.cee";
    public static final String MODULE_CODE_INSERVICE_REVIEW = "education.is_review";
    public static final String MODULE_CODE_EVIDENCE_BASED_PRACTICE = "education.ebp";
    public static final String MODULE_CODE_LITERATURE_SEARCH_BASED = "education.lsb";
    public static final String MODULE_CODE_RELEVANT_INTERNET_LINKS = "education.ril";
    public static final String MODULE_CODE_NCHK = "education.nchk";
    public static final String MODULE_CODE_CONTACT = "education.contact";
    public static final String MODULE_CODE_CALENDAR = "education.cal";    
    public static final String MODULE_CODE_SMART_SOP = "education.smart";

    public static final String VIEW_HOSPITAL_POLICIES = MODULE_NAME + "/hospital_policies";
    public static final String VIEW_INSERVICE_CALENDAR = MODULE_NAME + "/inserv_calendar";
    public static final String VIEW_INSERVICE_INFO = MODULE_NAME + "/mand_inserv_info";
    public static final String VIEW_INSERVICE_CONTENT = MODULE_NAME + "/mand_inserv_content";
    public static final String VIEW_OTHER_INSERVICE = MODULE_NAME + "/other_inserv";
    public static final String VIEW_CONT_EXT_EDU = MODULE_NAME + "/cont_ext_edu";
    public static final String VIEW_INSERVICE_REVIEW = MODULE_NAME + "/inserv_review";
    public static final String VIEW_EVIDENCE_BASED_PRACTICE = MODULE_NAME + "/evidence_practice";
    public static final String VIEW_LITERATURE_SEARCH_BASED = MODULE_NAME + "/literature_search";
    public static final String VIEW_NCHK = MODULE_NAME + "/nchk";
    public static final String VIEW_CONTACT = MODULE_NAME + "/contact";
    public static final String VIEW_MENU_LIST = MODULE_NAME + "/menu_list";
    public static final String VIEW_MENU_DETAILS = MODULE_NAME + "/menu_details";
    public static final String VIEW_RELEVANT_INTERNET_LINKS = MODULE_NAME + "/link";    
    public static final String VIEW_SMART_SOP = MODULE_NAME + "/smart_sop";
    
    public static final String INSERVICE_CONTENT_TYPE_DESC = "desc";
    public static final String INSERVICE_CONTENT_TYPE_VIDEO = "video";
    public static final String INSERVICE_CONTENT_TYPE_SLIDE = "slide";
    
    private static Map<String, ModuleConfig> moduleConfig = null;
    static {
    	moduleConfig = new HashMap<String, ModuleConfig>();
    	
    	moduleConfig.put(MODULE_CODE_HOSPITAL_POLICIES, 
    			new ModuleConfig(StaffEducationController.VIEW_HOSPITAL_POLICIES));
    	moduleConfig.put(MODULE_CODE_INSERVICE_CALENDAR, 
    			new ModuleConfig(StaffEducationController.VIEW_INSERVICE_CALENDAR));
    	moduleConfig.put(MODULE_CODE_INSERVICE_INFO, 
    			new ModuleConfig(StaffEducationController.VIEW_INSERVICE_INFO));
    	moduleConfig.put(MODULE_CODE_INSERVICE_CONTENT, 
    			new ModuleConfig(StaffEducationController.VIEW_INSERVICE_CONTENT));
    	moduleConfig.put(MODULE_CODE_OTHER_INSERVICE, 
    			new ModuleConfig(StaffEducationController.VIEW_OTHER_INSERVICE));
    	moduleConfig.put(MODULE_CODE_CONT_EXT_EDU, 
    			new ModuleConfig(StaffEducationController.VIEW_CONT_EXT_EDU));
    	moduleConfig.put(MODULE_CODE_INSERVICE_REVIEW, 
    			new ModuleConfig(StaffEducationController.VIEW_INSERVICE_REVIEW, new String[]{"eeMenuContentInservReviews"}));
    	moduleConfig.put(MODULE_CODE_EVIDENCE_BASED_PRACTICE, 
    			new ModuleConfig(StaffEducationController.VIEW_EVIDENCE_BASED_PRACTICE));
    	moduleConfig.put(MODULE_CODE_LITERATURE_SEARCH_BASED, 
    			new ModuleConfig(StaffEducationController.VIEW_LITERATURE_SEARCH_BASED));
    	moduleConfig.put(MODULE_CODE_NCHK, 
    			new ModuleConfig(StaffEducationController.VIEW_NCHK));
    	moduleConfig.put(MODULE_CODE_CONTACT, 
    			new ModuleConfig(StaffEducationController.VIEW_CONTACT));
    	moduleConfig.put(MODULE_CODE_RELEVANT_INTERNET_LINKS, 
    			new ModuleConfig(StaffEducationController.VIEW_RELEVANT_INTERNET_LINKS));
    	moduleConfig.put(MODULE_CODE_SMART_SOP, 
    			new ModuleConfig(StaffEducationController.VIEW_SMART_SOP));
    	
    }
    
	static class ModuleConfig {
    	private String view = null;
    	private String[] hibernateAssociationNames = null;
    	
		public ModuleConfig(String view) {
			this.view = view;
		}
		
		public ModuleConfig(String view, String[] hibernateAssociationNames) {
			this.view = view;
			this.hibernateAssociationNames = hibernateAssociationNames;
		}
		/**
		 * @return the view
		 */
		public String getView() {
			return view;
		}
		/**
		 * @param view the view to set
		 */
		public void setView(String view) {
			this.view = view;
		}
		/**
		 * @return the hibernateAssociationNames
		 */
		public String[] getHibernateAssociationNames() {
			return hibernateAssociationNames;
		}
		/**
		 * @param hibernateAssociationNames the hibernateAssociationNames to set
		 */
		public void setHibernateAssociationNames(String[] hibernateAssociationNames) {
			this.hibernateAssociationNames = hibernateAssociationNames;
		}
    }
    
    private static String SITE_CODE = ConstantsServerSide.SITE_CODE_TWAH;
    private static final String UPLOAD_SUB_PATH =	File.separator + "Intranet" + 
    												File.separator + "Portal" +
    												File.separator + "Staff Education";  
    
    private String requestName;
    
	public String getRequestName() {
		return requestName;
	}

	public void setRequestName(String requestName) {
		this.requestName = requestName;
	}

    public ModelAndView handleRequestInternal(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    	SITE_CODE = ConstantsServerSide.SITE_CODE;
    	 
    	if ("menu_list".equals(getRequestName())) {
    		return getMenuList(request, response);
    	} else if ("menu_details".equals(getRequestName())) {
    		return getMenuDetails(request, response);
    	} else if (getRequestName() != null && getRequestName().startsWith("education")) {
    		return getMenu(request, response, getRequestName());   
    	} else {
    		return null;
    	}
    }
    
    private ModelAndView getMenuList(HttpServletRequest request, HttpServletResponse response) {
    	UserBean userBean = new UserBean(request);
    	HttpSession session = request.getSession();
    	
    	String moduleCode = ParserUtil.getParameter(request, "moduleCode");
    	String command = ParserUtil.getParameter(request, "cmd");
    	String cid = ParserUtil.getParameter(request, "cid");
    	BigDecimal cid_BD = null;
    	try {
    		cid_BD = new BigDecimal(cid);
    	} catch (Exception e) {
    	}
    	String grandCid = ParserUtil.getParameter(request, "grandCid");
    	String parentCid = ParserUtil.getParameter(request, "parentCid");
    	String level = ParserUtil.getParameter(request, "level");
    	String step = ParserUtil.getParameter(request, "step");
    	String[] contentOrder = request.getParameterValues("row[]");
    	
    	String message = request.getParameter("message");
    	String errorMessage = request.getParameter("errorMessage");

    	EeMenuModule eeMenuModule = null;
    	List<EeMenuContent> eeMenuContentList = null;
    	List<EeMenuContent> ancestors = null;
    	
    	boolean createAction = false;
    	boolean updateSortOrderAction = false;
    	boolean closeAction = false;

    	if ("create".equals(command)) {
    		createAction = true;
    	} else if ("updateSortOrder".equals(command)) {
    		updateSortOrderAction = true;
    	}
    	
    	try {
    		if ("1".equals(step)) {
    			if (updateSortOrderAction) {
    				if (contentOrder != null) {
    					BigDecimal[] contentOrder_BD = new BigDecimal[contentOrder.length];
    					int i = 0;
    					for (String order: contentOrder) {
    						try {
    							contentOrder_BD[i] = new BigDecimal(order);
    						} catch (NumberFormatException nfe) {
    							contentOrder_BD[i] = null;
    						}
    						i++;
    					}
    					
	    				if(StaffEducationDB.updateEeMenuContentSortOrder(SITE_CODE, contentOrder_BD, userBean)) {
	    					message = MessageResources.getMessage(session, "message.staffEducation.displayOrderUpdateSuccess");
	    				} else {
	    					errorMessage = MessageResources.getMessage(session, "message.staffEducation.displayOrderUpdateFail");
	    				}
    				} else {
    					errorMessage = MessageResources.getMessage(session, "message.staffEducation.displayOrderNoChange");
    				}
    				updateSortOrderAction = false;
    			}
    			step = null;
    		}
    		
			// determine required hibernate data object based on moduleCode
    		String[] associationNames = null;
    		if (moduleConfig.get(moduleCode) != null)
    			associationNames = moduleConfig.get(moduleCode).getHibernateAssociationNames();
			
	    	eeMenuModule = StaffEducationDB.getEeMenuModule(
	    			new EeMenuModuleId(moduleCode, SITE_CODE));
			eeMenuContentList = StaffEducationDB.getEeMenuContentList(
					moduleCode, cid_BD, associationNames);
    		
    		// get an ancestor list for breadcrumb navigation, limit to max 5 level only
    		ancestors = StaffEducationDB.getEeMenuContentAncestors(
    				new EeMenuContentId(SITE_CODE, cid_BD),
    				moduleCode, 5, associationNames);
    		
    		// set hierarchy level info
    		parentCid = null;
    		if (ancestors != null && ancestors.size() > 0) {
   				EeMenuContent parent = ancestors.get(ancestors.size() - 1);
				parentCid = parent.getId().getEeMenuContentId_String();
    		}
    		grandCid = null;
    		if (ancestors != null && ancestors.size() > 1) {
   				EeMenuContent grand = ancestors.get(ancestors.size() - 2);
				grandCid = grand.getId().getEeMenuContentId_String();
    		}
    		if (ancestors != null) {
    			level = String.valueOf(ancestors.size());
    		} else {
    			level = String.valueOf(0);
    		}
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    	
    	if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
    	if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
    	
    	Map<String, Object> model = new HashMap<String, Object>();
    	model.put("message", message);
    	model.put("errorMessage", errorMessage);
    	
    	model.put("moduleCode", moduleCode);
    	model.put("isModule_IsReview", MODULE_CODE_INSERVICE_REVIEW.equals(moduleCode));
    	model.put("isModuleCodeIsContent", MODULE_CODE_INSERVICE_CONTENT.equals(moduleCode));
    	model.put("command", command);
    	model.put("level", level);
    	model.put("grandCid", grandCid);
    	model.put("parentCid", parentCid);
    	
    	model.put("userBean", userBean);
    	model.put("list", eeMenuContentList);
    	model.put("eeMenuModule", eeMenuModule);
    	model.put("ancestors", ancestors);
    	
    	return new ModelAndView(VIEW_MENU_LIST, MODULE_NAME, model);
    }
    
    private ModelAndView getMenuDetails(HttpServletRequest request, HttpServletResponse response) {
    	boolean fileUpload = false;
    	boolean isUrlSpecified = false;
    	boolean isFilePathSpecified = false;
    	boolean isRemoveDocument = false;
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
    	HttpSession session = request.getSession();
    	
    	String moduleCode = ParserUtil.getParameter(request, "moduleCode");
    	String command = ParserUtil.getParameter(request, "command");
    	String cid = ParserUtil.getParameter(request, "cid");
    	String parentCid = ParserUtil.getParameter(request, "parentCid");
    	String level = ParserUtil.getParameter(request, "level");
    	String step = ParserUtil.getParameter(request, "step");
    	String fileMethod = ParserUtil.getParameter(request, "fileMethod");
    	isUrlSpecified = "url".equals(fileMethod);
    	isFilePathSpecified = "filePath".equals(fileMethod);
    	isRemoveDocument = "remove".equals(fileMethod);
    	String colorMethod = ParserUtil.getParameter(request, "colorMethod"); 
    	String eeBgColor = ParserUtil.getParameter(request, "eeBgColor"); 
    	boolean isBgColorSpecified = "color".equals(colorMethod);
    	boolean isRemovedBgColor = "remove".equals(colorMethod);
    	if (isRemovedBgColor) {
    		eeBgColor = null;
    	}
    	
    	String eeDescriptionEn = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eeDescriptionEn"));
    	String eeDescriptionZh = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eeDescriptionZh"));
    	String eeInserviceContentDescriptionEn = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eeInserviceContentDescriptionEn"));
    	String eeInserviceContentDescriptionZh = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "eeInserviceContentDescriptionZh"));
    	String url = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "url"));
    	String filePath = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "filePath"));
    	String eeType = ParserUtil.getParameter(request, "eeType");
    	
    	String message = request.getParameter("message");
    	String errorMessage = request.getParameter("errorMessage");

    	BigDecimal eeMenuContentId_BD = null;
    	try {
    		eeMenuContentId_BD = new BigDecimal(cid);
    	} catch (Exception e) {
    		eeMenuContentId_BD = new BigDecimal(-1);
    	}
    	BigDecimal eeParentMenuContentId_BD = null;
    	try {
    		eeParentMenuContentId_BD = new BigDecimal(parentCid);
    	} catch (Exception e) {
    	}
    	EeMenuContentId eeMenuContentId = new EeMenuContentId(SITE_CODE, eeMenuContentId_BD);
    	EeMenuDocumentId eeMenuDocumentId = new EeMenuDocumentId(SITE_CODE, eeMenuContentId_BD);
    	
    	EeMenuModule eeMenuModule = null;
    	EeMenuContent eeMenuContent = null;
    	List<EeMenuContent> ancestors = null;
    	
    	boolean createAction = false;
    	boolean updateAction = false;
    	boolean deleteAction = false;
    	boolean closeAction = false;
    	boolean updateReviewAction = false;

    	if ("create".equals(command)) {
    		createAction = true;
    	} else if ("update".equals(command)) {
    		updateAction = true;
    	} else if ("delete".equals(command)) {
    		deleteAction = true;
    	} else if ("updateReview".equals(command)){
    		updateReviewAction = true;
    	}
    	
    	try {
    		if ("1".equals(step)) {
    			if (createAction) {
    				boolean createSuccess = false;
    		    	
    				eeMenuContent = StaffEducationDB.addEeMenuContent(SITE_CODE, moduleCode, eeParentMenuContentId_BD,
    						eeDescriptionEn, eeDescriptionZh, eeInserviceContentDescriptionEn, eeInserviceContentDescriptionZh,
    						eeType, eeBgColor, userBean);
    				if (eeMenuContent != null) {
    					createSuccess = true;
    					eeMenuContentId = eeMenuContent.getId();
    				}
    				
    				if(createSuccess) {
        				if (isUrlSpecified && !StringUtils.isEmpty(url)) {
        					processUrl(request, eeMenuContentId, moduleCode, url, userBean);
        				} else if (isFilePathSpecified) {
        					processFilePath(request, eeMenuContentId, moduleCode, filePath, userBean);
        				} else if (fileUpload) {
        					processUploadedDocument(request, eeMenuContentId, moduleCode, userBean);
        				}
        				
    					message = MessageResources.getMessage(session, "message.staffEducation.createSuccess");
    				} else {
    					errorMessage = MessageResources.getMessage(session, "message.staffEducation.createFail");
    				}
    				
    				createAction = false;
    			}else if (updateReviewAction){
    				boolean updateSuccess = false;
    				updateSuccess = StaffEducationDB.updateEeMenuContent(
    						eeMenuContentId, moduleCode, eeDescriptionEn, eeDescriptionZh, 
    						eeInserviceContentDescriptionEn, eeInserviceContentDescriptionZh, eeType, eeBgColor, userBean,true);
    				updateReviewAction = false;
    				
    			} else if (updateAction) {
    				boolean updateSuccess = false;
    				
    				updateSuccess = StaffEducationDB.updateEeMenuContent(
    						eeMenuContentId, moduleCode, eeDescriptionEn, eeDescriptionZh, 
    						eeInserviceContentDescriptionEn, eeInserviceContentDescriptionZh, eeType, eeBgColor, userBean);
    				if (isRemoveDocument) {
    					DocumentDB.delete(eeMenuContentId.getEeSiteCode(), userBean, moduleCode, eeMenuContentId.getEeMenuContentId().toEngineeringString());
    					updateSuccess = StaffEducationDB.deleteEeMenuDocument(eeMenuDocumentId, moduleCode, userBean);
    				} else if (isUrlSpecified && !StringUtils.isEmpty(url)) {
    					processUrl(request, eeMenuContentId, moduleCode, url, userBean);
    				} else if (isFilePathSpecified) {
    					processFilePath(request, eeMenuContentId, moduleCode, filePath, userBean);
    				} else if (fileUpload) {
    					processUploadedDocument(request, eeMenuContentId, moduleCode, userBean);
    				}
    				
    				if(updateSuccess) {
    					message = MessageResources.getMessage(session, "message.staffEducation.updateSuccess");
    				} else {
    					errorMessage = MessageResources.getMessage(session, "message.staffEducation.updateFail");
    				}
    				
    				updateAction = false;	                                                                                                                                                                                     
    			} else if (deleteAction) {
    				boolean deleteSuccess = false;
    				
    				deleteSuccess = StaffEducationDB.deleteEeMenuContent(eeMenuContentId, moduleCode, userBean);
    				if(deleteSuccess) {
    					message = MessageResources.getMessage(session, "message.staffEducation.deleteSuccess");
    				} else {
    					errorMessage = MessageResources.getMessage(session, "message.staffEducation.deleteFail");
    				}
    				
    				deleteAction = false;	
    			}
    			step = null;
    		}
    		
    		//------------------------
    		// load data from database
    		//------------------------
	    	eeMenuModule = StaffEducationDB.getEeMenuModule(
	    			new EeMenuModuleId(moduleCode, SITE_CODE));
    		if (!createAction && !"1".equals(step)) {
    			if (eeMenuContentId != null) {
    				eeMenuContent = StaffEducationDB.getEeMenuContent(eeMenuContentId, moduleCode);
    				

    				
    		    	if (MODULE_CODE_INSERVICE_CONTENT.equals(moduleCode)) {
    		    		// set EeMenuContentMandCont
    			    	StaffEducationModelHelper.constructEeMenuContentTreeForInserviceContent(eeMenuContent);
    		    	}
    			}
    		}
    		
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    	
    	// ui logic
    	String commandType = null;
    	if (createAction) {
    		commandType = "create";
    	} else if (updateAction) {
    		commandType = "update";
    	} else if (deleteAction) {
    		commandType = "delete";
    	} else {
    		commandType = "view";
    	}
    	
    	String allowRemove = updateAction ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE;
    	
    	if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
    	if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
    	
    	Map<String, Object> model = new HashMap<String, Object>();
    	model.put("message", message);
    	model.put("errorMessage", errorMessage);
    	model.put("commandType", commandType);
    	model.put("createAction", createAction);
    	model.put("updateAction", updateAction);
    	model.put("updateReviewAction", updateReviewAction);
    	model.put("deleteAction", deleteAction);
    	model.put("closeAction", closeAction);
    	model.put("allowRemove", allowRemove);
    	
    	model.put("moduleCode", moduleCode);
    	model.put("isModuleCodeIsReview", MODULE_CODE_INSERVICE_REVIEW.equals(moduleCode));
    	model.put("isModuleCodeIsContent", MODULE_CODE_INSERVICE_CONTENT.equals(moduleCode));
    	model.put("parentCid", parentCid);
    	model.put("command", command);
    	model.put("level", level);
    	
    	model.put("userBean", userBean);
    	model.put("eeMenuModule", eeMenuModule);
    	cid = cid == null ? "" : cid;
    	model.put("eeMenuContentId", cid);
    	model.put("eeMenuContent", eeMenuContent);
    	model.put("ancestors", ancestors);
    	
    	return new ModelAndView(VIEW_MENU_DETAILS, MODULE_NAME, model);
    }
    
    private void processUploadedDocument(HttpServletRequest request, EeMenuContentId id, String moduleCode, UserBean userBean) {
		String[] fileList = (String[]) request.getAttribute("filelist");
		if (fileList != null) {
			StringBuffer tempStrBuffer = new StringBuffer();

			tempStrBuffer.append(ConstantsServerSide.DOCUMENT_FOLDER);
			tempStrBuffer.append(UPLOAD_SUB_PATH);
			tempStrBuffer.append(File.separator);
			tempStrBuffer.append(id.getEeMenuContentId());
			tempStrBuffer.append(File.separator);
			String baseUrl = tempStrBuffer.toString();

			tempStrBuffer.setLength(0);
			tempStrBuffer.append(UPLOAD_SUB_PATH);
			tempStrBuffer.append(File.separator);
			tempStrBuffer.append(id.getEeMenuContentId());
			String webUrl = tempStrBuffer.toString();
			
			String documentID = null;
			for (int i = 0; i < fileList.length; i++) {
				FileUtil.moveFile(
					ConstantsServerSide.UPLOAD_FOLDER + File.separator + fileList[i],
					baseUrl + fileList[i]
				);
				
				// add record to CO_DOCUMENT_GENERAL
				DocumentDB.delete(SITE_CODE, userBean, moduleCode, id.getEeMenuContentId().toString());
				documentID = DocumentDB.add(SITE_CODE, userBean, moduleCode, id.getEeMenuContentId().toString(), webUrl, fileList[i]);
				
				// insert EE_MENU_DOCUMENT
				StaffEducationDB.updateOrInsertEeMenuDocument(id, moduleCode, new BigDecimal(documentID), userBean);
			}
		}
    }
    
    private void processUrl(HttpServletRequest request, EeMenuContentId id, String moduleCode, 
    		String url, UserBean userBean) {
		// insert or update EE_MENU_DOCUMENT
		StaffEducationDB.updateOrInsertEeMenuDocument(id, moduleCode, url, userBean);
    }
    
    private void processFilePath(HttpServletRequest request, EeMenuContentId id, String moduleCode, 
    		String filePath, UserBean userBean) {
    	String folderPath = "";
    	String fileName = "";
    	if (filePath != null) {
    		String separator = "\\\\";
    		if (filePath.startsWith("/")) {
    			separator = "/";
    		}
    		String[] pathArray = filePath.split(separator);
    		if (pathArray != null && pathArray.length > 0) {
    			fileName = pathArray[pathArray.length - 1];
    			try {
    				folderPath = filePath.substring(0, filePath.indexOf(fileName) - 1);
    			} catch (Exception e) {
    			}
    		}
    	}
    	
		// add record to CO_DOCUMENT_GENERAL
		DocumentDB.delete(SITE_CODE, userBean, moduleCode, id.getEeMenuContentId().toString());
		String documentID = DocumentDB.add(SITE_CODE, userBean, moduleCode, id.getEeMenuContentId().toString(), folderPath, fileName);
		
		// insert or update EE_MENU_DOCUMENT
		StaffEducationDB.updateOrInsertEeMenuDocument(id, moduleCode, new BigDecimal(documentID), userBean);
    }
    
    private ModelAndView getMenu(HttpServletRequest request, HttpServletResponse response,
    		String moduleCode) {
    	UserBean userBean = new UserBean(request);
    	String message = request.getParameter("message");
    	String errorMessage = request.getParameter("errorMessage");
    	boolean allowEdit = userBean.isGroupID("managerEducation");
    	
    	EeMenuModule eeMenuModule = StaffEducationDB.getEeMenuModule(
    			new EeMenuModuleId(moduleCode, SITE_CODE));

		String[] associationNames = null;
		if (moduleConfig.get(moduleCode) != null)
			associationNames = moduleConfig.get(moduleCode).getHibernateAssociationNames();
    	
    	List<EeMenuContent> eeMenuContentList = StaffEducationDB.getEeMenuContentList(
    			moduleCode, associationNames);
    	
    	if (MODULE_CODE_INSERVICE_CONTENT.equals(moduleCode)) {
    		// set EeMenuContentMandCont
    		if (eeMenuContentList != null) {
	    		for (Iterator<EeMenuContent> it = eeMenuContentList.iterator(); it.hasNext();) {
	    			StaffEducationModelHelper.constructEeMenuContentTreeForInserviceContent(it.next());
	    		}
    		}
    	}
    	
    	if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
    	if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
    	
    	Map<String, Object> model = new HashMap<String, Object>();
    	model.put("message", message);
    	model.put("errorMessage", errorMessage);
    	model.put("userBean", userBean);
    	model.put("allowEdit", allowEdit);
    	model.put("moduleCode", moduleCode);
    	model.put("list", eeMenuContentList);
    	model.put("listSize", (eeMenuContentList == null ? 0: eeMenuContentList.size()));
    	model.put("eeMenuModule", eeMenuModule);
    	
    	return new ModelAndView(moduleConfig.get(moduleCode).getView(), MODULE_NAME, model);
    }
}
