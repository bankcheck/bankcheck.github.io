package com.hkah.web.db.helper;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.hkah.web.db.hibernate.CoDocscan;

public class DocscanModelHelper {
	protected final Log logger = LogFactory.getLog(getClass());
	
	public static String MODULE_CODE = "doc_scanning";
	
	public static List<CoDocscan> constructCoDocscanTree(List<CoDocscan> coDocscanList) {
		return constructCoDocscanTree(coDocscanList, null);
	}
	
	/**
	 * 
	 * @param coDocscanList
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static List<CoDocscan> constructCoDocscanTree(List<CoDocscan> coDocscanList, BigDecimal coDocscanId) {
		List<CoDocscan> parentLvlList = new ArrayList<CoDocscan>();
		List<CoDocscan> childLvlList = new ArrayList<CoDocscan>();
		
		// Step 1, get a list of top level parent
		CoDocscan content = null;
		for (int i = 0; i < coDocscanList.size(); i++) {
			content = coDocscanList.get(i);
			if (content != null) {
				if ((content.getCoParentCoDocscanId() == null && coDocscanId == null) ||
						(coDocscanId != null && coDocscanId.equals(content.getCoParentCoDocscanId()))) {
					parentLvlList.add(content);
				} else {
					childLvlList.add(content);
				}
			}
		}
		
		// sort childLvlList by parent ID (Important!)
		Collections.sort(childLvlList, new Comparator<CoDocscan>() {
			@Override
			public int compare(CoDocscan o1, CoDocscan o2) {
				// TODO Auto-generated method stub
				BigDecimal pid1 = o1.getCoParentCoDocscanId();
				BigDecimal pid2 = o2.getCoParentCoDocscanId();
				return (pid1 == null ? 0 : pid1.intValue()) - (pid2 == null ? 0 : pid2.intValue());
			}
		});
		
		// Step 2, add child to their parent
		for (int i = 0; i < childLvlList.size(); i++) {
			wrapCoDocscanChild(parentLvlList, childLvlList.get(i), 0);
		}
		
		return parentLvlList;
	}
	
	private static void wrapCoDocscanChild(List<CoDocscan> coDocscanList, 
			CoDocscan content, int debug_level) {
		if (coDocscanList == null || content == null) {
			return;
		}
		
		BigDecimal id = null;
		if (content != null && content.getCoParentCoDocscanId() != null) {
			id = content.getCoParentCoDocscanId();
			
			CoDocscan parent = null;
			List<CoDocscan> childList = null;
			boolean isFound = false;
			// Find content's parent and wrap it in 
			for (int i = 0; i < coDocscanList.size() && !isFound; i++) {
				parent = coDocscanList.get(i);
				if (parent != null) {
					childList = parent.getChildList();
					
					if (id.compareTo(parent.getId().getCoDocscanId()) == 0) {
						// Parent matched
						if (childList == null) {
							childList = new ArrayList<CoDocscan>();
						}
						childList.add(content);
						parent.setChildList(childList);
						isFound = true;
					} else {
						// Parent not matched, recursive to find the immediate parent until deepest level is reached
						wrapCoDocscanChild(childList, content, debug_level+1);
					}
				}
			}
			
			if (isFound) {
				boolean removeSuccess = coDocscanList.remove(content);
			}
		}
	}
	
	/**
	 * Prints out the tree structure of CoDocscan.
	 * For debug only.
	 * 
	 * @param coDocscanList
	 * @param debugLvl
	 */
	public void printCoDocscanTree(List<CoDocscan> coDocscanList, int debugLvl) {
		if(coDocscanList == null || coDocscanList.isEmpty()) {
			return;
		}
		
		List<CoDocscan> childLvlList = null;
		CoDocscan content = null;
		
		for (int i = 0; i < coDocscanList.size(); i++) {
			content = coDocscanList.get(i);
			childLvlList = content.getChildList();
			this.printCoDocscanTree(content.getChildList(), debugLvl + 1);
		}
		
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
