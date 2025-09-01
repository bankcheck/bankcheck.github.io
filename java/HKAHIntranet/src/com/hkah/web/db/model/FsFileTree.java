package com.hkah.web.db.model;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

public class FsFileTree {
	private List<FsFileTree> fsFileTree = new ArrayList<FsFileTree>();
	private BigDecimal fsCategoryId;
	private FsFileIndex fsFileIndex;
	private String displayTitle;
	
	public BigDecimal getFsCategoryId() {
		return fsCategoryId;
	}
	public void setFsCategoryId(BigDecimal fsCategoryId) {
		this.fsCategoryId = fsCategoryId;
	}
	public String getDisplayTitle() {
		return displayTitle;
	}
	public void setDisplayTitle(String displayTitle) {
		this.displayTitle = displayTitle;
	}
	public List<FsFileTree> getFsFileTree() {
		return fsFileTree;
	}
	public void setFsFileIndexes(List<FsFileTree> fsFileTree) {
		this.fsFileTree = fsFileTree;
	}
	public FsFileIndex getFsFileIndex() {
		return fsFileIndex;
	}
	public void setFsFileIndex(FsFileIndex fsFileIndex) {
		this.fsFileIndex = fsFileIndex;
	}
}
