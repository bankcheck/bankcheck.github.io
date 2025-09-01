package com.hkah.web.db.helper;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.hkah.constant.ConstantsVariable;
import com.hkah.web.controller.StaffEducationController;
import com.hkah.web.db.hibernate.EeMenuContent;

public class StaffEducationModelHelper {
	protected final Log logger = LogFactory.getLog(getClass());
	
	public static final String EE_DOCUMENT_TYPE_SITIN = "sitin";
	public static final String EE_DOCUMENT_TYPE_ONLINE = "online";
	public static final String EE_DOCUMENT_TYPE_DESC = "desc";
	public static final String EE_DOCUMENT_TYPE_VIDEO = "video";
	public static final String EE_DOCUMENT_TYPE_SLIDE = "slide";
	
	public static final Map<String, String> eeInserviceContentLevel0TypeMap = new LinkedHashMap<String, String>();
	public static final Map<String, String> eeInserviceContentLevel1TypeMap = new LinkedHashMap<String, String>();
	
	static {
		eeInserviceContentLevel0TypeMap.put(EE_DOCUMENT_TYPE_SITIN, "Sit-in");
		eeInserviceContentLevel0TypeMap.put(EE_DOCUMENT_TYPE_ONLINE, "Online");
		
		eeInserviceContentLevel1TypeMap.put(EE_DOCUMENT_TYPE_DESC, "Detailed Description");
		eeInserviceContentLevel1TypeMap.put(EE_DOCUMENT_TYPE_VIDEO, "Video");
		eeInserviceContentLevel1TypeMap.put(EE_DOCUMENT_TYPE_SLIDE, "Powerppt");
	}
	
	public static Map<String, String> getEeTypes(String moduleCode, String level) {
		if (StaffEducationController.MODULE_CODE_INSERVICE_CONTENT.equals(moduleCode)) {
			if (ConstantsVariable.ZERO_VALUE.equals(level)) {
				return eeInserviceContentLevel0TypeMap;
			} else if (ConstantsVariable.ONE_VALUE.equals(level)) {
				return eeInserviceContentLevel1TypeMap;
			}
		}
		return new LinkedHashMap<String, String>();
	}
	
	public static List<EeMenuContent> constructEeMenuContentTree(List<EeMenuContent> eeMenuContentList) {
		return constructEeMenuContentTree(eeMenuContentList, null);
	}
	
	/**
	 * 
	 * @param eeMenuContentList
	 * @return
	 */
	public static List<EeMenuContent> constructEeMenuContentTree(List<EeMenuContent> eeMenuContentList, BigDecimal eeParentMenuContentId) {
		List<EeMenuContent> parentLvlList = new ArrayList<EeMenuContent>();
		List<EeMenuContent> childLvlList = new ArrayList<EeMenuContent>();
		
		// Step 1, get a list of top level parent
		EeMenuContent content = null;
		for (int i = 0; i < eeMenuContentList.size(); i++) {
			content = eeMenuContentList.get(i);
			if (content != null) {
				if ((content.getEeParentMenuContentId() == null && eeParentMenuContentId == null) ||
						(eeParentMenuContentId != null && eeParentMenuContentId.equals(content.getEeParentMenuContentId()))) {
					parentLvlList.add(content);
				} else {
					childLvlList.add(content);
				}
			}
		}
		
		// Step 2, add child to their parent
		for (int i = 0; i < childLvlList.size(); i++) {
			wrapEeMenuContentChild(parentLvlList, childLvlList.get(i), 0);
		}
		
		return parentLvlList;
	}
	
	private static void wrapEeMenuContentChild(List<EeMenuContent> eeMenuContentList, 
			EeMenuContent content, int debug_level) {
		if (eeMenuContentList == null || content == null) {
			return;
		}
		
		BigDecimal id = null;
		if (content != null && content.getEeParentMenuContentId() != null) {
			id = content.getEeParentMenuContentId();
			
			EeMenuContent parent = null;
			List<EeMenuContent> childList = null;
			boolean isFound = false;
			// Find content's parent and wrap it in 
			for (int i = 0; i < eeMenuContentList.size() && !isFound; i++) {
				parent = eeMenuContentList.get(i);
				if (parent != null) {
					childList = parent.getChildList();
					
					if (id.compareTo(parent.getId().getEeMenuContentId()) == 0) {
						// Parent matched
						if (childList == null) {
							childList = new ArrayList<EeMenuContent>();
						}
						childList.add(content);
						parent.setChildList(childList);
						isFound = true;
					} else {
						// Parent not matched, recursive to find the immediate parent until deepest level is reached
						wrapEeMenuContentChild(childList, content, debug_level++);
					}
				}
			}
			
			if (isFound) {
				boolean removeSuccess = eeMenuContentList.remove(content);
			}
		}
	}
	
	/**
	 * Prints out the tree structure of EeMenuContent.
	 * For debug only.
	 * 
	 * @param eeMenuContentList
	 * @param debugLvl
	 */
	public void printEeMenuContentTree(List<EeMenuContent> eeMenuContentList, int debugLvl) {
		if(eeMenuContentList == null || eeMenuContentList.isEmpty()) {
			return;
		}
		
		List<EeMenuContent> childLvlList = null;
		EeMenuContent content = null;
		
		for (int i = 0; i < eeMenuContentList.size(); i++) {
			content = eeMenuContentList.get(i);
			childLvlList = content.getChildList();
			this.printEeMenuContentTree(content.getChildList(), debugLvl + 1);
		}
		
	}
	
	public static EeMenuContent constructEeMenuContentTreeForInserviceContent(EeMenuContent eeMenuContent) {
		if (eeMenuContent == null) {
			return null;
		}
		
		List<EeMenuContent> children = eeMenuContent.getChildList();
		
		if (children != null && !children.isEmpty()) {
			EeMenuContent content = null;
			Iterator<EeMenuContent> itr = children.iterator();
			List<EeMenuContent> list = null;
			while (itr.hasNext()) {
				content = itr.next();
					
				if (content != null) {
					// split content details into
					// 1) description
					// 2) video
					// 3) powerpoint slides
					if (EE_DOCUMENT_TYPE_DESC.equals(content.getEeType())) {
						list = eeMenuContent.getInserviceContentDescriptionList();
					} else if (EE_DOCUMENT_TYPE_VIDEO.equals(content.getEeType())) {
						list = eeMenuContent.getInserviceContentVideoList();
					} else if (EE_DOCUMENT_TYPE_SLIDE.equals(content.getEeType())) {
						list = eeMenuContent.getInserviceContentSlidesList();
					}
					
					if (list == null) {
						list = new ArrayList<EeMenuContent>();
					}
					
					list.add(content);
				}
				list = null;
			}
		}
		return eeMenuContent;
	}
	
	public static int getMaxNoOfVideoAndSlideList(EeMenuContent eeMenuContent) {
		if (eeMenuContent == null) {
			return 0;
		}
		
		int noOfVideo = eeMenuContent.getInserviceContentVideoList() == null ? 0 : eeMenuContent.getInserviceContentVideoList().size();
		int noOfSlide = eeMenuContent.getInserviceContentSlidesList() == null ? 0 : eeMenuContent.getInserviceContentSlidesList().size();
		
		return Math.max(noOfVideo, noOfSlide);
	}
	
	public static String[] removeFirstElement(String[] rowItems) {
		if (rowItems == null) {
			return null;
		}
		
		String[] newArray = new String[rowItems.length - 1];
		for (int i = 0; i < rowItems.length; i++) { 
			if (i != 0) {
				newArray[i - 1] = rowItems[i];
			}
		}
		
		return newArray;
	}
}
