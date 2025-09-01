package com.hkah.web.db.model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

import com.hkah.constant.ConstantsServerSide;
import com.hkah.constant.ConstantsVariable;
import com.hkah.web.db.helper.FsModelHelper;

public class FsCategory implements Cloneable {
	protected BigDecimal fsCategoryId;
	protected String fsName;
	protected BigDecimal fsParentCategoryId;
	protected String fsSeq;
	protected String fsIsMulti;
	protected FsFileProfile fsFileProfile;
	protected List<FsCategory> childList = new ArrayList<FsCategory>();
	
	// associated file
	protected List<FsFileIndex> fsFileIndexes = new ArrayList<FsFileIndex>();
	
	public FsCategory() {
		super();
	}
	
	public static FsCategory newInstance(FsCategory aFsCategory) {
		return new FsCategory(aFsCategory.fsCategoryId, aFsCategory.fsName,
				aFsCategory.fsParentCategoryId, aFsCategory.fsSeq, aFsCategory.fsIsMulti, 
				aFsCategory.fsFileProfile, aFsCategory.childList, aFsCategory.fsFileIndexes);
	}

	public FsCategory(BigDecimal fsCategoryId, String fsName,
			BigDecimal fsParentCategoryId, String fsSeq, String fsIsMulti) {
		super();
		this.fsCategoryId = fsCategoryId;
		this.fsName = fsName;
		this.fsParentCategoryId = fsParentCategoryId;
		this.fsSeq = fsSeq;
		this.fsIsMulti = fsIsMulti;
	}

	public FsCategory(BigDecimal fsCategoryId, String fsName,
			BigDecimal fsParentCategoryId, String fsSeq, String fsIsMulti,
			FsFileProfile fsFileProfile, List<FsCategory> childList,
			List<FsFileIndex> fsFileIndexes) {
		super();
		this.fsCategoryId = fsCategoryId;
		this.fsName = fsName;
		this.fsParentCategoryId = fsParentCategoryId;
		this.fsSeq = fsSeq;
		this.fsIsMulti = fsIsMulti;
		this.fsFileProfile = fsFileProfile;
		this.childList = childList;
		this.fsFileIndexes = fsFileIndexes;
	}

	public BigDecimal getFsCategoryId() {
		return fsCategoryId;
	}
	
	public String getFsCategoryId_String() {
		if (this.getFsCategoryId() != null) {
			return this.getFsCategoryId().toString();
		} else {
			return null;
		}
	}

	public void setFsCategoryId(BigDecimal fsCategoryId) {
		this.fsCategoryId = fsCategoryId;
	}

	public String getFsName() {
		return fsName;
	}

	public void setFsName(String fsName) {
		this.fsName = fsName;
	}

	public BigDecimal getFsParentCategoryId() {
		return fsParentCategoryId;
	}	
	
	public String getFsParentCategoryId_String() {
		if (this.getFsParentCategoryId() != null) {
			return this.getFsParentCategoryId().toString();
		} else {
			return null;
		}
	}

	public void setFsParentCategoryId(BigDecimal fsParentCategoryId) {
		this.fsParentCategoryId = fsParentCategoryId;
	}

	public String getFsSeq() {
		return fsSeq;
	}

	public void setFsSeq(String fsSeq) {
		this.fsSeq = fsSeq;
	}

	public List<FsCategory> getChildList() {
		return childList;
	}

	public void setChildList(List<FsCategory> childList) {
		this.childList = childList;
	}
	
	public boolean appendChildCat(FsCategory fsCategory) {
		try {
			List<FsCategory> list = this.getChildList();
			if (list == null) {
				list = new ArrayList<FsCategory>();
			}
			list.add(fsCategory);
			return true;
		} catch (Exception e) {
			return false;
		}
	}
	
	
	public boolean isUnderOP() {
		boolean ret = false;
		List<FsCategory> ancestors = FsModelHelper.getCategoryAncestors(this);
		for (int i = 0; i < ancestors.size(); i++) {
			FsCategory ancestor = ancestors.get(i);
			if (ConstantsServerSide.isHKAH() && FsModelHelper.HKAH_OP_CAT_ID.equals(ancestor.getFsCategoryId()) ||
					ConstantsServerSide.isTWAH() && FsModelHelper.TWAH_OP_CAT_ID.equals(ancestor.getFsCategoryId())) {
				ret = true;
			}
		}
		return ret;
	}
	
