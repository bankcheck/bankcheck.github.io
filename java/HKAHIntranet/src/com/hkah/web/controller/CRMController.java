package com.hkah.web.controller;

import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

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
import com.hkah.util.TextUtil;
import com.hkah.util.upload.HttpFileUpload;
import com.hkah.web.common.UserBean;
import com.hkah.web.db.CRMPromotionDB2;
import com.hkah.web.db.DocumentDB;
import com.hkah.web.db.hibernate.CoDepartments;
import com.hkah.web.db.hibernate.CoEvent;
import com.hkah.web.db.hibernate.CoEventId;
import com.hkah.web.db.hibernate.CrmClients;
import com.hkah.web.db.hibernate.CrmPromotion;
import com.hkah.web.db.hibernate.CrmPromotionClient;
import com.hkah.web.db.hibernate.CrmPromotionClientId;
import com.hkah.web.db.hibernate.CrmPromotionDepartment;
import com.hkah.web.db.hibernate.CrmPromotionDepartmentId;
import com.hkah.web.db.hibernate.CrmPromotionDocumentId;
import com.hkah.web.db.hibernate.CrmPromotionEnquiry;
import com.hkah.web.db.hibernate.CrmPromotionEnquiryId;
import com.hkah.web.db.hibernate.CrmPromotionId;
import com.hkah.web.db.hibernate.CrmPromotionInstruction;
import com.hkah.web.db.hibernate.CrmPromotionInstructionId;
import com.hkah.web.db.hibernate.CrmPromotionRefCode;
import com.hkah.web.db.hibernate.CrmPromotionTarget;
import com.hkah.web.db.hibernate.CrmPromotionTargetId;
import com.hkah.web.db.hibernate.CrmTarget;

public class CRMController extends AbstractController  {
    protected final Log logger = LogFactory.getLog(getClass());
    
    public static final String MODULE_CODE = "crm";
    public static final String MODULE_CODE_DOCUMENT = "crm.promotion";
    public static final String PROMOTION_LIST = "promotion_list";
    public static final String PROMOTION_DETAIL = "promotion_detail";
    public static final String TARGET_LIST = "target_list";
    public static final String TARGET_DETAIL = "target_detail";
    public static final String VIEW_PROMOTION_LIST = MODULE_CODE + "/" + PROMOTION_LIST;
    public static final String VIEW_PROMOTION_DETAIL = MODULE_CODE + "/" + PROMOTION_DETAIL;
    public static final String VIEW_TARGET_LIST = MODULE_CODE + "/" + TARGET_LIST;
    public static final String VIEW_TARGET_DETAIL = MODULE_CODE + "/" + TARGET_DETAIL;
    
    public static final String PROMOTION_STATUS_CODE_CURRENT = "cr";
    public static final String PROMOTION_STATUS_CODE_COMING = "cm";
    public static final String PROMOTION_STATUS_CODE_EXPIRED = "exp";
    public static final String PROMOTION_STATUS_CODE_ALL = "all";
    
    public static final String REF_TYPE_CODE_NONE = "none";
    
    public static final String CO_EVENT_CATEGORY = "marketing";
    public static final String CO_EVENT_TYPE = "promotion";
    public static final String CRM_TARGET_TYPE = "corporate";
    
    public static final String CRM_DOCUMENT_TYPE_DETAILS = "details";
    public static final String CRM_DOCUMENT_TYPE_MATERIALS = "materials";
    
    private static String SITE_CODE = ConstantsServerSide.SITE_CODE;
    private static final String WEB_PATH =	File.separator + "Intranet" + 
    												File.separator + "Portal" +
    												File.separator + "Documents" +
    												File.separator + "crm";
    
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
    	 
