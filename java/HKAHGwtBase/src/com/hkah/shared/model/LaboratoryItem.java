package com.hkah.shared.model;

import com.extjs.gxt.ui.client.data.BaseModel;

public class LaboratoryItem extends BaseModel {
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public LaboratoryItem() {
	}

	public LaboratoryItem(String name,String desc,String type) {
		set("name",name);
		set("desc",desc);
		set("type",type);
	}
	public String getType(){
		return get("type");
	}
	public String getName() {
		return get("name");
	}

	public String getDesc() {
		return get("desc");
	}
	public String getDisplayName(){
		return get("displayName");
	}
	public void setDisplayName(String displayName){
		set("displayName",displayName);
	}
	public String toString() {
		return getName();
	}
}