	public boolean isUnderLab() {
		boolean ret = false;
		List<FsCategory> ancestors = FsModelHelper.getCategoryAncestors(this);
		for (int i = 0; i < ancestors.size(); i++) {
			FsCategory ancestor = ancestors.get(i);
			if (ConstantsServerSide.isHKAH() && FsModelHelper.HKAH_LABPATH_CAT_ID.equals(ancestor.getFsCategoryId())) {
				ret = true;
			}
		}
		return ret;
	}
	
	public boolean isOpConsTreat() {
		boolean ret = false;
		if (FsModelHelper.HKAH_OP_CONS_TREAT_CAT_ID.equals(this.getFsCategoryId())) {
			ret = true;
		}
		return ret;
	}
	
	public boolean isOpMisc() {
		boolean ret = false;
		if (FsModelHelper.HKAH_OP_MISC_CAT_ID.equals(this.getFsCategoryId())) {
			ret = true;
		}
		return ret;
	}
	
	public boolean isRptLb() {
		boolean ret = false;
		if (FsModelHelper.HKAH_RPT_LP_CAT_ID.equals(this.getFsCategoryId())) {
			ret = true;
		}
		return ret;
	}
	
	public boolean isOncology() {
		boolean ret = false;
		if (FsModelHelper.HKAH_ONCOLOGY_CAT_ID.equals(this.getFsCategoryId())) {
			ret = true;
		}
		return ret;
	}

	public String getFsIsMulti() {
		return fsIsMulti;
	}

	public void setFsIsMulti(String fsIsMulti) {
		this.fsIsMulti = fsIsMulti;
	}

	public List<FsFileIndex> getFsFileIndexes() {
		return fsFileIndexes;
	}

	public void setFsFileIndexes(List<FsFileIndex> fsFileIndexes) {
		this.fsFileIndexes = fsFileIndexes;
	}
	
	public boolean appendFileIndex(FsFileIndex fsFileIndex) {
		try {
			List<FsFileIndex> list = this.getFsFileIndexes();
			if (list == null) {
				list = new ArrayList<FsFileIndex>();
			}
			list.add(fsFileIndex);
			return true;
		} catch (Exception e) {
			return false;
		}
	}
	
	public boolean isDyna() {
		if (ConstantsVariable.YES_VALUE.equals(getFsIsMulti())) {
			return true;
		} else {
			return false;
		}
	}
	
	public boolean isUnderDyna() {
		boolean ret = false;
		List<FsCategory> ancestors = FsModelHelper.getCategoryAncestors(this);
		for (int i = 0; i < ancestors.size(); i++) {
			FsCategory ancestor = ancestors.get(i);
			if (ConstantsVariable.YES_VALUE.equals(ancestor.getFsIsMulti())) {
				ret = true;
			}
		}
		return ret;
	}
	
	public boolean isUnderInPat() {
		boolean ret = false;
		List<FsCategory> ancestors = FsModelHelper.getCategoryAncestors(this);
		for (int i = 0; i < ancestors.size(); i++) {
			FsCategory ancestor = ancestors.get(i);
			if (ConstantsServerSide.isHKAH() && FsModelHelper.HKAH_IP_CAT_ID.equals(ancestor.getFsCategoryId()) ||
					ConstantsServerSide.isTWAH() && FsModelHelper.TWAH_IP_CAT_ID.equals(ancestor.getFsCategoryId())) {
				ret = true;
			}
		}
		return ret;
	}
	
	public FsCategory setValues(FsCategory fsCategory) {
		fsCategory.setFsCategoryId(this.fsCategoryId);
		fsCategory.setFsName(this.fsName);
		fsCategory.setFsSeq(this.fsSeq);
		fsCategory.setFsIsMulti(this.fsIsMulti);
		fsCategory.setFsParentCategoryId(this.fsParentCategoryId);
		if (this.childList != null) {
			List<FsCategory> newChildList = new ArrayList<FsCategory>();
				for (int i = 0; i < this.childList.size(); i++) {
					FsCategory child = this.childList.get(i);
					try {
						newChildList.add((FsCategory) child.clone());
					} catch (CloneNotSupportedException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			
			//Collections.copy(newChildList, this.childList);
			fsCategory.setChildList(newChildList);
		}
		if (this.fsFileIndexes != null) {
			fsCategory.setFsFileIndexes(fsCategory.getFsFileIndexes());
		}
		
		return fsCategory;
	}
	
	public Object clone() throws CloneNotSupportedException {
		FsCategory c = (FsCategory) super.clone();
		if (this.childList != null)
			c.childList = (List<FsCategory>) ((ArrayList<FsCategory>) this.childList).clone();
		if (this.fsFileIndexes != null)
			c.fsFileIndexes = (List<FsFileIndex>) ((ArrayList<FsFileIndex>) this.fsFileIndexes).clone();
		
		return c;
	}
}