    	if (PROMOTION_LIST.equals(getRequestName())) {
    		return getPromotionList(request, response);
    	} else if (PROMOTION_DETAIL.equals(getRequestName())) {
    		return getPromotionDetail(request, response);
    	} else if (TARGET_LIST.equals(getRequestName())) {
    		return getTargetList(request, response);
    	} else if (TARGET_DETAIL.equals(getRequestName())) {
    		return getTargetDetail(request, response);
    	} else {
    		return null;
    	}
    }
    
    private ModelAndView getPromotionList(HttpServletRequest request, HttpServletResponse response) {
    	UserBean userBean = new UserBean(request);
    	HttpSession session = request.getSession();
    	
    	String moduleCode = ParserUtil.getParameter(request, "moduleCode");
    	String command = ParserUtil.getParameter(request, "cmd");
    	String eventID = ParserUtil.getParameter(request, "eventID");
    	
    	String promotionStatus = ParserUtil.getParameter(request, "promotionStatus");
    	if (promotionStatus == null) {
    		promotionStatus = PROMOTION_STATUS_CODE_CURRENT;
    	}
    	
    	String message = request.getParameter("message");
    	String errorMessage = request.getParameter("errorMessage");

    	List<CoEvent> coEvents = null;
    	try {
    		coEvents = CRMPromotionDB2.getCoEventWithCrmPromotionList(promotionStatus);
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    	
    	if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
    	if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
    	
    	// promotion list search criteria
    	HashMap<String, String> promotionStatusHashMap = new LinkedHashMap<String, String>();
    	promotionStatusHashMap.put(PROMOTION_STATUS_CODE_CURRENT, MessageResources.getMessage(session, "label.current"));
    	promotionStatusHashMap.put(PROMOTION_STATUS_CODE_COMING, MessageResources.getMessage(session, "label.coming"));
    	promotionStatusHashMap.put(PROMOTION_STATUS_CODE_EXPIRED, MessageResources.getMessage(session, "label.expired"));
    	promotionStatusHashMap.put(PROMOTION_STATUS_CODE_ALL, MessageResources.getMessage(session, "label.all"));

    	
    	Map<String, Object> model = new HashMap<String, Object>();
    	model.put("message", message);
    	model.put("errorMessage", errorMessage);
    	
    	model.put("moduleCode", moduleCode);
    	model.put("command", command);
    	model.put("userBean", userBean);
    	model.put("list", coEvents);
    	model.put("promotionStatus", promotionStatus);
    	model.put("promotionStatusHashMap", promotionStatusHashMap);
    	
    	return new ModelAndView(VIEW_PROMOTION_LIST, MODULE_CODE, model);
    }
    
    private ModelAndView getPromotionDetail(HttpServletRequest request, HttpServletResponse response) {
    	if (HttpFileUpload.isMultipartContent(request)){
    		HttpFileUpload.toUploadFolder(
    			request,
    			ConstantsServerSide.DOCUMENT_FOLDER,
    			ConstantsServerSide.TEMP_FOLDER,
    			ConstantsServerSide.UPLOAD_FOLDER,
    			"UTF-8"
    		);
    	}
    	
    	UserBean userBean = new UserBean(request);
    	HttpSession session = request.getSession();
    	
    	String command = ParserUtil.getParameter(request, "command");
    	String eventID = ParserUtil.getParameter(request, "eventID");
    	String step = ParserUtil.getParameter(request, "step");
    	
    	String message = request.getParameter("message");
    	String errorMessage = request.getParameter("errorMessage");

    	BigDecimal coEventId_BD = null;
    	try {
    		coEventId_BD = new BigDecimal(eventID);
    	} catch (Exception e) {
    		coEventId_BD = new BigDecimal(-1);
    	}
    	CoEventId coEventId = new CoEventId(SITE_CODE, MODULE_CODE, coEventId_BD);
    	
    	CoEvent coEvent = null;
    	List<CrmTarget> crmTargetList = null; 
    	List<CrmPromotionRefCode> crmPromotionRefCodeList = null; 
    	//Cherry edit20100709//
    	List<CrmClients> crmClientList = null;
    	//Cherry edit20100709//
    	boolean createAction = false;
    	boolean updateAction = false;
    	boolean deleteAction = false;
    	boolean closeAction = false;

    	if ("create".equals(command)) {
    		createAction = true;
    	} else if ("update".equals(command)) {
    		updateAction = true;
    	} else if ("delete".equals(command)) {
    		deleteAction = true;
    	}
    	
    	try {
    		if ("1".equals(step)) {
    			coEvent = CRMPromotionDB2.getCoEventWithCrmPromotion(coEventId);
    			
    			if (createAction) {
    				boolean createSuccess = false;
    				
        			// construct promotion object
        			coEvent = constructCoEventObject(request, coEvent);
        			coEventId = coEvent.getId();
    		    	
    				createSuccess = CRMPromotionDB2.add(coEvent);
    				
    				if(createSuccess) {
    					processUploadedDocument(request, coEvent.getId(), MODULE_CODE, userBean);
    					message = MessageResources.getMessage(session, "message.target.createSuccess");
    				} else {
    					errorMessage = MessageResources.getMessage(session, "message.target.createFail");
    				}
    				
    				createAction = false;
    			} else if (updateAction) {
    				boolean updateSuccess = false;
    				
        			// construct promotion object
        			coEvent = constructCoEventObject(request, coEvent);
    				
    				updateSuccess = CRMPromotionDB2.update(coEvent);
    				
    				if(updateSuccess) {
    					processUploadedDocument(request, coEvent.getId(), MODULE_CODE, userBean);
    					message = MessageResources.getMessage(session, "message.target.updateSuccess");
    				} else {
    					errorMessage = MessageResources.getMessage(session, "message.target.updateFail");
    				}
    				
    				updateAction = false;	
    			} else if (deleteAction) {
    				boolean deleteSuccess = false;
    				
    				deleteSuccess = CRMPromotionDB2.delete(userBean, coEvent);
    				if(deleteSuccess) {
    					message = MessageResources.getMessage(session, "message.target.deleteSuccess");
    				} else {
    					errorMessage = MessageResources.getMessage(session, "message.target.deleteFail");
    				}
    				
    				deleteAction = false;	
    			}
    			step = null;
    		}
    		
    		//------------------------
    		// load data from database
    		//------------------------
    		if (!createAction && !"1".equals(step)) {
    			if (coEventId != null) {
    				coEvent = CRMPromotionDB2.getCoEventWithCrmPromotion(coEventId);
    				
    			}
    		}
    		crmTargetList = CRMPromotionDB2.getCrmTargetList();
    		crmPromotionRefCodeList = CRMPromotionDB2.getCrmPromotionRefCodeList();
    		//crmClientList = CRMPromotionDB2.getCrmClientList();
    		
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    	
    	// ui logic
    	String commandType = null;
    	String title = "";
    	if (createAction) {
    		commandType = "create";
    	} else if (updateAction) {
    		commandType = "update";
    	} else if (deleteAction) {
    		commandType = "delete";
    	} else {
    		commandType = "view";
    	}
    	// set submit label
    	title = "function.event.promotion." + commandType;
    	
    	String allowRemove = updateAction ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE;
    	
    	if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
    	if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
    	
    	Map<String, Object> model = new HashMap<String, Object>();
    	model.put("message", message);
    	model.put("errorMessage", errorMessage);
    	model.put("commandType", commandType);
    	model.put("createAction", createAction);
    	model.put("updateAction", updateAction);
    	model.put("deleteAction", deleteAction);
    	model.put("closeAction", closeAction);
    	model.put("allowRemove", allowRemove);
    	
    	model.put("moduleCode", MODULE_CODE);
    	model.put("moduleCodeDocument", MODULE_CODE_DOCUMENT);
    	model.put("title", title);
    	
    	model.put("userBean", userBean);
    	model.put("coEvent", coEvent);
    	model.put("crmTargetList", crmTargetList);
    	model.put("crmPromotionRefCodeList", crmPromotionRefCodeList);
    	model.put("crmClientList", crmClientList);
    	
    	return new ModelAndView(VIEW_PROMOTION_DETAIL, MODULE_CODE, model);
    }
    
    private CoEvent constructCoEventObject(HttpServletRequest request, CoEvent coEvent) {
    	boolean eventIsExist;
    	UserBean userBean = new UserBean(request);
    	
    	String eventID = ParserUtil.getParameter(request, "eventID");
    	String coEventDesc = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "coEventDesc"));
    	String crmInitialDateFm = ParserUtil.getParameter(request, "crmInitialDateFm");
    	String crmInitialDateTo = ParserUtil.getParameter(request, "crmInitialDateTo");
    	String[] crmDepartmentCodes = (String[]) request.getAttribute("crmDepartmentCode[]_StringArray");
    	String[] crmTargetIds = (String[]) request.getAttribute("crmTargetId[]_StringArray");
    	String[] crmEnquirys = (String[]) request.getAttribute("crmEnquiry[]_StringArray");
    	String[] crmPhones = (String[]) request.getAttribute("crmPhone[]_StringArray");
    	String[] crmPromoInstrCodes = (String[]) request.getAttribute("crmPromoInstrCode[]_StringArray");
    	String[] crmPromoInstrRemarks = (String[]) request.getAttribute("crmPromoInstrRemarks[]_StringArray");	
    	String crmPromoteRemarks = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "crmPromoteRemarks"));
    	String crmRefTypeCode = ParserUtil.getParameter(request, "crmRefTypeCode");
    	String crmRefCode = ParserUtil.getParameter(request, "crmRefCode");
    	
    	String[] crmPromotionClientList = (String[]) request.getAttribute("selected_client[]_StringArray");
    	
    	BigDecimal coEventID_DB = null;
    	try {
    		coEventID_DB = new BigDecimal(eventID);
    	} catch (Exception e) {
    	}
    	Date now = new Date();
    	
    	// CoEvent
    	if (coEvent == null) {
    		coEvent = new CoEvent();
    		eventIsExist = false;
    	} else {
    		eventIsExist = true;
    	}
    	CoEventId coEventId = new CoEventId();
    	coEventId.setCoEventId(coEventID_DB);
    	coEventId.setCoSiteCode(SITE_CODE);
    	coEventId.setCoModuleCode(MODULE_CODE);
    	coEvent.setId(coEventId);
    	
    	if (!eventIsExist) {
    		coEvent.setCoCreatedDate(now);
    		coEvent.setCoCreatedUser(userBean.getLoginID());
    		coEvent.setCoEnabled(1);
    	}
		coEvent.setCoModifiedDate(now);
		coEvent.setCoModifiedUser(userBean.getLoginID());
    	coEvent.setCoEventDesc(coEventDesc);
    	coEvent.setCoEventCategory(CO_EVENT_CATEGORY);
    	coEvent.setCoEventType(CO_EVENT_TYPE);
    	
    	// CrmPromotion
    	CrmPromotion crmPromotion = coEvent.getCrmPromotion();
    	if (crmPromotion == null) {
    		crmPromotion = new CrmPromotion();
    	}
    	CrmPromotionId crmPromotionId = new CrmPromotionId();
    	crmPromotionId.setCrmEventId(coEventID_DB);
    	crmPromotionId.setCrmSiteCode(SITE_CODE);
    	crmPromotionId.setCrmModuleCode(MODULE_CODE);
    	crmPromotion.setId(crmPromotionId);
    	
    	crmPromotion.setCrmInitialDateFm(DateTimeUtil.parseDate(crmInitialDateFm));
    	crmPromotion.setCrmInitialDateTo(DateTimeUtil.parseDate(crmInitialDateTo));
    	crmPromotion.setCrmPromoteRemarks(crmPromoteRemarks);
    	
    	if (crmRefTypeCode == null || REF_TYPE_CODE_NONE.equals(crmRefTypeCode)) {
    		crmPromotion.setCrmPromotionRefCode(null);
    		crmPromotion.setCrmRefCode(null);
    	} else {
    		crmPromotion.setCrmPromotionRefCode(new CrmPromotionRefCode(crmRefTypeCode));
    		crmPromotion.setCrmRefCode(crmRefCode);
    	}
       	if (!eventIsExist) {
       		crmPromotion.setCrmCreatedDate(now);
       		crmPromotion.setCrmCreatedUser(userBean.getLoginID());
       		crmPromotion.setCrmEnabled(1);
    	}
       	crmPromotion.setCrmModifiedDate(now);
       	crmPromotion.setCrmModifiedUser(userBean.getLoginID());
		
    	coEvent.setCrmPromotion(crmPromotion);
    	
    	// CrmPromotionDepartment
    	Set<CrmPromotionDepartment> departments = crmPromotion.getCrmPromotionDepartments();
    	CrmPromotionDepartment iDepartment = null;
		for (Iterator<CrmPromotionDepartment> itr = departments.iterator(); itr.hasNext(); ) {
			iDepartment = itr.next();
			iDepartment.setCrmEnabled(0);
		}
    	if (crmDepartmentCodes != null && crmDepartmentCodes.length > 0) {
	    	if (crmPromotion.getCrmPromotionDepartments() == null) {
	    		crmPromotion.setCrmPromotionDepartments(new LinkedHashSet<CrmPromotionDepartment>(0));
	    	}
	    	
	    	CrmPromotionDepartment crmPromotionDepartment = null;
	    	CrmPromotionDepartmentId crmPromotionDepartmentId = null;
	    	CoDepartments coDepartments = null;
	    	boolean modelIsExist = false;
	    	
	    	for (String departmentCode : crmDepartmentCodes) {
	    		crmPromotionDepartment = null;
	    		modelIsExist = false;
	    		
	    		if (departmentCode != null) {
	    			crmPromotionDepartmentId = new CrmPromotionDepartmentId();
	    			crmPromotionDepartmentId.setCrmEventId(coEventID_DB);
	    			crmPromotionDepartmentId.setCrmSiteCode(SITE_CODE);
	    			crmPromotionDepartmentId.setCrmModuleCode(MODULE_CODE);
	    			crmPromotionDepartmentId.setCrmDepartmentCode(new BigDecimal(departmentCode));
	    			
	    			for (Iterator<CrmPromotionDepartment> itr = departments.iterator(); itr.hasNext(); ) {
	    				iDepartment = itr.next();
	    				
	    				if (crmPromotionDepartmentId.equals(iDepartment.getId())) {
	    					crmPromotionDepartment = iDepartment;
	    					modelIsExist = true;
	    				}
	    			}
	    			
	    			if (crmPromotionDepartment == null) {
	    				crmPromotionDepartment = new CrmPromotionDepartment();
	    				crmPromotionDepartment.setCrmCreatedDate(new Date());
	    				crmPromotionDepartment.setCrmCreatedUser(userBean.getLoginID());
	    			}
	    			crmPromotionDepartment.setId(crmPromotionDepartmentId);
    				crmPromotionDepartment.setCrmModifiedDate(new Date());
    				crmPromotionDepartment.setCrmModifiedUser(userBean.getLoginID());
    				crmPromotionDepartment.setCrmEnabled(1);
	    			
	    			coDepartments = new CoDepartments();
	    			coDepartments.setCoDepartmentCode(new BigDecimal(departmentCode));
	    			crmPromotionDepartment.setCoDepartments(coDepartments);
	    			
	    			if (!modelIsExist) {
	    				departments.add(crmPromotionDepartment);
	    			}
	    		}
	    	}
    	}
    	//CrmPromotionClient
    	Set<CrmPromotionClient> client = crmPromotion.getCrmPromotionClient();
    	CrmPromotionClient iClient = null;
		for (Iterator<CrmPromotionClient> itr = client.iterator(); itr.hasNext(); ) {
			iClient = itr.next();
			iClient.setCrmEnabled(0);
		}
    	if (crmPromotionClientList != null && crmPromotionClientList.length > 0) {
	    	if (crmPromotion.getCrmPromotionClient() == null) {
	    		crmPromotion.setCrmPromotionClient(new LinkedHashSet<CrmPromotionClient>(0));
	    	}
	    	
	    	CrmPromotionClient crmPromotionClient = null;
	    	CrmPromotionClientId crmPromotionClientId = null;
	    	
	    	boolean modelIsExist = false;
	    	
	    	for (String clientlist : crmPromotionClientList) {
	    		crmPromotionClient = null;
	    		modelIsExist = false;
	    		
	    		if (clientlist != null) {
	    			crmPromotionClientId = new CrmPromotionClientId();
	    			crmPromotionClientId.setCrmEventId(coEventID_DB);
	    			crmPromotionClientId.setCrmSiteCode(SITE_CODE);
	    			crmPromotionClientId.setCrmModuleCode(MODULE_CODE);
	    			crmPromotionClientId.setCrmClientId(new BigDecimal(clientlist));
	    			
	    			for (Iterator<CrmPromotionClient> itr = client.iterator(); itr.hasNext(); ) {
	    				iClient = itr.next();
	    				
	    				if (crmPromotionClientId.equals(iClient.getId())) {
	    					crmPromotionClient = iClient;
	    					modelIsExist = true;
	    				}
	    			}
	    			
	    			if (crmPromotionClient == null) {
	    				crmPromotionClient = new CrmPromotionClient();
	    				crmPromotionClient.setCrmCreateDate(new Date());
	    				crmPromotionClient.setCrmCreateUser(userBean.getLoginID());
	    			}
	    			crmPromotionClient.setId(crmPromotionClientId);
	    			crmPromotionClient.setCrmModifiedDate(new Date());
	    			crmPromotionClient.setCrmModifiedUser(userBean.getLoginID());
	    			crmPromotionClient.setCrmEnabled(1);
	    				    			
	    			if (!modelIsExist) {
	    				client.add(crmPromotionClient);
	    			}
	    		}
	    	}
    	}    	
    	// CrmPromotionTarget
    	Set<CrmPromotionTarget> targets = crmPromotion.getCrmPromotionTargets();
    	CrmPromotionTarget iTarget = null;
		for (Iterator<CrmPromotionTarget> itr = targets.iterator(); itr.hasNext(); ) {
			iTarget = itr.next();
			iTarget.setCrmEnabled(0);
		}
    	if (crmTargetIds != null && crmTargetIds.length > 0) {
	    	if (crmPromotion.getCrmPromotionTargets() == null) {
	    		crmPromotion.setCrmPromotionTargets(new LinkedHashSet<CrmPromotionTarget>(0));
	    	}
	    	
	    	CrmPromotionTarget crmPromotionTarget = null;
	    	CrmPromotionTargetId crmPromotionTargetId = null;
	    	boolean modelIsExist = false;
	    	
	    	for (String targetId : crmTargetIds) {
	    		if (targetId != null) {
	    			crmPromotionTarget = new CrmPromotionTarget();
	    			crmPromotionTargetId = new CrmPromotionTargetId();
	    			crmPromotionTargetId.setCrmEventId(coEventID_DB);
	    			crmPromotionTargetId.setCrmSiteCode(SITE_CODE);
	    			crmPromotionTargetId.setCrmModuleCode(MODULE_CODE);
	    			crmPromotionTargetId.setCrmTargetId(new BigDecimal(targetId));
	    			
	    			for (Iterator<CrmPromotionTarget> itr = targets.iterator(); itr.hasNext(); ) {
	    				iTarget = itr.next();
	    				
	    				if (crmPromotionTargetId.equals(iTarget.getId())) {
	    					crmPromotionTarget = iTarget;
	    					modelIsExist = true;
	    				}
	    			}
	    			
	    			if (crmPromotionTarget == null) {
	    				crmPromotionTarget = new CrmPromotionTarget();
	    				crmPromotionTarget.setCrmCreatedDate(new Date());
	    				crmPromotionTarget.setCrmCreatedUser(userBean.getLoginID());
	    			}
	    			crmPromotionTarget.setId(crmPromotionTargetId);
	    			crmPromotionTarget.setCrmModifiedDate(new Date());
	    			crmPromotionTarget.setCrmModifiedUser(userBean.getLoginID());
	    			crmPromotionTarget.setCrmEnabled(1);
    				
	    			crmPromotionTarget.getCrmTargetType();
	    			
	    			if (!modelIsExist) {
	    				targets.add(crmPromotionTarget);
	    			}
	    		}
	    	}
    	}
    	
    	// CrmPromotionInstruction
    	CrmPromotionInstruction iInstruction = null;
    	Set<CrmPromotionInstruction> instructions = crmPromotion.getCrmPromotionInstructions();
		for (Iterator<CrmPromotionInstruction> itr = instructions.iterator(); itr.hasNext(); ) {
			iInstruction = itr.next();
			iInstruction.setCrmEnabled(0);
		}
    	if (crmPromoInstrCodes != null && crmPromoInstrCodes.length > 0) {
	    	if (crmPromotion.getCrmPromotionInstructions() == null) {
	    		crmPromotion.setCrmPromotionInstructions(new LinkedHashSet<CrmPromotionInstruction>(0));
	    	}
	    	CrmPromotionInstruction crmPromotionInstruction = null;
	    	CrmPromotionInstructionId crmPromotionInstructionId = null;
	    	String instrCode = null;
	    	boolean modelIsExist = false;
	    	
	    	for (int i = 0; i < crmPromoInstrCodes.length; i++) {
	    		instrCode = crmPromoInstrCodes[i];
	    		modelIsExist = false;
	    		
	    		if (instrCode != null) {
	    			crmPromotionInstruction = new CrmPromotionInstruction();
	    			crmPromotionInstructionId = new CrmPromotionInstructionId();
	    			crmPromotionInstructionId.setCrmEventId(coEventID_DB);
	    			crmPromotionInstructionId.setCrmSiteCode(SITE_CODE);
	    			crmPromotionInstructionId.setCrmModuleCode(MODULE_CODE);
	    			crmPromotionInstructionId.setCrmPromoInstrPid(new BigDecimal(i + 1));
	    			
	    			for (Iterator<CrmPromotionInstruction> itr = instructions.iterator(); itr.hasNext(); ) {
	    				iInstruction = itr.next();
	    				
	    				if (crmPromotionInstructionId.equals(iInstruction.getId())) {
	    					crmPromotionInstruction = iInstruction;
	    					modelIsExist = true;
	    				}
	    			}
	    			
	    			if (crmPromotionInstruction == null) {
	    				crmPromotionInstruction = new CrmPromotionInstruction();
	    				crmPromotionInstruction.setCrmCreatedDate(new Date());
	    				crmPromotionInstruction.setCrmCreatedUser(userBean.getLoginID());
	    			}
	    			
	    			crmPromotionInstruction.setId(crmPromotionInstructionId);
	    			crmPromotionInstruction.setCrmPromoInstrCode(TextUtil.parseStrUTF8(instrCode));
	    			crmPromotionInstruction.setCrmPromoInstrRemarks(TextUtil.parseStrUTF8(crmPromoInstrRemarks[i]));
	    			crmPromotionInstruction.setCrmModifiedDate(new Date());
	    			crmPromotionInstruction.setCrmModifiedUser(userBean.getLoginID());
	    			crmPromotionInstruction.setCrmEnabled(1);
	    			
	    			if (!modelIsExist) {
	    				instructions.add(crmPromotionInstruction);
	    			}
	    		}
	    	}
    	}
    	
    	// CrmPromotionEnquiry
    	Set<CrmPromotionEnquiry> enquiries = crmPromotion.getCrmPromotionEnquiries();
    	CrmPromotionEnquiry iEnquiry = null;
		for (Iterator<CrmPromotionEnquiry> itr = enquiries.iterator(); itr.hasNext(); ) {
			iEnquiry = itr.next();
			iEnquiry.setCrmEnabled(0);
		}
    	if (crmEnquirys != null && crmEnquirys.length > 0) {
	    	if (crmPromotion.getCrmPromotionEnquiries() == null) {
	    		crmPromotion.setCrmPromotionEnquiries(new LinkedHashSet<CrmPromotionEnquiry>(0));
	    	}
	    	CrmPromotionEnquiry crmPromotionEnquiry = null;
	    	CrmPromotionEnquiryId crmPromotionEnquiryId = null;
	    	String enquiry = null;
	    	String phone = null;
	    	boolean modelIsExist = false;
	    	
	    	for (int i = 0; i < crmEnquirys.length; i++) {
	    		enquiry = crmEnquirys[i];
	    		phone = crmPhones[i];
	    		modelIsExist = false;
	    		
	    		if (enquiry != null) {
	    			crmPromotionEnquiry = new CrmPromotionEnquiry();
	    			crmPromotionEnquiryId = new CrmPromotionEnquiryId();
	    			crmPromotionEnquiryId.setCrmEventId(coEventID_DB);
	    			crmPromotionEnquiryId.setCrmSiteCode(SITE_CODE);
	    			crmPromotionEnquiryId.setCrmModuleCode(MODULE_CODE);
	    			crmPromotionEnquiryId.setCrmPromoEnqPid(new BigDecimal(i + 1));
	    			
	    			for (Iterator<CrmPromotionEnquiry> itr = enquiries.iterator(); itr.hasNext(); ) {
	    				iEnquiry = itr.next();
	    				
	    				if (crmPromotionEnquiryId.equals(iEnquiry.getId())) {
	    					crmPromotionEnquiry = iEnquiry;
	    					modelIsExist = true;
	    				}
	    			}
	    			
	    			if (crmPromotionEnquiry == null) {
	    				crmPromotionEnquiry = new CrmPromotionEnquiry();
	    				crmPromotionEnquiry.setCrmCreatedDate(new Date());
	    				crmPromotionEnquiry.setCrmCreatedUser(userBean.getLoginID());
	    			}
	    			crmPromotionEnquiry.setId(crmPromotionEnquiryId);
	    			crmPromotionEnquiry.setCrmEnquiry(TextUtil.parseStrUTF8(enquiry));
	    			crmPromotionEnquiry.setCrmPhone(TextUtil.parseStrUTF8(phone));
	    			crmPromotionEnquiry.setCrmModifiedDate(new Date());
	    			crmPromotionEnquiry.setCrmModifiedUser(userBean.getLoginID());
	    			crmPromotionEnquiry.setCrmEnabled(1);
	    			
	    			if (!modelIsExist) {
	    				enquiries.add(crmPromotionEnquiry);
	    			}
	    		}
	    	}
    	}
    	
    	return coEvent;
    }
    
    private void processUploadedDocument(HttpServletRequest request, CoEventId id, String moduleCode, UserBean userBean) {
		String[] fileList = (String[]) request.getAttribute("filelist");
		String[] removeDocumentIds = (String[]) request.getAttribute("removeDocumentId[]_StringArray");
    	String[] filePromotionDetails = (String[]) request.getAttribute("filePromotionDetail_StringArray");
    	String[] filePromotionMaterials = (String[]) request.getAttribute("filePromotionMaterials_StringArray");
    	
    	// delete removed documents
    	if (removeDocumentIds != null && removeDocumentIds.length > 0) {
    		CrmPromotionDocumentId crmPromotionDocumentId = new CrmPromotionDocumentId();
    		crmPromotionDocumentId.setCrmSiteCode(SITE_CODE);
    		crmPromotionDocumentId.setCrmModuleCode(MODULE_CODE);
    		crmPromotionDocumentId.setCrmEventId(id.getCoEventId());
    		for (String documentID : removeDocumentIds) {
    			crmPromotionDocumentId.setCrmDocumentId(new BigDecimal(documentID));
    			
    			CRMPromotionDB2.deleteDocument(userBean, crmPromotionDocumentId);
    			DocumentDB.delete(SITE_CODE, userBean, MODULE_CODE, id.getCoEventId().toString(), documentID);
    		}
    	}
    	
    	// add upload documents
		if (fileList != null) {
			String uploadUrl = ConstantsServerSide.UPLOAD_FOLDER;
			String webBaseUrl = ConstantsServerSide.DOCUMENT_FOLDER + WEB_PATH;
			String webUrl = null;
			String documentID = null;
			if (filePromotionDetails != null) {
				for (int i = 0; i < filePromotionDetails.length; i++) {
					// add record to CO_DOCUMENT_GENERAL
					documentID = DocumentDB.add(SITE_CODE, userBean, moduleCode, id.getCoEventId().toString(), WEB_PATH, true, File.separator, filePromotionDetails[i]);
					
					// move uploaded file
					webUrl = webBaseUrl + File.separator + documentID;
					FileUtil.moveFile(
						uploadUrl + File.separator + filePromotionDetails[i],
						webUrl + File.separator + filePromotionDetails[i]
					);
					
					// add CRM_PROMOTION_DOCUMENT
					CRMPromotionDB2.addCrmPromotionDocument(id, new BigDecimal(documentID), CRM_DOCUMENT_TYPE_DETAILS, userBean);
				}
			}
			
			if (filePromotionMaterials != null) {
				for (int i = 0; i < filePromotionMaterials.length; i++) {
					// add record to CO_DOCUMENT_GENERAL
					documentID = DocumentDB.add(SITE_CODE, userBean, moduleCode, id.getCoEventId().toString(), WEB_PATH, true, File.separator, filePromotionMaterials[i]);
					
					// move uploaded file
					webUrl = webBaseUrl + File.separator + documentID;
					FileUtil.moveFile(
						uploadUrl + File.separator + filePromotionMaterials[i],
						webUrl + File.separator + filePromotionMaterials[i]
					);
					
					// add CRM_PROMOTION_DOCUMENT
					CRMPromotionDB2.addCrmPromotionDocument(id, new BigDecimal(documentID), CRM_DOCUMENT_TYPE_MATERIALS, userBean);
				}
			}
		}
    }
    
    private ModelAndView getTargetList(HttpServletRequest request, HttpServletResponse response) {
    	UserBean userBean = new UserBean(request);
    	HttpSession session = request.getSession();
    	
    	String moduleCode = ParserUtil.getParameter(request, "moduleCode");
    	String command = ParserUtil.getParameter(request, "cmd");
    	String targetID = ParserUtil.getParameter(request, "targetID");
    	
    	String message = request.getParameter("message");
    	String errorMessage = request.getParameter("errorMessage");

    	List<CrmTarget> crmTarget = null;
    	try {
    		crmTarget = CRMPromotionDB2.getCrmTargetList();
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    	
    	if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
    	if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
    	
    	Map<String, Object> model = new HashMap<String, Object>();
    	model.put("message", message);
    	model.put("errorMessage", errorMessage);
    	
    	model.put("moduleCode", moduleCode);
    	model.put("command", command);
    	model.put("userBean", userBean);
    	model.put("list", crmTarget);
    	
    	return new ModelAndView(VIEW_TARGET_LIST, MODULE_CODE, model);
    }
    
    private ModelAndView getTargetDetail(HttpServletRequest request, HttpServletResponse response) {
    	if (HttpFileUpload.isMultipartContent(request)){
    		HttpFileUpload.toUploadFolder(
    			request,
    			ConstantsServerSide.DOCUMENT_FOLDER,
    			ConstantsServerSide.TEMP_FOLDER,
    			ConstantsServerSide.UPLOAD_FOLDER,
    			"UTF-8"
    		);
    	}
    	
    	UserBean userBean = new UserBean(request);
    	HttpSession session = request.getSession();
    	
    	String command = ParserUtil.getParameter(request, "command");
    	String targetID = ParserUtil.getParameter(request, "targetID");
    	String step = ParserUtil.getParameter(request, "step");
    	
    	String message = request.getParameter("message");
    	String errorMessage = request.getParameter("errorMessage");

    	BigDecimal crmTargetId_BD = null;
    	try {
    		crmTargetId_BD = new BigDecimal(targetID);
    	} catch (Exception e) {
    		crmTargetId_BD = new BigDecimal(-1);
    	}
    	
    	CrmTarget crmTarget = null;
    	
    	boolean createAction = false;
    	boolean updateAction = false;
    	boolean deleteAction = false;
    	boolean closeAction = false;

    	if ("create".equals(command)) {
    		createAction = true;
    	} else if ("update".equals(command)) {
    		updateAction = true;
    	} else if ("delete".equals(command)) {
    		deleteAction = true;
    	}
    	
    	try {
    		if ("1".equals(step)) {
    			if (!createAction) {
    				crmTarget = CRMPromotionDB2.getCrmTarget(crmTargetId_BD);
    			}
    			
    			if (createAction) {
    				boolean createSuccess = false;
    				
        			// construct target object
    				crmTarget = constructCrmTargetObject(request, crmTarget);
    		    	
    				createSuccess = CRMPromotionDB2.add(crmTarget);
    				crmTargetId_BD = crmTarget.getCrmTargetId();
    				
    				if(createSuccess) {
    					message = MessageResources.getMessage(session, "message.target.createSuccess");
    				} else {
    					errorMessage = MessageResources.getMessage(session, "message.target.createFail");
    				}
    				
    				createAction = false;
    			} else if (updateAction) {
    				boolean updateSuccess = false;
    				
        			// construct promotion object
    				crmTarget = constructCrmTargetObject(request, crmTarget);
    				
    				updateSuccess = CRMPromotionDB2.update(crmTarget);
    				
    				if(updateSuccess) {
    					message = MessageResources.getMessage(session, "message.target.updateSuccess");
    				} else {
    					errorMessage = MessageResources.getMessage(session, "message.target.updateFail");
    				}
    				
    				updateAction = false;	
    			} else if (deleteAction) {
    				boolean deleteSuccess = false;
    				
    				deleteSuccess = CRMPromotionDB2.delete(userBean, crmTarget);
    				if(deleteSuccess) {
    					message = MessageResources.getMessage(session, "message.target.deleteSuccess");
    				} else {
    					errorMessage = MessageResources.getMessage(session, "message.target.deleteFail");
    				}
    				
    				deleteAction = false;	
    			}
    			step = null;
    		}
    		
    		//------------------------
    		// load data from database
    		//------------------------
    		if (!createAction && !"1".equals(step)) {
    			crmTarget = CRMPromotionDB2.getCrmTarget(crmTargetId_BD);
    		}
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    	
    	// ui logic
    	String commandType = null;
    	String title = "";
    	if (createAction) {
    		commandType = "create";
    	} else if (updateAction) {
    		commandType = "update";
    	} else if (deleteAction) {
    		commandType = "delete";
    	} else {
    		commandType = "view";
    	}
    	// set submit label
    	title = "function.event.target." + commandType;
    	
    	String allowRemove = updateAction ? ConstantsVariable.YES_VALUE : ConstantsVariable.NO_VALUE;
    	
    	if (message == null) { message = ConstantsVariable.EMPTY_VALUE; }
    	if (errorMessage == null) { errorMessage = ConstantsVariable.EMPTY_VALUE; }
    	
    	Map<String, Object> model = new HashMap<String, Object>();
    	model.put("message", message);
    	model.put("errorMessage", errorMessage);
    	model.put("commandType", commandType);
    	model.put("createAction", createAction);
    	model.put("updateAction", updateAction);
    	model.put("deleteAction", deleteAction);
    	model.put("closeAction", closeAction);
    	model.put("allowRemove", allowRemove);
    	
    	model.put("moduleCode", MODULE_CODE);
    	model.put("title", title);
    	
    	model.put("userBean", userBean);
    	model.put("crmTarget", crmTarget);
    	
    	return new ModelAndView(VIEW_TARGET_DETAIL, MODULE_CODE, model);
    }
    
    private CrmTarget constructCrmTargetObject(HttpServletRequest request, CrmTarget crmTarget) {
    	boolean crmTargetIsExist;
    	UserBean userBean = new UserBean(request);
    	
    	String targetID = ParserUtil.getParameter(request, "targetID");
    	String crmTargetCode = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "crmTargetCode"));
    	String crmTargetName = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "crmTargetName"));
    	String crmTargetDescription = TextUtil.parseStrUTF8(ParserUtil.getParameter(request, "crmTargetDescription"));
    	
    	BigDecimal crmTargetId_BD = null;
    	try {
    		crmTargetId_BD = new BigDecimal(targetID);
    	} catch (Exception e) {
    	}
    	Date now = new Date();
    	
    	// crmTarget
    	if (crmTarget == null) {
    		crmTarget = new CrmTarget();
    		crmTargetIsExist = false;
    	} else {
    		crmTargetIsExist = true;
    	}
    	crmTarget.setCrmTargetId(crmTargetId_BD);
    	
    	if (!crmTargetIsExist) {
    		crmTarget.setCrmCreatedDate(now);
    		crmTarget.setCrmCreatedUser(userBean.getLoginID());
    		crmTarget.setCrmEnabled(1);
    	}
    	
    	crmTarget.setCrmTargetCode(crmTargetCode);
    	crmTarget.setCrmTargetName(crmTargetName);
    	crmTarget.setCrmTargetDescription(crmTargetDescription);
    	crmTarget.setCrmModifiedDate(now);
    	crmTarget.setCrmModifiedUser(userBean.getLoginID());
    	
    	return crmTarget;
    }
}
